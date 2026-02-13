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
        game:GetService("TweenService"):Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Linear), { Position = pos }):Play()
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

-- [ Premium Visual Effects ] --
function Library:CreateGradient(parent, colors, rotation)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new(colors)
    Gradient.Rotation = rotation or 45
    Gradient.Parent = parent
    return Gradient
end

function Library:CreateGlow(parent, color, size)
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.Size = UDim2.new(1, size or 30, 1, size or 30)
    Glow.Image = "rbxassetid://6015897843"
    Glow.ImageColor3 = color
    Glow.ImageTransparency = 0.6
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(49, 49, 450, 450)
    Glow.ZIndex = 0
    Glow.Parent = parent
    return Glow
end

function Library:CreatePattern(parent)
    local Pattern = Instance.new("ImageLabel")
    Pattern.Name = "Pattern"
    Pattern.BackgroundTransparency = 1
    Pattern.Size = UDim2.new(1, 0, 1, 0)
    Pattern.Image = "rbxassetid://5553946656"
    Pattern.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Pattern.ImageTransparency = 0.96
    Pattern.ScaleType = Enum.ScaleType.Tile
    Pattern.TileSize = UDim2.new(0, 100, 0, 100)
    Pattern.ZIndex = 1
    Pattern.Parent = parent
    return Pattern
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
    
    -- Premium Background Effects
    local BackgroundGradient = Instance.new("Frame")
    local BGGradient = Instance.new("UIGradient")
    local BGCorner = Instance.new("UICorner")
    
    local Top = Instance.new("Frame")
    local TopGradient = Instance.new("UIGradient")
    local TopStroke = Instance.new("UIStroke")
    local NameHub = Instance.new("TextLabel")
    local NameStroke = Instance.new("UIStroke")
    local LogoHub = Instance.new("ImageLabel")
    local LogoGlow = Instance.new("ImageLabel")
    local Desc = Instance.new("TextLabel")
    local PremiumBadge = Instance.new("Frame")
    local BadgeCorner = Instance.new("UICorner")
    local BadgeLabel = Instance.new("TextLabel")
    local BadgeGradient = Instance.new("UIGradient")
    
    local RightButtons = Instance.new("Frame")
    local UIListLayout_Buttons = Instance.new("UIListLayout")
    local Close = Instance.new("TextButton")
    local CloseCorner = Instance.new("UICorner")
    local CloseStroke = Instance.new("UIStroke")
    local Minize = Instance.new("TextButton")
    local MinizeCorner = Instance.new("UICorner")
    local MinizeStroke = Instance.new("UIStroke")
    
    local TabHolder = Instance.new("ScrollingFrame")
    local TabHolderStroke = Instance.new("UIStroke")
    local TabHolderCorner = Instance.new("UICorner")
    local TabListLayout = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    
    local ContentFrame = Instance.new("Frame")
    local ContentStroke = Instance.new("UIStroke")
    local ContentCorner = Instance.new("UICorner")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")
    
    -- Decorative Elements
    local TopAccent = Instance.new("Frame")
    local AccentGradient = Instance.new("UIGradient")
    local AccentCorner = Instance.new("UICorner")

    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 520, 0, 380)

    -- Enhanced Drop Shadow with Color
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 60, 1, 60)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = ConfigWindow.AccentColor
    DropShadow.ImageTransparency = 0.7
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.ZIndex = 0

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    -- Premium Border with Gradient
    UIStroke.Color = ConfigWindow.AccentColor
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.4
    UIStroke.Parent = Main
    
    -- Background Gradient Effect
    BackgroundGradient.Name = "BackgroundGradient"
    BackgroundGradient.Parent = Main
    BackgroundGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BackgroundGradient.Size = UDim2.new(1, 0, 1, 0)
    BackgroundGradient.ZIndex = 1
    BackgroundGradient.BackgroundTransparency = 0.97
    
    BGCorner.CornerRadius = UDim.new(0, 12)
    BGCorner.Parent = BackgroundGradient
    
    BGGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10))
    }
    BGGradient.Rotation = 135
    BGGradient.Parent = BackgroundGradient
    
    -- Pattern Overlay
    self:CreatePattern(Main)

    -- Top Bar with Premium Styling
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Top.Size = UDim2.new(1, 0, 0, 70)
    Top.ZIndex = 2
    
    TopGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 15))
    }
    TopGradient.Rotation = 90
    TopGradient.Parent = Top
    
    TopStroke.Color = ConfigWindow.AccentColor
    TopStroke.Thickness = 1
    TopStroke.Transparency = 0.7
    TopStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TopStroke.Parent = Top
    
    -- Top Accent Line
    TopAccent.Name = "TopAccent"
    TopAccent.Parent = Top
    TopAccent.BackgroundColor3 = ConfigWindow.AccentColor
    TopAccent.Position = UDim2.new(0, 0, 1, -3)
    TopAccent.Size = UDim2.new(1, 0, 0, 3)
    TopAccent.BorderSizePixel = 0
    TopAccent.ZIndex = 3
    
    AccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    AccentGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    AccentGradient.Parent = TopAccent
    
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = TopAccent

    -- Logo with Glow Effect
    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 15, 0, 12)
    LogoHub.Size = UDim2.new(0, 45, 0, 45)
    LogoHub.Image = "rbxassetid://101817370702077"
    LogoHub.ImageColor3 = ConfigWindow.AccentColor
    LogoHub.ZIndex = 3
    
    -- Logo Glow
    LogoGlow.Name = "LogoGlow"
    LogoGlow.Parent = LogoHub
    LogoGlow.BackgroundTransparency = 1
    LogoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoGlow.Size = UDim2.new(1, 20, 1, 20)
    LogoGlow.Image = "rbxassetid://6015897843"
    LogoGlow.ImageColor3 = ConfigWindow.AccentColor
    LogoGlow.ImageTransparency = 0.5
    LogoGlow.ScaleType = Enum.ScaleType.Slice
    LogoGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    LogoGlow.ZIndex = 2

    -- Title with Stroke
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 70, 0, 12)
    NameHub.Size = UDim2.new(0, 200, 0, 24)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 18
    NameHub.TextXAlignment = Enum.TextXAlignment.Left
    NameHub.ZIndex = 3
    
    NameStroke.Color = Color3.fromRGB(0, 0, 0)
    NameStroke.Thickness = 1.5
    NameStroke.Transparency = 0.6
    NameStroke.Parent = NameHub

    -- Premium Badge
    PremiumBadge.Name = "PremiumBadge"
    PremiumBadge.Parent = Top
    PremiumBadge.BackgroundColor3 = ConfigWindow.AccentColor
    PremiumBadge.Position = UDim2.new(0, 70, 0, 38)
    PremiumBadge.Size = UDim2.new(0, 65, 0, 18)
    PremiumBadge.ZIndex = 3
    
    BadgeCorner.CornerRadius = UDim.new(0, 4)
    BadgeCorner.Parent = PremiumBadge
    
    BadgeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.new(
            ConfigWindow.AccentColor.R * 0.7,
            ConfigWindow.AccentColor.G * 0.7,
            ConfigWindow.AccentColor.B * 0.7
        ))
    }
    BadgeGradient.Rotation = 45
    BadgeGradient.Parent = PremiumBadge
    
    BadgeLabel.Name = "BadgeLabel"
    BadgeLabel.Parent = PremiumBadge
    BadgeLabel.BackgroundTransparency = 1
    BadgeLabel.Size = UDim2.new(1, 0, 1, 0)
    BadgeLabel.Font = Enum.Font.GothamBold
    BadgeLabel.Text = "⭐ PREMIUM"
    BadgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BadgeLabel.TextSize = 10
    BadgeLabel.ZIndex = 4

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 145, 0, 38)
    Desc.Size = UDim2.new(0, 200, 0, 18)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 3

    -- Right Buttons with Premium Style
    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -95, 0, 20)
    RightButtons.Size = UDim2.new(0, 85, 0, 30)
    RightButtons.ZIndex = 3

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.Padding = UDim.new(0, 8)
    UIListLayout_Buttons.SortOrder = Enum.SortOrder.LayoutOrder

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Minize.Size = UDim2.new(0, 35, 0, 30)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "−"
    Minize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minize.TextSize = 18
    Minize.ZIndex = 4
    
    MinizeCorner.CornerRadius = UDim.new(0, 6)
    MinizeCorner.Parent = Minize
    
    MinizeStroke.Color = ConfigWindow.AccentColor
    MinizeStroke.Thickness = 1
    MinizeStroke.Transparency = 0.6
    MinizeStroke.Parent = Minize

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Close.LayoutOrder = 2
    Close.Size = UDim2.new(0, 35, 0, 30)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.TextSize = 20
    Close.ZIndex = 4
    
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    CloseStroke.Color = Color3.fromRGB(255, 80, 80)
    CloseStroke.Thickness = 1
    CloseStroke.Transparency = 0.6
    CloseStroke.Parent = Close

    -- Button Hover Effects
    local function CreateButtonEffect(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            self:TweenInstance(button, 0.2, "BackgroundColor3", hoverColor)
        end)
        button.MouseLeave:Connect(function()
            self:TweenInstance(button, 0.2, "BackgroundColor3", normalColor)
        end)
    end
    
    CreateButtonEffect(Minize, Color3.fromRGB(25, 25, 30), Color3.fromRGB(35, 35, 40))
    CreateButtonEffect(Close, Color3.fromRGB(25, 25, 30), Color3.fromRGB(255, 60, 60))

    -- Tab Holder with Premium Border
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.Active = true
    TabHolder.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 10, 0, 80)
    TabHolder.Size = UDim2.new(0, 130, 1, -90)
    TabHolder.ScrollBarThickness = 4
    TabHolder.ScrollBarImageColor3 = ConfigWindow.AccentColor
    TabHolder.ZIndex = 2
    
    TabHolderCorner.CornerRadius = UDim.new(0, 8)
    TabHolderCorner.Parent = TabHolder
    
    TabHolderStroke.Color = ConfigWindow.AccentColor
    TabHolderStroke.Thickness = 1
    TabHolderStroke.Transparency = 0.7
    TabHolderStroke.Parent = TabHolder

    TabListLayout.Parent = TabHolder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabPadding.Parent = TabHolder
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingRight = UDim.new(0, 5)
    TabPadding.PaddingTop = UDim.new(0, 5)

    -- Content Frame with Premium Border
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    ContentFrame.Position = UDim2.new(0, 150, 0, 80)
    ContentFrame.Size = UDim2.new(1, -160, 1, -90)
    ContentFrame.ClipsDescendants = true
    ContentFrame.ZIndex = 2
    
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentFrame
    
    ContentStroke.Color = ConfigWindow.AccentColor
    ContentStroke.Thickness = 1
    ContentStroke.Transparency = 0.7
    ContentStroke.Parent = ContentFrame

    PageLayout.Parent = ContentFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.TweenTime = 0.3

    PageList.Parent = ContentFrame

    self:UpdateScrolling(TabHolder, TabListLayout)
    self:MakeDraggable(Top, Main)

    Close.MouseButton1Click:Connect(function()
        self:TweenInstance(Main, 0.3, "Size", UDim2.new(0, 0, 0, 0))
        task.wait(0.3)
        TeddyUI_Premium:Destroy()
    end)

    Minize.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = false
    end)

    local Tab = {}
    function Tab:NewTab(ConfigTab)
        ConfigTab = self:MakeConfig({ Title = "Tab", Icon = "" }, ConfigTab or {})
        
        local TabBtn = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabStroke = Instance.new("UIStroke")
        local TabGradient = Instance.new("UIGradient")
        local TabIcon = Instance.new("ImageLabel")
        local TabIconGlow = Instance.new("ImageLabel")
        local TabLabel = Instance.new("TextLabel")
        local TabIndicator = Instance.new("Frame")
        local IndicatorCorner = Instance.new("UICorner")
        local IndicatorGradient = Instance.new("UIGradient")
        
        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        -- Premium Tab Button
        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabHolder
        TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = ""
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextSize = 13
        TabBtn.ZIndex = 3
        
        TabCorner.CornerRadius = UDim.new(0, 7)
        TabCorner.Parent = TabBtn
        
        TabStroke.Color = Color3.fromRGB(40, 40, 45)
        TabStroke.Thickness = 1
        TabStroke.Transparency = 0.5
        TabStroke.Parent = TabBtn
        
        TabGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 20))
        }
        TabGradient.Rotation = 90
        TabGradient.Parent = TabBtn
        
        -- Tab Icon with Glow
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 8, 0.5, -12)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Image = ConfigTab.Icon ~= "" and ConfigTab.Icon or "rbxassetid://10723434711"
        TabIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        TabIcon.ZIndex = 4
        
        TabIconGlow.Name = "Glow"
        TabIconGlow.Parent = TabIcon
        TabIconGlow.BackgroundTransparency = 1
        TabIconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        TabIconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        TabIconGlow.Size = UDim2.new(1, 10, 1, 10)
        TabIconGlow.Image = "rbxassetid://6015897843"
        TabIconGlow.ImageColor3 = ConfigWindow.AccentColor
        TabIconGlow.ImageTransparency = 1
        TabIconGlow.ScaleType = Enum.ScaleType.Slice
        TabIconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
        TabIconGlow.ZIndex = 3
        
        TabLabel.Name = "TabLabel"
        TabLabel.Parent = TabBtn
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 38, 0, 0)
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.Text = ConfigTab.Title
        TabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.ZIndex = 4
        
        -- Active Indicator
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabBtn
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.Position = UDim2.new(0, 0, 0.5, -10)
        TabIndicator.Size = UDim2.new(0, 0, 0, 20)
        TabIndicator.BorderSizePixel = 0
        TabIndicator.ZIndex = 5
        
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = TabIndicator
        
        IndicatorGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
            ColorSequenceKeypoint.new(1, Color3.new(
                ConfigWindow.AccentColor.R * 1.2,
                ConfigWindow.AccentColor.G * 1.2,
                ConfigWindow.AccentColor.B * 1.2
            ))
        }
        IndicatorGradient.Rotation = 90
        IndicatorGradient.Parent = TabIndicator

        -- Page Setup
        Page.Name = ConfigTab.Title
        Page.Parent = ContentFrame
        Page.Active = true
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = ConfigWindow.AccentColor
        Page.ZIndex = 3

        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PagePadding.Parent = Page
        PagePadding.PaddingBottom = UDim.new(0, 8)
        PagePadding.PaddingLeft = UDim.new(0, 8)
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.PaddingTop = UDim.new(0, 8)

        Library:UpdateScrolling(Page, PageList)

        -- Tab Selection Logic
        local function SelectTab()
            for _, tab in pairs(TabHolder:GetChildren()) do
                if tab:IsA("TextButton") then
                    Library:TweenInstance(tab, 0.2, "BackgroundColor3", Color3.fromRGB(18, 18, 22))
                    local icon = tab:FindFirstChild("TabIcon")
                    if icon then
                        Library:TweenInstance(icon, 0.2, "ImageColor3", Color3.fromRGB(180, 180, 180))
                        local glow = icon:FindFirstChild("Glow")
                        if glow then Library:TweenInstance(glow, 0.2, "ImageTransparency", 1) end
                    end
                    local label = tab:FindFirstChild("TabLabel")
                    if label then Library:TweenInstance(label, 0.2, "TextColor3", Color3.fromRGB(180, 180, 180)) end
                    local indicator = tab:FindFirstChild("Indicator")
                    if indicator then Library:TweenInstance(indicator, 0.2, "Size", UDim2.new(0, 0, 0, 20)) end
                    local stroke = tab:FindFirstChild("UIStroke")
                    if stroke then Library:TweenInstance(stroke, 0.2, "Transparency", 0.5) end
                end
            end
            
            Library:TweenInstance(TabBtn, 0.2, "BackgroundColor3", Color3.fromRGB(25, 25, 30))
            Library:TweenInstance(TabIcon, 0.2, "ImageColor3", ConfigWindow.AccentColor)
            Library:TweenInstance(TabIconGlow, 0.2, "ImageTransparency", 0.6)
            Library:TweenInstance(TabLabel, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
            Library:TweenInstance(TabIndicator, 0.2, "Size", UDim2.new(0, 3, 0, 20))
            Library:TweenInstance(TabStroke, 0.2, "Transparency", 0.2)
            PageLayout:JumpTo(Page)
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)
        
        -- Hover Effects
        TabBtn.MouseEnter:Connect(function()
            if PageLayout.CurrentPage ~= Page then
                Library:TweenInstance(TabBtn, 0.2, "BackgroundColor3", Color3.fromRGB(22, 22, 26))
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if PageLayout.CurrentPage ~= Page then
                Library:TweenInstance(TabBtn, 0.2, "BackgroundColor3", Color3.fromRGB(18, 18, 22))
            end
        end)

        if #TabHolder:GetChildren() == 2 then SelectTab() end

        local TabFunc = {}
        function TabFunc:NewSection(ConfigSection)
            ConfigSection = Library:MakeConfig({ Title = "Section" }, ConfigSection or {})
            
            local SectionFrame = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionGradient = Instance.new("UIGradient")
            local SectionHeader = Instance.new("Frame")
            local HeaderGradient = Instance.new("UIGradient")
            local SectionTitle = Instance.new("TextLabel")
            local TitleStroke = Instance.new("UIStroke")
            local SectionAccent = Instance.new("Frame")
            local AccentGrad = Instance.new("UIGradient")
            local ContentList = Instance.new("UIListLayout")
            local ContentPadding = Instance.new("UIPadding")
            
            -- Premium Section Frame
            SectionFrame.Name = "Section"
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.ZIndex = 3
            
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            SectionStroke.Color = ConfigWindow.AccentColor
            SectionStroke.Thickness = 1
            SectionStroke.Transparency = 0.8
            SectionStroke.Parent = SectionFrame
            
            SectionGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 18))
            }
            SectionGradient.Rotation = 90
            SectionGradient.Parent = SectionFrame
            
            -- Section Header
            SectionHeader.Name = "Header"
            SectionHeader.Parent = SectionFrame
            SectionHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            SectionHeader.Size = UDim2.new(1, 0, 0, 35)
            SectionHeader.BorderSizePixel = 0
            SectionHeader.ZIndex = 4
            
            HeaderGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 26)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22))
            }
            HeaderGradient.Rotation = 90
            HeaderGradient.Parent = SectionHeader
            
            SectionTitle.Name = "Title"
            SectionTitle.Parent = SectionHeader
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Size = UDim2.new(1, -30, 1, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = "  " .. ConfigSection.Title
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.ZIndex = 5
            
            TitleStroke.Color = ConfigWindow.AccentColor
            TitleStroke.Thickness = 1.2
            TitleStroke.Transparency = 0.7
            TitleStroke.Parent = SectionTitle
            
            -- Accent Line
            SectionAccent.Name = "Accent"
            SectionAccent.Parent = SectionHeader
            SectionAccent.BackgroundColor3 = ConfigWindow.AccentColor
            SectionAccent.Position = UDim2.new(0, 0, 1, -2)
            SectionAccent.Size = UDim2.new(1, 0, 0, 2)
            SectionAccent.BorderSizePixel = 0
            SectionAccent.ZIndex = 5
            
            AccentGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, ConfigWindow.AccentColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }
            AccentGrad.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            }
            AccentGrad.Parent = SectionAccent
            
            ContentList.Parent = SectionFrame
            ContentList.Padding = UDim.new(0, 6)
            ContentList.SortOrder = Enum.SortOrder.LayoutOrder
            
            ContentPadding.Parent = SectionFrame
            ContentPadding.PaddingBottom = UDim.new(0, 8)
            ContentPadding.PaddingLeft = UDim.new(0, 8)
            ContentPadding.PaddingRight = UDim.new(0, 8)
            ContentPadding.PaddingTop = UDim.new(0, 43)

            local CurrentGroup = SectionFrame
            local SectionFunc = {}

            function SectionFunc:AddButton(cfbutton)
                cfbutton = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbutton or {})
                
                local BtnFrame = Instance.new("Frame")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnGradient = Instance.new("UIGradient")
                local BtnClick = Instance.new("TextButton")
                local BtnTitle = Instance.new("TextLabel")
                local BtnIcon = Instance.new("TextLabel")
                local BtnGlow = Instance.new("ImageLabel")
                
                BtnFrame.Parent = CurrentGroup
                BtnFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                BtnFrame.Size = UDim2.new(1, 0, 0, 40)
                BtnFrame.ZIndex = 4
                
                BtnCorner.CornerRadius = UDim.new(0, 7)
                BtnCorner.Parent = BtnFrame
                
                BtnStroke.Color = Color3.fromRGB(40, 40, 45)
                BtnStroke.Thickness = 1
                BtnStroke.Transparency = 0.6
                BtnStroke.Parent = BtnFrame
                
                BtnGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                BtnGradient.Rotation = 90
                BtnGradient.Parent = BtnFrame
                
                -- Glow Effect
                BtnGlow.Name = "Glow"
                BtnGlow.Parent = BtnFrame
                BtnGlow.BackgroundTransparency = 1
                BtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                BtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                BtnGlow.Size = UDim2.new(1, 20, 1, 20)
                BtnGlow.Image = "rbxassetid://6015897843"
                BtnGlow.ImageColor3 = ConfigWindow.AccentColor
                BtnGlow.ImageTransparency = 1
                BtnGlow.ScaleType = Enum.ScaleType.Slice
                BtnGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                BtnGlow.ZIndex = 3
                
                BtnClick.Parent = BtnFrame
                BtnClick.BackgroundTransparency = 1
                BtnClick.Size = UDim2.new(1, 0, 1, 0)
                BtnClick.Text = ""
                BtnClick.ZIndex = 5
                
                BtnTitle.Parent = BtnFrame
                BtnTitle.BackgroundTransparency = 1
                BtnTitle.Position = UDim2.new(0, 15, 0, 0)
                BtnTitle.Size = UDim2.new(1, -50, 1, 0)
                BtnTitle.Font = Enum.Font.GothamBold
                BtnTitle.Text = cfbutton.Title
                BtnTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BtnTitle.TextSize = 13
                BtnTitle.TextXAlignment = Enum.TextXAlignment.Left
                BtnTitle.ZIndex = 5
                
                BtnIcon.Parent = BtnFrame
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(1, -35, 0, 0)
                BtnIcon.Size = UDim2.new(0, 35, 1, 0)
                BtnIcon.Font = Enum.Font.GothamBold
                BtnIcon.Text = "▶"
                BtnIcon.TextColor3 = ConfigWindow.AccentColor
                BtnIcon.TextSize = 14
                BtnIcon.ZIndex = 5
                
                -- Hover Effects
                BtnClick.MouseEnter:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(28, 28, 32))
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.3)
                    Library:TweenInstance(BtnGlow, 0.2, "ImageTransparency", 0.85)
                end)
                
                BtnClick.MouseLeave:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(22, 22, 26))
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.6)
                    Library:TweenInstance(BtnGlow, 0.2, "ImageTransparency", 1)
                end)
                
                BtnClick.MouseButton1Click:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.1, "Size", UDim2.new(1, -4, 0, 38))
                    task.wait(0.1)
                    Library:TweenInstance(BtnFrame, 0.1, "Size", UDim2.new(1, 0, 0, 40))
                    pcall(cfbutton.Callback)
                end)
            end

            function SectionFunc:AddToggle(cftoggle)
                cftoggle = Library:MakeConfig({ Title = "Toggle", Description = "", Default = false, Callback = function() end }, cftoggle or {})
                local TogState = cftoggle.Default
                
                local TogFrame = Instance.new("Frame")
                local TogCorner = Instance.new("UICorner")
                local TogStroke = Instance.new("UIStroke")
                local TogGradient = Instance.new("UIGradient")
                local TogBtn = Instance.new("TextButton")
                local TogTitle = Instance.new("TextLabel")
                local ToggleBase = Instance.new("Frame")
                local BaseCorner = Instance.new("UICorner")
                local BaseStroke = Instance.new("UIStroke")
                local ToggleKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local KnobGradient = Instance.new("UIGradient")
                local KnobGlow = Instance.new("ImageLabel")
                
                TogFrame.Parent = CurrentGroup
                TogFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                TogFrame.Size = UDim2.new(1, 0, 0, 40)
                TogFrame.ZIndex = 4
                
                TogCorner.CornerRadius = UDim.new(0, 7)
                TogCorner.Parent = TogFrame
                
                TogStroke.Color = Color3.fromRGB(40, 40, 45)
                TogStroke.Thickness = 1
                TogStroke.Transparency = 0.6
                TogStroke.Parent = TogFrame
                
                TogGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                TogGradient.Rotation = 90
                TogGradient.Parent = TogFrame
                
                TogBtn.Parent = TogFrame
                TogBtn.BackgroundTransparency = 1
                TogBtn.Size = UDim2.new(1, 0, 1, 0)
                TogBtn.Text = ""
                TogBtn.ZIndex = 5
                
                TogTitle.Parent = TogFrame
                TogTitle.BackgroundTransparency = 1
                TogTitle.Position = UDim2.new(0, 15, 0, 0)
                TogTitle.Size = UDim2.new(1, -70, 1, 0)
                TogTitle.Font = Enum.Font.GothamBold
                TogTitle.Text = cftoggle.Title
                TogTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                TogTitle.TextSize = 13
                TogTitle.TextXAlignment = Enum.TextXAlignment.Left
                TogTitle.ZIndex = 5
                
                -- Premium Toggle Switch
                ToggleBase.Name = "Base"
                ToggleBase.Parent = TogFrame
                ToggleBase.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                ToggleBase.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleBase.Size = UDim2.new(0, 40, 0, 20)
                ToggleBase.ZIndex = 5
                
                BaseCorner.CornerRadius = UDim.new(1, 0)
                BaseCorner.Parent = ToggleBase
                
                BaseStroke.Color = Color3.fromRGB(50, 50, 55)
                BaseStroke.Thickness = 1.5
                BaseStroke.Transparency = 0.3
                BaseStroke.Parent = ToggleBase
                
                ToggleKnob.Name = "Knob"
                ToggleKnob.Parent = ToggleBase
                ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                ToggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
                ToggleKnob.ZIndex = 6
                
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = ToggleKnob
                
                KnobGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
                }
                KnobGradient.Rotation = 90
                KnobGradient.Parent = ToggleKnob
                
                -- Knob Glow
                KnobGlow.Name = "Glow"
                KnobGlow.Parent = ToggleKnob
                KnobGlow.BackgroundTransparency = 1
                KnobGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobGlow.Size = UDim2.new(1, 12, 1, 12)
                KnobGlow.Image = "rbxassetid://6015897843"
                KnobGlow.ImageColor3 = ConfigWindow.AccentColor
                KnobGlow.ImageTransparency = 1
                KnobGlow.ScaleType = Enum.ScaleType.Slice
                KnobGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                KnobGlow.ZIndex = 5
                
                local function UpdateToggle()
                    if TogState then
                        Library:TweenInstance(ToggleBase, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
                        Library:TweenInstance(ToggleKnob, 0.2, "Position", UDim2.new(1, -18, 0.5, -8))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.5)
                        Library:TweenInstance(BaseStroke, 0.2, "Color", ConfigWindow.AccentColor)
                        Library:TweenInstance(BaseStroke, 0.2, "Transparency", 0)
                    else
                        Library:TweenInstance(ToggleBase, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 35))
                        Library:TweenInstance(ToggleKnob, 0.2, "Position", UDim2.new(0, 2, 0.5, -8))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 1)
                        Library:TweenInstance(BaseStroke, 0.2, "Color", Color3.fromRGB(50, 50, 55))
                        Library:TweenInstance(BaseStroke, 0.2, "Transparency", 0.3)
                    end
                    pcall(cftoggle.Callback, TogState)
                end
                
                TogBtn.MouseButton1Click:Connect(function()
                    TogState = not TogState
                    UpdateToggle()
                end)
                
                UpdateToggle()
                return { Set = function(self, val) TogState = val UpdateToggle() end }
            end

            function SectionFunc:AddSlider(cfslider)
                cfslider = Library:MakeConfig({ Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Callback = function() end }, cfslider or {})
                local SliderVal = cfslider.Default
                
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderStroke = Instance.new("UIStroke")
                local SliderGradient = Instance.new("UIGradient")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBack = Instance.new("Frame")
                local BackCorner = Instance.new("UICorner")
                local BackStroke = Instance.new("UIStroke")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local FillGradient = Instance.new("UIGradient")
                local FillGlow = Instance.new("ImageLabel")
                local SliderBtn = Instance.new("TextButton")
                
                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                SliderFrame.Size = UDim2.new(1, 0, 0, 55)
                SliderFrame.ZIndex = 4
                
                SliderCorner.CornerRadius = UDim.new(0, 7)
                SliderCorner.Parent = SliderFrame
                
                SliderStroke.Color = Color3.fromRGB(40, 40, 45)
                SliderStroke.Thickness = 1
                SliderStroke.Transparency = 0.6
                SliderStroke.Parent = SliderFrame
                
                SliderGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                SliderGradient.Rotation = 90
                SliderGradient.Parent = SliderFrame
                
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 15, 0, 8)
                SliderTitle.Size = UDim2.new(1, -80, 0, 18)
                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = cfslider.Title
                SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.ZIndex = 5
                
                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -65, 0, 8)
                SliderValue.Size = UDim2.new(0, 50, 0, 18)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(SliderVal)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 13
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.ZIndex = 5
                
                -- Slider Track
                SliderBack.Name = "Track"
                SliderBack.Parent = SliderFrame
                SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                SliderBack.Position = UDim2.new(0, 15, 1, -22)
                SliderBack.Size = UDim2.new(1, -30, 0, 8)
                SliderBack.ZIndex = 5
                
                BackCorner.CornerRadius = UDim.new(1, 0)
                BackCorner.Parent = SliderBack
                
                BackStroke.Color = Color3.fromRGB(50, 50, 55)
                BackStroke.Thickness = 1
                BackStroke.Transparency = 0.5
                BackStroke.Parent = SliderBack
                
                -- Slider Fill
                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBack
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BorderSizePixel = 0
                SliderFill.ZIndex = 6
                
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                FillGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
                    ColorSequenceKeypoint.new(1, Color3.new(
                        ConfigWindow.AccentColor.R * 0.8,
                        ConfigWindow.AccentColor.G * 0.8,
                        ConfigWindow.AccentColor.B * 0.8
                    ))
                }
                FillGradient.Parent = SliderFill
                
                -- Fill Glow
                FillGlow.Name = "Glow"
                FillGlow.Parent = SliderFill
                FillGlow.BackgroundTransparency = 1
                FillGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                FillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                FillGlow.Size = UDim2.new(1, 10, 3, 0)
                FillGlow.Image = "rbxassetid://6015897843"
                FillGlow.ImageColor3 = ConfigWindow.AccentColor
                FillGlow.ImageTransparency = 0.6
                FillGlow.ScaleType = Enum.ScaleType.Slice
                FillGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                FillGlow.ZIndex = 5
                
                SliderBtn.Parent = SliderBack
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.Text = ""
                SliderBtn.ZIndex = 7
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    SliderVal = math.floor(cfslider.Min + (cfslider.Max - cfslider.Min) * pos)
                    SliderVal = math.floor(SliderVal / cfslider.Increment + 0.5) * cfslider.Increment
                    SliderVal = math.clamp(SliderVal, cfslider.Min, cfslider.Max)
                    Library:TweenInstance(SliderFill, 0.1, "Size", UDim2.new(pos, 0, 1, 0))
                    SliderValue.Text = tostring(SliderVal)
                    pcall(cfslider.Callback, SliderVal)
                end
                
                local dragging = false
                SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                SliderBtn.MouseButton1Click:Connect(function(input) UpdateSlider(input) end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
                end)
                
                local initPos = (cfslider.Default - cfslider.Min) / (cfslider.Max - cfslider.Min)
                SliderFill.Size = UDim2.new(initPos, 0, 1, 0)
                pcall(cfslider.Callback, cfslider.Default)
            end

            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({ Title = "Dropdown", Description = "", Options = {}, Values = {}, Default = "", Callback = function() end }, cfdrop or {})
                local options = #cfdrop.Options > 0 and cfdrop.Options or cfdrop.Values
                
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropStroke = Instance.new("UIStroke")
                local DropGradient = Instance.new("UIGradient")
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("TextLabel")
                local DropIconGlow = Instance.new("ImageLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                DropFrame.Size = UDim2.new(1, 0, 0, 40)
                DropFrame.ClipsDescendants = true
                DropFrame.ZIndex = 4
                
                DropCorner.CornerRadius = UDim.new(0, 7)
                DropCorner.Parent = DropFrame
                
                DropStroke.Color = Color3.fromRGB(40, 40, 45)
                DropStroke.Thickness = 1
                DropStroke.Transparency = 0.6
                DropStroke.Parent = DropFrame
                
                DropGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                DropGradient.Rotation = 90
                DropGradient.Parent = DropFrame
                
                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 40)
                DropBtn.Text = ""
                DropBtn.ZIndex = 5
                
                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 15, 0, 0)
                DropTitle.Size = UDim2.new(1, -50, 0, 40)
                DropTitle.Font = Enum.Font.GothamBold
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropTitle.TextSize = 13
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropTitle.ZIndex = 5
                
                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -35, 0, 0)
                DropIcon.Size = UDim2.new(0, 35, 0, 40)
                DropIcon.Font = Enum.Font.GothamBold
                DropIcon.Text = "▼"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 12
                DropIcon.ZIndex = 5
                
                -- Icon Glow
                DropIconGlow.Name = "Glow"
                DropIconGlow.Parent = DropIcon
                DropIconGlow.BackgroundTransparency = 1
                DropIconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                DropIconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                DropIconGlow.Size = UDim2.new(2, 0, 2, 0)
                DropIconGlow.Image = "rbxassetid://6015897843"
                DropIconGlow.ImageColor3 = ConfigWindow.AccentColor
                DropIconGlow.ImageTransparency = 0.8
                DropIconGlow.ScaleType = Enum.ScaleType.Slice
                DropIconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                DropIconGlow.ZIndex = 4
                
                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 40)
                DropList.Size = UDim2.new(1, 0, 0, 0)
                DropList.ZIndex = 5
                
                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 4)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 8)
                DropPadding.PaddingLeft = UDim.new(0, 8)
                DropPadding.PaddingRight = UDim.new(0, 8)
                DropPadding.PaddingTop = UDim.new(0, 4)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 52) or 40
                    Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize))
                    Library:TweenInstance(DropIcon, 0.3, "Rotation", Open and 180 or 0)
                    DropIcon.Text = Open and "▲" or "▼"
                end
                
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        local OptStroke = Instance.new("UIStroke")
                        local OptGradient = Instance.new("UIGradient")
                        local OptGlow = Instance.new("ImageLabel")
                        
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                        OptBtn.Size = UDim2.new(1, 0, 0, 32)
                        OptBtn.Font = Enum.Font.GothamBold
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptBtn.TextSize = 12
                        OptBtn.ZIndex = 6
                        
                        OptCorner.CornerRadius = UDim.new(0, 6)
                        OptCorner.Parent = OptBtn
                        
                        OptStroke.Color = Color3.fromRGB(45, 45, 50)
                        OptStroke.Thickness = 1
                        OptStroke.Transparency = 0.5
                        OptStroke.Parent = OptBtn
                        
                        OptGradient.Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 34)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 30))
                        }
                        OptGradient.Rotation = 90
                        OptGradient.Parent = OptBtn
                        
                        -- Option Glow
                        OptGlow.Name = "Glow"
                        OptGlow.Parent = OptBtn
                        OptGlow.BackgroundTransparency = 1
                        OptGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                        OptGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                        OptGlow.Size = UDim2.new(1, 10, 1, 10)
                        OptGlow.Image = "rbxassetid://6015897843"
                        OptGlow.ImageColor3 = ConfigWindow.AccentColor
                        OptGlow.ImageTransparency = 1
                        OptGlow.ScaleType = Enum.ScaleType.Slice
                        OptGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                        OptGlow.ZIndex = 5
                        
                        OptBtn.MouseEnter:Connect(function()
                            Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 40))
                            Library:TweenInstance(OptGlow, 0.2, "ImageTransparency", 0.85)
                        end)
                        
                        OptBtn.MouseLeave:Connect(function()
                            Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(28, 28, 32))
                            Library:TweenInstance(OptGlow, 0.2, "ImageTransparency", 1)
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
                local BoxGradient = Instance.new("UIGradient")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                local InputStroke = Instance.new("UIStroke")
                local InputGradient = Instance.new("UIGradient")
                
                BoxFrame.Parent = CurrentGroup
                BoxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                BoxFrame.Size = UDim2.new(1, 0, 0, 40)
                BoxFrame.ZIndex = 4
                
                BoxCorner.CornerRadius = UDim.new(0, 7)
                BoxCorner.Parent = BoxFrame
                
                BoxStroke.Color = Color3.fromRGB(40, 40, 45)
                BoxStroke.Thickness = 1
                BoxStroke.Transparency = 0.6
                BoxStroke.Parent = BoxFrame
                
                BoxGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                BoxGradient.Rotation = 90
                BoxGradient.Parent = BoxFrame
                
                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 15, 0, 0)
                BoxTitle.Size = UDim2.new(0, 120, 1, 0)
                BoxTitle.Font = Enum.Font.GothamBold
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BoxTitle.TextSize = 13
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left
                BoxTitle.ZIndex = 5
                
                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                BoxInput.Position = UDim2.new(1, -165, 0.5, -13)
                BoxInput.Size = UDim2.new(0, 150, 0, 26)
                BoxInput.Font = Enum.Font.Gotham
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                BoxInput.TextSize = 12
                BoxInput.PlaceholderText = "Enter text..."
                BoxInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                BoxInput.ZIndex = 5
                
                InputCorner.CornerRadius = UDim.new(0, 5)
                InputCorner.Parent = BoxInput
                
                InputStroke.Color = Color3.fromRGB(50, 50, 55)
                InputStroke.Thickness = 1
                InputStroke.Transparency = 0.4
                InputStroke.Parent = BoxInput
                
                InputGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 34)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 30))
                }
                InputGradient.Rotation = 90
                InputGradient.Parent = BoxInput
                
                BoxInput.Focused:Connect(function()
                    Library:TweenInstance(InputStroke, 0.2, "Color", ConfigWindow.AccentColor)
                    Library:TweenInstance(InputStroke, 0.2, "Transparency", 0)
                end)
                
                BoxInput.FocusLost:Connect(function()
                    Library:TweenInstance(InputStroke, 0.2, "Color", Color3.fromRGB(50, 50, 55))
                    Library:TweenInstance(InputStroke, 0.2, "Transparency", 0.4)
                    pcall(cfbox.Callback, BoxInput.Text)
                end)
                
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                local LabelStroke = Instance.new("UIStroke")
                
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 25)
                Label.Font = Enum.Font.Gotham
                Label.Text = "  " .. text
                Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 5
                
                LabelStroke.Color = ConfigWindow.AccentColor
                LabelStroke.Thickness = 0.5
                LabelStroke.Transparency = 0.9
                LabelStroke.Parent = Label
                
                return { Set = function(self, val) Label.Text = "  " .. val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaStroke = Instance.new("UIStroke")
                local ParaGradient = Instance.new("UIGradient")
                local ParaTitle = Instance.new("TextLabel")
                local TitleStroke = Instance.new("UIStroke")
                local ParaContent = Instance.new("TextLabel")
                local ParaAccent = Instance.new("Frame")
                
                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                ParaFrame.Size = UDim2.new(1, 0, 0, 50)
                ParaFrame.ZIndex = 4
                
                ParaCorner.CornerRadius = UDim.new(0, 7)
                ParaCorner.Parent = ParaFrame
                
                ParaStroke.Color = Color3.fromRGB(40, 40, 45)
                ParaStroke.Thickness = 1
                ParaStroke.Transparency = 0.6
                ParaStroke.Parent = ParaFrame
                
                ParaGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                ParaGradient.Rotation = 90
                ParaGradient.Parent = ParaFrame
                
                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 15, 0, 10)
                ParaTitle.Size = UDim2.new(1, -30, 0, 18)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title
                ParaTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParaTitle.TextSize = 14
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParaTitle.ZIndex = 5
                
                TitleStroke.Color = ConfigWindow.AccentColor
                TitleStroke.Thickness = 1
                TitleStroke.Transparency = 0.8
                TitleStroke.Parent = ParaTitle
                
                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 15, 0, 32)
                ParaContent.Size = UDim2.new(1, -30, 0, 18)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(160, 160, 160)
                ParaContent.TextSize = 11
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true
                ParaContent.ZIndex = 5
                
                -- Accent Line
                ParaAccent.Name = "Accent"
                ParaAccent.Parent = ParaFrame
                ParaAccent.BackgroundColor3 = ConfigWindow.AccentColor
                ParaAccent.Position = UDim2.new(0, 0, 0, 0)
                ParaAccent.Size = UDim2.new(0, 3, 1, 0)
                ParaAccent.BorderSizePixel = 0
                ParaAccent.ZIndex = 5
                
                local function UpdateSize()
                    local textHeight = ParaContent.TextBounds.Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 42)
                    ParaContent.Size = UDim2.new(1, -30, 0, textHeight)
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
                local CardCorner = Instance.new("UICorner")
                local CardStroke = Instance.new("UIStroke")
                local CardGradient = Instance.new("UIGradient")
                local Icon = Instance.new("ImageLabel")
                local IconGlow = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnGradient = Instance.new("UIGradient")
                local BtnStroke = Instance.new("UIStroke")
                
                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                DiscordCard.Size = UDim2.new(1, 0, 0, 75)
                DiscordCard.ZIndex = 4
                
                CardCorner.CornerRadius = UDim.new(0, 8)
                CardCorner.Parent = DiscordCard
                
                CardStroke.Color = ConfigWindow.AccentColor
                CardStroke.Thickness = 1.5
                CardStroke.Transparency = 0.5
                CardStroke.Parent = DiscordCard
                
                CardGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
                }
                CardGradient.Rotation = 90
                CardGradient.Parent = DiscordCard
                
                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 15, 0, 15)
                Icon.Size = UDim2.new(0, 45, 0, 45)
                Icon.Image = "rbxassetid://123256573634"
                Icon.ImageColor3 = Color3.fromRGB(114, 137, 218)
                Icon.ZIndex = 6
                
                -- Icon Glow
                IconGlow.Name = "Glow"
                IconGlow.Parent = Icon
                IconGlow.BackgroundTransparency = 1
                IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                IconGlow.Size = UDim2.new(1, 15, 1, 15)
                IconGlow.Image = "rbxassetid://6015897843"
                IconGlow.ImageColor3 = Color3.fromRGB(114, 137, 218)
                IconGlow.ImageTransparency = 0.6
                IconGlow.ScaleType = Enum.ScaleType.Slice
                IconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                IconGlow.ZIndex = 5
                
                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 70, 0, 18)
                Title.Size = UDim2.new(1, -160, 0, 20)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 15
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 5
                
                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 70, 0, 40)
                SubTitle.Size = UDim2.new(1, -160, 0, 18)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Join our community"
                SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
                SubTitle.TextSize = 11
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                SubTitle.ZIndex = 5
                
                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = ConfigWindow.AccentColor
                JoinBtn.Position = UDim2.new(1, -85, 0, 22)
                JoinBtn.Size = UDim2.new(0, 70, 0, 30)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "Join"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 13
                JoinBtn.ZIndex = 6
                
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = JoinBtn
                
                BtnGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
                    ColorSequenceKeypoint.new(1, Color3.new(
                        ConfigWindow.AccentColor.R * 0.8,
                        ConfigWindow.AccentColor.G * 0.8,
                        ConfigWindow.AccentColor.B * 0.8
                    ))
                }
                BtnGradient.Rotation = 45
                BtnGradient.Parent = JoinBtn
                
                BtnStroke.Color = Color3.fromRGB(255, 255, 255)
                BtnStroke.Thickness = 1
                BtnStroke.Transparency = 0.8
                BtnStroke.Parent = JoinBtn
                
                JoinBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "Size", UDim2.new(0, 75, 0, 32))
                end)
                
                JoinBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "Size", UDim2.new(0, 70, 0, 30))
                end)
                
                JoinBtn.MouseButton1Click:Connect(function()
                    if setclipboard then setclipboard("https://discord.gg/" .. InviteCode) end
                    JoinBtn.Text = "Copied!"
                    task.wait(2)
                    JoinBtn.Text = "Join"
                end)
            end

            return SectionFunc
        end

        return TabFunc
    end

    -- Premium Toggle Button
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    local BtnGradient = Instance.new("UIGradient")
    local BtnGlow = Instance.new("ImageLabel")
    
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 20, 0, 20)
    MainBtn.Size = UDim2.new(0, 50, 0, 50)
    MainBtn.Image = "rbxassetid://101817370702077"
    MainBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = MainBtn
    
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.6
    BtnStroke.Parent = MainBtn
    
    BtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.new(
            ConfigWindow.AccentColor.R * 0.7,
            ConfigWindow.AccentColor.G * 0.7,
            ConfigWindow.AccentColor.B * 0.7
        ))
    }
    BtnGradient.Rotation = 45
    BtnGradient.Parent = MainBtn
    
    -- Button Glow
    BtnGlow.Name = "Glow"
    BtnGlow.Parent = MainBtn
    BtnGlow.BackgroundTransparency = 1
    BtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    BtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnGlow.Size = UDim2.new(1, 25, 1, 25)
    BtnGlow.Image = "rbxassetid://6015897843"
    BtnGlow.ImageColor3 = ConfigWindow.AccentColor
    BtnGlow.ImageTransparency = 0.4
    BtnGlow.ScaleType = Enum.ScaleType.Slice
    BtnGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    BtnGlow.ZIndex = 0
    
    self:MakeDraggable(MainBtn, MainBtn)
    
    MainBtn.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
    end)

    return Tab
end

return Library
