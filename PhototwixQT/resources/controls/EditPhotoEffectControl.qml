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
        ListElement { name: "Couleur"; image: "../images/effets/normal.png"}
        ListElement { name: "Sepia"; image: "../images/effets/sepia2.png"}
        ListElement { name: "Edge"; image: "../images/effets/edge.png"}
        ListElement { name: "Inkwell"; image: "../images/effets/inkwell.png"}
        ListElement { name: "1977"; image: "../images/effets/1977.png"}
        ListElement { name: "Amaro"; image: "../images/effets/amaro.png"}
        ListElement { name: "Branna"; image: "../images/effets/branna.png"}
        ListElement { name: "Early Bird"; image: "../images/effets/earlybird.png"}
        ListElement { name: "Hefe"; image: "../images/effets/hefe.png"}
        ListElement { name: "Hudson"; image: "../images/effets/hudson.png"}
        ListElement { name: "Lomo"; image: "../images/effets/lomo.png"}
        ListElement { name: "Lord Kelvin"; image: "../images/effets/lordkelvin.png"}
        ListElement { name: "Nashville"; image: "../images/effets/nashville.png"}
        ListElement { name: "Pixel"; image: "../images/effets/pixel.png"}
        ListElement { name: "Rise"; image: "../images/effets/rise.png"}
        ListElement { name: "Sierra"; image: "../images/effets/sierra.png"}
        ListElement { name: "Sutro"; image: "../images/effets/sutro.png"}
        ListElement { name: "Toaster"; image: "../images/effets/toaster.png"}
        ListElement { name: "Valancia"; image: "../images/effets/valancia.png"}
        ListElement { name: "Walden"; image: "../images/effets/walden.png"}
        ListElement { name: "XPro"; image: "../images/effets/xpro.png"}
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
        applicationWindows.effectSource = effectName;
        /*
        switch(effectName) {
            case "Couleur":
                applicationWindows.effectSource = "color"; break;
            case "Noir et blanc":
                applicationWindows.effectSource = "grayscale"; break;
            case "Sepia":
                applicationWindows.effectSource = "sepia"; break;
            case "Edge":
                applicationWindows.effectSource = "edge"; break;
            case "Amaro":
                applicationWindows.effectSource = "Amaro"; break;
            default:
                break;
        }
        */
    }
}

