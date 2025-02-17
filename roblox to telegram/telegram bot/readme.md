- **commands/**  
  contains individual command modules (e.g., `/verify`, `/help`) that the bot can execute

- **libs/**  
  holds supporting libraries (e.g., verification logic, config settings, database functions)

- **command_template.py**  
  a template file showing how to create new bot commands in python

- **core.py**  
  main python script that loads commands, sets up the bot, and runs command handlers

- **server.js**  
  node.js server that processes and stores verification codes, responding to http requests from roblox

- **token.txt**  
  holds your telegram bot token (keep this file private)
