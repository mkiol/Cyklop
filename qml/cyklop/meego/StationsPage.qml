import QtQuick 1.1

import com.nokia.meego 1.0

import "../config.js" as Config

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
        showList();
        nextbikeModel.init();
    }

    ToolBarLayout {
        id: bottomBar

        ToolIcon {
            iconId: pageStack.depth > 1 ? "toolbar-back" : "toolbar-close"
            onClicked: {
                if(pageStack.depth>1) {
                    myMenu.close();
                    pageStack.pop();
                } else {
                    Qt.quit()
                }
            }
        }

        ToolIcon {
            id: refreshButton
            iconId: "toolbar-refresh"
            onClicked: {
                nextbikeModel.init();
            }
        }

        Row {
            spacing: 0
            anchors.bottom: parent.bottom

            SwitchButton {
                id: listButton
                height: bottomBar.height-1
                text: qsTr("List")
                selected: true
                onClicked: {
                    mapButton.selected = false;
                    showList();
                }
            }

            SwitchButton {
                id: mapButton
                height: bottomBar.height-1
                text: qsTr("Map")
                onClicked: {
                    listButton.selected = false;
                    showMap();
                }
            }
        }

        ToolIcon {
            id: menuButton
            iconId: "toolbar-view-menu"
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

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

    Notification {
        id: errorInfo
        anchors.verticalCenter: root.verticalCenter
        text: qsTr("Can't find stations :-(")
    }

    BusyPane {
        id: busy
        open: nextbikeModel.busy
        text: qsTr("Updating data...")
        anchors.top: root.top; anchors.bottom: root.bottom;
    }

    Notification {
        id: gpsInfo
        anchors.bottom: root.bottom
        anchors.margins: Config.MARGIN
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
        onBusyChanged: {
            if (!nextbikeModel.busy) {
                if(nextbikeModel.count()==0) {
                    errorInfo.show();
                }
                if(!positionSource.active || !settings.gps) {
                    gpsInfo.show();
                }

                if (stationsMap.visible)
                    stationsMap.refresh();
            }
        }
    }
}
