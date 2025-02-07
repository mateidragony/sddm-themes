import QtQuick 2.15

Item {
    id : text_button

    property alias label      : text_button_label.text
    property alias size       : text_button_label.font.pointSize
    property alias fontFamily : text_button_label.font.family

    property color labelColor       : "#ffffff"
    property color hoverLabelColor  : "#d3d3d3"
    property color pressLabelColor  : "#bdbdbd"


    signal pressed()
    signal released()
    signal clicked()

    height : 40
    width: 100

    Text {
      id  : text_button_label

      text    : ""
      color   : labelColor
    }

    states: [
        State {
            name  : "hover"

            PropertyChanges {
                target  : text_button_label
                color   : hoverLabelColor
            }
        },
        State {
            name  : "pressed"

            PropertyChanges {
                target  : text_button_label
                color   : pressLabelColor
            }
        }
    ]

    MouseArea {
        anchors.fill    : text_button

        hoverEnabled    : true
        cursorShape     : Qt.PointingHandCursor
        acceptedButtons : Qt.LeftButton

        onEntered : {
            text_button.state = "hover"
        }

        onExited  : {
            text_button.state = ""
        }

        onPressed  : {
            text_button.state = "pressed"
        }

        onClicked  : {
            text_button.clicked()
        }

        onReleased  : {
            if (containsMouse) {
                text_button.state = "hover"
            } else {
                text_button.state = ""
            }
        }
    }
}