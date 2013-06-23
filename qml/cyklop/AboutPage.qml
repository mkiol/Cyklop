import QtQuick 1.0
import org.maemo.fremantle 1.0
import "config.js" as Config

Page {
    id: root

    orientationLock: PageOrientation.LockPortrait

    Rectangle {
        anchors.fill: parent
        color: Config.BGCOLOR_BANER
    }

    Flickable {
        id: flick

        anchors.left: root.left; anchors.right: root.right
        anchors.top: topBar.bottom; anchors.bottom: root.bottom

        anchors.margins: 20
        flickableDirection: Flickable.VerticalFlick
        contentHeight: content.height

        Column {
            id: content
            spacing: 40
            anchors.fill: parent

            Label {
                text: "Cyklop"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Config.FGCOLOR_BANER
                font.pixelSize: 32
            }
            Image {
                source: "icons/cyklop.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: qsTr("Version") + " : " + Config.VERSION
                anchors.horizontalCenter: parent.horizontalCenter
                color: Config.FGCOLOR_BANER
            }
            Label {
                text: qsTr("A bicycle sharing application. "
                          +"It allows you to find free bikes or stations near you. "
                          +"It currently supports every system handled by <em>Nextbike</em> "
                          +"including more than 80 cities from "
                          +"Germany, Austria, Latvia, Poland, Switzerland, Turkey, "
                          +"Azerbaijan, Cyprus, the United Arabian Emirates and New Zealand.")
                color: Config.FGCOLOR_BANER
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignJustify
                width: parent.width
            }
            Label {
                text: "Copyright (C) 2013 Michał Kościesza"
                color: Config.FGCOLOR_BANER
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }

    TopBar {
        id: topBar
        showImage: false
    }

}
