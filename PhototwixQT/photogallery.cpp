#include <QQmlEngine>
#include "photogallery.h"

PhotoGallery::PhotoGallery()
{

}

PhotoGallery::~PhotoGallery()
{
    //Free photos
    CLog::Write(CLog::Debug, "Delete Photo Gallery");


    QList<QObject*>::iterator it;

    for (it = m_photoList.begin(); it != m_photoList.end(); it++) {
        delete *it;
    }
}

Photo* PhotoGallery::addPhoto(QString name, Template *t)
{
    Photo *p = new Photo(name, t);
    m_photoList.append(p);
    QQmlEngine::setObjectOwnership(p, QQmlEngine::CppOwnership);
    emit photoListChanged();
    return p;
}

QList<QObject *> PhotoGallery::photoList() const
{
    CLog::Write(CLog::Debug, "Get Photo list " + itos(m_photoList.length()));
    return m_photoList;
}

void PhotoGallery::setPhotoList(const QList<QObject *> &photoList)
{
    m_photoList = photoList;
    emit photoListChanged();
}
