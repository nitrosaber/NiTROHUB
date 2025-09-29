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

-- Replace the SelectedLanguage with a reference to GG.Language
local SelectedLanguage = GG.Language

function convertStringToTable(inputString)
    local result = {}
    for value in string.gmatch(inputString, "([^,]+)") do
        local trimmedValue = value:match("^%s*(.-)%s*$")
        table.insert(result, trimmedValue) -- แก้ไขจาก tablein เป็น table.insert
    end

    return result
end

function convertTableToString(inputTable)
    return table.concat(inputTable, ", ")
end

local UserInputService = cloneref(game:GetService('UserInputService'))
local ContentProvider = cloneref(game:GetService('ContentProvider'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))

local mouse = Players.LocalPlayer:GetMouse()
local old_NathubUI = CoreGui:FindFirstChild('NathubUI')

if old_NathubUI then
    Debris:AddItem(old_NathubUI, 0)
end

if not isfolder("NathubUI") then
    makefolder("NathubUI")
end


local Connections = setmetatable({
    disconnect = function(self, connection)
        if not self[connection] then
            return
        end
    
        self[connection]:Disconnect()
        self[connection] = nil
    end,
    disconnect_all = function(self)
        for _, value in self do
            if typeof(value) == 'function' then
                continue
            end
    
            value:Disconnect()
        end
    end
}, Connections)


local Util = setmetatable({
    map = function(self: any, value: number, in_minimum: number, in_maximum: number, out_minimum: number, out_maximum: number)
        return (value - in_minimum) * (out_maximum - out_minimum) / (in_maximum - in_minimum) + out_minimum
    end,
    viewport_point_to_world = function(self: any, location: any, distance: number)
        local unit_ray = workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)

        return unit_ray.Origin + unit_ray.Direction * distance
    end,
    get_offset = function(self: any)
        local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y

        return self:map(viewport_size_Y, 0, 2560, 8, 56)
    end
}, Util)


local AcrylicBlur = {}
AcrylicBlur.__index = AcrylicBlur


function AcrylicBlur.new(object: GuiObject)
    local self = setmetatable({
        _object = object,
        _folder = nil,
        _frame = nil,
        _root = nil
    }, AcrylicBlur)

    self:setup()

    return self
end


function AcrylicBlur:create_folder()
    local old_folder = workspace.CurrentCamera:FindFirstChild('AcrylicBlur')

    if old_folder then
        Debris:AddItem(old_folder, 0)
    end

    local folder = Instance.new('Folder')
    folder.Name = 'AcrylicBlur'
    folder.Parent = workspace.CurrentCamera

    self._folder = folder
end


function AcrylicBlur:create_depth_of_fields()
    local depth_of_fields = Lighting:FindFirstChild('AcrylicBlur') or Instance.new('DepthOfFieldEffect')
    depth_of_fields.FarIntensity = 0
    depth_of_fields.FocusDistance = 0.05
    depth_of_fields.InFocusRadius = 0.1
    depth_of_fields.NearIntensity = 1
    depth_of_fields.Name = 'AcrylicBlur'
    depth_of_fields.Parent = Lighting

    for _, object in Lighting:GetChildren() do
        if not object:IsA('DepthOfFieldEffect') then
            continue
        end

        if object == depth_of_fields then
            continue
        end

        Connections[object] = object:GetPropertyChangedSignal('FarIntensity'):Connect(function()
            object.FarIntensity = 0
        end)

        object.FarIntensity = 0
    end
end


function AcrylicBlur:create_frame()
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.Parent = self._object

    self._frame = frame
end


function AcrylicBlur:create_root()
    local part = Instance.new('Part')
    part.Name = 'Root'
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.Glass
    part.Size = Vector3.new(1, 1, 0)  -- Use a thin part
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.Locked = true
    part.CastShadow = false
    part.Transparency = 0.98
    part.Parent = self._folder

    -- Create a SpecialMesh to simulate the acrylic blur effect
    local specialMesh = Instance.new('SpecialMesh')
    specialMesh.MeshType = Enum.MeshType.Brick  -- Use Brick mesh or another type suitable for the effect
    specialMesh.Offset = Vector3.new(0, 0, -0.000001)  -- Small offset to prevent z-fighting
    specialMesh.Parent = part

    self._root = part  -- Store the part as root
end


function AcrylicBlur:setup()
    self:create_depth_of_fields()
    self:create_folder()
    self:create_root()
    
    self:create_frame()
    self:render(0.001)

    self:check_quality_level()
end


