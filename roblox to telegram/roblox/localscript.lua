local rep = game:GetService("ReplicatedStorage")
local events = rep.Events
local player = game.Players.LocalPlayer

local getcode = script.Parent:WaitForChild('GetCode')
local verify = script.Parent:WaitForChild('Verify')

local clickDb = true
local clickDb1 = true

-- lmfao
local dbWait = (not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not not game:GetService("RunService"):IsStudio() and 4) or 30

getcode.MouseButton1Click:Connect(function()
	if not clickDb then return end
	clickDb = false

	script.Parent.Code.Text = "Код: ⏳"

	if player:GetAttribute("Verified") then
		print(`can't generate code for player: {player.Name}; timeout: {player:GetAttribute("Timeout")}; verified: {player:GetAttribute("Verified")}`)
		script.Parent.Code.Text = "player is already verified"
		task.wait(dbWait)
		clickDb = true
		return
	end

	if player:GetAttribute("CacheVerified") then
		task.wait(dbWait)
		clickDb = true
		return
	end

	if player:GetAttribute("Timeout") then
		print(`can't generate code for player: {player.Name}; timeout: {player:GetAttribute("Timeout")}; verified: {player:GetAttribute("Verified")}`)
		script.Parent.Code.Text = "player is timed out"
		task.wait(dbWait)
		clickDb = true
		return
	end

	events.Authenticate:FireServer(script.Parent.Code)

	task.wait(dbWait)
	clickDb = true
end)

verify.MouseButton1Click:Connect(function()
	if not clickDb1 then return end
	clickDb1 = false

	script.Parent.Status.Text = "status: ⏳"

	if player:GetAttribute("Timeout") == true then
		print(`player {player.Name} is on timeout`)
		script.Parent.Status.Text = "status: ❌❌❌"
		task.wait(dbWait)
		clickDb1 = true
		return
	end

	if player:GetAttribute("Verified") == true then
		print(`player {player.Name} is already verified`)
		script.Parent.Status.Text = "Статус: ✅"
		task.wait(dbWait)
		clickDb1 = true
		return
	end

	events.Verified:FireServer(script.Parent.Status)

	task.wait(dbWait)
	clickDb1 = true
end)
