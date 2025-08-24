-- LennonStyleUI v2.0 (Melhorado - Preto/Roxo/Branco, 30% menor, transparência 30%)
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

local function corner(obj, r) local c = new("UICorner",{CornerRadius=UDim.new(0,r or 6)}); c.Parent = obj; return c end
local function pad(obj, px) local p = new("UIPadding",{PaddingLeft=UDim.new(0,px),PaddingRight=UDim.new(0,px),PaddingTop=UDim.new(0,px),PaddingBottom=UDim.new(0,px)}); p.Parent = obj; return p end
local function stroke(obj, t, col, trans) local s=new("UIStroke",{Thickness=t or 1, Color=col or Color3.new(0,0,0),Transparency=trans or 0.5}); s.Parent=obj; return s end
local function gradient(obj,a,b) local g=new("UIGradient",{Color=ColorSequence.new{ColorSequenceKeypoint.new(0,a),ColorSequenceKeypoint.new(1,b)}}); g.Parent=obj; return g end

-- Novo Tema (Preto/Roxo/Branco com transparência 30%)
local DEFAULT = {
    Bg = Color3.fromRGB(0,0,0),           -- Preto puro
    Panel = Color3.fromRGB(15,15,15),     -- Preto suave
    Top = Color3.fromRGB(25,25,25),       -- Cinza escuro
    Accent = Color3.fromRGB(138,43,226),  -- Roxo vibrante (BlueViolet)
    AccentDark = Color3.fromRGB(75,0,130), -- Roxo escuro (Indigo)
    Muted = Color3.fromRGB(160,160,160),  -- Cinza claro
    Text = Color3.fromRGB(255,255,255),   -- Branco puro
    Good = Color3.fromRGB(50,205,50),     -- Verde lima
    Warn = Color3.fromRGB(255,165,0),     -- Laranja
    Bad  = Color3.fromRGB(220,20,60),     -- Vermelho carmesim
    -- Transparências (30%)
    BgTrans = 0.3,
    PanelTrans = 0.3,
    TopTrans = 0.2
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
local function tween(obj, props, time, style, dir) TweenService:Create(obj, TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play() end

-- Create window (30% menor)
function LennonStyleUI:CreateWindow(opts)
    opts = opts or {}
    local id = opts.Id or ("LennonUI_"..tostring(math.random(1000,9999)))
    local title = opts.Title or "LennonStyle"
    local subtitle = opts.Subtitle or ""
    local theme = opts.Theme or DEFAULT

    local screen = new("ScreenGui",{Name="LennonUI_"..id, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    screen.Parent = CoreGui

    -- UIScale for mobile (ajustado para ser 30% menor)
    local us = new("UIScale",{Scale = 0.7}) -- 30% menor
    us.Parent = screen
    local function adapt()
        local v = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
        us.Scale = (v.X < 900 or v.Y < 600) and 0.65 or 0.7 -- 30% menor em ambos os casos
    end
    adapt()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adapt)

    -- root frame (center) - 30% menor: 620*0.7=434, 420*0.7=294
    local root = new("Frame",{
        Size = UDim2.fromOffset(434, 294),
        Position = UDim2.new(0.5, -217, 0.5, -147),
        AnchorPoint = Vector2.new(0,0),
        BackgroundColor3 = theme.Bg,
        BackgroundTransparency = theme.BgTrans,
        BorderSizePixel = 0,
        Parent = screen,
        Active = true
    })
    corner(root, 10)
    stroke(root, 2, theme.Accent, 0.4)

    -- Efeito de brilho roxo
    local glow = new("ImageLabel",{
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084", ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24,24,276,276),
        ImageColor3 = theme.Accent,
        ImageTransparency = 0.7,
        Parent = root
    })

    -- header (ajustado para tamanho menor)
    local header = new("Frame",{Size = UDim2.new(1,0,0,44), BackgroundColor3 = theme.Top, BackgroundTransparency = theme.TopTrans, Parent = root})
    corner(header, 10)
    gradient(header, theme.AccentDark, theme.Top)
    
    local titleLbl = new("TextLabel",{Text = title, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 14,
        BackgroundTransparency = 1, Position = UDim2.new(0,15,0,8), Size = UDim2.new(0.6, -15, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = header})
    local subLbl = new("TextLabel",{Text = subtitle, TextColor3 = theme.Muted, Font = Enum.Font.Gotham, TextSize = 10,
        BackgroundTransparency = 1, Position = UDim2.new(0.6, 8, 0, 10), Size = UDim2.new(0.4, -25, 0, 16), TextXAlignment = Enum.TextXAlignment.Right, Parent = header})

    -- controls: minimize/dock/close (menores)
    local btnClose = new("TextButton",{Size=UDim2.fromOffset(24,20), Position=UDim2.new(1,-32,0,12), BackgroundColor3 = theme.Bad, Text="✕", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12, Parent=header, AutoButtonColor=false})
    corner(btnClose,6)
    local btnDock = new("TextButton",{Size=UDim2.fromOffset(24,20), Position=UDim2.new(1,-60,0,12), BackgroundColor3 = theme.Accent, Text="▤", TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=10, Parent=header, AutoButtonColor=false})
    corner(btnDock,6)

    -- tabbar top (menor)
    local tabbar = new("Frame",{Size = UDim2.new(1,0,0,32), Position = UDim2.new(0,0,0,44), BackgroundColor3 = theme.Panel, BackgroundTransparency = theme.PanelTrans, Parent = root})
    pad(tabbar, 6)
    corner(tabbar, 8)
    local tabLayout = new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Left, Padding=UDim.new(0,6), Parent = tabbar})

    -- content area (ajustado)
    local content = new("Frame",{Size = UDim2.new(1, -14, 1, -92), Position = UDim2.new(0,7,0,92), BackgroundColor3 = theme.Bg, BackgroundTransparency = 1, Parent = root})
    local contentScroll = new("ScrollingFrame",{Size=UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ScrollBarThickness = 6, Parent = content})
    local contentList = new("UIListLayout",{Padding = UDim.new(0,8), Parent = contentScroll})

    -- toast container
    local toastHolder = new("Frame",{Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Parent = screen})
    local toastList = new("UIListLayout",{Padding=UDim.new(0,6), HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom, Parent = toastHolder})
    pad(toastHolder, 10)

    -- dock bubble (menor)
    local dockGui = new("ScreenGui",{Name = id.."_Dock", Parent = CoreGui})
    local dockBtn = new("TextButton",{Size = UDim2.fromOffset(42,42), Position = UDim2.new(1,-56,1,-56), BackgroundColor3 = theme.Accent, Text="☰", TextColor3 = Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize = 18, Parent = dockGui, Visible = false, AutoButtonColor=false})
    corner(dockBtn, 21); stroke(dockBtn, 2, theme.AccentDark, 0.6)

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
        tween(root, {Size = UDim2.fromOffset(0,0)}, 0.2)
        task.wait(0.2)
        screen:Destroy()
        dockGui:Destroy()
    end)
    btnDock.MouseButton1Click:Connect(function()
        tween(root, {Size = UDim2.fromOffset(0,0)}, 0.15)
        task.wait(0.15)
        screen.Enabled = false
        dockGui.Enabled = true
        dockBtn.Visible = true
        tween(dockBtn, {Size = UDim2.fromOffset(42,42)}, 0.15)
    end)
    dockBtn.MouseButton1Click:Connect(function()
        tween(dockBtn, {Size = UDim2.fromOffset(0,0)}, 0.15)
        task.wait(0.15)
        screen.Enabled = true
        dockBtn.Visible = false
        tween(root, {Size = UDim2.fromOffset(434, 294)}, 0.15)
    end)

    -- toast function (melhorada)
    function win:Toast(title, msg, kind, dur)
        local dur = dur or 2.6
        local col = (kind=="good" and self.Theme.Good) or (kind=="warn" and self.Theme.Warn) or (kind=="bad" and self.Theme.Bad) or self.Theme.Accent
        local card = new("Frame",{Size=UDim2.new(0,224,0,50), BackgroundColor3 = self.Theme.Panel, BackgroundTransparency = self.Theme.PanelTrans, Parent = toastHolder})
        corner(card, 8); pad(card, 8); stroke(card,2,col,0.5)
        card.AnchorPoint = Vector2.new(0,1); card.Position = UDim2.new(1,-14,1,-8)
        
        local bar = new("Frame",{Size=UDim2.new(0,4,1,0), BackgroundColor3 = col, Parent = card}); corner(bar,3)
        local t = new("TextLabel",{Text = title or "Info", BackgroundTransparency = 1, TextColor3 = self.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, Parent = card, Position = UDim2.new(0,10,0,3), Size = UDim2.new(1,-20,0,16), TextXAlignment = Enum.TextXAlignment.Left})
        local m = new("TextLabel",{Text = msg or "", BackgroundTransparency = 1, TextColor3 = self.Theme.Muted, Font = Enum.Font.Gotham, TextSize = 11, Parent = card, Position = UDim2.new(0,10,0,18), Size = UDim2.new(1,-20,0,25), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left})
        
        -- Animação de entrada
        card.Position = UDim2.new(1,50,1,-8)
        tween(card, {Position = UDim2.new(1,-14,1,-8)}, 0.2)
        
        task.delay(dur, function()
            tween(card, {Position = UDim2.new(1,50,1,-8), BackgroundTransparency = 1}, 0.2)
            task.wait(0.2); pcall(function() card:Destroy() end)
        end)
    end

    -- Save/Load functions
    function win:Save()
        local data = {}
        for k,v in pairs(self._values) do data[k] = v end
        saveConfig(self.Id, data)
        self:Toast("Config", "Configuração salva!", "good")
    end

    function win:Load()
        local data = loadConfig(self.Id)
        if data then
            for k,v in pairs(data) do
                if self._setters[k] then
                    self._setters[k](v, true) -- silent = true
                end
            end
        end
    end

    -- AddTab (melhorado)
    function win:AddTab(name)
        local btn = new("TextButton",{Size=UDim2.new(0,91,1, -8), BackgroundColor3 = self.Theme.Top, BackgroundTransparency = self.Theme.TopTrans, Text = name, TextColor3 = self.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, Parent = self.TabBar, AutoButtonColor=false})
        corner(btn, 6); stroke(btn, 1, self.Theme.Accent, 0.7)
        
        local tabFrame = new("ScrollingFrame",{Size=UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 6, BackgroundTransparency = 1, Parent = self.Content})
        local layout = new("UIListLayout",{Padding = UDim.new(0,8), Parent = tabFrame})
        
        table.insert(self.Tabs, {Button = btn, Frame = tabFrame})
        
        -- tab switch com animação
        btn.MouseButton1Click:Connect(function()
            for _,t in ipairs(self.Tabs) do 
                t.Frame.Visible = false
                tween(t.Button, {BackgroundColor3 = self.Theme.Top, BackgroundTransparency = self.Theme.TopTrans}, 0.1)
            end
            tabFrame.Visible = true
            tween(btn, {BackgroundColor3 = self.Theme.Panel, BackgroundTransparency = self.Theme.PanelTrans}, 0.1)
        end)
        
        if #self.Tabs == 1 then 
            tabFrame.Visible = true
            btn.BackgroundColor3 = self.Theme.Panel
            btn.BackgroundTransparency = self.Theme.PanelTrans
        end

        -- Retorna a API da Tab
        local TabAPI = {}
        
        function TabAPI.AddSection(title, collapsed)
            local section = new("Frame",{Size = UDim2.new(1,0,0,0), BackgroundColor3 = win.Theme.Panel, BackgroundTransparency = win.Theme.PanelTrans, Parent = tabFrame, AutomaticSize = Enum.AutomaticSize.Y})
            corner(section, 8); pad(section, 10); stroke(section, 1, win.Theme.Accent, 0.6)
            
            local headerBtn = new("TextButton",{Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1, Parent = section, Text = (collapsed and "▸  " or "▾  ") .. (title or "Section"), TextColor3 = win.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false})
            local contentHolder = new("Frame",{Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, Parent = section, AutomaticSize = Enum.AutomaticSize.Y})
            local contentLayout = new("UIListLayout",{Padding = UDim.new(0,6), Parent = contentHolder})
            contentHolder.Visible = not collapsed

            headerBtn.MouseButton1Click:Connect(function()
                contentHolder.Visible = not contentHolder.Visible
                headerBtn.Text = (contentHolder.Visible and "▾  " or "▸  ") .. (title or "Section")
                tween(headerBtn, {TextColor3 = contentHolder.Visible and win.Theme.Accent or win.Theme.Text}, 0.1)
            end)

            return win:_createSectionAPI(contentHolder)
        end
        
        return TabAPI
    end

    return win
end

-- Função para criar a API de seção (será implementada na próxima fase)
function LennonStyleUI:_createSectionAPI(contentHolder)
    local SectionAPI = {}
    local win = self
    
    -- Implementações dos componentes serão adicionadas na próxima fase
    
    return SectionAPI
end

return LennonStyleUI


-- Função para criar a API de seção (implementação completa)
function LennonStyleUI:_createSectionAPI(contentHolder)
    local SectionAPI = {}
    local win = self
    
    -- BUTTON (melhorado)
    function SectionAPI:Button(text, cb)
        local b = new("TextButton",{Size = UDim2.new(1,0,0,32), BackgroundColor3 = win.Theme.Top, BackgroundTransparency = win.Theme.TopTrans, Text = text or "Button", TextColor3 = win.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, Parent = contentHolder, AutoButtonColor=false})
        corner(b, 6); stroke(b,1,win.Theme.Accent,0.6)
        
        -- Efeito hover
        b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = win.Theme.Accent, BackgroundTransparency = 0.1}, 0.1) end)
        b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = win.Theme.Top, BackgroundTransparency = win.Theme.TopTrans}, 0.1) end)
        
        b.MouseButton1Click:Connect(function() 
            tween(b, {Size = UDim2.new(1,0,0,28)}, 0.05)
            task.wait(0.05)
            tween(b, {Size = UDim2.new(1,0,0,32)}, 0.05)
            if cb then cb() end 
        end)
        return b
    end

    -- TOGGLE (melhorado)
    function SectionAPI:Toggle(key, label, default, cb)
        local frame = new("Frame",{Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1, Parent = contentHolder})
        local lbl = new("TextLabel",{Text = label or key, BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = frame, Size = UDim2.new(1,-56,1,0), TextXAlignment = Enum.TextXAlignment.Left})
        
        local toggle = new("TextButton",{Size = UDim2.fromOffset(45,22), Position = UDim2.new(1, -49, 0.5, -11), BackgroundColor3 = default and win.Theme.Accent or win.Theme.Top, Text = default and "ON" or "OFF", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 10, Parent = frame, AutoButtonColor=false})
        corner(toggle, 6); stroke(toggle,1,Color3.new(0,0,0),0.4)
        
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

    -- SLIDER (melhorado)
    function SectionAPI:Slider(key, label, min, max, default, cb)
        local f = new("Frame",{Size = UDim2.new(1,0,0,45), BackgroundTransparency = 1, Parent = contentHolder})
        local lab = new("TextLabel",{Text = (label or key) .. " (".. tostring(default or min) ..")", BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize=12, Parent = f, Size = UDim2.new(1,0,0,16), TextXAlignment = Enum.TextXAlignment.Left})
        
        local bar = new("Frame",{Size = UDim2.new(1,0,0,8), Position = UDim2.new(0,0,0,24), BackgroundColor3 = win.Theme.Top, BackgroundTransparency = win.Theme.TopTrans, Parent = f}); corner(bar,4)
        stroke(bar, 1, win.Theme.Accent, 0.7)
        
        local fill = new("Frame",{Size = UDim2.new(0,0,1,0), BackgroundColor3 = win.Theme.Accent, Parent = bar}); corner(fill,4)
        
        local value = math.clamp(default or min, min, max)
        local function setVal(v, silent)
            value = math.clamp(math.floor(v+.5), min, max)
            win._values[key] = value
            lab.Text = (label or key) .. " (".. tostring(value) ..")"
            local frac = (value - min) / math.max(1, (max-min))
            tween(fill, {Size = UDim2.new(frac, 0, 1, 0)}, 0.1)
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

    -- DROPDOWN (NOVO)
    function SectionAPI:Dropdown(key, label, options, default, cb)
        local frame = new("Frame",{Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1, Parent = contentHolder})
        local lbl = new("TextLabel",{Text = label or key, BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = frame, Size = UDim2.new(0.5,0,1,0), TextXAlignment = Enum.TextXAlignment.Left})
        
        local dropdown = new("TextButton",{Size = UDim2.new(0.5,-4,0,24), Position = UDim2.new(0.5,2,0,4), BackgroundColor3 = win.Theme.Top, BackgroundTransparency = win.Theme.TopTrans, Text = options[default or 1] or "Select", TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 11, Parent = frame, AutoButtonColor=false})
        corner(dropdown, 5); stroke(dropdown,1,win.Theme.Accent,0.6)
        
        local arrow = new("TextLabel",{Size = UDim2.fromOffset(16,16), Position = UDim2.new(1,-20,0.5,-8), BackgroundTransparency = 1, Text = "▼", TextColor3 = win.Theme.Muted, Font = Enum.Font.Gotham, TextSize = 10, Parent = dropdown})
        
        local dropFrame = new("Frame",{Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,2), BackgroundColor3 = win.Theme.Panel, BackgroundTransparency = win.Theme.PanelTrans, Parent = dropdown, Visible = false, AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 10})
        corner(dropFrame, 5); stroke(dropFrame,1,win.Theme.Accent,0.6)
        
        local dropLayout = new("UIListLayout",{Parent = dropFrame})
        
        win._values[key] = options[default or 1] or options[1]
        win._setters[key] = function(v, silent)
            win._values[key] = v
            dropdown.Text = v
            if cb and not silent then cb(v) end
        end
        
        for i, option in ipairs(options) do
            local optBtn = new("TextButton",{Size = UDim2.new(1,0,0,22), BackgroundColor3 = win.Theme.Top, BackgroundTransparency = 0.8, Text = option, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 10, Parent = dropFrame, AutoButtonColor=false})
            
            optBtn.MouseEnter:Connect(function() tween(optBtn, {BackgroundTransparency = 0.3}, 0.1) end)
            optBtn.MouseLeave:Connect(function() tween(optBtn, {BackgroundTransparency = 0.8}, 0.1) end)
            
            optBtn.MouseButton1Click:Connect(function()
                win._setters[key](option)
                dropFrame.Visible = false
                tween(arrow, {Rotation = 0}, 0.1)
            end)
        end
        
        dropdown.MouseButton1Click:Connect(function()
            dropFrame.Visible = not dropFrame.Visible
            tween(arrow, {Rotation = dropFrame.Visible and 180 or 0}, 0.1)
        end)
        
        return function() return win._values[key] end
    end

    -- TEXTBOX (NOVO)
    function SectionAPI:Textbox(key, label, placeholder, default, cb)
        local frame = new("Frame",{Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = contentHolder})
        local lbl = new("TextLabel",{Text = label or key, BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = frame, Size = UDim2.new(1,0,0,16), TextXAlignment = Enum.TextXAlignment.Left})
        
        local textbox = new("TextBox",{Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,20), BackgroundColor3 = win.Theme.Top, BackgroundTransparency = win.Theme.TopTrans, Text = default or "", PlaceholderText = placeholder or "", TextColor3 = win.Theme.Text, PlaceholderColor3 = win.Theme.Muted, Font = Enum.Font.Gotham, TextSize = 11, Parent = frame, ClearTextOnFocus = false})
        corner(textbox, 5); stroke(textbox,1,win.Theme.Accent,0.6)
        pad(textbox, 8)
        
        win._values[key] = default or ""
        win._setters[key] = function(v, silent)
            win._values[key] = v
            textbox.Text = v
            if cb and not silent then cb(v) end
        end
        
        textbox.FocusLost:Connect(function()
            win._setters[key](textbox.Text)
        end)
        
        textbox.Focused:Connect(function() tween(textbox, {BackgroundTransparency = 0.1}, 0.1) end)
        textbox.FocusLost:Connect(function() tween(textbox, {BackgroundTransparency = win.Theme.TopTrans}, 0.1) end)
        
        return function() return win._values[key] end
    end

    -- KEYBIND (NOVO)
    function SectionAPI:Keybind(key, label, defaultKey, cb)
        local frame = new("Frame",{Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1, Parent = contentHolder})
        local lbl = new("TextLabel",{Text = label or key, BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = frame, Size = UDim2.new(1,-70,1,0), TextXAlignment = Enum.TextXAlignment.Left})
        
        local keybind = new("TextButton",{Size = UDim2.fromOffset(64,24), Position = UDim2.new(1, -68, 0.5, -12), BackgroundColor3 = win.Theme.Top, BackgroundTransparency = win.Theme.TopTrans, Text = defaultKey and defaultKey.Name or "None", TextColor3 = win.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 10, Parent = frame, AutoButtonColor=false})
        corner(keybind, 5); stroke(keybind,1,win.Theme.Accent,0.6)
        
        local listening = false
        win._values[key] = defaultKey
        win._setters[key] = function(v, silent)
            win._values[key] = v
            keybind.Text = v and v.Name or "None"
            if cb and not silent then cb(v) end
        end
        
        keybind.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            keybind.Text = "..."
            tween(keybind, {BackgroundColor3 = win.Theme.Accent}, 0.1)
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    win._setters[key](input.KeyCode)
                    listening = false
                    tween(keybind, {BackgroundColor3 = win.Theme.Top}, 0.1)
                    connection:Disconnect()
                end
            end)
        end)
        
        -- Detectar quando a tecla é pressionada
        if defaultKey then
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == win._values[key] and cb then
                    cb(input.KeyCode)
                end
            end)
        end
        
        return function() return win._values[key] end
    end

    -- COLORPICKER (NOVO)
    function SectionAPI:ColorPicker(key, label, default, cb)
        local frame = new("Frame",{Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1, Parent = contentHolder})
        local lbl = new("TextLabel",{Text = label or key, BackgroundTransparency = 1, TextColor3 = win.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = frame, Size = UDim2.new(1,-40,1,0), TextXAlignment = Enum.TextXAlignment.Left})
        
        local colorBtn = new("TextButton",{Size = UDim2.fromOffset(32,24), Position = UDim2.new(1, -36, 0.5, -12), BackgroundColor3 = default or Color3.fromRGB(255,255,255), Text = "", Parent = frame, AutoButtonColor=false})
        corner(colorBtn, 5); stroke(colorBtn,2,win.Theme.Accent,0.6)
        
        win._values[key] = default or Color3.fromRGB(255,255,255)
        win._setters[key] = function(v, silent)
            win._values[key] = v
            colorBtn.BackgroundColor3 = v
            if cb and not silent then cb(v) end
        end
        
        -- Picker simples com cores predefinidas
        local colorFrame = new("Frame",{Size = UDim2.new(0,160,0,80), Position = UDim2.new(0,0,1,4), BackgroundColor3 = win.Theme.Panel, BackgroundTransparency = win.Theme.PanelTrans, Parent = colorBtn, Visible = false, ZIndex = 10})
        corner(colorFrame, 6); stroke(colorFrame,1,win.Theme.Accent,0.6)
        
        local colorGrid = new("UIGridLayout",{CellSize = UDim2.fromOffset(18,18), CellPadding = UDim2.fromOffset(2,2), Parent = colorFrame})
        pad(colorFrame, 4)
        
        local colors = {
            Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0),
            Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
            Color3.fromRGB(138,43,226), Color3.fromRGB(75,0,130), Color3.fromRGB(255,165,0), Color3.fromRGB(50,205,50),
            Color3.fromRGB(220,20,60), Color3.fromRGB(128,128,128), Color3.fromRGB(64,64,64), Color3.fromRGB(192,192,192)
        }
        
        for _, color in ipairs(colors) do
            local colorSample = new("TextButton",{Size = UDim2.fromOffset(18,18), BackgroundColor3 = color, Text = "", Parent = colorFrame, AutoButtonColor=false})
            corner(colorSample, 3)
            
            colorSample.MouseButton1Click:Connect(function()
                win._setters[key](color)
                colorFrame.Visible = false
            end)
        end
        
        colorBtn.MouseButton1Click:Connect(function()
            colorFrame.Visible = not colorFrame.Visible
        end)
        
        return function() return win._values[key] end
    end

    -- SEPARATOR (NOVO)
    function SectionAPI:Separator()
        local sep = new("Frame",{Size = UDim2.new(1,0,0,1), BackgroundColor3 = win.Theme.Accent, BackgroundTransparency = 0.7, Parent = contentHolder})
        local spacer = new("Frame",{Size = UDim2.new(1,0,0,8), BackgroundTransparency = 1, Parent = contentHolder})
        return sep
    end
    
    return SectionAPI
end

return LennonStyleUI
