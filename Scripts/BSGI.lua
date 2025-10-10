-- 🌌 BGSI HUB - Deluxe Edition (v8.0 Ultra-Safe + Smart AutoSave)
-- ✅ Rayfield UI + Auto Hatch + Hatch Disable + Safety + Auto-Rehook
-- 🧠 By NiTroHub x ChatGPT Integration
-- ⚙️ ออกแบบให้เสถียร ปลอดภัย และอ่านเข้าใจง่าย

--------------------------------------------------------------------
-- 🧱 โหลด Library หลัก
--------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--------------------------------------------------------------------
-- 🧩 Services หลักของ Roblox
--------------------------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------
-- 🧠 ฟังก์ชันรอ Object อย่างปลอดภัย
--------------------------------------------------------------------
local function safeWait(parent, name, timeout)
    local ok, obj = pcall(function() return parent:WaitForChild(name, timeout or 10) end)
    if not ok then warn("⚠️ Missing:", name) end
    return obj
end

--------------------------------------------------------------------
-- 🔌 ตรวจหา Remote หลักของเกม
--------------------------------------------------------------------
local RemoteEvent = safeWait(ReplicatedStorage, "Shared")
if RemoteEvent then
    RemoteEvent = safeWait(RemoteEvent, "Framework")
    RemoteEvent = safeWait(RemoteEvent, "Network")
    RemoteEvent = safeWait(RemoteEvent, "Remote")
    RemoteEvent = safeWait(RemoteEvent, "RemoteEvent")
end
if not RemoteEvent then warn("❌ Missing RemoteEvent, บางฟังก์ชันอาจใช้ไม่ได้") end

--------------------------------------------------------------------
-- ⚙️ ตัวแปรหลัก (Settings / Flags)
--------------------------------------------------------------------
local flags = {
    BlowBubble = false,
    AutoClaimChest = false,
    AutoHatchEgg = false,
    DisableAnimation = true
}

local settings = {
    EggName = "Infinity Egg",
    HatchAmount = 6,
}

local tasks, conns = {}, {}
local hatchPatched = false

--------------------------------------------------------------------
-- 🎬 ปิดแอนิเมชัน HatchEgg (Ultra-Safe System)
--------------------------------------------------------------------
local function makeStub()
    local function noop(...) return nil end
    return setmetatable({
        Play=noop,Hatch=noop,Open=noop,Init=noop,
        Animate=noop,Create=noop,Show=noop,Hide=noop
    },{__call=noop,__index=function()return noop end})
end

local function patchModuleNoop(tbl)
    if type(tbl)~="table" then return end
    for k,v in pairs(tbl)do
        if type(v)=="function"then tbl[k]=function(...)return nil end end
    end
end

local function tryPatchLoadedModules(target)
    if typeof(getloadedmodules)~="function"then return false end
    for _,m in ipairs(getloadedmodules())do
        if m==target or (m.Name=="HatchEgg" and m.Parent and m.Parent.Name=="Effects")then
            local ok,lib=pcall(require,m)
            if ok and type(lib)=="table"then patchModuleNoop(lib)return true end
        end
    end
end

local function cleanHatchGUI()
    local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    local allowed = {
        ["hatchegg"]=true,["hatchanimation"]=true,["hatching"]=true,
        ["eggopen"]=true,["egg_ui"]=true,["hatch_ui"]=true,["eggpopup"]=true
    }
    for _,d in ipairs(pg:GetDescendants())do
        if d:IsA("ScreenGui")or d:IsA("Frame")or d:IsA("Folder")then
            if allowed[d.Name:lower()]then pcall(function()d:Destroy()end)end
        end
    end
end

