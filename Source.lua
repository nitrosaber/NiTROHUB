-- Source.lua
-- MIT License — ทำใช้/แก้/แจกได้
-- Feature: Window + Sidebar Tabs + Components + Keybind Manager + Config (per game) + Theme + Notify + Drag + Resize + Hotkey UI Toggle
-- Note: ถ้าไม่มี writefile/readfile ในสภาพแวดล้อม จะ fallback ไม่ error

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Http    = game:GetService("HttpService")
local LP      = Players.LocalPlayer

-- ===== Safe FS helpers =====
local function canFS()
    return (writefile and readfile and isfile) ~= nil
end
local function safe_isfile(p) return canFS() and isfile(p) end
local function safe_write(p, s) if canFS() then writefile(p, s) end end
local function safe_read(p) if canFS() then return readfile(p) end return nil end

-- ===== Library table =====
local Library = {}
Library.__index = Library

-- -------- Theme presets --------
Library.Themes = {
    Dark = {
        BG = Color3.fromRGB(22,22,26),
        Panel = Color3.fromRGB(33,33,38),
        Accent = Color3.fromRGB(0,170,255),
        Text = Color3.fromRGB(240,240,244),
        SubText = Color3.fromRGB(180,180,190),
        Stroke = Color3.fromRGB(70,70,80),
        Font = Enum.Font.Gotham
    },
    Neon = {
        BG = Color3.fromRGB(8,8,10),
        Panel = Color3.fromRGB(22,22,26),
        Accent = Color3.fromRGB(0,255,140),
        Text = Color3.fromRGB(200,255,240),
        SubText = Color3.fromRGB(120,200,180),
        Stroke = Color3.fromRGB(30,120,90),
        Font = Enum.Font.Ubuntu
    },
    Custom = {
        BG = Color3.fromRGB(18,18,18),
        Panel = Color3.fromRGB(28,28,32),
        Accent = Color3.fromRGB(200,200,200),
        Text = Color3.fromRGB(255,255,255),
        SubText = Color3.fromRGB(200,200,200),
        Stroke = Color3.fromRGB(90,90,90),
        Font = Enum.Font.FredokaOne
    }
}
Library.Theme = Library.Themes.Dark

-- -------- Runtime state --------
Library._screen     = nil
Library._window     = nil
Library._titlebar   = nil
Library._tabsFrame  = nil
Library._pagesFrame = nil
Library._notifyRoot = nil
Library._connections= {}
Library._hotkey     = Enum.KeyCode.RightShift -- toggle UI
Library._choosing   = false

-- -------- Config --------
Library.Config = {
    filePrefix = "MyUiLib",
    data = {
        _keybinds = {},     -- [flag] = "Enum.KeyCode.X"
        _theme    = "Dark", -- theme name
        _values   = {}       -- [flag] = value (toggle/slider/dropdown)
    }
}
function Library:_cfgPath(gameId)
    gameId = tostring(gameId or game.GameId)
    return string.format("%s_%s.json", self.Config.filePrefix, gameId)
end
function Library:Save()
    local path = self:_cfgPath(game.GameId)
    safe_write(path, Http:JSONEncode(self.Config.data))
end
function Library:Load()
    local path = self:_cfgPath(game.GameId)
    if safe_isfile(path) then
        local ok, decoded = pcall(function() return Http:JSONDecode(safe_read(path)) end)
        if ok and type(decoded) == "table" then
            self.Config.data = decoded
            local themeName = decoded._theme or "Dark"
            self:SetTheme(themeName, false)
        end
    end
end

-- -------- UI helpers --------
local function mk(parent, class)
    local o = Instance.new(class)
    o.Parent = parent
    return o
end
local function style_corner(obj, r)
    local c = mk(obj,"UICorner"); c.CornerRadius = UDim.new(0, r or 10)
end
local function style_stroke(obj, col)
    local s = mk(obj,"UIStroke"); s.Thickness = 1; s.Color = col
