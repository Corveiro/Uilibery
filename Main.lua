local Library = {}

-- [ Enhanced Utility Functions ] --
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

-- 1. Melhoria: Sistema de Notificação Integrado com Design Premium
function Library:Notify(titulo, mensagem)
    local LogoID = "rbxassetid://101817370702077"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NM_Notify"
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    
    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 12) -- 2. Melhoria: Cor de fundo mais profunda
    Frame.Position = UDim2.new(1, 20, 0.85, 0)
    Frame.Size = UDim2.new(0, 280, 0, 70) -- 3. Melhoria: Tamanho ajustado para melhor legibilidade
    
    local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 12); UICorner.Parent = Frame -- 4. Melhoria: Bordas mais arredondadas
    local UIStroke = Instance.new("UIStroke"); UIStroke.Parent = Frame; UIStroke.Color = Color3.fromRGB(60, 60, 80); UIStroke.Thickness = 1.5 -- 5. Melhoria: Stroke mais visível e elegante

    -- 6. Melhoria: Gradiente de fundo na notificação
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = Frame

    local Logo = Instance.new("ImageLabel")
    Logo.Parent = Frame
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 12, 0, 12)
    Logo.Size = UDim2.new(0, 46, 0, 46)
    Logo.Image = LogoID
    Logo.ScaleType = Enum.ScaleType.Fit

    local Title = Instance.new("TextLabel")
    Title.Parent = Frame; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 70, 0, 14); Title.Size = UDim2.new(1, -80, 0, 20)
    Title.Font = Enum.Font.GothamBold; Title.Text = titulo; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 15; Title.TextXAlignment = Enum.TextXAlignment.Left

    local Msg = Instance.new("TextLabel")
    Msg.Parent = Frame; Msg.BackgroundTransparency = 1; Msg.Position = UDim2.new(0, 70, 0, 34); Msg.Size = UDim2.new(1, -80, 0, 24)
    Msg.Font = Enum.Font.GothamMedium; Msg.Text = mensagem; Msg.TextColor3 = Color3.fromRGB(200, 200, 220); Msg.TextSize = 13; Msg.TextXAlignment = Enum.TextXAlignment.Left; Msg.TextWrapped = true
    
    -- 7. Melhoria: Animação de entrada suave com Elastic
    TweenService:Create(Frame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0.85, 0)}):Play()

    task.delay(10, function()
        if Frame then
            -- 8. Melhoria: Animação de saída com desvanecimento
            TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.85, 0), BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            ScreenGui:Destroy()
        end
    end)
end

-- 9. Melhoria: TweenInstance aprimorado com suporte a múltiplos estilos
function Library:TweenInstance(Instance, Time, Property, Value, Style)
    local info = TweenInfo.new(Time, Style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(Instance, info, { [Property] = Value })
    tween:Play()
    return tween
end

function Library:UpdateScrolling(Scroll, List)
    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 20)
    end)
end

function Library:MakeConfig(Config, NewConfig)
    for i, v in next, Config do
        if NewConfig[i] == nil then
            NewConfig[i] = v
        end
    end
    return NewConfig
end

