-- NiTroHUB PRO - Final Evolution (Non-Teleport Edition) - FIXED & IMPROVED
-- by NiTroHUB x ChatGPT (ปรับปรุงตามคำขอ)
-- หมายเหตุ: โค้ดนี้เป็นเวอร์ชันปรับปรุง (best-effort) สำหรับใช้ใน Roblox exploit environment
-- ทำการปรับปรุงหลัก:
--  - ลดการสแปมการเรียก Remote (แก้ไขให้สอดคล้องกับ HATCH_DELAY)
--  - พยายามจับผลลัพธ์การฟักไข่ (ถ้าพบ Remote ตอบกลับจะใช้ค่านั้น)
--  - ปิดอนิเมชันและ GUI การฟักไข่ให้ครอบคลุมมากขึ้น
--  - ลด logmsg ที่ไม่จำเป็น เหลือเฉพาะเหตุการณ์สำคัญ
--  - ปรับ GUI ให้มี 2 หน้า (Main / Settings) พร้อมไอคอนเล็กและ loading
--  - ปรับปรุงการเก็บกล่อง: ตรวจสอบว่ากล่องหายไป/ถูกทำเครื่องหมายก่อนนับว่าเก็บสำเร็จ
--  - เพิ่ม Toggle สำหรับ Anti-AFK และ Dark Screen (หน้าจอดำ)
--  - เพิ่มการโหลดเมื่อสคริปต์เริ่มทำงาน (แสดงแค่ไอคอน) แล้วเปิด GUI หลักได้

-- ==========================
-- CONFIG
-- ==========================
local EGG_NAME = "Autumn Egg"
local HATCH_AMOUNT = 8          -- 1, 3, 8
local HATCH_DELAY = 0.05        -- วินาที (delay หลังจากเรียกแต่ละครั้ง)

local TELEPORT_TO_CHEST = false
local CHEST_CHECK_INTERVAL = 12 -- ลดเวลาเพื่อค้นหาบ่อยขึ้น แต่ไม่บ่อยเกินไป
local CHEST_COLLECT_COOLDOWN = 180

local CHEST_NAMES = {
    "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
    "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
    "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
}

local ENABLE_WEBHOOK = false
local WEBHOOK_URL = ""

-- ==========================
-- SERVICES
-- ==========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- helper for safe prints (เฉพาะข้อความสำคัญ)
local function logmsg(...)
    pcall(function() print("[NiTroHUB]", ...) end)
end

-- prepare chest lookup
local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end

