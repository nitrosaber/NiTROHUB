_G.WS = "23";
				local Humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid;
				Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
				Humanoid.WalkSpeed = _G.WS;
				end)
				Humanoid.WalkSpeed = _G.WS;

local UserInputService = game:GetService("UserInputService")
local localPlayer = game.Players.LocalPlayer
local character
local humanoid
 
local canDoubleJump = false
local hasDoubleJumped = false
local oldPower
local TIME_BETWEEN_JUMPS = 0.2
local DOUBLE_JUMP_POWER_MULTIPLIER = 2
 
function onJumpRequest()
    if not character or not humanoid or not character:IsDescendantOf(workspace) or
     humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end
 
    if canDoubleJump and not hasDoubleJumped then
        hasDoubleJumped = true
        humanoid.JumpPower = oldPower * DOUBLE_JUMP_POWER_MULTIPLIER
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end
 
local function characterAdded(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    hasDoubleJumped = false
    canDoubleJump = false
    oldPower = humanoid.JumpPower
 
    humanoid.StateChanged:connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            canDoubleJump = false
            hasDoubleJumped = false
            humanoid.JumpPower = oldPower
        elseif new == Enum.HumanoidStateType.Freefall then
            wait(TIME_BETWEEN_JUMPS)
            canDoubleJump = true
        end
    end)
end
 
if localPlayer.Character then
    characterAdded(localPlayer.Character)
end
 
localPlayer.CharacterAdded:connect(characterAdded)
UserInputService.JumpRequest:connect(onJumpRequest)

local jump = 120 -- Add the amount of jump power you want here!
 
spawn(function()
while wait() do
game.Players.LocalPlayer.Character.Humanoid.JumpPower = jump
end
end)

local ScreenGui = Instance.new("ScreenGui")
local MenuFrame = Instance.new("Frame")
local MenuTitlebar = Instance.new("Frame")
local TitleMenu = Instance.new("TextLabel")
local Utilities = Instance.new("TextButton")
local AutoSetup = Instance.new("TextButton")
local HideMenu = Instance.new("TextButton")
local OreBoost = Instance.new("TextButton")
local Util = Instance.new("Frame")
local UtilitiesTitlebar = Instance.new("Frame")
local BackMenuU = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local AutoRebirth = Instance.new("TextButton")
local GrabCrates = Instance.new("TextButton")
local GrabMM = Instance.new("TextButton")
local TTokens = Instance.new("TextButton")
local CTokens = Instance.new("TextButton")
local MSpeed = Instance.new("TextButton")
local JPower = Instance.new("TextButton")
local RemoteOn = Instance.new("TextButton")
local RemoteOff = Instance.new("TextButton")
local OBoost = Instance.new("Frame")
local BoostTitlebar = Instance.new("Frame")
local BackMenuB = Instance.new("TextButton")
local AutoLayout = Instance.new("TextButton")
local OreBoost_2 = Instance.new("TextButton")
local TextLabel_2 = Instance.new("TextLabel")
local TextBox = Instance.new("TextBox")
local OpenMenu = Instance.new("TextButton")
local ASetup = Instance.new("Frame")
local SetupTitlebar = Instance.new("Frame")
local BackMenuS = Instance.new("TextButton")
local CatalyzedStar = Instance.new("TextButton")
local NeutronStar = Instance.new("TextButton")
local MorningStar = Instance.new("TextButton")
local TextLabel_3 = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = ScreenGui
MenuFrame.BackgroundColor3 = Color3.new(1, 1, 1)
MenuFrame.BorderSizePixel = 0
MenuFrame.Position = UDim2.new(0.85852313, 0, 0.180689663, 0)
MenuFrame.Size = UDim2.new(0, 202, 0, 239)
MenuFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
MenuFrame.Style = Enum.FrameStyle.RobloxSquare
MenuFrame.Visible = false

MenuTitlebar.Name = "MenuTitlebar"
MenuTitlebar.Parent = MenuFrame
MenuTitlebar.BackgroundColor3 = Color3.new(1, 1, 1)
MenuTitlebar.Position = UDim2.new(-0.0420792066, 0, -0.0334728025, 0)
MenuTitlebar.Size = UDim2.new(0, 201, 0, 51)
MenuTitlebar.Style = Enum.FrameStyle.RobloxSquare

TitleMenu.Name = "TitleMenu"
TitleMenu.Parent = MenuFrame
TitleMenu.BackgroundColor3 = Color3.new(1, 1, 1)
TitleMenu.BackgroundTransparency = 1
TitleMenu.Position = UDim2.new(-0.0396039598, 0, -0.0292887036, 0)
TitleMenu.Size = UDim2.new(0, 202, 0, 51)
TitleMenu.Font = Enum.Font.SourceSans
TitleMenu.Text = "Masters Collection Menu"
TitleMenu.TextColor3 = Color3.new(1, 1, 1)
TitleMenu.TextSize = 20

Utilities.Name = "Utilities"
Utilities.Parent = MenuFrame
Utilities.BackgroundColor3 = Color3.new(1, 1, 1)
Utilities.Position = UDim2.new(0.0990099013, 0, 0.252595186, 0)
Utilities.Size = UDim2.new(0, 148, 0, 37)
Utilities.Style = Enum.ButtonStyle.RobloxRoundButton
Utilities.Font = Enum.Font.SourceSans
Utilities.Text = "Utilities"
Utilities.TextSize = 14
Utilities.MouseButton1Click:connect(function()
MenuFrame.Visible = false
Util.Visible = true
end)

AutoSetup.Name = "AutoSetup"
AutoSetup.Parent = MenuFrame
AutoSetup.BackgroundColor3 = Color3.new(1, 1, 1)
AutoSetup.Position = UDim2.new(0.0990099013, 0, 0.465043187, 0)
AutoSetup.Size = UDim2.new(0, 148, 0, 37)
AutoSetup.Style = Enum.ButtonStyle.RobloxRoundButton
AutoSetup.Font = Enum.Font.SourceSans
AutoSetup.Text = "Auto Setup"
AutoSetup.TextSize = 14
AutoSetup.MouseButton1Click:connect(function()
MenuFrame.Visible = false
ASetup.Visible = true
end)

HideMenu.Name = "HideMenu"
HideMenu.Parent = MenuFrame
HideMenu.BackgroundColor3 = Color3.new(1, 1, 1)
HideMenu.BackgroundTransparency = 1
HideMenu.Position = UDim2.new(0.742574275, 0, 0.927824259, 0)
HideMenu.Size = UDim2.new(0, 69, 0, 17)
HideMenu.Font = Enum.Font.SourceSans
HideMenu.Text = "Hide"
HideMenu.TextColor3 = Color3.new(1, 1, 1)
HideMenu.TextSize = 14
HideMenu.MouseButton1Click:connect(function()
MenuFrame.Visible = false
OpenMenu.Visible = true
end)

OreBoost.Name = "OreBoost"
OreBoost.Parent = MenuFrame
OreBoost.BackgroundColor3 = Color3.new(1, 1, 1)
OreBoost.Position = UDim2.new(0.0990099013, 0, 0.670064151, 0)
OreBoost.Size = UDim2.new(0, 148, 0, 37)
OreBoost.Style = Enum.ButtonStyle.RobloxRoundButton
OreBoost.Font = Enum.Font.SourceSans
OreBoost.Text = "Ore Booster"
OreBoost.TextSize = 14
OreBoost.MouseButton1Click:connect(function()
MenuFrame.Visible = false
OBoost.Visible = true
end)

Util.Name = "Util"
Util.Parent = ScreenGui
Util.BackgroundColor3 = Color3.new(1, 1, 1)
Util.Position = UDim2.new(0.857142806, 0, 0.183448285, 0)
Util.Size = UDim2.new(0, 202, 0, 239)
Util.Visible = false
Util.Style = Enum.FrameStyle.RobloxSquare

UtilitiesTitlebar.Name = "UtilitiesTitlebar"
UtilitiesTitlebar.Parent = Util
UtilitiesTitlebar.BackgroundColor3 = Color3.new(1, 1, 1)
UtilitiesTitlebar.Position = UDim2.new(-0.0445544571, 0, -0.0376569033, 0)
UtilitiesTitlebar.Size = UDim2.new(0, 201, 0, 51)
UtilitiesTitlebar.Style = Enum.FrameStyle.RobloxSquare

BackMenuU.Name = "BackMenuU"
BackMenuU.Parent = Util
BackMenuU.BackgroundColor3 = Color3.new(1, 1, 1)
BackMenuU.BackgroundTransparency = 1
BackMenuU.Position = UDim2.new(0.742574275, 0, 0.927824259, 0)
BackMenuU.Size = UDim2.new(0, 69, 0, 17)
BackMenuU.Font = Enum.Font.SourceSans
BackMenuU.Text = "Back"
BackMenuU.TextColor3 = Color3.new(1, 1, 1)
BackMenuU.TextSize = 14
BackMenuU.MouseButton1Click:connect(function()
Util.Visible = false
MenuFrame.Visible = true
end)

TextLabel.Parent = Util
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(-0.0396039598, 0, -0.0251046028, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Utilities"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 24

AutoRebirth.Name = "AutoRebirth"
AutoRebirth.Parent = Util
AutoRebirth.BackgroundColor3 = Color3.new(1, 1, 1)
AutoRebirth.Position = UDim2.new(0.0148514882, 0, 0.22594142, 0)
AutoRebirth.Size = UDim2.new(0, 83, 0, 23)
AutoRebirth.Style = Enum.ButtonStyle.RobloxRoundButton
AutoRebirth.Font = Enum.Font.SourceSans
AutoRebirth.Text = "Auto Rebirth"
AutoRebirth.TextSize = 14
AutoRebirth.MouseButton1Click:connect(function()
while true do
game.ReplicatedStorage.Rebirth:InvokeServer()
wait(0.1)
end
end)

GrabCrates.Name = "GrabCrates"
GrabCrates.Parent = Util
GrabCrates.BackgroundColor3 = Color3.new(1, 1, 1)
GrabCrates.Position = UDim2.new(0.544554472, 0, 0.22594142, 0)
GrabCrates.Size = UDim2.new(0, 83, 0, 23)
GrabCrates.Style = Enum.ButtonStyle.RobloxRoundButton
GrabCrates.Font = Enum.Font.SourceSans
GrabCrates.Text = "GrabCrates"
GrabCrates.TextSize = 14
GrabCrates.MouseButton1Click:connect(function()
while wait() do
while wait(2) do
for _,v in pairs(game.Workspace:GetChildren()) do
if string.match(v.Name, "DiamondCrate") or string.match(v.Name, "ResearchCrate") or string.match(v.Name, "GoldenCrate") or string.match(v.Name, "CrystalCrate") or string.match(v.Name, "Pumpkin") or string.match(v.Name, "MegaPumpkin") or string.match(v.Name, "Pumpkin") or string.match(v.Name, "LuckyCrate") or string.match(v.Name, "ExecutiveCrate") or string.match(v.Name, "GiftCrate") or string.match(v.Name, "ShadowCrate")then
v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,0,0)
v.CanCollide = false
v.Transparency = 1
for _,v in pairs(game.Workspace.Shadows:GetChildren()) do
if string.match(v.Name, "ShadowCrate") or string.match(v.Name, "MegaPumpkin") then
v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,0,0)
v.CanCollide = false
v.Transparency = 1
end
end
end
end
end
end
end)

GrabMM.Name = "GrabMM"
GrabMM.Parent = Util
GrabMM.BackgroundColor3 = Color3.new(1, 1, 1)
GrabMM.Position = UDim2.new(0.0198019929, 0, 0.364016712, 0)
GrabMM.Size = UDim2.new(0, 83, 0, 23)
GrabMM.Style = Enum.ButtonStyle.RobloxRoundButton
GrabMM.Font = Enum.Font.SourceSans
GrabMM.Text = "Grab MM"
GrabMM.TextSize = 14
GrabMM.MouseButton1Click:connect(function()
thing = game.Workspace.Market.Hitfox
thing.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(math.random(0,0),0,math.random(0,0))
thing.Transparency = 0
thing.BrickColor = BrickColor.new(255,0,100)
tell = Instance.new("SurfaceGui",thing)
tell2 = Instance.new("TextLabel",tell)
tell2.Size = UDim2.new(0, 800, 0, 750)
tell2.TextWrapped= true
tell2.TextScaled = true
tell2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tell2.TextColor3 = Color3.fromRGB(255, 255, 255)
tell2.Text =  "Click Me!" 
end)

