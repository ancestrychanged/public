# roblox-to-computer communication
controller(?) that lets you control your pc straight from roblox

uses simple chat commands to trigger actions on your pc via a C server

## overview
this system creates a sort-of a link between roblox and your pc

you can send commands like `messagebox`, `showimage`, `website`, `volume`, and `shell` directly from roblox chat and have your pc respond accordingly

on the roblox side, a server script listens for a message sent in chat, and sends a request to the C server, which executes the command

## roblox studio side  
a `<ServerScript>` sender listens for chat messages that start with a slash and checks them against a list of valid commands defined in a `<ModuleScript>` cmds

once validated, it sends the command to the c server via http; you can change the ip in the script from `127.0.0.1` (localhost) to a dedicated ip if you want to access your pc from anywhere

## C server side
C program that listens on port `8080`, validates an authorization header, and transfers the command to the proper handler

there are several folders:
- **commands**: self-explanatory
- **headers**: contains declarations for each command
- **utilities**: includes helper functions (such as sending http responses)
- **assets folders** (like `images` and `music`): store files used by commands like `showimage`

## accessing your pc from anywhere  
to control your pc from anywhere, change the ip addr in roblox studio from `127.0.0.1` to your own ip

here are some options to set that up:  
- set up a static ip or use a dynamic dns service (i.e. [No-IP](https://www.noip.com) or [DynDNS](https://dyn.com))
- configure port forwarding on your router to forward port `8080` to your pc  
- adjust your firewall settings to allow incoming connections on port `8080`

## compilation instructions  
to compile the C server, follow these steps:

1. **compile the resource file**  
   the server requires admin privileges, so check out `server.rc` and `server.exe.manifest`

   use the following command to compile the resource file:
   ```bash
   windres server.rc -O coff -o server_res.o
   ```

2. **compile the server**  
   use gcc (or a similar tool) in the root directory; here's a command that compiles all cmds with the main server code:
   
   ```bash
   gcc -I. main.c utilities/response.c commands/messagebox.c commands/showimage.c commands/website.c commands/volume.c commands/shell.c server_res.o -o server -lws2_32
   ```
   
   if you add a new command (for example, `newcommand.c`), simply include it in the command:
   
   ```bash
   gcc -I. main.c utilities/response.c commands/messagebox.c commands/showimage.c commands/website.c commands/volume.c commands/shell.c commands/newcommand.c server_res.o -o server -lws2_32
   ```
   
   note that you must compile and run the server with administrator privileges to ensure that the winapi functions (and any operations requiring elevated rights) work correctly

## libs
the project uses several key libraries and tools:

- **winsock2**: for network communication; comes with the windows sdk and is linked with `-lws2_32`  
- **winapi**: various windows api functions (like `MessageBoxA`, `ShellExecuteExA`, etc.) for system-level operations  
- **nircmd**: used to set the system volume; download from [the official site](https://www.nirsoft.net/utils/nircmd.html) and place it inside the root directory
- **GCC/MinGW**: a C compiler; if you don’t have one, install [MinGW](https://www.mingw-w64.org/) (or using [MSYS2](https://www.msys2.org/)) or use another compatible compiler  
- **windres**: a tool for compiling resource files; it is typically included with gcc/MinGW distributions

## notes  
- change the `authKey` in the roblox sender script to your own secret key
- the shell command enforces a whitelist by default to prevent dangerous commands; it's disabled by default, so if you're planning to use a static ip, change the `enforceWhitelist` variable to `1` inside `main.c`
- dynamic memory allocation in the shell command might be sensitive if the output is very large  
- winapi functions like `ShellExecuteExA` might behave unexpectedly if files aren’t found or windows fail to focus  
- remember that running the server requires administrator privileges (see `server.rc` and `server.exe.manifest`) to perform certain operations
