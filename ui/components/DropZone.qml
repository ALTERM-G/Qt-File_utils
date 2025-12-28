import QtQuick
import QtQuick.Controls

Rectangle {
    id: dropzone
    width: 700
    height: 350
    radius: 16
    color: hovered ? "#3a3a3a" : "#333333"
    border.color: hovered ? "#dd1124" : "#888888"
    border.width: 4

    signal fileDropped(string path, string type)
    property bool hovered: false
    property string droppedFile: ""
    property string fileTypeLabel: ""
    property InfoPanel infoPanel

    HoverHandler {
        acceptedDevices: PointerDevice.Mouse
        onHoveredChanged: dropzone.hovered = hovered
    }

    Text {
        id: mainText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        text: dropzone.droppedFile === "" ? "Drop a file here" : dropzone.droppedFile
        color: "white"
        font.pixelSize: 24
        font.family: "JetBrains Mono"
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        width: parent.width - 20
        elide: Text.ElideMiddle
    }

    Text {
        id: typeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: mainText.bottom
        anchors.topMargin: 10
        text: dropzone.fileTypeLabel
        color: "lightgray"
        font.pixelSize: 20
        font.family: "JetBrains Mono"
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        id: fileIcon
        source: "../../assets/file.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: typeLabel.bottom
        width: 100
        height: 100
        visible: dropzone.droppedFile !== ""
    }

    DropArea {
        anchors.fill: parent

        onDropped: drop => {
            if (drop.hasUrls && drop.urls.length > 0) {
                var urlString = drop.urls[0].toString();
                var localPath = urlString;
                if (urlString.startsWith("file:///")) localPath = urlString.substring(7);
                else if (urlString.startsWith("file://")) localPath = urlString.substring(6);
                dropzone.droppedFile = localPath;
                var info = fileHelper.getInfo(localPath);
                var ext = info.extension || "";
                var fileType = "Unknown";
                if (ext !== "" && window.extensionToTypeMap[ext] !== undefined)
                    fileType = window.extensionToTypeMap[ext];
                dropzone.fileTypeLabel = fileType + (ext ? " (." + ext + ")" : "");
                dropzone.fileDropped(info.path, fileType);
                if (dropzone.infoPanel) {
                    dropzone.infoPanel.filePath = info.path;
                    dropzone.infoPanel.fileName = info.name;
                    dropzone.infoPanel.fileType = fileType;
                    dropzone.infoPanel.fileExtension = info.extension;
                    dropzone.infoPanel.fileSize = info.size;
                    dropzone.infoPanel.lastModified = info.lastModified;
                }
            }
        }
        onEntered: dropzone.hovered = true
        onExited: dropzone.hovered = false
    }
}
