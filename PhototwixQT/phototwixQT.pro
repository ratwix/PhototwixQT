TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    template.cpp \
    parameters.cpp \
    clog.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    template.h \
    parameters.h \
    clog.h \
    common.h
