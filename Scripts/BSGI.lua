-- 🌌 BGSI HUB - Deluxe Edition (Delta Auto-Rehook v6 Safe)
-- ✅ Stable Rayfield + Auto Hatch + Safe Hatch Disable (Delta Optimized)
-- 🧠 By NiTroHub x ChatGPT Integration

-- // Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- === Safe Wait ===
local function safeWait(parent, childName, timeout)
    local ok, obj = pcall(function() return parent:WaitForChild(childName, timeout or 10) end)
    if not ok or not obj then warn("Missing:", childName) end
    return obj
end

-- === REMOTES ===
local RemoteEvent = safeWait(ReplicatedStorage, "Shared")
if RemoteEvent then
    RemoteEvent = safeWait(RemoteEvent, "Framework")
    RemoteEvent = RemoteEvent and safeWait(RemoteEvent, "Network")
    RemoteEvent = RemoteEvent and safeWait(RemoteEvent, "Remote")
    RemoteEvent = RemoteEvent and safeWait(RemoteEvent, "RemoteEvent")
end

if not RemoteEvent then
    warn("❌ Missing RemoteEvent; some features may not work.")
end

-- === FLAGS & SETTINGS ===
local flags = {
    BlowBubble = false,
    AutoClaimChest = false,
    AutoHatchEgg = false,
    DisableAnimation = true
}

local settings = {
    EggName = "Infinity Egg",
    HatchAmount = 6
}

local tasks, conns = {}, {}
local hatchPatched = false

--------------------------------------------------------------------
-- === 🧩 Disable Hatch Animation (Safe Delta Auto-Rehook)
--------------------------------------------------------------------

local function makeStub()
    local function noop(...) return nil end
    return setmetatable({
        Play = noop, Hatch = noop, Open = noop, Init = noop,
        Animate = noop, Create = noop, Show = noop, Hide = noop
    }, { __call = noop, __index = function() return noop end })
end

local function patchModuleNoop(modTable)
    if type(modTable) ~= "table" then return end
    for k, v in pairs(modTable) do
        if type(v) == "function" then
            modTable[k] = function(...) return nil end
        end
    end
end

local function tryPatchLoadedModules(targetModule)
    if typeof(getloadedmodules) ~= "function" then return false end
    for _, m in ipairs(getloadedmodules()) do
        if m == targetModule or (m.Name == "HatchEgg" and m.Parent and m.Parent.Name == "Effects") then
            local ok, lib = pcall(require, m)
            if ok and type(lib) == "table" then
                patchModuleNoop(lib)
                return true
            end
        end
    end
    return false
end

-- 🧩 Safe Hatch GUI Cleaner (v3 - Strict Filter)
local function cleanHatchGUI()
    local player = Players.LocalPlayer
    if not player then return end

    local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")

    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("ScreenGui") or d:IsA("Frame") or d:IsA("Folder") then
            local name = (d.Name or ""):lower()

            -- ✅ เงื่อนไขใหม่: จะลบเฉพาะ Hatch Animation เท่านั้น
            local isHatchUI =
                name == "hatchegg" or
                name == "hatching" or
                name == "eggopen" or
                name == "hatchanimation" or
                name:match("^hatch") or
                name:match("hatch_ui")

            if isHatchUI then
                pcall(function()
                    d:Destroy()
                    print("[Cleaner] Removed Hatch GUI:", d.Name)
                end)
            end
        end
    end
end

local function patchHatchEgg()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local effects = client and client:FindFirstChild("Effects")
    local target = effects and effects:FindFirstChild("HatchEgg")
    if not target then return end

    local stub = makeStub()
    pcall(function() tryPatchLoadedModules(target) end)

    local env = (rawget and pcall(function() return getrenv() end) and getrenv()) or _G
    local req = (rawget(env or {}, "require") or require)
    if typeof(req) == "function" and hookfunction then
        local old; old = hookfunction(req, function(mod, ...)
            if typeof(mod) == "Instance" and mod:IsA("ModuleScript") then
                if mod == target or (mod.Name == "HatchEgg" and mod.Parent and mod.Parent.Name == "Effects") then
                    return stub
                end
            end
            return old(mod, ...)
        end)
    end

    if effects and effects:IsA("Instance") then
        if conns.HatchAuto then pcall(function() conns.HatchAuto:Disconnect() end) end
        conns.HatchAuto = effects.ChildAdded:Connect(function(child)
            task.wait(0.5)
            if child and child.Name == "HatchEgg" then
                pcall(function()
                    tryPatchLoadedModules(child)
                    if typeof(require) == "function" and child:IsA("ModuleScript") then
                        local ok, lib = pcall(require, child)
                        if ok and type(lib) == "table" then
                            patchModuleNoop(lib)
                        end
                    end
                    cleanHatchGUI()
                end)
            end
        end)
    end
end

local function DisableHatchAnimation()
    if hatchPatched then return end
    hatchPatched = true

    local exec = (identifyexecutor and identifyexecutor() or "Unknown")
    local isDelta = tostring(exec):lower():find("delta") ~= nil

    pcall(patchHatchEgg)
    pcall(cleanHatchGUI)

    Rayfield:Notify({
        Title = "🎬 Hatch Animation Disabled",
        Content = isDelta and "Delta Auto-Rehook Active ✅" or "Generic Hook Active ⚙️",
        Duration = 3
    })
