import QtQuick 1.1

import com.nokia.symbian 1.1
import com.nokia.extras 1.1

import "../config.js" as Config

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    property variant stack: pageStack

    ToolBarLayout {
        id: bottomBar

        ToolButton {
            id: backButton
            iconSource: "toolbar-back"
            onClicked: {
                if(stack.depth>1) {
                    stack.pop();
                } else {
                    Qt.quit()
                }
            }
        }
    }
    Column {
        ListItem {
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: qsTr("Enable GPS")
            }
            Switch {
                checked: settings.gps
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10

                onClicked: {
                    settings.gps = checked;
                }
            }
        }

        /*ListItem {
            visible: settings.gps

            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: qsTr("GPS interval (ms)")
            }
            TextField {
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                maximumLength: 6
                text: settings.updateInterval
                width: 100
                enabled: settings.gps
            }
        }*/
    }

}
