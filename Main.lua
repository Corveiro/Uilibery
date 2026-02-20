-- ═══════════════════════════════════════════════════════
--        UI Library  •  Design ONION13 Style
--        Tabs = Accordion  |  API 100% Preservada
--        Toggle ON verde / OFF cinza  ✓
-- ═══════════════════════════════════════════════════════

local Library = {}
Library.__index = Library

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

-- ─── Helpers ───────────────────────────────────────────────
local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function mkCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 5)
    c.Parent = parent
    return c
end

local function mkPadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.Parent = parent
    return p
end

local function mkList(parent, spacing)
    local l = Instance.new("UIListLayout")
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.FillDirection       = Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding             = UDim.new(0, spacing or 0)
    l.Parent              = parent
    return l
end

local function mkStroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color     = color or Color3.fromRGB(50,50,50)
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent    = parent
    return s
end

local function draggable(handle, target)
    local drag, s0, p0 = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            s0   = i.Position
            p0   = target.Position
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

-- ─── Paleta de cores (ONION13 exata) ───────────────────────
local C = {
    WIN_BG   = Color3.fromRGB(20, 20, 20),    -- janela
    HEADER   = Color3.fromRGB(12, 12, 12),    -- header
    TAB_BTN  = Color3.fromRGB(26, 26, 26),    -- botão tab fechado
    TAB_OPEN = Color3.fromRGB(32, 32, 32),    -- botão tab aberto
    ELEM_BG  = Color3.fromRGB(15, 15, 15),    -- fundo elemento
    ELEM_HOV = Color3.fromRGB(28, 28, 28),    -- hover elemento
    OPT_BG   = Color3.fromRGB(22, 22, 22),    -- opção dropdown
    SL_TRACK = Color3.fromRGB(38, 38, 38),    -- trilho slider
    SL_FILL  = Color3.fromRGB(72, 195, 72),   -- fill slider (verde)
    TEXT     = Color3.fromRGB(235, 235, 235), -- texto principal
    TEXT_DIM = Color3.fromRGB(140, 140, 140), -- texto secundário
    ON_CLR   = Color3.fromRGB(72,  195, 72),  -- "ON" verde
    OFF_CLR  = Color3.fromRGB(165, 165, 165), -- "OFF" cinza
    CLOSE    = Color3.fromRGB(210,  42,  42), -- X vermelho
    BORDER   = Color3.fromRGB(40,   40,  40), -- bordas
    SCHEME   = Color3.fromRGB(72,  195, 72),  -- cor principal
}

local _GUI = nil  -- referência global ao ScreenGui

