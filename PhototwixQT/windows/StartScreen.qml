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
    ListView {
        id:chooseTemplateListView
        height: parent.height * 0.5
        width: parent.width
        anchors.left: parent.left
        anchors.top:parent.top
        anchors.topMargin: 20
        anchors.leftMargin: 20

        orientation: Qt.Horizontal
        spacing: 10


        Component {
            id: activeTemplateDelegate

            Image {
                id: templateSelect
                source: modelData.url
                height: chooseTemplateListView.height * 0.9
                fillMode: Image.PreserveAspectFit
                cache: true
                asynchronous: false
                antialiasing: true

                MouseArea {
                    id: templateSelectMouseArea
                    anchors.fill: parent

                    onClicked: {
                        applicationWindows.currentPhoto = parameters.addPhotoToGallerie("Test", model.modelData)
                        applicationWindows.effectSource = "color"
                        mainRectangle.state = "TAKE_PHOTO"
                    }
                }
            }
        }

        model: currentActiveTemplates
        delegate: activeTemplateDelegate

        Component.onCompleted: {
            positionViewAtIndex(count / 2 + 1, ListView.Center) //TODO marche pas
        }
    }

    /**
      * Bottom part, album
      */

/*
    DelegateModel {
        id: albumVisualModel
        model: parameters.photoGalleryList
        delegate: AlbumDelegate {}
    }

    PathView {
        id: photosPathView;
        model: albumVisualModel.parts.stack
        pathItemCount: 5
        //visible: !busyIndicator.visible
        anchors.centerIn: parent;
        anchors.verticalCenterOffset: -30
        path: Path {
            PathAttribute { name: 'z'; value: 9999.0 }
            PathLine { x: 1; y: 1 }
            PathAttribute { name: 'z'; value: 0.0 }
        }
    }
*/

    Item {
        Package.name: 'album'
        id: albumWrapper;
        //width: height - 20;
        height: applicationWindows.height * 0.45
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        DelegateModel {
            id: visualModel
            delegate: PhotoDelegate2 {}
            model: parameters.photoGallery.photoList
        }

        PathView {
            id: photosPathView;
            model: visualModel
            pathItemCount: 5
            //visible: !busyIndicator.visible
            anchors.centerIn: parent;
            anchors.verticalCenterOffset: -30
            path: Path {
                PathAttribute { name: 'z'; value: 9999.0 }
                PathLine { x: 1; y: 1 }
                PathAttribute { name: 'z'; value: 0.0 }
            }
        }
    }

    /**
      * Option access menu
      */

    Image {
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
    }
}

