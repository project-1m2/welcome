/**
 * AppListItem.qml - Application List Item Component
 * 
 * Displays app info with icon, name, description, and install button.
 * Based on the "Navegadores Web" list from the reference design.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../Theme" as Theme
import "." as Components

Item {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    
    property string appName: ""
    property string appDescription: ""
    property string appIconName: ""
    property bool isInstalled: false
    property bool isInstalling: false
    property int modelIndex: -1

    // =========================================================================
    // SIGNALS
    // =========================================================================
    
    signal installClicked(int index)
    signal removeClicked(int index)
    signal openClicked(int index)

    // =========================================================================
    // DIMENSIONS
    // =========================================================================
    
    implicitWidth: parent ? parent.width : 400
    implicitHeight: 72

    // =========================================================================
    // ACCESSIBILITY
    // =========================================================================
    
    Accessible.role: Accessible.ListItem
    Accessible.name: appName + ". " + appDescription
    Accessible.description: isInstalled ? qsTr("Instalado") : qsTr("Não instalado")

    // =========================================================================
    // CONTENT
    // =========================================================================
    
    Rectangle {
        id: itemBackground
        anchors.fill: parent
        anchors.leftMargin: Theme.TigerTheme.spacing.xs
        anchors.rightMargin: Theme.TigerTheme.spacing.xs
        radius: Theme.TigerTheme.radius.md
        color: itemMouseArea.containsMouse 
               ? Theme.TigerTheme.colors.glassLight 
               : "transparent"
        
        Behavior on color {
            ColorAnimation { duration: Theme.TigerTheme.animation.fast }
        }
        
        MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: if (root.isInstalled) root.openClicked(root.modelIndex)
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.md
            spacing: Theme.TigerTheme.spacing.md

            // App Icon
            Rectangle {
                id: iconContainer
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                radius: Theme.TigerTheme.radius.sm
                color: Theme.TigerTheme.colors.glassDark
                
                Components.Icon {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    source: root.appIconName
                    fallback: "application-x-executable"
                    
                    // Grayscale when not installed (subtle)
                    opacity: root.isInstalled ? 1.0 : 0.7
                }
            }

            // App Info
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.TigerTheme.spacing.xxs

                Text {
                    id: nameText
                    Layout.fillWidth: true
                    text: root.appName
                    color: Theme.TigerTheme.colors.textPrimary
                    font.pixelSize: Theme.TigerTheme.typography.sizeMd
                    font.weight: Theme.TigerTheme.typography.weightSemiBold
                    elide: Text.ElideRight
                }

                Text {
                    id: descriptionText
                    Layout.fillWidth: true
                    text: root.appDescription
                    color: Theme.TigerTheme.colors.textSecondary
                    font.pixelSize: Theme.TigerTheme.typography.sizeSm
                    elide: Text.ElideRight
                }
            }

            // Action Button
            GlassButton {
                id: actionButton
                Layout.alignment: Qt.AlignVCenter
                
                text: {
                    if (root.isInstalling) return ""
                    if (root.isInstalled) return qsTr("Abrir")
                    return qsTr("Instalar")
                }
                
                variant: root.isInstalled ? "secondary" : "primary"
                loading: root.isInstalling
                
                implicitWidth: 100
                implicitHeight: 36
                
                Accessible.name: {
                    if (root.isInstalling) return qsTr("Instalando ") + root.appName
                    if (root.isInstalled) return qsTr("Abrir ") + root.appName
                    return qsTr("Instalar ") + root.appName
                }
                
                onClicked: {
                    if (root.isInstalling) return
                    
                    if (root.isInstalled) {
                        root.openClicked(root.modelIndex)
                    } else {
                        root.installClicked(root.modelIndex)
                    }
                }
            }
        }

        // Bottom separator
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: Theme.TigerTheme.spacing.xl + 48  // Aligned with text
                rightMargin: Theme.TigerTheme.spacing.md
            }
            height: 1
            color: Theme.TigerTheme.colors.borderLight
            visible: true
        }
    }
}
