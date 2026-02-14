local Library = {}

-- [ Utility Functions ] --
function Library:TweenInstance(Instance, Time, OldValue, NewValue, Style, Direction)
    local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Style or Enum.EasingStyle.Back, Direction or Enum.EasingDirection.Out), { [OldValue] = NewValue })
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
        game:GetService("TweenService"):Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Sine), { Position = pos }):Play()
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
        Title = "ARCADE W-AZURE",
        Description = "Elite Edition",
        AccentColor = Color3.fromRGB(255, 0, 0)
    }, ConfigWindow or {})

    local TeddyUI_Premium = Instance.new("ScreenGui")
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

    -- [ W-AZURE Style Dropdown Overlay ] --
    local DropdownOverlay = Instance.new("Frame")
    DropdownOverlay.Name = "DropdownOverlay"
    DropdownOverlay.Parent = Main
    DropdownOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DropdownOverlay.BackgroundTransparency = 1
    DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
    DropdownOverlay.Visible = false
    DropdownOverlay.ZIndex = 50

    local DropdownPanel = Instance.new("Frame")
    DropdownPanel.Name = "DropdownPanel"
    DropdownPanel.Parent = DropdownOverlay
    DropdownPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    DropdownPanel.Position = UDim2.new(1, 0, 0, 0) -- Começa fora da tela (direita)
    DropdownPanel.Size = UDim2.new(0.6, 0, 1, 0) -- Ocupa 60% da largura
    DropdownPanel.ZIndex = 51

    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = ConfigWindow.AccentColor
    PanelStroke.Thickness = 1
    PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    PanelStroke.Parent = DropdownPanel

    local PanelTop = Instance.new("Frame")
    PanelTop.Name = "PanelTop"
    PanelTop.Parent = DropdownPanel
    PanelTop.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    PanelTop.Size = UDim2.new(1, 0, 0, 40)
    PanelTop.ZIndex = 52

    local BackBtn = Instance.new("TextButton")
    BackBtn.Name = "BackBtn"
    BackBtn.Parent = PanelTop
    BackBtn.BackgroundTransparency = 1
    BackBtn.Position = UDim2.new(0, 5, 0, 5)
    BackBtn.Size = UDim2.new(0, 30, 0, 30)
    BackBtn.Font = Enum.Font.Arcade
    BackBtn.Text = "<"
    BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackBtn.TextSize = 18
    BackBtn.ZIndex = 53

    local PanelTitle = Instance.new("TextLabel")
    PanelTitle.Name = "PanelTitle"
    PanelTitle.Parent = PanelTop
    PanelTitle.BackgroundTransparency = 1
    PanelTitle.Position = UDim2.new(0, 40, 0, 0)
    PanelTitle.Size = UDim2.new(1, -45, 1, 0)
    PanelTitle.Font = Enum.Font.Arcade
    PanelTitle.Text = "SETTING"
    PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PanelTitle.TextSize = 14
    PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
    PanelTitle.ZIndex = 53

    local PanelScroll = Instance.new("ScrollingFrame")
    PanelScroll.Name = "PanelScroll"
    PanelScroll.Parent = DropdownPanel
    PanelScroll.BackgroundTransparency = 1
    PanelScroll.Position = UDim2.new(0, 5, 0, 45)
    PanelScroll.Size = UDim2.new(1, -10, 1, -50)
    PanelScroll.ScrollBarThickness = 2
    PanelScroll.ScrollBarImageColor3 = ConfigWindow.AccentColor
    PanelScroll.ZIndex = 52

    local PanelList = Instance.new("UIListLayout")
    PanelList.Parent = PanelScroll
    PanelList.Padding = UDim.new(0, 5)
    PanelList.SortOrder = Enum.SortOrder.LayoutOrder

    Library:UpdateScrolling(PanelScroll, PanelList)

    TeddyUI_Premium.Name = "ArcadeUI_Wazure"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 440, 0, 320)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true
    Main.Visible = false

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Main

    UIStroke.Color = ConfigWindow.AccentColor
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Main

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Top.Size = UDim2.new(1, 0, 0, 40)

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 10, 0, 5)
    LogoHub.Size = UDim2.new(0, 30, 0, 30)
    LogoHub.Image = "rbxassetid://123256573634"

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 45, 0, 6)
    NameHub.Size = UDim2.new(0, 200, 0, 16)
    NameHub.Font = Enum.Font.Arcade
    NameHub.Text = ConfigWindow.Title:upper()
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 16
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 45, 0, 22)
    Desc.Size = UDim2.new(0, 200, 0, 10)
    Desc.Font = Enum.Font.Code
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = ConfigWindow.AccentColor
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -65, 0, 0)
    RightButtons.Size = UDim2.new(0, 60, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 5)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Font = Enum.Font.Arcade
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 50, 50)
    Close.TextSize = 14

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 20, 0, 20)
    Minize.Font = Enum.Font.Arcade
    Minize.Text = "_"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 200)
    Minize.TextSize = 14

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.Size = UDim2.new(1, 0, 0, 30)
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.ScrollingDirection = Enum.ScrollingDirection.X

    TabListLayout.Parent = TabHolder
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 8)

    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 20, 0, 0)
    end)

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 70)
    ContentFrame.Size = UDim2.new(1, 0, 1, -70)
    ContentFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame
    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Back
    PageLayout.TweenTime = 0.4

    self:MakeDraggable(Top, DropShadowHolder)

    Close.MouseButton1Click:Connect(function() 
        game:GetService("TweenService"):Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.5)
        TeddyUI_Premium:Destroy() 
    end)
    Minize.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)

    -- [ Intro Animation ] --
    local IntroFrame = Instance.new("Frame")
    local IntroCorner = Instance.new("UICorner")
    local IntroStroke = Instance.new("UIStroke")
    local IntroText = Instance.new("TextLabel")
    local LoadingBarBG = Instance.new("Frame")
    local LoadingBarFill = Instance.new("Frame")
    local LoadingBarCorner = Instance.new("UICorner")
    local BootText = Instance.new("TextLabel")

    IntroFrame.Name = "IntroFrame"
    IntroFrame.Parent = DropShadowHolder
    IntroFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    IntroFrame.Size = UDim2.new(0, 300, 0, 180)
    IntroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroFrame.ClipsDescendants = true
    
    IntroCorner.CornerRadius = UDim.new(0, 4)
    IntroCorner.Parent = IntroFrame
    
    IntroStroke.Color = ConfigWindow.AccentColor
    IntroStroke.Thickness = 2
    IntroStroke.Parent = IntroFrame
    
    IntroText.Parent = IntroFrame
    IntroText.BackgroundTransparency = 1
    IntroText.Size = UDim2.new(1, 0, 0, 50)
    IntroText.Position = UDim2.new(0, 0, 0.2, 0)
    IntroText.Font = Enum.Font.Arcade
    IntroText.Text = "INITIALIZING..."
    IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroText.TextSize = 18
    
    LoadingBarBG.Parent = IntroFrame
    LoadingBarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    LoadingBarBG.Position = UDim2.new(0.1, 0, 0.6, 0)
    LoadingBarBG.Size = UDim2.new(0.8, 0, 0, 15)
    
    LoadingBarFill.Parent = LoadingBarBG
    LoadingBarFill.BackgroundColor3 = ConfigWindow.AccentColor
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    
    LoadingBarCorner.CornerRadius = UDim.new(0, 2)
    LoadingBarCorner.Parent = LoadingBarBG
    local FillCorner = LoadingBarCorner:Clone()
    FillCorner.Parent = LoadingBarFill
    
    BootText.Parent = IntroFrame
    BootText.BackgroundTransparency = 1
    BootText.Position = UDim2.new(0.1, 0, 0.75, 0)
    BootText.Size = UDim2.new(0.8, 0, 0, 20)
    BootText.Font = Enum.Font.Code
    BootText.Text = "SYSTEM_CHECK: OK"
    BootText.TextColor3 = ConfigWindow.AccentColor
    BootText.TextSize = 10
    BootText.TextXAlignment = Enum.TextXAlignment.Left

    local function PlayWazureIntro()
        local TS = game:GetService("TweenService")
        IntroFrame.Size = UDim2.new(0, 0, 0, 2)
        TS:Create(IntroFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, 2)}):Play()
        task.wait(0.3)
        TS:Create(IntroFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 180)}):Play()
        task.wait(0.5)
        
        local stages = {
            {text = "LOADING ASSETS...", progress = 0.3},
            {text = "CONFIGURING W-AZURE...", progress = 0.6},
            {text = "READY TO START!", progress = 1.0}
        }
        
        for _, stage in ipairs(stages) do
            BootText.Text = "> " .. stage.text
            TS:Create(LoadingBarFill, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {Size = UDim2.new(stage.progress, 0, 1, 0)}):Play()
            task.wait(0.7)
        end
        
        task.wait(0.3)
        IntroText.Text = "W-AZURE ELITE READY"
        IntroText.TextColor3 = Color3.fromRGB(0, 255, 100)
        IntroStroke.Color = Color3.fromRGB(0, 255, 100)
        task.wait(0.8)
        
        TS:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.5)
        IntroFrame:Destroy()
        
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        TS:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    end

    task.spawn(PlayWazureIntro)

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
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = ConfigWindow.AccentColor
        TabPage.LayoutOrder = TabCount
        
        TabListLayout_Page.Parent = TabPage
        TabListLayout_Page.Padding = UDim.new(0, 6)
        TabListLayout_Page.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding_Page.Parent = TabPage
        TabPadding_Page.PaddingLeft = UDim.new(0, 10)
        TabPadding_Page.PaddingRight = UDim.new(0, 10)
        TabPadding_Page.PaddingTop = UDim.new(0, 10)
        TabPadding_Page.PaddingBottom = UDim.new(0, 10)

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
        TabBtnTitle.Font = Enum.Font.Arcade
        TabBtnTitle.Text = t:upper()
        TabBtnTitle.TextColor3 = Color3.fromRGB(100, 100, 120)
        TabBtnTitle.TextSize = 12
        
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabBtn
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 1, -2)
        TabIndicator.Size = UDim2.new(1, 0, 0, 2)
        TabIndicator.Transparency = 1

        local function UpdateTabBtnSize()
            local textWidth = game:GetService("TextService"):GetTextSize(TabBtnTitle.Text, TabBtnTitle.TextSize, TabBtnTitle.Font, Vector2.new(1000, 1000)).X
            TabBtn.Size = UDim2.new(0, textWidth + 20, 1, 0)
        end
        UpdateTabBtnSize()

        local function SelectTab()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    game:GetService("TweenService"):Create(v.TextLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(100, 100, 120)}):Play()
                    game:GetService("TweenService"):Create(v.Indicator, TweenInfo.new(0.3), {Transparency = 1}):Play()
                end
            end
            game:GetService("TweenService"):Create(TabBtnTitle, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            game:GetService("TweenService"):Create(TabIndicator, TweenInfo.new(0.3), {Transparency = 0}):Play()
            PageLayout:JumpTo(TabPage)
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        if FirstTab then
            FirstTab = false
            SelectTab()
        end

        TabCount = TabCount + 1

        local TabFunc = {}
        function TabFunc:AddSection(t)
            local SectionFrame = Instance.new("Frame")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContainer = Instance.new("Frame")
            local SectionLayout = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionFrame.Name = t .. "_Section"
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, 0, 0, 20)
            SectionTitle.Font = Enum.Font.Arcade
            SectionTitle.Text = t:upper()
            SectionTitle.TextColor3 = ConfigWindow.AccentColor
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionContainer.Name = "Container"
            SectionContainer.Parent = SectionFrame
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 0, 0, 22)
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y

            SectionLayout.Parent = SectionContainer
            SectionLayout.Padding = UDim.new(0, 6)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionContainer
            SectionPadding.PaddingLeft = UDim.new(0, 5)

            local SectionFunc = {}
            local CurrentGroup = SectionContainer

            function SectionFunc:AddButton(cfbut)
                cfbut = Library:MakeConfig({ Title = "Button", Callback = function() end }, cfbut or {})
                local ButtonFrame = Instance.new("Frame")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonBtn = Instance.new("TextButton")
                local ButtonStroke = Instance.new("UIStroke")

                ButtonFrame.Parent = CurrentGroup
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
                
                ButtonCorner.CornerRadius = UDim.new(0, 3)
                ButtonCorner.Parent = ButtonFrame
                
                ButtonBtn.Parent = ButtonFrame
                ButtonBtn.BackgroundTransparency = 1
                ButtonBtn.Size = UDim2.new(1, 0, 1, 0)
                ButtonBtn.Font = Enum.Font.Code
                ButtonBtn.Text = cfbut.Title
                ButtonBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                ButtonBtn.TextSize = 11
                
                ButtonStroke.Color = Color3.fromRGB(40, 40, 60)
                ButtonStroke.Thickness = 1
                ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ButtonStroke.Parent = ButtonFrame

                ButtonBtn.MouseEnter:Connect(function() Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 55), Enum.EasingStyle.Sine) end)
                ButtonBtn.MouseLeave:Connect(function() Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(25, 25, 40), Enum.EasingStyle.Sine) end)
                ButtonBtn.MouseButton1Click:Connect(function() pcall(cfbut.Callback) end)
            end

            function SectionFunc:AddToggle(cftog)
                cftog = Library:MakeConfig({ Title = "Toggle", Default = false, Callback = function() end }, cftog or {})
                local ToggleFrame = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleBtn = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleBox = Instance.new("Frame")
                local BoxCorner = Instance.new("UICorner")
                local BoxCheck = Instance.new("Frame")
                local CheckCorner = Instance.new("UICorner")

                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
                
                ToggleCorner.CornerRadius = UDim.new(0, 3)
                ToggleCorner.Parent = ToggleFrame
                
                ToggleBtn.Parent = ToggleFrame
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
                ToggleBtn.Text = ""
                
                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
                ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
                ToggleTitle.Font = Enum.Font.Code
                ToggleTitle.Text = cftog.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                ToggleTitle.TextSize = 11
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                ToggleBox.Parent = ToggleFrame
                ToggleBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                ToggleBox.Position = UDim2.new(1, -40, 0.5, -10)
                ToggleBox.Size = UDim2.new(0, 30, 0, 20)
                
                BoxCorner.CornerRadius = UDim.new(0, 10)
                BoxCorner.Parent = ToggleBox
                
                BoxCheck.Parent = ToggleBox
                BoxCheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BoxCheck.Position = UDim2.new(0, 2, 0.5, -8)
                BoxCheck.Size = UDim2.new(0, 16, 0, 16)
                
                CheckCorner.CornerRadius = UDim.new(1, 0)
                CheckCorner.Parent = BoxCheck

                local Toggled = cftog.Default
                local function Update()
                    local targetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local targetColor = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(255, 255, 255)
                    Library:TweenInstance(BoxCheck, 0.2, "Position", targetPos)
                    Library:TweenInstance(BoxCheck, 0.2, "BackgroundColor3", targetColor)
                    pcall(cftog.Callback, Toggled)
                end

                ToggleBtn.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                Update()
                return { Set = function(self, val) Toggled = val Update() end }
            end

            function SectionFunc:AddSlider(cfslid)
                cfslid = Library:MakeConfig({ Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslid or {})
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderBtn = Instance.new("TextButton")

                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                
                SliderCorner.CornerRadius = UDim.new(0, 3)
                SliderCorner.Parent = SliderFrame
                
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 10, 0, 5)
                SliderTitle.Size = UDim2.new(1, -20, 0, 15)
                SliderTitle.Font = Enum.Font.Code
                SliderTitle.Text = cfslid.Title
                SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                SliderTitle.TextSize = 11
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0, 10, 0, 5)
                SliderValue.Size = UDim2.new(1, -20, 0, 15)
                SliderValue.Font = Enum.Font.Code
                SliderValue.Text = tostring(cfslid.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 11
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                SliderBar.Position = UDim2.new(0, 10, 0, 25)
                SliderBar.Size = UDim2.new(1, -20, 0, 10)
                
                BarCorner.CornerRadius = UDim.new(0, 10)
                BarCorner.Parent = SliderBar
                
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new((cfslid.Default - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0)
                
                FillCorner.CornerRadius = UDim.new(0, 10)
                FillCorner.Parent = SliderFill
                
                SliderBtn.Parent = SliderBar
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.Text = ""

                local Dragging = false
                local function Update()
                    local pos = math.clamp((game:GetService("UserInputService"):GetMouseLocation().X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(cfslid.Min + (cfslid.Max - cfslid.Min) * pos)
                    SliderValue.Text = tostring(val)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    pcall(cfslid.Callback, val)
                end

                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = true end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        Update()
                    end
                end)
                pcall(cfslid.Callback, cfslid.Default)
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

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                DropFrame.Size = UDim2.new(1, 0, 0, 32)
                
                DropCorner.CornerRadius = UDim.new(0, 3)
                DropCorner.Parent = DropFrame
                
                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 32)
                DropBtn.Text = ""
                
                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 10, 0, 0)
                DropTitle.Size = UDim2.new(1, -40, 0, 32)
                DropTitle.Font = Enum.Font.Code
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                DropTitle.TextSize = 11
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -30, 0, 0)
                DropIcon.Size = UDim2.new(0, 30, 0, 32)
                DropIcon.Font = Enum.Font.Arcade
                DropIcon.Text = ">"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 12

                local function CloseWazureDropdown()
                    Library:TweenInstance(DropdownPanel, 0.4, "Position", UDim2.new(1, 0, 0, 0), Enum.EasingStyle.Sine)
                    Library:TweenInstance(DropdownOverlay, 0.3, "BackgroundTransparency", 1, Enum.EasingStyle.Sine)
                    task.wait(0.4)
                    DropdownOverlay.Visible = false
                end

                local function OpenWazureDropdown()
                    for _, v in pairs(PanelScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    PanelTitle.Text = cfdrop.Title:upper()
                    DropdownOverlay.Visible = true
                    Library:TweenInstance(DropdownOverlay, 0.3, "BackgroundTransparency", 0.6, Enum.EasingStyle.Sine)
                    Library:TweenInstance(DropdownPanel, 0.5, "Position", UDim2.new(0.4, 0, 0, 0), Enum.EasingStyle.Back)

                    for _, opt in pairs(options) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = PanelScroll
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                        OptBtn.Size = UDim2.new(1, 0, 0, 35)
                        OptBtn.Font = Enum.Font.Code
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                        OptBtn.TextSize = 12
                        OptBtn.ZIndex = 53
                        
                        OptCorner.CornerRadius = UDim.new(0, 4)
                        OptCorner.Parent = OptBtn
                        
                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. " : " .. opt
                            pcall(cfdrop.Callback, opt)
                            CloseWazureDropdown()
                        end)
                    end
                end

                DropBtn.MouseButton1Click:Connect(OpenWazureDropdown)
                BackBtn.MouseButton1Click:Connect(CloseWazureDropdown)

                if cfdrop.Default ~= "" then pcall(cfdrop.Callback, cfdrop.Default) end
                return { 
                    Refresh = function(self, newopts) options = newopts end, 
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
                BoxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                BoxFrame.Size = UDim2.new(1, 0, 0, 32)
                
                BoxCorner.CornerRadius = UDim.new(0, 3)
                BoxCorner.Parent = BoxFrame
                
                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 10, 0, 0)
                BoxTitle.Size = UDim2.new(0, 100, 1, 0)
                BoxTitle.Font = Enum.Font.Code
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                BoxTitle.TextSize = 11
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                BoxInput.Position = UDim2.new(1, -130, 0.5, -11)
                BoxInput.Size = UDim2.new(0, 120, 0, 22)
                BoxInput.Font = Enum.Font.Code
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = ConfigWindow.AccentColor
                BoxInput.TextSize = 11
                
                InputCorner.CornerRadius = UDim.new(0, 2)
                InputCorner.Parent = BoxInput
                
                InputStroke.Color = Color3.fromRGB(50, 50, 70)
                InputStroke.Thickness = 1
                InputStroke.Parent = BoxInput

                BoxInput.FocusLost:Connect(function() pcall(cfbox.Callback, BoxInput.Text) end)
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Font = Enum.Font.Code
                Label.Text = "> " .. text
                Label.TextColor3 = Color3.fromRGB(150, 150, 170)
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = "> " .. val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")
                
                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                ParaFrame.Size = UDim2.new(1, 0, 0, 45)
                
                ParaCorner.CornerRadius = UDim.new(0, 3)
                ParaCorner.Parent = ParaFrame
                
                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 10, 0, 5)
                ParaTitle.Size = UDim2.new(1, -20, 0, 15)
                ParaTitle.Font = Enum.Font.Arcade
                ParaTitle.Text = cfpara.Title:upper()
                ParaTitle.TextColor3 = ConfigWindow.AccentColor
                ParaTitle.TextSize = 11
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 10, 0, 22)
                ParaContent.Size = UDim2.new(1, -20, 0, 18)
                ParaContent.Font = Enum.Font.Code
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(180, 180, 200)
                ParaContent.TextSize = 10
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true
                
                local function UpdateSize() 
                    local textHeight = ParaContent.TextBounds.Y 
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 30) 
                    ParaContent.Size = UDim2.new(1, -20, 0, textHeight) 
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
                DiscordCard.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                DiscordCard.Size = UDim2.new(1, 0, 0, 60)
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = DiscordCard
                
                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 10, 0, 10)
                Icon.Size = UDim2.new(0, 40, 0, 40)
                Icon.Image = "rbxassetid://11419713314"
                
                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 60, 0, 15)
                Title.Size = UDim2.new(1, -130, 0, 15)
                Title.Font = Enum.Font.Arcade
                Title.Text = (DiscordTitle or "Discord"):upper()
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 60, 0, 32)
                SubTitle.Size = UDim2.new(1, -130, 0, 15)
                SubTitle.Font = Enum.Font.Code
                SubTitle.Text = "Join community"
                SubTitle.TextColor3 = Color3.fromRGB(150, 150, 170)
                SubTitle.TextSize = 10
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = ConfigWindow.AccentColor
                JoinBtn.Position = UDim2.new(1, -70, 0, 15)
                JoinBtn.Size = UDim2.new(0, 60, 0, 30)
                JoinBtn.Font = Enum.Font.Arcade
                JoinBtn.Text = "JOIN"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 12
                
                BtnCorner.CornerRadius = UDim.new(0, 3)
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
                SeperatorFrame.Size = UDim2.new(1, 0, 0, 20)

                SeperatorLabel.Parent = SeperatorFrame
                SeperatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                SeperatorLabel.BackgroundTransparency = 1
                SeperatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                SeperatorLabel.Size = UDim2.new(0, 0, 1, 0)
                SeperatorLabel.AutomaticSize = Enum.AutomaticSize.X
                SeperatorLabel.Font = Enum.Font.Code
                SeperatorLabel.Text = text:upper()
                SeperatorLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
                SeperatorLabel.TextSize = 10

                LineLeft.Parent = SeperatorFrame
                LineLeft.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                LineLeft.BorderSizePixel = 0
                LineLeft.Position = UDim2.new(0, 0, 0.5, 0)
                LineLeft.Size = UDim2.new(0.5, -60, 0, 1)

                LineRight.Parent = SeperatorFrame
                LineRight.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                LineRight.BorderSizePixel = 0
                LineRight.Position = UDim2.new(1, 0, 0.5, 0)
                LineRight.AnchorPoint = Vector2.new(1, 0)
                LineRight.Size = UDim2.new(0.5, -60, 0, 1)
            end

            return SectionFunc
        end

        return TabFunc
    end

    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 20, 0, 20)
    MainBtn.Size = UDim2.new(0, 40, 0, 40)
    MainBtn.Image = "rbxassetid://101817370702077"
    
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn
    
    BtnStroke.Color = Color3.fromRGB(20, 20, 30)
    BtnStroke.Thickness = 2
    BtnStroke.Parent = MainBtn
    
    self:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)

    return Tab
end

return Library