-- ==========================
-- FIND REMOTE UTIL
-- ==========================
local function findRemoteByNames(names)
    local searchLocations = {ReplicatedStorage, player:WaitForChild("PlayerScripts")}
    for _, loc in ipairs(searchLocations) do
        for _, obj in ipairs(loc:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local lower = obj.Name:lower()
                for _, n in ipairs(names) do
                    local nl = n:lower()
                    if lower == nl or lower:find(nl,1,true) then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

local hatchRemote = findRemoteByNames({"HatchEgg","EggHatch","Hatch","HatchRemote","RemoteHatch"})
if not hatchRemote then warn("[NiTroHUB] Hatch RemoteEvent ไม่พบ - ฟังก์ชันฟักไข่จะพยายามเรียกผ่านที่พบเท่านั้น") end

-- พยายามค้นหา Remote/Event ที่ส่งผลลัพธ์การฟักไข่ (server -> client) เพื่อให้นับจริง
local hatchResultRemote = findRemoteByNames({"HatchResult","HatchResponse","OnHatch","HatchComplete"})

-- Remote สำหรับเก็บกล่องถ้ามี
local specificCollectRemote = nil
pcall(function()
    specificCollectRemote = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Framework") and ReplicatedStorage.Shared.Framework:FindFirstChild("Network") and ReplicatedStorage.Shared.Framework.Network:FindFirstChild("Remote") and ReplicatedStorage.Shared.Framework.Network.Remote:FindFirstChild("RemoteEvent")
end)

-- ==========================
-- STATE
-- ==========================
local hatchRunning = false
local chestRunning = false
local antiAfkEnabled = true
local darkScreenEnabled = false

local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollectedChests = {}
local lastCollectedChestName = "-"
local currentStatus = "Idle"

-- buffer to avoid concurrent hatch attempts
local lastHatchTime = 0

-- ==========================
-- WEBHOOK
-- ==========================
local function sendWebhook(chestName)
    if not ENABLE_WEBHOOK or WEBHOOK_URL == "" then return end
    task.spawn(function()
        local data = {
            embeds = {{
                title = "✨ เก็บกล่องสมบัติสำเร็จ!",
                description = string.format("ผู้เล่น **%s** ได้เก็บ **%s**", player.Name, chestName),
                color = 0x00FFFF,
                footer = {text = "NiTroHUB PRO - Final Evolution"},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        local success, err = pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data))
        end)
        if not success then warn("[NiTroHUB] ไม่สามารถส่ง Webhook ได้:", err) end
    end)
end

-- ==========================
-- SUPPRESS ANIMATIONS & HIDE GUI (พยายามครอบคลุมมากขึ้น)
-- ==========================
local function safeDisableGuiObject(obj)
    pcall(function()
        if typeof(obj.Enabled) ~= "nil" then obj.Enabled = false end
        if typeof(obj.Visible) ~= "nil" then obj.Visible = false end
        if obj:IsA("GuiObject") then obj.Visible = false end
    end)
end

local guiNamesToHide = {
    ["HatchEggUI"] = true, ["HatchAnimationGui"] = true, ["HatchGui"] = true,
    ["LastHatchGui"] = true, ["EggHatchUI"] = true, ["AutoDeleteUI"] = true,
    ["HatchPopupUI"] = true
}

-- hide existing and future ones
for _, child in ipairs(playerGui:GetDescendants()) do
    if child:IsA("GuiObject") and guiNamesToHide[child.Name] then safeDisableGuiObject(child) end
end
playerGui.DescendantAdded:Connect(function(child)
    if child:IsA("GuiObject") and guiNamesToHide[child.Name] then safeDisableGuiObject(child) end
end)

-- Try to override known animation functions in PlayerScripts (best-effort)
pcall(function()
    local ps = player:FindFirstChild("PlayerScripts")
    if ps then
        for _, s in ipairs(ps:GetDescendants()) do
            if s:IsA("ModuleScript") or s:IsA("LocalScript") then
                local name = s.Name:lower()
                if name:find("egg") and name:find("open") or name:find("hatch") then
                    local ok, env = pcall(function() return getsenv and getsenv(s) or getfenv and getfenv(s) end)
                    if ok and env and type(env) == "table" then
                        pcall(function() if env.PlayEggAnimation then env.PlayEggAnimation = function() end end)
                    end
                end
            end
        end
    end
end)

-- ==========================
-- HATCHING LOOP (ปรับปรุง)
-- ==========================
-- We will:
--  1) throttle by HATCH_DELAY
--  2) call hatchRemote if available
--  3) if hatchResultRemote exists, listen for responses and increment real counts

if hatchResultRemote then
    pcall(function()
        hatchResultRemote.OnClientEvent:Connect(function(data)
            -- data format varies by game; best-effort: try find numeric count
            if type(data) == "table" then
                -- look for keys like 'amount', 'count', 'hatchCount'
                for k,v in pairs(data) do
                    if type(v) == "number" then
                        eggsHatchedCount = eggsHatchedCount + v
                        return
                    end
                end
            elseif type(data) == "number" then
                eggsHatchedCount = eggsHatchedCount + data
            end
        end)
    end)
end

-- fallback: if no result remote exists, increment by HATCH_AMOUNT but only when we think call succeeded
local function tryHatch()
    if not hatchRemote then return false end
    local now = tick()
    if now - lastHatchTime < math.max(HATCH_DELAY, 0.03) then return false end
    lastHatchTime = now

    local ok, err = pcall(function()
        if hatchRemote.FireServer then
            hatchRemote:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
        elseif hatchRemote.InvokeServer then
            -- remote function
            hatchRemote:InvokeServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
        end
    end)
    if not ok then
        warn("[NiTroHUB] Hatch call failed:", err)
        return false
    end

    -- if no hatchResultRemote we add to counter conservatively (we assume server accepted request)
    if not hatchResultRemote then
        eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
    end
    return true
