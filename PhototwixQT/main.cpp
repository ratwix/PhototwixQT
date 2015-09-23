#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "arduino.h"
#include "parameters.h"
#include "filereader.h"
#include "clog.h"
#include "keyemitter.h"



int main(int argc, char *argv[])
{
    //Définition du niveau de log
    CLog::SetLevel(CLog::Debug);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Parameters            parameters(QGuiApplication::applicationDirPath());
    FileReader            fileReader;
    KeyEmitter            keyEmitter;

    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("parameters", &parameters);
    engine.rootContext()->setContextProperty("fileReader", &fileReader);
    engine.rootContext()->setContextProperty("keyEmitter", &keyEmitter);

    CLog::Write(CLog::Debug, ("Application dir path "  + QGuiApplication::applicationDirPath()).toStdString());

    //Enregistrement des types de donnée
    qmlRegisterType<Template>("com.phototwix.components", 1, 0, "Template");
    qmlRegisterType<TemplatePhotoPosition>("com.phototwix.components", 1, 0, "TemplatePhotoPosition");
    qmlRegisterType<PhotoGallery>("com.phototwix.components", 1, 0, "PhotoGallery");
    qmlRegisterType<Photo>("com.phototwix.components", 1, 0, "Photo");
    qmlRegisterType<PhotoPart>("com.phototwix.components", 1, 0, "PhotoPart");
    qmlRegisterType<Arduino>("com.phototwix.components", 1, 0, "Arduino");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
