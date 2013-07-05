import QtQuick 1.1

import com.nokia.symbian 1.1

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
        anchors.fill: parent
        color: "red"
    }

    Rectangle {
        anchors.centerIn: parent
        width: text.width+30; height: 2*parent.height/3
        color: "white"
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

    Label {
        id: text
        text: root.text
        //color: root.selected ? Config.FGCOLOR_BANER : Config.FGCOLOR
        anchors.centerIn: parent
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
