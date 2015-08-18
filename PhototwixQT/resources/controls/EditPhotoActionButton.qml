import QtQuick 2.0

Item {
    id: container

    height: actionControl.height < actionControl.width ? actionControl.height * 0.90 : actionControl.width * 0.90
    width: actionControl.height > actionControl.width ? actionControl.width * 0.90 : actionControl.height * 0.90

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
            antialiasing: true
            smooth: true
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
