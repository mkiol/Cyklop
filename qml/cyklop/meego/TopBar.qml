import QtQuick 1.1

import "../config.js" as Config
import "../globals.js" as Globals

Item {
    id: root

    property string text
    property bool showImage: true
    property variant stack: Globals.pageStack == null ? pageStack : Globals.pageStack

    height: 70

    anchors.top: parent.top
    anchors.right: parent.right; anchors.left: parent.left

    Rectangle {
        id: header
        color: Config.BGCOLOR_BANER
        height: root.height;
        anchors.right: parent.right; anchors.left: parent.left
    }

    /*Image {
        id: backButton
        source: stack.depth > 1 ? "../icons/maemoBackIcon.png" : "../icons/maemoCloseIcon.png"
        anchors.right: root.right; anchors.top: root.top

        MouseArea {
            anchors.fill: parent
            onClicked: stack.depth > 1 ? stack.pop() : Qt.quit()
        }
    }*/

    Image {
        id: topBar
        source: "../icons/top.png"
        //anchors.left: root.left; //anchors.leftMargin: Config.MARGIN
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        visible: root.showImage
    }

    /*Rectangle {
        color: "black"; opacity: 0.2
        height: root.height; width: 1
        anchors.right: backButton.left;
    }*/

    /*Image {
        id: taskButton
        source: "../icons/maemoTaskSwitcherIcon.png"
        anchors.left: root.left; anchors.top: root.top

        MouseArea {
            anchors.fill: parent
            onClicked: Utils.minimizeWindow()
        }
    }*/

    /*Rectangle {
        color: "black"; opacity: 0.2
        height: root.height; width: 1
        anchors.left: taskButton.right
    }*/

    Rectangle {
        color: "black"; opacity: 0.2
        height: 1;
        anchors.bottom: header.bottom;
        anchors.right: parent.right; anchors.left: parent.left
    }

    Text {
        text: root.text
        font.family: Config.FONT_FAMILY
        font.weight: Font.Bold
        font.pixelSize: 24
        color: Config.FGCOLOR_BANER
        anchors.centerIn: root
    }
}
