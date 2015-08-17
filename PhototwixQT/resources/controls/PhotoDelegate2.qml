import QtQuick 2.4


Package {
    Item { id: stackItem; Package.name: 'stack'; width: 400; height: 400; z: stackItem.PathView.z }
    Item { id: gridItem; Package.name: 'grid'; width: 300; height: 300 }
    Item { id: listItem; Package.name: 'list'; width: startScreen.width; height: startScreen.height }

    Item {
        id:photoWrapper
        parent: stackItem
        width: parent.height
        height: parent.width

        property double randomAngle: Math.random() * 50 - 24
        property double randomAngle2: Math.random() * 20 - 9
        rotation: photoWrapper.randomAngle

        BorderImage {
            anchors {
                fill: originalImage.status == Image.Ready ? border : placeHolder
                leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8
            }
            source: '../images/box-shadow.png'
            border.left: 10; border.top: 10; border.right: 10; border.bottom: 10
        }

        Rectangle {
            id: placeHolder

            function calculateScale(width, height, cellSize) {
                var widthScale = (cellSize * 1.0) / width
                var heightScale = (cellSize * 1.0) / height
                var scale = 0

                if (widthScale <= heightScale) {
                    scale = widthScale;
                } else if (heightScale < widthScale) {
                    scale = heightScale;
                }
                return scale;
            }

            property int w: originalImage.sourceSize.width
            property int h: originalImage.sourceSize.height
            property double s: calculateScale(w, h, photoWrapper.width)

            color: 'white'; anchors.centerIn: parent; antialiasing: true
            width:  w * s; height: h * s; visible: originalImage.status != Image.Ready
            Rectangle {
                color: "#878787"; antialiasing: true
                anchors { fill: parent; topMargin: 5; bottomMargin: 5; leftMargin: 5; rightMargin: 5 }
            }
        }

        Rectangle {
            id: border; color: 'white'; anchors.centerIn: parent; antialiasing: true
            width: originalImage.paintedWidth + 10; height: originalImage.paintedHeight + 10
            visible: !placeHolder.visible
        }

        Image { //Image in low resolution
            id: originalImage; antialiasing: true;
            source: (modelData != null) && (modelData.finalResultSD != "") ? "file:///" + modelData.finalResultSD : ""; cache: false
            fillMode: Image.PreserveAspectFit; width: photoWrapper.width; height: photoWrapper.height
        }

        Image { //Image in high resolution
            id: hqImage; antialiasing: true; source: ""; visible: false; cache: false
            fillMode: Image.PreserveAspectFit; width: photoWrapper.width; height: photoWrapper.height
        }

        MouseArea {
            width: originalImage.paintedWidth; height: originalImage.paintedHeight; anchors.centerIn: originalImage
            onClicked: {
                gridItem.GridView.view.currentIndex = index;
                if (albumDelegate.state == 'stacked') {
                    albumDelegate.state = 'inGrid'
                } else if (albumDelegate.state == 'inGrid'){
                    albumDelegate.state = 'fullscreen'
                } else if (albumDelegate.state == 'fullscreen'){
                    albumDelegate.state = 'inGrid'
                }
            }
        }

        states: [
        State {
            name: 'stacked'; when: albumDelegate.state == 'stacked'
            ParentChange { target: photoWrapper; parent: stackItem; x: 10; y: 10 }
            PropertyChanges { target: photoWrapper; opacity: stackItem.PathView.onPath ? 1.0 : 0.0 }
        },
        State {
            name: 'inGrid'; when: albumDelegate.state == 'inGrid'
            ParentChange { target: photoWrapper;
                            parent: gridItem;
                            x: 10; y: 10;
                            rotation: photoWrapper.randomAngle2
            }
        },
        State {
            name: 'fullscreen'; when: albumDelegate.state == 'fullscreen'
            ParentChange {
                target: photoWrapper;
                parent: listItem;
                x: 0; y: 0; rotation: 0
                width: startScreen.width; height: startScreen.height
            }
            PropertyChanges { target: border; opacity: 0 }
            PropertyChanges {
                target: hqImage;
                source: listItem.ListView.isCurrentItem ? "file:///" + modelData.finalResult : "";
                visible: true
            }
        }
        ]

        transitions: [
        Transition {
            from: 'stacked'; to: 'inGrid'
            SequentialAnimation {
                PauseAnimation { duration: index >= 0 ? 30 * index : 0 }
                ParentAnimation {
                    target: photoWrapper;
                    NumberAnimation {
                        target: photoWrapper; properties: 'x,y,rotation,opacity,height,width'; duration: 600; easing.type: 'OutQuart'
                    }
                }
            }
        },
        Transition {
            from: 'inGrid'; to: 'stacked'
            ParentAnimation {
                target: photoWrapper;
                NumberAnimation { properties: 'x,y,rotation,opacity,height,width'; duration: 600; easing.type: 'OutQuart' }
            }
        },
        Transition {
            from: 'inGrid'; to: 'fullscreen'
            SequentialAnimation {
                PauseAnimation { duration: gridItem.GridView.isCurrentItem ? 0 : 600 }
                ParentAnimation {
                    target: photoWrapper;
                    NumberAnimation {
                        targets: [ photoWrapper, border ]
                        properties: 'x,y,width,height,opacity,rotation'
                        duration: gridItem.GridView.isCurrentItem ? 600 : 1; easing.type: 'OutQuart'
                    }
                }
            }
        },
        Transition {
            from: 'fullscreen'; to: 'inGrid'
            ParentAnimation {
                target: photoWrapper;
                NumberAnimation {
                    targets: [ photoWrapper, border ]
                    properties: 'x,y,width,height,rotation,opacity'
                    duration: gridItem.GridView.isCurrentItem ? 600 : 1; easing.type: 'OutQuart'
                }
            }
        }
        ]
    }
}
