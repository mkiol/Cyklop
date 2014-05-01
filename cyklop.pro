folder_01.source = qml/cyklop
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

CONFIG += mobility
MOBILITY += location
QT += network xml xmlpatterns
CONFIG += qt-components

symbian {
    TARGET.UID3 = 0xE40FD623
    TARGET.CAPABILITY += NetworkServices
    TARGET.CAPABILITY += Location
    DEPLOYMENT.display_name = Cyklop
    VERSION = 0.3.0
    ICON = cyklop.svg
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    nextbikeplacemodel.h \
    nextbikecitymodel.h \
    listmodel.h \
    settings.h

SOURCES += main.cpp \
    nextbikeplacemodel.cpp \
    nextbikecitymodel.cpp \
    listmodel.cpp \
    settings.cpp

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    cyklop.svg \
    README.md \
    cyklop_harmattan.desktop \
    cyklop80.png



