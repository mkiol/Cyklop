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

#include "nextbikecitymodel.h"

NextbikeCityModel::NextbikeCityModel(QObject *parent) :
    ListModel(new NextbikeCityItem, parent)
{
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(finished(QNetworkReply*)));
    currentReply = 0;
    _busy = false;
}

void NextbikeCityModel::setBusy(bool value)
{
    if (_busy == value)
        return;
    _busy = value;
    emit busyChanged();
}

bool NextbikeCityModel::isBusy()
{
    return _busy;
}

void NextbikeCityModel::init()
{
    if(_busy)
        return;
    setBusy(true);

    int l = rowCount();
    if (l>0)
        removeRows(0,l);
    XMLdata = QByteArray();

    QUrl url("http://nextbike.net/maps/nextbike-official.xml");

    QNetworkRequest request(url);

    if (currentReply) {
        currentReply->disconnect();
        currentReply->deleteLater();
    }

    currentReply = manager.get(request);
    connect(currentReply, SIGNAL(readyRead()), this, SLOT(readyRead()));
    connect(currentReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(networkError(QNetworkReply::NetworkError)));
}

void NextbikeCityModel::reload()
{
    init();
}

void NextbikeCityModel::readyRead()
{
    int statusCode = currentReply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (statusCode >= 200 && statusCode < 300) {
        XMLdata += currentReply->readAll();
    }
}

bool NextbikeCityModel::parse()
{
    QDomDocument doc("mydocument");
    if (!doc.setContent(XMLdata)) {
        qWarning() << "XML parsing fails!";
        return false;
    }
    domElement = doc.documentElement();
    return true;
}

void NextbikeCityModel::createCity()
{
    QDomNodeList cityList = domElement.elementsByTagName("city");
    int l = cityList.length();

    for(int i=0;i<l;++i) {
        QDomElement city = cityList.at(i).toElement();
        appendRow(new NextbikeCityItem(
                      city.attribute("name"),
                      city.attribute("uid").toInt(),
                      city.attribute("lat").toDouble(),
                      city.attribute("lng").toDouble()
                      ));
    }

    sort();
    setBusy(false);
}

void NextbikeCityModel::finished(QNetworkReply *reply)
{
    qDebug() << "finished";

    if(!parse()) {
        qWarning() << "Error parsing XML feed";
        setBusy(false);
        emit error();
        return;
    }
    
    createCity();
}

void NextbikeCityModel::networkError(QNetworkReply::NetworkError)
{
    qWarning() << "Error retrieving XML feed";
    currentReply->disconnect(this);
    currentReply->deleteLater();
    currentReply = 0;
}

void NextbikeCityModel::sort(double lat, double lng)
{
    //TODO
}

void NextbikeCityModel::sort()
{
    int n, i;
    for (n = 0; n < rowCount(); ++n) {
        for (i=n+1; i < rowCount(); ++i) {
            if(((NextbikeCityItem*)readRow(n))->name().toLower() >
               ((NextbikeCityItem*)readRow(i))->name().toLower()) {
                moveRow(i, n);
                n = 0;
            }
        }
    }
}

// ----------------------------------------------------------------

NextbikeCityItem::NextbikeCityItem(const QString &name, int uid, double lat, double lng, QObject *parent) :
    ListItem(parent), m_name(name), m_uid(uid), m_lat(lat), m_lng(lng)
{
}

QHash<int, QByteArray> NextbikeCityItem::roleNames() const
{
    QHash<int, QByteArray> names;
    names[NameRole] = "name";
    names[UidRole] = "uid";
    names[LatRole] = "lat";
    names[LngRole] = "lng";
    return names;
}

QVariant NextbikeCityItem::data(int role) const
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
    default:
        return QVariant();
    }
}
