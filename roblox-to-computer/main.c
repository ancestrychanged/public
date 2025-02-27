#include <stdio.h>
#include <winsock2.h>
#include <windows.h>
#include <string.h>

#pragma comment(lib, "ws2_32.lib")

int initWinsock() {
    WSADATA wsaData;
    return WSAStartup(MAKEWORD(2, 2), &wsaData);
}

void startServer() {
    SOCKET serverSocket, clientSocket;
    struct sockaddr_in serverAddr, clientAddr;
    int addrLen = sizeof(clientAddr);
    char buffer[1024];

    if (initWinsock() != 0) {
        printf("winsock init fail\n");
        return;
    }

    serverSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (serverSocket == INVALID_SOCKET) {
        printf("socket creation fail\n");
        return;
    }

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(8080);
    serverAddr.sin_addr.s_addr = INADDR_ANY;

    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
        printf("binding fail\n");
        return;
    }

    if (listen(serverSocket, 5) == SOCKET_ERROR) {
        printf("listening fail\n");
        return;
    }

    printf("server is active\n");

    while (1) {
        clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &addrLen);
        if (clientSocket == INVALID_SOCKET) {
            printf("client connection fail\n");
            continue;
        }

        int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);
        if (bytesRead > 0) {
            buffer[bytesRead] = '\0';
            printf("request:\n%s\n", buffer);

            char *body = strstr(buffer, "\r\n\r\n"); // wtf is stackoverflow is on about? why do i have to do this??
            if (body != NULL) {
                body += 4; // skip the "\r\n\r\n"
                if (strlen(body) > 0) {
                    HWND hwnd = GetConsoleWindow();
                    ShowWindow(hwnd, SW_RESTORE);
                    SetForegroundWindow(hwnd);

                    int msgResult = MessageBoxA(NULL, body, "test", MB_OKCANCEL);
                    if (msgResult == IDOK) {
                        printf("ok was pressed\n");
                    } else {
                        printf("cancel was pressed\n");
                    }
                }
            } else {
                printf("err request body 404\n");
            }
            
            const char* httpResponse = 
                "HTTP/1.1 200 OK\r\n"
                "Content-Type: text/plain\r\n"
                "Connection: close\r\n"
                "Content-Length: 14\r\n\r\n"
                "action received";

            int responseLength = strlen(httpResponse);
            int bytesSent = send(clientSocket, httpResponse, responseLength, 0);
            if (bytesSent == SOCKET_ERROR) {
                printf("err sending response\n");
            } else {
                printf("sent back\n");
            }
        } else {
            printf("failed to read request\n");
        }

        closesocket(clientSocket);
    }

    closesocket(serverSocket);
    WSACleanup();
}

int main() {
    startServer();
    return 0;
}
