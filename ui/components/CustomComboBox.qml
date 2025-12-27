import QtQuick 2.12
import QtQuick.Controls 2.12

ComboBox {
    id: control
    width: 200
    height: 40
    model: ["Video", "Image", "Audio", "Document"]

    contentItem: Text {
        text: control.displayText !== "" ? control.displayText : "Select type"
        anchors.fill: parent
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.bold: true
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Text {
        text: "▾"
        color: "#888888"
        font.pixelSize: 24
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 6
        color: control.hovered ? "#4b4b4b" : "#3a3a3a"
        border.color: "#888888"
        border.width: 3

        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    popup: Popup {
        width: control.width
        implicitHeight: control.model.length * 43

        background: Rectangle {
            anchors.fill: parent
            radius: 6
            color: "#3a3a3a"
            border.color: "#888888"
            border.width: 3
        }

        ListView {
            anchors.fill: parent
            model: control.popup.visible ? control.delegateModel : null
            interactive: false

            delegate: ItemDelegate {
                width: parent.width
                height: 40
                contentItem: Text {
                    text: modelData
                    font.pixelSize: 18
                    font.family: "JetBrains Mono"
                    font.bold: true
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    anchors.fill: parent
                    color: hovered ? "#dd1124" : "transparent"
                    radius: 6
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        control.currentIndex = index
                        control.popup.visible = false
                    }
                }
            }
        }
    }
}
