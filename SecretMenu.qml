import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    Text {
        id: title
        text: "Секретное меню"
        color: colors.theme_1_6
        anchors.centerIn: parent
    }

    Button {
        text: "Назад"
        width: 100
        height: 30
        onClicked: swipeView.previous()
        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
