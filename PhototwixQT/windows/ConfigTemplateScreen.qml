
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: configTemplateScreen

    height: parent.height
    width: parent.width

    property double aspectRation : 1.5 //TODO, replace with camera aspect ration

    property var currentFrame: undefined
    property int currentFrameNumber : 0

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
                id: deletePhoto;
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Supprimer";
                onClicked:
                {
                    if (currentFrame) {
                        applicationWindows.currentEditedTemplate.deleteTemplatePhotoPosition(currentFrameNumber);
                        updateTemplatePhotoPositionsRepeater();
                    }
                }
            }

            ButtonImage {
                id: saveTemplate;
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Sauvegarder";
                onClicked:
                {
                    parameters.Serialize();
                    mainRectangle.state = "CONFIG"
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

            Repeater { //Affichage de tout les photo frame
                id:templatePhotoPositionsRepeater
                anchors.fill: parent

                model: applicationWindows.currentEditedTemplate.templatePhotoPositions

                Rectangle {
                    id:templatePhotoPosition
                    y: currentEditedTemplate.height * modelData.y
                    x: currentEditedTemplate.width * modelData.x
                    z:10
                    height: currentEditedTemplate.height * modelData.height
                    width: height * aspectRation
                    rotation: modelData.rotate
                    color: "#800000FF"
                    smooth: true
                    antialiasing: true
                    property bool renderFinish: false

                    onXChanged: {
                        if (renderFinish) {
                            calculateCoord()
                        }
                    }

                    onYChanged: {
                        if (renderFinish) {
                            calculateCoord()
                        }
                    }

                    onRotationChanged: {
                        if (renderFinish) {
                            modelData.rotate = rotation;
                        }
                    }

                    onHeightChanged: {
                        if (renderFinish) {
                            modelData.height = templatePhotoPosition.height / currentEditedTemplate.height
                        }
                    }

                    onWidthChanged: {
                        if (renderFinish) {
                            modelData.width = templatePhotoPosition.width / currentEditedTemplate.width
                        }
                    }

                    Component.onCompleted: {
                        renderFinish = true
                    }

                    function calculateCoord() {
                        var tx = templatePhotoPosition.x;
                        var ty = templatePhotoPosition.y;

                        var maxx = currentEditedTemplate.width
                        var maxy = currentEditedTemplate.height

                        var px = tx / maxx;
                        var py = ty / maxy;

                        modelData.x = px;
                        modelData.y = py;
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
                            onEntered: {
                                currentFrameNumber = modelData.number;
                                parent.setFrameColor();
                            }

                            onWheel: {
                                if (wheel.modifiers & Qt.ControlModifier) {
                                    templatePhotoPosition.rotation += wheel.angleDelta.y / 120;
                                    if (Math.abs(templatePhotoPosition.rotation) < 0.6)
                                        templatePhotoPosition.rotation = 0;
                                } else {
                                    templatePhotoPosition.rotation += wheel.angleDelta.x / 120;
                                    if (Math.abs(templatePhotoPosition.rotation) < 0.6)
                                        templatePhotoPosition.rotation = 0;
                                    var heighBefore = templatePhotoPosition.height;
                                    var widthBefore = templatePhotoPosition.width;
                                    templatePhotoPosition.height += templatePhotoPosition.height * wheel.angleDelta.y / 120 / 60;
                                    templatePhotoPosition.width =  widthBefore / heighBefore * templatePhotoPosition.height
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
}
