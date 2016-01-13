#ifndef BASE64_H
#define BASE64_H

#include <QObject>

class Base64 : public QObject
{
    Q_OBJECT
public:
    Base64();
    Q_INVOKABLE QString fileToBase64(QString filename);
    Q_INVOKABLE QString getFileNameFromPath(QString filename);
};

#endif // BASE64_H
