--===============================================================
-- 🌀 NiTROHUB PRO - Final (Pure Instance.new GUI, No Libraries)
-- ✨ by NiTROHUB x ChatGPT
--===============================================================

--= CONFIG ======================================================
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 3,                 -- 1 / 3 / 9
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
    HatchRunning=false, RebirthRunning=false, ChestRunning=false,
    EggsHatched=0, ChestsCollected=0, LastChest="-", Status="Idle"
}

-- ไอคอน (เปลี่ยนได้ตามใจ)
local ICONS = {
    app = "rbxassetid://7734053425",     -- แอป/โลโก้
    egg = "rbxassetid://7733697785",
    rebirth = "rbxassetid://7733960981",
    chest = "rbxassetid://7733775631",
    status = "rbxassetid://7733911825",
    toggleOn = "rbxassetid://6031068433",
    toggleOff = "rbxassetid://6031068420",
    dropdown = "rbxassetid://6031090993",
}

--= SERVICES & REMOTES =========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local frameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

--= HELPERS =====================================================
local function log(...) print("[NiTROHUB]", ...) end
local function warnx(...) warn("[NiTROHUB]", ...) end

-- ทำ lookup ของ Chest
local CHEST_LIST = {}
for _,n in ipairs(Config.ChestNames) do CHEST_LIST[n:lower()] = true end

--= GUI FACTORY =================================================
local sg = Instance.new("ScreenGui")
sg.Name = "NiTROHUB_PRO_UI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

local theme = {
    bg = Color3.fromRGB(20,22,26),
    panel = Color3.fromRGB(28,30,36),
    primary = Color3.fromRGB(88,101,242),
    text = Color3.fromRGB(235,238,245),
    sub = Color3.fromRGB(160,170,190),
    good = Color3.fromRGB(0, 200, 120),
    warn = Color3.fromRGB(255, 170, 60),
    danger = Color3.fromRGB(230, 60, 80),
    stroke = Color3.fromRGB(60,65,75)
}

local function roundify(obj, r) local uic = Instance.new("UICorner", obj); uic.CornerRadius=UDim.new(0,r or 10) return uic end
local function stroke(obj, c, t) local s=Instance.new("UIStroke", obj); s.Thickness=t or 1; s.Color=c or theme.stroke; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border return s end
local function padding(p, t,l,r,b)
    local ui = Instance.new("UIPadding", p)
    ui.PaddingTop=UDim.new(0,t or 0); ui.PaddingLeft=UDim.new(0,l or 0)
    ui.PaddingRight=UDim.new(0,r or 0); ui.PaddingBottom=UDim.new(0,b or 0)
    return ui
end

-- Button base
local function makeButton(parent, text, iconId)
    local b = Instance.new("TextButton")
    b.Name = "Button"
    b.Parent = parent
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = theme.panel
    b.Text = ""
    roundify(b,8); stroke(b, theme.stroke, 1)

    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Image = iconId or ICONS.app
    icon.Size = UDim2.new(0,20,0,20)
    icon.Position = UDim2.new(0,12,0,8)
    icon.Parent = b

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.Font = Enum.Font.GothamSemibold
    t.TextColor3 = theme.text
    t.TextSize = 14
    t.AnchorPoint = Vector2.new(0,0.5)
    t.Position = UDim2.new(0,40,0,18)
    t.Size = UDim2.new(1,-50,1,-4)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = b

    -- Hover anim
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = theme.primary}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = theme.panel}):Play()
    end)

    return b
end

-- Toggle
local function makeToggle(parent, label, default, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,38)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = theme.text
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Size = UDim2.new(1,-48,1,0)
    text.Parent = frame

    local btn = Instance.new("ImageButton")
    btn.Image = default and ICONS.toggleOn or ICONS.toggleOff
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(0,28,0,28)
    btn.Position = UDim2.new(1,-28,0,5)
    btn.Parent = frame

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Image = state and ICONS.toggleOn or ICONS.toggleOff
        if cb then task.spawn(cb, state) end
    end)

    return {
        Set = function(v) state=v; btn.Image = state and ICONS.toggleOn or ICONS.toggleOff end,
        Get = function() return state end
    }
end

