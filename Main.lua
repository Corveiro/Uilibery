--[[
    ╔══════════════════════════════════════════════════════╗
    ║   PVP Script UI  —  ONION STYLE  v2                 ║
    ║   460×380  |  Sidebar  |  Intro flutuante           ║
    ║   Elementos detalhados  |  Resize inferior          ║
    ╚══════════════════════════════════════════════════════╝
--]]

local Library      = {}
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

------------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------------
local function tw(o, p, t, s, d)
    TweenService:Create(o, TweenInfo.new(t or 0.16,
        s or Enum.EasingStyle.Quart,
        d or Enum.EasingDirection.Out), p):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p; return c
end

local function newStroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(50,50,60)
    s.Thickness = th or 1
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p; return s
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
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.FillDirection = Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding = UDim.new(0, sp or 0)
    l.Parent = p; return l
end

local function hlist(p, sp)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.FillDirection = Enum.FillDirection.Horizontal
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.Padding = UDim.new(0, sp or 0)
    l.Parent = p; return l
end

local function lbl(p, txt, sz, col, xa, font, zi)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text         = txt  or ""
    t.TextSize     = sz   or 12
    t.TextColor3   = col  or Color3.fromRGB(220,220,220)
    t.TextXAlignment = xa or Enum.TextXAlignment.Left
    t.Font         = font or Enum.Font.GothamBold
    t.TextTruncate = Enum.TextTruncate.AtEnd
    t.ZIndex       = zi   or 4
    t.Parent       = p; return t
end

