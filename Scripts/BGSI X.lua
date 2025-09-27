--// 🌀 NiTroHUB PRO - Infinity Hatch + Auto Chest (FULL)
--// ✨ by NiTroHUB x ChatGPT (2025 Edition)

-- ==========================
-- ⚙️ CONFIG (ตั้งค่าตามต้องการ)
-- ==========================
local EGG_NAME = "Autumn Egg"           -- ชื่อไข่ที่จะสุ่ม
local HATCH_AMOUNT = 8                  -- จำนวนสุ่มต่อครั้ง (1/3/8)
local HATCH_DELAY = 0.05                -- เวลาระหว่างสุ่ม (ระวังค่าต่ำเกินไป)
local CHEST_CHECK_INTERVAL = 10         -- ตรวจหากล่องทุก ๆ 10 วินาที
local CHEST_COLLECT_COOLDOWN = 60       -- คูลดาวน์การเก็บซ้ำ (วินาที)

-- 📦 รายชื่อกล่องที่รองรับจาก Wiki
local CHEST_NAMES = {
    "Royal Chest",
    "Super Chest",
    "Golden Chest",
    "Ancient Chest",
    "Dice Chest",
    "Infinity Chest",
    "Void Chest",
    "Giant Chest",
    "Ticket Chest",
    "Easy Obby Chest",
    "Medium Obby Chest",
    "Hard Obby Chest"
}

-- ==========================
-- 🧩 SERVICES & PLAYER
-- ==========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- ✅ แปลงชื่อเป็น lowercase เพื่อเปรียบเทียบ
local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end

-- ==========================
-- 📡 REMOTE EVENTS (ค้นหาและตรวจสอบความพร้อม)
-- ==========================
local function logmsg(...)
    print("[NiTroHUB]", ...)
end