-- Dropdown
local function makeDropdown(parent, label, options, default, cb)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,0,0,74)
    holder.BackgroundTransparency = 1
    holder.Parent = parent

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = label
    title.TextColor3 = theme.text
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Size = UDim2.new(1,0,0,24)
    title.Parent = holder

    local box = Instance.new("TextButton")
    box.AutoButtonColor = false
    box.Text = ""
    box.Size = UDim2.new(1,0,0,36)
    box.Position = UDim2.new(0,0,0,28)
    box.Parent = holder
    box.BackgroundColor3 = theme.panel
    roundify(box,8); stroke(box, theme.stroke, 1)

    local val = Instance.new("TextLabel")
    val.BackgroundTransparency = 1
    val.Text = default or (options[1] or "-")
    val.Font = Enum.Font.GothamSemibold
    val.TextColor3 = theme.sub
    val.TextSize = 14
    val.TextXAlignment = Enum.TextXAlignment.Left
    val.Size = UDim2.new(1,-36,1,0)
    val.Position = UDim2.new(0,12,0,0)
    val.Parent = box

    local caret = Instance.new("ImageLabel")
    caret.BackgroundTransparency = 1
    caret.Image = ICONS.dropdown
    caret.Size = UDim2.new(0,18,0,18)
    caret.Position = UDim2.new(1,-26,0,9)
    caret.Parent = box

    local list = Instance.new("Frame")
    list.Visible = false
    list.BackgroundColor3 = theme.panel
    list.Size = UDim2.new(1,0,0, math.min(#options,6)*30 + 8)
    list.Position = UDim2.new(0,0,0,68)
    list.Parent = holder
    roundify(list,8); stroke(list, theme.stroke, 1)
    padding(list,4,4,4,4)

    local ui = Instance.new("UIListLayout", list)
    ui.Padding = UDim.new(0,4)

    local function setValue(v)
        val.Text = v
        if cb then cb(v) end
    end
    setValue(default or options[1])

    for _,op in ipairs(options) do
        local b = makeButton(list, op)
        b.Size = UDim2.new(1,0,0,26)
        b.MouseButton1Click:Connect(function()
            setValue(op)
            list.Visible=false
        end)
    end

    box.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    return {Set=setValue, Get=function() return val.Text end}
end

-- Label line
local function makeRow(parent)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,28)
    f.BackgroundTransparency = 1
    f.Parent = parent
    return f
end
local function makeLabel(parent, text, right)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 14
    l.TextColor3 = right and theme.sub or theme.text
    l.TextXAlignment = right and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
    l.Size = UDim2.new(0.5, -6, 1, 0)
    l.Position = right and UDim2.new(0.5, 6, 0, 0) or UDim2.new(0, 0, 0, 0)
    l.Parent = parent
    return l
end

--= MAIN WINDOW ==================================================
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 520, 0, 360)
window.Position = UDim2.new(0.5,-260,0.5,-180)
window.BackgroundColor3 = theme.bg
window.Active = true
window.Draggable = true
window.Parent = sg
roundify(window, 16); stroke(window, theme.stroke, 1)

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,48)
header.BackgroundColor3 = theme.panel
header.Parent = window
roundify(header,16); stroke(header, theme.stroke, 1)

local logo = Instance.new("ImageLabel")
logo.BackgroundTransparency = 1
logo.Image = ICONS.app
logo.Size = UDim2.new(0,26,0,26)
logo.Position = UDim2.new(0,14,0,11)
logo.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Text = "NiTROHUB PRO — Final"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = theme.text
title.Position = UDim2.new(0,48,0,0)
title.Size = UDim2.new(1,-180,1,0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subt = Instance.new("TextLabel")
subt.BackgroundTransparency = 1
subt.Text = "Auto Hatch • Rebirth • Chest"
subt.Font = Enum.Font.Gotham
subt.TextSize = 12
subt.TextColor3 = theme.sub
subt.Position = UDim2.new(0,48,0,22)
subt.Size = UDim2.new(1,-180,1,-22)
subt.TextXAlignment = Enum.TextXAlignment.Left
subt.Parent = header

local closeBtn = makeButton(header, "Close")
closeBtn.Size = UDim2.new(0,88,0,30)
closeBtn.Position = UDim2.new(1,-100,0,9)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled = false end)

-- Left tabbar
local tabbar = Instance.new("Frame")
tabbar.Size = UDim2.new(0,150,1,-60)
tabbar.Position = UDim2.new(0,10,0,54)
tabbar.BackgroundTransparency = 1
tabbar.Parent = window

