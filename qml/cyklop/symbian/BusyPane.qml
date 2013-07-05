import QtQuick 1.1

import com.nokia.symbian 1.1

import "../config.js" as Config

Item {
    id: root

    property string text: qsTr("Updating...")
    property bool running: false

    anchors.right: parent.right; anchors.left: parent.left
    opacity: 1.0
    state: "visible"

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; opacity: 1.0 }
            PropertyChanges { target: root; running: true }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; opacity: 0.0 }
            PropertyChanges { target: root; running: false }
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
            running: root.running
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
        enabled: root.state=="visible" ? true : false
    }

    /*Rectangle {
        id: label
        width: row.width + 2*Config.MARGIN
        anchors.centerIn: root
        anchors.margins: Config.MARGIN
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
            running: root.running
            anchors.verticalCenter: row.verticalCenter
            width: 25; height: 25
        }

        Label {
            text: root.text
            platformInverted: true
            opacity: 0.8
            anchors.verticalCenter: row.verticalCenter
        }
    }*/



}
