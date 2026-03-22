--[[
    ╔══════════════════════════════════════════════════════╗
    ║   PVP Script UI  —  v3 FINAL                        ║
    ║   Compacto · Resize livre · Notificações · Detalhes ║
    ╚══════════════════════════════════════════════════════╝
--]]

local Library      = {}
local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local PL  = game:GetService("Players")
local RS  = game:GetService("RunService")

-- ══════════════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════════════
local function tw(o, p, t, s, d)
    TS:Create(o, TweenInfo.new(t or .15, s or Enum.EasingStyle.Quart,
        d or Enum.EasingDirection.Out), p):Play()
end
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r or 6)
    c.Parent = p; return c
end
local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(45,45,58)
    s.Thickness = th or 1; s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p; return s
end
local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0,t or 0); u.PaddingBottom = UDim.new(0,b or 0)
    u.PaddingLeft = UDim.new(0,l or 0); u.PaddingRight = UDim.new(0,r or 0)
    u.Parent = p; return u
end
local function vlist(p, sp)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.FillDirection = Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding = UDim.new(0, sp or 0); l.Parent = p; return l
end
local function hlist(p, sp)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.FillDirection = Enum.FillDirection.Horizontal
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.Padding = UDim.new(0, sp or 0); l.Parent = p; return l
end
local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function lbl(p, txt, sz, col, xa, font, zi)
    return mk("TextLabel", {
        BackgroundTransparency = 1, Text = txt or "",
        TextSize = sz or 11, TextColor3 = col or Color3.fromRGB(220,220,220),
        TextXAlignment = xa or Enum.TextXAlignment.Left,
        Font = font or Enum.Font.GothamBold,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = zi or 4
    }, p)
end
local function grad(p, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1); g.Rotation = rot or 90
    g.Parent = p; return g
end

-- ══════════════════════════════════════════════════════════════════════
-- PALETA
-- ══════════════════════════════════════════════════════════════════════
local C = {
    WIN      = Color3.fromRGB(14,14,18),
    HDR      = Color3.fromRGB(72,185,35),
    HDR_DK   = Color3.fromRGB(48,128,18),
    HDR_CLO  = Color3.fromRGB(195,32,32),
    SIDE     = Color3.fromRGB(18,18,23),
    CONT     = Color3.fromRGB(11,11,15),
    TAB_OFF  = Color3.fromRGB(18,18,23),
    TAB_HOV  = Color3.fromRGB(25,25,32),
    TAB_ON   = Color3.fromRGB(72,185,35),
    TAB_T_OFF= Color3.fromRGB(105,105,122),
    TAB_T_ON = Color3.fromRGB(10,10,14),
    ELEM     = Color3.fromRGB(20,20,26),
    ELEM_H   = Color3.fromRGB(27,27,35),
    ELEM_STR = Color3.fromRGB(38,38,50),
    ELEM_ACT = Color3.fromRGB(72,185,35),
    TOG_OFF  = Color3.fromRGB(34,34,46),
    TOG_ON   = Color3.fromRGB(72,185,35),
    CHK      = Color3.fromRGB(255,255,255),
    BADGE    = Color3.fromRGB(19,19,27),
    BADGE_T  = Color3.fromRGB(82,200,42),
    BADGE_S  = Color3.fromRGB(46,46,60),
    TXT      = Color3.fromRGB(228,228,235),
    TXT_D    = Color3.fromRGB(88,88,105),
    TXT_M    = Color3.fromRGB(148,148,165),
    DIV      = Color3.fromRGB(28,28,38),
    SCHEME   = Color3.fromRGB(72,185,35),
    SCROLL   = Color3.fromRGB(72,185,35),
    NOTIF_BG = Color3.fromRGB(16,16,22),
    NOTIF_S  = Color3.fromRGB(72,185,35),
    NOTIF_E  = Color3.fromRGB(195,32,32),
    NOTIF_W  = Color3.fromRGB(210,150,20),
    NOTIF_I  = Color3.fromRGB(40,120,210),
}

local _GUI, _activeTab = nil, nil

-- ══════════════════════════════════════════════════════════════════════
-- SISTEMA DE NOTIFICAÇÃO
-- ══════════════════════════════════════════════════════════════════════
local NotifHolder = nil   -- frame container criado junto com a GUI
local notifQueue  = 0

local function Notify(opts)
    if not NotifHolder then return end
    opts = opts or {}
    local title    = tostring(opts.Title   or "Notification")
    local text     = tostring(opts.Text    or "")
    local dur      = tonumber(opts.Duration) or 4
    local ntype    = tostring(opts.Type    or "success") -- success/error/warn/info

    notifQueue = notifQueue + 1

    local accentCol = ntype == "error" and C.NOTIF_E
                   or ntype == "warn"  and C.NOTIF_W
                   or ntype == "info"  and C.NOTIF_I
                   or C.NOTIF_S

    local iconTxt   = ntype == "error" and "✕"
                   or ntype == "warn"  and "⚠"
                   or ntype == "info"  and "ℹ"
                   or "✓"

    -- Card
    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = C.NOTIF_BG,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 200,
    }, NotifHolder)
    corner(card, 9)
    local cStr = stroke(card, accentCol, 1, 0.6)
    grad(card, Color3.fromRGB(20,20,28), Color3.fromRGB(14,14,20), 180)

    -- Barra lateral colorida
    local accent = mk("Frame", {
        Size = UDim2.new(0, 3, 1, -14),
        Position = UDim2.new(0, 0, 0, 7),
        BackgroundColor3 = accentCol,
        BorderSizePixel = 0,
        ZIndex = 202,
    }, card)
    corner(accent, 2)

    -- Ícone círculo
    local iconBg = mk("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 10, 0.5, -11),
        BackgroundColor3 = accentCol,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 202,
    }, card)
    corner(iconBg, 11)
    local iconL = lbl(iconBg, iconTxt, 11, accentCol,
        Enum.TextXAlignment.Center, Enum.Font.GothamBold, 203)
    iconL.Size = UDim2.new(1,0,1,0)
    iconL.TextYAlignment = Enum.TextYAlignment.Center

    -- Título
    local tL = lbl(card, title, 11, C.TXT,
        Enum.TextXAlignment.Left, Enum.Font.GothamBold, 202)
    tL.Size = UDim2.new(1, -44, 0, 16)
    tL.Position = UDim2.new(0, 38, 0, 9)

    -- Subtexto
    local sL = lbl(card, text, 10, C.TXT_M,
        Enum.TextXAlignment.Left, Enum.Font.Gotham, 202)
    sL.Size = UDim2.new(1, -44, 0, 14)
    sL.Position = UDim2.new(0, 38, 0, 27)
    sL.TextTruncate = Enum.TextTruncate.AtEnd

    -- Barra de progresso de tempo
    local pBg = mk("Frame", {
        Size = UDim2.new(1, -8, 0, 2),
        Position = UDim2.new(0, 4, 1, -4),
        BackgroundColor3 = Color3.fromRGB(30,30,40),
        BorderSizePixel = 0, ZIndex = 202,
    }, card)
    corner(pBg, 1)
    local pFill = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentCol,
        BorderSizePixel = 0, ZIndex = 203,
    }, pBg)
    corner(pFill, 1)

    -- Slide in
    card.Position = UDim2.new(1, 10, 0, 0)
    card.BackgroundTransparency = 0
    tw(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3,
        Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tw(cStr, {Transparency = 0.3}, 0.3)

    -- Progress bar drain
    TS:Create(pFill, TweenInfo.new(dur, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 1, 0)}):Play()

    -- Clique para fechar
    local closeN = mk("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -20, 0, 6),
        BackgroundTransparency = 1,
        Text = "✕", Font = Enum.Font.GothamBold,
        TextSize = 9, TextColor3 = C.TXT_D,
        AutoButtonColor = false, ZIndex = 204,
    }, card)
    closeN.MouseButton1Click:Connect(function()
        tw(card, {BackgroundTransparency = 1, Position = UDim2.new(1,10,0,0)}, 0.2)
        task.delay(0.22, function() card:Destroy(); notifQueue = math.max(0, notifQueue-1) end)
    end)

    task.delay(dur, function()
        if card and card.Parent then
            tw(card, {BackgroundTransparency = 1, Position = UDim2.new(1,10,0,0)}, 0.22)
            task.delay(0.25, function()
                if card and card.Parent then card:Destroy() end
                notifQueue = math.max(0, notifQueue-1)
            end)
        end
    end)
