-- ===============================================================
-- 🌀 NatUI MegaScript (Test UI Version)
-- ===============================================================

local NatUI = {}
NatUI.__index = NatUI

-- ✅ Core GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NatUI"

-- ✅ Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Visible = false

-- ✅ Tab system
local TabButtons = Instance.new("Frame", Main)
TabButtons.Size = UDim2.new(0, 120, 1, 0)
TabButtons.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local TabContent = Instance.new("Frame", Main)
TabContent.Position = UDim2.new(0, 120, 0, 0)
TabContent.Size = UDim2.new(1, -120, 1, 0)
TabContent.BackgroundTransparency = 1

local Tabs = {}

-- ===============================================================
-- WINDOW
-- ===============================================================
function NatUI:Window(info)
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = info.Title or "NatUI Library"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
end

-- ===============================================================
-- OPEN UI
-- ===============================================================
function NatUI:OpenUI(info)
    local Btn = Instance.new("TextButton", ScreenGui)
    Btn.Size = UDim2.new(0, 130, 0, 40)
    Btn.Position = UDim2.new(0, 20, 0, 200)
    Btn.Text = info.Title or "Open UI"
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)
end

-- ===============================================================
-- ADD TAB
-- ===============================================================
function NatUI:AddTab(info)
    local Button = Instance.new("TextButton", TabButtons)
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.Text = info.Title or "Tab"
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    local TabPage = Instance.new("Frame", TabContent)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false

    Tabs[info.Title] = TabPage

    Button.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do tab.Visible = false end
        TabPage.Visible = true
    end)

    return TabPage
end

-- ===============================================================
-- SECTION
-- ===============================================================
function NatUI:Section(tab, info)
    local Label = Instance.new("TextLabel", tab)
    Label.Text = info.Title or "Section"
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
end

-- ===============================================================
-- BUTTON
-- ===============================================================
function NatUI:Button(tab, info)
    local Btn = Instance.new("TextButton", tab)
    Btn.Size = UDim2.new(0, 120, 0, 30)
    Btn.Text = info.Title or "Button"
    Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.MouseButton1Click:Connect(function()
        if info.Callback then info.Callback() end
    end)
end

-- ===============================================================
-- TOGGLE
-- ===============================================================
function NatUI:Toggle(tab, info)
    local Btn = Instance.new("TextButton", tab)
    Btn.Size = UDim2.new(0, 140, 0, 30)
    Btn.Text = "[OFF] " .. (info.Title or "Toggle")
    Btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = (state and "[ON] " or "[OFF] ") .. (info.Title or "Toggle")
        if info.Callback then info.Callback(state) end
    end)
end

-- ===============================================================
-- PARAGRAPH
-- ===============================================================
function NatUI:Paragraph(tab, info)
    local Text = Instance.new("TextLabel", tab)
    Text.Size = UDim2.new(1, -10, 0, 30)
    Text.Text = (info.Title or "") .. ": " .. (info.Desc or "")
    Text.TextColor3 = Color3.fromRGB(180, 180, 180)
    Text.BackgroundTransparency = 1
end

-- ===============================================================
-- SLIDER
-- ===============================================================
function NatUI:Slider(tab, info)
    local Frame = Instance.new("Frame", tab)
    Frame.Size = UDim2.new(0, 200, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

    local dragging = false
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local ratio = math.clamp((input.Position.X - Frame.AbsolutePosition.X) / Frame.AbsoluteSize.X, 0, 1)
            Bar.Size = UDim2.new(ratio, 0, 1, 0)
            local value = math.floor(ratio * (tonumber(info.MaxValue) or 100))
            if info.Callback then info.Callback(value) end
        end
    end)
end

-- ===============================================================
-- ✅ TEST UI EXAMPLE
-- ===============================================================
task.spawn(function()
    local ui = NatUI
    ui:Window({ Title = "NatUI Mega Test" })
    ui:OpenUI({ Title = "Open NatUI" })

    local Tab1 = ui:AddTab({ Title = "Main" })
    ui:Section(Tab1, { Title = "Main Section" })
    ui:Button(Tab1, { Title = "Click Me", Callback = function() print("Button Pressed") end })
    ui:Toggle(Tab1, { Title = "Enable Feature", Callback = function(s) print("Toggle:", s) end })
    ui:Paragraph(Tab1, { Title = "Info", Desc = "This is a paragraph" })
    ui:Slider(Tab1, { Title = "Volume", MaxValue = 100, Callback = function(v) print("Slider:", v) end })

    local Tab2 = ui:AddTab({ Title = "Second" })
    ui:Section(Tab2, { Title = "Second Section" })
    ui:Button(Tab2, { Title = "Another Btn", Callback = function() print("Another Button!") end })
end)

return NatUI
