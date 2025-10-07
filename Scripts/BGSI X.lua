--===============================================================
-- 🌀 NiTROHUB PRO - Final (Fixed GUI Version)
--✨ by NiTROHUB x ChatGPT (No Libraries, Full GUI)
--===============================================================

-- ✅ CONFIG ------------------------------------------------------
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 3,
    HatchDelay = 1.2,
    AutoRebirth = true,
    RebirthDelay = 2,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
        "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
        "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }
}

local State = {
    HatchRunning = false,
    RebirthRunning = false,
    ChestRunning = false,
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-",
    Status = "Idle"
}

-- ✅ SERVICES ----------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ✅ REMOTES -----------------------------------------------------
local frameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

-- ✅ GUI BASE ----------------------------------------------------
local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "NiTROHUB_PRO_UI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local theme = {
    bg = Color3.fromRGB(20,22,26),
    panel = Color3.fromRGB(28,30,36),
    stroke = Color3.fromRGB(60,65,75),
    text = Color3.fromRGB(235,238,245),
    sub = Color3.fromRGB(160,170,190),
    primary = Color3.fromRGB(88,101,242),
}

local function round(o,r) Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 10) end
local function stroke(o,c,t) local s=Instance.new("UIStroke",o) s.Color=c or theme.stroke s.Thickness=t or 1 return s end

-- Main window
local window = Instance.new("Frame", sg)
window.Size = UDim2.new(0, 520, 0, 360)
window.Position = UDim2.new(0.5, -260, 0.5, -180)
window.BackgroundColor3 = theme.bg
window.Active = true
window.Draggable = true
round(window, 14)
stroke(window)

-- Header
local header = Instance.new("Frame", window)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundColor3 = theme.panel
round(header, 14)
stroke(header)

local title = Instance.new("TextLabel", header)
title.Text = "🌀 NiTROHUB PRO — Final"
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,16,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = theme.text
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local sub = Instance.new("TextLabel", header)
sub.Text = "Auto Hatch • Auto Rebirth • Auto Chest"
sub.Size = UDim2.new(1,-100,1,0)
sub.Position = UDim2.new(0,16,0,20)
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.TextColor3 = theme.sub
sub.BackgroundTransparency = 1
sub.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0,80,0,28)
close.Position = UDim2.new(1,-90,0.5,-14)
close.Text = "Close"
close.Font = Enum.Font.GothamSemibold
close.TextColor3 = theme.text
close.TextSize = 14
close.BackgroundColor3 = theme.panel
round(close,8)
stroke(close)
close.MouseButton1Click:Connect(function() sg.Enabled = false end)

-- Tabs
local tabbar = Instance.new("Frame", window)
tabbar.Size = UDim2.new(0,150,1,-60)
tabbar.Position = UDim2.new(0,10,0,54)
tabbar.BackgroundTransparency = 1

local pages = Instance.new("Frame", window)
pages.Size = UDim2.new(1,-170,1,-60)
pages.Position = UDim2.new(0,160,0,54)
pages.BackgroundTransparency = 1

local function makePage(name)
    local sc = Instance.new("ScrollingFrame", pages)
    sc.Name = name
    sc.Size = UDim2.new(1,0,1,0)
    sc.CanvasSize = UDim2.new(0,0,0,0)
    sc.ScrollBarThickness = 4
    sc.BackgroundTransparency = 1
    sc.Visible = false
    Instance.new("UIListLayout", sc).Padding = UDim.new(0,8)
    return sc
end

local function makeTab(name,page)
    local btn = Instance.new("TextButton", tabbar)
    btn.Size = UDim2.new(1,0,0,36)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = theme.text
    btn.BackgroundColor3 = theme.panel
    round(btn,8)
    stroke(btn)
    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
        page.Visible = true
    end)
end

pages.Hatch = makePage("Hatch")
pages.Rebirth = makePage("Rebirth")
pages.Chest = makePage("Chest")
pages.Status = makePage("Status")

