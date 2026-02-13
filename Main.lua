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
        game:GetService("TweenService"):Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = pos }):Play()
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
    local UIGradient_Main = Instance.new("UIGradient")
    
    local Top = Instance.new("Frame")
    local TopStroke = Instance.new("Frame")
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

    TeddyUI_Premium.Name = "TeddyUI_Premium_" .. math.random(100, 999)
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 550, 0, 400)

    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 60, 1, 60)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.3
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    UIStroke.Color = Color3.fromRGB(45, 45, 45)
    UIStroke.Thickness = 1.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Main

    UIGradient_Main.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    UIGradient_Main.Rotation = 45
    UIGradient_Main.Parent = Main

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Top.Size = UDim2.new(1, 0, 0, 55)

    TopStroke.Name = "TopStroke"
    TopStroke.Parent = Top
    TopStroke.BackgroundColor3 = ConfigWindow.AccentColor
    TopStroke.BorderSizePixel = 0
    TopStroke.Position = UDim2.new(0, 0, 1, -1)
    TopStroke.Size = UDim2.new(1, 0, 0, 1)
    local TopStrokeGradient = Instance.new("UIGradient")
    TopStrokeGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    TopStrokeGradient.Parent = TopStroke

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 15, 0, 10)
    LogoHub.Size = UDim2.new(0, 35, 0, 35)
    LogoHub.Image = "rbxassetid://123256573634"

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 60, 0, 12)
    NameHub.Size = UDim2.new(0, 200, 0, 18)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 17
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 60, 0, 30)
    Desc.Size = UDim2.new(0, 200, 0, 12)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(160, 160, 160)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -80, 0, 0)
    RightButtons.Size = UDim2.new(0, 70, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 12)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "✕"
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.TextSize = 16

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 25, 0, 25)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "—"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 200)
    Minize.TextSize = 16

    -- Horizontal Tab Holder
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    TabHolder.Position = UDim2.new(0, 0, 0, 55)
    TabHolder.Size = UDim2.new(1, 0, 0, 45)
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.ScrollingDirection = Enum.ScrollingDirection.X

    TabListLayout.Parent = TabHolder
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 15)
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 15)

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 30, 0, 0)
    end)

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 100)
    ContentFrame.Size = UDim2.new(1, 0, 1, -100)
    ContentFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame
    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quint
    PageLayout.EasingDirection = Enum.EasingDirection.Out
    PageLayout.TweenTime = 0.4

    self:MakeDraggable(Top, DropShadowHolder)

    Close.MouseButton1Click:Connect(function() TeddyUI_Premium:Destroy() end)
    Minize.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)

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
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = ConfigWindow.AccentColor
        TabPage.LayoutOrder = TabCount
        
        TabListLayout_Page.Parent = TabPage
        TabListLayout_Page.Padding = UDim.new(0, 10)
        TabListLayout_Page.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding_Page.Parent = TabPage
        TabPadding_Page.PaddingLeft = UDim.new(0, 15)
        TabPadding_Page.PaddingRight = UDim.new(0, 15)
        TabPadding_Page.PaddingTop = UDim.new(0, 15)
        TabPadding_Page.PaddingBottom = UDim.new(0, 15)

        Library:UpdateScrolling(TabPage, TabListLayout_Page)

        -- Horizontal Tab Button
        local TabBtn = Instance.new("TextButton")
        local TabBtnTitle = Instance.new("TextLabel")
        local TabIndicator = Instance.new("Frame")
        local TabIndicatorGradient = Instance.new("UIGradient")

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
        TabBtnTitle.Text = t
        TabBtnTitle.TextColor3 = Color3.fromRGB(120, 120, 120)
        TabBtnTitle.TextSize = 13
        
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabBtn
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 1, -2)
        TabIndicator.Size = UDim2.new(1, 0, 0, 2)
        TabIndicator.BackgroundTransparency = 1

        TabIndicatorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ConfigWindow.AccentColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
        TabIndicatorGradient.Parent = TabIndicator

        local textWidth = game:GetService("TextService"):GetTextSize(t, 13, Enum.Font.GothamBold, Vector2.new(1000, 1000)).X
        TabBtn.Size = UDim2.new(0, textWidth + 20, 1, 0)

        local function SelectTab()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:TweenInstance(v.TextLabel, 0.3, "TextColor3", Color3.fromRGB(120, 120, 120))
                    Library:TweenInstance(v.Indicator, 0.3, "BackgroundTransparency", 1)
                end
            end
            Library:TweenInstance(TabBtnTitle, 0.3, "TextColor3", Color3.fromRGB(255, 255, 255))
            Library:TweenInstance(TabIndicator, 0.3, "BackgroundTransparency", 0)
            PageLayout:JumpTo(TabPage)
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        if FirstTab then
            task.spawn(function()
                task.wait(0.1)
                SelectTab()
            end)
            FirstTab = false
        end

        TabCount = TabCount + 1
        local TabFunc = {}

        function TabFunc:AddSection(SectionTitle)
            local SectionFrame = Instance.new("Frame")
            local SectionTitleLabel = Instance.new("TextLabel")
            local SectionList = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")

            SectionFrame.Name = SectionTitle .. "_Section"
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame

            SectionStroke.Color = Color3.fromRGB(35, 35, 35)
            SectionStroke.Thickness = 1
            SectionStroke.Parent = SectionFrame

            SectionTitleLabel.Parent = SectionFrame
            SectionTitleLabel.BackgroundTransparency = 1
            SectionTitleLabel.Position = UDim2.new(0, 12, 0, -10)
            SectionTitleLabel.Size = UDim2.new(0, 100, 0, 20)
            SectionTitleLabel.Font = Enum.Font.GothamBold
            SectionTitleLabel.Text = "  " .. SectionTitle:upper() .. "  "
            SectionTitleLabel.TextColor3 = ConfigWindow.AccentColor
            SectionTitleLabel.TextSize = 11
            SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitleLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            SectionTitleLabel.AutomaticSize = Enum.AutomaticSize.X

            SectionList.Parent = SectionFrame
            SectionList.Padding = UDim.new(0, 8)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionFrame
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)
            SectionPadding.PaddingTop = UDim.new(0, 15)
            SectionPadding.PaddingBottom = UDim.new(0, 10)

            local SectionFunc = {}
            local CurrentGroup = SectionFrame

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbtn or {})
                local BtnFrame = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnTitle = Instance.new("TextLabel")
                local BtnIcon = Instance.new("ImageLabel")

                BtnFrame.Parent = CurrentGroup
                BtnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                BtnFrame.Size = UDim2.new(1, 0, 0, 42)
                BtnFrame.AutoButtonColor = false
                BtnFrame.Text = ""

                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = BtnFrame

                BtnStroke.Color = Color3.fromRGB(45, 45, 45)
                BtnStroke.Thickness = 1
                BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                BtnStroke.Parent = BtnFrame

                BtnTitle.Parent = BtnFrame
                BtnTitle.BackgroundTransparency = 1
                BtnTitle.Position = UDim2.new(0, 12, 0, 0)
                BtnTitle.Size = UDim2.new(1, -40, 1, 0)
                BtnTitle.Font = Enum.Font.GothamMedium
                BtnTitle.Text = cfbtn.Title
                BtnTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BtnTitle.TextSize = 13
                BtnTitle.TextXAlignment = Enum.TextXAlignment.Left

                BtnIcon.Parent = BtnFrame
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(1, -32, 0.5, -10)
                BtnIcon.Size = UDim2.new(0, 20, 0, 20)
                BtnIcon.Image = "rbxassetid://10747373176"
                BtnIcon.ImageColor3 = ConfigWindow.AccentColor

                BtnFrame.MouseEnter:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 35))
                    Library:TweenInstance(BtnStroke, 0.2, "Color", ConfigWindow.AccentColor)
                end)
                BtnFrame.MouseLeave:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(25, 25, 25))
                    Library:TweenInstance(BtnStroke, 0.2, "Color", Color3.fromRGB(45, 45, 45))
                end)
                BtnFrame.MouseButton1Down:Connect(function()
                    BtnFrame.Size = UDim2.new(1, -4, 0, 40)
                    task.wait(0.1)
                    BtnFrame.Size = UDim2.new(1, 0, 0, 42)
                    pcall(cfbtn.Callback)
                end)
            end

            function SectionFunc:AddToggle(cftog)
                cftog = Library:MakeConfig({ Title = "Toggle", Description = "", Default = false, Callback = function() end }, cftog or {})
                local TogFrame = Instance.new("TextButton")
                local TogCorner = Instance.new("UICorner")
                local TogTitle = Instance.new("TextLabel")
                local TogSwitch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local SwitchDot = Instance.new("Frame")
                local DotCorner = Instance.new("UICorner")

                TogFrame.Parent = CurrentGroup
                TogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TogFrame.Size = UDim2.new(1, 0, 0, 42)
                TogFrame.AutoButtonColor = false
                TogFrame.Text = ""

                TogCorner.CornerRadius = UDim.new(0, 6)
                TogCorner.Parent = TogFrame

                TogTitle.Parent = TogFrame
                TogTitle.BackgroundTransparency = 1
                TogTitle.Position = UDim2.new(0, 12, 0, 0)
                TogTitle.Size = UDim2.new(1, -60, 1, 0)
                TogTitle.Font = Enum.Font.GothamMedium
                TogTitle.Text = cftog.Title
                TogTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                TogTitle.TextSize = 13
                TogTitle.TextXAlignment = Enum.TextXAlignment.Left

                TogSwitch.Parent = TogFrame
                TogSwitch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                TogSwitch.Position = UDim2.new(1, -50, 0.5, -11)
                TogSwitch.Size = UDim2.new(0, 38, 0, 22)
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = TogSwitch

                SwitchDot.Parent = TogSwitch
                SwitchDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                SwitchDot.Position = UDim2.new(0, 3, 0.5, -8)
                SwitchDot.Size = UDim2.new(0, 16, 0, 16)
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = SwitchDot

                local Toggled = cftog.Default
                local function UpdateTog()
                    if Toggled then
                        Library:TweenInstance(TogSwitch, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
                        Library:TweenInstance(SwitchDot, 0.2, "Position", UDim2.new(1, -19, 0.5, -8))
                        Library:TweenInstance(SwitchDot, 0.2, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
                    else
                        Library:TweenInstance(TogSwitch, 0.2, "BackgroundColor3", Color3.fromRGB(40, 40, 40))
                        Library:TweenInstance(SwitchDot, 0.2, "Position", UDim2.new(0, 3, 0.5, -8))
                        Library:TweenInstance(SwitchDot, 0.2, "BackgroundColor3", Color3.fromRGB(200, 200, 200))
                    end
                    pcall(cftog.Callback, Toggled)
                end

                TogFrame.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateTog()
                end)
                UpdateTog()
                return { Set = function(self, val) Toggled = val UpdateTog() end }
            end

            function SectionFunc:AddSlider(cfslid)
                cfslid = Library:MakeConfig({ Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslid or {})
                local SlidFrame = Instance.new("Frame")
                local SlidCorner = Instance.new("UICorner")
                local SlidTitle = Instance.new("TextLabel")
                local SlidVal = Instance.new("TextLabel")
                local SlidBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SlidFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SlidBtn = Instance.new("TextButton")

                SlidFrame.Parent = CurrentGroup
                SlidFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                SlidFrame.Size = UDim2.new(1, 0, 0, 55)
                SlidCorner.CornerRadius = UDim.new(0, 6)
                SlidCorner.Parent = SlidFrame

                SlidTitle.Parent = SlidFrame
                SlidTitle.BackgroundTransparency = 1
                SlidTitle.Position = UDim2.new(0, 12, 0, 8)
                SlidTitle.Size = UDim2.new(1, -60, 0, 20)
                SlidTitle.Font = Enum.Font.GothamMedium
                SlidTitle.Text = cfslid.Title
                SlidTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SlidTitle.TextSize = 13
                SlidTitle.TextXAlignment = Enum.TextXAlignment.Left

                SlidVal.Parent = SlidFrame
                SlidVal.BackgroundTransparency = 1
                SlidVal.Position = UDim2.new(1, -52, 0, 8)
                SlidVal.Size = UDim2.new(0, 40, 0, 20)
                SlidVal.Font = Enum.Font.GothamBold
                SlidVal.Text = tostring(cfslid.Default)
                SlidVal.TextColor3 = ConfigWindow.AccentColor
                SlidVal.TextSize = 13
                SlidVal.TextXAlignment = Enum.TextXAlignment.Right

                SlidBar.Parent = SlidFrame
                SlidBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                SlidBar.Position = UDim2.new(0, 12, 0, 35)
                SlidBar.Size = UDim2.new(1, -24, 0, 6)
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SlidBar

                SlidFill.Parent = SlidBar
                SlidFill.BackgroundColor3 = ConfigWindow.AccentColor
                SlidFill.Size = UDim2.new((cfslid.Default - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0)
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SlidFill

                SlidBtn.Parent = SlidBar
                SlidBtn.BackgroundTransparency = 1
                SlidBtn.Size = UDim2.new(1, 0, 1, 0)
                SlidBtn.Text = ""

                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SlidBar.AbsolutePosition.X) / SlidBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(cfslid.Min + (cfslid.Max - cfslid.Min) * pos)
                    SlidVal.Text = tostring(val)
                    Library:TweenInstance(SlidFill, 0.1, "Size", UDim2.new(pos, 0, 1, 0))
                    pcall(cfslid.Callback, val)
                end

                local Dragging = false
                SlidBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSlider(input)
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                pcall(cfslid.Callback, cfslid.Default)
                return { Set = function(self, val) val = math.clamp(val, cfslid.Min, cfslid.Max) SlidVal.Text = tostring(val) SlidFill.Size = UDim2.new((val - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0) pcall(cfslid.Callback, val) end }
            end

            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({ Title = "Dropdown", Description = "", Options = {}, Values = {}, Default = "", Callback = function() end }, cfdrop or {})
                local options = #cfdrop.Options > 0 and cfdrop.Options or cfdrop.Values
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropStroke = Instance.new("UIStroke")
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("ImageLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                DropFrame.Size = UDim2.new(1, 0, 0, 42)
                DropFrame.ClipsDescendants = true
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropFrame
                
                DropStroke.Color = Color3.fromRGB(45, 45, 45)
                DropStroke.Thickness = 1
                DropStroke.Parent = DropFrame

                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 42)
                DropBtn.Text = ""

                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 12, 0, 0)
                DropTitle.Size = UDim2.new(1, -40, 0, 42)
                DropTitle.Font = Enum.Font.GothamMedium
                local defaultText = type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default)
                DropTitle.Text = cfdrop.Title .. " : " .. (defaultText ~= "" and defaultText or "None")
                DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropTitle.TextSize = 13
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left

                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -32, 0, 11)
                DropIcon.Size = UDim2.new(0, 20, 0, 20)
                DropIcon.Image = "rbxassetid://10747383819"
                DropIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 42)
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
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 50) or 42
                    Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize))
                    Library:TweenInstance(DropIcon, 0.3, "Rotation", Open and 180 or 0)
                    Library:TweenInstance(DropStroke, 0.3, "Color", Open and ConfigWindow.AccentColor or Color3.fromRGB(45, 45, 45))
                end
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        OptBtn.Size = UDim2.new(1, 0, 0, 32)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptBtn.TextSize = 12
                        OptCorner.CornerRadius = UDim.new(0, 4)
                        OptCorner.Parent = OptBtn
                        
                        OptBtn.MouseEnter:Connect(function() Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(45, 45, 45)) end)
                        OptBtn.MouseLeave:Connect(function() Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 35)) end)

                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. " : " .. opt
                            ToggleDrop()
                            pcall(cfdrop.Callback, opt)
                        end)
                    end
                end
                AddOptions(options)
                if cfdrop.Default ~= "" then pcall(cfdrop.Callback, cfdrop.Default) end
                return { Refresh = function(self, newopts) for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOptions(newopts) end, Set = function(self, val) DropTitle.Text = cfdrop.Title .. " : " .. tostring(val) pcall(cfdrop.Callback, val) end }
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
                BoxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                BoxFrame.Size = UDim2.new(1, 0, 0, 42)
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = BoxFrame
                
                BoxStroke.Color = Color3.fromRGB(45, 45, 45)
                BoxStroke.Thickness = 1
                BoxStroke.Parent = BoxFrame

                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 12, 0, 0)
                BoxTitle.Size = UDim2.new(0, 100, 1, 0)
                BoxTitle.Font = Enum.Font.GothamMedium
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BoxTitle.TextSize = 13
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                BoxInput.Position = UDim2.new(1, -160, 0.5, -13)
                BoxInput.Size = UDim2.new(0, 150, 0, 26)
                BoxInput.Font = Enum.Font.Gotham
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                BoxInput.TextSize = 12
                BoxInput.PlaceholderText = "Type here..."
                BoxInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = BoxInput
                
                InputStroke.Color = Color3.fromRGB(45, 45, 45)
                InputStroke.Thickness = 1
                InputStroke.Parent = BoxInput

                BoxInput.Focused:Connect(function() Library:TweenInstance(InputStroke, 0.3, "Color", ConfigWindow.AccentColor) end)
                BoxInput.FocusLost:Connect(function() Library:TweenInstance(InputStroke, 0.3, "Color", Color3.fromRGB(45, 45, 45)) pcall(cfbox.Callback, BoxInput.Text) end)
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local LabelFrame = Instance.new("Frame")
                local Label = Instance.new("TextLabel")
                local LabelIcon = Instance.new("ImageLabel")
                
                LabelFrame.Parent = CurrentGroup
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Size = UDim2.new(1, 0, 0, 25)

                LabelIcon.Parent = LabelFrame
                LabelIcon.BackgroundTransparency = 1
                LabelIcon.Position = UDim2.new(0, 5, 0.5, -8)
                LabelIcon.Size = UDim2.new(0, 16, 0, 16)
                LabelIcon.Image = "rbxassetid://10747372831"
                LabelIcon.ImageColor3 = ConfigWindow.AccentColor

                Label.Parent = LabelFrame
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 28, 0, 0)
                Label.Size = UDim2.new(1, -30, 1, 0)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                Label.TextSize = 12
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
                local ParaIcon = Instance.new("ImageLabel")

                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                ParaFrame.Size = UDim2.new(1, 0, 0, 60)
                ParaCorner.CornerRadius = UDim.new(0, 8)
                ParaCorner.Parent = ParaFrame
                
                ParaStroke.Color = Color3.fromRGB(45, 45, 45)
                ParaStroke.Thickness = 1
                ParaStroke.Parent = ParaFrame

                ParaIcon.Parent = ParaFrame
                ParaIcon.BackgroundTransparency = 1
                ParaIcon.Position = UDim2.new(0, 12, 0, 12)
                ParaIcon.Size = UDim2.new(0, 18, 0, 18)
                ParaIcon.Image = "rbxassetid://10747373176"
                ParaIcon.ImageColor3 = ConfigWindow.AccentColor

                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 38, 0, 12)
                ParaTitle.Size = UDim2.new(1, -50, 0, 18)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title
                ParaTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParaTitle.TextSize = 14
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 38, 0, 32)
                ParaContent.Size = UDim2.new(1, -50, 0, 18)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(160, 160, 160)
                ParaContent.TextSize = 12
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true

                local function UpdateSize()
                    local textHeight = game:GetService("TextService"):GetTextSize(ParaContent.Text, 12, Enum.Font.Gotham, Vector2.new(ParaContent.AbsoluteSize.X, 10000)).Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 45)
                    ParaContent.Size = UDim2.new(1, -50, 0, textHeight)
                end
                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                task.spawn(function() task.wait(0.1) UpdateSize() end)
                
                return { SetTitle = function(self, val) ParaTitle.Text = val end, SetDesc = function(self, val) ParaContent.Text = val end, Set = function(self, val) ParaContent.Text = val end }
            end

            function SectionFunc:AddDiscord(DiscordTitle, InviteCode)
                local DiscordCard = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local Icon = Instance.new("ImageLabel")
                local IconCorner = Instance.new("UICorner")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnGradient = Instance.new("UIGradient")

                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
                DiscordCard.Size = UDim2.new(1, 0, 0, 80)
                UICorner.CornerRadius = UDim.new(0, 10)
                UICorner.Parent = DiscordCard
                
                UIStroke.Color = Color3.fromRGB(88, 101, 242)
                UIStroke.Thickness = 1.5
                UIStroke.Parent = DiscordCard

                Icon.Parent = DiscordCard
                Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                Icon.Position = UDim2.new(0, 15, 0, 15)
                Icon.Size = UDim2.new(0, 50, 0, 50)
                Icon.Image = "rbxassetid://123256573634"
                IconCorner.CornerRadius = UDim.new(0, 8)
                IconCorner.Parent = Icon

                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 75, 0, 20)
                Title.Size = UDim2.new(1, -160, 0, 20)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 15
                Title.TextXAlignment = Enum.TextXAlignment.Left

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 75, 0, 40)
                SubTitle.Size = UDim2.new(1, -160, 0, 20)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Join our community!"
                SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
                SubTitle.TextSize = 12
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                JoinBtn.Position = UDim2.new(1, -85, 0.5, -15)
                JoinBtn.Size = UDim2.new(0, 70, 0, 30)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "JOIN"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 13
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = JoinBtn
                
                BtnGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
                })
                BtnGradient.Rotation = 90
                BtnGradient.Parent = JoinBtn

                JoinBtn.MouseButton1Click:Connect(function()
                    if setclipboard then setclipboard("https://discord.gg/" .. InviteCode) end
                    JoinBtn.Text = "COPIED!"
                    task.wait(2)
                    JoinBtn.Text = "JOIN"
                end)
            end

            return SectionFunc
        end

        return TabFunc
    end

    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    local BtnGradient = Instance.new("UIGradient")

    ToggleBtn.Name = "ToggleUI_" .. math.random(100, 999)
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 30, 0, 30)
    MainBtn.Size = UDim2.new(0, 50, 0, 50)
    MainBtn.Image = "rbxassetid://101817370702077"
    
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn
    
    BtnStroke.Color = Color3.fromRGB(255, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.Transparency = 0.5
    BtnStroke.Parent = MainBtn
    
    BtnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
    })
    BtnGradient.Rotation = 45
    BtnGradient.Parent = MainBtn

    self:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)

    return Tab
end

return Library
