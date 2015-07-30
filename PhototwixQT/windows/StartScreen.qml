import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "../resources/controls"

Rectangle {
    id: startScreen
    color: "red"
    anchors.fill : parent

    Column {
        spacing: 10
        anchors.fill: parent

        GroupBox {
            id:takePhotoGroup
            height: parent.height * 0.5
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            ListView {
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
                                applicationWindows.currentPhotoTemplate = model.modelData
                                mainTabView.currentIndex = 1
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
}

