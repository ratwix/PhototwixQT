import QtQuick 2.0
import QtQml.Models 2.2
import QtQuick.Window 2.1

Rectangle {
    color:"white"

    Rectangle {
        id:title
        color:"white"
        width: parent.width
        height: 30
        Text {
            id: effectLabel
            text: qsTr("Effets")
            anchors.leftMargin: 20
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height * 0.5
        }
    }

    ListModel {
        id:effectButtonModel
        ListElement { name: "Couleur"; image: "../images/effets/couleur.png"}
        ListElement { name: "Noir et blanc"; image: "../images/effets/black_white.png"}
        ListElement { name: "Sepia"; image: "../images/effets/sepia.png"}
        ListElement { name: "X-Pro"; image: "../images/effets/warm.png"}
        ListElement { name: "Willow"; image: "../images/effets/cold.png"}
    }

    DelegateModel {
        id:effectButtonDeleate
        model:effectButtonModel
        delegate: EditPhotoEffectButton {
            height: 100
            width: parent.width
            effectName: name
            effectImage: image
            MouseArea {
                anchors.fill: parent
                onClicked: applyEffect(name)
            }
        }
    }

    ListView {
        width: parent.width
        anchors.top: title.bottom
        anchors.bottom: parent.bottom
        model:effectButtonDeleate
    }

    function applyEffect(effectName) {
        switch(effectName) {
            case "Couleur":
                couleur();
                break;
            case "Noir et blanc":
                grayscale();
                break;
            case "Sepia":
                sepia();
                break;
            case "X-Pro":
                xpro();
                break;
            case "Willow":
                willow();
                break;
            default:
                break;
        }
    }

    function sepia() {
        console.log("sepia")
        applicationWindows.effectSource = "sepia"
    }

    function grayscale() {
        console.log("grayscale")
        //applicationWindows.effectSource = "EffectBlackAndWhite.qml"
        applicationWindows.effectSource = "grayscale"
    }

    function xpro() {
        console.log("xpro")
        applicationWindows.effectSource = "xpro2"
    }

    function willow() {
        console.log("willow")
        applicationWindows.effectSource = "willow"
    }

    function couleur() {
        console.log("couleur")
        applicationWindows.effectSource = "color"
    }
}

