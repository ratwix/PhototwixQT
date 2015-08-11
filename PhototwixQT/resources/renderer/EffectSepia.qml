import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property variant itemSource
    property real    value:1.0

    EffectSepiaShader {
        anchors.fill: parent
        source: itemSource
        amount: 1.0
    }
}
