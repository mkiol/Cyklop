import QtQuick 1.1

import com.nokia.symbian 1.1
import com.nokia.extras 1.1

import "../config.js" as Config

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    ToolBarLayout {
        id: bottomBar

        ToolButton {
            id: backButton
            anchors.left: parent.left
            //iconSource: pageStack.depth > 1 ? "toolbar-back" : "toolbar-close"
            iconSource: "toolbar-back"
            onClicked: {
                if(pageStack.depth>1) {
                    myMenu.close();
                    pageStack.pop();
                } else {
                    Qt.quit()
                }
            }
        }

        ToolButton {
            id: refreshButton
            anchors.left: backButton.right
            iconSource: "toolbar-refresh"
            onClicked: {
                nextbikeModel.init();
            }
        }

        TabBar {
            anchors.left: refreshButton.right
            anchors.right: menuButton.left
            TabButton {
                id: listButton
                text: qsTr("List")
                checked: true
                onClicked: {
                    mapButton.checked = false;
                    checked = true;
                    showList();
                }
            }

            TabButton {
                id: mapButton
                text: qsTr("Map")
                onClicked: {
                    listButton.checked = false;
                    checked = true;
                    showMap();
                }
            }
        }

        ToolButton {
            id: menuButton
            iconSource: "toolbar-view-menu"
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

    }

    Component.onCompleted: {
        showList();
    }

    StationsList {
        id: stationsList
        anchors.top: root.top; anchors.bottom: root.bottom
        anchors.right: root.right; anchors.left: parent.left
        visible: true
    }

    StationsMap {
        id: stationsMap
        anchors.top: root.top; anchors.bottom: root.bottom
        anchors.right: root.right; anchors.left: parent.left
        visible: false
    }

    BusyPane {
        id: busy
        text: qsTr("Updating data...")
        anchors.top: root.top; anchors.bottom: root.bottom;
    }

    InfoBanner {
        id: errorInfo
        text: qsTr("Can't find stations :-(")
    }

    InfoBanner {
        id: gpsInfo
        text: qsTr("GPS is disabled!")
    }

    function showList() {
        stationsMap.visible = false;
        stationsList.visible = true;
    }

    function showMap() {
        stationsList.visible = false;
        stationsMap.visible = true;
        stationsMap.init();
    }

    Connections {
        target: nextbikeModel
        onBusy: {
            busy.text = qsTr("Updating data...");
            busy.state = "visible";
        }
        onReady: {
            if(positionSource.active) {
                gpsInfo.text = qsTr("Waiting for GPS...");
                gpsInfo.open();
            }
            busy.text = qsTr("Finding nearest stations...");
        }
        onSorted: {
            busy.state = "hidden";
            if(nextbikeModel.count()==0) {
                errorInfo.open();
            }
            if(!positionSource.active || !Utils.gps()) {
                gpsInfo.open();
            }
            stationsMap.init();
        }
    }

}
