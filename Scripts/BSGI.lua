-- 🌌 BGSI HUB - Deluxe Edition (v8.3 Full Clean + AutoLoad + Debug UI)
-- ✅ Rayfield UI | Auto Hatch | Hatch Disable | Safety | Auto-Rehook | Smart Autosave | Colored Debug Console
-- ✨ By NiTroHub x ChatGPT (Rayfield Integrated Debug Edition)

---------------------------------------------------------------------
-- 🧱 Load Rayfield
---------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

---------------------------------------------------------------------
-- ⚙️ Roblox Services
---------------------------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------------------
-- 🧠 Safe Wait
---------------------------------------------------------------------
local function safeWait(parent, name, timeout)
    local ok, obj = pcall(function() return parent:WaitForChild(name, timeout or 10) end)
    if not ok then warn("⚠️ Missing:", name) end
    return obj
end

---------------------------------------------------------------------
-- 🔌 Game Remote
---------------------------------------------------------------------
local RemoteEvent = safeWait(ReplicatedStorage, "Shared")
if RemoteEvent then
    RemoteEvent = safeWait(RemoteEvent, "Framework")
    RemoteEvent = safeWait(RemoteEvent, "Network")
    RemoteEvent = safeWait(RemoteEvent, "Remote")
    RemoteEvent = safeWait(RemoteEvent, "RemoteEvent")
end
if not RemoteEvent then warn("❌ Missing RemoteEvent, some features may not work.") end

---------------------------------------------------------------------
-- ⚙️ Flags / Settings
---------------------------------------------------------------------
local flags = {
    BlowBubble = false,
    AutoClaimChest = false,
    AutoHatchEgg = false,
    DisableAnimation = false,
    AntiAFK = true
}
local settings = { EggName = "Infinity Egg", HatchAmount = 6 }
local tasks, conns = {}, {}
local hatchPatched = false

---------------------------------------------------------------------
-- 🧰 Debug Console (Core)
---------------------------------------------------------------------
local DEBUG_MAX = 200
local DebugLog = {}
local DebugParagraph
local function ts() return os.date("%H:%M:%S") end

-- สีข้อความ
local colors = {
    ["loop"] = "#5AC8FA",
    ["patch"] = "#4CD964",
    ["cleaner"] = "#FFD60A",
    ["safety"] = "#A2845E",
    ["error"] = "#FF3B30",
    ["warn"] = "#FF9500",
    ["info"] = "#FFFFFF",
}

local function getColorForLog(msg)
    msg = msg:lower()
    for key, hex in pairs(colors) do
        if msg:find(key) then
            return hex
        end
    end
    return "#FFFFFF"
end

