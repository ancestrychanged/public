// commands/playsound.c

#include "headers/playsound.h"
#include <windows.h>
#include <mmsystem.h>
#include <string.h>
#include "utilities/response.h"
#include <stdio.h>

void handlePlaySound(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
    if (argument == NULL || strlen(argument) == 0) {
        sendResponse(clientSocket, 400, "Bad Request: no sound filename provided");
        return;
    }

    char exePath[MAX_PATH];
    GetModuleFileNameA(NULL, exePath, MAX_PATH);

    char* lastSlash = strrchr(exePath, '\\');
    if (lastSlash) *lastSlash = '\0';

    char path[256];
    sprintf(path, "%s\\music\\%s", exePath, argument);
    
    // does the file exist?
    FILE* file = fopen(path, "r");
    if (file == NULL) {
        sendResponse(clientSocket, 404, "sound file not found");
        return;
    }
    fclose(file);

    // stop any currently playing sound
    mciSendStringA("close all", NULL, 0, NULL);

    char mciCommand[512];
    sprintf(mciCommand, "open \"%s\" type mpegvideo alias mysound", path);
    
    MCIERROR error = mciSendStringA(mciCommand, NULL, 0, NULL);
    if (error) {
        char errorMessage[256];
        mciGetErrorStringA(error, errorMessage, sizeof(errorMessage));
        printf("mci error: %s\n", errorMessage);
        sendResponse(clientSocket, 500, "failed to open sound file");
        return;
    }
    
    error = mciSendStringA("play mysound", NULL, 0, NULL);
    if (error) {
        char errorMessage[256];
        mciGetErrorStringA(error, errorMessage, sizeof(errorMessage));
        printf("mci error: %s\n", errorMessage);
        mciSendStringA("close mysound", NULL, 0, NULL);
        sendResponse(clientSocket, 500, "failed to play sound");
        return;
    }
    
    sendResponse(clientSocket, 200, "sound playing - use /playsound to stop current and play new sound");
}