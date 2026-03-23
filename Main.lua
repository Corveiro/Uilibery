--[[
    ╔══════════════════════════════════════════════════════════╗
    ║   NIGHT HUB UI  —  Premium Library                      ║
    ║   Sidebar + Content Panel  |  Full API compatível       ║
    ║   Resize Livre (W+H)  |  Intro animada  |  Discord Card ║
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
    s.Color           = col or Color3.fromRGB(50, 50, 60)
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
    t.TextColor3             = col  or Color3.fromRGB(220, 220, 230)
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
-- PALETA — Night Hub (dark azul/cinza com accent azul)
------------------------------------------------------------------------
local C = {
    -- Janela
    WIN        = Color3.fromRGB(28, 30, 38),       -- fundo principal dark
    WIN_STR    = Color3.fromRGB(45, 48, 62),       -- borda da janela

    -- Header
    HDR        = Color3.fromRGB(28, 30, 38),       -- header escuro (sem cor sólida)
    HDR_BOTTOM = Color3.fromRGB(38, 40, 52),       -- linha inferior header
    HDR_TXT    = Color3.fromRGB(255, 255, 255),

    -- Sidebar
    SIDEBAR    = Color3.fromRGB(34, 36, 46),
    SIDE_CAT   = Color3.fromRGB(130, 135, 160),    -- texto categoria

    -- Tabs
    TAB_OFF    = Color3.fromRGB(34, 36, 46),
    TAB_ON     = Color3.fromRGB(50, 130, 240),     -- azul accent
    TAB_H      = Color3.fromRGB(42, 44, 58),
    TAB_TXT_OFF= Color3.fromRGB(160, 165, 185),
    TAB_TXT_ON = Color3.fromRGB(255, 255, 255),

    -- Conteúdo
    CONTENT    = Color3.fromRGB(24, 26, 34),

    -- Seções
    SEC_TXT    = Color3.fromRGB(130, 135, 160),    -- cinza claro (igual print)

    -- Elementos
    ELEM       = Color3.fromRGB(34, 36, 48),
    ELEM_H     = Color3.fromRGB(42, 45, 60),
    ELEM_STR   = Color3.fromRGB(50, 53, 70),

    -- Toggle pill
    TOG_OFF    = Color3.fromRGB(55, 58, 75),
    TOG_ON     = Color3.fromRGB(50, 130, 240),

    -- Badge / inputs
    BADGE_BG   = Color3.fromRGB(40, 43, 58),
    BADGE_TXT  = Color3.fromRGB(200, 205, 225),
    BADGE_STR  = Color3.fromRGB(58, 62, 82),

    -- Textos
    TXT        = Color3.fromRGB(230, 232, 245),
    TXT_DIM    = Color3.fromRGB(110, 115, 140),
    TXT_MID    = Color3.fromRGB(165, 170, 195),
    TXT_ACCENT = Color3.fromRGB(50, 130, 240),     -- azul accent (ACTIVE)

    -- Misc
    DIV        = Color3.fromRGB(45, 48, 65),
    SL_TR      = Color3.fromRGB(45, 48, 65),
    SL_FILL    = Color3.fromRGB(50, 130, 240),
    OPT        = Color3.fromRGB(30, 32, 44),
    OPT_H      = Color3.fromRGB(42, 45, 60),
    SCHEME     = Color3.fromRGB(50, 130, 240),
    SCROLL     = Color3.fromRGB(60, 130, 220),

    -- Botão minimize / close
    BTN_MIN    = Color3.fromRGB(50, 53, 70),
    BTN_CLOSE  = Color3.fromRGB(50, 53, 70),

    -- Discord card
    DISC_BG    = Color3.fromRGB(30, 33, 46),
    DISC_JOIN  = Color3.fromRGB(50, 130, 240),
}

local _GUI       = nil
local _activeTab = nil

------------------------------------------------------------------------
-- INTRO ANIMATION
------------------------------------------------------------------------
local function playIntro(title, onDone)
    local player = Players.LocalPlayer
    local pGui   = player:WaitForChild("PlayerGui")

    local sg = Instance.new("ScreenGui")
    sg.Name           = "__NHIntro"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 99998
    pcall(function() sg.Parent = game.CoreGui end)
    if not sg.Parent then sg.Parent = pGui end

    local bg = Instance.new("Frame")
    bg.Size             = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
    bg.BorderSizePixel  = 0
    bg.ZIndex           = 1
    bg.Parent           = sg

    local panel = Instance.new("Frame")
    panel.Size             = UDim2.new(0, 0, 0, 0)
    panel.AnchorPoint      = Vector2.new(0.5, 0.5)
    panel.Position         = UDim2.new(0.5, 0, 0.5, 0)
    panel.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
    panel.BorderSizePixel  = 0
    panel.ZIndex           = 2
    panel.ClipsDescendants = true
    panel.Parent           = sg
    corner(panel, 18)
    stroke(panel, C.SCHEME, 1.5)

    local scanLine = Instance.new("Frame")
    scanLine.Size             = UDim2.new(1, 0, 0, 2)
    scanLine.Position         = UDim2.new(0, 0, 0, 0)
    scanLine.BackgroundColor3 = C.SCHEME
    scanLine.BackgroundTransparency = 0.4
    scanLine.BorderSizePixel  = 0
    scanLine.ZIndex           = 10
    scanLine.Parent           = panel

    local iconBg = Instance.new("Frame")
    iconBg.Size             = UDim2.new(0, 0, 0, 0)
    iconBg.AnchorPoint      = Vector2.new(0.5, 0.5)
    iconBg.Position         = UDim2.new(0.5, 0, 0.36, 0)
    iconBg.BackgroundColor3 = C.SCHEME
    iconBg.BorderSizePixel  = 0
    iconBg.ZIndex           = 5
    iconBg.Parent           = panel
    corner(iconBg, 50)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size                 = UDim2.new(1, 0, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text                 = "N"
    iconLbl.TextScaled           = true
    iconLbl.Font                 = Enum.Font.GothamBold
    iconLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    iconLbl.ZIndex               = 6
    iconLbl.Parent               = iconBg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size                 = UDim2.new(1, -40, 0, 34)
    titleLbl.AnchorPoint          = Vector2.new(0.5, 0)
    titleLbl.Position             = UDim2.new(0.5, 0, 0.55, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                 = title or "NIGHT HUB"
    titleLbl.TextSize             = 24
    titleLbl.Font                 = Enum.Font.GothamBold
    titleLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    titleLbl.TextXAlignment       = Enum.TextXAlignment.Center
    titleLbl.TextTransparency     = 1
    titleLbl.ZIndex               = 5
    titleLbl.Parent               = panel

    local subLbl = Instance.new("TextLabel")
    subLbl.Size                 = UDim2.new(1, -40, 0, 20)
    subLbl.AnchorPoint          = Vector2.new(0.5, 0)
    subLbl.Position             = UDim2.new(0.5, 0, 0.70, 0)
    subLbl.BackgroundTransparency = 1
    subLbl.Text                 = "v1.0.1 - BETA"
    subLbl.TextSize             = 12
    subLbl.Font                 = Enum.Font.GothamSemibold
    subLbl.TextColor3           = C.SCHEME
    subLbl.TextXAlignment       = Enum.TextXAlignment.Center
    subLbl.TextTransparency     = 1
    subLbl.ZIndex               = 5
    subLbl.Parent               = panel

    local barBg = Instance.new("Frame")
    barBg.Size             = UDim2.new(0.65, 0, 0, 3)
    barBg.AnchorPoint      = Vector2.new(0.5, 0)
    barBg.Position         = UDim2.new(0.5, 0, 0.85, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
    barBg.BorderSizePixel  = 0
    barBg.ZIndex           = 5
    barBg.Parent           = panel
    corner(barBg, 2)

    local barFill = Instance.new("Frame")
    barFill.Size             = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = C.SCHEME
    barFill.BorderSizePixel  = 0
    barFill.ZIndex           = 6
    barFill.Parent           = barBg
    corner(barFill, 2)

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size                 = UDim2.new(1, -40, 0, 16)
    statusLbl.AnchorPoint          = Vector2.new(0.5, 0)
    statusLbl.Position             = UDim2.new(0.5, 0, 0.91, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text                 = "Initializing..."
    statusLbl.TextSize             = 11
    statusLbl.Font                 = Enum.Font.Gotham
    statusLbl.TextColor3           = C.TXT_DIM
    statusLbl.TextXAlignment       = Enum.TextXAlignment.Center
    statusLbl.TextTransparency     = 1
    statusLbl.ZIndex               = 5
    statusLbl.Parent               = panel

    -- Partículas flutuantes
    local particles = {}
    for i = 1, 14 do
        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, math.random(2,3), 0, math.random(2,3))
        dot.Position         = UDim2.new(math.random()/1, 0, math.random()/1, 0)
        dot.BackgroundColor3 = C.SCHEME
        dot.BackgroundTransparency = math.random(5,8)/10
        dot.BorderSizePixel  = 0
        dot.ZIndex           = 3
        dot.Parent           = bg
        corner(dot, 3)
        particles[i] = dot
    end
    local pConn = RunService.Heartbeat:Connect(function()
        for _, d in ipairs(particles) do
            local np = d.Position
            local nx = math.clamp(np.X.Scale + (math.random(-100,100)/120000), 0.01, 0.99)
            local ny = math.clamp(np.Y.Scale + (math.random(-100,100)/120000), 0.01, 0.99)
            d.Position = UDim2.new(nx, 0, ny, 0)
        end
    end)

    task.spawn(function()
        tween(panel, {Size = UDim2.new(0, 320, 0, 260)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.5)
        tween(iconBg, {Size = UDim2.new(0, 60, 0, 60)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.28)
        tween(titleLbl,  {TextTransparency = 0}, 0.35)
        task.wait(0.12)
        tween(subLbl,    {TextTransparency = 0}, 0.3)
        task.wait(0.12)
        tween(statusLbl, {TextTransparency = 0}, 0.28)
        task.wait(0.18)

        TweenService:Create(scanLine, TweenInfo.new(0.7, Enum.EasingStyle.Linear),
            {Position = UDim2.new(0, 0, 1, 0)}):Play()

        local stages = {
            {0.3,  "Loading modules..."},
            {0.6,  "Connecting remotes..."},
            {0.85, "Applying settings..."},
            {1.0,  "Ready!"},
        }
        for _, s in ipairs(stages) do
            tween(barFill, {Size = UDim2.new(s[1], 0, 1, 0)}, 0.3)
            statusLbl.Text = s[2]
            task.wait(0.33)
        end

        tween(iconBg, {BackgroundColor3 = Color3.fromRGB(100, 180, 255)}, 0.1)
        task.wait(0.12)
        tween(iconBg, {BackgroundColor3 = C.SCHEME}, 0.12)
        task.wait(0.15)

        tween(titleLbl,  {TextTransparency = 1}, 0.22)
        tween(subLbl,    {TextTransparency = 1}, 0.2)
        tween(statusLbl, {TextTransparency = 1}, 0.18)
        tween(iconBg,    {BackgroundTransparency = 1}, 0.22)
        task.wait(0.26)

        tween(panel, {Size = UDim2.new(0, 0, 0, 0)}, 0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        tween(bg,    {BackgroundTransparency = 1}, 0.32)
        task.wait(0.36)

        pConn:Disconnect()
        sg:Destroy()
        pcall(onDone)
    end)
end

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    if typeof(themeColor) == "Color3" then
        C.SCHEME = themeColor; C.SL_FILL = themeColor; C.TAB_ON = themeColor
        C.TXT_ACCENT = themeColor; C.DISC_JOIN = themeColor; C.SCROLL = themeColor
    elseif typeof(themeColor) == "table" then
        if themeColor.SchemeColor then
            local sc = themeColor.SchemeColor
            C.SCHEME = sc; C.SL_FILL = sc; C.TAB_ON = sc
            C.TXT_ACCENT = sc; C.DISC_JOIN = sc; C.SCROLL = sc
        end
        if themeColor.Background   then C.WIN     = themeColor.Background   end
        if themeColor.TextColor    then C.TXT     = themeColor.TextColor    end
        if themeColor.ElementColor then C.ELEM    = themeColor.ElementColor end
    end

    pcall(function()
        for _, v in ipairs(game.CoreGui:GetChildren()) do
            if v.Name == "__NHLib" then v:Destroy() end
        end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name           = "__NHLib"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 9999
    sg.Enabled        = false
    pcall(function() sg.Parent = game.CoreGui end)
    _GUI = sg

    --------------------------------------------------------------------
    -- DIMENSÕES
    --------------------------------------------------------------------
    local WIN_W    = 650
    local SIDE_W   = 180
    local HDR_H    = 52
    local WIN_H    = 430
    local WIN_MIN_H = 280
    local WIN_MAX_H = 820
    local WIN_MIN_W = 440
    local WIN_MAX_W = 1080
    local EH       = 70    -- altura elemento duplo (nome + desc)
    local EH_SM    = 44    -- altura elemento simples

    --------------------------------------------------------------------
    -- JANELA PRINCIPAL
    --------------------------------------------------------------------
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
    stroke(win, C.WIN_STR, 1)

    -- Sombra externa
    local shadow = Instance.new("ImageLabel")
    shadow.Size  = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.45
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 0
    shadow.Parent = win

    --------------------------------------------------------------------
    -- HEADER  (dark, linha separadora embaixo)
    --------------------------------------------------------------------
    local hdr = Instance.new("Frame")
    hdr.Name             = "Hdr"
    hdr.Size             = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = C.WIN
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 10
    hdr.Parent           = win
    corner(hdr, 12)

    -- patch inferior para fechar o canto arredondado do header
    local hPatch = Instance.new("Frame")
    hPatch.Size             = UDim2.new(1, 0, 0, 14)
    hPatch.Position         = UDim2.new(0, 0, 1, -14)
    hPatch.BackgroundColor3 = C.WIN
    hPatch.BorderSizePixel  = 0
    hPatch.ZIndex           = 10
    hPatch.Parent           = hdr

    -- Linha separadora inferior do header
    local hdrLine = Instance.new("Frame")
    hdrLine.Size             = UDim2.new(1, 0, 0, 1)
    hdrLine.Position         = UDim2.new(0, 0, 1, -1)
    hdrLine.BackgroundColor3 = C.WIN_STR
    hdrLine.BorderSizePixel  = 0
    hdrLine.ZIndex           = 11
    hdrLine.Parent           = hdr

    -- Título "Night Hub" — dois estilos (bold + lighter)
    local titleMain = Instance.new("TextLabel")
    titleMain.Size                 = UDim2.new(0, 72, 1, 0)
    titleMain.Position             = UDim2.new(0, 16, 0, 0)
    titleMain.BackgroundTransparency = 1
    titleMain.Text                 = "Night"
    titleMain.TextSize             = 18
    titleMain.Font                 = Enum.Font.GothamBold
    titleMain.TextColor3           = Color3.fromRGB(255, 255, 255)
    titleMain.TextXAlignment       = Enum.TextXAlignment.Left
    titleMain.TextYAlignment       = Enum.TextYAlignment.Center
    titleMain.ZIndex               = 12
    titleMain.Parent               = hdr

    local titleSub = Instance.new("TextLabel")
    titleSub.Size                 = UDim2.new(0, 50, 1, 0)
    titleSub.Position             = UDim2.new(0, 86, 0, 0)
    titleSub.BackgroundTransparency = 1
    titleSub.Text                 = "Hub"
    titleSub.TextSize             = 18
    titleSub.Font                 = Enum.Font.Gotham
    titleSub.TextColor3           = Color3.fromRGB(200, 205, 220)
    titleSub.TextXAlignment       = Enum.TextXAlignment.Left
    titleSub.TextYAlignment       = Enum.TextYAlignment.Center
    titleSub.ZIndex               = 12
    titleSub.Parent               = hdr

    -- Badge de versão (azul)
    local verBadge = Instance.new("Frame")
    verBadge.Size             = UDim2.new(0, 82, 0, 22)
    verBadge.Position         = UDim2.new(0, 140, 0.5, -11)
    verBadge.BackgroundColor3 = C.SCHEME
    verBadge.BorderSizePixel  = 0
    verBadge.ZIndex           = 13
    verBadge.Parent           = hdr
    corner(verBadge, 6)

    local verLbl = Instance.new("TextLabel")
    verLbl.Size                 = UDim2.new(1, 0, 1, 0)
    verLbl.BackgroundTransparency = 1
    verLbl.Text                 = "v1.0.1 - BETA"
    verLbl.TextSize             = 10
    verLbl.Font                 = Enum.Font.GothamBold
    verLbl.TextColor3           = Color3.fromRGB(255, 255, 255)
    verLbl.TextXAlignment       = Enum.TextXAlignment.Center
    verLbl.TextYAlignment       = Enum.TextYAlignment.Center
    verLbl.ZIndex               = 14
    verLbl.Parent               = verBadge

    -- Botões direita do header (arrows decorativos + minimize + close)
    -- Arrows decorativos (igual ao print: ">> >> >> >> >> >> >> >> >>")
    local arrowsLbl = Instance.new("TextLabel")
    arrowsLbl.Size                 = UDim2.new(1, -380, 1, 0)
    arrowsLbl.Position             = UDim2.new(0, 235, 0, 0)
    arrowsLbl.BackgroundTransparency = 1
    arrowsLbl.Text                 = ">> >> >> >> >> >> >> >> >>"
    arrowsLbl.TextSize             = 10
    arrowsLbl.Font                 = Enum.Font.GothamBold
    arrowsLbl.TextColor3           = Color3.fromRGB(55, 130, 230)
    arrowsLbl.TextXAlignment       = Enum.TextXAlignment.Left
    arrowsLbl.TextYAlignment       = Enum.TextYAlignment.Center
    arrowsLbl.TextTruncate         = Enum.TextTruncate.AtEnd
    arrowsLbl.ZIndex               = 12
    arrowsLbl.Parent               = hdr

    -- Botão MINIMIZE
    local minBtn = Instance.new("TextButton")
    minBtn.Size             = UDim2.new(0, 28, 0, 28)
    minBtn.Position         = UDim2.new(1, -68, 0.5, -14)
    minBtn.BackgroundColor3 = C.BTN_MIN
    minBtn.BorderSizePixel  = 0
    minBtn.Text             = "—"
    minBtn.Font             = Enum.Font.GothamBold
    minBtn.TextSize         = 12
    minBtn.TextColor3       = Color3.fromRGB(200, 205, 225)
    minBtn.AutoButtonColor  = false
    minBtn.ZIndex           = 14
    minBtn.Parent           = hdr
    corner(minBtn, 6)

    local minimized = false
    local savedH    = WIN_H
    minBtn.MouseEnter:Connect(function() tween(minBtn, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
    minBtn.MouseLeave:Connect(function() tween(minBtn, {BackgroundColor3 = C.BTN_MIN}, 0.08) end)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            savedH = win.AbsoluteSize.Y
            tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, HDR_H + 1)}, 0.22)
        else
            tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, savedH)}, 0.22)
        end
    end)

    -- Botão FECHAR
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size             = UDim2.new(0, 28, 0, 28)
    closeBtn.Position         = UDim2.new(1, -34, 0.5, -14)
    closeBtn.BackgroundColor3 = C.BTN_CLOSE
    closeBtn.BorderSizePixel  = 0
    closeBtn.Text             = "x"
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.TextSize         = 13
    closeBtn.TextColor3       = Color3.fromRGB(200, 205, 225)
    closeBtn.AutoButtonColor  = false
    closeBtn.ZIndex           = 14
    closeBtn.Parent           = hdr
    corner(closeBtn, 6)

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50), TextColor3 = Color3.fromRGB(255,255,255)}, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundColor3 = C.BTN_CLOSE, TextColor3 = Color3.fromRGB(200,205,225)}, 0.1)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, 0), BackgroundTransparency = 1}, 0.2)
        task.delay(0.22, function() sg:Destroy() end)
    end)

    draggable(hdr, win)

    --------------------------------------------------------------------
    -- CORPO
    --------------------------------------------------------------------
    local body = Instance.new("Frame")
    body.Name             = "Body"
    body.Size             = UDim2.new(1, 0, 1, -HDR_H)
    body.Position         = UDim2.new(0, 0, 0, HDR_H)
    body.BackgroundTransparency = 1
    body.BorderSizePixel  = 0
    body.ClipsDescendants = true
    body.ZIndex           = 2
    body.Parent           = win

    --------------------------------------------------------------------
    -- SIDEBAR ESQUERDA
    --------------------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Name             = "Sidebar"
    sidebar.Size             = UDim2.new(0, SIDE_W, 1, 0)
    sidebar.BackgroundColor3 = C.SIDEBAR
    sidebar.BorderSizePixel  = 0
    sidebar.ZIndex           = 3
    sidebar.Parent           = body

    -- linha separadora lateral
    local sideDiv = Instance.new("Frame")
    sideDiv.Size             = UDim2.new(0, 1, 1, 0)
    sideDiv.Position         = UDim2.new(1, -1, 0, 0)
    sideDiv.BackgroundColor3 = C.DIV
    sideDiv.BorderSizePixel  = 0
    sideDiv.ZIndex           = 4
    sideDiv.Parent           = sidebar

    -- ScrollingFrame das tabs
    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Name                  = "SideScroll"
    sideScroll.Size                  = UDim2.new(1, -1, 1, 0)
    sideScroll.Position              = UDim2.new(0, 0, 0, 0)
    sideScroll.BackgroundTransparency = 1
    sideScroll.BorderSizePixel       = 0
    sideScroll.ScrollBarThickness    = 2
    sideScroll.ScrollBarImageColor3  = C.SCROLL
    sideScroll.ScrollBarImageTransparency = 0.4
    sideScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    sideScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    sideScroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    sideScroll.ClipsDescendants      = true
    sideScroll.ElasticBehavior       = Enum.ElasticBehavior.WhenScrollable
    sideScroll.ZIndex                = 4
    sideScroll.Parent                = sidebar

    local sideList = Instance.new("Frame")
    sideList.Size             = UDim2.new(1, 0, 0, 0)
    sideList.AutomaticSize    = Enum.AutomaticSize.Y
    sideList.BackgroundTransparency = 1
    sideList.BorderSizePixel  = 0
    sideList.ZIndex           = 4
    sideList.Parent           = sideScroll
    list(sideList, 2)
    pad(sideList, 8, 8, 8, 8)

    --------------------------------------------------------------------
    -- PAINEL DIREITO (conteúdo)
    --------------------------------------------------------------------
    local contentPanel = Instance.new("Frame")
    contentPanel.Name             = "Content"
    contentPanel.Size             = UDim2.new(1, -SIDE_W, 1, 0)
    contentPanel.Position         = UDim2.new(0, SIDE_W, 0, 0)
    contentPanel.BackgroundColor3 = C.CONTENT
    contentPanel.BorderSizePixel  = 0
    contentPanel.ZIndex           = 3
    contentPanel.ClipsDescendants = true
    contentPanel.Parent           = body

    -- Título da tab ativa (grande, no topo)
    local secTitleLbl = Instance.new("TextLabel")
    secTitleLbl.Size                 = UDim2.new(1, -24, 0, 50)
    secTitleLbl.Position             = UDim2.new(0, 16, 0, 0)
    secTitleLbl.BackgroundTransparency = 1
    secTitleLbl.Text                 = ""
    secTitleLbl.TextSize             = 26
    secTitleLbl.Font                 = Enum.Font.GothamBold
    secTitleLbl.TextColor3           = Color3.fromRGB(240, 242, 255)
    secTitleLbl.TextXAlignment       = Enum.TextXAlignment.Left
    secTitleLbl.TextYAlignment       = Enum.TextYAlignment.Center
    secTitleLbl.ZIndex               = 6
    secTitleLbl.Parent               = contentPanel

    -- ScrollingFrame do conteúdo
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name                  = "Scroll"
    scroll.Position              = UDim2.new(0, 0, 0, 52)
    scroll.Size                  = UDim2.new(1, 0, 1, -56)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel       = 0
    scroll.ScrollBarThickness    = 3
    scroll.ScrollBarImageColor3  = C.SCROLL
    scroll.ScrollBarImageTransparency = 0.3
    scroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    scroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    scroll.ClipsDescendants      = true
    scroll.ZIndex                = 4
    scroll.Parent                = contentPanel

    local scrollLL = list(scroll, 6)
    pad(scroll, 6, 14, 12, 12)

    --------------------------------------------------------------------
    -- RESIZE HANDLES — Bottom + Right + Corner
    --------------------------------------------------------------------
    local resizingBottom, resizingRight, resizingCorner = false, false, false
    local rsX, rsY, rsW, rsH = 0, 0, 0, 0

    local function makeResizeHandle(name, sz, pos, zIdx)
        local h = Instance.new("TextButton")
        h.Name             = name
        h.Size             = sz
        h.Position         = pos
        h.BackgroundColor3 = Color3.fromRGB(55, 58, 78)
        h.BackgroundTransparency = 0.7
        h.BorderSizePixel  = 0
        h.AutoButtonColor  = false
        h.Text             = ""
        h.ZIndex           = zIdx or 20
        h.Parent           = win
        corner(h, 4)
        return h
    end

    local rBottom = makeResizeHandle("ResizeB",
        UDim2.new(1, -22, 0, 7), UDim2.new(0, 11, 1, -3), 20)
    local rRight  = makeResizeHandle("ResizeR",
        UDim2.new(0, 7, 1, -22), UDim2.new(1, -3, 0, 11), 20)
    local rCorner = makeResizeHandle("ResizeC",
        UDim2.new(0, 12, 0, 12), UDim2.new(1, -12, 1, -12), 22)
    rCorner.BackgroundColor3 = C.SCHEME
    rCorner.BackgroundTransparency = 0.55

    -- dots nos handles
    local function addDots(handle, isVert)
        local dc = Instance.new("Frame")
        dc.Size             = isVert and UDim2.new(0, 3, 0, 26) or UDim2.new(0, 26, 0, 3)
        dc.AnchorPoint      = Vector2.new(0.5, 0.5)
        dc.Position         = UDim2.new(0.5, 0, 0.5, 0)
        dc.BackgroundTransparency = 1
        dc.BorderSizePixel  = 0
        dc.ZIndex           = 21
        dc.Parent           = handle
        list(dc, 5, isVert and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal)
        for i = 1, 3 do
            local d = Instance.new("Frame")
            d.Size             = isVert and UDim2.new(0, 3, 0, 4) or UDim2.new(0, 4, 0, 3)
            d.BackgroundColor3 = Color3.fromRGB(170, 175, 200)
            d.BackgroundTransparency = 0.25
            d.BorderSizePixel  = 0
            d.ZIndex           = 22
            d.Parent           = dc
            corner(d, 2)
        end
    end
    addDots(rBottom, false)
    addDots(rRight,  true)

    local function hookResize(handle, doW, doH)
        handle.MouseEnter:Connect(function()
            tween(handle, {BackgroundTransparency = 0.15}, 0.1)
        end)
        handle.MouseLeave:Connect(function()
            tween(handle, {BackgroundTransparency = doW and doH and 0.55 or 0.7}, 0.1)
        end)
        handle.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if doW and doH then resizingCorner = true
                elseif doW     then resizingRight  = true
                else                resizingBottom = true end
                rsX = inp.Position.X; rsY = inp.Position.Y
                rsW = win.AbsoluteSize.X; rsH = win.AbsoluteSize.Y
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then
                        resizingBottom = false; resizingRight = false; resizingCorner = false
                        tween(handle, {BackgroundTransparency = doW and doH and 0.55 or 0.7}, 0.1)
                    end
                end)
            end
        end)
    end
    hookResize(rBottom, false, true)
    hookResize(rRight,  true,  false)
    hookResize(rCorner, true,  true)

    UserInputService.InputChanged:Connect(function(inp)
        if (resizingBottom or resizingRight or resizingCorner)
        and (inp.UserInputType == Enum.UserInputType.MouseMovement
          or inp.UserInputType == Enum.UserInputType.Touch) then
            local dx = inp.Position.X - rsX
            local dy = inp.Position.Y - rsY
            local nW = win.AbsoluteSize.X
            local nH = win.AbsoluteSize.Y
            if resizingRight  or resizingCorner then nW = math.clamp(rsW + dx, WIN_MIN_W, WIN_MAX_W) end
            if resizingBottom or resizingCorner then nH = math.clamp(rsH + dy, WIN_MIN_H, WIN_MAX_H) end
            win.Size = UDim2.new(0, nW, 0, nH)
        end
    end)

    --------------------------------------------------------------------
    -- Window:NewTab
    --------------------------------------------------------------------
    local Window    = {}
    local tabPanels = {}
    local defaultIcons = {"🏠","⚔️","📄","</>","⚙️","🎯","👁","🔧","🥊","💎","🌍","🔄"}
    local tabIndex = 0

    -- Referência para poder usar selLbl no dropdown (resolve bug)
    local _selLbl = nil

    local function showTab(tabData)
        for _, td in ipairs(tabPanels) do
            td.panel.Visible = false
            tween(td.btn, {BackgroundColor3 = C.TAB_OFF}, 0.14)
            tween(td.nameLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.12)
            if td.iconLbl then tween(td.iconLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.12) end
            -- remove indicador lateral
            if td.indicator then
                tween(td.indicator, {BackgroundTransparency = 1}, 0.12)
            end
        end
        tabData.panel.Visible = true
        tween(tabData.btn, {BackgroundColor3 = C.TAB_ON}, 0.16)
        tween(tabData.nameLbl, {TextColor3 = C.TAB_TXT_ON}, 0.12)
        if tabData.iconLbl then tween(tabData.iconLbl, {TextColor3 = C.TAB_TXT_ON}, 0.12) end
        if tabData.indicator then
            tween(tabData.indicator, {BackgroundTransparency = 0}, 0.14)
        end
        secTitleLbl.Text = tabData.cleanName
        _activeTab = tabData
    end

    function Window:NewTab(tabName, categoryName)
        tabName = tabName or "Tab"
        tabIndex = tabIndex + 1

        local iconStr   = defaultIcons[tabIndex] or "•"
        local cleanName = tabName
        local ei, en    = tabName:match("^(.-)・(.+)$")
        if ei and en then iconStr = ei; cleanName = en end

        -- Categoria (label acima do grupo de tabs)
        if categoryName and categoryName ~= "" then
            local catLbl = Instance.new("TextLabel")
            catLbl.Size                 = UDim2.new(1, 0, 0, 26)
            catLbl.BackgroundTransparency = 1
            catLbl.Text                 = string.upper(categoryName)
            catLbl.TextSize             = 10
            catLbl.Font                 = Enum.Font.GothamBold
            catLbl.TextColor3           = C.SIDE_CAT
            catLbl.TextXAlignment       = Enum.TextXAlignment.Left
            catLbl.TextYAlignment       = Enum.TextYAlignment.Center
            catLbl.ZIndex               = 5
            catLbl.Parent               = sideList
            pad(catLbl, 0, 0, 8, 0)
        end

        -- Botão da tab
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size             = UDim2.new(1, 0, 0, 40)
        tabBtn.BackgroundColor3 = C.TAB_OFF
        tabBtn.BorderSizePixel  = 0
        tabBtn.AutoButtonColor  = false
        tabBtn.Text             = ""
        tabBtn.ZIndex           = 5
        tabBtn.Parent           = sideList
        corner(tabBtn, 8)

        -- Indicador lateral esquerdo (barra azul quando ativo)
        local indicator = Instance.new("Frame")
        indicator.Size             = UDim2.new(0, 3, 0.6, 0)
        indicator.AnchorPoint      = Vector2.new(0, 0.5)
        indicator.Position         = UDim2.new(0, 0, 0.5, 0)
        indicator.BackgroundColor3 = C.TAB_ON
        indicator.BackgroundTransparency = 1
        indicator.BorderSizePixel  = 0
        indicator.ZIndex           = 7
        indicator.Parent           = tabBtn
        corner(indicator, 2)

        -- Ícone da tab
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size                 = UDim2.new(0, 26, 1, 0)
        tabIcon.Position             = UDim2.new(0, 10, 0, 0)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text                 = iconStr
        tabIcon.TextScaled           = true
        tabIcon.Font                 = Enum.Font.GothamBold
        tabIcon.TextColor3           = C.TAB_TXT_OFF
        tabIcon.TextXAlignment       = Enum.TextXAlignment.Center
        tabIcon.ZIndex               = 6
        tabIcon.Parent               = tabBtn

        -- Nome da tab
        local tabNameLbl = Instance.new("TextLabel")
        tabNameLbl.Size                 = UDim2.new(1, -44, 1, 0)
        tabNameLbl.Position             = UDim2.new(0, 40, 0, 0)
        tabNameLbl.BackgroundTransparency = 1
        tabNameLbl.Text                 = cleanName
        tabNameLbl.TextSize             = 13
        tabNameLbl.Font                 = Enum.Font.GothamSemibold
        tabNameLbl.TextColor3           = C.TAB_TXT_OFF
        tabNameLbl.TextXAlignment       = Enum.TextXAlignment.Left
        tabNameLbl.TextYAlignment       = Enum.TextYAlignment.Center
        tabNameLbl.ZIndex               = 6
        tabNameLbl.Parent               = tabBtn

        -- Painel de conteúdo desta tab
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

        local tabData = {
            btn       = tabBtn,
            panel     = panel,
            nameLbl   = tabNameLbl,
            iconLbl   = tabIcon,
            indicator = indicator,
            cleanName = cleanName,
        }
        table.insert(tabPanels, tabData)

        tabBtn.MouseButton1Click:Connect(function() showTab(tabData) end)

        tabBtn.MouseEnter:Connect(function()
            if _activeTab ~= tabData then
                tween(tabBtn, {BackgroundColor3 = C.TAB_H}, 0.08)
                tween(tabNameLbl, {TextColor3 = Color3.fromRGB(210,215,235)}, 0.08)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if _activeTab ~= tabData then
                tween(tabBtn, {BackgroundColor3 = C.TAB_OFF}, 0.08)
                tween(tabNameLbl, {TextColor3 = C.TAB_TXT_OFF}, 0.08)
            end
        end)

        if tabIndex == 1 then
            task.defer(function() showTab(tabData) end)
        end

        ----------------------------------------------------------
        -- Tab:NewSection
        ----------------------------------------------------------
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"
            local secClean = secName
            local _, sn = secName:match("^.+・(.+)$")
            if sn then secClean = sn end

            -- Cabeçalho da seção (label cinza claro, igual ao print)
            local secHeader = Instance.new("Frame")
            secHeader.Size             = UDim2.new(1, 0, 0, 30)
            secHeader.BackgroundTransparency = 1
            secHeader.BorderSizePixel  = 0
            secHeader.ZIndex           = 5
            secHeader.Parent           = panel

            local secHLbl = Instance.new("TextLabel")
            secHLbl.Size                 = UDim2.new(1, 0, 1, 0)
            secHLbl.BackgroundTransparency = 1
            secHLbl.Text                 = secClean
            secHLbl.TextSize             = 12
            secHLbl.Font                 = Enum.Font.GothamBold
            secHLbl.TextColor3           = C.SEC_TXT
            secHLbl.TextXAlignment       = Enum.TextXAlignment.Left
            secHLbl.TextYAlignment       = Enum.TextYAlignment.Center
            secHLbl.ZIndex               = 6
            secHLbl.Parent               = secHeader

            -- Linha divisória abaixo
            local secLine = Instance.new("Frame")
            secLine.Size             = UDim2.new(1, 0, 0, 1)
            secLine.Position         = UDim2.new(0, 0, 1, -1)
            secLine.BackgroundColor3 = C.DIV
            secLine.BorderSizePixel  = 0
            secLine.ZIndex           = 6
            secLine.Parent           = secHeader

            local Section = {}

            -- GRID LAYOUT para elementos duplos (2 por linha)
            local currentRow = nil
            local rowCount   = 0

            local function mkRow()
                local r = Instance.new("Frame")
                r.Size             = UDim2.new(1, 0, 0, EH)
                r.BackgroundTransparency = 1
                r.BorderSizePixel  = 0
                r.ZIndex           = 5
                r.Parent           = panel
                local ll = Instance.new("UIListLayout")
                ll.FillDirection       = Enum.FillDirection.Horizontal
                ll.SortOrder           = Enum.SortOrder.LayoutOrder
                ll.Padding             = UDim.new(0, 8)
                ll.Parent              = r
                return r
            end

            -- Elemento individual (metade da linha ou largura total)
            local function mkCell(fullWidth)
                if fullWidth then
                    currentRow = nil; rowCount = 0
                    local f = Instance.new("Frame")
                    f.Size             = UDim2.new(1, 0, 0, EH)
                    f.BackgroundColor3 = C.ELEM
                    f.BorderSizePixel  = 0
                    f.ZIndex           = 5
                    f.Parent           = panel
                    corner(f, 10)
                    stroke(f, C.ELEM_STR, 1)
                    return f
                else
                    if rowCount == 0 or rowCount >= 2 then
                        currentRow = mkRow()
                        rowCount   = 0
                    end
                    rowCount = rowCount + 1
                    local f = Instance.new("Frame")
                    f.Size             = UDim2.new(0.5, rowCount == 2 and -4 or -4, 1, 0)
                    f.BackgroundColor3 = C.ELEM
                    f.BorderSizePixel  = 0
                    f.ZIndex           = 5
                    f.Parent           = currentRow
                    corner(f, 10)
                    stroke(f, C.ELEM_STR, 1)
                    return f
                end
            end

            local function mkCellBtn(fullWidth)
                if fullWidth then
                    currentRow = nil; rowCount = 0
                    local b = Instance.new("TextButton")
                    b.Size             = UDim2.new(1, 0, 0, EH)
                    b.BackgroundColor3 = C.ELEM
                    b.BorderSizePixel  = 0
                    b.AutoButtonColor  = false
                    b.Text             = ""
                    b.ZIndex           = 5
                    b.Parent           = panel
                    corner(b, 10)
                    stroke(b, C.ELEM_STR, 1)
                    b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                    b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = C.ELEM}, 0.08) end)
                    return b
                else
                    if rowCount == 0 or rowCount >= 2 then
                        currentRow = mkRow()
                        rowCount   = 0
                    end
                    rowCount = rowCount + 1
                    local b = Instance.new("TextButton")
                    b.Size             = UDim2.new(0.5, -4, 1, 0)
                    b.BackgroundColor3 = C.ELEM
                    b.BorderSizePixel  = 0
                    b.AutoButtonColor  = false
                    b.Text             = ""
                    b.ZIndex           = 5
                    b.Parent           = currentRow
                    corner(b, 10)
                    stroke(b, C.ELEM_STR, 1)
                    b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                    b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = C.ELEM}, 0.08) end)
                    return b
                end
            end

            -- Ícone quadrado com fundo escuro (igual ao print: ícone à esquerda)
            local function mkIcon(parent, iconTxt, accentCol)
                local iconBg = Instance.new("Frame")
                iconBg.Size             = UDim2.new(0, 38, 0, 38)
                iconBg.Position         = UDim2.new(0, 10, 0.5, -19)
                iconBg.BackgroundColor3 = accentCol or C.SCHEME
                iconBg.BackgroundTransparency = 0.72
                iconBg.BorderSizePixel  = 0
                iconBg.ZIndex           = 7
                iconBg.Parent           = parent
                corner(iconBg, 10)

                local il = Instance.new("TextLabel")
                il.Size                 = UDim2.new(1, 0, 1, 0)
                il.BackgroundTransparency = 1
                il.Text                 = iconTxt or "•"
                il.TextScaled           = true
                il.Font                 = Enum.Font.GothamBold
                il.TextColor3           = accentCol or C.SCHEME
                il.TextXAlignment       = Enum.TextXAlignment.Center
                il.TextYAlignment       = Enum.TextYAlignment.Center
                il.ZIndex               = 8
                il.Parent               = iconBg
                return iconBg
            end

            -- Título + sub (à direita do ícone)
            local function mkTitleSub(parent, titleTxt, subTxt, subCol)
                local tl = Instance.new("TextLabel")
                tl.Size                 = UDim2.new(1, -110, 0, 20)
                tl.Position             = UDim2.new(0, 56, 0, 14)
                tl.BackgroundTransparency = 1
                tl.Text                 = titleTxt or ""
                tl.TextSize             = 14
                tl.Font                 = Enum.Font.GothamBold
                tl.TextColor3           = C.TXT
                tl.TextXAlignment       = Enum.TextXAlignment.Left
                tl.TextTruncate         = Enum.TextTruncate.AtEnd
                tl.ZIndex               = 6
                tl.Parent               = parent

                local sl = Instance.new("TextLabel")
                sl.Size                 = UDim2.new(1, -110, 0, 16)
                sl.Position             = UDim2.new(0, 56, 0, 34)
                sl.BackgroundTransparency = 1
                sl.Text                 = subTxt or ""
                sl.TextSize             = 11
                sl.Font                 = Enum.Font.GothamBold
                sl.TextColor3           = subCol or C.TXT_DIM
                sl.TextXAlignment       = Enum.TextXAlignment.Left
                sl.TextTruncate         = Enum.TextTruncate.AtEnd
                sl.ZIndex               = 6
                sl.Parent               = parent
                return tl, sl
            end

            --------------------------------------------------------
            -- DISCORD CARD  (NewDiscord)
            --------------------------------------------------------
            function Section:NewDiscord(serverName, serverDesc, imageId, inviteUrl)
                currentRow = nil; rowCount = 0
                serverName = serverName or "Discord Server"
                serverDesc = serverDesc or "Join our community!"
                inviteUrl  = inviteUrl  or ""

                -- Container principal
                local card = Instance.new("Frame")
                card.Size             = UDim2.new(1, 0, 0, 0)
                card.AutomaticSize    = Enum.AutomaticSize.Y
                card.BackgroundColor3 = C.DISC_BG
                card.BorderSizePixel  = 0
                card.ZIndex           = 5
                card.Parent           = panel
                corner(card, 10)
                stroke(card, C.ELEM_STR, 1)

                -- Banner/imagem do servidor (se fornecido)
                if imageId and imageId ~= "" then
                    local banner = Instance.new("ImageLabel")
                    banner.Size             = UDim2.new(1, 0, 0, 100)
                    banner.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
                    banner.BorderSizePixel  = 0
                    banner.Image            = "rbxassetid://" .. tostring(imageId)
                    banner.ScaleType        = Enum.ScaleType.Crop
                    banner.ZIndex           = 6
                    banner.Parent           = card
                    corner(banner, 10)

                    -- Patch para quadrar a parte inferior do banner
                    local bannerPatch = Instance.new("Frame")
                    bannerPatch.Size             = UDim2.new(1, 0, 0, 12)
                    bannerPatch.Position         = UDim2.new(0, 0, 1, -12)
                    bannerPatch.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
                    bannerPatch.BorderSizePixel  = 0
                    bannerPatch.ZIndex           = 7
                    bannerPatch.Parent           = banner
                end

                -- Área de info + botão
                local infoRow = Instance.new("Frame")
                infoRow.Size             = UDim2.new(1, 0, 0, 64)
                infoRow.Position         = imageId and imageId ~= "" and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
                infoRow.BackgroundTransparency = 1
                infoRow.BorderSizePixel  = 0
                infoRow.ZIndex           = 6
                infoRow.Parent           = card

                -- Nome do servidor
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size                 = UDim2.new(1, -110, 0, 22)
                nameLbl.Position             = UDim2.new(0, 14, 0, 12)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text                 = serverName
                nameLbl.TextSize             = 15
                nameLbl.Font                 = Enum.Font.GothamBold
                nameLbl.TextColor3           = C.TXT
                nameLbl.TextXAlignment       = Enum.TextXAlignment.Left
                nameLbl.TextTruncate         = Enum.TextTruncate.AtEnd
                nameLbl.ZIndex               = 7
                nameLbl.Parent               = infoRow

                -- Descrição
                local descLbl = Instance.new("TextLabel")
                descLbl.Size                 = UDim2.new(1, -110, 0, 18)
                descLbl.Position             = UDim2.new(0, 14, 0, 34)
                descLbl.BackgroundTransparency = 1
                descLbl.Text                 = serverDesc
                descLbl.TextSize             = 11
                descLbl.Font                 = Enum.Font.Gotham
                descLbl.TextColor3           = C.TXT_DIM
                descLbl.TextXAlignment       = Enum.TextXAlignment.Left
                descLbl.TextTruncate         = Enum.TextTruncate.AtEnd
                descLbl.ZIndex               = 7
                descLbl.Parent               = infoRow
                descLbl.TextWrapped          = true

                -- Botão Join (verde/azul arredondado)
                local joinBtn = Instance.new("TextButton")
                joinBtn.Size             = UDim2.new(0, 70, 0, 34)
                joinBtn.Position         = UDim2.new(1, -82, 0.5, -17)
                joinBtn.BackgroundColor3 = C.DISC_JOIN
                joinBtn.BorderSizePixel  = 0
                joinBtn.Text             = "Join"
                joinBtn.Font             = Enum.Font.GothamBold
                joinBtn.TextSize         = 14
                joinBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
                joinBtn.AutoButtonColor  = false
                joinBtn.ZIndex           = 8
                joinBtn.Parent           = infoRow
                corner(joinBtn, 8)

                joinBtn.MouseEnter:Connect(function()
                    tween(joinBtn, {BackgroundColor3 = Color3.fromRGB(70, 155, 255)}, 0.1)
                end)
                joinBtn.MouseLeave:Connect(function()
                    tween(joinBtn, {BackgroundColor3 = C.DISC_JOIN}, 0.1)
                end)
                joinBtn.MouseButton1Click:Connect(function()
                    if inviteUrl ~= "" then
                        pcall(function()
                            setclipboard(inviteUrl)
                        end)
                    end
                    -- pulso no botão
                    tween(joinBtn, {BackgroundColor3 = Color3.fromRGB(120, 200, 255)}, 0.08)
                    task.delay(0.1, function()
                        tween(joinBtn, {BackgroundColor3 = C.DISC_JOIN}, 0.2)
                    end)
                end)

                return {}
            end

            --------------------------------------------------------
            -- NewToggle  (pill switch, estilo Night Hub)
            --------------------------------------------------------
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local on = false

                local iconChar = "◎"
                local dispName = name:match("^・?(.+)$") or name
                local ei2, en2 = name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar = ei2; dispName = en2 end

                local row = mkCellBtn(false)

                mkIcon(row, iconChar, C.SCHEME)
                local tl, sl = mkTitleSub(row, dispName, tip or "DISABLE", C.TXT_DIM)

                -- Pill switch
                local pillBg = Instance.new("Frame")
                pillBg.Size             = UDim2.new(0, 44, 0, 24)
                pillBg.Position         = UDim2.new(1, -52, 0.5, -12)
                pillBg.BackgroundColor3 = C.TOG_OFF
                pillBg.BorderSizePixel  = 0
                pillBg.ZIndex           = 7
                pillBg.Parent           = row
                corner(pillBg, 12)

                local pillCircle = Instance.new("Frame")
                pillCircle.Size             = UDim2.new(0, 18, 0, 18)
                pillCircle.Position         = UDim2.new(0, 3, 0.5, -9)
                pillCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                pillCircle.BorderSizePixel  = 0
                pillCircle.ZIndex           = 8
                pillCircle.Parent           = pillBg
                corner(pillCircle, 10)

                local function setState(v)
                    on = v
                    if on then
                        tween(pillBg,     {BackgroundColor3 = C.TOG_ON}, 0.16)
                        tween(pillCircle, {Position = UDim2.new(0, 23, 0.5, -9)}, 0.16,
                            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        sl.Text      = "ACTIVE"
                        sl.TextColor3 = C.TXT_ACCENT
                    else
                        tween(pillBg,     {BackgroundColor3 = C.TOG_OFF}, 0.14)
                        tween(pillCircle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.14)
                        sl.Text       = "DISABLE"
                        sl.TextColor3 = C.TXT_DIM
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
                local iconChar = "▶"
                local dispName = name:match("^・?(.+)$") or name
                local ei2, en2 = name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar = ei2; dispName = en2 end

                local row = mkCellBtn(false)
                mkIcon(row, iconChar, C.SCHEME)
                local tl, sl = mkTitleSub(row, dispName, tip or "")

                row.MouseButton1Click:Connect(function()
                    tween(row, {BackgroundColor3 = C.SCHEME}, 0.06)
                    task.delay(0.1, function() tween(row, {BackgroundColor3 = C.ELEM}, 0.14) end)
                    pcall(callback)
                end)

                local B = {}
                function B:UpdateButton(t) tl.Text = t or name end
                return B
            end

            --------------------------------------------------------
            -- NewLabel
            --------------------------------------------------------
            function Section:NewLabel(text)
                currentRow = nil; rowCount = 0
                local row = Instance.new("Frame")
                row.Size             = UDim2.new(1, 0, 0, 28)
                row.BackgroundTransparency = 1
                row.BorderSizePixel  = 0
                row.ZIndex           = 5
                row.Parent           = panel

                local nl = Instance.new("TextLabel")
                nl.Size                 = UDim2.new(1, -8, 0, 28)
                nl.Position             = UDim2.new(0, 4, 0, 0)
                nl.BackgroundTransparency = 1
                nl.Text                 = text or ""
                nl.TextSize             = 12
                nl.Font                 = Enum.Font.Gotham
                nl.TextColor3           = C.TXT_DIM
                nl.TextXAlignment       = Enum.TextXAlignment.Left
                nl.TextYAlignment       = Enum.TextYAlignment.Center
                nl.TextWrapped          = true
                nl.ZIndex               = 6
                nl.Parent               = row

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
                currentRow = nil; rowCount = 0
                maxV     = tonumber(maxV) or 100
                minV     = tonumber(minV) or 0
                callback = callback or function() end
                local cur = minV

                local dispName = name:match("^・?(.+)$") or name
                local row = Instance.new("Frame")
                row.Size             = UDim2.new(1, 0, 0, EH + 10)
                row.BackgroundColor3 = C.ELEM
                row.BorderSizePixel  = 0
                row.ZIndex           = 5
                row.Parent           = panel
                corner(row, 10)
                stroke(row, C.ELEM_STR, 1)

                local nLbl = Instance.new("TextLabel")
                nLbl.Size                 = UDim2.new(1, -14, 0, 22)
                nLbl.Position             = UDim2.new(0, 14, 0, 10)
                nLbl.BackgroundTransparency = 1
                nLbl.Text                 = dispName .. "  " .. tostring(cur)
                nLbl.TextSize             = 14
                nLbl.Font                 = Enum.Font.GothamBold
                nLbl.TextColor3           = C.TXT
                nLbl.TextXAlignment       = Enum.TextXAlignment.Left
                nLbl.ZIndex               = 6
                nLbl.Parent               = row

                local track = Instance.new("Frame")
                track.Size             = UDim2.new(1, -28, 0, 5)
                track.Position         = UDim2.new(0, 14, 0, 46)
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
                handle.Size             = UDim2.new(0, 14, 0, 14)
                handle.AnchorPoint      = Vector2.new(0.5, 0.5)
                handle.Position         = UDim2.new(0, 0, 0.5, 0)
                handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                handle.BorderSizePixel  = 0
                handle.ZIndex           = 9
                handle.Parent           = track
                corner(handle, 8)

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
                    local tw2 = track.AbsoluteSize.X
                    local rx  = math.clamp(mx - track.AbsolutePosition.X, 0, tw2)
                    local pct = rx / math.max(tw2, 1)
                    cur       = math.floor(minV + (maxV - minV) * pct)
                    fill.Size = UDim2.new(0, rx, 1, 0)
                    handle.Position = UDim2.new(0, rx, 0.5, 0)
                    nLbl.Text = dispName .. "  " .. tostring(cur)
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
                    nLbl.Text = dispName .. "  " .. tostring(cur)
                end
                return S
            end

            --------------------------------------------------------
            -- NewDropdown  (corrigido — sem bug de emoji na seta)
            --------------------------------------------------------
            function Section:NewDropdown(name, tip, options, callback)
                currentRow = nil; rowCount = 0
                options  = options  or {}
                callback = callback or function() end
                local isOpen    = false
                local selectedVal = nil

                local iconChar = "≡"
                local dispName = name:match("^・?(.+)$") or name
                local ei2, en2 = name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar = ei2; dispName = en2 end

                -- Frame externo que cresce ao abrir
                local outer = Instance.new("Frame")
                outer.Name             = "DD_" .. dispName
                outer.Size             = UDim2.new(1, 0, 0, EH)
                outer.BackgroundColor3 = C.ELEM
                outer.BorderSizePixel  = 0
                outer.ClipsDescendants = true
                outer.ZIndex           = 6
                outer.Parent           = panel
                corner(outer, 10)
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

                mkIcon(dHead, iconChar, C.SCHEME)

                -- Título e tip
                local dTitle = Instance.new("TextLabel")
                dTitle.Size                 = UDim2.new(1, -130, 0, 22)
                dTitle.Position             = UDim2.new(0, 56, 0, 13)
                dTitle.BackgroundTransparency = 1
                dTitle.Text                 = dispName
                dTitle.TextSize             = 14
                dTitle.Font                 = Enum.Font.GothamBold
                dTitle.TextColor3           = C.TXT
                dTitle.TextXAlignment       = Enum.TextXAlignment.Left
                dTitle.TextTruncate         = Enum.TextTruncate.AtEnd
                dTitle.ZIndex               = 8
                dTitle.Parent               = dHead

                local dSub = Instance.new("TextLabel")
                dSub.Size                 = UDim2.new(1, -130, 0, 16)
                dSub.Position             = UDim2.new(0, 56, 0, 35)
                dSub.BackgroundTransparency = 1
                dSub.Text                 = tip or "Select: -"
                dSub.TextSize             = 11
                dSub.Font                 = Enum.Font.Gotham
                dSub.TextColor3           = C.TXT_DIM
                dSub.TextXAlignment       = Enum.TextXAlignment.Left
                dSub.TextTruncate         = Enum.TextTruncate.AtEnd
                dSub.ZIndex               = 8
                dSub.Parent               = dHead

                -- Botão seta (usa TextLabel, NÃO emoji — sem bug)
                local arrowBox = Instance.new("Frame")
                arrowBox.Size             = UDim2.new(0, 32, 0, 32)
                arrowBox.Position         = UDim2.new(1, -42, 0.5, -16)
                arrowBox.BackgroundColor3 = C.BADGE_BG
                arrowBox.BorderSizePixel  = 0
                arrowBox.ZIndex           = 9
                arrowBox.Parent           = dHead
                corner(arrowBox, 8)
                stroke(arrowBox, C.BADGE_STR, 1)

                local arrowLbl = Instance.new("TextLabel")
                arrowLbl.Size                 = UDim2.new(1, 0, 1, 0)
                arrowLbl.BackgroundTransparency = 1
                arrowLbl.Text                 = "v"
                arrowLbl.Font                 = Enum.Font.GothamBold
                arrowLbl.TextSize             = 13
                arrowLbl.TextColor3           = C.BADGE_TXT
                arrowLbl.TextXAlignment       = Enum.TextXAlignment.Center
                arrowLbl.TextYAlignment       = Enum.TextYAlignment.Center
                arrowLbl.ZIndex               = 10
                arrowLbl.Parent               = arrowBox

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
                optBox.ZIndex           = 8
                optBox.Parent           = outer
                local optLL = list(optBox, 3)
                pad(optBox, 4, 4, 8, 8)

                local function buildOpts(lst)
                    for _, ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, opt in ipairs(lst) do
                        local ob = Instance.new("TextButton")
                        ob.Size             = UDim2.new(1, 0, 0, 32)
                        ob.BackgroundColor3 = C.OPT
                        ob.BorderSizePixel  = 0
                        ob.AutoButtonColor  = false
                        ob.Text             = "  " .. tostring(opt)
                        ob.Font             = Enum.Font.GothamSemibold
                        ob.TextSize         = 13
                        ob.TextColor3       = C.TXT_MID
                        ob.TextXAlignment   = Enum.TextXAlignment.Left
                        ob.ZIndex           = 10
                        ob.Parent           = optBox
                        corner(ob, 6)

                        ob.MouseEnter:Connect(function()
                            tween(ob, {BackgroundColor3 = C.OPT_H, TextColor3 = C.TXT}, 0.07)
                        end)
                        ob.MouseLeave:Connect(function()
                            tween(ob, {BackgroundColor3 = C.OPT, TextColor3 = C.TXT_MID}, 0.07)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            selectedVal = opt
                            -- atualiza label "Select: Valor"
                            local shortV = tostring(opt)
                            if #shortV > 12 then shortV = shortV:sub(1, 11) .. ".." end
                            dSub.Text  = "Select: " .. shortV
                            isOpen     = false
                            arrowLbl.Text = "v"
                            tween(outer, {Size = UDim2.new(1, 0, 0, EH)}, 0.15,
                                Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
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
                        arrowLbl.Text = "^"
                        local oh = optLL.AbsoluteContentSize.Y + 8
                        tween(outer, {Size = UDim2.new(1, 0, 0, EH + 1 + oh)}, 0.18,
                            Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    else
                        arrowLbl.Text = "v"
                        tween(outer, {Size = UDim2.new(1, 0, 0, EH)}, 0.14,
                            Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    end
                end)

                local D = {}
                function D:Refresh(newList, keep)
                    options = newList or {}
                    if not keep then dSub.Text = (tip or "Select: -") end
                    buildOpts(options)
                    if isOpen then
                        local oh = optLL.AbsoluteContentSize.Y + 8
                        outer.Size = UDim2.new(1, 0, 0, EH + 1 + oh)
                    end
                end
                function D:SetSelected(v)
                    selectedVal = v
                    local shortV = tostring(v)
                    if #shortV > 12 then shortV = shortV:sub(1, 11) .. ".." end
                    dSub.Text = "Select: " .. shortV
                end
                function D:GetSelected() return selectedVal end
                return D
            end

            --------------------------------------------------------
            -- NewTextBox
            --------------------------------------------------------
            function Section:NewTextBox(name, tip, callback)
                currentRow = nil; rowCount = 0
                callback = callback or function() end
                local iconChar = "T"
                local dispName = name:match("^・?(.+)$") or name
                local ei2, en2 = name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar = ei2; dispName = en2 end

                local row = Instance.new("Frame")
                row.Size             = UDim2.new(1, 0, 0, EH)
                row.BackgroundColor3 = C.ELEM
                row.BorderSizePixel  = 0
                row.ZIndex           = 5
                row.Parent           = panel
                corner(row, 10)
                stroke(row, C.ELEM_STR, 1)

                mkIcon(row, iconChar, C.SCHEME)
                local tl, _ = mkTitleSub(row, dispName, tip or "")

                local badgeBg = Instance.new("Frame")
                badgeBg.Size             = UDim2.new(0, 80, 0, 34)
                badgeBg.Position         = UDim2.new(1, -90, 0.5, -17)
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
                tb.TextSize               = 13
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

                local iconChar = "K"
                local dispName = name:match("^・?(.+)$") or name
                local ei2, en2 = name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar = ei2; dispName = en2 end

                local row = Instance.new("TextButton")
                row.Size             = UDim2.new(1, 0, 0, EH)
                row.BackgroundColor3 = C.ELEM
                row.BorderSizePixel  = 0
                row.AutoButtonColor  = false
                row.Text             = ""
                row.ZIndex           = 5
                row.Parent           = panel
                corner(row, 10)
                stroke(row, C.ELEM_STR, 1)
                row.MouseEnter:Connect(function() tween(row, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                row.MouseLeave:Connect(function() tween(row, {BackgroundColor3 = C.ELEM}, 0.08) end)

                mkIcon(row, iconChar, C.SCHEME)
                mkTitleSub(row, dispName, tip or "")

                local kBg = Instance.new("Frame")
                kBg.Size             = UDim2.new(0, 62, 0, 30)
                kBg.Position         = UDim2.new(1, -72, 0.5, -15)
                kBg.BackgroundColor3 = C.BADGE_BG
                kBg.BorderSizePixel  = 0
                kBg.ZIndex           = 7
                kBg.Parent           = row
                corner(kBg, 8)
                stroke(kBg, C.BADGE_STR, 1)

                local kLbl = Instance.new("TextLabel")
                kLbl.Size                 = UDim2.new(1, 0, 1, 0)
                kLbl.BackgroundTransparency = 1
                kLbl.Text                 = defaultKey.Name
                kLbl.Font                 = Enum.Font.GothamBold
                kLbl.TextSize             = 12
                kLbl.TextColor3           = C.BADGE_TXT
                kLbl.TextXAlignment       = Enum.TextXAlignment.Center
                kLbl.TextYAlignment       = Enum.TextYAlignment.Center
                kLbl.ZIndex               = 8
                kLbl.Parent               = kBg

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
                C.SCHEME = t.SchemeColor; C.SL_FILL = t.SchemeColor
                C.TAB_ON = t.SchemeColor; C.TXT_ACCENT = t.SchemeColor
                C.DISC_JOIN = t.SchemeColor; C.SCROLL = t.SchemeColor
            end
            if t.Background   then C.WIN  = t.Background   end
            if t.TextColor    then C.TXT  = t.TextColor    end
            if t.ElementColor then C.ELEM = t.ElementColor end
        elseif typeof(propOrTable) == "string" then
            if propOrTable == "SchemeColor" then
                C.SCHEME = color; C.SL_FILL = color; C.TAB_ON = color
                C.TXT_ACCENT = color; C.DISC_JOIN = color
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
        win.Size = UDim2.new(0, WIN_W, 0, 0)
        win.BackgroundTransparency = 1
        tween(win, {Size = UDim2.new(0, WIN_W, 0, WIN_H), BackgroundTransparency = 0}, 0.38,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    return Window
end

------------------------------------------------------------------------
-- ToggleUI global
------------------------------------------------------------------------
function Library:ToggleUI()
    if _GUI then _GUI.Enabled = not _GUI.Enabled end
end

return Library
