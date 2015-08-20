import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtMultimedia 5.4
import QtQuick 2.4
import QtGraphicalEffects 1.0


Flipable {
    id: photoShootRenderer

    property bool flipped: false
    property int  photoIndex: 0
    property bool photoTaked: false
    property double destRotation
    property string effectSource : applicationWindows.effectSource

    signal processEnd()

    function startPhotoProcess() {
        flipped = true;
        photoTaked = true;
        destRotation = -rotation;
        resetFilters();
    }

    function endPhotoProcess(photoResult) {
        photoPreview.source = photoResult;
    }

    function resetFilters() {
        filter_black_white.visible = false;
        filter_sepia.visible = false;
        filter_xpro2.visible = false;
        filter_willow.visible = false;
    }

    front: Rectangle {
        anchors.fill: parent
        id: photoResult
        color:"red" //TODO, a remplacer avec une image

        Image {
            id: photoPreview
            anchors.fill: parent
            mirror: parameters.flipresult //TODO: a mettre dans les options
            smooth: true
            onStatusChanged: {
                if (photoPreview.status == Image.Ready) {
                    photoTaked = true; //photo is taked, wait to switch finish
                    flipped = false;
                    currentLabel.visible = false;

                }
            }
        }

        EffectGrayscale {
            id:filter_black_white
            visible: false
            itemSource: photoPreview
            anchors.fill: parent
        }

        EffectSepia {
            id:filter_sepia
            visible: false
            itemSource: photoPreview
            anchors.fill: parent
        }

        EffectXPRO2 {
            id:filter_xpro2
            visible: false
            itemSource: photoPreview
            anchors.fill: parent
        }

        EffectWillow {
            id:filter_willow
            visible: false
            itemSource: photoPreview
            anchors.fill: parent
        }

        Text {
            id:currentLabel
            anchors.centerIn: parent
            font.pixelSize: parent.height * 0.6
            text: photoIndex
        }
    }

    onEffectSourceChanged: { //effectManagement
        resetFilters();
        if (effectSource == "color") {

        }

        if (effectSource == "grayscale") {
            filter_black_white.visible = true;
        }

        if (effectSource == "sepia") {
            filter_sepia.visible = true;
        }

        if (effectSource == "xpro2") {
            filter_xpro2.visible = true;
        }

        if (effectSource == "willow") {
            filter_willow.visible = true;
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
            live:true
            transform: Rotation { origin.x: videoPreview.width / 2; axis { x: 0; y: 1; z: 0 } angle: parameters.flipcamera ? 180 : 0 }
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
