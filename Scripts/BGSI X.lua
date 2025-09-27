--// 🌀 Bubble Gum Simulator - Infinity Hatch + Auto Chest (สมบูรณ์แบบ)
--// ✨ by NiTroHUB x ChatGPT

-- ⚙️ ตั้งค่าเริ่มต้น
local EGG_NAME = "Autumn Egg"    -- เปลี่ยนชื่อไข่ที่ต้องการ
local HATCH_AMOUNT = 8           -- จำนวนสุ่มไข่ต่อครั้ง (1 / 3 / 8)
local HATCH_DELAY = 0.001        -- หน่วงเวลาระหว่างการสุ่ม
local CHEST_CHECK_INTERVAL = 5   -- วินาทีตรวจ Chest ใหม่
local CHEST_COLLECT_COOLDOWN = 60  -- วินาทีรอ Chest เก็บซ้ำ (ถ้าเกมมีคูลดาวน์)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()

-- RemoteEvent (อ้างอิงตามโครงสร้างที่เคยใช้)
local remoteEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

--------------------------------------------------------------------
-- 🕵️ ซ่อน GUI การสุ่มเดิม (แบบถาวร)
--------------------------------------------------------------------
task.spawn(function()
    local guiNames = {
        "HatchEggUI", "HatchAnimationGui", "HatchGui", "LastHatchGui",
        "EggHatchUI", "AutoDeleteUI", "HatchPopupUI"
    }
    while task.wait(0.3) do
        for _, name in ipairs(guiNames) do
            local gui = playerGui:FindFirstChild(name)
            if gui then
                gui.Enabled = false
                gui.Visible = false
            end
        end
    end
end)

-- ปิดอนิเมชันสุ่มไข่
task.spawn(function()
    local success, err = pcall(function()
        local EggsScript = player:WaitForChild("PlayerScripts")
            :WaitForChild("Scripts")
            :WaitForChild("Game")
            :WaitForChild("Egg Opening Frontend")
        local env = getsenv(EggsScript)
        if env and env.PlayEggAnimation then
            env.PlayEggAnimation = function(...) return end
            print("[🎬] ปิดอนิเมชันสุ่มไข่เรียบร้อย")
        end
    end)
    if not success then
        warn("[❌] ปิดอนิเมชันสุ่มไข่ล้มเหลว:", err)
    end
end)

--------------------------------------------------------------------
-- 🎯 ฟังก์ชันสุ่มไข่
--------------------------------------------------------------------
local function hatchEgg()
    local args = {"HatchEgg", EGG_NAME, HATCH_AMOUNT}
    remoteEvent:FireServer(unpack(args))
end

--------------------------------------------------------------------
-- 🔁 ลูปสุ่มไข่อัตโนมัติ
--------------------------------------------------------------------
local running = false
task.spawn(function()
    while true do
        if running then
            pcall(hatchEgg)
            task.wait(HATCH_DELAY)
        else
            task.wait(0.1)
        end
    end
end)

--------------------------------------------------------------------
-- 💰 ระบบ Auto Chest
--------------------------------------------------------------------
-- ตารางเก็บ Chest ที่เคยเก็บ ไปแล้ว (เพื่อหลีกเลี่ยงการเก็บซ้ำทันที)
local collectedChests = {}

local function tryCollectChest(chest)
    -- ตรวจให้แน่ใจว่า chest มีส่วน “TouchTrigger” หรือส่วนที่สามารถเก็บได้
    local touchPart = chest:FindFirstChild("TouchTrigger")
    if not touchPart then return false end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local dist = (hrp.Position - touchPart.Position).magnitude
    local MAX_DIST = 50  -- ปรับระยะที่สามารถเก็บได้

    if dist <= MAX_DIST then
        -- ตรวจว่าเก็บไปแล้วหรือไม่
        if collectedChests[chest] then
            -- ถ้าคูลดาวน์เก็บซ้ำ (ถ้ามี) ตรวจเวลา
            local lastTime = collectedChests[chest]
            if tick() - lastTime < CHEST_COLLECT_COOLDOWN then
                return false
            end
        end

        -- ทำ Touch เพื่อเก็บ
        firetouchinterest(hrp, touchPart, 0)
        task.wait(0.2)
        firetouchinterest(hrp, touchPart, 1)

        collectedChests[chest] = tick()
        print("[💰] เก็บ Chest:", chest.Name)
        return true
    end

    return false
