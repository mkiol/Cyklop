/*
  Copyright (C) 2014 Michal Kosciesza <michal@mkiol.net>

  This file is part of Cyklop.

  Cyklop is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Cyklop is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Cyklop.  If not, see <http://www.gnu.org/licenses/>.
*/


#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDebug>
#include <QSettings>
#include <QTranslator>

#include "qmlapplicationviewer.h"
#include "nextbikeplacemodel.h"
#include "nextbikecitymodel.h"
#include "settings.h"

static const char *APP_NAME = "Cyklop";
static const char *VERSION = "0.3.1";
static const char *AUTHOR = "Michał Kościesza <michal@mkiol.net>";
static const char *PAGE = "http://cyklop.mkiol.net/";

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    app->setApplicationName("cyklop");
    app->setOrganizationName("mkiol");
    app->setApplicationVersion(VERSION);

    //qDebug() << "QT_VERSION_STR: " << QT_VERSION_STR;
    //qDebug() << "QTM_VERSION_STR: " << QTM_VERSION_STR;

    QTranslator *appTranslator = new QTranslator;
    //appTranslator->load(":/i18n/cyklop_" + QLocale::system().name() + ".qm");
    appTranslator->load(":/i18n/cyklop_pl.qm");
    app->installTranslator(appTranslator);

    Settings *s = Settings::instance();
    QmlApplicationViewer viewer;
    NextbikePlaceModel nextbikeModel;
    NextbikeCityModel cityModel;

    s->viewer = &viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    QObject::connect(viewer.engine(), SIGNAL(quit()), app.data(), SLOT(quit()));
    QObject::connect(&nextbikeModel, SIGNAL(error()), app.data(), SLOT(quit()));
    QObject::connect(&cityModel, SIGNAL(error()), app.data(), SLOT(quit()));

    viewer.rootContext()->setContextProperty("APP_NAME", APP_NAME);
    viewer.rootContext()->setContextProperty("VERSION", VERSION);
    viewer.rootContext()->setContextProperty("AUTHOR", AUTHOR);
    viewer.rootContext()->setContextProperty("PAGE", PAGE);

    viewer.rootContext()->setContextProperty("settings", Settings::instance());
    viewer.rootContext()->setContextProperty("cityModel", &cityModel);
    viewer.rootContext()->setContextProperty("nextbikeModel", &nextbikeModel);

#ifdef MEEGO_EDITION_HARMATTAN
    qDebug() << "MEEGO_EDITION_HARMATTAN";
#endif

#if defined(Q_WS_MAEMO_5)
    qputenv("N900_PORTRAIT_SENSORS", "1");
    viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
    viewer.engine()->addPluginPath(QString("/opt/qtm12/plugins"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setGeometry(QRect(0,0,800,480));
    viewer.setMainQmlFile(QLatin1String("qml/cyklop/maemo/main.qml"));
#elif defined(MEEGO_EDITION_HARMATTAN)
    viewer.setMainQmlFile(QLatin1String("qml/cyklop/meego/main.qml"));
#elif defined(Q_OS_SYMBIAN)
    viewer.setMainQmlFile(QLatin1String("qml/cyklop/symbian/main.qml"));
#else
    //viewer.setMainQmlFile(QLatin1String("qml/cyklop/symbian/main.qml"));
    viewer.setMainQmlFile(QLatin1String("qml/cyklop/meego/main.qml"));
#endif

    viewer.setWindowTitle(QString(APP_NAME));
    viewer.showExpanded();

    return app->exec();
}

