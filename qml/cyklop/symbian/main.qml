import QtQuick 1.1

import com.nokia.symbian 1.1
import QtMobility.location 1.2

import "../config.js" as Config

PageStackWindow {
    id: appWindow

    property bool started: false

    showStatusBar: true
    showToolBar: true

    Component.onCompleted: {
        if(settings.cityName === "") {
            pageStack.push((Qt.resolvedUrl("FirstRunPage.qml")),{},true);
        } else {
            pageStack.push((Qt.resolvedUrl("StationsPage.qml")),{},true);
        }
        //pageStack.push((Qt.resolvedUrl("FirstRunPage.qml")),{},true);
    }

    PositionSource {
        id: positionSource
        property bool ready: false
        updateInterval: settings.updateInterval
        active: settings.gps

        function printableMethod(method) {
            if (method == PositionSource.SatellitePositioningMethod)
                return "Satellite";
            else if (method == PositionSource.NoPositioningMethod)
                return "Not available"
            else if (method == PositionSource.NonSatellitePositioningMethod)
                return "Non-satellite"
            else if (method == PositionSource.AllPositioningMethods)
                return "All/multiple"
            return "source error";
        }

        onPositionChanged: {
            //console.log("main.qml: positionSource.onPositionChanged");

            /*console.log("positioningMethod: "+printableMethod(positionSource.positioningMethod));
            console.log("nmeaSource: "+ positionSource.nmeaSource);
            console.log("updateInterval: "+ positionSource.updateInterval);
            console.log("active: "+ positionSource.active);
            console.log("timestamp: "  + positionSource.position.timestamp);
            console.log("altitudeValid: "  + positionSource.position.altitudeValid);
            console.log("longitudeValid: "  + positionSource.position.longitudeValid);
            console.log("latitudeValid: "  + positionSource.position.latitudeValid);
            console.log("speedValid: "     + positionSource.position.speedValid);*/

            nextbikeModel.lat = positionSource.position.coordinate.latitude;
            nextbikeModel.lng = positionSource.position.coordinate.longitude;
            if (settings.cityId!=0 && !cityModel.busy) {
                nextbikeModel.refresh();
                ready = true;
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
                    pageStack.replace(Qt.resolvedUrl("FirstRunPage.qml"));
                }
            }
            MenuItem {
                id: item2
                text:  qsTr("Settings")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
                }
            }
            MenuItem {
                id: item3
                text:  qsTr("About")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
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

    Connections {
        target: nextbikeModel
        onBusyChanged: {
            if (!nextbikeModel.busy)
                started = true;
        }
    }

    SplashPane {
        id: splash
        open: (cityModel.busy || nextbikeModel.busy) && !started
    }
}
