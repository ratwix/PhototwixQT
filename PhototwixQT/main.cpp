#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "parameters.h"
#include "clog.h"

int main(int argc, char *argv[])
{
    //Définition du niveau de log
    CLog::SetLevel(CLog::Debug);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Parameters            parameters;


    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("parameters", &parameters);

    //Enregistrement des types de donnée
    qmlRegisterType<Template>("com.phototwix.components", 1, 0, "Template");
    qmlRegisterType<TemplatePhotoPosition>("com.phototwix.components", 1, 0, "TemplatePhotoPosition");
    qmlRegisterType<PhotoGallery>("com.phototwix.components", 1, 0, "PhotoGallery");
    qmlRegisterType<Photo>("com.phototwix.components", 1, 0, "Photo");
    qmlRegisterType<PhotoPart>("com.phototwix.components", 1, 0, "PhotoPart");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
