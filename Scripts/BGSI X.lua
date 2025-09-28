--// 🌀 NiTroHUB PRO - Emoji Edition v8.2 (FINAL)
--// ✨ by NiTroHUB x Gemini (แก้ไขบัคสุดท้ายเพื่อความสมบูรณ์แบบ)
--// Description: A complete and bug-free version with all known issues resolved, ensuring full functionality and stability.

-- =================================================================
-- [[ SAFETY WAIT MECHANISM ]]
-- =================================================================
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1)

-- =================================================================
-- [[ ⚙️ CONFIGURATION ]]
-- =================================================================
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 8,
    HatchDelay = 0.1,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
        "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
        "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
    }
}

-- =================================================================
-- [[ 🧩 SERVICES & CORE SETUP ]]
-- =================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CHEST_LIST = {}
for _, name in ipairs(Config.ChestNames) do
    CHEST_LIST[name:lower()] = true
end

local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

-- =================================================================
-- [[ 📡 REMOTE EVENT HANDLER ]]
-- =================================================================
local frameworkRemote
do
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Framework", 5):WaitForChild("Network", 5):WaitForChild("Remote", 5):WaitForChild("RemoteEvent", 5)
    end)
    if success and remote then
        frameworkRemote = remote
        logmsg("Successfully located Framework RemoteEvent.")
    else
        warnmsg("Could not find the specific Framework RemoteEvent! The script will not function.")
    end
end

-- =================================================================
-- [[ 📊 SCRIPT STATE ]]
-- =================================================================
local State = {
    HatchRunning = false,
    ChestRunning = false,
    AntiAfkRunning = true,
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-",
    Status = "Idle"
}
local lastCollectedChests = {}

-- =================================================================
-- [[ 🚀 CORE FUNCTIONS (HATCH, CHEST, ANTI-AFK) ]]
-- =================================================================

local toggleButtonUpdaters = {}
_G.UpdateToggleButton = function(name, state)
    if toggleButtonUpdaters[name] then toggleButtonUpdaters[name](state) end
end

pcall(function()
    local function destroyHatchGui(child)
        if child and child.Parent and (child.Name:match("Hatch") or child.Name:match("Egg")) then
            task.wait()
            child:Destroy()
        end
    end
    for _, v in ipairs(playerGui:GetChildren()) do destroyHatchGui(v) end
    playerGui.ChildAdded:Connect(destroyHatchGui)
end)

task.spawn(function()
    while true do
        if State.HatchRunning and frameworkRemote then
            State.Status = "Hatching Eggs..."
            local success, err = pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched = State.EggsHatched + Config.HatchAmount
            end)
            if not success then
                warnmsg("Auto Hatch failed: " .. tostring(err))
                State.HatchRunning = false
                _G.UpdateToggleButton("AutoHatch", false)
            end
            task.wait(Config.HatchDelay)
        else
            task.wait(0.2)
        end
    end
end)

local function collectChest(chest)
    if not chest or not chest.Parent then return false end
    local character = player.Character
    if not character then return false end

    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < Config.ChestCollectCooldown) then
        return false
    end

    State.Status = "Collecting " .. chest.Name
    if frameworkRemote then
        local success, _ = pcall(function()
            frameworkRemote:FireServer("ClaimChest", chest.Name, true)
        end)
        if success then
            lastCollectedChests[key] = tick()
            State.ChestsCollected = State.ChestsCollected + 1
            State.LastChest = chest.Name
            return true
        end
    end
    return false
end

task.spawn(function()
    while true do
        if State.ChestRunning then
            State.Status = "Searching for chests..."
            local searchAreas = {Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}
            for _, area in ipairs(searchAreas) do
                if area and State.ChestRunning then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if not State.ChestRunning then break end
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            pcall(collectChest, obj)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(Config.ChestCheckInterval)
    end
end)

task.spawn(function()
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if State.AntiAfkRunning then
                VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end)

-- ================================================================================
-- // SECTION: 🎨 GUI INTERFACE - ELEGANT & MINIMALIST
-- ================================================================================
pcall(function()
    playerGui:FindFirstChild("NiTroHUB_PRO_GUI"):Destroy()
end)

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Primary = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(255, 215, 0), -- Gold
    Text = Color3.fromRGB(240, 240, 240), -- Creamy white
    TextSecondary = Color3.fromRGB(150, 150, 150),
    Green = Color3.fromRGB(76, 175, 80),
    Red = Color3.fromRGB(220, 50, 50),
    Font = Enum.Font.SourceSans,
    FontBold = Enum.Font.SourceSansBold,
    Icons = {
        MiniIcon = "✨",
        Hatch = "🥚",
        Chest = "📦",
        Settings = "⚙️"
    }
}

