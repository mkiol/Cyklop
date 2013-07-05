import QtQuick 1.1

import com.nokia.symbian 1.1
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
        //anchors.margins: Config.MARGIN
        anchors.fill: parent
        model: nextbikeModel
        spacing: 0
        visible: true

        /*delegate: ListDelegate {
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
        }*/

        delegate: ListItem {
            id: listItem
            //subItemIndicator: true
            //anchors.left: root.left; anchors.right: root.right

            Column {
                anchors.right: arrow.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10

                ListItemText {
                    mode: listItem.mode
                    role: "Title"
                    elide: Text.ElideRight
                    text: name
                    anchors.left: parent.left; anchors.right: parent.right
                }

                ListItemText {
                    id: subtitleText
                    mode: listItem.mode
                    role: "SubTitle"
                    elide: Text.ElideRight
                    text: Utils.gps() ? humanReadableMeterCount(distance)+" | " : ""
                }
            }

            Image {
                id: arrow
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            Component.onCompleted: {
                arrow.source = bikes>=5 ? "../icons/icon-arrow-green.png" :
                               bikes<1 ?  "../icons/icon-arrow-red.png" :
                                          "../icons/icon-arrow-yellow.png";
                if(bikes>=5)
                    subtitleText.text = subtitleText.text + bikes + " " + qsTr("or more free bikes");
                else if(bikes>1)
                    subtitleText.text = subtitleText.text + bikes + " " + qsTr("free bikes");
                else if(bikes>0)
                    subtitleText.text = subtitleText.text + bikes + " " + qsTr("free bike");
                else
                    subtitleText.text = subtitleText.text + qsTr("no free bikes");
            }
            onClicked: {
                root.openPlacePage(name,lat,lng,bikes,bikesNumber);
            }
        }
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
