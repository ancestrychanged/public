game.ReplicatedStorage.Message.OnClientEvent:Connect(function(text: string)
	if text:find("Studio") then return end
	game:GetService('TextChatService').TextChannels.RBXGeneral:DisplaySystemMessage(text)
end)
