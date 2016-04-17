#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
//#include <QtWebEngine/QtWebEngine>

#include "arduino.h"
#include "parameters.h"
#include "filereader.h"
#include "clog.h"
#include "keyemitter.h"
#include "base64.h"
#include "cameraworker.h"
#include "mail.h"



int main(int argc, char *argv[])
{
    //Définition du niveau de log
    CLog::SetLevel(CLog::Warning);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Parameters            parameters(QGuiApplication::applicationDirPath());
    FileReader            fileReader;
    KeyEmitter            keyEmitter;
    Base64                base64;
    CameraWorker          *cameraWorker;
    Mail                  mail(&parameters);


    //mail.setParameters(&parameters);
    cameraWorker = new CameraWorker();

//    QtWebEngine::initialize();

    engine.rootContext()->setContextProperty("base64", &base64);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("parameters", &parameters);
    engine.rootContext()->setContextProperty("photoGallery", parameters.getPhotogallery());
    engine.rootContext()->setContextProperty("fileReader", &fileReader);
    engine.rootContext()->setContextProperty("keyEmitter", &keyEmitter);
    engine.rootContext()->setContextProperty("cameraWorker", cameraWorker);
    engine.rootContext()->setContextProperty("mail", &mail);

    CLog::Write(CLog::Debug, ("Application dir path "  + QGuiApplication::applicationDirPath()).toStdString());

    //Enregistrement des types de donnée
    qmlRegisterType<Template>("com.phototwix.components", 1, 0, "Template");
    qmlRegisterType<TemplatePhotoPosition>("com.phototwix.components", 1, 0, "TemplatePhotoPosition");
    qmlRegisterType<PhotoGallery>("com.phototwix.components", 1, 0, "PhotoGallery");
    qmlRegisterType<Photo>("com.phototwix.components", 1, 0, "Photo");
    qmlRegisterType<PhotoPart>("com.phototwix.components", 1, 0, "PhotoPart");
    qmlRegisterType<Arduino>("com.phototwix.components", 1, 0, "Arduino");
    qmlRegisterType<CameraWorker>("com.phototwix.components", 1, 0, "CameraWorker");
    qmlRegisterType<Mail>("com.phototwix.components", 1, 0, "Mail");

    engine.addImageProvider("camerapreview", cameraWorker);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
