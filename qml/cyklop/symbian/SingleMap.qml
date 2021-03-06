import QtQuick 1.1

import QtMobility.location 1.2

Item {
    id: myMapRoot

    property Coordinate center
    property Coordinate currentPosition
    property int bikes

    signal viewportChanged(variant from, variant to)

    onOpacityChanged: {
        if (opacity == 1) {
            updateViewport();
        }
    }

    function updateViewport() {
        viewportChanged(
                    map.toCoordinate(Qt.point(-map.anchors.leftMargin,-map.anchors.topMargin)),
                    map.toCoordinate(Qt.point(map.size.width + map.anchors.rightMargin,
                                              map.size.height + map.anchors.bottomMargin)))
    }

    function intCenter() {
        setCurrentPosition();
        map.center = myMapRoot.currentPosition
    }

    function setCurrentPosition() {
        if (myMapRoot.currentPosition)
            myMapRoot.currentPosition.destroy();
        myMapRoot.currentPosition =
                Qt.createQmlObject('import QtMobility.location 1.2; Coordinate{latitude:' +
                                   nextbikeModel.lat  + ';longitude:' +
                                   nextbikeModel.lng + '}',myMapRoot);
    }

    Map {

        id: map
        anchors.fill: parent
        anchors.margins: -80
        zoomLevel: 16

        center: myMapRoot.center

        plugin : Plugin {
            name : "nokia"
            parameters: [
                PluginParameter {name: "mapping.app_id"; value: "xv-oxqLvX_nltn_beU0j"},
                PluginParameter {name: "mapping.token"; value: "YfeYb5Rx5e9mGaV0EPso-g"}
            ]
        }

        onZoomLevelChanged: {
            myMapRoot.updateViewport()
        }

        MapImage {
            id: myPositionMarker
            coordinate: currentPosition
            source: "../icons/marker64.png"
            offset.x: -32
            offset.y: -64
        }

        MapImage {
            id: station
            coordinate: myMapRoot.center
            offset.x: -24
            offset.y: -24
            source: myMapRoot.bikes>=5 ? "../icons/station-green.png" :
                    myMapRoot.bikes<1 ? "../icons/station-red.png" : "../icons/station-yellow.png";
        }
    }

    Flickable {

        id: flickable
        anchors.fill: parent
        contentWidth: 8000
        contentHeight: 8000

        Component.onCompleted: setCenter()
        onMovementEnded: {
            setCenter()
            myMapRoot.updateViewport()
        }
        function setCenter() {
            lock = true
            contentX = contentWidth / 2
            contentY = contentHeight / 2
            lock = false
            prevX = contentX
            prevY = contentY
        }

        onContentXChanged: panMap()
        onContentYChanged: panMap()
        property double prevX: 0
        property double prevY: 0
        property bool lock: false
        function panMap() {
            if (lock) return
            map.pan(contentX - prevX, contentY - prevY)
            prevX = contentX
            prevY = contentY
        }
    }

    Column {
        //anchors.bottom: myMapRoot.bottom
        //anchors.top: myMapRoot.top
        anchors.verticalCenter: myMapRoot.verticalCenter
        anchors.right: myMapRoot.right
        anchors.margins: 15
        spacing: 10

        MapButton {
            width: 40; height: 40
            text: "+"
            onClicked: map.zoomLevel++
        }
        MapButton {
            width: 40; height: 40
            text: "-"
            onClicked: map.zoomLevel--
        }
        MapButton {
            //enabled: positionSource.active
            //visible: positionSource.active
            width: 40; height: 40
            source: "../icons/ball30.png"
            onClicked: {
                myMapRoot.intCenter();
            }
        }
    }
}
