#ifndef PHOTOGALLERY_H
#define PHOTOGALLERY_H

#include <QObject>
#include <thread>
#include "template.h"
#include "photo.h"

class Photo;
class PhotoGallery : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> photoList READ photoList WRITE setPhotoList NOTIFY photoListChanged)
public:
    PhotoGallery();
    ~PhotoGallery();
    Q_INVOKABLE Photo* addPhoto(QString name, Template *t);
    Q_INVOKABLE void Serialize();
                void Unserialize(QList<QObject*> &templates);
    QList<QObject*> photoList() const;
    void setPhotoList(const QList<QObject *> &photoList);

    QUrl applicationDirPath() const;
    void setApplicationDirPath(const QUrl &applicationDirPath);

private:
    QList<QObject*> m_photoList; //List of all photos in Gallery. List of Photo class
    QUrl            m_applicationDirPath;
    void            SerializeThread();
    void            addPhoto(Value const &value, QList<QObject*> &templates);
    std::thread     m_t;
signals:
    void photoListChanged();

public slots:
};

#endif // GALLERY_H
