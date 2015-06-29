#ifndef PARAMETERS_H
#define PARAMETERS_H

#include <QObject>
#include <iostream>
#include <vector>
#include <utility>

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
private:
    vector<Template>   templates;
    void addTemplate(QString name);
};

#endif // CPARAMETERS_H
