#include "parameters.h"

#include <errno.h>
#include <dirent.h>
#include <iostream>
#include <fstream>
#include <QQmlEngine>
#include <QDir>
#include <QtConcurrent>
#include <QFile>

#include <string>
#include <stdio.h>

#include "clog.h"
#include "rapidjson/document.h"
#include <sys/stat.h>
#include <sys/types.h>
#include <photogallery.h>

using namespace std;
using namespace rapidjson;

inline bool file_exists (const std::string& name) {
  struct stat buffer;
  return (stat (name.c_str(), &buffer) == 0);
}

static std::string pexec(const char* cmd) {
    FILE* pipe = popen(cmd, "r");
    if (!pipe) return "ERROR";
    char buffer[128];
    std::string result = "";
    while (!feof(pipe)) {
        if (fgets(buffer, 128, pipe) != NULL)
            result += buffer;
    }
    pclose(pipe);
    return result;
}

static bool is_number(const std::string& s)
{
    std::string::const_iterator it = s.begin();
    while (it != s.end() && std::isdigit(*it)) ++it;
    return !s.empty() && it == s.end();
}

Parameters::Parameters(QUrl appDirPath)
{
    m_applicationDirPath = appDirPath;
    CLog::Write(CLog::Info, "C++ : Initialisation des parametres");
    init();
}

Parameters::~Parameters()
{
    CLog::Write(CLog::Debug, "Delete Parameters");
    //Free templates
    QList<QObject*>::iterator it;

    for (it = m_templates.begin(); it != m_templates.end(); it++) {
        delete *it;
    }

    delete m_arduino;
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
        QQmlEngine::setObjectOwnership(t, QQmlEngine::CppOwnership);
        m_templates.append(t);
    }
}

void Parameters::addTemplate(Value const &value) {
    CLog::Write(CLog::Info, "Load Template ");
    //TODO : check if template file exists, or remove it
    if (file_exists(string(TEMPLATE_PATH) + "/" + value["template_name"].GetString())) {
        Template *t = new Template(value, this);
        QQmlEngine::setObjectOwnership(t, QQmlEngine::CppOwnership);
        QFileInfo fileInf(t->getUrl().toLocalFile());
        if (fileInf.exists()) {
            m_templates.append(t);
        } else {
            delete t;
        }
    } else {
        CLog::Write(CLog::Info, "Template file not found " + string(value["template_name"].GetString()));
    }
}

void Parameters::addTemplateFromUrl(QUrl url)
{
    QFileInfo fileInf(url.toLocalFile());
    QString filename = fileInf.fileName();

    //Copy file to local template directory
    if (fileInf.exists()) {
        QFile::copy(fileInf.absoluteFilePath(), m_applicationDirPath.toString() + "/templates/" + filename);
        Template *t = new Template(filename, this);
        QQmlEngine::setObjectOwnership(t, QQmlEngine::CppOwnership);
        m_templates.append(t);
        emit templatesChanged();
    }
}

void Parameters::changeBackground(QUrl url) {
    QFileInfo fileInf(url.toLocalFile());
    QString filename = fileInf.fileName();

    //Copy file to local template directory
    if (fileInf.exists()) {
        QFile::copy(fileInf.absoluteFilePath(), QString(BACKGROUND_PATH) + "/" + filename);
        setBackgroundImage("file:///" + QString(BACKGROUND_PATH) + "/" + filename);
    } else {
        setBackgroundImage("");
    }

}

void Parameters::updatePaperPrint()
{
    if (system(NULL)) {
        string result;

        string cmd = m_applicationDirPath.toString().toStdString() + "/print/get_paper.sh";
        CLog::Write(CLog::Debug, "Paper cmd :" + cmd);
        result = pexec(cmd.c_str());
        CLog::Write(CLog::Debug, "Paper result :" + result);
        if (is_number(result)) {
            setPaperprint(atoi(result.c_str()));
        } else {
            setPaperprint(699);
        }
    }
}

