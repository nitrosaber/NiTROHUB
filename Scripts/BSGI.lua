-- 🌌 BGSI HUB - Deluxe Edition (v8.3.1 Stable + AutoLoad + Debug UI)
-- ✅ Rayfield UI | Auto Hatch | Hatch Disable | Safety | Auto-Rehook | Smart Autosave | Debug Console
-- ✨ Patched to remove nil-call bugs / safer on all executors

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
-- 🔌 Game Remote (best-effort chain)
---------------------------------------------------------------------
local RemoteEvent = safeWait(ReplicatedStorage, "Shared")
if RemoteEvent then
    RemoteEvent = safeWait(RemoteEvent, "Framework") or RemoteEvent
    RemoteEvent = safeWait(RemoteEvent, "Network") or RemoteEvent
    RemoteEvent = safeWait(RemoteEvent, "Remote") or RemoteEvent
    RemoteEvent = safeWait(RemoteEvent, "RemoteEvent") or RemoteEvent
end
if not RemoteEvent or (not RemoteEvent.FireServer and not RemoteEvent.InvokeServer) then
    warn("❌ Missing/invalid RemoteEvent; some features may not work.")
    RemoteEvent = nil
end

---------------------------------------------------------------------
-- ⚙️ Flags / Settings
---------------------------------------------------------------------
local flags = {
    BlowBubble = false,
    AutoClaimChest = false,
    AutoHatchEgg = false,
    DisableAnimation = true,
    AntiAFK = true
}
local settings = { EggName = "Infinity Egg", HatchAmount = 6 }
local tasks, conns = {}, {}
local hatchPatched = false

---------------------------------------------------------------------
-- 🧰 Debug Console (UI + Logger)
---------------------------------------------------------------------
local DEBUG_MAX = 200
local DebugLog = {}
local DebugLabel

local function ts() return os.date("%H:%M:%S") end
local function pushLog(text)
    table.insert(DebugLog, ("[%s] %s"):format(ts(), tostring(text)))
    if #DebugLog > DEBUG_MAX then table.remove(DebugLog, 1) end
end