-- ═══════════════════════════════════════════════════════════
--   Library.CreateLib(title, themeColor)
-- ═══════════════════════════════════════════════════════════
function Library.CreateLib(title, themeColor)
    -- Aplicar cor do tema se fornecida
    if typeof(themeColor) == "Color3" then
        C.SCHEME  = themeColor
        C.SL_FILL = themeColor
        C.ON_CLR  = themeColor
    end

    -- Destruir gui antiga
    pcall(function()
        for _, v in ipairs(game.CoreGui:GetChildren()) do
            if v.Name == "__SapiLib" then v:Destroy() end
        end
    end)

    -- ── ScreenGui ────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name           = "__SapiLib"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 9999
    pcall(function() sg.Parent = game.CoreGui end)
    _GUI = sg

    local WIN_W  = 238  -- largura fixa idêntica ao print
    local ELEM_H = 32   -- altura padrão dos elementos
    local MAX_H  = 430  -- altura máxima do scroll

    -- ── Frame principal ──────────────────────────────────
    local win = Instance.new("Frame")
    win.Name             = "MainWindow"
    win.AnchorPoint      = Vector2.new(0.5, 0)
    win.Position         = UDim2.new(0.5, 0, 0.06, 0)
    win.Size             = UDim2.new(0, WIN_W, 0, 30)
    win.BackgroundColor3 = C.WIN_BG
    win.BorderSizePixel  = 0
    win.ClipsDescendants = false
    win.Parent           = sg
    mkCorner(win, 7)
    mkStroke(win, C.BORDER, 1)

    -- ── Header ───────────────────────────────────────────
    local header = Instance.new("Frame")
    header.Name             = "Header"
    header.Size             = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = C.HEADER
    header.BorderSizePixel  = 0
    header.ZIndex           = 10
    header.Parent           = win
    mkCorner(header, 7)

    -- cobre o arredondamento inferior do header
    local hfix = Instance.new("Frame")
    hfix.Size             = UDim2.new(1, 0, 0, 7)
    hfix.Position         = UDim2.new(0, 0, 1, -7)
    hfix.BackgroundColor3 = C.HEADER
    hfix.BorderSizePixel  = 0
    hfix.ZIndex           = 10
    hfix.Parent           = header

    -- título
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size                  = UDim2.new(1, -60, 1, 0)
    titleLbl.Position              = UDim2.new(0, 30, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                  = title or "UI Library"
    titleLbl.Font                  = Enum.Font.GothamBold
    titleLbl.TextSize              = 12
    titleLbl.TextColor3            = C.TEXT
    titleLbl.TextXAlignment        = Enum.TextXAlignment.Center
    titleLbl.TextTruncate          = Enum.TextTruncate.AtEnd
    titleLbl.ZIndex                = 11
    titleLbl.Parent                = header

    -- ícone (bolinha colorida pequena, igual ao print)
    local iconDot = Instance.new("Frame")
    iconDot.Size             = UDim2.new(0, 10, 0, 10)
    iconDot.Position         = UDim2.new(0, 12, 0.5, -5)
    iconDot.BackgroundColor3 = C.SCHEME
    iconDot.BorderSizePixel  = 0
    iconDot.ZIndex           = 11
    iconDot.Parent           = header
    mkCorner(iconDot, 5)

    -- botão X vermelho
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size             = UDim2.new(0, 20, 0, 20)
    closeBtn.Position         = UDim2.new(1, -25, 0.5, -10)
    closeBtn.BackgroundColor3 = C.CLOSE
    closeBtn.BorderSizePixel  = 0
    closeBtn.Text             = "X"
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.TextSize         = 10
    closeBtn.TextColor3       = Color3.fromRGB(255,255,255)
    closeBtn.AutoButtonColor  = false
    closeBtn.ZIndex           = 12
    closeBtn.Parent           = header
    mkCorner(closeBtn, 4)

    closeBtn.MouseButton1Click:Connect(function()
        tw(win, {Size = UDim2.new(0, WIN_W, 0, 0)}, 0.2)
        task.delay(0.25, function() sg:Destroy() end)
    end)

    draggable(header, win)

    -- ── ScrollingFrame ───────────────────────────────────
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

    local scrollList = mkList(scroll, 0)
    mkPadding(scroll, 4, 6, 0, 0)

    -- Atualiza altura da janela conforme o conteúdo
    local function updateWinH()
        local h = math.min(scrollList.AbsoluteContentSize.Y + 10, MAX_H)
        win.Size    = UDim2.new(0, WIN_W, 0, h + 30)
        scroll.Size = UDim2.new(1, 0, 0, h)
    end
    scrollList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateWinH)

    -- ════════════════════════════════════════════════════
    --  Window:NewTab  → accordion
    -- ════════════════════════════════════════════════════
    local Window = {}

    function Window:NewTab(tabName)
        tabName = tabName or "Tab"

        -- Container total da tab (botão + filhos)
        local tabWrap = Instance.new("Frame")
        tabWrap.Name                  = "TabWrap"
        tabWrap.Size                  = UDim2.new(1, 0, 0, 33)  -- começa fechado
        tabWrap.BackgroundTransparency = 1
        tabWrap.BorderSizePixel       = 0
        tabWrap.ClipsDescendants      = true
        tabWrap.Parent                = scroll

        local wrapList = mkList(tabWrap, 0)

        -- ── Botão da tab (cabeçalho accordion) ──────────
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name             = "TabBtn"
        tabBtn.Size             = UDim2.new(1, 0, 0, 32)
        tabBtn.BackgroundColor3 = C.TAB_BTN
        tabBtn.BorderSizePixel  = 0
        tabBtn.AutoButtonColor  = false
        tabBtn.ZIndex           = 5
        tabBtn.Parent           = tabWrap
        mkCorner(tabBtn, 5)
        mkStroke(tabBtn, C.BORDER, 1)

        -- seta + nome
        local arrow = Instance.new("TextLabel")
        arrow.Size                  = UDim2.new(0, 18, 1, 0)
        arrow.Position              = UDim2.new(0, 8, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text                  = "▶"
        arrow.Font                  = Enum.Font.GothamBold
        arrow.TextSize              = 9
        arrow.TextColor3            = C.SCHEME
        arrow.TextXAlignment        = Enum.TextXAlignment.Center
        arrow.ZIndex                = 6
        arrow.Parent                = tabBtn

        local tabNameLbl = Instance.new("TextLabel")
        tabNameLbl.Size                  = UDim2.new(1, -32, 1, 0)
        tabNameLbl.Position              = UDim2.new(0, 26, 0, 0)
        tabNameLbl.BackgroundTransparency = 1
        tabNameLbl.Text                  = tabName
        tabNameLbl.Font                  = Enum.Font.GothamBold
        tabNameLbl.TextSize              = 12
        tabNameLbl.TextColor3            = C.TEXT
        tabNameLbl.TextXAlignment        = Enum.TextXAlignment.Left
        tabNameLbl.TextTruncate          = Enum.TextTruncate.AtEnd
        tabNameLbl.ZIndex                = 6
        tabNameLbl.Parent                = tabBtn

        -- linha divisória abaixo do botão
        local divLine = Instance.new("Frame")
        divLine.Name             = "Div"
        divLine.Size             = UDim2.new(1, 0, 0, 1)
        divLine.BackgroundColor3 = C.BORDER
        divLine.BorderSizePixel  = 0
        divLine.Parent           = tabWrap

        -- ── Container dos elementos (conteúdo da tab) ────
        local body = Instance.new("Frame")
        body.Name                  = "Body"
        body.Size                  = UDim2.new(1, 0, 0, 0)
        body.BackgroundTransparency = 1
        body.BorderSizePixel       = 0
        body.ClipsDescendants      = false  -- não cortar; o tabWrap vai cortar
        body.Parent                = tabWrap

        local bodyList = mkList(body, 3)
        mkPadding(body, 5, 5, 5, 5)

        -- estado
        local isOpen   = false
        local bodyH    = 0

        local function refreshBodyH()
            return bodyList.AbsoluteContentSize.Y + 10
        end

        local function openTab()
            isOpen    = true
            bodyH     = refreshBodyH()
            arrow.Text            = "▼"
            tabBtn.BackgroundColor3 = C.TAB_OPEN
            -- abrir com tween
            tw(body,    {Size = UDim2.new(1, 0, 0, bodyH)}, 0.18)
            tw(tabWrap, {Size = UDim2.new(1, 0, 0, 32 + 1 + bodyH)}, 0.18)
        end

        local function closeTab()
            isOpen    = false
            arrow.Text            = "▶"
            tabBtn.BackgroundColor3 = C.TAB_BTN
            tw(body,    {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
            tw(tabWrap, {Size = UDim2.new(1, 0, 0, 33)}, 0.15)
        end

        -- Quando conteúdo muda e tab está aberta, recalcula
        bodyList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if isOpen then
                bodyH = refreshBodyH()
                body.Size    = UDim2.new(1, 0, 0, bodyH)
                tabWrap.Size = UDim2.new(1, 0, 0, 32 + 1 + bodyH)
            end
        end)

        tabBtn.MouseButton1Click:Connect(function()
            if isOpen then closeTab() else openTab() end
        end)

        -- hover sutil no botão da tab
        tabBtn.MouseEnter:Connect(function()
            if not isOpen then tw(tabBtn, {BackgroundColor3 = Color3.fromRGB(32,32,32)}, 0.08) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if not isOpen then tw(tabBtn, {BackgroundColor3 = C.TAB_BTN}, 0.08) end
        end)

        -- ════════════════════════════════════════════════
        --  Tab:NewSection
        -- ════════════════════════════════════════════════
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"

            -- Cabeçalho da section (verde)
            local secHead = Instance.new("Frame")
            secHead.Name             = "SecHead"
            secHead.Size             = UDim2.new(1, 0, 0, 22)
            secHead.BackgroundColor3 = C.SCHEME
            secHead.BorderSizePixel  = 0
            secHead.Parent           = body
            mkCorner(secHead, 5)

            local secLbl = Instance.new("TextLabel")
            secLbl.Size                  = UDim2.new(1, -10, 1, 0)
            secLbl.Position              = UDim2.new(0, 8, 0, 0)
            secLbl.BackgroundTransparency = 1
            secLbl.Text                  = secName
            secLbl.Font                  = Enum.Font.GothamBold
            secLbl.TextSize              = 11
            secLbl.TextColor3            = Color3.fromRGB(255,255,255)
            secLbl.TextXAlignment        = Enum.TextXAlignment.Left
            secLbl.Parent                = secHead

            -- ── Funções de elemento ──────────────────────
            local Section = {}

            -- ─ helper: cria row base ─────────────────────
            local function mkRow(h)
                local row = Instance.new("Frame")
                row.Size             = UDim2.new(1, 0, 0, h or ELEM_H)
                row.BackgroundColor3 = C.ELEM_BG
                row.BorderSizePixel  = 0
                row.Parent           = body
                mkCorner(row, 5)
                return row
            end

            local function mkRowBtn(h)
                local row = Instance.new("TextButton")
                row.Size             = UDim2.new(1, 0, 0, h or ELEM_H)
                row.BackgroundColor3 = C.ELEM_BG
                row.BorderSizePixel  = 0
                row.AutoButtonColor  = false
                row.Text             = ""
                row.ZIndex           = 4
                row.Parent           = body
                mkCorner(row, 5)
                row.MouseEnter:Connect(function() tw(row, {BackgroundColor3 = C.ELEM_HOV}, 0.08) end)
                row.MouseLeave:Connect(function() tw(row, {BackgroundColor3 = C.ELEM_BG},  0.08) end)
                return row
            end

            local function nameLabel(parent, text, xoff)
                local l = Instance.new("TextLabel")
                l.Size                  = UDim2.new(1, -(xoff or 50), 1, 0)
                l.Position              = UDim2.new(0, 10, 0, 0)
                l.BackgroundTransparency = 1
                l.Text                  = text or ""
                l.Font                  = Enum.Font.GothamSemibold
                l.TextSize              = 12
                l.TextColor3            = C.TEXT
                l.TextXAlignment        = Enum.TextXAlignment.Left
                l.TextTruncate          = Enum.TextTruncate.AtEnd
                l.ZIndex                = 5
                l.Parent                = parent
                return l
            end

            -- ══ NewToggle ════════════════════════════════
            function Section:NewToggle(name, tip, callback)
                callback = callback or function() end
                local toggled = false

                local row = mkRowBtn()

                nameLabel(row, name, 50)

                -- badge ON/OFF
                local badge = Instance.new("TextLabel")
                badge.Size                  = UDim2.new(0, 36, 0, 20)
                badge.Position              = UDim2.new(1, -42, 0.5, -10)
                badge.BackgroundTransparency = 1
                badge.Text                  = "OFF"
                badge.Font                  = Enum.Font.GothamBold
                badge.TextSize              = 12
                badge.TextColor3            = C.OFF_CLR
                badge.TextXAlignment        = Enum.TextXAlignment.Center
                badge.ZIndex                = 5
                badge.Parent                = row

                row.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        badge.Text      = "ON"
                        badge.TextColor3 = C.ON_CLR
                    else
                        badge.Text      = "OFF"
                        badge.TextColor3 = C.OFF_CLR
                    end
                    pcall(callback, toggled)
                end)

                local TogFunc = {}

                function TogFunc:UpdateToggle(newStateOrText, isOn)
                    -- suporta UpdateToggle(bool) e UpdateToggle("texto", bool)
                    if typeof(newStateOrText) == "boolean" then
                        toggled = newStateOrText
                    elseif typeof(newStateOrText) == "string" then
                        -- atualizar nome se necessário
                    end
                    if typeof(isOn) == "boolean" then toggled = isOn end

                    if toggled then
                        badge.Text      = "ON"
                        badge.TextColor3 = C.ON_CLR
                    else
                        badge.Text      = "OFF"
                        badge.TextColor3 = C.OFF_CLR
                    end
                    pcall(callback, toggled)
                end

                function TogFunc:SetToggle(state)
                    toggled = state
                    if toggled then
                        badge.Text      = "ON"
                        badge.TextColor3 = C.ON_CLR
                    else
                        badge.Text      = "OFF"
                        badge.TextColor3 = C.OFF_CLR
                    end
                end

                return TogFunc
            end

            -- ══ NewButton ════════════════════════════════
            function Section:NewButton(name, tip, callback)
                callback = callback or function() end
                local row = mkRowBtn()

                local lbl = Instance.new("TextLabel")
                lbl.Size                  = UDim2.new(1, -16, 1, 0)
                lbl.Position              = UDim2.new(0, 8, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text                  = name or "Button"
                lbl.Font                  = Enum.Font.GothamSemibold
                lbl.TextSize              = 12
                lbl.TextColor3            = C.TEXT
                lbl.TextXAlignment        = Enum.TextXAlignment.Center
                lbl.ZIndex                = 5
                lbl.Parent                = row

                row.MouseButton1Click:Connect(function() pcall(callback) end)

                local BtnFunc = {}
                function BtnFunc:UpdateButton(t) lbl.Text = t or name end
                return BtnFunc
            end

            -- ══ NewLabel ═════════════════════════════════
            function Section:NewLabel(text)
                local row = mkRow(26)

                local lbl = Instance.new("TextLabel")
                lbl.Size                  = UDim2.new(1, -14, 0, 26)
                lbl.Position              = UDim2.new(0, 8, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text                  = text or ""
                lbl.Font                  = Enum.Font.Gotham
                lbl.TextSize              = 11
                lbl.TextColor3            = C.TEXT_DIM
                lbl.TextXAlignment        = Enum.TextXAlignment.Left
                lbl.TextWrapped           = true
                lbl.ZIndex                = 5
                lbl.Parent                = row

                lbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h = math.max(26, lbl.TextBounds.Y + 8)
                    row.Size = UDim2.new(1, 0, 0, h)
                    lbl.Size = UDim2.new(1, -14, 0, h)
                end)

                local LblFunc = {}
                function LblFunc:UpdateLabel(t) lbl.Text = t or "" end
                return LblFunc
            end

            -- ══ NewSlider ════════════════════════════════
            function Section:NewSlider(name, tip, maxVal, minVal, callback)
                maxVal   = tonumber(maxVal)   or 100
                minVal   = tonumber(minVal)   or 0
                callback = callback           or function() end
                local curVal = minVal

                local row = mkRow(46)

                -- texto "Nome: val"
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size                  = UDim2.new(1, -14, 0, 20)
                nameLbl.Position              = UDim2.new(0, 8, 0, 4)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text                  = (name or "Slider") .. ": " .. tostring(curVal)
                nameLbl.Font                  = Enum.Font.GothamSemibold
                nameLbl.TextSize              = 12
                nameLbl.TextColor3            = C.TEXT
                nameLbl.TextXAlignment        = Enum.TextXAlignment.Left
                nameLbl.ZIndex                = 5
                nameLbl.Parent                = row

                -- trilho
                local track = Instance.new("Frame")
                track.Size             = UDim2.new(1, -16, 0, 7)
                track.Position         = UDim2.new(0, 8, 0, 30)
                track.BackgroundColor3 = C.SL_TRACK
                track.BorderSizePixel  = 0
                track.ZIndex           = 5
                track.Parent           = row
                mkCorner(track, 4)

                -- preenchimento verde
                local fill = Instance.new("Frame")
                fill.Size             = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = C.SL_FILL
                fill.BorderSizePixel  = 0
                fill.ZIndex           = 6
                fill.Parent           = track
                mkCorner(fill, 4)

                -- botão invisível para captura de input
                local slBtn = Instance.new("TextButton")
                slBtn.Size               = UDim2.new(1, 0, 0, 22)
                slBtn.Position           = UDim2.new(0, 0, 0, -7)
                slBtn.BackgroundTransparency = 1
                slBtn.Text               = ""
                slBtn.ZIndex             = 8
                slBtn.Parent             = track

                local mouse   = Players.LocalPlayer:GetMouse()
                local sliding = false

                local function setVal(mx)
                    local tw_ = track.AbsoluteSize.X
                    local rx   = math.clamp(mx - track.AbsolutePosition.X, 0, tw_)
                    local pct  = rx / math.max(tw_, 1)
                    curVal     = math.floor(minVal + (maxVal - minVal) * pct)
                    fill.Size  = UDim2.new(0, rx, 1, 0)
                    nameLbl.Text = (name or "Slider") .. ": " .. tostring(curVal)
                    pcall(callback, curVal)
                end

                slBtn.MouseButton1Down:Connect(function()
                    sliding = true
                    setVal(mouse.X)
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                mouse.Move:Connect(function()
                    if sliding then setVal(mouse.X) end
                end)

                local SlFunc = {}
                function SlFunc:UpdateSlider(v)
                    curVal = math.clamp(tonumber(v) or minVal, minVal, maxVal)
                    local pct = (curVal - minVal) / math.max(maxVal - minVal, 1)
                    fill.Size    = UDim2.new(pct, 0, 1, 0)
                    nameLbl.Text = (name or "Slider") .. ": " .. tostring(curVal)
                end
                return SlFunc
            end

            -- ══ NewDropdown ══════════════════════════════
            function Section:NewDropdown(name, tip, options, callback)
                options  = options  or {}
                callback = callback or function() end
                local isOpen   = false
                local selected = nil

                -- outer frame (cresce ao abrir)
                local outer = Instance.new("Frame")
                outer.Name             = "Drop_" .. tostring(name)
                outer.Size             = UDim2.new(1, 0, 0, ELEM_H)
                outer.BackgroundColor3 = C.ELEM_BG
                outer.BorderSizePixel  = 0
                outer.ClipsDescendants = true
                outer.ZIndex           = 6
                outer.Parent           = body
                mkCorner(outer, 5)

                -- cabeçalho clicável
                local head = Instance.new("TextButton")
                head.Size             = UDim2.new(1, 0, 0, ELEM_H)
                head.BackgroundTransparency = 1
                head.BorderSizePixel  = 0
                head.AutoButtonColor  = false
                head.Text             = ""
                head.ZIndex           = 7
                head.Parent           = outer

                local headLbl = Instance.new("TextLabel")
                headLbl.Size                  = UDim2.new(1, -32, 1, 0)
                headLbl.Position              = UDim2.new(0, 10, 0, 0)
                headLbl.BackgroundTransparency = 1
                headLbl.Text                  = name or "Dropdown"
                headLbl.Font                  = Enum.Font.GothamSemibold
                headLbl.TextSize              = 12
                headLbl.TextColor3            = C.TEXT
                headLbl.TextXAlignment        = Enum.TextXAlignment.Left
                headLbl.TextTruncate          = Enum.TextTruncate.AtEnd
                headLbl.ZIndex                = 8
                headLbl.Parent                = head

                local arrowLbl = Instance.new("TextLabel")
                arrowLbl.Size                  = UDim2.new(0, 20, 1, 0)
                arrowLbl.Position              = UDim2.new(1, -24, 0, 0)
                arrowLbl.BackgroundTransparency = 1
                arrowLbl.Text                  = "▶"
                arrowLbl.Font                  = Enum.Font.GothamBold
                arrowLbl.TextSize              = 9
                arrowLbl.TextColor3            = C.TEXT_DIM
                arrowLbl.TextXAlignment        = Enum.TextXAlignment.Center
                arrowLbl.ZIndex                = 8
                arrowLbl.Parent                = head

                -- separador
                local sepLine = Instance.new("Frame")
                sepLine.Size             = UDim2.new(1, -16, 0, 1)
                sepLine.Position         = UDim2.new(0, 8, 0, ELEM_H)
                sepLine.BackgroundColor3 = C.BORDER
                sepLine.BorderSizePixel  = 0
                sepLine.ZIndex           = 7
                sepLine.Parent           = outer

                -- opções
                local optHolder = Instance.new("Frame")
                optHolder.Size             = UDim2.new(1, 0, 0, 0)
                optHolder.Position         = UDim2.new(0, 0, 0, ELEM_H + 1)
                optHolder.BackgroundTransparency = 1
                optHolder.BorderSizePixel  = 0
                optHolder.ZIndex           = 7
                optHolder.Parent           = outer

                local optList = mkList(optHolder, 2)
                mkPadding(optHolder, 4, 4, 5, 5)

                local function buildOpts(list)
                    for _, ch in ipairs(optHolder:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _, opt in ipairs(list) do
                        local ob = Instance.new("TextButton")
                        ob.Size             = UDim2.new(1, 0, 0, 28)
                        ob.BackgroundColor3 = C.OPT_BG
                        ob.BorderSizePixel  = 0
                        ob.AutoButtonColor  = false
                        ob.Text             = "  " .. tostring(opt)
                        ob.Font             = Enum.Font.GothamSemibold
                        ob.TextSize         = 12
                        ob.TextColor3       = C.TEXT
                        ob.TextXAlignment   = Enum.TextXAlignment.Left
                        ob.ZIndex           = 9
                        ob.Parent           = optHolder
                        mkCorner(ob, 4)

                        ob.MouseEnter:Connect(function() tw(ob, {BackgroundColor3 = C.ELEM_HOV}, 0.08) end)
                        ob.MouseLeave:Connect(function() tw(ob, {BackgroundColor3 = C.OPT_BG}, 0.08) end)

                        ob.MouseButton1Click:Connect(function()
                            selected     = opt
                            headLbl.Text = tostring(name) .. ": " .. tostring(opt)
                            -- fechar dropdown
                            isOpen = false
                            arrowLbl.Text = "▶"
                            tw(outer, {Size = UDim2.new(1, 0, 0, ELEM_H)}, 0.15)
                            pcall(callback, opt)
                        end)
                    end
                end

                buildOpts(options)

                head.MouseEnter:Connect(function() tw(outer, {BackgroundColor3 = C.ELEM_HOV}, 0.08) end)
                head.MouseLeave:Connect(function() tw(outer, {BackgroundColor3 = C.ELEM_BG}, 0.08) end)

                head.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        arrowLbl.Text = "▼"
                        local optH = optList.AbsoluteContentSize.Y + 8
                        tw(outer, {Size = UDim2.new(1, 0, 0, ELEM_H + 1 + optH)}, 0.18)
                    else
                        arrowLbl.Text = "▶"
                        tw(outer, {Size = UDim2.new(1, 0, 0, ELEM_H)}, 0.15)
                    end
                end)

                local DropFunc = {}
                function DropFunc:Refresh(newList, keep)
                    options = newList or {}
                    if not keep then selected = nil; headLbl.Text = name end
                    buildOpts(options)
                    if isOpen then
                        local optH = optList.AbsoluteContentSize.Y + 8
                        outer.Size = UDim2.new(1, 0, 0, ELEM_H + 1 + optH)
                    end
                end
                function DropFunc:SetSelected(val)
                    selected     = val
                    headLbl.Text = tostring(name) .. ": " .. tostring(val)
                end
                return DropFunc
            end

            -- ══ NewTextBox ═══════════════════════════════
            function Section:NewTextBox(name, tip, callback)
                callback = callback or function() end
                local row = mkRow(ELEM_H)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size                  = UDim2.new(0.45, -5, 1, 0)
                nameLbl.Position              = UDim2.new(0, 8, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text                  = name or "TextBox"
                nameLbl.Font                  = Enum.Font.GothamSemibold
                nameLbl.TextSize              = 12
                nameLbl.TextColor3            = C.TEXT
                nameLbl.TextXAlignment        = Enum.TextXAlignment.Left
                nameLbl.TextTruncate          = Enum.TextTruncate.AtEnd
                nameLbl.ZIndex                = 5
                nameLbl.Parent                = row

                local inputBg = Instance.new("Frame")
                inputBg.Size             = UDim2.new(0.52, 0, 0, 22)
                inputBg.Position         = UDim2.new(0.47, 0, 0.5, -11)
                inputBg.BackgroundColor3 = C.TAB_BTN
                inputBg.BorderSizePixel  = 0
                inputBg.ZIndex           = 5
                inputBg.Parent           = row
                mkCorner(inputBg, 4)
                mkStroke(inputBg, C.BORDER, 1)

                local tb = Instance.new("TextBox")
                tb.Size                  = UDim2.new(1, -8, 1, 0)
                tb.Position              = UDim2.new(0, 4, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text                  = ""
                tb.PlaceholderText       = tip or "Type..."
                tb.PlaceholderColor3     = C.TEXT_DIM
                tb.Font                  = Enum.Font.Gotham
                tb.TextSize              = 11
                tb.TextColor3            = C.TEXT
                tb.ClearTextOnFocus      = false
                tb.ZIndex                = 6
                tb.Parent                = inputBg

                tb.FocusLost:Connect(function(enter)
                    if enter then
                        pcall(callback, tb.Text)
                        tb.Text = ""
                    end
                end)

                return {}
            end

            -- ══ NewKeybind ═══════════════════════════════
            function Section:NewKeybind(name, tip, defaultKey, callback)
                defaultKey = defaultKey or Enum.KeyCode.F
                callback   = callback   or function() end
                local curKey    = defaultKey
                local listening = false

                local row = mkRowBtn()

                nameLabel(row, name, 70)

                local keyBox = Instance.new("TextLabel")
                keyBox.Size                  = UDim2.new(0, 58, 0, 22)
                keyBox.Position              = UDim2.new(1, -64, 0.5, -11)
                keyBox.BackgroundColor3      = C.TAB_BTN
                keyBox.BackgroundTransparency = 0
                keyBox.Text                  = defaultKey.Name
                keyBox.Font                  = Enum.Font.GothamBold
                keyBox.TextSize              = 11
                keyBox.TextColor3            = C.SCHEME
                keyBox.TextXAlignment        = Enum.TextXAlignment.Center
                keyBox.ZIndex                = 5
                keyBox.Parent                = row
                mkCorner(keyBox, 4)
                mkStroke(keyBox, C.BORDER, 1)

                row.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening     = true
                    keyBox.Text   = "..."
                    keyBox.TextColor3 = C.TEXT_DIM
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, gp)
                        if not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
                            curKey             = inp.KeyCode
                            keyBox.Text        = inp.KeyCode.Name
                            keyBox.TextColor3  = C.SCHEME
                            listening          = false
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

    -- ToggleUI e ChangeColor no objeto Window
    function Window:ToggleUI()
        if _GUI then _GUI.Enabled = not _GUI.Enabled end
    end

    function Window:ChangeColor(prop, color)
        if prop == "SchemeColor" then C.SCHEME = color; C.SL_FILL = color; C.ON_CLR = color end
        if prop == "Background"  then C.WIN_BG = color end
        if prop == "TextColor"   then C.TEXT   = color end
        if prop == "ElementColor" then C.ELEM_BG = color end
    end

    return Window
end -- CreateLib

-- ToggleUI no objeto Library também
function Library:ToggleUI()
    if _GUI then _GUI.Enabled = not _GUI.Enabled end
end

return Library
