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
                settings.cityName = name;
                settings.cityId = uid;
                pageStack.replace(Qt.resolvedUrl("StationsPage.qml"));
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
        open: cityModel.busy
        anchors.top: root.top; anchors.bottom: root.bottom;
        text: qsTr("Updating data...");
    }

    Connections {
        target: cityModel
        onBusyChanged: {
            if (!cityModel.busy) {
                listView.positionViewAtIndex(0,ListView.Beginning);
                info.open();
            }
        }
    }

}
