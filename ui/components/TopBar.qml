import QtQuick
import QtQuick.Controls

Rectangle {
    id: topBar
    width: parent.width
    height: 40
    color: Theme.topBarColor
    z: 1
    property int currentWorkspace: 1
    property var titles: []

    MouseArea {
        anchors.fill: parent
        z: 0
        acceptedButtons: Qt.LeftButton
        onPressed: window.startSystemMove()
    }

    Row {
        z: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 10

        Repeater {
            model: 4

            Button {
                text: (index + 1).toString()
                implicitWidth: 40
                implicitHeight: 30
                checkable: true
                checked: window.currentWorkspace === (index + 1)
                font.family: Data.fontBold
                font.pointSize: 12

                background: Rectangle {
                    radius: 4
                    color: checked ? Theme.borderColor : hovered ? Theme.hoverBackgroundColor : Theme.backgroundColor

                    Behavior on color {
                        ColorAnimation {
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? Theme.topBarColor : Theme.topBarTextColor
                    font.family: parent.font.family
                    font.pointSize: parent.font.pointSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        window.currentWorkspace = index + 1
                    }
                }
            }
        }
    }

    Text {
        text: titles.length >= currentWorkspace
              ? titles[currentWorkspace - 1]
              : ""

        color: Theme.topBarTextColor
        font.family: Data.fontBold
        font.pointSize: 13
        anchors.centerIn: parent
        elide: Text.ElideRight
    }

    SVGObject {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.borderColor
    }

    Rectangle {
        id: buttonRect
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: 30
        height: 30
        color: "transparent"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                settingsPopup.opened ? settingsPopup.close() : settingsPopup.open()
            }
        }

        SVGObject {
            anchors.centerIn: parent
            path: "../../assets/icons/settings/settings.svg"
            color: mouseArea.containsMouse ? Theme.themeColor : Theme.textColor

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Settings {
            id: settingsPopup
        }
    }
}
