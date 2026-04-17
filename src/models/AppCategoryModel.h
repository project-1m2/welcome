/**
 * AppCategoryModel - Model for main Hub category cards
 * 
 * Provides data for the glassmorphic category cards in the Hub screen.
 * Each category has an icon, title, description, and target screen.
 */

#ifndef APPCATEGORYMODEL_H
#define APPCATEGORYMODEL_H

#include <QAbstractListModel>
#include <QVector>

struct AppCategory {
    QString id;
    QString title;
    QString description;
    QString iconName;
    QString targetScreen;
};

class AppCategoryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        DescriptionRole,
        IconNameRole,
        TargetScreenRole
    };

    explicit AppCategoryModel(QObject *parent = nullptr);

    // QAbstractListModel interface
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    void populateData();
    QVector<AppCategory> m_categories;
};

#endif // APPCATEGORYMODEL_H
