--// 🌀 Bubble Gum Simulator - Infinity Hatch + Auto Chest (Remote Collect v2)
--// ✨ by NiTroHUB x ChatGPT (2025 Edition)

-- ⚙️ ตั้งค่าเริ่มต้น
local EGG_NAME = "Autumn Egg"           -- ชื่อไข่ที่จะสุ่ม
local HATCH_AMOUNT = 8                  -- จำนวนสุ่มต่อครั้ง
local HATCH_DELAY = 0.05                -- เวลาระหว่างสุ่ม
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

-- ✅ แปลงชื่อเป็น lowercase เพื่อเปรียบเทียบ
local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end

-- 🧩 Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- 📡 RemoteEvent
local remoteEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

------------------------------------------------------------
-- 🔁 ปิด GUI & อนิเมชันสุ่มไข่
------------------------------------------------------------
task.spawn(function()
    local guiNames = {"HatchEggUI", "HatchAnimationGui", "HatchGui", "LastHatchGui", "EggHatchUI", "AutoDeleteUI", "HatchPopupUI"}
    while task.wait(0.3) do
        for _, n in ipairs(guiNames) do
            local g = playerGui:FindFirstChild(n)
            if g then
                g.Enabled = false
                g.Visible = false
            end
        end
    end
end)

task.spawn(function()
    local ok, err = pcall(function()
        local s = player:WaitForChild("PlayerScripts")
            :WaitForChild("Scripts")
            :WaitForChild("Game")
            :WaitForChild("Egg Opening Frontend")
        local env = getsenv(s)
        if env and env.PlayEggAnimation then
            env.PlayEggAnimation = function() return end
            print("[🎬] ปิดอนิเมชันสุ่มไข่แล้ว")
        end
    end)
    if not ok then warn("❌ ปิดอนิเมชันสุ่มไข่ล้มเหลว:", err) end
end)

------------------------------------------------------------
-- 🥚 ฟังก์ชันสุ่มไข่
------------------------------------------------------------
local function hatchEgg()
    pcall(function()
        remoteEvent:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
    end)
end

------------------------------------------------------------
-- 🔁 ลูปสุ่มไข่อัตโนมัติ
------------------------------------------------------------
local running = false
task.spawn(function()
    while task.wait(HATCH_DELAY) do
        if running then
            hatchEgg()
        end
    end
end)

------------------------------------------------------------
-- 💰 ระบบ Auto Chest (เก็บจากระยะไกล)
------------------------------------------------------------
local collectedChests = {}

-- ฟังก์ชันเก็บกล่องจากระยะไกล
local function collectChest(chest)
    if not chest or not chest.Parent then return end
    local lowerName = chest.Name:lower()

    -- ตรวจสอบชื่อว่าตรงกับในลิสต์มั้ย
    if not CHEST_LIST[lowerName] then return end

    -- Cooldown ป้องกันเก็บซ้ำ
    if collectedChests[chest] and tick() - collectedChests[chest] < CHEST_COLLECT_COOLDOWN then
        return
    end

    -- หา part ที่จะใช้ FireTouchInterest
    local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
    if trigger then
        firetouchinterest(hrp, trigger, 0)
        task.wait(0.2)
        firetouchinterest(hrp, trigger, 1)
        collectedChests[chest] = tick()
        print("[💰] เก็บ Chest สำเร็จ:", chest.Name)
    end
end

-- ลูปค้นหาและเก็บ
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

------------------------------------------------------------
-- ⌨️ ปุ่ม Toggle (J)
------------------------------------------------------------
UIS.InputBegan:Connect(function(input, typing)
    if typing then return end
    if input.KeyCode == Enum.KeyCode.J then
        running = not running
        warn(running and "[✅] เริ่มสุ่มไข่..." or "[⏸️] หยุดสุ่มไข่แล้ว")
    end
end)

------------------------------------------------------------
-- 🧭 GUI Interface
------------------------------------------------------------
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "InfinityHatchGUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.Size = UDim2.new(0, 220, 0, 110)
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
btn.Position = UDim2.new(0.1, 0, 0.45, 0)
btn.Size = UDim2.new(0.8, 0, 0.4, 0)
btn.Text = "เริ่มสุ่มไข่ 🔁"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundTransparency = 0.2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
    running = not running
    btn.Text = running and "หยุดสุ่ม ⏸️" or "เริ่มสุ่มไข่ 🔁"
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

------------------------------------------------------------
-- 💤 Anti AFK
------------------------------------------------------------
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

print("✅ NiTroHUB PRO - Infinity Hatch + AutoChest Loaded!")
