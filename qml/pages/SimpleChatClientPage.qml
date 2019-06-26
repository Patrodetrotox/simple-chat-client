import QtQuick 2.6
import Sailfish.Silica 1.0
import "../assets"
import QtWebSockets 1.0
// ToDo: import QtWebSockets --

Page {
    property url serverUrl: "wss://echo.websocket.org"

    WebSocket {
        id: webSocket
        url: serverUrl
        // ToDo: set url
        active: true
        onTextMessageReceived: {
            chatView.postIncomingText(message, "EchoServer");
            chatView.scrollToBottom();
            // ToDo: implement handler
        }
        onStatusChanged: {
            if (webSocket.status === WebSocket.Error) {
                console.log("Error: %1".arg(webSocket.errorString));
            } else if (webSocket.status === WebSocket.Open) {
                chatView.postInfo(qsTr("Socket opened"));
            } else if (webSocket.status === WebSocket.Closed) {
                chatView.postInfo(qsTr("Socket closed"));
            }
            chatView.scrollToBottom();
        }
    }
    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width
            height: parent.height

            ChatView {
                id: chatView
                width: parent.width
                height: parent.height - inputArea.height
                clip: true
                header: PageHeader { title: qsTr("WebSockets Client") }
            }
            Rectangle {
                id: inputArea
                width: parent.width
                height: childrenRect.height
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)

                TextField {
                    width: parent.width
                    enabled: webSocket.status === WebSocket.Open
                    placeholderText: qsTr("Input message")
                    label: qsTr("Message")
                    EnterKey.enabled: text.length > 0
                    EnterKey.iconSource: "image://theme/icon-m-sms"
                    EnterKey.onClicked: {
                        // ToDo: send to WebSocket
                        webSocket.sendTextMessage(text);
                        chatView.postOutgoingText(text, qsTr("Me"));
                        chatView.scrollToBottom();
                        text = "";
                    }
                }
            }
        }
    }
}
