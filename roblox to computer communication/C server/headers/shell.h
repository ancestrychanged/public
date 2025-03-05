// headers/shell.h

#ifndef SHELL_H
#define SHELL_H
#include <winsock2.h>
void handleShell(SOCKET clientSocket, const char* command, int enforceWhitelist);
#endif