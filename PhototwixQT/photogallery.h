#ifndef PHOTOGALLERY_H
#define PHOTOGALLERY_H

#include <QObject>
#include "template.h"
#include "photo.h"

class Photo;
class PhotoGallery : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> photoList READ photoList WRITE setPhotoList NOTIFY photoListChanged)
public:
    PhotoGallery();
    Q_INVOKABLE Photo* addPhoto(QString name, Template *t);


    QList<QObject*> photoList() const;
    void setPhotoList(const QList<QObject *> &photoList);

private:
    QList<QObject*> m_photoList; //List of all photos in Gallery. List of Photo class

signals:
    void photoListChanged();

public slots:
};

#endif // GALLERY_H