end
local function add_shadow(parent)
    local sh = mk(parent,"ImageLabel")
    sh.BackgroundTransparency = 1
    sh.Image = "rbxassetid://1316045217"
    sh.ImageTransparency = 0.6
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(10,10,118,118)
    sh.Size = UDim2.new(1,20,1,20)
    sh.Position = UDim2.new(0,-10,0,-10)
    sh.ZIndex = (parent.ZIndex or 1) - 1
end
local function gradient(obj, c1, c2)
    local g = mk(obj,"UIGradient")
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    }
    g.Rotation = 90
end

-- -------- Notifications --------
function Library:Notify(text, duration)
    duration = duration or 2
    local n = mk(self._notifyRoot, "Frame")
    n.BackgroundColor3 = self.Theme.Panel
    n.Size = UDim2.new(1, -20, 0, 32)
    n.Position = UDim2.new(0, 10, 0, 0)
    n.AutomaticSize = Enum.AutomaticSize.Y
    style_corner(n, 8); style_stroke(n, self.Theme.Stroke)

    local l = mk(n,"TextLabel")
    l.Size = UDim2.new(1,-12,1,-8); l.Position = UDim2.new(0,6,0,4)
    l.BackgroundTransparency = 1
    l.Text = tostring(text); l.TextColor3 = self.Theme.Text; l.Font = self.Theme.Font; l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        n.Visible = true
        task.wait(duration)
        n:Destroy()
    end)
end

-- -------- Build Window --------
function Library:CreateWindow(title, toggleHotkey) -- toggleHotkey: Enum.KeyCode
    self._screen = mk(LP:WaitForChild("PlayerGui"), "ScreenGui")
    self._screen.Name = "SourceUiLib"
    self._screen.IgnoreGuiInset = true
    self._screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    self._window = mk(self._screen, "Frame")
    self._window.Size = UDim2.new(0, 640, 0, 380)
    self._window.Position = UDim2.new(0.5, -320, 0.5, -190)
    self._window.BackgroundColor3 = self.Theme.BG
    self._window.BorderSizePixel = 0
    style_corner(self._window, 12); style_stroke(self._window, self.Theme.Stroke); add_shadow(self._window)

    -- titlebar
    self._titlebar = mk(self._window,"Frame")
    self._titlebar.Size = UDim2.new(1,0,0,42)
    self._titlebar.BackgroundColor3 = self.Theme.Panel
    self._titlebar.BorderSizePixel = 0; style_corner(self._titlebar,12); style_stroke(self._titlebar,self.Theme.Stroke)
    gradient(self._titlebar, self.Theme.Panel, self.Theme.BG)

    local titleLbl = mk(self._titlebar,"TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size = UDim2.new(1,-12,1,0); titleLbl.Position = UDim2.new(0,8,0,0)
    titleLbl.Text = tostring(title or "My UI Library")
    titleLbl.TextColor3 = self.Theme.Text; titleLbl.Font = self.Theme.Font; titleLbl.TextSize = 18
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- sidebar tabs
    self._tabsFrame = mk(self._window,"Frame")
    self._tabsFrame.Size = UDim2.new(0, 150, 1, -42)
    self._tabsFrame.Position = UDim2.new(0,0,0,42)
    self._tabsFrame.BackgroundColor3 = self.Theme.Panel; self._tabsFrame.BorderSizePixel = 0
    style_corner(self._tabsFrame,12); style_stroke(self._tabsFrame,self.Theme.Stroke)

    local tabsLayout = mk(self._tabsFrame,"UIListLayout")
    tabsLayout.Padding = UDim.new(0,6); tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- pages holder
    self._pagesFrame = mk(self._window,"Frame")
    self._pagesFrame.Size = UDim2.new(1, -150, 1, -42)
    self._pagesFrame.Position = UDim2.new(0,150,0,42)
    self._pagesFrame.BackgroundTransparency = 1

    -- notify root (top-right)
    self._notifyRoot = mk(self._screen,"Frame")
    self._notifyRoot.AnchorPoint = Vector2.new(1,0)
    self._notifyRoot.Position = UDim2.new(1,-16,0,16)
    self._notifyRoot.Size = UDim2.new(0, 280, 1, -32)
    self._notifyRoot.BackgroundTransparency = 1
    local notifyList = mk(self._notifyRoot,"UIListLayout")
    notifyList.FillDirection = Enum.FillDirection.Vertical
    notifyList.VerticalAlignment = Enum.VerticalAlignment.Top
    notifyList.Padding = UDim.new(0,8)

    -- drag window via title
    do
        local dragging, start, startPos = false, nil, nil
        self._titlebar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; start = i.Position; startPos = self._window.Position
            end
        end)
        self._titlebar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - start
                self._window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    -- resizer
    do
        local handle = mk(self._window,"Frame")
        handle.AnchorPoint = Vector2.new(1,1)
        handle.Position = UDim2.new(1, -8, 1, -8)
        handle.Size = UDim2.new(0, 16, 0, 16)
        handle.BackgroundColor3 = self.Theme.Accent; style_corner(handle,6)
        local dragging, start, startSize = false, nil, nil
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; start = i.Position; startSize = self._window.Size
            end
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                local d = i.Position - start
                self._window.Size = UDim2.new(startSize.X.Scale, startSize.X.Offset + d.X, startSize.Y.Scale, startSize.Y.Offset + d.Y)
            end
        end)
    end

    -- UI toggle hotkey
    self._hotkey = toggleHotkey or self._hotkey
    table.insert(self._connections, UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self._hotkey then
            self._window.Visible = not self._window.Visible
        end
    end))

    -- apply saved theme if any
    local t = self.Config.data._theme or "Dark"
    self:SetTheme(t, false)

    return self
