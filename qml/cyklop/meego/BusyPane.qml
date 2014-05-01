import QtQuick 1.1

import com.nokia.meego 1.0

import "../config.js" as Config

Item {
    id: root

    property string text: qsTr("Updating...")
    property bool open: false

    anchors.right: parent.right; anchors.left: parent.left
    opacity: 1.0
    state: open ? "visible" : "hidden"

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; opacity: 1.0 }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; opacity: 0.0 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutCubic;
            duration: 200;
        }
    }

    Rectangle {
        id: box
        anchors.fill: parent
        color: Config.BGCOLOR
        opacity: 0.6
    }

    MouseArea {
        anchors.fill: box
        enabled: root.open
    }

    Rectangle {
        id: label
        width: row.width + 2*Config.MARGIN
        //anchors.bottom: root.bottom
        anchors.centerIn: root
        anchors.margins: Config.MARGIN
        //anchors.horizontalCenter: root.horizontalCenter
        height: row.height + 2*Config.MARGIN
        border.color: "#aaaaaa"
        border.width: 1
        color: Config.BGCOLOR
        radius: 10
    }

    Row {
        id: row
        anchors.centerIn: label
        spacing: Config.MARGIN

        BusyIndicator {
            running: root.open
            platformStyle: BusyIndicatorStyle { size: "small" }
            anchors.verticalCenter: row.verticalCenter
        }

        Label {
            text: root.text
            //font.pixelSize: Config.FONT_SIZE
            //font.family: Config.FONT_FAMILY
            opacity: 0.8
            anchors.verticalCenter: row.verticalCenter
        }
    }

}
