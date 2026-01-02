import QtQuick
import QtQuick.Controls
import "../components"


Rectangle {
    anchors.fill: parent
    color: "#222222"
    property ListModel outputFormats
    property var updateOutputFormats
    property bool isConverting

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: isConverting ? 0.4 : 0

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
        }

        ConvertButton {
            id: convertButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            onPressed: {
                if (!controller) {
                    console.log("Controller is not assigned!")
                    return
                }

                if (dropzone.droppedFile && comboBox.currentText && outputComboBox.currentText) {
                    controller.convert(
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
            dropzone.droppedFile = path
        }
    }

    Component.onCompleted: {
        comboBox.currentIndex = 0
        if (updateOutputFormats) {
            updateOutputFormats(comboBox.currentText)
        }
    }

    Shortcut {
        sequence: "Return"
        onActivated: {
            if (!isConverting) convertButton.pressed()
        }
    }
}
