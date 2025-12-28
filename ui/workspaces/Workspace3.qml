import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
    anchors.fill: parent
    color: "#222222"

    CustomComboBox {
        id: combobox
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 100
        model: ["Option 1", "Option 2", "Option 3"]
    }

    DropZone {
        anchors.top: combobox.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        dropMode: 1
    }
}
