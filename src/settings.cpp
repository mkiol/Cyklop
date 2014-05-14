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

#include "settings.h"

Settings* Settings::inst = 0;

Settings::Settings(QObject *parent) : QObject(parent), settings()
{
}

Settings* Settings::instance()
{
    if (Settings::inst == NULL) {
        Settings::inst = new Settings();
    }

    return Settings::inst;
}

bool Settings::getGps()
{
    return settings.value("gps",true).toBool();
}

void Settings::setGps(bool value)
{
    if (getGps() != value) {
        settings.setValue("gps",value);
        emit gpsChanged();
    }
}

QString Settings::getCityName()
{
    return settings.value("city_name","").toString();
}

void Settings::setCityName(const QString &value)
{
    if (getCityName() != value) {
        settings.setValue("city_name",value);
        emit cityNameChanged();
    }
}

int Settings::getCityId()
{
    return settings.value("city_id",0).toInt();
}

void Settings::setCityId(int value)
{
    if (getCityId() != value) {
        settings.setValue("city_id",value);
        emit cityIdChanged();
    }
}

int Settings::getUpdateInterval()
{
    return settings.value("update_interval",10000).toInt();
}

void Settings::setUpdateInterval(int value)
{
    if (getUpdateInterval() != value) {
        settings.setValue("update_interval",value);
        emit updateIntervalChanged();
    }
}
