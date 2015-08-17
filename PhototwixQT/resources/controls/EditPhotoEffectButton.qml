import QtQuick 2.0

Rectangle {
    property string effectName: ""
    property url    effectImage: ""

    Image {
        anchors.fill: parent
        antialiasing: true
        fillMode: Image.Stretch
        source: effectImage
    }

    Rectangle {
        border.color: "white"
        border.width: 1
        color: "#A0707070"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height * 0.20
        width: parent.width * 0.60

        Text {
            id: effectNameLabel
            text: qsTr(effectName)
            font.pixelSize: parent.height * 0.6
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
        }
    }
}

