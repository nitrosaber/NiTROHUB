--=============================================================
-- 🌀 NiTROHUB PRO — Final (No Library / Fixed GUI Edition)
--=============================================================

-- CONFIG
local Config = {
    EggName = "Autumn Egg",
    HatchAmount = 3,
    HatchDelay = 0.5,
    ChestCheckInterval = 10,
    ChestCollectCooldown = 60,
    ChestNames = {
        "Royal Chest", "Super Chest", "Golden Chest", "Ancient Chest",
        "Dice Chest", "Infinity Chest", "Void Chest", "Giant Chest",
        "Ticket Chest", "Easy Obby Chest", "Medium Obby Chest", "Hard Obby Chest"
    }
}

local State = {
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
local LocalPlayer = Players.LocalPlayer

-- REMOTES
local frameworkRemote = ReplicatedStorage:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

-- CREATE GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "NiTROHUB_PRO_UI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "Frame"
mainFrame.Size = UDim2.new(0, 550, 0, 350)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "🌀 NiTROHUB PRO — Final"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 60, 0, 25)
closeBtn.Position = UDim2.new(1, -70, 0, 8)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 14
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Left Tabs
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0, 120, 1, -40)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
local tabCorner = Instance.new("UICorner", tabFrame)
tabCorner.CornerRadius = UDim.new(0, 6)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -130, 1, -50)
contentFrame.Position = UDim2.new(0, 130, 0, 45)
contentFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", contentFrame)

-- Tab Buttons
local pages = {}
local buttons = {
    {"🥚 Hatch", "Hatch"},
    {"📦 Chest", "Chest"},
    {"📊 Status", "Status"}
}

for i, btn in ipairs(buttons) do
    local b = Instance.new("TextButton", tabFrame)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Position = UDim2.new(0, 0, 0, (i-1)*45)
    b.Text = btn[1]
    b.Name = btn[2].."Button"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", b)

    local page = Instance.new("Frame", contentFrame)
    page.Visible = false
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    pages[btn[2]] = page

    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(pages) do pg.Visible = false end
        for _, bb in pairs(tabFrame:GetChildren()) do
            if bb:IsA("TextButton") then
                bb.BackgroundColor3 = Color3.fromRGB(45,45,45)
            end
        end
        b.BackgroundColor3 = Color3.fromRGB(80,80,80)
        page.Visible = true
    end)
end

pages.Hatch.Visible = true

-- Helper: Create Toggle
local function makeToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        local on = btn.Text:find("OFF")
        btn.Text = text .. (on and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = on and Color3.fromRGB(80,140,80) or Color3.fromRGB(60,60,60)
        callback(on)
    end)
    Instance.new("UICorner", btn)
    return btn
end

-- ===============================================================
-- 🥚 HATCH TAB
-- ===============================================================
makeToggle(pages.Hatch, "Auto Hatch", function(state)
    State.HatchRunning = state
end).Position = UDim2.new(0, 20, 0, 20)

makeToggle(pages.Hatch, "ปิด Hatch Animation", function(state)
    local effects = game:GetService("ReplicatedStorage"):FindFirstChild("Client")
    if effects and effects:FindFirstChild("Effects") then
        local hatch = effects.Effects:FindFirstChild("HatchEgg")
        if state then
            if hatch then
                hatch:Destroy()
                print("[NiTROHUB] 🧩 Hatch animation disabled.")
            end
        else
            print("[NiTROHUB] 🌀 Toggle OFF (animation not restored).")
        end
    end
end).Position = UDim2.new(0, 20, 0, 70)

-- ===============================================================
-- 📦 CHEST TAB
-- ===============================================================
makeToggle(pages.Chest, "Auto Chest", function(state)
    State.ChestRunning = state
end).Position = UDim2.new(0, 20, 0, 20)

-- ===============================================================
-- 📊 STATUS TAB
-- ===============================================================
local info = Instance.new("TextLabel", pages.Status)
info.Size = UDim2.new(1, -20, 1, -20)
info.Position = UDim2.new(0, 10, 0, 10)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(255,255,255)
info.Font = Enum.Font.Gotham
info.TextSize = 16
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Text = ""

task.spawn(function()
    while task.wait(1) do
        info.Text = string.format("📌 สถานะ: %s\n🥚 Eggs Hatched: %s\n📦 Chests Collected: %s\n🎁 Last Chest: %s",
            State.Status, State.EggsHatched, State.ChestsCollected, State.LastChest)
    end
end)

-- ===============================================================
-- 🧠 BACKGROUND TASKS
-- ===============================================================
task.spawn(function()
    repeat task.wait(1) until pages.Hatch
    while task.wait() do
        if State.HatchRunning and frameworkRemote then
            State.Status = "Hatching..."
            local success, err = pcall(function()
                frameworkRemote:FireServer("HatchEgg", Config.EggName, Config.HatchAmount)
                State.EggsHatched += Config.HatchAmount
            end)
            if not success then warn("[NiTROHUB] Hatch Error:", err) end
            task.wait(Config.HatchDelay)
        end
    end
end)

task.spawn(function()
    repeat task.wait(1) until pages.Chest
    local CHEST_LIST = {}
    for _, name in ipairs(Config.ChestNames) do CHEST_LIST[name:lower()] = true end
    local lastCollected = {}
    while task.wait(Config.ChestCheckInterval) do
        if State.ChestRunning then
            State.Status = "Collecting Chests..."
            for _, area in ipairs({Workspace:FindFirstChild("Chests"), Workspace:FindFirstChild("Areas"), Workspace}) do
                if area then
                    for _, obj in ipairs(area:GetDescendants()) do
                        if obj:IsA("Model") and CHEST_LIST[obj.Name:lower()] then
                            local key = obj:GetDebugId()
                            if not lastCollected[key] or tick() - lastCollected[key] > Config.ChestCollectCooldown then
                                pcall(function()
                                    frameworkRemote:FireServer("ClaimChest", obj.Name, true)
                                    State.ChestsCollected += 1
                                    State.LastChest = obj.Name
                                    lastCollected[key] = tick()
                                    print("[NiTROHUB] 🎁 Collected:", obj.Name)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("[NiTROHUB] ✅ Final Version Loaded Successfully!")
