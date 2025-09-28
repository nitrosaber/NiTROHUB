--// 🌀 NiTroHUB - Compact & Performance v4.0
--// ✨ by NiTroHUB x Gemini (ปรับปรุงประสิทธิภาพและดีไซน์)
--// Description: ยกเครื่อง UI ให้เล็กลง สวยงาม และปรับปรุงโค้ดเพื่อลดอาการกระตุกขณะทำงาน

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
-- [ Performance: Aggressively destroy hatching UI to prevent lag ]
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

-- [ Auto Hatch Module ]
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
                if _G.UpdateToggleButton then _G.UpdateToggleButton("AutoHatch", false) end
            end
            task.wait(Config.HatchDelay)
        else
            task.wait(0.2)
        end
    end
end)

-- [ Auto Chest Module ]
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

-- [ Anti-AFK Module ]
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
-- // SECTION: 🎨 GUI INTERFACE - COMPACT EDITION
-- ================================================================================
pcall(function() playerGui:FindFirstChild("NiTroHUB_GUI"):Destroy() end)

local Theme = {
    Background = Color3.fromRGB(28, 28, 32),
    Primary = Color3.fromRGB(40, 40, 45),
    Accent = Color3.fromRGB(0, 225, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Green = Color3.fromRGB(76, 175, 80),
    Red = Color3.fromRGB(220, 50, 50),
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    Icons = { MiniIcon = "🌀", Hatch = "🥚", Chest = "📦", Settings = "⚙️" }
}

local gui = Instance.new("ScreenGui")
gui.Name = "NiTroHUB_GUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function Create(instanceType)
    return function(properties)
        local obj = Instance.new(instanceType)
        for prop, value in pairs(properties) do pcall(function() obj[prop] = value end) end
        return obj
    end
end

local mainFrame = Create("Frame"){
    Name = "MainFrame",
    Size = UDim2.fromOffset(280, 260), --<-- Smaller UI
    Position = UDim2.fromScale(0.5, 0.4),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderColor3 = Theme.Accent,
    BorderSizePixel = 1,
    Active = true,
    Draggable = true,
    Visible = false,
    Parent = gui,
    ClipsDescendants = true
}
Create("UICorner"){CornerRadius = UDim.new(0, 10), Parent = mainFrame}
Create("UIGradient"){ Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))}), Rotation = 90, Parent = mainFrame }

local header = Create("Frame"){ Name = "Header", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.5, Parent = mainFrame }
Create("UIStroke"){Color = Theme.Accent, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1.5, Parent = header} --<-- Added Stroke
Create("TextLabel"){ Name = "Title", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = "NiTroHUB", TextColor3 = Theme.Accent, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = header }

local content = Create("Frame"){ Name = "Content", Size = UDim2.new(1, -20, 1, -45), Position = UDim2.fromOffset(10, 35), BackgroundTransparency = 1, Parent = mainFrame }
Create("UIListLayout"){ Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content }

