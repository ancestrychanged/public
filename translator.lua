-- you can change those 5 variables
local model = "google" -- google/deepl
local deepl_apikey = 'your_deepl_apikey_here' -- only if you're using deepl; tutorial: https://support.deepl.com/hc/en-us/articles/360020695820-API-Key-for-DeepL-s-API
local fixColor = true -- whether you want to preserve the color (while translating) in the new chat system
local oldSystemRemoveWhitespaceWarning = false -- i don't recommend changing this to true if you're in a high-end game that uses the old chat system (i.e. evade)
local debugmode = false -- change to true if you wanna see stuff in console

-- everything below is the functionality
-- don't touch it if you don't know what are you doing blah blah blah
-- made with <3 by 2-13
-- dm me on discord if you have any questions:
-- ancestrychanged






local request = assert(request or http.request or http_request, "error: your executor does not support the 'request' function")
local getrawmetatable = assert(getrawmetatable, "error: your executor does not support the 'getrawmetatable' function")
local setreadonly = assert(setreadonly, "error: your executor does not support the 'setreadonly' function")
local newcclosure = assert(newcclosure, "error: your executor does not support the 'newcclosure' function")
local getnamecallmethod = assert(getnamecallmethod, "error: your executor does not support the 'getnamecallmethod' function")
	
local chatService = game:GetService("TextChatService")
local rep = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService") -- keeping this for encoding/decoding purposes
local player = game:GetService("Players").LocalPlayer

local currentlang
local flag = false -- remoteevent flag so the message will actually send due to __namecall sending the same intercepted event twice
local db = false -- debounce for the new chat system so the message won't get translated twice

local supportedLangsDeepL = {
	-- i swear i'm not YandereDev
	"bg", "en", "zh",
	"cz", "da", "nl",
	"en", "et", "fi",
	"fr", "de", "el-GR",
	"hu", "it", "ja",
	"ko", "lv", "lt",
	"nb", "pt-BR", "pt",
	"ro", "ru", "sk",
	"sl", "sp", "es",
	"sv-SE", "tr"
}