-- FIX: Luau ไม่มี table.pack → สร้างเองแบบปลอดภัย + tostring ทุกอาร์กิวเมนต์
local function dbg(...)
    local n = select("#", ...)
    local parts = table.create(n)
    for i = 1, n do
        parts[i] = tostring(select(i, ...))
    end
    local msg = table.concat(parts, " ")
    print("[BGSI]", msg)
    pushLog(msg)
    if DebugLabel and DebugLabel.Set then
        local start = math.max(1, #DebugLog - 60 + 1)
        local slice = {}
        for i = start, #DebugLog do slice[#slice+1] = DebugLog[i] end
        DebugLabel:Set(table.concat(slice, "\n"))
    end
end

---------------------------------------------------------------------
-- 🎬 Disable Hatch Animation (Ultra-Safe)
---------------------------------------------------------------------
local function makeStub()
    local function noop(...) return nil end
    return setmetatable({
        Play=noop,Hatch=noop,Open=noop,Init=noop,
        Animate=noop,Create=noop,Show=noop,Hide=noop
    }, { __call=noop, __index=function() return noop end })
end

local function patchModuleNoop(tbl)
    if type(tbl) ~= "table" then return end
    for k,v in pairs(tbl) do
        if type(v)=="function" then
            tbl[k] = function(...) return nil end
        end
    end
end

local function tryPatchLoadedModules(target)
    if typeof(getloadedmodules) ~= "function" then return false end
    for _,m in ipairs(getloadedmodules()) do
        if m==target or (m.Name=="HatchEgg" and m.Parent and m.Parent.Name=="Effects") then
            local ok,lib = pcall(require, m)
            if ok and type(lib)=="table" then
                patchModuleNoop(lib)
                dbg("patch", "Patched loaded HatchEgg table.")
                return true
            end
        end
    end
    return false
end

-- Safe hide (ไม่ Destroy ถ้าไม่จำเป็น)
local function setIfExists(obj, prop, value)
    if obj and obj[prop] ~= nil then
        local ok = pcall(function() obj[prop] = value end)
        return ok
    end
end

local function cleanHatchGUI()
    local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    local removed, hidden = 0, 0
    local allowed = {
        ["hatchegg"]=true,["hatchanimation"]=true,["hatching"]=true,
        ["eggopen"]=true,["egg_ui"]=true,["hatch_ui"]=true,["eggpopup"]=true
    }

    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("ScreenGui") or d:IsA("Frame") or d:IsA("Folder") then
            local n = (d.Name or ""):lower()
            if allowed[n] then
                local hid = false
                hid = setIfExists(d, "Enabled", false) or hid
                hid = setIfExists(d, "Visible", false) or hid
                if hid then
                    hidden += 1
                else
                    pcall(function() d:Destroy() end)
                    removed += 1
                end
            end
        end
    end
    dbg("cleaner", ("Hidden %d | Removed %d Hatch GUI nodes."):format(hidden, removed))
end

local function patchHatchEgg()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local effects = client and client:FindFirstChild("Effects")
    if not effects then dbg("patch", "Effects folder not found."); return end

    local target = effects:FindFirstChild("HatchEgg")
    if not target then dbg("patch", "HatchEgg module not found yet."); return end

    local stub = makeStub()
    pcall(function() tryPatchLoadedModules(target) end)

    local env = (pcall(function() return getrenv() end) and getrenv()) or _G
    local req = (rawget(env or {}, "require") or require)

    if typeof(req)=="function" and hookfunction and not _G.HatchReqHooked then
        _G.HatchReqHooked = true
        local old
        old = hookfunction(req, function(mod, ...)
            if typeof(mod)=="Instance" and mod:IsA("ModuleScript") then
                if mod==target or (mod.Name=="HatchEgg" and mod.Parent and mod.Parent.Name=="Effects") then
                    dbg("patch", "Stubbed require(HatchEgg).")
                    return stub
                end
            end
            return old(mod, ...)
        end)
        dbg("patch", "Hooked require() for HatchEgg.")
    end

    if conns.HatchAuto then pcall(function() conns.HatchAuto:Disconnect() end) end
    conns.HatchAuto = effects.ChildAdded:Connect(function(child)
        if child.Name == "HatchEgg" then
            task.wait(0.5)
            pcall(function()
                tryPatchLoadedModules(child)
                cleanHatchGUI()
                dbg("patch", "Auto-rehook on HatchEgg ChildAdded.")
            end)
        end
    end)
    dbg("patch", "patchHatchEgg completed.")
end

local function DisableHatchAnimation()
    if hatchPatched then dbg("patch", "DisableHatchAnimation: already applied."); return end
    hatchPatched = true
    pcall(patchHatchEgg)
    pcall(cleanHatchGUI)
    Rayfield:Notify({Title="🎬 Hatch Animation Disabled", Content="Delta Auto-Rehook Active ✅", Duration=3})
    dbg("patch", "Hatch animation disabled.")
end

task.defer(function()
    task.wait(1)
    if flags.DisableAnimation then
        pcall(DisableHatchAnimation)
    end
end)

--------------------------------------------------------------------
-- Helpers สำหรับเคลม “Chest” อย่างทนทาน
--------------------------------------------------------------------
local RS = game:GetService("ReplicatedStorage")
local function isRemote(x) return x and (x:IsA("RemoteEvent") or x:IsA("RemoteFunction")) end

local function sendRemote(remote, op, ...)
    if not isRemote(remote) then return false, "no-remote" end
    if remote:IsA("RemoteEvent") then
        local ok, err = pcall(function() remote:FireServer(op, ...) end)
        return ok, err
    else
        local ok, res = pcall(function() return remote:InvokeServer(op, ...) end)
        return ok, res
    end
end

local function findChestRemotes()
    local out = {}
    for _,obj in ipairs(RS:GetDescendants()) do
        if isRemote(obj) then
            local n = (obj.Name or ""):lower()
            if n:find("chest") or n:find("reward") or n:find("claim") then
                table.insert(out, obj)
            end
        end
    end
    return out
end

local CHEST_OPS = { "ClaimChest","RedeemChest","CollectChest","ClaimReward","RedeemReward" }
local function tryClaimVia(remote, chestName)
    if not isRemote(remote) then return false end
    local payloads = {
        {chestName, true},
        {chestName},
        {{chestName}},
        {{Chest = chestName, Auto = true}},
        {{Chest = chestName}},
        {{Name = chestName}},
    }
    for _,op in ipairs(CHEST_OPS) do
        for i,args in ipairs(payloads) do
            local ok = sendRemote(remote, op, table.unpack(args))
            if ok == true then
                dbg("patch", ("Chest OK: %s via %s payload#%d"):format(op, remote.Name, i))
                return true
            end
        end
    end
    return false
end

local function tryProximity(chestName)
    if not fireproximityprompt then return false end
    local hit = 0
    for _,pp in ipairs(workspace:GetDescendants()) do
        if pp:IsA("ProximityPrompt") then
            local parentName = (pp.Parent and pp.Parent.Name or ""):lower()
            local thisName = (pp.Name or ""):lower()
            if thisName:find("chest") or parentName:find("chest") or parentName:find(chestName:lower()) then
                pcall(function() fireproximityprompt(pp, 5) end)
                hit += 1
            end
        end
    end
    if hit > 0 then dbg("cleaner", ("Fired %d proximity prompt(s)"):format(hit)) end
    return hit > 0
end

---------------------------------------------------------------------
-- 🔄 Core Loops
---------------------------------------------------------------------
local function BlowBubbleLoop()
    if not RemoteEvent then task.wait(0.25) return end
    local ok,err = pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    if not ok then dbg("error", "BlowBubble:", err) end
    task.wait(0.1)
end

local function AutoClaimChestLoop()
    local chests = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest","Dice Chest",
        "Infinity Chest","Void Chest","Giant Chest","Ticket Chest",
        "Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }

    local candidates = {}
    if RemoteEvent then table.insert(candidates, RemoteEvent) end
    for _,r in ipairs(findChestRemotes()) do
        if r ~= RemoteEvent then table.insert(candidates, r) end
    end
    if #candidates == 0 then dbg("warn", "no chest-related remotes found.") end

    for _, chest in ipairs(chests) do
        local claimed = false
        for _,remote in ipairs(candidates) do
            if tryClaimVia(remote, chest) then
                claimed = true
                break
            end
            task.wait(0.05)
        end
        if not claimed then
            claimed = tryProximity(chest)
        end
        if not claimed then
            dbg("warn", "ClaimChest failed:", chest)
        end
        task.wait(0.15)
    end

    task.wait(3)
end

local function AutoHatchEggLoop()
    if not RemoteEvent then task.wait(0.25) return end
    local ok,err = pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    if not ok then dbg("error", "HatchEgg:", err) end
    task.wait(0.1)
end

local function stopLoop(name)
    flags[name] = false
    if tasks[name] then pcall(function() task.cancel(tasks[name]) end) end
    tasks[name] = nil
    dbg("info", "Stopped loop:", name)
end

local function startLoop(name, fn, delay)
    if tasks[name] then return end
    dbg("info", "Started loop:", name)
    tasks[name] = task.spawn(function()
        while flags[name] do
            local ok, err = pcall(fn)
            if not ok then dbg("error", "[Loop "..name.."] "..tostring(err)) end
            task.wait(delay or 0.1)
        end
        tasks[name] = nil
    end)
end

---------------------------------------------------------------------
-- 🪟 Rayfield Window
---------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name="🌌 BGSI HUB",
    LoadingTitle="Loading NiTroHub...",
    LoadingSubtitle="By NiTroHub",
    ConfigurationSaving={Enabled=true,FolderName="NiTroHub",FileName="BGSI-Deluxe",Autosave=true,Autoload=true}
})
Rayfield:Notify({Title="✅ BGSI HUB Ready", Content="Systems Loaded", Duration=3})

