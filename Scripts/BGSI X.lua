--// 🌀 NiTroHUB PRO - Final Evolution (Direct Remote Fix)
--// ✨ by NiTroHUB x Gemini (อัปเดตด้วย RemoteEvent ที่ผู้ใช้ระบุ)

-- =================================================================
-- [[ SAFETY WAIT MECHANISM ]]
-- =================================================================
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1)

-- ==========================
-- ⚙️ CONFIG
-- ==========================
local EGG_NAME = "Autumn Egg"
local HATCH_AMOUNT = 8
local HATCH_DELAY = 0.1

local CHEST_CHECK_INTERVAL = 10
local CHEST_COLLECT_COOLDOWN = 60

local CHEST_NAMES = {
    "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
    "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
    "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
}

-- ==========================
-- 🧩 SERVICES & CORE SETUP
-- ==========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local isFireTouchInterestAvailable = type(firetouchinterest) == "function"

local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end

-- ==========================
-- 📡 REMOTE EVENTS & UTILITIES
-- ==========================
local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

-- [[ ✨ DIRECT REMOTE ✨ ]] --
-- ใช้เส้นทาง RemoteEvent ที่ผู้ใช้ให้มาโดยตรง เพื่อความแม่นยำสูงสุด
-- ทั้งการสุ่มไข่และเก็บกล่องจะใช้ RemoteEvent ตัวเดียวกันนี้
local frameworkRemote
local success, remote = pcall(function()
    return ReplicatedStorage:WaitForChild("Shared", 10):WaitForChild("Framework", 5):WaitForChild("Network", 5):WaitForChild("Remote", 5):WaitForChild("RemoteEvent", 5)
end)

if success and remote then
    frameworkRemote = remote
    logmsg("Successfully found the game's Framework RemoteEvent!")
else
    warnmsg("Could not find the specific Framework RemoteEvent! The script will likely not work.")
end

-- ==========================
-- 📊 STATE
-- ==========================
local hatchRunning = false
local chestRunning = false
local antiAfkRunning = true
local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollectedChests = {}
local lastCollectedChestName = "-"
local currentStatus = "Idle"

-- ==========================
-- 🚀 PERFORMANCE & ANIMATION PATCH
-- ==========================
pcall(function()
    local function hideHatchGui(child)
        if child.Name:match("Hatch") or child.Name:match("Egg") then
            task.wait(); child.Enabled = false
        end
    end
    for _, v in ipairs(playerGui:GetChildren()) do hideHatchGui(v) end
    playerGui.ChildAdded:Connect(hideHatchGui)
    logmsg("Hatch UI hiding system is active.")
end)

-- ==========================
-- 🥚 AUTO HATCH
-- ==========================
task.spawn(function()
    while true do
        if hatchRunning and frameworkRemote then
            currentStatus = "Hatching Eggs..."
            local hatchSuccess, err = pcall(function()
                -- [[ ✨ FIXED ✨ ]] แก้ไขการส่งคำสั่งให้ถูกต้องตามที่ผู้ใช้ระบุ
                frameworkRemote:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
                eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
            end)
            if not hatchSuccess then warnmsg("Auto Hatch failed:", err); hatchRunning = false end
            task.wait(HATCH_DELAY)
        else
            task.wait(0.2)
        end
    end
end)

