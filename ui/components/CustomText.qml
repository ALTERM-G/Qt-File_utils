import QtQuick
import QtQuick.Controls

TextEdit {
    id: customText
    property alias textContent: customText.text

    readOnly: true
    selectByMouse: true
    wrapMode: TextEdit.Wrap
    color: Theme.textColor
    font.family: Typography.fontRegular
    font.pixelSize: 14
    selectionColor: Theme.themeColor
    selectedTextColor: Theme.selectedTextColor
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
}
