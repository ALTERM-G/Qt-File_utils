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
    property string fileExtension: ""
    property string lastModified: ""

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8
        visible: root.filePath !== ""

        Text {
            text: "File information"
            font.pixelSize: 16
            font.family: "JetBrains Mono"
            font.bold: true
            font.underline: true
            color: "#dddddd"
        }

        GridLayout {
            columns: 2
            columnSpacing: 20
            rowSpacing: 8
            // NAME
            Text { text: "Name:"; color: "#aaaaaa" }
            Text { text: root.fileName; color: "white" }

            // TYPE
            Text { text: "Type:"; color: "#aaaaaa" }
            Text { text: root.fileType; color: "white" }

            // EXTENSION
            Text { text: "Extension:"; color: "#aaaaaa" }
            Text { text: root.fileExtension === "" ? "—" : "." + root.fileExtension; color: "white" }

            // SIZE
            Text { text: "Size:"; color: "#aaaaaa" }
            Text { text: root.fileSize; color: "white" }

            // LAST MODIFIED
            Text { text: "Last modified:"; color: "#aaaaaa" }
            Text { text: root.lastModified; color: "white" }

            // PATH
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
