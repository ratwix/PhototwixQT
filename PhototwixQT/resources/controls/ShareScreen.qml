import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtWebEngine 1.1

import "createWebview.js" as MyScriptWV

Rectangle {
    id:shareScreen
    anchors.fill: parent
    state:"hide"
    opacity: 0.0
    visible: opacity != 0.0

    property string photoUrl: ""

    onPhotoUrlChanged: {
        var baseURL = parameters.sharingBaseUrl

        //TODO : envoie en cour
        var event_code = parameters.eventCode
        var filenamePath = photoUrl
        var filename = base64.getFileNameFromPath(filenamePath);
        var filebase64 = base64.fileToBase64(filenamePath);
        var filename_escape = encodeURIComponent(filename);
        var event_escape = encodeURIComponent(event);
        var event_code_escape = encodeURIComponent(event_code);

        var params = "event_code=" + event_code_escape + "&filename=" + filename_escape + "&filebase64=" + filebase64;

        var http = new XMLHttpRequest()
        var url = baseURL + "uploadPhoto.php"

        http.open("POST", url, true);

        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                if (http.readyState == 4) {
                    if (http.status == 200) {
                        console.debug(http.responseText)
                        var url = baseURL + "showPhoto.php?filename=" + filename_escape + "&event_code=" + event_code_escape;
                        MyScriptWV.createprofileViewObjects();
                        webview.profile = MyScriptWV.profileObject.profile;
                        webview.url = url;
                        webview.visible = true;
                    } else {
                        console.log("error envoie photo: " + http.status)
                        //TODO : Message : fin envoie en cour
                    }
                }
            }

        http.send(params);
    }

    FontLoader {
        source: "../font/FontAwesome.otf"
    }

    MouseArea {
        anchors.fill: parent
    }

    WebEngineView { //WebEngineView
        id: webview

        settings.localContentCanAccessRemoteUrls: true
        settings.hyperlinkAuditingEnabled: true
        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.height - keyboard.height;
        width: parent.width

        onProfileChanged: {
            console.log("Nouveau profil:" + webview.profile.storageName)
        }

        onJavaScriptConsoleMessage: {
            console.log("JAVASCRIPT:" + message)
        }
    }

    InputPanel {
        id:keyboard
        state:"SHOW"
        onEsc: {
            shareScreen.state = "hide"
        }

        onEnter: {
            if (passInput.text == password) {
                escapeScreen.state = "hide"
                passInput.text = ""
                escapeScreen.success()
            } else {
                if (passInput.text == passwordAdmin) {
                    escapeScreen.state = "hide"
                    passInput.text = ""
                    escapeScreen.successAdmin()
                } else {
                    passInput.text = ""
                    escapeScreen.failed()
                }
            }
        }
    }


    states: [
        State {
            name: "hide"
        },
        State {
            name: "show"
            PropertyChanges { target: shareScreen; opacity: 1.0}
        }
    ]

    transitions: [
        Transition {
            from: 'hide'; to: 'show'
            NumberAnimation {
                target: shareScreen; properties:'opacity'; duration: 400; easing.type: 'OutQuart'
            }
        }
    ]
}