local gui = Instance.new("ScreenGui")
gui.Name = "NiTroHUB_PRO_GUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function Create(instanceType)
    return function(properties)
        local obj = Instance.new(instanceType)
        for prop, value in pairs(properties) do
            pcall(function() obj[prop] = value end)
        end
        return obj
    end
end

local defaultSize = UDim2.fromOffset(360, 420)
local lastKnownSize = defaultSize

-- [ Main Frame ]
local mainFrame = Create("Frame"){
    Name = "MainFrame",
    Size = defaultSize,
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Visible = false,
    Parent = gui,
    ClipsDescendants = true
}
Create("UICorner"){CornerRadius = UDim.new(0, 12), Parent = mainFrame}
local mainFrameStroke = Create("UIStroke"){Thickness = 1, Color = Theme.Accent, Transparency = 0.8, Parent = mainFrame}

-- [ Header ]
local header = Create("Frame"){ Name = "Header", Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Secondary, BorderSizePixel = 0, Parent = mainFrame }
Create("UIGradient"){
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(1, Theme.Secondary)
    }),
    Parent = header
}
Create("TextLabel"){ Name = "Title", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = "NiTroHUB PRO", TextColor3 = Theme.Accent, TextSize = 22, TextXAlignment = Enum.TextXAlignment.Center, Parent = header }
Create("UICorner"){CornerRadius = UDim.new(0, 12), Parent = header}

-- [ Content Area ]
local content = Create("Frame"){ Name = "Content", Size = UDim2.new(1, -20, 1, -70), Position = UDim2.fromOffset(10, 60), BackgroundTransparency = 1, Parent = mainFrame }
Create("UIListLayout"){ Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content }

local function createToggleButton(config)
    local buttonFrame = Create("Frame"){
        Name = config.Name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Secondary,
        LayoutOrder = config.Order,
        BorderSizePixel = 0,
        Parent = content
    }
    Create("UICorner"){CornerRadius = UDim.new(0, 10), Parent = buttonFrame}
    
    local iconLabel = Create("TextLabel"){
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = config.Icon,
        TextColor3 = Theme.Accent,
        TextScaled = true,
        Parent = buttonFrame
    }
    
    Create("TextLabel"){
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.fromOffset(45, 0),
        BackgroundTransparency = 1,
        Font = Theme.Font,
        Text = config.Text,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = buttonFrame
    }
    
    local toggleButton = Create("TextButton"){
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        BackgroundTransparency = 1,
        Parent = buttonFrame
    }
    
    local stateIndicator = Create("Frame"){
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Red,
        BorderSizePixel = 0,
        Parent = buttonFrame
    }
    Create("UICorner"){Parent = stateIndicator}

    local function updateVisuals(state)
        local color = state and Theme.Green or Theme.Red
        TweenService:Create(stateIndicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = state and Theme.Green or Theme.Accent}):Play()
    end
    
    toggleButton.MouseButton1Click:Connect(function() config.Callback() end)
    
    updateVisuals(config.InitialState)
    toggleButtonUpdaters[config.Name] = updateVisuals
end

createToggleButton({ Name = "AutoHatch", Order = 1, Text = "Auto Hatch", Icon = Theme.Icons.Hatch, InitialState = State.HatchRunning,
    Callback = function() State.HatchRunning = not State.HatchRunning; _G.UpdateToggleButton("AutoHatch", State.HatchRunning) end })
createToggleButton({ Name = "AutoChest", Order = 2, Text = "Auto Chest", Icon = Theme.Icons.Chest, InitialState = State.ChestRunning,
    Callback = function() State.ChestRunning = not State.ChestRunning; _G.UpdateToggleButton("AutoChest", State.ChestRunning) end })
createToggleButton({ Name = "AntiAFK", Order = 3, Text = "Anti-AFK", Icon = Theme.Icons.Settings, InitialState = State.AntiAfkRunning,
    Callback = function() State.AntiAfkRunning = not State.AntiAfkRunning; _G.UpdateToggleButton("AntiAFK", State.AntiAfkRunning) end })

local statsLabel = Create("TextLabel"){
    Name = "StatsLabel",
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundTransparency = 1,
    Font = Theme.Font,
    RichText = true,
    TextColor3 = Theme.TextSecondary,
    TextSize = 14,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 4,
    Parent = content
}