TTokens.Name = "TTokens"
TTokens.Parent = Util
TTokens.BackgroundColor3 = Color3.new(1, 1, 1)
TTokens.Position = UDim2.new(0.544554472, 0, 0.364016712, 0)
TTokens.Size = UDim2.new(0, 83, 0, 23)
TTokens.Style = Enum.ButtonStyle.RobloxRoundButton
TTokens.Font = Enum.Font.SourceSans
TTokens.Text = "Twitch Tokens"
TTokens.TextSize = 14
TTokens.MouseButton1Click:connect(function()
while wait() do
while wait(1) do
game.Players.LocalPlayer.TwitchPoints.Value = game.Players.LocalPlayer.TwitchPoints.Value +50
end
end
end)

CTokens.Name = "CTokens"
CTokens.Parent = Util
CTokens.BackgroundColor3 = Color3.new(1, 1, 1)
CTokens.Position = UDim2.new(0.0198019929, 0, 0.497907937, 0)
CTokens.Size = UDim2.new(0, 83, 0, 23)
CTokens.Style = Enum.ButtonStyle.RobloxRoundButton
CTokens.Font = Enum.Font.SourceSans
CTokens.Text = "Clover Tokens"
CTokens.TextSize = 14
CTokens.MouseButton1Click:connect(function()
while wait() do
while wait(1) do
game.Players.LocalPlayer.Clovers.Value = game.Players.LocalPlayer.Clovers.Value +100
end
end
end)

MSpeed.Name = "MSpeed"
MSpeed.Parent = Util
MSpeed.BackgroundColor3 = Color3.new(1, 1, 1)
MSpeed.Position = UDim2.new(0.544554472, 0, 0.497907937, 0)
MSpeed.Size = UDim2.new(0, 83, 0, 23)
MSpeed.Style = Enum.ButtonStyle.RobloxRoundButton
MSpeed.Font = Enum.Font.SourceSans
MSpeed.Text = "Walk Speed"
MSpeed.TextSize = 14
MSpeed.MouseButton1Click:connect(function()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 80
end)

JPower.Name = "JPower"
JPower.Parent = Util
JPower.BackgroundColor3 = Color3.new(1, 1, 1)
JPower.Position = UDim2.new(0.0198019929, 0, 0.631799161, 0)
JPower.Size = UDim2.new(0, 83, 0, 23)
JPower.Style = Enum.ButtonStyle.RobloxRoundButton
JPower.Font = Enum.Font.SourceSans
JPower.Text = "Jump Power"
JPower.TextSize = 14
JPower.MouseButton1Click:connect(function()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 180
end)

RemoteOn.Name = "RemoteOn"
RemoteOn.Parent = Util
RemoteOn.BackgroundColor3 = Color3.new(1, 1, 1)
RemoteOn.Position = UDim2.new(0.544554472, 0, 0.631799161, 0)
RemoteOn.Size = UDim2.new(0, 83, 0, 23)
RemoteOn.Style = Enum.ButtonStyle.RobloxRoundButton
RemoteOn.Font = Enum.Font.SourceSans
RemoteOn.Text = "Remote On"
RemoteOn.TextSize = 14
RemoteOn.MouseButton1Click:connect(function()
x = 1;
while(x>0) do
wait (0.3)
game.ReplicatedStorage.RemoteDrop:FireServer()
end
end)

RemoteOff.Name = "RemoteOff"
RemoteOff.Parent = Util
RemoteOff.BackgroundColor3 = Color3.new(1, 1, 1)
RemoteOff.Position = UDim2.new(0.544554472, 0, 0.753138065, 0)
RemoteOff.Size = UDim2.new(0, 83, 0, 23)
RemoteOff.Style = Enum.ButtonStyle.RobloxRoundButton
RemoteOff.Font = Enum.Font.SourceSans
RemoteOff.Text = "Remote Off"
RemoteOff.TextSize = 14
RemoteOff.MouseButton1Click:connect(function()
x = 0;
end)

OBoost.Name = "OBoost"
OBoost.Parent = ScreenGui
OBoost.BackgroundColor3 = Color3.new(1, 1, 1)
OBoost.Position = UDim2.new(0.856797814, 0, 0.180689663, 0)
OBoost.Size = UDim2.new(0, 202, 0, 239)
OBoost.Visible = false
OBoost.Style = Enum.FrameStyle.RobloxSquare

BoostTitlebar.Name = "BoostTitlebar"
BoostTitlebar.Parent = OBoost
BoostTitlebar.BackgroundColor3 = Color3.new(1, 1, 1)
BoostTitlebar.Position = UDim2.new(-0.0445544571, 0, -0.0376569033, 0)
BoostTitlebar.Size = UDim2.new(0, 201, 0, 51)
BoostTitlebar.Style = Enum.FrameStyle.RobloxSquare

BackMenuB.Name = "BackMenuB"
BackMenuB.Parent = OBoost
BackMenuB.BackgroundColor3 = Color3.new(1, 1, 1)
BackMenuB.BackgroundTransparency = 1
BackMenuB.Position = UDim2.new(0.742574275, 0, 0.927824259, 0)
BackMenuB.Size = UDim2.new(0, 69, 0, 17)
BackMenuB.Font = Enum.Font.SourceSans
BackMenuB.Text = "Back"
BackMenuB.TextColor3 = Color3.new(1, 1, 1)
BackMenuB.TextSize = 14
BackMenuB.MouseButton1Click:connect(function()
OBoost.Visible = false
MenuFrame.Visible = true
end)

AutoLayout.Name = "AutoLayout"
AutoLayout.Parent = OBoost
AutoLayout.BackgroundColor3 = Color3.new(1, 1, 1)
AutoLayout.Position = UDim2.new(0.103960395, 0, 0.684708416, 0)
AutoLayout.Size = UDim2.new(0, 148, 0, 37)
AutoLayout.Style = Enum.ButtonStyle.RobloxRoundButton
AutoLayout.Font = Enum.Font.SourceSans
AutoLayout.Text = "Auto Load Layout 1: OFF"
AutoLayout.TextSize = 14

local autoload1 = false
AutoLayout.MouseButton1Click:connect(function()
if autoload1 == false then
autoload1 = true
AutoLayout.Text = "Auto Load Layout 1: ON"
else
autoload1 = false
AutoLayout.Text = "Auto Load Layout 1: OFF"
end
end)

spawn(function()
while true do
wait()
if autoload1 == true then
game.Players.LocalPlayer.PlayerGui.GUI.Menu.Menu.Sounds.Message.Volume = 0
game.Players.LocalPlayer.PlayerGui.GUI.Notifications.Visible = false
game.ReplicatedStorage.Layouts:InvokeServer("Load","Layout1")
else
game.Players.LocalPlayer.PlayerGui.GUI.Menu.Menu.Sounds.Message.Volume = 0.5
game.Players.LocalPlayer.PlayerGui.GUI.Notifications.Visible = true
end
end
end)


OreBoost_2.Name = "OreBoost"
OreBoost_2.Parent = OBoost
OreBoost_2.BackgroundColor3 = Color3.new(1, 1, 1)
OreBoost_2.Position = UDim2.new(0.101485148, 0, 0.49318096, 0)
OreBoost_2.Size = UDim2.new(0, 148, 0, 37)
OreBoost_2.Style = Enum.ButtonStyle.RobloxRoundButton
OreBoost_2.Font = Enum.Font.SourceSans
OreBoost_2.Text = "Boost Ore: OFF"
OreBoost_2.TextSize = 14

local boost = false
OreBoost_2.MouseButton1Click:connect(function()
if boost == false then
boost = true
OreBoost_2.Text = "Boost Ore: ON"
else
boost = false
OreBoost_2.Text = "Boost Ore: OFF"
end
end)

spawn(function()
while true do
wait()
if boost == true then
local tyc = workspace.Tycoons:GetChildren()
for i=1,#tyc do
local basepart = tyc[i]:GetChildren()
for i=1,#basepart do
if basepart[i].ClassName == "Model" then
if basepart[i].Model:findFirstChild("Upgrade") then
if basepart[i].Model.Upgrade:findFirstChild("Cloned") then
else
local decoy = basepart[i].Model.Upgrade:Clone()
decoy.Parent = basepart[i].Model
decoy.Name = "UpgradeDecoy"
local tag = Instance.new("StringValue",basepart[i].Model.Upgrade)
tag.Name = "Cloned"
local deco = basepart[i].Model.Upgrade:GetChildren()
for i=1,#deco do
if deco[i].ClassName == "ParticleEmitter" then
deco[i]:remove()
end
if deco[i].Name == "Mesh" then
deco[i]:remove()
end
if deco[i].Name == "Smoke" then
deco[i]:remove()
end
if deco[i].Name == "Fire" then
deco[i]:remove()
end
end
if basepart[i].Model.Upgrade:findFirstChild("Error") then
basepart[i].Model.Upgrade.Error.Volume = 0
end
basepart[i].Model.Upgrade.Transparency = 1
basepart[i].Model.Upgrade.Size = Vector3.new(5,5,5)
basepart[i].Model.Upgrade.CFrame = CFrame.new(workspace.Tycoons[tostring(game.Players.LocalPlayer.PlayerTycoon.Value)][TextBox.Text].Model.Drop.Position)
end
end
end
end
end
end
end
end)

TextLabel_2.Parent = OBoost
TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(-0.0247524753, 0, -0.0292887036, 0)
TextLabel_2.Size = UDim2.new(0, 200, 0, 50)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "Ore Booster"
TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
TextLabel_2.TextSize = 24

TextBox.Parent = OBoost
TextBox.BackgroundColor3 = Color3.new(1, 1, 1)
TextBox.Position = UDim2.new(0.103960402, 0, 0.22594142, 0)
TextBox.Size = UDim2.new(0, 148, 0, 54)
TextBox.Font = Enum.Font.SourceSans
TextBox.Text = "Enter Mine Name, Case Sensitive: E.g. \"Basic Iron Mine\""
TextBox.TextScaled = true
TextBox.TextSize = 14
TextBox.TextWrapped = true

OpenMenu.Name = "OpenMenu"
OpenMenu.Parent = ScreenGui
OpenMenu.BackgroundColor3 = Color3.new(1, 1, 1)
OpenMenu.Position = UDim2.new(0.473775059, 0, 0.79724133, 0)
OpenMenu.Size = UDim2.new(0, 76, 0, 31)
OpenMenu.Style = Enum.ButtonStyle.RobloxRoundButton
OpenMenu.Font = Enum.Font.SourceSans
OpenMenu.Text = "Open"
OpenMenu.TextSize = 14
OpenMenu.MouseButton1Click:connect(function()
MenuFrame.Visible = true
OpenMenu.Visible = false
end)

ASetup.Name = "ASetup"
ASetup.Parent = ScreenGui
ASetup.BackgroundColor3 = Color3.new(1, 1, 1)
ASetup.Position = UDim2.new(0.858078897, 0, 0.182611465, 0)
ASetup.Size = UDim2.new(0, 202, 0, 239)
ASetup.Visible = false
ASetup.Style = Enum.FrameStyle.RobloxSquare

SetupTitlebar.Name = "SetupTitlebar"
SetupTitlebar.Parent = ASetup
SetupTitlebar.BackgroundColor3 = Color3.new(1, 1, 1)
SetupTitlebar.Position = UDim2.new(-0.0445544571, 0, -0.0376569033, 0)
SetupTitlebar.Size = UDim2.new(0, 201, 0, 51)
SetupTitlebar.Style = Enum.FrameStyle.RobloxSquare

BackMenuS.Name = "BackMenuS"
BackMenuS.Parent = ASetup
BackMenuS.BackgroundColor3 = Color3.new(1, 1, 1)
BackMenuS.BackgroundTransparency = 1
BackMenuS.Position = UDim2.new(0.742574275, 0, 0.927824259, 0)
BackMenuS.Size = UDim2.new(0, 69, 0, 17)
BackMenuS.Font = Enum.Font.SourceSans
BackMenuS.Text = "Back"
BackMenuS.TextColor3 = Color3.new(1, 1, 1)
BackMenuS.TextSize = 14
BackMenuS.MouseButton1Click:connect(function()
ASetup.Visible = false
MenuFrame.Visible = true
end)

