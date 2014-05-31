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

#include <QModelIndex>

#include "nextbikeplacemodel.h"
#include "settings.h"

NextbikePlaceModel::NextbikePlaceModel(QObject *parent) :
    ListModel(new NextbikePlaceItem, parent)
{
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(finished(QNetworkReply*)));
    currentReply = 0;
    busy = false;
    cityName = "null";
    cityLat = 0.0;
    cityLng = 0.0;
    lat = 0;
    lng = 0;
}

void NextbikePlaceModel::setBusy(bool value)
{
    if (busy == value)
        return;
    busy = value;
    emit busyChanged();
}

bool NextbikePlaceModel::isBusy()
{
    return busy;
}

void NextbikePlaceModel::refresh()
{
    if(busy)
        return;
    setBusy(true);

    QModelIndex firstIndex, lastIndex;
    int l = rowCount();
    if (l>0) {
        firstIndex = indexFromItem(readRow(0));
        lastIndex = indexFromItem(readRow(rowCount()-1));
        emit layoutAboutToBeChanged();
        removeRows(0,l);
    }

    sortPlaceList();

    QList<Place>::iterator it = placeList.begin();
    while (it != placeList.end()) {
        if ((*it).distance<radius)
            appendRow(new NextbikePlaceItem(
                          (*it).name,
                          (*it).id,
                          (*it).lat,
                          (*it).lng,
                          (*it).bikes,
                          (*it).bikesNumbers,
                          (*it).distance
                          ));
        ++it;
    }

    if (l>0) {
        changePersistentIndex(firstIndex, lastIndex);
        emit layoutChanged();
    }

    setBusy(false);
}

void NextbikePlaceModel::init()
{
    if(busy)
        return;
    setBusy(true);

    int l = rowCount();
    if (l>0)
        removeRows(0,l);
    XMLdata = QByteArray();

    Settings *s = Settings::instance();
    int uid = s->getCityId(); int uid2 = 0;
    // fix for Veturilo and BemowoBike //
    if(uid==210) uid2=197;
    if(uid==197) uid2=210;
    // --- //

    QUrl url("http://nextbike.net/maps/nextbike-official.xml");
    if (uid!=0 && uid2==0)
        url.setUrl(QString("http://nextbike.net/maps/nextbike-official.xml?city=%1").arg(uid));
    if (uid!=0 && uid2!=0)
        url.setUrl(QString("http://nextbike.net/maps/nextbike-official.xml?city=%1,%2").arg(uid).arg(uid2));

    QNetworkRequest request(url);

    if (currentReply) {
        currentReply->disconnect();
        currentReply->deleteLater();
    }

    currentReply = manager.get(request);
    connect(currentReply, SIGNAL(readyRead()), this, SLOT(readyRead()));
    connect(currentReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(networkError(QNetworkReply::NetworkError)));
}

void NextbikePlaceModel::readyRead()
{
    int statusCode = currentReply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (statusCode >= 200 && statusCode < 300) {
        XMLdata += currentReply->readAll();
    }
}

bool NextbikePlaceModel::parse()
{
    QDomDocument doc("mydocument");
    if (!doc.setContent(XMLdata)) {
        qDebug() << "XML parsing fails!";
        return false;
    }
    domElement = doc.documentElement();
    return true;
}

void NextbikePlaceModel::createPlaces()
{
    placeList.clear();

    QDomNodeList cityList = domElement.elementsByTagName("city");
    int l = cityList.length();

    if (l==0) {
        qWarning() << "City not found!";
        return;
    }

    Settings *s = Settings::instance();
    int uid = s->getCityId(); int uid2 = uid;
    // fix for Veturilo and BemowoBike //
    if(uid==210) uid2=197;
    if(uid==197) uid2=210;
    // --- //

    for(int i=0;i<l;++i) {
        QDomElement city = cityList.at(i).toElement();
        if(city.attribute("uid").toInt() == uid ) {
            cityLat = city.attribute("lat").toDouble();
            cityLng = city.attribute("lng").toDouble();
            cityName = city.attribute("name");
            //qDebug() << "New city:" << cityName;
            //qDebug() << "Lat:" << cityLat;
            //qDebug() << "Lng:" << cityLng;
        }
        if(city.attribute("uid").toInt() == uid ||
           city.attribute("uid").toInt() == uid2 ) {
            QDomNodeList placeList = city.elementsByTagName("place");
            int ll = placeList.length();
            for(int ii=0;ii<ll;++ii) {
                QDomElement place = placeList.at(ii).toElement();

                Place placeItem;
                placeItem.name = place.attribute("name");
                placeItem.id = place.attribute("uid").toInt();
                placeItem.lat = place.attribute("lat").toDouble();
                placeItem.lng = place.attribute("lng").toDouble();
                placeItem.bikes = place.attribute("bikes")=="5+" ? 5 : place.attribute("bikes").toInt();
                placeItem.bikesNumbers = place.attribute("bike_numbers","");
                placeItem.distance = 0;

                this->placeList.append(placeItem);
            }
        }
    }

    sortPlaceList();

    bool doDel = (this->lat!=0 && this->lng!=0 && s->getGps());
    QList<Place>::iterator it = placeList.begin();
    while (it != placeList.end()) {
        if (!doDel || (*it).distance<radius)
            appendRow(new NextbikePlaceItem(
                          (*it).name,
                          (*it).id,
                          (*it).lat,
                          (*it).lng,
                          (*it).bikes,
                          (*it).bikesNumbers,
                          (*it).distance
                          ));
        ++it;
    }

    setBusy(false);
}

