// commands/messagebox.c
#include "headers/messagebox.h"
#include <windows.h>
#include <string.h>
#include "utilities/response.h"

void handleMessageBox(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
    if (argument == NULL || strlen(argument) == 0) {
        sendResponse(clientSocket, 400, "Bad Request: no message provided");
        return;
    }

    const char* title = "hi";
    char* body = (char*)argument;

    char* delimiter = strstr(argument, "||");

    if (delimiter != NULL) {
        *delimiter = '\0'; 
        char* potentialTitle = delimiter + 2;

        while (*potentialTitle == ' ') {
            potentialTitle++;
        }

        if (strlen(potentialTitle) > 0) {
            title = potentialTitle;
        }
    }

    MessageBoxA(NULL, body, title, MB_OK | MB_SYSTEMMODAL);
    sendResponse(clientSocket, 200, "message box shown");
}