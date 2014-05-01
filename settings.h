/*
  Copyright (C) 2014 Michal Kosciesza <michal@mkiol.net>

  This file is part of Kaktus.

  Kaktus is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Kaktus is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Kaktus.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>
#include <QString>

#include "qmlapplicationviewer.h"

class Settings: public QObject
{
    Q_OBJECT

    Q_PROPERTY (bool gps READ getGps WRITE setGps NOTIFY gpsChanged)
    Q_PROPERTY (QString cityName READ getCityName WRITE setCityName NOTIFY cityNameChanged)
    Q_PROPERTY (int cityId READ getCityId WRITE setCityId NOTIFY cityIdChanged)
    Q_PROPERTY (int updateInterval READ getUpdateInterval WRITE setUpdateInterval NOTIFY updateIntervalChanged)

public:
    static Settings* instance();

    QmlApplicationViewer* viewer;

    bool getGps();
    void setGps(bool value);
    QString getCityName();
    void setCityName(const QString &value);
    int getCityId();
    void setCityId(int value);
    int getUpdateInterval();
    void setUpdateInterval(int value);

signals:
    void gpsChanged();
    void cityNameChanged();
    void cityIdChanged();
    void updateIntervalChanged();

private:
    QSettings settings;
    static Settings *inst;

    explicit Settings(QObject *parent = 0);
};

#endif // SETTINGS_H
