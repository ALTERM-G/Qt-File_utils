import QtQuick
import QtQuick.Controls
import "../components"


Rectangle {
    anchors.fill: parent
    color: "#222222"
    anchors.topMargin: 40
    property var filedialog
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

    DropZone {
        id: dropzone
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    ChooseFileButton {
        id: chooseFileButton
        dialog: filedialog
        anchors.bottom: dropzone.top
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    CustomComboBox {
        id: comboBox
        width: 200
        anchors.bottom: dropzone.top
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 60
        model: ["Video", "Image", "Audio", "Document", "Vector"]
        hoverEnabled: !isConverting
        onCurrentTextChanged: {
            if (updateOutputFormats) updateOutputFormats(currentText)
        }
    }

    CustomComboBox {
        id: outputComboBox
        width: 200
        model: outputFormats
        textRole: "name"
        enabled: outputFormats.count > 0
        anchors.bottom: dropzone.top
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 60
        hoverEnabled: !isConverting
    }

    ConvertButton {
        id: convertButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
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