function AcrylicBlur:render(distance: number)
    local positions = {
        top_left = Vector2.new(),
        top_right = Vector2.new(),
        bottom_right = Vector2.new(),
    }

    local function update_positions(size: any, position: any)
        positions.top_left = position
        positions.top_right = position + Vector2.new(size.X, 0)
        positions.bottom_right = position + size
    end

    local function update()
        local top_left = positions.top_left
        local top_right = positions.top_right
        local bottom_right = positions.bottom_right

        local top_left3D = Util:viewport_point_to_world(top_left, distance)
        local top_right3D = Util:viewport_point_to_world(top_right, distance)
        local bottom_right3D = Util:viewport_point_to_world(bottom_right, distance)

        local width = (top_right3D - top_left3D).Magnitude
        local height = (top_right3D - bottom_right3D).Magnitude

        if not self._root then
            return
        end

        self._root.CFrame = CFrame.fromMatrix((top_left3D + bottom_right3D) / 2, workspace.CurrentCamera.CFrame.XVector, workspace.CurrentCamera.CFrame.YVector, workspace.CurrentCamera.CFrame.ZVector)
        self._root.Mesh.Scale = Vector3.new(width, height, 0)
    end

    local function on_change()
        local offset = Util:get_offset()
        local size = self._frame.AbsoluteSize - Vector2.new(offset, offset)
        local position = self._frame.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

        update_positions(size, position)
        task.spawn(update)
    end

    Connections['cframe_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(update)
    Connections['viewport_size_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(update)
    Connections['field_of_view_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(update)

    Connections['frame_absolute_position'] = self._frame:GetPropertyChangedSignal('AbsolutePosition'):Connect(on_change)
    Connections['frame_absolute_size'] = self._frame:GetPropertyChangedSignal('AbsoluteSize'):Connect(on_change)
    
    task.spawn(update)
end


function AcrylicBlur:check_quality_level()
    local game_settings = UserSettings().GameSettings
    local quality_level = game_settings.SavedQualityLevel.Value

    if quality_level < 8 then
        self:change_visiblity(false)
    end

    Connections['quality_level'] = game_settings:GetPropertyChangedSignal('SavedQualityLevel'):Connect(function()
        local game_settings = UserSettings().GameSettings
        local quality_level = game_settings.SavedQualityLevel.Value

        self:change_visiblity(quality_level >= 8)
    end)
end


function AcrylicBlur:change_visiblity(state: boolean)
    self._root.Transparency = state and 0.98 or 1
end


local Config = setmetatable({
    save = function(self: any, file_name: any, config: any)
        local success_save, result = pcall(function()
            local flags = HttpService:JSONEncode(config)
            writefile('NathubUI/'..file_name..'.json', flags)
        end)
    
        if not success_save then
            warn('failed to save config', result)
        end
    end,
    load = function(self: any, file_name: any, config: any)
        local success_load, result = pcall(function()
            if not isfile('NathubUI/'..file_name..'.json') then
                self:save(file_name, config)
        
                return
            end
        
            local flags = readfile('NathubUI/'..file_name..'.json')
        
            if not flags then
                self:save(file_name, config)
        
                return
            end

            return HttpService:JSONDecode(flags)
        end)
    
        if not success_load then
            warn('failed to load config', result)
        end
    
        if not result then
            result = {
                _flags = {},
                _keybinds = {},
                _library = {}
            }
        end
    
        return result
    end
}, Config)


local Library = {
    _config = Config:load(game.GameId),

    _choosing_keybind = false,
    _device = nil,

    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,

    _dragging = false,
    _drag_start = nil,
    _container_position = nil,
    _tab = 0 -- เพิ่มการกำหนดค่าเริ่มต้น
}
Library.__index = Library

-- Create Notification Container
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "RobloxCoreGuis"
NotificationContainer.Size = UDim2.new(0, 300, 0, 0)  -- Fixed width (300px), dynamic height (Y)
NotificationContainer.Position = UDim2.new(0.8, 0, 0, 10)  -- Right side, offset by 10 from top
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ClipsDescendants = false;
NotificationContainer.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("CoreGui")
NotificationContainer.AutomaticSize = Enum.AutomaticSize.Y

-- UIListLayout to arrange notifications vertically
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = NotificationContainer

-- Function to create notifications
function Library.SendNotification(settings)
    -- Create the notification frame (this will be managed by UIListLayout)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 60)  -- Width = 100% of NotificationContainer's width, dynamic height (Y)
    Notification.BackgroundTransparency = 1  -- Outer frame is transparent for layout to work
    Notification.BorderSizePixel = 0
    Notification.Name = "Notification"
    Notification.Parent = NotificationContainer  -- Parent it to your NotificationContainer (the parent of the list layout)
    Notification.AutomaticSize = Enum.AutomaticSize.Y  -- Allow this frame to resize based on child height

    -- Add rounded corners to outer frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Notification

    -- Create the inner frame for the notification's content
    local InnerFrame = Instance.new("Frame")
    InnerFrame.Size = UDim2.new(1, 0, 0, 60)  -- Start with an initial height, width will adapt
    InnerFrame.Position = UDim2.new(0, 0, 0, 0)  -- Positioned inside the outer notification frame
    InnerFrame.BackgroundColor3 = Color3.fromRGB(32, 38, 51)
    InnerFrame.BackgroundTransparency = 0.1
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Name = "InnerFrame"
    InnerFrame.Parent = Notification
    InnerFrame.AutomaticSize = Enum.AutomaticSize.Y  -- Automatically resize based on its content

    -- Add rounded corners to the inner frame
    local InnerUICorner = Instance.new("UICorner")
    InnerUICorner.CornerRadius = UDim.new(0, 4)
    InnerUICorner.Parent = InnerFrame

    -- Title Label (with automatic size support)
    local Title = Instance.new("TextLabel")
    Title.Text = settings.Title or "Notification Title"
    Title.TextColor3 = Color3.fromRGB(210, 210, 210)
    Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -10, 0, 20)  -- Width is 1 (100% of parent width), height is fixed initially
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.TextWrapped = true  -- Enable wrapping
    Title.AutomaticSize = Enum.AutomaticSize.Y  -- Allow the title to resize based on content
    Title.Parent = InnerFrame

    -- Body Text (with automatic size support)
    local Body = Instance.new("TextLabel")
    Body.Text = settings.text or "This is the body of the notification."
    Body.TextColor3 = Color3.fromRGB(180, 180, 180)
    Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Body.TextSize = 12
    Body.Size = UDim2.new(1, -10, 0, 30)  -- Width is 1 (100% of parent width), height is fixed initially
    Body.Position = UDim2.new(0, 5, 0, 25)
    Body.BackgroundTransparency = 1
    Body.TextXAlignment = Enum.TextXAlignment.Left
    Body.TextYAlignment = Enum.TextYAlignment.Top
    Body.TextWrapped = true  -- Enable wrapping for long text
    Body.AutomaticSize = Enum.AutomaticSize.Y  -- Allow the body text to resize based on content
    Body.Parent = InnerFrame

    -- Force the size to adjust after the text is fully loaded and wrapped
    task.spawn(function()
        wait(0.1)  -- Allow text wrapping to finish
        -- Adjust inner frame size based on content
        local totalHeight = Title.TextBounds.Y + Body.TextBounds.Y + 10  -- Add padding
        InnerFrame.Size = UDim2.new(1, 0, 0, totalHeight)  -- Resize the inner frame
    end)

    -- Use task.spawn to ensure the notification tweening happens asynchronously
    task.spawn(function()
        -- Tween In the Notification (inner frame)
        local tweenIn = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 10 + NotificationContainer.Size.Y.Offset)
        })
        tweenIn:Play()

        -- Wait for the duration before tweening out
        local duration = settings.duration or 5  -- Default to 5 seconds if not provided
        wait(duration)

        -- Tween Out the Notification (inner frame) to the right side of the screen
        local tweenOut = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 310, 0, 10 + NotificationContainer.Size.Y.Offset)  -- Move to the right off-screen
        })
        tweenOut:Play()

        -- Remove the notification after it is done tweening out
        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

function Library:get_screen_scale()
    local viewport_size_x = workspace.CurrentCamera.ViewportSize.X

    self._ui_scale = viewport_size_x / 1400
end


function Library:get_device()
    local device = 'Unknown'

    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        device = 'PC'
    elseif UserInputService.TouchEnabled then
        device = 'Mobile'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    end

    self._device = device
end


function Library:removed(action: any)
    self._ui.AncestryChanged:Once(action)
end


function Library:flag_type(flag: any, flag_type: any)
    if not Library._config._flags[flag] then
        return
    end

    return typeof(Library._config._flags[flag]) == flag_type
end


function Library:remove_table_value(__table: any, table_value: string)
    for index, value in __table do
        if value ~= table_value then
            continue
        end

        table.remove(__table, index)
    end
end

