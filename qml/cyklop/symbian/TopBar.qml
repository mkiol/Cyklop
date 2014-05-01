import QtQuick 1.1

import "../config.js" as Config

Item {
    id: root

    property bool showImage: true
    property variant stack: pageStack

    height: 70

    anchors.top: parent.top
    anchors.right: parent.right; anchors.left: parent.left

    Rectangle {
        id: header
        color: Config.BGCOLOR_BANER
        height: root.height;
        anchors.right: parent.right; anchors.left: parent.left
    }

    Image {
        id: topBar
        source: "../icons/top.png"
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        visible: root.showImage
    }

    Rectangle {
        color: "black"; opacity: 0.2
        height: 1;
        anchors.bottom: header.bottom;
        anchors.right: parent.right; anchors.left: parent.left
    }

}
