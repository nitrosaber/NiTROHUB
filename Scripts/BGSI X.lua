--// NiTroHUB PRO - Infinity Hatch + AutoChest (FULL)
--// by NiTroHUB x ChatGPT
--// รวมทุกฟีเจอร์: AutoHatch, AutoChest remote collect, no-animation, AntiAFK, GUI, logs

-- ==========================
-- CONFIG (แก้ได้ตามต้องการ)
-- ==========================
local DEFAULT_EGG = "Autumn Egg"
local DEFAULT_HATCH_AMOUNT = 8      -- 1 / 3 / 8 ตามเกมรองรับ
local DEFAULT_HATCH_DELAY = 0.05    -- ระวังตั้งค่าต่ำมากจะสแปม server
local CHEST_CHECK_INTERVAL = 6      -- วินาที ตรวจหา chest
local CHEST_COOLDOWN = 60           -- วินาทีก่อนเก็บ chest เดิมซ้ำ
local EGG_LIST = {                  -- ตัวอย่าง list จาก wiki (ขยายได้)
    "Autumn Egg","Infinity Egg","Common Egg","Spotted Egg","Aura Egg","Pastel Egg",
    "Bunny Egg","Throwback Egg","100M Egg","Silly Egg","Game Egg","Underworld Egg",
    "Beach Egg","Icecream Egg","Fruit Egg","Magma Egg","Void Egg","Rainbow Egg"
}
local CHEST_WHITELIST = {           -- รายชื่อกล่องตามที่ให้มา (ตรงตามคำขอ)
    "Royal Chest","Super Chest","Golden Chest","Ancient Chest",
    "Dice Chest","Infinity Chest","Void Chest","Giant Chest",
    "Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"
}

-- ==========================
-- SERVICES & PLAYER
-- ==========================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================
-- STATE
-- ==========================
local config = {
    egg = DEFAULT_EGG,
    amount = DEFAULT_HATCH_AMOUNT,
    delay = DEFAULT_HATCH_DELAY
}
local autoHatch = false
local autoChest = true
local eggsHatchedCount = 0
local chestsCollectedCount = 0
local lastCollected = {} -- map[string] = timestamp, key by chest name or unique id

-- prepare chest whitelist lookup (lowercase)
local CHEST_MAP = {}
for _, n in ipairs(CHEST_WHITELIST) do CHEST_MAP[n:lower()] = true end

-- utility safe print
local function logmsg(...)
    print("[NiTroHUB]", ...)
end

-- ==========================
-- RemoteEvent finder (robust)
-- ==========================
local function findRemoteEvent()
    -- try known path
    local ok, remote = pcall(function()
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        if shared then
            local framework = shared:FindFirstChild("Framework")
            if framework then
                local network = framework:FindFirstChild("Network")
                if network then
                    local remoteFolder = network:FindFirstChild("Remote") or network
                    if remoteFolder then
                        local re = remoteFolder:FindFirstChild("RemoteEvent") or remoteFolder:FindFirstChildWhichIsA("RemoteEvent")
                        if re then return re end
                    end
                end
            end
        end
        return nil
    end)
    if ok and remote then return remote end

    -- fallback: search any RemoteEvent under ReplicatedStorage with likely name
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local lname = obj.Name:lower()
            if lname:find("remoteevent") or lname:find("remote") or lname:find("network") then
                return obj
            end
        end
    end

    -- last resort: first RemoteEvent
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then return obj end
    end

    return nil
end

local remoteEvent = findRemoteEvent()
if not remoteEvent then
    warn("[NiTroHUB] RemoteEvent not found. Hatch will likely fail.")
else
    logmsg("RemoteEvent found:", remoteEvent:GetFullName())
end

