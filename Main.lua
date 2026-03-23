--[[
    ╔══════════════════════════════════════════════════════╗
    ║   PVP Script UI  —  ONION STYLE                     ║
    ║   Sidebar + Content Panel  |  Full API compatível   ║
    ║   Resize inferior  |  Intro animada                 ║
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
local function tween(o, p, t, style, dir)
    TweenService:Create(o,
        TweenInfo.new(t or 0.16,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out), p
    ):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color           = col or Color3.fromRGB(40, 40, 40)
    s.Thickness       = th  or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent          = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
    return u
end

local function list(p, sp, dir)
    local l = Instance.new("UIListLayout")
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.FillDirection       = dir or Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding             = UDim.new(0, sp or 0)
    l.Parent              = p
    return l
end

local function lbl(p, txt, sz, col, xa, font, zi)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text                   = txt  or ""
    t.TextSize               = sz   or 13
    t.TextColor3             = col  or Color3.fromRGB(220, 220, 220)
    t.TextXAlignment         = xa   or Enum.TextXAlignment.Left
    t.Font                   = font or Enum.Font.GothamBold
    t.TextTruncate           = Enum.TextTruncate.AtEnd
    t.ZIndex                 = zi   or 4
    t.Parent                 = p
    return t
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
    -- Header
    HDR        = Color3.fromRGB(100, 220, 60),    -- verde brilhante do header
    HDR_TXT    = Color3.fromRGB(255, 255, 255),   -- texto branco no header
    HDR_CLOSE  = Color3.fromRGB(210, 40, 40),     -- botão X vermelho

    -- Janela / Sidebar
    WIN        = Color3.fromRGB(18, 18, 22),      -- fundo principal escuro
    SIDEBAR    = Color3.fromRGB(22, 22, 28),      -- sidebar esquerda
    CONTENT    = Color3.fromRGB(15, 15, 19),      -- painel direito

    -- Tabs
    TAB_OFF    = Color3.fromRGB(22, 22, 28),      -- tab inativa
    TAB_ON     = Color3.fromRGB(100, 220, 60),    -- tab ativa (verde)
    TAB_TXT_OFF= Color3.fromRGB(130, 130, 145),   -- texto tab inativa
    TAB_TXT_ON = Color3.fromRGB(20, 20, 24),      -- texto tab ativa (escuro)

    -- Seções
    SEC_TXT    = Color3.fromRGB(100, 220, 60),    -- título da seção (verde)

    -- Elementos
    ELEM       = Color3.fromRGB(28, 28, 34),      -- fundo dos elementos
    ELEM_H     = Color3.fromRGB(36, 36, 44),      -- hover dos elementos
    ELEM_STR   = Color3.fromRGB(44, 44, 54),      -- borda dos elementos

    -- Toggle
    TOG_OFF    = Color3.fromRGB(50, 50, 60),      -- toggle OFF
    TOG_ON     = Color3.fromRGB(100, 220, 60),    -- toggle ON (verde)
    TOG_CHECK  = Color3.fromRGB(255, 255, 255),   -- checkmark branco

    -- TextBox / badge
    BADGE_BG   = Color3.fromRGB(28, 28, 36),      -- fundo badge textbox
    BADGE_TXT  = Color3.fromRGB(100, 220, 60),    -- texto badge (verde)
    BADGE_STR  = Color3.fromRGB(55, 55, 68),      -- borda badge

    -- Textos
    TXT        = Color3.fromRGB(235, 235, 240),   -- texto principal
    TXT_DIM    = Color3.fromRGB(100, 100, 115),   -- texto secundário
    TXT_MID    = Color3.fromRGB(160, 160, 175),   -- texto médio

    -- Misc
    DIV        = Color3.fromRGB(36, 36, 44),      -- divisor
    SL_TR      = Color3.fromRGB(36, 36, 46),      -- trilho slider
    SL_FILL    = Color3.fromRGB(100, 220, 60),    -- fill slider
    OPT        = Color3.fromRGB(24, 24, 30),      -- opção dropdown
    OPT_H      = Color3.fromRGB(36, 36, 44),      -- hover dropdown
    INP        = Color3.fromRGB(20, 20, 26),      -- input bg
    SCHEME     = Color3.fromRGB(100, 220, 60),    -- cor de esquema (verde)
    BTN_ACC    = Color3.fromRGB(100, 220, 60),    -- accent botão
    SCROLL     = Color3.fromRGB(100, 220, 60),    -- scrollbar
    ON         = Color3.fromRGB(100, 220, 60),    -- ON
    OFF_BG     = Color3.fromRGB(30, 30, 38),
    ON_BG      = Color3.fromRGB(20, 50, 20),
}

local _GUI       = nil
local _activeTab = nil  -- guarda o botão da tab ativa

------------------------------------------------------------------------
-- INTRO ANIMATION
------------------------------------------------------------------------
local function playIntro(title, onDone)
    local player = Players.LocalPlayer
    local pGui   = player:WaitForChild("PlayerGui")

    -- Screen overlay
    local sg = Instance.new("ScreenGui")
    sg.Name         = "__PVPIntro"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 99998
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = pGui end

    -- Fundo preto total
    local bg = Instance.new("Frame")
    bg.Size             = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BorderSizePixel  = 0
    bg.ZIndex           = 1
    bg.Parent           = sg

    -- Painel central
    local panel = Instance.new("Frame")
    panel.Size             = UDim2.new(0, 0, 0, 0)
    panel.AnchorPoint      = Vector2.new(0.5, 0.5)
    panel.Position         = UDim2.new(0.5, 0, 0.5, 0)
    panel.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    panel.BorderSizePixel  = 0
    panel.ZIndex           = 2
    panel.ClipsDescendants = true
    panel.Parent           = sg
    corner(panel, 16)

    -- Borda verde brilhante
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color       = C.SCHEME
    panelStroke.Thickness   = 2
    panelStroke.Transparency = 0
    panelStroke.Parent      = panel

    -- Linha de scan (efeito de loading)
    local scanLine = Instance.new("Frame")
    scanLine.Size             = UDim2.new(1, 0, 0, 2)
    scanLine.Position         = UDim2.new(0, 0, 0, 0)
    scanLine.BackgroundColor3 = C.SCHEME
    scanLine.BackgroundTransparency = 0.3
    scanLine.BorderSizePixel  = 0
    scanLine.ZIndex           = 10
    scanLine.Parent           = panel

    -- Logo / ícone central (círculo verde)
    local iconCircle = Instance.new("Frame")
    iconCircle.Size             = UDim2.new(0, 0, 0, 0)
    iconCircle.AnchorPoint      = Vector2.new(0.5, 0.5)
    iconCircle.Position         = UDim2.new(0.5, 0, 0.38, 0)
    iconCircle.BackgroundColor3 = C.SCHEME
    iconCircle.BorderSizePixel  = 0
    iconCircle.ZIndex           = 5
    iconCircle.Parent           = panel
    corner(iconCircle, 50)

    -- Símbolo dentro do ícone
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size                 = UDim2.new(1, 0, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text                 = "⚔️"
    iconLbl.TextScaled           = true
    iconLbl.Font                 = Enum.Font.GothamBold
    iconLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    iconLbl.ZIndex               = 6
    iconLbl.Parent               = iconCircle

    -- Título principal
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size                 = UDim2.new(1, -40, 0, 32)
    titleLbl.AnchorPoint          = Vector2.new(0.5, 0)
    titleLbl.Position             = UDim2.new(0.5, 0, 0.58, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                 = "PVP SCRIPT"
    titleLbl.TextSize             = 22
    titleLbl.Font                 = Enum.Font.GothamBold
    titleLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    titleLbl.TextXAlignment       = Enum.TextXAlignment.Center
    titleLbl.TextTransparency     = 1
    titleLbl.ZIndex               = 5
    titleLbl.Parent               = panel

    -- Subtítulo
    local subLbl = Instance.new("TextLabel")
    subLbl.Size                 = UDim2.new(1, -40, 0, 20)
    subLbl.AnchorPoint          = Vector2.new(0.5, 0)
    subLbl.Position             = UDim2.new(0.5, 0, 0.72, 0)
    subLbl.BackgroundTransparency = 1
    subLbl.Text                 = "Blox Fruit  ·  All In One"
    subLbl.TextSize             = 13
    subLbl.Font                 = Enum.Font.GothamSemibold
    subLbl.TextColor3           = C.SCHEME
    subLbl.TextXAlignment       = Enum.TextXAlignment.Center
    subLbl.TextTransparency     = 1
    subLbl.ZIndex               = 5
    subLbl.Parent               = panel

    -- Barra de loading
    local barBg = Instance.new("Frame")
    barBg.Size             = UDim2.new(0.7, 0, 0, 4)
    barBg.AnchorPoint      = Vector2.new(0.5, 0)
    barBg.Position         = UDim2.new(0.5, 0, 0.86, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    barBg.BorderSizePixel  = 0
    barBg.ZIndex           = 5
    barBg.Parent           = panel
    corner(barBg, 3)

    local barFill = Instance.new("Frame")
    barFill.Size             = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = C.SCHEME
    barFill.BorderSizePixel  = 0
    barFill.ZIndex           = 6
    barFill.Parent           = barBg
    corner(barFill, 3)

    -- Texto de status
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size                 = UDim2.new(1, -40, 0, 16)
    statusLbl.AnchorPoint          = Vector2.new(0.5, 0)
    statusLbl.Position             = UDim2.new(0.5, 0, 0.92, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text                 = "Initializing..."
    statusLbl.TextSize             = 11
    statusLbl.Font                 = Enum.Font.Gotham
    statusLbl.TextColor3           = C.TXT_DIM
    statusLbl.TextXAlignment       = Enum.TextXAlignment.Center
    statusLbl.TextTransparency     = 1
    statusLbl.ZIndex               = 5
    statusLbl.Parent               = panel

    -- Partículas de fundo (pontos verdes piscando)
    local particles = {}
    for i = 1, 18 do
        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
        dot.Position         = UDim2.new(math.random()/1, 0, math.random()/1, 0)
        dot.BackgroundColor3 = C.SCHEME
        dot.BackgroundTransparency = math.random(4,8)/10
        dot.BorderSizePixel  = 0
        dot.ZIndex           = 3
        dot.Parent           = bg
        corner(dot, 3)
        particles[i] = dot
    end

    -- Animação das partículas
    local particleConn
    particleConn = RunService.Heartbeat:Connect(function(dt)
        for _, dot in ipairs(particles) do
            local np = dot.Position
            local nx = np.X.Scale + (math.random(-100, 100) / 100000)
            local ny = np.Y.Scale + (math.random(-100, 100) / 100000)
            nx = math.clamp(nx, 0.01, 0.99)
            ny = math.clamp(ny, 0.01, 0.99)
            dot.Position = UDim2.new(nx, 0, ny, 0)
        end
    end)

    -- SEQUÊNCIA DA ANIMAÇÃO
    task.spawn(function()
        -- 1. Painel expande
        tween(panel, {Size = UDim2.new(0, 340, 0, 280)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.55)

        -- 2. Ícone aparece
        tween(iconCircle, {Size = UDim2.new(0, 64, 0, 64)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.3)

        -- 3. Título aparece
        tween(titleLbl, {TextTransparency = 0}, 0.4)
        task.wait(0.15)
        tween(subLbl, {TextTransparency = 0}, 0.35)
        task.wait(0.15)
        tween(statusLbl, {TextTransparency = 0}, 0.3)
        task.wait(0.2)

        -- 4. Scan line desce
        local scanT = TweenService:Create(scanLine,
            TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 1, 0)})
        scanT:Play()

        -- 5. Barra de loading
        local stages = {
            {0.25, "Loading modules..."},
            {0.55, "Setting up combat..."},
            {0.80, "Connecting remotes..."},
            {1.00, "Ready!"},
        }
        for _, stage in ipairs(stages) do
            tween(barFill, {Size = UDim2.new(stage[1], 0, 1, 0)}, 0.32)
            statusLbl.Text = stage[2]
            task.wait(0.35)
        end

        -- 6. Pisca o ícone
        tween(iconCircle, {BackgroundColor3 = Color3.fromRGB(160, 255, 100)}, 0.1)
        task.wait(0.12)
        tween(iconCircle, {BackgroundColor3 = C.SCHEME}, 0.12)
        task.wait(0.15)

        -- 7. Fade out de tudo
        tween(titleLbl,  {TextTransparency = 1}, 0.25)
        tween(subLbl,    {TextTransparency = 1}, 0.22)
        tween(statusLbl, {TextTransparency = 1}, 0.2)
        tween(iconCircle, {BackgroundTransparency = 1}, 0.25)
        task.wait(0.28)

        -- 8. Painel colapsa
        tween(panel, {Size = UDim2.new(0, 0, 0, 0)}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        tween(bg,    {BackgroundTransparency = 1}, 0.35)
        task.wait(0.38)

        -- 9. Limpa partículas e conn
        particleConn:Disconnect()
        sg:Destroy()

        -- 10. Chama callback
        pcall(onDone)
    end)
end

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    -- suporta tanto Color3 quanto tabela de tema
    if typeof(themeColor) == "Color3" then
        C.SCHEME    = themeColor
        C.SL_FILL   = themeColor
        C.ON        = themeColor
        C.TAB_ON    = themeColor
        C.SEC_TXT   = themeColor
        C.BTN_ACC   = themeColor
        C.SCROLL    = themeColor
        C.BADGE_TXT = themeColor
        C.HDR       = themeColor
        C.TOG_ON    = themeColor
    elseif typeof(themeColor) == "table" then
        if themeColor.SchemeColor then
            local sc = themeColor.SchemeColor
            C.SCHEME    = sc; C.SL_FILL   = sc; C.TAB_ON    = sc
            C.SEC_TXT   = sc; C.BTN_ACC   = sc; C.SCROLL    = sc
            C.BADGE_TXT = sc; C.ON        = sc; C.HDR       = sc
            C.TOG_ON    = sc
        end
        if themeColor.Background   then C.WIN     = themeColor.Background   end
        if themeColor.Header       then C.HDR     = themeColor.Header       end
        if themeColor.TextColor    then C.TXT     = themeColor.TextColor    end
        if themeColor.ElementColor then C.ELEM    = themeColor.ElementColor end
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
    sg.Enabled        = false   -- fica oculta até a intro terminar
    pcall(function() sg.Parent = game.CoreGui end)
    _GUI = sg

    ------------------------------------------------------------------
    -- DIMENSÕES
    ------------------------------------------------------------------
    local WIN_W    = 480    -- largura total
    local SIDE_W   = 190    -- largura da sidebar
    local HDR_H    = 64     -- altura do header
    local WIN_H    = 340    -- altura inicial
    local WIN_MIN  = 260    -- altura mínima
    local WIN_MAX  = 700    -- altura máxima
    local EH       = 62     -- altura elemento (com descrição)
    local EH_SM    = 34     -- altura elemento pequeno (label/botão)

    ------------------------------------------------------------------
    -- JANELA PRINCIPAL
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

    -- Sombra externa
    local shadow = Instance.new("ImageLabel")
    shadow.Size  = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.55
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 0
    shadow.Parent = win

    ------------------------------------------------------------------
    -- HEADER  (verde sólido, full-width)
    ------------------------------------------------------------------
    local hdr = Instance.new("Frame")
    hdr.Name             = "Hdr"
    hdr.Size             = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = C.HDR
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 10
    hdr.Parent           = win

    -- Arredondamento só no topo
    corner(hdr, 12)
    -- Patch para quadrar a parte de baixo do header
    local hfix = Instance.new("Frame")
    hfix.Size             = UDim2.new(1, 0, 0, 14)
    hfix.Position         = UDim2.new(0, 0, 1, -14)
    hfix.BackgroundColor3 = C.HDR
    hfix.BorderSizePixel  = 0
    hfix.ZIndex           = 10
    hfix.Parent           = hdr

    -- Ícone (emoji/frame circular)
    local hdrIcon = Instance.new("TextLabel")
    hdrIcon.Size                 = UDim2.new(0, 44, 0, 44)
    hdrIcon.Position             = UDim2.new(0, 14, 0.5, -22)
    hdrIcon.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
    hdrIcon.BackgroundTransparency = 0.9
    hdrIcon.Text                 = "⚔️"
    hdrIcon.TextScaled           = true
    hdrIcon.Font                 = Enum.Font.GothamBold
    hdrIcon.TextColor3           = Color3.fromRGB(255, 255, 255)
    hdrIcon.ZIndex               = 12
    hdrIcon.BorderSizePixel      = 0
    hdrIcon.Parent               = hdr
    corner(hdrIcon, 10)

    -- Título
    local titleLbl = lbl(hdr, title or "PVP SCRIPT", 22,
        Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, Enum.Font.GothamBold, 11)
    titleLbl.Size     = UDim2.new(1, -120, 1, 0)
    titleLbl.Position = UDim2.new(0, 68, 0, 0)
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Botão FECHAR
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size             = UDim2.new(0, 42, 0, 42)
    closeBtn.Position         = UDim2.new(1, -56, 0.5, -21)
    closeBtn.BackgroundColor3 = C.HDR_CLOSE
    closeBtn.BorderSizePixel  = 0
    closeBtn.Text             = "✕"
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.TextSize         = 16
    closeBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    closeBtn.AutoButtonColor  = false
    closeBtn.ZIndex           = 14
    closeBtn.Parent           = hdr
    corner(closeBtn, 10)

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(240, 60, 60)}, 0.08)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundColor3 = C.HDR_CLOSE}, 0.08)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win, {Size = UDim2.new(0, WIN_W, 0, 0)}, 0.2)
        task.delay(0.22, function() sg:Destroy() end)
    end)

    draggable(hdr, win)

    ------------------------------------------------------------------
    -- CORPO (sidebar + conteúdo)
    ------------------------------------------------------------------
    local body = Instance.new("Frame")
    body.Name             = "Body"
    body.Size             = UDim2.new(1, 0, 1, -HDR_H)
    body.Position         = UDim2.new(0, 0, 0, HDR_H)
    body.BackgroundTransparency = 1
    body.BorderSizePixel  = 0
    body.ClipsDescendants = true
    body.ZIndex           = 2
    body.Parent           = win

    -- Arredondamento inferior da janela
    local bodyFix = Instance.new("Frame")
    bodyFix.Size             = UDim2.new(1, 0, 0, 12)
    bodyFix.Position         = UDim2.new(0, 0, 1, -12)
    bodyFix.BackgroundColor3 = C.WIN
    bodyFix.BorderSizePixel  = 0
    bodyFix.ZIndex           = 2
    bodyFix.Parent           = body

    ------------------------------------------------------------------
    -- SIDEBAR ESQUERDA
    ------------------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Name             = "Sidebar"
    sidebar.Size             = UDim2.new(0, SIDE_W, 1, 0)
    sidebar.BackgroundColor3 = C.SIDEBAR
    sidebar.BorderSizePixel  = 0
    sidebar.ZIndex           = 3
    sidebar.Parent           = body

    -- Arredondamento inferior esquerdo
    corner(sidebar, 0)
    local sideCornerFix = Instance.new("Frame")
    sideCornerFix.Size             = UDim2.new(1, 0, 0, 12)
    sideCornerFix.Position         = UDim2.new(0, 0, 0, 0)
    sideCornerFix.BackgroundColor3 = C.SIDEBAR
    sideCornerFix.BorderSizePixel  = 0
    sideCornerFix.ZIndex           = 3
    sideCornerFix.Parent           = sidebar

    -- Lista das tabs
    local sideList = Instance.new("Frame")
    sideList.Size             = UDim2.new(1, 0, 1, -10)
    sideList.Position         = UDim2.new(0, 0, 0, 10)
    sideList.BackgroundTransparency = 1
    sideList.BorderSizePixel  = 0
    sideList.ZIndex           = 4
    sideList.Parent           = sidebar
    list(sideList, 4)
    pad(sideList, 8, 8, 10, 10)

    ------------------------------------------------------------------
    -- PAINEL DIREITO (conteúdo)
    ------------------------------------------------------------------
    local contentPanel = Instance.new("Frame")
    contentPanel.Name             = "Content"
    contentPanel.Size             = UDim2.new(1, -SIDE_W, 1, 0)
    contentPanel.Position         = UDim2.new(0, SIDE_W, 0, 0)
    contentPanel.BackgroundColor3 = C.CONTENT
    contentPanel.BorderSizePixel  = 0
    contentPanel.ZIndex           = 3
    contentPanel.ClipsDescendants = true
    contentPanel.Parent           = body

    -- Linha separadora sidebar/conteúdo
    local sepLine = Instance.new("Frame")
    sepLine.Size             = UDim2.new(0, 1, 1, 0)
    sepLine.BackgroundColor3 = C.DIV
    sepLine.BorderSizePixel  = 0
    sepLine.ZIndex           = 5
    sepLine.Parent           = contentPanel

    -- Título da seção ativa (no topo do painel)
    local secTitleLbl = lbl(contentPanel, "", 18, C.SEC_TXT,
        Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
    secTitleLbl.Size     = UDim2.new(1, -28, 0, 44)
    secTitleLbl.Position = UDim2.new(0, 20, 0, 4)
    secTitleLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- ScrollingFrame do conteúdo
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name                  = "Scroll"
    scroll.Position              = UDim2.new(0, 0, 0, 48)
    scroll.Size                  = UDim2.new(1, 0, 1, -52)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel       = 0
    scroll.ScrollBarThickness    = 3
    scroll.ScrollBarImageColor3  = C.SCROLL
    scroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    scroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    scroll.ClipsDescendants      = true
    scroll.ZIndex                = 4
    scroll.Parent                = contentPanel

    local scrollLL = list(scroll, 6)
    pad(scroll, 8, 14, 12, 12)

    ------------------------------------------------------------------
    -- RESIZE HANDLE (borda inferior)
    ------------------------------------------------------------------
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name             = "ResizeHandle"
    resizeHandle.Size             = UDim2.new(1, -20, 0, 8)
    resizeHandle.Position         = UDim2.new(0, 10, 1, -4)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    resizeHandle.BackgroundTransparency = 0.6
    resizeHandle.BorderSizePixel  = 0
    resizeHandle.AutoButtonColor  = false
    resizeHandle.Text             = ""
    resizeHandle.ZIndex           = 20
    resizeHandle.Parent           = win
    corner(resizeHandle, 4)

    -- 3 pontinhos visuais no handle
    local dotContainer = Instance.new("Frame")
    dotContainer.Size             = UDim2.new(0, 32, 0, 4)
    dotContainer.AnchorPoint      = Vector2.new(0.5, 0.5)
    dotContainer.Position         = UDim2.new(0.5, 0, 0.5, 0)
    dotContainer.BackgroundTransparency = 1
    dotContainer.BorderSizePixel  = 0
    dotContainer.ZIndex           = 21
    dotContainer.Parent           = resizeHandle
    list(dotContainer, 6, Enum.FillDirection.Horizontal)

    for i = 1, 3 do
        local d = Instance.new("Frame")
        d.Size             = UDim2.new(0, 5, 0, 3)
        d.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
        d.BackgroundTransparency = 0.3
        d.BorderSizePixel  = 0
        d.ZIndex           = 22
        d.Parent           = dotContainer
        corner(d, 2)
    end

    -- Lógica de resize
    local resizing = false
    local resizeStart, resizeStartH = nil, nil

    resizeHandle.MouseEnter:Connect(function()
        tween(resizeHandle, {BackgroundTransparency = 0.3}, 0.1)
    end)
    resizeHandle.MouseLeave:Connect(function()
        if not resizing then tween(resizeHandle, {BackgroundTransparency = 0.6}, 0.1) end
    end)

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart  = input.Position.Y
            resizeStartH = win.AbsoluteSize.Y
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    tween(resizeHandle, {BackgroundTransparency = 0.6}, 0.1)
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
                      or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position.Y - resizeStart
            local newH  = math.clamp(resizeStartH + delta, WIN_MIN, WIN_MAX)
            win.Size = UDim2.new(0, WIN_W, 0, newH)
        end
    end)

    ------------------------------------------------------------------
    -- Window:NewTab
    ------------------------------------------------------------------
    local Window     = {}
    local tabPanels  = {}   -- {btn, panel, secTitle}

    -- Ícones padrão por índice
    local defaultIcons = {"🏠","⚔️","📄","</> ","⚙️","🎯","👁","🔧","🥊","💎","🌍","🔄"}
    local tabIndex = 0

    local function showTab(tabData)
        -- Esconde todos
        for _, td in ipairs(tabPanels) do
            td.panel.Visible = false
            -- Reset visual btn
            tween(td.btn, {BackgroundColor3 = C.TAB_OFF}, 0.12)
            tween(td.nameLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.12)
            if td.iconLbl then tween(td.iconLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.12) end
        end
        -- Mostra o selecionado
        tabData.panel.Visible = true
        tween(tabData.btn, {BackgroundColor3 = C.TAB_ON}, 0.15)
        tween(tabData.nameLbl, {TextColor3 = C.TAB_TXT_ON}, 0.12)
        if tabData.iconLbl then tween(tabData.iconLbl, {TextColor3 = C.TAB_TXT_ON}, 0.12) end
        secTitleLbl.Text = tabData.cleanName
        _activeTab = tabData
    end

    function Window:NewTab(tabName)
        tabName = tabName or "Tab"
        tabIndex = tabIndex + 1

        -- Extrai ícone do nome (ex: "🎯・General" → ícone = "🎯", nome = "General")
        local iconStr  = defaultIcons[tabIndex] or "•"
        local cleanName = tabName
        -- tenta pegar emoji + texto do padrão "emoji・Texto"
        local ei, en = tabName:match("^(.-)・(.+)$")
        if ei and en then
            iconStr   = ei
            cleanName = en
        end

        ------------------------------------------------------------
        -- BOTÃO DA TAB (na sidebar)
        ------------------------------------------------------------
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size             = UDim2.new(1, 0, 0, 48)
        tabBtn.BackgroundColor3 = C.TAB_OFF
        tabBtn.BorderSizePixel  = 0
        tabBtn.AutoButtonColor  = false
        tabBtn.Text             = ""
        tabBtn.ZIndex           = 5
        tabBtn.Parent           = sideList
        corner(tabBtn, 10)

        -- Ícone
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size                 = UDim2.new(0, 28, 1, 0)
        tabIcon.Position             = UDim2.new(0, 10, 0, 0)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text                 = iconStr
        tabIcon.TextScaled           = true
        tabIcon.Font                 = Enum.Font.GothamBold
        tabIcon.TextColor3           = C.TAB_TXT_OFF
        tabIcon.TextXAlignment       = Enum.TextXAlignment.Center
        tabIcon.ZIndex               = 6
        tabIcon.Parent               = tabBtn

        -- Nome
        local tabNameLbl = lbl(tabBtn, cleanName, 13, C.TAB_TXT_OFF,
            Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
        tabNameLbl.Size     = UDim2.new(1, -48, 1, 0)
        tabNameLbl.Position = UDim2.new(0, 42, 0, 0)
        tabNameLbl.TextYAlignment = Enum.TextYAlignment.Center

        ------------------------------------------------------------
        -- PAINEL DE CONTEÚDO desta tab (dentro do scroll)
        ------------------------------------------------------------
        local panel = Instance.new("Frame")
        panel.Name             = "Panel_" .. cleanName
        panel.Size             = UDim2.new(1, 0, 0, 0)
        panel.AutomaticSize    = Enum.AutomaticSize.Y
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel  = 0
        panel.Visible          = false
        panel.ZIndex           = 5
        panel.Parent           = scroll
        list(panel, 8)

        -- Registra
        local tabData = {
            btn       = tabBtn,
            panel     = panel,
            nameLbl   = tabNameLbl,
            iconLbl   = tabIcon,
            cleanName = cleanName,
        }
        table.insert(tabPanels, tabData)

        -- Abre essa tab ao clicar
        tabBtn.MouseButton1Click:Connect(function()
            showTab(tabData)
        end)

        -- Hover
        tabBtn.MouseEnter:Connect(function()
            if _activeTab ~= tabData then
                tween(tabBtn, {BackgroundColor3 = C.ELEM_H}, 0.08)
                tween(tabNameLbl, {TextColor3 = C.TXT}, 0.08)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if _activeTab ~= tabData then
                tween(tabBtn, {BackgroundColor3 = C.TAB_OFF}, 0.08)
                tween(tabNameLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.08)
            end
        end)

        -- Abre a primeira tab automaticamente
        if tabIndex == 1 then
            task.defer(function() showTab(tabData) end)
        end

        ------------------------------------------------------------
        -- Tab:NewSection
        ------------------------------------------------------------
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"

            -- Limpa emoji do nome da seção para o título (ex: "🥊・Movement" → "Movement")
            local secClean = secName
            local se, sn = secName:match("^.+・(.+)$")
            if sn then secClean = sn end

            -- Título da seção
            local secHeader = Instance.new("Frame")
            secHeader.Size             = UDim2.new(1, 0, 0, 28)
            secHeader.BackgroundTransparency = 1
            secHeader.BorderSizePixel  = 0
            secHeader.ZIndex           = 5
            secHeader.Parent           = panel

            local secHeaderLbl = lbl(secHeader, secClean, 15, C.SEC_TXT,
                Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
            secHeaderLbl.Size     = UDim2.new(1, 0, 1, 0)
            secHeaderLbl.TextYAlignment = Enum.TextYAlignment.Center

            -- Linha verde abaixo do título
            local secLine = Instance.new("Frame")
            secLine.Size             = UDim2.new(1, 0, 0, 1)
            secLine.Position         = UDim2.new(0, 0, 1, -1)
            secLine.BackgroundColor3 = C.SCHEME
            secLine.BackgroundTransparency = 0.6
            secLine.BorderSizePixel  = 0
            secLine.ZIndex           = 6
            secLine.Parent           = secHeader

            -- Helpers internos
            local Section = {}

            local function mkElem(h)
                local f = Instance.new("Frame")
                f.Size             = UDim2.new(1, 0, 0, h or EH)
                f.BackgroundColor3 = C.ELEM
                f.BorderSizePixel  = 0
                f.ZIndex           = 5
                f.Parent           = panel
                corner(f, 8)
                stroke(f, C.ELEM_STR, 1)
                return f
            end

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
                stroke(b, C.ELEM_STR, 1)
                b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = C.ELEM}, 0.08) end)
                return b
            end

            -- Nome principal do elemento (linha 1: bold grande)
            local function mkTitle(parent, text)
                local l = Instance.new("TextLabel")
                l.Size                 = UDim2.new(1, -90, 0, 22)
                l.Position             = UDim2.new(0, 14, 0, 10)
                l.BackgroundTransparency = 1
                l.Text                 = text or ""
                l.TextSize             = 14
                l.Font                 = Enum.Font.GothamBold
                l.TextColor3           = C.TXT
                l.TextXAlignment       = Enum.TextXAlignment.Left
                l.TextTruncate         = Enum.TextTruncate.AtEnd
                l.ZIndex               = 6
                l.Parent               = parent
                return l
            end

            -- Descrição do elemento (linha 2: menor, cinza)
            local function mkDesc(parent, text)
                local l = Instance.new("TextLabel")
                l.Size                 = UDim2.new(1, -90, 0, 18)
                l.Position             = UDim2.new(0, 14, 0, 32)
                l.BackgroundTransparency = 1
                l.Text                 = text or ""
                l.TextSize             = 12
                l.Font                 = Enum.Font.Gotham
                l.TextColor3           = C.TXT_DIM
                l.TextXAlignment       = Enum.TextXAlignment.Left
                l.TextTruncate         = Enum.TextTruncate.AtEnd
                l.ZIndex               = 6
                l.Parent               = parent
                return l
            end

            --------------------------------------------------------
            -- NewToggle
            --------------------------------------------------------
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local on = false

                -- Extrai emoji + nome do padrão "・Nome"
                local dispName = name:match("^・?(.+)$") or name
                local row = mkElemBtn(EH)

                mkTitle(row, dispName)
                mkDesc(row, tip or "")

                -- Checkbox quadrado (igual ao print)
                local checkBg = Instance.new("Frame")
                checkBg.Size             = UDim2.new(0, 36, 0, 36)
                checkBg.Position         = UDim2.new(1, -50, 0.5, -18)
                checkBg.BackgroundColor3 = C.TOG_OFF
                checkBg.BorderSizePixel  = 0
                checkBg.ZIndex           = 7
                checkBg.Parent           = row
                corner(checkBg, 8)
                stroke(checkBg, C.ELEM_STR, 1)

                local checkMark = lbl(checkBg, "✓", 18, C.TOG_CHECK,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 8)
                checkMark.Size          = UDim2.new(1, 0, 1, 0)
                checkMark.TextYAlignment = Enum.TextYAlignment.Center
                checkMark.TextTransparency = 1

                local function setState(v)
                    on = v
                    if on then
                        tween(checkBg,   {BackgroundColor3 = C.TOG_ON},  0.15)
                        tween(checkMark, {TextTransparency = 0},          0.12)
                        stroke(checkBg, C.TOG_ON, 1)
                    else
                        tween(checkBg,   {BackgroundColor3 = C.TOG_OFF}, 0.15)
                        tween(checkMark, {TextTransparency = 1},          0.12)
                        stroke(checkBg, C.ELEM_STR, 1)
                    end
                end

                row.MouseButton1Click:Connect(function()
                    setState(not on)
                    pcall(callback, on)
                end)

                local T = {}
                function T:UpdateToggle(a, b)
                    local v = (typeof(a) == "boolean") and a or (typeof(b) == "boolean") and b or nil
                    if v ~= nil then setState(v) end
                end
                function T:SetToggle(v) setState(v) end
                return T
            end

            --------------------------------------------------------
            -- NewButton
            --------------------------------------------------------
            function Section:NewButton(name, tip, callback)
                callback = callback or function() end

                local dispName = name:match("^・?(.+)$") or name
                local row = mkElemBtn(EH_SM + 10)

                local nl = lbl(row, dispName, 13, C.TXT,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 6)
                nl.Size     = UDim2.new(1, -16, 1, 0)
                nl.Position = UDim2.new(0, 8, 0, 0)
                nl.TextYAlignment = Enum.TextYAlignment.Center

                -- Linha accent inferior que aparece no hover
                local bLine = Instance.new("Frame")
                bLine.Size             = UDim2.new(0, 0, 0, 2)
                bLine.Position         = UDim2.new(0, 0, 1, -2)
                bLine.BackgroundColor3 = C.SCHEME
                bLine.BorderSizePixel  = 0
                bLine.ZIndex           = 7
                bLine.Parent           = row
                corner(bLine, 2)

                row.MouseEnter:Connect(function()
                    tween(bLine, {Size = UDim2.new(1, 0, 0, 2)}, 0.15)
                    tween(nl,   {TextColor3 = C.SCHEME}, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    tween(bLine, {Size = UDim2.new(0, 0, 0, 2)}, 0.12)
                    tween(nl,   {TextColor3 = C.TXT}, 0.1)
                end)

                row.MouseButton1Click:Connect(function() pcall(callback) end)

                local B = {}
                function B:UpdateButton(t) nl.Text = t or name end
                return B
            end

            --------------------------------------------------------
            -- NewLabel
            --------------------------------------------------------
            function Section:NewLabel(text)
                local row = Instance.new("Frame")
                row.Size             = UDim2.new(1, 0, 0, 28)
                row.BackgroundTransparency = 1
                row.BorderSizePixel  = 0
                row.ZIndex           = 5
                row.Parent           = panel

                local nl = lbl(row, text, 12, C.TXT_DIM,
                    Enum.TextXAlignment.Left, Enum.Font.Gotham, 6)
                nl.Size        = UDim2.new(1, -8, 0, 28)
                nl.Position    = UDim2.new(0, 4, 0, 0)
                nl.TextWrapped = true
                nl.TextYAlignment = Enum.TextYAlignment.Center

                nl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h = math.max(28, nl.TextBounds.Y + 10)
                    row.Size = UDim2.new(1, 0, 0, h)
                    nl.Size  = UDim2.new(1, -8, 0, h)
                end)

                local L = {}
                function L:UpdateLabel(t) nl.Text = t or "" end
                return L
            end

            --------------------------------------------------------
            -- NewSlider
            --------------------------------------------------------
            function Section:NewSlider(name, tip, maxV, minV, callback)
                maxV     = tonumber(maxV) or 100
                minV     = tonumber(minV) or 0
                callback = callback       or function() end
                local cur = minV

                local dispName = name:match("^・?(.+)$") or name
                local row = mkElem(EH + 8)

                local nLbl = lbl(row, dispName .. ": " .. tostring(cur), 14, C.TXT,
                    Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
                nLbl.Size     = UDim2.new(1, -14, 0, 22)
                nLbl.Position = UDim2.new(0, 14, 0, 8)

                local track = Instance.new("Frame")
                track.Size             = UDim2.new(1, -28, 0, 6)
                track.Position         = UDim2.new(0, 14, 0, 42)
                track.BackgroundColor3 = C.SL_TR
                track.BorderSizePixel  = 0
                track.ZIndex           = 6
                track.Parent           = row
                corner(track, 3)

                local fill = Instance.new("Frame")
                fill.Size             = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = C.SL_FILL
                fill.BorderSizePixel  = 0
                fill.ZIndex           = 7
                fill.Parent           = track
                corner(fill, 3)

                local handle = Instance.new("Frame")
                handle.Size             = UDim2.new(0, 12, 0, 12)
                handle.AnchorPoint      = Vector2.new(0.5, 0.5)
                handle.Position         = UDim2.new(0, 0, 0.5, 0)
                handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                handle.BorderSizePixel  = 0
                handle.ZIndex           = 9
                handle.Parent           = track
                corner(handle, 6)

                local grab = Instance.new("TextButton")
                grab.Size               = UDim2.new(1, 0, 0, 28)
                grab.Position           = UDim2.new(0, 0, 0.5, -14)
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
                    nLbl.Text = dispName .. ": " .. tostring(cur)
                    pcall(callback, cur)
                end

                grab.MouseButton1Down:Connect(function() sliding = true; applyX(mouse.X) end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
                end)
                mouse.Move:Connect(function() if sliding then applyX(mouse.X) end end)

                local S = {}
                function S:UpdateSlider(v)
                    cur = math.clamp(tonumber(v) or minV, minV, maxV)
                    local pct = (cur - minV) / math.max(maxV - minV, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    handle.Position = UDim2.new(pct, 0, 0.5, 0)
                    nLbl.Text = dispName .. ": " .. tostring(cur)
                end
                return S
            end

            --------------------------------------------------------
            -- NewDropdown
            --------------------------------------------------------
            function Section:NewDropdown(name, tip, options, callback)
                options  = options  or {}
                callback = callback or function() end
                local isOpen = false

                local dispName = name:match("^・?(.+)$") or name

                -- Frame externo que cresce ao abrir
                local outer = Instance.new("Frame")
                outer.Name             = "DD"
                outer.Size             = UDim2.new(1, 0, 0, EH)
                outer.BackgroundColor3 = C.ELEM
                outer.BorderSizePixel  = 0
                outer.ClipsDescendants = true
                outer.ZIndex           = 6
                outer.Parent           = panel
                corner(outer, 8)
                stroke(outer, C.ELEM_STR, 1)

                -- Cabeçalho clicável
                local dHead = Instance.new("TextButton")
                dHead.Size               = UDim2.new(1, 0, 0, EH)
                dHead.BackgroundTransparency = 1
                dHead.BorderSizePixel    = 0
                dHead.AutoButtonColor    = false
                dHead.Text               = ""
                dHead.ZIndex             = 7
                dHead.Parent             = outer

                -- Título e descrição
                local dTitle = lbl(dHead, dispName, 14, C.TXT,
                    Enum.TextXAlignment.Left, Enum.Font.GothamBold, 8)
                dTitle.Size     = UDim2.new(1, -50, 0, 22)
                dTitle.Position = UDim2.new(0, 14, 0, 10)

                local dTip = lbl(dHead, tip or "", 12, C.TXT_DIM,
                    Enum.TextXAlignment.Left, Enum.Font.Gotham, 8)
                dTip.Size     = UDim2.new(1, -50, 0, 18)
                dTip.Position = UDim2.new(0, 14, 0, 32)

                -- Badge com valor selecionado (igual ao textbox do print)
                local selBadge = Instance.new("Frame")
                selBadge.Size             = UDim2.new(0, 60, 0, 30)
                selBadge.Position         = UDim2.new(1, -74, 0.5, -15)
                selBadge.BackgroundColor3 = C.BADGE_BG
                selBadge.BorderSizePixel  = 0
                selBadge.ZIndex           = 9
                selBadge.Parent           = dHead
                corner(selBadge, 8)
                stroke(selBadge, C.BADGE_STR, 1)

                local selLbl = lbl(selBadge, "▾", 13, C.BADGE_TXT,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 10)
                selLbl.Size = UDim2.new(1, 0, 1, 0)
                selLbl.TextYAlignment = Enum.TextYAlignment.Center

                -- Linha divisória
                local dDiv = Instance.new("Frame")
                dDiv.Size             = UDim2.new(1, -16, 0, 1)
                dDiv.Position         = UDim2.new(0, 8, 0, EH)
                dDiv.BackgroundColor3 = C.DIV
                dDiv.BorderSizePixel  = 0
                dDiv.ZIndex           = 7
                dDiv.Parent           = outer

                -- Caixa de opções
                local optBox = Instance.new("Frame")
                optBox.Size             = UDim2.new(1, 0, 0, 0)
                optBox.Position         = UDim2.new(0, 0, 0, EH + 1)
                optBox.BackgroundTransparency = 1
                optBox.BorderSizePixel  = 0
                optBox.ZIndex           = 7
                optBox.Parent           = outer
                local optLL = list(optBox, 3)
                pad(optBox, 5, 5, 8, 8)

                local function buildOpts(lst)
                    for _, ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, opt in ipairs(lst) do
                        local ob = Instance.new("TextButton")
                        ob.Size             = UDim2.new(1, 0, 0, 30)
                        ob.BackgroundColor3 = C.OPT
                        ob.BorderSizePixel  = 0
                        ob.AutoButtonColor  = false
                        ob.Text             = "  " .. tostring(opt)
                        ob.Font             = Enum.Font.GothamSemibold
                        ob.TextSize         = 12
                        ob.TextColor3       = C.TXT_MID
                        ob.TextXAlignment   = Enum.TextXAlignment.Left
                        ob.ZIndex           = 9
                        ob.Parent           = optBox
                        corner(ob, 6)

                        ob.MouseEnter:Connect(function()
                            tween(ob, {BackgroundColor3 = C.OPT_H}, 0.07)
                            tween(ob, {TextColor3 = C.TXT}, 0.07)
                        end)
                        ob.MouseLeave:Connect(function()
                            tween(ob, {BackgroundColor3 = C.OPT}, 0.07)
                            tween(ob, {TextColor3 = C.TXT_MID}, 0.07)
                        end)

                        ob.MouseButton1Click:Connect(function()
                            local shortOpt = tostring(opt)
                            if #shortOpt > 6 then shortOpt = shortOpt:sub(1,5) .. ".." end
                            selLbl.Text = shortOpt
                            isOpen      = false
                            tween(outer, {Size = UDim2.new(1, 0, 0, EH)}, 0.14)
                            pcall(callback, opt)
                        end)
                    end
                end

                buildOpts(options)

                dHead.MouseEnter:Connect(function() tween(outer, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                dHead.MouseLeave:Connect(function() tween(outer, {BackgroundColor3 = C.ELEM}, 0.08) end)

                dHead.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        selLbl.Text = "▴"
                        local oh = optLL.AbsoluteContentSize.Y + 10
                        tween(outer, {Size = UDim2.new(1, 0, 0, EH + 1 + oh)}, 0.17)
                    else
                        selLbl.Text = "▾"
                        tween(outer, {Size = UDim2.new(1, 0, 0, EH)}, 0.14)
                    end
                end)

                local D = {}
                function D:Refresh(newList, keep)
                    options = newList or {}
                    if not keep then selLbl.Text = "▾" end
                    buildOpts(options)
                    if isOpen then
                        local oh = optLL.AbsoluteContentSize.Y + 10
                        outer.Size = UDim2.new(1, 0, 0, EH + 1 + oh)
                    end
                end
                function D:SetSelected(v)
                    local shortOpt = tostring(v)
                    if #shortOpt > 6 then shortOpt = shortOpt:sub(1,5) .. ".." end
                    selLbl.Text = shortOpt
                end
                return D
            end

            --------------------------------------------------------
            -- NewTextBox
            --------------------------------------------------------
            function Section:NewTextBox(name, tip, callback)
                callback = callback or function() end

                local dispName = name:match("^・?(.+)$") or name
                local row = mkElem(EH)

                mkTitle(row, dispName)
                mkDesc(row, tip or "")

                -- Badge de input (igual ao print: fundo escuro, texto verde, borda)
                local badgeBg = Instance.new("Frame")
                badgeBg.Size             = UDim2.new(0, 68, 0, 34)
                badgeBg.Position         = UDim2.new(1, -82, 0.5, -17)
                badgeBg.BackgroundColor3 = C.BADGE_BG
                badgeBg.BorderSizePixel  = 0
                badgeBg.ZIndex           = 7
                badgeBg.Parent           = row
                corner(badgeBg, 8)
                stroke(badgeBg, C.BADGE_STR, 1)

                local tb = Instance.new("TextBox")
                tb.Size                   = UDim2.new(1, -8, 1, 0)
                tb.Position               = UDim2.new(0, 4, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text                   = ""
                tb.PlaceholderText        = tip or "..."
                tb.PlaceholderColor3      = C.TXT_DIM
                tb.Font                   = Enum.Font.GothamBold
                tb.TextSize               = 14
                tb.TextColor3             = C.BADGE_TXT
                tb.TextXAlignment         = Enum.TextXAlignment.Center
                tb.TextYAlignment         = Enum.TextYAlignment.Center
                tb.ClearTextOnFocus       = false
                tb.ZIndex                 = 8
                tb.Parent                 = badgeBg

                tb.Focused:Connect(function()
                    tween(badgeBg, {BackgroundColor3 = C.ELEM_H}, 0.1)
                    stroke(badgeBg, C.SCHEME, 1)
                end)
                tb.FocusLost:Connect(function(enter)
                    tween(badgeBg, {BackgroundColor3 = C.BADGE_BG}, 0.1)
                    stroke(badgeBg, C.BADGE_STR, 1)
                    if enter then pcall(callback, tb.Text) end
                end)

                local TX = {}
                function TX:SetText(str) pcall(function() tb.Text = tostring(str or "") end) end
                function TX:GetText() return tb.Text end
                function TX:Clear() tb.Text = "" end
                return TX
            end

            --------------------------------------------------------
            -- NewKeybind
            --------------------------------------------------------
            function Section:NewKeybind(name, tip, defaultKey, callback)
                defaultKey = defaultKey or Enum.KeyCode.F
                callback   = callback   or function() end
                local curKey    = defaultKey
                local listening = false

                local dispName = name:match("^・?(.+)$") or name
                local row = mkElemBtn(EH)
                mkTitle(row, dispName)
                mkDesc(row, tip or "")

                local kBg = Instance.new("Frame")
                kBg.Size             = UDim2.new(0, 58, 0, 28)
                kBg.Position         = UDim2.new(1, -72, 0.5, -14)
                kBg.BackgroundColor3 = C.BADGE_BG
                kBg.BorderSizePixel  = 0
                kBg.ZIndex           = 7
                kBg.Parent           = row
                corner(kBg, 7)
                stroke(kBg, C.BADGE_STR, 1)

                local kLbl = lbl(kBg, defaultKey.Name, 11, C.BADGE_TXT,
                    Enum.TextXAlignment.Center, Enum.Font.GothamBold, 8)
                kLbl.Size = UDim2.new(1, 0, 1, 0)
                kLbl.TextYAlignment = Enum.TextYAlignment.Center

                row.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    kLbl.Text       = "..."
                    kLbl.TextColor3 = C.TXT_DIM
                    stroke(kBg, C.SCHEME, 1)
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, gp)
                        if not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
                            curKey          = inp.KeyCode
                            kLbl.Text       = inp.KeyCode.Name
                            kLbl.TextColor3 = C.BADGE_TXT
                            listening       = false
                            stroke(kBg, C.BADGE_STR, 1)
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
    -- Utilitários do Window
    ------------------------------------------------------------------
    function Window:ToggleUI()
        if _GUI then _GUI.Enabled = not _GUI.Enabled end
    end

    function Window:ChangeColor(propOrTable, color)
        if typeof(propOrTable) == "table" then
            local t = propOrTable
            if t.SchemeColor then
                C.SCHEME    = t.SchemeColor; C.SL_FILL   = t.SchemeColor
                C.ON        = t.SchemeColor; C.TAB_ON    = t.SchemeColor
                C.SEC_TXT   = t.SchemeColor; C.BTN_ACC   = t.SchemeColor
                C.BADGE_TXT = t.SchemeColor; C.TOG_ON    = t.SchemeColor
                C.HDR       = t.SchemeColor
            end
            if t.Background   then C.WIN  = t.Background   end
            if t.TextColor    then C.TXT  = t.TextColor    end
            if t.ElementColor then C.ELEM = t.ElementColor end
        elseif typeof(propOrTable) == "string" then
            if propOrTable == "SchemeColor" then
                C.SCHEME    = color; C.SL_FILL = color; C.ON = color
                C.TAB_ON    = color; C.HDR     = color
            elseif propOrTable == "Background"   then C.WIN  = color
            elseif propOrTable == "TextColor"    then C.TXT  = color
            elseif propOrTable == "ElementColor" then C.ELEM = color
            end
        end
    end

    ------------------------------------------------------------------
    -- INTRO → depois mostra a GUI
    ------------------------------------------------------------------
    playIntro(title, function()
        sg.Enabled = true
        -- Animação de entrada da janela
        win.Size = UDim2.new(0, WIN_W, 0, 0)
        win.BackgroundTransparency = 1
        tween(win, {Size = UDim2.new(0, WIN_W, 0, WIN_H), BackgroundTransparency = 0}, 0.4,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    return Window
end

------------------------------------------------------------------------
-- ToggleUI no próprio Library
------------------------------------------------------------------------
function Library:ToggleUI()
    if _GUI then _GUI.Enabled = not _GUI.Enabled end
end

return Library
