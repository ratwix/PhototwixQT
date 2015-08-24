#ifndef ARDUINO_H
#define ARDUINO_H

#include <QSerialPortInfo>
#include <QtSerialPort/QSerialPort>

#include <QTextStream>
#include <QTimer>
#include <QByteArray>
#include <QObject>

#define MANUFACTURER          "PJRC.COM, LLC."

#define PHOTO_BUTTON_PUSHED   'p'
#define PHOTO_BUTTON_RELEASE  'q'

#define PRINT_BUTTON_PUSHED   'r'
#define PRINT_BUTTON_RELEASE  's'

#define LED_ON                'O'
#define LED_OFF               'F'
#define LED_INTENSITY         'l' //folow by a chat representing the value

#define NB_PHOTO              'N'
#define PHOTO_PRICE           'R'
#define PHOTO_FREE            'F'

QT_USE_NAMESPACE


class Arduino : public QObject
{
    Q_OBJECT

public:
    Arduino();
    //Arduino(QSerialPort *serialPort, QObject *parent = 0);
    ~Arduino();

    Q_INVOKABLE void flashSwitchOn();
    Q_INVOKABLE void flashSwitchOff();
    Q_INVOKABLE void flashSetIntensity(int i);
    Q_INVOKABLE void setNbPhotoPrint(int nbPhotos);
    Q_INVOKABLE void setPhotoPrice(float photoPrice);
    Q_INVOKABLE void setNbPhotoFree(int nbPhotos);


signals:
    void photoButtonPushed();
    void photoButtonRelease();
    void printButtonPushed();
    void printButtonRelease();

private slots:
    void handleReadyRead();
    void handleBytesWritten(qint64 bytes);
    void handleError(QSerialPort::SerialPortError error);

private:
    void write(const QByteArray &writeData);
    void openPort();

    QSerialPort m_serialPort;
    QByteArray  m_readData;
    QByteArray  m_writeData;
    qint64      m_bytesWritten;
    bool        m_arduinoActive;
};


#endif // ARDUINO_H
