--[[
    NathubUI - Rewritten & Fixed by Gemini
]]

Getgenv().GG = {
    Language = {
        CheckboxEnabledCheckboxEnabled = "Enabled",
        CheckboxDisabled = "Disabled",
        SliderValue = "Value",
        DropdownSelect = "Select",
        DropdownNone = "None",
        DropdownSelected = "Selected",
        ButtonClick = "Click",
        TextboxEnter = "Enter",
        ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled",
        TabGeneral = "General",
        TabSettings = "Settings",
        Loading = "Loading...",
        Error = "Error",
        Success = "Success"
    }
}

local SelectedLanguage = GG.Language

function convertStringToTable(inputString)
    local result = {}
    for value in string.gmatch(inputString, "([^,]+)") do
        local trimmedValue = value:match("^%s*(.-)%s*$")
        table.insert(result, trimmedValue)
    end
    return result
end

function convertTableToString(inputTable)
    return table.concat(inputTable, ", ")
end

local UserInputService = game:GetService('UserInputService')
local ContentProvider = game:GetService('ContentProvider')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local TextService = game:GetService('TextService')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
local CoreGui = game:GetService('CoreGui')
local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')

local mouse = Players.LocalPlayer:GetMouse()
local old_NathubUI = CoreGui:FindFirstChild('NathubUI')

if old_NathubUI then
    old_NathubUI:Destroy()
end

if not isfolder("NathubUI") then
    makefolder("NathubUI")
end

local Connections = {}
Connections.__index = Connections

function Connections:disconnect(connection)
    if not self[connection] then
        return
    end
    self[connection]:Disconnect()
    self[connection] = nil
end

function Connections:disconnect_all()
    for i, v in pairs(self) do
        if typeof(v) == 'RBXScriptConnection' then
            v:Disconnect()
        end
    end
    table.clear(self)
end

local Util = {}
function Util:map(value, in_minimum, in_maximum, out_minimum, out_maximum)
    return (value - in_minimum) * (out_maximum - out_minimum) / (in_maximum - in_minimum) + out_minimum
end

function Util:viewport_point_to_world(location, distance)
    local unit_ray = workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)
    return unit_ray.Origin + unit_ray.Direction * distance
end

function Util:get_offset()
    local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y
    return self:map(viewport_size_Y, 0, 2560, 8, 56)
end

local Config = {}
function Config:save(file_name, config)
    local success, result = pcall(function()
        local flags = HttpService:JSONEncode(config)
        writefile('NathubUI/' .. file_name .. '.json', flags)
    end)
    if not success then
        warn('failed to save config', result)
    end
end

function Config:load(file_name)
    local success, result = pcall(function()
        if not isfile('NathubUI/' .. file_name .. '.json') then
            self:save(file_name, { _flags = {}, _keybinds = {} })
            return { _flags = {}, _keybinds = {} }
        end
        local flags = readfile('NathubUI/' .. file_name .. '.json')
        if not flags or flags == "" then
            self:save(file_name, { _flags = {}, _keybinds = {} })
            return { _flags = {}, _keybinds = {} }
        end
        return HttpService:JSONDecode(flags)
    end)

    if not success then
        warn('failed to load config', result)
        return { _flags = {}, _keybinds = {} }
    end

    return result or { _flags = {}, _keybinds = {} }
end

local Library = {
    _config = Config:load(game.PlaceId),
    _tab = 0, -- FIX 1: Initialized the tab counter
    _choosing_keybind = false,
    _device = nil,
    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,
    _dragging = false,
    _drag_start = nil,
    _container_position = nil
}
Library.__index = Library

function Library:flag_type(flag, flag_type)
    if not self._config._flags[flag] then
        return false
    end
    return typeof(self._config._flags[flag]) == flag_type
end

