local http = game:GetService("HttpService")
local url = "http://127.0.0.1:8080"
local authKey = "meowzerss" -- change this to your own secret key
local headers = {Authorization = "Bearer " .. authKey}
local cmds = require(game.ServerScriptService.cmds)

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if message:sub(1,1) == "/" then
			local cmd = message:match("^/(%w+)")
			if cmd and cmds[cmd] then
				http:PostAsync(url, message, Enum.HttpContentType.TextPlain, false, headers)
			else
				warn("invalid command: " .. (cmd or "<no cmd specified>"))
			end
		end
	end)
end)
