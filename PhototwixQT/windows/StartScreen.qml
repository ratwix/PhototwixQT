import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: startScreen
    color: "transparent"
    height: parent.height
    width: parent.width

    Column {
        spacing: 10
        anchors.fill: parent

        GroupBox {
            id:takePhotoGroup
            height: parent.height * 0.5
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            ListView {
                id:chooseTemplateListView
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                orientation: Qt.Horizontal
                spacing: 10


                Component {
                    id: activeTemplateDelegate

                    Image {
                        id: templateSelect
                        source: modelData.url
                        sourceSize.height: takePhotoGroup.height * 0.8
                        cache: true
                        asynchronous: true
                        antialiasing: true

                        MouseArea {
                            id: templateSelectMouseArea
                            anchors.fill: parent

                            onPressed: {
                                applicationWindows.currentPhotoTemplate = parameters.addPhotoToGallerie("Test", model.modelData)
                                mainRectangle.state = "TAKE_PHOTO"
                            }
                        }
                    }
                }

                model: currentActiveTemplates
                delegate: activeTemplateDelegate
            }
        }

        GroupBox {
            id:showGalleryGroup
            height: parent.height * 0.5
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            ButtonImage {
                id: showGalleryPhoto;
                label: "Voir les photos";

                onClicked:
                {

                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

    }

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

