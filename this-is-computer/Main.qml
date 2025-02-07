import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

import "./Components"

Rectangle {
    id : container
    LayoutMirroring.enabled : Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit : true
    color : doscolor
    anchors.fill : parent

    property int sessionIndex : session.index

    //SET DEFAULTS
    property int defaultscale : setdefaultScale()

    property int targetscreenwidth : container.width
    property int targetscreenheight : container.height

    property int defaultscreenwidth : 1920 * defaultscale
    property int defaultscreenheight : 1200 * defaultscale

    property int defaultcharwidth : 8 * defaultscale
    property int defaultcharheight : 8 * defaultscale

    property string doscolor  : "#ffffff"
    property string dosblack  : "#000000"
    property string linkColor: "#71d1e9" 
    property string hoverLinkColor: "#77f1be" 
    property string pressLinkColor: "#48ff00"


    //Background Settings
    property string borderimage : "./Background.png"


    //FONT SECTION (1 px = .75 pt)
    property string fontstyle : "TerminusTTF-4.49.3.ttf"
    property int dosfontsize : 20 * defaultscale
    property int welcomefontsize : 40 * defaultscale
    property int welcomefontsize2 : 20 * defaultscale

    // strings
    property string loginbuttontext : "LOGIN"
    property string restartbuttontext : "RESTART"
    property string shutdownbuttontext : "SHUTDOWN"

    //Wecome Text
    property int welcometoppadding : 50 * defaultscale
    property int welcomeleftpadding : 50 * defaultscale

    // text inputs
    property int textinputpadding : 15 * defaultscale
    property int textinputwidth : 400 * defaultscale
    property int textinputheight : 50 * defaultscale

    //Username
    property int usernametoppadding : 250 * defaultscale
    property int usernameleftpadding : 150 * defaultscale

    //Password
    property int passwordtoppadding : 325 * defaultscale
    property int passwordleftpadding : 150 * defaultscale

    //COMBOBOX
    property string comboboxcolor : dosblack
    property string comboboxbordercolor : dosblack
    property string comboboxhovercolor : dosblack
    property string comboboxfocuscolor : dosblack
    property string comboboxtextcolor : doscolor
    property string comboboxmenucolor : dosblack
    property string comboboxarrowcolor : "transparent"
    property string comboboximage : "./Arrow.svg"


    //Set Scale
    function setdefaultScale() {
        var setscale = 1

        //Set UHD
        if (container.width > 1920)
        {
            setscale = 2
        }

        return setscale
    }


    FontLoader {
        id : loginfont
        source : fontstyle
    }

    Connections {
        target : sddm
        function onLoginSucceeded() {
            errorMessage.color = "green"
            errorMessage.text = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
            errorMessage.bold = true
        }
    }

    Background {
        anchors.fill: parent
        source: borderimage
        fillMode: Image.Stretch
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    // everything
    Column {
        leftPadding: 150
        topPadding: 100
        spacing: 50

        //Welcome Message
        Column {
            id : entryColumn1
            spacing: 15

            Text {
                    color : doscolor
                    text : "You are using a computer."
                    font.family : loginfont.name
                    font.pointSize : welcomefontsize
            }


            Row {

                leftPadding: 5

                Text {
                    color : doscolor
                    text : "Was this not your intended goal?"
                    font.family : loginfont.name
                    font.pointSize : welcomefontsize2

                    rightPadding: textinputpadding
                }

                TextButton {
                    label: "Leave."
                    size: welcomefontsize2
                    fontFamily : loginfont.name

                    labelColor: linkColor
                    hoverLabelColor: hoverLinkColor
                    pressLabelColor: pressLinkColor

                    onClicked : sddm.powerOff()
                }
            }
        }

        // Username and Password and session
        Column {
            leftPadding: 5
            //Username
            Row {
                height : textinputheight
                z: 100

                Text {
                    height : textinputheight

                    verticalAlignment: Text.AlignVCenter

                    color : doscolor
                    text : "Username:"
                    font.family : loginfont.name
                    font.pointSize : dosfontsize
                }

                TextInput {
                    id : username

                    focus: userModel.lastUser == "" ? true : false

                    text: userModel.lastUser

                    leftPadding : textinputpadding

                    verticalAlignment: Text.AlignVCenter

                    width : textinputwidth
                    height : textinputheight

                    color : doscolor

                    font.family : loginfont.name
                    font.pointSize : dosfontsize

                    KeyNavigation.backtab : username
                    KeyNavigation.tab : loginButton
                    Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            password.focus = true
                            event.accepted = true
                        }
                    }

                    HoverHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        cursorShape: Qt.IBeamCursor
                    }
                }
            }

            // Password Text
            Row {
                height : textinputheight

                Text {
                    color : doscolor
            
                    font.family : loginfont.name
                    font.pointSize : dosfontsize

                    verticalAlignment: Text.AlignVCenter
                    height : textinputheight

                    text : "Password:"
                }

                TextInput {
                    id : password

		    focus: userModel.lastUser == "" ? false : true

                    leftPadding : textinputpadding

                    verticalAlignment: Text.AlignVCenter

                    width : textinputwidth
                    height : textinputheight

                    color : doscolor

                    font.family : loginfont.name
                    font.pointSize : dosfontsize

                    echoMode : TextInput.Password
                    passwordCharacter : "*"
                    
                    KeyNavigation.backtab : username
                    KeyNavigation.tab : loginButton
                    Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(username.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }

                    HoverHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        cursorShape: Qt.IBeamCursor
                    }
                }
            }

            // session
            Row {
                height : textinputheight

                Text {
                    height : textinputheight

                    verticalAlignment: Text.AlignVCenter

                    color : doscolor
                    text : "Session: "
                    font.family : loginfont.name
                    font.pointSize : dosfontsize

                    rightPadding: textinputpadding
                }

                ComboBox {
                    id : session

                    width : textinputwidth
                    height : textinputheight

                    color : comboboxcolor
                    borderColor : comboboxbordercolor
                    hoverColor : comboboxhovercolor
                    focusColor : comboboxfocuscolor
                    textColor : doscolor
                    menuColor : comboboxmenucolor
                    arrowColor: comboboxarrowcolor


                    font.pointSize : dosfontsize
                    font.family : loginfont.name

                    arrowIcon : comboboximage

                    model : sessionModel
                    index : model.lastIndex

                    KeyNavigation.tab : password
                    Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            password.focus = true
                            event.accepted = true
                        }
                    }
                }
            }
        }


	Row {
	    leftPadding: 5
	    
	    TextButton {
            id : loginButton

            label: "Login"
            size: dosfontsize
            fontFamily : loginfont.name

            labelColor: linkColor
            hoverLabelColor: hoverLinkColor
            pressLabelColor: pressLinkColor

            onClicked : sddm.login(username.text, password.text, sessionIndex)
            }
	}
    }
}

