--[[
    ╔══════════════════════════════════════════════════════════╗
    ║   NIGHT HUB UI  —  v2  Premium Library                  ║
    ║   Cores fiéis ao print  |  Grid 2 colunas               ║
    ║   Resize Livre (W+H)  |  Intro  |  Discord Card         ║
    ╚══════════════════════════════════════════════════════════╝
--]]

local Library          = {}
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

------------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------------
local function tween(o, p, t, style, dir)
    TweenService:Create(o, TweenInfo.new(t or 0.16,
        style or Enum.EasingStyle.Quart,
        dir   or Enum.EasingDirection.Out), p):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p; return c
end

local function stroke(p, col, th)
    -- limpa strokes antigos para não acumular
    for _, v in ipairs(p:GetChildren()) do
        if v:IsA("UIStroke") then v:Destroy() end
    end
    local s = Instance.new("UIStroke")
    s.Color           = col or Color3.fromRGB(50, 53, 70)
    s.Thickness       = th  or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent          = p; return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p; return u
end

local function vlist(p, sp)
    local l = Instance.new("UIListLayout")
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.FillDirection       = Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding             = UDim.new(0, sp or 0)
    l.Parent              = p; return l
end

local function hlist(p, sp)
    local l = Instance.new("UIListLayout")
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.FillDirection       = Enum.FillDirection.Horizontal
    l.VerticalAlignment   = Enum.VerticalAlignment.Center
    l.Padding             = UDim.new(0, sp or 0)
    l.Parent              = p; return l
end

local function draggable(handle, target)
    local drag, s0, p0 = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; s0 = i.Position; p0 = target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
                  or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - s0
            target.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X,
                                        p0.Y.Scale,  p0.Y.Offset + d.Y)
        end
    end)
end

------------------------------------------------------------------------
-- PALETA  — cores exatas do print Night Hub
------------------------------------------------------------------------
local C = {
    -- Janela
    WIN        = Color3.fromRGB(22, 24, 35),       -- fundo janela #16181F aprox
    WIN_STR    = Color3.fromRGB(40, 43, 60),

    -- Header (escuro, sem cor)
    HDR        = Color3.fromRGB(22, 24, 35),
    HDR_LINE   = Color3.fromRGB(38, 41, 58),       -- linha divisória header

    -- Sidebar
    SIDEBAR    = Color3.fromRGB(26, 28, 42),       -- #1A1C2A
    SIDE_CAT   = Color3.fromRGB(100, 104, 130),    -- "FARMMING" cinza

    -- Tabs
    TAB_OFF    = Color3.fromRGB(26, 28, 42),
    TAB_ON     = Color3.fromRGB(42, 98, 210),      -- azul da tab ativa
    TAB_H      = Color3.fromRGB(34, 37, 54),
    TAB_TXT_OFF= Color3.fromRGB(150, 155, 180),
    TAB_TXT_ON = Color3.fromRGB(255, 255, 255),
    TAB_ICON_ON= Color3.fromRGB(255, 255, 255),

    -- Conteúdo
    CONTENT    = Color3.fromRGB(18, 20, 30),       -- #12141E

    -- Seção
    SEC_TXT    = Color3.fromRGB(100, 104, 130),    -- cinza igual "Discord Invite" / "Farmming Toggle"

    -- Elementos (cards escuros)
    ELEM       = Color3.fromRGB(30, 33, 48),       -- #1E2130
    ELEM_H     = Color3.fromRGB(38, 42, 60),
    ELEM_STR   = Color3.fromRGB(44, 48, 68),       -- borda sutil

    -- Toggle pill
    TOG_OFF    = Color3.fromRGB(52, 55, 75),       -- cinza off
    TOG_ON     = Color3.fromRGB(55, 135, 255),     -- azul vivo on

    -- Badge / inputs
    BADGE_BG   = Color3.fromRGB(36, 39, 56),
    BADGE_TXT  = Color3.fromRGB(185, 190, 215),
    BADGE_STR  = Color3.fromRGB(52, 56, 78),

    -- Textos
    TXT        = Color3.fromRGB(225, 228, 245),    -- texto principal
    TXT_DIM    = Color3.fromRGB(95, 100, 128),     -- "DISABLE", descrição
    TXT_MID    = Color3.fromRGB(155, 160, 188),
    TXT_ACTIVE = Color3.fromRGB(55, 135, 255),     -- "ACTIVE" azul

    -- Misc
    DIV        = Color3.fromRGB(38, 41, 58),
    SL_TR      = Color3.fromRGB(42, 45, 65),
    SL_FILL    = Color3.fromRGB(55, 135, 255),
    OPT        = Color3.fromRGB(26, 28, 42),
    OPT_H      = Color3.fromRGB(36, 40, 58),
    SCHEME     = Color3.fromRGB(55, 135, 255),
    SCROLL     = Color3.fromRGB(55, 135, 255),

    -- Header btns
    BTN_HDR    = Color3.fromRGB(38, 41, 58),

    -- Discord Join (verde igual ao print)
    DISC_JOIN  = Color3.fromRGB(48, 185, 90),
    DISC_BG    = Color3.fromRGB(26, 28, 42),
}

local _GUI       = nil
local _activeTab = nil

