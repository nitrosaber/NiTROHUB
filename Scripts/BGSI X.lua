-- Load Library
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/Uisource.lua"))()

-- Main Window
NatUI:Window({
    Title = "Bubble Gum Hub",
    Description = "Auto Hatch & Farm",
    Icon = "rbxassetid://3926305904"
})

-- Toggle UI button
NatUI:OpenUI({
    Title = "Open / Close Hub",
    Icon = "rbxassetid://3926305904",
    BackgroundColor = "fromrgb",
    BorderColor = "fromrgb"
})

-- Create Tab
NatUI:AddTab({
    Title = "Auto Farm",
    Desc = "Main Farming Features",
    Icon = "rbxassetid://3926305904"
})

-- Section
NatUI:Section({
    Title = "Egg Features",
    Icon = "rbxassetid://3926305904"
})

-- Toggle : Auto Hatch Egg
NatUI:Toggle({
    Title = "Auto Hatch Egg (Autumn Egg x3)",
    Callback = function(state)
        getgenv().AutoHatch = state
        while getgenv().AutoHatch do
            local args = {
                "HatchEgg",
                "Autumn Egg", -- Egg name (can be changed)
                3 -- hatch amount (1 / 3 / 9)
            }
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))
            task.wait(1)
        end
    end,
})

-- Button : Collect All Chests
NatUI:Button({
    Title = "Collect All Chests",
    Callback = function()
        print("Collecting all chests (Demo)")
        -- If chest RemoteEvent exists, add FireServer code here
    end,
})

-- Section for Settings
NatUI:Section({
    Title = "Settings",
    Icon = "rbxassetid://3926305904"
})

-- Paragraph
NatUI:Paragraph({
    Title = "How to Use",
    Desc = "1. Enable Auto Hatch to hatch eggs automatically\n2. Press Collect Chests to collect all available chests"
})

-- Slider : Walk Speed
NatUI:Slider({
    Title = "Walk Speed",
    MaxValue = "200",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(value)
    end,
})

-- Toggle : Notifications
NatUI:Toggle({
    Title = "Enable Notifications",
    Callback = function(state)
        if state then
            print("Notifications Enabled")
        else
            print("Notifications Disabled")
        end
    end,
})
