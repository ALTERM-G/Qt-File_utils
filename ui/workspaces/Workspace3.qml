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

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 80

            CustomComboBox {
                id: combobox
                model: ["zip", "rar", "7z"]
            }

            ChooseFileButton {
                dialog: filedialog
            }
        }


        DropZone {
            id: dropzone
            multiFile: true
        }

        CustomButton {
            id: compressButton
            buttonText: "Compress"
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: {
                if (dropzone.droppedFiles.length > 0 && combobox.currentText) {
                    var lastFile = dropzone.droppedFiles[dropzone.droppedFiles.length - 1]
                    var folder = lastFile.substring(0, lastFile.lastIndexOf("/"))

                    controller.run_compression(
                        dropzone.droppedFiles,
                        folder,
                        combobox.currentText
                    )
                } else {
                    console.log("Select a file and format first")
                }
            }
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
