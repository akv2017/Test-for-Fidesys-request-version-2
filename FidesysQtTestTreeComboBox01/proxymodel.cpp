#include "proxymodel.h"
#include <QStandardItemModel>

ProxyModel::ProxyModel(QObject *parent)
    : QIdentityProxyModel(parent)
{

}

Q_INVOKABLE QModelIndex ProxyModel::indexFrom(int row, const QModelIndex &parent, const QModelIndex &modelContainer)
{
    return ((nullptr == parent.model())?((nullptr == modelContainer.model())?QModelIndex():modelContainer.model()->index(row, 0, parent)):parent.model()->index(row, 0, parent));
}

Q_SLOT void ProxyModel::onSourceModelChanged()
{
    emit totalItemCountChanged(getItemRowCountRecursive());
}

Q_SLOT int ProxyModel::getItemRowCountRecursive(QModelIndex itemIndex) const
{
    if(nullptr == sourceModel()) return 0;
    QStandardItemModel* sourceItemModel(qobject_cast<QStandardItemModel*>(sourceModel()));
    QModelIndex childItemIndex;
    int itemRowCount(sourceItemModel->rowCount(itemIndex));
    int totalRowCount(itemRowCount);
    int i(0);
    for(; i < itemRowCount; ++i) {
        childItemIndex = sourceItemModel->index(i, 0, itemIndex);
        totalRowCount += getItemRowCountRecursive(childItemIndex);
    }
    return totalRowCount;
}

Q_INVOKABLE bool ProxyModel::hasChildren(const QModelIndex &parent) const
{
    return (qobject_cast<QStandardItemModel*>(sourceModel()))->hasChildren(parent);
}

Q_INVOKABLE QVariant ProxyModel::data(const QModelIndex &proxyIndex, int role) const
{
    return (qobject_cast<QStandardItemModel*>(sourceModel()))->data(proxyIndex, role);
}

Q_INVOKABLE QModelIndex ProxyModel::index(int row, int column, const QModelIndex &parent) const
{
    return (qobject_cast<QStandardItemModel*>(sourceModel()))->index(row, column, parent);
}

Q_INVOKABLE QModelIndex ProxyModel::index(int row, const QModelIndex &parent) const
{
    return (qobject_cast<QStandardItemModel*>(sourceModel()))->index(row, 0, parent);
}

Q_INVOKABLE QModelIndex ProxyModel::parent(const QModelIndex &child) const
{
    return (qobject_cast<QStandardItemModel*>(sourceModel()))->parent(child);
}

Q_INVOKABLE int ProxyModel::rowCount(const QModelIndex &parent) const
{
    return (qobject_cast<QStandardItemModel*>(sourceModel()))->rowCount(parent);
}


