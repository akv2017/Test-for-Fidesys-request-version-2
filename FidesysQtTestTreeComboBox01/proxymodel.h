#ifndef PROXYMODEL_H
#define PROXYMODEL_H

#include <QIdentityProxyModel>

class ProxyModel : public QIdentityProxyModel
{
    Q_OBJECT
public:
    ProxyModel(QObject *parent = nullptr);

    Q_PROPERTY(int totalItemCount READ getItemRowCountRecursive NOTIFY totalItemCountChanged)

    Q_INVOKABLE bool hasChildren(const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE QVariant data(const QModelIndex &proxyIndex, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE QModelIndex index(int row, const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE QModelIndex parent(const QModelIndex &child) const override;
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    Q_INVOKABLE static QModelIndex indexFrom(int row, const QModelIndex &parent, const QModelIndex &modelContainer = QModelIndex());

public Q_SLOTS:
    int getItemRowCountRecursive(QModelIndex itemIndex = QModelIndex()) const;
    void onSourceModelChanged();

signals:
    void totalItemCountChanged(int count);

private:

};

#endif // PROXYMODEL_H
