local Library = {}

-- [ Utility Functions ] --
function Library:TweenInstance(Instance, Time, OldValue, NewValue)
    local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { [OldValue] = NewValue })
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

-- [ Premium Visual Effects ] --
function Library:CreatePulsingBorder(parent, color)
    local PulsingBorder = Instance.new("UIStroke")
    PulsingBorder.Color = color
    PulsingBorder.Thickness = 2
    PulsingBorder.Transparency = 0.3
    PulsingBorder.Parent = parent
    
    -- Pulsing effect
    task.spawn(function()
        while PulsingBorder.Parent do
            game:GetService("TweenService"):Create(PulsingBorder, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Transparency = 0.6
            }):Play()
            task.wait(1.5)
        end
    end)
    
    return PulsingBorder
end

function Library:CreateNeonGlow(parent, color, size)
    local NeonGlow = Instance.new("ImageLabel")
    NeonGlow.Name = "NeonGlow"
    NeonGlow.Parent = parent
    NeonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    NeonGlow.BackgroundTransparency = 1
    NeonGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    NeonGlow.Size = size or UDim2.new(1.8, 0, 1.8, 0)
    NeonGlow.Image = "rbxassetid://6015897843"
    NeonGlow.ImageColor3 = color
    NeonGlow.ImageTransparency = 0.5
    NeonGlow.ScaleType = Enum.ScaleType.Slice
    NeonGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    NeonGlow.ZIndex = 0
    
    -- Pulsing glow
    task.spawn(function()
        while NeonGlow.Parent do
            game:GetService("TweenService"):Create(NeonGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                ImageTransparency = 0.75
            }):Play()
            task.wait(2)
        end
    end)
    
    return NeonGlow
end

function Library:CreateGlassmorphism(parent)
    local Glass = Instance.new("Frame")
    Glass.Name = "Glassmorphism"
    Glass.Parent = parent
    Glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Glass.BackgroundTransparency = 0.97
    Glass.Size = UDim2.new(1, 0, 1, 0)
    Glass.ZIndex = 1
    
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 10)
    GlassCorner.Parent = Glass
    
    local GlassStroke = Instance.new("UIStroke")
    GlassStroke.Color = Color3.fromRGB(255, 255, 255)
    GlassStroke.Thickness = 1
    GlassStroke.Transparency = 0.92
    GlassStroke.Parent = Glass
    
    return Glass
end