local function patchHatchEgg()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local effects = client and client:FindFirstChild("Effects")
    if not effects then return end
    local target = effects:FindFirstChild("HatchEgg")
    if not target then return end

    local stub = makeStub()
    pcall(function()tryPatchLoadedModules(target)end)

    local env = (pcall(function()return getrenv()end) and getrenv()) or _G
    local req = (rawget(env or {}, "require") or require)
    if typeof(req)=="function" and hookfunction and not _G.HatchReqHooked then
        _G.HatchReqHooked = true
        local old; old=hookfunction(req,function(mod,...)
            if typeof(mod)=="Instance"and mod:IsA("ModuleScript")then
                if mod==target or(mod.Name=="HatchEgg"and mod.Parent and mod.Parent.Name=="Effects")then
                    return stub
                end
            end
            return old(mod,...)
        end)
    end

    if conns.HatchAuto then pcall(function()conns.HatchAuto:Disconnect()end)end
    conns.HatchAuto = effects.ChildAdded:Connect(function(child)
        if child.Name=="HatchEgg"then task.wait(0.5)
            pcall(function()tryPatchLoadedModules(child)cleanHatchGUI()end)
        end
    end)
end

local function DisableHatchAnimation()
    if hatchPatched then return end
    hatchPatched = true
    pcall(patchHatchEgg)
    pcall(cleanHatchGUI)
    Rayfield:Notify({Title="🎬 Hatch Animation Disabled",Content="Delta Auto-Rehook Active ✅",Duration=3})
end

-- 🔁 เรียกใช้โดยอัตโนมัติเมื่อสคริปต์โหลด
task.defer(function()
    task.wait(1)
    if flags.DisableAnimation then
        pcall(DisableHatchAnimation)
    end
end)

--------------------------------------------------------------------
-- 🔄 Core Loops (ฟังก์ชันหลัก)
--------------------------------------------------------------------
local function BlowBubbleLoop()pcall(function()RemoteEvent:FireServer("BlowBubble")end)task.wait(0.1)end
local function AutoClaimChestLoop()
    local chests={"Royal Chest","Super Chest","Golden Chest","Ancient Chest","Dice Chest","Infinity Chest",
        "Void Chest","Giant Chest","Ticket Chest","Easy Obby Chest","Medium Obby Chest","Hard Obby Chest"}
    for _,c in ipairs(chests)do pcall(function()RemoteEvent:FireServer("ClaimChest",c,true)end)end
    task.wait(3)
end
local function AutoHatchEggLoop()
    pcall(function()RemoteEvent:FireServer("HatchEgg",settings.EggName,settings.HatchAmount)end)
    task.wait(0.1)
end

local function stopLoop(name)
    flags[name]=false
    if tasks[name] then pcall(function()task.cancel(tasks[name])end)end
    tasks[name]=nil
end

local function startLoop(name,fn,delay)
    if tasks[name]then return end
    tasks[name]=task.spawn(function()
        while flags[name]do local ok,err=pcall(fn)
            if not ok then warn("[Loop Error:"..name.."]",err)end
            task.wait(delay or 0.1)
        end
        tasks[name]=nil
    end)
end

--------------------------------------------------------------------
-- 🪟 สร้าง UI หลัก (Rayfield)
--------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name="🌌 BGSI HUB",
    LoadingTitle="Loading NiTroHub...",
    LoadingSubtitle="By NiTroHub",
    ConfigurationSaving={Enabled=true,FolderName="NiTroHub",FileName="BGSI-Deluxe",Autosave=true,Autoload=true}
})

Rayfield:Notify({Title="✅ BGSI HUB Ready",Content="ระบบโหลดเสร็จสมบูรณ์",Duration=3})

--------------------------------------------------------------------
-- ⚙️ แท็บ Controls (คำสั่งหลัก)
--------------------------------------------------------------------
local Controls = Window:CreateTab("⚙️ Controls")

Controls:CreateToggle({Name="Blow Bubble",CurrentValue=false,Callback=function(v)
    flags.BlowBubble=v if v then startLoop("BlowBubble",BlowBubbleLoop,0.5) else stopLoop("BlowBubble") end
end})

Controls:CreateToggle({Name="Auto Claim All Chests",CurrentValue=false,Callback=function(v)
    flags.AutoClaimChest=v if v then startLoop("AutoClaimChest",AutoClaimChestLoop,3) else stopLoop("AutoClaimChest") end
end})