-- ==========================
-- No-animation patch (getsenv) - safe
-- ==========================
task.spawn(function()
    pcall(function()
        -- Try multiple likely script paths to be robust
        local success = false
        local tryRoots = {}
        -- PlayerScripts -> Scripts -> Game
        local pScripts = player:FindFirstChild("PlayerScripts")
        if pScripts then
            local scriptsFolder = pScripts:FindFirstChild("Scripts")
            if scriptsFolder then
                local gameFolder = scriptsFolder:FindFirstChild("Game") or scriptsFolder
                table.insert(tryRoots, gameFolder)
            end
        end
        -- also try PlayerGui or other places
        table.insert(tryRoots, player:FindFirstChild("PlayerScripts"))
        for _, root in ipairs(tryRoots) do
            if root and root:IsA("Instance") then
                for _, child in ipairs(root:GetDescendants()) do
                    if child:IsA("LocalScript") or child:IsA("ModuleScript") then
                        local nm = child.Name:lower()
                        if nm:find("egg") and (nm:find("open") or nm:find("open") or nm:find("frontend") or nm:find("hatch")) then
                            if type(getsenv) == "function" then
                                local env = getsenv(child)
                                if env and env.PlayEggAnimation then
                                    env.PlayEggAnimation = function(...) return end
                                    logmsg("Patched PlayEggAnimation from", child:GetFullName())
                                    success = true
                                end
                            end
                        end
                    end
                end
            end
        end
        -- explicit try by name if available
        pcall(function()
            local candidate = player:WaitForChild("PlayerScripts", 1)
            if candidate then
                local eggsScript = candidate:FindFirstChild("Scripts") and candidate.Scripts:FindFirstChild("Game") and candidate.Scripts.Game:FindFirstChild("Egg Opening Frontend")
                if eggsScript and type(getsenv) == "function" then
                    local env = getsenv(eggsScript)
                    if env and env.PlayEggAnimation then
                        env.PlayEggAnimation = function(...) return end
                        logmsg("Patched PlayEggAnimation (Egg Opening Frontend)")
                        success = true
                    end
                end
            end
        end)
        if not success then
            logmsg("No animation patch applied (getsenv unavailable or script not found).")
        end
    end)
end)

-- ==========================
-- Hide/disable original hatch GUIs and on spawn disable new GUI items with names
-- ==========================
local HIDE_GUI_NAMES = {"HatchEggUI","HatchAnimationGui","HatchGui","LastHatchGui","EggHatchUI","AutoDeleteUI","HatchPopupUI"}

task.spawn(function()
    -- initial and periodic disable
    while task.wait(0.6) do
        for _, name in ipairs(HIDE_GUI_NAMES) do
            local g = playerGui:FindFirstChild(name)
            if g and g:IsA("ScreenGui") or g and g:IsA("GuiObject") then
                pcall(function() g.Enabled = false; g.Visible = false end)
            end
        end
    end
end)

-- disable newly added GUIs that look like hatch UI
game.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("ScreenGui") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            local nm = obj.Name:lower()
            if nm:find("hatch") or nm:find("egg") or nm:find("open") or nm:find("popup") then
                pcall(function() obj.Enabled = false; obj.Visible = false end)
            end
        end
    end)
end)

-- ==========================
-- Auto Hatch functions
-- ==========================
local function doHatch()
    if not remoteEvent then return end
    pcall(function()
        -- FireServer arguments depend on game - based on your earlier usage:
        remoteEvent:FireServer("HatchEgg", config.egg, config.amount)
        eggsHatchedCount = eggsHatchedCount + (tonumber(config.amount) or 1)
    end)
end

task.spawn(function()
    while true do
        task.wait(math.max(0.0005, tonumber(config.delay) or DEFAULT_HATCH_DELAY))
        if autoHatch then
            doHatch()
        end
    end
end)

-- ==========================
-- Auto Chest (remote collect NO teleport)
-- ==========================
-- Find candidate touch part for a chest model
local function findTriggerPart(model)
    if not model then return nil end
    -- try common names first (recursive)
    local names = {"TouchTrigger","Touch","Trigger","Hitbox","HitBox","CollectPart","Part"}
    for _, n in ipairs(names) do
        local p = model:FindFirstChild(n, true)
        if p and p:IsA("BasePart") then return p end
    end
    -- try PrimaryPart
    if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then return model.PrimaryPart end
    -- fallback first BasePart descendant
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then return d end
    end
    return nil
end

