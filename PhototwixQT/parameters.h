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
    Q_PROPERTY(QList<QObject*> templates READ getTemplates WRITE setTemplates NOTIFY templatesChanged)
public:
    Parameters();
    ~Parameters();

    Q_INVOKABLE void activeTemplate(QString name);
    Q_INVOKABLE void unactiveTemplate(QString name);

    QList<QObject*> getTemplates();
    void setTemplates(QList<QObject*> templates);

private:
    QList<QObject*>   m_templates;
    void addTemplate(QString name);

    void init();
    void readTemplateDir();

signals:
    void templatesChanged();
};

#endif // CPARAMETERS_H
