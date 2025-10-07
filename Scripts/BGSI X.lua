--===============================================================
-- 🌀 NiTROHUB PRO — Final (Custom GUI, No Library)
--  • Dark theme • Left tabbar • Icons
--  • Features: Auto Hatch, Auto Chest, Status (NO Auto Rebirth)
--===============================================================

--== CONFIG =====================================================
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 3,                 -- 1 / 3 / 9
    HatchDelay = 1.2,                -- seconds
    ChestCheckInterval = 10,         -- seconds
    ChestCollectCooldown = 60,       -- seconds
    ChestNames = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
        "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
        "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }
}

local State = {
    HatchRunning=false,
    ChestRunning=false,
    EggsHatched=0,
    ChestsCollected=0,
    LastChest="-",
    Status="Idle"
}

--== SERVICES / REMOTES ========================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local frameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

--== CHEST LOOKUP ==============================================
local CHEST_LIST = {}
for _,n in ipairs(Config.ChestNames) do CHEST_LIST[n:lower()] = true end

--== THEME & ICONS (Dark) ======================================
local theme = {
    bg = Color3.fromRGB(20,22,26),
    panel = Color3.fromRGB(28,30,36),
    stroke = Color3.fromRGB(60,65,75),
    text = Color3.fromRGB(235,238,245),
    sub = Color3.fromRGB(160,170,190),
    primary = Color3.fromRGB(88,101,242)
}
local ICONS = {
    app="rbxassetid://7734053425", egg="rbxassetid://7733697785",
    chest="rbxassetid://7733775631", status="rbxassetid://7733911825",
    dropdown="rbxassetid://6031090993"
}

local function round(o,r) Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 10) end
local function stroke(o,c,t) local s=Instance.new("UIStroke",o) s.Color=c or theme.stroke s.Thickness=t or 1 return s end
local function pad(p,t,l,r,b) local u=Instance.new("UIPadding",p); u.PaddingTop=UDim.new(0,t or 0); u.PaddingLeft=UDim.new(0,l or 0); u.PaddingRight=UDim.new(0,r or 0); u.PaddingBottom=UDim.new(0,b or 0) end

--== SCREEN GUI =================================================
local sg = Instance.new("ScreenGui")
sg.Name = "NiTROHUB_PRO_UI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main window (draggable)
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 560, 0, 380)
window.Position = UDim2.new(0.5,-280,0.5,-190)
window.BackgroundColor3 = theme.bg
window.Active = true
window.Draggable = true
window.Parent = sg
round(window,16); stroke(window)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,52)
header.BackgroundColor3 = theme.panel
header.Parent = window
round(header,16); stroke(header)

local logo = Instance.new("ImageLabel")
logo.BackgroundTransparency = 1
logo.Image = ICONS.app
logo.Size = UDim2.new(0,26,0,26)
logo.Position = UDim2.new(0,14,0,13)
logo.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Text = "NiTROHUB PRO — Final"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = theme.text
title.Position = UDim2.new(0,48,0,4)
title.Size = UDim2.new(1,-160,0,24)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Text = "Auto Hatch • Auto Chest • Status"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = theme.sub
subtitle.Position = UDim2.new(0,48,0,26)
subtitle.Size = UDim2.new(1,-160,0,22)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.AutoButtonColor = false
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.TextColor3 = theme.text
closeBtn.Size = UDim2.new(0,88,0,32)
closeBtn.Position = UDim2.new(1,-100,0.5,-16)
closeBtn.BackgroundColor3 = theme.panel
closeBtn.Parent = header
round(closeBtn,10); stroke(closeBtn)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

-- Left Tabbar
local tabbar = Instance.new("Frame")
tabbar.Size = UDim2.new(0,160,1,-64)
tabbar.Position = UDim2.new(0,12,0,56)
tabbar.BackgroundTransparency = 1
tabbar.Parent = window

-- Pages container
local pages = Instance.new("Frame")
pages.Size = UDim2.new(1,-184,1,-64)
pages.Position = UDim2.new(0,172,0,56)
pages.BackgroundTransparency = 1
pages.Parent = window

local function makePage(name)
    local sc = Instance.new("ScrollingFrame")
    sc.Name = name
    sc.Parent = pages
    sc.Size = UDim2.new(1,0,1,0)
    sc.ScrollBarThickness = 4
    sc.BackgroundTransparency = 1
    sc.Visible = false
    pad(sc,10,10,10,10)
    local l = Instance.new("UIListLayout", sc)
    l.Padding = UDim.new(0,8); l.SortOrder = Enum.SortOrder.LayoutOrder
    return sc
end

