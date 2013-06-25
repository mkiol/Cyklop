import QtQuick 1.1

import com.nokia.meego 1.0

import "../config.js" as Config

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

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

    Label {
        id: error
        anchors.centerIn: root
        visible: false
        text: qsTr("Can't find stations :-(");
    }

    Notification {
        id: gpsInfo
        anchors.bottom: root.bottom
        anchors.margins: Config.MARGIN
        text: qsTr("GPS is disabled!")
    }

    BusyPane {
        id: busy
        text: qsTr("Updating data...")
        anchors.top: root.top; anchors.bottom: root.bottom;
    }

    /*Line {
        anchors.top: topBar.bottom
        shadow: false
        white: true
    }

    TopBar {
        id: topBar
    }*/

    /*ToolIcon {
        iconId: "toolbar-refresh"
        anchors.right: topBar.right
        anchors.verticalCenter: topBar.verticalCenter
    }*/

    /*ToolButton {
        iconSource: pressed ? "image://theme/icon-m-toolbar-refresh-white-selected" : "image://theme/icon-m-toolbar-refresh-white"
        anchors.right: topBar.right
        anchors.verticalCenter: topBar.verticalCenter
        onClicked: {
            nextbikeModel.init();
        }
    }*/

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
            error.visible = false;
            busy.text = qsTr("Updating data...");
            busy.state = "visible";
        }
        onReady: {
            error.visible = false;
            busy.text = qsTr("Finding nearest stations...");
        }
        onSorted: {
            busy.state = "hidden";
            if(nextbikeModel.count()==0) {
                error.visible = true;
            }
            if(!positionSource.active || !Utils.gps()) {
                gpsInfo.show();
            }
            stationsMap.init();
        }
    }

}
