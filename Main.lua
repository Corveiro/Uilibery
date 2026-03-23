--[[
    ╔══════════════════════════════════════════════════════════╗
    ║   NIGHT HUB UI  — v4  Premium Library                   ║
    ║   450×300  |  Grid 2 col  |  Dropdown push-down fix     ║
    ║   Resize livre  |  Discord Card  |  Elementos compactos ║
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
local function tween(o,p,t,style,dir)
    TweenService:Create(o,TweenInfo.new(t or 0.15,
        style or Enum.EasingStyle.Quart,
        dir   or Enum.EasingDirection.Out),p):Play()
end

local function corner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 6)
    c.Parent=p; return c
end

local function stroke(p,col,th)
    for _,v in ipairs(p:GetChildren()) do
        if v:IsA("UIStroke") then v:Destroy() end
    end
    local s=Instance.new("UIStroke")
    s.Color=col or Color3.fromRGB(42,45,65); s.Thickness=th or 1
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    s.Parent=p; return s
end

local function pad(p,t,b,l,r)
    local u=Instance.new("UIPadding")
    u.PaddingTop=UDim.new(0,t or 0); u.PaddingBottom=UDim.new(0,b or 0)
    u.PaddingLeft=UDim.new(0,l or 0); u.PaddingRight=UDim.new(0,r or 0)
    u.Parent=p; return u
end

local function vlist(p,sp)
    local l=Instance.new("UIListLayout")
    l.SortOrder=Enum.SortOrder.LayoutOrder
    l.FillDirection=Enum.FillDirection.Vertical
    l.HorizontalAlignment=Enum.HorizontalAlignment.Center
    l.Padding=UDim.new(0,sp or 0); l.Parent=p; return l
end

local function hlist(p,sp)
    local l=Instance.new("UIListLayout")
    l.SortOrder=Enum.SortOrder.LayoutOrder
    l.FillDirection=Enum.FillDirection.Horizontal
    l.VerticalAlignment=Enum.VerticalAlignment.Center
    l.Padding=UDim.new(0,sp or 0); l.Parent=p; return l
end

local function draggable(handle,target)
    local drag,s0,p0=false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; s0=i.Position; p0=target.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
                  or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-s0
            target.Position=UDim2.new(p0.X.Scale,p0.X.Offset+d.X,
                                      p0.Y.Scale,p0.Y.Offset+d.Y)
        end
    end)
end

------------------------------------------------------------------------
-- PALETA
------------------------------------------------------------------------
local C = {
    WIN      = Color3.fromRGB(11, 12, 18),    -- fundo janela: quase preto-azul
    WIN_STR  = Color3.fromRGB(30, 32, 48),
    HDR      = Color3.fromRGB(11, 12, 18),
    HDR_LINE = Color3.fromRGB(28, 30, 46),

    SIDEBAR  = Color3.fromRGB(16, 17, 26),    -- sidebar: um degrau acima do fundo
    SIDE_CAT = Color3.fromRGB(80, 85, 112),

    TAB_OFF  = Color3.fromRGB(16, 17, 26),
    TAB_ON   = Color3.fromRGB(40, 95, 205),
    TAB_H    = Color3.fromRGB(24, 26, 40),
    TAB_OFF_TXT = Color3.fromRGB(130, 135, 162),
    TAB_ON_TXT  = Color3.fromRGB(255, 255, 255),

    CONTENT  = Color3.fromRGB(11, 12, 18),    -- conteúdo: igual ao fundo

    SEC_TXT  = Color3.fromRGB(82, 87, 114),

    ELEM     = Color3.fromRGB(28, 30, 44),    -- cards: bem mais claros que o fundo
    ELEM_H   = Color3.fromRGB(36, 38, 55),
    ELEM_STR = Color3.fromRGB(40, 43, 62),

    TOG_OFF  = Color3.fromRGB(46, 49, 70),
    TOG_ON   = Color3.fromRGB(52, 130, 250),

    BADGE_BG  = Color3.fromRGB(22, 24, 36),
    BADGE_TXT = Color3.fromRGB(165, 170, 200),
    BADGE_STR = Color3.fromRGB(40, 43, 62),

    TXT      = Color3.fromRGB(218, 222, 245),
    TXT_DIM  = Color3.fromRGB(80, 85, 112),
    TXT_MID  = Color3.fromRGB(138, 143, 172),
    TXT_ACT  = Color3.fromRGB(52, 130, 250),

    DIV      = Color3.fromRGB(28, 30, 46),
    SL_TR    = Color3.fromRGB(36, 38, 56),
    SL_FILL  = Color3.fromRGB(52, 130, 250),
    OPT      = Color3.fromRGB(20, 22, 34),
    OPT_H    = Color3.fromRGB(32, 35, 52),
    SCHEME   = Color3.fromRGB(52, 130, 250),
    SCROLL   = Color3.fromRGB(52, 130, 250),
    BTN_HDR  = Color3.fromRGB(28, 30, 46),

    DISC_JOIN = Color3.fromRGB(46, 180, 88),
    DISC_BG   = Color3.fromRGB(20, 22, 34),
}

local _GUI=nil; local _activeTab=nil

