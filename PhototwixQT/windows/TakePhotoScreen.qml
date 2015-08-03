import QtQuick 2.0
import QtQuick.Window 2.1

Rectangle {
    id: takePhotoScreen
    color: "blue"
    anchors.fill : parent

    Image {
        id: photoScreenTemplate
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: applicationWindows.currentPhotoTemplate.currentTemplate.url
        sourceSize.height: parent.height * 0.9
        cache: true
        asynchronous: true
        antialiasing: true

    }
}
