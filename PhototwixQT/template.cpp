#include <QApplication>
#include "template.h"

Template::Template(QString name, Parameters *parameters)
{
    m_parameters = parameters;
    setName(name);
    m_active = false;
    setUrl("file:///" + QGuiApplication::applicationDirPath() + "/" + TEMPLATE_PATH + "/" + name);
}

Template::Template(Value const &value, Parameters *parameters) {
    m_parameters = parameters;
    Unserialize(value);
}

Template::~Template()
{

}

QString Template::getName() const {
    return m_name;
}

void Template::setName(QString name) {
    m_name = name;
}

QUrl Template::getUrl() const {
    return m_url;
}

void Template::setUrl(QUrl url)  {
    m_url = url;
}

bool Template::getActive() const {
    return m_active;
}

void Template::setActive(bool active) {
    if (active != m_active) {
        this->m_active = active;

        CLog::Write(CLog::Info, m_name.toStdString() + " active:" + (this->m_active ? "true" : "false"));
        //Save change to json files
        m_parameters->Serialize();
    }
}

void Template::Serialize(PrettyWriter<StringBuffer> &writer) const {
    writer.StartObject();

    writer.Key("template_name");
    writer.String(m_name.toStdString().c_str());

    writer.Key("url");
    writer.String(m_url.toString().toStdString().c_str());

    writer.Key("active");
    writer.Bool(m_active);

    writer.EndObject();
}


void Template::Unserialize(Value const &value) {
    if (value.HasMember("template_name")) {
        m_name = QString(value["template_name"].GetString());
    }

    if (value.HasMember("url")) {
        m_url = QUrl(value["url"].GetString());
    }

    if (value.HasMember("active")) {
        m_active = value["active"].GetBool();
    }
}

