import QtQuick
import QtQuick.Controls

TextEdit {
    id: customText
    property alias textContent: customText.text

    readOnly: true
    selectByMouse: true
    wrapMode: TextEdit.Wrap
    color: Data.textColor
    font.family: Data.fontRegular
    font.pixelSize: 14
    selectionColor: Data.themeColor
    selectedTextColor: Data.selectedTextColor
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
}
