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
import QtQuick.XmlListModel 2.0
import QtQml.Models 2.1

Component {
    id: albumDelegate
    Package {

        Item {
            Package.name: 'browser'
            GridView {
                id: photosGridView; model: visualModel.parts.grid; width: applicationWindows.width; height: applicationWindows.height - 21
                x: 0; y: 21; cellWidth: 160; cellHeight: 153; interactive: false
                onCurrentIndexChanged: photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
            }
        }

        Item {
            Package.name: 'fullscreen'
            ListView {
                id: photosListView; model: visualModel.parts.list; orientation: Qt.Horizontal
                width: applicationWindows.width; height: applicationWindows.height; interactive: false
                onCurrentIndexChanged: photosGridView.positionViewAtIndex(currentIndex, GridView.Contain)
                highlightRangeMode: ListView.StrictlyEnforceRange; snapMode: ListView.SnapOneItem
            }
        }

        Item {
            Package.name: 'album'
            id: albumWrapper;
            //width: height - 20;
            height: applicationWindows.height * 0.45

            DelegateModel {
                id: visualModel; delegate: PhotoDelegate { }
                model: modelData.photoList
            }

            PathView {
                id: photosPathView;
                model: visualModel.parts.stack;
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

            MouseArea {
                anchors.fill: parent
                onClicked: mainWindow.editMode ? photosModel.remove(index) : albumWrapper.state = 'inGrid'
            }

            states: [
            State {
                name: 'inGrid'
                PropertyChanges { target: photosGridView; interactive: true }
                PropertyChanges { target: albumsShade; opacity: 1 }
                PropertyChanges { target: backButton; onClicked: albumWrapper.state = ''; y: 6 }
            },
            State {
                name: 'fullscreen'; extend: 'inGrid'
                PropertyChanges { target: photosGridView; interactive: false }
                PropertyChanges { target: photosListView; interactive: true }
                PropertyChanges { target: photosShade; opacity: 1 }
                PropertyChanges { target: backButton; y: -backButton.height - 8 }
            }
            ]

            GridView.onAdd: NumberAnimation {
                target: albumWrapper; properties: "scale"; from: 0.0; to: 1.0; easing.type: Easing.OutQuad
            }
            GridView.onRemove: SequentialAnimation {
                PropertyAction { target: albumWrapper; property: "GridView.delayRemove"; value: true }
                NumberAnimation { target: albumWrapper; property: "scale"; from: 1.0; to: 0.0; easing.type: Easing.OutQuad }
                PropertyAction { target: albumWrapper; property: "GridView.delayRemove"; value: false }
            }

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
    }

}