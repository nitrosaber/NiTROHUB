--// 🌀 NiTroHUB - NatHub Edition v5.3
--// ✨ by NiTroHUB x Gemini (Final Compatibility Workaround)
--// Description: แก้ไข Error โดยการเลี่ยงไม่ใช้ฟังก์ชัน AddTab ที่มีปัญหา และนำ UI ทั้งหมดใส่ในหน้าต่างหลักโดยตรง

-- =================================================================
-- [[ SECTION 1: LOAD NATHUB LIBRARY (WITH ERROR HANDLING) ]]
-- =================================================================
local NatLib
local success, result = pcall(function()
    NatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()
end)

if not success or not NatLib then
    warn("[NiTroHUB] FATAL: Could not load NatHub Library. The script cannot continue. Error: " .. tostring(result))
    return -- Stop script execution if the library fails to load
end
print("[NiTroHUB] NatHub Library loaded successfully.")


-- =================================================================
-- [[ SECTION 2: NITROHUB CORE LOGIC (UNCHANGED) ]]
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
for _, name in ipairs(Config.ChestNames) do CHEST_LIST[name:lower()] = true end
local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

-- // 📡 REMOTE EVENT HANDLER
local frameworkRemote
pcall(function()
    frameworkRemote = ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Framework", 5):WaitForChild("Network", 5):WaitForChild("Remote", 5):WaitForChild("RemoteEvent", 5)
    logmsg("Framework RemoteEvent found.")
end)
if not frameworkRemote then warnmsg("Could not find the Framework RemoteEvent! Script will not function.") end

-- // 📊 SCRIPT STATE
local State = { HatchRunning = false, ChestRunning = false, AntiAfkRunning = true, EggsHatched = 0, ChestsCollected = 0, LastChest = "-", Status = "Idle" }
local lastCollectedChests = {}

-- // 🚀 CORE FUNCTIONS
pcall(function()
    local function destroyHatchGui(child) if child and child.Parent and (child.Name:match("Hatch") or child.Name:match("Egg")) then task.wait(); child:Destroy() end end
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
        local success, _ = pcall(function() frameworkRemote:FireServer("ClaimChest", chest.Name, true) end)
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
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then pcall(collectChest, obj); task.wait() end
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
-- [[ SECTION 3: GUI CREATION (BYPASSING BUGGY AddTab FUNCTION) ]]
-- =================================================================

local Window = NatLib:CreateWindow("NiTroHUB")
-- [FIX] เราจะไม่สร้าง Tab แยกอีกต่อไป แต่จะเพิ่ม UI Element ทั้งหมดลงใน Window โดยตรง
-- เพื่อเลี่ยงการใช้ฟังก์ชัน AddTab ที่มีปัญหา
local Toggles = {}

_G.UpdateNiTroHUBToggle = function(name, value)
    if Toggles[name] then Toggles[name]:Update(value) end
end

-- เพิ่ม Toggles ลงใน Window โดยตรง
Toggles.AutoHatch = Window:AddToggle({ Name = "Auto Hatch", Default = State.HatchRunning, Callback = function(Value) State.HatchRunning = Value end })
Toggles.AutoChest = Window:AddToggle({ Name = "Auto Chest Collect", Default = State.ChestRunning, Callback = function(Value) State.ChestRunning = Value end })
Toggles.AntiAFK = Window:AddToggle({ Name = "Anti-AFK", Default = State.AntiAfkRunning, Callback = function(Value) State.AntiAfkRunning = Value end })

Window:AddSeparator()

-- เพิ่ม Labels ลงใน Window โดยตรง
Window:AddLabel({ Text = "--- Stats ---" })
local StatLabels = {
    Status = Window:AddLabel({ Text = "Status: Idle" }),
    Eggs = Window:AddLabel({ Text = "Eggs Hatched: 0" }),
    Chests = Window:AddLabel({ Text = "Chests Collected: 0" }),
    LastChest = Window:AddLabel({ Text = "Last Chest: -" })
}

-- Loop สำหรับอัปเดตข้อมูลบน Labels ยังคงทำงานเหมือนเดิม
task.spawn(function()
    while task.wait(0.25) do
        if not State.HatchRunning and not State.ChestRunning then
            State.Status = "Idle"
        end

        pcall(function() StatLabels.Status:Set("Status: " .. State.Status) end)
        pcall(function() StatLabels.Eggs:Set("Eggs Hatched: " .. State.EggsHatched) end)
        pcall(function() StatLabels.Chests:Set("Chests Collected: " .. State.ChestsCollected) end)
        pcall(function() StatLabels.LastChest:Set("Last Chest: " .. State.LastChest) end)
    end
end)

logmsg("NiTroHUB - NatHub Edition Initialized Successfully!")