local function renderColoredLogs()
    if not DebugParagraph then return end
    local start = math.max(1, #DebugLog - 80 + 1)
    local buf = {}
    for i = start, #DebugLog do
        local msg = DebugLog[i]
        local hex = getColorForLog(msg)
        buf[#buf+1] = string.format("<font color='%s'>%s</font>", hex, msg)
    end
    DebugParagraph:Set({
        Title = "📋 Debug Output",
        Content = table.concat(buf, "\n")
    })
end

local function pushLog(text)
    table.insert(DebugLog, ("[%s] %s"):format(ts(), tostring(text)))
    if #DebugLog > DEBUG_MAX then table.remove(DebugLog, 1) end
    renderColoredLogs()
end

function dbg(...)
    local msg = table.concat(table.pack(...), " ")
    print("[BGSI]", msg)
    pushLog(msg)
end

---------------------------------------------------------------------
-- 🎬 Disable Hatch Animation (No GUI Clean)
---------------------------------------------------------------------
local function makeStub()
    local function noop(...) return nil end
    return setmetatable({
        Play = noop, Hatch = noop, Open = noop, Init = noop,
        Animate = noop, Create = noop, Show = noop, Hide = noop
    }, { __call = noop, __index = function() return noop end })
end

local function patchModuleNoop(tbl)
    if type(tbl) ~= "table" then return end
    for k, v in pairs(tbl) do
        if type(v) == "function" then
            tbl[k] = function(...) return nil end
        elseif type(v) == "table" then
            patchModuleNoop(v)
        end
    end
end

local function tryPatchLoadedModules(target)
    if typeof(getloadedmodules) ~= "function" then return false end
    for _, m in ipairs(getloadedmodules()) do
        if m == target or (m.Name == "HatchEgg" and m.Parent and m.Parent.Name == "Effects") then
            local ok, lib = pcall(require, m)
            if ok and type(lib) == "table" then
                patchModuleNoop(lib)
                dbg("Patch: HatchEgg module functions disabled.")
                return true
            end
        end
    end
    return false
end

local function patchHatchEgg()
    local client = ReplicatedStorage:FindFirstChild("Client") or safeWait(ReplicatedStorage, "Client", 10)
    local effects = client and client:FindFirstChild("Effects") or safeWait(client, "Effects", 10)
    if not effects then dbg("Warn: Effects folder not found."); return end

    local target = effects:FindFirstChild("HatchEgg")
    if not target then dbg("Warn: HatchEgg module not found yet."); return end

    local stub = makeStub()
    pcall(function() tryPatchLoadedModules(target) end)

    local env = (pcall(function() return getrenv() end) and getrenv()) or _G
    local req = (rawget(env, "require") or require)

    if typeof(req) == "function" and hookfunction and not _G.HatchReqHooked then
        _G.HatchReqHooked = true
        local old
        old = hookfunction(req, function(mod, ...)
            if typeof(mod) == "Instance" and mod:IsA("ModuleScript") then
                if mod == target or (mod.Name == "HatchEgg" and mod.Parent and mod.Parent.Name == "Effects") then
                    dbg("Stubbed require(HatchEgg).")
                    return stub
                end
            end
            return old(mod, ...)
        end)
        dbg("Hooked require() for HatchEgg.")
    end

    -- Auto re-patch (no GUI cleaning)
    if conns.HatchAuto then pcall(function() conns.HatchAuto:Disconnect() end) end
    conns.HatchAuto = effects.ChildAdded:Connect(function(child)
        if child.Name == "HatchEgg" then
            task.wait(0.5)
            pcall(function()
                tryPatchLoadedModules(child)
                dbg("Auto-rehook on HatchEgg ChildAdded (no GUI cleaning).")
            end)
        end
    end)

    dbg("patchHatchEgg completed (GUI untouched).")
end

local function DisableHatchAnimation()
    if hatchPatched then dbg("Info: DisableHatchAnimation already applied."); return end
    hatchPatched = true
    task.spawn(function()
        pcall(patchHatchEgg)
        Rayfield:Notify({
            Title = "🎬 Hatch Animation Disabled",
            Content = "Delta Auto-Rehook Active ✅",
            Duration = 3
        })
        dbg("Info: Hatch animation disabled successfully (GUI untouched).")
    end)
end

-- Auto-run after load
task.defer(function()
    task.wait(1)
    if flags.DisableAnimation then
        pcall(DisableHatchAnimation)
    end
end)

---------------------------------------------------------------------
-- 🧩 Universal Fake GUI Fix (for Hatching errors)
---------------------------------------------------------------------
task.spawn(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not pg then
        dbg("Warn: PlayerGui not found; cannot create fake GUI.")
        return
    end

    local possibleParents = {
        pg,
        pg:FindFirstChild("ScreenGui"),
        pg:FindFirstChildWhichIsA("ScreenGui"),
        pg:FindFirstChild("Gui"),
        pg:FindFirstChild("GuiFrame"),
    }

    local created = false
    for _, parent in ipairs(possibleParents) do
        if parent and not parent:FindFirstChild("Hatching") then
            local fake = Instance.new("Frame")
            fake.Name = "Hatching"
            fake.Visible = false
            fake.Size = UDim2.new(0, 0, 0, 0)
            fake.Parent = parent
            dbg("Patch: Added fake Hatching GUI under " .. parent.Name)
            created = true
        end
    end

    if not created then
        dbg("Info: No valid parent found for fake Hatching GUI (may already exist).")
    end
end)

---------------------------------------------------------------------
-- 🔄 Core Loops
---------------------------------------------------------------------
--Bubble
local function BlowBubbleLoop()
    local ok,err = pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    if not ok then dbg("BlowBubble error:", err) end
    task.wait(0.1)
end

--Chest
local function AutoClaimChestLoop()
    local chests = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest","Dice Chest",
        "Infinity Chest","Void Chest","Giant Chest","Ticket Chest",
        "Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }

    for _, chestName in ipairs(chests) do
        local chest = workspace:FindFirstChild(chestName, true)
        if chest then
            -- ตรวจสอบว่ามีคุณสมบัติ "CanClaim" หรือไม่
            local canClaim = nil
            pcall(function()
                -- เผื่อบางเกมมี ValueObject เก็บสถานะไว้
                local val = chest:FindFirstChild("CanClaim") or chest:FindFirstChild("Ready") or chest:FindFirstChild("Available")
                if val and val:IsA("BoolValue") then
                    canClaim = val.Value
                elseif val and val:IsA("NumberValue") and val.Value <= 0 then
                    -- ถ้าใช้ตัวเลขนับถอยหลัง (Cooldown)
                    canClaim = true
                end
            end)

            if canClaim == nil or canClaim == true then
                -- ✅ เคลมได้แล้ว → ยิง RemoteEvent
                local ok, err = pcall(function()
                    RemoteEvent:FireServer("ClaimChest", chestName, true)
                end)
                if ok then
                    dbg("Claimed chest:", chestName)
                else
                    dbg("ClaimChest error:", chestName, err)
                end
            else
                dbg("Info: Chest not ready →", chestName)
            end
        else
            dbg("Warn: Chest not found →", chestName)
        end
    end

    -- รอรอบต่อไป (สามารถปรับเวลาได้)
    task.wait(5)
end

--AutoHatch
local MIN_INTERVAL = 0.12   -- ระยะเวลาขั้นต่ำ (วินาที) ที่จะรอคำสั่งถัดไป
local MAX_INTERVAL = 1.5    -- ถ้าเกิดปัญหาจะเพิ่มจนไม่เกินค่านี้
local BACKOFF_FACTOR = 1.8  -- คูณเวลาเมื่อเกิด error
local JITTER = 0.06         -- เพิ่ม/ลบนิดหน่อยเพื่อหลีกเลี่ยง pattern ตายตัว
local MAX_ERRORS = 5        -- ถ้าเกิด error ติดต่อกันเกินนี้จะหยุด AutoHatch
local MAX_DISTANCE = 50     -- ระยะสูงสุด (studs) ที่อนุญาตให้ฟักไข่

-- internal state
local hatchInterval = MIN_INTERVAL
local consecutiveErrors = 0

local function randomJitter()
    return (math.random() * 2 - 1) * JITTER -- ค่าระหว่าง -JITTER .. +JITTER
end

local function resetBackoff()
    hatchInterval = MIN_INTERVAL
    consecutiveErrors = 0
end

local function increaseBackoff()
    hatchInterval = math.min(MAX_INTERVAL, hatchInterval * BACKOFF_FACTOR)
    hatchInterval = hatchInterval + randomJitter()
    consecutiveErrors = consecutiveErrors + 1
end

local function AutoHatchEggLoop()
    local ok, err = pcall(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- หาไข่ใน workspace
        local egg = workspace:FindFirstChild(settings.EggName, true)
        if not egg then
            dbg("Warn: Egg not found →", settings.EggName)
            -- ถ้าไม่เจอ ให้เพิ่ม backoff เพื่อไม่สแปมการค้นหา
            increaseBackoff()
            if consecutiveErrors >= MAX_ERRORS then
                flags.AutoHatchEgg = false
                stopLoop("AutoHatchEgg")
                Rayfield:Notify({Title="⛔ AutoHatch Stopped", Content="ไม่พบไข่หลายครั้ง กำลังหยุด", Duration=3})
            end
            return
        end

        -- คำนวณตำแหน่งของไข่
        local eggPos
        if egg:IsA("Model") and egg.GetPivot then
            eggPos = egg:GetPivot().Position
        elseif egg:IsA("BasePart") then
            eggPos = egg.Position
        else
            -- กรณีวัตถุไม่รองรับ
            dbg("Warn: Egg object not a Model/BasePart")
            increaseBackoff()
            return
        end

        -- เช็กระยะ ถ้าไกลเกินหยุด AutoHatch
        local dist = (hrp.Position - eggPos).Magnitude
        if dist > MAX_DISTANCE then
            flags.AutoHatchEgg = false
            stopLoop("AutoHatchEgg")
            Rayfield:Notify({Title="⛔ Out of Range", Content="อยู่นอกระยะ ("..math.floor(dist).." studs). AutoHatch หยุด", Duration=3})
            dbg("Warn: Too far from egg:", math.floor(dist))
            return
        end

        -- ส่งคำขอฟักไข่แบบปลอดภัย (pcall)
        local fired, fireErr = pcall(function()
            RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
        end)

        if not fired then
            dbg("HatchEgg FireServer fail:", fireErr)
            increaseBackoff()
            if consecutiveErrors >= MAX_ERRORS then
                flags.AutoHatchEgg = false
                stopLoop("AutoHatchEgg")
                Rayfield:Notify({Title="❗ AutoHatch Disabled", Content="เกิดข้อผิดพลาดซ้ำหลายครั้ง", Duration=4})
            end
            return
        end

        -- ถ้า FireServer สำเร็จ ให้รีเซ็ต backoff เล็กน้อย
        resetBackoff()
    end)

    if not ok then
        dbg("AutoHatch loop outer pcall error:", err)
        increaseBackoff()
    end

    -- รอโดยใช้ hatchInterval (adaptive) แต่ไม่ต่ำกว่า MIN_INTERVAL
    task.wait(math.max(MIN_INTERVAL, hatchInterval))
end

--Loop On/Off
local function stopLoop(name)
    flags[name] = false
    if tasks[name] then pcall(function() task.cancel(tasks[name]) end) end
    tasks[name] = nil
    dbg("Stopped loop:", name)
end

local function startLoop(name, fn, delay)
    if tasks[name] then return end
    dbg("Started loop:", name)
    tasks[name] = task.spawn(function()
        while flags[name] do
            local ok, err = pcall(fn)
            if not ok then dbg("[Loop Error:", name .. "]", err) end
            task.wait(delay or 0.1)
        end
        tasks[name] = nil
    end)
end

---------------------------------------------------------------------
-- 🪟 Rayfield Window
---------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name="🌌 BGSI HUB / By NiTroHub",
    LoadingTitle="Loading NiTroHub...",
    LoadingSubtitle="By NiTroHub",
    ConfigurationSaving={Enabled=true,FolderName="NiTroHub",FileName="BGSI-Default",Autosave=false,Autoload=false}
})
Rayfield:Notify({Title="✅ BGSI HUB Ready", Content="By NiTroHub | Systems Loaded", Duration=3})

