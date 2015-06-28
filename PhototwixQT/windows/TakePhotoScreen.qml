import QtQuick 2.0
import QtQuick.Window 2.1

Rectangle {
    id: takePhotoScreen
    color: "blue"
    anchors.fill : parent

    Rectangle {
        width: 100
        height: 100
        color: "red"
        border.color: "black"
        border.width: 5
        radius: 10
    }
}
