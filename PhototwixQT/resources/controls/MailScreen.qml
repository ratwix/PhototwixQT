import QtQuick 2.0
import com.phototwix.components 1.0

Rectangle {
    id:mailScreen
    anchors.fill: parent

    property bool   show: false
    color:"#C0212126"

    state:"hide"
    opacity: 0.0
    visible: opacity != 0.0

    signal success()
    signal failed()

    property Photo    currentPhoto

    FontLoader {
        source: "../font/FontAwesome.otf"
    }


    MouseArea {
        anchors.fill: parent
    }


    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top : parent.top
        anchors.topMargin: 20
        height: parent.height * 0.3
        font.pixelSize: 200
        color:"white"
        font.family: "FontAwesome"
        text: "\uf0e0"
    }

    Text {
        id:textLabel
        width: 300
        //height: parent.height * 0.4
        anchors.top: parent.top
        anchors.topMargin: 250
        anchors.horizontalCenter: parent.horizontalCenter
        fontSizeMode :  Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
        text:"Mail :"
        minimumPixelSize: 30
        font.pixelSize: 80
    }

    TextInput {
        id:mailInput
        width: 400
        height: textLabel.height
        anchors.left: textLabel.right
        anchors.top: textLabel.top
        anchors.leftMargin: 30
        echoMode: TextInput.Normal
        color: "white"
        font.pixelSize: textLabel.font.pixelSize
    }



    onStateChanged: {
        if (state == "show") {
            mailInput.forceActiveFocus()
        }
    }

    InputPanel {
        id:keyboard
        state:"SHOW"
        onEsc: {
            mailScreen.state = "hide"
        }
        onEnter: {
            mail.sendMail(mailInput.text, currentPhoto.finalResultS)

            //mailScreen.state = "hide"
            //mailScreen.success()

        }
    }

    states: [
        State {
            name: "hide"
        },
        State {
            name: "show"
            PropertyChanges { target: mailScreen; opacity: 1.0}
        }

    ]

    transitions: [
        Transition {
            from: 'hide'; to: 'show'
            NumberAnimation {
                target: mailScreen; properties:'opacity'; duration: 400; easing.type: 'OutQuart'
            }
        }
    ]
}
