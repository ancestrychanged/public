// commands/showimage.c

#include "headers/showimage.h"
#include <windows.h>
#include <string.h>
#include "utilities/response.h"
#include <stdio.h>
#include <stdint.h>

static int delay = 300;

void handleShowImage(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
    if (argument == NULL || strlen(argument) == 0) {
        sendResponse(clientSocket, 400, "Bad Request: no image name provided");
        return;
    }

    char exePath[MAX_PATH];
    GetModuleFileNameA(NULL, exePath, MAX_PATH);
    char* lastSlash = strrchr(exePath, '\\');
    if (lastSlash) *lastSlash = '\0';

    char path[256];
    sprintf(path, "%s\\images\\%s", exePath, argument);
    FILE* file = fopen(path, "r");

    if (file == NULL) {
        sendResponse(clientSocket, 404, "image not found");
        return;
    }

    fclose(file);

    SHELLEXECUTEINFOA sei = {0};
    sei.cbSize = sizeof(SHELLEXECUTEINFOA);
    sei.fMask = SEE_MASK_NOCLOSEPROCESS;
    sei.lpVerb = "open";
    sei.lpFile = path;
    sei.nShow = SW_SHOWMAXIMIZED;

    if (!ShellExecuteExA(&sei)) {
        printf("ShellExecuteExA failed with code %d\n", GetLastError());
        sendResponse(clientSocket, 500, "failed to open image");
        return;
    }

    Sleep(delay);
    HWND hwnd = FindWindowA(NULL, NULL);
    char windowTitle[256];

    while (hwnd) {
        GetWindowTextA(hwnd, windowTitle, sizeof(windowTitle));
        if (IsWindowVisible(hwnd) && windowTitle[0] != '\0') {
            if (strstr(windowTitle, argument)) {
                ShowWindow(hwnd, SW_RESTORE);
                ShowWindow(hwnd, SW_SHOWMAXIMIZED);
                SetActiveWindow(hwnd);
                SwitchToThisWindow(hwnd, TRUE);
                SetForegroundWindow(hwnd);
                BringWindowToTop(hwnd);
                SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
                Sleep(200);
                SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
                
                if (GetForegroundWindow() == hwnd) {
                    CloseHandle(sei.hProcess);
                    sendResponse(clientSocket, 200, "image opened");
                    return;
                } else {
                    HWND fg = GetForegroundWindow();
                    GetWindowTextA(fg, windowTitle, sizeof(windowTitle));
                }
                break;
            }
        }
        hwnd = GetWindow(hwnd, GW_HWNDNEXT);
    }

    CloseHandle(sei.hProcess);
    sendResponse(clientSocket, 200, "image opened");
}
