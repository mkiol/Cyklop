import QtQuick 1.1

import QtMobility.location 1.2

Item {
    id: root

    property Coordinate currentPosition
    signal viewportChanged(variant from, variant to)

    anchors.fill: parent

    function init() {
        setCurrentPosition();
        intCenter(root.currentPosition);
        showStations();
    }

    function refresh() {
        setCurrentPosition();
        showStations();
    }

    function setCurrentPosition() {
        if (root.currentPosition)
            root.currentPosition.destroy();
        root.currentPosition =
                Qt.createQmlObject('import QtMobility.location 1.2; Coordinate{latitude:' +
                                   nextbikeModel.lat  + ';longitude:' +
                                   nextbikeModel.lng + '}',root);
    }

    function showStations() {

        if (nextbikeModel.busy)
            return;

        var i;
        for(i=0; i<120; i++) {
            landmarks.children[i].visible = false;
        }
        var l = nextbikeModel.count(); if(l>120) l=120;
        //console.log("nextbikeModel.count: "+nextbikeModel.count());
        for(i=0; i<l; i++) {
            //console.log("i: "+i);
            landmarks.children[i].coordinate.latitude = nextbikeModel.get(i).lat();
            landmarks.children[i].coordinate.longitude = nextbikeModel.get(i).lng();
            landmarks.children[i].source = nextbikeModel.get(i).bikes()>=5 ? "../icons/station-green.png" :
                                           nextbikeModel.get(i).bikes()<1 ?  "../icons/station-red.png" :
                                                                             "../icons/station-yellow.png";
            landmarks.children[i].visible = true;
        }
    }

    function updateViewport() {
        viewportChanged(
                    map.toCoordinate(Qt.point(-map.anchors.leftMargin,-map.anchors.topMargin)),
                    map.toCoordinate(Qt.point(map.size.width + map.anchors.rightMargin,
                                              map.size.height + map.anchors.bottomMargin)))
    }

    function intCenter(c) {
        if (map.center)
            map.center.destroy();
        map.center = Qt.createQmlObject('import QtMobility.location 1.2; Coordinate{latitude:' + c.latitude  + ';longitude:' + c.longitude + ';}', map, "coord");
    }

    onOpacityChanged: {
        if (opacity == 1) {
            updateViewport();
        }
    }

    Map {
        id: map
        anchors.fill: parent
        anchors.margins: -80
        zoomLevel: 16

        plugin : Plugin {
            name : "nokia"
            parameters: [
                PluginParameter {name: "mapping.app_id"; value: "xv-oxqLvX_nltn_beU0j"},
                PluginParameter {name: "mapping.token"; value: "YfeYb5Rx5e9mGaV0EPso-g"}
            ]
        }

        onZoomLevelChanged: {
            root.updateViewport()
        }

        MapGroup {
            id: landmarks
            Repeater {
                model: 120
                MapImage {
                    offset.x: -32
                    offset.y: -64
                    visible: false
                    coordinate: Coordinate {}
                }
            }
        }

        MapImage {
            id: myPositionMarker
            coordinate: positionSource.position.coordinate
            source: "../icons/marker64.png"
            offset.x: -32
            offset.y: -64
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
            root.updateViewport()
        }

        function setCenter() {
            lock = true;
            contentX = contentWidth / 2;
            contentY = contentHeight / 2;
            lock = false;
            prevX = contentX;
            prevY = contentY;
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
        //anchors.bottom: root.bottom
        //anchors.top: root.top
        anchors.verticalCenter: root.verticalCenter
        anchors.right: root.right
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
            enabled: positionSource.active
            visible: positionSource.active
            width: 40; height: 40
            source: "../icons/ball30.png"
            onClicked: root.intCenter(root.currentPosition);
        }
    }
}
