import QtQuick
import QtQuick.Controls

CustomPopup {
    id: settingsPopup
    width: 250
    height: 350
    x: parent.width - width - 10
    y: 40

    background: AppRect {
        anchors.fill: parent
    }
}