-- Make tab button
local function makeTab(txt, iconId, page)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Parent = tabbar
    b.Size = UDim2.new(1,0,0,40)
    b.Text = ""
    b.BackgroundColor3 = theme.panel
    round(b,10); stroke(b); pad(b,0,10,10,0)

    local ic = Instance.new("ImageLabel", b)
    ic.BackgroundTransparency = 1
    ic.Image = iconId
    ic.Size = UDim2.new(0,22,0,22)
    ic.Position = UDim2.new(0,10,0.5,-11)

    local t = Instance.new("TextLabel", b)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.Font = Enum.Font.GothamSemibold
    t.TextSize = 14
    t.TextColor3 = theme.text
    t.Size = UDim2.new(1,-40,1,0)
    t.Position = UDim2.new(0,40,0,0)
    t.TextXAlignment = Enum.TextXAlignment.Left

    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3=theme.primary}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3=theme.panel}):Play() end)
    b.MouseButton1Click:Connect(function()
        for _,v in ipairs(pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
        page.Visible = true
    end)
    return b
end

-- Pages
pages.Hatch  = makePage("Hatch")
pages.Chest  = makePage("Chest")
pages.Status = makePage("Status")
pages.Hatch.Visible = true

-- Tabs (with icons)
makeTab("🥚  Auto Hatch",  ICONS.egg,    pages.Hatch)
makeTab("📦  Auto Chest",  ICONS.chest,  pages.Chest)
makeTab("📊  Status",      ICONS.status, pages.Status)

--== SMALL WIDGETS ==============================================
local function makeToggle(parent, label, cb)
    local f = Instance.new("Frame")
    f.Parent = parent
    f.Size = UDim2.new(1,0,0,38)
    f.BackgroundTransparency = 1

    local t = Instance.new("TextLabel", f)
    t.BackgroundTransparency = 1
    t.Text = label
    t.Font = Enum.Font.Gotham
    t.TextSize = 14
    t.TextColor3 = theme.text
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Size = UDim2.new(1,-60,1,0)

    local b = Instance.new("TextButton", f)
    b.AutoButtonColor = false
    b.Size = UDim2.new(0,30,0,26)
    b.Position = UDim2.new(1,-34,0.5,-13)
    b.Text = "OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = theme.text
    b.BackgroundColor3 = theme.panel
    round(b,8); stroke(b)

    local on=false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = on and "ON" or "OFF"
        b.BackgroundColor3 = on and theme.primary or theme.panel
        if cb then task.spawn(cb,on) end
    end)
    return {Set=function(v) on=v; b.Text=v and "ON" or "OFF"; b.BackgroundColor3=v and theme.primary or theme.panel end}
end

