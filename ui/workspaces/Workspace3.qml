import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
    anchors.fill: parent
    color: "#222222"
    property bool isExtracting
    property alias dropzone: dropzone

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: isExtracting ? 0.4 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        visible: isExtracting
        z: isExtracting ? 19 : 0

        MouseArea {
            anchors.fill: parent
            enabled: isExtracting
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
        }
    }

    CustomBusyIndicator {
        anchors.centerIn: parent
        active: isExtracting
        visible: isExtracting
        z: isExtracting ? 20 : 0
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
                    isExtracting = true
                    var lastFile = dropzone.droppedFiles[dropzone.droppedFiles.length - 1]
                    var folder = lastFile.substring(0, lastFile.lastIndexOf("/"))

                    var inputFile = dropzone.droppedFile;
                    var baseName = inputFile.split("/").pop().split(".")[0];
                    var parentFolder = inputFile.substring(0, inputFile.lastIndexOf("/"));

                    if (combobox.currentText === "frames") {
                        var outputFolder = parentFolder + "/" + baseName + "_frames/";
                        controller.run_extraction(inputFile, outputFolder, "frames");
                    } else if (combobox.currentText === "audio") {
                        var outputFile = parentFolder + "/" + baseName + ".mp3";
                        controller.run_extraction(inputFile, outputFile, "audio");
                    } else if (combobox.currentText === "subtitles") {
                        var outputFile = parentFolder + "/" + baseName + ".srt";
                        controller.run_extraction(inputFile, outputFile, "subtitles");
                    }
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

    Connections {
        target: controller
        function onExtractionStarted() { workspace_3.isExtracting = true }
        function onExtractionFinished(resultPath) {
            workspace_3.isExtracting = false
            workspace_3.dropzone.showSuccess("Output: " + resultPath)
        }
        function onExtractionError(errorMessage) {
            workspace_3.isExtracting = false
            workspace_3.dropzone.showError(errorMessage)
        }
    }
}
