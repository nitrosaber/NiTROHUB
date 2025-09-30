-- โหลด Library
local NiTRO = loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrosaber/NiTROHUB/refs/heads/main/Uisource.lua"))()

-- หาวิธีสร้างหน้าต่าง (รองรับหลายแบบ)
local create_window = NiTRO.Window or NiTRO.CreateWindow or NiTRO.New or NiTRO.Init

if not create_window then
    warn("⚠ ไม่พบเมธอด Window ใน Library นี้ ลองตรวจสอบชื่อฟังก์ชันอีกที")
    -- Debug: พิมพ์ออกมาดูว่ามีอะไรใน NiTRO
    for k,v in pairs(NiTRO) do
        print("พบฟังก์ชัน/ค่า:", k, v)
    end
    return
end

-- สร้างหน้าต่างหลัก
local win = create_window({
    Title = "NiTRO Hub | BGS Infinity",
    Description = "Auto Farm UI",
    Icon = "rbxassetid://12345678"
})

-- เพิ่มแท็บหลัก
local mainTab = NiTRO.AddTab and NiTRO:AddTab({
    Title = "Main",
    Desc = "Auto Features",
    Icon = "rbxassetid://12345678"
}) or win

-- Section
NiTRO.Section and NiTRO:Section({
    Title = "Auto Hatch",
    Icon = "rbxassetid://12345678"
})

------------------------------------------------
-- Auto Hatch Menu
------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

local selectedEgg = "Autumn Egg"
local hatchAmount = 1
local autoHatch = false

-- Dropdown เลือกไข่
NiTRO:Dropdown({
    Title = "Select Egg",
    Items = {"Autumn Egg","Basic Egg","Shiny Egg","Limited Egg"},
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
                task.wait(2)
            end
        end)
    end,
})
