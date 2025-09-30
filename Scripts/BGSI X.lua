-- โหลด Library
local NiTRO = loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrosaber/NiTROHUB/refs/heads/main/Uisource.lua"))()

if not NiTRO then
    warn("❌ โหลด NiTRO UI Library ไม่สำเร็จ")
    return
end

-- หาวิธีสร้าง Window (ลองหลายชื่อ)
local create_window = NiTRO.Window or NiTRO.CreateWindow or NiTRO.New or NiTRO.Init
local win

if create_window then
    win = create_window({
        Title = "NiTRO Hub | Auto Debug",
        Description = "List all functions automatically",
        Icon = "rbxassetid://12345678"
    })
else
    warn("⚠ Library ไม่มี Window/CreateWindow/New/Init")
end

-- เพิ่มแท็บ Debug
local debugTab
if NiTRO.AddTab then
    debugTab = NiTRO:AddTab({
        Title = "Debug",
        Desc = "List of functions",
        Icon = "rbxassetid://12345678"
    })
end

-- 🔍 ฟังก์ชัน list อัตโนมัติ
local function autoList()
    print("🔎 [NiTRO Auto Debug] ฟังก์ชันทั้งหมดใน Library ↓↓↓")
    for k,v in pairs(NiTRO) do
        print("Key:", k, "Type:", typeof(v))
        -- ถ้า Lib มีปุ่ม → สร้างปุ่มใน Debug Tab
        if NiTRO.Button and debugTab then
            NiTRO:Button({
                Title = tostring(k) .. " (" .. typeof(v) .. ")",
                Callback = function()
                    print("กดปุ่ม:", k, v)
                end,
            })
        end
    end
end

-- เรียกทำงานทันที
autoList()