local function findRemoteEvent(name)
    local function searchRemote(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local lname = obj.Name:lower()
                if lname:find(name:lower()) or lname:find("remote") or lname:find("network") then
                    return obj
                end
            end
        end
        return nil
    end

    local remote = searchRemote(ReplicatedStorage)
    if remote then return remote end

    local shared = ReplicatedStorage:FindFirstChild("Shared")
    if shared then
        local remoteFolder = shared:FindFirstChild("Framework") and shared.Framework:FindFirstChild("Network") and shared.Framework.Network:FindFirstChild("Remote")
        if remoteFolder then
            local r = searchRemote(remoteFolder)
            if r then return r end
        end
    end
    
    return nil
end

local remoteEvent = findRemoteEvent("HatchEgg") or findRemoteEvent("RemoteEvent")
if not remoteEvent then
    warn("❌ RemoteEvent สำหรับสุ่มไข่ไม่พบ. สคริปต์อาจทำงานไม่สมบูรณ์")
else
    logmsg("✅ RemoteEvent สำหรับสุ่มไข่พบแล้ว:", remoteEvent.Name)
end

local collectRemoteEvent = findRemoteEvent("CollectChest") or findRemoteEvent("RemoteEvent")
if not collectRemoteEvent then
    warn("❌ Collect RemoteEvent สำหรับเก็บกล่องไม่พบ. AutoChest อาจไม่ทำงาน")
else
    logmsg("✅ Collect RemoteEvent สำหรับเก็บกล่องพบแล้ว:", collectRemoteEvent.Name)
end

-- 📊 STATE
local running = false
local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollectedChests = {}
local lastCollectedChestName = "-"

-- ==========================
-- 🔁 UI & ANIMATION PATCH
-- ==========================
-- ปิด GUI ที่เกี่ยวข้อง
task.spawn(function()
    local guiNames = {"HatchEggUI", "HatchAnimationGui", "HatchGui", "LastHatchGui", "EggHatchUI", "AutoDeleteUI", "HatchPopupUI"}
    while task.wait(0.3) do
        for _, n in ipairs(guiNames) do
            local g = playerGui:FindFirstChild(n)
            if g then
                pcall(function() g.Enabled = false; g.Visible = false end)
            end
        end
    end
end)

-- ปิดแอนิเมชันสุ่มไข่ (ต้องการ getsenv)
task.spawn(function()
    pcall(function()
        local s = player:WaitForChild("PlayerScripts", 5)
            :WaitForChild("Scripts", 5)
            :WaitForChild("Game", 5)
            :WaitForChild("Egg Opening Frontend", 5)
        local env = getsenv(s)
        if env and env.PlayEggAnimation then
            env.PlayEggAnimation = function() return end
            logmsg("✅ ปิดอนิเมชันสุ่มไข่แล้ว")
        end
    end)
end)

-- ==========================
-- 🥚 AUTO HATCH
-- ==========================
local function hatchEgg()
    if not remoteEvent then return end
    pcall(function()
        remoteEvent:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
        eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
    end)
end

task.spawn(function()
    while task.wait(HATCH_DELAY) do
        if running then
            hatchEgg()
        end
    end
end)

-- ==========================
-- 💰 AUTO CHEST
-- ==========================
local function collectChest(chest)
    if not chest or not chest.Parent then return end
    local lowerName = chest.Name:lower()

    if not CHEST_LIST[lowerName] then return end

    local key = chest:GetDebugId() or chest:GetFullName()
    if lastCollectedChests[key] and tick() - lastCollectedChests[key] < CHEST_COLLECT_COOLDOWN then
        return
    end

    local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
    if trigger then
        if firetouchinterest then
            firetouchinterest(hrp, trigger, 0)
            task.wait(0.2)
            firetouchinterest(hrp, trigger, 1)
            lastCollectedChests[key] = tick()
            chestsCollectedCount = chestsCollectedCount + 1
            lastCollectedChestName = chest.Name
            logmsg("💰 เก็บ Chest สำเร็จ:", chest.Name)
        else
            warn("❌ ฟังก์ชัน firetouchinterest ไม่รองรับใน Executor นี้")
        end
    end
end

task.spawn(function()
    while task.wait(CHEST_CHECK_INTERVAL) do
        local areas = {workspace, workspace:FindFirstChild("Chests")}
        for _, area in ipairs(areas) do
            if area then
                for _, obj in ipairs(area:GetDescendants()) do
                    if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                        pcall(collectChest, obj)
                    end
                end
            end
        end
    end
end)

-- ==========================
-- 💤 ANTI AFK
-- ==========================
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ==========================
-- 🧭 GUI INTERFACE
-- ==========================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "InfinityHatchGUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.Size = UDim2.new(0, 220, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "🌀 Infinity Hatch"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16

local btn = Instance.new("TextButton", frame)
btn.Position = UDim2.new(0.1, 0, 0.35, 0)
btn.Size = UDim2.new(0.8, 0, 0.2, 0)
btn.Text = "เริ่มสุ่มไข่ 🔁"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundTransparency = 0.2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        btn.Text = "หยุดสุ่ม ⏸️"
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        btn.Text = "เริ่มสุ่มไข่ 🔁"
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

local statsLabel = Instance.new("TextLabel", frame)
statsLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
statsLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 12
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

task.spawn(function()
    while task.wait(0.5) do
        statsLabel.Text = string.format("ฟักไข่แล้ว: %d\nเก็บกล่องแล้ว: %d\nกล่องล่าสุด: %s",
            eggsHatchedCount, chestsCollectedCount, lastCollectedChestName)
    end
end)

-- ปุ่มไอคอนลอย
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0, 50, 0, 50)
mini.Position = UDim2.new(0.02, 0, 0.7, 0)
mini.Text = "🌀"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 28
mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mini.TextColor3 = Color3.fromRGB(0, 255, 255)
mini.BackgroundTransparency = 0.3
mini.Draggable = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(1, 0)

local tip = Instance.new("TextLabel", mini)
tip.Size = UDim2.new(0, 120, 0, 30)
tip.Position = UDim2.new(1, 5, 0.25, 0)
tip.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tip.TextColor3 = Color3.fromRGB(0, 255, 255)
tip.Text = "NiTroHUB PRO"
tip.Font = Enum.Font.GothamBold
tip.TextSize = 14
tip.Visible = false
tip.BackgroundTransparency = 0.2
Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 8)

mini.MouseEnter:Connect(function() tip.Visible = true end)
mini.MouseLeave:Connect(function() tip.Visible = false end)
mini.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

-- ==========================
-- ⌨️ HOTKEY TOGGLE
-- ==========================
UIS.InputBegan:Connect(function(input, typing)
    if typing then return end
    if input.KeyCode == Enum.KeyCode.J then
        running = not running
        btn.Text = running and "หยุดสุ่ม ⏸️" or "เริ่มสุ่มไข่ 🔁"
        btn.BackgroundColor3 = running and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 0, 0)
        logmsg(running and "✅ เริ่มสุ่มไข่..." or "⏸️ หยุดสุ่มไข่แล้ว")
    end
end)

logmsg("✅ NiTroHUB PRO - Infinity Hatch + AutoChest Loaded!")
