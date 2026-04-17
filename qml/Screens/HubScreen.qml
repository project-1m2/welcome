/**
 * HubScreen.qml - Main Hub with Category Grid
 * 
 * Premium redesigned central navigation hub with full-screen layout,
 * vibrant gradient cards, and enhanced glassmorphism.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

import "../Theme" as Theme
import "../Components" as Components

Item {
    id: root

    signal categorySelected(string categoryId, string targetScreen)
    signal aboutClicked()

    property bool animationsComplete: false

    SequentialAnimation {
        id: entranceAnimation
        running: true
        
        PauseAnimation { duration: 50 }
        
        ParallelAnimation {
            NumberAnimation {
                target: headerSection
                property: "opacity"
                from: 0; to: 1
                duration: Theme.TigerTheme.animation.normal
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: headerSection
                property: "y"
                from: -20; to: 0
                duration: Theme.TigerTheme.animation.normal
                easing.type: Easing.OutQuad
            }
        }
        
        PropertyAction {
            target: root
            property: "animationsComplete"
            value: true
        }
    }

    // MAIN CONTAINER - FILLS ENTIRE WINDOW
    Components.GlassCard {
        id: mainContainer
        anchors.fill: parent
        anchors.margins: Theme.TigerTheme.spacing.xs
        interactive: false
        glassOpacity: 0.15
        radius: Theme.TigerTheme.radius.lg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.TigerTheme.spacing.xl
            spacing: Theme.TigerTheme.spacing.xl

            // HEADER SECTION
            RowLayout {
                id: headerSection
                Layout.fillWidth: true
                spacing: Theme.TigerTheme.spacing.lg
                opacity: 0

                Item {
                    Layout.preferredWidth: 56
                    Layout.preferredHeight: 56
                    
                    Image {
                        id: logoImg
                        anchors.centerIn: parent
                        width: 48
                        height: 48
                        source: "qrc:/Imgs/Logos/logo.png"
                        sourceSize: Qt.size(48, 48)
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                    }
                    
                    Glow {
                        anchors.fill: logoImg
                        source: logoImg
                        radius: 12
                        samples: 25
                        color: Theme.TigerTheme.colors.primary
                        opacity: 0.4
                        cached: true
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: qsTr("Central de Boas-Vindas")
                        color: Theme.TigerTheme.colors.textPrimary
                        font.pixelSize: Theme.TigerTheme.typography.size2xl
                        font.weight: Font.Bold
                    }
                    
                    Text {
                        text: qsTr("Configure e personalize seu TigerOS")
                        color: Theme.TigerTheme.colors.textSecondary
                        font.pixelSize: Theme.TigerTheme.typography.sizeMd
                        opacity: 0.8
                    }
                }
            }

            // SYSTEM INFO COMPACT BAR
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                radius: Theme.TigerTheme.radius.md
                color: Qt.rgba(1, 1, 1, 0.06)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.08)
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.TigerTheme.spacing.md
                    anchors.rightMargin: Theme.TigerTheme.spacing.md
                    spacing: Theme.TigerTheme.spacing.md
                    
                    // OS Version
                    Row {
                        spacing: 4
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://icon/distributor-logo"
                            sourceSize: Qt.size(16, 16)
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: systemController ? systemController.osVersion : "TigerOS"
                            color: Theme.TigerTheme.colors.textPrimary
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }
                    }
                    
                    Rectangle { width: 1; height: 20; color: Qt.rgba(1,1,1,0.1) }
                    
                    // KDE Plasma
                    Row {
                        spacing: 4
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://icon/plasma"
                            sourceSize: Qt.size(16, 16)
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Plasma " + (systemController ? systemController.kdeVersion : "")
                            color: Theme.TigerTheme.colors.textSecondary
                            font.pixelSize: 11
                        }
                    }
                    
                    Rectangle { width: 1; height: 20; color: Qt.rgba(1,1,1,0.1) }
                    
                    // Display Server
                    Row {
                        spacing: 4
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://icon/video-display"
                            sourceSize: Qt.size(16, 16)
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: systemController ? systemController.displayServer : ""
                            color: Theme.TigerTheme.colors.textSecondary
                            font.pixelSize: 11
                        }
                    }
                    
                    Rectangle { width: 1; height: 20; color: Qt.rgba(1,1,1,0.1) }
                    
                    // Kernel
                    Row {
                        spacing: 4
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://icon/tux"
                            sourceSize: Qt.size(16, 16)
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: systemController ? systemController.kernelVersion : ""
                            color: Theme.TigerTheme.colors.textSecondary
                            font.pixelSize: 11
                        }
                    }
                    
                    Rectangle { width: 1; height: 20; color: Qt.rgba(1,1,1,0.1) }
                    
                    // RAM
                    Row {
                        spacing: 4
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://icon/memory"
                            sourceSize: Qt.size(16, 16)
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: systemController ? systemController.ramInfo : ""
                            color: Theme.TigerTheme.colors.textSecondary
                            font.pixelSize: 11
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    // Hostname
                    Text {
                        text: systemController ? systemController.hostname : ""
                        color: Theme.TigerTheme.colors.textMuted
                        font.pixelSize: 10
                    }
                }
            }


            // CATEGORY CARDS GRID
            GridLayout {
                id: categoryGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: Theme.TigerTheme.spacing.lg
                columnSpacing: Theme.TigerTheme.spacing.lg

                property var categories: [
                    {
                        id: "firststeps",
                        title: qsTr("Primeiros Passos"),
                        subtitle: qsTr("Atualizações e configurações iniciais"),
                        icon: "system-software-update",
                        gradient1: "#10B981",
                        gradient2: "#059669",
                        target: "FirstStepsScreen"
                    },
                    {
                        id: "customize",
                        title: qsTr("Personalizar"),
                        subtitle: qsTr("Temas, cores e aparência"),
                        icon: "preferences-desktop-theme",
                        gradient1: "#6366F1",
                        gradient2: "#4F46E5",
                        target: "CustomizeScreen"
                    },
                    {
                        id: "apps",
                        title: qsTr("Descobrir Apps"),
                        subtitle: qsTr("Navegadores, escritório e mais"),
                        icon: "application-x-executable",
                        gradient1: "#F59E0B",
                        gradient2: "#D97706",
                        target: "AppsScreen"
                    },
                    {
                        id: "community",
                        title: qsTr("Comunidade"),
                        subtitle: qsTr("Suporte e contribuição"),
                        icon: "system-users",
                        gradient1: "#EC4899",
                        gradient2: "#DB2777",
                        target: "CommunityScreen"
                    }
                ]
                
                Repeater {
                    model: categoryGrid.categories
                    
                    Rectangle {
                        id: catCard
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 200
                        Layout.minimumHeight: 160
                        
                        radius: Theme.TigerTheme.radius.lg
                        color: Qt.rgba(1, 1, 1, 0.08)
                        border.width: 1
                        border.color: Qt.rgba(1, 1, 1, hovered ? 0.25 : 0.1)
                        
                        property bool hovered: cardMouseArea.containsMouse
                        property bool pressed: cardMouseArea.pressed
                        
                        Rectangle {
                            id: accentBar
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 4
                            radius: Theme.TigerTheme.radius.lg
                            
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: modelData.gradient1 }
                                GradientStop { position: 1.0; color: modelData.gradient2 }
                            }
                        }
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.TigerTheme.spacing.lg
                            spacing: Theme.TigerTheme.spacing.md

                            Rectangle {
                                Layout.preferredWidth: 56
                                Layout.preferredHeight: 56
                                radius: 14
                                color: Qt.rgba(1, 1, 1, 0.1)
                                
                                Image {
                                    anchors.centerIn: parent
                                    source: "image://icon/" + modelData.icon
                                    sourceSize.width: 32
                                    sourceSize.height: 32
                                }
                            }
                            
                            Text {
                                Layout.fillWidth: true
                                text: modelData.title
                                color: Theme.TigerTheme.colors.textPrimary
                                font.pixelSize: Theme.TigerTheme.typography.sizeLg
                                font.weight: Font.SemiBold
                                wrapMode: Text.WordWrap
                            }
                            
                            Text {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                text: modelData.subtitle
                                color: Theme.TigerTheme.colors.textSecondary
                                font.pixelSize: Theme.TigerTheme.typography.sizeSm
                                wrapMode: Text.WordWrap
                                opacity: 0.75
                                verticalAlignment: Text.AlignTop
                            }
                        }
                        
                        scale: pressed ? 0.97 : (hovered ? 1.02 : 1.0)
                        Behavior on scale {
                            NumberAnimation {
                                duration: Theme.TigerTheme.animation.fast
                                easing.type: Easing.OutBack
                            }
                        }
                        
                        Behavior on border.color {
                            ColorAnimation { duration: Theme.TigerTheme.animation.fast }
                        }
                        
                        opacity: 0
                        transform: Translate { id: cardTranslate; y: 30 }
                        
                        Component.onCompleted: {
                            cardEntranceAnim.start()
                        }
                        
                        SequentialAnimation {
                            id: cardEntranceAnim
                            
                            PauseAnimation { duration: 150 + (index * 100) }
                            
                            ParallelAnimation {
                                NumberAnimation {
                                    target: catCard
                                    property: "opacity"
                                    to: 1
                                    duration: Theme.TigerTheme.animation.slow
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: cardTranslate
                                    property: "y"
                                    to: 0
                                    duration: Theme.TigerTheme.animation.slow
                                    easing.type: Easing.OutExpo
                                }
                            }
                        }
                        
                        MouseArea {
                            id: cardMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                root.categorySelected(modelData.id, modelData.target)
                            }
                        }
                        
                        Accessible.role: Accessible.Button
                        Accessible.name: modelData.title
                        Accessible.description: modelData.subtitle
                    }
                }
            }

            // FOOTER
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.TigerTheme.spacing.md

                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: Qt.rgba(1, 1, 1, aboutBtn.containsMouse ? 0.15 : 0.08)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.1)
                    
                    Behavior on color {
                        ColorAnimation { duration: Theme.TigerTheme.animation.fast }
                    }
                    
                    Image {
                        anchors.centerIn: parent
                        source: "image://icon/help-about"
                        sourceSize.width: 20
                        sourceSize.height: 20
                    }
                    
                    MouseArea {
                        id: aboutBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.aboutClicked()
                    }
                    
                    Accessible.role: Accessible.Button
                    Accessible.name: qsTr("Sobre o TigerOS")
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    spacing: Theme.TigerTheme.spacing.sm
                    
                    Text {
                        text: qsTr("Mostrar ao iniciar")
                        color: Theme.TigerTheme.colors.textSecondary
                        font.pixelSize: Theme.TigerTheme.typography.sizeSm
                    }
                    
                    Switch {
                        id: autostartSwitch
                        checked: systemController ? systemController.autostartEnabled : true
                        
                        onToggled: {
                            if (systemController) {
                                systemController.setAutostartEnabled(checked)
                            }
                        }
                        
                        Accessible.name: qsTr("Mostrar TigerOS Welcome ao iniciar")
                        Accessible.role: Accessible.CheckBox
                        
                        // Custom Tiger Orange styling
                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            x: autostartSwitch.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 13
                            color: autostartSwitch.checked ? Theme.TigerTheme.colors.primary : Qt.rgba(1, 1, 1, 0.2)
                            border.color: autostartSwitch.checked ? Theme.TigerTheme.colors.primaryDark : Qt.rgba(1, 1, 1, 0.1)
                            border.width: 1
                            
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            Rectangle {
                                x: autostartSwitch.checked ? parent.width - width - 3 : 3
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                height: 20
                                radius: 10
                                color: "white"
                                
                                Behavior on x {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
