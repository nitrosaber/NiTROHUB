-- โหลด Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- Window หลัก
local Window = Library:CreateWindow("Bubble Gum Hub")
Window:load()

-- Tab Auto Farm
local FarmTab = Window:CreateTab({
    Title = "Auto Farm",
    Description = "ฟาร์มหลัก",
    Icon = "rbxassetid://3926305904"
})

-- Toggle : Auto Hatch
FarmTab:Toggle({
    Title = "Auto Hatch Egg",
    Description = "ฟักไข่อัตโนมัติ (Autumn Egg x3)",
    Flag = "AutoHatch",
    Callback = function(state)
        getgenv().AutoHatch = state
        while getgenv().AutoHatch do
            local args = {
                "HatchEgg",
                "Autumn Egg", -- เปลี่ยนชื่อไข่ได้
                3 -- จำนวน 1 / 3 / 9
            }
            game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))
            task.wait(1) -- เว้นระยะ 1 วิ
        end
    end
})

-- Button : เก็บทุก Chest
FarmTab:Button({
    Title = "Collect All Chests",
    Callback = function()
        print("กำลังเก็บ Chest ทั้งหมด (Demo)")
    end
})

-- Checkbox : เปิดปิดการแจ้งเตือน
FarmTab:Checkbox({
    Title = "Enable Notifications",
    Flag = "Notify",
    Callback = function(state)
        if state then
            Library.SendNotification({
                Title = "Notification",
                text = "เปิดการแจ้งเตือน",
                duration = 3
            })
        else
            print("ปิดการแจ้งเตือน")
        end
    end
})

-- Paragraph : แสดงคำอธิบาย
FarmTab:Paragraph({
    Title = "วิธีใช้",
    Description = "กด Auto Hatch เพื่อเริ่มฟักไข่อัตโนมัติ\nกด Collect Chest เพื่อเก็บกล่องทั้งหมด"
})

-- Slider : ความเร็ว
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
FarmTab:Divider("ตั้งค่าอื่น ๆ")

-- Text : สถานะ
FarmTab:Text({
    Title = "Status",
    Description = "พร้อมทำงาน"
})

-- Input : ตั้งชื่อไข่ที่ต้องการฟักเอง
FarmTab:Input({
    Title = "Egg Name",
    Placeholder = "ใส่ชื่อไข่ตรงนี้ เช่น Autumn Egg",
    Flag = "EggName",
    Callback = function(text)
        print("คุณตั้งชื่อไข่เป็น:", text)
        getgenv().EggName = text
    end
})

-- แจ้งเตือนเมื่อโหลดเสร็จ
Library.SendNotification({
    Title = "Bubble Gum Hub Loaded",
    text = "ระบบพร้อมใช้งานแล้ว!",
    duration = 5
})
