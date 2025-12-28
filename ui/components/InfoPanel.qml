import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    width: 700
    height: 200
    radius: 12
    color: "#2a2a2a"
    border.color: "#333333"
    border.width: 2
    property string filePath: ""
    property string fileName: ""
    property string fileType: ""
    property string fileSize: ""

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10
        visible: filePath !== ""

        Text {
            text: "File information"
            font.pixelSize: 16
            font.family: "JetBrains Mono"
            font.bold: true
            color: "#dddddd"
        }

        GridLayout {
            columns: 2
            columnSpacing: 20
            rowSpacing: 8

            Text { text: "Type:"; color: "#aaaaaa" }
            Text { text: root.fileType; color: "white" }

            Text { text: "Size:"; color: "#aaaaaa" }
            Text { text: root.fileSize; color: "white" }

            Text { text: "Path:"; color: "#aaaaaa" }
            Text {
                text: root.filePath
                color: "white"
                elide: Text.ElideMiddle
                wrapMode: Text.NoWrap
            }
        }
    }
}
