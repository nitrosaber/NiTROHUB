--=============================================================
-- 🌀 NiTROHUB PRO — Final (No Library / Fixed GUI Edition)
--  • Dark GUI • Left tabs with icons • Master Power
--  • Features: Auto Hatch, Auto Chest, Status
--  • Hatch FX toggle: disables ReplicatedStorage.Client.Effects.HatchEgg
--=============================================================

-- CONFIG
local Config = {
    EggName = "Candle Egg",
    HatchAmount = 9,
    HatchDelay = 0.10,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
        "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
        "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
    }
}

local State = {
    MasterEnabled = true,
    HatchRunning = false,
    ChestRunning = false,
    EggsHatched = 0,
    ChestsCollected = 0,
    LastChest = "-",
    Status = "Idle"
}

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- REMOTES (game-specific)
local frameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

-- ===== HATCH FX KILLER =======================================
-- ปิดแอนิเมชัน HatchEgg แบบปลอดภัย + กู้คืนได้
local _hatchBackup, _placeholder

local function _effectsFolders()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local effects = client and client:FindFirstChild("Effects")
    return client, effects
end

local function disableHatchFX()
    local _, effects = _effectsFolders()
    if not effects then return false, "Effects folder not found" end
    local hatch = effects:FindFirstChild("HatchEgg")
    if not hatch then return false, "HatchEgg not found" end

    -- 1) พยายามปิด connections ก่อน (ต้องมี getconnections)
    local function killConnections(signal)
        local any = false
        if typeof(getconnections) == "function" and signal then
            for _,c in ipairs(getconnections(signal)) do
                pcall(function() c:Disable() end)
                any = true
            end
        end
        return any
    end

    local killed = false
    if hatch:IsA("RemoteEvent") then
        killed = killConnections(hatch.OnClientEvent)
    elseif hatch:IsA("BindableEvent") then
        killed = killConnections(hatch.Event)
    end
    if killed then return true end

    -- 2) ถ้าปิดไม่ได้ ให้เปลี่ยนชื่อเก็บของจริง แล้ววาง placeholder ชื่อเดิมแทน
    _hatchBackup = hatch
    _hatchBackup.Name = "__HatchEgg_Original_Disabled"

    if _placeholder then _placeholder:Destroy() end
    if _hatchBackup.ClassName == "RemoteEvent" then
        _placeholder = Instance.new("RemoteEvent")
    elseif _hatchBackup.ClassName == "BindableEvent" then
        _placeholder = Instance.new("BindableEvent")
    else
        _placeholder = Instance.new("Folder")
    end
    _placeholder.Name = "HatchEgg"
    _placeholder.Parent = effects
    return true
end

local function restoreHatchFX()
    local _, effects = _effectsFolders()
    if not effects then return false end
    if _hatchBackup and _hatchBackup.Parent and effects:FindFirstChild("HatchEgg") then
        _placeholder:Destroy()
        _hatchBackup.Name = "HatchEgg"
        _hatchBackup.Parent = effects
        _hatchBackup, _placeholder = nil, nil
        return true
    end
    return false
end

-- ===== GUI ====================================================
local theme = {
    bg=Color3.fromRGB(20,22,26), panel=Color3.fromRGB(28,30,36),
    text=Color3.fromRGB(235,238,245), sub=Color3.fromRGB(160,170,190),
    stroke=Color3.fromRGB(60,65,75), primary=Color3.fromRGB(88,101,242),
    ok=Color3.fromRGB(60,180,110), off=Color3.fromRGB(60,60,60), bad=Color3.fromRGB(220,70,80)
}

local function round(o,r) Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 10) end
local function stroke(o,c,t) local s=Instance.new("UIStroke",o); s.Color=c or theme.stroke; s.Thickness=t or 1; return s end

local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "NiTROHUB_PRO_UI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame", sg)
main.Name = "Frame"
main.Size = UDim2.new(0,560,0,380)
main.Position = UDim2.new(0.5,-280,0.5,-190)
main.BackgroundColor3 = theme.bg
main.Active = true
main.Draggable = true
round(main,16); stroke(main)

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,52)
header.BackgroundColor3 = theme.panel
round(header,16); stroke(header)

local title = Instance.new("TextLabel", header)
title.BackgroundTransparency=1
title.Text = "🌀 NiTROHUB PRO — Final"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = theme.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Size = UDim2.new(1,-180,1,0)
title.Position = UDim2.new(0,16,0,0)

local subtitle = Instance.new("TextLabel", header)
subtitle.BackgroundTransparency=1
subtitle.Text = "Auto Hatch • Auto Chest • Status"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = theme.sub
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Size = UDim2.new(1,-180,1,0)
subtitle.Position = UDim2.new(0,16,0,22)

