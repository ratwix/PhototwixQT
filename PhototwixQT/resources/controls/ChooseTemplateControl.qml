import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import QtQuick.Particles 2.0

import "../controls"

Item {
    property int last_template_index: -1

    Component {
        id: activeTemplateDelegate

        //Last template have particle system. This is this one that will be selected when press button
        Item {
            height: parent.height * 0.9
            width: templateSelect.width

            Rectangle {
                color:applicationWindows.backTemplateColor
                anchors.fill: parent
                visible: index == last_template_index
                /*
                ParticleSystem {
                    anchors.fill: parent
                    ImageParticle {
                        groups: ["stars"]
                        anchors.fill: parent
                        source: "../images/star.png"
                    }

                    Emitter {
                        group: "stars"
                        emitRate: 100
                        lifeSpan: 2400
                        size: 24
                        sizeVariation: 8
                        anchors.fill: parent
                    }

                    Turbulence {
                        anchors.fill: parent
                        strength: 2
                    }
                }
                */
            }

            Rectangle {
                color:applicationWindows.backTemplateColor
                anchors.fill: parent
                visible: index != last_template_index
            }

            //Template image
            Image {
                id: templateSelect
                source: modelData.url
                height: parent.height
                fillMode: Image.PreserveAspectFit
                cache: true
                asynchronous: false
                antialiasing: true

                MouseArea {
                    id: templateSelectMouseArea
                    anchors.fill: parent

                    onClicked: {
                        applicationWindows.currentPhoto = parameters.addPhotoToGallerie("Test", model.modelData)
                        cameraWorker.capturePreview()
                        applicationWindows.effectSource = "Couleur"
                        mainRectangle.state = "TAKE_PHOTO"
                        last_template_index = index
                    }
                }
            }
        }
    }


    Row {
        height: parent.height
        anchors.horizontalCenter:parent.horizontalCenter
        spacing: 20
        Repeater {
            model: currentActiveTemplates
            delegate: activeTemplateDelegate
        }
    }

    //Arduino management
    Connections {
        target: parameters.arduino
        onPhotoButtonRelease: {
            if ((mainRectangle.state == "START") &&                     //Quand on est sur l'ecran de départ
                (takePhotoScreen.state == "PHOTO_SHOOT") &&
                (startScreen.galleryControlAlias.state == "stacked") &&
                (last_template_index != -1)) {

                applicationWindows.currentPhoto = parameters.addPhotoToGallerie("Test", currentActiveTemplates[last_template_index])
                applicationWindows.effectSource = "Couleur"
                mainRectangle.state = "TAKE_PHOTO"
            } else {
                if ((mainRectangle.state != "START") && (takePhotoScreen.state == "PHOTO_SHOOT")) { //On ne revient pas au départ pendant la prise de photo

                } else {
                    applicationWindows.resetStates();
                    mbox.state = "hide"
                    cbox.state = "hide"
                }
            }
        }
    }
}