makeTab("🥚 Auto Hatch", pages.Hatch)
makeTab("♻️ Auto Rebirth", pages.Rebirth)
makeTab("📦 Auto Chest", pages.Chest)
makeTab("📊 Status", pages.Status)
pages.Hatch.Visible = true

-- Simple toggle button
local function makeToggle(parent, text, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,36)
    f.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", f)
    lbl.Text = text
    lbl.Size = UDim2.new(1,-50,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = theme.text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0,28,0,28)
    btn.Position = UDim2.new(1,-30,0,4)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = theme.text
    btn.BackgroundColor3 = theme.panel
    round(btn,6)
    stroke(btn)
    local on=false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        btn.BackgroundColor3 = on and theme.primary or theme.panel
        callback(on)
    end)
end

-- ✅ AUTO HATCH -------------------------------------------------
do
    makeToggle(pages.Hatch,"เปิด Auto Hatch",function(state)
        State.HatchRunning=state
        State.Status=state and "Hatching Eggs..." or "Idle"
    end)
end

-- ✅ AUTO REBIRTH ----------------------------------------------
do
    makeToggle(pages.Rebirth,"เปิด Auto Rebirth",function(state)
        State.RebirthRunning=state
        State.Status=state and "Auto Rebirth..." or "Idle"
    end)
end

-- ✅ AUTO CHEST -------------------------------------------------
do
    makeToggle(pages.Chest,"เปิด Auto Chest",function(state)
        State.ChestRunning=state
        State.Status=state and "Collecting Chests..." or "Idle"
    end)
end

-- ✅ STATUS TAB -------------------------------------------------
do
    local info = Instance.new("Frame", pages.Status)
    info.Size = UDim2.new(1,0,0,150)
    info.BackgroundColor3 = theme.panel
    round(info,8)
    stroke(info)
    local layout = Instance.new("UIListLayout", info)
    layout.Padding = UDim.new(0,6)
    local function add(txt,get)
        local lbl = Instance.new("TextLabel", info)
        lbl.Text = txt..": ..."
        lbl.Size = UDim2.new(1,0,0,26)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = theme.text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        game:GetService("RunService").RenderStepped:Connect(function()
            lbl.Text = txt..": "..tostring(get())
        end)
    end
    add("🚀 Status", function() return State.Status end)
    add("🥚 Eggs Hatched", function() return State.EggsHatched end)
    add("📦 Chests Collected", function() return State.ChestsCollected end)
    add("🎁 Last Chest", function() return State.LastChest end)
end

-- ✅ BACKGROUND TASKS -------------------------------------------
task.spawn(function()
    while true do
        if State.HatchRunning then
            pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched += Config.HatchAmount
            end)
            task.wait(Config.HatchDelay)
        else task.wait(0.3) end
    end
end)

task.spawn(function()
    while true do
        if State.RebirthRunning then
            pcall(function() frameworkRemote:FireServer("Rebirth", 1) end)
            task.wait(Config.RebirthDelay)
        else task.wait(0.3) end
    end
end)

task.spawn(function()
    local collected = {}
    while true do
        if State.ChestRunning then
            for _,area in ipairs({Workspace:FindFirstChild("Chests"),Workspace}) do
                if area then
                    for _,obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and Config.ChestNames then
                            local name=obj.Name:lower()
                            for _,n in ipairs(Config.ChestNames) do
                                if name==n:lower() then
                                    local key=obj:GetDebugId()
                                    if not collected[key] or tick()-collected[key]>Config.ChestCollectCooldown then
                                        pcall(function()
                                            frameworkRemote:FireServer("ClaimChest",obj.Name,true)
                                        end)
                                        collected[key]=tick()
                                        State.ChestsCollected+=1
                                        State.LastChest=obj.Name
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(Config.ChestCheckInterval)
    end
end)

print("[✅] NiTROHUB PRO (Final GUI Edition) Loaded Successfully!")
