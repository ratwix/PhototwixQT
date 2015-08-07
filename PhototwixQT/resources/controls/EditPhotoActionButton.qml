import QtQuick 2.0

Item {
    id: container

    height: actionControl.height * 0.95
    width: height

    property url imagePath: "value"
    signal clicked

    Rectangle {
        id:homeButton
        anchors.fill: parent
        color:"#212126"
        radius:height / 7

        Image {
            id: logo
            source: imagePath
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.6
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            anchors { fill: parent;  }
            onClicked: container.clicked()
        }
    }




}