CatalyzedStar.Name = "CatalyzedStar"
CatalyzedStar.Parent = ASetup
CatalyzedStar.BackgroundColor3 = Color3.new(1, 1, 1)
CatalyzedStar.Position = UDim2.new(0.0990099013, 0, 0.438787639, 0)
CatalyzedStar.Size = UDim2.new(0, 148, 0, 37)
CatalyzedStar.Style = Enum.ButtonStyle.RobloxRoundButton
CatalyzedStar.Font = Enum.Font.SourceSans
CatalyzedStar.Text = "Catalyzed Star"
CatalyzedStar.TextSize = 14
CatalyzedStar.MouseButton1Click:connect(function()
local function A()
wait(0.5)

game.ReplicatedStorage.PlaceItem:InvokeServer("Symmetryte Mine", CFrame.new(-97.5, 206.799988, 194, -2.90066708e-07, 0, -1, 0, 1, 0, 1, 0, -2.90066708e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-97.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-91.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-85.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-79.5, 202.299988, 209, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-79.5, 202.299988, 215, 1.3907092e-07, 0, 1, 0, 1, 0, -1, 0, 1.3907092e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-73.5, 202.299988, 215, -1, 0, -2.38497613e-08, 0, 1, 0, 2.38497613e-08, 0, -1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-73.5, 202.299988, 209, -2.90066708e-07, 0, -1, 0, 1, 0, 1, 0, -2.90066708e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Catalyzed Star", CFrame.new(-43.5, 205.299988, 179, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("The Final Upgrader", CFrame.new(-45, 205.299988, 198.5, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Sakura Garden", CFrame.new(-43.5, 206.799988, 219.5, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))

local player = game:GetService'Players'.LocalPlayer
local factorye = player.PlayerTycoon.Value
local Factory = tostring(factorye)
-- if you'd like to change the upgrader this goes through, go ahead and change it below
thing = game.Workspace.Tycoons[Factory]["Catalyzed Star"].Hitbox

--1200 is the default amount of times this will run, feel free to change it to whatever you want!
for i = 1,1000 do wait(.01) 
for i,v in pairs(game.Workspace.DroppedParts[Factory]:getChildren()) do
    local p= CFrame.new(thing.Position.x, thing.Position.y, thing.Position.z)
v.CFrame = p
end
end
end

A()

spawn(function()
while wait(0.1)do
    game:GetService'ReplicatedStorage'.RemoteDrop:FireServer()
end
end)
spawn(function()
while wait(1)do
    local Ea = game:GetService'ReplicatedStorage'.Rebirth:InvokeServer()
    if Ea == true then
    wait(3)
        A()
    end
end
end)
end)

NeutronStar.Name = "NeutronStar"
NeutronStar.Parent = ASetup
NeutronStar.BackgroundColor3 = Color3.new(1, 1, 1)
NeutronStar.Position = UDim2.new(0.0990099013, 0, 0.634499252, 0)
NeutronStar.Size = UDim2.new(0, 148, 0, 37)
NeutronStar.Style = Enum.ButtonStyle.RobloxRoundButton
NeutronStar.Font = Enum.Font.SourceSans
NeutronStar.Text = "Neutron Star"
NeutronStar.TextSize = 14
NeutronStar.MouseButton1Click:connect(function()
local function A()
wait(0.5)

game.ReplicatedStorage.PlaceItem:InvokeServer("Symmetryte Mine", CFrame.new(-97.5, 206.799988, 194, -2.90066708e-07, 0, -1, 0, 1, 0, 1, 0, -2.90066708e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-97.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-91.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-85.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-79.5, 202.299988, 209, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-79.5, 202.299988, 215, 1.3907092e-07, 0, 1, 0, 1, 0, -1, 0, 1.3907092e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-73.5, 202.299988, 215, -1, 0, -2.38497613e-08, 0, 1, 0, 2.38497613e-08, 0, -1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-73.5, 202.299988, 209, -2.90066708e-07, 0, -1, 0, 1, 0, 1, 0, -2.90066708e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Neutron Star", CFrame.new(-43.5, 206.799988, 182, -1, 0, -2.38497613e-08, 0, 1, 0, 2.38497613e-08, 0, -1))
game.ReplicatedStorage.PlaceItem:InvokeServer("The Final Upgrader", CFrame.new(-45, 205.299988, 198.5, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Sakura Garden", CFrame.new(-43.5, 206.799988, 219.5, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))

local player = game:GetService'Players'.LocalPlayer
local factorye = player.PlayerTycoon.Value
local Factory = tostring(factorye)
-- if you'd like to change the upgrader this goes through, go ahead and change it below
thing = game.Workspace.Tycoons[Factory]["Neutron Star"].Hitbox

--1200 is the default amount of times this will run, feel free to change it to whatever you want!
for i = 1,1000 do wait(.01) 
for i,v in pairs(game.Workspace.DroppedParts[Factory]:getChildren()) do
    local p= CFrame.new(thing.Position.x, thing.Position.y, thing.Position.z)
v.CFrame = p
end
end
end

A()

spawn(function()
while wait(0.1)do
    game:GetService'ReplicatedStorage'.RemoteDrop:FireServer()
end
end)
spawn(function()
while wait(1)do
    local Ea = game:GetService'ReplicatedStorage'.Rebirth:InvokeServer()
    if Ea == true then
    wait(3)
        A()
    end
end
end)
end)

MorningStar.Name = "MorningStar"
MorningStar.Parent = ASetup
MorningStar.BackgroundColor3 = Color3.new(1, 1, 1)
MorningStar.Position = UDim2.new(0.0965346545, 0, 0.25468725, 0)
MorningStar.Size = UDim2.new(0, 148, 0, 37)
MorningStar.Style = Enum.ButtonStyle.RobloxRoundButton
MorningStar.Font = Enum.Font.SourceSans
MorningStar.Text = "Morning Star"
MorningStar.TextSize = 14
MorningStar.MouseButton1Click:connect(function()
local function A()
wait(0.5)

game.ReplicatedStorage.PlaceItem:InvokeServer("Symmetryte Mine", CFrame.new(-97.5, 206.799988, 194, -2.90066708e-07, 0, -1, 0, 1, 0, 1, 0, -2.90066708e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-97.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-91.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Discord Conveyor", CFrame.new(-85.5, 202.299988, 209, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-79.5, 202.299988, 209, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-79.5, 202.299988, 215, 1.3907092e-07, 0, 1, 0, 1, 0, -1, 0, 1.3907092e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-73.5, 202.299988, 215, -1, 0, -2.38497613e-08, 0, 1, 0, 2.38497613e-08, 0, -1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Basic Conveyor", CFrame.new(-73.5, 202.299988, 209, -2.90066708e-07, 0, -1, 0, 1, 0, 1, 0, -2.90066708e-07))
game.ReplicatedStorage.PlaceItem:InvokeServer("Morning Star", CFrame.new(-43.5, 206.799988, 182, -1, 0, -2.38497613e-08, 0, 1, 0, 2.38497613e-08, 0, -1))
game.ReplicatedStorage.PlaceItem:InvokeServer("The Final Upgrader", CFrame.new(-45, 205.299988, 198.5, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))
game.ReplicatedStorage.PlaceItem:InvokeServer("Sakura Garden", CFrame.new(-43.5, 206.799988, 219.5, 1, 0, 1.74845553e-07, 0, 1, 0, -1.74845553e-07, 0, 1))

local player = game:GetService'Players'.LocalPlayer
local factorye = player.PlayerTycoon.Value
local Factory = tostring(factorye)
-- if you'd like to change the upgrader this goes through, go ahead and change it below
thing = game.Workspace.Tycoons[Factory]["Morning Star"].Hitbox

--1200 is the default amount of times this will run, feel free to change it to whatever you want!
for i = 1,1000 do wait(.01) 
for i,v in pairs(game.Workspace.DroppedParts[Factory]:getChildren()) do
    local p= CFrame.new(thing.Position.x, thing.Position.y, thing.Position.z)
v.CFrame = p
end
end
end

A()

spawn(function()
while wait(0.1)do
    game:GetService'ReplicatedStorage'.RemoteDrop:FireServer()
end
end)
spawn(function()
while wait(1)do
    local Ea = game:GetService'ReplicatedStorage'.Rebirth:InvokeServer()
    if Ea == true then
    wait(3)
        A()
    end
end
end)
end)

TextLabel_3.Parent = ASetup
TextLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.Position = UDim2.new(-0.0247524753, 0, -0.0292887036, 0)
TextLabel_3.Size = UDim2.new(0, 200, 0, 50)
TextLabel_3.Font = Enum.Font.SourceSans
TextLabel_3.Text = "Auto Setup"
TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
TextLabel_3.TextSize = 24

--[[
Morning Star/Neutron Star Quick loop V2a made by LuckyMMB @ v3rmillion. Discord https://discord.gg/GKzJnUC
 
Thanks to footwears @v3rmillion for the tp loop script which I modified and put in to setups.
 
SMALL SETUP
You need a Symmetrium or Symmetryte Mine, 1 Nature's Grip furnace and 1 Morning Star. This will make NvD-Vgn
in about 2 minutes and is extremely efficient. The quickest ever method to get an Overlord Device.
MEDIUM SETUP
You need a Symmetrium or Symmetryte Mine, 1 Nature's Grip furnace and 1 Neutron Star. This will make UVg-DVg
in about 2 minutes and is extremely efficient. Use this if you don't have the Big Setup upgraders.
BIG SETUP
You need a Symmetrium or Symmetryte Mine, 1 Nature's Grip furnace, 1 Neutron Star, 1 Tesla Refuter, 3 Quantum
Clockwork, 3 True Overlord Devices, 1 The Final Upgrader, 1 Saturated Catalyst, 1 Catalyst, 2 Quantum Ore Polisher,
2 Azure Spore and a Sage King Furnace. This will get NVG and takes less than 3 minutes from start to rebirth.
CUSTOM SETUP
This can be used in public, private or solo games as it uses the Layouts feature. Place a good dropper and
a furnace and save it to Layout1 (in Base Settings, Layouts) and place a setup with 1 Morning Star OR 1
Neutron Star at the start and a furnace at the end and save it to Layout2. The setup will place down Layout1
for a few seconds, then buy some basic items (conveyors, pink/blue teleporters and ramps), clear the base
and place Layout2. This means you can use conveyors, teleporters and ramps in Layout2 that you may not have
in your inventory. The ore will then loop through the Star (automatically detected by the script which is why
you can only place 1) and carry on to the furnace. If you just want to use the preset setup then go a Solo
game and start the Big Setup, save it to Layout2 then you can go in any server and Layout2 will load.
You can tweak the setup or make your own its completely up to you.
 
Sometimes the ore may overload the star and come out early so it doesn't make enough money to rebirth or it may
not re-enable the ore when the setup restarts so the extra items wont buy and it will break the loop. If this
happens click the setup off/on to restart it or the setup will restart automatically after waiting 4 minutes.
 
You can change the numbers below to fine tune the ore going in (around 50-80 is a good number) and the
number of loops (1000 should be fine but you can take it up to 1200 if you really want to) to get the max
value from your ore.
 
B key brings all the ore to your location. Good for clearing blockages or just testing a certain upgrader.
N key toggles Ore Gates Open/Closed.
M key Toggles all the mines ON/OFF.
H key Remote Clicks the Lightningbolt Refiner Lightningbolt Predicter and Arcane Lightning Upgraders.
J key toggles Remote Clicking On/OFF.
K key toggles Reversible Conveyors.
]]
 
defaultdropper = "symmetrium" -- Mine used. Choose between symmetrium or symmetryte --
oretime = "30" -- Time in seconds ore drops before it starts looping. More time equals more ore --
loopnumber = "1000" -- Number of loops. About 850 is right but you can go higher --
turnminesoff = true -- Turn mines off when ores go to loop. Set to true or false --
 
smallsetupactive = false
mediumsetupactive = false
bigsetupactive = false
customsetupactive = false
rebirthactive = false
setuptimeactive = false
remoteclickstarted = false
remoteclickactive = false
oregatetoggleactive = false
upgraderclickstarted = false
upgraderclickactive = false
 
local player = game:GetService'Players'.LocalPlayer
local factorye = player.PlayerTycoon.Value
local Factory = tostring(factorye)
 
mouse = game.Players.LocalPlayer:GetMouse()
 
local MainGUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseMH = Instance.new("TextButton")
local Label = Instance.new("TextLabel")
local SmallSetup = Instance.new("TextButton")
local MediumSetup = Instance.new("TextButton")
local BigSetup = Instance.new("TextButton")
local SmallSetupText = Instance.new("TextLabel")
local MediumSetupText = Instance.new("TextLabel")
local BigSetupText = Instance.new("TextLabel")
local CustomSetup = Instance.new("TextButton")
local CustomSetupText = Instance.new("TextLabel")
local LoopFrame = Instance.new("Frame")
local LoopItem = Instance.new("TextBox")
local TPLoopNumber = Instance.new("TextBox")
local LoopButton = Instance.new("TextButton")
local Rebirth = Instance.new("TextButton")
local TPCrates = Instance.new("TextButton")
local CountTpCrates = Instance.new("TextLabel")
 
MainGUI.Name = "MainGUI"
MainGUI.Parent = game.CoreGui
local MainCORE = game.CoreGui["MainGUI"]
 
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGUI
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
MainFrame.BorderColor3 = Color3.new(0, 0, 0)
MainFrame.Position = UDim2.new(1, -170, 0, 0)
MainFrame.Size = UDim2.new(0, 170, 0, 300)
MainFrame.Selectable = true
MainFrame.Active = true
MainFrame.Draggable = true
 
CloseMH.Name = "CloseMH"
CloseMH.Parent = MainFrame
CloseMH.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
CloseMH.BorderColor3 = Color3.new(0, 0, 0)
CloseMH.Position = UDim2.new(0, 10, 0, 8)
CloseMH.Size = UDim2.new(0, 19, 0, 19)
CloseMH.Font = Enum.Font.SourceSans
CloseMH.Text = "X"
CloseMH.TextColor3 = Color3.new(1, 0, 0)
CloseMH.TextScaled = true
CloseMH.TextSize = 17
 
Label.Name = "Label"
Label.Parent = MainFrame
Label.BackgroundColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.BorderSizePixel = 0
Label.Position = UDim2.new(0, 31, 0, 4)
Label.Size = UDim2.new(0, 130, 0, 24)
Label.Font = Enum.Font.SourceSans
Label.Text = "Star Loop GUI"
Label.TextColor3 = Color3.new(0, 0, 0)
Label.TextSize = 22
 
SmallSetup.Name = "SmallSetup"
SmallSetup.Parent = MainFrame
SmallSetup.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
SmallSetup.Position = UDim2.new(0, 10, 0, 35)
SmallSetup.Size = UDim2.new(0, 150, 0, 25)
SmallSetup.Font = Enum.Font.SourceSans
SmallSetup.Text = "SMALL SETUP: OFF\nMorning Star"
SmallSetup.TextColor3 = Color3.new(0, 0, 0)
SmallSetup.TextSize = 18
SmallSetup.TextWrapped = true
 
SmallSetupText.Name = "SmallSetupText"
SmallSetupText.Parent = MainFrame
SmallSetupText.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SmallSetupText.Position = UDim2.new(0, 10, 0, 70)
SmallSetupText.Size = UDim2.new(0, 150, 0, 60)
SmallSetupText.Font = Enum.Font.SourceSans
SmallSetupText.Text = "Need Symmetrium Mine and a Morning Star. Everything is Automatic."
SmallSetupText.TextColor3 = Color3.new(1, 1, 1)
SmallSetupText.TextSize = 16
SmallSetupText.ZIndex = 6
SmallSetupText.Visible = false
SmallSetupText.TextWrapped = true
 
MediumSetup.Name = "MediumSetup"
MediumSetup.Parent = MainFrame
MediumSetup.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
MediumSetup.Position = UDim2.new(0, 10, 0, 70)
MediumSetup.Size = UDim2.new(0, 150, 0, 25)
MediumSetup.Font = Enum.Font.SourceSans
MediumSetup.Text = "MEDIUM SETUP: OFF"
MediumSetup.TextColor3 = Color3.new(0, 0, 0)
MediumSetup.TextSize = 18
MediumSetup.TextWrapped = true
 
MediumSetupText.Name = "MediumSetupText"
MediumSetupText.Parent = MainFrame
MediumSetupText.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MediumSetupText.Position = UDim2.new(0, 10, 0, 105)
MediumSetupText.Size = UDim2.new(0, 150, 0, 60)
MediumSetupText.Font = Enum.Font.SourceSans
MediumSetupText.Text = "Need Symmetrium Mine and a Neutron Star. Everything is Automatic."
MediumSetupText.TextColor3 = Color3.new(1, 1, 1)
MediumSetupText.TextSize = 16
MediumSetupText.ZIndex = 6
MediumSetupText.Visible = false
MediumSetupText.TextWrapped = true
 
BigSetup.Name = "BigSetup"
BigSetup.Parent = MainFrame
BigSetup.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
BigSetup.Position = UDim2.new(0, 10, 0, 105)
BigSetup.Size = UDim2.new(0, 150, 0, 25)
BigSetup.Font = Enum.Font.SourceSans
BigSetup.Text = "BIG SETUP: OFF"
BigSetup.TextColor3 = Color3.new(0, 0, 0)
BigSetup.TextSize = 18
BigSetup.TextWrapped = true
 
BigSetupText.Name = "BigSetupText"
BigSetupText.Parent = MainFrame
BigSetupText.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
BigSetupText.Position = UDim2.new(0, 10, 0, 35)
BigSetupText.Size = UDim2.new(0, 150, 0, 60)
BigSetupText.Font = Enum.Font.SourceSans
BigSetupText.Text = "Need Symmetrium Mine Neutron Star and Reborn Items. Fully Automatic."
BigSetupText.TextColor3 = Color3.new(1, 1, 1)
BigSetupText.TextSize = 16
BigSetupText.ZIndex = 6
BigSetupText.Visible = false
BigSetupText.TextWrapped = true
 
CustomSetup.Name = "CustomSetup"
CustomSetup.Parent = MainFrame
CustomSetup.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
CustomSetup.Position = UDim2.new(0, 10, 0, 140)
CustomSetup.Size = UDim2.new(0, 150, 0, 25)
CustomSetup.Font = Enum.Font.SourceSans
CustomSetup.Text = "CUSTOM SETUP: OFF"
CustomSetup.TextColor3 = Color3.new(0, 0, 0)
CustomSetup.TextSize = 18
CustomSetup.TextWrapped = true
 
CustomSetupText.Name = "CustomSetupText"
CustomSetupText.Parent = MainFrame
CustomSetupText.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
CustomSetupText.Position = UDim2.new(0, 10, 0, 35)
CustomSetupText.Size = UDim2.new(0, 150, 0, 95)
CustomSetupText.Font = Enum.Font.SourceSans
CustomSetupText.Text = "Save a good dropper and furnace to Layout1 and a setup with 1 Neutron Star OR 1 Morning Star to Layout2"
CustomSetupText.TextColor3 = Color3.new(1, 1, 1)
CustomSetupText.TextSize = 16
CustomSetupText.ZIndex = 6
CustomSetupText.Visible = false
CustomSetupText.TextWrapped = true
 
LoopFrame.Name = "LoopFrame"
LoopFrame.Parent = MainFrame
LoopFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.9)
LoopFrame.BorderColor3 = Color3.new(0, 0, 0)
LoopFrame.Position = UDim2.new(0, 0, 0, 170)
LoopFrame.Size = UDim2.new(0, 170, 0, 55)
 
LoopItem.Name = "LoopItem"
LoopItem.Parent = MainFrame
LoopItem.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
LoopItem.Position = UDim2.new(0, 10, 0, 175)
LoopItem.Size = UDim2.new(0, 150, 0, 20)
LoopItem.Font = Enum.Font.SourceSans
LoopItem.Text = "TYPE LOOP ITEM"
LoopItem.TextColor3 = Color3.new(0, 0, 0)
LoopItem.TextSize = 18
LoopItem.TextWrapped = true
LoopItem.ZIndex = 7
 
TPLoopNumber.Name = "TPLoopNumber"
TPLoopNumber.Parent = MainFrame
TPLoopNumber.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
TPLoopNumber.Position = UDim2.new(0, 10, 0, 200)
TPLoopNumber.Size = UDim2.new(0, 50, 0, 20)
TPLoopNumber.Font = Enum.Font.SourceSans
TPLoopNumber.Text = "1000"
TPLoopNumber.TextColor3 = Color3.new(0, 0, 0)
TPLoopNumber.TextSize = 18
TPLoopNumber.TextWrapped = true
TPLoopNumber.ZIndex = 7
 
LoopButton.Name = "LoopButton"
LoopButton.Parent = MainFrame
LoopButton.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
LoopButton.Position = UDim2.new(0, 65, 0, 200)
LoopButton.Size = UDim2.new(0, 95, 0, 20)
LoopButton.Font = Enum.Font.SourceSans
LoopButton.Text = "LOOP"
LoopButton.TextColor3 = Color3.new(0, 0, 0)
LoopButton.TextSize = 18
LoopButton.TextWrapped = true
LoopButton.ZIndex = 7
 
Rebirth.Name = "Rebirth"
Rebirth.Parent = MainFrame
Rebirth.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
Rebirth.Position = UDim2.new(0, 10, 0, 230)
Rebirth.Size = UDim2.new(0, 150, 0, 25)
Rebirth.Font = Enum.Font.SourceSans
Rebirth.Text = "AUTO REBIRTH: OFF"
Rebirth.TextColor3 = Color3.new(0, 0, 0)
Rebirth.TextSize = 18
Rebirth.TextWrapped = true
 
TPCrates.Name = "TPCrates"
TPCrates.Parent = MainFrame
TPCrates.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
TPCrates.Position = UDim2.new(0, 10, 0, 265)
TPCrates.Size = UDim2.new(0, 130, 0, 25)
TPCrates.Font = Enum.Font.SourceSans
TPCrates.Text = "TP TO CRATES: OFF"
TPCrates.TextColor3 = Color3.new(0, 0, 0)
TPCrates.TextSize = 18
TPCrates.TextWrapped = true
 
CountTpCrates.Name = "CountTpCrates"
CountTpCrates.Parent = MainFrame
CountTpCrates.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
CountTpCrates.Position = UDim2.new(0, 140, 0, 265)
CountTpCrates.Size = UDim2.new(0, 20, 0, 25)
CountTpCrates.Font = Enum.Font.SourceSans
CountTpCrates.Text = "0"
CountTpCrates.TextColor3 = Color3.new(0, 0, 0)
CountTpCrates.TextSize = 18
CountTpCrates.TextWrapped = true
 
game.Lighting.Changed:connect(function()
    game.Lighting.TimeOfDay = "12:00:00"
    game.Lighting.FogEnd = 9999
    game.Lighting.Brightness = 1
    game.Lighting.ColorCorrection.Brightness = 0
    game.Lighting.ColorCorrection.Saturation = 0
    game.Lighting.Bloom.Intensity = 0
end)
 
local function addtptool()
    local Tele = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
    Tele.RequiresHandle = false
    Tele.RobloxLocked = true
    Tele.Name = "TP Tool"
    Tele.ToolTip = "Teleport Tool"
    Tele.Equipped:connect(function(Mouse)
        Mouse.Button1Down:connect(function()
            if Mouse.Target then
                game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = (CFrame.new(Mouse.Hit.x, Mouse.Hit.y + 5, Mouse.Hit.z))
            end
        end)
    end)
end
addtptool()
 
function notify(msg)
    game.StarterGui:SetCore('SendNotification', {
        Title = 'Miner\'s Haven';
        Text = msg;
        Duration = 5;
    })
end
 
CloseMH.MouseButton1Down:connect(function()
MainGUI:Destroy()
end)
 
SmallSetup.MouseEnter:connect(function()
    SmallSetupText.Visible = true
end)
 
SmallSetup.MouseLeave:connect(function()
    SmallSetupText.Visible = false
end)
 
MediumSetup.MouseEnter:connect(function()
    MediumSetupText.Visible = true
end)
 
MediumSetup.MouseLeave:connect(function()
    MediumSetupText.Visible = false
end)
 
BigSetup.MouseEnter:connect(function()
    BigSetupText.Visible = true
end)
 
BigSetup.MouseLeave:connect(function()
    BigSetupText.Visible = false
end)
 
CustomSetup.MouseEnter:connect(function()
    CustomSetupText.Visible = true
end)
 
CustomSetup.MouseLeave:connect(function()
    CustomSetupText.Visible = false
end)
 
spawn (function()
    while true do
        wait(0.1)
        if tpcratesactive == true then
            local player = game:GetService'Players'.LocalPlayer
            local children = game.Workspace:GetChildren()
            for i =1, #children do
                wait(0.1)
                if children[i] ~= nil then
                    for x in string.gmatch(children[i].Name, "Crate") do
                        if children[i].Parent then
                            if children[i].Name ~= "GiftCrate" then
                                player.Character:MoveTo(children[i].Position)
                                wait(1)
                            end
                        end
                    end
                end
            end
            local children = game.Workspace.Shadows:GetChildren()
            for i =1, #children do
                wait(0.1)
                if children[i] ~= nil then
                    for x in string.gmatch(children[i].Name, "Crate") do
                        if children[i].Parent then
                            player.Character:MoveTo(children[i].Position)
                            wait(1)
                        end
                    end
                end
            end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocationX, LocationY, LocationZ)
        end
    end
end)
 
TPCrates.MouseButton1Down:connect(function()
    if tpcratesstarted == true then
        tpcratesstarted = false
        tpcratesactive = false
        TPCrates.Text = "TP TO CRATES: OFF"
        TPCrates.TextColor3 = Color3.new(0, 0, 0)
    else
        tpcratesstarted = true
        tpcratesactive = true
        TPCrates.Text = "TP TO CRATES: ON"
        TPCrates.TextColor3 = Color3.new(1, 0, 0)
        LocationX = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.x
        LocationY = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y
        LocationZ = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.z
    end
end)
 
SmallSetup.MouseButton1Down:connect(function()
    if smallsetupactive ~= true then
        smallsetupactive = true
        rebirthactive = true
        bigsetupactive = false
        layoutempty = false
        SmallSetup.Text = "SMALL SETUP: ON"
        mediumsetupactive = false
        MediumSetup.Text = "MEDIUM SETUP: OFF"
        MediumSetup.TextColor3 = Color3.new(0, 0, 0)
        BigSetup.Text = "BIG SETUP: OFF"
        SmallSetup.TextColor3 = Color3.new(1, 0, 0)
        BigSetup.TextColor3 = Color3.new(0, 0, 0)
        customsetupactive = false
        setupinuse = false
        CustomSetup.Text = "CUSTOM SETUP: OFF"
        CustomSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: ON"
        Rebirth.TextColor3 = Color3.new(1, 0, 0)
        print("Morning Star Loop (SMALL) setup started on " ..Factory.. ", sit back and relax")
 
        loopsetupstart()
    else
        smallsetupactive = false
        rebirthactive = false
        setuptimeactive = false
        SmallSetup.Text = "SMALL SETUP: OFF"
        SmallSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: OFF"
        Rebirth.TextColor3 = Color3.new(0, 0, 0)
    end
end)
 
MediumSetup.MouseButton1Down:connect(function()
    if mediumsetupactive ~= true then
        mediumsetupactive = true
        rebirthactive = true
        smallsetupactive = false
        bigsetupactive = false
        layoutempty = false
        mediumsetupactive = true
        setupinuse = false
        MediumSetup.Text = "MEDIUM SETUP: ON"
        MediumSetup.TextColor3 = Color3.new(1, 0, 0)
        SmallSetup.Text = "SMALL SETUP: OFF"
        BigSetup.Text = "BIG SETUP: OFF"
        SmallSetup.TextColor3 = Color3.new(0, 0, 0)
        customsetupactive = false
        CustomSetup.Text = "CUSTOM SETUP: OFF"
        CustomSetup.TextColor3 = Color3.new(0, 0, 0)
        BigSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: ON"
        Rebirth.TextColor3 = Color3.new(1, 0, 0)
        print("Neutron Star Loop (MEDIUM) setup started on " ..Factory.. ", sit back and relax")
 
        loopsetupstart()
    else
        mediumsetupactive = false
        rebirthactive = false
        setuptimeactive = false
        MediumSetup.Text = "MEDIUM SETUP: OFF"
        MediumSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: OFF"
        Rebirth.TextColor3 = Color3.new(0, 0, 0)
    end
end)
 
BigSetup.MouseButton1Down:connect(function()
    if bigsetupactive ~= true then
        bigsetupactive = true
        rebirthactive = true
        smallsetupactive = false
        layoutempty = false
        mediumsetupactive = false
        setupinuse = false
        MediumSetup.Text = "MEDIUM SETUP: OFF"
        MediumSetup.TextColor3 = Color3.new(0, 0, 0)
        SmallSetup.Text = "SMALL SETUP: OFF"
        BigSetup.Text = "BIG SETUP: ON"
        SmallSetup.TextColor3 = Color3.new(0, 0, 0)
        BigSetup.TextColor3 = Color3.new(1, 0, 0)
        customsetupactive = false
        CustomSetup.Text = "CUSTOM SETUP: OFF"
        CustomSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: ON"
        Rebirth.TextColor3 = Color3.new(1, 0, 0)
        print("Neutron Star Loop {BIG) setup started on " ..Factory.. ", sit back and relax")
 
        loopsetupstart()
    else
        bigsetupactive = false
        rebirthactive = false
        setuptimeactive = false
        BigSetup.Text = "BIG SETUP: OFF"
        BigSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: OFF"
        Rebirth.TextColor3 = Color3.new(0, 0, 0)
    end
end)
 
CustomSetup.MouseButton1Down:connect(function()
    if customsetupactive ~= true then
        customsetupactive = true
        rebirthactive = true
        smallsetupactive = false
        layoutempty = false
        CustomSetup.Text = "CUSTOM SETUP: ON"
        CustomSetup.TextColor3 = Color3.new(1, 0, 0)
        mediumsetupactive = false
        setupinuse = false
        MediumSetup.Text = "MEDIUM SETUP: OFF"
        MediumSetup.TextColor3 = Color3.new(0, 0, 0)
        SmallSetup.Text = "SMALL SETUP: OFF"
        BigSetup.Text = "BIG SETUP: OFF"
        SmallSetup.TextColor3 = Color3.new(0, 0, 0)
        BigSetup.TextColor3 = Color3.new(0, 0, 0)
        Rebirth.Text = "AUTO REBIRTH: ON"
        Rebirth.TextColor3 = Color3.new(1, 0, 0)
        print("Custom setup started using Layouts1/2 on " ..Factory.. ", sit back and relax")
 
        loopsetupstart()
    else
        customsetupactive = false
        CustomSetup.Text = "CUSTOM SETUP: OFF"
        CustomSetup.TextColor3 = Color3.new(0, 0, 0)
        rebirthactive = false
        setuptimeactive = false
        Rebirth.Text = "AUTO REBIRTH: OFF"
        Rebirth.TextColor3 = Color3.new(0, 0, 0)
        game.Players.LocalPlayer.PlayerGui.GUI.Menu.Menu.Sounds.Message.Volume = 0.5
        game.Players.LocalPlayer.PlayerGui.GUI.Notifications.Visible = true
    end
end)
Rebirth.MouseButton1Down:connect(function()
    if rebirthactive ~= true then
        rebirthactive = true
        Rebirth.Text = "AUTO REBIRTH: ON"
        Rebirth.TextColor3 = Color3.new(1, 0, 0)
    else
        rebirthactive = false
        Rebirth.Text = "AUTO REBIRTH: OFF"
        Rebirth.TextColor3 = Color3.new(0, 0, 0)
    end
end)
 
spawn(function()
    while true do
        wait(0.01)
        if remoteclickactive == true then
            while remoteclickactive == true do
                game:GetService("ReplicatedStorage").RemoteDrop:FireServer()
                wait(0.2)
            end
        end
    end
end)
 
spawn(function()
    while true do
        wait(0.01)
        if pulseclickactive == true then
            while pulseclickactive == true do
                game:GetService("ReplicatedStorage").Pulse:FireServer()
                wait(0.2)
            end
        end
    end
end)
 
spawn(function()
    while true do
        wait(0.25)
        if upgraderclickactive == true then
            while upgraderclickactive == true do
                local ClickEvent = game:GetService("ReplicatedStorage"):WaitForChild('Click');
 
                local CheckFactory = function()
                    for i,v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild('Owner') then
                            if v.Owner.Value == game.Players.LocalPlayer.Name then
                                return v
                            end
                        end
                    end
                end
 
                local Factory = tostring(CheckFactory())
                local basepart = workspace.Tycoons[Factory]:GetChildren()
 
                for i,v in pairs(basepart) do
                    if v.Name ~= "Ore Gate" then
                        if v.Name ~= "Reversible Conveyor" then
                            for _,desc in pairs(v:GetDescendants()) do
                                if desc:IsA("ClickDetector") then
                                    if desc.Parent:IsA('Part') then
                                        ClickEvent:FireServer(desc.Parent)
                                    end
                                end
                            end
                        end
                    end
                end
                wait(0.2)
            end
        end
    end
end)
 
spawn(function()
    while true do
        wait(0.01)
        if customsetupactive == true then setuptimeout = "600" else setuptimeout = "300" end
        if rebirthactive == true then
            rebirthcashvalue = game.Players.LocalPlayer.leaderstats.Cash.Value
            rebirthcashvalue1 = tostring(rebirthcashvalue)
            game:GetService'ReplicatedStorage'.Rebirth:InvokeServer()
            wait(5)
            if bigsetupactive == true or customsetupactive == true then wait(5) end
            rebirthilfe = game.Players.LocalPlayer.leaderstats.Life.Value
            rebirthilfe = tostring(rebirthilfe)
 
            factoryitems = workspace.Tycoons[tostring(game.Players.LocalPlayer.PlayerTycoon.Value)]:GetChildren()
            for i =1, #factoryitems do
                if factoryitems[i].ClassName == "Model" then
                    layoutempty = false
                    break
                end
                layoutempty = true
            end
            --if layoutempty == true then print("base empty") else print("base not empty") end--
 
            if layoutempty == true then
                if game.Players.LocalPlayer.MinesActivated.Value ~= true then
                    game:GetService("ReplicatedStorage").ToggleMines:InvokeServer()
                    -- print("Turning mines back ON") --
                end
                if smallsetupactive == true or mediumsetupactive == true or bigsetupactive == true or customsetupactive == true then
                    if setupinuse == true then
                        print("ReBirthed to ".. rebirthilfe .. " Life at ".. rebirthcashvalue1)
                        wait(0.5)
                        loopsetupstart()
                    end
                end
            end
            if setuptimeactive == true then
                if smallsetupactive == true or mediumsetupactive == true then
                    setuptime = setuptime + 5
                end
                if bigsetupactive == true or customsetupactive == true then
                    setuptime = setuptime + 10
                end
                if tonumber(setuptime) >= tonumber(setuptimeout) then
                    print("Something went wrong with Setup or Ore. Restarting..")
                    if smallsetupactive == true then
                        smallsetupactive = false
                        wait(1)
                        smallsetupactive = true
                        loopsetupstart()
                    end
                    if mediumsetupactive == true then
                        mediumsetupactive = false
                        wait(1)
                        mediumsetupactive = true
                        loopsetupstart()
                    end
                    if bigsetupactive == true then
                        bigsetupactive = false
                        wait(1)
                        bigsetupactive = true
                        loopsetupstart()
                    end
                    if customsetupactive == true then
                        customsetupactive = false
                        wait(1)
                        customsetupactive = true
                        loopsetupstart()
                    end
                end
            end
        end
    end
end)
 
function loopsetupstart()
    setupinuse = false
    remoteclickactive = false
    upgraderclickactive = false
    setuptimeactive = true 
    setuptime = 0
    if game.Players.LocalPlayer.MinesActivated.Value ~= true then
        game:GetService("ReplicatedStorage").ToggleMines:InvokeServer()
        -- print("Turning mines back ON") --
    end
    if layoutempty ~= true then
        game:GetService("ReplicatedStorage").DestroyAll:InvokeServer()
        wait(2)
    end
    setupinuse = true
 
    if tpcratesstarted == true then
        tpcratesactive = false
        wait(2)
    end
    if customsetupactive == true then
        game.Players.LocalPlayer.PlayerGui.GUI.Notifications.Visible = false
        game.Players.LocalPlayer.PlayerGui.GUI.Menu.Menu.Sounds.Message.Volume = 0
        game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load", "Layout1")
    else
        if defaultdropper == "symmetrium" then
            local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
            local Event = game:GetService("ReplicatedStorage").PlaceItem
            local A_1 = CFrame.new(-15, 6.5, 67.4999847, 0.000140138043, 1.86660731e-09, 1, -4.3159529e-05, 1, 4.18168433e-09, -1, -4.3159529e-05, 0.000140138043) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Symmetrium Mine",  A_1)
 
            layoutempty = false
 
            local A_1 = CFrame.new(-18, 5, 53.9999847, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Nature's Grip",  A_1)
           
        end
   
        if defaultdropper == "symmetryte" then
            local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
            local Event = game:GetService("ReplicatedStorage").PlaceItem
            local A_1 = CFrame.new(-15, 6.5, 69, 5.34659193e-05, 9.31346444e-10, 1, -4.31585977e-05, 1, 1.37616774e-09, -1, -4.31585977e-05, 5.34659193e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Symmetryte Mine",  A_1)
 
            layoutempty = false
 
            local A_1 = CFrame.new(-18, 5, 50.9999847, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Nature's Grip",  A_1)
           
        end
    end
 
    if tpcratesstarted == true then
        tpcratesactive = true
    end
   
    wait(4)
   
    game.ReplicatedStorage.BuyItem:InvokeServer('Basic Conveyor', 99)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Raised Shielded Conveyor', 99)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Centering Conveyor', 40)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Conveyor Wall', 40)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Military-Grade Conveyor', 90)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Pink Teleporter (Receiver)', 1)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Pink Teleporter (Sender)', 4)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Ore Replicator', 2)
    wait(0.5)
    game.ReplicatedStorage.BuyItem:InvokeServer('Shrine of Penitence', 1)
    wait(0.5)
 
    if customsetupactive == true then
        game.ReplicatedStorage.BuyItem:InvokeServer('Raised Mini Conveyor', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Conveyor Converter', 10)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Basic Conveyor', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Teleporter (Receiver)', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Teleporter (Sender)', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Raised Mini Conveyor', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Walled Conveyor', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Raised-ier Conveyor', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Steel Wall', 20)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Metal Wall Segment', 30)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Slanted Wall', 20)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Controlled Gate', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Cannon', 2)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Pulsar', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Satellite Beam', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Spectral Upgrader', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Flaming Ore Scanner', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Endpoint Refiner', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Elevator', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Hoister', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Winder', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Steamer', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Portable Ore Advancer', 30)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Portable Ore Stopper', 30)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Industrial Ore Welder', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Nuclear Conveyor', 20)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Freon-Blast Upgrader', 2)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Plasma Conveyor', 30)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Tiny Conveyor', 40)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ladder', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Advanced Ore Scanner', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Heat Condenser', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Roaster', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Overhang Upgrader', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Overhang Upgrader', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Zapper', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Collider', 2)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Illuminator', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Gate', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Large Conveyor Ramp', 15)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Conveyor Ramp', 99)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Fine-Point Upgrader', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Recliner', 5)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ore Zapper', 4)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Portable Ore Stopper', 30)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Orbitable Upgrader', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Coal Mine', 15)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Plasma Iron Polisher', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Ion Field', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Way-Up-High Upgrader', 3)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Precision Refiner', 1)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Drone Upgrader', 2)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Flaming Ore Scanner', 2)
        wait(0.5)
        game.ReplicatedStorage.BuyItem:InvokeServer('Half Conveyor', 6)
        wait(0.5)
    end
 
    wait(4)
    loopsetupstart2()
