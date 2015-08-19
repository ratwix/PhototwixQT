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
#include "photogallery.h"

#include "rapidjson/prettywriter.h"

using namespace std;
using namespace rapidjson;

class PhotoGallery;
class Photo;
class Parameters : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> templates READ getTemplates WRITE setTemplates NOTIFY templatesChanged)
    Q_PROPERTY(QList<QObject*> activesTemplates READ getActivesTemplates WRITE setActivesTemplates NOTIFY activeTemplatesChanged)
    Q_PROPERTY(PhotoGallery* photoGallery READ getPhotogallery WRITE setPhotogallery NOTIFY photoGalleryChanged)
    Q_PROPERTY(QUrl applicationDirPath READ getApplicationDirPath WRITE setApplicationDirPath NOTIFY applicationDirPathChanged)
    Q_PROPERTY(int nbprint READ getNbprint WRITE setNbprint NOTIFY nbPrintChanged)

public:
    Parameters(QUrl appDirPath);
    ~Parameters();

    Q_INVOKABLE void activeTemplate(QString name);
    Q_INVOKABLE void unactiveTemplate(QString name);
    Q_INVOKABLE void Serialize();
    Q_INVOKABLE Photo* addPhotoToGallerie(QString name, QObject *temp);
    Q_INVOKABLE void printPhoto(QUrl url);


    QList<QObject*> getTemplates();
    void setTemplates(QList<QObject*> templates);
    QList<QObject *> getActivesTemplates() const;
    void setActivesTemplates(const QList<QObject *> &activesTemplates);
    void rebuildActivesTemplates();


    PhotoGallery *getPhotogallery() const;
    void setPhotogallery(PhotoGallery *photogallery);

    QUrl getApplicationDirPath() const;
    void setApplicationDirPath(const QUrl &applicationDirPath);

    int getNbprint() const;
    void setNbprint(int nbprint);

private:
    QList<QObject*>      m_templates;
    QList<QObject*>      m_activesTemplates; //TODO: workaround to display a list of photo gallery
    PhotoGallery*        m_photogallery;
    QUrl                 m_applicationDirPath;
    int                  m_nbprint;

    void addTemplate(QString name);
    void addTemplate(Value const &value);
    void init();
    void readTemplateDir();
    void Unserialize();
    void createFolders();
signals:
    void templatesChanged();
    void activeTemplatesChanged();
    void photoGalleryChanged();
    void photoGalleryListChanged();
    void applicationDirPathChanged();
    void nbPrintChanged();
};

#endif // CPARAMETERS_H
