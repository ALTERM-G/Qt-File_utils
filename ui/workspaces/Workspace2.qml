import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
    anchors.fill: parent
    color: "#222222"

    property bool isCompressing
    property alias dropzone: dropzone

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "#ffffff"
        opacity: isCompressing ? 0.2 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        visible: isCompressing
        z: isCompressing ? 19 : 0

        MouseArea {
            anchors.fill: parent
            enabled: isCompressing
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
        }
    }

    CustomBusyIndicator {
        anchors.centerIn: parent
        active: isCompressing
        visible: isCompressing
        z: isCompressing ? 20 : 0
    }

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
                    isCompressing = true
                    controller.run_compression(
                        dropzone.droppedFiles,
                        "", // Let backend handle the folder path
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

    Connections {
        target: controller
        function onCompressionStarted() { workspace_2.isCompressing = true }
        function onCompressionFinished(resultPath) {
            workspace_2.isCompressing = false
            workspace_2.dropzone.showSuccess("Output: " + resultPath)
        }
        function onCompressionError(errorMessage) {
            workspace_2.isCompressing = false
            workspace_2.dropzone.showError(errorMessage)
        }
    }
}
