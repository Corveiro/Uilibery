--[[
    ╔══════════════════════════════════════════════╗
    ║   UI Library  —  ONION13 Design             ║
    ║   Tabs = Accordion  |  API Preservada       ║
    ║   Toggle: OFF cinza → ON verde  ✓           ║
    ╚══════════════════════════════════════════════╝
--]]

local Library = {}
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

------------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------------
local function tween(o, p, t)
    TweenService:Create(o,
        TweenInfo.new(t or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p
    ):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = p
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color     = col or Color3.fromRGB(45,45,45)
    s.Thickness = th  or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent    = p
end

local function pad(p, t,b,l,r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
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
    t.TextSize               = sz   or 12
    t.TextColor3             = col  or Color3.fromRGB(235,235,235)
    t.TextXAlignment         = xa   or Enum.TextXAlignment.Left
    t.Font                   = font or Enum.Font.GothamSemibold
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
            drag = true  s0 = i.Position  p0 = target.Position
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
-- PALETA — ONION13 pixel-perfect
------------------------------------------------------------------------
local C = {
    -- janela
    WIN      = Color3.fromRGB(24, 24, 24),
    -- header
    HDR      = Color3.fromRGB(11, 11, 11),
    -- ícone laranja (igual ao print)
    ICON     = Color3.fromRGB(210, 140, 30),
    -- X vermelho
    CLOSE    = Color3.fromRGB(205, 38, 38),
    -- botão de tab fechada
    TAB_OFF  = Color3.fromRGB(20, 20, 20),
    -- botão de tab aberta
    TAB_ON   = Color3.fromRGB(28, 28, 28),
    -- fundo dos elementos
    ELEM     = Color3.fromRGB(14, 14, 14),
    -- hover dos elementos
    ELEM_H   = Color3.fromRGB(26, 26, 26),
    -- linha divisória
    DIV      = Color3.fromRGB(36, 36, 36),
    -- trilho do slider
    SL_TR    = Color3.fromRGB(42, 42, 42),
    -- preenchimento do slider (verde)
    SL_FILL  = Color3.fromRGB(68, 190, 68),
    -- texto principal
    TXT      = Color3.fromRGB(232, 232, 232),
    -- texto secundário / OFF
    TXT_DIM  = Color3.fromRGB(135, 135, 135),
    -- ON verde
    ON       = Color3.fromRGB(68, 190, 68),
    -- cor de esquema
    SCHEME   = Color3.fromRGB(68, 190, 68),
    -- opção de dropdown
    OPT      = Color3.fromRGB(20, 20, 20),
    -- input bg
    INP      = Color3.fromRGB(18, 18, 18),
}

local _GUI = nil   -- referência à ScreenGui

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    if typeof(themeColor) == "Color3" then
        C.SCHEME  = themeColor
        C.SL_FILL = themeColor
        C.ON      = themeColor
    end

    -- destruir gui anterior
    pcall(function()
        for _, v in ipairs(game.CoreGui:GetChildren()) do
            if v.Name == "__OLib" then v:Destroy() end
        end
    end)

    -- ── ScreenGui ─────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name           = "__OLib"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 9999
    pcall(function() sg.Parent = game.CoreGui end)
    _GUI = sg

    local W   = 238    -- largura total
    local EH  = 32     -- altura padrão dos elementos
    local MH  = 420    -- altura máxima scroll

    ----------------------------------------------------------------
    -- JANELA PRINCIPAL
    ----------------------------------------------------------------
    local win = Instance.new("Frame")
    win.Name             = "Win"
    win.AnchorPoint      = Vector2.new(0.5, 0)
    win.Position         = UDim2.new(0.5, 0, 0.05, 0)
    win.Size             = UDim2.new(0, W, 0, 30)
    win.BackgroundColor3 = C.WIN
    win.BorderSizePixel  = 0
    win.ClipsDescendants = false
    win.Parent           = sg
    corner(win, 6)
    stroke(win, C.DIV, 1)

    ----------------------------------------------------------------
    -- HEADER  (idêntico ao print: preto, ícone dourado, X vermelho)
    ----------------------------------------------------------------
    local hdr = Instance.new("Frame")
    hdr.Name             = "Hdr"
    hdr.Size             = UDim2.new(1, 0, 0, 30)
    hdr.BackgroundColor3 = C.HDR
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 10
    hdr.Parent           = win
    corner(hdr, 6)

    -- tapa o arredondamento embaixo do header
    local hfix = Instance.new("Frame")
    hfix.Size             = UDim2.new(1, 0, 0, 8)
    hfix.Position         = UDim2.new(0, 0, 1, -8)
    hfix.BackgroundColor3 = C.HDR
    hfix.BorderSizePixel  = 0
    hfix.ZIndex           = 10
    hfix.Parent           = hdr

    -- ícone dourado/laranja (círculo) — igual ao ONION13
    local ico = Instance.new("Frame")
    ico.Size             = UDim2.new(0, 14, 0, 14)
    ico.Position         = UDim2.new(0, 10, 0.5, -7)
    ico.BackgroundColor3 = C.ICON
    ico.BorderSizePixel  = 0
    ico.ZIndex           = 12
    ico.Parent           = hdr
    corner(ico, 7)

    -- brilho interno do ícone
    local icoIn = Instance.new("Frame")
    icoIn.Size             = UDim2.new(0, 6, 0, 6)
    icoIn.Position         = UDim2.new(0, 2, 0, 2)
    icoIn.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    icoIn.BorderSizePixel  = 0
    icoIn.ZIndex           = 13
    icoIn.Parent           = ico
    corner(icoIn, 3)

    -- título centralizado
    local titleLbl = lbl(hdr, title or "UI", 12, C.TXT, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 11)
    titleLbl.Size     = UDim2.new(1, -56, 1, 0)
    titleLbl.Position = UDim2.new(0, 28, 0, 0)

    -- botão X — vermelho sólido, pequeno, quadrado com corner suave
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size             = UDim2.new(0, 20, 0, 20)
    closeBtn.Position         = UDim2.new(1, -26, 0.5, -10)
    closeBtn.BackgroundColor3 = C.CLOSE
    closeBtn.BorderSizePixel  = 0
    closeBtn.Text             = "X"
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.TextSize         = 10
    closeBtn.TextColor3       = Color3.fromRGB(255,255,255)
    closeBtn.AutoButtonColor  = false
    closeBtn.ZIndex           = 12
    closeBtn.Parent           = hdr
    corner(closeBtn, 4)

    closeBtn.MouseButton1Click:Connect(function()
        tween(win, {Size = UDim2.new(0,W,0,0)}, 0.18)
        task.delay(0.2, function() sg:Destroy() end)
    end)

    draggable(hdr, win)

    ----------------------------------------------------------------
    -- SCROLL (conteúdo abaixo do header)
    ----------------------------------------------------------------
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name                  = "Scroll"
    scroll.Position              = UDim2.new(0, 0, 0, 30)
    scroll.Size                  = UDim2.new(1, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel       = 0
    scroll.ScrollBarThickness    = 3
    scroll.ScrollBarImageColor3  = C.SCHEME
    scroll.CanvasSize            = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    scroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    scroll.ClipsDescendants      = true
    scroll.Parent                = win

    local scrollLL = list(scroll, 0)
    pad(scroll, 3, 4, 0, 0)

    -- ajusta janela conforme o conteúdo muda
    local function refreshH()
        local h = math.min(scrollLL.AbsoluteContentSize.Y + 7, MH)
        win.Size    = UDim2.new(0, W, 0, h + 30)
        scroll.Size = UDim2.new(1, 0, 0, h)
    end
    scrollLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshH)

    ----------------------------------------------------------------
    -- Window:NewTab  — accordion
    ----------------------------------------------------------------
    local Window = {}

    function Window:NewTab(tabName)
        tabName = tabName or "Tab"

        -- wrapper que agrupa botão + conteúdo
        local wrap = Instance.new("Frame")
        wrap.Name                  = "T_" .. tabName
        wrap.Size                  = UDim2.new(1, 0, 0, 32)
        wrap.BackgroundTransparency = 1
        wrap.BorderSizePixel       = 0
        wrap.ClipsDescendants      = true
        wrap.Parent                = scroll
        list(wrap, 0)

        -- ── Botão da tab ──────────────────────────────
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = C.TAB_OFF
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Text             = ""
        btn.ZIndex           = 5
        btn.Parent           = wrap

        -- seta
        local arrLbl = lbl(btn, "▶", 9, C.SCHEME, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 6)
        arrLbl.Size     = UDim2.new(0, 18, 1, 0)
        arrLbl.Position = UDim2.new(0, 8, 0, 0)

        -- nome da tab
        local tNameLbl = lbl(btn, tabName, 12, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
        tNameLbl.Size     = UDim2.new(1, -32, 1, 0)
        tNameLbl.Position = UDim2.new(0, 26, 0, 0)

        -- linha inferior do botão
        local tDiv = Instance.new("Frame")
        tDiv.Size             = UDim2.new(1, 0, 0, 1)
        tDiv.BackgroundColor3 = C.DIV
        tDiv.BorderSizePixel  = 0
        tDiv.ZIndex           = 5
        tDiv.Parent           = wrap

        -- ── Corpo da tab (elementos) ──────────────────
        local body = Instance.new("Frame")
        body.Size                  = UDim2.new(1, 0, 0, 0)
        body.BackgroundTransparency = 1
        body.BorderSizePixel       = 0
        body.ClipsDescendants      = false
        body.Parent                = wrap

        local bodyLL = list(body, 1)
        pad(body, 4, 4, 4, 4)

        local isOpen = false

        local function bodyH()
            return bodyLL.AbsoluteContentSize.Y + 8
        end

        bodyLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if isOpen then
                local h = bodyH()
                body.Size = UDim2.new(1, 0, 0, h)
                wrap.Size = UDim2.new(1, 0, 0, 33 + h)
            end
        end)

        btn.MouseEnter:Connect(function()
            if not isOpen then tween(btn, {BackgroundColor3 = Color3.fromRGB(28,28,28)}, 0.08) end
        end)
        btn.MouseLeave:Connect(function()
            if not isOpen then tween(btn, {BackgroundColor3 = C.TAB_OFF}, 0.08) end
        end)

        btn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                arrLbl.Text           = "▼"
                btn.BackgroundColor3  = C.TAB_ON
                local h               = bodyH()
                tween(body, {Size = UDim2.new(1,0,0,h)}, 0.17)
                tween(wrap, {Size = UDim2.new(1,0,0,33+h)}, 0.17)
            else
                arrLbl.Text           = "▶"
                btn.BackgroundColor3  = C.TAB_OFF
                tween(body, {Size = UDim2.new(1,0,0,0)}, 0.14)
                tween(wrap, {Size = UDim2.new(1,0,0,32)}, 0.14)
            end
        end)

        ------------------------------------------------------------
        -- Tab:NewSection
        ------------------------------------------------------------
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"

            -- cabeçalho da seção com cor de destaque
            local sHead = Instance.new("Frame")
            sHead.Size             = UDim2.new(1, 0, 0, 22)
            sHead.BackgroundColor3 = C.SCHEME
            sHead.BorderSizePixel  = 0
            sHead.Parent           = body
            corner(sHead, 4)

            local sLbl = lbl(sHead, "  " .. secName, 11, Color3.fromRGB(255,255,255), Enum.TextXAlignment.Left, Enum.Font.GothamBold, 5)
            sLbl.Size = UDim2.new(1,0,1,0)

            ----------------------------------------------------------
            -- Helpers internos
            ----------------------------------------------------------
            local Section = {}

            -- frame simples (label, slider, textbox)
            local function mkFrame(h)
                local f = Instance.new("Frame")
                f.Size             = UDim2.new(1, 0, 0, h or EH)
                f.BackgroundColor3 = C.ELEM
                f.BorderSizePixel  = 0
                f.Parent           = body
                corner(f, 4)
                return f
            end

            -- botão clicável (toggle, button, dropdown head, keybind)
            local function mkBtn(h)
                local b = Instance.new("TextButton")
                b.Size             = UDim2.new(1, 0, 0, h or EH)
                b.BackgroundColor3 = C.ELEM
                b.BorderSizePixel  = 0
                b.AutoButtonColor  = false
                b.Text             = ""
                b.ZIndex           = 4
                b.Parent           = body
                corner(b, 4)
                b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = C.ELEM}, 0.08) end)
                return b
            end

            -- label de nome à esquerda
            local function mkName(parent, text, rightOff)
                local l = lbl(parent, text, 12, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 5)
                l.Size     = UDim2.new(1, -(rightOff or 48), 1, 0)
                l.Position = UDim2.new(0, 10, 0, 0)
                return l
            end

            --------------------------------------------------------
            -- NewToggle
            --------------------------------------------------------
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local on = false

                local row = mkBtn()

                mkName(row, name, 50)

                -- badge ON / OFF  (igual ao print)
                local badge = lbl(row, "OFF", 12, C.TXT_DIM, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 5)
                badge.Size     = UDim2.new(0, 36, 0, 20)
                badge.Position = UDim2.new(1, -42, 0.5, -10)

                local function setState(v)
                    on = v
                    if on then
                        badge.Text       = "ON"
                        badge.TextColor3 = C.ON
                    else
                        badge.Text       = "OFF"
                        badge.TextColor3 = C.TXT_DIM
                    end
                end

                row.MouseButton1Click:Connect(function()
                    setState(not on)
                    pcall(callback, on)
                end)

                -- TogFunc
                local T = {}
                function T:UpdateToggle(newState, _)
                    -- aceita bool direto
                    if typeof(newState) == "boolean" then
                        setState(newState)
                    end
                end
                function T:SetToggle(v) setState(v) end
                return T
            end

            --------------------------------------------------------
            -- NewButton
            --------------------------------------------------------
            function Section:NewButton(name, tip, callback)
                callback = callback or function() end
                local row = mkBtn()

                local nl = lbl(row, name, 12, C.TXT, Enum.TextXAlignment.Center, Enum.Font.GothamSemibold, 5)
                nl.Size     = UDim2.new(1, -16, 1, 0)
                nl.Position = UDim2.new(0, 8, 0, 0)

                row.MouseButton1Click:Connect(function() pcall(callback) end)

                local B = {}
                function B:UpdateButton(t) nl.Text = t or name end
                return B
            end

            --------------------------------------------------------
            -- NewLabel
            --------------------------------------------------------
            function Section:NewLabel(text)
                local row = mkFrame(26)

                local nl = lbl(row, text, 11, C.TXT_DIM, Enum.TextXAlignment.Left, Enum.Font.Gotham, 5)
                nl.Size        = UDim2.new(1, -14, 0, 26)
                nl.Position    = UDim2.new(0, 8, 0, 0)
                nl.TextWrapped = true

                nl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h = math.max(26, nl.TextBounds.Y + 8)
                    row.Size = UDim2.new(1, 0, 0, h)
                    nl.Size  = UDim2.new(1, -14, 0, h)
                end)

                local L = {}
                function L:UpdateLabel(t) nl.Text = t or "" end
                return L
            end

            --------------------------------------------------------
            -- NewSlider  (idêntico ao print: texto em cima, barra verde embaixo)
            --------------------------------------------------------
            function Section:NewSlider(name, tip, maxV, minV, callback)
                maxV     = tonumber(maxV) or 100
                minV     = tonumber(minV) or 0
                callback = callback       or function() end
                local cur = minV

                local row = mkFrame(46)

                -- "Nome: valor"
                local nLbl = lbl(row, (name or "Slider") .. ": " .. tostring(cur), 12, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 5)
                nLbl.Size     = UDim2.new(1, -14, 0, 20)
                nLbl.Position = UDim2.new(0, 8, 0, 4)

                -- trilho (quase toda a largura, igual ao print)
                local track = Instance.new("Frame")
                track.Size             = UDim2.new(1, -16, 0, 7)
                track.Position         = UDim2.new(0, 8, 0, 30)
                track.BackgroundColor3 = C.SL_TR
                track.BorderSizePixel  = 0
                track.ZIndex           = 5
                track.Parent           = row
                corner(track, 4)

                -- preenchimento verde
                local fill = Instance.new("Frame")
                fill.Size             = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = C.SL_FILL
                fill.BorderSizePixel  = 0
                fill.ZIndex           = 6
                fill.Parent           = track
                corner(fill, 4)

                -- área de captura de click (mais alta que a barra)
                local grab = Instance.new("TextButton")
                grab.Size               = UDim2.new(1, 0, 0, 22)
                grab.Position           = UDim2.new(0, 0, 0.5, -11)
                grab.BackgroundTransparency = 1
                grab.Text               = ""
                grab.ZIndex             = 8
                grab.Parent             = track

                local mouse   = Players.LocalPlayer:GetMouse()
                local sliding = false

                local function applyX(mx)
                    local tw_ = track.AbsoluteSize.X
                    local rx  = math.clamp(mx - track.AbsolutePosition.X, 0, tw_)
                    local pct = rx / math.max(tw_, 1)
                    cur       = math.floor(minV + (maxV - minV) * pct)
                    fill.Size = UDim2.new(0, rx, 1, 0)
                    nLbl.Text = (name or "Slider") .. ": " .. tostring(cur)
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
                    nLbl.Text = (name or "Slider") .. ": " .. tostring(cur)
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

                -- outer frame — cresce ao abrir
                local outer = Instance.new("Frame")
                outer.Name             = "DD"
                outer.Size             = UDim2.new(1, 0, 0, EH)
                outer.BackgroundColor3 = C.ELEM
                outer.BorderSizePixel  = 0
                outer.ClipsDescendants = true
                outer.ZIndex           = 6
                outer.Parent           = body
                corner(outer, 4)

                -- cabeçalho clicável
                local dHead = Instance.new("TextButton")
                dHead.Size               = UDim2.new(1, 0, 0, EH)
                dHead.BackgroundTransparency = 1
                dHead.BorderSizePixel    = 0
                dHead.AutoButtonColor    = false
                dHead.Text               = ""
                dHead.ZIndex             = 7
                dHead.Parent             = outer

                local dLbl = lbl(dHead, name or "Dropdown", 12, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 8)
                dLbl.Size     = UDim2.new(1, -30, 1, 0)
                dLbl.Position = UDim2.new(0, 10, 0, 0)

                local dArr = lbl(dHead, "▶", 9, C.TXT_DIM, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 8)
                dArr.Size     = UDim2.new(0, 18, 1, 0)
                dArr.Position = UDim2.new(1, -22, 0, 0)

                -- divisor
                local dDiv = Instance.new("Frame")
                dDiv.Size             = UDim2.new(1, -16, 0, 1)
                dDiv.Position         = UDim2.new(0, 8, 0, EH)
                dDiv.BackgroundColor3 = C.DIV
                dDiv.BorderSizePixel  = 0
                dDiv.ZIndex           = 7
                dDiv.Parent           = outer

                -- container de opções
                local optBox = Instance.new("Frame")
                optBox.Size             = UDim2.new(1, 0, 0, 0)
                optBox.Position         = UDim2.new(0, 0, 0, EH + 1)
                optBox.BackgroundTransparency = 1
                optBox.BorderSizePixel  = 0
                optBox.ZIndex           = 7
                optBox.Parent           = outer

                local optLL = list(optBox, 2)
                pad(optBox, 3, 3, 4, 4)

                local function buildOpts(lst)
                    for _, ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, opt in ipairs(lst) do
                        local ob = Instance.new("TextButton")
                        ob.Size             = UDim2.new(1, 0, 0, 28)
                        ob.BackgroundColor3 = C.OPT
                        ob.BorderSizePixel  = 0
                        ob.AutoButtonColor  = false
                        ob.Text             = "  " .. tostring(opt)
                        ob.Font             = Enum.Font.GothamSemibold
                        ob.TextSize         = 12
                        ob.TextColor3       = C.TXT
                        ob.TextXAlignment   = Enum.TextXAlignment.Left
                        ob.ZIndex           = 9
                        ob.Parent           = optBox
                        corner(ob, 3)

                        ob.MouseEnter:Connect(function() tween(ob, {BackgroundColor3 = C.ELEM_H}, 0.07) end)
                        ob.MouseLeave:Connect(function() tween(ob, {BackgroundColor3 = C.OPT}, 0.07) end)

                        ob.MouseButton1Click:Connect(function()
                            dLbl.Text = tostring(name) .. ": " .. tostring(opt)
                            isOpen    = false
                            dArr.Text = "▶"
                            tween(outer, {Size = UDim2.new(1,0,0,EH)}, 0.14)
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
                        dArr.Text = "▼"
                        local oh  = optLL.AbsoluteContentSize.Y + 6
                        tween(outer, {Size = UDim2.new(1,0,0, EH+1+oh)}, 0.17)
                    else
                        dArr.Text = "▶"
                        tween(outer, {Size = UDim2.new(1,0,0,EH)}, 0.14)
                    end
                end)

                local D = {}
                function D:Refresh(newList, keep)
                    options = newList or {}
                    if not keep then dLbl.Text = name end
                    buildOpts(options)
                    if isOpen then
                        local oh = optLL.AbsoluteContentSize.Y + 6
                        outer.Size = UDim2.new(1,0,0, EH+1+oh)
                    end
                end
                function D:SetSelected(v)
                    dLbl.Text = tostring(name) .. ": " .. tostring(v)
                end
                return D
            end

            --------------------------------------------------------
            -- NewTextBox
            --------------------------------------------------------
            function Section:NewTextBox(name, tip, callback)
                callback = callback or function() end
                local row = mkFrame(EH)

                local nLbl = lbl(row, name, 12, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 5)
                nLbl.Size     = UDim2.new(0.44, 0, 1, 0)
                nLbl.Position = UDim2.new(0, 8, 0, 0)
                nLbl.TextTruncate = Enum.TextTruncate.AtEnd

                -- fundo do input
                local inBg = Instance.new("Frame")
                inBg.Size             = UDim2.new(0.52, 0, 0, 22)
                inBg.Position         = UDim2.new(0.46, 0, 0.5, -11)
                inBg.BackgroundColor3 = C.INP
                inBg.BorderSizePixel  = 0
                inBg.ZIndex           = 5
                inBg.Parent           = row
                corner(inBg, 4)
                stroke(inBg, C.DIV, 1)

                local tb = Instance.new("TextBox")
                tb.Size                  = UDim2.new(1, -8, 1, 0)
                tb.Position              = UDim2.new(0, 4, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text                  = ""
                tb.PlaceholderText       = tip or "Type..."
                tb.PlaceholderColor3     = C.TXT_DIM
                tb.Font                  = Enum.Font.Gotham
                tb.TextSize              = 11
                tb.TextColor3            = C.TXT
                tb.ClearTextOnFocus      = false
                tb.ZIndex                = 6
                tb.Parent                = inBg

                tb.FocusLost:Connect(function(enter)
                    if enter then pcall(callback, tb.Text); tb.Text = "" end
                end)

                return {}
            end

            --------------------------------------------------------
            -- NewKeybind
            --------------------------------------------------------
            function Section:NewKeybind(name, tip, defaultKey, callback)
                defaultKey = defaultKey or Enum.KeyCode.F
                callback   = callback   or function() end
                local curKey    = defaultKey
                local listening = false

                local row = mkBtn()
                mkName(row, name, 72)

                -- caixa da tecla
                local kBox = lbl(row, defaultKey.Name, 11, C.SCHEME, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 5)
                kBox.Size               = UDim2.new(0, 60, 0, 22)
                kBox.Position           = UDim2.new(1, -66, 0.5, -11)
                kBox.BackgroundColor3   = C.INP
                kBox.BackgroundTransparency = 0
                corner(kBox --[[ workaround ]])

                -- não tem corner em TextLabel diretamente, usa um frame
                local kFrame = Instance.new("Frame")
                kFrame.Size             = UDim2.new(0, 60, 0, 22)
                kFrame.Position         = UDim2.new(1, -66, 0.5, -11)
                kFrame.BackgroundColor3 = C.INP
                kFrame.BorderSizePixel  = 0
                kFrame.ZIndex           = 5
                kFrame.Parent           = row
                corner(kFrame, 4)
                stroke(kFrame, C.DIV, 1)

                -- remover o TextLabel criado acima, recriar dentro do frame
                kBox:Destroy()
                local kLbl = lbl(kFrame, defaultKey.Name, 11, C.SCHEME, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 6)
                kLbl.Size = UDim2.new(1, 0, 1, 0)

                row.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    kLbl.Text       = "..."
                    kLbl.TextColor3 = C.TXT_DIM
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, gp)
                        if not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
                            curKey          = inp.KeyCode
                            kLbl.Text       = inp.KeyCode.Name
                            kLbl.TextColor3 = C.SCHEME
                            listening       = false
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

    ----------------------------------------------------------------
    -- Utilitários do Window
    ----------------------------------------------------------------
    function Window:ToggleUI()
        if _GUI then _GUI.Enabled = not _GUI.Enabled end
    end

    function Window:ChangeColor(prop, color)
        if prop == "SchemeColor" then
            C.SCHEME  = color
            C.SL_FILL = color
            C.ON      = color
        elseif prop == "Background" then
            C.WIN = color
        elseif prop == "TextColor" then
            C.TXT = color
        elseif prop == "ElementColor" then
            C.ELEM = color
        end
    end

    return Window
end

----------------------------------------------------------------
-- ToggleUI no próprio Library (para Library:ToggleUI())
----------------------------------------------------------------
function Library:ToggleUI()
    if _GUI then _GUI.Enabled = not _GUI.Enabled end
end

return Library
