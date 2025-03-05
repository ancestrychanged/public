// headers/website.h

#ifndef WEBSITE_H
#define WEBSITE_H
#include <winsock2.h>
void handleWebsite(SOCKET clientSocket, const char* argument, int enforceWhitelist);
#endif