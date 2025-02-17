
# translator script

a translator script that lets you translate your outgoing, and incoming messages into the chat

---

## tutorial

- **usage:**
  - execute via ``loadstring(game:HttpGet('https://raw.githubusercontent.com/ancestrychanged/public/main/translator/translator.lua'))()``
- inside the chat window, type the language code you want to translate your message to, followed by your query (note: use the language code, **not** the language name)  
- a full list of language codes (with linked languages) can be found [here](https://localizely.com/iso-639-1-list/)

### examples

#### 1. single message translation

- **input:**  
  ```
  >de good!
  ```

- **output in chat:**  
  ```
  gut!
  ```

#### 2. continuous translation

for all of your subsequent messages, the script will keep translating your messages (even if you don't type the language code), until you send `>d` into the chat

- **example:**
  - **input:**  
    ```
    >de morning!
    ```
    **output:**  
    ```
    morgen!
    ```

  - **input:**  
    ```
    wonderful!
    ```
    **output:**  
    ```
    wunderbar!
    ```

  - **note:** queries with spaces and special characters are also supported
    - **example:**  
      ```
      abfragen mit leerzeichen und sonderzeichen werden ebenfalls unterstützt
      ```

#### 3. stopping the translation

- **to stop translating, send:**
  ```
  >d
  ```
  *(no message will be sent in the chat)*

> **note:** the script will not translate messages until you add a prefix of `>language_code` (e.g., `>de`, `>es`, etc)

- **warning:**  
  if you add `>d` in front of your message, it will ignore the query.
  **example:**  
  ```
  >d be careful!
  ```
  *(no message will be sent in the chat)*

#### 4. additional examples

- **changing the language mid-convo:**
  - **input:**  
    ```
    >es german language was used as an example - other languages are supported; full list of language codes can be found at the top of this post
    ```
  - **output in chat:**  
    ```
    se utilizó el idioma alemán como ejemplo - se admiten otros idiomas; la lista completa de códigos de idioma se puede encontrar en la parte superior de esta publicación
    ```

- **translation of a message without a prefix:**
  - **input:**  
    ```
    this message will get translated to spanish
    ```
  - **output in chat:**  
    ```
    este mensaje será traducido al español
    ```

- **switching languages with the translator active:**
  - **input:**  
    ```
    >ru switching languages, while having the translator active, will also work
    ```
  - **output in chat:**  
    ```
    переключение языков при активном переводчике также будет работать
    ```

- **testing with non-latin characters:**
  - **input:**  
    ```
    >el it works!
    ```
  - **output in chat:**  
    ```
    λειτουργεί!
    ```

- **testing with non utf-8 characters:**
  - **input:**  
    ```
    >ja test message containing non-utf-8 characters
    ```
  - **output in chat:**  
    ```
    utf-8以外の文字を含むテストメッセージ
    ```

#### 5. handling original strings with non-latin characters

- **example:**
  - **input:**  
    ```
    >en это сообщение также поддерживается переводчиком!
    ```
  - **output in chat:**  
    ```
    this message is also supported by the translator!
    ```

- **note:**  
  even if the `>en` prefix is not specified, the messages will still be translated.
  - **example:**  
    ```
    даже если префикс >en не указан, сообщения все равно будут переведены
    ```
    **output:**  
    ```
    even if the >en prefix is ​​not specified, messages will still be translated
    ```

- **additional example:**  
  ```
  outros idiomas tambem sao suportados
  ```
  **output:**  
  ```
  other languages are also supported