local function urlencode(str)
    if str then
        str = str:gsub("([^%w%-%.%_%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
    end
    return str
end

local function checklanguage(code)
	for _, validCode in ipairs(supportedLangsDeepL) do
		if validCode == code then
			return true
		end
	end
	return false
end

local colors =
{
	Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
	Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
	Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
	BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color,
}

local function namehash(username)
	local value = 0
	for i = 1, #username do
		local colorValue = string.byte(string.sub(username, i, i))
		local reverseIndex = #username - i + 1
		if #username%2 == 1 then
			reverseIndex = reverseIndex - 1
		end
		if reverseIndex%4 >= 2 then
			colorValue = -colorValue
	end
		value = value + colorValue
	end
	return value
end

local offset = 0
local function getcolor(pName)
	return colors[((namehash(pName) + offset) % #colors) + 1]
end

local function Color3ToRichText(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return string.format("rgb(%d,%d,%d)", r, g, b)
end

local function translate(original, languageCode)
	if debugmode then print(original, languageCode) end
	if model == "deepl" then
		if deepl_apikey == 'your_deepl_apikey_here' then
			warn("your deepl api key wasn't found or you forgot to change it; changing the model to google")
			model = "google"
			return translate(original, languageCode)
		end
		local body = "text=" .. original .. "&target_lang=" .. languageCode
		local headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
			["Authorization"] = `DeepL-Auth-Key {deepl_apikey}`
		}

		local req = request({
			Url = "https://api-free.deepl.com/v2/translate",
			Method = "POST",
			Headers = headers,
			Body = body
		})

		if req and req.StatusCode == 200 then
			local response = http:JSONDecode(req.Body)
			if response then
				return response.translations[1].text
			else
				warn("wtf?", req.StatusCode, response)
			end
		else
			warn("fail deepl", req.StatusCode)
		end

		return original
	else
		local enc = urlencode(original)
		local req = request({
			Url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. languageCode .. "&dt=t&q=" .. enc,
			Method = "GET"
		})

		if req and req.StatusCode == 200 then
			local response = http:JSONDecode(req.Body)
			if response then
				local translations = response[1] 
				local fullTranslation = ""
				
				for _, translation in ipairs(translations) do
					fullTranslation = fullTranslation .. translation[1]
				end

				return fullTranslation:match("^%s*(.-)%s*$")
			else
				warn("wtf?", req.StatusCode, response)
			end
		else
			warn("fail google", req.StatusCode)
		end
		
		return "error" .. req.StatusCode
	end
end

local function hookMessage(m)
	if debugmode then print('func called') end
	m = string.gsub(m, "&gt;", ">")
	m = string.gsub(m, "&lt;", "<")

	if string.sub(m, 1, 2) == ">d" and (string.len(m) == 2 or string.sub(m, 3, 3) == " ") then
		currentlang = nil
		if debugmode then print("disabled") end
		return "\n"
	end

	local prefix = string.match(m, "^>([%a%-]+)")
	if prefix and checklanguage(prefix) then
		currentlang = prefix
		if debugmode then print("lang set to", currentlang) end
		return translate(string.sub(m, #prefix + 2):gsub("^%s+", ""), currentlang)
	end

	if currentlang then
		if debugmode then print("translating message with lang", currentlang) end
		return translate(m, currentlang)
	end

	if debugmode then print("no translation") end
	return m
end

if player.PlayerGui:FindFirstChild("Chat") then -- old system (i hate it)
	if rep:FindFirstChild("DefaultChatSystemChatEvents") then
		local mt = getrawmetatable(game)
		local old = mt.__namecall

		setreadonly(mt, false)

		mt.__namecall = newcclosure(function(self, ...)
			-- had to spend >6 hours learning UNC docs
			-- >:(
			local method = getnamecallmethod()
			local args = {...}

			if tostring(self) == "SayMessageRequest" and method == "FireServer" then
				if flag then
					return old(self, unpack(args))
				end

				local originalMessage = args[1]
				args[1] = "\n" -- this gets blocked so ppl wont see it
				-- iirc bc you can't send whitespace into the old chat

				old(self, unpack(args))
				task.spawn(function()
					local translatedMessage = hookMessage(originalMessage)
					flag = true

					rep:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(translatedMessage, args[2] or "All")
					flag = false
				end)
				return
			end
			return old(self, unpack(args))
		end)

		setreadonly(mt, true)
	else
		error("the folder that contains the chat event wasn't found, the game you're in probably has a custom chat")
	end
else -- new system
	local channel = chatService.TextChannels.RBXGeneral

	if channel then
		channel.OnIncomingMessage = function(m)
			if fixColor then
				local rgb = Color3ToRichText(getcolor(player.Name))
				m.PrefixText = `<font color="{rgb}">{player.Name}:</font>`
			end

			if not db then
				db = true
				-- so, for some reason, the richtext breaks when i overwrite this function
				-- therefore i have to change it locally
				-- other clients wont see this change so i call it a win-win situation
				if tostring(m.TextSource) == tostring(player.Name) then
					-- and only translate messages sent by self
					m.Text = hookMessage(m.Text)
				end
				
				-- i doubt someone's gonna spam in chat
				-- ..on a second thought, its their fault if they do :P
                                task.delay(0.45, function()
                                        db = false
                                end)
			end
		end
	end
end

if debugmode then -- optional
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end

if oldSystemRemoveWhitespaceWarning then
	local log: Frame = player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller
	
	if not log:FindFirstChildOfClass("UIListLayout") then
		local list = Instance.new("UIListLayout")
		list.Padding = UDim.new(0, 0)
		list.Archivable = true
		list.FillDirection = Enum.FillDirection.Vertical
		list.HorizontalAlignment = Enum.HorizontalAlignment.Left
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.VerticalAlignment = Enum.VerticalAlignment.Top
		list.Parent = log
	end
	
	log.ChildAdded:Connect(function()
		for _, v in ipairs(log:GetChildren()) do
			if v:IsA("Frame") then
				local textLabel = v:FindFirstChildOfClass("TextLabel")
				if textLabel and textLabel.Text == "Your message contains whitespace that is not allowed." then
					task.wait(1 / workspace:GetRealPhysicsFPS()) -- removing this will make the chat ugly
					v:Destroy()
				end
			end
		end
	end)
end

print('translator initialized')
if debugmode then
	print(`\nmodel: {model}\nold chat system: {oldSystemRemoveWhitespaceWarning}`)
end
