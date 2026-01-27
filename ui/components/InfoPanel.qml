import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    width: 700
    height: Math.max(200, contentColumn.implicitHeight + 32)
    radius: 12
    color: Theme.backgroundColor_2
    border.color: Theme.borderColor
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
            font.pixelSize: Typography.bigFontSize
            font.family: Typography.fontBold
            font.underline: true
            color: Theme.textColor_2
        }

        GridLayout {
            columns: 2
            columnSpacing: 8
            rowSpacing: 4

            // NAME
            Text { text: "Name:"; color: Theme.textColor_3 }
            CustomText {
                textContent: root.formatLongText(root.fileName, 40)
                Layout.fillWidth: true
                Layout.rightMargin: 60
            }

            // TYPE
            Text { text: "Type:"; color: Theme.textColor_3 }
            CustomText { textContent: root.fileType }

            // EXTENSION
            Text { text: "Extension:"; color: Theme.textColor_3 }
            CustomText { textContent: root.fileExtension === "" ? "—" : "." + root.fileExtension }

            // SIZE
            Text { text: "Size:"; color: Theme.textColor_3 }
            CustomText { textContent: root.fileSize }

            // LAST MODIFIED
            Text { text: "Last modified:"; color: Theme.textColor_3 }
            CustomText { textContent: root.formatLongText(root.lastModified, 40) }

            // PATH
            Text { text: "Path:"; color: Theme.textColor_3 }
            CustomText {
                textContent: root.formatLongText(root.filePath, 45)
                Layout.fillWidth: true
            }
        }
    }
}
