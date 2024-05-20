pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtSensors
import "."

ApplicationWindow {
    id: root

    readonly property int defaultFontSize: 22
    readonly property int imageSize: width / 2

    property var path: []
    property string lastDir: "top"
    property string lastPosDir: "default"
    property var startPos: ({ "x": 0, "y": 0 })

    visible: true
    width: 400
    height: 300
    title: "Motion Based Auth"

    header: Header {
        id: headerComponent
    }

    // Recording state
    property bool isRecording: false


    function getDirection(degree) {
        // Normalize the degree to a value between 0 and 359
        var normalizedDegree = ((degree % 360) + 360) % 360;

        // Find the closest direction
        if (normalizedDegree >= 315 || normalizedDegree < 45) {
            return "0";
        } else if (normalizedDegree >= 45 && normalizedDegree < 135) {
            return "90";
        } else if (normalizedDegree >= 135 && normalizedDegree < 225) {
            return "180";
        } else if (normalizedDegree >= 225 && normalizedDegree < 315) {
            return "-90";
        } else {
            return "unknown"; // Should not reach here
        }
    }

    function getPositionDir(vx , vy){
        let thrv = 1
        if(vx >= thrv){
            return "right"
        }else if(vx <= -thrv){
            return "left"
        }else if(vy >= thrv){
            return "top"
        }else if(vy <= -thrv){
            return "down"
        }else{
            return "default"
        }
    }
    // reset
    function resetButton() {
        lastPosDir = "default"
        lastDir = "0"
        // Reset gyroscope values
        gyroscope.x = 0
        gyroscope.y = 0
        gyroscope.z = 0
        gyroscope.lastTimeStamp = 0
        gyroscope.underThrCount = 0

        // Reset accelerometer values
        accelerometer.ax = 0
        accelerometer.ay = 0
        accelerometer.az = 0
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

        // Clear path
        path = []
    }

    function startRecording() {
        isRecording = true
        path = []
        startPos["x"] = position.px.toFixed(2)
        startPos["y"] = position.py.toFixed(2)
    }

    function stopRecording() {
        isRecording = false
        // Log path coordinates to console
        console.log("Recorded Path:")
        for (var i = 0; i < path.length; ++i) {
            var point = path[i];
            console.log(
                        "Position(X):", point.x.toFixed(2),
                        "Position(Y):", point.y.toFixed(2),
                        "Position(Z):", point.z.toFixed(2));
        }
    }

    function savePath(){
        if (root.isRecording) {
            // console.log("Save path starting ...")
            let newState = {
                "start": startPos,
                "end": { "x": position.px.toFixed(2), "y": position.py.toFixed(2) },
                "direction": lastPosDir,
                "angle": lastDir
            }
            root.path.push(newState)
            console.log("newState is:", JSON.stringify(newState))
            startPos = { "x": position.px.toFixed(2), "y": position.py.toFixed(2) }
        }
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

                        let firstCall = lastTimeStamp == 0

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

                        if (underThrCount === 5) {
                            let currentDir = getDirection(rotation.rz)
                            if((currentDir !== lastDir) && (currentDir !== "default")){
                                console.log("from G")
                                savePath()
                                lastDir = currentDir
                            }
                        }

                        rotation.rx += (x > thr || x < -thr) ? (x * timeSinceLast) : 0
                        rotation.ry += (y > thr || y < -thr) ? (y * timeSinceLast) : 0
                        rotation.rz += (z > thr || z < -thr) ? (z * timeSinceLast) : 0
                    }
                }

                Accelerometer {
                    id: accelerometer

                    property real lastTimeStamp: 0
                    property real ax: 0
                    property real ay: 0
                    property real az: 0

                    property real vx: 0
                    property real vy: 0
                    property real vz: 0

                    property real bz: 9.8 // bias accelerate of g

                    property int underThrCount: 0

                    active: true
                    dataRate: 100

                    onReadingChanged: {
                        ax = (reading as AccelerometerReading).x
                        ay = (reading as AccelerometerReading).y
                        az = (reading as AccelerometerReading).z - bz

                        let firstCall = lastTimeStamp == 0

                        let newLast = reading.timestamp
                        let timeSinceLast = (newLast - lastTimeStamp) / 1000000
                        lastTimeStamp = newLast

                        if (firstCall === true)
                        return

                        let thr = 0.5
                        let thrv = 1

                        if ((ax <= thr && ax >= -thr) && (ay <= thr && ay >= -thr) && (az <= thr && az >= -thr)) {
                            underThrCount += 1
                        } else {
                            underThrCount = 0
                        }

                        if (underThrCount === 20) {
                            // console.log(vx + " , " + vy)
                            vx = 0
                            vy = 0
                            vz = 0
                        }

                        vx += (ax > thr || ax < -thr) ? (ax * timeSinceLast) : 0
                        vy += (ay > thr || ay < -thr) ? (ay * timeSinceLast) : 0
                        vz += (az > thr || az < -thr) ? (az * timeSinceLast) : 0

                        let currentPosDir = getPositionDir(vx, vy)
                        if(lastPosDir === "default"){
                            lastPosDir = currentPosDir
                        }else if((lastPosDir !== currentPosDir) && (currentPosDir !== "default")){
                            console.log("from A", lastPosDir, currentPosDir)
                            savePath()
                            lastPosDir = currentPosDir
                        }

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
                    onClicked: {
                        if (root.isRecording) {
                            root.stopRecording()
                            text = "Start Recording"
                        } else {
                            root.startRecording()
                            text = "Stop Recording"
                        }
                    }
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
