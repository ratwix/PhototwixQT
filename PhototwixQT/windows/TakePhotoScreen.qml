import QtQuick 2.0
import QtQuick.Window 2.1
import QtQml.Models 2.2
import QtMultimedia 5.4
import "../resources/controls"
import "../resources/renderer"

Item {
    id: takePhotoScreen
    //color: applicationWindows.backColor
    height: parent.height
    width: parent.width

    //property alias camera: camera
    property alias cameraVideoOutput: cameraVideoOutput

    property variant frameRate
    property variant resolution

    property bool camera_ready: false

    state:"PHOTO_SHOOT"

    MouseArea {
        anchors.fill: parent
    }

    QtObject {
        id:p
        property int cameraHeight : 0
        property int cameraWidth : 0
        property int currentPhoto : 0
        property int nb_photos : photoPartModel.count
    }

    function init() {
        countdown.init()
    }

    function startGlobalPhotoProcess() {
        //timerPhotoPreview.running = true;
        p.currentPhoto = 0;
        parameters.arduino.flashSwitchOn();
        takePhotoScreen.startPhotoProcess();
    }

    function startPhotoProcess() {
        //timerPhotoPreview.running = true;
        countdown.start()
    }

    function endGlobalPhotoProcess() {
        //timerPhotoPreview.running = false;
        var photoHeighP = 6;
        var dpi = 300;
        var firstsave = 0;

        parameters.arduino.flashSwitchOff();

        function saveImage(result) {
            var d = new Date();
            var date = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
            var imageName = "phototwix-" + date + ".png"
            var path = applicationDirPath + "/photos/" + imageName;
            result.saveToFile(path);
            applicationWindows.currentPhoto.name = d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear() + " " + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"; //save image name
            applicationWindows.currentPhoto.finalResultS = path; //save image path
            state = "PHOTO_EDIT" //TODO changer le changement d'etat une fois le call asynchrone fait
            if (firstsave == 0) {
                firstsave = 1;
            } else {
                parameters.photoGallery.Serialize();
            }
        }

        function saveImageSD(result) {
            var d = new Date();
            var date = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
            var imageName = "phototwix-" + date + ".png"
            var path = applicationDirPath + "/photos/sd/" + imageName;
            result.saveToFile(path);
            applicationWindows.currentPhoto.finalResultSDS = path; //save image path
            if (firstsave == 0) {
                firstsave = 1;
            } else {
                parameters.photoGallery.Serialize();
            }
        }

        //HQ
        if (takePhotoScreenPhotoSizedBlock.height > takePhotoScreenPhotoSizedBlock.width) { //Photo in portrait
            var captureHeight = photoHeighP * dpi;
            var captureWidth = takePhotoScreenPhotoSizedBlock.width / takePhotoScreenPhotoSizedBlock.height * captureHeight;
            takePhotoScreenPhotoSizedBlock.grabToImage(saveImage, Qt.size(captureWidth, captureHeight));
        } else { //Photo in landscape
            var captureWidth = photoHeighP * dpi;
            var captureHeight = takePhotoScreenPhotoSizedBlock.height / takePhotoScreenPhotoSizedBlock.width * captureWidth;
            takePhotoScreenPhotoSizedBlock.grabToImage(saveImage, Qt.size(captureWidth, captureHeight));
        }

        //SD
        if (takePhotoScreenPhotoSizedBlock.height > takePhotoScreenPhotoSizedBlock.width) { //Photo in portrait
            var captureHeight = photoHeighP * dpi / 5;
            var captureWidth = takePhotoScreenPhotoSizedBlock.width / takePhotoScreenPhotoSizedBlock.height * captureHeight;
            takePhotoScreenPhotoSizedBlock.grabToImage(saveImageSD, Qt.size(captureWidth, captureHeight));
        } else { //Photo in landscape
            var captureWidth = photoHeighP * dpi / 5;
            var captureHeight = takePhotoScreenPhotoSizedBlock.height / takePhotoScreenPhotoSizedBlock.width * captureWidth;
            takePhotoScreenPhotoSizedBlock.grabToImage(saveImageSD, Qt.size(captureWidth, captureHeight));
        }

        cameraWorker.closeCamera();

        //Serialize gallery after new insertion
    }

    function endGlobalPhotoProcessAfterError() {
        console.log("La capture a merder, faut stopper le process")
        parameters.arduino.flashSwitchOff();
        //TODO: supprimer la derniere tentative
        applicationWindows.resetStates();
        parameters.photoGallery.removeFirstPhoto();
        mbox.message = "Ooops.. quelque chose n'a pas fonctionné"
        mbox.imageSource = "../images/Refuse-icon.png"
        mbox.state = "show"
    }


    //Connection to cameraWorker in C++
    Connections {
            target: cameraWorker

            onImageCaptured: {
                console.log("Image captured!" + fileName)

                var path = fileName
                applicationWindows.currentPhoto.photoPartList[p.currentPhoto].pathS = path; //TODO: bug, type conversion on linux date to string add qrc://
                photoPartRepeater.itemAt(p.currentPhoto).endPhotoProcess(path)
            }

            onImageCaptureError: {
                endGlobalPhotoProcessAfterError();
            }
    }


    Timer {
            id: timerPhotoPreview
            interval: 100;
            running: false;
            repeat: true
            onTriggered: {
                cameraWorker.capturePreview();
                cameraVideoOutput.source = "image://camerapreview/" + Math.random();
                // change URL to refresh image. Add random URL part to avoid caching
            }
    }

    Image {
        id: cameraVideoOutput
        source:"image://camerapreview/1"
        visible: false
    }

    Item {
        id:takePhotoScreenPhotoBlock
        anchors.top : parent.top
        anchors.topMargin: 10
        height: parent.height * 0.90
        width: parent.width
        anchors.left:editPhotoEffectControl.right

        Rectangle {
            id:takePhotoScreenPhotoSizedBlock
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height * 0.95
            width: photoScreenTemplate.sourceSize.width / photoScreenTemplate.sourceSize.height * height


            DelegateModel {
                id: photoPartModel
                model:applicationWindows.currentPhoto ? applicationWindows.currentPhoto.photoPartList : null
                delegate: PhotoShootRenderer {
                    y: photoScreenTemplate.y + photoScreenTemplate.height * modelData.photoPosition.y
                    x: photoScreenTemplate.x + photoScreenTemplate.width * modelData.photoPosition.x + photoScreenTemplate.width * modelData.photoPosition.width * modelData.photoPosition.xphoto
                    xphoto: modelData.photoPosition.xphoto
                    height: photoScreenTemplate.height * modelData.photoPosition.height
                    width: photoScreenTemplate.width * modelData.photoPosition.width - photoScreenTemplate.width * modelData.photoPosition.width * modelData.photoPosition.xphoto * 2
                    rotation: modelData.photoPosition.rotate
                    photoIndex: modelData.photoPosition.number
                    onProcessEnd: {
                        p.currentPhoto++;
                        if (p.currentPhoto < p.nb_photos) { //All photos are not taken, shoot again
                            takePhotoScreen.startPhotoProcess();
                        } else {  //finis all photos
                            endGlobalPhotoProcess();
                        }
                    }
                }
            }

            Repeater {
                id:photoPartRepeater
                anchors.fill: parent
                model:photoPartModel
            }


            Image { //Back template
                id: photoScreenTemplate
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: applicationWindows.currentPhoto ? applicationWindows.currentPhoto.currentTemplate.url : ""
                height: parent.height
                width: parent.width
                cache: true
                asynchronous: false
                antialiasing: true
            }
        }
    }

    Item {
        id:takePhotoScreenBottomBlock
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.top: takePhotoScreenPhotoBlock.bottom
        width: parent.width

        Countdown {
            id: countdown
            height: parent.height
            width: parent.width
            x:0
            y:0

            onStartCount: { //debut de prise d'une photo
                timerPhotoPreview.running = true;
                photoPartRepeater.itemAt(p.currentPhoto).startPhotoProcess()
            }

            onEndCount: { //fin de prise d'une photo
                timerPhotoPreview.running = false;
                var d = new Date();
                var date = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
                var imageName = "phototwix-" + date + ".jpg" //TODO : modifier cet element. Doit etre un jpg
                var imagePath = applicationDirPath + "/photos/single/" + imageName;
                cameraWorker.capturePhoto(imagePath)
                //camera.imageCapture.captureToLocation(imagePath)
                //TODO: ajouter l'image a l'image part
            }
        }

        EditPhotoActionControl {
            id:editPhotoActionControl
            state:"editPhoto"
            height: parent.height
            width: parent.width
            x:0
            y:takePhotoScreenBottomBlock.height + takePhotoScreenBottomBlock.anchors.bottomMargin
            opacity: 0.0
        }
    }

    EditPhotoEffectControl {
        id:editPhotoEffectControl
        width: 200
        height: parent.height
        anchors.top: parent.top
        x:-200
        visible: false
    }

    /*
    MessageScreen {
        id:mbox
    }

    ConfirmScreen {
        id:cbox
    }
*/

    MailScreen {
        id: mailScreen
        onSuccess: {

        }
        onFailed: {

        }
    }

    onStateChanged: {
        applicationWindows.effectSource = "Couleur"
    }

    states: [
        State {
            name: "PHOTO_SHOOT"
        },
        State {
            name: "PHOTO_EDIT"
            PropertyChanges { target: editPhotoEffectControl
                              visible: true
                              x:0
            }
            PropertyChanges { target: countdown
                              y: takePhotoScreenBottomBlock.height + takePhotoScreenBottomBlock.anchors.bottomMargin
            }
            PropertyChanges { target: editPhotoActionControl
                              y: 0
                              opacity: 1.0
            }
            PropertyChanges { target: takePhotoScreenBottomBlock
                              anchors.bottomMargin: 0
            }
        }

    ]

    transitions: [
      Transition {
          from: "PHOTO_SHOOT"; to: "PHOTO_EDIT"
          ParallelAnimation {
              PropertyAnimation { target: editPhotoEffectControl
                                  properties: "x"
                                  easing.type: Easing.Linear
                                  duration: 250 }
              SequentialAnimation {
                  PropertyAnimation { target: countdown
                                      properties: "y"
                                      easing.type: Easing.Linear
                                      duration: 125 }
                  PropertyAnimation { target: editPhotoActionControl
                                      properties: "y"
                                      easing.type: Easing.Linear
                                      duration: 125 }
              }
          }
      }
    ]
}
