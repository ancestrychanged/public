// commands/screenshot.c

#include "headers/screenshot.h"
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include "utilities/response.h"

void handleScreenshot(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
    int screenWidth = GetSystemMetrics(SM_CXSCREEN);
    int screenHeight = GetSystemMetrics(SM_CYSCREEN);
    HDC hdcScreen = GetDC(NULL);
    HDC hdcMemory = CreateCompatibleDC(hdcScreen);
    HBITMAP hbmScreen = CreateCompatibleBitmap(hdcScreen, screenWidth, screenHeight);
    HBITMAP hbmOld = (HBITMAP)SelectObject(hdcMemory, hbmScreen);
    BitBlt(hdcMemory, 0, 0, screenWidth, screenHeight, hdcScreen, 0, 0, SRCCOPY);
    
    char exePath[MAX_PATH];
    GetModuleFileNameA(NULL, exePath, MAX_PATH);
    char* lastSlash = strrchr(exePath, '\\');
    if (lastSlash) *lastSlash = '\0';
    
    char screenshotDir[MAX_PATH];
    sprintf(screenshotDir, "%s\\screenshots", exePath);
    CreateDirectoryA(screenshotDir, NULL);
    
    time_t now;
    time(&now);
    struct tm* timeinfo = localtime(&now);
    char timestamp[64];
    strftime(timestamp, sizeof(timestamp), "%Y%m%d_%H%M%S", timeinfo);
    
    char tempBmpPath[MAX_PATH];
    sprintf(tempBmpPath, "%s\\screenshots\\temp_%s.bmp", exePath, timestamp);
    char pngPath[MAX_PATH];
    sprintf(pngPath, "%s\\screenshots\\screenshot_%s.png", exePath, timestamp);
    
    BITMAPINFOHEADER bi;
    bi.biSize = sizeof(BITMAPINFOHEADER);
    bi.biWidth = screenWidth;
    bi.biHeight = screenHeight;
    bi.biPlanes = 1;
    bi.biBitCount = 32;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;
    
    DWORD dwBmpSize = ((screenWidth * bi.biBitCount + 31) / 32) * 4 * screenHeight;
    
    HANDLE hDIB = GlobalAlloc(GHND, dwBmpSize);
    char* lpbitmap = (char*)GlobalLock(hDIB);
    
    GetDIBits(hdcScreen, hbmScreen, 0, (UINT)screenHeight, lpbitmap, (BITMAPINFO*)&bi, DIB_RGB_COLORS);
    HANDLE hFile = CreateFileA(tempBmpPath, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    
    if (hFile == INVALID_HANDLE_VALUE) {
        GlobalUnlock(hDIB);
        GlobalFree(hDIB);
        SelectObject(hdcMemory, hbmOld);
        DeleteObject(hbmScreen);
        DeleteDC(hdcMemory);
        ReleaseDC(NULL, hdcScreen);
        sendResponse(clientSocket, 500, "failed to create screenshot file");
        return;
    }
    
    BITMAPFILEHEADER bmfHeader;
    bmfHeader.bfType = 0x4D42; // "BM"
    bmfHeader.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + dwBmpSize;
    bmfHeader.bfReserved1 = 0;
    bmfHeader.bfReserved2 = 0;
    bmfHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    
    DWORD dwBytesWritten = 0;
    WriteFile(hFile, (LPSTR)&bmfHeader, sizeof(BITMAPFILEHEADER), &dwBytesWritten, NULL);
    WriteFile(hFile, (LPSTR)&bi, sizeof(BITMAPINFOHEADER), &dwBytesWritten, NULL);
    WriteFile(hFile, (LPSTR)lpbitmap, dwBmpSize, &dwBytesWritten, NULL);
    CloseHandle(hFile);
    
    GlobalUnlock(hDIB);
    GlobalFree(hDIB);
    SelectObject(hdcMemory, hbmOld);
    DeleteObject(hbmScreen);
    DeleteDC(hdcMemory);
    ReleaseDC(NULL, hdcScreen);
    
    char psCommand[1024];
    sprintf(psCommand, "powershell -Command \"Add-Type -AssemblyName System.Drawing; $img = [System.Drawing.Image]::FromFile('%s'); $img.Save('%s', [System.Drawing.Imaging.ImageFormat]::Png); $img.Dispose(); Remove-Item '%s'\"", 
            tempBmpPath, pngPath, tempBmpPath);
    
    STARTUPINFOA si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));
    
    if (CreateProcessA(NULL, psCommand, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi)) {
        WaitForSingleObject(pi.hProcess, 10000);
        
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
        
        ShellExecuteA(NULL, "open", pngPath, NULL, NULL, SW_SHOWMAXIMIZED);
        
        char response[256];
        sprintf(response, "Screenshot saved and opened: screenshot_%s.png", timestamp);
        sendResponse(clientSocket, 200, response);
    } else {
        ShellExecuteA(NULL, "open", tempBmpPath, NULL, NULL, SW_SHOWMAXIMIZED);
        
        char response[256];
        sprintf(response, "Screenshot saved as BMP (PNG conversion failed): temp_%s.bmp", timestamp);
        sendResponse(clientSocket, 200, response);
    }
}