end

spawn(function()
    while true do
        if hatchRunning then
            currentStatus = "กำลังฟักไข่..."
            local ok = pcall(tryHatch)
            if not ok then warn("[NiTroHUB] การเรียกฟักไข่ล้มเหลว") end
            task.wait(HATCH_DELAY)
        else
            task.wait(0.5)
        end
    end
end)

-- ==========================
-- CHEST COLLECT (ปรับปรุงให้ตรวจสอบความสำเร็จจริง)
-- ==========================
local function chestActuallyCollected(chest)
    -- ตรวจสอบว่ากล่องถูกลบออกจาก Workspace หรือมี flag ที่บ่งชี้
    if not chest then return false end
    for i=1,30 do -- รอตรวจสอบนานสุด ~3 วินาที
        if not chest.Parent then return true end
        if chest:FindFirstChild("Collected") or chest:FindFirstChild("_collected") then return true end
        task.wait(0.1)
    end
    return false
end

local function collectChest(chest)
    if not chest or not chest.Parent or not hrp then return end

    local key = tostring(chest:GetDebugId() or chest:GetFullName())
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < CHEST_COLLECT_COOLDOWN) then return end

    currentStatus = "พยายามเก็บ: "..tostring(chest.Name)
    local attempted = false
    local success = false

    -- try specific remote if exists
    if specificCollectRemote then
        attempted = true
        local ok, err = pcall(function()
            specificCollectRemote:FireServer("ClaimChest", chest.Name, true)
        end)
        if not ok then warn("[NiTroHUB] specificCollectRemote error:", err) end
        if chestActuallyCollected(chest) then success = true end
    end

    -- fallback to touch trigger
    if not success then
        local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
        if trigger and firetouchinterest then
            attempted = true
            pcall(function()
                firetouchinterest(hrp, trigger, 0); task.wait(0.08); firetouchinterest(hrp, trigger, 1)
            end)
            if chestActuallyCollected(chest) then success = true end
        end
    end

    if success then
        lastCollectedChests[key] = tick()
        chestsCollectedCount = chestsCollectedCount + 1
        lastCollectedChestName = chest.Name
        sendWebhook(chest.Name)
        logmsg("เก็บกล่องสำเร็จ:", chest.Name)
    else
        -- หากไม่ได้เก็บจริงๆ ให้พยายามหลีกเลี่ยงการวนซ้ำเปล่าๆ
        lastCollectedChests[key] = tick()
        warn("[NiTroHUB] ไม่สามารถเก็บกล่องได้จริง:", chest.Name)
    end
end

spawn(function()
    while true do
        if chestRunning then
            currentStatus = "กำลังค้นหากล่อง..."
            local searchAreas = {Workspace, Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas")}
            for _, area in ipairs(searchAreas) do
                if area then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] and chestRunning then
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
-- ANTI-AFK (toggleable)
-- ==========================
spawn(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if antiAfkEnabled then
                vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end)

-- ==========================
-- GUI: Cleaner, 2 pages (Main / Settings), Loading mini-icon
-- ==========================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "NiTroHUB_PRO_GUI"; gui.IgnoreGuiInset = true; gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Name = "MainFrame"
frame.Position = UDim2.new(0.06,0,0.18,0)
frame.Size = UDim2.new(0, 320, 0, 260)
frame.BackgroundColor3 = Color3.fromRGB(24,24,28)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(60,60,60)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,44); title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold
title.TextSize = 18; title.TextColor3 = Color3.fromRGB(0, 210, 230)
title.Text = "🌀 NiTroHUB PRO"

-- Pages container
local pages = Instance.new("Frame", frame)
pages.Name = "Pages"; pages.Position = UDim2.new(0,0,0,44); pages.Size = UDim2.new(1,0,0,216)
pages.BackgroundTransparency = 1

