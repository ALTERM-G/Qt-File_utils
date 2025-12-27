import QtQuick
import QtQuick.Controls

Rectangle {
    id: topBar
    width: parent.width
    height: 40
    color: "#121212"
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
            model: 5

            Button {
                text: (index + 1).toString()
                implicitWidth: 40
                implicitHeight: 30
                checkable: true
                checked: window.currentWorkspace === (index + 1)
                font.family: "JetBrains Mono"
                font.pointSize: 12
                font.bold: true

                background: Rectangle {
                    radius: 4
                    color: checked ? "#8a8a8a" : hovered ? "#4a4a4a" : "#333333"

                    Behavior on color {
                        ColorAnimation {
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? "#121212" : "#e6e6e6"
                    font.family: parent.font.family
                    font.pointSize: parent.font.pointSize
                    font.bold: parent.font.bold
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

        color: "#e6e6e6"
        font.family: "JetBrains Mono"
        font.pointSize: 13
        font.bold: true
        anchors.centerIn: parent
        elide: Text.ElideRight
    }
}
