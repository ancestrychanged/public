// commands/shell.c
#include "headers/shell.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "utilities/response.h"
#define INITIAL_BUFFER_SIZE 4096

const char* allowedCommands[] = {
    "dir",
    "echo",
    "type",
    // todo: add more
};
const int numAllowed = sizeof(allowedCommands) / sizeof(allowedCommands[0]);

void handleShell(SOCKET clientSocket, const char* command, int enforceWhitelist) {
    if (command == NULL || strlen(command) == 0) {
        sendResponse(clientSocket, 400, "Bad Request: no command provided");
        return;
    }

    if (enforceWhitelist) {
        int allowed = 0;
        for (int i = 0; i < numAllowed; i++) {
            if (strcmp(command, allowedCommands[i]) == 0) {
                allowed = 1;
                break;
            }
        }
        if (!allowed) {
            sendResponse(clientSocket, 403, "Forbidden: command not whitelisted");
            return;
        }
    }

    printf("executing shell command: %s\n", command);
    FILE* fp = _popen(command, "r");
    if (fp == NULL) {
        sendResponse(clientSocket, 500, "failed to execute command");
        return;
    }

    // dynamic buffer allocation
    // i'm a fool.
    size_t bufferSize = INITIAL_BUFFER_SIZE;
    char* output = (char*)malloc(bufferSize);
    if (!output) {
        _pclose(fp);
        sendResponse(clientSocket, 500, "memory allocation failed");
        return;
    }
    size_t len = 0;
    output[0] = '\0';

    char temp[1024];
    while (fgets(temp, sizeof(temp), fp) != NULL) {
        size_t tempLen = strlen(temp);
        if (len + tempLen + 1 > bufferSize) {
            bufferSize *= 2;
            char* newOutput = (char*)realloc(output, bufferSize);
            if (!newOutput) {
                free(output);
                _pclose(fp);
                sendResponse(clientSocket, 500, "memory reallocation failed");
                return;
            }
            output = newOutput;
        }
        strcpy(output + len, temp);
        len += tempLen;
    }

    _pclose(fp);

    printf("command output: %s\n", output);
    sendResponse(clientSocket, 200, output[0] ? output : "command executed, no output");

    free(output);
}