-- helper to create buttons
local function MakeButton(parent, text, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 220, 0, 30)
    b.Position = UDim2.new(0.5, -110, 0, y)
    b.Font = Enum.Font.Gotham; b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(40,40,44)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

-- Main page
local mainPage = Instance.new("Frame", pages)
mainPage.Name = "Main"; mainPage.Size = UDim2.new(1,0,1,0); mainPage.BackgroundTransparency = 1

local hatchBtn = MakeButton(mainPage, "Auto Hatch [J]", 10)
local chestBtn = MakeButton(mainPage, "Auto Chest [K]", 50)
local afkBtn = MakeButton(mainPage, "Anti-AFK: ON", 90)
local darkBtn = MakeButton(mainPage, "Dark Screen: OFF", 130)

local stats = Instance.new("TextLabel", mainPage)
stats.Position = UDim2.new(0,10,0,170); stats.Size = UDim2.new(1,-20,0,36)
stats.BackgroundTransparency = 1; stats.TextXAlignment = Enum.TextXAlignment.Left
stats.Font = Enum.Font.Gotham; stats.TextSize = 13; stats.TextColor3 = Color3.fromRGB(210,210,210)

-- Settings page
local settingsPage = Instance.new("Frame", pages)
settingsPage.Name = "Settings"; settingsPage.Size = UDim2.new(1,0,1,0); settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false

local settingsTitle = Instance.new("TextLabel", settingsPage)
settingsTitle.Position = UDim2.new(0,0,0,8); settingsTitle.Size = UDim2.new(1,0,0,28)
settingsTitle.BackgroundTransparency = 1; settingsTitle.Text = "Settings"; settingsTitle.Font = Enum.Font.GothamBold; settingsTitle.TextSize = 16

local hatchAmountLabel = Instance.new("TextLabel", settingsPage)
hatchAmountLabel.Position = UDim2.new(0,10,0,44); hatchAmountLabel.Size = UDim2.new(0,150,0,24)
hatchAmountLabel.BackgroundTransparency = 1; hatchAmountLabel.Text = "Hatch Amount: "..tostring(HATCH_AMOUNT)
hatchAmountLabel.Font = Enum.Font.Gotham; hatchAmountLabel.TextSize = 13

local hatchDelayLabel = Instance.new("TextLabel", settingsPage)
hatchDelayLabel.Position = UDim2.new(0,10,0,72); hatchDelayLabel.Size = UDim2.new(0,150,0,24)
hatchDelayLabel.BackgroundTransparency = 1; hatchDelayLabel.Text = string.format("Hatch Delay: %.3f s", HATCH_DELAY)
hatchDelayLabel.Font = Enum.Font.Gotham; hatchDelayLabel.TextSize = 13

-- Nav buttons
local navMain = MakeButton(frame, "Main", 220)
local navSettings = MakeButton(frame, "Settings", 220)
navMain.Position = UDim2.new(0.08,0,0,220)
navSettings.Position = UDim2.new(0.58,0,0,220)

-- Mini icon + loading animation
local mini = Instance.new("TextButton", gui)
mini.Name = "MiniIcon"; mini.Size = UDim2.new(0, 52, 0, 52)
mini.Position = UDim2.new(0.02, 0, 0.72, 0)
mini.Text = "🌀"; mini.Font = Enum.Font.GothamBold; mini.TextSize = 28
mini.BackgroundColor3 = Color3.fromRGB(0,0,0); mini.BackgroundTransparency = 0.25
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local loadingDot = Instance.new("TextLabel", mini)
loadingDot.Size = UDim2.new(0, 120, 0, 24); loadingDot.Position = UDim2.new(1,6,0,14)
loadingDot.BackgroundTransparency = 0.4; loadingDot.Text = "NiTroHUB PRO"; loadingDot.Font = Enum.Font.Gotham; loadingDot.TextSize = 12
Instance.new("UICorner", loadingDot).CornerRadius = UDim.new(0,6)
loadingDot.Visible = false

