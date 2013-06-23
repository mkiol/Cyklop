import QtQuick 1.0
import "config.js" as Config

Item {
    id: root

    property string text
    property bool selected: false
    signal clicked()
    width: 120

    //color: selected ? Config.BGCOLOR_BANER : "#00000000"
    //color: selected ? Config.BGCOLOR_BANER : Config.BGCOLOR_DARK
    //color: selected ? Config.BGCOLOR_DARK : Config.BGCOLOR_BANER

    Rectangle {
        anchors.centerIn: parent
        width: 2*parent.width/3; height: 2*parent.height/3
        color: "black"
        opacity: 0.1
        radius: 10
        visible: mouse.pressed
    }

    Rectangle {
        anchors.fill: parent
        color: selected ? Config.BGCOLOR_BANER : "#00000000"
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