void Parameters::haltSystem()
{
    if (system(NULL)) {
        string cmd = m_applicationDirPath.toString().toStdString() + "/scripts/halt.sh";
        pexec(cmd.c_str());
    }
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
 */
void Parameters::init() {
    m_nbprint = 0;
    m_nbfreephotos = 250;
    m_pricephoto = 0.4;
    m_flipcamera = false;
    m_flipresult = false;
    m_volume = 1.0;
    m_backgroundImage = "";
    m_cameraHight = 1728;
    m_cameraWidth = 2592;
    m_blockPrint = false;
    m_blockPrintNb = 700;
    m_paperprint = 0;
    m_arduino = new Arduino();
    m_sharing = true;
    m_sharingBaseUrl = "";
    m_eventCode = "";
    QQmlEngine::setObjectOwnership(m_arduino, QQmlEngine::CppOwnership);
    createFolders();
    m_photogallery = new PhotoGallery();
    m_photogallery->setApplicationDirPath(m_applicationDirPath);

    Unserialize();

    m_photogallery->Unserialize(m_templates); //unserialize current gallery

    //Read all .png and .jpg files in tempalte directory
    readTemplateDir();

    updatePaperPrint();

    Serialize();

    rebuildActivesTemplates();

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
QList<QObject *> Parameters::getActivesTemplates() const
{
    return m_activesTemplates;
}

void Parameters::setActivesTemplates(const QList<QObject *> &activesTemplates)
{
    m_activesTemplates = activesTemplates;
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
        writer.Key("nbPrint");
        writer.Int(m_nbprint);

        writer.Key("nbFreePhoto");
        writer.Int(m_nbfreephotos);

        writer.Key("pricephoto");
        writer.Double(m_pricephoto);

        writer.Key("flipcamera");
        writer.Bool(m_flipcamera);

        writer.Key("flipresult");
        writer.Bool(m_flipresult);

        writer.Key("volume");
        writer.Double(m_volume);

        writer.Key("flashBrightness");
        writer.Int(m_flashBrightness);

        writer.Key("cameraHeight");
        writer.Int(m_cameraHight);

        writer.Key("cameraWidth");
        writer.Int(m_cameraWidth);

        writer.Key("blockPrint");
        writer.Bool(m_blockPrint);

        writer.Key("blockPrintNb");
        writer.Int(m_blockPrintNb);

        writer.Key("paperprint");
        writer.Int(m_paperprint);

        writer.Key("backgroundImage");
        writer.String(m_backgroundImage.toStdString().c_str());

        writer.Key("sharing");
        writer.Bool(m_sharing);

        writer.Key("sharingBaseUrl");
        writer.String(m_sharingBaseUrl.toStdString().c_str());

        writer.Key("eventCode");
        writer.String(m_eventCode.toStdString().c_str());

        m_arduino->setPhotoPrice(m_pricephoto);
        m_arduino->setNbPhotoFree(m_nbfreephotos);
        m_arduino->setNbPhotoPrint(m_nbprint);
        m_arduino->flashSetIntensity(m_flashBrightness);

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

    //string jsonurl = string(m_applicationDirPath.toString().toStdString() + CONFIG_FILE);
    //CLog::Write(CLog::Debug, "JSon String " + jsonurl);

    jsonFile.open(CONFIG_FILE);
    jsonFile << sb.GetString();

    if (!jsonFile.good()) {
        CLog::Write(CLog::Fatal, "Can't write the JSON string to the file!");
    } else {
        CLog::Write(CLog::Debug, "Write the JSON string to the file!");
    }

    jsonFile.close();
}

Photo* Parameters::addPhotoToGallerie(QString name, QObject *temp)
{
    if (Template *t = dynamic_cast<Template*>(temp)) {
        CLog::Write(CLog::Info, "Creation d'une nouvelle photo " + name.toStdString());
        Photo *p = m_photogallery->addPhoto(name, t);
        emit photoGalleryChanged();
        emit photoGalleryListChanged();
        return p;
    } else {
        CLog::Write(CLog::Warning, "Can't cast template");
    }
    return NULL;
}

extern void printThread(QUrl m_applicationDirPath, QUrl url, bool doubleprint, bool cutprint, bool landscape) {
    if (system(NULL)) {
        string cmd = m_applicationDirPath.toString().toStdString() + "/print/print.sh" +
                " duplicate:" + (doubleprint ? "true":"false") +
                " portrait:" + (landscape?"false":"true") +
                " cutter:" + (cutprint?"true":"false") +
                " " + url.toString().toStdString();
        //std::replace(cmd.begin(), cmd.end(), '/', '\\'); //TODO: uncomment on windows
        cmd = cmd;
        CLog::Write(CLog::Debug, "Print cmd :" + cmd);
        system(cmd.c_str());
    }
}

void Parameters::printPhoto(QUrl url, bool doubleprint, bool cutprint, bool landscape)
{
    CLog::Write(CLog::Debug, "Print file : " + url.toString().toStdString() + " double:" + (doubleprint ? "true":"false") + " cut:" + (cutprint?"true":"false") + " landscape:" + (landscape?"true":"false"));
    //TODO: print & manage

    QtConcurrent::run(printThread, m_applicationDirPath, url, doubleprint, cutprint, landscape);
    //printThread(m_applicationDirPath, url, doubleprint, cutprint, landscape);

    //On incremente le conteur
    setNbprint(m_nbprint + 1);
}

void Parameters::clearGallery()
{
    clearGallery(false);
}

void Parameters::clearGalleryDeleteImages()
{
    clearGallery(true);
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

    //CLog::Write(CLog::Debug, "Fichier json : " + str);

    Document document;
    document.Parse(str.c_str());

    jsonFile.close();

    if (document.HasMember("nbPrint")) {
        m_nbprint = document["nbPrint"].GetInt();
    }

    if (document.HasMember("nbFreePhoto")) {
        m_nbfreephotos = document["nbFreePhoto"].GetInt();
    }

    if (document.HasMember("pricephoto")) {
        m_pricephoto = document["pricephoto"].GetDouble();
    }

    if (document.HasMember("flipcamera")) {
        m_flipcamera = document["flipcamera"].GetBool();
    }

    if (document.HasMember("flipresult")) {
       m_flipresult = document["flipresult"].GetBool();
    }

    if (document.HasMember("volume")) {
       m_volume = document["volume"].GetDouble();
    }

    if (document.HasMember("flashBrightness")) {
       m_flashBrightness = document["flashBrightness"].GetInt();
    }

    if (document.HasMember("backgroundImage")) {
       m_backgroundImage = QString(document["backgroundImage"].GetString());
    }

    if (document.HasMember("cameraHeight")) {
       m_cameraHight = document["cameraHeight"].GetInt();
    }


    if (document.HasMember("cameraWidth")) {
       m_cameraWidth = document["cameraWidth"].GetInt();
    }

    if (document.HasMember("blockPrint")) {
       m_blockPrint = document["blockPrint"].GetBool();
    }

    if (document.HasMember("blockPrintNb")) {
       m_blockPrintNb = document["blockPrintNb"].GetInt();
    }

    if (document.HasMember("paperprint")) {
        m_paperprint = document["paperprint"].GetInt();
    }

    if (document.HasMember("sharing")) {
        m_sharing = document["sharing"].GetBool();
    }

    if (document.HasMember("sharingBaseUrl")) {
        m_sharingBaseUrl = QString(document["sharingBaseUrl"].GetString());
    }

    if (document.HasMember("eventCode")) {
        m_eventCode = QString(document["eventCode"].GetString());
    }

    if (document.HasMember("templates")) {
        const Value& templates = document["templates"];
        if (templates.IsArray()) {
            for (SizeType i = 0; i < templates.Size(); i++) {
                addTemplate(templates[i]);
            }
        }
    }
}

void Parameters::createFolders()
{
    QDir d;

    d.mkpath(QString(PHOTOS_PATH));
    d.mkpath(QString(PHOTOSSD_PATH));
    d.mkpath(QString(PHOTOSS_PATH));
    d.mkpath(QString(PHOTOSD_PATH));
    d.mkpath(QString(PHOTOSDS_PATH));
    d.mkpath(QString(BACKGROUND_PATH));
}

static void delAllFileInDirectory(const char* p) {
    QString path(p);
    QDir dir(path);
    dir.setNameFilters(QStringList() << "*.*");
    dir.setFilter(QDir::Files);
    foreach(QString dirFile, dir.entryList())
    {
        dir.remove(dirFile);
    }
}

void Parameters::clearGallery(bool del)
{
    delete m_photogallery;
    m_photogallery = new PhotoGallery();
    m_photogallery->setApplicationDirPath(m_applicationDirPath);


    if (del) {
        delAllFileInDirectory(PHOTOS_PATH);
        delAllFileInDirectory(PHOTOSSD_PATH);
        delAllFileInDirectory(PHOTOSS_PATH);
        delAllFileInDirectory(PHOTOSD_PATH);
        delAllFileInDirectory(PHOTOSDS_PATH);
    }

    Serialize();
    m_photogallery->Serialize();
    emit photoGalleryChanged();
}

void Parameters::rebuildActivesTemplates()
{
    m_activesTemplates.clear();

    QList<QObject*>::iterator it;

    for (QList<QObject*>::iterator it = m_templates.begin(); it != m_templates.end(); it++) {
        if (Template *t = dynamic_cast<Template*>(*it)) {
            if (t->getActive()) {
                m_activesTemplates.push_back(t);
                emit activeTemplatesChanged();
            }
        }
    }

}

PhotoGallery *Parameters::getPhotogallery() const
{
    return m_photogallery;
}

void Parameters::setPhotogallery(PhotoGallery *photogallery)
{
    m_photogallery = photogallery;
}
QUrl Parameters::getApplicationDirPath() const
{
    return m_applicationDirPath;
}

void Parameters::setApplicationDirPath(const QUrl &applicationDirPath)
{
    CLog::Write(CLog::Debug, QUrl("Application dir path " + applicationDirPath.toString()).toString().toStdString());
    m_applicationDirPath = applicationDirPath;
}
int Parameters::getNbprint() const
{
    return m_nbprint;
}

void Parameters::setNbprint(int nbprint)
{
    m_nbprint = nbprint;
    Serialize();
    emit nbPrintChanged();
}
int Parameters::getNbfreephotos() const
{
    return m_nbfreephotos;
}

void Parameters::setNbfreephotos(int nbfreephotos)
{
    m_nbfreephotos = nbfreephotos;
    Serialize();
    emit nbfreephotoChanged();
}
float Parameters::getPricephoto() const
{
    return m_pricephoto;
}

void Parameters::setPricephoto(float pricephoto)
{
    m_pricephoto = pricephoto;
    Serialize();
    emit pricephotoChanged();
}
bool Parameters::getFlipcamera() const
{
    return m_flipcamera;
}

void Parameters::setFlipcamera(bool flipcamera)
{
    m_flipcamera = flipcamera;
    Serialize();
    emit flipcameraChanged();
}
bool Parameters::getFlipresult() const
{
    return m_flipresult;
}

void Parameters::setFlipresult(bool flipresult)
{
    m_flipresult = flipresult;
    Serialize();
    emit flipresultChanged();
}
float Parameters::getVolume() const
{
    return m_volume;
}

void Parameters::setVolume(float volume)
{
    m_volume = volume;
    Serialize();
    emit volumeChanged();
}
Arduino *Parameters::getArduino() const
{
    return m_arduino;
}

void Parameters::setArduino(Arduino *arduino)
{
    m_arduino = arduino;
}

int Parameters::getFlashBrightness() const
{
    return m_flashBrightness;
}

void Parameters::setFlashBrightness(int flashBrightness)
{
    m_flashBrightness = flashBrightness;
    m_arduino->flashSetIntensity(flashBrightness);
    Serialize();
    emit flashBrightnessChanged();
}
QString Parameters::getBackgroundImage() const
{
    return m_backgroundImage;
}

void Parameters::setBackgroundImage(const QString &backgroundImage)
{
    m_backgroundImage = backgroundImage;
    Serialize();
    emit backgroundImageChange();
}
int Parameters::getCameraHight() const
{
    return m_cameraHight;
}

void Parameters::setCameraHight(int cameraHight)
{
    m_cameraHight = cameraHight;
    Serialize();
    emit cameraHeightChange();
}
int Parameters::getCameraWidth() const
{
    return m_cameraWidth;
}

void Parameters::setCameraWidth(int cameraWidth)
{
    m_cameraWidth = cameraWidth;
    Serialize();
    emit cameraWidthChange();
}
bool Parameters::getBlockPrint() const
{
    return m_blockPrint;
}

void Parameters::setBlockPrint(bool blockPrint)
{
    m_blockPrint = blockPrint;
    Serialize();
    emit blockPrintChanged();
}
int Parameters::getBlockPrintNb() const
{
    return m_blockPrintNb;
}

void Parameters::setBlockPrintNb(int blockPrintNb)
{
    m_blockPrintNb = blockPrintNb;
    Serialize();
    emit blockPrintNbChanged();
}
int Parameters::paperprint() const
{
    return m_paperprint;
}

void Parameters::setPaperprint(int paperprint)
{
    m_paperprint = paperprint;
    Serialize();
    emit paperprintChanged();
}
bool Parameters::getSharing() const
{
    return m_sharing;
}

void Parameters::setSharing(bool sharing)
{
    m_sharing = sharing;
    Serialize();
    emit sharingChanged();
}
QString Parameters::getSharingBaseUrl() const
{
    return m_sharingBaseUrl;
}

void Parameters::setSharingBaseUrl(const QString &sharingBaseUrl)
{
    m_sharingBaseUrl = sharingBaseUrl;
    Serialize();
    emit sharingBaseUrlChanged();
}
QString Parameters::getEventCode() const
{
    return m_eventCode;
}

void Parameters::setEventCode(const QString &eventCode)
{
    m_eventCode = eventCode;
    Serialize();
    emit eventCodeChanged();
}








