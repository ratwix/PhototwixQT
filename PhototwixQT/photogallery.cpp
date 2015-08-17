#include <dirent.h>
#include <iostream>
#include <fstream>
#include <QQmlEngine>
#include "rapidjson/document.h"
#include <sys/stat.h>
#include <thread>

#include "photogallery.h"
#include "parameters.h"

PhotoGallery::PhotoGallery()
{

}

PhotoGallery::~PhotoGallery()
{
    //Free photos
    CLog::Write(CLog::Debug, "Delete PhotoGallery");


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

void PhotoGallery::Serialize()
{
    m_t = std::thread(&PhotoGallery::SerializeThread, this);
    m_t.join();  //TODO: bad thread management. Have to terminate later
}

void PhotoGallery::SerializeThread()
{
    StringBuffer sb;
    PrettyWriter<StringBuffer> writer(sb);

    writer.StartObject();
    writer.Key("photos");
    writer.StartArray();
    for (QList<QObject*>::const_iterator it = m_photoList.begin(); it != m_photoList.end(); it++) {
        if (Photo *p = dynamic_cast<Photo*>(*it)) {
            p->Serialize(writer);
        } else {
            CLog::Write(CLog::Fatal, "Bad type QObject -> Photo");
        }
    }
    writer.EndArray();
    writer.EndObject();

    //write to file
    std::ofstream jsonFile;
    jsonFile.open(GALLERY_FILE);
    jsonFile << sb.GetString();

    if (!jsonFile.good()) {
        CLog::Write(CLog::Fatal, "Can't write the JSON string to the gallery file!");
    } else {
        CLog::Write(CLog::Debug, "Write the JSON string to the gallery file!");
    }

    jsonFile.close();
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
QUrl PhotoGallery::applicationDirPath() const
{
    return m_applicationDirPath;
}

void PhotoGallery::setApplicationDirPath(const QUrl &applicationDirPath)
{
    m_applicationDirPath = applicationDirPath;
}



