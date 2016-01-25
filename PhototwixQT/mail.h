#ifndef MAIL_H
#define MAIL_H

#include <QObject>
#include <parameters.h>

class Mail : public QObject
{
    Q_OBJECT
public:
    explicit Mail(QObject *parent = 0);

    Parameters *parameters() const;
    void setParameters(Parameters *parameters);

    Q_INVOKABLE void sendMail(QString mail, QString photoPath);
private:
    Parameters *m_parameters;

signals:
    void mailSend();
    void mailFailed();
public slots:
};

#endif // MAIL_H
