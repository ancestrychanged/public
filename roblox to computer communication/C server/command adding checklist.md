# checklist for adding a new command

## tl;dr
1. **in roblox studio**: add `newcommand = true` inside `cmds`
2. **inside the C server**:
   - create `headers/newcommand.h` with handler declaration
   - write `commands/newcommand.c` with the command logic
   - add `#include "headers/newcommand.h"` and `{"newcommand", handleNewCommand}` to `main.c`
   - compile with `commands/newcommand.c` added to the gcc command


ㅤ

ㅤ
## on roblox side:

### 1. update the \<ModuleScript\> cmds inside `ServerScriptService`
- **purpose**: define the command name so the main script recognizes it as a valid thing
- **steps**:
  - open the \<ModuleScript\> `cmds` in `ServerScriptService`
  - add the new command name as a key with a `true` value (or any value, since the script just checks for existence)
  - example:
    ```lua
    -- ServerScriptService.cmds
    local cmds = {
        messagebox = true,
        showimage = true,
        website = true,
        volume = true,
        shell = true, -- don't forget the comma
        newcommand = true -- over here
    }

    return cmds
    ```
- **notes**:
  - replace `newcommand` with an actual command name (for example, `playmusic`)
  - the main script (`ServerScriptService` script) uses `cmds[cmd]` to validate commands before sending them to the server

### 2. test the cmd in the Main Script
- **purpose**: make sure the command sends a request to the server
- **existing code** (for reference):
  ```lua
  local http = game:GetService("HttpService")
  local url = "http://127.0.0.1:8080"
  local authKey = "meowzerss" -- change this to your own secret key
  local headers = {Authorization = "Bearer " .. authKey}
  local cmds = require(game.ServerScriptService.cmds)

  game.Players.PlayerAdded:Connect(function(player)
      player.Chatted:Connect(function(message)
          if message:sub(1,1) == "/" then
              local cmd = message:match("^/(%w+)")
              if cmd and cmds[cmd] then -- here!!
                  http:PostAsync(url, message, Enum.HttpContentType.TextPlain, false, headers)
              else
                  warn("invalid command: " .. (cmd or "<no cmd specified>"))
              end
          end
      end)
  end)
  ```
- **steps**:
  - no changes needed here if `cmds` is updated correctly
  - test by sending `/newcommand arg` into the chat to ensure it sends the request (for example, `/playmusic songname`)
- **notes**:
  - the command name must be **lowercase** and alphanumeric (test123) to match `message:match("^/(%w+)")`

## on C server side:

### 1. create a header File
- **lo**: `headers/newcommand.h`
- **purpose**: declare the command handler function for use in `main.c` and the implementation file
- **steps**:
  - create a new file named `newcommand.h` in the `headers/` dir
  - add the following content:
    ```c
    // headers/newcommand.h

    #ifndef NEWCOMMAND_H
    #define NEWCOMMAND_H
    #include <winsock2.h>
    void handleNewCommand(SOCKET clientSocket, const char* argument, int enforceWhitelist);
    #endif
    ```
- **notes**:
  - replace `newcommand` with your command name (for example, `playmusic` → `headers/playmusic.h` and `handlePlayMusic`)
  - the signature matches other handlers: `SOCKET`, `const char*` for args, and `int` for the whitelist toggle (even if unused)
  - include `<winsock2.h>` for the `SOCKET` type

### 2. make the command
- **lo**: `commands/newcommand.c`
- **purpose**: the actual stuff that the cmd does
- **steps**:
  - create a new file named `newcommand.c` in the `commands/` dir
  - add the basic structure:
    ```c
    // commands/newcommand.c

    #include "headers/newcommand.h"
    #include <windows.h>
    #include <string.h>
    #include "utilities/response.h"

    void handleNewCommand(SOCKET clientSocket, const char* argument, int enforceWhitelist) {
        // you can remove this if statement below ONLY if ur cmd doesn't need args
        if (argument == NULL || strlen(argument) == 0) {
            sendResponse(clientSocket, 400, "Bad Request: no argument provided");
            return;
        }

        // code here
        // example: MessageBoxA(NULL, argument, "title", MB_OK);

        sendResponse(clientSocket, 200, "newcommand executed");
    }
    ```
