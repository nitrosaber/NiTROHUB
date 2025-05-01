-- Load Test Library
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/Uisource.lua"))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
local Framework = Shared and Shared:WaitForChild("Framework", 10)
local Network = Framework and Framework:WaitForChild("Network", 10)
local Remote = Network and Network:WaitForChild("Remote", 10)

local RemoteEvent = Remote and Remote:FindFirstChild("Event")
local RemoteFunction = Remote and Remote:FindFirstChild("Function")

--- Create Window
NatUI:Window({
	Title = "NiTro Hub",
	Description = "made by 2o3b.",
	Icon = "rbxassetid://6035019070"
	ConfigurationSaving = {
        Enabled = true,
        FolderName = "NiTroHub",
        FileName = "Script-BGSI-Settings"
    }
})

--- Open Toggle UI
NatUI:Farm = OpenUI({
	Title = "Main",
	Icon = "rbxasset",
	BackgroundColor = "fromrgb",
	BorderColor = "fromrgb"
})


--- Open Toggle UI
NatUI:Farm = OpenUI({
	Title = "Farm",
	Icon = "rbxasset",
	BackgroundColor = "fromrgb",
	BorderColor = "fromrgb"
})

--- Section
NatUI:Farm = Section({
	Title = "Bubble",
	Icon = "rbxasset"
})

