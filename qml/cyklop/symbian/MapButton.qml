import QtQuick 1.1

import "../config.js" as Config

Item {
    id: root

    property string text
    property url source
    signal clicked

    Rectangle {
        id: rect
        anchors.fill: parent
        color: ma.pressed ? "gray" : "#aaffffff"
        border.color: "#aaaaaa"
        border.width: 1
    }

    Text {
        text: root.text
        color: ma.pressed ? "white" : "black"
        font.pixelSize: 38
        anchors.centerIn: rect
    }

    Image {
        source: root.source
        anchors.centerIn: rect
        height: 30; width: 30
    }

    MouseArea {
        id: ma
        anchors.fill: rect
        onClicked: root.clicked()
    }

}

