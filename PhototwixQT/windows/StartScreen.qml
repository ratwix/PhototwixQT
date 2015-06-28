import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: startScreen
    color: "red"
    anchors.fill : parent

    Rectangle {
        width: 100
        height: 100
        color: "blue"
        border.color: "white"
        border.width: 5
        radius: 10
    }

    Column {
        spacing: 10
        anchors.fill: parent

        GroupBox {
            id:takePhotoGroup
            height: parent.height * 0.5
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            ButtonImage {
                id: takePhotoButton;
                label: "Take Photo";
                //rotation: -2;
                onClicked:
                {
                    mainTabView.currentIndex = 1
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            GroupBox {
                id: takePhotoOptionGroup
                anchors.left: takePhotoButton.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 50

                Row {
                    spacing: 20

                    ButtonSelectorImage {
                        id: onePhotoShoot; label: "1 Photo";
                        onClicked:
                        {

                        }
                    }

                    ButtonSelectorImage {
                        id: twoPhotoShoot; label: "2 Photo";
                        onClicked:
                        {

                        }
                    }

                    ButtonSelectorImage {
                        id: fourPhotoShoot; label: "4 Photo";
                        onClicked:
                        {

                        }
                    }

                    ButtonSelectorImage {
                        id: gamePhotoShoot; label: "Game Photo";
                        onClicked:
                        {

                        }
                    }
                }
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
}

