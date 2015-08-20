import QtQuick 2.4
import QtQuick.Controls 1.4

import "../resources/controls"



Rectangle {
    id: configScreen
    color: applicationWindows.backColor
    height: parent.height
    width: parent.width


    signal currentEditedTemplateChange(url currentUrl) //TODO: changer avec un objet C++ template

    //Actions
    Column {
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
                   onClicked: {
                       parameters.nbprint = 0;
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
        }

        ButtonImage {
            anchors.left: parent.left
            label:"Nettoyer la Gallerie"
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
            anchors.left: parent.left
            label:"Nettoyer et effacer la gallerie"
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
                    Switch {
                        id:templateActiveSwitch
                        checked: model.modelData.active
                        onCheckedChanged: {
                            model.modelData.active = checked
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