-- 10. Melhoria: Sistema de arraste mais suave e responsivo para Mobile
function Library:MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = pos }):Play()
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then UpdatePos(input) end
    end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "ARCADE HUB",
        Description = "Enhanced Edition",
        AccentColor = Color3.fromRGB(255, 40, 40)
    }, ConfigWindow or {})

    local ArcadeUI = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    local Top = Instance.new("Frame")
    local NameHub = Instance.new("TextLabel")
    local LogoHub = Instance.new("ImageLabel")
    local Desc = Instance.new("TextLabel")
    
    local RightButtons = Instance.new("Frame")
    local UIListLayout_Buttons = Instance.new("UIListLayout")
    local Close = Instance.new("TextButton")
    local Minize = Instance.new("TextButton")
    
    local TabHolder = Instance.new("ScrollingFrame")
    local TabListLayout = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    
    local ContentFrame = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")

    ArcadeUI.Name = "ArcadeUI_Enhanced"
    ArcadeUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    ArcadeUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- 11. Melhoria: Sombra realística para profundidade
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = DropShadowHolder
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

    DropShadowHolder.Name = "MainContainer"
    DropShadowHolder.Parent = ArcadeUI
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 450, 0, 330) -- 12. Melhoria: Tamanho levemente aumentado

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18) -- 13. Melhoria: Cor de fundo moderna
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 10) -- 14. Melhoria: Cantos mais suaves
    UICorner.Parent = Main

    UIStroke.Color = ConfigWindow.AccentColor
    UIStroke.Thickness = 1.8
    UIStroke.Transparency = 0.2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Main

    -- 15. Melhoria: Linha de brilho interna (Inner Glow)
    local InnerStroke = Instance.new("UIStroke")
    InnerStroke.Color = Color3.fromRGB(255, 255, 255)
    InnerStroke.Thickness = 1
    InnerStroke.Transparency = 0.9
    InnerStroke.Parent = Main

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Top.Size = UDim2.new(1, 0, 0, 45) -- 16. Melhoria: Topbar mais alta

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 12, 0, 7)
    LogoHub.Size = UDim2.new(0, 30, 0, 30)
    LogoHub.Image = "rbxassetid://101817370702077"

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 50, 0, 8)
    NameHub.Size = UDim2.new(0, 200, 0, 16)
    NameHub.Font = Enum.Font.GothamBold -- 17. Melhoria: Fonte mais moderna para o título
    NameHub.Text = ConfigWindow.Title:upper()
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 16
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 50, 0, 24)
    Desc.Size = UDim2.new(0, 200, 0, 12)
    Desc.Font = Enum.Font.Code
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = ConfigWindow.AccentColor
    Desc.TextSize = 11
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -75, 0, 0)
    RightButtons.Size = UDim2.new(0, 70, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 8)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 24, 0, 24)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.TextSize = 20

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 24, 0, 24)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "−"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 200)
    Minize.TextSize = 20

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    TabHolder.Position = UDim2.new(0, 0, 0, 45)
    TabHolder.Size = UDim2.new(1, 0, 0, 35) -- 18. Melhoria: TabHolder mais espaçoso
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.ScrollingDirection = Enum.ScrollingDirection.X

    TabListLayout.Parent = TabHolder
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 12)

    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 15)

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 30, 0, 0)
    end)

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 80)
    ContentFrame.Size = UDim2.new(1, 0, 1, -80)
    ContentFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame
    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart -- 19. Melhoria: Transição de página mais suave
    PageLayout.TweenTime = 0.5

    self:MakeDraggable(Top, DropShadowHolder)

    -- 20. Melhoria: Animação de fechar/abrir suave
    Close.MouseButton1Click:Connect(function() 
        Library:TweenInstance(Main, 0.4, "Size", UDim2.new(1, 0, 0, 0))
        task.wait(0.4)
        ArcadeUI:Destroy() 
    end)
    
    Minize.MouseButton1Click:Connect(function() 
        ArcadeUI.Enabled = not ArcadeUI.Enabled 
    end)

    local TabCount = 0
    local Tab = {}
    local FirstTab = true

    function Tab:T(t, iconid)
        local TabPage = Instance.new("ScrollingFrame")
        local TabListLayout_Page = Instance.new("UIListLayout")
        local TabPadding_Page = Instance.new("UIPadding")
        
        TabPage.Name = t
        TabPage.Parent = PageList
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 3 -- 21. Melhoria: Scrollbar mais visível
        TabPage.ScrollBarImageColor3 = ConfigWindow.AccentColor
        TabPage.LayoutOrder = TabCount
        
        TabListLayout_Page.Parent = TabPage
        TabListLayout_Page.Padding = UDim.new(0, 8)
        TabListLayout_Page.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding_Page.Parent = TabPage
        TabPadding_Page.PaddingLeft = UDim.new(0, 12)
        TabPadding_Page.PaddingRight = UDim.new(0, 12)
        TabPadding_Page.PaddingTop = UDim.new(0, 12)
        TabPadding_Page.PaddingBottom = UDim.new(0, 12)

        Library:UpdateScrolling(TabPage, TabListLayout_Page)

        local TabBtn = Instance.new("TextButton")
        local TabBtnTitle = Instance.new("TextLabel")
        local TabIndicator = Instance.new("Frame")

        TabBtn.Name = t .. "_Tab"
        TabBtn.Parent = TabHolder
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.Text = ""
        TabBtn.LayoutOrder = TabCount

        TabBtnTitle.Parent = TabBtn
        TabBtnTitle.BackgroundTransparency = 1
        TabBtnTitle.Size = UDim2.new(1, 0, 1, 0)
        TabBtnTitle.Font = Enum.Font.GothamBold
        TabBtnTitle.Text = t:upper()
        TabBtnTitle.TextColor3 = Color3.fromRGB(120, 120, 140)
        TabBtnTitle.TextSize = 12
        
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabBtn
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 1, -2)
        TabIndicator.Size = UDim2.new(0, 0, 0, 2) -- Inicia com tamanho 0
        TabIndicator.Transparency = 0

        local function UpdateTabBtnSize()
            local textWidth = TextService:GetTextSize(TabBtnTitle.Text, TabBtnTitle.TextSize, TabBtnTitle.Font, Vector2.new(1000, 1000)).X
            TabBtn.Size = UDim2.new(0, textWidth + 24, 1, 0)
        end
        UpdateTabBtnSize()

        local function Activate()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:TweenInstance(v.TextLabel, 0.3, "TextColor3", Color3.fromRGB(120, 120, 140))
                    Library:TweenInstance(v.Indicator, 0.3, "Size", UDim2.new(0, 0, 0, 2))
                end
            end
            Library:TweenInstance(TabBtnTitle, 0.3, "TextColor3", Color3.fromRGB(255, 255, 255))
            Library:TweenInstance(TabIndicator, 0.3, "Size", UDim2.new(1, 0, 0, 2))
            PageLayout:JumpTo(TabPage)
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            task.spawn(Activate)
        end

        TabCount = TabCount + 1

        local TabFunc = {}

        function TabFunc:AddSection(SectionTitle)
            local SectionFrame = Instance.new("Frame")
            local SectionTitleLabel = Instance.new("TextLabel")
            local CurrentGroup = Instance.new("Frame")
            local GroupLayout = Instance.new("UIListLayout")
            
            SectionFrame.Name = SectionTitle .. "_Section"
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            SectionTitleLabel.Parent = SectionFrame
            SectionTitleLabel.BackgroundTransparency = 1
            SectionTitleLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionTitleLabel.Font = Enum.Font.GothamBold
            SectionTitleLabel.Text = SectionTitle:upper()
            SectionTitleLabel.TextColor3 = ConfigWindow.AccentColor
            SectionTitleLabel.TextSize = 11
            SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

            CurrentGroup.Name = "Elements"
            CurrentGroup.Parent = SectionFrame
            CurrentGroup.BackgroundTransparency = 1
            CurrentGroup.Position = UDim2.new(0, 0, 0, 25)
            CurrentGroup.Size = UDim2.new(1, 0, 0, 0)
            CurrentGroup.AutomaticSize = Enum.AutomaticSize.Y
            
            GroupLayout.Parent = CurrentGroup
            GroupLayout.Padding = UDim.new(0, 6)
            GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local SectionFunc = {}

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Callback = function() end }, cfbtn or {})
                local BtnFrame = Instance.new("Frame")
                local BtnCorner = Instance.new("UICorner")
                local Btn = Instance.new("TextButton")
                local BtnIcon = Instance.new("ImageLabel")

                BtnFrame.Parent = CurrentGroup
                BtnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38) -- 22. Melhoria: Elementos com cor mais viva
                BtnFrame.Size = UDim2.new(1, 0, 0, 34)
                
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = BtnFrame
                
                -- 23. Melhoria: Stroke individual nos elementos
                local ElemStroke = Instance.new("UIStroke")
                ElemStroke.Color = Color3.fromRGB(50, 50, 70)
                ElemStroke.Thickness = 1
                ElemStroke.Parent = BtnFrame

                Btn.Parent = BtnFrame
                Btn.BackgroundTransparency = 1
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.Font = Enum.Font.GothamMedium
                Btn.Text = cfbtn.Title
                Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
                Btn.TextSize = 13
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.PaddingLeft = UDim.new(0, 12)

                BtnIcon.Parent = BtnFrame
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(1, -30, 0.5, -9)
                BtnIcon.Size = UDim2.new(0, 18, 0, 18)
                BtnIcon.Image = "rbxassetid://101817370702077"
                BtnIcon.ImageColor3 = ConfigWindow.AccentColor
                BtnIcon.ImageTransparency = 0.3

                Btn.MouseButton1Click:Connect(function()
                    -- 24. Melhoria: Efeito visual de clique (Flash)
                    local flash = Instance.new("Frame")
                    flash.Parent = BtnFrame
                    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    flash.BackgroundTransparency = 0.8
                    flash.Size = UDim2.new(1, 0, 1, 0)
                    flash.ZIndex = 5
                    Instance.new("UICorner", flash).CornerRadius = UDim.new(0, 6)
                    TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    task.delay(0.3, function() flash:Destroy() end)
                    
                    pcall(cfbtn.Callback)
                end)
                
                return { Set = function(self, val) Btn.Text = val end }
            end

            function SectionFunc:AddToggle(cftog)
                cftog = Library:MakeConfig({ Title = "Toggle", Default = false, Callback = function() end }, cftog or {})
                local TogFrame = Instance.new("Frame")
                local TogCorner = Instance.new("UICorner")
                local TogBtn = Instance.new("TextButton")
                local TogTitle = Instance.new("TextLabel")
                local TogOuter = Instance.new("Frame")
                local TogInner = Instance.new("Frame")
                local TogInnerCorner = Instance.new("UICorner")
                local TogOuterCorner = Instance.new("UICorner")

                TogFrame.Parent = CurrentGroup
                TogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                TogFrame.Size = UDim2.new(1, 0, 0, 34)
                
                TogCorner.CornerRadius = UDim.new(0, 6)
                TogCorner.Parent = TogFrame
                
                local ElemStroke = Instance.new("UIStroke")
                ElemStroke.Color = Color3.fromRGB(50, 50, 70)
                ElemStroke.Thickness = 1
                ElemStroke.Parent = TogFrame

                TogBtn.Parent = TogFrame
                TogBtn.BackgroundTransparency = 1
                TogBtn.Size = UDim2.new(1, 0, 1, 0)
                TogBtn.Text = ""

                TogTitle.Parent = TogFrame
                TogTitle.BackgroundTransparency = 1
                TogTitle.Position = UDim2.new(0, 12, 0, 0)
                TogTitle.Size = UDim2.new(1, -60, 1, 0)
                TogTitle.Font = Enum.Font.GothamMedium
                TogTitle.Text = cftog.Title
                TogTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                TogTitle.TextSize = 13
                TogTitle.TextXAlignment = Enum.TextXAlignment.Left

                TogOuter.Name = "Outer"
                TogOuter.Parent = TogFrame
                TogOuter.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                TogOuter.Position = UDim2.new(1, -45, 0.5, -10)
                TogOuter.Size = UDim2.new(0, 35, 0, 20)
                
                TogOuterCorner.CornerRadius = UDim.new(1, 0)
                TogOuterCorner.Parent = TogOuter

                TogInner.Name = "Inner"
                TogInner.Parent = TogOuter
                TogInner.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
                TogInner.Position = UDim2.new(0, 2, 0.5, -8)
                TogInner.Size = UDim2.new(0, 16, 0, 16)
                
                TogInnerCorner.CornerRadius = UDim.new(1, 0)
                TogInnerCorner.Parent = TogInner

                local Toggled = cftog.Default
                local function UpdateTog()
                    local targetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local targetColor = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(100, 100, 120)
                    Library:TweenInstance(TogInner, 0.2, "Position", targetPos)
                    Library:TweenInstance(TogInner, 0.2, "BackgroundColor3", targetColor)
                    -- 25. Melhoria: Glow no toggle quando ativo
                    Library:TweenInstance(TogOuter, 0.2, "BackgroundColor3", Toggled and Color3.fromRGB(30, 30, 45) or Color3.fromRGB(15, 15, 25))
                end
                UpdateTog()

                TogBtn.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateTog()
                    pcall(cftog.Callback, Toggled)
                end)
                
                return { Set = function(self, val) Toggled = val UpdateTog() pcall(cftog.Callback, Toggled) end }
            end

            function SectionFunc:AddSlider(cfslid)
                cfslid = Library:MakeConfig({ Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslid or {})
                local SlidFrame = Instance.new("Frame")
                local SlidCorner = Instance.new("UICorner")
                local SlidTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBack = Instance.new("Frame")
                local SliderFill = Instance.new("Frame")
                local SliderCorner2 = Instance.new("UICorner")
                local SliderCorner3 = Instance.new("UICorner")
                local SliderBtn = Instance.new("TextButton")

                SlidFrame.Parent = CurrentGroup
                SlidFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                SlidFrame.Size = UDim2.new(1, 0, 0, 45)
                
                SlidCorner.CornerRadius = UDim.new(0, 6)
                SlidCorner.Parent = SlidFrame
                
                local ElemStroke = Instance.new("UIStroke")
                ElemStroke.Color = Color3.fromRGB(50, 50, 70)
                ElemStroke.Thickness = 1
                ElemStroke.Parent = SlidFrame

                SlidTitle.Parent = SlidFrame
                SlidTitle.BackgroundTransparency = 1
                SlidTitle.Position = UDim2.new(0, 12, 0, 5)
                SlidTitle.Size = UDim2.new(1, -70, 0, 20)
                SlidTitle.Font = Enum.Font.GothamMedium
                SlidTitle.Text = cfslid.Title
                SlidTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SlidTitle.TextSize = 13
                SlidTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Parent = SlidFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -60, 0, 5)
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.Font = Enum.Font.Code
                SliderValue.Text = tostring(cfslid.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 13
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBack.Parent = SlidFrame
                SliderBack.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                SliderBack.Position = UDim2.new(0, 12, 0, 30)
                SliderBack.Size = UDim2.new(1, -24, 0, 6)
                
                SliderCorner2.CornerRadius = UDim.new(1, 0)
                SliderCorner2.Parent = SliderBack

                SliderFill.Parent = SliderBack
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new((cfslid.Default - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0)
                
                SliderCorner3.CornerRadius = UDim.new(1, 0)
                SliderCorner3.Parent = SliderFill

                SliderBtn.Parent = SliderBack
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.Text = ""

                local function UpdateSlider()
                    local mousePos = UserInputService:GetMouseLocation().X
                    local framePos = SliderBack.AbsolutePosition.X
                    local frameSize = SliderBack.AbsoluteSize.X
                    local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                    local val = math.floor(cfslid.Min + (cfslid.Max - cfslid.Min) * percent)
                    
                    SliderValue.Text = tostring(val)
                    -- 26. Melhoria: Animação suave na barra do slider
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                    pcall(cfslid.Callback, val)
                end

                local Sliding = false
                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = true
                        UpdateSlider()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider()
                    end
                end)
                
                return { Set = function(self, val) SliderValue.Text = tostring(val) SliderFill.Size = UDim2.new((val - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0) pcall(cfslid.Callback, val) end }
            end

            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({ Title = "Dropdown", Options = {}, Values = {}, Default = "", Callback = function() end }, cfdrop or {})
                local options = #cfdrop.Options > 0 and cfdrop.Options or cfdrop.Values
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("TextLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                DropFrame.Size = UDim2.new(1, 0, 0, 34)
                DropFrame.ClipsDescendants = true
                
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropFrame
                
                local ElemStroke = Instance.new("UIStroke")
                ElemStroke.Color = Color3.fromRGB(50, 50, 70)
                ElemStroke.Thickness = 1
                ElemStroke.Parent = DropFrame
                
                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 34)
                DropBtn.Text = ""
                
                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 12, 0, 0)
                DropTitle.Size = UDim2.new(1, -40, 0, 34)
                DropTitle.Font = Enum.Font.GothamMedium
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropTitle.TextSize = 12
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -30, 0, 0)
                DropIcon.Size = UDim2.new(0, 30, 0, 34)
                DropIcon.Font = Enum.Font.GothamBold
                DropIcon.Text = "+"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 16

                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 34)
                DropList.Size = UDim2.new(1, 0, 0, 0)
                
                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 5)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 8)
                DropPadding.PaddingLeft = UDim.new(0, 8)
                DropPadding.PaddingRight = UDim.new(0, 8)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 40) or 34
                    Library:TweenInstance(DropFrame, 0.4, "Size", UDim2.new(1, 0, 0, targetSize), Enum.EasingStyle.Quart)
                    -- 27. Melhoria: Animação de rotação no ícone do dropdown
                    Library:TweenInstance(DropIcon, 0.3, "Rotation", Open and 45 or 0)
                    DropIcon.Text = Open and "×" or "+"
                end
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                        OptBtn.Size = UDim2.new(1, 0, 0, 30)
                        OptBtn.Font = Enum.Font.GothamMedium
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptBtn.TextSize = 12
                        
                        OptCorner.CornerRadius = UDim.new(0, 4)
                        OptCorner.Parent = OptBtn
                        
                        -- 28. Melhoria: Feedback visual ao selecionar opção
                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. " : " .. opt
                            ToggleDrop()
                            pcall(cfdrop.Callback, opt)
                        end)
                    end
                end
                AddOptions(options)
                
                return { 
                    Refresh = function(self, newopts) 
                        for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end 
                        AddOptions(newopts) 
                    end, 
                    Set = function(self, val) 
                        DropTitle.Text = cfdrop.Title .. " : " .. tostring(val) 
                        pcall(cfdrop.Callback, val) 
                    end 
                }
            end

            function SectionFunc:AddTextbox(cfbox)
                cfbox = Library:MakeConfig({ Title = "Textbox", Description = "", Default = "", Callback = function() end }, cfbox or {})
                local BoxFrame = Instance.new("Frame")
                local BoxCorner = Instance.new("UICorner")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                local InputStroke = Instance.new("UIStroke")

                BoxFrame.Parent = CurrentGroup
                BoxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                BoxFrame.Size = UDim2.new(1, 0, 0, 34)
                
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = BoxFrame
                
                local ElemStroke = Instance.new("UIStroke")
                ElemStroke.Color = Color3.fromRGB(50, 50, 70)
                ElemStroke.Thickness = 1
                ElemStroke.Parent = BoxFrame
                
                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 12, 0, 0)
                BoxTitle.Size = UDim2.new(0, 100, 1, 0)
                BoxTitle.Font = Enum.Font.GothamMedium
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BoxTitle.TextSize = 12
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                BoxInput.Position = UDim2.new(1, -135, 0.5, -11)
                BoxInput.Size = UDim2.new(0, 125, 0, 22)
                BoxInput.Font = Enum.Font.Code
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = ConfigWindow.AccentColor
                BoxInput.TextSize = 12
                BoxInput.ClipsDescendants = true
                
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = BoxInput
                
                InputStroke.Color = Color3.fromRGB(60, 60, 80)
                InputStroke.Thickness = 1
                InputStroke.Parent = BoxInput

                -- 29. Melhoria: Animação de foco no Textbox
                BoxInput.Focused:Connect(function()
                    Library:TweenInstance(InputStroke, 0.3, "Color", ConfigWindow.AccentColor)
                    Library:TweenInstance(InputStroke, 0.3, "Thickness", 1.5)
                end)
                BoxInput.FocusLost:Connect(function()
                    Library:TweenInstance(InputStroke, 0.3, "Color", Color3.fromRGB(60, 60, 80))
                    Library:TweenInstance(InputStroke, 0.3, "Thickness", 1)
                    pcall(cfbox.Callback, BoxInput.Text) 
                end)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 22)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = "• " .. text
                Label.TextColor3 = Color3.fromRGB(170, 170, 190)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = "• " .. val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")
                
                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
                ParaFrame.Size = UDim2.new(1, 0, 0, 50)
                
                ParaCorner.CornerRadius = UDim.new(0, 6)
                ParaCorner.Parent = ParaFrame
                
                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 12, 0, 8)
                ParaTitle.Size = UDim2.new(1, -24, 0, 15)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title:upper()
                ParaTitle.TextColor3 = ConfigWindow.AccentColor
                ParaTitle.TextSize = 11
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 12, 0, 25)
                ParaContent.Size = UDim2.new(1, -24, 0, 18)
                ParaContent.Font = Enum.Font.GothamMedium
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(180, 180, 200)
                ParaContent.TextSize = 11
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true
                
                local function UpdateSize() 
                    local textHeight = TextService:GetTextSize(ParaContent.Text, ParaContent.TextSize, ParaContent.Font, Vector2.new(ParaContent.AbsoluteSize.X, 10000)).Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 35) 
                    ParaContent.Size = UDim2.new(1, -24, 0, textHeight) 
                end
                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                task.spawn(UpdateSize)
                
                return { SetTitle = function(self, val) ParaTitle.Text = val end, SetDesc = function(self, val) ParaContent.Text = val end, Set = function(self, val) ParaContent.Text = val end }
            end

            function SectionFunc:AddDiscord(DiscordTitle, InviteCode)
                local DiscordCard = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local Icon = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                
                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                DiscordCard.Size = UDim2.new(1, 0, 0, 65)
                
                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = DiscordCard
                
                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 12, 0, 12)
                Icon.Size = UDim2.new(0, 40, 0, 40)
                Icon.Image = "rbxassetid://101817370702077" -- Logo padrão
                Icon.ImageColor3 = Color3.fromRGB(114, 137, 218)

                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 65, 0, 15)
                Title.Size = UDim2.new(1, -140, 0, 15)
                Title.Font = Enum.Font.GothamBold
                Title.Text = (DiscordTitle or "Discord"):upper()
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 65, 0, 32)
                SubTitle.Size = UDim2.new(1, -140, 0, 15)
                SubTitle.Font = Enum.Font.GothamMedium
                SubTitle.Text = "discord.gg/" .. InviteCode
                SubTitle.TextColor3 = Color3.fromRGB(150, 150, 170)
                SubTitle.TextSize = 11
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
                JoinBtn.Position = UDim2.new(1, -75, 0.5, -15)
                JoinBtn.Size = UDim2.new(0, 65, 0, 30)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "JOIN"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 12
                
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = JoinBtn
                
                JoinBtn.MouseButton1Click:Connect(function() 
                    if setclipboard then setclipboard("https://discord.gg/" .. InviteCode) end 
                    JoinBtn.Text = "COPIED" 
                    task.wait(2) 
                    JoinBtn.Text = "JOIN" 
                end)
            end

            function SectionFunc:AddSeperator(text)
                local SeperatorFrame = Instance.new("Frame")
                local SeperatorLabel = Instance.new("TextLabel")
                local LineLeft = Instance.new("Frame")
                local LineRight = Instance.new("Frame")

                SeperatorFrame.Parent = CurrentGroup
                SeperatorFrame.BackgroundTransparency = 1
                SeperatorFrame.Size = UDim2.new(1, 0, 0, 25)

                SeperatorLabel.Parent = SeperatorFrame
                SeperatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                SeperatorLabel.BackgroundTransparency = 1
                SeperatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                SeperatorLabel.Size = UDim2.new(0, 0, 1, 0)
                SeperatorLabel.AutomaticSize = Enum.AutomaticSize.X
                SeperatorLabel.Font = Enum.Font.GothamBold
                SeperatorLabel.Text = text:upper()
                SeperatorLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
                SeperatorLabel.TextSize = 10

                LineLeft.Parent = SeperatorFrame
                LineLeft.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                LineLeft.BorderSizePixel = 0
                LineLeft.Position = UDim2.new(0, 5, 0.5, 0)
                LineLeft.Size = UDim2.new(0.5, -65, 0, 1)

                LineRight.Parent = SeperatorFrame
                LineRight.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                LineRight.BorderSizePixel = 0
                LineRight.Position = UDim2.new(1, -5, 0.5, 0)
                LineRight.AnchorPoint = Vector2.new(1, 0)
                LineRight.Size = UDim2.new(0.5, -65, 0, 1)
            end

            return SectionFunc
        end

        return TabFunc
    end

    -- 30. Melhoria: Botão de Toggle flutuante com design aprimorado para Mobile
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    ToggleBtn.Name = "ToggleUI_Enhanced"
    ToggleBtn.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 25, 0, 25)
    MainBtn.Size = UDim2.new(0, 50, 0, 50) -- Maior para facilitar o toque no mobile
    MainBtn.Image = "rbxassetid://101817370702077"
    
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn
    
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.5
    BtnStroke.Parent = MainBtn
    
    self:MakeDraggable(MainBtn, MainBtn)
    
    MainBtn.MouseButton1Click:Connect(function() 
        DropShadowHolder.Visible = not DropShadowHolder.Visible
        -- Animação de escala ao abrir/fechar
        if DropShadowHolder.Visible then
            DropShadowHolder.Size = UDim2.new(0, 0, 0, 0)
            Library:TweenInstance(DropShadowHolder, 0.5, "Size", UDim2.new(0, 450, 0, 330), Enum.EasingStyle.Elastic)
        end
    end)

    return Tab
end

return Library
