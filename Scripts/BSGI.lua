-- Load Rayfield Library
local success, RayfieldLib = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
end)

if not success or not RayfieldLib then
    warn("❌ Failed to load Rayfield Library.")
    return
end

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Safe Wait Function
local function safeWait(parent, childName, timeout)
    local obj = parent:WaitForChild(childName, timeout or 10)
    if not obj then
        warn("Missing object:", childName)
    end
    return obj
end

-- === REMOTES ===
-- hatcheggRemote = ปิด/เปิดอนิเมชันตอนสุ่มไข่
local hatcheggRemote = safeWait(ReplicatedStorage, "Client")
if hatcheggRemote then
    hatcheggRemote = safeWait(hatcheggRemote, "Effects")
    hatcheggRemote = hatcheggRemote and safeWait(hatcheggRemote, "HatchEgg")
end

-- frameworkRemote = ใช้สุ่มไข่จริง
local frameworkRemote = safeWait(ReplicatedStorage, "Shared")
if frameworkRemote then
    frameworkRemote = safeWait(frameworkRemote, "Framework")
    frameworkRemote = frameworkRemote and safeWait(frameworkRemote, "Network")
    frameworkRemote = frameworkRemote and safeWait(frameworkRemote, "Remote")
    frameworkRemote = frameworkRemote and safeWait(frameworkRemote, "RemoteEvent")
end

if not (hatcheggRemote and frameworkRemote) then
    warn("❌ Missing required Remote objects.")
    return
end

-- === FLAGS & SETTINGS ===
local flags = {
    BlowBubble = false,
    UnlockRiftChest = false,
    MainLoop = false,
    AutoHatchEgg = false,
    DisableAnimation = true -- ค่าเริ่มต้น: ปิดอนิเมชัน
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
    RemoteEvent:FireServer("BlowBubble")
    task.wait(0.6)
end

local function UnlockRiftChestLoop()
    RemoteEvent:FireServer("UnlockRiftChest", "royal-chest", "golden-chest", false)
    task.wait(1)
end

local function MainLoop()
    frameworkRemote:FireServer("ClaimFreeWheelSpin")

    for i = 1, 9 do
        if not flags.MainLoop then break end
        frameworkRemote:FireServer("ClaimPlaytime", i)
        task.wait(3.5)
    end

    frameworkRemote:FireServer("ClaimChest", "Void Chest", "Giant Chest", true)
    task.wait(2)
end

-- ✅ Auto Hatch Egg + ปิดอนิเมชันแบบแน่นอน
local function AutoHatchEggLoop()
    -- ถ้าเลือกให้ปิดอนิเมชัน
    if flags.DisableAnimation then
        pcall(function()
            -- ปิดอนิเมชัน (บางเกมต้องส่ง false, false เพื่อปิดทั้งหมด)
            hatcheggRemote:FireServer(false, false)
        end)
    else
        -- เปิดอนิเมชันกลับ
        pcall(function()
            hatcheggRemote:FireServer(true, true)
        end)
    end

    -- สุ่มไข่จริง
    pcall(function()
        frameworkRemote:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)

    task.wait(0.15)
end

-- === RAYFIELD UI ===
local Window = RayfieldLib:CreateWindow({
    Name = "BGSI FARM",
    LoadingTitle = "Loading BGSI Scripts",
    LoadingSubtitle = "by NiTroHub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "Script-BGSI-Settings"
    }
})

RayfieldLib:LoadConfiguration()

local Controls = Window:CreateTab("Controls")

Controls:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = flags.BlowBubble,
    Flag = "BlowBubbleToggle",
    Callback = function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.6)
        else stopLoop("BlowBubble") end
        RayfieldLib:SaveConfiguration()
    end
})

Controls:CreateToggle({
    Name = "Unlock Golden Chest",
    CurrentValue = flags.UnlockRiftChest,
    Flag = "UnlockRiftChestToggle",
    Callback = function(v)
        flags.UnlockRiftChest = v
        if v then startLoop("UnlockRiftChest", UnlockRiftChestLoop, 1)
        else stopLoop("UnlockRiftChest") end
        RayfieldLib:SaveConfiguration()
    end
})

Controls:CreateToggle({
    Name = "Main Loop (Spin, Playtime, Chests)",
    CurrentValue = flags.MainLoop,
    Flag = "MainLoopToggle",
    Callback = function(v)
        flags.MainLoop = v
        if v then startLoop("MainLoop", MainLoop, 4)
        else stopLoop("MainLoop") end
        RayfieldLib:SaveConfiguration()
    end
})

Controls:CreateToggle({
    Name = "Auto Hatch (Custom Egg)",
    CurrentValue = flags.AutoHatchEgg,
    Flag = "AutoHatchEggToggle",
    Callback = function(v)
        flags.AutoHatchEgg = v
        if v then startLoop("AutoHatchEgg", AutoHatchEggLoop, 0.15)
        else stopLoop("AutoHatchEgg") end
        RayfieldLib:SaveConfiguration()
    end
})

Controls:CreateToggle({
    Name = "Disable Hatch Animation",
    CurrentValue = flags.DisableAnimation,
    Flag = "DisableAnimationToggle",
    Callback = function(v)
        flags.DisableAnimation = v
        if v then
            print("[BGSI] Hatch animation disabled (no cutscene)")
            pcall(function()
                hatcheggRemote:FireServer(false, false)
            end)
        else
            print("[BGSI] Hatch animation enabled")
            pcall(function()
                hatcheggRemote:FireServer(true, true)
            end)
        end
        RayfieldLib:SaveConfiguration()
    end
})

Controls:CreateInput({
    Name = "Egg Name",
    PlaceholderText = "Enter egg name (e.g. Infinity Egg)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text ~= "" then
            settings.EggName = text
            print("[BGSI] Egg name set to:", text)
            RayfieldLib:SaveConfiguration()
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
            RayfieldLib:SaveConfiguration()
        else
            warn("⚠️ Invalid hatch amount. Please use 1, 3, 6, 8 or 9.")
        end
    end
})

local Settings = Window:CreateTab("Settings")

Settings:CreateButton({
    Name = "💾 Save Configuration Now",
    Callback = function()
        RayfieldLib:SaveConfiguration()
        RayfieldLib:Notify({
            Title = "✅ Settings Saved",
            Content = "Your current configuration has been saved!",
            Duration = 4
        })
    end
})

Settings:CreateButton({
    Name = "📂 Load Configuration Now",
    Callback = function()
        RayfieldLib:LoadConfiguration()
        RayfieldLib:Notify({
            Title = "📦 Settings Loaded",
            Content = "Configuration loaded successfully!",
            Duration = 4
        })
    end
})

Settings:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        RayfieldLib:Destroy()
    end
})