local pages = Instance.new("Frame")
pages.Size = UDim2.new(1,-170,1,-60)
pages.Position = UDim2.new(0,160,0,54)
pages.BackgroundTransparency = 1
pages.Parent = window

local function createPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.new(1,0,1,0)
    p.CanvasSize = UDim2.new(0,0,0,0)
    p.ScrollBarThickness = 4
    p.Visible = false
    p.BackgroundTransparency = 1
    p.Parent = pages
    local ui = Instance.new("UIListLayout", p)
    ui.Padding = UDim.new(0,8); ui.SortOrder = Enum.SortOrder.LayoutOrder
    padding(p,8,8,8,8)
    return p
end

local function addTab(text, icon, page)
    local b = makeButton(tabbar, text, icon)
    b.Size = UDim2.new(1, -0, 0, 40)
    b.MouseButton1Click:Connect(function()
        for _,v in ipairs(pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
        page.Visible = true
    end)
    return b
end

pages.Hatch = createPage("Hatch")
pages.Rebirth = createPage("Rebirth")
pages.Chest = createPage("Chest")
pages.Status = createPage("Status")

addTab("🥚 Auto Hatch", ICONS.egg, pages.Hatch)
addTab("♻️ Auto Rebirth", ICONS.rebirth, pages.Rebirth)
addTab("📦 Auto Chest", ICONS.chest, pages.Chest)
addTab("📊 Status", ICONS.status, pages.Status)
pages.Hatch.Visible = true

--= BUILD: HATCH PAGE ===========================================
do
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    local eggNames = {}
    if eggsFolder then
        for _,e in ipairs(eggsFolder:GetChildren()) do
            if e:IsA("Model") or e:IsA("Folder") then table.insert(eggNames, e.Name) end
        end
    end
    table.sort(eggNames, function(a,b) return a<b end)
    if #eggNames == 0 then eggNames = {Config.EggName} end

    local ddEgg = makeDropdown(pages.Hatch, "เลือกไข่ที่จะเปิด", eggNames, Config.EggName, function(v)
        Config.EggName = v; log("Egg:", v)
    end)

    local ddAmount = makeDropdown(pages.Hatch, "จำนวนการเปิด (1/3/9)", {"1","3","9"}, tostring(Config.HatchAmount), function(v)
        Config.HatchAmount = tonumber(v) or 1
    end)

    local ddDelay = makeDropdown(pages.Hatch, "ดีเลย์ต่อรอบ (วินาที)", {"0.5","0.8","1.0","1.2","1.5","2.0"}, tostring(Config.HatchDelay), function(v)
        Config.HatchDelay = tonumber(v) or 1.2
    end)

    makeToggle(pages.Hatch, "เปิด Auto Hatch", false, function(on)
        State.HatchRunning = on
        State.Status = on and "Hatching Eggs..." or "Idle"
        log(on and "Start Hatch" or "Stop Hatch")
    end)
end

--= BUILD: REBIRTH PAGE =========================================
do
    local ddDelay = makeDropdown(pages.Rebirth, "ดีเลย์ Rebirth (วินาที)", {"0.5","1","2","3","5"}, tostring(Config.RebirthDelay), function(v)
        Config.RebirthDelay = tonumber(v) or 2
    end)
    makeToggle(pages.Rebirth, "เปิด Auto Rebirth", Config.AutoRebirth, function(on)
        State.RebirthRunning = on
        log(on and "Auto Rebirth ON" or "Auto Rebirth OFF")
    end)
end

--= BUILD: CHEST PAGE ===========================================
do
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1,0,0,160)
    listFrame.BackgroundColor3 = theme.panel
    listFrame.Parent = pages.Chest
    roundify(listFrame,10); stroke(listFrame, theme.stroke, 1); padding(listFrame,8,8,8,8)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = "Chest รายการที่เก็บอัตโนมัติ"
    title.TextColor3 = theme.text
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.Size = UDim2.new(1,0,0,20)
    title.Parent = listFrame

    local scroll = Instance.new("ScrollingFrame", listFrame)
    scroll.Position = UDim2.new(0,0,0,24)
    scroll.Size = UDim2.new(1,0,1,-24)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4

    local lay = Instance.new("UIListLayout", scroll)
    lay.Padding = UDim.new(0,4)
    padding(scroll,4,4,4,4)

    for _,n in ipairs(Config.ChestNames) do
        local lab = makeButton(scroll, n, ICONS.chest)
        lab.Size = UDim2.new(1,0,0,28)
        lab.AutoButtonColor=false
    end

    makeToggle(pages.Chest, "เปิด Auto Chest", false, function(on)
        State.ChestRunning = on
        State.Status = on and "Collecting Chests..." or "Idle"
        log(on and "Auto Chest ON" or "Auto Chest OFF")
    end)

    local ddInt = makeDropdown(pages.Chest, "รอบการตรวจ (วินาที)", {"5","10","15","30"}, tostring(Config.ChestCheckInterval), function(v)
        Config.ChestCheckInterval = tonumber(v) or 10
    end)
    local ddCd = makeDropdown(pages.Chest, "คูลดาวน์ต่อกล่อง (วินาที)", {"30","45","60","90"}, tostring(Config.ChestCollectCooldown), function(v)
        Config.ChestCollectCooldown = tonumber(v) or 60
    end)
