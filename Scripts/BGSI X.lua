--// 🌀 NiTroHUB PRO - Final Evolution (Non-Teleport Edition)
--// ✨ by NiTroHUB x ChatGPT (ปรับปรุงล่าสุด)
--//
--// คุณสมบัติหลัก:
--//   - สุ่มไข่อัตโนมัติ (Infinity Hatch)
--//   - เก็บกล่องสมบัติอัตโนมัติ (Auto Chest) **โดยไม่ใช้การเทเลพอร์ต**
--//   - ควบคุมการทำงานของ Auto Hatch และ Auto Chest ได้อย่างอิสระ
--//   - การแจ้งเตือนผ่าน Discord Webhook เมื่อเก็บกล่องสำเร็จ
--//   - ปิดอนิเมชันและ UI ที่ไม่จำเป็นเพื่อประสิทธิภาพสูงสุด
--//   - ระบบป้องกัน AFK (Anti-AFK)
--//   - GUI ควบคุมที่ใช้งานง่ายและลากตำแหน่งได้
--//   - Hotkey: กดปุ่ม 'J' เพื่อเปิด/ปิดการสุ่มไข่, 'K' เพื่อเปิด/ปิดการเก็บกล่อง
--// =================================================================

-- ==========================
-- ⚙️ CONFIG (ตั้งค่าตามต้องการ)
-- ==========================
-- ส่วนของ Auto Hatch
local EGG_NAME = "Autumn Egg"           -- ชื่อไข่ที่จะสุ่ม
local HATCH_AMOUNT = 8                  -- จำนวนสุ่มต่อครั้ง (รองรับ 1, 3, หรือ 8)
local HATCH_DELAY = 0.05                -- เวลาระหว่างสุ่ม (วินาที) | คำเตือน: ค่าที่ต่ำเกินไปอาจทำให้ถูกตัดออกจากเซิร์ฟเวอร์

-- ส่วนของ Auto Chest
-- *** ปิดการเทเลพอร์ตเป็นค่าเริ่มต้น ***
local TELEPORT_TO_CHEST = false         -- true = เทเลพอร์ตไปที่กล่องก่อนเก็บ, false = ไม่เทเลพอร์ต
local CHEST_CHECK_INTERVAL = 10         -- ความถี่ในการตรวจหากล่อง (วินาที)
local CHEST_COLLECT_COOLDOWN = 60       -- คูลดาวน์หลังจากเก็บกล่องเดิมแล้ว (วินาที)

-- 📦 รายชื่อกล่องที่ต้องการให้เก็บ (สามารถเพิ่ม/ลบได้)
local CHEST_NAMES = {
    "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
    "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
    "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
}

-- ส่วนของการแจ้งเตือน (Webhook)
local ENABLE_WEBHOOK = false            -- ตั้งเป็น true เพื่อเปิดใช้งานการแจ้งเตือนผ่าน Discord
local WEBHOOK_URL = ""                  -- ใส่ URL ของ Discord Webhook ที่นี่

-- ==========================
-- 🧩 SERVICES & CORE SETUP
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

-- ✅ แปลงรายชื่อกล่องเป็น lowercase และเก็บใน Dictionary เพื่อการค้นหาที่รวดเร็ว (O(1) complexity)
local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end

-- ==========================
-- 📡 REMOTE EVENTS & UTILITIES
-- ==========================
local function logmsg(...) print("[NiTroHUB]", ...) end