Controls:CreateToggle({Name="Auto Hatch (Custom Egg)",CurrentValue=false,Callback=function(v)
    flags.AutoHatchEgg=v
    if v then
        if flags.DisableAnimation then DisableHatchAnimation() end
        startLoop("AutoHatchEgg",AutoHatchEggLoop,0.15)
    else stopLoop("AutoHatchEgg") end
end})

Controls:CreateToggle({Name="Disable Hatch Animation (Auto-Rehook)",CurrentValue=flags.DisableAnimation,Callback=function(v)
    flags.DisableAnimation=v
    if v then DisableHatchAnimation()
    else Rayfield:Notify({Title="⚙️ Rejoin Required",Content="Rejoin เพื่อเปิด Animation กลับ",Duration=3}) end
end})

--------------------------------------------------------------------
-- 🥚 ตั้งค่า Egg / Hatch
--------------------------------------------------------------------
Controls:CreateInput({Name="Egg Name",PlaceholderText="Infinity Egg",RemoveTextAfterFocusLost=false,
    Callback=function(t)settings.EggName=t end})

Controls:CreateInput({Name="Hatch Amount (1/3/6/8/9/10/11/12)",PlaceholderText="6",RemoveTextAfterFocusLost=false,
    Callback=function(t)local n=tonumber(t)
    if n and (n==1 or n==3 or n==6 or n==8 or n==9 or n==10 or n==11 or n==12)then settings.HatchAmount=n
    else warn("⚠️ Invalid Hatch Amount")end end})

--------------------------------------------------------------------
-- 🛡️ Safety Tab (ระบบป้องกัน)
--------------------------------------------------------------------
local Safety = Window:CreateTab("🛡️ Safety")

Safety:CreateToggle({Name="Anti-AFK",CurrentValue=true,Callback=function(v)
    if conns.AFK then conns.AFK:Disconnect() conns.AFK=nil end
    if v then conns.AFK=LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end) end
end})

Safety:CreateButton({Name="♻️ Auto Reconnect",Callback=function()
    LocalPlayer.OnTeleport:Connect(function(s)
        if s==Enum.TeleportState.Failed then task.wait(3)TeleportService:Teleport(game.PlaceId)end
    end)
    Rayfield:Notify({Title="🌐 Auto Reconnect",Content="เปิดใช้งานแล้ว",Duration=3})
end})

Safety:CreateButton({Name="🕵️ Anti-Admin Detector",Callback=function()
    local words={"admin","mod","dev","staff"}
    Players.PlayerAdded:Connect(function(p)
        for _,w in ipairs(words)do
            if p.Name:lower():find(w)then
                for k in pairs(flags)do stopLoop(k)end
                Rayfield:Destroy()
                LocalPlayer:Kick("⚠️ Admin Detected. Script Stopped.")
            end
        end
    end)
end})

--------------------------------------------------------------------
-- ⚙️ Settings Tab (ตั้งค่า / บันทึกสถานะ)
--------------------------------------------------------------------
local Settings = Window:CreateTab("⚙️ Settings")

Settings:CreateButton({Name="💾 Save Current Toggles",Callback=function()
    writefile("NiTroHub_Toggles.json", game:GetService("HttpService"):JSONEncode(flags))
    Rayfield:Notify({Title="💾 Saved",Content="บันทึกสถานะการเปิด/ปิดแล้ว",Duration=2})
end})

Settings:CreateButton({Name="♻️ Load Saved Toggles",Callback=function()
    local s=pcall(function()
        local data=readfile("NiTroHub_Toggles.json")
        local loaded=game:GetService("HttpService"):JSONDecode(data)
        for k,v in pairs(loaded)do flags[k]=v end
        Rayfield:Notify({Title="✅ Loaded",Content="โหลดสถานะล่าสุดเรียบร้อย",Duration=2})
    end)
end})

Settings:CreateButton({Name="🧨 Destroy UI",Callback=function()
    for k in pairs(flags)do stopLoop(k)end
    Rayfield:Destroy()
end})
