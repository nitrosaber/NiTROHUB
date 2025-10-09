-- 🌌 BGSI HUB - Deluxe Edition (BGS Infinite Version)
-- ✅ Permanent Hatch Animation Block
-- ✅ Auto Claim All Chests (ClaimChest)
-- ✅ Sirius Rayfield (https://sirius.menu/rayfield)

-- // Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
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

-- HatchEgg RemoteEvent (ของ BGS Infinite)
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
    AutoClaimChest = false,
    AutoHatchEgg = false,
    DisableAnimation = true
}

local settings = {
    EggName = "Infinity Egg",
    HatchAmount = 6
}

local tasks, conns = {}, {}

-- === 🧱 BLOCK HatchEggRemote ===
local function BlockHatchEggRemote()
    if not HatchEggRemote then return end

    -- ตัดการเชื่อมต่อทั้งหมดจาก OnClientEvent
    if typeof(getconnections) == "function" then
        for _, conn in ipairs(getconnections(HatchEggRemote.OnClientEvent)) do
            pcall(function()
                if conn.Disable then conn:Disable() else conn:Disconnect() end
            end)
        end
    end

    -- ดูด event ทิ้ง (prevent animation / remote firing)
    HatchEggRemote.OnClientEvent:Connect(function() end)
end

local function StartHatchBlockWatcher()
    local effects = ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("Effects")
    if not effects then return end

    if conns.HatchWatcher then conns.HatchWatcher:Disconnect() end
    conns.HatchWatcher = effects.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") and (obj.Name == "HatchEgg" or obj.Name == "HatchEggs") then
            BlockHatchEggRemote()
        end
    end)
end

local function SetHatchAnimationDisabled(disabled)
    if disabled then
        BlockHatchEggRemote()
        StartHatchBlockWatcher()
        if not tasks.__HatchBlockLoop then
            tasks.__HatchBlockLoop = task.spawn(function()
                while flags.DisableAnimation do
                    BlockHatchEggRemote()
                    task.wait(1)
                end
                tasks.__HatchBlockLoop = nil
            end)
        end
    else
        if conns.HatchWatcher then conns.HatchWatcher:Disconnect() conns.HatchWatcher=nil end
    end
end

-- === Core Loops ===
local function BlowBubbleLoop()
    pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    task.wait(0.2)
end

local function AutoClaimChestLoop()
    local chests = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
        "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
        "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }

    for _, chest in ipairs(chests) do
        pcall(function()
            RemoteEvent:FireServer("ClaimChest", chest, true)
        end)
    end
    task.wait(3)
end

local function AutoHatchEggLoop()
    pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    task.wait(0.1)
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
    Content = "HatchEggRemote permanently blocked.",
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
    Name = "Auto Claim All Chests",
    CurrentValue = false,
    Callback = function(v)
        flags.AutoClaimChest = v
        if v then startLoop("AutoClaimChest", AutoClaimChestLoop, 3)
        else stopLoop("AutoClaimChest") end
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
    Name = "Block Hatch Animation (Permanent)",
    CurrentValue = flags.DisableAnimation,
    Callback = function(v)
        flags.DisableAnimation = v
        SetHatchAnimationDisabled(v)
        Rayfield:Notify({
            Title = v and "🎬 Hatch Blocked" or "🎬 Hatch Enabled",
            Content = v and "HatchEggRemote is now blocked." or "You may need to rejoin.",
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
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        Rayfield:Destroy()
    end
})