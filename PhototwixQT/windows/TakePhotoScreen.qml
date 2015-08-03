import QtQuick 2.0
import QtQuick.Window 2.1

Rectangle {
    id: takePhotoScreen
    color: "blue"
    height: parent.height
    width: parent.width

    Image {
        id: photoScreenTemplate
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: applicationWindows.currentPhotoTemplate.currentTemplate.url
        sourceSize.height: parent.height * 0.9
        cache: true
        asynchronous: false
        antialiasing: true
    }

    Image {
        source: "../resources/images/back_button.png"
        anchors.right: parent.right
        anchors.top : parent.top
        height: 60
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent

            onPressed: {
                mainRectangle.state = "START"
            }
        }
    }
}