---------------------------------------------------------------------
-- ⚙️ Controls Tab
---------------------------------------------------------------------
local Controls = Window:CreateTab("⚙️ Main")

Controls:CreateToggle({
    Name="Blow Bubble", CurrentValue=false,
    Callback=function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.5) else stopLoop("BlowBubble") end
    end
})

Controls:CreateToggle({
    Name="Auto Claim All Chests", CurrentValue=false,
    Callback=function(v)
        flags.AutoClaimChest = v
        if v then startLoop("AutoClaimChest", AutoClaimChestLoop, 3) else stopLoop("AutoClaimChest") end
    end
})

Controls:CreateToggle({
    Name="Auto Hatch)", CurrentValue=false,
    Callback=function(v)
        flags.AutoHatchEgg = v
        if v then
            if flags.DisableAnimation then DisableHatchAnimation() end
            startLoop("AutoHatchEgg", AutoHatchEggLoop, 0.15)
        else
            stopLoop("AutoHatchEgg")
        end
    end
})

Controls:CreateToggle({
    Name="Disable Hatch Animation", CurrentValue=flags.DisableAnimation,
    Callback=function(v)
        flags.DisableAnimation = v
        if v then DisableHatchAnimation()
        else Rayfield:Notify({Title="⚙️ Rejoin Required", Content="Rejoin to restore animations.", Duration=3}) end
    end
})

