/**
 * AppListModel implementation
 */

#include "AppListModel.h"
#include <QProcess>
#include <QStandardPaths>

AppListModel::AppListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

void AppListModel::loadFromCategory(const QString &categoryId)
{
    beginResetModel();
    m_apps.clear();
    m_category = categoryId;
    
    if (categoryId == "browsers") {
        loadBrowsers();
    } else if (categoryId == "office") {
        loadOfficeApps();
    } else if (categoryId == "multimedia") {
        loadMultimedia();
    } else if (categoryId == "security") {
        loadSecurity();
    }
    
    // Check installation status for all apps
    refreshInstallStatus();
    
    endResetModel();
    emit categoryChanged();
}

void AppListModel::loadBrowsers()
{
    m_apps.append({
        "firefox",
        "Mozilla Firefox",
        tr("Rápido, privado e seguro."),
        "firefox",
        ":/Scripts/navegadores/firefox.sh",
        "",
        "which firefox"
    });
    
    m_apps.append({
        "chrome",
        "Google Chrome",
        tr("O navegador mais popular."),
        "google-chrome",
        ":/Scripts/navegadores/chrome.sh",
        "",
        "which google-chrome-stable"
    });
    
    m_apps.append({
        "brave",
        "Brave",
        tr("Privacidade em primeiro lugar."),
        "brave-browser",
        ":/Scripts/navegadores/brave.sh",
        "",
        "which brave-browser"
    });
    
    m_apps.append({
        "edge",
        "Microsoft Edge",
        tr("Navegador da Microsoft."),
        "microsoft-edge",
        ":/Scripts/navegadores/edge.sh",
        "",
        "which microsoft-edge-stable"
    });
    
    m_apps.append({
        "opera",
        "Opera",
        tr("Navegador com VPN integrada."),
        "opera",
        ":/Scripts/navegadores/opera.sh",
        "",
        "which opera"
    });
    
    m_apps.append({
        "vivaldi",
        "Vivaldi",
        tr("Altamente personalizável."),
        "vivaldi",
        "",
        "",
        "which vivaldi-stable"
    });
}

void AppListModel::loadOfficeApps()
{
    m_apps.append({
        "libreoffice",
        "LibreOffice",
        tr("Suite office livre e completa."),
        "libreoffice-startcenter",
        ":/Scripts/office/libreoffice.sh",
        "",
        "which libreoffice"
    });
    
    m_apps.append({
        "onlyoffice",
        "OnlyOffice",
        tr("Compatível com Microsoft Office."),
        "onlyoffice-desktopeditors",
        "",
        "",
        "which onlyoffice-desktopeditors"
    });
    
    m_apps.append({
        "wps",
        "WPS Office",
        tr("Interface similar ao MS Office."),
        "wps-office2019-kprometheus",
        ":/Scripts/office/wps.sh",
        "",
        "which wps"
    });
    
    m_apps.append({
        "office365",
        "Office 365 (Web)",
        tr("Microsoft Office online."),
        "ms-office",
        ":/Scripts/office/office365.sh",
        "",
        ""  // Web app, always "installable"
    });
}

void AppListModel::loadMultimedia()
{
    m_apps.append({
        "vlc",
        "VLC Media Player",
        tr("Reproduz qualquer formato."),
        "vlc",
        "",
        "",
        "which vlc"
    });
    
    m_apps.append({
        "spotify",
        "Spotify",
        tr("Streaming de música."),
        "spotify-client",
        "",
        "",
        "which spotify"
    });
    
    m_apps.append({
        "gimp",
        "GIMP",
        tr("Editor de imagens profissional."),
        "gimp",
        "",
        "",
        "which gimp"
    });
    
    m_apps.append({
        "kdenlive",
        "Kdenlive",
        tr("Editor de vídeo poderoso."),
        "kdenlive",
        "",
        "",
        "which kdenlive"
    });
}

void AppListModel::loadSecurity()
{
    m_apps.append({
        "keepassxc",
        "KeePassXC",
        tr("Gerenciador de senhas seguro."),
        "keepassxc",
        "",
        "",
        "which keepassxc"
    });
    
    m_apps.append({
        "bitwarden",
        "Bitwarden",
        tr("Senhas na nuvem."),
        "bitwarden",
        "",
        "",
        "which bitwarden"
    });
}

void AppListModel::refreshInstallStatus()
{
    for (int i = 0; i < m_apps.count(); ++i) {
        AppItem &app = m_apps[i];
        if (!app.checkCommand.isEmpty()) {
            app.isInstalled = checkIfInstalled(app.checkCommand);
        }
    }
}

bool AppListModel::checkIfInstalled(const QString &checkCommand)
{
    if (checkCommand.isEmpty())
        return false;
    
    QProcess process;
    process.start("/bin/sh", QStringList() << "-c" << checkCommand);
    process.waitForFinished(3000);
    
    return process.exitCode() == 0;
}

void AppListModel::setInstalling(int index, bool installing)
{
    if (index < 0 || index >= m_apps.count())
        return;
    
    m_apps[index].isInstalling = installing;
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {IsInstallingRole});
}

void AppListModel::updateInstalledStatus(int index, bool installed)
{
    if (index < 0 || index >= m_apps.count())
        return;
    
    m_apps[index].isInstalled = installed;
    m_apps[index].isInstalling = false;
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), 
                     {IsInstalledRole, IsInstallingRole});
}

int AppListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_apps.count();
}

QVariant AppListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_apps.count())
        return QVariant();
    
    const AppItem &app = m_apps.at(index.row());
    
    switch (role) {
        case IdRole:
            return app.id;
        case NameRole:
            return app.name;
        case DescriptionRole:
            return app.description;
        case IconNameRole:
            return app.iconName;
        case InstallScriptRole:
            return app.installScript;
        case RemoveScriptRole:
            return app.removeScript;
        case IsInstalledRole:
            return app.isInstalled;
        case IsInstallingRole:
            return app.isInstalling;
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> AppListModel::roleNames() const
{
    return {
        {IdRole, "appId"},
        {NameRole, "name"},
        {DescriptionRole, "description"},
        {IconNameRole, "iconName"},
        {InstallScriptRole, "installScript"},
        {RemoveScriptRole, "removeScript"},
        {IsInstalledRole, "isInstalled"},
        {IsInstallingRole, "isInstalling"}
    };
}
