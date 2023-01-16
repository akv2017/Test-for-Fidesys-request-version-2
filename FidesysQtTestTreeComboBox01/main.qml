import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 1.6 as C1_6
import QtQuick.Controls 2.14
import QtQuick.Controls 1.4 as C1_4
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 640
    height: 420
    title: qsTr("Fidesys Qt test")
    font.pointSize: 16

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0

        TreeComboBox {
            Layout.alignment: Qt.AlignTop
            applicationMainWindow: applicationWindow
            treemodel: treeModel
        }
    }
}
