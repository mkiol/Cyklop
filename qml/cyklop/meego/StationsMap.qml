import QtQuick 1.1

import QtMobility.location 1.2

Item {
    id: root

    property Coordinate center
    property bool inited: false
    signal viewportChanged(variant from, variant to)

    anchors.fill: parent

    function setCenter(coordinate) {
        intCenter(coordinate)
    }

    function init() {
        /*if(!inited) {
            intCenter(appWindow.position);
            //refresh();
            inited = true;
        }*/
        intCenter(appWindow.position);
        refresh();
    }

    function refresh() {
        var i;

        for(i=0; i<100; i++) {
            landmarks.children[i].visible = false;
        }

        var l = nextbikeModel.count(); if(l>100) l=100;
        for(i=0; i<l; i++) {
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

        center: root.center

        onZoomLevelChanged: {
            root.updateViewport()
        }

        MapGroup {
            id: landmarks
            Repeater {
                model: 100
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
            coordinate: appWindow.position
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
        anchors.bottom: root.bottom
        //anchors.top: root.top
        anchors.right: root.right
        anchors.margins: 15
        spacing: 10

        MapButton {
            width: 50; height: 50
            text: "+"
            onClicked: map.zoomLevel++
        }
        MapButton {
            width: 50; height: 50
            text: "-"
            onClicked: map.zoomLevel--
        }
        MapButton {
            width: 50; height: 50
            source: "../icons/ball30.png"
            onClicked: root.intCenter(appWindow.position)
        }
    }

    /*Connections {
        target: viewer
        onVolumeUp: {
            map.zoomLevel++;
        }
    }
    Connections {
        target: viewer
        onVolumeDown: {
            map.zoomLevel--;
        }
    }*/
}
