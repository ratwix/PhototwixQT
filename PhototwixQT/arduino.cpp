#include "arduino.h"
#include <QDebug>
#include <QCoreApplication>

QT_USE_NAMESPACE

Arduino::Arduino()
{
    m_arduinoActive = false;
    openPort();
    connect(&m_serialPort, SIGNAL(readyRead()), SLOT(handleReadyRead()));
    connect(&m_serialPort, SIGNAL(bytesWritten(qint64)), SLOT(handleBytesWritten(qint64)));
    connect(&m_serialPort, SIGNAL(error(QSerialPort::SerialPortError)), SLOT(handleError(QSerialPort::SerialPortError)));
}


Arduino::~Arduino()
{
    m_serialPort.close();
}

void Arduino::flashSwitchOn()
{
    QByteArray bites;
    char c = LED_ON;
    bites.append(c);
    bites.append('\n');
    bites.append('\r');
    write(bites);
}

void Arduino::flashSwitchOff()
{
    QByteArray bites;
    char c = LED_OFF;
    bites.append(c);
    bites.append('\n');
    bites.append('\r');
    write(bites);
}

void Arduino::flashSetIntensity(int i)
{
    QByteArray bites;
    char c = LED_INTENSITY;
    char it = (char) i;
    bites.append(c);
    bites.append(it);
    bites.append('\n');
    bites.append('\r');
    write(bites);
}

void Arduino::setNbPhotoPrint(int nbPhotos)
{
    QByteArray bites;
    char c = NB_PHOTO;
    bites.append(c);
    unsigned char r1 = nbPhotos >> 8; //byte des dizaines
    unsigned char r2 = nbPhotos; //byte des unites
    bites.append(r1);
    bites.append(r2);
    bites.append('\n');
    bites.append('\r');
    write(bites);
}

void Arduino::setPhotoPrice(float photoPrice)
{
    QByteArray bites;
    int result = photoPrice * 100;
    char c = PHOTO_PRICE;
    bites.append(c);
    unsigned char r1 = result >> 8; //byte des dizaines
    unsigned char r2 = result; //byte des unites
    bites.append(r1);
    bites.append(r2);
    bites.append('\n');
    bites.append('\r');
    write(bites);
}

void Arduino::setNbPhotoFree(int nbPhotos)
{
    QByteArray bites;
    char c = PHOTO_FREE;
    bites.append(c);
    unsigned char r1 = nbPhotos >> 8; //byte des dizaines
    unsigned char r2 = nbPhotos; //byte des unites
    bites.append(r1);
    bites.append(r2);
    bites.append('\n');
    bites.append('\r');
    write(bites);
}

void Arduino::handleReadyRead()
{
    if (m_arduinoActive) {
        QByteArray bites = m_serialPort.readAll();
        if (bites.size() > 0) {
            if (bites.at(0) == PHOTO_BUTTON_PUSHED) {
               qDebug() << "Photo Button Pushed";
               emit photoButtonPushed();
            } else if (bites.at(0) == PHOTO_BUTTON_RELEASE) {
               qDebug() << "Photo Button Release";
               emit photoButtonRelease();
            } else if (bites.at(0) == PRINT_BUTTON_PUSHED) {
                qDebug() << "Print Button Pushed";
                emit printButtonPushed();
             }else if (bites.at(0) == PRINT_BUTTON_RELEASE) {
                qDebug() << "Print Button Release";
                emit printButtonRelease();
             } else {
                qDebug() << "Error:" << bites << " " << bites.at(0) << " " << PHOTO_BUTTON_PUSHED;
            }
        }
    }
}

void Arduino::handleBytesWritten(qint64 bytes)
{
    if (m_arduinoActive) {
        m_bytesWritten += bytes;
        if (m_bytesWritten == m_writeData.size()) {
            m_bytesWritten = 0;
            qDebug() << QObject::tr("Data successfully sent to port %1").arg(m_serialPort.portName()) << endl;
        }
    }
}

void Arduino::write(const QByteArray &writeData)
{
    if (m_arduinoActive) {
        m_writeData = writeData;

        qint64 bytesWritten = m_serialPort.write(writeData);

        if (bytesWritten == -1) {
            qDebug() << QObject::tr("Failed to write the data to port %1, error: %2").arg(m_serialPort.portName()).arg(m_serialPort.errorString()) << endl;
        } else if (bytesWritten != m_writeData.size()) {
            qDebug() << QObject::tr("Failed to write all the data to port %1, error: %2").arg(m_serialPort.portName()).arg(m_serialPort.errorString()) << endl;
        }
    }
}


void Arduino::handleError(QSerialPort::SerialPortError serialPortError)
{
    if (serialPortError == QSerialPort::ReadError) {
        qDebug() << QObject::tr("An I/O error occurred while reading the data from port %1, error: %2").arg(m_serialPort.portName()).arg(m_serialPort.errorString()) << endl;
    }
}

void Arduino::openPort()
{
    QString serialPortName = "";

    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts()) {
        qDebug() << "Name        : " << info.portName();
        qDebug() << "Description : " << info.description();
        qDebug() << "Manufacturer: " << info.manufacturer();

        if (info.manufacturer() ==  MANUFACTURER) {
            serialPortName = info.portName();
        }
    }

    if (serialPortName == "") {
        qDebug() << QObject::tr("Failed to serial port") << endl;
    } else {
        qDebug() << QObject::tr("Try to open port ") << serialPortName << endl;
    }

    //Open port

    m_serialPort.setPortName(serialPortName);
    m_serialPort.setBaudRate(QSerialPort::Baud9600);
    m_serialPort.setDataBits(QSerialPort::Data8);
    m_serialPort.setParity(QSerialPort::NoParity);
    m_serialPort.setStopBits(QSerialPort::OneStop);
    m_serialPort.setFlowControl(QSerialPort::NoFlowControl);
    m_serialPort.setSettingsRestoredOnClose(true);



    if (!m_serialPort.open(QIODevice::ReadWrite)) {
        qDebug() << QObject::tr("Failed to open port %1, error: %2").arg(serialPortName).arg(m_serialPort.errorString()) << endl;
        m_arduinoActive = false;
        return;
    }
    m_arduinoActive = true;
}
