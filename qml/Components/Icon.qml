/**
 * Icon.qml - Simple Icon Wrapper using FreeDesktop icons
 */

import QtQuick 2.15

Item {
    id: root
    
    property string source: ""
    property string fallback: "application-x-executable"
    property color color: "white"  // Note: color is for API compat only
    
    Image {
        id: iconImage
        anchors.fill: parent
        source: root.source !== "" ? "image://icon/" + root.source : ""
        sourceSize: Qt.size(parent.width, parent.height)
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        
        onStatusChanged: {
            if (status === Image.Error && root.fallback !== "") {
                source = "image://icon/" + root.fallback
            }
        }
    }
}
