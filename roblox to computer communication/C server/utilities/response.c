// utilities/response.c

#include "response.h"
#include <stdio.h>
#include <string.h>

void sendResponse(SOCKET clientSocket, int statusCode, const char* body) {
    char statusLine[50];
    if (statusCode == 200) {
        strcpy(statusLine, "HTTP/1.1 200 OK\r\n");

    } else if (statusCode == 404) {
        strcpy(statusLine, "HTTP/1.1 404 Not Found\r\n");

    } else if (statusCode == 400) {
        strcpy(statusLine, "HTTP/1.1 400 Bad Request\r\n");

    } else {
        strcpy(statusLine, "HTTP/1.1 500 Internal Server Error\r\n");

    }

    char contentLength[50];
    sprintf(contentLength, "Content-Length: %d\r\n", strlen(body));

    const char* headers = "Content-Type: text/plain\r\nConnection: close\r\n";

    send(clientSocket, statusLine, strlen(statusLine), 0);
    send(clientSocket, headers, strlen(headers), 0);
    send(clientSocket, contentLength, strlen(contentLength), 0);
    send(clientSocket, "\r\n", 2, 0);
    send(clientSocket, body, strlen(body), 0);
}