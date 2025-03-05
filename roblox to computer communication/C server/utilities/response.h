// utilities/response.h

#ifndef RESPONSE_H
#define RESPONSE_H
#include <winsock2.h>
void sendResponse(SOCKET clientSocket, int statusCode, const char* body);
#endif