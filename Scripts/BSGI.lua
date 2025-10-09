-- // Load Rayfield (Sirius Edition)
local RayfieldLib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- === THEMES ===
local THEMES = {
    ["Dark"] = {Main = Color3.fromRGB(25, 25, 25), Accent = Color3.fromRGB(255, 100, 100)},
    ["Light"] = {Main = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 120, 255)},
    ["Neon"] = {Main = Color3.fromRGB(20, 20, 35), Accent = Color3.fromRGB(120, 0, 255)},
    ["Aqua"] = {Main = Color3.fromRGB(25, 45, 55), Accent = Color3.fromRGB(0, 200, 255)},
    ["Sunset"] = {Main = Color3.fromRGB(55, 30, 40), Accent = Color3.fromRGB(255, 120, 80)},
    ["Aurora"] = {Main = Color3.fromRGB(30, 50, 60), Accent = Color3.fromRGB(0, 255, 180)},
}

local currentTheme = "Dark"

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
    warn("❌ Missing Remote objects.")
    return
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

-- === TASKS ===
local tasks = {}

local function startLoop(flagName, loopFunc, delay)
    if tasks[flagName] then return end
    tasks[flagName] = task.spawn(function()
        while flags[flagName] do
            local ok, err = pcall(loopFunc)
            if not ok then warn("[Loop Error - " .. flagName .. "]", err) end
            task.wait(delay or 0.3)
        end
        tasks[flagName] = nil
    end)
end

local function stopLoop(flagName)
    flags[flagName] = false
    if tasks[flagName] then
        task.cancel(tasks[flagName])
        tasks[flagName] = nil
    end
end

-- === LOOPS ===
local function BlowBubbleLoop()
    pcall(function()
        RemoteEvent:FireServer("BlowBubble")
    end)
    task.wait(0.6)
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
    if flags.DisableAnimation then
        pcall(function()
            hatcheggRemote:FireServer(false, false)
        end)
    end
    pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    task.wait(0.15)
end

-- === WINDOW ===
local Window = RayfieldLib:CreateWindow({
    Name = "🌌 BGSI FARM - Cosmetic Pro Edition",
    LoadingTitle = "Loading NiTroHub...",
    LoadingSubtitle = "✨ Sirius Rayfield | Aesthetic Mode",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "Script-BGSI-CosmeticPro",
        Autosave = true,
        Autoload = true,
    }
})

-- === STARTUP NOTIFY ===
RayfieldLib:Notify({
    Title = "🌈 Welcome to BGSI FARM Pro",
    Content = "Cosmetic Edition Loaded Successfully!",
    Duration = 5
})

-- === CONTROLS TAB ===
local Controls = Window:CreateTab("Controls")

Controls:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = flags.BlowBubble,
    Callback = function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.6)
        else stopLoop("BlowBubble") end
    end
})

Controls:CreateToggle({
    Name = "Unlock AutoChest",
    CurrentValue = flags.UnlockRiftChest,
    Callback = function(v)
        flags.UnlockRiftChest = v
        if v then startLoop("UnlockRiftChest", UnlockRiftChestLoop, 1)
        else stopLoop("UnlockRiftChest") end
    end
})

Controls:CreateToggle({
    Name = "Auto Hatch (Custom Egg)",
    CurrentValue = flags.AutoHatchEgg,
    Callback = function(v)
        flags.AutoHatchEgg = v
        if v then
            if flags.DisableAnimation then
                pcall(function() hatcheggRemote:FireServer(false, false) end)
            end
            startLoop("AutoHatchEgg", AutoHatchEggLoop, 0.15)
        else
            stopLoop("AutoHatchEgg")
        end
    end
})

Controls:CreateToggle({
    Name = "Disable Hatch Animation",
    CurrentValue = flags.DisableAnimation,
    Callback = function(v)
        flags.DisableAnimation = v
        if v then
            pcall(function() hatcheggRemote:FireServer(false, false) end)
            print("[BGSI] Hatch animation disabled")
        else
            pcall(function() hatcheggRemote:FireServer(true, true) end)
            print("[BGSI] Hatch animation enabled")
        end
    end
})

Controls:CreateInput({
    Name = "Egg Name",
    PlaceholderText = "Infinity Egg",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text ~= "" then
            settings.EggName = text
            print("[BGSI] Egg set to:", text)
        end
    end
})

Controls:CreateInput({
    Name = "Hatch Amount (1 / 3 / 6 / 8 / 9)",
    PlaceholderText = "Enter number",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and (num == 1 or num == 3 or num == 6 or num == 8 or num == 9) then
            settings.HatchAmount = num
        else
            warn("⚠️ Invalid hatch amount.")
        end
    end
})

-- === COSMETIC TAB ===
local Cosmetic = Window:CreateTab("🎨 Cosmetic")

Cosmetic:CreateDropdown({
    Name = "Theme Style",
    Options = {"Dark", "Light", "Neon", "Aqua", "Sunset", "Aurora"},
    CurrentOption = "Dark",
    Callback = function(opt)
        currentTheme = opt
        local theme = THEMES[opt]
        RayfieldLib:SetTheme(theme.Main, theme.Accent)
        RayfieldLib:Notify({
            Title = "🎨 Theme Changed",
            Content = "Now using " .. opt .. " theme!",
            Duration = 4
        })
    end
})

Cosmetic:CreateButton({
    Name = "✨ Random Theme",
    Callback = function()
        local keys = {}
        for k in pairs(THEMES) do table.insert(keys, k) end
        local pick = keys[math.random(1, #keys)]
        local theme = THEMES[pick]
        RayfieldLib:SetTheme(theme.Main, theme.Accent)
        RayfieldLib:Notify({
            Title = "🌈 Random Theme",
            Content = "Applied theme: " .. pick,
            Duration = 4
        })
    end
})

-- === BACKGROUND GRADIENT ANIMATION ===
task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.005) % 1
        local color = Color3.fromHSV(hue, 0.8, 1)
        RayfieldLib:SetTheme(Color3.fromHSV(hue, 0.3, 0.15), color)
        task.wait(0.05)
    end
end)

-- === SETTINGS TAB ===
local Settings = Window:CreateTab("Settings")

Settings:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        RayfieldLib:Destroy()
    end
})
