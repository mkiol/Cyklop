import QtQuick 1.1

import com.nokia.symbian 1.1
import com.nokia.extras 1.1

import "../config.js" as Config
import "../globals.js" as Globals

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    ToolBarLayout {
        id: bottomBar

        ToolButton {
            id: menuButton
            iconSource: "toolbar-view-menu"
            anchors.right: parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

    }

    Component.onCompleted: {
        cityModel.init();
    }

    ListView {
        id: listView

        //anchors.margins: Config.MARGIN
        anchors.left: root.left; anchors.right: root.right
        anchors.top: root.top; anchors.bottom: root.bottom

        model: cityModel
        spacing: 0
        visible: true

        delegate: ListItem {
            id: listItem
            subItemIndicator: true
            anchors.margins: Config.MARGIN

            ListItemText {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                id: listTitle
                mode: listItem.mode
                role: "Title"
                text: name
            }

            onClicked: {
                Utils.saveCity(uid, name);
                Utils.saveSettings();
                nextbikeModel.init();
                Globals.pageStack.clear();
                Globals.pageStack.replace(Globals.stationsPage);
            }
        }
    }

    ScrollDecorator {
        flickableItem: listView
    }

    InfoBanner {
        id: info
        text: qsTr("Select your city");
    }

    BusyPane {
        id: busy
        anchors.top: root.top; anchors.bottom: root.bottom;
        text: qsTr("Updating data...");
    }

    Connections {
        target: cityModel
        onBusy: {
            busy.state = "visible"
        }
        onReady: {
            listView.positionViewAtIndex(0,ListView.Beginning);
            busy.state = "hidden";
            info.open();
        }
    }

}
