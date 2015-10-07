import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property variant itemSource

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Image {
        id:brannanProcessImg
        visible: false
        source: "../filtersResources/brannanProcess.png"
    }

    ShaderEffectSource {
        id: brannanProcess
        sourceItem: brannanProcessImg
    }


    Image {
        id:brannanBlowoutImg
        visible: false
        source: "../filtersResources/brannanBlowout.png"
    }

    ShaderEffectSource {
        id: brannanBlowout
        sourceItem: brannanBlowoutImg
    }

    Image {
        id:brannanContrastimg
        visible: false
        source: "../filtersResources/brannanContrast.png"
    }

    ShaderEffectSource {
        id: brannanContrast
        sourceItem: brannanContrastimg
    }

    Image {
        id:brannanLumaImg
        visible: false
        source: "../filtersResources/brannanLuma.png"
    }

    ShaderEffectSource {
        id: brannanLuma
        sourceItem: brannanLumaImg
    }

    Image {
        id:brannanScreenImg
        visible: false
        source: "../filtersResources/brannanScreen.png"
    }

    ShaderEffectSource {
        id: brannanScreen
        sourceItem: brannanScreenImg
    }

    ShaderEffect {
        id:brannaFilter
        anchors.fill: parent

        property variant inputImageTexture: itemSource
        property variant inputImageTexture2: brannanProcess
        property variant inputImageTexture3: brannanBlowout
        property variant inputImageTexture4: brannanContrast
        property variant inputImageTexture5: brannanLuma
        property variant inputImageTexture6: brannanScreen

        fragmentShader: "
             varying highp vec2 qt_TexCoord0;

             uniform sampler2D inputImageTexture;
             uniform sampler2D inputImageTexture2;  //process
             uniform sampler2D inputImageTexture3;  //blowout
             uniform sampler2D inputImageTexture4;  //contrast
             uniform sampler2D inputImageTexture5;  //luma
             uniform sampler2D inputImageTexture6;  //screen

             mat3 saturateMatrix = mat3(
                                        1.105150,
                                        -0.044850,
                                        -0.046000,
                                        -0.088050,
                                        1.061950,
                                        -0.089200,
                                        -0.017100,
                                        -0.017100,
                                        1.132900);

             vec3 luma = vec3(.3, .59, .11);

             void main()
             {

                 vec3 texel = texture2D(inputImageTexture, qt_TexCoord0).rgb;

                 vec2 lookup;
                 lookup.y = 0.5;
                 lookup.x = texel.r;
                 texel.r = texture2D(inputImageTexture2, lookup).r;
                 lookup.x = texel.g;
                 texel.g = texture2D(inputImageTexture2, lookup).g;
                 lookup.x = texel.b;
                 texel.b = texture2D(inputImageTexture2, lookup).b;

                 texel = saturateMatrix * texel;


                 vec2 tc = (2.0 * qt_TexCoord0) - 1.0;
                 float d = dot(tc, tc);
                 vec3 sampled;
                 lookup.y = 0.5;
                 lookup.x = texel.r;
                 sampled.r = texture2D(inputImageTexture3, lookup).r;
                 lookup.x = texel.g;
                 sampled.g = texture2D(inputImageTexture3, lookup).g;
                 lookup.x = texel.b;
                 sampled.b = texture2D(inputImageTexture3, lookup).b;
                 float value = smoothstep(0.0, 1.0, d);
                 texel = mix(sampled, texel, value);

                 lookup.x = texel.r;
                 texel.r = texture2D(inputImageTexture4, lookup).r;
                 lookup.x = texel.g;
                 texel.g = texture2D(inputImageTexture4, lookup).g;
                 lookup.x = texel.b;
                 texel.b = texture2D(inputImageTexture4, lookup).b;


                 lookup.x = dot(texel, luma);
                 texel = mix(texture2D(inputImageTexture5, lookup).rgb, texel, .5);

                 lookup.x = texel.r;
                 texel.r = texture2D(inputImageTexture6, lookup).r;
                 lookup.x = texel.g;
                 texel.g = texture2D(inputImageTexture6, lookup).g;
                 lookup.x = texel.b;
                 texel.b = texture2D(inputImageTexture6, lookup).b;

                 gl_FragColor = vec4(texel, 1.0);
             }"
    }
}
