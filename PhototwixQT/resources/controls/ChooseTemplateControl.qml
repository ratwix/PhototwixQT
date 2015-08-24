import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml.Models 2.2

import "../controls"

ListView {
    id:chooseTemplateListView

    orientation: Qt.Horizontal
    spacing: 20
    preferredHighlightBegin: 150 - 15 //TODO : meilleur alignement Component.onCompleted: positionViewAtIndex(count - 1, ListView.Beginning)
    preferredHighlightEnd: 150 + 15

    highlight: Rectangle {
        color:"#193259"
        height: parent.height
        width:  parent.width


    }

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
                    chooseTemplateListView.currentIndex = index
                    chooseTemplateListView.positionViewAtBeginning()
                }
            }
        }
    }

    model: currentActiveTemplates
    delegate: activeTemplateDelegate

    Component.onCompleted: {
        positionViewAtIndex(count / 2 + 1, ListView.Center) //TODO marche pas
    }

    Connections {
        target: parameters.arduino
        onPhotoButtonRelease: {
            if ((mainRectangle.state == "START") &&                     //Quand on est sur l'ecran de départ
                (takePhotoScreen.state == "PHOTO_SHOOT") &&
                (startScreen.galleryControlAlias.state == "stacked") &&
                (chooseTemplateListView.currentIndex != -1)) {

                applicationWindows.currentPhoto = parameters.addPhotoToGallerie("Test", currentActiveTemplates[chooseTemplateListView.currentIndex])
                applicationWindows.effectSource = "color"
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


