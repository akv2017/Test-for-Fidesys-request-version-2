import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQml 2.14
import QtQml.Models 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 1.6 as C1_6
import QtQuick.Controls 2.14
import QtQuick.Controls 1.4 as C1_4
import QtQuick.Controls.Styles 1.4

ComboBox {
    id: root
    Layout.fillWidth: true

    model: []//This is stub. For model use property treemodel
    property alias treemodel: treeViewComboBoxPopup.model
    onModelChanged: model = []

    implicitHeight: treeViewComboBoxPopup.implicitItemHeight
    displayText: treeViewComboBoxPopup.getItemNameFullPath()
    currentIndex: currentModelIndex.row

    property var applicationMainWindow: null
    property alias currentModelIndex: treeViewComboBoxPopup.currentModelIndex
    property real applicationWindowX: applicationMainWindow.x
    property real applicationWindowY: applicationMainWindow.y
    onApplicationWindowXChanged: if(comboBoxPopup.visible) comboBoxPopup.positionFromRoot()
    onApplicationWindowYChanged: if(comboBoxPopup.visible) comboBoxPopup.positionFromRoot()

    popup.onOpenedChanged: {
        if(0 < displayText.length && popup.opened) comboBoxPopup.show()
    }
    popup.onAboutToShow: {
        comboBoxPopup.positionFromRoot()
    }

    Window {
        id: comboBoxPopup
        x: popupPosition.x
        y: popupPosition.y
        width: root.width
        flags: Qt.FramelessWindowHint

        property var popupPosition: ({"x":0,"y":0})
        property alias popupMinimumHeight: treeViewComboBoxPopup.treeViewPopupMinimumHeight
        property alias popupMaximumHeight: treeViewComboBoxPopup.treeViewPopupMaximumHeight
        property alias popupImplicitItemHeightMinimum: treeViewComboBoxPopup.implicitItemHeightMinimum
        property alias popupConstantHeightExtent: treeViewComboBoxPopup.implicitItemHeightExtentConstant
        property alias fontBoundingRectWidthExtentConstant: treeViewComboBoxPopup.fontBoundingRectWidthExtentConstant
        onVisibleChanged: {
            treeViewComboBoxPopup.expandAll()
        }
        function positionFromRoot() {
            let localPosition = root.mapToGlobal(root.x, root.y + root.height - 1)
            comboBoxPopup.popupPosition = localPosition
        }

        ColumnLayout {
            id: columnLayoutTreeViewComboBoxPopup
            anchors.fill: parent
            C1_6.TreeView {
                id: treeViewComboBoxPopup
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true
                alternatingRowColors: false
                selectionMode: C1_6.SelectionMode.SingleSelection
                headerVisible: false

                readonly property string treeComboBoxDisplayStringSeparator: " - "
                readonly property string arrowBlackTrianglePointingDown: "\u25BC"
                readonly property string arrowBlackTrianglePointingRight: "\u25B6"

                property var emptyModelIndex: rootIndex
                property var currentModelIndex: emptyModelIndex
                property alias modelAdaptor: treeViewComboBoxPopup.__model
                property alias innerListView: treeViewComboBoxPopup.__listView

                property int treeViewPopupMaximumHeight: (400 - 16)
                property int treeViewPopupMinimumHeight: (300 - 16)
                property int implicitItemHeight: treeViewComboBoxPopup.implicitItemHeightCalculation()
                property int fontBoundingRectWidthMaximum: (treeViewComboBoxPopup.width - 16)
                property int fontBoundingRectWidthExtentConstant: 8
                property int implicitItemHeightMinimum: 18
                property int implicitItemHeightExtentConstant: 2
                property var branchDecorationTextColor: undefined

                C1_6.TableViewColumn {
                    title: "Info"
                    role: "display"
                    width: treeViewComboBoxPopup.fontBoundingRectWidthMaximum
                    movable: false
                }

                selection: ItemSelectionModel {
                     model: treeViewComboBoxPopup.model
                     onModelChanged: {
                         treeViewComboBoxPopup.itemSelectionInit()
                     }
                }
                style: TreeViewStyle {
                    branchDelegate: Text {
                        text: styleData.isExpanded?treeViewComboBoxPopup.arrowBlackTrianglePointingRight:treeViewComboBoxPopup.arrowBlackTrianglePointingDown
                        color: 'black'
                    }
                }
                itemDelegate: Item {
                    Rectangle {
                        implicitHeight: treeViewComboBoxPopup.implicitItemHeight
                        height: implicitHeight
                        width: treeViewComboBoxPopup.fontBoundingRectWidthCalculation(styleData.value)
                        color: getItemDelegateBackgroundColor()
                        function getItemDelegateBackgroundColor() {
                            let localColor = 'whitesmoke'
                            if(treeViewComboBoxPopup.focus) {
                                if(styleData.selected) {
                                    let modelItemIndex = treeViewComboBoxPopup.modelAdaptor.mapRowToModelIndex(styleData.row)
                                    if(undefined !== modelItemIndex
                                            && null !== treeViewComboBoxPopup.model
                                            && treeViewComboBoxPopup.model.hasChildren(modelItemIndex)) {
                                        localColor = 'lightsteelblue'
                                    } else {
                                        localColor = Qt.darker('darkslateblue', 1.5)
                                    }
                                }
                            } else {
                                if(styleData.selected) localColor = 'grey'
                            }
                            return localColor
                        }
                    }
                    Text {
                        text: styleData.value
                        color: styleData.textColor
                        font.pointSize: root.font.pointSize
                        leftPadding: ((4 < treeViewComboBoxPopup.fontBoundingRectWidthExtentConstant)?4:(treeViewComboBoxPopup.fontBoundingRectWidthExtentConstant/2))
                    }
                }
                rowDelegate: Rectangle {
                    color: rowDelegateBackgroundColor()
                    function rowDelegateBackgroundColor() {
                        let localColor = 'whitesmoke'
                        return localColor
                    }
                    implicitHeight: treeViewComboBoxPopup.implicitItemHeight
                    height: implicitHeight
                }

                flickableItem.onHeightChanged: {
                    treeViewComboBoxPopup.flickableItemOnHeightChangedHandler()
                }
                function flickableItemOnHeightChangedHandler() {
                    let calculatedHeight = treeViewComboBoxPopup.flickableItem.height
                    if(treeViewComboBoxPopup.treeViewPopupMinimumHeight > calculatedHeight) calculatedHeight = treeViewComboBoxPopup.treeViewPopupMinimumHeight
                    calculatedHeight = ((treeViewComboBoxPopup.treeViewPopupMaximumHeight < calculatedHeight)?treeViewComboBoxPopup.treeViewPopupMaximumHeight:calculatedHeight)
                    comboBoxPopup.height = calculatedHeight - 1
                }

                function itemSelectionInit() {
                    treeViewComboBoxPopup.expandAll()
                    if(!!treeViewComboBoxPopup.selection
                            && !treeViewComboBoxPopup.selection.hasSelection) {
                        let itemModelIndex = getFirstSelectableItemModelIndex()
                        if(itemModelIndex.valid) {
                            selectItem(itemModelIndex)
                        }
                    }
                }
                onModelChanged: {
                    expandAll()
                    itemSelectionInit()
                }
                onCurrentIndexChanged: onCurrentIndexChangedHandler()
                function onCurrentIndexChangedHandler() {
                    if(null === treeViewComboBoxPopup.model) return
                    let modelItemIndex = treeViewComboBoxPopup.currentIndex
                    if(!modelItemIndex.valid) modelItemIndex = treeViewComboBoxPopup.selection.currentIndex
                    if(!modelItemIndex.valid
                            || treeViewComboBoxPopup.model.hasChildren(modelItemIndex)) {
                        return
                    }
                    treeViewComboBoxPopup.currentModelIndex = modelItemIndex
                    if(1 > root.displayText.length || comboBoxPopup.visible) {
                        comboBoxPopup.hide()
                        root.popup.close()
                    }
                }
                function fontBoundingRectWidthCalculation(text) {
                    let tm = Qt.createQmlObject("import QtQuick 2.14;FontMetrics{}", parent)
                    tm.font = font
                    let itemWidth = tm.boundingRect(text).width
                    tm.destroy()
                    itemWidth += treeViewComboBoxPopup.fontBoundingRectWidthExtentConstant
                    return Math.min(itemWidth, treeViewComboBoxPopup.fontBoundingRectWidthMaximum)
                }
                function implicitItemHeightCalculation() {
                    let tm = Qt.createQmlObject("import QtQuick 2.14;FontMetrics{}", parent)
                    tm.font = font
                    let text = "W"
                    let itemHeight = tm.boundingRect(text).height
                    tm.destroy()
                    itemHeight += treeViewComboBoxPopup.implicitItemHeightExtentConstant
                    return Math.max(itemHeight, treeViewComboBoxPopup.implicitItemHeightMinimum)
                }
                function selectItem(itemModelIndex) {
                    if(!itemModelIndex.valid) {
                        if(!!treeViewComboBoxPopup.selection) treeViewComboBoxPopup.selection.clear()
                        return
                    }
                    if(!!treeViewComboBoxPopup.selection) {
                        treeViewComboBoxPopup.selection.setCurrentIndex(itemModelIndex, ItemSelectionModel.ClearAndSelect)
                    }
                }
                function getFirstSelectableItemModelIndex(argumentParentItemIndex = treeViewComboBoxPopup.rootIndex)
                {
                    if(!viewCompletedCheck()) return treeViewComboBoxPopup.emptyModelIndex
                    if(!treeViewComboBoxPopup.model.hasChildren(argumentParentItemIndex)) return argumentParentItemIndex

                    let rowIndex = 0
                    let itemIndex = treeViewComboBoxPopup.model.index(rowIndex, argumentParentItemIndex)
                    for(++rowIndex; itemIndex.valid; ++rowIndex) {
                        itemIndex = treeViewComboBoxPopup.getFirstSelectableItemModelIndex(itemIndex)
                        if(itemIndex.valid) return itemIndex
                        itemIndex = treeViewComboBoxPopup.model.index(rowIndex, argumentParentItemIndex)
                    }
                    return treeViewComboBoxPopup.emptyModelIndex
                }
                function expand(index) {
                    treeViewComboBoxPopup.modelAdaptor.expand(index)
                }
                function isExpanded(index) {
                    return treeViewComboBoxPopup.modelAdaptor.isExpanded(index)
                }
                function viewCompletedCheck() {
                    return (treeViewComboBoxPopup.Component.completed
                            && (null !== treeViewComboBoxPopup.model)
                            && (undefined !== treeViewComboBoxPopup.model))
                }
                function expandAll() {
                    expandRecursive(treeViewComboBoxPopup.emptyModelIndex)
                }
                function expandRecursive(argumentItemIndex = treeViewComboBoxPopup.emptyModelIndex) {
                    if(!viewCompletedCheck()) return
                    if(!treeViewComboBoxPopup.isExpanded(argumentItemIndex)) {
                        treeViewComboBoxPopup.expand(argumentItemIndex)
                    }
                    let rowIndex = 0
                    let itemIndex = treeViewComboBoxPopup.model.index(rowIndex, argumentItemIndex)
                    for(++rowIndex; itemIndex.valid; ++rowIndex) {
                        treeViewComboBoxPopup.expandRecursive(itemIndex)
                        itemIndex = treeViewComboBoxPopup.model.index(rowIndex, argumentItemIndex)
                    }
                }
                function getItemNameFullPath() {
                    let path = ""
                    if(!treeViewComboBoxPopup.currentModelIndex.valid
                            || !viewCompletedCheck()) return path
                    path = treeViewComboBoxPopup.model.data(treeViewComboBoxPopup.currentModelIndex)
                    let itemModelIndex = treeViewComboBoxPopup.currentModelIndex.parent
                    while (itemModelIndex.valid) {
                        path = treeViewComboBoxPopup.treeComboBoxDisplayStringSeparator + path
                        path = treeViewComboBoxPopup.model.data(itemModelIndex) + path
                        itemModelIndex = itemModelIndex.parent
                    }
                    return path
                }

                onRootIndexChanged: {//Initializing property treeViewComboBoxPopup.emptyModelIndex
                    if(undefined === treeViewComboBoxPopup.emptyModelIndex
                            && undefined !== treeViewComboBoxPopup.rootIndex && !treeViewComboBoxPopup.rootIndex.valid) {
                        let itemModelIndex = rootIndex
                        emptyModelIndex = itemModelIndex
                    }
                }
            }
        }
    }
}