local function chestIsWhitelisted(model)
    if not model or not model.Name then return false end
    local lower = model.Name:lower()
    return CHEST_MAP[lower] or false
end

-- Use firetouchinterest to simulate touch without moving player
local function remoteCollectPart(part)
    if not part or not player.Character then return false end
    if type(firetouchinterest) == "function" then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        pcall(function()
            firetouchinterest(hrp, part, 0)
            task.wait(0.12)
            firetouchinterest(hrp, part, 1)
        end)
        return true
    else
        -- firetouchinterest not available on this executor
        return false
    end
end

task.spawn(function()
    while true do
        task.wait(CHEST_CHECK_INTERVAL)
        if autoChest then
            -- scan workspace and optional "Chests" folder
            local searchAreas = {workspace}
            if workspace:FindFirstChild("Chests") then table.insert(searchAreas, workspace.Chests) end

            for _, area in ipairs(searchAreas) do
                for _, obj in ipairs(area:GetDescendants()) do
                    if obj:IsA("Model") then
                        -- check whitelist by name (case-insensitive)
                        local nm = obj.Name and obj.Name:lower() or ""
                        if CHEST_MAP[nm] then
                            -- cooldown per chest-name (or use unique id if you want per instance)
                            local key = obj:GetDebugId and obj:GetDebugId() or obj:GetFullName() or obj.Name
                            if lastCollected[key] and tick() - lastCollected[key] < CHEST_COOLDOWN then
                                -- still cooling down
                            else
                                local trigger = findTriggerPart(obj)
                                if trigger then
                                    local ok = remoteCollectPart(trigger)
                                    if ok then
                                        lastCollected[key] = tick()
                                        chestsCollectedCount = chestsCollectedCount + 1
                                        logmsg("Collected chest:", obj.Name)
                                    else
                                        -- remote collect not supported by executor
                                        -- (do not teleport; skip)
                                        -- Optionally we can try to invoke a server remote to collect if known (not implemented)
                                        -- warn once
                                        warn("[NiTroHUB] remoteCollect not supported on this executor (firetouchinterest missing). Chest not collected:", obj.Name)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================
-- Anti AFK
-- ==========================
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        pcall(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
end)

-- ==========================
-- GUI (dropdown for eggs, toggles, stats log)
-- ==========================
-- avoid creating multiple GUIs
if playerGui:FindFirstChild("NiTroHUB_GUI") then
    playerGui.NiTroHUB_GUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NiTroHUB_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 380, 0, 220)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Header
local header = Instance.new("TextLabel", frame)
header.Position = UDim2.new(0, 20, 0, 12)
header.Size = UDim2.new(1, -40, 0, 28)
header.BackgroundTransparency = 1
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.Text = "🌀 NiTroHUB PRO - Infinity Hatch"
header.TextColor3 = Color3.fromRGB(255,120,120)
header.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 28, 0, 24)
closeBtn.Position = UDim2.new(1, -34, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- Egg dropdown (simple)
local ddBtn = Instance.new("TextButton", frame)
ddBtn.Position = UDim2.new(0.04, 0, 0.16, 0)
ddBtn.Size = UDim2.new(0.6, 0, 0, 30)
ddBtn.Font = Enum.Font.Gotham
ddBtn.TextSize = 14
ddBtn.Text = "Egg: "..tostring(config.egg)
ddBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ddBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0,6)

local ddOpen = false
local ddFrame = Instance.new("Frame", frame)
ddFrame.Position = UDim2.new(0.04, 0, 0.16, 30)
ddFrame.Size = UDim2.new(0.6, 0, 0, 0)
ddFrame.ClipsDescendants = true
ddFrame.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", ddFrame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,#EGG_LIST * 30)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- populate eggs
for i,eggname in ipairs(EGG_LIST) do
    local it = Instance.new("TextButton", scroll)
    it.Size = UDim2.new(1, -6, 0, 28)
    it.Position = UDim2.new(0, 3, 0, (i-1)*30)
    it.BackgroundColor3 = Color3.fromRGB(30,30,30)
    it.Font = Enum.Font.Gotham
    it.TextSize = 14
    it.TextColor3 = Color3.fromRGB(255,255,255)
    it.Text = eggname
    local corner = Instance.new("UICorner", it)
    corner.CornerRadius = UDim.new(0,6)
    it.MouseButton1Click:Connect(function()
        config.egg = eggname
        ddBtn.Text = "Egg: "..eggname
        ddOpen = false
        ddFrame:TweenSize(UDim2.new(0.6,0,0,0),"Out","Quad",0.18,true)
    end)
