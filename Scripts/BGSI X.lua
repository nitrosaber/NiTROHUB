--// 🌀 Bubble Gum Simulator - Infinity Hatch (AppleBlox UI Edition)
--// ✨ by NiTroHUB x ChatGPT

-- ⚙️ ตั้งค่าเริ่มต้น
local EGG_NAME = "Autumn Egg" -- เปลี่ยนชื่อไข่ที่ต้องการ
local HATCH_AMOUNT = 8        -- จำนวนที่สุ่มต่อครั้ง (1 / 3 / 8)
local HATCH_DELAY = 0.05      -- เวลาหน่วงระหว่างสุ่ม (ไวขึ้น)

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
            if gui and gui:IsA("ScreenGui") then
                gui.Enabled = false -- ใช้ Enabled แทน Visible
            end
        end
    end
end)

-- 🧩 ปิด Render อนิเมชันที่ Spawn ใหม่
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ScreenGui") then
        if string.find(obj.Name:lower(), "hatch") or string.find(obj.Name:lower(), "egg") then
            obj.Enabled = false -- ใช้ Enabled แทน Visible
        end
    end
end)

--------------------------------------------------------------------
-- 🎯 ฟังก์ชันสุ่มไข่
--------------------------------------------------------------------
local function hatchEgg()
    local args = {"HatchEgg", EGG_NAME, HATCH_AMOUNT}
    pcall(function() -- เพิ่ม pcall เพื่อป้องกันข้อผิดพลาด
        remoteEvent:FireServer(unpack(args))
    end)
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
-- 🎨 GUI หลัก สไตล์ AppleBlox
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "InfinityHatchUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 220)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("TextLabel", MainFrame)
Header.Text = "🌀 NiTroHUB Infinity Hatch"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.TextColor3 = Color3.fromRGB(255, 85, 85)
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0, 20, 0, 15)
Header.Size = UDim2.new(1, -40, 0, 25)
Header.TextXAlignment = Enum.TextXAlignment.Left

-- เส้นคั่น
local Line = Instance.new("Frame", MainFrame)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Line.Position = UDim2.new(0, 15, 0, 50)
Line.Size = UDim2.new(1, -30, 0, 1)

-- Info
local Info = Instance.new("TextLabel", MainFrame)
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(0, 20, 0, 60)
Info.Size = UDim2.new(1, -40, 0, 60)
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(220, 220, 220)
Info.TextSize = 14
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = "• Egg: "..EGG_NAME.."\n• Amount: "..HATCH_AMOUNT.." eggs / hatch\n• Delay: "..HATCH_DELAY.."s"

-- ปุ่ม Toggle
local HatchBtn = Instance.new("TextButton", MainFrame)
HatchBtn.Position = UDim2.new(0, 20, 0, 130)
HatchBtn.Size = UDim2.new(0, 340, 0, 35)
HatchBtn.BackgroundColor3 = Color3.fromRGB(255, 115, 0)
HatchBtn.TextColor3 = Color3.new(1, 1, 1)
HatchBtn.Font = Enum.Font.GothamBold
HatchBtn.Text = "เริ่มสุ่มไข่ 🔁"
HatchBtn.TextSize = 14
Instance.new("UICorner", HatchBtn).CornerRadius = UDim.new(0, 6)

HatchBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        HatchBtn.Text = "หยุดสุ่ม ⏸️"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        HatchBtn.Text = "เริ่มสุ่มไข่ 🔁"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(255, 115, 0)
    end
end)

-- ปุ่ม Close
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

--------------------------------------------------------------------
-- 🧿 ปุ่มไอคอนเล็ก + Hover "NiTroHUB"
--------------------------------------------------------------------
local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
ToggleIcon.Position = UDim2.new(0.02, 0, 0.7, 0)
ToggleIcon.Text = "🌀"
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 22
ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
ToggleIcon.TextColor3 = Color3.new(1, 1, 1)
ToggleIcon.Draggable = true
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local Tooltip = Instance.new("TextLabel", ToggleIcon)
Tooltip.Size = UDim2.new(0, 100, 0, 25)
Tooltip.Position = UDim2.new(1, 5, 0.25, 0)
Tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Tooltip.TextColor3 = Color3.new(1, 1, 1)
Tooltip.Text = "NiTroHUB"
Tooltip.Font = Enum.Font.GothamBold
Tooltip.TextSize = 14
Tooltip.Visible = false
Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 6)

ToggleIcon.MouseEnter:Connect(function() Tooltip.Visible = true end)
ToggleIcon.MouseLeave:Connect(function() Tooltip.Visible = false end)
ToggleIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------
-- 💤 Anti AFK
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

print("✅ โหลด NiTroHUB AppleBlox UI สำเร็จ! ใช้ปุ่ม J หรือ GUI เพื่อเปิด/ปิด")
