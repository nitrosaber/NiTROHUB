--// 🌀 Bubble Gum Simulator - Infinity Hatch (NiTroHUB PRO)
--// ✨ by NiTroHUB x ChatGPT

-- ⚙️ ตั้งค่าเริ่มต้น
local EGG_NAME = "Autumn Egg" -- เปลี่ยนชื่อไข่ที่ต้องการ
local HATCH_AMOUNT = 8        -- จำนวนที่สุ่มต่อครั้ง (1 / 3 / 8)
local HATCH_DELAY = 0.001      -- เวลาหน่วงระหว่างสุ่ม (ไวขึ้น)

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
            task.wait(0.1)
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
-- 🧭 GUI หลัก (เวอร์ชันอนาคต:  gradient, neon glow, animations)
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "InfinityHatchGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- 🎛️ กรอบหลัก
local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- พื้นฐานดำสำหรับ gradient
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.BackgroundTransparency = 0.1  -- กึ่งโปร่งใสแบบ holographic

-- Gradient สำหรับพื้นหลัง futuristic
local FrameGradient = Instance.new("UIGradient", Frame)
FrameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),  -- Neon Cyan
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))   -- Neon Purple
}
FrameGradient.Rotation = 45

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)  -- โค้งมนกว่า

-- Neon Glow Stroke
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 255, 255)  -- Neon Cyan
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3  -- Glow effect
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 🏷️ Title
local Title = Instance.new("TextLabel", Frame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌀 Infinity Hatch"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextStrokeTransparency = 0.8  -- เพิ่ม stroke สำหรับ glow

-- Gradient สำหรับ Title
local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
}

-- 🔘 ปุ่มสลับสถานะ
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.35, 0)
ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.BackgroundTransparency = 0.2

-- Gradient สำหรับปุ่ม
local ButtonGradient = Instance.new("UIGradient", ToggleButton)
ButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 115, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 115))
}
ButtonGradient.Rotation = 45

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

-- Neon Stroke สำหรับปุ่ม
local ButtonStroke = Instance.new("UIStroke", ToggleButton)
ButtonStroke.Color = Color3.fromRGB(255, 115, 0)
ButtonStroke.Thickness = 1.5
ButtonStroke.Transparency = 0.4

-- Animation สำหรับ hover (scale up)
local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleButton, hoverTweenInfo, {Size = UDim2.new(0.85, 0, 0.4, 0)}):Play()
    TweenService:Create(ButtonStroke, hoverTweenInfo, {Color = Color3.fromRGB(0, 255, 255)}):Play()
end)
ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleButton, hoverTweenInfo, {Size = UDim2.new(0.8, 0, 0.35, 0)}):Play()
    TweenService:Create(ButtonStroke, hoverTweenInfo, {Color = Color3.fromRGB(255, 115, 0)}):Play()
end)

ToggleButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        ToggleButton.Text = "หยุดสุ่ม ⏸️"
        ButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
        }
        ButtonStroke.Color = Color3.fromRGB(200, 50, 50)
    else
        ToggleButton.Text = "เริ่มสุ่มไข่ 🔁"
        ButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 115, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 115))
        }
        ButtonStroke.Color = Color3.fromRGB(255, 115, 0)
    end
end)

--------------------------------------------------------------------
-- 🧿 ปุ่มไอคอนเล็ก (เวอร์ชันอนาคต: neon, glow, animation)
--------------------------------------------------------------------
local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 50, 0, 50)  -- ขนาดใหญ่ขึ้นเล็กน้อย
ToggleIcon.Position = UDim2.new(0.02, 0, 0.7, 0)
ToggleIcon.Text = "🌀"
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 28
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleIcon.TextColor3 = Color3.fromRGB(0, 255, 255)  -- Neon Cyan
ToggleIcon.Draggable = true
ToggleIcon.BackgroundTransparency = 0.3

-- Gradient สำหรับไอคอน
local IconGradient = Instance.new("UIGradient", ToggleIcon)
IconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 128, 255))
}
IconGradient.Rotation = 90

Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)  -- วงกลมเต็ม

-- Neon Glow Stroke
local IconStroke = Instance.new("UIStroke", ToggleIcon)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.2

-- Animation สำหรับ hover (rotate and glow)
ToggleIcon.MouseEnter:Connect(function()
    TweenService:Create(IconGradient, hoverTweenInfo, {Rotation = 180}):Play()
    TweenService:Create(IconStroke, hoverTweenInfo, {Transparency = 0}):Play()
end)
ToggleIcon.MouseLeave:Connect(function()
    TweenService:Create(IconGradient, hoverTweenInfo, {Rotation = 90}):Play()
    TweenService:Create(IconStroke, hoverTweenInfo, {Transparency = 0.2}):Play()
end)

-- 🏷️ Tooltip NiTroHUB (เวอร์ชันอนาคต)
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

-- Gradient สำหรับ Tooltip
local TooltipGradient = Instance.new("UIGradient", Tooltip)
TooltipGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
}

Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 8)

-- Stroke สำหรับ Tooltip
local TooltipStroke = Instance.new("UIStroke", Tooltip)
TooltipStroke.Color = Color3.fromRGB(0, 255, 255)
TooltipStroke.Thickness = 1
TooltipStroke.Transparency = 0.5

ToggleIcon.MouseEnter:Connect(function()
    Tooltip.Visible = true
end)
ToggleIcon.MouseLeave:Connect(function()
    Tooltip.Visible = false
end)

ToggleIcon.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    -- Animation สำหรับเปิด/ปิด Frame
    if Frame.Visible then
        TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1, Size = UDim2.new(0, 200, 0, 100)}):Play()
    else
        TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        Frame.Visible = false  -- ซ่อนจริงหลัง animation
    end
end)

--------------------------------------------------------------------
-- 💤 Anti AFK (ป้องกันหลุด)
--------------------------------------------------------------------
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        print("[🛡️] Anti AFK ทำงานแล้ว!")
    end)
end)

print("✅ โหลด NiTroHUB เรียบร้อย! ใช้ปุ่ม J หรือปุ่ม GUI เพื่อเปิด/ปิดการสุ่มไข่")
