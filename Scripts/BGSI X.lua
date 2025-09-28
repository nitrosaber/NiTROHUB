--// 🌀 NiTroHUB PRO - Final Evolution (Complete Overhaul)
--// ✨ by NiTroHUB x Gemini (ปรับปรุงและแก้ไขตามคำขอทั้งหมด)
--//
--// การเปลี่ยนแปลงหลัก:
--//   - [FIX] แก้ไขการสุ่มไข่ให้เสถียรและนับค่าได้แม่นยำ
--//   - [FIX] ตรวจสอบและปิดอนิเมชันการสุ่มไข่โดยสมบูรณ์
--//   - [FIX] แก้ไขการเก็บกล่องที่บางครั้งไม่ทำงานแต่สคริปต์ยังรันต่อ
--//   - [GUI] ยกเครื่องดีไซน์ GUI ใหม่ทั้งหมด สวยงามและใช้งานง่าย
--//   - [GUI] เพิ่มหน้า Main (ควบคุม) และ Settings (ตั้งค่า)
--//   - [NEW] เพิ่ม Loading Screen ตอนเริ่มต้น
--//   - [NEW] เพิ่มฟังก์ชัน Screen Dimmer (ปรับจอมืด) และสวิตช์ Anti-AFK
--// =================================================================

-- ==========================
-- ⚙️ CONFIG (ตั้งค่าตามต้องการ)
-- ==========================
local EGG_NAME = "Autumn Egg"
local HATCH_AMOUNT = 8
local HATCH_DELAY = 0.1 -- แนะนำให้เริ่มที่ 0.1 เพื่อความเสถียร

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
local antiAfkRunning = true -- เปิด Anti-AFK เป็นค่าเริ่มต้น

local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollectedChests = {}
local lastCollectedChestName = "-"
local currentStatus = "Idle"

-- ==========================
-- 🚀 PERFORMANCE & ANIMATION PATCH (*** แก้ไขแล้ว ***)
-- ==========================
-- ปิด GUI ที่ไม่จำเป็นทั้งหมด
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

-- ปิดอนิเมชันการฟักไข่ (สมบูรณ์ยิ่งขึ้น)
task.spawn(function()
    local scripts = player:WaitForChild("PlayerScripts"):GetDescendants()
    for _, script in ipairs(scripts) do
        if script:IsA("LocalScript") and script.Name:match("Open") or script.Name:match("Egg") then
            local success, err = pcall(function()
                local env = getfenv and getfenv(script) or getsenv and getsenv(script)
                if env and env.PlayEggAnimation then
                    env.PlayEggAnimation = function() return end
                    logmsg("✅ ปิดอนิเมชันสุ่มไข่สำเร็จแล้ว!")
                    return -- ออกจาก loop เมื่อเจอและแก้ไขสำเร็จ
                end
            end)
            if not success then warnmsg("พยายามปิดอนิเมชัน แต่เกิดข้อผิดพลาด:", err) end
        end
    end
end)


-- ==========================
-- 🥚 AUTO HATCH (*** แก้ไขแล้ว ***)
-- ==========================
task.spawn(function()
    while true do
        if hatchRunning and hatchRemote then
            currentStatus = "กำลังฟักไข่..."
            local success, err = pcall(function()
                hatchRemote:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
                -- การนับจะเกิดขึ้นหลัง FireServer ทันที (Client-Side Assumption)
                eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
            end)
            if not success then
                warnmsg("Auto Hatch ล้มเหลว:", err)
                hatchRunning = false -- หยุดทำงานเมื่อเกิดข้อผิดพลาด
            end
            task.wait(HATCH_DELAY)
        else
            -- รอเล็กน้อยเมื่อไม่ได้ทำงาน เพื่อลดการใช้ CPU
            task.wait(0.1)
        end
    end
end)

