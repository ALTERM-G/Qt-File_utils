import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "components"
import "workspaces"
import Data 1.0

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

    ListModel {
        id: outputFormatsModel
    }

    Workspace1 {
        id: workspace_1
        isConverting: window.isConverting
        updateOutputFormats: window.updateOutputFormats
        outputFormats: outputFormatsModel
        visible: currentWorkspace === 1
    }

    Workspace2 {
        id: workspace_2
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
        titles: Data.workspaceTitles
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
        var type = Data.extensionToTypeMap[ext]

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

        function onWorkingStarted() {
            console.log("Working...");
            window.isConverting = true
        }

        function onWorkingFinished(resultPath) {
            console.log("Finished! Output: " + resultPath);
            window.isConverting = false
        }

        function onWorkingError(errorMessage) {
            console.log("Error: " + errorMessage);
            window.isConverting = false
        }
    }
}
