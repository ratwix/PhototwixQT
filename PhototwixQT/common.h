#ifndef COMMON
#define COMMON

#include <sstream>
#include <string>

#define TEMPLATE_PATH       string(m_applicationDirPath.toString().toStdString() + "/templates").c_str()
#define TEMPLATE_PATH2      string(parameters->getApplicationDirPath().toString().toStdString() + "/templates")

#define CONFIG_FILE         string(m_applicationDirPath.toString().toStdString() + "/config.json").c_str()

#define PHOTO_ASPECT_RATIO  1.5


std::string itos(int i);

#endif // COMMON
