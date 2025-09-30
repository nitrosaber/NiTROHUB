-- ===============================================================
-- 🌀 NiTROHUB PRO - Auto Hatch + Auto Rebirth + Auto Chest (Final)
-- ✨ by NiTROHUB x Gemini (แก้ไข Asset ID)
-- Description: A full-featured script with selectable eggs, safe auto hatch,
-- auto rebirth, and auto chest collection without teleporting.
-- ===============================================================

-- ✅ CONFIG ------------------------------------------------------
local Config = {
    EggName = "Autumn Egg",    -- 🥚 ไข่เริ่มต้น
    HatchAmount = 3,           -- 🎲 จำนวนที่เปิด (1 / 3 / 9)
    HatchDelay = 1.2,          -- ⏱️ เวลาระหว่างการเปิดแต่ละรอบ
    AutoRebirth = true,        -- ♻️ เปิด Rebirth อัตโนมัติ
    RebirthDelay = 2,          -- ⏱️ เวลาระหว่าง Rebirth
    ChestCheckInterval = 10,   -- 🔍 ตรวจหากล่องทุกๆ n วินาที
    ChestCollectCooldown = 60, -- ⏱️ หน่วงเวลาเก็บกล่องแต่ละกล่อง
    ChestNames = {             -- 📦 รายชื่อกล่องที่ต้องการเก็บ
        "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
        "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
        "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
    }
}

local State = {
    HatchRunning = false,
    RebirthRunning = false,
    ChestRunning = false,
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-",
    Status = "Idle"
}

-- ✅ SERVICES ----------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ✅ REMOTES -----------------------------------------------------
local frameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

-- ✅ UI LIBRARY --------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NiTroHub/UI-Library/main/Source.lua"))()
local MainWindow = Library:CreateWindow("🌀 NiTROHUB PRO - Final Edition")

-- ✅ LOG FUNCTION ------------------------------------------------
local function logmsg(msg) print("[NiTROHUB]", msg) end
local function warnmsg(msg) warn("[NiTROHUB]", msg) end

-- ✅ CHEST LIST LOOKUP -------------------------------------------
local CHEST_LIST = {}
for _, name in ipairs(Config.ChestNames) do
    CHEST_LIST[name:lower()] = true
end

-- ===============================================================
-- 🥚 AUTO HATCH SYSTEM (Selectable Egg)
-- ===============================================================
task.spawn(function()
    local EggFolder = Workspace:FindFirstChild("Eggs")
    local EggNames = {}

    if EggFolder then
        for _, egg in pairs(EggFolder:GetChildren()) do
            if egg:IsA("Model") or egg:IsA("Folder") then
                table.insert(EggNames, egg.Name)
            end
        end
    end

    -- [EDITED] Changed icon to rbxassetid
    local HatchTab = MainWindow:AddTab("Auto Hatch", "rbxassetid://1351877496")

    HatchTab:CreateDropdown({
        Name = "เลือกไข่ที่ต้องการเปิด",
        Options = EggNames,
        Default = Config.EggName,
        Callback = function(selected)
            Config.EggName = selected
            logmsg("✅ เปลี่ยนไข่เป็น: " .. selected)
        end
    })

    HatchTab:CreateDropdown({
        Name = "จำนวนการเปิดไข่",
        Options = {"1", "3", "9"},
        Default = tostring(Config.HatchAmount),
        Callback = function(selected)
            Config.HatchAmount = tonumber(selected)
            logmsg("🎲 เปลี่ยนจำนวนเปิดไข่: " .. selected)
        end
    })

    HatchTab:CreateToggle({
        Name = "เปิด Auto Hatch",
        Default = false,
        Callback = function(state)
            State.HatchRunning = state
            if state then
                logmsg("🚀 เริ่มสุ่มไข่: " .. Config.EggName)
            else
                logmsg("⏸️ หยุดสุ่มไข่")
            end
        end
    })

    while true do
        if State.HatchRunning and frameworkRemote then
            State.Status = "Hatching Eggs..."
            local success, err = pcall(function()
                local args = {"HatchEgg", Config.EggName, Config.HatchAmount}
                frameworkRemote:FireServer(unpack(args))
                State.EggsHatched += Config.HatchAmount
            end)
            if not success then
                warnmsg("Auto Hatch failed: " .. tostring(err))
                State.HatchRunning = false
            end
            task.wait(Config.HatchDelay)
        else
            task.wait(0.25)
        end
    end
end)

