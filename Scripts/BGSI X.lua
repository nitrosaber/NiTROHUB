--// 🌀 NiTroHUB PRO - Final Evolution (Readability Improved)
--// ✨ by NiTroHUB x Gemini (จัดระเบียบโค้ดให้อ่านง่ายและสบายตา)
--//
--// การเปลี่ยนแปลง:
--//   - จัดรูปแบบการเว้นวรรคและการเยื้องใหม่ทั้งหมด
--//   - แบ่งส่วนการสร้าง GUI ที่ซับซ้อนออกมาเป็นส่วนย่อยๆ ที่เข้าใจง่าย
--//   - เพิ่ม Comment ในส่วนที่สำคัญเพื่ออธิบายโค้ด
--//   - การทำงานของสคริปต์ยังคงเหมือนเดิม 100%
--// =================================================================

-- ==========================
-- ⚙️ CONFIG (ตั้งค่าตามต้องการ)
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

local ENABLE_WEBHOOK = false
local WEBHOOK_URL = ""


-- ==========================
-- 🧩 SERVICES & CORE SETUP
-- ==========================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Compatibility checks for different executors
local isFireTouchInterestAvailable = type(firetouchinterest) == "function"
local getEnvironment = getfenv or getsenv

local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end


-- ==========================
-- 📡 REMOTE EVENTS & UTILITIES
-- ==========================

local function logmsg(...) print("[NiTroHUB]", ...) end
local function warnmsg(...) warn("[NiTroHUB]", ...) end

local function findRemote(possibleNames)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local objNameLower = obj.Name:lower()
            for _, name in ipairs(possibleNames) do
                if objNameLower:find(name:lower(), 1, true) then return obj end
            end
        end
    end
    return nil
end

local hatchRemote = findRemote({"HatchEgg", "EggHatch"})
local specificCollectRemote = ReplicatedStorage:WaitForChild("Shared", 2) and ReplicatedStorage.Shared:WaitForChild("Framework", 2) and ReplicatedStorage.Shared.Framework:WaitForChild("Network", 2) and ReplicatedStorage.Shared.Framework.Network:WaitForChild("Remote", 2) and ReplicatedStorage.Shared.Framework.Network.Remote:WaitForChild("RemoteEvent", 2)

if not hatchRemote then warnmsg("ไม่พบ Hatch RemoteEvent! Auto Hatch อาจไม่ทำงาน") end
if not specificCollectRemote then warnmsg("ไม่พบ Specific Collect RemoteEvent, จะใช้ระบบเก็บกล่องสำรอง") end


-- ==========================
-- 📊 STATE (ตัวแปรสถานะการทำงาน)
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

-- Hide unnecessary GUIs
pcall(function()
    for _, v in ipairs(playerGui:GetChildren()) do
        if v.Name:match("Hatch") or v.Name:match("Egg") then
            v.Enabled = false
        end
    end
    playerGui.ChildAdded:Connect(function(child)
        if child.Name:match("Hatch") or child.Name:match("Egg") then
            task.wait()
            child.Enabled = false
        end
    end)
end)

-- Disable hatch animation by hooking into the game's scripts
if getEnvironment then
    task.spawn(function()
        local scripts = player:WaitForChild("PlayerScripts"):GetDescendants()
        for _, script in ipairs(scripts) do
            if script:IsA("LocalScript") and (script.Name:match("Open") or script.Name:match("Egg")) then
                local success, err = pcall(function()
                    local env = getEnvironment(script)
                    if env and env.PlayEggAnimation then
                        env.PlayEggAnimation = function() return end
                        logmsg("✅ ปิดอนิเมชันสุ่มไข่สำเร็จแล้ว!")
                        return
                    end
                end)
                if not success then warnmsg("พยายามปิดอนิเมชัน แต่เกิดข้อผิดพลาด:", err) end
            end
        end
    end)