end
   
function loopsetupstart2()
    setupinuse = false
    if smallsetupactive == true or mediumsetupactive == true or bigsetupactive == true or customsetupactive == true then
 
    game:GetService("ReplicatedStorage").DestroyAll:InvokeServer()
    wait(2)
 
    if game.Players.LocalPlayer.MinesActivated.Value ~= true then
        game:GetService("ReplicatedStorage").ToggleMines:InvokeServer()
        -- print("Turning mines back ON") --
    end
 
    if tpcratesstarted == true then
        tpcratesactive = false
        wait(2)
    end
 
    if customsetupactive == true then
        game.Players.LocalPlayer.PlayerGui.GUI.Notifications.Visible = false
        game.Players.LocalPlayer.PlayerGui.GUI.Menu.Menu.Sounds.Message.Volume = 0
        game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load", "Layout2")
        starloopend()
    else
        if defaultdropper == "symmetrium" then
            local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
            local Event = game:GetService("ReplicatedStorage").PlaceItem
            local A_1 = CFrame.new(78, 6.5, 76.5, 0.000140138043, 1.86660731e-09, 1, -4.3159529e-05, 1, 4.18168433e-09, -1, -4.3159529e-05, 0.000140138043) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Symmetrium Mine",  A_1)
           
            local A_1 = CFrame.new(66, 6.5, 76.5, 0.000140138043, 1.86660731e-09, 1, -4.3159529e-05, 1, 4.18168433e-09, -1, -4.3159529e-05, 0.000140138043) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Symmetrium Mine",  A_1)
           
            local A_1 = CFrame.new(79.5, 5, 55.5, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Ore Replicator",  A_1)
           
            local A_1 = CFrame.new(67.5, 5, 55.5, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Ore Replicator",  A_1)
           
            local A_1 = CFrame.new(81, 2, 61.5, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Raised Shielded Conveyor",  A_1)
           
            local A_1 = CFrame.new(75, 2, 61.5, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Raised Shielded Conveyor",  A_1)
           
            local A_1 = CFrame.new(69, 2, 61.5, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Raised Shielded Conveyor",  A_1)
           
            local A_1 = CFrame.new(63, 2, 61.5, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Raised Shielded Conveyor",  A_1)
           
            local A_1 = CFrame.new(57, 2, 60, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
           
            local A_1 = CFrame.new(51, 2, 60, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
           
            local A_1 = CFrame.new(51, 2, 66, 0.000140138043, 1.86660731e-09, 1, -4.3159529e-05, 1, 4.18168433e-09, -1, -4.3159529e-05, 0.000140138043) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
           
            local A_1 = CFrame.new(57, 2, 66, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
        end
        if defaultdropper == "symmetryte" then
            local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
            local Event = game:GetService("ReplicatedStorage").PlaceItem
            local A_1 = CFrame.new(75, 6.5, 72, 5.34659193e-05, 9.31346444e-10, 1, -4.31585977e-05, 1, 1.37616774e-09, -1, -4.31585977e-05, 5.34659193e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Symmetryte Mine",  A_1)
           
            local A_1 = CFrame.new(78, 2, 57, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
           
            local A_1 = CFrame.new(78, 2, 51, -3.26636873e-05, 4.31581502e-05, -1, 9.29513355e-10, 1, 4.31581502e-05, 1, 4.80190998e-10, -3.26636873e-05) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
           
            local A_1 = CFrame.new(72, 2, 51, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
           
            local A_1 = CFrame.new(72, 2, 57, 0.000140138043, 1.86660731e-09, 1, -4.3159529e-05, 1, 4.18168433e-09, -1, -4.3159529e-05, 0.000140138043) + Tycoon:FindFirstChild("Base").Position
            Event:InvokeServer("Basic Conveyor",  A_1)
        end
        if smallsetupactive == true then
            morningstarloop()
        end
        if mediumsetupactive == true then
            neutronstarloop1()
        end
        if bigsetupactive == true then
            neutronstarloop2()
        end
    end
    end
end
 
function morningstarloop()
    tptarget = "Morning Star"
 
    local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
    local Event = game:GetService("ReplicatedStorage").PlaceItem
    local A_1 = CFrame.new(27, 6.5, 62.9999847, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Morning Star",  A_1)
   
    local A_1 = CFrame.new(27, 2, 54, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Military-Grade Conveyor",  A_1)
   
    local A_1 = CFrame.new(27, 2, 48, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Military-Grade Conveyor",  A_1)
   
    local A_1 = CFrame.new(27, 5, 39, 5.34659193e-05, 9.31346444e-10, 1, -4.31585977e-05, 1, 1.37616774e-09, -1, -4.31585977e-05, 5.34659193e-05) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Shrine of Penitence",  A_1)
 
    starloopend()
end
 
function neutronstarloop1()
    tptarget = "Neutron Star"
 
    local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
    local Event = game:GetService("ReplicatedStorage").PlaceItem
    local A_1 = CFrame.new(21, 6.5, 78, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Neutron Star",  A_1)
   
    local A_1 = CFrame.new(21, 2, 69, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Military-Grade Conveyor",  A_1)
   
    local A_1 = CFrame.new(21, 2, 63, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Military-Grade Conveyor",  A_1)
   
    local A_1 = CFrame.new(21, 5, 54, 5.34659193e-05, 9.31346444e-10, 1, -4.31585977e-05, 1, 1.37616774e-09, -1, -4.31585977e-05, 5.34659193e-05) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Shrine of Penitence",  A_1)
 
    starloopend()
end
 
function neutronstarloop2()
    tptarget = "Neutron Star"
 
    local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value))
    local Event = game:GetService("ReplicatedStorage").PlaceItem
    local A_1 = CFrame.new(21, 6.5, 78, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Neutron Star",  A_1)
   
    local A_1 = CFrame.new(20.999939, 2, 69, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Centering Conveyor",  A_1)
   
    local A_1 = CFrame.new(21, 2, 63, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Centering Conveyor",  A_1)
   
    local A_1 = CFrame.new(25.500061, 1.89996338, 69, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
   
    local A_1 = CFrame.new(16.499939, 1.89996338, 69, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
   
    local A_1 = CFrame.new(25.500061, 1.89996338, 63, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
   
    local A_1 = CFrame.new(16.499939, 1.89996338, 63, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
 
    local A_1 = CFrame.new(21, 3.5, 54, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Quantum Clockwork",  A_1)
   
    local A_1 = CFrame.new(21, 5, 39, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("True Overlord Device",  A_1)
   
    local A_1 = CFrame.new(20.9999695, 8, 19.5, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Saturated Catalyst",  A_1)
   
    local A_1 = CFrame.new(21, 8, -6.10351563e-05, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Azure Spore",  A_1)
   
    local A_1 = CFrame.new(21.0000305, 3.5, -16.5, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Quantum Ore Polisher",  A_1)
   
    local A_1 = CFrame.new(21, 5, -31.5, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Tesla Refuter",  A_1)
   
    local A_1 = CFrame.new(21, 3.5, -45, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Quantum Clockwork",  A_1)
   
    local A_1 = CFrame.new(21, 5, -59.9999695, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("True Overlord Device",  A_1)
   
    local A_1 = CFrame.new(21, 3.5, -72, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Pink Teleporter (Sender)",  A_1)
   
    local A_1 = CFrame.new(-19.5, 3.5, -75, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Pink Teleporter (Receiver)",  A_1)
   
    local A_1 = CFrame.new(-21, 2.00006104, -66, 0.000226440417, 4.66035299e-09, 1, -4.31585977e-05, 1, 5.11249842e-09, -1, -4.31585977e-05, 0.000226440417) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Basic Conveyor",  A_1)
   
    local A_1 = CFrame.new(-15, 2, -66, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Centering Conveyor",  A_1)
 
    local A_1 = CFrame.new(-10.5, 1.90002441, -66, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
   
    local A_1 = CFrame.new(-25.5, 1.89996338, -66, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
 
    local A_1 = CFrame.new(-16.5, 5, -52.5, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("The Final Upgrader",  A_1)
   
    local A_1 = CFrame.new(-15, 2, -39, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Centering Conveyor",  A_1)
   
    local A_1 = CFrame.new(-21, 2.00006104, -39, 0.000140138043, 1.86660731e-09, 1, -4.3159529e-05, 1, 4.18168433e-09, -1, -4.3159529e-05, 0.000140138043) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Basic Conveyor",  A_1)
 
    local A_1 = CFrame.new(-25.5, 1.90002441, -39, -1, 3.05171125e-05, 3.05180438e-05, 3.05180438e-05, 1, 3.05171125e-05, -3.05171125e-05, 3.05180438e-05, -1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
   
    local A_1 = CFrame.new(-10.5, 1.90002441, -39, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Conveyor Wall",  A_1)
   
    local A_1 = CFrame.new(-15, 5, -27, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("True Overlord Device",  A_1)
   
    local A_1 = CFrame.new(-15, 3.5, -12, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Quantum Clockwork",  A_1)
   
    local A_1 = CFrame.new(-15, 8, 3, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Azure Spore",  A_1)
   
    local A_1 = CFrame.new(-15, 7.99993896, 21, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("The Catalyst",  A_1)
   
    local A_1 = CFrame.new(-15, 3.5, 37.5, 1, 3.05180438e-05, -3.05171125e-05, -3.05171125e-05, 1, 3.05180438e-05, 3.05180438e-05, -3.05171125e-05, 1) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Quantum Ore Polisher",  A_1)
 
    local A_1 = CFrame.new(-15, 12.5700073, 60, 0.000226440417, 4.66035299e-09, 1, -4.31585977e-05, 1, 5.11249842e-09, -1, -4.31585977e-05, 0.000226440417) + Tycoon:FindFirstChild("Base").Position
    Event:InvokeServer("Sage King",  A_1)
   
    starloopend()
end
 
function starloopend()
    setupinuse = true
    if tpcratesstarted == true then
        tpcratesactive = true
    end
    if remoteclickstarted == true then
        remoteclickactive = true
    end
    if upgraderclickstarted == true then
         upgraderclickactive = true
    end
    wait(oretime)
 
    if smallsetupactive == true or mediumsetupactive == true or bigsetupactive == true or customsetupactive == true then
 
    if turnminesoff then
        if game.Players.LocalPlayer.MinesActivated.Value == true then
            game:GetService("ReplicatedStorage").ToggleMines:InvokeServer()
            -- print("Turning mines OFF") --
        end
    end
 
    if customsetupactive == true then
        local player = game:GetService'Players'.LocalPlayer
        local factorye = player.PlayerTycoon.Value
        local Factory = tostring(factorye)
        local basepart = workspace.Tycoons[Factory]:GetChildren()
        for i=1,#basepart do
            if basepart[i].Name == "Morning Star" then
                tptarget = "Morning Star"
                targeterror = false
                break
            end
            if basepart[i].Name == "Neutron Star" then
                tptarget = "Neutron Star"
                targeterror = false
                break
            end
            targeterror = true
        end
        if targeterror == true then
            print("Error. No Morning Star or Neutron Star found on base.")
            print("Restarting setup to try and fix the problem")
            wait(1)
            customsetupactive = false
            wait(1)
            customsetupactive = true
            loopsetupstart()
        else
            -- print("Target set: " ..tptarget) --
            starloopend2()
        end
    else
        starloopend2()
    end
    end
end
   
function starloopend2()
    local player = game:GetService'Players'.LocalPlayer
    local factorye = player.PlayerTycoon.Value
    local Factory = tostring(factorye)
    thing = game.Workspace.Tycoons[Factory][tptarget].Model.Upgrade
 
    for n = 1,loopnumber do
        wait(.04)
        for i,v in pairs(game.Workspace.DroppedParts[Factory]:getChildren()) do
            if v.Name ~= "Triple Coal Mine" then
                if v.Name ~= "Coal Mine" then
                    local p= CFrame.new(thing.Position.x, thing.Position.y, thing.Position.z)
                    v.CFrame = p
                end
                if smallsetupactive == true then
                    SmallSetup.Text = "SMALL - LOOPS("..tostring(n)..")"
                elseif mediumsetupactive == true then
                    MediumSetup.Text = "MEDIUM - LOOPS("..tostring(n)..")"
                elseif bigsetupactive == true then
                    BigSetup.Text = "BIG - LOOPS("..tostring(n)..")"
                elseif customsetupactive == true then
                    CustomSetup.Text = "CUSTOM - LOOPS("..tostring(n)..")"
                end
            end
        end
    end
    wait(3)
    if smallsetupactive == true then
        SmallSetup.Text = "SMALL SETUP: ON"
    elseif mediumsetupactive == true then
        MediumSetup.Text = "MEDIUM SETUP: ON"
    elseif bigsetupactive == true then
        BigSetup.Text = "BIG SETUP: ON"
    elseif customsetupactive == true then
        CustomSetup.Text = "CUSTOM SETUP: ON"
    end
end
 
LoopButton.MouseButton1Down:connect(function()
    local player = game:GetService'Players'.LocalPlayer
    local factorye = player.PlayerTycoon.Value
    local Factory = tostring(factorye)
    thing = game.Workspace.Tycoons[Factory][tostring(LoopItem.Text)].Model.Upgrade
 
    for n = 1,tonumber(TPLoopNumber.Text) do
        wait(.04)
        for i,v in pairs(game.Workspace.DroppedParts[Factory]:getChildren()) do
            if v.Name ~= "Triple Coal Mine" then
                if v.Name ~= "Coal Mine" then
                    local p= CFrame.new(thing.Position.x, thing.Position.y, thing.Position.z)
                    v.CFrame = p
                end
            end
        end
        LoopButton.Text = "LOOPS("..tostring(n)..")"
        LoopButton.TextColor3 = Color3.new(1, 0, 0)
    end
    wait(3)
        LoopButton.Text = "LOOP"
        LoopButton.TextColor3 = Color3.new(0, 0, 0)
end)
 
mouse.KeyDown:connect(function(key)
    if key == "b" then
        local player = game:GetService'Players'.LocalPlayer
        local factorynumber = player.PlayerTycoon.Value
        local Factory = tostring(factorynumber)
        for i,v in pairs(game.Workspace.DroppedParts[Factory]:getChildren()) do
            if v.Name ~= "Triple Coal Mine" then
                if v.Name ~= "Coal Mine" then
                    local p= CFrame.new(game.Players.LocalPlayer.Character.Head.Position.x, game.Players.LocalPlayer.Character.Head.Position.y -1, game.Players.LocalPlayer.Character.Head.Position.z -1)
                    v.CFrame = p
                end
            end
        end
    end
end)
 
mouse.KeyDown:connect(function(key)
    if key == "m" then
        if game.Players.LocalPlayer.MinesActivated.Value == true then
            game:GetService("ReplicatedStorage").ToggleMines:InvokeServer()
            notify'Turning all mines OFF'
        else
            game:GetService("ReplicatedStorage").ToggleMines:InvokeServer()
            notify'Turning all mines ON'
        end
    end
end)
 
mouse.KeyDown:connect(function(key)
    if key == "n" then
        local ClickEvent = game:GetService("ReplicatedStorage"):WaitForChild('Click');
        local CheckFactory = function()
            for i,v in pairs(workspace.Tycoons:GetChildren()) do
                if v:FindFirstChild('Owner') then
                    if v.Owner.Value == game.Players.LocalPlayer.Name then
                        return v
                    end
                end
            end
        end
 
        local Factory = tostring(CheckFactory())
        local basepart = workspace.Tycoons[Factory]:GetChildren()
 
        if toggleoregate == true then
            toggleoregate = false
            notify'Closing ALL Ore Gates'
            for i,v in pairs(basepart) do
                if v.Name == "Ore Gate" then
                    for _,desc in pairs(v:GetDescendants()) do
                        if desc:IsA("ClickDetector") then
                            if desc.Parent:IsA("Part") then
                                ClickEvent:FireServer(desc.Parent)
                                break
                            end
                        end
                    end
                end
            end
        else
            toggleoregate = true
            notify'Opening ALL Ore Gates'
            for i,v in pairs(basepart) do
                if v.Name == "Ore Gate" then
                    for _,desc in pairs(v:GetDescendants()) do
                        if desc:IsA("ClickDetector") then
                            if desc.Parent:IsA("Part") then
                                ClickEvent:FireServer(desc.Parent)
                            end
                        end
                    end
                end
            end
        end
    end
end)
 
mouse.KeyDown:connect(function(key)
    if key == "k" then
        local ClickEvent = game:GetService("ReplicatedStorage"):WaitForChild('Click');
        local CheckFactory = function()
            for i,v in pairs(workspace.Tycoons:GetChildren()) do
                if v:FindFirstChild('Owner') then
                    if v.Owner.Value == game.Players.LocalPlayer.Name then
                        return v
                    end
                end
            end
        end
 
        local Factory = tostring(CheckFactory())
        local basepart = workspace.Tycoons[Factory]:GetChildren()
 
        for i,v in pairs(basepart) do
            if v.Name == "Reversible Conveyor" then
                for _,desc in pairs(v:GetDescendants()) do
                    if desc:IsA("ClickDetector") then
                        if desc.Parent:IsA('Part') then
                            ClickEvent:FireServer(desc.Parent)
                        end
                    end
                end
            end
        end
        notify'Switching ALL Reversible Conveyors'
    end
end)
 
mouse.KeyDown:connect(function(key)
    if key == "j" then
        if remoteclickstarted == true then
            remoteclickstarted = false
            remoteclickactive = false
            notify'Remote Clicking turned OFF'
        else
            remoteclickstarted = true
            remoteclickactive = true
            notify'Remote Clicking turned ON'
        end
    end
end)
 
mouse.KeyDown:connect(function(key)
    if key == "h" then
        if upgraderclickstarted == true then
            upgraderclickstarted = false
            upgraderclickactive = false
            notify'Clicking Upgraders turned OFF'
        else
            upgraderclickstarted = true
            upgraderclickactive = true
            notify'Clicking Upgraders turned ON'
        end
    end
end)
 
function CountBricks()
  local count = 0
    for i,v in pairs(workspace:GetChildren()) do
        for x in string.gmatch(v.Name, "Crate") do
            if v.Name ~= "GiftCrate" then
                wait(0.1)
                count = count + 1
            end
        end
    end
    for i,v in pairs(workspace.Shadows:GetChildren()) do
        for x in string.gmatch(v.Name, "Crate") do
            wait(0.1)
            count = count + 1
        end
    end
   return count
end
 
spawn (function()
    while true do
        wait(0.1)
        CountTpCrates.Text = CountBricks()
    end
end)

wait(0.5)local ba=Instance.new("ScreenGui")
local ca=Instance.new("TextLabel")local da=Instance.new("Frame")
local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui
ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true
ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ca.Draggable=true
ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,304,0,52)
ca.Font=Enum.Font.SourceSansSemibold;ca.Text="Anti Afk Kick Script"ca.TextColor3=Color3.new(0,1,1)
ca.TextSize=22;da.Parent=ca
da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)da.Position=UDim2.new(0,0,1.0192306,0)
da.Size=UDim2.new(0,304,0,107)_b.Parent=da
_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)_b.Position=UDim2.new(0,0,0.800455689,0)
_b.Size=UDim2.new(0,304,0,21)_b.Font=Enum.Font.Arial;_b.Text="Made by Warn"
_b.TextColor3=Color3.new(1,1,1)_b.TextSize=20;ab.Parent=da
ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ab.Position=UDim2.new(0,0,0.158377379,0)
ab.Size=UDim2.new(0,304,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="Status: Script Started"
ab.TextColor3=Color3.new(1,1,1)ab.TextSize=20;local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
bb:CaptureController()bb:ClickButton2(Vector2.new())
ab.Text="You went idle and ROBLOX tried to kick you but we reflected it!"wait(2)ab.Text="Script Re-Enabled"end)

-- Credit to Bork for the scripts!


local MinersHavenGUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local BodyFrame = Instance.new("Frame")
local AutoRebirth = Instance.new("TextButton")
local AutoRemote = Instance.new("TextButton")
local TPUpgraders = Instance.new("TextButton")
local Instructions = Instance.new("TextButton")
local Credits = Instance.new("TextLabel")
local Divider = Instance.new("TextLabel")
local InstructionSteps = Instance.new("Frame")
local Step1 = Instance.new("TextLabel")
local Step2 = Instance.new("TextLabel")
local Step0 = Instance.new("TextLabel")
local Step3 = Instance.new("TextLabel")
local Step4 = Instance.new("TextLabel")
local AutoLayout1 = Instance.new("TextButton")
local AutoLayout2 = Instance.new("TextButton")
local AutoLayout3 = Instance.new("TextButton")
local AutoLayout = Instance.new("TextLabel")
local Destroy = Instance.new("TextButton")
local Mini = Instance.new("TextButton")
local Name = Instance.new("TextLabel")
--Properties:
MinersHavenGUI.Name = "MinersHavenGUI"
MinersHavenGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
MinersHavenGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = MinersHavenGUI
MainFrame.Active = true
MainFrame.BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.108695649, 0, 0.18427518, 0)
MainFrame.Selectable = true
MainFrame.Size = UDim2.new(0, 323, 0, 40)
MainFrame.Draggable = true

BodyFrame.Name = "BodyFrame"
BodyFrame.Parent = MainFrame
BodyFrame.BackgroundColor3 = Color3.new(1, 1, 1)
BodyFrame.BorderSizePixel = 0
BodyFrame.Position = UDim2.new(0, 0, 1, 0)
BodyFrame.Size = UDim2.new(0, 323, 0, 162)

AutoRebirth.Name = "AutoRebirth"
AutoRebirth.Parent = BodyFrame
AutoRebirth.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
AutoRebirth.BorderSizePixel = 0
AutoRebirth.Size = UDim2.new(0, 166, 0, 43)
AutoRebirth.Font = Enum.Font.SourceSans
AutoRebirth.Text = "Auto Rebirth: OFF"
AutoRebirth.TextColor3 = Color3.new(0, 0, 0)
AutoRebirth.TextSize = 14

AutoRemote.Name = "AutoRemote"
AutoRemote.Parent = BodyFrame
AutoRemote.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
AutoRemote.BorderSizePixel = 0
AutoRemote.Position = UDim2.new(0.4860681, 0, 0, 0)
AutoRemote.Size = UDim2.new(0, 166, 0, 43)
AutoRemote.Font = Enum.Font.SourceSans
AutoRemote.Text = "Auto Remote: OFF"
AutoRemote.TextColor3 = Color3.new(0, 0, 0)
AutoRemote.TextSize = 14

TPUpgraders.Name = "TPUpgraders"
TPUpgraders.Parent = BodyFrame
TPUpgraders.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
TPUpgraders.BorderSizePixel = 0
TPUpgraders.Position = UDim2.new(0.241486058, 0, 0.415868074, 0)
TPUpgraders.Size = UDim2.new(0, 166, 0, 43)
TPUpgraders.Font = Enum.Font.SourceSans
TPUpgraders.Text = "Upgrader CFrame"
TPUpgraders.TextColor3 = Color3.new(0, 0, 0)
TPUpgraders.TextSize = 14

Instructions.Name = "Instructions"
Instructions.Parent = BodyFrame
Instructions.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
Instructions.BorderSizePixel = 0
Instructions.Position = UDim2.new(0.365325123, 0, 0.722740173, 0)
Instructions.Size = UDim2.new(0, 87, 0, 25)
Instructions.Font = Enum.Font.SourceSans
Instructions.Text = "Instructions: OFF"
Instructions.TextColor3 = Color3.new(0, 0, 0)
Instructions.TextSize = 14

Credits.Name = "Credits"
Credits.Parent = BodyFrame
Credits.BackgroundColor3 = Color3.new(1, 1, 1)
Credits.BackgroundTransparency = 1
Credits.BorderSizePixel = 0
Credits.Position = UDim2.new(0.662538707, 0, 0.74125874, 0)
Credits.Size = UDim2.new(0, 109, 0, 37)
Credits.Font = Enum.Font.SourceSans
Credits.Text = "by Stefanuk12"
Credits.TextColor3 = Color3.new(0, 0, 0)
Credits.TextSize = 14

Divider.Name = "Divider"
Divider.Parent = BodyFrame
Divider.BackgroundColor3 = Color3.new(1, 1, 1)
Divider.BorderColor3 = Color3.new(0, 0, 0)
Divider.Position = UDim2.new(0, 0, 0.263662249, 0)
Divider.Size = UDim2.new(0, 323, 0, 0)
Divider.Font = Enum.Font.SourceSans
Divider.Text = " "
Divider.TextColor3 = Color3.new(0, 0, 0)
Divider.TextSize = 14

InstructionSteps.Name = "InstructionSteps"
InstructionSteps.Parent = BodyFrame
InstructionSteps.BackgroundColor3 = Color3.new(1, 1, 1)
InstructionSteps.BorderSizePixel = 0
InstructionSteps.Position = UDim2.new(1, 0, 0, 0)
InstructionSteps.Size = UDim2.new(0, 323, 0, 162)
InstructionSteps.Visible = false

Step1.Name = "Step1"
Step1.Parent = InstructionSteps
Step1.BackgroundColor3 = Color3.new(1, 1, 1)
Step1.BorderSizePixel = 0
Step1.Position = UDim2.new(0, 0, 0.240740746, 0)
Step1.Size = UDim2.new(0, 323, 0, 29)
Step1.Font = Enum.Font.SourceSansLight
Step1.Text = "1. Make a layout - Look at thread for more info"
Step1.TextColor3 = Color3.new(0, 0, 0)
Step1.TextSize = 14

Step2.Name = "Step2"
Step2.Parent = InstructionSteps
Step2.BackgroundColor3 = Color3.new(1, 1, 1)
Step2.BorderSizePixel = 0
Step2.Position = UDim2.new(0, 0, 0.419753045, 0)
Step2.Size = UDim2.new(0, 323, 0, 29)
Step2.Font = Enum.Font.SourceSansLight
Step2.Text = "2. Turn AutoRebirth/Remote ON"
Step2.TextColor3 = Color3.new(0, 0, 0)
Step2.TextSize = 14

Step0.Name = "Step0"
Step0.Parent = InstructionSteps
Step0.BackgroundColor3 = Color3.new(1, 1, 1)
Step0.BorderSizePixel = 0
Step0.Position = UDim2.new(0, 0, 0.0679011345, 0)
Step0.Size = UDim2.new(0, 323, 0, 29)
Step0.Font = Enum.Font.SourceSansLight
Step0.Text = "0. Find a game with people that have very high rebirths"
Step0.TextColor3 = Color3.new(0, 0, 0)
Step0.TextSize = 14

Step3.Name = "Step3"
Step3.Parent = InstructionSteps
Step3.BackgroundColor3 = Color3.new(1, 1, 1)
Step3.BorderSizePixel = 0
Step3.Position = UDim2.new(0, 0, 0.598765433, 0)
Step3.Size = UDim2.new(0, 323, 0, 29)
Step3.Font = Enum.Font.SourceSansLight
Step3.Text = "3. Press the Upgrader CFrame button and load the layout"
Step3.TextColor3 = Color3.new(0, 0, 0)
Step3.TextSize = 14

Step4.Name = "Step4"
Step4.Parent = InstructionSteps
Step4.BackgroundColor3 = Color3.new(1, 1, 1)
Step4.BorderSizePixel = 0
Step4.Position = UDim2.new(0, 0, 0.746913552, 0)
Step4.Size = UDim2.new(0, 323, 0, 29)
Step4.Font = Enum.Font.SourceSansLight
Step4.Text = "4. Once you've rebirthed, Repeat from Step 3"
Step4.TextColor3 = Color3.new(0, 0, 0)
Step4.TextSize = 14

AutoLayout1.Name = "AutoLayout1"
AutoLayout1.Parent = BodyFrame
AutoLayout1.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
AutoLayout1.BorderSizePixel = 0
AutoLayout1.Position = UDim2.new(0, 0, 0.839506149, 0)
AutoLayout1.Size = UDim2.new(0, 22, 0, 26)
AutoLayout1.Font = Enum.Font.SourceSans
AutoLayout1.Text = "1"
AutoLayout1.TextColor3 = Color3.new(0, 0, 0)
AutoLayout1.TextSize = 14

AutoLayout2.Name = "AutoLayout2"
AutoLayout2.Parent = BodyFrame
AutoLayout2.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
AutoLayout2.BorderSizePixel = 0
AutoLayout2.Position = UDim2.new(0.067079477, 0, 0.839506149, 0)
AutoLayout2.Size = UDim2.new(0, 22, 0, 26)
AutoLayout2.Font = Enum.Font.SourceSans
AutoLayout2.Text = "2"
AutoLayout2.TextColor3 = Color3.new(0, 0, 0)
AutoLayout2.TextSize = 14

AutoLayout3.Name = "AutoLayout3"
AutoLayout3.Parent = BodyFrame
AutoLayout3.BackgroundColor3 = Color3.new(0.956863, 0.956863, 0.956863)
AutoLayout3.BorderSizePixel = 0
AutoLayout3.Position = UDim2.new(0.134158954, 0, 0.839506149, 0)
AutoLayout3.Size = UDim2.new(0, 22, 0, 26)
AutoLayout3.Font = Enum.Font.SourceSans
AutoLayout3.Text = "3"
AutoLayout3.TextColor3 = Color3.new(0, 0, 0)
AutoLayout3.TextSize = 14

AutoLayout.Name = "AutoLayout"
AutoLayout.Parent = BodyFrame
AutoLayout.BackgroundColor3 = Color3.new(1, 1, 1)
AutoLayout.BackgroundTransparency = 1
AutoLayout.BorderSizePixel = 0
AutoLayout.Position = UDim2.new(0, 0, 0.697530866, 0)
AutoLayout.Size = UDim2.new(0, 65, 0, 29)
AutoLayout.Font = Enum.Font.SourceSans
AutoLayout.Text = "Auto Layout"
AutoLayout.TextColor3 = Color3.new(0, 0, 0)
AutoLayout.TextSize = 14

Destroy.Name = "Destroy"
Destroy.Parent = MainFrame
Destroy.BackgroundColor3 = Color3.new(1, 1, 1)
Destroy.BackgroundTransparency = 1
Destroy.BorderSizePixel = 0
Destroy.Position = UDim2.new(0.801857591, 0, 0, 0)
Destroy.Size = UDim2.new(0, 64, 0, 40)
Destroy.Font = Enum.Font.SourceSans
Destroy.Text = "X"
Destroy.TextColor3 = Color3.new(0, 0, 0)
Destroy.TextSize = 14

Mini.Name = "Mini"
Mini.Parent = MainFrame
Mini.BackgroundColor3 = Color3.new(1, 1, 1)
Mini.BackgroundTransparency = 1
Mini.BorderSizePixel = 0
Mini.Position = UDim2.new(0.603715181, 0, 0, 0)
Mini.Size = UDim2.new(0, 64, 0, 40)
Mini.Font = Enum.Font.SourceSans
Mini.Text = "_"
Mini.TextColor3 = Color3.new(0, 0, 0)
Mini.TextSize = 14

Name.Name = "Name"
Name.Parent = MainFrame
Name.BackgroundColor3 = Color3.new(1, 1, 1)
Name.BackgroundTransparency = 1
Name.BorderSizePixel = 0
Name.Size = UDim2.new(0, 195, 0, 40)
Name.Font = Enum.Font.SourceSansLight
Name.Text = "Rebirthing Tool - Miners Haven"
Name.TextColor3 = Color3.new(0, 0, 0)
Name.TextSize = 14

-- Scripts:

_G.AutoRebirth = false
_G.AutoRemote = false


Destroy.MouseButton1Click:connect(function() -- Destory GUI
    MinersHavenGUI:Destroy()
end)

Mini.MouseButton1Click:connect(function() -- Minimise/Restore GUI
    if BodyFrame.Visible == true then
        BodyFrame.Visible = false
        else BodyFrame.Visible = true
    end
end)

Instructions.MouseButton1Click:connect(function() -- Minimise/Restore Instructions
    if InstructionSteps.Visible == false then
        InstructionSteps.Visible = true
        Instructions.Text = "Instructions: ON"
    else InstructionSteps.Visible = false
        Instructions.Text = "Instructions: OFF"
    end
end)

AutoRebirth.MouseButton1Click:connect(function() -- Toggle work for AutoRebirth
    if _G.AutoRebirth == false then
        _G.AutoRebirth = true
        AutoRebirth.Text = "Auto Rebirth: ON"
    else _G.AutoRebirth = false
        AutoRebirth.Text = "Auto Rebirth: OFF"
    end
    while _G.AutoRebirth == true do wait()
        game.ReplicatedStorage.Rebirth:InvokeServer()
    end
end)

AutoRemote.MouseButton1Click:connect(function() -- Toggle work for AutoRemote
    if _G.AutoRemote == false then
        _G.AutoRemote = true
        AutoRemote.Text = "Auto Remote: ON"
    else _G.AutoRemote = false
        AutoRemote.Text = "Auto Remote: OFF"
    end
    while _G.AutoRemote == true do wait()
        game.ReplicatedStorage.RemoteDrop:FireServer()
    end
end)

TPUpgraders.MouseButton1Click:connect(function() -- Teleports all of the upgraders into the conveyor
    game.ReplicatedStorage.DestroyAll:InvokeServer()
local Tycoon = workspace.Tycoons:FindFirstChild(tostring(game.Players.LocalPlayer.PlayerTycoon.Value)) 
local PlaceItem = game.ReplicatedStorage.PlaceItem 
local placehere = CFrame.new(0, 2, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon:FindFirstChild("Base").Position
PlaceItem:InvokeServer("Basic Conveyor",  placehere)
wait(0.01) 
local pt = game.Players.LocalPlayer.PlayerTycoon.Value
local cv = game.Players.LocalPlayer.PlayerTycoon.Value["Basic Conveyor"].Hitbox
for i,v in pairs(game.Workspace.Tycoons:GetDescendants()) do
if v.Name == "Big Bad Blaster" or v.Name == "Flaming Schrodinger" or v.Name == "Schrodinger Evaluator" or v.Name == "Super Schrodinger" or v.Name == "Ore Illuminator" or v.Name == "Ore Crane" or v.Name == "Portable Flamethrower" or v.Name == "Flaming Ore Scanner" or v.Name == "Chemical Refiner" or v.Name == "Pirate Cove" or v.Name == "Dragonglass Blaster" or v.Name == "Dragon Blaster" or v.Name == "Clover Blaster" or v.Name == "Hydra Blaster" or v.Name == "Aether Schrodinger" or v.Name == "Ore Indoctrinator" or v.Name == "Arcane Lightning" then
v:Remove()
end
end
for i,v in pairs(game.Workspace.Tycoons:GetDescendants()) do
if v.Name == "Upgrade" then
v.Transparency = 1
v.CFrame = cv.CFrame*CFrame.new(0,100,0)
end
end
for i,v in pairs(game.Workspace.Tycoons:GetDescendants()) do
if v.Name == "Morning Star" or v.Name == "Nova Star" then
v:Remove()
elseif v.Name == "Tesla Resetter" or v.Name == "Tesla Refuter" then
v.Model.Upgrade.CFrame = cv.CFrame*CFrame.new(0,50,0)
elseif v.Name == "The Final Upgrader" or v.Name == "The Ultimate Sacrifice" then
v.Model.Upgrade.CFrame = cv.CFrame*CFrame.new(0,75,0)
end
end
pt["Basic Conveyor"].Hitbox.Touched:connect(function(hit)
    if hit:FindFirstChild("Cash") then
if hit:FindFirstChild("Bork") then
local variable = true
else
local int = Instance.new("IntValue")
int.Parent = hit
int.Name = "Bork"
hit.CFrame = cv.CFrame*CFrame.new(0,100,0)
wait(0.05)
hit.CFrame = cv.CFrame*CFrame.new(0,50,0)
wait(0.05)
hit.CFrame = cv.CFrame*CFrame.new(0,100,0)
wait(0.05)
hit.CFrame = cv.CFrame*CFrame.new(0,75,0)
wait(0.05)
hit.CFrame = cv.CFrame*CFrame.new(0,100,0)
wait(0.5)
hit.CFrame = pt["Basic Furnace"].Model.Lava.CFrame
end
end
end)
end)

AutoLayout2.MouseButton1Down:connect(function() -- Layout 2 gets placed after Rebirth
game.Players.LocalPlayer.leaderstats.Life.Changed:connect(function(plr)
delay(7, function()
game.ReplicatedStorage.Layouts:InvokeServer("Load", "Layout2")
end)
end)
end)

AutoLayout3.MouseButton1Down:connect(function() -- Layout 3 gets placed after Rebirth
game.Players.LocalPlayer.leaderstats.Life.Changed:connect(function(plr)
delay(7, function()
game.ReplicatedStorage.Layouts:InvokeServer("Load", "Layout3")
end)
end)
end)


print("Rebirthing Tool by Stefanuk12. Scripts by Bork")
