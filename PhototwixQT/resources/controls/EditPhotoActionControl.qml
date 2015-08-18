import QtQuick 2.4

Rectangle {
    id:actionControl
    color:"white"

    state:"editPhoto"

    Grid {
        id:gridButton
        columns: 3
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
        if (galleryControl) {
            galleryControl.state = "stacked"
        }
    }

    function delete_photo() {
        console.log("delete")
        if (state == "viewPhoto") {
            var name = parameters.photoGallery.photoList[photosGridView.currentIndex].name;
            console.debug("Delete1 " + name);
            parameters.photoGallery.removePhoto(name);
            mainRectangle.state = "START"
            galleryControl.state = "inGrid"
        } else if (state == "editPhoto") {
            var name = currentPhoto.name;
            console.debug("Delete2 " + currentPhoto.name);
            parameters.photoGallery.removePhoto(name);
            mainRectangle.state = "START"
            galleryControl.state = "stacked"
            currentPhoto = undefined;
        }
    }

    function print_photo() {
        console.log("print")
    }

    states: [
        State {
            name: "editPhoto"
        },
        State {
            name: "viewPhoto"
            PropertyChanges { target: gridButton
                              columns: 1
            }

        }

    ]
}

