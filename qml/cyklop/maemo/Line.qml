import QtQuick 1.0

import "../config.js" as Config

Item {
    id: root

    property bool shadow: false
    property bool white: false

    anchors.right: parent.right; anchors.left: parent.left
    height: 1

    Rectangle {
        color: "white"; opacity: 0.8
        height: 1;
        anchors.right: root.right; anchors.left: root.left
        visible: white
    }

    Image {
        source: "../icons/hshadow.png"
        anchors.left: root.left; anchors.right: root.right
        anchors.top: root.top
        height: 5
        fillMode: Image.TileHorizontally
        visible: shadow
    }

}
