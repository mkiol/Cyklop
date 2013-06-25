import QtQuick 1.0

import "../config.js" as Config

Rectangle {
    id: root

    property string text
    property string textcolor: Config.FGCOLOR
    height: 50

    anchors.left: parent.left; anchors.right: parent.right
    //color: Config.BGCOLOR_DARK
    color: "#63b600"
    radius: 10

    Text {
        color: root.textcolor
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        width: root.width-Config.MARGIN
        font.pixelSize: Config.FONT_SIZE
        font.family: Config.FONT_FAMILY
        font.weight: Font.Bold
        text: root.text
        elide: Text.ElideNone
        wrapMode: Text.WordWrap
        horizontalAlignment:Text.AlignHCenter
    }

    Rectangle {
        color: "black"; opacity: 0.2
        height: 1;
        anchors.bottom: root.bottom;
        anchors.right: parent.right; anchors.left: parent.left
    }
}

