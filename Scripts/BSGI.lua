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
    DisableAnimation = true,
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
        if type(v)=="function" then tbl[k] = function(...) return nil end end
    end
end

local function tryPatchLoadedModules(target)
    if typeof(getloadedmodules) ~= "function" then return false end
    for _,m in ipairs(getloadedmodules()) do
        if m==target or (m.Name=="HatchEgg" and m.Parent and m.Parent.Name=="Effects") then
            local ok,lib = pcall(require, m)
            if ok and type(lib)=="table" then
                patchModuleNoop(lib)
                dbg("Patched loaded HatchEgg table.")
                return true
            end
        end
    end
    return false
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
                local ok = pcall(function()
                    d.Visible = false
                    d.Enabled = false
                end)
                if ok then hidden += 1 else pcall(function() d:Destroy() end) removed += 1 end
            end
        end
    end
    dbg(("Cleaner: Hidden %d | Removed %d Hatch GUI nodes."):format(hidden, removed))
end

local function patchHatchEgg()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local effects = client and client:FindFirstChild("Effects")
    if not effects then dbg("Effects folder not found."); return end

    local target = effects:FindFirstChild("HatchEgg")
    if not target then dbg("HatchEgg module not found yet."); return end

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
                    dbg("Stubbed require(HatchEgg).")
                    return stub
                end
            end
            return old(mod, ...)
        end)
        dbg("Hooked require() for HatchEgg.")
    end

    if conns.HatchAuto then pcall(function() conns.HatchAuto:Disconnect() end) end
    conns.HatchAuto = effects.ChildAdded:Connect(function(child)
        if child.Name == "HatchEgg" then
            task.wait(0.5)
            pcall(function()
                tryPatchLoadedModules(child)
                cleanHatchGUI()
                dbg("Auto-rehook on HatchEgg ChildAdded.")
            end)
        end
    end)
    dbg("patchHatchEgg completed.")
end

local function DisableHatchAnimation()
    if hatchPatched then dbg("DisableHatchAnimation: already applied."); return end
    hatchPatched = true
    pcall(patchHatchEgg)
    pcall(cleanHatchGUI)
    Rayfield:Notify({Title="🎬 Hatch Animation Disabled", Content="Delta Auto-Rehook Active ✅", Duration=3})
    dbg("Hatch animation disabled.")
end

task.defer(function()
    task.wait(1)
    if flags.DisableAnimation then
        pcall(DisableHatchAnimation)
    end
end)

---------------------------------------------------------------------
-- 🔄 Core Loops
---------------------------------------------------------------------
local function BlowBubbleLoop()
    local ok,err = pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    if not ok then dbg("BlowBubble error:", err) end
    task.wait(0.1)
end

local function AutoClaimChestLoop()
    local chests = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest","Dice Chest",
        "Infinity Chest","Void Chest","Giant Chest","Ticket Chest",
        "Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }
    for _,c in ipairs(chests) do
        local ok,err = pcall(function() RemoteEvent:FireServer("ClaimChest", c, true) end)
        if not ok then dbg("ClaimChest error:", c, err) end
    end
    task.wait(3)
end

local function AutoHatchEggLoop()
    local ok,err = pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    if not ok then dbg("HatchEgg error:", err) end
    task.wait(0.1)
end

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
    Name="🌌 BGSI HUB",
    LoadingTitle="Loading NiTroHub...",
    LoadingSubtitle="By NiTroHub",
    ConfigurationSaving={Enabled=true,FolderName="NiTroHub",FileName="BGSI-Deluxe",Autosave=true,Autoload=true}
})
Rayfield:Notify({Title="✅ BGSI HUB Ready", Content="By NiTroHub | Systems Loaded", Duration=3})

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
    Callback=function(t) settings.EggName = t dbg("Set EggName:", t) end
})

Controls:CreateInput({
    Name="Hatch Amount (1/3/6/8/9/10/11/12)", PlaceholderText="6", RemoveTextAfterFocusLost=true,
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
                    dbg("Kicked due to admin-like name:", p.Name)
                end
            end
        end)
        dbg("Anti-Admin: enabled")
    end
})

---------------------------------------------------------------------
-- ⚙️ Settings Tab
---------------------------------------------------------------------
local SettingsTab = Window:CreateTab("⚙️ Settings")
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