#include <QFile>
#include <QtDebug>
#include <QByteArray>
#include <iostream>
#include <QFileInfo>

#include "base64.h"

Base64::Base64()
{

}

QString Base64::fileToBase64(QString filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly)) {
       qDebug() << "BASE64 Can't open file" << filename;
    }

    QByteArray loadedArray = file.readAll();
    QByteArray encodedFile = loadedArray.toBase64(QByteArray::Base64UrlEncoding | QByteArray::OmitTrailingEquals);
    QString result = QString(encodedFile.toStdString().c_str());

    qDebug() << "BASE64 FIN" << result.length();
    return result;
}

QString Base64::getFileNameFromPath(QString filename)
{
    QFileInfo fileInfo(filename);

    if (fileInfo.exists()) {
        return fileInfo.fileName();
    }
    return "";
}
