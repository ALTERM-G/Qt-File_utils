import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "components"

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height
    flags: Qt.FramelessWindowHint | Qt.Window
    title: "File Converter"
    property var outputFormats: []
    property bool isConverting: false
    property int currentWorkspace: 1
    property var extensionToTypeMap: {
        "txt": "Document",
        "md": "Document",
        "html": "Document",
        "rtf": "Document",
        "csv": "Document",
        "docx": "Document",
        "pdf": "Document",
        "png": "Image",
        "jpg": "Image",
        "jpeg": "Image",
        "webp": "Image",
        "bmp": "Image",
        "mp4": "Video",
        "mkv": "Video",
        "avi": "Video",
        "mov": "Video",
        "mp3": "Audio",
        "wav": "Audio",
        "flac": "Audio",
        "ogg": "Audio",
        "svg": "Vector",
    }
    property var workspaceTitles: [
        "Convert Files",
        "File Info",
        "Compress Files",
        "Extract Files",
        "Settings"
    ]
    onCurrentWorkspaceChanged: {
        if (currentWorkspace === 1) workspaceStack.sourceComponent = workspace1
        else if (currentWorkspace === 2) workspaceStack.sourceComponent = workspace2
        else if (currentWorkspace === 3) workspaceStack.sourceComponent = workspace3
        else if (currentWorkspace === 4) workspaceStack.sourceComponent = workspace4
        else if (currentWorkspace === 5) workspaceStack.sourceComponent = workspace5
    }

    TopBar {
        id: topBar
        currentWorkspace: window.currentWorkspace
        titles: window.workspaceTitles
    }

    Loader {
        id: workspaceStack
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        sourceComponent: workspace1
    }

    Component {
        id: workspace1
        Rectangle {
            anchors.fill: parent
            color: "#222222"

            Rectangle {
                id: overlay
                anchors.fill: parent
                opacity: 0.2
                visible: isConverting
                z: 100

                MouseArea {
                    anchors.fill: parent
                    enabled: true
                    hoverEnabled: true
                    acceptedButtons: Qt.AllButtons
                }

                CustomBusyIndicator {
                    anchors.centerIn: parent
                    active: true
                    indicatorSize: 64
                }
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

            CustomComboBox {
                id: comboBox
                width: 200
                anchors.bottom: dropzone.top
                anchors.bottomMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 60
                model: ["Video", "Image", "Audio", "Document", "Vector"]
                onCurrentTextChanged: updateOutputFormats(currentText)
            }

            CustomComboBox {
                id: outputComboBox
                width: 200
                model: outputFormats
                enabled: outputFormats.length > 0
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
                    if (dropzone.droppedFile && comboBox.currentText && outputComboBox.currentText) {
                        controller.convert(
                            dropzone.droppedFile,
                            comboBox.currentText,
                            outputComboBox.currentText
                        )
                    }
                    else {
                        console.log("Select a file, type, and output format first");
                    }
                }
            }
        }
    }

    Component {
        id: workspace2
        Rectangle {
            anchors.fill: parent
            color: "#222222"
        }
    }

    Component {
        id: workspace3
        Rectangle {
            anchors.fill: parent
            color: "#222222"
        }
    }

    Component {
        id: workspace4
        Rectangle {
            anchors.fill: parent
            color: "#222222"
        }
    }

    Component {
        id: workspace5
        Rectangle {
            anchors.fill: parent
            color: "#222222"
        }
    }

    function switchWorkspace(index) {
        var target
        if (index === 1) target = workspace1
        else if (index === 2) target = workspace2
        else target = workspace3

        workspaceStack.replace(target)
    }

    function updateOutputFormats(type) {
        if (type === "Video")
            outputFormats = [".mp4", ".mkv", ".avi", ".mov"];
        else if (type === "Vector")
            outputFormats = [".svg", ".pdf", ".png", ".eps"];
        else if (type === "Image")
            outputFormats = [".png", ".jpg", ".webp", ".bmp"];
        else if (type === "Audio")
            outputFormats = [".mp3", ".wav", ".flac", ".ogg"];
        else if (type === "Document")
            outputFormats = [".txt", ".md", ".html", ".rtf", ".csv", ".docx", ".pdf"];
        else
            outputFormats = [];
    }

    function handleInputFile(path) {
        dropzone.droppedFile = path
        var ext = path.split(".").pop().toLowerCase()
        var type = extensionToTypeMap[ext]

        if (type) {
            var index = comboBox.model.indexOf(type)
            if (index >= 0)
                comboBox.currentIndex = index
            updateOutputFormats(type)
        }
        else {
            console.log("Unsupported file type")
        }
    }

    Shortcut {
        sequence: "Return"
        onActivated: {
            if (!isConverting) convertButton.pressed()
        }
    }
    Shortcut {
        sequence: "Ctrl+1"
        onActivated: {
            window.currentWorkspace = 1
            workspaceStack.sourceComponent = workspace1
        }
    }
    Shortcut {
        sequence: "Ctrl+2"
        onActivated: {
            window.currentWorkspace = 2
            workspaceStack.sourceComponent = workspace2
        }
    }
    Shortcut {
        sequence: "Ctrl+3"
        onActivated: {
            window.currentWorkspace = 3
            workspaceStack.sourceComponent = workspace3
        }
    }
    Shortcut {
        sequence: "Ctrl+4"
        onActivated: {
            window.currentWorkspace = 4
            workspaceStack.sourceComponent = workspace4
        }
    }
    Shortcut {
        sequence: "Ctrl+5"
        onActivated: {
            window.currentWorkspace = 5
            workspaceStack.sourceComponent = workspace5
        }
    }

    Connections {
        target: controller

        function onConversionStarted() {
            console.log("Conversion started...");
            isConverting = true
        }

        function onConversionFinished(resultPath) {
            console.log("Conversion finished! Output: " + resultPath);
            isConverting = false
        }

        function onConversionError(errorMessage) {
            console.log("Conversion error: " + errorMessage);
            isConverting = false
        }
    }
}
