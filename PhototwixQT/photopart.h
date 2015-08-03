#ifndef PHOTOPART_H
#define PHOTOPART_H

#include <QObject>
#include "templatephotoposition.h"

class TemplatePhotoPosition;
class PhotoPart : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl path READ path WRITE setPath NOTIFY pathChanged)
public:
    PhotoPart();

    TemplatePhotoPosition *photoPosition() const;
    void setPhotoPosition(TemplatePhotoPosition *photoPosition);

    QUrl path() const;
    void setPath(const QUrl &path);

private:
    QUrl                    m_path;
    TemplatePhotoPosition*  m_photoPosition;
signals:
    void                    pathChanged();
public slots:
};

#endif // PHOTOPART_H
