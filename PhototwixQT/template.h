#ifndef TEMPLATE_H
#define TEMPLATE_H

#include <QObject>
#include <QUrl>
#include <string>

#include "common.h"

using namespace std;

class Template : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)

public:
    Template(QString name);
    ~Template();

    //Accesseurs
    void setName(QString name) {
        m_name = name;
        emit nameChanged(name);
    }
    QString name() const { return m_name; }

    void setUrl(QUrl url) {
        m_url = url;
        emit urlChanged(url);
    }
    QUrl url() const { return m_url; }

signals:
    void nameChanged(QString);
    void urlChanged(QUrl);

private:
    bool    active;
    QString m_name;
    QUrl    m_url;
};

#endif // TEMPLATE_H
