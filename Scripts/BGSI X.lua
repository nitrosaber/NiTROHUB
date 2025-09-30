-- โหลดไลบรารี NatLibrary
local NatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/Source.lua"))()

-- สร้างหน้าต่าง UI
local Window = NatLib:Window({
    Title = "NatHub | BGS Infinity",
    Description = "ใช้ NatLibrary",
    Icon = "rbxassetid://123456"
})

-- เปิด UI toggle
NatLib:OpenUI({
    Title = "NatUI",
    Icon = "rbxassetid://123456",
    BackgroundColor = Color3.fromRGB(20,20,20),
    BorderColor = Color3.fromRGB(80,80,80)
})

-- เพิ่ม Tab
local mainTab = NatLib:AddTab({
    Title = "Main",
    Desc = "ฟีเจอร์หลัก",
    Icon = "rbxassetid://123456"
})

-- Section
NatLib:Section({
    Title = "Auto Hatch",
    Icon = "rbxassetid://123456"
})

-- Toggle Auto Hatch
local autoHatch = false
NatLib:Toggle({
    Title = "Auto Hatch",
    Callback = function(v)
        autoHatch = v
        task.spawn(function()
            while autoHatch do
                local args = {"HatchEgg", "Autumn Egg", 9}
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))
                task.wait(2)
            end
        end)
    end,
})

-- Button ตัวอย่าง
NatLib:Button({
    Title = "Collect Chests",
    Callback = function()
        print("Collect Chests")
    end,
})

-- Slider ตัวอย่าง
NatLib:Slider({
    Title = "WalkSpeed",
    MaxValue = 200,
    Callback = function(val)
        local p = game.Players.LocalPlayer
        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
        end
    end,
})