Controls:CreateInput({
    Name="Egg Name", PlaceholderText=" Infinity Egg ", RemoveTextAfterFocusLost=false,
    Callback=function(t) settings.EggName = t dbg("Set EggName: ", t) end
})

Controls:CreateInput({
    Name="Hatch Amount (1/ 3/ 6/ 8/ 9/ 10/ 11/ 12)", PlaceholderText=" 6 ", RemoveTextAfterFocusLost=false,
    Callback=function(t)
        local n = tonumber(t)
        if n and table.find({1,3,6,8,9,10,11,12}, n) then
            settings.HatchAmount = n
            dbg("Set HatchAmount:", n)
        else
            dbg("Invalid HatchAmount:", t)
        end
    end
})

Controls:CreateInput({
    Name="Min Hatch Interval (sec)", PlaceholderText=" 0.12 ",
    Callback=function(t)
        local n = tonumber(t)
        if n and n >= 0.05 then MIN_INTERVAL = n dbg("Set MIN_INTERVAL:", n) end
    end
})
Controls:CreateInput({
    Name="Max Hatch Distance (stud)", PlaceholderText=" 50 ",
    Callback=function(t)
        local n = tonumber(t)
        if n and n > 0 then MAX_DISTANCE = n dbg("Set MAX_DISTANCE:", n) end
    end
})

