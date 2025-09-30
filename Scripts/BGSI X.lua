-- โหลด NatUI Library
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/Uisource.lua"))()

-- สร้างหน้าต่างหลัก
NatUI:Window({
    Title = "NatUI Test Window",
    Description = "ทดสอบการใช้งาน UI",
    Icon = "rbxassetid://3926305904"
})

-- ปุ่มเปิด/ปิด UI
NatUI:OpenUI({
    Title = "NatUI Toggle",
    Icon = "rbxassetid://3926305904",
    BackgroundColor = "fromrgb",
    BorderColor = "fromrgb"
})

-- เพิ่มแท็บใหม่
NatUI:AddTab({
    Title = "Test Tab",
    Desc = "แท็บสำหรับทดสอบ",
    Icon = "rbxassetid://3926305904"
})

-- เพิ่ม Section
NatUI:Section({
    Title = "Controls",
    Icon = "rbxassetid://3926305904"
})

-- ปุ่ม
NatUI:Button({
    Title = "Click Me!",
    Callback = function()
        print("✅ Button ถูกกดแล้ว")
    end,
})

-- Toggle
NatUI:Toggle({
    Title = "Enable Feature",
    Callback = function(state)
        print("✅ Toggle State:", state and "ON" or "OFF")
    end,
})

-- Paragraph
NatUI:Paragraph({
    Title = "ℹ️ Info",
    Desc = "นี่คือข้อความทดสอบ Paragraph"
})

-- Slider
NatUI:Slider({
    Title = "Volume",
    MaxValue = "100",
    Callback = function(value)
        print("✅ Slider Value:", value)
    end,
})
