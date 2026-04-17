/**
 * FirstStepsScreen.qml - Welcome and First Steps
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Theme" as Theme
import "../Components" as Components

Item {
    id: root
    
    signal backClicked()
    
    Components.GlassCard {
        interactive: false
        anchors.fill: parent
        anchors.margins: Theme.TigerTheme.spacing.lg
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.lg
            spacing: Theme.TigerTheme.spacing.lg
            
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
                    text: qsTr("Primeiros Passos")
                    color: Theme.TigerTheme.colors.textPrimary
                    font.pixelSize: Theme.TigerTheme.typography.sizeXl
                    font.weight: Theme.TigerTheme.typography.weightBold
                }
            }
            
            // Welcome Banner
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 110
                radius: Theme.TigerTheme.radius.lg
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: Theme.TigerTheme.tiger.orange }
                    GradientStop { position: 1.0; color: Theme.TigerTheme.tiger.darkOrange }
                }
                
                Row {
                    anchors.fill: parent
                    anchors.margins: Theme.TigerTheme.spacing.lg
                    spacing: Theme.TigerTheme.spacing.lg
                    
                    Image {
                        width: 72
                        height: 72
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/Imgs/Logos/logo.png"
                        sourceSize: Qt.size(72, 72)
                        fillMode: Image.PreserveAspectFit
                    }
                    
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        
                        Text {
                            text: qsTr("Bem-vindo ao TigerOS!")
                            color: "#FFFFFF"
                            font.pixelSize: Theme.TigerTheme.typography.sizeLg
                            font.weight: Font.Bold
                        }
                        
                        Text {
                            text: qsTr("Configure seu sistema e comece a explorar")
                            color: Qt.rgba(1, 1, 1, 0.85)
                            font.pixelSize: Theme.TigerTheme.typography.sizeSm
                        }
                    }
                }
            }
            
            // Quick Actions - Simple list
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.TigerTheme.spacing.sm
                
                ActionCard {
                    Layout.fillWidth: true
                    actionTitle: qsTr("Verificar Atualizações")
                    actionDesc: qsTr("Mantenha seu sistema seguro e atualizado")
                    actionIcon: "system-software-update"
                    onClicked: if (systemController) systemController.runCommand("plasma-discover --mode update")
                }
                
                ActionCard {
                    Layout.fillWidth: true
                    actionTitle: qsTr("Drivers Adicionais")
                    actionDesc: qsTr("Instale drivers proprietários se necessário")
                    actionIcon: "cpu"
                    onClicked: if (systemController) systemController.runCommand("plasma-discover --mode installed")
                }
                
                ActionCard {
                    Layout.fillWidth: true
                    actionTitle: qsTr("Configurar Backup")
                    actionDesc: qsTr("Proteja seus arquivos importantes")
                    actionIcon: "folder-sync"
                    onClicked: if (systemController) systemController.runCommand("pkexec timeshift-gtk")
                }
                
                ActionCard {
                    Layout.fillWidth: true
                    actionTitle: qsTr("Firewall")
                    actionDesc: qsTr("Configure a segurança de rede")
                    actionIcon: "security-high"
                    onClicked: if (systemController) systemController.runCommand("systemsettings kcm_firewall")
                }
                
                Item { Layout.fillHeight: true }
            }
        }
    }
    
    // Simple Action Card Component
    component ActionCard: Rectangle {
        id: cardRoot
        
        property string actionTitle: ""
        property string actionDesc: ""
        property string actionIcon: ""
        
        signal clicked()
        
        implicitHeight: 72
        radius: Theme.TigerTheme.radius.md
        color: cardMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 1, 1, 0.05)
        
        MouseArea {
            id: cardMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: cardRoot.clicked()
        }
        
        Row {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.md
            spacing: Theme.TigerTheme.spacing.md
            
            Rectangle {
                width: 48
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                radius: Theme.TigerTheme.radius.sm
                color: Qt.rgba(Theme.TigerTheme.colors.primary.r,
                              Theme.TigerTheme.colors.primary.g,
                              Theme.TigerTheme.colors.primary.b, 0.2)
                
                Image {
                    anchors.centerIn: parent
                    source: "image://icon/" + cardRoot.actionIcon
                    sourceSize: Qt.size(24, 24)
                }
            }
            
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                
                Text {
                    text: cardRoot.actionTitle
                    font.pixelSize: Theme.TigerTheme.typography.sizeSm
                    font.weight: Font.SemiBold
                    color: Theme.TigerTheme.colors.textPrimary
                }
                
                Text {
                    text: cardRoot.actionDesc
                    font.pixelSize: Theme.TigerTheme.typography.sizeXs
                    color: Theme.TigerTheme.colors.textSecondary
                }
            }
            
            Item { width: 1; height: 1; Layout.fillWidth: true }
            
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "image://icon/go-next"
                sourceSize: Qt.size(16, 16)
                opacity: cardMouse.containsMouse ? 1.0 : 0.5
            }
        }
    }
}