else
    warnmsg("ไม่พบฟังก์ชัน getfenv/getsenv, อาจไม่สามารถปิดอนิเมชันการสุ่มไข่ได้")
end


-- ==========================
-- 🥚 AUTO HATCH
-- ==========================

task.spawn(function()
    while true do
        if hatchRunning and hatchRemote then
            currentStatus = "กำลังฟักไข่..."
            local success, err = pcall(function()
                hatchRemote:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
                eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
            end)
            if not success then
                warnmsg("Auto Hatch ล้มเหลว:", err)
                hatchRunning = false
            end
            task.wait(HATCH_DELAY)
        else
            task.wait(0.1)
        end
    end
end)


-- ==========================
-- 💰 AUTO CHEST
-- ==========================

local function collectChest(chest)
    if not chest or not chest.Parent or not hrp then return false end

    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < CHEST_COLLECT_COOLDOWN) then
        return false
    end

    currentStatus = "พยายามเก็บ " .. chest.Name
    local success = false

    if specificCollectRemote then
        local remoteSuccess, _ = pcall(function()
            specificCollectRemote:FireServer("ClaimChest", chest.Name, true)
        end)
        if remoteSuccess then success = true; logmsg("💰 [Remote] เก็บ Chest:", chest.Name) end
    end

    if not success and isFireTouchInterestAvailable then
        local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
        if trigger then
            firetouchinterest(hrp, trigger, 0); task.wait(0.1); firetouchinterest(hrp, trigger, 1)
            success = true
            logmsg("💰 [Touch] เก็บ Chest:", chest.Name)
        end
    end

    if success then
        lastCollectedChests[key] = tick()
        chestsCollectedCount = chestsCollectedCount + 1
        lastCollectedChestName = chest.Name
        return true
    else
        warnmsg("ไม่สามารถเก็บกล่องได้: ไม่พบวิธีที่เหมาะสมสำหรับ", chest.Name)
        return false
    end
end

task.spawn(function()
    while true do
        if chestRunning then
            currentStatus = "กำลังค้นหากล่อง..."
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not chestRunning then break end
                if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                    pcall(collectChest, obj)
                    task.wait()
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
-- 🎨 GUI INTERFACE & 🕹️ CONTROLS (จัดระเบียบใหม่)
-- =================================================================

-- Cleanup old GUIs
playerGui:FindFirstChild("NiTroHUB_PRO_GUI") and playerGui:FindFirstChild("NiTroHUB_PRO_GUI"):Destroy()
playerGui:FindFirstChild("NiTroHUB_LoadingGUI") and playerGui:FindFirstChild("NiTroHUB_LoadingGUI"):Destroy()


-- [ SECTION ] LOADING SCREEN
do
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "NiTroHUB_LoadingGUI"
    loadingGui.IgnoreGuiInset = true
    loadingGui.ResetOnSpawn = false
    loadingGui.Parent = playerGui

    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    background.Parent = loadingGui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 300, 0, 50)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.fromScale(0.5, 0.45)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "🌀 NiTroHUB PRO 🌀"
    title.TextColor3 = Color3.fromRGB(0, 225, 255)
    title.TextSize = 32
    title.Parent = background

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.new(0, 0, 0)
    titleStroke.Thickness = 1.5
    titleStroke.Parent = title

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(0, 300, 0, 8)
    bar.AnchorPoint = Vector2.new(0.5, 0.5)
    bar.Position = UDim2.fromScale(0.5, 0.52)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.Parent = background
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local progress = Instance.new("Frame")
    progress.Name = "Progress"
    progress.Size = UDim2.new(0, 0, 1, 0)
    progress.BackgroundColor3 = Color3.fromRGB(0, 225, 255)
    progress.Parent = bar
    Instance.new("UICorner", progress).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        TweenService:Create(progress, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(2.5)
        TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        loadingGui:Destroy()
    end)
end

