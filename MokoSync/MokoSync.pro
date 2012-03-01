#-------------------------------------------------
#
# Project created by QtCreator 2011-12-28T17:54:44
#
#-------------------------------------------------

TARGET = mokosync-client
TEMPLATE = lib
DEFINES += MOKOSYNC_LIBRARY

DEPENDPATH += .
INCLUDEPATH += .  \
                 /usr/include/libsynccommon \
                 /usr/include/libsyncprofile
SOURCES += MokoSync.cpp
HEADERS += MokoSync.h\
        MokoSync_global.h

include(../../feedparrot/feedparrot.pri)
INCLUDEPATH += ../../feedparrot

LIBS += -lsyncpluginmgr -lsyncprofile
CONFIG += debug plugin meegotouchevents
QT += dbus network # why im adding network?
QT -= gui

unix:!symbian {
OTHER_FILES += xml/*.xml
OTHER_FILES += xml/sync/*.xml
OTHER_FILES += xml/service/*.xml
#install
target.path = /usr/lib/sync/

client.path = /etc/sync/profiles/client
client.files = xml/mokosync.xml

sync.path = /etc/sync/profiles/sync
sync.files = xml/sync/*

service.path = /etc/sync/profiles/service
service.files = xml/service/*

INSTALLS += target client sync service
}

