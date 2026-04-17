/**
 * AppCategoryModel implementation
 */

#include "AppCategoryModel.h"

AppCategoryModel::AppCategoryModel(QObject *parent)
    : QAbstractListModel(parent)
{
    populateData();
}

void AppCategoryModel::populateData()
{
    beginResetModel();
    m_categories.clear();
    
    m_categories.append({
        "first-steps",
        tr("Primeiros Passos"),
        tr("Verificar atualizações"),
        "checkmark-circle",
        "FirstStepsScreen"
    });
    
    m_categories.append({
        "customize",
        tr("Personalizar"),
        tr("Mudar temas e ícones"),
        "preferences-desktop-theme",
        "CustomizeScreen"
    });
    
    m_categories.append({
        "apps",
        tr("Descobrir Apps"),
        tr("Instalar programas"),
        "applications-other",
        "AppsScreen"
    });
    
    m_categories.append({
        "community",
        tr("Comunidade"),
        tr("Obter ajuda"),
        "system-users",
        "CommunityScreen"
    });
    
    endResetModel();
}

int AppCategoryModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_categories.count();
}

QVariant AppCategoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_categories.count())
        return QVariant();
    
    const AppCategory &category = m_categories.at(index.row());
    
    switch (role) {
        case IdRole:
            return category.id;
        case TitleRole:
            return category.title;
        case DescriptionRole:
            return category.description;
        case IconNameRole:
            return category.iconName;
        case TargetScreenRole:
            return category.targetScreen;
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> AppCategoryModel::roleNames() const
{
    return {
        {IdRole, "categoryId"},
        {TitleRole, "title"},
        {DescriptionRole, "description"},
        {IconNameRole, "iconName"},
        {TargetScreenRole, "targetScreen"}
    };
}
