#include "modelfiller.h"

QStandardItem* ModelFiller::addTreeComboBoxModelItem(const QString &itemName
                                                     , QStandardItemModel* amodel
                                                     , const QModelIndex &parentIndex)
{
    if(nullptr == amodel) return nullptr;

    QStandardItem *createdChildItem(nullptr);
    if(0 == amodel->columnCount(parentIndex)) {
        if(!amodel->insertColumn(0, parentIndex)) return createdChildItem;
    }
    int rowIndex = amodel->rowCount(parentIndex);
    if(!amodel->insertRow(rowIndex, parentIndex)) return createdChildItem;

    QModelIndex createdChildItemIndex = amodel->index(rowIndex, 0, parentIndex);
    if(!createdChildItemIndex.isValid()) return createdChildItem;

    createdChildItem = amodel->itemFromIndex(createdChildItemIndex);
    if(nullptr == createdChildItem) return createdChildItem;

    const QString itemNameTrimmed(itemName.trimmed());
    createdChildItem->setText(itemNameTrimmed);
    return createdChildItem;
}

QStandardItem* ModelFiller::addTreeComboBoxModelItem(QStandardItemModel* amodel
                                                     , const QModelIndex &parentIndex)
{
    if(nullptr == amodel) return nullptr;

    static QString treeComboBoxModelItemNamePrefixDefault(QObject::tr(TREECOMBOBOX_MODEL_ITEM_NAME_PREFIX_LITERAL_DEFAULT));
    static const QString treeComboBoxDot(TREECOMBOBOX_LITERAL_DOT);
    static const QString treeComboBoxSpace(TREECOMBOBOX_LITERAL_SPACE);

    QStandardItem *parentItem = amodel->itemFromIndex(parentIndex);
    if(nullptr == parentItem) parentItem = amodel->invisibleRootItem();
    if(nullptr == parentItem) return nullptr;//TODO: handle error of creating item
    QString itemName(parentItem->text());
    if(itemName.isEmpty())
    {
        itemName.append(treeComboBoxModelItemNamePrefixDefault).append(treeComboBoxSpace);
    }
    else {
        itemName.append(treeComboBoxDot);
    }
    itemName.append(QString("%0").arg(parentItem->rowCount() + 1));
    return addTreeComboBoxModelItem(itemName, amodel, parentIndex);
}

Q_INVOKABLE void ModelFiller::modelFill()
{
    //TODO: The code below for demonstrative purposes only.

    QStandardItem *item(nullptr);
    QStandardItem *rootItem = m_managedModel->invisibleRootItem();
    QStandardItem *parentItem(rootItem);
    QModelIndex rootIndex = m_managedModel->indexFromItem(rootItem);

    item = addTreeComboBoxModelItem(m_managedModel, rootIndex);
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, rootIndex);
    if(nullptr == item) return;
    parentItem = item;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    parentItem = item;
    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, rootIndex);
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    parentItem = item;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());

    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, rootIndex);
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    parentItem = item;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, parentItem->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, rootIndex);
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;

    item = addTreeComboBoxModelItem(m_managedModel, rootIndex);
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
    if(nullptr == item) return;
    item = addTreeComboBoxModelItem(m_managedModel, item->index());
}

