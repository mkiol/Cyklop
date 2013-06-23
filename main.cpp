#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDebug>
#include <QSettings>

#include "qmlapplicationviewer.h"
#include "nextbikeplacemodel.h"
#include "nextbikecitymodel.h"
#include "utils.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    //qDebug() << "QT_VERSION_STR: " << QT_VERSION_STR;
    //qDebug() << "QTM_VERSION_STR: " << QTM_VERSION_STR;

    // utils
    Utils utils;

    // translator
    QTranslator translator;
    QString dir = "ts";
#if defined(Q_WS_MAEMO_5)
    dir = "/opt/cyklop/ts";
#endif
    if (translator.load(QString("cyklop.")+utils.locale(),dir)) {
        app->installTranslator(&translator);
    }

    // viewer
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    QObject::connect(viewer.engine(), SIGNAL(quit()), app.data(), SLOT(quit()));
    viewer.rootContext()->setContextProperty("viewer", &viewer);
    viewer.rootContext()->setContextProperty("Utils", &utils);

    // nextbikeModels
    NextbikePlaceModel nextbikeModel(&utils);
    QObject::connect(&nextbikeModel, SIGNAL(quit()), app.data(), SLOT(quit()));
    viewer.rootContext()->setContextProperty("nextbikeModel", &nextbikeModel);
    //nextbikeModel.init();
    NextbikeCityModel cityModel;
    QObject::connect(&cityModel, SIGNAL(quit()), app.data(), SLOT(quit()));
    viewer.rootContext()->setContextProperty("cityModel", &cityModel);


#if defined(Q_WS_MAEMO_5)
    qputenv("N900_PORTRAIT_SENSORS", "1");
    viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
    viewer.engine()->addPluginPath(QString("/opt/qtm12/plugins"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setGeometry(QRect(0,0,800,480));
    //viewer.grabZoomKeys(true);
#endif //Q_WS_MAEMO_5

    viewer.setMainQmlFile(QLatin1String("qml/cyklop/main.qml"));
    viewer.setWindowTitle(QString("Cyklop"));
    viewer.showExpanded();

    return app->exec();
}

