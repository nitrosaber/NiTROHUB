-- โหลด NatUI Library
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/Uisource.lua"))()

-- 🔹 1) สร้าง Window หลัก
NatUI:Window({
    Title = "NatUI Library",
    Description = "made by whidd",
    Icon = "rbxassetid://3926305904"  -- ใช้ asset id จริง ๆ
})

-- 🔹 2) ปุ่มเปิด/ปิด UI
NatUI:OpenUI({
    Title = "NatUI Toggle",
    Icon = "rbxassetid://3926305904",
    BackgroundColor = "fromrgb",
    BorderColor = "fromrgb"
})

-- 🔹 3) เพิ่มแท็บใหม่
NatUI:AddTab({
    Title = "Main Tab",
    Desc = "แท็บทดสอบการใช้งาน",
    Icon = "rbxassetid://3926305904"
})

-- 🔹 4) เพิ่ม Section
NatUI:Section({
    Title = "Controls",
    Icon = "rbxassetid://3926305904"
})

-- 🔹 5) ปุ่มทดสอบ
NatUI:Button({
    Title = "Click Me!",
    Callback = function()
        print("✅ Button ถูกกดแล้ว")
    end,
})

-- 🔹 6) Toggle
NatUI:Toggle({
    Title = "Enable Feature",
    Callback = function(state)
        print("✅ Toggle:", state and "ON" or "OFF")
    end,
})

-- 🔹 7) Paragraph
NatUI:Paragraph({
    Title = "ℹ️ Info",
    Desc = "ข้อความทดสอบ Paragraph"
})

-- 🔹 8) Slider
NatUI:Slider({
    Title = "Volume",
    MaxValue = "100",
    Callback = function(value)
        print("✅ Slider Value:", value)
    end,
})
