-- โหลด Library
local NiTRO = loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrosaber/NiTROHUB/refs/heads/main/Uisource.lua"))()

-- เช็คว่าโหลดได้ไหม
if not NiTRO then
    warn("❌ โหลด Library ไม่สำเร็จ")
    return
end

-- Debug print ใน Console
print("=== [NiTRO Debug] แสดงฟังก์ชันและค่าทั้งหมดใน Library ===")
for k, v in pairs(NiTRO) do
    print("Key:", k, "| Type:", typeof(v))
end
