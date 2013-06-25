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

#include <QGeoCoordinate>

#include "listmodel.h"
#include "utils.h"

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
             int uid, double lat,double lng, int bikes, const QString &bikesNumber,
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
public:
    explicit NextbikePlaceModel(Utils *utils, QObject *parent = 0);
    Q_INVOKABLE void init();
    Q_INVOKABLE void sort(double lat, double lng);
    Q_INVOKABLE void sortS();
    Q_INVOKABLE QString cityName();
    Q_INVOKABLE double lat();
    Q_INVOKABLE double lng();
    Q_INVOKABLE int count();
    Q_INVOKABLE QObject* get(int i);

signals:
    void quit();
    void busy();
    void ready();
    void sorted();

public slots:
    void finished(QNetworkReply *reply);
    void readyRead();
    void error(QNetworkReply::NetworkError);

private:
    QNetworkAccessManager manager;
    QNetworkReply *currentReply;
    QByteArray XMLdata;
    QDomElement domElement;
    QString _cityName;
    bool _busy;
    Utils* _utils;
    double _lat;
    double _lng;

    bool parse();
    void createPlaces(); 
    void doSorting();
};

#endif // NEXTBIKEPLACEMODEL_H
