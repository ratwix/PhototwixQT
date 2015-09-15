#ifndef COMMON
#define COMMON

#include <sstream>
#include <string>

#define PHOTOS_PATH         string(m_applicationDirPath.toString().toStdString() + "/photos").c_str()
#define PHOTOSSD_PATH       string(m_applicationDirPath.toString().toStdString() + "/photos/sd").c_str()
#define PHOTOSS_PATH        string(m_applicationDirPath.toString().toStdString() + "/photos/single").c_str()
#define PHOTOSD_PATH        string(m_applicationDirPath.toString().toStdString() + "/photos/deleted").c_str()
#define PHOTOSDS_PATH       string(m_applicationDirPath.toString().toStdString() + "/photos/deleted/single").c_str()
#define TEMPLATE_PATH       string(m_applicationDirPath.toString().toStdString() + "/templates").c_str()
#define BACKGROUND_PATH     string(m_applicationDirPath.toString().toStdString() + "/background").c_str()
#define TEMPLATE_PATH2      string(parameters->getApplicationDirPath().toString().toStdString() + "/templates")

#define CONFIG_FILE         string(m_applicationDirPath.toString().toStdString() + "/config.json").c_str()
#define GALLERY_FILE        string(m_applicationDirPath.toString().toStdString() + "/gallery.json").c_str()

std::string itos(int i);

#endif // COMMON
