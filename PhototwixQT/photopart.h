#ifndef PHOTOPART_H
#define PHOTOPART_H

#include <QObject>
#include "templatephotoposition.h"

class TemplatePhotoPosition;
class PhotoPart : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QString pathS READ pathS WRITE setPathS)
    Q_PROPERTY(TemplatePhotoPosition* photoPosition READ photoPosition WRITE setPhotoPosition NOTIFY photoPositionChanged)
public:
    PhotoPart();
    PhotoPart(TemplatePhotoPosition *tpp);
    ~PhotoPart();

    TemplatePhotoPosition *photoPosition() const;
    void setPhotoPosition(TemplatePhotoPosition *photoPosition);

    QUrl path() const;
    void setPath(const QUrl &path);
    QString pathS() const;
    void setPathS(const QString &path);

    void Serialize(PrettyWriter<StringBuffer>& writer) const;
private:
    QUrl                    m_path;
    TemplatePhotoPosition*  m_photoPosition;
signals:
    void                    pathChanged();
    void                    photoPositionChanged();
public slots:
};

#endif // PHOTOPART_H
