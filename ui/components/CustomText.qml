import QtQuick
import QtQuick.Controls
import Data

TextEdit {
    id: customText
    property alias textContent: customText.text

    readOnly: true
    selectByMouse: true
    wrapMode: TextEdit.Wrap
    color: "white"
    font.family: Data.fontRegular
    font.pixelSize: 14
    selectionColor: "#dd1124"
    selectedTextColor: "#000000"
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
}