---------------------------------------------------------------------
-- ⚙️ Controls Tab
---------------------------------------------------------------------
local Controls = Window:CreateTab("⚙️ Controls")

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
    Name="Auto Hatch (Custom Egg)", CurrentValue=false,
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
    Name="Disable Hatch Animation (Auto-Rehook)", CurrentValue=flags.DisableAnimation,
    Callback=function(v)
        flags.DisableAnimation = v
        if v then DisableHatchAnimation()
        else Rayfield:Notify({Title="⚙️ Rejoin Required", Content="Rejoin to restore animations.", Duration=3}) end
    end
})

Controls:CreateInput({
    Name="Egg Name", PlaceholderText="Infinity Egg", RemoveTextAfterFocusLost=true,
    Callback=function(t) settings.EggName = t dbg("info", "Set EggName:", t) end
})

Controls:CreateInput({
    Name="Hatch Amount (1/3/6/8/9/10/11/12)", PlaceholderText="6", RemoveTextAfterFocusLost=true,
    Callback=function(t)
        local n = tonumber(t)
        if n and table.find({1,3,6,8,9,10,11,12}, n) then
            settings.HatchAmount = n
            dbg("info", "Set HatchAmount:", n)
        else
            warn("⚠️ Invalid Hatch Amount")
            dbg("warn", "Invalid HatchAmount:", t)
        end
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
        dbg("safety", "Anti-AFK:", v and "ON" or "OFF")
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
        dbg("safety", "AutoReconnect: enabled")
    end
})

Safety:CreateButton({
    Name="🕵️ Anti-Admin Detector",
    Callback=function()
        local words={"admin","mod","dev","staff"}
        Players.PlayerAdded:Connect(function(p)
            for _,w in ipairs(words) do
                if p.Name:lower():find(w) then
                    for k in pairs(flags) do stopLoop(k) end
                    Rayfield:Destroy()
                    LocalPlayer:Kick("⚠️ Admin Detected. Script Stopped.")
                    dbg("safety", "Kicked due to admin-like name:", p.Name)
                end
            end
        end)
        dbg("safety", "Anti-Admin: enabled")
    end
})

