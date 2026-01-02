import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    width: 700
    height: Math.max(200, contentColumn.implicitHeight + 32)
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
    property bool isCorrupted: false

    function formatLongText(text, lineLength) {
        if (!text) {
            return "";
        }
        var result = "";
        for (var i = 0; i < text.length; i += lineLength) {
            result += text.substring(i, i + lineLength) + "\n";
        }
        return result.slice(0, -1);
    }

    Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
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
            columns: 4
            columnSpacing: 20
            rowSpacing: 8
            // NAME
            Text { text: "Name:"; color: "#aaaaaa" }
            Text {
                text: root.formatLongText(root.fileName, 40)
                color: "white"
                Layout.fillWidth: true
                Layout.rightMargin: 60
            }

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
            Text { text: root.formatLongText(root.lastModified, 40); color: "white" }

            // PATH
            Text { text: "Path:"; color: "#aaaaaa" }
            Text {
                text: root.formatLongText(root.filePath, 45)
                color: "white"
                Layout.fillWidth: true
            }

            // CORRUPTED
            Text { text: "Corrupted:"; color: "#aaaaaa" }
            Text { text: root.isCorrupted ? "Yes" : "No"; color: "white" }
        }
    }
}
