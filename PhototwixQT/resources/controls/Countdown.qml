import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Rectangle {
    height: parent.height
    color: "transparent"

    function updateStatus(nb) {
        if (nb < 1) {
            light1.state = "OFF"
            light2.state = "OFF"
            light3.state = "OFF"
        }

        if (nb == 1) {
            light1.state = "RED"
            light2.state = "OFF"
            light3.state = "OFF"
        }

        if (nb == 2) {
            light1.state = "RED"
            light2.state = "RED"
            light3.state = "OFF"
        }

        if (nb == 3) {
            light1.state = "RED"
            light2.state = "RED"
            light3.state = "RED"
        }

        if (nb > 3) {
            light1.state = "GREEN"
            light2.state = "GREEN"
            light3.state = "GREEN"
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: parent.height
        spacing: 15

        CountdownLight {
            height: parent.height
            width: height
            id: light1
        }
        CountdownLight {
            height: parent.height
            width: height
            id: light2
        }
        CountdownLight {
            height: parent.height
            width: height
            id: light3
        }
    }
}

