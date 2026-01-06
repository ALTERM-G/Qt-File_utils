import QtQuick

Rectangle {
    id: convertButton
    width: 200
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? "#4b4b4b" : "#3a3a3a"
    border.color: "#888888"
    border.width: 2.5
    signal pressed
    property string buttonText

    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()

    function doPress() {
        pressed()
    }

    Text {
        anchors.centerIn: parent
        text: convertButton.buttonText
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.bold: true
        color: "#ffffff"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: convertButton.doPress()
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
