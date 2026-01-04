import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
    anchors.fill: parent
    color: "#222222"
    property bool isWorking: false

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: isWorking ? 0.4 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        visible: isWorking
        z: isWorking ? 19 : 0

        MouseArea {
            anchors.fill: parent
            enabled: isWorking
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
        }
    }

    CustomBusyIndicator {
        anchors.centerIn: parent
        active: isWorking
        visible: isWorking
        z: isWorking ? 20 : 0
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
                model: ["audio", "frames", "subtitles"]
            }

            ChooseFileButton {
                dialog: filedialog
            }
        }


        DropZone {
            id: dropzone
        }

        CustomButton {
            id: compressButton
            buttonText: "Extract"
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: {
                if (dropzone.droppedFiles.length > 0 && combobox.currentText) {
                    var lastFile = dropzone.droppedFiles[dropzone.droppedFiles.length - 1]
                    var folder = lastFile.substring(0, lastFile.lastIndexOf("/"))

                    controller.run_extraction(
                        dropzone.droppedFile,
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
        nameFilters: ["Videos (*.mp4 *.mkv *.mov *.avi)"]
        onAccepted: {
            var path = selectedFile.toString().replace("file://", "")
            dropzone.droppedFile = path
        }
    }
}
