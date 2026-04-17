# TigerOS Welcome - QMake Build File (Qt 6)
# Alternative to CMake for simpler setups

QT += core gui qml quick quickcontrols2

TEMPLATE = app
TARGET = tiger-welcome
VERSION = 2.0.0

CONFIG += c++17

# Enable high DPI support
QT += gui-private

# Sources
SOURCES += \
    src/main.cpp \
    src/models/AppCategoryModel.cpp \
    src/models/AppListModel.cpp \
    src/controllers/ThemeController.cpp \
    src/controllers/SystemController.cpp

HEADERS += \
    src/models/AppCategoryModel.h \
    src/models/AppListModel.h \
    src/controllers/ThemeController.h \
    src/controllers/SystemController.h \
    src/providers/IconProvider.h

# Include paths
INCLUDEPATH += \
    src \
    src/models \
    src/controllers \
    src/providers

# Resources
RESOURCES += \
    qml/qml.qrc \
    ImgsResources.qrc \
    scripts.qrc

# QML import path
QML_IMPORT_PATH = $$PWD/qml

# KDE Kirigami (optional - only if available)
packagesExist(KF6Kirigami2) {
    CONFIG += link_pkgconfig
    PKGCONFIG += KF6Kirigami2
    DEFINES += HAS_KIRIGAMI
}

# Try KF5 Kirigami if KF6 not available
!packagesExist(KF6Kirigami2) {
    packagesExist(KF5Kirigami2) {
        CONFIG += link_pkgconfig
        PKGCONFIG += KF5Kirigami2
        DEFINES += HAS_KIRIGAMI
    }
}

# Qt5Compat for GraphicalEffects
QT += core5compat

# Installation
target.path = /usr/bin
desktop.files = tiger-welcome.desktop
desktop.path = /usr/share/applications
icon.files = Imgs/Logos/tigeros-welcome.svg
icon.path = /usr/share/icons/hicolor/scalable/apps

INSTALLS += target desktop icon

# Compiler flags
QMAKE_CXXFLAGS += -Wall -Wextra
QMAKE_CXXFLAGS_RELEASE += -O2
