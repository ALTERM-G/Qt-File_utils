import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    width: 200
    height: 40
    hoverEnabled: true

    contentItem: Text {
        text: control.displayText !== "" ? control.displayText : "Select"
        anchors.fill: parent
        font.pixelSize: 18
        font.family: Data.fontBold
        color: Theme.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Text {
        text: "▾"
        color: Theme.borderColor
        font.pixelSize: 24
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 6
        color: control.hovered ? Theme.hoverBackgroundColor : Theme.backgroundColor
        border.color: Theme.borderColor
        border.width: 3

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: control.open()
        }
    }

    popup: Popup {
        width: control.width
        implicitHeight: control.count * 47

        background: Rectangle {
            radius: 6
            color: Theme.backgroundColor
            border.color: Theme.borderColor
            border.width: 3
        }

        Column {
            anchors.fill: parent
            spacing: 0

            Repeater {
                model: control.model

                delegate: ItemDelegate {
                    width: parent ? parent.width : 200
                    height: 43

                    contentItem: Text {
                        text: control.textRole ? model[control.textRole] : modelData
                        font.pixelSize: 18
                        font.family: Data.fontBold
                        color: Theme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        anchors.fill: parent
                        color: hovered ? Theme.themeColor : "transparent"
                        radius: 6
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            control.currentIndex = index
                            control.popup.close()
                        }
                    }
                }
            }
        }
    }
}
