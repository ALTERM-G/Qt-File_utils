import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
    anchors.fill: parent
    color: "#222222"

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
        spacing: 15

        CustomComboBox {
            id: combobox
            model: ["Option 1", "Option 2", "Option 3"]
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DropZone {
            dropMode: 1
            height: 250
        }
    }
}