task.wait(3) -- Wait for loading screen to finish

-- [ SECTION ] MAIN GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "NiTroHUB_PRO_GUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

local screenDimmer = Instance.new("Frame")
screenDimmer.Name = "ScreenDimmer"
screenDimmer.Size = UDim2.new(1, 0, 1, 0)
screenDimmer.BackgroundColor3 = Color3.new(0, 0, 0)
screenDimmer.BackgroundTransparency = 1
screenDimmer.ZIndex = -1
screenDimmer.Parent = gui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 320, 0, 250)
frame.Position = UDim2.fromScale(0.05, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(80, 80, 80)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
header.Parent = frame
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "NiTroHUB PRO"
title.TextColor3 = Color3.fromRGB(0, 225, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tab System
local tabsContainer = Instance.new("Frame")
tabsContainer.Name = "TabsContainer"
tabsContainer.Size = UDim2.new(1, 0, 0, 35)
tabsContainer.Position = UDim2.fromOffset(0, 40)
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = frame

local pagesContainer = Instance.new("Frame")
pagesContainer.Name = "PagesContainer"
pagesContainer.Size = UDim2.new(1, -20, 1, -85)
pagesContainer.Position = UDim2.fromOffset(10, 75)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = frame

local pages = {}
local function createTab(text, position)
    local page = Instance.new("Frame")
    page.Name = text .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pagesContainer
    pages[text] = page

    local tabButton = Instance.new("TextButton")
    tabButton.Name = text .. "Tab"
    tabButton.Size = UDim2.new(0.5, -5, 1, 0)
    tabButton.Position = position
    tabButton.Text = text
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 14
    tabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabButton.Parent = tabsContainer
    
    tabButton.MouseButton1Click:Connect(function()
        for name, pg in pairs(pages) do pg.Visible = (name == text) end
        for _, otherTab in ipairs(tabsContainer:GetChildren()) do
            if otherTab:IsA("TextButton") then
                otherTab.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                otherTab.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return tabButton, page
end

local mainTab, mainPage = createTab("Main", UDim2.fromOffset(5, 0))
local settingsTab, settingsPage = createTab("Settings", UDim2.fromScale(0.5, 0))
mainTab.MouseButton1Click:Fire() -- Set Main as default tab

-- [ SECTION ] MAIN PAGE CONTENT
local function createToggleButton(parent, config)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Name = config.Name
    btn.Size = config.Size or UDim2.new(1, 0, 0, 35)
    btn.Position = config.Position
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(120, 120, 120)
    
    local function updateVisuals()
        local hotkeyText = config.Hotkey and config.Hotkey ~= "" and " ("..config.Hotkey..")" or ""
        btn.Text = config.Text .. " [".. (state and "ON" or "OFF") .."]" .. hotkeyText
        btn.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(220, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        if config.Callback then config.Callback(state) end
    end)
    
    updateVisuals()
    return function(newState) state = newState; updateVisuals() end
end

local setHatchButton = createToggleButton(mainPage, {Name = "AutoHatchButton", Text = "Auto Hatch", Hotkey = "J", Position = UDim2.fromOffset(0, 10), Callback = function(state) hatchRunning = state end})
local setChestButton = createToggleButton(mainPage, {Name = "AutoChestButton", Text = "Auto Chest", Hotkey = "K", Position = UDim2.fromOffset(0, 55), Callback = function(state) chestRunning = state end})

-- [ SECTION ] SETTINGS PAGE CONTENT
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Size = UDim2.new(1, 0, 0, 70)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 14
statsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = settingsPage

-- Anti-AFK Toggle
local antiAfkLabel = Instance.new("TextLabel", settingsPage)
antiAfkLabel.Size = UDim2.new(0.7, 0, 0, 30)
antiAfkLabel.Position = UDim2.fromOffset(0, 75)
antiAfkLabel.BackgroundTransparency = 1
antiAfkLabel.Font = Enum.Font.GothamSemibold
antiAfkLabel.Text = "Enable Anti-AFK"
antiAfkLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
antiAfkLabel.TextXAlignment = Enum.TextXAlignment.Left

local setAntiAfkButton = createToggleButton(settingsPage, {Name = "AntiAfkButton", Text = "", Position = UDim2.new(0.7, 0, 0, 75), Size = UDim2.new(0.3, 0, 0, 30), Callback = function(state) antiAfkRunning = state end})
setAntiAfkButton(antiAfkRunning)

-- Screen Dimmer
local dimmerLabel = Instance.new("TextLabel", settingsPage)
dimmerLabel.Size = UDim2.new(1, 0, 0, 20)
dimmerLabel.Position = UDim2.fromOffset(0, 110)
dimmerLabel.BackgroundTransparency = 1
dimmerLabel.Font = Enum.Font.GothamSemibold
dimmerLabel.Text = "Screen Dimmer"
dimmerLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
dimmerLabel.TextXAlignment = Enum.TextXAlignment.Left

local dimmerSlider = Instance.new("Frame", settingsPage)
dimmerSlider.Size = UDim2.new(1, 0, 0, 8)
dimmerSlider.Position = UDim2.fromOffset(0, 135)
dimmerSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", dimmerSlider).CornerRadius = UDim.new(1,0)

local dimmerHandle = Instance.new("TextButton", dimmerSlider)
dimmerHandle.Size = UDim2.new(0, 16, 0, 16)
dimmerHandle.Position = UDim2.fromScale(0, 0.5)
dimmerHandle.AnchorPoint = Vector2.new(0.5, 0.5)
dimmerHandle.BackgroundColor3 = Color3.fromRGB(0, 225, 255)
dimmerHandle.Draggable = true
Instance.new("UICorner", dimmerHandle).CornerRadius = UDim.new(1,0)

dimmerHandle.DragBegin:Connect(function()
    local mouse = player:GetMouse()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not dimmerHandle.Dragging then conn:Disconnect() return end
        local relativeX = math.clamp(mouse.X - dimmerSlider.AbsolutePosition.X, 0, dimmerSlider.AbsoluteSize.X)
        dimmerHandle.Position = UDim2.fromOffset(relativeX, 8)
        local percentage = relativeX / dimmerSlider.AbsoluteSize.X
        screenDimmer.BackgroundTransparency = 1 - percentage * 0.95
    end)
end)

-- [ SECTION ] GUI UPDATE AND CONTROLS
task.spawn(function()
    while task.wait(0.25) do
        if not gui or not gui.Parent then break end
        statsLabel.Text = string.format(
            "Status: %s\nEggs Hatched: %d\nChests Collected: %d\nLast Chest: %s",
            currentStatus, eggsHatchedCount, chestsCollectedCount, lastCollectedChestName
        )
    end
end)

local miniIcon = Instance.new("TextButton", gui)
miniIcon.Name = "MiniIcon"
miniIcon.Size = UDim2.new(0, 50, 0, 50)
miniIcon.Position = UDim2.new(0.02, 0, 0.5, 0)
miniIcon.Text = "🌀"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 28
miniIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
miniIcon.TextColor3 = Color3.fromRGB(0, 255, 255)
miniIcon.Draggable = true
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", miniIcon).Color = Color3.fromRGB(80, 80, 80)

miniIcon.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible then
        frame:TweenSize(UDim2.new(0, 320, 0, 250), "Out", "Quint", 0.3, true)
    end
end)

UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then hatchRunning = not hatchRunning; setHatchButton(hatchRunning) end
    if input.KeyCode == Enum.KeyCode.K then chestRunning = not chestRunning; setChestButton(chestRunning) end
end)

logmsg("✅ NiTroHUB PRO (Readability Improved) Loaded! | J = สุ่มไข่, K = เก็บกล่อง")
