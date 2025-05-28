local serverScript = Instance.new("Script")
local localScript = Instance.new("LocalScript")

serverScript.Source = [[local rep = game:GetService("ReplicatedStorage")

local fakesend = Instance.new("RemoteEvent")
fakesend.Name = "fakesend"
fakesend.Parent = rep

local fakebroadcast = Instance.new("RemoteEvent")
fakebroadcast.Name = "fakebroadcast"
fakebroadcast.Parent = rep

local prefix = "ё" -- trust me on this one

fakesend.OnServerEvent:Connect(function(player, messageText, id)
	-- not using RemoteFunction bc too much work
	local t = prefix .. messageText
	fakebroadcast:FireAllClients(player, t, id)
end)]]

serverScript.Parent = game.ServerScriptService

localScript.Source = [[local players = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local tcs = game:GetService("TextChatService")
local http = game:GetService("HttpService") -- for the GenerateGUID fn

local fakesend = rep:WaitForChild("fakesend")
local fakebroadcast = rep:WaitForChild("fakebroadcast")

local colors = {
	Color3.new(253/255, 41/255, 67/255), Color3.new(1/255, 162/255, 255/255), 
	Color3.new(2/255, 184/255, 87/255), BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color, BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color, BrickColor.new("Brick yellow").Color
}

local playerColors = {}

local function namehash(username)
	local value = 0
	for i = 1, #username do
		local charByte = string.byte(username, i)
		local reverseIndex = #username - i + 1
		if #username % 2 == 1 then 
			reverseIndex = reverseIndex - 1
		end
		if reverseIndex % 4 >= 2 then
			charByte = -charByte
		end
		value = value + charByte
	end
	return value
end

local function getColor(userId, playerName)
	if playerColors[userId] then 
		return playerColors[userId]
	end
	local offset = userId % #colors
	local color = colors[((namehash(playerName) + offset) % #colors) + 1]
	playerColors[userId] = color
	return color
end

local function CTR(color3)
	if not color3 then return "rgb(255,255,255)" end
	return string.format("rgb(%d,%d,%d)",
		math.floor(color3.R * 255),
		math.floor(color3.G * 255),
		math.floor(color3.B * 255)
	)
end

local fakeMessages = {} 
local expiration = 5 
local prefix = "ё"
local processedMessages = setmetatable({}, {__mode = "k"})

tcs.SendingMessage:Connect(function(messageObject)
	return nil 
end)

local function displayMessage(sender, text, id)
	local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
	if not channel then
		error("if you got this error you know what to do; read line 63 of this script")
	end

	fakeMessages[id] = {
		userId = sender.UserId,
		displayName = sender.DisplayName,
		text = text,
		timestamp = tick()
	}

	if sender.Character then
		tcs:DisplayBubble(sender.Character, string.sub(text, #prefix + 1))
	end

	channel:DisplaySystemMessage("|" .. id)
end

fakebroadcast.OnClientEvent:Connect(displayMessage)

tcs.OnIncomingMessage = function(msg) 
	local original = msg.Text 
	local senderID = nil 
	
	if msg.TextSource then
		senderID = msg.TextSource.UserId
	end

	if string.sub(original, 1, 1) == "|" then
		local msgId = string.sub(original, 2)
		local stored = fakeMessages[msgId]

		if stored and stored.text then
			if stored.processed then 
				msg.Text = "" -- hiding
				msg.PrefixText = ""
			else
				local textToProcess = stored.text 
				if string.sub(textToProcess, 1, #prefix) == prefix then
					local actual = string.sub(textToProcess, #prefix + 1) 
					local color = getColor(stored.userId, stored.displayName) 
					msg.PrefixText = `<font color="{CTR(color)}">{stored.displayName}:</font>`
					msg.Text = actual
					stored.processed = true 
				else 
					msg.Text = "" 
					msg.PrefixText = "[error]"
				end
			end
		else 
			msg.Text = "" 
			msg.PrefixText = "[error]"
		end
	elseif senderID == players.LocalPlayer.UserId then 
		if processedMessages[msg] then
			msg.Text = ""
			msg.PrefixText = ""
		else
			local text = original 
			
			if text and string.gsub(text, "%s", "") ~= "" then
				fakesend:FireServer(text, http:GenerateGUID(false))
			end
			
			msg.Text = "" 
			msg.PrefixText = ""
			
			processedMessages[msg] = true 
		end
	elseif senderID then 
		local sender = players:GetPlayerByUserId(senderID)
		
		if sender then 
			local color = getColor(sender.UserId, sender.DisplayName)
			msg.PrefixText = `<font color="{CTR(color)}">{sender.DisplayName}:</font>`
		end
	end
	
	return nil 
end

task.spawn(function() 
	while true do 
		task.wait(expiration) 
		local currentTime = tick()
		for id, data in pairs(fakeMessages) do 
			if currentTime - (data.timestamp or 0) > expiration then 
				fakeMessages[id] = nil 
			end
		end
	end
end)]]
localScript.Parent = game.StarterPlayer.StarterPlayerScripts
