import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtSensors

ToolBar {
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        Label {
            id: heading
            text: root.title
            font.pixelSize: root.defaultFontSize
            font.weight: Font.Medium
            verticalAlignment: Qt.AlignVCenter
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: 55
        }

    }
}
