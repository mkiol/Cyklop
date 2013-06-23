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

void NextbikePlaceModel::reload()
{
    if(_busy) return;

    int l = rowCount();
    removeRows(0,l);
    XMLdata = QByteArray();
    //qDebug() << "reload";
    //qDebug() << "checkDbFile: " << checkDbFile();
    //generateDbFile();
    init();
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
            QDomNodeList placeList = city.elementsByTagName("place");
            int ll = placeList.length();
            for(int ii=0;ii<ll;++ii) {
                QDomElement place = placeList.at(ii).toElement();
                //qDebug() << "uid: " << place.attribute("uid").toInt() << " name: " << place.attribute("name");
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

    generateDbFile();
    generateLmxFile();

    _busy = false;
    emit ready();
}

void NextbikePlaceModel::finished(QNetworkReply *reply)
{
    qDebug() << "finished";

    if(!parse()) {
        qWarning("error parsing XML feed");
        emit quit();
        return;
    }

    //emit readyToSelect();
    createPlaces();
}

void NextbikePlaceModel::error(QNetworkReply::NetworkError)
{
    qWarning("error retrieving XML feed");
    currentReply->disconnect(this);
    currentReply->deleteLater();
    currentReply = 0;
}

QString NextbikePlaceModel::nameFixup(NextbikePlaceItem *place)
{
   return QString::number(place->bikes()) + "@#@" + place->bikesNumber();
}

bool NextbikePlaceModel::generateLmxFile()
{
    //clean
    QDir dir(QDir::temp().absolutePath());
    dir.setNameFilters(QStringList() << "nextbikefeed_*.lmx");
    dir.setFilter(QDir::Files);
    for(int i=0; i<dir.entryList().size();++i) {
        qDebug() << dir.entryList().at(i);
        dir.remove(dir.entryList().at(i));
    }

    _landmarkFile = QDir::toNativeSeparators(QDir::temp().absolutePath()+"/nextbikefeed_"+randomString()+".lmx");
    //qDebug() << "file: " << _landmarkFile;
    QFile file(_landmarkFile);

    if(file.exists()) {
        file.remove();
    }

    if (!file.open(QFile::WriteOnly|QFile::Truncate))
        return false;

    QTextStream out(&file);

    out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    out << "<lm:lmx xmlns:lm=\"http://www.nokia.com/schemas/location/landmarks/1/0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.nokia.com/schemas/location/landmarks/1/0/lmx.xsd\">\n";
    out << "<lm:landmarkCollection>\n";

    int l = rowCount();
    for(int i=0;i<l;++i) {
        NextbikePlaceItem* place = (NextbikePlaceItem*) readRow(i);
        out << "<lm:landmark>\n";
        out << "  <lm:name>" << place->name() << "</lm:name>\n";
        out << "  <lm:description>" << nameFixup(place) << "</lm:description>\n";
        out << "  <lm:coordinates>\n";
        out << "      <lm:latitude>" << place->lat() << "</lm:latitude>\n";
        out << "      <lm:longitude>" << place->lng() << "</lm:longitude>\n";
        out << "  </lm:coordinates>\n";
        out << "</lm:landmark>\n";
    }

    out << "</lm:landmarkCollection>";

    file.close();

    return true;
}

QString NextbikePlaceModel::exportFilePath()
{
    //qDebug() << "file: " << _landmarkFile;
    return _landmarkFile;
}

bool NextbikePlaceModel::generateDbFile()
{
    //clean
    QDir dir(QDir::temp().absolutePath());
    dir.setNameFilters(QStringList() << "cyklop_*.db");
    dir.setFilter(QDir::Files);
    for(int i=0; i<dir.entryList().size();++i) {
        qDebug() << dir.entryList().at(i);
        dir.remove(dir.entryList().at(i));
    }

    _dbFile = QDir::toNativeSeparators(QDir::temp().absolutePath()+"/cyklop_"+randomString()+".db");
    //qDebug() << "file: " << _dbFile;
    QFile file(_dbFile);

    if(file.exists()) {
        file.remove();
    }

    return true;
}

bool NextbikePlaceModel::checkDbFile()
{
    QFile file(_dbFile);

    if(file.exists()) {
        return true;
    }
    return false;
}

QString NextbikePlaceModel::dBFilePath()
{
    //qDebug() << "file: " << _dbFile;
    return _dbFile;
}

QString NextbikePlaceModel::randomString()
{
    return QString::number(qrand() % 10000);
}

QString NextbikePlaceModel::cityName()
{
    return _cityName;
}

void NextbikePlaceModel::sort(double lat, double lng)
{
    /*QGeoCoordinate curCoord = QGeoCoordinate(lat, lng);
    QList<int> torem = QList<int>();
    int l = this->rowCount();
    for(int i=0; i<l; ++i) {
        NextbikePlaceItem* item = (NextbikePlaceItem*) this->readRow(i);
        QGeoCoordinate coord = QGeoCoordinate(item->lat(), item->lng());
        int distance = (int) curCoord.distanceTo(coord);
        if(distance>5000)
            torem.append(i);
        else
            item->setDistance(distance);
    }
    QList<int>::iterator it;
    for (it = torem.begin(); it != torem.end(); ++it)
        this->removeRow(*it);
    */
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
