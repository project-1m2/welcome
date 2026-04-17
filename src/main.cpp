/**
 * TigerOS Welcome - A Modern Glassmorphic Welcome App
 * 
 * High-performance Qt Quick application with native blur integration,
 * translucent window support, and dynamic C++ models.
 * 
 * Copyright (c) 2024-2026 TigerOS Project
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QIcon>
#include <QStandardPaths>
#include <QDir>

#include "models/AppCategoryModel.h"
#include "models/AppListModel.h"
#include "controllers/ThemeController.h"
#include "controllers/SystemController.h"
#include "providers/IconProvider.h"

int main(int argc, char *argv[])
{
    // Enable high DPI scaling (critical for modern displays)
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(
        Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
    
    QGuiApplication app(argc, argv);
    
    // Application metadata
    app.setOrganizationName("TigerOS");
    app.setOrganizationDomain("tigeros.com.br");
    app.setApplicationName("TigerOS Welcome");
    app.setApplicationVersion("2.0.0");
    app.setWindowIcon(QIcon::fromTheme("tigeros-welcome", 
                      QIcon(":/icons/tigeros-welcome.png")));
    
    // Enable OpenGL for better blur performance on Wayland/X11
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
    
    // Set default surface format for translucency
    QSurfaceFormat format;
    format.setAlphaBufferSize(8);
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);
    
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    
    // Register icon provider for freedesktop icons
    engine.addImageProvider("icon", new IconProvider());
    
    // =========================================================================
    // REGISTER C++ MODELS AND CONTROLLERS
    // =========================================================================
    
    // Category model for the main Hub grid
    AppCategoryModel categoryModel;
    context->setContextProperty("appCategoryModel", &categoryModel);
    
    // App list model for browser/office/etc categories
    AppListModel browserModel;
    browserModel.loadFromCategory("browsers");
    context->setContextProperty("browserAppsModel", &browserModel);
    
    AppListModel officeModel;
    officeModel.loadFromCategory("office");
    context->setContextProperty("officeAppsModel", &officeModel);
    
    AppListModel multimediaModel;
    multimediaModel.loadFromCategory("multimedia");
    context->setContextProperty("multimediaAppsModel", &multimediaModel);
    
    AppListModel securityModel;
    securityModel.loadFromCategory("security");
    context->setContextProperty("securityAppsModel", &securityModel);
    
    // Theme controller for light/dark/auto modes
    ThemeController themeController;
    context->setContextProperty("themeController", &themeController);
    
    // System controller for running scripts, checking installed apps
    SystemController systemController;
    context->setContextProperty("systemController", &systemController);
    
    // =========================================================================
    // EXPOSE USEFUL PATH CONSTANTS
    // =========================================================================
    
    context->setContextProperty("configPath", 
        QStandardPaths::writableLocation(QStandardPaths::ConfigLocation));
    context->setContextProperty("dataPath", 
        QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    
    // =========================================================================
    // LOAD QML
    // =========================================================================
    
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    
    engine.load(url);
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    // Apply translucent window hint after loading
    QQuickWindow *window = qobject_cast<QQuickWindow*>(engine.rootObjects().first());
    if (window) {
        window->setColor(Qt::transparent);
        // Request KWin blur (works on KDE Plasma with compositing)
        // This is done via X11/Wayland protocols in the QML side
    }
    
    return app.exec();
}
