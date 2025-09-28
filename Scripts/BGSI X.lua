--// 🌀 NiTroHUB PRO - Stability & Compatibility Fix
--// ✨ by NiTroHUB x Gemini (แก้ไขสคริปต์ไม่ทำงาน เพิ่มระบบตรวจสอบสถานะ)
--// Description: ปรับปรุงความเสถียร เพิ่มการป้องกันข้อผิดพลาด และระบบตรวจสอบการเชื่อมต่อ

-- =================================================================
-- // [ SAFETY WAIT ]
-- =================================================================
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1)

-- =================================================================
-- // [ ⚙️ CONFIGURATION ]
-- =================================================================
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 8,
    HATCH_COUNT_INTERVAL = 1,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
        "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
        "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
    }
}

-- =================================================================
-- // [ 🧩 CORE SETUP ]
-- =================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local CHEST_LIST = setmetatable({}, {__index = function() return false end})
for _, name in ipairs(Config.ChestNames) do CHEST_LIST[name:lower()] = true end

local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

-- =================================================================
-- // [ 📊 SCRIPT STATE ]
-- =================================================================
local State = {
    HatchRunning = false,
    ChestRunning = false,
    AntiAfkRunning = true,
    RemoteConnected = false, -- ✨ [NEW] สถานะการเชื่อมต่อ
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-"
}
local lastCollectedChests = {}
local lastHatchCountTick = 0
local frameworkRemote

-- =================================================================
-- // [ 📡 REMOTE EVENT FINDER ]
-- =================================================================
task.spawn(function()
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Framework", 5):WaitForChild("Network", 5):WaitForChild("Remote", 5):WaitForChild("RemoteEvent", 5)
    end)
    if success and remote then
        frameworkRemote = remote
        State.RemoteConnected = true
        logmsg("Framework RemoteEvent Connected.")
    else
        State.RemoteConnected = false
        warnmsg("Framework RemoteEvent Not Found! Farming functions will be disabled.")
    end
end)

-- =================================================================
-- // [ 🚀 CORE LOGIC ]
-- =================================================================

--// Animation & VFX Hider
task.spawn(function()
    playerGui.ChildAdded:Connect(function(child)
        if child.Name:match("Hatch") or child.Name:match("Egg") then task.wait(); child.Enabled = false end
    end)
    Workspace.ChildAdded:Connect(function(child)
        if State.HatchRunning and (child.Name:match("egg") or child.Name:match("hatch")) then Debris:AddItem(child, 0) end
    end)
end)

--// Auto Hatch Logic
task.spawn(function()
    while task.wait() do -- ✨ [STABILITY] ใช้ task.wait() เพื่อความเสถียรสูงสุด
        if State.HatchRunning and frameworkRemote then
            pcall(function() frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount) end)
            if tick() - lastHatchCountTick >= Config.HATCH_COUNT_INTERVAL then
                State.EggsHatched = State.EggsHatched + Config.HatchAmount
                lastHatchCountTick = tick()
            end
        end
    end
end)

--// Auto Chest Logic
task.spawn(function()
    while task.wait(Config.ChestCheckInterval) do
        if State.ChestRunning and frameworkRemote then
            for _, area in ipairs({Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}) do
                if not area then continue end
                for _, obj in ipairs(area:GetDescendants()) do
                    if not State.ChestRunning then break end
                    if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                        local key = obj:GetDebugId()
                        if not lastCollectedChests[key] or tick() - lastCollectedChests[key] > Config.ChestCollectCooldown then
                            if pcall(function() frameworkRemote:FireServer("ClaimChest", obj.Name, true) end) then
                                lastCollectedChests[key] = tick()
                                State.ChestsCollected, State.LastChest = State.ChestsCollected + 1, obj.Name
                            end
                        end
                        task.wait()
                    end
                end
            end
        end
    end
end)

--// Anti-AFK Logic
task.spawn(function()
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if State.AntiAfkRunning then
                VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame); task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end)

-- ================================================================================
-- // [ 🎨 USER INTERFACE ]
-- ================================================================================
pcall(function() playerGui:FindFirstChild("NiTroHUB_PRO_GUI"):Destroy() end)

local Theme = { Background = Color3.fromRGB(28, 28, 32), Primary = Color3.fromRGB(40, 40, 45), Accent = Color3.fromRGB(0, 225, 255), Text = Color3.fromRGB(255, 255, 255), Green = Color3.fromRGB(76, 175, 80), Red = Color3.fromRGB(220, 50, 50), Font = Enum.Font.Gotham, FontBold = Enum.Font.GothamBold }
local gui = Instance.new("ScreenGui", playerGui); gui.Name, gui.IgnoreGuiInset, gui.ResetOnSpawn = "NiTroHUB_PRO_GUI", true, false
local function Create(instanceType, properties) local obj = Instance.new(instanceType); for prop, val in pairs(properties or {}) do obj[prop] = val end; return obj end

