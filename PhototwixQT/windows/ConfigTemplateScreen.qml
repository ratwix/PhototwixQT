import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: configTemplateScreen
    color: "yellow"
    anchors.fill : parent

    property url currentEditedTemplateUrl //TODO, remplacer par un template C++

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

            source: applicationWindows.currentEditedTemplate

            asynchronous: true
            cache: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.95
            width: parent.width * 0.95
            fillMode: Image.PreserveAspectFit
        }
    }
}
