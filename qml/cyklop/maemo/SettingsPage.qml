import QtQuick 1.0

import org.maemo.fremantle 1.0

import "../config.js" as Config
import "../scripts.js" as Scripts
import "../globals.js" as Globals

Page {
    id: root

    tools: bottomBar
    orientationLock: PageOrientation.LockPortrait

    property variant stack: Globals.pageStack == null ? pageStack : Globals.pageStack

    ToolBarLayout {
        id: bottomBar

        ToolButton{
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Save settings")
            width: root.width/2
            onClicked: {
                // save settings
                Utils.saveLocale(languageDialog.model.get(languageDialog.selectedIndex).locale);
                Utils.saveRadius(parseInt(radiusField.text));
                Utils.saveInterval(parseInt(intervalField.text));
                Utils.saveGps(gpsSwitch.checked);

                info.text = qsTr("Restart for the change to take effect!");
                info.show();
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
        anchors.top: topBar.bottom; anchors.bottom: root.bottom
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.margins: Config.MARGIN
        spacing: Config.MARGIN
        Item {
            anchors.left: parent.left; anchors.right: parent.right; anchors.margins: Config.MARGIN; height: 50
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Language")
            }
            Button {
                id: languageButton
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                text: Scripts.languageName(Utils.locale());
                width: 200
                onClicked: {
                    languageDialog.open();
                }
            }
        }
        Item {
            anchors.left: parent.left; anchors.right: parent.right; anchors.margins: Config.MARGIN; height: 50
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Enable GPS")
            }
            Switch {
                id: gpsSwitch
                checked: Utils.gps()
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
            }
        }
        Item {
            visible: gpsSwitch.checked
            anchors.left: parent.left; anchors.right: parent.right; anchors.margins: Config.MARGIN; height: 50
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                text: qsTr("GPS interval (ms)")
            }
            TextField {
                id: intervalField
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                maximumLength: 6
                text: Utils.gpsInterval()
                width: 150
                enabled: gpsSwitch.checked
            }
        }
        Item {
            visible: gpsSwitch.checked
            anchors.left: parent.left; anchors.right: parent.right; anchors.margins: Config.MARGIN; height: 50
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Search radius (m)")
            }
            TextField {
                id: radiusField
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                maximumLength: 6
                text: Utils.radius()
                width: 150
                enabled: gpsSwitch.checked
            }
        }
    }

    SelectionDialog {
        id: languageDialog
        titleText: qsTr("Choose your language")
        selectedIndex: localeIndex()

        model: ListModel {
            ListElement { name: "English"; locale: "en" }
            ListElement { name: "Polski"; locale: "pl" }
        }

        onAccepted: {
            languageButton.text = Scripts.languageName(model.get(selectedIndex).locale);
        }

        function localeIndex() {
            var locale = Utils.locale();
            for(var i=0; i<model.count; i++) {
                if(model.get(i).locale==locale) return i;
            }
        }
    }

    Notification {
        id: info
        anchors.bottom: root.bottom; anchors.margins: Config.MARGIN;
    }

    Line {
        anchors.top: topBar.bottom
        shadow: false
        white: true
    }

    TopBar {
        id: topBar
    }

}
