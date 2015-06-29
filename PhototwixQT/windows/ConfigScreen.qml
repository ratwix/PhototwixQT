import QtQuick 2.4
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 1.3

import "../resources/controls"

Rectangle {
    id: configScreen
    color: "green"
    anchors.fill : parent


    //Liste des templates
    ListView {
        anchors.fill:parent

        //Dans quel répertoire il faut chercher
        FolderListModel {
            id: folderModel
            nameFilters: ["*.png", "*.jpg"]
            folder: "file:///" + applicationDirPath + "/templates/"
        }

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

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: fileURL
                        sourceSize.height: 150
                        cache: false
                        asynchronous: true
                        antialiasing: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr(fileName)
                    }
                }


                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing : 10
                    Switch {
                        checked: false
                        onCheckedChanged: {checked ?
                                               parameters.activeTemplate(fileName) :
                                               parameters.unactiveTemplate(fileName)
                        }
                    }
                    ButtonImage {
                        label: "Config"
                        onClicked: { }
                    }
                }

            }

        }

        model: folderModel
        delegate: fileDelegate
    }


}
