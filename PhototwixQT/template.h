#ifndef TEMPLATE_H
#define TEMPLATE_H

#include <QObject>
#include <QUrl>
#include <string>

using namespace std;

class Template : public QObject
{
    Q_OBJECT
public:
    Template(QString name, QUrl url);
    ~Template();

private:
    bool    active;
    QString name;
    QUrl    url;
};

#endif // TEMPLATE_H
