cmake_minimum_required(VERSION 3.16)

project(MotionAuth VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Sensors)

qt_standard_project_setup()

qt_add_executable(appMotionAuth
    main.cpp
)

qt_add_qml_module(appMotionAuth
    URI MotionAuth
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES ProgressXYZBar.qml
        RESOURCES images/qt.png
        QML_FILES
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMotionAuth PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMotionAuth
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMotionAuth
    PRIVATE Qt6::Quick
)
target_link_libraries(appMotionAuth PRIVATE Qt6::Sensors)

include(GNUInstallDirs)
install(TARGETS appMotionAuth
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
