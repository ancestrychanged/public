local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local rep = game:GetService("ReplicatedStorage")

local verifyev = rep:WaitForChild("Events"):WaitForChild("Authenticate")
local verifiedev = rep:WaitForChild("Events"):WaitForChild("Verified")

local codeStore = DataStoreService:GetDataStore("PublicVerificationCodes")
local userStore = DataStoreService:GetDataStore("PublicUserVerification")

local recentlyVerifiedServerCache = {}
local cyrillicLetters = {}

for code = 1040, 1071 do
	local letter = utf8.char(code)
	table.insert(cyrillicLetters, letter)
end

local function generateCode()
	local numberPart = math.random(1000, 9999)
	local letterPart = ""
	for i = 1, 4 do
		local letter = cyrillicLetters[math.random(1, #cyrillicLetters)]
		letterPart = letterPart .. letter
	end
	return tostring(numberPart) .. "-" .. letterPart
end

local function checkPlayerVerified(player)
	local key = tostring(player.UserId) .. "_verifiedthroughtelegram"
	local success, value = pcall(function()
		return userStore:GetAsync(key)
	end)
	if success and value and string.sub(value, 1, 3) == "yes" then
		return true, value
	else
		if not success then
			warn(`failed to retrieve verification status for player: {player.Name}, {value}`)
		end
		return false, nil
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("Timeout", false)
	player:SetAttribute("Verified", false)
	player:SetAttribute("CacheVerified", false)

	local isVerified, verificationData = checkPlayerVerified(player)
	if isVerified then
		player:SetAttribute("Verified", true)
		print(`player {player.Name} is already verified`)
	else
		local success, code = pcall(function()
			return codeStore:GetAsync(player.UserId)
		end)
		if success and code then
			print(`existing code for {player.Name}: {code}`)
		end
	end
end)

verifyev.OnServerEvent:Connect(function(player, label)
	local timeout = player:GetAttribute("Timeout")
	local verified = player:GetAttribute("Verified")

	if timeout or verified then
		print(`cannot generate code for player: {player.Name}, timeout: {timeout}, verified: {verified}`)
		task.wait()
		label.Text = "player is already verified"
		return
	end

	label.Text = "code: ⏳"

	local success, existingCode = pcall(function()
		return codeStore:GetAsync(player.UserId)
	end)

	if success and existingCode then
		player:SetAttribute("CacheVerified", true)
		print(`existing code for {player.Name}: {existingCode}`)
		label.Text = `code: {existingCode}`
		return
	end

	local code = generateCode()
	print(`generated code for {player.Name}: {code}`)
	label.Text = `code: {code}`

	local successStore, errStore = pcall(function()
		codeStore:SetAsync(player.UserId, code)
	end)

	if not successStore then
		warn(`failed to store code: {errStore}`)
		return
	end

	local payload = {
		robloxuserid = player.UserId,
		accesscode = code,
		timestamp = os.time()
	}

	local jsonPayload = HttpService:JSONEncode(payload)
	local successPost, errPost = pcall(function()
		HttpService:PostAsync("http://127.0.0.1:1337/validate", jsonPayload, Enum.HttpContentType.ApplicationJson)
	end)

	if not successPost then
		warn(`failed to send code to server: {errPost}`)
	end
end)

verifiedev.OnServerEvent:Connect(function(player, label)
	if player:GetAttribute("Verified") == true then
		print(`player {player.Name} is already verified`)
		label.Text = "status: ✅"
		return
	end

	if player:GetAttribute("Timeout") == true then
		print(`player {player.Name} is already verified`)
		label.Text = "status: ❌❌❌"
		return
	end

	local url = `http://127.0.0.1:1337/successfulverifications?robloxuserid={tostring(player.UserId)}`
	local success, response = pcall(function()
		return HttpService:GetAsync(url)
	end)

	print(response)

	if success then
		local data = HttpService:JSONDecode(response)
		if data.exists then
			local verifiedThroughTelegram = `yes|{tostring(data.telegramid)}`
			local success2, err2 = pcall(function()
				local key = tostring(player.UserId) .. "_verifiedthroughtelegram"
				userStore:SetAsync(key, verifiedThroughTelegram)
			end)

			if not success2 then
				warn(`failed to update verification status: {err2}`)
				label.Text = "status: ❌❓"
			else
				player:SetAttribute("Verified", true)
				label.Text = "status: ✅"
				print(`player {player.Name} verified successfully`)
			end
		else
			print(`player {player.Name} isn't verified`)
			label.Text = "status: ❌"
			player:SetAttribute("Timeout", true)
			task.wait(10)
			player:SetAttribute("Timeout", false)
		end
	else
		label.Text = "status: ❌❓❓"
		warn(`failed to check verification status: {response}`)
	end
end)
