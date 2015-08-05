import QtQuick 2.0
import QtQuick.Window 2.1
import QtQml.Models 2.2
import QtMultimedia 5.4
import "../resources/controls"
import "../resources/renderer"

Rectangle {
    id: takePhotoScreen
    color: "blue"
    height: parent.height
    width: parent.width

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

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageSaved: {
                var path = "file:///" + camera.imageCapture.capturedImagePath
                applicationWindows.currentPhotoTemplate.photoPartList[p.currentPhoto].path = path;
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

                console.log("Current " + cres.width + ":" + cres.height + " ration:" + applicationWindows.cameraRation);
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


        DelegateModel {
            id: photoPartModel
            model:applicationWindows.currentPhotoTemplate ? applicationWindows.currentPhotoTemplate.photoPartList : undefined
            delegate: PhotoShootRenderer {
                y: photoScreenTemplate.y + photoScreenTemplate.height * modelData.photoPosition.y
                x: photoScreenTemplate.x + photoScreenTemplate.width * modelData.photoPosition.x
                height: photoScreenTemplate.height * modelData.photoPosition.height
                width: photoScreenTemplate.width * modelData.photoPosition.width
                rotation: modelData.photoPosition.rotate
                photoIndex: modelData.photoPosition.number
                onProcessEnd: {
                    p.currentPhoto++;
                    if (p.currentPhoto < p.nb_photos) { //We reshoot if some photos miss
                        takePhotoScreen.startPhotoProcess();
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
            source: applicationWindows.currentPhotoTemplate ? applicationWindows.currentPhotoTemplate.currentTemplate.url : ""
            height: parent.height * 0.95
            width: sourceSize.width / sourceSize.height * height
            cache: true
            asynchronous: false
            antialiasing: true
        }
    }

    Item {
        id:takePhotoScreenCountdownBlock
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.top: takePhotoScreenPhotoBlock.bottom
        width: parent.width

        Countdown {
            id: countdown
            anchors.fill: parent

            onStartCount: { //debut de prise d'une photo
                photoPartRepeater.itemAt(p.currentPhoto).startPhotoProcess()
            }

            onEndCount: { //fin de prise d'une photo
                var d = new Date();
                var date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDay() + "_" + d.getHours() + "h" + d.getMinutes() + "m" + d.getSeconds() + "s"
                var imagePath = "d:\\phototwix-" + date + ".jpg" //TODO : modifier cet element. Doit etre un jpg
                camera.imageCapture.captureToLocation(imagePath)
            }
        }
    }


    Image {
        source: "../resources/images/back_button.png"
        anchors.right: parent.right
        anchors.top : parent.top
        height: 60
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent

            onPressed: {
                mainRectangle.state = "START"
            }
        }
    }

    ButtonImage {
        label: "TEST"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: {
            startGlobalPhotoProcess();
        }
    }
}