------------------------------------------------------------------------
-- INTRO
------------------------------------------------------------------------
local function playIntro(title, onDone)
    local pGui=Players.LocalPlayer:WaitForChild("PlayerGui")
    local sg=Instance.new("ScreenGui")
    sg.Name="__NHIntro"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.DisplayOrder=99998
    pcall(function() sg.Parent=game.CoreGui end)
    if not sg.Parent then sg.Parent=pGui end

    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Color3.fromRGB(8,9,14)
    bg.BorderSizePixel=0; bg.ZIndex=1; bg.Parent=sg

    local panel=Instance.new("Frame")
    panel.Size=UDim2.new(0,0,0,0); panel.AnchorPoint=Vector2.new(0.5,0.5)
    panel.Position=UDim2.new(0.5,0,0.5,0)
    panel.BackgroundColor3=Color3.fromRGB(16,17,26)
    panel.BorderSizePixel=0; panel.ZIndex=2; panel.ClipsDescendants=true
    panel.Parent=sg; corner(panel,14); stroke(panel,C.SCHEME,1.5)

    local scan=Instance.new("Frame")
    scan.Size=UDim2.new(1,0,0,1); scan.BackgroundColor3=C.SCHEME
    scan.BackgroundTransparency=0.3; scan.BorderSizePixel=0
    scan.ZIndex=10; scan.Parent=panel

    local iconBg=Instance.new("Frame")
    iconBg.Size=UDim2.new(0,0,0,0); iconBg.AnchorPoint=Vector2.new(0.5,0.5)
    iconBg.Position=UDim2.new(0.5,0,0.35,0); iconBg.BackgroundColor3=C.SCHEME
    iconBg.BorderSizePixel=0; iconBg.ZIndex=5; iconBg.Parent=panel; corner(iconBg,50)

    local iL=Instance.new("TextLabel"); iL.Size=UDim2.new(1,0,1,0)
    iL.BackgroundTransparency=1; iL.Text="N"; iL.TextScaled=true
    iL.Font=Enum.Font.GothamBold; iL.TextColor3=Color3.fromRGB(255,255,255)
    iL.ZIndex=6; iL.Parent=iconBg

    local function mkLbl(txt,sz,col,y)
        local l=Instance.new("TextLabel")
        l.Size=UDim2.new(1,-32,0,sz+4); l.AnchorPoint=Vector2.new(0.5,0)
        l.Position=UDim2.new(0.5,0,y,0); l.BackgroundTransparency=1
        l.Text=txt; l.TextSize=sz; l.Font=Enum.Font.GothamBold
        l.TextColor3=col; l.TextXAlignment=Enum.TextXAlignment.Center
        l.TextTransparency=1; l.ZIndex=5; l.Parent=panel; return l
    end
    local tLbl=mkLbl(title or "NIGHT HUB",20,Color3.fromRGB(255,255,255),0.56)
    local sLbl=mkLbl("v1.0.1 - BETA",10,C.SCHEME,0.70)
    local stLbl=mkLbl("Initializing...",9,C.TXT_DIM,0.88)

    local barBg=Instance.new("Frame"); barBg.Size=UDim2.new(0.58,0,0,2)
    barBg.AnchorPoint=Vector2.new(0.5,0); barBg.Position=UDim2.new(0.5,0,0.82,0)
    barBg.BackgroundColor3=Color3.fromRGB(30,32,48); barBg.BorderSizePixel=0
    barBg.ZIndex=5; barBg.Parent=panel; corner(barBg,1)
    local barF=Instance.new("Frame"); barF.Size=UDim2.new(0,0,1,0)
    barF.BackgroundColor3=C.SCHEME; barF.BorderSizePixel=0
    barF.ZIndex=6; barF.Parent=barBg; corner(barF,1)

    local particles={}
    for i=1,10 do
        local d=Instance.new("Frame")
        d.Size=UDim2.new(0,math.random(2,3),0,math.random(2,3))
        d.Position=UDim2.new(math.random()/1,0,math.random()/1,0)
        d.BackgroundColor3=C.SCHEME
        d.BackgroundTransparency=math.random(5,8)/10
        d.BorderSizePixel=0; d.ZIndex=3; d.Parent=bg; corner(d,2); particles[i]=d
    end
    local pc=RunService.Heartbeat:Connect(function()
        for _,d in ipairs(particles) do
            local np=d.Position
            d.Position=UDim2.new(
                math.clamp(np.X.Scale+(math.random(-100,100)/140000),0.01,0.99),0,
                math.clamp(np.Y.Scale+(math.random(-100,100)/140000),0.01,0.99),0)
        end
    end)

    task.spawn(function()
        tween(panel,{Size=UDim2.new(0,280,0,220)},0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        task.wait(0.44)
        tween(iconBg,{Size=UDim2.new(0,50,0,50)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        task.wait(0.24)
        tween(tLbl,{TextTransparency=0},0.28); task.wait(0.09)
        tween(sLbl,{TextTransparency=0},0.24); task.wait(0.09)
        tween(stLbl,{TextTransparency=0},0.22); task.wait(0.14)
        TweenService:Create(scan,TweenInfo.new(0.6,Enum.EasingStyle.Linear),
            {Position=UDim2.new(0,0,1,0)}):Play()
        for _,s in ipairs({{0.3,"Loading..."},{0.62,"Connecting..."},{0.88,"Applying..."},{1,"Ready!"}}) do
            tween(barF,{Size=UDim2.new(s[1],0,1,0)},0.26)
            stLbl.Text=s[2]; task.wait(0.28)
        end
        tween(iconBg,{BackgroundColor3=Color3.fromRGB(100,175,255)},0.07)
        task.wait(0.09); tween(iconBg,{BackgroundColor3=C.SCHEME},0.09); task.wait(0.11)
        for _,l in ipairs({tLbl,sLbl,stLbl}) do tween(l,{TextTransparency=1},0.18) end
        tween(iconBg,{BackgroundTransparency=1},0.18); task.wait(0.22)
        tween(panel,{Size=UDim2.new(0,0,0,0)},0.26,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        tween(bg,{BackgroundTransparency=1},0.26); task.wait(0.3)
        pc:Disconnect(); sg:Destroy(); pcall(onDone)
    end)
end

------------------------------------------------------------------------
-- Library.CreateLib
------------------------------------------------------------------------
function Library.CreateLib(title, themeColor)
    if typeof(themeColor)=="Color3" then
        C.SCHEME=themeColor; C.SL_FILL=themeColor; C.TAB_ON=themeColor
        C.TXT_ACT=themeColor; C.SCROLL=themeColor; C.TOG_ON=themeColor
    elseif typeof(themeColor)=="table" then
        if themeColor.SchemeColor then
            local sc=themeColor.SchemeColor
            C.SCHEME=sc;C.SL_FILL=sc;C.TAB_ON=sc;C.TXT_ACT=sc;C.SCROLL=sc;C.TOG_ON=sc
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

    local sg=Instance.new("ScreenGui")
    sg.Name="__NHLib"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder=9999; sg.Enabled=false
    pcall(function() sg.Parent=game.CoreGui end)
    _GUI=sg

    ------------------------------------------------------------------
    -- DIMENSÕES
    ------------------------------------------------------------------
    local WIN_W    = 450
    local SIDE_W   = 145
    local HDR_H    = 42
    local WIN_H    = 300
    local WIN_MIN_H= 200
    local WIN_MAX_H= 740
    local WIN_MIN_W= 320
    local WIN_MAX_W= 920

    -- Tamanhos dos elementos (compactos)
    local EH    = 54   -- altura de cada card no grid
    local GAP   = 5    -- gap entre cards
    local ICON  = 28   -- tamanho do ícone
    local TX_T  = 12   -- textsize título
    local TX_S  = 9    -- textsize subtítulo

    ------------------------------------------------------------------
    -- JANELA
    ------------------------------------------------------------------
    local win=Instance.new("Frame")
    win.Name="Win"; win.AnchorPoint=Vector2.new(0.5,0)
    win.Position=UDim2.new(0.5,0,0.04,0)
    win.Size=UDim2.new(0,WIN_W,0,WIN_H)
    win.BackgroundColor3=C.WIN; win.BorderSizePixel=0
    win.ClipsDescendants=false; win.Parent=sg; corner(win,10); stroke(win,C.WIN_STR,1)

    local shadow=Instance.new("ImageLabel")
    shadow.Size=UDim2.new(1,44,1,44); shadow.Position=UDim2.new(0,-22,0,-22)
    shadow.BackgroundTransparency=1; shadow.Image="rbxassetid://6015897843"
    shadow.ImageColor3=Color3.fromRGB(0,0,0); shadow.ImageTransparency=0.4
    shadow.ScaleType=Enum.ScaleType.Slice; shadow.SliceCenter=Rect.new(49,49,450,450)
    shadow.ZIndex=0; shadow.Parent=win

    ------------------------------------------------------------------
    -- HEADER
    ------------------------------------------------------------------
    local hdr=Instance.new("Frame")
    hdr.Name="Hdr"; hdr.Size=UDim2.new(1,0,0,HDR_H)
    hdr.BackgroundColor3=C.HDR; hdr.BorderSizePixel=0; hdr.ZIndex=10; hdr.Parent=win
    corner(hdr,10)
    -- patch inferior
    local hp=Instance.new("Frame"); hp.Size=UDim2.new(1,0,0,12)
    hp.Position=UDim2.new(0,0,1,-12); hp.BackgroundColor3=C.HDR
    hp.BorderSizePixel=0; hp.ZIndex=10; hp.Parent=hdr
    -- linha separadora
    local hl=Instance.new("Frame"); hl.Size=UDim2.new(1,0,0,1)
    hl.Position=UDim2.new(0,0,1,-1); hl.BackgroundColor3=C.HDR_LINE
    hl.BorderSizePixel=0; hl.ZIndex=11; hl.Parent=hdr

    -- "Night" bold
    local tN=Instance.new("TextLabel"); tN.Size=UDim2.new(0,44,1,0)
    tN.Position=UDim2.new(0,12,0,0); tN.BackgroundTransparency=1; tN.Text="Night"
    tN.TextSize=14; tN.Font=Enum.Font.GothamBold; tN.TextColor3=Color3.fromRGB(255,255,255)
    tN.TextXAlignment=Enum.TextXAlignment.Left; tN.TextYAlignment=Enum.TextYAlignment.Center
    tN.ZIndex=12; tN.Parent=hdr

    -- "Hub" regular
    local tH=Instance.new("TextLabel"); tH.Size=UDim2.new(0,30,1,0)
    tH.Position=UDim2.new(0,58,0,0); tH.BackgroundTransparency=1; tH.Text="Hub"
    tH.TextSize=14; tH.Font=Enum.Font.Gotham; tH.TextColor3=Color3.fromRGB(175,180,210)
    tH.TextXAlignment=Enum.TextXAlignment.Left; tH.TextYAlignment=Enum.TextYAlignment.Center
    tH.ZIndex=12; tH.Parent=hdr

    -- Badge versão
    local vBg=Instance.new("Frame"); vBg.Size=UDim2.new(0,72,0,17)
    vBg.Position=UDim2.new(0,92,0.5,-8.5); vBg.BackgroundColor3=C.SCHEME
    vBg.BorderSizePixel=0; vBg.ZIndex=13; vBg.Parent=hdr; corner(vBg,4)
    local vL=Instance.new("TextLabel"); vL.Size=UDim2.new(1,0,1,0)
    vL.BackgroundTransparency=1; vL.Text="v1.0.1 - BETA"; vL.TextSize=8
    vL.Font=Enum.Font.GothamBold; vL.TextColor3=Color3.fromRGB(255,255,255)
    vL.TextXAlignment=Enum.TextXAlignment.Center; vL.TextYAlignment=Enum.TextYAlignment.Center
    vL.ZIndex=14; vL.Parent=vBg

    -- Arrows decorativos
    local ar=Instance.new("TextLabel"); ar.Size=UDim2.new(1,-280,1,0)
    ar.Position=UDim2.new(0,172,0,0); ar.BackgroundTransparency=1
    ar.Text=">> >> >> >> >> >> >> >> >>"; ar.TextSize=8; ar.Font=Enum.Font.GothamBold
    ar.TextColor3=Color3.fromRGB(52,130,250)
    ar.TextXAlignment=Enum.TextXAlignment.Left; ar.TextYAlignment=Enum.TextYAlignment.Center
    ar.TextTruncate=Enum.TextTruncate.AtEnd; ar.ZIndex=12; ar.Parent=hdr

    -- Minimize
    local minB=Instance.new("TextButton"); minB.Size=UDim2.new(0,22,0,22)
    minB.Position=UDim2.new(1,-52,0.5,-11); minB.BackgroundColor3=C.BTN_HDR
    minB.BorderSizePixel=0; minB.Text="—"; minB.Font=Enum.Font.GothamBold; minB.TextSize=9
    minB.TextColor3=Color3.fromRGB(165,170,200); minB.AutoButtonColor=false
    minB.ZIndex=14; minB.Parent=hdr; corner(minB,5)
    minB.MouseEnter:Connect(function() tween(minB,{BackgroundColor3=C.ELEM_H},0.08) end)
    minB.MouseLeave:Connect(function() tween(minB,{BackgroundColor3=C.BTN_HDR},0.08) end)
    local mini,savedH=false,WIN_H
    minB.MouseButton1Click:Connect(function()
        mini=not mini
        if mini then savedH=win.AbsoluteSize.Y
            tween(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,HDR_H+1)},0.2)
        else tween(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,savedH)},0.2) end
    end)

    -- Close
    local clB=Instance.new("TextButton"); clB.Size=UDim2.new(0,22,0,22)
    clB.Position=UDim2.new(1,-26,0.5,-11); clB.BackgroundColor3=C.BTN_HDR
    clB.BorderSizePixel=0; clB.Text="x"; clB.Font=Enum.Font.GothamBold; clB.TextSize=10
    clB.TextColor3=Color3.fromRGB(165,170,200); clB.AutoButtonColor=false
    clB.ZIndex=14; clB.Parent=hdr; corner(clB,5)
    clB.MouseEnter:Connect(function()
        tween(clB,{BackgroundColor3=Color3.fromRGB(190,45,45),TextColor3=Color3.fromRGB(255,255,255)},0.08)
    end)
    clB.MouseLeave:Connect(function()
        tween(clB,{BackgroundColor3=C.BTN_HDR,TextColor3=Color3.fromRGB(165,170,200)},0.08)
    end)
    clB.MouseButton1Click:Connect(function()
        tween(win,{Size=UDim2.new(0,win.AbsoluteSize.X,0,0),BackgroundTransparency=1},0.16)
        task.delay(0.18,function() sg:Destroy() end)
    end)

    draggable(hdr,win)

    ------------------------------------------------------------------
    -- CORPO
    ------------------------------------------------------------------
    local body=Instance.new("Frame"); body.Name="Body"
    body.Size=UDim2.new(1,0,1,-HDR_H); body.Position=UDim2.new(0,0,0,HDR_H)
    body.BackgroundTransparency=1; body.BorderSizePixel=0
    body.ClipsDescendants=true; body.ZIndex=2; body.Parent=win

    ------------------------------------------------------------------
    -- SIDEBAR
    ------------------------------------------------------------------
    local sidebar=Instance.new("Frame"); sidebar.Name="Sidebar"
    sidebar.Size=UDim2.new(0,SIDE_W,1,0)
    sidebar.BackgroundColor3=C.SIDEBAR; sidebar.BorderSizePixel=0
    sidebar.ZIndex=3; sidebar.Parent=body

    local sdiv=Instance.new("Frame"); sdiv.Size=UDim2.new(0,1,1,0)
    sdiv.Position=UDim2.new(1,-1,0,0); sdiv.BackgroundColor3=C.HDR_LINE
    sdiv.BorderSizePixel=0; sdiv.ZIndex=4; sdiv.Parent=sidebar

    local sScroll=Instance.new("ScrollingFrame")
    sScroll.Size=UDim2.new(1,-1,1,0); sScroll.BackgroundTransparency=1
    sScroll.BorderSizePixel=0; sScroll.ScrollBarThickness=2
    sScroll.ScrollBarImageColor3=C.SCROLL; sScroll.ScrollBarImageTransparency=0.4
    sScroll.CanvasSize=UDim2.new(0,0,0,0)
    sScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sScroll.ScrollingDirection=Enum.ScrollingDirection.Y
    sScroll.ClipsDescendants=true
    sScroll.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable
    sScroll.ZIndex=4; sScroll.Parent=sidebar

    local sList=Instance.new("Frame"); sList.Size=UDim2.new(1,0,0,0)
    sList.AutomaticSize=Enum.AutomaticSize.Y; sList.BackgroundTransparency=1
    sList.BorderSizePixel=0; sList.ZIndex=4; sList.Parent=sScroll
    vlist(sList,2); pad(sList,6,6,6,6)

    ------------------------------------------------------------------
    -- CONTEÚDO
    ------------------------------------------------------------------
    local cPanel=Instance.new("Frame"); cPanel.Name="Content"
    cPanel.Size=UDim2.new(1,-SIDE_W,1,0); cPanel.Position=UDim2.new(0,SIDE_W,0,0)
    cPanel.BackgroundColor3=C.CONTENT; cPanel.BorderSizePixel=0
    cPanel.ZIndex=3; cPanel.ClipsDescendants=true; cPanel.Parent=body

    -- Título da tab ativa
    local secTitle=Instance.new("TextLabel")
    secTitle.Size=UDim2.new(1,-16,0,36); secTitle.Position=UDim2.new(0,12,0,0)
    secTitle.BackgroundTransparency=1; secTitle.Text=""
    secTitle.TextSize=20; secTitle.Font=Enum.Font.GothamBold
    secTitle.TextColor3=Color3.fromRGB(230,233,255)
    secTitle.TextXAlignment=Enum.TextXAlignment.Left
    secTitle.TextYAlignment=Enum.TextYAlignment.Center
    secTitle.ZIndex=6; secTitle.Parent=cPanel

    -- ScrollingFrame do conteúdo
    -- CRÍTICO: AutomaticCanvasSize=Y para o dropdown empurrar tudo
    local scroll=Instance.new("ScrollingFrame"); scroll.Name="Scroll"
    scroll.Position=UDim2.new(0,0,0,38); scroll.Size=UDim2.new(1,0,1,-42)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=2; scroll.ScrollBarImageColor3=C.SCROLL
    scroll.ScrollBarImageTransparency=0.35
    scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.ScrollingDirection=Enum.ScrollingDirection.Y
    scroll.ClipsDescendants=true; scroll.ZIndex=4; scroll.Parent=cPanel
    vlist(scroll,GAP); pad(scroll,4,10,8,8)

    ------------------------------------------------------------------
    -- RESIZE HANDLES
    ------------------------------------------------------------------
    local rB,rR,rC=false,false,false
    local rsX,rsY,rsW,rsH=0,0,0,0

    local function mkRH(sz,pos,zi)
        local h=Instance.new("TextButton"); h.Size=sz; h.Position=pos
        h.BackgroundColor3=Color3.fromRGB(48,52,72); h.BackgroundTransparency=0.7
        h.BorderSizePixel=0; h.AutoButtonColor=false; h.Text=""
        h.ZIndex=zi or 20; h.Parent=win; corner(h,3); return h
    end

    local rBot=mkRH(UDim2.new(1,-18,0,5),UDim2.new(0,9,1,-2),20)
    local rRig=mkRH(UDim2.new(0,5,1,-18),UDim2.new(1,-2,0,9),20)
    local rCor=mkRH(UDim2.new(0,9,0,9),UDim2.new(1,-9,1,-9),22)
    rCor.BackgroundColor3=C.SCHEME; rCor.BackgroundTransparency=0.5

    local function addDots(h,vert)
        local dc=Instance.new("Frame")
        dc.Size=vert and UDim2.new(0,3,0,18) or UDim2.new(0,18,0,3)
        dc.AnchorPoint=Vector2.new(0.5,0.5); dc.Position=UDim2.new(0.5,0,0.5,0)
        dc.BackgroundTransparency=1; dc.BorderSizePixel=0; dc.ZIndex=21; dc.Parent=h
        local ll=Instance.new("UIListLayout")
        ll.FillDirection=vert and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
        ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Padding=UDim.new(0,3); ll.Parent=dc
        for i=1,3 do
            local d=Instance.new("Frame")
            d.Size=vert and UDim2.new(0,2,0,3) or UDim2.new(0,3,0,2)
            d.BackgroundColor3=Color3.fromRGB(155,160,190); d.BackgroundTransparency=0.3
            d.BorderSizePixel=0; d.ZIndex=22; d.Parent=dc; corner(d,1)
        end
    end
    addDots(rBot,false); addDots(rRig,true)

    local function hookRes(h,doW,doH)
        local baseT=doW and doH and 0.5 or 0.7
        h.MouseEnter:Connect(function() tween(h,{BackgroundTransparency=0.1},0.1) end)
        h.MouseLeave:Connect(function() tween(h,{BackgroundTransparency=baseT},0.1) end)
        h.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.Touch then
                if doW and doH then rC=true elseif doW then rR=true else rB=true end
                rsX=inp.Position.X; rsY=inp.Position.Y
                rsW=win.AbsoluteSize.X; rsH=win.AbsoluteSize.Y
                inp.Changed:Connect(function()
                    if inp.UserInputState==Enum.UserInputState.End then
                        rB=false;rR=false;rC=false
                        tween(h,{BackgroundTransparency=baseT},0.1)
                    end
                end)
            end
        end)
    end
    hookRes(rBot,false,true); hookRes(rRig,true,false); hookRes(rCor,true,true)

    UserInputService.InputChanged:Connect(function(inp)
        if (rB or rR or rC) and
           (inp.UserInputType==Enum.UserInputType.MouseMovement
         or inp.UserInputType==Enum.UserInputType.Touch) then
            local dx=inp.Position.X-rsX; local dy=inp.Position.Y-rsY
            local nW=win.AbsoluteSize.X; local nH=win.AbsoluteSize.Y
            if rR or rC then nW=math.clamp(rsW+dx,WIN_MIN_W,WIN_MAX_W) end
            if rB or rC then nH=math.clamp(rsH+dy,WIN_MIN_H,WIN_MAX_H) end
            win.Size=UDim2.new(0,nW,0,nH)
        end
    end)

    ------------------------------------------------------------------
    -- Window:NewTab
    ------------------------------------------------------------------
    local Window={}; local tabPanels={}
    local defIcons={"🏠","⚔️","📄","⚙️","🎯","👁","🔧","🥊","💎","🌍","🔄","📦"}
    local tabIdx=0

    local function showTab(td)
        for _,t in ipairs(tabPanels) do
            t.panel.Visible=false
            tween(t.btn,{BackgroundColor3=C.TAB_OFF},0.12)
            tween(t.nameLbl,{TextColor3=C.TAB_OFF_TXT},0.1)
            if t.iconLbl then tween(t.iconLbl,{TextColor3=C.TAB_OFF_TXT},0.1) end
            if t.indic   then tween(t.indic,{BackgroundTransparency=1},0.1) end
        end
        td.panel.Visible=true
        tween(td.btn,{BackgroundColor3=C.TAB_ON},0.14)
        tween(td.nameLbl,{TextColor3=C.TAB_ON_TXT},0.1)
        if td.iconLbl then tween(td.iconLbl,{TextColor3=C.TAB_ON_TXT},0.1) end
        if td.indic   then tween(td.indic,{BackgroundTransparency=0},0.12) end
        secTitle.Text=td.cleanName; _activeTab=td
    end

    function Window:NewTab(tabName, catName)
        tabName=tabName or "Tab"; tabIdx=tabIdx+1
        local iconStr=defIcons[tabIdx] or "•"; local cleanName=tabName
        local ei,en=tabName:match("^(.-)・(.+)$")
        if ei and en then iconStr=ei; cleanName=en end

        -- categoria
        if catName and catName~="" then
            local cl=Instance.new("TextLabel"); cl.Size=UDim2.new(1,0,0,18)
            cl.BackgroundTransparency=1; cl.Text=string.upper(catName)
            cl.TextSize=8; cl.Font=Enum.Font.GothamBold; cl.TextColor3=C.SIDE_CAT
            cl.TextXAlignment=Enum.TextXAlignment.Left
            cl.TextYAlignment=Enum.TextYAlignment.Center
            cl.ZIndex=5; cl.Parent=sList; pad(cl,0,0,4,0)
        end

        -- Botão tab
        local tabBtn=Instance.new("TextButton"); tabBtn.Size=UDim2.new(1,0,0,30)
        tabBtn.BackgroundColor3=C.TAB_OFF; tabBtn.BorderSizePixel=0
        tabBtn.AutoButtonColor=false; tabBtn.Text=""; tabBtn.ZIndex=5
        tabBtn.Parent=sList; corner(tabBtn,7)

        -- indicador lateral
        local indic=Instance.new("Frame"); indic.Size=UDim2.new(0,2,0.5,0)
        indic.AnchorPoint=Vector2.new(0,0.5); indic.Position=UDim2.new(0,0,0.5,0)
        indic.BackgroundColor3=C.TAB_ON; indic.BackgroundTransparency=1
        indic.BorderSizePixel=0; indic.ZIndex=7; indic.Parent=tabBtn; corner(indic,2)

        -- ícone
        local tabIcon=Instance.new("TextLabel"); tabIcon.Size=UDim2.new(0,18,1,0)
        tabIcon.Position=UDim2.new(0,8,0,0); tabIcon.BackgroundTransparency=1
        tabIcon.Text=iconStr; tabIcon.TextScaled=true; tabIcon.Font=Enum.Font.GothamBold
        tabIcon.TextColor3=C.TAB_OFF_TXT; tabIcon.TextXAlignment=Enum.TextXAlignment.Center
        tabIcon.ZIndex=6; tabIcon.Parent=tabBtn

        -- nome
        local tabNameLbl=Instance.new("TextLabel")
        tabNameLbl.Size=UDim2.new(1,-32,1,0); tabNameLbl.Position=UDim2.new(0,30,0,0)
        tabNameLbl.BackgroundTransparency=1; tabNameLbl.Text=cleanName
        tabNameLbl.TextSize=11; tabNameLbl.Font=Enum.Font.GothamSemibold
        tabNameLbl.TextColor3=C.TAB_OFF_TXT
        tabNameLbl.TextXAlignment=Enum.TextXAlignment.Left
        tabNameLbl.TextYAlignment=Enum.TextYAlignment.Center
        tabNameLbl.ZIndex=6; tabNameLbl.Parent=tabBtn

        -- painel de conteúdo — AutomaticSize=Y para o dropdown empurrar tudo
        local panel=Instance.new("Frame")
        panel.Name="Panel_"..cleanName
        panel.Size=UDim2.new(1,0,0,0)
        panel.AutomaticSize=Enum.AutomaticSize.Y
        panel.BackgroundTransparency=1; panel.BorderSizePixel=0
        panel.Visible=false; panel.ZIndex=5; panel.Parent=scroll
        vlist(panel,GAP)

        local td={btn=tabBtn,panel=panel,nameLbl=tabNameLbl,
            iconLbl=tabIcon,indic=indic,cleanName=cleanName}
        table.insert(tabPanels,td)

        tabBtn.MouseButton1Click:Connect(function() showTab(td) end)
        tabBtn.MouseEnter:Connect(function()
            if _activeTab~=td then
                tween(tabBtn,{BackgroundColor3=C.TAB_H},0.07)
                tween(tabNameLbl,{TextColor3=Color3.fromRGB(195,200,225)},0.07)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if _activeTab~=td then
                tween(tabBtn,{BackgroundColor3=C.TAB_OFF},0.07)
                tween(tabNameLbl,{TextColor3=C.TAB_OFF_TXT},0.07)
            end
        end)
        if tabIdx==1 then task.defer(function() showTab(td) end) end

        --------------------------------------------------------
        -- Tab:NewSection
        --------------------------------------------------------
        local Tab={}

        function Tab:NewSection(secName)
            secName=secName or "Section"
            local secClean=secName
            local _,sn=secName:match("^.+・(.+)$")
            if sn then secClean=sn end

            -- Cabeçalho da seção
            local sh=Instance.new("Frame"); sh.Size=UDim2.new(1,0,0,22)
            sh.BackgroundTransparency=1; sh.BorderSizePixel=0; sh.ZIndex=5; sh.Parent=panel

            local shl=Instance.new("TextLabel"); shl.Size=UDim2.new(1,0,1,0)
            shl.BackgroundTransparency=1; shl.Text=secClean; shl.TextSize=10
            shl.Font=Enum.Font.GothamBold; shl.TextColor3=C.SEC_TXT
            shl.TextXAlignment=Enum.TextXAlignment.Left
            shl.TextYAlignment=Enum.TextYAlignment.Center
            shl.ZIndex=6; shl.Parent=sh

            local secLine=Instance.new("Frame"); secLine.Size=UDim2.new(1,0,0,1)
            secLine.Position=UDim2.new(0,0,1,-1); secLine.BackgroundColor3=C.DIV
            secLine.BorderSizePixel=0; secLine.ZIndex=6; secLine.Parent=sh

            local Section={}

            ------------------------------------------------------------
            -- GRID 2 COLUNAS
            -- Cada linha do grid é um Frame com AutomaticSize=Y e hlist.
            -- IMPORTANTE: as rows NÃO têm altura fixa — elas crescem
            -- automaticamente quando o dropdown abre, empurrando tudo abaixo.
            ------------------------------------------------------------
            local curRow=nil; local rowCount=0

            local function newRow()
                local r=Instance.new("Frame")
                r.Size=UDim2.new(1,0,0,0)
                r.AutomaticSize=Enum.AutomaticSize.Y   -- ← CHAVE: cresce com dropdown
                r.BackgroundTransparency=1; r.BorderSizePixel=0
                r.ZIndex=5; r.Parent=panel
                hlist(r,GAP)
                return r
            end

            -- Cria um frame-célula meia-largura (fill=0.5 - gap/2)
            -- Retorna o frame e um UDim2 de "tamanho fechado" para o dropdown
            local function newHalfFrame(isBtn)
                if rowCount==0 or rowCount>=2 then
                    curRow=newRow(); rowCount=0
                end
                rowCount=rowCount+1
                -- Usamos UDim2 com Scale=0.5 e Offset=-gap/2
                local sz=UDim2.new(0.5,-(math.ceil(GAP/2)),0,EH)

                local f
                if isBtn then
                    f=Instance.new("TextButton")
                    f.AutoButtonColor=false; f.Text=""
                else
                    f=Instance.new("Frame")
                end
                f.Size=sz; f.BackgroundColor3=C.ELEM; f.BorderSizePixel=0
                f.ZIndex=5; f.Parent=curRow; corner(f,9); stroke(f,C.ELEM_STR,1)
                if isBtn then
                    f.MouseEnter:Connect(function() tween(f,{BackgroundColor3=C.ELEM_H},0.07) end)
                    f.MouseLeave:Connect(function() tween(f,{BackgroundColor3=C.ELEM},0.07) end)
                end
                return f, sz
            end

            -- Ícone compacto
            local function mkIcon(parent,txt,col)
                col=col or C.SCHEME
                local bg=Instance.new("Frame"); bg.Size=UDim2.new(0,ICON,0,ICON)
                bg.Position=UDim2.new(0,8,0.5,-ICON/2); bg.BackgroundColor3=col
                bg.BackgroundTransparency=0.78; bg.BorderSizePixel=0
                bg.ZIndex=7; bg.Parent=parent; corner(bg,8)
                local il=Instance.new("TextLabel"); il.Size=UDim2.new(1,0,1,0)
                il.BackgroundTransparency=1; il.Text=txt or "•"; il.TextScaled=true
                il.Font=Enum.Font.GothamBold; il.TextColor3=col
                il.TextXAlignment=Enum.TextXAlignment.Center
                il.TextYAlignment=Enum.TextYAlignment.Center
                il.ZIndex=8; il.Parent=bg; return bg
            end

            -- Título + sub compacto
            local function mkTS(parent,title,sub,subCol)
                local tl=Instance.new("TextLabel")
                tl.Size=UDim2.new(1,-ICON-22,0,TX_T+2)
                tl.Position=UDim2.new(0,ICON+14,0,math.floor(EH/2)-TX_T-1)
                tl.BackgroundTransparency=1; tl.Text=title or ""
                tl.TextSize=TX_T; tl.Font=Enum.Font.GothamBold; tl.TextColor3=C.TXT
                tl.TextXAlignment=Enum.TextXAlignment.Left
                tl.TextTruncate=Enum.TextTruncate.AtEnd
                tl.ZIndex=6; tl.Parent=parent

                local sl=Instance.new("TextLabel")
                sl.Size=UDim2.new(1,-ICON-22,0,TX_S+2)
                sl.Position=UDim2.new(0,ICON+14,0,math.floor(EH/2)+2)
                sl.BackgroundTransparency=1; sl.Text=sub or ""
                sl.TextSize=TX_S; sl.Font=Enum.Font.GothamBold
                sl.TextColor3=subCol or C.TXT_DIM
                sl.TextXAlignment=Enum.TextXAlignment.Left
                sl.TextTruncate=Enum.TextTruncate.AtEnd
                sl.ZIndex=6; sl.Parent=parent
                return tl,sl
            end

            ------------------------------------------------------------
            -- NewDiscord
            ------------------------------------------------------------
            function Section:NewDiscord(serverName,serverDesc,imageId,inviteUrl)
                curRow=nil; rowCount=0
                serverName=serverName or "Discord Server"
                serverDesc=serverDesc or "Join our community!"
                inviteUrl=inviteUrl or ""

                local card=Instance.new("Frame")
                card.Size=UDim2.new(1,0,0,0); card.AutomaticSize=Enum.AutomaticSize.Y
                card.BackgroundColor3=C.DISC_BG; card.BorderSizePixel=0
                card.ZIndex=5; card.Parent=panel; corner(card,10); stroke(card,C.ELEM_STR,1)

                if imageId and imageId~="" then
                    local ban=Instance.new("ImageLabel")
                    ban.Size=UDim2.new(1,0,0,75); ban.BackgroundColor3=Color3.fromRGB(14,15,22)
                    ban.BorderSizePixel=0; ban.Image="rbxassetid://"..tostring(imageId)
                    ban.ScaleType=Enum.ScaleType.Crop; ban.ZIndex=6; ban.Parent=card; corner(ban,10)
                    local bp=Instance.new("Frame"); bp.Size=UDim2.new(1,0,0,10)
                    bp.Position=UDim2.new(0,0,1,-10); bp.BackgroundColor3=Color3.fromRGB(14,15,22)
                    bp.BorderSizePixel=0; bp.ZIndex=7; bp.Parent=ban
                end

                local infoY=(imageId and imageId~="") and 75 or 0
                local infoRow=Instance.new("Frame"); infoRow.Size=UDim2.new(1,0,0,50)
                infoRow.Position=UDim2.new(0,0,0,infoY); infoRow.BackgroundTransparency=1
                infoRow.BorderSizePixel=0; infoRow.ZIndex=6; infoRow.Parent=card

                local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-86,0,18)
                nl.Position=UDim2.new(0,10,0,8); nl.BackgroundTransparency=1
                nl.Text=serverName; nl.TextSize=13; nl.Font=Enum.Font.GothamBold
                nl.TextColor3=C.TXT; nl.TextXAlignment=Enum.TextXAlignment.Left
                nl.TextTruncate=Enum.TextTruncate.AtEnd; nl.ZIndex=7; nl.Parent=infoRow

                local dl=Instance.new("TextLabel"); dl.Size=UDim2.new(1,-86,0,16)
                dl.Position=UDim2.new(0,10,0,26); dl.BackgroundTransparency=1
                dl.Text=serverDesc; dl.TextSize=9; dl.Font=Enum.Font.Gotham
                dl.TextColor3=C.TXT_DIM; dl.TextXAlignment=Enum.TextXAlignment.Left
                dl.TextWrapped=true; dl.ZIndex=7; dl.Parent=infoRow

                local jBtn=Instance.new("TextButton"); jBtn.Size=UDim2.new(0,54,0,26)
                jBtn.Position=UDim2.new(1,-62,0.5,-13); jBtn.BackgroundColor3=C.DISC_JOIN
                jBtn.BorderSizePixel=0; jBtn.Text="Join"; jBtn.Font=Enum.Font.GothamBold
                jBtn.TextSize=12; jBtn.TextColor3=Color3.fromRGB(255,255,255)
                jBtn.AutoButtonColor=false; jBtn.ZIndex=8; jBtn.Parent=infoRow; corner(jBtn,7)
                jBtn.MouseEnter:Connect(function()
                    tween(jBtn,{BackgroundColor3=Color3.fromRGB(58,205,100)},0.09) end)
                jBtn.MouseLeave:Connect(function()
                    tween(jBtn,{BackgroundColor3=C.DISC_JOIN},0.09) end)
                jBtn.MouseButton1Click:Connect(function()
                    if inviteUrl~="" then pcall(function() setclipboard(inviteUrl) end) end
                    tween(jBtn,{BackgroundColor3=Color3.fromRGB(110,230,150)},0.06)
                    task.delay(0.09,function() tween(jBtn,{BackgroundColor3=C.DISC_JOIN},0.16) end)
                end)
                return {}
            end

            ------------------------------------------------------------
            -- NewToggle — pill, 2 por linha
            ------------------------------------------------------------
            function Section:NewToggle(name,tip,callback)
                callback=callback or function() end
                local on=false
                local iconChar="◎"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                local cell,_=newHalfFrame(true)
                mkIcon(cell,iconChar,C.SCHEME)
                local _,sl2=mkTS(cell,dispName,tip or "DISABLE",C.TXT_DIM)

                -- Pill switch compacto
                local pBg=Instance.new("Frame"); pBg.Size=UDim2.new(0,32,0,17)
                pBg.Position=UDim2.new(1,-38,0.5,-8.5); pBg.BackgroundColor3=C.TOG_OFF
                pBg.BorderSizePixel=0; pBg.ZIndex=7; pBg.Parent=cell; corner(pBg,9)

                local circ=Instance.new("Frame"); circ.Size=UDim2.new(0,12,0,12)
                circ.Position=UDim2.new(0,2.5,0.5,-6); circ.BackgroundColor3=Color3.fromRGB(255,255,255)
                circ.BorderSizePixel=0; circ.ZIndex=8; circ.Parent=pBg; corner(circ,7)

                local function setState(v)
                    on=v
                    if on then
                        tween(pBg,{BackgroundColor3=C.TOG_ON},0.14)
                        tween(circ,{Position=UDim2.new(0,17.5,0.5,-6)},0.14,
                            Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                        sl2.Text="ACTIVE"; sl2.TextColor3=C.TXT_ACT
                    else
                        tween(pBg,{BackgroundColor3=C.TOG_OFF},0.12)
                        tween(circ,{Position=UDim2.new(0,2.5,0.5,-6)},0.12)
                        sl2.Text="DISABLE"; sl2.TextColor3=C.TXT_DIM
                    end
                end

                cell.MouseButton1Click:Connect(function() setState(not on); pcall(callback,on) end)

                local T={}
                function T:UpdateToggle(a,b)
                    local v=(typeof(a)=="boolean") and a or (typeof(b)=="boolean") and b or nil
                    if v~=nil then setState(v) end
                end
                function T:SetToggle(v) setState(v) end
                return T
            end

            ------------------------------------------------------------
            -- NewButton — 2 por linha
            ------------------------------------------------------------
            function Section:NewButton(name,tip,callback)
                callback=callback or function() end
                local iconChar="▶"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                local cell,_=newHalfFrame(true)
                mkIcon(cell,iconChar,C.SCHEME)
                local tl2,_=mkTS(cell,dispName,tip or "")

                cell.MouseButton1Click:Connect(function()
                    tween(cell,{BackgroundColor3=Color3.fromRGB(44,56,95)},0.05)
                    task.delay(0.09,function() tween(cell,{BackgroundColor3=C.ELEM},0.12) end)
                    pcall(callback)
                end)

                local B={}; function B:UpdateButton(t) tl2.Text=t or name end; return B
            end

            ------------------------------------------------------------
            -- NewDropdown — 2 por linha
            -- FIX: o outer e o curRow usam AutomaticSize=Y
            -- Quando abre, o outer cresce → curRow cresce → panel cresce
            -- → scroll canvas cresce → conteúdo empurra para baixo ✓
            ------------------------------------------------------------
            function Section:NewDropdown(name,tip,options,callback)
                options=options or {}; callback=callback or function() end
                local isOpen=false; local selVal=nil

                local iconChar="≡"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                -- Posiciona na grid
                if rowCount==0 or rowCount>=2 then
                    curRow=newRow(); rowCount=0
                end
                rowCount=rowCount+1

                -- Frame externo: AutomaticSize=Y + ClipsDescendants=false
                -- para crescer livremente e empurrar tudo abaixo
                local outer=Instance.new("Frame")
                outer.Name="DD_"..dispName
                outer.Size=UDim2.new(0.5,-(math.ceil(GAP/2)),0,EH)
                outer.AutomaticSize=Enum.AutomaticSize.None  -- controlamos manualmente com tween
                outer.BackgroundColor3=C.ELEM; outer.BorderSizePixel=0
                outer.ClipsDescendants=true
                outer.ZIndex=6; outer.Parent=curRow; corner(outer,9); stroke(outer,C.ELEM_STR,1)

                -- Header clicável (altura EH fixa)
                local dHead=Instance.new("TextButton")
                dHead.Size=UDim2.new(1,0,0,EH); dHead.BackgroundTransparency=1
                dHead.BorderSizePixel=0; dHead.AutoButtonColor=false; dHead.Text=""
                dHead.ZIndex=7; dHead.Parent=outer

                mkIcon(dHead,iconChar,C.SCHEME)

                local dTitle=Instance.new("TextLabel")
                dTitle.Size=UDim2.new(1,-ICON-30,0,TX_T+2)
                dTitle.Position=UDim2.new(0,ICON+14,0,math.floor(EH/2)-TX_T-1)
                dTitle.BackgroundTransparency=1; dTitle.Text=dispName
                dTitle.TextSize=TX_T; dTitle.Font=Enum.Font.GothamBold; dTitle.TextColor3=C.TXT
                dTitle.TextXAlignment=Enum.TextXAlignment.Left
                dTitle.TextTruncate=Enum.TextTruncate.AtEnd; dTitle.ZIndex=8; dTitle.Parent=dHead

                local dSub=Instance.new("TextLabel")
                dSub.Size=UDim2.new(1,-ICON-30,0,TX_S+2)
                dSub.Position=UDim2.new(0,ICON+14,0,math.floor(EH/2)+2)
                dSub.BackgroundTransparency=1
                dSub.Text="Select: "..(#options>0 and tostring(options[1]) or "-")
                dSub.TextSize=TX_S; dSub.Font=Enum.Font.Gotham; dSub.TextColor3=C.TXT_DIM
                dSub.TextXAlignment=Enum.TextXAlignment.Left
                dSub.TextTruncate=Enum.TextTruncate.AtEnd; dSub.ZIndex=8; dSub.Parent=dHead

                -- Seta (TextLabel puro, sem emoji — sem bug)
                local arrLbl=Instance.new("TextLabel")
                arrLbl.Size=UDim2.new(0,14,0,14); arrLbl.Position=UDim2.new(1,-18,0.5,-7)
                arrLbl.BackgroundTransparency=1; arrLbl.Text="v"
                arrLbl.Font=Enum.Font.GothamBold; arrLbl.TextSize=10
                arrLbl.TextColor3=C.TXT_MID
                arrLbl.TextXAlignment=Enum.TextXAlignment.Center
                arrLbl.TextYAlignment=Enum.TextYAlignment.Center
                arrLbl.ZIndex=9; arrLbl.Parent=dHead

                -- Divisória
                local dDiv=Instance.new("Frame"); dDiv.Size=UDim2.new(1,-10,0,1)
                dDiv.Position=UDim2.new(0,5,0,EH); dDiv.BackgroundColor3=C.DIV
                dDiv.BorderSizePixel=0; dDiv.ZIndex=7; dDiv.Parent=outer

                -- Lista de opções
                local optBox=Instance.new("Frame"); optBox.Size=UDim2.new(1,0,0,0)
                optBox.Position=UDim2.new(0,0,0,EH+1); optBox.BackgroundTransparency=1
                optBox.BorderSizePixel=0; optBox.ZIndex=8; optBox.Parent=outer
                local optLL=vlist(optBox,2); pad(optBox,3,3,5,5)

                local function buildOpts(lst)
                    for _,ch in ipairs(optBox:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    for _,opt in ipairs(lst) do
                        local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,0,0,24)
                        ob.BackgroundColor3=C.OPT; ob.BorderSizePixel=0
                        ob.AutoButtonColor=false
                        ob.Text="  "..tostring(opt)
                        ob.Font=Enum.Font.GothamSemibold; ob.TextSize=11
                        ob.TextColor3=C.TXT_MID; ob.TextXAlignment=Enum.TextXAlignment.Left
                        ob.ZIndex=10; ob.Parent=optBox; corner(ob,5)
                        ob.MouseEnter:Connect(function()
                            tween(ob,{BackgroundColor3=C.OPT_H,TextColor3=C.TXT},0.06) end)
                        ob.MouseLeave:Connect(function()
                            tween(ob,{BackgroundColor3=C.OPT,TextColor3=C.TXT_MID},0.06) end)
                        ob.MouseButton1Click:Connect(function()
                            selVal=opt
                            local sv=tostring(opt)
                            if #sv>9 then sv=sv:sub(1,8)..".." end
                            dSub.Text="Select: "..sv
                            isOpen=false; arrLbl.Text="v"
                            -- fecha: volta para EH
                            tween(outer,{Size=UDim2.new(0.5,-(math.ceil(GAP/2)),0,EH)},0.13,
                                Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
                            pcall(callback,opt)
                        end)
                    end
                end
                buildOpts(options)

                dHead.MouseEnter:Connect(function() tween(outer,{BackgroundColor3=C.ELEM_H},0.07) end)
                dHead.MouseLeave:Connect(function() tween(outer,{BackgroundColor3=C.ELEM},0.07) end)

                dHead.MouseButton1Click:Connect(function()
                    isOpen=not isOpen
                    if isOpen then
                        arrLbl.Text="^"
                        -- Calcula altura das opções
                        local oh=optLL.AbsoluteContentSize.Y+6
                        -- Abre: cresce o outer → curRow com AutomaticSize cresce → panel cresce → scroll rola
                        tween(outer,{Size=UDim2.new(0.5,-(math.ceil(GAP/2)),0,EH+1+oh)},0.16,
                            Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
                    else
                        arrLbl.Text="v"
                        tween(outer,{Size=UDim2.new(0.5,-(math.ceil(GAP/2)),0,EH)},0.12,
                            Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
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
                        local oh=optLL.AbsoluteContentSize.Y+6
                        outer.Size=UDim2.new(0.5,-(math.ceil(GAP/2)),0,EH+1+oh)
                    end
                end
                function D:SetSelected(v)
                    selVal=v; local sv=tostring(v)
                    if #sv>9 then sv=sv:sub(1,8)..".." end
                    dSub.Text="Select: "..sv
                end
                function D:GetSelected() return selVal end
                return D
            end

            ------------------------------------------------------------
            -- NewSlider — largura total
            ------------------------------------------------------------
            function Section:NewSlider(name,tip,maxV,minV,callback)
                curRow=nil; rowCount=0
                maxV=tonumber(maxV) or 100; minV=tonumber(minV) or 0
                callback=callback or function() end; local cur=minV

                local dispName=(name:match("^・?(.+)$") or name)

                local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,EH+6)
                row.BackgroundColor3=C.ELEM; row.BorderSizePixel=0
                row.ZIndex=5; row.Parent=panel; corner(row,9); stroke(row,C.ELEM_STR,1)

                local nLbl=Instance.new("TextLabel"); nLbl.Size=UDim2.new(1,-12,0,TX_T+2)
                nLbl.Position=UDim2.new(0,10,0,8); nLbl.BackgroundTransparency=1
                nLbl.Text=dispName.."  "..tostring(cur)
                nLbl.TextSize=TX_T; nLbl.Font=Enum.Font.GothamBold; nLbl.TextColor3=C.TXT
                nLbl.TextXAlignment=Enum.TextXAlignment.Left; nLbl.ZIndex=6; nLbl.Parent=row

                local track=Instance.new("Frame"); track.Size=UDim2.new(1,-20,0,4)
                track.Position=UDim2.new(0,10,0,EH-4); track.BackgroundColor3=C.SL_TR
                track.BorderSizePixel=0; track.ZIndex=6; track.Parent=row; corner(track,2)

                local fill=Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0)
                fill.BackgroundColor3=C.SL_FILL; fill.BorderSizePixel=0
                fill.ZIndex=7; fill.Parent=track; corner(fill,2)

                local handle=Instance.new("Frame"); handle.Size=UDim2.new(0,11,0,11)
                handle.AnchorPoint=Vector2.new(0.5,0.5); handle.Position=UDim2.new(0,0,0.5,0)
                handle.BackgroundColor3=Color3.fromRGB(255,255,255)
                handle.BorderSizePixel=0; handle.ZIndex=9; handle.Parent=track; corner(handle,6)

                local grab=Instance.new("TextButton"); grab.Size=UDim2.new(1,0,0,24)
                grab.Position=UDim2.new(0,0,0.5,-12); grab.BackgroundTransparency=1
                grab.Text=""; grab.ZIndex=10; grab.Parent=track

                local mouse=Players.LocalPlayer:GetMouse(); local sliding=false

                local function applyX(mx)
                    local tw2=track.AbsoluteSize.X
                    local rx=math.clamp(mx-track.AbsolutePosition.X,0,tw2)
                    local pct=rx/math.max(tw2,1); cur=math.floor(minV+(maxV-minV)*pct)
                    fill.Size=UDim2.new(0,rx,1,0); handle.Position=UDim2.new(0,rx,0.5,0)
                    nLbl.Text=dispName.."  "..tostring(cur); pcall(callback,cur)
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

            ------------------------------------------------------------
            -- NewTextBox — 2 por linha
            ------------------------------------------------------------
            function Section:NewTextBox(name,tip,callback)
                callback=callback or function() end
                local iconChar="T"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                local cell,_=newHalfFrame(false)
                mkIcon(cell,iconChar,C.SCHEME); mkTS(cell,dispName,tip or "")

                local bBg=Instance.new("Frame"); bBg.Size=UDim2.new(0,44,0,22)
                bBg.Position=UDim2.new(1,-50,0.5,-11); bBg.BackgroundColor3=C.BADGE_BG
                bBg.BorderSizePixel=0; bBg.ZIndex=7; bBg.Parent=cell; corner(bBg,6); stroke(bBg,C.BADGE_STR,1)

                local tb=Instance.new("TextBox"); tb.Size=UDim2.new(1,-6,1,0)
                tb.Position=UDim2.new(0,3,0,0); tb.BackgroundTransparency=1; tb.Text=""
                tb.PlaceholderText=tip or "..."; tb.PlaceholderColor3=C.TXT_DIM
                tb.Font=Enum.Font.GothamBold; tb.TextSize=10; tb.TextColor3=C.BADGE_TXT
                tb.TextXAlignment=Enum.TextXAlignment.Center; tb.TextYAlignment=Enum.TextYAlignment.Center
                tb.ClearTextOnFocus=false; tb.ZIndex=8; tb.Parent=bBg

                tb.Focused:Connect(function()
                    tween(bBg,{BackgroundColor3=C.ELEM_H},0.09); stroke(bBg,C.SCHEME,1) end)
                tb.FocusLost:Connect(function(enter)
                    tween(bBg,{BackgroundColor3=C.BADGE_BG},0.09); stroke(bBg,C.BADGE_STR,1)
                    if enter then pcall(callback,tb.Text) end
                end)

                local TX={}
                function TX:SetText(s) pcall(function() tb.Text=tostring(s or "") end) end
                function TX:GetText() return tb.Text end
                function TX:Clear() tb.Text="" end
                return TX
            end

            ------------------------------------------------------------
            -- NewKeybind — 2 por linha
            ------------------------------------------------------------
            function Section:NewKeybind(name,tip,defaultKey,callback)
                defaultKey=defaultKey or Enum.KeyCode.F; callback=callback or function() end
                local curKey=defaultKey; local listening=false

                local iconChar="K"; local dispName=name
                local ei2,en2=name:match("^(.-)・(.+)$")
                if ei2 and en2 then iconChar=ei2; dispName=en2 end
                dispName=dispName:match("^・?(.+)$") or dispName

                local cell,_=newHalfFrame(true)
                mkIcon(cell,iconChar,C.SCHEME); mkTS(cell,dispName,tip or "")

                local kBg=Instance.new("Frame"); kBg.Size=UDim2.new(0,40,0,20)
                kBg.Position=UDim2.new(1,-46,0.5,-10); kBg.BackgroundColor3=C.BADGE_BG
                kBg.BorderSizePixel=0; kBg.ZIndex=7; kBg.Parent=cell; corner(kBg,5); stroke(kBg,C.BADGE_STR,1)

                local kLbl=Instance.new("TextLabel"); kLbl.Size=UDim2.new(1,0,1,0)
                kLbl.BackgroundTransparency=1; kLbl.Text=defaultKey.Name
                kLbl.Font=Enum.Font.GothamBold; kLbl.TextSize=9; kLbl.TextColor3=C.BADGE_TXT
                kLbl.TextXAlignment=Enum.TextXAlignment.Center; kLbl.TextYAlignment=Enum.TextYAlignment.Center
                kLbl.ZIndex=8; kLbl.Parent=kBg

                cell.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening=true; kLbl.Text="..."; kLbl.TextColor3=C.TXT_DIM; stroke(kBg,C.SCHEME,1)
                    local conn; conn=UserInputService.InputBegan:Connect(function(inp,gp)
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

            ------------------------------------------------------------
            -- NewLabel — largura total
            ------------------------------------------------------------
            function Section:NewLabel(text)
                curRow=nil; rowCount=0
                local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,22)
                row.BackgroundTransparency=1; row.BorderSizePixel=0; row.ZIndex=5; row.Parent=panel

                local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-8,0,22)
                nl.Position=UDim2.new(0,4,0,0); nl.BackgroundTransparency=1
                nl.Text=text or ""; nl.TextSize=10; nl.Font=Enum.Font.Gotham
                nl.TextColor3=C.TXT_DIM; nl.TextXAlignment=Enum.TextXAlignment.Left
                nl.TextYAlignment=Enum.TextYAlignment.Center; nl.TextWrapped=true
                nl.ZIndex=6; nl.Parent=row

                nl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h=math.max(22,nl.TextBounds.Y+6)
                    row.Size=UDim2.new(1,0,0,h); nl.Size=UDim2.new(1,-8,0,h)
                end)

                local L={}; function L:UpdateLabel(t) nl.Text=t or "" end; return L
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

    function Window:ChangeColor(propOrTable,color)
        if typeof(propOrTable)=="table" then
            local t=propOrTable
            if t.SchemeColor then
                C.SCHEME=t.SchemeColor; C.SL_FILL=t.SchemeColor; C.TAB_ON=t.SchemeColor
                C.TXT_ACT=t.SchemeColor; C.SCROLL=t.SchemeColor; C.TOG_ON=t.SchemeColor
            end
            if t.Background   then C.WIN=t.Background   end
            if t.TextColor    then C.TXT=t.TextColor    end
            if t.ElementColor then C.ELEM=t.ElementColor end
        elseif typeof(propOrTable)=="string" then
            if propOrTable=="SchemeColor" then
                C.SCHEME=color; C.SL_FILL=color; C.TAB_ON=color
                C.TXT_ACT=color; C.SCROLL=color; C.TOG_ON=color
            elseif propOrTable=="Background"   then C.WIN=color
            elseif propOrTable=="TextColor"    then C.TXT=color
            elseif propOrTable=="ElementColor" then C.ELEM=color
            end
        end
    end

    ------------------------------------------------------------------
    -- INTRO → mostra GUI
    ------------------------------------------------------------------
    playIntro(title,function()
        sg.Enabled=true
        win.Size=UDim2.new(0,WIN_W,0,0); win.BackgroundTransparency=1
        tween(win,{Size=UDim2.new(0,WIN_W,0,WIN_H),BackgroundTransparency=0},0.34,
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