-- ===============================================================
-- ♻️ AUTO REBIRTH SYSTEM
-- ===============================================================
task.spawn(function()
    -- [EDITED] Changed icon to rbxassetid
    local RebirthTab = MainWindow:AddTab("Auto Rebirth", "rbxassetid://1351877495")

    RebirthTab:CreateToggle({
        Name = "เปิด Auto Rebirth",
        Default = Config.AutoRebirth,
        Callback = function(state)
            State.RebirthRunning = state
            logmsg(state and "♻️ เริ่ม Auto Rebirth" or "⏸️ หยุด Auto Rebirth")
        end
    })

    while true do
        if State.RebirthRunning then
            local success, err = pcall(function()
                local args = {"Rebirth", 1}
                frameworkRemote:FireServer(unpack(args))
            end)
            if not success then
                warnmsg("Rebirth Error: " .. tostring(err))
                State.RebirthRunning = false
            end
            task.wait(Config.RebirthDelay)
        else
            task.wait(0.25)
        end
    end
end)

-- ===============================================================
-- 📦 AUTO CHEST SYSTEM (No Teleport)
-- ===============================================================
task.spawn(function()
    -- [EDITED] Changed icon to rbxassetid
    local ChestTab = MainWindow:AddTab("Auto Chest", "rbxassetid://1351877503")

    ChestTab:CreateToggle({
        Name = "เปิด Auto Chest",
        Default = false,
        Callback = function(state)
            State.ChestRunning = state
            logmsg(state and "📦 เริ่มค้นหาและเก็บกล่อง" or "⏸️ หยุดเก็บกล่อง")
        end
    })

    local lastCollected = {}

    local function collectChest(chest)
        if not chest or not chest.Parent then return end
        local key = chest:GetDebugId()
        if lastCollected[key] and tick() - lastCollected[key] < Config.ChestCollectCooldown then
            return
        end

        local success = pcall(function()
            frameworkRemote:FireServer("ClaimChest", chest.Name, true)
        end)

        if success then
            State.ChestsCollected += 1
            State.LastChest = chest.Name
            lastCollected[key] = tick()
            logmsg("🎁 เก็บกล่อง: " .. chest.Name)
        end
    end

    while true do
        if State.ChestRunning then
            State.Status = "Collecting Chests..."
            local areas = {Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}
            for _, area in ipairs(areas) do
                if area then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            collectChest(obj)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(Config.ChestCheckInterval)
    end
end)

-- ===============================================================
-- 📊 STATUS TAB
-- ===============================================================
task.spawn(function()
    -- [EDITED] Changed icon to rbxassetid and corrected typo from 'Add-Tab' to 'AddTab'
    local InfoTab = MainWindow:AddTab("Status", "rbxassetid://1351877500")

    InfoTab:CreateLabel(function()
        return "📌 สถานะ: " .. State.Status
    end)

    InfoTab:CreateLabel(function()
        return "🥚 Eggs Hatched: " .. tostring(State.EggsHatched)
    end)

    InfoTab:CreateLabel(function()
        return "📦 Chests Collected: " .. tostring(State.ChestsCollected)
    end)

    InfoTab:CreateLabel(function()
        return "🎁 Last Chest: " .. tostring(State.LastChest)
    end)
end)

logmsg("✅ NiTROHUB PRO - Final Edition Loaded Successfully!")
