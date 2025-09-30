-- Load the NatHub UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- Create the main window
local Window = Library:CreateWindow("Bubble Gum Hub")
Window:load()

-- Add a tab (library uses AddTab method)
local FarmTab = Window:AddTab("Auto Farm", "Main Farming", "rbxassetid://3926305904")

-- Section for egg operations
FarmTab:Section({
    Title = "Egg Controls",
    Icon = "rbxassetid://3926305904"
})

-- Toggle for auto hatch
FarmTab:Toggle({
    Title = "Auto Hatch Egg",
    Description = "Automatically hatch Autumn Egg x3",
    Flag = "AutoHatch",
    Callback = function(state)
        getgenv().AutoHatch = state
        while getgenv().AutoHatch do
            local args = {
                "HatchEgg",
                getgenv().EggName or "Autumn Egg",
                3
            }
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))
            task.wait(1)
        end
    end
})

-- Button to collect chests
FarmTab:Button({
    Title = "Collect All Chests",
    Callback = function()
        print("Collecting all chests (demo)")
        -- Insert the proper FireServer for chests if you know it
    end
})

-- Section for settings
FarmTab:Section({
    Title = "Settings",
    Icon = "rbxassetid://3926305904"
})

-- Paragraph showing usage instructions
FarmTab:Paragraph({
    Title = "How to Use",
    Description = "1. Toggle Auto Hatch to start auto-hatching\n2. Use Button to collect chests\n3. Set your WalkSpeed with slider"
})

-- Slider for walk speed
FarmTab:Slider({
    Title = "Walk Speed",
    Min = 16,
    Max = 200,
    Flag = "WalkSpeed",
    Callback = function(value)
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = value
            end
        end
    end
})

-- Toggle for notifications (just prints)
FarmTab:Toggle({
    Title = "Enable Notifications",
    Description = "Show demo notifications",
    Flag = "Notifications",
    Callback = function(state)
        if state then
            Library.SendNotification({
                Title = "Notification",
                text = "Notifications Enabled",
                duration = 3
            })
        else
            print("Notifications Disabled")
        end
    end
})

-- Input box to set which egg to hatch
FarmTab:Input({
    Title = "Egg Name",
    Placeholder = "e.g. Autumn Egg",
    Flag = "EggName",
    Callback = function(text)
        print("Egg set to:", text)
        getgenv().EggName = text
    end
})

-- Final notification when UI is ready
Library.SendNotification({
    Title = "Bubble Gum Hub Loaded",
    text = "UI is ready!",
    duration = 5
})
