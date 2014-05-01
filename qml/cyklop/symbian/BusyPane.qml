import QtQuick 1.1

import com.nokia.symbian 1.1

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

    /*Rectangle {
        id: box
        anchors.fill: parent
        color: "white"
        opacity: 0.2
    }*/

    Rectangle {
        id: box
        anchors.bottom: root.bottom; anchors.left: root.left; anchors.right: root.right
        height: 60
        color: "#222222"
        opacity: 0.9
    }

    Row {
        id: row
        anchors.left: box.left; anchors.verticalCenter: box.verticalCenter
        anchors.margins: 10
        spacing: Config.MARGIN/2

        BusyIndicator {
            running: root.open
            anchors.verticalCenter: row.verticalCenter
            width: 25; height: 25
        }

        Label {
            text: root.text
            opacity: 0.8
            anchors.verticalCenter: row.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: root
        enabled: root.open
    }
}
