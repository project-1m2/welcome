/**
 * GlassButton.qml - Stylized CTA Button
 * TigerOS Welcome - Premium Edition
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

import "../Theme" as Theme

AbstractButton {
    id: root

    property string variant: "primary"  // "primary", "secondary", "ghost", "danger"
    property string iconName: ""
    property bool loading: false
    property bool iconOnly: false
    property real radius: Theme.TigerTheme.radius.md

    readonly property color bgColor: {
        switch (variant) {
            case "primary": return Theme.TigerTheme.colors.primary
            case "secondary": return Theme.TigerTheme.colors.glassLight
            case "ghost": return "transparent"
            case "danger": return Theme.TigerTheme.colors.error
            default: return Theme.TigerTheme.colors.primary
        }
    }
    
    readonly property color bgHoverColor: {
        switch (variant) {
            case "primary": return Theme.TigerTheme.colors.primaryHover
            case "secondary": return Theme.TigerTheme.colors.glassMedium
            case "ghost": return Theme.TigerTheme.colors.glassLight
            case "danger": return Qt.lighter(Theme.TigerTheme.colors.error, 1.1)
            default: return Theme.TigerTheme.colors.primaryHover
        }
    }
    
    readonly property color textColor: {
        switch (variant) {
            case "primary": return Theme.TigerTheme.colors.textOnPrimary
            case "secondary": return Theme.TigerTheme.colors.textPrimary
            case "ghost": return Theme.TigerTheme.colors.textPrimary
            case "danger": return Theme.TigerTheme.colors.textPrimary
            default: return Theme.TigerTheme.colors.textOnPrimary
        }
    }

    implicitWidth: iconOnly ? implicitHeight : contentRow.implicitWidth + Theme.TigerTheme.spacing.lg * 2
    implicitHeight: 44
    
    padding: Theme.TigerTheme.spacing.sm
    leftPadding: iconOnly ? padding : Theme.TigerTheme.spacing.lg
    rightPadding: iconOnly ? padding : Theme.TigerTheme.spacing.lg

    Accessible.role: Accessible.Button
    Accessible.name: text

    opacity: enabled ? 1.0 : 0.5
    
    Behavior on opacity {
        NumberAnimation { duration: Theme.TigerTheme.animation.fast }
    }

    transform: Scale {
        id: buttonScale
        origin.x: root.width / 2
        origin.y: root.height / 2
        xScale: root.pressed ? 0.96 : 1.0
        yScale: root.pressed ? 0.96 : 1.0
        
        Behavior on xScale {
            NumberAnimation {
                duration: Theme.TigerTheme.animation.instant
                easing.type: Easing.OutQuad
            }
        }
        Behavior on yScale {
            NumberAnimation {
                duration: Theme.TigerTheme.animation.instant
                easing.type: Easing.OutQuad
            }
        }
    }

    background: Rectangle {
        id: buttonBg
        radius: root.radius
        color: root.hovered ? root.bgHoverColor : root.bgColor
        
        border.width: variant === "ghost" ? 1 : 0
        border.color: Theme.TigerTheme.colors.borderMedium
        
        Behavior on color {
            ColorAnimation { duration: Theme.TigerTheme.animation.fast }
        }
        
        layer.enabled: root.variant === "primary" && root.hovered
        layer.effect: DropShadow {
            radius: 12
            samples: 17
            color: Qt.rgba(0, 212, 170, 0.4)
            verticalOffset: 2
            cached: true
        }
    }

    contentItem: RowLayout {
        id: contentRow
        spacing: Theme.TigerTheme.spacing.xs
        
        Item {
            id: spinnerContainer
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            visible: root.loading
            
            Rectangle {
                id: spinner
                anchors.centerIn: parent
                width: 16
                height: 16
                radius: 8
                color: "transparent"
                border.width: 2
                border.color: root.textColor
                
                Rectangle {
                    width: parent.width
                    height: parent.height / 2
                    color: root.bgColor
                    anchors.bottom: parent.bottom
                }
                
                RotationAnimation on rotation {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 1000
                    running: root.loading
                }
            }
        }
        
        Image {
            id: buttonIcon
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            source: root.iconName !== "" ? "image://icon/" + root.iconName : ""
            sourceSize: Qt.size(20, 20)
            visible: root.iconName !== "" && !root.loading
        }
        
        Text {
            id: buttonText
            Layout.fillWidth: !root.iconOnly
            text: root.text
            color: root.textColor
            font.pixelSize: Theme.TigerTheme.typography.sizeMd
            font.weight: Font.SemiBold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: !root.iconOnly && !root.loading
            elide: Text.ElideRight
        }
        
        Image {
            id: arrowIcon
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            source: "image://icon/arrow-right"
            sourceSize: Qt.size(16, 16)
            visible: root.variant === "primary" && !root.iconOnly && !root.loading
            
            transform: Translate {
                x: root.hovered ? 4 : 0
                Behavior on x {
                    NumberAnimation {
                        duration: Theme.TigerTheme.animation.fast
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
}
