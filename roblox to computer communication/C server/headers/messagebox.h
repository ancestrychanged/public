// headers/messagebox.h

#ifndef MESSAGEBOX_H
#define MESSAGEBOX_H
#include <winsock2.h>
void handleMessageBox(SOCKET clientSocket, const char* argument, int enforceWhitelist);
#endif