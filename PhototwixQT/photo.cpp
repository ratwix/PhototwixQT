#include <sstream>
#include <string>
#include "photo.h"

Photo::Photo()
{

}

Photo::Photo(QString name, Template *t)
{
    m_name = name;
    m_currentTemplate = t;
    //For all photo template position, add a new photopart

    QList<QObject*>::iterator it;

    if (t) {
        QList<QObject *> tppList = t->templatePhotoPositions();

        for (it = tppList.begin(); it != tppList.end(); it++) {
            QObject *tppo = (*it);
            if (TemplatePhotoPosition* tpp = dynamic_cast<TemplatePhotoPosition*>(tppo)) {
                addPhotoPart(tpp);
            } else {
                CLog::Write(CLog::Warning, "Unable to cast TemplatePhotoPosition");
            }

        }
    }
}

Photo::~Photo()
{
    QList<QObject*>::iterator it;

    for (it = m_photoPartList.begin(); it != m_photoPartList.end(); it++) {
        delete *it;
    }
}



QUrl Photo::finalResult() const
{
    return m_finalResult;
}

void Photo::setFinalResult(const QUrl &finalResult)
{
    m_finalResult = finalResult;
}
QString Photo::name() const
{
    return m_name;
}

void Photo::setName(const QString &name)
{
    m_name = name;
}
QList<QObject *> Photo::photoPartList() const
{
    ostringstream test;
    test << "Get photo part list :" << m_photoPartList.count() << ":";
    CLog::Write(CLog::Debug, test.str());
    return m_photoPartList;
}

void Photo::setPhotoPartList(const QList<QObject *> &photoPartList)
{
    m_photoPartList = photoPartList;
}

int Photo::nbPrint() const
{
    return m_nbPrint;
}

void Photo::setNbPrint(int nbPrint)
{
    m_nbPrint = nbPrint;
}

Template *Photo::currentTemplate() const
{
    return m_currentTemplate;
}

void Photo::setCurrentTemplate(Template *currentTemplate)
{
    m_currentTemplate = currentTemplate;
}



void Photo::addPhotoPart(TemplatePhotoPosition *t)
{
    PhotoPart* pp = new PhotoPart(t);
    m_photoPartList.append(pp);
}








