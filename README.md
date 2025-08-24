-- LennonStyleUI v1.2 (mobile-first, completo, estilo Lennon Hub)
-- Cole todo este bloco em um único script / ModuleScript.
-- Retorna: LennonStyleUI

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function new(class, props)
    local inst = Instance.new(class)
    if props then for k,v in pairs(props) do inst[k] = v end end
    return inst
end

local function corner(obj, r) local c = new("UICorner",{CornerRadius=UDim.new(0,r or 8)}); c.Parent = obj; return c end
local function pad(obj, px) local p = new("UIPadding",{PaddingLeft=UDim.new(0,px),PaddingRight=UDim.new(0,px),PaddingTop=UDim.new(0,px),PaddingBottom=UDim.new(0,px)}); p.Parent = obj; return p end
local function stroke(obj, t, col, trans) local s=new("UIStroke",{Thickness=t or 1, Color=col or Color3.new(0,0,0),Transparency=trans or 0.7}); s.Parent=obj; return s end
local function gradient(obj,a,b) local g=new("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,a),ColorSequenceKeypoint.new(1,b)}}); g.Parent=obj; return g end

-- Theme (Lennon-like)
local DEFAULT = {
    Bg = Color3.fromRGB(20,20,22),
    Panel = Color3.fromRGB(28,28,30),
    Top = Color3.fromRGB(34,34,36),
    Accent = Color3.fromRGB(58,120,255), -- subtle blue
    Muted = Color3.fromRGB(150,150,160),
    Text = Color3.fromRGB(240,240,242),
    Good = Color3.fromRGB(38,185,154),
    Warn = Color3.fromRGB(255,179,0),
    Bad  = Color3.fromRGB(235,70,90)
}

local LennonStyleUI = {}
LennonStyleUI.__index = LennonStyleUI

-- persistence helpers
local function saveConfig(id, data)
    getgenv().LennonUIConfig = getgenv().LennonUIConfig or {}
    getgenv().LennonUIConfig[id] = data
end
local function loadConfig(id) return (getgenv().LennonUIConfig or {})[id] end

-- small animation helper
local function tween(obj, props, time, style, dir) TweenService:Create(obj, TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play() end

-- Create window
function LennonStyleUI:CreateWindow(opts)
    opts = opts or {}
    local id = opts.Id or ("LennonUI_"..tostring(math.random(1000,9999)))
    local title = opts.Title or "LennonStyle"
    local subtitle = opts.Subtitle or ""
    local theme = opts.Theme or DEFAULT

    local screen = new("ScreenGui",{Name="LennonUI_"..id, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    screen.Parent = CoreGui

    -- UIScale for mobile
    local us = new("UIScale",{Scale = 1})
    us.Parent = screen
    local function adapt()
        local v = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
        us.Scale = (v.X < 900 or v.Y < 600) and 0.92 or 1
    end
    adapt()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adapt)

    -- root frame (center)
    local root = new("Frame",{
        Size = UDim2.fromOffset(620, 420),
        Position = UDim2.new(0.5, -310, 0.5, -210),
        AnchorPoint = Vector2.new(0,0),
        BackgroundColor3 = theme.Bg,
        BorderSizePixel = 0,
        Parent = screen,
        Active = true
    })
    corner(root, 12)
    stroke(root, 1, Color3.new(0,0,0), 0.85)

    -- subtle drop shadow (image slice)
    local shadow = new("ImageLabel",{
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084", ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24,24,276,276),
        ImageTransparency = 0.88,
        Parent = root
    })

    -- header
    local header = new("Frame",{Size = UDim2.new(1,0,0,62), BackgroundColor3 = theme.Top, Parent = root})
    corner(header, 12)
    local titleLbl = new("TextLabel",{Text = title, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 18,
        BackgroundTransparency = 1, Position = UDim2.new(0,20,0,10), Size = UDim2.new(0.6, -20, 0, 28), TextXAlignment = Enum.TextXAlignment.Left, Parent = header})
    local subLbl = new("TextLabel",{Text = subtitle, TextColor3 = theme.Muted, Font = Enum.Font.Gotham, TextSize = 12,
        BackgroundTransparency = 1, Position = UDim2.new(0.6, 10, 0, 14), Size = UDim2.new(0.4, -32, 0, 20), TextXAlignment = Enum.TextXAlignment.Right, Parent = header})

    -- controls: minimize/dock/close
    local btnClose = new("TextButton",{Size=UDim2.fromOffset(34,28), Position=UDim2.new(1,-44,0,16), BackgroundColor3 = theme.Bad, Text="✕", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=16, Parent=header, AutoButtonColor=false})
    corner(btnClose,8)
    local btnDock = new("TextButton",{Size=UDim2.fromOffset(34,28), Position=UDim2.new(1,-84,0,16), BackgroundColor3 = theme.Accent, Text="▤", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=14, Parent=header, AutoButtonColor=false})
    corner(btnDock,8)

    -- tabbar top
    local tabbar = new("Frame",{Size = UDim2.new(1,0,0,44), Position = UDim2.new(0,0,0,62), BackgroundColor3 = theme.Panel, Parent = root})
    pad(tabbar, 8)
    corner(tabbar, 10)
    local tabLayout = new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Left, Padding=UDim.new(0,8), Parent = tabbar})

    -- content area
    local content = new("Frame",{Size = UDim2.new(1, -20, 1, -132), Position = UDim2.new(0,10,0,132), BackgroundColor3 = theme.Bg, Parent = root})
    local contentScroll = new("ScrollingFrame",{Size=UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ScrollBarThickness = 8, Parent = content})
    local contentList = new("UIListLayout",{Padding = UDim.new(0,10), Parent = contentScroll})

    -- toast container
    local toastHolder = new("Frame",{Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Parent = screen})
    local toastList = new("UIListLayout",{Padding=UDim.new(0,8), HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = toastHolder})
    pad(toastHolder, 12)

    -- dock bubble
    local dockGui = new("ScreenGui",{Name = id.."_Dock", Parent = CoreGui})
    local dockBtn = new("TextButton",{Size = UDim2.fromOffset(60,60), Position = UDim2.new(1,-80,1,-80), BackgroundColor3 = theme.Accent, Text="☰", TextColor3 = Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize = 24, Parent = dockGui, Visible = false, AutoButtonColor=false})
    corner(dockBtn, 30); stroke(dockBtn, 1, Color3.new(0,0,0), 0.85)

    -- drag root (touch & mouse)
    do
        local dragging = false
        local startPos, startMouse
        local function update(input)
            local delta = input.Position - startMouse
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        root.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging = true; startMouse = input.Position; startPos = root.Position
                input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
            end
        end)
        root.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then update(input) end end)
    end

    -- window object
    local win = {
        Id = id,
        Screen = screen,
        Root = root,
        Header = header,
        TabBar = tabbar,
        Content = contentScroll,
        Theme = theme,
        Tabs = {},
        _values = {},
        _setters = {},
        _sections = {}
    }
    setmetatable(win, LennonStyleUI)

    -- close/dock behavior
    btnClose.MouseButton1Click:Connect(function()
        screen:Destroy()
        dockGui:Destroy()
    end)
    btnDock.MouseButton1Click:Connect(function()
        screen.Enabled = false
        dockGui.Enabled = true
        dockBtn.Visible = true
    end)
    dockBtn.MouseButton1Click:Connect(function()
        screen.Enabled = true
        dockBtn.Visible = false
    end)

    -- toast function
    function win:Toast(title, msg, kind, dur)
        local dur = dur or 2.6
        local col = (kind=="good" and self.Theme.Good) or (kind=="warn" and self.Theme.Warn) or (kind=="bad" and self.Theme.Bad) or self.Theme.Accent
        local card = new("Frame",{Size=UDim2.new(0,320,0,72), BackgroundColor3 = self.Theme.Panel, Parent = toastHolder})
        corner(card, 10); pad(card, 10); stroke(card,1,Color3.new(0,0,0),0.8)
        card.AnchorPoint = Vector2.new(0,1); card.Position = UDim2.new(1,-20,1,-12)
        local bar = new("Frame",{Size=UDim2.new(0,6,1,0), BackgroundColor3 = col, Parent = card}); corner(bar,4)
        local t = new("TextLabel",{Text = title or "Info", BackgroundTransparency = 1, TextColor3 = self.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, Parent = card, Position = UDim2.new(0,12,0,4), Size = UDim2.new(1,-28,0,20), TextXAlignment = Enum.TextXAlignment.Left})
        local m = new("TextLabel",{Text = msg or "", BackgroundTransparency = 1, TextColor3 = self.Theme.Muted, Font = Enum.Font.Gotham, TextSize = 13, Parent = card, Position = UDim2.new(0,12,0,26), Size = UDim2.new(1,-28,0,36), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left})
        TweenService:Create(card, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
        task.delay(dur, function()
            TweenService:Create(card, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
            task.wait(0.18); pcall(function() card:Destroy() end)
        end)
    end

    -- AddTab
    function win:AddTab(name)
        local btn = new("TextButton",{Size=UDim2.new(0,130,1, -12), BackgroundColor3 = self.Theme.Top, Text = name, TextColor3 = self.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, Parent = self.TabBar, AutoButtonColor=false})
        corner(btn, 8); stroke(btn, 1, Color3.new(0,0,0), 0.8)
        local tabFrame = new("ScrollingFrame",{Size=UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 8, BackgroundTransparency = 1, Parent = self.Content})
        local layout = new("UIListLayout",{Padding = UDim.new(0,10), Parent = tabFrame})
        table.insert(self.Tabs, {Button = btn, Frame = tabFrame})
        -- tab switch
        btn.MouseButton1Click:Connect(function()
            for _,t in ipairs(self.Tabs) do t.Frame.Visible = false; t.Button.BackgroundColor3 = self.Theme.Top end
            tabFrame.Visible = true; btn.BackgroundColor3 = self.Theme.Panel
        end)
        if #self.Tabs == 1 then tabFrame.Visible = true; btn.BackgroundColor3 = self.Theme.Panel end

        -- section creator
        local function AddSection(title, collapsed)
            local section = new("Frame",{Size = UDim2.new(1,0,0,0), BackgroundColor3 = self.Theme.Panel, Parent = tabFrame, AutomaticSize = Enum.AutomaticSize.Y})
            corner(section, 10); pad(section, 12); stroke(section, 1, Color3.new(0,0,0), 0.85)
            local headerBtn = new("TextButton",{Size = UDim2.new(1,0,0,34), BackgroundTransparency = 1, Parent = section, Text = (collapsed and "▸  " or "▾  ") .. (title or "Section"), TextColor3 = self.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false})
            local contentHolder = new("Frame",{Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, Parent = section, AutomaticSize = Enum.AutomaticSize.Y})
            local contentLayout = new("UIListLayout",{Padding = UDim.new(0,8), Parent = contentHolder})
            contentHolder.Visible = not collapsed

            headerBtn.MouseButton1Click:Connect(function()
                contentHolder.Visible = not contentHolder.Visible
                headerBtn.Text = (contentHolder.Visible and "▾  " or "▸  ") .. (title or "Section")
            end)

            local SectionAPI = {}

            function SectionAPI:Button(text, cb)
                local b = new("TextButton",{Size = UDim2.new(1,0,0,46), BackgroundColor3 = selfTheme().Alt or win.Theme.Top, Text = text or "Button", TextColor3 = win.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, Parent = contentHolder, AutoButtonColor=false})
                corner(b, 10); stroke(b,1,Color3.new(0,0,0),0.6)
                b.MouseButton1Click:Connect(function() if cb then cb() end end)
                return b
            end

            function SectionAPI:Toggle(key, label, default, cb)
                local frame = new("Frame",{Size = UDim2.new(1,0,0,46), BackgroundTransparency = 1, Parent = contentHolder})
                local lbl = new("TextLabel",{Text = label or key, BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, Parent = frame, Size = UDim2.new(1,-80,1,0), TextXAlignment = Enum.TextXAlignment.Left})
                local toggle = new("TextButton",{Size = UDim2.fromOffset(64,32), Position = UDim2.new(1, -70, 0.5, -16), BackgroundColor3 = default and win.Theme.Accent or win.Theme.Top, Text = default and "ON" or "OFF", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, Parent = frame, AutoButtonColor=false})
                corner(toggle, 8); stroke(toggle,1,Color3.new(0,0,0),0.6)
                win._values[key] = default or false
                win._setters[key] = function(v, silent)
                    win._values[key] = v and true or false
                    toggle.Text = win._values[key] and "ON" or "OFF"
                    tween(toggle, {BackgroundColor3 = win._values[key] and win.Theme.Accent or win.Theme.Top}, 0.12)
                    if cb and not silent then cb(win._values[key]) end
                end
                toggle.MouseButton1Click:Connect(function() win._setters[key](not win._values[key]) end)
                return function() return win._values[key] end
            end

            function SectionAPI:Slider(key, label, min, max, default, cb)
                local f = new("Frame",{Size = UDim2.new(1,0,0,64), BackgroundTransparency = 1, Parent = contentHolder})
                local lab = new("TextLabel",{Text = (label or key) .. " (".. tostring(default or min) ..")", BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize=14, Parent = f, Size = UDim2.new(1,0,0,20), TextXAlignment = Enum.TextXAlignment.Left})
                local bar = new("Frame",{Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,34), BackgroundColor3 = win.Theme.Top, Parent = f}); corner(bar,6)
                local fill = new("Frame",{Size = UDim2.new(0,0,1,0), BackgroundColor3 = win.Theme.Accent, Parent = bar}); corner(fill,6)
                local value = math.clamp(default or min, min, max)
                local function setVal(v, silent)
                    value = math.clamp(math.floor(v+.5), min, max)
                    win._values[key] = value
                    lab.Text = (label or key) .. " (".. tostring(value) ..")"
                    local frac = (value - min) / math.max(1, (max-min))
                    fill.Size = UDim2.new(frac, 0, 1, 0)
                    if cb and not silent then cb(value) end
                end
                win._setters[key] = setVal
                setVal(value, true)
                local dragging=false
                local function at(x)
                    local abs = bar.AbsolutePosition.X; local w = bar.AbsoluteSize.X
                    local frac = math.clamp((x-abs)/w,0,1)
                    setVal(min + frac * (max-min))
                end
                bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = true; at(i.Position.X) end end)
                bar.InputEnded:Connect(function() dragging=false end)
                UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then at(i.Position.X) end end)
                return function() return win._values[key] end
            end

            function SectionAPI:Dropdown(key, label, items, defaultIndex, cb)
                local f = new("Frame",{Size=UDim2.new(1,0,0,48), BackgroundTransparency = 1, Parent = contentHolder})
                local l = new("TextLabel",{Text = label or key, BackgroundTransparency=1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize=14, Parent = f, Size = UDim2.new(1,-140,0,20), TextXAlignment = Enum.TextXAlignment.Left})
                local btn = new("TextButton",{Size = UDim2.fromOffset(120,32), Position = UDim2.new(1,-126,0,8), BackgroundColor3 = win.Theme.Top, Text = items[defaultIndex or 1] or "", TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, Parent = f, AutoButtonColor=false})
                corner(btn,8)
                local list = new("Frame",{Size = UDim2.new(0,200,0,0), Position = UDim2.new(1,-210,1,6), BackgroundColor3 = win.Theme.Panel, Parent = f, Visible = false, ClipsDescendants=true}); corner(list,8); pad(list,6)
                local scroll = new("ScrollingFrame",{Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = list, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 6})
                for i,v in ipairs(items) do
                    local it = new("TextButton",{Size = UDim2.new(1,0,0,30), BackgroundColor3 = win.Theme.Top, Text = v, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, Parent = scroll, AutoButtonColor=false})
                    corner(it,6)
                    it.MouseButton1Click:Connect(function()
                        btn.Text = v; win._values[key] = v
                        if cb then cb(v) end
                        tween(list, {Size = UDim2.new(0,200,0,0)}, 0.14)
                        task.delay(0.14, function() list.Visible = false end)
                    end)
                end
                win._values[key] = items[defaultIndex or 1]
                btn.MouseButton1Click:Connect(function()
                    list.Visible = true
                    tween(list, {Size = UDim2.new(0,200,0,180)}, 0.14)
                end)
                return function() return win._values[key] end
            end

            function SectionAPI:Textbox(key, label, placeholder, default, cb)
                local f = new("Frame",{Size = UDim2.new(1,0,0,68), BackgroundTransparency = 1, Parent = contentHolder})
                local l = new("TextLabel",{Text = label or key, BackgroundTransparency=1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize=14, Parent = f, Size = UDim2.new(1,0,0,20), TextXAlignment = Enum.TextXAlignment.Left})
                local tb = new("TextBox",{Size = UDim2.new(1,0,0,36), Position = UDim2.new(0,0,0,28), BackgroundColor3 = win.Theme.Top, Text = default or "", PlaceholderText = placeholder or "", TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, Parent = f})
                corner(tb,10); pad(tb,6)
                win._values[key] = tb.Text
                win._setters[key] = function(v,silent) tb.Text = tostring(v or ""); win._values[key] = tb.Text; if cb and not silent then cb(tb.Text) end end
                tb.FocusLost:Connect(function(enter) win._setters[key](tb.Text) end)
                return function() return win._values[key] end
            end

            function SectionAPI:Keybind(key, label, default, cb)
                local f = new("Frame",{Size = UDim2.new(1,0,0,48), BackgroundTransparency = 1, Parent = contentHolder})
                local l = new("TextLabel",{Text = label or key, BackgroundTransparency=1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize=14, Parent = f, Size = UDim2.new(1,-140,0,20), TextXAlignment = Enum.TextXAlignment.Left})
                local b = new("TextButton",{Size = UDim2.fromOffset(120,32), Position = UDim2.new(1,-126,0,8), BackgroundColor3 = win.Theme.Top, Text = default and default.Name or "Tap to bind", TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, Parent = f, AutoButtonColor=false})
                corner(b,8)
                win._values[key] = default
                win._setters[key] = function(v) win._values[key] = v; b.Text = v and v.Name or "Tap to bind" end
                local binding = false
                b.MouseButton1Click:Connect(function() binding = true; b.Text = "Press key..." end)
                UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if binding then
                        binding = false
                        if input.KeyCode ~= Enum.KeyCode.Unknown then win._setters[key](input.KeyCode) end
                    else
                        if win._values[key] and input.KeyCode == win._values[key] then if cb then cb() end end
                    end
                end)
                return function() return win._values[key] end
            end

            function SectionAPI:ColorPicker(key, label, default, cb)
                local f = new("Frame",{Size = UDim2.new(1,0,0,68), BackgroundTransparency = 1, Parent = contentHolder})
                local l = new("TextLabel",{Text = label or key, BackgroundTransparency=1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize=14, Parent = f, Size = UDim2.new(1,0,0,20), TextXAlignment = Enum.TextXAlignment.Left})
                local sw = new("TextButton",{Size = UDim2.fromOffset(46,40), Position = UDim2.new(1,-56,0,22), BackgroundColor3 = default or win.Theme.Accent, Parent = f, AutoButtonColor=false})
                corner(sw,8)
                local palette = {
                    Color3.fromRGB(58,120,255), Color3.fromRGB(38,185,154),
                    Color3.fromRGB(255,179,0), Color3.fromRGB(235,70,90),
                    Color3.fromRGB(180,95,255), Color3.fromRGB(120,120,130)
                }
                local idx = 1
                win._values[key] = sw.BackgroundColor3
                win._setters[key] = function(c,silent) sw.BackgroundColor3 = c; win._values[key]=c; if cb and not silent then cb(c) end end
                sw.MouseButton1Click:Connect(function() idx = idx % #palette + 1; win._setters[key](palette[idx]) end)
                return function() return win._values[key] end
            end

            function SectionAPI:Separator()
                local line = new("Frame",{Size = UDim2.new(1,0,0,1), BackgroundColor3 = win.Theme.Top, Parent = contentHolder})
                return line
            end

            return SectionAPI
        end

        return { AddSection = AddSection, TabButton = btn, TabFrame = tabFrame }
    end

    -- Save / Load
    function win:Save()
        local data = {Theme = self.Theme, Values = self._values}
        saveConfig(self.Id, data)
        self:Toast("Config","Salvo com sucesso","good",1.8)
    end
    function win:Load()
        local data = loadConfig(self.Id)
        if data and data.Values then
            for k,v in pairs(data.Values) do if self._setters[k] then self._setters[k](v, true) end end
        end
        if data and data.Theme then
            for k,v in pairs(data.Theme) do if self.Theme[k] ~= nil then self.Theme[k] = v end end
        end
    end

    return win
end

return LennonStyleUI
