/**
 * AppsScreen.qml - Application Installation Hub
 * 
 * Features:
 * - Categorized applications (Browsers, Office, IAs, Tutoriais)
 * - Tabbed category navigation
 * - Script-based installation support
 * - Web app launcher functionality
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../Theme" as Theme
import "../Components" as Components

Item {
    id: root

    signal backClicked()

    property int currentCategory: 0

    // Category definitions with apps
    property var categories: [
        {
            id: "browsers",
            name: qsTr("Navegadores"),
            icon: "internet-web-browser",
            apps: [
                {
                    id: "firefox", 
                    name: "Mozilla Firefox", 
                    desc: qsTr("Rápido, privado e seguro"), 
                    icon: "firefox", 
                    script: ":/Scripts/navegadores/firefox.sh"
                },
                {
                    id: "chrome", 
                    name: "Google Chrome", 
                    desc: qsTr("O navegador mais popular do mundo"), 
                    icon: "google-chrome", 
                    script: ":/Scripts/navegadores/chrome.sh"
                },
                {
                    id: "brave", 
                    name: "Brave", 
                    desc: qsTr("Privacidade em primeiro lugar"), 
                    icon: "brave-browser", 
                    script: ":/Scripts/navegadores/brave.sh"
                },
                {
                    id: "edge", 
                    name: "Microsoft Edge", 
                    desc: qsTr("Baseado no Chromium"), 
                    icon: "microsoft-edge", 
                    script: ":/Scripts/navegadores/edge.sh"
                },
                {
                    id: "opera", 
                    name: "Opera", 
                    desc: qsTr("Com VPN integrada"), 
                    icon: "opera", 
                    script: ":/Scripts/navegadores/opera.sh"
                },
                {
                    id: "tor", 
                    name: "Tor Browser", 
                    desc: qsTr("Navegação anônima"), 
                    icon: "tor-browser", 
                    script: ""
                }
            ]
        },
        {
            id: "office",
            name: qsTr("Escritório"),
            icon: "applications-office",
            apps: [
                {
                    id: "libreoffice", 
                    name: "LibreOffice", 
                    desc: qsTr("Suite completa e livre"), 
                    icon: "libreoffice-startcenter", 
                    script: ":/Scripts/office/libreoffice.sh"
                },
                {
                    id: "wps", 
                    name: "WPS Office", 
                    desc: qsTr("Interface similar ao MS Office"), 
                    icon: "wps-office2019-kprometheus", 
                    script: ":/Scripts/office/wps.sh"
                },
                {
                    id: "office365", 
                    name: "Office 365", 
                    desc: qsTr("Microsoft Office na nuvem"), 
                    icon: "ms-office", 
                    script: ":/Scripts/office/office365.sh",
                    isWebApp: true
                },
                {
                    id: "googledocs", 
                    name: "Google Docs", 
                    desc: qsTr("Documentos colaborativos"), 
                    icon: "google-docs", 
                    script: ":/Scripts/googledocs.sh",
                    isWebApp: true
                }
            ]
        },
        {
            id: "ia",
            name: qsTr("Inteligência Artificial"),
            icon: "preferences-system-activities",
            apps: [
                {
                    id: "chatgpt", 
                    name: "ChatGPT", 
                    desc: qsTr("IA conversacional da OpenAI"), 
                    icon: "chatgpt", 
                    script: ":/Scripts/chatgpt.sh",
                    isWebApp: true
                },
                {
                    id: "gemini", 
                    name: "Google Gemini", 
                    desc: qsTr("IA do Google"), 
                    icon: "gemini", 
                    script: ":/Scripts/gemini.sh",
                    isWebApp: true
                },
                {
                    id: "maritalk", 
                    name: "Maritalk", 
                    desc: qsTr("IA brasileira"), 
                    icon: "maritalk", 
                    script: ":/Scripts/maritalk.sh",
                    isWebApp: true
                },
                {
                    id: "leonardo", 
                    name: "Leonardo AI", 
                    desc: qsTr("Geração de imagens com IA"), 
                    icon: "leonardo-ai", 
                    script: ":/Scripts/leonardo-ai.sh",
                    isWebApp: true
                }
            ]
        },
        {
            id: "tutorials",
            name: qsTr("Tutoriais"),
            icon: "help-about",
            apps: [
                {
                    id: "aula1", 
                    name: qsTr("Introdução ao TigerOS"), 
                    desc: qsTr("Conheça o sistema"), 
                    icon: "video-x-generic", 
                    url: "/var/lib/curso-linux/videos/aula_1.mp4"
                },
                {
                    id: "aula2", 
                    name: qsTr("Personalização"), 
                    desc: qsTr("Temas e aparência"), 
                    icon: "video-x-generic", 
                    url: "/var/lib/curso-linux/videos/aula_2.mp4"
                },
                {
                    id: "aula3", 
                    name: qsTr("Instalando Apps"), 
                    desc: qsTr("Discover e Flatpak"), 
                    icon: "video-x-generic", 
                    url: "/var/lib/curso-linux/videos/aula_3.mp4"
                },
                {
                    id: "aula4", 
                    name: qsTr("Segurança"), 
                    desc: qsTr("Proteja seu sistema"), 
                    icon: "video-x-generic", 
                    url: "/var/lib/curso-linux/videos/aula_4.mp4"
                }
            ]
        }
    ]

    Components.GlassCard {
        id: appsCard
        anchors.fill: parent
        anchors.margins: Theme.TigerTheme.spacing.md
        interactive: false
        glassOpacity: 0.2

        contentItem: [
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.TigerTheme.spacing.lg
                spacing: Theme.TigerTheme.spacing.md

                // Header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.TigerTheme.spacing.md

                    Components.GlassButton {
                        variant: "ghost"
                        iconName: "go-previous"
                        iconOnly: true
                        implicitWidth: 36
                        implicitHeight: 36
                        radius: 18
                        onClicked: root.backClicked()
                    }

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Instalar Aplicativos")
                        color: Theme.TigerTheme.colors.textPrimary
                        font.pixelSize: Theme.TigerTheme.typography.sizeXl
                        font.weight: Theme.TigerTheme.typography.weightBold
                    }
                }

                // Category Tabs
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    radius: Theme.TigerTheme.radius.md
                    color: Qt.rgba(0, 0, 0, 0.15)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        Repeater {
                            model: root.categories
                            
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: Theme.TigerTheme.radius.sm
                                color: index === root.currentCategory 
                                       ? Theme.TigerTheme.colors.primary 
                                       : "transparent"
                                
                                Behavior on color { ColorAnimation { duration: 150 } }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.currentCategory = index
                                }
                                
                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 6
                                    
                                    Image {
                                        Layout.preferredWidth: 18
                                        Layout.preferredHeight: 18
                                        source: "image://icon/" + modelData.icon
                                        sourceSize: Qt.size(18, 18)
                                    }
                                    
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: Theme.TigerTheme.typography.sizeXs
                                        font.weight: index === root.currentCategory ? Font.SemiBold : Font.Normal
                                        color: index === root.currentCategory 
                                               ? "#FFFFFF" 
                                               : Theme.TigerTheme.colors.textSecondary
                                    }
                                }
                            }
                        }
                    }
                }

                // Apps Grid
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: appsGrid.height
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    GridLayout {
                        id: appsGrid
                        width: parent.width
                        columns: 2
                        rowSpacing: Theme.TigerTheme.spacing.sm
                        columnSpacing: Theme.TigerTheme.spacing.sm

                        Repeater {
                            model: root.categories[root.currentCategory].apps

                            AppCard {
                                Layout.fillWidth: true
                                appName: modelData.name
                                appDescription: modelData.desc
                                appIcon: modelData.icon
                                appScript: modelData.script || ""
                                appUrl: modelData.url || ""
                                isWebApp: modelData.isWebApp || false
                            }
                        }
                    }
                }
            }
        ]
    }

    // =========================================================================
    // APP CARD COMPONENT
    // =========================================================================

    component AppCard: Rectangle {
        id: appCardItem
        
        property string appName: ""
        property string appDescription: ""
        property string appIcon: ""
        property string appScript: ""
        property string appUrl: ""
        property bool isWebApp: false
        property bool isInstalling: false
        
        Layout.preferredHeight: 90
        radius: Theme.TigerTheme.radius.md
        color: cardMouse.containsMouse
               ? Theme.TigerTheme.colors.glassMedium
               : Theme.TigerTheme.colors.glassLight
        border.width: 1
        border.color: Theme.TigerTheme.colors.borderLight
        
        Behavior on color { ColorAnimation { duration: 150 } }
        
        MouseArea {
            id: cardMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            onClicked: {
                console.log("AppCard clicked - url:", appCardItem.appUrl, "script:", appCardItem.appScript)
                if (appCardItem.isInstalling) return
                
                if (appCardItem.appUrl) {
                    // Video/URL - open in browser
                    systemController.runCommand("xdg-open \"" + appCardItem.appUrl + "\"")
                } else if (appCardItem.appScript && systemController) {
                    // Run installation script
                    appCardItem.isInstalling = true
                    systemController.executeScript(appCardItem.appScript)
                    installTimer.start()
                }
            }
        }
        
        Timer {
            id: installTimer
            interval: 2000
            onTriggered: appCardItem.isInstalling = false
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.md
            spacing: Theme.TigerTheme.spacing.md
            
            // App Icon
            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                radius: Theme.TigerTheme.radius.sm
                color: Qt.rgba(Theme.TigerTheme.colors.primary.r,
                              Theme.TigerTheme.colors.primary.g,
                              Theme.TigerTheme.colors.primary.b, 0.15)
                
                Image {
                    anchors.centerIn: parent
                    source: "image://icon/" + appCardItem.appIcon
                    sourceSize: Qt.size(36, 36)
                    smooth: true
                }
            }
            
            // App Info
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    
                    Text {
                        text: appCardItem.appName
                        font.pixelSize: Theme.TigerTheme.typography.sizeMd
                        font.weight: Font.SemiBold
                        color: Theme.TigerTheme.colors.textPrimary
                    }
                    
                    // Web App Badge
                    Rectangle {
                        visible: appCardItem.isWebApp
                        width: webLabel.width + 10
                        height: 18
                        radius: 9
                        color: Qt.rgba(Theme.TigerTheme.colors.primary.r,
                                      Theme.TigerTheme.colors.primary.g,
                                      Theme.TigerTheme.colors.primary.b, 0.3)
                        
                        Text {
                            id: webLabel
                            anchors.centerIn: parent
                            text: "WEB"
                            font.pixelSize: 9
                            font.weight: Font.Bold
                            color: Theme.TigerTheme.colors.textPrimary
                        }
                    }
                }
                
                Text {
                    Layout.fillWidth: true
                    text: appCardItem.appDescription
                    font.pixelSize: Theme.TigerTheme.typography.sizeXs
                    color: Theme.TigerTheme.colors.textSecondary
                    elide: Text.ElideRight
                }
            }
            
            // Action Button
            Components.GlassButton {
                implicitWidth: 100
                implicitHeight: 36
                text: appCardItem.appUrl 
                      ? qsTr("Abrir") 
                      : (appCardItem.isInstalling ? "..." : qsTr("Instalar"))
                variant: "secondary"
                enabled: !appCardItem.isInstalling

                onClicked: {
                    if (appCardItem.appUrl) {
                        systemController.runCommand("xdg-open \"" + appCardItem.appUrl + "\"")
                    } else if (appCardItem.appScript) {
                        appCardItem.isInstalling = true
                        systemController.executeScript(appCardItem.appScript)
                    }
                }
            }
        }
    }
}
