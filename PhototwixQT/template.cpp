#include <QApplication>
#include "template.h"

Template::Template(QString name)
{
    setName(name);
    setUrl("file:///" + QGuiApplication::applicationDirPath() + "/" + TEMPLATE_PATH + "/");
}

Template::~Template()
{

}