-- Master Power (⏻)
local power = Instance.new("TextButton", header)
power.AutoButtonColor=false
power.Text = "⏻"
power.Font = Enum.Font.GothamBold
power.TextSize = 18
power.TextColor3 = theme.text
power.Size = UDim2.new(0,32,0,32)
power.Position = UDim2.new(1,-90,0.5,-16)
power.BackgroundColor3 = theme.ok
round(power,16); stroke(power)
power.MouseButton1Click:Connect(function()
    State.MasterEnabled = not State.MasterEnabled
    if State.MasterEnabled then
        power.BackgroundColor3 = theme.ok
        subtitle.Text = "Auto Hatch • Auto Chest • Status"
    else
        power.BackgroundColor3 = theme.bad
        -- turn everything off immediately
        State.HatchRunning = false
        State.ChestRunning = false
        subtitle.Text = "MASTER OFF — all systems paused"
    end
end)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "Close"
closeBtn.AutoButtonColor=false
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.TextColor3 = theme.text
closeBtn.Size = UDim2.new(0,80,0,30)
closeBtn.Position = UDim2.new(1,-80-10,0.5,-15)
closeBtn.BackgroundColor3 = theme.panel
round(closeBtn,10); stroke(closeBtn)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

-- Left tabs
local tabbar = Instance.new("Frame", main)
tabbar.Size = UDim2.new(0,150,1,-64)
tabbar.Position = UDim2.new(0,12,0,56)
tabbar.BackgroundTransparency = 1

local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-184,1,-64)
pages.Position = UDim2.new(0,172,0,56)
pages.BackgroundTransparency = 1

local function makePage(name)
    local sc = Instance.new("ScrollingFrame", pages)
    sc.Name=name; sc.Size=UDim2.new(1,0,1,0)
    sc.ScrollBarThickness=4; sc.BackgroundTransparency=1; sc.Visible=false
    local l = Instance.new("UIListLayout", sc); l.Padding=UDim.new(0,8)
    return sc
end
local function makeTab(text, page)
    local b = Instance.new("TextButton", tabbar)
    b.AutoButtonColor=false
    b.Size = UDim2.new(1,0,0,40)
    b.Text = text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 14
    b.TextColor3 = theme.text
    b.BackgroundColor3 = theme.panel
    round(b,10); stroke(b)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=theme.primary}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=theme.panel}):Play() end)
    b.MouseButton1Click:Connect(function()
        for _,v in ipairs(pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
        page.Visible=true
    end)
end

pages.Hatch  = makePage("Hatch")
pages.Chest  = makePage("Chest")
pages.Status = makePage("Status")
pages.Hatch.Visible = true

makeTab("🥚  Auto Hatch",  pages.Hatch)
makeTab("📦  Auto Chest",  pages.Chest)
makeTab("📊  Status",      pages.Status)

-- Widgets
local function toggle(parent, label, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,38); f.BackgroundTransparency=1
    local t = Instance.new("TextLabel", f)
    t.BackgroundTransparency=1; t.Text=label; t.Font=Enum.Font.Gotham; t.TextSize=14
    t.TextColor3=theme.text; t.TextXAlignment=Enum.TextXAlignment.Left; t.Size=UDim2.new(1,-60,1,0)
    local b = Instance.new("TextButton", f)
    b.AutoButtonColor=false; b.Size=UDim2.new(0,30,0,26); b.Position=UDim2.new(1,-34,0.5,-13)
    b.Text="OFF"; b.Font=Enum.Font.GothamBold; b.TextSize=12; b.TextColor3=theme.text
    b.BackgroundColor3=theme.off; round(b,8); stroke(b)
    local on=false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = on and "ON" or "OFF"
        b.BackgroundColor3 = on and theme.ok or theme.off
        if cb then task.spawn(cb, on) end
    end)
    return {Set=function(v) on=v; b.Text=v and "ON" or "OFF"; b.BackgroundColor3=v and theme.ok or theme.off end}
end

