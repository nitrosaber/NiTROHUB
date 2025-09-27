--// 🌀 Bubble Gum Simulator - Infinity Hatch (NiTroHUB PRO)
--// ✨ by NiTroHUB x ChatGPT

-- ⚙️ ตั้งค่าเริ่มต้น
local EGG_NAME = "Autumn Egg" -- เปลี่ยนชื่อไข่ที่ต้องการ
local HATCH_AMOUNT = 8        -- จำนวนที่สุ่มต่อครั้ง (1 / 3 / 8)
local HATCH_DELAY = 0.05      -- เวลาหน่วงระหว่างสุ่ม (ไวขึ้น)

-- 📦 อ้างอิง Remote Event
local remoteEvent = game:GetService("ReplicatedStorage")
    :WaitForChild("Shared", 5)
    :WaitForChild("Framework", 5)
    :WaitForChild("Network", 5)
    :WaitForChild("Remote", 5)
    :WaitForChild("RemoteEvent", 5)

local player = game.Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui", 5)

--------------------------------------------------------------------
-- 🕵️ ปิด / ซ่อน GUI การสุ่ม (แบบสมบูรณ์)
--------------------------------------------------------------------
task.spawn(function()
    local guiNames = {
        "HatchEggUI", "HatchAnimationGui", "HatchGui", "LastHatchGui",
        "EggHatchUI", "AutoDeleteUI", "HatchPopupUI"
    }
    while task.wait(0.2) do
        for _, name in ipairs(guiNames) do
            local gui = playerGui:FindFirstChild(name)
            if gui and gui:IsA("ScreenGui") then
                gui.Enabled = false
            end
        end
    end
end)

-- 🧩 ปิด Render อนิเมชันที่ Spawn ใหม่
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ScreenGui") then
        if string.find(obj.Name:lower(), "hatch") or string.find(obj.Name:lower(), "egg") then
            obj.Enabled = false
        end
    end
end)

--------------------------------------------------------------------
-- 🎯 ฟังก์ชันสุ่มไข่
--------------------------------------------------------------------
local function hatchEgg()
    if remoteEvent then
        local args = {"HatchEgg", EGG_NAME, HATCH_AMOUNT}
        remoteEvent:FireServer(unpack(args))
    end
end

--------------------------------------------------------------------
-- 🔁 ลูปสุ่มอัตโนมัติ
--------------------------------------------------------------------
local running = false
task.spawn(function()
    while true do
        if running then
            hatchEgg()
        end
        task.wait(HATCH_DELAY)
    end
end)

--------------------------------------------------------------------
-- ⌨️ Toggle ด้วยปุ่ม J
--------------------------------------------------------------------
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, isTyping)
    if isTyping or not input.KeyCode then return end
    if input.KeyCode == Enum.KeyCode.J then
        running = not running
        print(running and "[✅] เริ่มสุ่มไข่..." or "[⏸️] หยุดสุ่มไข่แล้ว")
    end
end)

--------------------------------------------------------------------
-- 🧭 GUI หลัก (ปรับปรุงให้ทันสมัย)
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "InfinityHatchGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- 🎛️ กรอบหลัก
local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(15, 20, 40) -- โทนน้ำเงินเข้ม
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 250, 0, 150) -- ขยายขนาดให้ใหญ่ขึ้น
Frame.Active = true
Frame.Draggable = true

-- เพิ่ม Gradient Background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 20, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
}
Gradient.Parent = Frame

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 150, 255) -- สีเน้นแบบนีออน
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 🏷️ Title
local Title = Instance.new("TextLabel", Frame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🌀 Infinity Hatch v2.0"
Title.TextColor3 = Color3.fromRGB(0, 200, 255) -- สีฟ้าเน้น
Title.TextSize = 18
Title.TextStrokeTransparency = 0.5
Title.TextStrokeColor3 = Color3.fromRGB(0, 100, 200)

-- 🔘 ปุ่มสลับสถานะ
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Position = UDim2.new(0.1, 0, 0.55, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

-- เพิ่ม Gradient ให้ปุ่ม
local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
}
ButtonGradient.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        ToggleButton.Text = "หยุดสุ่ม ⏸️"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
        }
    else
        ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        ButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
        }
    end
end)

--------------------------------------------------------------------
-- 🧿 ปุ่มไอคอนเล็ก (ปรับปรุงให้ทันสมัย)
--------------------------------------------------------------------
local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 50, 0, 50) -- ขยายขนาดไอคอน
ToggleIcon.Position = UDim2.new(0.02, 0, 0.7, 0)
ToggleIcon.Text = "🌌" -- เปลี่ยนไอคอนเป็นสัญลักษณ์ดาวกาแล็กซี่
ToggleIcon.Font = Enum.Font.SourceSansBold
ToggleIcon.TextSize = 28
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
ToggleIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
ToggleIcon.Draggable = true

-- เพิ่ม Gradient ให้ไอคอน
local IconGradient = Instance.new("UIGradient")
IconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
}
IconGradient.Parent = ToggleIcon

Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", ToggleIcon)
IconStroke.Color = Color3.fromRGB(0, 200, 255)
IconStroke.Thickness = 2

-- 🏷️ Tooltip NiTroHUB
local Tooltip = Instance.new("TextLabel", ToggleIcon)
Tooltip.Size = UDim2.new(0, 120, 0, 30)
Tooltip.Position = UDim2.new(1, 5, 0.25, 0)
Tooltip.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
Tooltip.TextColor3 = Color3.fromRGB(0, 200, 255)
Tooltip.Text = "NiTroHUB v2.0"
Tooltip.Font = Enum.Font.SourceSansBold
Tooltip.TextSize = 16
Tooltip.Visible = false
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
-- 💤 Anti AFK (ป้องกันหลุด)
--------------------------------------------------------------------
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        print("[🛡️] Anti AFK ทำงานแล้ว!")
    end)
end)

print("✅ โหลด NiTroHUB เรียบร้อย! ใช้ปุ่ม J หรือปุ่ม GUI เพื่อเปิด/ปิดการสุ่มไข่")
