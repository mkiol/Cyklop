import QtQuick 1.0

import "../config.js" as Config

Item {
    id: root

    property url source
    signal clicked

    width: 70; height: 70

    Image {
        source: root.source
    }

    MouseArea {
        anchors.fill: root
        onClicked: root.clicked()
    }
}