local miniIcon = Create("TextButton"){
    Name = "MiniIcon",
    Size = UDim2.fromOffset(60, 60),
    Position = UDim2.new(0.05, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Theme.Primary,
    BackgroundTransparency = 0.3,
    Text = Theme.Icons.MiniIcon,
    Font = Theme.FontBold,
    TextColor3 = Theme.Accent,
    TextScaled = true,
    Active = true,
    Draggable = true,
    Parent = gui
}
Create("UICorner"){CornerRadius = UDim.new(1, 0), Parent = miniIcon}
local miniIconStroke = Create("UIStroke"){Color = Theme.Accent, Thickness = 2, Transparency = 0.5, Parent = miniIcon}
Create("UIAspectRatioConstraint"){AspectRatio = 1, Parent = miniIcon}

-- ================================================================================
-- // SECTION: 🖱️ GUI LOGIC & EVENTS
-- ================================================================================

local isGuiVisible = false
local isTweening = false

local function showGUI()
    if isTweening then return end
    isTweening = true
    mainFrame.Visible = true
    
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = lastKnownSize,
        Position = UDim2.fromScale(0.5, 0.5)
    })
    
    local strokeTween = TweenService:Create(mainFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.8})

    tween:Play()
    strokeTween:Play()

    tween.Completed:Wait()
    isTweening = false
    isGuiVisible = true
end

local function hideGUI()
    if isTweening then return end
    isTweening = true
    lastKnownSize = mainFrame.Size
    
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(lastKnownSize.X.Offset, 0),
        Position = UDim2.fromScale(0.5, 0.5)
    })
    
    local strokeTween = TweenService:Create(mainFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1})
    
    tween:Play()
    strokeTween:Play()

    tween.Completed:Wait()
    mainFrame.Visible = false
    isTweening = false
    isGuiVisible = false
end

miniIcon.MouseButton1Click:Connect(function()
    if not isGuiVisible then
        showGUI()
    else
        hideGUI()
    end
end)

local isResizing = false
local mouse = player:GetMouse()
local resizeHandle = Create("TextButton"){
    Name = "ResizeHandle",
    Size = UDim2.fromOffset(20, 20),
    Position = UDim2.new(1, -20, 1, -20),
    BackgroundColor3 = Theme.Accent,
    BackgroundTransparency = 0.8,
    BorderSizePixel = 0,
    Parent = mainFrame,
    ZIndex = 2,
    Text = ""
}
Create("UICorner"){CornerRadius = UDim.new(0, 5), Parent = resizeHandle}
Create("UIGradient"){
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Accent) -- Fixed gradient to be uniform for compatibility
    }),
    Parent = resizeHandle
}

resizeHandle.MouseButton1Down:Connect(function()
    isResizing = true
    mainFrame.Draggable = false
end)

mouse.Button1Up:Connect(function()
    if isResizing then
        isResizing = false
        mainFrame.Draggable = true
        lastKnownSize = mainFrame.Size
    end
end)

mouse.Move:Connect(function()
    if isResizing then
        local newWidth = math.max(mouse.X - mainFrame.AbsolutePosition.X, 250)
        local newHeight = math.max(mouse.Y - mainFrame.AbsolutePosition.Y, 300)
        
        mainFrame.Size = UDim2.fromOffset(newWidth, newHeight)
    end
end)

RunService.RenderStepped:Connect(function()
    if not gui or not gui.Parent then return end
    
    if not State.HatchRunning and not State.ChestRunning then
        State.Status = "Idle"
    end

    statsLabel.Text = string.format(
        "<font face='SourceSansBold'><b>Status:</b></font> <font color='#%s'>%s</font>\n\n<font face='SourceSansBold'><b>Eggs Hatched:</b></font> %d\n<font face='SourceSansBold'><b>Chests Collected:</b></font> %d\n<font face='SourceSansBold'><b>Last Chest:</b></font> %s",
        Theme.Accent:ToHex(), State.Status, State.EggsHatched, State.ChestsCollected, State.LastChest
    )
end)

-- =================================================================
-- [[ ✨ INITIALIZATION ]]
-- =================================================================
logmsg("NiTroHUB PRO - Elegant & Minimalist Edition Loaded!")
logmsg("แตะที่ไอคอน ✨ เพื่อเปิด/ปิด GUI")
logmsg("ลากที่มุมขวาล่างของหน้าต่างเพื่อปรับขนาด GUI")
