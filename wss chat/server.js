const WebSocket = require('ws');
const express = require('express');
const bodyParser = require('body-parser');

const wss = new WebSocket.Server({ port: 8080 });
const app = express();
app.use(bodyParser.json());

let messages = [];

wss.on('connection', (ws, req) => {
    const clientIP = req.socket.remoteAddress;
    console.log(`successful connection with ${clientIP}`);
  
    ws.on('message', (message) => {
      if (Buffer.isBuffer(message)) {
        message = message.toString();
      }
      console.log(`message from ${clientIP}:`, message);
  
      messages.push(message);
  
      wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
          client.send(message);
        }
      });
    });
  
    ws.on('close', () => {
      console.log(`client ${clientIP} has disconnected`);
    });
  });
  
app.get('/messages', (req, res) => {
  messages.sort((a, b) => a.timestamp - b.timestamp); 
  res.json(messages);
});

app.post('/clear-messages', (req, res) => {
  messages = [];
  res.sendStatus(200);
});

app.post('/send-message', (req, res) => {
    const messagesFromStudio = req.body.messages;
  
    if (Array.isArray(messagesFromStudio)) {
      messagesFromStudio.forEach(({ username, message, timestamp }) => {
        if (username && message && timestamp) {
          const fullMessage = {
            username: username,
            message: message,
            timestamp: timestamp
          };
          console.log('got a message from studio: ', fullMessage);
  
          messages.push(fullMessage);
  
          messages.sort((a, b) => a.timestamp - b.timestamp); 

          wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
              client.send(`${fullMessage.username}: ${fullMessage.message} (time: ${new Date(fullMessage.timestamp * 1000).toLocaleTimeString()})`);
            }
          });
        }
      });
  
      res.sendStatus(200);
    } else {
      res.sendStatus(400);
    }
  });
  

app.listen(3000, () => {
  console.log('server\'s on http://localhost:3000');
});

console.log('websocket is on ws://localhost:8080');
