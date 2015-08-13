import QtQuick 2.0

Rectangle {
    id:photoWrapper
    width: 400
    height: 400
    color:"transparent"

    property double randomAngle: Math.random() * 30 - 14
    rotation: photoWrapper.randomAngle


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
/*
    Image { //Image in high resolution
        id: hqImage; antialiasing: true; source: ""; visible: false; cache: false
        fillMode: Image.PreserveAspectFit; width: photoWrapper.width; height: photoWrapper.height
    }
    */
}

