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
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    -- Background pattern overlay
    local BackgroundPattern = Instance.new("ImageLabel")
    
    -- Animated gradient background
    local BackgroundGradient = Instance.new("UIGradient")
    
    -- Top accent bar
    local AccentBar = Instance.new("Frame")
    local AccentGradient = Instance.new("UIGradient")
    
    local Top = Instance.new("Frame")
    local TopBlur = Instance.new("Frame")
    local TopBlurGradient = Instance.new("UIGradient")
    local NameHub = Instance.new("TextLabel")
    local NameGlow = Instance.new("TextLabel")
    local LogoHub = Instance.new("ImageLabel")
    local LogoFrame = Instance.new("Frame")
    local LogoFrameCorner = Instance.new("UICorner")
    local LogoFrameStroke = Instance.new("UIStroke")
    local LogoGlow = Instance.new("ImageLabel")
    local Desc = Instance.new("TextLabel")
    local DescIcon = Instance.new("ImageLabel")
    
    local RightButtons = Instance.new("Frame")
    local UIListLayout_Buttons = Instance.new("UIListLayout")
    local Close = Instance.new("TextButton")
    local CloseCorner = Instance.new("UICorner")
    local CloseIcon = Instance.new("ImageLabel")
    local Minize = Instance.new("TextButton")
    local MinizeCorner = Instance.new("UICorner")
    local MinizeIcon = Instance.new("ImageLabel")
    
    -- Sidebar section
    local SidebarSection = Instance.new("Frame")
    local SidebarCorner = Instance.new("UICorner")
    local SidebarGradient = Instance.new("UIGradient")
    local SidebarPattern = Instance.new("ImageLabel")
    local SidebarStroke = Instance.new("UIStroke")
    
    local TabHolder = Instance.new("ScrollingFrame")
    local TabListLayout = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    
    -- Divider line between sidebar and content
    local DividerLine = Instance.new("Frame")
    local DividerGlow = Instance.new("Frame")
    local DividerGlowGradient = Instance.new("UIGradient")
    
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
    DropShadowHolder.Size = UDim2.new(0, 650, 0, 450)

    -- MASSIVE glow shadow
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 80, 1, 80)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = ConfigWindow.AccentColor
    DropShadow.ImageTransparency = 0.3
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.ZIndex = 0

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = Main

    UIStroke.Color = ConfigWindow.AccentColor
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.6
    UIStroke.Parent = Main

    -- Animated gradient background
    BackgroundGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 22)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(11, 11, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
    }
    BackgroundGradient.Rotation = 135
    BackgroundGradient.Parent = Main

    -- Background pattern
    BackgroundPattern.Name = "Pattern"
    BackgroundPattern.Parent = Main
    BackgroundPattern.BackgroundTransparency = 1
    BackgroundPattern.Size = UDim2.new(1, 0, 1, 0)
    BackgroundPattern.Image = "rbxassetid://6015897843"
    BackgroundPattern.ImageColor3 = Color3.fromRGB(255, 255, 255)
    BackgroundPattern.ImageTransparency = 0.97
    BackgroundPattern.ScaleType = Enum.ScaleType.Tile
    BackgroundPattern.TileSize = UDim2.new(0, 100, 0, 100)
    BackgroundPattern.ZIndex = 1

    -- Top accent bar (premium indicator)
    AccentBar.Name = "AccentBar"
    AccentBar.Parent = Main
    AccentBar.BackgroundColor3 = ConfigWindow.AccentColor
    AccentBar.BorderSizePixel = 0
    AccentBar.Size = UDim2.new(1, 0, 0, 4)
    AccentBar.ZIndex = 10

    AccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, ConfigWindow.AccentColor)
    }
    AccentGradient.Parent = AccentBar

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Top.BackgroundTransparency = 0
    Top.BorderSizePixel = 0
    Top.Position = UDim2.new(0, 0, 0, 4)
    Top.Size = UDim2.new(1, 0, 0, 95)
    Top.ZIndex = 2

    -- Blur effect behind top bar
    TopBlur.Name = "Blur"
    TopBlur.Parent = Top
    TopBlur.BackgroundColor3 = ConfigWindow.AccentColor
    TopBlur.BackgroundTransparency = 0.95
    TopBlur.BorderSizePixel = 0
    TopBlur.Size = UDim2.new(1, 0, 1, 0)
    TopBlur.ZIndex = 1

    TopBlurGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 22))
    }
    TopBlurGradient.Rotation = 90
    TopBlurGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 1)
    }
    TopBlurGradient.Parent = TopBlur

    -- Logo with frame
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Parent = Top
    LogoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    LogoFrame.Position = UDim2.new(0, 25, 0, 22)
    LogoFrame.Size = UDim2.new(0, 60, 0, 60)
    LogoFrame.ZIndex = 3

    LogoFrameCorner.CornerRadius = UDim.new(0, 15)
    LogoFrameCorner.Parent = LogoFrame

    LogoFrameStroke.Color = ConfigWindow.AccentColor
    LogoFrameStroke.Thickness = 2
    LogoFrameStroke.Transparency = 0.5
    LogoFrameStroke.Parent = LogoFrame

    LogoHub.Name = "Logo"
    LogoHub.Parent = LogoFrame
    LogoHub.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoHub.Size = UDim2.new(0, 40, 0, 40)
    LogoHub.Image = "rbxassetid://101817370702077"
    LogoHub.ImageColor3 = ConfigWindow.AccentColor
    LogoHub.ZIndex = 4

    -- Massive logo glow
    LogoGlow.Name = "LogoGlow"
    LogoGlow.Parent = LogoFrame
    LogoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoGlow.BackgroundTransparency = 1
    LogoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoGlow.Size = UDim2.new(2.5, 0, 2.5, 0)
    LogoGlow.Image = "rbxassetid://6015897843"
    LogoGlow.ImageColor3 = ConfigWindow.AccentColor
    LogoGlow.ImageTransparency = 0.5
    LogoGlow.ScaleType = Enum.ScaleType.Slice
    LogoGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    LogoGlow.ZIndex = 1

    -- Title with glow effect
    NameGlow.Name = "NameGlow"
    NameGlow.Parent = Top
    NameGlow.BackgroundTransparency = 1
    NameGlow.Position = UDim2.new(0, 98, 0, 28)
    NameGlow.Size = UDim2.new(0, 400, 0, 32)
    NameGlow.Font = Enum.Font.GothamBold
    NameGlow.Text = ConfigWindow.Title
    NameGlow.TextColor3 = ConfigWindow.AccentColor
    NameGlow.TextSize = 24
    NameGlow.TextXAlignment = Enum.TextXAlignment.Left
    NameGlow.TextTransparency = 0.5
    NameGlow.ZIndex = 2

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 100, 0, 30)
    NameHub.Size = UDim2.new(0, 400, 0, 32)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 24
    NameHub.TextXAlignment = Enum.TextXAlignment.Left
    NameHub.ZIndex = 3

    -- Description with icon
    DescIcon.Name = "Icon"
    DescIcon.Parent = Top
    DescIcon.BackgroundTransparency = 1
    DescIcon.Position = UDim2.new(0, 100, 0, 62)
    DescIcon.Size = UDim2.new(0, 16, 0, 16)
    DescIcon.Image = "rbxassetid://11419704020"
    DescIcon.ImageColor3 = ConfigWindow.AccentColor
    DescIcon.ZIndex = 3

    Desc.Name = "Description"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 120, 0, 62)
    Desc.Size = UDim2.new(0, 350, 0, 18)
    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.ZIndex = 3

    RightButtons.Name = "Buttons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.AnchorPoint = Vector2.new(1, 0)
    RightButtons.Position = UDim2.new(1, -20, 0, 32)
    RightButtons.Size = UDim2.new(0, 100, 0, 40)
    RightButtons.ZIndex = 3

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.Padding = UDim.new(0, 10)
    UIListLayout_Buttons.SortOrder = Enum.SortOrder.LayoutOrder

    -- Minimize button redesign
    Minize.Name = "Minimize"
    Minize.Parent = RightButtons
    Minize.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Minize.BackgroundTransparency = 0
    Minize.Size = UDim2.new(0, 40, 0, 40)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = ""
    Minize.TextColor3 = Color3.fromRGB(200, 200, 220)
    Minize.TextSize = 18
    Minize.AutoButtonColor = false
    
    MinizeCorner.CornerRadius = UDim.new(0, 10)
    MinizeCorner.Parent = Minize

    MinizeIcon.Parent = Minize
    MinizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinizeIcon.BackgroundTransparency = 1
    MinizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinizeIcon.Size = UDim2.new(0, 20, 0, 20)
    MinizeIcon.Image = "rbxassetid://11422142913"
    MinizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 220)

    -- Close button redesign
    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
    Close.BackgroundTransparency = 0
    Close.Size = UDim2.new(0, 40, 0, 40)
    Close.Font = Enum.Font.GothamBold
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 20
    Close.AutoButtonColor = false
    
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = Close

    CloseIcon.Parent = Close
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size = UDim2.new(0, 20, 0, 20)
    CloseIcon.Image = "rbxassetid://11293981586"
    CloseIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

    -- Button hover effects
    local function AddButtonEffect(button, hoverColor, originalColor, icon)
        button.MouseEnter:Connect(function()
            Library:TweenInstance(button, 0.2, "BackgroundColor3", hoverColor)
            Library:TweenInstance(button, 0.2, "Size", button.Size + UDim2.new(0, 4, 0, 4))
            if icon then
                Library:TweenInstance(icon, 0.2, "ImageColor3", Color3.fromRGB(255, 255, 255))
            end
        end)
        button.MouseLeave:Connect(function()
            Library:TweenInstance(button, 0.2, "BackgroundColor3", originalColor)
            Library:TweenInstance(button, 0.2, "Size", UDim2.new(0, 40, 0, 40))
            if icon and button.Name == "Minimize" then
                Library:TweenInstance(icon, 0.2, "ImageColor3", Color3.fromRGB(200, 200, 220))
            end
        end)
    end

    AddButtonEffect(Minize, Color3.fromRGB(50, 50, 70), Color3.fromRGB(30, 30, 40), MinizeIcon)
    AddButtonEffect(Close, Color3.fromRGB(255, 70, 90), Color3.fromRGB(220, 50, 70), CloseIcon)

    -- SIDEBAR SECTION WITH PREMIUM DESIGN
    SidebarSection.Name = "Sidebar"
    SidebarSection.Parent = Main
    SidebarSection.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    SidebarSection.BorderSizePixel = 0
    SidebarSection.Position = UDim2.new(0, 0, 0, 99)
    SidebarSection.Size = UDim2.new(0, 180, 1, -99)
    SidebarSection.ZIndex = 2

    SidebarCorner.CornerRadius = UDim.new(0, 0)
    SidebarCorner.Parent = SidebarSection

    SidebarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 16, 24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
    }
    SidebarGradient.Rotation = 90
    SidebarGradient.Parent = SidebarSection

    SidebarPattern.Name = "Pattern"
    SidebarPattern.Parent = SidebarSection
    SidebarPattern.BackgroundTransparency = 1
    SidebarPattern.Size = UDim2.new(1, 0, 1, 0)
    SidebarPattern.Image = "rbxassetid://6015897843"
    SidebarPattern.ImageColor3 = ConfigWindow.AccentColor
    SidebarPattern.ImageTransparency = 0.96
    SidebarPattern.ScaleType = Enum.ScaleType.Tile
    SidebarPattern.TileSize = UDim2.new(0, 50, 0, 50)
    SidebarPattern.ZIndex = 2

    SidebarStroke.Color = Color3.fromRGB(25, 25, 35)
    SidebarStroke.Thickness = 1
    SidebarStroke.Transparency = 0.5
    SidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SidebarStroke.Parent = SidebarSection

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = SidebarSection
    TabHolder.Active = true
    TabHolder.BackgroundTransparency = 1
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 0)
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.ScrollBarThickness = 4
    TabHolder.ScrollBarImageColor3 = ConfigWindow.AccentColor
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ZIndex = 3

    TabListLayout.Parent = TabHolder
    TabListLayout.Padding = UDim.new(0, 8)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 15)
    TabPadding.PaddingBottom = UDim.new(0, 15)

    -- Divider line with glow
    DividerLine.Name = "Divider"
    DividerLine.Parent = Main
    DividerLine.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    DividerLine.BorderSizePixel = 0
    DividerLine.Position = UDim2.new(0, 180, 0, 99)
    DividerLine.Size = UDim2.new(0, 1, 1, -99)
    DividerLine.ZIndex = 5

    DividerGlow.Name = "Glow"
    DividerGlow.Parent = DividerLine
    DividerGlow.BackgroundColor3 = ConfigWindow.AccentColor
    DividerGlow.BackgroundTransparency = 0.7
    DividerGlow.BorderSizePixel = 0
    DividerGlow.Size = UDim2.new(1, 0, 1, 0)
    DividerGlow.ZIndex = 4

    DividerGlowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }
    DividerGlowGradient.Rotation = 90
    DividerGlowGradient.Parent = DividerGlow

    ContentFrame.Name = "Content"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 195, 0, 110)
    ContentFrame.Size = UDim2.new(1, -210, 1, -125)
    ContentFrame.ZIndex = 2

    PageLayout.Parent = ContentFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.EasingDirection = Enum.EasingDirection.Out
    PageLayout.TweenTime = 0.4

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame

    self:UpdateScrolling(TabHolder, TabListLayout)

    local Minimized = false
    Minize.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local targetSize = Minimized and UDim2.new(0, 650, 0, 99) or UDim2.new(0, 650, 0, 450)
        Library:TweenInstance(DropShadowHolder, 0.4, "Size", targetSize)
        Library:TweenInstance(MinizeIcon, 0.3, "Rotation", Minimized and 180 or 0)
    end)

    Close.MouseButton1Click:Connect(function()
        Library:TweenInstance(Main, 0.4, "Size", UDim2.new(0, 0, 0, 0))
        Library:TweenInstance(DropShadow, 0.4, "ImageTransparency", 1)
        task.wait(0.4)
        TeddyUI_Premium:Destroy()
    end)

    self:MakeDraggable(Top, Main)

    local Tab = {}
    function Tab:NewTab(ConfigTab)
        ConfigTab = Library:MakeConfig({ Title = "Tab", Icon = "" }, ConfigTab or {})
        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        Page.Name = ConfigTab.Title
        Page.Parent = ContentFrame
        Page.Active = true
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 5
        Page.ScrollBarImageColor3 = ConfigWindow.AccentColor
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.ZIndex = 2

        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 12)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PagePadding.Parent = Page
        PagePadding.PaddingLeft = UDim.new(0, 5)
        PagePadding.PaddingRight = UDim.new(0, 5)
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingBottom = UDim.new(0, 10)

        Library:UpdateScrolling(Page, PageList)

        -- PREMIUM TAB BUTTON DESIGN
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabStroke = Instance.new("UIStroke")
        local TabIcon = Instance.new("ImageLabel")
        local TabIconGlow = Instance.new("ImageLabel")
        local TabTitle = Instance.new("TextLabel")
        local TabIndicator = Instance.new("Frame")
        local IndicatorCorner = Instance.new("UICorner")
        local IndicatorGlow = Instance.new("ImageLabel")
        local TabGlow = Instance.new("Frame")
        local GlowCorner = Instance.new("UICorner")
        local TabHighlight = Instance.new("Frame")
        local HighlightCorner = Instance.new("UICorner")

        TabButton.Name = ConfigTab.Title
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
        TabButton.BackgroundTransparency = 0.3
        TabButton.Size = UDim2.new(1, 0, 0, 50)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 210)
        TabButton.TextSize = 14
        TabButton.ZIndex = 4

        TabCorner.CornerRadius = UDim.new(0, 12)
        TabCorner.Parent = TabButton

        TabStroke.Color = Color3.fromRGB(35, 35, 50)
        TabStroke.Thickness = 1.5
        TabStroke.Transparency = 0.7
        TabStroke.Parent = TabButton

        -- Glow background for active state
        TabGlow.Name = "Glow"
        TabGlow.Parent = TabButton
        TabGlow.BackgroundColor3 = ConfigWindow.AccentColor
        TabGlow.BackgroundTransparency = 1
        TabGlow.Size = UDim2.new(1, 0, 1, 0)
        TabGlow.ZIndex = 3
        
        GlowCorner.CornerRadius = UDim.new(0, 12)
        GlowCorner.Parent = TabGlow

        -- Highlight bar on top
        TabHighlight.Name = "Highlight"
        TabHighlight.Parent = TabButton
        TabHighlight.BackgroundColor3 = ConfigWindow.AccentColor
        TabHighlight.BackgroundTransparency = 1
        TabHighlight.Size = UDim2.new(1, 0, 0, 3)
        TabHighlight.ZIndex = 5

        HighlightCorner.CornerRadius = UDim.new(0, 12)
        HighlightCorner.Parent = TabHighlight

        -- Icon with glow
        TabIconGlow.Name = "IconGlow"
        TabIconGlow.Parent = TabButton
        TabIconGlow.BackgroundTransparency = 1
        TabIconGlow.Position = UDim2.new(0, 10, 0.5, -15)
        TabIconGlow.Size = UDim2.new(0, 35, 0, 35)
        TabIconGlow.Image = "rbxassetid://6015897843"
        TabIconGlow.ImageColor3 = ConfigWindow.AccentColor
        TabIconGlow.ImageTransparency = 1
        TabIconGlow.ScaleType = Enum.ScaleType.Slice
        TabIconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
        TabIconGlow.ZIndex = 3

        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 15, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Image = ConfigTab.Icon ~= "" and ConfigTab.Icon or "rbxassetid://10734950309"
        TabIcon.ImageColor3 = Color3.fromRGB(140, 140, 160)
        TabIcon.ZIndex = 5

        TabTitle.Name = "Title"
        TabTitle.Parent = TabButton
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 48, 0, 0)
        TabTitle.Size = UDim2.new(1, -55, 1, 0)
        TabTitle.Font = Enum.Font.GothamBold
        TabTitle.Text = ConfigTab.Title
        TabTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
        TabTitle.TextSize = 13
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.ZIndex = 5

        -- Side indicator with glow
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabButton
        TabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.Position = UDim2.new(0, -2, 0.5, 0)
        TabIndicator.Size = UDim2.new(0, 0, 0, 30)
        TabIndicator.ZIndex = 6
        
        IndicatorCorner.CornerRadius = UDim.new(0, 3)
        IndicatorCorner.Parent = TabIndicator

        IndicatorGlow.Name = "Glow"
        IndicatorGlow.Parent = TabIndicator
        IndicatorGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        IndicatorGlow.BackgroundTransparency = 1
        IndicatorGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        IndicatorGlow.Size = UDim2.new(3, 0, 1.5, 0)
        IndicatorGlow.Image = "rbxassetid://6015897843"
        IndicatorGlow.ImageColor3 = ConfigWindow.AccentColor
        IndicatorGlow.ImageTransparency = 0.5
        IndicatorGlow.ScaleType = Enum.ScaleType.Slice
        IndicatorGlow.SliceCenter = Rect.new(49, 49, 450, 450)
        IndicatorGlow.ZIndex = 5

        local FirstTab = #TabHolder:GetChildren() == 3

        local function SelectTab()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    local isSelected = v == TabButton
                    Library:TweenInstance(v, 0.3, "BackgroundColor3", isSelected and Color3.fromRGB(25, 25, 38) or Color3.fromRGB(18, 18, 26))
                    Library:TweenInstance(v, 0.3, "BackgroundTransparency", isSelected and 0 or 0.3)
                    
                    local stroke = v:FindFirstChild("UIStroke")
                    if stroke then
                        Library:TweenInstance(stroke, 0.3, "Color", isSelected and ConfigWindow.AccentColor or Color3.fromRGB(35, 35, 50))
                        Library:TweenInstance(stroke, 0.3, "Transparency", isSelected and 0.3 or 0.7)
                    end
                    
                    local glow = v:FindFirstChild("Glow")
                    if glow then
                        Library:TweenInstance(glow, 0.3, "BackgroundTransparency", isSelected and 0.85 or 1)
                    end

                    local highlight = v:FindFirstChild("Highlight")
                    if highlight then
                        Library:TweenInstance(highlight, 0.3, "BackgroundTransparency", isSelected and 0 or 1)
                    end
                    
                    local iconGlow = v:FindFirstChild("IconGlow")
                    if iconGlow then
                        Library:TweenInstance(iconGlow, 0.3, "ImageTransparency", isSelected and 0.5 or 1)
                    end

                    local icon = v:FindFirstChild("Icon")
                    if icon then
                        Library:TweenInstance(icon, 0.3, "ImageColor3", isSelected and ConfigWindow.AccentColor or Color3.fromRGB(140, 140, 160))
                        Library:TweenInstance(icon, 0.3, "Size", isSelected and UDim2.new(0, 26, 0, 26) or UDim2.new(0, 24, 0, 24))
                    end
                    
                    local title = v:FindFirstChild("Title")
                    if title then
                        Library:TweenInstance(title, 0.3, "TextColor3", isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 160))
                    end
                    
                    local indicator = v:FindFirstChild("Indicator")
                    if indicator then
                        Library:TweenInstance(indicator, 0.4, "Size", isSelected and UDim2.new(0, 4, 0, 30) or UDim2.new(0, 0, 0, 30))
                    end
                end
            end
            
            for _, v in pairs(ContentFrame:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = v.Name == ConfigTab.Title
                end
            end
        end

        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Enhanced hover effect
        TabButton.MouseEnter:Connect(function()
            if TabButton.BackgroundTransparency > 0.1 then
                Library:TweenInstance(TabButton, 0.2, "BackgroundTransparency", 0.1)
                Library:TweenInstance(TabButton, 0.2, "Size", UDim2.new(1, 2, 0, 50))
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabButton.BackgroundTransparency > 0.1 then
                Library:TweenInstance(TabButton, 0.2, "BackgroundTransparency", 0.3)
                Library:TweenInstance(TabButton, 0.2, "Size", UDim2.new(1, 0, 0, 50))
            end
        end)

        if FirstTab then
            Page.Visible = true
            SelectTab()
        end

        local TabFunc = {}
        function TabFunc:NewSection(ConfigSection)
            ConfigSection = Library:MakeConfig({ Title = "Section", Side = "Left" }, ConfigSection or {})
            
            -- PREMIUM SECTION DESIGN
            local SectionFrame = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionGradient = Instance.new("UIGradient")
            local SectionGlow = Instance.new("ImageLabel")
            local SectionHeader = Instance.new("Frame")
            local HeaderCorner = Instance.new("UICorner")
            local SectionTitle = Instance.new("TextLabel")
            local SectionIcon = Instance.new("ImageLabel")
            local SectionDivider = Instance.new("Frame")
            local DividerGradient = Instance.new("UIGradient")
            local SectionList = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionFrame.Name = ConfigSection.Title
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
            SectionFrame.BackgroundTransparency = 0.2
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.ClipsDescendants = false
            SectionFrame.ZIndex = 2

            SectionCorner.CornerRadius = UDim.new(0, 14)
            SectionCorner.Parent = SectionFrame

            SectionStroke.Color = ConfigWindow.AccentColor
            SectionStroke.Thickness = 1.5
            SectionStroke.Transparency = 0.7
            SectionStroke.Parent = SectionFrame

            SectionGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 28)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 22))
            }
            SectionGradient.Rotation = 135
            SectionGradient.Parent = SectionFrame

            -- Section glow effect
            SectionGlow.Name = "Glow"
            SectionGlow.Parent = SectionFrame
            SectionGlow.AnchorPoint = Vector2.new(0.5, 0)
            SectionGlow.BackgroundTransparency = 1
            SectionGlow.Position = UDim2.new(0.5, 0, 0, 0)
            SectionGlow.Size = UDim2.new(1.1, 0, 0, 60)
            SectionGlow.Image = "rbxassetid://6015897843"
            SectionGlow.ImageColor3 = ConfigWindow.AccentColor
            SectionGlow.ImageTransparency = 0.9
            SectionGlow.ScaleType = Enum.ScaleType.Slice
            SectionGlow.SliceCenter = Rect.new(49, 49, 450, 450)
            SectionGlow.ZIndex = 1

            -- Header with gradient
            SectionHeader.Name = "Header"
            SectionHeader.Parent = SectionFrame
            SectionHeader.BackgroundColor3 = ConfigWindow.AccentColor
            SectionHeader.BackgroundTransparency = 0.92
            SectionHeader.BorderSizePixel = 0
            SectionHeader.Size = UDim2.new(1, 0, 0, 45)
            SectionHeader.ZIndex = 3

            HeaderCorner.CornerRadius = UDim.new(0, 14)
            HeaderCorner.Parent = SectionHeader

            SectionIcon.Name = "Icon"
            SectionIcon.Parent = SectionHeader
            SectionIcon.BackgroundTransparency = 1
            SectionIcon.Position = UDim2.new(0, 18, 0.5, -10)
            SectionIcon.Size = UDim2.new(0, 20, 0, 20)
            SectionIcon.Image = "rbxassetid://11419703997"
            SectionIcon.ImageColor3 = ConfigWindow.AccentColor
            SectionIcon.ZIndex = 4

            SectionTitle.Name = "Title"
            SectionTitle.Parent = SectionHeader
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 45, 0, 0)
            SectionTitle.Size = UDim2.new(1, -50, 1, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = ConfigSection.Title
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 15
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.ZIndex = 4

            SectionDivider.Name = "Divider"
            SectionDivider.Parent = SectionFrame
            SectionDivider.BackgroundColor3 = ConfigWindow.AccentColor
            SectionDivider.BackgroundTransparency = 0.4
            SectionDivider.BorderSizePixel = 0
            SectionDivider.Position = UDim2.new(0, 18, 0, 45)
            SectionDivider.Size = UDim2.new(1, -36, 0, 2)
            SectionDivider.ZIndex = 3

            DividerGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, ConfigWindow.AccentColor)
            }
            DividerGradient.Parent = SectionDivider

            SectionList.Parent = SectionFrame
            SectionList.Padding = UDim.new(0, 10)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionFrame
            SectionPadding.PaddingBottom = UDim.new(0, 18)
            SectionPadding.PaddingLeft = UDim.new(0, 18)
            SectionPadding.PaddingRight = UDim.new(0, 18)
            SectionPadding.PaddingTop = UDim.new(0, 55)

            local CurrentGroup = SectionFrame
            local SectionFunc = {}

            function SectionFunc:AddButton(cfbutton)
                cfbutton = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbutton or {})
                
                local ButtonFrame = Instance.new("Frame")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonStroke = Instance.new("UIStroke")
                local ButtonGradient = Instance.new("UIGradient")
                local Button = Instance.new("TextButton")
                local ButtonTitle = Instance.new("TextLabel")
                local ButtonIcon = Instance.new("ImageLabel")
                local ButtonGlow = Instance.new("ImageLabel")
                local ButtonShine = Instance.new("Frame")
                local ShineGradient = Instance.new("UIGradient")

                ButtonFrame.Parent = CurrentGroup
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                ButtonFrame.BackgroundTransparency = 0.2
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
                ButtonFrame.ZIndex = 3

                ButtonCorner.CornerRadius = UDim.new(0, 10)
                ButtonCorner.Parent = ButtonFrame

                ButtonStroke.Color = Color3.fromRGB(45, 45, 65)
                ButtonStroke.Thickness = 1.5
                ButtonStroke.Transparency = 0.6
                ButtonStroke.Parent = ButtonFrame

                ButtonGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                ButtonGradient.Rotation = 45
                ButtonGradient.Parent = ButtonFrame

                ButtonGlow.Name = "Glow"
                ButtonGlow.Parent = ButtonFrame
                ButtonGlow.BackgroundTransparency = 1
                ButtonGlow.Size = UDim2.new(1, 0, 1, 0)
                ButtonGlow.Image = "rbxassetid://6015897843"
                ButtonGlow.ImageColor3 = ConfigWindow.AccentColor
                ButtonGlow.ImageTransparency = 1
                ButtonGlow.ScaleType = Enum.ScaleType.Slice
                ButtonGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                ButtonGlow.ZIndex = 2

                ButtonShine.Name = "Shine"
                ButtonShine.Parent = ButtonFrame
                ButtonShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonShine.BackgroundTransparency = 1
                ButtonShine.BorderSizePixel = 0
                ButtonShine.Size = UDim2.new(1, 0, 0.5, 0)
                ButtonShine.ZIndex = 4

                ShineGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.95),
                    NumberSequenceKeypoint.new(1, 1)
                }
                ShineGradient.Rotation = 90
                ShineGradient.Parent = ButtonShine

                Button.Parent = ButtonFrame
                Button.BackgroundTransparency = 1
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.Font = Enum.Font.Gotham
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.ZIndex = 5

                ButtonIcon.Parent = ButtonFrame
                ButtonIcon.BackgroundTransparency = 1
                ButtonIcon.Position = UDim2.new(0, 16, 0.5, -10)
                ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
                ButtonIcon.Image = "rbxassetid://11419720091"
                ButtonIcon.ImageColor3 = ConfigWindow.AccentColor
                ButtonIcon.ZIndex = 5

                ButtonTitle.Parent = ButtonFrame
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Position = UDim2.new(0, 44, 0, 0)
                ButtonTitle.Size = UDim2.new(1, -50, 1, 0)
                ButtonTitle.Font = Enum.Font.GothamBold
                ButtonTitle.Text = cfbutton.Title
                ButtonTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
                ButtonTitle.TextSize = 13
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
                ButtonTitle.ZIndex = 5

                Button.MouseEnter:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.3, "BackgroundColor3", Color3.fromRGB(30, 30, 42))
                    Library:TweenInstance(ButtonStroke, 0.3, "Color", ConfigWindow.AccentColor)
                    Library:TweenInstance(ButtonStroke, 0.3, "Transparency", 0.3)
                    Library:TweenInstance(ButtonGlow, 0.3, "ImageTransparency", 0.85)
                    Library:TweenInstance(ButtonShine, 0.3, "BackgroundTransparency", 0.92)
                    Library:TweenInstance(ButtonTitle, 0.3, "TextColor3", Color3.fromRGB(255, 255, 255))
                    Library:TweenInstance(ButtonIcon, 0.3, "ImageColor3", Color3.fromRGB(255, 255, 255))
                end)

                Button.MouseLeave:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.3, "BackgroundColor3", Color3.fromRGB(22, 22, 32))
                    Library:TweenInstance(ButtonStroke, 0.3, "Color", Color3.fromRGB(45, 45, 65))
                    Library:TweenInstance(ButtonStroke, 0.3, "Transparency", 0.6)
                    Library:TweenInstance(ButtonGlow, 0.3, "ImageTransparency", 1)
                    Library:TweenInstance(ButtonShine, 0.3, "BackgroundTransparency", 1)
                    Library:TweenInstance(ButtonTitle, 0.3, "TextColor3", Color3.fromRGB(220, 220, 240))
                    Library:TweenInstance(ButtonIcon, 0.3, "ImageColor3", ConfigWindow.AccentColor)
                end)

                Button.MouseButton1Down:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.1, "Size", UDim2.new(1, -4, 0, 43))
                    Library:TweenInstance(ButtonGlow, 0.1, "ImageTransparency", 0.7)
                end)

                Button.MouseButton1Up:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.1, "Size", UDim2.new(1, 0, 0, 45))
                end)

                Button.MouseButton1Click:Connect(function()
                    pcall(cfbutton.Callback)
                end)
            end

            function SectionFunc:AddToggle(cftoggle)
                cftoggle = Library:MakeConfig({ Title = "Toggle", Description = "", Default = false, Callback = function() end }, cftoggle or {})
                local Toggled = cftoggle.Default
                
                local ToggleFrame = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleStroke = Instance.new("UIStroke")
                local ToggleGradient = Instance.new("UIGradient")
                local ToggleBtn = Instance.new("TextButton")
                local ToggleIcon = Instance.new("ImageLabel")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local SwitchStroke = Instance.new("UIStroke")
                local SwitchGlow = Instance.new("ImageLabel")
                local SwitchKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local KnobInner = Instance.new("Frame")
                local KnobInnerCorner = Instance.new("UICorner")

                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                ToggleFrame.BackgroundTransparency = 0.2
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
                ToggleFrame.ZIndex = 3

                ToggleCorner.CornerRadius = UDim.new(0, 10)
                ToggleCorner.Parent = ToggleFrame

                ToggleStroke.Color = Color3.fromRGB(45, 45, 65)
                ToggleStroke.Thickness = 1.5
                ToggleStroke.Transparency = 0.6
                ToggleStroke.Parent = ToggleFrame

                ToggleGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                ToggleGradient.Rotation = 45
                ToggleGradient.Parent = ToggleFrame

                ToggleBtn.Parent = ToggleFrame
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
                ToggleBtn.Text = ""
                ToggleBtn.AutoButtonColor = false
                ToggleBtn.ZIndex = 5

                ToggleIcon.Parent = ToggleFrame
                ToggleIcon.BackgroundTransparency = 1
                ToggleIcon.Position = UDim2.new(0, 16, 0.5, -10)
                ToggleIcon.Size = UDim2.new(0, 20, 0, 20)
                ToggleIcon.Image = "rbxassetid://11419719396"
                ToggleIcon.ImageColor3 = ConfigWindow.AccentColor
                ToggleIcon.ZIndex = 5

                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 44, 0, 0)
                ToggleTitle.Size = UDim2.new(1, -120, 1, 0)
                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.Text = cftoggle.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
                ToggleTitle.TextSize = 13
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.ZIndex = 5

                ToggleSwitch.Parent = ToggleFrame
                ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                ToggleSwitch.Position = UDim2.new(1, -16, 0.5, 0)
                ToggleSwitch.Size = UDim2.new(0, 52, 0, 26)
                ToggleSwitch.ZIndex = 4

                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                SwitchStroke.Color = Color3.fromRGB(50, 50, 70)
                SwitchStroke.Thickness = 2
                SwitchStroke.Transparency = 0.5
                SwitchStroke.Parent = ToggleSwitch

                SwitchGlow.Name = "Glow"
                SwitchGlow.Parent = ToggleSwitch
                SwitchGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                SwitchGlow.BackgroundTransparency = 1
                SwitchGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                SwitchGlow.Size = UDim2.new(1.5, 0, 1.8, 0)
                SwitchGlow.Image = "rbxassetid://6015897843"
                SwitchGlow.ImageColor3 = ConfigWindow.AccentColor
                SwitchGlow.ImageTransparency = 1
                SwitchGlow.ScaleType = Enum.ScaleType.Slice
                SwitchGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                SwitchGlow.ZIndex = 3

                SwitchKnob.Parent = ToggleSwitch
                SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
                SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
                SwitchKnob.Position = UDim2.new(0, 4, 0.5, 0)
                SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
                SwitchKnob.ZIndex = 6

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SwitchKnob

                KnobInner.Parent = SwitchKnob
                KnobInner.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KnobInner.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobInner.Size = UDim2.new(0, 10, 0, 10)
                KnobInner.ZIndex = 7

                KnobInnerCorner.CornerRadius = UDim.new(1, 0)
                KnobInnerCorner.Parent = KnobInner

                local function UpdateToggle()
                    Library:TweenInstance(ToggleSwitch, 0.4, "BackgroundColor3", Toggled and ConfigWindow.AccentColor or Color3.fromRGB(30, 30, 42))
                    Library:TweenInstance(SwitchStroke, 0.4, "Color", Toggled and ConfigWindow.AccentColor or Color3.fromRGB(50, 50, 70))
                    Library:TweenInstance(SwitchStroke, 0.4, "Transparency", Toggled and 0.2 or 0.5)
                    Library:TweenInstance(SwitchGlow, 0.4, "ImageTransparency", Toggled and 0.6 or 1)
                    Library:TweenInstance(SwitchKnob, 0.4, "Position", Toggled and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0))
                    Library:TweenInstance(SwitchKnob, 0.4, "BackgroundColor3", Toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 220))
                    Library:TweenInstance(ToggleIcon, 0.3, "ImageColor3", Toggled and ConfigWindow.AccentColor or Color3.fromRGB(100, 100, 120))
                end

                UpdateToggle()

                ToggleBtn.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                    pcall(cftoggle.Callback, Toggled)
                end)

                ToggleBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(ToggleFrame, 0.2, "BackgroundColor3", Color3.fromRGB(26, 26, 38))
                    Library:TweenInstance(ToggleStroke, 0.2, "Transparency", 0.4)
                end)

                ToggleBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(ToggleFrame, 0.2, "BackgroundColor3", Color3.fromRGB(22, 22, 32))
                    Library:TweenInstance(ToggleStroke, 0.2, "Transparency", 0.6)
                end)

                return {
                    Set = function(self, val)
                        Toggled = val
                        UpdateToggle()
                        pcall(cftoggle.Callback, val)
                    end
                }
            end

            function SectionFunc:AddSlider(cfslider)
                cfslider = Library:MakeConfig({ Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslider or {})
                local SliderValue = cfslider.Default
                
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderStroke = Instance.new("UIStroke")
                local SliderGradient = Instance.new("UIGradient")
                local SliderIcon = Instance.new("ImageLabel")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValueLabel = Instance.new("TextLabel")
                local SliderValueBg = Instance.new("Frame")
                local ValueBgCorner = Instance.new("UICorner")
                local SliderTrackBg = Instance.new("Frame")
                local TrackBgCorner = Instance.new("UICorner")
                local SliderTrack = Instance.new("Frame")
                local TrackCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local FillGlow = Instance.new("ImageLabel")
                local SliderKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local KnobInner = Instance.new("Frame")
                local KnobInnerCorner = Instance.new("UICorner")
                local KnobGlow = Instance.new("ImageLabel")
                local SliderInput = Instance.new("TextButton")

                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                SliderFrame.BackgroundTransparency = 0.2
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 70)
                SliderFrame.ZIndex = 3

                SliderCorner.CornerRadius = UDim.new(0, 10)
                SliderCorner.Parent = SliderFrame

                SliderStroke.Color = Color3.fromRGB(45, 45, 65)
                SliderStroke.Thickness = 1.5
                SliderStroke.Transparency = 0.6
                SliderStroke.Parent = SliderFrame

                SliderGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                SliderGradient.Rotation = 45
                SliderGradient.Parent = SliderFrame

                SliderIcon.Parent = SliderFrame
                SliderIcon.BackgroundTransparency = 1
                SliderIcon.Position = UDim2.new(0, 16, 0, 14)
                SliderIcon.Size = UDim2.new(0, 20, 0, 20)
                SliderIcon.Image = "rbxassetid://11419721449"
                SliderIcon.ImageColor3 = ConfigWindow.AccentColor
                SliderIcon.ZIndex = 5

                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 44, 0, 12)
                SliderTitle.Size = UDim2.new(1, -140, 0, 22)
                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = cfslider.Title
                SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderTitle.ZIndex = 5

                SliderValueBg.Parent = SliderFrame
                SliderValueBg.AnchorPoint = Vector2.new(1, 0)
                SliderValueBg.BackgroundColor3 = ConfigWindow.AccentColor
                SliderValueBg.BackgroundTransparency = 0.8
                SliderValueBg.Position = UDim2.new(1, -16, 0, 12)
                SliderValueBg.Size = UDim2.new(0, 65, 0, 24)
                SliderValueBg.ZIndex = 4

                ValueBgCorner.CornerRadius = UDim.new(0, 8)
                ValueBgCorner.Parent = SliderValueBg

                SliderValueLabel.Parent = SliderValueBg
                SliderValueLabel.BackgroundTransparency = 1
                SliderValueLabel.Size = UDim2.new(1, 0, 1, 0)
                SliderValueLabel.Font = Enum.Font.GothamBold
                SliderValueLabel.Text = tostring(SliderValue)
                SliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderValueLabel.TextSize = 14
                SliderValueLabel.ZIndex = 5

                SliderTrackBg.Parent = SliderFrame
                SliderTrackBg.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                SliderTrackBg.BorderSizePixel = 0
                SliderTrackBg.Position = UDim2.new(0, 16, 1, -20)
                SliderTrackBg.Size = UDim2.new(1, -32, 0, 8)
                SliderTrackBg.ZIndex = 3

                TrackBgCorner.CornerRadius = UDim.new(1, 0)
                TrackBgCorner.Parent = SliderTrackBg

                SliderTrack.Parent = SliderTrackBg
                SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Size = UDim2.new(1, 0, 1, 0)
                SliderTrack.ZIndex = 4

                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack

                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.ZIndex = 5

                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                FillGlow.Parent = SliderFill
                FillGlow.BackgroundTransparency = 1
                FillGlow.Position = UDim2.new(0, 0, -0.5, 0)
                FillGlow.Size = UDim2.new(1, 0, 2, 0)
                FillGlow.Image = "rbxassetid://6015897843"
                FillGlow.ImageColor3 = ConfigWindow.AccentColor
                FillGlow.ImageTransparency = 0.7
                FillGlow.ScaleType = Enum.ScaleType.Slice
                FillGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                FillGlow.ZIndex = 4

                SliderKnob.Parent = SliderTrack
                SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderKnob.BackgroundColor3 = ConfigWindow.AccentColor
                SliderKnob.BorderSizePixel = 0
                SliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
                SliderKnob.Size = UDim2.new(0, 18, 0, 18)
                SliderKnob.ZIndex = 7

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SliderKnob

                KnobInner.Parent = SliderKnob
                KnobInner.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KnobInner.BorderSizePixel = 0
                KnobInner.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobInner.Size = UDim2.new(0, 8, 0, 8)
                KnobInner.ZIndex = 8

                KnobInnerCorner.CornerRadius = UDim.new(1, 0)
                KnobInnerCorner.Parent = KnobInner

                KnobGlow.Parent = SliderKnob
                KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobGlow.BackgroundTransparency = 1
                KnobGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobGlow.Size = UDim2.new(2.5, 0, 2.5, 0)
                KnobGlow.Image = "rbxassetid://6015897843"
                KnobGlow.ImageColor3 = ConfigWindow.AccentColor
                KnobGlow.ImageTransparency = 0.5
                KnobGlow.ScaleType = Enum.ScaleType.Slice
                KnobGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                KnobGlow.ZIndex = 6

                SliderInput.Parent = SliderFrame
                SliderInput.BackgroundTransparency = 1
                SliderInput.Size = UDim2.new(1, 0, 1, 0)
                SliderInput.Text = ""
                SliderInput.AutoButtonColor = false
                SliderInput.ZIndex = 8

                local Dragging = false

                local function UpdateSlider(input)
                    local Pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    SliderValue = math.floor(cfslider.Min + (cfslider.Max - cfslider.Min) * Pos)
                    SliderValueLabel.Text = tostring(SliderValue)
                    Library:TweenInstance(SliderFill, 0.15, "Size", UDim2.new(Pos, 0, 1, 0))
                    Library:TweenInstance(SliderKnob, 0.15, "Position", UDim2.new(Pos, 0, 0.5, 0))
                    pcall(cfslider.Callback, SliderValue)
                end

                SliderInput.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSlider(input)
                        Library:TweenInstance(SliderKnob, 0.2, "Size", UDim2.new(0, 22, 0, 22))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.3)
                        Library:TweenInstance(KnobInner, 0.2, "Size", UDim2.new(0, 10, 0, 10))
                    end
                end)

                SliderInput.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                        Library:TweenInstance(SliderKnob, 0.2, "Size", UDim2.new(0, 18, 0, 18))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.5)
                        Library:TweenInstance(KnobInner, 0.2, "Size", UDim2.new(0, 8, 0, 8))
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)

                local InitialPos = (SliderValue - cfslider.Min) / (cfslider.Max - cfslider.Min)
                SliderFill.Size = UDim2.new(InitialPos, 0, 1, 0)
                SliderKnob.Position = UDim2.new(InitialPos, 0, 0.5, 0)

                return {
                    Set = function(self, val)
                        SliderValue = math.clamp(val, cfslider.Min, cfslider.Max)
                        SliderValueLabel.Text = tostring(SliderValue)
                        local Pos = (SliderValue - cfslider.Min) / (cfslider.Max - cfslider.Min)
                        Library:TweenInstance(SliderFill, 0.3, "Size", UDim2.new(Pos, 0, 1, 0))
                        Library:TweenInstance(SliderKnob, 0.3, "Position", UDim2.new(Pos, 0, 0.5, 0))
                        pcall(cfslider.Callback, SliderValue)
                    end
                }

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
                local DropIcon = Instance.new("ImageLabel")
                local DropTitle = Instance.new("TextLabel")
                local DropArrow = Instance.new("ImageLabel")
                local DropList = Instance.new("Frame")
                local DropListCorner = Instance.new("UICorner")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                DropFrame.BackgroundTransparency = 0.2
                DropFrame.BorderSizePixel = 0
                DropFrame.Size = UDim2.new(1, 0, 0, 45)
                DropFrame.ClipsDescendants = true
                DropFrame.ZIndex = 3

                DropCorner.CornerRadius = UDim.new(0, 10)
                DropCorner.Parent = DropFrame

                DropStroke.Color = Color3.fromRGB(45, 45, 65)
                DropStroke.Thickness = 1.5
                DropStroke.Transparency = 0.6
                DropStroke.Parent = DropFrame

                DropGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                DropGradient.Rotation = 45
                DropGradient.Parent = DropFrame

                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 45)
                DropBtn.Text = ""
                DropBtn.AutoButtonColor = false
                DropBtn.ZIndex = 5

                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(0, 16, 0, 12)
                DropIcon.Size = UDim2.new(0, 20, 0, 20)
                DropIcon.Image = "rbxassetid://11419708898"
                DropIcon.ImageColor3 = ConfigWindow.AccentColor
                DropIcon.ZIndex = 5

                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 44, 0, 0)
                DropTitle.Size = UDim2.new(1, -90, 0, 45)
                DropTitle.Font = Enum.Font.GothamBold
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
                DropTitle.TextSize = 13
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropTitle.ZIndex = 5

                DropArrow.Parent = DropFrame
                DropArrow.AnchorPoint = Vector2.new(1, 0.5)
                DropArrow.BackgroundTransparency = 1
                DropArrow.Position = UDim2.new(1, -20, 0, 22)
                DropArrow.Size = UDim2.new(0, 20, 0, 20)
                DropArrow.Image = "rbxassetid://11419708116"
                DropArrow.ImageColor3 = ConfigWindow.AccentColor
                DropArrow.ZIndex = 5

                DropList.Parent = DropFrame
                DropList.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                DropList.BackgroundTransparency = 0.3
                DropList.BorderSizePixel = 0
                DropList.Position = UDim2.new(0, 8, 0, 50)
                DropList.Size = UDim2.new(1, -16, 0, 0)
                DropList.ZIndex = 4

                DropListCorner.CornerRadius = UDim.new(0, 8)
                DropListCorner.Parent = DropList

                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 6)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder

                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 8)
                DropPadding.PaddingLeft = UDim.new(0, 8)
                DropPadding.PaddingRight = UDim.new(0, 8)
                DropPadding.PaddingTop = UDim.new(0, 8)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 66) or 45
                    Library:TweenInstance(DropFrame, 0.4, "Size", UDim2.new(1, 0, 0, targetSize))
                    Library:TweenInstance(DropArrow, 0.3, "Rotation", Open and 180 or 0)
                    Library:TweenInstance(DropStroke, 0.3, "Color", Open and ConfigWindow.AccentColor or Color3.fromRGB(45, 45, 65))
                    Library:TweenInstance(DropStroke, 0.3, "Transparency", Open and 0.3 or 0.6)
                end

                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                DropBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(DropFrame, 0.2, "BackgroundColor3", Color3.fromRGB(26, 26, 38))
                end)

                DropBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(DropFrame, 0.2, "BackgroundColor3", Color3.fromRGB(22, 22, 32))
                end)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        local OptStroke = Instance.new("UIStroke")
                        local OptGlow = Instance.new("Frame")
                        local OptGlowCorner = Instance.new("UICorner")
                        local OptCheck = Instance.new("ImageLabel")

                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
                        OptBtn.BackgroundTransparency = 0.4
                        OptBtn.BorderSizePixel = 0
                        OptBtn.Size = UDim2.new(1, 0, 0, 36)
                        OptBtn.Font = Enum.Font.GothamMedium
                        OptBtn.Text = "  " .. opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                        OptBtn.TextSize = 12
                        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OptBtn.AutoButtonColor = false
                        OptBtn.ZIndex = 5

                        OptCorner.CornerRadius = UDim.new(0, 8)
                        OptCorner.Parent = OptBtn

                        OptStroke.Color = Color3.fromRGB(40, 40, 55)
                        OptStroke.Thickness = 1
                        OptStroke.Transparency = 0.7
                        OptStroke.Parent = OptBtn

                        OptGlow.Name = "Glow"
                        OptGlow.Parent = OptBtn
                        OptGlow.BackgroundColor3 = ConfigWindow.AccentColor
                        OptGlow.BackgroundTransparency = 1
                        OptGlow.BorderSizePixel = 0
                        OptGlow.Size = UDim2.new(1, 0, 1, 0)
                        OptGlow.ZIndex = 4

                        OptGlowCorner.CornerRadius = UDim.new(0, 8)
                        OptGlowCorner.Parent = OptGlow

                        OptCheck.Name = "Check"
                        OptCheck.Parent = OptBtn
                        OptCheck.AnchorPoint = Vector2.new(1, 0.5)
                        OptCheck.BackgroundTransparency = 1
                        OptCheck.Position = UDim2.new(1, -8, 0.5, 0)
                        OptCheck.Size = UDim2.new(0, 18, 0, 18)
                        OptCheck.Image = "rbxassetid://11419719395"
                        OptCheck.ImageColor3 = ConfigWindow.AccentColor
                        OptCheck.ImageTransparency = 1
                        OptCheck.ZIndex = 6

                        OptBtn.MouseEnter:Connect(function()
                            Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(32, 32, 46))
                            Library:TweenInstance(OptStroke, 0.2, "Color", ConfigWindow.AccentColor)
                            Library:TweenInstance(OptStroke, 0.2, "Transparency", 0.4)
                            Library:TweenInstance(OptGlow, 0.2, "BackgroundTransparency", 0.88)
                            Library:TweenInstance(OptBtn, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
                        end)

                        OptBtn.MouseLeave:Connect(function()
                            Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(25, 25, 36))
                            Library:TweenInstance(OptStroke, 0.2, "Color", Color3.fromRGB(40, 40, 55))
                            Library:TweenInstance(OptStroke, 0.2, "Transparency", 0.7)
                            Library:TweenInstance(OptGlow, 0.2, "BackgroundTransparency", 1)
                            Library:TweenInstance(OptBtn, 0.2, "TextColor3", Color3.fromRGB(200, 200, 220))
                        end)

                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. " : " .. opt
                            Library:TweenInstance(OptCheck, 0.2, "ImageTransparency", 0)
                            task.wait(0.3)
                            Library:TweenInstance(OptCheck, 0.2, "ImageTransparency", 1)
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
                local BoxIcon = Instance.new("ImageLabel")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                local InputStroke = Instance.new("UIStroke")
                local InputGlow = Instance.new("ImageLabel")

                BoxFrame.Parent = CurrentGroup
                BoxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                BoxFrame.BackgroundTransparency = 0.2
                BoxFrame.BorderSizePixel = 0
                BoxFrame.Size = UDim2.new(1, 0, 0, 45)
                BoxFrame.ZIndex = 3

                BoxCorner.CornerRadius = UDim.new(0, 10)
                BoxCorner.Parent = BoxFrame

                BoxStroke.Color = Color3.fromRGB(45, 45, 65)
                BoxStroke.Thickness = 1.5
                BoxStroke.Transparency = 0.6
                BoxStroke.Parent = BoxFrame

                BoxGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                BoxGradient.Rotation = 45
                BoxGradient.Parent = BoxFrame

                BoxIcon.Parent = BoxFrame
                BoxIcon.BackgroundTransparency = 1
                BoxIcon.Position = UDim2.new(0, 16, 0.5, -10)
                BoxIcon.Size = UDim2.new(0, 20, 0, 20)
                BoxIcon.Image = "rbxassetid://11419715016"
                BoxIcon.ImageColor3 = ConfigWindow.AccentColor
                BoxIcon.ZIndex = 5

                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 44, 0, 0)
                BoxTitle.Size = UDim2.new(0, 140, 1, 0)
                BoxTitle.Font = Enum.Font.GothamBold
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
                BoxTitle.TextSize = 13
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left
                BoxTitle.ZIndex = 5

                BoxInput.Parent = BoxFrame
                BoxInput.AnchorPoint = Vector2.new(1, 0.5)
                BoxInput.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                BoxInput.BackgroundTransparency = 0.3
                BoxInput.BorderSizePixel = 0
                BoxInput.Position = UDim2.new(1, -16, 0.5, 0)
                BoxInput.Size = UDim2.new(0, 180, 0, 32)
                BoxInput.Font = Enum.Font.GothamMedium
                BoxInput.PlaceholderText = "Enter value..."
                BoxInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                BoxInput.TextSize = 12
                BoxInput.ClearTextOnFocus = false
                BoxInput.ZIndex = 5

                InputCorner.CornerRadius = UDim.new(0, 8)
                InputCorner.Parent = BoxInput

                InputStroke.Color = Color3.fromRGB(50, 50, 70)
                InputStroke.Thickness = 1.5
                InputStroke.Transparency = 0.6
                InputStroke.Parent = BoxInput

                InputGlow.Name = "Glow"
                InputGlow.Parent = BoxInput
                InputGlow.BackgroundTransparency = 1
                InputGlow.Size = UDim2.new(1, 0, 1, 0)
                InputGlow.Image = "rbxassetid://6015897843"
                InputGlow.ImageColor3 = ConfigWindow.AccentColor
                InputGlow.ImageTransparency = 1
                InputGlow.ScaleType = Enum.ScaleType.Slice
                InputGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                InputGlow.ZIndex = 4

                BoxInput.Focused:Connect(function()
                    Library:TweenInstance(InputStroke, 0.3, "Color", ConfigWindow.AccentColor)
                    Library:TweenInstance(InputStroke, 0.3, "Transparency", 0.2)
                    Library:TweenInstance(BoxInput, 0.3, "BackgroundTransparency", 0)
                    Library:TweenInstance(InputGlow, 0.3, "ImageTransparency", 0.8)
                    Library:TweenInstance(BoxIcon, 0.3, "ImageColor3", Color3.fromRGB(255, 255, 255))
                end)

                BoxInput.FocusLost:Connect(function()
                    Library:TweenInstance(InputStroke, 0.3, "Color", Color3.fromRGB(50, 50, 70))
                    Library:TweenInstance(InputStroke, 0.3, "Transparency", 0.6)
                    Library:TweenInstance(BoxInput, 0.3, "BackgroundTransparency", 0.3)
                    Library:TweenInstance(InputGlow, 0.3, "ImageTransparency", 1)
                    Library:TweenInstance(BoxIcon, 0.3, "ImageColor3", ConfigWindow.AccentColor)
                    pcall(cfbox.Callback, BoxInput.Text)
                end)

                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local LabelFrame = Instance.new("Frame")
                local LabelCorner = Instance.new("UICorner")
                local Label = Instance.new("TextLabel")
                local LabelIcon = Instance.new("ImageLabel")
                
                LabelFrame.Parent = CurrentGroup
                LabelFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                LabelFrame.BackgroundTransparency = 0.5
                LabelFrame.BorderSizePixel = 0
                LabelFrame.Size = UDim2.new(1, 0, 0, 32)
                LabelFrame.ZIndex = 3

                LabelCorner.CornerRadius = UDim.new(0, 8)
                LabelCorner.Parent = LabelFrame

                LabelIcon.Parent = LabelFrame
                LabelIcon.BackgroundTransparency = 1
                LabelIcon.Position = UDim2.new(0, 12, 0.5, -8)
                LabelIcon.Size = UDim2.new(0, 16, 0, 16)
                LabelIcon.Image = "rbxassetid://11419718348"
                LabelIcon.ImageColor3 = ConfigWindow.AccentColor
                LabelIcon.ImageTransparency = 0.5
                LabelIcon.ZIndex = 4

                Label.Parent = LabelFrame
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 36, 0, 0)
                Label.Size = UDim2.new(1, -40, 1, 0)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(180, 180, 200)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 4

                return {
                    Set = function(self, val)
                        Label.Text = val
                    end
                }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaStroke = Instance.new("UIStroke")
                local ParaGradient = Instance.new("UIGradient")
                local ParaIcon = Instance.new("ImageLabel")
                local ParaTitle = Instance.new("TextLabel")
                local ParaDivider = Instance.new("Frame")
                local ParaContent = Instance.new("TextLabel")

                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                ParaFrame.BackgroundTransparency = 0.2
                ParaFrame.BorderSizePixel = 0
                ParaFrame.Size = UDim2.new(1, 0, 0, 60)
                ParaFrame.ZIndex = 3

                ParaCorner.CornerRadius = UDim.new(0, 10)
                ParaCorner.Parent = ParaFrame

                ParaStroke.Color = Color3.fromRGB(45, 45, 65)
                ParaStroke.Thickness = 1.5
                ParaStroke.Transparency = 0.6
                ParaStroke.Parent = ParaFrame

                ParaGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 36)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
                }
                ParaGradient.Rotation = 45
                ParaGradient.Parent = ParaFrame

                ParaIcon.Parent = ParaFrame
                ParaIcon.BackgroundTransparency = 1
                ParaIcon.Position = UDim2.new(0, 16, 0, 14)
                ParaIcon.Size = UDim2.new(0, 20, 0, 20)
                ParaIcon.Image = "rbxassetid://11419717444"
                ParaIcon.ImageColor3 = ConfigWindow.AccentColor
                ParaIcon.ZIndex = 5

                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 44, 0, 12)
                ParaTitle.Size = UDim2.new(1, -50, 0, 20)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title
                ParaTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
                ParaTitle.TextSize = 13
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParaTitle.ZIndex = 5

                ParaDivider.Parent = ParaFrame
                ParaDivider.BackgroundColor3 = ConfigWindow.AccentColor
                ParaDivider.BackgroundTransparency = 0.7
                ParaDivider.BorderSizePixel = 0
                ParaDivider.Position = UDim2.new(0, 16, 0, 38)
                ParaDivider.Size = UDim2.new(1, -32, 0, 1)
                ParaDivider.ZIndex = 4

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 16, 0, 44)
                ParaContent.Size = UDim2.new(1, -32, 0, 20)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(160, 160, 180)
                ParaContent.TextSize = 11
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true
                ParaContent.ZIndex = 5

                local function UpdateSize()
                    local textHeight = ParaContent.TextBounds.Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 52)
                    ParaContent.Size = UDim2.new(1, -32, 0, textHeight)
                end

                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                UpdateSize()

                return {
                    SetTitle = function(self, val)
                        ParaTitle.Text = val
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
                local CardGlow = Instance.new("ImageLabel")
                local DiscordPattern = Instance.new("ImageLabel")
                local IconFrame = Instance.new("Frame")
                local IconFrameCorner = Instance.new("UICorner")
                local Icon = Instance.new("ImageLabel")
                local IconGlow = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnGlow = Instance.new("ImageLabel")
                local BtnIcon = Instance.new("ImageLabel")

                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                DiscordCard.BackgroundTransparency = 0
                DiscordCard.BorderSizePixel = 0
                DiscordCard.Size = UDim2.new(1, 0, 0, 85)
                DiscordCard.ZIndex = 3

                CardCorner.CornerRadius = UDim.new(0, 12)
                CardCorner.Parent = DiscordCard

                CardStroke.Color = Color3.fromRGB(88, 101, 242)
                CardStroke.Thickness = 2
                CardStroke.Transparency = 0.4
                CardStroke.Parent = DiscordCard

                CardGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 32))
                }
                CardGradient.Rotation = 135
                CardGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0.85),
                    NumberSequenceKeypoint.new(1, 1)
                }
                CardGradient.Parent = DiscordCard

                CardGlow.Name = "Glow"
                CardGlow.Parent = DiscordCard
                CardGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                CardGlow.BackgroundTransparency = 1
                CardGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                CardGlow.Size = UDim2.new(1.2, 0, 1.4, 0)
                CardGlow.Image = "rbxassetid://6015897843"
                CardGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
                CardGlow.ImageTransparency = 0.8
                CardGlow.ScaleType = Enum.ScaleType.Slice
                CardGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                CardGlow.ZIndex = 2

                DiscordPattern.Name = "Pattern"
                DiscordPattern.Parent = DiscordCard
                DiscordPattern.BackgroundTransparency = 1
                DiscordPattern.Size = UDim2.new(1, 0, 1, 0)
                DiscordPattern.Image = "rbxassetid://6015897843"
                DiscordPattern.ImageColor3 = Color3.fromRGB(88, 101, 242)
                DiscordPattern.ImageTransparency = 0.94
                DiscordPattern.ScaleType = Enum.ScaleType.Tile
                DiscordPattern.TileSize = UDim2.new(0, 50, 0, 50)
                DiscordPattern.ZIndex = 3

                IconFrame.Parent = DiscordCard
                IconFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                IconFrame.BackgroundTransparency = 0.2
                IconFrame.BorderSizePixel = 0
                IconFrame.Position = UDim2.new(0, 18, 0.5, -25)
                IconFrame.Size = UDim2.new(0, 50, 0, 50)
                IconFrame.ZIndex = 5

                IconFrameCorner.CornerRadius = UDim.new(0, 12)
                IconFrameCorner.Parent = IconFrame

                Icon.Parent = IconFrame
                Icon.AnchorPoint = Vector2.new(0.5, 0.5)
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                Icon.Size = UDim2.new(0, 32, 0, 32)
                Icon.Image = "rbxassetid://123256573634"
                Icon.ZIndex = 6

                IconGlow.Parent = IconFrame
                IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                IconGlow.BackgroundTransparency = 1
                IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                IconGlow.Size = UDim2.new(2, 0, 2, 0)
                IconGlow.Image = "rbxassetid://6015897843"
                IconGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
                IconGlow.ImageTransparency = 0.6
                IconGlow.ScaleType = Enum.ScaleType.Slice
                IconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                IconGlow.ZIndex = 4

                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 78, 0, 24)
                Title.Size = UDim2.new(1, -180, 0, 20)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 15
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 6

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 78, 0, 46)
                SubTitle.Size = UDim2.new(1, -180, 0, 16)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Join our community"
                SubTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
                SubTitle.TextSize = 11
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                SubTitle.ZIndex = 6

                JoinBtn.Parent = DiscordCard
                JoinBtn.AnchorPoint = Vector2.new(1, 0.5)
                JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                JoinBtn.BackgroundTransparency = 0
                JoinBtn.BorderSizePixel = 0
                JoinBtn.Position = UDim2.new(1, -18, 0.5, 0)
                JoinBtn.Size = UDim2.new(0, 80, 0, 36)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "  Join"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 13
                JoinBtn.TextXAlignment = Enum.TextXAlignment.Left
                JoinBtn.AutoButtonColor = false
                JoinBtn.ZIndex = 6

                BtnCorner.CornerRadius = UDim.new(0, 10)
                BtnCorner.Parent = JoinBtn

                BtnGlow.Name = "Glow"
                BtnGlow.Parent = JoinBtn
                BtnGlow.BackgroundTransparency = 1
                BtnGlow.Size = UDim2.new(1, 0, 1, 0)
                BtnGlow.Image = "rbxassetid://6015897843"
                BtnGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
                BtnGlow.ImageTransparency = 1
                BtnGlow.ScaleType = Enum.ScaleType.Slice
                BtnGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                BtnGlow.ZIndex = 5

                BtnIcon.Parent = JoinBtn
                BtnIcon.AnchorPoint = Vector2.new(1, 0.5)
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(1, -10, 0.5, 0)
                BtnIcon.Size = UDim2.new(0, 18, 0, 18)
                BtnIcon.Image = "rbxassetid://11419710394"
                BtnIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                BtnIcon.ZIndex = 7

                JoinBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.3, "BackgroundColor3", Color3.fromRGB(105, 120, 255))
                    Library:TweenInstance(JoinBtn, 0.3, "Size", UDim2.new(0, 85, 0, 38))
                    Library:TweenInstance(BtnGlow, 0.3, "ImageTransparency", 0.85)
                end)

                JoinBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.3, "BackgroundColor3", Color3.fromRGB(88, 101, 242))
                    Library:TweenInstance(JoinBtn, 0.3, "Size", UDim2.new(0, 80, 0, 36))
                    Library:TweenInstance(BtnGlow, 0.3, "ImageTransparency", 1)
                end)

                JoinBtn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                    JoinBtn.Text = "  Copied!"
                    task.wait(2)
                    JoinBtn.Text = "  Join"
                end)
            end

            return SectionFunc
        end

        return TabFunc
    end

    -- PREMIUM TOGGLE BUTTON
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

    BtnFrame.Parent = ToggleBtn
    BtnFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    BtnFrame.Position = UDim2.new(0, 15, 0, 15)
    BtnFrame.Size = UDim2.new(0, 60, 0, 60)

    BtnFrameCorner.CornerRadius = UDim.new(0, 16)
    BtnFrameCorner.Parent = BtnFrame

    MainBtn.Parent = BtnFrame
    MainBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBtn.Size = UDim2.new(0, 50, 0, 50)
    MainBtn.Image = "rbxassetid://101817370702077"
    MainBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

    BtnCorner.CornerRadius = UDim.new(0, 14)
    BtnCorner.Parent = MainBtn

    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.8
    BtnStroke.Parent = BtnFrame

    BtnGlow.Name = "Glow"
    BtnGlow.Parent = BtnFrame
    BtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnGlow.BackgroundTransparency = 1
    BtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    BtnGlow.Size = UDim2.new(2, 0, 2, 0)
    BtnGlow.Image = "rbxassetid://6015897843"
    BtnGlow.ImageColor3 = ConfigWindow.AccentColor
    BtnGlow.ImageTransparency = 0.5
    BtnGlow.ScaleType = Enum.ScaleType.Slice
    BtnGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    BtnGlow.ZIndex = 0

    BtnPulse.Name = "Pulse"
    BtnPulse.Parent = BtnFrame
    BtnPulse.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnPulse.BackgroundTransparency = 1
    BtnPulse.Position = UDim2.new(0.5, 0, 0.5, 0)
    BtnPulse.Size = UDim2.new(1.5, 0, 1.5, 0)
    BtnPulse.Image = "rbxassetid://6015897843"
    BtnPulse.ImageColor3 = ConfigWindow.AccentColor
    BtnPulse.ImageTransparency = 0.7
    BtnPulse.ScaleType = Enum.ScaleType.Slice
    BtnPulse.SliceCenter = Rect.new(49, 49, 450, 450)
    BtnPulse.ZIndex = 0

    MainBtn.MouseEnter:Connect(function()
        Library:TweenInstance(MainBtn, 0.3, "Size", UDim2.new(0, 54, 0, 54))
        Library:TweenInstance(BtnGlow, 0.3, "ImageTransparency", 0.3)
        Library:TweenInstance(BtnStroke, 0.3, "Transparency", 0.5)
        Library:TweenInstance(BtnPulse, 0.3, "Size", UDim2.new(2, 0, 2, 0))
        Library:TweenInstance(BtnPulse, 0.3, "ImageTransparency", 0.9)
    end)

    MainBtn.MouseLeave:Connect(function()
        Library:TweenInstance(MainBtn, 0.3, "Size", UDim2.new(0, 50, 0, 50))
        Library:TweenInstance(BtnGlow, 0.3, "ImageTransparency", 0.5)
        Library:TweenInstance(BtnStroke, 0.3, "Transparency", 0.8)
        Library:TweenInstance(BtnPulse, 0.3, "Size", UDim2.new(1.5, 0, 1.5, 0))
        Library:TweenInstance(BtnPulse, 0.3, "ImageTransparency", 0.7)
    end)

    self:MakeDraggable(MainBtn, BtnFrame)
    
    MainBtn.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
        Library:TweenInstance(MainBtn, 0.1, "Size", UDim2.new(0, 46, 0, 46))
        task.wait(0.1)
        Library:TweenInstance(MainBtn, 0.2, "Size", UDim2.new(0, 50, 0, 50))
    end)

    return Tab
end

return Library
