/**
 * GlassCard.qml - Glassmorphic Card Component
 * 
 * A translucent card with blur effect, soft shadows, and smooth
 * hover/press animations. The foundation of the TigerOS Welcome UI.
 * 
 * Features:
 * - Frosted glass background with configurable opacity
 * - Subtle border glow
 * - Scale animation on hover (1.02x) and press (0.98x)
 * - Shadow depth changes on interaction
 * - Accessible roles and keyboard navigation
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../Theme" as Theme
import "." as Components

Item {
    id: root

    // =========================================================================
    // PUBLIC PROPERTIES
    // =========================================================================
    
    property alias contentItem: contentContainer.data
    property alias backgroundColor: glassBackground.color
    property alias borderColor: glassBackground.border.color
    property alias radius: glassBackground.radius
    
    property bool interactive: true
    property bool hovered: mouseArea.containsMouse
    property bool pressed: mouseArea.pressed
    property bool highlighted: false
    
    property real glassOpacity: 0.18
    property real hoverScale: 1.02
    property real pressScale: 0.98
    property int shadowRadius: Theme.TigerTheme.effects.shadowRadius
    
    // Accessibility
    property string accessibleName: ""
    property string accessibleDescription: ""

    // =========================================================================
    // SIGNALS
    // =========================================================================
    
    signal clicked()
    signal doubleClicked()

    // =========================================================================
    // DIMENSIONS
    // =========================================================================
    
    implicitWidth: 200
    implicitHeight: 160

    // =========================================================================
    // ACCESSIBILITY
    // =========================================================================
    
    Accessible.role: Accessible.Button
    Accessible.name: accessibleName
    Accessible.description: accessibleDescription
    Accessible.onPressAction: if (interactive) clicked()

    // =========================================================================
    // ANIMATIONS
    // =========================================================================
    
    // Scale transformation
    transform: Scale {
        id: scaleTransform
        origin.x: root.width / 2
        origin.y: root.height / 2
        xScale: 1.0
        yScale: 1.0
        
        Behavior on xScale {
            NumberAnimation {
                duration: Theme.TigerTheme.animation.fast
                easing.type: Theme.TigerTheme.animation.easingBounce
            }
        }
        Behavior on yScale {
            NumberAnimation {
                duration: Theme.TigerTheme.animation.fast
                easing.type: Theme.TigerTheme.animation.easingBounce
            }
        }
    }

    // State machine for hover/press
    states: [
        State {
            name: "hovered"
            when: root.interactive && root.hovered && !root.pressed
            PropertyChanges {
                target: scaleTransform
                xScale: root.hoverScale
                yScale: root.hoverScale
            }
            PropertyChanges {
                target: shadowEffect
                radius: root.shadowRadius * 1.5
                verticalOffset: 8
            }
            PropertyChanges {
                target: glassBackground
                color: Qt.lighter(Theme.TigerTheme.colors.glassLight, 1.3)
                border.color: Qt.rgba(1, 1, 1, 0.25)
            }
        },
        State {
            name: "pressed"
            when: root.interactive && root.pressed
            PropertyChanges {
                target: scaleTransform
                xScale: root.pressScale
                yScale: root.pressScale
            }
            PropertyChanges {
                target: shadowEffect
                radius: root.shadowRadius * 0.5
                verticalOffset: 2
            }
            PropertyChanges {
                target: glassBackground
                color: Qt.darker(Theme.TigerTheme.colors.glassLight, 1.1)
            }
        },
        State {
            name: "highlighted"
            when: root.highlighted && !root.hovered && !root.pressed
            PropertyChanges {
                target: glassBackground
                border.color: Theme.TigerTheme.colors.primary
                border.width: 2
            }
        }
    ]

    // =========================================================================
    // VISUAL LAYERS
    // =========================================================================
    
    // Layer 1: Drop Shadow
    DropShadow {
        id: shadowEffect
        anchors.fill: glassBackground
        source: glassBackground
        horizontalOffset: 0
        verticalOffset: 4
        radius: root.shadowRadius
        samples: 17
        color: Theme.TigerTheme.colors.shadow
        cached: true
        
        Behavior on radius {
            NumberAnimation {
                duration: Theme.TigerTheme.animation.normal
                easing.type: Theme.TigerTheme.animation.easingType
            }
        }
        Behavior on verticalOffset {
            NumberAnimation {
                duration: Theme.TigerTheme.animation.normal
                easing.type: Theme.TigerTheme.animation.easingType
            }
        }
    }

    // Layer 2: Glass Background
    Rectangle {
        id: glassBackground
        anchors.fill: parent
        enabled: root.interactive  // Only intercept when card is clickable
        radius: Theme.TigerTheme.radius.lg
        color: Qt.rgba(1, 1, 1, root.glassOpacity)
        
        border.width: 1
        border.color: Theme.TigerTheme.colors.borderLight
        
        // Subtle gradient overlay for depth
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) }
            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.02) }
        }
        
        Behavior on color {
            ColorAnimation {
                duration: Theme.TigerTheme.animation.fast
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: Theme.TigerTheme.animation.fast
            }
        }
    }

    // Layer 3: Inner highlight (top edge glow)
    Rectangle {
        id: innerHighlight
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 1
        }
        height: 1
        radius: glassBackground.radius - 1
        color: Qt.rgba(1, 1, 1, 0.3)
    }

    // Layer 4: Content Container
    Item {
        id: contentContainer
        anchors {
            fill: parent
            margins: Theme.TigerTheme.spacing.md
        }
    }

    // Layer 5: Mouse Area (on top for interaction)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.interactive  // Only intercept when card is clickable
        hoverEnabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        
        onClicked: {
            if (root.interactive) {
                root.clicked()
            }
        }
        onDoubleClicked: {
            if (root.interactive) {
                root.doubleClicked()
            }
        }
    }

    // Keyboard focus indicator
    Rectangle {
        id: focusIndicator
        anchors.fill: parent
        enabled: root.interactive  // Only intercept when card is clickable
        anchors.margins: -2
        radius: glassBackground.radius + 2
        color: "transparent"
        border.width: 2
        border.color: Theme.TigerTheme.colors.primary
        visible: root.activeFocus
        opacity: 0.8
    }

    // Enable keyboard navigation
    Keys.onSpacePressed: if (root.interactive) root.clicked()
    Keys.onEnterPressed: if (root.interactive) root.clicked()
    Keys.onReturnPressed: if (root.interactive) root.clicked()
}
