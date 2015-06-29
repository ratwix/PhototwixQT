#include "parameters.h"

Parameters::Parameters()
{
    cout << "C++ : Initialisation des parametres" << endl;
}

Parameters::~Parameters()
{

}

void Parameters::addTemplate(QString name) {

}

void Parameters::activeTemplate(QString name) {
    cout << "C++: activation du template " << name.toStdString() << endl;
}

void Parameters::unactiveTemplate(QString name) {
    cout << "C++: désactivation du template " << name.toStdString() << endl;
}
