import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Rectangle {
    anchors.fill: parent
    color: "#222222"
    property var filedialog
    property bool isConverting
    property var outputFormats
    property var controller
    property var updateOutputFormats

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
        spacing: 15

        ChooseFileButton {
            id: choosefilebutton
            dialog: filedialog
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DropZone {
            id: dropzone
            height: 250
        }

        InfoPanel {
            filePath: dropzone.droppedFile
            fileType: dropzone.fileTypeLabel
        }
    }
}
