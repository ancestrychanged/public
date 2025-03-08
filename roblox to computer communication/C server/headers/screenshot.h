// headers/screenshot.h

#ifndef SCREENSHOT_H
#define SCREENSHOT_H
#include <winsock2.h>
void handleScreenshot(SOCKET clientSocket, const char* argument, int enforceWhitelist);
#endif