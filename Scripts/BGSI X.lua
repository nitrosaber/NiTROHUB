--// 🌀 NiTroHUB PRO - Infinity Hatch + Auto Chest (FULL)
--// ✨ by NiTroHUB x ChatGPT (2025 Revised Edition)
--//
--// คุณสมบัติ:
--//   - สุ่มไข่อัตโนมัติ (Infinity Hatch)
--//   - เก็บกล่องสมบัติที่กำหนดให้อัตโนมัติ (Auto Chest)
--//   - ปิดอนิเมชันและ UI การฟักไข่เพื่อลดอาการแลค
--//   - ระบบป้องกัน AFK (Anti-AFK)
--//   - GUI ควบคุมที่เรียบง่ายและลากตำแหน่งได้
--//   - Hotkey: กดปุ่ม 'J' เพื่อเปิด/ปิดการสุ่มไข่
--// =================================================================

-- ==========================
-- ⚙️ CONFIG (ตั้งค่าตามต้องการ)
-- ==========================
local EGG_NAME = "Autumn Egg"           -- ชื่อไข่ที่จะสุ่ม
local HATCH_AMOUNT = 8                  -- จำนวนสุ่มต่อครั้ง (รองรับ 1, 3, หรือ 8)
local HATCH_DELAY = 0.05                -- เวลาระหว่างสุ่ม (วินาที) | คำเตือน: ค่าที่ต่ำเกินไปอาจทำให้ถูกตัดออกจากเซิร์ฟเวอร์
local CHEST_CHECK_INTERVAL = 60         -- ความถี่ในการตรวจหากล่อง (วินาที)
local CHEST_COLLECT_COOLDOWN = 180      -- คูลดาวน์หลังจากเก็บกล่องเดิมแล้ว (วินาที)

-- 📦 รายชื่อกล่องที่ต้องการให้เก็บ (สามารถเพิ่ม/ลบได้)
local CHEST_NAMES = {
    "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
    "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
    "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
}

-- ==========================
-- 🧩 SERVICES & PLAYER
-- ==========================
-- การเรียกใช้ Services หลักของ Roblox
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- การเข้าถึงข้อมูลของผู้เล่น
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- รอให้ตัวละครโหลดเสร็จสมบูรณ์เพื่อป้องกัน Error
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- ✅ แปลงรายชื่อกล่องเป็น lowercase และเก็บใน Dictionary เพื่อการค้นหาที่รวดเร็ว (O(1) complexity)
local CHEST_LIST = {}
for _, name in ipairs(CHEST_NAMES) do
    CHEST_LIST[name:lower()] = true
end

-- ==========================
-- 📡 REMOTE EVENTS (ปรับปรุงการค้นหาให้ดีขึ้น)
-- ==========================
local function logmsg(...)
    print("[NiTroHUB]", ...)
end

