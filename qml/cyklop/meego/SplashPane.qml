import QtQuick 1.1

import com.nokia.meego 1.0

import "../config.js" as Config

Item {
    id: root

    property bool running: false
    height: parent.height; width: parent.width

    state: "visible"

    Rectangle {
        anchors.fill: parent
        color: Config.BGCOLOR_BANER
    }

    /*Image {
        id: quitButton
        source: "../icons/maemoCloseIcon.png"
        anchors.right: root.right
        anchors.top: root.top

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }*/

    Connections {
        target: nextbikeModel
        onReady: {
            root.state = "hidden";
        }
    }

    Connections {
        target: cityModel
        onReady: {
            root.state = "hidden";
        }
        onBusy: {
            root.state = "hidden";
        }
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
            running: root.running
            anchors.verticalCenter: row.verticalCenter
            platformStyle: BusyIndicatorStyle {
                size: "small"
                spinnerFrames: "image://theme/spinnerinverted"
            }
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
            PropertyChanges { target: root; running: true }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; y: -root.height }
            //PropertyChanges { target: root; visible: false }
            PropertyChanges { target: root; running: false }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutCubic;
            duration: root.height/2;
        }
    }

}
