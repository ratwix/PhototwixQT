import QtQuick 2.0
import QtQuick.Window 2.1
import QtQml.Models 2.2
import QtMultimedia 5.4
import "../resources/controls"
import "../resources/renderer"

Rectangle {
    id: takePhotoScreen
    color: applicationWindows.backColor
    height: parent.height
    width: parent.width

    state:"PHOTO_SHOOT"

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
        p.currentPhoto = 0;
        takePhotoScreen.startPhotoProcess();
    }

    function startPhotoProcess() {
        countdown.start()
    }

    function endGlobalPhotoProcess() {
        var photoHeighP = 6;
        var dpi = 300;
        var firstsave = 0;

        function saveImage(result) {
            var d = new Date();
            var date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDay() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
            var imageName = "phototwix-" + date + ".png"
            var path = applicationDirPath + "/photos/" + imageName;
            result.saveToFile(path);
            applicationWindows.currentPhoto.name = d.getDay() + "/" + d.getMonth() + "/" + d.getFullYear() + " " + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"; //save image name
            applicationWindows.currentPhoto.finalResult = path; //save image path
            state = "PHOTO_EDIT" //TODO changer le changement d'etat une fois le call asynchrone fait
            if (firstsave == 0) {
                firstsave = 1;
            } else {
                parameters.photoGallery.Serialize();
            }
        }

        function saveImageSD(result) {
            var d = new Date();
            var date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDay() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
            var imageName = "phototwix-" + date + ".png"
            var path = applicationDirPath + "/photos/sd/" + imageName;
            result.saveToFile(path);
            applicationWindows.currentPhoto.finalResultSD = path; //save image path
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

        //Serialize gallery after new insertion
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageSaved: {
                var path = camera.imageCapture.capturedImagePath
                applicationWindows.currentPhoto.photoPartList[p.currentPhoto].path = path;
                photoPartRepeater.itemAt(p.currentPhoto).endPhotoProcess(path)
            }
        }

        onCameraStatusChanged: {
            if (cameraStatus == Camera.ActiveStatus) {

                var fr = camera.supportedViewfinderFrameRateRanges();
                console.log("Frame rate : " + JSON.stringify(fr));


                var res = camera.supportedViewfinderResolutions(15);
                console.log("Camera resolution : " + JSON.stringify(res));

                camera.viewfinder.resolution = Qt.size(res[res.length - 1].width, res[res.length - 1].height);

                var cres = camera.viewfinder.resolution;  //Choose the best resolution available

                applicationWindows.cameraRation = cres.width / cres.height;
                p.cameraHeight = cres.height
                p.cameraWidth = cres.width

                console.log("Current " + cres.width + ":" + cres.height + " ratio:" + applicationWindows.cameraRation);
            }
        }
    }

    VideoOutput {
            id: cameraVideoOutput
            height: p.cameraHeight
            width: p.cameraWidth
            source: camera
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
                model:applicationWindows.currentPhoto ? applicationWindows.currentPhoto.photoPartList : undefined
                delegate: PhotoShootRenderer {
                    y: photoScreenTemplate.y + photoScreenTemplate.height * modelData.photoPosition.y
                    x: photoScreenTemplate.x + photoScreenTemplate.width * modelData.photoPosition.x
                    height: photoScreenTemplate.height * modelData.photoPosition.height
                    width: photoScreenTemplate.width * modelData.photoPosition.width
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
                photoPartRepeater.itemAt(p.currentPhoto).startPhotoProcess()
            }

            onEndCount: { //fin de prise d'une photo
                var d = new Date();
                var date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDay() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
                var imageName = "phototwix-" + date + ".jpg" //TODO : modifier cet element. Doit etre un jpg
                var imagePath = applicationDirPath + "/photos/single/" + imageName;
                camera.imageCapture.captureToLocation(imagePath)
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

    MessageScreen {
        id:mbox
    }

    ConfirmScreen {
        id:cbox
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
