#include "photogallery.h"

PhotoGallery::PhotoGallery()
{

}

Photo* PhotoGallery::addPhoto(QString name, Template *t)
{
    Photo *p = new Photo();
    p->setName(name);
    p->setCurrentTemplate(t);
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


