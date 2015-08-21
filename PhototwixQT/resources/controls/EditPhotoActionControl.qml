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
                cbox.message = "Supprimer la photo ?"
                cbox.acceptFunction = delete_photo
                cbox.state = "show"
            }
        }

        EditPhotoActionButton {
            id:printButton
            imagePath:"../images/print.png"
            onClicked: {
                mbox.message = "Impression en cours"
                mbox.imageSource = "../images/print.png"
                mbox.state = "show"
                print_photo()
            }
        }

        EditPhotoActionButton {
            id:editButton
            imagePath:"../images/paint_bucket.png"
            onClicked: {
                currentPhoto = parameters.photoGallery.photoList[photosListView.currentIndex];
                applicationWindows.showEdit();

            }
            visible: false
        }
    }

    function home() {
        console.log("home")
        applicationWindows.resetStates()
        /*
        mainRectangle.state = "START"
        if (typeof galleryControl !== 'undefined') {
            galleryControl.state = "stacked"
        }
        */
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
            if (typeof galleryControl !== 'undefined') {
                galleryControl.state = "stacked"
            }
            currentPhoto = undefined;
        }
    }

    function print_photo() {
        if (state == "viewPhoto") {
            var url = parameters.photoGallery.photoList[photosListView.currentIndex].finalResult;
            var doubleprint = parameters.photoGallery.photoList[photosListView.currentIndex].currentTemplate.doubleprint;
            var cutprint = parameters.photoGallery.photoList[photosListView.currentIndex].currentTemplate.printcutter;
            console.log("Print " + url);
            parameters.printPhoto(url, doubleprint, cutprint);
        } else if (state == "editPhoto") { //Save image in a tmp directory to apply effects, then print the file
            var photoHeighP = 6;
            var dpi = 300;

            if (applicationWindows.effectSource == "color") {
                //No need to regenerate image, just print
                var url = applicationWindows.currentPhoto.finalResult;
                var doubleprint = applicationWindows.currentPhoto.currentTemplate.doubleprint;
                var cutprint = applicationWindows.currentPhoto.currentTemplate.printcutter;
                console.log("Print " + url);
                parameters.printPhoto(url, doubleprint, cutprint);
                return;
            }
            //else regenerate the image with effects
            function saveImage(result) {
                var imageName = "tmp.png"
                var url = applicationDirPath + "/" + imageName;
                var doubleprint = applicationWindows.currentPhoto.currentTemplate.doubleprint;
                var cutprint = applicationWindows.currentPhoto.currentTemplate.printcutter;

                result.saveToFile(url);
                console.log("Print " + url);
                parameters.printPhoto(url, doubleprint, cutprint);
            }

            if (takePhotoScreenPhotoSizedBlock.height > takePhotoScreenPhotoSizedBlock.width) { //Photo in portrait
                var captureHeight = photoHeighP * dpi;
                var captureWidth = takePhotoScreenPhotoSizedBlock.width / takePhotoScreenPhotoSizedBlock.height * captureHeight;
                takePhotoScreenPhotoSizedBlock.grabToImage(saveImage, Qt.size(captureWidth, captureHeight));
            } else { //Photo in landscape
                var captureWidth = photoHeighP * dpi;
                var captureHeight = takePhotoScreenPhotoSizedBlock.height / takePhotoScreenPhotoSizedBlock.width * captureWidth;
                takePhotoScreenPhotoSizedBlock.grabToImage(saveImage, Qt.size(captureWidth, captureHeight));
            }
        }
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
            PropertyChanges {
                target: editButton
                visible: true
            }

        }

    ]
}

