import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property variant itemSource
    property real    value:1.0


    Desaturate {
        id:block1
        anchors.fill: parent
        source: itemSource
        desaturation: 0.98
    }

    BrightnessContrast {
        id:block2
        anchors.fill: parent
        source: block1
        brightness: 0.2
        contrast: -0.15
    }

    ShaderEffectSource {
        id:block3
        anchors.fill: parent
        sourceItem: block2
    }

    EffectSepiaShader {
        id: block4
        anchors.fill: parent
        source: block3
        amount: 0.05
        //visible: false
    }
}
