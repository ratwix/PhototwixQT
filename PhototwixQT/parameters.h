#ifndef PARAMETERS_H
#define PARAMETERS_H

#include <QObject>
#include <QList>
#include <QVariant>
#include <iostream>
#include <vector>
#include <utility>

#include "common.h"
#include "template.h"



using namespace std;

class Parameters : public QObject
{
    Q_OBJECT
public:
    Parameters();
    ~Parameters();

    Q_INVOKABLE void activeTemplate(QString name);
    Q_INVOKABLE void unactiveTemplate(QString name);
    Q_INVOKABLE QVariant getAllTemplates() { return QVariant::fromValue(templates);}

private:
    QList<Template*>   templates;
    void addTemplate(QString name);

    void init();
    void readTemplateDir();
};

#endif // CPARAMETERS_H