local function findRemote(possibleNames)
    local locations = {ReplicatedStorage, player:WaitForChild("PlayerScripts")}
    for _, loc in ipairs(locations) do
        for _, obj in ipairs(loc:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local objNameLower = obj.Name:lower()
                for _, name in ipairs(possibleNames) do
                    if objNameLower == name:lower() or objNameLower:find(name:lower(), 1, true) then return obj end
                end
            end
        end
    end
    return nil
end

local hatchRemote = findRemote({"HatchEgg", "EggHatch", "RemoteEvent", "DefaultRemote"})
if hatchRemote then logmsg("✅ Hatch RemoteEvent พบแล้ว:", hatchRemote:GetFullName()) else warn("❌ ไม่พบ Hatch RemoteEvent!") end

local collectRemote = findRemote({"RemoteEvent", "DefaultRemote", "CollectChest"})
if collectRemote then logmsg("✅ Collect RemoteEvent พบแล้ว:", collectRemote:GetFullName()) else warn("❌ ไม่พบ Collect RemoteEvent, AutoChest อาจใช้ได้แค่ firetouchinterest") end

-- ==========================
-- 📊 STATE (ตัวแปรสถานะการทำงาน)
-- ==========================
local hatchRunning = false
local chestRunning = false
local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollectedChests = {}
local lastCollectedChestName = "-"
local currentStatus = "Idle"

-- ==========================
-- 💬 WEBHOOK FUNCTION
-- ==========================
local function sendWebhook(chestName)
    if not ENABLE_WEBHOOK or WEBHOOK_URL == "" then return end
    task.spawn(function()
        local data = {
            embeds = {{
                title = "✨ เก็บกล่องสมบัติสำเร็จ!",
                description = string.format("ผู้เล่น **%s** ได้เก็บ **%s**", player.Name, chestName),
                color = 0x00FFFF, -- สี Aqua
                footer = {text = "NiTroHUB PRO - Final Evolution"},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        local success, err = pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data))
        end)
        if not success then warn("⚠️ ไม่สามารถส่ง Webhook ได้:", err) end
    end)
end

-- ==========================
-- 🚀 PERFORMANCE PATCHES
-- ==========================
local function hideUnwantedGui(gui)
    local guiNamesToHide = {HatchEggUI=true, HatchAnimationGui=true, HatchGui=true, LastHatchGui=true, EggHatchUI=true, AutoDeleteUI=true, HatchPopupUI=true}
    if gui and guiNamesToHide[gui.Name] then
        pcall(function() gui.Enabled = false; gui.Visible = false; end)
    end
end
for _, child in ipairs(playerGui:GetChildren()) do hideUnwantedGui(child) end
playerGui.ChildAdded:Connect(hideUnwantedGui)
logmsg("✅ ระบบซ่อน UI การฟักไข่ทำงานแล้ว")

task.spawn(function()
    local success, err = pcall(function()
        local eggOpeningScript = player:WaitForChild("PlayerScripts"):WaitForChild("Scripts"):WaitForChild("Game"):WaitForChild("Egg Opening Frontend")
        local env = getfenv and getfenv(eggOpeningScript) or getsenv and getsenv(eggOpeningScript)
        if env and env.PlayEggAnimation then env.PlayEggAnimation = function() return end; logmsg("✅ ปิดอนิเมชันสุ่มไข่สำเร็จ") end
    end)
    if not success then warn("⚠️ ไม่สามารถปิดอนิเมชันสุ่มไข่ได้:", err) end
end)

-- ==========================
-- 🥚 AUTO HATCH
-- ==========================
task.spawn(function()
    while true do
        if hatchRunning then
            currentStatus = "กำลังฟักไข่..."
            pcall(function()
                hatchRemote:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
                eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
            end)
        end
        task.wait(HATCH_DELAY)
    end
end)

-- ==========================
-- 💰 AUTO CHEST (*** เวอร์ชันไม่เทเลพอร์ต ***)
-- ==========================
local function collectChest(chest)
    if not chest or not chest.Parent or not hrp then return end

    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < CHEST_COLLECT_COOLDOWN) then return end

    local success = false
    currentStatus = "กำลังพยายามเก็บ " .. chest.Name

    -- วิธีเก็บกล่อง (เหมือนเดิม แต่ไม่มีโค้ดเทเลพอร์ต)
    local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
    if trigger and firetouchinterest then
        firetouchinterest(hrp, trigger, 0); task.wait(0.1); firetouchinterest(hrp, trigger, 1)
        success = true
        logmsg("💰 [Touch] เก็บ Chest สำเร็จ:", chest.Name)
    elseif collectRemote then
        local remoteSuccess = pcall(function() collectRemote:FireServer("ClaimChest", chest.Name, true) end)
        if remoteSuccess then success = true; logmsg("💰 [Remote] ส่งคำสั่งเก็บ Chest:", chest.Name) end
    else
        warn("❌ ไม่สามารถเก็บกล่องได้: ไม่รองรับ firetouchinterest และไม่พบ Collect RemoteEvent")
    end

    -- อัปเดตสถานะเมื่อเก็บสำเร็จ
    if success then
        lastCollectedChests[key] = tick()
        chestsCollectedCount = chestsCollectedCount + 1
        lastCollectedChestName = chest.Name
        sendWebhook(chest.Name)
    end
