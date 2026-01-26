import QtQuick
import QtQuick.Controls

ToolTip {
    id: customToolTip

    background: Rectangle {
        radius: 6
        color: Theme.backgroundColor
        border.color: Theme.borderColor
        border.width: 1
    }

    contentItem: Text {
        text: customToolTip.text
        color: Theme.textColor
        font.family: Data.fontBold
        font.pointSize: 10
        padding: 6
    }

    enter: Transition {
        NumberAnimation {
            property: "scale"
            from: 0.8
            to: 1
            duration: 120
        }
    }
}