-- Dark screen overlay
local darkOverlay = Instance.new("Frame", gui)
darkOverlay.Size = UDim2.new(1,0,1,0); darkOverlay.Position = UDim2.new(0,0,0,0)
darkOverlay.BackgroundColor3 = Color3.new(0,0,0); darkOverlay.BackgroundTransparency = 1

darkOverlay.ZIndex = 9999; darkOverlay.Visible = false

-- GUI interactions
mini.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

navMain.MouseButton1Click:Connect(function()
    mainPage.Visible = true; settingsPage.Visible = false
end)
navSettings.MouseButton1Click:Connect(function()
    mainPage.Visible = false; settingsPage.Visible = true
end)

-- toggle functions
local function updateHatchButtonVisual()
    hatchBtn.Text = (hatchRunning and "Auto Hatch: ON [J]" or "Auto Hatch: OFF [J]")
    hatchBtn.BackgroundColor3 = hatchRunning and Color3.fromRGB(46,125,50) or Color3.fromRGB(160,40,40)
end
local function updateChestButtonVisual()
    chestBtn.Text = (chestRunning and "Auto Chest: ON [K]" or "Auto Chest: OFF [K]")
    chestBtn.BackgroundColor3 = chestRunning and Color3.fromRGB(46,125,50) or Color3.fromRGB(160,40,40)
end
local function updateAfkVisual()
    afkBtn.Text = (antiAfkEnabled and "Anti-AFK: ON" or "Anti-AFK: OFF")
    afkBtn.BackgroundColor3 = antiAfkEnabled and Color3.fromRGB(60,60,120) or Color3.fromRGB(60,60,60)
end
local function updateDarkVisual()
    darkBtn.Text = (darkScreenEnabled and "Dark Screen: ON" or "Dark Screen: OFF")
    darkBtn.BackgroundColor3 = darkScreenEnabled and Color3.fromRGB(30,30,30) or Color3.fromRGB(60,60,60)
    darkOverlay.Visible = darkScreenEnabled
    darkOverlay.BackgroundTransparency = darkScreenEnabled and 0.25 or 1
end

hatchBtn.MouseButton1Click:Connect(function()
    hatchRunning = not hatchRunning
    updateHatchButtonVisual()
end)
chestBtn.MouseButton1Click:Connect(function()
    chestRunning = not chestRunning
    updateChestButtonVisual()
end)
afkBtn.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    updateAfkVisual()
end)
darkBtn.MouseButton1Click:Connect(function()
    darkScreenEnabled = not darkScreenEnabled
    updateDarkVisual()
end)

-- hotkeys
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        hatchRunning = not hatchRunning; updateHatchButtonVisual()
    elseif input.KeyCode == Enum.KeyCode.K then
        chestRunning = not chestRunning; updateChestButtonVisual()
    end
end)

-- update stats loop
spawn(function()
    while true do
        stats.Text = string.format("Status: %s\nHatched: %d\nChests: %d\nLast Chest: %s", currentStatus, eggsHatchedCount, chestsCollectedCount, lastCollectedChestName)
        hatchAmountLabel.Text = "Hatch Amount: "..tostring(HATCH_AMOUNT)
        hatchDelayLabel.Text = string.format("Hatch Delay: %.3f s", HATCH_DELAY)
        updateHatchButtonVisual(); updateChestButtonVisual(); updateAfkVisual(); updateDarkVisual()
        task.wait(0.25)
    end
end)

-- show a quick loading animation (mini icon + label) for 1.2s when script loads
loadingDot.Visible = true
spawn(function()
    for i=1,6 do
        loadingDot.Text = "NiTroHUB PRO - Loading" .. string.rep('.', (i%4))
        task.wait(0.2)
    end
    loadingDot.Visible = false
end)

-- initial visuals
frame.Visible = false -- start hidden, only mini icon visible
updateHatchButtonVisual(); updateChestButtonVisual(); updateAfkVisual(); updateDarkVisual()

logmsg("NiTroHUB PRO loaded (UI ready). J = Hatch, K = Chest")

-- End of script