- **what to include**:
  - `#include "headers/newcommand.h"`: links to the header
  - `#include <windows.h>`: for winapi functions (if needed, for example, `MessageBoxA`, `ShellExecuteA`)
  - `#include <string.h>`: for string operations (for example, `strlen`, `strcmp`)
  - `#include "utilities/response.h"`: for `sendResponse` to send HTTP responses
  - add other headers as needed (for example, `<stdio.h>` for `printf`)
- **also**:
  - check for valid arguments with `if (argument == NULL || strlen(argument) == 0)`, if needed
  - send a response with `sendResponse(clientSocket, statusCode, message)`
- **Notes**:
  - use status codes: 200 (OK), 400 (Bad Request), 500 (Server Error), etc., matching other cmds

### 3. update `main.c`
- **lo**: `./main.c` (basically the root dir)
- **purpose**: include the new cmd in the server’s cmd list
- **steps**:
  - add the header include near the top: (after `#include <string.h>` or smth)
    ```c
    #include "headers/newcommand.h"
    ```
  - add the command to the `commands` array:
    ```c
    Command commands[] = {
        {"messagebox", handleMessageBox},
        {"showimage", handleShowImage},
        {"website", handleWebsite},
        {"volume", handleVolume},
        {"shell", handleShell},
        {"newcommand", handleNewCommand} // here
    };
    ```
- **notes**:
  - the handler function must match the signature in the header
  - no other changes needed; the existing loop will call `handleNewCommand` when `/newcommand` is received

### 4. compile
- **lo**: (cmd inside root dir)
- **steps**:
  - template:
    ```bash
    gcc -I. main.c utilities/response.c commands/messagebox.c commands/showimage.c commands/website.c commands/volume.c commands/shell.c server_res.o -o server -lws2_32
    ```
  - updated:
    ```bash
    gcc -I. main.c utilities/response.c commands/messagebox.c commands/showimage.c commands/website.c commands/volume.c commands/shell.c commands/newcommand.c server_res.o -o server -lws2_32
    ```
  - notice how i added `commands/newcommand.c` after `commands/shell.c`? yea do that

## testing
1. **start the server**:
   - run `server.exe` (or `server.exe --enable-whitelist` if testing whitelist)
2. **test in roblox**:
   - in studio, send `/newcommand testarg` into the chat (replace with the actual cmd name and args, if any)
3. **debug**:
   - 400: check argument handling
   - 500: check server logic (for example, API calls failing)
   - 404: check if the command is in `main.c`'s `commands` array

## example: adding `/playmusic <filename>`
- **inside the \<ModuleScript\> cmds**:
  ```lua
  local cmds = {
      -- existing cmds
      playmusic = true
  }
  return cmds
  ```
- **header**: `headers/playmusic.h`
  ```c
  // headers/playmusic.h

  #ifndef PLAYMUSIC_H
  #define PLAYMUSIC_H
  #include <winsock2.h>
  void handlePlayMusic(SOCKET clientSocket, const char* argument, int enforceWhitelist);
  #endif
  ```
- **source**: `commands/playmusic.c`
  ```c
  // commands/playmusic.c

  #include "headers/playmusic.h"

  #include <windows.h>

  #include <string.h>

  #include "utilities/response.h"

  void handlePlayMusic(SOCKET clientSocket,
      const char * argument, int enforceWhitelist) {
      if (argument == NULL || strlen(argument) == 0) {
          sendResponse(clientSocket, 400, "Bad Request: no music filename provided");
          return;
      }

      char exePath[MAX_PATH];
      GetModuleFileNameA(NULL, exePath, MAX_PATH);

      char * lastSlash = strrchr(exePath, '\\');
      if (lastSlash) * lastSlash = '\0';

      char path[256];
      sprintf(path, "%s\\music\\%s", exePath, argument);

      if (ShellExecuteA(NULL, "open", path, NULL, NULL, SW_SHOWNORMAL) <= 32) {
          sendResponse(clientSocket, 500, "failed to play music");
          return;
      }
      sendResponse(clientSocket, 200, "music playing");
  }
  ```
- **update `main.c`**:
  ```c
  // ...
  #include "headers/playmusic.h"
  // ...
  Command commands[] = {
      // existing cmds
      {"playmusic", handlePlayMusic}
  };
  ```
- **compile**:
  ```bash
  gcc -I. main.c utilities/response.c commands/messagebox.c commands/showimage.c commands/website.c commands/volume.c commands/shell.c commands/playmusic.c server_res.o -o server -lws2_32
  ```