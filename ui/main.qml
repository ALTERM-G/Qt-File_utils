import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "components"
import "workspaces"
import "../data"

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
    font.family: Typography.fontRegular
    property int currentWorkspace: 1

    ListModel {
        id: outputFormatsModel
    }

    Workspace1 {
        id: workspace_1
        updateOutputFormats: window.updateOutputFormats
        handleInputFile: window.handleInputFile
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

    TopBar {
        id: topBar
        currentWorkspace: window.currentWorkspace
        titles: Data.workspaceTitles
    }

    function updateOutputFormats(type) {
        outputFormatsModel.clear()
        var formats = Data.getOutputFormats(type)
        for (var i = 0; i < formats.length; i++)
            outputFormatsModel.append({"name": formats[i]})
    }

    function handleInputFile(path, dropzone, comboBox) {
        dropzone.droppedFile = path
        var type = Data.getFileType(path)

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
}
