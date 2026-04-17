/**
 * CategoryCard.qml - Hub Category Card
 * 
 * Specialized GlassCard for the main Hub grid. Shows icon, title, and subtitle.
 * Designed to match the 2x2 grid layout from the reference design.
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../Theme" as Theme
import "." as Components

GlassCard {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    
    property string title: ""
    property string subtitle: ""
    property string iconName: ""
    property color iconColor: Theme.TigerTheme.colors.primary

    // =========================================================================
    // DIMENSIONS
    // =========================================================================
    
    implicitWidth: 180
    implicitHeight: 150

    // =========================================================================
    // ACCESSIBILITY
    // =========================================================================
    
    accessibleName: title
    accessibleDescription: subtitle

    // =========================================================================
    // CONTENT
    // =========================================================================
    
    contentItem: [
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.md
            spacing: Theme.TigerTheme.spacing.sm

            // Icon container with subtle background
            Rectangle {
                id: iconBackground
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                Layout.alignment: Qt.AlignHCenter
                radius: Theme.TigerTheme.radius.md
                color: Qt.rgba(root.iconColor.r, root.iconColor.g, root.iconColor.b, 0.15)
                
                Components.Icon {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    source: root.iconName
                    color: root.iconColor
                    
                    // Subtle bounce on card hover
                    transform: Scale {
                        origin.x: 16
                        origin.y: 16
                        xScale: root.hovered ? 1.1 : 1.0
                        yScale: root.hovered ? 1.1 : 1.0
                        
                        Behavior on xScale {
                            NumberAnimation {
                                duration: Theme.TigerTheme.animation.normal
                                easing.type: Easing.OutBack
                            }
                        }
                        Behavior on yScale {
                            NumberAnimation {
                                duration: Theme.TigerTheme.animation.normal
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }
            }

            // Title
            Text {
                id: titleText
                Layout.fillWidth: true
                Layout.topMargin: Theme.TigerTheme.spacing.xs
                text: root.title
                color: Theme.TigerTheme.colors.textPrimary
                font.pixelSize: Theme.TigerTheme.typography.sizeMd
                font.weight: Theme.TigerTheme.typography.weightSemiBold
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            // Subtitle
            Text {
                id: subtitleText
                Layout.fillWidth: true
                text: root.subtitle
                color: Theme.TigerTheme.colors.textSecondary
                font.pixelSize: Theme.TigerTheme.typography.sizeSm
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                maximumLineCount: 2
            }

            Item { Layout.fillHeight: true }
        }
    ]
}
