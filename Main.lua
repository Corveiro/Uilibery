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
    local MainGradient = Instance.new("UIGradient")
    
    -- Glow effect
    local GlowEffect = Instance.new("ImageLabel")
    
    local Top = Instance.new("Frame")
    local TopGradient = Instance.new("UIGradient")
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

    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 560, 0, 400)

    -- Enhanced shadow
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 50, 1, 50)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = ConfigWindow.AccentColor
    DropShadow.ImageTransparency = 0.7
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = Main

    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5
    UIStroke.Parent = Main

    -- Subtle gradient overlay
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
    }
    MainGradient.Rotation = 45
    MainGradient.Parent = Main

    -- Glow effect for accent
    GlowEffect.Name = "Glow"
    GlowEffect.Parent = Main
    GlowEffect.AnchorPoint = Vector2.new(0.5, 0)
    GlowEffect.BackgroundTransparency = 1
    GlowEffect.Position = UDim2.new(0.5, 0, 0, 0)
    GlowEffect.Size = UDim2.new(1.2, 0, 0.3, 0)
    GlowEffect.Image = "rbxassetid://6015897843"
    GlowEffect.ImageColor3 = ConfigWindow.AccentColor
    GlowEffect.ImageTransparency = 0.85
    GlowEffect.ScaleType = Enum.ScaleType.Slice
    GlowEffect.SliceCenter = Rect.new(49, 49, 450, 450)
    GlowEffect.ZIndex = 0

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Top.BackgroundTransparency = 0.3
    Top.Size = UDim2.new(1, 0, 0, 80)

    TopGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    }
    TopGradient.Rotation = 90
    TopGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    }
    TopGradient.Parent = Top

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 75, 0, 18)
    NameHub.Size = UDim2.new(0, 300, 0, 28)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 20
    NameHub.TextXAlignment = Enum.TextXAlignment.Left
    NameHub.TextStrokeTransparency = 0.9

    LogoHub.Name = "Logo"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 18, 0, 15)
    LogoHub.Size = UDim2.new(0, 50, 0, 50)
    LogoHub.Image = "rbxassetid://101817370702077"
    LogoHub.ImageColor3 = Color3.fromRGB(255, 255, 255)

    -- Logo glow effect
    LogoGlow.Name = "LogoGlow"
    LogoGlow.Parent = LogoHub
    LogoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoGlow.BackgroundTransparency = 1
    LogoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
    LogoGlow.Image = "rbxassetid://6015897843"
    LogoGlow.ImageColor3 = ConfigWindow.AccentColor
    LogoGlow.ImageTransparency = 0.7
    LogoGlow.ScaleType = Enum.ScaleType.Slice
    LogoGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    LogoGlow.ZIndex = 0

    Desc.Name = "Description"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 75, 0, 46)
    Desc.Size = UDim2.new(0, 300, 0, 18)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(160, 160, 170)
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "Buttons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.AnchorPoint = Vector2.new(1, 0)
    RightButtons.Position = UDim2.new(1, -15, 0, 25)
    RightButtons.Size = UDim2.new(0, 80, 0, 30)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.Padding = UDim.new(0, 8)
    UIListLayout_Buttons.SortOrder = Enum.SortOrder.LayoutOrder

    Minize.Name = "Minimize"
    Minize.Parent = RightButtons
    Minize.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Minize.BackgroundTransparency = 0.5
    Minize.Size = UDim2.new(0, 32, 0, 32)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "−"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 210)
    Minize.TextSize = 18
    Minize.AutoButtonColor = false
    
    MinizeCorner.CornerRadius = UDim.new(0, 8)
    MinizeCorner.Parent = Minize

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
    Close.BackgroundTransparency = 0.2
    Close.Size = UDim2.new(0, 32, 0, 32)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 20
    Close.AutoButtonColor = false
    
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = Close

    -- Button hover effects
    local function AddButtonEffect(button, hoverColor, originalColor)
        button.MouseEnter:Connect(function()
            Library:TweenInstance(button, 0.2, "BackgroundColor3", hoverColor)
            Library:TweenInstance(button, 0.2, "BackgroundTransparency", 0)
        end)
        button.MouseLeave:Connect(function()
            Library:TweenInstance(button, 0.2, "BackgroundColor3", originalColor)
            Library:TweenInstance(button, 0.2, "BackgroundTransparency", button.Name == "Minimize" and 0.5 or 0.2)
        end)
    end

    AddButtonEffect(Minize, Color3.fromRGB(50, 50, 65), Color3.fromRGB(35, 35, 45))
    AddButtonEffect(Close, Color3.fromRGB(255, 70, 90), Color3.fromRGB(220, 50, 70))

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.Active = true
    TabHolder.BackgroundTransparency = 1
    TabHolder.Position = UDim2.new(0, 0, 0, 85)
    TabHolder.Size = UDim2.new(0, 145, 1, -90)
    TabHolder.ScrollBarThickness = 3
    TabHolder.ScrollBarImageColor3 = ConfigWindow.AccentColor
    TabHolder.BorderSizePixel = 0
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)

    TabListLayout.Parent = TabHolder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 12)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingBottom = UDim.new(0, 8)

    ContentFrame.Name = "Content"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 155, 0, 90)
    ContentFrame.Size = UDim2.new(1, -165, 1, -100)

    PageLayout.Parent = ContentFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.EasingDirection = Enum.EasingDirection.Out
    PageLayout.TweenTime = 0.3

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame

    self:UpdateScrolling(TabHolder, TabListLayout)

    local Minimized = false
    Minize.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local targetSize = Minimized and UDim2.new(0, 560, 0, 80) or UDim2.new(0, 560, 0, 400)
        Library:TweenInstance(DropShadowHolder, 0.3, "Size", targetSize)
        Minize.Text = Minimized and "+" or "−"
    end)

    Close.MouseButton1Click:Connect(function()
        Library:TweenInstance(Main, 0.3, "Size", UDim2.new(0, 0, 0, 0))
        task.wait(0.3)
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
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = ConfigWindow.AccentColor
        Page.BorderSizePixel = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false

        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 10)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PagePadding.Parent = Page
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)

        Library:UpdateScrolling(Page, PageList)

        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabIcon = Instance.new("ImageLabel")
        local TabTitle = Instance.new("TextLabel")
        local TabIndicator = Instance.new("Frame")
        local IndicatorCorner = Instance.new("UICorner")
        local TabGlow = Instance.new("Frame")
        local GlowCorner = Instance.new("UICorner")

        TabButton.Name = ConfigTab.Title
        TabButton.Parent = TabHolder
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        TabButton.BackgroundTransparency = 0.5
        TabButton.Size = UDim2.new(1, 0, 0, 42)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 210)
        TabButton.TextSize = 14

        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton

        -- Glow background for active state
        TabGlow.Name = "Glow"
        TabGlow.Parent = TabButton
        TabGlow.BackgroundColor3 = ConfigWindow.AccentColor
        TabGlow.BackgroundTransparency = 1
        TabGlow.Size = UDim2.new(1, 0, 1, 0)
        TabGlow.ZIndex = 0
        
        GlowCorner.CornerRadius = UDim.new(0, 10)
        GlowCorner.Parent = TabGlow

        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 12, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = ConfigTab.Icon ~= "" and ConfigTab.Icon or "rbxassetid://10734950309"
        TabIcon.ImageColor3 = Color3.fromRGB(160, 160, 170)

        TabTitle.Name = "Title"
        TabTitle.Parent = TabButton
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 40, 0, 0)
        TabTitle.Size = UDim2.new(1, -50, 1, 0)
        TabTitle.Font = Enum.Font.GothamMedium
        TabTitle.Text = ConfigTab.Title
        TabTitle.TextColor3 = Color3.fromRGB(160, 160, 170)
        TabTitle.TextSize = 13
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left

        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabButton
        TabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        TabIndicator.Size = UDim2.new(0, 0, 0, 24)
        
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = TabIndicator

        local FirstTab = #TabHolder:GetChildren() == 2

        local function SelectTab()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    local isSelected = v == TabButton
                    Library:TweenInstance(v, 0.2, "BackgroundColor3", isSelected and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(25, 25, 32))
                    Library:TweenInstance(v, 0.2, "BackgroundTransparency", isSelected and 0 or 0.5)
                    
                    local glow = v:FindFirstChild("Glow")
                    if glow then
                        Library:TweenInstance(glow, 0.2, "BackgroundTransparency", isSelected and 0.9 or 1)
                    end
                    
                    local icon = v:FindFirstChild("Icon")
                    if icon then
                        Library:TweenInstance(icon, 0.2, "ImageColor3", isSelected and ConfigWindow.AccentColor or Color3.fromRGB(160, 160, 170))
                    end
                    
                    local title = v:FindFirstChild("Title")
                    if title then
                        Library:TweenInstance(title, 0.2, "TextColor3", isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170))
                    end
                    
                    local indicator = v:FindFirstChild("Indicator")
                    if indicator then
                        Library:TweenInstance(indicator, 0.3, "Size", isSelected and UDim2.new(0, 3, 0, 24) or UDim2.new(0, 0, 0, 24))
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
        
        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if TabButton.BackgroundTransparency > 0.1 then
                Library:TweenInstance(TabButton, 0.2, "BackgroundTransparency", 0.3)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabButton.BackgroundTransparency > 0.1 then
                Library:TweenInstance(TabButton, 0.2, "BackgroundTransparency", 0.5)
            end
        end)

        if FirstTab then
            Page.Visible = true
            SelectTab()
        end

        local TabFunc = {}
        function TabFunc:NewSection(ConfigSection)
            ConfigSection = Library:MakeConfig({ Title = "Section", Side = "Left" }, ConfigSection or {})
            local SectionFrame = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionTitle = Instance.new("TextLabel")
            local SectionDivider = Instance.new("Frame")
            local SectionList = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionFrame.Name = ConfigSection.Title
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            SectionFrame.BackgroundTransparency = 0.4
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            SectionCorner.CornerRadius = UDim.new(0, 12)
            SectionCorner.Parent = SectionFrame

            SectionStroke.Color = Color3.fromRGB(40, 40, 50)
            SectionStroke.Thickness = 1
            SectionStroke.Transparency = 0.6
            SectionStroke.Parent = SectionFrame

            SectionTitle.Name = "Title"
            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 12)
            SectionTitle.Size = UDim2.new(1, -30, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = ConfigSection.Title
            SectionTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionDivider.Name = "Divider"
            SectionDivider.Parent = SectionFrame
            SectionDivider.BackgroundColor3 = ConfigWindow.AccentColor
            SectionDivider.BackgroundTransparency = 0.6
            SectionDivider.Position = UDim2.new(0, 15, 0, 38)
            SectionDivider.Size = UDim2.new(1, -30, 0, 1)

            SectionList.Parent = SectionFrame
            SectionList.Padding = UDim.new(0, 8)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionFrame
            SectionPadding.PaddingBottom = UDim.new(0, 12)
            SectionPadding.PaddingLeft = UDim.new(0, 15)
            SectionPadding.PaddingRight = UDim.new(0, 15)
            SectionPadding.PaddingTop = UDim.new(0, 45)

            local CurrentGroup = SectionFrame
            local SectionFunc = {}

            function SectionFunc:AddButton(cfbutton)
                cfbutton = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbutton or {})
                local ButtonFrame = Instance.new("Frame")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonStroke = Instance.new("UIStroke")
                local Button = Instance.new("TextButton")
                local ButtonTitle = Instance.new("TextLabel")
                local ButtonGlow = Instance.new("Frame")
                local GlowCorner = Instance.new("UICorner")

                ButtonFrame.Parent = CurrentGroup
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                ButtonFrame.BackgroundTransparency = 0.3
                ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
                ButtonFrame.ClipsDescendants = true

                ButtonCorner.CornerRadius = UDim.new(0, 9)
                ButtonCorner.Parent = ButtonFrame

                ButtonStroke.Color = Color3.fromRGB(50, 50, 65)
                ButtonStroke.Thickness = 1
                ButtonStroke.Transparency = 0.7
                ButtonStroke.Parent = ButtonFrame

                ButtonGlow.Name = "Glow"
                ButtonGlow.Parent = ButtonFrame
                ButtonGlow.BackgroundColor3 = ConfigWindow.AccentColor
                ButtonGlow.BackgroundTransparency = 1
                ButtonGlow.Size = UDim2.new(1, 0, 1, 0)
                ButtonGlow.ZIndex = 0
                
                GlowCorner.CornerRadius = UDim.new(0, 9)
                GlowCorner.Parent = ButtonGlow

                Button.Parent = ButtonFrame
                Button.BackgroundTransparency = 1
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.Font = Enum.Font.Gotham
                Button.Text = ""
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 14
                Button.AutoButtonColor = false

                ButtonTitle.Parent = ButtonFrame
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Position = UDim2.new(0, 14, 0, 0)
                ButtonTitle.Size = UDim2.new(1, -28, 1, 0)
                ButtonTitle.Font = Enum.Font.GothamMedium
                ButtonTitle.Text = cfbutton.Title
                ButtonTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                ButtonTitle.TextSize = 13
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

                Button.MouseEnter:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 45))
                    Library:TweenInstance(ButtonGlow, 0.2, "BackgroundTransparency", 0.92)
                    Library:TweenInstance(ButtonTitle, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
                end)

                Button.MouseLeave:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(28, 28, 36))
                    Library:TweenInstance(ButtonGlow, 0.2, "BackgroundTransparency", 1)
                    Library:TweenInstance(ButtonTitle, 0.2, "TextColor3", Color3.fromRGB(220, 220, 230))
                end)

                Button.MouseButton1Down:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.1, "BackgroundColor3", ConfigWindow.AccentColor)
                    Library:TweenInstance(ButtonTitle, 0.1, "TextColor3", Color3.fromRGB(255, 255, 255))
                end)

                Button.MouseButton1Up:Connect(function()
                    Library:TweenInstance(ButtonFrame, 0.1, "BackgroundColor3", Color3.fromRGB(35, 35, 45))
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
                local ToggleBtn = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local SwitchKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")

                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                ToggleFrame.BackgroundTransparency = 0.3
                ToggleFrame.Size = UDim2.new(1, 0, 0, 38)

                ToggleCorner.CornerRadius = UDim.new(0, 9)
                ToggleCorner.Parent = ToggleFrame

                ToggleStroke.Color = Color3.fromRGB(50, 50, 65)
                ToggleStroke.Thickness = 1
                ToggleStroke.Transparency = 0.7
                ToggleStroke.Parent = ToggleFrame

                ToggleBtn.Parent = ToggleFrame
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
                ToggleBtn.Text = ""
                ToggleBtn.AutoButtonColor = false

                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 14, 0, 0)
                ToggleTitle.Size = UDim2.new(1, -70, 1, 0)
                ToggleTitle.Font = Enum.Font.GothamMedium
                ToggleTitle.Text = cftoggle.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                ToggleTitle.TextSize = 13
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                ToggleSwitch.Parent = ToggleFrame
                ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                ToggleSwitch.Position = UDim2.new(1, -12, 0.5, 0)
                ToggleSwitch.Size = UDim2.new(0, 44, 0, 22)

                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                SwitchKnob.Parent = ToggleSwitch
                SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
                SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
                SwitchKnob.Position = UDim2.new(0, 3, 0.5, 0)
                SwitchKnob.Size = UDim2.new(0, 16, 0, 16)

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SwitchKnob

                local function UpdateToggle()
                    Library:TweenInstance(ToggleSwitch, 0.3, "BackgroundColor3", Toggled and ConfigWindow.AccentColor or Color3.fromRGB(40, 40, 50))
                    Library:TweenInstance(SwitchKnob, 0.3, "Position", Toggled and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0))
                    Library:TweenInstance(SwitchKnob, 0.3, "BackgroundColor3", Toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210))
                end

                UpdateToggle()

                ToggleBtn.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                    pcall(cftoggle.Callback, Toggled)
                end)

                ToggleBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(ToggleFrame, 0.2, "BackgroundColor3", Color3.fromRGB(32, 32, 40))
                end)

                ToggleBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(ToggleFrame, 0.2, "BackgroundColor3", Color3.fromRGB(28, 28, 36))
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
                local SliderTitle = Instance.new("TextLabel")
                local SliderValueLabel = Instance.new("TextLabel")
                local SliderTrack = Instance.new("Frame")
                local TrackCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local KnobGlow = Instance.new("ImageLabel")
                local SliderInput = Instance.new("TextButton")

                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                SliderFrame.BackgroundTransparency = 0.3
                SliderFrame.Size = UDim2.new(1, 0, 0, 58)

                SliderCorner.CornerRadius = UDim.new(0, 9)
                SliderCorner.Parent = SliderFrame

                SliderStroke.Color = Color3.fromRGB(50, 50, 65)
                SliderStroke.Thickness = 1
                SliderStroke.Transparency = 0.7
                SliderStroke.Parent = SliderFrame

                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 14, 0, 8)
                SliderTitle.Size = UDim2.new(1, -80, 0, 18)
                SliderTitle.Font = Enum.Font.GothamMedium
                SliderTitle.Text = cfslider.Title
                SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValueLabel.Parent = SliderFrame
                SliderValueLabel.BackgroundTransparency = 1
                SliderValueLabel.AnchorPoint = Vector2.new(1, 0)
                SliderValueLabel.Position = UDim2.new(1, -14, 0, 8)
                SliderValueLabel.Size = UDim2.new(0, 60, 0, 18)
                SliderValueLabel.Font = Enum.Font.GothamBold
                SliderValueLabel.Text = tostring(SliderValue)
                SliderValueLabel.TextColor3 = ConfigWindow.AccentColor
                SliderValueLabel.TextSize = 13
                SliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right

                SliderTrack.Parent = SliderFrame
                SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                SliderTrack.Position = UDim2.new(0, 14, 1, -22)
                SliderTrack.Size = UDim2.new(1, -28, 0, 6)

                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack

                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new(0, 0, 1, 0)

                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                SliderKnob.Parent = SliderTrack
                SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
                SliderKnob.Size = UDim2.new(0, 14, 0, 14)

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SliderKnob

                KnobGlow.Parent = SliderKnob
                KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                KnobGlow.BackgroundTransparency = 1
                KnobGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                KnobGlow.Size = UDim2.new(2, 0, 2, 0)
                KnobGlow.Image = "rbxassetid://6015897843"
                KnobGlow.ImageColor3 = ConfigWindow.AccentColor
                KnobGlow.ImageTransparency = 0.7
                KnobGlow.ScaleType = Enum.ScaleType.Slice
                KnobGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                KnobGlow.ZIndex = 0

                SliderInput.Parent = SliderFrame
                SliderInput.BackgroundTransparency = 1
                SliderInput.Size = UDim2.new(1, 0, 1, 0)
                SliderInput.Text = ""
                SliderInput.AutoButtonColor = false

                local Dragging = false

                local function UpdateSlider(input)
                    local Pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    SliderValue = math.floor(cfslider.Min + (cfslider.Max - cfslider.Min) * Pos)
                    SliderValueLabel.Text = tostring(SliderValue)
                    Library:TweenInstance(SliderFill, 0.1, "Size", UDim2.new(Pos, 0, 1, 0))
                    Library:TweenInstance(SliderKnob, 0.1, "Position", UDim2.new(Pos, 0, 0.5, 0))
                    pcall(cfslider.Callback, SliderValue)
                end

                SliderInput.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSlider(input)
                        Library:TweenInstance(SliderKnob, 0.2, "Size", UDim2.new(0, 18, 0, 18))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.4)
                    end
                end)

                SliderInput.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                        Library:TweenInstance(SliderKnob, 0.2, "Size", UDim2.new(0, 14, 0, 14))
                        Library:TweenInstance(KnobGlow, 0.2, "ImageTransparency", 0.7)
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
                        Library:TweenInstance(SliderFill, 0.2, "Size", UDim2.new(Pos, 0, 1, 0))
                        Library:TweenInstance(SliderKnob, 0.2, "Position", UDim2.new(Pos, 0, 0.5, 0))
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
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("TextLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                DropFrame.BackgroundTransparency = 0.3
                DropFrame.Size = UDim2.new(1, 0, 0, 40)
                DropFrame.ClipsDescendants = true

                DropCorner.CornerRadius = UDim.new(0, 9)
                DropCorner.Parent = DropFrame

                DropStroke.Color = Color3.fromRGB(50, 50, 65)
                DropStroke.Thickness = 1
                DropStroke.Transparency = 0.7
                DropStroke.Parent = DropFrame

                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 40)
                DropBtn.Text = ""
                DropBtn.AutoButtonColor = false

                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 14, 0, 0)
                DropTitle.Size = UDim2.new(1, -45, 0, 40)
                DropTitle.Font = Enum.Font.GothamMedium
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                DropTitle.TextSize = 13
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left

                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -35, 0, 0)
                DropIcon.Size = UDim2.new(0, 35, 0, 40)
                DropIcon.Font = Enum.Font.GothamBold
                DropIcon.Text = "+"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 18

                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 40)
                DropList.Size = UDim2.new(1, 0, 0, 0)

                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 6)
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
                    Library:TweenInstance(DropIcon, 0.3, "Rotation", Open and 45 or 0)
                    DropIcon.Text = Open and "×" or "+"
                end

                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                DropBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(DropFrame, 0.2, "BackgroundColor3", Color3.fromRGB(32, 32, 40))
                end)

                DropBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(DropFrame, 0.2, "BackgroundColor3", Color3.fromRGB(28, 28, 36))
                end)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        local OptGlow = Instance.new("Frame")
                        local GlowCorner = Instance.new("UICorner")

                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                        OptBtn.BackgroundTransparency = 0.4
                        OptBtn.Size = UDim2.new(1, 0, 0, 32)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
                        OptBtn.TextSize = 12
                        OptBtn.AutoButtonColor = false

                        OptCorner.CornerRadius = UDim.new(0, 7)
                        OptCorner.Parent = OptBtn

                        OptGlow.Name = "Glow"
                        OptGlow.Parent = OptBtn
                        OptGlow.BackgroundColor3 = ConfigWindow.AccentColor
                        OptGlow.BackgroundTransparency = 1
                        OptGlow.Size = UDim2.new(1, 0, 1, 0)
                        OptGlow.ZIndex = 0

                        GlowCorner.CornerRadius = UDim.new(0, 7)
                        GlowCorner.Parent = OptGlow

                        OptBtn.MouseEnter:Connect(function()
                            Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(40, 40, 52))
                            Library:TweenInstance(OptGlow, 0.2, "BackgroundTransparency", 0.92)
                            Library:TweenInstance(OptBtn, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
                        end)

                        OptBtn.MouseLeave:Connect(function()
                            Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 45))
                            Library:TweenInstance(OptGlow, 0.2, "BackgroundTransparency", 1)
                            Library:TweenInstance(OptBtn, 0.2, "TextColor3", Color3.fromRGB(200, 200, 210))
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
                BoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                BoxFrame.BackgroundTransparency = 0.3
                BoxFrame.Size = UDim2.new(1, 0, 0, 40)

                BoxCorner.CornerRadius = UDim.new(0, 9)
                BoxCorner.Parent = BoxFrame

                BoxStroke.Color = Color3.fromRGB(50, 50, 65)
                BoxStroke.Thickness = 1
                BoxStroke.Transparency = 0.7
                BoxStroke.Parent = BoxFrame

                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 14, 0, 0)
                BoxTitle.Size = UDim2.new(0, 120, 1, 0)
                BoxTitle.Font = Enum.Font.GothamMedium
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                BoxTitle.TextSize = 13
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                BoxInput.BackgroundTransparency = 0.5
                BoxInput.Position = UDim2.new(1, -170, 0.5, -14)
                BoxInput.Size = UDim2.new(0, 160, 0, 28)
                BoxInput.Font = Enum.Font.Gotham
                BoxInput.PlaceholderText = "Enter value..."
                BoxInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = Color3.fromRGB(240, 240, 250)
                BoxInput.TextSize = 12
                BoxInput.ClearTextOnFocus = false

                InputCorner.CornerRadius = UDim.new(0, 7)
                InputCorner.Parent = BoxInput

                InputStroke.Color = Color3.fromRGB(60, 60, 75)
                InputStroke.Thickness = 1
                InputStroke.Transparency = 0.6
                InputStroke.Parent = BoxInput

                BoxInput.Focused:Connect(function()
                    Library:TweenInstance(InputStroke, 0.2, "Color", ConfigWindow.AccentColor)
                    Library:TweenInstance(InputStroke, 0.2, "Transparency", 0)
                    Library:TweenInstance(BoxInput, 0.2, "BackgroundTransparency", 0.2)
                end)

                BoxInput.FocusLost:Connect(function()
                    Library:TweenInstance(InputStroke, 0.2, "Color", Color3.fromRGB(60, 60, 75))
                    Library:TweenInstance(InputStroke, 0.2, "Transparency", 0.6)
                    Library:TweenInstance(BoxInput, 0.2, "BackgroundTransparency", 0.5)
                    pcall(cfbox.Callback, BoxInput.Text)
                end)

                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 25)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(170, 170, 180)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left

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
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")

                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                ParaFrame.BackgroundTransparency = 0.3
                ParaFrame.Size = UDim2.new(1, 0, 0, 55)

                ParaCorner.CornerRadius = UDim.new(0, 9)
                ParaCorner.Parent = ParaFrame

                ParaStroke.Color = Color3.fromRGB(50, 50, 65)
                ParaStroke.Thickness = 1
                ParaStroke.Transparency = 0.7
                ParaStroke.Parent = ParaFrame

                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 12, 0, 10)
                ParaTitle.Size = UDim2.new(1, -24, 0, 16)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title
                ParaTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
                ParaTitle.TextSize = 13
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 12, 0, 30)
                ParaContent.Size = UDim2.new(1, -24, 0, 18)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(150, 150, 160)
                ParaContent.TextSize = 11
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true

                local function UpdateSize()
                    local textHeight = ParaContent.TextBounds.Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 40)
                    ParaContent.Size = UDim2.new(1, -24, 0, textHeight)
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
                local Icon = Instance.new("ImageLabel")
                local IconGlow = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnGlow = Instance.new("Frame")
                local BtnGlowCorner = Instance.new("UICorner")

                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                DiscordCard.BackgroundTransparency = 0.2
                DiscordCard.Size = UDim2.new(1, 0, 0, 75)

                CardCorner.CornerRadius = UDim.new(0, 10)
                CardCorner.Parent = DiscordCard

                CardStroke.Color = Color3.fromRGB(88, 101, 242)
                CardStroke.Thickness = 1.5
                CardStroke.Transparency = 0.6
                CardStroke.Parent = DiscordCard

                CardGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 36))
                }
                CardGradient.Rotation = 90
                CardGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0.9),
                    NumberSequenceKeypoint.new(1, 1)
                }
                CardGradient.Parent = DiscordCard

                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 14, 0, 15)
                Icon.Size = UDim2.new(0, 45, 0, 45)
                Icon.Image = "rbxassetid://123256573634"

                IconGlow.Parent = Icon
                IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                IconGlow.BackgroundTransparency = 1
                IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                IconGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
                IconGlow.Image = "rbxassetid://6015897843"
                IconGlow.ImageColor3 = Color3.fromRGB(88, 101, 242)
                IconGlow.ImageTransparency = 0.75
                IconGlow.ScaleType = Enum.ScaleType.Slice
                IconGlow.SliceCenter = Rect.new(49, 49, 450, 450)
                IconGlow.ZIndex = 0

                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 70, 0, 20)
                Title.Size = UDim2.new(1, -155, 0, 18)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 14
                Title.TextXAlignment = Enum.TextXAlignment.Left

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 70, 0, 40)
                SubTitle.Size = UDim2.new(1, -155, 0, 16)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Click to join our community"
                SubTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
                SubTitle.TextSize = 11
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                JoinBtn.Position = UDim2.new(1, -78, 0, 22)
                JoinBtn.Size = UDim2.new(0, 70, 0, 32)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "Join"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 13
                JoinBtn.AutoButtonColor = false

                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = JoinBtn

                BtnGlow.Name = "Glow"
                BtnGlow.Parent = JoinBtn
                BtnGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BtnGlow.BackgroundTransparency = 1
                BtnGlow.Size = UDim2.new(1, 0, 1, 0)
                BtnGlow.ZIndex = 2

                BtnGlowCorner.CornerRadius = UDim.new(0, 8)
                BtnGlowCorner.Parent = BtnGlow

                JoinBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "BackgroundColor3", Color3.fromRGB(105, 120, 255))
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 0.9)
                end)

                JoinBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "BackgroundColor3", Color3.fromRGB(88, 101, 242))
                    Library:TweenInstance(BtnGlow, 0.2, "BackgroundTransparency", 1)
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

    -- Toggle button with improved design
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
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

    BtnStroke.Color = Color3.fromRGB(35, 35, 45)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.3
    BtnStroke.Parent = MainBtn

    BtnGlow.Name = "Glow"
    BtnGlow.Parent = MainBtn
    BtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    BtnGlow.BackgroundTransparency = 1
    BtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    BtnGlow.Size = UDim2.new(1.6, 0, 1.6, 0)
    BtnGlow.Image = "rbxassetid://6015897843"
    BtnGlow.ImageColor3 = ConfigWindow.AccentColor
    BtnGlow.ImageTransparency = 0.7
    BtnGlow.ScaleType = Enum.ScaleType.Slice
    BtnGlow.SliceCenter = Rect.new(49, 49, 450, 450)
    BtnGlow.ZIndex = 0

    MainBtn.MouseEnter:Connect(function()
        Library:TweenInstance(MainBtn, 0.2, "Size", UDim2.new(0, 55, 0, 55))
        Library:TweenInstance(BtnGlow, 0.2, "ImageTransparency", 0.5)
    end)

    MainBtn.MouseLeave:Connect(function()
        Library:TweenInstance(MainBtn, 0.2, "Size", UDim2.new(0, 50, 0, 50))
        Library:TweenInstance(BtnGlow, 0.2, "ImageTransparency", 0.7)
    end)

    self:MakeDraggable(MainBtn, MainBtn)
    
    MainBtn.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
    end)

    return Tab
end

return Library