-- ฟังก์ชันค้นหา RemoteEvent ที่ปรับปรุงใหม่
local function findRemote(possibleNames)
    local locations = {ReplicatedStorage, player:WaitForChild("PlayerScripts")} -- เพิ่มพื้นที่ค้นหา
    for _, loc in ipairs(locations) do
        for _, obj in ipairs(loc:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local objNameLower = obj.Name:lower()
                for _, name in ipairs(possibleNames) do
                    -- ค้นหาชื่อที่ตรงกันเป๊ะๆ ก่อน เพื่อความแม่นยำ
                    if objNameLower == name:lower() then
                        return obj
                    -- ถ้าไม่เจอ ให้ลองค้นหาจากบางส่วนของชื่อ
                    elseif objNameLower:find(name:lower(), 1, true) then
                        return obj
                    end
                end
            end
        end
    end
    return nil -- ค้นหาไม่พบ
end

-- ค้นหา RemoteEvent สำหรับการฟักไข่
local hatchRemote = findRemote({"HatchEgg", "EggHatch", "RemoteEvent", "DefaultRemote"})
if hatchRemote then
    logmsg("✅ Hatch RemoteEvent พบแล้ว:", hatchRemote:GetFullName())
else
    warn("❌ Hatch RemoteEvent ไม่พบ! สคริปต์อาจทำงานไม่สมบูรณ์")
end

-- ค้นหา RemoteEvent สำหรับการเก็บกล่อง (อาจเป็นอันเดียวกับ RemoteEvent หลัก)
local collectRemote = findRemote({"CollectChest", "TouchInterest", "RemoteEvent", "DefaultRemote"})
if collectRemote then
    logmsg("✅ Collect RemoteEvent พบแล้ว:", collectRemote:GetFullName())
else
    warn("❌ Collect RemoteEvent ไม่พบ! AutoChest อาจไม่ทำงาน")
end

-- ==========================
-- 📊 STATE (ตัวแปรสถานะการทำงาน)
-- ==========================
local running = false
local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollectedChests = {} -- ใช้เก็บข้อมูล {chestId = lastCollectTime}
local lastCollectedChestName = "-"

-- ==========================
-- 🔁 UI & ANIMATION PATCH (ปรับปรุงประสิทธิภาพ)
-- ==========================
-- ฟังก์ชันสำหรับซ่อน GUI ที่ไม่ต้องการ
local function hideUnwantedGui(gui)
    local guiNamesToHide = {
        HatchEggUI = true, HatchAnimationGui = true, HatchGui = true,
        LastHatchGui = true, EggHatchUI = true, AutoDeleteUI = true, HatchPopupUI = true
    }
    if gui and guiNamesToHide[gui.Name] then
        pcall(function()
            gui.Enabled = false
            gui.Visible = false
        end)
    end
end

-- ซ่อน GUI ที่มีอยู่แล้วตอนสคริปต์เริ่มทำงาน
for _, child in ipairs(playerGui:GetChildren()) do
    hideUnwantedGui(child)
end

-- ติดตาม GUI ที่จะถูกสร้างขึ้นมาใหม่ แล้วซ่อนทันที (ประสิทธิภาพดีกว่าการใช้ while loop)
playerGui.ChildAdded:Connect(hideUnwantedGui)
logmsg("✅ ระบบซ่อน UI การฟักไข่ทำงานแล้ว")

-- ปิดแอนิเมชันสุ่มไข่ (ต้องการ Executor ที่รองรับ getsenv)
task.spawn(function()
    local success, err = pcall(function()
        local eggOpeningScript = player:WaitForChild("PlayerScripts"):WaitForChild("Scripts"):WaitForChild("Game"):WaitForChild("Egg Opening Frontend")
        local env = getfenv and getfenv(eggOpeningScript) or getsenv and getsenv(eggOpeningScript)
        if env and env.PlayEggAnimation then
            env.PlayEggAnimation = function() return end -- แทนที่ฟังก์ชันเดิมด้วยฟังก์ชันว่างเปล่า
            logmsg("✅ ปิดอนิเมชันสุ่มไข่สำเร็จ")
        end
    end)
    if not success then
        warn("⚠️ ไม่สามารถปิดอนิเมชันสุ่มไข่ได้:", err)
    end
end)

-- ==========================
-- 🥚 AUTO HATCH
-- ==========================
local function hatchEgg()
    if not hatchRemote then return end
    -- ใช้ pcall เพื่อป้องกันสคริปต์หยุดทำงานหากเกิดข้อผิดพลาดในการส่งข้อมูล
    pcall(function()
        hatchRemote:FireServer("HatchEgg", EGG_NAME, HATCH_AMOUNT)
        eggsHatchedCount = eggsHatchedCount + HATCH_AMOUNT
    end)
end

task.spawn(function()
    while true do
        if running then
            hatchEgg()
        end
        task.wait(HATCH_DELAY)
    end
end)

-- ==========================
-- 💰 AUTO CHEST
-- ==========================
local function collectChest(chest)
    if not chest or not chest.Parent then return end

    -- ใช้ Unique ID ของ Instance เป็น key เพื่อป้องกันการเก็บซ้ำแม้จะถูกย้ายที่
    local key = chest:GetDebugId()
    if lastCollectedChests[key] and (tick() - lastCollectedChests[key] < CHEST_COLLECT_COOLDOWN) then
        return -- ยังอยู่ในช่วงคูลดาวน์
    end

    local trigger = chest:FindFirstChild("TouchTrigger") or chest:FindFirstChildWhichIsA("BasePart")
    if trigger then
        if firetouchinterest then
            firetouchinterest(hrp, trigger, 0) -- 0 for Touch
            task.wait(0.1)
            firetouchinterest(hrp, trigger, 1) -- 1 for Untouch
            lastCollectedChests[key] = tick()
            chestsCollectedCount = chestsCollectedCount + 1
            lastCollectedChestName = chest.Name
            logmsg("💰 เก็บ Chest สำเร็จ:", chest.Name)
        elseif collectRemote then
            -- Fallback: หากไม่มี firetouchinterest ให้ลองใช้ RemoteEvent
            pcall(function() collectRemote:FireServer(chest) end)
            lastCollectedChests[key] = tick()
            chestsCollectedCount = chestsCollectedCount + 1
            lastCollectedChestName = chest.Name
            logmsg("💰 [Fallback] ส่งคำสั่งเก็บ Chest:", chest.Name)
        else
            warn("❌ ฟังก์ชัน firetouchinterest ไม่รองรับ และไม่พบ Collect RemoteEvent")
        end
    end
end

task.spawn(function()
    while task.wait(CHEST_CHECK_INTERVAL) do
        local searchAreas = {Workspace, Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas")}
        for _, area in ipairs(searchAreas) do
            if area then
                for _, obj in ipairs(area:GetDescendants()) do
                    -- ตรวจสอบว่าเป็น Model และมีชื่ออยู่ในรายการที่กำหนดหรือไม่
                    if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                        pcall(collectChest, obj)
                    end
                end
            end
        end
    end
end)

-- ==========================
-- 💤 ANTI AFK
-- ==========================
task.spawn(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            logmsg("💤 Anti-AFK ทำงาน")
        end)
    end)
end)

