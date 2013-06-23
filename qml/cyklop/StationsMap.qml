import QtQuick 1.0

Item {
    id: root

    property bool centerInited: false

    NewMap {
        id: map
        anchors.fill: parent
        bikesModel:landmarkModel
    }

    function setCenter(coordinate) {
        map.intCenter(coordinate)
    }

    function initCenter(coordinate) {
        if(!centerInited) {
            map.intCenter(coordinate);
            centerInited = true;
        }
    }

}
