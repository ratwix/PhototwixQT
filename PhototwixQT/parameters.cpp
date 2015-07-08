#include "parameters.h"

#include <direct.h>
#include <errno.h>
#include <dirent.h>

#include "clog.h"
#include "rapidjson/document.h"

using namespace rapidjson;

Parameters::Parameters()
{
    CLog::Write(CLog::Info, "C++ : Initialisation des parametres");
    init();
}

Parameters::~Parameters()
{
    //Free templates
    QList<QObject*>::iterator it;

    for (it = m_templates.begin(); it != m_templates.end(); it++) {
        delete *it;
    }
}

void Parameters::addTemplate(QString name) {
    CLog::Write(CLog::Info, "Add Template " + name.toStdString());

    Template *t = new Template(name);
    m_templates.append(t);
    emit templatesChanged();
}

void Parameters::activeTemplate(QString name) {
    CLog::Write(CLog::Info, "Enable Template " + name.toStdString());
}

void Parameters::unactiveTemplate(QString name) {
    CLog::Write(CLog::Info, "Disable Template " + name.toStdString());
}

/**
 * @brief Parameters::ini
 *
 * Méthode d'initialisation des paramètres
 * * Charge la base de parametres actuels       //TODO
 * * Charge la base de photos actuels           //TODO
 * * Charge les nouveaux templates              //TODO
 */
void Parameters::init() {

    //Read all .png and .jpg files in tempalte directory
    readTemplateDir();

    Serialize();
}

/**
 * @brief Parameters::readTemplateDir
 * Read all template in template path and create Templates
 * Do not create template if template is already configured //TODO
 */
void Parameters::readTemplateDir() {
    DIR *dir;
    struct dirent *file;

    dir = opendir(TEMPLATE_PATH); //"." refers to the current dir
    if (!dir) {
        CLog::Write(CLog::Fatal, string("opendir() ") + TEMPLATE_PATH + " failure; terminating");
        exit(1);
    }

    errno=0;
    while ((file = readdir(dir))) {
        string fn = string(file->d_name);
        string ext = fn.substr(fn.find_last_of(".") + 1);
        if (ext == "png" || ext == "jpg" || ext == "gif") {
            CLog::Write(CLog::Debug, "Nouveau template " + fn);
            addTemplate(QString(fn.c_str()));
        } else {
            CLog::Write(CLog::Debug, "Not a template " + fn);
        }
    }
    if (errno){
        CLog::Write(CLog::Fatal, string("readdir() ") + TEMPLATE_PATH + " failure; terminating");
        exit(1);
    }
    closedir(dir);
}

QList<QObject*> Parameters::getTemplates() {
    return m_templates;
}

void Parameters::setTemplates(QList<QObject*> templates) {
    this->m_templates = templates;
    emit templatesChanged();
}


/**
 * @brief Parameters::Serialize
 * Save parameters to JSon file
 */

void Parameters::Serialize() {
    StringBuffer sb;
    PrettyWriter<StringBuffer> writer(sb);

    writer.StartObject();
        //save standard elements

        //save template definition

        writer.Key("templates");
        writer.StartArray();
        for (QList<QObject*>::const_iterator it = m_templates.begin(); it != m_templates.end(); it++) {
            if (Template *t = dynamic_cast<Template*>(*it)) {
                t->Serialize(writer);
            } else {
                CLog::Write(CLog::Fatal, "Bad type QObject -> Template");
            }
        }
        writer.EndArray();

    writer.EndObject();

    CLog::Write(CLog::Debug, sb.GetString());
}

void Parameters::Unserialize() {
    StringBuffer sb;

    Document document;
    document.Parse(sb.GetString());

    if (document.HasMember("templates")) {
        const Value& templates = document["templates"];
        if (templates.IsArray()) {
        /*
            for (Value::ConstMemberIterator it = templates.MemberBegin(); it != templates.MemberEnd(); it++) {

            }
        */
        }
    }
}
