import QtQuick
import QtQuick.Controls
import "../components"


Rectangle {
    anchors.fill: parent
    color: Theme.appBackground

    property ListModel outputFormats
    property var updateOutputFormats
    property var handleInputFile
    property bool isConverting
    property alias dropzone: dropzone

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "#ffffff"
        opacity: isConverting ? 0.2 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        visible: isConverting
        z: isConverting ? 19 : 0

        MouseArea {
            anchors.fill: parent
            enabled: isConverting
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
        }
    }

    CustomBusyIndicator {
        anchors.centerIn: parent
        active: isConverting
        visible: isConverting
        z: isConverting ? 20 : 0
    }

    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 60
        spacing: 15

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            CustomComboBox {
                id: comboBox
                width: 200
                model: ["Video", "Image", "Audio", "Document", "Vector"]
                hoverEnabled: !isConverting
                onCurrentTextChanged: {
                    if (updateOutputFormats) updateOutputFormats(currentText)
                }
            }

            ChooseFileButton {
                id: chooseFileButton
                dialog: filedialog
            }

            CustomComboBox {
                id: outputComboBox
                width: 200
                model: outputFormats
                textRole: "name"
                enabled: outputFormats.count > 0
                hoverEnabled: !isConverting
            }
        }

        DropZone {
            id: dropzone
            anchors.horizontalCenter: parent.horizontalCenter
            onFileDropped: (path, type) => {
                if (handleInputFile) {
                    handleInputFile(path, dropzone, comboBox)
                }
            }
        }

        CustomButton {
            id: convertButton
            buttonText: "Convert"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            onPressed: {
                if (dropzone.droppedFile && comboBox.currentText && outputComboBox.currentText) {
                    isConverting = true
                    controller.run_conversion(
                        dropzone.droppedFile,
                        comboBox.currentText,
                        outputComboBox.currentText
                    )
                } else {
                    console.log("Select a file, type, and output format first")
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
            if (handleInputFile) {
                handleInputFile(path, dropzone, comboBox)
            }
        }
    }

    Component.onCompleted: {
        comboBox.currentIndex = 0
        if (updateOutputFormats) {
            updateOutputFormats(comboBox.currentText)
        }
    }

    Connections {
        target: controller
        function onConversionStarted() { workspace_1.isConverting = true }
        function onConversionFinished(resultPath) {
            workspace_1.isConverting = false
            workspace_1.dropzone.showSuccess("Output: " + resultPath)
        }
        function onConversionError(errorMessage) { workspace_1.isConverting = false; workspace_1.dropzone.showError(errorMessage)}
    }
}
