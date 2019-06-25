import QtQuick 2.6
import Sailfish.Silica 1.0

SilicaListView {

    function postInfo(message) {
        model.append({
            type: "info",
            date: new Date(),
            content: JSON.stringify({ message: message }),
            user: ""
        });
    }

    function postIncomingText(text, user) {
        model.append({
            type: "incoming",
            date: new Date(),
            content: JSON.stringify({ type: "text", text: text }),
            user: user
        });
    }

    function postOutgoingText(text, user) {
        model.append({
            type: "outgoing",
            date: new Date(),
            content: JSON.stringify({ type: "text", text: text }),
            user: user
        });
    }

    function postIncomingImage(source, user) {
        model.append({
            type: "incoming",
            date: new Date(),
            content: JSON.stringify({ type: "image", source: source }),
            user: user
        });
    }

    function postOutgoingImage(source, user) {
        model.append({
            type: "outgoing",
            date: new Date(),
            content: JSON.stringify({ type: "image", source: source }),
            user: user
        });
    }

    model: ListModel { id: listModel }
    spacing: Theme.paddingLarge
    delegate: ListItem {
        property var content: JSON.parse(model.content)

        contentHeight: chatDelegate.height
        width: parent.width
        menu: ContextMenu {
            MenuItem {
                text: qsTr("Delete")
                onClicked: listModel.remove(model.index)
            }
        }

        Column {
            id: chatDelegate

            property int horizontalAlignment: {
                switch (model.type) {
                case "incoming":
                    return Text.AlignRight;
                case "outgoing":
                    return Text.AlignLeft;
                default:
                    return Text.AlignHCenter;
                }
            }

            width: parent.width - Theme.itemSizeExtraLarge
            anchors {
                left: horizontalAlignment === Text.AlignLeft ? parent.left : undefined
                right: horizontalAlignment === Text.AlignRight ? parent.right : undefined
                horizontalCenter: horizontalAlignment === Text.AlignHCenter ? parent.horizontalCenter : undefined
                margins: Theme.horizontalPageMargin
            }
            Loader {
                width: parent.width
                sourceComponent: {
                    if (model.type === "info")
                        return infoMessage;
                    switch (content.type) {
                    case "text":
                        return textMessage;
                    case "image":
                        return imageMessage;
                    default:
                        return null;
                    }
                }

                Component {
                    id: infoMessage

                    Label {
                        text: content.message
                        wrapMode: Text.WordWrap
                        horizontalAlignment: parent.parent.horizontalAlignment
                    }
                }
                Component {
                    id: textMessage

                    Label {
                        text: content.text
                        wrapMode: Text.WordWrap
                        horizontalAlignment: chatDelegate.horizontalAlignment
                    }
                }
                Component {
                    id: imageMessage

                    Image {
                        source: content.source
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: chatDelegate.horizontalAlignment
                    }
                }
            }
            Label {
                width: parent.width
                text: model.user ?
                    qsTr("<b>%1</b>, %2").arg(model.user).arg(model.date.toLocaleString()) :
                    model.date.toLocaleString()
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.highlightColor
                horizontalAlignment: chatDelegate.horizontalAlignment
            }
        }
    }

    VerticalScrollDecorator { }
}
