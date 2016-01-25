import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import com.phototwix.components 1.0

import "./windows"
import "./resources/controls"

ApplicationWindow {
    id: applicationWindows
    title: "Phototwix V5"
    visible: true
    visibility: Window.FullScreen

/*
    height: 900
    width: 1600
*/
    property string backColor: "#d5d6d8" //"#212126"
    property string backTemplateColor: "#193259"

    //Fond d'ecran
    Rectangle {
        color: backColor
        anchors.fill: parent
    }

    //property to comunicate between differentScreen
    property Template currentEditedTemplate
    property Photo    currentPhoto
    property var currentActiveTemplates : parameters.activesTemplates
    property int nbSecPhoto: 4
    property double cameraRation: 1.5
    property string effectSource : "Couleur"

    //Go to home and reset all
    property var resetStates: function () {
        mainRectangle.state = "START"
        takePhotoScreen.state = "PHOTO_SHOOT"
        startScreen.galleryControlAlias.state = "stacked"
        //shareScreen.state = "hide"
    }

    property var showEdit: function () {
        //resetStates();
        mainRectangle.state = "EDIT_PHOTO"
        takePhotoScreen.state = "PHOTO_EDIT"
    }

    Rectangle {
        id: mainRectangle
        anchors.fill: parent
        visible: false
        color:"transparent"

        state:"START"

        Image {
            id: backgroundImage
            anchors.fill: parent
            fillMode:Image.Stretch
            source: parameters.backgroundImage
        }

        StartScreen {
            id: startScreen
            x:0
            y:0
        }

        Image {
            id: startScreenHide
            anchors.fill: parent
            fillMode:Image.Stretch
            source: parameters.backgroundImage
            opacity: 0.0
            visible: opacity > 0
        }
/*
        Rectangle {
            id: startScreenHide
            anchors.fill: parent
            color:backColor
            opacity: 0.0
            visible: opacity > 0
        }
*/
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
            },
            State {
                name: "TAKE_PHOTO"
                PropertyChanges { target: startScreenHide;
                                   opacity: 1.0
                                }
                PropertyChanges { target: takePhotoScreen;
                                    x:0
                                    state:"PHOTO_SHOOT"
                                }
            },
            State {
                name: "EDIT_PHOTO"; extend: 'TAKE_PHOTO'
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
                  NumberAnimation { target: startScreenHide
                                      properties: "opacity"
                                      easing.type: Easing.Linear
                                      duration: 200 }
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
              from: "START"; to: "EDIT_PHOTO"
              ParallelAnimation {
                  NumberAnimation { target: startScreenHide
                                      properties: "opacity"
                                      easing.type: Easing.Linear
                                      duration: 200 }
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
