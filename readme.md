# CA2 - CPS - Motion-Based Authentication Android Application

### Table of Contents  
- [Introduction](#introduction)
- [Preliminary](#preliminary)
    - [Tools and Requirements](#tools-and-requirements)
    - [Experiment Settings](#experiment-settings)
- [Visual Results](#visual-results)
    - [Accept Scenario](#accept-scenario)
    - [Decline Scenario](#decline-scenario)
- [Code Explanation](#code-explanation) 
- [Perfetto](#perfetto)  
- [Other Questions](#other-questions)
- [Conclusion](#conclusion) 


# Introduction

This project is a motion-based authentication application developed for Android devices. It leverages the device's built-in sensors, such as the accelerometer and gyroscope, to capture and recognize user-specific motion patterns. The primary objective is to explore an innovative approach to user authentication, moving beyond traditional methods like passwords or biometrics.

The application is designed to record and store a user's unique motion pattern, which can be used as a "motion signature" for subsequent authentication attempts. During the recording phase, the user performs a series of predefined movements with their device, and the application captures the sensor data associated with these movements. This recorded motion pattern serves as the reference for future authentication attempts.

When a user attempts to authenticate, the application prompts them to repeat the same motion pattern. It then compares the real-time sensor data with the previously recorded motion signature. If the patterns match within a specified tolerance, the application grants access; otherwise, access is denied. This approach introduces an additional layer of security by combining the user's physical motion with the device's sensor data, making it more challenging for unauthorized individuals to replicate or bypass the authentication process.

# Preliminary

## Tools and Requirements

To compile and build this project, the following assumptions and requirements must be met:

- **Qt Framework**: The project is built using the Qt framework, specifically Qt 6.1 or later. Ensure that you have Qt installed on your development environment.
- **Android Development Environment**: Since this application targets Android devices, you'll need to have the Android SDK and Android NDK properly configured in your development environment. Please use versions 26 or higher.
- **CMake**: The project uses CMake as the build system, so you'll need to have CMake installed.


The following tools were used in the development and testing of this project:

- **Qt Creator**: The Qt Creator IDE was used for coding, building, and deploying the application.
- **Android Device**: A physical Android device (Android 13 or later) is required for testing and running the application. An emulator or simulator is not sufficient for this project.

## Experiment Settings

To ensure accurate sensor data and calibration, the following experiment settings were used:

- **Sensor Sampling Rate**: The accelerometer and gyroscope were configured to sample data at a rate of 100Hz and 20Hz, respectively.
- **Noise Filtering**: A low-pass filter was applied to the sensor data to reduce noise and improve accuracy.
- **Threshold Values**: Specific threshold values were set for detecting motion patterns and transitions between different movements.


The project utilizes the following Qt libraries and modules:

- **Qt Quick**: The Qt Quick module was used for developing the user interface and handling user interactions.
- **Qt Sensors**: This module provides access to the device's sensors, including the accelerometer and gyroscope, which are crucial for capturing motion data.
- **Qt Core**: The Qt Core module provides essential functionality for handling data structures, threading, and other low-level operations.

Additionally, the project may incorporate other third-party libraries or dependencies, which will be listed in the project's documentation or source code.



# Visual Results

Before we can describe our code and its components, we will demonstrate the result of this project. The demonstration includes both the scenarios where the user authentication is successful/unsuccessful.

To run the program, we first need to build and run the web server configuration in QT environment.

Below, is the corresponding demographic to record a motion pattern and to replicate it inorder to authenticate yourself successfully.

![Record and Authenticate Patterns](./MotionAuth/images/Authentication-Figure.jpg)

To run the program, we need to connect the android device to our system (using cable), build the project, and deploy (run) it on our device. Please make sure that the developer options is turned on and also USB debugging is enabled.

## Accept Scenario

<img src="./MotionAuth/images/Accept Scenario.gif" alt="Accept Scenario" width="200"/>


## Decline Scenario

<img src="./MotionAuth/images/Decline Scenario.gif" alt="Decline Scenario" width="200"/>


> **Note:** We have also implemented a bonus excercise to show the online recorded path. Here is the described scenario:

<img src="./MotionAuth/images/Bonus Part.gif" alt="Online Path" width="200"/>


# Code Explanation

Our coding structure consists of one main file *Main.qml* and some complimentary files *Header.qml, ProgressXYZBar.qml*. We will explain the *Main.qml* file and its functions briefly.


1. **Utility Functions**:
   - `getDirection(degree)`: This function takes an angle in degrees and normalizes it to a value between 0 and 359 degrees. It then maps the normalized angle to one of the four cardinal directions ("0", "90", "-90", or "180") based on the angle range. For example, if the angle is between 315 and 45 degrees, it returns "0" (representing the positive X-axis direction).
   - `getGlobalDirection(localDirection, angle)`: This function takes a local direction (e.g., "top", "left", "down", "right") and an angle (in degrees) representing the device's rotation around the Z-axis. It then calculates the global direction based on the local direction and the rotation angle. This is necessary because the device's orientation can change, and the local directions need to be mapped to the global coordinate system.
   - `getPositionDir(vx, vy)`: This function determines the direction of motion based on the velocity components `vx` (velocity along the X-axis) and `vy` (velocity along the Y-axis). It compares these velocities against a threshold value (`thrv`) and returns the corresponding direction ("right", "left", "top", "down", or "default" if the velocities are below the threshold).
   - `refresh()`: This function resets all sensor values and states to their initial conditions. It sets the gyroscope's `x`, `y`, `z`, and `lastTimeStamp` values to 0, as well as the `underThrCount` (a counter used for detecting stationary periods). Similarly, it resets the accelerometer's `ax`, `ay`, `az`, `lastTimeStamp`, `vx`, `vy`, `vz`, and `underThrCount` values. It also resets the rotation (`rx`, `ry`, `rz`) and position (`px`, `py`, `pz`) values to 0, and sets the `startPos` to (0, 0).
   - `resetButton()`: This function calls the `refresh()` function to reset all sensor values and states, and then clears the `path` and `authPath` arrays, which store the recorded motion path and the authentication path, respectively.

2. **Recording and Authentication**:
   - `startRecording()`: This function sets the `isRecording` property to `true` and calls the `refresh()` function to reset the sensor values and states before starting the recording process.
   - `stopRecording()`: This function sets the `isRecording` property to `false`, effectively stopping the recording process.
   - `startAuthenticating()`: This function sets the `isAutheticating` property to `true` and calls the `refresh()` function to reset the sensor values and states before starting the authentication process. Additionally, it resets the `vx`, `vy`, and `vz` values of the accelerometer to 0.
   - `stopAuthenticating()`: This function sets the `isAutheticating` property to `false`, effectively stopping the authentication process.

3. **Path Management**:
   - `getEndPosition()`: This function calculates the end position of a motion segment based on the current position (`startPos`), the last recorded direction (`lastPosDir`), and the last recorded angle (`lastDir`). It maps the local direction and angle to a global direction using the `getGlobalDirection` function and updates the `startPos` accordingly.
   - `savePath()`: This function first calls `getEndPosition()` to calculate the end position of the current motion segment. It then creates a new object containing the start position, end position, global direction, and angle, and appends it to either the `path` array (if `isRecording` is true) or the `authPath` array (if `isAutheticating` is true). Finally, it updates the `startPos` to the calculated end position for the next motion segment.
   - `checkPath()`: This function compares the recorded `path` with the `authPath`. If the `path` is empty, it returns "Record first". If the lengths of `path` and `authPath` are different, it returns "not matched!". Otherwise, it iterates through both arrays and compares the direction and angle for each motion segment. If any segment's direction or angle does not match, it returns "not matched!". If all segments match, it returns "matched".
   - `generateOnlinePathData()`: This function generates an array of direction strings ("right", "left", "top", "down") representing the recorded motion path. It iterates through the `path` array and appends the corresponding direction for each motion segment to the `onlinePathData` array. This data is used for visualizing the motion path on the canvas.

4. **User Interface**:
   - The main.qml file defines various UI components, such as buttons for starting/stopping recording and authentication, a popup for displaying validation messages, and a canvas for visualizing the motion path.
   - The buttons call the respective functions (`startRecording()`, `stopRecording()`, `startAuthenticating()`, `stopAuthenticating()`, `checkPath()`, and `resetButton()`) when clicked.
   - The `validatePopup` component displays a message based on the result of the `checkPath()` function.
   - The `chartPopup` component contains a `Canvas` element that renders the motion path using the `generateOnlinePathData()` function. It draws line segments and arrowheads for each motion segment, scaling the coordinates based on the canvas size.
   - The UI also includes components for displaying sensor data (accelerometer, gyroscope, and rotation) and position information, using `ProgressBar` and `Text` elements.

5. **Sensor Integration**:
   - The `Gyroscope` component is used to access the device's gyroscope sensor. It provides the angular velocity around the X, Y, and Z axes (`x`, `y`, `z`), which are used to calculate the device's rotation.
   - The `Accelerometer` component is used to access the device's accelerometer sensor. It provides the acceleration values along the X, Y, and Z axes (`ax`, `ay`, `az`), which are used to calculate the device's velocity and position.
   - Both sensor components update their respective values whenever a new reading is available (`onReadingChanged` signal). The `Gyroscope` component calculates the rotation angles (`rx`, `ry`, `rz`) based on the angular velocity and time elapsed between readings. The `Accelerometer` component calculates the velocity components (`vx`, `vy`, `vz`) and position (`px`, `py`, `pz`) based on the acceleration values and time elapsed between readings.
   - The sensor components also handle noise filtering and stationary detection by keeping track of an `underThrCount` value, which counts the number of consecutive readings where the sensor values are below a specified threshold. This information is used to determine when to update the `lastDir` (for the gyroscope) and `lastPosDir` (for the accelerometer), which represent the last recorded direction and angle, respectively.


# Perfetto

# Other Questions


# Conclusion

In conclusion, in this course project, we successfully implemented an IoT-based entry and exit management system for a hypothetical company. By leveraging technologies like RFID, Arduino, and web development frameworks, the system provides a seamless integration of hardware and software components to control and monitor access to the premises effectively.

The embedded system, simulated using Proteus, handles the core functionality of reading RFID tags, controlling the door's servo motor, and communicating with the cloud-based web server. The web server, developed using the Qt framework, maintains the list of authorized individuals and processes authentication requests, ensuring only authorized personnel can gain entry.

The monitoring application, also built with Qt, establishes a WebSocket connection with the web server, providing real-time visibility into entry and exit events. This centralized monitoring capability enhances security by allowing administrators to promptly detect and address any unauthorized access attempts or suspicious activities.

Throughout the project, emphasis was placed on modular design, code maintainability, and thorough documentation to facilitate future enhancements or adaptations. The integration of various components, including hardware simulations, web development, and real-time monitoring, challenged our problem-solving and technical skills, contributing to a valuable learning experience. 🚀🌟

---

[Answers](Answers.md)