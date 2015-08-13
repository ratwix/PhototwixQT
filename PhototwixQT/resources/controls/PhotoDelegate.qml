/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the QtQml module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0


Package {
    Item { id: stackItem; Package.name: 'stack'; width: applicationWindows.height * 0.45; height: applicationWindows.height * 0.40; z: stackItem.PathView.z}
    Item { id: listItem; Package.name: 'list'; width: applicationWindows.width + 40; height: 153 }
    Item { id: gridItem; Package.name: 'grid'; width: 320; height: 306 }

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

    Item {
        width: applicationWindows.height * 0.45; height: applicationWindows.height * 0.4

        Item {
            id: photoWrapper

            property double randomAngle: Math.random() * 30 - 14
            property double randomAngle2: Math.random() * 30 - 14

            x: 0; y: 0;
            width: applicationWindows.height * 0.40
            height: applicationWindows.height * 0.35
            z: stackItem.PathView.z;
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
                    if (albumWrapper.state == 'inGrid') {
                        gridItem.GridView.view.currentIndex = index;
                        albumWrapper.state = 'fullscreen'
                    } else {
                        gridItem.GridView.view.currentIndex = index;
                        albumWrapper.state = 'inGrid'
                    }
                }
            }

            states: [
            State {
                name: 'stacked'; when: albumWrapper.state == ''
                ParentChange { target: photoWrapper; parent: stackItem; x: 10; y: 10 }
                PropertyChanges { target: photoWrapper; opacity: stackItem.PathView.onPath ? 1.0 : 0.0 }
            },
            State {
                name: 'inGrid'; when: albumWrapper.state == 'inGrid'
                ParentChange { target: photoWrapper; parent: gridItem; x: 10; y: 10; rotation: photoWrapper.randomAngle2 }
            },
            State {
                name: 'fullscreen'; when: albumWrapper.state == 'fullscreen'
                ParentChange {
                    target: photoWrapper; parent: listItem; x: 0; y: 0; rotation: 0
                    width: mainWindow.width; height: mainWindow.height
                }
                PropertyChanges { target: border; opacity: 0 }
                PropertyChanges { target: hqImage; source: listItem.ListView.isCurrentItem ? "file:///" + modelData.finalResult : ""; visible: true }
            }
            ]

            transitions: [
            Transition {
                from: 'stacked'; to: 'inGrid'
                SequentialAnimation {
                    PauseAnimation { duration: 10 * index }
                    ParentAnimation {
                        target: photoWrapper; via: foreground
                        NumberAnimation {
                            target: photoWrapper; properties: 'x,y,rotation,opacity'; duration: 600; easing.type: 'OutQuart'
                        }
                    }
                }
            },
            Transition {
                from: 'inGrid'; to: 'stacked'
                ParentAnimation {
                    target: photoWrapper; via: foreground
                    NumberAnimation { properties: 'x,y,rotation,opacity'; duration: 600; easing.type: 'OutQuart' }
                }
            },
            Transition {
                from: 'inGrid'; to: 'fullscreen'
                SequentialAnimation {
                    PauseAnimation { duration: gridItem.GridView.isCurrentItem ? 0 : 600 }
                    ParentAnimation {
                        target: photoWrapper; via: foreground
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
                    target: photoWrapper; via: foreground
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
}
