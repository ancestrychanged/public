// headers/showimage.h

#ifndef SHOWIMAGE_H
#define SHOWIMAGE_H
#include <winsock2.h>
void handleShowImage(SOCKET clientSocket, const char* argument, int enforceWhitelist);
#endif