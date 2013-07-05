import QtQuick 1.1

import com.nokia.symbian 1.1

import "../config.js" as Config

Item {
    id: root

    property string text

    anchors.right: parent.right; anchors.left: parent.left
    height: box.height
    state: "hidden"

    Rectangle {
        id: box
        width: label.width + 2*Config.MARGIN
        anchors.centerIn: root
        anchors.margins: Config.MARGIN
        height: label.height + 2*Config.MARGIN
        border.color: "#aaaaaa"
        border.width: 1
        color: Config.BGCOLOR
        radius: 10
    }

    Label {
        id: label
        text: root.text
        opacity: 0.8
        platformInverted: true
        anchors.centerIn: box
    }

    MouseArea {
        anchors.fill: box
        onClicked: root.state = "hidden"
    }

    function show() {
        state = "visible"
        time.restart();
    }

    function open() {
        show();
    }


    function hide() {
        state="hidden";
    }

    Timer {
        id: time
        interval: 3000
        onTriggered: {
            root.hide();
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; opacity: 1 }
            PropertyChanges { target: root; width: label.width + 2*Config.MARGIN }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; width: 0 }
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutBack }
        NumberAnimation { properties: "width"; easing.type: Easing.InOutBack}
    }

}
