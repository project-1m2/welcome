/**
 * ThemeController - Manages KDE Plasma theme switching
 * 
 * Handles light/dark/auto theme modes with proper KDE integration.
 */

#ifndef THEMECONTROLLER_H
#define THEMECONTROLLER_H

#include <QObject>
#include <QSettings>

class ThemeController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentTheme READ currentTheme WRITE setCurrentTheme NOTIFY currentThemeChanged)
    Q_PROPERTY(QString currentColorScheme READ currentColorScheme NOTIFY currentThemeChanged)
    Q_PROPERTY(bool isDarkMode READ isDarkMode NOTIFY currentThemeChanged)

public:
    explicit ThemeController(QObject *parent = nullptr);

    enum ThemeMode {
        Light,
        Dark,
        Auto
    };
    Q_ENUM(ThemeMode)

    QString currentTheme() const { return m_currentTheme; }
    QString currentColorScheme() const;
    bool isDarkMode() const;

    Q_INVOKABLE void setCurrentTheme(const QString &theme);
    Q_INVOKABLE void applyTheme(const QString &themeName);
    Q_INVOKABLE void applyColorScheme(const QString &schemeName);
    Q_INVOKABLE void openSystemSettings();

signals:
    void currentThemeChanged();

private:
    void loadCurrentTheme();
    void saveConfiguration();
    
    QString m_currentTheme;
    QSettings m_settings;
};

#endif // THEMECONTROLLER_H
