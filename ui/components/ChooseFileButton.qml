import QtQuick
import QtQuick.Controls


Rectangle {
    id: choosefilebutton
    width: 200
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? "#4b4b4b" : "#3a3a3a"
    border.color: "#888888"
    border.width: 2.5
    property var dialog

    Text {
        anchors.centerIn: parent
        text: "Choose File"
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        color: "#ffffff"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: dialog.open()
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
