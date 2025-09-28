--// 🌀 NiTroHUB - NatHub Edition v5.0
--// ✨ by NiTroHUB x Gemini (Adapted for NatHub Library)
--// Description: ย้ายการทำงานทั้งหมดของ NiTroHUB เข้าไปใน UI ของ NatHub เพื่อความสวยงามและคุ้นเคย

-- =================================================================
-- [[ 1. UI LIBRARY LOADER ]]
-- =================================================================
-- โหลด Library ของ NatHub เข้ามาเพื่อใช้งาน
local NatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()
logmsg("NatHub Library Loaded.")

-- =================================================================
-- [[ 2. NITROHUB CORE LOGIC (UNCHANGED) ]]
-- ส่วนนี้คือการทำงานหลักของสคริปต์ ซึ่งยังคงเหมือนเดิมทุกประการ
-- =================================================================

-- // ⚙️ CONFIGURATION
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 8,
    HatchDelay = 0.1,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
        "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
        "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
    }
}

-- // 🧩 SERVICES & CORE SETUP
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CHEST_LIST = {}
for _, name in ipairs(Config.ChestNames) do
    CHEST_LIST[name:lower()] = true
end

local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

-- // 📡 REMOTE EVENT HANDLER
local frameworkRemote
do
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Framework", 5):WaitForChild("Network", 5):WaitForChild("Remote", 5):WaitForChild("RemoteEvent", 5)
    end)
    if success and remote then
        frameworkRemote = remote
        logmsg("Framework RemoteEvent found.")
    else
        warnmsg("Could not find the Framework RemoteEvent! The script will not function.")
    end
end

-- // 📊 SCRIPT STATE
local State = {
    HatchRunning = false,
    ChestRunning = false,
    AntiAfkRunning = true,
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-",
    Status = "Idle"
}
local lastCollectedChests = {}

-- // 🚀 CORE FUNCTIONS
pcall(function()
    local function destroyHatchGui(child)
        if child and child.Parent and (child.Name:match("Hatch") or child.Name:match("Egg")) then
            task.wait(); child:Destroy()
        end
    end
    for _, v in ipairs(playerGui:GetChildren()) do destroyHatchGui(v) end
    playerGui.ChildAdded:Connect(destroyHatchGui)
end)

task.spawn(function()
    while true do
        if State.HatchRunning and frameworkRemote then
            State.Status = "Hatching Eggs..."
            local success, err = pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched = State.EggsHatched + Config.HatchAmount
            end)
            if not success then
                warnmsg("Auto Hatch failed: " .. tostring(err))
                State.HatchRunning = false
                -- ส่งสัญญาณให้ UI ของ NatHub ปิดตัวเองลง
                if _G.UpdateNiTroHUBToggle then _G.UpdateNiTroHUBToggle("AutoHatch", false) end
            end
            task.wait(Config.HatchDelay)
        else
            task.wait(0.2)
        end
    end
end)

local function collectChest(chest)
    if not chest or not chest.Parent then return false end
    local character = player.Character
    if not character then return false end
    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < Config.ChestCollectCooldown) then return false end

    State.Status = "Collecting " .. chest.Name
    if frameworkRemote then
        local success, _ = pcall(function()
            frameworkRemote:FireServer("ClaimChest", chest.Name, true)
        end)
        if success then
            lastCollectedChests[key] = tick()
            State.ChestsCollected = State.ChestsCollected + 1
            State.LastChest = chest.Name
            return true
        end
    end
    return false
end

task.spawn(function()
    while true do
        if State.ChestRunning then
            State.Status = "Searching for chests..."
            local searchAreas = {Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}
            for _, area in ipairs(searchAreas) do
                if area and State.ChestRunning then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if not State.ChestRunning then break end
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            pcall(collectChest, obj); task.wait()
                        end
                    end
                end
            end
        end
        task.wait(Config.ChestCheckInterval)
    end
end)

task.spawn(function()
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if State.AntiAfkRunning then
                VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end)


-- =================================================================
-- [[ 3. GUI CREATION & INTEGRATION ]]
-- ส่วนนี้คือการสร้าง UI ด้วย NatHub และเชื่อมต่อกับ Logic ด้านบน
-- =================================================================

-- สร้างหน้าต่างหลักของ UI
local Window = NatLib:CreateWindow("NiTroHUB")

-- สร้างแท็บสำหรับฟังก์ชันฟาร์ม
local FarmTab = Window:AddTab("Farming")

-- สร้างตารางสำหรับเก็บ Object ของ Toggle เพื่อให้สามารถอัปเดตจากภายนอกได้
local Toggles = {}

-- สร้างฟังก์ชัน Global สำหรับอัปเดตสถานะปุ่ม Toggle ใน UI
_G.UpdateNiTroHUBToggle = function(name, value)
    if Toggles[name] then
        Toggles[name]:Update(value) -- ใช้ฟังก์ชัน Update ของ NatHub
    end
end

-- // -- สร้างปุ่ม Toggle สำหรับ Auto Hatch -- //
Toggles.AutoHatch = FarmTab:AddToggle({
    Name = "Auto Hatch",
    Default = State.HatchRunning, -- ค่าเริ่มต้น
    Callback = function(Value)
        -- เมื่อผู้ใช้กดปุ่ม สถานะจะถูกส่งมาที่นี่
        State.HatchRunning = Value
    end
})

-- // -- สร้างปุ่ม Toggle สำหรับ Auto Chest -- //
Toggles.AutoChest = FarmTab:AddToggle({
    Name = "Auto Chest Collect",
    Default = State.ChestRunning,
    Callback = function(Value)
        State.ChestRunning = Value
    end
})

-- // -- สร้างปุ่ม Toggle สำหรับ Anti-AFK -- //
Toggles.AntiAFK = FarmTab:AddToggle({
    Name = "Anti-AFK",
    Default = State.AntiAfkRunning,
    Callback = function(Value)
        State.AntiAfkRunning = Value
    end
})

-- เพิ่มเส้นคั่นเพื่อความสวยงาม
FarmTab:AddSeparator()

-- สร้าง Label สำหรับแสดงสถานะและสถิติ
local StatsDisplay = FarmTab:AddLabel("Loading stats...")

-- เริ่ม Loop สำหรับอัปเดตข้อมูลบน Label ทุกๆ 0.25 วินาที
task.spawn(function()
    while task.wait(0.25) do
        if not State.HatchRunning and not State.ChestRunning then
            State.Status = "Idle"
        end

        -- สร้างข้อความที่จะแสดงผล
        local statsString = string.format(
            "Status: %s\n\nEggs Hatched: %d\nChests Collected: %d\nLast Chest: %s",
            State.Status, State.EggsHatched, State.ChestsCollected, State.LastChest
        )

        -- อัปเดตข้อความบน Label ของ NatHub (ใช้ pcall เพื่อป้องกัน error)
        pcall(function()
            StatsDisplay:Set(statsString)
        end)
    end
end)

logmsg("NiTroHUB - NatHub Edition Initialized Successfully!")
