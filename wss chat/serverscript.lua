local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local sendMessageURL = "http://localhost:3000/send-message"
local pollURL = "http://localhost:3000/messages"
local clearURL = "http://localhost:3000/clear-messages"

local pollInterval = 10
local sentMessages = {}
local messageBatch = {} -- table to hold all cached messages
local maxBatchSize = 10 -- maximum number of messages per batch
local batchSendInterval = 5 -- send the batch every 5 seconds

local function sendBatchToServer()
	if #messageBatch > 0 then
		local data = {
			messages = messageBatch
		}
		local jsonData = HttpService:JSONEncode(data)

		local success, result = pcall(function()
			return HttpService:PostAsync(sendMessageURL, jsonData, Enum.HttpContentType.ApplicationJson)
		end)

		if success then
			print("batch sent successfully")
			messageBatch = {}
		else
			warn(`failed to send the batch: {tostring(result)}`)
		end
	end
end

RunService.Heartbeat:Connect(function(dt)
	batchSendInterval = batchSendInterval - dt
	if batchSendInterval <= 0 then
		sendBatchToServer()
		batchSendInterval = 5
	end
end)

local function pollMessages()
	while true do
		local success, result = pcall(function()
			return HttpService:GetAsync(pollURL)
		end)

		if success then
			local messages = HttpService:JSONDecode(result)

			for _, message in ipairs(messages) do
				local isDuplicate = false
				for i, sentMessage in ipairs(sentMessages) do
					if message:find(sentMessage) then
						isDuplicate = true
						table.remove(sentMessages, i)
						break
					end
				end

				if not isDuplicate then
					game.ReplicatedStorage.Message:FireAllClients(message)
				end
			end

			HttpService:PostAsync(clearURL, "{}", Enum.HttpContentType.ApplicationJson)

			if #messages > 0 then
				pollInterval = 7
			else
				pollInterval = 10
			end

		else
			warn(`failed to poll messages: {tostring(result)}`)
		end

		wait(pollInterval)
	end
end

spawn(pollMessages)

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		table.insert(messageBatch, {
			username = player.Name .. " [from studio]",
			message = message,
			timestamp = os.time()
		})

		table.insert(sentMessages, message)
	end)
end)
