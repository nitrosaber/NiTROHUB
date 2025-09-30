-- ===============================================================
-- 🌀 NiTROHUB PRO - Final Edition (NatUI Fixed Version)
-- ===============================================================

-- ✅ CONFIG ------------------------------------------------------
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 3,
    HatchDelay = 0.1,
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

-- ✅ LOAD NATUI LIBRARY ------------------------------------------
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/Uisource.lua"))()

-- สร้างหน้าต่างหลัก
local MainUI = NatUI({
    Title = "🌀 NiTROHUB PRO - Final Edition",
    Description = "Auto Hatch, Rebirth, Chest, Rewards, Status",
    Icon = "rbxassetid://3926305904"
})

-- ✅ ICONS -------------------------------------------------------
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
local HatchTab = MainUI:AddTab({
    Title = "Auto Hatch",
    Desc = "สุ่มไข่อัตโนมัติ",
    Icon = icons.Egg
})

HatchTab:Toggle({
    Title = "เปิด Auto Hatch",
    Callback = function(state)
        State.HatchRunning = state
        logmsg(state and "🚀 เริ่มสุ่มไข่" or "⏸️ หยุดสุ่มไข่")
    end
})

task.spawn(function()
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
local RebirthTab = MainUI:AddTab({
    Title = "Auto Rebirth",
    Desc = "รีเกิดอัตโนมัติ",
    Icon = icons.Refresh
})

RebirthTab:Toggle({
    Title = "เปิด Auto Rebirth",
    Callback = function(state)
        State.RebirthRunning = state
        logmsg(state and "♻️ เริ่ม Rebirth" or "⏸️ หยุด Rebirth")
    end
})

task.spawn(function()
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
local ChestTab = MainUI:AddTab({
    Title = "Auto Chest",
    Desc = "เก็บกล่องอัตโนมัติ",
    Icon = icons.Box
})

ChestTab:Toggle({
    Title = "เปิด Auto Chest",
    Callback = function(state)
        State.ChestRunning = state
        logmsg(state and "📦 เริ่มเก็บกล่อง" or "⏸️ หยุดเก็บกล่อง")
    end
})

task.spawn(function()
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
-- 🎁 AUTO REWARDS
-- ===============================================================
local RewardsTab = MainUI:AddTab({
    Title = "Auto Rewards",
    Desc = "รับของรางวัลอัตโนมัติ",
    Icon = icons.Gift
})

RewardsTab:Toggle({ Title = "Auto Gift",  Callback = function(s) State.RewardGift  = s end })
RewardsTab:Toggle({ Title = "Auto Daily", Callback = function(s) State.RewardDaily = s end })
RewardsTab:Toggle({ Title = "Auto Spin",  Callback = function(s) State.RewardSpin  = s end })
RewardsTab:Toggle({ Title = "Auto Rank",  Callback = function(s) State.RewardRank  = s end })

task.spawn(function()
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
local StatusTab = MainUI:AddTab({
    Title = "Status",
    Desc = "สถานะการทำงาน",
    Icon = icons.Info
})

StatusTab:Paragraph({
    Title = "📌 สถานะ",
    Desc = function() return State.Status end
})
StatusTab:Paragraph({
    Title = "🥚 Eggs",
    Desc = function() return tostring(State.EggsHatched) end
})
StatusTab:Paragraph({
    Title = "📦 Chests",
    Desc = function() return tostring(State.ChestsCollected) end
})
StatusTab:Paragraph({
    Title = "🎁 Last Chest",
    Desc = function() return State.LastChest end
})

StatusTab:Paragraph({
    Title = "🎁 Rewards",
    Desc = function()
        return string.format("Gift(%s) Daily(%s) Spin(%s) Rank(%s)",
            State.RewardGift and "ON" or "OFF",
            State.RewardDaily and "ON" or "OFF",
            State.RewardSpin and "ON" or "OFF",
            State.RewardRank and "ON" or "OFF"
        )
    end
})

logmsg("✅ Loaded NiTROHUB PRO - Final Edition (NatUI Fixed Version)")
