import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: root
    width: 360
    height: 640
    visible: true
    title: "Калькулятор"
    flags: Qt.FramelessWindowHint
    color: colors.theme_1_1

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        TopStatusBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }

        SwipeView {
            id: swipeView
            clip: true

            Layout.fillWidth: true
            Layout.fillHeight: true

            interactive: false
            function next() {
                if (currentIndex < count - 1)
                    currentIndex += 1
            }

            function previous() {
                if (currentIndex > 0)
                    currentIndex -= 1
            }

            Calculator {}
            SecretMenu {}
        }
    }

    QtObject {
        id: colors

        readonly property color theme_1_1: "#024873"
        readonly property color theme_1_2: "#0889A6"
        readonly property color theme_1_3: "#04BFAD"
        readonly property color theme_1_4: "#B0D1D8"
        readonly property color theme_1_5: "#F25E5E"
        readonly property color theme_1_6: "#FFFFFF"

        readonly property color theme_1_add_1: "#00F79C"
        readonly property color theme_1_add_2: "#F7E425"
        readonly property color theme_1_3_30: "#04BFAD"
        readonly property color theme_1_1_30: "#024873"
        readonly property color theme_1_4_50: "#B0D1D8"
    }

    FontLoader {
       id: fontRobotoMedium
       source: "fonts/Roboto-Medium.ttf"
    }

    FontLoader {
       id: fontOpenSansSemiBold
       source: "fonts/OpenSans-SemiBold.ttf"
    }
}
