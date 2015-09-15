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
#include "arduino.h"

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
    Q_PROPERTY(int nbfreephotos READ getNbfreephotos WRITE setNbfreephotos NOTIFY nbfreephotoChanged)
    Q_PROPERTY(float pricephoto READ getPricephoto WRITE setPricephoto NOTIFY pricephotoChanged)
    Q_PROPERTY(bool flipcamera READ getFlipcamera WRITE setFlipcamera NOTIFY flipcameraChanged)
    Q_PROPERTY(bool flipresult READ getFlipresult WRITE setFlipresult NOTIFY flipresultChanged)
    Q_PROPERTY(float volume READ getVolume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(Arduino* arduino READ getArduino WRITE setArduino NOTIFY arduinoChanged)
    Q_PROPERTY(int flashBrightness READ getFlashBrightness WRITE setFlashBrightness NOTIFY flashBrightnessChanged)
    Q_PROPERTY(QString backgroundImage READ getBackgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChange)

public:
    Parameters(QUrl appDirPath);
    ~Parameters();

    Q_INVOKABLE void activeTemplate(QString name);
    Q_INVOKABLE void unactiveTemplate(QString name);
    Q_INVOKABLE void Serialize();
    Q_INVOKABLE Photo* addPhotoToGallerie(QString name, QObject *temp);
    Q_INVOKABLE void printPhoto(QUrl url, bool doubleprint, bool cutprint, bool landscape);
    Q_INVOKABLE void clearGallery();
    Q_INVOKABLE void clearGalleryDeleteImages();
    Q_INVOKABLE void addTemplateFromUrl(QUrl url);
    Q_INVOKABLE void changeBackground(QUrl url);


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

    int getNbfreephotos() const;
    void setNbfreephotos(int nbfreephotos);

    float getPricephoto() const;
    void setPricephoto(float pricephoto);

    bool getFlipcamera() const;
    void setFlipcamera(bool flipcamera);

    bool getFlipresult() const;
    void setFlipresult(bool flipresult);

    float getVolume() const;
    void setVolume(float volume);

    Arduino *getArduino() const;
    void setArduino(Arduino *arduino);

    int getFlashBrightness() const;
    void setFlashBrightness(int flashBrightness);

    QString getBackgroundImage() const;
    void setBackgroundImage(const QString &backgroundImage);

private:
    QList<QObject*>      m_templates;
    QList<QObject*>      m_activesTemplates;
    PhotoGallery*        m_photogallery;
    QUrl                 m_applicationDirPath;
    int                  m_nbprint;
    int                  m_nbfreephotos;
    float                m_pricephoto;
    bool                 m_flipcamera;
    bool                 m_flipresult;
    float                m_volume;
    int                  m_flashBrightness;
    QString              m_backgroundImage;
    Arduino*             m_arduino;

    void addTemplate(QString name);
    void addTemplate(Value const &value);
    void init();
    void readTemplateDir();
    void Unserialize();
    void createFolders();
    void clearGallery(bool del);
signals:
    void templatesChanged();
    void activeTemplatesChanged();
    void photoGalleryChanged();
    void photoGalleryListChanged();
    void applicationDirPathChanged();
    void nbPrintChanged();
    void nbfreephotoChanged();
    void pricephotoChanged();
    void flipcameraChanged();
    void flipresultChanged();
    void volumeChanged();
    void arduinoChanged();
    void flashBrightnessChanged();
    void backgroundImageChange();
};

#endif // CPARAMETERS_H
