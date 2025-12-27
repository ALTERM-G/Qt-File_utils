import QtQuick 2.12

Rectangle {
    id: convertButton
    width: 200
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? "#4b4b4b" : "#3a3a3a"
    border.color: "#888888"
    border.width: 2.5
    signal pressed

    Text {
        anchors.centerIn: parent
        text: "Convert"
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        color: "#ffffff"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: convertButton.pressed()
    }

    Behavior on color {
        ColorAnimation {
            duration: 300
        }
    }
}
