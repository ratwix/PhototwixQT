import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property variant itemSource
    property real    value:1.0


    BrightnessContrast {
        id:block1
        anchors.fill: parent
        source: itemSource
        brightness: 0.6
        contrast: 0.3
        //visible: false
    }

    ShaderEffectSource {
        id:block2
        anchors.fill: parent
        sourceItem: block1
    }

    EffectSepiaShader {
        id: block3
        anchors.fill: parent
        source: block2
        amount: 0.3
        //visible: false
    }

    HueSaturation {
        anchors.fill: parent
        source: block3
        hue: -0.055
        saturation: 0.75
        lightness: 0.0
    }

}
