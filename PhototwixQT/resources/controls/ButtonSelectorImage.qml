import QtQuick 2.0

Item {
    id: container

    property string label: "toto"
    property color tint: "transparent"
    property string imageSourceUnselected: "qrc:/resources/images/cardboard.png"
    property string imageSourceSelected: "qrc:/resources/images/cardboardSelected.png"

    property bool selected: false

    signal clicked

    width: labelText.width + 70 ; height: labelText.height + 18

    BorderImage {
        anchors { fill: container; leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
        source: 'qrc:/resources/images/box-shadow.png'
        border.left: 10; border.top: 10; border.right: 10; border.bottom: 10
    }

    Image { id:currentImage; anchors.fill: parent; source: selected ? imageSourceSelected : imageSourceUnselected; antialiasing: true }

    Rectangle {
        anchors.fill: container; color: container.tint; visible: container.tint != ""
        opacity: 0.25
    }

    Text { id: labelText; font.pixelSize: 15; anchors.centerIn: parent; text: label + " " + selected}

    MouseArea {
        anchors { fill: parent; }
        onClicked: {
            selected = !selected;
            container.clicked()
        }
    }
}
