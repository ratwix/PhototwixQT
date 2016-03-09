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
    Q_PROPERTY(int cameraHeight READ getCameraHight WRITE setCameraHight NOTIFY cameraHeightChange)
    Q_PROPERTY(int cameraWidth READ getCameraWidth WRITE setCameraWidth NOTIFY cameraWidthChange)
    Q_PROPERTY(bool blockPrint READ getBlockPrint WRITE setBlockPrint NOTIFY blockPrintChanged)
    Q_PROPERTY(int blockPrintNb READ getBlockPrintNb WRITE setBlockPrintNb NOTIFY blockPrintNbChanged)
    Q_PROPERTY(int paperprint READ paperprint WRITE setPaperprint NOTIFY paperprintChanged)
    Q_PROPERTY(bool sharing READ getSharing WRITE setSharing NOTIFY sharingChanged)
    Q_PROPERTY(QString sharingBaseUrl READ getSharingBaseUrl WRITE setSharingBaseUrl NOTIFY sharingBaseUrlChanged)
    Q_PROPERTY(QString eventCode READ getEventCode WRITE setEventCode NOTIFY eventCodeChanged)
    Q_PROPERTY(bool mailActive READ getMailActive WRITE setMailActive NOTIFY mailChange)
    Q_PROPERTY(QString mailFrom READ getMailFrom WRITE setMailFrom NOTIFY mailChange)
    Q_PROPERTY(QString mailCc READ getMailCc WRITE setMailCc NOTIFY mailChange)
    Q_PROPERTY(QString mailBcc READ getMailBcc WRITE setMailBcc NOTIFY mailChange)
    Q_PROPERTY(QString mailSmtp READ getMailSmtp WRITE setMailSmtp NOTIFY mailChange)
    Q_PROPERTY(QString mailPort READ getMailPort WRITE setMailPort NOTIFY mailChange)
    Q_PROPERTY(QString mailUsername READ getMailUsername WRITE setMailUsername NOTIFY mailChange)
    Q_PROPERTY(QString mailPassword READ getMailPassword WRITE setMailPassword NOTIFY mailChange)
    Q_PROPERTY(QString mailSubject READ getMailSubject WRITE setMailSubject NOTIFY mailChange)
    Q_PROPERTY(QString mailContent READ getMailContent WRITE setMailContent NOTIFY mailChange)
    Q_PROPERTY(int countdownDelay READ getCountdownDelay WRITE setCountdownDelay NOTIFY countdownDelayChange)



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
    Q_INVOKABLE void deleteTemplateFromName(QString name);
    Q_INVOKABLE void changeBackground(QUrl url);
    Q_INVOKABLE void updatePaperPrint();
    Q_INVOKABLE void haltSystem();


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

    int getCameraHight() const;
    void setCameraHight(int cameraHight);

    int getCameraWidth() const;
    void setCameraWidth(int cameraWidth);



    bool getBlockPrint() const;
    void setBlockPrint(bool blockPrint);

    int getBlockPrintNb() const;
    void setBlockPrintNb(int blockPrintNb);

    int paperprint() const;
    void setPaperprint(int paperprint);

    bool getSharing() const;
    void setSharing(bool sharing);

    QString getSharingBaseUrl() const;
    void setSharingBaseUrl(const QString &sharingBaseUrl);

    QString getEventCode() const;
    void setEventCode(const QString &eventCode);

    bool getMailActive() const;
    void setMailActive(bool mailActive);

    QString getMailFrom() const;
    void setMailFrom(const QString &mailFrom);

    QString getMailCc() const;
    void setMailCc(const QString &mailCc);

    QString getMailBcc() const;
    void setMailBcc(const QString &mailBcc);

    QString getMailSmtp() const;
    void setMailSmtp(const QString &mailSmtp);

    QString getMailPort() const;
    void setMailPort(const QString &mailPort);

    QString getMailUsername() const;
    void setMailUsername(const QString &mailUsername);

    QString getMailPassword() const;
    void setMailPassword(const QString &mailPassword);

    QString getMailSubject() const;
    void setMailSubject(const QString &mailSubject);

    void setMailContent(const QString &mailContent);
    QString getMailContent() const;

    int getCountdownDelay() const;
    void setCountdownDelay(int countdownDelay);

private:
    QList<QObject*>      m_templates;
    QList<QObject*>      m_activesTemplates;
    PhotoGallery*        m_photogallery;
    QUrl                 m_applicationDirPath;
    int                  m_nbprint;
    int                  m_nbfreephotos;
    bool                 m_blockPrint;
    int                  m_blockPrintNb;
    float                m_pricephoto;
    bool                 m_flipcamera;
    bool                 m_flipresult;
    float                m_volume;
    int                  m_flashBrightness;
    int                  m_cameraHight;
    int                  m_cameraWidth;
    int                  m_paperprint;
    QString              m_backgroundImage;
    Arduino*             m_arduino;
    bool                 m_sharing;
    QString              m_sharingBaseUrl;
    QString              m_eventCode;
    bool                 m_mailActive;
    QString              m_mailFrom;
    QString              m_mailCc;
    QString              m_mailBcc;
    QString              m_mailSmtp;
    QString              m_mailPort;
    QString              m_mailUsername;
    QString              m_mailPassword;
    QString              m_mailSubject;
    QString              m_mailContent;
    int                  m_countdownDelay;


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
    void cameraHeightChange();
    void cameraWidthChange();
    void blockPrintChanged();
    void blockPrintNbChanged();
    void paperprintChanged();
    void sharingChanged();
    void sharingBaseUrlChanged();
    void eventCodeChanged();
    void mailChange();
    void countdownDelayChange();
};

#endif // CPARAMETERS_H
