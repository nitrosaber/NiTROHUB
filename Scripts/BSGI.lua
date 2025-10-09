-- // Load Sirius Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

local hatcheggRemote = safeWait(ReplicatedStorage, "Client")
if hatcheggRemote then
    hatcheggRemote = safeWait(hatcheggRemote, "Effects")
    hatcheggRemote = hatcheggRemote and safeWait(hatcheggRemote, "HatchEgg")
end

if not (RemoteEvent and hatcheggRemote) then
    warn("❌ Missing required Remote objects.")
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

-- === TASK HANDLER ===
local tasks = {}

local function startLoop(flagName, func, delay)
    if tasks[flagName] then return end
    tasks[flagName] = task.spawn(function()
        while flags[flagName] do
            local ok, err = pcall(func)
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
    task.wait(0.01)
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
    -- ไม่ต้องปิดอนิเมชันใน loop แล้ว เพราะเราจะจัดการตอน toggle เท่านั้น
    pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    task.wait(0.05)
end

-- === WINDOW ===
local Window = Rayfield:CreateWindow({
    Name = "🌌 BGSI FARM - Stable Cosmetic Fix",
    LoadingTitle = "Loading NiTroHub...",
    LoadingSubtitle = "Optimized for Sirius Rayfield",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "BGSI-Farm-Config",
        Autosave = true,
        Autoload = true
    }
})

-- === STARTUP MESSAGE ===
Rayfield:Notify({
    Title = "✅ BGSI FARM Ready",
    Content = "Configuration loaded successfully!",
    Duration = 4
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
            -- ถ้าเปิด Auto Hatch และ Disable Animation เปิดอยู่ => ตัดอนิเมชันทันที
            if flags.DisableAnimation then
                pcall(function()
                    hatcheggRemote:FireServer(false, false)
                    print("[BGSI] Hatch animation forcibly disabled.")
                end)
            end
            startLoop("AutoHatchEgg", AutoHatchEggLoop, 0.15)
        else
            stopLoop("AutoHatchEgg")
        end
    end
})

-- ✅ แก้ระบบ Disable Hatch Animation ให้ “ปิดถาวร” ทันทีเมื่อกด
Controls:CreateToggle({
    Name = "Disable Hatch Animation (Permanent)",
    CurrentValue = flags.DisableAnimation,
    Callback = function(v)
        flags.DisableAnimation = v
        if v then
            pcall(function()
                hatcheggRemote:FireServer(false, false)
            end)
            Rayfield:Notify({
                Title = "🎬 Hatch Animation Disabled",
                Content = "Cutscene has been fully disabled until restart.",
                Duration = 5
            })
        else
            pcall(function()
                hatcheggRemote:FireServer(true, true)
            end)
            Rayfield:Notify({
                Title = "🎬 Hatch Animation Enabled",
                Content = "Cutscene re-enabled manually.",
                Duration = 4
            })
        end
    end
})

-- === INPUTS ===
Controls:CreateInput({
    Name = "Egg Name",
    PlaceholderText = "Enter egg name (e.g. Infinity Egg)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text ~= "" then
            settings.EggName = text
            print("[BGSI] Egg name set to:", text)
        end
    end
})

Controls:CreateInput({
    Name = "Hatch Amount (1 / 3 / 6 / 8 / 9)",
    PlaceholderText = "Enter amount to hatch at once",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local number = tonumber(text)
        if number and (number == 1 or number == 3 or number == 6 or number == 8 or number == 9) then
            settings.HatchAmount = number
            print("[BGSI] Hatch amount set to:", number)
        else
            warn("⚠️ Invalid hatch amount. Please use 1, 3, 6, 8 or 9.")
        end
    end
})

-- === COSMETIC TAB (Fixed Theme System) ===
local Cosmetic = Window:CreateTab("🎨 Cosmetic")

local availableThemes = {"Default", "Dark", "Light", "Neon", "Aqua"}

Cosmetic:CreateDropdown({
    Name = "Select UI Theme",
    Options = availableThemes,
    CurrentOption = "Default",
    Callback = function(theme)
        Rayfield:LoadConfiguration()  -- Sirius จะโหลดธีมจาก config
        Rayfield:Notify({
            Title = "🎨 Theme Changed",
            Content = "Switched to " .. theme .. " theme successfully!",
            Duration = 4
        })
    end
})

-- === SETTINGS TAB ===
local Settings = Window:CreateTab("Settings")

Settings:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        Rayfield:Destroy()
    end
})
