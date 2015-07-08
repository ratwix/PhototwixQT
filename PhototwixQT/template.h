#ifndef TEMPLATE_H
#define TEMPLATE_H

#include <QObject>
#include <QUrl>
#include <string>
#include "clog.h"

#include "common.h"

#include "rapidjson/prettywriter.h"
#include "rapidjson/document.h"

using namespace std;
using namespace rapidjson;

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
    QString getName() const;
    void setName(QString name);

    QUrl getUrl() const;
    void setUrl(QUrl url);

    bool getActive() const;
    void setActive(bool active);
    //End of accessors

    void Serialize(PrettyWriter<StringBuffer>& writer) const;
    void Unserialize(Value &value);

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
