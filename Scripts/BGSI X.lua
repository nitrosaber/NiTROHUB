--// 🌀 NiTroHUB PRO - Emoji & Max Speed Edition
--// ✨ by NiTroHUB x Gemini (อัปเกรด UI เป็นอีโมจิ, สุ่มไข่ความเร็วสูงสุด, และซ่อนอนิเมชัน)
--// Description: ปรับปรุงให้เร็วและคลีนที่สุดสำหรับสายฟาร์มโดยเฉพาะ

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
    HatchDelay = 0, -- ✨ [SPEED] ตั้งเป็น 0 เพื่อความเร็วสูงสุดในการสุ่มไข่
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
-- [[ ✨ NEW: ANIMATION & VFX HIDER ]]
-- =================================================================
task.spawn(function()
    -- ส่วนที่ 1: ซ่อน GUI ที่เกี่ยวกับการสุ่มไข่
    pcall(function()
        local function hideHatchGui(child)
            if child.Name:match("Hatch") or child.Name:match("Egg") then
                task.wait(); child.Enabled = false
            end
        end
        for _, v in ipairs(playerGui:GetChildren()) do hideHatchGui(v) end
        playerGui.ChildAdded:Connect(hideHatchGui)
    end)
    
    -- ส่วนที่ 2: ซ่อนโมเดล/เอฟเฟกต์/Hitbox ที่เกิดใน Workspace ตอนสุ่มไข่
    Workspace.ChildAdded:Connect(function(child)
        if State.HatchRunning then
            local name = child.Name:lower()
            -- ตรวจจับคำที่เกี่ยวข้องกับการสุ่มไข่ และทำลายทิ้งทันที
            if name:match("egg") or name:match("hatch") or name:match("reward") or name:match("open") then
                -- ใช้ Debris เพื่อป้องกัน error และจัดการหน่วยความจำ
                game:GetService("Debris"):AddItem(child, 0)
            end
        end
    end)
end)

-- =================================================================
-- [[ 🚀 CORE FUNCTIONS (HATCH, CHEST, ANTI-AFK) ]]
-- =================================================================
-- [ Auto Hatch Module ]
task.spawn(function()
    while true do
        if State.HatchRunning and frameworkRemote then
            State.Status = "Hatching Eggs (Max Speed)"
            local success, err = pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched = State.EggsHatched + Config.HatchAmount
            end)
            if not success then
                warnmsg("Auto Hatch failed: " .. tostring(err))
                State.HatchRunning = false
                if _G.UpdateToggleButton then _G.UpdateToggleButton("AutoHatch", false) end
            end
            
            if Config.HatchDelay > 0 then
                task.wait(Config.HatchDelay)
            else
                RunService.Heartbeat:Wait() -- ใช้ Heartbeat:Wait() แทน task.wait(0) เพื่อประสิทธิภาพสูงสุด
            end
        else
            task.wait(0.2)
        end
    end
end)

-- [ Auto Chest Module ]
local function collectChest(chest)
    if not chest or not chest.Parent then return false end
    if not player.Character then return false end

    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < Config.ChestCollectCooldown) then
        return false
    end

    State.Status = "Collecting " .. chest.Name
    if frameworkRemote then
        local success, _ = pcall(function() frameworkRemote:FireServer("ClaimChest", chest.Name, true) end)
        if success then
            lastCollectedChests[key] = tick()
            State.ChestsCollected, State.LastChest = State.ChestsCollected + 1, chest.Name
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
                VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame); task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end)

-- ================================================================================
-- // SECTION: 🎨 GUI INTERFACE - EMOJI EDITION
-- ================================================================================
pcall(function() playerGui:FindFirstChild("NiTroHUB_PRO_GUI"):Destroy() end)

local Theme = { Background = Color3.fromRGB(28, 28, 32), Primary = Color3.fromRGB(40, 40, 45), Accent = Color3.fromRGB(0, 225, 255), Text = Color3.fromRGB(255, 255, 255), TextSecondary = Color3.fromRGB(180, 180, 180), Green = Color3.fromRGB(76, 175, 80), Red = Color3.fromRGB(220, 50, 50), Font = Enum.Font.Gotham, FontBold = Enum.Font.GothamBold }

local gui = Instance.new("ScreenGui", playerGui)
gui.Name, gui.IgnoreGuiInset, gui.ResetOnSpawn = "NiTroHUB_PRO_GUI", true, false

local function Create(instanceType) return function(properties) local obj = Instance.new(instanceType); for prop, value in pairs(properties) do pcall(function() obj[prop] = value end) end; return obj end end

local mainFrame = Create("Frame"){ Name = "MainFrame", Size = UDim2.fromOffset(300, 280), Position = UDim2.fromScale(0.5, 0.4), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderColor3 = Theme.Accent, BorderSizePixel = 1, Active = true, Draggable = true, Visible = false, Parent = gui, ClipsDescendants = true }
Create("UICorner"){CornerRadius = UDim.new(0, 12), Parent = mainFrame}
Create("UIGradient"){ Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))}), Rotation = 90, Parent = mainFrame }

