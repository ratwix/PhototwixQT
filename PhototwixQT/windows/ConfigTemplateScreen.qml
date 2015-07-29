
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: configTemplateScreen

    anchors.fill : parent

    property double aspectRation : 1.5 //TODO, replace with camera aspect ration

    property var currentFrame: undefined

    function updateTemplatePhotoPositionsRepeater() {
        templatePhotoPositionsRepeater.model = applicationWindows.currentEditedTemplate.templatePhotoPositions;
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
                    updateTemplatePhotoPositionsRepeater();
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

        property int highestZ: 0


        color: "yellow"
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
            width: sourceSize.width / sourceSize.height * height //conserv aspect ratio. Can't use native fonction, coords incorect

            onSourceChanged: {
                updateTemplatePhotoPositionsRepeater();
            }
        }

        Repeater { //Affichage de tout les photo frame
            id:templatePhotoPositionsRepeater
            anchors.fill: parent

            model: applicationWindows.currentEditedTemplate.templatePhotoPositions

            Rectangle {
                id:templatePhotoPosition
                x:0
                y:0
                z:10
                height: 200
                width: height * aspectRation
                color: "#800000FF"
                smooth: true
                antialiasing: true

                onXChanged: {
                    calculateCoord()
                }

                onYChanged: {
                    calculateCoord()
                }

                onRotationChanged: {
                    modelData.rotate = rotation;
                }

                onHeightChanged: {
                    modelData.height = templatePhotoPosition.height / currentEditedTemplate.height
                }

                onWidthChanged: {
                    modelData.width = templatePhotoPosition.width / currentEditedTemplate.width
                }


                function calculateCoord() {
                    var cords = templatePhotoPosition.mapToItem(null, 0, 0);
                    var cords2 = currentEditedTemplate.mapToItem(null, 0, 0);

                    //x, y relative to
                    var x = cords.x - cords2.x;
                    var y = cords.y - cords2.y;

                    var maxx = currentEditedTemplate.width
                    var maxy = currentEditedTemplate.height

                    var px = x / maxx;
                    var py = y / maxy;

                    modelData.x = px;
                    modelData.y = py;

                    //console.info("x:", x, "y:", y, "maxx", maxx, "maxy", maxy, "px", px, "py", py);
                }

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
                    onPinchStarted: setFrameColor();
                    MouseArea {
                        id: dragArea
                        hoverEnabled: true
                        anchors.fill: parent
                        drag.target: templatePhotoPosition
                        onPressed: {
                            templatePhotoPosition.z = ++configTemplateScreenTemplate.highestZ; //set element to top
                            parent.setFrameColor();
                        }
                        onEntered: parent.setFrameColor();
                        onWheel: {
                            if (wheel.modifiers & Qt.ControlModifier) {
                                templatePhotoPosition.rotation += wheel.angleDelta.y / 120 * 5;
                                if (Math.abs(templatePhotoPosition.rotation) < 4)
                                    templatePhotoPosition.rotation = 0;
                            } else {
                                templatePhotoPosition.rotation += wheel.angleDelta.x / 120;
                                if (Math.abs(templatePhotoPosition.rotation) < 0.6)
                                    templatePhotoPosition.rotation = 0;
                                var heighBefore = templatePhotoPosition.height;
                                var widthBefore = templatePhotoPosition.width;
                                templatePhotoPosition.height += templatePhotoPosition.height * wheel.angleDelta.y / 120 / 40;
                                templatePhotoPosition.x -= (templatePhotoPosition.width - widthBefore) / 2.0;
                                templatePhotoPosition.y -= (templatePhotoPosition.height - heighBefore) / 2.0;
                            }
                        }
                    }

                    function setFrameColor() {
                        if (currentFrame)
                            currentFrame.color = "#800000FF";
                        currentFrame = templatePhotoPosition;
                        currentFrame.color = "#80FF0000";
                    }

                }
            }


        }
    }
}
