TARGET = simple-chat-client

CONFIG += sailfishapp_qml

DISTFILES += qml/simple-chat-client.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SimpleChatClientPage.qml \
    qml/assets/ChatView.qml \
    rpm/simple-chat-client.yaml \
    translations/*.ts \
    simple-chat-client.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/simple-chat-client-ru.ts

SOURCES +=
