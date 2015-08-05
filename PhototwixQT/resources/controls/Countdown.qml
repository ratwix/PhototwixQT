import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtMultimedia 5.0

Rectangle {
    id:countdownElement
    height: parent.height
    color: "transparent"

    function init() {
        light1.state = "OFF"
        light2.state = "OFF"
        light3.state = "OFF"
    }

    function start() {
        timer.start()
    }

    signal startCount()
    signal endCount()

    QtObject {
        id: countdownElementPrivate
        property int previusStatus: 0
    }

    SoundEffect {
        id: beep1Sound
        source: "../sounds/beep-07.wav"
    }

    SoundEffect {
        id: beep2Sound
        source: "../sounds/beep-08b.wav"
    }
    SoundEffect {
        id: photoSound
        source: "../sounds/camera-shutter-click-01.wav"
    }

    function updateStatus(nb) {
        if (nb < 1) {
            light1.state = "OFF"
            light2.state = "OFF"
            light3.state = "OFF"
        }

        if (nb == 1) {
            if (countdownElementPrivate.previusStatus < 1) {
                countdownElementPrivate.previusStatus = 1
                beep1Sound.play()
            }

            light1.state = "RED"
            light2.state = "OFF"
            light3.state = "OFF"
        }

        if (nb == 2) {
            if (countdownElementPrivate.previusStatus < 2) {
                countdownElementPrivate.previusStatus = 2
                beep1Sound.play()
            }
            light1.state = "RED"
            light2.state = "RED"
            light3.state = "OFF"
        }

        if (nb == 3) {
            if (countdownElementPrivate.previusStatus < 3) {
                countdownElementPrivate.previusStatus = 3
                beep2Sound.play()
            }
            light1.state = "RED"
            light2.state = "RED"
            light3.state = "RED"
        }

        if (nb > 3) {
            if (countdownElementPrivate.previusStatus < 4) {
                countdownElementPrivate.previusStatus = 4
                photoSound.play()
            }
            light1.state = "GREEN"
            light2.state = "GREEN"
            light3.state = "GREEN"
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: parent.height
        spacing: 15

        CountdownLight {
            height: parent.height
            width: height
            id: light1
        }
        CountdownLight {
            height: parent.height
            width: height
            id: light2
        }
        CountdownLight {
            height: parent.height
            width: height
            id: light3
        }
    }

    Timer { //TODO : integrer le timer a Countdown et emettre des signaux onStart et onFinish
        id:timer
        interval: 50; running: false; repeat: true; triggeredOnStart: true

        property variant initialTime

        onRunningChanged: {
            if (running == true) {
                countdownElementPrivate.previusStatus = 0;
                initialTime = Date.now()
                countdownElement.startCount()
            }
        }

        onTriggered: {
            var nbSec = Math.round(((Date.now() - initialTime) / 1000))

            countdown.updateStatus(nbSec)


            if (nbSec == 4) {
                timer.stop()
                countdownElement.endCount()
            }
        }
    }
}