end

-- -------- Theme switch & apply --------
function Library:SetTheme(themeName, save)
    local th = self.Themes[themeName]
    if not th then return end
    self.Theme = th
    if save then
        self.Config.data._theme = themeName
        self:Save()
    end
    -- walk & apply
    if self._screen then
        for _,ui in ipairs(self._screen:GetDescendants()) do
            if ui:IsA("TextLabel") or ui:IsA("TextButton") then
                ui.TextColor3 = th.Text
                ui.Font = th.Font
            elseif ui:IsA("Frame") or ui:IsA("ScrollingFrame") then
                if ui.BackgroundTransparency < 1 and ui ~= self._window then
                    ui.BackgroundColor3 = th.Panel
                end
            end
            if ui:IsA("UIStroke") then ui.Color = th.Stroke end
        end
        self._window.BackgroundColor3 = th.BG
    end
end

-- -------- Tabs / Pages --------
function Library:CreateTab(name, iconId) -- returns Tab object
    local tab = setmetatable({}, {__index = self})
    tab._lib = self
    tab.Name = tostring(name or "Tab")

    local btn = mk(self._tabsFrame,"TextButton")
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.BackgroundColor3 = self.Theme.Accent
    btn.TextColor3 = self.Theme.Text
    btn.Font = self.Theme.Font; btn.TextSize = 14
    btn.Text = (iconId and ("  "..tab.Name)) or tab.Name
    style_corner(btn,10); style_stroke(btn, self.Theme.Stroke)
    gradient(btn, self.Theme.Accent, Color3.fromRGB(0,0,0))

    if iconId then
        local ic = mk(btn,"ImageLabel")
        ic.BackgroundTransparency = 1
        ic.Image = "rbxassetid://"..tostring(iconId)
        ic.Size = UDim2.new(0,18,0,18)
        ic.Position = UDim2.new(0,8,0.5,-9)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = "     "..tab.Name
    end

    local page = mk(self._pagesFrame,"ScrollingFrame")
    page.Visible = false; page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0,0,0,0); page.ScrollBarThickness = 4
    page.BackgroundTransparency = 1
    local list = mk(page,"UIListLayout")
    list.Padding = UDim.new(0,8); list.SortOrder = Enum.SortOrder.LayoutOrder

    tab._button = btn; tab.Page = page

    btn.MouseButton1Click:Connect(function()
        for _,d in ipairs(self._pagesFrame:GetChildren()) do
            if d:IsA("ScrollingFrame") then d.Visible = false end
        end
        page.Visible = true
    end)
    if #self._tabsFrame:GetChildren() <= 2 then
        page.Visible = true
    end

    return tab
