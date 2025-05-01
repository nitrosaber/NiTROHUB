-- Load Rayfield Library
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Failed to load Rayfield Library. Please check the URL or your internet connection.")
    return
end
print("Rayfield Library loaded successfully.")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
local Framework = Shared and Shared:WaitForChild("Framework", 10)
local Network = Framework and Framework:WaitForChild("Network", 10)
local Remote = Network and Network:WaitForChild("Remote", 10)

-- Validate remote objects
local RemoteEvent = Remote and Remote:FindFirstChild("Event")
local RemoteFunction = Remote and Remote:FindFirstChild("Function")

-- Exit if critical services are missing
if not (Shared and Framework and Network and Remote and RemoteEvent and RemoteFunction) then
    warn("Failed to initialize: Critical services or remotes not found.")
    return
end
print("All critical services successfully loaded.")

-- Flags to control loops
local BlowBubbleEnabled = false
local UnlockRiftChestEnabled = false
local MainLoopEnabled = false
local AutoHatchEggEnabled = false

-- Variables for user selections
local SelectedEgg = "Common Egg" -- Default selected egg
local SelectedQuantity = 3 -- Default quantity

-- Task references for loop cancellation
local BlowBubbleTask, UnlockRiftChestTask, MainLoopTask, AutoHatchEggTask

-- Function to safely start tasks
local function StartTask(ref, taskFunc)
    if ref then return end
    return task.spawn(taskFunc)
end

-- Function to safely stop tasks
local function StopTask(ref)
    if ref then
        task.cancel(ref)
        ref = nil
    end
    return ref
end

-- BlowBubble Loop
local function StartBlowBubbleLoop()
    BlowBubbleTask = StartTask(BlowBubbleTask, function()
        while BlowBubbleEnabled do
            pcall(function()
                RemoteEvent:FireServer("BlowBubble")
            end)
            task.wait(0.6)
        end
        BlowBubbleTask = nil
    end)
end

-- UnlockRiftChest Loop
local function StartUnlockRiftChestLoop()
    UnlockRiftChestTask = StartTask(UnlockRiftChestTask, function()
        while UnlockRiftChestEnabled do
            pcall(function()
                RemoteEvent:FireServer("UnlockRiftChest", "royal-chest", "golden-chest", false)
            end)
            task.wait(1)
        end
        UnlockRiftChestTask = nil
    end)
end

-- Main Loop
local function StartMainLoop()
    MainLoopTask = StartTask(MainLoopTask, function()
        while MainLoopEnabled do
            pcall(function()
                RemoteEvent:FireServer("ClaimFreeWheelSpin")
            end)

            for i = 1, 9 do
                if not MainLoopEnabled then break end
                pcall(function()
                    RemoteFunction:InvokeServer("ClaimPlaytime", i)
                end)
                task.wait(3.5)
            end

            pcall(function()
                RemoteEvent:FireServer("ClaimChest", "Void Chest", "Giant Chest", true)
            end)
            task.wait(1.5)
        end
        MainLoopTask = nil
    end)
end

-- Auto Hatch Egg Loop
local function StartAutoHatchEggLoop()
    AutoHatchEggTask = StartTask(AutoHatchEggTask, function()
        while AutoHatchEggEnabled do
            pcall(function()
                -- Use the selected egg and quantity from user input
                RemoteEvent:FireServer("HatchEgg", SelectedEgg, SelectedQuantity)
            end)
            task.wait(0.1) -- Adjust the delay as needed
        end
        AutoHatchEggTask = nil
    end)
end

-- Stop Functions
local function StopBlowBubbleLoop() BlowBubbleTask = StopTask(BlowBubbleTask) end
local function StopUnlockRiftChestLoop() UnlockRiftChestTask = StopTask(UnlockRiftChestTask) end
local function StopMainLoop() MainLoopTask = StopTask(MainLoopTask) end
local function StopAutoHatchEggLoop() AutoHatchEggTask = StopTask(AutoHatchEggTask) end

-- Create Rayfield UI
local Window = Rayfield:CreateWindow({
    Name = "BGSI FARM",
    LoadingTitle = "Loading BGSI Scripts",
    LoadingSubtitle = "by NiTroHub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "Script-BGSI-Settings"
    }
})

if not Window then
    warn("Failed to create Rayfield Window")
    return
end
print("Rayfield Window created successfully.")

-- Controls Tab
local ControlsTab = Window:CreateTab("Controls")
if not ControlsTab then
    warn("Failed to create Controls Tab")
else
    print("Controls Tab created successfully!")
end

-- Toggles
ControlsTab:CreateToggle({
    Name = "Blow Bubble",
    CurrentValue = false,
    Flag = "BlowBubbleToggle",
    Callback = function(Value)
        BlowBubbleEnabled = Value
        if Value then StartBlowBubbleLoop() else StopBlowBubbleLoop() end
    end
})

ControlsTab:CreateToggle({
    Name = "Unlock Golden Chest",
    CurrentValue = false,
    Flag = "UnlockRiftChestToggle",
    Callback = function(Value)
        UnlockRiftChestEnabled = Value
        if Value then StartUnlockRiftChestLoop() else StopUnlockRiftChestLoop() end
    end
})

ControlsTab:CreateToggle({
    Name = "Main Loop (Spin, Playtime, Chests)",
    CurrentValue = false,
    Flag = "MainLoopToggle",
    Callback = function(Value)
        MainLoopEnabled = Value
        if Value then StartMainLoop() else StopMainLoop() end
    end
})

ControlsTab:CreateToggle({
    Name = "Fast Hatch Egg",
    CurrentValue = false,
    Flag = "AutoHatchEggToggle",
    Callback = function(Value)
        AutoHatchEggEnabled = Value
        if Value then StartAutoHatchEggLoop() else StopAutoHatchEggLoop() end
    end
})

-- Dropdown for Egg Selection
ControlsTab:CreateDropdown({
    Name = "Select Egg to Hatch",
    Options = {
        "Common Egg", "Spotted Egg", "Iceshard Egg", "Spikey Egg", "Magma Egg",
        "Crystal Egg", "Lunar Egg", "Void Egg", "Hell Egg", "Nightmare Egg",
        "Rainbow Egg", "Infinity Egg", "100M Egg"
    },
    CurrentOption = "Common Egg",
    Flag = "EggDropdown",
    Callback = function(Value)
        SelectedEgg = Value
        print("Selected Egg: " .. SelectedEgg)
    end
})

-- Slider for Egg Quantity
ControlsTab:CreateSlider({
    Name = "Select Quantity (1-6)",
    Range = {1, 6},
    Increment = 1,
    Suffix = " Egg(s)",
    CurrentValue = 3,
    Flag = "EggQuantitySlider",
    Callback = function(Value)
        SelectedQuantity = Value
        print("Selected Quantity: " .. SelectedQuantity)
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings")
if not SettingsTab then
    warn("Failed to create Settings Tab")
else
    print("Settings Tab created successfully!")
end

-- Destroy UI Button
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        StopBlowBubbleLoop()
        StopUnlockRiftChestLoop()
        StopMainLoop()
        StopAutoHatchEggLoop()
        Rayfield:Destroy()
        print("UI destroyed successfully!")
    end
})
