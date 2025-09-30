local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

-- โหลด NiTRO UI
local NiTRO = loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrosaber/NiTROHUB/refs/heads/main/Uisource.lua"))()

NiTRO:Window({
    Title = "NiTRO Hub | BGS Infinity",
    Description = "Auto Farm UI",
    Icon = "rbxassetid://12345678"
})

local mainTab = NiTRO:AddTab({
    Title = "Main",
    Desc = "Auto Features",
    Icon = "rbxassetid://12345678"
})

------------------------------------------------
-- Auto Hatch Menu
------------------------------------------------

-- เก็บค่าเลือก
local selectedEgg = "Autumn Egg"
local hatchAmount = 1
local autoHatch = false

-- Dropdown เลือกไข่
NiTRO:Dropdown({
    Title = "Select Egg",
    Items = {
        "Autumn Egg",
        "Basic Egg",
        "Shiny Egg",
        "Limited Egg"
    },
    Callback = function(choice)
        selectedEgg = choice
        print("เลือกไข่:", choice)
    end,
})

-- Slider เลือกจำนวนเปิด (1,3,9)
NiTRO:Slider({
    Title = "Hatch Amount",
    MaxValue = 9,
    Callback = function(val)
        -- ทำให้เป็น 1,3,9 เท่านั้น
        if val < 2 then
            hatchAmount = 1
        elseif val < 6 then
            hatchAmount = 3
        else
            hatchAmount = 9
        end
        print("จำนวนเปิด:", hatchAmount)
    end,
})

-- Toggle Auto Hatch
NiTRO:Toggle({
    Title = "Auto Hatch",
    Callback = function(v)
        autoHatch = v
        task.spawn(function()
            while autoHatch do
                local args = {"HatchEgg", selectedEgg, hatchAmount}
                RemoteEvent:FireServer(unpack(args))
                task.wait(2) -- ปรับ delay ให้เหมาะ
            end
        end)
    end,
})
