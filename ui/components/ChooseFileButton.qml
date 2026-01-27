import QtQuick
import QtQuick.Controls

Rectangle {
    id: choosefilebutton
    width: 200
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? Theme.hoverBackgroundColor : Theme.backgroundColor
    border.color: Theme.borderColor
    border.width: 2.5
    property var dialog

    Row {
        anchors.centerIn: parent
        spacing: 8

        Image {
            source: "../../assets/icons/file_search.svg"
            width: 24
            height: 24
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Text {
            text: "Choose File"
            font.pixelSize: Typography.bigFontSize
            font.family: Typography.fontBold
            color: Theme.textColor
        }
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
