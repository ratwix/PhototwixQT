#include <QApplication>
#include "template.h"

Template::Template(QString name)
{
    setName(name);
    setUrl("file:///" + QGuiApplication::applicationDirPath() + "/" + TEMPLATE_PATH + "/" + name);
}

Template::~Template()
{

}

QString Template::getName() const {
    return m_name;
}

void Template::setName(QString name) {
    m_name = name;
    emit nameChanged(name);
}

QUrl Template::getUrl() const {
    return m_url;
}

void Template::setUrl(QUrl url)  {
    m_url = url;
    emit urlChanged(url);
}

bool Template::getActive() const {
    return m_active;
}

void Template::setActive(bool active) {
    this->m_active = active;

    CLog::Write(CLog::Info, m_name.toStdString() + " active:" + (this->m_active ? "true" : "false"));

    emit activeChanged(m_active);
}

void Template::Serialize(PrettyWriter<StringBuffer> &writer) const {
    writer.StartObject();

    writer.Key("template_name");
    writer.String(m_name.toStdString().c_str());

    writer.Key("url");
    writer.String(m_url.toString().toStdString().c_str());

    writer.EndObject();
}


void Template::Unserialize(Value &value) {
    if (value.HasMember("template_name")) {
        m_name = QString(value["template_name"].GetString());
    }
    if (value.HasMember("url")) {
        m_url = QUrl(value["url"].GetString());
    }
}

