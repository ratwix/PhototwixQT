#include "photogallery.h"

PhotoGallery::PhotoGallery()
{

}

PhotoGallery::~PhotoGallery()
{
    //Free photos
    QList<QObject*>::iterator it;

    for (it = m_photoList.begin(); it != m_photoList.end(); it++) {
        delete *it;
    }
}

Photo* PhotoGallery::addPhoto(QString name, Template *t)
{
    Photo *p = new Photo(name, t);
    m_photoList.append(p);
    return p;
}

QList<QObject *> PhotoGallery::photoList() const
{
    return m_photoList;
}

void PhotoGallery::setPhotoList(const QList<QObject *> &photoList)
{
    m_photoList = photoList;
}
