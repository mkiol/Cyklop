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

#ifndef NEXTBIKEPLACEMODEL_H
#define NEXTBIKEPLACEMODEL_H

#include <QObject>
#include <QVariant>
#include <QHash>
#include <QByteArray>
#include <QString>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QDomElement>
#include <QList>
#include <QGeoCoordinate>

#include "listmodel.h"

// Use the QtMobility namespace
QTM_USE_NAMESPACE

class NextbikePlaceItem : public ListItem
{
    Q_OBJECT

public:
    enum Roles {
        NameRole = Qt::UserRole+1,
        UidRole,
        LatRole,
        LngRole,
        BikesRole,
        BikesNumberRole,
        DistanceRole
    };

public:
    NextbikePlaceItem(QObject *parent = 0): ListItem(parent) {}
    explicit NextbikePlaceItem(const QString &name,
             int uid, double lat,double lng, int bikes, const QString &bikesNumber, int distance,
                               QObject *parent = 0);
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    inline QString id() const { return m_name; }
    Q_INVOKABLE inline QString name() const { return m_name; }
    inline int uid() const { return m_uid; }
    Q_INVOKABLE inline double lat() const { return m_lat; }
    Q_INVOKABLE inline double lng() const { return m_lng; }
    Q_INVOKABLE inline int bikes() const { return m_bikes; }
    inline QString bikesNumber() const { return m_bikesNumber; }
    inline int distance() const { return m_distance; }
    void setDistance(int distance);


private:
    QString m_name;
    int m_uid;
    double m_lat;
    double m_lng;
    int m_bikes;
    QString m_bikesNumber;
    int m_distance;
};

class NextbikePlaceModel : public ListModel
{
    Q_OBJECT

    Q_PROPERTY (bool busy READ isBusy NOTIFY busyChanged)
    Q_PROPERTY (QString cityName READ getCityName)
    Q_PROPERTY (double cityLat READ getCityLat)
    Q_PROPERTY (double cityLng READ getCityLng)
    Q_PROPERTY (double lat READ getLat WRITE setLat)
    Q_PROPERTY (double lng READ getLng WRITE setLng)

    struct Place {
        int id;
        QString name;
        double lat;
        double lng;
        int bikes;
        QString bikesNumbers;
        int distance;
    };

public:
    static const int radius = 5000;

    explicit NextbikePlaceModel(QObject *parent = 0);

    Q_INVOKABLE void init();
    Q_INVOKABLE void refresh();

    //Q_INVOKABLE void sort(double lat, double lng, bool delEnabled = true);
    //Q_INVOKABLE void sortS();

    QString getCityName();
    double getCityLat();
    double getCityLng();
    double getLat();
    double getLng();
    void setLat(const double value);
    void setLng(const double value);

    Q_INVOKABLE int count();
    Q_INVOKABLE QObject* get(int i);

    bool isBusy();

signals:
    void sorted();
    void error();
    void busyChanged();

public slots:
    void finished(QNetworkReply *reply);
    void readyRead();
    void networkError(QNetworkReply::NetworkError);

private:
    QNetworkAccessManager manager;
    QNetworkReply *currentReply;
    QByteArray XMLdata;
    QDomElement domElement;
    QString cityName;
    bool busy;
    double cityLat;
    double cityLng;
    double lat;
    double lng;
    QList<Place> placeList;

    bool parse();
    void createPlaces(); 
    //void doSorting();
    void setBusy(bool value);
    //void sortS();
    void sortPlaceList();
};

#endif // NEXTBIKEPLACEMODEL_H
