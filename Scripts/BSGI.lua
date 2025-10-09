-- 🌌 BGSI HUB Deluxe Edition
-- 🔧 Sirius Rayfield Stable | Last Updated: 2025
-- ⚙️ All-in-One Automation, Cosmetic & Safety System

-- // Load Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Safe Wait
local function safeWait(parent, childName, timeout)
	local obj = parent:WaitForChild(childName, timeout or 10)
	if not obj then warn("Missing:", childName) end
	return obj
end

-- === REMOTES ===
local RemoteEvent = safeWait(ReplicatedStorage, "Shared")
if RemoteEvent then
	RemoteEvent = safeWait(RemoteEvent, "Framework")
	RemoteEvent = RemoteEvent and safeWait(RemoteEvent, "Network")
	RemoteEvent = RemoteEvent and safeWait(RemoteEvent, "Remote")
	RemoteEvent = RemoteEvent and safeWait(RemoteEvent, "RemoteEvent")
end

local hatcheggRemote = safeWait(ReplicatedStorage, "Client")
if hatcheggRemote then
	hatcheggRemote = safeWait(hatcheggRemote, "Effects")
	hatcheggRemote = hatcheggRemote and safeWait(hatcheggRemote, "HatchEgg")
end

if not (RemoteEvent and hatcheggRemote) then
	warn("❌ Missing Remote objects. Some features may not work.")
end

-- === FLAGS & SETTINGS ===
local flags = {
	BlowBubble = false,
	UnlockRiftChest = false,
	AutoHatchEgg = false,
	DisableAnimation = true,
	AutoCollect = false,
}

local settings = {
	EggName = "Infinity Egg",
	HatchAmount = 6
}

local tasks = {}
local function stopLoop(name)
	flags[name] = false
	if tasks[name] then
		task.cancel(tasks[name])
		tasks[name] = nil
	end
end

local function startLoop(name, func, delay)
	if tasks[name] then return end
	tasks[name] = task.spawn(function()
		while flags[name] do
			local ok, err = pcall(func)
			if not ok then warn("[Loop Error: "..name.."]", err) end
			task.wait(delay or 0.3)
		end
		tasks[name] = nil
	end)
end

-- === SMART WAIT ===
local function smartDelay(base)
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	return base + (ping / 1000)
end

-- === CORE LOOPS ===
local function BlowBubbleLoop()
	pcall(function()
		RemoteEvent:FireServer("BlowBubble")
	end)
	task.wait(smartDelay(0.5))
end

local function UnlockRiftChestLoop()
	pcall(function()
		RemoteEvent:FireServer("UnlockRiftChest",
			"Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
			"Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
			"Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest", false
		)
	end)
	task.wait(1)
end

local function AutoHatchEggLoop()
	pcall(function()
		RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
	end)
	task.wait(smartDelay(0.15))
end

local function AutoCollectLoop()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Part") and obj.Name:lower():find("gem") then
			firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
			firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
		end
	end
	task.wait(1)
end

-- === WINDOW ===
local Window = Rayfield:CreateWindow({
	Name = "🌌 BGSI HUB - Deluxe Edition",
	LoadingTitle = "Initializing NiTroHub Deluxe...",
	LoadingSubtitle = "⚙️ Sirius Rayfield Stable Build",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "NiTroHub",
		FileName = "BGSI-Deluxe",
		Autosave = true,
		Autoload = true
	}
})

-- === NOTIFY ===
Rayfield:Notify({
	Title = "✅ BGSI HUB Loaded",
	Content = "Welcome to Deluxe Edition",
	Duration = 5
})

-- === CONTROLS TAB ===
local Controls = Window:CreateTab("⚙️ Controls")

Controls:CreateToggle({
	Name = "Blow Bubble",
	CurrentValue = false,
	Callback = function(v)
		flags.BlowBubble = v
		if v then startLoop("BlowBubble", BlowBubbleLoop)
		else stopLoop("BlowBubble") end
	end
})

Controls:CreateToggle({
	Name = "Unlock AutoChest",
	CurrentValue = false,
	Callback = function(v)
		flags.UnlockRiftChest = v
		if v then startLoop("UnlockRiftChest", UnlockRiftChestLoop)
		else stopLoop("UnlockRiftChest") end
	end
})

