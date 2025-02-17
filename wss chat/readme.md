# roblox-websocket chat system documentation

this project bridges roblox with a web server to allow real-time chat communication between roblox players and web clients; the system is composed of three main components

1. **roblox game scripts** – responsible for sending and receiving chat messages from roblox  
2. **node.js server (with express & websocket)** – acts as a central hub for message routing between roblox and web clients  
3. **web chat page** – a simple webpage that connects to the websocket server to display and send messages

---

## overview

- **roblox side:**  
  - a **server script** in roblox captures player chat messages; it batches these messages and sends them via http to a node.js server  
  - the same script periodically polls the node.js server for new messages and broadcasts them to all connected clients in roblox  
  - a **local script** on the client listens for these broadcast messages and displays them in roblox’s text chat service

- **node.js server:**  
  - the server uses express to create http endpoints that receive messages from roblox, return messages for polling, and clear messages once delivered  
  - a websocket server (running on a different port) allows web clients to connect and receive real-time chat updates; when a message is received from either source, it is forwarded to all connected websocket clients

- **web chat page:**  
  - a basic html page that establishes a websocket connection with the server  
  - displays incoming messages in a scrollable chat area and provides an input field for sending new messages through the websocket connection

---

## components and their functionality

### 1 - roblox scripts

- **server script:**  
  - **batching & sending:** collects player chat messages, groups them into batches (with configurable size and interval), and sends them to the node.js server via http post;  
  - **polling:** periodically polls the node.js server for any messages that were sent from the web chat;  
  - **message filtering:** filters out duplicate messages (eg- messages sent from roblox itself) to avoid repetition;  
  - **http endpoints:** uses three endpoints  
    - `/send-message` - receives batched messages from roblox  
    - `/messages` - returns all pending messages  
    - `/clear-messages` - clears the message queue after processing

- **local script (client):**  
  - listens for incoming messages from the server and displays them using roblox’s textchatservice;

### 2 - node.js server

- **express http server:**  
  - **endpoints:**  
    - **get `/messages`** - returns a json list of messages sorted by timestamp  
    - **post `/send-message`** - accepts a batch of messages from roblox, logs them, and sends them to connected websocket clients  
    - **post `/clear-messages`** - clears the message storage after polling

- **websocket server:**  
  - listens on a specified port (e.g. 8080) for connections from both roblox and the web chat page  
  - forwards any received messages to all connected websocket clients, ensuring real-time chat updates  
  - logs connection, disconnection, and message events for debugging purposes

### 3 - web chat page

- **html & javascript client:**  
  - establishes a websocket connection to the server  
  - displays incoming messages in a scrollable chat area  
  - provides an input field and button to send new messages; when a message is sent, it is prepended with an identifier (eg- "you [from server]") before being sent through the websocket

---

## setup instructions

### prerequisites
- **node.js environment:**  
  - install node.js, npm, and all of the required dependencies

### step 1 - configure the roblox game

1 - **insert the server script:**  
   - add the provided server script into your roblox game (e.g. inside `serverscriptservice`); this script handles sending batched chat messages and polling for messages

2 - **insert the local script:**  
   - place the local script into a suitable location (e.g. inside `starterplayerscripts`) so that each client can listen for and display chat messages

3 - **set up remote events:**  
   - ensure that a remoteevent (named `message`) is present in `replicatedstorage` to allow message broadcasting

### step 2 - set up the node.js server

1 - **create a new node.js project:**  
   - initialize a new node.js project using `npm init` and install the required packages  
     - express  
     - body-parser  
     - ws (websocket)

2 - **create and configure the server script:**  
   - set up the express server with endpoints (`/send-message`, `/messages`, `/clear-messages`) and configure the websocket server on the designated port  
   - adjust endpoint urls if necessary (e.g. if not running locally or on different ports)

3 - **run the server:**  
   - start the server (commonly with `node server.js`), ensuring it logs that it’s running (i.e. "server's on http://localhost:3000" and "websocket is on ws://localhost:8080")

### step 3 - deploy and test the web chat page

1 - **create the html page:**  
   - use the provided html template; save it as an `.html` file

2 - **connect to the websocket server:**  
   - ensure the websocket url in the html file matches the one defined in your node.js server

3 - **test the chat:**  
   - open the html file in your browser  
   - send messages using the input field and verify that they are broadcasted to both the web client and roblox players
---
