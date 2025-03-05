// headers/volume.h

#ifndef VOLUME_H
#define VOLUME_H
#include <winsock2.h>
void handleVolume(SOCKET clientSocket, const char* argument, int enforceWhitelist);
#endif