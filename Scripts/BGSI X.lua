local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- Window
local Window = Library:CreateWindow("Demo Hub")
Window:load()

-- Tab (ใช้ AddTab แบบนี้เท่านั้น)
local MainTab = Window:AddTab("Main Tab")

-- Toggle
MainTab:Toggle({
    Title = "Auto Hatch",
    Description = "Auto hatch eggs",
    Flag = "AutoHatch",
    Callback = function(state)
        print("Auto Hatch:", state)
    end
})

-- Paragraph
MainTab:Paragraph({
    Title = "Info",
    Description = "This is a test paragraph."
})
