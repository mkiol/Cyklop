import QtQuick 1.1

import com.nokia.symbian 1.1

import "../config.js" as Config

Page {
    id: root

    orientationLock: PageOrientation.LockPortrait

    tools: bottomBar

    property variant stack: pageStack

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
                text: APP_NAME
                anchors.horizontalCenter: parent.horizontalCenter
                color: Config.FGCOLOR_BANER
                font.pixelSize: 32
            }
            Image {
                source: "../icons/cyklop.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: qsTr("Version: %1").arg(VERSION);
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
                text: PAGE
                color: Config.FGCOLOR_BANER
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                textFormat: Text.RichText
                text: "Copyright &copy; 2014 Michał Kościesza"
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
