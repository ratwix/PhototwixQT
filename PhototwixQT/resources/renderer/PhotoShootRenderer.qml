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
    property double xphoto : 0.0
    property string effectSource : applicationWindows.effectSource

    signal processEnd()

    function startPhotoProcess() {
        flipped = true;
        photoTaked = true;
        destRotation = -rotation;
        resetFilters();
    }

    function endPhotoProcess(photoResult) {
        photoPreview.source = "file:///" + photoResult;
    }

    function resetFilters() {
        filter_black_white.visible = false;
        filter_sepia.visible = false;
        filter_edge.visible = false;
        filter_1977.visible = false;
        filter_amaro.visible = false;
        filter_branna.visible = false;
        filter_earlyBird.visible = false;
        filter_hefe.visible = false;
        filter_hudson.visible = false;
        filter_inkwell.visible = false;
        filter_lomo.visible = false;
        filter_lordKelvin.visible = false;
        filter_nashville.visible = false;
        filter_pixel.visible = false;
        filter_rise.visible = false;
        filter_sierra.visible = false;
        filter_sutro.visible = false;
        filter_toaster.visible = false;
        filter_valancia.visible = false;
        filter_walden.visible = false;
        filter_xpro.visible = false;
    }

    front: Rectangle {
        anchors.fill: parent
        id: photoResult
        color:"red" //TODO, a remplacer avec une image

        Image {
            id: photoPreview
            source:(modelData.path != "") ? "file:///" + modelData.path : ""
            anchors.fill: parent
            mirror: parameters.flipresult
            smooth: true
            onStatusChanged: {
                if ((source != "") && (photoPreview.status == Image.Ready)) {
                    photoTaked = true; //photo is taked, wait to switch finish
                    flipped = false;
                    currentLabel.visible = false;

                }
            }
        }

        ShaderEffectSource { //Duplication de la camera
            id:photoPreviewShader
            anchors.fill: parent
            sourceItem: photoPreview
            hideSource: true
            sourceRect:Qt.rect(photoPreview.width * xphoto,
                               0,
                               photoPreview.width - photoPreview.width * xphoto * 2,
                               photoPreview.height);
        }

        EffectGrayscale {
            id:filter_black_white
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectSepia {
            id:filter_sepia
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectEdge {
            id:filter_edge
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        Effect1977 {
            id:filter_1977
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectAmaro {
            id:filter_amaro
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectBranna {
            id:filter_branna
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectEarlyBird {
            id:filter_earlyBird
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectHefe {
            id:filter_hefe
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectHudson {
            id:filter_hudson
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectInkwell {
            id:filter_inkwell
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectLomo {
            id:filter_lomo
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectLordKelvin {
            id:filter_lordKelvin
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectNashville {
            id:filter_nashville
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectPixel {
            id:filter_pixel
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectRise {
            id:filter_rise
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectSierra {
            id:filter_sierra
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }


        EffectSutro {
            id:filter_sutro
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectToaster {
            id:filter_toaster
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectValancia {
            id:filter_valancia
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectWalden {
            id:filter_walden
            visible: false
            itemSource: photoPreviewShader
            anchors.fill: parent
        }

        EffectXpro {
            id:filter_xpro
            visible: false
            itemSource: photoPreviewShader
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
        console.debug("Effect source : " + effectSource);
        if (effectSource == "Couleur") {

        }

        if (effectSource == "Noir et blanc") {
            filter_black_white.visible = true;
        }

        if (effectSource == "Sepia") {
            filter_sepia.visible = true;
        }

        if (effectSource == "Edge") {
            filter_edge.visible = true;
        }

        if (effectSource == "Amaro") {
            filter_amaro.visible = true;
        }

        if (effectSource == "1977") {
            filter_1977.visible = true;
        }

        if (effectSource == "Branna") {
            filter_branna.visible = true;
        }

        if (effectSource == "Early Bird") {
            filter_earlyBird.visible = true;
        }

        if (effectSource == "Hefe") {
            filter_hefe.visible = true;
        }

        if (effectSource == "Hudson") {
            filter_hudson.visible = true;
        }

        if (effectSource == "Inkwell") {
            filter_inkwell.visible = true;
        }

        if (effectSource == "Lomo") {
            filter_lomo.visible = true;
        }

        if (effectSource == "Lord Kelvin") {
            filter_lordKelvin.visible = true;
        }

        if (effectSource == "Nashville") {
            filter_nashville.visible = true;
        }

        if (effectSource == "Pixel") {
            filter_pixel.visible = true;
        }

        if (effectSource == "Rise") {
            filter_rise.visible = true;
        }

        if (effectSource == "Sierra") {
            filter_sierra.visible = true;
        }

        if (effectSource == "Sutro") {
            filter_sutro.visible = true;
        }

        if (effectSource == "Toaster") {
            filter_toaster.visible = true;
        }

        if (effectSource == "Valancia") {
            filter_valancia.visible = true;
        }

        if (effectSource == "Walden") {
            filter_walden.visible = true;
        }

        if (effectSource == "XPro") {
            filter_xpro.visible = true;
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
            sourceRect:Qt.rect(cameraVideoOutput.width * xphoto,
                               0,
                               cameraVideoOutput.width - cameraVideoOutput.width * xphoto * 2,
                               cameraVideoOutput.height);
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
}
