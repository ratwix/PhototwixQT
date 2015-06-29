import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import "./windows"

ApplicationWindow {
    id: applicationWindows
    title: "Phototwix V5"
    visible: true
//    visibility: Window.FullScreen

    height: 600
    width: 800

    //Fond d'ecran
    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }


    TabView {
        id: mainTabView
        visible: false
        anchors.fill: parent
        //tabsVisible: false
        frameVisible: false

        Tab {
            title: "Start Screen"
            StartScreen {
                id: startScreen
            }

        }
        Tab {
            title: "Take Photo Screen"
            TakePhotoScreen {
                id: takePhotoScreen
            }
        }
        Tab {
            title: "Config Screen"
            ConfigScreen {
                id: configScreen
            }
        }
    }

    property var splashWindow : Splash {
        onTimeout: {
            mainTabView.visible = true
        }
    }
}
