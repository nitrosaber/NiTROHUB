-- 🌌 BGSI HUB - Deluxe Edition (BGS Infinite Version)
-- ✅ Fixed Permanent Hatch Animation Disable
-- ✅ Sirius Rayfield (https://sirius.menu/rayfield)

-- // Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- === Safe Wait ===
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

-- HatchEgg RemoteEvent (จาก BGS Infinite)
local HatchEggRemote = safeWait(ReplicatedStorage, "Client")
if HatchEggRemote then
    HatchEggRemote = safeWait(HatchEggRemote, "Effects")
    HatchEggRemote = HatchEggRemote and safeWait(HatchEggRemote, "HatchEgg")
end

if not (RemoteEvent and HatchEggRemote) then
    warn("❌ Missing required remotes. Some features may not work.")
end

-- === FLAGS & SETTINGS ===
local flags = {
    BlowBubble = false,
    UnlockRiftChest = false,
    AutoHatchEgg = false,
    DisableAnimation = true
}

local settings = {
    EggName = "Infinity Egg",
    HatchAmount = 6
}

local tasks, conns = {}, {}

-- === Smart Delay ===
local function smartDelay(base)
    local ping = Stats.Network.ServerStatsItem["Data Ping"] and Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
    return base + (ping / 1000)
end

-- === 🔪 Kill Hatch Animation (เฉพาะ HatchEgg) ===
local function KillHatchAnimation()
    if typeof(getconnections) ~= "function" then return end
    for _, c in ipairs(getconnections(HatchEggRemote.OnClientEvent)) do
        pcall(function()
            if c.Disable then c:Disable() else c:Disconnect() end
        end)
    end
    HatchEggRemote.OnClientEvent:Connect(function() end)
end

local function WatchHatchEvent()
    local effects = ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("Effects")
    if not effects then return end

    if conns.HatchWatch then conns.HatchWatch:Disconnect() end
    conns.HatchWatch = effects.DescendantAdded:Connect(function(obj)
        if obj.Name == "HatchEgg" and obj:IsA("RemoteEvent") then
            KillHatchAnimation()
        end
    end)
end

local function SetHatchAnimationDisabled(disabled)
    if disabled then
        KillHatchAnimation()
        WatchHatchEvent()
        if not tasks.__NoCutsceneWatch then
            tasks.__NoCutsceneWatch = task.spawn(function()
                while flags.DisableAnimation do
                    KillHatchAnimation()
                    task.wait(1)
                end
                tasks.__NoCutsceneWatch = nil
            end)
        end
    else
        if conns.HatchWatch then conns.HatchWatch:Disconnect(); conns.HatchWatch=nil end
    end
end

-- === Core Loops ===
local function BlowBubbleLoop()
    pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    task.wait(smartDelay(0.1))
end

local function UnlockRiftChestLoop()
    pcall(function()
        RemoteEvent:FireServer("UnlockRiftChest",
            "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
            "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
            "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest",false)
    end)
    task.wait(1)
end

local function AutoHatchEggLoop()
    pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    task.wait(smartDelay(0.1))
end

-- === Loop Manager ===
local function stopLoop(name)
    flags[name] = false
    if tasks[name] then task.cancel(tasks[name]); tasks[name] = nil end
end

local function startLoop(name, fn, delay)
    if tasks[name] then return end
    tasks[name] = task.spawn(function()
        while flags[name] do
            local ok, err = pcall(fn)
            if not ok then warn("[Loop Error: "..name.."]", err) end
            task.wait(delay or 0.3)
        end
        tasks[name] = nil
    end)
end

-- === UI Window ===
local Window = Rayfield:CreateWindow({
    Name = "🌌 BGSI HUB - Deluxe Edition",
    LoadingTitle = "Loading NiTroHub...",
    LoadingSubtitle = "BGS Infinite Edition",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "BGSI-Deluxe",
        Autosave = true,
        Autoload = true
    }
})

Rayfield:Notify({
    Title = "✅ BGSI HUB Ready",
    Content = "Permanent Hatch Animation Disabled!",
    Duration = 4
})

-- === Controls Tab ===
local Controls = Window:CreateTab("⚙️ Controls")

Controls:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = false,
    Callback = function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.5) else stopLoop("BlowBubble") end
    end
})

Controls:CreateToggle({
    Name = "Unlock AutoChest",
    CurrentValue = false,
    Callback = function(v)
        flags.UnlockRiftChest = v
        if v then startLoop("UnlockRiftChest", UnlockRiftChestLoop, 1) else stopLoop("UnlockRiftChest") end
    end
})

Controls:CreateToggle({
    Name = "Auto Hatch (Custom Egg)",
    CurrentValue = false,
    Callback = function(v)
        flags.AutoHatchEgg = v
        if v then
            if flags.DisableAnimation then
                SetHatchAnimationDisabled(true)
            end
            startLoop("AutoHatchEgg", AutoHatchEggLoop, 0.15)
        else
            stopLoop("AutoHatchEgg")
        end
    end
})

Controls:CreateToggle({
    Name = "Disable Hatch Animation (Permanent)",
    CurrentValue = flags.DisableAnimation,
    Callback = function(v)
        flags.DisableAnimation = v
        SetHatchAnimationDisabled(v)
        Rayfield:Notify({
            Title = v and "🎬 Disabled" or "🎬 Enabled",
            Content = v and "Cutscene fully blocked." or "You may need to rejoin.",
            Duration = 3
        })
    end
})

Controls:CreateInput({
    Name = "Egg Name",
    PlaceholderText = "Infinity Egg",
    RemoveTextAfterFocusLost = false,
    Callback = function(t)
        settings.EggName = t
    end
})

Controls:CreateInput({
    Name = "Hatch Amount (1/3/6/8/9/10/11/12)",
    PlaceholderText = "6",
    RemoveTextAfterFocusLost = false,
    Callback = function(t)
        local n = tonumber(t)
        if n and (n==1 or n==3 or n==6 or n==8 or n==9 or n==10 or n==11 or n==12) then
            settings.HatchAmount = n
        else
            warn("⚠️ Invalid hatch amount.")
        end
    end
})

-- === Safety Tab ===
local Safety = Window:CreateTab("🛡️ Safety")

Safety:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(v)
        if conns.AFK then conns.AFK:Disconnect(); conns.AFK=nil end
        if v then
            conns.AFK = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
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
    end
})

Safety:CreateButton({
    Name = "🕵️ Anti-Admin Detector",
    Callback = function()
        local keywords = {"admin","mod","dev","staff"}
        Players.PlayerAdded:Connect(function(p)
            for _, word in ipairs(keywords) do
                if string.find(p.Name:lower(), word) then
                    for k in pairs(flags) do stopLoop(k) end
                    Rayfield:Destroy()
                    LocalPlayer:Kick("⚠️ Admin detected. Script terminated.")
                end
            end
        end)
    end
})

Safety:CreateButton({
    Name = "🔴 Panic (Stop Everything)",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        Rayfield:Destroy()
    end
})

-- === Settings Tab ===
local Settings = Window:CreateTab("⚙️ Settings")

Settings:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        Rayfield:Destroy()
    end
})