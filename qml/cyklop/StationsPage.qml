import QtQuick 1.0
import org.maemo.fremantle 1.0
import "config.js" as Config

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
                nextbikeModel.reload();
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

    BusyPane {
        id: busy
        //text: qsTr("updating data...")
        anchors.top: topBar.bottom; anchors.bottom: root.bottom;
    }

    Line {
        anchors.top: topBar.bottom
        shadow: true
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
        stationsMap.initCenter(positionSource.position.coordinate);
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
    }

    /*Connections {
        target: nextbikeModel
        onLandmarksReady: {
            console.log("nextbikeModel:LandmarksReady");
            busy.state = "hidden";
        }
    }*/

    Connections {
        target: landmarkModel
        onReady: {
            busy.state = "hidden";
        }

        onTimeout: {
            error.visible = true;
            busy.state = "hidden";
        }
    }

}