local mainFrame = Create("Frame", { Name = "MainFrame", Size = UDim2.fromOffset(300, 280), Position = UDim2.fromScale(0.5, 0.4), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderColor3 = Theme.Accent, BorderSizePixel = 1, Active = true, Draggable = true, Visible = false, ClipsDescendants = true, Parent = gui })
Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainFrame})
Create("UIGradient", { Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))}), Rotation = 90, Parent = mainFrame })

local header = Create("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.5, Parent = mainFrame })
Create("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = "NiTroHUB PRO", TextColor3 = Theme.Accent, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })

local contentFrame = Create("Frame", { Name = "Content", Size = UDim2.new(1, -20, 1, -115), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = mainFrame })
Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = contentFrame })

local statsLabel = Create("TextLabel", { Name = "StatsLabel", Size = UDim2.new(1, -20, 0, 60), Position = UDim2.new(0, 10, 1, -100), BackgroundTransparency = 1, RichText = true, Font = Theme.Font, TextSize = 15, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = mainFrame })
local remoteStatusLabel = Create("TextLabel", { Name = "RemoteStatus", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 1, -30), BackgroundTransparency = 1, Font = Theme.Font, Text = "Remote Status: Searching...", TextColor3 = Color3.fromRGB(255, 255, 0), TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Bottom, Parent = mainFrame })

local toggleButtonUpdaters = {}
local function CreateToggleButton(config)
    local buttonFrame = Create("Frame", { Name = config.Name, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Primary, LayoutOrder = config.Order, Parent = contentFrame })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = buttonFrame}); Create("UIStroke", {Color = Theme.Accent, Transparency = 0.8, Parent = buttonFrame})
    Create("TextLabel", { Name = "Label", Size = UDim2.new(1, -55, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = config.Text, TextColor3 = Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = buttonFrame })
    Create("TextLabel", { Name = "Icon", Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -45, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = config.Emoji, TextSize = 28, Parent = buttonFrame })
    local stateIndicator = Create("Frame", { Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Red, Parent = buttonFrame })
    Create("UICorner", {Parent = stateIndicator})
    
    local function updateVisuals(state) TweenService:Create(stateIndicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Green or Theme.Red}):Play() end
    Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1, Parent = buttonFrame }).MouseButton1Click:Connect(config.Callback)
    
    updateVisuals(config.InitialState)
    toggleButtonUpdaters[config.Name] = updateVisuals
end

CreateToggleButton({ Name = "AutoHatch", Order = 1, Text = "Auto Hatch", Emoji = "🥚", InitialState = State.HatchRunning, Callback = function() if not frameworkRemote then warnmsg("Cannot use Auto Hatch: Remote not connected.") return end; State.HatchRunning = not State.HatchRunning; toggleButtonUpdaters.AutoHatch(State.HatchRunning) end })
CreateToggleButton({ Name = "AutoChest", Order = 2, Text = "Auto Chest", Emoji = "📦", InitialState = State.ChestRunning, Callback = function() if not frameworkRemote then warnmsg("Cannot use Auto Chest: Remote not connected.") return end; State.ChestRunning = not State.ChestRunning; toggleButtonUpdaters.AutoChest(State.ChestRunning) end })
CreateToggleButton({ Name = "AntiAFK", Order = 3, Text = "Anti-AFK", Emoji = "⚙️", InitialState = State.AntiAfkRunning, Callback = function() State.AntiAfkRunning = not State.AntiAfkRunning; toggleButtonUpdaters.AntiAFK(State.AntiAfkRunning) end })

_G.UpdateToggleButton = function(name, state) if toggleButtonUpdaters[name] then toggleButtonUpdaters[name](state) end end

local miniIcon = Create("TextButton", { Name = "MiniIcon", Text = "🌀", Size = UDim2.fromOffset(55, 55), Position = UDim2.new(0.02, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.Background, TextColor3 = Theme.Accent, Font = Theme.Font, TextSize = 40, Draggable = true, Parent = gui })
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = miniIcon}); Create("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Parent = miniIcon})

-- ================================================================================
-- // [ 🖱️ UI LOGIC ]
-- ================================================================================

local isGuiVisible = false
miniIcon.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    mainFrame.Visible = true
    mainFrame:TweenSize(isGuiVisible and UDim2.fromOffset(300, 280) or UDim2.fromOffset(300, 0), "Out", "Quad", 0.3, true)
end)

RunService.RenderStepped:Connect(function()
    if not gui.Parent then return end
    statsLabel.Text = string.format("<b>Eggs Hatched:</b> %d\n<b>Chests Collected:</b> %d\n<b>Last Chest:</b> %s", State.EggsHatched, State.ChestsCollected, State.LastChest)
    if State.RemoteConnected then
        remoteStatusLabel.Text = "Remote Status: Connected"
        remoteStatusLabel.TextColor3 = Theme.Green
    else
        remoteStatusLabel.Text = "Remote Status: Not Found"
        remoteStatusLabel.TextColor3 = Theme.Red
    end
end)

-- =================================================================
-- // [ ✨ INITIALIZATION ]
-- =================================================================
logmsg("NiTroHUB PRO - Stability Fix Loaded.")
logmsg("Tap '🌀' to open menu. Check Remote Status if features don't work.")
