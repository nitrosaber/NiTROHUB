--// 🌀 NiTroHUB PRO - Final Cleanup
--// ✨ by NiTroHUB x Gemini (ปรับปรุง UI, ตัดส่วนที่ไม่จำเป็น, และเรียบเรียงโค้ดใหมทั้งหมด)
--// Description: เวอร์ชันที่สมบูรณ์และสะอาดที่สุด เน้นความเสถียรและอ่านง่าย

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
    HatchDelay = 0, -- ความเร็วในการส่งคำสั่ง (0 = สูงสุด)
    HATCH_COUNT_INTERVAL = 1, -- หน่วงเวลาการนับไข่ (วินาที) เพื่อให้สมจริง
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
--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

--// Player & Game Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local CHEST_LIST = setmetatable({}, {__index = function() return false end})
for _, name in ipairs(Config.ChestNames) do
    CHEST_LIST[name:lower()] = true
end

--// Utilities
local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

-- =================================================================
-- // [ 📡 REMOTE EVENT HANDLER ]
-- =================================================================
local frameworkRemote
do
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Framework", 5):WaitForChild("Network", 5):WaitForChild("Remote", 5):WaitForChild("RemoteEvent", 5)
    end)
    if success and remote then
        frameworkRemote, logmsg("Framework RemoteEvent Found.") = remote
    else
        warnmsg("Framework RemoteEvent Not Found! Script might not work.")
    end
end

-- =================================================================
-- // [ 📊 SCRIPT STATE ]
-- =================================================================
local State = {
    HatchRunning = false,
    ChestRunning = false,
    AntiAfkRunning = true,
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-"
}
local lastCollectedChests = {}
local lastHatchCountTick = 0

-- =================================================================
-- // [ 🚀 CORE LOGIC ]
-- =================================================================

--// Animation & VFX Hider
task.spawn(function()
    -- Hide GUI Popups
    playerGui.ChildAdded:Connect(function(child)
        if child.Name:match("Hatch") or child.Name:match("Egg") then
            task.wait(); child.Enabled = false
        end
    end)
    -- Hide Workspace Models/Hitboxes
    Workspace.ChildAdded:Connect(function(child)
        if State.HatchRunning and (child.Name:match("egg") or child.Name:match("hatch")) then
            Debris:AddItem(child, 0)
        end
    end)
end)

--// Auto Hatch Logic
task.spawn(function()
    while true do
        if State.HatchRunning and frameworkRemote then
            -- 1. Send hatch command at max speed
            pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
            end)

            -- 2. Count eggs at a realistic interval
            if tick() - lastHatchCountTick >= Config.HATCH_COUNT_INTERVAL then
                State.EggsHatched = State.EggsHatched + Config.HatchAmount
                lastHatchCountTick = tick()
            end
            
            if Config.HatchDelay > 0 then task.wait(Config.HatchDelay) else RunService.Heartbeat:Wait() end
        else
            task.wait(0.2)
        end
    end
end)

--// Auto Chest Logic
task.spawn(function()
    while true do
        if State.ChestRunning then
            for _, area in ipairs({Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}) do
                if not (area and State.ChestRunning) then continue end
                for _, obj in ipairs(area:GetDescendants()) do
                    if not State.ChestRunning then break end
                    if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                        local key = obj:GetDebugId()
                        if not lastCollectedChests[key] or tick() - lastCollectedChests[key] > Config.ChestCollectCooldown then
                            local success, _ = pcall(function() frameworkRemote:FireServer("ClaimChest", obj.Name, true) end)
                            if success then
                                lastCollectedChests[key] = tick()
                                State.ChestsCollected, State.LastChest = State.ChestsCollected + 1, obj.Name
                            end
                        end
                        task.wait()
                    end
                end
            end
        end
        task.wait(Config.ChestCheckInterval)
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

--// Theme & Assets
local Theme = { Background = Color3.fromRGB(28, 28, 32), Primary = Color3.fromRGB(40, 40, 45), Accent = Color3.fromRGB(0, 225, 255), Text = Color3.fromRGB(255, 255, 255), Green = Color3.fromRGB(76, 175, 80), Red = Color3.fromRGB(220, 50, 50), Font = Enum.Font.Gotham, FontBold = Enum.Font.GothamBold }

--// UI Creation
local gui = Instance.new("ScreenGui", playerGui); gui.Name, gui.IgnoreGuiInset, gui.ResetOnSpawn = "NiTroHUB_PRO_GUI", true, false
local function Create(instanceType, properties) local obj = Instance.new(instanceType); for prop, val in pairs(properties or {}) do obj[prop] = val end; return obj end

--// Main Frame
local mainFrame = Create("Frame", { Name = "MainFrame", Size = UDim2.fromOffset(300, 250), Position = UDim2.fromScale(0.5, 0.4), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderColor3 = Theme.Accent, BorderSizePixel = 1, Active = true, Draggable = true, Visible = false, ClipsDescendants = true, Parent = gui })
Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainFrame})
Create("UIGradient", { Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))}), Rotation = 90, Parent = mainFrame })

