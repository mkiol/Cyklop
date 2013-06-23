#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QSettings>

#if defined(Q_WS_MAEMO_5)
#include <QDBusConnection>
#include <QDBusMessage>
#endif


class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);

    Q_INVOKABLE bool isMaemo();
    Q_INVOKABLE void minimizeWindow();
    Q_INVOKABLE bool isFirstStart();
    Q_INVOKABLE void saveCity(int uid, const QString &name);
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE int cityUid();
    Q_INVOKABLE QString cityName();
    Q_INVOKABLE int radius();
    Q_INVOKABLE void saveRadius(int radius);
    Q_INVOKABLE int gpsInterval();
    Q_INVOKABLE void saveInterval(int interval);
    Q_INVOKABLE QString locale();
    Q_INVOKABLE void saveLocale(const QString &name);
    Q_INVOKABLE int timeout();
    Q_INVOKABLE void saveTimeout(int t);


private:
    QSettings* _settings;
    
};

#endif // UTILS_H
