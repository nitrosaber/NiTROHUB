-- โหลด Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatLibrary/SourceV2.lua"))()

-- Window หลัก
local Window = Library:CreateWindow("Bubble Gum Hub")
Window:load()

-- Debug ดูว่ามี function อะไร
print("==== Window Functions ====")
for k,v in pairs(Window) do
    print(k, typeof(v))
end
