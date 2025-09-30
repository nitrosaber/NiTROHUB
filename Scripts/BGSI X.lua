local NiTroUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrosaber/NiTROHUB/refs/heads/main/Uisource.lua"))()

print("NiTroUI type:", typeof(NiTroUI))
for k,v in pairs(NiTroUI) do
    print("Key:", k, "| Type:", typeof(v))
end
