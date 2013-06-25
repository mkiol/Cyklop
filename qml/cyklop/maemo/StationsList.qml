import QtQuick 1.0

import org.maemo.fremantle 1.0
import QtMobility.location 1.2

import "../config.js" as Config

Item {
    id: root

    function openPlacePage(name,lat,lng,bikes,bikesNumber) {
        var component = Qt.createComponent("PlacePage.qml")
        if (component.status == Component.Ready) {
            var coord = Qt.createQmlObject('import QtMobility.location 1.2; Coordinate{latitude:'+lat+';longitude:'+lng+';}',root,"coord");
            var obj = pageStack.push(component,{"name":name,"bikes":bikes,"bikesNumber":bikesNumber,"coordinate":coord});
        } else {
            console.log("Error loading component:", component.errorString());
        }
    }

    function humanReadableMeterCount(meters) {
        var unit = 1000;
        if (meters <= unit) return meters.toFixed(0) + " m";
        if (meters > unit) return (meters/unit).toFixed(1) + " km";
    }

    ListView {
        id: listView
        anchors.margins: Config.MARGIN
        anchors.fill: parent
        model: nextbikeModel
        spacing: 10
        visible: true

        delegate: ListDelegate {
            titleText: name
            subtitleText: Utils.gps() ? humanReadableMeterCount(distance)+" | " : ""
            titleWidth: parent.width-arrow.width
            Image {
                id: arrow
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: {
                root.openPlacePage(name,lat,lng,bikes,bikesNumber);
            }
            Component.onCompleted: {
                arrow.source = bikes>=5 ? "../icons/icon-arrow-green.png" :
                               bikes<1 ?  "../icons/icon-arrow-red.png" :
                                          "../icons/icon-arrow-yellow.png";
                if(bikes>=5)
                    subtitleText = subtitleText + bikes + " " + qsTr("or more free bikes");
                else if(bikes>1)
                    subtitleText = subtitleText + bikes + " " + qsTr("free bikes");
                else if(bikes>0)
                    subtitleText = subtitleText + bikes + " " + qsTr("free bike");
                else
                    subtitleText = subtitleText + qsTr("no free bikes");
            }
        }
        Component.onCompleted: positionViewAtIndex(0,ListView.Beginning)
    }

    Connections {
        target: nextbikeModel
        onSorted: {
            listView.positionViewAtIndex(0,ListView.Beginning)
        }
    }

    ScrollDecorator {
        flickableItem: listView
    }

}