end

-- -------- Components (Tab methods) --------
local TabMt = {}
TabMt.__index = TabMt

-- generic Builder
local function sectionFrame(tab, height)
    local f = mk(tab.Page,"Frame")
    f.Size = UDim2.new(1, -16, 0, height or 40)
    f.BackgroundColor3 = tab._lib.Theme.Panel
    f.BorderSizePixel = 0; style_corner(f,10); style_stroke(f, tab._lib.Theme.Stroke)
    local l = mk(f,"UIListLayout"); l.Padding = UDim.new(0,6)
    return f
end

-- Button
function TabMt:Button(text, callback)
    local f = sectionFrame(self, 44)
    local b = mk(f,"TextButton")
    b.Size = UDim2.new(1,-10,1,-10); b.Position = UDim2.new(0,5,0,5)
    b.Text = tostring(text); b.Font = self._lib.Theme.Font; b.TextSize = 16
    b.TextColor3 = self._lib.Theme.Text; b.BackgroundColor3 = self._lib.Theme.Accent
    style_corner(b,8); style_stroke(b, self._lib.Theme.Stroke)
    gradient(b, self._lib.Theme.Accent, Color3.fromRGB(0,0,0))
    b.MouseButton1Click:Connect(function() if callback then callback() end end)
    return b
end

-- Toggle
function TabMt:Toggle(text, flag, default, callback)
    local f = sectionFrame(self, 44)
    local lbl = mk(f,"TextLabel")
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(0.7,0,1,0)
    lbl.Text = tostring(text); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = self._lib.Theme.Font; lbl.TextSize = 16; lbl.TextColor3 = self._lib.Theme.Text

    local btn = mk(f,"TextButton")
    btn.Size = UDim2.new(0.3,-8,1,-10); btn.Position = UDim2.new(0.7,8,0,5)
    btn.TextColor3 = self._lib.Theme.Text; btn.Font = self._lib.Theme.Font; btn.TextSize = 16
    style_corner(btn,8); style_stroke(btn, self._lib.Theme.Stroke)

    local state = self._lib.Config.data._values[flag] 
        if state == nil then state = default or false end
    local function apply()
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(40,170,90) or Color3.fromRGB(170,50,50)
    end
    apply()
    btn.MouseButton1Click:Connect(function()
        state = not state
        self._lib.Config.data._values[flag] = state
        apply()
        if callback then callback(state) end
    end)
    task.defer(function() if callback then callback(state) end end)
    return function(v) state = v; self._lib.Config.data._values[flag]=v; apply() end
end

