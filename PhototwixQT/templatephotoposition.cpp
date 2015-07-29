#include <QApplication>
#include <sstream>
#include <string>
#include "templatephotoposition.h"
#include "clog.h"

string d2s(qreal const &q) {
    std::ostringstream strs;
    strs << q;
    return strs.str();
}


TemplatePhotoPosition::TemplatePhotoPosition()
{
    //initialise
    setX(0.1);
    setY(0.1);
    setHeight(0.2);
    setWidth(height() * PHOTO_ASPECT_RATIO);
    setRotate(0);
    setWidth(0.3);
    setXphoto(0);
}

void TemplatePhotoPosition::Serialize(PrettyWriter<StringBuffer> &writer) const {
    //TODO
}

void TemplatePhotoPosition::Unserialize(const Value &value) {
    //TODO
}

int TemplatePhotoPosition::number() const
{
    return m_number;
}

void TemplatePhotoPosition::setNumber(const int &number)
{
    m_number = number;
}


qreal TemplatePhotoPosition::x() const
{
    return m_x;
}

void TemplatePhotoPosition::setX(const qreal &x)
{
    CLog::Write(CLog::Debug, "New X:" + d2s(x));
    m_x = x;
}
qreal TemplatePhotoPosition::y() const
{
    return m_y;
}

void TemplatePhotoPosition::setY(const qreal &y)
{
    CLog::Write(CLog::Debug, "New Y:" + d2s(y));
    m_y = y;
}
qreal TemplatePhotoPosition::rotate() const
{
    return m_rotate;
}

void TemplatePhotoPosition::setRotate(const qreal &rotate)
{
    CLog::Write(CLog::Debug, "New Rotate:" + d2s(rotate));
    m_rotate = rotate;
}
qreal TemplatePhotoPosition::width() const
{
    return m_width;
}

void TemplatePhotoPosition::setWidth(const qreal &width)
{
    CLog::Write(CLog::Debug, "New Width:" + d2s(width));
    m_width = width;
}
qreal TemplatePhotoPosition::height() const
{
    return m_height;
}

void TemplatePhotoPosition::setHeight(const qreal &height)
{
    CLog::Write(CLog::Debug, "New Height:" + d2s(height));
    m_height = height;
}
qreal TemplatePhotoPosition::xphoto() const
{
    return m_xphoto;
}

void TemplatePhotoPosition::setXphoto(const qreal &xphoto)
{
    m_xphoto = xphoto;
}

