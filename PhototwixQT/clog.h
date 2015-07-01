#ifndef CLOG_H
#define CLOG_H

#include <cstdio>
#include <cstdarg>
#include <string>

using namespace std;

class CLog
{
public:
    enum { All=0, Debug, Info, Warning, Error, Fatal, None };
    static void Write(int nLevel, const char *szFormat);
    static void Write(int nLevel, const string szFormat);
    static void SetLevel(int nLevel);

protected:
    static void CheckInit();
    static void Init();

private:
    CLog();
    ~CLog();
    static bool m_bInitialised;
    static int  m_nLevel;
};

#endif // CLOG_H
