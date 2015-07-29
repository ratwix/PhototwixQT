
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: configTemplateScreen
    color: "yellow"
    anchors.fill : parent

    property url currentEditedTemplateUrl //TODO, remplacer par un template C++

    function updateTemplatePhotoPositionsRepeater(model) {
        templatePhotoPositionsRepeater.model = model;
    }

    Rectangle {
        id: configTemplateScreenButtons
        anchors.left: parent.left
        height: parent.height
        width: parent.width * 0.15

        Column {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter : parent.horizontalCenter
            spacing: 20

            ButtonImage {
                id: addPhoto;
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Ajouter";
                onClicked:
                {
                    applicationWindows.currentEditedTemplate.addTemplatePhotoPosition();
                    updateTemplatePhotoPositionsRepeater(applicationWindows.currentEditedTemplate.templatePhotoPositions);
                }
            }

            ButtonImage {
                id: resetTemplate;
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Reset";
                onClicked:
                {

                }
            }

            ButtonImage {
                id: saveTemplate;
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Sauvegarder";
                onClicked:
                {
                    mainTabView.currentIndex = 2
                }
            }
        }
    }

    Rectangle {
        id: configTemplateScreenTemplate
        anchors.right: parent.right
        height: parent.height
        width: parent.width - configTemplateScreenButtons.width

        Image {
            id: currentEditedTemplate

            source: applicationWindows.currentEditedTemplate.url

            asynchronous: true
            cache: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.95
            width: parent.width * 0.95
            fillMode: Image.PreserveAspectFit

            onSourceChanged: {
                updateTemplatePhotoPositionsRepeater(applicationWindows.currentEditedTemplate.templatePhotoPositions);
            }
        }

        Repeater { //Affichage de tout les photo frame
            id:templatePhotoPositionsRepeater
            anchors.fill: parent

            model: applicationWindows.currentEditedTemplate.templatePhotoPositions

            Rectangle {
                id:templatePhotoPosition
                x:10
                y:10
                z:10
                height: 200
                width: 375
                color: "#800000FF"
                border.color: "#80FFFF00"
                border.width: 2
                smooth: true
                antialiasing: true

                Label {

                    id: templatePhotoPositionNumber
                    anchors.centerIn: parent
                    font.pixelSize: parent.height * 0.6
                    text: modelData.number
                }

                PinchArea {
                    anchors.fill: parent
                    pinch.target: templatePhotoPosition
                    pinch.minimumRotation: -360
                    pinch.maximumRotation: 360
                    pinch.minimumScale: 0.1
                    pinch.maximumScale: 10
                    //onPinchStarted: setFrameColor();
                    MouseArea {
                        id: dragArea
                        hoverEnabled: true
                        anchors.fill: parent
                        drag.target: templatePhotoPosition
                        onPressed: {
                            /*
                            photoFrame.z = ++root.highestZ;
                            parent.setFrameColor();
                            */
                        }
                        //onEntered: parent.setFrameColor();
                        onWheel: {
                            if (wheel.modifiers & Qt.ControlModifier) {
                                templatePhotoPosition.rotation += wheel.angleDelta.y / 120 * 5;
                                if (Math.abs(templatePhotoPosition.rotation) < 4)
                                    templatePhotoPosition.rotation = 0;
                            } else {
                                templatePhotoPosition.rotation += wheel.angleDelta.x / 120;
                                if (Math.abs(templatePhotoPosition.rotation) < 0.6)
                                    templatePhotoPosition.rotation = 0;
                                //var scaleBefore = image.scale;
                                //image.scale += image.scale * wheel.angleDelta.y / 120 / 10;
                                //photoFrame.x -= image.width * (image.scale - scaleBefore) / 2.0;
                                //photoFrame.y -= image.height * (image.scale - scaleBefore) / 2.0;
                            }
                        }
                    }
                    /*
                    function setFrameColor() {
                        if (currentFrame)
                            currentFrame.border.color = "black";
                        currentFrame = photoFrame;
                        currentFrame.border.color = "red";
                    }
                    */
                }
            }


        }
    }
}
