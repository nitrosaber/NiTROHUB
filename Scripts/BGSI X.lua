-- โหลด Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- สร้างหน้าต่างหลัก
local Window = Library:CreateWindow("Demo Hub")
Window:load()

-- เพิ่ม Tab หลัก
local MainTab = Window:AddTab("Main Tab", "รวมตัวอย่างทั้งหมด")

-- Toggle
MainTab:Toggle({
    Title = "Auto Hatch",
    Description = "เปิด/ปิดการฟักไข่อัตโนมัติ",
    Flag = "AutoHatch",
    Callback = function(state)
        print("Auto Hatch = ", state)
    end
})

-- Checkbox
MainTab:Checkbox({
    Title = "Enable Notifications",
    Flag = "Notify",
    Callback = function(state)
        if state then
            Library.SendNotification({
                Title = "แจ้งเตือน",
                text = "เปิดการแจ้งเตือนแล้ว",
                duration = 3
            })
        else
            print("ปิดการแจ้งเตือน")
        end
    end
})

-- Paragraph
MainTab:Paragraph({
    Title = "คำอธิบาย",
    Description = "นี่คือตัวอย่างการใช้ Paragraph สำหรับแสดงข้อความยาว ๆ หรืออธิบายฟีเจอร์"
})

-- Slider
MainTab:Slider({
    Title = "Speed",
    Min = 1,
    Max = 100,
    Flag = "WalkSpeed",
    Callback = function(value)
        print("Walk Speed:", value)
    end
})

-- Divider
MainTab:Divider("เส้นแบ่ง UI")

-- Text
MainTab:Text({
    Title = "สถานะ",
    Description = "กำลังทำงาน..."
})

-- Input
MainTab:Input({
    Title = "ตั้งค่าชื่อ",
    Placeholder = "พิมพ์ชื่อตรงนี้...",
    Flag = "PlayerName",
    Callback = function(text)
        print("คุณพิมพ์ว่า:", text)
    end
})

-- ตัวอย่าง Notification ทันทีเมื่อรัน
Library.SendNotification({
    Title = "Demo Hub Loaded",
    text = "สคริปต์ตัวอย่างทำงานแล้ว!",
    duration = 5
})
