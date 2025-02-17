local base64 = require(game.ServerStorage.Base64)
local AES = require(game.ServerStorage.aes)

local encoder = {}

local charList = {"О", "о", "А", "у", "Е", "е", "Н", "В", "Р", "р", "С", "с", "Т"}

function encoder.getRandomChar()
	return charList[math.random(1, #charList)]
end

-- generate a salt (or key string) using only the russian characters
function encoder.generateSalt(length)
	local salt = ""
	for i = 1, length do
		salt = salt .. encoder.getRandomChar()
	end
	return salt
end

-- convert a string (like the salt/key) to a number for use with AES
function encoder.keyFromString(str)
	local num = 0
	for i = 1, #str do
		num = num * 256 + str:byte(i)
	end
	return num
end

function encoder.encode(promocode, key)
	return base64.encode(AES.ECB_256(AES.encrypt, key, promocode))
end

return encoder