---------------------------------------------------------------------
-- ⚙️ Settings Tab (Save / Load / Destroy)
---------------------------------------------------------------------
local SettingsTab = Window:CreateTab("⚙️ Settings")
SettingsTab:CreateButton({
    Name="🧨 Destroy UI",
    Callback=function()
        for k in pairs(flags) do stopLoop(k) end
        Rayfield:Destroy()
        dbg("info", "UI destroyed by user.")
    end
})

---------------------------------------------------------------------
-- 📊 Debug Log Tab (UI)
---------------------------------------------------------------------
local DebugTab = Window:CreateTab("📊 Debug Log")

-- === UI Elements ===
local DebugFrame = Instance.new("ScrollingFrame")
DebugFrame.Size = UDim2.new(1, -20, 0, 320)
DebugFrame.Position = UDim2.new(0, 10, 0, 10)
DebugFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DebugFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
DebugFrame.BackgroundTransparency = 0.2
DebugFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DebugFrame.BorderSizePixel = 0
DebugFrame.ScrollBarThickness = 6
DebugFrame.Parent = (DebugTab.SectionParent or DebugTab)

local DebugText = Instance.new("TextLabel")
DebugText.Size = UDim2.new(1, -10, 0, 0)
DebugText.Position = UDim2.new(0, 5, 0, 5)
DebugText.BackgroundTransparency = 1
DebugText.TextColor3 = Color3.fromRGB(230, 230, 230)
DebugText.TextXAlignment = Enum.TextXAlignment.Left
DebugText.TextYAlignment = Enum.TextYAlignment.Top
DebugText.Font = Enum.Font.Code
DebugText.TextSize = 18
DebugText.RichText = true
DebugText.TextWrapped = true
DebugText.Text = "<b><font color='#AAAAAA'>Logs will appear here...</font></b>"
DebugText.Parent = DebugFrame

DebugText:GetPropertyChangedSignal("TextBounds"):Connect(function()
    DebugFrame.CanvasSize = UDim2.new(0, 0, 0, DebugText.TextBounds.Y + 20)
end)

-- === Colored Logging ===
local colors = {
    ["loop"] = "#5AC8FA", ["patch"] = "#4CD964", ["cleaner"] = "#FFD60A",
    ["safety"] = "#A2845E", ["error"] = "#FF3B30", ["warn"] = "#FF9500",
    ["info"] = "#FFFFFF",
}

local function getColorForLog(msg)
    msg = (msg or ""):lower()
    for key, hex in pairs(colors) do
        if msg:find(key) then return hex end
    end
    return "#FFFFFF"
end

DebugLabel = { Set = function(_, txt) DebugText.Text = txt or "" end }

local function renderColoredLogs()
    local start = math.max(1, #DebugLog - 100 + 1)
    local buffer = {}
    for i = start, #DebugLog do
        local msg = DebugLog[i]
        buffer[#buffer + 1] = string.format("<font color='%s'>%s</font>", getColorForLog(msg), msg)
    end
    DebugText.Text = table.concat(buffer, "\n")
end

-- wrap dbg เพื่อระบายสี
do
    local _dbg = dbg
    dbg = function(...)
        local n = select("#", ...)
        local parts = table.create(n)
        for i = 1, n do parts[i] = tostring(select(i, ...)) end
        local msg = table.concat(parts, " ")
        table.insert(DebugLog, ("[%s] %s"):format(os.date("%H:%M:%S"), msg))
        if #DebugLog > DEBUG_MAX then table.remove(DebugLog, 1) end
        renderColoredLogs()
        print("[BGSI]", msg)
    end
end

DebugTab:CreateButton({
    Name = "🧹 Clear Log",
    Callback = function()
        DebugLog = {}
        DebugLabel:Set("<b><font color='#888888'>[Logs Cleared]</font></b>")
        dbg("cleaner", "Debug log cleared.")
    end
})

DebugTab:CreateButton({
    Name = "📥 Export Log to File",
    Callback = function()
        if not writefile then
            Rayfield:Notify({Title="⚠️ Export", Content="Executor ไม่รองรับ writefile", Duration=3})
            return
        end
        local exportName = ("BGSI_Debug_%s.txt"):format(os.date("%Y%m%d_%H%M%S"))
        local start = math.max(1, #DebugLog - 200 + 1)
        local buf = {}
        for i = start, #DebugLog do buf[#buf+1] = DebugLog[i] end
        writefile(exportName, table.concat(buf, "\n"))
        Rayfield:Notify({Title="📥 Exported", Content=exportName, Duration=3})
        dbg("info", "Exported debug log:", exportName)
    end
})

dbg("info", "Debug UI (Colored Log) initialized.")
