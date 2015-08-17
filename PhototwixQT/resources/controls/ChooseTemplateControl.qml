import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml.Models 2.2

import "../controls"

ListView {
    id:chooseTemplateListView

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
