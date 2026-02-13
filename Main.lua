local Library = {}

-- [ Utility Functions ] --
function Library:TweenInstance(Instance, Time, OldValue, NewValue)
    local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Enum.EasingStyle.Quad), { [OldValue] = NewValue })
    rz_Tween:Play()
    return rz_Tween
end

function Library:UpdateScrolling(Scroll, List)
    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 15)
    end)
end

function Library:MakeConfig(Config, NewConfig)
    for i, v in next, Config do
        if not NewConfig[i] then
            NewConfig[i] = v
        end
    end
    return NewConfig
end

function Library:MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        game:GetService("TweenService"):Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = pos }):Play()
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
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == DragInput and Dragging then UpdatePos(input) end
    end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "SYNTRAX Hub",
        Description = "Premium Script",
        AccentColor = Color3.fromRGB(255, 0, 0)
    }, ConfigWindow or {})

    local TeddyUI_Premium = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local MainGradient = Instance.new("UIGradient")
    
    local Top = Instance.new("Frame")
    local TopGlow = Instance.new("Frame")
    local TopGlowGradient = Instance.new("UIGradient")
    local NameHub = Instance.new("TextLabel")
    local LogoHub = Instance.new("ImageLabel")
    local LogoGlow = Instance.new("ImageLabel")
    local Desc = Instance.new("TextLabel")
    
    local RightButtons = Instance.new("Frame")
    local UIListLayout_Buttons = Instance.new("UIListLayout")
    local Close = Instance.new("TextButton")
    local CloseCorner = Instance.new("UICorner")
    local Minize = Instance.new("TextButton")
    local MinizeCorner = Instance.new("UICorner")
    
    local TabHolder = Instance.new("ScrollingFrame")
    local TabListLayout = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    
    local ContentFrame = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")

    -- [ UI Setup ] --
    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Tamanho reduzido: de 520x380 para 440x340
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 440, 0, 340)

    -- Sombra mais suave e elegante
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 50, 1, 50)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.3
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    -- Main frame com gradiente elegante
    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    -- Borda com glow sutil
    UIStroke.Color = Color3.fromRGB(35, 35, 40)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.3
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Main

    -- Gradiente de fundo
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15))
    }
    MainGradient.Rotation = 45
    MainGradient.Parent = Main

    -- Header com glow accent
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Top.BackgroundTransparency = 0.3
    Top.Size = UDim2.new(1, 0, 0, 55)
    Top.BorderSizePixel = 0

    -- Glow no topo com accent color
    TopGlow.Name = "TopGlow"
    TopGlow.Parent = Top
    TopGlow.BackgroundColor3 = ConfigWindow.AccentColor
    TopGlow.Position = UDim2.new(0, 0, 1, -2)
    TopGlow.Size = UDim2.new(1, 0, 0, 2)
    TopGlow.BorderSizePixel = 0

    TopGlowGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    TopGlowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    TopGlowGradient.Parent = TopGlow

    -- Logo com efeito de glow
    LogoGlow.Name = "LogoGlow"
    LogoGlow.Parent = Top
    LogoGlow.BackgroundTransparency = 1
    LogoGlow.Position = UDim2.new(0, 15, 0.5, -18)
    LogoGlow.Size = UDim2.new(0, 36, 0, 36)
    LogoGlow.Image = "rbxassetid://11963352805"
    LogoGlow.ImageColor3 = ConfigWindow.AccentColor
    LogoGlow.ImageTransparency = 0.6

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 15, 0.5, -18)
    LogoHub.Size = UDim2.new(0, 36, 0, 36)
    LogoHub.Image = "rbxassetid://11963352805"
    LogoHub.ImageColor3 = Color3.fromRGB(255, 255, 255)

    -- Título mais elegante
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 58, 0, 12)
    NameHub.Size = UDim2.new(1, -200, 0, 18)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(245, 245, 250)
    NameHub.TextSize = 14
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    -- Descrição com cor suave
    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 58, 0, 30)
    Desc.Size = UDim2.new(1, -200, 0, 14)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(140, 140, 150)
    Desc.TextSize = 11
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    -- Botões de controle elegantes
    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.AnchorPoint = Vector2.new(1, 0)
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -12, 0, 12)
    RightButtons.Size = UDim2.new(0, 70, 0, 32)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Buttons.Padding = UDim.new(0, 8)

    -- Botão Minimizar
    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Minize.Size = UDim2.new(0, 32, 0, 32)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "—"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 210)
    Minize.TextSize = 14
    Minize.AutoButtonColor = false

    MinizeCorner.CornerRadius = UDim.new(0, 6)
    MinizeCorner.Parent = Minize

    Minize.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(Minize, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 52)}):Play()
    end)
    Minize.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(Minize, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
    end)
    Minize.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = false
    end)

    -- Botão Fechar com hover elegante
    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundColor3 = Color3.fromRGB(200, 35, 45)
    Close.Size = UDim2.new(0, 32, 0, 32)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "✕"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 16
    Close.AutoButtonColor = false

    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close

    Close.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(Close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 60)}):Play()
    end)
    Close.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(Close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 35, 45)}):Play()
    end)
    Close.MouseButton1Click:Connect(function()
        TeddyUI_Premium:Destroy()
    end)

    -- Tab Holder com scroll vertical
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.Active = true
    TabHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    TabHolder.BackgroundTransparency = 0
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 10, 0, 65)
    TabHolder.Size = UDim2.new(0, 120, 1, -75)
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 3
    TabHolder.ScrollBarImageColor3 = ConfigWindow.AccentColor
    TabHolder.ScrollBarImageTransparency = 0.5
    TabHolder.Visible = true

    TabListLayout.Parent = TabHolder
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)

    local TabHolderCorner = Instance.new("UICorner")
    TabHolderCorner.CornerRadius = UDim.new(0, 8)
    TabHolderCorner.Parent = TabHolder

    TabPadding.Parent = TabHolder
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.PaddingBottom = UDim.new(0, 8)

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 140, 0, 65)
    ContentFrame.Size = UDim2.new(1, -150, 1, -75)
    ContentFrame.ClipsDescendants = true
    ContentFrame.Visible = true

    PageLayout.Parent = ContentFrame
    PageLayout.FillDirection = Enum.FillDirection.Horizontal
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.EasingDirection = Enum.EasingDirection.Out
    PageLayout.TweenTime = 0.35
    PageLayout.Circular = false

    PageList.Parent = ContentFrame
    PageList.Name = "PageList"

    self:UpdateScrolling(TabHolder, TabListLayout)
    self:MakeDraggable(Top, Main)

    -- [ Tab Functions ] --
    local Tab = {}
    function Tab:CreateTab(TabConfig)
        TabConfig = Library:MakeConfig({
            Title = "New Tab",
            Icon = "rbxassetid://10734950309"
        }, TabConfig or {})

        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabStroke = Instance.new("UIStroke")
        local TabIcon = Instance.new("ImageLabel")
        local TabLabel = Instance.new("TextLabel")
        local TabGlow = Instance.new("Frame")

        local TabPage = Instance.new("ScrollingFrame")
        local PageListLayout = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        -- Tab Button com design elegante
        TabButton.Name = TabConfig.Title
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabButton.Size = UDim2.new(1, 0, 0, 42)
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        TabButton.Visible = true
        TabButton.ZIndex = 2

        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton

        TabStroke.Color = Color3.fromRGB(40, 40, 45)
        TabStroke.Thickness = 1
        TabStroke.Transparency = 0.5
        TabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        TabStroke.Parent = TabButton

        -- Glow indicator
        TabGlow.Name = "TabGlow"
        TabGlow.Parent = TabButton
        TabGlow.BackgroundColor3 = ConfigWindow.AccentColor
        TabGlow.Position = UDim2.new(0, 0, 0.5, -12)
        TabGlow.Size = UDim2.new(0, 3, 0, 24)
        TabGlow.BorderSizePixel = 0
        TabGlow.BackgroundTransparency = 1

        local TabGlowCorner = Instance.new("UICorner")
        TabGlowCorner.CornerRadius = UDim.new(1, 0)
        TabGlowCorner.Parent = TabGlow

        -- Tab Icon
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = TabConfig.Icon
        TabIcon.ImageColor3 = Color3.fromRGB(160, 160, 170)

        -- Tab Label
        TabLabel.Name = "TabLabel"
        TabLabel.Parent = TabButton
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 36, 0, 0)
        TabLabel.Size = UDim2.new(1, -42, 1, 0)
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.Text = TabConfig.Title
        TabLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
        TabLabel.TextSize = 12
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- Tab Page
        TabPage.Name = TabConfig.Title
        TabPage.Parent = PageList
        TabPage.Active = true
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = ConfigWindow.AccentColor
        TabPage.ScrollBarImageTransparency = 0.6
        TabPage.Visible = true

        PageListLayout.Parent = TabPage
        PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageListLayout.Padding = UDim.new(0, 8)

        PagePadding.Parent = TabPage
        PagePadding.PaddingTop = UDim.new(0, 8)
        PagePadding.PaddingLeft = UDim.new(0, 8)
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.PaddingBottom = UDim.new(0, 8)

        Library:UpdateScrolling(TabPage, PageListLayout)

        -- Tab Selection Logic
        local Selected = false
        local function SelectTab()
            if Selected then return end
            
            -- Deselect all tabs
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    game:GetService("TweenService"):Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
                    if btn:FindFirstChild("TabIcon") then
                        game:GetService("TweenService"):Create(btn.TabIcon, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(160, 160, 170)}):Play()
                    end
                    if btn:FindFirstChild("TabLabel") then
                        game:GetService("TweenService"):Create(btn.TabLabel, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(160, 160, 170)}):Play()
                    end
                    if btn:FindFirstChild("TabGlow") then
                        game:GetService("TweenService"):Create(btn.TabGlow, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
                    end
                end
            end

            -- Select this tab
            Selected = true
            game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
            game:GetService("TweenService"):Create(TabIcon, TweenInfo.new(0.25), {ImageColor3 = ConfigWindow.AccentColor}):Play()
            game:GetService("TweenService"):Create(TabLabel, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            game:GetService("TweenService"):Create(TabGlow, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
            
            PageLayout:JumpTo(TabPage)
            
            task.wait(0.25)
            Selected = false
        end

        TabButton.MouseButton1Click:Connect(SelectTab)

        -- Hover effects
        TabButton.MouseEnter:Connect(function()
            if not Selected then
                game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if not Selected then
                game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
            end
        end)

        -- Auto select first tab
        if #TabHolder:GetChildren() == 2 then
            SelectTab()
        end

        -- [ Section Functions ] --
        local TabFunc = {}
        function TabFunc:CreateSection(SectionTitle)
            local SectionFrame = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionHeader = Instance.new("Frame")
            local SectionTitle_Label = Instance.new("TextLabel")
            local SectionLine = Instance.new("Frame")
            local SectionLineGradient = Instance.new("UIGradient")
            local SectionContent = Instance.new("Frame")
            local SectionList = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionFrame.Name = SectionTitle
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionFrame

            SectionStroke.Color = Color3.fromRGB(35, 35, 42)
            SectionStroke.Thickness = 1
            SectionStroke.Transparency = 0.6
            SectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            SectionStroke.Parent = SectionFrame

            SectionHeader.Name = "Header"
            SectionHeader.Parent = SectionFrame
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 35)

            SectionTitle_Label.Name = "Title"
            SectionTitle_Label.Parent = SectionHeader
            SectionTitle_Label.BackgroundTransparency = 1
            SectionTitle_Label.Position = UDim2.new(0, 12, 0, 8)
            SectionTitle_Label.Size = UDim2.new(1, -24, 0, 20)
            SectionTitle_Label.Font = Enum.Font.GothamBold
            SectionTitle_Label.Text = SectionTitle
            SectionTitle_Label.TextColor3 = Color3.fromRGB(240, 240, 245)
            SectionTitle_Label.TextSize = 13
            SectionTitle_Label.TextXAlignment = Enum.TextXAlignment.Left

            SectionLine.Name = "Line"
            SectionLine.Parent = SectionHeader
            SectionLine.BackgroundColor3 = ConfigWindow.AccentColor
            SectionLine.BorderSizePixel = 0
            SectionLine.Position = UDim2.new(0, 12, 1, -1)
            SectionLine.Size = UDim2.new(1, -24, 0, 1)

            SectionLineGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, ConfigWindow.AccentColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }
            SectionLineGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            }
            SectionLineGradient.Parent = SectionLine

            SectionContent.Name = "Content"
            SectionContent.Parent = SectionFrame
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 35)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y

            SectionList.Parent = SectionContent
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 6)

            SectionPadding.Parent = SectionContent
            SectionPadding.PaddingTop = UDim.new(0, 8)
            SectionPadding.PaddingBottom = UDim.new(0, 8)
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)

            local CurrentGroup = SectionContent
            local SectionFunc = {}

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbtn or {})
                
                local ButtonFrame = Instance.new("Frame")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonStroke = Instance.new("UIStroke")
                local Button = Instance.new("TextButton")
                local ButtonTitle = Instance.new("TextLabel")
                local ButtonIcon = Instance.new("TextLabel")
                local ButtonGlow = Instance.new("Frame")

                ButtonFrame.Name = cfbtn.Title
                ButtonFrame.Parent = CurrentGroup
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                ButtonFrame.Size = UDim2.new(1, 0, 0, 36)

                ButtonCorner.CornerRadius = UDim.new(0, 7)
                ButtonCorner.Parent = ButtonFrame

                ButtonStroke.Color = Color3.fromRGB(40, 40, 48)
                ButtonStroke.Thickness = 1
                ButtonStroke.Transparency = 0.7
                ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ButtonStroke.Parent = ButtonFrame

                ButtonGlow.Name = "Glow"
                ButtonGlow.Parent = ButtonFrame
                ButtonGlow.BackgroundColor3 = ConfigWindow.AccentColor
                ButtonGlow.Position = UDim2.new(0, 0, 1, -2)
                ButtonGlow.Size = UDim2.new(1, 0, 0, 2)
                ButtonGlow.BorderSizePixel = 0
                ButtonGlow.BackgroundTransparency = 1

                local GlowCorner = Instance.new("UICorner")
                GlowCorner.CornerRadius = UDim.new(1, 0)
                GlowCorner.Parent = ButtonGlow

                Button.Name = "Button"
                Button.Parent = ButtonFrame
                Button.BackgroundTransparency = 1
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.Text = ""
                Button.AutoButtonColor = false

                ButtonTitle.Name = "Title"
                ButtonTitle.Parent = ButtonFrame
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Position = UDim2.new(0, 12, 0, 0)
                ButtonTitle.Size = UDim2.new(1, -45, 1, 0)
                ButtonTitle.Font = Enum.Font.GothamMedium
                ButtonTitle.Text = cfbtn.Title
                ButtonTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                ButtonTitle.TextSize = 12
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

                ButtonIcon.Name = "Icon"
                ButtonIcon.Parent = ButtonFrame
                ButtonIcon.BackgroundTransparency = 1
                ButtonIcon.Position = UDim2.new(1, -32, 0.5, -8)
                ButtonIcon.Size = UDim2.new(0, 16, 0, 16)
                ButtonIcon.Font = Enum.Font.GothamBold
                ButtonIcon.Text = "→"
                ButtonIcon.TextColor3 = ConfigWindow.AccentColor
                ButtonIcon.TextSize = 16

                Button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 38)}):Play()
                    game:GetService("TweenService"):Create(ButtonGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
                    game:GetService("TweenService"):Create(ButtonIcon, TweenInfo.new(0.2), {Position = UDim2.new(1, -28, 0.5, -8)}):Play()
                end)

                Button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
                    game:GetService("TweenService"):Create(ButtonGlow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    game:GetService("TweenService"):Create(ButtonIcon, TweenInfo.new(0.2), {Position = UDim2.new(1, -32, 0.5, -8)}):Play()
                end)

                Button.MouseButton1Click:Connect(function()
                    game:GetService("TweenService"):Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = ConfigWindow.AccentColor}):Play()
                    task.wait(0.1)
                    game:GetService("TweenService"):Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 38)}):Play()
                    pcall(cfbtn.Callback)
                end)
            end

            function SectionFunc:AddToggle(cftoggle)
                cftoggle = Library:MakeConfig({ Title = "Toggle", Description = "", Default = false, Callback = function() end }, cftoggle or {})
                
                local ToggleFrame = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleStroke = Instance.new("UIStroke")
                local ToggleButton = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local SwitchCircle = Instance.new("Frame")
                local CircleCorner = Instance.new("UICorner")

                ToggleFrame.Name = cftoggle.Title
                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 36)

                ToggleCorner.CornerRadius = UDim.new(0, 7)
                ToggleCorner.Parent = ToggleFrame

                ToggleStroke.Color = Color3.fromRGB(40, 40, 48)
                ToggleStroke.Thickness = 1
                ToggleStroke.Transparency = 0.7
                ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ToggleStroke.Parent = ToggleFrame

                ToggleButton.Name = "Button"
                ToggleButton.Parent = ToggleFrame
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false

                ToggleTitle.Name = "Title"
                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 12, 0, 0)
                ToggleTitle.Size = UDim2.new(1, -60, 1, 0)
                ToggleTitle.Font = Enum.Font.GothamMedium
                ToggleTitle.Text = cftoggle.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                ToggleTitle.TextSize = 12
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                ToggleSwitch.Name = "Switch"
                ToggleSwitch.Parent = ToggleFrame
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                ToggleSwitch.Position = UDim2.new(1, -46, 0.5, -10)
                ToggleSwitch.Size = UDim2.new(0, 38, 0, 20)

                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                SwitchCircle.Name = "Circle"
                SwitchCircle.Parent = ToggleSwitch
                SwitchCircle.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                SwitchCircle.Position = UDim2.new(0, 2, 0.5, -8)
                SwitchCircle.Size = UDim2.new(0, 16, 0, 16)

                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = SwitchCircle

                local Toggled = cftoggle.Default
                local function UpdateToggle()
                    if Toggled then
                        game:GetService("TweenService"):Create(ToggleSwitch, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = ConfigWindow.AccentColor}):Play()
                        game:GetService("TweenService"):Create(SwitchCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    else
                        game:GetService("TweenService"):Create(ToggleSwitch, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
                        game:GetService("TweenService"):Create(SwitchCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 180, 190)}):Play()
                    end
                    pcall(cftoggle.Callback, Toggled)
                end

                ToggleButton.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
                end)

                ToggleButton.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
                end)

                ToggleButton.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                end)

                UpdateToggle()
                return { Set = function(self, val) Toggled = val UpdateToggle() end }
            end

            function SectionFunc:AddSlider(cfslider)
                cfslider = Library:MakeConfig({ Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Callback = function() end }, cfslider or {})
                
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderStroke = Instance.new("UIStroke")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderCircle = Instance.new("Frame")
                local CircleCorner = Instance.new("UICorner")
                local SliderButton = Instance.new("TextButton")

                SliderFrame.Name = cfslider.Title
                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                SliderFrame.Size = UDim2.new(1, 0, 0, 48)

                SliderCorner.CornerRadius = UDim.new(0, 7)
                SliderCorner.Parent = SliderFrame

                SliderStroke.Color = Color3.fromRGB(40, 40, 48)
                SliderStroke.Thickness = 1
                SliderStroke.Transparency = 0.7
                SliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                SliderStroke.Parent = SliderFrame

                SliderTitle.Name = "Title"
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 12, 0, 8)
                SliderTitle.Size = UDim2.new(1, -70, 0, 16)
                SliderTitle.Font = Enum.Font.GothamMedium
                SliderTitle.Text = cfslider.Title
                SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                SliderTitle.TextSize = 12
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Name = "Value"
                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -58, 0, 8)
                SliderValue.Size = UDim2.new(0, 50, 0, 16)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(cfslider.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 12
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBar.Name = "Bar"
                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                SliderBar.Position = UDim2.new(0, 12, 1, -16)
                SliderBar.Size = UDim2.new(1, -24, 0, 6)

                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar

                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new(0, 0, 1, 0)

                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                SliderCircle.Name = "Circle"
                SliderCircle.Parent = SliderBar
                SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderCircle.Position = UDim2.new(0, 0, 0.5, 0)
                SliderCircle.Size = UDim2.new(0, 12, 0, 12)

                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = SliderCircle

                SliderButton.Name = "Button"
                SliderButton.Parent = SliderFrame
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Text = ""
                SliderButton.AutoButtonColor = false

                local Value = cfslider.Default
                local Dragging = false

                local function UpdateSlider(input)
                    local barSize = SliderBar.AbsoluteSize.X
                    local barPos = SliderBar.AbsolutePosition.X
                    local mousePos = input.Position.X
                    local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    
                    Value = cfslider.Min + (cfslider.Max - cfslider.Min) * percentage
                    Value = math.floor(Value / cfslider.Increment + 0.5) * cfslider.Increment
                    Value = math.clamp(Value, cfslider.Min, cfslider.Max)
                    
                    SliderValue.Text = tostring(Value)
                    game:GetService("TweenService"):Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
                    game:GetService("TweenService"):Create(SliderCircle, TweenInfo.new(0.1), {Position = UDim2.new(percentage, 0, 0.5, 0)}):Play()
                    
                    pcall(cfslider.Callback, Value)
                end

                SliderButton.MouseButton1Down:Connect(function()
                    Dragging = true
                    game:GetService("TweenService"):Create(SliderCircle, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16)}):Play()
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                        game:GetService("TweenService"):Create(SliderCircle, TweenInfo.new(0.15), {Size = UDim2.new(0, 12, 0, 12)}):Play()
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)

                SliderButton.MouseButton1Click:Connect(function(x, y)
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    UpdateSlider({Position = Vector2.new(mousePos.X, mousePos.Y)})
                end)

                -- Set initial value
                local initialPercentage = (cfslider.Default - cfslider.Min) / (cfslider.Max - cfslider.Min)
                SliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
                SliderCircle.Position = UDim2.new(initialPercentage, 0, 0.5, 0)
                pcall(cfslider.Callback, cfslider.Default)

                return { Set = function(self, val) Value = val local perc = (val - cfslider.Min) / (cfslider.Max - cfslider.Min) SliderValue.Text = tostring(val) SliderFill.Size = UDim2.new(perc, 0, 1, 0) SliderCircle.Position = UDim2.new(perc, 0, 0.5, 0) pcall(cfslider.Callback, val) end }
            end

            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({ Title = "Dropdown", Description = "", Options = {}, Values = {}, Default = "", Callback = function() end }, cfdrop or {})
                local options = #cfdrop.Options > 0 and cfdrop.Options or cfdrop.Values
                
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropStroke = Instance.new("UIStroke")
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("TextLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                DropFrame.Size = UDim2.new(1, 0, 0, 36)
                DropFrame.ClipsDescendants = true

                DropCorner.CornerRadius = UDim.new(0, 7)
                DropCorner.Parent = DropFrame

                DropStroke.Color = Color3.fromRGB(40, 40, 48)
                DropStroke.Thickness = 1
                DropStroke.Transparency = 0.7
                DropStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                DropStroke.Parent = DropFrame

                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 36)
                DropBtn.Text = ""

                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 12, 0, 0)
                DropTitle.Size = UDim2.new(1, -36, 0, 36)
                DropTitle.Font = Enum.Font.GothamMedium
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                DropTitle.TextSize = 12
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left

                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -32, 0, 0)
                DropIcon.Size = UDim2.new(0, 32, 0, 36)
                DropIcon.Font = Enum.Font.GothamBold
                DropIcon.Text = "▼"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 12

                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 36)
                DropList.Size = UDim2.new(1, 0, 0, 0)

                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 4)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder

                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 6)
                DropPadding.PaddingLeft = UDim.new(0, 6)
                DropPadding.PaddingRight = UDim.new(0, 6)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 42) or 36
                    Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize))
                    game:GetService("TweenService"):Create(DropIcon, TweenInfo.new(0.3), {Rotation = Open and 180 or 0}):Play()
                end

                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                DropBtn.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
                end)

                DropBtn.MouseLeave:Connect(function()
                    if not Open then
                        game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
                    end
                end)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
                        OptBtn.Size = UDim2.new(1, 0, 0, 28)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
                        OptBtn.TextSize = 11
                        OptBtn.AutoButtonColor = false
                        
                        OptCorner.CornerRadius = UDim.new(0, 5)
                        OptCorner.Parent = OptBtn

                        OptBtn.MouseEnter:Connect(function()
                            game:GetService("TweenService"):Create(OptBtn, TweenInfo.new(0.15), {BackgroundColor3 = ConfigWindow.AccentColor}):Play()
                            game:GetService("TweenService"):Create(OptBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        end)

                        OptBtn.MouseLeave:Connect(function()
                            game:GetService("TweenService"):Create(OptBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 38)}):Play()
                            game:GetService("TweenService"):Create(OptBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(200, 200, 210)}):Play()
                        end)

                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. " : " .. opt
                            ToggleDrop()
                            pcall(cfdrop.Callback, opt)
                        end)
                    end
                end

                AddOptions(options)
                if cfdrop.Default ~= "" then pcall(cfdrop.Callback, cfdrop.Default) end
                
                return {
                    Refresh = function(self, newopts)
                        for _, v in pairs(DropList:GetChildren()) do
                            if v:IsA("TextButton") then v:Destroy() end
                        end
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
                local BoxStroke = Instance.new("UIStroke")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                local InputStroke = Instance.new("UIStroke")

                BoxFrame.Parent = CurrentGroup
                BoxFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                BoxFrame.Size = UDim2.new(1, 0, 0, 36)

                BoxCorner.CornerRadius = UDim.new(0, 7)
                BoxCorner.Parent = BoxFrame

                BoxStroke.Color = Color3.fromRGB(40, 40, 48)
                BoxStroke.Thickness = 1
                BoxStroke.Transparency = 0.7
                BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                BoxStroke.Parent = BoxFrame

                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 12, 0, 0)
                BoxTitle.Size = UDim2.new(0, 100, 1, 0)
                BoxTitle.Font = Enum.Font.GothamMedium
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                BoxTitle.TextSize = 12
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
                BoxInput.Position = UDim2.new(1, -138, 0.5, -12)
                BoxInput.Size = UDim2.new(0, 130, 0, 24)
                BoxInput.Font = Enum.Font.Gotham
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                BoxInput.TextSize = 11
                BoxInput.PlaceholderText = "Enter text..."
                BoxInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)

                InputCorner.CornerRadius = UDim.new(0, 5)
                InputCorner.Parent = BoxInput

                InputStroke.Color = Color3.fromRGB(45, 45, 52)
                InputStroke.Thickness = 1
                InputStroke.Transparency = 0.5
                InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                InputStroke.Parent = BoxInput

                BoxInput.Focused:Connect(function()
                    game:GetService("TweenService"):Create(InputStroke, TweenInfo.new(0.2), {Color = ConfigWindow.AccentColor, Transparency = 0}):Play()
                end)

                BoxInput.FocusLost:Connect(function()
                    game:GetService("TweenService"):Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 52), Transparency = 0.5}):Play()
                    pcall(cfbox.Callback, BoxInput.Text)
                end)

                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 22)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(160, 160, 170)
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaStroke = Instance.new("UIStroke")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")

                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                ParaFrame.Size = UDim2.new(1, 0, 0, 46)

                ParaCorner.CornerRadius = UDim.new(0, 7)
                ParaCorner.Parent = ParaFrame

                ParaStroke.Color = Color3.fromRGB(40, 40, 48)
                ParaStroke.Thickness = 1
                ParaStroke.Transparency = 0.7
                ParaStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ParaStroke.Parent = ParaFrame

                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 10, 0, 8)
                ParaTitle.Size = UDim2.new(1, -20, 0, 14)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title
                ParaTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
                ParaTitle.TextSize = 12
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 10, 0, 24)
                ParaContent.Size = UDim2.new(1, -20, 0, 16)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(140, 140, 150)
                ParaContent.TextSize = 10
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true

                local function UpdateSize()
                    local textHeight = ParaContent.TextBounds.Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 32)
                    ParaContent.Size = UDim2.new(1, -20, 0, textHeight)
                end

                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                UpdateSize()

                return {
                    SetTitle = function(self, val) ParaTitle.Text = val end,
                    SetDesc = function(self, val) ParaContent.Text = val end,
                    Set = function(self, val) ParaContent.Text = val end
                }
            end

            function SectionFunc:AddDiscord(DiscordTitle, InviteCode)
                local DiscordCard = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local Icon = Instance.new("ImageLabel")
                local IconGlow = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")

                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                DiscordCard.Size = UDim2.new(1, 0, 0, 64)

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = DiscordCard

                UIStroke.Color = Color3.fromRGB(40, 40, 48)
                UIStroke.Thickness = 1
                UIStroke.Transparency = 0.7
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Parent = DiscordCard

                IconGlow.Parent = DiscordCard
                IconGlow.BackgroundTransparency = 1
                IconGlow.Position = UDim2.new(0, 10, 0.5, -20)
                IconGlow.Size = UDim2.new(0, 40, 0, 40)
                IconGlow.Image = "rbxassetid://123256573634"
                IconGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
                IconGlow.ImageTransparency = 0.7

                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 10, 0.5, -20)
                Icon.Size = UDim2.new(0, 40, 0, 40)
                Icon.Image = "rbxassetid://123256573634"

                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 58, 0, 14)
                Title.Size = UDim2.new(1, -126, 0, 18)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(245, 245, 250)
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 58, 0, 32)
                SubTitle.Size = UDim2.new(1, -126, 0, 18)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Click to join our community"
                SubTitle.TextColor3 = Color3.fromRGB(140, 140, 150)
                SubTitle.TextSize = 10
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = ConfigWindow.AccentColor
                JoinBtn.Position = UDim2.new(1, -70, 0.5, -14)
                JoinBtn.Size = UDim2.new(0, 60, 0, 28)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "Join"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 12
                JoinBtn.AutoButtonColor = false

                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = JoinBtn

                JoinBtn.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(JoinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(ConfigWindow.AccentColor.R * 1.2, ConfigWindow.AccentColor.G * 1.2, ConfigWindow.AccentColor.B * 1.2)}):Play()
                end)

                JoinBtn.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(JoinBtn, TweenInfo.new(0.2), {BackgroundColor3 = ConfigWindow.AccentColor}):Play()
                end)

                JoinBtn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                    JoinBtn.Text = "Copied!"
                    task.wait(2)
                    JoinBtn.Text = "Join"
                end)
            end

            return SectionFunc
        end

        return TabFunc
    end

    -- Toggle Button
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    local BtnGlow = Instance.new("ImageLabel")

    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    BtnGlow.Name = "Glow"
    BtnGlow.Parent = ToggleBtn
    BtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnGlow.BackgroundTransparency = 1
    BtnGlow.Position = UDim2.new(0, 42, 0, 42)
    BtnGlow.Size = UDim2.new(0, 50, 0, 50)
    BtnGlow.Image = "rbxassetid://101817370702077"
    BtnGlow.ImageColor3 = ConfigWindow.AccentColor
    BtnGlow.ImageTransparency = 0.5

    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 18, 0, 18)
    MainBtn.Size = UDim2.new(0, 48, 0, 48)
    MainBtn.Image = "rbxassetid://101817370702077"

    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn

    BtnStroke.Color = Color3.fromRGB(20, 20, 24)
    BtnStroke.Thickness = 2.5
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BtnStroke.Parent = MainBtn

    MainBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(MainBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 16, 0, 16)}):Play()
        game:GetService("TweenService"):Create(BtnGlow, TweenInfo.new(0.2), {ImageTransparency = 0.3}):Play()
    end)

    MainBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(MainBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 48, 0, 48), Position = UDim2.new(0, 18, 0, 18)}):Play()
        game:GetService("TweenService"):Create(BtnGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
    end)

    self:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
    end)

    return Tab
end

return Library
