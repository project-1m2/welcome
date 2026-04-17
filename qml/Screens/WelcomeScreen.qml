/**
 * WelcomeScreen.qml - Initial Welcome Hero Screen
 * TigerOS Welcome - Premium Edition
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

import "../Theme" as Theme
import "../Components" as Components

Item {
    id: root

    signal exploreClicked()
    signal skipClicked()

    property bool animationsComplete: false
    
    SequentialAnimation {
        id: entranceAnimation
        running: true
        
        PauseAnimation { duration: 100 }
        
        ParallelAnimation {
            NumberAnimation {
                target: logoImage
                property: "opacity"
                from: 0; to: 1
                duration: Theme.TigerTheme.animation.slow
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: logoImage
                property: "scale"
                from: 0.8; to: 1
                duration: Theme.TigerTheme.animation.slow
                easing.type: Easing.OutBack
            }
        }
        
        PauseAnimation { duration: 150 }
        
        NumberAnimation {
            target: titleColumn
            property: "opacity"
            from: 0; to: 1
            duration: Theme.TigerTheme.animation.normal
            easing.type: Easing.OutQuad
        }
        
        PauseAnimation { duration: 100 }
        
        NumberAnimation {
            target: buttonsRow
            property: "opacity"
            from: 0; to: 1
            duration: Theme.TigerTheme.animation.normal
            easing.type: Easing.OutQuad
        }
        
        PropertyAction {
            target: root
            property: "animationsComplete"
            value: true
        }
    }

    Components.GlassCard {
        id: mainCard
        anchors.fill: parent
        anchors.margins: Theme.TigerTheme.spacing.xs
        interactive: false
        glassOpacity: 0.18
        radius: Theme.TigerTheme.radius.lg
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.xxl
            spacing: Theme.TigerTheme.spacing.xxl

            Item {
                Layout.preferredWidth: parent.width * 0.35
                Layout.fillHeight: true

                Image {
                    id: logoImage
                    anchors.centerIn: parent
                    width: Math.min(180, parent.width * 0.8)
                    height: width
                    source: "qrc:/Imgs/Logos/logo.png"
                    sourceSize: Qt.size(180, 180)
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true
                    opacity: 0
                    scale: 0.8
                }
                
                Glow {
                    anchors.fill: logoImage
                    source: logoImage
                    radius: 32
                    samples: 33
                    color: Theme.TigerTheme.colors.primary
                    opacity: 0.3
                    cached: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.TigerTheme.spacing.lg

                Item { Layout.fillHeight: true }

                ColumnLayout {
                    id: titleColumn
                    Layout.fillWidth: true
                    spacing: Theme.TigerTheme.spacing.xs
                    opacity: 0

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Bem-vindo ao TigerOS")
                        color: Theme.TigerTheme.colors.textPrimary
                        font.pixelSize: Theme.TigerTheme.typography.sizeHero
                        font.weight: Font.Bold
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.topMargin: Theme.TigerTheme.spacing.md
                        text: qsTr("Sua jornada digital começa aqui.\nFluida, livre e bonita.")
                        color: Theme.TigerTheme.colors.textSecondary
                        font.pixelSize: Theme.TigerTheme.typography.sizeLg
                        lineHeight: 1.5
                        wrapMode: Text.WordWrap
                    }
                }

                Item { Layout.preferredHeight: Theme.TigerTheme.spacing.xl }

                RowLayout {
                    id: buttonsRow
                    Layout.fillWidth: true
                    spacing: Theme.TigerTheme.spacing.md
                    opacity: 0

                    Components.GlassButton {
                        id: exploreButton
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 52
                        text: qsTr("Explorar")
                        variant: "primary"
                        onClicked: root.exploreClicked()
                        
                        Accessible.name: qsTr("Explorar o sistema")
                    }

                    Components.GlassButton {
                        id: skipButton
                        Layout.preferredWidth: 140
                        Layout.preferredHeight: 52
                        text: qsTr("Pular")
                        variant: "ghost"
                        onClicked: root.skipClicked()
                        
                        Accessible.name: qsTr("Pular introdução")
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
    
    Keys.onEnterPressed: exploreButton.clicked()
    Keys.onReturnPressed: exploreButton.clicked()
    Keys.onEscapePressed: skipButton.clicked()
}
