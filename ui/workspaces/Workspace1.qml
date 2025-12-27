import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"


Rectangle {
    anchors.fill: parent
    anchors.topMargin: 40
    color: "#222222"
    property var filedialog
    property bool isConverting
    property ListModel outputFormats
    property var updateOutputFormats
    property var extensionToTypeMap

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: 0.2
        visible: isConverting
        z: 10
    }

    MouseArea {
        anchors.fill: parent
        enabled: isConverting
        acceptedButtons: Qt.AllButtons
        z: 11
    }

    CustomBusyIndicator {
        anchors.centerIn: parent
        active: isConverting
        visible: isConverting
        z: 12
    }


    DropZone {
        id: dropzone
        anchors.horizontalCenter: parent.horizontalCenter
        y: window.height / 2 - height / 2
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
}
