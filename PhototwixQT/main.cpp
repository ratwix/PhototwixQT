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
    qmlRegisterType<Template>("com.phototwix.template", 1, 0, "Template");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
