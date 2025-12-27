import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: lineEditBackground
    width: 400
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? "#dd1124" : "#222222"
    border.color: "#000000"
    border.width: 3
    clip: true
    property alias text: lineEdit.text
    signal editingFinished

    TextInput {
        id: lineEdit
        anchors.fill: parent
        anchors.margins: 8
        font.pixelSize: 20
        font.family: "JetBrains Mono"
        font.bold: true
        color: "#ffffff"
        focus: true
        cursorVisible: true
        selectByMouse: true
        onEditingFinished: lineEditBackground.editingFinished()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.IBeamCursor
        onClicked: lineEdit.forceActiveFocus()
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}