local function makeDropdown(parent, label, options, default, cb)
    local holder = Instance.new("Frame")
    holder.Parent = parent
    holder.Size = UDim2.new(1,0,0,74)
    holder.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", holder)
    title.BackgroundTransparency = 1
    title.Text = label
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextColor3 = theme.text
    title.Size = UDim2.new(1,0,0,22)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextButton", holder)
    box.AutoButtonColor = false
    box.Size = UDim2.new(1,0,0,36)
    box.Position = UDim2.new(0,0,0,28)
    box.BackgroundColor3 = theme.panel
    box.Text = ""
    round(box,10); stroke(box)

    local val = Instance.new("TextLabel", box)
    val.BackgroundTransparency = 1
    val.Text = default or (options[1] or "-")
    val.Font = Enum.Font.GothamSemibold
    val.TextSize = 14
    val.TextColor3 = theme.sub
    val.TextXAlignment = Enum.TextXAlignment.Left
    val.Size = UDim2.new(1,-30,1,0)
    val.Position = UDim2.new(0,12,0,0)

    local caret = Instance.new("ImageLabel", box)
    caret.BackgroundTransparency = 1
    caret.Image = ICONS.dropdown
    caret.Size = UDim2.new(0,18,0,18)
    caret.Position = UDim2.new(1,-24,0.5,-9)

    local list = Instance.new("Frame", holder)
    list.Visible = false
    list.BackgroundColor3 = theme.panel
    list.Size = UDim2.new(1,0,0, math.min(#options,6)*28 + 8)
    list.Position = UDim2.new(0,0,0,68)
    round(list,10); stroke(list); pad(list,4,4,4,4)
    local ul = Instance.new("UIListLayout", list); ul.Padding = UDim.new(0,4)

    local function setValue(v)
        val.Text = v
        if cb then task.spawn(cb, v) end
    end
    setValue(default or options[1])

    for _,op in ipairs(options) do
        local btn = Instance.new("TextButton", list)
        btn.AutoButtonColor=false
        btn.Text = op
        btn.Size = UDim2.new(1,0,0,24)
        btn.BackgroundColor3 = theme.panel
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextColor3 = theme.text
        round(btn,6); stroke(btn)
        btn.MouseButton1Click:Connect(function()
            setValue(op)
            list.Visible=false
        end)
    end
    box.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)
    return {Set=setValue, Get=function() return val.Text end}
end

--== HATCH PAGE =================================================
do
    -- list eggs from workspace
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    local eggNames = {}
    if eggsFolder then
        for _,e in ipairs(eggsFolder:GetChildren()) do
            if e:IsA("Model") or e:IsA("Folder") then table.insert(eggNames, e.Name) end
        end
    end
    if #eggNames == 0 then eggNames = {Config.EggName} end
    table.sort(eggNames, function(a,b) return a<b end)

    makeDropdown(pages.Hatch, "เลือกไข่ที่จะเปิด", eggNames, Config.EggName, function(v)
        Config.EggName = v
    end)
    makeDropdown(pages.Hatch, "จำนวนเปิด (1/3/9)", {"1","3","9"}, tostring(Config.HatchAmount), function(v)
        Config.HatchAmount = tonumber(v) or 1
    end)
    makeDropdown(pages.Hatch, "ดีเลย์ต่อรอบ (วินาที)", {"0.5","0.8","1.0","1.2","1.5","2.0"}, tostring(Config.HatchDelay), function(v)
        Config.HatchDelay = tonumber(v) or 1.2
    end)

    makeToggle(pages.Hatch, "เปิด Auto Hatch", function(on)
        State.HatchRunning = on
        State.Status = on and "Hatching Eggs..." or "Idle"
    end)
end

--== CHEST PAGE =================================================
do
    makeToggle(pages.Chest, "เปิด Auto Chest", function(on)
        State.ChestRunning = on
        State.Status = on and "Collecting Chests..." or "Idle"
    end)
    makeDropdown(pages.Chest, "รอบตรวจ (วินาที)", {"5","10","15","30"}, tostring(Config.ChestCheckInterval), function(v)
        Config.ChestCheckInterval = tonumber(v) or 10
    end)
    makeDropdown(pages.Chest, "คูลดาวน์ต่อกล่อง (วินาที)", {"30","45","60","90"}, tostring(Config.ChestCollectCooldown), function(v)
        Config.ChestCollectCooldown = tonumber(v) or 60
    end)
end

--== STATUS PAGE ================================================
local statusNodes = {}
do
    local card = Instance.new("Frame", pages.Status)
    card.Size = UDim2.new(1,0,0,170)
    card.BackgroundColor3 = theme.panel
    round(card,12); stroke(card); pad(card,10,10,10,10)
    local lay = Instance.new("UIListLayout", card); lay.Padding = UDim.new(0,6)

    local function row(label, getter)
        local f = Instance.new("Frame", card)
        f.Size = UDim2.new(1,0,0,26); f.BackgroundTransparency = 1
        local L = Instance.new("TextLabel", f)
        L.BackgroundTransparency = 1; L.Text = label
        L.Font = Enum.Font.GothamSemibold; L.TextSize = 14
        L.TextColor3 = theme.text; L.TextXAlignment = Enum.TextXAlignment.Left
        L.Size = UDim2.new(0.5,-6,1,0)
        local R = Instance.new("TextLabel", f)
        R.BackgroundTransparency = 1; R.Text = "-"
        R.Font = Enum.Font.Gotham; R.TextSize = 14
        R.TextColor3 = theme.sub; R.TextXAlignment = Enum.TextXAlignment.Right
        R.Size = UDim2.new(0.5,-6,1,0); R.Position = UDim2.new(0.5,6,0,0)
        table.insert(statusNodes, {node=R, getter=getter})
    end

    row("🚀 สถานะ", function() return State.Status end)
    row("🥚 Eggs Hatched", function() return State.EggsHatched end)
    row("📦 Chests Collected", function() return State.ChestsCollected end)
    row("🎁 Last Chest", function() return State.LastChest end)
end

--== WAIT GUI BUILT, THEN START WORKERS =========================
task.spawn(function()
    -- รอจนหน้า Hatch/Chest/Status ถูกสร้างจริง (กัน error)
    repeat task.wait(0.2) until pages and pages:FindFirstChild("Hatch") and pages:FindFirstChild("Chest") and pages:FindFirstChild("Status")
    task.wait(0.5)

    -- 🥚 Auto Hatch loop
    task.spawn(function()
        while sg.Parent do
            if State.HatchRunning and frameworkRemote then
                local ok,err = pcall(function()
                    frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                    State.EggsHatched += Config.HatchAmount
                end)
                if not ok then warn("[NiTROHUB][Hatch]", err) end
                task.wait(Config.HatchDelay)
            else
                task.wait(0.3)
            end
        end
    end)

    -- 📦 Auto Chest loop (no teleport)
    task.spawn(function()
        local last = {}
        while sg.Parent do
            if State.ChestRunning then
                local areas = {Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}
                for _,area in ipairs(areas) do
                    if area then
                        for _,obj in ipairs(area:GetDescendants()) do
                            if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                                local key = obj:GetDebugId()
                                if not last[key] or tick()-last[key] > Config.ChestCollectCooldown then
                                    local ok = pcall(function()
                                        frameworkRemote:FireServer("ClaimChest", obj.Name, true)
                                    end)
                                    if ok then
                                        State.ChestsCollected += 1
                                        State.LastChest = obj.Name
                                        last[key] = tick()
                                    end
                                end
                                task.wait()
                            end
                        end
                    end
                end
            end
            task.wait(Config.ChestCheckInterval)
        end
    end)

    -- 📊 Status refresh
    task.spawn(function()
        while sg.Parent do
            for _,s in ipairs(statusNodes) do
                local ok,v = pcall(s.getter)
                s.node.Text = ok and tostring(v) or "-"
            end
            task.wait(0.3)
        end
    end)
end)

print("[✅] NiTROHUB PRO — Final (No Rebirth) loaded.")
