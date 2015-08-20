import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml.Models 2.2

import "../resources/controls"

Rectangle {
    id: startScreen
    color: "transparent"
    height: parent.height
    width: parent.width

    /**
      * Top part : template Selection
      */


    ChooseTemplateControl {
        id:chooseTemplateListView
        height: parent.height * 0.5
        width: parent.width
        anchors.left: parent.left
        anchors.top:parent.top
        anchors.topMargin: 20
        anchors.leftMargin: 20
    }

    /**
      * Bottom part, album
      */

    GalleryControl {
        id:galleryControl
        anchors.fill: parent;
    }


    /**
      * Option access menu
      */

    Image {
        id:configButton
        source: "../resources/images/config.png"
        anchors.right: parent.right
        anchors.top : parent.top
        height: 60
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent

            onPressed: {
                mainRectangle.state = "CONFIG"
            }
        }
        visible: galleryControl.state == "stacked"
    }

    MessageScreen {
        id:mbox
    }

    ConfirmScreen {
        id:cbox
    }
}