------------------------------------------------------------------------
-- INTRO
------------------------------------------------------------------------
local function playIntro(title, onDone)
    local pGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local sg   = Instance.new("ScreenGui")
    sg.Name = "__NHIntro"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 99998
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = pGui end

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(10,12,20)
    bg.BorderSizePixel  = 0; bg.ZIndex = 1; bg.Parent = sg

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0,0,0,0)
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position    = UDim2.new(0.5,0,0.5,0)
    panel.BackgroundColor3 = Color3.fromRGB(20,22,32)
    panel.BorderSizePixel  = 0; panel.ZIndex = 2
    panel.ClipsDescendants = true; panel.Parent = sg
    corner(panel, 16); stroke(panel, C.SCHEME, 1.5)

    local scan = Instance.new("Frame")
    scan.Size = UDim2.new(1,0,0,2); scan.BackgroundColor3 = C.SCHEME
    scan.BackgroundTransparency = 0.4; scan.BorderSizePixel = 0
    scan.ZIndex = 10; scan.Parent = panel

    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.new(0,0,0,0)
    iconBg.AnchorPoint = Vector2.new(0.5,0.5)
    iconBg.Position    = UDim2.new(0.5,0,0.36,0)
    iconBg.BackgroundColor3 = C.SCHEME
    iconBg.BorderSizePixel  = 0; iconBg.ZIndex = 5; iconBg.Parent = panel
    corner(iconBg, 50)

    local iconTxt = Instance.new("TextLabel")
    iconTxt.Size = UDim2.new(1,0,1,0); iconTxt.BackgroundTransparency = 1
    iconTxt.Text = "N"; iconTxt.TextScaled = true
    iconTxt.Font = Enum.Font.GothamBold
    iconTxt.TextColor3 = Color3.fromRGB(255,255,255)
    iconTxt.ZIndex = 6; iconTxt.Parent = iconBg

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1,-40,0,32); tl.AnchorPoint = Vector2.new(0.5,0)
    tl.Position = UDim2.new(0.5,0,0.56,0)
    tl.BackgroundTransparency = 1
    tl.Text = title or "NIGHT HUB"; tl.TextSize = 22
    tl.Font = Enum.Font.GothamBold
    tl.TextColor3 = Color3.fromRGB(255,255,255)
    tl.TextXAlignment = Enum.TextXAlignment.Center
    tl.TextTransparency = 1; tl.ZIndex = 5; tl.Parent = panel

    local sl = Instance.new("TextLabel")
    sl.Size = UDim2.new(1,-40,0,18); sl.AnchorPoint = Vector2.new(0.5,0)
    sl.Position = UDim2.new(0.5,0,0.70,0)
    sl.BackgroundTransparency = 1; sl.Text = "v1.0.1 - BETA"
    sl.TextSize = 11; sl.Font = Enum.Font.GothamSemibold
    sl.TextColor3 = C.SCHEME
    sl.TextXAlignment = Enum.TextXAlignment.Center
    sl.TextTransparency = 1; sl.ZIndex = 5; sl.Parent = panel

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.6,0,0,3)
    barBg.AnchorPoint = Vector2.new(0.5,0)
    barBg.Position = UDim2.new(0.5,0,0.84,0)
    barBg.BackgroundColor3 = Color3.fromRGB(36,40,56)
    barBg.BorderSizePixel = 0; barBg.ZIndex = 5; barBg.Parent = panel
    corner(barBg, 2)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0,0,1,0)
    barFill.BackgroundColor3 = C.SCHEME
    barFill.BorderSizePixel = 0; barFill.ZIndex = 6; barFill.Parent = barBg
    corner(barFill, 2)

    local stl = Instance.new("TextLabel")
    stl.Size = UDim2.new(1,-40,0,14); stl.AnchorPoint = Vector2.new(0.5,0)
    stl.Position = UDim2.new(0.5,0,0.90,0)
    stl.BackgroundTransparency = 1; stl.Text = "Initializing..."
    stl.TextSize = 10; stl.Font = Enum.Font.Gotham
    stl.TextColor3 = C.TXT_DIM
    stl.TextXAlignment = Enum.TextXAlignment.Center
    stl.TextTransparency = 1; stl.ZIndex = 5; stl.Parent = panel

    local particles = {}
    for i = 1,12 do
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0,math.random(2,3),0,math.random(2,3))
        d.Position = UDim2.new(math.random()/1,0,math.random()/1,0)
        d.BackgroundColor3 = C.SCHEME
        d.BackgroundTransparency = math.random(5,8)/10
        d.BorderSizePixel = 0; d.ZIndex = 3; d.Parent = bg
        corner(d,3); particles[i] = d
    end
    local pc = RunService.Heartbeat:Connect(function()
        for _,d in ipairs(particles) do
            local np = d.Position
            d.Position = UDim2.new(
                math.clamp(np.X.Scale+(math.random(-100,100)/130000),0.01,0.99),0,
                math.clamp(np.Y.Scale+(math.random(-100,100)/130000),0.01,0.99),0)
        end
    end)

    task.spawn(function()
        tween(panel,{Size=UDim2.new(0,300,0,240)},0.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        task.wait(0.46)
        tween(iconBg,{Size=UDim2.new(0,56,0,56)},0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        task.wait(0.26)
        tween(tl,{TextTransparency=0},0.3); task.wait(0.1)
        tween(sl,{TextTransparency=0},0.28); task.wait(0.1)
        tween(stl,{TextTransparency=0},0.26); task.wait(0.16)
        TweenService:Create(scan,TweenInfo.new(0.65,Enum.EasingStyle.Linear),
            {Position=UDim2.new(0,0,1,0)}):Play()
        for _,s in ipairs({{0.3,"Loading..."},{0.6,"Connecting..."},{0.85,"Applying..."},{1,"Ready!"}}) do
            tween(barFill,{Size=UDim2.new(s[1],0,1,0)},0.28)
            stl.Text = s[2]; task.wait(0.3)
        end
        tween(iconBg,{BackgroundColor3=Color3.fromRGB(110,185,255)},0.08)
        task.wait(0.1); tween(iconBg,{BackgroundColor3=C.SCHEME},0.1); task.wait(0.12)
        tween(tl,{TextTransparency=1},0.2); tween(sl,{TextTransparency=1},0.18)
        tween(stl,{TextTransparency=1},0.16); tween(iconBg,{BackgroundTransparency=1},0.2)
        task.wait(0.24)
        tween(panel,{Size=UDim2.new(0,0,0,0)},0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        tween(bg,{BackgroundTransparency=1},0.28); task.wait(0.32)
        pc:Disconnect(); sg:Destroy(); pcall(onDone)
    end)
end

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    if typeof(themeColor) == "Color3" then
        C.SCHEME=themeColor; C.SL_FILL=themeColor; C.TAB_ON=themeColor
        C.TXT_ACTIVE=themeColor; C.SCROLL=themeColor; C.TOG_ON=themeColor
    elseif typeof(themeColor) == "table" then
        if themeColor.SchemeColor then
            local sc=themeColor.SchemeColor
            C.SCHEME=sc;C.SL_FILL=sc;C.TAB_ON=sc
            C.TXT_ACTIVE=sc;C.SCROLL=sc;C.TOG_ON=sc
        end
        if themeColor.Background   then C.WIN=themeColor.Background   end
        if themeColor.TextColor    then C.TXT=themeColor.TextColor    end
        if themeColor.ElementColor then C.ELEM=themeColor.ElementColor end
    end

    pcall(function()
        for _,v in ipairs(game.CoreGui:GetChildren()) do
            if v.Name=="__NHLib" then v:Destroy() end
        end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name="__NHLib"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder=9999; sg.Enabled=false
    pcall(function() sg.Parent=game.CoreGui end)
    _GUI = sg

    --------------------------------------------------------------------
    -- DIMENSÕES  (menores, fiéis ao print)
    --------------------------------------------------------------------
    local WIN_W    = 530   -- largura total (~print)
    local SIDE_W   = 168   -- sidebar
    local HDR_H    = 46    -- header fino igual ao print
    local WIN_H    = 420
    local WIN_MIN_H= 260
    local WIN_MAX_H= 760
    local WIN_MIN_W= 400
    local WIN_MAX_W= 960
    local EH       = 76    -- altura de cada cell (element)
    local CELL_GAP = 7     -- gap entre células

    --------------------------------------------------------------------
    -- JANELA
    --------------------------------------------------------------------
    local win = Instance.new("Frame")
    win.Name="Win"; win.AnchorPoint=Vector2.new(0.5,0)
    win.Position=UDim2.new(0.5,0,0.04,0)
    win.Size=UDim2.new(0,WIN_W,0,WIN_H)
    win.BackgroundColor3=C.WIN
    win.BorderSizePixel=0; win.ClipsDescendants=false; win.Parent=sg
    corner(win,12); stroke(win,C.WIN_STR,1)

    local shadow = Instance.new("ImageLabel")
    shadow.Size=UDim2.new(1,46,1,46); shadow.Position=UDim2.new(0,-23,0,-23)
    shadow.BackgroundTransparency=1; shadow.Image="rbxassetid://6015897843"
    shadow.ImageColor3=Color3.fromRGB(0,0,0); shadow.ImageTransparency=0.42
    shadow.ScaleType=Enum.ScaleType.Slice
    shadow.SliceCenter=Rect.new(49,49,450,450)
    shadow.ZIndex=0; shadow.Parent=win

    --------------------------------------------------------------------
    -- HEADER
    --------------------------------------------------------------------
    local hdr = Instance.new("Frame")
    hdr.Name="Hdr"; hdr.Size=UDim2.new(1,0,0,HDR_H)
    hdr.BackgroundColor3=C.HDR; hdr.BorderSizePixel=0
    hdr.ZIndex=10; hdr.Parent=win
    corner(hdr,12)

    -- patch inferior
    local hp = Instance.new("Frame")
    hp.Size=UDim2.new(1,0,0,14); hp.Position=UDim2.new(0,0,1,-14)
    hp.BackgroundColor3=C.HDR; hp.BorderSizePixel=0; hp.ZIndex=10; hp.Parent=hdr

    -- Linha separadora
    local hl = Instance.new("Frame")
    hl.Size=UDim2.new(1,0,0,1); hl.Position=UDim2.new(0,0,1,-1)
    hl.BackgroundColor3=C.HDR_LINE; hl.BorderSizePixel=0; hl.ZIndex=11; hl.Parent=hdr

    -- "Night" bold
    local tMain = Instance.new("TextLabel")
    tMain.Size=UDim2.new(0,50,1,0); tMain.Position=UDim2.new(0,14,0,0)
    tMain.BackgroundTransparency=1; tMain.Text="Night"
    tMain.TextSize=16; tMain.Font=Enum.Font.GothamBold
    tMain.TextColor3=Color3.fromRGB(255,255,255)
    tMain.TextXAlignment=Enum.TextXAlignment.Left
    tMain.TextYAlignment=Enum.TextYAlignment.Center
    tMain.ZIndex=12; tMain.Parent=hdr

    -- "Hub" regular
    local tHub = Instance.new("TextLabel")
    tHub.Size=UDim2.new(0,36,1,0); tHub.Position=UDim2.new(0,66,0,0)
    tHub.BackgroundTransparency=1; tHub.Text="Hub"
    tHub.TextSize=16; tHub.Font=Enum.Font.Gotham
    tHub.TextColor3=Color3.fromRGB(185,190,215)
    tHub.TextXAlignment=Enum.TextXAlignment.Left
    tHub.TextYAlignment=Enum.TextYAlignment.Center
    tHub.ZIndex=12; tHub.Parent=hdr

    -- Badge versão azul
    local vBg = Instance.new("Frame")
    vBg.Size=UDim2.new(0,78,0,20); vBg.Position=UDim2.new(0,106,0.5,-10)
    vBg.BackgroundColor3=C.SCHEME; vBg.BorderSizePixel=0; vBg.ZIndex=13; vBg.Parent=hdr
    corner(vBg,5)
    local vL = Instance.new("TextLabel")
    vL.Size=UDim2.new(1,0,1,0); vL.BackgroundTransparency=1
    vL.Text="v1.0.1 - BETA"; vL.TextSize=9; vL.Font=Enum.Font.GothamBold
    vL.TextColor3=Color3.fromRGB(255,255,255)
    vL.TextXAlignment=Enum.TextXAlignment.Center
    vL.TextYAlignment=Enum.TextYAlignment.Center
    vL.ZIndex=14; vL.Parent=vBg

    -- Arrows decorativos
    local arrows = Instance.new("TextLabel")
    arrows.Size=UDim2.new(1,-310,1,0); arrows.Position=UDim2.new(0,198,0,0)
    arrows.BackgroundTransparency=1
    arrows.Text=">> >> >> >> >> >> >> >> >>"
    arrows.TextSize=9; arrows.Font=Enum.Font.GothamBold
    arrows.TextColor3=Color3.fromRGB(55,135,255)
    arrows.TextXAlignment=Enum.TextXAlignment.Left
    arrows.TextYAlignment=Enum.TextYAlignment.Center
    arrows.TextTruncate=Enum.TextTruncate.AtEnd
    arrows.ZIndex=12; arrows.Parent=hdr

    -- Botão minimize
    local minBtn = Instance.new("TextButton")
    minBtn.Size=UDim2.new(0,24,0,24); minBtn.Position=UDim2.new(1,-58,0.5,-12)
    minBtn.BackgroundColor3=C.BTN_HDR; minBtn.BorderSizePixel=0
    minBtn.Text="—"; minBtn.Font=Enum.Font.GothamBold; minBtn.TextSize=10
    minBtn.TextColor3=Color3.fromRGB(180,185,210); minBtn.AutoButtonColor=false
    minBtn.ZIndex=14; minBtn.Parent=hdr; corner(minBtn,5)
    minBtn.MouseEnter:Connect(function() tween(minBtn,{BackgroundColor3=C.ELEM_H},0.08) end)
    minBtn.MouseLeave:Connect(function() tween(minBtn,{BackgroundColor3=C.BTN_HDR},0.08) end)

    local minimized,savedH = false, WIN_H
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            savedH = win.AbsoluteSize.Y
            tween(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,HDR_H+1)},0.2)
        else
            tween(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,savedH)},0.2)
        end
    end)

    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size=UDim2.new(0,24,0,24); closeBtn.Position=UDim2.new(1,-28,0.5,-12)
    closeBtn.BackgroundColor3=C.BTN_HDR; closeBtn.BorderSizePixel=0
    closeBtn.Text="x"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=11
    closeBtn.TextColor3=Color3.fromRGB(180,185,210); closeBtn.AutoButtonColor=false
    closeBtn.ZIndex=14; closeBtn.Parent=hdr; corner(closeBtn,5)
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn,{BackgroundColor3=Color3.fromRGB(196,50,50),TextColor3=Color3.fromRGB(255,255,255)},0.08)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn,{BackgroundColor3=C.BTN_HDR,TextColor3=Color3.fromRGB(180,185,210)},0.08)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,0),BackgroundTransparency=1},0.18)
        task.delay(0.2,function() sg:Destroy() end)
    end)

    draggable(hdr,win)

    --------------------------------------------------------------------
    -- CORPO
    --------------------------------------------------------------------
    local body = Instance.new("Frame")
    body.Name="Body"; body.Size=UDim2.new(1,0,1,-HDR_H)
    body.Position=UDim2.new(0,0,0,HDR_H)
    body.BackgroundTransparency=1; body.BorderSizePixel=0
    body.ClipsDescendants=true; body.ZIndex=2; body.Parent=win

    --------------------------------------------------------------------
    -- SIDEBAR
    --------------------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Name="Sidebar"; sidebar.Size=UDim2.new(0,SIDE_W,1,0)
    sidebar.BackgroundColor3=C.SIDEBAR; sidebar.BorderSizePixel=0
    sidebar.ZIndex=3; sidebar.Parent=body

    -- divisor lateral
    local sdiv = Instance.new("Frame")
    sdiv.Size=UDim2.new(0,1,1,0); sdiv.Position=UDim2.new(1,-1,0,0)
    sdiv.BackgroundColor3=C.HDR_LINE; sdiv.BorderSizePixel=0
    sdiv.ZIndex=4; sdiv.Parent=sidebar

    -- scroll das tabs
    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Size=UDim2.new(1,-1,1,0)
    sideScroll.BackgroundTransparency=1; sideScroll.BorderSizePixel=0
    sideScroll.ScrollBarThickness=2; sideScroll.ScrollBarImageColor3=C.SCROLL
    sideScroll.ScrollBarImageTransparency=0.4
    sideScroll.CanvasSize=UDim2.new(0,0,0,0)
    sideScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sideScroll.ScrollingDirection=Enum.ScrollingDirection.Y
    sideScroll.ClipsDescendants=true
    sideScroll.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable
    sideScroll.ZIndex=4; sideScroll.Parent=sidebar

    local sideList = Instance.new("Frame")
    sideList.Size=UDim2.new(1,0,0,0); sideList.AutomaticSize=Enum.AutomaticSize.Y
    sideList.BackgroundTransparency=1; sideList.BorderSizePixel=0
    sideList.ZIndex=4; sideList.Parent=sideScroll
    vlist(sideList,2); pad(sideList,8,8,8,8)

    --------------------------------------------------------------------
    -- CONTEÚDO
    --------------------------------------------------------------------
    local contentPanel = Instance.new("Frame")
    contentPanel.Name="Content"
    contentPanel.Size=UDim2.new(1,-SIDE_W,1,0)
    contentPanel.Position=UDim2.new(0,SIDE_W,0,0)
    contentPanel.BackgroundColor3=C.CONTENT
    contentPanel.BorderSizePixel=0; contentPanel.ZIndex=3
    contentPanel.ClipsDescendants=true; contentPanel.Parent=body

    -- Título da tab ativa
    local secTitleLbl = Instance.new("TextLabel")
    secTitleLbl.Size=UDim2.new(1,-20,0,44)
    secTitleLbl.Position=UDim2.new(0,14,0,0)
    secTitleLbl.BackgroundTransparency=1; secTitleLbl.Text=""
    secTitleLbl.TextSize=24; secTitleLbl.Font=Enum.Font.GothamBold
    secTitleLbl.TextColor3=Color3.fromRGB(235,238,255)
    secTitleLbl.TextXAlignment=Enum.TextXAlignment.Left
    secTitleLbl.TextYAlignment=Enum.TextYAlignment.Center
    secTitleLbl.ZIndex=6; secTitleLbl.Parent=contentPanel

    -- Scroll do conteúdo
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name="Scroll"
    scroll.Position=UDim2.new(0,0,0,46)
    scroll.Size=UDim2.new(1,0,1,-50)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=2; scroll.ScrollBarImageColor3=C.SCROLL
    scroll.ScrollBarImageTransparency=0.35
    scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.ScrollingDirection=Enum.ScrollingDirection.Y
    scroll.ClipsDescendants=true; scroll.ZIndex=4; scroll.Parent=contentPanel
    vlist(scroll,6); pad(scroll,4,12,10,10)

    --------------------------------------------------------------------
    -- RESIZE HANDLES
    --------------------------------------------------------------------
    local resB,resR,resC=false,false,false
    local rsX,rsY,rsW,rsH=0,0,0,0

    local function mkResizeH(sz,pos,zi)
        local h=Instance.new("TextButton")
        h.Size=sz; h.Position=pos
        h.BackgroundColor3=Color3.fromRGB(50,54,75)
        h.BackgroundTransparency=0.72; h.BorderSizePixel=0
        h.AutoButtonColor=false; h.Text=""
        h.ZIndex=zi or 20; h.Parent=win; corner(h,4)
        return h
    end

    local rBot=mkResizeH(UDim2.new(1,-20,0,6),UDim2.new(0,10,1,-3),20)
    local rRig=mkResizeH(UDim2.new(0,6,1,-20),UDim2.new(1,-3,0,10),20)
    local rCor=mkResizeH(UDim2.new(0,11,0,11),UDim2.new(1,-11,1,-11),22)
    rCor.BackgroundColor3=C.SCHEME; rCor.BackgroundTransparency=0.5

    local function addDots(h,vert)
        local dc=Instance.new("Frame")
        dc.Size=vert and UDim2.new(0,3,0,22) or UDim2.new(0,22,0,3)
        dc.AnchorPoint=Vector2.new(0.5,0.5); dc.Position=UDim2.new(0.5,0,0.5,0)
        dc.BackgroundTransparency=1; dc.BorderSizePixel=0; dc.ZIndex=21; dc.Parent=h
        local ll=Instance.new("UIListLayout")
        ll.FillDirection=vert and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
        ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Padding=UDim.new(0,4); ll.Parent=dc
        for i=1,3 do
            local d=Instance.new("Frame")
            d.Size=vert and UDim2.new(0,3,0,4) or UDim2.new(0,4,0,3)
            d.BackgroundColor3=Color3.fromRGB(160,165,195)
            d.BackgroundTransparency=0.3; d.BorderSizePixel=0; d.ZIndex=22; d.Parent=dc; corner(d,2)
        end
    end
    addDots(rBot,false); addDots(rRig,true)

    local function hookRes(h,doW,doH)
        local baseT=doW and doH and 0.5 or 0.72
        h.MouseEnter:Connect(function() tween(h,{BackgroundTransparency=0.15},0.1) end)
        h.MouseLeave:Connect(function() tween(h,{BackgroundTransparency=baseT},0.1) end)
        h.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.Touch then
                if doW and doH then resC=true
                elseif doW     then resR=true
                else                resB=true end
                rsX=inp.Position.X; rsY=inp.Position.Y
                rsW=win.AbsoluteSize.X; rsH=win.AbsoluteSize.Y
                inp.Changed:Connect(function()
                    if inp.UserInputState==Enum.UserInputState.End then
                        resB=false;resR=false;resC=false
                        tween(h,{BackgroundTransparency=baseT},0.1)
                    end
                end)
            end
        end)
    end
    hookRes(rBot,false,true); hookRes(rRig,true,false); hookRes(rCor,true,true)

    UserInputService.InputChanged:Connect(function(inp)
        if (resB or resR or resC) and
           (inp.UserInputType==Enum.UserInputType.MouseMovement
         or inp.UserInputType==Enum.UserInputType.Touch) then
            local dx=inp.Position.X-rsX; local dy=inp.Position.Y-rsY
            local nW=win.AbsoluteSize.X; local nH=win.AbsoluteSize.Y
            if resR or resC then nW=math.clamp(rsW+dx,WIN_MIN_W,WIN_MAX_W) end
            if resB or resC then nH=math.clamp(rsH+dy,WIN_MIN_H,WIN_MAX_H) end
            win.Size=UDim2.new(0,nW,0,nH)
        end
    end)

    --------------------------------------------------------------------
    -- Window:NewTab
    --------------------------------------------------------------------
    local Window    = {}
    local tabPanels = {}
    local defaultIcons={"🏠","⚔️","📄","⚙️","🎯","👁","🔧","🥊","💎","🌍","🔄","📦"}
    local tabIndex  = 0

    local function showTab(tabData)
        for _,td in ipairs(tabPanels) do
            td.panel.Visible=false
            tween(td.btn,{BackgroundColor3=C.TAB_OFF},0.14)
            tween(td.nameLbl,{TextColor3=C.TAB_TXT_OFF},0.12)
            if td.iconLbl then tween(td.iconLbl,{TextColor3=C.TAB_TXT_OFF},0.12) end
            if td.indic   then tween(td.indic,{BackgroundTransparency=1},0.12) end
        end
        tabData.panel.Visible=true
        tween(tabData.btn,{BackgroundColor3=C.TAB_ON},0.16)
        tween(tabData.nameLbl,{TextColor3=C.TAB_TXT_ON},0.12)
        if tabData.iconLbl then tween(tabData.iconLbl,{TextColor3=C.TAB_ICON_ON},0.12) end
        if tabData.indic   then tween(tabData.indic,{BackgroundTransparency=0},0.14) end
        secTitleLbl.Text=tabData.cleanName
        _activeTab=tabData
    end

    function Window:NewTab(tabName, catName)
        tabName  = tabName  or "Tab"
        tabIndex = tabIndex + 1

        local iconStr   = defaultIcons[tabIndex] or "•"
        local cleanName = tabName
        local ei,en     = tabName:match("^(.-)・(.+)$")
        if ei and en then iconStr=ei; cleanName=en end

        -- Categoria acima do grupo
        if catName and catName ~= "" then
            local cl = Instance.new("TextLabel")
            cl.Size=UDim2.new(1,0,0,22); cl.BackgroundTransparency=1
            cl.Text=string.upper(catName); cl.TextSize=9
            cl.Font=Enum.Font.GothamBold; cl.TextColor3=C.SIDE_CAT
            cl.TextXAlignment=Enum.TextXAlignment.Left
            cl.TextYAlignment=Enum.TextYAlignment.Center
            cl.ZIndex=5; cl.Parent=sideList
            pad(cl,0,0,6,0)
        end

        -- Botão da tab
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size=UDim2.new(1,0,0,36); tabBtn.BackgroundColor3=C.TAB_OFF
        tabBtn.BorderSizePixel=0; tabBtn.AutoButtonColor=false; tabBtn.Text=""
        tabBtn.ZIndex=5; tabBtn.Parent=sideList; corner(tabBtn,8)

        -- indicador lateral
        local indic = Instance.new("Frame")
        indic.Size=UDim2.new(0,3,0.55,0); indic.AnchorPoint=Vector2.new(0,0.5)
        indic.Position=UDim2.new(0,0,0.5,0)
        indic.BackgroundColor3=C.TAB_ON; indic.BackgroundTransparency=1
        indic.BorderSizePixel=0; indic.ZIndex=7; indic.Parent=tabBtn; corner(indic,2)

        -- ícone
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size=UDim2.new(0,22,1,0); tabIcon.Position=UDim2.new(0,10,0,0)
        tabIcon.BackgroundTransparency=1; tabIcon.Text=iconStr
        tabIcon.TextScaled=true; tabIcon.Font=Enum.Font.GothamBold
        tabIcon.TextColor3=C.TAB_TXT_OFF
        tabIcon.TextXAlignment=Enum.TextXAlignment.Center
        tabIcon.ZIndex=6; tabIcon.Parent=tabBtn

        -- nome
        local tabNameLbl = Instance.new("TextLabel")
        tabNameLbl.Size=UDim2.new(1,-38,1,0); tabNameLbl.Position=UDim2.new(0,36,0,0)
        tabNameLbl.BackgroundTransparency=1; tabNameLbl.Text=cleanName
        tabNameLbl.TextSize=12; tabNameLbl.Font=Enum.Font.GothamSemibold
        tabNameLbl.TextColor3=C.TAB_TXT_OFF
        tabNameLbl.TextXAlignment=Enum.TextXAlignment.Left
        tabNameLbl.TextYAlignment=Enum.TextYAlignment.Center
        tabNameLbl.ZIndex=6; tabNameLbl.Parent=tabBtn

        -- painel de conteúdo
        local panel = Instance.new("Frame")
        panel.Name="Panel_"..cleanName
        panel.Size=UDim2.new(1,0,0,0); panel.AutomaticSize=Enum.AutomaticSize.Y
        panel.BackgroundTransparency=1; panel.BorderSizePixel=0
        panel.Visible=false; panel.ZIndex=5; panel.Parent=scroll
        vlist(panel,CELL_GAP)

        local tabData={btn=tabBtn,panel=panel,nameLbl=tabNameLbl,
            iconLbl=tabIcon,indic=indic,cleanName=cleanName}
        table.insert(tabPanels,tabData)

        tabBtn.MouseButton1Click:Connect(function() showTab(tabData) end)
        tabBtn.MouseEnter:Connect(function()
            if _activeTab~=tabData then
                tween(tabBtn,{BackgroundColor3=C.TAB_H},0.08)
                tween(tabNameLbl,{TextColor3=Color3.fromRGB(200,205,228)},0.08)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if _activeTab~=tabData then
                tween(tabBtn,{BackgroundColor3=C.TAB_OFF},0.08)
                tween(tabNameLbl,{TextColor3=C.TAB_TXT_OFF},0.08)
            end
        end)
        if tabIndex==1 then task.defer(function() showTab(tabData) end) end

        ----------------------------------------------------------
        -- Tab:NewSection
        ----------------------------------------------------------
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"
            local secClean = secName
            local _,sn = secName:match("^.+・(.+)$")
            if sn then secClean=sn end

            -- header da seção
            local sh = Instance.new("Frame")
            sh.Size=UDim2.new(1,0,0,26); sh.BackgroundTransparency=1
            sh.BorderSizePixel=0; sh.ZIndex=5; sh.Parent=panel

            local shl = Instance.new("TextLabel")
            shl.Size=UDim2.new(1,0,1,0); shl.BackgroundTransparency=1
            shl.Text=secClean; shl.TextSize=11; shl.Font=Enum.Font.GothamSemibold
            shl.TextColor3=C.SEC_TXT
            shl.TextXAlignment=Enum.TextXAlignment.Left
            shl.TextYAlignment=Enum.TextYAlignment.Center
            shl.ZIndex=6; shl.Parent=sh

            -- linha divisória
            local sl2 = Instance.new("Frame")
            sl2.Size=UDim2.new(1,0,0,1); sl2.Position=UDim2.new(0,0,1,-1)
            sl2.BackgroundColor3=C.DIV; sl2.BorderSizePixel=0
            sl2.ZIndex=6; sl2.Parent=sh

            local Section = {}

            -- ===================================================
            -- GRID 2 colunas  (todos os elementos)
            -- Cada "linha" é um Frame horizontal com 2 filhos
            -- ===================================================
            local curRow   = nil
            local rowCount = 0

            -- Cria nova linha de grid
            local function newGridRow()
                local r = Instance.new("Frame")
                r.Size=UDim2.new(1,0,0,EH)
                r.BackgroundTransparency=1; r.BorderSizePixel=0
                r.ZIndex=5; r.Parent=panel
                hlist(r, CELL_GAP)
                return r
            end

            -- Retorna um Frame célula (metade da linha)
            local function getCell(forceFullWidth)
                if forceFullWidth then
                    curRow=nil; rowCount=0
                    local f=Instance.new("Frame")
                    f.Size=UDim2.new(1,0,0,EH)
                    f.BackgroundColor3=C.ELEM; f.BorderSizePixel=0
                    f.ZIndex=5; f.Parent=panel
                    corner(f,12); stroke(f,C.ELEM_STR,1)
                    return f
                end
                if rowCount==0 or rowCount>=2 then
                    curRow=newGridRow(); rowCount=0
                end
                rowCount=rowCount+1
                local half = rowCount==1 and UDim2.new(0.5,-math.ceil(CELL_GAP/2),1,0)
                                          or UDim2.new(0.5,-math.floor(CELL_GAP/2),1,0)
                local f=Instance.new("Frame")
                f.Size=half
                f.BackgroundColor3=C.ELEM; f.BorderSizePixel=0
                f.ZIndex=5; f.Parent=curRow
                corner(f,12); stroke(f,C.ELEM_STR,1)
                return f
            end

            -- Botão célula (clicável)
            local function getCellBtn(forceFullWidth)
                if forceFullWidth then
                    curRow=nil; rowCount=0
                    local b=Instance.new("TextButton")
                    b.Size=UDim2.new(1,0,0,EH)
                    b.BackgroundColor3=C.ELEM; b.BorderSizePixel=0
                    b.AutoButtonColor=false; b.Text=""
                    b.ZIndex=5; b.Parent=panel
                    corner(b,12); stroke(b,C.ELEM_STR,1)
                    b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=C.ELEM_H},0.08) end)
                    b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=C.ELEM},0.08) end)
                    return b
                end
                if rowCount==0 or rowCount>=2 then
                    curRow=newGridRow(); rowCount=0
                end
                rowCount=rowCount+1
                local half = rowCount==1 and UDim2.new(0.5,-math.ceil(CELL_GAP/2),1,0)
                                          or UDim2.new(0.5,-math.floor(CELL_GAP/2),1,0)
                local b=Instance.new("TextButton")
                b.Size=half
                b.BackgroundColor3=C.ELEM; b.BorderSizePixel=0
                b.AutoButtonColor=false; b.Text=""
                b.ZIndex=5; b.Parent=curRow
                corner(b,12); stroke(b,C.ELEM_STR,1)
                b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=C.ELEM_H},0.08) end)
                b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=C.ELEM},0.08) end)
                return b
            end

            -- Ícone quadrado escuro à esquerda
            local function mkIcon(parent, txt, col)
                col = col or C.SCHEME
                local bg = Instance.new("Frame")
                bg.Size=UDim2.new(0,36,0,36)
                bg.Position=UDim2.new(0,10,0.5,-18)
                bg.BackgroundColor3=col
                bg.BackgroundTransparency=0.76
                bg.BorderSizePixel=0; bg.ZIndex=7; bg.Parent=parent
                corner(bg,10)
                local il=Instance.new("TextLabel")
                il.Size=UDim2.new(1,0,1,0); il.BackgroundTransparency=1
                il.Text=txt or "•"; il.TextScaled=true
                il.Font=Enum.Font.GothamBold; il.TextColor3=col
                il.TextXAlignment=Enum.TextXAlignment.Center
                il.TextYAlignment=Enum.TextYAlignment.Center
                il.ZIndex=8; il.Parent=bg
                return bg
            end

            -- Título + subtítulo à direita do ícone
            local function mkTS(parent, title, sub, subCol)
                local tl=Instance.new("TextLabel")
                tl.Size=UDim2.new(1,-100,0,18)
                tl.Position=UDim2.new(0,54,0,17)
                tl.BackgroundTransparency=1; tl.Text=title or ""
                tl.TextSize=13; tl.Font=Enum.Font.GothamBold
                tl.TextColor3=C.TXT
                tl.TextXAlignment=Enum.TextXAlignment.Left
                tl.TextTruncate=Enum.TextTruncate.AtEnd
                tl.ZIndex=6; tl.Parent=parent

                local sl3=Instance.new("TextLabel")
                sl3.Size=UDim2.new(1,-100,0,14)
                sl3.Position=UDim2.new(0,54,0,35)
                sl3.BackgroundTransparency=1; sl3.Text=sub or ""
                sl3.TextSize=10; sl3.Font=Enum.Font.GothamBold
                sl3.TextColor3=subCol or C.TXT_DIM
                sl3.TextXAlignment=Enum.TextXAlignment.Left
                sl3.TextTruncate=Enum.TextTruncate.AtEnd
                sl3.ZIndex=6; sl3.Parent=parent
                return tl, sl3
            end

            --------------------------------------------------------
            -- NewDiscord
            --------------------------------------------------------
            function Section:NewDiscord(serverName, serverDesc, imageId, inviteUrl)
                curRow=nil; rowCount=0
                serverName = serverName or "Discord Server"
                serverDesc = serverDesc or "Join our community!"
                inviteUrl  = inviteUrl  or ""

                local card = Instance.new("Frame")
                card.Size=UDim2.new(1,0,0,0); card.AutomaticSize=Enum.AutomaticSize.Y
                card.BackgroundColor3=C.DISC_BG; card.BorderSizePixel=0
                card.ZIndex=5; card.Parent=panel
                corner(card,12); stroke(card,C.ELEM_STR,1)

                -- banner imagem
                if imageId and imageId~="" then
                    local ban=Instance.new("ImageLabel")
                    ban.Size=UDim2.new(1,0,0,90)
                    ban.BackgroundColor3=Color3.fromRGB(18,20,30)
                    ban.BorderSizePixel=0
                    ban.Image="rbxassetid://"..tostring(imageId)
                    ban.ScaleType=Enum.ScaleType.Crop
                    ban.ZIndex=6; ban.Parent=card; corner(ban,12)
                    -- patch inferior
                    local bp=Instance.new("Frame")
                    bp.Size=UDim2.new(1,0,0,12); bp.Position=UDim2.new(0,0,1,-12)
                    bp.BackgroundColor3=Color3.fromRGB(18,20,30)
                    bp.BorderSizePixel=0; bp.ZIndex=7; bp.Parent=ban
                end

                local infoY = (imageId and imageId~="") and 90 or 0
                local infoRow = Instance.new("Frame")
                infoRow.Size=UDim2.new(1,0,0,58)
                infoRow.Position=UDim2.new(0,0,0,infoY)
                infoRow.BackgroundTransparency=1; infoRow.BorderSizePixel=0
                infoRow.ZIndex=6; infoRow.Parent=card

                local nl=Instance.new("TextLabel")
                nl.Size=UDim2.new(1,-100,0,20); nl.Position=UDim2.new(0,12,0,10)
                nl.BackgroundTransparency=1; nl.Text=serverName
                nl.TextSize=14; nl.Font=Enum.Font.GothamBold
                nl.TextColor3=C.TXT; nl.TextXAlignment=Enum.TextXAlignment.Left
                nl.TextTruncate=Enum.TextTruncate.AtEnd; nl.ZIndex=7; nl.Parent=infoRow

                local dl=Instance.new("TextLabel")
                dl.Size=UDim2.new(1,-100,0,22); dl.Position=UDim2.new(0,12,0,29)
                dl.BackgroundTransparency=1; dl.Text=serverDesc
                dl.TextSize=10; dl.Font=Enum.Font.Gotham
                dl.TextColor3=C.TXT_DIM; dl.TextXAlignment=Enum.TextXAlignment.Left
                dl.TextWrapped=true; dl.ZIndex=7; dl.Parent=infoRow

                local jBtn=Instance.new("TextButton")
                jBtn.Size=UDim2.new(0,60,0,30); jBtn.Position=UDim2.new(1,-70,0.5,-15)
                jBtn.BackgroundColor3=C.DISC_JOIN; jBtn.BorderSizePixel=0
                jBtn.Text="Join"; jBtn.Font=Enum.Font.GothamBold; jBtn.TextSize=13
                jBtn.TextColor3=Color3.fromRGB(255,255,255); jBtn.AutoButtonColor=false
                jBtn.ZIndex=8; jBtn.Parent=infoRow; corner(jBtn,8)
                jBtn.MouseEnter:Connect(function()
                    tween(jBtn,{BackgroundColor3=Color3.fromRGB(60,215,100)},0.1)
                end)
                jBtn.MouseLeave:Connect(function()
                    tween(jBtn,{BackgroundColor3=C.DISC_JOIN},0.1)
                end)
                jBtn.MouseButton1Click:Connect(function()
                    if inviteUrl~="" then pcall(function() setclipboard(inviteUrl) end) end
                    tween(jBtn,{BackgroundColor3=Color3.fromRGB(120,240,160)},0.07)
                    task.delay(0.1,function() tween(jBtn,{BackgroundColor3=C.DISC_JOIN},0.18) end)
                end)
                return {}
            end

            --------------------------------------------------------
            -- NewToggle  — pill switch, 2 por linha
            --------------------------------------------------------
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local on  = false

                local iconChar="◎"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName = dispName:match("^・?(.+)$") or dispName

                local cell = getCellBtn(false)
                mkIcon(cell, iconChar, C.SCHEME)
                local _,sl4 = mkTS(cell, dispName, tip or "DISABLE", C.TXT_DIM)

                -- Pill
                local pillBg = Instance.new("Frame")
                pillBg.Size=UDim2.new(0,38,0,21)
                pillBg.Position=UDim2.new(1,-46,0.5,-10.5)
                pillBg.BackgroundColor3=C.TOG_OFF
                pillBg.BorderSizePixel=0; pillBg.ZIndex=7; pillBg.Parent=cell
                corner(pillBg,11)

                local circle = Instance.new("Frame")
                circle.Size=UDim2.new(0,15,0,15)
                circle.Position=UDim2.new(0,3,0.5,-7.5)
                circle.BackgroundColor3=Color3.fromRGB(255,255,255)
                circle.BorderSizePixel=0; circle.ZIndex=8; circle.Parent=pillBg
                corner(circle,9)

                local function setState(v)
                    on=v
                    if on then
                        tween(pillBg,{BackgroundColor3=C.TOG_ON},0.15)
                        tween(circle,{Position=UDim2.new(0,20,0.5,-7.5)},0.15,
                            Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                        sl4.Text="ACTIVE"; sl4.TextColor3=C.TXT_ACTIVE
                    else
                        tween(pillBg,{BackgroundColor3=C.TOG_OFF},0.13)
                        tween(circle,{Position=UDim2.new(0,3,0.5,-7.5)},0.13)
                        sl4.Text="DISABLE"; sl4.TextColor3=C.TXT_DIM
                    end
                end

                cell.MouseButton1Click:Connect(function()
                    setState(not on); pcall(callback,on)
                end)

                local T={}
                function T:UpdateToggle(a,b)
                    local v=(typeof(a)=="boolean") and a or (typeof(b)=="boolean") and b or nil
                    if v~=nil then setState(v) end
                end
                function T:SetToggle(v) setState(v) end
                return T
            end

            --------------------------------------------------------
            -- NewButton  — 2 por linha
            --------------------------------------------------------
            function Section:NewButton(name, tip, callback)
                callback = callback or function() end
                local iconChar="▶"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName = dispName:match("^・?(.+)$") or dispName

                local cell = getCellBtn(false)
                mkIcon(cell, iconChar, C.SCHEME)
                local tl2,_ = mkTS(cell, dispName, tip or "")

                cell.MouseButton1Click:Connect(function()
                    tween(cell,{BackgroundColor3=Color3.fromRGB(50,60,100)},0.06)
                    task.delay(0.1,function() tween(cell,{BackgroundColor3=C.ELEM},0.14) end)
                    pcall(callback)
                end)

                local B={}
                function B:UpdateButton(t) tl2.Text=t or name end
                return B
            end

            --------------------------------------------------------
            -- NewDropdown  — 2 por linha, sem bug de emoji na seta
            --------------------------------------------------------
            function Section:NewDropdown(name, tip, options, callback)
                options  = options  or {}
                callback = callback or function() end
                local isOpen   = false
                local selVal   = nil

                local iconChar="≡"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName = dispName:match("^・?(.+)$") or dispName

                -- Forçamos nova linha se rowCount>=2 para o dropdown
                -- O dropdown ocupa meia linha (igual toggle/button)
                if rowCount==0 or rowCount>=2 then
                    curRow=newGridRow(); rowCount=0
                end
                rowCount=rowCount+1
                local half = rowCount==1 and UDim2.new(0.5,-math.ceil(CELL_GAP/2),1,0)
                                          or UDim2.new(0.5,-math.floor(CELL_GAP/2),1,0)

                -- Frame externo (cresce ao abrir)
                local outer=Instance.new("Frame")
                outer.Name="DD_"..dispName
                outer.Size=half
                outer.BackgroundColor3=C.ELEM; outer.BorderSizePixel=0
                outer.ClipsDescendants=true; outer.ZIndex=6; outer.Parent=curRow
                corner(outer,12); stroke(outer,C.ELEM_STR,1)

                -- Cabeçalho (altura EH)
                local dHead=Instance.new("TextButton")
                dHead.Size=UDim2.new(1,0,0,EH)
                dHead.BackgroundTransparency=1; dHead.BorderSizePixel=0
                dHead.AutoButtonColor=false; dHead.Text=""
                dHead.ZIndex=7; dHead.Parent=outer

                mkIcon(dHead, iconChar, C.SCHEME)

                local dTitle=Instance.new("TextLabel")
                dTitle.Size=UDim2.new(1,-52,0,18)
                dTitle.Position=UDim2.new(0,54,0,17)
                dTitle.BackgroundTransparency=1; dTitle.Text=dispName
                dTitle.TextSize=13; dTitle.Font=Enum.Font.GothamBold
                dTitle.TextColor3=C.TXT; dTitle.TextXAlignment=Enum.TextXAlignment.Left
                dTitle.TextTruncate=Enum.TextTruncate.AtEnd; dTitle.ZIndex=8; dTitle.Parent=dHead

                local dSub=Instance.new("TextLabel")
                dSub.Size=UDim2.new(1,-52,0,14)
                dSub.Position=UDim2.new(0,54,0,35)
                dSub.BackgroundTransparency=1; dSub.Text="Select: "..(#options>0 and tostring(options[1]) or "-")
                dSub.TextSize=10; dSub.Font=Enum.Font.Gotham
                dSub.TextColor3=C.TXT_DIM; dSub.TextXAlignment=Enum.TextXAlignment.Left
                dSub.TextTruncate=Enum.TextTruncate.AtEnd; dSub.ZIndex=8; dSub.Parent=dHead

                -- Seta (TextLabel simples, SEM emoji — corrige bug)
                local arrowLbl=Instance.new("TextLabel")
                arrowLbl.Size=UDim2.new(0,18,0,18)
                arrowLbl.Position=UDim2.new(1,-24,0.5,-9)
                arrowLbl.BackgroundTransparency=1; arrowLbl.Text="v"
                arrowLbl.Font=Enum.Font.GothamBold; arrowLbl.TextSize=12
                arrowLbl.TextColor3=C.TXT_MID
                arrowLbl.TextXAlignment=Enum.TextXAlignment.Center
                arrowLbl.TextYAlignment=Enum.TextYAlignment.Center
                arrowLbl.ZIndex=9; arrowLbl.Parent=dHead

                -- Divisória
                local dDiv=Instance.new("Frame")
                dDiv.Size=UDim2.new(1,-12,0,1); dDiv.Position=UDim2.new(0,6,0,EH)
                dDiv.BackgroundColor3=C.DIV; dDiv.BorderSizePixel=0
                dDiv.ZIndex=7; dDiv.Parent=outer

                -- Caixa de opções
                local optBox=Instance.new("Frame")
                optBox.Size=UDim2.new(1,0,0,0); optBox.Position=UDim2.new(0,0,0,EH+1)
                optBox.BackgroundTransparency=1; optBox.BorderSizePixel=0
                optBox.ZIndex=8; optBox.Parent=outer
                local optLL=vlist(optBox,3); pad(optBox,4,4,6,6)

                local function buildOpts(lst)
                    for _,ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _,opt in ipairs(lst) do
                        local ob=Instance.new("TextButton")
                        ob.Size=UDim2.new(1,0,0,28)
                        ob.BackgroundColor3=C.OPT; ob.BorderSizePixel=0
                        ob.AutoButtonColor=false
                        ob.Text="  "..tostring(opt)
                        ob.Font=Enum.Font.GothamSemibold; ob.TextSize=12
                        ob.TextColor3=C.TXT_MID
                        ob.TextXAlignment=Enum.TextXAlignment.Left
                        ob.ZIndex=10; ob.Parent=optBox; corner(ob,6)
                        ob.MouseEnter:Connect(function()
                            tween(ob,{BackgroundColor3=C.OPT_H,TextColor3=C.TXT},0.07)
                        end)
                        ob.MouseLeave:Connect(function()
                            tween(ob,{BackgroundColor3=C.OPT,TextColor3=C.TXT_MID},0.07)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            selVal=opt
                            local sv=tostring(opt)
                            if #sv>10 then sv=sv:sub(1,9)..".." end
                            dSub.Text="Select: "..sv
                            isOpen=false; arrowLbl.Text="v"
                            tween(outer,{Size=half},0.14,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
                            pcall(callback,opt)
                        end)
                    end
                end
                buildOpts(options)

                dHead.MouseEnter:Connect(function() tween(outer,{BackgroundColor3=C.ELEM_H},0.08) end)
                dHead.MouseLeave:Connect(function() tween(outer,{BackgroundColor3=C.ELEM},0.08) end)

                dHead.MouseButton1Click:Connect(function()
                    isOpen=not isOpen
                    if isOpen then
                        arrowLbl.Text="^"
                        local oh=optLL.AbsoluteContentSize.Y+8
                        local openSize=UDim2.new(half.X.Scale,half.X.Offset,0,EH+1+oh)
                        tween(outer,{Size=openSize},0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
                    else
                        arrowLbl.Text="v"
                        tween(outer,{Size=half},0.13,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
                    end
                end)

                local D={}
                function D:Refresh(newList,keep)
                    options=newList or {}
                    if not keep then
                        dSub.Text="Select: "..(#options>0 and tostring(options[1]) or "-")
                    end
                    buildOpts(options)
                    if isOpen then
                        local oh=optLL.AbsoluteContentSize.Y+8
                        outer.Size=UDim2.new(half.X.Scale,half.X.Offset,0,EH+1+oh)
                    end
                end
                function D:SetSelected(v)
                    selVal=v
                    local sv=tostring(v)
                    if #sv>10 then sv=sv:sub(1,9)..".." end
                    dSub.Text="Select: "..sv
                end
                function D:GetSelected() return selVal end
                return D
            end

            --------------------------------------------------------
            -- NewLabel
            --------------------------------------------------------
            function Section:NewLabel(text)
                curRow=nil; rowCount=0
                local row=Instance.new("Frame")
                row.Size=UDim2.new(1,0,0,26)
                row.BackgroundTransparency=1; row.BorderSizePixel=0
                row.ZIndex=5; row.Parent=panel

                local nl=Instance.new("TextLabel")
                nl.Size=UDim2.new(1,-8,0,26); nl.Position=UDim2.new(0,4,0,0)
                nl.BackgroundTransparency=1; nl.Text=text or ""
                nl.TextSize=11; nl.Font=Enum.Font.Gotham
                nl.TextColor3=C.TXT_DIM
                nl.TextXAlignment=Enum.TextXAlignment.Left
                nl.TextYAlignment=Enum.TextYAlignment.Center
                nl.TextWrapped=true; nl.ZIndex=6; nl.Parent=row

                nl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h=math.max(26,nl.TextBounds.Y+8)
                    row.Size=UDim2.new(1,0,0,h); nl.Size=UDim2.new(1,-8,0,h)
                end)

                local L={}
                function L:UpdateLabel(t) nl.Text=t or "" end
                return L
            end

            --------------------------------------------------------
            -- NewSlider  — largura total
            --------------------------------------------------------
            function Section:NewSlider(name, tip, maxV, minV, callback)
                curRow=nil; rowCount=0
                maxV=tonumber(maxV) or 100; minV=tonumber(minV) or 0
                callback=callback or function() end; local cur=minV

                local dispName=(name:match("^・?(.+)$") or name)
                local row=Instance.new("Frame")
                row.Size=UDim2.new(1,0,0,EH+8)
                row.BackgroundColor3=C.ELEM; row.BorderSizePixel=0
                row.ZIndex=5; row.Parent=panel
                corner(row,12); stroke(row,C.ELEM_STR,1)

                local nLbl=Instance.new("TextLabel")
                nLbl.Size=UDim2.new(1,-14,0,20); nLbl.Position=UDim2.new(0,14,0,10)
                nLbl.BackgroundTransparency=1
                nLbl.Text=dispName.."  "..tostring(cur)
                nLbl.TextSize=13; nLbl.Font=Enum.Font.GothamBold
                nLbl.TextColor3=C.TXT; nLbl.TextXAlignment=Enum.TextXAlignment.Left
                nLbl.ZIndex=6; nLbl.Parent=row

                local track=Instance.new("Frame")
                track.Size=UDim2.new(1,-28,0,5); track.Position=UDim2.new(0,14,0,44)
                track.BackgroundColor3=C.SL_TR; track.BorderSizePixel=0
                track.ZIndex=6; track.Parent=row; corner(track,3)

                local fill=Instance.new("Frame")
                fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=C.SL_FILL
                fill.BorderSizePixel=0; fill.ZIndex=7; fill.Parent=track; corner(fill,3)

                local handle=Instance.new("Frame")
                handle.Size=UDim2.new(0,13,0,13); handle.AnchorPoint=Vector2.new(0.5,0.5)
                handle.Position=UDim2.new(0,0,0.5,0)
                handle.BackgroundColor3=Color3.fromRGB(255,255,255)
                handle.BorderSizePixel=0; handle.ZIndex=9; handle.Parent=track; corner(handle,7)

                local grab=Instance.new("TextButton")
                grab.Size=UDim2.new(1,0,0,26); grab.Position=UDim2.new(0,0,0.5,-13)
                grab.BackgroundTransparency=1; grab.Text=""
                grab.ZIndex=10; grab.Parent=track

                local mouse=Players.LocalPlayer:GetMouse()
                local sliding=false

                local function applyX(mx)
                    local tw2=track.AbsoluteSize.X
                    local rx=math.clamp(mx-track.AbsolutePosition.X,0,tw2)
                    local pct=rx/math.max(tw2,1)
                    cur=math.floor(minV+(maxV-minV)*pct)
                    fill.Size=UDim2.new(0,rx,1,0)
                    handle.Position=UDim2.new(0,rx,0.5,0)
                    nLbl.Text=dispName.."  "..tostring(cur)
                    pcall(callback,cur)
                end

                grab.MouseButton1Down:Connect(function() sliding=true; applyX(mouse.X) end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
                end)
                mouse.Move:Connect(function() if sliding then applyX(mouse.X) end end)

                local S={}
                function S:UpdateSlider(v)
                    cur=math.clamp(tonumber(v) or minV,minV,maxV)
                    local pct=(cur-minV)/math.max(maxV-minV,1)
                    fill.Size=UDim2.new(pct,0,1,0); handle.Position=UDim2.new(pct,0,0.5,0)
                    nLbl.Text=dispName.."  "..tostring(cur)
                end
                return S
            end

            --------------------------------------------------------
            -- NewTextBox  — 2 por linha
            --------------------------------------------------------
            function Section:NewTextBox(name, tip, callback)
                callback=callback or function() end
                local iconChar="T"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                local cell=getCell(false)
                mkIcon(cell,iconChar,C.SCHEME)
                mkTS(cell,dispName,tip or "")

                local badgeBg=Instance.new("Frame")
                badgeBg.Size=UDim2.new(0,52,0,26)
                badgeBg.Position=UDim2.new(1,-58,0.5,-13)
                badgeBg.BackgroundColor3=C.BADGE_BG; badgeBg.BorderSizePixel=0
                badgeBg.ZIndex=7; badgeBg.Parent=cell; corner(badgeBg,7); stroke(badgeBg,C.BADGE_STR,1)

                local tb=Instance.new("TextBox")
                tb.Size=UDim2.new(1,-6,1,0); tb.Position=UDim2.new(0,3,0,0)
                tb.BackgroundTransparency=1; tb.Text=""
                tb.PlaceholderText=tip or "..."
                tb.PlaceholderColor3=C.TXT_DIM; tb.Font=Enum.Font.GothamBold
                tb.TextSize=12; tb.TextColor3=C.BADGE_TXT
                tb.TextXAlignment=Enum.TextXAlignment.Center
                tb.TextYAlignment=Enum.TextYAlignment.Center
                tb.ClearTextOnFocus=false; tb.ZIndex=8; tb.Parent=badgeBg

                tb.Focused:Connect(function()
                    tween(badgeBg,{BackgroundColor3=C.ELEM_H},0.1); stroke(badgeBg,C.SCHEME,1)
                end)
                tb.FocusLost:Connect(function(enter)
                    tween(badgeBg,{BackgroundColor3=C.BADGE_BG},0.1); stroke(badgeBg,C.BADGE_STR,1)
                    if enter then pcall(callback,tb.Text) end
                end)

                local TX={}
                function TX:SetText(s) pcall(function() tb.Text=tostring(s or "") end) end
                function TX:GetText() return tb.Text end
                function TX:Clear() tb.Text="" end
                return TX
            end

            --------------------------------------------------------
            -- NewKeybind  — 2 por linha
            --------------------------------------------------------
            function Section:NewKeybind(name, tip, defaultKey, callback)
                defaultKey=defaultKey or Enum.KeyCode.F
                callback=callback or function() end
                local curKey=defaultKey; local listening=false

                local iconChar="K"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                local cell=getCellBtn(false)
                mkIcon(cell,iconChar,C.SCHEME)
                mkTS(cell,dispName,tip or "")

                local kBg=Instance.new("Frame")
                kBg.Size=UDim2.new(0,50,0,24)
                kBg.Position=UDim2.new(1,-56,0.5,-12)
                kBg.BackgroundColor3=C.BADGE_BG; kBg.BorderSizePixel=0
                kBg.ZIndex=7; kBg.Parent=cell; corner(kBg,6); stroke(kBg,C.BADGE_STR,1)

                local kLbl=Instance.new("TextLabel")
                kLbl.Size=UDim2.new(1,0,1,0); kLbl.BackgroundTransparency=1
                kLbl.Text=defaultKey.Name; kLbl.Font=Enum.Font.GothamBold; kLbl.TextSize=11
                kLbl.TextColor3=C.BADGE_TXT
                kLbl.TextXAlignment=Enum.TextXAlignment.Center
                kLbl.TextYAlignment=Enum.TextYAlignment.Center
                kLbl.ZIndex=8; kLbl.Parent=kBg

                cell.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening=true; kLbl.Text="..."; kLbl.TextColor3=C.TXT_DIM; stroke(kBg,C.SCHEME,1)
                    local conn
                    conn=UserInputService.InputBegan:Connect(function(inp,gp)
                        if not gp and inp.UserInputType==Enum.UserInputType.Keyboard then
                            curKey=inp.KeyCode; kLbl.Text=inp.KeyCode.Name
                            kLbl.TextColor3=C.BADGE_TXT; listening=false
                            stroke(kBg,C.BADGE_STR,1); conn:Disconnect()
                        end
                    end)
                end)

                UserInputService.InputBegan:Connect(function(inp,gp)
                    if not gp and not listening and inp.KeyCode==curKey then pcall(callback) end
                end)

                return {}
            end

            return Section
        end -- NewSection

        return Tab
    end -- NewTab

    ------------------------------------------------------------------
    -- Utilitários
    ------------------------------------------------------------------
    function Window:ToggleUI()
        if _GUI then _GUI.Enabled=not _GUI.Enabled end
    end

    function Window:ChangeColor(propOrTable, color)
        if typeof(propOrTable)=="table" then
            local t=propOrTable
            if t.SchemeColor then
                C.SCHEME=t.SchemeColor; C.SL_FILL=t.SchemeColor; C.TAB_ON=t.SchemeColor
                C.TXT_ACTIVE=t.SchemeColor; C.SCROLL=t.SchemeColor; C.TOG_ON=t.SchemeColor
            end
            if t.Background   then C.WIN=t.Background   end
            if t.TextColor    then C.TXT=t.TextColor    end
            if t.ElementColor then C.ELEM=t.ElementColor end
        elseif typeof(propOrTable)=="string" then
            if propOrTable=="SchemeColor" then
                C.SCHEME=color; C.SL_FILL=color; C.TAB_ON=color
                C.TXT_ACTIVE=color; C.SCROLL=color; C.TOG_ON=color
            elseif propOrTable=="Background"   then C.WIN=color
            elseif propOrTable=="TextColor"    then C.TXT=color
            elseif propOrTable=="ElementColor" then C.ELEM=color
            end
        end
    end

    ------------------------------------------------------------------
    -- INTRO → mostra GUI
    ------------------------------------------------------------------
    playIntro(title, function()
        sg.Enabled=true
        win.Size=UDim2.new(0,WIN_W,0,0); win.BackgroundTransparency=1
        tween(win,{Size=UDim2.new(0,WIN_W,0,WIN_H),BackgroundTransparency=0},0.36,
            Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    end)

    return Window
end

------------------------------------------------------------------------
-- ToggleUI global
------------------------------------------------------------------------
function Library:ToggleUI()
    if _GUI then _GUI.Enabled=not _GUI.Enabled end
end

return Library