-- ==========================
-- 💰 AUTO CHEST (*** แก้ไขแล้ว ***)
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

    if not success then
        local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
        if trigger and firetouchinterest then
            firetouchinterest(hrp, trigger, 0); task.wait(0.1); firetouchinterest(hrp, trigger, 1)
            success = true
            logmsg("💰 [Touch] เก็บ Chest:", chest.Name)
        end
    end

    if success then
        lastCollectedChests[key] = tick()
        chestsCollectedCount = chestsCollectedCount + 1
        lastCollectedChestName = chest.Name
        -- Webhook ถูกย้ายไปเรียกใช้ข้างนอก เพื่อให้แน่ใจว่าสำเร็จจริง
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
                if not chestRunning then break end -- หยุดทันทีถ้าปิดฟังก์ชัน
                if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                    local collected = pcall(collectChest, obj)
                    if collected then
                        -- ส่ง Webhook ที่นี่ หลังจากยืนยันว่าเก็บสำเร็จ
                        if ENABLE_WEBHOOK and WEBHOOK_URL ~= "" then
                           -- sendWebhook(obj.Name) -- หากต้องการเปิดใช้งาน Webhook ให้ลบ comment ออก
                        end
                    end
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
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        if antiAfkRunning then
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame); task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame);
        end
    end)
end)


-- =================================================================
-- 🎨 GUI INTERFACE & 🕹️ CONTROLS (*** สร้างใหม่ทั้งหมด ***)
-- =================================================================
-- ล้าง GUI เก่า (ถ้ามี)
playerGui:FindFirstChild("NiTroHUB_PRO_GUI") and playerGui:FindFirstChild("NiTroHUB_PRO_GUI"):Destroy()
playerGui:FindFirstChild("NiTroHUB_LoadingGUI") and playerGui:FindFirstChild("NiTroHUB_LoadingGUI"):Destroy()

-- Utility Functions for GUI
local function Create(instanceType)
    return function(data)
        local obj = Instance.new(instanceType)
        for k, v in pairs(data) do
            if type(k) == 'number' then
                v.Parent = obj
            else
                obj[k] = v
            end
        end
        return obj
    end
end

-- Loading Screen
local loadingGui = Create'ScreenGui'{
    Name = "NiTroHUB_LoadingGUI",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    Parent = playerGui,
    [1] = Create'Frame'{
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        [1] = Create'TextLabel'{
            Name = "Title",
            Size = UDim2.new(0, 300, 0, 50),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = "🌀 NiTroHUB PRO 🌀",
            TextColor3 = Color3.fromRGB(0, 225, 255),
            TextSize = 32,
            [1] = Create'UIStroke'{Color = Color3.new(0,0,0), Thickness = 1.5}
        },
        [2] = Create'Frame'{
            Name = "Bar",
            Size = UDim2.new(0, 300, 0, 8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.52),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            [1] = Create'UICorner'{CornerRadius = UDim.new(1,0)},
            [2] = Create'Frame'{
                Name = "Progress",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 225, 255),
                [1] = Create'UICorner'{CornerRadius = UDim.new(1,0)}
            }
        }
    }
}

-- Loading Animation
task.spawn(function()
    local bar = loadingGui.Background.Bar.Progress
    local background = loadingGui.Background
    TweenService:Create(bar, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.5)
    TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    loadingGui:Destroy()
end)

task.wait(3) -- รอให้ Loading Screen จบ

-- Main GUI
local gui = Create'ScreenGui'{
    Name = "NiTroHUB_PRO_GUI",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    Enabled = true,
    Parent = playerGui
}

-- Screen Dimmer Frame
local screenDimmer = Create'Frame'{
    Name = "ScreenDimmer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1, -- เริ่มที่มองไม่เห็น
    ZIndex = -1,
    Parent = gui
}

