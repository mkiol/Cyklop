import QtQuick 1.1

import com.nokia.symbian 1.1
import com.nokia.extras 1.1

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

        ToolButton{
            text: qsTr("Save settings")
            anchors.left: backButton.right
            anchors.right: parent.right
            anchors.margins: Config.MARGIN
            onClicked: {
                // save settings
                Utils.saveLocale(languageDialog.model.get(languageDialog.selectedIndex).locale);
                Utils.saveRadius(parseInt(radiusField.text));
                Utils.saveInterval(parseInt(intervalField.text));
                Utils.saveGps(gpsSwitch.checked);

                info.text = qsTr("Restart for the change to take effect!");
                info.open();
            }
        }
    }
    Column {
        ListItem {
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: qsTr("Language")
            }

            Button {
                id: languageButton
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: Scripts.languageName(Utils.locale());
                //width: 200
                onClicked: {
                    languageDialog.open();
                }
            }
        }

        ListItem {
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: qsTr("Enable GPS")
            }
            Switch {
                id: gpsSwitch
                checked: Utils.gps()
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
            }
        }

        ListItem {
            visible: gpsSwitch.checked
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: qsTr("GPS interval (ms)")
            }
            TextField {
                id: intervalField
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                maximumLength: 6
                text: Utils.gpsInterval()
                width: 100
                enabled: gpsSwitch.checked
            }
        }

        ListItem {
            visible: gpsSwitch.checked
            Label {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                text: qsTr("Search radius (m)")
            }
            TextField {
                id: radiusField
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                maximumLength: 6
                text: Utils.radius()
                width: 100
                enabled: gpsSwitch.checked
            }
        }
    }

    SelectionDialog {
        id: languageDialog
        titleText: qsTr("Choose your language:")
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

    InfoBanner {
        id: info
    }

}
