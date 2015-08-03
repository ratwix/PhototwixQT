import QtQuick 2.4
import QtQuick.Controls 1.4

import "../resources/controls"



Rectangle {
    id: configScreen
    color: "green"
    height: parent.height
    width: parent.width


    signal currentEditedTemplateChange(url currentUrl) //TODO: changer avec un objet C++ template

    //Liste des templates
    ListView {
        anchors.fill:parent

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
                        sourceSize.height: 150
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

    Image {
        source: "../resources/images/back_button.png"
        anchors.right: parent.right
        anchors.top : parent.top
        height: 60
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent

            onPressed: {
                mainRectangle.state = "START"
            }
        }
    }
}
