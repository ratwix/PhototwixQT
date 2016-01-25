#include "mail.h"
#include "clog.h"

Mail::Mail(QObject *parent) : QObject(parent)
{

}

Parameters *Mail::parameters() const
{
    return m_parameters;
}

void Mail::setParameters(Parameters *parameters)
{
    m_parameters = parameters;
}

void Mail::sendMail(QString mail, QString photoPath)
{
     CLog::Write(CLog::Debug, "Envoie du mail" + mail.toStdString() + " photo:" + photoPath.toStdString());
}

