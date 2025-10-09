-- // Load Rayfield (Sirius Edition)
local RayfieldLib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Safe Wait Function
local function safeWait(parent, childName, timeout)
    local obj = parent:WaitForChild(childName, timeout or 10)
    if not obj then
        warn("Missing object:", childName)
    end
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

-- === TASKS ===
local tasks = {}

local function startLoop(flagName, loopFunc, delay)
    if tasks[flagName] then return end
    tasks[flagName] = task.spawn(function()
        while flags[flagName] do
            local ok, err = pcall(loopFunc)
            if not ok then
                warn("[Loop Error - " .. flagName .. "]", err)
            end
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

-- ✅ Auto Hatch Egg + ผูก Disable Animation ให้ทำงานร่วมกัน
local function AutoHatchEggLoop()
    -- ถ้าปิดอนิเมชันไว้ จะส่งสัญญาณให้หยุด cutscene ทุกครั้ง
    if flags.DisableAnimation then
        pcall(function()
            hatcheggRemote:FireServer(false, false)
        end)
    end

    -- สุ่มไข่จริง
    pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)

    task.wait(0.15)
end

-- === UI (Sirius Rayfield) ===
local Window = RayfieldLib:CreateWindow({
    Name = "BGSI FARM",
    LoadingTitle = "Loading BGSI Scripts",
    LoadingSubtitle = "by NiTroHub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "Script-BGSI-Settings",
        Autosave = true,
        Autoload = true,
    }
})

-- === CONTROLS TAB ===
local Controls = Window:CreateTab("Controls")

-- ✅ Blow Bubble
Controls:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = flags.BlowBubble,
    Flag = "BlowBubbleToggle",
    Callback = function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.6)
        else stopLoop("BlowBubble") end
    end
})

-- ✅ Unlock Chest
Controls:CreateToggle({
    Name = "Unlock AutoChest",
    CurrentValue = flags.UnlockRiftChest,
    Flag = "UnlockRiftChestToggle",
    Callback = function(v)
        flags.UnlockRiftChest = v
        if v then startLoop("UnlockRiftChest", UnlockRiftChestLoop, 1)
        else stopLoop("UnlockRiftChest") end
    end
})

-- ✅ Auto Hatch Egg
Controls:CreateToggle({
    Name = "Auto Hatch (Custom Egg)",
    CurrentValue = flags.AutoHatchEgg,
    Flag = "AutoHatchEggToggle",
    Callback = function(v)
        flags.AutoHatchEgg = v
        if v then
            -- เมื่อเริ่ม Auto Hatch ถ้ามี Disable Animation ก็ปิดอนิเมชันทันที
            if flags.DisableAnimation then
                pcall(function()
                    hatcheggRemote:FireServer(false, false)
                end)
            end
            startLoop("AutoHatchEgg", AutoHatchEggLoop, 0.15)
        else
            stopLoop("AutoHatchEgg")
        end
    end
})

-- ✅ Disable Hatch Animation (ผูกกับ Auto Hatch)
Controls:CreateToggle({
    Name = "Disable Hatch Animation",
    CurrentValue = flags.DisableAnimation,
    Flag = "DisableAnimationToggle",
    Callback = function(v)
        flags.DisableAnimation = v
        if v then
            print("[BGSI] Hatch animation disabled (no cutscene)")
            -- ถ้าเปิด Auto Hatch อยู่ จะปิดอนิเมชันทันที
            if flags.AutoHatchEgg then
                pcall(function()
                    hatcheggRemote:FireServer(false, false)
                end)
            end
        else
            print("[BGSI] Hatch animation enabled")
            -- ถ้าเปิด Auto Hatch อยู่ จะเปิดอนิเมชันกลับ
            if flags.AutoHatchEgg then
                pcall(function()
                    hatcheggRemote:FireServer(true, true)
                end)
            end
        end
    end
})

-- ✅ Textbox for Egg Name
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

-- ✅ Textbox for Hatch Amount
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

-- === SETTINGS TAB ===
local Settings = Window:CreateTab("Settings")

Settings:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        RayfieldLib:Destroy()
    end
})