end

Library.Notify = Notify

-- ══════════════════════════════════════════════════════════════════════
-- INTRO  — painel flutuante sem fundo preto
-- ══════════════════════════════════════════════════════════════════════
local function playIntro(onDone)
    local sg = Instance.new("ScreenGui")
    sg.Name = "__PVPIntro"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 99998
    pcall(function() sg.Parent = game.CoreGui end)
    if sg.Parent ~= game.CoreGui then
        sg.Parent = PL.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Painel compacto 240×160
    local W, H = 240, 160
    local pan = mk("Frame", {
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.new(.5,0,.5,0),
        Size = UDim2.new(0,0,0,0),
        BackgroundColor3 = Color3.fromRGB(13,13,17),
        BorderSizePixel = 0, ZIndex = 100,
    }, sg)
    corner(pan, 14)
    local panStr = stroke(pan, C.SCHEME, 1.5, 0.2)
    grad(pan, Color3.fromRGB(16,20,14), Color3.fromRGB(10,10,14), 135)

    -- Linha topo colorida
    local topLine = mk("Frame",{
        Size=UDim2.new(0,0,0,2), Position=UDim2.new(0,0,0,0),
        BackgroundColor3=C.SCHEME, BorderSizePixel=0, ZIndex=110,
    }, pan)
    corner(topLine,2)
    grad(topLine, C.HDR, C.HDR_DK, 0)

    -- Decoração cantos (L-brackets)
    local function lbracket(ax,ay,px,py)
        local f = mk("Frame",{Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(ax,ay),
            Position=UDim2.new(px,0,py,0),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=108},pan)
        mk("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,ay==0 and 0 or 1,-2*(1-ay)),
            BackgroundColor3=C.SCHEME,BorderSizePixel=0,ZIndex=109},f)
        mk("Frame",{Size=UDim2.new(0,2,1,0),Position=UDim2.new(ax==0 and 0 or 1,-2*(1-ax),0,0),
            BackgroundColor3=C.SCHEME,BorderSizePixel=0,ZIndex=109},f)
    end
    lbracket(0,0,0,0); lbracket(1,0,1,0); lbracket(0,1,0,1); lbracket(1,1,1,1)

    -- Ícone central
    local iconBg = mk("Frame",{
        AnchorPoint=Vector2.new(.5,.5), Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(.5,0,.38,0),
        BackgroundColor3=C.SCHEME, BorderSizePixel=0, ZIndex=105,
    }, pan)
    corner(iconBg, 22)
    grad(iconBg, C.HDR, C.HDR_DK, 135)
    local iconL = mk("TextLabel",{
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="⚔️", TextScaled=true, Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(255,255,255),
        TextTransparency=1, ZIndex=106,
    }, iconBg)

    -- Anel externo (sem gradiente, só borda)
    local ring = mk("Frame",{
        AnchorPoint=Vector2.new(.5,.5), Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(.5,0,.38,0),
        BackgroundTransparency=1, BorderSizePixel=0, ZIndex=104,
    }, pan)
    corner(ring,35)
    local ringStr = stroke(ring, C.SCHEME, 1, 0.5)

    -- Título
    local titL = mk("TextLabel",{
        AnchorPoint=Vector2.new(.5,0), Size=UDim2.new(.9,0,0,18),
        Position=UDim2.new(.5,0,.62,0),
        BackgroundTransparency=1, Text="PVP SCRIPT",
        TextSize=16, Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(255,255,255),
        TextXAlignment=Enum.TextXAlignment.Center,
        TextTransparency=1, ZIndex=105,
    }, pan)

    local subL = mk("TextLabel",{
        AnchorPoint=Vector2.new(.5,0), Size=UDim2.new(.9,0,0,13),
        Position=UDim2.new(.5,0,.76,0),
        BackgroundTransparency=1, Text="Blox Fruit · PVP",
        TextSize=10, Font=Enum.Font.GothamSemibold,
        TextColor3=C.SCHEME,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextTransparency=1, ZIndex=105,
    }, pan)

    -- Barra loading slim
    local barBg = mk("Frame",{
        AnchorPoint=Vector2.new(.5,0), Size=UDim2.new(.7,0,0,3),
        Position=UDim2.new(.5,0,.89,0),
        BackgroundColor3=Color3.fromRGB(26,26,36),
        BorderSizePixel=0, ZIndex=105,
    }, pan)
    corner(barBg,2)
    local barFill = mk("Frame",{
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=C.SCHEME,
        BorderSizePixel=0, ZIndex=106,
    }, barBg)
    corner(barFill,2)
    grad(barFill, C.HDR, C.HDR_DK, 0)

    local stL = mk("TextLabel",{
        AnchorPoint=Vector2.new(.5,0), Size=UDim2.new(.9,0,0,12),
        Position=UDim2.new(.5,0,.94,0),
        BackgroundTransparency=1, Text="Loading...",
        TextSize=9, Font=Enum.Font.Gotham,
        TextColor3=C.TXT_D,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextTransparency=1, ZIndex=105,
    }, pan)

    -- Pulso da borda
    local pulseConn; local pa, pd = 0, 1
    pulseConn = RS.Heartbeat:Connect(function(dt)
        pa = pa + dt*2.2*pd
        if pa>1 then pd=-1 elseif pa<0 then pd=1 end
        panStr.Transparency = 0.1 + pa*0.55
    end)

    task.spawn(function()
        -- 1. Painel abre
        tw(pan, {Size=UDim2.new(0,W,0,H)}, .45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tw(topLine, {Size=UDim2.new(1,0,0,2)}, .4, Enum.EasingStyle.Quart)
        task.wait(.32)

        -- 2. Anel e ícone expandem
        tw(ring,   {Size=UDim2.new(0,62,0,62)}, .35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(.12)
        tw(iconBg, {Size=UDim2.new(0,38,0,38)}, .30, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tw(iconL,  {TextTransparency=0}, .25)
        task.wait(.2)

        -- 3. Textos
        tw(titL, {TextTransparency=0}, .25); task.wait(.08)
        tw(subL, {TextTransparency=0}, .22); task.wait(.08)
        tw(stL,  {TextTransparency=0}, .2)
        task.wait(.1)

        -- 4. Barra
        local stages = {
            {.3,"Loading..."},{.6,"Setting up..."},{.85,"Remotes..."},{1,"Ready! ✓"}
        }
        for _, s in ipairs(stages) do
            tw(barFill, {Size=UDim2.new(s[1],0,1,0)}, .28)
            stL.Text = s[2]; task.wait(.28)
        end

        -- 5. Flash
        tw(iconBg,{BackgroundColor3=Color3.fromRGB(160,255,100)},.07)
        task.wait(.1)
        tw(iconBg,{BackgroundColor3=C.SCHEME},.12)
        task.wait(.18)

        -- 6. Fade out
        for _, o in ipairs({titL,subL,stL,iconL}) do tw(o,{TextTransparency=1},.18) end
        tw(iconBg,{BackgroundTransparency=1},.18)
        tw(ring,  {BackgroundTransparency=1},.15)
        tw(barBg, {BackgroundTransparency=1},.15)
        task.wait(.22)

        -- 7. Colapsa
        tw(pan, {Size=UDim2.new(0,0,0,0), BackgroundTransparency=.6}, .28,
            Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(.3)

        pulseConn:Disconnect()
        sg:Destroy()
        pcall(onDone)
    end)
end

-- ══════════════════════════════════════════════════════════════════════
-- Library.CreateLib
-- ══════════════════════════════════════════════════════════════════════
function Library.CreateLib(title, themeColor)
    -- Aplica tema
    if typeof(themeColor) == "Color3" then
        local sc = themeColor
        C.SCHEME=sc; C.HDR=sc; C.TAB_ON=sc; C.BADGE_T=sc
        C.TOG_ON=sc; C.ELEM_ACT=sc; C.SCROLL=sc
        C.HDR_DK=Color3.new(sc.R*.65,sc.G*.65,sc.B*.65)
    elseif typeof(themeColor) == "table" then
        if themeColor.SchemeColor then
            local sc=themeColor.SchemeColor
            C.SCHEME=sc; C.HDR=sc; C.TAB_ON=sc; C.BADGE_T=sc
            C.TOG_ON=sc; C.ELEM_ACT=sc; C.SCROLL=sc
            C.HDR_DK=Color3.new(sc.R*.65,sc.G*.65,sc.B*.65)
        end
        if themeColor.Background   then C.WIN  = themeColor.Background   end
        if themeColor.TextColor    then C.TXT  = themeColor.TextColor    end
        if themeColor.ElementColor then C.ELEM = themeColor.ElementColor end
    end

    pcall(function()
        for _, v in ipairs(game.CoreGui:GetChildren()) do
            if v.Name == "__OLib" then v:Destroy() end
        end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name="__OLib"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder=9999; sg.Enabled=false
    pcall(function() sg.Parent=game.CoreGui end)
    _GUI = sg

    -- ────────────────────────────────────────────────────────────────
    -- TAMANHOS INICIAIS
    -- ────────────────────────────────────────────────────────────────
    local WIN_W_DEF = 355
    local WIN_H_DEF = 285
    local HDR_H     = 42
    local SIDE_W_PC = 0.32   -- sidebar = 32% da largura
    local EH        = 48     -- elemento padrão
    local EH_SM     = 28     -- elemento pequeno
    local WIN_W_MIN = 260
    local WIN_W_MAX = 580
    local WIN_H_MIN = 200
    local WIN_H_MAX = 520

    -- ────────────────────────────────────────────────────────────────
    -- JANELA PRINCIPAL
    -- ────────────────────────────────────────────────────────────────
    local win = mk("Frame", {
        Name="Win", AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.new(.5,0,.5,0),
        Size=UDim2.new(0,WIN_W_DEF,0,WIN_H_DEF),
        BackgroundColor3=C.WIN, BorderSizePixel=0,
        ClipsDescendants=false,
    }, sg)
    corner(win,10)

    local winStr = stroke(win, Color3.fromRGB(30,30,40), 1)

    -- Sombra
    mk("ImageLabel",{
        Size=UDim2.new(1,44,1,44), Position=UDim2.new(0,-22,0,-22),
        BackgroundTransparency=1,
        Image="rbxassetid://6015897843",
        ImageColor3=Color3.fromRGB(0,0,0),
        ImageTransparency=0.48,
        ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450),
        ZIndex=0,
    }, win)

    -- ────────────────────────────────────────────────────────────────
    -- RESIZE LIVRE (8 handles: 4 bordas + 4 cantos)
    -- ────────────────────────────────────────────────────────────────
    --[[  O resize funciona assim:
          • Cada handle é um TextButton transparente nas bordas/cantos.
          • Ao arrastar, recalcula Size e Position da janela.
    ]]
    local resizing   = false
    local resizeType = nil   -- "r","l","b","t","br","bl","tr","tl"
    local rsX0, rsY0, rW0, rH0, rPX0, rPY0 = 0,0,0,0,0,0
    local VP = workspace.CurrentCamera.ViewportSize  -- atualizado no drag

    local function mkResizeHandle(name, size, pos, cursor)
        local h = mk("TextButton",{
            Name=name, Size=size, Position=pos,
            BackgroundTransparency=1, BorderSizePixel=0,
            Text="", AutoButtonColor=false, ZIndex=50,
        }, win)
        h.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                resizing   = true
                resizeType = name
                rsX0  = i.Position.X; rsY0 = i.Position.Y
                rW0   = win.AbsoluteSize.X; rH0 = win.AbsoluteSize.Y
                rPX0  = win.AbsolutePosition.X; rPY0 = win.AbsolutePosition.Y
                VP    = workspace.CurrentCamera.ViewportSize
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then resizing = false end
                end)
            end
        end)
        return h
    end

    local E = 6  -- espessura handle
    mkResizeHandle("r",  UDim2.new(0,E,1,-16), UDim2.new(1,-E,0,8))
    mkResizeHandle("l",  UDim2.new(0,E,1,-16), UDim2.new(0,0,0,8))
    mkResizeHandle("b",  UDim2.new(1,-16,0,E), UDim2.new(0,8,1,-E))
    mkResizeHandle("t",  UDim2.new(1,-16,0,E), UDim2.new(0,8,0,0))
    mkResizeHandle("br", UDim2.new(0,12,0,12), UDim2.new(1,-12,1,-12))
    mkResizeHandle("bl", UDim2.new(0,12,0,12), UDim2.new(0,0,1,-12))
    mkResizeHandle("tr", UDim2.new(0,12,0,12), UDim2.new(1,-12,0,0))
    mkResizeHandle("tl", UDim2.new(0,12,0,12), UDim2.new(0,0,0,0))

    -- Resize grip decoration (canto inferior direito)
    local grip = mk("Frame",{
        Size=UDim2.new(0,10,0,10), Position=UDim2.new(1,-12,1,-12),
        BackgroundTransparency=1, BorderSizePixel=0, ZIndex=51,
    }, win)
    for i=1,3 do
        mk("Frame",{
            Size=UDim2.new(0,2,0,2),
            Position=UDim2.new(0,(i-1)*3.5,0,(i-1)*3.5),
            BackgroundColor3=C.TXT_D,
            BackgroundTransparency=0.3,
            BorderSizePixel=0, ZIndex=52,
        }, grip)
    end

    UIS.InputChanged:Connect(function(i)
        if not resizing then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement
        and i.UserInputType ~= Enum.UserInputType.Touch then return end

        local dx = i.Position.X - rsX0
        local dy = i.Position.Y - rsY0
        local rt = resizeType

        local nW = rW0; local nH = rH0
        local nPX = rPX0; local nPY = rPY0

        if rt=="r"  or rt=="tr" or rt=="br" then nW = rW0+dx end
        if rt=="l"  or rt=="tl" or rt=="bl" then nW = rW0-dx; nPX = rPX0+dx end
        if rt=="b"  or rt=="bl" or rt=="br" then nH = rH0+dy end
        if rt=="t"  or rt=="tl" or rt=="tr" then nH = rH0-dy; nPY = rPY0+dy end

        nW = math.clamp(nW, WIN_W_MIN, WIN_W_MAX)
        nH = math.clamp(nH, WIN_H_MIN, WIN_H_MAX)
        -- Reaplica clamp no offset da posição
        if rt=="l" or rt=="tl" or rt=="bl" then
            nPX = rPX0 + (rW0 - nW)
        end
        if rt=="t" or rt=="tl" or rt=="tr" then
            nPY = rPY0 + (rH0 - nH)
        end

        -- Usa Scale+Offset para manter dentro da tela
        win.Position = UDim2.new(0, nPX + nW/2, 0, nPY + nH/2)
        win.Size     = UDim2.new(0, nW, 0, nH)
    end)

    -- ────────────────────────────────────────────────────────────────
    -- HEADER
    -- ────────────────────────────────────────────────────────────────
    local hdr = mk("Frame",{
        Name="Hdr", Size=UDim2.new(1,0,0,HDR_H),
        BackgroundColor3=C.HDR, BorderSizePixel=0, ZIndex=10,
    }, win)
    corner(hdr,10)
    grad(hdr, C.HDR, C.HDR_DK, 110)

    mk("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),
        BackgroundColor3=C.HDR,BorderSizePixel=0,ZIndex=10}, hdr)
    -- Linha brilhante inferior
    local hLine = mk("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=Color3.fromRGB(180,255,110),
        BackgroundTransparency=0.55,BorderSizePixel=0,ZIndex=11}, hdr)

    -- Ícone header
    local hIco = mk("Frame",{
        Size=UDim2.new(0,26,0,26),Position=UDim2.new(0,8,.5,-13),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.88,BorderSizePixel=0,ZIndex=12}, hdr)
    corner(hIco,6)
    mk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Text="⚔️",TextScaled=true,Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(255,255,255),ZIndex=13}, hIco)

    -- Título
    local hTitle = lbl(hdr, title or "PVP SCRIPT", 13,
        Color3.fromRGB(255,255,255), Enum.TextXAlignment.Left, Enum.Font.GothamBold, 11)
    hTitle.Size=UDim2.new(1,-88,1,0); hTitle.Position=UDim2.new(0,40,0,0)
    hTitle.TextYAlignment=Enum.TextYAlignment.Center
    hTitle.TextStrokeTransparency=0.65; hTitle.TextStrokeColor3=Color3.fromRGB(0,50,0)

    -- Botão minimizar
    local minBtn = mk("TextButton",{
        Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-56,.5,-11),
        BackgroundColor3=Color3.fromRGB(45,90,45),
        BackgroundTransparency=0.3,BorderSizePixel=0,
        Text="–",Font=Enum.Font.GothamBold,TextSize=13,
        TextColor3=Color3.fromRGB(255,255,255),
        AutoButtonColor=false,ZIndex=14,
    }, hdr)
    corner(minBtn,6)
    stroke(minBtn, Color3.fromRGB(80,160,50), 1, 0.6)
    local minimized = false
    local beforeMinH = WIN_H_DEF
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            beforeMinH = win.AbsoluteSize.Y
            tw(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,HDR_H)},.22)
            minBtn.Text = "▲"
        else
            tw(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,beforeMinH)},.22)
            minBtn.Text = "–"
        end
    end)

    -- Botão fechar
    local closeBtn = mk("TextButton",{
        Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-28,.5,-11),
        BackgroundColor3=C.HDR_CLO,BorderSizePixel=0,
        Text="✕",Font=Enum.Font.GothamBold,TextSize=11,
        TextColor3=Color3.fromRGB(255,255,255),
        AutoButtonColor=false,ZIndex=14,
    }, hdr)
    corner(closeBtn,6)
    stroke(closeBtn, Color3.fromRGB(240,80,80), 1, 0.5)
    closeBtn.MouseEnter:Connect(function()
        tw(closeBtn,{BackgroundColor3=Color3.fromRGB(230,45,45)},.08)
    end)
    closeBtn.MouseLeave:Connect(function()
        tw(closeBtn,{BackgroundColor3=C.HDR_CLO},.08)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tw(win,{BackgroundTransparency=1,Size=UDim2.new(0,win.AbsoluteSize.X,0,0)},.18)
        task.delay(.2, function() sg:Destroy() end)
    end)

    draggable(hdr, win)

    -- ────────────────────────────────────────────────────────────────
    -- CORPO
    -- ────────────────────────────────────────────────────────────────
    local body = mk("Frame",{
        Name="Body", Size=UDim2.new(1,0,1,-HDR_H),
        Position=UDim2.new(0,0,0,HDR_H),
        BackgroundTransparency=1, BorderSizePixel=0,
        ClipsDescendants=true, ZIndex=2,
    }, win)

    -- SIDEBAR
    local side = mk("Frame",{
        Name="Side", Size=UDim2.new(SIDE_W_PC,0,1,0),
        BackgroundColor3=C.SIDE, BorderSizePixel=0, ZIndex=3,
    }, body)
    grad(side, Color3.fromRGB(21,21,27), Color3.fromRGB(16,16,21), 180)

    mk("Frame",{Size=UDim2.new(1,0,0,8),
        BackgroundColor3=C.SIDE,BorderSizePixel=0,ZIndex=3}, side)

    mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=C.DIV,BorderSizePixel=0,ZIndex=4}, side)

    local sideScroll = mk("ScrollingFrame",{
        Size=UDim2.new(1,0,1,-8), Position=UDim2.new(0,0,0,8),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=2, ScrollBarImageColor3=C.SCROLL,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=4,
    }, side)
    vlist(sideScroll, 3)
    pad(sideScroll, 5,5,5,5)

    -- CONTEÚDO
    local cont = mk("Frame",{
        Name="Cont",
        Size=UDim2.new(1-SIDE_W_PC,0,1,0),
        Position=UDim2.new(SIDE_W_PC,0,0,0),
        BackgroundColor3=C.CONT, BorderSizePixel=0,
        ClipsDescendants=true, ZIndex=3,
    }, body)
    grad(cont, Color3.fromRGB(13,13,17), Color3.fromRGB(9,9,13), 180)

    -- Título da tab ativa (topo do conteúdo)
    local secTitleLbl = lbl(cont,"",12,C.SCHEME,
        Enum.TextXAlignment.Left, Enum.Font.GothamBold, 5)
    secTitleLbl.Size=UDim2.new(1,-12,0,28); secTitleLbl.Position=UDim2.new(0,10,0,2)
    secTitleLbl.TextYAlignment=Enum.TextYAlignment.Center

    mk("Frame",{Size=UDim2.new(1,-10,0,1),Position=UDim2.new(0,5,0,28),
        BackgroundColor3=C.SCHEME,BackgroundTransparency=0.6,
        BorderSizePixel=0,ZIndex=5}, cont)

    -- Scroll do conteúdo
    local scroll = mk("ScrollingFrame",{
        Name="Scroll", Position=UDim2.new(0,0,0,32),
        Size=UDim2.new(1,-3,1,-35),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=2, ScrollBarImageColor3=C.SCROLL,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        ClipsDescendants=true, ZIndex=4,
    }, cont)
    vlist(scroll, 4)
    pad(scroll, 5,8,6,6)

    -- ────────────────────────────────────────────────────────────────
    -- CONTAINER DE NOTIFICAÇÕES (canto inferior direito da tela)
    -- ────────────────────────────────────────────────────────────────
    local notifSg = Instance.new("ScreenGui")
    notifSg.Name="__OLibNotif"; notifSg.ResetOnSpawn=false
    notifSg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    notifSg.DisplayOrder=99990
    pcall(function() notifSg.Parent=game.CoreGui end)

    NotifHolder = mk("Frame",{
        Size=UDim2.new(0,200,1,0),
        Position=UDim2.new(1,-210,0,0),
        BackgroundTransparency=1, BorderSizePixel=0, ZIndex=199,
    }, notifSg)
    -- Lista de baixo para cima
    local notifList = Instance.new("UIListLayout")
    notifList.SortOrder=Enum.SortOrder.LayoutOrder
    notifList.FillDirection=Enum.FillDirection.Vertical
    notifList.VerticalAlignment=Enum.VerticalAlignment.Bottom
    notifList.Padding=UDim.new(0,6)
    notifList.Parent=NotifHolder
    pad(NotifHolder,0,14,0,0)

    -- ────────────────────────────────────────────────────────────────
    -- Window:NewTab
    -- ────────────────────────────────────────────────────────────────
    local Window    = {}
    local tabPanels = {}
    local tabIdx    = 0

    local defIcons = {"🏠","⚔️","👁","🔧","🥊","⚙️","🎯","💎","🌍","🔄","📡","🛡️"}

    local function showTab(td)
        for _, t in ipairs(tabPanels) do
            t.panel.Visible = false
            tw(t.btn,  {BackgroundColor3=C.TAB_OFF}, .12)
            tw(t.nLbl, {TextColor3=C.TAB_T_OFF}, .10)
            if t.iLbl then tw(t.iLbl,{TextColor3=C.TAB_T_OFF},.10) end
            if t.bar  then tw(t.bar, {BackgroundTransparency=1},.10) end
        end
        td.panel.Visible = true
        tw(td.btn,  {BackgroundColor3=C.TAB_ON}, .15)
        tw(td.nLbl, {TextColor3=C.TAB_T_ON}, .12)
        if td.iLbl then tw(td.iLbl,{TextColor3=C.TAB_T_ON},.12) end
        if td.bar  then tw(td.bar, {BackgroundTransparency=0},.12) end
        secTitleLbl.Text = td.clean
        _activeTab = td
    end

    function Window:NewTab(tabName)
        tabName = tabName or "Tab"
        tabIdx  = tabIdx + 1

        local ico   = defIcons[tabIdx] or "•"
        local clean = tabName
        local a, b  = tabName:match("^(.-)・(.+)$")
        if a and b then ico = a; clean = b end

        -- Botão sidebar
        local tabBtn = mk("TextButton",{
            Size=UDim2.new(1,0,0,36),
            BackgroundColor3=C.TAB_OFF,
            BorderSizePixel=0,AutoButtonColor=false,
            Text="",ZIndex=5,
        }, sideScroll)
        corner(tabBtn,8)

        -- Barra ativa esquerda
        local actBar = mk("Frame",{
            Size=UDim2.new(0,2,0,18),Position=UDim2.new(0,0,.5,-9),
            BackgroundColor3=Color3.fromRGB(200,255,150),
            BackgroundTransparency=1,BorderSizePixel=0,ZIndex=7,
        }, tabBtn)
        corner(actBar,1)

        -- Ícone
        local tIco = mk("TextLabel",{
            Size=UDim2.new(0,18,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1, Text=ico,
            TextScaled=true, Font=Enum.Font.GothamBold,
            TextColor3=C.TAB_T_OFF, TextXAlignment=Enum.TextXAlignment.Center,
            ZIndex=6,
        }, tabBtn)

        -- Nome
        local tName = lbl(tabBtn, clean, 11, C.TAB_T_OFF,
            Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
        tName.Size=UDim2.new(1,-32,1,0); tName.Position=UDim2.new(0,28,0,0)
        tName.TextYAlignment=Enum.TextYAlignment.Center

        -- Painel de conteúdo
        local panel = mk("Frame",{
            Name="P_"..clean,
            Size=UDim2.new(1,0,0,0),
            AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1,BorderSizePixel=0,
            Visible=false, ZIndex=5,
        }, scroll)
        vlist(panel, 4)

        local td = {btn=tabBtn,panel=panel,nLbl=tName,iLbl=tIco,bar=actBar,clean=clean}
        table.insert(tabPanels, td)

        tabBtn.MouseButton1Click:Connect(function() showTab(td) end)
        tabBtn.MouseEnter:Connect(function()
            if _activeTab~=td then
                tw(tabBtn,{BackgroundColor3=C.TAB_HOV},.08)
                tw(tName, {TextColor3=C.TXT},.08)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if _activeTab~=td then
                tw(tabBtn,{BackgroundColor3=C.TAB_OFF},.08)
                tw(tName, {TextColor3=C.TAB_T_OFF},.08)
            end
        end)

        if tabIdx==1 then task.defer(function() showTab(td) end) end

        -- ────────────────────────────────────────────────────────
        -- Tab:NewSection
        -- ────────────────────────────────────────────────────────
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"
            local sc = secName
            local _, sn = secName:match("^.+・(.+)$")
            if sn then sc = sn end

            -- Cabeçalho da seção
            local sh = mk("Frame",{
                Size=UDim2.new(1,0,0,20),
                BackgroundTransparency=1,BorderSizePixel=0,ZIndex=5,
            }, panel)

            -- Ponto + linha + texto
            mk("Frame",{Size=UDim2.new(0,5,0,5),Position=UDim2.new(0,0,.5,-2.5),
                BackgroundColor3=C.SCHEME,BorderSizePixel=0,ZIndex=6}, sh)
                :Parent.Parent -- just corner it
            local dot = sh:FindFirstChildOfClass("Frame")
            if dot then corner(dot,3) end

            local shL = lbl(sh,sc,11,C.SCHEME,Enum.TextXAlignment.Left,Enum.Font.GothamBold,6)
            shL.Size=UDim2.new(1,-8,1,0); shL.Position=UDim2.new(0,10,0,0)
            shL.TextYAlignment=Enum.TextYAlignment.Center

            mk("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
                BackgroundColor3=C.SCHEME,BackgroundTransparency=0.7,
                BorderSizePixel=0,ZIndex=6}, sh)

            local Section = {}

            -- Cria elemento base (frame, sem hover)
            local function mkElem(h)
                local f = mk("Frame",{
                    Size=UDim2.new(1,0,0,h or EH),
                    BackgroundColor3=C.ELEM,BorderSizePixel=0,ZIndex=5,
                }, panel)
                corner(f,7)
                stroke(f,C.ELEM_STR,1)
                grad(f, Color3.fromRGB(24,24,31), Color3.fromRGB(17,17,23), 180)
                return f
            end

            -- Cria elemento clicável (TextButton, com hover)
            local function mkBtn(h)
                local b = mk("TextButton",{
                    Size=UDim2.new(1,0,0,h or EH),
                    BackgroundColor3=C.ELEM,BorderSizePixel=0,
                    AutoButtonColor=false,Text="",ZIndex=5,
                }, panel)
                corner(b,7)
                local bs = stroke(b,C.ELEM_STR,1)
                grad(b, Color3.fromRGB(24,24,31), Color3.fromRGB(17,17,23), 180)
                b.MouseEnter:Connect(function()
                    tw(b, {BackgroundColor3=C.ELEM_H},.08)
                    tw(bs,{Color=C.ELEM_ACT,Transparency=0.65},.08)
                end)
                b.MouseLeave:Connect(function()
                    tw(b, {BackgroundColor3=C.ELEM},.08)
                    tw(bs,{Color=C.ELEM_STR,Transparency=0},.08)
                end)
                return b, bs
            end

            -- Título + descrição padrão
            local function mkTD(parent, t, d, rOff)
                local rO = rOff or 54
                local tL = lbl(parent,t,11,C.TXT,Enum.TextXAlignment.Left,Enum.Font.GothamBold,6)
                tL.Size=UDim2.new(1,-rO,0,17); tL.Position=UDim2.new(0,10,0,6)
                local dL = lbl(parent,d or "",10,C.TXT_D,Enum.TextXAlignment.Left,Enum.Font.Gotham,6)
                dL.Size=UDim2.new(1,-rO,0,14); dL.Position=UDim2.new(0,10,0,24)
                return tL, dL
            end

            -- Badge arredondado reutilizável
            local function mkBadge(parent, w, h, fromRight)
                local bg = mk("Frame",{
                    Size=UDim2.new(0,w,0,h),
                    Position=UDim2.new(1,-(fromRight or w+8),.5,-h/2),
                    BackgroundColor3=C.BADGE,BorderSizePixel=0,ZIndex=7,
                }, parent)
                corner(bg,7)
                stroke(bg,C.BADGE_S,1)
                grad(bg, Color3.fromRGB(23,23,32), Color3.fromRGB(16,16,24), 135)
                return bg
            end

            -- ──────────────────────────────────────────────────────
            -- NewToggle
            -- ──────────────────────────────────────────────────────
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local on   = false
                local dsp  = name:match("^・?(.+)$") or name
                local row, rowStr = mkBtn(EH)
                mkTD(row, dsp, tip, 52)

                -- Checkbox
                local chkBg = mkBadge(row, 32, 32, 40)
                corner(chkBg, 8)
                local chkStr = stroke(chkBg, C.BADGE_S, 1)

                -- Ícone OFF
                local offL = lbl(chkBg,"✕",11,C.TXT_D,Enum.TextXAlignment.Center,Enum.Font.GothamBold,9)
                offL.Size=UDim2.new(1,0,1,0); offL.TextYAlignment=Enum.TextYAlignment.Center

                -- Ícone ON
                local onL = lbl(chkBg,"✓",14,C.CHK,Enum.TextXAlignment.Center,Enum.Font.GothamBold,10)
                onL.Size=UDim2.new(1,0,1,0); onL.TextYAlignment=Enum.TextYAlignment.Center
                onL.TextTransparency=1

                -- Indicador ponto
                local indDot = mk("Frame",{
                    Size=UDim2.new(0,5,0,5),Position=UDim2.new(1,-2,0,-2),
                    BackgroundColor3=C.TXT_D,BackgroundTransparency=0.4,
                    BorderSizePixel=0,ZIndex=10,
                }, row)
                corner(indDot,3)

                local function setState(v)
                    on = v
                    if on then
                        tw(chkBg, {BackgroundColor3=C.TOG_ON},.15)
                        tw(onL,   {TextTransparency=0},.12)
                        tw(offL,  {TextTransparency=1},.1)
                        tw(indDot,{BackgroundColor3=C.SCHEME,BackgroundTransparency=0},.12)
                        chkStr.Color=C.SCHEME; chkStr.Transparency=0.3
                    else
                        tw(chkBg, {BackgroundColor3=C.TOG_OFF},.15)
                        tw(onL,   {TextTransparency=1},.12)
                        tw(offL,  {TextTransparency=0},.1)
                        tw(indDot,{BackgroundColor3=C.TXT_D,BackgroundTransparency=0.4},.12)
                        chkStr.Color=C.BADGE_S; chkStr.Transparency=0
                    end
                end

                row.MouseButton1Click:Connect(function()
                    setState(not on); pcall(callback, on)
                end)

                local T={}
                function T:UpdateToggle(a,b2)
                    local v=(typeof(a)=="boolean") and a or (typeof(b2)=="boolean") and b2 or nil
                    if v~=nil then setState(v) end
                end
                function T:SetToggle(v) setState(v) end
                return T
            end

            -- ──────────────────────────────────────────────────────
            -- NewButton
            -- ──────────────────────────────────────────────────────
            function Section:NewButton(name, tip, callback)
                callback = callback or function() end
                local dsp = name:match("^・?(.+)$") or name
                local row, rowStr = mkBtn(EH_SM+8)

                -- Ícone play
                local icoL = lbl(row,"▶",9,C.SCHEME,Enum.TextXAlignment.Center,Enum.Font.GothamBold,7)
                icoL.Size=UDim2.new(0,14,1,0); icoL.Position=UDim2.new(0,7,0,0)
                icoL.TextYAlignment=Enum.TextYAlignment.Center

                local nL = lbl(row,dsp,11,C.TXT,Enum.TextXAlignment.Left,Enum.Font.GothamBold,6)
                nL.Size=UDim2.new(1,-26,1,0); nL.Position=UDim2.new(0,22,0,0)
                nL.TextYAlignment=Enum.TextYAlignment.Center

                -- Linha inferior que anima
                local bLine = mk("Frame",{
                    Size=UDim2.new(0,0,0,2),Position=UDim2.new(0,0,1,-2),
                    BackgroundColor3=C.SCHEME,BorderSizePixel=0,ZIndex=7,
                }, row)
                corner(bLine,1)

                row.MouseEnter:Connect(function()
                    tw(bLine,{Size=UDim2.new(1,0,0,2)},.14)
                    tw(nL,   {TextColor3=C.SCHEME},.1)
                    tw(icoL, {TextColor3=Color3.fromRGB(180,255,100)},.1)
                end)
                row.MouseLeave:Connect(function()
                    tw(bLine,{Size=UDim2.new(0,0,0,2)},.12)
                    tw(nL,   {TextColor3=C.TXT},.1)
                    tw(icoL, {TextColor3=C.SCHEME},.1)
                end)
                row.MouseButton1Click:Connect(function()
                    tw(row,{BackgroundColor3=Color3.fromRGB(28,44,20)},.06)
                    task.delay(.12,function() tw(row,{BackgroundColor3=C.ELEM},.1) end)
                    pcall(callback)
                end)

                local B={}
                function B:UpdateButton(t) nL.Text=t or name end
                return B
            end

            -- ──────────────────────────────────────────────────────
            -- NewLabel
            -- ──────────────────────────────────────────────────────
            function Section:NewLabel(text)
                local row = mk("Frame",{
                    Size=UDim2.new(1,0,0,22),
                    BackgroundColor3=Color3.fromRGB(18,18,26),
                    BackgroundTransparency=0.35,BorderSizePixel=0,ZIndex=5,
                }, panel)
                corner(row,6)
                stroke(row, Color3.fromRGB(30,30,42), 1, 0.4)

                -- Ponto decorativo
                mk("Frame",{Size=UDim2.new(0,4,0,4),Position=UDim2.new(0,7,.5,-2),
                    BackgroundColor3=C.SCHEME,BackgroundTransparency=0.45,
                    BorderSizePixel=0,ZIndex=6}, row)

                local nL = lbl(row,text,10,C.TXT_M,Enum.TextXAlignment.Left,Enum.Font.Gotham,6)
                nL.Size=UDim2.new(1,-20,0,22); nL.Position=UDim2.new(0,16,0,0)
                nL.TextWrapped=true; nL.TextYAlignment=Enum.TextYAlignment.Center

                nL:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h=math.max(22,nL.TextBounds.Y+8)
                    row.Size=UDim2.new(1,0,0,h); nL.Size=UDim2.new(1,-20,0,h)
                end)

                local L={}
                function L:UpdateLabel(t) nL.Text=t or "" end
                return L
            end

            -- ──────────────────────────────────────────────────────
            -- NewSlider
            -- ──────────────────────────────────────────────────────
            function Section:NewSlider(name, tip, maxV, minV, callback)
                maxV=tonumber(maxV) or 100; minV=tonumber(minV) or 0
                callback=callback or function() end
                local cur=minV
                local dsp=name:match("^・?(.+)$") or name

                local row=mkElem(EH+10)

                local nL=lbl(row,dsp,11,C.TXT,Enum.TextXAlignment.Left,Enum.Font.GothamBold,6)
                nL.Size=UDim2.new(.6,0,0,17); nL.Position=UDim2.new(0,10,0,5)

                -- Badge valor
                local vBg=mkBadge(row,38,18,46)
                corner(vBg,5)
                local vL=lbl(vBg,tostring(cur),10,C.BADGE_T,Enum.TextXAlignment.Center,Enum.Font.GothamBold,8)
                vL.Size=UDim2.new(1,0,1,0); vL.TextYAlignment=Enum.TextYAlignment.Center

                -- min/max labels
                local minL=lbl(row,tostring(minV),8,C.TXT_D,Enum.TextXAlignment.Left,Enum.Font.Gotham,6)
                minL.Size=UDim2.new(0,25,0,10); minL.Position=UDim2.new(0,10,0,26)
                local maxL=lbl(row,tostring(maxV),8,C.TXT_D,Enum.TextXAlignment.Right,Enum.Font.Gotham,6)
                maxL.Size=UDim2.new(0,25,0,10); maxL.Position=UDim2.new(1,-35,0,26)

                -- Trilho
                local track=mk("Frame",{
                    Size=UDim2.new(1,-20,0,4),Position=UDim2.new(0,10,0,40),
                    BackgroundColor3=Color3.fromRGB(28,28,38),BorderSizePixel=0,ZIndex=6,
                }, row)
                corner(track,2)
                stroke(track,Color3.fromRGB(35,35,48),1)

                local fill=mk("Frame",{
                    Size=UDim2.new(0,0,1,0),BackgroundColor3=C.SCHEME,
                    BorderSizePixel=0,ZIndex=7,
                }, track)
                corner(fill,2)
                grad(fill,C.HDR,C.HDR_DK,0)

                local handle=mk("Frame",{
                    Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(.5,.5),
                    Position=UDim2.new(0,0,.5,0),
                    BackgroundColor3=Color3.fromRGB(230,255,220),
                    BorderSizePixel=0,ZIndex=9,
                }, track)
                corner(handle,5)
                stroke(handle,C.SCHEME,1.2,.3)

                local grab=mk("TextButton",{
                    Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,.5,-11),
                    BackgroundTransparency=1,Text="",ZIndex=10,
                }, track)

                local mouse=PL.LocalPlayer:GetMouse()
                local sliding=false

                local function applyX(mx)
                    local tw_=track.AbsoluteSize.X
                    local rx=math.clamp(mx-track.AbsolutePosition.X,0,tw_)
                    local pct=rx/math.max(tw_,1)
                    cur=math.floor(minV+(maxV-minV)*pct)
                    fill.Size=UDim2.new(0,rx,1,0)
                    handle.Position=UDim2.new(0,rx,.5,0)
                    vL.Text=tostring(cur)
                    pcall(callback,cur)
                end

                grab.MouseButton1Down:Connect(function()
                    sliding=true; applyX(mouse.X)
                    tw(handle,{Size=UDim2.new(0,13,0,13)},.07)
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then
                        sliding=false; tw(handle,{Size=UDim2.new(0,10,0,10)},.07)
                    end
                end)
                mouse.Move:Connect(function() if sliding then applyX(mouse.X) end end)

                local S={}
                function S:UpdateSlider(v)
                    cur=math.clamp(tonumber(v) or minV,minV,maxV)
                    local pct=(cur-minV)/math.max(maxV-minV,1)
                    fill.Size=UDim2.new(pct,0,1,0)
                    handle.Position=UDim2.new(pct,0,.5,0)
                    vL.Text=tostring(cur)
                end
                return S
            end

            -- ──────────────────────────────────────────────────────
            -- NewDropdown  (ícone corrigido: usa texto simples, não emoji)
            -- ──────────────────────────────────────────────────────
            function Section:NewDropdown(name, tip, options, callback)
                options=options or {}; callback=callback or function() end
                local isOpen=false
                local dsp=name:match("^・?(.+)$") or name
                local selected=nil  -- valor selecionado

                local outer=mk("Frame",{
                    Name="DD",Size=UDim2.new(1,0,0,EH),
                    BackgroundColor3=C.ELEM,BorderSizePixel=0,
                    ClipsDescendants=true,ZIndex=6,
                }, panel)
                corner(outer,7)
                local outerStr=stroke(outer,C.ELEM_STR,1)
                grad(outer, Color3.fromRGB(24,24,31), Color3.fromRGB(17,17,23), 180)

                local dHead=mk("TextButton",{
                    Size=UDim2.new(1,0,0,EH),
                    BackgroundTransparency=1,BorderSizePixel=0,
                    AutoButtonColor=false,Text="",ZIndex=7,
                }, outer)

                mkTD(dHead, dsp, tip, 58)

                -- Badge do dropdown  ← SEM EMOJI, só texto ASCII
                local selBg=mkBadge(dHead,46,24,54)
                corner(selBg,6)
                -- Label do valor selecionado
                local selValL=lbl(selBg,"",9,C.BADGE_T,
                    Enum.TextXAlignment.Center,Enum.Font.GothamBold,9)
                selValL.Size=UDim2.new(0,28,1,0); selValL.Position=UDim2.new(0,2,0,0)
                selValL.TextYAlignment=Enum.TextYAlignment.Center
                selValL.TextTruncate=Enum.TextTruncate.AtEnd
                -- Seta (Frame separado para não conflitar)
                local arrowL=lbl(selBg,"v",9,C.TXT_D,
                    Enum.TextXAlignment.Center,Enum.Font.GothamBold,9)
                arrowL.Size=UDim2.new(0,14,1,0); arrowL.Position=UDim2.new(1,-16,0,0)
                arrowL.TextYAlignment=Enum.TextYAlignment.Center

                -- Divisor
                mk("Frame",{Size=UDim2.new(1,-12,0,1),Position=UDim2.new(0,6,0,EH),
                    BackgroundColor3=C.DIV,BorderSizePixel=0,ZIndex=7}, outer)

                -- Opções
                local optBox=mk("Frame",{
                    Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,EH+1),
                    BackgroundTransparency=1,BorderSizePixel=0,ZIndex=7,
                }, outer)
                local optLL=vlist(optBox,2)
                pad(optBox,3,3,5,5)

                local function buildOpts(lst)
                    for _,ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _,opt in ipairs(lst) do
                        local ob=mk("TextButton",{
                            Size=UDim2.new(1,0,0,22),
                            BackgroundColor3=C.OPT,BorderSizePixel=0,
                            AutoButtonColor=false,
                            Text="  "..tostring(opt),
                            Font=Enum.Font.GothamSemibold,TextSize=10,
                            TextColor3=C.TXT_M,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            ZIndex=9,
                        }, optBox)
                        corner(ob,5)
                        ob.MouseEnter:Connect(function()
                            tw(ob,{BackgroundColor3=C.OPT_H,TextColor3=C.TXT},.06)
                        end)
                        ob.MouseLeave:Connect(function()
                            tw(ob,{BackgroundColor3=C.OPT,TextColor3=C.TXT_M},.06)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            selected = opt
                            local sv=tostring(opt)
                            if #sv>5 then sv=sv:sub(1,4)..".." end
                            selValL.Text=sv
                            arrowL.Text="v"
                            isOpen=false
                            tw(outer,{Size=UDim2.new(1,0,0,EH)},.13)
                            tw(outerStr,{Color=C.ELEM_STR,Transparency=0},.1)
                            pcall(callback,opt)
                        end)
                    end
                end
                buildOpts(options)

                dHead.MouseEnter:Connect(function()
                    tw(outer,   {BackgroundColor3=C.ELEM_H},.08)
                    tw(outerStr,{Color=C.ELEM_ACT,Transparency=0.65},.08)
                end)
                dHead.MouseLeave:Connect(function()
                    if not isOpen then
                        tw(outer,   {BackgroundColor3=C.ELEM},.08)
                        tw(outerStr,{Color=C.ELEM_STR,Transparency=0},.08)
                    end
                end)
                dHead.MouseButton1Click:Connect(function()
                    isOpen=not isOpen
                    if isOpen then
                        arrowL.Text="^"
                        tw(outerStr,{Color=C.SCHEME,Transparency=0.3},.1)
                        local oh=optLL.AbsoluteContentSize.Y+8
                        tw(outer,{Size=UDim2.new(1,0,0,EH+1+oh)},.16)
                    else
                        arrowL.Text="v"
                        tw(outer,{Size=UDim2.new(1,0,0,EH)},.13)
                        tw(outerStr,{Color=C.ELEM_STR,Transparency=0},.1)
                    end
                end)

                local D={}
                function D:Refresh(newList,keep)
                    options=newList or {}
                    if not keep then selValL.Text="" end
                    buildOpts(options)
                    if isOpen then
                        local oh=optLL.AbsoluteContentSize.Y+8
                        outer.Size=UDim2.new(1,0,0,EH+1+oh)
                    end
                end
                function D:SetSelected(v)
                    selected=v
                    local sv=tostring(v)
                    if #sv>5 then sv=sv:sub(1,4)..".." end
                    selValL.Text=sv
                end
                return D
            end

            -- ──────────────────────────────────────────────────────
            -- NewTextBox
            -- ──────────────────────────────────────────────────────
            function Section:NewTextBox(name, tip, callback)
                callback=callback or function() end
                local dsp=name:match("^・?(.+)$") or name

                local row=mkElem(EH)
                mkTD(row, dsp, tip, 88)

                local bg=mkBadge(row,76,28,84)
                corner(bg,7)
                local bgStr=stroke(bg,C.BADGE_S,1)

                local tb=mk("TextBox",{
                    Size=UDim2.new(1,-6,1,0),Position=UDim2.new(0,3,0,0),
                    BackgroundTransparency=1,Text="",
                    PlaceholderText="...",PlaceholderColor3=C.TXT_D,
                    Font=Enum.Font.GothamBold,TextSize=11,
                    TextColor3=C.BADGE_T,
                    TextXAlignment=Enum.TextXAlignment.Center,
                    TextYAlignment=Enum.TextYAlignment.Center,
                    ClearTextOnFocus=false,ZIndex=8,
                }, bg)

                tb.Focused:Connect(function()
                    tw(bg,    {BackgroundColor3=C.ELEM_H},.1)
                    tw(bgStr, {Color=C.SCHEME,Transparency=0.2},.1)
                end)
                tb.FocusLost:Connect(function(enter)
                    tw(bg,   {BackgroundColor3=C.BADGE},.1)
                    tw(bgStr,{Color=C.BADGE_S,Transparency=0},.1)
                    if enter then pcall(callback,tb.Text) end
                end)

                local TX={}
                function TX:SetText(s) pcall(function() tb.Text=tostring(s or "") end) end
                function TX:GetText() return tb.Text end
                function TX:Clear() tb.Text="" end
                return TX
            end

            -- ──────────────────────────────────────────────────────
            -- NewKeybind
            -- ──────────────────────────────────────────────────────
            function Section:NewKeybind(name, tip, defaultKey, callback)
                defaultKey=defaultKey or Enum.KeyCode.F
                callback=callback or function() end
                local curKey=defaultKey; local listening=false
                local dsp=name:match("^・?(.+)$") or name

                local row,rowStr=mkBtn(EH)
                mkTD(row,dsp,tip,70)

                local kBg=mkBadge(row,56,24,64)
                corner(kBg,6)
                local kStr=stroke(kBg,C.BADGE_S,1)

                local kL=lbl(kBg,defaultKey.Name,9,C.BADGE_T,
                    Enum.TextXAlignment.Center,Enum.Font.GothamBold,8)
                kL.Size=UDim2.new(1,0,1,0); kL.TextYAlignment=Enum.TextYAlignment.Center

                row.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening=true; kL.Text="..."; kL.TextColor3=C.TXT_D
                    tw(kStr,{Color=C.SCHEME,Transparency=0.2},.1)
                    local conn
                    conn=UIS.InputBegan:Connect(function(inp,gp)
                        if not gp and inp.UserInputType==Enum.UserInputType.Keyboard then
                            curKey=inp.KeyCode; kL.Text=inp.KeyCode.Name
                            kL.TextColor3=C.BADGE_T; listening=false
                            tw(kStr,{Color=C.BADGE_S,Transparency=0},.1)
                            conn:Disconnect()
                        end
                    end)
                end)
                UIS.InputBegan:Connect(function(inp,gp)
                    if not gp and not listening and inp.KeyCode==curKey then pcall(callback) end
                end)
                return {}
            end

            return Section
        end -- NewSection

        return Tab
    end -- NewTab

    -- ────────────────────────────────────────────────────────────────
    -- Utilitários
    -- ────────────────────────────────────────────────────────────────
    function Window:ToggleUI()
        if _GUI then _GUI.Enabled=not _GUI.Enabled end
    end
    function Window:ChangeColor(propOrTable, color)
        if typeof(propOrTable)=="table" then
            local t=propOrTable
            if t.SchemeColor then
                C.SCHEME=t.SchemeColor; C.HDR=t.SchemeColor; C.TAB_ON=t.SchemeColor
                C.BADGE_T=t.SchemeColor; C.TOG_ON=t.SchemeColor; C.ELEM_ACT=t.SchemeColor
                C.HDR_DK=Color3.new(t.SchemeColor.R*.65,t.SchemeColor.G*.65,t.SchemeColor.B*.65)
            end
            if t.Background   then C.WIN =t.Background   end
            if t.TextColor    then C.TXT =t.TextColor    end
            if t.ElementColor then C.ELEM=t.ElementColor end
        elseif typeof(propOrTable)=="string" then
            if propOrTable=="SchemeColor" then
                C.SCHEME=color; C.HDR=color; C.TAB_ON=color
            elseif propOrTable=="Background"   then C.WIN =color
            elseif propOrTable=="TextColor"    then C.TXT =color
            elseif propOrTable=="ElementColor" then C.ELEM=color
            end
        end
    end

    -- Expõe Notify no Window também
    Window.Notify = Notify

    -- ────────────────────────────────────────────────────────────────
    -- Intro → depois mostra GUI
    -- ────────────────────────────────────────────────────────────────
    playIntro(function()
        sg.Enabled=true
        win.Position=UDim2.new(.5,0,.45,0)
        win.BackgroundTransparency=1
        tw(win,{Position=UDim2.new(.5,0,.5,0), BackgroundTransparency=0}, .32,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    return Window
end

-- ──────────────────────────────────────────────────────────────────────
function Library:ToggleUI()
    if _GUI then _GUI.Enabled=not _GUI.Enabled end
end

return Library