local function dropdown(parent, label, options, default, cb)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1,0,0,72); box.BackgroundTransparency=1
    local tl = Instance.new("TextLabel", box)
    tl.BackgroundTransparency=1; tl.Text=label; tl.Font=Enum.Font.Gotham; tl.TextSize=14
    tl.TextColor3=theme.text; tl.Size=UDim2.new(1,0,0,22); tl.TextXAlignment=Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", box)
    btn.AutoButtonColor=false; btn.Size=UDim2.new(1,0,0,36); btn.Position=UDim2.new(0,0,0,28)
    btn.BackgroundColor3=theme.panel; btn.Text=""
    round(btn,10); stroke(btn)
    local val = Instance.new("TextLabel", btn)
    val.BackgroundTransparency=1; val.Text=default or (options[1] or "-")
    val.Font=Enum.Font.GothamSemibold; val.TextSize=14; val.TextColor3=theme.sub
    val.TextXAlignment=Enum.TextXAlignment.Left; val.Size=UDim2.new(1,-16,1,0); val.Position=UDim2.new(0,8,0,0)

    local list = Instance.new("Frame", box)
    list.Visible=false; list.BackgroundColor3=theme.panel
    list.Size=UDim2.new(1,0,0, math.min(#options,6)*28 + 8); list.Position=UDim2.new(0,0,0,68)
    round(list,10); stroke(list)
    local lay = Instance.new("UIListLayout", list); lay.Padding=UDim.new(0,4)

    local function set(v) val.Text=v; if cb then task.spawn(cb,v) end end
    set(default or options[1])

    for _,op in ipairs(options) do
        local o = Instance.new("TextButton", list)
        o.AutoButtonColor=false; o.Size=UDim2.new(1,0,0,24)
        o.BackgroundColor3=theme.panel; o.Text=op; o.Font=Enum.Font.GothamSemibold
        o.TextSize=13; o.TextColor3=theme.text; round(o,6); stroke(o)
        o.MouseButton1Click:Connect(function() set(op); list.Visible=false end)
    end
    btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)
    return {Set=set, Get=function() return val.Text end}
end

-- ===== HATCH TAB ==============================================
do
    -- (optional) egg names from workspace
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    local eggNames = {}
    if eggsFolder then
        for _,e in ipairs(eggsFolder:GetChildren()) do
            if e:IsA("Model") or e:IsA("Folder") then table.insert(eggNames, e.Name) end
        end
    end
    if #eggNames == 0 then eggNames = {Config.EggName} end

    dropdown(pages.Hatch, "เลือกไข่", eggNames, Config.EggName, function(v) Config.EggName=v end)
    dropdown(pages.Hatch, "จำนวนเปิด", {"1","3","9"}, tostring(Config.HatchAmount), function(v) Config.HatchAmount=tonumber(v) or 1 end)
    dropdown(pages.Hatch, "ดีเลย์ (วิ)", {"0.05","0.1","0.2","0.5","1.0","1.2"}, tostring(Config.HatchDelay), function(v) Config.HatchDelay=tonumber(v) or 0.1 end)

    toggle(pages.Hatch, "Auto Hatch", function(on)
        State.HatchRunning = on
        State.Status = on and "Hatching Eggs..." or "Idle"
    end)

    toggle(pages.Hatch, "Disable Hatch Animation", function(on)
        if on then
            local ok, why = disableHatchFX()
            print(ok and "[NiTROHUB] Hatch FX disabled." or ("[NiTROHUB] FX not disabled: "..tostring(why)))
        else
            local ok = restoreHatchFX()
            print(ok and "[NiTROHUB] Hatch FX restored." or "[NiTROHUB] Nothing to restore.")
        end
    end)
end

-- ===== CHEST TAB ==============================================
do
    toggle(pages.Chest, "Auto Chest", function(on)
        State.ChestRunning = on
        State.Status = on and "Collecting Chests..." or "Idle"
    end)
    dropdown(pages.Chest, "รอบตรวจ (วิ)", {"5","10","15","30"}, tostring(Config.ChestCheckInterval), function(v) Config.ChestCheckInterval=tonumber(v) or 10 end)
    dropdown(pages.Chest, "คูลดาวน์ต่อกล่อง (วิ)", {"30","45","60","90"}, tostring(Config.ChestCollectCooldown), function(v) Config.ChestCollectCooldown=tonumber(v) or 60 end)
end

-- ===== STATUS TAB =============================================
local statusLbl = Instance.new("TextLabel", pages.Status)
statusLbl.BackgroundTransparency=1
statusLbl.TextColor3=theme.text
statusLbl.Font=Enum.Font.Gotham
statusLbl.TextSize=16
statusLbl.TextXAlignment=Enum.TextXAlignment.Left
statusLbl.TextYAlignment=Enum.TextYAlignment.Top
statusLbl.Size=UDim2.new(1,-20,1,-20)
statusLbl.Position=UDim2.new(0,10,0,10)

task.spawn(function()
    while sg.Parent do
        statusLbl.Text = ("📌 สถานะ: %s\n🥚 Eggs Hatched: %s\n📦 Chests Collected: %s\n🎁 Last Chest: %s")
            :format(State.Status, State.EggsHatched, State.ChestsCollected, State.LastChest)
        task.wait(0.3)
    end
end)

-- ===== WORKERS (start AFTER pages exist) ======================
task.spawn(function()
    repeat task.wait(0.2) until pages:FindFirstChild("Hatch")
    while sg.Parent do
        if State.MasterEnabled and State.HatchRunning and frameworkRemote then
            local ok, err = pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched += Config.HatchAmount
            end)
            if not ok then warn("[NiTROHUB] Hatch Error:", err) end
            task.wait(Config.HatchDelay)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    repeat task.wait(0.2) until pages:FindFirstChild("Chest")
    local CHEST_LOOKUP = {}
    for _,n in ipairs(Config.ChestNames) do CHEST_LOOKUP[n:lower()] = true end
    local last = {}
    while sg.Parent do
        if State.MasterEnabled and State.ChestRunning then
            for _,area in ipairs({Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}) do
                if area then
                    for _,obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and CHEST_LOOKUP[obj.Name:lower()] then
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
            task.wait(Config.ChestCheckInterval)
        else
            task.wait(0.2)
        end
    end
end)

print("[NiTROHUB] ✅ Final Version Loaded (Master switch + FX killer).")
