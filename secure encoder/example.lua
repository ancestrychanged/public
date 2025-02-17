local encoder = require(game.ServerStorage.encoder)
local decoder = require(game.ServerStorage.decoder)

local stringtoencode = "ancestrychanged was here"

-- generate a 32-character key
local keyStr = encoder.generateSalt(32) -- example: 'АОАТСРуВОуААНРТРсЕРТсАТНСТОНТНРА'
local key = encoder.keyFromString(keyStr) -- example: 1.0923471181195822e+154

local encrypted = encoder.encode(stringtoencode, key)
print(`encrypted: {encrypted}`)

local normalized = decoder.decode(encrypted, key)
normalized = normalized:gsub("%z", "")
print(`decrypted: {normalized}`)
print(`key: {key} | key string: {keyStr}`)