void NextbikePlaceModel::finished(QNetworkReply *reply)
{
    if(!parse()) {
        qWarning() << "Error parsing XML feed";
        emit error();
        return;
    }
    createPlaces();
}

void NextbikePlaceModel::networkError(QNetworkReply::NetworkError)
{
    qWarning() << "Error retrieving XML feed";
    currentReply->disconnect(this);
    currentReply->deleteLater();
}

QString NextbikePlaceModel::getCityName()
{
    return cityName;
}

double NextbikePlaceModel::getLat()
{
    if (lat==0)
        return cityLat;
    return lat;
}

double NextbikePlaceModel::getLng()
{
    if (lng==0)
        return cityLng;
    return lng;
}

void NextbikePlaceModel::setLat(const double value)
{
    lat = value;
}

void NextbikePlaceModel::setLng(const double value)
{
    lng = value;
}


double NextbikePlaceModel::getCityLat()
{
    return cityLat;
}

double NextbikePlaceModel::getCityLng()
{
    return cityLng;
}

/*void NextbikePlaceModel::sortS()
{
    qDebug() << "sortS()";

    this->sort(_lat,_lng,false);
}

void NextbikePlaceModel::sort(double lat, double lng, bool delEnabled)
{
    qDebug() << "sort()" << delEnabled;
    QGeoCoordinate curCoord = QGeoCoordinate(lat, lng);
    QList<int> removeList;
    int l = rowCount();
    for(int i=0; i<l; ++i) {
        NextbikePlaceItem* item = static_cast<NextbikePlaceItem*>(readRow(i));
        QGeoCoordinate coord = QGeoCoordinate(item->lat(), item->lng());
        item->setDistance((int) curCoord.distanceTo(coord));

        //item->setDistance(qrand() % ((100 + 1) - 1) + 1);
        //qDebug() << item->name() << " distance: " << item->distance();

        if(delEnabled && item->distance()>radius) {
            removeList.append(i);
        }
    }

    QList<int>::iterator it = removeList.begin();
    while (it != removeList.end()) {
        removeRow(*it);
        ++it;
    }

    QModelIndex firstIndex = indexFromItem(readRow(0));
    QModelIndex lastIndex = indexFromItem(readRow(rowCount()-1));
    emit layoutAboutToBeChanged();
    this->doSorting();
    changePersistentIndex(firstIndex, lastIndex);
    emit layoutChanged();
    emit sorted();
}*/

/*void NextbikePlaceModel::doSorting()
{
    int n, i;
    for (n = 0; n < this->rowCount(); ++n) {
        for (i=n+1; i < this->rowCount(); ++i) {
            if(((NextbikePlaceItem*)this->readRow(n))->distance() >
               ((NextbikePlaceItem*)this->readRow(i))->distance()) {
                this->moveRow(i, n);
                n = 0;
            }
        }
    }
}*/

void NextbikePlaceModel::sortPlaceList()
{
    //updating distance
    double lat, lng;
    if (this->lat !=0 && this->lng !=0) {
        lat = this->lat;
        lng = this->lng;
    } else {
        lat = this->cityLat;
        lng = this->cityLng;
    }
    QGeoCoordinate curCoord(lat, lng);
    QList<Place>::iterator it = placeList.begin();
    while (it != placeList.end()) {
        QGeoCoordinate coord((*it).lat,(*it).lng);
        (*it).distance = (int) curCoord.distanceTo(coord);
        ++it;
    }

    // sorting
    int n, i, l = placeList.count();
    for (n = 0; n < l; ++n) {
        for (i=n+1; i < l; ++i) {
            if(placeList.at(n).distance > placeList.at(i).distance) {
                placeList.move(i, n);
                n = 0;
            }
        }
    }
}

int NextbikePlaceModel::count()
{
    return this->rowCount();
}

QObject* NextbikePlaceModel::get(int i)
{
    return (QObject*) this->readRow(i);
}

// ----------------------------------------------------------------

NextbikePlaceItem::NextbikePlaceItem(const QString &name, int uid, double lat, double lng, int bikes, const QString &bikesNumber, int distance, QObject *parent) :
    ListItem(parent), m_name(name), m_uid(uid), m_lat(lat), m_lng(lng), m_bikes(bikes), m_bikesNumber(bikesNumber), m_distance(distance)
{
}

QHash<int, QByteArray> NextbikePlaceItem::roleNames() const
{
    QHash<int, QByteArray> names;
    names[NameRole] = "name";
    names[UidRole] = "uid";
    names[LatRole] = "lat";
    names[LngRole] = "lng";
    names[BikesRole] = "bikes";
    names[BikesNumberRole] = "bikesNumber";
    names[DistanceRole] = "distance";
    return names;
}

QVariant NextbikePlaceItem::data(int role) const
{
    switch(role) {
    case NameRole:
        return name();
    case UidRole:
        return uid();
    case LatRole:
        return lat();
    case LngRole:
        return lng();
    case BikesRole:
        return bikes();
    case BikesNumberRole:
        return bikesNumber();
    case DistanceRole:
        return distance();
    default:
        return QVariant();
    }
}

void NextbikePlaceItem::setDistance(int distance)
{
    this->m_distance = distance;
    emit dataChanged();
}
