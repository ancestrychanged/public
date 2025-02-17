# aes-256 roblox-compatible encryption system

a system to securely encrypt data using aes-256 in roblox  

---

## tutorial

- **setup:**  
  - place all modules (encoder, decoder, base64, aes) inside a folder in serverstorage

- **usage:**  
  - to generate a key, call `encoder.generatesalt(32)` to create a 32-character salt  
  - convert the salt into a numeric key with `encoder.keyfromstring(keystr)`  
  - to encrypt a message, pass your text and numeric key to `encoder.encode(message, key)`  
  - to decrypt a message, use `decoder.decode(encrypted, key)` and remove any null characters with `gsub("%z", "")`
---

## examples

### 1. encrypting a message

- **input:**  
  ```lua
  local encoder = require(game.serverstorage.encryption.encoder)
  local keystr = encoder.generatesalt(32)
  local key = encoder.keyfromstring(keystr)
  local encrypted = encoder.encode("your message here", key)
  print("encrypted:", encrypted)
  ```

- **output:**  
  an encrypted string, for example  
  ```
  q2fzc2u0ZW5jb2RlZGV4YW1wbGU=
  ```

### 2. decrypting a message

- **input:**  
  ```lua
  local decoder = require(game.serverstorage.encryption.decoder)
  local normalized = decoder.decode(encrypted, key)
  normalized = normalized:gsub("%z", "")
  print("decrypted:", normalized)
  ```

- **output:**  
  the original message  
  ```
  your message here
  ```
---

## additional information

- **security:**  
  this system uses aes 256 in ecb mode along with custom key generation and base64 encoding to ensure data security  
  it is recommended to further secure key storage and transmission in a production environment

- **integration:**  
  this can be easily integrated by placing the modules in serverstorage (or any other path - don't forget to change the variables inside those modules too) and requiring them in your scripts
  see example.lua for more info
- **customization:**  
  you can modify the salt generation or encryption parameters to suit your security requirements

---
