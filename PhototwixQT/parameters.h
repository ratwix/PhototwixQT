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

#include "rapidjson/prettywriter.h"

using namespace std;
using namespace rapidjson;

class Parameters : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> templates READ getTemplates WRITE setTemplates NOTIFY templatesChanged)
    Q_PROPERTY(QList<QObject*> activesTemplates READ getActivesTemplates WRITE setActivesTemplates NOTIFY activeTemplatesChanged)
public:
    Parameters();
    ~Parameters();

    Q_INVOKABLE void activeTemplate(QString name);
    Q_INVOKABLE void unactiveTemplate(QString name);
    Q_INVOKABLE void Serialize();

    QList<QObject*> getTemplates();
    void setTemplates(QList<QObject*> templates);
    QList<QObject *> getActivesTemplates() const;
    void setActivesTemplates(const QList<QObject *> &activesTemplates);
    void rebuildActivesTemplates();
private:
    QList<QObject*>   m_templates;
    QList<QObject*>   m_activesTemplates;

    void addTemplate(QString name);
    void addTemplate(Value const &value);
    void init();
    void readTemplateDir();
    void Unserialize();
signals:
    void templatesChanged();
    void activeTemplatesChanged();
};

#endif // CPARAMETERS_H
