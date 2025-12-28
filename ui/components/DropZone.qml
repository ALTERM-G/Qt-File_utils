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
    property int filesCount: 0

    readonly property int fileOnly: 0
    readonly property int multiFile: 1
    property int dropMode: fileOnly

    HoverHandler {
        acceptedDevices: PointerDevice.Mouse
        onHoveredChanged: dropzone.hovered = hovered
    }

    Text {
        id: mainText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        text: (dropzone.dropMode === dropzone.fileOnly)
              ? (dropzone.droppedFile === "" ? "Drop a file here" : dropzone.droppedFile)
              : "Drop files here"
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

    Image {
        id: fileIcon
        source: "../../assets/file.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: mainText.bottom
        anchors.topMargin: 10
        width: 100
        height: 100
        visible: dropzone.dropMode === dropzone.fileOnly ? dropzone.droppedFile !== "" : true
    }

    Text {
        id: filesCountText
        anchors.top: fileIcon.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        color: "lightgray"
        font.pixelSize: 16
        text: dropzone.filesCount > 0 ? dropzone.filesCount + " file(s) dropped" : ""
    }

    DropArea {
        anchors.fill: parent

        onDropped: drop => {
            if (!drop.hasUrls) return;

            if (dropzone.dropMode === dropzone.fileOnly) {
                var urlString = drop.urls[0].toString();
                var localPath = urlString.startsWith("file:///") ? urlString.substring(7)
                              : urlString.startsWith("file://") ? urlString.substring(6)
                              : urlString;

                var info = fileHelper.getInfo(localPath);
                if (info.isDir) return;

                dropzone.droppedFile = localPath;
                var fileType = window.extensionToTypeMap[info.extension] ?? "Unknown";
                dropzone.fileTypeLabel = fileType + (info.extension ? " (." + info.extension + ")" : "");
                dropzone.fileDropped(info.path, fileType);

                if (dropzone.infoPanel) {
                    dropzone.infoPanel.filePath = info.path;
                    dropzone.infoPanel.fileName = info.name;
                    dropzone.infoPanel.fileType = fileType;
                    dropzone.infoPanel.fileExtension = info.extension;
                    dropzone.infoPanel.fileSize = info.size;
                    dropzone.infoPanel.lastModified = info.lastModified;
                }

            } else if (dropzone.dropMode === dropzone.multiFile) {
                var count = 1;
                for (var i = 0; i < drop.urls.length; i++) {
                    var urlString = drop.urls[i].toString();
                    var localPath = urlString.startsWith("file:///") ? urlString.substring(7)
                                  : urlString.startsWith("file://") ? urlString.substring(6)
                                  : urlString;

                    var info = fileHelper.getInfo(localPath);
                    if (info.isDir) continue;

                    var fileType = window.extensionToTypeMap[info.extension] ?? "Unknown";
                    dropzone.fileDropped(info.path, fileType);
                    count++;

                    if (dropzone.infoPanel) {
                        dropzone.infoPanel.filePath = info.path;
                        dropzone.infoPanel.fileName = info.name;
                        dropzone.infoPanel.fileType = fileType;
                        dropzone.infoPanel.fileExtension = info.extension;
                        dropzone.infoPanel.fileSize = info.size;
                        dropzone.infoPanel.lastModified = info.lastModified;
                    }
                }
                dropzone.filesCount = count;
            }
        }
        onEntered: dropzone.hovered = true
        onExited: dropzone.hovered = false
    }
}
