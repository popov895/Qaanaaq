QT += \
    qml \
    quick

TEMPLATE = app

DEFINES += \
    QT_DEPRECATED_WARNINGS

SOURCES += \
    main.cpp \
    Utils.cpp

HEADERS += \
    Utils.h

RESOURCES += \
    qml.qrc

win32 {
    RC_FILE = Qaanaaq.rc
}
