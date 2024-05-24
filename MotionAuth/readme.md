# CA2 - CPS - Motion-based Authentication Android Application

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

Before we can describe our code and its components, we will demonstrate the result of this project. The demonstration includes both the scenarios where the user has/doesn't have access to open the door as well as the Proteus setup and configuration.

To run the program, we first need to build and run the web server configuration in QT environment.

![Server is Up!](./Images/server-up.png)

We also need the Proteus configuration below which consists of the following modules: ENC28J60 (ethernet), LM016L (LCD), Servo motor, LED (x2 with resistors), Arduino Uno, Terminal Windows (optional), Not Gate. 

![Proteus Config](./Images/proteus-configuration.png)

Please also note to set the appropriate IP for the ENC28J60 module.

![Ethernet Config](./Images/ethernet-config.png)

Lastly, note that we also need to build and run the client (administrator) configuration in QT environment if we want to monitor users' activities.

## Accept Scenario

In our database, we will authorise all RFIDs with the following format. Note that you can change this code to your own liking.

```
Database::Database()
{
    for (int i = 0; i < 10; ++i) {
        QJsonObject member;
        member["username"] = "ali" + QString::number(i);
        member["rfid"] = "123456789" + QString::number(i);
        members.append(member);
    }
}
```

For instance, `1234567890` is a valid ID. As it is shown below, on valid inputs, the green led will turn on, the door will roate 90 degrees and the appropriate message is shown. Moreover, the time and rfid value are shown on the LCD module. 

![Proteus Accept Scenario](./Images/accept-scenario.png)

On the server side, if we have the admin requirements, we can successfully log in to our account.

![Server Accept Scenario](./Images/server-accept-scenario.png)

As an admin, we also have the privilege to observe users' activities. For example, we can see that there have been one successful and one unsucceful entry attemps at April 30, 2024 at 12:38 and 12:39 respectively.  

![Server History](./Images/history.png)

> **Note:** Please note that after we have had at least one succeful entry, the server interface will also show the last successful entry record on the left side.

![Server User Entry Record](./Images/server-left-panel.png)


## Decline Scenario

On another hand, on invalid inputs, the red led will turn on, the door will stay closed and the *Access Denied* message is shown. Moreover, the *Access Denied* and rfid value are shown on the LCD module. 

![Proteus Decline Scenario](./Images/decline-scenario.png)

On the server side, if we have don't have the admin requirements, we cannot successfully log in to our account.

![Server Decline Scenario](./Images/server-accept-scenario.png)


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