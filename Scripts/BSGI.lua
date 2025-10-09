-- 🌌 BGSI HUB - Deluxe Edition (BGS Infinite / Final Fixed)
-- ✅ Permanent Hatch Animation Disable (Fixed for ModuleScript)
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

if not RemoteEvent then
    warn("❌ Missing RemoteEvent; core features may not work.")
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

-- === 🔪 Disable Hatch Animation (BGS Infinite Specific) ===
local function DisableHatchAnimation()
    local client = ReplicatedStorage:FindFirstChild("Client")
    if not client then return end

    local effects = client:FindFirstChild("Effects")
    if not effects then return end

    local hatchModule = effects:FindFirstChild("HatchEgg")
    if not hatchModule then
        warn("[BGSI] HatchEgg not found in Effects.")
        return
    end

    if hatchModule:IsA("ModuleScript") or hatchModule:IsA("LocalScript") then
        pcall(function()
            hatchModule.Name = "HatchEgg_Disabled"
        end)
        print("[BGSI] Hatch animation module disabled successfully.")
    elseif hatchModule:IsA("RemoteEvent") then
        if typeof(getconnections) == "function" then
            for _, c in ipairs(getconnections(hatchModule.OnClientEvent)) do
                pcall(function()
                    if c.Disable then c:Disable() else c:Disconnect() end
                end)
            end
        end
        hatchModule.OnClientEvent:Connect(function() end)
        print("[BGSI] Hatch animation remote blocked.")
    end
end

-- === Core Loops ===
local function BlowBubbleLoop()
    pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    task.wait(0.2)
end

-- 🏆 Auto Claim Chest System
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

-- 🥚 Auto Hatch Egg Loop
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
    Content = "Hatch Animation Disabled | Auto Systems Ready",
    Duration = 4
})

-- === Controls Tab ===
local Controls = Window:CreateTab("⚙️ Controls")

Controls:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = false,
    Callback = function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.5)
        else stopLoop("BlowBubble") end
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
                DisableHatchAnimation()
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
        if v then
            DisableHatchAnimation()
            Rayfield:Notify({
                Title = "🎬 Hatch Animation Disabled",
                Content = "HatchEgg script/module renamed & blocked.",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "⚙️ Animation Restored",
                Content = "Rejoin the game to reload animations.",
                Duration = 3
            })
        end
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