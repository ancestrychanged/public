local base64 = require(script.Parent.Base64)
local AES = require(script.Parent.aes)

local decoder = {}

-- helper to convert a string key to a number; can be used if the key is provided as a string
function decoder.keyFromString(str)
	local num = 0
	for i = 1, string.len(str) do
		num = num * 256 + str:byte(i)
	end
	return num
end

function decoder.decode(encryptedPromocode, key)
	local dec = base64.decode(encryptedPromocode)
	return AES.ECB_256(AES.decrypt, key, dec)
end

return decoder