-- ==========================
-- 💰 AUTO CHEST
-- ==========================
local function collectChest(chest)
    if not chest or not chest.Parent or not hrp then return false end
    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < CHEST_COLLECT_COOLDOWN) then return false end

    currentStatus = "Collecting " .. chest.Name
    local success = false

    -- [[ ✨ FIXED ✨ ]] ใช้ Framework Remote เป็นวิธีหลักในการเก็บกล่อง
    if frameworkRemote then
        local remoteSuccess, _ = pcall(function() frameworkRemote:FireServer("ClaimChest", chest.Name, true) end)
        if remoteSuccess then success = true; logmsg("[Framework Remote] Collected Chest:", chest.Name) end
    end

    -- ใช้วิธีสำรองหากวิธีแรกไม่สำเร็จ
    if not success and isFireTouchInterestAvailable then
        local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
        if trigger then
            firetouchinterest(hrp, trigger, 0); task.wait(0.1); firetouchinterest(hrp, trigger, 1)
            success = true; logmsg("[Touch Fallback] Collected Chest:", chest.Name)
        end
    end

    if success then
        lastCollectedChests[key] = tick()
        chestsCollectedCount = chestsCollectedCount + 1
        lastCollectedChestName = chest.Name
        return true
    end
    return false
end

task.spawn(function()
    while true do
        if chestRunning then
            currentStatus = "Searching for chests..."
            local searchAreas = {Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}
            for _, area in ipairs(searchAreas) do
                if area and chestRunning then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if not chestRunning then break end
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            pcall(collectChest, obj)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(CHEST_CHECK_INTERVAL)
    end
end)

-- ==========================
-- 💤 ANTI AFK
-- ==========================
task.spawn(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if antiAfkRunning then
                vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame); task.wait(1)
                vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame);
            end
        end)
    end)
end)

-- =================================================================
-- 🎨 GUI INTERFACE & CONTROLS (คงเดิม)
-- =================================================================
local oldGui = playerGui:FindFirstChild("NiTroHUB_PRO_GUI")
if oldGui then oldGui:Destroy() end
local oldLoadingGui = playerGui:FindFirstChild("NiTroHUB_LoadingGUI")
if oldLoadingGui then oldLoadingGui:Destroy() end

do
    local loadingGui = Instance.new("ScreenGui", playerGui)
    loadingGui.Name = "NiTroHUB_LoadingGUI"; loadingGui.IgnoreGuiInset = true; loadingGui.ResetOnSpawn = false
    local background = Instance.new("Frame", loadingGui); background.Size = UDim2.fromScale(1, 1); background.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    local title = Instance.new("TextLabel", background); title.Size = UDim2.new(0, 300, 0, 50); title.AnchorPoint = Vector2.new(0.5, 0.5); title.Position = UDim2.fromScale(0.5, 0.45); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.Text = "NiTroHUB PRO"; title.TextColor3 = Color3.fromRGB(0, 225, 255); title.TextSize = 32
    local bar = Instance.new("Frame", background); bar.Size = UDim2.new(0, 300, 0, 8); bar.AnchorPoint = Vector2.new(0.5, 0.5); bar.Position = UDim2.fromScale(0.5, 0.52); bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local progress = Instance.new("Frame", bar); progress.Size = UDim2.fromScale(0, 1); progress.BackgroundColor3 = Color3.fromRGB(0, 225, 255); Instance.new("UICorner", progress).CornerRadius = UDim.new(1, 0)
    TweenService:Create(progress, TweenInfo.new(2, Enum.EasingStyle.Quint), {Size = UDim2.fromScale(1, 1)}):Play()
    task.wait(2.5); TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play(); task.wait(0.5); loadingGui:Destroy()
end
task.wait(0.5)