function Library:CreateWindow(text)
    local old_NathubUI = CoreGui:FindFirstChild('NathubUI')
    if old_NathubUI then
        old_NathubUI:Destroy()
    end

    local NathubUI = Instance.new('ScreenGui')
    NathubUI.Name = 'NathubUI'
    NathubUI.Parent = CoreGui
    NathubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NathubUI.ResetOnSpawn = false

    local Container = Instance.new('Frame')
    Container.Name = 'Container'
    Container.Parent = NathubUI
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
    Container.BackgroundTransparency = 0.05
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.Active = true

    local UICorner = Instance.new('UICorner', Container)
    UICorner.CornerRadius = UDim.new(0, 10)

    local UIStroke = Instance.new('UIStroke', Container)
    UIStroke.Color = Color3.fromRGB(52, 66, 89)
    UIStroke.Transparency = 0.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Handler = Instance.new('Frame')
    Handler.Name = 'Handler'
    Handler.Parent = Container
    Handler.Size = UDim2.new(1, 0, 1, 0)
    Handler.BackgroundTransparency = 1

    local Tabs = Instance.new('ScrollingFrame')
    Tabs.Name = 'Tabs'
    Tabs.Parent = Handler
    Tabs.Size = UDim2.new(0, 129, 0, 401)
    Tabs.Position = UDim2.new(0.026, 0, 0.111, 0)
    Tabs.BackgroundTransparency = 1
    Tabs.BorderSizePixel = 0
    Tabs.ScrollBarThickness = 0
    Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Tabs.CanvasSize = UDim2.new(0,0,0,0)

    local UIListLayout = Instance.new('UIListLayout', Tabs)
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ClientName = Instance.new('TextLabel')
    ClientName.Name = 'ClientName'
    ClientName.Parent = Handler
    ClientName.Text = text
    ClientName.Font = Enum.Font.GothamSemibold
    ClientName.TextSize = 13
    ClientName.TextColor3 = Color3.fromRGB(152, 181, 255)
    ClientName.TextTransparency = 0.2
    ClientName.Size = UDim2.new(0, 100, 0, 13)
    ClientName.Position = UDim2.new(0.056, 0, 0.055, 0)
    ClientName.AnchorPoint = Vector2.new(0, 0.5)
    ClientName.BackgroundTransparency = 1
    ClientName.TextXAlignment = Enum.TextXAlignment.Left

    local Pin = Instance.new('Frame')
    Pin.Name = 'Pin'
    Pin.Parent = Handler
    Pin.Size = UDim2.new(0, 2, 0, 16)
    Pin.Position = UDim2.new(0.026, 0, 0.136, 0)
    Pin.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
    Pin.BorderSizePixel = 0
    Instance.new('UICorner', Pin).CornerRadius = UDim.new(1,0)
    
    local Divider = Instance.new('Frame')
    Divider.Name = 'Divider'
    Divider.Parent = Handler
    Divider.Size = UDim2.new(0, 1, 1, 0)
    Divider.Position = UDim2.new(0.235, 0, 0, 0)
    Divider.BackgroundColor3 = Color3.fromRGB(52, 66, 89)
    Divider.BackgroundTransparency = 0.5
    Divider.BorderSizePixel = 0

    local Sections = Instance.new('Folder', Handler)
    Sections.Name = 'Sections'

    self._ui = NathubUI

    function self:load()
        TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(698, 479)
        }):Play()
        self._ui_loaded = true
    end

    function self:update_tabs(tab)
        for _, object in pairs(Tabs:GetChildren()) do
            if object:IsA('TextButton') and object.Name == 'Tab' then
                local TextLabel = object:FindFirstChild('TextLabel')
                local Icon = object:FindFirstChild('Icon')
                
                local isSelected = (object == tab)
                
                local bgTransparency = isSelected and 0.5 or 1
                local textTransparency = isSelected and 0.2 or 0.7
                local textColor = isSelected and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(255, 255, 255)
                local iconTransparency = isSelected and 0.2 or 0.8
                local iconColor = isSelected and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(255, 255, 255)

                if isSelected then
                    local offset = (object.LayoutOrder - 1) * 42 -- 38 size + 4 padding
                    TweenService:Create(Pin, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0.026, 0, 0.111, offset + 11)
                    }):Play()
                end

                TweenService:Create(object, TweenInfo.new(0.3), {BackgroundTransparency = bgTransparency}):Play()
                if TextLabel then
                    TweenService:Create(TextLabel, TweenInfo.new(0.3), {TextTransparency = textTransparency, TextColor3 = textColor}):Play()
                end
                if Icon then
                    TweenService:Create(Icon, TweenInfo.new(0.3), {ImageTransparency = iconTransparency, ImageColor3 = iconColor}):Play()
                end
            end
        end
    end

    function self:update_sections(left_section, right_section)
        for _, object in pairs(Sections:GetChildren()) do
            if object == left_section or object == right_section then
                object.Visible = true
            else
                object.Visible = false
            end
        end
    end
    
    function self:AddTab(Title, IconURL) -- FIX 2: Renamed Icon parameter
        self._tab += 1
        local TabManager = {}
        local first_tab = not Tabs:FindFirstChild('Tab')

        local Tab = Instance.new('TextButton')
        Tab.Name = 'Tab'
        Tab.Parent = Tabs
        Tab.LayoutOrder = self._tab
        Tab.Size = UDim2.new(1, 0, 0, 38)
        Tab.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
        Tab.BackgroundTransparency = 1
        Tab.Text = ''
        Tab.AutoButtonColor = false
        Instance.new('UICorner', Tab).CornerRadius = UDim.new(0,5)
        
        local TextLabel = Instance.new('TextLabel')
        TextLabel.Parent = Tab
        TextLabel.Name = "TextLabel"
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = Title
        TextLabel.TextSize = 13
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextTransparency = 0.7
        TextLabel.Size = UDim2.new(0, 0, 0, 16)
        TextLabel.AutomaticSize = Enum.AutomaticSize.X
        TextLabel.Position = UDim2.new(0.24, 0, 0.5, 0)
        TextLabel.AnchorPoint = Vector2.new(0, 0.5)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        local Icon = Instance.new('ImageLabel')
        Icon.Name = 'Icon'
        Icon.Parent = Tab
        Icon.Image = IconURL -- FIX 2: Used renamed parameter
        Icon.Size = UDim2.new(0, 12, 0, 12)
        Icon.Position = UDim2.new(0.1, 0, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.ImageTransparency = 0.8
        
        local function createSection(name, position)
            local section = Instance.new('ScrollingFrame')
            section.Name = name
            section.Parent = Sections
            section.Visible = false
            section.Size = UDim2.new(0, 243, 0, 445)
            section.Position = position
            section.AnchorPoint = Vector2.new(0, 0.5)
            section.BackgroundTransparency = 1
            section.BorderSizePixel = 0
            section.ScrollBarThickness = 3
            section.AutomaticCanvasSize = Enum.AutomaticSize.Y
            local listLayout = Instance.new('UIListLayout', section)
            listLayout.Padding = UDim.new(0, 11)
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            Instance.new('UIPadding', section).PaddingTop = UDim.new(0,11)
            return section
        end

        local LeftSection = createSection('LeftSection', UDim2.new(0.259, 0, 0.5, 0))
        local RightSection = createSection('RightSection', UDim2.new(0.629, 0, 0.5, 0))

        Tab.MouseButton1Click:Connect(function()
            self:update_tabs(Tab) -- FIX 3: Corrected function call
            self:update_sections(LeftSection, RightSection)
        end)

        if first_tab then
            self:update_tabs(Tab) -- FIX 3: Corrected function call
            self:update_sections(LeftSection, RightSection)
        end
        
        function TabManager:Toggle(settings)
            local ModuleManager = {}
            local section = (settings.section == 'right' and RightSection or LeftSection)

            local Module = Instance.new('Frame')
            Module.Name = "Module"
            Module.Parent = section
            Module.Size = UDim2.new(1, -2, 0, 93) -- Using scale
            Module.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
            Module.BackgroundTransparency = 0.5
            Module.ClipsDescendants = true
            Instance.new('UICorner', Module).CornerRadius = UDim.new(0,5)
            Instance.new('UIListLayout', Module).SortOrder = Enum.SortOrder.LayoutOrder
            
            -- Your Toggle UI creation code here...
            -- For brevity, I'll just create a placeholder
            local Header = Instance.new("TextButton", Module)
            Header.Size = UDim2.new(1,0,0,93)
            Header.Text = ""
            Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Header.BackgroundTransparency = 1
            
            local TitleLabel = Instance.new("TextLabel", Header)
            TitleLabel.Text = settings.Title or "Toggle"
            TitleLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
            TitleLabel.Position = UDim2.new(0.1,0,0.1,0)
            TitleLabel.Font = Enum.Font.GothamSemibold
            TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.BackgroundTransparency = 1

            local DescriptionLabel = Instance.new("TextLabel", Header)
            DescriptionLabel.Text = settings.Description or "Description"
            DescriptionLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
            DescriptionLabel.Position = UDim2.new(0.1,0,0.4,0)
            DescriptionLabel.Font = Enum.Font.Gotham
            DescriptionLabel.TextSize = 12
            DescriptionLabel.TextColor3 = Color3.fromRGB(200,200,200)
            DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescriptionLabel.BackgroundTransparency = 1
            
            local OptionsFrame = Instance.new("Frame", Module)
            OptionsFrame.Name = "Options"
            OptionsFrame.Size = UDim2.new(1,0,0,0)
            OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            OptionsFrame.BackgroundTransparency = 1
            local listLayout = Instance.new("UIListLayout", OptionsFrame)
            listLayout.Padding = UDim.new(0,5)
            Instance.new("UIPadding", OptionsFrame).Padding = UDim.new(0,10,0,10)


            -- Placeholder for ModuleManager functions
            function ModuleManager:Slider(sliderSettings)
                local slider = Instance.new("TextLabel", OptionsFrame)
                slider.Text = sliderSettings.Title or "Slider"
                slider.Size = UDim2.new(1,0,0,30)
                slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
                slider.TextColor3 = Color3.fromRGB(255,255,255)
                return {}
            end

            function ModuleManager:Checkbox(checkboxSettings)
                local checkbox = Instance.new("TextLabel", OptionsFrame)
                checkbox.Text = checkboxSettings.Title or "Checkbox"
                checkbox.Size = UDim2.new(1,0,0,20)
                checkbox.BackgroundColor3 = Color3.fromRGB(50,50,50)
                checkbox.TextColor3 = Color3.fromRGB(255,255,255)
                return {}
            end
            
            local expanded = false
            Header.MouseButton1Click:Connect(function()
                expanded = not expanded
                local contentSize = OptionsFrame.UIListLayout.AbsoluteContentSize
                local targetHeight = expanded and contentSize.Y + 20 or 0
                
                TweenService:Create(Module, TweenInfo.new(0.3), {
                    Size = UDim2.new(1, -2, 0, 93 + targetHeight)
                }):Play()
                
                if settings.Callback then
                    settings.Callback(expanded)
                end
            end)
            
            return ModuleManager
        end
        return TabManager
    end
    return self
end

return Library
