-- Source.lua
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- 🎨 Theme Presets
Library.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(25,25,25),
        PrimaryColor = Color3.fromRGB(0,170,255),
        SecondaryColor = Color3.fromRGB(40,40,40),
        TextColor = Color3.fromRGB(255,255,255),
        Font = Enum.Font.Gotham
    },
    Neon = {
        BackgroundColor = Color3.fromRGB(10,10,10),
        PrimaryColor = Color3.fromRGB(0,255,140),
        SecondaryColor = Color3.fromRGB(30,30,30),
        TextColor = Color3.fromRGB(0,255,200),
        Font = Enum.Font.Ubuntu
    }
}

Library.Theme = Library.Themes.Dark
Library.Settings = {}
Library.Tabs = {}

-- 🛠 Utility
local function ApplyStyle(obj, radius, color)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, radius or 8)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Thickness = 1
    stroke.Color = color or Color3.fromRGB(80,80,80)
    return obj
end

local function AddShadow(obj)
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1,20,1,20)
    shadow.Position = UDim2.new(0,-10,0,-10)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = obj.ZIndex - 1
    shadow.Parent = obj
end

-- 💾 Save / Load
function Library:SaveSettings(name)
    name = name or "MyUI"
    writefile(name..".json", HttpService:JSONEncode(self.Settings))
end

function Library:LoadSettings(name)
    name = name or "MyUI"
    if isfile(name..".json") then
        self.Settings = HttpService:JSONDecode(readfile(name..".json"))
        return self.Settings
    end
    return {}
end

-- 🪟 Window
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = title

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = self.Theme.BackgroundColor
    Main.ZIndex = 10
    ApplyStyle(Main, 10)
    AddShadow(Main)

    local Title = Instance.new("TextLabel", Main)
    Title.Text = title
    Title.Size = UDim2.new(1,0,0,35)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = self.Theme.TextColor
    Title.Font = self.Theme.Font
    Title.TextScaled = true

    -- Drag
    local dragging, dragStart, startPos
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    Title.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)

    local TabsFrame = Instance.new("Frame", Main)
    TabsFrame.Size = UDim2.new(0,120,1,-35)
    TabsFrame.Position = UDim2.new(0,0,0,35)
    TabsFrame.BackgroundColor3 = self.Theme.SecondaryColor
    ApplyStyle(TabsFrame, 10)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1,-120,1,-35)
    Pages.Position = UDim2.new(0,120,0,35)
    Pages.BackgroundTransparency = 1

    local ui = setmetatable({}, self)
    ui.Main, ui.Pages, ui.TabButtons = Main, Pages, TabsFrame
    return ui
end

-- 🖌 Change Theme
function Library:SetTheme(themeName, save)
    local theme = self.Themes[themeName]
    if theme then
        self.Theme = theme
        if save then
            self.Settings["SelectedTheme"] = themeName
            self:SaveSettings("MyUI")
        end
        for _,ui in pairs(self.Main.Parent:GetDescendants()) do
            if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                ui.TextColor3 = theme.TextColor
                ui.Font = theme.Font
            elseif ui:IsA("Frame") then
                if ui.BackgroundTransparency < 1 then
                    ui.BackgroundColor3 = theme.SecondaryColor
                end
            end
        end
        self.Main.BackgroundColor3 = theme.BackgroundColor
    end
end

-- 📑 Create Tab
function Library:CreateTab(name)
    local Btn = Instance.new("TextButton", self.TabButtons)
    Btn.Text = name
    Btn.Size = UDim2.new(1,0,0,35)
    Btn.BackgroundColor3 = self.Theme.PrimaryColor
    Btn.TextColor3 = self.Theme.TextColor
    Btn.Font = self.Theme.Font
    Btn.TextScaled = true
    ApplyStyle(Btn,8)

    local Page = Instance.new("ScrollingFrame", self.Pages)
    Page.Size = UDim2.new(1,0,1,0)
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.ScrollBarThickness = 4
    Page.Visible = false
    Page.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0,6)

    local tab = {Page=Page, Button=Btn}
    table.insert(self.Tabs, tab)

    Btn.MouseButton1Click:Connect(function()
        for _,t in pairs(self.Tabs) do t.Page.Visible=false end
        Page.Visible=true
    end)
    if #self.Tabs==1 then Page.Visible=true end

    return setmetatable(tab, {__index=self, Page=Page})
end

