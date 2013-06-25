import QtQuick 1.0

import org.maemo.fremantle 1.0

import "../config.js" as Config

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    ToolBarLayout {
        id: bottomBar

        ToolIcon {
            id: refreshButton
            iconId: "toolbar-refresh"
            onClicked: {
                nextbikeModel.init();
            }
        }

        Row {
            spacing: 0
            anchors.centerIn: parent

            SwitchButton {
                id: listButton
                height: bottomBar.height
                text: qsTr("List")
                selected: true
                onClicked: {
                    mapButton.selected = false;
                    showList();
                }
            }

            SwitchButton {
                id: mapButton
                height: bottomBar.height
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
        anchors.top: topBar.bottom; anchors.bottom: root.bottom
        anchors.right: root.right; anchors.left: parent.left
        visible: true
    }

    StationsMap {
        id: stationsMap
        anchors.top: topBar.bottom; anchors.bottom: root.bottom
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
        anchors.top: topBar.bottom; anchors.bottom: root.bottom;
    }

    Line {
        anchors.top: topBar.bottom
        shadow: false
        white: true
    }

    TopBar {
        id: topBar
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