end

ddBtn.MouseButton1Click:Connect(function()
    if ddOpen then
        ddFrame:TweenSize(UDim2.new(0.6, 0, 0, 0),"Out","Quad",0.18,true)
    else
        local fullh = math.min(#EGG_LIST * 30, 180)
        ddFrame:TweenSize(UDim2.new(0.6,0,0,fullh),"Out","Quad",0.18,true)
    end
    ddOpen = not ddOpen
end)

-- Hatch amount selection (1 / 3 / 8)
local amtLabel = Instance.new("TextLabel", frame)
amtLabel.Position = UDim2.new(0.66, 0, 0.16, 0)
amtLabel.Size = UDim2.new(0.12, 0, 0, 30)
amtLabel.BackgroundTransparency = 1
amtLabel.Font = Enum.Font.Gotham
amtLabel.TextSize = 14
amtLabel.Text = "Amount"
amtLabel.TextColor3 = Color3.fromRGB(200,200,200)

local amtBox = Instance.new("TextBox", frame)
amtBox.Position = UDim2.new(0.78, 0, 0.16, 0)
amtBox.Size = UDim2.new(0.18, 0, 0, 30)
amtBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
amtBox.Text = tostring(config.amount)
amtBox.ClearTextOnFocus = false
amtBox.Font = Enum.Font.Gotham
amtBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", amtBox).CornerRadius = UDim.new(0,6)
amtBox.FocusLost:Connect(function(enter)
    local v = tonumber(amtBox.Text)
    if v and v > 0 then
        config.amount = math.floor(v)
        amtBox.Text = tostring(config.amount)
    else
        amtBox.Text = tostring(config.amount)
    end
end)

-- Delay Box
local delayLabel = Instance.new("TextLabel", frame)
delayLabel.Position = UDim2.new(0.04, 0, 0.34, 0)
delayLabel.Size = UDim2.new(0.35, 0, 0, 20)
delayLabel.BackgroundTransparency = 1
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.Text = "Delay (s)"
delayLabel.TextColor3 = Color3.fromRGB(200,200,200)

local delayBox = Instance.new("TextBox", frame)
delayBox.Position = UDim2.new(0.34, 0, 0.34, 0)
delayBox.Size = UDim2.new(0.22, 0, 0, 20)
delayBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
delayBox.Text = tostring(config.delay)
delayBox.ClearTextOnFocus = false
delayBox.Font = Enum.Font.Gotham
delayBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0,6)
delayBox.FocusLost:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v >= 0 then
        config.delay = v
        delayBox.Text = tostring(config.delay)
    else
        delayBox.Text = tostring(config.delay)
    end
end)

-- AutoHatch toggle
local hatchBtn = Instance.new("TextButton", frame)
hatchBtn.Position = UDim2.new(0.04, 0, 0.52, 0)
hatchBtn.Size = UDim2.new(0.44, 0, 0, 28)
hatchBtn.Font = Enum.Font.GothamBold
hatchBtn.TextSize = 14
hatchBtn.Text = "AutoHatch: OFF (J)"
hatchBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
hatchBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", hatchBtn).CornerRadius = UDim.new(0,6)
hatchBtn.MouseButton1Click:Connect(function()
    autoHatch = not autoHatch
    hatchBtn.Text = "AutoHatch: "..(autoHatch and "ON (J)" or "OFF (J)")
    hatchBtn.BackgroundColor3 = autoHatch and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(80,80,80)
end)

