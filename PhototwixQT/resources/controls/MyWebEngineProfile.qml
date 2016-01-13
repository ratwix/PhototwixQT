import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtWebEngine 1.1

Item {
    property alias profile : pr
    property alias storage : pr.storageName

    WebEngineProfile {
            id:pr
            offTheRecord: true
    }

    /*
    WebEngineView { //WebEngineView
        id: webview
        anchors.fill: parent

        settings.localContentCanAccessRemoteUrls: true
        settings.hyperlinkAuditingEnabled: true

        profile.httpCacheType: WebEngineProfile.MemoryHttpCache
        profile.persistentCookiesPolicy: WebEngineProfile.NoPersistentCookies
        profile.offTheRecord: true

        onJavaScriptConsoleMessage: {
            console.log("JAVASCRIPT:" + message)
        }
    }
    */
}
