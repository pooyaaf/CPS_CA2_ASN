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

Our coding structure consists of four main foulders *Client, Embedded, Proteus, Server* which represent their respective roles in our application. Aside from the *Proteus* folder which includes the required simulation data for the application, other code files need to be built and compiled. 

# Perfetto

# Other Questions


# Conclusion

In conclusion, in this course project, we successfully implemented an IoT-based entry and exit management system for a hypothetical company. By leveraging technologies like RFID, Arduino, and web development frameworks, the system provides a seamless integration of hardware and software components to control and monitor access to the premises effectively.

The embedded system, simulated using Proteus, handles the core functionality of reading RFID tags, controlling the door's servo motor, and communicating with the cloud-based web server. The web server, developed using the Qt framework, maintains the list of authorized individuals and processes authentication requests, ensuring only authorized personnel can gain entry.

The monitoring application, also built with Qt, establishes a WebSocket connection with the web server, providing real-time visibility into entry and exit events. This centralized monitoring capability enhances security by allowing administrators to promptly detect and address any unauthorized access attempts or suspicious activities.

Throughout the project, emphasis was placed on modular design, code maintainability, and thorough documentation to facilitate future enhancements or adaptations. The integration of various components, including hardware simulations, web development, and real-time monitoring, challenged our problem-solving and technical skills, contributing to a valuable learning experience. 🚀🌟

---

[Answers](Answers.md)