TEMPLATE = app

QT += qml quick widgets serialport concurrent

SOURCES += main.cpp \
    template.cpp \
    parameters.cpp \
    clog.cpp \
    templatephotoposition.cpp \
    photo.cpp \
    photopart.cpp \
    photogallery.cpp \
    filereader.cpp \
    common.cpp \
    arduino.cpp \
    keyemitter.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

QMAKE_CXXFLAGS += -std=c++11

HEADERS += \
    template.h \
    parameters.h \
    clog.h \
    common.h \
    rapidjson/error/en.h \
    rapidjson/error/error.h \
    rapidjson/internal/biginteger.h \
    rapidjson/internal/diyfp.h \
    rapidjson/internal/dtoa.h \
    rapidjson/internal/ieee754.h \
    rapidjson/internal/itoa.h \
    rapidjson/internal/meta.h \
    rapidjson/internal/pow10.h \
    rapidjson/internal/stack.h \
    rapidjson/internal/strfunc.h \
    rapidjson/internal/strtod.h \
    rapidjson/msinttypes/inttypes.h \
    rapidjson/msinttypes/stdint.h \
    rapidjson/allocators.h \
    rapidjson/document.h \
    rapidjson/encodedstream.h \
    rapidjson/encodings.h \
    rapidjson/filereadstream.h \
    rapidjson/filewritestream.h \
    rapidjson/memorybuffer.h \
    rapidjson/memorystream.h \
    rapidjson/pointer.h \
    rapidjson/prettywriter.h \
    rapidjson/rapidjson.h \
    rapidjson/reader.h \
    rapidjson/stringbuffer.h \
    rapidjson/writer.h \
    templatephotoposition.h \
    photo.h \
    photopart.h \
    photogallery.h \
    filereader.h \
    arduino.h \
    keyemitter.h

DISTFILES += \
    print/get_printer_reg.bat \
    print/print.bat
