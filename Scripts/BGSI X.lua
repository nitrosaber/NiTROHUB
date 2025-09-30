-- โหลด UI Library ที่แก้ไขแล้ว
local NiTroUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrosaber/NiTROHUB/refs/heads/main/Uisource.lua"))()

-- สร้างหน้าต่างหลัก
local Window = NiTroUI:Window("Bubble Gum Hub", "Auto Hatch Eggs", "rbxassetid://123456")

-- เพิ่มแท็บ Auto Farm
local Tab = NiTroUI:AddTab("Auto Farm", "Main Features", "rbxassetid://123456")

-- สถานะ Auto Hatch
local autoHatch = false

-- Toggle สำหรับ Auto Hatch
NiTroUI:Toggle("Auto Hatch", function()
    autoHatch = not autoHatch
    print("Auto Hatch: ", autoHatch)

    -- ทำงานใน Thread แยก
    task.spawn(function()
        while autoHatch do
            local args = {
                "HatchEgg",
                "Autumn Egg", -- ชื่อไข่ สามารถเปลี่ยนได้
                9             -- จำนวนครั้งต่อการ Fire
            }
            game:GetService("ReplicatedStorage")
                .Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))

            task.wait(0.5) -- หน่วงเวลา ป้องกัน disconnect
        end
    end)
end)

-- Button สำหรับ Collect All Chests
NiTroUI:Button("Collect All Chests", function()
    print("กำลังเก็บ chest ทั้งหมด")
    -- สามารถใส่โค้ด FireServer สำหรับ chest ได้ที่นี่
end)

return NiTroUI
