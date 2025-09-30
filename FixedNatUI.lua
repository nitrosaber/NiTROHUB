-- ===============================================================
-- ✅ NatUI Library (Fixed Version by ChatGPT)
-- ===============================================================

local NatUI = {}
NatUI.__index = NatUI

-- เก็บโครงสร้าง UI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NatUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- เปิด/ปิด UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- เก็บ Tab / Elements
local TabContainer = Instance.new("Folder", MainFrame)
TabContainer.Name = "Tabs"

-- ===============================================================
-- 🪟 Create Window
-- ===============================================================
function NatUI:Window(data)
    MainFrame.Visible = true
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = data.Title or "NatUI Window"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
end

-- ===============================================================
-- 🎛️ Open UI Toggle Button
-- ===============================================================
function NatUI:OpenUI(data)
    local Button = Instance.new("TextButton")
    Button.Name = "OpenButton"
    Button.Text = data.Title or "OpenUI"
    Button.Size = UDim2.new(0, 120, 0, 40)
    Button.Position = UDim2.new(0, 20, 0, 20)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = ScreenGui

    Button.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end

-- ===============================================================
-- 🗂️ Add Tab
-- ===============================================================
function NatUI:AddTab(data)
    local Tab = Instance.new("Frame", TabContainer)
    Tab.Name = data.Title or "Tab"
    Tab.Size = UDim2.new(1, 0, 1, -40)
    Tab.Position = UDim2.new(0, 0, 0, 40)
    Tab.Visible = false

    local TabLabel = Instance.new("TextLabel", Tab)
    TabLabel.Text = (data.Desc or data.Title) or "Tab"
    TabLabel.Size = UDim2.new(1, 0, 0, 30)
    TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Font = Enum.Font.SourceSans
    TabLabel.TextSize = 18

    return Tab
end

-- ===============================================================
-- ➕ Section
-- ===============================================================
function NatUI:Section(data)
    local Section = Instance.new("Frame", MainFrame)
    Section.Name = data.Title or "Section"
    Section.Size = UDim2.new(1, -20, 0, 30)
    Section.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Section)
    Label.Text = data.Title or "Section"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 18
end

-- ===============================================================
-- 🔘 Button
-- ===============================================================
function NatUI:Button(data)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Text = data.Title or "Button"
    Btn.Size = UDim2.new(0, 120, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 16

    Btn.MouseButton1Click:Connect(function()
        if data.Callback then data.Callback() end
    end)
end

-- ===============================================================
-- 🔀 Toggle
-- ===============================================================
function NatUI:Toggle(data)
    local ToggleBtn = Instance.new("TextButton", MainFrame)
    ToggleBtn.Text = "[OFF] " .. (data.Title or "Toggle")
    ToggleBtn.Size = UDim2.new(0, 140, 0, 30)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = (state and "[ON] " or "[OFF] ") .. (data.Title or "Toggle")
        if data.Callback then data.Callback(state) end
    end)
end

-- ===============================================================
-- 📝 Paragraph
-- ===============================================================
function NatUI:Paragraph(data)
    local Text = Instance.new("TextLabel", MainFrame)
    Text.Text = (data.Title or "") .. ": " .. (data.Desc or "")
    Text.Size = UDim2.new(1, -20, 0, 25)
    Text.TextColor3 = Color3.fromRGB(200, 200, 200)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.SourceSans
    Text.TextSize = 16
end

-- ===============================================================
-- 📏 Slider (basic)
-- ===============================================================
function NatUI:Slider(data)
    local SliderFrame = Instance.new("Frame", MainFrame)
    SliderFrame.Size = UDim2.new(0, 200, 0, 30)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local Bar = Instance.new("Frame", SliderFrame)
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

    local dragging = false
    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    SliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local ratio = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
            Bar.Size = UDim2.new(ratio, 0, 1, 0)
            local value = math.floor(ratio * (tonumber(data.MaxValue) or 100))
            if data.Callback then data.Callback(value) end
        end
    end)
end

return NatUI
