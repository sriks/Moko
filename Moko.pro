# Add more folders to ship with the application, here
folder_01.source = qml/Moko
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
CONFIG += mobility
MOBILITY += connectivity

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

include (../feedparrot/feedparrot.pri)

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qml/Moko/MokoUtils.js \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qtc_packaging/debian_harmattan/prerm \
    qtc_packaging/debian_harmattan/postinst

OTHER_FILES += \
    com.dreamcode.moko.service \
    moko.conf

RESOURCES += \
    resources.qrc

contains(MEEGO_EDITION,harmattan) {
    # share ui setup
    include(../shareui/shareui.pri)
}

# install d-bus files
#app_conf.files = moko.conf
#appp_conf.path = /etc/dbus-1/session.d/

#app_service.files = com.dreamcode.moko.service
#app_service.path = /usr/share/dbus-1/services/

#INSTALLS += app_conf app_service

# test
CONFIG += meegotouchevents
