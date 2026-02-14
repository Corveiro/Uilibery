local Library = {}

-- [ Utility Functions ] --
function Library:TweenInstance(Instance, Time, OldValue, NewValue)
    local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Enum.EasingStyle.Back), { [OldValue] = NewValue })
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
        Title = "ARCADE HUB",
        Description = "Retro Edition",
        AccentColor = Color3.fromRGB(255, 0, 0) -- Cor padrão alterada para VERMELHO
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

    TeddyUI_Premium.Name = "ArcadeUI"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 440, 0, 320) -- Ajustado para garantir espaço

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

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

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:TweenInstance(v.TextLabel, 0.2, "TextColor3", Color3.fromRGB(100, 100, 120))
                    Library:TweenInstance(v.Indicator, 0.2, "Transparency", 1)
                end
            end
            Library:TweenInstance(TabBtnTitle, 0.2, "TextColor3", Color3.fromRGB(255, 255, 255))
            Library:TweenInstance(TabIndicator, 0.2, "Transparency", 0)
            PageLayout:JumpToIndex(TabBtn.LayoutOrder)
        end)

        if FirstTab then
            FirstTab = false
            TabBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIndicator.Transparency = 0
        end

        TabCount = TabCount + 1
        local TabFunc = {}

        function TabFunc:AddSection(SectionTitle)
            local SectionFrame = Instance.new("Frame")
            local SectionTitleLabel = Instance.new("TextLabel")
            local CurrentGroup = Instance.new("Frame")
            local GroupLayout = Instance.new("UIListLayout")
            
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            SectionTitleLabel.Parent = SectionFrame
            SectionTitleLabel.BackgroundTransparency = 1
            SectionTitleLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionTitleLabel.Font = Enum.Font.Arcade
            SectionTitleLabel.Text = ">> " .. SectionTitle:upper()
            SectionTitleLabel.TextColor3 = ConfigWindow.AccentColor
            SectionTitleLabel.TextSize = 11
            SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

            CurrentGroup.Parent = SectionFrame
            CurrentGroup.BackgroundTransparency = 1
            CurrentGroup.Position = UDim2.new(0, 0, 0, 22)
            CurrentGroup.Size = UDim2.new(1, 0, 0, 0)
            CurrentGroup.AutomaticSize = Enum.AutomaticSize.Y
            
            GroupLayout.Parent = CurrentGroup
            GroupLayout.Padding = UDim.new(0, 5)
            GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local SectionFunc = {}

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Callback = function() end }, cfbtn or {})
                local BtnFrame = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnTitle = Instance.new("TextLabel")
                
                BtnFrame.Parent = CurrentGroup
                BtnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                BtnFrame.Size = UDim2.new(1, 0, 0, 32)
                BtnFrame.Text = ""
                BtnFrame.AutoButtonColor = false
                
                BtnCorner.CornerRadius = UDim.new(0, 3)
                BtnCorner.Parent = BtnFrame
                
                BtnStroke.Color = Color3.fromRGB(45, 45, 60)
                BtnStroke.Thickness = 1
                BtnStroke.Parent = BtnFrame
                
                BtnTitle.Parent = BtnFrame
                BtnTitle.BackgroundTransparency = 1
                BtnTitle.Size = UDim2.new(1, 0, 1, 0)
                BtnTitle.Font = Enum.Font.Code
                BtnTitle.Text = cfbtn.Title
                BtnTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                BtnTitle.TextSize = 12

                BtnFrame.MouseButton1Click:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.1, "BackgroundColor3", ConfigWindow.AccentColor)
                    task.wait(0.1)
                    Library:TweenInstance(BtnFrame, 0.2, "BackgroundColor3", Color3.fromRGB(25, 25, 40))
                    pcall(cfbtn.Callback)
                end)
                return { Set = function(self, val) BtnTitle.Text = val end }
            end

            function SectionFunc:AddToggle(cftog)
                cftog = Library:MakeConfig({ Title = "Toggle", Default = false, Callback = function() end }, cftog or {})
                local Toggled = cftog.Default
                local TogFrame = Instance.new("TextButton")
                local TogCorner = Instance.new("UICorner")
                local TogTitle = Instance.new("TextLabel")
                local TogStatus = Instance.new("Frame")
                local StatusCorner = Instance.new("UICorner")
                local StatusStroke = Instance.new("UIStroke")

                TogFrame.Parent = CurrentGroup
                TogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                TogFrame.Size = UDim2.new(1, 0, 0, 32)
                TogFrame.Text = ""
                
                TogCorner.CornerRadius = UDim.new(0, 3)
                TogCorner.Parent = TogFrame
                
                TogTitle.Parent = TogFrame
                TogTitle.BackgroundTransparency = 1
                TogTitle.Position = UDim2.new(0, 10, 0, 0)
                TogTitle.Size = UDim2.new(1, -50, 1, 0)
                TogTitle.Font = Enum.Font.Code
                TogTitle.Text = cftog.Title
                TogTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                TogTitle.TextSize = 12
                TogTitle.TextXAlignment = Enum.TextXAlignment.Left

                TogStatus.Parent = TogFrame
                TogStatus.AnchorPoint = Vector2.new(0, 0.5)
                TogStatus.BackgroundColor3 = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(40, 40, 50)
                TogStatus.Position = UDim2.new(1, -35, 0.5, 0)
                TogStatus.Size = UDim2.new(0, 25, 0, 12)
                
                StatusCorner.CornerRadius = UDim.new(1, 0)
                StatusCorner.Parent = TogStatus
                
                StatusStroke.Color = Color3.fromRGB(60, 60, 75)
                StatusStroke.Thickness = 1
                StatusStroke.Parent = TogStatus

                local function Update()
                    Library:TweenInstance(TogStatus, 0.2, "BackgroundColor3", Toggled and ConfigWindow.AccentColor or Color3.fromRGB(40, 40, 50))
                    pcall(cftog.Callback, Toggled)
                end

                TogFrame.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    Update()
                end)
                pcall(cftog.Callback, Toggled)
                return { Set = function(self, val) Toggled = val Update() end }
            end

            function SectionFunc:AddSlider(cfslid)
                cfslid = Library:MakeConfig({ Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslid or {})
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local SliderBarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local SliderFillCorner = Instance.new("UICorner")
                local SliderBtn = Instance.new("TextButton")

                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                
                SliderCorner.CornerRadius = UDim.new(0, 3)
                SliderCorner.Parent = SliderFrame
                
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 10, 0, 6)
                SliderTitle.Size = UDim2.new(0.5, 0, 0, 15)
                SliderTitle.Font = Enum.Font.Code
                SliderTitle.Text = cfslid.Title
                SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                SliderTitle.TextSize = 11
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0.5, 0, 0, 6)
                SliderValue.Size = UDim2.new(0.5, -10, 0, 15)
                SliderValue.Font = Enum.Font.Code
                SliderValue.Text = tostring(cfslid.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 11
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                SliderBar.Position = UDim2.new(0, 10, 0, 28)
                SliderBar.Size = UDim2.new(1, -20, 0, 6)
                
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new((cfslid.Default - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0)
                
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill

                SliderBtn.Parent = SliderBar
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.Text = ""

                local function Move()
                    local MousePos = game:GetService("Players").LocalPlayer:GetMouse().X
                    local RelativePos = MousePos - SliderBar.AbsolutePosition.X
                    local Percentage = math.clamp(RelativePos / SliderBar.AbsoluteSize.X, 0, 1)
                    local Value = math.floor(cfslid.Min + (cfslid.Max - cfslid.Min) * Percentage)
                    SliderValue.Text = tostring(Value)
                    SliderFill.Size = UDim2.new(Percentage, 0, 1, 0)
                    pcall(cfslid.Callback, Value)
                end

                local Dragging = false
                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        Move()
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        Move()
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
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                DropFrame.Size = UDim2.new(1, 0, 0, 32)
                DropFrame.ClipsDescendants = true
                
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
                DropIcon.Text = "+"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 14

                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 32)
                DropList.Size = UDim2.new(1, 0, 0, 0)
                
                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 4)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 5)
                DropPadding.PaddingLeft = UDim.new(0, 5)
                DropPadding.PaddingRight = UDim.new(0, 5)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 38) or 32
                    Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize))
                    DropIcon.Text = Open and "-" or "+"
                end
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                        OptBtn.Size = UDim2.new(1, 0, 0, 28)
                        OptBtn.Font = Enum.Font.Code
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptBtn.TextSize = 11
                        
                        OptCorner.CornerRadius = UDim.new(0, 2)
                        OptCorner.Parent = OptBtn
                        
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
                Icon.Image = "rbxassetid://123256573634"
                
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

            -- Adicionando o método AddSeperator que estava faltando
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
