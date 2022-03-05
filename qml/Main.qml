import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
//import Morph.Web 0.1
import "Components"
import QtWebEngine 1.6
//import Qt.labs.settings 1.0
//import QtSystemInfo 5.5
//import Ubuntu.Components.ListItems 1.3 as ListItemm
import Ubuntu.Content 1.3


MainView {
    id: mainLayout
    objectName: 'mainView'
    applicationName: 'discord-web.walking-octopus'
    automaticOrientation: true
    backgroundColor : "transparent"

    width: units.gu(75)
    height: units.gu(65)
    clip: false
    anchorToKeyboard: true

    property list<ContentItem> importItems

    PageStack {
        id: mainPageStack
        anchors.fill: parent
        Component.onCompleted: mainPageStack.push(pageMain)

        Page {
            id: pageMain
            anchors.fill: parent

            FlyingButton {
                id: hideSidebarButton
                onClicked: internal.toggleMenu()
                iconName: internal.showMenu ? "back" : "next"
                anchors.bottomMargin: units.gu(2)
                visibleState: true //!webview.loading
            }

            WebEngineView {
                id: webview
                anchors { fill: parent }
                //focus: true
                zoomFactor: units.gu(1) / 8.4
                settings.pluginsEnabled: true
                url: "https://discord.com/channels/@me"

                profile:  WebEngineProfile {
                    id: webContext
                    httpUserAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
                    storageName: "Storage"
                    persistentStoragePath: "/home/phablet/.cache/discord-web.walking-octopus/QtWebEngine"
                }

                onFileDialogRequested: function(request) {
                    request.accepted = true;
                    var importPage = mainPageStack.push(Qt.resolvedUrl("ImportPage.qml"),{"contentType": ContentType.All, "handler": ContentHandler.Source})
                    importPage.imported.connect(function(fileUrl) {
                        console.log(String(fileUrl).replace("file://", ""));
                        request.dialogAccept(String(fileUrl).replace("file://", ""));
                        mainPageStack.push(pageMain)
                    })
                }
                onNewViewRequested: {
                    request.action = WebEngineNavigationRequest.IgnoreRequest
                    if(request.userInitiated) {
                        Qt.openUrlExternally(request.requestedUrl)
                    }
                }
            }
        }
    }


    QtObject {
        id: internal
        property bool showMenu: true

        function toggleMenu() {
            webview.runJavaScript(`document.querySelectorAll(".sidebar-1tnWFu, .guilds-2JjMmN, .membersWrap-3NUR2t").forEach(function(x) {
		if (x.style.display === "none") {
			x.style.display = "flex";
		} else {
			x.style.display = "none";
		} })`)
            showMenu = !showMenu
        }
    }
}