-- Slider (int)
function TabMt:Slider(text, flag, min, max, default, callback)
    min, max = min or 0, max or 100
    local f = sectionFrame(self, 58)
    local lbl = mk(f,"TextLabel")
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1, -10, 0, 22); lbl.Position = UDim2.new(0,5,0,4)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Font = self._lib.Theme.Font; lbl.TextSize = 16
    lbl.TextColor3 = self._lib.Theme.Text

    local bar = mk(f,"Frame")
    bar.Size = UDim2.new(1,-10,0,14); bar.Position = UDim2.new(0,5,0,32)
    bar.BackgroundColor3 = Color3.fromRGB(70,70,80); style_corner(bar,8)

    local fill = mk(bar,"Frame")
    fill.BackgroundColor3 = self._lib.Theme.Accent; style_corner(fill,8)

    local val = tonumber(self._lib.Config.data._values[flag])
    if not val then val = default or min end
    local function setv(v)
        v = math.clamp(math.floor(v+0.5), min, max)
        self._lib.Config.data._values[flag] = v
        local ratio = (v-min)/(max-min)
        fill.Size = UDim2.new(ratio,0,1,0)
        lbl.Text = string.format("%s: %d", tostring(text), v)
        if callback then callback(v) end
    end
    setv(val)

    local dragging = false
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    bar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local ratio = (i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
            setv(min + (max-min)*math.clamp(ratio,0,1))
        end
    end)
    return setv
end

-- Dropdown (simple)
function TabMt:Dropdown(text, flag, options, default, callback)
    options = options or {}
    local f = sectionFrame(self, 44)
    local lbl = mk(f,"TextLabel")
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(0.5,0,1,0)
    lbl.Text = tostring(text); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = self._lib.Theme.Font; lbl.TextSize = 16; lbl.TextColor3 = self._lib.Theme.Text

    local btn = mk(f,"TextButton")
    btn.Size = UDim2.new(0.5,-8,1,-10); btn.Position = UDim2.new(0.5,8,0,5)
    btn.TextColor3 = self._lib.Theme.Text; btn.Font = self._lib.Theme.Font; btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(60,60,66); style_corner(btn,8); style_stroke(btn,self._lib.Theme.Stroke)
    btn.Text = "Select"

    local drop = mk(f,"Frame")
    drop.Visible = false; drop.BackgroundColor3 = self._lib.Theme.Panel
    drop.Size = UDim2.new(0.5,-8,0,100); drop.Position = UDim2.new(0.5,8,1,4)
    style_corner(drop,8); style_stroke(drop,self._lib.Theme.Stroke)
    local list = mk(drop,"UIListLayout"); list.Padding = UDim.new(0,4)

    local chosen = self._lib.Config.data._values[flag] or default
    if chosen then btn.Text = tostring(chosen) end

    local function choose(opt)
        chosen = opt
        self._lib.Config.data._values[flag] = opt
        btn.Text = tostring(opt)
        drop.Visible = false
        if callback then callback(opt) end
    end

    for _,opt in ipairs(options) do
        local o = mk(drop,"TextButton")
        o.BackgroundColor3 = Color3.fromRGB(70,70,78)
        o.TextColor3 = self._lib.Theme.Text; o.Font = self._lib.Theme.Font; o.TextSize = 14
        o.Size = UDim2.new(1,-8,0,24); o.Text = tostring(opt)
        style_corner(o,8)
        o.MouseButton1Click:Connect(function() choose(opt) end)
    end

    btn.MouseButton1Click:Connect(function() drop.Visible = not drop.Visible end)
    task.defer(function() if chosen and callback then callback(chosen) end end)
    return choose
end

