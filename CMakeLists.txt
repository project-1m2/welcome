# TigerOS Welcome - Modern CMake Build System
# Requires CMake 3.16+ and Qt 6.2+

cmake_minimum_required(VERSION 3.16)

project(tiger-welcome 
    VERSION 2.0.0 
    DESCRIPTION "TigerOS Welcome Application"
    LANGUAGES CXX
)

# ============================================================================
# Project Configuration
# ============================================================================

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# ============================================================================
# Dependencies
# ============================================================================

find_package(Qt6 6.2 REQUIRED COMPONENTS 
    Core
    Gui
    Qml
    Quick
    QuickControls2
)

find_package(KF6 REQUIRED COMPONENTS
    Kirigami2
)

# ============================================================================
# Sources
# ============================================================================

set(SOURCES
    src/main.cpp
    src/models/AppCategoryModel.cpp
    src/models/AppCategoryModel.h
    src/models/AppListModel.cpp
    src/models/AppListModel.h
    src/controllers/ThemeController.cpp
    src/controllers/ThemeController.h
    src/controllers/SystemController.cpp
    src/controllers/SystemController.h
)

set(RESOURCES
    qml/qml.qrc
    ImgsResources.qrc
    scripts.qrc
)

# ============================================================================
# Executable
# ============================================================================

qt_add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${RESOURCES}
)

# ============================================================================
# Include Directories
# ============================================================================

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/models
    ${CMAKE_CURRENT_SOURCE_DIR}/src/controllers
)

# ============================================================================
# Linking
# ============================================================================

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    KF6::Kirigami2
)

# ============================================================================
# QML Import Paths
# ============================================================================

set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_QML_MODULE_IMPORT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/qml"
)

# ============================================================================
# Installation
# ============================================================================

include(GNUInstallDirs)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES tiger-welcome.desktop
    DESTINATION ${CMAKE_INSTALL_DATADIR}/applications
)

install(FILES Imgs/Logos/tigeros-welcome.svg
    DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps
    OPTIONAL
)

# ============================================================================
# Summary
# ============================================================================

message(STATUS "")
message(STATUS "TigerOS Welcome ${PROJECT_VERSION}")
message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Qt version: ${Qt6_VERSION}")
message(STATUS "  Install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")
