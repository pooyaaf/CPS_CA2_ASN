pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtSensors

ApplicationWindow {
    id: root

    readonly property int defaultFontSize: 22
    readonly property int imageSize: width / 2

    property var path: []

    visible: true
    width: 400
    height: 300
    title: "Motion Based Auth"

    header : ToolBar {
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
            Item {
                visible: back.visible
                Layout.preferredWidth: back.width
            }
        }
    }
    // Reset
    function resetButton() {
        // Reset gyroscope values
        gyroscope.x = 0
        gyroscope.y = 0
        gyroscope.z = 0
        gyroscope.lastTimeStamp = 0
        gyroscope.underThrCount = 0

        // Reset accelerometer values
        accelerometer.x = 0
        accelerometer.y = 0
        accelerometer.z = 0
        accelerometer.lastTimeStamp = 0
        accelerometer.vx = 0
        accelerometer.vy = 0
        accelerometer.vz = 0
        accelerometer.underThrCount = 0

        // Reset rotation values
        rotation.rx = 0
        rotation.ry = 0
        rotation.rz = 0

        // Reset position values
        position.px = 0
        position.py = 0
        position.pz = 0
    }

    // Main page content
    StackView {
        id: stack

        anchors.fill: parent
        anchors.margins: width / 12

        initialItem: Item {
            ColumnLayout {
                id: initialItem

                anchors.fill: parent
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                spacing: 5

                Gyroscope {
                    id: gyroscope

                    property real lastTimeStamp: 0
                    property real x: 0
                    property real y: 0
                    property real z: 0

                    property int underThrCount: 0

                    active: true
                    dataRate: 20

                    onReadingChanged: {
                        x = (reading as GyroscopeReading).x
                        y = (reading as GyroscopeReading).y
                        z = (reading as GyroscopeReading).z

                        let firstCall = false
                        if (lastTimeStamp == 0) {
                            firstCall = true
                        }
                        let newLast = reading.timestamp
                        let timeSinceLast = (newLast - lastTimeStamp) / 1000000
                        lastTimeStamp = newLast

                        if (firstCall === true)
                            return

                        let thr = 4

                        if ((x <= thr && x >= -thr) && (y <= thr && y >= -thr) && (z <= thr && z >= -thr)) {
                            underThrCount += 1
                        } else {
                            underThrCount = 0
                        }

                        if (underThrCount === 4) {
                            console.log("2")
                        }

                        rotation.rx += (x > thr || x < -thr) ? (x * timeSinceLast) : 0
                        rotation.ry += (y > thr || y < -thr) ? (y * timeSinceLast) : 0
                        rotation.rz += (z > thr || z < -thr) ? (z * timeSinceLast) : 0
                    }
                }

                Accelerometer {
                    id: accelerometer

                    property real lastTimeStamp: 0
                    property real x: 0
                    property real y: 0
                    property real z: 0

                    property real vx: 0
                    property real vy: 0
                    property real vz: 0

                    property real bx: 0
                    property real by: 0
                    property real bz: 9.8

                    property int underThrCount: 0

                    active: true
                    dataRate: 100

                    onReadingChanged: {
                        x = (reading as AccelerometerReading).x
                        y = (reading as AccelerometerReading).y
                        z = (reading as AccelerometerReading).z

                        // console.log(vx, vy, vz)

                        let dx = x - bx
                        let dy = y - by
                        let dz = z - bz

                        let firstCall = false
                        if (lastTimeStamp == 0) {
                            firstCall = true
                        }
                        let newLast = reading.timestamp
                        let timeSinceLast = (newLast - lastTimeStamp) / 1000000
                        lastTimeStamp = newLast

                        if (firstCall === true)
                            return

                        let thr = 0.5

                        if ((dx <= thr && dx >= -thr) && (dy <= thr && dy >= -thr) && (dz <= thr && dz >= -thr)) {
                            underThrCount += 1
                        } else {
                            underThrCount = 0
                        }

                        if (underThrCount === 20) {
                            console.log("25")
                            vx = 0
                            vy = 0
                            vz = 0
                        }

                        vx += (dx > thr || dx < -thr) ? (dx * timeSinceLast) : 0
                        vy += (dy > thr || dy < -thr) ? (dy * timeSinceLast) : 0
                        vz += (dz > thr || dz < -thr) ? (dz * timeSinceLast) : 0

                        position.px += vx * timeSinceLast * 100
                        position.py += vy * timeSinceLast * 100
                        position.pz += vz * timeSinceLast * 100
                    }
                }

                    component NamedProgressBar: ColumnLayout {
                    property alias text: axes.text
                    property alias value: bar.value
                    Text {
                        id: axes
                        font.pixelSize: root.defaultFontSize
                        Layout.fillWidth: true
                    }
                    ProgressBar {
                        id: bar
                        Layout.fillWidth: true
                    }
                }


                ColumnLayout {
                    id: rotation
                    spacing: 0
                    Layout.fillWidth: true
                    Layout.topMargin: 20

                    property real rx: 0
                    property real ry: 0
                    property real rz: 0

                    xText: "Rotation(X): " + rx.toFixed(2)
                    xValue: 0.5 + (rx / 360)
                    yText: "Rotation(Y): " + ry.toFixed(2)
                    yValue: 0.5 + (ry / 360)
                    zText: "Rotation(Z): " + rz.toFixed(2)
                    zValue: 0.5 + (rz / 360)

                    property alias xText: xBar.text
                    property alias xValue: xBar.value
                    property alias yText: yBar.text
                    property alias yValue: yBar.value
                    property alias zText: zBar.text
                    property alias zValue: zBar.value

                    NamedProgressBar {
                        id: xBar
                    }

                    NamedProgressBar {
                        id: yBar
                    }

                    NamedProgressBar {
                        id: zBar
                    }
                }


                ColumnLayout {
                    id: position
                    spacing: 0
                    Layout.fillWidth: true
                    Layout.topMargin: 20

                    property real px: 0
                    property real py: 0
                    property real pz: 0

                    xText: "Position(X): " + px.toFixed(2)
                    xValue: 0.5 + (px / 100)
                    yText: "Position(Y): " + py.toFixed(2)
                    yValue: 0.5 + (py / 100)
                    zText: "Position(Z): " + pz.toFixed(2)
                    zValue: 0.5 + (pz / 100)

                    property alias xText: xPar.text
                    property alias xValue: xPar.value
                    property alias yText: yPar.text
                    property alias yValue: yPar.value
                    property alias zText: zPar.text
                    property alias zValue: zPar.value

                    NamedProgressBar {
                        id: xPar
                    }

                    NamedProgressBar {
                        id: yPar
                    }

                    NamedProgressBar {
                        id: zPar
                    }
                }

                Button {
                    text: "Start Recording"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                }

                Button {
                    text: "Authenticate"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                }

                Button {
                    text: "Validate"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                }

                Button {
                    text: "Reset"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    onClicked: root.resetButton()
                }
            }
        }
    }


}
