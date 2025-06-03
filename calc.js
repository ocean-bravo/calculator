.pragma library

.import "big.mjs" as BigJS

var Big = BigJS.Big;


function infixToPostfix(expression) {
    // Удаляем пробелы для упрощения обработки
    const expr = expression.replace(/\s+/g, '');
    const tokens = [];
    let current = '';

    // Токенизация: разделяем на числа, операторы и скобки
    for (let i = 0; i < expr.length; i++) {
        const char = expr[i];

        // Если символ - цифра или точка, добавляем в текущее число
        if (/[\d.]/.test(char)) {
            current += char;
        }
        // Если символ - оператор или скобка
        else {
            // Добавляем собранное число (если есть)
            if (current) {
                tokens.push(current);
                current = '';
            }

            // Обработка унарного минуса:
            // - Первый токен
            // - После открывающей скобки
            // - После другого оператора
            if (char === '-' && (
                        tokens.length === 0 ||
                        /[+\-*/(]/.test(tokens[tokens.length - 1])
                        )) {
                tokens.push('u-');
            } else {
                tokens.push(char);
            }
        }
    }

    // Добавляем последнее число, если осталось
    if (current) tokens.push(current);

    const precedence = {
        'u-': 4,    // Унарный минус (высший приоритет)
        '*': 3,
        '/': 3,
        '+': 2,
        '-': 2
    };

    const output = [];
    const stack = [];

    for (const token of tokens) {
        // Числа сразу в выход
        if (!isNaN(parseFloat(token))) {
            output.push(token);
        }
        // Обработка операторов
        else if (token in precedence) {
            // Выталкиваем операторы с высшим или равным приоритетом
            while (stack.length > 0) {
                const top = stack[stack.length - 1];

                // Прерываем если:
                // - Встретили скобку
                // - Приоритет в стеке меньше
                if (top === '(') break;
                if (precedence[top] < precedence[token]) break;

                output.push(stack.pop());
            }
            stack.push(token);
        }
        // Открывающая скобка - в стек
        else if (token === '(') {
            stack.push(token);
        }
        // Закрывающая скобка - выталкиваем до открывающей
        else if (token === ')') {
            while (stack.length > 0 && stack[stack.length - 1] !== '(') {
                output.push(stack.pop());
            }
            stack.pop(); // Удаляем открывающую скобку
        }
    }

    // Выталкиваем оставшиеся операторы
    while (stack.length > 0) {
        output.push(stack.pop());
    }

    return output;
}


function calculatePostfix(tokens) {
    const stack = [];

    for (const token of tokens) {
        if (isUnaryOperator(token)) {
            // Унарная операция - нужен только один операнд
            if (stack.length < 1) {
                throw new Error(`Недостаточно операндов для унарной операции ${token}`)
            }

            const a = stack.pop();
            const result = performUnaryOperation(a, token)
            stack.push(result);
        }
        else if (isBinaryOperator(token)) {
            // Бинарная операция - нужны два операнда
            if (stack.length < 2) {
                throw new Error(`Недостаточно операндов для операции ${token}`)
            }

            // Извлекаем два операнда (порядок важен!)
            const b = stack.pop()
            const a = stack.pop()

            // Выполняем операцию и помещаем результат обратно в стек
            const result = performBinaryOperation(a, b, token)
            stack.push(result)
        }
        else {
            // Это число - конвертируем в Big и помещаем в стек
            try {
                const num = new Big(token);
                stack.push(num);
            } catch (error) {
                throw new Error(`Некорректное число: ${token}`)
            }
        }
    }

    // После обработки всех токенов в стеке должно остаться одно значение
    if (stack.length !== 1) {
        throw new Error('Некорректное выражение: неправильное количество операндов');
    }

    return stack[0];
}

function isUnaryOperator(token) {
    return token === 'u-'
}

function isBinaryOperator(token) {
    return ['+', '-', '*', '/', '%'].includes(token)
}

function performUnaryOperation(a, operator) {
    switch (operator) {
        case 'u-':
            return a.times(-1)
        default:
            throw new Error(`Неизвестная унарная операция: ${operator}`)
    }
}

function performBinaryOperation(a, b, operator) {
    switch (operator) {
        case '+':
            return a.plus(b)
        case '-':
            return a.minus(b)
        case '*':
            return a.times(b)
        case '/':
            if (b.eq(0)) {
                throw new Error('Деление на ноль')
            }
            return a.div(b)
        case '%':
            if (b.eq(0)) {
                throw new Error('Деление на ноль в операции остатка')
            }
            return a.mod(b)
        default:
            throw new Error(`Неизвестная операция: ${operator}`)
    }
}

function insertMultiplySignBeforBracket(expression) {
    // Регулярное выражение для поиска числа (целого или десятичного)
    // за которым следует открывающая скобка
    const pattern = /(\d+(?:\.\d+)?)\s*\(/g

    // Заменяем найденные совпадения, добавляя знак умножения
    return expression.replace(pattern, '$1*(')
}

function insertMultiplySignAfterBracket(expression) {
    // Регулярное выражение для поиска закрывающей скобки
    // за которой следует число (с возможным унарным минусом)
    const pattern = /\)\s*(-?\d+(?:\.\d+)?)/g

    // Заменяем найденные совпадения, добавляя знак умножения
    return expression.replace(pattern, ')*$1')
}
