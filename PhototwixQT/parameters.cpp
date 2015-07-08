#include "parameters.h"

#include <direct.h>
#include <errno.h>
#include <dirent.h>
#include <iostream>
#include <fstream>

#include "clog.h"
#include "rapidjson/document.h"

using namespace std;
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
    bool find = false;
    //Research if template already exist in base, already configured
    for (QList<QObject*>::iterator it = m_templates.begin(); it != m_templates.end(); it++) {
        if (Template *t = dynamic_cast<Template*>(*it)) {
            if (t->getName() == name) {
                find = true;
                CLog::Write(CLog::Debug, "Template " + name.toStdString() + " already configured");
                break;
            }
        }

    }

    if (!find) {
        CLog::Write(CLog::Info, "Add Template " + name.toStdString());
        Template *t = new Template(name, this);
        m_templates.append(t);
    }
}

void Parameters::addTemplate(Value const &value) {
    CLog::Write(CLog::Info, "Load Template ");
    Template *t = new Template(value, this);
    m_templates.append(t);
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
    Unserialize();

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
            addTemplate(QString(fn.c_str()));
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

    //write to file
    std::ofstream jsonFile;

    jsonFile.open(CONFIG_FILE);
    jsonFile << sb.GetString();

    if (!jsonFile.good()) {
        CLog::Write(CLog::Fatal, "Can't write the JSON string to the file!");
    } else {
        CLog::Write(CLog::Debug, "Write the JSON string to the file!");
    }

    jsonFile.close();
}

void Parameters::Unserialize() {
    ifstream jsonFile(CONFIG_FILE, ios::in);

    if (!jsonFile) {
        CLog::Write(CLog::Info, "JSON File not exist");
        return;
    }

    std::string str;

    jsonFile.seekg(0, std::ios::end);
    str.reserve(jsonFile.tellg());
    jsonFile.seekg(0, std::ios::beg);

    str.assign((std::istreambuf_iterator<char>(jsonFile)),
                std::istreambuf_iterator<char>());

    CLog::Write(CLog::Debug, "Fichier json : " + str);

    Document document;
    document.Parse(str.c_str());

    jsonFile.close();

    if (document.HasMember("templates")) {
        const Value& templates = document["templates"];
        if (templates.IsArray()) {
            for (SizeType i = 0; i < templates.Size(); i++) {
                addTemplate(templates[i]);
            }
        }
    }
}
