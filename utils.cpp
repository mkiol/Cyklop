#include "utils.h"
#include <QDebug>

Utils::Utils(QObject *parent) :
    QObject(parent)
{
    _settings = new QSettings("cyklop");
}

void Utils::minimizeWindow()
{
#if defined(Q_WS_MAEMO_5)
    // This is needed for Maemo5 to recognize minimization
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusMessage message = QDBusMessage::createSignal(
                "/","com.nokia.hildon_desktop","exit_app_view");
    connection.send(message);
#else
    _viewer->setWindowState(Qt::WindowMinimized);
#endif
}

bool  Utils::isMaemo()
{
#if defined(Q_WS_MAEMO_5)
    return true;
#endif
    return false;
}

bool Utils::isFirstStart()
{
    int version = _settings->value("version",0).toInt();
    qDebug() << "isFirstStart: " << version;

    if(version==0) {
        return true;
    }
    return false;
}

void Utils::saveCity(int uid, const QString &name)
{
    _settings->setValue("city.uid",uid);
    _settings->setValue("city.name",name);
}

QString Utils::cityName()
{
    return _settings->value("city.name","").toString();
}

int Utils::cityUid()
{
    return _settings->value("city.uid",0).toInt();
}

void Utils::saveSettings()
{
    _settings->setValue("version",1);
}

int Utils::gpsInterval() {
    int interval = _settings->value("interval",5000).toInt();
    saveInterval(interval);
    return interval;
}

void Utils::saveInterval(int interval)
{
    _settings->setValue("interval",interval);
}

int Utils::radius() {
    int radius = _settings->value("radius",5000).toInt();
    saveRadius(radius);
    return radius;
}

void Utils::saveRadius(int radius)
{
    _settings->setValue("radius",radius);
}

QString Utils::locale() {
    QString locale = _settings->value("locale","en").toString();
    saveLocale(locale);
    return locale;
}

void Utils::saveLocale(const QString &locale) {
    _settings->setValue("locale",locale);
}

int Utils::timeout() {
    int t = _settings->value("timeout",10000).toInt();
    saveTimeout(t);
    return t;
}

void Utils::saveTimeout(int t)
{
    _settings->setValue("timeout",t);
}

