-- ===============================================================
-- 🌀 NiTROHUB PRO - Final Edition (Icons + Rewards Toggles)
-- ✨ Auto Hatch (Selectable Egg), Auto Rebirth, Auto Chest, Auto Rewards, Status
-- ===============================================================

-- ✅ CONFIG ------------------------------------------------------
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 3,
    HatchDelay = 1.2,
    AutoRebirth = true,
    RebirthDelay = 2,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
        "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
        "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }
}

local State = {
    HatchRunning = false,
    RebirthRunning = false,
    ChestRunning = false,
    RewardGift = false,
    RewardDaily = false,
    RewardSpin = false,
    RewardRank = false,
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
local FrameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

-- ✅ LOG ---------------------------------------------------------
local function logmsg(msg) print("[NiTROHUB]", msg) end
local function warnmsg(msg) warn("[NiTROHUB]", msg) end

-- ✅ LOAD UI LIBRARY ---------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NiTroHub/UI-Library/main/Source.lua"))()
local MainWindow = Library:CreateWindow("🌀 NiTROHUB PRO - Final Edition")

-- ✅ ICONS (rbxassetid จาก Roblox CoreGui) -----------------------
local icons = {
    Egg     = "rbxassetid://3926305904",
    Refresh = "rbxassetid://3926305905",
    Box     = "rbxassetid://3926305906",
    Gift    = "rbxassetid://3926307970",
    Info    = "rbxassetid://3926307971"
}

-- ===============================================================
-- 🥚 AUTO HATCH
-- ===============================================================
task.spawn(function()
    local EggFolder = Workspace:FindFirstChild("Eggs")
    local EggNames = {}

    if EggFolder then
        for _, egg in ipairs(EggFolder:GetChildren()) do
            if egg:IsA("Model") or egg:IsA("Folder") then
                table.insert(EggNames, egg.Name)
            end
        end
    end

    local HatchTab = MainWindow:AddTab("Auto Hatch", icons.Egg)

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
        Options = {"1","3","9"},
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
            if state then logmsg("🚀 เริ่มสุ่มไข่") else logmsg("⏸️ หยุดสุ่มไข่") end
        end
    })

    while task.wait(0.25) do
        if State.HatchRunning and FrameworkRemote then
            local ok, err = pcall(function()
                FrameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched += Config.HatchAmount
                State.Status = "Hatching " .. Config.EggName
            end)
            if not ok then warnmsg("❌ Hatch Error: " .. tostring(err)) end
            task.wait(Config.HatchDelay)
        end
    end
end)

-- ===============================================================
-- ♻️ AUTO REBIRTH
-- ===============================================================
task.spawn(function()
    local RebirthTab = MainWindow:AddTab("Auto Rebirth", icons.Refresh)

    RebirthTab:CreateToggle({
        Name = "เปิด Auto Rebirth",
        Default = Config.AutoRebirth,
        Callback = function(state)
            State.RebirthRunning = state
            logmsg(state and "♻️ เริ่ม Rebirth" or "⏸️ หยุด Rebirth")
        end
    })

    while task.wait(0.25) do
        if State.RebirthRunning and FrameworkRemote then
            local ok, err = pcall(function()
                FrameworkRemote:FireServer("Rebirth", 1)
                State.Status = "Rebirthing..."
            end)
            if not ok then warnmsg("❌ Rebirth Error: " .. tostring(err)) end
            task.wait(Config.RebirthDelay)
        end
    end
end)

-- ===============================================================
-- 📦 AUTO CHEST
-- ===============================================================
task.spawn(function()
    local ChestTab = MainWindow:AddTab("Auto Chest", icons.Box)

    ChestTab:CreateToggle({
        Name = "เปิด Auto Chest",
        Default = false,
        Callback = function(state)
            State.ChestRunning = state
            logmsg(state and "📦 เริ่มเก็บกล่อง" or "⏸️ หยุดเก็บกล่อง")
        end
    })

    local CHEST_LIST = {}
    for _, n in ipairs(Config.ChestNames) do CHEST_LIST[n:lower()] = true end
    local last = {}

    local function Collect(c)
        if not c or not c.Parent then return end
        local key = c:GetDebugId()
        if last[key] and tick()-last[key] < Config.ChestCollectCooldown then return end
        local ok = pcall(function()
            FrameworkRemote:FireServer("ClaimChest", c.Name, true)
        end)
        if ok then
            State.ChestsCollected += 1
            State.LastChest = c.Name
            last[key] = tick()
            logmsg("🎁 เก็บกล่อง: " .. c.Name)
        end
    end

    while task.wait(Config.ChestCheckInterval) do
        if State.ChestRunning and FrameworkRemote then
            State.Status = "Collecting Chests..."
            for _, area in ipairs({Workspace:FindFirstChild("Chests"), Workspace}) do
                if area then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            Collect(obj)
                        end
                    end
                end
            end
        end
    end
end)

-- ===============================================================
-- 🎁 AUTO REWARDS (แยก Toggle)
-- ===============================================================
task.spawn(function()
    local RewardsTab = MainWindow:AddTab("Auto Rewards", icons.Gift)

    RewardsTab:CreateToggle({
        Name = "Auto Gift",
        Default = false,
        Callback = function(state) State.RewardGift = state end
    })
    RewardsTab:CreateToggle({
        Name = "Auto Daily",
        Default = false,
        Callback = function(state) State.RewardDaily = state end
    })
    RewardsTab:CreateToggle({
        Name = "Auto Spin",
        Default = false,
        Callback = function(state) State.RewardSpin = state end
    })
    RewardsTab:CreateToggle({
        Name = "Auto Rank",
        Default = false,
        Callback = function(state) State.RewardRank = state end
    })

    while task.wait(10) do
        if FrameworkRemote then
            if State.RewardGift then
                pcall(function() FrameworkRemote:FireServer("ClaimReward", "GiftReward") end)
                logmsg("🎁 AutoClaim: GiftReward")
            end
            if State.RewardDaily then
                pcall(function() FrameworkRemote:FireServer("ClaimReward", "DailyReward") end)
                logmsg("📅 AutoClaim: DailyReward")
            end
            if State.RewardSpin then
                pcall(function() FrameworkRemote:FireServer("ClaimReward", "SpinReward") end)
                logmsg("🎲 AutoClaim: SpinReward")
            end
            if State.RewardRank then
                pcall(function() FrameworkRemote:FireServer("ClaimReward", "RankReward") end)
                logmsg("🏆 AutoClaim: RankReward")
            end
        end
    end
end)

-- ===============================================================
-- 📊 STATUS
-- ===============================================================
task.spawn(function()
    local InfoTab = MainWindow:AddTab("Status", icons.Info)

    InfoTab:CreateLabel(function() return "📌 สถานะ: " .. State.Status end)
    InfoTab:CreateLabel(function() return "🥚 Eggs: " .. State.EggsHatched end)
    InfoTab:CreateLabel(function() return "📦 Chests: " .. State.ChestsCollected end)
    InfoTab:CreateLabel(function() return "🎁 Last Chest: " .. State.LastChest end)
    InfoTab:CreateLabel(function()
        return string.format("🎁 Rewards: Gift(%s) Daily(%s) Spin(%s) Rank(%s)",
            State.RewardGift and "ON" or "OFF",
            State.RewardDaily and "ON" or "OFF",
            State.RewardSpin and "ON" or "OFF",
            State.RewardRank and "ON" or "OFF"
        )
    end)
end)

logmsg("✅ Loaded NiTROHUB PRO - Final Edition (Icons + Rewards Toggles)")
