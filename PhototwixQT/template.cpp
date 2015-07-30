#include <QApplication>
#include <sstream>
#include "template.h"

Template::Template()
{
    m_parameters = 0;
    setName("error");
    m_active = false;
}

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
    //Free templatesPhotoPosition
    QList<QObject*>::iterator it;

    for (it = m_templatePhotoPositions.begin(); it != m_templatePhotoPositions.end(); it++) {
        delete *it;
    }
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
        emit activeChanged();
        m_parameters->rebuildActivesTemplates();
    }
}

QList<QObject *> Template::templatePhotoPositions() const
{
    return m_templatePhotoPositions;
}

void Template::setTemplatePhotoPositions(const QList<QObject *> &templatePhotoPositions)
{
    m_templatePhotoPositions = templatePhotoPositions;
}

void Template::Serialize(PrettyWriter<StringBuffer> &writer) const {
    writer.StartObject();

    writer.Key("template_name");
    writer.String(m_name.toStdString().c_str());

    writer.Key("url");
    writer.String(m_url.toString().toStdString().c_str());

    writer.Key("active");
    writer.Bool(m_active);

    //Serialisation des TemplatePhotoPosition
    QList<QObject*>::const_iterator it;

    writer.Key("templatesPhotoPositions");
    writer.StartArray();

    for (it = m_templatePhotoPositions.begin(); it != m_templatePhotoPositions.end(); it++) {
        TemplatePhotoPosition *tpp = dynamic_cast<TemplatePhotoPosition*>(*it);
        if (tpp != 0) {
            tpp->Serialize(writer);
        }
    }

    writer.EndArray();

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

    if (value.HasMember("templatesPhotoPositions")) {
        const Value& templatesPhotoPositions = value["templatesPhotoPositions"];
        if (templatesPhotoPositions.IsArray()) {
            for (SizeType i = 0; i < templatesPhotoPositions.Size(); i++) {
                addTemplatePhotoPosition(templatesPhotoPositions[i]);
            }
        }
    }
}

void Template::addTemplatePhotoPosition(const Value &value)
{
    std::stringstream sstm;
    sstm << "Unserialise new Template Photo Position : " << m_templatePhotoPositions.count() << " for template " << m_name.toStdString();
    CLog::Write(CLog::Info, sstm.str());

    TemplatePhotoPosition *t = new TemplatePhotoPosition(value);

    m_templatePhotoPositions.append(t);
    t->setNumber(m_templatePhotoPositions.count());
}

void Template::addTemplatePhotoPosition() {
    std::stringstream sstm;
    sstm << "Add a new Template Photo Position : " << m_templatePhotoPositions.count() << " for template " << m_name.toStdString();
    CLog::Write(CLog::Info, sstm.str());

    TemplatePhotoPosition *t = new TemplatePhotoPosition();

    m_templatePhotoPositions.append(t);

    t->setNumber(m_templatePhotoPositions.count());
}

void Template::deleteTemplatePhotoPosition(int i)
{
    std::stringstream sstm;
    sstm << "Delete Template Photo Position at position : " << i << " for template " << m_name.toStdString();
    CLog::Write(CLog::Info, sstm.str());

    m_templatePhotoPositions.removeAt(i - 1);

    QList<QObject*>::iterator it;
    i = 1;

    for (it = m_templatePhotoPositions.begin(); it != m_templatePhotoPositions.end(); it++) {
        TemplatePhotoPosition *tpp = dynamic_cast<TemplatePhotoPosition*>(*it);

        if (tpp != 0) {
            tpp->setNumber(i++);
        }
    }
}
