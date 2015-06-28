import QtQuick 2.4
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 1.3

import "../resources/controls"

Rectangle {
    id: configScreen
    color: "green"
    anchors.fill : parent



    ListView {
        anchors.fill:parent

        FolderListModel {
            id: folderModel
            nameFilters: ["*.png", "*.jpg"]
            folder: "file:///" + applicationDirPath + "/templates/"
        }

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
                    Switch { checked: false }
                    ButtonImage {
                        label: "Config"
                    }
                }

            }

        }

        model: folderModel
        delegate: fileDelegate
    }


}
