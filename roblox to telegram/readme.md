# roblox-to-telegram linking system

a system to link your roblox account with your telegram account via an in-game gui and a telegram bot  
this system allows users to generate a verification code in roblox and verify their account through telegram

---

## introduction

this system consists of two main components  
- a roblox place that includes a gui for generating and verifying codes  
- a telegram bot that handles account linking and supports various commands

most string constants inside the telegram bot are in russian, sooooo if you need to change the language or adjust messages, update the corresponding text in the telegram bot folder

---

## roblox place setup

1. add the provided roblox scripts to your place  
   - insert the **manager** local script inside sstartergui/screengui/auth to handle ui interactions  
   - insert the **verify** server script inside serverscripts to manage code generation, datastore operations, and http requests
2. ensure a folder named **events** exists in `replicatedstorage` and contains the necessary remote events
3. verify that your datastore permissions are correctly configured for storing verification codes and user statuses
4. note that the roblox scripts use http requests to `http://127.0.0.1:1337` for communication so update this url if deploying to a live server
..orrrrr just download `robloxtotelegram.rbxl`
---

## telegram bot setup

1. install node.js and required dependencies  
   - in the telegram bot folder run `npm install express sqlite3`
2. update your bot token  
   - open the file `token.txt` and replace its contents with your telegram bot token
3. update configuration values  
   - in the file `libs/commandlist.py` replace `owner_id` with your telegram user id  
   - update `server_url` with the address of your verification server (e.g. `http://127.0.0.1`)
4. update placeholders in the telegram bot commands  
   - in files such as `commands/verify.py` and `commands/help.py` replace `https://t.me/your_telegram_link` with your actual telegram support or channel link
5. remember that most string constants (e.g. help texts, command responses) are in russian so modify these if you need a different language

---

## step-by-step guide

1. set up the roblox place
2. playtest it so that the gui for account linking is accessible to players
3. set up the telegram bot by installing dependencies, updating your bot token, and configuring values in `libs/commandlist.py`
4. run the telegram bot by executing `node server.js` in the telegram bot folder
5. when a player generates a code in roblox, the code is sent via an http request to your verification server and the telegram bot uses this information to verify and link the accounts
6. after successful verification the player's roblox account is linked to their telegram account enabling access to telegram bot commands

---

## additional notes

- ensure your verification server (e.g. the one running at `http://127.0.0.1:1337`) is accessible from both roblox and your telegram bot
- keep your bot token and configuration values secure to prevent unauthorized access
---
