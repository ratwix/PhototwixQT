#ifndef TEMPLATE_H
#define TEMPLATE_H

#include <QObject>
#include <QUrl>
#include <string>
#include "clog.h"

#include "common.h"

using namespace std;

class Template : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QUrl url READ getUrl WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(bool active READ getActive WRITE setActive NOTIFY activeChanged)

public:
    Template(QString name);
    ~Template();

    //Property Accesseurs
    void setName(QString name) {
        m_name = name;
        emit nameChanged(name);
    }
    QString getName() const { return m_name; }

    void setUrl(QUrl url) {
        m_url = url;
        emit urlChanged(url);
    }
    QUrl getUrl() const { return m_url; }

    bool getActive() { return m_active; }
    void setActive(bool active) {
        this->m_active = active;

        CLog::Write(CLog::Info, m_name.toStdString() + " active:" + (this->m_active ? "true" : "false"));

        emit activeChanged(m_active);
    }
    //End of accessors

signals:
    void nameChanged(QString);
    void urlChanged(QUrl);
    void activeChanged(bool);

private:
    bool    m_active;
    QString m_name;
    QUrl    m_url;
};

#endif // TEMPLATE_H