function Library:CreateWindow(text)
    local old_NathubUI = CoreGui:FindFirstChild('NathubUI')

    if old_NathubUI then
        Debris:AddItem(old_NathubUI, 0)
    end

	local NathubUI = Instance.new('ScreenGui')
    NathubUI.ResetOnSpawn = false
    NathubUI.Name = 'NathubUI'
    NathubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NathubUI.Parent = CoreGui
    
    local Container = Instance.new('Frame')
    Container.ClipsDescendants = true
    Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Name = 'Container'
    Container.BackgroundTransparency = 0.05000000074505806
    Container.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Active = true
    Container.BorderSizePixel = 0
    Container.Parent = NathubUI
    
    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Container
    
    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(52, 66, 89)
    UIStroke.Transparency = 0.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Container
    
    local Handler = Instance.new('Frame')
    Handler.BackgroundTransparency = 1
    Handler.Name = 'Handler'
    Handler.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Handler.Size = UDim2.new(1, 0, 1, 0)
    Handler.BorderSizePixel = 0
    Handler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handler.Parent = Container
    
    local Tabs = Instance.new('ScrollingFrame')
    Tabs.ScrollBarImageTransparency = 1
    Tabs.ScrollBarThickness = 0
    Tabs.Name = 'Tabs'
    Tabs.Size = UDim2.new(0, 129, 0, 401)
    Tabs.Selectable = false
    Tabs.AutomaticCanvasSize = Enum.AutomaticSize.XY
    Tabs.BackgroundTransparency = 1
    Tabs.Position = UDim2.new(0.026097271591424942, 0, 0.1111111119389534, 0)
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BorderSizePixel = 0
    Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tabs.Parent = Handler
    
    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Tabs
    
    local ClientName = Instance.new('TextLabel')
    ClientName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ClientName.TextColor3 = Color3.fromRGB(152, 181, 255)
    ClientName.TextTransparency = 0.20000000298023224
    ClientName.Text = text
    ClientName.Name = 'ClientName'
    ClientName.Size = UDim2.new(0.2, 0, 0.05, 0)
    ClientName.AnchorPoint = Vector2.new(0, 0.5)
    ClientName.Position = UDim2.new(0.056, 0, 0.055, 0)
    ClientName.BackgroundTransparency = 1
    ClientName.TextXAlignment = Enum.TextXAlignment.Left
    ClientName.BorderSizePixel = 0
    ClientName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ClientName.TextSize = 13
    ClientName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClientName.Parent = Handler
    
    local UIGradient = Instance.new('UIGradient')
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 155, 155)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    UIGradient.Parent = ClientName
    
    local Pin = Instance.new('Frame')
    Pin.Name = 'Pin'
    Pin.Position = UDim2.new(0.026, 0, 0.136, 0)
    Pin.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Pin.Size = UDim2.new(0, 2, 0, 16)
    Pin.BorderSizePixel = 0
    Pin.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
    Pin.Parent = Handler
    
    local UICorner_Pin = Instance.new('UICorner')
    UICorner_Pin.CornerRadius = UDim.new(1, 0)
    UICorner_Pin.Parent = Pin
    
    local Icon = Instance.new('ImageLabel')
    Icon.ImageColor3 = Color3.fromRGB(152, 181, 255)
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Image = ""
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0.025, 0, 0.055, 0)
    Icon.Name = 'Icon'
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.BorderSizePixel = 0
    Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Icon.Parent = Handler
    
    local Divider = Instance.new('Frame')
    Divider.Name = 'Divider'
    Divider.BackgroundTransparency = 0.5
    Divider.Position = UDim2.new(0.235, 0, 0, 0)
    Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Divider.Size = UDim2.new(0, 1, 1, 0)
    Divider.BorderSizePixel = 0
    Divider.BackgroundColor3 = Color3.fromRGB(52, 66, 89)
    Divider.Parent = Handler
    
    local Sections = Instance.new('Folder')
    Sections.Name = 'Sections'
    Sections.Parent = Handler
    
    local Minimize = Instance.new('TextButton')
    Minimize.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.Text = ''
    Minimize.AutoButtonColor = false
    Minimize.Name = 'Minimize'
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(0.95, 0, 0.02, 0)
    Minimize.Size = UDim2.new(0, 24, 0, 24)
    Minimize.BorderSizePixel = 0
    Minimize.TextSize = 14
    Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.Parent = Handler
    
    local UIScale = Instance.new('UIScale')
    UIScale.Parent = Container    
    
    self._ui = NathubUI

    local function on_drag(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            self._dragging = true
            self._drag_start = input.Position
            self._container_position = Container.Position

            local endedConnection
            endedConnection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self._dragging = false
                    if endedConnection then
                        endedConnection:Disconnect()
                    end
                end
            end)
        end
    end

    local function update_drag(input: any)
        if self._dragging then
            local delta = input.Position - self._drag_start
            local newPosition = UDim2.new(
                self._container_position.X.Scale, 
                self._container_position.X.Offset + delta.X, 
                self._container_position.Y.Scale, 
                self._container_position.Y.Offset + delta.Y
            )
            Container.Position = newPosition
        end
    end

    Container.InputBegan:Connect(on_drag)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            update_drag(input)
        end
    end)


    self:removed(function()
        self._ui = nil
        Connections:disconnect_all()
    end)

    function self:Update1Run(a)
        if a == "nil" then
            Container.BackgroundTransparency = 0.05000000074505806;
        else
            pcall(function()
                Container.BackgroundTransparency = tonumber(a);
            end);
        end;
    end;

    function self:UIVisiblity()
        NathubUI.Enabled = not NathubUI.Enabled;
    end;

    function self:change_visiblity(state: boolean)
        if state then
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(698, 479)
            }):Play()
        else
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(0, 0)
            }):Play()
        end
    end
    

    function self:load()
        local content = {}
    
        for _, object in NathubUI:GetDescendants() do
            if not object:IsA('ImageLabel') then
                continue
            end
    
            table.insert(content, object)
        end
    
        ContentProvider:PreloadAsync(content)
        self:get_device()

        if self._device == 'Mobile' or self._device == 'Unknown' then
            self:get_screen_scale()
            UIScale.Scale = self._ui_scale
    
            Connections['ui_scale'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
                self:get_screen_scale()
                UIScale.Scale = self._ui_scale
            end)
        end
    
        TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(698, 479)
        }):Play()

        AcrylicBlur.new(Container)
        self._ui_loaded = true
    end

    function self:update_tabs(tab: TextButton)
        for index, object in ipairs(Tabs:GetChildren()) do
            if object:IsA("TextButton") and object.Name == 'Tab' then
                local isSelected = (object == tab)
                local targetBgTransparency = isSelected and 0.5 or 1
                local targetTextTransparency = isSelected and 0.2 or 0.7
                local targetTextColor = isSelected and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(255, 255, 255)
                local targetIconTransparency = isSelected and 0.2 or 0.8
                local targetIconColor = isSelected and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(255, 255, 255)
                
                if isSelected then
                    local offset = (object.LayoutOrder - 1) * 42 -- (38 size + 4 padding)
                    TweenService:Create(Pin, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0.026, 0, 0.136, offset)
                    }):Play()
                end

                TweenService:Create(object, TweenInfo.new(0.3), {BackgroundTransparency = targetBgTransparency}):Play()
                
                local textLabel = object:FindFirstChild("TextLabel")
                if textLabel then
                    TweenService:Create(textLabel, TweenInfo.new(0.3), {
                        TextTransparency = targetTextTransparency,
                        TextColor3 = targetTextColor
                    }):Play()
                end

                local iconImage = object:FindFirstChild("Icon")
                if iconImage then
                     TweenService:Create(iconImage, TweenInfo.new(0.3), {
                        ImageTransparency = targetIconTransparency,
                        ImageColor3 = targetIconColor
                    }):Play()
                end
            end
        end
    end

    function self:update_sections(left_section: ScrollingFrame, right_section: ScrollingFrame)
        for _, object in ipairs(Sections:GetChildren()) do
            object.Visible = (object == left_section or object == right_section)
        end
    end

    function self:AddTab(Title: string, IconID: string) -- แก้ไขชื่อพารามิเตอร์
        local TabManager = {}
        
        self._tab += 1
        
        local font_params = Instance.new('GetTextBoundsParams')
        font_params.Text = Title
        font_params.Font = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        font_params.Size = 13
        
        local font_size = TextService:GetTextBoundsAsync(font_params)
        local first_tab = (self._tab == 1)

        local Tab = Instance.new('TextButton')
        Tab.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        Tab.Text = ''
        Tab.AutoButtonColor = false
        Tab.BackgroundTransparency = 1
        Tab.Name = 'Tab'
        Tab.Size = UDim2.new(1, 0, 0, 38)
        Tab.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
        Tab.Parent = Tabs
        Tab.LayoutOrder = self._tab
        
        local UICorner_Tab = Instance.new('UICorner')
        UICorner_Tab.CornerRadius = UDim.new(0, 5)
        UICorner_Tab.Parent = Tab
        
        local TextLabel = Instance.new('TextLabel')
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextTransparency = 0.7
        TextLabel.Text = Title
        TextLabel.Size = UDim2.new(0, font_size.X, 0, 16)
        TextLabel.AnchorPoint = Vector2.new(0, 0.5)
        TextLabel.Position = UDim2.new(0.24, 0, 0.5, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextSize = 13
        TextLabel.Parent = Tab
        
        local Icon = Instance.new('ImageLabel')
        Icon.ScaleType = Enum.ScaleType.Fit
        Icon.ImageTransparency = 0.8
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0.1, 0, 0.5, 0)
        Icon.Name = 'Icon'
		Icon.Image = IconID -- แก้ไขให้ใช้ IconID
        Icon.Size = UDim2.new(0, 12, 0, 12)
        Icon.Parent = Tab

        local LeftSection = Instance.new('ScrollingFrame')
        LeftSection.Name = Title .. '_LeftSection'
        LeftSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftSection.ScrollBarThickness = 2
        LeftSection.Size = UDim2.new(0, 243, 1, -34)
        LeftSection.AnchorPoint = Vector2.new(0, 0)
        LeftSection.BackgroundTransparency = 1
        LeftSection.Position = UDim2.new(0.259, 0, 0.03, 0)
        LeftSection.BorderSizePixel = 0
        LeftSection.Visible = false
        LeftSection.Parent = Sections
        
        local UIListLayout_Left = Instance.new('UIListLayout')
        UIListLayout_Left.Padding = UDim.new(0, 11)
        UIListLayout_Left.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout_Left.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_Left.Parent = LeftSection
        
        local UIPadding_Left = Instance.new('UIPadding')
        UIPadding_Left.PaddingTop = UDim.new(0, 10)
        UIPadding_Left.Parent = LeftSection

        local RightSection = Instance.new('ScrollingFrame')
        RightSection.Name = Title .. '_RightSection'
        RightSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightSection.ScrollBarThickness = 2
        RightSection.Size = UDim2.new(0, 243, 1, -34)
        RightSection.AnchorPoint = Vector2.new(0, 0)
        RightSection.BackgroundTransparency = 1
        RightSection.Position = UDim2.new(0.629, 0, 0.03, 0)
        RightSection.BorderSizePixel = 0
        RightSection.Visible = false
        RightSection.Parent = Sections
        
        local UIListLayout_Right = Instance.new('UIListLayout')
        UIListLayout_Right.Padding = UDim.new(0, 11)
        UIListLayout_Right.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout_Right.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_Right.Parent = RightSection
        
        local UIPadding_Right = Instance.new('UIPadding')
        UIPadding_Right.PaddingTop = UDim.new(0, 10)
        UIPadding_Right.Parent = RightSection

        if first_tab then
            self:update_tabs(Tab)
            self:update_sections(LeftSection, RightSection)
        end

        Tab.MouseButton1Click:Connect(function()
            self:update_tabs(Tab)
            self:update_sections(LeftSection, RightSection)
        end)

        function TabManager:Toggle(settings: any)

            local LayoutOrderModule = 0;

            local ModuleManager = {
                _state = false,
                _size = 0,
                _multiplier = 0
            }

            local targetSection
            if settings.section == 'right' then
                targetSection = RightSection
            else
                targetSection = LeftSection
            end

            local Module = Instance.new('Frame')
            Module.ClipsDescendants = true
            Module.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Module.BackgroundTransparency = 0.5
            Module.Name = 'Module'
            Module.Size = UDim2.new(1, -2, 0, 93)
            Module.BorderSizePixel = 0
            Module.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
            Module.Parent = targetSection

            local UIListLayout_Module = Instance.new('UIListLayout')
            UIListLayout_Module.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_Module.Parent = Module
            
            local UICorner_Module = Instance.new('UICorner')
            UICorner_Module.CornerRadius = UDim.new(0, 5)
            UICorner_Module.Parent = Module
            
            local UIStroke_Module = Instance.new('UIStroke')
            UIStroke_Module.Color = Color3.fromRGB(52, 66, 89)
            UIStroke_Module.Transparency = 0.5
            UIStroke_Module.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke_Module.Parent = Module
            
            local Header = Instance.new('TextButton')
            Header.Text = ''
            Header.AutoButtonColor = false
            Header.BackgroundTransparency = 1
            Header.Name = 'Header'
            Header.Size = UDim2.new(1, 0, 0, 93)
            Header.Parent = Module
            
            local Icon_Header = Instance.new('ImageLabel')
            Icon_Header.ImageColor3 = Color3.fromRGB(152, 181, 255)
            Icon_Header.ScaleType = Enum.ScaleType.Fit
            Icon_Header.ImageTransparency = 0.699999988079071
            Icon_Header.AnchorPoint = Vector2.new(0, 0.5)
            Icon_Header.Image = 'rbxassetid://79095934438045'
            Icon_Header.BackgroundTransparency = 1
            Icon_Header.Position = UDim2.new(0.071, 0, 0.82, 0)
            Icon_Header.Name = 'Icon'
            Icon_Header.Size = UDim2.new(0, 15, 0, 15)
            Icon_Header.Parent = Header
            
            local ModuleName = Instance.new('TextLabel')
            ModuleName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            ModuleName.TextColor3 = Color3.fromRGB(152, 181, 255)
            ModuleName.TextTransparency = 0.20000000298023224
            if not settings.rich then
                ModuleName.Text = settings.Title or "Skibidi"
            else
                ModuleName.RichText = true
                ModuleName.Text = settings.richtext or "<font color='rgb(255,0,0)'>NathubUI</font> user"
            end;
            ModuleName.Name = 'ModuleName'
            ModuleName.Size = UDim2.new(1, -36, 0, 13)
            ModuleName.AnchorPoint = Vector2.new(0, 0.5)
            ModuleName.Position = UDim2.new(0.073, 0, 0.24, 0)
            ModuleName.BackgroundTransparency = 1
            ModuleName.TextXAlignment = Enum.TextXAlignment.Left
            ModuleName.TextSize = 13
            ModuleName.Parent = Header
            
            local Description = Instance.new('TextLabel')
            Description.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            Description.TextColor3 = Color3.fromRGB(152, 181, 255)
            Description.TextTransparency = 0.699999988079071
            Description.Text = settings.Description
            Description.Name = 'Description'
            Description.Size = UDim2.new(1, -36, 0, 13)
            Description.AnchorPoint = Vector2.new(0, 0.5)
            Description.Position = UDim2.new(0.073, 0, 0.42, 0)
            Description.BackgroundTransparency = 1
            Description.TextXAlignment = Enum.TextXAlignment.Left
            Description.TextSize = 10
            Description.Parent = Header
            
            local Toggle = Instance.new('Frame')
            Toggle.Name = 'Toggle'
            Toggle.BackgroundTransparency = 0.699999988079071
            Toggle.Position = UDim2.new(0.82, 0, 0.757, 0)
            Toggle.Size = UDim2.new(0, 25, 0, 12)
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.Parent = Header
            
            local UICorner_Toggle = Instance.new('UICorner')
            UICorner_Toggle.CornerRadius = UDim.new(1, 0)
            UICorner_Toggle.Parent = Toggle
            
            local Circle = Instance.new('Frame')
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.BackgroundTransparency = 0.20000000298023224
            Circle.Position = UDim2.new(0, 0, 0.5, 0)
            Circle.Name = 'Circle'
            Circle.Size = UDim2.new(0, 12, 0, 12)
            Circle.BackgroundColor3 = Color3.fromRGB(66, 80, 115)
            Circle.Parent = Toggle
            
            local UICorner_Circle = Instance.new('UICorner')
            UICorner_Circle.CornerRadius = UDim.new(1, 0)
            UICorner_Circle.Parent = Circle
            
            local Keybind = Instance.new('Frame')
            Keybind.Name = 'Keybind'
            Keybind.BackgroundTransparency = 0.699999988079071
            Keybind.Position = UDim2.new(0.15, 0, 0.735, 0)
            Keybind.Size = UDim2.new(0, 33, 0, 15)
            Keybind.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
            Keybind.Parent = Header
            
            local UICorner_Keybind = Instance.new('UICorner')
            UICorner_Keybind.CornerRadius = UDim.new(0, 3)
            UICorner_Keybind.Parent = Keybind
            
            local TextLabel_Keybind = Instance.new('TextLabel')
            TextLabel_Keybind.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            TextLabel_Keybind.TextColor3 = Color3.fromRGB(209, 222, 255)
            TextLabel_Keybind.Text = 'None'
            TextLabel_Keybind.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel_Keybind.Size = UDim2.new(1, -6, 1, -2)
            TextLabel_Keybind.BackgroundTransparency = 1
            TextLabel_Keybind.Position = UDim2.new(0.5, 0, 0.5, 0)
            TextLabel_Keybind.TextSize = 10
            TextLabel_Keybind.Parent = Keybind
            
            local Divider_Header = Instance.new('Frame')
            Divider_Header.AnchorPoint = Vector2.new(0.5, 0)
            Divider_Header.BackgroundTransparency = 0.5
            Divider_Header.Position = UDim2.new(0.5, 0, 1, 0)
            Divider_Header.Name = 'Divider'
            Divider_Header.Size = UDim2.new(1, 0, 0, 1)
            Divider_Header.BackgroundColor3 = Color3.fromRGB(52, 66, 89)
            Divider_Header.Parent = Header
            
            local Options = Instance.new('Frame')
            Options.Name = 'Options'
            Options.BackgroundTransparency = 1
            Options.Position = UDim2.new(0, 0, 1, 0)
            Options.Size = UDim2.new(1, 0, 0, 8)
            Options.AutomaticSize = Enum.AutomaticSize.Y
            Options.Parent = Module

            local UIPadding_Options = Instance.new('UIPadding')
            UIPadding_Options.PaddingTop = UDim.new(0, 8)
            UIPadding_Options.PaddingBottom = UDim.new(0, 8)
            UIPadding_Options.Parent = Options

            local UIListLayout_Options = Instance.new('UIListLayout')
            UIListLayout_Options.Padding = UDim.new(0, 5)
            UIListLayout_Options.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout_Options.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_Options.Parent = Options
            
            function ModuleManager:change_state(state: boolean, skipCallback: boolean)
                self._state = state

                if self._state then
                    TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -2, 0, 93 + Options.AbsoluteSize.Y)
                    }):Play()

                    TweenService:Create(Toggle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                    }):Play()

                    TweenService:Create(Circle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(152, 181, 255),
                        Position = UDim2.fromScale(0.53, 0.5)
                    }):Play()
                else
                    TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -2, 0, 93)
                    }):Play()

                    TweenService:Create(Toggle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    }):Play()

                    TweenService:Create(Circle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(66, 80, 115),
                        Position = UDim2.fromScale(0, 0.5)
                    }):Play()
                end

                Library._config._flags[settings.Flag] = self._state
                Config:save(game.GameId, Library._config)

                if not skipCallback then
                    settings.Callback(self._state)
                end
            end
            
            function ModuleManager:connect_keybind()
                if Connections[settings.Flag..'_keybind'] then Connections[settings.Flag..'_keybind']:Disconnect() end
                if not Library._config._keybinds[settings.Flag] then
                    return
                end

                Connections[settings.Flag..'_keybind'] = UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
                    if process then return end
                    if tostring(input.KeyCode) == Library._config._keybinds[settings.Flag] then
                        self:change_state(not self._state)
                    end
                end)
            end

            function ModuleManager:scale_keybind(keybindText: string)
                 TextLabel_Keybind.Text = keybindText
                 task.wait() 
                 local textBounds = TextService:GetTextSize(keybindText, TextLabel_Keybind.TextSize, TextLabel_Keybind.Font, Vector2.new(math.huge, math.huge))
                 Keybind.Size = UDim2.fromOffset(textBounds.X + 8, 15)
            end

            if Library:flag_type(settings.Flag, 'boolean') and Library._config._flags[settings.Flag] then
                ModuleManager:change_state(true, true)
            end

            if Library._config._keybinds[settings.Flag] then
                local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.Flag]), 'Enum.KeyCode.', '')
                ModuleManager:scale_keybind(keybind_string)
                ModuleManager:connect_keybind()
            else
                ModuleManager:scale_keybind('None')
            end

            Header.InputBegan:Connect(function(input: InputObject)
                if input.UserInputType == Enum.UserInputType.MouseButton3 then
                    if Library._choosing_keybind then return end
                    Library._choosing_keybind = true
                    
                    ModuleManager:scale_keybind('...')
                    
                    local keybindConnection
                    keybindConnection = UserInputService.InputBegan:Connect(function(keyInput: InputObject, process: boolean)
                        if process then return end
                        if keyInput.UserInputType ~= Enum.UserInputType.Keyboard then return end

                        Library._choosing_keybind = false
                        keybindConnection:Disconnect()

                        if keyInput.KeyCode == Enum.KeyCode.Backspace then
                            Library._config._keybinds[settings.Flag] = nil
                            ModuleManager:scale_keybind('None')
                        else
                            Library._config._keybinds[settings.Flag] = tostring(keyInput.KeyCode)
                            local keybind_string = string.gsub(tostring(keyInput.KeyCode), 'Enum.KeyCode.', '')
                            ModuleManager:scale_keybind(keybind_string)
                        end
                        
                        Config:save(game.GameId, Library._config)
                        ModuleManager:connect_keybind()
                    end)
                end
            end)

            Header.MouseButton1Click:Connect(function()
                ModuleManager:change_state(not ModuleManager._state)
            end)

            function ModuleManager:Paragraph(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1;

                local ParagraphManager = {}
            
                -- Container Frame
                local Paragraph = Instance.new('Frame')
                Paragraph.BackgroundColor3 = Color3.fromRGB(32, 38, 51)
                Paragraph.BackgroundTransparency = 0.1
                Paragraph.Size = UDim2.new(0, 207, 0, 30) -- Initial size, auto-resized later
                Paragraph.BorderSizePixel = 0
                Paragraph.Name = "Paragraph"
                Paragraph.AutomaticSize = Enum.AutomaticSize.Y -- Support auto-resizing height
                Paragraph.Parent = Options
                Paragraph.LayoutOrder = LayoutOrderModule;
            
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Paragraph
            
                -- Title Label
                local Title = Instance.new('TextLabel')
                Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Title.TextColor3 = Color3.fromRGB(210, 210, 210)
                Title.Text = settings.Title or "Title"
                Title.Size = UDim2.new(1, -10, 0, 20)
                Title.Position = UDim2.new(0, 5, 0, 5)
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.TextYAlignment = Enum.TextYAlignment.Center
                Title.TextSize = 12
                Title.AutomaticSize = Enum.AutomaticSize.Y
                Title.Parent = Paragraph
            
                -- Body Text
                local Body = Instance.new('TextLabel')
                Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Body.TextColor3 = Color3.fromRGB(180, 180, 180)
                
                if not settings.rich then
                    Body.Text = settings.text or "Skibidi"
                else
                    Body.RichText = true
                    Body.Text = settings.richtext or "<font color='rgb(255,0,0)'>NathubUI</font> user"
                end
                
                Body.Size = UDim2.new(1, -10, 0, 0)
                Body.Position = UDim2.new(0, 5, 0, 25)
                Body.BackgroundTransparency = 1
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top
                Body.TextSize = 11
                Body.TextWrapped = true
                Body.AutomaticSize = Enum.AutomaticSize.Y
                Body.Parent = Paragraph
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end

                return ParagraphManager
            end

            function ModuleManager:create_text(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
            
                local TextManager = {}
            
                -- Container Frame
                local TextFrame = Instance.new('Frame')
                TextFrame.BackgroundColor3 = Color3.fromRGB(32, 38, 51)
                TextFrame.BackgroundTransparency = 0.1
                TextFrame.Size = UDim2.new(0, 207, 0, settings.CustomYSize or 30)
                TextFrame.BorderSizePixel = 0
                TextFrame.Name = "Text"
                TextFrame.AutomaticSize = Enum.AutomaticSize.Y
                TextFrame.Parent = Options
                TextFrame.LayoutOrder = LayoutOrderModule
            
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = TextFrame
            
                -- Body Text
                local Body = Instance.new('TextLabel')
                Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Body.TextColor3 = Color3.fromRGB(180, 180, 180)
            
                if not settings.rich then
                    Body.Text = settings.text or "Skibidi"
                else
                    Body.RichText = true
                    Body.Text = settings.richtext or "<font color='rgb(255,0,0)'>NathubUI</font> user"
                end
            
                Body.Size = UDim2.new(1, -10, 1, -10)
                Body.Position = UDim2.new(0, 5, 0, 5)
                Body.BackgroundTransparency = 1
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top
                Body.TextSize = 10
                Body.TextWrapped = true
                Body.Parent = TextFrame
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end

                function TextManager:Set(new_settings)
                    if not new_settings.rich then
                        Body.Text = new_settings.text or "Skibidi"
                    else
                        Body.RichText = true
                        Body.Text = new_settings.richtext or "<font color='rgb(255,0,0)'>NathubUI</font> user"
                    end
                end;
            
                return TextManager
            end

            function ModuleManager:Input(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
            
                local TextboxManager = {
                    _text = ""
                }
            
                local container = Instance.new("Frame")
                container.Size = UDim2.new(0, 207, 0, 32)
                container.BackgroundTransparency = 1
                container.LayoutOrder = LayoutOrderModule
                container.Parent = Options

                local Label = Instance.new('TextLabel')
                Label.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextTransparency = 0.2
                Label.Text = settings.Title or "Enter text"
                Label.Size = UDim2.new(1, 0, 0, 13)
                Label.BackgroundTransparency = 1
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextSize = 10;
                Label.Parent = container
            
                local Textbox = Instance.new('TextBox')
                Textbox.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                Textbox.PlaceholderText = settings.placeholder or "Enter text..."
                Textbox.Text = Library._config._flags[settings.Flag] or ""
                Textbox.Name = 'Textbox'
                Textbox.Size = UDim2.new(1, 0, 0, 15)
                Textbox.Position = UDim2.new(0,0,0,15)
                Textbox.TextSize = 10
                Textbox.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Textbox.BackgroundTransparency = 0.9
                Textbox.ClearTextOnFocus = false
                Textbox.Parent = container
            
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Textbox
            
                function TextboxManager:update_text(text: string)
                    self._text = text
                    Library._config._flags[settings.Flag] = self._text
                    Config:save(game.GameId, Library._config)
                    settings.Callback(self._text)
                end
            
                if Library:flag_type(settings.Flag, 'string') then
                    TextboxManager:update_text(Library._config._flags[settings.Flag])
                end
            
                Textbox.FocusLost:Connect(function()
                    TextboxManager:update_text(Textbox.Text)
                end)
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end
            
                return TextboxManager
            end   

            function ModuleManager:Checkbox(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
                local CheckboxManager = { _state = false }
            
                local Checkbox = Instance.new("TextButton")
                Checkbox.Text = ""
                Checkbox.AutoButtonColor = false
                Checkbox.BackgroundTransparency = 1
                Checkbox.Name = "Checkbox"
                Checkbox.Size = UDim2.new(0, 207, 0, 15)
                Checkbox.Parent = Options
                Checkbox.LayoutOrder = LayoutOrderModule
            
                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Name = "TitleLabel"
                TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                TitleLabel.TextSize = 11
                TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TitleLabel.TextTransparency = 0.2
                TitleLabel.Text = settings.Title or "Skibidi"
                TitleLabel.Size = UDim2.new(1, -20, 1, 0)
                TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
                TitleLabel.Position = UDim2.new(0, 0, 0.5, 0)
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.Parent = Checkbox
            
                local Box = Instance.new("Frame")
                Box.AnchorPoint = Vector2.new(1, 0.5)
                Box.BackgroundTransparency = 0.9
                Box.Position = UDim2.new(1, 0, 0.5, 0)
                Box.Name = "Box"
                Box.Size = UDim2.new(0, 15, 0, 15)
                Box.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Box.Parent = Checkbox
            
                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = Box
            
                local Fill = Instance.new("Frame")
                Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                Fill.BackgroundTransparency = 0.2
                Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                Fill.Name = "Fill"
                Fill.Size = UDim2.fromOffset(0,0)
                Fill.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Fill.Parent = Box
            
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 3)
                FillCorner.Parent = Fill
            
                function CheckboxManager:change_state(state: boolean, skipCallback: boolean)
                    self._state = state
                    if self._state then
                        TweenService:Create(Box, TweenInfo.new(0.3), { BackgroundTransparency = 0.7 }):Play()
                        TweenService:Create(Fill, TweenInfo.new(0.3), { Size = UDim2.fromOffset(9, 9) }):Play()
                    else
                        TweenService:Create(Box, TweenInfo.new(0.3), { BackgroundTransparency = 0.9 }):Play()
                        TweenService:Create(Fill, TweenInfo.new(0.3), { Size = UDim2.fromOffset(0, 0) }):Play()
                    end
                    Library._config._flags[settings.Flag] = self._state
                    Config:save(game.GameId, Library._config)
                    if not skipCallback then
                        settings.Callback(self._state)
                    end
                end
            
                if Library:flag_type(settings.Flag, "boolean") and Library._config._flags[settings.Flag] then
                    CheckboxManager:change_state(true, true)
                end
            
                Checkbox.MouseButton1Click:Connect(function()
                    CheckboxManager:change_state(not CheckboxManager._state)
                end)
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end
            
                return CheckboxManager
            end

            function ModuleManager:Divider(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1;
            
                local dividerHeight = 1
                local dividerWidth = 207
            
                local OuterFrame = Instance.new('Frame')
                OuterFrame.Size = UDim2.new(0, dividerWidth, 0, 20)
                OuterFrame.BackgroundTransparency = 1
                OuterFrame.Name = 'OuterFrame'
                OuterFrame.Parent = Options
                OuterFrame.LayoutOrder = LayoutOrderModule

                if settings and settings.showtopic then
                    local TextLabel = Instance.new('TextLabel')
                    TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.Text = settings.Title
                    TextLabel.Size = UDim2.new(1, 0, 1, 0)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                    TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
                    TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                    TextLabel.TextSize = 11
                    TextLabel.ZIndex = 3;
                    TextLabel.Parent = OuterFrame
                end;
                
                if not settings or (settings and not settings.disableline) then
                    local Divider = Instance.new('Frame')
                    Divider.Size = UDim2.new(1, 0, 0, dividerHeight)
                    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Divider.Name = 'Divider'
                    Divider.Parent = OuterFrame
                    Divider.ZIndex = 2;
                    Divider.Position = UDim2.new(0, 0, 0.5, -dividerHeight / 2)
                
                    local Gradient = Instance.new('UIGradient')
                    Gradient.Parent = Divider
                    Gradient.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),   
                        NumberSequenceKeypoint.new(0.5, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                
                    local UICorner_Div = Instance.new('UICorner')
                    UICorner_Div.CornerRadius = UDim.new(0, 2)
                    UICorner_Div.Parent = Divider

                end;
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end
            
                return true;
            end
            
            function ModuleManager:Slider(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1
                local SliderManager = {}

                local Slider = Instance.new('TextButton')
                Slider.Text = ''
                Slider.AutoButtonColor = false
                Slider.BackgroundTransparency = 1
                Slider.Name = 'Slider'
                Slider.Size = UDim2.new(0, 207, 0, 22)
                Slider.Parent = Options
                Slider.LayoutOrder = LayoutOrderModule
                
                local TextLabel = Instance.new('TextLabel')
                TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                TextLabel.TextSize = 11;
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextTransparency = 0.2
                TextLabel.Text = settings.Title
                TextLabel.Size = UDim2.new(0.7, 0, 1, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.Parent = Slider
                
                local Drag = Instance.new('Frame')
                Drag.AnchorPoint = Vector2.new(0.5, 1)
                Drag.BackgroundTransparency = 0.9
                Drag.Position = UDim2.new(0.5, 0, 1, 0)
                Drag.Name = 'Drag'
                Drag.Size = UDim2.new(1, 0, 0, 4)
                Drag.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Drag.Parent = Slider
                
                local UICorner_Drag = Instance.new('UICorner')
                UICorner_Drag.CornerRadius = UDim.new(1, 0)
                UICorner_Drag.Parent = Drag
                
                local Fill = Instance.new('Frame')
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundTransparency = 0.5
                Fill.Position = UDim2.new(0, 0, 0.5, 0)
                Fill.Name = 'Fill'
                Fill.Size = UDim2.new(0.5, 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Fill.Parent = Drag
                
                local UICorner_Fill = Instance.new('UICorner')
                UICorner_Fill.CornerRadius = UDim.new(1, 0)
                UICorner_Fill.Parent = Fill
                
                local Circle = Instance.new('Frame')
                Circle.AnchorPoint = Vector2.new(1, 0.5)
                Circle.Name = 'Circle'
                Circle.Position = UDim2.new(1, 0, 0.5, 0)
                Circle.Size = UDim2.new(0, 6, 0, 6)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.Parent = Fill
                
                local UICorner_Circle_Slider = Instance.new('UICorner')
                UICorner_Circle_Slider.CornerRadius = UDim.new(1, 0)
                UICorner_Circle_Slider.Parent = Circle
                
                local Value = Instance.new('TextLabel')
                Value.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                Value.TextTransparency = 0.2
                Value.Text = tostring(settings.Value)
                Value.Name = 'Value'
                Value.Size = UDim2.new(0.3, 0, 1, 0)
                Value.AnchorPoint = Vector2.new(1, 0)
                Value.Position = UDim2.new(1, 0, 0, 0)
                Value.BackgroundTransparency = 1
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.TextSize = 10
                Value.Parent = Slider

                function SliderManager:set_percentage(percentage: number, fromSaved: boolean)
                    local min, max = settings.MinValue, settings.MaxValue
                    local value = math.clamp(percentage, min, max)
                    
                    if settings.Round_Number then
                        value = math.floor(value + 0.5)
                    end
                    
                    local alpha = (value - min) / (max - min)
                    
                    Fill.Size = UDim2.new(alpha, 0, 1, 0)
                    Value.Text = tostring(value)
                    
                    if not fromSaved then
                        Library._config._flags[settings.Flag] = value
                        settings.Callback(value)
                    end
                end

                function SliderManager:update()
                    local mouse_X = mouse.X
                    local drag_Start = Drag.AbsolutePosition.X
                    local drag_End = drag_Start + Drag.AbsoluteSize.X
                    
                    local alpha = math.clamp((mouse_X - drag_Start) / (drag_End - drag_Start), 0, 1)
                    local value = settings.MinValue + (settings.MaxValue - settings.MinValue) * alpha
                    
                    SliderManager:set_percentage(value)
                end

                local isDragging = false
                Slider.MouseButton1Down:Connect(function()
                    isDragging = true
                    SliderManager:update()
                end)

                Slider.MouseButton1Up:Connect(function()
                    isDragging = false
                    if not settings.ignoresaved then
                        Config:save(game.GameId, Library._config)
                    end
                end)

                Slider.MouseLeave:Connect(function()
                    if isDragging then
                        isDragging = false
                        if not settings.ignoresaved then
                           Config:save(game.GameId, Library._config)
                        end
                    end
                end)

                mouse.Move:Connect(function()
                    if isDragging then
                        SliderManager:update()
                    end
                end)

                local savedValue = Library._config._flags[settings.Flag]
                if typeof(savedValue) == 'number' and not settings.ignoresaved then
                    SliderManager:set_percentage(savedValue, true)
                else
                    SliderManager:set_percentage(settings.Value, true)
                end
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end
                
                return SliderManager
            end

            function ModuleManager:Dropdown(settings: any)
                LayoutOrderModule = LayoutOrderModule + 1;

                local DropdownManager = {
                    _state = false,
                    _size = 0
                }

                local Dropdown = Instance.new('TextButton')
                Dropdown.Text = ''
                Dropdown.AutoButtonColor = false
                Dropdown.BackgroundTransparency = 1
                Dropdown.Name = 'Dropdown'
                Dropdown.Size = UDim2.new(0, 207, 0, 39)
                Dropdown.Parent = Options
                Dropdown.LayoutOrder = LayoutOrderModule

                if not Library._config._flags[settings.Flag] then
                    if settings.Multi then
                        Library._config._flags[settings.Flag] = {};
                    else
                        Library._config._flags[settings.Flag] = ""
                    end
                end;
                
                local TextLabel = Instance.new('TextLabel')
                TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                TextLabel.TextSize = 11;
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextTransparency = 0.2
                TextLabel.Text = settings.Title
                TextLabel.Size = UDim2.new(1, 0, 0, 13)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.Parent = Dropdown
                
                local Box = Instance.new('Frame')
                Box.ClipsDescendants = true
                Box.AnchorPoint = Vector2.new(0, 1)
                Box.BackgroundTransparency = 0.9
                Box.Position = UDim2.new(0, 0, 1, 0)
                Box.Name = 'Box'
                Box.Size = UDim2.new(1, 0, 0, 22)
                Box.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Box.Parent = Dropdown
                
                local UICorner_Box = Instance.new('UICorner')
                UICorner_Box.CornerRadius = UDim.new(0, 4)
                UICorner_Box.Parent = Box
                
                local Header = Instance.new('Frame')
                Header.BackgroundTransparency = 1
                Header.Name = 'Header'
                Header.Size = UDim2.new(1, 0, 1, 0)
                Header.Parent = Box
                
                local CurrentOption = Instance.new('TextLabel')
                CurrentOption.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                CurrentOption.TextColor3 = Color3.fromRGB(255, 255, 255)
                CurrentOption.TextTransparency = 0.2
                CurrentOption.Name = 'CurrentOption'
                CurrentOption.Size = UDim2.new(1, -20, 1, 0)
                CurrentOption.AnchorPoint = Vector2.new(0, 0.5)
                CurrentOption.Position = UDim2.new(0, 5, 0.5, 0)
                CurrentOption.BackgroundTransparency = 1
                CurrentOption.TextXAlignment = Enum.TextXAlignment.Left
                CurrentOption.TextSize = 10
                CurrentOption.Parent = Header
                
                local Arrow = Instance.new('ImageLabel')
                Arrow.AnchorPoint = Vector2.new(1, 0.5)
                Arrow.Image = 'rbxassetid://84232453189324'
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1, -5, 0.5, 0)
                Arrow.Name = 'Arrow'
                Arrow.Size = UDim2.new(0, 8, 0, 8)
                Arrow.Parent = Header
                
                local OptionsContainer = Instance.new('ScrollingFrame')
                OptionsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
                OptionsContainer.ScrollBarThickness = 2
                OptionsContainer.Name = 'Options'
                OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionsContainer.BackgroundTransparency = 1
                OptionsContainer.Position = UDim2.new(0, 0, 1, 0)
                OptionsContainer.BorderSizePixel = 0
                OptionsContainer.Visible = false
                OptionsContainer.Parent = Box
                
                local UIListLayout_Opts = Instance.new('UIListLayout')
                UIListLayout_Opts.Padding = UDim.new(0,2)
                UIListLayout_Opts.Parent = OptionsContainer
                
                local UIPadding_Opts = Instance.new('UIPadding')
                UIPadding_Opts.PaddingTop = UDim.new(0, 5)
                UIPadding_Opts.PaddingBottom = UDim.new(0, 5)
                UIPadding_Opts.PaddingLeft = UDim.new(0, 5)
                UIPadding_Opts.PaddingRight = UDim.new(0, 5)
                UIPadding_Opts.Parent = OptionsContainer

                local function getOptionName(option)
                    return typeof(option) == "string" and option or option.Name
                end

                function DropdownManager:update(option, skipCallback)
                    local optionName = getOptionName(option)
                    if settings.Multi then
                        local selectedOptions = Library._config._flags[settings.Flag]
                        local isSelected = table.find(selectedOptions, optionName)
                        
                        if isSelected then
                            table.remove(selectedOptions, table.find(selectedOptions, optionName))
                        else
                            table.insert(selectedOptions, optionName)
                        end
                        CurrentOption.Text = table.concat(selectedOptions, ", ")
                    else
                        Library._config._flags[settings.Flag] = optionName
                        CurrentOption.Text = optionName
                    end
                
                    for _, optButton in ipairs(OptionsContainer:GetChildren()) do
                        if optButton:IsA("TextButton") then
                            local optName = optButton.Text
                            local isSelected
                            if settings.Multi then
                                isSelected = table.find(Library._config._flags[settings.Flag], optName)
                            else
                                isSelected = (Library._config._flags[settings.Flag] == optName)
                            end
                            optButton.TextTransparency = isSelected and 0.2 or 0.6
                        end
                    end

                    Config:save(game.GameId, Library._config)
                    if not skipCallback then
                        settings.Callback(Library._config._flags[settings.Flag])
                    end
                end
                
                function DropdownManager:unfold_settings()
                    self._state = not self._state
                    OptionsContainer.Visible = self._state
                    
                    local optionsHeight = OptionsContainer.CanvasSize.Y.Offset
                    local targetBoxSizeY = self._state and (22 + optionsHeight) or 22
                    
                    TweenService:Create(Box, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetBoxSizeY)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = self._state and 180 or 0}):Play()
                    
                    if ModuleManager._state then
                         task.wait(0.3)
                         ModuleManager:change_state(true, true)
                    end
                end
                
                if #settings.Options > 0 then
                    for _, value in ipairs(settings.Options) do
                        local optionName = getOptionName(value)
                        local OptionButton = Instance.new('TextButton')
                        OptionButton.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                        OptionButton.TextTransparency = 0.6
                        OptionButton.TextSize = 10
                        OptionButton.Size = UDim2.new(1, 0, 0, 16)
                        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        OptionButton.Text = optionName
                        OptionButton.AutoButtonColor = false
                        OptionButton.Name = 'Option'
                        OptionButton.BackgroundTransparency = 1
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.Parent = OptionsContainer

                        OptionButton.MouseButton1Click:Connect(function()
                            DropdownManager:update(value)
                            if not settings.Multi then
                                DropdownManager:unfold_settings()
                            end
                        end)
                    end
                end

                if settings.Multi then
                    CurrentOption.Text = table.concat(Library._config._flags[settings.Flag], ", ")
                else
                    CurrentOption.Text = Library._config._flags[settings.Flag] or getOptionName(settings.Options[1])
                end
                DropdownManager:update(CurrentOption.Text, true)

                Dropdown.MouseButton1Click:Connect(function()
                    DropdownManager:unfold_settings()
                end)
                
                if ModuleManager._state then
                    task.wait()
                    ModuleManager:change_state(true, true)
                end

                return DropdownManager
            end
            
            return ModuleManager
        end

        return TabManager
    end

    Connections['library_visiblity'] = UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if input.KeyCode == Enum.KeyCode.Insert then
            self._ui_open = not self._ui_open
            self:change_visiblity(self._ui_open)
        end
    end)

    Minimize.MouseButton1Click:Connect(function()
        self._ui_open = not self._ui_open
        self:change_visiblity(self._ui_open)
    end)

    return self
end

return Library
