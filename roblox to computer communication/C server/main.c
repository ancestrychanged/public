// ./main.c 

#include <winsock2.h>
#include <stdio.h>
#include <string.h>
#include "headers/messagebox.h"
#include "headers/showimage.h"
#include "headers/website.h"
#include "headers/volume.h"
#include "headers/shell.h"
#include "utilities/response.h"

#define PORT 8080
const char* AUTH_KEY = "meowzerss";
int enforceWhitelist = 0;

typedef struct {
    const char* name;
    void (*handler)(SOCKET, const char*, int);
} Command;

Command commands[] = {
    // don't forget to add commands here
    {"messagebox", handleMessageBox},
    {"showimage", handleShowImage},
    {"website", handleWebsite},
    {"volume", handleVolume},
    {"shell", handleShell}
};

const int numCommands = sizeof(commands) / sizeof(commands[0]);

// function to extract a header value from the request headers
// thanks stackoverflow <3
const char* getHeaderValue(const char* headers, const char* headerName) {
    char search[256];
    sprintf(search, "%s: ", headerName);
    const char* line = strstr(headers, search);
    if (line) {
        line += strlen(search);
        const char* end = strstr(line, "\r\n");
        if (end) {
            size_t len = end - line;
            char* value = (char*)malloc(len + 1);
            if (value) {
                strncpy(value, line, len);
                value[len] = '\0';
                return value;
            }
        }
    }
    return NULL;
}

int main(int argc, char* argv[]) {
    // cli arguments to disable whitelist
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--disable-whitelist") == 0) {
            enforceWhitelist = 0;
            printf("whitelist enforcement disabled\n");
            break;
        }
    }

    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        printf("WSAStartup failed\n");
        return 1;
    }

    SOCKET serverSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (serverSocket == INVALID_SOCKET) {
        printf("socket failed\n");
        WSACleanup();
        return 1;
    }

    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    serverAddr.sin_port = htons(PORT);

    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
        printf("bind failed\n");
        closesocket(serverSocket);
        WSACleanup();
        return 1;
    }

    if (listen(serverSocket, SOMAXCONN) == SOCKET_ERROR) {
        printf("listen failed\n");
        closesocket(serverSocket);
        WSACleanup();
        return 1;
    }

    printf("server active on port %d\n", PORT);

    while (1) {
        SOCKET clientSocket = accept(serverSocket, NULL, NULL);
        if (clientSocket == INVALID_SOCKET) {
            printf("accept failed\n");
            continue;
        }

        char buffer[4096]; // pls god strike me down for using 4kb mem
        int bytesRead = recv(clientSocket, buffer, sizeof(buffer) - 1, 0);
        if (bytesRead > 0) {
            buffer[bytesRead] = '\0';

            char* headersStart = strstr(buffer, "\r\n");
            if (headersStart) {
                headersStart += 2;
                char* headersEnd = strstr(headersStart, "\r\n\r\n");
                if (headersEnd) {
                    
                    *headersEnd = '\0'; 
                    const char* authHeader = getHeaderValue(headersStart, "Authorization");
                    *headersEnd = '\r';

                    if (authHeader) {
                        char expected[256];
                        sprintf(expected, "Bearer %s", AUTH_KEY);
                        if (strcmp(authHeader, expected) == 0) {
                            // ok we ballin. authorization is ok so now we proceed
                            char* body = headersEnd + 4;
                            if (body[0] == '/') {
                                char* commandStr = strtok(body + 1, " ");
                                if (commandStr != NULL) {
                                    char* argument = strtok(NULL, "");
                                    int found = 0;
                                    for (int i = 0; i < numCommands; i++) {
                                        if (strcmp(commandStr, commands[i].name) == 0) {
                                            commands[i].handler(clientSocket, argument, enforceWhitelist);
                                            found = 1;
                                            break;
                                        }
                                    }
                                    if (!found) {
                                        sendResponse(clientSocket, 404, "unknown command");
                                    }
                                } else {
                                    sendResponse(clientSocket, 400, "Bad Request: no command");
                                }
                            } else {
                                sendResponse(clientSocket, 400, "Bad Request: command must start with a slash");
                            }
                        } else {
                            sendResponse(clientSocket, 401, "Unauthorized: invalid key");
                        }
                        free((void*)authHeader);
                    } else {
                        sendResponse(clientSocket, 401, "Unauthorized: missing Authorization header");
                    }
                } else {
                    sendResponse(clientSocket, 400, "Bad Request: malformed request");
                }
            } else {
                sendResponse(clientSocket, 400, "Bad Request: no headers");
            }
        }

        closesocket(clientSocket);
    }

    // i know this is unreachable code
    // just included it here for completeness
    closesocket(serverSocket);
    WSACleanup();
    return 0;
}
