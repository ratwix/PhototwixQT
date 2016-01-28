import QtQuick 2.4

Rectangle {
    id:actionControl
    color:"white"

    state:"editPhoto"

    Grid {
        id:gridButton
        columns: parameters.mailActive ? 4 : 3
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
                if (parameters.blockPrint && parameters.nbprint >= parameters.blockPrintNb) {
                    mbox.message = "Plus d'impressions disponibles..."
                    mbox.imageSource = "../images/print.png"
                    mbox.state = "show"
                } else {
                    parameters.updatePaperPrint();
                    if (parameters.paperprint < 15) { //Warning if paper become low
                        mbox.message = "Impression en cours.\nPlus que " + parameters.paperprint + " feuilles"
                        mbox.imageSource = "../images/print.png"
                        mbox.state = "show"
                        print_photo()
                    } else {
                        if (parameters.paperprint < 2) {
                            mbox.message = "Plus de papier"
                            mbox.imageSource = "../images/print.png"
                            mbox.state = "show"
                        } else {
                            mbox.message = "Impression en cours"
                            mbox.imageSource = "../images/print.png"
                            mbox.state = "show"
                            print_photo()
                        }
                    }
                }
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

        EditPhotoActionButton {
            id:mailButton
            visible: parameters.mailActive
            imagePath:"../images/mail.png"
            onClicked: {
                if (actionControl.state == "viewPhoto") {
                    currentPhoto = parameters.photoGallery.photoList[photosListView.currentIndex];
                }
                mailScreen.currentPhoto = currentPhoto;
                mailScreen.state = "show"
                console.log("Tachatte")
            }
        }

        EditPhotoActionButton {
            id:shareButton
            visible: parameters.sharing
            imagePath:"../images/share.png"
            onClicked: {

            }
        }
    }

    function home() {

        applicationWindows.resetStates()
    }

    function delete_photo() {

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


    function print_share_photo(boolPrint) {
        if (state == "viewPhoto") {
            var url = parameters.photoGallery.photoList[photosListView.currentIndex].finalResult;
            var doubleprint = parameters.photoGallery.photoList[photosListView.currentIndex].currentTemplate.doubleprint;
            var cutprint = parameters.photoGallery.photoList[photosListView.currentIndex].currentTemplate.printcutter;
            var landscape = parameters.photoGallery.photoList[photosListView.currentIndex].currentTemplate.landscape;
            console.debug("Print " + url);
            if (boolPrint) {
                parameters.printPhoto(url, doubleprint, cutprint, landscape);
            } else {
                sendPhotoToShareServer(url);
            }
        } else if (state == "editPhoto") { //Save image in a tmp directory to apply effects, then print the file
            var photoHeighP = 6;
            var dpi = 300;

            if (applicationWindows.effectSource == "Couleur") {
                //No need to regenerate image, just print
                if (applicationWindows.currentPhoto == null) {
                    return;
                }

                var url = applicationWindows.currentPhoto.finalResult;
                var doubleprint = applicationWindows.currentPhoto.currentTemplate.doubleprint;
                var cutprint = applicationWindows.currentPhoto.currentTemplate.printcutter;
                var landscape = applicationWindows.currentPhoto.currentTemplate.landscape;
                console.debug("Print " + url);
                if (boolPrint) {
                    parameters.printPhoto(url, doubleprint, cutprint, landscape);
                } else {
                    sendPhotoToShareServer(url);
                }

                return;
            }
            //else regenerate the image with effects
            function saveImage(result) {
                var imageName = "tmp.png"
                var url = applicationDirPath + "/" + imageName;
                var doubleprint = applicationWindows.currentPhoto.currentTemplate.doubleprint;
                var cutprint = applicationWindows.currentPhoto.currentTemplate.printcutter;
                var landscape = applicationWindows.currentPhoto.currentTemplate.landscape;

                result.saveToFile(url);
                console.debug("Print " + url);
                if (boolPrint) {
                    parameters.printPhoto(url, doubleprint, cutprint, landscape);
                } else {
                    sendPhotoToShareServer(url);
                }
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

    function print_photo() {
        print_share_photo(true);
    }

    function share_photo() {
        print_share_photo(false);
    }

    function sendPhotoToShareServer(url) {
        //shareScreen.state = "show"
    }

    Connections {
        target: parameters.arduino
        onPrintButtonRelease: {
            if (actionControl.opacity > 0) {
                console.debug("Print ok");
                printButton.clicked();
            } else {
                console.debug("Click print : not on right screen");
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

