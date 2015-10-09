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
        ListElement { name: "Couleur"; }
        ListElement { name: "Sepia"; }
        ListElement { name: "Edge";}
        ListElement { name: "Inkwell"}
        ListElement { name: "1977"}
        ListElement { name: "Amaro"}
        ListElement { name: "Branna"}
        ListElement { name: "Early Bird"}
        ListElement { name: "Hefe"}
        ListElement { name: "Hudson"}
        ListElement { name: "Lomo"}
        ListElement { name: "Lord Kelvin"}
        ListElement { name: "Nashville"}
        ListElement { name: "Pixel"}
        ListElement { name: "Rise"}
        ListElement { name: "Sierra"}
        ListElement { name: "Sutro"}
        ListElement { name: "Toaster"}
        ListElement { name: "Valancia"}
        ListElement { name: "Walden"}
        ListElement { name: "XPro"}
    }

    DelegateModel {
        id:effectButtonDeleate
        model:effectButtonModel
        delegate: EditPhotoEffectButton {
            height: 100
            width: parent.width
            effectName: name
            /*
            MouseArea {
                anchors.fill: parent
                onClicked: applyEffect(name)
            }
            */
        }
    }

    ListView {
        width: parent.width
        anchors.top: title.bottom
        anchors.bottom: parent.bottom
        model:effectButtonDeleate
    }

    /*
    function applyEffect(effectName) {
        applicationWindows.effectSource = effectName;
    }
    */
}

