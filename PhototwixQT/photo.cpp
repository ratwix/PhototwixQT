#include "photo.h"

Photo::Photo()
{

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

void Photo::addPhotoPart(TemplatePhotoPosition *t)
{

}

Template *Photo::currentTemplate() const
{
    return m_currentTemplate;
}

void Photo::setCurrentTemplate(Template *currentTemplate)
{
    m_currentTemplate = currentTemplate;
}








