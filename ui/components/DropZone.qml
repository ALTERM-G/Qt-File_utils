import QtQuick
import QtQuick.Controls
import Data 1.0

Rectangle {
    id: dropzone
    width: 700
    height: 400
    radius: 16
    color: hovered ? "#3a3a3a" : "#333333"

    Canvas {
        id: border_canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.lineWidth = 4;
            ctx.strokeStyle = dropzone.hovered ? "#dd1124" : "#888888";
            ctx.setLineDash(dropzone.hovered ? [] : [6, 3]);
            ctx.lineJoin = "round";

            var r = dropzone.radius;
            var i = ctx.lineWidth / 2;
            var w = width - 2*i;
            var h = height - 2*i;

            ctx.beginPath();
            ctx.moveTo(i + r, i);
            ctx.lineTo(i + w - r, i);
            ctx.quadraticCurveTo(i + w, i, i + w, i + r);
            ctx.lineTo(i + w, i + h - r);
            ctx.quadraticCurveTo(i + w, i + h, i + w - r, i + h);
            ctx.lineTo(i + r, i + h);
            ctx.quadraticCurveTo(i, i + h, i, i + h - r);
            ctx.lineTo(i, i + r);
            ctx.quadraticCurveTo(i, i, i + r, i);
            ctx.closePath();
            ctx.stroke();
        }
    }

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
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.centerIn: parent
        visible: dropzone.droppedFile === ""
        font.family: "JetBrains Mono"
        font.pixelSize: 16
        font.bold: true
        color: "white"
        wrapMode: Text.NoWrap
        elide: Text.ElideNone
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        width: 600
        text:
            "██████╗ ██████╗  ██████╗ ██████╗     ███████╗██╗██╗     ███████╗\n" +
            "██╔══██╗██╔══██╗██╔═══██╗██╔══██╗    ██╔════╝██║██║     ██╔════╝\n" +
            "██║  ██║██████╔╝██║   ██║██████╔╝    █████╗  ██║██║     █████╗  \n" +
            "██║  ██║██╔══██╗██║   ██║██╔═══╝     ██╔══╝  ██║██║     ██╔══╝  \n" +
            "██████╔╝██║  ██║╚██████╔╝██║         ██║     ██║███████╗███████╗\n" +
            "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝         ╚═╝     ╚═╝╚══════╝╚══════╝"
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        visible: dropzone.droppedFile !== ""

        Image {
            id: fileIcon
            source: "../../assets/icons/file.svg"
            width: 60
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: filePathText
            width: dropzone.width - 40
            font.family: "JetBrains Mono"
            font.pixelSize: 20
            font.bold: true
            color: "white"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: dropzone.droppedFile
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    DropArea {
        anchors.fill: parent

        onEntered: function(drag) {
            if (drag.hasUrls) {
                dropzone.hovered = true
                border_canvas.requestPaint()
            }
        }

        onExited: {
            dropzone.hovered = false
            border_canvas.requestPaint()
        }

        onDropped: drop => {
            dropzone.hovered = false
            border_canvas.requestPaint()
            if (!drop.hasUrls) return;

            if (dropzone.dropMode === dropzone.fileOnly) {
                var urlString = drop.urls[0].toString();
                var localPath = urlString.startsWith("file:///") ? urlString.substring(7)
                              : urlString.startsWith("file://") ? urlString.substring(6)
                              : urlString;

                var info = fileHelper.getInfo(localPath);
                if (info.isDir) return;

                dropzone.droppedFile = localPath;
                var fileType = Data.extensionToTypeMap[info.extension] ?? "Unknown";
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
                var count = 0;
                for (var i = 0; i < drop.urls.length; i++) {
                    var urlString = drop.urls[i].toString();
                    var localPath = urlString.startsWith("file:///") ? urlString.substring(7)
                                  : urlString.startsWith("file://") ? urlString.substring(6)
                                  : urlString;

                    var info = fileHelper.getInfo(localPath);
                    if (info.isDir) continue;

                    var fileType = Data.extensionToTypeMap[info.extension] ?? "Unknown";
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
    }
}
