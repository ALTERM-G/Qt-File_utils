import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "components"
import "workspaces"

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height
    title: "File Converter"
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
    ListModel {
        id: outputFormatsModel
    }

    Workspace1 {
        id: workspace_1
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        filedialog: filedialog
        isConverting: window.isConverting
        updateOutputFormats: window.updateOutputFormats
        extensionToTypeMap: extensionToTypeMap
        outputFormats: outputFormatsModel
        visible: currentWorkspace === 1
    }

    Workspace2 {
        id: workspace_2
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        filedialog: filedialog
        visible: currentWorkspace === 2
    }

    Workspace3 {
        id: workspace_3
        visible: currentWorkspace === 3
    }

    Workspace4 {
        id: workspace_4
        visible: currentWorkspace === 4
    }

    Workspace5 {
        id: workspace_5
        visible: currentWorkspace === 5
    }

    TopBar {
        id: topBar
        currentWorkspace: window.currentWorkspace
        titles: window.workspaceTitles
    }

    function updateOutputFormats(type) {
        outputFormatsModel.clear()
        var formats = []
        if (type === "Video")
            formats = [".mp4", ".mkv", ".avi", ".mov"]
        else if (type === "Vector")
            formats = [".svg", ".pdf", ".png", ".eps"]
        else if (type === "Image")
            formats = [".png", ".jpg", ".webp", ".bmp"]
        else if (type === "Audio")
            formats = [".mp3", ".wav", ".flac", ".ogg"]
        else if (type === "Document")
            formats = [".txt", ".md", ".html", ".rtf", ".csv", ".docx", ".pdf"]

        for (var i = 0; i < formats.length; i++)
            outputFormatsModel.append({"name": formats[i]})
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
        sequence: "Ctrl+1"
        onActivated: window.currentWorkspace = 1
    }
    Shortcut {
        sequence: "Ctrl+2"
        onActivated: window.currentWorkspace = 2
    }
    Shortcut {
        sequence: "Ctrl+3"
        onActivated: window.currentWorkspace = 3
    }
    Shortcut {
        sequence: "Ctrl+4"
        onActivated: window.currentWorkspace = 4
    }
    Shortcut {
        sequence: "Ctrl+5"
        onActivated: window.currentWorkspace = 5
    }

    Connections {
        target: controller

        function onConversionStarted() {
            console.log("Conversion started...");
            window.isConverting = true
        }

        function onConversionFinished(resultPath) {
            console.log("Conversion finished! Output: " + resultPath);
            window.isConverting = false
        }

        function onConversionError(errorMessage) {
            console.log("Conversion error: " + errorMessage);
            window.isConverting = false
        }
    }
}
