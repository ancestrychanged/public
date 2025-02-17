local base64 = {}

local base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64.encode(input)
	local binaryString = input:gsub('.', function(char)
		local byteValue = char:byte()
		local bits = ''
		for bitIndex = 8, 1, -1 do
			bits = bits .. ((byteValue % 2^bitIndex - byteValue % 2^(bitIndex - 1) > 0) and '1' or '0')
		end
		return bits
	end) .. "0000"
	
	local encodedString = binaryString:gsub("%d%d%d?%d?%d?%d?", function(binaryChunk)
		if string.len(binaryChunk) < 6 then return "" end
		local chunkValue = 0
		for bitPos = 1, 6 do
			if binaryChunk:sub(bitPos, bitPos) == "1" then
				chunkValue = chunkValue + 2^(6 - bitPos)
			end
		end
		return base64_chars:sub(chunkValue + 1, chunkValue + 1)
	end)
	
	local padding = ({ "", "==", "=" })[string.len(input) % 3 + 1]
	return encodedString .. padding
end

function base64.decode(input)
	input = input:gsub("[^" .. base64_chars .. "=]", "")
	
	local binaryString = input:gsub('.', function(char)
		if char == '=' then return "" end
		local charIndex = base64_chars:find(char) - 1
		local bits = ""
		for bitIndex = 6, 1, -1 do
			bits = bits .. ((charIndex % 2^bitIndex - charIndex % 2^(bitIndex - 1) > 0) and "1" or "0")
		end
		return bits
	end)
	
	local decodedString = binaryString:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(binaryChunk)
		if string.len(binaryChunk) ~= 8 then return "" end
		local byteValue = 0
		for bitPos = 1, 8 do
			if binaryChunk:sub(bitPos, bitPos) == "1" then
				byteValue = byteValue + 2^(8 - bitPos)
			end
		end
		return string.char(byteValue)
	end)

	return decodedString
end

return base64
