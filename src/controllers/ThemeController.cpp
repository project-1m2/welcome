/**
 * ThemeController implementation
 */

#include "ThemeController.h"
#include <QProcess>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

ThemeController::ThemeController(QObject *parent)
    : QObject(parent)
    , m_settings(QSettings::IniFormat, QSettings::UserScope, "TigerOS", "Welcome")
{
    loadCurrentTheme();
}

void ThemeController::loadCurrentTheme()
{
    // Try to detect current KDE color scheme
    QString kdeConfigPath = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) 
                            + "/kdeglobals";
    
    QSettings kdeSettings(kdeConfigPath, QSettings::IniFormat);
    QString colorScheme = kdeSettings.value("General/ColorScheme", "BreezeLight").toString();
    
    if (colorScheme.contains("Dark", Qt::CaseInsensitive)) {
        m_currentTheme = "dark";
    } else {
        m_currentTheme = "light";
    }
    
    // Check for auto mode preference
    QString savedMode = m_settings.value("theme/mode", "").toString();
    if (savedMode == "auto") {
        m_currentTheme = "auto";
    }
}

QString ThemeController::currentColorScheme() const
{
    return isDarkMode() ? "BreezeDark" : "BreezeLight";
}

bool ThemeController::isDarkMode() const
{
    if (m_currentTheme == "dark") {
        return true;
    } else if (m_currentTheme == "auto") {
        // Check system time for auto mode (simple day/night)
        QTime currentTime = QTime::currentTime();
        return currentTime.hour() < 6 || currentTime.hour() >= 18;
    }
    return false;
}

void ThemeController::setCurrentTheme(const QString &theme)
{
    if (m_currentTheme == theme)
        return;
    
    m_currentTheme = theme;
    saveConfiguration();
    
    // Apply the theme immediately
    if (theme == "light") {
        applyColorScheme("BreezeLight");
    } else if (theme == "dark") {
        applyColorScheme("BreezeDark");
    }
    // For auto, let the system handle it or use a timer
    
    emit currentThemeChanged();
}

void ThemeController::applyTheme(const QString &themeName)
{
    // Apply Plasma desktop theme using plasma-apply-desktoptheme
    QProcess process;
    process.start("plasma-apply-desktoptheme", QStringList() << themeName);
    process.waitForFinished(5000);
}

void ThemeController::applyColorScheme(const QString &schemeName)
{
    // Apply color scheme using plasma-apply-colorscheme
    QProcess process;
    process.start("plasma-apply-colorscheme", QStringList() << schemeName);
    process.waitForFinished(5000);
}

void ThemeController::openSystemSettings()
{
    QProcess::startDetached("systemsettings5", QStringList() << "kcm_colors");
}

void ThemeController::saveConfiguration()
{
    m_settings.setValue("theme/mode", m_currentTheme);
    m_settings.sync();
}