local function gradient(p, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    g.Parent   = p; return g
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
-- PALETA
------------------------------------------------------------------------
local C = {
    HDR        = Color3.fromRGB(80, 200, 40),
    HDR_DARK   = Color3.fromRGB(55, 150, 25),
    HDR_TXT    = Color3.fromRGB(255, 255, 255),
    HDR_CLOSE  = Color3.fromRGB(200, 35, 35),
    WIN        = Color3.fromRGB(16, 16, 20),
    SIDEBAR    = Color3.fromRGB(20, 20, 26),
    CONTENT    = Color3.fromRGB(13, 13, 17),
    TAB_OFF    = Color3.fromRGB(20, 20, 26),
    TAB_HOV    = Color3.fromRGB(28, 28, 36),
    TAB_ON     = Color3.fromRGB(80, 200, 40),
    TAB_ON_DK  = Color3.fromRGB(55, 150, 25),
    TAB_TXT_OFF= Color3.fromRGB(120, 120, 138),
    TAB_TXT_ON = Color3.fromRGB(12, 12, 16),
    SEC_TXT    = Color3.fromRGB(90, 210, 45),
    ELEM       = Color3.fromRGB(22, 22, 28),
    ELEM_H     = Color3.fromRGB(30, 30, 38),
    ELEM_DK    = Color3.fromRGB(16, 16, 22),
    ELEM_STR   = Color3.fromRGB(40, 40, 52),
    ELEM_STR_H = Color3.fromRGB(80, 200, 40),
    TOG_OFF    = Color3.fromRGB(38, 38, 50),
    TOG_ON     = Color3.fromRGB(80, 200, 40),
    TOG_ON_DK  = Color3.fromRGB(55, 150, 25),
    TOG_CHECK  = Color3.fromRGB(255, 255, 255),
    BADGE_BG   = Color3.fromRGB(22, 22, 30),
    BADGE_TXT  = Color3.fromRGB(90, 210, 45),
    BADGE_STR  = Color3.fromRGB(50, 50, 64),
    TXT        = Color3.fromRGB(232, 232, 238),
    TXT_DIM    = Color3.fromRGB(95, 95, 112),
    TXT_MID    = Color3.fromRGB(155, 155, 172),
    DIV        = Color3.fromRGB(32, 32, 42),
    SL_TR      = Color3.fromRGB(30, 30, 40),
    SL_FILL    = Color3.fromRGB(80, 200, 40),
    OPT        = Color3.fromRGB(20, 20, 28),
    OPT_H      = Color3.fromRGB(32, 32, 42),
    INP        = Color3.fromRGB(18, 18, 24),
    SCHEME     = Color3.fromRGB(80, 200, 40),
    BTN_ACC    = Color3.fromRGB(80, 200, 40),
    SCROLL     = Color3.fromRGB(80, 200, 40),
    ON         = Color3.fromRGB(80, 200, 40),
    OFF_BG     = Color3.fromRGB(28, 28, 38),
    ON_BG      = Color3.fromRGB(18, 46, 18),
    GLOW       = Color3.fromRGB(80, 200, 40),
}

local _GUI       = nil
local _activeTab = nil

------------------------------------------------------------------------
-- INTRO  — painel flutuante, SEM fundo preto cobrindo a tela
------------------------------------------------------------------------
local function playIntro(title, onDone)
    -- ScreenGui transparente (jogo visível atrás)
    local sg = Instance.new("ScreenGui")
    sg.Name           = "__PVPIntro"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 99998
    sg.BackgroundTransparency = 1
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent or sg.Parent ~= game.CoreGui then
        sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ── Painel principal da intro ─────────────────────────────────
    local W, H = 320, 220
    local panel = Instance.new("Frame")
    panel.AnchorPoint      = Vector2.new(0.5, 0.5)
    panel.Position         = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size             = UDim2.new(0, 0, 0, 0)
    panel.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel  = 0
    panel.ClipsDescendants = true
    panel.ZIndex           = 10
    panel.Parent           = sg
    corner(panel, 18)

    -- Sombra do painel
    local panShadow = Instance.new("ImageLabel")
    panShadow.Size             = UDim2.new(1, 60, 1, 60)
    panShadow.Position         = UDim2.new(0, -30, 0, -30)
    panShadow.BackgroundTransparency = 1
    panShadow.Image            = "rbxassetid://6015897843"
    panShadow.ImageColor3      = Color3.fromRGB(0, 0, 0)
    panShadow.ImageTransparency = 0.3
    panShadow.ScaleType        = Enum.ScaleType.Slice
    panShadow.SliceCenter      = Rect.new(49,49,450,450)
    panShadow.ZIndex           = 9
    panShadow.Parent           = panel

    -- Borda neon verde pulsante
    local panStroke = newStroke(panel, C.SCHEME, 2, 0)

    -- Gradiente sutil no fundo do painel
    gradient(panel,
        Color3.fromRGB(18, 22, 16),
        Color3.fromRGB(10, 12, 10), 145)

    -- Linha superior colorida (accent bar)
    local topBar = Instance.new("Frame")
    topBar.Size             = UDim2.new(1, 0, 0, 3)
    topBar.BackgroundColor3 = C.SCHEME
    topBar.BorderSizePixel  = 0
    topBar.ZIndex           = 15
    topBar.Parent           = panel
    gradient(topBar, C.HDR, C.HDR_DK or Color3.fromRGB(40,120,15), 0)

    -- ── Ring animado (círculos concêntricos girando) ──────────────
    local ringContainer = Instance.new("Frame")
    ringContainer.AnchorPoint      = Vector2.new(0.5, 0.5)
    ringContainer.Size             = UDim2.new(0, 80, 0, 80)
    ringContainer.Position         = UDim2.new(0.5, 0, 0.37, 0)
    ringContainer.BackgroundTransparency = 1
    ringContainer.BorderSizePixel  = 0
    ringContainer.ZIndex           = 12
    ringContainer.Parent           = panel

    -- Anel externo
    local ringOuter = Instance.new("Frame")
    ringOuter.AnchorPoint      = Vector2.new(0.5, 0.5)
    ringOuter.Size             = UDim2.new(0, 0, 0, 0)
    ringOuter.Position         = UDim2.new(0.5, 0, 0.5, 0)
    ringOuter.BackgroundTransparency = 1
    ringOuter.BorderSizePixel  = 0
    ringOuter.ZIndex           = 12
    ringOuter.Parent           = ringContainer
    corner(ringOuter, 40)
    newStroke(ringOuter, C.SCHEME, 2, 0.3)

    -- Anel médio
    local ringMid = Instance.new("Frame")
    ringMid.AnchorPoint      = Vector2.new(0.5, 0.5)
    ringMid.Size             = UDim2.new(0, 0, 0, 0)
    ringMid.Position         = UDim2.new(0.5, 0, 0.5, 0)
    ringMid.BackgroundTransparency = 1
    ringMid.BorderSizePixel  = 0
    ringMid.ZIndex           = 13
    ringMid.Parent           = ringContainer
    corner(ringMid, 30)
    newStroke(ringMid, C.SCHEME, 1.5, 0.5)

    -- Círculo central (ícone)
    local iconCircle = Instance.new("Frame")
    iconCircle.AnchorPoint      = Vector2.new(0.5, 0.5)
    iconCircle.Size             = UDim2.new(0, 0, 0, 0)
    iconCircle.Position         = UDim2.new(0.5, 0, 0.5, 0)
    iconCircle.BackgroundColor3 = C.SCHEME
    iconCircle.BorderSizePixel  = 0
    iconCircle.ZIndex           = 14
    iconCircle.Parent           = ringContainer
    corner(iconCircle, 30)
    gradient(iconCircle, C.HDR, C.HDR_DK or Color3.fromRGB(40,120,15), 135)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size                 = UDim2.new(1, 0, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text                 = "⚔️"
    iconLbl.TextScaled           = true
    iconLbl.Font                 = Enum.Font.GothamBold
    iconLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    iconLbl.TextTransparency     = 1
    iconLbl.ZIndex               = 15
    iconLbl.Parent               = iconCircle

    -- Pontos orbitais (4 pontos girando em volta do ícone)
    local orbitDots = {}
    for i = 1, 4 do
        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, 5, 0, 5)
        dot.AnchorPoint      = Vector2.new(0.5, 0.5)
        dot.BackgroundColor3 = C.SCHEME
        dot.BackgroundTransparency = 0.4
        dot.BorderSizePixel  = 0
        dot.ZIndex           = 13
        dot.Visible          = false
        dot.Parent           = ringContainer
        corner(dot, 3)
        orbitDots[i] = dot
    end

    -- ── Textos ───────────────────────────────────────────────────
    local titleTxt = Instance.new("TextLabel")
    titleTxt.AnchorPoint          = Vector2.new(0.5, 0)
    titleTxt.Size                 = UDim2.new(0.9, 0, 0, 26)
    titleTxt.Position             = UDim2.new(0.5, 0, 0.62, 0)
    titleTxt.BackgroundTransparency = 1
    titleTxt.Text                 = "PVP SCRIPT"
    titleTxt.TextSize             = 20
    titleTxt.Font                 = Enum.Font.GothamBold
    titleTxt.TextColor3           = Color3.fromRGB(255, 255, 255)
    titleTxt.TextXAlignment       = Enum.TextXAlignment.Center
    titleTxt.TextTransparency     = 1
    titleTxt.ZIndex               = 12
    titleTxt.Parent               = panel

    local subTxt = Instance.new("TextLabel")
    subTxt.AnchorPoint          = Vector2.new(0.5, 0)
    subTxt.Size                 = UDim2.new(0.9, 0, 0, 18)
    subTxt.Position             = UDim2.new(0.5, 0, 0.75, 0)
    subTxt.BackgroundTransparency = 1
    subTxt.Text                 = "Blox Fruit  ·  All In One  ·  PVP"
    subTxt.TextSize             = 11
    subTxt.Font                 = Enum.Font.GothamSemibold
    subTxt.TextColor3           = C.SCHEME
    subTxt.TextXAlignment       = Enum.TextXAlignment.Center
    subTxt.TextTransparency     = 1
    subTxt.ZIndex               = 12
    subTxt.Parent               = panel

    -- ── Barra de progresso detalhada ─────────────────────────────
    local barWrap = Instance.new("Frame")
    barWrap.AnchorPoint      = Vector2.new(0.5, 0)
    barWrap.Size             = UDim2.new(0.75, 0, 0, 22)
    barWrap.Position         = UDim2.new(0.5, 0, 0.855, 0)
    barWrap.BackgroundTransparency = 1
    barWrap.BorderSizePixel  = 0
    barWrap.ZIndex           = 12
    barWrap.Parent           = panel

    -- Fundo da barra
    local barBg = Instance.new("Frame")
    barBg.Size             = UDim2.new(1, 0, 0, 6)
    barBg.Position         = UDim2.new(0, 0, 0.5, -3)
    barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    barBg.BorderSizePixel  = 0
    barBg.ZIndex           = 12
    barBg.Parent           = barWrap
    corner(barBg, 4)
    newStroke(barBg, Color3.fromRGB(40,40,52), 1)

    -- Fill da barra com gradiente
    local barFill = Instance.new("Frame")
    barFill.Size             = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = C.SCHEME
    barFill.BorderSizePixel  = 0
    barFill.ZIndex           = 13
    barFill.Parent           = barBg
    corner(barFill, 4)
    gradient(barFill, C.HDR, Color3.fromRGB(40,180,10), 0)

    -- Brilho no topo do fill
    local barGlow = Instance.new("Frame")
    barGlow.Size             = UDim2.new(1, 0, 0, 2)
    barGlow.BackgroundColor3 = Color3.fromRGB(200, 255, 160)
    barGlow.BackgroundTransparency = 0.5
    barGlow.BorderSizePixel  = 0
    barGlow.ZIndex           = 14
    barGlow.Parent           = barFill

    -- Porcentagem
    local barPct = lbl(barWrap, "0%", 10, C.SCHEME,
        Enum.TextXAlignment.Right, Enum.Font.GothamBold, 13)
    barPct.Size     = UDim2.new(0, 32, 1, 0)
    barPct.Position = UDim2.new(1, 2, 0, 0)
    barPct.TextTransparency = 1

    -- Status
    local statusLbl = Instance.new("TextLabel")
    statusLbl.AnchorPoint          = Vector2.new(0.5, 0)
    statusLbl.Size                 = UDim2.new(0.9, 0, 0, 14)
    statusLbl.Position             = UDim2.new(0.5, 0, 0.94, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text                 = "Initializing..."
    statusLbl.TextSize             = 10
    statusLbl.Font                 = Enum.Font.Gotham
    statusLbl.TextColor3           = C.TXT_DIM
    statusLbl.TextXAlignment       = Enum.TextXAlignment.Center
    statusLbl.TextTransparency     = 1
    statusLbl.ZIndex               = 12
    statusLbl.Parent               = panel

    -- Scan line que desce pelo painel
    local scanLine = Instance.new("Frame")
    scanLine.Size             = UDim2.new(1, 0, 0, 2)
    scanLine.Position         = UDim2.new(0, 0, 0, 3)
    scanLine.BackgroundColor3 = C.SCHEME
    scanLine.BackgroundTransparency = 0.2
    scanLine.BorderSizePixel  = 0
    scanLine.ZIndex           = 20
    scanLine.Parent           = panel

    -- ── Cantos decorativos ────────────────────────────────────────
    local function mkCornerDeco(ancX, ancY, posX, posY)
        local f = Instance.new("Frame")
        f.Size             = UDim2.new(0, 16, 0, 16)
        f.AnchorPoint      = Vector2.new(ancX, ancY)
        f.Position         = UDim2.new(posX, 0, posY, 0)
        f.BackgroundTransparency = 1
        f.BorderSizePixel  = 0
        f.ZIndex           = 18
        f.Parent           = panel
        -- Linha horizontal
        local lh = Instance.new("Frame")
        lh.Size             = UDim2.new(1, 0, 0, 2)
        lh.Position         = ancY == 0 and UDim2.new(0,0,0,0) or UDim2.new(0,0,1,-2)
        lh.BackgroundColor3 = C.SCHEME
        lh.BorderSizePixel  = 0
        lh.ZIndex           = 19
        lh.Parent           = f
        -- Linha vertical
        local lv = Instance.new("Frame")
        lv.Size             = UDim2.new(0, 2, 1, 0)
        lv.Position         = ancX == 0 and UDim2.new(0,0,0,0) or UDim2.new(1,-2,0,0)
        lv.BackgroundColor3 = C.SCHEME
        lv.BorderSizePixel  = 0
        lv.ZIndex           = 19
        lv.Parent           = f
        return f
    end
    mkCornerDeco(0, 0, 0, 0)
    mkCornerDeco(1, 0, 1, 0)
    mkCornerDeco(0, 1, 0, 1)
    mkCornerDeco(1, 1, 1, 1)

    -- ── Animação da borda pulsante ────────────────────────────────
    local pulseConn
    local pulseAlpha = 0
    local pulseDir   = 1
    pulseConn = RunService.Heartbeat:Connect(function(dt)
        pulseAlpha = pulseAlpha + dt * 2 * pulseDir
        if pulseAlpha >= 1 then pulseDir = -1
        elseif pulseAlpha <= 0 then pulseDir = 1 end
        panStroke.Transparency = 0.2 + pulseAlpha * 0.5
    end)

    -- ── Animação dos pontos orbitais ──────────────────────────────
    local orbitAngle = 0
    local orbitConn
    orbitConn = RunService.Heartbeat:Connect(function(dt)
        orbitAngle = orbitAngle + dt * 120 -- graus/s
        local cx, cy = 0.5, 0.5
        local r = 0.42  -- raio em escala do ringContainer
        for i, dot in ipairs(orbitDots) do
            local angle = math.rad(orbitAngle + (i - 1) * 90)
            local nx = cx + math.cos(angle) * r
            local ny = cy + math.sin(angle) * r
            dot.Position = UDim2.new(nx, -2, ny, -2)
        end
    end)

    -- ── Sequência principal ───────────────────────────────────────
    task.spawn(function()
        -- 1. Painel aparece com efeito Back
        tw(panel, {Size = UDim2.new(0, W, 0, H)}, 0.55,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.4)

        -- 2. Scan line desce
        tw(scanLine, {Position = UDim2.new(0, 0, 1, -2), BackgroundTransparency = 0.8}, 0.7,
            Enum.EasingStyle.Linear)

        -- 3. Anéis expandem
        tw(ringOuter, {Size = UDim2.new(0, 78, 0, 78)}, 0.45,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.1)
        tw(ringMid, {Size = UDim2.new(0, 58, 0, 58)}, 0.4,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.1)
        tw(iconCircle, {Size = UDim2.new(0, 42, 0, 42)}, 0.38,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tw(iconLbl, {TextTransparency = 0}, 0.3)

        -- Ativa os pontos orbitais
        for _, d in ipairs(orbitDots) do d.Visible = true end
        task.wait(0.25)

        -- 4. Textos aparecem
        tw(titleTxt,  {TextTransparency = 0}, 0.35)
        task.wait(0.1)
        tw(subTxt,    {TextTransparency = 0}, 0.3)
        tw(statusLbl, {TextTransparency = 0}, 0.3)
        tw(barPct,    {TextTransparency = 0}, 0.3)
        task.wait(0.2)

        -- 5. Barra de progresso em etapas
        local stages = {
            {0.20, "Loading modules...",     "20%"},
            {0.45, "Setting up combat...",   "45%"},
            {0.70, "Connecting remotes...",  "70%"},
            {0.88, "Applying settings...",   "88%"},
            {1.00, "Ready!",                 "100%"},
        }
        for _, st in ipairs(stages) do
            tw(barFill, {Size = UDim2.new(st[1], 0, 1, 0)}, 0.28)
            statusLbl.Text = st[2]
            barPct.Text    = st[3]
            task.wait(0.3)
        end

        -- 6. Flash verde + pisca borda
        tw(iconCircle, {BackgroundColor3 = Color3.fromRGB(180, 255, 120)}, 0.08)
        tw(panStroke,  {Transparency = 0, Thickness = 3}, 0.08)
        task.wait(0.12)
        tw(iconCircle, {BackgroundColor3 = C.SCHEME}, 0.15)
        tw(panStroke,  {Transparency = 0.2, Thickness = 2}, 0.15)
        task.wait(0.2)

        -- 7. Fade out suave de todos os elementos internos
        local fadeOuts = {titleTxt, subTxt, statusLbl, barPct, iconLbl}
        for _, o in ipairs(fadeOuts) do tw(o, {TextTransparency = 1}, 0.22) end
        tw(iconCircle, {BackgroundTransparency = 1}, 0.22)
        tw(ringOuter,  {BackgroundTransparency = 1}, 0.2)
        for _, d in ipairs(orbitDots) do tw(d, {BackgroundTransparency = 1}, 0.2) end
        tw(barFill, {BackgroundTransparency = 1}, 0.2)
        tw(barBg,   {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25)

        -- 8. Painel fecha com efeito Quart In
        tw(panel, {Size = UDim2.new(0, 0, 0, 0),
                   BackgroundTransparency = 0.6}, 0.32,
            Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.35)

        -- 9. Limpa
        pulseConn:Disconnect()
        orbitConn:Disconnect()
        sg:Destroy()

        -- 10. Callback
        pcall(onDone)
    end)
end

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    if typeof(themeColor) == "Color3" then
        local sc = themeColor
        C.SCHEME = sc; C.SL_FILL = sc; C.ON = sc; C.TAB_ON = sc
        C.SEC_TXT = sc; C.BTN_ACC = sc; C.SCROLL = sc
        C.BADGE_TXT = sc; C.HDR = sc; C.TOG_ON = sc; C.GLOW = sc
    elseif typeof(themeColor) == "table" then
        if themeColor.SchemeColor then
            local sc = themeColor.SchemeColor
            C.SCHEME = sc; C.SL_FILL = sc; C.TAB_ON = sc
            C.SEC_TXT = sc; C.BTN_ACC = sc; C.SCROLL = sc
            C.BADGE_TXT = sc; C.ON = sc; C.HDR = sc
            C.TOG_ON = sc; C.GLOW = sc
        end
        if themeColor.Background   then C.WIN  = themeColor.Background   end
        if themeColor.Header       then C.HDR  = themeColor.Header       end
        if themeColor.TextColor    then C.TXT  = themeColor.TextColor    end
        if themeColor.ElementColor then C.ELEM = themeColor.ElementColor end
    end

    pcall(function()
        for _, v in ipairs(game.CoreGui:GetChildren()) do
            if v.Name == "__OLib" then v:Destroy() end
        end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name           = "__OLib"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 9999
    sg.Enabled        = false
    pcall(function() sg.Parent = game.CoreGui end)
    _GUI = sg

    ------------------------------------------------------------------
    -- DIMENSÕES
    ------------------------------------------------------------------
    local WIN_W   = 460   -- largura total
    local SIDE_W  = 148   -- sidebar
    local HDR_H   = 52    -- header
    local WIN_H   = 380   -- altura inicial
    local WIN_MIN = 220   -- mínima
    local WIN_MAX = 560   -- máxima
    local EH      = 56    -- elemento normal (título + desc)
    local EH_SM   = 32    -- elemento pequeno

    ------------------------------------------------------------------
    -- JANELA
    ------------------------------------------------------------------
    local win = Instance.new("Frame")
    win.Name             = "Win"
    win.AnchorPoint      = Vector2.new(0.5, 0)
    win.Position         = UDim2.new(0.5, 0, 0.04, 0)
    win.Size             = UDim2.new(0, WIN_W, 0, WIN_H)
    win.BackgroundColor3 = C.WIN
    win.BorderSizePixel  = 0
    win.ClipsDescendants = false
    win.Parent           = sg
    corner(win, 12)

    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Size             = UDim2.new(1, 50, 1, 50)
    shadow.Position         = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image            = "rbxassetid://6015897843"
    shadow.ImageColor3      = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.45
    shadow.ScaleType        = Enum.ScaleType.Slice
    shadow.SliceCenter      = Rect.new(49,49,450,450)
    shadow.ZIndex           = 0
    shadow.Parent           = win

    ------------------------------------------------------------------
    -- HEADER
    ------------------------------------------------------------------
    local hdr = Instance.new("Frame")
    hdr.Name             = "Hdr"
    hdr.Size             = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = C.HDR
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 10
    hdr.Parent           = win
    corner(hdr, 12)
    gradient(hdr, C.HDR, C.HDR_DARK, 100)

    -- Patch inferior do header (remove arredondamento embaixo)
    local hfix = Instance.new("Frame")
    hfix.Size             = UDim2.new(1, 0, 0, 14)
    hfix.Position         = UDim2.new(0, 0, 1, -14)
    hfix.BackgroundColor3 = C.HDR
    hfix.BorderSizePixel  = 0
    hfix.ZIndex           = 10
    hfix.Parent           = hdr
    gradient(hfix, C.HDR, C.HDR_DARK, 100)

    -- Linha brilhante na parte inferior do header
    local hdrBottomLine = Instance.new("Frame")
    hdrBottomLine.Size             = UDim2.new(1, 0, 0, 2)
    hdrBottomLine.Position         = UDim2.new(0, 0, 1, -2)
    hdrBottomLine.BackgroundColor3 = Color3.fromRGB(150, 255, 80)
    hdrBottomLine.BackgroundTransparency = 0.5
    hdrBottomLine.BorderSizePixel  = 0
    hdrBottomLine.ZIndex           = 11
    hdrBottomLine.Parent           = hdr

    -- Ícone no header
    local hdrIconBg = Instance.new("Frame")
    hdrIconBg.Size             = UDim2.new(0, 34, 0, 34)
    hdrIconBg.Position         = UDim2.new(0, 10, 0.5, -17)
    hdrIconBg.BackgroundColor3 = Color3.fromRGB(255,255,255)
    hdrIconBg.BackgroundTransparency = 0.85
    hdrIconBg.BorderSizePixel  = 0
    hdrIconBg.ZIndex           = 12
    hdrIconBg.Parent           = hdr
    corner(hdrIconBg, 9)

    local hdrIconLbl = Instance.new("TextLabel")
    hdrIconLbl.Size                 = UDim2.new(1,0,1,0)
    hdrIconLbl.BackgroundTransparency = 1
    hdrIconLbl.Text                 = "⚔️"
    hdrIconLbl.TextScaled           = true
    hdrIconLbl.Font                 = Enum.Font.GothamBold
    hdrIconLbl.TextColor3           = Color3.fromRGB(255,255,255)
    hdrIconLbl.ZIndex               = 13
    hdrIconLbl.Parent               = hdrIconBg

    -- Título
    local titleLbl = lbl(hdr, title or "PVP SCRIPT", 17,
        Color3.fromRGB(255,255,255), Enum.TextXAlignment.Left, Enum.Font.GothamBold, 11)
    titleLbl.Size     = UDim2.new(1, -110, 1, 0)
    titleLbl.Position = UDim2.new(0, 52, 0, 0)
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center
    -- Sombra no texto
    titleLbl.TextStrokeTransparency = 0.6
    titleLbl.TextStrokeColor3       = Color3.fromRGB(0,60,0)

    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size             = UDim2.new(0, 34, 0, 34)
    closeBtn.Position         = UDim2.new(1, -44, 0.5, -17)
    closeBtn.BackgroundColor3 = C.HDR_CLOSE
    closeBtn.BorderSizePixel  = 0
    closeBtn.Text             = "✕"
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.TextSize         = 14
    closeBtn.TextColor3       = Color3.fromRGB(255,255,255)
    closeBtn.AutoButtonColor  = false
    closeBtn.ZIndex           = 14
    closeBtn.Parent           = hdr
    corner(closeBtn, 9)
    newStroke(closeBtn, Color3.fromRGB(240,80,80), 1, 0.5)

    closeBtn.MouseEnter:Connect(function()
        tw(closeBtn, {BackgroundColor3 = Color3.fromRGB(235,55,55)}, 0.08)
    end)
    closeBtn.MouseLeave:Connect(function()
        tw(closeBtn, {BackgroundColor3 = C.HDR_CLOSE}, 0.08)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tw(win, {Size = UDim2.new(0, WIN_W, 0, 0), BackgroundTransparency = 1}, 0.2)
        task.delay(0.22, function() sg:Destroy() end)
    end)

    draggable(hdr, win)

    ------------------------------------------------------------------
    -- CORPO (sidebar + conteúdo)
    ------------------------------------------------------------------
    local bodyFrame = Instance.new("Frame")
    bodyFrame.Name             = "Body"
    bodyFrame.Size             = UDim2.new(1, 0, 1, -HDR_H)
    bodyFrame.Position         = UDim2.new(0, 0, 0, HDR_H)
    bodyFrame.BackgroundTransparency = 1
    bodyFrame.BorderSizePixel  = 0
    bodyFrame.ClipsDescendants = true
    bodyFrame.ZIndex           = 2
    bodyFrame.Parent           = win

    ------------------------------------------------------------------
    -- SIDEBAR
    ------------------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Name             = "Sidebar"
    sidebar.Size             = UDim2.new(0, SIDE_W, 1, 0)
    sidebar.BackgroundColor3 = C.SIDEBAR
    sidebar.BorderSizePixel  = 0
    sidebar.ZIndex           = 3
    sidebar.Parent           = bodyFrame

    -- Gradiente lateral
    gradient(sidebar,
        Color3.fromRGB(22, 22, 30),
        Color3.fromRGB(18, 18, 24), 180)

    -- Linha separadora
    local sideLine = Instance.new("Frame")
    sideLine.Size             = UDim2.new(0, 1, 1, 0)
    sideLine.Position         = UDim2.new(1, -1, 0, 0)
    sideLine.BackgroundColor3 = C.DIV
    sideLine.BorderSizePixel  = 0
    sideLine.ZIndex           = 4
    sideLine.Parent           = sidebar

    -- Fix topo arredondado
    local sideFix = Instance.new("Frame")
    sideFix.Size             = UDim2.new(1, 0, 0, 8)
    sideFix.BackgroundColor3 = C.SIDEBAR
    sideFix.BorderSizePixel  = 0
    sideFix.ZIndex           = 3
    sideFix.Parent           = sidebar

    -- Lista das tabs
    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Size                  = UDim2.new(1, 0, 1, -8)
    sideScroll.Position              = UDim2.new(0, 0, 0, 8)
    sideScroll.BackgroundTransparency = 1
    sideScroll.BorderSizePixel       = 0
    sideScroll.ScrollBarThickness    = 2
    sideScroll.ScrollBarImageColor3  = C.SCHEME
    sideScroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    sideScroll.CanvasSize            = UDim2.new(0,0,0,0)
    sideScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    sideScroll.ZIndex                = 4
    sideScroll.Parent                = sidebar
    vlist(sideScroll, 3)
    pad(sideScroll, 6, 6, 6, 6)

    ------------------------------------------------------------------
    -- PAINEL DE CONTEÚDO
    ------------------------------------------------------------------
    local contentPanel = Instance.new("Frame")
    contentPanel.Name             = "Content"
    contentPanel.Size             = UDim2.new(1, -SIDE_W, 1, 0)
    contentPanel.Position         = UDim2.new(0, SIDE_W, 0, 0)
    contentPanel.BackgroundColor3 = C.CONTENT
    contentPanel.BorderSizePixel  = 0
    contentPanel.ZIndex           = 3
    contentPanel.ClipsDescendants = true
    contentPanel.Parent           = bodyFrame

    gradient(contentPanel,
        Color3.fromRGB(14, 14, 18),
        Color3.fromRGB(11, 11, 15), 180)

    -- Título da aba ativa (top do painel)
    local secTitleLbl = lbl(contentPanel, "", 14, C.SEC_TXT,
        Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
    secTitleLbl.Size     = UDim2.new(1, -16, 0, 36)
    secTitleLbl.Position = UDim2.new(0, 14, 0, 2)
    secTitleLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Linha verde sob o título
    local secTitleLine = Instance.new("Frame")
    secTitleLine.Size             = UDim2.new(1, -14, 0, 1)
    secTitleLine.Position         = UDim2.new(0, 7, 0, 37)
    secTitleLine.BackgroundColor3 = C.SCHEME
    secTitleLine.BackgroundTransparency = 0.55
    secTitleLine.BorderSizePixel  = 0
    secTitleLine.ZIndex           = 5
    secTitleLine.Parent           = contentPanel

    -- ScrollingFrame do conteúdo
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name                  = "Scroll"
    scroll.Position              = UDim2.new(0, 0, 0, 40)
    scroll.Size                  = UDim2.new(1, -4, 1, -44)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel       = 0
    scroll.ScrollBarThickness    = 3
    scroll.ScrollBarImageColor3  = C.SCROLL
    scroll.CanvasSize            = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    scroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    scroll.ClipsDescendants      = true
    scroll.ZIndex                = 4
    scroll.Parent                = contentPanel
    vlist(scroll, 5)
    pad(scroll, 6, 10, 8, 8)

    ------------------------------------------------------------------
    -- RESIZE HANDLE
    ------------------------------------------------------------------
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name             = "ResizeHandle"
    resizeHandle.Size             = UDim2.new(1, -24, 0, 7)
    resizeHandle.Position         = UDim2.new(0, 12, 1, -5)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    resizeHandle.BackgroundTransparency = 0.55
    resizeHandle.BorderSizePixel  = 0
    resizeHandle.AutoButtonColor  = false
    resizeHandle.Text             = ""
    resizeHandle.ZIndex           = 20
    resizeHandle.Parent           = win
    corner(resizeHandle, 4)
    newStroke(resizeHandle, Color3.fromRGB(90,90,110), 1, 0.6)

    -- Pontinhos visuais
    local dotRow = Instance.new("Frame")
    dotRow.Size                 = UDim2.new(0, 40, 0, 3)
    dotRow.AnchorPoint          = Vector2.new(0.5, 0.5)
    dotRow.Position             = UDim2.new(0.5, 0, 0.5, 0)
    dotRow.BackgroundTransparency = 1
    dotRow.BorderSizePixel      = 0
    dotRow.ZIndex               = 21
    dotRow.Parent               = resizeHandle
    hlist(dotRow, 7)

    for i = 1, 3 do
        local d = Instance.new("Frame")
        d.Size             = UDim2.new(0, 6, 0, 3)
        d.BackgroundColor3 = Color3.fromRGB(170,170,190)
        d.BackgroundTransparency = 0.25
        d.BorderSizePixel  = 0
        d.ZIndex           = 22
        d.Parent           = dotRow
        corner(d, 2)
    end

    resizeHandle.MouseEnter:Connect(function()
        tw(resizeHandle, {BackgroundTransparency = 0.2}, 0.1)
    end)
    resizeHandle.MouseLeave:Connect(function()
        tw(resizeHandle, {BackgroundTransparency = 0.55}, 0.1)
    end)

    local resizing, resizeStartY, resizeStartH = false, 0, 0
    resizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStartY = i.Position.Y
            resizeStartH = win.AbsoluteSize.Y
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement
                      or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position.Y - resizeStartY
            win.Size = UDim2.new(0, WIN_W, 0,
                math.clamp(resizeStartH + delta, WIN_MIN, WIN_MAX))
        end
    end)

    ------------------------------------------------------------------
    -- Window:NewTab
    ------------------------------------------------------------------
    local Window    = {}
    local tabPanels = {}
    local tabIndex  = 0

    local defaultIcons = {
        "🏠","⚔️","👁","🔧","🥊","⚙️","🎯","💎","🌍","🔄","📡","🛡️"
    }

    local function showTab(td)
        for _, t in ipairs(tabPanels) do
            t.panel.Visible = false
            tw(t.btn, {BackgroundColor3 = C.TAB_OFF}, 0.12)
            tw(t.nameLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.1)
            if t.iconLbl then tw(t.iconLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.1) end
            if t.activeBar then tw(t.activeBar, {BackgroundTransparency = 1}, 0.1) end
        end
        td.panel.Visible = true
        tw(td.btn, {BackgroundColor3 = C.TAB_ON}, 0.15)
        tw(td.nameLbl, {TextColor3 = C.TAB_TXT_ON}, 0.12)
        if td.iconLbl then tw(td.iconLbl, {TextColor3 = C.TAB_TXT_ON}, 0.12) end
        if td.activeBar then tw(td.activeBar, {BackgroundTransparency = 0}, 0.12) end
        secTitleLbl.Text = td.cleanName
        _activeTab = td
    end

    function Window:NewTab(tabName)
        tabName  = tabName or "Tab"
        tabIndex = tabIndex + 1

        local iconStr   = defaultIcons[tabIndex] or "•"
        local cleanName = tabName
        local ei, en    = tabName:match("^(.-)・(.+)$")
        if ei and en then iconStr = ei; cleanName = en end

        ---- Botão da tab ----
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size             = UDim2.new(1, 0, 0, 42)
        tabBtn.BackgroundColor3 = C.TAB_OFF
        tabBtn.BorderSizePixel  = 0
        tabBtn.AutoButtonColor  = false
        tabBtn.Text             = ""
        tabBtn.ZIndex           = 5
        tabBtn.Parent           = sideScroll
        corner(tabBtn, 9)

        -- Indicador lateral ativo (barra verde esquerda)
        local activeBar = Instance.new("Frame")
        activeBar.Size             = UDim2.new(0, 3, 0, 22)
        activeBar.Position         = UDim2.new(0, 0, 0.5, -11)
        activeBar.BackgroundColor3 = Color3.fromRGB(200, 255, 150)
        activeBar.BackgroundTransparency = 1
        activeBar.BorderSizePixel  = 0
        activeBar.ZIndex           = 7
        activeBar.Parent           = tabBtn
        corner(activeBar, 2)

        -- Gradiente no btn quando ativo (aplicado depois via tween)
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size                 = UDim2.new(0, 22, 1, 0)
        tabIcon.Position             = UDim2.new(0, 10, 0, 0)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text                 = iconStr
        tabIcon.TextScaled           = true
        tabIcon.Font                 = Enum.Font.GothamBold
        tabIcon.TextColor3           = C.TAB_TXT_OFF
        tabIcon.TextXAlignment       = Enum.TextXAlignment.Center
        tabIcon.ZIndex               = 6
        tabIcon.Parent               = tabBtn

        local tabNameLbl = lbl(tabBtn, cleanName, 12, C.TAB_TXT_OFF,
            Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
        tabNameLbl.Size     = UDim2.new(1, -38, 1, 0)
        tabNameLbl.Position = UDim2.new(0, 36, 0, 0)
        tabNameLbl.TextYAlignment = Enum.TextYAlignment.Center

        ---- Painel de conteúdo ----
        local panel = Instance.new("Frame")
        panel.Name             = "Panel_" .. cleanName
        panel.Size             = UDim2.new(1, 0, 0, 0)
        panel.AutomaticSize    = Enum.AutomaticSize.Y
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel  = 0
        panel.Visible          = false
        panel.ZIndex           = 5
        panel.Parent           = scroll
        vlist(panel, 6)

        local td = {
            btn       = tabBtn,
            panel     = panel,
            nameLbl   = tabNameLbl,
            iconLbl   = tabIcon,
            activeBar = activeBar,
            cleanName = cleanName,
        }
        table.insert(tabPanels, td)

        tabBtn.MouseButton1Click:Connect(function() showTab(td) end)

        tabBtn.MouseEnter:Connect(function()
            if _activeTab ~= td then
                tw(tabBtn,    {BackgroundColor3 = C.TAB_HOV}, 0.08)
                tw(tabNameLbl,{TextColor3 = C.TXT}, 0.08)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if _activeTab ~= td then
                tw(tabBtn,    {BackgroundColor3 = C.TAB_OFF}, 0.08)
                tw(tabNameLbl,{TextColor3 = C.TAB_TXT_OFF}, 0.08)
            end
        end)

        if tabIndex == 1 then
            task.defer(function() showTab(td) end)
        end

        ----------------------------------------------------------------
        -- Tab:NewSection
        ----------------------------------------------------------------
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"
            local secClean = secName
            local _, sn = secName:match("^.+・(.+)$")
            if sn then secClean = sn end

            -- Cabeçalho da seção
            local secHdr = Instance.new("Frame")
            secHdr.Size             = UDim2.new(1, 0, 0, 26)
            secHdr.BackgroundTransparency = 1
            secHdr.BorderSizePixel  = 0
            secHdr.ZIndex           = 5
            secHdr.Parent           = panel

            -- Bola verde + texto
            local secDot = Instance.new("Frame")
            secDot.Size             = UDim2.new(0, 6, 0, 6)
            secDot.Position         = UDim2.new(0, 0, 0.5, -3)
            secDot.BackgroundColor3 = C.SCHEME
            secDot.BorderSizePixel  = 0
            secDot.ZIndex           = 6
            secDot.Parent           = secHdr
            corner(secDot, 3)

            local secLbl = lbl(secHdr, secClean, 13, C.SEC_TXT,
                Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
            secLbl.Size     = UDim2.new(1, -12, 1, 0)
            secLbl.Position = UDim2.new(0, 12, 0, 0)
            secLbl.TextYAlignment = Enum.TextYAlignment.Center

            -- Linha tracejada abaixo
            local secLine = Instance.new("Frame")
            secLine.Size             = UDim2.new(1, 0, 0, 1)
            secLine.Position         = UDim2.new(0, 0, 1, -1)
            secLine.BackgroundColor3 = C.SCHEME
            secLine.BackgroundTransparency = 0.65
            secLine.BorderSizePixel  = 0
            secLine.ZIndex           = 6
            secLine.Parent           = secHdr

            ---- Helpers internos ----
            local Section = {}

            -- Cria frame de elemento (read-only, sem hover)
            local function mkElem(h)
                local f = Instance.new("Frame")
                f.Size             = UDim2.new(1, 0, 0, h or EH)
                f.BackgroundColor3 = C.ELEM
                f.BorderSizePixel  = 0
                f.ZIndex           = 5
                f.Parent           = panel
                corner(f, 8)
                newStroke(f, C.ELEM_STR, 1)
                -- Gradiente sutil
                gradient(f,
                    Color3.fromRGB(26, 26, 34),
                    Color3.fromRGB(18, 18, 24), 180)
                return f
            end

            -- Cria botão de elemento (com hover)
            local function mkElemBtn(h)
                local b = Instance.new("TextButton")
                b.Size             = UDim2.new(1, 0, 0, h or EH)
                b.BackgroundColor3 = C.ELEM
                b.BorderSizePixel  = 0
                b.AutoButtonColor  = false
                b.Text             = ""
                b.ZIndex           = 5
                b.Parent           = panel
                corner(b, 8)
                local st = newStroke(b, C.ELEM_STR, 1)
                gradient(b,
                    Color3.fromRGB(26, 26, 34),
                    Color3.fromRGB(18, 18, 24), 180)

                b.MouseEnter:Connect(function()
                    tw(b,  {BackgroundColor3 = C.ELEM_H}, 0.08)
                    tw(st, {Color = C.ELEM_STR_H, Transparency = 0.6}, 0.08)
                end)
                b.MouseLeave:Connect(function()
                    tw(b,  {BackgroundColor3 = C.ELEM}, 0.08)
                    tw(st, {Color = C.ELEM_STR, Transparency = 0}, 0.08)
                end)
                return b
            end

            -- Título principal do elemento
            local function mkTitle(parent, text, rightOff)
                local l = Instance.new("TextLabel")
                l.Size                 = UDim2.new(1, -(rightOff or 80), 0, 20)
                l.Position             = UDim2.new(0, 12, 0, 8)
                l.BackgroundTransparency = 1
                l.Text                 = text or ""
                l.TextSize             = 13
                l.Font                 = Enum.Font.GothamBold
                l.TextColor3           = C.TXT
                l.TextXAlignment       = Enum.TextXAlignment.Left
                l.TextTruncate         = Enum.TextTruncate.AtEnd
                l.ZIndex               = 6
                l.Parent               = parent
                return l
            end

            -- Descrição
            local function mkDesc(parent, text, rightOff)
                local l = Instance.new("TextLabel")
                l.Size                 = UDim2.new(1, -(rightOff or 80), 0, 16)
                l.Position             = UDim2.new(0, 12, 0, 30)
                l.BackgroundTransparency = 1
                l.Text                 = text or ""
                l.TextSize             = 11
                l.Font                 = Enum.Font.Gotham
                l.TextColor3           = C.TXT_DIM
                l.TextXAlignment       = Enum.TextXAlignment.Left
                l.TextTruncate         = Enum.TextTruncate.AtEnd
                l.ZIndex               = 6
                l.Parent               = parent
                return l
            end

            -- Badge arredondado (para toggle/textbox/etc)
            local function mkBadge(parent, w, h, xOff)
                local bg = Instance.new("Frame")
                bg.Size             = UDim2.new(0, w or 38, 0, h or 38)
                bg.Position         = UDim2.new(1, -(xOff or (w or 38) + 10), 0.5, -((h or 38)/2))
                bg.BackgroundColor3 = C.BADGE_BG
                bg.BorderSizePixel  = 0
                bg.ZIndex           = 7
                bg.Parent           = parent
                corner(bg, 8)
                newStroke(bg, C.BADGE_STR, 1)
                gradient(bg,
                    Color3.fromRGB(26, 26, 36),
                    Color3.fromRGB(18, 18, 26), 135)
                return bg
            end

            ------------------------------------------------------------
            -- NewToggle
            ------------------------------------------------------------
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local on = false
                local dispName = (name:match("^・?(.+)$") or name)

                local row = mkElemBtn(EH)
                mkTitle(row, dispName, 58)
                mkDesc(row, tip or "", 58)

                -- Checkbox com detalhes
                local checkBg = mkBadge(row, 36, 36, 46)
                corner(checkBg, 9)

                -- Ícone X (off)
                local offMark = lbl(checkBg, "✕", 13, C.TXT_DIM,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 9)
                offMark.Size     = UDim2.new(1,0,1,0)
                offMark.TextYAlignment = Enum.TextYAlignment.Center

                -- Checkmark (on)
                local checkMark = lbl(checkBg, "✓", 16, C.TOG_CHECK,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 10)
                checkMark.Size             = UDim2.new(1,0,1,0)
                checkMark.TextYAlignment   = Enum.TextYAlignment.Center
                checkMark.TextTransparency = 1

                -- Pequeno ponto indicador no canto
                local dot = Instance.new("Frame")
                dot.Size             = UDim2.new(0, 6, 0, 6)
                dot.Position         = UDim2.new(1, -2, 0, -2)
                dot.BackgroundColor3 = C.TXT_DIM
                dot.BackgroundTransparency = 0.3
                dot.BorderSizePixel  = 0
                dot.ZIndex           = 11
                dot.Parent           = row
                corner(dot, 3)

                local function setState(v)
                    on = v
                    if on then
                        tw(checkBg,  {BackgroundColor3 = C.TOG_ON},  0.15)
                        tw(checkMark,{TextTransparency = 0}, 0.12)
                        tw(offMark,  {TextTransparency = 1}, 0.1)
                        tw(dot,      {BackgroundColor3 = C.SCHEME, BackgroundTransparency = 0}, 0.12)
                        newStroke(checkBg, C.SCHEME, 1)
                    else
                        tw(checkBg,  {BackgroundColor3 = C.TOG_OFF}, 0.15)
                        tw(checkMark,{TextTransparency = 1}, 0.12)
                        tw(offMark,  {TextTransparency = 0}, 0.1)
                        tw(dot,      {BackgroundColor3 = C.TXT_DIM, BackgroundTransparency = 0.3}, 0.12)
                        newStroke(checkBg, C.BADGE_STR, 1)
                    end
                end

                row.MouseButton1Click:Connect(function()
                    setState(not on); pcall(callback, on)
                end)

                local T = {}
                function T:UpdateToggle(a, b)
                    local v = (typeof(a)=="boolean") and a or (typeof(b)=="boolean") and b or nil
                    if v ~= nil then setState(v) end
                end
                function T:SetToggle(v) setState(v) end
                return T
            end

            ------------------------------------------------------------
            -- NewButton
            ------------------------------------------------------------
            function Section:NewButton(name, tip, callback)
                callback = callback or function() end
                local dispName = (name:match("^・?(.+)$") or name)

                local row = mkElemBtn(EH_SM + 8)

                -- Ícone de botão (►)
                local btnIcon = lbl(row, "▶", 10, C.SCHEME,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 7)
                btnIcon.Size     = UDim2.new(0, 18, 1, 0)
                btnIcon.Position = UDim2.new(0, 8, 0, 0)
                btnIcon.TextYAlignment = Enum.TextYAlignment.Center

                local nl = lbl(row, dispName, 12, C.TXT,
                    Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
                nl.Size     = UDim2.new(1, -32, 1, 0)
                nl.Position = UDim2.new(0, 26, 0, 0)
                nl.TextYAlignment = Enum.TextYAlignment.Center

                -- Linha accent inferior
                local bLine = Instance.new("Frame")
                bLine.Size             = UDim2.new(0, 0, 0, 2)
                bLine.Position         = UDim2.new(0, 0, 1, -2)
                bLine.BackgroundColor3 = C.SCHEME
                bLine.BorderSizePixel  = 0
                bLine.ZIndex           = 7
                bLine.Parent           = row
                corner(bLine, 2)

                -- Ícone ► animado
                row.MouseEnter:Connect(function()
                    tw(bLine,   {Size = UDim2.new(1,0,0,2)},    0.14)
                    tw(nl,      {TextColor3 = C.SCHEME},         0.1)
                    tw(btnIcon, {TextColor3 = Color3.fromRGB(180,255,100)}, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    tw(bLine,   {Size = UDim2.new(0,0,0,2)},    0.12)
                    tw(nl,      {TextColor3 = C.TXT},            0.1)
                    tw(btnIcon, {TextColor3 = C.SCHEME},         0.1)
                end)
                row.MouseButton1Click:Connect(function()
                    -- Flash ao clicar
                    tw(row, {BackgroundColor3 = Color3.fromRGB(35,50,28)}, 0.06)
                    task.delay(0.1, function()
                        tw(row, {BackgroundColor3 = C.ELEM}, 0.1)
                    end)
                    pcall(callback)
                end)

                local B = {}
                function B:UpdateButton(t) nl.Text = t or name end
                return B
            end

            ------------------------------------------------------------
            -- NewLabel
            ------------------------------------------------------------
            function Section:NewLabel(text)
                local row = Instance.new("Frame")
                row.Size             = UDim2.new(1, 0, 0, 24)
                row.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                row.BackgroundTransparency = 0.3
                row.BorderSizePixel  = 0
                row.ZIndex           = 5
                row.Parent           = panel
                corner(row, 6)
                newStroke(row, Color3.fromRGB(32,32,42), 1, 0.3)

                -- Ponto decorativo
                local ldot = Instance.new("Frame")
                ldot.Size             = UDim2.new(0, 4, 0, 4)
                ldot.Position         = UDim2.new(0, 8, 0.5, -2)
                ldot.BackgroundColor3 = C.SCHEME
                ldot.BackgroundTransparency = 0.4
                ldot.BorderSizePixel  = 0
                ldot.ZIndex           = 6
                ldot.Parent           = row
                corner(ldot, 2)

                local nl = lbl(row, text, 11, C.TXT_MID,
                    Enum.TextXAlignment.Left, Enum.Font.Gotham, 6)
                nl.Size        = UDim2.new(1, -22, 0, 24)
                nl.Position    = UDim2.new(0, 18, 0, 0)
                nl.TextWrapped = true
                nl.TextYAlignment = Enum.TextYAlignment.Center

                nl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h = math.max(24, nl.TextBounds.Y + 10)
                    row.Size = UDim2.new(1, 0, 0, h)
                    nl.Size  = UDim2.new(1, -22, 0, h)
                end)

                local L = {}
                function L:UpdateLabel(t) nl.Text = t or "" end
                return L
            end

            ------------------------------------------------------------
            -- NewSlider
            ------------------------------------------------------------
            function Section:NewSlider(name, tip, maxV, minV, callback)
                maxV     = tonumber(maxV) or 100
                minV     = tonumber(minV) or 0
                callback = callback or function() end
                local cur = minV
                local dispName = (name:match("^・?(.+)$") or name)

                local row = mkElem(EH + 10)

                -- Título + valor em badge
                local nLbl = lbl(row, dispName, 13, C.TXT,
                    Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
                nLbl.Size     = UDim2.new(0.6, 0, 0, 20)
                nLbl.Position = UDim2.new(0, 12, 0, 7)

                local valBadge = Instance.new("Frame")
                valBadge.Size             = UDim2.new(0, 42, 0, 20)
                valBadge.Position         = UDim2.new(1, -54, 0, 7)
                valBadge.BackgroundColor3 = C.BADGE_BG
                valBadge.BorderSizePixel  = 0
                valBadge.ZIndex           = 7
                valBadge.Parent           = row
                corner(valBadge, 6)
                newStroke(valBadge, C.BADGE_STR, 1)

                local valLbl = lbl(valBadge, tostring(cur), 11, C.BADGE_TXT,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 8)
                valLbl.Size = UDim2.new(1,0,1,0)
                valLbl.TextYAlignment = Enum.TextYAlignment.Center

                -- Faixa mín/máx
                local minLbl = lbl(row, tostring(minV), 9, C.TXT_DIM,
                    Enum.TextXAlignment.Left, Enum.Font.Gotham, 6)
                minLbl.Size     = UDim2.new(0, 30, 0, 12)
                minLbl.Position = UDim2.new(0, 12, 0, 30)

                local maxLbl = lbl(row, tostring(maxV), 9, C.TXT_DIM,
                    Enum.TextXAlignment.Right, Enum.Font.Gotham, 6)
                maxLbl.Size     = UDim2.new(0, 30, 0, 12)
                maxLbl.Position = UDim2.new(1, -42, 0, 30)

                -- Trilho
                local track = Instance.new("Frame")
                track.Size             = UDim2.new(1, -28, 0, 5)
                track.Position         = UDim2.new(0, 14, 0, 46)
                track.BackgroundColor3 = C.SL_TR
                track.BorderSizePixel  = 0
                track.ZIndex           = 6
                track.Parent           = row
                corner(track, 3)
                newStroke(track, Color3.fromRGB(38,38,50), 1)

                local fill = Instance.new("Frame")
                fill.Size             = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = C.SL_FILL
                fill.BorderSizePixel  = 0
                fill.ZIndex           = 7
                fill.Parent           = track
                corner(fill, 3)
                gradient(fill, C.HDR, Color3.fromRGB(40,160,10), 0)

                local handle = Instance.new("Frame")
                handle.Size             = UDim2.new(0, 12, 0, 12)
                handle.AnchorPoint      = Vector2.new(0.5, 0.5)
                handle.Position         = UDim2.new(0, 0, 0.5, 0)
                handle.BackgroundColor3 = Color3.fromRGB(240, 255, 230)
                handle.BorderSizePixel  = 0
                handle.ZIndex           = 9
                handle.Parent           = track
                corner(handle, 6)
                newStroke(handle, C.SCHEME, 1.5, 0.3)

                local grab = Instance.new("TextButton")
                grab.Size               = UDim2.new(1, 0, 0, 26)
                grab.Position           = UDim2.new(0, 0, 0.5, -13)
                grab.BackgroundTransparency = 1
                grab.Text               = ""
                grab.ZIndex             = 10
                grab.Parent             = track

                local mouse   = Players.LocalPlayer:GetMouse()
                local sliding = false

                local function applyX(mx)
                    local tw_ = track.AbsoluteSize.X
                    local rx  = math.clamp(mx - track.AbsolutePosition.X, 0, tw_)
                    local pct = rx / math.max(tw_, 1)
                    cur       = math.floor(minV + (maxV - minV) * pct)
                    fill.Size = UDim2.new(0, rx, 1, 0)
                    handle.Position = UDim2.new(0, rx, 0.5, 0)
                    valLbl.Text = tostring(cur)
                    pcall(callback, cur)
                end

                grab.MouseButton1Down:Connect(function()
                    sliding = true; applyX(mouse.X)
                    tw(handle, {Size = UDim2.new(0,14,0,14)}, 0.08)
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                        tw(handle, {Size = UDim2.new(0,12,0,12)}, 0.08)
                    end
                end)
                mouse.Move:Connect(function() if sliding then applyX(mouse.X) end end)

                local S = {}
                function S:UpdateSlider(v)
                    cur = math.clamp(tonumber(v) or minV, minV, maxV)
                    local pct = (cur - minV) / math.max(maxV - minV, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    handle.Position = UDim2.new(pct, 0, 0.5, 0)
                    valLbl.Text = tostring(cur)
                end
                return S
            end

            ------------------------------------------------------------
            -- NewDropdown
            ------------------------------------------------------------
            function Section:NewDropdown(name, tip, options, callback)
                options  = options  or {}
                callback = callback or function() end
                local isOpen   = false
                local dispName = (name:match("^・?(.+)$") or name)

                local outer = Instance.new("Frame")
                outer.Name             = "DD"
                outer.Size             = UDim2.new(1, 0, 0, EH)
                outer.BackgroundColor3 = C.ELEM
                outer.BorderSizePixel  = 0
                outer.ClipsDescendants = true
                outer.ZIndex           = 6
                outer.Parent           = panel
                corner(outer, 8)
                local outerStr = newStroke(outer, C.ELEM_STR, 1)
                gradient(outer,
                    Color3.fromRGB(26, 26, 34),
                    Color3.fromRGB(18, 18, 24), 180)

                local dHead = Instance.new("TextButton")
                dHead.Size               = UDim2.new(1, 0, 0, EH)
                dHead.BackgroundTransparency = 1
                dHead.BorderSizePixel    = 0
                dHead.AutoButtonColor    = false
                dHead.Text               = ""
                dHead.ZIndex             = 7
                dHead.Parent             = outer

                mkTitle(dHead, dispName, 60)
                mkDesc(dHead, tip or "", 60)

                -- Badge com seta + valor
                local selBadge = mkBadge(dHead, 48, 28, 56)
                corner(selBadge, 7)

                local selLbl = lbl(selBadge, "▾", 12, C.BADGE_TXT,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 9)
                selLbl.Size = UDim2.new(1,0,1,0)
                selLbl.TextYAlignment = Enum.TextYAlignment.Center

                -- Divisor
                local dDiv = Instance.new("Frame")
                dDiv.Size             = UDim2.new(1, -16, 0, 1)
                dDiv.Position         = UDim2.new(0, 8, 0, EH)
                dDiv.BackgroundColor3 = C.DIV
                dDiv.BorderSizePixel  = 0
                dDiv.ZIndex           = 7
                dDiv.Parent           = outer

                local optBox = Instance.new("Frame")
                optBox.Size             = UDim2.new(1, 0, 0, 0)
                optBox.Position         = UDim2.new(0, 0, 0, EH + 1)
                optBox.BackgroundTransparency = 1
                optBox.BorderSizePixel  = 0
                optBox.ZIndex           = 7
                optBox.Parent           = outer
                local optLL = vlist(optBox, 3)
                pad(optBox, 4, 4, 6, 6)

                local function buildOpts(lst)
                    for _, ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, opt in ipairs(lst) do
                        local ob = Instance.new("TextButton")
                        ob.Size             = UDim2.new(1, 0, 0, 26)
                        ob.BackgroundColor3 = C.OPT
                        ob.BorderSizePixel  = 0
                        ob.AutoButtonColor  = false
                        ob.Text             = "  " .. tostring(opt)
                        ob.Font             = Enum.Font.GothamSemibold
                        ob.TextSize         = 11
                        ob.TextColor3       = C.TXT_MID
                        ob.TextXAlignment   = Enum.TextXAlignment.Left
                        ob.ZIndex           = 9
                        ob.Parent           = optBox
                        corner(ob, 6)

                        ob.MouseEnter:Connect(function()
                            tw(ob, {BackgroundColor3 = C.OPT_H,  TextColor3 = C.TXT},     0.07)
                        end)
                        ob.MouseLeave:Connect(function()
                            tw(ob, {BackgroundColor3 = C.OPT,    TextColor3 = C.TXT_MID}, 0.07)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            local sv = tostring(opt)
                            if #sv > 7 then sv = sv:sub(1,6) .. "." end
                            selLbl.Text = sv
                            isOpen      = false
                            tw(outer, {Size = UDim2.new(1,0,0,EH)}, 0.14)
                            tw(outerStr, {Color = C.ELEM_STR}, 0.1)
                            pcall(callback, opt)
                        end)
                    end
                end
                buildOpts(options)

                dHead.MouseEnter:Connect(function()
                    tw(outer,    {BackgroundColor3 = C.ELEM_H}, 0.08)
                    tw(outerStr, {Color = C.ELEM_STR_H, Transparency = 0.55}, 0.08)
                end)
                dHead.MouseLeave:Connect(function()
                    if not isOpen then
                        tw(outer,    {BackgroundColor3 = C.ELEM}, 0.08)
                        tw(outerStr, {Color = C.ELEM_STR, Transparency = 0}, 0.08)
                    end
                end)
                dHead.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        selLbl.Text = "▴"
                        tw(outerStr, {Color = C.SCHEME, Transparency = 0.3}, 0.1)
                        local oh = optLL.AbsoluteContentSize.Y + 9
                        tw(outer, {Size = UDim2.new(1,0,0, EH + 1 + oh)}, 0.17)
                    else
                        selLbl.Text = "▾"
                        tw(outer, {Size = UDim2.new(1,0,0, EH)}, 0.14)
                        tw(outerStr, {Color = C.ELEM_STR, Transparency = 0}, 0.1)
                    end
                end)

                local D = {}
                function D:Refresh(newList, keep)
                    options = newList or {}
                    if not keep then selLbl.Text = "▾" end
                    buildOpts(options)
                    if isOpen then
                        local oh = optLL.AbsoluteContentSize.Y + 9
                        outer.Size = UDim2.new(1,0,0, EH + 1 + oh)
                    end
                end
                function D:SetSelected(v)
                    local sv = tostring(v)
                    if #sv > 7 then sv = sv:sub(1,6) .. "." end
                    selLbl.Text = sv
                end
                return D
            end

            ------------------------------------------------------------
            -- NewTextBox
            ------------------------------------------------------------
            function Section:NewTextBox(name, tip, callback)
                callback = callback or function() end
                local dispName = (name:match("^・?(.+)$") or name)

                local row = mkElem(EH)
                mkTitle(row, dispName, 90)
                mkDesc(row, tip or "", 90)

                local badgeBg = mkBadge(row, 72, 30, 80)
                corner(badgeBg, 8)
                local badgeStr = newStroke(badgeBg, C.BADGE_STR, 1)

                local tb = Instance.new("TextBox")
                tb.Size                   = UDim2.new(1, -8, 1, 0)
                tb.Position               = UDim2.new(0, 4, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text                   = ""
                tb.PlaceholderText        = "..."
                tb.PlaceholderColor3      = C.TXT_DIM
                tb.Font                   = Enum.Font.GothamBold
                tb.TextSize               = 13
                tb.TextColor3             = C.BADGE_TXT
                tb.TextXAlignment         = Enum.TextXAlignment.Center
                tb.TextYAlignment         = Enum.TextYAlignment.Center
                tb.ClearTextOnFocus       = false
                tb.ZIndex                 = 8
                tb.Parent                 = badgeBg

                tb.Focused:Connect(function()
                    tw(badgeBg,  {BackgroundColor3 = C.ELEM_H}, 0.1)
                    tw(badgeStr, {Color = C.SCHEME, Transparency = 0.2}, 0.1)
                end)
                tb.FocusLost:Connect(function(enter)
                    tw(badgeBg,  {BackgroundColor3 = C.BADGE_BG}, 0.1)
                    tw(badgeStr, {Color = C.BADGE_STR, Transparency = 0}, 0.1)
                    if enter then pcall(callback, tb.Text) end
                end)

                local TX = {}
                function TX:SetText(s) pcall(function() tb.Text = tostring(s or "") end) end
                function TX:GetText() return tb.Text end
                function TX:Clear() tb.Text = "" end
                return TX
            end

            ------------------------------------------------------------
            -- NewKeybind
            ------------------------------------------------------------
            function Section:NewKeybind(name, tip, defaultKey, callback)
                defaultKey = defaultKey or Enum.KeyCode.F
                callback   = callback   or function() end
                local curKey    = defaultKey
                local listening = false
                local dispName  = (name:match("^・?(.+)$") or name)

                local row = mkElemBtn(EH)
                mkTitle(row, dispName, 76)
                mkDesc(row, tip or "", 76)

                local kBg = mkBadge(row, 58, 28, 66)
                corner(kBg, 7)
                local kStr = newStroke(kBg, C.BADGE_STR, 1)

                local kLbl = lbl(kBg, defaultKey.Name, 10, C.BADGE_TXT,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 8)
                kLbl.Size = UDim2.new(1,0,1,0)
                kLbl.TextYAlignment = Enum.TextYAlignment.Center

                row.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    kLbl.Text       = "..."
                    kLbl.TextColor3 = C.TXT_DIM
                    tw(kStr, {Color = C.SCHEME, Transparency = 0.2}, 0.1)
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, gp)
                        if not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
                            curKey          = inp.KeyCode
                            kLbl.Text       = inp.KeyCode.Name
                            kLbl.TextColor3 = C.BADGE_TXT
                            listening       = false
                            tw(kStr, {Color = C.BADGE_STR, Transparency = 0}, 0.1)
                            conn:Disconnect()
                        end
                    end)
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if not gp and not listening and inp.KeyCode == curKey then
                        pcall(callback)
                    end
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
        if _GUI then _GUI.Enabled = not _GUI.Enabled end
    end

    function Window:ChangeColor(propOrTable, color)
        if typeof(propOrTable) == "table" then
            local t = propOrTable
            if t.SchemeColor then
                C.SCHEME = t.SchemeColor; C.SL_FILL = t.SchemeColor
                C.ON = t.SchemeColor; C.TAB_ON = t.SchemeColor
                C.SEC_TXT = t.SchemeColor; C.BTN_ACC = t.SchemeColor
                C.BADGE_TXT = t.SchemeColor; C.TOG_ON = t.SchemeColor
                C.HDR = t.SchemeColor; C.GLOW = t.SchemeColor
            end
            if t.Background   then C.WIN  = t.Background   end
            if t.TextColor    then C.TXT  = t.TextColor    end
            if t.ElementColor then C.ELEM = t.ElementColor end
        elseif typeof(propOrTable) == "string" then
            if propOrTable == "SchemeColor" then
                C.SCHEME = color; C.SL_FILL = color; C.ON = color
                C.TAB_ON = color; C.HDR = color
            elseif propOrTable == "Background"   then C.WIN  = color
            elseif propOrTable == "TextColor"    then C.TXT  = color
            elseif propOrTable == "ElementColor" then C.ELEM = color
            end
        end
    end

    ------------------------------------------------------------------
    -- Dispara a intro → depois mostra a GUI
    ------------------------------------------------------------------
    playIntro(title, function()
        sg.Enabled = true
        -- Animação de entrada: desliza de cima + fade in
        win.Position = UDim2.new(0.5, 0, -0.02, 0)
        win.BackgroundTransparency = 1
        tw(win, {
            Position = UDim2.new(0.5, 0, 0.04, 0),
            BackgroundTransparency = 0
        }, 0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    return Window
end

------------------------------------------------------------------------
-- ToggleUI no Library
------------------------------------------------------------------------
function Library:ToggleUI()
    if _GUI then _GUI.Enabled = not _GUI.Enabled end
end

return Library
