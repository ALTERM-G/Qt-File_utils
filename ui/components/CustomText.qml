import QtQuick
import QtQuick.Controls

TextEdit {
    id: customText
    property alias textContent: customText.text

    readOnly: true
    selectByMouse: true
    wrapMode: TextEdit.Wrap
    color: "white"
    font.family: "JetBrains Mono"
    font.pixelSize: 14
    selectionColor: "#dd1124"       // background color of selected text
    selectedTextColor: "#000000"
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
}
