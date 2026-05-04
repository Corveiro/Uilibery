-- ╔══════════════════════════════════════════════════╗
-- ║           RenLib — UI Library v1.0              ║
-- ║     Clean Dark · Vertical Tabs · All Elements   ║
-- ╚══════════════════════════════════════════════════╝

local RenLib = {}
RenLib.__index = RenLib

-- ── Serviços ──────────────────────────────────────────────────────────────────
local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")

local player         = Players.LocalPlayer
local mouse          = player:GetMouse()

-- ── Paleta (apenas preto / cinza / branco) ────────────────────────────────────
local C = {
    bg          = Color3.fromRGB(10,  10,  10),   -- fundo principal
    sidebar     = Color3.fromRGB(14,  14,  14),   -- sidebar
    panel       = Color3.fromRGB(18,  18,  18),   -- painel de conteúdo
    element     = Color3.fromRGB(22,  22,  22),   -- fundo dos elementos
    elementHov  = Color3.fromRGB(28,  28,  28),   -- hover
    tabActive   = Color3.fromRGB(30,  30,  30),   -- aba ativa
    stroke      = Color3.fromRGB(50,  50,  50),   -- borda sutil
    strokeLight = Color3.fromRGB(70,  70,  70),
    textMain    = Color3.fromRGB(230, 230, 230),  -- texto principal
    textSub     = Color3.fromRGB(140, 140, 140),  -- texto secundário / descrição
    textMuted   = Color3.fromRGB(80,  80,  80),   -- separadores / muted
    toggleOff   = Color3.fromRGB(45,  45,  45),
    toggleOn    = Color3.fromRGB(210, 210, 210),
    thumb       = Color3.fromRGB(230, 230, 230),
    sliderTrack = Color3.fromRGB(40,  40,  40),
    sliderFill  = Color3.fromRGB(160, 160, 160),
    white       = Color3.fromRGB(255, 255, 255),
    notif       = Color3.fromRGB(12,  12,  12),
}

local CORNER   = UDim.new(0, 6)
local CORNER4  = UDim.new(0, 4)
local CORNER10 = UDim.new(0, 10)

-- ── Helpers ───────────────────────────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or CORNER
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.stroke
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent = parent
    return p
end

local function listLayout(parent, dir, spacing, halign, valign)
    local l = Instance.new("UIListLayout")
    l.FillDirection      = dir     or Enum.FillDirection.Vertical
    l.Padding            = UDim.new(0, spacing or 6)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
    l.SortOrder          = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function label(parent, text, size, color, halign, xsize, ysize)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 13
    l.Font = Enum.Font.GothamMedium
    l.TextColor3 = color or C.textMain
    l.TextXAlignment = halign or Enum.TextXAlignment.Left
    l.Size = UDim2.new(xsize or 1, 0, ysize or 1, 0)
    l.Parent = parent
    return l
end

local function frame(parent, size, pos, color, transp)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1,0,1,0)
    f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or C.element
    f.BackgroundTransparency = transp or 0
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

