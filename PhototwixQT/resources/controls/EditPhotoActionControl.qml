import QtQuick 2.0

Rectangle {
    id:actionControl
    color:"white"

    height:300
    width:700

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 30

        EditPhotoActionButton {
            id:homeButton
            imagePath:"../images/home.png"
            onClicked: {
                home()
            }
        }

        EditPhotoActionButton {
            id:deleteButton
            imagePath:"../images/delete.png"
            onClicked: {
                delete_photo()
            }
        }

        EditPhotoActionButton {
            id:printButton
            imagePath:"../images/print.png"
            onClicked: {
                print_photo()
            }
        }
    }

    function home() {
        console.log("home")
        mainRectangle.state = "START"
    }

    function delete_photo() {
        console.log("delete")
    }

    function print_photo() {
        console.log("print")
    }
}