-- 🔘 Button
function Library:Button(text, callback)
    local Btn = Instance.new("TextButton", self.Page)
    Btn.Text = text
    Btn.Size = UDim2.new(1,-10,0,40)
    Btn.BackgroundColor3 = self.Theme.PrimaryColor
    Btn.TextColor3 = self.Theme.TextColor
    Btn.Font = self.Theme.Font
    Btn.TextScaled = true
    ApplyStyle(Btn,8)
    Btn.MouseButton1Click:Connect(callback)
end

-- 🔽 Theme Dropdown (Preview + Apply + Cancel)
function Library:ThemeDropdown(tab, text)
    local Frame = Instance.new("Frame", tab.Page)
    Frame.Size = UDim2.new(1,-10,0,40)
    Frame.BackgroundColor3 = self.Theme.SecondaryColor
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = text
    Label.Size = UDim2.new(0.4,0,1,0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = self.Theme.TextColor
    Label.Font = self.Theme.Font
    Label.TextScaled = true

    local DropBtn = Instance.new("TextButton", Frame)
    DropBtn.Text = self.Settings["SelectedTheme"] or "เลือกธีม"
    DropBtn.Size = UDim2.new(0.6,-5,1,-10)
    DropBtn.Position = UDim2.new(0.4,5,0,5)
    DropBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    DropBtn.TextColor3 = self.Theme.TextColor
    DropBtn.Font = self.Theme.Font
    DropBtn.TextScaled = true
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0,8)

    local DropFrame = Instance.new("Frame", Frame)
    DropFrame.Size = UDim2.new(0.6,-5,0,90)
    DropFrame.Position = UDim2.new(0.4,5,1,0)
    DropFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    DropFrame.Visible = false
    Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0,8)
    local UIList = Instance.new("UIListLayout", DropFrame)

    local savedTheme = self.Settings["SelectedTheme"] or "Dark"
    local previewTheme = savedTheme

    local function addOption(name)
        local opt = Instance.new("TextButton", DropFrame)
        opt.Size = UDim2.new(1,0,0,25)
        opt.Text = "▶ " .. name
        opt.BackgroundColor3 = Color3.fromRGB(70,70,70)
        opt.TextColor3 = self.Theme.TextColor
        opt.Font = self.Theme.Font
        opt.TextScaled = true
        Instance.new("UICorner", opt).CornerRadius = UDim.new(0,8)

        opt.MouseButton1Click:Connect(function()
            previewTheme = name
            DropBtn.Text = "Preview: " .. name
            self:SetTheme(name,false) -- Preview
        end)
    end

    for themeName,_ in pairs(self.Themes) do
        addOption(themeName)
    end

    DropBtn.MouseButton1Click:Connect(function()
        DropFrame.Visible = not DropFrame.Visible
    end)

    -- ✅ Apply
    local Confirm = Instance.new("TextButton", tab.Page)
    Confirm.Text = "✅ Apply Theme"
    Confirm.Size = UDim2.new(0.5,-5,0,35)
    Confirm.BackgroundColor3 = self.Theme.PrimaryColor
    Confirm.TextColor3 = self.Theme.TextColor
    Confirm.Font = self.Theme.Font
    Confirm.TextScaled = true
    Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,8)

    Confirm.MouseButton1Click:Connect(function()
        savedTheme = previewTheme
        self:SetTheme(savedTheme,true)
        DropBtn.Text = savedTheme
        print("🎨 Theme Applied and Saved:", savedTheme)
    end)

    -- ❌ Cancel
    local Cancel = Instance.new("TextButton", tab.Page)
    Cancel.Text = "❌ Cancel Preview"
    Cancel.Size = UDim2.new(0.5,-5,0,35)
    Cancel.Position = UDim2.new(0.5,5,Confirm.Position.Y.Scale,Confirm.Position.Y.Offset)
    Cancel.BackgroundColor3 = Color3.fromRGB(180,50,50)
    Cancel.TextColor3 = Color3.fromRGB(255,255,255)
    Cancel.Font = self.Theme.Font
    Cancel.TextScaled = true
    Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0,8)

    Cancel.MouseButton1Click:Connect(function()
        previewTheme = savedTheme
        self:SetTheme(savedTheme,false)
        DropBtn.Text = savedTheme
        print("↩️ Theme Reverted to:", savedTheme)
    end)

    if self.Settings["SelectedTheme"] then
        self:SetTheme(self.Settings["SelectedTheme"],false)
        DropBtn.Text = self.Settings["SelectedTheme"]
    end
end

return Library
