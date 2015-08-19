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

void PhotoGallery::removePhoto(QString name)
{
    QList<QObject*>::iterator it;

    for (it = m_photoList.begin(); it != m_photoList.end(); it++) {
        if (Photo *p = dynamic_cast<Photo*>(*it)) {
            if (name == p->name()) {
                m_photoList.removeOne(p);

                //Move photo to "deleted" directory
                string ip = string(PHOTOS_PATH);
                string dest = p->finalResult().toString().replace(0, ip.length(), QString(PHOTOSD_PATH)).toStdString();
                rename(p->finalResult().toString().toStdString().c_str(),
                       dest.c_str());
                //Move all photo part
                for (QList<QObject*>::const_iterator it2 = p->photoPartList().begin(); it2 != p->photoPartList().end(); it2++) {
                    if (PhotoPart const *pp = dynamic_cast<PhotoPart*>(*it2)) {
                        string ip2 = string(PHOTOSS_PATH);
                        string dest = pp->path().toString().replace(0, ip2.length(), QString(PHOTOSDS_PATH)).toStdString();
                        rename(pp->path().toString().toStdString().c_str(),
                               dest.c_str());
                    }
                }
                delete p;
                emit photoListChanged();
                break;
            }
        }
    }
    Serialize();
}

void PhotoGallery::addPhoto(const Value &value, QList<QObject*> &templates)
{
    //Find the right template
    if (value.HasMember("currentTemplate")) {
        QString tmp = QString(value["currentTemplate"].GetString());

        Template *tmp_dest = 0;
        for (QList<QObject*>::const_iterator it = templates.begin(); it != templates.end(); it++) {
            if (Template *t = dynamic_cast<Template*>(*it)) {
                if (tmp == t->getName()) {
                    tmp_dest = t;
                    break;
                }
            }
        }

        if (tmp_dest != 0) {
            Photo *photo = new Photo(value, tmp_dest);
            m_photoList.append(photo);
            QQmlEngine::setObjectOwnership(photo, QQmlEngine::CppOwnership);
        } else {
            CLog::Write(CLog::Debug, "No dest template found");
        }

    } else {
        CLog::Write(CLog::Debug, "No current template");
    }
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

void PhotoGallery::Unserialize(QList<QObject*> &templates)
{
    ifstream jsonFile(GALLERY_FILE, ios::in);

    if (!jsonFile) {
        CLog::Write(CLog::Info, "JSON gallery File not exist");
        return;
    }

    std::string str;

    jsonFile.seekg(0, std::ios::end);
    str.reserve(jsonFile.tellg());
    jsonFile.seekg(0, std::ios::beg);

    str.assign((std::istreambuf_iterator<char>(jsonFile)),
                std::istreambuf_iterator<char>());

    CLog::Write(CLog::Debug, "Fichier json gallery : " + str);

    Document document;
    document.Parse(str.c_str());
    jsonFile.close();


    if (document.HasMember("photos")) {
        const Value& photos = document["photos"];
        if (photos.IsArray()) {
            for (SizeType i = 0; i < photos.Size(); i++) {
                addPhoto(photos[i], templates);
            }
        }
    }

    emit photoListChanged();
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



