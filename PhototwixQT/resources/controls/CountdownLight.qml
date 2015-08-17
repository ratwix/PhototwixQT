import QtQuick 2.0

Rectangle {
    id: light
    state:"OFF"
    color: "transparent"

    Image {
        id: imageLight
        height: parent.height
        fillMode: Image.PreserveAspectFit
        antialiasing: true
        source: "../images/grey_button.png"
    }

    states: [
            State {
                name: "OFF"
                PropertyChanges { target: imageLight; source: "../images/grey_button.png"}
            },
            State {
                name: "GREEN"
                PropertyChanges { target: imageLight; source: "../images/green_button.png"}
            },
            State {
                name: "RED"
                PropertyChanges { target: imageLight; source: "../images/red_button.png"}
            }
        ]
}