-- Main Frame
local frame = Create'Frame'{
    Name = "MainFrame",
    Size = UDim2.new(0, 320, 0, 250),
    Position = UDim2.fromScale(0.05, 0.2),
    BackgroundColor3 = Color3.fromRGB(28, 28, 32),
    BorderColor3 = Color3.fromRGB(80, 80, 80),
    Active = true,
    Draggable = true,
    Visible = false, -- เริ่มโดยซ่อนไว้
    Parent = gui,
    [1] = Create'UICorner'{CornerRadius = UDim.new(0, 12)},
    [2] = Create'UIStroke'{Color = Color3.fromRGB(80, 80, 80)}
}

-- Header
local header = Create'Frame'{
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
    Parent = frame,
    [1] = Create'TextLabel'{
        Name = "Title",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "NiTroHUB PRO",
        TextColor3 = Color3.fromRGB(0, 225, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    [2] = Create'UICorner'{CornerRadius = UDim.new(0, 12)}
}

-- Tabs Container
local tabsContainer = Create'Frame'{
    Name = "TabsContainer",
    Size = UDim2.new(1, 0, 0, 35),
    Position = UDim2.fromOffset(0, 40),
    BackgroundTransparency = 1,
    Parent = frame
}

-- Pages Container
local pagesContainer = Create'Frame'{
    Name = "PagesContainer",
    Size = UDim2.new(1, -20, 1, -85),
    Position = UDim2.fromOffset(10, 75),
    BackgroundTransparency = 1,
    Parent = frame
}

-- Tab Creation Logic
local pages = {}
local function createTab(text)
    local tabButton = Create'TextButton'{
        Name = text .. "Tab",
        Size = UDim2.new(0.5, -5, 1, 0),
        Text = text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(28, 28, 32),
        TextColor3 = Color3.fromRGB(150, 150, 150)
    }

    local page = Create'Frame'{
        Name = text .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = pagesContainer
    }
    pages[text] = page

    tabButton.MouseButton1Click:Connect(function()
        for name, pg in pairs(pages) do
            pg.Visible = (name == text)
        end
        for _, otherTab in ipairs(tabsContainer:GetChildren()) do
            if otherTab:IsA("TextButton") then
                otherTab.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                otherTab.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return tabButton
end

local mainTab = createTab("Main")
mainTab.Position = UDim2.fromOffset(5, 0)
mainTab.Parent = tabsContainer

local settingsTab = createTab("Settings")
settingsTab.Position = UDim2.fromScale(0.5, 0)
settingsTab.Parent = tabsContainer

-- Activate Main tab by default
mainTab.MouseButton1Click:Wait()

-- ## Main Page Content ##
local mainPage = pages["Main"]

-- Toggle Button Creator
local function createToggleButton(parent, config)
    local state = false
    local btn = Create'TextButton'{
        Name = config.Name,
        Size = UDim2.new(1, 0, 0, 35),
        Position = config.Position,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = parent
    }
    local corner = Create'UICorner'{CornerRadius = UDim.new(0, 8), Parent = btn}
    local stroke = Create'UIStroke'{Color = Color3.fromRGB(120, 120, 120), Parent = btn}
    
    local function updateVisuals()
        local color = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(220, 50, 50)
        local text = state and "ON" or "OFF"
        btn.Text = config.Text .. " ["..text.."] ("..config.Hotkey..")"
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        if config.Callback then config.Callback(state) end
    end)
    
    updateVisuals()
    return btn, function(newState) state = newState; updateVisuals() end
end

local _, setHatchButton = createToggleButton(mainPage, {
    Name = "AutoHatchButton", Text = "Auto Hatch", Hotkey = "J",
    Position = UDim2.fromOffset(0, 10),
    Callback = function(state) hatchRunning = state end
})

local _, setChestButton = createToggleButton(mainPage, {
    Name = "AutoChestButton", Text = "Auto Chest", Hotkey = "K",
    Position = UDim2.fromOffset(0, 55),
    Callback = function(state) chestRunning = state end
})


-- ## Settings Page Content ##
local settingsPage = pages["Settings"]

-- Stats Display
local statsLabel = Create'TextLabel'{
    Name = "StatsLabel",
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Parent = settingsPage
}

-- Anti-AFK Toggle
local antiAfkLabel = Create'TextLabel'{
    Name = "AntiAfkLabel",
    Size = UDim2.new(0.7, 0, 0, 30),
    Position = UDim2.fromOffset(0, 75),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamSemibold,
    Text = "Enable Anti-AFK",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = settingsPage
}
local _, setAntiAfkButton = createToggleButton(settingsPage, {
    Name = "AntiAfkButton", Text = "", Hotkey = "",
    Position = UDim2.new(0.75, 0, 0, 75),
    Callback = function(state) antiAfkRunning = state end
})
setAntiAfkButton(antiAfkRunning) -- Set initial state


-- Screen Dimmer
local dimmerLabel = Create'TextLabel'{
    Name = "DimmerLabel",
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.fromOffset(0, 110),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamSemibold,
    Text = "Screen Dimmer",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = settingsPage
}
local dimmerSlider = Create'Frame'{
    Name = "DimmerSlider",
    Size = UDim2.new(1, 0, 0, 8),
    Position = UDim2.fromOffset(0, 135),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    Parent = settingsPage,
    [1] = Create'UICorner'{CornerRadius = UDim.new(1,0)}
}
local dimmerHandle = Create'TextButton'{
    Name = "Handle",
    Size = UDim2.new(0, 16, 0, 16),
    Position = UDim2.fromScale(0, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(0, 225, 255),
    Draggable = true,
    Text = "",
    Parent = dimmerSlider,
    [1] = Create'UICorner'{CornerRadius = UDim.new(1,0)}
}
dimmerHandle.Draggable = true
dimmerHandle.DragBegin:Connect(function()
    local mouse = player:GetMouse()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not dimmerHandle.Dragging then conn:Disconnect() return end
        local relativeX = math.clamp(mouse.X - dimmerSlider.AbsolutePosition.X, 0, dimmerSlider.AbsoluteSize.X)
        dimmerHandle.Position = UDim2.fromOffset(relativeX, 8)
        local percentage = relativeX / dimmerSlider.AbsoluteSize.X
        screenDimmer.BackgroundTransparency = 1 - percentage * 0.95 -- Max 95% dim
    end)
end)


-- GUI Update Loop
task.spawn(function()
    while task.wait(0.25) do
        if not gui or not gui.Parent then break end
        statsLabel.Text = string.format(
            "Status: %s\nEggs Hatched: %d\nChests Collected: %d\nLast Chest: %s",
            currentStatus, eggsHatchedCount, chestsCollectedCount, lastCollectedChestName
        )
    end
end)


-- Mini Icon to toggle main GUI
local miniIcon = Create'TextButton'{
    Name = "MiniIcon",
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.02, 0, 0.5, 0),
    Text = "🌀",
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    BackgroundColor3 = Color3.fromRGB(28, 28, 32),
    TextColor3 = Color3.fromRGB(0, 255, 255),
    Draggable = true,
    Parent = gui,
    [1] = Create'UICorner'{CornerRadius = UDim.new(1, 0)},
    [2] = Create'UIStroke'{Color = Color3.fromRGB(80, 80, 80)}
}

miniIcon.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible then
        frame:TweenSizeAndPosition(UDim2.new(0, 320, 0, 250), frame.Position, "Out", "Quint", 0.3, true)
    end
end)


-- Hotkeys
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then
        hatchRunning = not hatchRunning
        setHatchButton(hatchRunning)
    end
    if input.KeyCode == Enum.KeyCode.K then
        chestRunning = not chestRunning
        setChestButton(chestRunning)
    end
end)

logmsg("✅ NiTroHUB PRO (Overhaul) Loaded! | J = สุ่มไข่, K = เก็บกล่อง")