Controls:CreateToggle({
	Name = "Auto Hatch (Custom Egg)",
	CurrentValue = false,
	Callback = function(v)
		flags.AutoHatchEgg = v
		if v then
			if flags.DisableAnimation then
				pcall(function() hatcheggRemote:FireServer(false, false) end)
			end
			startLoop("AutoHatchEgg", AutoHatchEggLoop)
		else
			stopLoop("AutoHatchEgg")
		end
	end
})

Controls:CreateToggle({
	Name = "Disable Hatch Animation",
	CurrentValue = true,
	Callback = function(v)
		flags.DisableAnimation = v
		if v then
			pcall(function() hatcheggRemote:FireServer(false, false) end)
			Rayfield:Notify({Title = "🎬 Animation Disabled", Content = "Cutscene fully disabled.", Duration = 4})
		else
			pcall(function() hatcheggRemote:FireServer(true, true) end)
			Rayfield:Notify({Title = "🎬 Animation Enabled", Content = "Cutscene enabled again.", Duration = 4})
		end
	end
})

Controls:CreateToggle({
	Name = "Auto Collect (Gems/Coins)",
	CurrentValue = false,
	Callback = function(v)
		flags.AutoCollect = v
		if v then startLoop("AutoCollect", AutoCollectLoop)
		else stopLoop("AutoCollect") end
	end
})

Controls:CreateInput({
	Name = "Egg Name",
	PlaceholderText = "Infinity Egg",
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		settings.EggName = text
	end
})

Controls:CreateInput({
	Name = "Hatch Amount (1/3/6/8/9)",
	PlaceholderText = "6",
	RemoveTextAfterFocusLost = false,
	Callback = function(t)
		local n = tonumber(t)
		if n then settings.HatchAmount = n end
	end
})

-- === COSMETIC TAB ===
local Cosmetic = Window:CreateTab("🎨 Cosmetic")

Cosmetic:CreateButton({
	Name = "🌈 Enable Gradient Accent",
	Callback = function()
		task.spawn(function()
			local hue = 0
			while true do
				hue = (hue + 0.003) % 1
				Rayfield:SetUIColor(Color3.fromHSV(hue, 0.8, 1))
				task.wait(0.05)
			end
		end)
		Rayfield:Notify({Title = "🌈 Gradient Accent", Content = "Activated animated color accent!", Duration = 4})
	end
})

Cosmetic:CreateButton({
	Name = "🎵 Play Click Sound",
	Callback = function()
		local sound = Instance.new("Sound", workspace)
		sound.SoundId = "rbxassetid://9118823106"
		sound.Volume = 1
		sound:Play()
		game.Debris:AddItem(sound, 3)
	end
})

-- === SAFETY TAB ===
local Safety = Window:CreateTab("🛡️ Safety")

Safety:CreateToggle({
	Name = "Anti-AFK",
	CurrentValue = true,
	Callback = function(v)
		if v then
			LocalPlayer.Idled:Connect(function()
				VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait(1)
				VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end)
		end
	end
})

Safety:CreateButton({
	Name = "🔴 Panic (Stop Everything)",
	Callback = function()
		for k in pairs(flags) do stopLoop(k) end
		Rayfield:Destroy()
		warn("[BGSI HUB] Panic mode activated. UI closed.")
	end
})

Safety:CreateButton({
	Name = "🕵️ Anti-Admin Detector",
	Callback = function()
		local keywords = {"admin", "mod", "dev", "staff"}
		Players.PlayerAdded:Connect(function(p)
			for _, word in ipairs(keywords) do
				if string.find(p.Name:lower(), word) then
					for k in pairs(flags) do stopLoop(k) end
					Rayfield:Destroy()
					LocalPlayer:Kick("⚠️ Admin detected. Script terminated.")
				end
			end
		end)
		Rayfield:Notify({Title = "🛡️ Anti-Admin", Content = "Monitoring new joins for staff.", Duration = 4})
	end
})

Safety:CreateButton({
	Name = "♻️ Auto Reconnect",
	Callback = function()
		LocalPlayer.OnTeleport:Connect(function(state)
			if state == Enum.TeleportState.Failed then
				task.wait(3)
				TeleportService:Teleport(game.PlaceId)
			end
		end)
		Rayfield:Notify({Title = "🌐 Auto Reconnect", Content = "Enabled auto reconnect.", Duration = 4})
	end
})

-- === SETTINGS TAB ===
local Settings = Window:CreateTab("⚙️ Settings")
Settings:CreateButton({
	Name = "Destroy UI",
	Callback = function()
		for k in pairs(flags) do stopLoop(k) end
		Rayfield:Destroy()
	end
})
