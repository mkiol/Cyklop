import QtQuick 1.1

import com.nokia.symbian 1.1

import "../config.js" as Config
import "../globals.js" as Globals

Page {
    id: root

    orientationLock: PageOrientation.LockPortrait

    tools: bottomBar

    property variant stack: Globals.pageStack == null ? pageStack : Globals.pageStack

    ToolBarLayout {
        id: bottomBar

        ToolButton {
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

    Rectangle {
        anchors.fill: parent
        color: Config.BGCOLOR_BANER
    }

    Flickable {
        id: flick

        anchors.left: root.left; anchors.right: root.right
        anchors.top: root.top; anchors.bottom: root.bottom

        flickableDirection: Flickable.VerticalFlick
        contentHeight: content.height+Config.MARGIN

        Column {
            id: content
            spacing: 30
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: Config.MARGIN

            Label {
                text: "cyklop"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Config.FGCOLOR_BANER
                font.pixelSize: 32
            }
            Image {
                source: "../icons/cyklop.png"
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
                text: "http://cyklop.mkiol.net/"
                color: Config.FGCOLOR_BANER
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "<p>Copyrights &copy; 2013 Michał Kościesza</p>"
                color: Config.FGCOLOR_BANER
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }

    ScrollDecorator {
        flickableItem: flick
    }

    /*TopBar {
        id: topBar
        showImage: false
    }*/

}