-- ── Drag ──────────────────────────────────────────────────────────────────────
local function makeDraggable(handle, target)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos  = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═════════════════════════════════════════════════════════════════════════════
-- CRIAR JANELA
-- ═════════════════════════════════════════════════════════════════════════════
function RenLib:CreateWindow(opts)
    opts = opts or {}
    local title    = opts.Title    or "RenLib"
    local subtitle = opts.SubTitle or "v1.0"

    -- ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = "RenLibGui"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    sg.Parent = gethui and gethui() or player:WaitForChild("PlayerGui")

    -- Main Frame
    local main = frame(sg, UDim2.new(0,420,0,340), UDim2.new(0.5,-210,0.5,-170), C.bg, 0.20)
    corner(main)
    stroke(main, C.stroke, 1)

    -- Título
    local titleBar = frame(main, UDim2.new(1,0,0,38), nil, C.sidebar, 0)
    corner(titleBar, UDim.new(0,6))
    -- Cobre cantos inferiores do titleBar
    local titleBarFix = frame(main, UDim2.new(1,0,0,8), UDim2.new(0,0,0,30), C.sidebar, 0)
    titleBarFix.ZIndex = titleBar.ZIndex

    local titleLabel = label(titleBar, title, 14, C.textMain, Enum.TextXAlignment.Left)
    titleLabel.Size = UDim2.new(1,-90,1,0)
    padding(titleLabel, 0,0,14,0)

    local subLabel = label(titleBar, subtitle, 11, C.textSub, Enum.TextXAlignment.Right)
    subLabel.Size = UDim2.new(1,-14,1,0)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,22,0,22)
    closeBtn.Position = UDim2.new(1,-32,0.5,-11)
    closeBtn.BackgroundColor3 = C.element
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = C.textSub
    closeBtn.TextSize = 11
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    corner(closeBtn, UDim.new(0,4))
    closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

    makeDraggable(titleBar, main)

    -- Layout principal (sidebar + conteúdo)
    local body = frame(main, UDim2.new(1,0,1,-38), UDim2.new(0,0,0,38), C.bg, 1)

    -- Sidebar
    local sidebar = frame(body, UDim2.new(0,110,1,0), nil, C.sidebar, 0)
    -- arredonda só o canto inferior esquerdo
    corner(sidebar, UDim.new(0,6))
    local sidebarFix = frame(body, UDim2.new(0,8,1,0), UDim2.new(0,102,0,0), C.sidebar, 0)

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1,0,1,-8)
    tabList.Position = UDim2.new(0,0,0,8)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0,0,0,0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = sidebar
    listLayout(tabList, Enum.FillDirection.Vertical, 2)
    padding(tabList, 4,4,6,6)

    -- Painel de conteúdo
    local contentArea = frame(body, UDim2.new(1,-116,1,-8), UDim2.new(0,113,0,4), C.panel, 0)
    corner(contentArea, UDim.new(0,6))
    stroke(contentArea, C.stroke, 1)

    -- Window object
    local Window = {}
    Window._tabs = {}
    Window._activeTab = nil
    Window._tabBtns = {}
    Window._sg = sg

    -- ── AddTab ────────────────────────────────────────────────────────────────
    function Window:AddTab(topts)
        topts = topts or {}
        local tname = topts.Name or "Tab"
        local ticon = topts.Icon or ""

        -- Botão da aba
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,0,0,32)
        tabBtn.BackgroundColor3 = C.sidebar
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        corner(tabBtn, UDim.new(0,4))

        local tabInner = Instance.new("Frame")
        tabInner.Size = UDim2.new(1,0,1,0)
        tabInner.BackgroundTransparency = 1
        tabInner.Parent = tabBtn
        listLayout(tabInner, Enum.FillDirection.Horizontal, 6, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
        padding(tabInner, 0,0,10,0)

        if ticon ~= "" then
            local ico = Instance.new("ImageLabel")
            ico.Size = UDim2.new(0,14,0,14)
            ico.BackgroundTransparency = 1
            ico.Image = ticon
            ico.ImageColor3 = C.textSub
            ico.Parent = tabInner
        end

        local tabLbl = label(tabInner, tname, 12, C.textSub, Enum.TextXAlignment.Left, 0, 1)
        tabLbl.Size = UDim2.new(1,0,1,0)
        tabLbl.AutomaticSize = Enum.AutomaticSize.X

        -- Scroll de conteúdo
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1,0,1,0)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = C.stroke
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = contentArea
        listLayout(scroll, Enum.FillDirection.Vertical, 4)
        padding(scroll, 6,6,8,8)

        -- Registrar
        local tabIdx = #Window._tabs + 1
        Window._tabs[tabIdx]   = scroll
        Window._tabBtns[tabIdx] = tabBtn

        local function activate()
            for i, s in ipairs(Window._tabs) do
                s.Visible = false
                tween(Window._tabBtns[i], {BackgroundTransparency=1}, 0.12)
                -- ícone e label ficam cinza
            end
            scroll.Visible = true
            tween(tabBtn, {BackgroundTransparency=0, BackgroundColor3=C.tabActive}, 0.12)
            tabLbl.TextColor3 = C.textMain
            Window._activeTab = tabIdx
        end

        tabBtn.MouseButton1Click:Connect(activate)
        tabBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= tabIdx then
                tween(tabBtn, {BackgroundTransparency=0.5, BackgroundColor3=C.elementHov}, 0.1)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= tabIdx then
                tween(tabBtn, {BackgroundTransparency=1}, 0.1)
            end
        end)

        if tabIdx == 1 then activate() end

        -- ── Tab object ────────────────────────────────────────────────────────
        local Tab = {}

        -- Elemento base
        local function makeElement(h)
            local el = frame(scroll, UDim2.new(1,0,0,h or 36), nil, C.element, 0)
            corner(el)
            stroke(el, C.stroke, 1)
            return el
        end

        -- ── AddSection ──────────────────────────────────────────────────────
        function Tab:AddSection(name)
            local sec = frame(scroll, UDim2.new(1,0,0,20), nil, C.panel, 1)

            local line = frame(sec, UDim2.new(1,-10,0,1), UDim2.new(0,5,0.5,0), C.strokeLight, 0)

            local bg = frame(sec, UDim2.new(0,0,1,0), UDim2.new(0.5,0,0,0), C.panel, 1)
            bg.AutomaticSize = Enum.AutomaticSize.X
            local lbl = label(bg, string.upper(name), 10, C.textMuted, Enum.TextXAlignment.Center)
            lbl.AutomaticSize = Enum.AutomaticSize.X
            lbl.Size = UDim2.new(0,0,1,0)
            padding(lbl, 0,0,6,6)
            bg.Position = UDim2.new(0.5,-40,0,0)
        end

        -- ── AddLabel ────────────────────────────────────────────────────────
        function Tab:AddLabel(opts2)
            opts2 = opts2 or {}
            local lbl = frame(scroll, UDim2.new(1,0,0,26), nil, C.panel, 1)
            local txt = label(lbl, opts2.Text or "", 12, C.textSub)
            padding(txt, 0,0,4,0)
            return lbl
        end

        -- ── AddSeparator ────────────────────────────────────────────────────
        function Tab:AddSeparator()
            local sep = frame(scroll, UDim2.new(1,0,0,1), nil, C.stroke, 0)
            return sep
        end

        -- ── AddToggle ───────────────────────────────────────────────────────
        function Tab:AddToggle(opts2)
            opts2 = opts2 or {}
            local hasDesc = opts2.Description and opts2.Description ~= ""
            local elH = hasDesc and 48 or 34
            local el = makeElement(elH)
            padding(el, 0,0,10,10)

            local value = opts2.Default or false

            -- Textos
            local textCol = frame(el, UDim2.new(1,-50,1,0), nil, C.panel, 1)
            label(textCol, opts2.Name or "Toggle", 13, C.textMain)
            if hasDesc then
                local desc = label(textCol, opts2.Description, 11, C.textSub)
                desc.Position = UDim2.new(0,0,0,18)
                desc.Size = UDim2.new(1,0,0,14)
            end

            -- Track
            local track = frame(el, UDim2.new(0,34,0,18), UDim2.new(1,-44,0.5,-9), value and C.toggleOn or C.toggleOff, 0)
            corner(track, UDim.new(1,0))

            -- Thumb
            local thumb = frame(track, UDim2.new(0,14,0,14), UDim2.new(0, value and 16 or 2, 0.5,-7), C.thumb, 0)
            corner(thumb, UDim.new(1,0))

            local obj = {Value = value}

            local function setVal(v, cb)
                obj.Value = v
                tween(track, {BackgroundColor3 = v and C.toggleOn or C.toggleOff}, 0.15)
                tween(thumb, {Position = UDim2.new(0, v and 16 or 2, 0.5,-7)}, 0.15)
                if cb ~= false and opts2.Callback then
                    pcall(opts2.Callback, v)
                end
            end

            function obj:Set(v) setVal(v, true) end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = el
            btn.MouseButton1Click:Connect(function() setVal(not obj.Value) end)

            return obj
        end

        -- ── AddButton ───────────────────────────────────────────────────────
        function Tab:AddButton(opts2)
            opts2 = opts2 or {}
            local hasDesc = opts2.Description and opts2.Description ~= ""
            local elH = hasDesc and 48 or 34
            local el = makeElement(elH)
            padding(el, 0,0,10,10)

            local textCol = frame(el, UDim2.new(1,-0,1,0), nil, C.panel, 1)
            local lbl = label(textCol, opts2.Name or "Button", 13, C.textMain, Enum.TextXAlignment.Left)
            if hasDesc then
                local desc = label(textCol, opts2.Description, 11, C.textSub)
                desc.Position = UDim2.new(0,0,0,18)
                desc.Size = UDim2.new(1,0,0,14)
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = el
            btn.AutoButtonColor = false

            btn.MouseEnter:Connect(function()
                tween(el, {BackgroundColor3 = C.elementHov}, 0.1)
            end)
            btn.MouseLeave:Connect(function()
                tween(el, {BackgroundColor3 = C.element}, 0.1)
            end)
            btn.MouseButton1Down:Connect(function()
                tween(el, {BackgroundColor3 = C.strokeLight}, 0.08)
            end)
            btn.MouseButton1Up:Connect(function()
                tween(el, {BackgroundColor3 = C.elementHov}, 0.08)
            end)
            btn.MouseButton1Click:Connect(function()
                if opts2.Callback then pcall(opts2.Callback) end
            end)

            local obj = {}
            function obj:SetText(t) lbl.Text = t end
            return obj
        end

        -- ── AddSlider ───────────────────────────────────────────────────────
        function Tab:AddSlider(opts2)
            opts2 = opts2 or {}
            local hasDesc = opts2.Description and opts2.Description ~= ""
            local elH = hasDesc and 58 or 46
            local el = makeElement(elH)
            padding(el, 6,6,10,10)

            local minV = opts2.Min or 0
            local maxV = opts2.Max or 100
            local inc  = opts2.Increment or 1
            local val  = math.clamp(opts2.Default or minV, minV, maxV)

            local top = frame(el, UDim2.new(1,0,0,16), nil, C.panel, 1)
            label(top, opts2.Name or "Slider", 13, C.textMain)
            local valLbl = label(top, tostring(val), 12, C.textSub, Enum.TextXAlignment.Right)

            if hasDesc then
                local desc = label(el, opts2.Description, 11, C.textSub)
                desc.Position = UDim2.new(0,0,0,18)
                desc.Size = UDim2.new(1,0,0,12)
            end

            local trackY = hasDesc and 36 or 28
            local trackF = frame(el, UDim2.new(1,0,0,5), UDim2.new(0,0,0,trackY), C.sliderTrack, 0)
            corner(trackF, UDim.new(1,0))

            local pct = (val - minV) / (maxV - minV)
            local fillF = frame(trackF, UDim2.new(pct,0,1,0), nil, C.sliderFill, 0)
            corner(fillF, UDim.new(1,0))

            local thumb = frame(trackF, UDim2.new(0,10,0,10), UDim2.new(pct,0,0.5,-5), C.thumb, 0)
            corner(thumb, UDim.new(1,0))

            local obj = {Value = val}

            local function setVal(v, cb)
                v = math.clamp(math.round((v - minV) / inc) * inc + minV, minV, maxV)
                obj.Value = v
                local p = (v - minV) / (maxV - minV)
                valLbl.Text = tostring(v)
                tween(fillF, {Size = UDim2.new(p,0,1,0)}, 0.05)
                tween(thumb, {Position = UDim2.new(p,-5,0.5,-5)}, 0.05)
                if cb ~= false and opts2.Callback then pcall(opts2.Callback, v) end
            end

            function obj:Set(v) setVal(v, true) end

            local dragging = false
            local function updateFromInput(i)
                local absPos = trackF.AbsolutePosition.X
                local absSize = trackF.AbsoluteSize.X
                local p = math.clamp((i.Position.X - absPos) / absSize, 0, 1)
                setVal(minV + p * (maxV - minV))
            end

            thumb.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            trackF.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; updateFromInput(i)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    updateFromInput(i)
                end
            end)

            return obj
        end

        -- ── AddDropdown ─────────────────────────────────────────────────────
        function Tab:AddDropdown(opts2)
            opts2 = opts2 or {}
            local hasDesc = opts2.Description and opts2.Description ~= ""
            local elH = hasDesc and 52 or 38
            local el = makeElement(elH)
            padding(el, 6,6,10,10)

            local options = opts2.Options or {}
            local selected = opts2.Default or (options[1] or "")

            local top = frame(el, UDim2.new(1,0,0,14), nil, C.panel, 1)
            label(top, opts2.Name or "Dropdown", 13, C.textMain)
            if hasDesc then
                local desc = label(el, opts2.Description, 11, C.textSub)
                desc.Position = UDim2.new(0,0,0,16)
                desc.Size = UDim2.new(1,0,0,12)
            end

            local dropY = hasDesc and 30 or 18
            local box = frame(el, UDim2.new(1,0,0,18), UDim2.new(0,0,0,dropY), C.sliderTrack, 0)
            corner(box, UDim.new(0,4))
            stroke(box, C.strokeLight, 1)
            padding(box, 0,0,6,6)

            local selLbl = label(box, selected, 12, C.textMain)
            local arrow = label(box, "▾", 11, C.textSub, Enum.TextXAlignment.Right)

            -- Lista dropdown (aparece fora do frame)
            local listFrame = frame(sg, UDim2.new(0,0,0,0), nil, C.element, 0)
            listFrame.ZIndex = 100
            listFrame.Visible = false
            corner(listFrame, UDim.new(0,4))
            stroke(listFrame, C.strokeLight, 1)

            local listScroll = Instance.new("ScrollingFrame")
            listScroll.Size = UDim2.new(1,0,1,0)
            listScroll.BackgroundTransparency = 1
            listScroll.ScrollBarThickness = 2
            listScroll.ScrollBarImageColor3 = C.stroke
            listScroll.CanvasSize = UDim2.new(0,0,0,0)
            listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            listScroll.Parent = listFrame
            listLayout(listScroll, Enum.FillDirection.Vertical, 1)
            padding(listScroll, 4,4,4,4)

            local obj = {Value = selected}
            local open = false

            local function closeList()
                open = false
                tween(listFrame, {Size = UDim2.new(0, listFrame.AbsoluteSize.X, 0, 0)}, 0.12)
                task.delay(0.13, function() listFrame.Visible = false end)
                arrow.Text = "▾"
            end

            local function buildList()
                for _, c2 in pairs(listScroll:GetChildren()) do
                    if not c2:IsA("UIListLayout") and not c2:IsA("UIPadding") then c2:Destroy() end
                end
                for _, opt in ipairs(options) do
                    local item = Instance.new("TextButton")
                    item.Size = UDim2.new(1,0,0,24)
                    item.BackgroundColor3 = selected == opt and C.elementHov or C.element
                    item.BackgroundTransparency = selected == opt and 0 or 1
                    item.Text = opt
                    item.TextColor3 = C.textMain
                    item.TextSize = 12
                    item.Font = Enum.Font.Gotham
                    item.TextXAlignment = Enum.TextXAlignment.Left
                    item.BorderSizePixel = 0
                    item.AutoButtonColor = false
                    item.Parent = listScroll
                    corner(item, UDim.new(0,3))
                    padding(item, 0,0,6,0)
                    item.MouseButton1Click:Connect(function()
                        selected = opt
                        obj.Value = opt
                        selLbl.Text = opt
                        closeList()
                        if opts2.Callback then pcall(opts2.Callback, opt) end
                    end)
                end
            end

            local function openList()
                buildList()
                local absPos  = box.AbsolutePosition
                local absSize = box.AbsoluteSize
                local itemH   = math.min(#options, 5) * 26 + 8
                listFrame.Size = UDim2.new(0, absSize.X, 0, 0)
                listFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 2)
                listFrame.Visible = true
                tween(listFrame, {Size = UDim2.new(0, absSize.X, 0, itemH)}, 0.15)
                arrow.Text = "▴"
            end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = el
            btn.MouseButton1Click:Connect(function()
                if open then closeList() else openList() end
                open = not open
            end)

            function obj:Set(v)
                selected = v; obj.Value = v; selLbl.Text = v
                if opts2.Callback then pcall(opts2.Callback, v) end
            end
            function obj:SetOptions(t)
                options = t; buildList()
            end

            return obj
        end

        -- ── AddTextBox ──────────────────────────────────────────────────────
        function Tab:AddTextBox(opts2)
            opts2 = opts2 or {}
            local hasDesc = opts2.Description and opts2.Description ~= ""
            local elH = hasDesc and 56 or 42
            local el = makeElement(elH)
            padding(el, 6,6,10,10)

            local top = frame(el, UDim2.new(1,0,0,14), nil, C.panel, 1)
            label(top, opts2.Name or "TextBox", 13, C.textMain)
            if hasDesc then
                local desc = label(el, opts2.Description, 11, C.textSub)
                desc.Position = UDim2.new(0,0,0,16)
                desc.Size = UDim2.new(1,0,0,12)
            end

            local boxY = hasDesc and 30 or 20
            local boxF = frame(el, UDim2.new(1,0,0,18), UDim2.new(0,0,0,boxY), C.sliderTrack, 0)
            corner(boxF, UDim.new(0,4))
            stroke(boxF, C.strokeLight, 1)

            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(1,0,1,0)
            tb.BackgroundTransparency = 1
            tb.PlaceholderText = opts2.Placeholder or "Digite..."
            tb.PlaceholderColor3 = C.textMuted
            tb.Text = opts2.Default or ""
            tb.TextColor3 = C.textMain
            tb.TextSize = 12
            tb.Font = Enum.Font.Gotham
            tb.TextXAlignment = Enum.TextXAlignment.Left
            tb.ClearTextOnFocus = false
            tb.Parent = boxF
            padding(tb, 0,0,6,6)

            tb.Focused:Connect(function()
                stroke(boxF, C.textSub, 1)
            end)
            tb.FocusLost:Connect(function(enter)
                stroke(boxF, C.strokeLight, 1)
                if opts2.Callback then pcall(opts2.Callback, tb.Text, enter) end
            end)

            local obj = {}
            function obj:Get() return tb.Text end
            function obj:Set(v) tb.Text = tostring(v) end
            return obj
        end

        -- ── AddColorPicker ──────────────────────────────────────────────────
        function Tab:AddColorPicker(opts2)
            opts2 = opts2 or {}
            local el = makeElement(34)
            padding(el, 0,0,10,10)

            local defColor = opts2.Default or Color3.fromRGB(200,200,200)
            local value = defColor

            label(el, opts2.Name or "Color", 13, C.textMain)

            local preview = frame(el, UDim2.new(0,18,0,18), UDim2.new(1,-28,0.5,-9), defColor, 0)
            corner(preview, UDim.new(0,4))
            stroke(preview, C.strokeLight, 1)

            -- Painel de seleção (escala de cinza simples)
            local picker = frame(sg, UDim2.new(0,140,0,0), nil, C.element, 0)
            picker.ZIndex = 100
            picker.Visible = false
            corner(picker, UDim.new(0,6))
            stroke(picker, C.strokeLight, 1)
            padding(picker, 8,8,8,8)

            local listP = Instance.new("UIListLayout")
            listP.Padding = UDim.new(0,4)
            listP.Parent = picker

            local shades = {255,200,160,120,80,40,0}
            for _, s in ipairs(shades) do
                local row = frame(picker, UDim2.new(1,0,0,18), nil, C.sliderTrack, 0)
                corner(row, UDim.new(0,3))
                local c3 = Color3.fromRGB(s,s,s)
                row.BackgroundColor3 = c3
                local rowBtn = Instance.new("TextButton")
                rowBtn.Size = UDim2.new(1,0,1,0)
                rowBtn.BackgroundTransparency = 1
                rowBtn.Text = ""
                rowBtn.Parent = row
                rowBtn.MouseButton1Click:Connect(function()
                    value = c3; preview.BackgroundColor3 = c3
                    picker.Visible = false
                    if opts2.Callback then pcall(opts2.Callback, c3) end
                end)
            end
            picker.Size = UDim2.new(0,140,0, #shades*22+12)

            local open = false
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = el
            btn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    local absPos = preview.AbsolutePosition
                    picker.Position = UDim2.new(0, absPos.X - 120, 0, absPos.Y + 24)
                    picker.Visible = true
                else
                    picker.Visible = false
                end
            end)

            local obj = {Value = value}
            function obj:Set(c3) value = c3; preview.BackgroundColor3 = c3; obj.Value = c3 end
            return obj
        end

        -- ── AddKeybind ──────────────────────────────────────────────────────
        function Tab:AddKeybind(opts2)
            opts2 = opts2 or {}
            local el = makeElement(34)
            padding(el, 0,0,10,10)

            local boundKey = opts2.Default or Enum.KeyCode.Unknown
            local listening = false

            label(el, opts2.Name or "Keybind", 13, C.textMain)
            if opts2.Description then
                local desc = label(el, opts2.Description, 11, C.textSub)
                desc.Position = UDim2.new(0,0,0,18)
            end

            local keyBox = frame(el, UDim2.new(0,50,0,20), UDim2.new(1,-60,0.5,-10), C.sliderTrack, 0)
            corner(keyBox, UDim.new(0,4))
            stroke(keyBox, C.strokeLight, 1)

            local keyLbl = label(keyBox, boundKey == Enum.KeyCode.Unknown and "NONE" or boundKey.Name, 11, C.textMain, Enum.TextXAlignment.Center)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = el
            btn.MouseButton1Click:Connect(function()
                listening = true
                keyLbl.Text = "..."
                keyLbl.TextColor3 = C.textSub
            end)

            UserInputService.InputBegan:Connect(function(i, gp)
                if listening and not gp then
                    listening = false
                    boundKey = i.KeyCode
                    keyLbl.Text = i.KeyCode == Enum.KeyCode.Unknown and "NONE" or i.KeyCode.Name
                    keyLbl.TextColor3 = C.textMain
                    if opts2.Callback then pcall(opts2.Callback, i.KeyCode) end
                elseif not listening and i.KeyCode == boundKey then
                    if opts2.OnPress then pcall(opts2.OnPress) end
                end
            end)

            local obj = {Value = boundKey}
            function obj:Set(k) boundKey = k; obj.Value = k; keyLbl.Text = k.Name end
            return obj
        end

        return Tab
    end -- AddTab

    -- ── Notify ────────────────────────────────────────────────────────────────
    function Window:Notify(opts2)
        opts2 = opts2 or {}
        local dur = opts2.Duration or 4

        local notifFrame = frame(sg, UDim2.new(0,240,0,0), UDim2.new(1,-250,1,-10), C.notif, 0.10)
        notifFrame.AnchorPoint = Vector2.new(0,1)
        notifFrame.AutomaticSize = Enum.AutomaticSize.Y
        corner(notifFrame)
        stroke(notifFrame, C.stroke, 1)
        notifFrame.ZIndex = 200
        padding(notifFrame, 10,10,12,12)

        local inner = Instance.new("UIListLayout")
        inner.Padding = UDim.new(0,4)
        inner.Parent = notifFrame

        label(notifFrame, opts2.Title or "Notificação", 13, C.textMain)
        if opts2.Description then
            label(notifFrame, opts2.Description, 11, C.textSub)
        end

        notifFrame.BackgroundTransparency = 1
        tween(notifFrame, {BackgroundTransparency=0.10}, 0.2)

        task.delay(dur, function()
            tween(notifFrame, {BackgroundTransparency=1}, 0.3)
            task.delay(0.35, function()
                if notifFrame and notifFrame.Parent then notifFrame:Destroy() end
            end)
        end)
    end

    return Window
end

return RenLib
