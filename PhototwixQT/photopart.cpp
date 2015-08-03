#include "photopart.h"

PhotoPart::PhotoPart()
{

}

TemplatePhotoPosition *PhotoPart::photoPosition() const
{
    return m_photoPosition;
}

void PhotoPart::setPhotoPosition(TemplatePhotoPosition *photoPosition)
{
    m_photoPosition = photoPosition;
}
QUrl PhotoPart::path() const
{
    return m_path;
}

void PhotoPart::setPath(const QUrl &path)
{
    m_path = path;
}




