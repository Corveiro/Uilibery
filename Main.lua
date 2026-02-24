--[[
    ╔══════════════════════════════════════════════════════╗
    ║   PVP Script UI  —  DARK EDITION                    ║
    ║   Accordion tabs  |  Full API compatível            ║
    ║   Bugs corrigidos: UpdateToggle, ChangeColor        ║
    ╚══════════════════════════════════════════════════════╝
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
        TweenInfo.new(t or 0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p
    ):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color           = col or Color3.fromRGB(38, 38, 38)
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
    t.TextColor3             = col  or Color3.fromRGB(220, 220, 220)
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
-- PALETA — DARK EDITION
------------------------------------------------------------------------
local C = {
    WIN      = Color3.fromRGB(10, 10, 12),      -- janela (quase preto)
    HDR      = Color3.fromRGB(6, 6, 8),          -- header (mais escuro)
    HDR_LINE = Color3.fromRGB(30, 30, 35),       -- linha inferior do header
    ICON     = Color3.fromRGB(200, 130, 20),     -- ícone dourado
    CLOSE    = Color3.fromRGB(185, 32, 32),      -- X vermelho
    TAB_OFF  = Color3.fromRGB(13, 13, 16),       -- tab fechada
    TAB_ON   = Color3.fromRGB(18, 18, 22),       -- tab aberta
    TAB_BAR  = Color3.fromRGB(255, 80, 40),      -- barra lateral da tab ativa
    ELEM     = Color3.fromRGB(16, 16, 20),       -- fundo dos elementos
    ELEM_H   = Color3.fromRGB(22, 22, 28),       -- hover dos elementos
    SEC_BG   = Color3.fromRGB(12, 12, 15),       -- fundo da seção
    SEC_LINE = Color3.fromRGB(255, 80, 40),      -- linha accent da seção
    DIV      = Color3.fromRGB(28, 28, 34),       -- linha divisória
    SL_TR    = Color3.fromRGB(30, 30, 38),       -- trilho do slider
    SL_FILL  = Color3.fromRGB(255, 80, 40),      -- preenchimento do slider
    TXT      = Color3.fromRGB(230, 230, 235),    -- texto principal
    TXT_DIM  = Color3.fromRGB(100, 100, 110),    -- texto secundário / OFF
    TXT_MID  = Color3.fromRGB(160, 160, 170),    -- texto médio
    ON       = Color3.fromRGB(60, 210, 100),     -- ON verde
    OFF_BG   = Color3.fromRGB(20, 20, 26),       -- fundo badge OFF
    ON_BG    = Color3.fromRGB(18, 50, 28),       -- fundo badge ON
    SCHEME   = Color3.fromRGB(255, 80, 40),      -- cor de esquema (laranja/vermelho)
    OPT      = Color3.fromRGB(14, 14, 18),       -- opção de dropdown
    OPT_H    = Color3.fromRGB(22, 22, 28),       -- hover dropdown option
    INP      = Color3.fromRGB(12, 12, 16),       -- input bg
    BTN_ACC  = Color3.fromRGB(255, 80, 40),      -- accent botão
    SCROLL   = Color3.fromRGB(255, 80, 40),      -- scrollbar
}

local _GUI = nil

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    -- suporta tanto Color3 quanto tabela de tema
    if typeof(themeColor) == "Color3" then
        C.SCHEME   = themeColor
        C.SL_FILL  = themeColor
        C.ON       = themeColor
        C.TAB_BAR  = themeColor
        C.SEC_LINE = themeColor
        C.BTN_ACC  = themeColor
        C.SCROLL   = themeColor
    elseif typeof(themeColor) == "table" then
        if themeColor.SchemeColor then
            C.SCHEME   = themeColor.SchemeColor
            C.SL_FILL  = themeColor.SchemeColor
            C.TAB_BAR  = themeColor.SchemeColor
            C.SEC_LINE = themeColor.SchemeColor
            C.BTN_ACC  = themeColor.SchemeColor
            C.SCROLL   = themeColor.SchemeColor
        end
        if themeColor.Background  then C.WIN  = themeColor.Background  end
        if themeColor.Header      then C.HDR  = themeColor.Header      end
        if themeColor.TextColor   then C.TXT  = themeColor.TextColor   end
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
    pcall(function() sg.Parent = game.CoreGui end)
    _GUI = sg

    local W  = 244   -- largura
    local EH = 32    -- altura elementos
    local MH = 460   -- altura max scroll

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
    corner(win, 8)
    stroke(win, C.DIV, 1)

    -- brilho sutil no topo da janela
    local winGlow = Instance.new("Frame")
    winGlow.Size             = UDim2.new(1, -20, 0, 1)
    winGlow.Position         = UDim2.new(0, 10, 0, 0)
    winGlow.BackgroundColor3 = C.SCHEME
    winGlow.BackgroundTransparency = 0.6
    winGlow.BorderSizePixel  = 0
    winGlow.ZIndex           = 20
    winGlow.Parent           = win
    corner(winGlow, 1)

    ----------------------------------------------------------------
    -- HEADER
    ----------------------------------------------------------------
    local hdr = Instance.new("Frame")
    hdr.Name             = "Hdr"
    hdr.Size             = UDim2.new(1, 0, 0, 30)
    hdr.BackgroundColor3 = C.HDR
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 10
    hdr.Parent           = win
    corner(hdr, 8)

    -- tapa arredondamento embaixo do header
    local hfix = Instance.new("Frame")
    hfix.Size             = UDim2.new(1, 0, 0, 10)
    hfix.Position         = UDim2.new(0, 0, 1, -10)
    hfix.BackgroundColor3 = C.HDR
    hfix.BorderSizePixel  = 0
    hfix.ZIndex           = 10
    hfix.Parent           = hdr

    -- linha inferior do header
    local hline = Instance.new("Frame")
    hline.Size             = UDim2.new(1, 0, 0, 1)
    hline.Position         = UDim2.new(0, 0, 1, -1)
    hline.BackgroundColor3 = C.HDR_LINE
    hline.BorderSizePixel  = 0
    hline.ZIndex           = 11
    hline.Parent           = hdr

    -- ponto laranja (ícone)
    local ico = Instance.new("Frame")
    ico.Size             = UDim2.new(0, 10, 0, 10)
    ico.Position         = UDim2.new(0, 11, 0.5, -5)
    ico.BackgroundColor3 = C.ICON
    ico.BorderSizePixel  = 0
    ico.ZIndex           = 12
    ico.Parent           = hdr
    corner(ico, 5)

    -- título
    local titleLbl = lbl(hdr, title or "PVP Script", 11, C.TXT, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 11)
    titleLbl.Size     = UDim2.new(1, -60, 1, 0)
    titleLbl.Position = UDim2.new(0, 28, 0, 0)

    -- botão X
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size             = UDim2.new(0, 18, 0, 18)
    closeBtn.Position         = UDim2.new(1, -26, 0.5, -9)
    closeBtn.BackgroundColor3 = C.CLOSE
    closeBtn.BorderSizePixel  = 0
    closeBtn.Text             = "✕"
    closeBtn.Font             = Enum.Font.GothamBold
    closeBtn.TextSize         = 9
    closeBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    closeBtn.AutoButtonColor  = false
    closeBtn.ZIndex           = 12
    closeBtn.Parent           = hdr
    corner(closeBtn, 4)

    closeBtn.MouseEnter:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.08) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, {BackgroundColor3 = C.CLOSE}, 0.08) end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win, {Size = UDim2.new(0, W, 0, 0)}, 0.18)
        task.delay(0.2, function() sg:Destroy() end)
    end)

    draggable(hdr, win)

    ----------------------------------------------------------------
    -- SCROLL
    ----------------------------------------------------------------
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name                  = "Scroll"
    scroll.Position              = UDim2.new(0, 0, 0, 30)
    scroll.Size                  = UDim2.new(1, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel       = 0
    scroll.ScrollBarThickness    = 2
    scroll.ScrollBarImageColor3  = C.SCROLL
    scroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    scroll.ScrollingDirection    = Enum.ScrollingDirection.Y
    scroll.ClipsDescendants      = true
    scroll.Parent                = win

    local scrollLL = list(scroll, 0)
    pad(scroll, 3, 6, 0, 0)

    local function refreshH()
        local h = math.min(scrollLL.AbsoluteContentSize.Y + 9, MH)
        win.Size    = UDim2.new(0, W, 0, h + 30)
        scroll.Size = UDim2.new(1, 0, 0, h)
    end
    scrollLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshH)

    ----------------------------------------------------------------
    -- Window:NewTab — accordion
    ----------------------------------------------------------------
    local Window = {}

    function Window:NewTab(tabName)
        tabName = tabName or "Tab"

        local wrap = Instance.new("Frame")
        wrap.Name                   = "T_" .. tabName
        wrap.Size                   = UDim2.new(1, 0, 0, 32)
        wrap.BackgroundTransparency = 1
        wrap.BorderSizePixel        = 0
        wrap.ClipsDescendants       = true
        wrap.Parent                 = scroll
        list(wrap, 0)

        -- ── Botão da tab ──────────────────────────────────────
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = C.TAB_OFF
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Text             = ""
        btn.ZIndex           = 5
        btn.Parent           = wrap

        -- barra lateral accent (aparece quando aberto)
        local tabBar = Instance.new("Frame")
        tabBar.Size             = UDim2.new(0, 2, 0, 16)
        tabBar.Position         = UDim2.new(0, 0, 0.5, -8)
        tabBar.BackgroundColor3 = C.TAB_BAR
        tabBar.BackgroundTransparency = 1
        tabBar.BorderSizePixel  = 0
        tabBar.ZIndex           = 7
        tabBar.Parent           = btn
        corner(tabBar, 1)

        -- seta
        local arrLbl = lbl(btn, "▶", 8, C.TXT_DIM, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 6)
        arrLbl.Size     = UDim2.new(0, 16, 1, 0)
        arrLbl.Position = UDim2.new(0, 10, 0, 0)

        -- nome da tab
        local tNameLbl = lbl(btn, tabName, 11, C.TXT_MID, Enum.TextXAlignment.Left, Enum.Font.GothamBold, 6)
        tNameLbl.Size     = UDim2.new(1, -34, 1, 0)
        tNameLbl.Position = UDim2.new(0, 26, 0, 0)

        -- linha divisória inferior
        local tDiv = Instance.new("Frame")
        tDiv.Size             = UDim2.new(1, 0, 0, 1)
        tDiv.BackgroundColor3 = C.DIV
        tDiv.BorderSizePixel  = 0
        tDiv.ZIndex           = 5
        tDiv.Parent           = wrap

        -- ── Corpo da tab ──────────────────────────────────────
        local body = Instance.new("Frame")
        body.Size                   = UDim2.new(1, 0, 0, 0)
        body.BackgroundTransparency = 1
        body.BorderSizePixel        = 0
        body.ClipsDescendants       = false
        body.Parent                 = wrap

        local bodyLL = list(body, 2)
        pad(body, 4, 4, 5, 5)

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
            if not isOpen then
                tween(btn, {BackgroundColor3 = C.TAB_ON}, 0.08)
                tween(tNameLbl, {TextColor3 = C.TXT}, 0.08)
            end
        end)
        btn.MouseLeave:Connect(function()
            if not isOpen then
                tween(btn, {BackgroundColor3 = C.TAB_OFF}, 0.08)
                tween(tNameLbl, {TextColor3 = C.TXT_MID}, 0.08)
            end
        end)

        btn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                arrLbl.Text    = "▼"
                arrLbl.TextColor3 = C.SCHEME
                tNameLbl.TextColor3 = C.TXT
                btn.BackgroundColor3 = C.TAB_ON
                tween(tabBar, {BackgroundTransparency = 0}, 0.12)
                local h = bodyH()
                tween(body, {Size = UDim2.new(1, 0, 0, h)}, 0.18)
                tween(wrap, {Size = UDim2.new(1, 0, 0, 33 + h)}, 0.18)
            else
                arrLbl.Text    = "▶"
                arrLbl.TextColor3 = C.TXT_DIM
                tNameLbl.TextColor3 = C.TXT_MID
                btn.BackgroundColor3 = C.TAB_OFF
                tween(tabBar, {BackgroundTransparency = 1}, 0.12)
                tween(body, {Size = UDim2.new(1, 0, 0, 0)}, 0.14)
                tween(wrap, {Size = UDim2.new(1, 0, 0, 32)}, 0.14)
            end
        end)

        ------------------------------------------------------------
        -- Tab:NewSection
        ------------------------------------------------------------
        local Tab = {}

        function Tab:NewSection(secName)
            secName = secName or "Section"

            -- Frame da seção com fundo ligeiramente mais claro
            local secWrap = Instance.new("Frame")
            secWrap.Size             = UDim2.new(1, 0, 0, 20)
            secWrap.BackgroundColor3 = C.SEC_BG
            secWrap.BorderSizePixel  = 0
            secWrap.Parent           = body
            corner(secWrap, 4)
            stroke(secWrap, C.DIV, 1)

            -- linha accent à esquerda
            local secAccent = Instance.new("Frame")
            secAccent.Size             = UDim2.new(0, 2, 0, 10)
            secAccent.Position         = UDim2.new(0, 0, 0.5, -5)
            secAccent.BackgroundColor3 = C.SEC_LINE
            secAccent.BorderSizePixel  = 0
            secAccent.ZIndex           = 5
            secAccent.Parent           = secWrap
            corner(secAccent, 1)

            -- nome da seção
            local sLbl = lbl(secWrap, secName, 10, C.TXT_MID, Enum.TextXAlignment.Left, Enum.Font.GothamBold, 5)
            sLbl.Size     = UDim2.new(1, -14, 1, 0)
            sLbl.Position = UDim2.new(0, 10, 0, 0)
            sLbl.TextTruncate = Enum.TextTruncate.AtEnd

            ----------------------------------------------------------
            -- Helpers internos
            ----------------------------------------------------------
            local Section = {}

            local function mkFrame(h)
                local f = Instance.new("Frame")
                f.Size             = UDim2.new(1, 0, 0, h or EH)
                f.BackgroundColor3 = C.ELEM
                f.BorderSizePixel  = 0
                f.Parent           = body
                corner(f, 5)
                stroke(f, C.DIV, 1)
                return f
            end

            local function mkBtn(h)
                local b = Instance.new("TextButton")
                b.Size             = UDim2.new(1, 0, 0, h or EH)
                b.BackgroundColor3 = C.ELEM
                b.BorderSizePixel  = 0
                b.AutoButtonColor  = false
                b.Text             = ""
                b.ZIndex           = 4
                b.Parent           = body
                corner(b, 5)
                stroke(b, C.DIV, 1)
                b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = C.ELEM_H}, 0.08) end)
                b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = C.ELEM}, 0.08) end)
                return b
            end

            local function mkName(parent, text, rightOff)
                local l = lbl(parent, text, 11, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 5)
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
                mkName(row, name, 54)

                -- badge container
                local badgeBg = Instance.new("Frame")
                badgeBg.Size             = UDim2.new(0, 38, 0, 20)
                badgeBg.Position         = UDim2.new(1, -44, 0.5, -10)
                badgeBg.BackgroundColor3 = C.OFF_BG
                badgeBg.BorderSizePixel  = 0
                badgeBg.ZIndex           = 5
                badgeBg.Parent           = row
                corner(badgeBg, 5)
                stroke(badgeBg, C.DIV, 1)

                local badge = lbl(badgeBg, "OFF", 10, C.TXT_DIM, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 6)
                badge.Size = UDim2.new(1, 0, 1, 0)

                local function setState(v)
                    on = v
                    if on then
                        badge.Text       = "ON"
                        badge.TextColor3 = C.ON
                        tween(badgeBg, {BackgroundColor3 = C.ON_BG}, 0.12)
                    else
                        badge.Text       = "OFF"
                        badge.TextColor3 = C.TXT_DIM
                        tween(badgeBg, {BackgroundColor3 = C.OFF_BG}, 0.12)
                    end
                end

                row.MouseButton1Click:Connect(function()
                    setState(not on)
                    pcall(callback, on)
                end)

                local T = {}
                -- FIX: suporta UpdateToggle(bool) E UpdateToggle(nil, bool)
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
                local row = mkBtn()

                -- fundo accent sutil no hover
                local nl = lbl(row, name, 11, C.TXT, Enum.TextXAlignment.Center, Enum.Font.GothamSemibold, 5)
                nl.Size     = UDim2.new(1, -16, 1, 0)
                nl.Position = UDim2.new(0, 8, 0, 0)

                -- linha accent no bottom do botão
                local bLine = Instance.new("Frame")
                bLine.Size             = UDim2.new(0, 0, 0, 1)
                bLine.Position         = UDim2.new(0, 0, 1, -1)
                bLine.BackgroundColor3 = C.SCHEME
                bLine.BorderSizePixel  = 0
                bLine.ZIndex           = 5
                bLine.Parent           = row
                corner(bLine, 1)

                row.MouseEnter:Connect(function()
                    tween(bLine, {Size = UDim2.new(1, 0, 0, 1)}, 0.15)
                    tween(nl, {TextColor3 = C.SCHEME}, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    tween(bLine, {Size = UDim2.new(0, 0, 0, 1)}, 0.12)
                    tween(nl, {TextColor3 = C.TXT}, 0.1)
                end)

                row.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)

                local B = {}
                function B:UpdateButton(t) nl.Text = t or name end
                return B
            end

            --------------------------------------------------------
            -- NewLabel
            --------------------------------------------------------
            function Section:NewLabel(text)
                local row = mkFrame(26)

                local nl = lbl(row, text, 11, C.TXT_MID, Enum.TextXAlignment.Left, Enum.Font.Gotham, 5)
                nl.Size        = UDim2.new(1, -14, 0, 26)
                nl.Position    = UDim2.new(0, 9, 0, 0)
                nl.TextWrapped = true

                nl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h = math.max(26, nl.TextBounds.Y + 10)
                    row.Size = UDim2.new(1, 0, 0, h)
                    nl.Size  = UDim2.new(1, -14, 0, h)
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

                local row = mkFrame(48)

                local nLbl = lbl(row, (name or "Slider") .. ": " .. tostring(cur), 11, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 5)
                nLbl.Size     = UDim2.new(1, -14, 0, 20)
                nLbl.Position = UDim2.new(0, 9, 0, 4)

                -- trilho
                local track = Instance.new("Frame")
                track.Size             = UDim2.new(1, -18, 0, 5)
                track.Position         = UDim2.new(0, 9, 0, 32)
                track.BackgroundColor3 = C.SL_TR
                track.BorderSizePixel  = 0
                track.ZIndex           = 5
                track.Parent           = row
                corner(track, 3)

                -- preenchimento
                local fill = Instance.new("Frame")
                fill.Size             = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = C.SL_FILL
                fill.BorderSizePixel  = 0
                fill.ZIndex           = 6
                fill.Parent           = track
                corner(fill, 3)

                -- handle (bolinha no final)
                local handle = Instance.new("Frame")
                handle.Size             = UDim2.new(0, 9, 0, 9)
                handle.AnchorPoint      = Vector2.new(0.5, 0.5)
                handle.Position         = UDim2.new(0, 0, 0.5, 0)
                handle.BackgroundColor3 = C.TXT
                handle.BorderSizePixel  = 0
                handle.ZIndex           = 8
                handle.Parent           = track
                corner(handle, 5)

                -- área de captura
                local grab = Instance.new("TextButton")
                grab.Size               = UDim2.new(1, 0, 0, 24)
                grab.Position           = UDim2.new(0, 0, 0.5, -12)
                grab.BackgroundTransparency = 1
                grab.Text               = ""
                grab.ZIndex             = 9
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
                    handle.Position = UDim2.new(pct, 0, 0.5, 0)
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

                local outer = Instance.new("Frame")
                outer.Name             = "DD"
                outer.Size             = UDim2.new(1, 0, 0, EH)
                outer.BackgroundColor3 = C.ELEM
                outer.BorderSizePixel  = 0
                outer.ClipsDescendants = true
                outer.ZIndex           = 6
                outer.Parent           = body
                corner(outer, 5)
                stroke(outer, C.DIV, 1)

                local dHead = Instance.new("TextButton")
                dHead.Size               = UDim2.new(1, 0, 0, EH)
                dHead.BackgroundTransparency = 1
                dHead.BorderSizePixel    = 0
                dHead.AutoButtonColor    = false
                dHead.Text               = ""
                dHead.ZIndex             = 7
                dHead.Parent             = outer

                local dLbl = lbl(dHead, name or "Dropdown", 11, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 8)
                dLbl.Size     = UDim2.new(1, -30, 1, 0)
                dLbl.Position = UDim2.new(0, 10, 0, 0)

                local dArr = lbl(dHead, "▶", 8, C.TXT_DIM, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 8)
                dArr.Size     = UDim2.new(0, 16, 1, 0)
                dArr.Position = UDim2.new(1, -20, 0, 0)

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

                local optLL = list(optBox, 2)
                pad(optBox, 3, 3, 4, 4)

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
                        corner(ob, 4)

                        ob.MouseEnter:Connect(function()
                            tween(ob, {BackgroundColor3 = C.OPT_H}, 0.07)
                            tween(ob, {TextColor3 = C.TXT}, 0.07)
                        end)
                        ob.MouseLeave:Connect(function()
                            tween(ob, {BackgroundColor3 = C.OPT}, 0.07)
                            tween(ob, {TextColor3 = C.TXT_MID}, 0.07)
                        end)

                        ob.MouseButton1Click:Connect(function()
                            dLbl.Text = tostring(name) .. ": " .. tostring(opt)
                            isOpen    = false
                            dArr.Text = "▶"
                            dArr.TextColor3 = C.TXT_DIM
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
                        dArr.Text = "▼"
                        dArr.TextColor3 = C.SCHEME
                        local oh = optLL.AbsoluteContentSize.Y + 8
                        tween(outer, {Size = UDim2.new(1, 0, 0, EH + 1 + oh)}, 0.17)
                    else
                        dArr.Text = "▶"
                        dArr.TextColor3 = C.TXT_DIM
                        tween(outer, {Size = UDim2.new(1, 0, 0, EH)}, 0.14)
                    end
                end)

                local D = {}
                function D:Refresh(newList, keep)
                    options = newList or {}
                    if not keep then dLbl.Text = name end
                    buildOpts(options)
                    if isOpen then
                        local oh = optLL.AbsoluteContentSize.Y + 8
                        outer.Size = UDim2.new(1, 0, 0, EH + 1 + oh)
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

                local nLbl = lbl(row, name, 11, C.TXT, Enum.TextXAlignment.Left, Enum.Font.GothamSemibold, 5)
                nLbl.Size     = UDim2.new(0.44, 0, 1, 0)
                nLbl.Position = UDim2.new(0, 9, 0, 0)
                nLbl.TextTruncate = Enum.TextTruncate.AtEnd

                local inBg = Instance.new("Frame")
                inBg.Size             = UDim2.new(0.51, 0, 0, 22)
                inBg.Position         = UDim2.new(0.47, 0, 0.5, -11)
                inBg.BackgroundColor3 = C.INP
                inBg.BorderSizePixel  = 0
                inBg.ZIndex           = 5
                inBg.Parent           = row
                corner(inBg, 4)
                stroke(inBg, C.DIV, 1)

                local tb = Instance.new("TextBox")
                tb.Size                   = UDim2.new(1, -8, 1, 0)
                tb.Position               = UDim2.new(0, 4, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text                   = ""
                tb.PlaceholderText        = tip or "Type..."
                tb.PlaceholderColor3      = C.TXT_DIM
                tb.Font                   = Enum.Font.Gotham
                tb.TextSize               = 11
                tb.TextColor3             = C.TXT
                tb.ClearTextOnFocus       = false
                tb.ZIndex                 = 6
                tb.Parent                 = inBg

                tb.Focused:Connect(function() tween(inBg, {BackgroundColor3 = C.ELEM_H}, 0.1) end)
                tb.FocusLost:Connect(function(enter)
                    tween(inBg, {BackgroundColor3 = C.INP}, 0.1)
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

                local kFrame = Instance.new("Frame")
                kFrame.Size             = UDim2.new(0, 58, 0, 20)
                kFrame.Position         = UDim2.new(1, -64, 0.5, -10)
                kFrame.BackgroundColor3 = C.INP
                kFrame.BorderSizePixel  = 0
                kFrame.ZIndex           = 5
                kFrame.Parent           = row
                corner(kFrame, 4)
                stroke(kFrame, C.DIV, 1)

                local kLbl = lbl(kFrame, defaultKey.Name, 10, C.SCHEME, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 6)
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

    -- FIX: aceita tanto (prop, color) quanto tabela de tema
    function Window:ChangeColor(propOrTable, color)
        if typeof(propOrTable) == "table" then
            local t = propOrTable
            if t.SchemeColor  then C.SCHEME = t.SchemeColor; C.SL_FILL = t.SchemeColor; C.ON = t.SchemeColor end
            if t.Background   then C.WIN    = t.Background  end
            if t.TextColor    then C.TXT    = t.TextColor   end
            if t.ElementColor then C.ELEM   = t.ElementColor end
        elseif typeof(propOrTable) == "string" then
            if propOrTable == "SchemeColor" then C.SCHEME = color; C.SL_FILL = color; C.ON = color
            elseif propOrTable == "Background"   then C.WIN  = color
            elseif propOrTable == "TextColor"    then C.TXT  = color
            elseif propOrTable == "ElementColor" then C.ELEM = color
            end
        end
    end

    return Window
end

----------------------------------------------------------------
-- ToggleUI no próprio Library
----------------------------------------------------------------
function Library:ToggleUI()
    if _GUI then _GUI.Enabled = not _GUI.Enabled end
end

return Library
