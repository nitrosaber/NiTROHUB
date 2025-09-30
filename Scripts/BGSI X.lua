-- โหลด NatUI
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/Uisource.lua"))()

-- สร้างหน้าต่างหลัก
NatUI:Window({
    Title = "🌐 NatUI - Test Script",
    Description = "ทดสอบการใช้งาน UI Library",
    Icon = "rbxassetid://3926305904"
})

-- ปุ่มเปิด/ปิด UI
NatUI:OpenUI({
    Title = "NatUI Toggle",
    Icon = "rbxassetid://3926305904",
    BackgroundColor = Color3.fromRGB(45, 45, 45),
    BorderColor = Color3.fromRGB(0, 0, 0)
})

-- เพิ่มแท็บ
NatUI:AddTab({
    Title = "Test Tab",
    Desc = "สำหรับทดสอบ",
    Icon = "rbxassetid://3926305904"
})

-- เพิ่ม Section
NatUI:Section({
    Title = "🎛 Controls",
    Icon = "rbxassetid://3926305904"
})

-- ปุ่มทดสอบ
NatUI:Button({
    Title = "Click Me!",
    Callback = function()
        print("[NatUI Test] Button ถูกกดแล้ว ✅")
    end,
})

-- Toggle ทดสอบ
NatUI:Toggle({
    Title = "Enable Feature",
    Callback = function(state)
        print("[NatUI Test] Toggle สถานะ:", state and "ON" or "OFF")
    end,
})

-- Paragraph แสดงข้อความ
NatUI:Paragraph({
    Title = "ℹ️ Info",
    Desc = "นี่คือ Paragraph สำหรับแสดงข้อความคงที่"
})

-- Slider ทดสอบ
NatUI:Slider({
    Title = "Volume Control",
    MaxValue = "100",
    Callback = function(value)
        print("[NatUI Test] Slider ค่า:", value)
    end,
})
