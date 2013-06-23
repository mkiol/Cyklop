#ifndef NEXTBIKEPLACEMODEL_H
#define NEXTBIKEPLACEMODEL_H

#include <QAbstractListModel>
#include <QString>
#include <QList>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QBuffer>
#include <QUrl>
#include <QDebug>
#include <QByteArray>
#include <QDomDocument>
#include <QDomNode>
#include <QDomNodeList>
#include <QModelIndex>
#include <QFile>
#include <QDir>
//#include <QtLocation/QGeoCoordinate>

// Use the QtMobility namespace
//QTM_USE_NAMESPACE


#include "listmodel.h"
#include "utils.h"


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
             int uid, double lat,double lng, int bikes, const QString &bikesNumber,
                               QObject *parent = 0);
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    inline QString id() const { return m_name; }
    inline QString name() const { return m_name; }
    inline int uid() const { return m_uid; }
    inline double lat() const { return m_lat; }
    inline double lng() const { return m_lng; }
    inline int bikes() const { return m_bikes; }
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
public:
    explicit NextbikePlaceModel(Utils *utils, QObject *parent = 0);
    Q_INVOKABLE QString exportFilePath();
    Q_INVOKABLE QString dBFilePath();
    Q_INVOKABLE void init();
    Q_INVOKABLE void reload();
    Q_INVOKABLE void sort(double lat, double lng);
    Q_INVOKABLE QString cityName();

signals:
    void quit();
    void busy();
    //void readyToSelect();
    void ready();

public slots:
    void finished(QNetworkReply *reply);
    void readyRead();
    void error(QNetworkReply::NetworkError);

private:
    QNetworkAccessManager manager;
    QNetworkReply *currentReply;
    QByteArray XMLdata;
    QDomElement domElement;
    QString _dbFile;
    QString _landmarkFile;
    QString _cityName;
    bool _busy;
    Utils* _utils;

    bool parse();
    void createPlaces();
    bool generateLmxFile();
    bool generateDbFile();
    bool checkDbFile();
    QString nameFixup(NextbikePlaceItem *place);
    QString randomString();   
};

#endif // NEXTBIKEPLACEMODEL_H
