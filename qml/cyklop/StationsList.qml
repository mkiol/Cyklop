import QtQuick 1.0
import org.maemo.fremantle 1.0
//import org.maemo.extras 1.0
import QtMobility.location 1.2
import "config.js" as Config

Item {
    id: root

    function openPlacePage(landmark) {
        var component = Qt.createComponent("PlacePage.qml")
        if (component.status == Component.Ready) {
            var obj = pageStack.push(component,{"landmark":landmark});
            var place = getPlace(landmark.description);
            obj.bikes = place[0];
            obj.bikesNumber = place[1];
        } else {
            console.log("Error loading component:", component.errorString());
        }
    }

    function getPlace(str) {
        var place = new Array();
        var i = str.indexOf("@#@",0);
        place[0] = parseInt(str.slice(0,i));
        place[1] = str.slice(i+3,str.length);
        return place;
    }

    function getBikes(str) {
        return parseInt(str.slice(0,str.indexOf("@#@",0)));
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
        model: landmarkModel
        spacing: 10
        visible: true

        /*header: Item {
            height: 80
            width: parent.width
            Label {
                id: header
                font.family: Config.FGCOLOR
                font.weight: Font.Bold
                font.pixelSize: 26
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Connections {
                target: nextbikeModel
                onReady: {
                    header.text = nextbikeModel.cityName();
                }
            }
        }*/

        delegate: ListDelegate {
            titleText: landmark.name
            subtitleText: humanReadableMeterCount(positionSource.position.coordinate.distanceTo(landmark.coordinate))
            titleWidth: parent.width-arrow.width
            Image {
                id: arrow
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: {
                root.openPlacePage(landmark);
            }
            Component.onCompleted: {
                var bikes = getBikes(landmark.description);
                arrow.source = bikes>=5 ? "icons/icon-arrow-green.png" :
                                          bikes<1 ? "icons/icon-arrow-red.png" : "icons/icon-arrow-yellow.png";
                if(bikes>=5)
                    subtitleText = subtitleText + " | " + bikes + " " + qsTr("or more free bikes");
                else if(bikes>1)
                    subtitleText = subtitleText + " | " + bikes + " " + qsTr("free bikes");
                else if(bikes>0)
                    subtitleText = subtitleText + " | " + bikes + " " + qsTr("free bike");
                else
                    subtitleText = subtitleText + " | " + qsTr("no free bikes");
            }
        }
        Component.onCompleted: positionViewAtIndex(0,ListView.Beginning)
    }

    /*ListView {
        id: listView
        anchors.fill: parent
        model: landmarkModel
        spacing: 10
        visible: true
        delegate: ListDelegate {

            titleText: landmark.name
            subtitleText: humanReadableMeterCount(positionSource.position.coordinate.distanceTo(landmark.coordinate))
            titleWidth: parent.width-arrow.width

            Image {
                id: arrow
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: {
                root.openPlacePage(landmark);
            }
            Component.onCompleted: {
                var bikes = getBikes(landmark.description);
                arrow.source = bikes>=5 ? "icons/icon-arrow-green.png" :
                                          bikes<1 ? "icons/icon-arrow-red.png" : "icons/icon-arrow-yellow.png";
                if(bikes>=5)
                    subtitleText = subtitleText + " | " + bikes + " " + qsTr("or more free bikes");
                else if(bikes>1)
                    subtitleText = subtitleText + " | " + bikes + " " + qsTr("free bikes");
                else if(bikes>0)
                    subtitleText = subtitleText + " | " + bikes + " " + qsTr("free bike");
                else
                    subtitleText = subtitleText + " | " + qsTr("no free bikes");
            }
        }
        Component.onCompleted: positionViewAtIndex(0,ListView.Beginning)
    }*/

    ScrollDecorator {
        flickableItem: listView
    }


}
