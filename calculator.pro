QT += core qml quick quickcontrols2

CONFIG += c++17

TARGET = calculator
TEMPLATE = app

DISTFILES += \
    $$PWD/*.qml \
    $$PWD/fonts/*ttf \
    $$PWD/signs/*.svg \
    $$PWD/big.mjs \
    $$PWD/calc.js \

SOURCES += $$PWD/main.cpp \

target.path = $$OUT_PWD
target.files += $$PWD/*.qml $$PWD/big.mjs $$PWD/calc.js

fonts.path = $$OUT_PWD/fonts
fonts.files += $$PWD/fonts/*.ttf

signs.path = $$OUT_PWD/signs
signs.files += $$PWD/signs/*.svg

INSTALLS += target signs fonts
