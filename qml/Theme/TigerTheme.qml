/**
 * TigerTheme.qml - TigerOS Design Tokens & Theme Constants
 * 
 * Official TigerOS color palette based on system design.
 * Centralized theme configuration following 8px grid system.
 * Supports light/dark mode with glassmorphism effects.
 * 
 * Usage: import "Theme" as Theme
 *        Theme.TigerTheme.spacing.md
 */

pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme

    // =========================================================================
    // TIGEROS OFFICIAL COLOR PALETTE
    // =========================================================================
    
    readonly property QtObject tiger: QtObject {
        // Primary Orange Family
        readonly property color orange: "#F5981A"           // Main Tiger Orange
        readonly property color darkOrange: "#E87120"       // Dark geometric shapes
        readonly property color burntOrange: "#D95E10"      // Deep accent
        readonly property color amber: "#FFAE42"            // Light geometric shapes
        readonly property color gold: "#FFD54F"             // Highlights, badges
        readonly property color light: "#FFCC80"            // Soft glows, circles
        readonly property color cream: "#FFF3E0"            // Highlights on dark
        
        // Neutral Family
        readonly property color black: "#1A1A1A"            // Primary text/stripes
        readonly property color charcoal: "#2D3436"         // Secondary text/icons
        readonly property color brown: "#6D4C41"            // Earthy accents
        readonly property color white: "#FFFFFF"            // Light text/backgrounds
        readonly property color snow: "#F8F9FA"             // Light card backgrounds
        
        // Mascot Colors
        readonly property color fur: "#E09540"              // Tiger pelage
        readonly property color stripes: "#2D3436"          // Tiger stripes
        readonly property color nose: "#6D4C41"             // Tiger nose
    }

    // =========================================================================
    // SPACING SYSTEM (8px Grid)
    // =========================================================================
    
    readonly property QtObject spacing: QtObject {
        readonly property int xxs: 2    // Micro spaces
        readonly property int xs: 4     // Extra small
        readonly property int sm: 8     // Small
        readonly property int md: 12    // Medium (default)
        readonly property int lg: 16    // Large
        readonly property int xl: 24    // Extra large
        readonly property int xxl: 32   // Section spacing
        readonly property int xxxl: 48  // Hero sections
    }

    // =========================================================================
    // RADIUS (Rounded Corners)
    // =========================================================================
    
    readonly property QtObject radius: QtObject {
        readonly property int xs: 4     // Badges
        readonly property int sm: 8     // Buttons, inputs
        readonly property int md: 12    // Smaller cards
        readonly property int lg: 16    // Main cards
        readonly property int xl: 20    // Modals, dialogs
        readonly property int full: 9999  // Circular/pill shape
    }

    // =========================================================================
    // COLORS - Adaptive (Dark Mode Default for Glassmorphism)
    // =========================================================================
    
    readonly property QtObject colors: QtObject {
        // === PRIMARY BRAND COLOR (Tiger Orange) ===
        readonly property color primary: theme.tiger.orange
        readonly property color primaryHover: theme.tiger.amber
        readonly property color primaryPressed: theme.tiger.darkOrange
        readonly property color primaryLight: theme.tiger.light
        readonly property color primaryDark: theme.tiger.burntOrange
        
        // Secondary accent (Gold for highlights)
        readonly property color secondary: theme.tiger.gold
        readonly property color secondaryHover: "#FFE082"
        
        // === GLASS BACKGROUNDS (Dark Mode) ===
        readonly property color glassLight: Qt.rgba(1, 1, 1, 0.12)
        readonly property color glassMedium: Qt.rgba(1, 1, 1, 0.18)
        readonly property color glassHeavy: Qt.rgba(1, 1, 1, 0.25)
        readonly property color glassDark: Qt.rgba(0, 0, 0, 0.2)
        
        // === TEXT COLORS (Dark Mode) ===
        readonly property color textPrimary: theme.tiger.white
        readonly property color textSecondary: Qt.rgba(1, 1, 1, 0.7)
        readonly property color textMuted: Qt.rgba(1, 1, 1, 0.5)
        readonly property color textOnPrimary: theme.tiger.black
        
        // === SEMANTIC COLORS ===
        readonly property color success: "#4CAF50"
        readonly property color successLight: "#81C784"
        readonly property color warning: "#FF9800"
        readonly property color warningLight: "#FFB74D"
        readonly property color error: "#F44336"
        readonly property color errorLight: "#E57373"
        readonly property color info: "#29B6F6"
        readonly property color infoLight: "#4FC3F7"
        
        // === BORDERS ===
        readonly property color borderLight: Qt.rgba(1, 1, 1, 0.1)
        readonly property color borderMedium: Qt.rgba(1, 1, 1, 0.2)
        readonly property color borderStrong: Qt.rgba(1, 1, 1, 0.3)
        
        // === SHADOWS ===
        readonly property color shadow: Qt.rgba(0, 0, 0, 0.25)
        readonly property color shadowHeavy: Qt.rgba(0, 0, 0, 0.4)
        readonly property color shadowOrange: Qt.rgba(245, 152, 26, 0.3)
        
        // === DARK MODE BACKGROUND ===
        readonly property color background: "#121212"
        readonly property color surface: "#1E1E1E"
        readonly property color surfaceElevated: "#2C2C2C"
    }

    // =========================================================================
    // GRADIENT DEFINITIONS
    // =========================================================================
    
    readonly property QtObject gradients: QtObject {
        // Main desktop gradient colors (for reference/recreation in QML)
        readonly property color gradientStart: theme.tiger.orange
        readonly property color gradientMid: theme.tiger.darkOrange
        readonly property color gradientEnd: theme.tiger.gold
        
        // Accent gradient
        readonly property color accentStart: theme.tiger.orange
        readonly property color accentEnd: theme.tiger.gold
    }

    // =========================================================================
    // TYPOGRAPHY
    // =========================================================================
    
    readonly property QtObject typography: QtObject {
        // Font family
        readonly property string fontFamily: "Inter, Noto Sans, system-ui, sans-serif"
        
        // Font sizes
        readonly property int sizeXs: 11
        readonly property int sizeSm: 13
        readonly property int sizeMd: 15
        readonly property int sizeLg: 17
        readonly property int sizeXl: 20
        readonly property int size2xl: 24
        readonly property int size3xl: 32
        readonly property int sizeHero: 40
        
        // Font weights
        readonly property int weightRegular: Font.Normal      // 400
        readonly property int weightMedium: Font.Medium       // 500
        readonly property int weightSemiBold: Font.DemiBold   // 600
        readonly property int weightBold: Font.Bold           // 700
    }

    // =========================================================================
    // ANIMATION DURATIONS & EASING
    // =========================================================================
    
    readonly property QtObject animation: QtObject {
        // Durations
        readonly property int instant: 100
        readonly property int fast: 150
        readonly property int normal: 250
        readonly property int slow: 400
        readonly property int verySlow: 600
        
        // Easing curves
        readonly property int easingStandard: Easing.OutQuad
        readonly property int easingEmphasized: Easing.OutExpo
        readonly property int easingSpring: Easing.OutBack
        readonly property int easingSmooth: Easing.InOutQuad
    }

    // =========================================================================
    // LAYOUT CONSTANTS
    // =========================================================================
    
    readonly property QtObject layout: QtObject {
        // Window dimensions
        readonly property int windowMinWidth: 900
        readonly property int windowMinHeight: 600
        readonly property int windowDefaultWidth: 960
        readonly property int windowDefaultHeight: 680
        
        // Structural elements
        readonly property int sidebarWidth: 72
        readonly property int sidebarExpandedWidth: 240
        readonly property int headerHeight: 56
        readonly property int titleBarHeight: 40
        
        // Card dimensions
        readonly property int cardMinWidth: 160
        readonly property int cardMaxWidth: 280
        
        // Icon sizes
        readonly property int iconSizeXs: 16
        readonly property int iconSizeSm: 20
        readonly property int iconSizeMd: 24
        readonly property int iconSizeLg: 32
        readonly property int iconSizeXl: 48
        readonly property int iconSizeHero: 120
    }

    // =========================================================================
    // BLUR & EFFECTS
    // =========================================================================
    
    readonly property QtObject effects: QtObject {
        readonly property int blurRadius: 48           // KWin blur intensity
        readonly property int blurRadiusHeavy: 64
        readonly property int shadowRadius: 16
        readonly property int shadowOffset: 4
        readonly property real glowIntensity: 0.15     // Tiger orange glow
    }
}
