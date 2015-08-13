#include "common.h"


std::string itos(int i) {
    std::ostringstream tmp;
    tmp  << i;
    return tmp.str();
}
