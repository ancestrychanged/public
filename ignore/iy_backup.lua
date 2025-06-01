if IY_LOADED and not _G.IY_DEBUG == true then
    -- error("Infinite Yield is already running!", 0)
    return
end

pcall(function() getgenv().IY_LOADED = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback or nil
end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden =  missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden =  missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
queueteleport =  missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
httprequest =  missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
firetouchinterest = missing("function", firetouchinterest)
waxwritefile, waxreadfile = writefile, readfile
writefile = missing("function", waxwritefile) and function(file, data, safe)
    if safe == true then return pcall(waxwritefile, file, data) end
    waxwritefile(file, data)
end
readfile = missing("function", waxreadfile) and function(file, safe)
    if safe == true then return pcall(waxreadfile, file) end
    return waxreadfile(file)
end
isfile = missing("function", isfile, readfile and function(file)
    local success, result = pcall(function()
        return readfile(file)
    end)
    return success and result ~= nil and result ~= ""
end)
makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)
waxgetcustomasset = missing("function", getcustomasset or getsynasset)
hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)

COREGUI = cloneref(game:GetService("CoreGui"))
Players = cloneref(game:GetService("Players"))
UserInputService = cloneref(game:GetService("UserInputService"))
TweenService = cloneref(game:GetService("TweenService"))
HttpService = cloneref(game:GetService("HttpService"))
MarketplaceService = cloneref(game:GetService("MarketplaceService"))
RunService = cloneref(game:GetService("RunService"))
TeleportService = cloneref(game:GetService("TeleportService"))
StarterGui = cloneref(game:GetService("StarterGui"))
GuiService = cloneref(game:GetService("GuiService"))
Lighting = cloneref(game:GetService("Lighting"))
ContextActionService = cloneref(game:GetService("ContextActionService"))
ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
GroupService = cloneref(game:GetService("GroupService"))
PathService = cloneref(game:GetService("PathfindingService"))
SoundService = cloneref(game:GetService("SoundService"))
Teams = cloneref(game:GetService("Teams"))
StarterPlayer = cloneref(game:GetService("StarterPlayer"))
InsertService = cloneref(game:GetService("InsertService"))
ChatService = cloneref(game:GetService("Chat"))
ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
ContentProvider = cloneref(game:GetService("ContentProvider"))
StatsService = cloneref(game:GetService("Stats"))
MaterialService = cloneref(game:GetService("MaterialService"))
AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
TextService = cloneref(game:GetService("TextService"))
TextChatService = cloneref(game:GetService("TextChatService"))
CaptureService = cloneref(game:GetService("CaptureService"))
VoiceChatService = cloneref(game:GetService("VoiceChatService"))

IYMouse = cloneref(Players.LocalPlayer:GetMouse())
PlayerGui = cloneref(Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui"))
PlaceId, JobId = game.PlaceId, game.JobId
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

-- xylex & europa
local iyassets = {
    ["infiniteyield/assets/bindsandplugins.png"] = "rbxassetid://5147695474",
    ["infiniteyield/assets/close.png"] = "rbxassetid://5054663650",
    ["infiniteyield/assets/editaliases.png"] = "rbxassetid://5147488658",
    ["infiniteyield/assets/editkeybinds.png"] = "rbxassetid://129697930",
    ["infiniteyield/assets/edittheme.png"] = "rbxassetid://4911962991",
    ["infiniteyield/assets/editwaypoints.png"] = "rbxassetid://5147488592",
    ["infiniteyield/assets/imgstudiopluginlogo.png"] = "rbxassetid://4113050383",
    ["infiniteyield/assets/logo.png"] = "rbxassetid://1352543873",
    ["infiniteyield/assets/minimize.png"] = "rbxassetid://2406617031",
    ["infiniteyield/assets/pin.png"] = "rbxassetid://6234691350",
    ["infiniteyield/assets/reference.png"] = "rbxassetid://3523243755",
    ["infiniteyield/assets/settings.png"] = "rbxassetid://1204397029"
}

local function getcustomasset(asset)
    if waxgetcustomasset then
        local success, result = pcall(function()
            return waxgetcustomasset(asset)
        end)
        if success and result ~= nil and result ~= "" then
            return result
        end
    end
    return iyassets[asset]
end

if makefolder and isfolder and writefile and isfile then
    pcall(function() -- good executor trust
        local assets = "https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/"
        for _, folder in {"infiniteyield", "infiniteyield/assets"} do
            if not isfolder(folder) then
                makefolder(folder)
            end
        end
        for path in iyassets do
            if not isfile(path) then
                writefile(path, game:HttpGet((path:gsub("infiniteyield/", assets))))
            end
        end
    end)
end

currentVersion = "6.3.2"

ScaledHolder = Instance.new("Frame")
Scale = Instance.new("UIScale")
Holder = Instance.new("Frame")
Title = Instance.new("TextLabel")
Dark = Instance.new("Frame")
Cmdbar = Instance.new("TextBox")
CMDsF = Instance.new("ScrollingFrame")
cmdListLayout = Instance.new("UIListLayout")
SettingsButton = Instance.new("ImageButton")
ColorsButton = Instance.new("ImageButton")
Settings = Instance.new("Frame")
Prefix = Instance.new("TextLabel")
PrefixBox = Instance.new("TextBox")
Keybinds = Instance.new("TextLabel")
StayOpen = Instance.new("TextLabel")
Button = Instance.new("Frame")
On = Instance.new("TextButton")
Positions = Instance.new("TextLabel")
EventBind = Instance.new("TextLabel")
Plugins = Instance.new("TextLabel")
Example = Instance.new("TextButton")
Notification = Instance.new("Frame")
Title_2 = Instance.new("TextLabel")
Text_2 = Instance.new("TextLabel")
CloseButton = Instance.new("TextButton")
CloseImage = Instance.new("ImageLabel")
PinButton = Instance.new("TextButton")
PinImage = Instance.new("ImageLabel")
Tooltip = Instance.new("Frame")
Title_3 = Instance.new("TextLabel")
Description = Instance.new("TextLabel")
IntroBackground = Instance.new("Frame")
Logo = Instance.new("ImageLabel")
Credits = Instance.new("TextBox")
KeybindsFrame = Instance.new("Frame")
Close = Instance.new("TextButton")
Add = Instance.new("TextButton")
Delete = Instance.new("TextButton")
Holder_2 = Instance.new("ScrollingFrame")
Example_2 = Instance.new("Frame")
Text_3 = Instance.new("TextLabel")
Delete_2 = Instance.new("TextButton")
KeybindEditor = Instance.new("Frame")
background_2 = Instance.new("Frame")
Dark_3 = Instance.new("Frame")
Directions = Instance.new("TextLabel")
BindTo = Instance.new("TextButton")
TriggerLabel = Instance.new("TextLabel")
BindTriggerSelect = Instance.new("TextButton")
Add_2 = Instance.new("TextButton")
Toggles = Instance.new("ScrollingFrame")
ClickTP  = Instance.new("TextLabel")
Select = Instance.new("TextButton")
ClickDelete = Instance.new("TextLabel")
Select_2 = Instance.new("TextButton")
Cmdbar_2 = Instance.new("TextBox")
Cmdbar_3 = Instance.new("TextBox")
CreateToggle = Instance.new("TextLabel")
Button_2 = Instance.new("Frame")
On_2 = Instance.new("TextButton")
shadow_2 = Instance.new("Frame")
PopupText_2 = Instance.new("TextLabel")
Exit_2 = Instance.new("TextButton")
ExitImage_2 = Instance.new("ImageLabel")
PositionsFrame = Instance.new("Frame")
Close_3 = Instance.new("TextButton")
Delete_5 = Instance.new("TextButton")
Part = Instance.new("TextButton")
Holder_4 = Instance.new("ScrollingFrame")
Example_4 = Instance.new("Frame")
Text_5 = Instance.new("TextLabel")
Delete_6 = Instance.new("TextButton")
TP = Instance.new("TextButton")
AliasesFrame = Instance.new("Frame")
Close_2 = Instance.new("TextButton")
Delete_3 = Instance.new("TextButton")
Holder_3 = Instance.new("ScrollingFrame")
Example_3 = Instance.new("Frame")
Text_4 = Instance.new("TextLabel")
Delete_4 = Instance.new("TextButton")
Aliases = Instance.new("TextLabel")
PluginsFrame = Instance.new("Frame")
Close_4 = Instance.new("TextButton")
Add_3 = Instance.new("TextButton")
Holder_5 = Instance.new("ScrollingFrame")
Example_5 = Instance.new("Frame")
Text_6 = Instance.new("TextLabel")
Delete_7 = Instance.new("TextButton")
PluginEditor = Instance.new("Frame")
background_3 = Instance.new("Frame")
Dark_2 = Instance.new("Frame")
Img = Instance.new("ImageButton")
AddPlugin = Instance.new("TextButton")
FileName = Instance.new("TextBox")
About = Instance.new("TextLabel")
Directions_2 = Instance.new("TextLabel")
shadow_3 = Instance.new("Frame")
PopupText_3 = Instance.new("TextLabel")
Exit_3 = Instance.new("TextButton")
ExitImage_3 = Instance.new("ImageLabel")
AliasHint = Instance.new("TextLabel")
PluginsHint = Instance.new("TextLabel")
PositionsHint = Instance.new("TextLabel")
ToPartFrame = Instance.new("Frame")
background_4 = Instance.new("Frame")
ChoosePart = Instance.new("TextButton")
CopyPath = Instance.new("TextButton")
Directions_3 = Instance.new("TextLabel")
Path = Instance.new("TextLabel")
shadow_4 = Instance.new("Frame")
PopupText_5 = Instance.new("TextLabel")
Exit_4 = Instance.new("TextButton")
ExitImage_5 = Instance.new("ImageLabel")
logs = Instance.new("Frame")
shadow = Instance.new("Frame")
Hide = Instance.new("TextButton")
ImageLabel = Instance.new("ImageLabel")
PopupText = Instance.new("TextLabel")
Exit = Instance.new("TextButton")
ImageLabel_2 = Instance.new("ImageLabel")
background = Instance.new("Frame")
chat = Instance.new("Frame")
Clear = Instance.new("TextButton")
SaveChatlogs = Instance.new("TextButton")
Toggle = Instance.new("TextButton")
scroll_2 = Instance.new("ScrollingFrame")
join = Instance.new("Frame")
Toggle_2 = Instance.new("TextButton")
Clear_2 = Instance.new("TextButton")
scroll_3 = Instance.new("ScrollingFrame")
listlayout = Instance.new("UIListLayout",scroll_3)
selectChat = Instance.new("TextButton")
selectJoin = Instance.new("TextButton")

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

PARENT = nil
if get_hidden_gui or gethui then
    local hiddenUI = get_hidden_gui or gethui
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.Parent = hiddenUI()
    PARENT = Main
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    syn.protect_gui(Main)
    Main.Parent = COREGUI
    PARENT = Main
elseif COREGUI:FindFirstChild("RobloxGui") then
    PARENT = COREGUI.RobloxGui
else
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.Parent = COREGUI
    PARENT = Main
end

shade1 = {}
shade2 = {}
shade3 = {}
text1 = {}
text2 = {}
scroll = {}

ScaledHolder.Name = randomString()
ScaledHolder.Size = UDim2.fromScale(1, 1)
ScaledHolder.BackgroundTransparency = 1
ScaledHolder.Parent = PARENT
Scale.Name = randomString()

Holder.Name = randomString()
Holder.Parent = ScaledHolder
Holder.Active = true
Holder.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(1, -250, 1, -220)
Holder.Size = UDim2.new(0, 250, 0, 220)
Holder.ZIndex = 10
table.insert(shade2,Holder)

Title.Name = "Title"
Title.Parent = Holder
Title.Active = true
Title.BackgroundColor3 = Color3.fromRGB(36,36,37)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0, 250, 0, 20)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 18
Title.Text = "Infinite Yield FE v" .. currentVersion

do
	local emoji = ({
		["01 01"] = "🎆",
		[(function(Year)
			local A = math.floor(Year/100)
			local B = math.floor((13+8*A)/25)
			local C = (15-B+A-math.floor(A/4))%30
			local D = (4+A-math.floor(A/4))%7
			local E = (19*(Year%19)+C)%30
			local F = (2*(Year%4)+4*(Year%7)+6*E+D)%7
			local G = (22+E+F)
			if E == 29 and F == 6 then
				return "04 19"
			elseif E == 28 and F == 6 then
				return "04 18"
			elseif 31 < G then
				return ("04 %02d"):format(G-31)
			end
			return ("03 %02d"):format(G)
		end)(tonumber(os.date"%Y"))] = "🥚",
		["10 31"] = "🎃",
		["12 25"] = "🎄"
	})[os.date("%m %d")]
	if emoji then
		Title.Text = ("%s %s %s"):format(emoji, Title.Text, emoji)
	end
end

Title.TextColor3 = Color3.new(1, 1, 1)
Title.ZIndex = 10
table.insert(shade1,Title)
table.insert(text1,Title)

Dark.Name = "Dark"
Dark.Parent = Holder
Dark.Active = true
Dark.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
Dark.BorderSizePixel = 0
Dark.Position = UDim2.new(0, 0, 0, 45)
Dark.Size = UDim2.new(0, 250, 0, 175)
Dark.ZIndex = 10
table.insert(shade1,Dark)

Cmdbar.Name = "Cmdbar"
Cmdbar.Parent = Holder
Cmdbar.BackgroundTransparency = 1
Cmdbar.BorderSizePixel = 0
Cmdbar.Position = UDim2.new(0, 5, 0, 20)
Cmdbar.Size = UDim2.new(0, 240, 0, 25)
Cmdbar.Font = Enum.Font.SourceSans
Cmdbar.TextSize = 18
Cmdbar.TextXAlignment = Enum.TextXAlignment.Left
Cmdbar.TextColor3 = Color3.new(1, 1, 1)
Cmdbar.Text = ""
Cmdbar.ZIndex = 10
Cmdbar.PlaceholderText = "Command Bar"

CMDsF.Name = "CMDs"
CMDsF.Parent = Holder
CMDsF.BackgroundTransparency = 1
CMDsF.BorderSizePixel = 0
CMDsF.Position = UDim2.new(0, 5, 0, 45)
CMDsF.Size = UDim2.new(0, 245, 0, 175)
CMDsF.ScrollBarImageColor3 = Color3.fromRGB(78,78,79)
CMDsF.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
CMDsF.CanvasSize = UDim2.new(0, 0, 0, 0)
CMDsF.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
CMDsF.ScrollBarThickness = 8
CMDsF.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
CMDsF.VerticalScrollBarInset = 'Always'
CMDsF.ZIndex = 10
table.insert(scroll,CMDsF)

cmdListLayout.Parent = CMDsF

SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = Holder
SettingsButton.BackgroundTransparency = 1
SettingsButton.Position = UDim2.new(0, 230, 0, 0)
SettingsButton.Size = UDim2.new(0, 20, 0, 20)
SettingsButton.Image = getcustomasset("infiniteyield/assets/settings.png")
SettingsButton.ZIndex = 10

ReferenceButton = Instance.new("ImageButton")
ReferenceButton.Name = "ReferenceButton"
ReferenceButton.Parent = Holder
ReferenceButton.BackgroundTransparency = 1
ReferenceButton.Position = UDim2.new(0, 212, 0, 2)
ReferenceButton.Size = UDim2.new(0, 16, 0, 16)
ReferenceButton.Image = getcustomasset("infiniteyield/assets/reference.png")
ReferenceButton.ZIndex = 10

Settings.Name = "Settings"
Settings.Parent = Holder
Settings.Active = true
Settings.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
Settings.BorderSizePixel = 0
Settings.Position = UDim2.new(0, 0, 0, 220)
Settings.Size = UDim2.new(0, 250, 0, 175)
Settings.ZIndex = 10
table.insert(shade1,Settings)

SettingsHolder = Instance.new("ScrollingFrame")
SettingsHolder.Name = "Holder"
SettingsHolder.Parent = Settings
SettingsHolder.BackgroundTransparency = 1
SettingsHolder.BorderSizePixel = 0
SettingsHolder.Size = UDim2.new(1,0,1,0)
SettingsHolder.ScrollBarImageColor3 = Color3.fromRGB(78,78,79)
SettingsHolder.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsHolder.CanvasSize = UDim2.new(0, 0, 0, 235)
SettingsHolder.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsHolder.ScrollBarThickness = 8
SettingsHolder.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsHolder.VerticalScrollBarInset = 'Always'
SettingsHolder.ZIndex = 10
table.insert(scroll,SettingsHolder)

Prefix.Name = "Prefix"
Prefix.Parent = SettingsHolder
Prefix.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Prefix.BorderSizePixel = 0
Prefix.BackgroundTransparency = 1
Prefix.Position = UDim2.new(0, 5, 0, 5)
Prefix.Size = UDim2.new(1, -10, 0, 20)
Prefix.Font = Enum.Font.SourceSans
Prefix.TextSize = 14
Prefix.Text = "Prefix"
Prefix.TextColor3 = Color3.new(1, 1, 1)
Prefix.TextXAlignment = Enum.TextXAlignment.Left
Prefix.ZIndex = 10
table.insert(shade2,Prefix)
table.insert(text1,Prefix)

PrefixBox.Name = "PrefixBox"
PrefixBox.Parent = Prefix
PrefixBox.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
PrefixBox.BorderSizePixel = 0
PrefixBox.Position = UDim2.new(1, -20, 0, 0)
PrefixBox.Size = UDim2.new(0, 20, 0, 20)
PrefixBox.Font = Enum.Font.SourceSansBold
PrefixBox.TextSize = 14
PrefixBox.Text = ''
PrefixBox.TextColor3 = Color3.new(0, 0, 0)
PrefixBox.ZIndex = 10
table.insert(shade3,PrefixBox)
table.insert(text2,PrefixBox)

function makeSettingsButton(name,iconID,off)
	local button = Instance.new("TextButton")
	button.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
	button.BorderSizePixel = 0
	button.Position = UDim2.new(0,0,0,0)
	button.Size = UDim2.new(1,0,0,25)
	button.Text = ""
	button.ZIndex = 10
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Parent = button
	icon.Position = UDim2.new(0,5,0,5)
	icon.Size = UDim2.new(0,16,0,16)
	icon.BackgroundTransparency = 1
	icon.Image = iconID
	icon.ZIndex = 10
	if off then
		icon.ScaleType = Enum.ScaleType.Crop
		icon.ImageRectSize = Vector2.new(16,16)
		icon.ImageRectOffset = Vector2.new(off,0)
	end
	local label = Instance.new("TextLabel")
	label.Name = "ButtonLabel"
	label.Parent = button
	label.BackgroundTransparency = 1
	label.Text = name
	label.Position = UDim2.new(0,28,0,0)
	label.Size = UDim2.new(1,-28,1,0)
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 14
	label.ZIndex = 10
	label.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(shade2,button)
	table.insert(text1,label)
	return button
end

ColorsButton = makeSettingsButton("Edit Theme",getcustomasset("infiniteyield/assets/edittheme.png"))
ColorsButton.Position = UDim2.new(0, 5, 0, 55)
ColorsButton.Size = UDim2.new(1, -10, 0, 25)
ColorsButton.Name = "Colors"
ColorsButton.Parent = SettingsHolder

Keybinds = makeSettingsButton("Edit Keybinds",getcustomasset("infiniteyield/assets/editkeybinds.png"))
Keybinds.Position = UDim2.new(0, 5, 0, 85)
Keybinds.Size = UDim2.new(1, -10, 0, 25)
Keybinds.Name = "Keybinds"
Keybinds.Parent = SettingsHolder

Aliases = makeSettingsButton("Edit Aliases",getcustomasset("infiniteyield/assets/editaliases.png"))
Aliases.Position = UDim2.new(0, 5, 0, 115)
Aliases.Size = UDim2.new(1, -10, 0, 25)
Aliases.Name = "Aliases"
Aliases.Parent = SettingsHolder

StayOpen.Name = "StayOpen"
StayOpen.Parent = SettingsHolder
StayOpen.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
StayOpen.BorderSizePixel = 0
StayOpen.BackgroundTransparency = 1
StayOpen.Position = UDim2.new(0, 5, 0, 30)
StayOpen.Size = UDim2.new(1, -10, 0, 20)
StayOpen.Font = Enum.Font.SourceSans
StayOpen.TextSize = 14
StayOpen.Text = "Keep Menu Open"
StayOpen.TextColor3 = Color3.new(1, 1, 1)
StayOpen.TextXAlignment = Enum.TextXAlignment.Left
StayOpen.ZIndex = 10
table.insert(shade2,StayOpen)
table.insert(text1,StayOpen)

Button.Name = "Button"
Button.Parent = StayOpen
Button.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(1, -20, 0, 0)
Button.Size = UDim2.new(0, 20, 0, 20)
Button.ZIndex = 10
table.insert(shade3,Button)

On.Name = "On"
On.Parent = Button
On.BackgroundColor3 = Color3.fromRGB(150, 150, 151)
On.BackgroundTransparency = 1
On.BorderSizePixel = 0
On.Position = UDim2.new(0, 2, 0, 2)
On.Size = UDim2.new(0, 16, 0, 16)
On.Font = Enum.Font.SourceSans
On.FontSize = Enum.FontSize.Size14
On.Text = ""
On.TextColor3 = Color3.new(0, 0, 0)
On.ZIndex = 10

Positions = makeSettingsButton("Edit/Goto Waypoints",getcustomasset("infiniteyield/assets/editwaypoints.png"))
Positions.Position = UDim2.new(0, 5, 0, 145)
Positions.Size = UDim2.new(1, -10, 0, 25)
Positions.Name = "Waypoints"
Positions.Parent = SettingsHolder

EventBind = makeSettingsButton("Edit Event Binds",getcustomasset("infiniteyield/assets/bindsandplugins.png"),759)
EventBind.Position = UDim2.new(0, 5, 0, 205)
EventBind.Size = UDim2.new(1, -10, 0, 25)
EventBind.Name = "EventBinds"
EventBind.Parent = SettingsHolder

Plugins = makeSettingsButton("Manage Plugins",getcustomasset("infiniteyield/assets/bindsandplugins.png"),743)
Plugins.Position = UDim2.new(0, 5, 0, 175)
Plugins.Size = UDim2.new(1, -10, 0, 25)
Plugins.Name = "Plugins"
Plugins.Parent = SettingsHolder

Example.Name = "Example"
Example.Parent = Holder
Example.BackgroundTransparency = 1
Example.BorderSizePixel = 0
Example.Size = UDim2.new(0, 190, 0, 20)
Example.Visible = false
Example.Font = Enum.Font.SourceSans
Example.TextSize = 18
Example.Text = "Example"
Example.TextColor3 = Color3.new(1, 1, 1)
Example.TextXAlignment = Enum.TextXAlignment.Left
Example.ZIndex = 10
table.insert(text1,Example)

Notification.Name = randomString()
Notification.Parent = ScaledHolder
Notification.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
Notification.BorderSizePixel = 0
Notification.Position = UDim2.new(1, -500, 1, 20)
Notification.Size = UDim2.new(0, 250, 0, 100)
Notification.ZIndex = 10
table.insert(shade1,Notification)

Title_2.Name = "Title"
Title_2.Parent = Notification
Title_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Title_2.BorderSizePixel = 0
Title_2.Size = UDim2.new(0, 250, 0, 20)
Title_2.Font = Enum.Font.SourceSans
Title_2.TextSize = 14
Title_2.Text = "Notification Title"
Title_2.TextColor3 = Color3.new(1, 1, 1)
Title_2.ZIndex = 10
table.insert(shade2,Title_2)
table.insert(text1,Title_2)

Text_2.Name = "Text"
Text_2.Parent = Notification
Text_2.BackgroundTransparency = 1
Text_2.BorderSizePixel = 0
Text_2.Position = UDim2.new(0, 5, 0, 25)
Text_2.Size = UDim2.new(0, 240, 0, 75)
Text_2.Font = Enum.Font.SourceSans
Text_2.TextSize = 16
Text_2.Text = "Notification Text"
Text_2.TextColor3 = Color3.new(1, 1, 1)
Text_2.TextWrapped = true
Text_2.ZIndex = 10
table.insert(text1,Text_2)

CloseButton.Name = "CloseButton"
CloseButton.Parent = Notification
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -20, 0, 0)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Text = ""
CloseButton.ZIndex = 10

CloseImage.Parent = CloseButton
CloseImage.BackgroundColor3 = Color3.new(1, 1, 1)
CloseImage.BackgroundTransparency = 1
CloseImage.Position = UDim2.new(0, 5, 0, 5)
CloseImage.Size = UDim2.new(0, 10, 0, 10)
CloseImage.Image = getcustomasset("infiniteyield/assets/close.png")
CloseImage.ZIndex = 10

PinButton.Name = "PinButton"
PinButton.Parent = Notification
PinButton.BackgroundTransparency = 1
PinButton.Size = UDim2.new(0, 20, 0, 20)
PinButton.ZIndex = 10
PinButton.Text = ""

PinImage.Parent = PinButton
PinImage.BackgroundColor3 = Color3.new(1, 1, 1)
PinImage.BackgroundTransparency = 1
PinImage.Position = UDim2.new(0, 3, 0, 3)
PinImage.Size = UDim2.new(0, 14, 0, 14)
PinImage.ZIndex = 10
PinImage.Image = getcustomasset("infiniteyield/assets/pin.png")

Tooltip.Name = randomString()
Tooltip.Parent = ScaledHolder
Tooltip.Active = true
Tooltip.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
Tooltip.BackgroundTransparency = 0.1
Tooltip.BorderSizePixel = 0
Tooltip.Size = UDim2.new(0, 200, 0, 96)
Tooltip.Visible = false
Tooltip.ZIndex = 10
table.insert(shade1,Tooltip)

Title_3.Name = "Title"
Title_3.Parent = Tooltip
Title_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Title_3.BackgroundTransparency = 0.1
Title_3.BorderSizePixel = 0
Title_3.Size = UDim2.new(0, 200, 0, 20)
Title_3.Font = Enum.Font.SourceSans
Title_3.TextSize = 14
Title_3.Text = ""
Title_3.TextColor3 = Color3.new(1, 1, 1)
Title_3.TextTransparency = 0.1
Title_3.ZIndex = 10
table.insert(shade2,Title_3)
table.insert(text1,Title_3)

Description.Name = "Description"
Description.Parent = Tooltip
Description.BackgroundTransparency = 1
Description.BorderSizePixel = 0
Description.Size = UDim2.new(0,180,0,72)
Description.Position = UDim2.new(0,10,0,18)
Description.Font = Enum.Font.SourceSans
Description.TextSize = 16
Description.Text = ""
Description.TextColor3 = Color3.new(1, 1, 1)
Description.TextTransparency = 0.1
Description.TextWrapped = true
Description.ZIndex = 10
table.insert(text1,Description)

IntroBackground.Name = "IntroBackground"
IntroBackground.Parent = Holder
IntroBackground.Active = true
IntroBackground.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
IntroBackground.BorderSizePixel = 0
IntroBackground.Position = UDim2.new(0, 0, 0, 45)
IntroBackground.Size = UDim2.new(0, 250, 0, 175)
IntroBackground.ZIndex = 10

Logo.Name = "Logo"
Logo.Parent = Holder
Logo.BackgroundTransparency = 1
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0, 125, 0, 127)
Logo.Size = UDim2.new(0, 10, 0, 10)
Logo.Image = getcustomasset("infiniteyield/assets/logo.png")
Logo.ImageTransparency = 0
Logo.ZIndex = 10

Credits.Name = "Credits"
Credits.Parent = Holder
Credits.BackgroundTransparency = 1
Credits.BorderSizePixel = 0
Credits.Position = UDim2.new(0, 0, 0.9, 30)
Credits.Size = UDim2.new(0, 250, 0, 20)
Credits.Font = Enum.Font.SourceSansLight
Credits.FontSize = Enum.FontSize.Size14
Credits.Text = "Edge // Zwolf // Moon // Toon // Peyton // ATP"
Credits.TextColor3 = Color3.new(1, 1, 1)
Credits.ZIndex = 10

KeybindsFrame.Name = "KeybindsFrame"
KeybindsFrame.Parent = Settings
KeybindsFrame.Active = true
KeybindsFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
KeybindsFrame.BorderSizePixel = 0
KeybindsFrame.Position = UDim2.new(0, 0, 0, 175)
KeybindsFrame.Size = UDim2.new(0, 250, 0, 175)
KeybindsFrame.ZIndex = 10
table.insert(shade1,KeybindsFrame)

Close.Name = "Close"
Close.Parent = KeybindsFrame
Close.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0, 205, 0, 150)
Close.Size = UDim2.new(0, 40, 0, 20)
Close.Font = Enum.Font.SourceSans
Close.TextSize = 14
Close.Text = "Close"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.ZIndex = 10
table.insert(shade2,Close)
table.insert(text1,Close)

Add.Name = "Add"
Add.Parent = KeybindsFrame
Add.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Add.BorderSizePixel = 0
Add.Position = UDim2.new(0, 5, 0, 150)
Add.Size = UDim2.new(0, 40, 0, 20)
Add.Font = Enum.Font.SourceSans
Add.TextSize = 14
Add.Text = "Add"
Add.TextColor3 = Color3.new(1, 1, 1)
Add.ZIndex = 10
table.insert(shade2,Add)
table.insert(text1,Add)

Delete.Name = "Delete"
Delete.Parent = KeybindsFrame
Delete.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Delete.BorderSizePixel = 0
Delete.Position = UDim2.new(0, 50, 0, 150)
Delete.Size = UDim2.new(0, 40, 0, 20)
Delete.Font = Enum.Font.SourceSans
Delete.TextSize = 14
Delete.Text = "Clear"
Delete.TextColor3 = Color3.new(1, 1, 1)
Delete.ZIndex = 10
table.insert(shade2,Delete)
table.insert(text1,Delete)

Holder_2.Name = "Holder"
Holder_2.Parent = KeybindsFrame
Holder_2.BackgroundTransparency = 1
Holder_2.BorderSizePixel = 0
Holder_2.Position = UDim2.new(0, 0, 0, 0)
Holder_2.Size = UDim2.new(0, 250, 0, 145)
Holder_2.ScrollBarImageColor3 = Color3.fromRGB(78,78,79)
Holder_2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_2.CanvasSize = UDim2.new(0, 0, 0, 0)
Holder_2.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_2.ScrollBarThickness = 0
Holder_2.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_2.VerticalScrollBarInset = 'Always'
Holder_2.ZIndex = 10

Example_2.Name = "Example"
Example_2.Parent = KeybindsFrame
Example_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Example_2.BorderSizePixel = 0
Example_2.Size = UDim2.new(0, 10, 0, 20)
Example_2.Visible = false
Example_2.ZIndex = 10
table.insert(shade2,Example_2)

Text_3.Name = "Text"
Text_3.Parent = Example_2
Text_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Text_3.BorderSizePixel = 0
Text_3.Position = UDim2.new(0, 10, 0, 0)
Text_3.Size = UDim2.new(0, 240, 0, 20)
Text_3.Font = Enum.Font.SourceSans
Text_3.TextSize = 14
Text_3.Text = "nom"
Text_3.TextColor3 = Color3.new(1, 1, 1)
Text_3.TextXAlignment = Enum.TextXAlignment.Left
Text_3.ZIndex = 10
table.insert(shade2,Text_3)
table.insert(text1,Text_3)

Delete_2.Name = "Delete"
Delete_2.Parent = Text_3
Delete_2.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Delete_2.BorderSizePixel = 0
Delete_2.Position = UDim2.new(0, 200, 0, 0)
Delete_2.Size = UDim2.new(0, 40, 0, 20)
Delete_2.Font = Enum.Font.SourceSans
Delete_2.TextSize = 14
Delete_2.Text = "Delete"
Delete_2.TextColor3 = Color3.new(0, 0, 0)
Delete_2.ZIndex = 10
table.insert(shade3,Delete_2)
table.insert(text2,Delete_2)

KeybindEditor.Name = randomString()
KeybindEditor.Parent = ScaledHolder
KeybindEditor.Active = true
KeybindEditor.BackgroundTransparency = 1
KeybindEditor.Position = UDim2.new(0.5, -180, 0, -500)
KeybindEditor.Size = UDim2.new(0, 360, 0, 20)
KeybindEditor.ZIndex = 10

background_2.Name = "background"
background_2.Parent = KeybindEditor
background_2.Active = true
background_2.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
background_2.BorderSizePixel = 0
background_2.Position = UDim2.new(0, 0, 0, 20)
background_2.Size = UDim2.new(0, 360, 0, 185)
background_2.ZIndex = 10
table.insert(shade1,background_2)

Dark_3.Name = "Dark"
Dark_3.Parent = background_2
Dark_3.Active = true
Dark_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Dark_3.BorderSizePixel = 0
Dark_3.Position = UDim2.new(0, 135, 0, 0)
Dark_3.Size = UDim2.new(0, 2, 0, 185)
Dark_3.ZIndex = 10
table.insert(shade2,Dark_3)

Directions.Name = "Directions"
Directions.Parent = background_2
Directions.BackgroundTransparency = 1
Directions.BorderSizePixel = 0
Directions.Position = UDim2.new(0, 10, 0, 15)
Directions.Size = UDim2.new(0, 115, 0, 90)
Directions.ZIndex = 10
Directions.Font = Enum.Font.SourceSans
Directions.Text = "Click the button below and press a key/mouse button. Then select what you want to bind it to."
Directions.TextColor3 = Color3.fromRGB(255, 255, 255)
Directions.TextSize = 14.000
Directions.TextWrapped = true
Directions.TextYAlignment = Enum.TextYAlignment.Top
table.insert(text1,Directions)

BindTo.Name = "BindTo"
BindTo.Parent = background_2
BindTo.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
BindTo.BorderSizePixel = 0
BindTo.Position = UDim2.new(0, 10, 0, 95)
BindTo.Size = UDim2.new(0, 115, 0, 50)
BindTo.ZIndex = 10
BindTo.Font = Enum.Font.SourceSans
BindTo.Text = "Click to bind"
BindTo.TextColor3 = Color3.fromRGB(255, 255, 255)
BindTo.TextSize = 16.000
table.insert(shade2,BindTo)
table.insert(text1,BindTo)

TriggerLabel.Name = "TriggerLabel"
TriggerLabel.Parent = background_2
TriggerLabel.BackgroundTransparency = 1
TriggerLabel.Position = UDim2.new(0, 10, 0, 155)
TriggerLabel.Size = UDim2.new(0, 45, 0, 20)
TriggerLabel.ZIndex = 10
TriggerLabel.Font = Enum.Font.SourceSans
TriggerLabel.Text = "Trigger:"
TriggerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TriggerLabel.TextSize = 14.000
TriggerLabel.TextXAlignment = Enum.TextXAlignment.Left
table.insert(text1,TriggerLabel)

BindTriggerSelect.Name = "BindTo"
BindTriggerSelect.Parent = background_2
BindTriggerSelect.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
BindTriggerSelect.BorderSizePixel = 0
BindTriggerSelect.Position = UDim2.new(0, 60, 0, 155)
BindTriggerSelect.Size = UDim2.new(0, 65, 0, 20)
BindTriggerSelect.ZIndex = 10
BindTriggerSelect.Font = Enum.Font.SourceSans
BindTriggerSelect.Text = "KeyDown"
BindTriggerSelect.TextColor3 = Color3.fromRGB(255, 255, 255)
BindTriggerSelect.TextSize = 16.000
table.insert(shade2,BindTriggerSelect)
table.insert(text1,BindTriggerSelect)

Add_2.Name = "Add"
Add_2.Parent = background_2
Add_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Add_2.BorderSizePixel = 0
Add_2.Position = UDim2.new(0, 310, 0, 35)
Add_2.Size = UDim2.new(0, 40, 0, 20)
Add_2.ZIndex = 10
Add_2.Font = Enum.Font.SourceSans
Add_2.Text = "Add"
Add_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Add_2.TextSize = 14.000
table.insert(shade2,Add_2)
table.insert(text1,Add_2)

Toggles.Name = "Toggles"
Toggles.Parent = background_2
Toggles.BackgroundTransparency = 1
Toggles.BorderSizePixel = 0
Toggles.Position = UDim2.new(0, 150, 0, 125)
Toggles.Size = UDim2.new(0, 200, 0, 50)
Toggles.ZIndex = 10
Toggles.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Toggles.CanvasSize = UDim2.new(0, 0, 0, 50)
Toggles.ScrollBarThickness = 8
Toggles.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Toggles.VerticalScrollBarInset = Enum.ScrollBarInset.Always
table.insert(scroll,Toggles)

ClickTP.Name = "Click TP (Hold Key & Click)"
ClickTP.Parent = Toggles
ClickTP.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
ClickTP.BorderSizePixel = 0
ClickTP.Size = UDim2.new(0, 200, 0, 20)
ClickTP.ZIndex = 10
ClickTP.Font = Enum.Font.SourceSans
ClickTP.Text = "    Click TP (Hold Key & Click)"
ClickTP.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickTP.TextSize = 14.000
ClickTP.TextXAlignment = Enum.TextXAlignment.Left
table.insert(shade2,ClickTP)
table.insert(text1,ClickTP)

Select.Name = "Select"
Select.Parent = ClickTP
Select.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Select.BorderSizePixel = 0
Select.Position = UDim2.new(0, 160, 0, 0)
Select.Size = UDim2.new(0, 40, 0, 20)
Select.ZIndex = 10
Select.Font = Enum.Font.SourceSans
Select.Text = "Add"
Select.TextColor3 = Color3.fromRGB(0, 0, 0)
Select.TextSize = 14.000
table.insert(shade3,Select)
table.insert(text2,Select)

ClickDelete.Name = "Click Delete (Hold Key & Click)"
ClickDelete.Parent = Toggles
ClickDelete.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
ClickDelete.BorderSizePixel = 0
ClickDelete.Position = UDim2.new(0, 0, 0, 25)
ClickDelete.Size = UDim2.new(0, 200, 0, 20)
ClickDelete.ZIndex = 10
ClickDelete.Font = Enum.Font.SourceSans
ClickDelete.Text = "    Click Delete (Hold Key & Click)"
ClickDelete.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickDelete.TextSize = 14.000
ClickDelete.TextXAlignment = Enum.TextXAlignment.Left
table.insert(shade2,ClickDelete)
table.insert(text1,ClickDelete)

Select_2.Name = "Select"
Select_2.Parent = ClickDelete
Select_2.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Select_2.BorderSizePixel = 0
Select_2.Position = UDim2.new(0, 160, 0, 0)
Select_2.Size = UDim2.new(0, 40, 0, 20)
Select_2.ZIndex = 10
Select_2.Font = Enum.Font.SourceSans
Select_2.Text = "Add"
Select_2.TextColor3 = Color3.fromRGB(0, 0, 0)
Select_2.TextSize = 14.000
table.insert(shade3,Select_2)
table.insert(text2,Select_2)

Cmdbar_2.Name = "Cmdbar_2"
Cmdbar_2.Parent = background_2
Cmdbar_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Cmdbar_2.BorderSizePixel = 0
Cmdbar_2.Position = UDim2.new(0, 150, 0, 35)
Cmdbar_2.Size = UDim2.new(0, 150, 0, 20)
Cmdbar_2.ZIndex = 10
Cmdbar_2.Font = Enum.Font.SourceSans
Cmdbar_2.PlaceholderText = "Command"
Cmdbar_2.Text = ""
Cmdbar_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Cmdbar_2.TextSize = 14.000
Cmdbar_2.TextXAlignment = Enum.TextXAlignment.Left

Cmdbar_3.Name = "Cmdbar_3"
Cmdbar_3.Parent = background_2
Cmdbar_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Cmdbar_3.BorderSizePixel = 0
Cmdbar_3.Position = UDim2.new(0, 150, 0, 60)
Cmdbar_3.Size = UDim2.new(0, 150, 0, 20)
Cmdbar_3.ZIndex = 10
Cmdbar_3.Font = Enum.Font.SourceSans
Cmdbar_3.PlaceholderText = "Command 2"
Cmdbar_3.Text = ""
Cmdbar_3.TextColor3 = Color3.fromRGB(255, 255, 255)
Cmdbar_3.TextSize = 14.000
Cmdbar_3.TextXAlignment = Enum.TextXAlignment.Left

CreateToggle.Name = "CreateToggle"
CreateToggle.Parent = background_2
CreateToggle.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
CreateToggle.BackgroundTransparency = 1
CreateToggle.BorderSizePixel = 0
CreateToggle.Position = UDim2.new(0, 152, 0, 10)
CreateToggle.Size = UDim2.new(0, 198, 0, 20)
CreateToggle.ZIndex = 10
CreateToggle.Font = Enum.Font.SourceSans
CreateToggle.Text = "Create Toggle"
CreateToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
CreateToggle.TextSize = 14.000
CreateToggle.TextXAlignment = Enum.TextXAlignment.Left
table.insert(text1,CreateToggle)

Button_2.Name = "Button"
Button_2.Parent = CreateToggle
Button_2.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Button_2.BorderSizePixel = 0
Button_2.Position = UDim2.new(1, -20, 0, 0)
Button_2.Size = UDim2.new(0, 20, 0, 20)
Button_2.ZIndex = 10
table.insert(shade3,Button_2)

On_2.Name = "On"
On_2.Parent = Button_2
On_2.BackgroundColor3 = Color3.fromRGB(150, 150, 151)
On_2.BackgroundTransparency = 1
On_2.BorderSizePixel = 0
On_2.Position = UDim2.new(0, 2, 0, 2)
On_2.Size = UDim2.new(0, 16, 0, 16)
On_2.ZIndex = 10
On_2.Font = Enum.Font.SourceSans
On_2.Text = ""
On_2.TextColor3 = Color3.fromRGB(0, 0, 0)
On_2.TextSize = 14.000

shadow_2.Name = "shadow"
shadow_2.Parent = KeybindEditor
shadow_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
shadow_2.BorderSizePixel = 0
shadow_2.Size = UDim2.new(0, 360, 0, 20)
shadow_2.ZIndex = 10
table.insert(shade2,shadow_2)

PopupText_2.Name = "PopupText_2"
PopupText_2.Parent = shadow_2
PopupText_2.BackgroundTransparency = 1
PopupText_2.Size = UDim2.new(1, 0, 0.949999988, 0)
PopupText_2.ZIndex = 10
PopupText_2.Font = Enum.Font.SourceSans
PopupText_2.Text = "Set Keybinds"
PopupText_2.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText_2.TextSize = 14.000
PopupText_2.TextWrapped = true
table.insert(text1,PopupText_2)

Exit_2.Name = "Exit_2"
Exit_2.Parent = shadow_2
Exit_2.BackgroundTransparency = 1
Exit_2.Position = UDim2.new(1, -20, 0, 0)
Exit_2.Size = UDim2.new(0, 20, 0, 20)
Exit_2.ZIndex = 10
Exit_2.Text = ""

ExitImage_2.Parent = Exit_2
ExitImage_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExitImage_2.BackgroundTransparency = 1
ExitImage_2.Position = UDim2.new(0, 5, 0, 5)
ExitImage_2.Size = UDim2.new(0, 10, 0, 10)
ExitImage_2.ZIndex = 10
ExitImage_2.Image = getcustomasset("infiniteyield/assets/close.png")

PositionsFrame.Name = "PositionsFrame"
PositionsFrame.Parent = Settings
PositionsFrame.Active = true
PositionsFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
PositionsFrame.BorderSizePixel = 0
PositionsFrame.Size = UDim2.new(0, 250, 0, 175)
PositionsFrame.Position = UDim2.new(0, 0, 0, 175)
PositionsFrame.ZIndex = 10
table.insert(shade1,PositionsFrame)

Close_3.Name = "Close"
Close_3.Parent = PositionsFrame
Close_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Close_3.BorderSizePixel = 0
Close_3.Position = UDim2.new(0, 205, 0, 150)
Close_3.Size = UDim2.new(0, 40, 0, 20)
Close_3.Font = Enum.Font.SourceSans
Close_3.TextSize = 14
Close_3.Text = "Close"
Close_3.TextColor3 = Color3.new(1, 1, 1)
Close_3.ZIndex = 10
table.insert(shade2,Close_3)
table.insert(text1,Close_3)

Delete_5.Name = "Delete"
Delete_5.Parent = PositionsFrame
Delete_5.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Delete_5.BorderSizePixel = 0
Delete_5.Position = UDim2.new(0, 50, 0, 150)
Delete_5.Size = UDim2.new(0, 40, 0, 20)
Delete_5.Font = Enum.Font.SourceSans
Delete_5.TextSize = 14
Delete_5.Text = "Clear"
Delete_5.TextColor3 = Color3.new(1, 1, 1)
Delete_5.ZIndex = 10
table.insert(shade2,Delete_5)
table.insert(text1,Delete_5)

Part.Name = "PartGoto"
Part.Parent = PositionsFrame
Part.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Part.BorderSizePixel = 0
Part.Position = UDim2.new(0, 5, 0, 150)
Part.Size = UDim2.new(0, 40, 0, 20)
Part.Font = Enum.Font.SourceSans
Part.TextSize = 14
Part.Text = "Part"
Part.TextColor3 = Color3.new(1, 1, 1)
Part.ZIndex = 10
table.insert(shade2,Part)
table.insert(text1,Part)

Holder_4.Name = "Holder"
Holder_4.Parent = PositionsFrame
Holder_4.BackgroundTransparency = 1
Holder_4.BorderSizePixel = 0
Holder_4.Position = UDim2.new(0, 0, 0, 0)
Holder_4.Selectable = false
Holder_4.Size = UDim2.new(0, 250, 0, 145)
Holder_4.ScrollBarImageColor3 = Color3.fromRGB(78,78,79)
Holder_4.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_4.CanvasSize = UDim2.new(0, 0, 0, 0)
Holder_4.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_4.ScrollBarThickness = 0
Holder_4.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_4.VerticalScrollBarInset = 'Always'
Holder_4.ZIndex = 10

Example_4.Name = "Example"
Example_4.Parent = PositionsFrame
Example_4.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Example_4.BorderSizePixel = 0
Example_4.Size = UDim2.new(0, 10, 0, 20)
Example_4.Visible = false
Example_4.Position = UDim2.new(0, 0, 0, -5)
Example_4.ZIndex = 10
table.insert(shade2,Example_4)

Text_5.Name = "Text"
Text_5.Parent = Example_4
Text_5.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Text_5.BorderSizePixel = 0
Text_5.Position = UDim2.new(0, 10, 0, 0)
Text_5.Size = UDim2.new(0, 240, 0, 20)
Text_5.Font = Enum.Font.SourceSans
Text_5.TextSize = 14
Text_5.Text = "Position"
Text_5.TextColor3 = Color3.new(1, 1, 1)
Text_5.TextXAlignment = Enum.TextXAlignment.Left
Text_5.ZIndex = 10
table.insert(shade2,Text_5)
table.insert(text1,Text_5)

Delete_6.Name = "Delete"
Delete_6.Parent = Text_5
Delete_6.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Delete_6.BorderSizePixel = 0
Delete_6.Position = UDim2.new(0, 200, 0, 0)
Delete_6.Size = UDim2.new(0, 40, 0, 20)
Delete_6.Font = Enum.Font.SourceSans
Delete_6.TextSize = 14
Delete_6.Text = "Delete"
Delete_6.TextColor3 = Color3.new(0, 0, 0)
Delete_6.ZIndex = 10
table.insert(shade3,Delete_6)
table.insert(text2,Delete_6)

TP.Name = "TP"
TP.Parent = Text_5
TP.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
TP.BorderSizePixel = 0
TP.Position = UDim2.new(0, 155, 0, 0)
TP.Size = UDim2.new(0, 40, 0, 20)
TP.Font = Enum.Font.SourceSans
TP.TextSize = 14
TP.Text = "Goto"
TP.TextColor3 = Color3.new(0, 0, 0)
TP.ZIndex = 10
table.insert(shade3,TP)
table.insert(text2,TP)

AliasesFrame.Name = "AliasesFrame"
AliasesFrame.Parent = Settings
AliasesFrame.Active = true
AliasesFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
AliasesFrame.BorderSizePixel = 0
AliasesFrame.Position = UDim2.new(0, 0, 0, 175)
AliasesFrame.Size = UDim2.new(0, 250, 0, 175)
AliasesFrame.ZIndex = 10
table.insert(shade1,AliasesFrame)

Close_2.Name = "Close"
Close_2.Parent = AliasesFrame
Close_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Close_2.BorderSizePixel = 0
Close_2.Position = UDim2.new(0, 205, 0, 150)
Close_2.Size = UDim2.new(0, 40, 0, 20)
Close_2.Font = Enum.Font.SourceSans
Close_2.TextSize = 14
Close_2.Text = "Close"
Close_2.TextColor3 = Color3.new(1, 1, 1)
Close_2.ZIndex = 10
table.insert(shade2,Close_2)
table.insert(text1,Close_2)

Delete_3.Name = "Delete"
Delete_3.Parent = AliasesFrame
Delete_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Delete_3.BorderSizePixel = 0
Delete_3.Position = UDim2.new(0, 5, 0, 150)
Delete_3.Size = UDim2.new(0, 40, 0, 20)
Delete_3.Font = Enum.Font.SourceSans
Delete_3.TextSize = 14
Delete_3.Text = "Clear"
Delete_3.TextColor3 = Color3.new(1, 1, 1)
Delete_3.ZIndex = 10
table.insert(shade2,Delete_3)
table.insert(text1,Delete_3)

Holder_3.Name = "Holder"
Holder_3.Parent = AliasesFrame
Holder_3.BackgroundTransparency = 1
Holder_3.BorderSizePixel = 0
Holder_3.Position = UDim2.new(0, 0, 0, 0)
Holder_3.Size = UDim2.new(0, 250, 0, 145)
Holder_3.ScrollBarImageColor3 = Color3.fromRGB(78,78,79)
Holder_3.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_3.CanvasSize = UDim2.new(0, 0, 0, 0)
Holder_3.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_3.ScrollBarThickness = 0
Holder_3.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_3.VerticalScrollBarInset = 'Always'
Holder_3.ZIndex = 10

Example_3.Name = "Example"
Example_3.Parent = AliasesFrame
Example_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Example_3.BorderSizePixel = 0
Example_3.Size = UDim2.new(0, 10, 0, 20)
Example_3.Visible = false
Example_3.ZIndex = 10
table.insert(shade2,Example_3)

Text_4.Name = "Text"
Text_4.Parent = Example_3
Text_4.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Text_4.BorderSizePixel = 0
Text_4.Position = UDim2.new(0, 10, 0, 0)
Text_4.Size = UDim2.new(0, 240, 0, 20)
Text_4.Font = Enum.Font.SourceSans
Text_4.TextSize = 14
Text_4.Text = "honk"
Text_4.TextColor3 = Color3.new(1, 1, 1)
Text_4.TextXAlignment = Enum.TextXAlignment.Left
Text_4.ZIndex = 10
table.insert(shade2,Text_4)
table.insert(text1,Text_4)

Delete_4.Name = "Delete"
Delete_4.Parent = Text_4
Delete_4.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Delete_4.BorderSizePixel = 0
Delete_4.Position = UDim2.new(0, 200, 0, 0)
Delete_4.Size = UDim2.new(0, 40, 0, 20)
Delete_4.Font = Enum.Font.SourceSans
Delete_4.TextSize = 14
Delete_4.Text = "Delete"
Delete_4.TextColor3 = Color3.new(0, 0, 0)
Delete_4.ZIndex = 10
table.insert(shade3,Delete_4)
table.insert(text2,Delete_4)

PluginsFrame.Name = "PluginsFrame"
PluginsFrame.Parent = Settings
PluginsFrame.Active = true
PluginsFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
PluginsFrame.BorderSizePixel = 0
PluginsFrame.Position = UDim2.new(0, 0, 0, 175)
PluginsFrame.Size = UDim2.new(0, 250, 0, 175)
PluginsFrame.ZIndex = 10
table.insert(shade1,PluginsFrame)

Close_4.Name = "Close"
Close_4.Parent = PluginsFrame
Close_4.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Close_4.BorderSizePixel = 0
Close_4.Position = UDim2.new(0, 205, 0, 150)
Close_4.Size = UDim2.new(0, 40, 0, 20)
Close_4.Font = Enum.Font.SourceSans
Close_4.TextSize = 14
Close_4.Text = "Close"
Close_4.TextColor3 = Color3.new(1, 1, 1)
Close_4.ZIndex = 10
table.insert(shade2,Close_4)
table.insert(text1,Close_4)

Add_3.Name = "Add"
Add_3.Parent = PluginsFrame
Add_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Add_3.BorderSizePixel = 0
Add_3.Position = UDim2.new(0, 5, 0, 150)
Add_3.Size = UDim2.new(0, 40, 0, 20)
Add_3.Font = Enum.Font.SourceSans
Add_3.TextSize = 14
Add_3.Text = "Add"
Add_3.TextColor3 = Color3.new(1, 1, 1)
Add_3.ZIndex = 10
table.insert(shade2,Add_3)
table.insert(text1,Add_3)

Holder_5.Name = "Holder"
Holder_5.Parent = PluginsFrame
Holder_5.BackgroundTransparency = 1
Holder_5.BorderSizePixel = 0
Holder_5.Position = UDim2.new(0, 0, 0, 0)
Holder_5.Selectable = false
Holder_5.Size = UDim2.new(0, 250, 0, 145)
Holder_5.ScrollBarImageColor3 = Color3.fromRGB(78,78,79)
Holder_5.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_5.CanvasSize = UDim2.new(0, 0, 0, 0)
Holder_5.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_5.ScrollBarThickness = 0
Holder_5.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Holder_5.VerticalScrollBarInset = 'Always'
Holder_5.ZIndex = 10

Example_5.Name = "Example"
Example_5.Parent = PluginsFrame
Example_5.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Example_5.BorderSizePixel = 0
Example_5.Size = UDim2.new(0, 10, 0, 20)
Example_5.Visible = false
Example_5.ZIndex = 10
table.insert(shade2,Example_5)

Text_6.Name = "Text"
Text_6.Parent = Example_5
Text_6.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Text_6.BorderSizePixel = 0
Text_6.Position = UDim2.new(0, 10, 0, 0)
Text_6.Size = UDim2.new(0, 240, 0, 20)
Text_6.Font = Enum.Font.SourceSans
Text_6.TextSize = 14
Text_6.Text = "F4 > Toggle Fly"
Text_6.TextColor3 = Color3.new(1, 1, 1)
Text_6.TextXAlignment = Enum.TextXAlignment.Left
Text_6.ZIndex = 10
table.insert(shade2,Text_6)
table.insert(text1,Text_6)

Delete_7.Name = "Delete"
Delete_7.Parent = Text_6
Delete_7.BackgroundColor3 = Color3.fromRGB(78, 78, 79)
Delete_7.BorderSizePixel = 0
Delete_7.Position = UDim2.new(0, 200, 0, 0)
Delete_7.Size = UDim2.new(0, 40, 0, 20)
Delete_7.Font = Enum.Font.SourceSans
Delete_7.TextSize = 14
Delete_7.Text = "Delete"
Delete_7.TextColor3 = Color3.new(0, 0, 0)
Delete_7.ZIndex = 10
table.insert(shade3,Delete_7)
table.insert(text2,Delete_7)

PluginEditor.Name = randomString()
PluginEditor.Parent = ScaledHolder
PluginEditor.BorderSizePixel = 0
PluginEditor.Active = true
PluginEditor.BackgroundTransparency = 1
PluginEditor.Position = UDim2.new(0.5, -180, 0, -500)
PluginEditor.Size = UDim2.new(0, 360, 0, 20)
PluginEditor.ZIndex = 10

background_3.Name = "background"
background_3.Parent = PluginEditor
background_3.Active = true
background_3.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
background_3.BorderSizePixel = 0
background_3.Position = UDim2.new(0, 0, 0, 20)
background_3.Size = UDim2.new(0, 360, 0, 160)
background_3.ZIndex = 10
table.insert(shade1,background_3)

Dark_2.Name = "Dark"
Dark_2.Parent = background_3
Dark_2.Active = true
Dark_2.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
Dark_2.BorderSizePixel = 0
Dark_2.Position = UDim2.new(0, 222, 0, 0)
Dark_2.Size = UDim2.new(0, 2, 0, 160)
Dark_2.ZIndex = 10
table.insert(shade2,Dark_2)

Img.Name = "Img"
Img.Parent = background_3
Img.BackgroundTransparency = 1
Img.Position = UDim2.new(0, 242, 0, 3)
Img.Size = UDim2.new(0, 100, 0, 95)
Img.Image = getcustomasset("infiniteyield/assets/imgstudiopluginlogo.png")
Img.ZIndex = 10

AddPlugin.Name = "AddPlugin"
AddPlugin.Parent = background_3
AddPlugin.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
AddPlugin.BorderSizePixel = 0
AddPlugin.Position = UDim2.new(0, 235, 0, 100)
AddPlugin.Size = UDim2.new(0, 115, 0, 50)
AddPlugin.Font = Enum.Font.SourceSans
AddPlugin.TextSize = 14
AddPlugin.Text = "Add Plugin"
AddPlugin.TextColor3 = Color3.new(1, 1, 1)
AddPlugin.ZIndex = 10
table.insert(shade2,AddPlugin)
table.insert(text1,AddPlugin)

FileName.Name = "FileName"
FileName.Parent = background_3
FileName.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
FileName.BorderSizePixel = 0
FileName.Position = UDim2.new(0.028, 0, 0.625, 0)
FileName.Size = UDim2.new(0, 200, 0, 50)
FileName.Font = Enum.Font.SourceSans
FileName.TextSize = 14
FileName.Text = "Plugin File Name"
FileName.TextColor3 = Color3.new(1, 1, 1)
FileName.ZIndex = 10
table.insert(shade2,FileName)
table.insert(text1,FileName)

About.Name = "About"
About.Parent = background_3
About.BackgroundTransparency = 1
About.BorderSizePixel = 0
About.Position = UDim2.new(0, 17, 0, 10)
About.Size = UDim2.new(0, 187, 0, 49)
About.Font = Enum.Font.SourceSans
About.TextSize = 14
About.Text = "Plugins are .iy files and should be located in the 'workspace' folder of your exploit."
About.TextColor3 = Color3.fromRGB(255, 255, 255)
About.TextWrapped = true
About.TextYAlignment = Enum.TextYAlignment.Top
About.ZIndex = 10
table.insert(text1,About)

Directions_2.Name = "Directions"
Directions_2.Parent = background_3
Directions_2.BackgroundTransparency = 1
Directions_2.BorderSizePixel = 0
Directions_2.Position = UDim2.new(0, 17, 0, 60)
Directions_2.Size = UDim2.new(0, 187, 0, 49)
Directions_2.Font = Enum.Font.SourceSans
Directions_2.TextSize = 14
Directions_2.Text = "Type the name of the plugin file you want to add below."
Directions_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Directions_2.TextWrapped = true
Directions_2.TextYAlignment = Enum.TextYAlignment.Top
Directions_2.ZIndex = 10
table.insert(text1,Directions_2)

shadow_3.Name = "shadow"
shadow_3.Parent = PluginEditor
shadow_3.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
shadow_3.BorderSizePixel = 0
shadow_3.Size = UDim2.new(0, 360, 0, 20)
shadow_3.ZIndex = 10
table.insert(shade2,shadow_3)

PopupText_3.Name = "PopupText"
PopupText_3.Parent = shadow_3
PopupText_3.BackgroundTransparency = 1
PopupText_3.Size = UDim2.new(1, 0, 0.95, 0)
PopupText_3.ZIndex = 10
PopupText_3.Font = Enum.Font.SourceSans
PopupText_3.TextSize = 14
PopupText_3.Text = "Add Plugins"
PopupText_3.TextColor3 = Color3.new(1, 1, 1)
PopupText_3.TextWrapped = true
table.insert(text1,PopupText_3)

Exit_3.Name = "Exit"
Exit_3.Parent = shadow_3
Exit_3.BackgroundTransparency = 1
Exit_3.Position = UDim2.new(1, -20, 0, 0)
Exit_3.Size = UDim2.new(0, 20, 0, 20)
Exit_3.Text = ""
Exit_3.ZIndex = 10

ExitImage_3.Parent = Exit_3
ExitImage_3.BackgroundColor3 = Color3.new(1, 1, 1)
ExitImage_3.BackgroundTransparency = 1
ExitImage_3.Position = UDim2.new(0, 5, 0, 5)
ExitImage_3.Size = UDim2.new(0, 10, 0, 10)
ExitImage_3.Image = getcustomasset("infiniteyield/assets/close.png")
ExitImage_3.ZIndex = 10

AliasHint.Name = "AliasHint"
AliasHint.Parent = AliasesFrame
AliasHint.BackgroundTransparency = 1
AliasHint.BorderSizePixel = 0
AliasHint.Position = UDim2.new(0, 25, 0, 40)
AliasHint.Size = UDim2.new(0, 200, 0, 50)
AliasHint.Font = Enum.Font.SourceSansItalic
AliasHint.TextSize = 16
AliasHint.Text = "Add aliases by using the 'addalias' command"
AliasHint.TextColor3 = Color3.new(1, 1, 1)
AliasHint.TextStrokeColor3 = Color3.new(1, 1, 1)
AliasHint.TextWrapped = true
AliasHint.ZIndex = 10
table.insert(text1,AliasHint)

PluginsHint.Name = "PluginsHint"
PluginsHint.Parent = PluginsFrame
PluginsHint.BackgroundTransparency = 1
PluginsHint.BorderSizePixel = 0
PluginsHint.Position = UDim2.new(0, 25, 0, 40)
PluginsHint.Size = UDim2.new(0, 200, 0, 50)
PluginsHint.Font = Enum.Font.SourceSansItalic
PluginsHint.TextSize = 16
PluginsHint.Text = "Download plugins from the IY Discord (discord.gg/78ZuWSq)"
PluginsHint.TextColor3 = Color3.new(1, 1, 1)
PluginsHint.TextStrokeColor3 = Color3.new(1, 1, 1)
PluginsHint.TextWrapped = true
PluginsHint.ZIndex = 10
table.insert(text1,PluginsHint)

PositionsHint.Name = "PositionsHint"
PositionsHint.Parent = PositionsFrame
PositionsHint.BackgroundTransparency = 1
PositionsHint.BorderSizePixel = 0
PositionsHint.Position = UDim2.new(0, 25, 0, 40)
PositionsHint.Size = UDim2.new(0, 200, 0, 70)
PositionsHint.Font = Enum.Font.SourceSansItalic
PositionsHint.TextSize = 16
PositionsHint.Text = "Use the 'swp' or 'setwaypoint' command to add a position using your character (NOTE: Part teleports will not save)"
PositionsHint.TextColor3 = Color3.new(1, 1, 1)
PositionsHint.TextStrokeColor3 = Color3.new(1, 1, 1)
PositionsHint.TextWrapped = true
PositionsHint.ZIndex = 10
table.insert(text1,PositionsHint)

ToPartFrame.Name = randomString()
ToPartFrame.Parent = ScaledHolder
ToPartFrame.Active = true
ToPartFrame.BackgroundTransparency = 1
ToPartFrame.Position = UDim2.new(0.5, -180, 0, -500)
ToPartFrame.Size = UDim2.new(0, 360, 0, 20)
ToPartFrame.ZIndex = 10

background_4.Name = "background"
background_4.Parent = ToPartFrame
background_4.Active = true
background_4.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
background_4.BorderSizePixel = 0
background_4.Position = UDim2.new(0, 0, 0, 20)
background_4.Size = UDim2.new(0, 360, 0, 117)
background_4.ZIndex = 10
table.insert(shade1,background_4)

ChoosePart.Name = "ChoosePart"
ChoosePart.Parent = background_4
ChoosePart.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
ChoosePart.BorderSizePixel = 0
ChoosePart.Position = UDim2.new(0, 100, 0, 55)
ChoosePart.Size = UDim2.new(0, 75, 0, 30)
ChoosePart.Font = Enum.Font.SourceSans
ChoosePart.TextSize = 14
ChoosePart.Text = "Select Part"
ChoosePart.TextColor3 = Color3.new(1, 1, 1)
ChoosePart.ZIndex = 10
table.insert(shade2,ChoosePart)
table.insert(text1,ChoosePart)

CopyPath.Name = "CopyPath"
CopyPath.Parent = background_4
CopyPath.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
CopyPath.BorderSizePixel = 0
CopyPath.Position = UDim2.new(0, 185, 0, 55)
CopyPath.Size = UDim2.new(0, 75, 0, 30)
CopyPath.Font = Enum.Font.SourceSans
CopyPath.TextSize = 14
CopyPath.Text = "Copy Path"
CopyPath.TextColor3 = Color3.new(1, 1, 1)
CopyPath.ZIndex = 10
table.insert(shade2,CopyPath)
table.insert(text1,CopyPath)

Directions_3.Name = "Directions"
Directions_3.Parent = background_4
Directions_3.BackgroundTransparency = 1
Directions_3.BorderSizePixel = 0
Directions_3.Position = UDim2.new(0, 51, 0, 17)
Directions_3.Size = UDim2.new(0, 257, 0, 32)
Directions_3.Font = Enum.Font.SourceSans
Directions_3.TextSize = 14
Directions_3.Text = 'Click on a part and then click the "Select Part" button below to set it as a teleport location'
Directions_3.TextColor3 = Color3.new(1, 1, 1)
Directions_3.TextWrapped = true
Directions_3.TextYAlignment = Enum.TextYAlignment.Top
Directions_3.ZIndex = 10
table.insert(text1,Directions_3)

Path.Name = "Path"
Path.Parent = background_4
Path.BackgroundTransparency = 1
Path.BorderSizePixel = 0
Path.Position = UDim2.new(0, 0, 0, 94)
Path.Size = UDim2.new(0, 360, 0, 16)
Path.Font = Enum.Font.SourceSansItalic
Path.TextSize = 14
Path.Text = ""
Path.TextColor3 = Color3.new(1, 1, 1)
Path.TextScaled = true
Path.TextWrapped = true
Path.TextYAlignment = Enum.TextYAlignment.Top
Path.ZIndex = 10
table.insert(text1,Path)

shadow_4.Name = "shadow"
shadow_4.Parent = ToPartFrame
shadow_4.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
shadow_4.BorderSizePixel = 0
shadow_4.Size = UDim2.new(0, 360, 0, 20)
shadow_4.ZIndex = 10
table.insert(shade2,shadow_4)

PopupText_5.Name = "PopupText"
PopupText_5.Parent = shadow_4
PopupText_5.BackgroundTransparency = 1
PopupText_5.Size = UDim2.new(1, 0, 0.95, 0)
PopupText_5.ZIndex = 10
PopupText_5.Font = Enum.Font.SourceSans
PopupText_5.TextSize = 14
PopupText_5.Text = "Teleport to Part"
PopupText_5.TextColor3 = Color3.new(1, 1, 1)
PopupText_5.TextWrapped = true
table.insert(text1,PopupText_5)

Exit_4.Name = "Exit"
Exit_4.Parent = shadow_4
Exit_4.BackgroundTransparency = 1
Exit_4.Position = UDim2.new(1, -20, 0, 0)
Exit_4.Size = UDim2.new(0, 20, 0, 20)
Exit_4.Text = ""
Exit_4.ZIndex = 10

ExitImage_5.Parent = Exit_4
ExitImage_5.BackgroundColor3 = Color3.new(1, 1, 1)
ExitImage_5.BackgroundTransparency = 1
ExitImage_5.Position = UDim2.new(0, 5, 0, 5)
ExitImage_5.Size = UDim2.new(0, 10, 0, 10)
ExitImage_5.Image = getcustomasset("infiniteyield/assets/close.png")
ExitImage_5.ZIndex = 10

logs.Name = randomString()
logs.Parent = ScaledHolder
logs.Active = true
logs.BackgroundTransparency = 1
logs.Position = UDim2.new(0, 0, 1, 10)
logs.Size = UDim2.new(0, 338, 0, 20)
logs.ZIndex = 10

shadow.Name = "shadow"
shadow.Parent = logs
shadow.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
shadow.BorderSizePixel = 0
shadow.Position = UDim2.new(0, 0, 0.00999999978, 0)
shadow.Size = UDim2.new(0, 338, 0, 20)
shadow.ZIndex = 10
table.insert(shade2,shadow)

Hide.Name = "Hide"
Hide.Parent = shadow
Hide.BackgroundTransparency = 1
Hide.Position = UDim2.new(1, -40, 0, 0)
Hide.Size = UDim2.new(0, 20, 0, 20)
Hide.ZIndex = 10
Hide.Text = ""

ImageLabel.Parent = Hide
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, 3, 0, 3)
ImageLabel.Size = UDim2.new(0, 14, 0, 14)
ImageLabel.Image = getcustomasset("infiniteyield/assets/minimize.png")
ImageLabel.ZIndex = 10

PopupText.Name = "PopupText"
PopupText.Parent = shadow
PopupText.BackgroundTransparency = 1
PopupText.Size = UDim2.new(1, 0, 0.949999988, 0)
PopupText.ZIndex = 10
PopupText.Font = Enum.Font.SourceSans
PopupText.FontSize = Enum.FontSize.Size14
PopupText.Text = "Logs"
PopupText.TextColor3 = Color3.new(1, 1, 1)
PopupText.TextWrapped = true
table.insert(text1,PopupText)

Exit.Name = "Exit"
Exit.Parent = shadow
Exit.BackgroundTransparency = 1
Exit.Position = UDim2.new(1, -20, 0, 0)
Exit.Size = UDim2.new(0, 20, 0, 20)
Exit.ZIndex = 10
Exit.Text = ""

ImageLabel_2.Parent = Exit
ImageLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_2.BackgroundTransparency = 1
ImageLabel_2.Position = UDim2.new(0, 5, 0, 5)
ImageLabel_2.Size = UDim2.new(0, 10, 0, 10)
ImageLabel_2.Image = getcustomasset("infiniteyield/assets/close.png")
ImageLabel_2.ZIndex = 10

background.Name = "background"
background.Parent = logs
background.Active = true
background.BackgroundColor3 = Color3.new(0.141176, 0.141176, 0.145098)
background.BorderSizePixel = 0
background.ClipsDescendants = true
background.Position = UDim2.new(0, 0, 1, 0)
background.Size = UDim2.new(0, 338, 0, 245)
background.ZIndex = 10

chat.Name = "chat"
chat.Parent = background
chat.Active = true
chat.BackgroundColor3 = Color3.new(0.141176, 0.141176, 0.145098)
chat.BorderSizePixel = 0
chat.ClipsDescendants = true
chat.Size = UDim2.new(0, 338, 0, 245)
chat.ZIndex = 10
table.insert(shade1,chat)

Clear.Name = "Clear"
Clear.Parent = chat
Clear.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
Clear.BorderSizePixel = 0
Clear.Position = UDim2.new(0, 5, 0, 220)
Clear.Size = UDim2.new(0, 50, 0, 20)
Clear.ZIndex = 10
Clear.Font = Enum.Font.SourceSans
Clear.FontSize = Enum.FontSize.Size14
Clear.Text = "Clear"
Clear.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade2,Clear)
table.insert(text1,Clear)

SaveChatlogs.Name = "SaveChatlogs"
SaveChatlogs.Parent = chat
SaveChatlogs.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
SaveChatlogs.BorderSizePixel = 0
SaveChatlogs.Position = UDim2.new(0, 258, 0, 220)
SaveChatlogs.Size = UDim2.new(0, 75, 0, 20)
SaveChatlogs.ZIndex = 10
SaveChatlogs.Font = Enum.Font.SourceSans
SaveChatlogs.FontSize = Enum.FontSize.Size14
SaveChatlogs.Text = "Save To .txt"
SaveChatlogs.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade2,SaveChatlogs)
table.insert(text1,SaveChatlogs)

Toggle.Name = "Toggle"
Toggle.Parent = chat
Toggle.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
Toggle.BorderSizePixel = 0
Toggle.Position = UDim2.new(0, 60, 0, 220)
Toggle.Size = UDim2.new(0, 66, 0, 20)
Toggle.ZIndex = 10
Toggle.Font = Enum.Font.SourceSans
Toggle.FontSize = Enum.FontSize.Size14
Toggle.Text = "Disabled"
Toggle.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade2,Toggle)
table.insert(text1,Toggle)

scroll_2.Name = "scroll"
scroll_2.Parent = chat
scroll_2.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
scroll_2.BorderSizePixel = 0
scroll_2.Position = UDim2.new(0, 5, 0, 25)
scroll_2.Size = UDim2.new(0, 328, 0, 190)
scroll_2.ZIndex = 10
scroll_2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
scroll_2.CanvasSize = UDim2.new(0, 0, 0, 10)
scroll_2.ScrollBarThickness = 8
scroll_2.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
table.insert(scroll,scroll_2)
table.insert(shade2,scroll_2)

join.Name = "join"
join.Parent = background
join.Active = true
join.BackgroundColor3 = Color3.new(0.141176, 0.141176, 0.145098)
join.BorderSizePixel = 0
join.ClipsDescendants = true
join.Size = UDim2.new(0, 338, 0, 245)
join.Visible = false
join.ZIndex = 10
table.insert(shade1,join)

Toggle_2.Name = "Toggle"
Toggle_2.Parent = join
Toggle_2.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
Toggle_2.BorderSizePixel = 0
Toggle_2.Position = UDim2.new(0, 60, 0, 220)
Toggle_2.Size = UDim2.new(0, 66, 0, 20)
Toggle_2.ZIndex = 10
Toggle_2.Font = Enum.Font.SourceSans
Toggle_2.FontSize = Enum.FontSize.Size14
Toggle_2.Text = "Disabled"
Toggle_2.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade2,Toggle_2)
table.insert(text1,Toggle_2)

Clear_2.Name = "Clear"
Clear_2.Parent = join
Clear_2.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
Clear_2.BorderSizePixel = 0
Clear_2.Position = UDim2.new(0, 5, 0, 220)
Clear_2.Size = UDim2.new(0, 50, 0, 20)
Clear_2.ZIndex = 10
Clear_2.Font = Enum.Font.SourceSans
Clear_2.FontSize = Enum.FontSize.Size14
Clear_2.Text = "Clear"
Clear_2.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade2,Clear_2)
table.insert(text1,Clear_2)

scroll_3.Name = "scroll"
scroll_3.Parent = join
scroll_3.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
scroll_3.BorderSizePixel = 0
scroll_3.Position = UDim2.new(0, 5, 0, 25)
scroll_3.Size = UDim2.new(0, 328, 0, 190)
scroll_3.ZIndex = 10
scroll_3.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
scroll_3.CanvasSize = UDim2.new(0, 0, 0, 10)
scroll_3.ScrollBarThickness = 8
scroll_3.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
table.insert(scroll,scroll_3)
table.insert(shade2,scroll_3)

selectChat.Name = "selectChat"
selectChat.Parent = background
selectChat.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.184314)
selectChat.BorderSizePixel = 0
selectChat.Position = UDim2.new(0, 5, 0, 5)
selectChat.Size = UDim2.new(0, 164, 0, 20)
selectChat.ZIndex = 10
selectChat.Font = Enum.Font.SourceSans
selectChat.FontSize = Enum.FontSize.Size14
selectChat.Text = "Chat Logs"
selectChat.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade2,selectChat)
table.insert(text1,selectChat)

selectJoin.Name = "selectJoin"
selectJoin.Parent = background
selectJoin.BackgroundColor3 = Color3.new(0.305882, 0.305882, 0.309804)
selectJoin.BorderSizePixel = 0
selectJoin.Position = UDim2.new(0, 169, 0, 5)
selectJoin.Size = UDim2.new(0, 164, 0, 20)
selectJoin.ZIndex = 10
selectJoin.Font = Enum.Font.SourceSans
selectJoin.FontSize = Enum.FontSize.Size14
selectJoin.Text = "Join Logs"
selectJoin.TextColor3 = Color3.new(1, 1, 1)
table.insert(shade3,selectJoin)
table.insert(text1,selectJoin)

function create(data)
	local insts = {}
	for i,v in pairs(data) do insts[v[1]] = Instance.new(v[2]) end

	for _,v in pairs(data) do
		for prop,val in pairs(v[3]) do
			if type(val) == "table" then
				insts[v[1]][prop] = insts[val[1]]
			else
				insts[v[1]][prop] = val
			end
		end
	end

	return insts[1]
end

ViewportTextBox = (function()

	local funcs = {}
	funcs.Update = function(self)
		local cursorPos = self.TextBox.CursorPosition
		local text = self.TextBox.Text
		if text == "" then self.TextBox.Position = UDim2.new(0,2,0,0) return end
		if cursorPos == -1 then return end

		local cursorText = text:sub(1,cursorPos-1)
		local pos = nil
		local leftEnd = -self.TextBox.Position.X.Offset
		local rightEnd = leftEnd + self.View.AbsoluteSize.X

		local totalTextSize = TextService:GetTextSize(text,self.TextBox.TextSize,self.TextBox.Font,Vector2.new(999999999,100)).X
		local cursorTextSize = TextService:GetTextSize(cursorText,self.TextBox.TextSize,self.TextBox.Font,Vector2.new(999999999,100)).X

		if cursorTextSize > rightEnd then
			pos = math.max(-2,cursorTextSize - self.View.AbsoluteSize.X + 2)
		elseif cursorTextSize < leftEnd then
			pos = math.max(-2,cursorTextSize-2)
		elseif totalTextSize < rightEnd then
			pos = math.max(-2,totalTextSize - self.View.AbsoluteSize.X + 2)
		end

		if pos then
			self.TextBox.Position = UDim2.new(0,-pos,0,0)
			self.TextBox.Size = UDim2.new(1,pos,1,0)
		end
	end

	local mt = {}
	mt.__index = funcs

	local function convert(textbox)
		local obj = setmetatable({OffsetX = 0, TextBox = textbox},mt)

		local view = Instance.new("Frame")
		view.BackgroundTransparency = textbox.BackgroundTransparency
		view.BackgroundColor3 = textbox.BackgroundColor3
		view.BorderSizePixel = textbox.BorderSizePixel
		view.BorderColor3 = textbox.BorderColor3
		view.Position = textbox.Position
		view.Size = textbox.Size
		view.ClipsDescendants = true
		view.Name = textbox.Name
		view.ZIndex = 10
		textbox.BackgroundTransparency = 1
		textbox.Position = UDim2.new(0,4,0,0)
		textbox.Size = UDim2.new(1,-8,1,0)
		textbox.TextXAlignment = Enum.TextXAlignment.Left
		textbox.Name = "Input"
		table.insert(text1,textbox)
		table.insert(shade2,view)

		obj.View = view

		textbox.Changed:Connect(function(prop)
			if prop == "Text" or prop == "CursorPosition" or prop == "AbsoluteSize" then
				obj:Update()
			end
		end)

		obj:Update()

		view.Parent = textbox.Parent
		textbox.Parent = view

		return obj
	end

	return {convert = convert}
end)()

ViewportTextBox.convert(Cmdbar).View.ZIndex = 10
ViewportTextBox.convert(Cmdbar_2).View.ZIndex = 10
ViewportTextBox.convert(Cmdbar_3).View.ZIndex = 10

function writefileExploit()
	if writefile then
		return true
	end
end

function readfileExploit()
	if readfile then
		return true
	end
end

function isNumber(str)
	if tonumber(str) ~= nil or str == 'inf' then
		return true
	end
end

function vtype(o, t)
    if o == nil then return false end
    if type(o) == "userdata" then return typeof(o) == t end
    return type(o) == t
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

function tools(plr)
	if plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass('Tool') or plr.Character:FindFirstChildOfClass('Tool') then
		return true
	end
end

function r15(plr)
	if plr.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
		return true
	end
end

function toClipboard(txt)
    if everyClipboard then
        everyClipboard(tostring(txt))
        notify("Clipboard", "Copied to clipboard")
    else
        notify("Clipboard", "Your exploit doesn't have the ability to use the clipboard")
    end
end

function chatMessage(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

function getHierarchy(obj)
	local fullname
	local period

	if string.find(obj.Name,' ') then
		fullname = '["'..obj.Name..'"]'
		period = false
	else
		fullname = obj.Name
		period = true
	end

	local getS = obj
	local parent = obj
	local service = ''

	if getS.Parent ~= game then
		repeat
			getS = getS.Parent
			service = getS.ClassName
		until getS.Parent == game
	end

	if parent.Parent ~= getS then
		repeat
			parent = parent.Parent
			if string.find(tostring(parent),' ') then
				if period then
					fullname = '["'..parent.Name..'"].'..fullname
				else
					fullname = '["'..parent.Name..'"]'..fullname
				end
				period = false
			else
				if period then
					fullname = parent.Name..'.'..fullname
				else
					fullname = parent.Name..''..fullname
				end
				period = true
			end
		until parent.Parent == getS
	elseif string.find(tostring(parent),' ') then
		fullname = '["'..parent.Name..'"]'
		period = false
	end

	if period then
		return 'game:GetService("'..service..'").'..fullname
	else
		return 'game:GetService("'..service..'")'..fullname
	end
end

AllWaypoints = {}

local cooldown = false
function writefileCooldown(name,data)
	task.spawn(function()
		if not cooldown then
			cooldown = true
			writefile(name, data, true)
		else
			repeat wait() until cooldown == false
			writefileCooldown(name,data)
		end
		wait(3)
		cooldown = false
	end)
end

function dragGUI(gui)
	task.spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

dragGUI(logs)
dragGUI(KeybindEditor)
dragGUI(PluginEditor)
dragGUI(ToPartFrame)

eventEditor = (function()
	local events = {}

	local function registerEvent(name,sets)
		events[name] = {
			commands = {},
			sets = sets or {}
		}
	end

	local onEdited = nil

	local function fireEvent(name,...)
		local args = {...}
		local event = events[name]
		if event then
			for i,cmd in pairs(event.commands) do
				local metCondition = true
				for idx,set in pairs(event.sets) do
					local argVal = args[idx]
					local cmdSet = cmd[2][idx]
					local condType = set.Type
					if condType == "Player" then
						if cmdSet == 0 then
							metCondition = metCondition and (tostring(Players.LocalPlayer) == argVal)
						elseif cmdSet ~= 1 then
							metCondition = metCondition and table.find(getPlayer(cmdSet,Players.LocalPlayer),argVal)
						end
					elseif condType == "String" then
						if cmdSet ~= 0 then
							metCondition = metCondition and string.find(argVal:lower(),cmdSet:lower())
						end
					elseif condType == "Number" then
						if cmdSet ~= 0 then
							metCondition = metCondition and tonumber(argVal)<=tonumber(cmdSet)
						end
					end
					if not metCondition then break end
				end

				if metCondition then
					pcall(task.spawn(function()
						local cmdStr = cmd[1]
						for count,arg in pairs(args) do
							cmdStr = cmdStr:gsub("%$"..count,arg)
						end
						wait(cmd[3] or 0)
						execCmd(cmdStr)
					end))
				end
			end
		end
	end

	local main = create({
		{1,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BackgroundTransparency=1,BorderSizePixel=0,Name="EventEditor",Position=UDim2.new(0.5,-175,0,-500),Size=UDim2.new(0,350,0,20),ZIndex=10,}},
		{2,"Frame",{BackgroundColor3=currentShade2,BorderSizePixel=0,Name="TopBar",Parent={1},Size=UDim2.new(1,0,0,20),ZIndex=10,}},
		{3,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={2},Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0.95,0),Text="Event Editor",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=10,}},
		{4,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Close",Parent={2},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{5,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image=getcustomasset("infiniteyield/assets/close.png"),Parent={4},Position=UDim2.new(0,5,0,5),Size=UDim2.new(0,10,0,10),ZIndex=10,}},
		{6,"Frame",{BackgroundColor3=currentShade1,BorderSizePixel=0,Name="Content",Parent={1},Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,0,202),ZIndex=10,}},
		{7,"ScrollingFrame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png",CanvasSize=UDim2.new(0,0,0,100),Name="List",Parent={6},Position=UDim2.new(0,5,0,5),ScrollBarImageColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),ScrollBarThickness=8,Size=UDim2.new(1,-10,1,-10),TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png",ZIndex=10,}},
		{8,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Holder",Parent={7},Size=UDim2.new(1,0,1,0),ZIndex=10,}},
		{9,"UIListLayout",{Parent={8},SortOrder=2,}},
		{10,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BackgroundTransparency=1,BorderColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BorderSizePixel=0,ClipsDescendants=true,Name="Settings",Parent={6},Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,150,1,0),ZIndex=10,}},
		{11,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),Name="Slider",Parent={10},Position=UDim2.new(0,-150,0,0),Size=UDim2.new(1,0,1,0),ZIndex=10,}},
		{12,"Frame",{BackgroundColor3=Color3.new(0.23529413342476,0.23529413342476,0.23529413342476),BorderColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BorderSizePixel=0,Name="Line",Parent={11},Size=UDim2.new(0,1,1,0),ZIndex=10,}},
		{13,"ScrollingFrame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png",CanvasSize=UDim2.new(0,0,0,100),Name="List",Parent={11},Position=UDim2.new(0,0,0,25),ScrollBarImageColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),ScrollBarThickness=8,Size=UDim2.new(1,0,1,-25),TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png",ZIndex=10,}},
		{14,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Holder",Parent={13},Size=UDim2.new(1,0,1,0),ZIndex=10,}},
		{15,"UIListLayout",{Parent={14},SortOrder=2,}},
		{16,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={11},Size=UDim2.new(1,0,0,20),Text="Event Settings",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{17,"TextButton",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),Font=3,Name="Close",BorderSizePixel=0,Parent={11},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),Text="<",TextColor3=Color3.new(1,1,1),TextSize=18,ZIndex=10,}},
		{18,"Folder",{Name="Templates",Parent={10},}},
		{19,"Frame",{BackgroundColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),Name="Players",Parent={18},Position=UDim2.new(0,0,0,25),Size=UDim2.new(1,0,0,86),Visible=false,ZIndex=10,}},
		{20,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={19},Size=UDim2.new(1,0,0,20),Text="Choose Players",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{21,"TextLabel",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Any",Parent={19},Position=UDim2.new(0,5,0,42),Size=UDim2.new(1,-10,0,20),Text="Any Player",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{22,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="Button",Parent={21},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{23,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={22},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{24,"TextLabel",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Me",Parent={19},Position=UDim2.new(0,5,0,20),Size=UDim2.new(1,-10,0,20),Text="Me Only",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{25,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="Button",Parent={24},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{26,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={25},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{27,"TextBox",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,ClearTextOnFocus=false,Font=3,Name="Custom",Parent={19},PlaceholderColor3=Color3.new(0.47058826684952,0.47058826684952,0.47058826684952),PlaceholderText="Custom Player Set",Position=UDim2.new(0,5,0,64),Size=UDim2.new(1,-35,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{28,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="CustomButton",Parent={19},Position=UDim2.new(1,-25,0,64),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{29,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={28},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{30,"Frame",{BackgroundColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),Name="Strings",Parent={18},Position=UDim2.new(0,0,0,25),Size=UDim2.new(1,0,0,64),Visible=false,ZIndex=10,}},
		{31,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={30},Size=UDim2.new(1,0,0,20),Text="Choose String",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{32,"TextLabel",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Any",Parent={30},Position=UDim2.new(0,5,0,20),Size=UDim2.new(1,-10,0,20),Text="Any String",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{33,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="Button",Parent={32},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{34,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={33},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{54,"Frame",{BackgroundColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),Name="Numbers",Parent={18},Position=UDim2.new(0,0,0,25),Size=UDim2.new(1,0,0,64),Visible=false,ZIndex=10,}},
		{55,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={54},Size=UDim2.new(1,0,0,20),Text="Choose String",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{56,"TextLabel",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Any",Parent={54},Position=UDim2.new(0,5,0,20),Size=UDim2.new(1,-10,0,20),Text="Any Number",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{57,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="Button",Parent={56},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{58,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={57},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{59,"TextBox",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,ClearTextOnFocus=false,Font=3,Name="Custom",Parent={54},PlaceholderColor3=Color3.new(0.47058826684952,0.47058826684952,0.47058826684952),PlaceholderText="Number",Position=UDim2.new(0,5,0,42),Size=UDim2.new(1,-35,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{60,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="CustomButton",Parent={54},Position=UDim2.new(1,-25,0,42),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{61,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={60},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{35,"TextBox",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,ClearTextOnFocus=false,Font=3,Name="Custom",Parent={30},PlaceholderColor3=Color3.new(0.47058826684952,0.47058826684952,0.47058826684952),PlaceholderText="Match String",Position=UDim2.new(0,5,0,42),Size=UDim2.new(1,-35,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{36,"Frame",{BackgroundColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),BorderSizePixel=0,Name="CustomButton",Parent={30},Position=UDim2.new(1,-25,0,42),Size=UDim2.new(0,20,0,20),ZIndex=10,}},
		{37,"TextButton",{BackgroundColor3=Color3.new(0.58823531866074,0.58823531866074,0.59215688705444),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="On",Parent={36},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,ZIndex=10,}},
		{38,"Frame",{BackgroundColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),Name="DelayEditor",Parent={18},Position=UDim2.new(0,0,0,25),Size=UDim2.new(1,0,0,24),Visible=false,ZIndex=10,}},
		{39,"TextBox",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Font=3,Name="Secs",Parent={38},PlaceholderColor3=Color3.new(0.47058826684952,0.47058826684952,0.47058826684952),Position=UDim2.new(0,60,0,2),Size=UDim2.new(1,-65,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{40,"TextLabel",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Label",Parent={39},Position=UDim2.new(0,-55,0,0),Size=UDim2.new(1,0,1,0),Text="Delay (s):",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{41,"Frame",{BackgroundColor3=currentShade1,BorderSizePixel=0,ClipsDescendants=true,Name="EventTemplate",Parent={6},Size=UDim2.new(1,0,0,20),Visible=false,ZIndex=10,}},
		{42,"TextButton",{BackgroundColor3=currentText1,BackgroundTransparency=1,Font=3,Name="Expand",Parent={41},Size=UDim2.new(0,20,0,20),Text=">",TextColor3=Color3.new(1,1,1),TextSize=18,ZIndex=10,}},
		{43,"TextLabel",{BackgroundColor3=currentText1,BackgroundTransparency=1,Font=3,Name="EventName",Parent={41},Position=UDim2.new(0,25,0,0),Size=UDim2.new(1,-25,0,20),Text="OnSpawn",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{44,"Frame",{BackgroundColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BorderSizePixel=0,BackgroundTransparency=1,ClipsDescendants=true,Name="Cmds",Parent={41},Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,1,-20),ZIndex=10,}},
		{45,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BorderColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),Name="Add",Parent={44},Position=UDim2.new(0,0,1,-20),Size=UDim2.new(1,0,0,20),ZIndex=10,}},
		{46,"TextBox",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClearTextOnFocus=false,Font=3,Parent={45},PlaceholderColor3=Color3.new(0.7843137383461,0.7843137383461,0.7843137383461),PlaceholderText="Add new command",Position=UDim2.new(0,5,0,0),Size=UDim2.new(1,-10,1,0),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{47,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Holder",Parent={44},Size=UDim2.new(1,0,1,-20),ZIndex=10,}},
		{48,"UIListLayout",{Parent={47},SortOrder=2,}},
		{49,"Frame",{currentShade1,BorderSizePixel=0,ClipsDescendants=true,Name="CmdTemplate",Parent={6},Size=UDim2.new(1,0,0,20),Visible=false,ZIndex=10,}},
		{50,"TextBox",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClearTextOnFocus=false,Font=3,Parent={49},PlaceholderColor3=Color3.new(1,1,1),Position=UDim2.new(0,5,0,0),Size=UDim2.new(1,-45,0,20),Text="a\\b\\c\\d",TextColor3=currentText1,TextSize=14,TextXAlignment=0,ZIndex=10,}},
		{51,"TextButton",{BackgroundColor3=currentShade1,BorderSizePixel=0,Font=3,Name="Delete",Parent={49},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),Text="X",TextColor3=Color3.new(1,1,1),TextSize=18,ZIndex=10,}},
		{52,"TextButton",{BackgroundColor3=currentShade1,BorderSizePixel=0,Font=3,Name="Settings",Parent={49},Position=UDim2.new(1,-40,0,0),Size=UDim2.new(0,20,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=18,ZIndex=10,}},
		{53,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image=getcustomasset("infiniteyield/assets/settings.png"),Parent={52},Position=UDim2.new(0,2,0,2),Size=UDim2.new(0,16,0,16),ZIndex=10,}},
	})
	main.Name = randomString()
	local mainFrame = main:WaitForChild("Content")
	local eventList = mainFrame:WaitForChild("List")
	local eventListHolder = eventList:WaitForChild("Holder")
	local cmdTemplate = mainFrame:WaitForChild("CmdTemplate")
	local eventTemplate = mainFrame:WaitForChild("EventTemplate")
	local settingsFrame = mainFrame:WaitForChild("Settings"):WaitForChild("Slider")
	local settingsTemplates = mainFrame.Settings:WaitForChild("Templates")
	local settingsList = settingsFrame:WaitForChild("List"):WaitForChild("Holder")
	table.insert(shade2,main.TopBar) table.insert(shade1,mainFrame) table.insert(shade2,eventTemplate)
	table.insert(text1,eventTemplate.EventName) table.insert(shade1,eventTemplate.Cmds.Add) table.insert(shade1,cmdTemplate)
	table.insert(text1,cmdTemplate.TextBox) table.insert(shade2,cmdTemplate.Delete) table.insert(shade2,cmdTemplate.Settings)
	table.insert(scroll,mainFrame.List) table.insert(shade1,settingsFrame) table.insert(shade2,settingsFrame.Line)
	table.insert(shade2,settingsFrame.Close) table.insert(scroll,settingsFrame.List) table.insert(shade2,settingsTemplates.DelayEditor.Secs)
	table.insert(text1,settingsTemplates.DelayEditor.Secs) table.insert(text1,settingsTemplates.DelayEditor.Secs.Label) table.insert(text1,settingsTemplates.Players.Title)
	table.insert(shade3,settingsTemplates.Players.CustomButton) table.insert(shade2,settingsTemplates.Players.Custom) table.insert(text1,settingsTemplates.Players.Custom)
	table.insert(shade3,settingsTemplates.Players.Any.Button) table.insert(shade3,settingsTemplates.Players.Me.Button) table.insert(text1,settingsTemplates.Players.Any)
	table.insert(text1,settingsTemplates.Players.Me) table.insert(text1,settingsTemplates.Strings.Title) table.insert(text1,settingsTemplates.Strings.Any)
	table.insert(shade3,settingsTemplates.Strings.Any.Button) table.insert(shade3,settingsTemplates.Strings.CustomButton) table.insert(text1,settingsTemplates.Strings.Custom)
	table.insert(shade2,settingsTemplates.Strings.Custom)
	table.insert(text1,settingsTemplates.Players.Me) table.insert(text1,settingsTemplates.Numbers.Title) table.insert(text1,settingsTemplates.Numbers.Any)
	table.insert(shade3,settingsTemplates.Numbers.Any.Button) table.insert(shade3,settingsTemplates.Numbers.CustomButton) table.insert(text1,settingsTemplates.Numbers.Custom)
	table.insert(shade2,settingsTemplates.Numbers.Custom)

	local tweenInf = TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)

	local currentlyEditingCmd = nil

	settingsFrame:WaitForChild("Close").MouseButton1Click:Connect(function()
		settingsFrame:TweenPosition(UDim2.new(0,-150,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
	end)

	local function resizeList()
		local size = 0

		for i,v in pairs(eventListHolder:GetChildren()) do
			if v.Name == "EventTemplate" then
				size = size + 20
				if v.Expand.Rotation == 90 then
					size = size + 20*(1+(#events[v.EventName:GetAttribute("RawName")].commands or 0))
				end
			end
		end

		TweenService:Create(eventList,tweenInf,{CanvasSize = UDim2.new(0,0,0,size)}):Play()

		if size > eventList.AbsoluteSize.Y then
			eventListHolder.Size = UDim2.new(1,-8,1,0)
		else
			eventListHolder.Size = UDim2.new(1,0,1,0)
		end
	end

	local function resizeSettingsList()
		local size = 0

		for i,v in pairs(settingsList:GetChildren()) do
			if v:IsA("Frame") then
				size = size + v.AbsoluteSize.Y
			end
		end

		settingsList.Parent.CanvasSize = UDim2.new(0,0,0,size)

		if size > settingsList.Parent.AbsoluteSize.Y then
			settingsList.Size = UDim2.new(1,-8,1,0)
		else
			settingsList.Size = UDim2.new(1,0,1,0)
		end
	end

	local function setupCheckbox(button,callback)
		local enabled = button.On.BackgroundTransparency == 0

		local function update()
			button.On.BackgroundTransparency = (enabled and 0 or 1)
		end

		button.On.MouseButton1Click:Connect(function()
			enabled = not enabled
			update()
			if callback then callback(enabled) end
		end)

		return {
			Toggle = function(nocall) enabled = not enabled update() if not nocall and callback then callback(enabled) end end,
			Enable = function(nocall) if enabled then return end enabled = true update()if not nocall and callback then callback(enabled) end end,
			Disable = function(nocall) if not enabled then return end enabled = false update()if not nocall and callback then callback(enabled) end end,
			IsEnabled = function() return enabled end
		}
	end

	local function openSettingsEditor(event,cmd)
		currentlyEditingCmd = cmd

		for i,v in pairs(settingsList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end

		local delayEditor = settingsTemplates.DelayEditor:Clone()
		delayEditor.Secs.FocusLost:Connect(function()
			cmd[3] = tonumber(delayEditor.Secs.Text) or 0
			delayEditor.Secs.Text = cmd[3]
			if onEdited then onEdited() end
		end)
		delayEditor.Secs.Text = cmd[3]
		delayEditor.Visible = true
		table.insert(shade2,delayEditor.Secs)
		table.insert(text1,delayEditor.Secs)
		table.insert(text1,delayEditor.Secs.Label)
		delayEditor.Parent = settingsList

		for i,v in pairs(event.sets) do
			if v.Type == "Player" then
				local template = settingsTemplates.Players:Clone()
				template.Title.Text = v.Name or "Player"

				local me,any,custom

				me = setupCheckbox(template.Me.Button,function(on)
					if not on then return end
					any.Disable()
					custom.Disable()
					cmd[2][i] = 0
					if onEdited then onEdited() end
				end)

				any = setupCheckbox(template.Any.Button,function(on)
					if not on then return end
					me.Disable()
					custom.Disable()
					cmd[2][i] = 1
					if onEdited then onEdited() end
				end)

				local customTextBox = template.Custom
				custom = setupCheckbox(template.CustomButton,function(on)
					if not on then return end
					me.Disable()
					any.Disable()
					cmd[2][i] = customTextBox.Text
					if onEdited then onEdited() end
				end)

				ViewportTextBox.convert(customTextBox)
				customTextBox.FocusLost:Connect(function()
					if custom:IsEnabled() then
						cmd[2][i] = customTextBox.Text
						if onEdited then onEdited() end
					end
				end)

				local cVal = cmd[2][i]
				if cVal == 0 then
					me:Enable()
				elseif cVal == 1 then
					any:Enable()
				else
					custom:Enable()
					customTextBox.Text = cVal
				end

				template.Visible = true
				table.insert(text1,template.Title)
				table.insert(shade3,template.CustomButton)
				table.insert(shade3,template.Any.Button)
				table.insert(shade3,template.Me.Button)
				table.insert(text1,template.Any)
				table.insert(text1,template.Me)
				template.Parent = settingsList
			elseif v.Type == "String" then
				local template = settingsTemplates.Strings:Clone()
				template.Title.Text = v.Name or "String"

				local any,custom

				any = setupCheckbox(template.Any.Button,function(on)
					if not on then return end
					custom.Disable()
					cmd[2][i] = 0
					if onEdited then onEdited() end
				end)

				local customTextBox = template.Custom
				custom = setupCheckbox(template.CustomButton,function(on)
					if not on then return end
					any.Disable()
					cmd[2][i] = customTextBox.Text
					if onEdited then onEdited() end
				end)

				ViewportTextBox.convert(customTextBox)
				customTextBox.FocusLost:Connect(function()
					if custom:IsEnabled() then
						cmd[2][i] = customTextBox.Text
						if onEdited then onEdited() end
					end
				end)

				local cVal = cmd[2][i]
				if cVal == 0 then
					any:Enable()
				else
					custom:Enable()
					customTextBox.Text = cVal
				end

				template.Visible = true
				table.insert(text1,template.Title)
				table.insert(text1,template.Any)
				table.insert(shade3,template.Any.Button)
				table.insert(shade3,template.CustomButton)
				template.Parent = settingsList
			elseif v.Type == "Number" then
				local template = settingsTemplates.Numbers:Clone()
				template.Title.Text = v.Name or "Number"

				local any,custom

				any = setupCheckbox(template.Any.Button,function(on)
					if not on then return end
					custom.Disable()
					cmd[2][i] = 0
					if onEdited then onEdited() end
				end)

				local customTextBox = template.Custom
				custom = setupCheckbox(template.CustomButton,function(on)
					if not on then return end
					any.Disable()
					cmd[2][i] = customTextBox.Text
					if onEdited then onEdited() end
				end)

				ViewportTextBox.convert(customTextBox)
				customTextBox.FocusLost:Connect(function()
					cmd[2][i] = tonumber(customTextBox.Text) or 0
					customTextBox.Text = cmd[2][i]
					if custom:IsEnabled() then
						if onEdited then onEdited() end
					end
				end)

				local cVal = cmd[2][i]
				if cVal == 0 then
					any:Enable()
				else
					custom:Enable()
					customTextBox.Text = cVal
				end

				template.Visible = true
				table.insert(text1,template.Title)
				table.insert(text1,template.Any)
				table.insert(shade3,template.Any.Button)
				table.insert(shade3,template.CustomButton)
				template.Parent = settingsList
			end
		end
		resizeSettingsList()
		settingsFrame:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
	end

	local function defaultSettings(ev)
		local res = {}

		for i,v in pairs(ev.sets) do
			if v.Type == "Player" then
				res[#res+1] = v.Default or 0
			elseif v.Type == "String" then
				res[#res+1] = v.Default or 0
			elseif v.Type == "Number" then
				res[#res+1] = v.Default or 0
			end
		end

		return res
	end

	local function refreshList()
		for i,v in pairs(eventListHolder:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end

		for name,event in pairs(events) do
			local eventF = eventTemplate:Clone()
			eventF.EventName.Text = name
			eventF.Visible = true
			eventF.EventName:SetAttribute("RawName", name)
			table.insert(shade2,eventF)
			table.insert(text1,eventF.EventName)
			table.insert(shade1,eventF.Cmds.Add)

			local expanded = false
			eventF.Expand.MouseButton1Down:Connect(function()
				expanded = not expanded
				eventF:TweenSize(UDim2.new(1,0,0,20 + (expanded and 20*#eventF.Cmds.Holder:GetChildren() or 0)),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
				eventF.Expand.Rotation = expanded and 90 or 0
				resizeList()
			end)

			local function refreshCommands()
				for i,v in pairs(eventF.Cmds.Holder:GetChildren()) do
					if v.Name == "CmdTemplate" then
						v:Destroy()
					end
				end

				eventF.EventName.Text = name..(#event.commands > 0 and " ("..#event.commands..")" or "")

				for i,cmd in pairs(event.commands) do
					local cmdF = cmdTemplate:Clone()
					local cmdTextBox = cmdF.TextBox
					ViewportTextBox.convert(cmdTextBox)
					cmdTextBox.Text = cmd[1]
					cmdF.Visible = true
					table.insert(shade1,cmdF)
					table.insert(shade2,cmdF.Delete)
					table.insert(shade2,cmdF.Settings)

					cmdTextBox.FocusLost:Connect(function()
						event.commands[i] = {cmdTextBox.Text,cmd[2],cmd[3]}
						if onEdited then onEdited() end
					end)

					cmdF.Settings.MouseButton1Click:Connect(function()
						openSettingsEditor(event,cmd)
					end)

					cmdF.Delete.MouseButton1Click:Connect(function()
						table.remove(event.commands,i)
						refreshCommands()
						resizeList()

						if currentlyEditingCmd == cmd then
							settingsFrame:TweenPosition(UDim2.new(0,-150,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
						end
						if onEdited then onEdited() end
					end)

					cmdF.Parent = eventF.Cmds.Holder
				end

				eventF:TweenSize(UDim2.new(1,0,0,20 + (expanded and 20*#eventF.Cmds.Holder:GetChildren() or 0)),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
			end

			local newBox = eventF.Cmds.Add.TextBox
			ViewportTextBox.convert(newBox)
			newBox.FocusLost:Connect(function(enter)
				if enter then
					event.commands[#event.commands+1] = {newBox.Text,defaultSettings(event),0}
					newBox.Text = ""

					refreshCommands()
					resizeList()
					if onEdited then onEdited() end
				end
			end)

			--eventF:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeList)

			eventF.Parent = eventListHolder

			refreshCommands()
		end

		resizeList()
	end

	local function saveData()
		local result = {}
		for i,v in pairs(events) do
			result[i] = v.commands
		end
		return HttpService:JSONEncode(result)
	end

	local function loadData(str)
		local data = HttpService:JSONDecode(str)
		for i,v in pairs(data) do
			if events[i] then
				events[i].commands = v
			end
		end
	end

	local function addCmd(event,data)
		table.insert(events[event].commands,data)
	end

	local function setOnEdited(f)
		if type(f) == "function" then
			onEdited = f
		end
	end

	main.TopBar.Close.MouseButton1Click:Connect(function()
		main:TweenPosition(UDim2.new(0.5,-175,0,-500), "InOut", "Quart", 0.5, true, nil)
	end)
	dragGUI(main)
	main.Parent = ScaledHolder

	return {
		RegisterEvent = registerEvent,
		FireEvent = fireEvent,
		Refresh = refreshList,
		SaveData = saveData,
		LoadData = loadData,
		AddCmd = addCmd,
		Frame = main,
		SetOnEdited = setOnEdited
	}
end)()

reference = (function()
	local main = create({
		{1,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Name="Main",Position=UDim2.new(0.5,-250,0,-500),Size=UDim2.new(0,500,0,20),ZIndex=10,}},
		{2,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="TopBar",Parent={1},Size=UDim2.new(1,0,0,20),ZIndex=10,}},
		{3,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={2},Size=UDim2.new(1,0,0.94999998807907,0),Text="Reference",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{4,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Close",Parent={2},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,20),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=10,}},
		{5,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image=getcustomasset("infiniteyield/assets/close.png"),Parent={4},Position=UDim2.new(0,5,0,5),Size=UDim2.new(0,10,0,10),ZIndex=10,}},
		{6,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BorderSizePixel=0,Name="Content",Parent={1},Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,0,300),ZIndex=10,}},
		{7,"ScrollingFrame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14509804546833),BackgroundTransparency=1,BorderColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png",CanvasSize=UDim2.new(0,0,0,1313),Name="List",Parent={6},ScrollBarImageColor3=Color3.new(0.30588236451149,0.30588236451149,0.3098039329052),ScrollBarThickness=8,Size=UDim2.new(1,0,1,0),TopImage="rbxasset://textures/ui/Scroll/scroll-middle.png",VerticalScrollBarInset=2,ZIndex=10,}},
		{8,"UIListLayout",{Parent={7},SortOrder=2,}},
		{9,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,429),ZIndex=10,}},
		{10,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={9},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Special Player Cases",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{11,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={9},Position=UDim2.new(0,8,0,25),Size=UDim2.new(1,-8,0,20),Text="These keywords can be used to quickly select groups of players in commands:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{12,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={9},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{13,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Cases",Parent={9},Position=UDim2.new(0,8,0,55),Size=UDim2.new(1,-16,0,342),ZIndex=10,}},
		{14,"UIListLayout",{Parent={13},SortOrder=2,}},
		{15,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=-4,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{16,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={15},Size=UDim2.new(1,0,1,0),Text="all",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{17,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={15},Position=UDim2.new(0,15,0,0),Size=UDim2.new(1,0,1,0),Text="- includes everyone",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{18,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=-3,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{19,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={18},Size=UDim2.new(1,0,1,0),Text="others",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{20,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={18},Position=UDim2.new(0,37,0,0),Size=UDim2.new(1,0,1,0),Text="- includes everyone except you",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{21,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=-2,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{22,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={21},Size=UDim2.new(1,0,1,0),Text="me",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{23,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={21},Position=UDim2.new(0,19,0,0),Size=UDim2.new(1,0,1,0),Text="- includes your player only",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{24,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{25,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={24},Size=UDim2.new(1,0,1,0),Text="#[number]",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{26,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={24},Position=UDim2.new(0,59,0,0),Size=UDim2.new(1,0,1,0),Text="- gets a specified amount of random players",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{27,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{28,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={27},Size=UDim2.new(1,0,1,0),Text="random",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{29,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={27},Position=UDim2.new(0,44,0,0),Size=UDim2.new(1,0,1,0),Text="- affects a random player",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{30,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{31,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={30},Size=UDim2.new(1,0,1,0),Text="%[team name]",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{32,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={30},Position=UDim2.new(0,78,0,0),Size=UDim2.new(1,0,1,0),Text="- includes everyone on a given team",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{33,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{34,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={33},Size=UDim2.new(1,0,1,0),Text="allies / team",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{35,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={33},Position=UDim2.new(0,63,0,0),Size=UDim2.new(1,0,1,0),Text="- players who are on your team",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{36,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{37,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={36},Size=UDim2.new(1,0,1,0),Text="enemies / nonteam",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{38,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={36},Position=UDim2.new(0,101,0,0),Size=UDim2.new(1,0,1,0),Text="- players who are not on your team",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{39,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{40,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={39},Size=UDim2.new(1,0,1,0),Text="friends",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{41,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={39},Position=UDim2.new(0,40,0,0),Size=UDim2.new(1,0,1,0),Text="- anyone who is friends with you",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{42,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{43,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={42},Size=UDim2.new(1,0,1,0),Text="nonfriends",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{44,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={42},Position=UDim2.new(0,61,0,0),Size=UDim2.new(1,0,1,0),Text="- anyone who is not friends with you",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{45,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{46,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={45},Size=UDim2.new(1,0,1,0),Text="guests",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{47,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={45},Position=UDim2.new(0,36,0,0),Size=UDim2.new(1,0,1,0),Text="- guest players (obsolete)",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{48,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{49,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={48},Size=UDim2.new(1,0,1,0),Text="bacons",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{50,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={48},Position=UDim2.new(0,40,0,0),Size=UDim2.new(1,0,1,0),Text="- anyone with the \"bacon\" or pal hair",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{51,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{52,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={51},Size=UDim2.new(1,0,1,0),Text="age[number]",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{53,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={51},Position=UDim2.new(0,71,0,0),Size=UDim2.new(1,0,1,0),Text="- includes anyone below or at the given age",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{54,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{55,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={54},Size=UDim2.new(1,0,1,0),Text="rad[number]",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{56,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={54},Position=UDim2.new(0,70,0,0),Size=UDim2.new(1,0,1,0),Text="- includes anyone within the given radius",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{57,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{58,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={57},Size=UDim2.new(1,0,1,0),Text="nearest",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{59,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={57},Position=UDim2.new(0,43,0,0),Size=UDim2.new(1,0,1,0),Text="- gets the closest player to you",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{60,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{61,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={60},Size=UDim2.new(1,0,1,0),Text="farthest",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{62,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={60},Position=UDim2.new(0,46,0,0),Size=UDim2.new(1,0,1,0),Text="- gets the farthest player from you",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{63,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{64,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={63},Size=UDim2.new(1,0,1,0),Text="group[ID]",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{65,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={63},Position=UDim2.new(0,55,0,0),Size=UDim2.new(1,0,1,0),Text="- gets players who are in a certain group",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{66,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{67,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={66},Size=UDim2.new(1,0,1,0),Text="alive",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{68,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={66},Position=UDim2.new(0,27,0,0),Size=UDim2.new(1,0,1,0),Text="- gets players who are alive",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{69,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{70,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={69},Size=UDim2.new(1,0,1,0),Text="dead",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{71,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={69},Position=UDim2.new(0,29,0,0),Size=UDim2.new(1,0,1,0),Text="- gets players who are dead",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{72,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=-1,Name="Case",Parent={13},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,0,0,18),ZIndex=10,}},
		{73,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="CaseName",Parent={72},Size=UDim2.new(1,0,1,0),Text="@username",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{74,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="CaseDesc",Parent={72},Position=UDim2.new(0,66,0,0),Size=UDim2.new(1,0,1,0),Text="- searches for players by username only (ignores displaynames)",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{75,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,180),ZIndex=10,}},
		{76,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={75},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Various Operators",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{77,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={75},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{78,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={75},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,16),Text="Use commas to separate multiple expressions:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{79,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={75},Position=UDim2.new(0,8,0,75),Size=UDim2.new(1,-8,0,16),Text="Use - to exclude, and + to include players in your expression:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{80,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={75},Position=UDim2.new(0,8,0,91),Size=UDim2.new(1,-8,0,16),Text=";locate %blue-friends (gets players in blue team who aren't your friends)",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{81,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={75},Position=UDim2.new(0,8,0,46),Size=UDim2.new(1,-8,0,16),Text=";locate noob,noob2,bob",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{82,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={75},Position=UDim2.new(0,8,0,120),Size=UDim2.new(1,-8,0,16),Text="Put ! before a command to run it with the last arguments it was ran with:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{83,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={75},Position=UDim2.new(0,8,0,136),Size=UDim2.new(1,-8,0,32),Text="After running ;offset 0 100 0,  you can run !offset anytime to repeat that command with the same arguments that were used to run it last time",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{84,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,154),ZIndex=10,}},
		{85,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={84},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Command Looping",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{86,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={84},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,20),Text="Form: [How many times it loops]^[delay (optional)]^[command]",TextColor3=Color3.new(1,1,1),TextSize=15,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{87,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={84},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{88,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={84},Position=UDim2.new(0,8,0,50),Size=UDim2.new(1,-8,0,20),Text="Use the 'breakloops' command to stop all running loops.",TextColor3=Color3.new(1,1,1),TextSize=15,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{89,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={84},Position=UDim2.new(0,8,0,80),Size=UDim2.new(1,-8,0,16),Text="Examples:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{90,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={84},Position=UDim2.new(0,8,0,98),Size=UDim2.new(1,-8,0,42),Text=";5^btools - gives you 5 sets of btools\n;10^3^drophats - drops your hats every 3 seconds 10 times\n;inf^0.1^animspeed 100 - infinitely loops your animation speed to 100",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{91,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,120),ZIndex=10,}},
		{92,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={91},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Execute Multiple Commands at Once",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{93,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={91},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,20),Text="You can execute multiple commands at once using \"\\\"",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{94,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={91},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{95,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={91},Position=UDim2.new(0,8,0,60),Size=UDim2.new(1,-8,0,16),Text="Examples:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{96,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={91},Position=UDim2.new(0,8,0,78),Size=UDim2.new(1,-8,0,32),Text=";drophats\\respawn - drops your hats and respawns you\n;enable inventory\\enable playerlist\\refresh - enables those coregui items and refreshes you",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{97,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,75),ZIndex=10,}},
		{98,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={97},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Browse Command History",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{99,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={97},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,32),Text="While focused on the command bar, you can use the up and down arrow keys to browse recently used commands",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{100,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={97},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{101,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,75),ZIndex=10,}},
		{102,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={101},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Autocomplete in the Command Bar",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{103,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={101},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,32),Text="While focused on the command bar, you can use the tab key to insert the top suggested command into the command bar.",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{104,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={101},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{105,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,175),ZIndex=10,}},
		{106,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={105},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Using Event Binds",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{107,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={105},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,32),Text="Use event binds to set up commands that get executed when certain events happen. You can edit the conditions for an event command to run (such as which player triggers it).",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{108,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={105},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),ZIndex=10,}},
		{109,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={105},Position=UDim2.new(0,8,0,70),Size=UDim2.new(1,-8,0,48),Text="Some events may send arguments; you can use them in your event command by using $ followed by the argument number ($1, $2, etc). You can find out the order and types of these arguments by looking at the settings of the event command.",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{110,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Text",Parent={105},Position=UDim2.new(0,8,0,130),Size=UDim2.new(1,-8,0,16),Text="Example:",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{111,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={105},Position=UDim2.new(0,8,0,148),Size=UDim2.new(1,-8,0,16),Text="Setting up 'goto $1' on the OnChatted event will teleport you to any player that chats.",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,TextYAlignment=0,ZIndex=10,}},
		{112,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Section",Parent={7},Size=UDim2.new(1,0,0,105),ZIndex=10,}},
		{113,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Header",Parent={112},Position=UDim2.new(0,8,0,5),Size=UDim2.new(1,-8,0,20),Text="Get Further Help",TextColor3=Color3.new(1,1,1),TextSize=20,TextXAlignment=0,ZIndex=10,}},
		{114,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Text",Parent={112},Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-8,0,32),Text="You can join the Discord server to get support with IY,  and read up on more documentation such as the Plugin API.",TextColor3=Color3.new(1,1,1),TextSize=14,TextWrapped=true,TextXAlignment=0,ZIndex=10,}},
		{115,"Frame",{BackgroundColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),BorderSizePixel=0,Name="Line",Parent={112},Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),Visible=false,ZIndex=10,}},
		{116,"TextButton",{BackgroundColor3=Color3.new(0.48627451062202,0.61960786581039,0.85098040103912),BorderColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),Font=4,Name="InviteButton",Parent={112},Position=UDim2.new(0,5,0,75),Size=UDim2.new(1,-10,0,25),Text="Copy Discord Invite Link (https://discord.gg/78ZuWSq)",TextColor3=Color3.new(0.1803921610117,0.1803921610117,0.1843137294054),TextSize=16,ZIndex=10,}},
	})
	for i,v in pairs(main.Content.List:GetDescendants()) do
		if v:IsA("TextLabel") then
			table.insert(text1,v)
		end
	end
	table.insert(scroll,main.Content.List)
	table.insert(shade1,main.Content)
	table.insert(shade2,main.TopBar)
	main.Name = randomString()
	main.TopBar.Close.MouseButton1Click:Connect(function()
		main:TweenPosition(UDim2.new(0.5,-250,0,-500), "InOut", "Quart", 0.5, true, nil)
	end)
	local inviteButton = main:FindFirstChild("InviteButton",true)
	local lastPress = nil
	inviteButton.MouseButton1Click:Connect(function()
		if everyClipboard then
			toClipboard("https://discord.gg/78ZuWSq")
			inviteButton.Text = "Copied"
		else
			inviteButton.Text = "No Clipboard Function, type out the link"
		end
		local pressTime = tick()
		lastPress = pressTime
		wait(2)
		if lastPress ~= pressTime then return end
		inviteButton.Text = "Copy Discord Invite Link (https://discord.gg/78ZuWSq)"
	end)
	dragGUI(main)
	main.Parent = ScaledHolder

	ReferenceButton.MouseButton1Click:Connect(function()
		main:TweenPosition(UDim2.new(0.5,-250,0.5,-150), "InOut", "Quart", 0.5, true, nil)
	end)
end)()

currentShade1 = Color3.fromRGB(36, 36, 37)
currentShade2 = Color3.fromRGB(46, 46, 47)
currentShade3 = Color3.fromRGB(78, 78, 79)
currentText1 = Color3.new(1, 1, 1)
currentText2 = Color3.new(0, 0, 0)
currentScroll = Color3.fromRGB(78,78,79)

defaultGuiScale = IsOnMobile and 0.9 or 1
defaultsettings = {
	prefix = ';';
	StayOpen = false;
	guiScale = defaultGuiScale;
	espTransparency = 0.3;
	keepIY = true;
	logsEnabled = false;
	jLogsEnabled = false;
	aliases = {};
	binds = {};
	WayPoints = {};
	PluginsTable = {};
	currentShade1 = {currentShade1.R,currentShade1.G,currentShade1.B};
	currentShade2 = {currentShade2.R,currentShade2.G,currentShade2.B};
	currentShade3 = {currentShade3.R,currentShade3.G,currentShade3.B};
	currentText1 = {currentText1.R,currentText1.G,currentText1.B};
	currentText2 = {currentText2.R,currentText2.G,currentText2.B};
	currentScroll = {currentScroll.R,currentScroll.G,currentScroll.B};
	eventBinds = eventEditor.SaveData()
}

defaults = HttpService:JSONEncode(defaultsettings)
nosaves = false
useFactorySettings = function()
    prefix = ';'
    StayOpen = false
    guiScale = defaultGuiScale
    KeepInfYield = true
    espTransparency = 0.3
    logsEnabled = false
    jLogsEnabled = false
    logsWebhook = nil
    aliases = {}
    binds = {}
    WayPoints = {}
    PluginsTable = {}
end

createPopup = function(text)
    local FileError = Instance.new("Frame")
    local background = Instance.new("Frame")
    local Directions = Instance.new("TextLabel")
    local shadow = Instance.new("Frame")
    local PopupText = Instance.new("TextLabel")
    local Exit = Instance.new("TextButton")
    local ExitImage = Instance.new("ImageLabel")

    FileError.Name = randomString()
    FileError.Parent = ScaledHolder
    FileError.Active = true
    FileError.BackgroundTransparency = 1
    FileError.Position = UDim2.new(0.5, -180, 0, 290)
    FileError.Size = UDim2.new(0, 360, 0, 20)
    FileError.ZIndex = 10

    background.Name = "background"
    background.Parent = FileError
    background.Active = true
    background.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
    background.BorderSizePixel = 0
    background.Position = UDim2.new(0, 0, 0, 20)
    background.Size = UDim2.new(0, 360, 0, 205)
    background.ZIndex = 10

    Directions.Name = "Directions"
    Directions.Parent = background
    Directions.BackgroundTransparency = 1
    Directions.BorderSizePixel = 0
    Directions.Position = UDim2.new(0, 10, 0, 10)
    Directions.Size = UDim2.new(0, 340, 0, 185)
    Directions.Font = Enum.Font.SourceSans
    Directions.TextSize = 14
    Directions.Text = text
    Directions.TextColor3 = Color3.new(1, 1, 1)
    Directions.TextWrapped = true
    Directions.TextXAlignment = Enum.TextXAlignment.Left
    Directions.TextYAlignment = Enum.TextYAlignment.Top
    Directions.ZIndex = 10

    shadow.Name = "shadow"
    shadow.Parent = FileError
    shadow.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
    shadow.BorderSizePixel = 0
    shadow.Size = UDim2.new(0, 360, 0, 20)
    shadow.ZIndex = 10

    PopupText.Name = "PopupText"
    PopupText.Parent = shadow
    PopupText.BackgroundTransparency = 1
    PopupText.Size = UDim2.new(1, 0, 0.95, 0)
    PopupText.ZIndex = 10
    PopupText.Font = Enum.Font.SourceSans
    PopupText.TextSize = 14
    PopupText.Text = "File Error"
    PopupText.TextColor3 = Color3.new(1, 1, 1)
    PopupText.TextWrapped = true

    Exit.Name = "Exit"
    Exit.Parent = shadow
    Exit.BackgroundTransparency = 1
    Exit.Position = UDim2.new(1, -20, 0, 0)
    Exit.Size = UDim2.new(0, 20, 0, 20)
    Exit.Text = ""
    Exit.ZIndex = 10

    ExitImage.Parent = Exit
    ExitImage.BackgroundColor3 = Color3.new(1, 1, 1)
    ExitImage.BackgroundTransparency = 1
    ExitImage.Position = UDim2.new(0, 5, 0, 5)
    ExitImage.Size = UDim2.new(0, 10, 0, 10)
    ExitImage.Image = getcustomasset("infiniteyield/assets/close.png")
    ExitImage.ZIndex = 10

    Exit.MouseButton1Click:Connect(function()
        FileError:Destroy()
    end)
end

local loadedEventData = nil
local jsonAttempts = 0
function saves()
    if writefileExploit() and readfileExploit() and jsonAttempts < 10 then
        local readSuccess, out = readfile("IY_FE.iy", true)
        if readSuccess then
            if out ~= nil and tostring(out):gsub("%s", "") ~= "" then
                local success, response = pcall(function()
                    local json = HttpService:JSONDecode(out)
                    if vtype(json.prefix, "string") then prefix = json.prefix else prefix = ';' end
                    if vtype(json.StayOpen, "boolean") then StayOpen = json.StayOpen else StayOpen = false end
                    if vtype(json.guiScale, "number") then guiScale = json.guiScale else guiScale = defaultGuiScale end
                    if vtype(json.keepIY, "boolean") then KeepInfYield = json.keepIY else KeepInfYield = true end
                    if vtype(json.espTransparency, "number") then espTransparency = json.espTransparency else espTransparency = 0.3 end
                    if vtype(json.logsEnabled, "boolean") then logsEnabled = json.logsEnabled else logsEnabled = false end
                    if vtype(json.jLogsEnabled, "boolean") then jLogsEnabled = json.jLogsEnabled else jLogsEnabled = false end
                    if vtype(json.logsWebhook, "string") then logsWebhook = json.logsWebhook else logsWebhook = nil end
                    if vtype(json.aliases, "table") then aliases = json.aliases else aliases = {} end
                    if vtype(json.binds, "table") then binds = json.binds else binds = {} end
                    if vtype(json.spawnCmds, "table") then spawnCmds = json.spawnCmds end
                    if vtype(json.WayPoints, "table") then AllWaypoints = json.WayPoints else WayPoints = {} AllWaypoints = {} end
                    if vtype(json.PluginsTable, "table") then PluginsTable = json.PluginsTable else PluginsTable = {} end
                    if vtype(json.currentShade1, "table") then currentShade1 = Color3.new(json.currentShade1[1],json.currentShade1[2],json.currentShade1[3]) end
                    if vtype(json.currentShade2, "table") then currentShade2 = Color3.new(json.currentShade2[1],json.currentShade2[2],json.currentShade2[3]) end
                    if vtype(json.currentShade3, "table") then currentShade3 = Color3.new(json.currentShade3[1],json.currentShade3[2],json.currentShade3[3]) end
                    if vtype(json.currentText1, "table") then currentText1 = Color3.new(json.currentText1[1],json.currentText1[2],json.currentText1[3]) end
                    if vtype(json.currentText2, "table") then currentText2 = Color3.new(json.currentText2[1],json.currentText2[2],json.currentText2[3]) end
                    if vtype(json.currentScroll, "table") then currentScroll = Color3.new(json.currentScroll[1],json.currentScroll[2],json.currentScroll[3]) end
                    if vtype(json.eventBinds, "string") then loadedEventData = json.eventBinds end
                end)
                if not success then
                    jsonAttempts = jsonAttempts + 1
                    warn("Save Json Error:", response)
                    warn("Overwriting Save File")
                    writefile("IY_FE.iy", defaults, true)
                    wait()
                    saves()
                end
            else
                writefile("IY_FE.iy", defaults, true)
                wait()
                local dReadSuccess, dOut = readfile("IY_FE.iy", true)
                if dReadSuccess and dOut ~= nil and tostring(dOut):gsub("%s", "") ~= "" then
                    saves()
                else
                    nosaves = true
                    useFactorySettings()
                    createPopup("There was a problem writing a save file to your PC.\n\nPlease contact the developer/support team for your exploit and tell them writefile/readfile is not working.\n\nYour settings, keybinds, waypoints, and aliases will not save if you continue.\n\nThings to try:\n> Make sure a 'workspace' folder is located in the same folder as your exploit\n> If your exploit is inside of a zip/rar file, extract it.\n> Rejoin the game and try again or restart your PC and try again.")
                end
            end
        else
            writefile("IY_FE.iy", defaults, true)
            wait()
            local dReadSuccess, dOut = readfile("IY_FE.iy", true)
            if dReadSuccess and dOut ~= nil and tostring(dOut):gsub("%s", "") ~= "" then
                saves()
            else
                nosaves = true
                useFactorySettings()
                createPopup("There was a problem writing a save file to your PC.\n\nPlease contact the developer/support team for your exploit and tell them writefile/readfile is not working.\n\nYour settings, keybinds, waypoints, and aliases will not save if you continue.\n\nThings to try:\n> Make sure a 'workspace' folder is located in the same folder as your exploit\n> If your exploit is inside of a zip/rar file, extract it.\n> Rejoin the game and try again or restart your PC and try again.")
            end
        end
    else
        if jsonAttempts >= 10 then
            nosaves = true
            useFactorySettings()
            createPopup("Sorry, we have attempted to parse your save file, but it is unreadable!\n\nInfinite Yield is now using factory settings until your exploit's file system works.\n\nYour save file has not been deleted.")
        else
            nosaves = true
            useFactorySettings()
        end
    end
end

saves()

function updatesaves()
	if nosaves == false and writefileExploit() then
		local update = {
			prefix = prefix;
			StayOpen = StayOpen;
			guiScale = guiScale;
			keepIY = KeepInfYield;
			espTransparency = espTransparency;
			logsEnabled = logsEnabled;
			jLogsEnabled = jLogsEnabled;
			logsWebhook = logsWebhook;
			aliases = aliases;
			binds = binds or {};
			WayPoints = AllWaypoints;
			PluginsTable = PluginsTable;
			currentShade1 = {currentShade1.R,currentShade1.G,currentShade1.B};
			currentShade2 = {currentShade2.R,currentShade2.G,currentShade2.B};
			currentShade3 = {currentShade3.R,currentShade3.G,currentShade3.B};
			currentText1 = {currentText1.R,currentText1.G,currentText1.B};
			currentText2 = {currentText2.R,currentText2.G,currentText2.B};
			currentScroll = {currentScroll.R,currentScroll.G,currentScroll.B};
			eventBinds = eventEditor.SaveData()
		}
		writefileCooldown("IY_FE.iy", HttpService:JSONEncode(update))
	end
end

eventEditor.SetOnEdited(updatesaves)

pWayPoints = {}
WayPoints = {}

if #AllWaypoints > 0 then
	for i = 1, #AllWaypoints do
		if not AllWaypoints[i].GAME or AllWaypoints[i].GAME == PlaceId then
			WayPoints[#WayPoints + 1] = {NAME = AllWaypoints[i].NAME, COORD = {AllWaypoints[i].COORD[1], AllWaypoints[i].COORD[2], AllWaypoints[i].COORD[3]}, GAME = AllWaypoints[i].GAME}
		end
	end
end

if type(binds) ~= "table" then binds = {} end

function Time()
	local HOUR = math.floor((tick() % 86400) / 3600)
	local MINUTE = math.floor((tick() % 3600) / 60)
	local SECOND = math.floor(tick() % 60)
	local AP = HOUR > 11 and 'PM' or 'AM'
	HOUR = (HOUR % 12 == 0 and 12 or HOUR % 12)
	HOUR = HOUR < 10 and '0' .. HOUR or HOUR
	MINUTE = MINUTE < 10 and '0' .. MINUTE or MINUTE
	SECOND = SECOND < 10 and '0' .. SECOND or SECOND
	return HOUR .. ':' .. MINUTE .. ':' .. SECOND .. ' ' .. AP
end

PrefixBox.Text = prefix
local SettingsOpen = false
local isHidden = false

if StayOpen == false then
	On.BackgroundTransparency = 1
else
	On.BackgroundTransparency = 0
end

if logsEnabled then
	Toggle.Text = 'Enabled'
else
	Toggle.Text = 'Disabled'
end

if jLogsEnabled then
	Toggle_2.Text = 'Enabled'
else
	Toggle_2.Text = 'Disabled'
end

function maximizeHolder()
	if StayOpen == false then
		Holder:TweenPosition(UDim2.new(1, Holder.Position.X.Offset, 1, -220), "InOut", "Quart", 0.2, true, nil)
	end
end

minimizeNum = -20
function minimizeHolder()
	if StayOpen == false then
		Holder:TweenPosition(UDim2.new(1, Holder.Position.X.Offset, 1, minimizeNum), "InOut", "Quart", 0.5, true, nil)
	end
end

function cmdbarHolder()
	if StayOpen == false then
		Holder:TweenPosition(UDim2.new(1, Holder.Position.X.Offset, 1, -45), "InOut", "Quart", 0.5, true, nil)
	end
end

pinNotification = nil
local notifyCount = 0
function notify(text,text2,length)
	task.spawn(function()
		local LnotifyCount = notifyCount+1
		local notificationPinned = false
		notifyCount = notifyCount+1
		if pinNotification then pinNotification:Disconnect() end
		pinNotification = PinButton.MouseButton1Click:Connect(function()
			task.spawn(function()
				pinNotification:Disconnect()
				notificationPinned = true
				Title_2.BackgroundTransparency = 1
				wait(0.5)
				Title_2.BackgroundTransparency = 0
			end)
		end)
		Notification:TweenPosition(UDim2.new(1, Notification.Position.X.Offset, 1, 0), "InOut", "Quart", 0.5, true, nil)
		wait(0.6)
		local closepressed = false
		if text2 then
			Title_2.Text = text
			Text_2.Text = text2
		else
			Title_2.Text = 'Notification'
			Text_2.Text = text
		end
		Notification:TweenPosition(UDim2.new(1, Notification.Position.X.Offset, 1, -100), "InOut", "Quart", 0.5, true, nil)
		CloseButton.MouseButton1Click:Connect(function()
			Notification:TweenPosition(UDim2.new(1, Notification.Position.X.Offset, 1, 0), "InOut", "Quart", 0.5, true, nil)
			closepressed = true
			pinNotification:Disconnect()
		end)
		if length and isNumber(length) then
			wait(length)
		else
			wait(10)
		end
		if LnotifyCount == notifyCount then
			if closepressed == false and notificationPinned == false then
				pinNotification:Disconnect()
				Notification:TweenPosition(UDim2.new(1, Notification.Position.X.Offset, 1, 0), "InOut", "Quart", 0.5, true, nil)
			end
			notifyCount = 0
		end
	end)
end

local lastMessage = nil
local lastLabel = nil
local dupeCount = 1
function CreateLabel(Name, Text)
	if lastMessage == Name..Text then
		dupeCount = dupeCount+1
		lastLabel.Text = Time()..' - ['..Name..']: '..Text..' (x'..dupeCount..')'
	else
		if dupeCount > 1 then dupeCount = 1 end
		if #scroll_2:GetChildren() >= 2546 then
			scroll_2:ClearAllChildren()
		end
		local alls = 0
		for i,v in pairs(scroll_2:GetChildren()) do
			if v then
				alls = v.Size.Y.Offset + alls
			end
			if not v then
				alls = 0
			end
		end
		local tl = Instance.new('TextLabel')
		lastMessage = Name..Text
		lastLabel = tl
		tl.Name = Name
		tl.Parent = scroll_2
		tl.ZIndex = 10
		tl.Text = Time().." - ["..Name.."]: "..Text
		tl.Size = UDim2.new(0,322,0,84)
		tl.BackgroundTransparency = 1
		tl.BorderSizePixel = 0
		tl.Font = "SourceSans"
		tl.Position = UDim2.new(-1,0,0,alls)
		tl.TextTransparency = 1
		tl.TextScaled = false
		tl.TextSize = 14
		tl.TextWrapped = true
		tl.TextXAlignment = "Left"
		tl.TextYAlignment = "Top"
		tl.TextColor3 = currentText1
		tl.Size = UDim2.new(0,322,0,tl.TextBounds.Y)
		table.insert(text1,tl)
		scroll_2.CanvasSize = UDim2.new(0,0,0,alls+tl.TextBounds.Y)
		scroll_2.CanvasPosition = Vector2.new(0,scroll_2.CanvasPosition.Y+tl.TextBounds.Y)
		tl:TweenPosition(UDim2.new(0,3,0,alls), 'In', 'Quint', 0.5)
		TweenService:Create(tl, TweenInfo.new(1.25, Enum.EasingStyle.Linear), { TextTransparency = 0 }):Play()
	end
end

function CreateJoinLabel(plr,ID)
	if #scroll_3:GetChildren() >= 2546 then
		scroll_3:ClearAllChildren()
	end
	local infoFrame = Instance.new("Frame")
	local info1 = Instance.new("TextLabel")
	local info2 = Instance.new("TextLabel")
	local ImageLabel_3 = Instance.new("ImageLabel")
	infoFrame.Name = randomString()
	infoFrame.Parent = scroll_3
	infoFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	infoFrame.BackgroundTransparency = 1
	infoFrame.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
	infoFrame.Size = UDim2.new(1, 0, 0, 50)
	info1.Name = randomString()
	info1.Parent = infoFrame
	info1.BackgroundTransparency = 1
	info1.BorderSizePixel = 0
	info1.Position = UDim2.new(0, 45, 0, 0)
	info1.Size = UDim2.new(0, 135, 1, 0)
	info1.ZIndex = 10
	info1.Font = Enum.Font.SourceSans
	info1.FontSize = Enum.FontSize.Size14
	info1.Text = "Username: "..plr.Name.."\nJoined Server: "..Time()
	info1.TextColor3 = Color3.new(1, 1, 1)
	info1.TextWrapped = true
	info1.TextXAlignment = Enum.TextXAlignment.Left
	info2.Name = randomString()
	info2.Parent = infoFrame
	info2.BackgroundTransparency = 1
	info2.BorderSizePixel = 0
	info2.Position = UDim2.new(0, 185, 0, 0)
	info2.Size = UDim2.new(0, 140, 1, -5)
	info2.ZIndex = 10
	info2.Font = Enum.Font.SourceSans
	info2.FontSize = Enum.FontSize.Size14
	info2.Text = "User ID: "..ID.."\nAccount Age: "..plr.AccountAge.."\nJoined Roblox: Loading..."
	info2.TextColor3 = Color3.new(1, 1, 1)
	info2.TextWrapped = true
	info2.TextXAlignment = Enum.TextXAlignment.Left
	info2.TextYAlignment = Enum.TextYAlignment.Center
	ImageLabel_3.Parent = infoFrame
	ImageLabel_3.BackgroundTransparency = 1
	ImageLabel_3.BorderSizePixel = 0
	ImageLabel_3.Size = UDim2.new(0, 45, 1, 0)
	ImageLabel_3.Image = Players:GetUserThumbnailAsync(ID, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)
	scroll_3.CanvasSize = UDim2.new(0, 0, 0, listlayout.AbsoluteContentSize.Y)
	scroll_3.CanvasPosition = Vector2.new(0,scroll_2.CanvasPosition.Y+infoFrame.AbsoluteSize.Y)
	wait()
	local user = game:HttpGet("https://users.roblox.com/v1/users/"..ID)
	local json = HttpService:JSONDecode(user)
	local date = json["created"]:sub(1,10)
	local splitDates = string.split(date,"-")
	info2.Text = string.gsub(info2.Text, "Loading...",splitDates[2].."/"..splitDates[3].."/"..splitDates[1])
end

IYMouse.KeyDown:Connect(function(Key)
	if (Key==prefix) then
		RunService.RenderStepped:Wait()
		Cmdbar:CaptureFocus()
		maximizeHolder()
	end
end)

local lastMinimizeReq = 0
Holder.MouseEnter:Connect(function()
	lastMinimizeReq = 0
	maximizeHolder()
end)

Holder.MouseLeave:Connect(function()
	if not Cmdbar:IsFocused() then
		local reqTime = tick()
		lastMinimizeReq = reqTime
		wait(1)
		if lastMinimizeReq ~= reqTime then return end
		if not Cmdbar:IsFocused() then
			minimizeHolder()
		end
	end
end)

function updateColors(color,ctype)
	if ctype == shade1 then
		for i,v in pairs(shade1) do
			v.BackgroundColor3 = color
		end
		currentShade1 = color
	elseif ctype == shade2 then
		for i,v in pairs(shade2) do
			v.BackgroundColor3 = color
		end
		currentShade2 = color
	elseif ctype == shade3 then
		for i,v in pairs(shade3) do
			v.BackgroundColor3 = color
		end
		currentShade3 = color
	elseif ctype == text1 then
		for i,v in pairs(text1) do
			v.TextColor3 = color
			if v:IsA("TextBox") then
				v.PlaceholderColor3 = color	
			end
		end
		currentText1 = color
	elseif ctype == text2 then
		for i,v in pairs(text2) do
			v.TextColor3 = color
		end
		currentText2 = color
	elseif ctype == scroll then
		for i,v in pairs(scroll) do
			v.ScrollBarImageColor3 = color
		end
		currentScroll = color
	end
end

local colorpickerOpen = false
ColorsButton.MouseButton1Click:Connect(function()
	cache_currentShade1 = currentShade1
	cache_currentShade2 = currentShade2
	cache_currentShade3 = currentShade3
	cache_currentText1 = currentText1
	cache_currentText2 = currentText2
	cache_currentScroll = currentScroll
	if not colorpickerOpen then
		colorpickerOpen = true
		picker = game:GetObjects("rbxassetid://4908465318")[1]
		picker.Name = randomString()
		picker.Parent = ScaledHolder

		local ColorPicker do
			ColorPicker = {}

			ColorPicker.new = function()
				local newMt = setmetatable({},{})

				local pickerGui = picker.ColorPicker
				local pickerTopBar = pickerGui.TopBar
				local pickerExit = pickerTopBar.Exit
				local pickerFrame = pickerGui.Content
				local colorSpace = pickerFrame.ColorSpaceFrame.ColorSpace
				local colorStrip = pickerFrame.ColorStrip
				local previewFrame = pickerFrame.Preview
				local basicColorsFrame = pickerFrame.BasicColors
				local customColorsFrame = pickerFrame.CustomColors
				local defaultButton = pickerFrame.Default
				local cancelButton = pickerFrame.Cancel
				local shade1Button = pickerFrame.Shade1
				local shade2Button = pickerFrame.Shade2
				local shade3Button = pickerFrame.Shade3
				local text1Button = pickerFrame.Text1
				local text2Button = pickerFrame.Text2
				local scrollButton = pickerFrame.Scroll

				local colorScope = colorSpace.Scope
				local colorArrow = pickerFrame.ArrowFrame.Arrow

				local hueInput = pickerFrame.Hue.Input
				local satInput = pickerFrame.Sat.Input
				local valInput = pickerFrame.Val.Input

				local redInput = pickerFrame.Red.Input
				local greenInput = pickerFrame.Green.Input
				local blueInput = pickerFrame.Blue.Input

				local mouse = IYMouse

				local hue,sat,val = 0,0,1
				local red,green,blue = 1,1,1
				local chosenColor = Color3.new(0,0,0)

				local basicColors = {Color3.new(0,0,0),Color3.new(0.66666668653488,0,0),Color3.new(0,0.33333334326744,0),Color3.new(0.66666668653488,0.33333334326744,0),Color3.new(0,0.66666668653488,0),Color3.new(0.66666668653488,0.66666668653488,0),Color3.new(0,1,0),Color3.new(0.66666668653488,1,0),Color3.new(0,0,0.49803924560547),Color3.new(0.66666668653488,0,0.49803924560547),Color3.new(0,0.33333334326744,0.49803924560547),Color3.new(0.66666668653488,0.33333334326744,0.49803924560547),Color3.new(0,0.66666668653488,0.49803924560547),Color3.new(0.66666668653488,0.66666668653488,0.49803924560547),Color3.new(0,1,0.49803924560547),Color3.new(0.66666668653488,1,0.49803924560547),Color3.new(0,0,1),Color3.new(0.66666668653488,0,1),Color3.new(0,0.33333334326744,1),Color3.new(0.66666668653488,0.33333334326744,1),Color3.new(0,0.66666668653488,1),Color3.new(0.66666668653488,0.66666668653488,1),Color3.new(0,1,1),Color3.new(0.66666668653488,1,1),Color3.new(0.33333334326744,0,0),Color3.new(1,0,0),Color3.new(0.33333334326744,0.33333334326744,0),Color3.new(1,0.33333334326744,0),Color3.new(0.33333334326744,0.66666668653488,0),Color3.new(1,0.66666668653488,0),Color3.new(0.33333334326744,1,0),Color3.new(1,1,0),Color3.new(0.33333334326744,0,0.49803924560547),Color3.new(1,0,0.49803924560547),Color3.new(0.33333334326744,0.33333334326744,0.49803924560547),Color3.new(1,0.33333334326744,0.49803924560547),Color3.new(0.33333334326744,0.66666668653488,0.49803924560547),Color3.new(1,0.66666668653488,0.49803924560547),Color3.new(0.33333334326744,1,0.49803924560547),Color3.new(1,1,0.49803924560547),Color3.new(0.33333334326744,0,1),Color3.new(1,0,1),Color3.new(0.33333334326744,0.33333334326744,1),Color3.new(1,0.33333334326744,1),Color3.new(0.33333334326744,0.66666668653488,1),Color3.new(1,0.66666668653488,1),Color3.new(0.33333334326744,1,1),Color3.new(1,1,1)}
				local customColors = {}

				dragGUI(picker)

				local function updateColor(noupdate)
					local relativeX,relativeY,relativeStripY = 219 - hue*219, 199 - sat*199, 199 - val*199
					local hsvColor = Color3.fromHSV(hue,sat,val)

					if noupdate == 2 or not noupdate then
						hueInput.Text = tostring(math.ceil(359*hue))
						satInput.Text = tostring(math.ceil(255*sat))
						valInput.Text = tostring(math.floor(255*val))
					end
					if noupdate == 1 or not noupdate then
						redInput.Text = tostring(math.floor(255*red))
						greenInput.Text = tostring(math.floor(255*green))
						blueInput.Text = tostring(math.floor(255*blue))
					end

					chosenColor = Color3.new(red,green,blue)

					colorScope.Position = UDim2.new(0,relativeX-9,0,relativeY-9)
					colorStrip.ImageColor3 = Color3.fromHSV(hue,sat,1)
					colorArrow.Position = UDim2.new(0,-2,0,relativeStripY-4)
					previewFrame.BackgroundColor3 = chosenColor

					newMt.Color = chosenColor
					if newMt.Changed then newMt:Changed(chosenColor) end
				end

				local function colorSpaceInput()
					local relativeX = mouse.X - colorSpace.AbsolutePosition.X
					local relativeY = mouse.Y - colorSpace.AbsolutePosition.Y

					if relativeX < 0 then relativeX = 0 elseif relativeX > 219 then relativeX = 219 end
					if relativeY < 0 then relativeY = 0 elseif relativeY > 199 then relativeY = 199 end

					hue = (219 - relativeX)/219
					sat = (199 - relativeY)/199

					local hsvColor = Color3.fromHSV(hue,sat,val)
					red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b

					updateColor()
				end

				local function colorStripInput()
					local relativeY = mouse.Y - colorStrip.AbsolutePosition.Y

					if relativeY < 0 then relativeY = 0 elseif relativeY > 199 then relativeY = 199 end	

					val = (199 - relativeY)/199

					local hsvColor = Color3.fromHSV(hue,sat,val)
					red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b

					updateColor()
				end

				local function hookButtons(frame,func)
					frame.ArrowFrame.Up.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							frame.ArrowFrame.Up.BackgroundTransparency = 0.5
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
							local releaseEvent,runEvent

							local startTime = tick()
							local pressing = true
							local startNum = tonumber(frame.Text)

							if not startNum then return end

							releaseEvent = UserInputService.InputEnded:Connect(function(input)
								if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
								releaseEvent:Disconnect()
								pressing = false
							end)

							startNum = startNum + 1
							func(startNum)
							while pressing do
								if tick()-startTime > 0.3 then
									startNum = startNum + 1
									func(startNum)
								end
								wait(0.1)
							end
						end
					end)

					frame.ArrowFrame.Up.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							frame.ArrowFrame.Up.BackgroundTransparency = 1
						end
					end)

					frame.ArrowFrame.Down.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							frame.ArrowFrame.Down.BackgroundTransparency = 0.5
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
							local releaseEvent,runEvent

							local startTime = tick()
							local pressing = true
							local startNum = tonumber(frame.Text)

							if not startNum then return end

							releaseEvent = UserInputService.InputEnded:Connect(function(input)
								if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
								releaseEvent:Disconnect()
								pressing = false
							end)

							startNum = startNum - 1
							func(startNum)
							while pressing do
								if tick()-startTime > 0.3 then
									startNum = startNum - 1
									func(startNum)
								end
								wait(0.1)
							end
						end
					end)

					frame.ArrowFrame.Down.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							frame.ArrowFrame.Down.BackgroundTransparency = 1
						end
					end)
				end

				colorSpace.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local releaseEvent,mouseEvent

						releaseEvent = UserInputService.InputEnded:Connect(function(input)
							if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
							releaseEvent:Disconnect()
							mouseEvent:Disconnect()
						end)

						mouseEvent = UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								colorSpaceInput()
							end
						end)

						colorSpaceInput()
					end
				end)

				colorStrip.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local releaseEvent,mouseEvent

						releaseEvent = UserInputService.InputEnded:Connect(function(input)
							if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
							releaseEvent:Disconnect()
							mouseEvent:Disconnect()
						end)

						mouseEvent = UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								colorStripInput()
							end
						end)

						colorStripInput()
					end
				end)

				local function updateHue(str)
					local num = tonumber(str)
					if num then
						hue = math.clamp(math.floor(num),0,359)/359
						local hsvColor = Color3.fromHSV(hue,sat,val)
						red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b
						hueInput.Text = tostring(hue*359)
						updateColor(1)
					end
				end
				hueInput.FocusLost:Connect(function() updateHue(hueInput.Text) end) hookButtons(hueInput,updateHue)

				local function updateSat(str)
					local num = tonumber(str)
					if num then
						sat = math.clamp(math.floor(num),0,255)/255
						local hsvColor = Color3.fromHSV(hue,sat,val)
						red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b
						satInput.Text = tostring(sat*255)
						updateColor(1)
					end
				end
				satInput.FocusLost:Connect(function() updateSat(satInput.Text) end) hookButtons(satInput,updateSat)

				local function updateVal(str)
					local num = tonumber(str)
					if num then
						val = math.clamp(math.floor(num),0,255)/255
						local hsvColor = Color3.fromHSV(hue,sat,val)
						red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b
						valInput.Text = tostring(val*255)
						updateColor(1)
					end
				end
				valInput.FocusLost:Connect(function() updateVal(valInput.Text) end) hookButtons(valInput,updateVal)

				local function updateRed(str)
					local num = tonumber(str)
					if num then
						red = math.clamp(math.floor(num),0,255)/255
						local newColor = Color3.new(red,green,blue)
						hue,sat,val = Color3.toHSV(newColor)
						redInput.Text = tostring(red*255)
						updateColor(2)
					end
				end
				redInput.FocusLost:Connect(function() updateRed(redInput.Text) end) hookButtons(redInput,updateRed)

				local function updateGreen(str)
					local num = tonumber(str)
					if num then
						green = math.clamp(math.floor(num),0,255)/255
						local newColor = Color3.new(red,green,blue)
						hue,sat,val = Color3.toHSV(newColor)
						greenInput.Text = tostring(green*255)
						updateColor(2)
					end
				end
				greenInput.FocusLost:Connect(function() updateGreen(greenInput.Text) end) hookButtons(greenInput,updateGreen)

				local function updateBlue(str)
					local num = tonumber(str)
					if num then
						blue = math.clamp(math.floor(num),0,255)/255
						local newColor = Color3.new(red,green,blue)
						hue,sat,val = Color3.toHSV(newColor)
						blueInput.Text = tostring(blue*255)
						updateColor(2)
					end
				end
				blueInput.FocusLost:Connect(function() updateBlue(blueInput.Text) end) hookButtons(blueInput,updateBlue)

				local colorChoice = Instance.new("TextButton")
				colorChoice.Name = "Choice"
				colorChoice.Size = UDim2.new(0,25,0,18)
				colorChoice.BorderColor3 = Color3.new(96/255,96/255,96/255)
				colorChoice.Text = ""
				colorChoice.AutoButtonColor = false
				colorChoice.ZIndex = 10

				local row = 0
				local column = 0
				for i,v in pairs(basicColors) do
					local newColor = colorChoice:Clone()
					newColor.BackgroundColor3 = v
					newColor.Position = UDim2.new(0,1 + 30*column,0,21 + 23*row)

					newColor.MouseButton1Click:Connect(function()
						red,green,blue = v.r,v.g,v.b
						local newColor = Color3.new(red,green,blue)
						hue,sat,val = Color3.toHSV(newColor)
						updateColor()
					end)	

					newColor.Parent = basicColorsFrame
					column = column + 1
					if column == 6 then row = row + 1 column = 0 end
				end

				row = 0
				column = 0
				for i = 1,12 do
					local color = customColors[i] or Color3.new(0,0,0)
					local newColor = colorChoice:Clone()
					newColor.BackgroundColor3 = color
					newColor.Position = UDim2.new(0,1 + 30*column,0,20 + 23*row)

					newColor.MouseButton1Click:Connect(function()
						local curColor = customColors[i] or Color3.new(0,0,0)
						red,green,blue = curColor.r,curColor.g,curColor.b
						hue,sat,val = Color3.toHSV(curColor)
						updateColor()
					end)

					newColor.MouseButton2Click:Connect(function()
						customColors[i] = chosenColor
						newColor.BackgroundColor3 = chosenColor
					end)

					newColor.Parent = customColorsFrame
					column = column + 1
					if column == 6 then row = row + 1 column = 0 end
				end

				shade1Button.MouseButton1Click:Connect(function() if newMt.Confirm then newMt:Confirm(chosenColor,shade1) end end)
				shade1Button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then shade1Button.BackgroundTransparency = 0.4 end end)
				shade1Button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then shade1Button.BackgroundTransparency = 0 end end)

				shade2Button.MouseButton1Click:Connect(function() if newMt.Confirm then newMt:Confirm(chosenColor,shade2) end end)
				shade2Button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then shade2Button.BackgroundTransparency = 0.4 end end)
				shade2Button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then shade2Button.BackgroundTransparency = 0 end end)

				shade3Button.MouseButton1Click:Connect(function() if newMt.Confirm then newMt:Confirm(chosenColor,shade3) end end)
				shade3Button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then shade3Button.BackgroundTransparency = 0.4 end end)
				shade3Button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then shade3Button.BackgroundTransparency = 0 end end)

				text1Button.MouseButton1Click:Connect(function() if newMt.Confirm then newMt:Confirm(chosenColor,text1) end end)
				text1Button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then text1Button.BackgroundTransparency = 0.4 end end)
				text1Button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then text1Button.BackgroundTransparency = 0 end end)

				text2Button.MouseButton1Click:Connect(function() if newMt.Confirm then newMt:Confirm(chosenColor,text2) end end)
				text2Button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then text2Button.BackgroundTransparency = 0.4 end end)
				text2Button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then text2Button.BackgroundTransparency = 0 end end)

				scrollButton.MouseButton1Click:Connect(function() if newMt.Confirm then newMt:Confirm(chosenColor,scroll) end end)
				scrollButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then scrollButton.BackgroundTransparency = 0.4 end end)
				scrollButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then scrollButton.BackgroundTransparency = 0 end end)

				cancelButton.MouseButton1Click:Connect(function() if newMt.Cancel then newMt:Cancel() end end)
				cancelButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then cancelButton.BackgroundTransparency = 0.4 end end)
				cancelButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then cancelButton.BackgroundTransparency = 0 end end)

				defaultButton.MouseButton1Click:Connect(function() if newMt.Default then newMt:Default() end end)
				defaultButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then defaultButton.BackgroundTransparency = 0.4 end end)
				defaultButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then defaultButton.BackgroundTransparency = 0 end end)

				pickerExit.MouseButton1Click:Connect(function()
					picker:TweenPosition(UDim2.new(0.5, -219, 0, -500), "InOut", "Quart", 0.5, true, nil)
				end)

				updateColor()

				newMt.SetColor = function(self,color)
					red,green,blue = color.r,color.g,color.b
					hue,sat,val = Color3.toHSV(color)
					updateColor()
				end

				return newMt
			end
		end

		picker:TweenPosition(UDim2.new(0.5, -219, 0, 100), "InOut", "Quart", 0.5, true, nil)

		local Npicker = ColorPicker.new()
		Npicker.Confirm = function(self,color,ctype) updateColors(color,ctype) wait() updatesaves() end
		Npicker.Cancel = function(self)
			updateColors(cache_currentShade1,shade1)
			updateColors(cache_currentShade2,shade2)
			updateColors(cache_currentShade3,shade3)
			updateColors(cache_currentText1,text1)
			updateColors(cache_currentText2,text2)
			updateColors(cache_currentScroll,scroll)
			wait()
			updatesaves()
		end
		Npicker.Default = function(self)
			updateColors(Color3.fromRGB(36, 36, 37),shade1)
			updateColors(Color3.fromRGB(46, 46, 47),shade2)
			updateColors(Color3.fromRGB(78, 78, 79),shade3)
			updateColors(Color3.new(1, 1, 1),text1)
			updateColors(Color3.new(0, 0, 0),text2)
			updateColors(Color3.fromRGB(78,78,79),scroll)
			wait()
			updatesaves()
		end
	else
		picker:TweenPosition(UDim2.new(0.5, -219, 0, 100), "InOut", "Quart", 0.5, true, nil)
	end
end)


SettingsButton.MouseButton1Click:Connect(function()
	if SettingsOpen == false then SettingsOpen = true
		Settings:TweenPosition(UDim2.new(0, 0, 0, 45), "InOut", "Quart", 0.5, true, nil)
		CMDsF.Visible = false
	else SettingsOpen = false
		CMDsF.Visible = true
		Settings:TweenPosition(UDim2.new(0, 0, 0, 220), "InOut", "Quart", 0.5, true, nil)
	end
end)

On.MouseButton1Click:Connect(function()
	if isHidden == false then
		if StayOpen == false then
			StayOpen = true
			On.BackgroundTransparency = 0
		else
			StayOpen = false
			On.BackgroundTransparency = 1
		end
		updatesaves()
	end
end)

Clear.MouseButton1Down:Connect(function()
	for _, child in pairs(scroll_2:GetChildren()) do
		child:Destroy()
	end
	scroll_2.CanvasSize = UDim2.new(0, 0, 0, 10)
end)

Clear_2.MouseButton1Down:Connect(function()
	for _, child in pairs(scroll_3:GetChildren()) do
		child:Destroy()
	end
	scroll_3.CanvasSize = UDim2.new(0, 0, 0, 10)
end)

Toggle.MouseButton1Down:Connect(function()
	if logsEnabled then
		logsEnabled = false
		Toggle.Text = 'Disabled'
		updatesaves()
	else
		logsEnabled = true
		Toggle.Text = 'Enabled'
		updatesaves()
	end
end)

Toggle_2.MouseButton1Down:Connect(function()
	if jLogsEnabled then
		jLogsEnabled = false
		Toggle_2.Text = 'Disabled'
		updatesaves()
	else
		jLogsEnabled = true
		Toggle_2.Text = 'Enabled'
		updatesaves()
	end
end)

selectChat.MouseButton1Down:Connect(function()
	join.Visible = false
	chat.Visible = true
	table.remove(shade3,table.find(shade3,selectChat))
	table.remove(shade2,table.find(shade2,selectJoin))
	table.insert(shade2,selectChat)
	table.insert(shade3,selectJoin)
	selectJoin.BackgroundColor3 = currentShade3
	selectChat.BackgroundColor3 = currentShade2
end)

selectJoin.MouseButton1Down:Connect(function()
	chat.Visible = false
	join.Visible = true	
	table.remove(shade3,table.find(shade3,selectJoin))
	table.remove(shade2,table.find(shade2,selectChat))
	table.insert(shade2,selectJoin)
	table.insert(shade3,selectChat)
	selectChat.BackgroundColor3 = currentShade3
	selectJoin.BackgroundColor3 = currentShade2
end)

if not writefileExploit() then
    notify("Saves", "Your exploit does not support read/write file. Your settings will not save.")
end

avatarcache = {}
function sendChatWebhook(player, message)
  if httprequest and vtype(logsWebhook, "string") then
    local id = player.UserId
    local avatar = avatarcache[id]
    if not avatar then
      local d = HttpService:JSONDecode(httprequest({
        Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. id .. "&size=420x420&format=Png&isCircular=false",
        Method = "GET"
      }).Body)["data"]
      avatar = d and d[1].state == "Completed" and d[1].imageUrl or "https://files.catbox.moe/i968v2.jpg"
      avatarcache[id] = avatar
    end
    local log = HttpService:JSONEncode({
      content = message,
      avatar_url = avatar,
      username = formatUsername(player),
      allowed_mentions = {parse = {}}
    })
    httprequest({
      Url = logsWebhook,
      Method = "POST",
      Headers = {["Content-Type"] = "application/json"},
      Body = log
    })
  end
end

ChatLog = function(player)
    player.Chatted:Connect(function(message)
        if logsEnabled == true then
            CreateLabel(player.Name, message)
            sendChatWebhook(player, message)
        end
    end)
end

JoinLog = function(plr)
	if jLogsEnabled == true then
		CreateJoinLabel(plr,plr.UserId)
	end
end

CleanFileName = function(name)
    return tostring(name):gsub("[*\\?:<>|]+", ""):sub(1, 175)
end

SaveChatlogs.MouseButton1Down:Connect(function()
	if writefileExploit() then
		if #scroll_2:GetChildren() > 0 then
			notify("Loading",'Hold on a sec')
			local placeName = CleanFileName(MarketplaceService:GetProductInfo(PlaceId).Name)
			local writelogs = '-- Infinite Yield Chat logs for "'..placeName..'"\n'
			for _, child in pairs(scroll_2:GetChildren()) do
				writelogs = writelogs..'\n'..child.Text
			end
			local writelogsFile = tostring(writelogs)
			local fileext = 0
			local function nameFile()
				local file
				pcall(function() file = readfile(placeName..' Chat Logs ('..fileext..').txt') end)
				if file then
					fileext = fileext+1
					nameFile()
				else
					writefileCooldown(placeName..' Chat Logs ('..fileext..').txt', writelogsFile)
				end
			end
			nameFile()
			notify('Chat Logs','Saved chat logs to the workspace folder within your exploit folder.')
		end
	else
		notify('Chat Logs','Your exploit does not support write file. You cannot save chat logs.')
	end
end)

if isLegacyChat then
    for _, plr in pairs(Players:GetPlayers()) do
        ChatLog(plr)
    end
end

Players.PlayerRemoving:Connect(function(player)
	if ESPenabled or CHMSenabled or COREGUI:FindFirstChild(player.Name..'_LC') then
		for i,v in pairs(COREGUI:GetChildren()) do
			if v.Name == player.Name..'_ESP' or v.Name == player.Name..'_LC' or v.Name == player.Name..'_CHMS' then
				v:Destroy()
			end
		end
	end
	if viewing ~= nil and player == viewing then
		workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character
		viewing = nil
		if viewDied then
			viewDied:Disconnect()
			viewChanged:Disconnect()
		end
		notify('Spectate','View turned off (player left)')
	end
	eventEditor.FireEvent("OnLeave", player.Name)
end)

Exit.MouseButton1Down:Connect(function()
	logs:TweenPosition(UDim2.new(0, 0, 1, 10), "InOut", "Quart", 0.3, true, nil)
end)

Hide.MouseButton1Down:Connect(function()
	if logs.Position ~= UDim2.new(0, 0, 1, -20) then
		logs:TweenPosition(UDim2.new(0, 0, 1, -20), "InOut", "Quart", 0.3, true, nil)
	else
		logs:TweenPosition(UDim2.new(0, 0, 1, -265), "InOut", "Quart", 0.3, true, nil)
	end
end)

EventBind.MouseButton1Click:Connect(function()
	eventEditor.Frame:TweenPosition(UDim2.new(0.5,-175,0.5,-101), "InOut", "Quart", 0.5, true, nil)
end)

Keybinds.MouseButton1Click:Connect(function()
	KeybindsFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quart", 0.5, true, nil)
	wait(0.5)
	SettingsHolder.Visible = false
end)

Close.MouseButton1Click:Connect(function()
	SettingsHolder.Visible = true
	KeybindsFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
end)

Keybinds.MouseButton1Click:Connect(function()
	KeybindsFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quart", 0.5, true, nil)
	wait(0.5)
	SettingsHolder.Visible = false
end)

Add.MouseButton1Click:Connect(function()
	KeybindEditor:TweenPosition(UDim2.new(0.5, -180, 0, 260), "InOut", "Quart", 0.5, true, nil)
end)

Delete.MouseButton1Click:Connect(function()
	binds = {}
	refreshbinds()
	updatesaves()
	notify('Keybinds Updated','Removed all keybinds')
end)

Close_2.MouseButton1Click:Connect(function()
	SettingsHolder.Visible = true
	AliasesFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
end)

Aliases.MouseButton1Click:Connect(function()
	AliasesFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quart", 0.5, true, nil)
	wait(0.5)
	SettingsHolder.Visible = false
end)

Close_3.MouseButton1Click:Connect(function()
	SettingsHolder.Visible = true
	PositionsFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
end)

Positions.MouseButton1Click:Connect(function()
	PositionsFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quart", 0.5, true, nil)
	wait(0.5)
	SettingsHolder.Visible = false
end)

local selectionBox = Instance.new("SelectionBox")
selectionBox.Name = randomString()
selectionBox.Color3 = Color3.new(255,255,255)
selectionBox.Adornee = nil
selectionBox.Parent = PARENT

local selected = Instance.new("SelectionBox")
selected.Name = randomString()
selected.Color3 = Color3.new(0,166,0)
selected.Adornee = nil
selected.Parent = PARENT

local ActivateHighlight = nil
local ClickSelect = nil
function selectPart()
	ToPartFrame:TweenPosition(UDim2.new(0.5, -180, 0, 335), "InOut", "Quart", 0.5, true, nil)
	local function HighlightPart()
		if selected.Adornee ~= IYMouse.Target then
			selectionBox.Adornee = IYMouse.Target
		else
			selectionBox.Adornee = nil
		end
	end
	ActivateHighlight = IYMouse.Move:Connect(HighlightPart)
	local function SelectPart()
		if IYMouse.Target ~= nil then
			selected.Adornee = IYMouse.Target
			Path.Text = getHierarchy(IYMouse.Target)
		end
	end
	ClickSelect = IYMouse.Button1Down:Connect(SelectPart)
end

Part.MouseButton1Click:Connect(function()
	selectPart()
end)

Exit_4.MouseButton1Click:Connect(function()
	ToPartFrame:TweenPosition(UDim2.new(0.5, -180, 0, -500), "InOut", "Quart", 0.5, true, nil)
	if ActivateHighlight then
		ActivateHighlight:Disconnect()
	end
	if ClickSelect then
		ClickSelect:Disconnect()
	end
	selectionBox.Adornee = nil
	selected.Adornee = nil
	Path.Text = ""
end)

CopyPath.MouseButton1Click:Connect(function()
	if Path.Text ~= "" then
		toClipboard(Path.Text)
	else
		notify('Copy Path','Select a part to copy its path')
	end
end)

ChoosePart.MouseButton1Click:Connect(function()
	if Path.Text ~= "" then
		local tpNameExt = ''
		local function handleWpNames()
			local FoundDupe = false
			for i,v in pairs(pWayPoints) do
				if v.NAME:lower() == selected.Adornee.Name:lower()..tpNameExt then
					FoundDupe = true
				end
			end
			if not FoundDupe then
				notify('Modified Waypoints',"Created waypoint: "..selected.Adornee.Name..tpNameExt)
				pWayPoints[#pWayPoints + 1] = {NAME = selected.Adornee.Name..tpNameExt, COORD = {selected.Adornee}}
			else
				if isNumber(tpNameExt) then
					tpNameExt = tpNameExt+1
				else
					tpNameExt = 1
				end
				handleWpNames()
			end
		end
		handleWpNames()
		refreshwaypoints()
	else
		notify('Part Selection','Select a part first')
	end
end)

cmds={}
customAlias = {}
Delete_3.MouseButton1Click:Connect(function()
	customAlias = {}
	aliases = {}
	notify('Aliases Modified','Removed all aliases')
	updatesaves()
	refreshaliases()
end)

PrefixBox:GetPropertyChangedSignal("Text"):Connect(function()
	prefix = PrefixBox.Text
	Cmdbar.PlaceholderText = "Command Bar ("..prefix..")"
	updatesaves()
end)

function CamViewport()
	if workspace.CurrentCamera then
		return workspace.CurrentCamera.ViewportSize.X
	end
end

function UpdateToViewport()
	if Holder.Position.X.Offset < -CamViewport() then
		Holder:TweenPosition(UDim2.new(1, -CamViewport(), Holder.Position.Y.Scale, Holder.Position.Y.Offset), "InOut", "Quart", 0.04, true, nil)
		Notification:TweenPosition(UDim2.new(1, -CamViewport() + 250, Notification.Position.Y.Scale, Notification.Position.Y.Offset), "InOut", "Quart", 0.04, true, nil)
	end
end
CameraChanged = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateToViewport)

function updateCamera(child, parent)
	if parent ~= workspace then
		CamMoved:Disconnect()
		CameraChanged:Disconnect()
		repeat wait() until workspace.CurrentCamera
		CameraChanged = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateToViewport)
		CamMoved = workspace.CurrentCamera.AncestryChanged:Connect(updateCamera)
	end
end
CamMoved = workspace.CurrentCamera.AncestryChanged:Connect(updateCamera)

function dragMain(dragpoint,gui)
	task.spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local pos = -250
			local delta = input.Position - dragStart
			if startPos.X.Offset + delta.X <= -500 then
				local Position = UDim2.new(1, -250, Notification.Position.Y.Scale, Notification.Position.Y.Offset)
				TweenService:Create(Notification, TweenInfo.new(.20), {Position = Position}):Play()
				pos = 250
			else
				local Position = UDim2.new(1, -500, Notification.Position.Y.Scale, Notification.Position.Y.Offset)
				TweenService:Create(Notification, TweenInfo.new(.20), {Position = Position}):Play()
				pos = -250
			end
			if startPos.X.Offset + delta.X <= -250 and -CamViewport() <= startPos.X.Offset + delta.X then
				local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, gui.Position.Y.Scale, gui.Position.Y.Offset)
				TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
				local Position2 = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X + pos, Notification.Position.Y.Scale, Notification.Position.Y.Offset)
				TweenService:Create(Notification, TweenInfo.new(.20), {Position = Position2}):Play()
			elseif startPos.X.Offset + delta.X > -500 then
				local Position = UDim2.new(1, -250, gui.Position.Y.Scale, gui.Position.Y.Offset)
				TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
			elseif -CamViewport() > startPos.X.Offset + delta.X then
				gui:TweenPosition(UDim2.new(1, -CamViewport(), gui.Position.Y.Scale, gui.Position.Y.Offset), "InOut", "Quart", 0.04, true, nil)
				local Position = UDim2.new(1, -CamViewport(), gui.Position.Y.Scale, gui.Position.Y.Offset)
				TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
				local Position2 = UDim2.new(1, -CamViewport() + 250, Notification.Position.Y.Scale, Notification.Position.Y.Offset)
				TweenService:Create(Notification, TweenInfo.new(.20), {Position = Position2}):Play()
			end
		end
		dragpoint.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		dragpoint.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

dragMain(Title,Holder)

Match = function(name,str)
	str = str:gsub("%W", "%%%1")
	return name:lower():find(str:lower()) and true
end

local canvasPos = Vector2.new(0,0)
local topCommand = nil
IndexContents = function(str,bool,cmdbar,Ianim)
	CMDsF.CanvasPosition = Vector2.new(0,0)
	local SizeY = 0
	local indexnum = 0
	local frame = CMDsF
	topCommand = nil
	local chunks = {}
	if str:sub(#str,#str) == "\\" then str = "" end
	for w in string.gmatch(str,"[^\\]+") do
		table.insert(chunks,w)
	end
	if #chunks > 0 then str = chunks[#chunks] end
	if str:sub(1,1) == "!" then str = str:sub(2) end
	for i,v in next, frame:GetChildren() do
		if v:IsA("TextButton") then
			if bool then
				if Match(v.Text,str) then
					indexnum = indexnum + 1
					v.Visible = true
					if topCommand == nil then
						topCommand = v.Text
					end
				else
					v.Visible = false
				end
			else
				v.Visible = true
				if topCommand == nil then
					topCommand = v.Text
				end
			end
		end
	end
	frame.CanvasSize = UDim2.new(0,0,0,cmdListLayout.AbsoluteContentSize.Y)
	if not Ianim then
		if indexnum == 0 or string.find(str, " ") then
			if not cmdbar then
				minimizeHolder()
			elseif cmdbar then
				cmdbarHolder()
			end
		else
			maximizeHolder()
		end
	else
		minimizeHolder()
	end
end

task.spawn(function()
	if not isLegacyChat then return end
	local chatbox
	local success, result = pcall(function() chatbox = PlayerGui:WaitForChild("Chat").Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar end)
	if success then
		local function chatboxFocused()
			canvasPos = CMDsF.CanvasPosition
		end
		local chatboxFocusedC = chatbox.Focused:Connect(chatboxFocused)

		local function Index()
			if chatbox.Text:lower():sub(1,1) == prefix then
				if SettingsOpen == true then
					wait(0.2)
					CMDsF.Visible = true
					Settings:TweenPosition(UDim2.new(0, 0, 0, 220), "InOut", "Quart", 0.2, true, nil)
				end
				IndexContents(PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.Text:lower():sub(2),true)
			else
				minimizeHolder()
				if SettingsOpen == true then
					wait(0.2)
					Settings:TweenPosition(UDim2.new(0, 0, 0, 45), "InOut", "Quart", 0.2, true, nil)
					CMDsF.Visible = false
				end
			end
		end
		local chatboxFunc = chatbox:GetPropertyChangedSignal("Text"):Connect(Index)

		local function chatboxFocusLost(enterpressed)
			if not enterpressed or chatbox.Text:lower():sub(1,1) ~= prefix then
				IndexContents('',true)
			end
			CMDsF.CanvasPosition = canvasPos
			minimizeHolder()
		end
		local chatboxFocusLostC = chatbox.FocusLost:Connect(chatboxFocusLost)

		PlayerGui:WaitForChild("Chat").Frame.ChatBarParentFrame.ChildAdded:Connect(function(newbar)
			wait()
			if newbar:FindFirstChild('BoxFrame') then
				chatbox = PlayerGui:WaitForChild("Chat").Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
				if chatboxFocusedC then chatboxFocusedC:Disconnect() end
				chatboxFocusedC = chatbox.Focused:Connect(chatboxFocused)
				if chatboxFunc then chatboxFunc:Disconnect() end
				chatboxFunc = chatbox:GetPropertyChangedSignal("Text"):Connect(Index)
				if chatboxFocusLostC then chatboxFocusLostC:Disconnect() end
				chatboxFocusLostC = chatbox.FocusLost:Connect(chatboxFocusLost)
			end
		end)
		--else
		--print('Custom chat detected. Will not provide suggestions for commands typed in the chat.')
	end
end)

function autoComplete(str,curText)
	local endingChar = {"[", "/", "(", " "}
	local stop = 0
	for i=1,#str do
		local c = str:sub(i,i)
		if table.find(endingChar, c) then
			stop = i
			break
		end
	end
	curText = curText or Cmdbar.Text
	local subPos = 0
	local pos = 1
	local findRes = string.find(curText,"\\",pos)
	while findRes do
		subPos = findRes
		pos = findRes+1
		findRes = string.find(curText,"\\",pos)
	end
	if curText:sub(subPos+1,subPos+1) == "!" then subPos = subPos + 1 end
	Cmdbar.Text = curText:sub(1,subPos) .. str:sub(1, stop - 1)..' '
	RunService.RenderStepped:Wait()
	Cmdbar.Text = Cmdbar.Text:gsub( '\t', '' )
	Cmdbar.CursorPosition = #Cmdbar.Text+1--1020
end

CMDs = {}
CMDs[#CMDs + 1] = {NAME = 'discord / support / help', DESC = 'Invite to the Infinite Yield support server.'}
CMDs[#CMDs + 1] = {NAME = 'guiscale [number]', DESC = 'Changes the size of the gui. [number] accepts both decimals and whole numbers. Min is 0.4 and Max is 2'}
CMDs[#CMDs + 1] = {NAME = 'console', DESC = 'Loads Roblox console'}
CMDs[#CMDs + 1] = {NAME = 'oldconsole', DESC = 'Loads old Roblox console'}
CMDs[#CMDs + 1] = {NAME = 'explorer / dex', DESC = 'Opens DEX by Moon'}
CMDs[#CMDs + 1] = {NAME = 'olddex / odex', DESC = 'Opens Old DEX by Moon'}
CMDs[#CMDs + 1] = {NAME = 'remotespy / rspy', DESC = 'Opens Simple Spy V3'}
CMDs[#CMDs + 1] = {NAME = 'audiologger / alogger', DESC = 'Opens Edges audio logger'}
CMDs[#CMDs + 1] = {NAME = 'serverinfo / info', DESC = 'Gives you info about the server'}
CMDs[#CMDs + 1] = {NAME = 'jobid', DESC = 'Copies the games JobId to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'notifyjobid', DESC = 'Notifies you the games JobId'}
CMDs[#CMDs + 1] = {NAME = 'rejoin / rj', DESC = 'Makes you rejoin the game'}
CMDs[#CMDs + 1] = {NAME = 'autorejoin / autorj', DESC = 'Automatically rejoins the server if you get kicked/disconnected'}
CMDs[#CMDs + 1] = {NAME = 'serverhop / shop', DESC = 'Teleports you to a different server'}
CMDs[#CMDs + 1] = {NAME = 'gameteleport / gametp [place ID]', DESC = 'Joins a game by ID'}
CMDs[#CMDs + 1] = {NAME = 'antiidle / antiafk', DESC = 'Prevents the game from kicking you for being idle/afk'}
CMDs[#CMDs + 1] = {NAME = 'datalimit [num]', DESC = 'Set outgoing KBPS limit'}
CMDs[#CMDs + 1] = {NAME = 'replicationlag / backtrack [num]', DESC = 'Set IncomingReplicationLag'}
CMDs[#CMDs + 1] = {NAME = 'creatorid / creator', DESC = 'Notifies you the creators ID'}
CMDs[#CMDs + 1] = {NAME = 'copycreatorid / copycreator', DESC = 'Copies the creators ID to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'setcreatorid / setcreator', DESC = 'Sets your userid to the creators ID'}
CMDs[#CMDs + 1] = {NAME = 'noprompts', DESC = 'Prevents the game from showing you purchase/premium prompts'}
CMDs[#CMDs + 1] = {NAME = 'showprompts', DESC = 'Allows the game to show purchase/premium prompts again'}
CMDs[#CMDs + 1] = {NAME = 'enable [inventory/playerlist/chat/reset/emotes/all]', DESC = 'Toggles visibility of coregui items'}
CMDs[#CMDs + 1] = {NAME = 'disable [inventory/playerlist/chat/reset/emotes/all]', DESC = 'Toggles visibility of coregui items'}
CMDs[#CMDs + 1] = {NAME = 'showguis', DESC = 'Shows any invisible GUIs'}
CMDs[#CMDs + 1] = {NAME = 'unshowguis', DESC = 'Undoes showguis'}
CMDs[#CMDs + 1] = {NAME = 'hideguis', DESC = 'Hides any GUIs in PlayerGui'}
CMDs[#CMDs + 1] = {NAME = 'unhideguis', DESC = 'Undoes hideguis'}
CMDs[#CMDs + 1] = {NAME = 'guidelete', DESC = 'Enables backspace to delete GUI'}
CMDs[#CMDs + 1] = {NAME = 'unguidelete / noguidelete', DESC = 'Disables guidelete'}
CMDs[#CMDs + 1] = {NAME = 'hideiy', DESC = 'Hides the main IY GUI'}
CMDs[#CMDs + 1] = {NAME = 'showiy / unhideiy', DESC = 'Shows IY again'}
CMDs[#CMDs + 1] = {NAME = 'keepiy', DESC = 'Auto execute IY when you teleport through servers'}
CMDs[#CMDs + 1] = {NAME = 'unkeepiy', DESC = 'Disable keepiy'}
CMDs[#CMDs + 1] = {NAME = 'togglekeepiy', DESC = 'Toggle keepiy'}
CMDs[#CMDs + 1] = {NAME = 'savegame / saveplace', DESC = 'Uses saveinstance to save the game'}
CMDs[#CMDs + 1] = {NAME = 'clearerror', DESC = 'Clears the annoying box and blur when a game kicks you'}
CMDs[#CMDs + 1] = {NAME = 'clientantikick / antikick (CLIENT)', DESC = 'Prevents localscripts from kicking you'}
CMDs[#CMDs + 1] = {NAME = 'clientantiteleport / antiteleport (CLIENT)', DESC = 'Prevents localscripts from teleporting you'}
CMDs[#CMDs + 1] = {NAME = 'allowrejoin / allowrj [true/false] (CLIENT)', DESC = 'Changes if antiteleport allows you to rejoin or not'}
CMDs[#CMDs + 1] = {NAME = 'cancelteleport / canceltp', DESC = 'Cancels teleports in progress'}
CMDs[#CMDs + 1] = {NAME = 'volume / vol [0-10]', DESC = 'Adjusts your game volume on a scale of 0 to 10'}
CMDs[#CMDs + 1] = {NAME = 'antilag / boostfps / lowgraphics', DESC = 'Lowers game quality to boost FPS'}
CMDs[#CMDs + 1] = {NAME = 'record / rec', DESC = 'Starts roblox recorder'}
CMDs[#CMDs + 1] = {NAME = 'screenshot / scrnshot', DESC = 'Takes a screenshot'}
CMDs[#CMDs + 1] = {NAME = 'togglefullscreen / togglefs', DESC = 'Toggles fullscreen'}
CMDs[#CMDs + 1] = {NAME = 'notify [text]', DESC = 'Sends you a notification with the provided text'}
CMDs[#CMDs + 1] = {NAME = 'lastcommand / lastcmd', DESC = 'Executes the previous command used'}
CMDs[#CMDs + 1] = {NAME = 'exit', DESC = 'Kills roblox process'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'noclip', DESC = 'Go through objects'}
CMDs[#CMDs + 1] = {NAME = 'unnoclip / clip', DESC = 'Disables noclip'}
CMDs[#CMDs + 1] = {NAME = 'fly [speed]', DESC = 'Makes you fly'}
CMDs[#CMDs + 1] = {NAME = 'unfly', DESC = 'Disables fly'}
CMDs[#CMDs + 1] = {NAME = 'flyspeed [num]', DESC = 'Set fly speed (default is 20)'}
CMDs[#CMDs + 1] = {NAME = 'vehiclefly / vfly [speed]', DESC = 'Makes you fly in a vehicle'}
CMDs[#CMDs + 1] = {NAME = 'unvehiclefly / unvfly', DESC = 'Disables vehicle fly'}
CMDs[#CMDs + 1] = {NAME = 'vehicleflyspeed  / vflyspeed [num]', DESC = 'Set vehicle fly speed'}
CMDs[#CMDs + 1] = {NAME = 'cframefly / cfly [speed]', DESC = 'Makes you fly, bypassing some anti cheats (works on mobile)'}
CMDs[#CMDs + 1] = {NAME = 'uncframefly / uncfly', DESC = 'Disables cfly'}
CMDs[#CMDs + 1] = {NAME = 'cframeflyspeed  / cflyspeed [num]', DESC = 'Sets cfly speed'}
CMDs[#CMDs + 1] = {NAME = 'qefly [true / false]', DESC = 'enables or disables the Q and E hotkeys for fly'}
CMDs[#CMDs + 1] = {NAME = 'vehiclenoclip / vnoclip', DESC = 'Turns off vehicle collision'}
CMDs[#CMDs + 1] = {NAME = 'vehicleclip / vclip / unvnoclip', DESC = 'Enables vehicle collision'}
CMDs[#CMDs + 1] = {NAME = 'float /  platform', DESC = 'Spawns a platform beneath you causing you to float'}
CMDs[#CMDs + 1] = {NAME = 'unfloat / noplatform', DESC = 'Removes the platform'}
CMDs[#CMDs + 1] = {NAME = 'swim', DESC = 'Allows you to swim in the air'}
CMDs[#CMDs + 1] = {NAME = 'unswim / noswim', DESC = 'Stops you from swimming everywhere'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'setwaypoint / swp [name]', DESC = 'Sets a waypoint at your position'}
CMDs[#CMDs + 1] = {NAME = 'waypointpos / wpp [name] [X Y Z]', DESC = 'Sets a waypoint with specified coordinates'}
CMDs[#CMDs + 1] = {NAME = 'waypoints', DESC = 'Shows a list of currently active waypoints'}
CMDs[#CMDs + 1] = {NAME = 'showwaypoints / showwp', DESC = 'Shows all currently set waypoints'}
CMDs[#CMDs + 1] = {NAME = 'hidewaypoints / hidewp', DESC = 'Hides shown waypoints'}
CMDs[#CMDs + 1] = {NAME = 'waypoint / wp [name]', DESC = 'Teleports player to a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'tweenwaypoint / twp [name]', DESC = 'Tweens player to a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'walktowaypoint / wtwp [name]', DESC = 'Walks player to a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'deletewaypoint / dwp [name]', DESC = 'Deletes a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'clearwaypoints / cwp', DESC = 'Clears all waypoints'}
CMDs[#CMDs + 1] = {NAME = 'cleargamewaypoints / cgamewp', DESC = 'Clears all waypoints for the game you are in'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'goto [player]', DESC = 'Go to a player'}
CMDs[#CMDs + 1] = {NAME = 'tweengoto / tgoto [player]', DESC = 'Tween to a player (bypasses some anti cheats)'}
CMDs[#CMDs + 1] = {NAME = 'tweenspeed / tspeed [num]', DESC = 'Sets how fast all tween commands go (default is 1)'}
CMDs[#CMDs + 1] = {NAME = 'vehiclegoto / vgoto [player]', DESC = 'Go to a player while in a vehicle'}
CMDs[#CMDs + 1] = {NAME = 'loopgoto [player] [distance] [delay]', DESC = 'Loop teleport to a player'}
CMDs[#CMDs + 1] = {NAME = 'unloopgoto', DESC = 'Stops teleporting you to a player'}
CMDs[#CMDs + 1] = {NAME = 'pulsetp / ptp [player] [seconds]', DESC = 'Teleports you to a player for a specified amount of time'}
CMDs[#CMDs + 1] = {NAME = 'clientbring / cbring [player] (CLIENT)', DESC = 'Bring a player'}
CMDs[#CMDs + 1] = {NAME = 'loopbring [player] [distance] [delay] (CLIENT)', DESC = 'Loop brings a player to you (useful for killing)'}
CMDs[#CMDs + 1] = {NAME = 'unloopbring [player]', DESC = 'Undoes loopbring'}
CMDs[#CMDs + 1] = {NAME = 'freeze / fr [player] (CLIENT)', DESC = 'Freezes a player'}
CMDs[#CMDs + 1] = {NAME = 'freezeanims', DESC = 'Freezes your animations / pauses your animations - Does not work on default animations'}
CMDs[#CMDs + 1] = {NAME = 'unfreezeanims', DESC = 'Unfreezes your animations / plays your animations'}
CMDs[#CMDs + 1] = {NAME = 'thaw / unfr [player] (CLIENT)', DESC = 'Unfreezes a player'}
CMDs[#CMDs + 1] = {NAME = 'tpposition / tppos [X Y Z]', DESC = 'Teleports you to certain coordinates'}
CMDs[#CMDs + 1] = {NAME = 'tweentpposition / ttppos [X Y Z]', DESC = 'Tween to coordinates (bypasses some anti cheats)'}
CMDs[#CMDs + 1] = {NAME = 'offset [X Y Z]', DESC = 'Offsets you by certain coordinates'}
CMDs[#CMDs + 1] = {NAME = 'tweenoffset / toffset [X Y Z]', DESC = 'Tween offset (bypasses some anti cheats)'}
CMDs[#CMDs + 1] = {NAME = 'notifyposition / notifypos [player]', DESC = 'Notifies you the coordinates of a character'}
CMDs[#CMDs + 1] = {NAME = 'copyposition / copypos [player]', DESC = 'Copies the coordinates of a character to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'walktoposition / walktopos [X Y Z]', DESC = 'Makes you walk to a coordinate'}
CMDs[#CMDs + 1] = {NAME = 'spawnpoint / spawn [delay]', DESC = 'Sets a position where you will spawn'}
CMDs[#CMDs + 1] = {NAME = 'nospawnpoint / nospawn', DESC = 'Removes your custom spawn point'}
CMDs[#CMDs + 1] = {NAME = 'flashback / diedtp', DESC = 'Teleports you to where you last died'}
CMDs[#CMDs + 1] = {NAME = 'walltp', DESC = 'Teleports you above/over any wall you run into'}
CMDs[#CMDs + 1] = {NAME = 'nowalltp / unwalltp', DESC = 'Disables walltp'}
CMDs[#CMDs + 1] = {NAME = 'teleporttool / tptool', DESC = 'Gives you a teleport tool'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'logs', DESC = 'Opens the logs GUI'}
CMDs[#CMDs + 1] = {NAME = 'chatlogs / clogs', DESC = 'Log what people say or whisper'}
CMDs[#CMDs + 1] = {NAME = 'joinlogs / jlogs', DESC = 'Log when people join'}
CMDs[#CMDs + 1] = {NAME = 'chatlogswebhook / logswebhook [url]', DESC = 'Set a discord webhook for chatlogs to go to (provide no url to disable this)'}
CMDs[#CMDs + 1] = {NAME = 'antichatlogs / antichatlogger', DESC = 'Prevents Roblox from banning you for your silly chat messages (game needs the legacy chat)'}
CMDs[#CMDs + 1] = {NAME = 'chat / say [text]', DESC = 'Makes you chat a string (possible mute bypass)'}
CMDs[#CMDs + 1] = {NAME = 'spam [text]', DESC = 'Makes you spam the chat'}
CMDs[#CMDs + 1] = {NAME = 'unspam', DESC = 'Turns off spam'}
CMDs[#CMDs + 1] = {NAME = 'whisper / pm [player] [text]', DESC = 'Makes you whisper a string to someone (possible mute bypass)'}
CMDs[#CMDs + 1] = {NAME = 'pmspam [player] [text]', DESC = 'Makes you spam a players whispers'}
CMDs[#CMDs + 1] = {NAME = 'unpmspam [player]', DESC = 'Turns off pm spam'}
CMDs[#CMDs + 1] = {NAME = 'spamspeed [num]', DESC = 'How quickly you spam (default is 1)'}
CMDs[#CMDs + 1] = {NAME = 'bubblechat (CLIENT)', DESC = 'Enables bubble chat for your client'}
CMDs[#CMDs + 1] = {NAME = 'unbubblechat / nobubblechat', DESC = 'Disables the bubblechat command'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'esp', DESC = 'View all players and their status'}
CMDs[#CMDs + 1] = {NAME = 'espteam', DESC = 'Esp but teammates are green and bad guys are red'}
CMDs[#CMDs + 1] = {NAME = 'noesp / unesp / unespteam', DESC = 'Removes esp'}
CMDs[#CMDs + 1] = {NAME = 'esptransparency [number]', DESC = 'Changes the transparency of esp related commands'}
CMDs[#CMDs + 1] = {NAME = 'partesp [part name]', DESC = 'Highlights a part'}
CMDs[#CMDs + 1] = {NAME = 'unpartesp / nopartesp [part name]', DESC = 'removes partesp'}
CMDs[#CMDs + 1] = {NAME = 'chams', DESC = 'ESP but without text in the way'}
CMDs[#CMDs + 1] = {NAME = 'nochams / unchams', DESC = 'Removes chams'}
CMDs[#CMDs + 1] = {NAME = 'locate [player]', DESC = 'View a single player and their status'}
CMDs[#CMDs + 1] = {NAME = 'unlocate / nolocate [player]', DESC = 'Removes locate'}
CMDs[#CMDs + 1] = {NAME = 'xray', DESC = 'Makes all parts in workspace transparent'}
CMDs[#CMDs + 1] = {NAME = 'unxray / noxray', DESC = 'Restores transparency'}
CMDs[#CMDs + 1] = {NAME = 'loopxray', DESC = 'Makes all parts in workspace transparent but looped'}
CMDs[#CMDs + 1] = {NAME = 'unloopunxray', DESC = 'Unloops xray'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'spectate / view [player]', DESC = 'View a player'}
CMDs[#CMDs + 1] = {NAME = 'viewpart / viewp [part name]', DESC = 'View a part'}
CMDs[#CMDs + 1] = {NAME = 'unspectate / unview', DESC = 'Stops viewing player'}
CMDs[#CMDs + 1] = {NAME = 'freecam / fc', DESC = 'Allows you to freely move camera around the game'}
CMDs[#CMDs + 1] = {NAME = 'freecampos / fcpos [X Y Z]', DESC = 'Moves / opens freecam in a certain position'}
CMDs[#CMDs + 1] = {NAME = 'freecamwaypoint / fcwp [name]', DESC = 'Moves / opens freecam to a waypoint'}
CMDs[#CMDs + 1] = {NAME = 'freecamgoto / fcgoto / fctp [player]', DESC = 'Moves / opens freecam to a player'}
CMDs[#CMDs + 1] = {NAME = 'unfreecam / unfc', DESC = 'Disables freecam'}
CMDs[#CMDs + 1] = {NAME = 'freecamspeed / fcspeed [num]', DESC = 'Adjusts freecam speed (default is 1)'}
CMDs[#CMDs + 1] = {NAME = 'notifyfreecamposition / notifyfcpos', DESC = 'Noitifies you your freecam coordinates'}
CMDs[#CMDs + 1] = {NAME = 'copyfreecamposition / copyfcpos', DESC = 'Copies your freecam coordinates to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'gotocamera / gotocam', DESC = 'Teleports you to the location of your camera'}
CMDs[#CMDs + 1] = {NAME = 'tweengotocam / tgotocam', DESC = 'Tweens you to the location of your camera'}
CMDs[#CMDs + 1] = {NAME = 'firstp', DESC = 'Forces camera to go into first person'}
CMDs[#CMDs + 1] = {NAME = 'thirdp', DESC = 'Allows camera to go into third person'}
CMDs[#CMDs + 1] = {NAME = 'noclipcam / nccam', DESC = 'Allows camera to go through objects like walls'}
CMDs[#CMDs + 1] = {NAME = 'maxzoom [num]', DESC = 'Maximum camera zoom'}
CMDs[#CMDs + 1] = {NAME = 'minzoom [num]', DESC = 'Minimum camera zoom'}
CMDs[#CMDs + 1] = {NAME = 'camdistance [num]', DESC = 'Changes camera distance from your player'}
CMDs[#CMDs + 1] = {NAME = 'fov [num]', DESC = 'Adjusts field of view (default is 70)'}
CMDs[#CMDs + 1] = {NAME = 'fixcam / restorecam', DESC = 'Fixes camera'}
CMDs[#CMDs + 1] = {NAME = 'enableshiftlock / enablesl', DESC = 'Enables the shift lock option'}
CMDs[#CMDs + 1] = {NAME = 'lookat [player]', DESC = 'Moves your camera view to a player'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'btools (CLIENT)', DESC = 'Gives you building tools (DOES NOT REPLICATE)'}
CMDs[#CMDs + 1] = {NAME = 'f3x (CLIENT)', DESC = 'Gives you F3X building tools (DOES NOT REPLICATE)'}
CMDs[#CMDs + 1] = {NAME = 'partname / partpath', DESC = 'Allows you to click a part to see its path & name'}
CMDs[#CMDs + 1] = {NAME = 'delete [instance name] (CLIENT)', DESC = 'Removes any part with a certain name from the workspace (DOES NOT REPLICATE)'}
CMDs[#CMDs + 1] = {NAME = 'deleteclass / dc [class name] (CLIENT)', DESC = 'Removes any part with a certain classname from the workspace (DOES NOT REPLICATE)'}
CMDs[#CMDs + 1] = {NAME = 'lockworkspace / lockws', DESC = 'Locks the whole workspace'}
CMDs[#CMDs + 1] = {NAME = 'unlockworkspace / unlockws', DESC = 'Unlocks the whole workspace'}
CMDs[#CMDs + 1] = {NAME = 'invisibleparts / invisparts (CLIENT)', DESC = 'Shows invisible parts'}
CMDs[#CMDs + 1] = {NAME = 'uninvisibleparts / uninvisparts (CLIENT)', DESC = 'Makes parts affected by invisparts return to normal'}
CMDs[#CMDs + 1] = {NAME = 'deleteinvisparts / dip (CLIENT)', DESC = 'Deletes invisible parts'}
CMDs[#CMDs + 1] = {NAME = 'gotopart [part name]', DESC = 'Moves your character to a part or multiple parts'}
CMDs[#CMDs + 1] = {NAME = 'tweengotopart / tgotopart [part name]', DESC = 'Tweens your character to a part or multiple parts'}
CMDs[#CMDs + 1] = {NAME = 'gotopartclass / gpc [class name]', DESC = 'Moves your character to a part or multiple parts based on classname'}
CMDs[#CMDs + 1] = {NAME = 'tweengotopartclass / tgpc [class name]', DESC = 'Tweens your character to a part or multiple parts based on classname'}
CMDs[#CMDs + 1] = {NAME = 'gotomodel [part name]', DESC = 'Moves your character to a model or multiple models'}
CMDs[#CMDs + 1] = {NAME = 'tweengotomodel / tgotomodel [part name]', DESC = 'Tweens your character to a model or multiple models'}
CMDs[#CMDs + 1] = {NAME = 'gotopartdelay / gotomodeldelay [num]', DESC = 'Adjusts how quickly you teleport to each part (default is 0.1)'}
CMDs[#CMDs + 1] = {NAME = 'bringpart [part name] (CLIENT)', DESC = 'Moves a part or multiple parts to your character'}
CMDs[#CMDs + 1] = {NAME = 'bringpartclass / bpc [class name] (CLIENT)', DESC = 'Moves a part or multiple parts to your character based on classname'}
CMDs[#CMDs + 1] = {NAME = 'noclickdetectorlimits / nocdlimits', DESC = 'Sets all click detectors MaxActivationDistance to math.huge'}
CMDs[#CMDs + 1] = {NAME = 'fireclickdetectors / firecd [name]', DESC = 'Uses all click detectors in a game or uses the optional name'}
CMDs[#CMDs + 1] = {NAME = 'firetouchinterests / touchinterests [name]', DESC = 'Uses all touchinterests in a game or uses the optional name'}
CMDs[#CMDs + 1] = {NAME = 'noproximitypromptlimits / nopplimits', DESC = 'Sets all proximity prompts MaxActivationDistance to math.huge'}
CMDs[#CMDs + 1] = {NAME = 'fireproximityprompts / firepp [name]', DESC = 'Uses all proximity prompts in a game or uses the optional name'}
CMDs[#CMDs + 1] = {NAME = 'instantproximityprompts / instantpp', DESC = 'Disable the cooldown for proximity prompts'}
CMDs[#CMDs + 1] = {NAME = 'uninstantproximityprompts / uninstantpp', DESC = 'Undo the cooldown removal'}
CMDs[#CMDs + 1] = {NAME = 'tpunanchored / tpua [player]', DESC = 'Teleports unanchored parts to a player'}
CMDs[#CMDs + 1] = {NAME = 'animsunanchored / freezeua', DESC = 'Freezes unanchored parts'}
CMDs[#CMDs + 1] = {NAME = 'thawunanchored / thawua / unfreezeua', DESC = 'Thaws unanchored parts'}
CMDs[#CMDs + 1] = {NAME = 'removeterrain / rterrain / noterrain', DESC = 'Removes all terrain'}
CMDs[#CMDs + 1] = {NAME = 'clearnilinstances / nonilinstances / cni', DESC = 'Removes nil instances'}
CMDs[#CMDs + 1] = {NAME = 'destroyheight / dh [num]', DESC = 'Sets FallenPartsDestroyHeight'}
CMDs[#CMDs + 1] = {NAME = 'fakeout', DESC = 'Tp to the void and then back (useful to kill people attached to you)'}
CMDs[#CMDs + 1] = {NAME = 'antivoid', DESC = 'Prevents you from falling into the void by launching you upwards'}
CMDs[#CMDs + 1] = {NAME = 'unantivoid / noantivoid', DESC = 'Disables antivoid'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'fullbright / fb (CLIENT)', DESC = 'Makes the map brighter / more visible'}
CMDs[#CMDs + 1] = {NAME = 'loopfullbright / loopfb (CLIENT)', DESC = 'Makes the map brighter / more visible but looped'}
CMDs[#CMDs + 1] = {NAME = 'unloopfullbright / unloopfb', DESC = 'Unloops fullbright'}
CMDs[#CMDs + 1] = {NAME = 'ambient [num] [num] [num] (CLIENT)', DESC = 'Changes ambient'}
CMDs[#CMDs + 1] = {NAME = 'day (CLIENT)', DESC = 'Changes the time to day for the client'}
CMDs[#CMDs + 1] = {NAME = 'night (CLIENT)', DESC = 'Changes the time to night for the client'}
CMDs[#CMDs + 1] = {NAME = 'nofog (CLIENT)', DESC = 'Removes fog'}
CMDs[#CMDs + 1] = {NAME = 'brightness [num] (CLIENT)', DESC = 'Changes the brightness lighting property'}
CMDs[#CMDs + 1] = {NAME = 'globalshadows / gshadows (CLIENT)', DESC = 'Enables global shadows'}
CMDs[#CMDs + 1] = {NAME = 'noglobalshadows / nogshadows (CLIENT)', DESC = 'Disables global shadows'}
CMDs[#CMDs + 1] = {NAME = 'restorelighting / rlighting', DESC = 'Restores Lighting properties'}
CMDs[#CMDs + 1] = {NAME = 'light [radius] [brightness] (CLIENT)', DESC = 'Gives your player dynamic light'}
CMDs[#CMDs + 1] = {NAME = 'nolight / unlight', DESC = 'Removes dynamic light from your player'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'inspect / examine [player]', DESC = 'Opens InspectMenu for a certain player'}
CMDs[#CMDs + 1] = {NAME = 'age [player]', DESC = 'Tells you the age of a player'}
CMDs[#CMDs + 1] = {NAME = 'chatage [player]', DESC = 'Chats the age of a player'}
CMDs[#CMDs + 1] = {NAME = 'joindate / jd [player]', DESC = 'Tells you the date the player joined Roblox'}
CMDs[#CMDs + 1] = {NAME = 'chatjoindate / cjd [player]', DESC = 'Chats the date the player joined Roblox'}
CMDs[#CMDs + 1] = {NAME = 'copyname / copyuser [player]', DESC = 'Copies a players full username to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'userid / id [player]', DESC = 'Notifies a players user ID'}
CMDs[#CMDs + 1] = {NAME = 'copyuserid / copyid [player]', DESC = 'Copies a players user ID to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'appearanceid / aid [player]', DESC = 'Notifies a players appearance ID'}
CMDs[#CMDs + 1] = {NAME = 'copyappearanceid / caid [player]', DESC = 'Copies a players appearance ID to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'bang [player] [speed]', DESC = 'owo'}
CMDs[#CMDs + 1] = {NAME = 'unbang', DESC = 'uwu'}
CMDs[#CMDs + 1] = {NAME = 'carpet [player]', DESC = 'Be someones carpet'}
CMDs[#CMDs + 1] = {NAME = 'uncarpet', DESC = 'Undoes carpet'}
CMDs[#CMDs + 1] = {NAME = 'friend [player]', DESC = 'Sends a friend request to certain players'}
CMDs[#CMDs + 1] = {NAME = 'unfriend [player]', DESC = 'Unfriends certain players'}
CMDs[#CMDs + 1] = {NAME = 'headsit [player]', DESC = 'Sit on a players head'}
CMDs[#CMDs + 1] = {NAME = 'walkto / follow [player]', DESC = 'Follow a player'}
CMDs[#CMDs + 1] = {NAME = 'pathfindwalkto / pathfindfollow [player]', DESC = 'Follow a player using pathfinding'}
CMDs[#CMDs + 1] = {NAME = 'pathfindwalktowaypoint / pathfindwalktowp [waypoint]', DESC = 'Walk to a waypoint using pathfinding'}
CMDs[#CMDs + 1] = {NAME = 'unwalkto / unfollow', DESC = 'Stops following a player'}
CMDs[#CMDs + 1] = {NAME = 'orbit [player] [speed] [distance]', DESC = 'Makes your character orbit around a player with an optional speed and an optional distance'}
CMDs[#CMDs + 1] = {NAME = 'unorbit', DESC = 'Disables orbit'}
CMDs[#CMDs + 1] = {NAME = 'stareat / stare [player]', DESC = 'Stare / look at a player'}
CMDs[#CMDs + 1] = {NAME = 'unstareat / unstare [player]', DESC = 'Disables stareat'}
CMDs[#CMDs + 1] = {NAME = 'rolewatch [group id] [role name]', DESC = 'Notify if someone from a watched group joins the server'}
CMDs[#CMDs + 1] = {NAME = 'rolewatchstop / unrolewatch', DESC = 'Disable Rolewatch'}
CMDs[#CMDs + 1] = {NAME = 'rolewatchleave', DESC = 'Toggle if you should leave the game if someone from a watched group joins the server'}
CMDs[#CMDs + 1] = {NAME = 'staffwatch', DESC = 'Notify if a staff member of the game joins the server'}
CMDs[#CMDs + 1] = {NAME = 'unstaffwatch', DESC = 'Disable Staffwatch'}
CMDs[#CMDs + 1] = {NAME = 'handlekill / hkill [player] [radius] (TOOL)', DESC = 'Kills a player using tool damage (YOU NEED A TOOL)'}
CMDs[#CMDs + 1] = {NAME = 'fling', DESC = 'Flings anyone you touch'}
CMDs[#CMDs + 1] = {NAME = 'unfling', DESC = 'Disables the fling command'}
CMDs[#CMDs + 1] = {NAME = 'flyfling [speed]', DESC = 'Basically the invisfling command but not invisible'}
CMDs[#CMDs + 1] = {NAME = 'unflyfling', DESC = 'Disables the flyfling command'}
CMDs[#CMDs + 1] = {NAME = 'walkfling', DESC = 'Basically fling but no spinning'}
CMDs[#CMDs + 1] = {NAME = 'unwalkfling / nowalkfling', DESC = 'Disables walkfling'}
CMDs[#CMDs + 1] = {NAME = 'invisfling', DESC = 'Enables invisible fling'}
CMDs[#CMDs + 1] = {NAME = 'antifling', DESC = 'Disables player collisions to prevent you from being flung'}
CMDs[#CMDs + 1] = {NAME = 'unantifling', DESC = 'Disables antifling'}
CMDs[#CMDs + 1] = {NAME = 'loopoof', DESC = 'Loops everyones character sounds (everyone can hear)'}
CMDs[#CMDs + 1] = {NAME = 'unloopoof', DESC = 'Stops the oof chaos'}
CMDs[#CMDs + 1] = {NAME = 'muteboombox [player]', DESC = 'Mutes someones boombox'}
CMDs[#CMDs + 1] = {NAME = 'unmuteboombox [player]', DESC = 'Unmutes someones boombox'}
CMDs[#CMDs + 1] = {NAME = 'hitbox [player] [size] [transparency]', DESC = 'Expands the hitbox for players HumanoidRootPart (default is 1)'}
CMDs[#CMDs + 1] = {NAME = 'headsize [player] [size]', DESC = 'Expands the head size for players Head (default is 1)'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'reset', DESC = 'Resets your character normally'}
CMDs[#CMDs + 1] = {NAME = 'respawn', DESC = 'Respawns you'}
CMDs[#CMDs + 1] = {NAME = 'refresh / re', DESC = 'Respawns and brings you back to the same position'}
CMDs[#CMDs + 1] = {NAME = 'god', DESC = 'Makes your character difficult to kill in most games'}
CMDs[#CMDs + 1] = {NAME = 'permadeath', DESC = 'Makes you unable to die'}
CMDs[#CMDs + 1] = {NAME = 'invisible / invis', DESC = 'Makes you invisible to other players'}
CMDs[#CMDs + 1] = {NAME = 'visible / vis', DESC = 'Makes you visible to other players'}
CMDs[#CMDs + 1] = {NAME = 'toolinvisible / toolinvis / tinvis', DESC = 'Makes you invisible to other players and able to use tools'}
CMDs[#CMDs + 1] = {NAME = 'speed / ws / walkspeed [num]', DESC = 'Change your walkspeed'}
CMDs[#CMDs + 1] = {NAME = 'spoofspeed / spoofws [num]', DESC = 'Spoofs your WalkSpeed on the Client'}
CMDs[#CMDs + 1] = {NAME = 'loopspeed / loopws [num]', DESC = 'Loops your walkspeed'}
CMDs[#CMDs + 1] = {NAME = 'unloopspeed / unloopws', DESC = 'Turns off loopspeed'}
CMDs[#CMDs + 1] = {NAME = 'hipheight / hheight [num]', DESC = 'Adjusts hip height'}
CMDs[#CMDs + 1] = {NAME = 'jumppower / jpower / jp [num]', DESC = 'Change a players jump height'}
CMDs[#CMDs + 1] = {NAME = 'spoofjumppower / spoofjp [num]', DESC = 'Spoofs your JumpPower on the Client'}
CMDs[#CMDs + 1] = {NAME = 'loopjumppower / loopjp [num]', DESC = 'Loops your jump height'}
CMDs[#CMDs + 1] = {NAME = 'unloopjumppower / unloopjp', DESC = 'Turns off loopjumppower'}
CMDs[#CMDs + 1] = {NAME = 'maxslopeangle / msa [num]', DESC = 'Adjusts MaxSlopeAngle'}
CMDs[#CMDs + 1] = {NAME = 'gravity / grav [num] (CLIENT)', DESC = 'Change your gravity'}
CMDs[#CMDs + 1] = {NAME = 'sit', DESC = 'Makes your character sit'}
CMDs[#CMDs + 1] = {NAME = 'lay / laydown', DESC = 'Makes your character lay down'}
CMDs[#CMDs + 1] = {NAME = 'sitwalk', DESC = 'Makes your character sit while still being able to walk'}
CMDs[#CMDs + 1] = {NAME = 'nosit', DESC = 'Prevents your character from sitting'}
CMDs[#CMDs + 1] = {NAME = 'unnosit', DESC = 'Disables nosit'}
CMDs[#CMDs + 1] = {NAME = 'jump', DESC = 'Makes your character jump'}
CMDs[#CMDs + 1] = {NAME = 'infinitejump / infjump', DESC = 'Allows you to jump before hitting the ground'}
CMDs[#CMDs + 1] = {NAME = 'uninfinitejump / uninfjump', DESC = 'Disables infjump'}
CMDs[#CMDs + 1] = {NAME = 'flyjump', DESC = 'Allows you to hold space to fly up'}
CMDs[#CMDs + 1] = {NAME = 'unflyjump', DESC = 'Disables flyjump'}
CMDs[#CMDs + 1] = {NAME = 'autojump / ajump', DESC = 'Automatically jumps when you run into an object'}
CMDs[#CMDs + 1] = {NAME = 'unautojump / unajump', DESC = 'Disables autojump'}
CMDs[#CMDs + 1] = {NAME = 'edgejump / ejump', DESC = 'Automatically jumps when you get to the edge of an object'}
CMDs[#CMDs + 1] = {NAME = 'unedgejump / unejump', DESC = 'Disables edgejump'}
CMDs[#CMDs + 1] = {NAME = 'platformstand / stun', DESC = 'Enables PlatformStand'}
CMDs[#CMDs + 1] = {NAME = 'unplatformstand / unstun', DESC = 'Disables PlatformStand'}
CMDs[#CMDs + 1] = {NAME = 'norotate / noautorotate', DESC = 'Disables AutoRotate'}
CMDs[#CMDs + 1] = {NAME = 'unnorotate / autorotate', DESC = 'Enables AutoRotate'}
CMDs[#CMDs + 1] = {NAME = 'enablestate [StateType]', DESC = 'Enables a humanoid state type'}
CMDs[#CMDs + 1] = {NAME = 'disablestate [StateType]', DESC = 'Disables a humanoid state type'}
CMDs[#CMDs + 1] = {NAME = 'team [team name] (CLIENT)', DESC = 'Changes your team. Sometimes fools localscripts.'}
CMDs[#CMDs + 1] = {NAME = 'nobillboardgui / nobgui / noname', DESC = 'Removes billboard and surface guis from your players (i.e. name guis at cafes)'}
CMDs[#CMDs + 1] = {NAME = 'loopnobgui / loopnoname', DESC = 'Loop removes billboard and surface guis from your players (i.e. name guis at cafes)'}
CMDs[#CMDs + 1] = {NAME = 'unloopnobgui / unloopnoname', DESC = 'Disables loopnobgui'}
CMDs[#CMDs + 1] = {NAME = 'noarms', DESC = 'Removes your arms'}
CMDs[#CMDs + 1] = {NAME = 'nolegs', DESC = 'Removes your legs'}
CMDs[#CMDs + 1] = {NAME = 'nolimbs', DESC = 'Removes your limbs'}
CMDs[#CMDs + 1] = {NAME = 'naked (CLIENT)', DESC = 'Removes your clothing'}
CMDs[#CMDs + 1] = {NAME = 'noface / removeface', DESC = 'Removes your face'}
CMDs[#CMDs + 1] = {NAME = 'blockhead', DESC = 'Turns your head into a block'}
CMDs[#CMDs + 1] = {NAME = 'blockhats', DESC = 'Turns your hats into blocks'}
CMDs[#CMDs + 1] = {NAME = 'blocktool', DESC = 'Turns the currently selected tool into a block'}
CMDs[#CMDs + 1] = {NAME = 'creeper', DESC = 'Makes you look like a creeper'}
CMDs[#CMDs + 1] = {NAME = 'drophats', DESC = 'Drops your hats'}
CMDs[#CMDs + 1] = {NAME = 'nohats / deletehats / rhats', DESC = 'Deletes your hats'}
CMDs[#CMDs + 1] = {NAME = 'hatspin / spinhats', DESC = 'Spins your characters accessories'}
CMDs[#CMDs + 1] = {NAME = 'unhatspin / unspinhats', DESC = 'Undoes spinhats'}
CMDs[#CMDs + 1] = {NAME = 'clearhats / cleanhats', DESC = 'Clears hats in the workspace'}
CMDs[#CMDs + 1] = {NAME = 'chardelete / cd [instance name]', DESC = 'Removes any part with a certain name from your character'}
CMDs[#CMDs + 1] = {NAME = 'chardeleteclass / cdc [class name]', DESC = 'Removes any part with a certain classname from your character'}
CMDs[#CMDs + 1] = {NAME = 'deletevelocity / dv / removeforces', DESC = 'Removes any velocity / force instances in your character'}
CMDs[#CMDs + 1] = {NAME = 'weaken [num]', DESC = 'Makes your character less dense'}
CMDs[#CMDs + 1] = {NAME = 'unweaken', DESC = 'Sets your characters CustomPhysicalProperties to default'}
CMDs[#CMDs + 1] = {NAME = 'strengthen [num]', DESC = 'Makes your character more dense (CustomPhysicalProperties)'}
CMDs[#CMDs + 1] = {NAME = 'unstrengthen', DESC = 'Sets your characters CustomPhysicalProperties to default'}
CMDs[#CMDs + 1] = {NAME = 'breakvelocity', DESC = 'Sets your characters velocity to 0'}
CMDs[#CMDs + 1] = {NAME = 'spin [speed]', DESC = 'Spins your character'}
CMDs[#CMDs + 1] = {NAME = 'unspin', DESC = 'Disables spin'}
CMDs[#CMDs + 1] = {NAME = 'split', DESC = 'Splits your character in half'}
CMDs[#CMDs + 1] = {NAME = 'nilchar', DESC = 'Sets your characters parent to nil'}
CMDs[#CMDs + 1] = {NAME = 'unnilchar / nonilchar', DESC = 'Sets your characters parent to workspace'}
CMDs[#CMDs + 1] = {NAME = 'noroot / removeroot / rroot', DESC = 'Removes your characters HumanoidRootPart'}
CMDs[#CMDs + 1] = {NAME = 'replaceroot', DESC = 'Replaces your characters HumanoidRootPart'}
CMDs[#CMDs + 1] = {NAME = 'clearcharappearance / clearchar / clrchar', DESC = 'Removes all accessory, shirt, pants, charactermesh, and bodycolors'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'animation / anim [ID] [speed]', DESC = 'Makes your character perform an animation (must be by roblox to replicate)'}
CMDs[#CMDs + 1] = {NAME = 'dance', DESC = 'Makes you  d a n c e'}
CMDs[#CMDs + 1] = {NAME = 'undance', DESC = 'Stops dance animations'}
CMDs[#CMDs + 1] = {NAME = 'spasm', DESC = 'Makes you  c r a z y'}
CMDs[#CMDs + 1] = {NAME = 'unspasm', DESC = 'Stops spasm'}
CMDs[#CMDs + 1] = {NAME = 'headthrow', DESC = 'Simply makes you throw your head'}
CMDs[#CMDs + 1] = {NAME = 'noanim', DESC = 'Disables your animations'}
CMDs[#CMDs + 1] = {NAME = 'reanim', DESC = 'Restores your animations'}
CMDs[#CMDs + 1] = {NAME = 'animspeed [num]', DESC = 'Changes the speed of your current animation'}
CMDs[#CMDs + 1] = {NAME = 'copyanimation / copyanim / copyemote [player]', DESC = 'Copies someone elses animation'}
CMDs[#CMDs + 1] = {NAME = 'copyanimationid / copyanimid / copyemoteid [player]', DESC = 'Copies your animation id or someone elses to your clipboard'}
CMDs[#CMDs + 1] = {NAME = 'loopanimation / loopanim', DESC = 'Loops your current animation'}
CMDs[#CMDs + 1] = {NAME = 'stopanimations / stopanims', DESC = 'Stops running animations'}
CMDs[#CMDs + 1] = {NAME = 'refreshanimations / refreshanims', DESC = 'Refreshes animations'}
CMDs[#CMDs + 1] = {NAME = 'allowcustomanim / allowcustomanimations', DESC = 'Lets you use custom animation packs instead'}
CMDs[#CMDs + 1] = {NAME = 'unallowcustomanim / unallowcustomanimations', DESC = 'Doesn\'t let you use custom animation packs instead'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'autoclick [click delay] [release delay]', DESC = 'Automatically clicks your mouse with a set delay'}
CMDs[#CMDs + 1] = {NAME = 'unautoclick / noautoclick', DESC = 'Turns off autoclick'}
CMDs[#CMDs + 1] = {NAME = 'autokeypress [key] [down delay] [up delay]', DESC = 'Automatically presses a key with a set delay'}
CMDs[#CMDs + 1] = {NAME = 'unautokeypress', DESC = 'Stops autokeypress'}
CMDs[#CMDs + 1] = {NAME = 'hovername', DESC = 'Shows a players username when your mouse is hovered over them'}
CMDs[#CMDs + 1] = {NAME = 'unhovername / nohovername', DESC = 'Turns off hovername'}
CMDs[#CMDs + 1] = {NAME = 'mousesensitivity / ms [0-10]', DESC = 'Sets your mouse sensitivity (affects first person and right click drag) (default is 1)'}
CMDs[#CMDs + 1] = {NAME = 'clickdelete', DESC = 'Go to settings>Keybinds>Add for clicktp'}
CMDs[#CMDs + 1] = {NAME = 'clickteleport', DESC = 'Go to settings>Keybinds>Add for click tp'}
CMDs[#CMDs + 1] = {NAME = 'mouseteleport / mousetp', DESC = 'Teleports your character to your mouse. This is recommended as a keybind'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'tools', DESC = 'Copies tools from ReplicatedStorage and Lighting'}
CMDs[#CMDs + 1] = {NAME = 'notools / removetools / deletetools', DESC = 'Removes tools from character and backpack'}
CMDs[#CMDs + 1] = {NAME = 'deleteselectedtool / dst', DESC = 'Removes any currently selected tools'}
CMDs[#CMDs + 1] = {NAME = 'grabtools', DESC = 'Automatically get tools that are dropped'}
CMDs[#CMDs + 1] = {NAME = 'ungrabtools / nograbtools', DESC = 'Disables grabtools'}
CMDs[#CMDs + 1] = {NAME = 'copytools [player] (CLIENT)', DESC = 'Copies a players tools'}
CMDs[#CMDs + 1] = {NAME = 'dupetools / clonetools [num]', DESC = 'Duplicates your inventory tools a set amount of times'}
CMDs[#CMDs + 1] = {NAME = 'droptools', DESC = 'Drops your tools'}
CMDs[#CMDs + 1] = {NAME = 'droppabletools', DESC = 'Makes your tools droppable'}
CMDs[#CMDs + 1] = {NAME = 'equiptools', DESC = 'Equips every tool in your inventory at once'}
CMDs[#CMDs + 1] = {NAME = 'unequiptools', DESC = 'Unequips every tool you are currently holding at once'}
CMDs[#CMDs + 1] = {NAME = 'removespecifictool [name]', DESC = 'Automatically remove a specific tool from your inventory'}
CMDs[#CMDs + 1] = {NAME = 'unremovespecifictool [name]', DESC = 'Stops removing a specific tool from your inventory'}
CMDs[#CMDs + 1] = {NAME = 'clearremovespecifictool', DESC = 'Stop removing all specific tools from your inventory'}
CMDs[#CMDs + 1] = {NAME = 'reach [num]', DESC = 'Increases the hitbox of your held tool'}
CMDs[#CMDs + 1] = {NAME = 'boxreach [num]', DESC = 'Increases the hitbox of your held tool in a box shape'}
CMDs[#CMDs + 1] = {NAME = 'unreach / noreach', DESC = 'Turns off reach'}
CMDs[#CMDs + 1] = {NAME = 'grippos [X Y Z]', DESC = 'Changes your current tools grip position'}
CMDs[#CMDs + 1] = {NAME = 'usetools [amount] [delay]', DESC = 'Activates all tools in your backpack at the same time'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'addalias [cmd] [alias]', DESC = 'Adds an alias to a command'}
CMDs[#CMDs + 1] = {NAME = 'removealias [alias]', DESC = 'Removes a custom alias'}
CMDs[#CMDs + 1] = {NAME = 'clraliases', DESC = 'Removes all custom aliases'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'addplugin / plugin [name]', DESC = 'Add a plugin via command'}
CMDs[#CMDs + 1] = {NAME = 'removeplugin / deleteplugin [name]', DESC = 'Remove a plugin via command'}
CMDs[#CMDs + 1] = {NAME = 'reloadplugin [name]', DESC = 'Reloads a plugin'}
CMDs[#CMDs + 1] = {NAME = 'addallplugins / loadallplugins', DESC = 'Adds all available plugins from the workspace folder'}
CMDs[#CMDs + 1] = {NAME = '', DESC = ''}
CMDs[#CMDs + 1] = {NAME = 'breakloops / break (cmd loops)', DESC = 'Stops any cmd loops (;100^1^cmd)'}
CMDs[#CMDs + 1] = {NAME = 'removecmd / deletecmd', DESC = 'Removes a command until the admin is reloaded'}
CMDs[#CMDs + 1] = {NAME = 'tpwalk / teleportwalk [num]', DESC = 'Teleports you to your move direction'}
CMDs[#CMDs + 1] = {NAME = 'untpwalk / unteleportwalk', DESC = 'Undoes tpwalk / teleportwalk'}
CMDs[#CMDs + 1] = {NAME = 'notifyping / ping', DESC = 'Notify yourself your ping'}
CMDs[#CMDs + 1] = {NAME = 'trip', DESC = 'Makes your character fall over'}
CMDs[#CMDs + 1] = {NAME = 'norender', DESC = 'Disable 3d Rendering to decrease the amount of CPU the client uses'}
CMDs[#CMDs + 1] = {NAME = 'render', DESC = 'Enable 3d Rendering'}
CMDs[#CMDs + 1] = {NAME = 'use2022materials / 2022materials', DESC = 'Enables 2022 material textures'}
CMDs[#CMDs + 1] = {NAME = 'unuse2022materials / un2022materials', DESC = 'Disables 2022 material textures'}
CMDs[#CMDs + 1] = {NAME = 'promptr6', DESC = 'Prompts the game to switch your rig type to R6'}
CMDs[#CMDs + 1] = {NAME = 'promptr15', DESC = 'Prompts the game to switch your rig type to R15'}
CMDs[#CMDs + 1] = {NAME = 'wallwalk / walkonwalls', DESC = 'Walk on walls'}
CMDs[#CMDs + 1] = {NAME = 'removeads / adblock', DESC = 'Automatically removes ad billboards'}
CMDs[#CMDs + 1] = {NAME = 'scare / spook [player]', DESC = 'Teleports in front of a player for half a second'}
CMDs[#CMDs + 1] = {NAME = 'alignmentkeys', DESC = 'Enables the left and right alignment keys (comma and period)'}
CMDs[#CMDs + 1] = {NAME = 'unalignmentkeys / noalignmentkeys', DESC = 'Disables the alignment keys'}
CMDs[#CMDs + 1] = {NAME = 'ctrllock', DESC = 'Binds Shiftlock to LeftControl'}
CMDs[#CMDs + 1] = {NAME = 'unctrllock', DESC = 'Re-binds Shiftlock to LeftShift'}
CMDs[#CMDs + 1] = {NAME = 'listento [player]', DESC = 'Listens to the area around a player. Can also eavesdrop with vc'}
CMDs[#CMDs + 1] = {NAME = 'unlistento', DESC = 'Disables listento'}
CMDs[#CMDs + 1] = {NAME = 'jerk', DESC = 'Makes you jork it'}
CMDs[#CMDs + 1] = {NAME = 'unsuspendvc', DESC = 'Unsuspends you from voice chat'}
wait()

for i = 1, #CMDs do
	local newcmd = Example:Clone()
	newcmd.Parent = CMDsF
	newcmd.Visible = false
	newcmd.Text = CMDs[i].NAME
	newcmd.Name = "CMD"
	table.insert(text1, newcmd)
	if CMDs[i].DESC ~= "" then
		newcmd:SetAttribute("Title", CMDs[i].NAME)
		newcmd:SetAttribute("Desc", CMDs[i].DESC)
		newcmd.MouseButton1Down:Connect(function()
			if not IsOnMobile and newcmd.Visible and newcmd.TextTransparency == 0 then
				local currentText = Cmdbar.Text
				Cmdbar:CaptureFocus()
				autoComplete(newcmd.Text, currentText)
				maximizeHolder()
			end
		end)
	end
end

IndexContents("", true)

function checkTT()
	local t
	local guisAtPosition = COREGUI:GetGuiObjectsAtPosition(IYMouse.X, IYMouse.Y)

	for _, gui in pairs(guisAtPosition) do
		if gui.Parent == CMDsF then
			t = gui
		end
	end

	if t ~= nil and t:GetAttribute("Title") ~= nil then
		local x = IYMouse.X
		local y = IYMouse.Y
		local xP
		local yP
		if IYMouse.X > 200 then
			xP = x - 201
		else
			xP = x + 21
		end
		if IYMouse.Y > (IYMouse.ViewSizeY-96) then
			yP = y - 97
		else
			yP = y
		end
		Tooltip.Position = UDim2.new(0, xP, 0, yP)
		Description.Text = t:GetAttribute("Desc")
		if t:GetAttribute("Title") ~= nil then
			Title_3.Text = t:GetAttribute("Title")
		else
			Title_3.Text = ''
		end
		Tooltip.Visible = true
	else
		Tooltip.Visible = false
	end
end

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end

function GetInTable(Table, Name)
	for i = 1, #Table do
		if Table[i] == Name then
			return i
		end
	end
	return false
end

function permadeath(plr)
    if replicatesignal then
        replicatesignal(plr.ConnectDiedSignalBackend)
        task.wait(Players.RespawnTime - 0.1)
    end
end

function respawn(plr)
    if invisRunning then TurnVisible() end

    local rcdEnabled, wasHidden = false, false
    if gethidden then
        rcdEnabled, wasHidden = gethidden(workspace, "RejectCharacterDeletions") ~= Enum.RejectCharacterDeletions.Disabled
    end

    if rcdEnabled and replicatesignal then
        replicatesignal(plr.ConnectDiedSignalBackend)
        task.wait(Players.RespawnTime - 0.1)
        replicatesignal(plr.Kill)
    elseif rcdEnabled and not replicatesignal then
        notify("Incompatible Exploit", "Your exploit does not support this command (missing replicatesignal)")
    else
        local char = plr.Character
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
        char:ClearAllChildren()
        local newChar = Instance.new("Model")
        newChar.Parent = workspace
        plr.Character = newChar
        task.wait()
        plr.Character = char
        newChar:Destroy()
    end
end

local refreshCmd = false
function refresh(plr)
    refreshCmd = true
    local root = plr.Character:WaitForChild("HumanoidRootPart")
    local pos = root.CFrame
    local pos1 = workspace.CurrentCamera.CFrame
    respawn(plr)
    task.spawn(function()
        plr.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame, workspace.CurrentCamera.CFrame = pos, task.wait() and pos1
        refreshCmd = false
    end)
end

local lastDeath

function onDied()
	task.spawn(function()
		if pcall(function() Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') end) and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
			Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
				if getRoot(Players.LocalPlayer.Character) then
					lastDeath = getRoot(Players.LocalPlayer.Character).CFrame
				end
			end)
		else
			wait(2)
			onDied()
		end
	end)
end

Clip = true
spDelay = 0.1
Players.LocalPlayer.CharacterAdded:Connect(function()
	NOFLY()
	Floating = false

	if not Clip then
		execCmd('clip')
	end

	repeat wait() until getRoot(Players.LocalPlayer.Character)

	pcall(function()
		if spawnpoint and not refreshCmd and spawnpos ~= nil then
			wait(spDelay)
			getRoot(Players.LocalPlayer.Character).CFrame = spawnpos
		end
	end)

	onDied()
end)

onDied()

function getstring(begin)
	local start = begin-1
	local AA = '' for i,v in pairs(cargs) do
		if i > start then
			if AA ~= '' then
				AA = AA .. ' ' .. v
			else
				AA = AA .. v
			end
		end
	end
	return AA
end

findCmd=function(cmd_name)
	for i,v in pairs(cmds)do
		if v.NAME:lower()==cmd_name:lower() or FindInTable(v.ALIAS,cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end

cmdHistory = {}
local lastCmds = {}
local historyCount = 0
local split=" "
local lastBreakTime = 0
function execCmd(cmdStr,speaker,store)
	cmdStr = cmdStr:gsub("%s+$","")
	task.spawn(function()
		local rawCmdStr = cmdStr
		cmdStr = string.gsub(cmdStr,"\\\\","%%BackSlash%%")
		local commandsToRun = splitString(cmdStr,"\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v,"%%BackSlash%%","\\")
			local x,y,num = v:find("^(%d+)%^")
			local cmdDelay = 0
			local infTimes = false
			if num then
				v = v:sub(y+1)
				local x,y,del = v:find("^([%d%.]+)%^")
				if del then
					v = v:sub(y+1)
					cmdDelay = tonumber(del) or 0
				end
			else
				local x,y = v:find("^inf%^")
				if x then
					infTimes = true
					v = v:sub(y+1)
					local x,y,del = v:find("^([%d%.]+)%^")
					if del then
						v = v:sub(y+1)
						del = tonumber(del) or 1
						cmdDelay = (del > 0 and del or 1)
					else
						cmdDelay = 1
					end
				end
			end
			num = tonumber(num or 1)

			if v:sub(1,1) == "!" then
				local chunks = splitString(v:sub(2),split)
				if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
			end

			local args = splitString(v,split)
			local cmdName = args[1]
			local cmd = findCmd(cmdName)
			if cmd then
				table.remove(args,1)
				cargs = args
				if not speaker then speaker = Players.LocalPlayer end
				if store then
					if speaker == Players.LocalPlayer then
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= 'lastcommand' and rawCmdStr:sub(1,7) ~= 'lastcmd' then
							table.insert(cmdHistory,1,rawCmdStr)
						end
					end
					if #cmdHistory > 30 then table.remove(cmdHistory) end

					lastCmds[cmdName] = v
				end
				local cmdStartTime = tick()
				if infTimes then
					while lastBreakTime < cmdStartTime do
						local success,err = pcall(cmd.FUNC,args, speaker)
						if not success and _G.IY_DEBUG then
							warn("Command Error:", cmdName, err)
						end
						wait(cmdDelay)
					end
				else
					for rep = 1,num do
						if lastBreakTime > cmdStartTime then break end
						local success,err = pcall(function()
							cmd.FUNC(args, speaker)
						end)
						if not success and _G.IY_DEBUG then
							warn("Command Error:", cmdName, err)
						end
						if cmdDelay ~= 0 then wait(cmdDelay) end
					end
				end
			end
		end
	end)
end	

function addcmd(name,alias,func,plgn)
	cmds[#cmds+1]=
		{
			NAME=name;
			ALIAS=alias or {};
			FUNC=func;
			PLUGIN=plgn;
		}
end

function removecmd(cmd)
	if cmd ~= " " then
		for i = #cmds,1,-1 do
			if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
				table.remove(cmds, i)
				for a,c in pairs(CMDsF:GetChildren()) do
					if string.find(c.Text, "^"..cmd.."$") or string.find(c.Text, "^"..cmd.." ") or string.find(c.Text, " "..cmd.."$") or string.find(c.Text, " "..cmd.." ") then
						c.TextTransparency = 0.7
						c.MouseButton1Click:Connect(function()
							notify(c.Text, "Command has been disabled by you or a plugin")
						end)
					end
				end
			end
		end
	end
end

function overridecmd(name, func)
    local cmd = findCmd(name)
    if cmd and cmd.FUNC then cmd.FUNC = func end
end

function addbind(cmd,key,iskeyup,toggle)
	if toggle then
		binds[#binds+1]=
			{
				COMMAND=cmd;
				KEY=key;
				ISKEYUP=iskeyup;
				TOGGLE = toggle;
			}
	else
		binds[#binds+1]=
			{
				COMMAND=cmd;
				KEY=key;
				ISKEYUP=iskeyup;
			}
	end
end

function addcmdtext(text,name,desc)
	local newcmd = Example:Clone()
	local tooltipText = tostring(text)
	local tooltipDesc = tostring(desc)
	newcmd.Parent = CMDsF
	newcmd.Visible = false
	newcmd.Text = text
	newcmd.Name = 'PLUGIN_'..name
	table.insert(text1,newcmd)
	if desc and desc ~= '' then
		newcmd:SetAttribute("Title", tooltipText)
		newcmd:SetAttribute("Desc", tooltipDesc)
		newcmd.MouseButton1Down:Connect(function()
			if newcmd.Visible and newcmd.TextTransparency == 0 then
				Cmdbar:CaptureFocus()
				autoComplete(newcmd.Text)
				maximizeHolder()
			end
		end)
	end
end

local WorldToScreen = function(Object)
	local ObjectVector = workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local MousePositionToVector2 = function()
	return Vector2.new(IYMouse.X, IYMouse.Y)
end

local GetClosestPlayerFromCursor = function()
	local found = nil
	local ClosestDistance = math.huge
	for i, v in pairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
			for k, x in pairs(v.Character:GetChildren()) do
				if string.find(x.Name, "Torso") then
					local Distance = (WorldToScreen(x) - MousePositionToVector2()).Magnitude
					if Distance < ClosestDistance then
						ClosestDistance = Distance
						found = v
					end
				end
			end
		end
	end
	return found
end

SpecialPlayerCases = {
	["all"] = function(speaker) return Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker,args,currentList)
		local players = Players:GetPlayers()
		local localplayer = Players.LocalPlayer
		table.remove(players, table.find(players, localplayer))
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild('Pal Hair') or plr.Character:FindFirstChild('Kate Hair') then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end,
	["cursor"] = function(speaker)
		local plrs = {}
		local v = GetClosestPlayerFromCursor()
		if v ~= nil then table.insert(plrs, v) end
		return plrs
	end,
	["npcs"] = function(speaker,args)
		local returns = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and getRoot(v) and v:FindFirstChildWhichIsA("Humanoid") and Players:GetPlayerFromCharacter(v) == nil then
				local clone = Instance.new("Player")
				clone.Name = v.Name .. " - " .. v:FindFirstChildWhichIsA("Humanoid").DisplayName
				clone.Character = v
				table.insert(returns, clone)
			end
		end
		return returns
	end,
}

function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end

function onlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function removeTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function getPlayersByName(Name)
	local Name,Len,Found = string.lower(Name),#Name,{}
	for _,v in pairs(Players:GetPlayers()) do
		if Name:sub(0,1) == '@' then
			if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
				table.insert(Found,v)
			end
		else
			if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
				table.insert(Found,v)
			end
		end
	end
	return Found
end

function getPlayer(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end

formatUsername = function(player)
    if player.DisplayName ~= player.Name then
        return string.format("%s (%s)", player.Name, player.DisplayName)
    end
    return player.Name
end

getprfx=function(strn)
	if strn:sub(1,string.len(prefix))==prefix then return{'cmd',string.len(prefix)+1}
	end return
end

function do_exec(str, plr)
	str = str:gsub('/e ', '')
	local t = getprfx(str)
	if not t then return end
	str = str:sub(t[2])
	if t[1]=='cmd' then
		execCmd(str, plr, true)
		IndexContents('',true,false,true)
		CMDsF.CanvasPosition = canvasPos
	end
end

lastTextBoxString,lastTextBoxCon,lastEnteredString = nil,nil,nil

UserInputService.TextBoxFocused:Connect(function(obj)
	if lastTextBoxCon then lastTextBoxCon:Disconnect() end
	if obj == Cmdbar then lastTextBoxString = nil return end
	lastTextBoxString = obj.Text
	lastTextBoxCon = obj:GetPropertyChangedSignal("Text"):Connect(function()
		if not (UserInputService:IsKeyDown(Enum.KeyCode.Return) or UserInputService:IsKeyDown(Enum.KeyCode.KeypadEnter)) then
			lastTextBoxString = obj.Text
		end
	end)
end)

UserInputService.InputBegan:Connect(function(input,gameProcessed)
	if gameProcessed then
		if Cmdbar and Cmdbar:IsFocused() then
			if input.KeyCode == Enum.KeyCode.Up then
				historyCount = historyCount + 1
				if historyCount > #cmdHistory then historyCount = #cmdHistory end
				Cmdbar.Text = cmdHistory[historyCount] or ""
				Cmdbar.CursorPosition = 1020
			elseif input.KeyCode == Enum.KeyCode.Down then
				historyCount = historyCount - 1
				if historyCount < 0 then historyCount = 0 end
				Cmdbar.Text = cmdHistory[historyCount] or ""
				Cmdbar.CursorPosition = 1020
			end
		elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
			lastEnteredString = lastTextBoxString
		end
	end
end)

Players.LocalPlayer.Chatted:Connect(function()
	wait()
	if lastEnteredString then
		local message = lastEnteredString
		lastEnteredString = nil
		do_exec(message, Players.LocalPlayer)
	end
end)

Cmdbar.PlaceholderText = "Command Bar ("..prefix..")"
Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	if Cmdbar:IsFocused() then
		IndexContents(Cmdbar.Text,true,true)
	end
end)

local tabComplete = nil
tabAllowed = true
Cmdbar.FocusLost:Connect(function(enterpressed)
	if enterpressed then
		local cmdbarText = Cmdbar.Text:gsub("^"..prefix,"")
		execCmd(cmdbarText,Players.LocalPlayer,true)
	end
	if tabComplete then tabComplete:Disconnect() end
	wait()
	if not Cmdbar:IsFocused() then
		Cmdbar.Text = ""
		IndexContents('',true,false,true)
		if SettingsOpen == true then
			wait(0.2)
			Settings:TweenPosition(UDim2.new(0, 0, 0, 45), "InOut", "Quart", 0.2, true, nil)
			CMDsF.Visible = false
		end
	end
	CMDsF.CanvasPosition = canvasPos
end)

Cmdbar.Focused:Connect(function()
	historyCount = 0
	canvasPos = CMDsF.CanvasPosition
	if SettingsOpen == true then
		wait(0.2)
		CMDsF.Visible = true
		Settings:TweenPosition(UDim2.new(0, 0, 0, 220), "InOut", "Quart", 0.2, true, nil)
	end
	tabComplete = UserInputService.InputBegan:Connect(function(input,gameProcessed)
		if Cmdbar:IsFocused() then
			if tabAllowed == true and input.KeyCode == Enum.KeyCode.Tab and topCommand ~= nil then
				autoComplete(topCommand)
			end
		else
			tabComplete:Disconnect()
		end
	end)
end)

ESPenabled = false
CHMSenabled = false

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function ESP(plr, logic)
	task.spawn(function()
		for i,v in pairs(COREGUI:GetChildren()) do
			if v.Name == plr.Name..'_ESP' then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not COREGUI:FindFirstChild(plr.Name..'_ESP') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name..'_ESP'
			ESPholder.Parent = COREGUI
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
					a.Name = plr.Name
					a.Parent = ESPholder
					a.Adornee = n
					a.AlwaysOnTop = true
					a.ZIndex = 10
					a.Size = n.Size
					a.Transparency = espTransparency
					if logic == true then
						a.Color = BrickColor.new(plr.TeamColor == Players.LocalPlayer.TeamColor and "Bright green" or "Bright red")
					else
						a.Color = plr.TeamColor
					end
				end
			end
			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = plr.Character.Head
				BillboardGui.Name = plr.Name
				BillboardGui.Parent = ESPholder
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = UDim2.new(0, 100, 0, 100)
				TextLabel.Font = Enum.Font.SourceSansSemibold
				TextLabel.TextSize = 20
				TextLabel.TextColor3 = Color3.new(1, 1, 1)
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = 'Name: '..plr.Name
				TextLabel.ZIndex = 10
				local espLoopFunc
				local teamChange
				local addedFunc
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
						ESP(plr, logic)
						addedFunc:Disconnect()
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
					end
				end)
				teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect()
						addedFunc:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
						ESP(plr, logic)
						teamChange:Disconnect()
					else
						teamChange:Disconnect()
					end
				end)
				local function espLoop()
					if COREGUI:FindFirstChild(plr.Name..'_ESP') then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = 'Name: '..plr.Name..' | Health: '..round(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1)..' | Studs: '..pos
						end
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
						espLoopFunc:Disconnect()
					end
				end
				espLoopFunc = RunService.RenderStepped:Connect(espLoop)
			end
		end
	end)
end

function CHMS(plr)
	task.spawn(function()
		for i,v in pairs(COREGUI:GetChildren()) do
			if v.Name == plr.Name..'_CHMS' then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not COREGUI:FindFirstChild(plr.Name..'_CHMS') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name..'_CHMS'
			ESPholder.Parent = COREGUI
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
					a.Name = plr.Name
					a.Parent = ESPholder
					a.Adornee = n
					a.AlwaysOnTop = true
					a.ZIndex = 10
					a.Size = n.Size
					a.Transparency = espTransparency
					a.Color = plr.TeamColor
				end
			end
			local addedFunc
			local teamChange
			local CHMSremoved
			addedFunc = plr.CharacterAdded:Connect(function()
				if CHMSenabled then
					ESPholder:Destroy()
					teamChange:Disconnect()
					repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
					CHMS(plr)
					addedFunc:Disconnect()
				else
					teamChange:Disconnect()
					addedFunc:Disconnect()
				end
			end)
			teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
				if CHMSenabled then
					ESPholder:Destroy()
					addedFunc:Disconnect()
					repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
					CHMS(plr)
					teamChange:Disconnect()
				else
					teamChange:Disconnect()
				end
			end)
			CHMSremoved = ESPholder.AncestryChanged:Connect(function()
				teamChange:Disconnect()
				addedFunc:Disconnect()
				CHMSremoved:Disconnect()
			end)
		end
	end)
end

function Locate(plr)
	task.spawn(function()
		for i,v in pairs(COREGUI:GetChildren()) do
			if v.Name == plr.Name..'_LC' then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not COREGUI:FindFirstChild(plr.Name..'_LC') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name..'_LC'
			ESPholder.Parent = COREGUI
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
					a.Name = plr.Name
					a.Parent = ESPholder
					a.Adornee = n
					a.AlwaysOnTop = true
					a.ZIndex = 10
					a.Size = n.Size
					a.Transparency = espTransparency
					a.Color = plr.TeamColor
				end
			end
			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = plr.Character.Head
				BillboardGui.Name = plr.Name
				BillboardGui.Parent = ESPholder
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = UDim2.new(0, 100, 0, 100)
				TextLabel.Font = Enum.Font.SourceSansSemibold
				TextLabel.TextSize = 20
				TextLabel.TextColor3 = Color3.new(1, 1, 1)
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = 'Name: '..plr.Name
				TextLabel.ZIndex = 10
				local lcLoopFunc
				local addedFunc
				local teamChange
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPholder ~= nil and ESPholder.Parent ~= nil then
						lcLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
						Locate(plr)
						addedFunc:Disconnect()
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
					end
				end)
				teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
					if ESPholder ~= nil and ESPholder.Parent ~= nil then
						lcLoopFunc:Disconnect()
						addedFunc:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
						Locate(plr)
						teamChange:Disconnect()
					else
						teamChange:Disconnect()
					end
				end)
				local function lcLoop()
					if COREGUI:FindFirstChild(plr.Name..'_LC') then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = 'Name: '..plr.Name..' | Health: '..round(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1)..' | Studs: '..pos
						end
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
						lcLoopFunc:Disconnect()
					end
				end
				lcLoopFunc = RunService.RenderStepped:Connect(lcLoop)
			end
		end
	end)
end

local bindsGUI = KeybindEditor
local awaitingInput = false
local keySelected = false

function refreshbinds()
	if Holder_2 then
		Holder_2:ClearAllChildren()
		Holder_2.CanvasSize = UDim2.new(0, 0, 0, 10)
		for i = 1, #binds do
			local YSize = 25
			local Position = ((i * YSize) - YSize)
			local newbind = Example_2:Clone()
			newbind.Parent = Holder_2
			newbind.Visible = true
			newbind.Position = UDim2.new(0,0,0, Position + 5)
			table.insert(shade2,newbind)
			table.insert(shade2,newbind.Text)
			table.insert(text1,newbind.Text)
			table.insert(shade3,newbind.Text.Delete)
			table.insert(text2,newbind.Text.Delete)
			local input = tostring(binds[i].KEY)
			local key
			if input == 'RightClick' or input == 'LeftClick' then
				key = input
			else
				key = input:sub(14)
			end
			if binds[i].TOGGLE then
				newbind.Text.Text = key.." > "..binds[i].COMMAND.." / "..binds[i].TOGGLE
			else
				newbind.Text.Text = key.." > "..binds[i].COMMAND.."  "..(binds[i].ISKEYUP and "(keyup)" or "(keydown)")
			end
			Holder_2.CanvasSize = UDim2.new(0,0,0, Position + 30)
			newbind.Text.Delete.MouseButton1Click:Connect(function()
				unkeybind(binds[i].COMMAND,binds[i].KEY)
			end)
		end
	end
end

refreshbinds()

toggleOn = {}

function unkeybind(cmd,key)
	for i = #binds,1,-1 do
		if binds[i].COMMAND == cmd and binds[i].KEY == key then
			toggleOn[binds[i]] = nil
			table.remove(binds, i)
		end
	end
	refreshbinds()
	updatesaves()
	if key == 'RightClick' or key == 'LeftClick' then
		notify('Keybinds Updated','Unbinded '..key..' from '..cmd)
	else
		notify('Keybinds Updated','Unbinded '..key:sub(14)..' from '..cmd)
	end
end

PositionsFrame.Delete.MouseButton1Click:Connect(function()
	execCmd('cpos')
end)

function refreshwaypoints()
	if #WayPoints > 0 or #pWayPoints > 0 then
		PositionsHint:Destroy()
	end
	if Holder_4 then
		Holder_4:ClearAllChildren()
		Holder_4.CanvasSize = UDim2.new(0, 0, 0, 10)
		local YSize = 25
		local num = 1
		for i = 1, #WayPoints do
			local Position = ((num * YSize) - YSize)
			local newpoint = Example_4:Clone()
			newpoint.Parent = Holder_4
			newpoint.Visible = true
			newpoint.Position = UDim2.new(0,0,0, Position + 5)
			newpoint.Text.Text = WayPoints[i].NAME
			table.insert(shade2,newpoint)
			table.insert(shade2,newpoint.Text)
			table.insert(text1,newpoint.Text)
			table.insert(shade3,newpoint.Text.Delete)
			table.insert(text2,newpoint.Text.Delete)
			table.insert(shade3,newpoint.Text.TP)
			table.insert(text2,newpoint.Text.TP)
			Holder_4.CanvasSize = UDim2.new(0,0,0, Position + 30)
			newpoint.Text.Delete.MouseButton1Click:Connect(function()
				execCmd('dpos '..WayPoints[i].NAME)
			end)
			newpoint.Text.TP.MouseButton1Click:Connect(function()
				execCmd("loadpos "..WayPoints[i].NAME)
			end)
			num = num+1
		end
		for i = 1, #pWayPoints do
			local Position = ((num * YSize) - YSize)
			local newpoint = Example_4:Clone()
			newpoint.Parent = Holder_4
			newpoint.Visible = true
			newpoint.Position = UDim2.new(0,0,0, Position + 5)
			newpoint.Text.Text = pWayPoints[i].NAME
			table.insert(shade2,newpoint)
			table.insert(shade2,newpoint.Text)
			table.insert(text1,newpoint.Text)
			table.insert(shade3,newpoint.Text.Delete)
			table.insert(text2,newpoint.Text.Delete)
			table.insert(shade3,newpoint.Text.TP)
			table.insert(text2,newpoint.Text.TP)
			Holder_4.CanvasSize = UDim2.new(0,0,0, Position + 30)
			newpoint.Text.Delete.MouseButton1Click:Connect(function()
				execCmd('dpos '..pWayPoints[i].NAME)
			end)
			newpoint.Text.TP.MouseButton1Click:Connect(function()
				execCmd("loadpos "..pWayPoints[i].NAME)
			end)
			num = num+1
		end
	end
end

refreshwaypoints()

function refreshaliases()
	if #aliases > 0 then
		AliasHint:Destroy()
	end
	if Holder_3 then
		Holder_3:ClearAllChildren()
		Holder_3.CanvasSize = UDim2.new(0, 0, 0, 10)
		for i = 1, #aliases do
			local YSize = 25
			local Position = ((i * YSize) - YSize)
			local newalias = Example_3:Clone()
			newalias.Parent = Holder_3
			newalias.Visible = true
			newalias.Position = UDim2.new(0,0,0, Position + 5)
			newalias.Text.Text = aliases[i].CMD.." > "..aliases[i].ALIAS
			table.insert(shade2,newalias)
			table.insert(shade2,newalias.Text)
			table.insert(text1,newalias.Text)
			table.insert(shade3,newalias.Text.Delete)
			table.insert(text2,newalias.Text.Delete)
			Holder_3.CanvasSize = UDim2.new(0,0,0, Position + 30)
			newalias.Text.Delete.MouseButton1Click:Connect(function()
				execCmd('removealias '..aliases[i].ALIAS)
			end)
		end
	end
end

local bindChosenKeyUp = false

BindTo.MouseButton1Click:Connect(function()
	awaitingInput = true
	BindTo.Text = 'Press something'
end)

BindTriggerSelect.MouseButton1Click:Connect(function()
	bindChosenKeyUp = not bindChosenKeyUp
	BindTriggerSelect.Text = bindChosenKeyUp and "KeyUp" or "KeyDown"
end)

newToggle = false
Cmdbar_3.Parent.Visible = false
On_2.MouseButton1Click:Connect(function()
	if newToggle == false then newToggle = true
		On_2.BackgroundTransparency = 0
		Cmdbar_3.Parent.Visible = true
		BindTriggerSelect.Visible = false
	else newToggle = false
		On_2.BackgroundTransparency = 1
		Cmdbar_3.Parent.Visible = false
		BindTriggerSelect.Visible = true
	end
end)

Add_2.MouseButton1Click:Connect(function()
	if keySelected then
		if string.find(Cmdbar_2.Text, "\\\\") or string.find(Cmdbar_3.Text, "\\\\") then
			notify('Keybind Error','Only use one backslash to keybind multiple commands into one keybind or command')
		else
			if newToggle and Cmdbar_3.Text ~= '' and Cmdbar_2.text ~= '' then
				addbind(Cmdbar_2.Text,keyPressed,false,Cmdbar_3.Text)
			elseif not newToggle and Cmdbar_2.text ~= '' then
				addbind(Cmdbar_2.Text,keyPressed,bindChosenKeyUp)
			else
				return
			end
			refreshbinds()
			updatesaves()
			if keyPressed == 'RightClick' or keyPressed == 'LeftClick' then
				notify('Keybinds Updated','Binded '..keyPressed..' to '..Cmdbar_2.Text..(newToggle and " / "..Cmdbar_3.Text or ""))
			else
				notify('Keybinds Updated','Binded '..keyPressed:sub(14)..' to '..Cmdbar_2.Text..(newToggle and " / "..Cmdbar_3.Text or ""))
			end
		end
	end
end)

Exit_2.MouseButton1Click:Connect(function()
	Cmdbar_2.Text = 'Command'
	Cmdbar_3.Text = 'Command 2'
	BindTo.Text = 'Click to bind'
	bindChosenKeyUp = false
	BindTriggerSelect.Text = "KeyDown"
	keySelected = false
	KeybindEditor:TweenPosition(UDim2.new(0.5, -180, 0, -500), "InOut", "Quart", 0.5, true, nil)
end)

function onInputBegan(input,gameProcessed)
	if awaitingInput then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			keyPressed = tostring(input.KeyCode)
			BindTo.Text = keyPressed:sub(14)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			keyPressed = 'LeftClick'
			BindTo.Text = 'LeftClick'
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			keyPressed = 'RightClick'
			BindTo.Text = 'RightClick'
		end
		awaitingInput = false
		keySelected = true
	end
	if not gameProcessed and #binds > 0 then
		for i,v in pairs(binds) do
			if not v.ISKEYUP then
				if (input.UserInputType == Enum.UserInputType.Keyboard and v.KEY:lower()==tostring(input.KeyCode):lower()) or (input.UserInputType == Enum.UserInputType.MouseButton1 and v.KEY:lower()=='leftclick') or (input.UserInputType == Enum.UserInputType.MouseButton2 and v.KEY:lower()=='rightclick') then
					if v.TOGGLE then
						local isOn = toggleOn[v] == true
						toggleOn[v] = not isOn
						if isOn then
							execCmd(v.TOGGLE,Players.LocalPlayer)
						else
							execCmd(v.COMMAND,Players.LocalPlayer)
						end
					else
						execCmd(v.COMMAND,Players.LocalPlayer)
					end
				end
			end
		end
	end
end

function onInputEnded(input,gameProcessed)
	if not gameProcessed and #binds > 0 then
		for i,v in pairs(binds) do
			if v.ISKEYUP then
				if (input.UserInputType == Enum.UserInputType.Keyboard and v.KEY:lower()==tostring(input.KeyCode):lower()) or (input.UserInputType == Enum.UserInputType.MouseButton1 and v.KEY:lower()=='leftclick') or (input.UserInputType == Enum.UserInputType.MouseButton2 and v.KEY:lower()=='rightclick') then
					execCmd(v.COMMAND,Players.LocalPlayer)
				end
			end
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

ClickTP.Select.MouseButton1Click:Connect(function()
	if keySelected then
		addbind('clicktp',keyPressed,bindChosenKeyUp)
		refreshbinds()
		updatesaves()
		if keyPressed == 'RightClick' or keyPressed == 'LeftClick' then
			notify('Keybinds Updated','Binded '..keyPressed..' to click tp')
		else
			notify('Keybinds Updated','Binded '..keyPressed:sub(14)..' to click tp')
		end
	end
end)

ClickDelete.Select.MouseButton1Click:Connect(function()
	if keySelected then
		addbind('clickdel',keyPressed,bindChosenKeyUp)
		refreshbinds()
		updatesaves()
		if keyPressed == 'RightClick' or keyPressed == 'LeftClick' then
			notify('Keybinds Updated','Binded '..keyPressed..' to click delete')
		else
			notify('Keybinds Updated','Binded '..keyPressed:sub(14)..' to click delete')
		end
	end
end)

local function clicktpFunc()
	pcall(function()
		local character = Players.LocalPlayer.Character
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.SeatPart then
			humanoid.Sit = false
			wait(0.1)
		end

		local hipHeight = humanoid and humanoid.HipHeight > 0 and (humanoid.HipHeight + 1)
		local rootPart = getRoot(character)
		local rootPartPosition = rootPart.Position
		local hitPosition = IYMouse.Hit.Position
		local newCFrame = CFrame.new(
			hitPosition, 
			Vector3.new(rootPartPosition.X, hitPosition.Y, rootPartPosition.Z)
		) * CFrame.Angles(0, math.pi, 0)

		rootPart.CFrame = newCFrame + Vector3.new(0, hipHeight or 4, 0)
	end)
end

IYMouse.Button1Down:Connect(function()
	for i,v in pairs(binds) do
		if v.COMMAND == 'clicktp' then
			local input = v.KEY
			if input == 'RightClick' and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and Players.LocalPlayer.Character then
				clicktpFunc()
			elseif input == 'LeftClick' and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and Players.LocalPlayer.Character then
				clicktpFunc()
			elseif UserInputService:IsKeyDown(Enum.KeyCode[input:sub(14)]) and Players.LocalPlayer.Character then
				clicktpFunc()
			end
		elseif v.COMMAND == 'clickdel' then
			local input = v.KEY
			if input == 'RightClick' and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				pcall(function() IYMouse.Target:Destroy() end)
			elseif input == 'LeftClick' and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				pcall(function() IYMouse.Target:Destroy() end)
			elseif UserInputService:IsKeyDown(Enum.KeyCode[input:sub(14)]) then
				pcall(function() IYMouse.Target:Destroy() end)
			end
		end
	end
end)

PluginsGUI = PluginEditor.background

function addPlugin(name)
	if name:lower() == 'plugin file name' or name:lower() == 'iy_fe.iy' or name == 'iy_fe' then
		notify('Plugin Error','Please enter a valid plugin')
	else
		local file
		local fileName
		if name:sub(-3) == '.iy' then
			pcall(function() file = readfile(name) end)
			fileName = name
		else
			pcall(function() file = readfile(name..'.iy') end)
			fileName = name..'.iy'
		end
		if file then
			if not FindInTable(PluginsTable, fileName) then
				table.insert(PluginsTable, fileName)
				LoadPlugin(fileName)
				refreshplugins()
				pcall(eventEditor.Refresh)
			else
				notify('Plugin Error','This plugin is already added')
			end
		else
			notify('Plugin Error','Cannot locate file "'..fileName..'". Is the file in the correct folder?')
		end
	end
end

function deletePlugin(name)
	local pName = name..'.iy'
	if name:sub(-3) == '.iy' then
		pName = name
	end
	for i = #cmds,1,-1 do
		if cmds[i].PLUGIN == pName then
			table.remove(cmds, i)
		end
	end
	for i,v in pairs(CMDsF:GetChildren()) do
		if v.Name == 'PLUGIN_'..pName then
			v:Destroy()
		end
	end
	for i,v in pairs(PluginsTable) do
		if v == pName then
			table.remove(PluginsTable, i)
			notify('Removed Plugin',pName..' was removed')
		end
	end
	IndexContents('',true)
	refreshplugins()
end

function refreshplugins(dontSave)
	if #PluginsTable > 0 then
		PluginsHint:Destroy()
	end
	if Holder_5 then
		Holder_5:ClearAllChildren()
		Holder_5.CanvasSize = UDim2.new(0, 0, 0, 10)
		for i,v in pairs(PluginsTable) do
			local pName = v
			local YSize = 25
			local Position = ((i * YSize) - YSize)
			local newplugin = Example_5:Clone()
			newplugin.Parent = Holder_5
			newplugin.Visible = true
			newplugin.Position = UDim2.new(0,0,0, Position + 5)
			newplugin.Text.Text = pName
			table.insert(shade2,newplugin)
			table.insert(shade2,newplugin.Text)
			table.insert(text1,newplugin.Text)
			table.insert(shade3,newplugin.Text.Delete)
			table.insert(text2,newplugin.Text.Delete)
			Holder_5.CanvasSize = UDim2.new(0,0,0, Position + 30)
			newplugin.Text.Delete.MouseButton1Click:Connect(function()
				deletePlugin(pName)
			end)
		end
		if not dontSave then
			updatesaves()
		end
	end
end

local PluginCache
function LoadPlugin(val,startup)
	local plugin

	function CatchedPluginLoad()
		plugin = loadfile(val)()
	end

	function handlePluginError(plerror)
		notify('Plugin Error','An error occurred with the plugin, "'..val..'" and it could not be loaded')
		if FindInTable(PluginsTable,val) then
			for i,v in pairs(PluginsTable) do
				if v == val then
					table.remove(PluginsTable,i)
				end
			end
		end
		updatesaves()

		print("Original Error: "..tostring(plerror))
		print("Plugin Error, stack traceback: "..tostring(debug.traceback()))

		plugin = nil

		return false
	end

	xpcall(CatchedPluginLoad, handlePluginError)

	if plugin ~= nil then
		if not startup then
			notify('Loaded Plugin',"Name: "..plugin["PluginName"].."\n".."Description: "..plugin["PluginDescription"])
		end
		addcmdtext('',val)
		addcmdtext(string.upper('--'..plugin["PluginName"]),val,plugin["PluginDescription"])
		if plugin["Commands"] then
			for i,v in pairs(plugin["Commands"]) do 
				local cmdExt = ''
				local cmdName = i
				local function handleNames()
					cmdName = i
					if findCmd(cmdName..cmdExt) then
						if isNumber(cmdExt) then
							cmdExt = cmdExt+1
						else
							cmdExt = 1
						end
						handleNames()
					else
						cmdName = cmdName..cmdExt
					end
				end
				handleNames()
				addcmd(cmdName, v["Aliases"], v["Function"], val)
				if v["ListName"] then
					local newName = v.ListName
					local cmdNames = {i,unpack(v.Aliases)}
					for i,v in pairs(cmdNames) do
						newName = newName:gsub(v,v..cmdExt)
					end
					addcmdtext(newName,val,v["Description"])
				else
					addcmdtext(cmdName,val,v["Description"])
				end
			end
		end
		IndexContents('',true)
	elseif plugin == nil then
		plugin = nil
	end
end

function FindPlugins()
	if PluginsTable ~= nil and type(PluginsTable) == "table" then
		for i,v in pairs(PluginsTable) do
			LoadPlugin(v,true)
		end
		refreshplugins(true)
	end
end

AddPlugin.MouseButton1Click:Connect(function()
	addPlugin(PluginsGUI.FileName.Text)
end)

Exit_3.MouseButton1Click:Connect(function()
	PluginEditor:TweenPosition(UDim2.new(0.5, -180, 0, -500), "InOut", "Quart", 0.5, true, nil)
	FileName.Text = 'Plugin File Name'
end)

Add_3.MouseButton1Click:Connect(function()
	PluginEditor:TweenPosition(UDim2.new(0.5, -180, 0, 310), "InOut", "Quart", 0.5, true, nil)
end)

Plugins.MouseButton1Click:Connect(function()
	if writefileExploit() then
		PluginsFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quart", 0.5, true, nil)
		wait(0.5)
		SettingsHolder.Visible = false
	else
		notify('Incompatible Exploit','Your exploit is unable to use plugins (missing read/writefile)')
	end
end)

Close_4.MouseButton1Click:Connect(function()
	SettingsHolder.Visible = true
	PluginsFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
end)

local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if KeepInfYield and (not TeleportCheck) and queueteleport then
		TeleportCheck = true
		queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()")
	end
end)

addcmd('addalias',{},function(args, speaker)
	if #args < 2 then return end
	local cmd = string.lower(args[1])
	local alias = string.lower(args[2])
	for i,v in pairs(cmds) do
		if v.NAME:lower()==cmd or FindInTable(v.ALIAS,cmd) then
			customAlias[alias] = v
			aliases[#aliases + 1] = {CMD = cmd, ALIAS = alias}
			notify('Aliases Modified',"Added "..alias.." as an alias to "..cmd)
			updatesaves()
			refreshaliases()
			break
		end
	end
end)

addcmd('removealias',{},function(args, speaker)
	if #args < 1 then return end
	local alias = string.lower(args[1])
	if customAlias[alias] then
		local cmd = customAlias[alias].NAME
		customAlias[alias] = nil
		for i = #aliases,1,-1 do
			if aliases[i].ALIAS == tostring(alias) then
				table.remove(aliases, i)
			end
		end
		notify('Aliases Modified',"Removed the alias "..alias.." from "..cmd)
		updatesaves()
		refreshaliases()
	end
end)

addcmd('clraliases',{},function(args, speaker)
	customAlias = {}
	aliases = {}
	notify('Aliases Modified','Removed all aliases')
	updatesaves()
	refreshaliases()
end)

addcmd('discord', {'support', 'help'}, function(args, speaker)
	if everyClipboard then
		toClipboard('https://discord.com/invite/dYHag43eeU')
		notify('Discord Invite', 'Copied to clipboard!\ndiscord.gg/dYHag43eeU')
	else
		notify('Discord Invite', 'discord.gg/dYHag43eeU')
	end
	if httprequest then
		httprequest({
			Url = 'http://127.0.0.1:6463/rpc?v=1',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json',
				Origin = 'https://discord.com'
			},
			Body = HttpService:JSONEncode({
				cmd = 'INVITE_BROWSER',
				nonce = HttpService:GenerateGUID(false),
				args = {code = 'dYHag43eeU'}
			})
		})
	end
end)

addcmd('keepiy', {}, function(args, speaker)
	if queueteleport then
		KeepInfYield = true
		updatesaves()
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing queue_on_teleport)')
	end
end)

addcmd('unkeepiy', {}, function(args, speaker)
	if queueteleport then
		KeepInfYield = false
		updatesaves()
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing queue_on_teleport)')
	end
end)

addcmd('togglekeepiy', {}, function(args, speaker)
	if queueteleport then
		KeepInfYield = not KeepInfYield
		updatesaves()
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing queue_on_teleport)')
	end
end)

local canOpenServerinfo = true
addcmd('serverinfo',{'info','sinfo'},function(args, speaker)
	if not canOpenServerinfo then return end
	canOpenServerinfo = false
	task.spawn(function()
		local FRAME = Instance.new("Frame")
		local shadow = Instance.new("Frame")
		local PopupText = Instance.new("TextLabel")
		local Exit = Instance.new("TextButton")
		local ExitImage = Instance.new("ImageLabel")
		local background = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")
		local TextLabel2 = Instance.new("TextLabel")
		local TextLabel3 = Instance.new("TextLabel")
		local Time = Instance.new("TextLabel")
		local appearance = Instance.new("TextLabel")
		local maxplayers = Instance.new("TextLabel")
		local name = Instance.new("TextLabel")
		local placeid = Instance.new("TextLabel")
		local playerid = Instance.new("TextLabel")
		local players = Instance.new("TextLabel")
		local CopyApp = Instance.new("TextButton")
		local CopyPlrID = Instance.new("TextButton")
		local CopyPlcID = Instance.new("TextButton")
		local CopyPlcName = Instance.new("TextButton")

		FRAME.Name = randomString()
		FRAME.Parent = ScaledHolder
		FRAME.Active = true
		FRAME.BackgroundTransparency = 1
		FRAME.Position = UDim2.new(0.5, -130, 0, -500)
		FRAME.Size = UDim2.new(0, 250, 0, 20)
		FRAME.ZIndex = 10
		dragGUI(FRAME)

		shadow.Name = "shadow"
		shadow.Parent = FRAME
		shadow.BackgroundColor3 = currentShade2
		shadow.BorderSizePixel = 0
		shadow.Size = UDim2.new(0, 250, 0, 20)
		shadow.ZIndex = 10
		table.insert(shade2,shadow)

		PopupText.Name = "PopupText"
		PopupText.Parent = shadow
		PopupText.BackgroundTransparency = 1
		PopupText.Size = UDim2.new(1, 0, 0.95, 0)
		PopupText.ZIndex = 10
		PopupText.Font = Enum.Font.SourceSans
		PopupText.TextSize = 14
		PopupText.Text = "Server"
		PopupText.TextColor3 = currentText1
		PopupText.TextWrapped = true
		table.insert(text1,PopupText)

		Exit.Name = "Exit"
		Exit.Parent = shadow
		Exit.BackgroundTransparency = 1
		Exit.Position = UDim2.new(1, -20, 0, 0)
		Exit.Size = UDim2.new(0, 20, 0, 20)
		Exit.Text = ""
		Exit.ZIndex = 10

		ExitImage.Parent = Exit
		ExitImage.BackgroundColor3 = Color3.new(1, 1, 1)
		ExitImage.BackgroundTransparency = 1
		ExitImage.Position = UDim2.new(0, 5, 0, 5)
		ExitImage.Size = UDim2.new(0, 10, 0, 10)
		ExitImage.Image = getcustomasset("infiniteyield/assets/close.png")
		ExitImage.ZIndex = 10

		background.Name = "background"
		background.Parent = FRAME
		background.Active = true
		background.BackgroundColor3 = currentShade1
		background.BorderSizePixel = 0
		background.Position = UDim2.new(0, 0, 1, 0)
		background.Size = UDim2.new(0, 250, 0, 250)
		background.ZIndex = 10
		table.insert(shade1,background)

		TextLabel.Name = "Text Label"
		TextLabel.Parent = background
		TextLabel.BackgroundTransparency = 1
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 5, 0, 80)
		TextLabel.Size = UDim2.new(0, 100, 0, 20)
		TextLabel.ZIndex = 10
		TextLabel.Font = Enum.Font.SourceSansLight
		TextLabel.TextSize = 20
		TextLabel.Text = "Run Time:"
		TextLabel.TextColor3 = currentText1
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,TextLabel)

		TextLabel2.Name = "Text Label2"
		TextLabel2.Parent = background
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 5, 0, 130)
		TextLabel2.Size = UDim2.new(0, 100, 0, 20)
		TextLabel2.ZIndex = 10
		TextLabel2.Font = Enum.Font.SourceSansLight
		TextLabel2.TextSize = 20
		TextLabel2.Text = "Statistics:"
		TextLabel2.TextColor3 = currentText1
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,TextLabel2)

		TextLabel3.Name = "Text Label3"
		TextLabel3.Parent = background
		TextLabel3.BackgroundTransparency = 1
		TextLabel3.BorderSizePixel = 0
		TextLabel3.Position = UDim2.new(0, 5, 0, 10)
		TextLabel3.Size = UDim2.new(0, 100, 0, 20)
		TextLabel3.ZIndex = 10
		TextLabel3.Font = Enum.Font.SourceSansLight
		TextLabel3.TextSize = 20
		TextLabel3.Text = "Local Player:"
		TextLabel3.TextColor3 = currentText1
		TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,TextLabel3)

		Time.Name = "Time"
		Time.Parent = background
		Time.BackgroundTransparency = 1
		Time.BorderSizePixel = 0
		Time.Position = UDim2.new(0, 5, 0, 105)
		Time.Size = UDim2.new(0, 100, 0, 20)
		Time.ZIndex = 10
		Time.Font = Enum.Font.SourceSans
		Time.FontSize = Enum.FontSize.Size14
		Time.Text = "LOADING"
		Time.TextColor3 = currentText1
		Time.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,Time)

		appearance.Name = "appearance"
		appearance.Parent = background
		appearance.BackgroundTransparency = 1
		appearance.BorderSizePixel = 0
		appearance.Position = UDim2.new(0, 5, 0, 55)
		appearance.Size = UDim2.new(0, 100, 0, 20)
		appearance.ZIndex = 10
		appearance.Font = Enum.Font.SourceSans
		appearance.FontSize = Enum.FontSize.Size14
		appearance.Text = "Appearance: LOADING"
		appearance.TextColor3 = currentText1
		appearance.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,appearance)

		maxplayers.Name = "maxplayers"
		maxplayers.Parent = background
		maxplayers.BackgroundTransparency = 1
		maxplayers.BorderSizePixel = 0
		maxplayers.Position = UDim2.new(0, 5, 0, 175)
		maxplayers.Size = UDim2.new(0, 100, 0, 20)
		maxplayers.ZIndex = 10
		maxplayers.Font = Enum.Font.SourceSans
		maxplayers.FontSize = Enum.FontSize.Size14
		maxplayers.Text = "LOADING"
		maxplayers.TextColor3 = currentText1
		maxplayers.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,maxplayers)

		name.Name = "name"
		name.Parent = background
		name.BackgroundTransparency = 1
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0, 5, 0, 215)
		name.Size = UDim2.new(0, 240, 0, 30)
		name.ZIndex = 10
		name.Font = Enum.Font.SourceSans
		name.FontSize = Enum.FontSize.Size14
		name.Text = "Place Name: LOADING"
		name.TextColor3 = currentText1
		name.TextWrapped = true
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextYAlignment = Enum.TextYAlignment.Top
		table.insert(text1,name)

		placeid.Name = "placeid"
		placeid.Parent = background
		placeid.BackgroundTransparency = 1
		placeid.BorderSizePixel = 0
		placeid.Position = UDim2.new(0, 5, 0, 195)
		placeid.Size = UDim2.new(0, 100, 0, 20)
		placeid.ZIndex = 10
		placeid.Font = Enum.Font.SourceSans
		placeid.FontSize = Enum.FontSize.Size14
		placeid.Text = "Place ID: LOADING"
		placeid.TextColor3 = currentText1
		placeid.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,placeid)

		playerid.Name = "playerid"
		playerid.Parent = background
		playerid.BackgroundTransparency = 1
		playerid.BorderSizePixel = 0
		playerid.Position = UDim2.new(0, 5, 0, 35)
		playerid.Size = UDim2.new(0, 100, 0, 20)
		playerid.ZIndex = 10
		playerid.Font = Enum.Font.SourceSans
		playerid.FontSize = Enum.FontSize.Size14
		playerid.Text = "Player ID: LOADING"
		playerid.TextColor3 = currentText1
		playerid.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,playerid)

		players.Name = "players"
		players.Parent = background
		players.BackgroundTransparency = 1
		players.BorderSizePixel = 0
		players.Position = UDim2.new(0, 5, 0, 155)
		players.Size = UDim2.new(0, 100, 0, 20)
		players.ZIndex = 10
		players.Font = Enum.Font.SourceSans
		players.FontSize = Enum.FontSize.Size14
		players.Text = "LOADING"
		players.TextColor3 = currentText1
		players.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,players)

		CopyApp.Name = "CopyApp"
		CopyApp.Parent = background
		CopyApp.BackgroundColor3 = currentShade2
		CopyApp.BorderSizePixel = 0
		CopyApp.Position = UDim2.new(0, 210, 0, 55)
		CopyApp.Size = UDim2.new(0, 35, 0, 20)
		CopyApp.Font = Enum.Font.SourceSans
		CopyApp.TextSize = 14
		CopyApp.Text = "Copy"
		CopyApp.TextColor3 = currentText1
		CopyApp.ZIndex = 10
		table.insert(shade2,CopyApp)
		table.insert(text1,CopyApp)

		CopyPlrID.Name = "CopyPlrID"
		CopyPlrID.Parent = background
		CopyPlrID.BackgroundColor3 = currentShade2
		CopyPlrID.BorderSizePixel = 0
		CopyPlrID.Position = UDim2.new(0, 210, 0, 35)
		CopyPlrID.Size = UDim2.new(0, 35, 0, 20)
		CopyPlrID.Font = Enum.Font.SourceSans
		CopyPlrID.TextSize = 14
		CopyPlrID.Text = "Copy"
		CopyPlrID.TextColor3 = currentText1
		CopyPlrID.ZIndex = 10
		table.insert(shade2,CopyPlrID)
		table.insert(text1,CopyPlrID)

		CopyPlcID.Name = "CopyPlcID"
		CopyPlcID.Parent = background
		CopyPlcID.BackgroundColor3 = currentShade2
		CopyPlcID.BorderSizePixel = 0
		CopyPlcID.Position = UDim2.new(0, 210, 0, 195)
		CopyPlcID.Size = UDim2.new(0, 35, 0, 20)
		CopyPlcID.Font = Enum.Font.SourceSans
		CopyPlcID.TextSize = 14
		CopyPlcID.Text = "Copy"
		CopyPlcID.TextColor3 = currentText1
		CopyPlcID.ZIndex = 10
		table.insert(shade2,CopyPlcID)
		table.insert(text1,CopyPlcID)

		CopyPlcName.Name = "CopyPlcName"
		CopyPlcName.Parent = background
		CopyPlcName.BackgroundColor3 = currentShade2
		CopyPlcName.BorderSizePixel = 0
		CopyPlcName.Position = UDim2.new(0, 210, 0, 215)
		CopyPlcName.Size = UDim2.new(0, 35, 0, 20)
		CopyPlcName.Font = Enum.Font.SourceSans
		CopyPlcName.TextSize = 14
		CopyPlcName.Text = "Copy"
		CopyPlcName.TextColor3 = currentText1
		CopyPlcName.ZIndex = 10
		table.insert(shade2,CopyPlcName)
		table.insert(text1,CopyPlcName)

		local SINFOGUI = background
		FRAME:TweenPosition(UDim2.new(0.5, -130, 0, 100), "InOut", "Quart", 0.5, true, nil) 
		wait(0.5)
		Exit.MouseButton1Click:Connect(function()
			FRAME:TweenPosition(UDim2.new(0.5, -130, 0, -500), "InOut", "Quart", 0.5, true, nil) 
			wait(0.6)
			FRAME:Destroy()
			canOpenServerinfo = true
		end)
		local Asset = MarketplaceService:GetProductInfo(PlaceId)
		SINFOGUI.name.Text = "Place Name: " .. Asset.Name
		SINFOGUI.playerid.Text = "Player ID: " ..speaker.UserId
		SINFOGUI.maxplayers.Text = Players.MaxPlayers.. " Players Max"
		SINFOGUI.placeid.Text = "Place ID: " ..PlaceId

		CopyApp.MouseButton1Click:Connect(function()
			toClipboard(speaker.CharacterAppearanceId)
		end)
		CopyPlrID.MouseButton1Click:Connect(function()
			toClipboard(speaker.UserId)
		end)
		CopyPlcID.MouseButton1Click:Connect(function()
			toClipboard(PlaceId)
		end)
		CopyPlcName.MouseButton1Click:Connect(function()
			toClipboard(Asset.Name)
		end)

		repeat
			players = Players:GetPlayers()
			SINFOGUI.players.Text = #players.. " Player(s)"
			SINFOGUI.appearance.Text = "Appearance: " ..speaker.CharacterAppearanceId
			local seconds = math.floor(workspace.DistributedGameTime)
			local minutes = math.floor(workspace.DistributedGameTime / 60)
			local hours = math.floor(workspace.DistributedGameTime / 60 / 60)
			local seconds = seconds - (minutes * 60)
			local minutes = minutes - (hours * 60)
			if hours < 1 then if minutes < 1 then
					SINFOGUI.Time.Text = seconds .. " Second(s)" else
					SINFOGUI.Time.Text = minutes .. " Minute(s), " .. seconds .. " Second(s)"
				end
			else
				SINFOGUI.Time.Text = hours .. " Hour(s), " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
			end
			wait(1)
		until SINFOGUI.Parent == nil
	end)
end)

addcmd("jobid", {}, function(args, speaker)
    toClipboard("roblox://placeId=" .. PlaceId .. "&gameInstanceId=" .. JobId)
end)

addcmd('notifyjobid',{},function(args, speaker)
	notify('JobId / PlaceId',JobId..' / '..PlaceId)
end)

addcmd('breakloops',{'break'},function(args, speaker)
	lastBreakTime = tick()
end)

addcmd('gametp',{'gameteleport'},function(args, speaker)
	TeleportService:Teleport(args[1])
end)

addcmd("rejoin", {"rj"}, function(args, speaker)
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("\nRejoining...")
		wait()
		TeleportService:Teleport(PlaceId, Players.LocalPlayer)
	else
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
	end
end)

addcmd("autorejoin", {"autorj"}, function(args, speaker)
	GuiService.ErrorMessageChanged:Connect(function()
		execCmd("rejoin")
	end)
	notify("Auto Rejoin", "Auto rejoin enabled")
end)

addcmd("serverhop", {"shop"}, function(args, speaker)
    -- thanks to Amity for fixing
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    local body = HttpService:JSONDecode(req)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    else
        return notify("Serverhop", "Couldn't find a server.")
    end
end)

addcmd("exit", {}, function(args, speaker)
    game:Shutdown()
end)

local Noclipping = nil
addcmd('noclip',{},function(args, speaker)
	Clip = false
	wait(0.1)
	local function NoclipLoop()
		if Clip == false and speaker.Character ~= nil then
			for _, child in pairs(speaker.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end
	end
	Noclipping = RunService.Stepped:Connect(NoclipLoop)
	if args[1] and args[1] == 'nonotify' then return end
	notify('Noclip','Noclip Enabled')
end)

addcmd('clip',{'unnoclip'},function(args, speaker)
	if Noclipping then
		Noclipping:Disconnect()
	end
	Clip = true
	if args[1] and args[1] == 'nonotify' then return end
	notify('Noclip','Noclip Disabled')
end)

addcmd('togglenoclip',{},function(args, speaker)
	if Clip then
		execCmd('noclip')
	else
		execCmd('clip')
	end
end)

FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1
function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local velocityHandlerName = randomString()
local gyroHandlerName = randomString()
local mfly1
local mfly2

local unmobilefly = function(speaker)
	pcall(function()
		FLYING = false
		local root = getRoot(speaker.Character)
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end

local mobilefly = function(speaker, vfly)
	unmobilefly(speaker)
	FLYING = true

	local root = getRoot(speaker.Character)
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = speaker.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = RunService.RenderStepped:Connect(function()
		root = getRoot(speaker.Character)
		camera = workspace.CurrentCamera
		if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
		end
	end)
end

addcmd('fly',{},function(args, speaker)
	if not IsOnMobile then
		NOFLY()
		wait()
		sFLY()
	else
		mobilefly(speaker)
	end
	if args[1] and isNumber(args[1]) then
		iyflyspeed = args[1]
	end
end)

addcmd('flyspeed',{'flysp'},function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		iyflyspeed = speed
	end
end)

addcmd('unfly',{'nofly','novfly','unvehiclefly','novehiclefly','unvfly'},function(args, speaker)
	if not IsOnMobile then NOFLY() else unmobilefly(speaker) end
end)

addcmd('vfly',{'vehiclefly'},function(args, speaker)
	if not IsOnMobile then
		NOFLY()
		wait()
		sFLY(true)
	else
		mobilefly(speaker, true)
	end
	if args[1] and isNumber(args[1]) then
		vehicleflyspeed = args[1]
	end
end)

addcmd('togglevfly',{},function(args, speaker)
	if FLYING then
		if not IsOnMobile then NOFLY() else unmobilefly(speaker) end
	else
		if not IsOnMobile then sFLY(true) else mobilefly(speaker, true) end
	end
end)

addcmd('vflyspeed',{'vflysp','vehicleflyspeed','vehicleflysp'},function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		vehicleflyspeed = speed
	end
end)

addcmd('qefly',{'flyqe'},function(args, speaker)
	if args[1] == 'false' then
		QEfly = false
	else
		QEfly = true
	end
end)

addcmd('togglefly',{},function(args, speaker)
	if FLYING then
		if not IsOnMobile then NOFLY() else unmobilefly(speaker) end
	else
		if not IsOnMobile then sFLY() else mobilefly(speaker) end
	end
end)

CFspeed = 50
addcmd('cframefly', {'cfly'}, function(args, speaker)
	-- Full credit to peyton#9148 (apeyton)
	speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
	local Head = speaker.Character:WaitForChild("Head")
	Head.Anchored = true
	if CFloop then CFloop:Disconnect() end
	CFloop = RunService.Heartbeat:Connect(function(deltaTime)
		local moveDirection = speaker.Character:FindFirstChildOfClass('Humanoid').MoveDirection * (CFspeed * deltaTime)
		local headCFrame = Head.CFrame
		local cameraCFrame = workspace.CurrentCamera.CFrame
		local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
		cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
		local cameraPosition = cameraCFrame.Position
		local headPosition = headCFrame.Position

		local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
		Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
	end)
end)

addcmd('uncframefly',{'uncfly'},function(args, speaker)
	if CFloop then
		CFloop:Disconnect()
		speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
		local Head = speaker.Character:WaitForChild("Head")
		Head.Anchored = false
	end
end)

addcmd('cframeflyspeed',{'cflyspeed'},function(args, speaker)
	if isNumber(args[1]) then
		CFspeed = args[1]
	end
end)

Floating = false
floatName = randomString()
addcmd('float', {'platform'},function(args, speaker)
	Floating = true
	local pchar = speaker.Character
	if pchar and not pchar:FindFirstChild(floatName) then
		task.spawn(function()
			local Float = Instance.new('Part')
			Float.Name = floatName
			Float.Parent = pchar
			Float.Transparency = 1
			Float.Size = Vector3.new(2,0.2,1.5)
			Float.Anchored = true
			local FloatValue = -3.1
			Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0,FloatValue,0)
			notify('Float','Float Enabled (Q = down & E = up)')
			qUp = IYMouse.KeyUp:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue + 0.5
				end
			end)
			eUp = IYMouse.KeyUp:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue - 1.5
				end
			end)
			qDown = IYMouse.KeyDown:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue - 0.5
				end
			end)
			eDown = IYMouse.KeyDown:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue + 1.5
				end
			end)
			floatDied = speaker.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
				FloatingFunc:Disconnect()
				Float:Destroy()
				qUp:Disconnect()
				eUp:Disconnect()
				qDown:Disconnect()
				eDown:Disconnect()
				floatDied:Disconnect()
			end)
			local function FloatPadLoop()
				if pchar:FindFirstChild(floatName) and getRoot(pchar) then
					Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0,FloatValue,0)
				else
					FloatingFunc:Disconnect()
					Float:Destroy()
					qUp:Disconnect()
					eUp:Disconnect()
					qDown:Disconnect()
					eDown:Disconnect()
					floatDied:Disconnect()
				end
			end			
			FloatingFunc = RunService.Heartbeat:Connect(FloatPadLoop)
		end)
	end
end)

addcmd('unfloat',{'nofloat','unplatform','noplatform'},function(args, speaker)
	Floating = false
	local pchar = speaker.Character
	notify('Float','Float Disabled')
	if pchar:FindFirstChild(floatName) then
		pchar:FindFirstChild(floatName):Destroy()
	end
	if floatDied then
		FloatingFunc:Disconnect()
		qUp:Disconnect()
		eUp:Disconnect()
		qDown:Disconnect()
		eDown:Disconnect()
		floatDied:Disconnect()
	end
end)

addcmd('togglefloat',{},function(args, speaker)
	if Floating then
		execCmd('unfloat')
	else
		execCmd('float')
	end
end)

swimming = false
local oldgrav = workspace.Gravity
local swimbeat = nil
addcmd('swim',{},function(args, speaker)
	if not swimming and speaker and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
		oldgrav = workspace.Gravity
		workspace.Gravity = 0
		local swimDied = function()
			workspace.Gravity = oldgrav
			swimming = false
		end
		local Humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
		gravReset = Humanoid.Died:Connect(swimDied)
		local enums = Enum.HumanoidStateType:GetEnumItems()
		table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
		for i, v in pairs(enums) do
			Humanoid:SetStateEnabled(v, false)
		end
		Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		swimbeat = RunService.Heartbeat:Connect(function()
			pcall(function()
				speaker.Character.HumanoidRootPart.Velocity = ((Humanoid.MoveDirection ~= Vector3.new() or UserInputService:IsKeyDown(Enum.KeyCode.Space)) and speaker.Character.HumanoidRootPart.Velocity or Vector3.new())
			end)
		end)
		swimming = true
	end
end)

addcmd('unswim',{'noswim'},function(args, speaker)
	if speaker and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
		workspace.Gravity = oldgrav
		swimming = false
		if gravReset then
			gravReset:Disconnect()
		end
		if swimbeat ~= nil then
			swimbeat:Disconnect()
			swimbeat = nil
		end
		local Humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
		local enums = Enum.HumanoidStateType:GetEnumItems()
		table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
		for i, v in pairs(enums) do
			Humanoid:SetStateEnabled(v, true)
		end
	end
end)

addcmd('toggleswim',{},function(args, speaker)
	if swimming then
		execCmd('unswim')
	else
		execCmd('swim')
	end
end)

addcmd('setwaypoint',{'swp','setwp','spos','saveposition','savepos'},function(args, speaker)
	local WPName = tostring(getstring(1))
	if getRoot(speaker.Character) then
		notify('Modified Waypoints',"Created waypoint: "..getstring(1))
		local torso = getRoot(speaker.Character)
		WayPoints[#WayPoints + 1] = {NAME = WPName, COORD = {math.floor(torso.Position.X), math.floor(torso.Position.Y), math.floor(torso.Position.Z)}, GAME = PlaceId}
		if AllWaypoints ~= nil then
			AllWaypoints[#AllWaypoints + 1] = {NAME = WPName, COORD = {math.floor(torso.Position.X), math.floor(torso.Position.Y), math.floor(torso.Position.Z)}, GAME = PlaceId}
		end
	end	
	refreshwaypoints()
	updatesaves()
end)

addcmd('waypointpos',{'wpp','setwaypointposition','setpos','setwaypoint','setwaypointpos'},function(args, speaker)
	local WPName = tostring(getstring(1))
	if getRoot(speaker.Character) then
		notify('Modified Waypoints',"Created waypoint: "..getstring(1))
		WayPoints[#WayPoints + 1] = {NAME = WPName, COORD = {args[2], args[3], args[4]}, GAME = PlaceId}
		if AllWaypoints ~= nil then
			AllWaypoints[#AllWaypoints + 1] = {NAME = WPName, COORD = {args[2], args[3], args[4]}, GAME = PlaceId}
		end
	end	
	refreshwaypoints()
	updatesaves()
end)

addcmd('waypoints',{'positions'},function(args, speaker)
	if SettingsOpen == false then SettingsOpen = true
		Settings:TweenPosition(UDim2.new(0, 0, 0, 45), "InOut", "Quart", 0.5, true, nil)
		CMDsF.Visible = false
	end
	KeybindsFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
	AliasesFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
	PluginsFrame:TweenPosition(UDim2.new(0, 0, 0, 175), "InOut", "Quart", 0.5, true, nil)
	PositionsFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quart", 0.5, true, nil)
	wait(0.5)
	SettingsHolder.Visible = false
	maximizeHolder()
end)

waypointParts = {}
addcmd('showwaypoints',{'showwp','showwps'},function(args, speaker)
	execCmd('hidewaypoints')
	wait()
	for i,_ in pairs(WayPoints) do
		local x = WayPoints[i].COORD[1]
		local y = WayPoints[i].COORD[2]
		local z = WayPoints[i].COORD[3]
		local part = Instance.new("Part")
		part.Size = Vector3.new(5,5,5)
		part.CFrame = CFrame.new(x,y,z)
		part.Parent = workspace
		part.Anchored = true
		part.CanCollide = false
		table.insert(waypointParts,part)
		local view = Instance.new("BoxHandleAdornment")
		view.Adornee = part
		view.AlwaysOnTop = true
		view.ZIndex = 10
		view.Size = part.Size
		view.Parent = part
	end
	for i,v in pairs(pWayPoints) do
		local view = Instance.new("BoxHandleAdornment")
		view.Adornee = pWayPoints[i].COORD[1]
		view.AlwaysOnTop = true
		view.ZIndex = 10
		view.Size = pWayPoints[i].COORD[1].Size
		view.Parent = pWayPoints[i].COORD[1]
		table.insert(waypointParts,view)
	end
end)

addcmd('hidewaypoints',{'hidewp','hidewps'},function(args, speaker)
	for i,v in pairs(waypointParts) do
		v:Destroy()
	end
	waypointParts = {}
end)

addcmd('waypoint',{'wp','lpos','loadposition','loadpos'},function(args, speaker)
	local WPName = tostring(getstring(1))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				local x = WayPoints[i].COORD[1]
				local y = WayPoints[i].COORD[2]
				local z = WayPoints[i].COORD[3]
				getRoot(speaker.Character).CFrame = CFrame.new(x,y,z)
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				getRoot(speaker.Character).CFrame = CFrame.new(pWayPoints[i].COORD[1].Position)
			end
		end
	end
end)

tweenSpeed = 1
addcmd('tweenspeed',{'tspeed'},function(args, speaker)
	local newSpeed = args[1] or 1
	if tonumber(newSpeed) then
		tweenSpeed = tonumber(newSpeed)
	end
end)

addcmd('tweenwaypoint',{'twp'},function(args, speaker)
	local WPName = tostring(getstring(1))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			local x = WayPoints[i].COORD[1]
			local y = WayPoints[i].COORD[2]
			local z = WayPoints[i].COORD[3]
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(x,y,z)}):Play()
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pWayPoints[i].COORD[1].Position)}):Play()
			end
		end
	end
end)

addcmd('walktowaypoint',{'wtwp'},function(args, speaker)
	local WPName = tostring(getstring(1))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			local x = WayPoints[i].COORD[1]
			local y = WayPoints[i].COORD[2]
			local z = WayPoints[i].COORD[3]
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				speaker.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = Vector3.new(x,y,z)
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				speaker.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = Vector3.new(pWayPoints[i].COORD[1].Position)
			end
		end
	end
end)

addcmd('deletewaypoint',{'dwp','dpos','deleteposition','deletepos'},function(args, speaker)
	for i,v in pairs(WayPoints) do
		if v.NAME:lower() == tostring(getstring(1)):lower() then
			notify('Modified Waypoints',"Deleted waypoint: " .. v.NAME)
			table.remove(WayPoints, i)
		end
	end
	if AllWaypoints ~= nil and #AllWaypoints > 0 then
		for i,v in pairs(AllWaypoints) do
			if v.NAME:lower() == tostring(getstring(1)):lower() then
				if not v.GAME or v.GAME == PlaceId then
					table.remove(AllWaypoints, i)
				end
			end
		end
	end
	for i,v in pairs(pWayPoints) do
		if v.NAME:lower() == tostring(getstring(1)):lower() then
			notify('Modified Waypoints',"Deleted waypoint: " .. v.NAME)
			table.remove(pWayPoints, i)
		end
	end
	refreshwaypoints()
	updatesaves()
end)

addcmd('clearwaypoints',{'cwp','clearpositions','cpos','clearpos'},function(args, speaker)
	WayPoints = {}
	pWayPoints = {}
	refreshwaypoints()
	updatesaves()
	AllWaypoints = {}
	notify('Modified Waypoints','Removed all waypoints')
end)

addcmd('cleargamewaypoints',{'cgamewp'},function(args, speaker)
	for i,v in pairs(WayPoints) do
		if v.GAME == PlaceId then
			table.remove(WayPoints, i)
		end
	end
	if AllWaypoints ~= nil and #AllWaypoints > 0 then
		for i,v in pairs(AllWaypoints) do
			if v.GAME == PlaceId then
				table.remove(AllWaypoints, i)
			end
		end
	end
	for i,v in pairs(pWayPoints) do
		if v.GAME == PlaceId then
			table.remove(pWayPoints, i)
		end
	end
	refreshwaypoints()
	updatesaves()
	notify('Modified Waypoints','Deleted game waypoints')
end)


local coreGuiTypeNames = {
	-- predefined aliases
	["inventory"] = Enum.CoreGuiType.Backpack,
	["leaderboard"] = Enum.CoreGuiType.PlayerList,
	["emotes"] = Enum.CoreGuiType.EmotesMenu
}

-- Load the full list of enums
for _, enumItem in ipairs(Enum.CoreGuiType:GetEnumItems()) do
	coreGuiTypeNames[enumItem.Name:lower()] = enumItem
end

addcmd('enable',{},function(args, speaker)
	local input = args[1] and args[1]:lower()
	if input then
		if input == "reset" then
			StarterGui:SetCore("ResetButtonCallback", true)
		else
			local coreGuiType = coreGuiTypeNames[input]
			if coreGuiType then
				StarterGui:SetCoreGuiEnabled(coreGuiType, true)
			end
		end
	end
end)

addcmd('disable',{},function(args, speaker)
	local input = args[1] and args[1]:lower()
	if input then
		if input == "reset" then
			StarterGui:SetCore("ResetButtonCallback", false)
		else
			local coreGuiType = coreGuiTypeNames[input]
			if coreGuiType then
				StarterGui:SetCoreGuiEnabled(coreGuiType, false)
			end
		end
	end
end)


local invisGUIS = {}
addcmd('showguis',{},function(args, speaker)
	for i,v in pairs(PlayerGui:GetDescendants()) do
		if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and not v.Visible then
			v.Visible = true
			if not FindInTable(invisGUIS,v) then
				table.insert(invisGUIS,v)
			end
		end
	end
end)

addcmd('unshowguis',{},function(args, speaker)
	for i,v in pairs(invisGUIS) do
		v.Visible = false
	end
	invisGUIS = {}
end)

local hiddenGUIS = {}
addcmd('hideguis',{},function(args, speaker)
	for i,v in pairs(PlayerGui:GetDescendants()) do
		if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and v.Visible then
			v.Visible = false
			if not FindInTable(hiddenGUIS,v) then
				table.insert(hiddenGUIS,v)
			end
		end
	end
end)

addcmd('unhideguis',{},function(args, speaker)
	for i,v in pairs(hiddenGUIS) do
		v.Visible = true
	end
	hiddenGUIS = {}
end)

function deleteGuisAtPos()
	pcall(function()
		local guisAtPosition = PlayerGui:GetGuiObjectsAtPosition(IYMouse.X, IYMouse.Y)
		for _, gui in pairs(guisAtPosition) do
			if gui.Visible == true then
				gui:Destroy()
			end
		end
	end)
end

local deleteGuiInput
addcmd('guidelete',{},function(args, speaker)
	deleteGuiInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent then
			if input.KeyCode == Enum.KeyCode.Backspace then
				deleteGuisAtPos()
			end
		end
	end)
	notify('GUI Delete Enabled','Hover over a GUI and press backspace to delete it')
end)

addcmd('unguidelete',{'noguidelete'},function(args, speaker)
	if deleteGuiInput then deleteGuiInput:Disconnect() end
	notify('GUI Delete Disabled','GUI backspace delete has been disabled')
end)

local wasStayOpen = StayOpen
addcmd('hideiy',{},function(args, speaker)
	isHidden = true
	wasStayOpen = StayOpen
	if StayOpen == true then
		StayOpen = false
		On.BackgroundTransparency = 1
	end
	minimizeNum = 0
	minimizeHolder()
	if not (args[1] and tostring(args[1]) == 'nonotify') then notify('IY Hidden','You can press the prefix key to access the command bar') end
end)

addcmd('showiy',{'unhideiy'},function(args, speaker)
	isHidden = false
	minimizeNum = -20
	if wasStayOpen then
		maximizeHolder()
		StayOpen = true
		On.BackgroundTransparency = 0
	else
		minimizeHolder()
	end
end)

addcmd('rec', {'record'}, function(args, speaker)
	return COREGUI:ToggleRecording()
end)

addcmd('screenshot', {'scrnshot'}, function(args, speaker)
	return COREGUI:TakeScreenshot()
end)

addcmd('togglefs', {'togglefullscreen'}, function(args, speaker)
	return GuiService:ToggleFullscreen()
end)

addcmd('inspect', {'examine'}, function(args, speaker)
	for _, v in ipairs(getPlayer(args[1], speaker)) do
		GuiService:CloseInspectMenu()
		GuiService:InspectPlayerFromUserId(Players[v].UserId)
	end
end)

addcmd("savegame", {"saveplace"}, function(args, speaker)
    if saveinstance then
        notify("Loading", "Downloading game. This will take a while")
        saveinstance()
        notify("Game Saved", "Saved place to the workspace folder within your exploit folder.")
    else
        notify("Incompatible Exploit", "Your exploit does not support this command (missing saveinstance)")
    end
end)

addcmd('clearerror',{'clearerrors'},function(args, speaker)
	GuiService:ClearError()
end)

addcmd('clientantikick',{'antikick'},function(args, speaker)
	if not hookmetamethod then 
	    return notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
	end
	local LocalPlayer = Players.LocalPlayer
	local oldhmmi
	local oldhmmnc
	local oldKickFunction
	if hookfunction then
	    oldKickFunction = hookfunction(LocalPlayer.Kick, function() end)
	end
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
	    if self == LocalPlayer and method:lower() == "kick" then
	        return error("Expected ':' not '.' calling member function Kick", 2)
	    end
	    return oldhmmi(self, method)
	end)
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
	    if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
	        return
	    end
	    return oldhmmnc(self, ...)
	end)
	
	notify('Client Antikick','Client anti kick is now active (only effective on localscript kick)')
end)

allow_rj = true
addcmd('clientantiteleport',{'antiteleport'},function(args, speaker)
	if not hookmetamethod then 
		return notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
	end
	local TeleportService = TeleportService
	local oldhmmi
	local oldhmmnc
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
		if self == TeleportService then
			if method:lower() == "teleport" then
				return error("Expected ':' not '.' calling member function Kick", 2)
			elseif method == "TeleportToPlaceInstance" then
				return error("Expected ':' not '.' calling member function TeleportToPlaceInstance", 2)
			end
		end
		return oldhmmi(self, method)
	end)
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
		if self == TeleportService and getnamecallmethod():lower() == "teleport" or getnamecallmethod() == "TeleportToPlaceInstance" then
			return
		end
		return oldhmmnc(self, ...)
	end)

	notify('Client AntiTP','Client anti teleport is now active (only effective on localscript teleport)')
end)

addcmd('allowrejoin',{'allowrj'},function(args, speaker)
	if args[1] and args[1] == 'false' then
		allow_rj = false
		notify('Client AntiTP','Allow rejoin set to false')
	else
		allow_rj = true
		notify('Client AntiTP','Allow rejoin set to true')
	end
end)

addcmd('cancelteleport',{'canceltp'},function(args, speaker)
	TeleportService:TeleportCancel()
end)

addcmd('volume',{'vol'},function(args, speaker)
	local level = args[1]/10
	UserSettings():GetService("UserGameSettings").MasterVolume = level
end)

addcmd('antilag',{'boostfps','lowgraphics'},function(args, speaker)
	local Terrain = workspace:FindFirstChildOfClass('Terrain')
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	Lighting.FogStart = 9e9
	settings().Rendering.QualityLevel = 1
	for i,v in pairs(game:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material = "Plastic"
			v.Reflectance = 0
			v.BackSurface = "SmoothNoOutlines"
			v.BottomSurface = "SmoothNoOutlines"
			v.FrontSurface = "SmoothNoOutlines"
			v.LeftSurface = "SmoothNoOutlines"
			v.RightSurface = "SmoothNoOutlines"
			v.TopSurface = "SmoothNoOutlines"
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		end
	end
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
	workspace.DescendantAdded:Connect(function(child)
		task.spawn(function()
			if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') or child:IsA('Beam') then
				RunService.Heartbeat:Wait()
				child:Destroy()
			end
		end)
	end)
end)

addcmd("setfpscap", {"fpscap", "maxfps"}, function(args, speaker)
    if fpscaploop then
        task.cancel(fpscaploop)
        fpscaploop = nil
    end

    local fpsCap = 60
    local num = tonumber(args[1]) or 1e6
    if num == "none" then
        return
    elseif num > 0 then
        fpsCap = num
    else
        return notify("Invalid argument", "Please provide a number above 0 or 'none'.")
    end

    if setfpscap and type(setfpscap) == "function" then
        setfpscap(fpsCap)
    else
        fpscaploop = task.spawn(function()
            local timer = os.clock()
            while true do
                if os.clock() >= timer + 1 / fpsCap then
                    timer = os.clock()
                    task.wait()
                end
            end
        end)
    end
end)

addcmd('notify',{},function(args, speaker)
	notify(getstring(1))
end)

addcmd('lastcommand',{'lastcmd'},function(args, speaker)
	if cmdHistory[1]:sub(1,11) ~= 'lastcommand' and cmdHistory[1]:sub(1,7) ~= 'lastcmd' then
		execCmd(cmdHistory[1])
	end
end)

addcmd('esp',{},function(args, speaker)
	if not CHMSenabled then
		ESPenabled = true
		for i,v in pairs(Players:GetPlayers()) do
			if v.Name ~= speaker.Name then
				ESP(v)
			end
		end
	else
		notify('ESP','Disable chams (nochams) before using esp')
	end
end)

addcmd('espteam',{},function(args, speaker)
	if not CHMSenabled then
		ESPenabled = true
		for i,v in pairs(Players:GetPlayers()) do
			if v.Name ~= speaker.Name then
				ESP(v, true)
			end
		end
	else
		notify('ESP','Disable chams (nochams) before using esp')
	end
end)

addcmd('noesp',{'unesp','unespteam'},function(args, speaker)
	ESPenabled = false
	for i,c in pairs(COREGUI:GetChildren()) do
		if string.sub(c.Name, -4) == '_ESP' then
			c:Destroy()
		end
	end
end)

addcmd('esptransparency',{},function(args, speaker)
	espTransparency = (args[1] and isNumber(args[1]) and args[1]) or 0.3
	updatesaves()
end)

local espParts = {}
local partEspTrigger = nil
function partAdded(part)
	if #espParts > 0 then
		if FindInTable(espParts,part.Name:lower()) then
			local a = Instance.new("BoxHandleAdornment")
			a.Name = part.Name:lower().."_PESP"
			a.Parent = part
			a.Adornee = part
			a.AlwaysOnTop = true
			a.ZIndex = 0
			a.Size = part.Size
			a.Transparency = espTransparency
			a.Color = BrickColor.new("Lime green")
		end
	else
		partEspTrigger:Disconnect()
		partEspTrigger = nil
	end
end

addcmd('partesp',{},function(args, speaker)
	local partEspName = getstring(1):lower()
	if not FindInTable(espParts,partEspName) then
		table.insert(espParts,partEspName)
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Name:lower() == partEspName then
				local a = Instance.new("BoxHandleAdornment")
				a.Name = partEspName.."_PESP"
				a.Parent = v
				a.Adornee = v
				a.AlwaysOnTop = true
				a.ZIndex = 0
				a.Size = v.Size
				a.Transparency = espTransparency
				a.Color = BrickColor.new("Lime green")
			end
		end
	end
	if partEspTrigger == nil then
		partEspTrigger = workspace.DescendantAdded:Connect(partAdded)
	end
end)

addcmd('unpartesp',{'nopartesp'},function(args, speaker)
	if args[1] then
		local partEspName = getstring(1):lower()
		if FindInTable(espParts,partEspName) then
			table.remove(espParts, GetInTable(espParts, partEspName))
		end
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name == partEspName..'_PESP' then
				v:Destroy()
			end
		end
	else
		partEspTrigger:Disconnect()
		partEspTrigger = nil
		espParts = {}
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:sub(-5) == '_PESP' then
				v:Destroy()
			end
		end
	end
end)

addcmd('chams',{},function(args, speaker)
	if not ESPenabled then
		CHMSenabled = true
		for i,v in pairs(Players:GetPlayers()) do
			if v.Name ~= speaker.Name then
				CHMS(v)
			end
		end
	else
		notify('Chams','Disable ESP (noesp) before using chams')
	end
end)

addcmd('nochams',{'unchams'},function(args, speaker)
	CHMSenabled = false
	for i,v in pairs(Players:GetPlayers()) do
		local chmsplr = v
		for i,c in pairs(COREGUI:GetChildren()) do
			if c.Name == chmsplr.Name..'_CHMS' then
				c:Destroy()
			end
		end
	end
end)

addcmd('locate',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		Locate(Players[v])
	end
end)

addcmd('nolocate',{'unlocate'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if args[1] then
		for i,v in pairs(players) do
			for i,c in pairs(COREGUI:GetChildren()) do
				if c.Name == Players[v].Name..'_LC' then
					c:Destroy()
				end
			end
		end
	else
		for i,c in pairs(COREGUI:GetChildren()) do
			if string.sub(c.Name, -3) == '_LC' then
				c:Destroy()
			end
		end
	end
end)

viewing = nil
addcmd('view',{'spectate'},function(args, speaker)
	StopFreecam()
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		if viewDied then
			viewDied:Disconnect()
			viewChanged:Disconnect()
		end
		viewing = Players[v]
		workspace.CurrentCamera.CameraSubject = viewing.Character
		notify('Spectate','Viewing ' .. Players[v].Name)
		local function viewDiedFunc()
			repeat wait() until Players[v].Character ~= nil and getRoot(Players[v].Character)
			workspace.CurrentCamera.CameraSubject = viewing.Character
		end
		viewDied = Players[v].CharacterAdded:Connect(viewDiedFunc)
		local function viewChangedFunc()
			workspace.CurrentCamera.CameraSubject = viewing.Character
		end
		viewChanged = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(viewChangedFunc)
	end
end)

addcmd('viewpart',{'viewp'},function(args, speaker)
	StopFreecam()
	if args[1] then
		for i,v in pairs(workspace:GetDescendants()) do
			if v.Name:lower() == getstring(1):lower() and v:IsA("BasePart") then
				wait(0.1)
				workspace.CurrentCamera.CameraSubject = v
			end
		end
	end
end)

addcmd('unview',{'unspectate'},function(args, speaker)
	StopFreecam()
	if viewing ~= nil then
		viewing = nil
		notify('Spectate','View turned off')
	end
	if viewDied then
		viewDied:Disconnect()
		viewChanged:Disconnect()
	end
	workspace.CurrentCamera.CameraSubject = speaker.Character
end)


fcRunning = false
local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = workspace.CurrentCamera
	if newCamera then
		Camera = newCamera
	end
end)

local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value

Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*math.pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = math.exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()

local velSpring = Spring.new(5, Vector3.new())
local panSpring = Spring.new(5, Vector2.new())

Input = {} do

	keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
	}

	mouse = {
		Delta = Vector2.new(),
	}

	NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	PAN_MOUSE_SPEED = Vector2.new(1, 1)*(math.pi/64)
	NAV_ADJ_SPEED = 0.75
	NAV_SHIFT_MUL = 0.25

	navSpeed = 1

	function Input.Vel(dt)
		navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A,
			keyboard.E - keyboard.Q,
			keyboard.S - keyboard.W
		)*NAV_KEYBOARD_SPEED

		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

		return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kMouse
	end

	do
		function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			ContextActionService:BindActionAtPriority("FreecamKeyboard",Keypress,false,INPUT_PRIORITY,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D,
				Enum.KeyCode.E,
				Enum.KeyCode.Q,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
			)
			ContextActionService:BindActionAtPriority("FreecamMousePan",MousePan,false,INPUT_PRIORITY,Enum.UserInputType.MouseMovement)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(keyboard)
			Zero(mouse)
			ContextActionService:UnbindAction("FreecamKeyboard")
			ContextActionService:UnbindAction("FreecamMousePan")
		end
	end
end

function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = Camera.ViewportSize
	local projy = 2*math.tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end

local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))

	local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

	cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
	cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

	local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
	cameraPos = cameraCFrame.p

	Camera.CFrame = cameraCFrame
	Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	Camera.FieldOfView = cameraFov
end

local PlayerState = {} do
	mouseBehavior = ""
	mouseIconEnabled = ""
	cameraType = ""
	cameraFocus = ""
	cameraCFrame = ""
	cameraFieldOfView = ""

	function PlayerState.Push()
		cameraFieldOfView = Camera.FieldOfView
		Camera.FieldOfView = 70

		cameraType = Camera.CameraType
		Camera.CameraType = Enum.CameraType.Custom

		cameraCFrame = Camera.CFrame
		cameraFocus = Camera.Focus

		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = true

		mouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	function PlayerState.Pop()
		Camera.FieldOfView = 70

		Camera.CameraType = cameraType
		cameraType = nil

		Camera.CFrame = cameraCFrame
		cameraCFrame = nil

		Camera.Focus = cameraFocus
		cameraFocus = nil

		UserInputService.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil

		UserInputService.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end

function StartFreecam(pos)
	if fcRunning then
		StopFreecam()
	end
	local cameraCFrame = Camera.CFrame
	if pos then
		cameraCFrame = pos
	end
	cameraRot = Vector2.new()
	cameraPos = cameraCFrame.p
	cameraFov = Camera.FieldOfView

	velSpring:Reset(Vector3.new())
	panSpring:Reset(Vector2.new())

	PlayerState.Push()
	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	Input.StartCapture()
	fcRunning = true
end

function StopFreecam()
	if not fcRunning then return end
	Input.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	PlayerState.Pop()
	workspace.Camera.FieldOfView = 70
	fcRunning = false
end

addcmd('freecam',{'fc'},function(args, speaker)
	StartFreecam()
end)

addcmd('freecampos',{'fcpos','fcp','freecamposition','fcposition'},function(args, speaker)
	if not args[1] then return end
	local freecamPos = CFrame.new(args[1],args[2],args[3])
	StartFreecam(freecamPos)
end)

addcmd('freecamwaypoint',{'fcwp'},function(args, speaker)
	local WPName = tostring(getstring(1))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			local x = WayPoints[i].COORD[1]
			local y = WayPoints[i].COORD[2]
			local z = WayPoints[i].COORD[3]
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				StartFreecam(CFrame.new(x,y,z))
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				StartFreecam(CFrame.new(pWayPoints[i].COORD[1].Position))
			end
		end
	end
end)

addcmd('freecamgoto',{'fcgoto','freecamtp','fctp'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		StartFreecam(getRoot(Players[v].Character).CFrame)
	end
end)

addcmd('unfreecam',{'nofreecam','unfc','nofc'},function(args, speaker)
	StopFreecam()
end)

addcmd('freecamspeed',{'fcspeed'},function(args, speaker)
	local FCspeed = args[1] or 1
	if isNumber(FCspeed) then
		NAV_KEYBOARD_SPEED = Vector3.new(FCspeed, FCspeed, FCspeed)
	end
end)

addcmd('notifyfreecamposition',{'notifyfcpos'},function(args, speaker)
	if fcRunning then
		local X,Y,Z = workspace.CurrentCamera.CFrame.Position.X,workspace.CurrentCamera.CFrame.Position.Y,workspace.CurrentCamera.CFrame.Position.Z
		local Format, Round = string.format, math.round
		notify("Current Position", Format("%s, %s, %s", Round(X), Round(Y), Round(Z)))
	end
end)

addcmd('copyfreecamposition',{'copyfcpos'},function(args, speaker)
	if fcRunning then
		local X,Y,Z = workspace.CurrentCamera.CFrame.Position.X,workspace.CurrentCamera.CFrame.Position.Y,workspace.CurrentCamera.CFrame.Position.Z
		local Format, Round = string.format, math.round
		toClipboard(Format("%s, %s, %s", Round(X), Round(Y), Round(Z)))
	end
end)

addcmd('gotocamera',{'gotocam','tocam'},function(args, speaker)
	getRoot(speaker.Character).CFrame = workspace.Camera.CFrame
end)

addcmd('tweengotocamera',{'tweengotocam','tgotocam','ttocam'},function(args, speaker)
	TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = workspace.Camera.CFrame}):Play()
end)

addcmd('fov',{},function(args, speaker)
	local fov = args[1] or 70
	if isNumber(fov) then
		workspace.CurrentCamera.FieldOfView = fov
	end
end)

local preMaxZoom = Players.LocalPlayer.CameraMaxZoomDistance
local preMinZoom = Players.LocalPlayer.CameraMinZoomDistance
addcmd('lookat',{},function(args, speaker)
	if speaker.CameraMaxZoomDistance ~= 0.5 then
		preMaxZoom = speaker.CameraMaxZoomDistance
		preMinZoom = speaker.CameraMinZoomDistance
	end
	speaker.CameraMaxZoomDistance = 0.5
	speaker.CameraMinZoomDistance = 0.5
	wait()
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local target = Players[v].Character
		if target and target:FindFirstChild('Head') then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Head.CFrame.p)
			wait(0.1)
		end
	end
	speaker.CameraMaxZoomDistance = preMaxZoom
	speaker.CameraMinZoomDistance = preMinZoom
end)

addcmd('fixcam',{'restorecam'},function(args, speaker)
	StopFreecam()
	execCmd('unview')
	workspace.CurrentCamera:remove()
	wait(.1)
	repeat wait() until speaker.Character ~= nil
	workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA('Humanoid')
	workspace.CurrentCamera.CameraType = "Custom"
	speaker.CameraMinZoomDistance = 0.5
	speaker.CameraMaxZoomDistance = 400
	speaker.CameraMode = "Classic"
	speaker.Character.Head.Anchored = false
end)

addcmd('enableshiftlock',{'enablesl','shiftlock'},function(args, speaker)
	speaker.DevEnableMouseLock = true
	notify('Shiftlock','Shift lock is now available')
end)

addcmd('firstp',{},function(args, speaker)
	speaker.CameraMode = "LockFirstPerson"
end)

addcmd('thirdp',{},function(args, speaker)
	speaker.CameraMode = "Classic"
end)

addcmd('noclipcam', {'nccam'}, function(args, speaker)
	local sc = (debug and debug.setconstant) or setconstant
	local gc = (debug and debug.getconstants) or getconstants
	if not sc or not getgc or not gc then
		return notify('Incompatible Exploit', 'Your exploit does not support this command (missing setconstant or getconstants or getgc)')
	end
	local pop = speaker.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
	for _, v in pairs(getgc()) do
		if type(v) == 'function' and getfenv(v).script == pop then
			for i, v1 in pairs(gc(v)) do
				if tonumber(v1) == .25 then
					sc(v, i, 0)
				elseif tonumber(v1) == 0 then
					sc(v, i, .25)
				end
			end
		end
	end
end)

addcmd('maxzoom',{},function(args, speaker)
	speaker.CameraMaxZoomDistance = args[1]
end)

addcmd('minzoom',{},function(args, speaker)
	speaker.CameraMinZoomDistance = args[1]
end)

addcmd('camdistance',{},function(args, speaker)
	local camMax = speaker.CameraMaxZoomDistance
	local camMin = speaker.CameraMinZoomDistance
	if camMax < tonumber(args[1]) then
		camMax = args[1]
	end
	speaker.CameraMaxZoomDistance = args[1]
	speaker.CameraMinZoomDistance = args[1]
	wait()
	speaker.CameraMaxZoomDistance = camMax
	speaker.CameraMinZoomDistance = camMin
end)

addcmd('unlockws',{'unlockworkspace'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Locked = false
		end
	end
end)

addcmd('lockws',{'lockworkspace'},function(args, speaker) 
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Locked = true
		end
	end
end)

addcmd('delete',{'remove'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted ' ..getstring(1))
end)

addcmd('deleteclass',{'removeclass','deleteclassname','removeclassname','dc'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.ClassName:lower() == getstring(1):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted items with ClassName ' ..getstring(1))
end)

addcmd('chardelete',{'charremove','cd'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted ' ..getstring(1))
end)

addcmd('chardeleteclass',{'charremoveclass','chardeleteclassname','charremoveclassname','cdc'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v.ClassName:lower() == getstring(1):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted items with ClassName ' ..getstring(1))
end)

addcmd('deletevelocity',{'dv','removevelocity','removeforces'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("RocketPropulsion") or v:IsA("BodyThrust") or v:IsA("BodyAngularVelocity") or v:IsA("AngularVelocity") or v:IsA("BodyForce") or v:IsA("VectorForce") or v:IsA("LineForce") then
			v:Destroy()
		end
	end
end)

addcmd('deleteinvisparts',{'deleteinvisibleparts','dip'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency == 1 and v.CanCollide then
			v:Destroy()
		end
	end
end)

local shownParts = {}
addcmd('invisibleparts',{'invisparts'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency == 1 then
			if not table.find(shownParts,v) then
				table.insert(shownParts,v)
			end
			v.Transparency = 0
		end
	end
end)

addcmd('uninvisibleparts',{'uninvisparts'},function(args, speaker)
	for i,v in pairs(shownParts) do
		v.Transparency = 1
	end
	shownParts = {}
end)

addcmd('btools',{},function(args, speaker)
	for i = 1, 4 do
		local Tool = Instance.new("HopperBin")
		Tool.BinType = i
		Tool.Name = randomString()
		Tool.Parent = speaker:FindFirstChildOfClass("Backpack")
	end
end)

addcmd('f3x',{'fex'},function(args, speaker)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/f3x.lua"))()
end)

addcmd('partpath',{'partname'},function(args, speaker)
	selectPart()
end)

addcmd('antiafk',{'antiidle'},function(args, speaker)
	local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
	else
		local VirtualUser = cloneref(game:GetService("VirtualUser"))
		Players.LocalPlayer.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end
	if not (args[1] and tostring(args[1]) == 'nonotify') then notify('Anti Idle','Anti idle is enabled') end
end)

addcmd("datalimit", {}, function(args, speaker)
    local kbps = tonumber(args[1])
    if kbps then
        local NetworkClient = cloneref(game:GetService("NetworkClient"))
        NetworkClient:SetOutgoingKBPSLimit(kbps)
    end
end)

addcmd("replicationlag", {"backtrack"}, function(args, speaker)
	if tonumber(args[1]) then
		settings():GetService("NetworkSettings").IncomingReplicationLag = args[1]
	end
end)

addcmd("noprompts", {"nopurchaseprompts"}, function(args, speaker)
	COREGUI.PurchasePromptApp.Enabled = false
end)

addcmd("showprompts", {"showpurchaseprompts"}, function(args, speaker)
	COREGUI.PurchasePromptApp.Enabled = true
end)

promptNewRig = function(speaker, rig)
	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		AvatarEditorService:PromptSaveAvatar(humanoid.HumanoidDescription, Enum.HumanoidRigType[rig])
		local result = AvatarEditorService.PromptSaveAvatarCompleted:Wait()
		if result == Enum.AvatarPromptResult.Success then
			execCmd("reset")
		end
	end
end

addcmd("promptr6", {}, function(args, speaker)
	promptNewRig(speaker, "R6")
end)

addcmd("promptr15", {}, function(args, speaker)
	promptNewRig(speaker, "R15")
end)

addcmd("wallwalk", {"walkonwalls"}, function(args, speaker)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/wallwalker.lua"))()
end)

addcmd('age',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	local ages = {}
	for i,v in pairs(players) do
		local p = Players[v]
		table.insert(ages, p.Name.."'s age is: "..p.AccountAge)
	end
	notify('Account Age',table.concat(ages, ',\n'))
end)

addcmd('chatage',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	local ages = {}
	for i,v in pairs(players) do
		local p = Players[v]
		table.insert(ages, p.Name.."'s age is: "..p.AccountAge)
	end
	local chatString = table.concat(ages, ', ')
	chatMessage(chatString)
end)

addcmd('joindate',{'jd'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	local dates = {}
	notify("Loading",'Hold on a sec')
	for i,v in pairs(players) do
		local user = game:HttpGet("https://users.roblox.com/v1/users/"..Players[v].UserId)
		local json = HttpService:JSONDecode(user)
		local date = json["created"]:sub(1,10)
		local splitDates = string.split(date,"-")
		table.insert(dates,Players[v].Name.." joined: "..splitDates[2].."/"..splitDates[3].."/"..splitDates[1])
	end
	notify('Join Date (Month/Day/Year)',table.concat(dates, ',\n'))
end)

addcmd('chatjoindate',{'cjd'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	local dates = {}
	notify("Loading",'Hold on a sec')
	for i,v in pairs(players) do
		local user = game:HttpGet("https://users.roblox.com/v1/users/"..Players[v].UserId)
		local json = HttpService:JSONDecode(user)
		local date = json["created"]:sub(1,10)
		local splitDates = string.split(date,"-")
		table.insert(dates,Players[v].Name.." joined: "..splitDates[2].."/"..splitDates[3].."/"..splitDates[1])
	end
	local chatString = table.concat(dates, ', ')
	chatMessage(chatString)
end)

addcmd('copyname',{'copyuser'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local name = tostring(Players[v].Name)
		toClipboard(name)
	end
end)

addcmd('userid',{'id'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local id = tostring(Players[v].UserId)
		notify('User ID',id)
	end
end)

addcmd('copyid',{'copyuserid'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local id = tostring(Players[v].UserId)
		toClipboard(id)
	end
end)

addcmd('creatorid',{'creator'},function(args, speaker)
	if game.CreatorType == Enum.CreatorType.User then
		notify('Creator ID',game.CreatorId)
	elseif game.CreatorType == Enum.CreatorType.Group then
		local OwnerID = GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Id
		speaker.UserId = OwnerID
		notify('Creator ID',OwnerID)
	end
end)

addcmd('copycreatorid',{'copycreator'},function(args, speaker)
	if game.CreatorType == Enum.CreatorType.User then
		toClipboard(game.CreatorId)
		notify('Copied ID','Copied creator ID to clipboard')
	elseif game.CreatorType == Enum.CreatorType.Group then
		local OwnerID = GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Id
		toClipboard(OwnerID)
		notify('Copied ID','Copied creator ID to clipboard')
	end
end)

addcmd('setcreatorid',{'setcreator'},function(args, speaker)
	if game.CreatorType == Enum.CreatorType.User then
		speaker.UserId = game.CreatorId
		notify('Set ID','Set UserId to '..game.CreatorId)
	elseif game.CreatorType == Enum.CreatorType.Group then
		local OwnerID = GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Id
		speaker.UserId = OwnerID
		notify('Set ID','Set UserId to '..OwnerID)
	end
end)

addcmd('appearanceid',{'aid'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local aid = tostring(Players[v].CharacterAppearanceId)
		notify('Appearance ID',aid)
	end
end)

addcmd('copyappearanceid',{'caid'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local aid = tostring(Players[v].CharacterAppearanceId)
		toClipboard(aid)
	end
end)

addcmd('norender',{},function(args, speaker)
	RunService:Set3dRenderingEnabled(false)
end)

addcmd('render',{},function(args, speaker)
	RunService:Set3dRenderingEnabled(true)
end)

addcmd('2022materials',{'use2022materials'},function(args, speaker)
	if sethidden then
		sethidden(MaterialService, "Use2022Materials", true)
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing sethiddenproperty)')
	end
end)

addcmd('un2022materials',{'unuse2022materials'},function(args, speaker)
	if sethidden then
		sethidden(MaterialService, "Use2022Materials", false)
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing sethiddenproperty)')
	end
end)

addcmd('goto',{'to'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
		end
	end
	execCmd('breakvelocity')
end)

addcmd('tweengoto',{'tgoto','tto','tweento'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)}):Play()
		end
	end
	execCmd('breakvelocity')
end)

addcmd('vehiclegoto',{'vgoto','vtp','vehicletp'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			local seat = speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart
			local vehicleModel = seat:FindFirstAncestorWhichIsA("Model")
			vehicleModel:MoveTo(getRoot(Players[v].Character).Position)
		end
	end
end)

addcmd('pulsetp',{'ptp'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			local startPos = getRoot(speaker.Character).CFrame
			local seconds = args[2] or 1
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
			wait(seconds)
			getRoot(speaker.Character).CFrame = startPos
		end
	end
	execCmd('breakvelocity')
end)

local vnoclipParts = {}
addcmd('vehiclenoclip',{'vnoclip'},function(args, speaker)
	vnoclipParts = {}
	local seat = speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart
	local vehicleModel = seat.Parent
	repeat
		if vehicleModel.ClassName ~= "Model" then
			vehicleModel = vehicleModel.Parent
		end
	until vehicleModel.ClassName == "Model"
	wait(0.1)
	execCmd('noclip')
	for i,v in pairs(vehicleModel:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide then
			table.insert(vnoclipParts,v)
			v.CanCollide = false
		end
	end
end)

addcmd("vehicleclip", {"vclip", "unvnoclip", "unvehiclenoclip"}, function(args, speaker)
	execCmd("clip")
	for i, v in pairs(vnoclipParts) do
		v.CanCollide = true
	end
	vnoclipParts = {}
end)

addcmd("togglevnoclip", {}, function(args, speaker)
	execCmd(Clip and "vnoclip" or "vclip")
end)

addcmd('clientbring',{'cbring'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			if Players[v].Character:FindFirstChildOfClass('Humanoid') then
				Players[v].Character:FindFirstChildOfClass('Humanoid').Sit = false
			end
			wait()
			getRoot(Players[v].Character).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(3,1,0)
		end
	end
end)

local bringT = {}
addcmd('loopbring',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		task.spawn(function()
			if Players[v].Name ~= speaker.Name and not FindInTable(bringT, Players[v].Name) then
				table.insert(bringT, Players[v].Name)
				local plrName = Players[v].Name
				local pchar=Players[v].Character
				local distance = 3
				if args[2] and isNumber(args[2]) then
					distance = args[2]
				end
				local lDelay = 0
				if args[3] and isNumber(args[3]) then
					lDelay = args[3]
				end
				repeat
					for i,c in pairs(players) do
						if Players:FindFirstChild(v) then
							pchar = Players[v].Character
							if pchar~= nil and Players[v].Character ~= nil and getRoot(pchar) and speaker.Character ~= nil and getRoot(speaker.Character) then
								getRoot(pchar).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(distance,1,0)
							end
							wait(lDelay)
						else 
							for a,b in pairs(bringT) do if b == plrName then table.remove(bringT, a) end end
						end
					end
				until not FindInTable(bringT, plrName)
			end
		end)
	end
end)

addcmd('unloopbring',{'noloopbring'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		task.spawn(function()
			for a,b in pairs(bringT) do if b == Players[v].Name then table.remove(bringT, a) end end
		end)
	end
end)

local walkto = false
local waypointwalkto = false
addcmd('walkto',{'follow'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			walkto = true
			repeat wait()
				speaker.Character:FindFirstChildOfClass('Humanoid'):MoveTo(getRoot(Players[v].Character).Position)
			until Players[v].Character == nil or not getRoot(Players[v].Character) or walkto == false
		end
	end
end)

addcmd('pathfindwalkto',{'pathfindfollow'},function(args, speaker)
	walkto = false
	wait()
	local players = getPlayer(args[1], speaker)
	local hum = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local path = PathService:CreatePath()
	for i,v in pairs(players)do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			walkto = true
			repeat wait()
				local success, response = pcall(function()
					path:ComputeAsync(getRoot(speaker.Character).Position, getRoot(Players[v].Character).Position)
					local waypoints = path:GetWaypoints()
					local distance 
					for waypointIndex, waypoint in pairs(waypoints) do
						local waypointPosition = waypoint.Position
						hum:MoveTo(waypointPosition)
						repeat 
							distance = (waypointPosition - hum.Parent.PrimaryPart.Position).magnitude
							wait()
						until
						distance <= 5
					end	 
				end)
				if not success then
					speaker.Character:FindFirstChildOfClass('Humanoid'):MoveTo(getRoot(Players[v].Character).Position)
				end
			until Players[v].Character == nil or not getRoot(Players[v].Character) or walkto == false
		end
	end
end)

addcmd('pathfindwalktowaypoint',{'pathfindwalktowp'},function(args, speaker)
	waypointwalkto = false
	wait()
	local WPName = tostring(getstring(1))
	local hum = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local path = PathService:CreatePath()
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				local TrueCoords = Vector3.new(WayPoints[i].COORD[1], WayPoints[i].COORD[2], WayPoints[i].COORD[3])
				waypointwalkto = true
				repeat wait()
					local success, response = pcall(function()
						path:ComputeAsync(getRoot(speaker.Character).Position, TrueCoords)
						local waypoints = path:GetWaypoints()
						local distance 
						for waypointIndex, waypoint in pairs(waypoints) do
							local waypointPosition = waypoint.Position
							hum:MoveTo(waypointPosition)
							repeat 
								distance = (waypointPosition - hum.Parent.PrimaryPart.Position).magnitude
								wait()
							until
							distance <= 5
						end
					end)
					if not success then
						speaker.Character:FindFirstChildOfClass('Humanoid'):MoveTo(TrueCoords)
					end
				until not speaker.Character or waypointwalkto == false
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				local TrueCoords = pWayPoints[i].COORD[1].Position
				waypointwalkto = true
				repeat wait()
					local success, response = pcall(function()
						path:ComputeAsync(getRoot(speaker.Character).Position, TrueCoords)
						local waypoints = path:GetWaypoints()
						local distance 
						for waypointIndex, waypoint in pairs(waypoints) do
							local waypointPosition = waypoint.Position
							hum:MoveTo(waypointPosition)
							repeat 
								distance = (waypointPosition - hum.Parent.PrimaryPart.Position).magnitude
								wait()
							until
							distance <= 5
						end
					end)
					if not success then
						speaker.Character:FindFirstChildOfClass('Humanoid'):MoveTo(TrueCoords)
					end
				until not speaker.Character or waypointwalkto == false
			end
		end
	end
end)

addcmd('unwalkto',{'nowalkto','unfollow','nofollow'},function(args, speaker)
	walkto = false
	waypointwalkto = false
end)

addcmd("orbit", {}, function(args, speaker)
    execCmd("unorbit nonotify")
    local target = Players:FindFirstChild(getPlayer(args[1], speaker)[1])
    local root = getRoot(speaker.Character)
    local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
    if target and target.Character and getRoot(target.Character) and root and humanoid then
        local rotation = 0
        local speed = tonumber(args[2]) or 0.2
        local distance = tonumber(args[3]) or 6
        orbit1 = RunService.Heartbeat:Connect(function()
            pcall(function()
                rotation = rotation + speed
                root.CFrame = CFrame.new(getRoot(target.Character).Position) * CFrame.Angles(0, math.rad(rotation), 0) * CFrame.new(distance, 0, 0)
            end)
        end)
        orbit2 = RunService.RenderStepped:Connect(function()
            pcall(function()
                root.CFrame = CFrame.new(root.Position, getRoot(target.Character).Position)
            end)
        end)
        orbit3 = humanoid.Died:Connect(function() execCmd("unorbit") end)
        orbit4 = humanoid.Seated:Connect(function(value) if value then execCmd("unorbit") end end)
        notify("Orbit", "Started orbiting " .. formatUsername(target))
    end
end)

addcmd("unorbit", {}, function(args, speaker)
    if orbit1 then orbit1:Disconnect() end
    if orbit2 then orbit2:Disconnect() end
    if orbit3 then orbit3:Disconnect() end
    if orbit4 then orbit4:Disconnect() end
    if args[1] ~= "nonotify" then notify("Orbit", "Stopped orbiting player") end
end)

addcmd('freeze',{'fr'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if players ~= nil then
		for i,v in pairs(players) do
			task.spawn(function()
				for i, x in next, Players[v].Character:GetDescendants() do
					if x:IsA("BasePart") and not x.Anchored then
						x.Anchored = true
					end
				end
			end)
		end
	end
end)


addcmd('thaw',{'unfreeze','unfr'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if players ~= nil then
		for i,v in pairs(players) do
			task.spawn(function()
				for i, x in next, Players[v].Character:GetDescendants() do
					if x.Name ~= floatName and x:IsA("BasePart") and x.Anchored then
						x.Anchored = false
					end
				end
			end)
		end
	end
end)

oofing = false
addcmd('loopoof',{},function(args, speaker)
	oofing = true
	repeat wait(0.1)
		for i,v in pairs(Players:GetPlayers()) do
			if v.Character ~= nil and v.Character:FindFirstChild'Head' then
				for _,x in pairs(v.Character.Head:GetChildren()) do
					if x:IsA'Sound' then x.Playing = true end
				end
			end
		end
	until oofing == false
end)

addcmd('unloopoof',{},function(args, speaker)
	oofing = false
end)

local notifiedRespectFiltering = false
addcmd('muteboombox',{},function(args, speaker)
	if not notifiedRespectFiltering and SoundService.RespectFilteringEnabled then notifiedRespectFiltering = true notify('RespectFilteringEnabled','RespectFilteringEnabled is set to true (the command will still work but may only be clientsided)') end
	local players = getPlayer(args[1], speaker)
	if players ~= nil then
		for i,v in pairs(players) do
			task.spawn(function()
				for i, x in next, Players[v].Character:GetDescendants() do
					if x:IsA("Sound") and x.Playing == true then
						x.Playing = false
					end
				end
				for i, x in next, Players[v]:FindFirstChildOfClass("Backpack"):GetDescendants() do
					if x:IsA("Sound") and x.Playing == true then
						x.Playing = false
					end
				end
			end)
		end
	end
end)

addcmd('unmuteboombox',{},function(args, speaker)
	if not notifiedRespectFiltering and SoundService.RespectFilteringEnabled then notifiedRespectFiltering = true notify('RespectFilteringEnabled','RespectFilteringEnabled is set to true (the command will still work but may only be clientsided)') end
	local players = getPlayer(args[1], speaker)
	if players ~= nil then
		for i,v in pairs(players) do
			task.spawn(function()
				for i, x in next, Players[v].Character:GetDescendants() do
					if x:IsA("Sound") and x.Playing == false then
						x.Playing = true
					end
				end
			end)
		end
	end
end)

addcmd("reset", {}, function(args, speaker)
    local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
    if replicatesignal then
        replicatesignal(speaker.Kill)
    elseif humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    else
        speaker.Character:BreakJoints()
    end
end)

addcmd('freezeanims',{},function(args, speaker)
	local Humanoid = speaker.Character:FindFirstChildOfClass("Humanoid") or speaker.Character:FindFirstChildOfClass("AnimationController")
	local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
	for _, v in pairs(ActiveTracks) do
		v:AdjustSpeed(0)
	end
end)

addcmd('unfreezeanims',{},function(args, speaker)
	local Humanoid = speaker.Character:FindFirstChildOfClass("Humanoid") or speaker.Character:FindFirstChildOfClass("AnimationController")
	local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
	for _, v in pairs(ActiveTracks) do
		v:AdjustSpeed(1)
	end
end)

addcmd("respawn", {}, function(args, speaker)
    respawn(speaker)
end)

addcmd("refresh", {"re"}, function(args, speaker)
    refresh(speaker)
end)

addcmd("god", {}, function(args, speaker)
    permadeath(speaker)
    local Cam = workspace.CurrentCamera
    local Char, Pos = speaker.Character, Cam.CFrame
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    local nHuman = Human:Clone()
    nHuman.Parent = char
    speaker.Character = nil
    nHuman:SetStateEnabled(15, false)
    nHuman:SetStateEnabled(1, false)
    nHuman:SetStateEnabled(0, false)
    nHuman.BreakJointsOnDeath = true
    Human:Destroy()
    speaker.Character = char
    Cam.CameraSubject = nHuman
    Cam.CFrame = task.wait() and pos
    nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local Script = Char:FindFirstChild("Animate")
    if Script then
        Script.Disabled = true
        task.wait()
        Script.Disabled = false
    end
    nHuman.Health = nHuman.MaxHealth
end)

invisRunning = false
addcmd('invisible',{'invis'},function(args, speaker)
	if invisRunning then return end
	invisRunning = true
	-- Full credit to AmokahFox @V3rmillion
	local Player = speaker
	repeat wait(.1) until Player.Character
	local Character = Player.Character
	Character.Archivable = true
	local IsInvis = false
	local IsRunning = true
	local InvisibleCharacter = Character:Clone()
	InvisibleCharacter.Parent = Lighting
	local Void = workspace.FallenPartsDestroyHeight
	InvisibleCharacter.Name = ""
	local CF

	local invisFix = RunService.Stepped:Connect(function()
		pcall(function()
			local IsInteger
			if tostring(Void):find'-' then
				IsInteger = true
			else
				IsInteger = false
			end
			local Pos = Player.Character.HumanoidRootPart.Position
			local Pos_String = tostring(Pos)
			local Pos_Seperate = Pos_String:split(', ')
			local X = tonumber(Pos_Seperate[1])
			local Y = tonumber(Pos_Seperate[2])
			local Z = tonumber(Pos_Seperate[3])
			if IsInteger == true then
				if Y <= Void then
					Respawn()
				end
			elseif IsInteger == false then
				if Y >= Void then
					Respawn()
				end
			end
		end)
	end)

	for i,v in pairs(InvisibleCharacter:GetDescendants())do
		if v:IsA("BasePart") then
			if v.Name == "HumanoidRootPart" then
				v.Transparency = 1
			else
				v.Transparency = .5
			end
		end
	end

	function Respawn()
		IsRunning = false
		if IsInvis == true then
			pcall(function()
				Player.Character = Character
				wait()
				Character.Parent = workspace
				Character:FindFirstChildWhichIsA'Humanoid':Destroy()
				IsInvis = false
				InvisibleCharacter.Parent = nil
				invisRunning = false
			end)
		elseif IsInvis == false then
			pcall(function()
				Player.Character = Character
				wait()
				Character.Parent = workspace
				Character:FindFirstChildWhichIsA'Humanoid':Destroy()
				TurnVisible()
			end)
		end
	end

	local invisDied
	invisDied = InvisibleCharacter:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
		Respawn()
		invisDied:Disconnect()
	end)

	if IsInvis == true then return end
	IsInvis = true
	CF = workspace.CurrentCamera.CFrame
	local CF_1 = Player.Character.HumanoidRootPart.CFrame
	Character:MoveTo(Vector3.new(0,math.pi*1000000,0))
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	wait(.2)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	InvisibleCharacter = InvisibleCharacter
	Character.Parent = Lighting
	InvisibleCharacter.Parent = workspace
	InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
	Player.Character = InvisibleCharacter
	execCmd('fixcam')
	Player.Character.Animate.Disabled = true
	Player.Character.Animate.Disabled = false

	function TurnVisible()
		if IsInvis == false then return end
		invisFix:Disconnect()
		invisDied:Disconnect()
		CF = workspace.CurrentCamera.CFrame
		Character = Character
		local CF_1 = Player.Character.HumanoidRootPart.CFrame
		Character.HumanoidRootPart.CFrame = CF_1
		InvisibleCharacter:Destroy()
		Player.Character = Character
		Character.Parent = workspace
		IsInvis = false
		Player.Character.Animate.Disabled = true
		Player.Character.Animate.Disabled = false
		invisDied = Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
			Respawn()
			invisDied:Disconnect()
		end)
		invisRunning = false
	end
	notify('Invisible','You now appear invisible to other players')
end)

addcmd("visible", {"vis","uninvisible"}, function(args, speaker)
	TurnVisible()
end)

addcmd("toggleinvis", {}, function(args, speaker)
	execCmd(invisRunning and "visible" or "invisible")
end)

addcmd('toolinvisible',{'toolinvis','tinvis'},function(args, speaker)
	local Char  = Players.LocalPlayer.Character
	local touched = false
	local tpdback = false
	local box = Instance.new('Part')
	box.Anchored = true
	box.CanCollide = true
	box.Size = Vector3.new(10,1,10)
	box.Position = Vector3.new(0,10000,0)
	box.Parent = workspace
	local boxTouched = box.Touched:connect(function(part)
		if (part.Parent.Name == Players.LocalPlayer.Name) then
			if touched == false then
				touched = true
				local function apply()
					local no = Char.HumanoidRootPart:Clone()
					wait(.25)
					Char.HumanoidRootPart:Destroy()
					no.Parent = Char
					Char:MoveTo(loc)
					touched = false
				end
				if Char then
					apply()
				end
			end
		end
	end)
	repeat wait() until Char
	local cleanUp
	cleanUp = Players.LocalPlayer.CharacterAdded:connect(function(char)
		boxTouched:Disconnect()
		box:Destroy()
		cleanUp:Disconnect()
	end)
	loc = Char.HumanoidRootPart.Position
	Char:MoveTo(box.Position + Vector3.new(0,.5,0))
end)

addcmd("strengthen", {}, function(args, speaker)
	for _, child in pairs(speaker.Character:GetDescendants()) do
		if child.ClassName == "Part" then
			if args[1] then
				child.CustomPhysicalProperties = PhysicalProperties.new(args[1], 0.3, 0.5)
			else
				child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
			end
		end
	end
end)

addcmd("weaken", {}, function(args, speaker)
	for _, child in pairs(speaker.Character:GetDescendants()) do
		if child.ClassName == "Part" then
			if args[1] then
				child.CustomPhysicalProperties = PhysicalProperties.new(-args[1], 0.3, 0.5)
			else
				child.CustomPhysicalProperties = PhysicalProperties.new(0, 0.3, 0.5)
			end
		end
	end
end)

addcmd("unweaken", {"unstrengthen"}, function(args, speaker)
	for _, child in pairs(speaker.Character:GetDescendants()) do
		if child.ClassName == "Part" then
			child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		end
	end
end)

addcmd("breakvelocity", {}, function(args, speaker)
	local BeenASecond, V3 = false, Vector3.new(0, 0, 0)
	delay(1, function()
		BeenASecond = true
	end)
	while not BeenASecond do
		for _, v in ipairs(speaker.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Velocity, v.RotVelocity = V3, V3
			end
		end
		wait()
	end
end)

addcmd('jpower',{'jumppower','jp'},function(args, speaker)
	local jpower = args[1] or 50
	if isNumber(jpower) then
		if speaker.Character:FindFirstChildOfClass('Humanoid').UseJumpPower then
			speaker.Character:FindFirstChildOfClass('Humanoid').JumpPower = jpower
		else
			speaker.Character:FindFirstChildOfClass('Humanoid').JumpHeight  = jpower
		end
	end
end)

addcmd("maxslopeangle", {"msa"}, function(args, speaker)
	local sangle = args[1] or 89
	if isNumber(sangle) then
		speaker.Character:FindFirstChildWhichIsA("Humanoid").MaxSlopeAngle = sangle
	end
end)

addcmd("gravity", {"grav"}, function(args, speaker)
	local grav = args[1] or 196.2
	if isNumber(grav) then
		workspace.Gravity = grav
	end
end)

addcmd("hipheight", {"hheight"}, function(args, speaker)
	speaker.Character:FindFirstChildWhichIsA("Humanoid").HipHeight = args[1] or (r15(speaker) and 2.1 or 0)
end)

addcmd("dance", {}, function(args, speaker)
	pcall(execCmd, "undance")
	local dances = {"27789359", "30196114", "248263260", "45834924", "33796059", "28488254", "52155728"}
	if r15(speaker) then
		dances = {"3333432454", "4555808220", "4049037604", "4555782893", "10214311282", "10714010337", "10713981723", "10714372526", "10714076981", "10714392151", "11444443576"}
	end
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. dances[math.random(1, #dances)]
	danceTrack = speaker.Character:FindFirstChildWhichIsA("Humanoid"):LoadAnimation(animation)
	danceTrack.Looped = true
	danceTrack:Play()
end)

addcmd("undance", {"nodance"}, function(args, speaker)
	danceTrack:Stop()
	danceTrack:Destroy()
end)

addcmd('nolimbs',{'rlimbs'},function(args, speaker)
	if r15(speaker) then
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "RightUpperLeg" or
				v.Name == "LeftUpperLeg" or
				v.Name == "RightUpperArm" or
				v.Name == "LeftUpperArm" then
				v:Destroy()
			end
		end
	else
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Leg" or
				v.Name == "Left Leg" or
				v.Name == "Right Arm" or
				v.Name == "Left Arm" then
				v:Destroy()
			end
		end
	end
end)

addcmd('noarms',{'rarms'},function(args, speaker)
	if r15(speaker) then
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "RightUpperArm" or
				v.Name == "LeftUpperArm" then
				v:Destroy()
			end
		end
	else
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Arm" or
				v.Name == "Left Arm" then
				v:Destroy()
			end
		end
	end
end)

addcmd('nolegs',{'rlegs'},function(args, speaker)
	if r15(speaker) then
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "RightUpperLeg" or
				v.Name == "LeftUpperLeg" then
				v:Destroy()
			end
		end
	else
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Leg" or
				v.Name == "Left Leg" then
				v:Destroy()
			end
		end
	end
end)

addcmd("sit", {}, function(args, speaker)
	speaker.Character:FindFirstChildWhichIsA("Humanoid").Sit = true
end)

addcmd("lay", {"laydown"}, function(args, speaker)
	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	humanoid.Sit = true
	task.wait(0.1)
	humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
	for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end)

addcmd("sitwalk", {}, function(args, speaker)
	local anims = speaker.Character.Animate
	local sit = anims.sit:FindFirstChildWhichIsA("Animation").AnimationId
	anims.idle:FindFirstChildWhichIsA("Animation").AnimationId = sit
	anims.walk:FindFirstChildWhichIsA("Animation").AnimationId = sit
	anims.run:FindFirstChildWhichIsA("Animation").AnimationId = sit
	anims.jump:FindFirstChildWhichIsA("Animation").AnimationId = sit
	speaker.Character:FindFirstChildWhichIsA("Humanoid").HipHeight = not r15(speaker) and -1.5 or 0.5
end)

addcmd("nosit", {}, function(args, speaker)
    speaker.Character:FindFirstChildWhichIsA("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false)
end)

addcmd("unnosit", {}, function(args, speaker)
    speaker.Character:FindFirstChildWhichIsA("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, true)
end)

addcmd("jump", {}, function(args, speaker)
	speaker.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end)

local infJump
infJumpDebounce = false
addcmd("infjump", {"infinitejump"}, function(args, speaker)
	if infJump then infJump:Disconnect() end
	infJumpDebounce = false
	infJump = UserInputService.JumpRequest:Connect(function()
		if not infJumpDebounce then
			infJumpDebounce = true
			speaker.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			wait()
			infJumpDebounce = false
		end
	end)
end)

addcmd("uninfjump", {"uninfinitejump", "noinfjump", "noinfinitejump"}, function(args, speaker)
	if infJump then infJump:Disconnect() end
	infJumpDebounce = false
end)

local flyjump
addcmd("flyjump", {}, function(args, speaker)
	if flyjump then flyjump:Disconnect() end
	flyjump = UserInputService.JumpRequest:Connect(function()
		speaker.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end)

addcmd("unflyjump", {"noflyjump"}, function(args, speaker)
	if flyjump then flyjump:Disconnect() end
end)

local HumanModCons = {}
addcmd('autojump',{'ajump'},function(args, speaker)
	local Char = speaker.Character
	local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
	local function autoJump()
		if Char and Human then
			local check1 = workspace:FindPartOnRay(Ray.new(Human.RootPart.Position-Vector3.new(0,1.5,0), Human.RootPart.CFrame.lookVector*3), Human.Parent)
			local check2 = workspace:FindPartOnRay(Ray.new(Human.RootPart.Position+Vector3.new(0,1.5,0), Human.RootPart.CFrame.lookVector*3), Human.Parent)
			if check1 or check2 then
				Human.Jump = true
			end
		end
	end
	autoJump()
	HumanModCons.ajLoop = (HumanModCons.ajLoop and HumanModCons.ajLoop:Disconnect() and false) or RunService.RenderStepped:Connect(autoJump)
	HumanModCons.ajCA = (HumanModCons.ajCA and HumanModCons.ajCA:Disconnect() and false) or speaker.CharacterAdded:Connect(function(nChar)
		Char, Human = nChar, nChar:WaitForChild("Humanoid")
		autoJump()
		HumanModCons.ajLoop = (HumanModCons.ajLoop and HumanModCons.ajLoop:Disconnect() and false) or RunService.RenderStepped:Connect(autoJump)
	end)
end)

addcmd('unautojump',{'noautojump', 'noajump', 'unajump'},function(args, speaker)
	HumanModCons.ajLoop = (HumanModCons.ajLoop and HumanModCons.ajLoop:Disconnect() and false) or nil
	HumanModCons.ajCA = (HumanModCons.ajCA and HumanModCons.ajCA:Disconnect() and false) or nil
end)

addcmd('edgejump',{'ejump'},function(args, speaker)
	local Char = speaker.Character
	local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
	-- Full credit to NoelGamer06 @V3rmillion
	local state
	local laststate
	local lastcf
	local function edgejump()
		if Char and Human then
			laststate = state
			state = Human:GetState()
			if laststate ~= state and state == Enum.HumanoidStateType.Freefall and laststate ~= Enum.HumanoidStateType.Jumping then
				Char.HumanoidRootPart.CFrame = lastcf
				Char.HumanoidRootPart.Velocity = Vector3.new(Char.HumanoidRootPart.Velocity.X, Human.JumpPower or Human.JumpHeight, Char.HumanoidRootPart.Velocity.Z)
			end
			lastcf = Char.HumanoidRootPart.CFrame
		end
	end
	edgejump()
	HumanModCons.ejLoop = (HumanModCons.ejLoop and HumanModCons.ejLoop:Disconnect() and false) or RunService.RenderStepped:Connect(edgejump)
	HumanModCons.ejCA = (HumanModCons.ejCA and HumanModCons.ejCA:Disconnect() and false) or speaker.CharacterAdded:Connect(function(nChar)
		Char, Human = nChar, nChar:WaitForChild("Humanoid")
		edgejump()
		HumanModCons.ejLoop = (HumanModCons.ejLoop and HumanModCons.ejLoop:Disconnect() and false) or RunService.RenderStepped:Connect(edgejump)
	end)
end)

addcmd('unedgejump',{'noedgejump', 'noejump', 'unejump'},function(args, speaker)
	HumanModCons.ejLoop = (HumanModCons.ejLoop and HumanModCons.ejLoop:Disconnect() and false) or nil
	HumanModCons.ejCA = (HumanModCons.ejCA and HumanModCons.ejCA:Disconnect() and false) or nil
end)

addcmd("team", {}, function(args, speaker)
    local teamName = getstring(1)
    local team = nil
    local root = speaker.Character and getRoot(speaker.Character)
    for _, v in ipairs(Teams:GetChildren()) do
        if v.Name:lower():match(teamName:lower()) then
            team = v
            break
        end
    end
    if not team then
        return notify("Invalid Team", teamName .. " is not a valid team")
    end
    if root and firetouchinterest then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("SpawnLocation") and v.BrickColor == team.TeamColor and v.AllowTeamChangeOnTouch == true then
                firetouchinterest(v, root, 0)
                firetouchinterest(v, root, 1)
                break
            end
        end
    else
        speaker.Team = team
    end
end)

addcmd('nobgui',{'unbgui','nobillboardgui','unbillboardgui','noname','rohg'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants())do
		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v:Destroy()
		end
	end
end)

addcmd('loopnobgui',{'loopunbgui','loopnobillboardgui','loopunbillboardgui','loopnoname','looprohg'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants())do
		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v:Destroy()
		end
	end
	local function charPartAdded(part)
		if part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
			wait()
			part:Destroy()
		end
	end
	charPartTrigger = speaker.Character.DescendantAdded:Connect(charPartAdded)
end)

addcmd('unloopnobgui',{'unloopunbgui','unloopnobillboardgui','unloopunbillboardgui','unloopnoname','unlooprohg'},function(args, speaker)
	if charPartTrigger then
		charPartTrigger:Disconnect()
	end
end)

addcmd('spasm',{},function(args, speaker)
	if not r15(speaker) then
		local pchar=speaker.Character
		local AnimationId = "33796059"
		SpasmAnim = Instance.new("Animation")
		SpasmAnim.AnimationId = "rbxassetid://"..AnimationId
		Spasm = pchar:FindFirstChildOfClass('Humanoid'):LoadAnimation(SpasmAnim)
		Spasm:Play()
		Spasm:AdjustSpeed(99)
	else
		notify('R6 Required','This command requires the r6 rig type')
	end
end)

addcmd('unspasm',{'nospasm'},function(args, speaker)
	Spasm:Stop()
	SpasmAnim:Destroy()
end)

addcmd('headthrow',{},function(args, speaker)
	if not r15(speaker) then
		local AnimationId = "35154961"
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..AnimationId
		local k = speaker.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(Anim)
		k:Play(0)
		k:AdjustSpeed(1)
	else
		notify('R6 Required','This command requires the r6 rig type')
	end
end)

addcmd('animation',{'anim'},function(args, speaker)
	if not r15(speaker) then
		local pchar=speaker.Character
		local AnimationId = tostring(args[1])
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..AnimationId
		local k = pchar:FindFirstChildOfClass('Humanoid'):LoadAnimation(Anim)
		k:Play()
		if args[2] then
			k:AdjustSpeed(tostring(args[2]))
		end
	else
		notify('R6 Required','This command requires the r6 rig type')
	end
end)

addcmd('noanim',{},function(args, speaker)
	speaker.Character.Animate.Disabled = true
end)

addcmd('reanim',{},function(args, speaker)
	speaker.Character.Animate.Disabled = false
end)

addcmd('animspeed',{},function(args, speaker)
	local Char = speaker.Character
	local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

	for i,v in next, Hum:GetPlayingAnimationTracks() do
		v:AdjustSpeed(tonumber(args[1] or 1))
	end
end)

addcmd('copyanimation',{'copyanim','copyemote'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for _,v in ipairs(players)do
		local char = Players[v].Character
		for _, v1 in pairs(speaker.Character:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks()) do
			v1:Stop()
		end
		for _, v1 in pairs(Players[v].Character:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks()) do
			if not string.find(v1.Animation.AnimationId, "507768375") then
				local ANIM = speaker.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(v1.Animation)
				ANIM:Play(.1, 1, v1.Speed)
				ANIM.TimePosition = v1.TimePosition
				task.spawn(function()
					v1.Stopped:Wait()
					ANIM:Stop()
					ANIM:Destroy()
				end)
			end
		end
	end
end)

addcmd("copyanimationid", {"copyanimid", "copyemoteid"}, function(args, speaker)
    local copyAnimId = function(player)
        local found = "Animations Copied"

        for _, v in pairs(player.Character:FindFirstChildWhichIsA("Humanoid"):GetPlayingAnimationTracks()) do
            local animationId = v.Animation.AnimationId
            local assetId = animationId:find("rbxassetid://") and animationId:match("%d+")

            if not string.find(animationId, "507768375") and not string.find(animationId, "180435571") then
                if assetId then
                    local success, result = pcall(function()
                        return MarketplaceService:GetProductInfo(tonumber(assetId)).Name
                    end)
                    local name = success and result or "Failed to get name"
                    found = found .. "\n\nName: " .. name .. "\nAnimation Id: " .. animationId
                else
                    found = found .. "\n\nAnimation Id: " .. animationId
                end
            end
        end

        if found ~= "Animations Copied" then
            toClipboard(found)
        else
            notify("Animations", "No animations to copy")
        end
    end

    if args[1] then
        copyAnimId(Players[getPlayer(args[1], speaker)[1]])
    else
        copyAnimId(speaker)
    end
end)

addcmd('stopanimations',{'stopanims','stopanim'},function(args, speaker)
	local Char = speaker.Character
	local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

	for i,v in next, Hum:GetPlayingAnimationTracks() do
		v:Stop()
	end
end)

addcmd('refreshanimations', {'refreshanimation', 'refreshanims', 'refreshanim'}, function(args, speaker)
	local Char = speaker.Character or speaker.CharacterAdded:Wait()
	local Human = Char and Char:WaitForChild('Humanoid', 15)
	local Animate = Char and Char:WaitForChild('Animate', 15)
	if not Human or not Animate then
		return notify('Refresh Animations', 'Failed to get Animate/Humanoid')
	end
	Animate.Disabled = true
	for _, v in ipairs(Human:GetPlayingAnimationTracks()) do
		v:Stop()
	end
	Animate.Disabled = false
end)

addcmd('allowcustomanim', {'allowcustomanimations'}, function(args, speaker)
	StarterPlayer.AllowCustomAnimations = true
	execCmd('refreshanimations')
end)

addcmd('unallowcustomanim', {'unallowcustomanimations'}, function(args, speaker)
	StarterPlayer.AllowCustomAnimations = false
	execCmd('refreshanimations')
end)

addcmd('loopanimation', {'loopanim'},function(args, speaker)
	local Char = speaker.Character
	local Human = Char and Char.FindFirstChildWhichIsA(Char, "Humanoid")
	for _, v in ipairs(Human.GetPlayingAnimationTracks(Human)) do
		v.Looped = true
	end
end)

addcmd('tpposition',{'tppos'},function(args, speaker)
	if #args < 3 then return end
	local tpX,tpY,tpZ = tonumber((args[1]:gsub(",", ""))),tonumber((args[2]:gsub(",", ""))),tonumber((args[3]:gsub(",", "")))
	local char = speaker.Character
	if char and getRoot(char) then
		getRoot(char).CFrame = CFrame.new(tpX,tpY,tpZ)
	end
end)

addcmd('tweentpposition',{'ttppos'},function(args, speaker)
	if #args < 3 then return end
	local tpX,tpY,tpZ = tonumber((args[1]:gsub(",", ""))),tonumber((args[2]:gsub(",", ""))),tonumber((args[3]:gsub(",", "")))
	local char = speaker.Character
	if char and getRoot(char) then
		TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(tpX,tpY,tpZ)}):Play()
	end
end)

addcmd('offset',{},function(args, speaker)
	if #args < 3 then
		return 
	end
	if speaker.Character then
		speaker.Character:TranslateBy(Vector3.new(tonumber(args[1]) or 0, tonumber(args[2]) or 0, tonumber(args[3]) or 0))
	end
end)

addcmd('tweenoffset',{'toffset'},function(args, speaker)
	if #args < 3 then return end
	local tpX,tpY,tpZ = tonumber(args[1]),tonumber(args[2]),tonumber(args[3])
	local char = speaker.Character
	if char and getRoot(char) then
		TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(tpX,tpY,tpZ)}):Play()
	end
end)

addcmd('clickteleport',{},function(args, speaker)
	if speaker == Players.LocalPlayer then
		notify('Click TP','Go to Settings>Keybinds>Add to set up click tp')
	end
end)

addcmd("mouseteleport", {"mousetp"}, function(args, speaker)
    local root = getRoot(speaker.Character)
    local pos = IYMouse.Hit
    if root and pos then
        root.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z, select(4, root.CFrame:components()))
    end
end)

addcmd('tptool', {'teleporttool'}, function(args, speaker)
	local TpTool = Instance.new("Tool")
	TpTool.Name = "Teleport Tool"
	TpTool.RequiresHandle = false
	TpTool.Parent = speaker.Backpack
	TpTool.Activated:Connect(function()
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
		if not Char or not HRP then
			return warn("Failed to find HumanoidRootPart")
		end
		HRP.CFrame = CFrame.new(IYMouse.Hit.X, IYMouse.Hit.Y + 3, IYMouse.Hit.Z, select(4, HRP.CFrame:components()))
	end)
end)

addcmd('clickdelete',{},function(args, speaker)
	if speaker == Players.LocalPlayer then
		notify('Click Delete','Go to Settings>Keybinds>Add to set up click delete')
	end
end)

addcmd('getposition',{'getpos','notifypos','notifyposition'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		local char = Players[v].Character
		local pos = char and (getRoot(char) or char:FindFirstChildWhichIsA("BasePart"))
		pos = pos and pos.Position
		if not pos then
			return notify('Getposition Error','Missing character')
		end
		local roundedPos = math.round(pos.X) .. ", " .. math.round(pos.Y) .. ", " .. math.round(pos.Z)
		notify('Current Position',roundedPos)
	end
end)

addcmd('copyposition',{'copypos'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		local char = Players[v].Character
		local pos = char and (getRoot(char) or char:FindFirstChildWhichIsA("BasePart"))
		pos = pos and pos.Position
		if not pos then
			return notify('Getposition Error','Missing character')
		end
		local roundedPos = math.round(pos.X) .. ", " .. math.round(pos.Y) .. ", " .. math.round(pos.Z)
		toClipboard(roundedPos)
	end
end)

addcmd('walktopos',{'walktoposition'},function(args, speaker)
	if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
		speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
		wait(.1)
	end
	speaker.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = Vector3.new(args[1],args[2],args[3])
end)

addcmd('speed',{'ws','walkspeed'},function(args, speaker)
	if args[2] then
		local speed = args[2] or 16
		if isNumber(speed) then
			speaker.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = speed
		end
	else
		local speed = args[1] or 16
		if isNumber(speed) then
			speaker.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = speed
		end
	end
end)

addcmd('spoofspeed',{'spoofws','spoofwalkspeed'},function(args, speaker)
	if args[1] and isNumber(args[1]) then
		if hookmetamethod then
			local char = speaker.Character
			local setspeed;
			local index; index = hookmetamethod(game, "__index", function(self, key)
				if not checkcaller() and typeof(self) == "Instance" and self:IsA("Humanoid") and (key == "WalkSpeed" or key == "walkSpeed") and self:IsDescendantOf(char) then
					return setspeed or args[1]
				end
				return index(self, key)
			end)
			local newindex; newindex = hookmetamethod(game, "__newindex", function(self, key, value)
				if not checkcaller() and typeof(self) == "Instance" and self:IsA("Humanoid") and (key == "WalkSpeed" or key == "walkSpeed") and self:IsDescendantOf(char) then
					setspeed = tonumber(value)
				end
				return newindex(self, key, value)
			end)
		else
			notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
		end
	end
end)

addcmd('loopspeed',{'loopws'},function(args, speaker)
	local speed = args[1] or 16
	if args[2] then
		speed = args[2] or 16
	end
	if isNumber(speed) then
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local function WalkSpeedChange()
			if Char and Human then
				Human.WalkSpeed = speed
			end
		end
		WalkSpeedChange()
		HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
		HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or speaker.CharacterAdded:Connect(function(nChar)
			Char, Human = nChar, nChar:WaitForChild("Humanoid")
			WalkSpeedChange()
			HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
		end)
	end
end)

addcmd('unloopspeed',{'unloopws'},function(args, speaker)
	HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or nil
	HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or nil
end)

addcmd('spoofjumppower',{'spoofjp'},function(args, speaker)
	if args[1] and isNumber(args[1]) then
		if hookmetamethod then
			local char = speaker.Character
			local setpower;
			local index; index = hookmetamethod(game, "__index", function(self, key)
				if not checkcaller() and typeof(self) == "Instance" and self:IsA("Humanoid") and (key == "JumpPower" or key == "jumpPower") and self:IsDescendantOf(char) then
					return setpower or args[1]
				end
				return index(self, key)
			end)
			local newindex; newindex = hookmetamethod(game, "__newindex", function(self, key, value)
				if not checkcaller() and typeof(self) == "Instance" and self:IsA("Humanoid") and (key == "JumpPower" or key == "jumpPower") and self:IsDescendantOf(char) then
					setpower = tonumber(value)
				end
				return newindex(self, key, value)
			end)
		else
			notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
		end
	end
end)

addcmd('loopjumppower',{'loopjp','loopjpower'},function(args, speaker)
	local jpower = args[1] or 50
	if isNumber(jpower) then
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local function JumpPowerChange()
			if Char and Human then
				if speaker.Character:FindFirstChildOfClass('Humanoid').UseJumpPower then
					speaker.Character:FindFirstChildOfClass('Humanoid').JumpPower = jpower
				else
					speaker.Character:FindFirstChildOfClass('Humanoid').JumpHeight  = jpower
				end
			end
		end
		JumpPowerChange()
		HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("JumpPower"):Connect(JumpPowerChange)
		HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or speaker.CharacterAdded:Connect(function(nChar)
			Char, Human = nChar, nChar:WaitForChild("Humanoid")
			JumpPowerChange()
			HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("JumpPower"):Connect(JumpPowerChange)
		end)
	end
end)

addcmd('unloopjumppower',{'unloopjp','unloopjpower'},function(args, speaker)
	local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
	local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
	HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or nil
	HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or nil
	if Char and Human then
		if speaker.Character:FindFirstChildOfClass('Humanoid').UseJumpPower then
			speaker.Character:FindFirstChildOfClass('Humanoid').JumpPower = 50
		else
			speaker.Character:FindFirstChildOfClass('Humanoid').JumpHeight  = 50
		end
	end
end)

addcmd('tools',{'gears'},function(args, speaker)
	local function copy(instance)
		for i,c in pairs(instance:GetChildren())do
			if c:IsA('Tool') or c:IsA('HopperBin') then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(Lighting)
	local function copy(instance)
		for i,c in pairs(instance:GetChildren())do
			if c:IsA('Tool') or c:IsA('HopperBin') then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(ReplicatedStorage)
	notify('Tools','Copied tools from ReplicatedStorage and Lighting')
end)

addcmd('notools',{'rtools','clrtools','removetools','deletetools','dtools'},function(args, speaker)
	for i,v in pairs(speaker:FindFirstChildOfClass("Backpack"):GetDescendants()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v:Destroy()
		end
	end
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v:Destroy()
		end
	end
end)

addcmd('deleteselectedtool',{'dst'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v:Destroy()
		end
	end
end)

addcmd("console", {}, function(args, speaker)
    StarterGui:SetCore("DevConsoleVisible", true)
end)

addcmd('oldconsole',{},function(args, speaker)
	-- Thanks wally!!
	notify("Loading",'Hold on a sec')
	local _, str = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/console.lua", true)
	end)

	local s, e = loadstring(str)
	if typeof(s) ~= "function" then
		return
	end

	local success, message = pcall(s)
	if (not success) then
		if printconsole then
			printconsole(message)
		elseif printoutput then
			printoutput(message)
		end
	end
	wait(1)
	notify('Console','Press F9 to open the console')
end)

addcmd("explorer", {"dex"}, function(args, speaker)
    notify("Loading", "Hold on a sec")
    loadstring([==[
  -- https://github.com/LorekeeperZinnia/Dex

--[[
	Dex
	Created by Moon
	Modified for Infinite Yield

	Dex is a debugging suite designed to help the user debug games and find any potential vulnerabilities.
]]

local nodes = {}
local selection
local cloneref = cloneref or function(...) return ... end

local service = setmetatable({}, {
	__index = function(self, name)
		self[name] = cloneref(game:GetService(name))
		return self[name]
	end
})

-- prevent environment implosion from references
-- mainly from the executor not having some game properties in their game variable
-- so we gotta use vanilla game
local oldgame = game
local game = workspace.Parent

local EmbeddedModules = {
	Explorer = function()
--[[
	Explorer App Module
	
	The main explorer interface
]]

		-- Common Locals
		local Main,Lib,Apps,Settings -- Main Containers
		local Explorer, Properties, ScriptViewer, Notebook -- Major Apps
		local API,RMD,env,service,plr,create,createSimple -- Main Locals

		local function initDeps(data)
			Main = data.Main
			Lib = data.Lib
			Apps = data.Apps
			Settings = data.Settings

			API = data.API
			RMD = data.RMD
			env = data.env
			service = data.service
			plr = data.plr
			create = data.create
			createSimple = data.createSimple
		end

		local function initAfterMain()
			Explorer = Apps.Explorer
			Properties = Apps.Properties
			ScriptViewer = Apps.ScriptViewer
			Notebook = Apps.Notebook
		end

		local function main()
			local Explorer = {}
			local tree,listEntries,explorerOrders,searchResults,specResults = {},{},{},{},{}
			local expanded
			local entryTemplate,treeFrame,toolBar,descendantAddedCon,descendantRemovingCon,itemChangedCon
			local ffa = game.FindFirstAncestorWhichIsA
			local getDescendants = game.GetDescendants
			local getTextSize = service.TextService.GetTextSize
			local updateDebounce,refreshDebounce = false,false
			local nilNode = {Obj = Instance.new("Folder")}
			local idCounter = 0
			local scrollV,scrollH,clipboard
			local renameBox,renamingNode,searchFunc
			local sortingEnabled,autoUpdateSearch
			local table,math = table,math
			local nilMap,nilCons = {},{}
			local connectSignal = game.DescendantAdded.Connect
			local addObject,removeObject,moveObject = nil,nil,nil

			addObject = function(root)
				if nodes[root] then return end

				local isNil = false
				local rootParObj = ffa(root,"Instance")
				local par = nodes[rootParObj]

				-- Nil Handling
				if not par then
					if nilMap[root] then
						nilCons[root] = nilCons[root] or {
							connectSignal(root.ChildAdded,addObject),
							connectSignal(root.AncestryChanged,moveObject),
						}
						par = nilNode
						isNil = true
					else
						return
					end
				elseif nilMap[rootParObj] or par == nilNode then
					nilMap[root] = true
					nilCons[root] = nilCons[root] or {
						connectSignal(root.ChildAdded,addObject),
						connectSignal(root.AncestryChanged,moveObject),
					}
					isNil = true
				end

				local newNode = {Obj = root, Parent = par}
				nodes[root] = newNode

				-- Automatic sorting if expanded
				if sortingEnabled and expanded[par] and par.Sorted then
					local left,right = 1,#par
					local floor = math.floor
					local sorter = Explorer.NodeSorter
					local pos = (right == 0 and 1)

					if not pos then
						while true do
							if left >= right then
								if sorter(newNode,par[left]) then
									pos = left
								else
									pos = left+1
								end
								break
							end

							local mid = floor((left+right)/2)
							if sorter(newNode,par[mid]) then
								right = mid-1
							else
								left = mid+1
							end
						end
					end

					table.insert(par,pos,newNode)
				else
					par[#par+1] = newNode
					par.Sorted = nil
				end

				local insts = getDescendants(root)
				for i = 1,#insts do
					local obj = insts[i]
					if nodes[obj] then continue end -- Deferred

					local par = nodes[ffa(obj,"Instance")]
					if not par then continue end
					local newNode = {Obj = obj, Parent = par}
					nodes[obj] = newNode
					par[#par+1] = newNode

					-- Nil Handling
					if isNil then
						nilMap[obj] = true
						nilCons[obj] = nilCons[obj] or {
							connectSignal(obj.ChildAdded,addObject),
							connectSignal(obj.AncestryChanged,moveObject),
						}
					end
				end

				if searchFunc and autoUpdateSearch then
					searchFunc({newNode})
				end

				if not updateDebounce and Explorer.IsNodeVisible(par) then
					if expanded[par] then
						Explorer.PerformUpdate()
					elseif not refreshDebounce then
						Explorer.PerformRefresh()
					end
				end
			end

			removeObject = function(root)
				local node = nodes[root]
				if not node then return end

				-- Nil Handling
				if nilMap[node.Obj] then
					moveObject(node.Obj)
					return
				end

				local par = node.Parent
				if par then
					par.HasDel = true
				end

				local function recur(root)
					for i = 1,#root do
						local node = root[i]
						if not node.Del then
							nodes[node.Obj] = nil
							if #node > 0 then recur(node) end
						end
					end
				end
				recur(node)
				node.Del = true
				nodes[root] = nil

				if par and not updateDebounce and Explorer.IsNodeVisible(par) then
					if expanded[par] then
						Explorer.PerformUpdate()
					elseif not refreshDebounce then
						Explorer.PerformRefresh()
					end
				end
			end

			moveObject = function(obj)
				local node = nodes[obj]
				if not node then return end

				local oldPar = node.Parent
				local newPar = nodes[ffa(obj,"Instance")]
				if oldPar == newPar then return end

				-- Nil Handling
				if not newPar then
					if nilMap[obj] then
						newPar = nilNode
					else
						return
					end
				elseif nilMap[newPar.Obj] or newPar == nilNode then
					nilMap[obj] = true
					nilCons[obj] = nilCons[obj] or {
						connectSignal(obj.ChildAdded,addObject),
						connectSignal(obj.AncestryChanged,moveObject),
					}
				end

				if oldPar then
					local parPos = table.find(oldPar,node)
					if parPos then table.remove(oldPar,parPos) end
				end

				node.Id = nil
				node.Parent = newPar

				if sortingEnabled and expanded[newPar] and newPar.Sorted then
					local left,right = 1,#newPar
					local floor = math.floor
					local sorter = Explorer.NodeSorter
					local pos = (right == 0 and 1)

					if not pos then
						while true do
							if left >= right then
								if sorter(node,newPar[left]) then
									pos = left
								else
									pos = left+1
								end
								break
							end

							local mid = floor((left+right)/2)
							if sorter(node,newPar[mid]) then
								right = mid-1
							else
								left = mid+1
							end
						end
					end

					table.insert(newPar,pos,node)
				else
					newPar[#newPar+1] = node
					newPar.Sorted = nil
				end

				if searchFunc and searchResults[node] then
					local currentNode = node.Parent
					while currentNode and (not searchResults[currentNode] or expanded[currentNode] == 0) do
						expanded[currentNode] = true
						searchResults[currentNode] = true
						currentNode = currentNode.Parent
					end
				end

				if not updateDebounce and (Explorer.IsNodeVisible(newPar) or Explorer.IsNodeVisible(oldPar)) then
					if expanded[newPar] or expanded[oldPar] then
						Explorer.PerformUpdate()
					elseif not refreshDebounce then
						Explorer.PerformRefresh()
					end
				end
			end

			Explorer.ViewWidth = 0
			Explorer.Index = 0
			Explorer.EntryIndent = 20
			Explorer.FreeWidth = 32
			Explorer.GuiElems = {}

			Explorer.InitRenameBox = function()
				renameBox = create({{1,"TextBox",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderColor3=Color3.new(0.062745101749897,0.51764708757401,1),BorderMode=2,ClearTextOnFocus=false,Font=3,Name="RenameBox",PlaceholderColor3=Color3.new(0.69803923368454,0.69803923368454,0.69803923368454),Position=UDim2.new(0,26,0,2),Size=UDim2.new(0,200,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,Visible=false,ZIndex=2}}})

				renameBox.Parent = Explorer.Window.GuiElems.Content.List

				renameBox.FocusLost:Connect(function()
					if not renamingNode then return end

					pcall(function() renamingNode.Obj.Name = renameBox.Text end)
					renamingNode = nil
					Explorer.Refresh()
				end)

				renameBox.Focused:Connect(function()
					renameBox.SelectionStart = 1
					renameBox.CursorPosition = #renameBox.Text + 1
				end)
			end

			Explorer.SetRenamingNode = function(node)
				renamingNode = node
				renameBox.Text = tostring(node.Obj)
				renameBox:CaptureFocus()
				Explorer.Refresh()
			end

			Explorer.SetSortingEnabled = function(val)
				sortingEnabled = val
				Settings.Explorer.Sorting = val
			end

			Explorer.UpdateView = function()
				local maxNodes = math.ceil(treeFrame.AbsoluteSize.Y / 20)
				local maxX = treeFrame.AbsoluteSize.X
				local totalWidth = Explorer.ViewWidth + Explorer.FreeWidth

				scrollV.VisibleSpace = maxNodes
				scrollV.TotalSpace = #tree + 1
				scrollH.VisibleSpace = maxX
				scrollH.TotalSpace = totalWidth

				scrollV.Gui.Visible = #tree + 1 > maxNodes
				scrollH.Gui.Visible = totalWidth > maxX

				local oldSize = treeFrame.Size
				treeFrame.Size = UDim2.new(1,(scrollV.Gui.Visible and -16 or 0),1,(scrollH.Gui.Visible and -39 or -23))
				if oldSize ~= treeFrame.Size then
					Explorer.UpdateView()
				else
					scrollV:Update()
					scrollH:Update()

					renameBox.Size = UDim2.new(0,maxX-100,0,16)

					if scrollV.Gui.Visible and scrollH.Gui.Visible then
						scrollV.Gui.Size = UDim2.new(0,16,1,-39)
						scrollH.Gui.Size = UDim2.new(1,-16,0,16)
						Explorer.Window.GuiElems.Content.ScrollCorner.Visible = true
					else
						scrollV.Gui.Size = UDim2.new(0,16,1,-23)
						scrollH.Gui.Size = UDim2.new(1,0,0,16)
						Explorer.Window.GuiElems.Content.ScrollCorner.Visible = false
					end

					Explorer.Index = scrollV.Index
				end
			end

			Explorer.NodeSorter = function(a,b)
				if a.Del or b.Del then return false end -- Ghost node

				local aClass = a.Class
				local bClass = b.Class
				if not aClass then aClass = a.Obj.ClassName a.Class = aClass end
				if not bClass then bClass = b.Obj.ClassName b.Class = bClass end

				local aOrder = explorerOrders[aClass]
				local bOrder = explorerOrders[bClass]
				if not aOrder then aOrder = RMD.Classes[aClass] and tonumber(RMD.Classes[aClass].ExplorerOrder) or 9999 explorerOrders[aClass] = aOrder end
				if not bOrder then bOrder = RMD.Classes[bClass] and tonumber(RMD.Classes[bClass].ExplorerOrder) or 9999 explorerOrders[bClass] = bOrder end

				if aOrder ~= bOrder then
					return aOrder < bOrder
				else
					local aName,bName = tostring(a.Obj),tostring(b.Obj)
					if aName ~= bName then
						return aName < bName
					elseif aClass ~= bClass then
						return aClass < bClass
					else
						local aId = a.Id if not aId then aId = idCounter idCounter = (idCounter+0.001)%999999999 a.Id = aId end
						local bId = b.Id if not bId then bId = idCounter idCounter = (idCounter+0.001)%999999999 b.Id = bId end
						return aId < bId
					end
				end
			end

			Explorer.Update = function()
				table.clear(tree)
				local maxNameWidth,maxDepth,count = 0,1,1
				local nameCache = {}
				local font = Enum.Font.SourceSans
				local size = Vector2.new(math.huge,20)
				local useNameWidth = Settings.Explorer.UseNameWidth
				local tSort = table.sort
				local sortFunc = Explorer.NodeSorter
				local isSearching = (expanded == Explorer.SearchExpanded)
				local textServ = service.TextService

				local function recur(root,depth)
					if depth > maxDepth then maxDepth = depth end
					depth = depth + 1
					if sortingEnabled and not root.Sorted then
						tSort(root,sortFunc)
						root.Sorted = true
					end
					for i = 1,#root do
						local n = root[i]

						if (isSearching and not searchResults[n]) or n.Del then continue end

						if useNameWidth then
							local nameWidth = n.NameWidth
							if not nameWidth then
								local objName = tostring(n.Obj)
								nameWidth = nameCache[objName]
								if not nameWidth then
									nameWidth = getTextSize(textServ,objName,14,font,size).X
									nameCache[objName] = nameWidth
								end
								n.NameWidth = nameWidth
							end
							if nameWidth > maxNameWidth then
								maxNameWidth = nameWidth
							end
						end

						tree[count] = n
						count = count + 1
						if expanded[n] and #n > 0 then
							recur(n,depth)
						end
					end
				end

				recur(nodes[game],1)

				-- Nil Instances
				if env.getnilinstances then
					if not (isSearching and not searchResults[nilNode]) then
						tree[count] = nilNode
						count = count + 1
						if expanded[nilNode] then
							recur(nilNode,2)
						end
					end
				end

				Explorer.MaxNameWidth = maxNameWidth
				Explorer.MaxDepth = maxDepth
				Explorer.ViewWidth = useNameWidth and Explorer.EntryIndent*maxDepth + maxNameWidth + 26 or Explorer.EntryIndent*maxDepth + 226
				Explorer.UpdateView()
			end

			Explorer.StartDrag = function(offX,offY)
				if Explorer.Dragging then return end
				for i,v in next, selection.List do
					local Obj = v.Obj
					if Obj.Parent == game or Obj:IsA("Player") then
						return
					end
				end
				Explorer.Dragging = true

				local dragTree = treeFrame:Clone()
				dragTree:ClearAllChildren()

				for i,v in pairs(listEntries) do
					local node = tree[i + Explorer.Index]
					if node and selection.Map[node] then
						local clone = v:Clone()
						clone.Active = false
						clone.Indent.Expand.Visible = false
						clone.Parent = dragTree
					end
				end

				local newGui = Instance.new("ScreenGui")
				newGui.DisplayOrder = Main.DisplayOrders.Menu
				dragTree.Parent = newGui
				Lib.ShowGui(newGui)

				local dragOutline = create({
					{1,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="DragSelect",Size=UDim2.new(1,0,1,0),}},
					{2,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Size=UDim2.new(1,0,0,1),ZIndex=2,}},
					{3,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),ZIndex=2,}},
					{4,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Size=UDim2.new(0,1,1,0),ZIndex=2,}},
					{5,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Line",Parent={1},Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),ZIndex=2,}},
				})
				dragOutline.Parent = treeFrame

				local mouse = Main.Mouse or service.Players.LocalPlayer:GetMouse()
				local function move()
					local posX = mouse.X - offX
					local posY = mouse.Y - offY
					dragTree.Position = UDim2.new(0,posX,0,posY)

					for i = 1,#listEntries do
						local entry = listEntries[i]
						if Lib.CheckMouseInGui(entry) then
							dragOutline.Position = UDim2.new(0,entry.Indent.Position.X.Offset-scrollH.Index,0,entry.Position.Y.Offset)
							dragOutline.Size = UDim2.new(0,entry.Size.X.Offset-entry.Indent.Position.X.Offset,0,20)
							dragOutline.Visible = true
							return
						end
					end
					dragOutline.Visible = false
				end
				move()

				local input = service.UserInputService
				local mouseEvent,releaseEvent

				mouseEvent = input.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						move()
					end
				end)

				releaseEvent = input.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						newGui:Destroy()
						dragOutline:Destroy()
						Explorer.Dragging = false

						for i = 1,#listEntries do
							if Lib.CheckMouseInGui(listEntries[i]) then
								local node = tree[i + Explorer.Index]
								if node then
									if selection.Map[node] then return end
									local newPar = node.Obj
									local sList = selection.List
									for i = 1,#sList do
										local n = sList[i]
										pcall(function() n.Obj.Parent = newPar end)
									end
									Explorer.ViewNode(sList[1])
								end
								break
							end
						end
					end
				end)
			end

			Explorer.NewListEntry = function(index)
				local newEntry = entryTemplate:Clone()
				newEntry.Position = UDim2.new(0,0,0,20*(index-1))

				local isRenaming = false

				newEntry.InputBegan:Connect(function(input)
					local node = tree[index + Explorer.Index]
					if not node or selection.Map[node] or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

					newEntry.Indent.BackgroundColor3 = Settings.Theme.Button
					newEntry.Indent.BorderSizePixel = 0
					newEntry.Indent.BackgroundTransparency = 0
				end)

				newEntry.InputEnded:Connect(function(input)
					local node = tree[index + Explorer.Index]
					if not node or selection.Map[node] or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

					newEntry.Indent.BackgroundTransparency = 1
				end)

				newEntry.MouseButton1Down:Connect(function()

				end)

				newEntry.MouseButton1Up:Connect(function()

				end)

				newEntry.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local releaseEvent, mouseEvent

						local mouse = Main.Mouse or plr:GetMouse()
						local startX, startY

						if input.UserInputType == Enum.UserInputType.Touch then
							startX = input.Position.X
							startY = input.Position.Y
						else
							startX = mouse.X
							startY = mouse.Y
						end

						local listOffsetX = startX - treeFrame.AbsolutePosition.X
						local listOffsetY = startY - treeFrame.AbsolutePosition.Y

						releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								releaseEvent:Disconnect()
								mouseEvent:Disconnect()
							end
						end)

						mouseEvent = service.UserInputService.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								local currentX, currentY

								if input.UserInputType == Enum.UserInputType.Touch then
									currentX = input.Position.X
									currentY = input.Position.Y
								else
									currentX = mouse.X
									currentY = mouse.Y
								end

								local deltaX = currentX - startX
								local deltaY = currentY - startY
								local dist = math.sqrt(deltaX^2 + deltaY^2)

								if dist > 5 then
									releaseEvent:Disconnect()
									mouseEvent:Disconnect()
									isRenaming = false
									Explorer.StartDrag(listOffsetX, listOffsetY)
								end
							end
						end)
					end
				end)

				newEntry.MouseButton2Down:Connect(function()

				end)

				newEntry.Indent.Expand.InputBegan:Connect(function(input)
					local node = tree[index + Explorer.Index]
					if not node or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

					if input.UserInputType == Enum.UserInputType.Touch then
						Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse_Over" or "Expand_Over")
					elseif input.UserInputType == Enum.UserInputType.MouseMovement then
						Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse_Over" or "Expand_Over")
					end
				end)

				newEntry.Indent.Expand.InputEnded:Connect(function(input)
					local node = tree[index + Explorer.Index]
					if not node or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

					if input.UserInputType == Enum.UserInputType.Touch then
						Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse" or "Expand")
					elseif input.UserInputType == Enum.UserInputType.MouseMovement then
						Explorer.MiscIcons:DisplayByKey(newEntry.Indent.Expand.Icon, expanded[node] and "Collapse" or "Expand")
					end
				end)

				newEntry.Indent.Expand.MouseButton1Down:Connect(function()
					local node = tree[index + Explorer.Index]
					if not node or #node == 0 then return end

					expanded[node] = not expanded[node]
					Explorer.Update()
					Explorer.Refresh()
				end)

				newEntry.Parent = treeFrame
				return newEntry
			end

			Explorer.Refresh = function()
				local maxNodes = math.max(math.ceil((treeFrame.AbsoluteSize.Y) / 20), 0)	
				local renameNodeVisible = false
				local isa = game.IsA

				for i = 1,maxNodes do
					local entry = listEntries[i]
					if not listEntries[i] then entry = Explorer.NewListEntry(i) listEntries[i] = entry Explorer.ClickSystem:Add(entry) end

					local node = tree[i + Explorer.Index]
					if node then
						local obj = node.Obj
						local depth = Explorer.EntryIndent*Explorer.NodeDepth(node)

						entry.Visible = true
						entry.Position = UDim2.new(0,-scrollH.Index,0,entry.Position.Y.Offset)
						entry.Size = UDim2.new(0,Explorer.ViewWidth,0,20)
						entry.Indent.EntryName.Text = tostring(node.Obj)
						entry.Indent.Position = UDim2.new(0,depth,0,0)
						entry.Indent.Size = UDim2.new(1,-depth,1,0)

						entry.Indent.EntryName.TextTruncate = (Settings.Explorer.UseNameWidth and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd)

						Explorer.MiscIcons:DisplayExplorerIcons(entry.Indent.Icon, obj.ClassName)

						if selection.Map[node] then
							entry.Indent.BackgroundColor3 = Settings.Theme.ListSelection
							entry.Indent.BorderSizePixel = 0
							entry.Indent.BackgroundTransparency = 0
						else
							if Lib.CheckMouseInGui(entry) then
								entry.Indent.BackgroundColor3 = Settings.Theme.Button
							else
								entry.Indent.BackgroundTransparency = 1
							end
						end

						if node == renamingNode then
							renameNodeVisible = true
							renameBox.Position = UDim2.new(0,depth+25-scrollH.Index,0,entry.Position.Y.Offset+2)
							renameBox.Visible = true
						end

						if #node > 0 and expanded[node] ~= 0 then
							if Lib.CheckMouseInGui(entry.Indent.Expand) then
								Explorer.MiscIcons:DisplayByKey(entry.Indent.Expand.Icon, expanded[node] and "Collapse_Over" or "Expand_Over")
							else
								Explorer.MiscIcons:DisplayByKey(entry.Indent.Expand.Icon, expanded[node] and "Collapse" or "Expand")
							end
							entry.Indent.Expand.Visible = true
						else
							entry.Indent.Expand.Visible = false
						end
					else
						entry.Visible = false
					end
				end

				if not renameNodeVisible then
					renameBox.Visible = false
				end

				for i = maxNodes+1, #listEntries do
					Explorer.ClickSystem:Remove(listEntries[i])
					listEntries[i]:Destroy()
					listEntries[i] = nil
				end
			end

			Explorer.PerformUpdate = function(instant)
				updateDebounce = true
				Lib.FastWait(not instant and 0.1)
				if not updateDebounce then return end
				updateDebounce = false
				if not Explorer.Window:IsVisible() then return end
				Explorer.Update()
				Explorer.Refresh()
			end

			Explorer.ForceUpdate = function(norefresh)
				updateDebounce = false
				Explorer.Update()
				if not norefresh then Explorer.Refresh() end
			end

			Explorer.PerformRefresh = function()
				refreshDebounce = true
				Lib.FastWait(0.1)
				refreshDebounce = false
				if updateDebounce or not Explorer.Window:IsVisible() then return end
				Explorer.Refresh()
			end

			Explorer.IsNodeVisible = function(node)
				if not node then return end

				local curNode = node.Parent
				while curNode do
					if not expanded[curNode] then return false end
					curNode = curNode.Parent
				end
				return true
			end

			Explorer.NodeDepth = function(node)
				local depth = 0

				if node == nilNode then
					return 1
				end

				local curNode = node.Parent
				while curNode do
					if curNode == nilNode then depth = depth + 1 end
					curNode = curNode.Parent
					depth = depth + 1
				end
				return depth
			end

			Explorer.SetupConnections = function()
				if descendantAddedCon then descendantAddedCon:Disconnect() end
				if descendantRemovingCon then descendantRemovingCon:Disconnect() end
				if itemChangedCon then itemChangedCon:Disconnect() end

				if Main.Elevated then
					descendantAddedCon = game.DescendantAdded:Connect(addObject)
					descendantRemovingCon = game.DescendantRemoving:Connect(removeObject)
				else
					descendantAddedCon = game.DescendantAdded:Connect(function(obj) pcall(addObject,obj) end)
					descendantRemovingCon = game.DescendantRemoving:Connect(function(obj) pcall(removeObject,obj) end)
				end

				if Settings.Explorer.UseNameWidth then
					itemChangedCon = game.ItemChanged:Connect(function(obj,prop)
						if prop == "Parent" and nodes[obj] then
							moveObject(obj)
						elseif prop == "Name" and nodes[obj] then
							nodes[obj].NameWidth = nil
						end
					end)
				else
					itemChangedCon = game.ItemChanged:Connect(function(obj,prop)
						if prop == "Parent" and nodes[obj] then
							moveObject(obj)
						end
					end)
				end
			end

			Explorer.ViewNode = function(node)
				if not node then return end

				Explorer.MakeNodeVisible(node)
				Explorer.ForceUpdate(true)
				local visibleSpace = scrollV.VisibleSpace

				for i,v in next,tree do
					if v == node then
						local relative = i - 1
						if Explorer.Index > relative then
							scrollV.Index = relative
						elseif Explorer.Index + visibleSpace - 1 <= relative then
							scrollV.Index = relative - visibleSpace + 2
						end
					end
				end

				scrollV:Update() Explorer.Index = scrollV.Index
				Explorer.Refresh()
			end

			Explorer.ViewObj = function(obj)
				Explorer.ViewNode(nodes[obj])
			end

			Explorer.MakeNodeVisible = function(node,expandRoot)
				if not node then return end

				local hasExpanded = false

				if expandRoot and not expanded[node] then
					expanded[node] = true
					hasExpanded = true
				end

				local currentNode = node.Parent
				while currentNode do
					hasExpanded = true
					expanded[currentNode] = true
					currentNode = currentNode.Parent
				end

				if hasExpanded and not updateDebounce then
					coroutine.wrap(Explorer.PerformUpdate)(true)
				end
			end

			Explorer.ShowRightClick = function(MousePos)
				local Mouse = MousePos or Main.Mouse
				local context = Explorer.RightClickContext
				local absoluteSize = context.Gui.AbsoluteSize
				context.MaxHeight = (absoluteSize.Y <= 600 and (absoluteSize.Y - 40)) or nil
				context:Clear()

				local sList = selection.List
				local sMap = selection.Map
				local emptyClipboard = #clipboard == 0
				local presentClasses = {}
				local apiClasses = API.Classes

				for i = 1, #sList do
					local node = sList[i]
					local class = node.Class
					local obj = node.Obj

					if not presentClasses.isViableDecompileScript then
						presentClasses.isViableDecompileScript = env.isViableDecompileScript(obj)
					end
					if not class then
						class = obj.ClassName
						node.Class = class
					end

					local curClass = apiClasses[class]
					while curClass and not presentClasses[curClass.Name] do
						presentClasses[curClass.Name] = true
						curClass = curClass.Superclass
					end
				end

				context:AddRegistered("CUT")
				context:AddRegistered("COPY")
				context:AddRegistered("PASTE", emptyClipboard)
				context:AddRegistered("DUPLICATE")
				context:AddRegistered("DELETE")
				context:AddRegistered("RENAME", #sList ~= 1)

				context:AddDivider()
				context:AddRegistered("GROUP")
				context:AddRegistered("UNGROUP")
				context:AddRegistered("SELECT_CHILDREN")
				context:AddRegistered("JUMP_TO_PARENT")
				context:AddRegistered("EXPAND_ALL")
				context:AddRegistered("COLLAPSE_ALL")

				context:AddDivider()

				if expanded == Explorer.SearchExpanded then context:AddRegistered("CLEAR_SEARCH_AND_JUMP_TO") end
				if env.setclipboard then context:AddRegistered("COPY_PATH") end
				context:AddRegistered("INSERT_OBJECT")
				-- context:AddRegistered("SAVE_INST")
				-- context:AddRegistered("CALL_FUNCTION")
				-- context:AddRegistered("VIEW_CONNECTIONS")
				-- context:AddRegistered("GET_REFERENCES")
				-- context:AddRegistered("VIEW_API")

				context:QueueDivider()

				if presentClasses["BasePart"] or presentClasses["Model"] then
					context:AddRegistered("TELEPORT_TO")
					context:AddRegistered("VIEW_OBJECT")
				end
				if presentClasses["Tween"] then context:AddRegistered("PLAY_TWEEN") end
				if presentClasses["Animation"] then
					context:AddRegistered("LOAD_ANIMATION")
					context:AddRegistered("STOP_ANIMATION")
				end

				if presentClasses["TouchTransmitter"] then context:AddRegistered("FIRE_TOUCHTRANSMITTER", firetouchinterest == nil) end
				if presentClasses["ClickDetector"] then context:AddRegistered("FIRE_CLICKDETECTOR", fireclickdetector == nil) end
				if presentClasses["ProximityPrompt"] then context:AddRegistered("FIRE_PROXIMITYPROMPT", fireproximityprompt == nil) end

				if presentClasses["Player"] then context:AddRegistered("SELECT_CHARACTER")context:AddRegistered("VIEW_PLAYER") end
				if presentClasses["Players"] then
					context:AddRegistered("SELECT_LOCAL_PLAYER")
					context:AddRegistered("SELECT_ALL_CHARACTERS")
				end

				if presentClasses["LuaSourceContainer"] then
					context:AddRegistered("VIEW_SCRIPT", not presentClasses.isViableDecompileScript or env.decompile == nil)
					context:AddRegistered("SAVE_SCRIPT", not presentClasses.isViableDecompileScript or env.decompile == nil or env.writefile == nil)
					context:AddRegistered("SAVE_BYTECODE", not presentClasses.isViableDecompileScript or env.getscriptbytecode == nil or env.writefile == nil)
				end

				if sMap[nilNode] then
					context:AddRegistered("REFRESH_NIL")
					context:AddRegistered("HIDE_NIL")
				end

				Explorer.LastRightClickX, Explorer.LastRightClickY = Mouse.X, Mouse.Y
				context:Show(Mouse.X, Mouse.Y)
			end

			Explorer.InitRightClick = function()
				local context = Lib.ContextMenu.new()

				context:Register("CUT",{Name = "Cut", IconMap = Explorer.MiscIcons, Icon = "Cut", DisabledIcon = "Cut_Disabled", Shortcut = "Ctrl+Z", OnClick = function()
					local destroy,clone = game.Destroy,game.Clone
					local sList,newClipboard = selection.List,{}
					local count = 1
					for i = 1,#sList do
						local inst = sList[i].Obj
						local s,cloned = pcall(clone,inst)
						if s and cloned then
							newClipboard[count] = cloned
							count = count + 1
						end
						pcall(destroy,inst)
					end
					clipboard = newClipboard
					selection:Clear()
				end})

				context:Register("COPY",{Name = "Copy", IconMap = Explorer.MiscIcons, Icon = "Copy", DisabledIcon = "Copy_Disabled", Shortcut = "Ctrl+C", OnClick = function()
					local clone = game.Clone
					local sList,newClipboard = selection.List,{}
					local count = 1
					for i = 1,#sList do
						local inst = sList[i].Obj
						local s,cloned = pcall(clone,inst)
						if s and cloned then
							newClipboard[count] = cloned
							count = count + 1
						end
					end
					clipboard = newClipboard
				end})

				context:Register("PASTE",{Name = "Paste Into", IconMap = Explorer.MiscIcons, Icon = "Paste", DisabledIcon = "Paste_Disabled", Shortcut = "Ctrl+Shift+V", OnClick = function()
					local sList = selection.List
					local newSelection = {}
					local count = 1
					for i = 1,#sList do
						local node = sList[i]
						local inst = node.Obj
						Explorer.MakeNodeVisible(node,true)
						for c = 1,#clipboard do
							local cloned = clipboard[c]:Clone()
							if cloned then
								cloned.Parent = inst
								local clonedNode = nodes[cloned]
								if clonedNode then newSelection[count] = clonedNode count = count + 1 end
							end
						end
					end
					selection:SetTable(newSelection)

					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					end
				end})

				context:Register("DUPLICATE",{Name = "Duplicate", IconMap = Explorer.MiscIcons, Icon = "Copy", DisabledIcon = "Copy_Disabled", Shortcut = "Ctrl+D", OnClick = function()
					local clone = game.Clone
					local sList = selection.List
					local newSelection = {}
					local count = 1
					for i = 1,#sList do
						local node = sList[i]
						local inst = node.Obj
						local instPar = node.Parent and node.Parent.Obj
						Explorer.MakeNodeVisible(node)
						local s,cloned = pcall(clone,inst)
						if s and cloned then
							cloned.Parent = instPar
							local clonedNode = nodes[cloned]
							if clonedNode then newSelection[count] = clonedNode count = count + 1 end
						end
					end

					selection:SetTable(newSelection)
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					end
				end})

				context:Register("DELETE",{Name = "Delete", IconMap = Explorer.MiscIcons, Icon = "Delete", DisabledIcon = "Delete_Disabled", Shortcut = "Del", OnClick = function()
					local destroy = game.Destroy
					local sList = selection.List
					for i = 1,#sList do
						pcall(destroy,sList[i].Obj)
					end
					selection:Clear()
				end})

				context:Register("RENAME",{Name = "Rename", IconMap = Explorer.MiscIcons, Icon = "Rename", DisabledIcon = "Rename_Disabled", Shortcut = "F2", OnClick = function()
					local sList = selection.List
					if sList[1] then
						Explorer.SetRenamingNode(sList[1])
					end
				end})

				context:Register("GROUP",{Name = "Group", IconMap = Explorer.MiscIcons, Icon = "Group", DisabledIcon = "Group_Disabled", Shortcut = "Ctrl+G", OnClick = function()
					local sList = selection.List
					if #sList == 0 then return end

					local model = Instance.new("Model",sList[#sList].Obj.Parent)
					for i = 1,#sList do
						pcall(function() sList[i].Obj.Parent = model end)
					end

					if nodes[model] then
						selection:Set(nodes[model])
						Explorer.ViewNode(nodes[model])
					end
				end})

				context:Register("UNGROUP",{Name = "Ungroup", IconMap = Explorer.MiscIcons, Icon = "Ungroup", DisabledIcon = "Ungroup_Disabled", Shortcut = "Ctrl+U", OnClick = function()
					local newSelection = {}
					local count = 1
					local isa = game.IsA

					local function ungroup(node)
						local par = node.Parent.Obj
						local ch = {}
						local chCount = 1

						for i = 1,#node do
							local n = node[i]
							newSelection[count] = n
							ch[chCount] = n
							count = count + 1
							chCount = chCount + 1
						end

						for i = 1,#ch do
							pcall(function() ch[i].Obj.Parent = par end)
						end

						node.Obj:Destroy()
					end

					for i,v in next,selection.List do
						if isa(v.Obj,"Model") then
							ungroup(v)
						end
					end

					selection:SetTable(newSelection)
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					end
				end})

				context:Register("SELECT_CHILDREN",{Name = "Select Children", IconMap = Explorer.MiscIcons, Icon = "SelectChildren", DisabledIcon = "SelectChildren_Disabled", OnClick = function()
					local newSelection = {}
					local count = 1
					local sList = selection.List

					for i = 1,#sList do
						local node = sList[i]
						for ind = 1,#node do
							local cNode = node[ind]
							if ind == 1 then Explorer.MakeNodeVisible(cNode) end

							newSelection[count] = cNode
							count = count + 1
						end
					end

					selection:SetTable(newSelection)
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					else
						Explorer.Refresh()
					end
				end})

				context:Register("JUMP_TO_PARENT",{Name = "Jump to Parent", IconMap = Explorer.MiscIcons, Icon = "JumpToParent", OnClick = function()
					local newSelection = {}
					local count = 1
					local sList = selection.List

					for i = 1,#sList do
						local node = sList[i]
						if node.Parent then
							newSelection[count] = node.Parent
							count = count + 1
						end
					end

					selection:SetTable(newSelection)
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					else
						Explorer.Refresh()
					end
				end})

				context:Register("TELEPORT_TO",{Name = "Teleport To", IconMap = Explorer.MiscIcons, Icon = "TeleportTo", OnClick = function()
					local sList = selection.List
					local plrRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

					if not plrRP then return end

					for _,node in next, sList do
						local Obj = node.Obj

						if Obj:IsA("BasePart") then
							if Obj.CanCollide then
								plr.Character:MoveTo(Obj.Position)
							else
								plrRP.CFrame = CFrame.new(Obj.Position + Settings.Explorer.TeleportToOffset)
							end
							break
						elseif Obj:IsA("Model") then
							if Obj.PrimaryPart then
								if Obj.PrimaryPart.CanCollide then
									plr.Character:MoveTo(Obj.PrimaryPart.Position)
								else
									plrRP.CFrame = CFrame.new(Obj.PrimaryPart.Position + Settings.Explorer.TeleportToOffset)
								end
								break
							else
								local part = Obj:FindFirstChildWhichIsA("BasePart", true)
								if part and nodes[part] then
									if part.CanCollide then
										plr.Character:MoveTo(part.Position)
									else
										plrRP.CFrame = CFrame.new(part.Position + Settings.Explorer.TeleportToOffset)
									end
									break
								elseif Obj.WorldPivot then
									plrRP.CFrame = Obj.WorldPivot
								end
							end
						end
					end
				end})

				local OldAnimation
				context:Register("PLAY_TWEEN",{Name = "Play Tween", IconMap = Explorer.MiscIcons, Icon = "Play", OnClick = function()
					local sList = selection.List

					for i = 1, #sList do
						local node = sList[i]
						local Obj = node.Obj

						if Obj:IsA("Tween") then Obj:Play() end
					end
				end})

				local OldAnimation
				context:Register("LOAD_ANIMATION",{Name = "Load Animation", IconMap = Explorer.MiscIcons, Icon = "Play", OnClick = function()
					local sList = selection.List

					local Humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid")
					if not Humanoid then return end

					for i = 1, #sList do
						local node = sList[i]
						local Obj = node.Obj

						if Obj:IsA("Animation") then
							if OldAnimation then OldAnimation:Stop() end
							OldAnimation = Humanoid:LoadAnimation(Obj)
							OldAnimation:Play()
							break
						end
					end
				end})

				context:Register("STOP_ANIMATION",{Name = "Stop Animation", IconMap = Explorer.MiscIcons, Icon = "Pause", OnClick = function()
					local sList = selection.List

					local Humanoid = plr.Character and plr.Character:FindFirstChild("Humanoid")
					if not Humanoid then return end

					for i = 1, #sList do
						local node = sList[i]
						local Obj = node.Obj

						if Obj:IsA("Animation") then
							if OldAnimation then OldAnimation:Stop() end
							Humanoid:LoadAnimation(Obj):Stop()
							break
						end
					end
				end})

				context:Register("EXPAND_ALL",{Name = "Expand All", OnClick = function()
					local sList = selection.List

					local function expand(node)
						expanded[node] = true
						for i = 1,#node do
							if #node[i] > 0 then
								expand(node[i])
							end
						end
					end

					for i = 1,#sList do
						expand(sList[i])
					end

					Explorer.ForceUpdate()
				end})

				context:Register("COLLAPSE_ALL",{Name = "Collapse All", OnClick = function()
					local sList = selection.List

					local function expand(node)
						expanded[node] = nil
						for i = 1,#node do
							if #node[i] > 0 then
								expand(node[i])
							end
						end
					end

					for i = 1,#sList do
						expand(sList[i])
					end

					Explorer.ForceUpdate()
				end})

				context:Register("CLEAR_SEARCH_AND_JUMP_TO",{Name = "Clear Search and Jump to", OnClick = function()
					local newSelection = {}
					local count = 1
					local sList = selection.List

					for i = 1,#sList do
						newSelection[count] = sList[i]
						count = count + 1
					end

					selection:SetTable(newSelection)
					Explorer.ClearSearch()
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					end
				end})

				-- this code is very bad but im lazy and it works so cope
				local clth = function(str)
					if str:sub(1, 28) == "game:GetService(\"Workspace\")" then str = str:gsub("game:GetService%(\"Workspace\"%)", "workspace", 1) end
					if str:sub(1, 27 + #plr.Name) == "game:GetService(\"Players\")." .. plr.Name then str = str:gsub("game:GetService%(\"Players\"%)." .. plr.Name, "game:GetService(\"Players\").LocalPlayer", 1) end
					return str
				end

				context:Register("COPY_PATH",{Name = "Copy Path", IconMap = Explorer.ClassIcons, Icon = 50, OnClick = function()
					local sList = selection.List
					if #sList == 1 then
						env.setclipboard(clth(Explorer.GetInstancePath(sList[1].Obj)))
					elseif #sList > 1 then
						local resList = {"{"}
						local count = 2
						for i = 1,#sList do
							local path = "\t"..clth(Explorer.GetInstancePath(sList[i].Obj))..","
							if #path > 0 then
								resList[count] = path
								count = count+1
							end
						end
						resList[count] = "}"
						env.setclipboard(table.concat(resList,"\n"))
					end
				end})

				context:Register("INSERT_OBJECT",{Name = "Insert Object", IconMap = Explorer.MiscIcons, Icon = "InsertObject", OnClick = function()
					local mouse = Main.Mouse
					local x,y = Explorer.LastRightClickX or mouse.X, Explorer.LastRightClickY or mouse.Y
					Explorer.InsertObjectContext:Show(x,y)
				end})

				--[[context:Register("CALL_FUNCTION",{Name = "Call Function", IconMap = Explorer.ClassIcons, Icon = 66, OnClick = function()

				end})

				context:Register("GET_REFERENCES",{Name = "Get Lua References", IconMap = Explorer.ClassIcons, Icon = 34, OnClick = function()

				end})

				context:Register("SAVE_INST",{Name = "Save to File", IconMap = Explorer.MiscIcons, Icon = "Save", OnClick = function()

				end})

                context:Register("VIEW_CONNECTIONS",{Name = "View Connections", OnClick = function()
                    
                end})

				context:Register("VIEW_API",{Name = "View API Page", IconMap = Explorer.MiscIcons, Icon = "Reference", OnClick = function()

				end})]]

				context:Register("VIEW_OBJECT",{Name = "View Object (Right click to reset)", IconMap = Explorer.ClassIcons, Icon = 5, OnClick = function()
					local sList = selection.List
					local isa = game.IsA

					for i = 1,#sList do
						local node = sList[i]

						if isa(node.Obj,"BasePart") or isa(node.Obj, "Model") then
							workspace.CurrentCamera.CameraSubject = node.Obj
							break
						end
					end
				end, OnRightClick = function()
					workspace.CurrentCamera.CameraSubject = plr.Character
				end})

				context:Register("FIRE_TOUCHTRANSMITTER",{Name = "Fire TouchTransmitter", IconMap = Explorer.ClassIcons, Icon = 37, OnClick = function()
					local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if not hrp then return end
					for _, v in ipairs(selection.List) do if v.Obj and v.Obj:IsA("TouchTransmitter") then firetouchinterest(hrp, v.Obj.Parent, 0) end end
				end})

				context:Register("FIRE_CLICKDETECTOR",{Name = "Fire ClickDetector", IconMap = Explorer.ClassIcons, Icon = 41, OnClick = function()
					local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if not hrp then return end
					for _, v in ipairs(selection.List) do if v.Obj and v.Obj:IsA("ClickDetector") then fireclickdetector(v.Obj) end end
				end})

				context:Register("FIRE_PROXIMITYPROMPT",{Name = "Fire ProximityPrompt", IconMap = Explorer.ClassIcons, Icon = 124, OnClick = function()
					local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if not hrp then return end
					for _, v in ipairs(selection.List) do if v.Obj and v.Obj:IsA("ProximityPrompt") then fireproximityprompt(v.Obj) end end
				end})

				context:Register("VIEW_SCRIPT",{Name = "View Script", IconMap = Explorer.MiscIcons, Icon = "ViewScript", OnClick = function()
					local scr = selection.List[1] and selection.List[1].Obj
					if scr then ScriptViewer.ViewScript(scr) end
				end})

				context:Register("SAVE_SCRIPT",{Name = "Save Script", IconMap = Explorer.MiscIcons, Icon = "Save", OnClick = function()
					for _, v in next, selection.List do
						if v.Obj:IsA("LuaSourceContainer") and env.isViableDecompileScript(v.Obj) then
							local success, source = pcall(env.decompile, v.Obj)
							if not success or not source then source = ("-- DEX - %s failed to decompile %s"):format(env.executor, v.Obj.ClassName) end
							local fileName = ("%i.%s.%s.Source.txt"):format(game.PlaceId, v.Obj.ClassName, env.parsefile(v.Obj.Name))
							env.writefile(fileName, source)
							task.wait(0.2)
						end
					end
				end})

				context:Register("SAVE_BYTECODE",{Name = "Save Script Bytecode", IconMap = Explorer.MiscIcons, Icon = "Save", OnClick = function()
					for _, v in next, selection.List do
						if v.Obj:IsA("LuaSourceContainer") and env.isViableDecompileScript(v.Obj) then
							local success, bytecode = pcall(getscriptbytecode, v.Obj)
							if success and type(bytecode) == "string" then
								local fileName = ("%i.%s.%s.Bytecode.txt"):format(game.PlaceId, v.Obj.ClassName, env.parsefile(v.Obj.Name))
								env.writefile(fileName, bytecode)
								task.wait(0.2)
							end
						end
					end
				end})

				context:Register("SELECT_CHARACTER",{Name = "Select Character", IconMap = Explorer.ClassIcons, Icon = 9, OnClick = function()
					local newSelection = {}
					local count = 1
					local sList = selection.List
					local isa = game.IsA

					for i = 1,#sList do
						local node = sList[i]
						if isa(node.Obj,"Player") and nodes[node.Obj.Character] then
							newSelection[count] = nodes[node.Obj.Character]
							count = count + 1
						end
					end

					selection:SetTable(newSelection)
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					else
						Explorer.Refresh()
					end
				end})

				context:Register("VIEW_PLAYER",{Name = "View Player", IconMap = Explorer.ClassIcons, Icon = 5, OnClick = function()
					local newSelection = {}
					local count = 1
					local sList = selection.List
					local isa = game.IsA

					for i = 1,#sList do
						local node = sList[i]
						local Obj = node.Obj
						if Obj:IsA("Player") and Obj.Character then
							workspace.CurrentCamera.CameraSubject = Obj.Character
							break
						end
					end
				end})

				context:Register("SELECT_LOCAL_PLAYER",{Name = "Select Local Player", IconMap = Explorer.ClassIcons, Icon = 9, OnClick = function()
					pcall(function() if nodes[plr] then selection:Set(nodes[plr]) Explorer.ViewNode(nodes[plr]) end end)
				end})

				context:Register("SELECT_ALL_CHARACTERS",{Name = "Select All Characters", IconMap = Explorer.ClassIcons, Icon = 2, OnClick = function()
					local newSelection = {}
					local sList = selection.List

					for i,v in next, service.Players:GetPlayers() do
						if v.Character and nodes[v.Character] then
							if i == 1 then Explorer.MakeNodeVisible(v.Character) end
							table.insert(newSelection, nodes[v.Character])
						end
					end

					selection:SetTable(newSelection)
					if #newSelection > 0 then
						Explorer.ViewNode(newSelection[1])
					else
						Explorer.Refresh()
					end
				end})

				context:Register("REFRESH_NIL",{Name = "Refresh Nil Instances", OnClick = function()
					Explorer.RefreshNilInstances()
				end})

				context:Register("HIDE_NIL",{Name = "Hide Nil Instances", OnClick = function()
					Explorer.HideNilInstances()
				end})

				Explorer.RightClickContext = context
			end

			Explorer.HideNilInstances = function()
				table.clear(nilMap)

				local disconnectCon = Instance.new("Folder").ChildAdded:Connect(function() end).Disconnect
				for i,v in next,nilCons do
					disconnectCon(v[1])
					disconnectCon(v[2])
				end
				table.clear(nilCons)

				for i = 1,#nilNode do
					coroutine.wrap(removeObject)(nilNode[i].Obj)
				end

				Explorer.Update()
				Explorer.Refresh()
			end

			Explorer.RefreshNilInstances = function()
				if not env.getnilinstances then return end

				local nilInsts = env.getnilinstances()
				local game = game
				local getDescs = game.GetDescendants
				--local newNilMap = {}
				--local newNilRoots = {}
				--local nilRoots = Explorer.NilRoots
				--local connect = game.DescendantAdded.Connect
				--local disconnect
				--if not nilRoots then nilRoots = {} Explorer.NilRoots = nilRoots end

				for i = 1,#nilInsts do
					local obj = nilInsts[i]
					if obj ~= game then
						nilMap[obj] = true
						--newNilRoots[obj] = true

						local descs = getDescs(obj)
						for j = 1,#descs do
							nilMap[descs[j]] = true
						end
					end
				end

				-- Remove unmapped nil nodes
		--[[for i = 1,#nilNode do
			local node = nilNode[i]
			if not newNilMap[node.Obj] then
				nilMap[node.Obj] = nil
				coroutine.wrap(removeObject)(node)
			end
		end]]

				--nilMap = newNilMap

				for i = 1,#nilInsts do
					local obj = nilInsts[i]
					local node = nodes[obj]
					if not node then coroutine.wrap(addObject)(obj) end
				end

		--[[
		-- Remove old root connections
		for obj in next,nilRoots do
			if not newNilRoots[obj] then
				if not disconnect then disconnect = obj[1].Disconnect end
				disconnect(obj[1])
				disconnect(obj[2])
			end
		end
		
		for obj in next,newNilRoots do
			if not nilRoots[obj] then
				nilRoots[obj] = {
					connect(obj.DescendantAdded,addObject),
					connect(obj.DescendantRemoving,removeObject)
				}
			end
		end]]

				--nilMap = newNilMap
				--Explorer.NilRoots = newNilRoots

				Explorer.Update()
				Explorer.Refresh()
			end

			Explorer.GetInstancePath = function(obj)
				local ffc = game.FindFirstChild
				local getCh = game.GetChildren
				local path = ""
				local curObj = obj
				local ts = tostring
				local match = string.match
				local gsub = string.gsub
				local tableFind = table.find
				local useGetCh = Settings.Explorer.CopyPathUseGetChildren
				local formatLuaString = Lib.FormatLuaString

				while curObj do
					if curObj == game then
						path = "game"..path
						break
					end

					local className = curObj.ClassName
					local curName = ts(curObj)
					local indexName
					if match(curName,"^[%a_][%w_]*$") then
						indexName = "."..curName
					else
						local cleanName = formatLuaString(curName)
						indexName = '["'..cleanName..'"]'
					end

					local parObj = curObj.Parent
					if parObj then
						local fc = ffc(parObj,curName)
						if useGetCh and fc and fc ~= curObj then
							local parCh = getCh(parObj)
							local fcInd = tableFind(parCh,curObj)
							indexName = ":GetChildren()["..fcInd.."]"
						elseif parObj == game and API.Classes[className] and API.Classes[className].Tags.Service then
							indexName = ':GetService("'..className..'")'
						end
					elseif parObj == nil then
						local getnil = "local getNil = function(name, class) for _, v in next, getnilinstances() do if v.ClassName == class and v.Name == name then return v end end end"
						local gotnil = "\n\ngetNil(\"%s\", \"%s\")"
						indexName = getnil .. gotnil:format(curObj.Name, className)
					end

					path = indexName..path
					curObj = parObj
				end

				return path
			end

			Explorer.DefaultProps = {
				["BasePart"] = {
					Position = function(Obj)
						local Player = service.Players.LocalPlayer
						if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
							Obj.Position = (Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)).p
						end
						return Obj.Position
					end,
					Anchored = true
				},
				["GuiObject"] = {
					Position = function(Obj) return (Obj.Parent:IsA("ScreenGui") and UDim2.new(0.5, 0, 0.5, 0)) or Obj.Position end,
					Active = true
				}
			}

			Explorer.InitInsertObject = function()
				local context = Lib.ContextMenu.new()
				context.SearchEnabled = true
				context.MaxHeight = 400
				context:ApplyTheme({
					ContentColor = Settings.Theme.Main2,
					OutlineColor = Settings.Theme.Outline1,
					DividerColor = Settings.Theme.Outline1,
					TextColor = Settings.Theme.Text,
					HighlightColor = Settings.Theme.ButtonHover
				})

				local classes = {}
				for i,class in next,API.Classes do
					local tags = class.Tags
					if not tags.NotCreatable and not tags.Service then
						local rmdEntry = RMD.Classes[class.Name]
						classes[#classes+1] = {class,rmdEntry and rmdEntry.ClassCategory or "Uncategorized"}
					end
				end
				table.sort(classes,function(a,b)
					if a[2] ~= b[2] then
						return a[2] < b[2]
					else
						return a[1].Name < b[1].Name
					end
				end)

				local function defaultProps(obj)
					for class, props in pairs(Explorer.DefaultProps) do
						if obj:IsA(class) then
							for prop, value in pairs(props) do
								obj[prop] = (type(value) == "function" and value(obj)) or value
							end
						end
					end
				end

				local function onClick(className)
					local sList = selection.List
					local instNew = Instance.new
					for i = 1,#sList do
						local node = sList[i]
						local obj = node.Obj
						Explorer.MakeNodeVisible(node, true)
						local success, obj = pcall(instNew, className, obj)
						if success and obj then defaultProps(obj) end
					end
				end

				local lastCategory = ""
				for i = 1,#classes do
					local class = classes[i][1]
					local rmdEntry = RMD.Classes[class.Name]
					local iconInd = rmdEntry and tonumber(rmdEntry.ExplorerImageIndex) or 0
					local category = classes[i][2]

					if lastCategory ~= category then
						context:AddDivider(category)
						lastCategory = category
					end
					context:Add({Name = class.Name, IconMap = Explorer.ClassIcons, Icon = iconInd, OnClick = onClick})
				end

				Explorer.InsertObjectContext = context
			end

			Explorer._SearchFilters = {} do
				local Filters = Explorer._SearchFilters

				local function NewFilter(list, func)
					for _,v in next, list do
						Filters[v:lower() .. ":"] = func
					end
				end

				local Only = {
					remotes = {"RemoteEvent", "RemoteFunction", "BindableEvent", "BindableFunction"},
					scripts = {"Script", "LocalScript", "ModuleScript"},
					players = {"Player"}
				}

				NewFilter({"parent", "p"}, function(Obj, str) return Obj.Parent and (Obj.Parent.Name:lower()):find(str) end)
				NewFilter({"class", "c"}, function(Obj, str) return (Obj.ClassName:lower()):find(str) end)
				NewFilter({"isa", "i"}, function(Obj, str) return Obj:IsA(str) end)

				NewFilter({"only", "o"}, function(Obj, str)
					local Special = Only[str]
					return Special and table.find(Special, Obj.ClassName)
				end)
			end

			Explorer.DoSearch = function(query)
				table.clear(Explorer.SearchExpanded)
				table.clear(searchResults)
				expanded = (#query == 0 and Explorer.Expanded) or Explorer.SearchExpanded

				local tostr = tostring;
				local tfind = table.find;

				local Filters = Explorer._SearchFilters
				local expandTable = Explorer.SearchExpanded

				local allnodes = nodes[game]

				local defaultSearch = (function(Obj, str) return (Obj.Name:lower()):find(str, 1, true) end)

				local function searchTable(root, str, func)
					local expandedpar = false
					for _,node in ipairs(root) do
						if func(node.Obj, str) then
							expandTable[node] = 0
							searchResults[node] = true
							if not expandedpar then
								local parnode = node.Parent
								while parnode and (not searchResults[parnode] or expandTable[parnode] == 0) do
									expanded[parnode] = true
									searchResults[parnode] = true
									parnode = parnode.Parent
								end
								expandedpar = true
							end
						end

						if #node > 0 then searchTable(node, str, func) end
					end
				end

				local function Search(query)
					if query:len() == 0 then return end

					local lower = query:lower()
					local split = lower:split(":")
					local Filter = (Filters[split[1] .. ":"]) or nil

					if Filter then
						searchTable(allnodes, (split[2] or ""), Filter)
					else
						searchTable(allnodes, (lower or ""), defaultSearch)
					end
				end

				for _,v in ipairs(query:split(",")) do
					if v:len() > 0 then
						Search(v)
					end
				end

		--[=[if #query > 0 then
			local expandTable = Explorer.SearchExpanded
			local specFilters
			
			local lower = string.lower
			local find = string.find
			local tostring = tostring
			
			local lowerQuery = lower(query)
			
			local function defaultSearch(root)
				local expandedpar = false
				for i = 1,#root do
					local node = root[i]
					local obj = node.Obj
					
					if find(lower(tostring(obj)),lowerQuery,1,true) then
						expandTable[node] = 0
						searchResults[node] = true
						if not expandedpar then
							local parnode = node.Parent
							while parnode and (not searchResults[parnode] or expandTable[parnode] == 0) do
								expanded[parnode] = true
								searchResults[parnode] = true
								parnode = parnode.Parent
							end
							expandedpar = true
						end
					elseif ExplorerSearch[lower(tostring(obj))] then
						
					end
					
					if #node > 0 then defaultSearch(node) end
				end
			end

			if Main.Elevated then
				local start = tick()
				searchFunc,specFilters = Explorer.BuildSearchFunc(query)
				--print("BUILD SEARCH",tick()-start)
			else
				searchFunc = defaultSearch
			end

			if specFilters then
				table.clear(specResults)
				for i = 1,#specFilters do -- Specific search filers that returns list of matches
					local resMap = {}
					specResults[i] = resMap
					local objs = specFilters[i]()
					for c = 1,#objs do
						local node = nodes[objs[c]]
						if node then
							resMap[node] = true
						end
					end
				end
			end
			
			if searchFunc then
				local start = tick()
				searchFunc(nodes[game])
				searchFunc(nilNode)
				--warn(tick()-start)
			end
		end]=]

				Explorer.ForceUpdate()
			end

			Explorer.ClearSearch = function()
				Explorer.GuiElems.SearchBar.Text = ""
				expanded = Explorer.Expanded
				searchFunc = nil
			end

			Explorer.InitSearch = function()
				local TweenService = service.TweenService
				local SearchFrame = Explorer.GuiElems.ToolBar.SearchFrame
				local searchBox = SearchFrame.SearchBox
				Explorer.GuiElems.SearchBar = searchBox

				local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint)
				local Tweens = {
					Start = TweenService:Create(SearchFrame.UIStroke, TweenInfo, { Color = Color3.fromRGB(0, 120, 215) }),
					End = TweenService:Create(SearchFrame.UIStroke, TweenInfo, { Color = Color3.fromRGB(42, 42, 42) })
				}

				searchBox.FocusLost:Connect(function() Tweens.End:Play() end)
				searchBox.Focused:Connect(function() Tweens.Start:Play() end)

				Lib.ViewportTextBox.convert(searchBox)

				searchBox.FocusLost:Connect(function()
					Explorer.DoSearch(searchBox.Text)
				end)
			end

			Explorer.InitEntryTemplate = function()
				entryTemplate = create({
					{1,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderColor3=Color3.new(0,0,0),Font=3,Name="Entry",Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,250,0,20),Text="",TextSize=14,}},
					{2,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=0,Name="Indent",Parent={1},Position=UDim2.new(0,20,0,0),Size=UDim2.new(1,-20,1,0),}},
					{3,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="EntryName",Parent={2},Position=UDim2.new(0,26,0,0),Size=UDim2.new(1,-26,1,0),Text="Workspace",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
					{4,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClipsDescendants=true,Font=3,Name="Expand",Parent={2},Position=UDim2.new(0,-20,0,0),Size=UDim2.new(0,20,0,20),Text="",TextSize=14,}},
					{5,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642383285",ImageRectOffset=Vector2.new(144,16),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={4},Position=UDim2.new(0,2,0,2),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
					{6,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ImageRectOffset=Vector2.new(304,0),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={2},Position=UDim2.new(0,4,0,2),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
				})

				local sys = Lib.ClickSystem.new()
				sys.AllowedButtons = {1,2}
				sys.OnDown:Connect(function(item,combo,button)
					local ind = table.find(listEntries,item)
					if not ind then return end
					local node = tree[ind + Explorer.Index]
					if not node then return end

					local entry = listEntries[ind]

					if button == 1 then
						if combo == 2 then
							if node.Obj:IsA("LuaSourceContainer") then
								ScriptViewer.ViewScript(node.Obj)
							elseif #node > 0 and expanded[node] ~= 0 then
								expanded[node] = not expanded[node]
								Explorer.Update()
							end
						end

						if Properties.SelectObject(node.Obj) then
							sys.IsRenaming = false
							return
						end

						sys.IsRenaming = selection.Map[node]

						if Lib.IsShiftDown() then
							if not selection.Piviot then return end

							local fromIndex = table.find(tree,selection.Piviot)
							local toIndex = table.find(tree,node)
							if not fromIndex or not toIndex then return end
							fromIndex,toIndex = math.min(fromIndex,toIndex),math.max(fromIndex,toIndex)

							local sList = selection.List
							for i = #sList,1,-1 do
								local elem = sList[i]
								if selection.ShiftSet[elem] then
									selection.Map[elem] = nil
									table.remove(sList,i)
								end
							end
							selection.ShiftSet = {}
							for i = fromIndex,toIndex do
								local elem = tree[i]
								if not selection.Map[elem] then
									selection.ShiftSet[elem] = true
									selection.Map[elem] = true
									sList[#sList+1] = elem
								end
							end
							selection.Changed:Fire()
						elseif Lib.IsCtrlDown() then
							selection.ShiftSet = {}
							if selection.Map[node] then selection:Remove(node) else selection:Add(node) end
							selection.Piviot = node
							sys.IsRenaming = false
						elseif not selection.Map[node] then
							selection.ShiftSet = {}
							selection:Set(node)
							selection.Piviot = node
						end
					elseif button == 2 then
						if Properties.SelectObject(node.Obj) then
							return
						end

						if not Lib.IsCtrlDown() and not selection.Map[node] then
							selection.ShiftSet = {}
							selection:Set(node)
							selection.Piviot = node
							Explorer.Refresh()
						end
					end

					Explorer.Refresh()
				end)

				sys.OnRelease:Connect(function(item,combo,button,position)
					local ind = table.find(listEntries,item)
					if not ind then return end
					local node = tree[ind + Explorer.Index]
					if not node then return end

					if button == 1 then
						if selection.Map[node] and not Lib.IsShiftDown() and not Lib.IsCtrlDown() then
							selection.ShiftSet = {}
							selection:Set(node)
							selection.Piviot = node
							Explorer.Refresh()
						end

						local id = sys.ClickId
						Lib.FastWait(sys.ComboTime)
						if combo == 1 and id == sys.ClickId and sys.IsRenaming and selection.Map[node] then
							Explorer.SetRenamingNode(node)
						end
					elseif button == 2 then
						Explorer.ShowRightClick(position)
					end
				end)
				Explorer.ClickSystem = sys
			end

			Explorer.InitDelCleaner = function()
				coroutine.wrap(function()
					local fw = Lib.FastWait
					while true do
						local processed = false
						local c = 0
						for _,node in next,nodes do
							if node.HasDel then
								local delInd
								for i = 1,#node do
									if node[i].Del then
										delInd = i
										break
									end
								end
								if delInd then
									for i = delInd+1,#node do
										local cn = node[i]
										if not cn.Del then
											node[delInd] = cn
											delInd = delInd+1
										end
									end
									for i = delInd,#node do
										node[i] = nil
									end
								end
								node.HasDel = false
								processed = true
								fw()
							end
							c = c + 1
							if c > 10000 then
								c = 0
								fw()
							end
						end
						if processed and not refreshDebounce then Explorer.PerformRefresh() end
						fw(0.5)
					end
				end)()
			end

			Explorer.UpdateSelectionVisuals = function()
				local holder = Explorer.SelectionVisualsHolder
				local isa = game.IsA
				local clone = game.Clone
				if not holder then
					holder = Instance.new("ScreenGui")
					holder.Name = "ExplorerSelections"
					holder.DisplayOrder = Main.DisplayOrders.Core
					Lib.ShowGui(holder)
					Explorer.SelectionVisualsHolder = holder
					Explorer.SelectionVisualCons = {}

					local guiTemplate = create({
						{1,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Size=UDim2.new(0,100,0,100),}},
						{2,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,-1,0,-1),Size=UDim2.new(1,2,0,1),}},
						{3,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,-1,1,0),Size=UDim2.new(1,2,0,1),}},
						{4,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,-1,0,0),Size=UDim2.new(0,1,1,0),}},
						{5,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BorderSizePixel=0,Parent={1},Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,1,1,0),}},
					})
					Explorer.SelectionVisualGui = guiTemplate

					local boxTemplate = Instance.new("SelectionBox")
					boxTemplate.LineThickness = 0.03
					boxTemplate.Color3 = Color3.fromRGB(0, 170, 255)
					Explorer.SelectionVisualBox = boxTemplate
				end
				holder:ClearAllChildren()

				-- Updates theme
				for i,v in pairs(Explorer.SelectionVisualGui:GetChildren()) do
					v.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
				end

				local attachCons = Explorer.SelectionVisualCons
				for i = 1,#attachCons do
					attachCons[i].Destroy()
				end
				table.clear(attachCons)

				local partEnabled = Settings.Explorer.PartSelectionBox
				local guiEnabled = Settings.Explorer.GuiSelectionBox
				if not partEnabled and not guiEnabled then return end

				local svg = Explorer.SelectionVisualGui
				local svb = Explorer.SelectionVisualBox
				local attachTo = Lib.AttachTo
				local sList = selection.List
				local count = 1
				local boxCount = 0
				local workspaceNode = nodes[workspace]
				for i = 1,#sList do
					if boxCount > 1000 then break end
					local node = sList[i]
					local obj = node.Obj

					if node ~= workspaceNode then
						if isa(obj,"GuiObject") and guiEnabled then
							local newVisual = clone(svg)
							attachCons[count] = attachTo(newVisual,{Target = obj, Resize = true})
							count = count + 1
							newVisual.Parent = holder
							boxCount = boxCount + 1
						elseif isa(obj,"PVInstance") and partEnabled then
							local newBox = clone(svb)
							newBox.Adornee = obj
							newBox.Parent = holder
							boxCount = boxCount + 1
						end
					end
				end
			end

			Explorer.Init = function()
				Explorer.ClassIcons = Lib.IconMap.newLinear("rbxasset://textures/ClassImages.PNG", 16, 16)
				Explorer.MiscIcons = Main.MiscIcons

				clipboard = {}

				selection = Lib.Set.new()
				selection.ShiftSet = {}
				selection.Changed:Connect(Properties.ShowExplorerProps)
				Explorer.Selection = selection

				Explorer.InitRightClick()
				Explorer.InitInsertObject()
				Explorer.SetSortingEnabled(Settings.Explorer.Sorting)
				Explorer.Expanded = setmetatable({},{__mode = "k"})
				Explorer.SearchExpanded = setmetatable({},{__mode = "k"})
				expanded = Explorer.Expanded

				nilNode.Obj.Name = "Nil Instances"
				nilNode.Locked = true

				local explorerItems = create({
					{1,"Folder",{Name="ExplorerItems",}},
					{2,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="ToolBar",Parent={1},Size=UDim2.new(1,0,0,22),}},
					{3,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.1176470592618,0.1176470592618,0.1176470592618),BorderSizePixel=0,Name="SearchFrame",Parent={2},Position=UDim2.new(0,3,0,1),Size=UDim2.new(1,-6,0,18),}},
					{4,"TextBox",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClearTextOnFocus=false,Font=3,Name="SearchBox",Parent={3},PlaceholderColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),PlaceholderText="Search workspace",Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-24,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,}},
					{5,"UICorner",{CornerRadius=UDim.new(0,2),Parent={3},}},
					{6,"UIStroke",{Thickness=1.4,Parent={3},Color=Color3.fromRGB(42,42,42)}},
					{7,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Reset",Parent={3},Position=UDim2.new(1,-17,0,1),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
					{8,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5034718129",ImageColor3=Color3.new(0.39215686917305,0.39215686917305,0.39215686917305),Parent={7},Size=UDim2.new(0,16,0,16),}},
					{9,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Refresh",Parent={2},Position=UDim2.new(1,-20,0,1),Size=UDim2.new(0,18,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,Visible=false,}},
					{10,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642310344",Parent={9},Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,12,0,12),}},
					{11,"Frame",{BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Name="ScrollCorner",Parent={1},Position=UDim2.new(1,-16,1,-16),Size=UDim2.new(0,16,0,16),Visible=false,}},
					{12,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClipsDescendants=true,Name="List",Parent={1},Position=UDim2.new(0,0,0,23),Size=UDim2.new(1,0,1,-23),}}
				})

				toolBar = explorerItems.ToolBar
				treeFrame = explorerItems.List

				Explorer.GuiElems.ToolBar = toolBar
				Explorer.GuiElems.TreeFrame = treeFrame

				scrollV = Lib.ScrollBar.new()		
				scrollV.WheelIncrement = 3
				scrollV.Gui.Position = UDim2.new(1,-16,0,23)
				scrollV:SetScrollFrame(treeFrame)
				scrollV.Scrolled:Connect(function()
					Explorer.Index = scrollV.Index
					Explorer.Refresh()
				end)

				scrollH = Lib.ScrollBar.new(true)
				scrollH.Increment = 5
				scrollH.WheelIncrement = Explorer.EntryIndent
				scrollH.Gui.Position = UDim2.new(0,0,1,-16)
				scrollH.Scrolled:Connect(function()
					Explorer.Refresh()
				end)

				local window = Lib.Window.new()
				Explorer.Window = window
				window:SetTitle("Explorer")
				window.GuiElems.Line.Position = UDim2.new(0,0,0,22)

				Explorer.InitEntryTemplate()
				toolBar.Parent = window.GuiElems.Content
				treeFrame.Parent = window.GuiElems.Content
				explorerItems.ScrollCorner.Parent = window.GuiElems.Content
				scrollV.Gui.Parent = window.GuiElems.Content
				scrollH.Gui.Parent = window.GuiElems.Content

				-- Init stuff that requires the window
				Explorer.InitRenameBox()
				Explorer.InitSearch()
				Explorer.InitDelCleaner()
				selection.Changed:Connect(Explorer.UpdateSelectionVisuals)

				-- Window events
				window.GuiElems.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if Explorer.Active then
						Explorer.UpdateView()
						Explorer.Refresh()
					end
				end)
				window.OnActivate:Connect(function()
					Explorer.Active = true
					Explorer.UpdateView()
					Explorer.Update()
					Explorer.Refresh()
				end)
				window.OnRestore:Connect(function()
					Explorer.Active = true
					Explorer.UpdateView()
					Explorer.Update()
					Explorer.Refresh()
				end)
				window.OnDeactivate:Connect(function() Explorer.Active = false end)
				window.OnMinimize:Connect(function() Explorer.Active = false end)

				-- Settings
				autoUpdateSearch = Settings.Explorer.AutoUpdateSearch

				-- Fill in nodes
				nodes[game] = {Obj = game}
				expanded[nodes[game]] = true

				-- Nil Instances
				if env.getnilinstances then
					nodes[nilNode.Obj] = nilNode
				end

				Explorer.SetupConnections()

				local insts = getDescendants(game)
				if Main.Elevated then
					for i = 1,#insts do
						local obj = insts[i]
						local par = nodes[ffa(obj,"Instance")]
						if not par then continue end
						local newNode = {
							Obj = obj,
							Parent = par,
						}
						nodes[obj] = newNode
						par[#par+1] = newNode
					end
				else
					for i = 1,#insts do
						local obj = insts[i]
						local s,parObj = pcall(ffa,obj,"Instance")
						local par = nodes[parObj]
						if not par then continue end
						local newNode = {
							Obj = obj,
							Parent = par,
						}
						nodes[obj] = newNode
						par[#par+1] = newNode
					end
				end
			end

			return Explorer
		end

		return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
	end,
	Properties = function()
--[[
	Properties App Module
	
	The main properties interface
]]

		-- Common Locals
		local Main,Lib,Apps,Settings -- Main Containers
		local Explorer, Properties, ScriptViewer, Notebook -- Major Apps
		local API,RMD,env,service,plr,create,createSimple -- Main Locals

		local function initDeps(data)
			Main = data.Main
			Lib = data.Lib
			Apps = data.Apps
			Settings = data.Settings

			API = data.API
			RMD = data.RMD
			env = data.env
			service = data.service
			plr = data.plr
			create = data.create
			createSimple = data.createSimple
		end

		local function initAfterMain()
			Explorer = Apps.Explorer
			Properties = Apps.Properties
			ScriptViewer = Apps.ScriptViewer
			Notebook = Apps.Notebook
		end

		local function main()
			local Properties = {}

			local window, toolBar, propsFrame
			local scrollV, scrollH
			local categoryOrder
			local props,viewList,expanded,indexableProps,propEntries,autoUpdateObjs = {},{},{},{},{},{}
			local inputBox,inputTextBox,inputProp
			local checkboxes,propCons = {},{}
			local table,string = table,string
			local getPropChangedSignal = game.GetPropertyChangedSignal
			local getAttributeChangedSignal = game.GetAttributeChangedSignal
			local isa = game.IsA
			local getAttribute = game.GetAttribute
			local setAttribute = game.SetAttribute

			Properties.GuiElems = {}
			Properties.Index = 0
			Properties.ViewWidth = 0
			Properties.MinInputWidth = 100
			Properties.EntryIndent = 16
			Properties.EntryOffset = 4
			Properties.NameWidthCache = {}
			Properties.SubPropCache = {}
			Properties.ClassLists = {}
			Properties.SearchText = ""

			Properties.AddAttributeProp = {Category = "Attributes", Class = "", Name = "", SpecialRow = "AddAttribute", Tags = {}}
			Properties.SoundPreviewProp = {Category = "Data", ValueType = {Name = "SoundPlayer"}, Class = "Sound", Name = "Preview", Tags = {}}

			Properties.IgnoreProps = {
				["DataModel"] = {
					["PrivateServerId"] = true,
					["PrivateServerOwnerId"] = true,
					["VIPServerId"] = true,
					["VIPServerOwnerId"] = true
				}
			}

			Properties.ExpandableTypes = {
				["Vector2"] = true,
				["Vector3"] = true,
				["UDim"] = true,
				["UDim2"] = true,
				["CFrame"] = true,
				["Rect"] = true,
				["PhysicalProperties"] = true,
				["Ray"] = true,
				["NumberRange"] = true,
				["Faces"] = true,
				["Axes"] = true
			}

			Properties.ExpandableProps = {
				["Sound.SoundId"] = true
			}

			Properties.CollapsedCategories = {
				["Surface Inputs"] = true,
				["Surface"] = true
			}

			Properties.ConflictSubProps = {
				["Vector2"] = {"X","Y"},
				["Vector3"] = {"X","Y","Z"},
				["UDim"] = {"Scale","Offset"},
				["UDim2"] = {"X","X.Scale","X.Offset","Y","Y.Scale","Y.Offset"},
				["CFrame"] = {"Position","Position.X","Position.Y","Position.Z",
					"RightVector","RightVector.X","RightVector.Y","RightVector.Z",
					"UpVector","UpVector.X","UpVector.Y","UpVector.Z",
					"LookVector","LookVector.X","LookVector.Y","LookVector.Z"},
				["Rect"] = {"Min.X","Min.Y","Max.X","Max.Y"},
				["PhysicalProperties"] = {"Density","Elasticity","ElasticityWeight","Friction","FrictionWeight"},
				["Ray"] = {"Origin","Origin.X","Origin.Y","Origin.Z","Direction","Direction.X","Direction.Y","Direction.Z"},
				["NumberRange"] = {"Min","Max"},
				["Faces"] = {"Back","Bottom","Front","Left","Right","Top"},
				["Axes"] = {"X","Y","Z"}
			}

			Properties.ConflictIgnore = {
				["BasePart"] = {
					["ResizableFaces"] = true
				}
			}

			Properties.RoundableTypes = {
				["float"] = true,
				["double"] = true,
				["Color3"] = true,
				["UDim"] = true,
				["UDim2"] = true,
				["Vector2"] = true,
				["Vector3"] = true,
				["NumberRange"] = true,
				["Rect"] = true,
				["NumberSequence"] = true,
				["ColorSequence"] = true,
				["Ray"] = true,
				["CFrame"] = true
			}

			Properties.TypeNameConvert = {
				["number"] = "double",
				["boolean"] = "bool"
			}

			Properties.ToNumberTypes = {
				["int"] = true,
				["int64"] = true,
				["float"] = true,
				["double"] = true
			}

			Properties.DefaultPropValue = {
				string = "",
				bool = false,
				double = 0,
				UDim = UDim.new(0,0),
				UDim2 = UDim2.new(0,0,0,0),
				BrickColor = BrickColor.new("Medium stone grey"),
				Color3 = Color3.new(1,1,1),
				Vector2 = Vector2.new(0,0),
				Vector3 = Vector3.new(0,0,0),
				NumberSequence = NumberSequence.new(1),
				ColorSequence = ColorSequence.new(Color3.new(1,1,1)),
				NumberRange = NumberRange.new(0),
				Rect = Rect.new(0,0,0,0)
			}

			Properties.AllowedAttributeTypes = {"string","boolean","number","UDim","UDim2","BrickColor","Color3","Vector2","Vector3","NumberSequence","ColorSequence","NumberRange","Rect"}

			Properties.StringToValue = function(prop,str)
				local typeData = prop.ValueType
				local typeName = typeData.Name

				if typeName == "string" or typeName == "Content" then
					return str
				elseif Properties.ToNumberTypes[typeName] then
					return tonumber(str)
				elseif typeName == "Vector2" then
					local vals = str:split(",")
					local x,y = tonumber(vals[1]),tonumber(vals[2])
					if x and y and #vals >= 2 then return Vector2.new(x,y) end
				elseif typeName == "Vector3" then
					local vals = str:split(",")
					local x,y,z = tonumber(vals[1]),tonumber(vals[2]),tonumber(vals[3])
					if x and y and z and #vals >= 3 then return Vector3.new(x,y,z) end
				elseif typeName == "UDim" then
					local vals = str:split(",")
					local scale,offset = tonumber(vals[1]),tonumber(vals[2])
					if scale and offset and #vals >= 2 then return UDim.new(scale,offset) end
				elseif typeName == "UDim2" then
					local vals = str:gsub("[{}]",""):split(",")
					local xScale,xOffset,yScale,yOffset = tonumber(vals[1]),tonumber(vals[2]),tonumber(vals[3]),tonumber(vals[4])
					if xScale and xOffset and yScale and yOffset and #vals >= 4 then return UDim2.new(xScale,xOffset,yScale,yOffset) end
				elseif typeName == "CFrame" then
					local vals = str:split(",")
					local s,result = pcall(CFrame.new, unpack(vals))
					if s and #vals >= 12 then return result end
				elseif typeName == "Rect" then
					local vals = str:split(",")
					local s,result = pcall(Rect.new,unpack(vals))
					if s and #vals >= 4 then return result end
				elseif typeName == "Ray" then
					local vals = str:gsub("[{}]",""):split(",")
					local s,origin = pcall(Vector3.new,unpack(vals,1,3))
					local s2,direction = pcall(Vector3.new,unpack(vals,4,6))
					if s and s2 and #vals >= 6 then return Ray.new(origin,direction) end
				elseif typeName == "NumberRange" then
					local vals = str:split(",")
					local s,result = pcall(NumberRange.new,unpack(vals))
					if s and #vals >= 1 then return result end
				elseif typeName == "Color3" then
					local vals = str:gsub("[{}]",""):split(",")
					local s,result = pcall(Color3.fromRGB,unpack(vals))
					if s and #vals >= 3 then return result end
				end

				return nil
			end

			Properties.ValueToString = function(prop,val)
				local typeData = prop.ValueType
				local typeName = typeData.Name

				if typeName == "Color3" then
					return Lib.ColorToBytes(val)
				elseif typeName == "NumberRange" then
					return val.Min..", "..val.Max
				end

				return tostring(val)
			end

			Properties.GetIndexableProps = function(obj,classData)
				if not Main.Elevated then
					if not pcall(function() return obj.ClassName end) then return nil end
				end

				local ignoreProps = Properties.IgnoreProps[classData.Name] or {}

				local result = {}
				local count = 1
				local props = classData.Properties
				for i = 1,#props do
					local prop = props[i]
					if not ignoreProps[prop.Name] then
						local s = pcall(function() return obj[prop.Name] end)
						if s then
							result[count] = prop
							count = count + 1
						end
					end
				end

				return result
			end

			Properties.FindFirstObjWhichIsA = function(class)
				local classList = Properties.ClassLists[class] or {}
				if classList and #classList > 0 then
					return classList[1]
				end

				return nil
			end

			Properties.ComputeConflicts = function(p)
				local maxConflictCheck = Settings.Properties.MaxConflictCheck
				local sList = Explorer.Selection.List
				local classLists = Properties.ClassLists
				local stringSplit = string.split
				local t_clear = table.clear
				local conflictIgnore = Properties.ConflictIgnore
				local conflictMap = {}
				local propList = p and {p} or props

				if p then
					local gName = p.Class.."."..p.Name
					autoUpdateObjs[gName] = nil
					local subProps = Properties.ConflictSubProps[p.ValueType.Name] or {}
					for i = 1,#subProps do
						autoUpdateObjs[gName.."."..subProps[i]] = nil
					end
				else
					table.clear(autoUpdateObjs)
				end

				if #sList > 0 then
					for i = 1,#propList do
						local prop = propList[i]
						local propName,propClass = prop.Name,prop.Class
						local typeData = prop.RootType or prop.ValueType
						local typeName = typeData.Name
						local attributeName = prop.AttributeName
						local gName = propClass.."."..propName

						local checked = 0
						local subProps = Properties.ConflictSubProps[typeName] or {}
						local subPropCount = #subProps
						local toCheck = subPropCount + 1
						local conflictsFound = 0
						local indexNames = {}
						local ignored = conflictIgnore[propClass] and conflictIgnore[propClass][propName]
						local truthyCheck = (typeName == "PhysicalProperties")
						local isAttribute = prop.IsAttribute
						local isMultiType = prop.MultiType

						t_clear(conflictMap)

						if not isMultiType then
							local firstVal,firstObj,firstSet
							local classList = classLists[prop.Class] or {}
							for c = 1,#classList do
								local obj = classList[c]
								if not firstSet then
									if isAttribute then
										firstVal = getAttribute(obj,attributeName)
										if firstVal ~= nil then
											firstObj = obj
											firstSet = true
										end
									else
										firstVal = obj[propName]
										firstObj = obj
										firstSet = true
									end
									if ignored then break end
								else
									local propVal,skip
									if isAttribute then
										propVal = getAttribute(obj,attributeName)
										if propVal == nil then skip = true end
									else
										propVal = obj[propName]
									end

									if not skip then
										if not conflictMap[1] then
											if truthyCheck then
												if (firstVal and true or false) ~= (propVal and true or false) then
													conflictMap[1] = true
													conflictsFound = conflictsFound + 1
												end
											elseif firstVal ~= propVal then
												conflictMap[1] = true
												conflictsFound = conflictsFound + 1
											end
										end

										if subPropCount > 0 then
											for sPropInd = 1,subPropCount do
												local indexes = indexNames[sPropInd]
												if not indexes then indexes = stringSplit(subProps[sPropInd],".") indexNames[sPropInd] = indexes end

												local firstValSub = firstVal
												local propValSub = propVal

												for j = 1,#indexes do
													if not firstValSub or not propValSub then break end -- PhysicalProperties
													local indexName = indexes[j]
													firstValSub = firstValSub[indexName]
													propValSub = propValSub[indexName]
												end

												local mapInd = sPropInd + 1
												if not conflictMap[mapInd] and firstValSub ~= propValSub then
													conflictMap[mapInd] = true
													conflictsFound = conflictsFound + 1
												end
											end
										end

										if conflictsFound == toCheck then break end
									end
								end

								checked = checked + 1
								if checked == maxConflictCheck then break end
							end

							if not conflictMap[1] then autoUpdateObjs[gName] = firstObj end
							for sPropInd = 1,subPropCount do
								if not conflictMap[sPropInd+1] then
									autoUpdateObjs[gName.."."..subProps[sPropInd]] = firstObj
								end
							end
						end
					end
				end

				if p then
					Properties.Refresh()
				end
			end

			-- Fetches the properties to be displayed based on the explorer selection
			Settings.Properties.ShowAttributes = true -- im making it true anyway since its useful by default and people complain
			Properties.ShowExplorerProps = function()
				local maxConflictCheck = Settings.Properties.MaxConflictCheck
				local sList = Explorer.Selection.List
				local foundClasses = {}
				local propCount = 1
				local elevated = Main.Elevated
				local showDeprecated,showHidden = Settings.Properties.ShowDeprecated,Settings.Properties.ShowHidden
				local Classes = API.Classes
				local classLists = {}
				local lower = string.lower
				local RMDCustomOrders = RMD.PropertyOrders
				local getAttributes = game.GetAttributes
				local maxAttrs = Settings.Properties.MaxAttributes
				local showingAttrs = Settings.Properties.ShowAttributes
				local foundAttrs = {}
				local attrCount = 0
				local typeof = typeof
				local typeNameConvert = Properties.TypeNameConvert

				table.clear(props)

				for i = 1,#sList do
					local node = sList[i]
					local obj = node.Obj
					local class = node.Class
					if not class then class = obj.ClassName node.Class = class end

					local apiClass = Classes[class]
					while apiClass do
						local APIClassName = apiClass.Name
						if not foundClasses[APIClassName] then
							local apiProps = indexableProps[APIClassName]
							if not apiProps then apiProps = Properties.GetIndexableProps(obj,apiClass) indexableProps[APIClassName] = apiProps end

							for i = 1,#apiProps do
								local prop = apiProps[i]
								local tags = prop.Tags
								if (not tags.Deprecated or showDeprecated) and (not tags.Hidden or showHidden) then
									props[propCount] = prop
									propCount = propCount + 1
								end
							end
							foundClasses[APIClassName] = true
						end

						local classList = classLists[APIClassName]
						if not classList then classList = {} classLists[APIClassName] = classList end
						classList[#classList+1] = obj

						apiClass = apiClass.Superclass
					end

					if showingAttrs and attrCount < maxAttrs then
						local attrs = getAttributes(obj)
						for name,val in pairs(attrs) do
							local typ = typeof(val)
							if not foundAttrs[name] then
								local category = (typ == "Instance" and "Class") or (typ == "EnumItem" and "Enum") or "Other"
								local valType = {Name = typeNameConvert[typ] or typ, Category = category}
								local attrProp = {IsAttribute = true, Name = "ATTR_"..name, AttributeName = name, DisplayName = name, Class = "Instance", ValueType = valType, Category = "Attributes", Tags = {}}
								props[propCount] = attrProp
								propCount = propCount + 1
								attrCount = attrCount + 1
								foundAttrs[name] = {typ,attrProp}
								if attrCount == maxAttrs then break end
							elseif foundAttrs[name][1] ~= typ then
								foundAttrs[name][2].MultiType = true
								foundAttrs[name][2].Tags.ReadOnly = true
								foundAttrs[name][2].ValueType = {Name = "string"}
							end
						end
					end
				end

				table.sort(props,function(a,b)
					if a.Category ~= b.Category then
						return (categoryOrder[a.Category] or 9999) < (categoryOrder[b.Category] or 9999)
					else
						local aOrder = (RMDCustomOrders[a.Class] and RMDCustomOrders[a.Class][a.Name]) or 9999999
						local bOrder = (RMDCustomOrders[b.Class] and RMDCustomOrders[b.Class][b.Name]) or 9999999
						if aOrder ~= bOrder then
							return aOrder < bOrder
						else
							return lower(a.Name) < lower(b.Name)
						end
					end
				end)

				-- Find conflicts and get auto-update instances
				Properties.ClassLists = classLists
				Properties.ComputeConflicts()
				--warn("CONFLICT",tick()-start)
				if #props > 0 then
					props[#props+1] = Properties.AddAttributeProp
				end

				Properties.Update()
				Properties.Refresh()
			end

			Properties.UpdateView = function()
				local maxEntries = math.ceil(propsFrame.AbsoluteSize.Y / 23)
				local maxX = propsFrame.AbsoluteSize.X
				local totalWidth = Properties.ViewWidth + Properties.MinInputWidth

				scrollV.VisibleSpace = maxEntries
				scrollV.TotalSpace = #viewList + 1
				scrollH.VisibleSpace = maxX
				scrollH.TotalSpace = totalWidth

				scrollV.Gui.Visible = #viewList + 1 > maxEntries
				scrollH.Gui.Visible = Settings.Properties.ScaleType == 0 and totalWidth > maxX

				local oldSize = propsFrame.Size
				propsFrame.Size = UDim2.new(1,(scrollV.Gui.Visible and -16 or 0),1,(scrollH.Gui.Visible and -39 or -23))
				if oldSize ~= propsFrame.Size then
					Properties.UpdateView()
				else
					scrollV:Update()
					scrollH:Update()

					if scrollV.Gui.Visible and scrollH.Gui.Visible then
						scrollV.Gui.Size = UDim2.new(0,16,1,-39)
						scrollH.Gui.Size = UDim2.new(1,-16,0,16)
						Properties.Window.GuiElems.Content.ScrollCorner.Visible = true
					else
						scrollV.Gui.Size = UDim2.new(0,16,1,-23)
						scrollH.Gui.Size = UDim2.new(1,0,0,16)
						Properties.Window.GuiElems.Content.ScrollCorner.Visible = false
					end

					Properties.Index = scrollV.Index
				end
			end

			Properties.MakeSubProp = function(prop,subName,valueType,displayName)
				local subProp = {}
				for i,v in pairs(prop) do
					subProp[i] = v
				end
				subProp.RootType = subProp.RootType or subProp.ValueType
				subProp.ValueType = valueType
				subProp.SubName = subProp.SubName and (subProp.SubName..subName) or subName
				subProp.DisplayName = displayName

				return subProp
			end

			Properties.GetExpandedProps = function(prop) -- TODO: Optimize using table
				local result = {}
				local typeData = prop.ValueType
				local typeName = typeData.Name
				local makeSubProp = Properties.MakeSubProp

				if typeName == "Vector2" then
					result[1] = makeSubProp(prop,".X",{Name = "float"})
					result[2] = makeSubProp(prop,".Y",{Name = "float"})
				elseif typeName == "Vector3" then
					result[1] = makeSubProp(prop,".X",{Name = "float"})
					result[2] = makeSubProp(prop,".Y",{Name = "float"})
					result[3] = makeSubProp(prop,".Z",{Name = "float"})
				elseif typeName == "CFrame" then
					result[1] = makeSubProp(prop,".Position",{Name = "Vector3"})
					result[2] = makeSubProp(prop,".RightVector",{Name = "Vector3"})
					result[3] = makeSubProp(prop,".UpVector",{Name = "Vector3"})
					result[4] = makeSubProp(prop,".LookVector",{Name = "Vector3"})
				elseif typeName == "UDim" then
					result[1] = makeSubProp(prop,".Scale",{Name = "float"})
					result[2] = makeSubProp(prop,".Offset",{Name = "int"})
				elseif typeName == "UDim2" then
					result[1] = makeSubProp(prop,".X",{Name = "UDim"})
					result[2] = makeSubProp(prop,".Y",{Name = "UDim"})
				elseif typeName == "Rect" then
					result[1] = makeSubProp(prop,".Min.X",{Name = "float"},"X0")
					result[2] = makeSubProp(prop,".Min.Y",{Name = "float"},"Y0")
					result[3] = makeSubProp(prop,".Max.X",{Name = "float"},"X1")
					result[4] = makeSubProp(prop,".Max.Y",{Name = "float"},"Y1")
				elseif typeName == "PhysicalProperties" then
					result[1] = makeSubProp(prop,".Density",{Name = "float"})
					result[2] = makeSubProp(prop,".Elasticity",{Name = "float"})
					result[3] = makeSubProp(prop,".ElasticityWeight",{Name = "float"})
					result[4] = makeSubProp(prop,".Friction",{Name = "float"})
					result[5] = makeSubProp(prop,".FrictionWeight",{Name = "float"})
				elseif typeName == "Ray" then
					result[1] = makeSubProp(prop,".Origin",{Name = "Vector3"})
					result[2] = makeSubProp(prop,".Direction",{Name = "Vector3"})
				elseif typeName == "NumberRange" then
					result[1] = makeSubProp(prop,".Min",{Name = "float"})
					result[2] = makeSubProp(prop,".Max",{Name = "float"})
				elseif typeName == "Faces" then
					result[1] = makeSubProp(prop,".Back",{Name = "bool"})
					result[2] = makeSubProp(prop,".Bottom",{Name = "bool"})
					result[3] = makeSubProp(prop,".Front",{Name = "bool"})
					result[4] = makeSubProp(prop,".Left",{Name = "bool"})
					result[5] = makeSubProp(prop,".Right",{Name = "bool"})
					result[6] = makeSubProp(prop,".Top",{Name = "bool"})
				elseif typeName == "Axes" then
					result[1] = makeSubProp(prop,".X",{Name = "bool"})
					result[2] = makeSubProp(prop,".Y",{Name = "bool"})
					result[3] = makeSubProp(prop,".Z",{Name = "bool"})
				end

				if prop.Name == "SoundId" and prop.Class == "Sound" then
					result[1] = Properties.SoundPreviewProp
				end

				return result
			end

			Properties.Update = function()
				table.clear(viewList)

				local nameWidthCache = Properties.NameWidthCache
				local lastCategory
				local count = 1
				local maxWidth,maxDepth = 0,1

				local textServ = service.TextService
				local getTextSize = textServ.GetTextSize
				local font = Enum.Font.SourceSans
				local size = Vector2.new(math.huge,20)
				local stringSplit = string.split
				local entryIndent = Properties.EntryIndent
				local isFirstScaleType = Settings.Properties.ScaleType == 0
				local find,lower = string.find,string.lower
				local searchText = (#Properties.SearchText > 0 and lower(Properties.SearchText))

				local function recur(props,depth)
					for i = 1,#props do
						local prop = props[i]
						local propName = prop.Name
						local subName = prop.SubName
						local category = prop.Category

						local visible
						if searchText and depth == 1 then
							if find(lower(propName),searchText,1,true) then
								visible = true
							end
						else
							visible = true
						end

						if visible and lastCategory ~= category then
							viewList[count] = {CategoryName = category}
							count = count + 1
							lastCategory = category
						end

						if (expanded["CAT_"..category] and visible) or prop.SpecialRow then
							if depth > 1 then prop.Depth = depth if depth > maxDepth then maxDepth = depth end end

							if isFirstScaleType then
								local nameArr = subName and stringSplit(subName,".")
								local displayName = prop.DisplayName or (nameArr and nameArr[#nameArr]) or propName

								local nameWidth = nameWidthCache[displayName]
								if not nameWidth then nameWidth = getTextSize(textServ,displayName,14,font,size).X nameWidthCache[displayName] = nameWidth end

								local totalWidth = nameWidth + entryIndent*depth
								if totalWidth > maxWidth then
									maxWidth = totalWidth
								end
							end

							viewList[count] = prop
							count = count + 1

							local fullName = prop.Class.."."..prop.Name..(prop.SubName or "")
							if expanded[fullName] then
								local nextDepth = depth+1
								local expandedProps = Properties.GetExpandedProps(prop)
								if #expandedProps > 0 then
									recur(expandedProps,nextDepth)
								end
							end
						end
					end
				end
				recur(props,1)

				inputProp = nil
				Properties.ViewWidth = maxWidth + 9 + Properties.EntryOffset
				Properties.UpdateView()
			end

			Properties.NewPropEntry = function(index)
				local newEntry = Properties.EntryTemplate:Clone()
				local nameFrame = newEntry.NameFrame
				local valueFrame = newEntry.ValueFrame
				local newCheckbox = Lib.Checkbox.new(1)
				newCheckbox.Gui.Position = UDim2.new(0,3,0,3)
				newCheckbox.Gui.Parent = valueFrame
				newCheckbox.OnInput:Connect(function()
					local prop = viewList[index + Properties.Index]
					if not prop then return end

					if prop.ValueType.Name == "PhysicalProperties" then
						Properties.SetProp(prop,newCheckbox.Toggled and true or nil)
					else
						Properties.SetProp(prop,newCheckbox.Toggled)
					end
				end)
				checkboxes[index] = newCheckbox

				local iconFrame = Main.MiscIcons:GetLabel()
				iconFrame.Position = UDim2.new(0,2,0,3)
				iconFrame.Parent = newEntry.ValueFrame.RightButton

				newEntry.Position = UDim2.new(0,0,0,23*(index-1))

				nameFrame.Expand.InputBegan:Connect(function(input)
					local prop = viewList[index + Properties.Index]
					if not prop or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

					local fullName = (prop.CategoryName and "CAT_"..prop.CategoryName) or prop.Class.."."..prop.Name..(prop.SubName or "")

					Main.MiscIcons:DisplayByKey(newEntry.NameFrame.Expand.Icon, expanded[fullName] and "Collapse_Over" or "Expand_Over")
				end)

				nameFrame.Expand.InputEnded:Connect(function(input)
					local prop = viewList[index + Properties.Index]
					if not prop or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end

					local fullName = (prop.CategoryName and "CAT_"..prop.CategoryName) or prop.Class.."."..prop.Name..(prop.SubName or "")

					Main.MiscIcons:DisplayByKey(newEntry.NameFrame.Expand.Icon, expanded[fullName] and "Collapse" or "Expand")
				end)

				nameFrame.Expand.MouseButton1Down:Connect(function()
					local prop = viewList[index + Properties.Index]
					if not prop then return end

					local fullName = (prop.CategoryName and "CAT_"..prop.CategoryName) or prop.Class.."."..prop.Name..(prop.SubName or "")
					if not prop.CategoryName and not Properties.ExpandableTypes[prop.ValueType and prop.ValueType.Name] and not Properties.ExpandableProps[fullName] then return end

					expanded[fullName] = not expanded[fullName]
					Properties.Update()
					Properties.Refresh()
				end)

				nameFrame.PropName.InputBegan:Connect(function(input)
					local prop = viewList[index + Properties.Index]
					if not prop then return end
					if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and not nameFrame.PropName.TextFits then
						local fullNameFrame = Properties.FullNameFrame	
						local nameArr = string.split(prop.Class.."."..prop.Name..(prop.SubName or ""), ".")
						local dispName = prop.DisplayName or nameArr[#nameArr]
						local sizeX = service.TextService:GetTextSize(dispName, 14, Enum.Font.SourceSans, Vector2.new(math.huge, 20)).X

						fullNameFrame.TextLabel.Text = dispName
						fullNameFrame.Size = UDim2.new(0, sizeX + 4, 0, 22)
						fullNameFrame.Visible = true
						Properties.FullNameFrameIndex = index
						Properties.FullNameFrameAttach.SetData(fullNameFrame, {Target = nameFrame})
						Properties.FullNameFrameAttach.Enable()
					end
				end)

				nameFrame.PropName.InputEnded:Connect(function(input)
					if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and Properties.FullNameFrameIndex == index then
						Properties.FullNameFrame.Visible = false
						Properties.FullNameFrameAttach.Disable()
					end
				end)


				valueFrame.ValueBox.MouseButton1Down:Connect(function()
					local prop = viewList[index + Properties.Index]
					if not prop then return end

					Properties.SetInputProp(prop,index)
				end)

				valueFrame.ColorButton.MouseButton1Down:Connect(function()
					local prop = viewList[index + Properties.Index]
					if not prop then return end

					Properties.SetInputProp(prop,index,"color")
				end)

				valueFrame.RightButton.MouseButton1Click:Connect(function()
					local prop = viewList[index + Properties.Index]
					if not prop then return end

					local fullName = prop.Class.."."..prop.Name..(prop.SubName or "")
					local inputFullName = inputProp and (inputProp.Class.."."..inputProp.Name..(inputProp.SubName or ""))

					if fullName == inputFullName and inputProp.ValueType.Category == "Class" then
						inputProp = nil
						Properties.SetProp(prop,nil)
					else
						Properties.SetInputProp(prop,index,"right")
					end
				end)

				nameFrame.ToggleAttributes.MouseButton1Click:Connect(function()
					Settings.Properties.ShowAttributes = not Settings.Properties.ShowAttributes
					Properties.ShowExplorerProps()
				end)

				newEntry.RowButton.MouseButton1Click:Connect(function()
					Properties.DisplayAddAttributeWindow()
				end)

				newEntry.EditAttributeButton.MouseButton1Down:Connect(function()
					local prop = viewList[index + Properties.Index]
					if not prop then return end

					Properties.DisplayAttributeContext(prop)
				end)

				valueFrame.SoundPreview.ControlButton.MouseButton1Click:Connect(function()
					if Properties.PreviewSound and Properties.PreviewSound.Playing then
						Properties.SetSoundPreview(false)
					else
						local soundObj = Properties.FindFirstObjWhichIsA("Sound")
						if soundObj then Properties.SetSoundPreview(soundObj) end
					end
				end)

				valueFrame.SoundPreview.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

					local releaseEvent, inputEvent
					releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							releaseEvent:Disconnect()
							if inputEvent then
								inputEvent:Disconnect()
							end
						end
					end)

					local timeLine = newEntry.ValueFrame.SoundPreview.TimeLine
					local soundObj = Properties.FindFirstObjWhichIsA("Sound")
					if soundObj then Properties.SetSoundPreview(soundObj, true) end

					local function update(input)
						local sound = Properties.PreviewSound
						if not sound or sound.TimeLength == 0 then return end

						local inputX = (input.UserInputType == Enum.UserInputType.Touch) and input.Position.X or input.Position.X
						local timeLineSize = timeLine.AbsoluteSize
						local relaX = inputX - timeLine.AbsolutePosition.X

						if timeLineSize.X <= 1 then return end
						if relaX < 0 then relaX = 0 elseif relaX >= timeLineSize.X then relaX = timeLineSize.X - 1 end

						local perc = (relaX / (timeLineSize.X - 1))
						sound.TimePosition = perc * sound.TimeLength
						timeLine.Slider.Position = UDim2.new(perc, -4, 0, -8)
					end

					update(input)

					inputEvent = service.UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							update(input)
						end
					end)
				end)


				newEntry.Parent = propsFrame

				return {
					Gui = newEntry,
					GuiElems = {
						NameFrame = nameFrame,
						ValueFrame = valueFrame,
						PropName = nameFrame.PropName,
						ValueBox = valueFrame.ValueBox,
						Expand = nameFrame.Expand,
						ColorButton = valueFrame.ColorButton,
						ColorPreview = valueFrame.ColorButton.ColorPreview,
						Gradient = valueFrame.ColorButton.ColorPreview.UIGradient,
						EnumArrow = valueFrame.EnumArrow,
						Checkbox = valueFrame.Checkbox,
						RightButton = valueFrame.RightButton,
						RightButtonIcon = iconFrame,
						RowButton = newEntry.RowButton,
						EditAttributeButton = newEntry.EditAttributeButton,
						ToggleAttributes = nameFrame.ToggleAttributes,
						SoundPreview = valueFrame.SoundPreview,
						SoundPreviewSlider = valueFrame.SoundPreview.TimeLine.Slider
					}
				}
			end

			Properties.GetSoundPreviewEntry = function()
				for i = 1,#viewList do
					if viewList[i] == Properties.SoundPreviewProp then
						return propEntries[i - Properties.Index]
					end
				end
			end

			Properties.SetSoundPreview = function(soundObj,noplay)
				local sound = Properties.PreviewSound
				if not sound then
					sound = Instance.new("Sound")
					sound.Name = "Preview"
					sound.Paused:Connect(function()
						local entry = Properties.GetSoundPreviewEntry()
						if entry then Main.MiscIcons:DisplayByKey(entry.GuiElems.SoundPreview.ControlButton.Icon, "Play") end
					end)
					sound.Resumed:Connect(function() Properties.Refresh() end)
					sound.Ended:Connect(function()
						local entry = Properties.GetSoundPreviewEntry()
						if entry then entry.GuiElems.SoundPreviewSlider.Position = UDim2.new(0,-4,0,-8) end
						Properties.Refresh()
					end)
					sound.Parent = window.Gui
					Properties.PreviewSound = sound
				end

				if not soundObj then
					sound:Pause()
				else
					local newId = sound.SoundId ~= soundObj.SoundId
					sound.SoundId = soundObj.SoundId
					sound.PlaybackSpeed = soundObj.PlaybackSpeed
					sound.Volume = soundObj.Volume
					if newId then sound.TimePosition = 0 end
					if not noplay then sound:Resume() end

					coroutine.wrap(function()
						local previewTime = tick()
						Properties.SoundPreviewTime = previewTime
						while previewTime == Properties.SoundPreviewTime and sound.Playing do
							local entry = Properties.GetSoundPreviewEntry()
							if entry then
								local tl = sound.TimeLength
								local perc = sound.TimePosition/(tl == 0 and 1 or tl)
								entry.GuiElems.SoundPreviewSlider.Position = UDim2.new(perc,-4,0,-8)
							end
							Lib.FastWait()
						end
					end)()
					Properties.Refresh()
				end
			end

			Properties.DisplayAttributeContext = function(prop)
				local context = Properties.AttributeContext
				if not context then
					context = Lib.ContextMenu.new()
					context.Iconless = true
					context.Width = 80
				end
				context:Clear()

				context:Add({Name = "Edit", OnClick = function()
					Properties.DisplayAddAttributeWindow(prop)
				end})
				context:Add({Name = "Delete", OnClick = function()
					Properties.SetProp(prop,nil,true)
					Properties.ShowExplorerProps()
				end})

				context:Show()
			end

			Properties.DisplayAddAttributeWindow = function(editAttr)
				local win = Properties.AddAttributeWindow
				if not win then
					win = Lib.Window.new()
					win.Alignable = false
					win.Resizable = false
					win:SetTitle("Add Attribute")
					win:SetSize(200,130)

					local saveButton = Lib.Button.new()
					local nameLabel = Lib.Label.new()
					nameLabel.Text = "Name"
					nameLabel.Position = UDim2.new(0,30,0,10)
					nameLabel.Size = UDim2.new(0,40,0,20)
					win:Add(nameLabel)

					local nameBox = Lib.ViewportTextBox.new()
					nameBox.Position = UDim2.new(0,75,0,10)
					nameBox.Size = UDim2.new(0,120,0,20)
					win:Add(nameBox,"NameBox")
					nameBox.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
						saveButton:SetDisabled(#nameBox:GetText() == 0)
					end)

					local typeLabel = Lib.Label.new()
					typeLabel.Text = "Type"
					typeLabel.Position = UDim2.new(0,30,0,40)
					typeLabel.Size = UDim2.new(0,40,0,20)
					win:Add(typeLabel)

					local typeChooser = Lib.DropDown.new()
					typeChooser.CanBeEmpty = false
					typeChooser.Position = UDim2.new(0,75,0,40)
					typeChooser.Size = UDim2.new(0,120,0,20)
					typeChooser:SetOptions(Properties.AllowedAttributeTypes)
					win:Add(typeChooser,"TypeChooser")

					local errorLabel = Lib.Label.new()
					errorLabel.Text = ""
					errorLabel.Position = UDim2.new(0,5,1,-45)
					errorLabel.Size = UDim2.new(1,-10,0,20)
					errorLabel.TextColor3 = Settings.Theme.Important
					win.ErrorLabel = errorLabel
					win:Add(errorLabel,"Error")

					local cancelButton = Lib.Button.new()
					cancelButton.Text = "Cancel"
					cancelButton.Position = UDim2.new(1,-97,1,-25)
					cancelButton.Size = UDim2.new(0,92,0,20)
					cancelButton.OnClick:Connect(function()
						win:Close()
					end)
					win:Add(cancelButton)

					saveButton.Text = "Save"
					saveButton.Position = UDim2.new(0,5,1,-25)
					saveButton.Size = UDim2.new(0,92,0,20)
					saveButton.OnClick:Connect(function()
						local name = nameBox:GetText()
						if #name > 100 then
							errorLabel.Text = "Error: Name over 100 chars"
							return
						elseif name:sub(1,3) == "RBX" then
							errorLabel.Text = "Error: Name begins with 'RBX'"
							return
						end

						local typ = typeChooser.Selected
						local valType = {Name = Properties.TypeNameConvert[typ] or typ, Category = "DataType"}
						local attrProp = {IsAttribute = true, Name = "ATTR_"..name, AttributeName = name, DisplayName = name, Class = "Instance", ValueType = valType, Category = "Attributes", Tags = {}}

						Settings.Properties.ShowAttributes = true
						Properties.SetProp(attrProp,Properties.DefaultPropValue[valType.Name],true,Properties.EditingAttribute)
						Properties.ShowExplorerProps()
						win:Close()
					end)
					win:Add(saveButton,"SaveButton")

					Properties.AddAttributeWindow = win
				end

				Properties.EditingAttribute = editAttr
				win:SetTitle(editAttr and "Edit Attribute "..editAttr.AttributeName or "Add Attribute")
				win.Elements.Error.Text = ""
				win.Elements.NameBox:SetText("")
				win.Elements.SaveButton:SetDisabled(true)
				win.Elements.TypeChooser:SetSelected(1)
				win:Show()
			end

			Properties.IsTextEditable = function(prop)
				local typeData = prop.ValueType
				local typeName = typeData.Name

				return typeName ~= "bool" and typeData.Category ~= "Enum" and typeData.Category ~= "Class" and typeName ~= "BrickColor"
			end

			Properties.DisplayEnumDropdown = function(entryIndex)
				local context = Properties.EnumContext
				if not context then
					context = Lib.ContextMenu.new()
					context.Iconless = true
					context.MaxHeight = 200
					context.ReverseYOffset = 22
					Properties.EnumDropdown = context
				end

				if not inputProp or inputProp.ValueType.Category ~= "Enum" then return end
				local prop = inputProp

				local entry = propEntries[entryIndex]
				local valueFrame = entry.GuiElems.ValueFrame

				local enum = Enum[prop.ValueType.Name]
				if not enum then return end

				local sorted = {}
				for name,enum in next,enum:GetEnumItems() do
					sorted[#sorted+1] = enum
				end
				table.sort(sorted,function(a,b) return a.Name < b.Name end)

				context:Clear()

				local function onClick(name)
					if prop ~= inputProp then return end

					local enumItem = enum[name]
					inputProp = nil
					Properties.SetProp(prop,enumItem)
				end

				for i = 1,#sorted do
					local enumItem = sorted[i]
					context:Add({Name = enumItem.Name, OnClick = onClick})
				end

				context.Width = valueFrame.AbsoluteSize.X
				context:Show(valueFrame.AbsolutePosition.X, valueFrame.AbsolutePosition.Y + 22)
			end

			Properties.DisplayBrickColorEditor = function(prop,entryIndex,col)
				local editor = Properties.BrickColorEditor
				if not editor then
					editor = Lib.BrickColorPicker.new()
					editor.Gui.DisplayOrder = Main.DisplayOrders.Menu
					editor.ReverseYOffset = 22

					editor.OnSelect:Connect(function(col)
						if not editor.CurrentProp or editor.CurrentProp.ValueType.Name ~= "BrickColor" then return end

						if editor.CurrentProp == inputProp then inputProp = nil end
						Properties.SetProp(editor.CurrentProp,BrickColor.new(col))
					end)

					editor.OnMoreColors:Connect(function() -- TODO: Special Case BasePart.BrickColor to BasePart.Color
						editor:Close()
						local colProp
						for i,v in pairs(API.Classes.BasePart.Properties) do
							if v.Name == "Color" then
								colProp = v
								break
							end
						end
						Properties.DisplayColorEditor(colProp,editor.SavedColor.Color)
					end)

					Properties.BrickColorEditor = editor
				end

				local entry = propEntries[entryIndex]
				local valueFrame = entry.GuiElems.ValueFrame

				editor.CurrentProp = prop
				editor.SavedColor = col
				if prop and prop.Class == "BasePart" and prop.Name == "BrickColor" then
					editor:SetMoreColorsVisible(true)
				else
					editor:SetMoreColorsVisible(false)
				end
				editor:Show(valueFrame.AbsolutePosition.X, valueFrame.AbsolutePosition.Y + 22)
			end

			Properties.DisplayColorEditor = function(prop,col)
				local editor = Properties.ColorEditor
				if not editor then
					editor = Lib.ColorPicker.new()

					editor.OnSelect:Connect(function(col)
						if not editor.CurrentProp then return end
						local typeName = editor.CurrentProp.ValueType.Name
						if typeName ~= "Color3" and typeName ~= "BrickColor" then return end

						local colVal = (typeName == "Color3" and col or BrickColor.new(col))

						if editor.CurrentProp == inputProp then inputProp = nil end
						Properties.SetProp(editor.CurrentProp,colVal)
					end)

					Properties.ColorEditor = editor
				end

				editor.CurrentProp = prop
				if col then
					editor:SetColor(col)
				else
					local firstVal = Properties.GetFirstPropVal(prop)
					if firstVal then editor:SetColor(firstVal) end
				end
				editor:Show()
			end

			Properties.DisplayNumberSequenceEditor = function(prop,seq)
				local editor = Properties.NumberSequenceEditor
				if not editor then
					editor = Lib.NumberSequenceEditor.new()

					editor.OnSelect:Connect(function(val)
						if not editor.CurrentProp or editor.CurrentProp.ValueType.Name ~= "NumberSequence" then return end

						if editor.CurrentProp == inputProp then inputProp = nil end
						Properties.SetProp(editor.CurrentProp,val)
					end)

					Properties.NumberSequenceEditor = editor
				end

				editor.CurrentProp = prop
				if seq then
					editor:SetSequence(seq)
				else
					local firstVal = Properties.GetFirstPropVal(prop)
					if firstVal then editor:SetSequence(firstVal) end
				end
				editor:Show()
			end

			Properties.DisplayColorSequenceEditor = function(prop,seq)
				local editor = Properties.ColorSequenceEditor
				if not editor then
					editor = Lib.ColorSequenceEditor.new()

					editor.OnSelect:Connect(function(val)
						if not editor.CurrentProp or editor.CurrentProp.ValueType.Name ~= "ColorSequence" then return end

						if editor.CurrentProp == inputProp then inputProp = nil end
						Properties.SetProp(editor.CurrentProp,val)
					end)

					Properties.ColorSequenceEditor = editor
				end

				editor.CurrentProp = prop
				if seq then
					editor:SetSequence(seq)
				else
					local firstVal = Properties.GetFirstPropVal(prop)
					if firstVal then editor:SetSequence(firstVal) end
				end
				editor:Show()
			end

			Properties.GetFirstPropVal = function(prop)
				local first = Properties.FindFirstObjWhichIsA(prop.Class)
				if first then
					return Properties.GetPropVal(prop,first)
				end
			end

			Properties.GetPropVal = function(prop,obj)
				if prop.MultiType then return "<Multiple Types>" end
				if not obj then return end

				local propVal
				if prop.IsAttribute then
					propVal = getAttribute(obj,prop.AttributeName)
					if propVal == nil then return nil end

					local typ = typeof(propVal)
					local currentType = Properties.TypeNameConvert[typ] or typ
					if prop.RootType then
						if prop.RootType.Name ~= currentType then
							return nil
						end
					elseif prop.ValueType.Name ~= currentType then
						return nil
					end
				else
					propVal = obj[prop.Name]
				end
				if prop.SubName then
					local indexes = string.split(prop.SubName,".")
					for i = 1,#indexes do
						local indexName = indexes[i]
						if #indexName > 0 and propVal then
							propVal = propVal[indexName]
						end
					end
				end

				return propVal
			end

			Properties.SelectObject = function(obj)
				if inputProp and inputProp.ValueType.Category == "Class" then
					local prop = inputProp
					inputProp = nil

					if isa(obj,prop.ValueType.Name) then
						Properties.SetProp(prop,obj)
					else
						Properties.Refresh()
					end

					return true
				end

				return false
			end

			Properties.DisplayProp = function(prop,entryIndex)
				local propName = prop.Name
				local typeData = prop.ValueType
				local typeName = typeData.Name
				local tags = prop.Tags
				local gName = prop.Class.."."..prop.Name..(prop.SubName or "")
				local propObj = autoUpdateObjs[gName]
				local entryData = propEntries[entryIndex]
				local UDim2 = UDim2

				local guiElems = entryData.GuiElems
				local valueFrame = guiElems.ValueFrame
				local valueBox = guiElems.ValueBox
				local colorButton = guiElems.ColorButton
				local colorPreview = guiElems.ColorPreview
				local gradient = guiElems.Gradient
				local enumArrow = guiElems.EnumArrow
				local checkbox = guiElems.Checkbox
				local rightButton = guiElems.RightButton
				local soundPreview = guiElems.SoundPreview

				local propVal = Properties.GetPropVal(prop,propObj)
				local inputFullName = inputProp and (inputProp.Class.."."..inputProp.Name..(inputProp.SubName or ""))

				local offset = 4
				local endOffset = 6

				-- Offsetting the ValueBox for ValueType specific buttons
				if (typeName == "Color3" or typeName == "BrickColor" or typeName == "ColorSequence") then
					colorButton.Visible = true
					enumArrow.Visible = false
					if propVal then
						gradient.Color = (typeName == "Color3" and ColorSequence.new(propVal)) or (typeName == "BrickColor" and ColorSequence.new(propVal.Color)) or propVal
					else
						gradient.Color = ColorSequence.new(Color3.new(1,1,1))
					end
					colorPreview.BorderColor3 = (typeName == "ColorSequence" and Color3.new(1,1,1) or Color3.new(0,0,0))
					offset = 22
					endOffset = 24 + (typeName == "ColorSequence" and 20 or 0)
				elseif typeData.Category == "Enum" then
					colorButton.Visible = false
					enumArrow.Visible = not prop.Tags.ReadOnly
					endOffset = 22
				elseif (gName == inputFullName and typeData.Category == "Class") or typeName == "NumberSequence" then
					colorButton.Visible = false
					enumArrow.Visible = false
					endOffset = 26
				else
					colorButton.Visible = false
					enumArrow.Visible = false
				end

				valueBox.Position = UDim2.new(0,offset,0,0)
				valueBox.Size = UDim2.new(1,-endOffset,1,0)

				-- Right button
				if inputFullName == gName and typeData.Category == "Class" then
					Main.MiscIcons:DisplayByKey(guiElems.RightButtonIcon, "Delete")
					guiElems.RightButtonIcon.Visible = true
					rightButton.Text = ""
					rightButton.Visible = true
				elseif typeName == "NumberSequence" or typeName == "ColorSequence" then
					guiElems.RightButtonIcon.Visible = false
					rightButton.Text = "..."
					rightButton.Visible = true
				else
					rightButton.Visible = false
				end

				-- Displays the correct ValueBox for the ValueType, and sets it to the prop value
				if typeName == "bool" or typeName == "PhysicalProperties" then
					valueBox.Visible = false
					checkbox.Visible = true
					soundPreview.Visible = false
					checkboxes[entryIndex].Disabled = tags.ReadOnly
					if typeName == "PhysicalProperties" and autoUpdateObjs[gName] then
						checkboxes[entryIndex]:SetState(propVal and true or false)
					else
						checkboxes[entryIndex]:SetState(propVal)
					end
				elseif typeName == "SoundPlayer" then
					valueBox.Visible = false
					checkbox.Visible = false
					soundPreview.Visible = true
					local playing = Properties.PreviewSound and Properties.PreviewSound.Playing
					Main.MiscIcons:DisplayByKey(soundPreview.ControlButton.Icon, playing and "Pause" or "Play")
				else
					valueBox.Visible = true
					checkbox.Visible = false
					soundPreview.Visible = false

					if propVal ~= nil then
						if typeName == "Color3" then
							valueBox.Text = "["..Lib.ColorToBytes(propVal).."]"
						elseif typeData.Category == "Enum" then
							valueBox.Text = propVal.Name
						elseif Properties.RoundableTypes[typeName] and Settings.Properties.NumberRounding then
							local rawStr = Properties.ValueToString(prop,propVal)
							valueBox.Text = rawStr:gsub("-?%d+%.%d+",function(num)
								return tostring(tonumber(("%."..Settings.Properties.NumberRounding.."f"):format(num)))
							end)
						else
							valueBox.Text = Properties.ValueToString(prop,propVal)
						end
					else
						valueBox.Text = ""
					end

					valueBox.TextColor3 = tags.ReadOnly and Settings.Theme.PlaceholderText or Settings.Theme.Text
				end
			end

			Properties.Refresh = function()
				local maxEntries = math.max(math.ceil((propsFrame.AbsoluteSize.Y) / 23),0)	
				local maxX = propsFrame.AbsoluteSize.X
				local valueWidth = math.max(Properties.MinInputWidth,maxX-Properties.ViewWidth)
				local inputPropVisible = false
				local isa = game.IsA
				local UDim2 = UDim2
				local stringSplit = string.split
				local scaleType = Settings.Properties.ScaleType

				-- Clear connections
				for i = 1,#propCons do
					propCons[i]:Disconnect()
				end
				table.clear(propCons)

				-- Hide full name viewer
				Properties.FullNameFrame.Visible = false
				Properties.FullNameFrameAttach.Disable()

				for i = 1,maxEntries do
					local entryData = propEntries[i]
					if not propEntries[i] then entryData = Properties.NewPropEntry(i) propEntries[i] = entryData end

					local entry = entryData.Gui
					local guiElems = entryData.GuiElems
					local nameFrame = guiElems.NameFrame
					local propNameLabel = guiElems.PropName
					local valueFrame = guiElems.ValueFrame
					local expand = guiElems.Expand
					local valueBox = guiElems.ValueBox
					local propNameBox = guiElems.PropName
					local rightButton = guiElems.RightButton
					local editAttributeButton = guiElems.EditAttributeButton
					local toggleAttributes = guiElems.ToggleAttributes

					local prop = viewList[i + Properties.Index]
					if prop then
						local entryXOffset = (scaleType == 0 and scrollH.Index or 0)
						entry.Visible = true
						entry.Position = UDim2.new(0,-entryXOffset,0,entry.Position.Y.Offset)
						entry.Size = UDim2.new(scaleType == 0 and 0 or 1, scaleType == 0 and Properties.ViewWidth + valueWidth or 0,0,22)

						if prop.SpecialRow then
							if prop.SpecialRow == "AddAttribute" then
								nameFrame.Visible = false
								valueFrame.Visible = false
								guiElems.RowButton.Visible = true
							end
						else
							-- Revert special row stuff
							nameFrame.Visible = true
							guiElems.RowButton.Visible = false

							local depth = Properties.EntryIndent*(prop.Depth or 1)
							local leftOffset = depth + Properties.EntryOffset
							nameFrame.Position = UDim2.new(0,leftOffset,0,0)
							propNameLabel.Size = UDim2.new(1,-2 - (scaleType == 0 and 0 or 6),1,0)

							local gName = (prop.CategoryName and "CAT_"..prop.CategoryName) or prop.Class.."."..prop.Name..(prop.SubName or "")

							if prop.CategoryName then
								entry.BackgroundColor3 = Settings.Theme.Main1
								valueFrame.Visible = false

								propNameBox.Text = prop.CategoryName
								propNameBox.Font = Enum.Font.SourceSansBold
								expand.Visible = true
								propNameBox.TextColor3 = Settings.Theme.Text
								nameFrame.BackgroundTransparency = 1
								nameFrame.Size = UDim2.new(1,0,1,0)
								editAttributeButton.Visible = false

								local showingAttrs = Settings.Properties.ShowAttributes
								toggleAttributes.Position = UDim2.new(1,-85-leftOffset,0,0)
								toggleAttributes.Text = (showingAttrs and "[Setting: ON]" or "[Setting: OFF]")
								toggleAttributes.TextColor3 = Settings.Theme.Text
								toggleAttributes.Visible = (prop.CategoryName == "Attributes")
							else
								local propName = prop.Name
								local typeData = prop.ValueType
								local typeName = typeData.Name
								local tags = prop.Tags
								local propObj = autoUpdateObjs[gName]

								local attributeOffset = (prop.IsAttribute and 20 or 0)
								editAttributeButton.Visible = (prop.IsAttribute and not prop.RootType)
								toggleAttributes.Visible = false

								-- Moving around the frames
								if scaleType == 0 then
									nameFrame.Size = UDim2.new(0,Properties.ViewWidth - leftOffset - 1,1,0)
									valueFrame.Position = UDim2.new(0,Properties.ViewWidth,0,0)
									valueFrame.Size = UDim2.new(0,valueWidth - attributeOffset,1,0)
								else
									nameFrame.Size = UDim2.new(0.5,-leftOffset - 1,1,0)
									valueFrame.Position = UDim2.new(0.5,0,0,0)
									valueFrame.Size = UDim2.new(0.5,-attributeOffset,1,0)
								end

								local nameArr = stringSplit(gName,".")
								propNameBox.Text = prop.DisplayName or nameArr[#nameArr]
								propNameBox.Font = Enum.Font.SourceSans
								entry.BackgroundColor3 = Settings.Theme.Main2
								valueFrame.Visible = true

								expand.Visible = typeData.Category == "DataType" and Properties.ExpandableTypes[typeName] or Properties.ExpandableProps[gName]
								propNameBox.TextColor3 = tags.ReadOnly and Settings.Theme.PlaceholderText or Settings.Theme.Text

								-- Display property value
								Properties.DisplayProp(prop,i)
								if propObj then
									if prop.IsAttribute then
										propCons[#propCons+1] = getAttributeChangedSignal(propObj,prop.AttributeName):Connect(function()
											Properties.DisplayProp(prop,i)
										end)
									else
										propCons[#propCons+1] = getPropChangedSignal(propObj,propName):Connect(function()
											Properties.DisplayProp(prop,i)
										end)
									end
								end

								-- Position and resize Input Box
								local beforeVisible = valueBox.Visible
								local inputFullName = inputProp and (inputProp.Class.."."..inputProp.Name..(inputProp.SubName or ""))
								if gName == inputFullName then
									nameFrame.BackgroundColor3 = Settings.Theme.ListSelection
									nameFrame.BackgroundTransparency = 0
									if typeData.Category == "Class" or typeData.Category == "Enum" or typeName == "BrickColor" then
										valueFrame.BackgroundColor3 = Settings.Theme.TextBox
										valueFrame.BackgroundTransparency = 0
										valueBox.Visible = true
									else
										inputPropVisible = true
										local scale = (scaleType == 0 and 0 or 0.5)
										local offset = (scaleType == 0 and Properties.ViewWidth-scrollH.Index or 0)
										local endOffset = 0

										if typeName == "Color3" or typeName == "ColorSequence" then
											offset = offset + 22
										end

										if typeName == "NumberSequence" or typeName == "ColorSequence" then
											endOffset = 20
										end

										inputBox.Position = UDim2.new(scale,offset,0,entry.Position.Y.Offset)
										inputBox.Size = UDim2.new(1-scale,-offset-endOffset-attributeOffset,0,22)
										inputBox.Visible = true
										valueBox.Visible = false
									end
								else
									nameFrame.BackgroundColor3 = Settings.Theme.Main1
									nameFrame.BackgroundTransparency = 1
									valueFrame.BackgroundColor3 = Settings.Theme.Main1
									valueFrame.BackgroundTransparency = 1
									valueBox.Visible = beforeVisible
								end
							end

							-- Expand
							if prop.CategoryName or Properties.ExpandableTypes[prop.ValueType and prop.ValueType.Name] or Properties.ExpandableProps[gName] then
								if Lib.CheckMouseInGui(expand) then
									Main.MiscIcons:DisplayByKey(expand.Icon, expanded[gName] and "Collapse_Over" or "Expand_Over")
								else
									Main.MiscIcons:DisplayByKey(expand.Icon, expanded[gName] and "Collapse" or "Expand")
								end
								expand.Visible = true
							else
								expand.Visible = false
							end
						end
						entry.Visible = true
					else
						entry.Visible = false
					end
				end

				if not inputPropVisible then
					inputBox.Visible = false
				end

				for i = maxEntries+1,#propEntries do
					propEntries[i].Gui:Destroy()
					propEntries[i] = nil
					checkboxes[i] = nil
				end
			end

			Properties.SetProp = function(prop,val,noupdate,prevAttribute)
				local sList = Explorer.Selection.List
				local propName = prop.Name
				local subName = prop.SubName
				local propClass = prop.Class
				local typeData = prop.ValueType
				local typeName = typeData.Name
				local attributeName = prop.AttributeName
				local rootTypeData = prop.RootType
				local rootTypeName = rootTypeData and rootTypeData.Name
				local fullName = prop.Class.."."..prop.Name..(prop.SubName or "")
				local Vector3 = Vector3

				for i = 1,#sList do
					local node = sList[i]
					local obj = node.Obj

					if isa(obj,propClass) then
						pcall(function()
							local setVal = val
							local root
							if prop.IsAttribute then
								root = getAttribute(obj,attributeName)
							else
								root = obj[propName]
							end

							if prevAttribute then
								if prevAttribute.ValueType.Name == typeName then
									setVal = getAttribute(obj,prevAttribute.AttributeName) or setVal
								end
								setAttribute(obj,prevAttribute.AttributeName,nil)
							end

							if rootTypeName then
								if rootTypeName == "Vector2" then
									setVal = Vector2.new((subName == ".X" and setVal) or root.X, (subName == ".Y" and setVal) or root.Y)
								elseif rootTypeName == "Vector3" then
									setVal = Vector3.new((subName == ".X" and setVal) or root.X, (subName == ".Y" and setVal) or root.Y, (subName == ".Z" and setVal) or root.Z)
								elseif rootTypeName == "UDim" then
									setVal = UDim.new((subName == ".Scale" and setVal) or root.Scale, (subName == ".Offset" and setVal) or root.Offset)
								elseif rootTypeName == "UDim2" then
									local rootX,rootY = root.X,root.Y
									local X_UDim = (subName == ".X" and setVal) or UDim.new((subName == ".X.Scale" and setVal) or rootX.Scale, (subName == ".X.Offset" and setVal) or rootX.Offset)
									local Y_UDim = (subName == ".Y" and setVal) or UDim.new((subName == ".Y.Scale" and setVal) or rootY.Scale, (subName == ".Y.Offset" and setVal) or rootY.Offset)
									setVal = UDim2.new(X_UDim,Y_UDim)
								elseif rootTypeName == "CFrame" then
									local rootPos,rootRight,rootUp,rootLook = root.Position,root.RightVector,root.UpVector,root.LookVector
									local pos = (subName == ".Position" and setVal) or Vector3.new((subName == ".Position.X" and setVal) or rootPos.X, (subName == ".Position.Y" and setVal) or rootPos.Y, (subName == ".Position.Z" and setVal) or rootPos.Z)
									local rightV = (subName == ".RightVector" and setVal) or Vector3.new((subName == ".RightVector.X" and setVal) or rootRight.X, (subName == ".RightVector.Y" and setVal) or rootRight.Y, (subName == ".RightVector.Z" and setVal) or rootRight.Z)
									local upV = (subName == ".UpVector" and setVal) or Vector3.new((subName == ".UpVector.X" and setVal) or rootUp.X, (subName == ".UpVector.Y" and setVal) or rootUp.Y, (subName == ".UpVector.Z" and setVal) or rootUp.Z)
									local lookV = (subName == ".LookVector" and setVal) or Vector3.new((subName == ".LookVector.X" and setVal) or rootLook.X, (subName == ".RightVector.Y" and setVal) or rootLook.Y, (subName == ".RightVector.Z" and setVal) or rootLook.Z)
									setVal = CFrame.fromMatrix(pos,rightV,upV,-lookV)
								elseif rootTypeName == "Rect" then
									local rootMin,rootMax = root.Min,root.Max
									local min = Vector2.new((subName == ".Min.X" and setVal) or rootMin.X, (subName == ".Min.Y" and setVal) or rootMin.Y)
									local max = Vector2.new((subName == ".Max.X" and setVal) or rootMax.X, (subName == ".Max.Y" and setVal) or rootMax.Y)
									setVal = Rect.new(min,max)
								elseif rootTypeName == "PhysicalProperties" then
									local rootProps = PhysicalProperties.new(obj.Material)
									local density = (subName == ".Density" and setVal) or (root and root.Density) or rootProps.Density
									local friction = (subName == ".Friction" and setVal) or (root and root.Friction) or rootProps.Friction
									local elasticity = (subName == ".Elasticity" and setVal) or (root and root.Elasticity) or rootProps.Elasticity
									local frictionWeight = (subName == ".FrictionWeight" and setVal) or (root and root.FrictionWeight) or rootProps.FrictionWeight
									local elasticityWeight = (subName == ".ElasticityWeight" and setVal) or (root and root.ElasticityWeight) or rootProps.ElasticityWeight
									setVal = PhysicalProperties.new(density,friction,elasticity,frictionWeight,elasticityWeight)
								elseif rootTypeName == "Ray" then
									local rootOrigin,rootDirection = root.Origin,root.Direction
									local origin = (subName == ".Origin" and setVal) or Vector3.new((subName == ".Origin.X" and setVal) or rootOrigin.X, (subName == ".Origin.Y" and setVal) or rootOrigin.Y, (subName == ".Origin.Z" and setVal) or rootOrigin.Z)
									local direction = (subName == ".Direction" and setVal) or Vector3.new((subName == ".Direction.X" and setVal) or rootDirection.X, (subName == ".Direction.Y" and setVal) or rootDirection.Y, (subName == ".Direction.Z" and setVal) or rootDirection.Z)
									setVal = Ray.new(origin,direction)
								elseif rootTypeName == "Faces" then
									local faces = {}
									local faceList = {"Back","Bottom","Front","Left","Right","Top"}
									for _,face in pairs(faceList) do
										local val
										if subName == "."..face then
											val = setVal
										else
											val = root[face]
										end
										if val then faces[#faces+1] = Enum.NormalId[face] end
									end
									setVal = Faces.new(unpack(faces))
								elseif rootTypeName == "Axes" then
									local axes = {}
									local axesList = {"X","Y","Z"}
									for _,axe in pairs(axesList) do
										local val
										if subName == "."..axe then
											val = setVal
										else
											val = root[axe]
										end
										if val then axes[#axes+1] = Enum.Axis[axe] end
									end
									setVal = Axes.new(unpack(axes))
								elseif rootTypeName == "NumberRange" then
									setVal = NumberRange.new(subName == ".Min" and setVal or root.Min, subName == ".Max" and setVal or root.Max)
								end
							end

							if typeName == "PhysicalProperties" and setVal then
								setVal = root or PhysicalProperties.new(obj.Material)
							end

							if prop.IsAttribute then
								setAttribute(obj,attributeName,setVal)
							else
								obj[propName] = setVal
							end
						end)
					end
				end

				if not noupdate then
					Properties.ComputeConflicts(prop)
				end
			end

			Properties.InitInputBox = function()
				inputBox = create({
					{1,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderSizePixel=0,Name="InputBox",Size=UDim2.new(0,200,0,22),Visible=false,ZIndex=2,}},
					{2,"TextBox",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BackgroundTransparency=1,BorderColor3=Color3.new(0.062745101749897,0.51764708757401,1),BorderSizePixel=0,ClearTextOnFocus=false,Font=3,Parent={1},PlaceholderColor3=Color3.new(0.69803923368454,0.69803923368454,0.69803923368454),Position=UDim2.new(0,3,0,0),Size=UDim2.new(1,-6,1,0),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,ZIndex=2,}},
				})
				inputTextBox = inputBox.TextBox
				inputBox.BackgroundColor3 = Settings.Theme.TextBox
				inputBox.Parent = Properties.Window.GuiElems.Content.List

				inputTextBox.FocusLost:Connect(function()
					if not inputProp then return end

					local prop = inputProp
					inputProp = nil
					local val = Properties.StringToValue(prop,inputTextBox.Text)
					if val then Properties.SetProp(prop,val) else Properties.Refresh() end
				end)

				inputTextBox.Focused:Connect(function()
					inputTextBox.SelectionStart = 1
					inputTextBox.CursorPosition = #inputTextBox.Text + 1
				end)

				Lib.ViewportTextBox.convert(inputTextBox)
			end

			Properties.SetInputProp = function(prop,entryIndex,special)
				local typeData = prop.ValueType
				local typeName = typeData.Name
				local fullName = prop.Class.."."..prop.Name..(prop.SubName or "")
				local propObj = autoUpdateObjs[fullName]
				local propVal = Properties.GetPropVal(prop,propObj)

				if prop.Tags.ReadOnly then return end

				inputProp = prop
				if special then
					if special == "color" then
						if typeName == "Color3" then
							inputTextBox.Text = propVal and Properties.ValueToString(prop,propVal) or ""
							Properties.DisplayColorEditor(prop,propVal)
						elseif typeName == "BrickColor" then
							Properties.DisplayBrickColorEditor(prop,entryIndex,propVal)
						elseif typeName == "ColorSequence" then
							inputTextBox.Text = propVal and Properties.ValueToString(prop,propVal) or ""
							Properties.DisplayColorSequenceEditor(prop,propVal)
						end
					elseif special == "right" then
						if typeName == "NumberSequence" then
							inputTextBox.Text = propVal and Properties.ValueToString(prop,propVal) or ""
							Properties.DisplayNumberSequenceEditor(prop,propVal)
						elseif typeName == "ColorSequence" then
							inputTextBox.Text = propVal and Properties.ValueToString(prop,propVal) or ""
							Properties.DisplayColorSequenceEditor(prop,propVal)
						end
					end
				else
					if Properties.IsTextEditable(prop) then
						inputTextBox.Text = propVal and Properties.ValueToString(prop,propVal) or ""
						inputTextBox:CaptureFocus()
					elseif typeData.Category == "Enum" then
						Properties.DisplayEnumDropdown(entryIndex)
					elseif typeName == "BrickColor" then
						Properties.DisplayBrickColorEditor(prop,entryIndex,propVal)
					end
				end
				Properties.Refresh()
			end

			Properties.InitSearch = function()
				local TweenService = service.TweenService
				local SearchFrame = Properties.GuiElems.ToolBar.SearchFrame
				local searchBox = SearchFrame.SearchBox

				local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint)

				local Tweens = {
					Start = TweenService:Create(SearchFrame.UIStroke, TweenInfo, { Color = Color3.fromRGB(0, 120, 215) }),
					End = TweenService:Create(SearchFrame.UIStroke, TweenInfo, { Color = Color3.fromRGB(42, 42, 42) })
				}

				Lib.ViewportTextBox.convert(searchBox)

				searchBox.FocusLost:Connect(function() Tweens.End:Play() end)
				searchBox.Focused:Connect(function() Tweens.Start:Play() end)

				searchBox:GetPropertyChangedSignal("Text"):Connect(function()
					Properties.SearchText = searchBox.Text
					Properties.Update()
					Properties.Refresh()
				end)
			end

			Properties.InitEntryStuff = function()
				Properties.EntryTemplate = create({
					{1,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderColor3=Color3.new(0.1294117718935,0.1294117718935,0.1294117718935),Font=3,Name="Entry",Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,250,0,22),Text="",TextSize=14,}},
					{2,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=0,Name="NameFrame",Parent={1},Position=UDim2.new(0,20,0,0),Size=UDim2.new(1,-40,1,0),}},
					{3,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="PropName",Parent={2},Position=UDim2.new(0,2,0,0),Size=UDim2.new(1,-2,1,0),Text="Anchored",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=0.10000000149012,TextTruncate=1,TextXAlignment=0,}},
					{4,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClipsDescendants=true,Font=3,Name="Expand",Parent={2},Position=UDim2.new(0,-20,0,1),Size=UDim2.new(0,20,0,20),Text="",TextSize=14,Visible=false,}},
					{5,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642383285",ImageRectOffset=Vector2.new(144,16),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={4},Position=UDim2.new(0,2,0,2),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
					{6,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=4,Name="ToggleAttributes",Parent={2},Position=UDim2.new(1,-85,0,0),Size=UDim2.new(0,85,0,22),Text="[SETTING: OFF]",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=0.10000000149012,Visible=false,}},
					{7,"Frame",{BackgroundColor3=Color3.new(0.04313725605607,0.35294118523598,0.68627452850342),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019607901573,0.73725491762161),BorderSizePixel=0,Name="ValueFrame",Parent={1},Position=UDim2.new(1,-100,0,0),Size=UDim2.new(0,80,1,0),}},
					{8,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=0,Name="Line",Parent={7},Position=UDim2.new(0,-1,0,0),Size=UDim2.new(0,1,1,0),}},
					{9,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="ColorButton",Parent={7},Size=UDim2.new(0,20,0,22),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,Visible=false,}},
					{10,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(0,0,0),Name="ColorPreview",Parent={9},Position=UDim2.new(0,5,0,6),Size=UDim2.new(0,10,0,10),}},
					{11,"UIGradient",{Parent={10},}},
					{12,"Frame",{BackgroundTransparency=1,Name="EnumArrow",Parent={7},Position=UDim2.new(1,-16,0,3),Size=UDim2.new(0,16,0,16),Visible=false,}},
					{13,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={12},Position=UDim2.new(0,8,0,9),Size=UDim2.new(0,1,0,1),}},
					{14,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={12},Position=UDim2.new(0,7,0,8),Size=UDim2.new(0,3,0,1),}},
					{15,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={12},Position=UDim2.new(0,6,0,7),Size=UDim2.new(0,5,0,1),}},
					{16,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="ValueBox",Parent={7},Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-8,1,0),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=0.10000000149012,TextTruncate=1,TextXAlignment=0,}},
					{17,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="RightButton",Parent={7},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,22),Text="...",TextColor3=Color3.new(1,1,1),TextSize=14,Visible=false,}},
					{18,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="SettingsButton",Parent={7},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,22),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,Visible=false,}},
					{19,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="SoundPreview",Parent={7},Size=UDim2.new(1,0,1,0),Visible=false,}},
					{20,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="ControlButton",Parent={19},Size=UDim2.new(0,20,0,22),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
					{21,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642383285",ImageRectOffset=Vector2.new(144,16),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={20},Position=UDim2.new(0,2,0,3),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
					{22,"Frame",{BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BorderSizePixel=0,Name="TimeLine",Parent={19},Position=UDim2.new(0,26,0.5,-1),Size=UDim2.new(1,-34,0,2),}},
					{23,"Frame",{BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.1294117718935,0.1294117718935,0.1294117718935),Name="Slider",Parent={22},Position=UDim2.new(0,-4,0,-8),Size=UDim2.new(0,8,0,18),}},
					{24,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="EditAttributeButton",Parent={1},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,22),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
					{25,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5034718180",ImageTransparency=0.20000000298023,Name="Icon",Parent={24},Position=UDim2.new(0,2,0,3),Size=UDim2.new(0,16,0,16),}},
					{26,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderSizePixel=0,Font=3,Name="RowButton",Parent={1},Size=UDim2.new(1,0,1,0),Text="Add Attribute",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=0.10000000149012,Visible=false,}},
				})

				local fullNameFrame = Lib.Frame.new()
				local label = Lib.Label.new()
				label.Parent = fullNameFrame.Gui
				label.Position = UDim2.new(0,2,0,0)
				label.Size = UDim2.new(1,-4,1,0)
				fullNameFrame.Visible = false
				fullNameFrame.Parent = window.Gui

				Properties.FullNameFrame = fullNameFrame
				Properties.FullNameFrameAttach = Lib.AttachTo(fullNameFrame)
			end

			Properties.Init = function() -- TODO: MAKE BETTER
				local guiItems = create({
					{1,"Folder",{Name="Items",}},
					{2,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="ToolBar",Parent={1},Size=UDim2.new(1,0,0,22),}},
					{3,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.1176470592618,0.1176470592618,0.1176470592618),BorderSizePixel=0,Name="SearchFrame",Parent={2},Position=UDim2.new(0,3,0,1),Size=UDim2.new(1,-6,0,18),}},
					{4,"TextBox",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClearTextOnFocus=false,Font=3,Name="SearchBox",Parent={3},PlaceholderColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),PlaceholderText="Search properties",Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-24,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,}},
					{5,"UICorner",{CornerRadius=UDim.new(0,2),Parent={3},}},
					{6,"UIStroke",{Thickness=1.4,Parent={3},Color=Color3.fromRGB(42,42,42)}},
					{7,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Reset",Parent={3},Position=UDim2.new(1,-17,0,1),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
					{8,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5034718129",ImageColor3=Color3.new(0.39215686917305,0.39215686917305,0.39215686917305),Parent={7},Size=UDim2.new(0,16,0,16),}},
					{9,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Refresh",Parent={2},Position=UDim2.new(1,-20,0,1),Size=UDim2.new(0,18,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,Visible=false,}},
					{10,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5642310344",Parent={9},Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,12,0,12),}},
					{11,"Frame",{BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Name="ScrollCorner",Parent={1},Position=UDim2.new(1,-16,1,-16),Size=UDim2.new(0,16,0,16),Visible=false,}},
					{12,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ClipsDescendants=true,Name="List",Parent={1},Position=UDim2.new(0,0,0,23),Size=UDim2.new(1,0,1,-23),}},
				})

				-- Vars
				categoryOrder =	API.CategoryOrder
				for category,_ in next,categoryOrder do
					if not Properties.CollapsedCategories[category] then
						expanded["CAT_"..category] = true
					end
				end
				expanded["Sound.SoundId"] = true

				-- Init window
				window = Lib.Window.new()
				Properties.Window = window
				window:SetTitle("Properties")

				toolBar = guiItems.ToolBar
				propsFrame = guiItems.List

				Properties.GuiElems.ToolBar = toolBar
				Properties.GuiElems.PropsFrame = propsFrame

				Properties.InitEntryStuff()

				-- Window events
				window.GuiElems.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if Properties.Window:IsContentVisible() then
						Properties.UpdateView()
						Properties.Refresh()
					end
				end)
				window.OnActivate:Connect(function()
					Properties.UpdateView()
					Properties.Update()
					Properties.Refresh()
				end)
				window.OnRestore:Connect(function()
					Properties.UpdateView()
					Properties.Update()
					Properties.Refresh()
				end)

				-- Init scrollbars
				scrollV = Lib.ScrollBar.new()		
				scrollV.WheelIncrement = 3
				scrollV.Gui.Position = UDim2.new(1,-16,0,23)
				scrollV:SetScrollFrame(propsFrame)
				scrollV.Scrolled:Connect(function()
					Properties.Index = scrollV.Index
					Properties.Refresh()
				end)

				scrollH = Lib.ScrollBar.new(true)
				scrollH.Increment = 5
				scrollH.WheelIncrement = 20
				scrollH.Gui.Position = UDim2.new(0,0,1,-16)
				scrollH.Scrolled:Connect(function()
					Properties.Refresh()
				end)

				-- Setup Gui
				window.GuiElems.Line.Position = UDim2.new(0,0,0,22)
				toolBar.Parent = window.GuiElems.Content
				propsFrame.Parent = window.GuiElems.Content
				guiItems.ScrollCorner.Parent = window.GuiElems.Content
				scrollV.Gui.Parent = window.GuiElems.Content
				scrollH.Gui.Parent = window.GuiElems.Content
				Properties.InitInputBox()
				Properties.InitSearch()
			end

			return Properties
		end

		return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
	end,
	ScriptViewer = function()
--[[
	Script Viewer App Module
	
	A script viewer that is basically a notepad
]]

		-- Common Locals
		local Main,Lib,Apps,Settings -- Main Containers
		local Explorer, Properties, ScriptViewer, Notebook -- Major Apps
		local API,RMD,env,service,plr,create,createSimple -- Main Locals

		local function initDeps(data)
			Main = data.Main
			Lib = data.Lib
			Apps = data.Apps
			Settings = data.Settings

			API = data.API
			RMD = data.RMD
			env = data.env
			service = data.service
			plr = data.plr
			create = data.create
			createSimple = data.createSimple
		end

		local function initAfterMain()
			Explorer = Apps.Explorer
			Properties = Apps.Properties
			ScriptViewer = Apps.ScriptViewer
			Notebook = Apps.Notebook
		end

		local function main()
			local ScriptViewer = {}
			local window, codeFrame
			local PreviousScr = nil

			ScriptViewer.ViewScript = function(scr)
				local success, source = pcall(env.decompile, scr)
				if not success or not source then source, PreviousScr = ("-- DEX - %s failed to decompile %s"):format(env.executor, scr.ClassName), nil else PreviousScr = scr end
				codeFrame:SetText(source:gsub("\0", "\\0"))
				window:Show()
			end

			ScriptViewer.Init = function()
				window = Lib.Window.new()
				window:SetTitle("Script Viewer")
				window:Resize(500, 400)
				ScriptViewer.Window = window

				codeFrame = Lib.CodeFrame.new()
				codeFrame.Frame.Position = UDim2.new(0,0,0,20)
				codeFrame.Frame.Size = UDim2.new(1,0,1,-20)
				codeFrame.Frame.Parent = window.GuiElems.Content

				-- TODO: REMOVE AND MAKE BETTER
				local copy = Instance.new("TextButton", window.GuiElems.Content)
				copy.BackgroundTransparency = 1
				copy.Size = UDim2.new(0.5,0,0,20)
				copy.Text = "Copy to Clipboard"
				copy.TextColor3 = Color3.new(1,1,1)

				copy.MouseButton1Click:Connect(function()
					local source = codeFrame:GetText()
					env.setclipboard(source)
				end)

				local save = Instance.new("TextButton",window.GuiElems.Content)
				save.BackgroundTransparency = 1
				save.Position = UDim2.new(0.35,0,0,0)
				save.Size = UDim2.new(0.3,0,0,20)
				save.Text = "Save to File"
				save.TextColor3 = Color3.new(1,1,1)

				save.MouseButton1Click:Connect(function()
					local source = codeFrame:GetText()
					local filename = "Place_"..game.PlaceId.."_Script_"..os.time()..".txt"

					env.writefile(filename, source)
					if env.movefileas then
						env.movefileas(filename, ".txt")
					end
				end)

				local dumpbtn = Instance.new("TextButton",window.GuiElems.Content)
				dumpbtn.BackgroundTransparency = 1
				dumpbtn.Position = UDim2.new(0.7,0,0,0)
				dumpbtn.Size = UDim2.new(0.3,0,0,20)
				dumpbtn.Text = "Dump Functions"
				dumpbtn.TextColor3 = Color3.new(1,1,1)

				dumpbtn.MouseButton1Click:Connect(function()
					if PreviousScr ~= nil then
						pcall(function()
							-- thanks King.Kevin#6025 you'll obviously be credited (no discord tag since that can easily be impersonated)
							local getgc = getgc or get_gc_objects
							local getupvalues = (debug and debug.getupvalues) or getupvalues or getupvals
							local getconstants = (debug and debug.getconstants) or getconstants or getconsts
							local getinfo = (debug and (debug.getinfo or debug.info)) or getinfo
							local original = ("\n-- // Function Dumper made by King.Kevin\n-- // Script Path: %s\n\n--[["):format(PreviousScr:GetFullName())
							local dump = original
							local functions, function_count, data_base = {}, 0, {}
							function functions:add_to_dump(str, indentation, new_line)
								local new_line = new_line or true
								dump = dump .. ("%s%s%s"):format(string.rep("		", indentation), tostring(str), new_line and "\n" or "")
							end
							function functions:get_function_name(func)
								local n = getinfo(func).name
								return n ~= "" and n or "Unknown Name"
							end
							function functions:dump_table(input, indent, index)
								local indent = indent < 0 and 0 or indent
								functions:add_to_dump(("%s [%s] %s"):format(tostring(index), tostring(typeof(input)), tostring(input)), indent - 1)
								local count = 0
								for index, value in pairs(input) do
									count = count + 1
									if type(value) == "function" then
										functions:add_to_dump(("%d [function] = %s"):format(count, functions:get_function_name(value)), indent)
									elseif type(value) == "table" then
										if not data_base[value] then
											data_base[value] = true
											functions:add_to_dump(("%d [table]:"):format(count), indent)
											functions:dump_table(value, indent + 1, index)
										else
											functions:add_to_dump(("%d [table] (Recursive table detected)"):format(count), indent)
										end
									else
										functions:add_to_dump(("%d [%s] = %s"):format(count, tostring(typeof(value)), tostring(value)), indent)
									end
								end
							end
							function functions:dump_function(input, indent)
								functions:add_to_dump(("\nFunction Dump: %s"):format(functions:get_function_name(input)), indent)
								functions:add_to_dump(("\nFunction Upvalues: %s"):format(functions:get_function_name(input)), indent)
								for index, upvalue in pairs(getupvalues(input)) do
									if type(upvalue) == "function" then
										functions:add_to_dump(("%d [function] = %s"):format(index, functions:get_function_name(upvalue)), indent + 1)
									elseif type(upvalue) == "table" then
										if not data_base[upvalue] then
											data_base[upvalue] = true
											functions:add_to_dump(("%d [table]:"):format(index), indent + 1)
											functions:dump_table(upvalue, indent + 2, index)
										else
											functions:add_to_dump(("%d [table] (Recursive table detected)"):format(index), indent + 1)
										end
									else
										functions:add_to_dump(("%d [%s] = %s"):format(index, tostring(typeof(upvalue)), tostring(upvalue)), indent + 1)
									end
								end
								functions:add_to_dump(("\nFunction Constants: %s"):format(functions:get_function_name(input)), indent)
								for index, constant in pairs(getconstants(input)) do
									if type(constant) == "function" then
										functions:add_to_dump(("%d [function] = %s"):format(index, functions:get_function_name(constant)), indent + 1)
									elseif type(constant) == "table" then
										if not data_base[constant] then
											data_base[constant] = true
											functions:add_to_dump(("%d [table]:"):format(index), indent + 1)
											functions:dump_table(constant, indent + 2, index)
										else
											functions:add_to_dump(("%d [table] (Recursive table detected)"):format(index), indent + 1)
										end
									else
										functions:add_to_dump(("%d [%s] = %s"):format(index, tostring(typeof(constant)), tostring(constant)), indent + 1)
									end
								end
							end
							for _, _function in pairs(getgc()) do
								if typeof(_function) == "function" and getfenv(_function).script and getfenv(_function).script == PreviousScr then
									functions:dump_function(_function, 0)
									functions:add_to_dump("\n" .. ("="):rep(100), 0, false)
								end
							end
							local source = codeFrame:GetText()

							if dump ~= original then source = source .. dump .. "]]" end
							codeFrame:SetText(source)
						end)
					end
				end)
			end

			return ScriptViewer
		end

		return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
	end,
	Lib = function()
--[[
	Lib Module
	
	Container for functions and classes
]]

		-- Common Locals
		local Main,Lib,Apps,Settings -- Main Containers
		local Explorer, Properties, ScriptViewer, Notebook -- Major Apps
		local API,RMD,env,service,plr,create,createSimple -- Main Locals

		local function initDeps(data)
			Main = data.Main
			Lib = data.Lib
			Apps = data.Apps
			Settings = data.Settings

			API = data.API
			RMD = data.RMD
			env = data.env
			service = data.service
			plr = data.plr
			create = data.create
			createSimple = data.createSimple
		end

		local function initAfterMain()
			Explorer = Apps.Explorer
			Properties = Apps.Properties
			ScriptViewer = Apps.ScriptViewer
			Notebook = Apps.Notebook
		end

		local function main()
			local Lib = {}

			local renderStepped = service.RunService.RenderStepped
			local signalWait = renderStepped.wait
			local PH = newproxy() -- Placeholder, must be replaced in constructor
			local SIGNAL = newproxy()

			-- Usually for classes that work with a Roblox Object
			local function initObj(props,mt)
				local type = type
				local function copy(t)
					local res = {}
					for i,v in pairs(t) do
						if v == SIGNAL then
							res[i] = Lib.Signal.new()
						elseif type(v) == "table" then
							res[i] = copy(v)
						else
							res[i] = v
						end
					end		
					return res
				end

				local newObj = copy(props)
				return setmetatable(newObj,mt)
			end

			local function getGuiMT(props,funcs)
				return {__index = function(self,ind) if not props[ind] then return funcs[ind] or self.Gui[ind] end end,
				__newindex = function(self,ind,val) if not props[ind] then self.Gui[ind] = val else rawset(self,ind,val) end end}
			end

			-- Functions

			Lib.FormatLuaString = (function()
				local string = string
				local gsub = string.gsub
				local format = string.format
				local char = string.char
				local cleanTable = {['"'] = '\\"', ['\\'] = '\\\\'}
				for i = 0,31 do
					cleanTable[char(i)] = "\\"..format("%03d",i)
				end
				for i = 127,255 do
					cleanTable[char(i)] = "\\"..format("%03d",i)
				end

				return function(str)
					return gsub(str,"[\"\\\0-\31\127-\255]",cleanTable)
				end
			end)()

			Lib.CheckMouseInGui = function(gui)
				if gui == nil then return false end
				local mouse = Main.Mouse
				local guiPosition = gui.AbsolutePosition
				local guiSize = gui.AbsoluteSize	

				return mouse.X >= guiPosition.X and mouse.X < guiPosition.X + guiSize.X and mouse.Y >= guiPosition.Y and mouse.Y < guiPosition.Y + guiSize.Y
			end

			Lib.IsShiftDown = function()
				return service.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or service.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
			end

			Lib.IsCtrlDown = function()
				return service.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or service.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
			end

			Lib.CreateArrow = function(size,num,dir)
				local max = num
				local arrowFrame = createSimple("Frame",{
					BackgroundTransparency = 1,
					Name = "Arrow",
					Size = UDim2.new(0,size,0,size)
				})
				if dir == "up" then
					for i = 1,num do
						local newLine = createSimple("Frame",{
							BackgroundColor3 = Color3.new(220/255,220/255,220/255),
							BorderSizePixel = 0,
							Position = UDim2.new(0,math.floor(size/2)-(i-1),0,math.floor(size/2)+i-math.floor(max/2)-1),
							Size = UDim2.new(0,i+(i-1),0,1),
							Parent = arrowFrame
						})
					end
					return arrowFrame
				elseif dir == "down" then
					for i = 1,num do
						local newLine = createSimple("Frame",{
							BackgroundColor3 = Color3.new(220/255,220/255,220/255),
							BorderSizePixel = 0,
							Position = UDim2.new(0,math.floor(size/2)-(i-1),0,math.floor(size/2)-i+math.floor(max/2)+1),
							Size = UDim2.new(0,i+(i-1),0,1),
							Parent = arrowFrame
						})
					end
					return arrowFrame
				elseif dir == "left" then
					for i = 1,num do
						local newLine = createSimple("Frame",{
							BackgroundColor3 = Color3.new(220/255,220/255,220/255),
							BorderSizePixel = 0,
							Position = UDim2.new(0,math.floor(size/2)+i-math.floor(max/2)-1,0,math.floor(size/2)-(i-1)),
							Size = UDim2.new(0,1,0,i+(i-1)),
							Parent = arrowFrame
						})
					end
					return arrowFrame
				elseif dir == "right" then
					for i = 1,num do
						local newLine = createSimple("Frame",{
							BackgroundColor3 = Color3.new(220/255,220/255,220/255),
							BorderSizePixel = 0,
							Position = UDim2.new(0,math.floor(size/2)-i+math.floor(max/2)+1,0,math.floor(size/2)-(i-1)),
							Size = UDim2.new(0,1,0,i+(i-1)),
							Parent = arrowFrame
						})
					end
					return arrowFrame
				end
				error("r u ok")
			end

			Lib.ParseXML = (function()
				local func = function()
					-- Only exists to parse RMD
					-- from https://github.com/jonathanpoelen/xmlparser

					local string, print, pairs = string, print, pairs

					-- http://lua-users.org/wiki/StringTrim
					local trim = function(s)
						local from = s:match"^%s*()"
						return from > #s and "" or s:match(".*%S", from)
					end

					local gtchar = string.byte('>', 1)
					local slashchar = string.byte('/', 1)
					local D = string.byte('D', 1)
					local E = string.byte('E', 1)

					function parse(s, evalEntities)
						-- remove comments
						s = s:gsub('<!%-%-(.-)%-%->', '')

						local entities, tentities = {}

						if evalEntities then
							local pos = s:find('<[_%w]')
							if pos then
								s:sub(1, pos):gsub('<!ENTITY%s+([_%w]+)%s+(.)(.-)%2', function(name, q, entity)
									entities[#entities+1] = {name=name, value=entity}
								end)
								tentities = createEntityTable(entities)
								s = replaceEntities(s:sub(pos), tentities)
							end
						end

						local t, l = {}, {}

						local addtext = function(txt)
							txt = txt:match'^%s*(.*%S)' or ''
							if #txt ~= 0 then
								t[#t+1] = {text=txt}
							end		
						end

						s:gsub('<([?!/]?)([-:_%w]+)%s*(/?>?)([^<]*)', function(type, name, closed, txt)
							-- open
							if #type == 0 then
								local a = {}
								if #closed == 0 then
									local len = 0
									for all,aname,_,value,starttxt in string.gmatch(txt, "(.-([-_%w]+)%s*=%s*(.)(.-)%3%s*(/?>?))") do
										len = len + #all
										a[aname] = value
										if #starttxt ~= 0 then
											txt = txt:sub(len+1)
											closed = starttxt
											break
										end
									end
								end
								t[#t+1] = {tag=name, attrs=a, children={}}

								if closed:byte(1) ~= slashchar then
									l[#l+1] = t
									t = t[#t].children
								end

								addtext(txt)
								-- close
							elseif '/' == type then
								t = l[#l]
								l[#l] = nil

								addtext(txt)
								-- ENTITY
							elseif '!' == type then
								if E == name:byte(1) then
									txt:gsub('([_%w]+)%s+(.)(.-)%2', function(name, q, entity)
										entities[#entities+1] = {name=name, value=entity}
									end, 1)
								end
								-- elseif '?' == type then
								--	 print('?	' .. name .. ' // ' .. attrs .. '$$')
								-- elseif '-' == type then
								--	 print('comment	' .. name .. ' // ' .. attrs .. '$$')
								-- else
								--	 print('o	' .. #p .. ' // ' .. name .. ' // ' .. attrs .. '$$')
							end
						end)

						return {children=t, entities=entities, tentities=tentities}
					end

					function parseText(txt)
						return parse(txt)
					end

					function defaultEntityTable()
						return { quot='"', apos='\'', lt='<', gt='>', amp='&', tab='\t', nbsp=' ', }
					end

					function replaceEntities(s, entities)
						return s:gsub('&([^;]+);', entities)
					end

					function createEntityTable(docEntities, resultEntities)
						entities = resultEntities or defaultEntityTable()
						for _,e in pairs(docEntities) do
							e.value = replaceEntities(e.value, entities)
							entities[e.name] = e.value
						end
						return entities
					end

					return parseText
				end
				local newEnv = setmetatable({},{__index = getfenv()})
				setfenv(func,newEnv)
				return func()
			end)()

			Lib.FastWait = function(s)
				if not s then return signalWait(renderStepped) end
				local start = tick()
				while tick() - start < s do signalWait(renderStepped) end
			end

			Lib.ButtonAnim = function(button,data)
				local holding = false
				local disabled = false
				local mode = data and data.Mode or 1
				local control = {}

				if mode == 2 then
					local lerpTo = data.LerpTo or Color3.new(0,0,0)
					local delta = data.LerpDelta or 0.2
					control.StartColor = data.StartColor or button.BackgroundColor3
					control.PressColor = data.PressColor or control.StartColor:lerp(lerpTo,delta)
					control.HoverColor = data.HoverColor or control.StartColor:lerp(control.PressColor,0.6)
					control.OutlineColor = data.OutlineColor
				end

				button.InputBegan:Connect(function(input)
					if disabled then return end

					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if not holding then
							if mode == 1 then
								button.BackgroundTransparency = 0.4
							elseif mode == 2 then
								button.BackgroundColor3 = control.HoverColor
							end
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						holding = true
						if mode == 1 then
							button.BackgroundTransparency = 0
						elseif mode == 2 then
							button.BackgroundColor3 = control.PressColor
							if control.OutlineColor then button.BorderColor3 = control.PressColor end
						end
					end
				end)

				button.InputEnded:Connect(function(input)
					if disabled then return end

					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if not holding then
							if mode == 1 then
								button.BackgroundTransparency = 1
							elseif mode == 2 then
								button.BackgroundColor3 = control.StartColor
							end
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						holding = false
						if mode == 1 then
							button.BackgroundTransparency = Lib.CheckMouseInGui(button) and 0.4 or 1
						elseif mode == 2 then
							button.BackgroundColor3 = Lib.CheckMouseInGui(button) and control.HoverColor or control.StartColor
							if control.OutlineColor then button.BorderColor3 = control.OutlineColor end
						end
					end
				end)

				control.Disable = function()
					disabled = true
					holding = false

					if mode == 1 then
						button.BackgroundTransparency = 1
					elseif mode == 2 then
						button.BackgroundColor3 = control.StartColor
					end
				end

				control.Enable = function()
					disabled = false
				end

				return control
			end

			Lib.FindAndRemove = function(t,item)
				local pos = table.find(t,item)
				if pos then table.remove(t,pos) end
			end

			Lib.AttachTo = function(obj,data)
				local target,posOffX,posOffY,sizeOffX,sizeOffY,resize,con
				local disabled = false

				local function update()
					if not obj or not target then return end

					local targetPos = target.AbsolutePosition
					local targetSize = target.AbsoluteSize
					obj.Position = UDim2.new(0,targetPos.X + posOffX,0,targetPos.Y + posOffY)
					if resize then obj.Size = UDim2.new(0,targetSize.X + sizeOffX,0,targetSize.Y + sizeOffY) end
				end

				local function setup(o,data)
					obj = o
					data = data or {}
					target = data.Target
					posOffX = data.PosOffX or 0
					posOffY = data.PosOffY or 0
					sizeOffX = data.SizeOffX or 0
					sizeOffY = data.SizeOffY or 0
					resize = data.Resize or false

					if con then con:Disconnect() con = nil end
					if target then
						con = target.Changed:Connect(function(prop)
							if not disabled and prop == "AbsolutePosition" or prop == "AbsoluteSize" then
								update()
							end
						end)
					end

					update()
				end
				setup(obj,data)

				return {
					SetData = function(obj,data)
						setup(obj,data)
					end,
					Enable = function()
						disabled = false
						update()
					end,
					Disable = function()
						disabled = true
					end,
					Destroy = function()
						con:Disconnect()
						con = nil
					end,
				}
			end

			Lib.ProtectedGuis = {}

			Lib.ShowGui = function(gui)
				if env.gethui then
					gui.Parent = env.gethui()
				elseif env.protectgui then
					env.protectgui(gui)
					gui.Parent = Main.GuiHolder
				else
					gui.Parent = Main.GuiHolder
				end
			end

			Lib.ColorToBytes = function(col)
				local round = math.round
				return string.format("%d, %d, %d",round(col.r*255),round(col.g*255),round(col.b*255))
			end

			Lib.ReadFile = function(filename)
				if not env.readfile then return end

				local s,contents = pcall(env.readfile,filename)
				if s and contents then return contents end
			end

			Lib.DeferFunc = function(f,...)
				signalWait(renderStepped)
				return f(...)
			end

			Lib.LoadCustomAsset = function(filepath)
				if not env.getcustomasset or not env.isfile or not env.isfile(filepath) then return end

				return env.getcustomasset(filepath)
			end

			Lib.FetchCustomAsset = function(url,filepath)
				if not env.writefile then return end

				local s,data = pcall(oldgame.HttpGet,game,url)
				if not s then return end

				env.writefile(filepath,data)
				return Lib.LoadCustomAsset(filepath)
			end

			-- Classes

			Lib.Signal = (function()
				local funcs = {}

				local disconnect = function(con)
					local pos = table.find(con.Signal.Connections,con)
					if pos then table.remove(con.Signal.Connections,pos) end
				end

				funcs.Connect = function(self,func)
					if type(func) ~= "function" then error("Attempt to connect a non-function") end		
					local con = {
						Signal = self,
						Func = func,
						Disconnect = disconnect
					}
					self.Connections[#self.Connections+1] = con
					return con
				end

				funcs.Fire = function(self,...)
					for i,v in next,self.Connections do
						xpcall(coroutine.wrap(v.Func),function(e) warn(e.."\n"..debug.traceback()) end,...)
					end
				end

				local mt = {
					__index = funcs,
					__tostring = function(self)
						return "Signal: " .. tostring(#self.Connections) .. " Connections"
					end
				}

				local function new()
					local obj = {}
					obj.Connections = {}

					return setmetatable(obj,mt)
				end

				return {new = new}
			end)()

			Lib.Set = (function()
				local funcs = {}

				funcs.Add = function(self,obj)
					if self.Map[obj] then return end

					local list = self.List
					list[#list+1] = obj
					self.Map[obj] = true
					self.Changed:Fire()
				end

				funcs.AddTable = function(self,t)
					local changed
					local list,map = self.List,self.Map
					for i = 1,#t do
						local elem = t[i]
						if not map[elem] then
							list[#list+1] = elem
							map[elem] = true
							changed = true
						end
					end
					if changed then self.Changed:Fire() end
				end

				funcs.Remove = function(self,obj)
					if not self.Map[obj] then return end

					local list = self.List
					local pos = table.find(list,obj)
					if pos then table.remove(list,pos) end
					self.Map[obj] = nil
					self.Changed:Fire()
				end

				funcs.RemoveTable = function(self,t)
					local changed
					local list,map = self.List,self.Map
					local removeSet = {}
					for i = 1,#t do
						local elem = t[i]
						map[elem] = nil
						removeSet[elem] = true
					end

					for i = #list,1,-1 do
						local elem = list[i]
						if removeSet[elem] then
							table.remove(list,i)
							changed = true
						end
					end
					if changed then self.Changed:Fire() end
				end

				funcs.Set = function(self,obj)
					if #self.List == 1 and self.List[1] == obj then return end

					self.List = {obj}
					self.Map = {[obj] = true}
					self.Changed:Fire()
				end

				funcs.SetTable = function(self,t)
					local newList,newMap = {},{}
					self.List,self.Map = newList,newMap
					table.move(t,1,#t,1,newList)
					for i = 1,#t do
						newMap[t[i]] = true
					end
					self.Changed:Fire()
				end

				funcs.Clear = function(self)
					if #self.List == 0 then return end
					self.List = {}
					self.Map = {}
					self.Changed:Fire()
				end

				local mt = {__index = funcs}

				local function new()
					local obj = setmetatable({
						List = {},
						Map = {},
						Changed = Lib.Signal.new()
					},mt)

					return obj
				end

				return {new = new}
			end)()

			Lib.IconMap = (function()
				local funcs = {}
				local _MapId, _Icons = (483448923), {
					["Accessory"] = 32;
					["Accoutrement"] = 32;
					["AdService"] = 73;
					["Animation"] = 60;
					["AnimationController"] = 60;
					["AnimationTrack"] = 60;
					["Animator"] = 60;
					["ArcHandles"] = 56;
					["AssetService"] = 72;
					["Attachment"] = 34;
					["Backpack"] = 20;
					["BadgeService"] = 75;
					["BallSocketConstraint"] = 89;
					["BillboardGui"] = 64;
					["BinaryStringValue"] = 4;
					["BindableEvent"] = 67;
					["BindableFunction"] = 66;
					["BlockMesh"] = 8;
					["BloomEffect"] = 90;
					["BlurEffect"] = 90;
					["BodyAngularVelocity"] = 14;
					["BodyForce"] = 14;
					["BodyGyro"] = 14;
					["BodyPosition"] = 14;
					["BodyThrust"] = 14;
					["BodyVelocity"] = 14;
					["BoolValue"] = 4;
					["BoxHandleAdornment"] = 54;
					["BrickColorValue"] = 4;
					["Camera"] = 5;
					["CFrameValue"] = 4;
					["CharacterMesh"] = 60;
					["Chat"] = 33;
					["ClickDetector"] = 41;
					["CollectionService"] = 30;
					["Color3Value"] = 4;
					["ColorCorrectionEffect"] = 90;
					["ConeHandleAdornment"] = 54;
					["Configuration"] = 58;
					["ContentProvider"] = 72;
					["ContextActionService"] = 41;
					["CoreGui"] = 46;
					["CoreScript"] = 18;
					["CornerWedgePart"] = 1;
					["CustomEvent"] = 4;
					["CustomEventReceiver"] = 4;
					["CylinderHandleAdornment"] = 54;
					["CylinderMesh"] = 8;
					["CylindricalConstraint"] = 89;
					["Debris"] = 30;
					["Decal"] = 7;
					["Dialog"] = 62;
					["DialogChoice"] = 63;
					["DoubleConstrainedValue"] = 4;
					["Explosion"] = 36;
					["FileMesh"] = 8;
					["Fire"] = 61;
					["Flag"] = 38;
					["FlagStand"] = 39;
					["FloorWire"] = 4;
					["Folder"] = 70;
					["ForceField"] = 37;
					["Frame"] = 48;
					["GamePassService"] = 19;
					["Glue"] = 34;
					["GuiButton"] = 52;
					["GuiMain"] = 47;
					["GuiService"] = 47;
					["Handles"] = 53;
					["HapticService"] = 84;
					["Hat"] = 45;
					["HingeConstraint"] = 89;
					["Hint"] = 33;
					["HopperBin"] = 22;
					["HttpService"] = 76;
					["Humanoid"] = 9;
					["ImageButton"] = 52;
					["ImageLabel"] = 49;
					["InsertService"] = 72;
					["IntConstrainedValue"] = 4;
					["IntValue"] = 4;
					["JointInstance"] = 34;
					["JointsService"] = 34;
					["Keyframe"] = 60;
					["KeyframeSequence"] = 60;
					["KeyframeSequenceProvider"] = 60;
					["Lighting"] = 13;
					["LineHandleAdornment"] = 54;
					["LocalScript"] = 18;
					["LogService"] = 87;
					["MarketplaceService"] = 46;
					["Message"] = 33;
					["Model"] = 2;
					["ModuleScript"] = 71;
					["Motor"] = 34;
					["Motor6D"] = 34;
					["MoveToConstraint"] = 89;
					["NegateOperation"] = 78;
					["NetworkClient"] = 16;
					["NetworkReplicator"] = 29;
					["NetworkServer"] = 15;
					["NumberValue"] = 4;
					["ObjectValue"] = 4;
					["Pants"] = 44;
					["ParallelRampPart"] = 1;
					["Part"] = 1;
					["ParticleEmitter"] = 69;
					["PartPairLasso"] = 57;
					["PathfindingService"] = 37;
					["Platform"] = 35;
					["Player"] = 12;
					["PlayerGui"] = 46;
					["Players"] = 21;
					["PlayerScripts"] = 82;
					["PointLight"] = 13;
					["PointsService"] = 83;
					["Pose"] = 60;
					["PrismaticConstraint"] = 89;
					["PrismPart"] = 1;
					["PyramidPart"] = 1;
					["RayValue"] = 4;
					["ReflectionMetadata"] = 86;
					["ReflectionMetadataCallbacks"] = 86;
					["ReflectionMetadataClass"] = 86;
					["ReflectionMetadataClasses"] = 86;
					["ReflectionMetadataEnum"] = 86;
					["ReflectionMetadataEnumItem"] = 86;
					["ReflectionMetadataEnums"] = 86;
					["ReflectionMetadataEvents"] = 86;
					["ReflectionMetadataFunctions"] = 86;
					["ReflectionMetadataMember"] = 86;
					["ReflectionMetadataProperties"] = 86;
					["ReflectionMetadataYieldFunctions"] = 86;
					["RemoteEvent"] = 80;
					["RemoteFunction"] = 79;
					["ReplicatedFirst"] = 72;
					["ReplicatedStorage"] = 72;
					["RightAngleRampPart"] = 1;
					["RocketPropulsion"] = 14;
					["RodConstraint"] = 89;
					["RopeConstraint"] = 89;
					["Rotate"] = 34;
					["RotateP"] = 34;
					["RotateV"] = 34;
					["RunService"] = 66;
					["ScreenGui"] = 47;
					["Script"] = 6;
					["ScrollingFrame"] = 48;
					["Seat"] = 35;
					["Selection"] = 55;
					["SelectionBox"] = 54;
					["SelectionPartLasso"] = 57;
					["SelectionPointLasso"] = 57;
					["SelectionSphere"] = 54;
					["ServerScriptService"] = 0;
					["ServerStorage"] = 74;
					["Shirt"] = 43;
					["ShirtGraphic"] = 40;
					["SkateboardPlatform"] = 35;
					["Sky"] = 28;
					["SlidingBallConstraint"] = 89;
					["Smoke"] = 59;
					["Snap"] = 34;
					["Sound"] = 11;
					["SoundService"] = 31;
					["Sparkles"] = 42;
					["SpawnLocation"] = 25;
					["SpecialMesh"] = 8;
					["SphereHandleAdornment"] = 54;
					["SpotLight"] = 13;
					["SpringConstraint"] = 89;
					["StarterCharacterScripts"] = 82;
					["StarterGear"] = 20;
					["StarterGui"] = 46;
					["StarterPack"] = 20;
					["StarterPlayer"] = 88;
					["StarterPlayerScripts"] = 82;
					["Status"] = 2;
					["StringValue"] = 4;
					["SunRaysEffect"] = 90;
					["SurfaceGui"] = 64;
					["SurfaceLight"] = 13;
					["SurfaceSelection"] = 55;
					["Team"] = 24;
					["Teams"] = 23;
					["TeleportService"] = 81;
					["Terrain"] = 65;
					["TerrainRegion"] = 65;
					["TestService"] = 68;
					["TextBox"] = 51;
					["TextButton"] = 51;
					["TextLabel"] = 50;
					["Texture"] = 10;
					["TextureTrail"] = 4;
					["Tool"] = 17;
					["TouchTransmitter"] = 37;
					["TrussPart"] = 1;
					["UnionOperation"] = 77;
					["UserInputService"] = 84;
					["Vector3Value"] = 4;
					["VehicleSeat"] = 35;
					["VelocityMotor"] = 34;
					["WedgePart"] = 1;
					["Weld"] = 34;
					["Workspace"] = 19;

				}
				funcs.ExplorerIcons = { ["MapId"] = _MapId, ["Icons"] = _Icons }

				funcs.GetLabel = function(self)
					local label = Instance.new("ImageLabel")
					self:SetupLabel(label)
					return label
				end

				funcs.SetupLabel = function(self,obj)
					obj.BackgroundTransparency = 1
					obj.ImageRectOffset = Vector2.new(0, 0)
					obj.ImageRectSize = Vector2.new(self.IconSizeX, self.IconSizeY)
					obj.ScaleType = Enum.ScaleType.Crop
					obj.Size = UDim2.new(0, self.IconSizeX, 0, self.IconSizeY)
				end

				funcs.Display = function(self,obj,index)
					obj.Image = self.MapId
					if not self.NumX then
						obj.ImageRectOffset = Vector2.new(self.IconSizeX*index, 0)
					else
						obj.ImageRectOffset = Vector2.new(self.IconSizeX*(index % self.NumX), self.IconSizeY*math.floor(index / self.NumX))
					end
				end

				funcs.DisplayByKey = function(self, obj, key)
					if self.IndexDict[key] then
						self:Display(obj, self.IndexDict[key])
					else
						local rmdEntry = RMD.Classes[obj.ClassName]
						Explorer.ClassIcons:Display(obj, rmdEntry and rmdEntry.ExplorerImageIndex or 0)
					end
				end

				funcs.IconDehash = function(self, _id)
					return math.floor(_id / 14 % 14), math.floor(_id % 14)
				end

				funcs.GetExplorerIcon = function(self, obj, index)
					index = (self.ExplorerIcons.Icons[index] or 0)
					local row, col = self:IconDehash(index)
					local MapSize = Vector2.new(256, 256)
					local pad, border = 2, 1
					local IconSize = 16

					obj.Position = UDim2.new(-col - (pad * (col + 1) + border) / IconSize, 0, -row - (pad * (row + 1) + border) / IconSize, 0)
					obj.Size = UDim2.new(MapSize.X / IconSize, 0, MapSize.Y / IconSize, 0)
				end

				funcs.DisplayExplorerIcons = function(self, Frame, index)
					if Frame:FindFirstChild("IconMap") then
						self:GetExplorerIcon(Frame.IconMap, index)
					else
						Frame.ClipsDescendants = true

						local obj = Instance.new("ImageLabel", Frame)
						obj.BackgroundTransparency = 1
						obj.Image = ("http://www.roblox.com/asset/?id=" .. (self.ExplorerIcons.MapId))
						obj.Name = "IconMap"
						self:GetExplorerIcon(obj, index)
					end
				end

				funcs.SetDict = function(self,dict)
					self.IndexDict = dict
				end

				local mt = {}
				mt.__index = funcs

				local function new(mapId,mapSizeX,mapSizeY,iconSizeX,iconSizeY)
					local obj = setmetatable({
						MapId = mapId,
						MapSizeX = mapSizeX,
						MapSizeY = mapSizeY,
						IconSizeX = iconSizeX,
						IconSizeY = iconSizeY,
						NumX = mapSizeX/iconSizeX,
						IndexDict = {}
					}, mt)
					return obj
				end

				local function newLinear(mapId,iconSizeX,iconSizeY)
					local obj = setmetatable({
						MapId = mapId,
						IconSizeX = iconSizeX,
						IconSizeY = iconSizeY,
						IndexDict = {}
					},mt)
					return obj
				end

				return {new = new, newLinear = newLinear}
			end)()

			Lib.ScrollBar = (function()
				local funcs = {}
				local user = service.UserInputService
				local mouse = plr:GetMouse()
				local checkMouseInGui = Lib.CheckMouseInGui
				local createArrow = Lib.CreateArrow

				local function drawThumb(self)
					local total = self.TotalSpace
					local visible = self.VisibleSpace
					local index = self.Index
					local scrollThumb = self.GuiElems.ScrollThumb
					local scrollThumbFrame = self.GuiElems.ScrollThumbFrame

					if not (self:CanScrollUp()	or self:CanScrollDown()) then
						scrollThumb.Visible = false
					else
						scrollThumb.Visible = true
					end

					if self.Horizontal then
						scrollThumb.Size = UDim2.new(visible/total,0,1,0)
						if scrollThumb.AbsoluteSize.X < 16 then
							scrollThumb.Size = UDim2.new(0,16,1,0)
						end
						local fs = scrollThumbFrame.AbsoluteSize.X
						local bs = scrollThumb.AbsoluteSize.X
						scrollThumb.Position = UDim2.new(self:GetScrollPercent()*(fs-bs)/fs,0,0,0)
					else
						scrollThumb.Size = UDim2.new(1,0,visible/total,0)
						if scrollThumb.AbsoluteSize.Y < 16 then
							scrollThumb.Size = UDim2.new(1,0,0,16)
						end
						local fs = scrollThumbFrame.AbsoluteSize.Y
						local bs = scrollThumb.AbsoluteSize.Y
						scrollThumb.Position = UDim2.new(0,0,self:GetScrollPercent()*(fs-bs)/fs,0)
					end
				end

				local function createFrame(self)
					local newFrame = createSimple("Frame",{Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.35294118523598,0.35294118523598,0.35294118523598),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-16,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ScrollBar",})
					local button1, button2

					if self.Horizontal then
						newFrame.Size = UDim2.new(1,0,0,16)
						button1 = createSimple("ImageButton",{
							Parent = newFrame,
							Name = "Left",
							Size = UDim2.new(0,16,0,16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false
						})
						createArrow(16,4,"left").Parent = button1
						button2 = createSimple("ImageButton",{
							Parent = newFrame,
							Name = "Right",
							Position = UDim2.new(1,-16,0,0),
							Size = UDim2.new(0,16,0,16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false
						})
						createArrow(16,4,"right").Parent = button2
					else
						newFrame.Size = UDim2.new(0,16,1,0)
						button1 = createSimple("ImageButton",{
							Parent = newFrame,
							Name = "Up",
							Size = UDim2.new(0,16,0,16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false
						})
						createArrow(16,4,"up").Parent = button1
						button2 = createSimple("ImageButton",{
							Parent = newFrame,
							Name = "Down",
							Position = UDim2.new(0,0,1,-16),
							Size = UDim2.new(0,16,0,16),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutoButtonColor = false
						})
						createArrow(16,4,"down").Parent = button2
					end

					local scrollThumbFrame = createSimple("ImageButton", {
						BackgroundTransparency = 1,
						Parent = newFrame
					})
					if self.Horizontal then
						scrollThumbFrame.Position = UDim2.new(0,16,0,0)
						scrollThumbFrame.Size = UDim2.new(1,-32,1,0)
					else
						scrollThumbFrame.Position = UDim2.new(0,0,0,16)
						scrollThumbFrame.Size = UDim2.new(1,0,1,-32)
					end

					local scrollThumb = createSimple("Frame", {
						BackgroundColor3 = Color3.new(120/255, 120/255, 120/255),
						BorderSizePixel = 0,
						Parent = scrollThumbFrame
					})

					local markerFrame = createSimple("Frame", {
						BackgroundTransparency = 1,
						Name = "Markers",
						Size = UDim2.new(1, 0, 1, 0),
						Parent = scrollThumbFrame
					})

					local buttonPress = false
					local thumbPress = false
					local thumbFramePress = false

					local function handleButtonPress(button, scrollDirection)
						if self:CanScroll(scrollDirection) then
							button.BackgroundTransparency = 0.5
							self:ScrollToDirection(scrollDirection)
							self.Scrolled:Fire()
							local buttonTick = tick()
							local releaseEvent
							releaseEvent = user.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									releaseEvent:Disconnect()
									button.BackgroundTransparency = checkMouseInGui(button) and 0.8 or 1
									buttonPress = false
								end
							end)
							while buttonPress do
								if tick() - buttonTick >= 0.25 and self:CanScroll(scrollDirection) then
									self:ScrollToDirection(scrollDirection)
									self.Scrolled:Fire()
								end
								task.wait()
							end
						end
					end

					button1.MouseButton1Down:Connect(function(input)
						buttonPress = true
						handleButtonPress(button1, "Up")
					end)

					button1.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							button1.BackgroundTransparency = 1
						end
					end)

					button2.MouseButton1Down:Connect(function(input)
						buttonPress = true
						handleButtonPress(button2, "Down")
					end)

					button2.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							button2.BackgroundTransparency = 1
						end
					end)

					scrollThumb.InputBegan:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							local dir = self.Horizontal and "X" or "Y"
							local lastThumbPos = nil
							thumbPress = true
							scrollThumb.BackgroundTransparency = 0
							local mouseOffset = mouse[dir] - scrollThumb.AbsolutePosition[dir]
							local releaseEvent
							local mouseEvent

							releaseEvent = user.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									releaseEvent:Disconnect()
									if mouseEvent then mouseEvent:Disconnect() end
									scrollThumb.BackgroundTransparency = 0.2
									thumbPress = false
								end
							end)

							mouseEvent = user.InputChanged:Connect(function(input)
								if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and thumbPress then
									local thumbFrameSize = scrollThumbFrame.AbsoluteSize[dir] - scrollThumb.AbsoluteSize[dir]
									local pos = mouse[dir] - scrollThumbFrame.AbsolutePosition[dir] - mouseOffset
									if pos > thumbFrameSize then pos = thumbFrameSize
									elseif pos < 0 then pos = 0 end
									if lastThumbPos ~= pos then
										lastThumbPos = pos
										self:ScrollTo(math.floor(0.5 + pos / thumbFrameSize * (self.TotalSpace - self.VisibleSpace)))
									end
								end
							end)
						end
					end)

					scrollThumb.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							scrollThumb.BackgroundTransparency = 0
						end
					end)

					scrollThumbFrame.InputBegan:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not checkMouseInGui(scrollThumb) then
							local dir = self.Horizontal and "X" or "Y"
							local scrollDir = (mouse[dir] >= scrollThumb.AbsolutePosition[dir] + scrollThumb.AbsoluteSize[dir]) and 1 or 0
							local function doTick()
								local scrollSize = self.VisibleSpace - 1
								if scrollDir == 0 and mouse[dir] < scrollThumb.AbsolutePosition[dir] then
									self:ScrollTo(self.Index - scrollSize)
								elseif scrollDir == 1 and mouse[dir] >= scrollThumb.AbsolutePosition[dir] + scrollThumb.AbsoluteSize[dir] then
									self:ScrollTo(self.Index + scrollSize)
								end
							end

							thumbPress = false
							thumbFramePress = true
							doTick()
							local thumbFrameTick = tick()
							local releaseEvent
							releaseEvent = user.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									releaseEvent:Disconnect()
									thumbFramePress = false
								end
							end)

							while thumbFramePress do
								if tick() - thumbFrameTick >= 0.3 and checkMouseInGui(scrollThumbFrame) then
									doTick()
								end
								task.wait()
							end
						end
					end)

					newFrame.MouseWheelForward:Connect(function()
						self:ScrollTo(self.Index - self.WheelIncrement)
					end)

					newFrame.MouseWheelBackward:Connect(function()
						self:ScrollTo(self.Index + self.WheelIncrement)
					end)

					self.GuiElems.ScrollThumb = scrollThumb
					self.GuiElems.ScrollThumbFrame = scrollThumbFrame
					self.GuiElems.Button1 = button1
					self.GuiElems.Button2 = button2
					self.GuiElems.MarkerFrame = markerFrame

					return newFrame
				end

				funcs.Update = function(self,nocallback)
					local total = self.TotalSpace
					local visible = self.VisibleSpace
					local index = self.Index
					local button1 = self.GuiElems.Button1
					local button2 = self.GuiElems.Button2

					self.Index = math.clamp(self.Index, 0, math.max(0, total - visible))

					if self.LastTotalSpace ~= self.TotalSpace then
						self.LastTotalSpace = self.TotalSpace
						self:UpdateMarkers()
					end

					if self:CanScrollUp() then
						for i,v in pairs(button1.Arrow:GetChildren()) do
							v.BackgroundTransparency = 0
						end
					else
						button1.BackgroundTransparency = 1
						for i,v in pairs(button1.Arrow:GetChildren()) do
							v.BackgroundTransparency = 0.5
						end
					end
					if self:CanScrollDown() then
						for i,v in pairs(button2.Arrow:GetChildren()) do
							v.BackgroundTransparency = 0
						end
					else
						button2.BackgroundTransparency = 1
						for i,v in pairs(button2.Arrow:GetChildren()) do
							v.BackgroundTransparency = 0.5
						end
					end

					drawThumb(self)
				end

				funcs.UpdateMarkers = function(self)
					local markerFrame = self.GuiElems.MarkerFrame
					markerFrame:ClearAllChildren()

					for i,v in pairs(self.Markers) do
						if i < self.TotalSpace then
							createSimple("Frame", {
								BackgroundTransparency = 0,
								BackgroundColor3 = v,
								BorderSizePixel = 0,
								Position = self.Horizontal and UDim2.new(i/self.TotalSpace,0,1,-6) or UDim2.new(1,-6,i/self.TotalSpace,0),
								Size = self.Horizontal and UDim2.new(0,1,0,6) or UDim2.new(0,6,0,1),
								Name = "Marker"..tostring(i),
								Parent = markerFrame
							})
						end
					end
				end

				funcs.AddMarker = function(self,ind,color)
					self.Markers[ind] = color or Color3.new(0,0,0)
				end
				funcs.ScrollTo = function(self, ind, nocallback)
					self.Index = ind
					self:Update()
					if not nocallback then
						self.Scrolled:Fire()
					end
				end
				funcs.ScrollUp = function(self)
					self.Index = self.Index - self.Increment
					self:Update()
				end
				funcs.CanScroll = function(self, direction)
					if direction == "Up" then
						return self:CanScrollUp()
					elseif direction == "Down" then
						return self:CanScrollDown()
					end
					return false
				end
				funcs.ScrollDown = function(self)
					self.Index = self.Index + self.Increment
					self:Update()
				end
				funcs.CanScrollUp = function(self)
					return self.Index > 0
				end
				funcs.CanScrollDown = function(self)
					return self.Index + self.VisibleSpace < self.TotalSpace
				end
				funcs.GetScrollPercent = function(self)
					return self.Index/(self.TotalSpace-self.VisibleSpace)
				end
				funcs.SetScrollPercent = function(self,perc)
					self.Index = math.floor(perc*(self.TotalSpace-self.VisibleSpace))
					self:Update()
				end
				funcs.ScrollToDirection = function(self, Direaction)
					if Direaction == "Up" then
						self:ScrollUp()
					elseif Direaction == "Down" then
						self:ScrollDown()
					end
				end

				funcs.Texture = function(self,data)
					self.ThumbColor = data.ThumbColor or Color3.new(0,0,0)
					self.ThumbSelectColor = data.ThumbSelectColor or Color3.new(0,0,0)
					self.GuiElems.ScrollThumb.BackgroundColor3 = data.ThumbColor or Color3.new(0,0,0)
					self.Gui.BackgroundColor3 = data.FrameColor or Color3.new(0,0,0)
					self.GuiElems.Button1.BackgroundColor3 = data.ButtonColor or Color3.new(0,0,0)
					self.GuiElems.Button2.BackgroundColor3 = data.ButtonColor or Color3.new(0,0,0)
					for i,v in pairs(self.GuiElems.Button1.Arrow:GetChildren()) do
						v.BackgroundColor3 = data.ArrowColor or Color3.new(0,0,0)
					end
					for i,v in pairs(self.GuiElems.Button2.Arrow:GetChildren()) do
						v.BackgroundColor3 = data.ArrowColor or Color3.new(0,0,0)
					end
				end

				funcs.SetScrollFrame = function(self,frame)
					if self.ScrollUpEvent then self.ScrollUpEvent:Disconnect() self.ScrollUpEvent = nil end
					if self.ScrollDownEvent then self.ScrollDownEvent:Disconnect() self.ScrollDownEvent = nil end
					self.ScrollUpEvent = frame.MouseWheelForward:Connect(function() self:ScrollTo(self.Index - self.WheelIncrement) end)
					self.ScrollDownEvent = frame.MouseWheelBackward:Connect(function() self:ScrollTo(self.Index + self.WheelIncrement) end)
				end

				local mt = {}
				mt.__index = funcs

				local function new(hor)
					local obj = setmetatable({
						Index = 0,
						VisibleSpace = 0,
						TotalSpace = 0,
						Increment = 1,
						WheelIncrement = 1,
						Markers = {},
						GuiElems = {},
						Horizontal = hor,
						LastTotalSpace = 0,
						Scrolled = Lib.Signal.new()
					},mt)
					obj.Gui = createFrame(obj)
					obj:Texture({
						ThumbColor = Color3.fromRGB(60,60,60),
						ThumbSelectColor = Color3.fromRGB(75,75,75),
						ArrowColor = Color3.new(1,1,1),
						FrameColor = Color3.fromRGB(40,40,40),
						ButtonColor = Color3.fromRGB(75,75,75)
					})
					return obj
				end

				return {new = new}
			end)()

			Lib.Window = (function()
				local funcs = {}
				local static = {MinWidth = 200, FreeWidth = 200}
				local mouse = plr:GetMouse()
				local sidesGui, alignIndicator
				local visibleWindows = {}
				local leftSide = {Width = 300, Windows = {}, ResizeCons = {}, Hidden = true}
				local rightSide = {Width = 300, Windows = {}, ResizeCons = {}, Hidden = true}

				local displayOrderStart
				local sideDisplayOrder
				local sideTweenInfo = TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
				local tweens = {}
				local isA = game.IsA

				local theme = {
					MainColor1 = Color3.fromRGB(52,52,52),
					MainColor2 = Color3.fromRGB(45,45,45),
					Button = Color3.fromRGB(60,60,60)
				}

				local function stopTweens()
					for i = 1,#tweens do
						tweens[i]:Cancel()
					end
					tweens = {}
				end

				local function resizeHook(self,resizer,dir)
					local guiMain = self.GuiElems.Main
					resizer.InputBegan:Connect(function(input)
						if not self.Dragging and not self.Resizing and self.Resizable and self.ResizableInternal then
							local isH = dir:find("[WE]") and true
							local isV = dir:find("[NS]") and true
							local signX = dir:find("W",1,true) and -1 or 1
							local signY = dir:find("N",1,true) and -1 or 1

							if self.Minimized and isV then return end

							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								resizer.BackgroundTransparency = 0.5
							elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								local releaseEvent, mouseEvent

								local offX = input.Position.X - resizer.AbsolutePosition.X
								local offY = input.Position.Y - resizer.AbsolutePosition.Y

								self.Resizing = resizer
								resizer.BackgroundTransparency = 1

								releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										releaseEvent:Disconnect()
										if mouseEvent then mouseEvent:Disconnect() end
										self.Resizing = false
										resizer.BackgroundTransparency = 1
									end
								end)

								mouseEvent = service.UserInputService.InputChanged:Connect(function(input)
									if self.Resizable and self.ResizableInternal and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
										self:StopTweens()
										local deltaX = input.Position.X - resizer.AbsolutePosition.X - offX
										local deltaY = input.Position.Y - resizer.AbsolutePosition.Y - offY

										if guiMain.AbsoluteSize.X + deltaX * signX < self.MinX then deltaX = signX * (self.MinX - guiMain.AbsoluteSize.X) end
										if guiMain.AbsoluteSize.Y + deltaY * signY < self.MinY then deltaY = signY * (self.MinY - guiMain.AbsoluteSize.Y) end
										if signY < 0 and guiMain.AbsolutePosition.Y + deltaY < 0 then deltaY = -guiMain.AbsolutePosition.Y end

										guiMain.Position = guiMain.Position + UDim2.new(0, (signX < 0 and deltaX or 0), 0, (signY < 0 and deltaY or 0))
										self.SizeX = self.SizeX + (isH and deltaX * signX or 0)
										self.SizeY = self.SizeY + (isV and deltaY * signY or 0)
										guiMain.Size = UDim2.new(0, self.SizeX, 0, self.Minimized and 20 or self.SizeY)
									end
								end)
							end
						end
					end)

					resizer.InputEnded:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and self.Resizing ~= resizer then
							resizer.BackgroundTransparency = 1
						end
					end)
				end

				local updateWindows

				local function moveToTop(window)
					local found = table.find(visibleWindows,window)
					if found then
						table.remove(visibleWindows,found)
						table.insert(visibleWindows,1,window)
						updateWindows()
					end
				end

				local function sideHasRoom(side,neededSize)
					local maxY = sidesGui.AbsoluteSize.Y - (math.max(0,#side.Windows - 1) * 4)
					local inc = 0
					for i,v in pairs(side.Windows) do
						inc = inc + (v.MinY or 100)
						if inc > maxY - neededSize then return false end
					end

					return true
				end

				local function getSideInsertPos(side,curY)
					local pos = #side.Windows + 1
					local range = {0,sidesGui.AbsoluteSize.Y}

					for i,v in pairs(side.Windows) do
						local midPos = v.PosY + v.SizeY/2
						if curY <= midPos then
							pos = i
							range[2] = midPos
							break
						else
							range[1] = midPos
						end
					end

					return pos,range
				end

				local function focusInput(self,obj)
					if isA(obj,"GuiButton") then
						obj.MouseButton1Down:Connect(function()
							moveToTop(self)
						end)
					elseif isA(obj,"TextBox") then
						obj.Focused:Connect(function()
							moveToTop(self)
						end)
					end
				end

				local createGui = function(self)
					local gui = create({
						{1,"ScreenGui",{Name="Window",}},
						{2,"Frame",{Active=true,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="Main",Parent={1},Position=UDim2.new(0.40000000596046,0,0.40000000596046,0),Size=UDim2.new(0,300,0,300),}},
						{3,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,Name="Content",Parent={2},Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,1,-20),ClipsDescendants=true}},
						{4,"Frame",{BackgroundColor3=Color3.fromRGB(33,33,33),BorderSizePixel=0,Name="Line",Parent={3},Size=UDim2.new(1,0,0,1),}},
						{5,"TextButton",{Text="",AutoButtonColor=false,BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="TopBar",Parent={2},Size=UDim2.new(1,0,0,20),}},
						{6,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={5},Position=UDim2.new(0,5,0,0),Size=UDim2.new(1,-10,0,20),Text="Window",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,}},
						{7,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Close",Parent={5},Position=UDim2.new(1,-18,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
						{8,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5054663650",Parent={7},Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,10,0,10),}},
						{9,"UICorner",{CornerRadius=UDim.new(0,4),Parent={7},}},
						{10,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Minimize",Parent={5},Position=UDim2.new(1,-36,0,2),Size=UDim2.new(0,16,0,16),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
						{11,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://5034768003",Parent={10},Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,10,0,10),}},
						{12,"UICorner",{CornerRadius=UDim.new(0,4),Parent={10},}},
						{13,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxassetid://1427967925",Name="Outlines",Parent={2},Position=UDim2.new(0,-5,0,-5),ScaleType=1,Size=UDim2.new(1,10,1,10),SliceCenter=Rect.new(6,6,25,25),TileSize=UDim2.new(0,20,0,20),}},
						{14,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="ResizeControls",Parent={2},Position=UDim2.new(0,-5,0,-5),Size=UDim2.new(1,10,1,10),}},
						{15,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="North",Parent={14},Position=UDim2.new(0,5,0,0),Size=UDim2.new(1,-10,0,5),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{16,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="South",Parent={14},Position=UDim2.new(0,5,1,-5),Size=UDim2.new(1,-10,0,5),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{17,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="NorthEast",Parent={14},Position=UDim2.new(1,-5,0,0),Size=UDim2.new(0,5,0,5),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{18,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="East",Parent={14},Position=UDim2.new(1,-5,0,5),Size=UDim2.new(0,5,1,-10),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{19,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="West",Parent={14},Position=UDim2.new(0,0,0,5),Size=UDim2.new(0,5,1,-10),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{20,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="SouthEast",Parent={14},Position=UDim2.new(1,-5,1,-5),Size=UDim2.new(0,5,0,5),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{21,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="NorthWest",Parent={14},Size=UDim2.new(0,5,0,5),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{22,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.27450981736183,0.27450981736183,0.27450981736183),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="SouthWest",Parent={14},Position=UDim2.new(0,0,1,-5),Size=UDim2.new(0,5,0,5),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
					})

					local guiMain = gui.Main
					local guiTopBar = guiMain.TopBar
					local guiResizeControls = guiMain.ResizeControls

					self.GuiElems.Main = guiMain
					self.GuiElems.TopBar = guiMain.TopBar
					self.GuiElems.Content = guiMain.Content
					self.GuiElems.Line = guiMain.Content.Line
					self.GuiElems.Outlines = guiMain.Outlines
					self.GuiElems.Title = guiTopBar.Title
					self.GuiElems.Close = guiTopBar.Close
					self.GuiElems.Minimize = guiTopBar.Minimize
					self.GuiElems.ResizeControls = guiResizeControls
					self.ContentPane = guiMain.Content

					local ButtonDown = false
					guiTopBar.MouseButton1Down:Connect(function() ButtonDown = true end)
					guiTopBar.MouseButton1Up:Connect(function() ButtonDown = false end)

					guiTopBar.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							if self.Draggable then
								local releaseEvent, mouseEvent

								local maxX = sidesGui.AbsoluteSize.X
								local initX = guiMain.AbsolutePosition.X
								local initY = guiMain.AbsolutePosition.Y
								local offX = input.Position.X - initX
								local offY = input.Position.Y - initY

								local alignInsertPos, alignInsertSide

								guiDragging = true

								releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										releaseEvent:Disconnect()
										if mouseEvent then mouseEvent:Disconnect() end
										guiDragging = false
										alignIndicator.Parent = nil
										if alignInsertSide then
											local targetSide = (alignInsertSide == "left" and leftSide) or (alignInsertSide == "right" and rightSide)
											self:AlignTo(targetSide, alignInsertPos)
										end
									end
								end)

								mouseEvent = service.UserInputService.InputChanged:Connect(function(input)
									if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and self.Draggable and not self.Closed and ButtonDown then
										if self.Aligned then
											if leftSide.Resizing or rightSide.Resizing then return end
											local posX, posY = input.Position.X - offX, input.Position.Y - offY
											local delta = math.sqrt((posX - initX)^2 + (posY - initY)^2)
											if delta >= 5 then
												self:SetAligned(false)
											end
										else
											local inputX, inputY = input.Position.X, input.Position.Y
											local posX, posY = inputX - offX, inputY - offY
											if posY < 0 then posY = 0 end
											guiMain.Position = UDim2.new(0, posX, 0, posY)

											if self.Resizable and self.Alignable then
												if inputX < 25 then
													if sideHasRoom(leftSide, self.MinY or 100) then
														local insertPos, range = getSideInsertPos(leftSide, inputY)
														alignIndicator.Indicator.Position = UDim2.new(0, -15, 0, range[1])
														alignIndicator.Indicator.Size = UDim2.new(0, 40, 0, range[2] - range[1])
														Lib.ShowGui(alignIndicator)
														alignInsertPos = insertPos
														alignInsertSide = "left"
														return
													end
												elseif inputX >= maxX - 25 then
													if sideHasRoom(rightSide, self.MinY or 100) then
														local insertPos, range = getSideInsertPos(rightSide, inputY)
														alignIndicator.Indicator.Position = UDim2.new(0, maxX - 25, 0, range[1])
														alignIndicator.Indicator.Size = UDim2.new(0, 40, 0, range[2] - range[1])
														Lib.ShowGui(alignIndicator)
														alignInsertPos = insertPos
														alignInsertSide = "right"
														return
													end
												end
											end
											alignIndicator.Parent = nil
											alignInsertPos = nil
											alignInsertSide = nil
										end
									end
								end)
							end
						end
					end)

					guiTopBar.Close.MouseButton1Click:Connect(function()
						if self.Closed then return end
						self:Close()
					end)

					guiTopBar.Minimize.MouseButton1Click:Connect(function()
						if self.Closed then return end
						if self.Aligned then
							self:SetAligned(false)
						else
							self:SetMinimized()
						end
					end)

					guiTopBar.Minimize.MouseButton2Click:Connect(function()
						if self.Closed then return end
						if not self.Aligned then
							self:SetMinimized(nil,2)
							guiTopBar.Minimize.BackgroundTransparency = 1
						end
					end)

					guiMain.InputBegan:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not self.Aligned and not self.Closed then
							moveToTop(self)
						end
					end)

					guiMain:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
						local absPos = guiMain.AbsolutePosition
						self.PosX = absPos.X
						self.PosY = absPos.Y
					end)

					resizeHook(self,guiResizeControls.North,"N")
					resizeHook(self,guiResizeControls.NorthEast,"NE")
					resizeHook(self,guiResizeControls.East,"E")
					resizeHook(self,guiResizeControls.SouthEast,"SE")
					resizeHook(self,guiResizeControls.South,"S")
					resizeHook(self,guiResizeControls.SouthWest,"SW")
					resizeHook(self,guiResizeControls.West,"W")
					resizeHook(self,guiResizeControls.NorthWest,"NW")

					guiMain.Size = UDim2.new(0,self.SizeX,0,self.SizeY)

					gui.DescendantAdded:Connect(function(obj) focusInput(self,obj) end)
					local descs = gui:GetDescendants()
					for i = 1,#descs do
						focusInput(self,descs[i])
					end

					self.MinimizeAnim = Lib.ButtonAnim(guiTopBar.Minimize)
					self.CloseAnim = Lib.ButtonAnim(guiTopBar.Close)

					return gui
				end

				local function updateSideFrames(noTween)
					stopTweens()
					leftSide.Frame.Size = UDim2.new(0,leftSide.Width,1,0)
					rightSide.Frame.Size = UDim2.new(0,rightSide.Width,1,0)
					leftSide.Frame.Resizer.Position = UDim2.new(0,leftSide.Width,0,0)
					rightSide.Frame.Resizer.Position = UDim2.new(0,-5,0,0)

					--leftSide.Frame.Visible = (#leftSide.Windows > 0)
					--rightSide.Frame.Visible = (#rightSide.Windows > 0)

			--[[if #leftSide.Windows > 0 and leftSide.Frame.Position == UDim2.new(0,-leftSide.Width-5,0,0) then
				leftSide.Frame:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3,true)
			elseif #leftSide.Windows == 0 and leftSide.Frame.Position == UDim2.new(0,0,0,0) then
				leftSide.Frame:TweenPosition(UDim2.new(0,-leftSide.Width-5,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3,true)
			end
			local rightTweenPos = (#rightSide.Windows == 0 and UDim2.new(1,5,0,0) or UDim2.new(1,-rightSide.Width,0,0))
			rightSide.Frame:TweenPosition(rightTweenPos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3,true)]]
					local leftHidden = #leftSide.Windows == 0 or leftSide.Hidden
					local rightHidden = #rightSide.Windows == 0 or rightSide.Hidden
					local leftPos = (leftHidden and UDim2.new(0,-leftSide.Width-10,0,0) or UDim2.new(0,0,0,0))
					local rightPos = (rightHidden and UDim2.new(1,10,0,0) or UDim2.new(1,-rightSide.Width,0,0))

					sidesGui.LeftToggle.Text = leftHidden and ">" or "<"
					sidesGui.RightToggle.Text = rightHidden and "<" or ">"

					if not noTween then
						local function insertTween(...)
							local tween = service.TweenService:Create(...)
							tweens[#tweens+1] = tween
							tween:Play()
						end
						insertTween(leftSide.Frame,sideTweenInfo,{Position = leftPos})
						insertTween(rightSide.Frame,sideTweenInfo,{Position = rightPos})
						insertTween(sidesGui.LeftToggle,sideTweenInfo,{Position = UDim2.new(0,#leftSide.Windows == 0 and -16 or 0,0,-36)})
						insertTween(sidesGui.RightToggle,sideTweenInfo,{Position = UDim2.new(1,#rightSide.Windows == 0 and 0 or -16,0,-36)})
					else
						leftSide.Frame.Position = leftPos
						rightSide.Frame.Position = rightPos
						sidesGui.LeftToggle.Position = UDim2.new(0,#leftSide.Windows == 0 and -16 or 0,0,-36)
						sidesGui.RightToggle.Position = UDim2.new(1,#rightSide.Windows == 0 and 0 or -16,0,-36)
					end
				end

				local function getSideFramePos(side)
					local leftHidden = #leftSide.Windows == 0 or leftSide.Hidden
					local rightHidden = #rightSide.Windows == 0 or rightSide.Hidden
					if side == leftSide then
						return (leftHidden and UDim2.new(0,-leftSide.Width-10,0,0) or UDim2.new(0,0,0,0))
					else
						return (rightHidden and UDim2.new(1,10,0,0) or UDim2.new(1,-rightSide.Width,0,0))
					end
				end

				local function sideResized(side)
					local currentPos = 0
					local sideFramePos = getSideFramePos(side)
					for i,v in pairs(side.Windows) do
						v.SizeX = side.Width
						v.GuiElems.Main.Size = UDim2.new(0,side.Width,0,v.SizeY)
						v.GuiElems.Main.Position = UDim2.new(sideFramePos.X.Scale,sideFramePos.X.Offset,0,currentPos)
						currentPos = currentPos + v.SizeY+4
					end
				end

				local function sideResizerHook(resizer,dir,side,pos)
					local mouse = Main.Mouse
					local windows = side.Windows

					resizer.InputBegan:Connect(function(input)
						if not side.Resizing then
							if input.UserInputType == Enum.UserInputType.MouseMovement then
								resizer.BackgroundColor3 = theme.MainColor2
							elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								local releaseEvent, inputEvent

								local offX = input.Position.X - resizer.AbsolutePosition.X
								local offY = input.Position.Y - resizer.AbsolutePosition.Y

								side.Resizing = resizer
								resizer.BackgroundColor3 = theme.MainColor2

								releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										releaseEvent:Disconnect()
										if inputEvent then inputEvent:Disconnect() end
										side.Resizing = false
										resizer.BackgroundColor3 = theme.Button
									end
								end)

								inputEvent = service.UserInputService.InputChanged:Connect(function(input)
									if not resizer.Parent then
										releaseEvent:Disconnect()
										if inputEvent then inputEvent:Disconnect() end
										side.Resizing = false
										return
									end

									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										if dir == "V" then
											local delta = input.Position.Y - resizer.AbsolutePosition.Y - offY

											if delta > 0 then
												local neededSize = delta
												for i = pos + 1, #windows do
													local window = windows[i]
													local newSize = math.max(window.SizeY - neededSize, (window.MinY or 100))
													neededSize = neededSize - (window.SizeY - newSize)
													window.SizeY = newSize
												end
												windows[pos].SizeY = windows[pos].SizeY + math.max(0, delta - neededSize)
											else
												local neededSize = -delta
												for i = pos, 1, -1 do
													local window = windows[i]
													local newSize = math.max(window.SizeY - neededSize, (window.MinY or 100))
													neededSize = neededSize - (window.SizeY - newSize)
													window.SizeY = newSize
												end
												windows[pos + 1].SizeY = windows[pos + 1].SizeY + math.max(0, -delta - neededSize)
											end

											updateSideFrames()
											sideResized(side)
										elseif dir == "H" then
											local maxWidth = math.max(300, sidesGui.AbsoluteSize.X - static.FreeWidth)
											local otherSide = (side == leftSide and rightSide or leftSide)
											local delta = input.Position.X - resizer.AbsolutePosition.X - offX
											delta = (side == leftSide and delta or -delta)

											local proposedSize = math.max(static.MinWidth, side.Width + delta)
											if proposedSize + otherSide.Width <= maxWidth then
												side.Width = proposedSize
											else
												local newOtherSize = maxWidth - proposedSize
												if newOtherSize >= static.MinWidth then
													side.Width = proposedSize
													otherSide.Width = newOtherSize
												else
													side.Width = maxWidth - static.MinWidth
													otherSide.Width = static.MinWidth
												end
											end

											updateSideFrames(true)
											sideResized(side)
											sideResized(otherSide)
										end
									end
								end)
							end
						end
					end)

					resizer.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							if side.Resizing ~= resizer then
								resizer.BackgroundColor3 = theme.Button
							end
						end
					end)

				end

				local function renderSide(side,noTween) -- TODO: Use existing resizers
					local currentPos = 0
					local sideFramePos = getSideFramePos(side)
					local template = side.WindowResizer:Clone()
					for i,v in pairs(side.ResizeCons) do v:Disconnect() end
					for i,v in pairs(side.Frame:GetChildren()) do if v.Name == "WindowResizer" then v:Destroy() end end
					side.ResizeCons = {}
					side.Resizing = nil

					for i,v in pairs(side.Windows) do
						v.SidePos = i
						local isEnd = i == #side.Windows
						local size = UDim2.new(0,side.Width,0,v.SizeY)
						local pos = UDim2.new(sideFramePos.X.Scale,sideFramePos.X.Offset,0,currentPos)
						Lib.ShowGui(v.Gui)
						--v.GuiElems.Main:TweenSizeAndPosition(size,pos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3,true)
						if noTween then
							v.GuiElems.Main.Size = size
							v.GuiElems.Main.Position = pos
						else
							local tween = service.TweenService:Create(v.GuiElems.Main,sideTweenInfo,{Size = size, Position = pos})
							tweens[#tweens+1] = tween
							tween:Play()
						end
						currentPos = currentPos + v.SizeY+4

						if not isEnd then
							local newTemplate = template:Clone()
							newTemplate.Position = UDim2.new(1,-side.Width,0,currentPos-4)
							side.ResizeCons[#side.ResizeCons+1] = v.Gui.Main:GetPropertyChangedSignal("Size"):Connect(function()
								newTemplate.Position = UDim2.new(1,-side.Width,0, v.GuiElems.Main.Position.Y.Offset + v.GuiElems.Main.Size.Y.Offset)
							end)
							side.ResizeCons[#side.ResizeCons+1] = v.Gui.Main:GetPropertyChangedSignal("Position"):Connect(function()
								newTemplate.Position = UDim2.new(1,-side.Width,0, v.GuiElems.Main.Position.Y.Offset + v.GuiElems.Main.Size.Y.Offset)
							end)
							sideResizerHook(newTemplate,"V",side,i)
							newTemplate.Parent = side.Frame
						end
					end

					--side.Frame.Back.Position = UDim2.new(0,0,0,0)
					--side.Frame.Back.Size = UDim2.new(0,side.Width,1,0)
				end

				local function updateSide(side,noTween)
					local oldHeight = 0
					local currentPos = 0
					local neededSize = 0
					local windows = side.Windows
					local height = sidesGui.AbsoluteSize.Y - (math.max(0,#windows - 1) * 4)

					for i,v in pairs(windows) do oldHeight = oldHeight + v.SizeY end
					for i,v in pairs(windows) do
						if i == #windows then
							v.SizeY = height-currentPos
							neededSize = math.max(0,(v.MinY or 100)-v.SizeY)
						else
							v.SizeY = math.max(math.floor(v.SizeY/oldHeight*height),v.MinY or 100)
						end
						currentPos = currentPos + v.SizeY
					end

					if neededSize > 0 then
						for i = #windows-1,1,-1 do
							local window = windows[i]
							local newSize = math.max(window.SizeY-neededSize,(window.MinY or 100))
							neededSize = neededSize - (window.SizeY - newSize)
							window.SizeY = newSize
						end
						local lastWindow = windows[#windows]
						lastWindow.SizeY = (lastWindow.MinY or 100)-neededSize
					end
					renderSide(side,noTween)
				end

				updateWindows = function(noTween)
					updateSideFrames(noTween)
					updateSide(leftSide,noTween)
					updateSide(rightSide,noTween)
					local count = 0
					for i = #visibleWindows,1,-1 do
						visibleWindows[i].Gui.DisplayOrder = displayOrderStart + count
						Lib.ShowGui(visibleWindows[i].Gui)
						count = count + 1
					end

			--[[local leftTweenPos = (#leftSide.Windows == 0 and UDim2.new(0,-leftSide.Width-5,0,0) or UDim2.new(0,0,0,0))
			leftSide.Frame:TweenPosition(leftTweenPos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3,true)
			local rightTweenPos = (#rightSide.Windows == 0 and UDim2.new(1,5,0,0) or UDim2.new(1,-rightSide.Width,0,0))
			rightSide.Frame:TweenPosition(rightTweenPos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3,true)]]
				end

				funcs.SetMinimized = function(self,set,mode)
					local oldVal = self.Minimized
					local newVal
					if set == nil then newVal = not self.Minimized else newVal = set end
					self.Minimized = newVal
					if not mode then mode = 1 end

					local resizeControls = self.GuiElems.ResizeControls
					local minimizeControls = {"North","NorthEast","NorthWest","South","SouthEast","SouthWest"}
					for i = 1,#minimizeControls do
						local control = resizeControls:FindFirstChild(minimizeControls[i])
						if control then control.Visible = not newVal end
					end

					if mode == 1 or mode == 2 then
						self:StopTweens()
						if mode == 1 then
							self.GuiElems.Main:TweenSize(UDim2.new(0,self.SizeX,0,newVal and 20 or self.SizeY),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
						else
							local maxY = sidesGui.AbsoluteSize.Y
							local newPos = UDim2.new(0,self.PosX,0,newVal and math.min(maxY-20,self.PosY + self.SizeY - 20) or math.max(0,self.PosY - self.SizeY + 20))

							self.GuiElems.Main:TweenPosition(newPos,Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
							self.GuiElems.Main:TweenSize(UDim2.new(0,self.SizeX,0,newVal and 20 or self.SizeY),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
						end
						self.GuiElems.Minimize.ImageLabel.Image = newVal and "rbxassetid://5060023708" or "rbxassetid://5034768003"
					end

					if oldVal ~= newVal then
						if newVal then
							self.OnMinimize:Fire()
						else
							self.OnRestore:Fire()
						end
					end
				end

				funcs.Resize = function(self,sizeX,sizeY)
					self.SizeX = sizeX or self.SizeX
					self.SizeY = sizeY or self.SizeY
					self.GuiElems.Main.Size = UDim2.new(0,self.SizeX,0,self.SizeY)
				end

				funcs.SetSize = funcs.Resize

				funcs.SetTitle = function(self,title)
					self.GuiElems.Title.Text = title
				end

				funcs.SetResizable = function(self,val)
					self.Resizable = val
					self.GuiElems.ResizeControls.Visible = self.Resizable and self.ResizableInternal
				end

				funcs.SetResizableInternal = function(self,val)
					self.ResizableInternal = val
					self.GuiElems.ResizeControls.Visible = self.Resizable and self.ResizableInternal
				end

				funcs.SetAligned = function(self,val)
					self.Aligned = val
					self:SetResizableInternal(not val)
					self.GuiElems.Main.Active = not val
					self.GuiElems.Main.Outlines.Visible = not val
					if not val then
						for i,v in pairs(leftSide.Windows) do if v == self then table.remove(leftSide.Windows,i) break end end
						for i,v in pairs(rightSide.Windows) do if v == self then table.remove(rightSide.Windows,i) break end end
						if not table.find(visibleWindows,self) then table.insert(visibleWindows,1,self) end
						self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5034768003"
						self.Side = nil
						updateWindows()
					else
						self:SetMinimized(false,3)
						for i,v in pairs(visibleWindows) do if v == self then table.remove(visibleWindows,i) break end end
						self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5448127505"
					end
				end

				funcs.Add = function(self,obj,name)
					if type(obj) == "table" and obj.Gui and obj.Gui:IsA("GuiObject") then
						obj.Gui.Parent = self.ContentPane
					else
						obj.Parent = self.ContentPane
					end
					if name then self.Elements[name] = obj end
				end

				funcs.GetElement = function(self,obj,name)
					return self.Elements[name]
				end

				funcs.AlignTo = function(self,side,pos,size,silent)
					if table.find(side.Windows,self) or self.Closed then return end

					size = size or self.SizeY
					if size > 0 and size <= 1 then
						local totalSideHeight = 0
						for i,v in pairs(side.Windows) do totalSideHeight = totalSideHeight + v.SizeY end
						self.SizeY = (totalSideHeight > 0 and totalSideHeight * size * 2) or size
					else
						self.SizeY = (size > 0 and size or 100)
					end

					self:SetAligned(true)
					self.Side = side
					self.SizeX = side.Width
					self.Gui.DisplayOrder = sideDisplayOrder + 1
					for i,v in pairs(side.Windows) do v.Gui.DisplayOrder = sideDisplayOrder end
					pos = math.min(#side.Windows+1, pos or 1)
					self.SidePos = pos
					table.insert(side.Windows, pos, self)

					if not silent then
						side.Hidden = false
					end
					-- updateWindows(silent)
				end

				funcs.Close = function(self)
					self.Closed = true
					self:SetResizableInternal(false)

					Lib.FindAndRemove(leftSide.Windows,self)
					Lib.FindAndRemove(rightSide.Windows,self)
					Lib.FindAndRemove(visibleWindows,self)

					self.MinimizeAnim.Disable()
					self.CloseAnim.Disable()
					self.ClosedSide = self.Side
					self.Side = nil
					self.OnDeactivate:Fire()

					if not self.Aligned then
						self:StopTweens()
						local ti = TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

						local closeTime = tick()
						self.LastClose = closeTime

						self:DoTween(self.GuiElems.Main,ti,{Size = UDim2.new(0,self.SizeX,0,20)})
						self:DoTween(self.GuiElems.Title,ti,{TextTransparency = 1})
						self:DoTween(self.GuiElems.Minimize.ImageLabel,ti,{ImageTransparency = 1})
						self:DoTween(self.GuiElems.Close.ImageLabel,ti,{ImageTransparency = 1})
						Lib.FastWait(0.2)
						if closeTime ~= self.LastClose then return end

						self:DoTween(self.GuiElems.TopBar,ti,{BackgroundTransparency = 1})
						self:DoTween(self.GuiElems.Outlines,ti,{ImageTransparency = 1})
						Lib.FastWait(0.2)
						if closeTime ~= self.LastClose then return end
					end

					self.Aligned = false
					self.Gui.Parent = nil
					updateWindows(true)
				end

				funcs.Hide = funcs.Close

				funcs.IsVisible = function(self)
					return not self.Closed and ((self.Side and not self.Side.Hidden) or not self.Side)
				end

				funcs.IsContentVisible = function(self)
					return self:IsVisible() and not self.Minimized
				end

				funcs.Focus = function(self)
					moveToTop(self)
				end

				funcs.MoveInBoundary = function(self)
					local posX,posY = self.PosX,self.PosY
					local maxX,maxY = sidesGui.AbsoluteSize.X,sidesGui.AbsoluteSize.Y
					posX = math.min(posX,maxX-self.SizeX)
					posY = math.min(posY,maxY-20)
					self.GuiElems.Main.Position = UDim2.new(0,posX,0,posY)
				end

				funcs.DoTween = function(self,...)
					local tween = service.TweenService:Create(...)
					self.Tweens[#self.Tweens+1] = tween
					tween:Play()
				end

				funcs.StopTweens = function(self)
					for i,v in pairs(self.Tweens) do
						v:Cancel()
					end
					self.Tweens = {}
				end

				funcs.Show = function(self,data)
					return static.ShowWindow(self,data)
				end

				funcs.ShowAndFocus = function(self,data)
					static.ShowWindow(self,data)
					service.RunService.RenderStepped:wait()
					self:Focus()
				end

				static.ShowWindow = function(window,data)
					data = data or {}
					local align = data.Align
					local pos = data.Pos
					local size = data.Size
					local targetSide = (align == "left" and leftSide) or (align == "right" and rightSide)

					if not window.Closed then
						if not window.Aligned then
							window:SetMinimized(false)
						elseif window.Side and not data.Silent then
							static.SetSideVisible(window.Side,true)
						end
						return
					end

					window.Closed = false
					window.LastClose = tick()
					window.GuiElems.Title.TextTransparency = 0
					window.GuiElems.Minimize.ImageLabel.ImageTransparency = 0
					window.GuiElems.Close.ImageLabel.ImageTransparency = 0
					window.GuiElems.TopBar.BackgroundTransparency = 0
					window.GuiElems.Outlines.ImageTransparency = 0
					window.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5034768003"
					window.GuiElems.Main.Active = true
					window.GuiElems.Main.Outlines.Visible = true
					window:SetMinimized(false,3)
					window:SetResizableInternal(true)
					window.MinimizeAnim.Enable()
					window.CloseAnim.Enable()

					if align then
						window:AlignTo(targetSide,pos,size,data.Silent)
					else
						if align == nil and window.ClosedSide then -- Regular open
							window:AlignTo(window.ClosedSide,window.SidePos,size,true)
							static.SetSideVisible(window.ClosedSide,true)
						else
							if table.find(visibleWindows,window) then return end

							-- TODO: make better
							window.GuiElems.Main.Size = UDim2.new(0,window.SizeX,0,20)
							local ti = TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
							window:StopTweens()
							window:DoTween(window.GuiElems.Main,ti,{Size = UDim2.new(0,window.SizeX,0,window.SizeY)})

							window.SizeY = size or window.SizeY
							table.insert(visibleWindows,1,window)
							updateWindows()
						end
					end

					window.ClosedSide = nil
					window.OnActivate:Fire()
				end

				static.ToggleSide = function(name)
					local side = (name == "left" and leftSide or rightSide)
					side.Hidden = not side.Hidden
					for i,v in pairs(side.Windows) do
						if side.Hidden then
							v.OnDeactivate:Fire()
						else
							v.OnActivate:Fire()
						end
					end
					updateWindows()
				end

				static.SetSideVisible = function(s,vis)
					local side = (type(s) == "table" and s) or (s == "left" and leftSide or rightSide)
					side.Hidden = not vis
					for i,v in pairs(side.Windows) do
						if side.Hidden then
							v.OnDeactivate:Fire()
						else
							v.OnActivate:Fire()
						end
					end
					updateWindows()
				end

				static.Init = function()
					displayOrderStart = Main.DisplayOrders.Window
					sideDisplayOrder = Main.DisplayOrders.SideWindow

					sidesGui = Instance.new("ScreenGui")
					local leftFrame = create({
						{1,"Frame",{Active=true,Name="LeftSide",BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,}},
						{2,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2549019753933,0.2549019753933,0.2549019753933),BorderSizePixel=0,Font=3,Name="Resizer",Parent={1},Size=UDim2.new(0,5,1,0),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{3,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderSizePixel=0,Name="Line",Parent={2},Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,1,1,0),}},
						{4,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2549019753933,0.2549019753933,0.2549019753933),BorderSizePixel=0,Font=3,Name="WindowResizer",Parent={1},Position=UDim2.new(1,-300,0,0),Size=UDim2.new(1,0,0,4),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{5,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderSizePixel=0,Name="Line",Parent={4},Size=UDim2.new(1,0,0,1),}},
					})
					leftSide.Frame = leftFrame
					leftFrame.Position = UDim2.new(0,-leftSide.Width-10,0,0)
					leftSide.WindowResizer = leftFrame.WindowResizer
					leftFrame.WindowResizer.Parent = nil
					leftFrame.Parent = sidesGui

					local rightFrame = create({
						{1,"Frame",{Active=true,Name="RightSide",BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,}},
						{2,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2549019753933,0.2549019753933,0.2549019753933),BorderSizePixel=0,Font=3,Name="Resizer",Parent={1},Size=UDim2.new(0,5,1,0),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{3,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderSizePixel=0,Name="Line",Parent={2},Position=UDim2.new(0,4,0,0),Size=UDim2.new(0,1,1,0),}},
						{4,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2549019753933,0.2549019753933,0.2549019753933),BorderSizePixel=0,Font=3,Name="WindowResizer",Parent={1},Position=UDim2.new(1,-300,0,0),Size=UDim2.new(1,0,0,4),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
						{5,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderSizePixel=0,Name="Line",Parent={4},Size=UDim2.new(1,0,0,1),}},
					})
					rightSide.Frame = rightFrame
					rightFrame.Position = UDim2.new(1,10,0,0)
					rightSide.WindowResizer = rightFrame.WindowResizer
					rightFrame.WindowResizer.Parent = nil
					rightFrame.Parent = sidesGui

					sideResizerHook(leftFrame.Resizer,"H",leftSide)
					sideResizerHook(rightFrame.Resizer,"H",rightSide)

					alignIndicator = Instance.new("ScreenGui")
					alignIndicator.DisplayOrder = Main.DisplayOrders.Core
					local indicator = Instance.new("Frame",alignIndicator)
					indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
					indicator.BorderSizePixel = 0
					indicator.BackgroundTransparency = 0.8
					indicator.Name = "Indicator"
					local corner = Instance.new("UICorner",indicator)
					corner.CornerRadius = UDim.new(0,10)

					local leftToggle = create({{1,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderMode=2,Font=10,Name="LeftToggle",Position=UDim2.new(0,0,0,-36),Size=UDim2.new(0,16,0,36),Text="<",TextColor3=Color3.new(1,1,1),TextSize=14,}}})
					local rightToggle = leftToggle:Clone()
					rightToggle.Name = "RightToggle"
					rightToggle.Position = UDim2.new(1,-16,0,-36)
					Lib.ButtonAnim(leftToggle,{Mode = 2,PressColor = Color3.fromRGB(32,32,32)})
					Lib.ButtonAnim(rightToggle,{Mode = 2,PressColor = Color3.fromRGB(32,32,32)})

					leftToggle.MouseButton1Click:Connect(function()
						static.ToggleSide("left")
					end)

					rightToggle.MouseButton1Click:Connect(function()
						static.ToggleSide("right")
					end)

					leftToggle.Parent = sidesGui
					rightToggle.Parent = sidesGui

					sidesGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						local maxWidth = math.max(300,sidesGui.AbsoluteSize.X-static.FreeWidth)
						leftSide.Width = math.max(static.MinWidth,math.min(leftSide.Width,maxWidth-rightSide.Width))
						rightSide.Width = math.max(static.MinWidth,math.min(rightSide.Width,maxWidth-leftSide.Width))
						for i = 1,#visibleWindows do
							visibleWindows[i]:MoveInBoundary()
						end
						updateWindows(true)
					end)

					sidesGui.DisplayOrder = sideDisplayOrder - 1
					Lib.ShowGui(sidesGui)
					updateSideFrames()
				end

				local mt = {__index = funcs}
				static.new = function()
					local obj = setmetatable({
						Minimized = false,
						Dragging = false,
						Resizing = false,
						Aligned = false,
						Draggable = true,
						Resizable = true,
						ResizableInternal = true,
						Alignable = true,
						Closed = true,
						SizeX = 300,
						SizeY = 300,
						MinX = 200,
						MinY = 200,
						PosX = 0,
						PosY = 0,
						GuiElems = {},
						Tweens = {},
						Elements = {},
						OnActivate = Lib.Signal.new(),
						OnDeactivate = Lib.Signal.new(),
						OnMinimize = Lib.Signal.new(),
						OnRestore = Lib.Signal.new()
					},mt)
					obj.Gui = createGui(obj)
					return obj
				end

				return static
			end)()

			Lib.ContextMenu = (function()
				local funcs = {}
				local mouse

				local function createGui(self)
					local contextGui = create({
						{1,"ScreenGui",{DisplayOrder=1000000,Name="Context",ZIndexBehavior=1,}},
						{2,"Frame",{Active=true,BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),Name="Main",Parent={1},Position=UDim2.new(0.5,-100,0.5,-150),Size=UDim2.new(0,200,0,100),}},
						{3,"UICorner",{CornerRadius=UDim.new(0,4),Parent={2},}},
						{4,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),Name="Container",Parent={2},Position=UDim2.new(0,1,0,1),Size=UDim2.new(1,-2,1,-2),}},
						{5,"UICorner",{CornerRadius=UDim.new(0,4),Parent={4},}},
						{6,"ScrollingFrame",{Active=true,BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),Name="List",Parent={4},Position=UDim2.new(0,2,0,2),ScrollBarImageColor3=Color3.new(0,0,0),ScrollBarThickness=4,Size=UDim2.new(1,-4,1,-4),VerticalScrollBarInset=1,}},
						{7,"UIListLayout",{Parent={6},SortOrder=2,}},
						{8,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="SearchFrame",Parent={4},Size=UDim2.new(1,0,0,24),Visible=false,}},
						{9,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.1176470592618,0.1176470592618,0.1176470592618),BorderSizePixel=0,Name="SearchContainer",Parent={8},Position=UDim2.new(0,3,0,3),Size=UDim2.new(1,-6,0,18),}},
						{10,"TextBox",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="SearchBox",Parent={9},PlaceholderColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),PlaceholderText="Search",Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-8,0,18),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=0,}},
						{11,"UICorner",{CornerRadius=UDim.new(0,2),Parent={9},}},
						{12,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderSizePixel=0,Name="Line",Parent={8},Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,1),}},
						{13,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=0,Font=3,Name="Entry",Parent={1},Size=UDim2.new(1,0,0,22),Text="",TextSize=14,Visible=false,}},
						{14,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="EntryName",Parent={13},Position=UDim2.new(0,24,0,0),Size=UDim2.new(1,-24,1,0),Text="Duplicate",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{15,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Shortcut",Parent={13},Position=UDim2.new(0,24,0,0),Size=UDim2.new(1,-30,1,0),Text="Ctrl+D",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{16,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ImageRectOffset=Vector2.new(304,0),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={13},Position=UDim2.new(0,2,0,3),ScaleType=4,Size=UDim2.new(0,16,0,16),}},
						{17,"UICorner",{CornerRadius=UDim.new(0,4),Parent={13},}},
						{18,"Frame",{BackgroundColor3=Color3.new(0.21568629145622,0.21568629145622,0.21568629145622),BackgroundTransparency=1,BorderSizePixel=0,Name="Divider",Parent={1},Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,0,7),Visible=false,}},
						{19,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="Line",Parent={18},Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0,1),}},
						{20,"TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="DividerName",Parent={18},Position=UDim2.new(0,2,0.5,0),Size=UDim2.new(1,-4,1,0),Text="Objects",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=0.60000002384186,TextXAlignment=0,Visible=false,}}
					})

					self.GuiElems.Main = contextGui.Main
					self.GuiElems.List = contextGui.Main.Container.List
					self.GuiElems.Entry = contextGui.Entry
					self.GuiElems.Divider = contextGui.Divider
					self.GuiElems.SearchFrame = contextGui.Main.Container.SearchFrame
					self.GuiElems.SearchBar = self.GuiElems.SearchFrame.SearchContainer.SearchBox
					Lib.ViewportTextBox.convert(self.GuiElems.SearchBar)

					self.GuiElems.SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
						local lower,find = string.lower,string.find
						local searchText = lower(self.GuiElems.SearchBar.Text)
						local items = self.Items
						local map = self.ItemToEntryMap

						if searchText ~= "" then
							local results = {}
							local count = 1
							for i = 1,#items do
								local item = items[i]
								local entry = map[item]
								if entry then
									if not item.Divider and find(lower(item.Name),searchText,1,true) then
										results[count] = item
										count = count + 1
									else
										entry.Visible = false
									end
								end
							end
							table.sort(results,function(a,b) return a.Name < b.Name end)
							for i = 1,#results do
								local entry = map[results[i]]
								entry.LayoutOrder = i
								entry.Visible = true
							end
						else
							for i = 1,#items do
								local entry = map[items[i]]
								if entry then entry.LayoutOrder = i entry.Visible = true end
							end
						end

						local toSize = self.GuiElems.List.UIListLayout.AbsoluteContentSize.Y + 6
						self.GuiElems.List.CanvasSize = UDim2.new(0,0,0,toSize-6)
					end)

					return contextGui
				end

				funcs.Add = function(self,item)
					local newItem = {
						Name = item.Name or "Item",
						Icon = item.Icon or "",
						Shortcut = item.Shortcut or "",
						OnClick = item.OnClick,
						OnHover = item.OnHover,
						Disabled = item.Disabled or false,
						DisabledIcon = item.DisabledIcon or "",
						IconMap = item.IconMap,
						OnRightClick = item.OnRightClick
					}

					if self.QueuedDivider then
						local text = self.QueuedDividerText and #self.QueuedDividerText > 0 and self.QueuedDividerText
						self:AddDivider(text)
					end
					self.Items[#self.Items+1] = newItem
					self.Updated = nil
				end

				funcs.AddRegistered = function(self,name,disabled)
					if not self.Registered[name] then error(name.." is not registered") end

					if self.QueuedDivider then
						local text = self.QueuedDividerText and #self.QueuedDividerText > 0 and self.QueuedDividerText
						self:AddDivider(text)
					end
					self.Registered[name].Disabled = disabled
					self.Items[#self.Items+1] = self.Registered[name]
					self.Updated = nil
				end

				funcs.Register = function(self,name,item)
					self.Registered[name] = {
						Name = item.Name or "Item",
						Icon = item.Icon or "",
						Shortcut = item.Shortcut or "",
						OnClick = item.OnClick,
						OnHover = item.OnHover,
						DisabledIcon = item.DisabledIcon or "",
						IconMap = item.IconMap,
						OnRightClick = item.OnRightClick
					}
				end

				funcs.UnRegister = function(self,name)
					self.Registered[name] = nil
				end

				funcs.AddDivider = function(self,text)
					self.QueuedDivider = false
					local textWidth = text and service.TextService:GetTextSize(text,14,Enum.Font.SourceSans,Vector2.new(999999999,20)).X or nil
					table.insert(self.Items,{Divider = true, Text = text, TextSize = textWidth and textWidth+4})
					self.Updated = nil
				end

				funcs.QueueDivider = function(self,text)
					self.QueuedDivider = true
					self.QueuedDividerText = text or ""
				end

				funcs.Clear = function(self)
					self.Items = {}
					self.Updated = nil
				end

				funcs.Refresh = function(self)
					for i,v in pairs(self.GuiElems.List:GetChildren()) do
						if not v:IsA("UIListLayout") then
							v:Destroy()
						end
					end
					local map = {}
					self.ItemToEntryMap = map

					local dividerFrame = self.GuiElems.Divider
					local contextList = self.GuiElems.List
					local entryFrame = self.GuiElems.Entry
					local items = self.Items

					for i = 1,#items do
						local item = items[i]
						if item.Divider then
							local newDivider = dividerFrame:Clone()
							newDivider.Line.BackgroundColor3 = self.Theme.DividerColor
							if item.Text then
								newDivider.Size = UDim2.new(1,0,0,20)
								newDivider.Line.Position = UDim2.new(0,item.TextSize,0.5,0)
								newDivider.Line.Size = UDim2.new(1,-item.TextSize,0,1)
								newDivider.DividerName.TextColor3 = self.Theme.TextColor
								newDivider.DividerName.Text = item.Text
								newDivider.DividerName.Visible = true
							end
							newDivider.Visible = true
							map[item] = newDivider
							newDivider.Parent = contextList
						else
							local newEntry = entryFrame:Clone()
							newEntry.BackgroundColor3 = self.Theme.HighlightColor
							newEntry.EntryName.TextColor3 = self.Theme.TextColor
							newEntry.EntryName.Text = item.Name
							newEntry.Shortcut.Text = item.Shortcut
							if item.Disabled then
								newEntry.EntryName.TextColor3 = Color3.new(150/255,150/255,150/255)
								newEntry.Shortcut.TextColor3 = Color3.new(150/255,150/255,150/255)
							end

							if self.Iconless then
								newEntry.EntryName.Position = UDim2.new(0,2,0,0)
								newEntry.EntryName.Size = UDim2.new(1,-4,0,20)
								newEntry.Icon.Visible = false
							else
								local iconIndex = item.Disabled and item.DisabledIcon or item.Icon
								-- Explorer.MiscIcons:DisplayExplorerIcons(newEntry.Icon, iconIndex)
								if item.IconMap then
									if type(iconIndex) == "number" then
										item.IconMap:Display(newEntry.Icon, iconIndex)
									elseif type(iconIndex) == "string" then
										item.IconMap:DisplayByKey(newEntry.Icon, iconIndex)
									end
								elseif type(iconIndex) == "string" then
									newEntry.Icon.Image = iconIndex
								end
							end

							if not item.Disabled then
								if item.OnClick then
									newEntry.MouseButton1Click:Connect(function()
										item.OnClick(item.Name)
										if not item.NoHide then
											self:Hide()
										end
									end)
								end

								if item.OnRightClick then
									newEntry.MouseButton2Click:Connect(function()
										item.OnRightClick(item.Name)
										if not item.NoHide then
											self:Hide()
										end
									end)
								end
							end

							newEntry.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
									newEntry.BackgroundTransparency = 0
								end
							end)

							newEntry.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
									newEntry.BackgroundTransparency = 1
								end
							end)

							newEntry.Visible = true
							map[item] = newEntry
							newEntry.Parent = contextList
						end
					end
					self.Updated = true
				end

				funcs.Show = function(self,x,y)
					local elems = self.GuiElems
					elems.SearchFrame.Visible = self.SearchEnabled
					elems.List.Position = UDim2.new(0,2,0,2 + (self.SearchEnabled and 24 or 0))
					elems.List.Size = UDim2.new(1,-4,1,-4 - (self.SearchEnabled and 24 or 0))
					if self.SearchEnabled and self.ClearSearchOnShow then elems.SearchBar.Text = "" end
					self.GuiElems.List.CanvasPosition = Vector2.new(0,0)

					if not self.Updated then
						self:Refresh()
					end

					-- Vars
					local reverseY = false
					local x,y = x or mouse.X, y or mouse.Y
					local maxX,maxY = mouse.ViewSizeX,mouse.ViewSizeY

					-- Position and show
					if x + self.Width > maxX then
						x = self.ReverseX and x - self.Width or maxX - self.Width
					end
					elems.Main.Position = UDim2.new(0,x,0,y)
					elems.Main.Size = UDim2.new(0,self.Width,0,0)
					self.Gui.DisplayOrder = Main.DisplayOrders.Menu
					Lib.ShowGui(self.Gui)

					-- Size adjustment
					local toSize = elems.List.UIListLayout.AbsoluteContentSize.Y + 6 -- Padding
					if self.MaxHeight and toSize > self.MaxHeight then
						elems.List.CanvasSize = UDim2.new(0,0,0,toSize-6)
						toSize = self.MaxHeight
					else
						elems.List.CanvasSize = UDim2.new(0,0,0,0)
					end
					if y + toSize > maxY then reverseY = true end

					-- Close event
					local closable
					if self.CloseEvent then self.CloseEvent:Disconnect() end
					self.CloseEvent = service.UserInputService.InputBegan:Connect(function(input)
						if not closable then return end

						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							if not Lib.CheckMouseInGui(elems.Main) then
								self.CloseEvent:Disconnect()
								self:Hide()
							end
						end
					end)

					-- Resize
					if reverseY then
						elems.Main.Position = UDim2.new(0,x,0,y-(self.ReverseYOffset or 0))
						local newY = y - toSize - (self.ReverseYOffset or 0)
						y = newY >= 0 and newY or 0
						elems.Main:TweenSizeAndPosition(UDim2.new(0,self.Width,0,toSize),UDim2.new(0,x,0,y),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
					else
						elems.Main:TweenSize(UDim2.new(0,self.Width,0,toSize),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
					end

					-- Close debounce
					Lib.FastWait()
					if self.SearchEnabled and self.FocusSearchOnShow then elems.SearchBar:CaptureFocus() end
					closable = true
				end

				funcs.Hide = function(self)
					self.Gui.Parent = nil
				end

				funcs.ApplyTheme = function(self,data)
					local theme = self.Theme
					theme.ContentColor = data.ContentColor or Settings.Theme.Menu
					theme.OutlineColor = data.OutlineColor or Settings.Theme.Menu
					theme.DividerColor = data.DividerColor or Settings.Theme.Outline2
					theme.TextColor = data.TextColor or Settings.Theme.Text
					theme.HighlightColor = data.HighlightColor or Settings.Theme.Main1

					self.GuiElems.Main.BackgroundColor3 = theme.OutlineColor
					self.GuiElems.Main.Container.BackgroundColor3 = theme.ContentColor
				end

				local mt = {__index = funcs}
				local function new()
					if not mouse then mouse = Main.Mouse or service.Players.LocalPlayer:GetMouse() end

					local obj = setmetatable({
						Width = 200,
						MaxHeight = nil,
						Iconless = false,
						SearchEnabled = false,
						ClearSearchOnShow = true,
						FocusSearchOnShow = true,
						Updated = false,
						QueuedDivider = false,
						QueuedDividerText = "",
						Items = {},
						Registered = {},
						GuiElems = {},
						Theme = {}
					},mt)
					obj.Gui = createGui(obj)
					obj:ApplyTheme({})
					return obj
				end

				return {new = new}
			end)()

			Lib.CodeFrame = (function()
				local funcs = {}

				local typeMap = {
					[1] = "String",
					[2] = "String",
					[3] = "String",
					[4] = "Comment",
					[5] = "Operator",
					[6] = "Number",
					[7] = "Keyword",
					[8] = "BuiltIn",
					[9] = "LocalMethod",
					[10] = "LocalProperty",
					[11] = "Nil",
					[12] = "Bool",
					[13] = "Function",
					[14] = "Local",
					[15] = "Self",
					[16] = "FunctionName",
					[17] = "Bracket"
				}

				local specialKeywordsTypes = {
					["nil"] = 11,
					["true"] = 12,
					["false"] = 12,
					["function"] = 13,
					["local"] = 14,
					["self"] = 15
				}

				local keywords = {
					["and"] = true,
					["break"] = true, 
					["do"] = true,
					["else"] = true,
					["elseif"] = true,
					["end"] = true,
					["false"] = true,
					["for"] = true,
					["function"] = true,
					["if"] = true,
					["in"] = true,
					["local"] = true,
					["nil"] = true,
					["not"] = true,
					["or"] = true,
					["repeat"] = true,
					["return"] = true,
					["then"] = true,
					["true"] = true,
					["until"] = true,
					["while"] = true,
					["plugin"] = true
				}

				local builtIns = {
					["delay"] = true,
					["elapsedTime"] = true,
					["require"] = true,
					["spawn"] = true,
					["tick"] = true,
					["time"] = true,
					["typeof"] = true,
					["UserSettings"] = true,
					["wait"] = true,
					["warn"] = true,
					["game"] = true,
					["shared"] = true,
					["script"] = true,
					["workspace"] = true,
					["assert"] = true,
					["collectgarbage"] = true,
					["error"] = true,
					["getfenv"] = true,
					["getmetatable"] = true,
					["ipairs"] = true,
					["loadstring"] = true,
					["newproxy"] = true,
					["next"] = true,
					["pairs"] = true,
					["pcall"] = true,
					["print"] = true,
					["rawequal"] = true,
					["rawget"] = true,
					["rawset"] = true,
					["select"] = true,
					["setfenv"] = true,
					["setmetatable"] = true,
					["tonumber"] = true,
					["tostring"] = true,
					["type"] = true,
					["unpack"] = true,
					["xpcall"] = true,
					["_G"] = true,
					["_VERSION"] = true,
					["coroutine"] = true,
					["debug"] = true,
					["math"] = true,
					["os"] = true,
					["string"] = true,
					["table"] = true,
					["bit32"] = true,
					["utf8"] = true,
					["Axes"] = true,
					["BrickColor"] = true,
					["CFrame"] = true,
					["Color3"] = true,
					["ColorSequence"] = true,
					["ColorSequenceKeypoint"] = true,
					["DockWidgetPluginGuiInfo"] = true,
					["Enum"] = true,
					["Faces"] = true,
					["Instance"] = true,
					["NumberRange"] = true,
					["NumberSequence"] = true,
					["NumberSequenceKeypoint"] = true,
					["PathWaypoint"] = true,
					["PhysicalProperties"] = true,
					["Random"] = true,
					["Ray"] = true,
					["Rect"] = true,
					["Region3"] = true,
					["Region3int16"] = true,
					["TweenInfo"] = true,
					["UDim"] = true,
					["UDim2"] = true,
					["Vector2"] = true,
					["Vector2int16"] = true,
					["Vector3"] = true,
					["Vector3int16"] = true
				}

				local builtInInited = false

				local richReplace = {
					["'"] = "&apos;",
					["\""] = "&quot;",
					["<"] = "&lt;",
					[">"] = "&gt;",
					["&"] = "&amp;"
				}

				local tabSub = "\t"
				local tabReplacement = (" %s "):format(tabSub)

				local tabJumps = {
					[("[^%s] "):format(tabSub)] = 0,
					[(" %s"):format(tabSub)] = -1,
					[("%s "):format(tabSub)] = 2,
					[(" [^%s]"):format(tabSub)] = 1,
				}

				local tweenService = service.TweenService
				local lineTweens = {}

				local function initBuiltIn()
					local env = getfenv()
					local type = type
					local tostring = tostring
					for name,_ in next,builtIns do
						local envVal = env[name]
						if type(envVal) == "table" then
							local items = {}
							for i,v in next,envVal do
								items[i] = true
							end
							builtIns[name] = items
						end
					end

					local enumEntries = {}
					local enums = Enum:GetEnums()
					for i = 1,#enums do
						enumEntries[tostring(enums[i])] = true
					end
					builtIns["Enum"] = enumEntries

					builtInInited = true
				end

				local function setupEditBox(obj)
					local editBox = obj.GuiElems.EditBox

					editBox.Focused:Connect(function()
						obj:ConnectEditBoxEvent()
						obj.Editing = true
					end)

					editBox.FocusLost:Connect(function()
						obj:DisconnectEditBoxEvent()
						obj.Editing = false
					end)

					editBox:GetPropertyChangedSignal("Text"):Connect(function()
						local text = editBox.Text
						if #text == 0 or obj.EditBoxCopying then return end
						editBox.Text = ""
						obj:AppendText(text)
					end)
				end

				local function setupMouseSelection(obj)
					local mouse = plr:GetMouse()
					local codeFrame = obj.GuiElems.LinesFrame
					local lines = obj.Lines

					codeFrame.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							local fontSizeX, fontSizeY = math.ceil(obj.FontSize / 2), obj.FontSize
							local relX = input.Position.X - codeFrame.AbsolutePosition.X
							local relY = input.Position.Y - codeFrame.AbsolutePosition.Y
							local selX = math.round(relX / fontSizeX) + obj.ViewX
							local selY = math.floor(relY / fontSizeY) + obj.ViewY
							local releaseEvent, inputEvent, scrollEvent
							local scrollPowerV, scrollPowerH = 0, 0
							selY = math.min(#lines - 1, selY)
							local relativeLine = lines[selY + 1] or ""
							selX = math.min(#relativeLine, selX + obj:TabAdjust(selX, selY))

							obj.SelectionRange = {{-1, -1}, {-1, -1}}
							obj:MoveCursor(selX, selY)
							obj.FloatCursorX = selX

							local function updateSelection()
								local relX = input.Position.X - codeFrame.AbsolutePosition.X
								local relY = input.Position.Y - codeFrame.AbsolutePosition.Y
								local sel2X = math.max(0, math.round(relX / fontSizeX) + obj.ViewX)
								local sel2Y = math.max(0, math.floor(relY / fontSizeY) + obj.ViewY)

								sel2Y = math.min(#lines - 1, sel2Y)
								local relativeLine = lines[sel2Y + 1] or ""
								sel2X = math.min(#relativeLine, sel2X + obj:TabAdjust(sel2X, sel2Y))

								if sel2Y < selY or (sel2Y == selY and sel2X < selX) then
									obj.SelectionRange = {{sel2X, sel2Y}, {selX, selY}}
								else						
									obj.SelectionRange = {{selX, selY}, {sel2X, sel2Y}}
								end

								obj:MoveCursor(sel2X, sel2Y)
								obj.FloatCursorX = sel2X
								obj:Refresh()
							end

							releaseEvent = service.UserInputService.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									releaseEvent:Disconnect()
									inputEvent:Disconnect()
									scrollEvent:Disconnect()
									obj:SetCopyableSelection()
								end
							end)

							inputEvent = service.UserInputService.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
									local upDelta = input.Position.Y - codeFrame.AbsolutePosition.Y
									local downDelta = input.Position.Y - codeFrame.AbsolutePosition.Y - codeFrame.AbsoluteSize.Y
									local leftDelta = input.Position.X - codeFrame.AbsolutePosition.X
									local rightDelta = input.Position.X - codeFrame.AbsolutePosition.X - codeFrame.AbsoluteSize.X

									scrollPowerV = 0
									scrollPowerH = 0
									if downDelta > 0 then
										scrollPowerV = math.floor(downDelta * 0.05) + 1
									elseif upDelta < 0 then
										scrollPowerV = math.ceil(upDelta * 0.05) - 1
									end
									if rightDelta > 0 then
										scrollPowerH = math.floor(rightDelta * 0.05) + 1
									elseif leftDelta < 0 then
										scrollPowerH = math.ceil(leftDelta * 0.05) - 1
									end
									updateSelection()
								end
							end)

							scrollEvent = service.RunService.RenderStepped:Connect(function()
								if scrollPowerV ~= 0 or scrollPowerH ~= 0 then
									obj:ScrollDelta(scrollPowerH, scrollPowerV)
									updateSelection()
								end
							end)

							obj:Refresh()
						end
					end)

				end

				local function makeFrame(obj)
					local frame = create({
						{1,"Frame",{BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel = 0,Position=UDim2.new(0.5,-300,0.5,-200),Size=UDim2.new(0,600,0,400),}},
					})
					local elems = {}

					local linesFrame = Instance.new("Frame")
					linesFrame.Name = "Lines"
					linesFrame.BackgroundTransparency = 1
					linesFrame.Size = UDim2.new(1,0,1,0)
					linesFrame.ClipsDescendants = true
					linesFrame.Parent = frame

					local lineNumbersLabel = Instance.new("TextLabel")
					lineNumbersLabel.Name = "LineNumbers"
					lineNumbersLabel.BackgroundTransparency = 1
					lineNumbersLabel.Font = Enum.Font.Code
					lineNumbersLabel.TextXAlignment = Enum.TextXAlignment.Right
					lineNumbersLabel.TextYAlignment = Enum.TextYAlignment.Top
					lineNumbersLabel.ClipsDescendants = true
					lineNumbersLabel.RichText = true
					lineNumbersLabel.Parent = frame

					local cursor = Instance.new("Frame")
					cursor.Name = "Cursor"
					cursor.BackgroundColor3 = Color3.fromRGB(220,220,220)
					cursor.BorderSizePixel = 0
					cursor.Parent = frame

					local editBox = Instance.new("TextBox")
					editBox.Name = "EditBox"
					editBox.MultiLine = true
					editBox.Visible = false
					editBox.Parent = frame

					lineTweens.Invis = tweenService:Create(cursor,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency = 1})
					lineTweens.Vis = tweenService:Create(cursor,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency = 0})

					elems.LinesFrame = linesFrame
					elems.LineNumbersLabel = lineNumbersLabel
					elems.Cursor = cursor
					elems.EditBox = editBox
					elems.ScrollCorner = create({{1,"Frame",{BackgroundColor3=Color3.new(0.15686275064945,0.15686275064945,0.15686275064945),BorderSizePixel=0,Name="ScrollCorner",Position=UDim2.new(1,-16,1,-16),Size=UDim2.new(0,16,0,16),Visible=false,}}})

					elems.ScrollCorner.Parent = frame
					linesFrame.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							obj:SetEditing(true, input)
						end
					end)


					obj.Frame = frame
					obj.Gui = frame
					obj.GuiElems = elems
					setupEditBox(obj)
					setupMouseSelection(obj)

					return frame
				end

				funcs.GetSelectionText = function(self)
					if not self:IsValidRange() then return "" end

					local selectionRange = self.SelectionRange
					local selX,selY = selectionRange[1][1], selectionRange[1][2]
					local sel2X,sel2Y = selectionRange[2][1], selectionRange[2][2]
					local deltaLines = sel2Y-selY
					local lines = self.Lines

					if not lines[selY+1] or not lines[sel2Y+1] then return "" end

					if deltaLines == 0 then
						return self:ConvertText(lines[selY+1]:sub(selX+1,sel2X), false)
					end

					local leftSub = lines[selY+1]:sub(selX+1)
					local rightSub = lines[sel2Y+1]:sub(1,sel2X)

					local result = leftSub.."\n" 
					for i = selY+1,sel2Y-1 do
						result = result..lines[i+1].."\n"
					end
					result = result..rightSub

					return self:ConvertText(result,false)
				end

				funcs.SetCopyableSelection = function(self)
					local text = self:GetSelectionText()
					local editBox = self.GuiElems.EditBox

					self.EditBoxCopying = true
					editBox.Text = text
					editBox.SelectionStart = 1
					editBox.CursorPosition = #editBox.Text + 1
					self.EditBoxCopying = false
				end

				funcs.ConnectEditBoxEvent = function(self)
					if self.EditBoxEvent then
						self.EditBoxEvent:Disconnect()
					end

					self.EditBoxEvent = service.UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

						local keycodes = Enum.KeyCode
						local keycode = input.KeyCode

						local function setupMove(key,func)
							local endCon,finished
							endCon = service.UserInputService.InputEnded:Connect(function(input)
								if input.KeyCode ~= key then return end
								endCon:Disconnect()
								finished = true
							end)
							func()
							Lib.FastWait(0.5)
							while not finished do func() Lib.FastWait(0.03) end
						end

						if keycode == keycodes.Down then
							setupMove(keycodes.Down,function()
								self.CursorX = self.FloatCursorX
								self.CursorY = self.CursorY + 1
								self:UpdateCursor()
								self:JumpToCursor()
							end)
						elseif keycode == keycodes.Up then
							setupMove(keycodes.Up,function()
								self.CursorX = self.FloatCursorX
								self.CursorY = self.CursorY - 1
								self:UpdateCursor()
								self:JumpToCursor()
							end)
						elseif keycode == keycodes.Left then
							setupMove(keycodes.Left,function()
								local line = self.Lines[self.CursorY+1] or ""
								self.CursorX = self.CursorX - 1 - (line:sub(self.CursorX-3,self.CursorX) == tabReplacement and 3 or 0)
								if self.CursorX < 0 then
									self.CursorY = self.CursorY - 1
									local line2 = self.Lines[self.CursorY+1] or ""
									self.CursorX = #line2
								end
								self.FloatCursorX = self.CursorX
								self:UpdateCursor()
								self:JumpToCursor()
							end)
						elseif keycode == keycodes.Right then
							setupMove(keycodes.Right,function()
								local line = self.Lines[self.CursorY+1] or ""
								self.CursorX = self.CursorX + 1 + (line:sub(self.CursorX+1,self.CursorX+4) == tabReplacement and 3 or 0)
								if self.CursorX > #line then
									self.CursorY = self.CursorY + 1
									self.CursorX = 0
								end
								self.FloatCursorX = self.CursorX
								self:UpdateCursor()
								self:JumpToCursor()
							end)
						elseif keycode == keycodes.Backspace then
							setupMove(keycodes.Backspace,function()
								local startRange,endRange
								if self:IsValidRange() then
									startRange = self.SelectionRange[1]
									endRange = self.SelectionRange[2]
								else
									endRange = {self.CursorX,self.CursorY}
								end

								if not startRange then
									local line = self.Lines[self.CursorY+1] or ""
									self.CursorX = self.CursorX - 1 - (line:sub(self.CursorX-3,self.CursorX) == tabReplacement and 3 or 0)
									if self.CursorX < 0 then
										self.CursorY = self.CursorY - 1
										local line2 = self.Lines[self.CursorY+1] or ""
										self.CursorX = #line2
									end
									self.FloatCursorX = self.CursorX
									self:UpdateCursor()

									startRange = startRange or {self.CursorX,self.CursorY}
								end

								self:DeleteRange({startRange,endRange},false,true)
								self:ResetSelection(true)
								self:JumpToCursor()
							end)
						elseif keycode == keycodes.Delete then
							setupMove(keycodes.Delete,function()
								local startRange,endRange
								if self:IsValidRange() then
									startRange = self.SelectionRange[1]
									endRange = self.SelectionRange[2]
								else
									startRange = {self.CursorX,self.CursorY}
								end

								if not endRange then
									local line = self.Lines[self.CursorY+1] or ""
									local endCursorX = self.CursorX + 1 + (line:sub(self.CursorX+1,self.CursorX+4) == tabReplacement and 3 or 0)
									local endCursorY = self.CursorY
									if endCursorX > #line then
										endCursorY = endCursorY + 1
										endCursorX = 0
									end
									self:UpdateCursor()

									endRange = endRange or {endCursorX,endCursorY}
								end

								self:DeleteRange({startRange,endRange},false,true)
								self:ResetSelection(true)
								self:JumpToCursor()
							end)
						elseif service.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
							if keycode == keycodes.A then
								self.SelectionRange = {{0,0},{#self.Lines[#self.Lines],#self.Lines-1}}
								self:SetCopyableSelection()
								self:Refresh()
							end
						end
					end)
				end

				funcs.DisconnectEditBoxEvent = function(self)
					if self.EditBoxEvent then
						self.EditBoxEvent:Disconnect()
					end
				end

				funcs.ResetSelection = function(self,norefresh)
					self.SelectionRange = {{-1,-1},{-1,-1}}
					if not norefresh then self:Refresh() end
				end

				funcs.IsValidRange = function(self,range)
					local selectionRange = range or self.SelectionRange
					local selX,selY = selectionRange[1][1], selectionRange[1][2]
					local sel2X,sel2Y = selectionRange[2][1], selectionRange[2][2]

					if selX == -1 or (selX == sel2X and selY == sel2Y) then return false end

					return true
				end

				funcs.DeleteRange = function(self,range,noprocess,updatemouse)
					range = range or self.SelectionRange
					if not self:IsValidRange(range) then return end

					local lines = self.Lines
					local selX,selY = range[1][1], range[1][2]
					local sel2X,sel2Y = range[2][1], range[2][2]
					local deltaLines = sel2Y-selY

					if not lines[selY+1] or not lines[sel2Y+1] then return end

					local leftSub = lines[selY+1]:sub(1,selX)
					local rightSub = lines[sel2Y+1]:sub(sel2X+1)
					lines[selY+1] = leftSub..rightSub

					local remove = table.remove
					for i = 1,deltaLines do
						remove(lines,selY+2)
					end

					if range == self.SelectionRange then self.SelectionRange = {{-1,-1},{-1,-1}} end
					if updatemouse then
						self.CursorX = selX
						self.CursorY = selY
						self:UpdateCursor()
					end

					if not noprocess then
						self:ProcessTextChange()
					end
				end

				funcs.AppendText = function(self,text)
					self:DeleteRange(nil,true,true)
					local lines,cursorX,cursorY = self.Lines,self.CursorX,self.CursorY
					local line = lines[cursorY+1]
					local before = line:sub(1,cursorX)
					local after = line:sub(cursorX+1)

					text = text:gsub("\r\n","\n")
					text = self:ConvertText(text,true) -- Tab Convert

					local textLines = text:split("\n")
					local insert = table.insert

					for i = 1,#textLines do
						local linePos = cursorY+i
						if i > 1 then insert(lines,linePos,"") end

						local textLine = textLines[i]
						local newBefore = (i == 1 and before or "")
						local newAfter = (i == #textLines and after or "")

						lines[linePos] = newBefore..textLine..newAfter
					end

					if #textLines > 1 then cursorX = 0 end

					self:ProcessTextChange()
					self.CursorX = cursorX + #textLines[#textLines]
					self.CursorY = cursorY + #textLines-1
					self:UpdateCursor()
				end

				funcs.ScrollDelta = function(self,x,y)
					self.ScrollV:ScrollTo(self.ScrollV.Index + y)
					self.ScrollH:ScrollTo(self.ScrollH.Index + x)
				end

				-- x and y starts at 0
				funcs.TabAdjust = function(self,x,y)
					local lines = self.Lines
					local line = lines[y+1]
					x=x+1

					if line then
						local left = line:sub(x-1,x-1)
						local middle = line:sub(x,x)
						local right = line:sub(x+1,x+1)
						local selRange = (#left > 0 and left or " ") .. (#middle > 0 and middle or " ") .. (#right > 0 and right or " ")

						for i,v in pairs(tabJumps) do
							if selRange:find(i) then
								return v
							end
						end
					end
					return 0
				end

				funcs.SetEditing = function(self,on,input)			
					self:UpdateCursor(input)

					if on then
						if self.Editable then
							self.GuiElems.EditBox.Text = ""
							self.GuiElems.EditBox:CaptureFocus()
						end
					else
						self.GuiElems.EditBox:ReleaseFocus()
					end
				end

				funcs.CursorAnim = function(self,on)
					local cursor = self.GuiElems.Cursor
					local animTime = tick()
					self.LastAnimTime = animTime

					if not on then return end

					lineTweens.Invis:Cancel()
					lineTweens.Vis:Cancel()
					cursor.BackgroundTransparency = 0

					coroutine.wrap(function()
						while self.Editable do
							Lib.FastWait(0.5)
							if self.LastAnimTime ~= animTime then return end
							lineTweens.Invis:Play()
							Lib.FastWait(0.4)
							if self.LastAnimTime ~= animTime then return end
							lineTweens.Vis:Play()
							Lib.FastWait(0.2)
						end
					end)()
				end

				funcs.MoveCursor = function(self,x,y)
					self.CursorX = x
					self.CursorY = y
					self:UpdateCursor()
					self:JumpToCursor()
				end

				funcs.JumpToCursor = function(self)
					self:Refresh()
				end

				funcs.UpdateCursor = function(self,input)
					local linesFrame = self.GuiElems.LinesFrame
					local cursor = self.GuiElems.Cursor			
					local hSize = math.max(0,linesFrame.AbsoluteSize.X)
					local vSize = math.max(0,linesFrame.AbsoluteSize.Y)
					local maxLines = math.ceil(vSize / self.FontSize)
					local maxCols = math.ceil(hSize / math.ceil(self.FontSize/2))
					local viewX,viewY = self.ViewX,self.ViewY
					local totalLinesStr = tostring(#self.Lines)
					local fontWidth = math.ceil(self.FontSize / 2)
					local linesOffset = #totalLinesStr*fontWidth + 4*fontWidth

					if input then
						local linesFrame = self.GuiElems.LinesFrame
						local frameX,frameY = linesFrame.AbsolutePosition.X,linesFrame.AbsolutePosition.Y
						local mouseX,mouseY = input.Position.X,input.Position.Y
						local fontSizeX,fontSizeY = math.ceil(self.FontSize/2),self.FontSize

						self.CursorX = self.ViewX + math.round((mouseX - frameX) / fontSizeX)
						self.CursorY = self.ViewY + math.floor((mouseY - frameY) / fontSizeY)
					end

					local cursorX,cursorY = self.CursorX,self.CursorY

					local line = self.Lines[cursorY+1] or ""
					if cursorX > #line then cursorX = #line
					elseif cursorX < 0 then cursorX = 0 end

					if cursorY >= #self.Lines then
						cursorY = math.max(0,#self.Lines-1)
					elseif cursorY < 0 then
						cursorY = 0
					end

					cursorX = cursorX + self:TabAdjust(cursorX,cursorY)

					-- Update modified
					self.CursorX = cursorX
					self.CursorY = cursorY

					local cursorVisible = (cursorX >= viewX) and (cursorY >= viewY) and (cursorX <= viewX + maxCols) and (cursorY <= viewY + maxLines)
					if cursorVisible then
						local offX = (cursorX - viewX)
						local offY = (cursorY - viewY)
						cursor.Position = UDim2.new(0,linesOffset + offX*math.ceil(self.FontSize/2) - 1,0,offY*self.FontSize)
						cursor.Size = UDim2.new(0,1,0,self.FontSize+2)
						cursor.Visible = true
						self:CursorAnim(true)
					else
						cursor.Visible = false
					end
				end

				funcs.MapNewLines = function(self)
					local newLines = {}
					local count = 1
					local text = self.Text
					local find = string.find
					local init = 1

					local pos = find(text,"\n",init,true)
					while pos do
						newLines[count] = pos
						count = count + 1
						init = pos + 1
						pos = find(text,"\n",init,true)
					end

					self.NewLines = newLines
				end

				funcs.PreHighlight = function(self)
					local start = tick()
					local text = self.Text:gsub("\\\\","	")
					--print("BACKSLASH SUB",tick()-start)
					local textLen = #text
					local found = {}
					local foundMap = {}
					local extras = {}
					local find = string.find
					local sub = string.sub
					self.ColoredLines = {}

					local function findAll(str,pattern,typ,raw)
						local count = #found+1
						local init = 1
						local x,y,extra = find(str,pattern,init,raw)
						while x do
							found[count] = x
							foundMap[x] = typ
							if extra then
								extras[x] = extra
							end

							count = count+1
							init = y+1
							x,y,extra = find(str,pattern,init,raw)
						end
					end
					local start = tick()
					findAll(text,'"',1,true)
					findAll(text,"'",2,true)
					findAll(text,"%[(=*)%[",3)
					findAll(text,"--",4,true)
					table.sort(found)

					local newLines = self.NewLines
					local curLine = 0
					local lineTableCount = 1
					local lineStart = 0
					local lineEnd = 0
					local lastEnding = 0
					local foundHighlights = {}

					for i = 1,#found do
						local pos = found[i]
						if pos <= lastEnding then continue end

						local ending = pos
						local typ = foundMap[pos]
						if typ == 1 then
							ending = find(text,'"',pos+1,true)
							while ending and sub(text,ending-1,ending-1) == "\\" do
								ending = find(text,'"',ending+1,true)
							end
							if not ending then ending = textLen end
						elseif typ == 2 then
							ending = find(text,"'",pos+1,true)
							while ending and sub(text,ending-1,ending-1) == "\\" do
								ending = find(text,"'",ending+1,true)
							end
							if not ending then ending = textLen end
						elseif typ == 3 then
							_,ending = find(text,"]"..extras[pos].."]",pos+1,true)
							if not ending then ending = textLen end
						elseif typ == 4 then
							local ahead = foundMap[pos+2]

							if ahead == 3 then
								_,ending = find(text,"]"..extras[pos+2].."]",pos+1,true)
								if not ending then ending = textLen end
							else
								ending = find(text,"\n",pos+1,true) or textLen
							end
						end

						while pos > lineEnd do
							curLine = curLine + 1
							--lineTableCount = 1
							lineEnd = newLines[curLine] or textLen+1
						end
						while true do
							local lineTable = foundHighlights[curLine]
							if not lineTable then lineTable = {} foundHighlights[curLine] = lineTable end
							lineTable[pos] = {typ,ending}
							--lineTableCount = lineTableCount + 1

							if ending > lineEnd then
								curLine = curLine + 1
								lineEnd = newLines[curLine] or textLen+1
							else
								break
							end
						end

						lastEnding = ending
						--if i < 200 then print(curLine) end
					end
					self.PreHighlights = foundHighlights
					--print(tick()-start)
					--print(#found,curLine)
				end

				funcs.HighlightLine = function(self,line)
					local cached = self.ColoredLines[line]
					if cached then return cached end

					local sub = string.sub
					local find = string.find
					local match = string.match
					local highlights = {}
					local preHighlights = self.PreHighlights[line] or {}
					local lineText = self.Lines[line] or ""
					local lineLen = #lineText
					local lastEnding = 0
					local currentType = 0
					local lastWord = nil
					local wordBeginsDotted = false
					local funcStatus = 0
					local lineStart = self.NewLines[line-1] or 0

					local preHighlightMap = {}
					for pos,data in next,preHighlights do
						local relativePos = pos-lineStart
						if relativePos < 1 then
							currentType = data[1]
							lastEnding = data[2] - lineStart
							--warn(pos,data[2])
						else
							preHighlightMap[relativePos] = {data[1],data[2]-lineStart}
						end
					end

					for col = 1,#lineText do
						if col <= lastEnding then highlights[col] = currentType continue end

						local pre = preHighlightMap[col]
						if pre then
							currentType = pre[1]
							lastEnding = pre[2]
							highlights[col] = currentType
							wordBeginsDotted = false
							lastWord = nil
							funcStatus = 0
						else
							local char = sub(lineText,col,col)
							if find(char,"[%a_]") then
								local word = match(lineText,"[%a%d_]+",col)
								local wordType = (keywords[word] and 7) or (builtIns[word] and 8)

								lastEnding = col+#word-1

								if wordType ~= 7 then
									if wordBeginsDotted then
										local prevBuiltIn = lastWord and builtIns[lastWord]
										wordType = (prevBuiltIn and type(prevBuiltIn) == "table" and prevBuiltIn[word] and 8) or 10
									end

									if wordType ~= 8 then
										local x,y,br = find(lineText,"^%s*([%({\"'])",lastEnding+1)
										if x then
											wordType = (funcStatus > 0 and br == "(" and 16) or 9
											funcStatus = 0
										end
									end
								else
									wordType = specialKeywordsTypes[word] or wordType
									funcStatus = (word == "function" and 1 or 0)
								end

								lastWord = word
								wordBeginsDotted = false
								if funcStatus > 0 then funcStatus = 1 end

								if wordType then
									currentType = wordType
									highlights[col] = currentType
								else
									currentType = nil
								end
							elseif find(char,"%p") then
								local isDot = (char == ".")
								local isNum = isDot and find(sub(lineText,col+1,col+1),"%d")
								highlights[col] = (isNum and 6 or 5)

								if not isNum then
									local dotStr = isDot and match(lineText,"%.%.?%.?",col)
									if dotStr and #dotStr > 1 then
										currentType = 5
										lastEnding = col+#dotStr-1
										wordBeginsDotted = false
										lastWord = nil
										funcStatus = 0
									else
										if isDot then
											if wordBeginsDotted then
												lastWord = nil
											else
												wordBeginsDotted = true
											end
										else
											wordBeginsDotted = false
											lastWord = nil
										end

										funcStatus = ((isDot or char == ":") and funcStatus == 1 and 2) or 0
									end
								end
							elseif find(char,"%d") then
								local _,endPos = find(lineText,"%x+",col)
								local endPart = sub(lineText,endPos,endPos+1)
								if (endPart == "e+" or endPart == "e-") and find(sub(lineText,endPos+2,endPos+2),"%d") then
									endPos = endPos + 1
								end
								currentType = 6
								lastEnding = endPos
								highlights[col] = 6
								wordBeginsDotted = false
								lastWord = nil
								funcStatus = 0
							else
								highlights[col] = currentType
								local _,endPos = find(lineText,"%s+",col)
								if endPos then
									lastEnding = endPos
								end
							end
						end
					end

					self.ColoredLines[line] = highlights
					return highlights
				end

				funcs.Refresh = function(self)
					local start = tick()

					local linesFrame = self.Frame.Lines
					local hSize = math.max(0,linesFrame.AbsoluteSize.X)
					local vSize = math.max(0,linesFrame.AbsoluteSize.Y)
					local maxLines = math.ceil(vSize / self.FontSize)
					local maxCols = math.ceil(hSize / math.ceil(self.FontSize/2))
					local gsub = string.gsub
					local sub = string.sub

					local viewX,viewY = self.ViewX,self.ViewY

					local lineNumberStr = ""

					for row = 1,maxLines do
						local lineFrame = self.LineFrames[row]
						if not lineFrame then
							lineFrame = Instance.new("Frame")
							lineFrame.Name = "Line"
							lineFrame.Position = UDim2.new(0,0,0,(row-1)*self.FontSize)
							lineFrame.Size = UDim2.new(1,0,0,self.FontSize)
							lineFrame.BorderSizePixel = 0
							lineFrame.BackgroundTransparency = 1

							local selectionHighlight = Instance.new("Frame")
							selectionHighlight.Name = "SelectionHighlight"
							selectionHighlight.BorderSizePixel = 0
							selectionHighlight.BackgroundColor3 = Settings.Theme.Syntax.SelectionBack
							selectionHighlight.Parent = lineFrame

							local label = Instance.new("TextLabel")
							label.Name = "Label"
							label.BackgroundTransparency = 1
							label.Font = Enum.Font.Code
							label.TextSize = self.FontSize
							label.Size = UDim2.new(1,0,0,self.FontSize)
							label.RichText = true
							label.TextXAlignment = Enum.TextXAlignment.Left
							label.TextColor3 = self.Colors.Text
							label.ZIndex = 2
							label.Parent = lineFrame

							lineFrame.Parent = linesFrame
							self.LineFrames[row] = lineFrame
						end

						local relaY = viewY + row
						local lineText = self.Lines[relaY] or ""
						local resText = ""
						local highlights = self:HighlightLine(relaY)
						local colStart = viewX + 1

						local richTemplates = self.RichTemplates
						local textTemplate = richTemplates.Text
						local selectionTemplate = richTemplates.Selection
						local curType = highlights[colStart]
						local curTemplate = richTemplates[typeMap[curType]] or textTemplate

						-- Selection Highlight
						local selectionRange = self.SelectionRange
						local selPos1 = selectionRange[1]
						local selPos2 = selectionRange[2]
						local selRow,selColumn = selPos1[2],selPos1[1]
						local sel2Row,sel2Column = selPos2[2],selPos2[1]
						local selRelaX,selRelaY = viewX,relaY-1

						if selRelaY >= selPos1[2] and selRelaY <= selPos2[2] then
							local fontSizeX = math.ceil(self.FontSize/2)
							local posX = (selRelaY == selPos1[2] and selPos1[1] or 0) - viewX
							local sizeX = (selRelaY == selPos2[2] and selPos2[1]-posX-viewX or maxCols+viewX)

							lineFrame.SelectionHighlight.Position = UDim2.new(0,posX*fontSizeX,0,0)
							lineFrame.SelectionHighlight.Size = UDim2.new(0,sizeX*fontSizeX,1,0)
							lineFrame.SelectionHighlight.Visible = true
						else
							lineFrame.SelectionHighlight.Visible = false
						end

						-- Selection Text Color for first char
						local inSelection = selRelaY >= selRow and selRelaY <= sel2Row and (selRelaY == selRow and viewX >= selColumn or selRelaY ~= selRow) and (selRelaY == sel2Row and viewX < sel2Column or selRelaY ~= sel2Row)
						if inSelection then
							curType = -999
							curTemplate = selectionTemplate
						end

						for col = 2,maxCols do
							local relaX = viewX + col
							local selRelaX = relaX-1
							local posType = highlights[relaX]

							-- Selection Text Color
							local inSelection = selRelaY >= selRow and selRelaY <= sel2Row and (selRelaY == selRow and selRelaX >= selColumn or selRelaY ~= selRow) and (selRelaY == sel2Row and selRelaX < sel2Column or selRelaY ~= sel2Row)
							if inSelection then
								posType = -999
							end

							if posType ~= curType then
								local template = (inSelection and selectionTemplate) or richTemplates[typeMap[posType]] or textTemplate

								if template ~= curTemplate then
									local nextText = gsub(sub(lineText,colStart,relaX-1),"['\"<>&]",richReplace)
									resText = resText .. (curTemplate ~= textTemplate and (curTemplate .. nextText .. "</font>") or nextText)
									colStart = relaX
									curTemplate = template
								end
								curType = posType
							end
						end

						local lastText = gsub(sub(lineText,colStart,viewX+maxCols),"['\"<>&]",richReplace)
						--warn("SUB",colStart,viewX+maxCols-1)
						if #lastText > 0 then
							resText = resText .. (curTemplate ~= textTemplate and (curTemplate .. lastText .. "</font>") or lastText)
						end

						if self.Lines[relaY] then
							lineNumberStr = lineNumberStr .. (relaY == self.CursorY and ("<b>"..relaY.."</b>\n") or relaY .. "\n")
						end

						lineFrame.Label.Text = resText
					end

					for i = maxLines+1,#self.LineFrames do
						self.LineFrames[i]:Destroy()
						self.LineFrames[i] = nil
					end

					self.Frame.LineNumbers.Text = lineNumberStr
					self:UpdateCursor()

					--print("REFRESH TIME",tick()-start)
				end

				funcs.UpdateView = function(self)
					local totalLinesStr = tostring(#self.Lines)
					local fontWidth = math.ceil(self.FontSize / 2)
					local linesOffset = #totalLinesStr*fontWidth + 4*fontWidth

					local linesFrame = self.Frame.Lines
					local hSize = linesFrame.AbsoluteSize.X
					local vSize = linesFrame.AbsoluteSize.Y
					local maxLines = math.ceil(vSize / self.FontSize)
					local totalWidth = self.MaxTextCols*fontWidth
					local scrollV = self.ScrollV
					local scrollH = self.ScrollH

					scrollV.VisibleSpace = maxLines
					scrollV.TotalSpace = #self.Lines + 1
					scrollH.VisibleSpace = math.ceil(hSize/fontWidth)
					scrollH.TotalSpace = self.MaxTextCols + 1

					scrollV.Gui.Visible = #self.Lines + 1 > maxLines
					scrollH.Gui.Visible = totalWidth > hSize

					local oldOffsets = self.FrameOffsets
					self.FrameOffsets = Vector2.new(scrollV.Gui.Visible and -16 or 0, scrollH.Gui.Visible and -16 or 0)
					if oldOffsets ~= self.FrameOffsets then
						self:UpdateView()
					else
						scrollV:ScrollTo(self.ViewY,true)
						scrollH:ScrollTo(self.ViewX,true)

						if scrollV.Gui.Visible and scrollH.Gui.Visible then
							scrollV.Gui.Size = UDim2.new(0,16,1,-16)
							scrollH.Gui.Size = UDim2.new(1,-16,0,16)
							self.GuiElems.ScrollCorner.Visible = true
						else
							scrollV.Gui.Size = UDim2.new(0,16,1,0)
							scrollH.Gui.Size = UDim2.new(1,0,0,16)
							self.GuiElems.ScrollCorner.Visible = false
						end

						self.ViewY = scrollV.Index
						self.ViewX = scrollH.Index
						self.Frame.Lines.Position = UDim2.new(0,linesOffset,0,0)
						self.Frame.Lines.Size = UDim2.new(1,-linesOffset+oldOffsets.X,1,oldOffsets.Y)
						self.Frame.LineNumbers.Position = UDim2.new(0,fontWidth,0,0)
						self.Frame.LineNumbers.Size = UDim2.new(0,#totalLinesStr*fontWidth,1,oldOffsets.Y)
						self.Frame.LineNumbers.TextSize = self.FontSize
					end
				end

				funcs.ProcessTextChange = function(self)
					local maxCols = 0
					local lines = self.Lines

					for i = 1,#lines do
						local lineLen = #lines[i]
						if lineLen > maxCols then
							maxCols = lineLen
						end
					end

					self.MaxTextCols = maxCols
					self:UpdateView()	
					self.Text = table.concat(self.Lines,"\n")
					self:MapNewLines()
					self:PreHighlight()
					self:Refresh()
					--self.TextChanged:Fire()
				end

				funcs.ConvertText = function(self,text,toEditor)
					if toEditor then
						return text:gsub("\t",(" %s "):format(tabSub))
					else
						return text:gsub((" %s "):format(tabSub),"\t")
					end
				end

				funcs.GetText = function(self) -- TODO: better (use new tab format)
					local source = table.concat(self.Lines,"\n")
					return self:ConvertText(source,false) -- Tab Convert
				end

				funcs.SetText = function(self,txt)
					txt = self:ConvertText(txt,true) -- Tab Convert
					local lines = self.Lines
					table.clear(lines)
					local count = 1

					for line in txt:gmatch("([^\n\r]*)[\n\r]?") do
						local len = #line
						lines[count] = line
						count = count + 1
					end

					self:ProcessTextChange()
				end

				funcs.MakeRichTemplates = function(self)
					local floor = math.floor
					local templates = {}

					for name,color in pairs(self.Colors) do
						templates[name] = ('<font color="rgb(%s,%s,%s)">'):format(floor(color.r*255),floor(color.g*255),floor(color.b*255))
					end

					self.RichTemplates = templates
				end

				funcs.ApplyTheme = function(self)
					local colors = Settings.Theme.Syntax
					self.Colors = colors
					self.Frame.LineNumbers.TextColor3 = colors.Text
					self.Frame.BackgroundColor3 = colors.Background
				end

				local mt = {__index = funcs}

				local function new()
					if not builtInInited then initBuiltIn() end

					local scrollV = Lib.ScrollBar.new()
					local scrollH = Lib.ScrollBar.new(true)
					scrollH.Gui.Position = UDim2.new(0,0,1,-16)
					local obj = setmetatable({
						FontSize = 15,
						ViewX = 0,
						ViewY = 0,
						Colors = Settings.Theme.Syntax,
						ColoredLines = {},
						Lines = {""},
						LineFrames = {},
						Editable = true,
						Editing = false,
						CursorX = 0,
						CursorY = 0,
						FloatCursorX = 0,
						Text = "",
						PreHighlights = {},
						SelectionRange = {{-1,-1},{-1,-1}},
						NewLines = {},
						FrameOffsets = Vector2.new(0,0),
						MaxTextCols = 0,
						ScrollV = scrollV,
						ScrollH = scrollH
					},mt)

					scrollV.WheelIncrement = 3
					scrollH.Increment = 2
					scrollH.WheelIncrement = 7

					scrollV.Scrolled:Connect(function()
						obj.ViewY = scrollV.Index
						obj:Refresh()
					end)

					scrollH.Scrolled:Connect(function()
						obj.ViewX = scrollH.Index
						obj:Refresh()
					end)

					makeFrame(obj)
					obj:MakeRichTemplates()
					obj:ApplyTheme()
					scrollV:SetScrollFrame(obj.Frame.Lines)
					scrollV.Gui.Parent = obj.Frame
					scrollH.Gui.Parent = obj.Frame

					obj:UpdateView()
					obj.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						obj:UpdateView()
						obj:Refresh()
					end)

					return obj
				end

				return {new = new}
			end)()

			Lib.Checkbox = (function()
				local funcs = {}
				local c3 = Color3.fromRGB
				local v2 = Vector2.new
				local ud2s = UDim2.fromScale
				local ud2o = UDim2.fromOffset
				local ud = UDim.new
				local max = math.max
				local new = Instance.new
				local TweenSize = new("Frame").TweenSize
				local ti = TweenInfo.new
				local delay = delay

				local function ripple(object, color)
					local circle = new('Frame')
					circle.BackgroundColor3 = color
					circle.BackgroundTransparency = 0.75
					circle.BorderSizePixel = 0
					circle.AnchorPoint = v2(0.5, 0.5)
					circle.Size = ud2o()
					circle.Position = ud2s(0.5, 0.5)
					circle.Parent = object
					local rounding = new('UICorner')
					rounding.CornerRadius = ud(1)
					rounding.Parent = circle

					local abssz = object.AbsoluteSize
					local size = max(abssz.X, abssz.Y) * 5/3

					TweenSize(circle, ud2o(size, size), "Out", "Quart", 0.4)
					service.TweenService:Create(circle, ti(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()

					service.Debris:AddItem(circle, 0.4)
				end

				local function initGui(self,frame)
					local checkbox = frame or create({
						{1,"ImageButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="Checkbox",Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,16,0,16),}},
						{2,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ripples",Parent={1},Size=UDim2.new(1,0,1,0),}},
						{3,"Frame",{BackgroundColor3=Color3.new(0.10196078568697,0.10196078568697,0.10196078568697),BorderSizePixel=0,Name="outline",Parent={1},Size=UDim2.new(0,16,0,16),}},
						{4,"Frame",{BackgroundColor3=Color3.new(0.14117647707462,0.14117647707462,0.14117647707462),BorderSizePixel=0,Name="filler",Parent={3},Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,14,0,14),}},
						{5,"Frame",{BackgroundColor3=Color3.new(0.90196084976196,0.90196084976196,0.90196084976196),BorderSizePixel=0,Name="top",Parent={4},Size=UDim2.new(0,16,0,0),}},
						{6,"Frame",{AnchorPoint=Vector2.new(0,1),BackgroundColor3=Color3.new(0.90196084976196,0.90196084976196,0.90196084976196),BorderSizePixel=0,Name="bottom",Parent={4},Position=UDim2.new(0,0,0,14),Size=UDim2.new(0,16,0,0),}},
						{7,"Frame",{BackgroundColor3=Color3.new(0.90196084976196,0.90196084976196,0.90196084976196),BorderSizePixel=0,Name="left",Parent={4},Size=UDim2.new(0,0,0,16),}},
						{8,"Frame",{AnchorPoint=Vector2.new(1,0),BackgroundColor3=Color3.new(0.90196084976196,0.90196084976196,0.90196084976196),BorderSizePixel=0,Name="right",Parent={4},Position=UDim2.new(0,14,0,0),Size=UDim2.new(0,0,0,16),}},
						{9,"Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,Name="checkmark",Parent={4},Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,0,0,20),}},
						{10,"ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxassetid://6234266378",Parent={9},Position=UDim2.new(0.5,0,0.5,0),ScaleType=3,Size=UDim2.new(0,15,0,11),}},
						{11,"ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://6401617475",ImageColor3=Color3.new(0.20784313976765,0.69803923368454,0.98431372642517),Name="checkmark2",Parent={4},Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,12,0,12),Visible=false,}},
						{12,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://6425281788",ImageTransparency=0.20000000298023,Name="middle",Parent={4},ScaleType=2,Size=UDim2.new(1,0,1,0),TileSize=UDim2.new(0,2,0,2),Visible=false,}},
						{13,"UICorner",{CornerRadius=UDim.new(0,2),Parent={3},}},
					})
					local outline = checkbox.outline
					local filler = outline.filler
					local checkmark = filler.checkmark
					local ripples_container = checkbox.ripples

					-- walls
					local top, bottom, left, right = filler.top, filler.bottom, filler.left, filler.right

					self.Gui = checkbox
					self.GuiElems = {
						Top = top,
						Bottom = bottom,
						Left = left,
						Right = right,
						Outline = outline,
						Filler = filler,
						Checkmark = checkmark,
						Checkmark2 = filler.checkmark2,
						Middle = filler.middle
					}

					checkbox.Activated:Connect(function()
						if Lib.CheckMouseInGui(checkbox) then
							if self.Style == 0 then
								ripple(ripples_container, self.Disabled and self.Colors.Disabled or self.Colors.Primary)
							end

							if not self.Disabled then
								self:SetState(not self.Toggled,true)
							else
								self:Paint()
							end

							self.OnInput:Fire()
						end
					end)

					-- Old:
			--[[checkbox.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					local release
					release = service.UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							release:Disconnect()

							if Lib.CheckMouseInGui(checkbox) then
								if self.Style == 0 then
									ripple(ripples_container, self.Disabled and self.Colors.Disabled or self.Colors.Primary)
								end

								if not self.Disabled then
									self:SetState(not self.Toggled,true)
								else
									self:Paint()
								end
								
								self.OnInput:Fire()
							end
						end
					end)
				end
			end)]]

					self:Paint()
				end

				funcs.Collapse = function(self,anim)
					local guiElems = self.GuiElems
					if anim then
						TweenSize(guiElems.Top, ud2o(14, 14), "In", "Quart", 4/15, true)
						TweenSize(guiElems.Bottom, ud2o(14, 14), "In", "Quart", 4/15, true)
						TweenSize(guiElems.Left, ud2o(14, 14), "In", "Quart", 4/15, true)
						TweenSize(guiElems.Right, ud2o(14, 14), "In", "Quart", 4/15, true)
					else
						guiElems.Top.Size = ud2o(14, 14)
						guiElems.Bottom.Size = ud2o(14, 14)
						guiElems.Left.Size = ud2o(14, 14)
						guiElems.Right.Size = ud2o(14, 14)
					end
				end

				funcs.Expand = function(self,anim)
					local guiElems = self.GuiElems
					if anim then
						TweenSize(guiElems.Top, ud2o(14, 0), "InOut", "Quart", 4/15, true)
						TweenSize(guiElems.Bottom, ud2o(14, 0), "InOut", "Quart", 4/15, true)
						TweenSize(guiElems.Left, ud2o(0, 14), "InOut", "Quart", 4/15, true)
						TweenSize(guiElems.Right, ud2o(0, 14), "InOut", "Quart", 4/15, true)
					else
						guiElems.Top.Size = ud2o(14, 0)
						guiElems.Bottom.Size = ud2o(14, 0)
						guiElems.Left.Size = ud2o(0, 14)
						guiElems.Right.Size = ud2o(0, 14)
					end
				end

				funcs.Paint = function(self)
					local guiElems = self.GuiElems

					if self.Style == 0 then
						local color_base = self.Disabled and self.Colors.Disabled
						guiElems.Outline.BackgroundColor3 = color_base or (self.Toggled and self.Colors.Primary) or self.Colors.Secondary
						local walls_color = color_base or self.Colors.Primary
						guiElems.Top.BackgroundColor3 = walls_color
						guiElems.Bottom.BackgroundColor3 = walls_color
						guiElems.Left.BackgroundColor3 = walls_color
						guiElems.Right.BackgroundColor3 = walls_color
					else
						guiElems.Outline.BackgroundColor3 = self.Disabled and self.Colors.Disabled or self.Colors.Secondary
						guiElems.Filler.BackgroundColor3 = self.Disabled and self.Colors.DisabledBackground or self.Colors.Background
						guiElems.Checkmark2.ImageColor3 = self.Disabled and self.Colors.DisabledCheck or self.Colors.Primary
					end
				end

				funcs.SetState = function(self,val,anim)
					self.Toggled = val

					if self.OutlineColorTween then self.OutlineColorTween:Cancel() end
					local setStateTime = tick()
					self.LastSetStateTime = setStateTime

					if self.Toggled then
						if self.Style == 0 then
							if anim then
								self.OutlineColorTween = service.TweenService:Create(self.GuiElems.Outline, ti(4/15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {BackgroundColor3 = self.Colors.Primary})
								self.OutlineColorTween:Play()
								delay(0.15, function()
									if setStateTime ~= self.LastSetStateTime then return end
									self:Paint()
									TweenSize(self.GuiElems.Checkmark, ud2o(14, 20), "Out", "Bounce", 2/15, true)
								end)
							else
								self.GuiElems.Outline.BackgroundColor3 = self.Colors.Primary
								self:Paint()
								self.GuiElems.Checkmark.Size = ud2o(14, 20)
							end
							self:Collapse(anim)
						else
							self:Paint()
							self.GuiElems.Checkmark2.Visible = true
							self.GuiElems.Middle.Visible = false
						end
					else
						if self.Style == 0 then
							if anim then
								self.OutlineColorTween = service.TweenService:Create(self.GuiElems.Outline, ti(4/15, Enum.EasingStyle.Circular, Enum.EasingDirection.In), {BackgroundColor3 = self.Colors.Secondary})
								self.OutlineColorTween:Play()
								delay(0.15, function()
									if setStateTime ~= self.LastSetStateTime then return end
									self:Paint()
									TweenSize(self.GuiElems.Checkmark, ud2o(0, 20), "Out", "Quad", 1/15, true)
								end)
							else
								self.GuiElems.Outline.BackgroundColor3 = self.Colors.Secondary
								self:Paint()
								self.GuiElems.Checkmark.Size = ud2o(0, 20)
							end
							self:Expand(anim)
						else
							self:Paint()
							self.GuiElems.Checkmark2.Visible = false
							self.GuiElems.Middle.Visible = self.Toggled == nil
						end
					end
				end

				local mt = {__index = funcs}

				local function new(style)
					local obj = setmetatable({
						Toggled = false,
						Disabled = false,
						OnInput = Lib.Signal.new(),
						Style = style or 0,
						Colors = {
							Background = c3(36,36,36),
							Primary = c3(49,176,230),
							Secondary = c3(25,25,25),
							Disabled = c3(64,64,64),
							DisabledBackground = c3(52,52,52),
							DisabledCheck = c3(80,80,80)
						}
					},mt)
					initGui(obj)
					return obj
				end

				local function fromFrame(frame)
					local obj = setmetatable({
						Toggled = false,
						Disabled = false,
						Colors = {
							Background = c3(36,36,36),
							Primary = c3(49,176,230),
							Secondary = c3(25,25,25),
							Disabled = c3(64,64,64),
							DisabledBackground = c3(52,52,52)
						}
					},mt)
					initGui(obj,frame)
					return obj
				end

				return {new = new, fromFrame}
			end)()

			Lib.BrickColorPicker = (function()
				local funcs = {}
				local paletteCount = 0
				local mouse = service.Players.LocalPlayer:GetMouse()
				local hexStartX = 4
				local hexSizeX = 27
				local hexTriangleStart = 1
				local hexTriangleSize = 8

				local bottomColors = {
					Color3.fromRGB(17,17,17),
					Color3.fromRGB(99,95,98),
					Color3.fromRGB(163,162,165),
					Color3.fromRGB(205,205,205),
					Color3.fromRGB(223,223,222),
					Color3.fromRGB(237,234,234),
					Color3.fromRGB(27,42,53),
					Color3.fromRGB(91,93,105),
					Color3.fromRGB(159,161,172),
					Color3.fromRGB(202,203,209),
					Color3.fromRGB(231,231,236),
					Color3.fromRGB(248,248,248)
				}

				local function isMouseInHexagon(hex, touchPos)
					local relativeX = touchPos.X - hex.AbsolutePosition.X
					local relativeY = touchPos.Y - hex.AbsolutePosition.Y
					if relativeX >= hexStartX and relativeX < hexStartX + hexSizeX then
						relativeX = relativeX - 4
						local relativeWidth = (13 - math.min(relativeX, 26 - relativeX)) / 13
						if relativeY >= hexTriangleStart + hexTriangleSize * relativeWidth and relativeY < hex.AbsoluteSize.Y - hexTriangleStart - hexTriangleSize * relativeWidth then
							return true
						end
					end
					return false
				end

				local function hexInput(self, hex, color)
					hex.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							if isMouseInHexagon(hex, input.Position) then
								self.OnSelect:Fire(color)
								self:Close()
							end
						end
					end)

					hex.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							if isMouseInHexagon(hex, input.Position) then
								self.OnPreview:Fire(color)
							end
						end
					end)
				end

				local function createGui(self)
					local gui = create({
						{1,"ScreenGui",{Name="BrickColor",}},
						{2,"Frame",{Active=true,BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderColor3=Color3.new(0.1294117718935,0.1294117718935,0.1294117718935),Parent={1},Position=UDim2.new(0.40000000596046,0,0.40000000596046,0),Size=UDim2.new(0,337,0,380),}},
						{3,"TextButton",{BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),BorderSizePixel=0,Font=3,Name="MoreColors",Parent={2},Position=UDim2.new(0,5,1,-30),Size=UDim2.new(1,-10,0,25),Text="More Colors",TextColor3=Color3.new(1,1,1),TextSize=14,}},
						{4,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxassetid://1281023007",ImageColor3=Color3.new(0.33333334326744,0.33333334326744,0.49803924560547),Name="Hex",Parent={2},Size=UDim2.new(0,35,0,35),Visible=false,}},
					})
					local colorFrame = gui.Frame
					local hex = colorFrame.Hex

					for row = 1,13 do
						local columns = math.min(row,14-row)+6
						for column = 1,columns do
							local nextColor = BrickColor.palette(paletteCount).Color
							local newHex = hex:Clone()
							newHex.Position = UDim2.new(0, (column-1)*25-(columns-7)*13+3*26 + 1, 0, (row-1)*23 + 4)
							newHex.ImageColor3 = nextColor
							newHex.Visible = true
							hexInput(self,newHex,nextColor)
							newHex.Parent = colorFrame
							paletteCount = paletteCount + 1
						end
					end

					for column = 1,12 do
						local nextColor = bottomColors[column]
						local newHex = hex:Clone()
						newHex.Position = UDim2.new(0, (column-1)*25-(12-7)*13+3*26 + 3, 0, 308)
						newHex.ImageColor3 = nextColor
						newHex.Visible = true
						hexInput(self,newHex,nextColor)
						newHex.Parent = colorFrame
						paletteCount = paletteCount + 1
					end

					colorFrame.MoreColors.MouseButton1Click:Connect(function()
						self.OnMoreColors:Fire()
						self:Close()
					end)

					self.Gui = gui
				end

				funcs.SetMoreColorsVisible = function(self,vis)
					local colorFrame = self.Gui.Frame
					colorFrame.Size = UDim2.new(0,337,0,380 - (not vis and 33 or 0))
					colorFrame.MoreColors.Visible = vis
				end

				funcs.Show = function(self,x,y,prevColor)
					self.PrevColor = prevColor or self.PrevColor

					local reverseY = false

					local x,y = x or mouse.X, y or mouse.Y
					local maxX,maxY = mouse.ViewSizeX,mouse.ViewSizeY
					Lib.ShowGui(self.Gui)
					local sizeX,sizeY = self.Gui.Frame.AbsoluteSize.X,self.Gui.Frame.AbsoluteSize.Y

					if x + sizeX > maxX then x = self.ReverseX and x - sizeX or maxX - sizeX end
					if y + sizeY > maxY then reverseY = true end

					local closable = false
					if self.CloseEvent then self.CloseEvent:Disconnect() end

					self.CloseEvent = service.UserInputService.InputBegan:Connect(function(input)
						if not closable or (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch) then
							return
						end

						if not Lib.CheckMouseInGui(self.Gui.Frame) then
							self.CloseEvent:Disconnect()
							self:Close()
						end
					end)


					if reverseY then
						local newY = y - sizeY - (self.ReverseYOffset or 0)
						y = newY >= 0 and newY or 0
					end

					self.Gui.Frame.Position = UDim2.new(0,x,0,y)

					Lib.FastWait()
					closable = true
				end

				funcs.Close = function(self)
					self.Gui.Parent = nil
					self.OnCancel:Fire()
				end

				local mt = {__index = funcs}

				local function new()
					local obj = setmetatable({
						OnPreview = Lib.Signal.new(),
						OnSelect = Lib.Signal.new(),
						OnCancel = Lib.Signal.new(),
						OnMoreColors = Lib.Signal.new(),
						PrevColor = Color3.new(0,0,0)
					}, mt)
					createGui(obj)
					return obj
				end

				return {new = new}
			end)()

			Lib.ColorPicker = (function() -- TODO: Convert to newer class model
				local funcs = {}

				local function new()
					local newMt = setmetatable({},{})

					newMt.OnSelect = Lib.Signal.new()
					newMt.OnCancel = Lib.Signal.new()
					newMt.OnPreview = Lib.Signal.new()

					local guiContents = create({
						{1,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,ClipsDescendants=true,Name="Content",Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,1,-20),}},
						{2,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="BasicColors",Parent={1},Position=UDim2.new(0,5,0,5),Size=UDim2.new(0,180,0,200),}},
						{3,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={2},Position=UDim2.new(0,0,0,-5),Size=UDim2.new(1,0,0,26),Text="Basic Colors",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{4,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Blue",Parent={1},Position=UDim2.new(1,-63,0,255),Size=UDim2.new(0,52,0,16),}},
						{5,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Font=3,Name="Input",Parent={4},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,50,0,16),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{6,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={5},Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,16,1,0),}},
						{7,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Up",Parent={6},Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{8,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={7},Size=UDim2.new(0,16,0,8),}},
						{9,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={8},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,1),}},
						{10,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={8},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{11,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={8},Position=UDim2.new(0,6,0,5),Size=UDim2.new(0,5,0,1),}},
						{12,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Down",Parent={6},Position=UDim2.new(0,0,0,8),Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{13,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={12},Size=UDim2.new(0,16,0,8),}},
						{14,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={13},Position=UDim2.new(0,8,0,5),Size=UDim2.new(0,1,0,1),}},
						{15,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={13},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{16,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={13},Position=UDim2.new(0,6,0,3),Size=UDim2.new(0,5,0,1),}},
						{17,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={4},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Blue:",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{18,"Frame",{BackgroundColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),BorderSizePixel=0,ClipsDescendants=true,Name="ColorSpaceFrame",Parent={1},Position=UDim2.new(1,-261,0,4),Size=UDim2.new(0,222,0,202),}},
						{19,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),BorderSizePixel=0,Image="rbxassetid://1072518406",Name="ColorSpace",Parent={18},Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,220,0,200),}},
						{20,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="Scope",Parent={19},Position=UDim2.new(0,210,0,190),Size=UDim2.new(0,20,0,20),}},
						{21,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Name="Line",Parent={20},Position=UDim2.new(0,9,0,0),Size=UDim2.new(0,2,0,20),}},
						{22,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Name="Line",Parent={20},Position=UDim2.new(0,0,0,9),Size=UDim2.new(0,20,0,2),}},
						{23,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="CustomColors",Parent={1},Position=UDim2.new(0,5,0,210),Size=UDim2.new(0,180,0,90),}},
						{24,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={23},Size=UDim2.new(1,0,0,20),Text="Custom Colors (RC = Set)",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{25,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Green",Parent={1},Position=UDim2.new(1,-63,0,233),Size=UDim2.new(0,52,0,16),}},
						{26,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Font=3,Name="Input",Parent={25},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,50,0,16),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{27,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={26},Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,16,1,0),}},
						{28,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Up",Parent={27},Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{29,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={28},Size=UDim2.new(0,16,0,8),}},
						{30,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={29},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,1),}},
						{31,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={29},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{32,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={29},Position=UDim2.new(0,6,0,5),Size=UDim2.new(0,5,0,1),}},
						{33,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Down",Parent={27},Position=UDim2.new(0,0,0,8),Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{34,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={33},Size=UDim2.new(0,16,0,8),}},
						{35,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={34},Position=UDim2.new(0,8,0,5),Size=UDim2.new(0,1,0,1),}},
						{36,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={34},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{37,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={34},Position=UDim2.new(0,6,0,3),Size=UDim2.new(0,5,0,1),}},
						{38,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={25},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Green:",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{39,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Hue",Parent={1},Position=UDim2.new(1,-180,0,211),Size=UDim2.new(0,52,0,16),}},
						{40,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Font=3,Name="Input",Parent={39},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,50,0,16),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{41,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={40},Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,16,1,0),}},
						{42,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Up",Parent={41},Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{43,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={42},Size=UDim2.new(0,16,0,8),}},
						{44,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={43},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,1),}},
						{45,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={43},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{46,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={43},Position=UDim2.new(0,6,0,5),Size=UDim2.new(0,5,0,1),}},
						{47,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Down",Parent={41},Position=UDim2.new(0,0,0,8),Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{48,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={47},Size=UDim2.new(0,16,0,8),}},
						{49,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={48},Position=UDim2.new(0,8,0,5),Size=UDim2.new(0,1,0,1),}},
						{50,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={48},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{51,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={48},Position=UDim2.new(0,6,0,3),Size=UDim2.new(0,5,0,1),}},
						{52,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={39},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Hue:",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{53,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Name="Preview",Parent={1},Position=UDim2.new(1,-260,0,211),Size=UDim2.new(0,35,1,-245),}},
						{54,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Red",Parent={1},Position=UDim2.new(1,-63,0,211),Size=UDim2.new(0,52,0,16),}},
						{55,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Font=3,Name="Input",Parent={54},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,50,0,16),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{56,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={55},Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,16,1,0),}},
						{57,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Up",Parent={56},Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{58,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={57},Size=UDim2.new(0,16,0,8),}},
						{59,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={58},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,1),}},
						{60,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={58},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{61,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={58},Position=UDim2.new(0,6,0,5),Size=UDim2.new(0,5,0,1),}},
						{62,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Down",Parent={56},Position=UDim2.new(0,0,0,8),Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{63,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={62},Size=UDim2.new(0,16,0,8),}},
						{64,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={63},Position=UDim2.new(0,8,0,5),Size=UDim2.new(0,1,0,1),}},
						{65,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={63},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{66,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={63},Position=UDim2.new(0,6,0,3),Size=UDim2.new(0,5,0,1),}},
						{67,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={54},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Red:",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{68,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Sat",Parent={1},Position=UDim2.new(1,-180,0,233),Size=UDim2.new(0,52,0,16),}},
						{69,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Font=3,Name="Input",Parent={68},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,50,0,16),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{70,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={69},Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,16,1,0),}},
						{71,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Up",Parent={70},Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{72,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={71},Size=UDim2.new(0,16,0,8),}},
						{73,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={72},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,1),}},
						{74,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={72},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{75,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={72},Position=UDim2.new(0,6,0,5),Size=UDim2.new(0,5,0,1),}},
						{76,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Down",Parent={70},Position=UDim2.new(0,0,0,8),Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{77,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={76},Size=UDim2.new(0,16,0,8),}},
						{78,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={77},Position=UDim2.new(0,8,0,5),Size=UDim2.new(0,1,0,1),}},
						{79,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={77},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{80,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={77},Position=UDim2.new(0,6,0,3),Size=UDim2.new(0,5,0,1),}},
						{81,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={68},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Sat:",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{82,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Val",Parent={1},Position=UDim2.new(1,-180,0,255),Size=UDim2.new(0,52,0,16),}},
						{83,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Font=3,Name="Input",Parent={82},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,50,0,16),Text="255",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{84,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={83},Position=UDim2.new(1,-16,0,0),Size=UDim2.new(0,16,1,0),}},
						{85,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Up",Parent={84},Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{86,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={85},Size=UDim2.new(0,16,0,8),}},
						{87,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={86},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,1),}},
						{88,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={86},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{89,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={86},Position=UDim2.new(0,6,0,5),Size=UDim2.new(0,5,0,1),}},
						{90,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="Down",Parent={84},Position=UDim2.new(0,0,0,8),Size=UDim2.new(1,0,0,8),Text="",TextSize=14,}},
						{91,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={90},Size=UDim2.new(0,16,0,8),}},
						{92,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={91},Position=UDim2.new(0,8,0,5),Size=UDim2.new(0,1,0,1),}},
						{93,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={91},Position=UDim2.new(0,7,0,4),Size=UDim2.new(0,3,0,1),}},
						{94,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={91},Position=UDim2.new(0,6,0,3),Size=UDim2.new(0,5,0,1),}},
						{95,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={82},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Val:",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{96,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Font=3,Name="Cancel",Parent={1},Position=UDim2.new(1,-105,1,-28),Size=UDim2.new(0,100,0,25),Text="Cancel",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{97,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Font=3,Name="Ok",Parent={1},Position=UDim2.new(1,-210,1,-28),Size=UDim2.new(0,100,0,25),Text="OK",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{98,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Image="rbxassetid://1072518502",Name="ColorStrip",Parent={1},Position=UDim2.new(1,-30,0,5),Size=UDim2.new(0,13,0,200),}},
						{99,"Frame",{BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=1,BorderSizePixel=0,Name="ArrowFrame",Parent={1},Position=UDim2.new(1,-16,0,1),Size=UDim2.new(0,5,0,208),}},
						{100,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={99},Position=UDim2.new(0,-2,0,-4),Size=UDim2.new(0,8,0,16),}},
						{101,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Parent={100},Position=UDim2.new(0,2,0,8),Size=UDim2.new(0,1,0,1),}},
						{102,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Parent={100},Position=UDim2.new(0,3,0,7),Size=UDim2.new(0,1,0,3),}},
						{103,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Parent={100},Position=UDim2.new(0,4,0,6),Size=UDim2.new(0,1,0,5),}},
						{104,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Parent={100},Position=UDim2.new(0,5,0,5),Size=UDim2.new(0,1,0,7),}},
						{105,"Frame",{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Parent={100},Position=UDim2.new(0,6,0,4),Size=UDim2.new(0,1,0,9),}},
					})
					local window = Lib.Window.new()
					window.Resizable = false
					window.Alignable = false
					window:SetTitle("Color Picker")
					window:Resize(450,330)
					for i,v in pairs(guiContents:GetChildren()) do
						v.Parent = window.GuiElems.Content
					end
					newMt.Window = window
					newMt.Gui = window.Gui
					local pickerGui = window.Gui.Main
					local pickerTopBar = pickerGui.TopBar
					local pickerFrame = pickerGui.Content
					local colorSpace = pickerFrame.ColorSpaceFrame.ColorSpace
					local colorStrip = pickerFrame.ColorStrip
					local previewFrame = pickerFrame.Preview
					local basicColorsFrame = pickerFrame.BasicColors
					local customColorsFrame = pickerFrame.CustomColors
					local okButton = pickerFrame.Ok
					local cancelButton = pickerFrame.Cancel
					local closeButton = pickerTopBar.Close

					local colorScope = colorSpace.Scope
					local colorArrow = pickerFrame.ArrowFrame.Arrow

					local hueInput = pickerFrame.Hue.Input
					local satInput = pickerFrame.Sat.Input
					local valInput = pickerFrame.Val.Input

					local redInput = pickerFrame.Red.Input
					local greenInput = pickerFrame.Green.Input
					local blueInput = pickerFrame.Blue.Input

					local user = service.UserInputService
					local mouse = service.Players.LocalPlayer:GetMouse()

					local hue,sat,val = 0,0,1
					local red,green,blue = 1,1,1
					local chosenColor = Color3.new(0,0,0)

					local basicColors = {Color3.new(0,0,0),Color3.new(0.66666668653488,0,0),Color3.new(0,0.33333334326744,0),Color3.new(0.66666668653488,0.33333334326744,0),Color3.new(0,0.66666668653488,0),Color3.new(0.66666668653488,0.66666668653488,0),Color3.new(0,1,0),Color3.new(0.66666668653488,1,0),Color3.new(0,0,0.49803924560547),Color3.new(0.66666668653488,0,0.49803924560547),Color3.new(0,0.33333334326744,0.49803924560547),Color3.new(0.66666668653488,0.33333334326744,0.49803924560547),Color3.new(0,0.66666668653488,0.49803924560547),Color3.new(0.66666668653488,0.66666668653488,0.49803924560547),Color3.new(0,1,0.49803924560547),Color3.new(0.66666668653488,1,0.49803924560547),Color3.new(0,0,1),Color3.new(0.66666668653488,0,1),Color3.new(0,0.33333334326744,1),Color3.new(0.66666668653488,0.33333334326744,1),Color3.new(0,0.66666668653488,1),Color3.new(0.66666668653488,0.66666668653488,1),Color3.new(0,1,1),Color3.new(0.66666668653488,1,1),Color3.new(0.33333334326744,0,0),Color3.new(1,0,0),Color3.new(0.33333334326744,0.33333334326744,0),Color3.new(1,0.33333334326744,0),Color3.new(0.33333334326744,0.66666668653488,0),Color3.new(1,0.66666668653488,0),Color3.new(0.33333334326744,1,0),Color3.new(1,1,0),Color3.new(0.33333334326744,0,0.49803924560547),Color3.new(1,0,0.49803924560547),Color3.new(0.33333334326744,0.33333334326744,0.49803924560547),Color3.new(1,0.33333334326744,0.49803924560547),Color3.new(0.33333334326744,0.66666668653488,0.49803924560547),Color3.new(1,0.66666668653488,0.49803924560547),Color3.new(0.33333334326744,1,0.49803924560547),Color3.new(1,1,0.49803924560547),Color3.new(0.33333334326744,0,1),Color3.new(1,0,1),Color3.new(0.33333334326744,0.33333334326744,1),Color3.new(1,0.33333334326744,1),Color3.new(0.33333334326744,0.66666668653488,1),Color3.new(1,0.66666668653488,1),Color3.new(0.33333334326744,1,1),Color3.new(1,1,1)}
					local customColors = {}

					local function updateColor(noupdate)
						local relativeX, relativeY, relativeStripY = 219 - hue * 219, 199 - sat * 199, 199 - val * 199
						local hsvColor = Color3.fromHSV(hue, sat, val)

						if noupdate == 2 or not noupdate then
							hueInput.Text = tostring(math.ceil(359 * hue))
							satInput.Text = tostring(math.ceil(255 * sat))
							valInput.Text = tostring(math.floor(255 * val))
						end
						if noupdate == 1 or not noupdate then
							redInput.Text = tostring(math.floor(255 * red))
							greenInput.Text = tostring(math.floor(255 * green))
							blueInput.Text = tostring(math.floor(255 * blue))
						end

						chosenColor = Color3.new(red, green, blue)
						colorScope.Position = UDim2.new(0, (relativeX - 9), 0, (relativeY - 9))
						colorStrip.ImageColor3 = Color3.fromHSV(hue, sat, 1)
						colorArrow.Position = UDim2.new(0, -2, 0, (relativeStripY - 4))
						previewFrame.BackgroundColor3 = chosenColor

						newMt.Color = chosenColor
						newMt.OnPreview:Fire(chosenColor)
					end

					local function handleInputBegan(input, updateFunc)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							while user:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
								updateFunc()task.wait()
							end
						end
					end

					local function colorSpaceInput()
						local relativeX = mouse.X - colorSpace.AbsolutePosition.X
						local relativeY = mouse.Y - colorSpace.AbsolutePosition.Y

						if relativeX < 0 then relativeX = 0 elseif relativeX > 219 then relativeX = 219 end
						if relativeY < 0 then relativeY = 0 elseif relativeY > 199 then relativeY = 199 end

						hue = (219 - relativeX) / 219
						sat = (199 - relativeY) / 199

						local hsvColor = Color3.fromHSV(hue, sat, val)
						red, green, blue = hsvColor.R, hsvColor.G, hsvColor.B
						updateColor()
					end

					local function colorStripInput()
						local relativeY = mouse.Y - colorStrip.AbsolutePosition.Y

						if relativeY < 0 then relativeY = 0 elseif relativeY > 199 then relativeY = 199 end	

						val = (199 - relativeY) / 199

						local hsvColor = Color3.fromHSV(hue, sat, val)
						red, green, blue = hsvColor.R, hsvColor.G, hsvColor.B
						updateColor()
					end

					colorSpace.InputBegan:Connect(function(input) handleInputBegan(input, colorSpaceInput) end)
					colorStrip.InputBegan:Connect(function(input) handleInputBegan(input, colorStripInput) end)

					local function hookButtons(frame, func)
						frame.ArrowFrame.Up.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								local releaseEvent, runEvent
								local startTime = tick()
								local pressing = true
								local startNum = tonumber(frame.Text)

								if not startNum then return end

								releaseEvent = user.InputEnded:Connect(function(endInput)
									if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
										releaseEvent:Disconnect()
										pressing = false
									end
								end)

								startNum = startNum + 1
								func(startNum)
								while pressing do
									if tick() - startTime > 0.3 then
										startNum = startNum + 1
										func(startNum)
										startTime = tick()
									end
									task.wait(0.1)
								end
							end
						end)

						frame.ArrowFrame.Down.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								local releaseEvent, runEvent
								local startTime = tick()
								local pressing = true
								local startNum = tonumber(frame.Text)

								if not startNum then return end

								releaseEvent = user.InputEnded:Connect(function(endInput)
									if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
										releaseEvent:Disconnect()
										pressing = false
									end
								end)

								startNum = startNum - 1
								func(startNum)
								while pressing do
									if tick() - startTime > 0.3 then
										startNum = startNum - 1
										func(startNum)
										startTime = tick()
									end
									task.wait(0.1)
								end
							end
						end)
					end

			--[[local function UpdateBox(TextBox, Value, IsHSV, ...)
				local number = tonumber(TextBox.Text)
				if number then
					number = math.clamp(math.floor(number), 0, Value) / Value
					local HSV = Color3.fromHSV(func(number))
					red, green, blue = HSV.R, HSV.G, HSV.B
					
					TextBox.Text = tostring(number):sub(4)
					updateColor(IsHSV)
				end
			end]]

					local function updateHue(str)
						local num = tonumber(str)
						if num then
							hue = math.clamp(math.floor(num),0,359)/359
							local hsvColor = Color3.fromHSV(hue,sat,val)
							red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b

							hueInput.Text = tostring(hue*359)
							updateColor(1)
						end
					end
					hueInput.FocusLost:Connect(function() updateHue(hueInput.Text) end) hookButtons(hueInput, hueInput)

					local function updateSat(str)
						local num = tonumber(str)
						if num then
							sat = math.clamp(math.floor(num),0,255)/255
							local hsvColor = Color3.fromHSV(hue,sat,val)
							red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b
							satInput.Text = tostring(sat*255)
							updateColor(1)
						end
					end
					satInput.FocusLost:Connect(function() updateSat(satInput.Text) end) hookButtons(satInput,updateSat)

					local function updateVal(str)
						local num = tonumber(str)
						if num then
							val = math.clamp(math.floor(num),0,255)/255
							local hsvColor = Color3.fromHSV(hue,sat,val)
							red,green,blue = hsvColor.r,hsvColor.g,hsvColor.b
							valInput.Text = tostring(val*255)
							updateColor(1)
						end
					end
					valInput.FocusLost:Connect(function() updateVal(valInput.Text) end) hookButtons(valInput,updateVal)

					local function updateRed(str)
						local num = tonumber(str)
						if num then
							red = math.clamp(math.floor(num),0,255)/255
							local newColor = Color3.new(red,green,blue)
							hue,sat,val = Color3.toHSV(newColor)
							redInput.Text = tostring(red*255)
							updateColor(2)
						end
					end
					redInput.FocusLost:Connect(function() updateRed(redInput.Text) end) hookButtons(redInput,updateRed)

					local function updateGreen(str)
						local num = tonumber(str)
						if num then
							green = math.clamp(math.floor(num),0,255)/255
							local newColor = Color3.new(red,green,blue)
							hue,sat,val = Color3.toHSV(newColor)
							greenInput.Text = tostring(green*255)
							updateColor(2)
						end
					end
					greenInput.FocusLost:Connect(function() updateGreen(greenInput.Text) end) hookButtons(greenInput,updateGreen)

					local function updateBlue(str)
						local num = tonumber(str)
						if num then
							blue = math.clamp(math.floor(num),0,255)/255
							local newColor = Color3.new(red,green,blue)
							hue,sat,val = Color3.toHSV(newColor)
							blueInput.Text = tostring(blue*255)
							updateColor(2)
						end
					end
					blueInput.FocusLost:Connect(function() updateBlue(blueInput.Text) end) hookButtons(blueInput,updateBlue)

					local colorChoice = Instance.new("TextButton")
					colorChoice.Name = "Choice"
					colorChoice.Size = UDim2.new(0,25,0,18)
					colorChoice.BorderColor3 = Color3.fromRGB(55,55,55)
					colorChoice.Text = ""
					colorChoice.AutoButtonColor = false

					local row = 0
					local column = 0
					for i,v in pairs(basicColors) do
						local newColor = colorChoice:Clone()
						newColor.BackgroundColor3 = v
						newColor.Position = UDim2.new(0,1 + 30*column,0,21 + 23*row)

						newColor.MouseButton1Click:Connect(function()
							red,green,blue = v.r,v.g,v.b
							local newColor = Color3.new(red,green,blue)
							hue,sat,val = Color3.toHSV(newColor)
							updateColor()
						end)

						newColor.Parent = basicColorsFrame
						column = column + 1
						if column == 6 then row = row + 1 column = 0 end
					end

					row = 0
					column = 0
					for i = 1,12 do
						local color = customColors[i] or Color3.new(0,0,0)
						local newColor = colorChoice:Clone()
						newColor.BackgroundColor3 = color
						newColor.Position = UDim2.new(0,1 + 30*column,0,20 + 23*row)

						newColor.MouseButton1Click:Connect(function()
							local curColor = customColors[i] or Color3.new(0,0,0)
							red,green,blue = curColor.r,curColor.g,curColor.b
							hue,sat,val = Color3.toHSV(curColor)
							updateColor()
						end)

						newColor.MouseButton2Click:Connect(function()
							customColors[i] = chosenColor
							newColor.BackgroundColor3 = chosenColor
						end)

						newColor.Parent = customColorsFrame
						column = column + 1
						if column == 6 then row = row + 1 column = 0 end
					end

					okButton.MouseButton1Click:Connect(function() newMt.OnSelect:Fire(chosenColor) window:Close() end)
					okButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then okButton.BackgroundTransparency = 0.4 end end)
					okButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then okButton.BackgroundTransparency = 0 end end)


					cancelButton.MouseButton1Click:Connect(function() newMt.OnCancel:Fire() window:Close() end)
					cancelButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then cancelButton.BackgroundTransparency = 0.4 end end)
					cancelButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then cancelButton.BackgroundTransparency = 0 end end)

					updateColor()

					newMt.SetColor = function(self,color)
						red,green,blue = color.r,color.g,color.b
						hue,sat,val = Color3.toHSV(color)
						updateColor()
					end

					newMt.Show = function(self)
						self.Window:Show()
					end

					return newMt
				end

				return {new = new}
			end)()

			Lib.NumberSequenceEditor = (function()
				local function new() -- TODO: Convert to newer class model
					local newMt = setmetatable({},{})
					newMt.OnSelect = Lib.Signal.new()
					newMt.OnCancel = Lib.Signal.new()
					newMt.OnPreview = Lib.Signal.new()

					local guiContents = create({
						{1,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,ClipsDescendants=true,Name="Content",Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,1,-20),}},
						{2,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Time",Parent={1},Position=UDim2.new(0,40,0,210),Size=UDim2.new(0,60,0,20),}},
						{3,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),ClipsDescendants=true,Font=3,Name="Input",Parent={2},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,58,0,20),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{4,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={2},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Time",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{5,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Font=3,Name="Close",Parent={1},Position=UDim2.new(1,-90,0,210),Size=UDim2.new(0,80,0,20),Text="Close",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{6,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Font=3,Name="Reset",Parent={1},Position=UDim2.new(1,-180,0,210),Size=UDim2.new(0,80,0,20),Text="Reset",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{7,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Font=3,Name="Delete",Parent={1},Position=UDim2.new(0,380,0,210),Size=UDim2.new(0,80,0,20),Text="Delete",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{8,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Name="NumberLineOutlines",Parent={1},Position=UDim2.new(0,10,0,20),Size=UDim2.new(1,-20,0,170),}},
						{9,"Frame",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),Name="NumberLine",Parent={1},Position=UDim2.new(0,10,0,20),Size=UDim2.new(1,-20,0,170),}},
						{10,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Value",Parent={1},Position=UDim2.new(0,170,0,210),Size=UDim2.new(0,60,0,20),}},
						{11,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={10},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Value",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{12,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),ClipsDescendants=true,Font=3,Name="Input",Parent={10},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,58,0,20),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{13,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Envelope",Parent={1},Position=UDim2.new(0,300,0,210),Size=UDim2.new(0,60,0,20),}},
						{14,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),ClipsDescendants=true,Font=3,Name="Input",Parent={13},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,58,0,20),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{15,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={13},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Envelope",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
					})
					local window = Lib.Window.new()
					window.Resizable = false
					window:Resize(680,265)
					window:SetTitle("NumberSequence Editor")
					newMt.Window = window
					newMt.Gui = window.Gui
					for i,v in pairs(guiContents:GetChildren()) do
						v.Parent = window.GuiElems.Content
					end
					local gui = window.Gui
					local pickerGui = gui.Main
					local pickerTopBar = pickerGui.TopBar
					local pickerFrame = pickerGui.Content
					local numberLine = pickerFrame.NumberLine
					local numberLineOutlines = pickerFrame.NumberLineOutlines
					local timeBox = pickerFrame.Time.Input
					local valueBox = pickerFrame.Value.Input
					local envelopeBox = pickerFrame.Envelope.Input
					local deleteButton = pickerFrame.Delete
					local resetButton = pickerFrame.Reset
					local closeButton = pickerFrame.Close
					local topClose = pickerTopBar.Close

					local points = {{1,0,3},{8,0.05,1},{5,0.6,2},{4,0.7,4},{6,1,4}}
					local lines = {}
					local eLines = {}
					local beginPoint = points[1]
					local endPoint = points[#points]
					local currentlySelected = nil
					local currentPoint = nil
					local resetSequence = nil

					local user = service.UserInputService
					local mouse = service.Players.LocalPlayer:GetMouse()

					for i = 2,10 do
						local newLine = Instance.new("Frame")
						newLine.BackgroundTransparency = 0.5
						newLine.BackgroundColor3 = Color3.new(96/255,96/255,96/255)
						newLine.BorderSizePixel = 0
						newLine.Size = UDim2.new(0,1,1,0)
						newLine.Position = UDim2.new((i-1)/(11-1),0,0,0)
						newLine.Parent = numberLineOutlines
					end

					for i = 2,4 do
						local newLine = Instance.new("Frame")
						newLine.BackgroundTransparency = 0.5
						newLine.BackgroundColor3 = Color3.new(96/255,96/255,96/255)
						newLine.BorderSizePixel = 0
						newLine.Size = UDim2.new(1,0,0,1)
						newLine.Position = UDim2.new(0,0,(i-1)/(5-1),0)
						newLine.Parent = numberLineOutlines
					end

					local lineTemp = Instance.new("Frame")
					lineTemp.BackgroundColor3 = Color3.new(0,0,0)
					lineTemp.BorderSizePixel = 0
					lineTemp.Size = UDim2.new(0,1,0,1)

					local sequenceLine = Instance.new("Frame")
					sequenceLine.BackgroundColor3 = Color3.new(0,0,0)
					sequenceLine.BorderSizePixel = 0
					sequenceLine.Size = UDim2.new(0,1,0,0)

					for i = 1,numberLine.AbsoluteSize.X do
						local line = sequenceLine:Clone()
						eLines[i] = line
						line.Name = "E"..tostring(i)
						line.BackgroundTransparency = 0.5
						line.BackgroundColor3 = Color3.new(199/255,44/255,28/255)
						line.Position = UDim2.new(0,i-1,0,0)
						line.Parent = numberLine
					end

					for i = 1,numberLine.AbsoluteSize.X do
						local line = sequenceLine:Clone()
						lines[i] = line
						line.Name = tostring(i)
						line.Position = UDim2.new(0,i-1,0,0)
						line.Parent = numberLine
					end

					local envelopeDrag = Instance.new("Frame")
					envelopeDrag.BackgroundTransparency = 1
					envelopeDrag.BackgroundColor3 = Color3.new(0,0,0)
					envelopeDrag.BorderSizePixel = 0
					envelopeDrag.Size = UDim2.new(0,7,0,20)
					envelopeDrag.Visible = false
					envelopeDrag.ZIndex = 2
					local envelopeDragLine = Instance.new("Frame",envelopeDrag)
					envelopeDragLine.Name = "Line"
					envelopeDragLine.BackgroundColor3 = Color3.new(0,0,0)
					envelopeDragLine.BorderSizePixel = 0
					envelopeDragLine.Position = UDim2.new(0,3,0,0)
					envelopeDragLine.Size = UDim2.new(0,1,0,20)
					envelopeDragLine.ZIndex = 2

					local envelopeDragTop,envelopeDragBottom = envelopeDrag:Clone(),envelopeDrag:Clone()
					envelopeDragTop.Parent = numberLine
					envelopeDragBottom.Parent = numberLine

					local function buildSequence()
						local newPoints = {}
						for i,v in pairs(points) do
							table.insert(newPoints,NumberSequenceKeypoint.new(v[2],v[1],v[3]))
						end
						newMt.Sequence = NumberSequence.new(newPoints)
						newMt.OnSelect:Fire(newMt.Sequence)
					end

					local function round(num,places)
						local multi = 10^places
						return math.floor(num*multi + 0.5)/multi
					end

					local function updateInputs(point)
						if point then
							currentPoint = point
							local rawT,rawV,rawE = point[2],point[1],point[3]
							timeBox.Text = round(rawT,(rawT < 0.01 and 5) or (rawT < 0.1 and 4) or 3)
							valueBox.Text = round(rawV,(rawV < 0.01 and 5) or (rawV < 0.1 and 4) or (rawV < 1 and 3) or 2)
							envelopeBox.Text = round(rawE,(rawE < 0.01 and 5) or (rawE < 0.1 and 4) or (rawV < 1 and 3) or 2)

							local envelopeDistance = numberLine.AbsoluteSize.Y*(point[3]/10)
							envelopeDragTop.Position = UDim2.new(0,point[4].Position.X.Offset-1,0,point[4].Position.Y.Offset-envelopeDistance-17)
							envelopeDragTop.Visible = true
							envelopeDragBottom.Position = UDim2.new(0,point[4].Position.X.Offset-1,0,point[4].Position.Y.Offset+envelopeDistance+2)
							envelopeDragBottom.Visible = true
						end
					end

					envelopeDragTop.InputBegan:Connect(function(input)
						if (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch) or not currentPoint or Lib.CheckMouseInGui(currentPoint[4].Select) then return end

						local mouseEvent, releaseEvent
						local maxSize = numberLine.AbsoluteSize.Y
						local mouseDelta = math.abs(envelopeDragTop.AbsolutePosition.Y - mouse.Y)

						envelopeDragTop.Line.Position = UDim2.new(0, 2, 0, 0)
						envelopeDragTop.Line.Size = UDim2.new(0, 3, 0, 20)

						releaseEvent = user.InputEnded:Connect(function(input)
							if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
							mouseEvent:Disconnect()
							releaseEvent:Disconnect()
							envelopeDragTop.Line.Position = UDim2.new(0, 3, 0, 0)
							envelopeDragTop.Line.Size = UDim2.new(0, 1, 0, 20)
						end)

						mouseEvent = user.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								local topDiff = (currentPoint[4].AbsolutePosition.Y + 2) - (mouse.Y - mouseDelta) - 19
								local newEnvelope = 10 * (math.max(topDiff, 0) / maxSize)
								local maxEnvelope = math.min(currentPoint[1], 10 - currentPoint[1])
								currentPoint[3] = math.min(newEnvelope, maxEnvelope)
								newMt:Redraw()
								buildSequence()
								updateInputs(currentPoint)
							end
						end)
					end)

					envelopeDragBottom.InputBegan:Connect(function(input)
						if (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch) or not currentPoint or Lib.CheckMouseInGui(currentPoint[4].Select) then return end

						local mouseEvent, releaseEvent
						local maxSize = numberLine.AbsoluteSize.Y
						local mouseDelta = math.abs(envelopeDragBottom.AbsolutePosition.Y - mouse.Y)

						envelopeDragBottom.Line.Position = UDim2.new(0, 2, 0, 0)
						envelopeDragBottom.Line.Size = UDim2.new(0, 3, 0, 20)

						releaseEvent = user.InputEnded:Connect(function(input)
							if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
							mouseEvent:Disconnect()
							releaseEvent:Disconnect()
							envelopeDragBottom.Line.Position = UDim2.new(0, 3, 0, 0)
							envelopeDragBottom.Line.Size = UDim2.new(0, 1, 0, 20)
						end)

						mouseEvent = user.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								local bottomDiff = (mouse.Y + (20 - mouseDelta)) - (currentPoint[4].AbsolutePosition.Y + 2) - 19
								local newEnvelope = 10 * (math.max(bottomDiff, 0) / maxSize)
								local maxEnvelope = math.min(currentPoint[1], 10 - currentPoint[1])
								currentPoint[3] = math.min(newEnvelope, maxEnvelope)
								newMt:Redraw()
								buildSequence()
								updateInputs(currentPoint)
							end
						end)
					end)

					local function placePoint(point)
						local newPoint = Instance.new("Frame")
						newPoint.Name = "Point"
						newPoint.BorderSizePixel = 0
						newPoint.Size = UDim2.new(0,5,0,5)
						newPoint.Position = UDim2.new(0,math.floor((numberLine.AbsoluteSize.X-1) * point[2])-2,0,numberLine.AbsoluteSize.Y*(10-point[1])/10-2)
						newPoint.BackgroundColor3 = Color3.new(0,0,0)

						local newSelect = Instance.new("Frame")
						newSelect.Name = "Select"
						newSelect.BackgroundTransparency = 1
						newSelect.BackgroundColor3 = Color3.new(199/255,44/255,28/255)
						newSelect.Position = UDim2.new(0,-2,0,-2)
						newSelect.Size = UDim2.new(0,9,0,9)
						newSelect.Parent = newPoint

						newPoint.Parent = numberLine


						newSelect.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								for i, v in pairs(points) do 
									v[4].Select.BackgroundTransparency = 1 
								end

								newSelect.BackgroundTransparency = 0
								updateInputs(point)
							end

							if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not currentlySelected then
								currentPoint = point
								local mouseEvent, releaseEvent
								currentlySelected = true
								newSelect.BackgroundColor3 = Color3.new(249/255, 191/255, 59/255)

								local oldEnvelope = point[3]

								releaseEvent = user.InputEnded:Connect(function(input)
									if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then	return end

									mouseEvent:Disconnect()
									releaseEvent:Disconnect()
									currentlySelected = nil
									newSelect.BackgroundColor3 = Color3.new(199/255, 44/255, 28/255)
								end)

								mouseEvent = user.InputChanged:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										local maxX = numberLine.AbsoluteSize.X - 1
										local relativeX = (input.Position.X - numberLine.AbsolutePosition.X)
										if relativeX < 0 then relativeX = 0 end
										if relativeX > maxX then relativeX = maxX end

										local maxY = numberLine.AbsoluteSize.Y - 1
										local relativeY = (input.Position.Y - numberLine.AbsolutePosition.Y)
										if relativeY < 0 then relativeY = 0 end
										if relativeY > maxY then relativeY = maxY end

										if point ~= beginPoint and point ~= endPoint then
											point[2] = relativeX / maxX
										end

										point[1] = 10 - (relativeY / maxY) * 10
										local maxEnvelope = math.min(point[1], 10 - point[1])
										point[3] = math.min(oldEnvelope, maxEnvelope)
										newMt:Redraw()
										updateInputs(point)

										for i, v in pairs(points) do 
											v[4].Select.BackgroundTransparency = 1 
										end

										newSelect.BackgroundTransparency = 0
										buildSequence()
									end
								end)
							end
						end)

						return newPoint
					end

					local function placePoints()
						for i,v in pairs(points) do
							v[4] = placePoint(v)
						end
					end

					local function redraw(self)
						local numberLineSize = numberLine.AbsoluteSize
						table.sort(points,function(a,b) return a[2] < b[2] end)
						for i,v in pairs(points) do
							v[4].Position = UDim2.new(0,math.floor((numberLineSize.X-1) * v[2])-2,0,(numberLineSize.Y-1)*(10-v[1])/10-2)
						end
						lines[1].Size = UDim2.new(0,1,0,0)
						for i = 1,#points-1 do
							local fromPoint = points[i]
							local toPoint = points[i+1]
							local deltaY = toPoint[4].Position.Y.Offset-fromPoint[4].Position.Y.Offset
							local deltaX = toPoint[4].Position.X.Offset-fromPoint[4].Position.X.Offset
							local slope = deltaY/deltaX

							local fromEnvelope = fromPoint[3]
							local nextEnvelope = toPoint[3]

							local currentRise = math.abs(slope)
							local totalRise = 0
							local maxRise = math.abs(toPoint[4].Position.Y.Offset-fromPoint[4].Position.Y.Offset)

							for lineCount = math.min(fromPoint[4].Position.X.Offset+1,toPoint[4].Position.X.Offset),toPoint[4].Position.X.Offset do
								if deltaX == 0 and deltaY == 0 then return end
								local riseNow = math.floor(currentRise)
								local line = lines[lineCount+3]
								if line then
									if totalRise+riseNow > maxRise then riseNow = maxRise-totalRise end
									if math.sign(slope) == -1 then
										line.Position = UDim2.new(0,lineCount+2,0,fromPoint[4].Position.Y.Offset + -(totalRise+riseNow)+2)
									else
										line.Position = UDim2.new(0,lineCount+2,0,fromPoint[4].Position.Y.Offset + totalRise+2)
									end
									line.Size = UDim2.new(0,1,0,math.max(riseNow,1))
								end
								totalRise = totalRise + riseNow
								currentRise = currentRise - riseNow + math.abs(slope)

								local envPercent = (lineCount-fromPoint[4].Position.X.Offset)/(toPoint[4].Position.X.Offset-fromPoint[4].Position.X.Offset)
								local envLerp = fromEnvelope+(nextEnvelope-fromEnvelope)*envPercent
								local relativeSize = (envLerp/10)*numberLineSize.Y						

								local line = eLines[lineCount + 3]
								if line then
									line.Position = UDim2.new(0,lineCount+2,0,lines[lineCount+3].Position.Y.Offset-math.floor(relativeSize))
									line.Size = UDim2.new(0,1,0,math.floor(relativeSize*2))
								end
							end
						end
					end
					newMt.Redraw = redraw



					local function loadSequence(self,seq)
						resetSequence = seq
						for i,v in pairs(points) do if v[4] then v[4]:Destroy() end end
						points = {}
						for i,v in pairs(seq.Keypoints) do
							local maxEnvelope = math.min(v.Value,10-v.Value)
							local newPoint = {v.Value,v.Time,math.min(v.Envelope,maxEnvelope)}
							newPoint[4] = placePoint(newPoint)
							table.insert(points,newPoint)
						end
						beginPoint = points[1]
						endPoint = points[#points]
						currentlySelected = nil
						redraw()
						envelopeDragTop.Visible = false
						envelopeDragBottom.Visible = false
					end
					newMt.SetSequence = loadSequence

					timeBox.FocusLost:Connect(function()
						local point = currentPoint
						local num = tonumber(timeBox.Text)
						if point and num and point ~= beginPoint and point ~= endPoint then
							num = math.clamp(num,0,1)
							point[2] = num
							redraw()
							buildSequence()
							updateInputs(point)
						end
					end)

					valueBox.FocusLost:Connect(function()
						local point = currentPoint
						local num = tonumber(valueBox.Text)
						if point and num then
							local oldEnvelope = point[3]
							num = math.clamp(num,0,10)
							point[1] = num
							local maxEnvelope = math.min(point[1],10-point[1])
							point[3] = math.min(oldEnvelope,maxEnvelope)
							redraw()
							buildSequence()
							updateInputs(point)
						end
					end)

					envelopeBox.FocusLost:Connect(function()
						local point = currentPoint
						local num = tonumber(envelopeBox.Text)
						if point and num then
							num = math.clamp(num,0,5)
							local maxEnvelope = math.min(point[1],10-point[1])
							point[3] = math.min(num,maxEnvelope)
							redraw()
							buildSequence()
							updateInputs(point)
						end
					end)

					local function buttonAnimations(button,inverse)
						button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then button.BackgroundTransparency = (inverse and 0.5 or 0.4) end end)
						button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then button.BackgroundTransparency = (inverse and 1 or 0) end end)
					end

					numberLine.InputBegan:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #points < 20 then

							if Lib.CheckMouseInGui(envelopeDragTop) or Lib.CheckMouseInGui(envelopeDragBottom) then return end

							for i, v in pairs(points) do
								if Lib.CheckMouseInGui(v[4].Select) then
									return
								end
							end

							local maxX = numberLine.AbsoluteSize.X - 1
							local relativeX = (input.Position.X - numberLine.AbsolutePosition.X)
							if relativeX < 0 then relativeX = 0 end
							if relativeX > maxX then relativeX = maxX end

							local maxY = numberLine.AbsoluteSize.Y - 1
							local relativeY = (input.Position.Y - numberLine.AbsolutePosition.Y)
							if relativeY < 0 then relativeY = 0 end
							if relativeY > maxY then relativeY = maxY end

							local raw = relativeX / maxX
							local newPoint = {10 - (relativeY / maxY) * 10, raw, 0}
							newPoint[4] = placePoint(newPoint)
							table.insert(points, newPoint)
							redraw()
							buildSequence()
						end
					end)

					deleteButton.MouseButton1Click:Connect(function()
						if currentPoint and currentPoint ~= beginPoint and currentPoint ~= endPoint then
							for i,v in pairs(points) do
								if v == currentPoint then
									v[4]:Destroy()
									table.remove(points,i)
									break
								end
							end
							currentlySelected = nil
							redraw()
							buildSequence()
							updateInputs(points[1])
						end
					end)

					resetButton.MouseButton1Click:Connect(function()
						if resetSequence then
							newMt:SetSequence(resetSequence)
							buildSequence()
						end
					end)

					closeButton.MouseButton1Click:Connect(function()
						window:Close()
					end)

					buttonAnimations(deleteButton)
					buttonAnimations(resetButton)
					buttonAnimations(closeButton)

					placePoints()
					redraw()

					newMt.Show = function(self)
						window:Show()
					end

					return newMt
				end

				return {new = new}
			end)()

			Lib.ColorSequenceEditor = (function() -- TODO: Convert to newer class model
				local function new()
					local newMt = setmetatable({},{})
					newMt.OnSelect = Lib.Signal.new()
					newMt.OnCancel = Lib.Signal.new()
					newMt.OnPreview = Lib.Signal.new()
					newMt.OnPickColor = Lib.Signal.new()

					local guiContents = create({
						{1,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,ClipsDescendants=true,Name="Content",Position=UDim2.new(0,0,0,20),Size=UDim2.new(1,0,1,-20),}},
						{2,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Name="ColorLine",Parent={1},Position=UDim2.new(0,10,0,5),Size=UDim2.new(1,-20,0,70),}},
						{3,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Name="Gradient",Parent={2},Size=UDim2.new(1,0,1,0),}},
						{4,"UIGradient",{Parent={3},}},
						{5,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="Arrows",Parent={1},Position=UDim2.new(0,1,0,73),Size=UDim2.new(1,-2,0,16),}},
						{6,"Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.5,BorderSizePixel=0,Name="Cursor",Parent={1},Position=UDim2.new(0,10,0,0),Size=UDim2.new(0,1,0,80),}},
						{7,"Frame",{BackgroundColor3=Color3.new(0.14901961386204,0.14901961386204,0.14901961386204),BorderColor3=Color3.new(0.12549020349979,0.12549020349979,0.12549020349979),Name="Time",Parent={1},Position=UDim2.new(0,40,0,95),Size=UDim2.new(0,100,0,20),}},
						{8,"TextBox",{BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=1,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),ClipsDescendants=true,Font=3,Name="Input",Parent={7},Position=UDim2.new(0,2,0,0),Size=UDim2.new(0,98,0,20),Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=0,}},
						{9,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={7},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Time",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{10,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),Name="ColorBox",Parent={1},Position=UDim2.new(0,220,0,95),Size=UDim2.new(0,20,0,20),}},
						{11,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Title",Parent={10},Position=UDim2.new(0,-40,0,0),Size=UDim2.new(0,34,1,0),Text="Color",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,TextXAlignment=1,}},
						{12,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),BorderSizePixel=0,Font=3,Name="Close",Parent={1},Position=UDim2.new(1,-90,0,95),Size=UDim2.new(0,80,0,20),Text="Close",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{13,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),BorderSizePixel=0,Font=3,Name="Reset",Parent={1},Position=UDim2.new(1,-180,0,95),Size=UDim2.new(0,80,0,20),Text="Reset",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{14,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderColor3=Color3.new(0.21568627655506,0.21568627655506,0.21568627655506),BorderSizePixel=0,Font=3,Name="Delete",Parent={1},Position=UDim2.new(0,280,0,95),Size=UDim2.new(0,80,0,20),Text="Delete",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextSize=14,}},
						{15,"Frame",{BackgroundTransparency=1,Name="Arrow",Parent={1},Size=UDim2.new(0,16,0,16),Visible=false,}},
						{16,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={15},Position=UDim2.new(0,8,0,3),Size=UDim2.new(0,1,0,2),}},
						{17,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={15},Position=UDim2.new(0,7,0,5),Size=UDim2.new(0,3,0,2),}},
						{18,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={15},Position=UDim2.new(0,6,0,7),Size=UDim2.new(0,5,0,2),}},
						{19,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={15},Position=UDim2.new(0,5,0,9),Size=UDim2.new(0,7,0,2),}},
						{20,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={15},Position=UDim2.new(0,4,0,11),Size=UDim2.new(0,9,0,2),}},
					})
					local window = Lib.Window.new()
					window.Resizable = false
					window:Resize(650,150)
					window:SetTitle("ColorSequence Editor")
					newMt.Window = window
					newMt.Gui = window.Gui
					for i,v in pairs(guiContents:GetChildren()) do
						v.Parent = window.GuiElems.Content
					end
					local gui = window.Gui
					local pickerGui = gui.Main
					local pickerTopBar = pickerGui.TopBar
					local pickerFrame = pickerGui.Content
					local colorLine = pickerFrame.ColorLine
					local gradient = colorLine.Gradient.UIGradient
					local arrowFrame = pickerFrame.Arrows
					local arrow = pickerFrame.Arrow
					local cursor = pickerFrame.Cursor
					local timeBox = pickerFrame.Time.Input
					local colorBox = pickerFrame.ColorBox
					local deleteButton = pickerFrame.Delete
					local resetButton = pickerFrame.Reset
					local closeButton = pickerFrame.Close
					local topClose = pickerTopBar.Close

					local user = service.UserInputService
					local mouse = service.Players.LocalPlayer:GetMouse()

					local colors = {{Color3.new(1,0,1),0},{Color3.new(0.2,0.9,0.2),0.2},{Color3.new(0.4,0.5,0.9),0.7},{Color3.new(0.6,1,1),1}}
					local resetSequence = nil

					local beginPoint = colors[1]
					local endPoint = colors[#colors]

					local currentlySelected = nil
					local currentPoint = nil

					local sequenceLine = Instance.new("Frame")
					sequenceLine.BorderSizePixel = 0
					sequenceLine.Size = UDim2.new(0,1,1,0)

					newMt.Sequence = ColorSequence.new(Color3.new(1,1,1))
					local function buildSequence(noupdate)
						local newPoints = {}
						table.sort(colors,function(a,b) return a[2] < b[2] end)
						for i,v in pairs(colors) do
							table.insert(newPoints,ColorSequenceKeypoint.new(v[2],v[1]))
						end
						newMt.Sequence = ColorSequence.new(newPoints)
						if not noupdate then newMt.OnSelect:Fire(newMt.Sequence) end
					end

					local function round(num,places)
						local multi = 10^places
						return math.floor(num*multi + 0.5)/multi
					end

					local function updateInputs(point)
						if point then
							currentPoint = point
							local raw = point[2]
							timeBox.Text = round(raw,(raw < 0.01 and 5) or (raw < 0.1 and 4) or 3)
							colorBox.BackgroundColor3 = point[1]
						end
					end

					local function placeArrow(ind,point)
						local newArrow = arrow:Clone()
						newArrow.Position = UDim2.new(0,ind-1,0,0)
						newArrow.Visible = true
						newArrow.Parent = arrowFrame

						newArrow.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								cursor.Visible = true
								cursor.Position = UDim2.new(0, 9 + newArrow.Position.X.Offset, 0, 0)
							end

							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								updateInputs(point)
								if point == beginPoint or point == endPoint or currentlySelected then return end

								local mouseEvent, releaseEvent
								currentlySelected = true

								releaseEvent = user.InputEnded:Connect(function(input)
									if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
									mouseEvent:Disconnect()
									releaseEvent:Disconnect()
									currentlySelected = nil
									cursor.Visible = false
								end)

								mouseEvent = user.InputChanged:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										local maxSize = colorLine.AbsoluteSize.X - 1
										local relativeX = (input.Position.X - colorLine.AbsolutePosition.X)
										if relativeX < 0 then relativeX = 0 end
										if relativeX > maxSize then relativeX = maxSize end
										local raw = relativeX / maxSize
										point[2] = relativeX / maxSize
										updateInputs(point)
										cursor.Visible = true
										cursor.Position = UDim2.new(0, 9 + newArrow.Position.X.Offset, 0, 0)
										buildSequence()
										newMt:Redraw()
									end
								end)
							end
						end)

						newArrow.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
								cursor.Visible = false
							end
						end)



						return newArrow
					end

					local function placeArrows()
						for i,v in pairs(colors) do
							v[3] = placeArrow(math.floor((colorLine.AbsoluteSize.X-1) * v[2]) + 1,v)
						end
					end

					local function redraw(self)
						gradient.Color = newMt.Sequence or ColorSequence.new(Color3.new(1,1,1))

						for i = 2,#colors do
							local nextColor = colors[i]
							local endPos = math.floor((colorLine.AbsoluteSize.X-1) * nextColor[2]) + 1
							nextColor[3].Position = UDim2.new(0,endPos,0,0)
						end		
					end
					newMt.Redraw = redraw

					local function loadSequence(self,seq)
						resetSequence = seq
						for i,v in pairs(colors) do if v[3] then v[3]:Destroy() end end
						colors = {}
						currentlySelected = nil
						for i,v in pairs(seq.Keypoints) do
							local newPoint = {v.Value,v.Time}
							newPoint[3] = placeArrow(v.Time,newPoint)
							table.insert(colors,newPoint)
						end
						beginPoint = colors[1]
						endPoint = colors[#colors]
						currentlySelected = nil
						updateInputs(colors[1])
						buildSequence(true)
						redraw()
					end
					newMt.SetSequence = loadSequence

					local function buttonAnimations(button,inverse)
						button.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then button.BackgroundTransparency = (inverse and 0.5 or 0.4) end end)
						button.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then button.BackgroundTransparency = (inverse and 1 or 0) end end)
					end

					colorLine.InputBegan:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #colors < 20 then
							local maxSize = colorLine.AbsoluteSize.X - 1
							local relativeX = (input.Position.X - colorLine.AbsolutePosition.X)
							if relativeX < 0 then relativeX = 0 end
							if relativeX > maxSize then relativeX = maxSize end

							local raw = relativeX / maxSize
							local fromColor = nil
							local toColor = nil
							for i, col in pairs(colors) do
								if col[2] >= raw then
									fromColor = colors[math.max(i - 1, 1)]
									toColor = colors[i]
									break
								end
							end
							local lerpColor = fromColor[1]:lerp(toColor[1], (raw - fromColor[2]) / (toColor[2] - fromColor[2]))
							local newPoint = {lerpColor, raw}
							newPoint[3] = placeArrow(newPoint[2], newPoint)
							table.insert(colors, newPoint)
							updateInputs(newPoint)
							buildSequence()
							redraw()
						end
					end)

					colorLine.InputChanged:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							local maxSize = colorLine.AbsoluteSize.X - 1
							local relativeX = (input.Position.X - colorLine.AbsolutePosition.X)
							if relativeX < 0 then relativeX = 0 end
							if relativeX > maxSize then relativeX = maxSize end
							cursor.Visible = true
							cursor.Position = UDim2.new(0, 10 + relativeX, 0, 0)
						end
					end)

					colorLine.InputEnded:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							local inArrow = false
							for i, v in pairs(colors) do
								if Lib.CheckMouseInGui(v[3]) then
									inArrow = v[3]
								end
							end
							cursor.Visible = inArrow and true or false
							if inArrow then cursor.Position = UDim2.new(0, 9 + inArrow.Position.X.Offset, 0, 0) end
						end
					end)

					timeBox:GetPropertyChangedSignal("Text"):Connect(function()
						local point = currentPoint
						local num = tonumber(timeBox.Text)
						if point and num and point ~= beginPoint and point ~= endPoint then
							num = math.clamp(num,0,1)
							point[2] = num
							buildSequence()
							redraw()
						end
					end)

					colorBox.InputBegan:Connect(function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							local editor = newMt.ColorPicker
							if not editor then
								editor = Lib.ColorPicker.new()
								editor.Window:SetTitle("ColorSequence Color Picker")

								editor.OnSelect:Connect(function(col)
									if currentPoint then
										currentPoint[1] = col
									end
									buildSequence()
									redraw()
								end)

								newMt.ColorPicker = editor
							end

							editor.Window:ShowAndFocus()
						end
					end)

					deleteButton.MouseButton1Click:Connect(function()
						if currentPoint and currentPoint ~= beginPoint and currentPoint ~= endPoint then
							for i,v in pairs(colors) do
								if v == currentPoint then
									v[3]:Destroy()
									table.remove(colors,i)
									break
								end
							end
							currentlySelected = nil
							updateInputs(colors[1])
							buildSequence()
							redraw()
						end
					end)

					resetButton.MouseButton1Click:Connect(function()
						if resetSequence then
							newMt:SetSequence(resetSequence)
						end
					end)

					closeButton.MouseButton1Click:Connect(function()
						window:Close()
					end)

					topClose.MouseButton1Click:Connect(function()
						window:Close()
					end)

					buttonAnimations(deleteButton)
					buttonAnimations(resetButton)
					buttonAnimations(closeButton)

					placeArrows()
					redraw()

					newMt.Show = function(self)
						window:Show()
					end

					return newMt
				end

				return {new = new}
			end)()

			Lib.ViewportTextBox = (function()
				local textService = service.TextService

				local props = {
					OffsetX = 0,
					TextBox = PH,
					CursorPos = -1,
					Gui = PH,
					View = PH
				}
				local funcs = {}
				funcs.Update = function(self)
					local cursorPos = self.CursorPos or -1
					local text = self.TextBox.Text
					if text == "" then self.TextBox.Position = UDim2.new(0,0,0,0) return end
					if cursorPos == -1 then return end

					local cursorText = text:sub(1,cursorPos-1)
					local pos = nil
					local leftEnd = -self.TextBox.Position.X.Offset
					local rightEnd = leftEnd + self.View.AbsoluteSize.X

					local totalTextSize = textService:GetTextSize(text,self.TextBox.TextSize,self.TextBox.Font,Vector2.new(999999999,100)).X
					local cursorTextSize = textService:GetTextSize(cursorText,self.TextBox.TextSize,self.TextBox.Font,Vector2.new(999999999,100)).X

					if cursorTextSize > rightEnd then
						pos = math.max(-1,cursorTextSize - self.View.AbsoluteSize.X + 2)
					elseif cursorTextSize < leftEnd then
						pos = math.max(-1,cursorTextSize-2)
					elseif totalTextSize < rightEnd then
						pos = math.max(-1,totalTextSize - self.View.AbsoluteSize.X + 2)
					end

					if pos then
						self.TextBox.Position = UDim2.new(0,-pos,0,0)
						self.TextBox.Size = UDim2.new(1,pos,1,0)
					end
				end

				funcs.GetText = function(self)
					return self.TextBox.Text
				end

				funcs.SetText = function(self,text)
					self.TextBox.Text = text
				end

				local mt = getGuiMT(props,funcs)

				local function convert(textbox)
					local obj = initObj(props,mt)

					local view = Instance.new("Frame")
					view.BackgroundTransparency = textbox.BackgroundTransparency
					view.BackgroundColor3 = textbox.BackgroundColor3
					view.BorderSizePixel = textbox.BorderSizePixel
					view.BorderColor3 = textbox.BorderColor3
					view.Position = textbox.Position
					view.Size = textbox.Size
					view.ClipsDescendants = true
					view.Name = textbox.Name
					textbox.BackgroundTransparency = 1
					textbox.Position = UDim2.new(0,0,0,0)
					textbox.Size = UDim2.new(1,0,1,0)
					textbox.TextXAlignment = Enum.TextXAlignment.Left
					textbox.Name = "Input"

					obj.TextBox = textbox
					obj.View = view
					obj.Gui = view

					textbox.Changed:Connect(function(prop)
						if prop == "Text" or prop == "CursorPosition" or prop == "AbsoluteSize" then
							local cursorPos = obj.TextBox.CursorPosition
							if cursorPos ~= -1 then obj.CursorPos = cursorPos end
							obj:Update()
						end
					end)

					obj:Update()

					view.Parent = textbox.Parent
					textbox.Parent = view

					return obj
				end

				local function new()
					local textBox = Instance.new("TextBox")
					textBox.Size = UDim2.new(0,100,0,20)
					textBox.BackgroundColor3 = Settings.Theme.TextBox
					textBox.BorderColor3 = Settings.Theme.Outline3
					textBox.ClearTextOnFocus = false
					textBox.TextColor3 = Settings.Theme.Text
					textBox.Font = Enum.Font.SourceSans
					textBox.TextSize = 14
					textBox.Text = ""
					return convert(textBox)
				end

				return {new = new, convert = convert}
			end)()

			Lib.Label = (function()
				local props,funcs = {},{}

				local mt = getGuiMT(props,funcs)

				local function new()
					local label = Instance.new("TextLabel")
					label.BackgroundTransparency = 1
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.TextColor3 = Settings.Theme.Text
					label.TextTransparency = 0.1
					label.Size = UDim2.new(0,100,0,20)
					label.Font = Enum.Font.SourceSans
					label.TextSize = 14

					local obj = setmetatable({
						Gui = label
					},mt)
					return obj
				end

				return {new = new}
			end)()

			Lib.Frame = (function()
				local props,funcs = {},{}

				local mt = getGuiMT(props,funcs)

				local function new()
					local fr = Instance.new("Frame")
					fr.BackgroundColor3 = Settings.Theme.Main1
					fr.BorderColor3 = Settings.Theme.Outline1
					fr.Size = UDim2.new(0,50,0,50)

					local obj = setmetatable({
						Gui = fr
					},mt)
					return obj
				end

				return {new = new}
			end)()

			Lib.Button = (function()
				local props = {
					Gui = PH,
					Anim = PH,
					Disabled = false,
					OnClick = SIGNAL,
					OnDown = SIGNAL,
					OnUp = SIGNAL,
					AllowedButtons = {1}
				}
				local funcs = {}
				local tableFind = table.find

				funcs.Trigger = function(self,event,button)
					if not self.Disabled and tableFind(self.AllowedButtons,button) then
						self["On"..event]:Fire(button)
					end
				end

				funcs.SetDisabled = function(self,dis)
					self.Disabled = dis

					if dis then
						self.Anim:Disable()
						self.Gui.TextTransparency = 0.5
					else
						self.Anim.Enable()
						self.Gui.TextTransparency = 0
					end
				end

				local mt = getGuiMT(props,funcs)

				local function new()
					local b = Instance.new("TextButton")
					b.AutoButtonColor = false
					b.TextColor3 = Settings.Theme.Text
					b.TextTransparency = 0.1
					b.Size = UDim2.new(0,100,0,20)
					b.Font = Enum.Font.SourceSans
					b.TextSize = 14
					b.BackgroundColor3 = Settings.Theme.Button
					b.BorderColor3 = Settings.Theme.Outline2

					local obj = initObj(props,mt)
					obj.Gui = b
					obj.Anim = Lib.ButtonAnim(b,{Mode = 2, StartColor = Settings.Theme.Button, HoverColor = Settings.Theme.ButtonHover, PressColor = Settings.Theme.ButtonPress, OutlineColor = Settings.Theme.Outline2})

					b.MouseButton1Click:Connect(function() obj:Trigger("Click",1) end)
					b.MouseButton1Down:Connect(function() obj:Trigger("Down",1) end)
					b.MouseButton1Up:Connect(function() obj:Trigger("Up",1) end)

					b.MouseButton2Click:Connect(function() obj:Trigger("Click",2) end)
					b.MouseButton2Down:Connect(function() obj:Trigger("Down",2) end)
					b.MouseButton2Up:Connect(function() obj:Trigger("Up",2) end)

					return obj
				end

				return {new = new}
			end)()

			Lib.DropDown = (function()
				local props = {
					Gui = PH,
					Anim = PH,
					Context = PH,
					Selected = PH,
					Disabled = false,
					CanBeEmpty = true,
					Options = {},
					GuiElems = {},
					OnSelect = SIGNAL
				}
				local funcs = {}

				funcs.Update = function(self)
					local options = self.Options

					if #options > 0 then
						if not self.Selected then
							if not self.CanBeEmpty then
								self.Selected = options[1]
								self.GuiElems.Label.Text = options[1]
							else
								self.GuiElems.Label.Text = "- Select -"
							end
						else
							self.GuiElems.Label.Text = self.Selected
						end
					else
						self.GuiElems.Label.Text = "- Select -"
					end
				end

				funcs.ShowOptions = function(self)
					local context = self.Context

					context.Width = self.Gui.AbsoluteSize.X
					context.ReverseYOffset = self.Gui.AbsoluteSize.Y
					context:Show(self.Gui.AbsolutePosition.X, self.Gui.AbsolutePosition.Y + context.ReverseYOffset)
				end

				funcs.SetOptions = function(self,opts)
					self.Options = opts

					local context = self.Context
					local options = self.Options
					context:Clear()

					local onClick = function(option) self.Selected = option self.OnSelect:Fire(option) self:Update() end

					if self.CanBeEmpty then
						context:Add({Name = "- Select -", function() self.Selected = nil self.OnSelect:Fire(nil) self:Update() end})
					end

					for i = 1,#options do
						context:Add({Name = options[i], OnClick = onClick})
					end

					self:Update()
				end

				funcs.SetSelected = function(self,opt)
					self.Selected = type(opt) == "number" and self.Options[opt] or opt
					self:Update()
				end

				local mt = getGuiMT(props,funcs)

				local function new()
					local f = Instance.new("TextButton")
					f.AutoButtonColor = false
					f.Text = ""
					f.Size = UDim2.new(0,100,0,20)
					f.BackgroundColor3 = Settings.Theme.TextBox
					f.BorderColor3 = Settings.Theme.Outline3

					local label = Lib.Label.new()
					label.Position = UDim2.new(0,2,0,0)
					label.Size = UDim2.new(1,-22,1,0)
					label.TextTruncate = Enum.TextTruncate.AtEnd
					label.Parent = f
					local arrow = create({
						{1,"Frame",{BackgroundTransparency=1,Name="EnumArrow",Position=UDim2.new(1,-16,0,2),Size=UDim2.new(0,16,0,16),}},
						{2,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,8,0,9),Size=UDim2.new(0,1,0,1),}},
						{3,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,7,0,8),Size=UDim2.new(0,3,0,1),}},
						{4,"Frame",{BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BorderSizePixel=0,Parent={1},Position=UDim2.new(0,6,0,7),Size=UDim2.new(0,5,0,1),}},
					})
					arrow.Parent = f

					local obj = initObj(props,mt)
					obj.Gui = f
					obj.Anim = Lib.ButtonAnim(f,{Mode = 2, StartColor = Settings.Theme.TextBox, LerpTo = Settings.Theme.Button, LerpDelta = 0.15})
					obj.Context = Lib.ContextMenu.new()
					obj.Context.Iconless = true
					obj.Context.MaxHeight = 200
					obj.Selected = nil
					obj.GuiElems = {Label = label}
					f.MouseButton1Down:Connect(function() obj:ShowOptions() end)
					obj:Update()
					return obj
				end

				return {new = new}
			end)()

			Lib.ClickSystem = (function()
				local props = {
					LastItem = PH,
					OnDown = SIGNAL,
					OnRelease = SIGNAL,
					AllowedButtons = {1},
					Combo = 0,
					MaxCombo = 2,
					ComboTime = 0.5,
					Items = {},
					ItemCons = {},
					ClickId = -1,
					LastButton = ""
				}
				local funcs = {}
				local tostring = tostring

				local disconnect = function(con)
					local pos = table.find(con.Signal.Connections,con)
					if pos then table.remove(con.Signal.Connections,pos) end
				end

				funcs.Trigger = function(self, item, button, X, Y)
					if table.find(self.AllowedButtons, button) then
						if self.LastButton ~= button or self.LastItem ~= item or self.Combo == self.MaxCombo or tick() - self.ClickId > self.ComboTime then
							self.Combo = 0
							self.LastButton = button
							self.LastItem = item
						end

						self.Combo = self.Combo + 1
						self.ClickId = tick()

						task.spawn(function()
							if self.InputDown then
								self.InputDown = false
							else
								self.InputDown = tick()

								local Connection = item.MouseButton1Up:Once(function()
									self.InputDown = false
								end)

								while self.InputDown and not Explorer.Dragging do
									if (tick() - self.InputDown) >= 0.4 then
										self.InputDown = false
										self["OnRelease"]:Fire(item, self.Combo, 2, Vector2.new(X, Y))
										break
									end;task.wait()
								end
							end
						end)

						local release
						release = service.UserInputService.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType["MouseButton" .. button] then
								release:Disconnect()
								if Lib.CheckMouseInGui(item) and self.LastButton == button and self.LastItem == item then
									self["OnRelease"]:Fire(item,self.Combo,button)
								end
							end
						end)

						self["OnDown"]:Fire(item,self.Combo,button)
					end
				end

				funcs.Add = function(self,item)
					if table.find(self.Items,item) then return end

					local cons = {}
					cons[1] = item.MouseButton1Down:Connect(function(X, Y) self:Trigger(item, 1, X, Y) end)
					cons[2] = item.MouseButton2Down:Connect(function(X, Y) self:Trigger(item, 2, X, Y) end)

					self.ItemCons[item] = cons
					self.Items[#self.Items+1] = item
				end

				funcs.Remove = function(self,item)
					local ind = table.find(self.Items,item)
					if not ind then return end

					for i,v in pairs(self.ItemCons[item]) do
						v:Disconnect()
					end
					self.ItemCons[item] = nil
					table.remove(self.Items,ind)
				end

				local mt = {__index = funcs}

				local function new()
					local obj = initObj(props,mt)

					return obj
				end

				return {new = new}
			end)()

			return Lib
		end

		return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
	end
}

-- Main vars
local Main, Explorer, Properties, ScriptViewer, DefaultSettings, Notebook, Serializer, Lib
local API, RM

-- Default Settings
DefaultSettings = (function()
	local rgb = Color3.fromRGB
	return {
		Explorer = {
			_Recurse = true,
			Sorting = true,
			TeleportToOffset = Vector3.new(0,0,0),
			ClickToRename = true,
			AutoUpdateSearch = true,
			AutoUpdateMode = 0, -- 0 Default, 1 no tree update, 2 no descendant events, 3 frozen
			PartSelectionBox = true,
			GuiSelectionBox = true,
			CopyPathUseGetChildren = true
		},
		Properties = {
			_Recurse = true,
			MaxConflictCheck = 50,
			ShowDeprecated = false,
			ShowHidden = false,
			ClearOnFocus = false,
			LoadstringInput = true,
			NumberRounding = 3,
			ShowAttributes = false,
			MaxAttributes = 50,
			ScaleType = 1 -- 0 Full Name Shown, 1 Equal Halves
		},
		Theme = {
			_Recurse = true,
			Main1 = rgb(52,52,52),
			Main2 = rgb(45,45,45),
			Outline1 = rgb(33,33,33), -- Mainly frames
			Outline2 = rgb(55,55,55), -- Mainly button
			Outline3 = rgb(30,30,30), -- Mainly textbox
			TextBox = rgb(38,38,38),
			Menu = rgb(32,32,32),
			ListSelection = rgb(11,90,175),
			Button = rgb(60,60,60),
			ButtonHover = rgb(68,68,68),
			ButtonPress = rgb(40,40,40),
			Highlight = rgb(75,75,75),
			Text = rgb(255,255,255),
			PlaceholderText = rgb(100,100,100),
			Important = rgb(255,0,0),
			ExplorerIconMap = "",
			MiscIconMap = "",
			Syntax = {
				Text = rgb(204,204,204),
				Background = rgb(36,36,36),
				Selection = rgb(255,255,255),
				SelectionBack = rgb(11,90,175),
				Operator = rgb(204,204,204),
				Number = rgb(255,198,0),
				String = rgb(173,241,149),
				Comment = rgb(102,102,102),
				Keyword = rgb(248,109,124),
				Error = rgb(255,0,0),
				FindBackground = rgb(141,118,0),
				MatchingWord = rgb(85,85,85),
				BuiltIn = rgb(132,214,247),
				CurrentLine = rgb(45,50,65),
				LocalMethod = rgb(253,251,172),
				LocalProperty = rgb(97,161,241),
				Nil = rgb(255,198,0),
				Bool = rgb(255,198,0),
				Function = rgb(248,109,124),
				Local = rgb(248,109,124),
				Self = rgb(248,109,124),
				FunctionName = rgb(253,251,172),
				Bracket = rgb(204,204,204)
			},
		}
	}
end)()

-- Vars
local Settings = {}
local Apps = {}
local env = {}

local plr = service.Players.LocalPlayer or service.Players.PlayerAdded:wait()

local create = function(data)
	local insts = {}
	for i,v in pairs(data) do insts[v[1]] = Instance.new(v[2]) end

	for _,v in pairs(data) do
		for prop,val in pairs(v[3]) do
			if type(val) == "table" then
				insts[v[1]][prop] = insts[val[1]]
			else
				insts[v[1]][prop] = val
			end
		end
	end

	return insts[1]
end

local createSimple = function(class,props)
	local inst = Instance.new(class)
	for i,v in next,props do
		inst[i] = v
	end
	return inst
end

Main = (function()
	local Main = {}

	Main.ModuleList = {"Explorer", "Properties", "ScriptViewer"}
	Main.Elevated = false
	Main.MissingEnv = {}
	Main.Version = "" -- Beta 1.0.0
	Main.Mouse = plr:GetMouse()
	Main.AppControls = {}
	Main.Apps = Apps
	Main.MenuApps = {}

	Main.DisplayOrders = {
		SideWindow = 8,
		Window = 10,
		Menu = 100000,
		Core = 101000
	}

	Main.GetInitDeps = function()
		return {
			Main = Main,
			Lib = Lib,
			Apps = Apps,
			Settings = Settings,

			API = API,
			RMD = RMD,
			env = env,
			service = service,
			plr = plr,
			create = create,
			createSimple = createSimple
		}
	end

	Main.Error = function(str)
		if rconsoleprint then
			rconsoleprint("DEX ERROR: "..tostring(str).."\n")
			wait(9e9)
		else
			error(str)
		end
	end

	Main.LoadModule = function(name)
		if Main.Elevated then -- If you don't have filesystem api then ur outta luck tbh
			local control

			if EmbeddedModules then -- Offline Modules
				control = EmbeddedModules[name]()

				if not control then Main.Error("Missing Embedded Module: "..name) end
			end

			Main.AppControls[name] = control
			control.InitDeps(Main.GetInitDeps())

			local moduleData = control.Main()
			Apps[name] = moduleData
			return moduleData
		else
			local module = script:WaitForChild("Modules"):WaitForChild(name, 2)
			if not module then Main.Error("CANNOT FIND MODULE " .. name) end

			local control = require(module)
			Main.AppControls[name] = control
			control.InitDeps(Main.GetInitDeps())

			local moduleData = control.Main()
			Apps[name] = moduleData
			return moduleData
		end
	end

	Main.LoadModules = function()
		for i,v in pairs(Main.ModuleList) do
			local s,e = pcall(Main.LoadModule,v)
			if not s then
				Main.Error(("FAILED LOADING %s CAUSE %s"):format(v, e))
			end
		end

		-- Init Major Apps and define them in modules
		Explorer = Apps.Explorer
		Properties = Apps.Properties
		ScriptViewer = Apps.ScriptViewer
		Notebook = Apps.Notebook
		local appTable = {
			Explorer = Explorer,
			Properties = Properties,
			ScriptViewer = ScriptViewer,
			Notebook = Notebook
		}

		Main.AppControls.Lib.InitAfterMain(appTable)
		for i,v in pairs(Main.ModuleList) do
			local control = Main.AppControls[v]
			if control then
				control.InitAfterMain(appTable)
			end
		end
	end

	Main.InitEnv = function()
		setmetatable(env, {__newindex = function(self, name, func)
			if not func then Main.MissingEnv[#Main.MissingEnv + 1] = name return end
			rawset(self, name, func)
		end})

		-- file
		env.readfile = readfile
		env.writefile = writefile
		env.appendfile = appendfile
		env.makefolder = makefolder
		env.listfiles = listfiles
		env.loadfile = loadfile
		env.movefileas = movefileas
		env.saveinstance = saveinstance
		env.parsefile = function(name)
			return tostring(name):gsub("[*\\?:<>|]+", ""):sub(1, 175)
		end

		-- debug
		env.getupvalues = (debug and debug.getupvalues) or getupvalues or getupvals
		env.getconstants = (debug and debug.getconstants) or getconstants or getconsts
		env.getinfo = (debug and (debug.getinfo or debug.info)) or getinfo
		env.islclosure = islclosure or is_l_closure or is_lclosure
		env.checkcaller = checkcaller
		--env.getreg = getreg
		env.getgc = getgc or get_gc_objects
		--env.base64encode = crypt and crypt.base64 and crypt.base64.encode
		env.getscriptbytecode = getscriptbytecode

		-- other
		--env.setfflag = setfflag
		env.request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
		-- hmm yes sanity check hmm fake decompile good
		env.safeDecompile = type(decompile) == "function" and decompile
		env.decompile = env.safeDecompile or (env.getscriptbytecode and env.request and (function()
			local success, err = pcall(function()
				loadstring(oldgame:HttpGet([====[-- by lovrewe

assert(getscriptbytecode, "Exploit not supported.")

local API = "http://api.plusgiant5.com"

local last_call = 0

local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function call(konstantType, scriptPath)
	local success, bytecode = pcall(getscriptbytecode, scriptPath)

	if (not success) then
		return `-- Failed to get script bytecode, error:\n\n--[[\n{bytecode}\n--]]`
	end

	local time_elapsed = os.clock() - last_call
	if time_elapsed <= .5 then
		task.wait(.5 - time_elapsed)
	end

	local httpResult = request({
		Url = API .. konstantType,
		Body = bytecode,
		Method = "POST",
		Headers = {
			["Content-Type"] = "text/plain"
		}
	})

	last_call = os.clock()

	if (httpResult.StatusCode ~= 200) then
		return `-- Error occurred while requesting Konstant API, error:\n\n--[[\n{httpResult.Body}\n--]]`
	else
		return httpResult.Body
	end
end

local function decompile(scriptPath)
	return call("/konstant/decompile", scriptPath)
end

local function disassemble(scriptPath)
	return call("/konstant/disassemble", scriptPath)
end

getgenv().decompile = decompile
getgenv().disassemble = disassemble]====]"))()
			end)

			return (success and decompile) or nil
		end)())
		env.isViableDecompileScript = function(obj)
			if obj:IsA("ModuleScript") then
				return true
			elseif obj:IsA("LocalScript") and (obj.RunContext == Enum.RunContext.Client or obj.RunContext == Enum.RunContext.Legacy) then
				return true
			elseif obj:IsA("Script") and obj.RunContext == Enum.RunContext.Client then
				return true
			end
			return false
		end
		env.protectgui = protect_gui or (syn and syn.protect_gui)
		env.gethui = gethui or get_hidden_gui
		env.setclipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
		env.getnilinstances = getnilinstances or get_nil_instances
		env.getloadedmodules = getloadedmodules

		env.executor = type(identifyexecutor) == "function" and tostring(identifyexecutor()) or "Your executor"

		Main.GuiHolder = Main.Elevated and service.CoreGui or plr:FindFirstChildWhichIsA("PlayerGui")

		setmetatable(env, nil)
	end

	Main.LoadSettings = function()
		local s,data = pcall(env.readfile or error,"DexSettings.json")
		if s and data and data ~= "" then
			local s,decoded = service.HttpService:JSONDecode(data)
			if s and decoded then
				for i,v in next,decoded do

				end
			else
				-- TODO: Notification
			end
		else
			Main.ResetSettings()
		end
	end

	Main.ResetSettings = function()
		local function recur(t,res)
			for set,val in pairs(t) do
				if type(val) == "table" and val._Recurse then
					if type(res[set]) ~= "table" then
						res[set] = {}
					end
					recur(val,res[set])
				else
					res[set] = val
				end
			end
			return res
		end
		recur(DefaultSettings,Settings)
	end
	
	local function jsonDecode(str)
		local suc, res = pcall(service.HttpService.JSONDecode, service.HttpService, str)
		return suc and res or suc
	end

	Main.FetchAPI = function()
		local api,rawAPI
		if Main.Elevated then
			if Main.LocalDepsUpToDate() then
				local localAPI = Lib.ReadFile("dex/rbx_api.dat")
				if localAPI then 
					rawAPI = localAPI
				else
					Main.DepsVersionData[1] = ""
				end
			end
			rawAPI = rawAPI or oldgame:HttpGet("http://setup.roblox.com/"..Main.RobloxVersion.."-API-Dump.json")
		else
			if script:FindFirstChild("API") then
				rawAPI = require(script.API)
			else
				error("NO API EXISTS")
			end
		end
		Main.RawAPI = rawAPI
		api = jsonDecode(rawAPI)

		-- backup for kaboom
		if not api then
			rawAPI = oldgame:HttpGet("https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/rbx_api.dat")
			Main.RawAPI = rawAPI
			api = jsonDecode(rawAPI)
		end

		local classes,enums = {},{}
		local categoryOrder,seenCategories = {},{}

		local function insertAbove(t,item,aboveItem)
			local findPos = table.find(t,item)
			if not findPos then return end
			table.remove(t,findPos)

			local pos = table.find(t,aboveItem)
			if not pos then return end
			table.insert(t,pos,item)
		end

		for _,class in pairs(api.Classes) do
			local newClass = {}
			newClass.Name = class.Name
			newClass.Superclass = class.Superclass
			newClass.Properties = {}
			newClass.Functions = {}
			newClass.Events = {}
			newClass.Callbacks = {}
			newClass.Tags = {}

			if class.Tags then for c,tag in pairs(class.Tags) do newClass.Tags[tag] = true end end
			for __,member in pairs(class.Members) do
				local newMember = {}
				newMember.Name = member.Name
				newMember.Class = class.Name
				newMember.Security = member.Security
				newMember.Tags ={}
				if member.Tags then for c,tag in pairs(member.Tags) do newMember.Tags[tag] = true end end

				local mType = member.MemberType
				if mType == "Property" then
					local propCategory = member.Category or "Other"
					propCategory = propCategory:match("^%s*(.-)%s*$")
					if not seenCategories[propCategory] then
						categoryOrder[#categoryOrder+1] = propCategory
						seenCategories[propCategory] = true
					end
					newMember.ValueType = member.ValueType
					newMember.Category = propCategory
					newMember.Serialization = member.Serialization
					table.insert(newClass.Properties,newMember)
				elseif mType == "Function" then
					newMember.Parameters = {}
					newMember.ReturnType = member.ReturnType.Name
					for c,param in pairs(member.Parameters) do
						table.insert(newMember.Parameters,{Name = param.Name, Type = param.Type.Name})
					end
					table.insert(newClass.Functions,newMember)
				elseif mType == "Event" then
					newMember.Parameters = {}
					for c,param in pairs(member.Parameters) do
						table.insert(newMember.Parameters,{Name = param.Name, Type = param.Type.Name})
					end
					table.insert(newClass.Events,newMember)
				end
			end

			classes[class.Name] = newClass
		end

		for _,class in pairs(classes) do
			class.Superclass = classes[class.Superclass]
		end

		for _,enum in pairs(api.Enums) do
			local newEnum = {}
			newEnum.Name = enum.Name
			newEnum.Items = {}
			newEnum.Tags = {}

			if enum.Tags then for c,tag in pairs(enum.Tags) do newEnum.Tags[tag] = true end end
			for __,item in pairs(enum.Items) do
				local newItem = {}
				newItem.Name = item.Name
				newItem.Value = item.Value
				table.insert(newEnum.Items,newItem)
			end

			enums[enum.Name] = newEnum
		end

		local function getMember(class,member)
			if not classes[class] or not classes[class][member] then return end
			local result = {}

			local currentClass = classes[class]
			while currentClass do
				for _,entry in pairs(currentClass[member]) do
					result[#result+1] = entry
				end
				currentClass = currentClass.Superclass
			end

			table.sort(result,function(a,b) return a.Name < b.Name end)
			return result
		end

		insertAbove(categoryOrder,"Behavior","Tuning")
		insertAbove(categoryOrder,"Appearance","Data")
		insertAbove(categoryOrder,"Attachments","Axes")
		insertAbove(categoryOrder,"Cylinder","Slider")
		insertAbove(categoryOrder,"Localization","Jump Settings")
		insertAbove(categoryOrder,"Surface","Motion")
		insertAbove(categoryOrder,"Surface Inputs","Surface")
		insertAbove(categoryOrder,"Part","Surface Inputs")
		insertAbove(categoryOrder,"Assembly","Surface Inputs")
		insertAbove(categoryOrder,"Character","Controls")
		categoryOrder[#categoryOrder+1] = "Unscriptable"
		categoryOrder[#categoryOrder+1] = "Attributes"

		local categoryOrderMap = {}
		for i = 1,#categoryOrder do
			categoryOrderMap[categoryOrder[i]] = i
		end

		return {
			Classes = classes,
			Enums = enums,
			CategoryOrder = categoryOrderMap,
			GetMember = getMember
		}
	end

	Main.FetchRMD = function()
		local rawXML
		if Main.Elevated then
			if Main.LocalDepsUpToDate() then
				local localRMD = Lib.ReadFile("dex/rbx_rmd.dat")
				if localRMD then 
					rawXML = localRMD
				else
					Main.DepsVersionData[1] = ""
				end
			end
			rawXML = rawXML or oldgame:HttpGet("https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml")
		else
			if script:FindFirstChild("RMD") then
				rawXML = require(script.RMD)
			else
				error("NO RMD EXISTS")
			end
		end
		Main.RawRMD = rawXML
		local parsed = Lib.ParseXML(rawXML)
		local classList = parsed.children[1].children[1].children
		local enumList = parsed.children[1].children[2].children
		local propertyOrders = {}

		local classes,enums = {},{}
		for _,class in pairs(classList) do
			local className = ""
			for _,child in pairs(class.children) do
				if child.tag == "Properties" then
					local data = {Properties = {}, Functions = {}}
					local props = child.children
					for _,prop in pairs(props) do
						local name = prop.attrs.name
						name = name:sub(1,1):upper()..name:sub(2)
						data[name] = prop.children[1].text
					end
					className = data.Name
					classes[className] = data
				elseif child.attrs.class == "ReflectionMetadataProperties" then
					local members = child.children
					for _,member in pairs(members) do
						if member.attrs.class == "ReflectionMetadataMember" then
							local data = {}
							if member.children[1].tag == "Properties" then
								local props = member.children[1].children
								for _,prop in pairs(props) do
									if prop.attrs then
										local name = prop.attrs.name
										name = name:sub(1,1):upper()..name:sub(2)
										data[name] = prop.children[1].text
									end
								end
								if data.PropertyOrder then
									local orders = propertyOrders[className]
									if not orders then orders = {} propertyOrders[className] = orders end
									orders[data.Name] = tonumber(data.PropertyOrder)
								end
								classes[className].Properties[data.Name] = data
							end
						end
					end
				elseif child.attrs.class == "ReflectionMetadataFunctions" then
					local members = child.children
					for _,member in pairs(members) do
						if member.attrs.class == "ReflectionMetadataMember" then
							local data = {}
							if member.children[1].tag == "Properties" then
								local props = member.children[1].children
								for _,prop in pairs(props) do
									if prop.attrs then
										local name = prop.attrs.name
										name = name:sub(1,1):upper()..name:sub(2)
										data[name] = prop.children[1].text
									end
								end
								classes[className].Functions[data.Name] = data
							end
						end
					end
				end
			end
		end

		for _,enum in pairs(enumList) do
			local enumName = ""
			for _,child in pairs(enum.children) do
				if child.tag == "Properties" then
					local data = {Items = {}}
					local props = child.children
					for _,prop in pairs(props) do
						local name = prop.attrs.name
						name = name:sub(1,1):upper()..name:sub(2)
						data[name] = prop.children[1].text
					end
					enumName = data.Name
					enums[enumName] = data
				elseif child.attrs.class == "ReflectionMetadataEnumItem" then
					local data = {}
					if child.children[1].tag == "Properties" then
						local props = child.children[1].children
						for _,prop in pairs(props) do
							local name = prop.attrs.name
							name = name:sub(1,1):upper()..name:sub(2)
							data[name] = prop.children[1].text
						end
						enums[enumName].Items[data.Name] = data
					end
				end
			end
		end

		return {Classes = classes, Enums = enums, PropertyOrders = propertyOrders}
	end

	Main.ShowGui = function(gui)
		if env.gethui then
			gui.Parent = env.gethui()
		elseif env.protectgui then
			env.protectgui(gui)
			gui.Parent = Main.GuiHolder
		else
			gui.Parent = Main.GuiHolder
		end
	end

	Main.CreateIntro = function(initStatus) -- TODO: Must theme and show errors
		local gui = create({
			{1,"ScreenGui",{Name="Intro",}},
			{2,"Frame",{Active=true,BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="Main",Parent={1},Position=UDim2.new(0.5,-175,0.5,-100),Size=UDim2.new(0,350,0,200),}},
			{3,"Frame",{BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,ClipsDescendants=true,Name="Holder",Parent={2},Size=UDim2.new(1,0,1,0),}},
			{4,"UIGradient",{Parent={3},Rotation=30,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0),}),}},
			{5,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=4,Name="Title",Parent={3},Position=UDim2.new(0,-190,0,15),Size=UDim2.new(0,100,0,50),Text="Dex",TextColor3=Color3.new(1,1,1),TextSize=50,TextTransparency=1,}},
			{6,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Desc",Parent={3},Position=UDim2.new(0,-230,0,60),Size=UDim2.new(0,180,0,25),Text="Ultimate Debugging Suite",TextColor3=Color3.new(1,1,1),TextSize=18,TextTransparency=1,}},
			{7,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="StatusText",Parent={3},Position=UDim2.new(0,20,0,110),Size=UDim2.new(0,180,0,25),Text="Fetching API",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=1,}},
			{8,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="ProgressBar",Parent={3},Position=UDim2.new(0,110,0,145),Size=UDim2.new(0,0,0,4),}},
			{9,"Frame",{BackgroundColor3=Color3.new(0.2392156869173,0.56078433990479,0.86274510622025),BorderSizePixel=0,Name="Bar",Parent={8},Size=UDim2.new(0,0,1,0),}},
			{10,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://2764171053",ImageColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),Parent={8},ScaleType=1,Size=UDim2.new(1,0,1,0),SliceCenter=Rect.new(2,2,254,254),}},
			{11,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Creator",Parent={2},Position=UDim2.new(1,-110,1,-20),Size=UDim2.new(0,105,0,20),Text="Developed by Moon",TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=1,}},
			{12,"UIGradient",{Parent={11},Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0),}),}},
			{13,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Version",Parent={2},Position=UDim2.new(1,-110,1,-35),Size=UDim2.new(0,105,0,20),Text=Main.Version,TextColor3=Color3.new(1,1,1),TextSize=14,TextXAlignment=1,}},
			{14,"UIGradient",{Parent={13},Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0),}),}},
			{15,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxassetid://1427967925",Name="Outlines",Parent={2},Position=UDim2.new(0,-5,0,-5),ScaleType=1,Size=UDim2.new(1,10,1,10),SliceCenter=Rect.new(6,6,25,25),TileSize=UDim2.new(0,20,0,20),}},
			{16,"UIGradient",{Parent={15},Rotation=-30,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0),}),}},
			{17,"UIGradient",{Parent={2},Rotation=-30,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0),}),}},
		})
		Main.ShowGui(gui)
		local backGradient = gui.Main.UIGradient
		local outlinesGradient = gui.Main.Outlines.UIGradient
		local holderGradient = gui.Main.Holder.UIGradient
		local titleText = gui.Main.Holder.Title
		local descText = gui.Main.Holder.Desc
		local versionText = gui.Main.Version
		local versionGradient = versionText.UIGradient
		local creatorText = gui.Main.Creator
		local creatorGradient = creatorText.UIGradient
		local statusText = gui.Main.Holder.StatusText
		local progressBar = gui.Main.Holder.ProgressBar
		local tweenS = service.TweenService

		local renderStepped = service.RunService.RenderStepped
		local signalWait = renderStepped.wait
		local fastwait = function(s)
			if not s then return signalWait(renderStepped) end
			local start = tick()
			while tick() - start < s do signalWait(renderStepped) end
		end

		statusText.Text = initStatus

		local function tweenNumber(n,ti,func)
			local tweenVal = Instance.new("IntValue")
			tweenVal.Value = 0
			tweenVal.Changed:Connect(func)
			local tween = tweenS:Create(tweenVal,ti,{Value = n})
			tween:Play()
			tween.Completed:Connect(function()
				tweenVal:Destroy()
			end)
		end

		local ti = TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
		tweenNumber(100,ti,function(val)
			val = val/200
			local start = NumberSequenceKeypoint.new(0,0)
			local a1 = NumberSequenceKeypoint.new(val,0)
			local a2 = NumberSequenceKeypoint.new(math.min(0.5,val+math.min(0.05,val)),1)
			if a1.Time == a2.Time then a2 = a1 end
			local b1 = NumberSequenceKeypoint.new(1-val,0)
			local b2 = NumberSequenceKeypoint.new(math.max(0.5,1-val-math.min(0.05,val)),1)
			if b1.Time == b2.Time then b2 = b1 end
			local goal = NumberSequenceKeypoint.new(1,0)
			backGradient.Transparency = NumberSequence.new({start,a1,a2,b2,b1,goal})
			outlinesGradient.Transparency = NumberSequence.new({start,a1,a2,b2,b1,goal})
		end)

		fastwait(0.4)

		tweenNumber(100,ti,function(val)
			val = val/166.66
			local start = NumberSequenceKeypoint.new(0,0)
			local a1 = NumberSequenceKeypoint.new(val,0)
			local a2 = NumberSequenceKeypoint.new(val+0.01,1)
			local goal = NumberSequenceKeypoint.new(1,1)
			holderGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
		end)

		tweenS:Create(titleText,ti,{Position = UDim2.new(0,60,0,15), TextTransparency = 0}):Play()
		tweenS:Create(descText,ti,{Position = UDim2.new(0,20,0,60), TextTransparency = 0}):Play()

		local function rightTextTransparency(obj)
			tweenNumber(100,ti,function(val)
				val = val/100
				local a1 = NumberSequenceKeypoint.new(1-val,0)
				local a2 = NumberSequenceKeypoint.new(math.max(0,1-val-0.01),1)
				if a1.Time == a2.Time then a2 = a1 end
				local start = NumberSequenceKeypoint.new(0,a1 == a2 and 0 or 1)
				local goal = NumberSequenceKeypoint.new(1,0)
				obj.Transparency = NumberSequence.new({start,a2,a1,goal})
			end)
		end
		rightTextTransparency(versionGradient)
		rightTextTransparency(creatorGradient)

		fastwait(0.9)

		local progressTI = TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

		tweenS:Create(statusText,progressTI,{Position = UDim2.new(0,20,0,120), TextTransparency = 0}):Play()
		tweenS:Create(progressBar,progressTI,{Position = UDim2.new(0,60,0,145), Size = UDim2.new(0,100,0,4)}):Play()

		fastwait(0.25)

		local function setProgress(text,n)
			statusText.Text = text
			tweenS:Create(progressBar.Bar,progressTI,{Size = UDim2.new(n,0,1,0)}):Play()
		end

		local function close()
			tweenS:Create(titleText,progressTI,{TextTransparency = 1}):Play()
			tweenS:Create(descText,progressTI,{TextTransparency = 1}):Play()
			tweenS:Create(versionText,progressTI,{TextTransparency = 1}):Play()
			tweenS:Create(creatorText,progressTI,{TextTransparency = 1}):Play()
			tweenS:Create(statusText,progressTI,{TextTransparency = 1}):Play()
			tweenS:Create(progressBar,progressTI,{BackgroundTransparency = 1}):Play()
			tweenS:Create(progressBar.Bar,progressTI,{BackgroundTransparency = 1}):Play()
			tweenS:Create(progressBar.ImageLabel,progressTI,{ImageTransparency = 1}):Play()

			tweenNumber(100,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),function(val)
				val = val/250
				local start = NumberSequenceKeypoint.new(0,0)
				local a1 = NumberSequenceKeypoint.new(0.6+val,0)
				local a2 = NumberSequenceKeypoint.new(math.min(1,0.601+val),1)
				if a1.Time == a2.Time then a2 = a1 end
				local goal = NumberSequenceKeypoint.new(1,a1 == a2 and 0 or 1)
				holderGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
			end)

			fastwait(0.5)
			gui.Main.BackgroundTransparency = 1
			outlinesGradient.Rotation = 30

			tweenNumber(100,ti,function(val)
				val = val/100
				local start = NumberSequenceKeypoint.new(0,1)
				local a1 = NumberSequenceKeypoint.new(val,1)
				local a2 = NumberSequenceKeypoint.new(math.min(1,val+math.min(0.05,val)),0)
				if a1.Time == a2.Time then a2 = a1 end
				local goal = NumberSequenceKeypoint.new(1,a1 == a2 and 1 or 0)
				outlinesGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
				holderGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
			end)

			fastwait(0.45)
			gui:Destroy()
		end

		return {SetProgress = setProgress, Close = close}
	end

	Main.CreateApp = function(data)
		if Main.MenuApps[data.Name] then return end -- TODO: Handle conflict
		local control = {}

		local app = Main.AppTemplate:Clone()

		local iconIndex = data.Icon
		if data.IconMap and iconIndex then
			if type(iconIndex) == "number" then
				data.IconMap:Display(app.Main.Icon,iconIndex)
			elseif type(iconIndex) == "string" then
				data.IconMap:DisplayByKey(app.Main.Icon,iconIndex)
			end
		elseif type(iconIndex) == "string" then
			app.Main.Icon.Image = iconIndex
		else
			app.Main.Icon.Image = ""
		end

		local function updateState()
			app.Main.BackgroundTransparency = data.Open and 0 or (Lib.CheckMouseInGui(app.Main) and 0 or 1)
			app.Main.Highlight.Visible = data.Open
		end

		local function enable(silent)
			if data.Open then return end
			data.Open = true
			updateState()
			if not silent then
				if data.Window then data.Window:Show() end
				if data.OnClick then data.OnClick(data.Open) end
			end
		end

		local function disable(silent)
			if not data.Open then return end
			data.Open = false
			updateState()
			if not silent then
				if data.Window then data.Window:Hide() end
				if data.OnClick then data.OnClick(data.Open) end
			end
		end

		updateState()

		local ySize = service.TextService:GetTextSize(data.Name,14,Enum.Font.SourceSans,Vector2.new(62,999999)).Y
		app.Main.Size = UDim2.new(1,0,0,math.clamp(46+ySize,60,74))
		app.Main.AppName.Text = data.Name

		app.Main.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				app.Main.BackgroundTransparency = 0
				app.Main.BackgroundColor3 = Settings.Theme.ButtonHover
			end
		end)

		app.Main.InputEnded:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				app.Main.BackgroundTransparency = data.Open and 0 or 1
				app.Main.BackgroundColor3 = Settings.Theme.Button
			end
		end)

		app.Main.MouseButton1Click:Connect(function()
			if data.Open then disable() else enable() end
		end)

		local window = data.Window
		if window then
			window.OnActivate:Connect(function() enable(true) end)
			window.OnDeactivate:Connect(function() disable(true) end)
		end

		app.Visible = true
		app.Parent = Main.AppsContainer
		Main.AppsFrame.CanvasSize = UDim2.new(0,0,0,Main.AppsContainerGrid.AbsoluteCellCount.Y*82 + 8)

		control.Enable = enable
		control.Disable = disable
		Main.MenuApps[data.Name] = control
		return control
	end

	Main.SetMainGuiOpen = function(val)
		Main.MainGuiOpen = val

		Main.MainGui.OpenButton.Text = val and "X" or "Dex"
		if val then Main.MainGui.OpenButton.MainFrame.Visible = true end
		Main.MainGui.OpenButton.MainFrame:TweenSize(val and UDim2.new(0,224,0,200) or UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
		--Main.MainGui.OpenButton.BackgroundTransparency = val and 0 or (Lib.CheckMouseInGui(Main.MainGui.OpenButton) and 0 or 0.2)
		service.TweenService:Create(Main.MainGui.OpenButton,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = val and 0 or (Lib.CheckMouseInGui(Main.MainGui.OpenButton) and 0 or 0.2)}):Play()

		if Main.MainGuiMouseEvent then Main.MainGuiMouseEvent:Disconnect() end

		if not val then
			local startTime = tick()
			Main.MainGuiCloseTime = startTime
			coroutine.wrap(function()
				Lib.FastWait(0.2)
				if not Main.MainGuiOpen and startTime == Main.MainGuiCloseTime then Main.MainGui.OpenButton.MainFrame.Visible = false end
			end)()
		else
			Main.MainGuiMouseEvent = service.UserInputService.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Lib.CheckMouseInGui(Main.MainGui.OpenButton) and not Lib.CheckMouseInGui(Main.MainGui.OpenButton.MainFrame) then

					Main.SetMainGuiOpen(false)
				end
			end)
		end
	end

	Main.CreateMainGui = function()
		local gui = create({
			{1,"ScreenGui",{IgnoreGuiInset=true,Name="MainMenu",}},
			{2,"TextButton",{AnchorPoint=Vector2.new(0.5,0),AutoButtonColor=false,BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),BorderSizePixel=0,Font=4,Name="OpenButton",Parent={1},Position=UDim2.new(0.5,0,0,2),Size=UDim2.new(0,32,0,32),Text="Dex",TextColor3=Color3.new(1,1,1),TextSize=16,TextTransparency=0.20000000298023,}},
			{3,"UICorner",{CornerRadius=UDim.new(0,4),Parent={2},}},
			{4,"Frame",{AnchorPoint=Vector2.new(0.5,0),BackgroundColor3=Color3.new(0.17647059261799,0.17647059261799,0.17647059261799),ClipsDescendants=true,Name="MainFrame",Parent={2},Position=UDim2.new(0.5,0,1,-4),Size=UDim2.new(0,224,0,200),}},
			{5,"UICorner",{CornerRadius=UDim.new(0,4),Parent={4},}},
			{6,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),Name="BottomFrame",Parent={4},Position=UDim2.new(0,0,1,-24),Size=UDim2.new(1,0,0,24),}},
			{7,"UICorner",{CornerRadius=UDim.new(0,4),Parent={6},}},
			{8,"Frame",{BackgroundColor3=Color3.new(0.20392157137394,0.20392157137394,0.20392157137394),BorderSizePixel=0,Name="CoverFrame",Parent={6},Size=UDim2.new(1,0,0,4),}},
			{9,"Frame",{BackgroundColor3=Color3.new(0.1294117718935,0.1294117718935,0.1294117718935),BorderSizePixel=0,Name="Line",Parent={8},Position=UDim2.new(0,0,0,-1),Size=UDim2.new(1,0,0,1),}},
			{10,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Settings",Parent={6},Position=UDim2.new(1,-48,0,0),Size=UDim2.new(0,24,1,0),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
			{11,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://6578871732",ImageTransparency=0.20000000298023,Name="Icon",Parent={10},Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,16,0,16),}},
			{12,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=3,Name="Information",Parent={6},Position=UDim2.new(1,-24,0,0),Size=UDim2.new(0,24,1,0),Text="",TextColor3=Color3.new(1,1,1),TextSize=14,}},
			{13,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://6578933307",ImageTransparency=0.20000000298023,Name="Icon",Parent={12},Position=UDim2.new(0,4,0,4),Size=UDim2.new(0,16,0,16),}},
			{14,"ScrollingFrame",{Active=true,AnchorPoint=Vector2.new(0.5,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.1294117718935,0.1294117718935,0.1294117718935),BorderSizePixel=0,Name="AppsFrame",Parent={4},Position=UDim2.new(0.5,0,0,0),ScrollBarImageColor3=Color3.new(0,0,0),ScrollBarThickness=4,Size=UDim2.new(0,222,1,-25),}},
			{15,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="Container",Parent={14},Position=UDim2.new(0,7,0,8),Size=UDim2.new(1,-14,0,2),}},
			{16,"UIGridLayout",{CellSize=UDim2.new(0,66,0,74),Parent={15},SortOrder=2,}},
			{17,"Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Name="App",Parent={1},Size=UDim2.new(0,100,0,100),Visible=false,}},
			{18,"TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.new(0.2352941185236,0.2352941185236,0.2352941185236),BorderSizePixel=0,Font=3,Name="Main",Parent={17},Size=UDim2.new(1,0,0,60),Text="",TextColor3=Color3.new(0,0,0),TextSize=14,}},
			{19,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://6579106223",ImageRectSize=Vector2.new(32,32),Name="Icon",Parent={18},Position=UDim2.new(0.5,-16,0,4),ScaleType=4,Size=UDim2.new(0,32,0,32),}},
			{20,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=3,Name="AppName",Parent={18},Position=UDim2.new(0,2,0,38),Size=UDim2.new(1,-4,1,-40),Text="Explorer",TextColor3=Color3.new(1,1,1),TextSize=14,TextTransparency=0.10000000149012,TextTruncate=1,TextWrapped=true,TextYAlignment=0,}},
			{21,"Frame",{BackgroundColor3=Color3.new(0,0.66666668653488,1),BorderSizePixel=0,Name="Highlight",Parent={18},Position=UDim2.new(0,0,1,-2),Size=UDim2.new(1,0,0,2),}},
		})
		Main.MainGui = gui
		Main.AppsFrame = gui.OpenButton.MainFrame.AppsFrame
		Main.AppsContainer = Main.AppsFrame.Container
		Main.AppsContainerGrid = Main.AppsContainer.UIGridLayout
		Main.AppTemplate = gui.App
		Main.MainGuiOpen = false

		local openButton = gui.OpenButton
		openButton.BackgroundTransparency = 0.2
		openButton.MainFrame.Size = UDim2.new(0,0,0,0)
		openButton.MainFrame.Visible = false
		openButton.MouseButton1Click:Connect(function()
			Main.SetMainGuiOpen(not Main.MainGuiOpen)
		end)

		openButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				service.TweenService:Create(Main.MainGui.OpenButton,TweenInfo.new(0,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
			end
		end)

		openButton.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				service.TweenService:Create(Main.MainGui.OpenButton,TweenInfo.new(0,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency = Main.MainGuiOpen and 0 or 0.2}):Play()
			end
		end)

		-- Create Main Apps
		Main.CreateApp({Name = "Explorer", IconMap = Main.LargeIcons, Icon = "Explorer", Open = true, Window = Explorer.Window})

		Main.CreateApp({Name = "Properties", IconMap = Main.LargeIcons, Icon = "Properties", Open = true, Window = Properties.Window})

		Main.CreateApp({Name = "Script Viewer", IconMap = Main.LargeIcons, Icon = "Script_Viewer", Window = ScriptViewer.Window})

		local cptsOnMouseClick = nil
		Main.CreateApp({Name = "Click part to select", IconMap = Main.LargeIcons, Icon = 6, OnClick = function(callback)
			if callback then
				local mouse = Main.Mouse
				cptsOnMouseClick = mouse.Button1Down:Connect(function()
					pcall(function()
						local object = mouse.Target
						if nodes[object] then
							selection:Set(nodes[object])
							Explorer.ViewNode(nodes[object])
						end
					end)
				end)
			else if cptsOnMouseClick ~= nil then cptsOnMouseClick:Disconnect() cptsOnMouseClick = nil end end
		end})

		Lib.ShowGui(gui)
	end

	Main.SetupFilesystem = function()
		if not env.writefile or not env.makefolder then return end
		local writefile, makefolder = env.writefile, env.makefolder
		makefolder("dex")
		makefolder("dex/assets")
		makefolder("dex/saved")
		makefolder("dex/plugins")
		makefolder("dex/ModuleCache")
	end

	Main.LocalDepsUpToDate = function()
		return Main.DepsVersionData and Main.ClientVersion == Main.DepsVersionData[1]
	end

	Main.Init = function()
		Main.Elevated = pcall(function() local a = service.CoreGui:GetFullName() end)
		Main.InitEnv()
		Main.LoadSettings()
		Main.SetupFilesystem()

		-- Load Lib
		local intro = Main.CreateIntro("Initializing Library")
		Lib = Main.LoadModule("Lib")
		Lib.FastWait()

		-- Init other stuff
		--Main.IncompatibleTest()

		-- Init icons
		Main.MiscIcons = Lib.IconMap.new("http://www.roblox.com/asset/?id=6511490623",256,256,16,16) -- 6579106223

		Main.MiscIcons:SetDict({
			["Reference"] = 0;
			["Cut"] = 1;
			["Cut_Disabled"] = 2;
			["Copy"] = 3;
			["Copy_Disabled"] = 4;
			["Paste"] = 5;
			["Paste_Disabled"] = 6;
			["Delete"] = 7;
			["Delete_Disabled"] = 8;
			["Group"] = 9;
			["Group_Disabled"] = 10;
			["Ungroup"] = 11;
			["Ungroup_Disabled"] = 12;
			["TeleportTo"] = 13;
			["Rename"] = 14;
			["JumpToParent"] = 15;
			["ExploreData"] = 16;
			["Save"] = 17;
			["CallFunction"] = 18;
			["CallRemote"] = 19;
			["Undo"] = 20,
			["Undo_Disabled"] = 21;
			["Redo"] = 22;
			["Redo_Disabled"] = 23;
			["Expand_Over"] = 24;
			["Expand"] = 25;
			["Collapse_Over"] = 26;
			["Collapse"] = 27;
			["SelectChildren"] = 28;
			["SelectChildren_Disabled"] = 29;
			["InsertObject"] = 30;
			["ViewScript"] = 31;
			["AddStar"] = 32;
			["RemoveStar"] = 33;
			["Script_Disabled"] = 34;
			["LocalScript_Disabled"] = 35;
			["Play"] = 36;
			["Pause"] = 37;
			["Rename_Disabled"] = 38;
		})
		Main.LargeIcons = Lib.IconMap.new("rbxassetid://6579106223",256,256,32,32)
		Main.LargeIcons:SetDict({
			Explorer = 0, Properties = 1, Script_Viewer = 2,
		})

		-- Fetch version if needed
		intro.SetProgress("Fetching Roblox Version",0.2)
		if Main.Elevated then
			local fileVer = Lib.ReadFile("dex/deps_version.dat")
			Main.ClientVersion = Version()

			if fileVer then
				Main.DepsVersionData = string.split(fileVer,"\n")
				if Main.LocalDepsUpToDate() then
					Main.RobloxVersion = Main.DepsVersionData[2]
				end
			end
			Main.RobloxVersion = Main.RobloxVersion or oldgame:HttpGet("http://setup.roblox.com/versionQTStudio")

			-- backup for kaboom
			if #Main.RobloxVersion < 1 then
				Main.RobloxVersion = oldgame:HttpGet("https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/deps_version.dat"):gsub("%s+", "")
			end
		end

		-- Fetch external deps
		intro.SetProgress("Fetching API",0.35)
		API = Main.FetchAPI()
		Lib.FastWait()
		intro.SetProgress("Fetching RMD",0.5)
		RMD = Main.FetchRMD()
		Lib.FastWait()

		-- Save external deps locally if needed
		if Main.Elevated and env.writefile and not Main.LocalDepsUpToDate() then
			env.writefile("dex/deps_version.dat",Main.ClientVersion.."\n"..Main.RobloxVersion)
			env.writefile("dex/rbx_api.dat",Main.RawAPI)
			env.writefile("dex/rbx_rmd.dat",Main.RawRMD)
		end

		-- Load other modules
		intro.SetProgress("Loading Modules",0.75)
		Main.AppControls.Lib.InitDeps(Main.GetInitDeps()) -- Missing deps now available
		Main.LoadModules()
		Lib.FastWait()

		-- Init other modules
		intro.SetProgress("Initializing Modules",0.9)
		Explorer.Init()
		Properties.Init()
		ScriptViewer.Init()
		Lib.FastWait()

		-- Done
		intro.SetProgress("Complete",1)
		coroutine.wrap(function()
			Lib.FastWait(1.25)
			intro.Close()
		end)()

		-- Init window system, create main menu, show explorer and properties
		Lib.Window.Init()
		Main.CreateMainGui()
		Explorer.Window:Show({Align = "right", Pos = 1, Size = 0.5, Silent = true})
		Properties.Window:Show({Align = "right", Pos = 2, Size = 0.5, Silent = true})
		Lib.DeferFunc(function() Lib.Window.ToggleSide("right") end)
	end

	return Main
end)()

-- Start
Main.Init()
    ]==])()
end)

addcmd('olddex', {'odex'}, function(args, speaker)
	notify('Loading old explorer', 'Hold on a sec')

	local getobjects = function(a)
		local Objects = {}
		if a then
			local b = InsertService:LoadLocalAsset(a)
			if b then 
				table.insert(Objects, b) 
			end
		end
		return Objects
	end

	local Dex = getobjects("rbxassetid://10055842438")[1]
	Dex.Parent = PARENT

	local function Load(Obj, Url)
		local function GiveOwnGlobals(Func, Script)
			-- Fix for this edit of dex being poorly made
			-- I (Alex) would like to commemorate whoever added this dex in somehow finding the worst dex to ever exist
			local Fenv, RealFenv, FenvMt = {}, {
				script = Script,
				getupvalue = function(a, b)
					return nil -- force it to use globals
				end,
				getreg = function() -- It loops registry for some idiotic reason so stop it from doing that and just use a global
					return {} -- force it to use globals
				end,
				getprops = getprops or function(inst)
					if getproperties then
						local props = getproperties(inst)
						if props[1] and gethiddenproperty then
							local results = {}
							for _,name in pairs(props) do
								local success, res = pcall(gethiddenproperty, inst, name)
								if success then
									results[name] = res
								end
							end

							return results
						end

						return props
					end

					return {}
				end
			}, {}
			FenvMt.__index = function(a,b)
				return RealFenv[b] == nil and getgenv()[b] or RealFenv[b]
			end
			FenvMt.__newindex = function(a, b, c)
				if RealFenv[b] == nil then 
					getgenv()[b] = c 
				else 
					RealFenv[b] = c 
				end
			end
			setmetatable(Fenv, FenvMt)
			pcall(setfenv, Func, Fenv)
			return Func
		end

		local function LoadScripts(_, Script)
			if Script:IsA("LocalScript") then
				task.spawn(function()
					GiveOwnGlobals(loadstring(Script.Source,"="..Script:GetFullName()), Script)()
				end)
			end
			table.foreach(Script:GetChildren(), LoadScripts)
		end

		LoadScripts(nil, Obj)
	end

	Load(Dex)
end)

addcmd('remotespy',{'rspy'},function(args, speaker)
	notify("Loading",'Hold on a sec')
	-- Full credit to exx, creator of SimpleSpy
	-- also thanks to Amity for fixing
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end)

addcmd('audiologger',{'alogger'},function(args, speaker)
	notify("Loading",'Hold on a sec')
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua'),true))()
end)

local loopgoto = nil
addcmd('loopgoto',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		loopgoto = nil
		if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
			speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
			wait(.1)
		end
		loopgoto = Players[v]
		local distance = 3
		if args[2] and isNumber(args[2]) then
			distance = args[2]
		end
		local lDelay = 0
		if args[3] and isNumber(args[3]) then
			lDelay = args[3]
		end
		repeat
			if Players:FindFirstChild(v) then
				if Players[v].Character ~= nil then
					getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(distance,1,0)
				end
				wait(lDelay)
			else
				loopgoto = nil
			end
		until loopgoto ~= Players[v]
	end
end)

addcmd('unloopgoto',{'noloopgoto'},function(args, speaker)
	loopgoto = nil
end)

addcmd('headsit',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if headSit then headSit:Disconnect() end
	for i,v in pairs(players)do
		speaker.Character:FindFirstChildOfClass('Humanoid').Sit = true
		headSit = RunService.Heartbeat:Connect(function()
			if Players:FindFirstChild(Players[v].Name) and Players[v].Character ~= nil and getRoot(Players[v].Character) and getRoot(speaker.Character) and speaker.Character:FindFirstChildOfClass('Humanoid').Sit == true then
				getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame * CFrame.Angles(0,math.rad(0),0)* CFrame.new(0,1.6,0.4)
			else
				headSit:Disconnect()
			end
		end)
	end
end)

addcmd('chat',{'say'},function(args, speaker)
	local cString = getstring(1)
	chatMessage(cString)
end)


spamming = false
spamspeed = 1
addcmd('spam',{},function(args, speaker)
	spamming = true
	local spamstring = getstring(1)
	repeat wait(spamspeed)
		chatMessage(spamstring)
	until spamming == false
end)

addcmd('nospam',{'unspam'},function(args, speaker)
	spamming = false
end)

addcmd('whisper',{'pm'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		task.spawn(function()
			local plrName = Players[v].Name
			local pmstring = getstring(2)
			chatMessage("/w "..plrName.." "..pmstring)
		end)
	end
end)

pmspamming = {}
addcmd('pmspam',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		task.spawn(function()
			local plrName = Players[v].Name
			if FindInTable(pmspamming, plrName) then return end
			table.insert(pmspamming, plrName)
			local pmspamstring = getstring(2)
			repeat
				if Players:FindFirstChild(v) then
					wait(spamspeed)
					chatMessage("/w "..plrName.." "..pmspamstring)
				else
					for a,b in pairs(pmspamming) do if b == plrName then table.remove(pmspamming, a) end end
				end
			until not FindInTable(pmspamming, plrName)
		end)
	end
end)

addcmd('nopmspam',{'unpmspam'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		task.spawn(function()
			for a,b in pairs(pmspamming) do
				if b == Players[v].Name then
					table.remove(pmspamming, a)
				end
			end
		end)
	end
end)

addcmd('spamspeed',{},function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		spamspeed = speed
	end
end)

addcmd('bubblechat',{},function(args, speaker)
	if isLegacyChat then
		ChatService.BubbleChatEnabled = true
	else
		TextChatService.BubbleChatConfiguration.Enabled = true
	end
end)

addcmd('unbubblechat',{'nobubblechat'},function(args, speaker)
	if isLegacyChat then
		ChatService.BubbleChatEnabled = false
	else
		TextChatService.BubbleChatConfiguration.Enabled = false
	end
end)

addcmd('blockhead',{},function(args, speaker)
	speaker.Character.Head:FindFirstChildOfClass("SpecialMesh"):Destroy()
end)

addcmd('blockhats',{},function(args, speaker)
	for _,v in pairs(speaker.Character:FindFirstChildOfClass('Humanoid'):GetAccessories()) do
		for i,c in pairs(v:GetDescendants()) do
			if c:IsA("SpecialMesh") then
				c:Destroy()
			end
		end
	end
end)

addcmd('blocktool',{},function(args, speaker)
	for _,v in pairs(speaker.Character:GetChildren()) do
		if v:IsA("Tool") or v:IsA("HopperBin") then
			for i,c in pairs(v:GetDescendants()) do
				if c:IsA("SpecialMesh") then
					c:Destroy()
				end
			end
		end
	end
end)

addcmd('creeper',{},function(args, speaker)
	if r15(speaker) then
		speaker.Character.Head:FindFirstChildOfClass("SpecialMesh"):Destroy()
		speaker.Character.LeftUpperArm:Destroy()
		speaker.Character.RightUpperArm:Destroy()
		speaker.Character:FindFirstChildOfClass("Humanoid"):RemoveAccessories()
	else
		speaker.Character.Head:FindFirstChildOfClass("SpecialMesh"):Destroy()
		speaker.Character["Left Arm"]:Destroy()
		speaker.Character["Right Arm"]:Destroy()
		speaker.Character:FindFirstChildOfClass("Humanoid"):RemoveAccessories()
	end
end)

function getTorso(x)
	x = x or Players.LocalPlayer.Character
	return x:FindFirstChild("Torso") or x:FindFirstChild("UpperTorso") or x:FindFirstChild("LowerTorso") or x:FindFirstChild("HumanoidRootPart")
end

addcmd("bang", {"rape"}, function(args, speaker)
	execCmd("unbang")
	wait()
	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	bangAnim = Instance.new("Animation")
	bangAnim.AnimationId = not r15(speaker) and "rbxassetid://148840371" or "rbxassetid://5918726674"
	bang = humanoid:LoadAnimation(bangAnim)
	bang:Play(0.1, 1, 1)
	bang:AdjustSpeed(args[2] or 3)
	bangDied = humanoid.Died:Connect(function()
		bang:Stop()
		bangAnim:Destroy()
		bangDied:Disconnect()
		bangLoop:Disconnect()
	end)
	if args[1] then
		local players = getPlayer(args[1], speaker)
		for _, v in pairs(players) do
			local bangplr = Players[v].Name
			local bangOffet = CFrame.new(0, 0, 1.1)
			bangLoop = RunService.Stepped:Connect(function()
				pcall(function()
					local otherRoot = getTorso(Players[bangplr].Character)
					getRoot(speaker.Character).CFrame = otherRoot.CFrame * bangOffet
				end)
			end)
		end
	end
end)

addcmd("unbang", {"unrape"}, function(args, speaker)
	if bangDied then
		bangDied:Disconnect()
		bang:Stop()
		bangAnim:Destroy()
		bangLoop:Disconnect()
	end
end)

addcmd('carpet',{},function(args, speaker)
	if not r15(speaker) then
		execCmd('uncarpet')
		wait()
		local players = getPlayer(args[1], speaker)
		for i,v in pairs(players)do
			carpetAnim = Instance.new("Animation")
			carpetAnim.AnimationId = "rbxassetid://282574440"
			carpet = speaker.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(carpetAnim)
			carpet:Play(.1, 1, 1)
			local carpetplr = Players[v].Name
			carpetDied = speaker.Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
				carpetLoop:Disconnect()
				carpet:Stop()
				carpetAnim:Destroy()
				carpetDied:Disconnect()
			end)
			carpetLoop = RunService.Heartbeat:Connect(function()
				pcall(function()
					getRoot(Players.LocalPlayer.Character).CFrame = getRoot(Players[carpetplr].Character).CFrame
				end)
			end)
		end
	else
		notify('R6 Required','This command requires the r6 rig type')
	end
end)

addcmd('uncarpet',{'nocarpet'},function(args, speaker)
	if carpetLoop then
		carpetLoop:Disconnect()
		carpetDied:Disconnect()
		carpet:Stop()
		carpetAnim:Destroy()
	end
end)

addcmd('friend',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		speaker:RequestFriendship(Players[v])
	end
end)

addcmd('unfriend',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		speaker:RevokeFriendship(Players[v])
	end
end)

addcmd('bringpart',{},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() and v:IsA("BasePart") then
			v.CFrame = getRoot(speaker.Character).CFrame
		end
	end
end)

addcmd('bringpartclass',{'bpc'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.ClassName:lower() == getstring(1):lower() and v:IsA("BasePart") then
			v.CFrame = getRoot(speaker.Character).CFrame
		end
	end
end)

gotopartDelay = 0.1
addcmd('gotopart',{'topart'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() and v:IsA("BasePart") then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			wait(gotopartDelay)
			getRoot(speaker.Character).CFrame = v.CFrame
		end
	end
end)

addcmd('tweengotopart',{'tgotopart','ttopart'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() and v:IsA("BasePart") then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			wait(gotopartDelay)
			TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = v.CFrame}):Play()
		end
	end
end)

addcmd('gotopartclass',{'gpc'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.ClassName:lower() == getstring(1):lower() and v:IsA("BasePart") then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			wait(gotopartDelay)
			getRoot(speaker.Character).CFrame = v.CFrame
		end
	end
end)

addcmd('tweengotopartclass',{'tgpc'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.ClassName:lower() == getstring(1):lower() and v:IsA("BasePart") then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			wait(gotopartDelay)
			TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = v.CFrame}):Play()
		end
	end
end)

addcmd('gotomodel',{'tomodel'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() and v:IsA("Model") then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			wait(gotopartDelay)
			getRoot(speaker.Character).CFrame = v:GetModelCFrame()
		end
	end
end)

addcmd('tweengotomodel',{'tgotomodel','ttomodel'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1):lower() and v:IsA("Model") then
			if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				wait(.1)
			end
			wait(gotopartDelay)
			TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = v:GetModelCFrame()}):Play()
		end
	end
end)

addcmd('gotopartdelay',{},function(args, speaker)
	local gtpDelay = args[1] or 0.1
	if isNumber(gtpDelay) then
		gotopartDelay = gtpDelay
	end
end)

addcmd('noclickdetectorlimits',{'nocdlimits','removecdlimits'},function(args, speaker)
	for i,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ClickDetector") then
			v.MaxActivationDistance = math.huge
		end
	end
end)

addcmd('fireclickdetectors',{'firecd','firecds'}, function(args, speaker)
	if fireclickdetector then
		if args[1] then
			local name = getstring(1)
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("ClickDetector") and descendant.Name == name or descendant.Parent.Name == name then
					fireclickdetector(descendant)
				end
			end
		else
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("ClickDetector") then
					fireclickdetector(descendant)
				end
			end
		end
	else
		notify("Incompatible Exploit", "Your exploit does not support this command (missing fireclickdetector)")
	end
end)

addcmd('noproximitypromptlimits',{'nopplimits','removepplimits'},function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			v.MaxActivationDistance = math.huge
		end
	end
end)

addcmd('fireproximityprompts',{'firepp'},function(args, speaker)
	if fireproximityprompt then
		if args[1] then
			local name = getstring(1)
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") and descendant.Name == name or descendant.Parent.Name == name then
					fireproximityprompt(descendant)
				end
			end
		else
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					fireproximityprompt(descendant)
				end
			end
		end
	else
		notify("Incompatible Exploit", "Your exploit does not support this command (missing fireproximityprompt)")
	end
end)

local PromptButtonHoldBegan = nil
addcmd('instantproximityprompts',{'instantpp'},function(args, speaker)
	if fireproximityprompt then
		execCmd("uninstantproximityprompts")
		wait(0.1)
		PromptButtonHoldBegan = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
			fireproximityprompt(prompt)
		end)
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing fireproximityprompt)')
	end
end)

addcmd('uninstantproximityprompts',{'uninstantpp'},function(args, speaker)
	if PromptButtonHoldBegan ~= nil then
		PromptButtonHoldBegan:Disconnect()
		PromptButtonHoldBegan = nil
	end
end)

addcmd('notifyping',{'ping'},function(args, speaker)
	notify("Ping", math.round(speaker:GetNetworkPing() * 1000) .. "ms")
end)

addcmd('grabtools', {}, function(args, speaker)
	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	for _, child in ipairs(workspace:GetChildren()) do
		if speaker.Character and child:IsA("BackpackItem") and child:FindFirstChild("Handle") then
			humanoid:EquipTool(child)
		end
	end

	if grabtoolsFunc then 
		grabtoolsFunc:Disconnect() 
	end

	grabtoolsFunc = workspace.ChildAdded:Connect(function(child)
		if speaker.Character and child:IsA("BackpackItem") and child:FindFirstChild("Handle") then
			humanoid:EquipTool(child)
		end
	end)

	notify("Grabtools", "Picking up any dropped tools")
end)

addcmd('nograbtools',{'ungrabtools'},function(args, speaker)
	if grabtoolsFunc then 
		grabtoolsFunc:Disconnect() 
	end

	notify("Grabtools", "Grabtools has been disabled")
end)

local specifictoolremoval = {}
addcmd('removespecifictool',{},function(args, speaker)
	if args[1] and speaker:FindFirstChildOfClass("Backpack") then
		local tool = string.lower(getstring(1))
		local RST = RunService.RenderStepped:Connect(function()
			if speaker:FindFirstChildOfClass("Backpack") then
				for i,v in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
					if v.Name:lower() == tool then
						v:Remove()
					end
				end
			end
		end)
		specifictoolremoval[tool] = RST
	end
end)

addcmd('unremovespecifictool',{},function(args, speaker)
	if args[1] then
		local tool = string.lower(getstring(1))
		if specifictoolremoval[tool] ~= nil then
			specifictoolremoval[tool]:Disconnect()
			specifictoolremoval[tool] = nil
		end
	end
end)

addcmd('clearremovespecifictool',{},function(args, speaker)
	for obj in pairs(specifictoolremoval) do
		specifictoolremoval[obj]:Disconnect()
		specifictoolremoval[obj] = nil
	end
end)

addcmd('light',{},function(args, speaker)
	local light = Instance.new("PointLight")
	light.Parent = getRoot(speaker.Character)
	light.Range = 30
	if args[1] then
		light.Brightness = args[2]
		light.Range = args[1]
	else
		light.Brightness = 5
	end
end)

addcmd('unlight',{'nolight'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v.ClassName == "PointLight" then
			v:Destroy()
		end
	end
end)

addcmd('copytools',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		task.spawn(function()
			for i,v in pairs(Players[v]:FindFirstChildOfClass("Backpack"):GetChildren()) do
				if v:IsA('Tool') or v:IsA('HopperBin') then
					v:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
				end
			end
		end)
	end
end)

addcmd('naked',{},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Clothing") or v:IsA("ShirtGraphic") then
			v:Destroy()
		end
	end
end)

addcmd('noface',{'removeface'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Decal") and v.Name == 'face' then
			v:Destroy()
		end
	end
end)

addcmd('spawnpoint',{'spawn'},function(args, speaker)
	spawnpos = getRoot(speaker.Character).CFrame
	spawnpoint = true
	spDelay = tonumber(args[1]) or 0.1
	notify('Spawn Point','Spawn point created at '..tostring(spawnpos))
end)

addcmd('nospawnpoint',{'nospawn','removespawnpoint'},function(args, speaker)
	spawnpoint = false
	notify('Spawn Point','Removed spawn point')
end)

addcmd('flashback',{'diedtp'},function(args, speaker)
	if lastDeath ~= nil then
		if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
			speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
			wait(.1)
		end
		getRoot(speaker.Character).CFrame = lastDeath
	end
end)

addcmd('hatspin',{'spinhats'},function(args, speaker)
	execCmd('unhatspin')
	wait(.5)
	for _,v in pairs(speaker.Character:FindFirstChildOfClass('Humanoid'):GetAccessories()) do
		local keep = Instance.new("BodyPosition") keep.Name = randomString() keep.Parent = v.Handle
		local spin = Instance.new("BodyAngularVelocity") spin.Name = randomString() spin.Parent = v.Handle
		v.Handle:FindFirstChildOfClass("Weld"):Destroy()
		if args[1] then
			spin.AngularVelocity = Vector3.new(0, args[1], 0)
			spin.MaxTorque = Vector3.new(0, args[1] * 2, 0)
		else
			spin.AngularVelocity = Vector3.new(0, 100, 0)
			spin.MaxTorque = Vector3.new(0, 200, 0)
		end
		keep.P = 30000
		keep.D = 50
		spinhats = RunService.Stepped:Connect(function()
			pcall(function()
				keep.Position = Players.LocalPlayer.Character.Head.Position
			end)
		end)
	end
end)

addcmd('unhatspin',{'unspinhats'},function(args, speaker)
	if spinhats then
		spinhats:Disconnect()
	end
	for _,v in pairs(speaker.Character:FindFirstChildOfClass('Humanoid'):GetAccessories()) do
		v.Parent = workspace
		for i,c in pairs(v.Handle) do
			if c:IsA("BodyPosition") or c:IsA("BodyAngularVelocity") then
				c:Destroy()
			end
		end
		wait()
		v.Parent = speaker.Character
	end
end)

addcmd('clearhats',{'cleanhats'},function(args, speaker)
	if firetouchinterest then
		local Player = Players.LocalPlayer
		local Character = Player.Character
		local Old = Character:FindFirstChild("HumanoidRootPart").CFrame
		local Hats = {}

		for _, child in ipairs(workspace:GetChildren()) do
			if child:IsA("Accessory") then
				table.insert(Hats, child)
			end
		end

		for _, accessory in ipairs(Character:FindFirstChildOfClass("Humanoid"):GetAccessories()) do
			accessory:Destroy()
		end

		for i = 1, #Hats do
			repeat RunService.Heartbeat:wait() until Hats[i]
			firetouchinterest(Hats[i].Handle,Character:FindFirstChild("HumanoidRootPart"),0)
			repeat RunService.Heartbeat:wait() until Character:FindFirstChildOfClass("Accessory")
			Character:FindFirstChildOfClass("Accessory"):Destroy()
			repeat RunService.Heartbeat:wait() until not Character:FindFirstChildOfClass("Accessory")
		end

		execCmd("reset")

		Player.CharacterAdded:Wait()

		for i = 1,20 do 
			RunService.Heartbeat:Wait()
			if Player.Character:FindFirstChild("HumanoidRootPart") then
				Player.Character:FindFirstChild("HumanoidRootPart").CFrame = Old
			end
		end
	else
		notify("Incompatible Exploit","Your exploit does not support this command (missing firetouchinterest)")
	end
end)

addcmd('split',{},function(args, speaker)
	if r15(speaker) then
		speaker.Character.UpperTorso.Waist:Destroy()
	else
		notify('R15 Required','This command requires the r15 rig type')
	end
end)

addcmd('nilchar',{},function(args, speaker)
	if speaker.Character ~= nil then
		speaker.Character.Parent = nil
	end
end)

addcmd('unnilchar',{'nonilchar'},function(args, speaker)
	if speaker.Character ~= nil then
		speaker.Character.Parent = workspace
	end
end)

addcmd('noroot',{'removeroot','rroot'},function(args, speaker)
	if speaker.Character ~= nil then
		local char = Players.LocalPlayer.Character
		char.Parent = nil
		char.HumanoidRootPart:Destroy()
		char.Parent = workspace
	end
end)

addcmd('replaceroot',{'replacerootpart'},function(args, speaker)
	if speaker.Character ~= nil and speaker.Character:FindFirstChild("HumanoidRootPart") then
		local Char = speaker.Character
		local OldParent = Char.Parent
		local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
		local OldPos = HRP.CFrame
		Char.Parent = game
		local HRP1 = HRP:Clone()
		HRP1.Parent = Char
		HRP = HRP:Destroy()
		HRP1.CFrame = OldPos
		Char.Parent = OldParent
	end
end)

addcmd('clearcharappearance',{'clearchar','clrchar'},function(args, speaker)
	speaker:ClearCharacterAppearance()
end)

addcmd('equiptools',{},function(args, speaker)
	for i,v in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
		if v:IsA("Tool") or v:IsA("HopperBin") then
			v.Parent = speaker.Character
		end
	end
end)

addcmd('unequiptools',{},function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid'):UnequipTools()
end)

local function GetHandleTools(p)
	p = p or Players.LocalPlayer
	local r = {}
	for _, v in ipairs(p.Character and p.Character:GetChildren() or {}) do
		if v.IsA(v, "BackpackItem") and v.FindFirstChild(v, "Handle") then
			r[#r + 1] = v
		end
	end
	for _, v in ipairs(p.Backpack:GetChildren()) do
		if v.IsA(v, "BackpackItem") and v.FindFirstChild(v, "Handle") then
			r[#r + 1] = v
		end
	end
	return r
end
addcmd('dupetools', {'clonetools'}, function(args, speaker)
	local LOOP_NUM = tonumber(args[1]) or 1
	local OrigPos = speaker.Character.HumanoidRootPart.Position
	local Tools, TempPos = {}, Vector3.new(math.random(-2e5, 2e5), 2e5, math.random(-2e5, 2e5))
	for i = 1, LOOP_NUM do
		local Human = speaker.Character:WaitForChild("Humanoid")
		wait(.1, Human.Parent:MoveTo(TempPos))
		Human.RootPart.Anchored = speaker:ClearCharacterAppearance(wait(.1)) or true
		local t = GetHandleTools(speaker)
		while #t > 0 do
			for _, v in ipairs(t) do
				task.spawn(function()
					for _ = 1, 25 do
						v.Parent = speaker.Character
						v.Handle.Anchored = true
					end
					for _ = 1, 5 do
						v.Parent = workspace
					end
					table.insert(Tools, v.Handle)
				end)
			end
			t = GetHandleTools(speaker)
		end
		wait(.1)
		speaker.Character = speaker.Character:Destroy()
		speaker.CharacterAdded:Wait():WaitForChild("Humanoid").Parent:MoveTo(LOOP_NUM == i and OrigPos or TempPos, wait(.1))
		if i == LOOP_NUM or i % 5 == 0 then
			local HRP = speaker.Character.HumanoidRootPart
			if type(firetouchinterest) == "function" then
				for _, v in ipairs(Tools) do
					v.Anchored = not firetouchinterest(v, HRP, 1, firetouchinterest(v, HRP, 0)) and false or false
				end
			else
				for _, v in ipairs(Tools) do
					task.spawn(function()
						local x = v.CanCollide
						v.CanCollide = false
						v.Anchored = false
						for _ = 1, 10 do
							v.CFrame = HRP.CFrame
							wait()
						end
						v.CanCollide = x
					end)
				end
			end
			wait(.1)
			Tools = {}
		end
		TempPos = TempPos + Vector3.new(10, math.random(-5, 5), 0)
	end
end)

local RS = RunService.RenderStepped

addcmd('touchinterests', {'touchinterest', 'firetouchinterests', 'firetouchinterest'}, function(args, speaker)
	if not firetouchinterest then
		notify("Incompatible Exploit", "Your exploit does not support this command (missing firetouchinterest)")
		return
	end

	local root = getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart")

	local function touch(x)
		x = x:FindFirstAncestorWhichIsA("Part")
		if x then
			if firetouchinterest then
				task.spawn(function()
					firetouchinterest(x, root, 1)
					wait()
					firetouchinterest(x, root, 0)
				end)
			end
			x.CFrame = root.CFrame
		end
	end

	if args[1] then
		local name = getstring(1)
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("TouchTransmitter") and descendant.Name == name or descendant.Parent.Name == name then
				touch(descendant)
			end
		end
	else
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("TouchTransmitter") then
				touch(descendant)
			end
		end
	end
end)

addcmd('fullbright',{'fb','fullbrightness'},function(args, speaker)
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.GlobalShadows = false
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

addcmd('loopfullbright',{'loopfb'},function(args, speaker)
	if brightLoop then
		brightLoop:Disconnect()
	end
	local function brightFunc()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end

	brightLoop = RunService.RenderStepped:Connect(brightFunc)
end)

addcmd('unloopfullbright',{'unloopfb'},function(args, speaker)
	if brightLoop then
		brightLoop:Disconnect()
	end
end)

addcmd('ambient',{},function(args, speaker)
	Lighting.Ambient = Color3.new(args[1],args[2],args[3])
	Lighting.OutdoorAmbient = Color3.new(args[1],args[2],args[3])
end)

addcmd('day',{},function(args, speaker)
	Lighting.ClockTime = 14
end)

addcmd('night',{},function(args, speaker)
	Lighting.ClockTime = 0
end)

addcmd('nofog',{},function(args, speaker)
	Lighting.FogEnd = 100000
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
end)

addcmd('brightness',{},function(args, speaker)
	Lighting.Brightness = args[1]
end)

addcmd('globalshadows',{'gshadows'},function(args, speaker)
	Lighting.GlobalShadows = true
end)

addcmd('unglobalshadows',{'nogshadows','ungshadows','noglobalshadows'},function(args, speaker)
	Lighting.GlobalShadows = false
end)

origsettings = {abt = Lighting.Ambient, oabt = Lighting.OutdoorAmbient, brt = Lighting.Brightness, time = Lighting.ClockTime, fe = Lighting.FogEnd, fs = Lighting.FogStart, gs = Lighting.GlobalShadows}

addcmd('restorelighting',{'rlighting'},function(args, speaker)
	Lighting.Ambient = origsettings.abt
	Lighting.OutdoorAmbient = origsettings.oabt
	Lighting.Brightness = origsettings.brt
	Lighting.ClockTime = origsettings.time
	Lighting.FogEnd = origsettings.fe
	Lighting.FogStart = origsettings.fs
	Lighting.GlobalShadows = origsettings.gs
end)

addcmd('stun',{'platformstand'},function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
end)

addcmd('unstun',{'nostun','unplatformstand','noplatformstand'},function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
end)

addcmd('norotate',{'noautorotate'},function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid').AutoRotate  = false
end)

addcmd('unnorotate',{'autorotate'},function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid').AutoRotate  = true
end)

addcmd('enablestate',{},function(args, speaker)
	local x = args[1]
	if not tonumber(x) then
		local x = Enum.HumanoidStateType[args[1]]
	end
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(x, true)
end)

addcmd('disablestate',{},function(args, speaker)
	local x = args[1]
	if not tonumber(x) then
		local x = Enum.HumanoidStateType[args[1]]
	end
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(x, false)
end)

addcmd('drophats',{'drophat'},function(args, speaker)
	if speaker.Character then
		for _,v in pairs(speaker.Character:FindFirstChildOfClass('Humanoid'):GetAccessories()) do
			v.Parent = workspace
		end
	end
end)

addcmd('deletehats',{'nohats','rhats'},function(args, speaker)
	for i,v in next, speaker.Character:GetDescendants() do
		if v:IsA("Accessory") then
			for i,p in next, v:GetDescendants() do
				if p:IsA("Weld") then
					p:Destroy()
				end
			end
		end
	end
end)

addcmd('droptools',{'droptool'},function(args, speaker)
	for i,v in pairs(Players.LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = Players.LocalPlayer.Character
		end
	end
	wait()
	for i,v in pairs(Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = workspace
		end
	end
end)

addcmd('droppabletools',{},function(args, speaker)
	if speaker.Character then
		for _,obj in pairs(speaker.Character:GetChildren()) do
			if obj:IsA("Tool") then
				obj.CanBeDropped = true
			end
		end
	end
	if speaker:FindFirstChildOfClass("Backpack") then
		for _,obj in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
			if obj:IsA("Tool") then
				obj.CanBeDropped = true
			end
		end
	end
end)

local currentToolSize = ""
local currentGripPos = ""
addcmd('reach',{},function(args, speaker)
	execCmd('unreach')
	wait()
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			if args[1] then
				currentToolSize = v.Handle.Size
				currentGripPos = v.GripPos
				local a = Instance.new("SelectionBox")
				a.Name = "SelectionBoxCreated"
				a.Parent = v.Handle
				a.Adornee = v.Handle
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5,0.5,args[1])
				v.GripPos = Vector3.new(0,0,0)
				speaker.Character:FindFirstChildOfClass('Humanoid'):UnequipTools()
			else
				currentToolSize = v.Handle.Size
				currentGripPos = v.GripPos
				local a = Instance.new("SelectionBox")
				a.Name = "SelectionBoxCreated"
				a.Parent = v.Handle
				a.Adornee = v.Handle
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5,0.5,60)
				v.GripPos = Vector3.new(0,0,0)
				speaker.Character:FindFirstChildOfClass('Humanoid'):UnequipTools()
			end
		end
	end
end)

addcmd("boxreach", {}, function(args, speaker)
    execCmd("unreach")
    wait()
    for i, v in pairs(speaker.Character:GetDescendants()) do
        if v:IsA("Tool") then
            local size = tonumber(args[1]) or 60
            currentToolSize = v.Handle.Size
            currentGripPos = v.GripPos
            local a = Instance.new("SelectionBox")
            a.Name = "SelectionBoxCreated"
            a.Parent = v.Handle
            a.Adornee = v.Handle
            v.Handle.Massless = true
            v.Handle.Size = Vector3.new(size, size, size)
            v.GripPos = Vector3.new(0, 0, 0)
            speaker.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
        end
    end
end)

addcmd('unreach',{'noreach','unboxreach'},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			v.Handle.Size = currentToolSize
			v.GripPos = currentGripPos
			v.Handle.SelectionBoxCreated:Destroy()
		end
	end
end)

addcmd('grippos',{},function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			v.Parent = speaker:FindFirstChildOfClass("Backpack")
			v.GripPos = Vector3.new(args[1],args[2],args[3])
			v.Parent = speaker.Character
		end
	end
end)

addcmd('usetools', {}, function(args, speaker)
	local Backpack = speaker:FindFirstChildOfClass("Backpack")
	local amount = tonumber(args[1]) or 1
	local delay_ = tonumber(args[2]) or false
	for _, v in ipairs(Backpack:GetChildren()) do
		v.Parent = speaker.Character
		task.spawn(function()
			for _ = 1, amount do
				v:Activate()
				if delay_ then
					wait(delay_)
				end
			end
			v.Parent = Backpack
		end)
	end
end)

addcmd('logs',{},function(args, speaker)
	logs:TweenPosition(UDim2.new(0, 0, 1, -265), "InOut", "Quart", 0.3, true, nil)
end)

addcmd('chatlogs',{'clogs'},function(args, speaker)
	join.Visible = false
	chat.Visible = true
	table.remove(shade3,table.find(shade3,selectChat))
	table.remove(shade2,table.find(shade2,selectJoin))
	table.insert(shade2,selectChat)
	table.insert(shade3,selectJoin)
	selectJoin.BackgroundColor3 = currentShade3
	selectChat.BackgroundColor3 = currentShade2
	logs:TweenPosition(UDim2.new(0, 0, 1, -265), "InOut", "Quart", 0.3, true, nil)
end)

addcmd('joinlogs',{'jlogs'},function(args, speaker)
	chat.Visible = false
	join.Visible = true	
	table.remove(shade3,table.find(shade3,selectJoin))
	table.remove(shade2,table.find(shade2,selectChat))
	table.insert(shade2,selectJoin)
	table.insert(shade3,selectChat)
	selectChat.BackgroundColor3 = currentShade3
	selectJoin.BackgroundColor3 = currentShade2
	logs:TweenPosition(UDim2.new(0, 0, 1, -265), "InOut", "Quart", 0.3, true, nil)
end)

addcmd("chatlogswebhook", {"logswebhook"}, function(args, speaker)
    if httprequest then
        logsWebhook = args[1] or nil
        updatesaves()
    else
        notify("Incompatible Exploit", "Your exploit does not support this command (missing request)")
    end
end)

addcmd("antichatlogs", {"antichatlogger"}, function(args, speaker)
    if not isLegacyChat then
        return notify("antichatlogs", "Game needs the legacy chat")
    end
    local MessagePosted, _ = pcall(function()
        rawset(require(speaker:FindFirstChild("PlayerScripts"):FindFirstChild("ChatScript").ChatMain), "MessagePosted", {
            ["fire"] = function(msg)
                return msg
            end,
            ["wait"] = function()
                return
            end,
            ["connect"] = function()
                return
            end
        })
    end)
    notify("antichatlogs", MessagePosted and "Enabled" or "Failed to enable antichatlogs")
end)

flinging = false
addcmd('fling',{},function(args, speaker)
	flinging = false
	for _, child in pairs(speaker.Character:GetDescendants()) do
		if child:IsA("BasePart") then
			child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
		end
	end
	execCmd('noclip')
	wait(.1)
	local bambam = Instance.new("BodyAngularVelocity")
	bambam.Name = randomString()
	bambam.Parent = getRoot(speaker.Character)
	bambam.AngularVelocity = Vector3.new(0,99999,0)
	bambam.MaxTorque = Vector3.new(0,math.huge,0)
	bambam.P = math.huge
	local Char = speaker.Character:GetChildren()
	for i, v in next, Char do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.Massless = true
			v.Velocity = Vector3.new(0, 0, 0)
		end
	end
	flinging = true
	local function flingDiedF()
		execCmd('unfling')
	end
	flingDied = speaker.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDiedF)
	repeat
		bambam.AngularVelocity = Vector3.new(0,99999,0)
		wait(.2)
		bambam.AngularVelocity = Vector3.new(0,0,0)
		wait(.1)
	until flinging == false
end)

addcmd('unfling',{'nofling'},function(args, speaker)
	execCmd('clip')
	if flingDied then
		flingDied:Disconnect()
	end
	flinging = false
	wait(.1)
	local speakerChar = speaker.Character
	if not speakerChar or not getRoot(speakerChar) then return end
	for i,v in pairs(getRoot(speakerChar):GetChildren()) do
		if v.ClassName == 'BodyAngularVelocity' then
			v:Destroy()
		end
	end
	for _, child in pairs(speakerChar:GetDescendants()) do
		if child.ClassName == "Part" or child.ClassName == "MeshPart" then
			child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		end
	end
end)

addcmd('togglefling',{},function(args, speaker)
	if flinging then
		execCmd('unfling')
	else
		execCmd('fling')
	end
end)

addcmd("flyfling", {}, function(args, speaker)
    execCmd("unvehiclefly\\unwalkfling")
    wait()
    if args[1] and isNumber(args[1]) then
        vehicleflyspeed = args[1]
    end
    execCmd("vehiclefly\\walkfling")
end)

addcmd("unflyfling", {}, function(args, speaker)
    execCmd("unvehiclefly\\unwalkfling\\breakvelocity")
end)

addcmd("toggleflyfling", {}, function(args, speaker)
    execCmd(flinging and "unflyfling" or "flyfling")
end)

walkflinging = false
addcmd("walkfling", {}, function(args, speaker)
    execCmd("unwalkfling")
    local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            execCmd("unwalkfling")
        end)
    end

    execCmd("noclip nonotify")
    walkflinging = true
    repeat RunService.Heartbeat:Wait()
        local character = speaker.Character
        local root = getRoot(character)
        local vel, movel = nil, 0.1

        while not (character and character.Parent and root and root.Parent) do
            RunService.Heartbeat:Wait()
            character = speaker.Character
            root = getRoot(character)
        end

        vel = root.Velocity
        root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

        RunService.RenderStepped:Wait()
        if character and character.Parent and root and root.Parent then
            root.Velocity = vel
        end

        RunService.Stepped:Wait()
        if character and character.Parent and root and root.Parent then
            root.Velocity = vel + Vector3.new(0, movel, 0)
            movel = movel * -1
        end
    until walkflinging == false
end)

addcmd("unwalkfling", {"nowalkfling"}, function(args, speaker)
    walkflinging = false
    execCmd("unnoclip nonotify")
end)

addcmd("togglewalkfling", {}, function(args, speaker)
    execCmd(walkflinging and "unwalkfling" or "walkfling")
end)

addcmd('invisfling',{},function(args, speaker)
	local ch = speaker.Character
	ch:FindFirstChildWhichIsA("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	local prt=Instance.new("Model")
	prt.Parent = speaker.Character
	local z1 = Instance.new("Part")
	z1.Name="Torso"
	z1.CanCollide = false
	z1.Anchored = true
	local z2 = Instance.new("Part")
	z2.Name="Head"
	z2.Parent = prt
	z2.Anchored = true
	z2.CanCollide = false
	local z3 =Instance.new("Humanoid")
	z3.Name="Humanoid"
	z3.Parent = prt
	z1.Position = Vector3.new(0,9999,0)
	speaker.Character=prt
	wait(3)
	speaker.Character=ch
	wait(3)
	local Hum = Instance.new("Humanoid")
	z2:Clone()
	Hum.Parent = speaker.Character
	local root =  getRoot(speaker.Character)
	for i,v in pairs(speaker.Character:GetChildren()) do
		if v ~= root and  v.Name ~= "Humanoid" then
			v:Destroy()
		end
	end
	root.Transparency = 0
	root.Color = Color3.new(1, 1, 1)
	local invisflingStepped
	invisflingStepped = RunService.Stepped:Connect(function()
		if speaker.Character and getRoot(speaker.Character) then
			getRoot(speaker.Character).CanCollide = false
		else
			invisflingStepped:Disconnect()
		end
	end)
	sFLY()
	workspace.CurrentCamera.CameraSubject = root
	local bambam = Instance.new("BodyThrust")
	bambam.Parent = getRoot(speaker.Character)
	bambam.Force = Vector3.new(99999,99999*10,99999)
	bambam.Location = getRoot(speaker.Character).Position
end)

addcmd("antifling", {}, function(args, speaker)
    if antifling then
        antifling:Disconnect()
        antifling = nil
    end
    antifling = RunService.Stepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= speaker and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end)

addcmd("unantifling", {}, function(args, speaker)
    if antifling then
        antifling:Disconnect()
        antifling = nil
    end
end)

addcmd("toggleantifling", {}, function(args, speaker)
    execCmd(antifling and "unantifling" or "antifling")
end)

function attach(speaker,target)
	if tools(speaker) then
		local char = speaker.Character
		local tchar = target.Character
		local hum = speaker.Character:FindFirstChildOfClass("Humanoid")
		local hrp = getRoot(speaker.Character)
		local hrp2 = getRoot(target.Character)
		hum.Name = "1"
		local newHum = hum:Clone()
		newHum.Parent = char
		newHum.Name = "Humanoid"
		wait()
		hum:Destroy()
		workspace.CurrentCamera.CameraSubject = char
		newHum.DisplayDistanceType = "None"
		local tool = speaker:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool") or speaker.Character:FindFirstChildOfClass("Tool")
		tool.Parent = char
		hrp.CFrame = hrp2.CFrame * CFrame.new(0, 0, 0) * CFrame.new(math.random(-100, 100)/200,math.random(-100, 100)/200,math.random(-100, 100)/200)
		local n = 0
		repeat
			wait(.1)
			n = n + 1
			hrp.CFrame = hrp2.CFrame
		until (tool.Parent ~= char or not hrp or not hrp2 or not hrp.Parent or not hrp2.Parent or n > 250) and n > 2
	else
		notify('Tool Required','You need to have an item in your inventory to use this command')
	end
end

function kill(speaker,target,fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = getRoot(speaker.Character).CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and getRoot(speaker.Character)
				wait(0.3)
			end
			local hrp = getRoot(speaker.Character)
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = CFrame.new(999999, workspace.FallenPartsDestroyHeight + 5,999999)
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	else
		notify('Tool Required','You need to have an item in your inventory to use this command')
	end
end

addcmd("handlekill", {"hkill"}, function(args, speaker)
	if not firetouchinterest then
		return notify("Incompatible Exploit", "Your exploit does not support this command (missing firetouchinterest)")
	end
	if not speaker.Character then return end
	local tool = speaker.Character:FindFirstChildWhichIsA("Tool")
	local handle = tool and tool:FindFirstChild("Handle")
	if not handle then
		return notify("Handle Kill", "You need to hold a \"Tool\" that does damage on touch. For example a common Sword tool.")
	end
	local range = tonumber(args[2]) or math.huge
    if range ~= math.huge then notify("Handle Kill", ("Started!\nRadius: %s"):format(tostring(range):upper())) end

	while task.wait() and speaker.Character and tool.Parent and tool.Parent == speaker.Character do
		for _, plr in next, getPlayer(args[1], speaker) do
			plr = Players[plr]
			if plr ~= speaker and plr.Character then
				local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
				local root = hum and getRoot(plr.Character)

				if root and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead and speaker:DistanceFromCharacter(root.Position) <= range then
					firetouchinterest(handle, root, 1)
					firetouchinterest(handle, root, 0)
				end
			end
		end
	end

	notify("Handle Kill", "Stopped!")
end)

local hb = RunService.Heartbeat
addcmd('tpwalk', {'teleportwalk'}, function(args, speaker)
	tpwalking = true
	local chr = speaker.Character
	local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
	while tpwalking and chr and hum and hum.Parent do
		local delta = hb:Wait()
		if hum.MoveDirection.Magnitude > 0 then
			if args[1] and isNumber(args[1]) then
				chr:TranslateBy(hum.MoveDirection * tonumber(args[1]) * delta * 10)
			else
				chr:TranslateBy(hum.MoveDirection * delta * 10)
			end
		end
	end
end)

addcmd('untpwalk', {'unteleportwalk'}, function(args, speaker)
	tpwalking = false
end)

function bring(speaker,target,fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = getRoot(speaker.Character).CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and getRoot(speaker.Character)
				wait(0.3)
			end
			local hrp = getRoot(speaker.Character)
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = NormPos
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	else
		notify('Tool Required','You need to have an item in your inventory to use this command')
	end
end

function teleport(speaker,target,target2,fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = getRoot(speaker.Character).CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and getRoot(speaker.Character)
				wait(0.3)
			end
			local hrp = getRoot(speaker.Character)
			local hrp2 = getRoot(target2.Character)
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = hrp2.CFrame
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			wait(1)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	else
		notify('Tool Required','You need to have an item in your inventory to use this command')
	end
end

addcmd('spin',{},function(args, speaker)
	local spinSpeed = 20
	if args[1] and isNumber(args[1]) then
		spinSpeed = args[1]
	end
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
	local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spinning"
	Spin.Parent = getRoot(speaker.Character)
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
end)

addcmd('unspin',{},function(args, speaker)
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
end)

xrayEnabled = false
xray = function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") and not v.Parent.Parent:FindFirstChildWhichIsA("Humanoid") then
            v.LocalTransparencyModifier = xrayEnabled and 0.5 or 0
        end
    end
end

addcmd("xray", {}, function(args, speaker)
    xrayEnabled = true
    xray()
end)

addcmd("unxray", {"noxray"}, function(args, speaker)
    xrayEnabled = false
    xray()
end)

addcmd("togglexray", {}, function(args, speaker)
    xrayEnabled = not xrayEnabled
    xray()
end)

addcmd("loopxray", {}, function(args, speaker)
    if xrayLoop then
        xrayLoop:Disconnect()
    end
    xrayLoop = RunService.RenderStepped:Connect(function()
        xrayEnabled = true
        xray()
    end)
end)

addcmd("unloopxray", {}, function(args, speaker)
    if xrayLoop then
        xrayLoop:Disconnect()
    end
end)

local walltpTouch = nil
addcmd('walltp',{},function(args, speaker)
	local torso
	if r15(speaker) then
		torso = speaker.Character.UpperTorso
	else
		torso = speaker.Character.Torso
	end
	local function touchedFunc(hit)
		local Root = getRoot(speaker.Character)
		if hit:IsA("BasePart") and hit.Position.Y > Root.Position.Y - speaker.Character:FindFirstChildOfClass('Humanoid').HipHeight then
			local hitP = getRoot(hit.Parent)
			if hitP ~= nil then
				Root.CFrame = hit.CFrame * CFrame.new(Root.CFrame.lookVector.X,hitP.Size.Z/2 + speaker.Character:FindFirstChildOfClass('Humanoid').HipHeight,Root.CFrame.lookVector.Z)
			elseif hitP == nil then
				Root.CFrame = hit.CFrame * CFrame.new(Root.CFrame.lookVector.X,hit.Size.Y/2 + speaker.Character:FindFirstChildOfClass('Humanoid').HipHeight,Root.CFrame.lookVector.Z)
			end
		end
	end
	walltpTouch = torso.Touched:Connect(touchedFunc)
end)

addcmd('unwalltp',{'nowalltp'},function(args, speaker)
	if walltpTouch then
		walltpTouch:Disconnect()
	end
end)

autoclicking = false
addcmd('autoclick',{},function(args, speaker)
	if mouse1press and mouse1release then
		execCmd('unautoclick')
		wait()
		local clickDelay = 0.1
		local releaseDelay = 0.1
		if args[1] and isNumber(args[1]) then clickDelay = args[1] end
		if args[2] and isNumber(args[2]) then releaseDelay = args[2] end
		autoclicking = true
		cancelAutoClick = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if (input.KeyCode == Enum.KeyCode.Backspace and UserInputService:IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and UserInputService:IsKeyDown(Enum.KeyCode.Backspace)) then
					autoclicking = false
					cancelAutoClick:Disconnect()
				end
			end
		end)
		notify('Auto Clicker',"Press [backspace] and [=] at the same time to stop")
		repeat wait(clickDelay)
			mouse1press()
			wait(releaseDelay)
			mouse1release()
		until autoclicking == false
	else
		notify('Auto Clicker',"Your exploit doesn't have the ability to use the autoclick")
	end
end)

addcmd('unautoclick',{'noautoclick'},function(args, speaker)
	autoclicking = false
	if cancelAutoClick then cancelAutoClick:Disconnect() end
end)

addcmd('mousesensitivity',{'ms'},function(args, speaker)
	UserInputService.MouseDeltaSensitivity = args[1]
end)

local nameBox = nil
local nbSelection = nil
addcmd('hovername',{},function(args, speaker)
	execCmd('unhovername')
	wait()
	nameBox = Instance.new("TextLabel")
	nameBox.Name = randomString()
	nameBox.Parent = ScaledHolder
	nameBox.BackgroundTransparency = 1
	nameBox.Size = UDim2.new(0,200,0,30)
	nameBox.Font = Enum.Font.Code
	nameBox.TextSize = 16
	nameBox.Text = ""
	nameBox.TextColor3 = Color3.new(1, 1, 1)
	nameBox.TextStrokeTransparency = 0
	nameBox.TextXAlignment = Enum.TextXAlignment.Left
	nameBox.ZIndex = 10
	nbSelection = Instance.new('SelectionBox')
	nbSelection.Name = randomString()
	nbSelection.LineThickness = 0.03
	nbSelection.Color3 = Color3.new(1, 1, 1)
	local function updateNameBox()
		local t
		local target = IYMouse.Target

		if target then
			local humanoid = target.Parent:FindFirstChildOfClass("Humanoid") or target.Parent.Parent:FindFirstChildOfClass("Humanoid")
			if humanoid then
				t = humanoid.Parent
			end
		end

		if t ~= nil then
			local x = IYMouse.X
			local y = IYMouse.Y
			local xP
			local yP
			if IYMouse.X > 200 then
				xP = x - 205
				nameBox.TextXAlignment = Enum.TextXAlignment.Right
			else
				xP = x + 25
				nameBox.TextXAlignment = Enum.TextXAlignment.Left
			end
			nameBox.Position = UDim2.new(0, xP, 0, y)
			nameBox.Text = t.Name
			nameBox.Visible = true
			nbSelection.Parent = t
			nbSelection.Adornee = t
		else
			nameBox.Visible = false
			nbSelection.Parent = nil
			nbSelection.Adornee = nil
		end
	end
	nbUpdateFunc = IYMouse.Move:Connect(updateNameBox)
end)

addcmd('unhovername',{'nohovername'},function(args, speaker)
	if nbUpdateFunc then
		nbUpdateFunc:Disconnect()
		nameBox:Destroy()
		nbSelection:Destroy()
	end
end)

addcmd('headsize',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		if Players[v] ~= speaker and Players[v].Character:FindFirstChild('Head') then
			local sizeArg = tonumber(args[2])
			local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
			local Head = Players[v].Character:FindFirstChild('Head')
			if Head:IsA("BasePart") then
				if not args[2] or sizeArg == 1 then
					Head.Size = Vector3.new(2,1,1)
				else
					Head.Size = Size
				end
			end
		end
	end
end)

addcmd('hitbox',{},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	local transparency = args[3] and tonumber(args[3]) or 0.4
	for i,v in pairs(players) do
		if Players[v] ~= speaker and Players[v].Character:FindFirstChild('HumanoidRootPart') then
			local sizeArg = tonumber(args[2])
			local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
			local Root = Players[v].Character:FindFirstChild('HumanoidRootPart')
			if Root:IsA("BasePart") then
				if not args[2] or sizeArg == 1 then
					Root.Size = Vector3.new(2,1,1)
					Root.Transparency = transparency
				else
					Root.Size = Size
					Root.Transparency = transparency
				end
			end
		end
	end
end)

addcmd('stareat',{'stare'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		if stareLoop then
			stareLoop:Disconnect()
		end
		if not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Players[v].Character:FindFirstChild("HumanoidRootPart") then return end
		local function stareFunc()
			if Players.LocalPlayer.Character.PrimaryPart and Players:FindFirstChild(v) and Players[v].Character ~= nil and Players[v].Character:FindFirstChild("HumanoidRootPart") then
				local chrPos=Players.LocalPlayer.Character.PrimaryPart.Position
				local tPos=Players[v].Character:FindFirstChild("HumanoidRootPart").Position
				local modTPos=Vector3.new(tPos.X,chrPos.Y,tPos.Z)
				local newCF=CFrame.new(chrPos,modTPos)
				Players.LocalPlayer.Character:SetPrimaryPartCFrame(newCF)
			elseif not Players:FindFirstChild(v) then
				stareLoop:Disconnect()
			end
		end

		stareLoop = RunService.RenderStepped:Connect(stareFunc)
	end
end)

addcmd('unstareat',{'unstare','nostare','nostareat'},function(args, speaker)
	if stareLoop then
		stareLoop:Disconnect()
	end
end)

RolewatchData = {Group = 0, Role = "", Leave = false}
RolewatchConnection = Players.PlayerAdded:Connect(function(player)
	if RolewatchData.Group == 0 then return end
	if player:IsInGroup(RolewatchData.Group) then
		if tostring(player:GetRoleInGroup(RolewatchData.Group)):lower() == RolewatchData.Role:lower() then
			if RolewatchData.Leave == true then
				Players.LocalPlayer:Kick("\n\nRolewatch\nPlayer \"" .. tostring(player.Name) .. "\" has joined with the Role \"" .. RolewatchData.Role .. "\"\n")
			else
				notify("Rolewatch", "Player \"" .. tostring(player.Name) .. "\" has joined with the Role \"" .. RolewatchData.Role .. "\"")
			end
		end
	end
end)

addcmd("rolewatch", {}, function(args, speaker)
    local groupId = tonumber(args[1] or 0)
    local roleName = args[2] and tostring(getstring(2))
    if groupId and roleName then
        RolewatchData.Group = groupId
        RolewatchData.Role = roleName
        notify("Rolewatch", "Watching Group ID \"" .. tostring(groupId) .. "\" for Role \"" .. roleName .. "\"")
    end
end)

addcmd("rolewatchstop", {}, function(args, speaker)
    RolewatchData.Group = 0
    RolewatchData.Role = ""
    RolewatchData.Leave = false
    notify("Rolewatch", "Disabled")
end)

addcmd("rolewatchleave", {"unrolewatch"}, function(args, speaker)
    RolewatchData.Leave = not RolewatchData.Leave
    notify("Rolewatch", RolewatchData.Leave and "Leave has been Enabled" or "Leave has been Disabled")
end)

staffRoles = {"mod", "admin", "staff", "dev", "founder", "owner", "supervis", "manager", "management", "executive", "president", "chairman", "chairwoman", "chairperson", "director"}

getStaffRole = function(player)
    local playerRole = player:GetRoleInGroup(game.CreatorId)
    local result = {Role = playerRole, Staff = false}
    if player:IsInGroup(1200769) then
        result.Role = "Roblox Employee"
        result.Staff = true
    end
    for _, role in pairs(staffRoles) do
        if string.find(string.lower(playerRole), role) then
            result.Staff = true
        end
    end
    return result
end

addcmd("staffwatch", {}, function(args, speaker)
    if staffwatchjoin then
        staffwatchjoin:Disconnect()
    end
    if game.CreatorType == Enum.CreatorType.Group then
        local found = {}
        staffwatchjoin = Players.PlayerAdded:Connect(function(player)
            local result = getStaffRole(player)
            if result.Staff then
                notify("Staffwatch", formatUsername(player) .. " is a " .. result.Role)
            end
        end)
        for _, player in pairs(Players:GetPlayers()) do
            local result = getStaffRole(player)
            if result.Staff then
                table.insert(found, formatUsername(player) .. " is a " .. result.Role)
            end
        end
        if #found > 0 then
            notify("Staffwatch", table.concat(found, ",\n"))
        else
            notify("Staffwatch", "Enabled")
        end
    else
        notify("Staffwatch", "Game is not owned by a Group")
    end
end)

addcmd("unstaffwatch", {}, function(args, speaker)
    if staffwatchjoin then
        staffwatchjoin:Disconnect()
    end
    notify("Staffwatch", "Disabled")
end)

addcmd('removeterrain',{'rterrain','noterrain'},function(args, speaker)
	workspace:FindFirstChildOfClass('Terrain'):Clear()
end)

addcmd('clearnilinstances',{'nonilinstances','cni'},function(args, speaker)
	if getnilinstances then
		for i,v in pairs(getnilinstances()) do
			v:Destroy()
		end
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing getnilinstances)')
	end
end)

addcmd('destroyheight',{'dh'},function(args, speaker)
	local dh = args[1] or -500
	if isNumber(dh) then
		workspace.FallenPartsDestroyHeight = dh
	end
end)

OrgDestroyHeight = workspace.FallenPartsDestroyHeight
addcmd("antivoid", {}, function(args, speaker)
    execCmd("unantivoid nonotify")
    task.wait()
    antivoidloop = RunService.Stepped:Connect(function()
        local root = getRoot(speaker.Character)
        if root and root.Position.Y <= OrgDestroyHeight + 25 then
            root.Velocity = root.Velocity + Vector3.new(0, 250, 0)
        end
    end)
    if args[1] ~= "nonotify" then notify("antivoid", "Enabled") end
end)

addcmd("unantivoid", {"noantivoid"}, function(args, speaker)
    pcall(function() antivoidloop:Disconnect() end)
    antivoidloop = nil
    if args[1] ~= "nonotify" then notify("antivoid", "Disabled") end
end)

antivoidWasEnabled = false
addcmd("fakeout", {}, function(args, speaker)
    local root = getRoot(speaker.Character)
    local oldpos = root.CFrame
    if antivoidloop then
        execCmd("unantivoid nonotify")
        antivoidWasEnabled = true
    end
    workspace.FallenPartsDestroyHeight = 0/1/0
    root.CFrame = CFrame.new(Vector3.new(0, OrgDestroyHeight - 25, 0))
    task.wait(1)
    root.CFrame = oldpos
    workspace.FallenPartsDestroyHeight = OrgDestroyHeight
    if antivoidWasEnabled then
        execCmd("antivoid nonotify")
        antivoidWasEnabled = false
    end
end)

addcmd("trip", {}, function(args, speaker)
    local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
    local root = speaker.Character and getRoot(speaker.Character)
    if humanoid and root then
        humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
        root.Velocity = root.CFrame.LookVector * 30
    end
end)

addcmd("removeads", {"adblock"}, function(args, speaker)
    while wait() do
        pcall(function()
            for i, v in pairs(workspace:GetDescendants()) do
                if v:IsA("PackageLink") then
                    if v.Parent:FindFirstChild("ADpart") then
                        v.Parent:Destroy()
                    end
                    if v.Parent:FindFirstChild("AdGuiAdornee") then
                        v.Parent.Parent:Destroy()
                    end
                end
            end
        end)
    end
end)

addcmd("scare", {"spook"}, function(args, speaker)
    local players = getPlayer(args[1], speaker)
    local oldpos = nil

    for _, v in pairs(players) do
        local root = speaker.Character and getRoot(speaker.Character)
        local target = Players[v]
        local targetRoot = target and target.Character and getRoot(target.Character)

        if root and targetRoot and target ~= speaker then
            oldpos = root.CFrame
            root.CFrame = targetRoot.CFrame + targetRoot.CFrame.lookVector * 2
            root.CFrame = CFrame.new(root.Position, targetRoot.Position)
            task.wait(0.5)
            root.CFrame = oldpos
        end
    end
end)

addcmd("alignmentkeys", {}, function(args, speaker)
    alignmentKeys = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Comma then workspace.CurrentCamera:PanUnits(-1) end
        if input.KeyCode == Enum.KeyCode.Period then workspace.CurrentCamera:PanUnits(1) end
    end)
    alignmentKeysEmotes = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
end)

addcmd("unalignmentkeys", {"noalignmentkeys"}, function(args, speaker)
    if type(alignmentKeysEmotes) == "boolean" then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, alignmentKeysEmotes)
    end
    alignmentKeys:Disconnect()
end)

addcmd("ctrllock", {}, function(args, speaker)
    local mouseLockController = speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
    local boundKeys = mouseLockController:FindFirstChild("BoundKeys")

    if boundKeys then
        boundKeys.Value = "LeftControl"
    else
        boundKeys = Instance.new("StringValue")
        boundKeys.Name = "BoundKeys"
        boundKeys.Value = "LeftControl"
        boundKeys.Parent = mouseLockController
    end
end)

addcmd("unctrllock", {}, function(args, speaker)
    local mouseLockController = speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
    local boundKeys = mouseLockController:FindFirstChild("BoundKeys")

    if boundKeys then
        boundKeys.Value = "LeftShift"
    else
        boundKeys = Instance.new("StringValue")
        boundKeys.Name = "BoundKeys"
        boundKeys.Value = "LeftShift"
        boundKeys.Parent = mouseLockController
    end
end)

addcmd("listento", {}, function(args, speaker)
    execCmd("unlistento")
    if not args[1] then return end

    local player = Players:FindFirstChild(getPlayer(args[1], speaker)[1])
    local root = player and player.Character and getRoot(player.Character)

    if root then
        SoundService:SetListener(Enum.ListenerType.ObjectPosition, root)
        listentoChar = player.CharacterAdded:Connect(function()
            repeat task.wait() until Players[player.Name].Character ~= nil and getRoot(Players[player.Name].Character)
            SoundService:SetListener(Enum.ListenerType.ObjectPosition, getRoot(Players[player.Name].Character))
        end)
    end
end)

addcmd("unlistento", {}, function(args, speaker)
    SoundService:SetListener(Enum.ListenerType.Camera)
    listentoChar:Disconnect()
end)

addcmd("jerk", {}, function(args, speaker)
    local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
    local backpack = speaker:FindFirstChildWhichIsA("Backpack")
    if not humanoid or not backpack then return end

    local tool = Instance.new("Tool")
    tool.Name = "Jerk Off"
    tool.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's justr say. My peanits."
    tool.RequiresHandle = false
    tool.Parent = backpack

    local jorkin = false
    local track = nil

    local function stopTomfoolery()
        jorkin = false
        if track then
            track:Stop()
            track = nil
        end
    end

    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stopTomfoolery)
    humanoid.Died:Connect(stopTomfoolery)

    while task.wait() do
        if not jorkin then continue end

        local isR15 = r15(speaker)
        if not track then
            local anim = Instance.new("Animation")
            anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
            track = humanoid:LoadAnimation(anim)
        end

        track:Play()
        track:AdjustSpeed(isR15 and 0.7 or 0.65)
        track.TimePosition = 0.6
        task.wait(0.1)
        while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do task.wait(0.1) end
        if track then
            track:Stop()
            track = nil
        end
    end
end)

addcmd("guiscale", {}, function(args, speaker)
    if args[1] and isNumber(args[1]) then
        local scale = tonumber(args[1])
        if scale % 1 == 0 then scale = scale / 100 end
        -- me when i divide and it explodes
        if scale == 0.01 then scale = 1 end
        if scale == 0.02 then scale = 2 end

        if scale >= 0.4 and scale <= 2 then
            guiScale = scale
        end
    else
        guiScale = defaultGuiScale
    end

    Scale.Scale = math.max(Holder.AbsoluteSize.X / 1920, guiScale)
    updatesaves()
end)

addcmd("unsuspendvc", {}, function(args, speaker)
    VoiceChatService:joinVoice()

    if typeof(onVoiceModerated) ~= "RBXScriptConnection" then
        onVoiceModerated = cloneref(game:GetService("VoiceChatInternal")).LocalPlayerModerated:Connect(function()
            task.wait(1)
            VoiceChatService:joinVoice()
        end)
    end
end)

addcmd("permadeath", {}, function(args, speaker)
    if replicatesignal then
        permadeath(speaker)
        notify("Permadeath", "Enabled")
    else
        notify("Incompatible Exploit", "Your exploit does not support this command (missing replicatesignal)")
    end
end)

local freezingua = nil
frozenParts = {}
addcmd('freezeunanchored',{'freezeua'},function(args, speaker)
    local badnames = {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "RightUpperArm",
        "LeftUpperArm",
        "RightLowerArm",
        "LeftLowerArm",
        "RightHand",
        "LeftHand",
        "RightUpperLeg",
        "LeftUpperLeg",
        "RightLowerLeg",
        "LeftLowerLeg",
        "RightFoot",
        "LeftFoot",
        "Torso",
        "Right Arm",
        "Left Arm",
        "Right Leg",
        "Left Leg",
        "HumanoidRootPart"
    }
    local function FREEZENOOB(v)
        if v:IsA("BasePart" or "UnionOperation") and v.Anchored == false then
            local BADD = false
            for i = 1,#badnames do
                if v.Name == badnames[i] then
                    BADD = true
                end
            end
            if speaker.Character and v:IsDescendantOf(speaker.Character) then
                BADD = true
            end
            if BADD == false then
                for i,c in pairs(v:GetChildren()) do
                    if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
                        c:Destroy()
                    end
                end
                local bodypos = Instance.new("BodyPosition")
                bodypos.Parent = v
                bodypos.Position = v.Position
                bodypos.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                local bodygyro = Instance.new("BodyGyro")
                bodygyro.Parent = v
                bodygyro.CFrame = v.CFrame
                bodygyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
                if not table.find(frozenParts,v) then
                    table.insert(frozenParts,v)
                end
            end
        end
    end
    for i,v in pairs(workspace:GetDescendants()) do
        FREEZENOOB(v)
    end
    freezingua = workspace.DescendantAdded:Connect(FREEZENOOB)
end)

addcmd('thawunanchored',{'thawua','unfreezeunanchored','unfreezeua'},function(args, speaker)
    if freezingua then
        freezingua:Disconnect()
    end
    for i,v in pairs(frozenParts) do
        for i,c in pairs(v:GetChildren()) do
            if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
                c:Destroy()
            end
        end
    end
    frozenParts = {}
end)

addcmd('tpunanchored',{'tpua'},function(args, speaker)
    local players = getPlayer(args[1], speaker)
    for i,v in pairs(players) do
        local Forces = {}
        for _,part in pairs(workspace:GetDescendants()) do
            if Players[v].Character:FindFirstChild('Head') and part:IsA("BasePart" or "UnionOperation" or "Model") and part.Anchored == false and not part:IsDescendantOf(speaker.Character) and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false then
                for i,c in pairs(part:GetChildren()) do
                    if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
                        c:Destroy()
                    end
                end
                local ForceInstance = Instance.new("BodyPosition")
                ForceInstance.Parent = part
                ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                table.insert(Forces, ForceInstance)
                if not table.find(frozenParts,part) then
                    table.insert(frozenParts,part)
                end
            end
        end
        for i,c in pairs(Forces) do
            c.Position = Players[v].Character.Head.Position
        end
    end
end)

keycodeMap = {
	["0"] = 0x30,
	["1"] = 0x31,
	["2"] = 0x32,
	["3"] = 0x33,
	["4"] = 0x34,
	["5"] = 0x35,
	["6"] = 0x36,
	["7"] = 0x37,
	["8"] = 0x38,
	["9"] = 0x39,
	["a"] = 0x41,
	["b"] = 0x42,
	["c"] = 0x43,
	["d"] = 0x44,
	["e"] = 0x45,
	["f"] = 0x46,
	["g"] = 0x47,
	["h"] = 0x48,
	["i"] = 0x49,
	["j"] = 0x4A,
	["k"] = 0x4B,
	["l"] = 0x4C,
	["m"] = 0x4D,
	["n"] = 0x4E,
	["o"] = 0x4F,
	["p"] = 0x50,
	["q"] = 0x51,
	["r"] = 0x52,
	["s"] = 0x53,
	["t"] = 0x54,
	["u"] = 0x55,
	["v"] = 0x56,
	["w"] = 0x57,
	["x"] = 0x58,
	["y"] = 0x59,
	["z"] = 0x5A,
	["enter"] = 0x0D,
	["shift"] = 0x10,
	["ctrl"] = 0x11,
	["alt"] = 0x12,
	["pause"] = 0x13,
	["capslock"] = 0x14,
	["spacebar"] = 0x20,
	["space"] = 0x20,
	["pageup"] = 0x21,
	["pagedown"] = 0x22,
	["end"] = 0x23,
	["home"] = 0x24,
	["left"] = 0x25,
	["up"] = 0x26,
	["right"] = 0x27,
	["down"] = 0x28,
	["insert"] = 0x2D,
	["delete"] = 0x2E,
	["f1"] = 0x70,
	["f2"] = 0x71,
	["f3"] = 0x72,
	["f4"] = 0x73,
	["f5"] = 0x74,
	["f6"] = 0x75,
	["f7"] = 0x76,
	["f8"] = 0x77,
	["f9"] = 0x78,
	["f10"] = 0x79,
	["f11"] = 0x7A,
	["f12"] = 0x7B,
}
autoKeyPressing = false
cancelAutoKeyPress = nil

addcmd('autokeypress',{'keypress'},function(args, speaker)
	if keypress and keyrelease and args[1] then
		local code = keycodeMap[args[1]:lower()]
		if not code then notify('Auto Key Press',"Invalid key") return end
		execCmd('unautokeypress')
		wait()
		local clickDelay = 0.1
		local releaseDelay = 0.1
		if args[2] and isNumber(args[2]) then clickDelay = args[2] end
		if args[3] and isNumber(args[3]) then releaseDelay = args[3] end
		autoKeyPressing = true
		cancelAutoKeyPress = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if (input.KeyCode == Enum.KeyCode.Backspace and UserInputService:IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and UserInputService:IsKeyDown(Enum.KeyCode.Backspace)) then
					autoKeyPressing = false
					cancelAutoKeyPress:Disconnect()
				end
			end
		end)
		notify('Auto Key Press',"Press [backspace] and [=] at the same time to stop")
		repeat wait(clickDelay)
			keypress(code)
			wait(releaseDelay)
			keyrelease(code)
		until autoKeyPressing == false
		if cancelAutoKeyPress then cancelAutoKeyPress:Disconnect() keyrelease(code) end
	else
		notify('Auto Key Press',"Your exploit doesn't have the ability to use auto key press")
	end
end)

addcmd('unautokeypress',{'noautokeypress','unkeypress','nokeypress'},function(args, speaker)
	autoKeyPressing = false
	if cancelAutoKeyPress then cancelAutoKeyPress:Disconnect() end
end)

addcmd('addplugin',{'plugin'},function(args, speaker)
	addPlugin(getstring(1))
end)

addcmd('removeplugin',{'deleteplugin'},function(args, speaker)
	deletePlugin(getstring(1))
end)

addcmd('reloadplugin',{},function(args, speaker)
	local pluginName = getstring(1)
	deletePlugin(pluginName)
	wait(1)
	addPlugin(pluginName)
end)

addcmd("addallplugins", {"loadallplugins"}, function(args, speaker)
    if not listfiles or not isfolder then
        notify("Incompatible Exploit", "Your exploit does not support this command (missing listfiles/isfolder)")
        return
    end

    for _, filePath in ipairs(listfiles("")) do
        local fileName = filePath:match("([^/\\]+%.iy)$")

        if fileName and
            fileName:lower() ~= "iy_fe.iy" and
            not isfolder(fileName) and
            not table.find(PluginsTable, fileName)
        then
            addPlugin(fileName)
        end
    end
end)

addcmd('removecmd',{'deletecmd'},function(args, speaker)
	removecmd(args[1])
end)

if IsOnMobile then
	local QuickCapture = Instance.new("TextButton")
	local UICorner = Instance.new("UICorner")
	QuickCapture.Name = randomString()
	QuickCapture.Parent = PARENT
	QuickCapture.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
	QuickCapture.BackgroundTransparency = 0.14
	QuickCapture.Position = UDim2.new(0.489, 0, 0, 0)
	QuickCapture.Size = UDim2.new(0, 32, 0, 33)
	QuickCapture.Font = Enum.Font.SourceSansBold
	QuickCapture.Text = "IY"
	QuickCapture.TextColor3 = Color3.fromRGB(255, 255, 255)
	QuickCapture.TextSize = 20
	QuickCapture.TextWrapped = true
	QuickCapture.ZIndex = 10
	QuickCapture.Draggable = true
	UICorner.Name = randomString()
	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = QuickCapture
	QuickCapture.MouseButton1Click:Connect(function()
		Cmdbar:CaptureFocus()
		maximizeHolder()
	end)
	table.insert(shade1, QuickCapture)
	table.insert(text1, QuickCapture)
end

pcall(function() Scale.Scale = math.max(Holder.AbsoluteSize.X / 1920, guiScale) end)
Scale.Parent = ScaledHolder
ScaledHolder.Size = UDim2.fromScale(1 / Scale.Scale, 1 / Scale.Scale)
Scale:GetPropertyChangedSignal("Scale"):Connect(function()
    ScaledHolder.Size = UDim2.fromScale(1 / Scale.Scale, 1 / Scale.Scale)
    for _, v in ScaledHolder:GetDescendants() do
        if v:IsA("GuiObject") and v.Visible then
            v.Visible = false
            v.Visible = true
        end
    end
end)

updateColors(currentShade1,shade1)
updateColors(currentShade2,shade2)
updateColors(currentShade3,shade3)
updateColors(currentText1,text1)
updateColors(currentText2,text2)
updateColors(currentScroll,scroll)

if PluginsTable ~= nil or PluginsTable ~= {} then
	FindPlugins(PluginsTable)
end

-- Events
eventEditor.RegisterEvent("OnExecute")
eventEditor.RegisterEvent("OnSpawn",{
	{Type="Player",Name="Player Filter ($1)"}
})
eventEditor.RegisterEvent("OnDied",{
	{Type="Player",Name="Player Filter ($1)"}
})
eventEditor.RegisterEvent("OnDamage",{
	{Type="Player",Name="Player Filter ($1)"},
	{Type="Number",Name="Below Health ($2)"}
})
eventEditor.RegisterEvent("OnKilled",{
	{Type="Player",Name="Victim Player ($1)"},
	{Type="Player",Name="Killer Player ($2)",Default = 1}
})
eventEditor.RegisterEvent("OnJoin",{
	{Type="Player",Name="Player Filter ($1)",Default = 1}
})
eventEditor.RegisterEvent("OnLeave",{
	{Type="Player",Name="Player Filter ($1)",Default = 1}
})
eventEditor.RegisterEvent("OnChatted",{
	{Type="Player",Name="Player Filter ($1)",Default = 1},
	{Type="String",Name="Message Filter ($2)"}
})

function hookCharEvents(plr,instant)
	task.spawn(function()
		local char = plr.Character
		if not char then return end

		local humanoid = char:WaitForChild("Humanoid",10)
		if not humanoid then return end

		local oldHealth = humanoid.Health
		humanoid.HealthChanged:Connect(function(health)
			local change = math.abs(oldHealth - health)
			if oldHealth > health then
				eventEditor.FireEvent("OnDamage",plr.Name,tonumber(health))
			end
			oldHealth = health
		end)

		humanoid.Died:Connect(function()
			eventEditor.FireEvent("OnDied",plr.Name)

			local killedBy = humanoid:FindFirstChild("creator")
			if killedBy and killedBy.Value and killedBy.Value.Parent then
				eventEditor.FireEvent("OnKilled",plr.Name,killedBy.Name)
			end
		end)
	end)
end

Players.PlayerAdded:Connect(function(plr)
	eventEditor.FireEvent("OnJoin",plr.Name)
	if isLegacyChat then plr.Chatted:Connect(function(msg) eventEditor.FireEvent("OnChatted",tostring(plr),msg) end) end
	plr.CharacterAdded:Connect(function() eventEditor.FireEvent("OnSpawn",tostring(plr)) hookCharEvents(plr) end)
	JoinLog(plr)
	if isLegacyChat then ChatLog(plr) end
	if ESPenabled then
		repeat wait(1) until plr.Character and getRoot(plr.Character)
		ESP(plr)
	end
	if CHMSenabled then
		repeat wait(1) until plr.Character and getRoot(plr.Character)
		CHMS(plr)
	end
end)

if not isLegacyChat then
    TextChatService.MessageReceived:Connect(function(message)
        if message.TextSource then
            local player = Players:GetPlayerByUserId(message.TextSource.UserId)
            if not player then return end

            if logsEnabled == true then
                CreateLabel(player.Name, message.Text)
            end
            if player.UserId == Players.LocalPlayer.UserId then
                do_exec(message.Text, Players.LocalPlayer)
            end
            eventEditor.FireEvent("OnChatted", player.Name, message.Text)
            sendChatWebhook(player, message.Text)
        end
    end)
end

for _,plr in pairs(Players:GetPlayers()) do
	pcall(function()
		plr.CharacterAdded:Connect(function() eventEditor.FireEvent("OnSpawn",tostring(plr)) hookCharEvents(plr) end)
		hookCharEvents(plr)
	end)
end

if spawnCmds and #spawnCmds > 0 then
	for i,v in pairs(spawnCmds) do
		eventEditor.AddCmd("OnSpawn",{v.COMMAND or "",{0},v.DELAY or 0})
	end
	updatesaves()
end

if loadedEventData then eventEditor.LoadData(loadedEventData) end
eventEditor.Refresh()

eventEditor.FireEvent("OnExecute")

if aliases and #aliases > 0 then
	local cmdMap = {}
	for i,v in pairs(cmds) do
		cmdMap[v.NAME:lower()] = v
		for _,alias in pairs(v.ALIAS) do
			cmdMap[alias:lower()] = v
		end
	end
	for i = 1, #aliases do
		local cmd = string.lower(aliases[i].CMD)
		local alias = string.lower(aliases[i].ALIAS)
		if cmdMap[cmd] then
			customAlias[alias] = cmdMap[cmd]
		end
	end
	refreshaliases()
end

IYMouse.Move:Connect(checkTT)

CaptureService.CaptureBegan:Connect(function()
    PARENT.Enabled = false
end)

CaptureService.CaptureEnded:Connect(function()
    task.delay(0.1, function()
        PARENT.Enabled = true
    end)
end)

task.spawn(function()
	local success, latestVersionInfo = pcall(function() 
		local versionJson = game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/version")
		return HttpService:JSONDecode(versionJson)
	end)

	if success then
		if currentVersion ~= latestVersionInfo.Version then
			notify("Outdated", "Get the new version at infyiff.github.io")
		end

		if latestVersionInfo.Announcement and latestVersionInfo.Announcement ~= "" then
			local AnnGUI = Instance.new("Frame")
			local background = Instance.new("Frame")
			local TextBox = Instance.new("TextLabel")
			local shadow = Instance.new("Frame")
			local PopupText = Instance.new("TextLabel")
			local Exit = Instance.new("TextButton")
			local ExitImage = Instance.new("ImageLabel")

			AnnGUI.Name = randomString()
			AnnGUI.Parent = ScaledHolder
			AnnGUI.Active = true
			AnnGUI.BackgroundTransparency = 1
			AnnGUI.Position = UDim2.new(0.5, -180, 0, -500)
			AnnGUI.Size = UDim2.new(0, 360, 0, 20)
			AnnGUI.ZIndex = 10

			background.Name = "background"
			background.Parent = AnnGUI
			background.Active = true
			background.BackgroundColor3 = currentShade1
			background.BorderSizePixel = 0
			background.Position = UDim2.new(0, 0, 0, 20)
			background.Size = UDim2.new(0, 360, 0, 150)
			background.ZIndex = 10

			TextBox.Parent = background
			TextBox.BackgroundTransparency = 1
			TextBox.Position = UDim2.new(0, 5, 0, 5)
			TextBox.Size = UDim2.new(0, 350, 0, 140)
			TextBox.Font = Enum.Font.SourceSans
			TextBox.TextSize = 18
			TextBox.TextWrapped = true
			TextBox.Text = latestVersionInfo.Announcement
			TextBox.TextColor3 = currentText1
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			TextBox.TextYAlignment = Enum.TextYAlignment.Top
			TextBox.ZIndex = 10

			shadow.Name = "shadow"
			shadow.Parent = AnnGUI
			shadow.BackgroundColor3 = currentShade2
			shadow.BorderSizePixel = 0
			shadow.Size = UDim2.new(0, 360, 0, 20)
			shadow.ZIndex = 10

			PopupText.Name = "PopupText"
			PopupText.Parent = shadow
			PopupText.BackgroundTransparency = 1
			PopupText.Size = UDim2.new(1, 0, 0.95, 0)
			PopupText.ZIndex = 10
			PopupText.Font = Enum.Font.SourceSans
			PopupText.TextSize = 14
			PopupText.Text = "Server Announcement"
			PopupText.TextColor3 = currentText1
			PopupText.TextWrapped = true

			Exit.Name = "Exit"
			Exit.Parent = shadow
			Exit.BackgroundTransparency = 1
			Exit.Position = UDim2.new(1, -20, 0, 0)
			Exit.Size = UDim2.new(0, 20, 0, 20)
			Exit.Text = ""
			Exit.ZIndex = 10

			ExitImage.Parent = Exit
			ExitImage.BackgroundColor3 = Color3.new(1, 1, 1)
			ExitImage.BackgroundTransparency = 1
			ExitImage.Position = UDim2.new(0, 5, 0, 5)
			ExitImage.Size = UDim2.new(0, 10, 0, 10)
			ExitImage.Image = getcustomasset("infiniteyield/assets/close.png")
			ExitImage.ZIndex = 10

			wait(1)
			AnnGUI:TweenPosition(UDim2.new(0.5, -180, 0, 150), "InOut", "Quart", 0.5, true, nil)

			Exit.MouseButton1Click:Connect(function()
				AnnGUI:TweenPosition(UDim2.new(0.5, -180, 0, -500), "InOut", "Quart", 0.5, true, nil)
				wait(0.6)
				AnnGUI:Destroy()
			end)
		end
	end
end)

task.spawn(function()
	wait()
	Credits:TweenPosition(UDim2.new(0, 0, 0.9, 0), "Out", "Quart", 0.2)
	Logo:TweenSizeAndPosition(UDim2.new(0, 175, 0, 175), UDim2.new(0, 37, 0, 45), "Out", "Quart", 0.3)
	wait(1)
	local OutInfo = TweenInfo.new(1.6809, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	TweenService:Create(Logo, OutInfo, {ImageTransparency = 1}):Play()
	TweenService:Create(IntroBackground, OutInfo, {BackgroundTransparency = 1}):Play()
	Credits:TweenPosition(UDim2.new(0, 0, 0.9, 30), "Out", "Quart", 0.2)
	wait(0.2)
	Logo:Destroy()
	Credits:Destroy()
	IntroBackground:Destroy()
	minimizeHolder()
	if IsOnMobile then notify("Unstable Device", "On mobile, Infinite Yield may have issues or features that are not functioning correctly.") end
end)