---------------------------------------------------------------------
-- 🛡️ Safety Tab
---------------------------------------------------------------------
local Safety = Window:CreateTab("🛡️ Safety")

Safety:CreateToggle({
    Name="Anti-AFK", CurrentValue=flags.AntiAFK,
    Callback=function(v)
        flags.AntiAFK = v
        if conns.AFK then conns.AFK:Disconnect() conns.AFK=nil end
        if v then
            conns.AFK = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
        dbg("Anti-AFK:", v and "ON" or "OFF")
    end
})

Safety:CreateButton({
    Name="♻️ Auto Reconnect",
    Callback=function()
        LocalPlayer.OnTeleport:Connect(function(s)
            if s==Enum.TeleportState.Failed then
                task.wait(3)
                TeleportService:Teleport(game.PlaceId)
            end
        end)
        Rayfield:Notify({Title="🌐 Auto Reconnect", Content="Enabled", Duration=3})
        dbg("AutoReconnect: enabled")
    end
})

---------------------------------------------------------------------
-- ⚙️ Settings Tab \ Performance Booster \ FPS Limiter / Unlocker
---------------------------------------------------------------------
local SettingsTab = Window:CreateTab("⚙️ Settings")

--Performance Booster
local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")

local perfState = false
local oldSettings = {}

SettingsTab:CreateToggle({
    Name = "🚀 Performance Booster (ลดแลค / เพิ่มเฟรมเรต)",
    CurrentValue = false,
    Callback = function(v)
        perfState = v
        if v then
            -- บันทึกค่าปัจจุบัน
            oldSettings = {
                GlobalShadows = lighting.GlobalShadows,
                FogEnd = lighting.FogEnd,
                Brightness = lighting.Brightness,
                WaterWaveSize = terrain.WaterWaveSize,
                WaterTransparency = terrain.WaterTransparency
            }

            -- ปรับค่าให้อยู่ในโหมดประสิทธิภาพสูง
            lighting.GlobalShadows = false
            lighting.FogEnd = 100000
            lighting.Brightness = 1
            terrain.WaterWaveSize = 0
            terrain.WaterTransparency = 1

            -- ปิด ParticleEffects และ Decals หนัก ๆ
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Explosion") then
                    obj.Visible = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end

            Rayfield:Notify({
                Title = "🚀 Performance Mode Enabled",
                Content = "ลดอาการแลคและเพิ่ม FPS สำเร็จ!",
                Duration = 3
            })
            dbg("Info: Performance Booster enabled.")
        else
            -- คืนค่ากลับเมื่อปิด
            lighting.GlobalShadows = oldSettings.GlobalShadows or true
            lighting.FogEnd = oldSettings.FogEnd or 5000
            lighting.Brightness = oldSettings.Brightness or 2
            terrain.WaterWaveSize = oldSettings.WaterWaveSize or 0.15
            terrain.WaterTransparency = oldSettings.WaterTransparency or 0.3

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = true
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 0
                end
            end

            Rayfield:Notify({
                Title = "🧹 Performance Mode Disabled",
                Content = "คืนค่าภาพปกติแล้ว",
                Duration = 3
            })
            dbg("Cleaner: Performance Booster disabled.")
        end
    end
})

