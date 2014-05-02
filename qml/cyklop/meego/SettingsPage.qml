import QtQuick 1.1

import com.nokia.meego 1.0

import "../config.js" as Config

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    property variant stack: pageStack

    ToolBarLayout {
        id: bottomBar

        ToolIcon {
            iconId: stack.depth > 1 ? "toolbar-back" : "toolbar-close"
            onClicked: {
                if(stack.depth>1) {
                    //myMenu.close();
                    stack.pop();
                } else {
                    Qt.quit()
                }
            }
        }

        /*ToolIcon {
            id: menuButton
            iconId: "toolbar-view-menu"
            anchors.right: bottomBar.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }*/
    }


    Column {
        anchors.top: root.top; anchors.bottom: root.bottom
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.margins: Config.MARGIN
        spacing: Config.MARGIN

        Item {
            anchors.left: parent.left; anchors.right: parent.right; anchors.margins: Config.MARGIN; height: 50
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Enable GPS")
            }
            Switch {
                id: gpsSwitch
                checked: settings.gps
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter

                onCheckedChanged: {
                    settings.gps = checked;
                }
            }
        }

    }

    /*Line {
        anchors.top: topBar.bottom
        shadow: false
        white: true
    }

    TopBar {
        id: topBar
    }*/

}
