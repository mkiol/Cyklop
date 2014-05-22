contains(MEEGO_EDITION, harmattan) {
    DEFINES += MEEGO_EDITION_HARMATTAN
}

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
    VERSION = 0.3.1
    ICON = cyklop_symbian.svg
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    src/nextbikeplacemodel.h \
    src/nextbikecitymodel.h \
    src/listmodel.h \
    src/settings.h

SOURCES += \
    src/main.cpp \
    src/nextbikeplacemodel.cpp \
    src/nextbikecitymodel.cpp \
    src/listmodel.cpp \
    src/settings.cpp

TRANSLATIONS = i18n/cyklop_en.ts \
               i18n/cyklop_pl.ts

CODECFORTR = UTF-8

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
    LICENSE \
    cyklop_harmattan.desktop \
    cyklop80.png \
    i18n_paths.lst \
    i18n_ts.lst \
    lupdate.sh

RESOURCES += \
    resources.qrc
