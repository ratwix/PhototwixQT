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


    state: "FULL"

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
               text: "Delais photos"
               font.pixelSize: 15
           }

           Slider {
               id:countdownSlider
               minimumValue: 1000
               maximumValue: 4000
               stepSize: 500
               tickmarksEnabled: true
               updateValueWhileDragging: false
               onValueChanged: {
                   parameters.countdownDelay = value;
               }

               Component.onCompleted: {
                   value = parameters.countdownDelay;
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

           Row {
               spacing: 10

               TextField {
                   id:editCameraHeight

                   Component.onCompleted: {
                       text = parameters.cameraHeight;
                   }
               }

               Label {
                   text:"x"
               }

               TextField {
                   id:editCameraWidth

                   Component.onCompleted: {
                       text = parameters.cameraWidth;
                   }
               }

               Label {
                   text:" (ratio:" + Math.round((parameters.cameraWidth / parameters.cameraHeight) * 100) / 100 + ")"
               }

               ButtonImage {
                   label:"Save Res"
                   onClicked: {
                       parameters.cameraWidth = parseInt(editCameraWidth.text)
                       parameters.cameraHeight = parseInt(editCameraHeight.text)
                   }
               }

               ButtonImage {
                   label:"Focus"
                   onClicked: {
                       timerPhotoPreview.start()
                       configScreen.state = "FOCUS"
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
                    cbox.message = "Vider la gallerie et supprimer les photos et mails ?"
                    cbox.acceptFunction = function () {
                        mail.resetMail();
                        parameters.clearGalleryDeleteImages();
                        mbox.message = "La gallerie les photos et mes mailsont étés effacés"
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
                label:"Mail"
                onClicked: {
                    configScreen.state = "MAIL"
                }
            }

            ButtonImage {
                label:"Sauvegarder Mails"
                visible: admin
                onClicked: {
                    saveMail.open()
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

        /* Active if sharing via website : deprecated
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
        */


        Row {
            anchors.left: parent.left
            spacing: 10

            ButtonImage {
                label:"Importer des visuels"
                onClicked: {
                    importTemplateFileDialog.open()
                }
            }

            ButtonImage {
                id:buttonBackground
                label:"Fond d'écran"
                onClicked: {
                    importBackgroundFileDialog.open()
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
            modality: Qt.NonModal
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
            modality: Qt.NonModal
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
            modality: Qt.NonModal
            onAccepted: {
                parameters.photoGallery.saveGallery(saveGallerie.fileUrl, copySingle.checked, copyDeleted.checked, copyDeletedSingle.checked);
            }
        }

        FileDialog {
            id: saveMail
            title: "Sauvegarde mails"
            folder: shortcuts.home
            visible:false
            selectMultiple: false
            selectFolder: true
            selectExisting: true
            modality: Qt.NonModal
            onAccepted: {
                mail.saveMail(saveMail.fileUrl);
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

    Rectangle {
        id:mailRectangle
        anchors.fill: parent
        color: "#D0AAAAAA"
        visible: false

        MouseArea {
            anchors { fill: parent;  }
            onClicked: {}
        }

        Column {
            id: mailCol
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top + 10
            width: parent.width / 2
            spacing: 5
                Row {
                    anchors.left: parent.left
                    spacing: 10

                    Label {
                        id:mailLabel
                        height: 30
                        text: "Mail :"
                        font.pixelSize: 15
                    }

                    Switch {
                        id:mailActive

                        Component.onCompleted: {
                            checked = parameters.mailActive;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10
                    visible: admin

                    Label {
                        id:fromMailLabel
                        height: 30
                        text: "Mail From :"
                        font.pixelSize: 15
                    }

                    TextField {
                        id:mailFrom

                        width: 300
                        placeholderText: qsTr("From")
                        Component.onCompleted: {
                            text = parameters.mailFrom;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10

                    Label {
                        id:ccMailLabel
                        height: 30
                        text: "Mail Cc :"
                        font.pixelSize: 15
                    }

                    TextField {
                        id:mailCc
                        width: 300
                        placeholderText: qsTr("Cc")
                        Component.onCompleted: {
                            text = parameters.mailCc;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10

                    Label {
                        id:bccMailLabel
                        height: 30
                        text: "Mail Bcc :"
                        font.pixelSize: 15
                    }

                    TextField {
                        id:mailBcc
                        width: 300
                        placeholderText: qsTr("Bcc")
                        Component.onCompleted: {
                            text = parameters.mailBcc;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10
                    visible: admin

                    Label {
                        height: 30
                        text: "SMTP :"
                        font.pixelSize: 15
                    }

                    TextField {
                        id:mailSmtp
                        visible: admin
                        width: 300
                        placeholderText: qsTr("Smtp")
                        Component.onCompleted: {
                            text = parameters.mailSmtp;
                        }
                    }

                    TextField {
                        id:mailPort
                        visible: admin
                        width: 50
                        placeholderText: qsTr("Port")
                        Component.onCompleted: {
                            text = parameters.mailPort;
                        }
                    }

                    TextField {
                        id:mailUsername
                        visible: admin
                        width: 150
                        placeholderText: qsTr("User")
                        Component.onCompleted: {
                            text = parameters.mailUsername;
                        }
                    }

                    TextField {
                        id:mailPassword
                        visible: admin
                        width: 150
                        placeholderText: qsTr("Password")
                        Component.onCompleted: {
                            text = parameters.mailPassword;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10

                    Label {
                        id:mailSubjectLabel
                        height: 30
                        text: "Sujet :"
                        font.pixelSize: 15
                    }

                    TextField {
                        id:mailSubject
                        width: 300
                        placeholderText: qsTr("Subject")
                        Component.onCompleted: {
                            text = parameters.mailSubject;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10

                    Label {
                        id:mailContentLabel
                        height: 30
                        text: "Contenu :"
                        font.pixelSize: 15
                    }

                    TextArea {
                        id:mailContent
                        width: 300
                        height: 200
                        Component.onCompleted: {
                            text = parameters.mailContent;
                        }
                    }
                }

                Row {
                    anchors.left: parent.left
                    spacing: 10

                    ButtonImage {
                        label:"Sauvegarder"

                        onClicked: {
                            parameters.mailFrom = mailFrom.text
                            parameters.mailCc = mailCc.text
                            parameters.mailBcc = mailBcc.text
                            parameters.mailSmtp = mailSmtp.text
                            parameters.mailPort = mailPort.text
                            parameters.mailUsername = mailUsername.text
                            parameters.mailPassword = mailPassword.text
                            parameters.mailSubject = mailSubject.text
                            parameters.mailContent = mailContent.text
                            parameters.mailActive = mailActive.checked
                            parameters.Serialize();
                            configScreen.state = "FULL"
                        }
                    }

                    ButtonImage {
                        label:"Annuler"
                        onClicked: {
                            mailFrom.text = parameters.mailFrom
                            mailCc.text = parameters.mailCc
                            mailBcc.text = parameters.mailBcc
                            mailSmtp.text = parameters.mailSmtp
                            mailPort.text = parameters.mailPort
                            mailUsername.text = parameters.mailUsername
                            mailPassword.text = parameters.mailPassword
                            mailSubject.text = parameters.mailSubject
                            mailContent.text = parameters.mailContent
                            mailActive.checked = parameters.mailActive
                            configScreen.state = "FULL"
                        }
                    }
                }
            }

        InputPanel {
            id:keyboard
            state:"SHOW"

            onEsc: {
                configScreen.state = "FULL"
            }

            onEnter: {

            }
        }

    }

    Rectangle {
        id: focusRectangle

        anchors.fill: parent
        color: "#D0AAAAAA"
        visible: false

        MouseArea {
            anchors { fill: parent;  }
            onClicked: {}
        }


        Image {
            id: cameraFocusOutput
            source:"image://camerapreview/1"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.6
            fillMode: Image.PreserveAspectFit
        }

        Timer {
            id: timerPhotoPreview
            interval: 100;
            running: false;
            repeat: true
            onTriggered: {
                cameraWorker.capturePreview();
                cameraFocusOutput.source = "image://camerapreview/" + Math.random();
                // change URL to refresh image. Add random URL part to avoid caching
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top : parent.top
            anchors.rightMargin: 10
            anchors.topMargin: 10
            height: 60
            width: 60
            color:"#212126"
            radius:height / 7

            Image {
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
                onClicked: {
                    timerPhotoPreview.stop()
                    cameraWorker.closeCamera();
                    configScreen.state = "FULL"
                }
            }
        }

    }

    MessageScreen {
        id:mbox
    }

    ConfirmScreen {
        id:cbox
    }


    states: [
        State {
            name: "FULL"
        },

        State {
            name: "MAIL"
            PropertyChanges { target: keyboard; state:"SHOW"}
            PropertyChanges { target: mailRectangle; visible:true}
        },

        State {
            name: "FOCUS"
            PropertyChanges { target: focusRectangle; visible:true}
        }
    ]


}
