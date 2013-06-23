import QtQuick 1.0
import org.maemo.fremantle 1.0
import QtMobility.location 1.2
import "config.js" as Config
import "globals.js" as Globals
import "scripts.js" as Scripts

PageStackWindow {
    id: appWindow

    platformStyle: defaultStyle
    showStatusBar: false
    allowClose: false
    allowSwitch: false
    showToolBar: true

    //initialPage: stationPage

    StationsPage {
        id: stationPage
    }

    Component.onCompleted: {
        //theme.inverted = true;

        // setup globals
        Globals.landmarkModel = landmarkModel;
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

    function sleep(milliseconds) {
      var start = new Date().getTime();
      for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds){
          break;
        }
      }
    }

    PageStackWindowStyle {
        id: defaultStyle
    }

    PositionSource {
        id: positionSource
        updateInterval: Utils.gpsInterval()
        active: true
    }

    LandmarkModel {
        id: landmarkModel

        property bool isReady: false

        signal ready
        signal timeout

        autoUpdate: true
        filter: LandmarkProximityFilter {
            center: positionSource.position.coordinate
            radius: Utils.radius()
        }

        onLandmarksChanged: {
            if(isReady && count > 0) {
                landmarkModel.ready();
                isReady = false;
            }
        }

        function importPlaces() {
            setDbFileName(nextbikeModel.dBFilePath());
            importFile = nextbikeModel.exportFilePath();
            isReady = true;
            importLandmarks();
            timer.start();
            update();
        }

    }

    Timer {
        id: timer
        interval: Utils.timeout()
        onTriggered: {
            if(landmarkModel.isReady) {
                landmarkModel.timeout();
            }
        }
    }

    Connections {
        target: nextbikeModel
        onReady: {
            landmarkModel.importPlaces();
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                id: item1
                text:  qsTr("Change city")
                onClicked: {
                    //Globals.pageStack.clear();
                    Globals.pageStack.push((Qt.resolvedUrl("FirstRunPage.qml")),{},true);
                }
            }
            MenuItem {
                id: item2
                text:  qsTr("Settings")
                onClicked: {
                    //Globals.pageStack.push((Qt.resolvedUrl("SettingsPage.qml")),{},true);
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