function Library:CreateBackgroundPattern(parent)
    local Pattern = Instance.new("Frame")
    Pattern.Name = "Pattern"
    Pattern.Parent = parent
    Pattern.BackgroundTransparency = 1
    Pattern.Size = UDim2.new(1, 0, 1, 0)
    Pattern.ZIndex = 0
    
    -- Grid pattern
    local UIList = Instance.new("UIGridLayout")
    UIList.CellPadding = UDim2.new(0, 25, 0, 25)
    UIList.CellSize = UDim2.new(0, 2, 0, 2)
    UIList.Parent = Pattern
    
    for i = 1, 100 do
        local Dot = Instance.new("Frame")
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dot.BackgroundTransparency = 0.96
        Dot.BorderSizePixel = 0
        Dot.Parent = Pattern
        
        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = Dot
    end
    
    return Pattern
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "SYNTRAX Hub",
        Description = "Premium Script",
        AccentColor = Color3.fromRGB(138, 43, 226)
    }, ConfigWindow or {})

    local TeddyUI_Premium = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")
    local DropShadow2 = Instance.new("ImageLabel")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local MainGradient = Instance.new("UIGradient")
    
    -- Enhanced glow effects
    local GlowEffect = Instance.new("ImageLabel")
    local GlowEffect2 = Instance.new("ImageLabel")
    local GlowEffect3 = Instance.new("ImageLabel")
    
    local Top = Instance.new("Frame")
    local TopGradient = Instance.new("UIGradient")
    local TopAccentLine = Instance.new("Frame")
    local TopAccentGradient = Instance.new("UIGradient")
    local NameHub = Instance.new("TextLabel")
    local LogoHub = Instance.new("ImageLabel")
    local LogoGlow = Instance.new("ImageLabel")
    local LogoFrame = Instance.new("Frame")
    local LogoFrameCorner = Instance.new("UICorner")
    local LogoFrameStroke = Instance.new("UIStroke")
    local Desc = Instance.new("TextLabel")
    
    local RightButtons = Instance.new("Frame")
    local UIListLayout_Buttons = Instance.new("UIListLayout")
    local Close = Instance.new("TextButton")
    local CloseCorner = Instance.new("UICorner")
    local CloseStroke = Instance.new("UIStroke")
    local CloseGlow = Instance.new("Frame")
    local Minize = Instance.new("TextButton")
    local MinizeCorner = Instance.new("UICorner")
    local MinizeStroke = Instance.new("UIStroke")
    local MinizeGlow = Instance.new("Frame")
    
    local TabHolder = Instance.new("ScrollingFrame")
    local TabListLayout = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    local TabHolderStroke = Instance.new("UIStroke")
    
    local ContentFrame = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")

    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 560, 0, 400)

    -- Multiple layered shadows for depth
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 60, 1, 60)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = ConfigWindow.AccentColor
    DropShadow.ImageTransparency = 0.4
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    DropShadow2.Name = "DropShadow2"
    DropShadow2.Parent = DropShadowHolder
    DropShadow2.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow2.BackgroundTransparency = 1
    DropShadow2.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow2.Size = UDim2.new(1, 30, 1, 30)
    DropShadow2.Image = "rbxassetid://6015897843"
    DropShadow2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow2.ImageTransparency = 0.6
    DropShadow2.ScaleType = Enum.ScaleType.Slice
    DropShadow2.SliceCenter = Rect.new(49, 49, 450, 450)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 18)
    UICorner.Parent = Main

    UIStroke.Color = ConfigWindow.AccentColor
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.7
    UIStroke.Parent = Main

    -- Create background pattern
    self:CreateBackgroundPattern(Main)

    -- Enhanced gradient overlay
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
    }
    MainGradient.Rotation = 135
    MainGradient.Parent = Main

    -- Multiple layered glow effects
    GlowEffect.Name = "Glow1"
    GlowEffect.Parent = Main
    GlowEffect.AnchorPoint = Vector2.new(0.5, 0)
    GlowEffect.BackgroundTransparency = 1
    GlowEffect.Position = UDim2.new(0.5, 0, 0, 0)
    GlowEffect.Size = UDim2.new(1.5, 0, 0.4, 0)
    GlowEffect.Image = "rbxassetid://6015897843"
    GlowEffect.ImageColor3 = ConfigWindow.AccentColor
    GlowEffect.ImageTransparency = 0.75
    GlowEffect.ScaleType = Enum.ScaleType.Slice
    GlowEffect.SliceCenter = Rect.new(49, 49, 450, 450)
    GlowEffect.ZIndex = 0

    GlowEffect2.Name = "Glow2"
    GlowEffect2.Parent = Main
    GlowEffect2.AnchorPoint = Vector2.new(0, 1)
    GlowEffect2.BackgroundTransparency = 1
    GlowEffect2.Position = UDim2.new(0, 0, 1, 0)
    GlowEffect2.Size = UDim2.new(0.6, 0, 0.3, 0)
    GlowEffect2.Image = "rbxassetid://6015897843"
    GlowEffect2.ImageColor3 = ConfigWindow.AccentColor
    GlowEffect2.ImageTransparency = 0.85
    GlowEffect2.ScaleType = Enum.ScaleType.Slice
    GlowEffect2.SliceCenter = Rect.new(49, 49, 450, 450)
    GlowEffect2.ZIndex = 0

    GlowEffect3.Name = "Glow3"
    GlowEffect3.Parent = Main
    GlowEffect3.AnchorPoint = Vector2.new(1, 1)
    GlowEffect3.BackgroundTransparency = 1
    GlowEffect3.Position = UDim2.new(1, 0, 1, 0)
    GlowEffect3.Size = UDim2.new(0.5, 0, 0.35, 0)
    GlowEffect3.Image = "rbxassetid://6015897843"
    GlowEffect3.ImageColor3 = ConfigWindow.AccentColor
    GlowEffect3.ImageTransparency = 0.88
    GlowEffect3.ScaleType = Enum.ScaleType.Slice
    GlowEffect3.SliceCenter = Rect.new(49, 49, 450, 450)
    GlowEffect3.ZIndex = 0

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Top.BackgroundTransparency = 0.2
    Top.Size = UDim2.new(1, 0, 0, 80)
    Top.ZIndex = 2

    TopGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 24))
    }
    TopGradient.Rotation = 90
    TopGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.75),
        NumberSequenceKeypoint.new(1, 1)
    }
    TopGradient.Parent = Top

    -- Accent line at bottom of top bar
    TopAccentLine.Name = "AccentLine"
    TopAccentLine.Parent = Top
    TopAccentLine.AnchorPoint = Vector2.new(0, 1)
    TopAccentLine.BackgroundColor3 = ConfigWindow.AccentColor
    TopAccentLine.BorderSizePixel = 0
    TopAccentLine.Position = UDim2.new(0, 0, 1, 0)
    TopAccentLine.Size = UDim2.new(1, 0, 0, 2)
    TopAccentLine.ZIndex = 3

    TopAccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, ConfigWindow.AccentColor)
    }
    TopAccentGradient.Parent = TopAccentLine

    -- Logo frame with premium styling
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Parent = Top
    LogoFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    LogoFrame.Position = UDim2.new(0, 14, 0, 12)
    LogoFrame.Size = UDim2.new(0, 56, 0, 56)
    LogoFrame.ZIndex = 3

    LogoFrameCorner.CornerRadius = UDim.new(0, 14)
    LogoFrameCorner.Parent = LogoFrame

    LogoFrameStroke.Color = ConfigWindow.AccentColor
    LogoFrameStroke.Thickness = 2
    LogoFrameStroke.Transparency = 0.5
    LogoFrameStroke.Parent = LogoFrame

    -- Pulsing border effect
    self:CreatePulsingBorder(LogoFrame, ConfigWindow.AccentColor)

    LogoHub.Name = "Logo"
    LogoHub.Parent = LogoFrame
    LogoHub.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoHub.Size = UDim2.new(0, 40, 0, 40)
    LogoHub.Image = "rbxassetid://101817370702077"
    LogoHub.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LogoHub.ZIndex = 4

    -- Enhanced logo glow
    self:CreateNeonGlow(LogoFrame, ConfigWindow.AccentColor, UDim2.new(1.6, 0, 1.6, 0))

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 82, 0, 16)
    NameHub.Size = UDim2.new(0, 300, 0, 30)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 22
    NameHub.TextXAlignment = Enum.TextXAlignment.Left
    NameHub.TextStrokeTransparency = 0.8
    NameHub.ZIndex = 3

    -- Text glow effect
    local NameGlow = NameHub:Clone()
    NameGlow.Name = "NameGlow"
    NameGlow.Parent = Top
    NameGlow.TextColor3 = ConfigWindow.AccentColor
    NameGlow.TextTransparency = 0.7
    NameGlow.ZIndex = 2

    Desc.Name = "Description"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 82, 0, 46)
    Desc.Size = UDim2.new(0, 300, 0, 20)
    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 3

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -110, 0, 24)
    RightButtons.Size = UDim2.new(0, 100, 0, 32)
    RightButtons.ZIndex = 3

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Buttons.Padding = UDim.new(0, 8)

    -- Premium styled minimize button
    Minize.Name = "Minimize"
    Minize.Parent = RightButtons
    Minize.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Minize.Size = UDim2.new(0, 32, 0, 32)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "_"
    Minize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minize.TextSize = 18
    Minize.AutoButtonColor = false
    Minize.ZIndex = 4

    MinizeCorner.CornerRadius = UDim.new(0, 8)
    MinizeCorner.Parent = Minize

    MinizeStroke.Color = Color3.fromRGB(60, 60, 80)
    MinizeStroke.Thickness = 1.5
    MinizeStroke.Transparency = 0.5
    MinizeStroke.Parent = Minize

    MinizeGlow.Name = "Glow"
    MinizeGlow.Parent = Minize
    MinizeGlow.BackgroundColor3 = ConfigWindow.AccentColor
    MinizeGlow.BackgroundTransparency = 1
    MinizeGlow.Size = UDim2.new(1, 0, 1, 0)
    MinizeGlow.ZIndex = 3

    local MinizeGlowCorner = Instance.new("UICorner")
    MinizeGlowCorner.CornerRadius = UDim.new(0, 8)
    MinizeGlowCorner.Parent = MinizeGlow

    -- Premium styled close button
    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
    Close.Size = UDim2.new(0, 32, 0, 32)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 16
    Close.AutoButtonColor = false
    Close.ZIndex = 4

    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = Close

    CloseStroke.Color = Color3.fromRGB(255, 80, 100)
    CloseStroke.Thickness = 1.5
    CloseStroke.Transparency = 0.5
    CloseStroke.Parent = Close

    CloseGlow.Name = "Glow"
    CloseGlow.Parent = Close
    CloseGlow.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
    CloseGlow.BackgroundTransparency = 1
    CloseGlow.Size = UDim2.new(1, 0, 1, 0)
    CloseGlow.ZIndex = 3

    local CloseGlowCorner = Instance.new("UICorner")
    CloseGlowCorner.CornerRadius = UDim.new(0, 8)
    CloseGlowCorner.Parent = CloseGlow

    -- Button interactions with premium effects
    Minize.MouseEnter:Connect(function()
        self:TweenInstance(Minize, 0.2, "BackgroundColor3", Color3.fromRGB(40, 40, 55))
        self:TweenInstance(MinizeGlow, 0.2, "BackgroundTransparency", 0.85)
        self:TweenInstance(MinizeStroke, 0.2, "Transparency", 0.2)
    end)

    Minize.MouseLeave:Connect(function()
        self:TweenInstance(Minize, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 40))
        self:TweenInstance(MinizeGlow, 0.2, "BackgroundTransparency", 1)
        self:TweenInstance(MinizeStroke, 0.2, "Transparency", 0.5)
    end)

    Close.MouseEnter:Connect(function()
        self:TweenInstance(Close, 0.2, "BackgroundColor3", Color3.fromRGB(220, 60, 80))
        self:TweenInstance(CloseGlow, 0.2, "BackgroundTransparency", 0.8)
        self:TweenInstance(CloseStroke, 0.2, "Transparency", 0.2)
    end)

    Close.MouseLeave:Connect(function()
        self:TweenInstance(Close, 0.2, "BackgroundColor3", Color3.fromRGB(200, 40, 60))
        self:TweenInstance(CloseGlow, 0.2, "BackgroundTransparency", 1)
        self:TweenInstance(CloseStroke, 0.2, "Transparency", 0.5)
    end)

    -- Premium styled tab holder
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    TabHolder.BackgroundTransparency = 0.3
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 12, 0, 94)
    TabHolder.Size = UDim2.new(0, 140, 1, -106)
    TabHolder.ScrollBarThickness = 4
    TabHolder.ScrollBarImageColor3 = ConfigWindow.AccentColor
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ZIndex = 2

    local TabHolderCorner = Instance.new("UICorner")
    TabHolderCorner.CornerRadius = UDim.new(0, 12)
    TabHolderCorner.Parent = TabHolder

    TabHolderStroke.Color = Color3.fromRGB(40, 40, 55)
    TabHolderStroke.Thickness = 1.5
    TabHolderStroke.Transparency = 0.6
    TabHolderStroke.Parent = TabHolder

    -- Glassmorphism effect
    self:CreateGlassmorphism(TabHolder)

    TabListLayout.Parent = TabHolder
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)

    TabPadding.Parent = TabHolder
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingBottom = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 164, 0, 94)
    ContentFrame.Size = UDim2.new(1, -176, 1, -106)
    ContentFrame.ZIndex = 2

    PageLayout.Parent = ContentFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.TweenTime = 0.3

    PageList.Parent = ContentFrame

    self:UpdateScrolling(TabHolder, TabListLayout)
    self:MakeDraggable(Top, Main)

    Close.MouseButton1Click:Connect(function()
        TeddyUI_Premium:Destroy()
    end)

    Minize.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = false
    end)

    local Tab = {}

    function Tab:NewTab(TabName, IconId)
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabIcon = Instance.new("ImageLabel")
        local TabIconGlow = Instance.new("ImageLabel")
        local TabText = Instance.new("TextLabel")
        local TabIndicator = Instance.new("Frame")
        local TabStroke = Instance.new("UIStroke")
        local TabGlow = Instance.new("Frame")

        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        TabButton.Name = TabName
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        TabButton.BackgroundTransparency = 0.4
        TabButton.Size = UDim2.new(1, 0, 0, 42)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.AutoButtonColor = false
        TabButton.ZIndex = 3

        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton

        TabStroke.Color = Color3.fromRGB(50, 50, 70)
        TabStroke.Thickness = 1.5
        TabStroke.Transparency = 0.7
        TabStroke.Parent = TabButton

        TabGlow.Name = "Glow"
        TabGlow.Parent = TabButton
        TabGlow.BackgroundColor3 = ConfigWindow.AccentColor
        TabGlow.BackgroundTransparency = 1
        TabGlow.Size = UDim2.new(1, 0, 1, 0)
        TabGlow.ZIndex = 2

        local TabGlowCorner = Instance.new("UICorner")
        TabGlowCorner.CornerRadius = UDim.new(0, 10)
        TabGlowCorner.Parent = TabGlow

        -- Icon frame with styling
        local IconFrame = Instance.new("Frame")
        IconFrame.Name = "IconFrame"
        IconFrame.Parent = TabButton
        IconFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        IconFrame.Position = UDim2.new(0, 8, 0, 8)
        IconFrame.Size = UDim2.new(0, 26, 0, 26)
        IconFrame.ZIndex = 4

        local IconFrameCorner = Instance.new("UICorner")
        IconFrameCorner.CornerRadius = UDim.new(0, 6)
        IconFrameCorner.Parent = IconFrame

        local IconFrameStroke = Instance.new("UIStroke")
        IconFrameStroke.Color = ConfigWindow.AccentColor
        IconFrameStroke.Thickness = 1
        IconFrameStroke.Transparency = 0.8
        IconFrameStroke.Parent = IconFrame

        TabIcon.Name = "Icon"
        TabIcon.Parent = IconFrame
        TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Image = IconId or "rbxassetid://10723434711"
        TabIcon.ImageColor3 = Color3.fromRGB(200, 200, 220)
        TabIcon.ZIndex = 5

        TabIconGlow.Name = "IconGlow"
        TabIconGlow.Parent = IconFrame
        TabIconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        TabIconGlow.BackgroundTransparency = 1
        TabIconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        TabIconGlow.Size = UDim2.new(2, 0, 2, 0)
        TabIconGlow.Image = "rbxassetid://6015897843"
        TabIconGlow.ImageColor3 = ConfigWindow.AccentColor
        TabIconGlow.ImageTransparency = 1
        TabIconGlow.ScaleType = Enum.ScaleType.Slice
        TabIconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
        TabIconGlow.ZIndex = 3

        TabText.Name = "TabText"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 42, 0, 0)
        TabText.Size = UDim2.new(1, -50, 1, 0)
        TabText.Font = Enum.Font.GothamMedium
        TabText.Text = TabName
        TabText.TextColor3 = Color3.fromRGB(200, 200, 220)
        TabText.TextSize = 13
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 4

        -- Active indicator
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabButton
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 0, 0)
        TabIndicator.Size = UDim2.new(0, 0, 1, 0)
        TabIndicator.ZIndex = 5

        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 10)
        IndicatorCorner.Parent = TabIndicator

        -- Page styling
        Page.Name = TabName .. "_Page"
        Page.Parent = PageList
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = ConfigWindow.AccentColor
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.BorderSizePixel = 0
        Page.ZIndex = 2

        PageList.Parent = Page
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 10)

        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 8)
        PagePadding.PaddingBottom = UDim.new(0, 8)
        PagePadding.PaddingLeft = UDim.new(0, 8)
        PagePadding.PaddingRight = UDim.new(0, 12)

        self:UpdateScrolling(Page, PageList)

        local function SetTab(Active)
            if Active then
                -- Active state with premium effects
                self:TweenInstance(TabButton, 0.3, "BackgroundColor3", Color3.fromRGB(28, 28, 38))
                self:TweenInstance(TabButton, 0.3, "BackgroundTransparency", 0)
                self:TweenInstance(TabGlow, 0.3, "BackgroundTransparency", 0.92)
                self:TweenInstance(TabStroke, 0.3, "Transparency", 0.3)
                self:TweenInstance(TabStroke, 0.3, "Color", ConfigWindow.AccentColor)
                self:TweenInstance(TabText, 0.3, "TextColor3", Color3.fromRGB(255, 255, 255))
                self:TweenInstance(TabIcon, 0.3, "ImageColor3", ConfigWindow.AccentColor)
                self:TweenInstance(TabIconGlow, 0.3, "ImageTransparency", 0.7)
                self:TweenInstance(IconFrameStroke, 0.3, "Transparency", 0.3)
                self:TweenInstance(TabIndicator, 0.3, "Size", UDim2.new(0, 3, 1, 0))
                PageLayout:JumpTo(Page)
            else
                -- Inactive state
                self:TweenInstance(TabButton, 0.3, "BackgroundColor3", Color3.fromRGB(20, 20, 28))
                self:TweenInstance(TabButton, 0.3, "BackgroundTransparency", 0.4)
                self:TweenInstance(TabGlow, 0.3, "BackgroundTransparency", 1)
                self:TweenInstance(TabStroke, 0.3, "Transparency", 0.7)
                self:TweenInstance(TabStroke, 0.3, "Color", Color3.fromRGB(50, 50, 70))
                self:TweenInstance(TabText, 0.3, "TextColor3", Color3.fromRGB(200, 200, 220))
                self:TweenInstance(TabIcon, 0.3, "ImageColor3", Color3.fromRGB(200, 200, 220))
                self:TweenInstance(TabIconGlow, 0.3, "ImageTransparency", 1)
                self:TweenInstance(IconFrameStroke, 0.3, "Transparency", 0.8)
                self:TweenInstance(TabIndicator, 0.3, "Size", UDim2.new(0, 0, 1, 0))
            end
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    SetTab(false)
                end
            end
            SetTab(true)
        end)

        -- Premium hover effects
        TabButton.MouseEnter:Connect(function()
            if TabIndicator.Size ~= UDim2.new(0, 3, 1, 0) then
                self:TweenInstance(TabButton, 0.2, "BackgroundTransparency", 0.2)
                self:TweenInstance(TabStroke, 0.2, "Transparency", 0.5)
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if TabIndicator.Size ~= UDim2.new(0, 3, 1, 0) then
                self:TweenInstance(TabButton, 0.2, "BackgroundTransparency", 0.4)
                self:TweenInstance(TabStroke, 0.2, "Transparency", 0.7)
            end
        end)

        if #TabHolder:GetChildren() == 2 then
            SetTab(true)
        end

        local TabFunc = {}

        function TabFunc:NewSection(SectionName, SectionDesc)
            local Section = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionGradient = Instance.new("UIGradient")
            local SectionTop = Instance.new("Frame")
            local SectionTopCorner = Instance.new("UICorner")
            local SectionTitle = Instance.new("TextLabel")
            local SectionDescription = Instance.new("TextLabel")
            local SectionAccent = Instance.new("Frame")
            local SectionContent = Instance.new("Frame")
            local SectionLayout = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            Section.Name = SectionName
            Section.Parent = Page
            Section.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            Section.BackgroundTransparency = 0.2
            Section.Size = UDim2.new(1, 0, 0, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.ZIndex = 2

            SectionCorner.CornerRadius = UDim.new(0, 12)
            SectionCorner.Parent = Section

            SectionStroke.Color = Color3.fromRGB(45, 45, 65)
            SectionStroke.Thickness = 1.5
            SectionStroke.Transparency = 0.6
            SectionStroke.Parent = Section

            -- Glassmorphism
            self:CreateGlassmorphism(Section)

            SectionGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 32)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 24))
            }
            SectionGradient.Rotation = 45
            SectionGradient.Parent = Section

            SectionTop.Name = "Top"
            SectionTop.Parent = Section
            SectionTop.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
            SectionTop.BackgroundTransparency = 0.3
            SectionTop.Size = UDim2.new(1, 0, 0, 50)
            SectionTop.ZIndex = 3

            SectionTopCorner.CornerRadius = UDim.new(0, 12)
            SectionTopCorner.Parent = SectionTop

            -- Accent bar
            SectionAccent.Name = "Accent"
            SectionAccent.Parent = SectionTop
            SectionAccent.BackgroundColor3 = ConfigWindow.AccentColor
            SectionAccent.BorderSizePixel = 0
            SectionAccent.Size = UDim2.new(0, 4, 1, 0)
            SectionAccent.ZIndex = 4

            local AccentCorner = Instance.new("UICorner")
            AccentCorner.CornerRadius = UDim.new(0, 12)
            AccentCorner.Parent = SectionAccent

            SectionTitle.Name = "Title"
            SectionTitle.Parent = SectionTop
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 18, 0, 10)
            SectionTitle.Size = UDim2.new(1, -24, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = SectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 15
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.ZIndex = 4

            SectionDescription.Name = "Description"
            SectionDescription.Parent = SectionTop
            SectionDescription.BackgroundTransparency = 1
            SectionDescription.Position = UDim2.new(0, 18, 0, 30)
            SectionDescription.Size = UDim2.new(1, -24, 0, 16)
            SectionDescription.Font = Enum.Font.Gotham
            SectionDescription.Text = SectionDesc or ""
            SectionDescription.TextColor3 = Color3.fromRGB(170, 170, 190)
            SectionDescription.TextSize = 11
            SectionDescription.TextXAlignment = Enum.TextXAlignment.Left
            SectionDescription.ZIndex = 4

            SectionContent.Name = "Content"
            SectionContent.Parent = Section
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 50)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.ZIndex = 3

            SectionLayout.Parent = SectionContent
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 8)

            SectionPadding.Parent = SectionContent
            SectionPadding.PaddingTop = UDim.new(0, 12)
            SectionPadding.PaddingBottom = UDim.new(0, 12)
            SectionPadding.PaddingLeft = UDim.new(0, 14)
            SectionPadding.PaddingRight = UDim.new(0, 14)

            local SectionFunc = {}
            local CurrentGroup = SectionContent

            function SectionFunc:AddButton(ButtonConfig)
                local ButtonConfig = self:MakeConfig({
                    Title = "Button",
                    Description = "",
                    Callback = function() end
                }, ButtonConfig or {})

                local ButtonFrame = Instance.new("Frame")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonStroke = Instance.new("UIStroke")
                local ButtonGradient = Instance.new("UIGradient")
                local ButtonTitle = Instance.new("TextLabel")
                local ButtonDesc = Instance.new("TextLabel")
                local Button = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnGlow = Instance.new("Frame")
                local BtnIcon = Instance.new("ImageLabel")

                ButtonFrame.Parent = CurrentGroup
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                ButtonFrame.BackgroundTransparency = 0.3
                ButtonFrame.Size = UDim2.new(1, 0, 0, 52)
                ButtonFrame.ZIndex = 3

                ButtonCorner.CornerRadius = UDim.new(0, 10)
                ButtonCorner.Parent = ButtonFrame

                ButtonStroke.Color = Color3.fromRGB(50, 50, 70)
                ButtonStroke.Thickness = 1.5
                ButtonStroke.Transparency = 0.7
                ButtonStroke.Parent = ButtonFrame

                self:CreateGlassmorphism(ButtonFrame)

                ButtonGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                ButtonGradient.Rotation = 90
                ButtonGradient.Parent = ButtonFrame

                ButtonTitle.Parent = ButtonFrame
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Position = UDim2.new(0, 14, 0, 8)
                ButtonTitle.Size = UDim2.new(1, -100, 0, 20)
                ButtonTitle.Font = Enum.Font.GothamMedium
                ButtonTitle.Text = ButtonConfig.Title
                ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonTitle.TextSize = 13
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
                ButtonTitle.ZIndex = 4

                ButtonDesc.Parent = ButtonFrame
                ButtonDesc.BackgroundTransparency = 1
                ButtonDesc.Position = UDim2.new(0, 14, 0, 28)
                ButtonDesc.Size = UDim2.new(1, -100, 0, 16)
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.Text = ButtonConfig.Description
                ButtonDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
                ButtonDesc.TextSize = 11
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
                ButtonDesc.ZIndex = 4

                Button.Parent = ButtonFrame
                Button.BackgroundColor3 = ConfigWindow.AccentColor
                Button.Position = UDim2.new(1, -72, 0, 10)
                Button.Size = UDim2.new(0, 64, 0, 32)
                Button.Font = Enum.Font.GothamBold
                Button.Text = ""
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 13
                Button.AutoButtonColor = false
                Button.ZIndex = 5

                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = Button

                BtnStroke.Color = Color3.fromRGB(255, 255, 255)
                BtnStroke.Thickness = 1
                BtnStroke.Transparency = 0.9
                BtnStroke.Parent = Button

                BtnGlow.Name = "Glow"
                BtnGlow.Parent = Button
                BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BtnGlow.BackgroundTransparency = 1
                BtnGlow.Size = UDim2.new(1, 0, 1, 0)
                BtnGlow.ZIndex = 4

                local BtnGlowCorner = Instance.new("UICorner")
                BtnGlowCorner.CornerRadius = UDim.new(0, 8)
                BtnGlowCorner.Parent = BtnGlow

                BtnIcon.Parent = Button
                BtnIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                BtnIcon.Size = UDim2.new(0, 16, 0, 16)
                BtnIcon.Image = "rbxassetid://10734896206"
                BtnIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                BtnIcon.ZIndex = 6

                Button.MouseEnter:Connect(function()
                    Library:TweenInstance(Button, 0.2, "BackgroundColor3", Color3.fromRGB(
                        math.clamp(ConfigWindow.AccentColor.R * 255 + 30, 0, 255),
                        math.clamp(ConfigWindow.AccentColor.G * 255 + 30, 0, 255),
                        math.clamp(ConfigWindow.AccentColor.B * 255 + 30, 0, 255)
                    ))
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 0.85)
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.7)
                end)

                Button.MouseLeave:Connect(function()
                    Library:TweenInstance(Button, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 1)
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.9)
                end)

                Button.MouseButton1Click:Connect(function()
                    Library:TweenInstance(Button, 0.1, "Size", UDim2.new(0, 60, 0, 28))
                    task.wait(0.1)
                    Library:TweenInstance(Button, 0.1, "Size", UDim2.new(0, 64, 0, 32))
                    pcall(ButtonConfig.Callback)
                end)

                return {
                    SetTitle = function(self, val)
                        ButtonTitle.Text = val
                    end,
                    SetDesc = function(self, val)
                        ButtonDesc.Text = val
                    end
                }
            end

            function SectionFunc:AddToggle(ToggleConfig)
                local ToggleConfig = self:MakeConfig({
                    Title = "Toggle",
                    Description = "",
                    Default = false,
                    Callback = function() end
                }, ToggleConfig or {})

                local ToggleValue = ToggleConfig.Default

                local ToggleFrame = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleStroke = Instance.new("UIStroke")
                local ToggleGradient = Instance.new("UIGradient")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleDesc = Instance.new("TextLabel")
                local ToggleButton = Instance.new("TextButton")
                local ToggleBg = Instance.new("Frame")
                local BgCorner = Instance.new("UICorner")
                local BgStroke = Instance.new("UIStroke")
                local ToggleKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local KnobGlow = Instance.new("ImageLabel")

                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                ToggleFrame.BackgroundTransparency = 0.3
                ToggleFrame.Size = UDim2.new(1, 0, 0, 52)
                ToggleFrame.ZIndex = 3

                ToggleCorner.CornerRadius = UDim.new(0, 10)
                ToggleCorner.Parent = ToggleFrame

                ToggleStroke.Color = Color3.fromRGB(50, 50, 70)
                ToggleStroke.Thickness = 1.5
                ToggleStroke.Transparency = 0.7
                ToggleStroke.Parent = ToggleFrame

                self:CreateGlassmorphism(ToggleFrame)

                ToggleGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                ToggleGradient.Rotation = 90
                ToggleGradient.Parent = ToggleFrame

                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 14, 0, 8)
                ToggleTitle.Size = UDim2.new(1, -90, 0, 20)
                ToggleTitle.Font = Enum.Font.GothamMedium
                ToggleTitle.Text = ToggleConfig.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleTitle.TextSize = 13
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.ZIndex = 4

                ToggleDesc.Parent = ToggleFrame
                ToggleDesc.BackgroundTransparency = 1
                ToggleDesc.Position = UDim2.new(0, 14, 0, 28)
                ToggleDesc.Size = UDim2.new(1, -90, 0, 16)
                ToggleDesc.Font = Enum.Font.Gotham
                ToggleDesc.Text = ToggleConfig.Description
                ToggleDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
                ToggleDesc.TextSize = 11
                ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                ToggleDesc.ZIndex = 4

                ToggleButton.Parent = ToggleFrame
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Position = UDim2.new(1, -64, 0, 14)
                ToggleButton.Size = UDim2.new(0, 54, 0, 24)
                ToggleButton.Text = ""
                ToggleButton.ZIndex = 5

                ToggleBg.Parent = ToggleButton
                ToggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                ToggleBg.Size = UDim2.new(1, 0, 1, 0)
                ToggleBg.ZIndex = 5

                BgCorner.CornerRadius = UDim.new(1, 0)
                BgCorner.Parent = ToggleBg

                BgStroke.Color = Color3.fromRGB(60, 60, 85)
                BgStroke.Thickness = 2
                BgStroke.Transparency = 0.5
                BgStroke.Parent = ToggleBg

                ToggleKnob.Parent = ToggleBg
                ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
                ToggleKnob.Position = UDim2.new(0, 3, 0, 3)
                ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
                ToggleKnob.ZIndex = 6

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = ToggleKnob

                KnobGlow.Name = "KnobGlow"
                KnobGlow.Parent = ToggleKnob
                KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobGlow.BackgroundTransparency = 1
                KnobGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobGlow.Size = UDim2.new(2.5, 0, 2.5, 0)
                KnobGlow.Image = "rbxassetid://6015897843"
                KnobGlow.ImageColor3 = ConfigWindow.AccentColor
                KnobGlow.ImageTransparency = 1
                KnobGlow.ScaleType = Enum.ScaleType.Slice
                KnobGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                KnobGlow.ZIndex = 5

                local function UpdateToggle()
                    if ToggleValue then
                        Library:TweenInstance(ToggleBg, 0.3, "BackgroundColor3", ConfigWindow.AccentColor)
                        Library:TweenInstance(ToggleKnob, 0.3, "Position", UDim2.new(1, -21, 0, 3))
                        Library:TweenInstance(ToggleKnob, 0.3, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
                        Library:TweenInstance(BgStroke, 0.3, "Color", ConfigWindow.AccentColor)
                        Library:TweenInstance(BgStroke, 0.3, "Transparency", 0.3)
                        Library:TweenInstance(KnobGlow, 0.3, "ImageTransparency", 0.6)
                    else
                        Library:TweenInstance(ToggleBg, 0.3, "BackgroundColor3", Color3.fromRGB(35, 35, 50))
                        Library:TweenInstance(ToggleKnob, 0.3, "Position", UDim2.new(0, 3, 0, 3))
                        Library:TweenInstance(ToggleKnob, 0.3, "BackgroundColor3", Color3.fromRGB(200, 200, 220))
                        Library:TweenInstance(BgStroke, 0.3, "Color", Color3.fromRGB(60, 60, 85))
                        Library:TweenInstance(BgStroke, 0.3, "Transparency", 0.5)
                        Library:TweenInstance(KnobGlow, 0.3, "ImageTransparency", 1)
                    end
                end

                UpdateToggle()

                ToggleButton.MouseButton1Click:Connect(function()
                    ToggleValue = not ToggleValue
                    UpdateToggle()
                    pcall(ToggleConfig.Callback, ToggleValue)
                end)

                return {
                    Set = function(self, val)
                        ToggleValue = val
                        UpdateToggle()
                        pcall(ToggleConfig.Callback, ToggleValue)
                    end,
                    SetTitle = function(self, val)
                        ToggleTitle.Text = val
                    end,
                    SetDesc = function(self, val)
                        ToggleDesc.Text = val
                    end
                }
            end

            function SectionFunc:AddSlider(SliderConfig)
                local SliderConfig = self:MakeConfig({
                    Title = "Slider",
                    Description = "",
                    Min = 0,
                    Max = 100,
                    Default = 50,
                    Callback = function() end
                }, SliderConfig or {})

                local SliderValue = SliderConfig.Default

                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderStroke = Instance.new("UIStroke")
                local SliderGradient = Instance.new("UIGradient")
                local SliderTitle = Instance.new("TextLabel")
                local SliderDesc = Instance.new("TextLabel")
                local ValueLabel = Instance.new("TextLabel")
                local ValueFrame = Instance.new("Frame")
                local ValueCorner = Instance.new("UICorner")
                local SliderTrack = Instance.new("Frame")
                local TrackCorner = Instance.new("UICorner")
                local TrackStroke = Instance.new("UIStroke")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local FillGlow = Instance.new("ImageLabel")
                local SliderKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local KnobStroke = Instance.new("UIStroke")
                local KnobGlow = Instance.new("ImageLabel")
                local SliderButton = Instance.new("TextButton")

                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                SliderFrame.BackgroundTransparency = 0.3
                SliderFrame.Size = UDim2.new(1, 0, 0, 74)
                SliderFrame.ZIndex = 3

                SliderCorner.CornerRadius = UDim.new(0, 10)
                SliderCorner.Parent = SliderFrame

                SliderStroke.Color = Color3.fromRGB(50, 50, 70)
                SliderStroke.Thickness = 1.5
                SliderStroke.Transparency = 0.7
                SliderStroke.Parent = SliderFrame

                self:CreateGlassmorphism(SliderFrame)

                SliderGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                SliderGradient.Rotation = 90
                SliderGradient.Parent = SliderFrame

                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 14, 0, 8)
                SliderTitle.Size = UDim2.new(1, -90, 0, 20)
                SliderTitle.Font = Enum.Font.GothamMedium
                SliderTitle.Text = SliderConfig.Title
                SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.ZIndex = 4

                SliderDesc.Parent = SliderFrame
                SliderDesc.BackgroundTransparency = 1
                SliderDesc.Position = UDim2.new(0, 14, 0, 28)
                SliderDesc.Size = UDim2.new(1, -90, 0, 16)
                SliderDesc.Font = Enum.Font.Gotham
                SliderDesc.Text = SliderConfig.Description
                SliderDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
                SliderDesc.TextSize = 11
                SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
                SliderDesc.ZIndex = 4

                ValueFrame.Parent = SliderFrame
                ValueFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
                ValueFrame.Position = UDim2.new(1, -56, 0, 10)
                ValueFrame.Size = UDim2.new(0, 48, 0, 28)
                ValueFrame.ZIndex = 4

                ValueCorner.CornerRadius = UDim.new(0, 8)
                ValueCorner.Parent = ValueFrame

                local ValueStroke = Instance.new("UIStroke")
                ValueStroke.Color = ConfigWindow.AccentColor
                ValueStroke.Thickness = 1.5
                ValueStroke.Transparency = 0.7
                ValueStroke.Parent = ValueFrame

                ValueLabel.Parent = ValueFrame
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Size = UDim2.new(1, 0, 1, 0)
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Text = tostring(SliderValue)
                ValueLabel.TextColor3 = ConfigWindow.AccentColor
                ValueLabel.TextSize = 13
                ValueLabel.ZIndex = 5

                SliderTrack.Parent = SliderFrame
                SliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                SliderTrack.Position = UDim2.new(0, 14, 1, -22)
                SliderTrack.Size = UDim2.new(1, -28, 0, 8)
                SliderTrack.ZIndex = 4

                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack

                TrackStroke.Color = Color3.fromRGB(50, 50, 70)
                TrackStroke.Thickness = 1
                TrackStroke.Transparency = 0.6
                TrackStroke.Parent = SliderTrack

                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.ZIndex = 5

                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                FillGlow.Name = "FillGlow"
                FillGlow.Parent = SliderFill
                FillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                FillGlow.BackgroundTransparency = 1
                FillGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                FillGlow.Size = UDim2.new(1, 10, 3, 0)
                FillGlow.Image = "rbxassetid://6015897843"
                FillGlow.ImageColor3 = ConfigWindow.AccentColor
                FillGlow.ImageTransparency = 0.7
                FillGlow.ScaleType = Enum.ScaleType.Slice
                FillGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                FillGlow.ZIndex = 4

                SliderKnob.Parent = SliderTrack
                SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
                SliderKnob.Size = UDim2.new(0, 16, 0, 16)
                SliderKnob.ZIndex = 7

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SliderKnob

                KnobStroke.Color = ConfigWindow.AccentColor
                KnobStroke.Thickness = 2
                KnobStroke.Transparency = 0.3
                KnobStroke.Parent = SliderKnob

                KnobGlow.Name = "KnobGlow"
                KnobGlow.Parent = SliderKnob
                KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobGlow.BackgroundTransparency = 1
                KnobGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobGlow.Size = UDim2.new(3, 0, 3, 0)
                KnobGlow.Image = "rbxassetid://6015897843"
                KnobGlow.ImageColor3 = ConfigWindow.AccentColor
                KnobGlow.ImageTransparency = 0.5
                KnobGlow.ScaleType = Enum.ScaleType.Slice
                KnobGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                KnobGlow.ZIndex = 6

                SliderButton.Parent = SliderTrack
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Text = ""
                SliderButton.ZIndex = 8

                local Dragging = false

                local function UpdateSlider(input)
                    local Percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    SliderValue = math.floor(SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * Percent)
                    ValueLabel.Text = tostring(SliderValue)
                    Library:TweenInstance(SliderFill, 0.1, "Size", UDim2.new(Percent, 0, 1, 0))
                    Library:TweenInstance(SliderKnob, 0.1, "Position", UDim2.new(Percent, 0, 0.5, 0))
                    pcall(SliderConfig.Callback, SliderValue)
                end

                SliderButton.MouseButton1Down:Connect(function()
                    Dragging = true
                    Library:TweenInstance(SliderKnob, 0.2, "Size", UDim2.new(0, 20, 0, 20))
                    Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.3)
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                        Library:TweenInstance(SliderKnob, 0.2, "Size", UDim2.new(0, 16, 0, 16))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.5)
                    end
                end)

                SliderButton.MouseButton1Click:Connect(function(input)
                    UpdateSlider(input)
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)

                UpdateSlider({Position = Vector2.new(SliderTrack.AbsolutePosition.X + (SliderTrack.AbsoluteSize.X * ((SliderValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min))), 0)})

                return {
                    Set = function(self, val)
                        SliderValue = math.clamp(val, SliderConfig.Min, SliderConfig.Max)
                        ValueLabel.Text = tostring(SliderValue)
                        local Percent = (SliderValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                        Library:TweenInstance(SliderFill, 0.3, "Size", UDim2.new(Percent, 0, 1, 0))
                        Library:TweenInstance(SliderKnob, 0.3, "Position", UDim2.new(Percent, 0, 0.5, 0))
                        pcall(SliderConfig.Callback, SliderValue)
                    end,
                    SetTitle = function(self, val)
                        SliderTitle.Text = val
                    end,
                    SetDesc = function(self, val)
                        SliderDesc.Text = val
                    end
                }
            end

            function SectionFunc:AddDropdown(DropdownConfig)
                local DropdownConfig = self:MakeConfig({
                    Title = "Dropdown",
                    Description = "",
                    Options = {"Option 1", "Option 2"},
                    Default = "Option 1",
                    Callback = function() end
                }, DropdownConfig or {})

                local SelectedOption = DropdownConfig.Default
                local IsOpen = false

                local DropdownFrame = Instance.new("Frame")
                local DropdownCorner = Instance.new("UICorner")
                local DropdownStroke = Instance.new("UIStroke")
                local DropdownGradient = Instance.new("UIGradient")
                local DropdownTitle = Instance.new("TextLabel")
                local DropdownDesc = Instance.new("TextLabel")
                local DropdownButton = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnGlow = Instance.new("Frame")
                local SelectedText = Instance.new("TextLabel")
                local ArrowIcon = Instance.new("ImageLabel")
                
                local OptionsFrame = Instance.new("Frame")
                local OptionsCorner = Instance.new("UICorner")
                local OptionsStroke = Instance.new("UIStroke")
                local OptionsGradient = Instance.new("UIGradient")
                local OptionsScroll = Instance.new("ScrollingFrame")
                local OptionsList = Instance.new("UIListLayout")
                local OptionsPadding = Instance.new("UIPadding")

                DropdownFrame.Parent = CurrentGroup
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                DropdownFrame.BackgroundTransparency = 0.3
                DropdownFrame.Size = UDim2.new(1, 0, 0, 52)
                DropdownFrame.ClipsDescendants = false
                DropdownFrame.ZIndex = 3

                DropdownCorner.CornerRadius = UDim.new(0, 10)
                DropdownCorner.Parent = DropdownFrame

                DropdownStroke.Color = Color3.fromRGB(50, 50, 70)
                DropdownStroke.Thickness = 1.5
                DropdownStroke.Transparency = 0.7
                DropdownStroke.Parent = DropdownFrame

                self:CreateGlassmorphism(DropdownFrame)

                DropdownGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                DropdownGradient.Rotation = 90
                DropdownGradient.Parent = DropdownFrame

                DropdownTitle.Parent = DropdownFrame
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2.new(0, 14, 0, 8)
                DropdownTitle.Size = UDim2.new(1, -140, 0, 20)
                DropdownTitle.Font = Enum.Font.GothamMedium
                DropdownTitle.Text = DropdownConfig.Title
                DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownTitle.TextSize = 13
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropdownTitle.ZIndex = 4

                DropdownDesc.Parent = DropdownFrame
                DropdownDesc.BackgroundTransparency = 1
                DropdownDesc.Position = UDim2.new(0, 14, 0, 28)
                DropdownDesc.Size = UDim2.new(1, -140, 0, 16)
                DropdownDesc.Font = Enum.Font.Gotham
                DropdownDesc.Text = DropdownConfig.Description
                DropdownDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
                DropdownDesc.TextSize = 11
                DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
                DropdownDesc.ZIndex = 4

                DropdownButton.Parent = DropdownFrame
                DropdownButton.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
                DropdownButton.Position = UDim2.new(1, -126, 0, 10)
                DropdownButton.Size = UDim2.new(0, 118, 0, 32)
                DropdownButton.Text = ""
                DropdownButton.AutoButtonColor = false
                DropdownButton.ZIndex = 5

                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = DropdownButton

                BtnStroke.Color = ConfigWindow.AccentColor
                BtnStroke.Thickness = 1.5
                BtnStroke.Transparency = 0.7
                BtnStroke.Parent = DropdownButton

                BtnGlow.Name = "Glow"
                BtnGlow.Parent = DropdownButton
                BtnGlow.BackgroundColor3 = ConfigWindow.AccentColor
                BtnGlow.BackgroundTransparency = 1
                BtnGlow.Size = UDim2.new(1, 0, 1, 0)
                BtnGlow.ZIndex = 4

                local BtnGlowCorner = Instance.new("UICorner")
                BtnGlowCorner.CornerRadius = UDim.new(0, 8)
                BtnGlowCorner.Parent = BtnGlow

                SelectedText.Parent = DropdownButton
                SelectedText.BackgroundTransparency = 1
                SelectedText.Position = UDim2.new(0, 10, 0, 0)
                SelectedText.Size = UDim2.new(1, -30, 1, 0)
                SelectedText.Font = Enum.Font.GothamMedium
                SelectedText.Text = SelectedOption
                SelectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SelectedText.TextSize = 12
                SelectedText.TextXAlignment = Enum.TextXAlignment.Left
                SelectedText.TextTruncate = Enum.TextTruncate.AtEnd
                SelectedText.ZIndex = 6

                ArrowIcon.Parent = DropdownButton
                ArrowIcon.AnchorPoint = Vector2.new(1, 0.5)
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Position = UDim2.new(1, -8, 0.5, 0)
                ArrowIcon.Size = UDim2.new(0, 12, 0, 12)
                ArrowIcon.Image = "rbxassetid://10709791437"
                ArrowIcon.ImageColor3 = ConfigWindow.AccentColor
                ArrowIcon.Rotation = 0
                ArrowIcon.ZIndex = 6

                OptionsFrame.Parent = DropdownFrame
                OptionsFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                OptionsFrame.BackgroundTransparency = 0.1
                OptionsFrame.Position = UDim2.new(1, -126, 0, 46)
                OptionsFrame.Size = UDim2.new(0, 118, 0, 0)
                OptionsFrame.ClipsDescendants = true
                OptionsFrame.Visible = false
                OptionsFrame.ZIndex = 10

                OptionsCorner.CornerRadius = UDim.new(0, 8)
                OptionsCorner.Parent = OptionsFrame

                OptionsStroke.Color = ConfigWindow.AccentColor
                OptionsStroke.Thickness = 1.5
                OptionsStroke.Transparency = 0.5
                OptionsStroke.Parent = OptionsFrame

                self:CreateGlassmorphism(OptionsFrame)

                OptionsGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
                }
                OptionsGradient.Rotation = 90
                OptionsGradient.Parent = OptionsFrame

                OptionsScroll.Parent = OptionsFrame
                OptionsScroll.BackgroundTransparency = 1
                OptionsScroll.Size = UDim2.new(1, 0, 1, 0)
                OptionsScroll.ScrollBarThickness = 3
                OptionsScroll.ScrollBarImageColor3 = ConfigWindow.AccentColor
                OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                OptionsScroll.BorderSizePixel = 0
                OptionsScroll.ZIndex = 11

                OptionsList.Parent = OptionsScroll
                OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsList.Padding = UDim.new(0, 2)

                OptionsPadding.Parent = OptionsScroll
                OptionsPadding.PaddingTop = UDim.new(0, 6)
                OptionsPadding.PaddingBottom = UDim.new(0, 6)
                OptionsPadding.PaddingLeft = UDim.new(0, 6)
                OptionsPadding.PaddingRight = UDim.new(0, 6)

                for _, option in ipairs(DropdownConfig.Options) do
                    local OptionButton = Instance.new("TextButton")
                    local OptionCorner = Instance.new("UICorner")
                    local OptionGlow = Instance.new("Frame")

                    OptionButton.Parent = OptionsScroll
                    OptionButton.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
                    OptionButton.BackgroundTransparency = 0.3
                    OptionButton.Size = UDim2.new(1, 0, 0, 28)
                    OptionButton.Font = Enum.Font.GothamMedium
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(200, 200, 220)
                    OptionButton.TextSize = 11
                    OptionButton.AutoButtonColor = false
                    OptionButton.ZIndex = 12

                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = OptionButton

                    OptionGlow.Name = "Glow"
                    OptionGlow.Parent = OptionButton
                    OptionGlow.BackgroundColor3 = ConfigWindow.AccentColor
                    OptionGlow.BackgroundTransparency = 1
                    OptionGlow.Size = UDim2.new(1, 0, 1, 0)
                    OptionGlow.ZIndex = 11

                    local OptionGlowCorner = Instance.new("UICorner")
                    OptionGlowCorner.CornerRadius = UDim.new(0, 6)
                    OptionGlowCorner.Parent = OptionGlow

                    OptionButton.MouseEnter:Connect(function()
                        Library:TweenInstance(OptionButton, 0.2, "BackgroundTransparency", 0)
                        Library:TweenInstance(OptionButton, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
                        Library:TweenInstance(OptionGlow, 0.2, "BackgroundTransparency", 0.9)
                    end)

                    OptionButton.MouseLeave:Connect(function()
                        if SelectedOption ~= option then
                            Library:TweenInstance(OptionButton, 0.2, "BackgroundTransparency", 0.3)
                            Library:TweenInstance(OptionButton, 0.2, "TextColor3", Color3.fromRGB(200, 200, 220))
                            Library:TweenInstance(OptionGlow, 0.2, "BackgroundTransparency", 1)
                        end
                    end)

                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        SelectedText.Text = option
                        IsOpen = false
                        OptionsFrame.Visible = false
                        Library:TweenInstance(OptionsFrame, 0.3, "Size", UDim2.new(0, 118, 0, 0))
                        Library:TweenInstance(ArrowIcon, 0.3, "Rotation", 0)
                        pcall(DropdownConfig.Callback, option)
                    end)

                    if option == SelectedOption then
                        OptionButton.BackgroundTransparency = 0
                        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        OptionGlow.BackgroundTransparency = 0.9
                    end
                end

                Library:UpdateScrolling(OptionsScroll, OptionsList)

                DropdownButton.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    if IsOpen then
                        OptionsFrame.Visible = true
                        local optionCount = math.min(#DropdownConfig.Options, 5)
                        Library:TweenInstance(OptionsFrame, 0.3, "Size", UDim2.new(0, 118, 0, (optionCount * 30) + 12))
                        Library:TweenInstance(ArrowIcon, 0.3, "Rotation", 180)
                    else
                        Library:TweenInstance(OptionsFrame, 0.3, "Size", UDim2.new(0, 118, 0, 0))
                        Library:TweenInstance(ArrowIcon, 0.3, "Rotation", 0)
                        task.wait(0.3)
                        OptionsFrame.Visible = false
                    end
                end)

                DropdownButton.MouseEnter:Connect(function()
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 0.92)
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.4)
                end)

                DropdownButton.MouseLeave:Connect(function()
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 1)
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.7)
                end)

                return {
                    Set = function(self, val)
                        if table.find(DropdownConfig.Options, val) then
                            SelectedOption = val
                            SelectedText.Text = val
                            pcall(DropdownConfig.Callback, val)
                        end
                    end,
                    SetTitle = function(self, val)
                        DropdownTitle.Text = val
                    end,
                    SetDesc = function(self, val)
                        DropdownDesc.Text = val
                    end
                }
            end

            function SectionFunc:AddInput(InputConfig)
                local InputConfig = self:MakeConfig({
                    Title = "Input",
                    Description = "",
                    Placeholder = "Enter text...",
                    Default = "",
                    Callback = function() end
                }, InputConfig or {})

                local InputValue = InputConfig.Default

                local InputFrame = Instance.new("Frame")
                local InputCorner = Instance.new("UICorner")
                local InputStroke = Instance.new("UIStroke")
                local InputGradient = Instance.new("UIGradient")
                local InputTitle = Instance.new("TextLabel")
                local InputDesc = Instance.new("TextLabel")
                local InputBox = Instance.new("TextBox")
                local BoxCorner = Instance.new("UICorner")
                local BoxStroke = Instance.new("UIStroke")
                local BoxGlow = Instance.new("Frame")

                InputFrame.Parent = CurrentGroup
                InputFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                InputFrame.BackgroundTransparency = 0.3
                InputFrame.Size = UDim2.new(1, 0, 0, 52)
                InputFrame.ZIndex = 3

                InputCorner.CornerRadius = UDim.new(0, 10)
                InputCorner.Parent = InputFrame

                InputStroke.Color = Color3.fromRGB(50, 50, 70)
                InputStroke.Thickness = 1.5
                InputStroke.Transparency = 0.7
                InputStroke.Parent = InputFrame

                self:CreateGlassmorphism(InputFrame)

                InputGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                InputGradient.Rotation = 90
                InputGradient.Parent = InputFrame

                InputTitle.Parent = InputFrame
                InputTitle.BackgroundTransparency = 1
                InputTitle.Position = UDim2.new(0, 14, 0, 8)
                InputTitle.Size = UDim2.new(1, -140, 0, 20)
                InputTitle.Font = Enum.Font.GothamMedium
                InputTitle.Text = InputConfig.Title
                InputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputTitle.TextSize = 13
                InputTitle.TextXAlignment = Enum.TextXAlignment.Left
                InputTitle.ZIndex = 4

                InputDesc.Parent = InputFrame
                InputDesc.BackgroundTransparency = 1
                InputDesc.Position = UDim2.new(0, 14, 0, 28)
                InputDesc.Size = UDim2.new(1, -140, 0, 16)
                InputDesc.Font = Enum.Font.Gotham
                InputDesc.Text = InputConfig.Description
                InputDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
                InputDesc.TextSize = 11
                InputDesc.TextXAlignment = Enum.TextXAlignment.Left
                InputDesc.ZIndex = 4

                InputBox.Parent = InputFrame
                InputBox.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
                InputBox.Position = UDim2.new(1, -126, 0, 10)
                InputBox.Size = UDim2.new(0, 118, 0, 32)
                InputBox.Font = Enum.Font.GothamMedium
                InputBox.PlaceholderText = InputConfig.Placeholder
                InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
                InputBox.Text = InputConfig.Default
                InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputBox.TextSize = 12
                InputBox.ClearTextOnFocus = false
                InputBox.ZIndex = 5

                BoxCorner.CornerRadius = UDim.new(0, 8)
                BoxCorner.Parent = InputBox

                BoxStroke.Color = ConfigWindow.AccentColor
                BoxStroke.Thickness = 1.5
                BoxStroke.Transparency = 0.7
                BoxStroke.Parent = InputBox

                BoxGlow.Name = "Glow"
                BoxGlow.Parent = InputBox
                BoxGlow.BackgroundColor3 = ConfigWindow.AccentColor
                BoxGlow.BackgroundTransparency = 1
                BoxGlow.Size = UDim2.new(1, 0, 1, 0)
                BoxGlow.ZIndex = 4

                local BoxGlowCorner = Instance.new("UICorner")
                BoxGlowCorner.CornerRadius = UDim.new(0, 8)
                BoxGlowCorner.Parent = BoxGlow

                InputBox.Focused:Connect(function()
                    Library:TweenInstance(BoxStroke, 0.2, "Transparency", 0.3)
                    Library:TweenInstance(BoxGlow, 0.2, "BackgroundTransparency", 0.92)
                end)

                InputBox.FocusLost:Connect(function(enter)
                    Library:TweenInstance(BoxStroke, 0.2, "Transparency", 0.7)
                    Library:TweenInstance(BoxGlow, 0.2, "BackgroundTransparency", 1)
                    if enter then
                        InputValue = InputBox.Text
                        pcall(InputConfig.Callback, InputValue)
                    end
                end)

                return {
                    Set = function(self, val)
                        InputValue = val
                        InputBox.Text = val
                        pcall(InputConfig.Callback, val)
                    end,
                    SetTitle = function(self, val)
                        InputTitle.Text = val
                    end,
                    SetDesc = function(self, val)
                        InputDesc.Text = val
                    end
                }
            end

            function SectionFunc:AddLabel(LabelTitle)
                local LabelFrame = Instance.new("Frame")
                local LabelCorner = Instance.new("UICorner")
                local LabelStroke = Instance.new("UIStroke")
                local LabelText = Instance.new("TextLabel")
                local LabelIcon = Instance.new("ImageLabel")

                LabelFrame.Parent = CurrentGroup
                LabelFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
                LabelFrame.BackgroundTransparency = 0.4
                LabelFrame.Size = UDim2.new(1, 0, 0, 38)
                LabelFrame.ZIndex = 3

                LabelCorner.CornerRadius = UDim.new(0, 10)
                LabelCorner.Parent = LabelFrame

                LabelStroke.Color = ConfigWindow.AccentColor
                LabelStroke.Thickness = 1.5
                LabelStroke.Transparency = 0.8
                LabelStroke.Parent = LabelFrame

                self:CreateGlassmorphism(LabelFrame)

                LabelIcon.Parent = LabelFrame
                LabelIcon.BackgroundTransparency = 1
                LabelIcon.Position = UDim2.new(0, 12, 0, 9)
                LabelIcon.Size = UDim2.new(0, 20, 0, 20)
                LabelIcon.Image = "rbxassetid://10723407389"
                LabelIcon.ImageColor3 = ConfigWindow.AccentColor
                LabelIcon.ZIndex = 4

                LabelText.Parent = LabelFrame
                LabelText.BackgroundTransparency = 1
                LabelText.Position = UDim2.new(0, 40, 0, 0)
                LabelText.Size = UDim2.new(1, -48, 1, 0)
                LabelText.Font = Enum.Font.GothamMedium
                LabelText.Text = LabelTitle
                LabelText.TextColor3 = Color3.fromRGB(230, 230, 245)
                LabelText.TextSize = 13
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                LabelText.ZIndex = 4

                return {
                    Set = function(self, val)
                        LabelText.Text = val
                    end
                }
            end

            function SectionFunc:AddParagraph(ParaTitle, ParaDesc)
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaStroke = Instance.new("UIStroke")
                local ParaGradient = Instance.new("UIGradient")
                local ParaAccent = Instance.new("Frame")
                local ParaTitleLabel = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")

                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                ParaFrame.BackgroundTransparency = 0.3
                ParaFrame.Size = UDim2.new(1, 0, 0, 0)
                ParaFrame.AutomaticSize = Enum.AutomaticSize.Y
                ParaFrame.ZIndex = 3

                ParaCorner.CornerRadius = UDim.new(0, 10)
                ParaCorner.Parent = ParaFrame

                ParaStroke.Color = Color3.fromRGB(50, 50, 70)
                ParaStroke.Thickness = 1.5
                ParaStroke.Transparency = 0.7
                ParaStroke.Parent = ParaFrame

                self:CreateGlassmorphism(ParaFrame)

                ParaGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                ParaGradient.Rotation = 90
                ParaGradient.Parent = ParaFrame

                ParaAccent.Name = "Accent"
                ParaAccent.Parent = ParaFrame
                ParaAccent.BackgroundColor3 = ConfigWindow.AccentColor
                ParaAccent.BorderSizePixel = 0
                ParaAccent.Size = UDim2.new(1, 0, 0, 3)
                ParaAccent.ZIndex = 4

                local AccentCorner = Instance.new("UICorner")
                AccentCorner.CornerRadius = UDim.new(0, 10)
                AccentCorner.Parent = ParaAccent

                ParaTitleLabel.Parent = ParaFrame
                ParaTitleLabel.BackgroundTransparency = 1
                ParaTitleLabel.Position = UDim2.new(0, 14, 0, 12)
                ParaTitleLabel.Size = UDim2.new(1, -28, 0, 20)
                ParaTitleLabel.Font = Enum.Font.GothamBold
                ParaTitleLabel.Text = ParaTitle
                ParaTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParaTitleLabel.TextSize = 14
                ParaTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ParaTitleLabel.ZIndex = 4

                ParaContent.Name = "Content"
                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 14, 0, 36)
                ParaContent.Size = UDim2.new(1, -28, 0, 0)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = ParaDesc
                ParaContent.TextColor3 = Color3.fromRGB(190, 190, 210)
                ParaContent.TextSize = 12
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextYAlignment = Enum.TextYAlignment.Top
                ParaContent.TextWrapped = true
                ParaContent.AutomaticSize = Enum.AutomaticSize.Y
                ParaContent.ZIndex = 4

                local function UpdateSize()
                    local textHeight = game:GetService("TextService"):GetTextSize(
                        ParaContent.Text,
                        ParaContent.TextSize,
                        ParaContent.Font,
                        Vector2.new(ParaContent.AbsoluteSize.X, math.huge)
                    ).Y
                    ParaContent.Size = UDim2.new(1, -24, 0, textHeight)
                end

                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                UpdateSize()

                return {
                    SetTitle = function(self, val)
                        ParaTitleLabel.Text = val
                    end,
                    SetDesc = function(self, val)
                        ParaContent.Text = val
                    end,
                    Set = function(self, val)
                        ParaContent.Text = val
                    end
                }
            end

            function SectionFunc:AddDiscord(DiscordTitle, InviteCode)
                local DiscordCard = Instance.new("Frame")
                local CardCorner = Instance.new("UICorner")
                local CardStroke = Instance.new("UIStroke")
                local CardGradient = Instance.new("UIGradient")
                local Icon = Instance.new("ImageLabel")
                local IconFrame = Instance.new("Frame")
                local IconFrameCorner = Instance.new("UICorner")
                local IconGlow = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnGlow = Instance.new("Frame")

                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
                DiscordCard.BackgroundTransparency = 0.1
                DiscordCard.Size = UDim2.new(1, 0, 0, 82)
                DiscordCard.ZIndex = 3

                CardCorner.CornerRadius = UDim.new(0, 12)
                CardCorner.Parent = DiscordCard

                CardStroke.Color = Color3.fromRGB(88, 101, 242)
                CardStroke.Thickness = 2
                CardStroke.Transparency = 0.5
                CardStroke.Parent = DiscordCard

                self:CreateGlassmorphism(DiscordCard)

                CardGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 36))
                }
                CardGradient.Rotation = 90
                CardGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0.85),
                    NumberSequenceKeypoint.new(1, 1)
                }
                CardGradient.Parent = DiscordCard

                IconFrame.Name = "IconFrame"
                IconFrame.Parent = DiscordCard
                IconFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                IconFrame.Position = UDim2.new(0, 16, 0, 16)
                IconFrame.Size = UDim2.new(0, 50, 0, 50)
                IconFrame.ZIndex = 4

                IconFrameCorner.CornerRadius = UDim.new(0, 12)
                IconFrameCorner.Parent = IconFrame

                local IconFrameStroke = Instance.new("UIStroke")
                IconFrameStroke.Color = Color3.fromRGB(255, 255, 255)
                IconFrameStroke.Thickness = 2
                IconFrameStroke.Transparency = 0.8
                IconFrameStroke.Parent = IconFrame

                Icon.Parent = IconFrame
                Icon.AnchorPoint = Vector2.new(0.5, 0.5)
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                Icon.Size = UDim2.new(0, 32, 0, 32)
                Icon.Image = "rbxassetid://123256573634"
                Icon.ZIndex = 5

                IconGlow.Parent = IconFrame
                IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                IconGlow.BackgroundTransparency = 1
                IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                IconGlow.Size = UDim2.new(1.8, 0, 1.8, 0)
                IconGlow.Image = "rbxassetid://6015897843"
                IconGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
                IconGlow.ImageTransparency = 0.7
                IconGlow.ScaleType = Enum.ScaleType.Slice
                IconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                IconGlow.ZIndex = 3

                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 78, 0, 22)
                Title.Size = UDim2.new(1, -168, 0, 20)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 15
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 4

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 78, 0, 44)
                SubTitle.Size = UDim2.new(1, -168, 0, 18)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Join our community"
                SubTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
                SubTitle.TextSize = 12
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                SubTitle.ZIndex = 4

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                JoinBtn.Position = UDim2.new(1, -82, 0, 25)
                JoinBtn.Size = UDim2.new(0, 74, 0, 34)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "Join"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 14
                JoinBtn.AutoButtonColor = false
                JoinBtn.ZIndex = 5

                BtnCorner.CornerRadius = UDim.new(0, 10)
                BtnCorner.Parent = JoinBtn

                BtnStroke.Color = Color3.fromRGB(255, 255, 255)
                BtnStroke.Thickness = 1.5
                BtnStroke.Transparency = 0.9
                BtnStroke.Parent = JoinBtn

                BtnGlow.Name = "Glow"
                BtnGlow.Parent = JoinBtn
                BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BtnGlow.BackgroundTransparency = 1
                BtnGlow.Size = UDim2.new(1, 0, 1, 0)
                BtnGlow.ZIndex = 4

                local BtnGlowCorner = Instance.new("UICorner")
                BtnGlowCorner.CornerRadius = UDim.new(0, 10)
                BtnGlowCorner.Parent = BtnGlow

                JoinBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "BackgroundColor3", Color3.fromRGB(105, 120, 255))
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 0.85)
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.7)
                end)

                JoinBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "BackgroundColor3", Color3.fromRGB(88, 101, 242))
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 1)
                    Library:TweenInstance(BtnStroke, 0.2, "Transparency", 0.9)
                end)

                JoinBtn.MouseButton1Click:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.1, "Size", UDim2.new(0, 70, 0, 30))
                    task.wait(0.1)
                    Library:TweenInstance(JoinBtn, 0.1, "Size", UDim2.new(0, 74, 0, 34))
                    
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

    -- Premium toggle button with enhanced styling
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnFrame = Instance.new("Frame")
    local BtnFrameCorner = Instance.new("UICorner")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    local BtnGlow = Instance.new("ImageLabel")
    local BtnPulse = Instance.new("ImageLabel")

    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    BtnFrame.Name = "Frame"
    BtnFrame.Parent = ToggleBtn
    BtnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    BtnFrame.Position = UDim2.new(0, 16, 0, 16)
    BtnFrame.Size = UDim2.new(0, 58, 0, 58)

    BtnFrameCorner.CornerRadius = UDim.new(0, 14)
    BtnFrameCorner.Parent = BtnFrame

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = ConfigWindow.AccentColor
    FrameStroke.Thickness = 2
    FrameStroke.Transparency = 0.6
    FrameStroke.Parent = BtnFrame

    MainBtn.Parent = BtnFrame
    MainBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBtn.Size = UDim2.new(0, 50, 0, 50)
    MainBtn.Image = "rbxassetid://101817370702077"
    MainBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = MainBtn

    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 1.5
    BtnStroke.Transparency = 0.9
    BtnStroke.Parent = MainBtn

    BtnGlow.Name = "Glow"
    BtnGlow.Parent = MainBtn
    BtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnGlow.BackgroundTransparency = 1
    BtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    BtnGlow.Size = UDim2.new(1.8, 0, 1.8, 0)
    BtnGlow.Image = "rbxassetid://6015897843"
    BtnGlow.ImageColor3 = ConfigWindow.AccentColor
    BtnGlow.ImageTransparency = 0.6
    BtnGlow.ScaleType = Enum.ScaleType.Slice
    BtnGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    BtnGlow.ZIndex = 0

    BtnPulse.Name = "Pulse"
    BtnPulse.Parent = BtnFrame
    BtnPulse.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnPulse.BackgroundTransparency = 1
    BtnPulse.Position = UDim2.new(0.5, 0, 0.5, 0)
    BtnPulse.Size = UDim2.new(1.4, 0, 1.4, 0)
    BtnPulse.Image = "rbxassetid://6015897843"
    BtnPulse.ImageColor3 = ConfigWindow.AccentColor
    BtnPulse.ImageTransparency = 0.8
    BtnPulse.ScaleType = Enum.ScaleType.Slice
    BtnPulse.SliceCenter = Rect.new(49, 49, 450, 450)
    BtnPulse.ZIndex = -1

    -- Pulsing effect
    task.spawn(function()
        while BtnPulse.Parent do
            game:GetService("TweenService"):Create(BtnPulse, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                ImageTransparency = 0.95,
                Size = UDim2.new(1.6, 0, 1.6, 0)
            }):Play()
            task.wait(2)
        end
    end)

    MainBtn.MouseEnter:Connect(function()
        self:TweenInstance(MainBtn, 0.2, "Size", UDim2.new(0, 55, 0, 55))
        self:TweenInstance(BtnGlow, 0.2, "ImageTransparency", 0.4)
        self:TweenInstance(BtnStroke, 0.2, "Transparency", 0.7)
    end)

    MainBtn.MouseLeave:Connect(function()
        self:TweenInstance(MainBtn, 0.2, "Size", UDim2.new(0, 50, 0, 50))
        self:TweenInstance(BtnGlow, 0.2, "ImageTransparency", 0.6)
        self:TweenInstance(BtnStroke, 0.2, "Transparency", 0.9)
    end)

    self:MakeDraggable(MainBtn, BtnFrame)
    
    MainBtn.MouseButton1Click:Connect(function()
        self:TweenInstance(MainBtn, 0.1, "Size", UDim2.new(0, 46, 0, 46))
        task.wait(0.1)
        self:TweenInstance(MainBtn, 0.1, "Size", UDim2.new(0, 50, 0, 50))
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
    end)

    return Tab
end

return Library
