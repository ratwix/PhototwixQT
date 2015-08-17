import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml.Models 2.2

Item {
    id:albumDelegate;

    state: 'stacked'
    /**
      * View Stack
      */
    Item {
        id: albumWrapper;
        //width: height - 20;
        height: albumDelegate.height * 0.45
        anchors.bottom: albumDelegate.bottom
        anchors.horizontalCenter: albumDelegate.horizontalCenter

        DelegateModel {
            id: visualModel
            delegate: PhotoDelegate2 {}
            model: parameters.photoGallery.photoList
        }

        PathView {
            id: photosPathView;
            model: visualModel.parts.stack
            pathItemCount: 5
            //visible: !busyIndicator.visible
            anchors.centerIn: parent;
            anchors.verticalCenterOffset: -30
            path: Path {
                PathAttribute { name: 'z'; value: 9999.0 }
                PathLine { x: 1; y: 1 }
                PathAttribute { name: 'z'; value: 0.0 }
            }
        }
    }



    /**
      * Grid display
      */

    Rectangle {
        id: albumsShade;
        color: applicationWindows.backColor
        anchors.fill: parent
        opacity: 0.0

    }

    GridView {
        id: photosGridView;
        model: visualModel.parts.grid;
        width: albumDelegate.width;
        height: albumDelegate.height - 21
        x: 0; y: 21;
        cellWidth: 400;
        cellHeight: 330;
        interactive: false
        visible: photosGridView.interactive
        onCurrentIndexChanged: photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
    }

    ButtonImage {
        id: backButton
        label: qsTr("Back")
        rotation: 3
        x: parent.width - backButton.width - 6
        y: -backButton.height - 8
    }

    /**
      * Fullscreen
      */

    Rectangle { id: photosShade;
        color: 'black';
        anchors.fill: parent
        opacity: 0;
        visible: opacity != 0.0
    }

    ListView {
        id: photosListView;
        model: visualModel.parts.list;
        orientation: Qt.Horizontal
        anchors.fill: albumDelegate
        interactive: false
        visible: photosListView.interactive
        onCurrentIndexChanged: photosGridView.positionViewAtIndex(currentIndex, GridView.Contain)
        highlightRangeMode: ListView.StrictlyEnforceRange;
        snapMode: ListView.SnapOneItem
    }

    /**
      * States and Transition Management
      */

    states: [
    State {
        name: 'inGrid'
        PropertyChanges { target: photosGridView
                          interactive: true
        }
        PropertyChanges { target: albumsShade; opacity: 1 }
        PropertyChanges { target: backButton; onClicked: albumDelegate.state = 'stacked'; y: 6 }
    },
    State {
        name: 'fullscreen'; extend: 'inGrid'
        PropertyChanges { target: photosGridView; interactive: false }
        PropertyChanges { target: photosListView; interactive: true }
        PropertyChanges { target: photosShade; opacity: 1 }
        PropertyChanges { target: backButton; y: -backButton.height - 8 }
    }
    ]

    transitions: [
    Transition {
        from: '*'; to: 'inGrid'
        SequentialAnimation {
            NumberAnimation { properties: 'opacity'; duration: 250 }
            PauseAnimation { duration: 350 }
            NumberAnimation { target: backButton; properties: "y"; duration: 200; easing.type: Easing.OutQuad }
        }
    },
    Transition {
        from: 'inGrid'; to: '*'
        NumberAnimation { properties: "y,opacity"; easing.type: Easing.OutQuad; duration: 300 }
    }
    ]
}