end

task.spawn(function()
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
-- 💤 ANTI AFK
-- ==========================
task.spawn(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame); task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame); logmsg("💤 Anti-AFK ทำงาน")
        end)
    end)
end)

-- ==========================
-- 🎨 GUI INTERFACE & 🕹️ CONTROLS (*** คงไว้ตามเดิม ***)
-- ==========================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "NiTroHUB_PRO_GUI"; gui.IgnoreGuiInset = true; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.2, 0); frame.Size = UDim2.new(0, 260, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32); frame.Active = true; frame.Draggable = true
frame.BackgroundTransparency = 0.1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(80, 80, 80)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35); title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
title.Font = Enum.Font.GothamBold; title.Text = "🌀 NiTroHUB PRO 🌀"
title.TextColor3 = Color3.fromRGB(0, 225, 255); title.TextSize = 18
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)
local titleStroke = Instance.new("UIStroke", title); titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; titleStroke.Color = Color3.fromRGB(80, 80, 80)

-- ฟังก์ชันสร้างปุ่ม Toggle
local function createToggleButton(parent, text, hotkey, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Position = UDim2.new(0.5, -110, 0, yPos); btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(120, 120, 120)

    local function updateVisuals(state)
        if state then
            btn.Text = text .. " [ON] - ("..hotkey..")"
            btn.BackgroundColor3 = Color3.fromRGB(76, 175, 80) -- สีเขียว
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. " [OFF] - ("..hotkey..")"
            btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- สีแดง
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    return btn, updateVisuals
end

-- ปุ่มควบคุม
local hatchBtn, updateHatchBtn = createToggleButton(frame, "Auto Hatch", "J", 45)
local chestBtn, updateChestBtn = createToggleButton(frame, "Auto Chest", "K", 85)

local statsLabel = Instance.new("TextLabel", frame)
statsLabel.Size = UDim2.new(1, -20, 0, 65); statsLabel.Position = UDim2.new(0, 10, 0, 125)
statsLabel.BackgroundTransparency = 1; statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 13; statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top; statsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)

-- ฟังก์ชันควบคุมหลัก
local function toggleHatch()
    hatchRunning = not hatchRunning
    updateHatchBtn(hatchRunning)
    logmsg("Auto Hatch:", hatchRunning and "ON" or "OFF")
end

local function toggleChest()
    chestRunning = not chestRunning
    updateChestBtn(chestRunning)
    if not chestRunning and not hatchRunning then currentStatus = "Idle" end
    logmsg("Auto Chest:", chestRunning and "ON" or "OFF")
end

-- เชื่อมต่อ Event
hatchBtn.MouseButton1Click:Connect(toggleHatch)
chestBtn.MouseButton1Click:Connect(toggleChest)

-- ตั้งค่าเริ่มต้น
updateHatchBtn(hatchRunning)
updateChestBtn(chestRunning)

-- อัปเดต GUI Loop
task.spawn(function()
    while task.wait(0.25) do
        statsLabel.Text = string.format(
            "สถานะ: %s\nฟักไข่แล้ว: %d\nเก็บกล่องแล้ว: %d\nกล่องล่าสุด: %s",
            currentStatus, eggsHatchedCount, chestsCollectedCount, lastCollectedChestName
        )
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then toggleHatch() end
    if input.KeyCode == Enum.KeyCode.K then toggleChest() end
end)

logmsg("✅ NiTroHUB PRO - (Non-Teleport) Loaded! | J = สุ่มไข่, K = เก็บกล่อง")
