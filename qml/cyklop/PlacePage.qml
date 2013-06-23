import QtQuick 1.0
import org.maemo.fremantle 1.0
import QtMobility.location 1.2
import "config.js" as Config

Page {
    id: root

    orientationLock: PageOrientation.LockPortrait

    property Landmark landmark: dummy
    property string bikesNumber
    property int bikes

    tools: bottomBar

    Landmark {
        id: dummy
    }

    ToolBarLayout {
        id: bottomBar

        ToolIcon {
            id: menuButton
            iconId: "toolbar-view-menu"
            anchors.right: parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    function setCenter(coordinate) {
        map.intCenter(coordinate)
    }

    SingleMap {
        id: map
        opacity: 1
        anchors.top: topBar.bottom; anchors.bottom: root.bottom
        anchors.left: root.left; anchors.right: root.right
        center: landmark.coordinate
        bikes: bikeGet()

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
        anchors.top: topBar.bottom
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
        text: root.landmark.name
        font.weight: Font.Bold
        elide: Text.ElideNone
        wrapMode: Text.WordWrap
        horizontalAlignment:Text.AlignHCenter
        opacity: 0.8
        width: root.width-2*Config.MARGIN
    }

    Line {
        anchors.top: topBar.bottom;
        shadow: true
        white: true
    }

    TopBar {
        id: topBar
    }

}
