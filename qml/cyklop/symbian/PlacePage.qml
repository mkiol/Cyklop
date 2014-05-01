import QtQuick 1.1

import com.nokia.symbian 1.1
import QtMobility.location 1.2

import "../config.js" as Config

Page {
    id: root

    orientationLock: PageOrientation.LockPortrait

    property variant coordinate: dummy
    property string name
    property string bikesNumber
    property int bikes

    property variant stack: pageStack

    tools: bottomBar

    ToolBarLayout {
        id: bottomBar

        ToolButton{
            iconSource: "toolbar-back"
            onClicked: {
                if(stack.depth>1) {
                    //myMenu.close();
                    stack.pop();
                } else {
                    Qt.quit()
                }
            }
        }
    }

    Coordinate {
        id: dummy
    }

    function setCenter(coordinate) {
        map.intCenter(coordinate)
    }

    SingleMap {
        id: map
        anchors.top: root.top; anchors.bottom: root.bottom
        anchors.left: root.left; anchors.right: root.right
        center: coordinate
        bikes: root.bikes

        function bikeGet() {
            return root.bikes;
        }
    }

    Baner2 {
        id: bar2
        anchors.bottom: root.bottom; anchors.bottomMargin: Config.MARGIN
        textcolor: bikes>=5 ? Config.FGCOLOR_BANER : bikes>0 ? Config.FGCOLOR : Config.FGCOLOR_BANER
        color: bikes>=5 ? Config.GREEN : bikes>0 ? Config.YELLOW : Config.RED
        text: bikeStatus()

        function bikeStatus() {
            if(bikes>=5)
                return bikes + " " + qsTr("or more free bikes");
            else if(bikes>1)
                return bikes + " " + qsTr("free bikes");
            else if(bikes>0)
                return bikes + " " + qsTr("free bike");
            else
                return qsTr("no free bikes");
        }

    }

    Rectangle {
        id: label
        anchors.left: root.left; anchors.right: root.right;
        anchors.top: root.top
        anchors.margins: Config.MARGIN
        height: text.height+2*Config.MARGIN
        border.color: "#aaaaaa"
        border.width: 1
        color: "#aaffffff"
        radius: 10
    }

    Label {
        id: text
        platformInverted: true
        anchors.centerIn: label
        text: root.name
        font.weight: Font.Bold
        elide: Text.ElideNone
        wrapMode: Text.WordWrap
        horizontalAlignment:Text.AlignHCenter
        opacity: 0.8
        width: root.width-2*Config.MARGIN
    }

}
