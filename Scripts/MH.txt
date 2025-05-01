local players = game:GetService("Players")
local self = players.LocalPlayer
local char = self.Character
local root = char.HumanoidRootPart
local mouse = self:GetMouse()
local value = game:GetService("Players").LocalPlayer.Rebirths

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheAbsolutionism/Wally-GUI-Library-V2-Remastered/main/Library%20Code", true))() --//Wally UI Lib V2 Remastered by: https://forum.robloxscripts.com/showthread.php?tid=3180
library.options.underlinecolor = 'rainbow' --//makes the underline of each "window" rainbow
library.options.toggledisplay = 'Fill' --//Applies to all toggles, [Fill] OFF = RED, ON = GREEN [CHECK] OFF = BLANK,ON = CHECKMARK
local mainW = library:CreateWindow("NiTROHUB - MH") --//Name of window
local Section = mainW:Section('Farm',true)

--//Anti AFK
loadstring(game:HttpGet("https://raw.githubusercontent.com/batusz/main/roblox/__Anti__Afk__Script__", true))()

--//Enables Rebirth Farming
local reFarm = mainW:Toggle('Rebirth Farm',{flag = "rebfarm"},function()
    if mainW.flags.rebfarm then
        loadLayouts()
        farmRebirth()
    end
end)

--//User chooses if they want second layout to be used
local tFarm = mainW:Toggle('Enable Second Layout?',{flag = "seclayout"},function()
    --turned on lol
end)

--//Auto Rebirth Toggle
local autoReb = mainW:Toggle('Auto Rebirth',{flag = "aReb"},function()
    farmRebirth()
end)

--//Input time between layouts
local timeBox = mainW:Box('Time Between Lays',{
        default = 0;
        type = 'number';
        min = 0;
        max = 60; --//You can change this to math.huge if u want. (Currently set to 60 Seconds / 1 Minute)
        flag = 'duration';
        location = {getgenv()};
},function(new)
    getgenv().duration = new
end)

--//Select First Layout
mainW:Dropdown("First Layout", {
    default = 'First Layout';
    location = getgenv();
    flag = "layoutone";
    list = {
        "Layout1";
        "Layout2";
        "Layout3";
    }
}, function()
    print("Selected: ".. getgenv().layoutone)
end)

--//Select Second Layout
mainW:Dropdown("Second Layout", {
    default = 'Second Layout';
    location = getgenv();
    flag = "layoutwo";
    list = {
        "Layout1";
        "Layout2";
        "Layout3";
    }
}, function()
    print("Selected: ".. getgenv().layoutwo)
end)

function loadLayouts()
    task.spawn(function()
        game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load",getgenv().layoutone) --//Loads first layout
        task.wait(getgenv().duration) --//Duration between layouts
        if mainW.flags.seclayout then --//Checks if "Enable second layout" toggle is true
            game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load",getgenv().layoutwo) --//Loads second layout
        end
    end)
end

--//Auto Rebirth Function
function farmRebirth()
    task.spawn(function()
        while mainW.flags.aReb do
            game:GetService("ReplicatedStorage").Rebirth:InvokeServer(26) --// I dont know what "26" means dont change it.
            task.wait()
        end
    end)
end

--//Auto Load
value:GetPropertyChangedSignal("Value"):Connect(function()
    task.wait(0.75)
    if mainW.flags.rebfarm then
        loadLayouts()
    end
end)
--//Auto Load