local gui = Instance.new("ScreenGui", playerGui); gui.Name = "NiTroHUB_PRO_GUI"; gui.IgnoreGuiInset = true; gui.ResetOnSpawn = false
local frame = Instance.new("Frame", gui); frame.Size = UDim2.new(0, 280, 0, 260); frame.Position = UDim2.fromScale(0.05, 0.2); frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32); frame.Active = true; frame.Draggable = true; frame.Visible = false; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12); Instance.new("UIStroke", frame).Color = Color3.fromRGB(80, 80, 80)
local header = Instance.new("Frame", frame); header.Size = UDim2.new(1, 0, 0, 40); header.BackgroundColor3 = Color3.fromRGB(40, 40, 45); local headerCorner = Instance.new("UICorner", header); headerCorner.CornerRadius = UDim.new(0, 12)
local title = Instance.new("TextLabel", header); title.Size = UDim2.new(1, -50, 1, 0); title.Position = UDim2.fromOffset(10, 0); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.Text = "NiTroHUB PRO"; title.TextColor3 = Color3.fromRGB(0, 225, 255); title.TextSize = 18; title.TextXAlignment = Enum.TextXAlignment.Left
local container = Instance.new("Frame", frame); container.Size = UDim2.new(1, -20, 1, -50); container.Position = UDim2.fromOffset(10, 40); container.BackgroundTransparency = 1
local statsLabel = Instance.new("TextLabel", frame); statsLabel.Size = UDim2.new(1, -20, 0, 60); statsLabel.Position = UDim2.new(0, 10, 1, -65); statsLabel.BackgroundTransparency = 1; statsLabel.Font = Enum.Font.Gotham; statsLabel.TextSize = 13; statsLabel.TextColor3 = Color3.fromRGB(220, 220, 220); statsLabel.TextXAlignment = Enum.TextXAlignment.Left; statsLabel.TextYAlignment = Enum.TextYAlignment.Top
local function createToggleButton(config)
    local state = config.InitialState or false; local btn = Instance.new("TextButton", config.Parent); btn.Size = config.Size or UDim2.new(1, 0, 0, 35); btn.Position = config.Position; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", btn).Color = Color3.fromRGB(120, 120, 120)
    local function updateVisuals()
        local hotkeyText = config.Hotkey and " (" .. config.Hotkey .. ")" or ""; btn.Text = config.Text .. " [" .. (state and "ON" or "OFF") .. "]" .. hotkeyText; btn.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(220, 50, 50); btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    btn.MouseButton1Click:Connect(function() state = not state; updateVisuals(); if config.Callback then config.Callback(state) end end); updateVisuals()
    return function(newState) state = newState; updateVisuals() end
end
local setHatchButton = createToggleButton({Parent = container, Text = "Auto Hatch", Hotkey = "J", Position = UDim2.fromOffset(0, 5), Callback = function(state) hatchRunning = state end})
local setChestButton = createToggleButton({Parent = container, Text = "Auto Chest", Hotkey = "K", Position = UDim2.fromOffset(0, 50), Callback = function(state) chestRunning = state end})
createToggleButton({Parent = container, Text = "Anti-AFK", InitialState = antiAfkRunning, Position = UDim2.fromOffset(0, 95), Callback = function(state) antiAfkRunning = state end})
task.spawn(function() while task.wait(0.25) do if not gui or not gui.Parent then break end; statsLabel.Text = string.format("Status: %s\nEggs Hatched: %d\nChests Collected: %d\nLast Chest: %s", currentStatus, eggsHatchedCount, chestsCollectedCount, lastCollectedChestName) end end)
local miniIcon = Instance.new("TextButton", gui); miniIcon.Size = UDim2.new(0, 50, 0, 50); miniIcon.Position = UDim2.new(0.02, 0, 0.5, 0); miniIcon.Text = "N"; miniIcon.Font = Enum.Font.GothamBold; miniIcon.TextSize = 28; miniIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 32); miniIcon.TextColor3 = Color3.fromRGB(0, 255, 255); miniIcon.Draggable = true; Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", miniIcon).Color = Color3.fromRGB(80, 80, 80)
miniIcon.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
UserInputService.InputBegan:Connect(function(input, isTyping) if isTyping then return end; if input.KeyCode == Enum.KeyCode.J then hatchRunning = not hatchRunning; setHatchButton(hatchRunning) end; if input.KeyCode == Enum.KeyCode.K then chestRunning = not chestRunning; setChestButton(chestRunning) end end)
logmsg("NiTroHUB PRO (Direct Remote) Loaded! | J = Auto Hatch, K = Auto Chest")

