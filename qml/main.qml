/**
 * main.qml - TigerOS Welcome Main Entry Point
 * 
 * Root application window with translucent background, KWin blur,
 * and StackView-based navigation between screens.
 * 
 * Screen Flow:
 * WelcomeScreen → HubScreen → [CustomizeScreen | AppsScreen | ...]
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
// import org.kde.kirigami 2.19 as Kirigami  // Disabled for compatibility

import "Theme" as Theme
import "Components" as Components
import "Screens" as Screens

ApplicationWindow {
    id: mainWindow

    // =========================================================================
    // WINDOW CONFIGURATION
    // =========================================================================
    
    title: qsTr("TigerOS Welcome")
    
    width: Theme.TigerTheme.layout.windowDefaultWidth
    height: Theme.TigerTheme.layout.windowDefaultHeight
    minimumWidth: Theme.TigerTheme.layout.windowMinWidth
    minimumHeight: Theme.TigerTheme.layout.windowMinHeight
    
    visible: true
    
    // Translucent window
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint
    
    // =========================================================================
    // WINDOW CONTROLS (Custom Title Bar)
    // =========================================================================
    
    // Custom title bar for frameless window
    header: Item {
        id: titleBar
        width: parent.width
        height: 40
        
        // Drag area
        MouseArea {
            id: dragArea
            anchors.fill: parent
            property point clickPos: Qt.point(0, 0)
            
            onPressed: function(mouse) {
                clickPos = Qt.point(mouse.x, mouse.y)
            }
            
            onPositionChanged: function(mouse) {
                if (pressed) {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    mainWindow.x += delta.x
                    mainWindow.y += delta.y
                }
            }
        }
        
        // Title
        Text {
            anchors {
                left: parent.left
                leftMargin: Theme.TigerTheme.spacing.lg
                verticalCenter: parent.verticalCenter
            }
            text: mainWindow.title
            font.pixelSize: Theme.TigerTheme.typography.sizeSm
        }
        
        // Window buttons
        RowLayout {
            anchors {
                right: parent.right
                rightMargin: Theme.TigerTheme.spacing.sm
                verticalCenter: parent.verticalCenter
            }
            spacing: Theme.TigerTheme.spacing.xs
            
            // Minimize
            WindowButton {
                iconName: "window-minimize"
                onClicked: mainWindow.showMinimized()
                Accessible.name: qsTr("Minimizar")
            }
            
            // Maximize/Restore
            WindowButton {
                iconName: mainWindow.visibility === Window.Maximized 
                         ? "window-restore" 
                         : "window-maximize"
                onClicked: {
                    if (mainWindow.visibility === Window.Maximized) {
                        mainWindow.showNormal()
                    } else {
                        mainWindow.showMaximized()
                    }
                }
                Accessible.name: mainWindow.visibility === Window.Maximized 
                                ? qsTr("Restaurar") 
                                : qsTr("Maximizar")
            }
            
            // Close
            WindowButton {
                iconName: "window-close"
                isDestructive: true
                onClicked: mainWindow.close()
                Accessible.name: qsTr("Fechar")
            }
        }
    }

    // =========================================================================
    // BACKGROUND - TigerOS Glassmorphism
    // =========================================================================
    
    // Background with semi-transparent dark overlay for readability
    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: 12
        color: Qt.rgba(0.07, 0.07, 0.07, 0.75)  // Dark translucent (#121212 at 75%)
        
        // Tiger orange accent glow - top right
        Rectangle {
            anchors {
                right: parent.right
                top: parent.top
            }
            width: parent.width * 0.6
            height: parent.height * 0.6
            color: "transparent"
            
            RadialGradient {
                anchors.fill: parent
                horizontalOffset: parent.width * 0.3
                verticalOffset: -parent.height * 0.2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(245/255, 152/255, 26/255, 0.18) }  // Tiger Orange
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }
        
        // Tiger gold accent glow - bottom left
        Rectangle {
            anchors {
                left: parent.left
                bottom: parent.bottom
            }
            width: parent.width * 0.5
            height: parent.height * 0.5
            color: "transparent"
            
            RadialGradient {
                anchors.fill: parent
                horizontalOffset: -parent.width * 0.2
                verticalOffset: parent.height * 0.3
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(255/255, 213/255, 79/255, 0.12) }  // Tiger Gold
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }
    }

    // =========================================================================
    // MAIN CONTENT - STACK VIEW NAVIGATION
    // =========================================================================
    
    StackView {
        id: mainStackView
        anchors.fill: parent
        
        initialItem: welcomeScreenComponent
        
        // Smooth transitions between screens
        pushEnter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Theme.TigerTheme.animation.normal
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    property: "x"
                    from: mainStackView.width * 0.1
                    to: 0
                    duration: Theme.TigerTheme.animation.normal
                    easing.type: Theme.TigerTheme.animation.easingType
                }
            }
        }
        
        pushExit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Theme.TigerTheme.animation.fast
                easing.type: Easing.InQuad
            }
        }
        
        popEnter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Theme.TigerTheme.animation.normal
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    property: "x"
                    from: -mainStackView.width * 0.1
                    to: 0
                    duration: Theme.TigerTheme.animation.normal
                    easing.type: Theme.TigerTheme.animation.easingType
                }
            }
        }
        
        popExit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Theme.TigerTheme.animation.fast
                easing.type: Easing.InQuad
            }
        }
    }

    // =========================================================================
    // SCREEN COMPONENTS
    // =========================================================================
    
    Component {
        id: welcomeScreenComponent
        
        Screens.WelcomeScreen {
            onExploreClicked: {
                mainStackView.push(hubScreenComponent)
            }
            onSkipClicked: {
                mainWindow.close()
            }
        }
    }
    
    Component {
        id: hubScreenComponent
        
        Screens.HubScreen {
            onCategorySelected: function(categoryId, targetScreen) {
                switch (targetScreen) {
                    case "CustomizeScreen":
                        mainStackView.push(customizeScreenComponent)
                        break
                    case "AppsScreen":
                        mainStackView.push(appsScreenComponent)
                        break
                    case "FirstStepsScreen":
                        mainStackView.push(firstStepsScreenComponent)
                        break
                    case "CommunityScreen":
                        mainStackView.push(communityScreenComponent)
                        break
                    default:
                        console.log("Unknown screen:", targetScreen)
                }
            }
            
            onAboutClicked: {
                aboutDialog.open()
            }
        }
    }
    
    Component {
        id: customizeScreenComponent
        
        Screens.CustomizeScreen {
            onBackClicked: {
                mainStackView.pop()
            }
        }
    }
    
    Component {
        id: appsScreenComponent
        
        Screens.AppsScreen {
            onBackClicked: {
                mainStackView.pop()
            }
        }
    }
    
    Component {
        id: firstStepsScreenComponent
        
        Screens.FirstStepsScreen {
            onBackClicked: {
                mainStackView.pop()
            }
        }
    }

    Component {
        id: communityScreenComponent
        
        Screens.CommunityScreen {
            onBackRequested: {
                mainStackView.pop()
            }
        }
    }

    // =========================================================================
    // ABOUT DIALOG
    // =========================================================================
    
    Dialog {
        id: aboutDialog
        title: qsTr("Sobre o TigerOS Welcome")
        modal: true
        anchors.centerIn: parent
        width: 480
        height: 520
        
        property int currentTab: 0
        
        // Team members data
        property var teamMembers: [
            { name: "Daigo Asuka", role: qsTr("Idealizador"), avatar: "" },
            { name: "Charles Santana", role: qsTr("Developer"), avatar: "" },
            { name: "Ednei Anunciação", role: qsTr("Designer Gráfico"), avatar: "" },
            { name: "Matheus Augusto", role: qsTr("Developer"), avatar: "" }
        ]
        
        // Collaborators data
        property var collaborators: [
            { name: "Rogerio Souza Santos", role: qsTr("Colaborador"), avatar: "" },
            { name: "Klaibson Ribeiro", role: qsTr("Colaborador"), avatar: "" },
            { name: "Vitor Gabriel Costa da Silva", role: qsTr("Colaborador"), avatar: "" },
            { name: "Jonatan - LinuXpert", role: qsTr("Colaborador"), avatar: "" }
        ]
        
        contentItem: ColumnLayout {
            spacing: Theme.TigerTheme.spacing.sm
            
            // Tab Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                radius: Theme.TigerTheme.radius.sm
                color: Qt.rgba(0, 0, 0, 0.1)
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4
                    
                    Repeater {
                        model: [qsTr("Sobre"), qsTr("Equipe"), qsTr("Colaboradores")]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: Theme.TigerTheme.radius.xs
                            color: aboutDialog.currentTab === index 
                                   ? Theme.TigerTheme.colors.primary 
                                   : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: Theme.TigerTheme.typography.sizeSm
                                font.weight: aboutDialog.currentTab === index ? Font.SemiBold : Font.Normal
                                color: aboutDialog.currentTab === index ? "#FFFFFF" : "#666666"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: aboutDialog.currentTab = index
                            }
                        }
                    }
                }
            }
            
            // Content Stack
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: aboutDialog.currentTab
                
                // TAB 0: About
                ColumnLayout {
                    spacing: Theme.TigerTheme.spacing.md
                    
                    RowLayout {
                        spacing: Theme.TigerTheme.spacing.md
                        
                        Image {
                            Layout.preferredWidth: 72
                            Layout.preferredHeight: 72
                            source: "qrc:/Imgs/Logos/logo.png"
                            sourceSize: Qt.size(72, 72)
                            fillMode: Image.PreserveAspectFit
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "TigerOS Welcome"
                                font.pixelSize: Theme.TigerTheme.typography.sizeLg
                                font.weight: Font.Bold
                                color: "#000000"
                            }
                            
                            Text {
                                text: qsTr("Versão 2.0.0")
                                font.pixelSize: Theme.TigerTheme.typography.sizeSm
                                color: "#5A5A5A"
                            }
                            
                            Text {
                                text: "Qt 6 + QML + KDE Kirigami"
                                font.pixelSize: Theme.TigerTheme.typography.sizeXs
                                color: "#7A7A7A"
                            }
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Qt.rgba(0, 0, 0, 0.1)
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Um aplicativo de boas-vindas moderno para o TigerOS, projetado com amor e atenção aos detalhes para proporcionar a melhor experiência ao usuário.")
                        font.pixelSize: Theme.TigerTheme.typography.sizeSm
                        wrapMode: Text.WordWrap
                        color: "#5A5A5A"
                        lineHeight: 1.4
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    Text {
                        Layout.fillWidth: true
                        text: "© 2024-2026 TigerOS Project\nLicença: GPL-3.0-or-later"
                        font.pixelSize: Theme.TigerTheme.typography.sizeXs
                        color: "#7A7A7A"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                
                // TAB 1: Team
                ColumnLayout {
                    spacing: Theme.TigerTheme.spacing.md
                    
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Nossa Equipe")
                        font.pixelSize: Theme.TigerTheme.typography.sizeMd
                        font.weight: Font.SemiBold
                        color: "#333333"
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    Repeater {
                        model: aboutDialog.teamMembers
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            radius: Theme.TigerTheme.radius.sm
                            color: Qt.rgba(0, 0, 0, 0.05)
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: Theme.TigerTheme.spacing.sm
                                spacing: Theme.TigerTheme.spacing.md
                                
                                Rectangle {
                                    width: 44
                                    height: 44
                                    anchors.verticalCenter: parent.verticalCenter
                                    radius: 22
                                    color: Theme.TigerTheme.colors.primary
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.name.charAt(0)
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 2
                                    
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: Theme.TigerTheme.typography.sizeSm
                                        font.weight: Font.SemiBold
                                        color: "#333333"
                                    }
                                    
                                    Text {
                                        text: modelData.role
                                        font.pixelSize: Theme.TigerTheme.typography.sizeXs
                                        color: "#666666"
                                    }
                                }
                            }
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Obrigado a todos os contribuidores!")
                        font.pixelSize: Theme.TigerTheme.typography.sizeXs
                        color: "#7A7A7A"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                
                // TAB 2: Collaborators
                ColumnLayout {
                    spacing: Theme.TigerTheme.spacing.md
                    
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Colaboradores")
                        font.pixelSize: Theme.TigerTheme.typography.sizeMd
                        font.weight: Font.SemiBold
                        color: "#333333"
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    Repeater {
                        model: aboutDialog.collaborators
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            radius: Theme.TigerTheme.radius.sm
                            color: Qt.rgba(0, 0, 0, 0.05)
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: Theme.TigerTheme.spacing.sm
                                spacing: Theme.TigerTheme.spacing.md
                                
                                Rectangle {
                                    width: 44
                                    height: 44
                                    anchors.verticalCenter: parent.verticalCenter
                                    radius: 22
                                    color: Theme.TigerTheme.tiger.amber
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.name.charAt(0)
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 2
                                    
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: Theme.TigerTheme.typography.sizeSm
                                        font.weight: Font.SemiBold
                                        color: "#333333"
                                    }
                                    
                                    Text {
                                        text: modelData.role
                                        font.pixelSize: Theme.TigerTheme.typography.sizeXs
                                        color: "#666666"
                                    }
                                }
                            }
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Agradecemos a todos que contribuem!")
                        font.pixelSize: Theme.TigerTheme.typography.sizeXs
                        color: "#7A7A7A"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
        
        standardButtons: Dialog.Ok
    }

    // =========================================================================
    // WINDOW BUTTON COMPONENT
    // =========================================================================
    
    component WindowButton: Item {
        id: windowBtn
        
        property string iconName: ""
        property bool isDestructive: false
        
        signal clicked()
        
        width: 28
        height: 28
        
        Rectangle {
            id: btnBackground
            anchors.fill: parent
            radius: Theme.TigerTheme.radius.sm
            color: {
                if (btnMouseArea.pressed) {
                    return windowBtn.isDestructive 
                           ? Theme.TigerTheme.colors.error 
                           : Theme.TigerTheme.colors.glassMedium
                }
                if (btnMouseArea.containsMouse) {
                    return windowBtn.isDestructive 
                           ? Qt.rgba(Theme.TigerTheme.colors.error.r, 
                                    Theme.TigerTheme.colors.error.g, 
                                    Theme.TigerTheme.colors.error.b, 0.7)
                           : Theme.TigerTheme.colors.glassLight
                }
                return "transparent"
            }
            
            Behavior on color {
                ColorAnimation { duration: Theme.TigerTheme.animation.instant }
            }
        }
        
        Image {
            id: windowBtnIcon
            anchors.centerIn: parent
            width: 16
            height: 16
            source: "image://icon/" + windowBtn.iconName
            visible: false
        }
        
        ColorOverlay {
            anchors.fill: windowBtnIcon
            source: windowBtnIcon
            color: windowBtn.isDestructive && btnMouseArea.containsMouse 
                   ? "white" 
                   : "#1a1a1a"
            
            Behavior on color {
                ColorAnimation { duration: Theme.TigerTheme.animation.instant }
            }
        }
        
        MouseArea {
            id: btnMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: windowBtn.clicked()
        }
    }

    // =========================================================================
    // KEYBOARD SHORTCUTS
    // =========================================================================
    
    Shortcut {
        sequence: StandardKey.Close
        onActivated: mainWindow.close()
    }
    
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (mainStackView.depth > 1) {
                mainStackView.pop()
            }
        }
    }
    
    Shortcut {
        sequence: "F11"
        onActivated: {
            if (mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal()
            } else {
                mainWindow.showFullScreen()
            }
        }
    }

    // =========================================================================
    // WINDOW RESIZE HANDLES
    // =========================================================================
    
    // Bottom-right resize handle
    MouseArea {
        id: resizeHandle
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        width: 16
        height: 16
        cursorShape: Qt.SizeFDiagCursor
        
        property point clickPos: Qt.point(0, 0)
        
        onPressed: function(mouse) {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        
        onPositionChanged: function(mouse) {
            if (pressed) {
                var newWidth = mainWindow.width + (mouse.x - clickPos.x)
                var newHeight = mainWindow.height + (mouse.y - clickPos.y)
                
                mainWindow.width = Math.max(newWidth, mainWindow.minimumWidth)
                mainWindow.height = Math.max(newHeight, mainWindow.minimumHeight)
            }
        }
        
        // Visual indicator
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            
            // Diagonal lines
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.2)
                    ctx.lineWidth = 1
                    
                    ctx.beginPath()
                    ctx.moveTo(width - 4, height)
                    ctx.lineTo(width, height - 4)
                    ctx.stroke()
                    
                    ctx.beginPath()
                    ctx.moveTo(width - 8, height)
                    ctx.lineTo(width, height - 8)
                    ctx.stroke()
                }
            }
        }
    }
}
