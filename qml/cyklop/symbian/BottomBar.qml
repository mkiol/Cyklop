import QtQuick 1.1

import "../config.js" as Config

Item {
    id: root

    height: 70

    anchors.bottom: parent.bottom
    anchors.right: parent.right; anchors.left: parent.left

    Rectangle {
        id: header

        color: Config.BGCOLOR_DARK

        height: root.height;
        anchors.bottom: parent.bottom;
        anchors.right: parent.right; anchors.left: parent.left

        visible: false
    }

}
