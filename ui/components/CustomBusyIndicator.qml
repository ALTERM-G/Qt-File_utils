import QtQuick
import QtQuick.Controls

BusyIndicator {
    id: root
    property bool active: false
    property int indicatorSize: 48
    running: active
    visible: active
    width: indicatorSize
    height: indicatorSize
    anchors.centerIn: parent
}