--// Header
local header = Create("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.5, Parent = mainFrame })
Create("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = "NiTroHUB PRO", TextColor3 = Theme.Accent, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })

--// Content Area
local contentFrame = Create("ScrollingFrame", { Name = "Content", Size = UDim2.new(1, -20, 1, -100), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = "Y", Parent = mainFrame })
Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = contentFrame })

--// Stats Display
local statsLabel = Create("TextLabel", { Name = "StatsLabel", Size = UDim2.new(1, -20, 0, 80), Position = UDim2.new(0, 10, 1, -90), BackgroundTransparency = 1, RichText = true, Font = Theme.Font, TextSize = 15, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = mainFrame })

--// Toggle Button Constructor
local toggleButtonUpdaters = {}
local function CreateToggleButton(config)
    local buttonFrame = Create("Frame", { Name = config.Name, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Primary, LayoutOrder = config.Order, Parent = contentFrame })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = buttonFrame})
    Create("UIStroke", {Color = Theme.Accent, Transparency = 0.8, Parent = buttonFrame})

    -- ✨ [FIXED] จัดวางชื่อและอีโมจิด้วยตนเองเพื่อให้แสดงผลถูกต้อง
    Create("TextLabel", { Name = "Label", Size = UDim2.new(1, -55, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = config.Text, TextColor3 = Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = buttonFrame })
    Create("TextLabel", { Name = "Icon", Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -45, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = config.Emoji, TextSize = 28, Parent = buttonFrame })

    local stateIndicator = Create("Frame", { Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Red, Parent = buttonFrame })
    Create("UICorner", {Parent = stateIndicator})
    
    local function updateVisuals(state) TweenService:Create(stateIndicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Green or Theme.Red}):Play() end
    Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1, Parent = buttonFrame }).MouseButton1Click:Connect(config.Callback)
    
    updateVisuals(config.InitialState)
    toggleButtonUpdaters[config.Name] = updateVisuals
end

--// Create Buttons
CreateToggleButton({ Name = "AutoHatch", Order = 1, Text = "Auto Hatch", Emoji = "🥚", InitialState = State.HatchRunning, Callback = function() State.HatchRunning = not State.HatchRunning; toggleButtonUpdaters.AutoHatch(State.HatchRunning) end })
CreateToggleButton({ Name = "AutoChest", Order = 2, Text = "Auto Chest", Emoji = "📦", InitialState = State.ChestRunning, Callback = function() State.ChestRunning = not State.ChestRunning; toggleButtonUpdaters.AutoChest(State.ChestRunning) end })
CreateToggleButton({ Name = "AntiAFK", Order = 3, Text = "Anti-AFK", Emoji = "⚙️", InitialState = State.AntiAfkRunning, Callback = function() State.AntiAfkRunning = not State.AntiAfkRunning; toggleButtonUpdaters.AntiAFK(State.AntiAfkRunning) end })

_G.UpdateToggleButton = function(name, state) if toggleButtonUpdaters[name] then toggleButtonUpdaters[name](state) end end

--// Mini Icon (Opener)
local miniIcon = Create("TextButton", { Name = "MiniIcon", Text = "🌀", Size = UDim2.fromOffset(55, 55), Position = UDim2.new(0.02, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.Background, TextColor3 = Theme.Accent, Font = Theme.Font, TextSize = 40, Draggable = true, Parent = gui })
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = miniIcon})
Create("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Parent = miniIcon})

-- ================================================================================
-- // [ 🖱️ UI LOGIC ]
-- ================================================================================

--// Toggle Main Frame Visibility
local isGuiVisible = false
miniIcon.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    mainFrame:TweenSize(isGuiVisible and UDim2.fromOffset(300, 250) or UDim2.fromOffset(300, 0), "Out", "Quad", 0.3, true)
end)

--// Update Stats Display
RunService.RenderStepped:Connect(function()
    if not gui.Parent then return end
    -- ✨ [REMOVED] ตัด Status ออก ให้เหลือแต่ข้อมูลหลัก
    statsLabel.Text = string.format("<b>Eggs Hatched:</b> %d\n<b>Chests Collected:</b> %d\n<b>Last Chest:</b> %s", State.EggsHatched, State.ChestsCollected, State.LastChest)
end)

-- =================================================================
-- // [ ✨ INITIALIZATION ]
-- =================================================================
logmsg("NiTroHUB PRO - Final Cleanup Loaded.")
logmsg("Tap '🌀' to open menu.")
