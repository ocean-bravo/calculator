import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    color: colors.theme_1_3

    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 8

        spacing: 3

        HSpacer {}
        Ico { source: "signs/wifi.svg" }
        Ico { source: "signs/cellular.svg" }
        Ico { source: "signs/battery.svg" }

        Text {
            id: time
            Layout.preferredHeight: 16
            verticalAlignment: Qt.AlignVCenter
            font.family: fontRobotoMedium.name
            font.weight: Font.Medium
            font.pixelSize: 14
            color: colors.theme_1_6
            renderType: Text.NativeRendering

            function update() {
                text = new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
            }

            Timer {
                id: timeUpdateTimer
                interval: 1000
                repeat: true
                running: true
                triggeredOnStart: true
                onTriggered: time.update()
            }
        }
    }

    component Ico : Image {
            Layout.preferredHeight: 16
            verticalAlignment: Image.AlignVCenter
    }

    component HSpacer: Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 16
    }
}