-- ==========================
-- 🎨 GUI INTERFACE
-- ==========================
-- สร้าง GUI หลัก
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "NiTroHUB_InfinityHatch"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- สร้าง Frame หลัก
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.Size = UDim2.new(0, 240, 0, 160)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(80, 80, 80)

-- หัวข้อ
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
title.Font = Enum.Font.GothamBold
title.Text = "🌀 NiTroHUB PRO"
title.TextColor3 = Color3.fromRGB(0, 225, 255)
title.TextSize = 16
local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 12)
-- ทำให้มุมด้านล่างไม่โค้ง
local titleStroke = Instance.new("UIStroke", title)
titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
titleStroke.Color = Color3.fromRGB(80, 80, 80)

-- ปุ่มควบคุมหลัก
local btn = Instance.new("TextButton", frame)
btn.Position = UDim2.new(0.5, -90, 0.25, 0)
btn.Size = UDim2.new(0, 180, 0, 35)
btn.Text = "เริ่มสุ่มไข่ 🔁"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 15
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", btn).Color = Color3.fromRGB(90, 90, 90)

-- ป้ายแสดงสถานะ
local statsLabel = Instance.new("TextLabel", frame)
statsLabel.Size = UDim2.new(1, -20, 0.5, 0)
statsLabel.Position = UDim2.new(0, 10, 0.55, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 13
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
statsLabel.Text = "กำลังรอเริ่ม..."

-- ปุ่มย่อ/ขยาย (Icon)
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0, 50, 0, 50)
mini.Position = UDim2.new(0.02, 0, 0.7, 0)
mini.Text = "🌀"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 28
mini.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
mini.TextColor3 = Color3.fromRGB(0, 225, 255)
mini.BackgroundTransparency = 0.2
mini.Draggable = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", mini).Color = Color3.fromRGB(0, 225, 255)

-- Tooltip
local tip = Instance.new("TextLabel", mini)
tip.Size = UDim2.new(0, 120, 0, 30)
tip.Position = UDim2.new(1, 5, 0.25, 0)
tip.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tip.TextColor3 = Color3.fromRGB(0, 225, 255)
tip.Text = "NiTroHUB PRO"
tip.Font = Enum.Font.GothamBold
tip.TextSize = 14
tip.Visible = false
tip.BackgroundTransparency = 0.2
Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 8)

-- ==========================
-- 🕹️ CONTROLS & LOGIC
-- ==========================
-- ฟังก์ชันกลางสำหรับเปิด/ปิดสคริปต์
local function toggleScript(newState)
    running = (newState == nil) and not running or newState
    if running then
        btn.Text = "หยุดสุ่ม ⏸️"
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        logmsg("✅ เริ่มสุ่มไข่...")
    else
        btn.Text = "เริ่มสุ่มไข่ 🔁"
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        logmsg("⏸️ หยุดสุ่มไข่แล้ว")
    end
end

-- เชื่อมต่อฟังก์ชันกับปุ่ม
btn.MouseButton1Click:Connect(function()
    toggleScript()
end)

-- การทำงานของปุ่มย่อ/ขยาย
mini.MouseEnter:Connect(function() tip.Visible = true end)
mini.MouseLeave:Connect(function() tip.Visible = false end)
mini.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

-- อัปเดตข้อความสถานะ
task.spawn(function()
    while true do
        statsLabel.Text = string.format("ฟักไข่แล้ว: %d\nเก็บกล่องแล้ว: %d\nกล่องล่าสุด: %s",
            eggsHatchedCount, chestsCollectedCount, lastCollectedChestName)
        task.wait(0.5)
    end
end)

-- Hotkey (ปุ่ม J)
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then
        toggleScript()
    end
end)

logmsg("✅ NiTroHUB PRO - Infinity Hatch + AutoChest Loaded! | กด 'J' เพื่อเริ่ม/หยุด")
