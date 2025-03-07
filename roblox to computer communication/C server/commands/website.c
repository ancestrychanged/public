// commands/website.c

#include "headers/website.h"
#include <windows.h>
#include <string.h>
#include "utilities/response.h"
#include <stdio.h>
#include <stdint.h>

static int delay = 500;

void handleWebsite(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
    if (argument == NULL || strlen(argument) == 0) {
        sendResponse(clientSocket, 400, "Bad Request: no url provided");
        return;
    }

    char fullUrl[256];
    if (strncmp(argument, "http://", 7) != 0 && strncmp(argument, "https://", 8) != 0) {
        sprintf(fullUrl, "http://%s", argument);
    } else {
        strncpy(fullUrl, argument, sizeof(fullUrl) - 1);
        fullUrl[sizeof(fullUrl) - 1] = '\0';
    }

    SHELLEXECUTEINFOA sei = {0};
    sei.cbSize = sizeof(SHELLEXECUTEINFOA);
    sei.fMask = SEE_MASK_NOCLOSEPROCESS;
    sei.lpVerb = "open";
    sei.lpFile = fullUrl;
    sei.nShow = SW_SHOWMAXIMIZED;

    if (!ShellExecuteExA(&sei)) {
        printf("ShellExecuteExA failed with code %d\n", GetLastError());
        sendResponse(clientSocket, 500, "failed to open website");
        return;
    }

    Sleep(delay);
    HWND hwnd = NULL;
    int attempts = 0;
    const int maxAttempts = 5;
    char windowTitle[256];

    while (attempts < maxAttempts) {
        hwnd = FindWindowA(NULL, NULL);
        while (hwnd) {
            GetWindowTextA(hwnd, windowTitle, sizeof(windowTitle));
            if (strstr(windowTitle, argument) && IsWindowVisible(hwnd)) {
                ShowWindow(hwnd, SW_RESTORE);
                ShowWindow(hwnd, SW_SHOWMAXIMIZED);
                SetForegroundWindow(hwnd);
                BringWindowToTop(hwnd);

                // dave: i'm sorry (TIME: 1741020908)
                // liam: wtf? why would you do that? (TIME: 1741027642)
                keybd_event(VK_MENU, 0, 0, 0);
                keybd_event(VK_TAB, 0, 0, 0);
                keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);
                keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);

                if (GetForegroundWindow() == hwnd) {
                    break;
                }
            }
            // liam: replaced GetNextWindow with GetWindow (TIME: 1741088448)
            // dave: thank you (TIME: 1741090930)
            // liam: nw (TIME: 1741091271)
            hwnd = GetWindow(hwnd, GW_HWNDNEXT);
        }
        if (GetForegroundWindow() == hwnd) break;
        Sleep(500);
        attempts++;
    }

    if (!hwnd || attempts >= maxAttempts) {
        printf("failed to focus browser window after %d attempts\n", maxAttempts);
    }

    CloseHandle(sei.hProcess);
    sendResponse(clientSocket, 200, "site opened");
}