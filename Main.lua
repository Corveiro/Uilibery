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
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = game:GetService("TweenService"):Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Linear), { Position = pos })
        Tween:Play()
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "SYNTRAX Hub",
        Description = "By Thais",
        AccentColor = Color3.fromRGB(255, 0, 0)
    }, ConfigWindow or {})

    local TeddyUI_Premium = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")
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
    local BackBtn = Instance.new("TextButton")
    
    local ContentFrame = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")
    
    local HomeTab = Instance.new("ScrollingFrame")
    local HomeGridLayout = Instance.new("UIGridLayout")
    local HomePadding = Instance.new("UIPadding")

    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Interface compacta: 520x340
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 520, 0, 340)

    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.4
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, 0, 1, 0)
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main
    UIStroke.Color = Color3.fromRGB(40, 40, 48)
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Main

    -- Header compacto: 48px
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    Top.Size = UDim2.new(1, 0, 0, 48)
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = Top
    local TopFill = Instance.new("Frame")
    TopFill.Parent = Top
    TopFill.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    TopFill.Position = UDim2.new(0, 0, 1, -12)
    TopFill.Size = UDim2.new(1, 0, 0, 12)
    TopFill.BorderSizePixel = 0

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 12, 0.5, -14)
    LogoHub.Size = UDim2.new(0, 28, 0, 28)
    LogoHub.Image = "rbxassetid://101817370702077"
    LogoHub.ImageColor3 = ConfigWindow.AccentColor

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 46, 0, 9)
    NameHub.Size = UDim2.new(0.5, -58, 0, 17)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 14
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 46, 0, 26)
    Desc.Size = UDim2.new(0.5, -58, 0, 13)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(150, 150, 160)
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    -- Botões compactos
    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -108, 0.5, -13)
    RightButtons.Size = UDim2.new(0, 104, 0, 26)
    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.Padding = UDim.new(0, 5)

    BackBtn.Name = "BackBtn"
    BackBtn.Parent = RightButtons
    BackBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    BackBtn.Size = UDim2.new(0, 26, 0, 26)
    BackBtn.Font = Enum.Font.GothamBold
    BackBtn.Text = "←"
    BackBtn.TextColor3 = Color3.fromRGB(190, 190, 200)
    BackBtn.TextSize = 15
    BackBtn.Visible = false
    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackBtn

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    Minize.Size = UDim2.new(0, 26, 0, 26)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "−"
    Minize.TextColor3 = Color3.fromRGB(190, 190, 200)
    Minize.TextSize = 17
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = Minize

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundColor3 = Color3.fromRGB(210, 45, 55)
    Close.Size = UDim2.new(0, 26, 0, 26)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 19
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 48)
    ContentFrame.Size = UDim2.new(1, 0, 1, -48)
    ContentFrame.ClipsDescendants = true
    PageLayout.Parent = ContentFrame
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.TweenTime = 0.2
    PageLayout.EasingStyle = Enum.EasingStyle.Quad
    PageList.Parent = ContentFrame

    -- Home Tab com grid 3 colunas
    HomeTab.Name = "Home"
    HomeTab.Parent = PageList
    HomeTab.BackgroundTransparency = 1
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.ScrollBarThickness = 4
    HomeTab.ScrollBarImageColor3 = ConfigWindow.AccentColor
    HomeTab.BorderSizePixel = 0
    HomeTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    HomeTab.LayoutOrder = 0

    HomeGridLayout.Parent = HomeTab
    HomeGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    HomeGridLayout.CellSize = UDim2.new(0, 158, 0, 42)  -- Cards compactos
    HomeGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    HomePadding.Parent = HomeTab
    HomePadding.PaddingLeft = UDim.new(0, 10)
    HomePadding.PaddingRight = UDim.new(0, 10)
    HomePadding.PaddingTop = UDim.new(0, 10)
    HomePadding.PaddingBottom = UDim.new(0, 10)

    self:UpdateScrolling(HomeTab, HomeGridLayout)
    self:MakeDraggable(Top, Main)

    local Closed = false
    Close.MouseButton1Click:Connect(function()
        if not Closed then
            Closed = true
            self:TweenInstance(Main, 0.3, "Size", UDim2.new(0, 0, 0, 0))
            task.wait(0.3)
            TeddyUI_Premium:Destroy()
        end
    end)

    local Minimized = false
    Minize.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            self:TweenInstance(Main, 0.3, "Size", UDim2.new(0, 520, 0, 48))
        else
            self:TweenInstance(Main, 0.3, "Size", UDim2.new(0, 520, 0, 340))
        end
    end)

    BackBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(HomeTab)
        BackBtn.Visible = false
    end)

    local TabCount = 1
    local Tab = {}
    
    function Tab:AddTab(cfgtab)
        cfgtab = Library:MakeConfig({ Title = "Tab", Icon = "" }, cfgtab or {})
        local t = cfgtab.Title
        local iconid = cfgtab.Icon

        local TabPage = Instance.new("ScrollingFrame")
        local TabListLayout = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")

        TabPage.Name = t
        TabPage.Parent = PageList
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = ConfigWindow.AccentColor
        TabPage.BorderSizePixel = 0
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.LayoutOrder = TabCount
        
        TabListLayout.Parent = TabPage
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding.Parent = TabPage
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.PaddingBottom = UDim.new(0, 10)

        Library:UpdateScrolling(TabPage, TabListLayout)

        -- Card de navegação moderno e compacto
        local Card = Instance.new("TextButton")
        local CardCorner = Instance.new("UICorner")
        local CardIcon = Instance.new("ImageLabel")
        local CardTitle = Instance.new("TextLabel")
        local CardGradient = Instance.new("UIGradient")

        Card.Name = t .. "_Card"
        Card.Parent = HomeTab
        Card.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        Card.Text = ""
        Card.LayoutOrder = TabCount
        Card.AutoButtonColor = false
        
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card
        
        CardGradient.Parent = Card
        CardGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 32)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 38))
        }
        CardGradient.Rotation = 45

        CardIcon.Parent = Card
        CardIcon.BackgroundTransparency = 1
        CardIcon.Position = UDim2.new(0, 10, 0.5, -11)
        CardIcon.Size = UDim2.new(0, 22, 0, 22)
        CardIcon.Image = (iconid and iconid ~= "") and iconid or "rbxassetid://123256573634"
        CardIcon.ImageColor3 = ConfigWindow.AccentColor

        CardTitle.Parent = Card
        CardTitle.BackgroundTransparency = 1
        CardTitle.Position = UDim2.new(0, 37, 0, 0)
        CardTitle.Size = UDim2.new(1, -42, 1, 0)
        CardTitle.Font = Enum.Font.GothamBold
        CardTitle.Text = t
        CardTitle.TextColor3 = Color3.fromRGB(215, 215, 225)
        CardTitle.TextSize = 12
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left

        Card.MouseEnter:Connect(function()
            Library:TweenInstance(Card, 0.2, "BackgroundColor3", Color3.fromRGB(33, 33, 42))
            Library:TweenInstance(CardTitle, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
        end)
        Card.MouseLeave:Connect(function()
            Library:TweenInstance(Card, 0.2, "BackgroundColor3", Color3.fromRGB(26, 26, 32))
            Library:TweenInstance(CardTitle, 0.2, "TextColor3", Color3.fromRGB(215, 215, 225))
        end)

        Card.MouseButton1Click:Connect(function()
            PageLayout:JumpToIndex(TabPage.LayoutOrder)
            BackBtn.Visible = true
        end)

        TabCount = TabCount + 1
        local TabFunc = {}

        function TabFunc:AddSection(RealNameSection)
            -- Section compacta e moderna
            local SectionCard = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionTitle = Instance.new("TextLabel")
            local SectionDivider = Instance.new("Frame")
            local SectionList = Instance.new("Frame")
            local SectionListLayout = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionCard.Name = "Section_" .. RealNameSection
            SectionCard.Parent = TabPage
            SectionCard.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            SectionCard.Size = UDim2.new(1, 0, 0, 0)
            SectionCard.AutomaticSize = Enum.AutomaticSize.Y
            
            SectionCorner.CornerRadius = UDim.new(0, 9)
            SectionCorner.Parent = SectionCard

            SectionTitle.Parent = SectionCard
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 11, 0, 7)
            SectionTitle.Size = UDim2.new(1, -22, 0, 16)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = RealNameSection:upper()
            SectionTitle.TextColor3 = ConfigWindow.AccentColor
            SectionTitle.TextSize = 11
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionDivider.Parent = SectionCard
            SectionDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SectionDivider.Position = UDim2.new(0, 11, 0, 26)
            SectionDivider.Size = UDim2.new(1, -22, 0, 1)
            SectionDivider.BorderSizePixel = 0

            SectionList.Name = "List"
            SectionList.Parent = SectionCard
            SectionList.BackgroundTransparency = 1
            SectionList.Position = UDim2.new(0, 0, 0, 32)
            SectionList.Size = UDim2.new(1, 0, 0, 0)
            SectionList.AutomaticSize = Enum.AutomaticSize.Y

            SectionListLayout.Parent = SectionList
            SectionListLayout.Padding = UDim.new(0, 6)
            SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionList
            SectionPadding.PaddingLeft = UDim.new(0, 9)
            SectionPadding.PaddingRight = UDim.new(0, 9)
            SectionPadding.PaddingBottom = UDim.new(0, 9)

            local CurrentGroup = SectionList
            local SectionFunc = {}

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbtn or {})
                
                local BtnFrame = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnGradient = Instance.new("UIGradient")
                local BtnTitle = Instance.new("TextLabel")
                local BtnIcon = Instance.new("TextLabel")
                
                BtnFrame.Parent = CurrentGroup
                BtnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                BtnFrame.Size = UDim2.new(1, 0, 0, 30)
                BtnFrame.AutoButtonColor = false
                BtnFrame.Text = ""
                BtnCorner.CornerRadius = UDim.new(0, 7)
                BtnCorner.Parent = BtnFrame
                
                BtnGradient.Parent = BtnFrame
                BtnGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 33))
                }
                BtnGradient.Rotation = 90
                
                BtnTitle.Parent = BtnFrame
                BtnTitle.BackgroundTransparency = 1
                BtnTitle.Position = UDim2.new(0, 11, 0, 0)
                BtnTitle.Size = UDim2.new(1, -38, 1, 0)
                BtnTitle.Font = Enum.Font.GothamBold
                BtnTitle.Text = cfbtn.Title
                BtnTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
                BtnTitle.TextSize = 12
                BtnTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                BtnIcon.Parent = BtnFrame
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(1, -28, 0, 0)
                BtnIcon.Size = UDim2.new(0, 28, 1, 0)
                BtnIcon.Font = Enum.Font.GothamBold
                BtnIcon.Text = "→"
                BtnIcon.TextColor3 = ConfigWindow.AccentColor
                BtnIcon.TextSize = 15
                
                BtnFrame.MouseEnter:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(38, 38, 48))
                end)
                BtnFrame.MouseLeave:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 38))
                end)
                BtnFrame.MouseButton1Click:Connect(function()
                    pcall(cfbtn.Callback)
                end)
            end

            function SectionFunc:AddToggle(cftoggle)
                cftoggle = Library:MakeConfig({ Title = "Toggle", Description = "", Default = false, Callback = function() end }, cftoggle or {})
                
                local ToggleFrame = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleBtn = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local SwitchKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                
                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleCorner.CornerRadius = UDim.new(0, 7)
                ToggleCorner.Parent = ToggleFrame
                
                ToggleBtn.Parent = ToggleFrame
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
                ToggleBtn.Text = ""
                
                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 11, 0, 0)
                ToggleTitle.Size = UDim2.new(1, -56, 1, 0)
                ToggleTitle.Font = Enum.Font.Gotham
                ToggleTitle.Text = cftoggle.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(210, 210, 220)
                ToggleTitle.TextSize = 12
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                ToggleSwitch.Parent = ToggleFrame
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
                ToggleSwitch.Position = UDim2.new(1, -42, 0.5, -8)
                ToggleSwitch.Size = UDim2.new(0, 36, 0, 16)
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch
                
                SwitchKnob.Parent = ToggleSwitch
                SwitchKnob.BackgroundColor3 = Color3.fromRGB(190, 190, 200)
                SwitchKnob.Position = UDim2.new(0, 2, 0.5, -6)
                SwitchKnob.Size = UDim2.new(0, 12, 0, 12)
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SwitchKnob
                
                local Toggled = cftoggle.Default
                local function UpdateToggle()
                    if Toggled then
                        Library:TweenInstance(ToggleSwitch, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
                        Library:TweenInstance(SwitchKnob, 0.2, "Position", UDim2.new(1, -14, 0.5, -6))
                        Library:TweenInstance(SwitchKnob, 0.2, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
                    else
                        Library:TweenInstance(ToggleSwitch, 0.2, "BackgroundColor3", Color3.fromRGB(42, 42, 52))
                        Library:TweenInstance(SwitchKnob, 0.2, "Position", UDim2.new(0, 2, 0.5, -6))
                        Library:TweenInstance(SwitchKnob, 0.2, "BackgroundColor3", Color3.fromRGB(190, 190, 200))
                    end
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                    pcall(cftoggle.Callback, Toggled)
                end)
                
                UpdateToggle()
                return { Set = function(self, val) Toggled = val UpdateToggle() pcall(cftoggle.Callback, Toggled) end }
            end

            function SectionFunc:AddSlider(cfslider)
                cfslider = Library:MakeConfig({ Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Increment = 1, Callback = function() end }, cfslider or {})
                
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderTrack = Instance.new("Frame")
                local TrackCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderBtn = Instance.new("TextButton")
                
                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
                SliderFrame.Size = UDim2.new(1, 0, 0, 42)
                SliderCorner.CornerRadius = UDim.new(0, 7)
                SliderCorner.Parent = SliderFrame
                
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 11, 0, 5)
                SliderTitle.Size = UDim2.new(1, -75, 0, 15)
                SliderTitle.Font = Enum.Font.Gotham
                SliderTitle.Text = cfslider.Title
                SliderTitle.TextColor3 = Color3.fromRGB(210, 210, 220)
                SliderTitle.TextSize = 11
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -56, 0, 5)
                SliderValue.Size = UDim2.new(0, 46, 0, 15)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(cfslider.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 11
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                SliderTrack.Parent = SliderFrame
                SliderTrack.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
                SliderTrack.Position = UDim2.new(0, 11, 1, -13)
                SliderTrack.Size = UDim2.new(1, -22, 0, 4)
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack
                
                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                SliderBtn.Parent = SliderFrame
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Position = UDim2.new(0, 11, 1, -13)
                SliderBtn.Size = UDim2.new(1, -22, 0, 4)
                SliderBtn.Text = ""
                
                local Value = cfslider.Default
                local function UpdateSlider(val)
                    val = math.clamp(val, cfslider.Min, cfslider.Max)
                    val = math.floor(val / cfslider.Increment + 0.5) * cfslider.Increment
                    Value = val
                    SliderValue.Text = tostring(val)
                    local percent = (val - cfslider.Min) / (cfslider.Max - cfslider.Min)
                    Library:TweenInstance(SliderFill, 0.1, "Size", UDim2.new(percent, 0, 1, 0))
                end
                
                local Dragging = false
                SliderBtn.MouseButton1Down:Connect(function() Dragging = true end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
                end)
                
                SliderBtn.MouseButton1Click:Connect(function()
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local percent = math.clamp((mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local val = cfslider.Min + (cfslider.Max - cfslider.Min) * percent
                    UpdateSlider(val)
                    pcall(cfslider.Callback, Value)
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = game.Players.LocalPlayer:GetMouse()
                        local percent = math.clamp((mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                        local val = cfslider.Min + (cfslider.Max - cfslider.Min) * percent
                        UpdateSlider(val)
                        pcall(cfslider.Callback, Value)
                    end
                end)
                
                UpdateSlider(cfslider.Default)
                if cfslider.Default ~= 0 then pcall(cfslider.Callback, cfslider.Default) end
                return { Set = function(self, val) UpdateSlider(val) pcall(cfslider.Callback, val) end }
            end

            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({ Title = "Dropdown", Description = "", Options = {}, Values = {}, Default = "", Callback = function() end }, cfdrop or {})
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
                DropFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
                DropFrame.Size = UDim2.new(1, 0, 0, 30)
                DropFrame.ClipsDescendants = true
                DropCorner.CornerRadius = UDim.new(0, 7)
                DropCorner.Parent = DropFrame
                
                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 30)
                DropBtn.Text = ""
                
                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 11, 0, 0)
                DropTitle.Size = UDim2.new(1, -38, 0, 30)
                DropTitle.Font = Enum.Font.Gotham
                DropTitle.Text = cfdrop.Title .. ": " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(210, 210, 220)
                DropTitle.TextSize = 11
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -28, 0, 0)
                DropIcon.Size = UDim2.new(0, 28, 0, 30)
                DropIcon.Font = Enum.Font.GothamBold
                DropIcon.Text = "▼"
                DropIcon.TextColor3 = Color3.fromRGB(170, 170, 180)
                DropIcon.TextSize = 9
                
                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 30)
                DropList.Size = UDim2.new(1, 0, 0, 0)
                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 4)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 4)
                DropPadding.PaddingLeft = UDim.new(0, 5)
                DropPadding.PaddingRight = UDim.new(0, 5)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 34) or 30
                    Library:TweenInstance(DropFrame, 0.2, "Size", UDim2.new(1, 0, 0, targetSize))
                    DropIcon.Text = Open and "▲" or "▼"
                end
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
                        OptBtn.Size = UDim2.new(1, 0, 0, 24)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(190, 190, 200)
                        OptBtn.TextSize = 11
                        OptBtn.AutoButtonColor = false
                        OptCorner.CornerRadius = UDim.new(0, 5)
                        OptCorner.Parent = OptBtn
                        
                        OptBtn.MouseEnter:Connect(function()
                            Library:TweenInstance(OptBtn, 0.15, "BackgroundColor3", ConfigWindow.AccentColor)
                            Library:TweenInstance(OptBtn, 0.15, "TextColor3", Color3.fromRGB(255, 255, 255))
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            Library:TweenInstance(OptBtn, 0.15, "BackgroundColor3", Color3.fromRGB(32, 32, 42))
                            Library:TweenInstance(OptBtn, 0.15, "TextColor3", Color3.fromRGB(190, 190, 200))
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. ": " .. opt
                            ToggleDrop()
                            pcall(cfdrop.Callback, opt)
                        end)
                    end
                end
                AddOptions(options)
                
                if cfdrop.Default ~= "" then pcall(cfdrop.Callback, cfdrop.Default) end

                return { 
                    Refresh = function(self, newopts) for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOptions(newopts) end,
                    Set = function(self, val) DropTitle.Text = cfdrop.Title .. ": " .. tostring(val) pcall(cfdrop.Callback, val) end
                }
            end

            function SectionFunc:AddTextbox(cfbox)
                cfbox = Library:MakeConfig({ Title = "Textbox", Description = "", Default = "", Callback = function() end }, cfbox or {})
                
                local BoxFrame = Instance.new("Frame")
                local BoxCorner = Instance.new("UICorner")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                
                BoxFrame.Parent = CurrentGroup
                BoxFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
                BoxFrame.Size = UDim2.new(1, 0, 0, 30)
                BoxCorner.CornerRadius = UDim.new(0, 7)
                BoxCorner.Parent = BoxFrame
                
                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 11, 0, 0)
                BoxTitle.Size = UDim2.new(0, 95, 1, 0)
                BoxTitle.Font = Enum.Font.Gotham
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(210, 210, 220)
                BoxTitle.TextSize = 11
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
                BoxInput.Position = UDim2.new(1, -128, 0.5, -9)
                BoxInput.Size = UDim2.new(0, 118, 0, 18)
                BoxInput.Font = Enum.Font.Gotham
                BoxInput.Text = cfbox.Default
                BoxInput.PlaceholderText = "Enter..."
                BoxInput.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
                BoxInput.TextColor3 = Color3.fromRGB(245, 245, 255)
                BoxInput.TextSize = 10
                InputCorner.CornerRadius = UDim.new(0, 5)
                InputCorner.Parent = BoxInput
                
                BoxInput.Focused:Connect(function()
                    Library:TweenInstance(BoxInput, 0.2, "BackgroundColor3", Color3.fromRGB(42, 42, 52))
                end)
                BoxInput.FocusLost:Connect(function()
                    Library:TweenInstance(BoxInput, 0.2, "BackgroundColor3", Color3.fromRGB(32, 32, 42))
                    pcall(cfbox.Callback, BoxInput.Text)
                end)
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(160, 160, 170)
                Label.TextSize = 10
                Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")
                
                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
                ParaFrame.Size = UDim2.new(1, 0, 0, 36)
                ParaCorner.CornerRadius = UDim.new(0, 7)
                ParaCorner.Parent = ParaFrame
                
                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 9, 0, 4)
                ParaTitle.Size = UDim2.new(1, -18, 0, 13)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.Text = cfpara.Title
                ParaTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
                ParaTitle.TextSize = 11
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 9, 0, 18)
                ParaContent.Size = UDim2.new(1, -18, 0, 14)
                ParaContent.Font = Enum.Font.Gotham
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(150, 150, 160)
                ParaContent.TextSize = 9
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true
                
                local function UpdateSize()
                    local textHeight = ParaContent.TextBounds.Y
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 24)
                    ParaContent.Size = UDim2.new(1, -18, 0, textHeight)
                end
                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                UpdateSize()
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
                DiscordCard.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                DiscordCard.Size = UDim2.new(1, 0, 0, 52)
                UICorner.CornerRadius = UDim.new(0, 9)
                UICorner.Parent = DiscordCard
                
                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 9, 0, 9)
                Icon.Size = UDim2.new(0, 34, 0, 34)
                Icon.Image = "rbxassetid://123256573634"
                
                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 49, 0, 11)
                Title.Size = UDim2.new(1, -120, 0, 15)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DiscordTitle or "Discord Server"
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                
                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 49, 0, 26)
                SubTitle.Size = UDim2.new(1, -120, 0, 13)
                SubTitle.Font = Enum.Font.Gotham
                SubTitle.Text = "Clique para entrar"
                SubTitle.TextColor3 = Color3.fromRGB(215, 215, 225)
                SubTitle.TextSize = 9
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.Position = UDim2.new(1, -64, 0, 14)
                JoinBtn.Size = UDim2.new(0, 54, 0, 24)
                JoinBtn.Font = Enum.Font.GothamBold
                JoinBtn.Text = "Join"
                JoinBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
                JoinBtn.TextSize = 11
                JoinBtn.AutoButtonColor = false
                BtnCorner.CornerRadius = UDim.new(0, 5)
                BtnCorner.Parent = JoinBtn
                
                JoinBtn.MouseEnter:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "BackgroundColor3", Color3.fromRGB(220, 220, 230))
                end)
                JoinBtn.MouseLeave:Connect(function()
                    Library:TweenInstance(JoinBtn, 0.2, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
                end)
                JoinBtn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                    JoinBtn.Text = "Copiado!"
                    task.wait(2)
                    JoinBtn.Text = "Join"
                end)
            end

            return SectionFunc
        end

        return TabFunc
    end

    -- Botão de toggle compacto
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 20, 0, 20)
    MainBtn.Size = UDim2.new(0, 42, 0, 42)
    MainBtn.Image = "rbxassetid://101817370702077"
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn
    BtnStroke.Color = Color3.fromRGB(28, 28, 32)
    BtnStroke.Thickness = 2
    BtnStroke.Parent = MainBtn
    
    self:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
    end)

    return Tab
end

return Library
