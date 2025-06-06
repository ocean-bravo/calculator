import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "calc.js" as Calc

Item {
    id: root

    property string expression: ""
    property string currentInput: "0"
    property bool enterPasswordEnable: false  // разрешение вводить пароль
    readonly property string password: "123"  // пароль входа в секретное меню
    property string currentPassword: ""       // текущий пароль, который ввел пользователь


    component Rb : RoundButton {
        property color normalBgColor: colors.theme_1_4
        property color activeBgColor: colors.theme_1_3
        property color normalTextColor: colors.theme_1_1
        property color activeTextColor: colors.theme_1_6

        onPressed: {
            addTextToPasswordAndCheckIt(text)

            var res = parseInput(text)
            console.log(res.expression)
            // Замена знаков '*' и '/' на более приятные '×' и '÷'
            expression = res.expression.replace(/\//g, '÷').replace(/\*/g, '×')
            currentInput = res.display
        }

        font {
            family: fontOpenSansSemiBold.name
            weight: Font.DemiBold
            pixelSize: 24
            letterSpacing: 1
        }

        Component.onCompleted: {
            background.color = Qt.binding(() => (pressed || checked) ? activeBgColor : normalBgColor)
            contentItem.color = Qt.binding(() => pressed ? activeTextColor : normalTextColor)
        }

        Layout.preferredWidth: 60
        Layout.preferredHeight: 60
    }

    component DigitButton : Rb {
        normalBgColor: colors.theme_1_4
        activeBgColor: colors.theme_1_3
        normalTextColor: colors.theme_1_1
        activeTextColor: colors.theme_1_6
    }

    component OperationButton : Rb {
        normalBgColor: colors.theme_1_2
        activeBgColor: colors.theme_1_add_2
        normalTextColor: colors.theme_1_6
        activeTextColor: colors.theme_1_6

        icon.width: 30
        icon.height: 30
        icon.color: colors.theme_1_6

        display: AbstractButton.IconOnly
    }

    component CancelButton : Rb {
        text: "C";
        normalBgColor: colors.theme_1_5
        activeBgColor: colors.theme_1_5
        normalTextColor: colors.theme_1_6
        activeTextColor: colors.theme_1_6

        Component.onCompleted: {
            background.opacity = Qt.binding(() => pressed ? 1.0 : 0.5)
        }
    }

    component WhiteBg : Rectangle { // белая подложка, чтобы получался нужный цвет, когда кнопка поверх меняет прозрачность фона
        radius: 30
        Layout.preferredWidth: 60
        Layout.preferredHeight: 60
    }

    // Закрывает скругления следующего прямоугольника
    Rectangle {
        color: colors.theme_1_3
        width: parent.width
        height: 50
        anchors.top: parent.top
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 24

        Rectangle {
            id: resultBackgroud
            color: colors.theme_1_3
            radius: 30
            Layout.preferredHeight: 156
            Layout.fillWidth: true

            Item {
                width: 280
                height: 30
                anchors.top: parent.top
                anchors.topMargin: 45
                anchors.horizontalCenter: parent.horizontalCenter

                // Математическое выражение
                Text {
                    anchors.fill: parent
                    text: root.expression
                    color: colors.theme_1_6
                    horizontalAlignment: Text.AlignRight
                    lineHeight: 30
                    lineHeightMode: Text.FixedHeight

                    font {
                        family: fontOpenSansSemiBold.name
                        weight: Font.DemiBold
                        pixelSize: 20
                        letterSpacing: 0.5
                    }
                }
            }

            Rectangle {
                color: "transparent"
                //color: "yellow"

                width: 281
                height: 60
                anchors.top: parent.top
                anchors.topMargin: 77

                anchors.horizontalCenter: parent.horizontalCenter

                // Ввод пользователя или результат вычисления математического выражения
                Text {
                    id: result
                    anchors.fill: parent
                    text: root.currentInput
                    color: colors.theme_1_6
                    // Для уменьшения размера текста, чтобы он помещался в поле
                    fontSizeMode: Text.HorizontalFit
                    minimumPixelSize: 16
                    // чтобы число при максимальном умешньшении шрифта начало переноситься на другую строку
                    wrapMode: Text.WrapAnywhere

                    horizontalAlignment: Text.AlignRight

                    font {
                        family: fontOpenSansSemiBold.name
                        weight: Font.DemiBold
                        pixelSize: 50
                        letterSpacing: 0.5
                    }
                }
            }
        }

        Item {
            id: numpad

            Layout.preferredHeight: 396
            Layout.fillWidth: true

            GridLayout {
                rows: 5
                columns: 6
                columnSpacing: 24
                rowSpacing: 24
                anchors.fill: parent

                Item {Layout.fillWidth: true; height: 10; Layout.column: 0;  Layout.row: 0; Layout.rowSpan: 5; } // Распорка

                OperationButton { text: ""; icon.source: "signs/bkt.svg"; checkable: true;

                    onCheckedChanged: {
                        var res = parseInput(checked ? '(' : ')')
                        // Замена знаков '*' и '/' на более приятные '×' и '÷'
                        expression = res.expression.replace(/\//g, '÷').replace(/\*/g, '×')
                        display = res.display
                    }
                }

                OperationButton { text: "±";  icon.source: "signs/plus_minus.svg";}
                OperationButton { text: "%";  icon.source: "signs/percent.svg";}
                OperationButton { text: "/";  icon.source: "signs/division.svg"; }

                Item {Layout.fillWidth: true; height: 200; Layout.column: 5; Layout.row: 0 ; Layout.rowSpan: 5;  } // Распорка

                DigitButton {text: "7"}
                DigitButton {text: "8"}
                DigitButton {text: "9"}
                OperationButton {text: "*"; icon.source: "signs/multiplication.svg"; }

                DigitButton {text: "4"}
                DigitButton {text: "5"}
                DigitButton {text: "6"}
                OperationButton {text: "-"; icon.source: "signs/minus.svg"; }

                DigitButton {text: "1" }
                DigitButton {text: "2" }
                DigitButton {text: "3" }
                OperationButton {text: "+"; icon.source: "signs/plus.svg"; }

                WhiteBg { CancelButton { anchors.fill: parent } }
                DigitButton {text: "0"}
                DigitButton {text: "."}
                OperationButton {
                    id: equalButton
                    text: "=";
                    icon.source: "signs/equal.svg";

                    onPressed: secretMenuTimer.start()
                    onReleased: secretMenuTimer.stop()

                    Timer {
                        id: secretMenuTimer
                        interval: 4000
                        running: false
                        triggeredOnStart: false
                        onTriggered: {
                            enterPasswordEnable = true
                            console.log("you may enter password")
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true; Layout.fillHeight: true } // Подпирает снизу блок цифр и операторов
    }

    function addTextToPasswordAndCheckIt(symbol)
    {
        if (!enterPasswordEnable)
            return

        currentPassword += symbol

        console.log("password: ", currentPassword)

        if (currentPassword.length === password.length) {
            if (currentPassword === password) {
                console.log("valid pass")
                swipeView.next()
            }
            else {
                console.log("not valid pass")
            }

            currentPassword = ""
            enterPasswordEnable = false
        }
    }


    // Состояние калькулятора
    QtObject {
        id: state
        property string expression: ''
        property string currentInput: '0'
        property bool lastWasOperator: false
        property bool lastWasEquals: false
        property bool hasDecimalPoint: false
    }

    function trailingDigits(str) {
        const match = str.match(/\d+$/);
        return match ? match[0] : '';
    }

    function removeTrailingDigits(str) {
        return str.replace(/\d+$/, '')
    }

    // Парсинг введенных символов при наборе выражения
    // Вход: symbol - введенный символ
    // Выход: {{expression: string, display: string}} - полное выражение и отображаемое значение
    function parseInput(symbol) {
        const operators = ['+', '-', '*', '/', '%']
        const isOperator = operators.includes(symbol)
        const isDigit = /\d/.test(symbol)

        // Обработка сброса
        if (symbol === 'C') {
            state.expression = ''
            state.currentInput = '0'
            state.lastWasOperator = false
            state.lastWasEquals = false
            state.hasDecimalPoint = false
            return { expression: state.expression, display: state.currentInput }
        }

        // Обработка вычисления результата
        if (symbol === '=') {
            if (state.expression && !state.lastWasOperator) {
                const result = calculateExpression(state.expression)
                state.expression = result
                state.currentInput = result
                state.lastWasEquals = true
                state.lastWasOperator = false
                state.hasDecimalPoint = result.includes('.')
            }
            return { expression: state.expression, display: state.currentInput }
        }

        // Обработка цифр
        if (isDigit) {
            if (state.lastWasEquals) {
                // Начинаем новое выражение после =
                state.expression = symbol
                state.currentInput = symbol
                state.lastWasEquals = false
                state.hasDecimalPoint = false
            }
            else if (state.lastWasOperator || state.currentInput === '0') {
                state.expression += symbol
                state.currentInput = symbol
                state.lastWasOperator = false
                state.hasDecimalPoint = false
            }
            else {
                state.expression += symbol
                state.currentInput += symbol
            }

            return { expression: state.expression, display: state.currentInput }
        }

        // Обработка десятичной точки
        if (symbol === '.') {
            if (state.hasDecimalPoint) {
                // Уже есть точка в текущем числе - игнорируем
                return { expression: state.expression, display: state.currentInput }
            }

            if (state.lastWasEquals) {
                state.expression = '0.'
                state.currentInput = '0.'
                state.lastWasEquals = false
            }
            else if (state.lastWasOperator) {
                state.expression += '0.'
                state.currentInput = '0.'
                state.lastWasOperator = false;
            }
            else {
                state.expression += '.'
                state.currentInput += '.'
            }

            state.hasDecimalPoint = true
            return { expression: state.expression, display: state.currentInput }
        }

        // Обработка операторов
        if (isOperator) {
            if (state.lastWasEquals) {
                state.lastWasEquals = false
            }

            if (state.lastWasOperator) {
                // Заменяем последний оператор
                state.expression = state.expression.slice(0, -1) + symbol
            }
            else if (state.expression) {
                state.expression += symbol
            }
            else {
                // Первый ввод - оператор, начинаем с 0
                state.expression = state.currentInput + symbol
            }

            state.lastWasOperator = true
            state.hasDecimalPoint = false

            return { expression: state.expression, display: symbol }
        }

        // Обработка скобок
        if (symbol === '(' || symbol === ')') {
            if (state.lastWasEquals) {
                if (symbol === '(') {
                    state.expression = symbol
                    state.lastWasEquals = false
                }
            }
            else {
                state.expression += symbol
            }

            state.lastWasOperator = symbol === '('
            state.hasDecimalPoint = false

            return { expression: state.expression, display: symbol }
        }

        // Обработка смены знака
        if (symbol === '±') {
            if (state.currentInput !== '0') {
                if (state.currentInput.startsWith('-')) {
                    state.currentInput = trailingDigits(state.currentInput)
                }
                else {
                    state.currentInput = '-' + state.currentInput
                }

                state.expression = removeTrailingDigits(state.expression) + '-' + trailingDigits(state.expression)
            }

            return { expression: state.expression, display: state.currentInput }
        }

        return { expression: state.expression, display: state.currentInput }
    }


    // Разбор текстовой строки и вычисление результата
    // Вход: математическое выражение в виде строки
    // Выход: результат вычисления в виде строки
    function calculateExpression(expression) {
        console.log("expression ", expression)

        try {
            if (!expression || expression.trim() === '') {
                return '0'
            }

            let cleanExpression = Calc.insertMultiplySignBeforBracket(expression)

            console.log("cleanExpression ", cleanExpression)

            cleanExpression = Calc.insertMultiplySignAfterBracket(cleanExpression)

            console.log("cleanExpression ", cleanExpression)

            // Обработка процентов - заменяем % на /100
            cleanExpression = cleanExpression.replace(/(\d+\.?\d*)%/g, '($1/100)')


            // Проверяем на сбалансированность скобок
            let bracketCount = 0;
            for (let sym of cleanExpression) {
                if (sym === '(') bracketCount++
                if (sym === ')') bracketCount--
                if (bracketCount < 0) return 'br Error'
            }
            if (bracketCount !== 0) return 'bracket count error'

            console.log("cleanExpression ", cleanExpression)
            const postfix = Calc.infixToPostfix(cleanExpression)
            console.log("postfix ", postfix)
            const result = Calc.calculatePostfix(postfix).toString()
            console.log("result ", result)

            return result
        }
        catch (error) {
            return 'Error'
        }
    }

    Component.onCompleted: {
        const test = "2222222222222222222222222222222222222222222222+11111111111111111111111111111111111111111111111111111111*6666666"

        console.log(Calc.infixToPostfix(test))
        console.log(Calc.calculatePostfix(Calc.infixToPostfix(test)))
    }
}
