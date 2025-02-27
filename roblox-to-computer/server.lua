local http = game:GetService("HttpService")
local url = "http://192.168.0.172:8080"

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if message:sub(1, 12) == "/messagebox " then
			local text = message:sub(13)
			http:PostAsync(url, text)
		end
	end)
end)