--Fps Unlocker
local currentFPS = 60

SettingsTab:CreateDropdown({
    Name = "🎯 FPS Limiter / Unlocker",
    Options = {"30 FPS", "60 FPS", "120 FPS", "240 FPS", "🔓 Unlimited"},
    CurrentOption = "60 FPS",
    Callback = function(option)
        -- ✅ Rayfield ส่งค่ากลับมาเป็น table เช่น { "60 FPS" }
        local selected = option
        if type(option) == "table" then
            selected = option[1]
        end

        if not selected then
            dbg("Warn: FPS dropdown returned nil option")
            return
        end

        -- ✅ แปลงค่าที่เลือกเป็นตัวเลข FPS
        if string.find(selected, "30") then currentFPS = 30
        elseif string.find(selected, "60") then currentFPS = 60
        elseif string.find(selected, "120") then currentFPS = 120
        elseif string.find(selected, "240") then currentFPS = 240
        elseif string.find(selected, "Unlimited") then currentFPS = 999 end

        -- ✅ ใช้งาน setfpscap() ถ้ามีใน executor
        if typeof(setfpscap) == "function" then
            setfpscap(currentFPS)
            if currentFPS == 0 then
                Rayfield:Notify({
                    Title = "🔓 FPS Unlocked",
                    Content = "FPS ปลดล็อกเต็มศักยภาพ!",
                    Duration = 3
                })
                dbg("Info: FPS unlocked (no limit).")
            else
                Rayfield:Notify({
                    Title = "🎯 FPS Limited",
                    Content = "ตั้งค่า FPS: " .. currentFPS,
                    Duration = 3
                })
                dbg("Info: FPS capped to", currentFPS)
            end
        else
            warn("⚠️ setfpscap() not supported in this executor.")
            dbg("Warn: FPS limiter not supported.")
        end
    end
})

--Destroy Ui ปิดการทำงานทุกอย่าง
SettingsTab:CreateButton({
    Name="🧨 Destroy UI",
    Callback=function()
        for k in pairs(flags) do stopLoop(k) end
        Rayfield:Destroy()
        dbg("UI destroyed by user.")
    end
})

---------------------------------------------------------------------
-- 📊 Debug Log Tab (Rayfield Integrated)
---------------------------------------------------------------------
local DebugTab = Window:CreateTab("📊 Debug Log")

DebugParagraph = DebugTab:CreateParagraph({
    Title = "📋 Debug Output",
    Content = "<b><font color='#AAAAAA'>Logs will appear here...</font></b>"
})

DebugTab:CreateButton({
    Name = "🧹 Clear Log",
    Callback = function()
        DebugLog = {}
        DebugParagraph:Set({
            Title = "📋 Debug Output",
            Content = "<b><font color='#888888'>[Logs Cleared]</font></b>"
        })
        dbg("Cleaner: Debug log cleared.")
    end
})

DebugTab:CreateButton({
    Name = "📥 Export Log to File",
    Callback = function()
        local exportName = ("BGSI_Debug_%s.txt"):format(os.date("%Y%m%d_%H%M%S"))
        local start = math.max(1, #DebugLog - 200 + 1)
        local buf = {}
        for i = start, #DebugLog do buf[#buf+1] = DebugLog[i] end
        writefile(exportName, table.concat(buf, "\n"))
        Rayfield:Notify({Title="📥 Exported", Content=exportName, Duration=3})
        dbg("Info: Exported debug log to file →", exportName)
    end
})

dbg("Info: Debug UI (Rayfield Integrated) initialized.")