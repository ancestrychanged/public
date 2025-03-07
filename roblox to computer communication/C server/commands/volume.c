// commands/volume.c

#include "headers/volume.h"
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include "utilities/response.h"

void handleVolume(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
    if (argument == NULL || strlen(argument) == 0) {
        sendResponse(clientSocket, 400, "Bad Request: no volume value provided");
        return;
    }

    int value = atoi(argument);
    if (value < 0 || value > 100) {
        sendResponse(clientSocket, 400, "Bad Request: volume must be 0-100");
        return;
    }
    
    int scaledValue = (value * 65535) / 100;
    char command[256];
    sprintf(command, "nircmd.exe setsysvolume %d", scaledValue);
    
    system(command);
    sendResponse(clientSocket, 200, "volume set");
}