-- โหลด Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- สร้างหน้าต่างหลัก
local Window = Library:CreateWindow("Demo Hub")
Window:load()

-- สร้าง Tab หลัก
local MainTab = Window:AddTab({
    Title = "Main Tab",
    Description = "ทดสอบระบบ",
    Icon = "rbxassetid://3926305904" -- ต้องเป็น string assetid
})

-- Toggle
MainTab:Toggle({
    Title = "Auto Hatch Egg",
    Description = "เปิด/ปิดการฟักไข่",
    Flag = "AutoHatch",
    Callback = function(state)
        print("Auto Hatch =", state)
    end
})

-- Button
MainTab:Button({
    Title = "Collect All Chests",
    Callback = function()
        print("เก็บ Chest ทั้งหมดแล้ว")
    end
})

-- Checkbox
MainTab:Checkbox({
    Title = "Enable Notifications",
    Flag = "Notify",
    Callback = function(state)
        print("Notifications =", state)
    end
})

-- Paragraph
MainTab:Paragraph({
    Title = "คำอธิบาย",
    Description = "นี่คือตัวอย่าง Paragraph จาก Library"
})

-- Slider
MainTab:Slider({
    Title = "Walk Speed",
    Min = 16,
    Max = 200,
    Flag = "WalkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Divider
MainTab:Divider("การตั้งค่าอื่น ๆ")

-- Text
MainTab:Text({
    Title = "Status",
    Description = "พร้อมใช้งาน"
})

-- Input
MainTab:Input({
    Title = "Egg Name",
    Placeholder = "พิมพ์ชื่อไข่ เช่น Autumn Egg",
    Flag = "EggName",
    Callback = function(text)
        print("คุณตั้งชื่อไข่เป็น:", text)
    end
})

-- แจ้งเตือนเมื่อโหลดเสร็จ
Library.SendNotification({
    Title = "Demo Hub",
    text = "ระบบพร้อมใช้งานแล้ว!",
    duration = 5
})