local header = Create("Frame"){ Name = "Header", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.5, Parent = mainFrame }
Create("TextLabel"){ Name = "Title", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = "NiTroHUB PRO", TextColor3 = Theme.Accent, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = header }

local content = Create("Frame"){ Name = "Content", Size = UDim2.new(1, -20, 1, -50), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = mainFrame }
Create("UIListLayout"){ Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content }

local toggleButtonUpdaters = {}
local function createToggleButton(config)
    local buttonFrame = Create("Frame"){ Name = config.Name, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Primary, LayoutOrder = config.Order, Parent = content }
    Create("UICorner"){CornerRadius = UDim.new(0, 8), Parent = buttonFrame}; Create("UIStroke"){Color = Theme.Accent, Transparency = 0.8, Parent = buttonFrame}
    
    -- ✨ [UI] ใช้ Emoji แทนรูปภาพ
    Create("TextLabel"){ Text = config.Emoji, Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(10, 7.5), BackgroundTransparency = 1, TextSize = 28, Parent = buttonFrame }
    Create("TextLabel"){ Size = UDim2.new(1, -50, 1, 0), Position = UDim2.fromOffset(45, 0), BackgroundTransparency = 1, Font = Theme.FontBold, Text = config.Text, TextColor3 = Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = buttonFrame }
    
    local toggleButton = Create("TextButton"){ Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1, Parent = buttonFrame }
    local stateIndicator = Create("Frame"){ Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Red, BorderSizePixel = 0, Parent = buttonFrame }
    Create("UICorner"){Parent = stateIndicator}

    local function updateVisuals(state) TweenService:Create(stateIndicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Green or Theme.Red}):Play() end
    toggleButton.MouseButton1Click:Connect(config.Callback)
    updateVisuals(config.InitialState)
    toggleButtonUpdaters[config.Name] = updateVisuals
    _G.UpdateToggleButton = function(name, state) if toggleButtonUpdaters[name] then toggleButtonUpdaters[name](state) end end
end

createToggleButton({ Name = "AutoHatch", Order = 1, Text = "Auto Hatch", Emoji = "🥚", InitialState = State.HatchRunning, Callback = function() State.HatchRunning = not State.HatchRunning; toggleButtonUpdaters.AutoHatch(State.HatchRunning) end })
createToggleButton({ Name = "AutoChest", Order = 2, Text = "Auto Chest", Emoji = "📦", InitialState = State.ChestRunning, Callback = function() State.ChestRunning = not State.ChestRunning; toggleButtonUpdaters.AutoChest(State.ChestRunning) end })
createToggleButton({ Name = "AntiAFK", Order = 3, Text = "Anti-AFK", Emoji = "⚙️", InitialState = State.AntiAfkRunning, Callback = function() State.AntiAfkRunning = not State.AntiAfkRunning; toggleButtonUpdaters.AntiAFK(State.AntiAfkRunning) end })

local statsLabel = Create("TextLabel"){ Name = "StatsLabel", Size = UDim2.new(1, 0, 0, 90), BackgroundTransparency = 1, Font = Theme.Font, RichText = true, TextColor3 = Theme.TextSecondary, TextSize = 14, TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 4, Parent = content }

local miniIcon = Create("TextButton"){ Name = "MiniIcon", Text = "🌀", Size = UDim2.fromOffset(55, 55), Position = UDim2.new(0.02, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.Background, TextColor3 = Theme.Accent, Font = Theme.Font, TextSize = 40, Active = true, Draggable = true, Parent = gui }
Create("UICorner"){CornerRadius = UDim.new(1, 0), Parent = miniIcon}; Create("UIStroke"){Color = Theme.Accent, Thickness = 1.5, Parent = miniIcon}; Create("UIAspectRatioConstraint"){AspectRatio = 1, Parent = miniIcon}

-- ================================================================================
-- // SECTION: 🖱️ GUI LOGIC & EVENTS
-- ================================================================================
local isGuiVisible = false
miniIcon.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    local targetSize = isGuiVisible and UDim2.fromOffset(300, 280) or UDim2.fromOffset(300, 0)
    local targetPos = UDim2.fromScale(0.5, 0.4)
    mainFrame.Visible = true
    mainFrame:TweenSizeAndPosition(targetSize, targetPos, "Out", "Quad", 0.3, true, function(s) if s == Enum.TweenStatus.Completed then mainFrame.Visible = isGuiVisible end end)
end)

RunService.RenderStepped:Connect(function()
    if not gui.Parent then return end
    if not State.HatchRunning and not State.ChestRunning then State.Status = "Idle" end
    statsLabel.Text = string.format("<b>Status:</b> <font color='#%s'>%s</font>\n\n<b>Eggs Hatched:</b> %d\n<b>Chests Collected:</b> %d\n<b>Last Chest:</b> %s", Theme.Accent:ToHex(), State.Status, State.EggsHatched, State.ChestsCollected, State.LastChest)
end)

-- =================================================================
-- [[ ✨ INITIALIZATION ]]
-- =================================================================
logmsg("NiTroHUB PRO - Emoji & Max Speed Edition Loaded!")
logmsg("แตะที่ไอคอน 🌀 เพื่อเปิด/ปิดเมนู | Auto Hatch is now at maximum speed!")
