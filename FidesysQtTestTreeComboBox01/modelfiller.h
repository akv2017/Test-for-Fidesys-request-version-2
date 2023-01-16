#ifndef MODELFILLER_H
#define MODELFILLER_H

#include <QString>
#include <QStandardItemModel>

#define TREECOMBOBOX_EDITLINE_STRING_LITERAL_SEPARATOR " - "
#define TREECOMBOBOX_LITERAL_SPACE " "
#define TREECOMBOBOX_LITERAL_DOT "."
#define TREECOMBOBOX_MODEL_ITEM_NAME_PREFIX_LITERAL_DEFAULT "Item"

class ModelFiller : public QObject
{
    Q_OBJECT
public:
    ModelFiller(QStandardItemModel* amodel = nullptr
            , QObject *parent = nullptr)
        : QObject(parent)
        , m_managedModel(amodel){}

    void setManagedModel(QStandardItemModel* amodel){m_managedModel = amodel;}

    Q_INVOKABLE void modelFill();
    QStandardItem* addTreeComboBoxModelItem(const QString &itemName
                                            , QStandardItemModel* amodel
                                            , const QModelIndex &parentIndex = QModelIndex());
    QStandardItem* addTreeComboBoxModelItem(QStandardItemModel* amodel
                                            , const QModelIndex &parentIndex = QModelIndex());

protected:
    QStandardItemModel* m_managedModel = nullptr;

};

#endif // MODELFILLER_H