-- Keybind picker (per-flag)
function TabMt:Keybind(text, flag, defaultKeyCode, onPress)
    local f = sectionFrame(self, 44)
    local lbl = mk(f,"TextLabel"); lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(0.6,0,1,0)
    lbl.Text = tostring(text); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = self._lib.Theme.Font; lbl.TextSize = 16; lbl.TextColor3 = self._lib.Theme.Text

    local btn = mk(f,"TextButton")
    btn.Size = UDim2.new(0.4,-8,1,-10); btn.Position = UDim2.new(0.6,8,0,5)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,66); btn.TextColor3 = self._lib.Theme.Text
    btn.Font = self._lib.Theme.Font; btn.TextSize = 16; style_corner(btn,8); style_stroke(btn,self._lib.Theme.Stroke)

    local stored = self._lib.Config.data._keybinds[flag]
    local cur = stored and stored:gsub("Enum.KeyCode.", "") or (defaultKeyCode and tostring(defaultKeyCode):gsub("Enum.KeyCode.", "") or "None")
    btn.Text = cur

    local choosing = false
    btn.MouseButton1Click:Connect(function()
        if choosing then return end
        choosing = true; btn.Text = "Press a key..."
        local conn; conn = UIS.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.Keyboard then
                choosing = false
                btn.Text = i.KeyCode.Name
                self._lib.Config.data._keybinds[flag] = tostring(i.KeyCode)
                self._lib:Save()
                if conn then conn:Disconnect() end
            end
        end)
    end)

    -- fire on press
    table.insert(self._lib._connections, UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.Keyboard then
            local want = self._lib.Config.data._keybinds[flag]
            if want and tostring(i.KeyCode) == want then
                if onPress then onPress() end
            end
        end
    end))

    return function(kc) -- setter
        self._lib.Config.data._keybinds[flag] = tostring(kc)
        btn.Text = (kc and kc.Name) or "None"
        self._lib:Save()
    end
end

-- Theme selector (Dropdown + Preview/Apply/Cancel)
function TabMt:ThemeSelector()
    local setPreview; local savedName = self._lib.Config.data._theme or "Dark"
    local applyBtn = self:Button("✅ Apply Theme", function()
        self._lib:SetTheme(savedName, true)
        self._lib:Notify("Theme saved: "..savedName, 2)
    end)
    local cancelBtn = self:Button("❌ Cancel Preview", function()
        self._lib:SetTheme(savedName, false)
        self._lib:Notify("Reverted to: "..savedName, 2)
    end)

    self:Dropdown("Theme", "_theme_pick", {"Dark","Neon","Custom"}, savedName, function(name)
        savedName = name
        self._lib:SetTheme(name, false) -- preview
    end)
end

-- Color pickers (simple RGB box: "r,g,b")
function TabMt:ColorPicker(label, targetKey) -- targetKey in {BG, Panel, Accent, Text, SubText, Stroke}
    local f = sectionFrame(self, 44)
    local tl = mk(f,"TextLabel"); tl.BackgroundTransparency=1; tl.Size=UDim2.new(0.5,0,1,0)
    tl.Text = label.." (R,G,B)"; tl.TextColor3=self._lib.Theme.Text; tl.Font=self._lib.Theme.Font; tl.TextSize=16; tl.TextXAlignment=Enum.TextXAlignment.Left

    local box = mk(f,"TextBox")
    box.Size = UDim2.new(0.5,-8,1,-10); box.Position = UDim2.new(0.5,8,0,5)
    box.Text = "255,255,255"; box.BackgroundColor3 = Color3.fromRGB(60,60,66)
    box.TextColor3=self._lib.Theme.Text; box.Font=self._lib.Theme.Font; box.TextSize=16; style_corner(box,8); style_stroke(box,self._lib.Theme.Stroke)

    box.FocusLost:Connect(function()
        local r,g,b = box.Text:match("(%d+),(%d+),(%d+)")
        r,g,b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b then
            Library.Themes.Custom[targetKey] = Color3.fromRGB(r,g,b)
            self._lib:SetTheme("Custom", true)
            self._lib:Notify("Custom "..targetKey.." updated", 2)
        else
            self._lib:Notify("Invalid RGB format. Example: 0,200,120", 2)
        end
    end)
end

-- mixins
function Library:MakeTabAPI(tab) return setmetatable(tab, TabMt) end

-- public: CreateTab wrapper that returns Tab API
function Library:Tab(name, iconId)
    local t = self:CreateTab(name, iconId)
    return self:MakeTabAPI(t)
end

-- cleanup
function Library:Destroy()
    for _,c in ipairs(self._connections) do pcall(function() c:Disconnect() end) end
    if self._screen then self._screen:Destroy() end
end

return Library
