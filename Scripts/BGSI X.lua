-- Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- Main Window
local Window = Library:CreateWindow("Bubble Gum Hub")
Window:load()

-- Auto Farm Tab
local FarmTab = Window:CreateTab({
    Title = "Auto Farm",
    Description = "Main Farming Features",
    Icon = "rbxassetid://3926305904"
})

-- Toggle : Auto Hatch
FarmTab:Toggle({
    Title = "Auto Hatch Egg",
    Description = "Automatically hatch Autumn Egg (x3)",
    Flag = "AutoHatch",
    Callback = function(state)
        getgenv().AutoHatch = state
        while getgenv().AutoHatch do
            local args = {
                "HatchEgg",
                "Autumn Egg", -- Change egg name if needed
                3 -- Hatch amount (1 / 3 / 9)
            }
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))
            task.wait(1) -- Wait 1 second between hatches
        end
    end
})

-- Button : Collect All Chests
FarmTab:Button({
    Title = "Collect All Chests",
    Callback = function()
        print("Collecting all chests (Demo)")
        -- Insert RemoteEvent FireServer for chests here if available
    end
})

-- Checkbox : Notifications
FarmTab:Checkbox({
    Title = "Enable Notifications",
    Flag = "Notify",
    Callback = function(state)
        if state then
            Library.SendNotification({
                Title = "Notification",
                text = "Notifications enabled",
                duration = 3
            })
        else
            print("Notifications disabled")
        end
    end
})

-- Paragraph : Instructions
FarmTab:Paragraph({
    Title = "How to Use",
    Description = "Press Auto Hatch to start auto hatching\nPress Collect Chests to collect all available chests"
})

-- Slider : Walk Speed
FarmTab:Slider({
    Title = "Walk Speed",
    Min = 16,
    Max = 200,
    Flag = "WalkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Divider
FarmTab:Divider("Other Settings")

-- Text : Status
FarmTab:Text({
    Title = "Status",
    Description = "Ready to work"
})

-- Input : Custom Egg Name
FarmTab:Input({
    Title = "Egg Name",
    Placeholder = "Enter egg name here, e.g. Autumn Egg",
    Flag = "EggName",
    Callback = function(text)
        print("You set egg name to:", text)
        getgenv().EggName = text
    end
})

-- Notification when loaded
Library.SendNotification({
    Title = "Bubble Gum Hub Loaded",
    text = "System is ready!",
    duration = 5
})
