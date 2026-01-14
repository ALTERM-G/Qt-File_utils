import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
    anchors.fill: parent
    color: Data.appBackground

    property var controller
    property var updateOutputFormats

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
        spacing: 15

        ChooseFileButton {
            dialog: filedialog
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DropZone {
            id: dropzone
            height: 250
            infoPanel: infoPanel
        }

        InfoPanel {
            id: infoPanel
        }
    }

    FileDialog {
        id: filedialog
        title: "Select a file"
        fileMode: FileDialog.OpenFile
        nameFilters: ["Images (*.png *.jpg *.bmp)", "Documents (*.pdf *.docx)"]

        onAccepted: {
            var path = selectedFile.toString().replace("file://", "")
            dropzone.droppedFile = path
        }
    }
}