end

-- ไล่ค้น Chest ทุก ๆ ช่วงเวลา
task.spawn(function()
    while true do
        task.wait(CHEST_CHECK_INTERVAL)
        -- ตรวจใน Workspace / กล่องที่ชื่อ “Chests” / ชื่ออื่น ๆ
        local possibleContainers = {workspace, workspace:FindFirstChild("Chests")}

        for _, container in ipairs(possibleContainers) do
            if container then
                for _, obj in ipairs(container:GetDescendants()) do
                    if obj:IsA("Model") then
                        -- เงื่อนไขให้เลือกเฉพาะโมเดลที่น่าจะเป็น Chest
                        local nameLower = obj.Name:lower()
                        if nameLower:find("chest") or nameLower:find("box") or nameLower:find("crate") then
                            pcall(tryCollectChest, obj)
                        end
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------
-- ⌨️ Toggle ด้วยปุ่ม J
--------------------------------------------------------------------
UIS.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then
        running = not running
        warn(running and "[✅] เริ่มสุ่มไข่..." or "[⏸️] หยุดสุ่มไข่แล้ว")
    end
end)

--------------------------------------------------------------------
-- 🧭 GUI หลัก
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHatchGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundTransparency = 0.1

do
    local grad = Instance.new("UIGradient", Frame)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
    }
    grad.Rotation = 45
end

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3

local Title = Instance.new("TextLabel", Frame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌀 Infinity Hatch"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
do
    local tg = Instance.new("UIGradient", Title)
    tg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    }
end

local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.35, 0)
ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.BackgroundTransparency = 0.2
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

do
    local bg = Instance.new("UIGradient", ToggleButton)
    bg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 115, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 115))
    }
    bg.Rotation = 45
end

local ButtonStroke = Instance.new("UIStroke", ToggleButton)
ButtonStroke.Color = Color3.fromRGB(255, 115, 0)
ButtonStroke.Thickness = 1.5
ButtonStroke.Transparency = 0.4

ToggleButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        ToggleButton.Text = "หยุดสุ่ม ⏸️"
        -- ปรับสีหรือ gradient เมื่อทำงาน
    else
        ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
    end
end)

--------------------------------------------------------------------
-- 🧿 ปุ่มไอคอนเล็ก + Tooltip NiTroHUB
--------------------------------------------------------------------
local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 50, 0, 50)
ToggleIcon.Position = UDim2.new(0.02, 0, 0.7, 0)
ToggleIcon.Text = "🌀"
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 28
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleIcon.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleIcon.Draggable = true
ToggleIcon.BackgroundTransparency = 0.3
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local Tooltip = Instance.new("TextLabel", ToggleIcon)
Tooltip.Size = UDim2.new(0, 120, 0, 30)
Tooltip.Position = UDim2.new(1, 5, 0.25, 0)
Tooltip.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Tooltip.TextColor3 = Color3.fromRGB(0, 255, 255)
Tooltip.Text = "NiTroHUB PRO"
Tooltip.Font = Enum.Font.GothamBold
Tooltip.TextSize = 14
Tooltip.Visible = false
Tooltip.BackgroundTransparency = 0.2
Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 8)

ToggleIcon.MouseEnter:Connect(function()
    Tooltip.Visible = true
end)
ToggleIcon.MouseLeave:Connect(function()
    Tooltip.Visible = false
end)
ToggleIcon.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

--------------------------------------------------------------------
-- 💤 Anti AFK
--------------------------------------------------------------------
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

print("✅ NiTroHUB PRO + AutoChest Loaded! ใช้ J หรือปุ่ม GUI 🌀 เพื่อควบคุม")
