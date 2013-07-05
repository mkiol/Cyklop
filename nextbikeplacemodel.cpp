#include "nextbikeplacemodel.h"

NextbikePlaceModel::NextbikePlaceModel(Utils *utils, QObject *parent) :
    ListModel(new NextbikePlaceItem, parent)
{
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(finished(QNetworkReply*)));
    currentReply = 0;
    _busy = false;
    _utils = utils;
    _cityName = "null";
}

void NextbikePlaceModel::init()
{
    if(_busy) return;
    _busy = true;
    emit busy();

    int l = rowCount();
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
    connect(currentReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(error(QNetworkReply::NetworkError)));
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
    QDomNodeList cityList = domElement.elementsByTagName("city");
    int l = cityList.length(); int uid = _utils->cityUid();
    for(int i=0;i<l;++i) {
        QDomElement city = cityList.at(i).toElement();
        if(city.attribute("uid").toInt() == uid) {
            _lat = city.attribute("lat").toDouble();
            _lng = city.attribute("lng").toDouble();
            QDomNodeList placeList = city.elementsByTagName("place");
            int ll = placeList.length();
            for(int ii=0;ii<ll;++ii) {
                QDomElement place = placeList.at(ii).toElement();
                appendRow(new NextbikePlaceItem(
                              place.attribute("name"),
                              place.attribute("uid").toInt(),
                              place.attribute("lat").toDouble(),
                              place.attribute("lng").toDouble(),
                              place.attribute("bikes")=="5+" ? 5 : place.attribute("bikes").toInt(),
                              place.attribute("bike_numbers","")
                              ));
            }
            _cityName = city.attribute("name");
        }
    }

    _busy = false;
    emit ready();
}

void NextbikePlaceModel::finished(QNetworkReply *reply)
{
    if(!parse()) {
        qWarning("error parsing XML feed");
        emit quit();
        return;
    }
    createPlaces();
}

void NextbikePlaceModel::error(QNetworkReply::NetworkError)
{
    qWarning("error retrieving XML feed");
    currentReply->disconnect(this);
    currentReply->deleteLater();
    currentReply = 0;
}

QString NextbikePlaceModel::cityName()
{
    return _cityName;
}

double NextbikePlaceModel::lat()
{
    return _lat;
}

double NextbikePlaceModel::lng()
{
    return _lng;
}

void NextbikePlaceModel::sortS()
{
    //qDebug() << "sortS()";
    this->sort(_lat,_lng,false);
}

void NextbikePlaceModel::sort(double lat, double lng, bool delEnabled)
{
    // set distance
    //qDebug() << "lat: " << lat << " lng: " << lng;
    QGeoCoordinate curCoord = QGeoCoordinate(lat, lng);
    int radius = _utils->radius();
    int l = this->rowCount();
    for(int i=0; i<l; ++i) {
        NextbikePlaceItem* item = (NextbikePlaceItem*) this->readRow(i);
        QGeoCoordinate coord = QGeoCoordinate(item->lat(), item->lng());
        item->setDistance((int) curCoord.distanceTo(coord));
        //qDebug() << item->name() << " distance: " << item->distance();
        if(delEnabled && item->distance()>radius) {
            this->removeRow(i);
            --i; --l;
        }
    }

    // sort
    this->doSorting();
    emit sorted();
}

void NextbikePlaceModel::doSorting()
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

NextbikePlaceItem::NextbikePlaceItem(const QString &name, int uid, double lat, double lng, int bikes, const QString &bikesNumber, QObject *parent) :
    ListItem(parent), m_name(name), m_uid(uid), m_lat(lat), m_lng(lng), m_bikes(bikes), m_bikesNumber(bikesNumber)
{
    m_distance = 0;
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
    this->dataChanged();
}
