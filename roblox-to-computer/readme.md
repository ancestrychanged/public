# messagebox test from roblox
thing that links roblox studio with a windows-based server

the roblox script sends a message to the localhost when a player types `/messagebox` into the chat

the windows server, written in C, listens for these messages and displays a message box on your pc

# overview  
there are two main parts: a serverscript (in roblox studio) that monitors player chat and sends http post requests, and a windows server written in C that uses winsock to handle incoming requests

the roblox script is for catching when the player types a command that begins with `/messagebox ` (notice the space) and then extracts the text that follows

`main.c` waits for these incoming messages, extracts the body from the request, and then displays the message using the windows message box API

after the user interacts with the message box by choosing either ok or cancel, the server logs the choice and sends back a response

# scripts

## roblox studio script
- whenever the player chats, it checks if a player's message starts with `/messagebox ` and extracts the following text  
- posts the extracted text to a specified url (in this case, `http://192.168.0.172:8080`), which is where the server is running  

## c server (main.c)
- creates a tcp server socket that listens on port 8080 for incoming connections
- uses `MessageBoxA` to display the message on the pc
- logs whether the ok or cancel button was pressed and then sends a response back to the client 
- runs an infinite loop to continuously handle incoming connections (terminate with `ctrl+c`)

# usage examples  
- i dont know? extend `main.c` with whatever functionality you want  
- this can act as a remote desktop for robloxians

# compilation note  
- compile with `gcc` using the command:  
  `gcc -o main.exe main.c -lws2_32`  
- note that `main.c` is windows-only due to the use of windows-specific headers and functions such as [winsock2](https://en.wikipedia.org/wiki/Winsock) and [windows api](https://en.wikipedia.org/wiki/Windows_API) calls  