end

--= BUILD: STATUS PAGE ==========================================
local statusLabels = {}
do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,0,0,160)
    card.BackgroundColor3 = theme.panel
    card.Parent = pages.Status
    roundify(card,10); stroke(card, theme.stroke, 1); padding(card,10,10,10,10)

    local headerT = Instance.new("TextLabel")
    headerT.BackgroundTransparency = 1
    headerT.Text = "📊 สถานะระบบ"
    headerT.TextColor3 = theme.text
    headerT.Font = Enum.Font.GothamBold
    headerT.TextSize = 16
    headerT.Size = UDim2.new(1,0,0,24)
    headerT.Parent = card

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,0,1,-28)
    list.Position = UDim2.new(0,0,0,28)
    list.BackgroundTransparency = 1
    list.Parent = card
    local col = Instance.new("UIListLayout", list)
    col.Padding = UDim.new(0,6)

    local function addRow(titleTxt, getFn)
        local row = makeRow(list)
        local l = makeLabel(row, titleTxt, false)
        local r = makeLabel(row, "", true)
        table.insert(statusLabels, {node=r, getter=getFn})
    end

    addRow("🚀 สถานะ", function() return State.Status end)
    addRow("🥚 Eggs Hatched", function() return tostring(State.EggsHatched) end)
    addRow("📦 Chests Collected", function() return tostring(State.ChestsCollected) end)
    addRow("🎁 Last Chest", function() return tostring(State.LastChest) end)
end

--= BACKGROUND WORKERS ==========================================

-- Hatch loop
task.spawn(function()
    while sg.Parent do
        if State.HatchRunning and frameworkRemote then
            local ok,err = pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched += Config.HatchAmount
            end)
            if not ok then warnx("Auto Hatch failed:", err); State.HatchRunning=false end
            task.wait(Config.HatchDelay)
        else
            task.wait(0.25)
        end
    end
end)

-- Rebirth loop
task.spawn(function()
    State.RebirthRunning = Config.AutoRebirth
    while sg.Parent do
        if State.RebirthRunning then
            local ok,err = pcall(function()
                frameworkRemote:FireServer("Rebirth", 1)
            end)
            if not ok then warnx("Rebirth error:", err); State.RebirthRunning=false end
            task.wait(Config.RebirthDelay)
        else
            task.wait(0.25)
        end
    end
end)

-- Chest loop (no teleport)
task.spawn(function()
    local lastCollected = {}
    local function collectChest(chest)
        if not chest or not chest.Parent then return end
        local key = chest:GetDebugId()
        if lastCollected[key] and tick() - lastCollected[key] < Config.ChestCollectCooldown then
            return
        end
        local ok = pcall(function()
            frameworkRemote:FireServer("ClaimChest", chest.Name, true)
        end)
        if ok then
            State.ChestsCollected += 1
            State.LastChest = chest.Name
            lastCollected[key] = tick()
            log("🎁 เก็บกล่อง:", chest.Name)
        end
    end

    while sg.Parent do
        if State.ChestRunning then
            local areas = {Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}
            for _,area in ipairs(areas) do
                if area then
                    for _,obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            collectChest(obj)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(Config.ChestCheckInterval)
    end
end)

-- Status refresher
task.spawn(function()
    while sg.Parent do
        for _,item in ipairs(statusLabels) do
            local ok, val = pcall(item.getter)
            item.node.Text = ok and tostring(val) or "-"
        end
        task.wait(0.3)
    end
end)

log("✅ NiTROHUB PRO (Final) UI loaded without external libraries.")
