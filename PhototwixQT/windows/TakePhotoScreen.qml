import QtQuick 2.0
import QtQuick.Window 2.1
import QtMultimedia 5.4
import "../resources/controls"

Rectangle {
    id: takePhotoScreen
    color: "blue"
    height: parent.height
    width: parent.width

    function init() {
        countdown.init()
    }

    function startPhotoProcess() {
        countdown.start()
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageCaptured: {
                //TODO jouer le son
            }
            onImageSaved: {
                //photo1.endPhotoProcess("file:///" + camera.imageCapture.capturedImagePath)
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

                console.log("Current " + cres.width + ":" + cres.height + " ration:" + applicationWindows.cameraRation);
            }
        }
    }

    Item {
        id:takePhotoScreenPhotoBlock
        anchors.top : parent.top
        anchors.topMargin: 10
        height: parent.height * 0.90
        width: parent.width

        Image { //Back template
            id: photoScreenTemplate
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: applicationWindows.currentPhotoTemplate ? applicationWindows.currentPhotoTemplate.currentTemplate.url : ""
            sourceSize.height: parent.height * 0.95
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
            onEndCount: {
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
            countdown.start()
        }
    }




}
