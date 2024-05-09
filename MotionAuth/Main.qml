import QtQuick
import QtQuick.Controls
import QtSensors

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Acceleration Sensor"

    // Main page content
    Item {
        anchors.fill: parent

        // Layout for buttons
        Column {
            anchors.centerIn: parent
            spacing: 20

            // Acceleration data display
                   Text {
                       text: "Gyroscope Data:"
                       font.bold: true
                   }

                   Text {
                       text: "X axis acceleration: " + accelerometer.x.toFixed(2)
                   }

                   Text {
                       text: "Y axis acceleration: " + accelerometer.y.toFixed(2)
                   }

                   Text {
                       text: "Z axis acceleration: " + accelerometer.z.toFixed(2)
                   }

                   // Gyroscope data display
                   Text {
                       text: "Gyroscope Data:"
                       font.bold: true
                   }

                   Text {
                       text: "X axis gyroscope: " + gyroscope.x.toFixed(2)
                   }

                   Text {
                       text: "Y axis gyroscope: " + gyroscope.y.toFixed(2)
                   }

                   Text {
                       text: "Z axis gyroscope: " + gyroscope.z.toFixed(2)
                   }

            // Start-record button
            Button {
                text: "Start-record"
                onClicked: {
                }
            }

            // Stop-record button
            Button {
                text: "Stop-record"
                onClicked: {

                }
            }
            // Start-authentication button
            Button {
                text: "Start-authentication"
                onClicked: {

                }
            }
            // Stop-authentication button
            Button {
                text: "Stop-authentication"
                onClicked: {

                }
            }
        }
    }
    // Accelerometer sensor
        Accelerometer {
            id: accelerometer

            property real x: 0
            property real y: 0
            property real z: 0

            active: true
            dataRate: 25

            onReadingChanged: {
                x = (reading as AccelerometerReading).x
                y = (reading as AccelerometerReading).y
                z = (reading as AccelerometerReading).z
            }
        }
        // Gyroscope sensor
        Gyroscope {
               id: gyroscope

               property real x: 0
               property real y: 0
               property real z: 0

               active: true
               dataRate: 25

               onReadingChanged: {
                   x = (reading as GyroscopeReading).x
                   y = (reading as GyroscopeReading).y
                   z = (reading as GyroscopeReading).z
               }
               onErrorChanged: {
                     console.error("Gyroscope error:", error)
                 }
           }

}
