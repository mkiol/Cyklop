#ifndef NEXTBIKECITYMODEL_H
#define NEXTBIKECITYMODEL_H

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

#include "listmodel.h"


class NextbikeCityItem : public ListItem
{
    Q_OBJECT

public:
    enum Roles {
        NameRole = Qt::UserRole+1,
        UidRole,
        LatRole,
        LngRole
    };

public:
    NextbikeCityItem(QObject *parent = 0): ListItem(parent) {}
    explicit NextbikeCityItem(const QString &name,
             int uid, double lat,double lng, QObject *parent = 0);
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    inline QString id() const { return m_name; }
    inline QString name() const { return m_name; }
    inline int uid() const { return m_uid; }
    inline double lat() const { return m_lat; }
    inline double lng() const { return m_lng; }

private:
    QString m_name;
    int m_uid;
    double m_lat;
    double m_lng;
};

class NextbikeCityModel : public ListModel
{
    Q_OBJECT
public:
    explicit NextbikeCityModel(QObject *parent = 0);
    Q_INVOKABLE void init();
    Q_INVOKABLE void reload();
    Q_INVOKABLE void sort(double lat, double lng);

signals:
    void quit();
    void busy();
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
    bool _busy;

    bool parse();
    void createCity();
    void sort();
    //bool caseInsensitiveLessThan(ListItem* i1, ListItem* i2);
    
};

#endif // NEXTBIKECITYMODEL_H
