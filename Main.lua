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

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "SYNTRAX Hub",
        Description = "Premium Script",
        AccentColor = Color3.fromRGB(0, 162, 255)
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
    local Sidebar = Instance.new("Frame")
    local SidebarCorner = Instance.new("UICorner")
    local SidebarScroll = Instance.new("ScrollingFrame")
    local SidebarList = Instance.new("UIListLayout")
    local SidebarPadding = Instance.new("UIPadding")
    
    local PageFrame = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")
    
    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Dimensões menores e proporcionais
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 480, 0, 320)

    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 40, 1, 40)
    DropShadow.Image = "rbxassetid://6014261993"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.Thickness = 1.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Main

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Top.Size = UDim2.new(1, 0, 0, 40)

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 10, 0, 8)
    LogoHub.Size = UDim2.new(0, 24, 0, 24)
    LogoHub.Image = "rbxassetid://101817370702077"

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 40, 0, 6)
    NameHub.Size = UDim2.new(0, 200, 0, 16)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 14
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 40, 0, 22)
    Desc.Size = UDim2.new(0, 200, 0, 10)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -100, 0, 0)
    RightButtons.Size = UDim2.new(0, 90, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 10)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "✕"
    Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Close.TextSize = 14

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 20, 0, 20)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "—"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 200)
    Minize.TextSize = 14

    BackBtn.Name = "BackBtn"
    BackBtn.Parent = RightButtons
    BackBtn.BackgroundTransparency = 1
    BackBtn.Size = UDim2.new(0, 40, 0, 20)
    BackBtn.Font = Enum.Font.GothamBold
    BackBtn.Text = "Back"
    BackBtn.TextColor3 = ConfigWindow.AccentColor
    BackBtn.TextSize = 11
    BackBtn.Visible = false

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)

    -- Sidebar para Tabs (Scroll Vertical)
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = ContentFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    
    SidebarCorner.CornerRadius = UDim.new(0, 0)
    SidebarCorner.Parent = Sidebar
    
    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Color3.fromRGB(30, 30, 30)
    SidebarStroke.Thickness = 1
    SidebarStroke.Parent = Sidebar

    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Parent = Sidebar
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    SidebarList.Parent = SidebarScroll
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder

    SidebarPadding.Parent = SidebarScroll
    SidebarPadding.PaddingLeft = UDim.new(0, 8)
    SidebarPadding.PaddingRight = UDim.new(0, 8)
    SidebarPadding.PaddingTop = UDim.new(0, 10)

    PageFrame.Name = "PageFrame"
    PageFrame.Parent = ContentFrame
    PageFrame.BackgroundTransparency = 1
    PageFrame.Position = UDim2.new(0, 130, 0, 0)
    PageFrame.Size = UDim2.new(1, -130, 1, 0)
    PageFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = PageFrame
    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quad
    PageLayout.TweenTime = 0.3

    -- HomeTab compatível com API (mesmo que mude o layout, deve existir)
    local HomeTab = Instance.new("ScrollingFrame")
    HomeTab.Name = "Home"
    HomeTab.Parent = PageList
    HomeTab.BackgroundTransparency = 1
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.ScrollBarThickness = 0
    HomeTab.LayoutOrder = 0
    HomeTab.Visible = false -- Na nova versão, as tabs são acessadas diretamente na sidebar

    self:MakeDraggable(Top, DropShadowHolder)

    Close.MouseButton1Click:Connect(function() TeddyUI_Premium:Destroy() end)
    Minize.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = false end)
    BackBtn.MouseButton1Click:Connect(function() PageLayout:JumpToIndex(0) BackBtn.Visible = false end)

    local TabCount = 1
    local Tab = {}

    function Tab:T(t, iconid)
        local TabPage = Instance.new("ScrollingFrame")
        local TabListLayout = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")
        
        TabPage.Name = t
        TabPage.Parent = PageList
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = ConfigWindow.AccentColor
        TabPage.LayoutOrder = TabCount
        
        TabListLayout.Parent = TabPage
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding.Parent = TabPage
        TabPadding.PaddingLeft = UDim.new(0, 12)
        TabPadding.PaddingRight = UDim.new(0, 12)
        TabPadding.PaddingTop = UDim.new(0, 12)
        TabPadding.PaddingBottom = UDim.new(0, 12)

        Library:UpdateScrolling(TabPage, TabListLayout)

        -- Botão da Tab na Sidebar (Novo design)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local TabBtnIcon = Instance.new("ImageLabel")
        local TabBtnTitle = Instance.new("TextLabel")
        local TabBtnStroke = Instance.new("UIStroke")

        TabBtn.Name = t .. "_Btn"
        TabBtn.Parent = SidebarScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.Text = ""
        TabBtn.LayoutOrder = TabCount
        
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn
        
        TabBtnStroke.Color = ConfigWindow.AccentColor
        TabBtnStroke.Thickness = 1.2
        TabBtnStroke.Transparency = 1
        TabBtnStroke.Parent = TabBtn

        TabBtnIcon.Parent = TabBtn
        TabBtnIcon.BackgroundTransparency = 1
        TabBtnIcon.Position = UDim2.new(0, 8, 0.5, -9)
        TabBtnIcon.Size = UDim2.new(0, 18, 0, 18)
        TabBtnIcon.Image = iconid or "rbxassetid://10709770533"
        TabBtnIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)

        TabBtnTitle.Parent = TabBtn
        TabBtnTitle.BackgroundTransparency = 1
        TabBtnTitle.Position = UDim2.new(0, 34, 0, 0)
        TabBtnTitle.Size = UDim2.new(1, -38, 1, 0)
        TabBtnTitle.Font = Enum.Font.GothamMedium
        TabBtnTitle.Text = t
        TabBtnTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtnTitle.TextSize = 12
        TabBtnTitle.TextXAlignment = Enum.TextXAlignment.Left

        local function SelectTab()
            for _, v in pairs(SidebarScroll:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:TweenInstance(v, 0.3, "BackgroundTransparency", 1)
                    Library:TweenInstance(v.UIStroke, 0.3, "Transparency", 1)
                    Library:TweenInstance(v.TextLabel, 0.3, "TextColor3", Color3.fromRGB(180, 180, 180))
                    Library:TweenInstance(v.ImageLabel, 0.3, "ImageColor3", Color3.fromRGB(180, 180, 180))
                end
            end
            Library:TweenInstance(TabBtn, 0.3, "BackgroundTransparency", 0.9)
            Library:TweenInstance(TabBtnStroke, 0.3, "Transparency", 0)
            Library:TweenInstance(TabBtnTitle, 0.3, "TextColor3", Color3.fromRGB(255, 255, 255))
            Library:TweenInstance(TabBtnIcon, 0.3, "ImageColor3", ConfigWindow.AccentColor)
            PageLayout:JumpTo(TabPage)
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)
        if TabCount == 1 then SelectTab() end

        TabCount = TabCount + 1
        Library:UpdateScrolling(SidebarScroll, SidebarList)

        local TabFunc = {}
        function TabFunc:AddSection(SectionTitle)
            local SectionFrame = Instance.new("Frame")
            local SectionTitleLabel = Instance.new("TextLabel")
            local SectionContainer = Instance.new("Frame")
            local SectionList = Instance.new("UIListLayout")
            
            SectionFrame.Name = SectionTitle .. "_Section"
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            
            SectionTitleLabel.Parent = SectionFrame
            SectionTitleLabel.BackgroundTransparency = 1
            SectionTitleLabel.Position = UDim2.new(0, 4, 0, 0)
            SectionTitleLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionTitleLabel.Font = Enum.Font.GothamBold
            SectionTitleLabel.Text = SectionTitle:upper()
            SectionTitleLabel.TextColor3 = ConfigWindow.AccentColor
            SectionTitleLabel.TextSize = 11
            SectionTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionContainer.Name = "Container"
            SectionContainer.Parent = SectionFrame
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 0, 0, 25)
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            
            SectionList.Parent = SectionContainer
            SectionList.Padding = UDim.new(0, 6)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContainer.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 30)
            end)

            local SectionFunc = {}
            local CurrentGroup = SectionContainer

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Callback = function() end }, cfbtn or {})
                local BtnFrame = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnTitle = Instance.new("TextLabel")
                local BtnIcon = Instance.new("ImageLabel")

                BtnFrame.Name = cfbtn.Title
                BtnFrame.Parent = CurrentGroup
                BtnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                BtnFrame.Size = UDim2.new(1, 0, 0, 34)
                BtnFrame.AutoButtonColor = false
                BtnFrame.Text = ""
                
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = BtnFrame
                
                BtnStroke.Color = Color3.fromRGB(40, 40, 40)
                BtnStroke.Thickness = 1
                BtnStroke.Parent = BtnFrame

                BtnTitle.Parent = BtnFrame
                BtnTitle.BackgroundTransparency = 1
                BtnTitle.Position = UDim2.new(0, 12, 0, 0)
                BtnTitle.Size = UDim2.new(1, -40, 1, 0)
                BtnTitle.Font = Enum.Font.GothamMedium
                BtnTitle.Text = cfbtn.Title
                BtnTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BtnTitle.TextSize = 12
                BtnTitle.TextXAlignment = Enum.TextXAlignment.Left

                BtnIcon.Parent = BtnFrame
                BtnIcon.BackgroundTransparency = 1
                BtnIcon.Position = UDim2.new(1, -28, 0.5, -8)
                BtnIcon.Size = UDim2.new(0, 16, 0, 16)
                BtnIcon.Image = "rbxassetid://10709767643"
                BtnIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

                BtnFrame.MouseButton1Click:Connect(function()
                    Library:TweenInstance(BtnFrame, 0.1, "BackgroundColor3", Color3.fromRGB(30, 30, 30))
                    task.wait(0.1)
                    Library:TweenInstance(BtnFrame, 0.1, "BackgroundColor3", Color3.fromRGB(20, 20, 20))
                    pcall(cfbtn.Callback)
                end)
                
                BtnFrame.MouseEnter:Connect(function()
                    Library:TweenInstance(BtnStroke, 0.2, "Color", ConfigWindow.AccentColor)
                end)
                BtnFrame.MouseLeave:Connect(function()
                    Library:TweenInstance(BtnStroke, 0.2, "Color", Color3.fromRGB(40, 40, 40))
                end)
            end

            function SectionFunc:AddToggle(cftog)
                cftog = Library:MakeConfig({ Title = "Toggle", Default = false, Callback = function() end }, cftog or {})
                local TogFrame = Instance.new("TextButton")
                local TogCorner = Instance.new("UICorner")
                local TogTitle = Instance.new("TextLabel")
                local TogBox = Instance.new("Frame")
                local TogBoxCorner = Instance.new("UICorner")
                local TogDot = Instance.new("Frame")
                local TogDotCorner = Instance.new("UICorner")

                TogFrame.Parent = CurrentGroup; TogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); TogFrame.Size = UDim2.new(1, 0, 0, 34); TogFrame.Text = ""; TogCorner.CornerRadius = UDim.new(0, 6); TogCorner.Parent = TogFrame
                TogTitle.Parent = TogFrame; TogTitle.BackgroundTransparency = 1; TogTitle.Position = UDim2.new(0, 12, 0, 0); TogTitle.Size = UDim2.new(1, -60, 1, 0); TogTitle.Font = Enum.Font.GothamMedium; TogTitle.Text = cftog.Title; TogTitle.TextColor3 = Color3.fromRGB(230, 230, 230); TogTitle.TextSize = 12; TogTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                TogBox.Parent = TogFrame; TogBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TogBox.Position = UDim2.new(1, -45, 0.5, -9); TogBox.Size = UDim2.new(0, 34, 0, 18); TogBoxCorner.CornerRadius = UDim.new(1, 0); TogBoxCorner.Parent = TogBox
                TogDot.Parent = TogBox; TogDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200); TogDot.Position = UDim2.new(0, 2, 0.5, -7); TogDot.Size = UDim2.new(0, 14, 0, 14); TogDotCorner.CornerRadius = UDim.new(1, 0); TogDotCorner.Parent = TogDot

                local Toggled = cftog.Default
                local function Update()
                    local targetPos = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local targetColor = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(35, 35, 35)
                    Library:TweenInstance(TogDot, 0.2, "Position", targetPos)
                    Library:TweenInstance(TogBox, 0.2, "BackgroundColor3", targetColor)
                    pcall(cftog.Callback, Toggled)
                end
                TogFrame.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                Update()
                return { Set = function(self, val) Toggled = val Update() end }
            end

            function SectionFunc:AddSlider(cfslid)
                cfslid = Library:MakeConfig({ Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslid or {})
                local SlidFrame = Instance.new("Frame")
                local SlidCorner = Instance.new("UICorner")
                local SlidTitle = Instance.new("TextLabel")
                local SlidVal = Instance.new("TextLabel")
                local SlidBar = Instance.new("Frame")
                local SlidBarCorner = Instance.new("UICorner")
                local SlidFill = Instance.new("Frame")
                local SlidFillCorner = Instance.new("UICorner")
                local SlidBtn = Instance.new("TextButton")

                SlidFrame.Parent = CurrentGroup; SlidFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SlidFrame.Size = UDim2.new(1, 0, 0, 45); SlidCorner.CornerRadius = UDim.new(0, 6); SlidCorner.Parent = SlidFrame
                SlidTitle.Parent = SlidFrame; SlidTitle.BackgroundTransparency = 1; SlidTitle.Position = UDim2.new(0, 12, 0, 8); SlidTitle.Size = UDim2.new(1, -60, 0, 12); SlidTitle.Font = Enum.Font.GothamMedium; SlidTitle.Text = cfslid.Title; SlidTitle.TextColor3 = Color3.fromRGB(230, 230, 230); SlidTitle.TextSize = 12; SlidTitle.TextXAlignment = Enum.TextXAlignment.Left
                SlidVal.Parent = SlidFrame; SlidVal.BackgroundTransparency = 1; SlidVal.Position = UDim2.new(1, -60, 0, 8); SlidVal.Size = UDim2.new(0, 50, 0, 12); SlidVal.Font = Enum.Font.GothamBold; SlidVal.Text = tostring(cfslid.Default); SlidVal.TextColor3 = ConfigWindow.AccentColor; SlidVal.TextSize = 12; SlidVal.TextXAlignment = Enum.TextXAlignment.Right
                
                SlidBar.Parent = SlidFrame; SlidBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); SlidBar.Position = UDim2.new(0, 12, 0, 30); SlidBar.Size = UDim2.new(1, -24, 0, 6); SlidBarCorner.CornerRadius = UDim.new(1, 0); SlidBarCorner.Parent = SlidBar
                SlidFill.Parent = SlidBar; SlidFill.BackgroundColor3 = ConfigWindow.AccentColor; SlidFill.Size = UDim2.new((cfslid.Default - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0); SlidFillCorner.CornerRadius = UDim.new(1, 0); SlidFillCorner.Parent = SlidFill
                SlidBtn.Parent = SlidBar; SlidBtn.BackgroundTransparency = 1; SlidBtn.Size = UDim2.new(1, 0, 1, 0); SlidBtn.Text = ""

                local Dragging = false
                local function Update(input)
                    local pos = math.clamp((input.Position.X - SlidBar.AbsolutePosition.X) / SlidBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(cfslid.Min + (cfslid.Max - cfslid.Min) * pos)
                    SlidVal.Text = tostring(val)
                    Library:TweenInstance(SlidFill, 0.1, "Size", UDim2.new(pos, 0, 1, 0))
                    pcall(cfslid.Callback, val)
                end
                SlidBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = true Update(input) end end)
                game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
                game:GetService("UserInputService").InputChanged:Connect(function(input) if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end end)
                
                return { Set = function(self, val) local pos = math.clamp((val - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1) SlidVal.Text = tostring(val) Library:TweenInstance(SlidFill, 0.1, "Size", UDim2.new(pos, 0, 1, 0)) pcall(cfslid.Callback, val) end }
            end

            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({ Title = "Dropdown", Default = "", Options = {}, Callback = function() end }, cfdrop or {})
                local options = cfdrop.Options or {}
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("ImageLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Parent = CurrentGroup; DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); DropFrame.Size = UDim2.new(1, 0, 0, 34); DropFrame.ClipsDescendants = true; DropCorner.CornerRadius = UDim.new(0, 6); DropCorner.Parent = DropFrame
                DropBtn.Parent = DropFrame; DropBtn.BackgroundTransparency = 1; DropBtn.Size = UDim2.new(1, 0, 0, 34); DropBtn.Text = ""
                DropTitle.Parent = DropFrame; DropTitle.BackgroundTransparency = 1; DropTitle.Position = UDim2.new(0, 12, 0, 0); DropTitle.Size = UDim2.new(1, -40, 0, 34); DropTitle.Font = Enum.Font.GothamMedium; DropTitle.Text = cfdrop.Title .. ": " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default)); DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230); DropTitle.TextSize = 12; DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropIcon.Parent = DropFrame; DropIcon.BackgroundTransparency = 1; DropIcon.Position = UDim2.new(1, -28, 0, 9); DropIcon.Size = UDim2.new(0, 16, 0, 16); DropIcon.Image = "rbxassetid://10709790932"; DropIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
                DropList.Parent = DropFrame; DropList.BackgroundTransparency = 1; DropList.Position = UDim2.new(0, 0, 0, 34); DropList.Size = UDim2.new(1, 0, 0, 0); DropListLayout.Parent = DropList; DropListLayout.Padding = UDim.new(0, 4); DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder; DropPadding.Parent = DropList; DropPadding.PaddingBottom = UDim.new(0, 5); DropPadding.PaddingLeft = UDim.new(0, 5); DropPadding.PaddingRight = UDim.new(0, 5)

                local Open = false
                local function ToggleDrop() 
                    Open = not Open 
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 40) or 34 
                    Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize)) 
                    Library:TweenInstance(DropIcon, 0.3, "Rotation", Open and 180 or 0)
                end
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList; OptBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); OptBtn.Size = UDim2.new(1, 0, 0, 28); OptBtn.Font = Enum.Font.Gotham; OptBtn.Text = opt; OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200); OptBtn.TextSize = 11; OptCorner.CornerRadius = UDim.new(0, 4); OptCorner.Parent = OptBtn
                        OptBtn.MouseButton1Click:Connect(function() DropTitle.Text = cfdrop.Title .. ": " .. opt ToggleDrop() pcall(cfdrop.Callback, opt) end)
                    end
                end
                AddOptions(options)
                if cfdrop.Default ~= "" then pcall(cfdrop.Callback, cfdrop.Default) end
                return { Refresh = function(self, newopts) for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOptions(newopts) end, Set = function(self, val) DropTitle.Text = cfdrop.Title .. ": " .. tostring(val) pcall(cfdrop.Callback, val) end }
            end

            function SectionFunc:AddTextbox(cfbox)
                cfbox = Library:MakeConfig({ Title = "Textbox", Description = "", Default = "", Callback = function() end }, cfbox or {})
                local BoxFrame = Instance.new("Frame")
                local BoxCorner = Instance.new("UICorner")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                local InputStroke = Instance.new("UIStroke")

                BoxFrame.Parent = CurrentGroup; BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); BoxFrame.Size = UDim2.new(1, 0, 0, 34); BoxCorner.CornerRadius = UDim.new(0, 6); BoxCorner.Parent = BoxFrame
                BoxTitle.Parent = BoxFrame; BoxTitle.BackgroundTransparency = 1; BoxTitle.Position = UDim2.new(0, 12, 0, 0); BoxTitle.Size = UDim2.new(0, 100, 1, 0); BoxTitle.Font = Enum.Font.GothamMedium; BoxTitle.Text = cfbox.Title; BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230); BoxTitle.TextSize = 12; BoxTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                BoxInput.Parent = BoxFrame; BoxInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15); BoxInput.Position = UDim2.new(1, -130, 0.5, -11); BoxInput.Size = UDim2.new(0, 120, 0, 22); BoxInput.Font = Enum.Font.Gotham; BoxInput.Text = cfbox.Default; BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255); BoxInput.TextSize = 11; InputCorner.CornerRadius = UDim.new(0, 4); InputCorner.Parent = BoxInput
                InputStroke.Color = Color3.fromRGB(40, 40, 40); InputStroke.Thickness = 1; InputStroke.Parent = BoxInput
                
                BoxInput.FocusLost:Connect(function() pcall(cfbox.Callback, BoxInput.Text) end)
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Font = Enum.Font.Gotham; Label.Text = text; Label.TextColor3 = Color3.fromRGB(160, 160, 160); Label.TextSize = 11; Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")

                ParaFrame.Parent = CurrentGroup; ParaFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ParaFrame.Size = UDim2.new(1, 0, 0, 50); ParaCorner.CornerRadius = UDim.new(0, 6); ParaCorner.Parent = ParaFrame
                ParaTitle.Parent = ParaFrame; ParaTitle.BackgroundTransparency = 1; ParaTitle.Position = UDim2.new(0, 10, 0, 8); ParaTitle.Size = UDim2.new(1, -20, 0, 14); ParaTitle.Font = Enum.Font.GothamBold; ParaTitle.Text = cfpara.Title; ParaTitle.TextColor3 = Color3.fromRGB(255, 255, 255); ParaTitle.TextSize = 12; ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.Parent = ParaFrame; ParaContent.BackgroundTransparency = 1; ParaContent.Position = UDim2.new(0, 10, 0, 24); ParaContent.Size = UDim2.new(1, -20, 0, 18); ParaContent.Font = Enum.Font.Gotham; ParaContent.Text = contentText; ParaContent.TextColor3 = Color3.fromRGB(140, 140, 140); ParaContent.TextSize = 10; ParaContent.TextXAlignment = Enum.TextXAlignment.Left; ParaContent.TextWrapped = true
                
                local function UpdateSize() local textHeight = ParaContent.TextBounds.Y ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 32) ParaContent.Size = UDim2.new(1, -20, 0, textHeight) end
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

                DiscordCard.Parent = CurrentGroup; DiscordCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20); DiscordCard.Size = UDim2.new(1, 0, 0, 60); UICorner.CornerRadius = UDim.new(0, 8); UICorner.Parent = DiscordCard
                Icon.Parent = DiscordCard; Icon.BackgroundTransparency = 1; Icon.Position = UDim2.new(0, 10, 0, 10); Icon.Size = UDim2.new(0, 40, 0, 40); Icon.Image = "rbxassetid://101817370702077"
                Title.Parent = DiscordCard; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 60, 0, 14); Title.Size = UDim2.new(1, -130, 0, 16); Title.Font = Enum.Font.GothamBold; Title.Text = DiscordTitle or "Discord Server"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
                SubTitle.Parent = DiscordCard; SubTitle.BackgroundTransparency = 1; SubTitle.Position = UDim2.new(0, 60, 0, 30); SubTitle.Size = UDim2.new(1, -130, 0, 16); SubTitle.Font = Enum.Font.Gotham; SubTitle.Text = "Click to join us"; SubTitle.TextColor3 = Color3.fromRGB(160, 160, 160); SubTitle.TextSize = 10; SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                JoinBtn.Parent = DiscordCard; JoinBtn.BackgroundColor3 = ConfigWindow.AccentColor; JoinBtn.Position = UDim2.new(1, -70, 0, 15); JoinBtn.Size = UDim2.new(0, 60, 0, 30); JoinBtn.Font = Enum.Font.GothamBold; JoinBtn.Text = "Join"; JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); JoinBtn.TextSize = 12; BtnCorner.CornerRadius = UDim.new(0, 6); BtnCorner.Parent = JoinBtn
                
                JoinBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard("https://discord.gg/" .. InviteCode) end JoinBtn.Text = "Copied!" task.wait(2) JoinBtn.Text = "Join" end)
            end

            return SectionFunc
        end

        return TabFunc
    end

    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    ToggleBtn.Name = "ToggleUI"; ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    MainBtn.Parent = ToggleBtn; MainBtn.BackgroundColor3 = ConfigWindow.AccentColor; MainBtn.Position = UDim2.new(0, 20, 0, 20); MainBtn.Size = UDim2.new(0, 40, 0, 40); MainBtn.Image = "rbxassetid://101817370702077"
    BtnCorner.CornerRadius = UDim.new(1, 0); BtnCorner.Parent = MainBtn
    BtnStroke.Color = Color3.fromRGB(20, 20, 20); BtnStroke.Thickness = 2; BtnStroke.Parent = MainBtn
    self:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)

    return Tab
end

return Library
