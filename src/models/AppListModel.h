/**
 * AppListModel - Model for application lists within categories
 * 
 * Provides data for app list items (browsers, office suites, etc.)
 * Each app has metadata and installation status checked dynamically.
 */

#ifndef APPLISTMODEL_H
#define APPLISTMODEL_H

#include <QAbstractListModel>
#include <QVector>

struct AppItem {
    QString id;
    QString name;
    QString description;
    QString iconName;
    QString installScript;
    QString removeScript;
    QString checkCommand;      // Command to check if installed (e.g., "which firefox")
    bool isInstalled = false;
    bool isInstalling = false;
};

class AppListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString category READ category NOTIFY categoryChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        DescriptionRole,
        IconNameRole,
        InstallScriptRole,
        RemoveScriptRole,
        IsInstalledRole,
        IsInstallingRole
    };

    explicit AppListModel(QObject *parent = nullptr);

    // Load apps for a specific category
    Q_INVOKABLE void loadFromCategory(const QString &categoryId);
    
    // Check and update installation status for all apps
    Q_INVOKABLE void refreshInstallStatus();
    
    // Mark an app as installing/not installing
    Q_INVOKABLE void setInstalling(int index, bool installing);
    
    // Update installed status after script finishes
    Q_INVOKABLE void updateInstalledStatus(int index, bool installed);

    // QAbstractListModel interface
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    
    QString category() const { return m_category; }

signals:
    void categoryChanged();

private:
    void loadBrowsers();
    void loadOfficeApps();
    void loadMultimedia();
    void loadSecurity();
    bool checkIfInstalled(const QString &checkCommand);
    
    QString m_category;
    QVector<AppItem> m_apps;
};

#endif // APPLISTMODEL_H
