import QtQuick 1.0

import org.maemo.fremantle 1.0

import "../config.js" as Config
import "../globals.js" as Globals

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    ToolBarLayout {
        id: bottomBar

        /*ToolIcon {
            id: refreshButton
            iconId: "toolbar-refresh"
            onClicked: {
                nextbikeModel.reload();
            }
        }*/

        ToolIcon {
            id: menuButton
            iconId: "toolbar-view-menu"
            anchors.right: parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

    }

    Component.onCompleted: {
        cityModel.init();
    }

    ListView {
        id: listView

        anchors.margins: Config.MARGIN
        anchors.left: root.left; anchors.right: root.right
        anchors.top: topBar.bottom; anchors.bottom: root.bottom

        model: cityModel
        spacing: 10
        visible: true

        /*header: Item {
            height: 80
            width: parent.width

            Label {
                font.family: Config.FGCOLOR
                font.weight: Font.Bold
                font.pixelSize: 26
                text: qsTr("Select your city")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }*/

        delegate: ListDelegate {
            titleText: name
            titleWidth: parent.width-arrow.width
            Image {
                id: arrow
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                Utils.saveCity(uid, name);
                Utils.saveSettings();
                nextbikeModel.init();
                //Globals.pageStack.replace((Qt.resolvedUrl("StationsPage.qml")));
                Globals.pageStack.clear();
                Globals.pageStack.replace(Globals.stationsPage);
            }
        }
        //Component.onCompleted: positionViewAtIndex(0,ListView.Beginning)
    }

    ScrollDecorator {
        flickableItem: listView
    }

    Notification {
        id: info
        anchors.bottom: root.bottom
        anchors.margins: Config.MARGIN
        text: qsTr("Select your city");
    }

    BusyPane {
        id: busy
        anchors.top: topBar.bottom; anchors.bottom: root.bottom;
        text: qsTr("Updating data...");
    }

    Line {
        anchors.top: topBar.bottom
        shadow: false
        white: true
    }

    TopBar {
        id: topBar
    }

    Connections {
        target: cityModel
        onBusy: {
            busy.state = "visible"
        }
        onReady: {
            listView.positionViewAtIndex(0,ListView.Beginning);
            busy.state = "hidden";
            info.show();
        }
    }

}
