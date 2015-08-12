import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import com.phototwix.components 1.0

import "./windows"

ApplicationWindow {
    id: applicationWindows
    title: "Phototwix V5"
    visible: true
    //visibility: Window.FullScreen

    height: 900
    width: 1600

    property string backColor: "#212126"

    //Fond d'ecran
    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    //property to comunicate between differentScreen
    property Template currentEditedTemplate
    property Photo    currentPhoto
    property var currentActiveTemplates : parameters.activesTemplates
    property int nbSecPhoto: 4
    property double cameraRation: 1.5
    property string effectSource : "color"


    Rectangle {
        id: mainRectangle
        anchors.fill: parent
        visible: false
        color:"transparent"

        state:"START"

        StartScreen {
            id: startScreen
            x:applicationWindows.width
            y:0
        }

        TakePhotoScreen {
            id: takePhotoScreen
            x:applicationWindows.width
            y:0
        }

        ConfigScreen {
            id: configScreen
            x:applicationWindows.width
            y:0
        }

        ConfigTemplateScreen {
            id: configTemplateScreen
            x:applicationWindows.width
            y:0
        }


        states: [
            State {
                name: "START"
                PropertyChanges { target: startScreen; x:0}
            },
            State {
                name: "TAKE_PHOTO"
                PropertyChanges { target: takePhotoScreen;
                                    x:0
                                    state:"PHOTO_SHOOT"
                                }
            },
            State {
                name: "CONFIG"
                PropertyChanges { target: configScreen; x:0}
            },
            State {
                name: "CONFIG_TEMPLATE"
                PropertyChanges { target: configTemplateScreen; x:0}
            }
        ]

        transitions: [
          Transition {
              from: "START"; to: "TAKE_PHOTO"
              ParallelAnimation {
                  PropertyAnimation { target: startScreen
                                      properties: "x"
                                      easing.type: Easing.Linear
                                      duration: 500 }
                  PropertyAnimation { target: takePhotoScreen
                                      properties: "x"
                                      easing.type: Easing.OutBounce
                                      duration: 2000 }
              }

              onRunningChanged: {
                  if (mainRectangle.state == "TAKE_PHOTO" && (!running)) {
                      takePhotoScreen.startGlobalPhotoProcess();
                  }
              }
          },
          Transition {
                from: "TAKE_PHOTO"; to: "START"
                ParallelAnimation {
                    PropertyAnimation { target: takePhotoScreen
                                        properties: "x"
                                        easing.type: Easing.Linear
                                        duration: 500 }
                    PropertyAnimation { target: startScreen
                                        properties: "x"
                                        easing.type: Easing.OutCirc
                                        duration: 1000 }
                }
            }
        ]

        onStateChanged: {
            if (state == "TAKE_PHOTO") {
                takePhotoScreen.init()
            }
        }
    }


    property var splashWindow : Splash {
        onTimeout: {
            mainRectangle.visible = true
        }
    }
}
