import QtQuick

Rectangle {
    id: convertButton
    width: 200
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? Theme.hoverBackgroundColor : Theme.backgroundColor
    border.color: Theme.borderColor
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
        font.pixelSize: Typography.bigFontSize
        font.family: Typography.fontBold
        color: Theme.textColor
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
