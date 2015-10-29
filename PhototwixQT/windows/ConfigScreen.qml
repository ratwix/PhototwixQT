import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtMultimedia 5.4

import "../resources/controls"



Rectangle {
    id: configScreen
    color: applicationWindows.backColor
    height: parent.height
    width: parent.width

    property bool admin: false


    signal currentEditedTemplateChange(url currentUrl)

    MouseArea {
        anchors.fill: parent
    }

    //Actions
    Column {
        id: col1
        anchors.left: parent.left
        width: parent.width * 0.4
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 40
        spacing: 15

        Grid {
           columns: 2
           columnSpacing: 10
           rowSpacing: 10

           Label {
               height: 30
               text: "Nombre d'impressions"
               font.pixelSize: 15
           }

           Rectangle {
               height: 30
               width: 150
               color:"transparent"
               Text {
                   anchors.left: parent.left
                   id:tnbprint
                   height: 30
                   font.pixelSize: 30 * 0.9
                   text: parameters.nbprint
               }

               Button {
                   anchors.left: tnbprint.right
                   anchors.leftMargin: 20
                   height: 30
                   text: "Remise à 0"
                   visible: admin
                   onClicked: {
                       parameters.nbprint = 0;
                   }
               }
           }

           Label {
               height: 30
               text: "Papier Restant"
               font.pixelSize: 15
           }

           Rectangle {
               height: 30
               width: 150
               color:"transparent"
               Text {
                   anchors.left: parent.left
                   id:tpaperprint
                   height: 30
                   font.pixelSize: 30 * 0.9
                   text: parameters.paperprint
               }

               Button {
                   anchors.left: tpaperprint.right
                   anchors.leftMargin: 20
                   height: 30
                   text: "Remise à jour"
                   onClicked: {
                       parameters.updatePaperPrint();
                   }
               }
           }

           Label {
               height: 30
               text: "Prix supplémentaire"
               font.pixelSize: 15
           }

           Text {
               height: 30
               font.pixelSize: 30 * 0.9
               text: parameters.nbprint - parameters.nbfreephotos > 0 ? ((parameters.nbprint - parameters.nbfreephotos) * parameters.pricephoto).toFixed(2).toString() + "€" : "0€";
           }


           Label {
               height: 30
               text: "Photos gratuites"
               font.pixelSize: 15
           }
           //FreePhotoNumberPicker

           FreePhotoPicker {
               id:freePhotoNumber
               height: 30
               width: 150
               step:10
               admin: configScreen.admin
           }

           Label {
               height: 30
               text: "Prix par photo supplementaires"
               font.pixelSize: 15
           }

           PricePhotoPicker {
               id:pricePhoto
               height: 30
               width: 150
               step:0.05
               admin: configScreen.admin
           }

           Label {
               height: 30
               text: "Bloquer impression"
               font.pixelSize: 15
           }

           MaxPhotoPicker {
               id:maxPhotoNumber
               block:false
               height: 30
               width: 300
               step:10
               admin:configScreen.admin
           }

           Label {
               height: 30
               text: "Flip Camera"
               font.pixelSize: 15
           }

           Switch {
               onCheckedChanged: {
                   parameters.flipcamera = checked;
               }
               Component.onCompleted: {
                   checked = parameters.flipcamera;
               }
           }

           Label {
               height: 30
               text: "Flip Camera Result"
               font.pixelSize: 15
           }

           Switch {
               onCheckedChanged: {
                   parameters.flipresult = checked;
               }
               Component.onCompleted: {
                   checked = parameters.flipresult;
               }
           }

           Label {
               height: 30
               text: "Volume"
               font.pixelSize: 15
           }

           Slider {
               id:volumeSlider
               minimumValue: 0.0
               maximumValue: 1.0
               stepSize: 0.1
               tickmarksEnabled: true
               updateValueWhileDragging: false
               onValueChanged: {
                   parameters.volume = value;
               }

               Component.onCompleted: {
                   value = parameters.volume;
               }
           }

           Label {
               height: 30
               text: "Test Flash"
               font.pixelSize: 15
           }

           Switch {
               checked: false;
               onCheckedChanged: {
                   if (checked) {
                       parameters.arduino.flashSwitchOn();
                   } else {
                       parameters.arduino.flashSwitchOff();
                   }
                }
           }

           Label {
               height: 30
               text: "Flash"
               font.pixelSize: 15
           }

           Slider {
               id:flashSlider
               minimumValue: 0
               maximumValue: 255
               stepSize: 10
               tickmarksEnabled: true
               updateValueWhileDragging: false
               onValueChanged: {
                   parameters.flashBrightness = value;
               }

               Component.onCompleted: {
                   value = parameters.flashBrightness;
               }
           }

           Label {
               height: 30
               text: "Camera Res"
               font.pixelSize: 15
               visible: admin
           }

           ListView {
               id:resolutionList
               visible: admin
               width:300
               height: 200
               highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
               snapMode:ListView.SnapOneItem
               highlightRangeMode :ListView.ApplyRange
               model: takePhotoScreen.resolution
               delegate: Item {
                   height: 20
                   width:300
                   Text {
                       height: 20
                       width:300
                       color:"black"
                       text:   modelData.width + "x" + modelData.height + " (" + Math.round((modelData.width / modelData.height) * 100) / 100 + ")"
                       MouseArea {
                           anchors.fill: parent
                           onClicked: {
                               /*
                               takePhotoScreen.camera.viewfinder.resolution = Qt.size(modelData.width, modelData.height);
                               takePhotoScreen.cameraVideoOutput.height = modelData.height
                               takePhotoScreen.cameraVideoOutput.width = modelData.width
                               */

                               resolutionList.currentIndex = index;
                               parameters.cameraHeight = modelData.height
                               parameters.cameraWidth = modelData.width
                               takePhotoScreen.camera.start()
                           }
                       }
                   }

                   Component.onCompleted: {
                       if ((modelData.height == parameters.cameraHeight) && (modelData.width == parameters.cameraWidth)) {
                           resolutionList.currentIndex = index;
                       }
                   }
               }
           }
        }

        Row {
            anchors.left: parent.left
            spacing: 10

            Label {
                height: 30
                text: "Gallerie:"
                font.pixelSize: 15
            }

            ButtonImage {
                label:"Nettoyer"
                visible: admin
                onClicked: {
                    console.debug("Reset photos");
                    cbox.message = "Vider la gallerie ?"
                    cbox.acceptFunction = function () {
                        parameters.clearGallery();
                        mbox.message = "La gallerie a été effacée"
                        mbox.state = "show"
                    }
                    cbox.state = "show"
                }
            }

            ButtonImage {
                label:"Nettoyer et effacer"
                visible: admin
                onClicked: {
                    console.debug("Reset photos & delete");
                    cbox.message = "Vider la gallerie et supprimer les photos ?"
                    cbox.acceptFunction = function () {
                        parameters.clearGalleryDeleteImages();
                        mbox.message = "La gallerie et les photos ont étés effacés"
                        mbox.state = "show"
                    }
                    cbox.state = "show"
                }
            }
        }



        Row {
            anchors.left: parent.left
            spacing: 10

            ButtonImage {
                label:"Sauvegarder"
                onClicked: {
                    console.debug("Save Gallery");
                    saveGallerie.open()
                }
            }

            CheckBox {
                id: copySingle
                text: "Sans visuel"
                checked: true
            }

            CheckBox {
                id: copyDeleted
                text: "Supprime"
                checked: true
            }

            CheckBox {
                id: copyDeletedSingle
                text: "Supprime sans visuel"
                checked: true
            }

            /*
                function getReadableFileSizeString(fileSizeInBytes) {

                    var i = -1;
                    var byteUnits = [' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
                    do {
                        fileSizeInBytes = fileSizeInBytes / 1024;
                        i++;
                    } while (fileSizeInBytes > 1024);

                    return Math.max(fileSizeInBytes, 0.1).toFixed(1) + byteUnits[i];
                };
            */
        }

        Row {
            anchors.left: parent.left
            spacing: 10

            Label {
                height: 30
                text: "Sharing"
                font.pixelSize: 15
            }

            Switch {
                onCheckedChanged: {
                    parameters.sharing = checked;
                }
                Component.onCompleted: {
                    checked = parameters.sharing;
                }
            }

            TextField {
                id:eventCodeText
                visible: admin
                placeholderText: qsTr("Code evenement")
                Component.onCompleted: {
                    text = parameters.eventCode;
                }
            }

            ButtonImage {
                label:"Change le code evenement"
                onClicked: {
                    parameters.eventCode = eventCodeText.text
                }
            }

            TextField {
                id:baseUrlText
                visible: admin
                placeholderText: qsTr("Server base url")
                Component.onCompleted: {
                    text = parameters.sharingBaseUrl;
                }
            }

            ButtonImage {
                label:"Change Base URL"
                visible: admin
                onClicked: {
                    parameters.sharingBaseUrl = baseUrlText.text
                }
            }
        }

        Row {
            anchors.left: parent.left
            spacing: 10

            ButtonImage {
                //anchors.left: parent.left
                label:"Quitter"
                onClicked: {
                    Qt.quit()
                }
            }

            ButtonImage {
                //anchors.left: parent.left
                label:"Eteindre"
                onClicked: {
                    parameters.haltSystem()
                    Qt.quit()
                }
            }
        }

        FileDialog {
            id: importTemplateFileDialog
            title: "Import de template"
            folder: shortcuts.home
            visible:false
            selectMultiple: true
            selectExisting: true
            nameFilters: [ "Images (*.jpg *.png)" ]
            onAccepted: {
                console.debug("Add templates: " + importTemplateFileDialog.fileUrls);
                for (var i = 0; i < importTemplateFileDialog.fileUrls.length; i++) {
                    parameters.addTemplateFromUrl(importTemplateFileDialog.fileUrls[i]);
                }
            }
        }

        FileDialog {
            id: importBackgroundFileDialog
            title: "Import Fond d'écran"
            folder: shortcuts.home
            visible:false
            selectMultiple: false
            selectExisting: true
            nameFilters: [ "Images (*.jpg *.png)" ]
            onAccepted: {
                parameters.changeBackground(importBackgroundFileDialog.fileUrl);
            }
        }

        FileDialog {
            id: saveGallerie
            title: "Sauvegarde"
            folder: shortcuts.home
            visible:false
            selectMultiple: false
            selectFolder: true
            selectExisting: true
            onAccepted: {
                parameters.photoGallery.saveGallery(saveGallerie.fileUrl, copySingle.checked, copyDeleted.checked, copyDeletedSingle.checked);
            }
        }
    }


    //Liste des templates
    ListView {
        anchors.top: parent.top
        anchors.right: parent.right
        height: parent.height
        width: parent.width * 0.4

        //Dans quel répertoire il faut chercher

        //Représentation des template, avec un bouton et un switch
        Component {
            id: fileDelegate

            Row {
                spacing : 30
                anchors.leftMargin: 20
                Column {
                    width: 250
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    BusyIndicator {
                        anchors.horizontalCenter: parent.horizontalCenter
                        running: templateImage.status === Image.Loading
                    }

                    Image {
                        id:templateImage
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: model.modelData.url
                        sourceSize.height: 200
                        cache: false
                        asynchronous: true
                        antialiasing: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr(model.modelData.name)
                    }
                }


                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing : 10

                    Grid {
                        columns: 2
                        columnSpacing: 10
                        Label {
                            height: 30
                            text: "Active"
                            font.pixelSize: 15
                        }

                        Switch {
                            id:templateActiveSwitch
                            onCheckedChanged: {
                                model.modelData.active = checked
                            }
                            Component.onCompleted: {
                                checked = model.modelData.active
                            }
                        }

                        Label {
                            height: 30
                            text: "Cutter print"
                            font.pixelSize: 15
                        }

                        Switch {
                            id:templateCutterSwitch
                            onCheckedChanged: {
                                model.modelData.printcutter = checked
                            }
                            Component.onCompleted: {
                                checked = model.modelData.printcutter
                            }
                        }

                        Label {
                            height: 30
                            text: "Double print"
                            font.pixelSize: 15
                        }

                        Switch {
                            id:templateDoubleSwitch
                            onCheckedChanged: {
                                model.modelData.doubleprint = checked
                            }
                            Component.onCompleted: {
                                checked = model.modelData.doubleprint
                            }
                        }

                        Label {
                            height: 30
                            text: "Landscape"
                            font.pixelSize: 15
                        }

                        Switch {
                            id:landscapeSwitch
                            onCheckedChanged: {
                                model.modelData.landscape = checked
                            }
                            Component.onCompleted: {
                                checked = model.modelData.landscape
                            }
                        }
                    }



                    ButtonImage {
                        label: "Config"
                        onClicked: {
                            applicationWindows.currentEditedTemplate = model.modelData
                            mainRectangle.state = "CONFIG_TEMPLATE"
                        }
                    }
                }

            }

        }

        model: parameters.templates
        delegate: fileDelegate
    }

    Rectangle {
        id:homeButton
        anchors.right: parent.right
        anchors.top : parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 10
        height: 60
        width: 60
        color:"#212126"
        radius:height / 7

        Image {
            id: logo
            antialiasing: true
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.6
            fillMode: Image.PreserveAspectFit
            source:"../resources/images/home.png"
        }

        MouseArea {
            anchors { fill: parent;  }
            onClicked: { mainRectangle.state = "START" }
        }
    }

    MessageScreen {
        id:mbox
    }

    ConfirmScreen {
        id:cbox
    }
}
