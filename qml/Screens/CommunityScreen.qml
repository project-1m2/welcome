/**
 * CommunityScreen.qml - Community Links and Resources
 * 
 * Displays links to TigerOS community resources:
 * GitHub, Telegram, Website, Forum, Wiki, Bug Reports
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../Theme" as Theme
import "../Components" as Components

Item {
    id: root

    signal backRequested()

    Components.GlassCard {
        id: communityCard
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
                        onClicked: root.backRequested()
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: qsTr("Comunidade TigerOS")
                            color: Theme.TigerTheme.colors.textPrimary
                            font.pixelSize: Theme.TigerTheme.typography.sizeXl
                            font.weight: Font.Bold
                        }

                        Text {
                            text: qsTr("Conecte-se com a comunidade, obtenha suporte e contribua.")
                            color: Theme.TigerTheme.colors.textSecondary
                            font.pixelSize: Theme.TigerTheme.typography.sizeSm
                        }
                    }
                }

                // Links Grid
                GridLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 2
                    rowSpacing: Theme.TigerTheme.spacing.sm
                    columnSpacing: Theme.TigerTheme.spacing.sm

                    CommunityLinkCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        title: "GitHub"
                        subtitle: qsTr("Código-fonte e issues")
                        iconName: "fork"
                        accentColor: "#6e5494"
                        onClicked: systemController.openUrl("https://github.com/Tiger-OperatingSystem")
                    }

                    CommunityLinkCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        title: "Telegram"
                        subtitle: qsTr("Grupo da comunidade")
                        iconName: "telegram"
                        accentColor: "#0088cc"
                        onClicked: systemController.openUrl("https://t.me/TigerOS_Linux")
                    }

                    CommunityLinkCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        title: "Website"
                        subtitle: qsTr("Documentação oficial")
                        iconName: "internet-web-browser"
                        accentColor: "#00D4AA"
                        onClicked: systemController.openUrl("https://tigeros.com.br")
                    }

                    CommunityLinkCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        title: qsTr("YouTube")
                        subtitle: qsTr("Tutoriais e vídeos")
                        iconName: "youtube"
                        accentColor: "#FF0000"
                        onClicked: systemController.openUrl("https://www.youtube.com/@mestresemlinux")
                    }

                    CommunityLinkCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        title: "Instagram"
                        subtitle: qsTr("Siga nas redes")
                        iconName: "instagram"
                        accentColor: "#E4405F"
                        onClicked: systemController.openUrl("https://instagram.com/tigerosbr/")
                    }

                    CommunityLinkCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        title: qsTr("Reportar Bug")
                        subtitle: qsTr("Ajude a melhorar")
                        iconName: "tools-report-bug"
                        accentColor: "#dc3545"
                        onClicked: systemController.openUrl("https://github.com/Tiger-OperatingSystem/TigerOS/issues")
                    }
                }

                // Support Banner
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    radius: Theme.TigerTheme.radius.md
                    color: Qt.rgba(Theme.TigerTheme.colors.primary.r,
                                  Theme.TigerTheme.colors.primary.g,
                                  Theme.TigerTheme.colors.primary.b, 0.15)
                    border.width: 1
                    border.color: Qt.rgba(Theme.TigerTheme.colors.primary.r,
                                         Theme.TigerTheme.colors.primary.g,
                                         Theme.TigerTheme.colors.primary.b, 0.3)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.TigerTheme.spacing.md
                        spacing: Theme.TigerTheme.spacing.md

                        Image {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            source: "image://icon/love"
                            sourceSize: Qt.size(40, 40)
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: qsTr("Apoie o TigerOS")
                                font.pixelSize: Theme.TigerTheme.typography.sizeMd
                                font.weight: Font.SemiBold
                                color: Theme.TigerTheme.colors.textPrimary
                            }

                            Text {
                                text: qsTr("Sua contribuição mantém o projeto livre")
                                font.pixelSize: Theme.TigerTheme.typography.sizeXs
                                color: Theme.TigerTheme.colors.textSecondary
                            }
                        }

                        Components.GlassButton {
                            text: qsTr("Doar")
                            variant: "primary"
                            iconName: "starred-symbolic"
                            onClicked: systemController.openUrl("https://ko-fi.com/mestresemlinux")
                        }
                    }
                }
            }
        ]
    }

    // =========================================================================
    // LINK CARD COMPONENT - REDESIGNED
    // =========================================================================
    
    component CommunityLinkCard: Rectangle {
        id: linkCard
        
        property string title: ""
        property string subtitle: ""
        property string iconName: ""
        property color accentColor: Theme.TigerTheme.colors.primary
        
        signal clicked()
        
        radius: Theme.TigerTheme.radius.md
        color: linkCardMouse.containsMouse 
               ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.15)
               : Theme.TigerTheme.colors.glassLight
        border.width: 1
        border.color: linkCardMouse.containsMouse 
                     ? accentColor 
                     : Theme.TigerTheme.colors.borderLight
        
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }
        
        MouseArea {
            id: linkCardMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: linkCard.clicked()
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.md
            spacing: Theme.TigerTheme.spacing.md
            
            // Icon Box
            Rectangle {
                Layout.preferredWidth: 52
                Layout.preferredHeight: 52
                radius: Theme.TigerTheme.radius.sm
                color: Qt.rgba(linkCard.accentColor.r, 
                              linkCard.accentColor.g, 
                              linkCard.accentColor.b, 0.2)
                
                Image {
                    anchors.centerIn: parent
                    source: "image://icon/" + linkCard.iconName
                    sourceSize: Qt.size(28, 28)
                }
            }
            
            // Text Content
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                
                Text {
                    text: linkCard.title
                    font.pixelSize: Theme.TigerTheme.typography.sizeMd
                    font.weight: Font.SemiBold
                    color: Theme.TigerTheme.colors.textPrimary
                }
                
                Text {
                    Layout.fillWidth: true
                    text: linkCard.subtitle
                    font.pixelSize: Theme.TigerTheme.typography.sizeXs
                    color: Theme.TigerTheme.colors.textSecondary
                    elide: Text.ElideRight
                }
            }
            
            // Arrow indicator
            Image {
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                source: "image://icon/go-next"
                sourceSize: Qt.size(16, 16)
                opacity: linkCardMouse.containsMouse ? 1.0 : 0.5
                
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
        }
    }
}
