import QtQuick 2.0

Item {
    id: container

    property alias label: labelText.text
    property color tint: "transparent"
    property string imageSource: "qrc:/resources/images/cardboard.png"
    signal clicked

    width: labelText.width + 70 ; height: labelText.height + 18

    BorderImage {
        anchors { fill: container; leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
        source: 'qrc:/resources/images/box-shadow.png'
        border.left: 10; border.top: 10; border.right: 10; border.bottom: 10
    }

    Image { anchors.fill: parent; source: imageSource; antialiasing: true }

    Rectangle {
        anchors.fill: container; color: container.tint; visible: container.tint != ""
        opacity: 0.25
    }

    Text { id: labelText; font.pixelSize: 15; anchors.centerIn: parent }

    MouseArea {
        anchors { fill: parent;  }
        onClicked: container.clicked()
    }
}
