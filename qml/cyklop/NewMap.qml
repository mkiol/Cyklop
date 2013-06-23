import QtQuick 1.0
import QtMobility.location 1.2

Item {
    id: myMapRoot

    property variant bikesModel
    property Coordinate center

    signal viewportChanged(variant from, variant to)
    //anchors.fill: parent
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

    function intCenter(c) {
        var coord = Qt.createQmlObject('import QtMobility.location 1.2; Coordinate{latitude:' + c.latitude  + ';longitude:' + c.longitude + ';}', map, "coord");
        map.center = coord;
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
        center: myMapRoot.center

        onZoomLevelChanged: {
            myMapRoot.updateViewport()
        }

        MapObjectView {

            id: allLandmarks
            model: myMapRoot.bikesModel
            delegate: Component {
                MapImage {
                    id: img
                    coordinate: landmark.coordinate
                    //source: "icons/station48.png"
                    offset.x: -24
                    offset.y: -24

                    Component.onCompleted: {
                        var bikes = getBikes(landmark.description);
                        img.source = bikes>=5 ? "icons/station-green.png" :
                                                bikes<1 ? "icons/station-red.png" : "icons/station-yellow.png";
                    }

                    function getBikes(str) {
                        return parseInt(str.slice(0,str.indexOf("@#@",0)));
                    }
                }
            }
        }

        MapImage {
            id: myPositionMarker
            coordinate: positionSource.position.coordinate
            source: "icons/marker64.png"
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
        anchors.bottom: myMapRoot.bottom
        //anchors.top: myMapRoot.top
        anchors.right: myMapRoot.right
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
            source: "icons/ball30.png"
            onClicked: myMapRoot.intCenter(positionSource.position.coordinate)
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
