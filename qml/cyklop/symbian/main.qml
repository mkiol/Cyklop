import QtQuick 1.1

import com.nokia.symbian 1.1
import QtMobility.location 1.2

import "../config.js" as Config
import "../globals.js" as Globals
import "../scripts.js" as Scripts

PageStackWindow {
    id: appWindow

    showStatusBar: true
    showToolBar: true

    StationsPage {
        id: stationPage
    }

    Component.onCompleted: {
        // setup globals
        Globals.pageStack = pageStack;
        Globals.stationsPage = stationPage;

        // init first page
        if(Utils.isFirstStart()) {
            pageStack.push((Qt.resolvedUrl("FirstRunPage.qml")),{},true);
        } else {
            pageStack.push(stationPage);
            nextbikeModel.init();
        }
    }

    property variant position: positionSource.position.coordinate

    PositionSource {
        id: positionSource
        updateInterval: Utils.gpsInterval()
        active: Utils.gps()

        property bool isReady: false
        property bool isDone: false
        signal ready;

        function reload() {
            positionSource.isReady=false;
            positionSource.update();
        }

        onPositionChanged: {
            if(isReady) {
                ready();
                isReady=false;
                isDone=true;
            }
        }
    }


    function sort() {
        if(!Utils.gps() || !positionSource.active) {
            appWindow.position = Qt.createQmlObject('import QtMobility.location 1.2; Coordinate{latitude:'+nextbikeModel.lat()+';longitude:'+nextbikeModel.lng()+';}',appWindow);
            nextbikeModel.sortS();
        } else {
            nextbikeModel.sort(position.latitude,position.longitude);
        }
    }

    Connections {
        target: positionSource
        onReady: {
            sort();
        }
    }

    Connections {
        target: nextbikeModel
        onReady: {
            if(Utils.gps()) {
                positionSource.update();
            }

            if(!Utils.gps() || !positionSource.active) {
                sort();
            } else if(positionSource.isReady || positionSource.isDone) {
                sort();
            } else {
                positionSource.isReady=true;
            }
        }
    }

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem {
                id: item1
                text:  qsTr("Change city")
                onClicked: {
                    Globals.pageStack.push((Qt.resolvedUrl("FirstRunPage.qml")),{},true);
                }
            }
            MenuItem {
                id: item2
                text:  qsTr("Settings")
                onClicked: {
                    Scripts.openFile("SettingsPage.qml");
                }
            }
            MenuItem {
                id: item3
                text:  qsTr("About")
                onClicked: {
                    Scripts.openFile("AboutPage.qml");
                }
            }
            MenuItem {
                id: item4
                text:  qsTr("Exit")
                onClicked: {
                    Qt.quit();
                }
            }

        }
    }

    SplashPane {
        id: splash
        state: "visible"
    }
}
