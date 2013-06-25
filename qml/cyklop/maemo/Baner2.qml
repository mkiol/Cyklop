import QtQuick 1.0

import "../config.js" as Config

Rectangle {
    id: root

    property string text
    property string textcolor: Config.FGCOLOR

    height: 50
    width: label.width + Config.MARGIN

    anchors.horizontalCenter: parent.horizontalCenter

    color: Config.BGCOLOR_DARK

    border.color: "#aaaaaa"
    border.width: 1

    radius: 10

    Text {
        id: label
        color: root.textcolor
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        font.pixelSize: Config.FONT_SIZE
        font.family: Config.FONT_FAMILY
        font.weight: Font.Bold
        text: root.text
        elide: Text.ElideRight
        horizontalAlignment:Text.AlignHCenter
    }

}
