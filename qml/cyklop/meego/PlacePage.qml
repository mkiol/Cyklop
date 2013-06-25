import QtQuick 1.1

import com.nokia.meego 1.0
import QtMobility.location 1.2

import "../config.js" as Config
import "../globals.js" as Globals

Page {
    id: root

    orientationLock: PageOrientation.LockPortrait

    property variant coordinate: dummy
    property string name
    property string bikesNumber
    property int bikes

    property variant stack: Globals.pageStack == null ? pageStack : Globals.pageStack

    tools: bottomBar

    ToolBarLayout {
        id: bottomBar

        ToolIcon {
            iconId: stack.depth > 1 ? "toolbar-back" : "toolbar-close"
            onClicked: {
                if(stack.depth>1) {
                    //myMenu.close();
                    stack.pop();
                } else {
                    Qt.quit()
                }
            }
        }

        /*ToolIcon {
            id: menuButton
            iconId: "toolbar-view-menu"
            anchors.right: parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }*/
    }

    Coordinate {
        id: dummy
    }

    function setCenter(coordinate) {
        map.intCenter(coordinate)
    }

    SingleMap {
        id: map
        //opacity: 1
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
        anchors.centerIn: label
        text: root.name
        font.weight: Font.Bold
        elide: Text.ElideNone
        wrapMode: Text.WordWrap
        horizontalAlignment:Text.AlignHCenter
        opacity: 0.8
        width: root.width-2*Config.MARGIN
    }

    /*Line {
        anchors.top: topBar.bottom;
        shadow: false
        white: true
    }

    TopBar {
        id: topBar
    }*/

}
