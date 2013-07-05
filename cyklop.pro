# Add more folders to ship with the application, here
folder_01.source = qml/cyklop
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

folder_02.source = ts/cyklop.pl.qm
folder_02.target = ts
DEPLOYMENTFOLDERS += folder_02

# Additional import path used to resolve QML modules in Creator's code model
#QML_IMPORT_PATH += /usr/lib/qt4/imports
#QML_IMPORT_PATH += /home/mkiol/dev/QtSDK/Maemo/4.6.2/sysroots/fremantle-arm-sysroot-20.2010.36-2-slim/opt/lib/qt4/imports
#QML_IMPORT_PATH += /home/mkiol/dev/QtSDK/Maemo/4.6.2/sysroots/fremantle-arm-sysroot-20.2010.36-2-slim/usr/lib/qt4/imports
#QML_IMPORT_PATH += /home/mkiol/dev/QtSDK/Desktop/Qt/474/gcc/imports/
symbian:TARGET.UID3 = 0xE40FD623

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
maemo5 {
  CONFIG += mobility12
  QMAKE_LFLAGS += -Wl,-rpath,/opt/qtm12/lib
  QT += dbus
} else {
  CONFIG += mobility
}
MOBILITY += location

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Networking nad xml
QT += network xml xmlpatterns

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    nextbikeplacemodel.cpp \
    nextbikecitymodel.cpp \
    listmodel.cpp \
    utils.cpp

# evil_hack_to_fool_lupdate
include(ts.pri)

contains(MEEGO_EDITION, harmattan): {
    DEFINES += MEEGO_EDITION_HARMATTAN
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

HEADERS += \
    nextbikeplacemodel.h \
    nextbikecitymodel.h \
    listmodel.h \
    utils.h

TRANSLATIONS += \
    ts/cyklop.pl.ts
