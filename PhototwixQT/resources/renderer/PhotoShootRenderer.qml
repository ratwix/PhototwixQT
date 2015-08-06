import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtMultimedia 5.4
import QtQuick 2.4

Flipable {
    id: photoShootRenderer

    property bool flipped: false
    property int  photoIndex: 0
    property bool photoTaked: false
    property double destRotation

    signal processEnd()

    function startPhotoProcess() {
        flipped = true;
        photoTaked = true;
        destRotation = -rotation;
    }

    function endPhotoProcess(photoResult) {
        console.log(photoResult);
        photoPreview.source = photoResult;
    }

    front: Rectangle {
        anchors.fill: parent
        id: photoResult
        color:"red" //TODO, a remplacer avec une image

        Image {
            id: photoPreview
            anchors.fill: parent
            visible: false
            mirror: true
            onStatusChanged: {
                if (photoPreview.status == Image.Ready) {
                    photoPreview.visible = true
                    photoTaked = true; //photo is taked, wait to switch finish
                    flipped = false;
                    currentLabel.visible = false;

                }
            }
        }

        Text {
            id:currentLabel
            anchors.centerIn: parent
            font.pixelSize: parent.height * 0.6
            text: photoIndex
        }
    }


    back: Rectangle {
        anchors.fill: parent
        id:videoPreviewArea
        color:"orange"


        ShaderEffectSource { //Duplication de la camera
            id:videoPreview
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height
            width: parent.width
            sourceItem: cameraVideoOutput
        }

    }

    transform: Rotation {
        id: rotationTransformer
        origin.x: photoShootRenderer.width/2
        origin.y: photoShootRenderer.height/2
        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
        angle: 0    // the default angle
    }

    states: State {
        name: "back"
        PropertyChanges { target: rotationTransformer; angle: 180 }
        PropertyChanges { target: photoShootRenderer; rotation: destRotation}
        when: photoShootRenderer.flipped
    }

    transitions: Transition {
        ParallelAnimation {
            NumberAnimation { target: rotationTransformer; property: "angle"; duration: 400 }
            NumberAnimation { target: photoShootRenderer; property: "rotation"; duration: 400 }
            SequentialAnimation {
                NumberAnimation { target: photoShootRenderer; property: "scale"; to: 0.8; duration: 200 }
                NumberAnimation { target: photoShootRenderer; property: "scale"; to: 1.0; duration: 200 }
            }
        }
        onRunningChanged: {
            if ((flipped == false) && !running && photoTaked) {
                photoShootRenderer.processEnd() //tell that process is end
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: photoProcess.flipped = !photoProcess.flipped
    }
}
