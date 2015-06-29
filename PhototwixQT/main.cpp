#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "parameters.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Parameters            parameters;


    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("parameters", &parameters);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
