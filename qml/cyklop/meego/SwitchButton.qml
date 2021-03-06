import QtQuick 1.1

import "../config.js" as Config

Item {
    id: root

    property string text
    property bool selected: false
    signal clicked()
    width: 100

    //color: selected ? Config.BGCOLOR_BANER : "#00000000"
    //color: selected ? Config.BGCOLOR_BANER : Config.BGCOLOR_DARK
    //color: selected ? Config.BGCOLOR_DARK : Config.BGCOLOR_BANER

    Rectangle {
        anchors.centerIn: parent
        width: text.width+30; height: 2*parent.height/3
        color: "black"
        opacity: 0.1
        radius: 10
        visible: mouse.pressed
    }

    Rectangle {
        color: selected ? Config.BGCOLOR_BANER : "#00000000"
        anchors.centerIn: parent
        width: text.width+30; height: 2*parent.height/3
        radius: 10
    }

    /*Image {
        source: "icons/vgreen.png"
        anchors.fill: parent
        fillMode: Image.TileHorizontally
        visible: selected
    }*/

    Text {
        id: text
        text: root.text
        color: root.selected ? Config.FGCOLOR_BANER : Config.FGCOLOR
        //color: root.selected ? Config.FGCOLOR : Config.FGCOLOR_BANER
        anchors.centerIn: parent
        font.family: Config.FONT_FAMILY
        font.pixelSize: Config.FONT_SIZE
        font.weight: Font.Bold
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            root.selected = true;
            root.clicked();
        }
    }
}