local toggleButtonUpdaters = {}
local function createToggleButton(config)
    local buttonFrame = Create("Frame"){ Name = config.Name, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, LayoutOrder = config.Order, Parent = content }
    Create("UICorner"){CornerRadius = UDim.new(0, 8), Parent = buttonFrame}
    Create("UIStroke"){Color = Theme.Accent, Transparency = 0.8, Parent = buttonFrame}
    Create("TextLabel"){ Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(10, 6), BackgroundTransparency = 1, Font = Theme.FontBold, Text = config.Icon, TextColor3 = Theme.Accent, TextScaled = true, Parent = buttonFrame }
    Create("TextLabel"){ Size = UDim2.new(1, -50, 1, 0), Position = UDim2.fromOffset(45, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = config.Text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = buttonFrame }
    local toggleButton = Create("TextButton"){ Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1, Parent = buttonFrame }
    local stateIndicator = Create("Frame"){ Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Red, BorderSizePixel = 0, Parent = buttonFrame }
    Create("UICorner"){Parent = stateIndicator}

    local function updateVisuals(state)
        local color = state and Theme.Green or Theme.Red
        TweenService:Create(stateIndicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end
    
    toggleButton.MouseButton1Click:Connect(config.Callback)
    updateVisuals(config.InitialState)
    toggleButtonUpdaters[config.Name] = updateVisuals
    _G.UpdateToggleButton = function(name, state) if toggleButtonUpdaters[name] then toggleButtonUpdaters[name](state) end end
end

createToggleButton({ Name = "AutoHatch", Order = 1, Text = "Auto Hatch", Icon = Theme.Icons.Hatch, InitialState = State.HatchRunning, Callback = function() State.HatchRunning = not State.HatchRunning; toggleButtonUpdaters.AutoHatch(State.HatchRunning) end })
createToggleButton({ Name = "AutoChest", Order = 2, Text = "Auto Chest", Icon = Theme.Icons.Chest, InitialState = State.ChestRunning, Callback = function() State.ChestRunning = not State.ChestRunning; toggleButtonUpdaters.AutoChest(State.ChestRunning) end })
createToggleButton({ Name = "AntiAFK", Order = 3, Text = "Anti-AFK", Icon = Theme.Icons.Settings, InitialState = State.AntiAfkRunning, Callback = function() State.AntiAfkRunning = not State.AntiAfkRunning; toggleButtonUpdaters.AntiAFK(State.AntiAfkRunning) end })

local statsLabel = Create("TextLabel"){ Name = "StatsLabel", Size = UDim2.new(1, 0, 1, -140), Position = UDim2.fromOffset(0,135), BackgroundTransparency = 1, Font = Theme.Font, RichText = true, TextColor3 = Theme.TextSecondary, TextSize = 13, TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 4, Parent = content }

local miniIcon = Create("TextButton"){ Name = "MiniIcon", Size = UDim2.fromOffset(50, 50), Position = UDim2.new(0.02, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.3, Text = Theme.Icons.MiniIcon, Font = Theme.FontBold, TextColor3 = Theme.Accent, TextScaled = true, Active = true, Draggable = true, Parent = gui }
Create("UICorner"){CornerRadius = UDim.new(1, 0), Parent = miniIcon}
Create("UIStroke"){Color = Theme.Accent, Thickness = 1.5, Parent = miniIcon}
Create("UIAspectRatioConstraint"){AspectRatio = 1, Parent = miniIcon}

-- ================================================================================
-- // SECTION: 🖱️ GUI LOGIC & EVENTS
-- ================================================================================

local isGuiVisible = false
miniIcon.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    local targetSize = isGuiVisible and UDim2.fromOffset(280, 260) or UDim2.fromOffset(280, 0)
    local targetPos = UDim2.fromScale(0.5, 0.4)

    mainFrame.Visible = true
    mainFrame:TweenSizeAndPosition(targetSize, targetPos, "Out", "Quad", 0.3, true, function(state)
        if state == Enum.TweenStatus.Completed then mainFrame.Visible = isGuiVisible end
    end)
end)

-- [ Performance: Stats update loop. Replaces RenderStepped to reduce lag. ]
task.spawn(function()
    while gui and gui.Parent and task.wait(0.25) do
        if not State.HatchRunning and not State.ChestRunning then State.Status = "Idle" end

        statsLabel.Text = string.format(
            "<b>Status:</b> <font color='#%s'>%s</font>\n\n🥚 Hatched: %d\n📦 Collected: %d\n🏷️ Last: %s",
            Theme.Accent:ToHex(), State.Status, State.EggsHatched, State.ChestsCollected, State.LastChest
        )
    end
end)

-- =================================================================
-- [[ ✨ INITIALIZATION ]]
-- =================================================================
logmsg("NiTroHUB - Compact Edition Loaded!")
logmsg("แตะที่ไอคอน 🌀 ด้านข้างเพื่อเปิด/ปิดเมนู")
