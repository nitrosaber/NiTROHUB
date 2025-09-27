--// 🌀 Bubble Gum Simulator - Infinity Hatch (Advanced GUI Version)
--// ✨ by nitro

-- ⚙️ ตั้งค่าเริ่มต้น
local EGG_NAME = "Autumn Egg" -- เปลี่ยนชื่อไข่ตรงนี้
local HATCH_AMOUNT = 8         -- จำนวนการสุ่มต่อครั้ง (1, 3, 8)
local HATCH_DELAY = 0.01        -- หน่วงเวลาแต่ละรอบสุ่ม (ไวขึ้น)

-- 📦 อ้างอิง Remote Event
local remoteEvent = game:GetService("ReplicatedStorage")
    :WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------
-- 🕵️ ปิด / ซ่อน GUI การสุ่ม (ถาวร)
--------------------------------------------------------------------
task.spawn(function()
    local guiNames = {"HatchEggUI", "HatchAnimationGui", "HatchGui", "LastHatchGui"}
    while task.wait(0.5) do
        for _, name in ipairs(guiNames) do
            local gui = playerGui:FindFirstChild(name)
            if gui then
                gui.Enabled = false
                gui.Visible = false
            end
        end
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
-- 🔁 ลูปสุ่มอัตโนมัติ
--------------------------------------------------------------------
local running = false
task.spawn(function()
    while true do
        if running then
            hatchEgg()
            task.wait(HATCH_DELAY)
        else
            task.wait(0.01)
        end
    end
end)

--------------------------------------------------------------------
-- ⌨️ Toggle ด้วยปุ่ม J
--------------------------------------------------------------------
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then
        running = not running
        print(running and "[✅] เริ่มสุ่มไข่..." or "[⏸️] หยุดสุ่มไข่แล้ว")
    end
end)

--------------------------------------------------------------------
-- 🧭 GUI หลัก
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "InfinityHatchGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- 🎛️ กรอบหลัก
local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(255, 165, 0)
UIStroke.Thickness = 2

-- 🏷️ Title
local Title = Instance.new("TextLabel", Frame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌀 Infinity Hatch"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16

-- 🔘 ปุ่มสลับสถานะ
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.35, 0)
ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 115, 0)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)

ToggleButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        ToggleButton.Text = "หยุดสุ่ม ⏸️"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 115, 0)
    end
end)

--------------------------------------------------------------------
-- 🧿 ปุ่มไอคอนเล็ก (เปิด / ปิด GUI)
--------------------------------------------------------------------
local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 40, 0, 40)
ToggleIcon.Position = UDim2.new(0.02, 0, 0.7, 0)
ToggleIcon.Text = "🌀"
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 24
ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
ToggleIcon.TextColor3 = Color3.new(1, 1, 1)
ToggleIcon.Draggable = true
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

ToggleIcon.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

print("✅ โหลด GUI เรียบร้อย! ใช้ปุ่ม J หรือปุ่มใน GUI เพื่อเปิด/ปิดการสุ่ม")