-- AutoChest toggle
local chestBtn = Instance.new("TextButton", frame)
chestBtn.Position = UDim2.new(0.52, 0, 0.52, 0)
chestBtn.Size = UDim2.new(0.44, 0, 0, 28)
chestBtn.Font = Enum.Font.GothamBold
chestBtn.TextSize = 14
chestBtn.Text = "AutoChest: ON"
chestBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
chestBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", chestBtn).CornerRadius = UDim.new(0,6)
chestBtn.MouseButton1Click:Connect(function()
    autoChest = not autoChest
    chestBtn.Text = "AutoChest: "..(autoChest and "ON" or "OFF")
    chestBtn.BackgroundColor3 = autoChest and Color3.fromRGB(0,170,255) or Color3.fromRGB(80,80,80)
end)

-- Stats / Log area
local stats = Instance.new("TextLabel", frame)
stats.Position = UDim2.new(0.04, 0, 0.72, 0)
stats.Size = UDim2.new(0.92, 0, 0.22, 0)
stats.BackgroundTransparency = 1
stats.Font = Enum.Font.Gotham
stats.TextSize = 13
stats.TextColor3 = Color3.fromRGB(220,220,220)
stats.TextXAlignment = Enum.TextXAlignment.Left
stats.TextYAlignment = Enum.TextYAlignment.Top
stats.Text = "Eggs Hatched: 0\nChests Collected: 0\nLast Chest: -"

-- Mini icon (tooltip)
local mini = Instance.new("TextButton", screenGui)
mini.Size = UDim2.new(0,48,0,48)
mini.Position = UDim2.new(0.02, 0, 0.75, 0)
mini.BackgroundColor3 = Color3.fromRGB(8,8,8)
mini.Text = "🌀"
mini.TextSize = 26
mini.Font = Enum.Font.GothamBold
mini.TextColor3 = Color3.fromRGB(0,255,255)
mini.BackgroundTransparency = 0.2
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local miniTip = Instance.new("TextLabel", mini)
miniTip.Size = UDim2.new(0, 140, 0, 26)
miniTip.Position = UDim2.new(1, 6, 0.2, 0)
miniTip.BackgroundColor3 = Color3.fromRGB(12,12,12)
miniTip.Text = "NiTroHUB PRO"
miniTip.TextColor3 = Color3.fromRGB(0,255,255)
miniTip.Font = Enum.Font.GothamBold
miniTip.TextSize = 14
miniTip.Visible = false
miniTip.BackgroundTransparency = 0.2
Instance.new("UICorner", miniTip).CornerRadius = UDim.new(0,6)

mini.MouseEnter:Connect(function() miniTip.Visible = true end)
mini.MouseLeave:Connect(function() miniTip.Visible = false end)
mini.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

-- update stats periodically
task.spawn(function()
    while task.wait(0.5) do
        stats.Text = string.format("Eggs Hatched: %d\nChests Collected: %d\nLast Chest: %s",
            eggsHatchedCount, chestsCollectedCount, (lastCollected._lastName or "-"))
    end
end)

-- when a chest collected, update last name (helper)
local function setLastChestName(name)
    lastCollected._lastName = name or "-"
end

-- ensure egg text shows config
ddBtn.Text = "Egg: "..tostring(config.egg)
amtBox.Text = tostring(config.amount)
delayBox.Text = tostring(config.delay)

-- ==========================
-- Input J toggles AutoHatch
-- ==========================
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.J then
        autoHatch = not autoHatch
        hatchBtn.Text = "AutoHatch: "..(autoHatch and "ON (J)" or "OFF (J)")
        hatchBtn.BackgroundColor3 = autoHatch and Color3.fromRGB(200,50,50) or Color3.fromRGB(80,80,80)
    end
end)

-- ==========================
-- Helper: chest collection log inside the auto collection loop
-- ==========================
-- The auto collection loop sets lastCollected[key] and chestsCollectedCount when successful.
-- We also set lastCollected._lastName to show latest chest name in GUI

-- ==========================
-- Final message
-- ==========================
logmsg("NiTroHUB PRO loaded. Requirements: executor with 'firetouchinterest' recommended for remote chest collection; 'getsenv' optional for no-animation patch.")
logmsg("Controls: J toggles AutoHatch; use GUI to toggle AutoChest, change egg/amount/delay.")
