import QtQuick
import QtQuick.Controls

Rectangle {
    id: choosefilebutton
    width: 200
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? Data.hoverBackgroundColor : Data.backgroundColor
    border.color: Data.borderColor
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
            font.pixelSize: 18
            font.family: Data.fontBold
            color: Data.textColor
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