end

--------------------------------------------------------------------
-- === Core Loops ===
--------------------------------------------------------------------
local function BlowBubbleLoop()
    pcall(function() RemoteEvent:FireServer("BlowBubble") end)
    task.wait(0.1)
end

local function AutoClaimChestLoop()
    local chests = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
        "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
        "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }
    for _, chest in ipairs(chests) do
        pcall(function()
            RemoteEvent:FireServer("ClaimChest", chest, true)
        end)
    end
    task.wait(3)
end

local function AutoHatchEggLoop()
    pcall(function()
        RemoteEvent:FireServer("HatchEgg", settings.EggName, settings.HatchAmount)
    end)
    task.wait(0.1)
end

local function stopLoop(name)
    flags[name] = false
    if tasks[name] then pcall(function() task.cancel(tasks[name]) end) end
    tasks[name] = nil
end

local function startLoop(name, fn, delay)
    if tasks[name] then return end
    tasks[name] = task.spawn(function()
        while flags[name] do
            local ok, err = pcall(fn)
            if not ok then warn("[Loop Error: "..name.."]", err) end
            task.wait(delay or 0.1)
        end
        tasks[name] = nil
    end)
end

--------------------------------------------------------------------
-- === UI ===
--------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "🌌 BGSI HUB",
    LoadingTitle = "Loading NiTroHub...",
    LoadingSubtitle = "By NiTroHub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "BGSI-Deluxe",
        Autosave = true,
        Autoload = true
    }
})

Rayfield:Notify({
    Title = "✅ BGSI HUB Ready",
    Content = "By NiTroHub | Systems Loaded",
    Duration = 4
})

local Controls = Window:CreateTab("⚙️ Controls")

Controls:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = false,
    Callback = function(v)
        flags.BlowBubble = v
        if v then startLoop("BlowBubble", BlowBubbleLoop, 0.5)
        else stopLoop("BlowBubble") end
    end
})

Controls:CreateToggle({
    Name = "Auto Claim All Chests",
    CurrentValue = false,
    Callback = function(v)
        flags.AutoClaimChest = v
        if v then startLoop("AutoClaimChest", AutoClaimChestLoop, 3)
        else stopLoop("AutoClaimChest") end
    end
})

Controls:CreateToggle({
    Name = "Auto Hatch (Custom Egg)",
    CurrentValue = false,
    Callback = function(v)
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
    Name = "Disable Hatch Animation (Auto-Rehook)",
    CurrentValue = flags.DisableAnimation,
    Callback = function(v)
        flags.DisableAnimation = v
        if v then
            DisableHatchAnimation()
        else
            Rayfield:Notify({
                Title = "⚙️ Rejoin Required",
                Content = "Rejoin to restore animations.",
                Duration = 3
            })
        end
    end
})

-- === Inputs ===
local EggInput = Controls:CreateInput({
    Name = "Egg Name",
    PlaceholderText = "Infinity Egg",
    RemoveTextAfterFocusLost = false,
    Callback = function(t)
        settings.EggName = t
    end
})

task.spawn(function()
    local textBox = EggInput.InputBox or EggInput.Input or EggInput
    if not textBox then return end
    local minWidth, maxWidth = 200, 600
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local len = string.len(textBox.Text)
        local newW = math.clamp(minWidth + (len * 10), minWidth, maxWidth)
        TweenService:Create(textBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, newW, 0, 30)
        }):Play()
    end)
end)

Controls:CreateInput({
    Name = "Hatch Amount (1/3/6/8/9/10/11/12)",
    PlaceholderText = "6",
    RemoveTextAfterFocusLost = false,
    Callback = function(t)
        local n = tonumber(t)
        if n and (n==1 or n==3 or n==6 or n==8 or n==9 or n==10 or n==11 or n==12) then
            settings.HatchAmount = n
        else
            warn("⚠️ Invalid hatch amount.")
        end
    end
})

--------------------------------------------------------------------
-- === Safety Tab ===
--------------------------------------------------------------------
local Safety = Window:CreateTab("🛡️ Safety")

Safety:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(v)
        if conns.AFK then conns.AFK:Disconnect(); conns.AFK=nil end
        if v then
            conns.AFK = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

Safety:CreateButton({
    Name = "♻️ Auto Reconnect",
    Callback = function()
        LocalPlayer.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Failed then
                task.wait(3)
                TeleportService:Teleport(game.PlaceId)
            end
        end)
        Rayfield:Notify({Title="🌐 Auto Reconnect",Content="Enabled",Duration=3})
    end
})

Safety:CreateButton({
    Name = "🕵️ Anti-Admin Detector",
    Callback = function()
        local keywords = {"admin","mod","dev","staff"}
        Players.PlayerAdded:Connect(function(p)
            for _, word in ipairs(keywords) do
                if string.find(p.Name:lower(), word) then
                    for k in pairs(flags) do stopLoop(k) end
                    pcall(function() Rayfield:Destroy() end)
                    LocalPlayer:Kick("⚠️ Admin detected. Script terminated.")
                end
            end
        end)
    end
})

local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for k in pairs(flags) do stopLoop(k) end
        pcall(function() Rayfield:Destroy() end)
    end
})
