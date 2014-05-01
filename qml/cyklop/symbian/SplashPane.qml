import QtQuick 1.1
import com.nokia.symbian 1.1

import "../config.js" as Config

Item {
    id: root

    property bool open

    height: parent.height; width: parent.width

    state: open ? "visible" : "hidden"

    onOpenChanged: {
        state = open ? "visible" : "hidden";
    }

    Rectangle {
        anchors.fill: parent
        color: Config.BGCOLOR_BANER
    }

    Column {
        anchors.centerIn: parent
        spacing: 50

        Image {
            source: "../icons/cyklop.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Row {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 2* Config.MARGIN
        spacing: Config.MARGIN

        BusyIndicator {
            running: root.open
            anchors.verticalCenter: row.verticalCenter
            width: 25
            height: 25
        }

        Label {
            id: status
            text: qsTr("loading...")
            color: Config.FGCOLOR_BANER
            anchors.verticalCenter: row.verticalCenter
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; y: 0}
            PropertyChanges { target: root; visible: true }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; y: -root.height }
            PropertyChanges { target: root; visible: false }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutCubic;
            duration: root.height/2;
        }
    }

}
