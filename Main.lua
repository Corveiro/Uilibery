local Library = {}

-- [ Utility Functions ] --
function Library:TweenInstance(Instance, Time, OldValue, NewValue)
    local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Enum.EasingStyle.Quad), { [OldValue] = NewValue })
    rz_Tween:Play()
    return rz_Tween
end

function Library:UpdateContent(Content, Title, Object)
    if Content.Text ~= "" then
        Title.Position = UDim2.new(0, 10, 0, 7)
        Title.Size = UDim2.new(1, -60, 0, 16)
        local MaxY = math.max(Content.TextBounds.Y + 15, 45)
        Object.Size = UDim2.new(1, 0, 0, MaxY)
    end
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

function Library:MakeResizable(object, minSize)
    local ResizeBtn = Instance.new("ImageButton")
    ResizeBtn.Name = "ResizeBtn"
    ResizeBtn.Parent = object
    ResizeBtn.AnchorPoint = Vector2.new(1, 1)
    ResizeBtn.Position = UDim2.new(1, -2, 1, -2)
    ResizeBtn.Size = UDim2.new(0, 15, 0, 15)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Image = "rbxassetid://10131441151"
    ResizeBtn.ImageColor3 = Color3.fromRGB(180, 180, 180)
    ResizeBtn.ZIndex = 10

    local Resizing = false
    local ResizeStart = nil
    local StartSize = nil

    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
            ResizeStart = input.Position
            StartSize = object.AbsoluteSize
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - ResizeStart
            local NewWidth = math.max(minSize.X, StartSize.X + Delta.X)
            local NewHeight = math.max(minSize.Y, StartSize.Y + Delta.Y)
            object.Size = UDim2.new(0, NewWidth, 0, NewHeight)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
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
    
    local Sidebar = Instance.new("Frame")
    local SidebarList = Instance.new("ScrollingFrame")
    local SidebarLayout = Instance.new("UIListLayout")
    local SidebarPadding = Instance.new("UIPadding")
    
    local ContentFrame = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PageList = Instance.new("Folder")
    
    local HomeTab = Instance.new("ScrollingFrame")
    local HomeGridLayout = Instance.new("UIGridLayout")
    local HomePadding = Instance.new("UIPadding")

    -- Setup ScreenGui
    TeddyUI_Premium.Name = "TeddyUI_Premium"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Shadow & Main Frame
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 600, 0, 400)

    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.Image = "rbxassetid://6015897843"
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

    UIStroke.Color = Color3.fromRGB(30, 30, 30)
    UIStroke.Thickness = 1
    UIStroke.Parent = Main

    -- Top Bar
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Top.Size = UDim2.new(1, 0, 0, 50)

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 15, 0, 7)
    LogoHub.Size = UDim2.new(0, 35, 0, 35)
    LogoHub.Image = "rbxassetid://123256573634"

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 60, 0, 8)
    NameHub.Size = UDim2.new(0, 200, 0, 20)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 16
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 60, 0, 26)
    Desc.Size = UDim2.new(0, 200, 0, 15)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -80, 0, 0)
    RightButtons.Size = UDim2.new(0, 80, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 10)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 14

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 30, 0, 30)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "-"
    Minize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minize.TextSize = 20

    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 160, 1, -50)

    SidebarList.Name = "SidebarList"
    SidebarList.Parent = Sidebar
    SidebarList.BackgroundTransparency = 1
    SidebarList.Size = UDim2.new(1, 0, 1, 0)
    SidebarList.ScrollBarThickness = 0

    SidebarLayout.Parent = SidebarList
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    SidebarPadding.Parent = SidebarList
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.PaddingTop = UDim.new(0, 10)

    -- Content Area
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 160, 0, 50)
    ContentFrame.Size = UDim2.new(1, -160, 1, -50)
    ContentFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame

    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quad
    PageLayout.TweenTime = 0.4

    -- Home Tab (Card System)
    HomeTab.Name = "Home"
    HomeTab.Parent = PageList
    HomeTab.BackgroundTransparency = 1
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.ScrollBarThickness = 0
    HomeTab.LayoutOrder = 0

    HomeGridLayout.Parent = HomeTab
    HomeGridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
    HomeGridLayout.CellSize = UDim2.new(0, 130, 0, 130)
    HomeGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    HomePadding.Parent = HomeTab
    HomePadding.PaddingLeft = UDim.new(0, 15)
    HomePadding.PaddingTop = UDim.new(0, 15)

    -- Home Sidebar Button
    local HomeBtn = Instance.new("TextButton")
    local HomeCorner = Instance.new("UICorner")
    HomeBtn.Name = "HomeBtn"
    HomeBtn.Parent = SidebarList
    HomeBtn.BackgroundColor3 = ConfigWindow.AccentColor
    HomeBtn.Size = UDim2.new(1, 0, 0, 35)
    HomeBtn.Font = Enum.Font.GothamBold
    HomeBtn.Text = "Home"
    HomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HomeBtn.TextSize = 14
    HomeBtn.LayoutOrder = 0
    HomeCorner.CornerRadius = UDim.new(0, 6)
    HomeCorner.Parent = HomeBtn

    HomeBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpToIndex(0)
    end)

    -- Functionality
    self:MakeDraggable(Top, DropShadowHolder)
    self:MakeResizable(DropShadowHolder, Vector2.new(500, 350))

    Close.MouseButton1Click:Connect(function()
        TeddyUI_Premium:Destroy()
    end)

    Minize.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = false
    end)

    local TabCount = 1
    local Tab = {}

    -- [ Tab Function (API: Tab:T(name, icon)) ] --
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
        TabListLayout.Padding = UDim.new(0, 10)
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding.Parent = TabPage
        TabPadding.PaddingLeft = UDim.new(0, 15)
        TabPadding.PaddingRight = UDim.new(0, 15)
        TabPadding.PaddingTop = UDim.new(0, 15)
        TabPadding.PaddingBottom = UDim.new(0, 15)

        Library:UpdateScrolling(TabPage, TabListLayout)

        -- Sidebar Button
        local SideBtn = Instance.new("TextButton")
        local SideCorner = Instance.new("UICorner")
        SideBtn.Name = t .. "_Btn"
        SideBtn.Parent = SidebarList
        SideBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        SideBtn.Size = UDim2.new(1, 0, 0, 35)
        SideBtn.Font = Enum.Font.Gotham
        SideBtn.Text = t
        SideBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        SideBtn.TextSize = 13
        SideBtn.LayoutOrder = TabCount
        SideCorner.CornerRadius = UDim.new(0, 6)
        SideCorner.Parent = SideBtn

        -- Home Card
        local Card = Instance.new("TextButton")
        local CardCorner = Instance.new("UICorner")
        local CardIcon = Instance.new("ImageLabel")
        local CardTitle = Instance.new("TextLabel")
        local CardStroke = Instance.new("UIStroke")

        Card.Name = t .. "_Card"
        Card.Parent = HomeTab
        Card.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Card.Text = ""
        Card.LayoutOrder = TabCount
        
        CardCorner.CornerRadius = UDim.new(0, 12)
        CardCorner.Parent = Card
        
        CardStroke.Color = Color3.fromRGB(30, 30, 30)
        CardStroke.Thickness = 1
        CardStroke.Parent = Card

        CardIcon.Parent = Card
        CardIcon.AnchorPoint = Vector2.new(0.5, 0)
        CardIcon.BackgroundTransparency = 1
        CardIcon.Position = UDim2.new(0.5, 0, 0, 20)
        CardIcon.Size = UDim2.new(0, 50, 0, 50)
        CardIcon.Image = (iconid and iconid ~= "") and iconid or "rbxassetid://123256573634"
        CardIcon.ImageColor3 = ConfigWindow.AccentColor

        CardTitle.Parent = Card
        CardTitle.BackgroundTransparency = 1
        CardTitle.Position = UDim2.new(0, 0, 0, 80)
        CardTitle.Size = UDim2.new(1, 0, 0, 30)
        CardTitle.Font = Enum.Font.GothamBold
        CardTitle.Text = t
        CardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        CardTitle.TextSize = 14

        local function SwitchToTab()
            PageLayout:JumpToIndex(TabPage.LayoutOrder)
            -- Update Sidebar Visuals
            for _, v in pairs(SidebarList:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:TweenInstance(v, 0.2, "BackgroundColor3", Color3.fromRGB(20, 20, 20))
                    v.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            Library:TweenInstance(SideBtn, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
            SideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        SideBtn.MouseButton1Click:Connect(SwitchToTab)
        Card.MouseButton1Click:Connect(SwitchToTab)

        TabCount = TabCount + 1
        local TabFunc = {}

        -- [ Section Function (API: Tab:AddSection(name)) ] --
        function TabFunc:AddSection(RealNameSection)
            local SectionCard = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionTitle = Instance.new("TextLabel")
            local SectionList = Instance.new("Frame")
            local SectionListLayout = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionCard.Name = "Section_" .. RealNameSection
            SectionCard.Parent = TabPage
            SectionCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            SectionCard.Size = UDim2.new(1, 0, 0, 40)
            
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionCard
            
            SectionStroke.Color = Color3.fromRGB(25, 25, 25)
            SectionStroke.Parent = SectionCard

            SectionTitle.Parent = SectionCard
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 12, 0, 0)
            SectionTitle.Size = UDim2.new(1, -12, 0, 35)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = RealNameSection:upper()
            SectionTitle.TextColor3 = ConfigWindow.AccentColor
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionList.Name = "SectionList"
            SectionList.Parent = SectionCard
            SectionList.BackgroundTransparency = 1
            SectionList.Position = UDim2.new(0, 0, 0, 35)
            SectionList.Size = UDim2.new(1, 0, 0, 0)

            SectionListLayout.Parent = SectionList
            SectionListLayout.Padding = UDim.new(0, 5)
            SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionList
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)

            SectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionCard.Size = UDim2.new(1, 0, 0, SectionListLayout.AbsoluteContentSize.Y + 45)
            end)

            local SectionFunc = {}

            -- [ Toggle Function (API: Section:AddToggle(config)) ] --
            function SectionFunc:AddToggle(cftoggle)
                cftoggle = Library:MakeConfig({
                    Title = "Toggle",
                    Description = "",
                    Default = false,
                    Callback = function() end
                }, cftoggle or {})

                local ToggleFrame = Instance.new("TextButton")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleDesc = Instance.new("TextLabel")
                local ToggleStatus = Instance.new("Frame")
                local StatusCorner = Instance.new("UICorner")
                local StatusCircle = Instance.new("Frame")
                local CircleCorner = Instance.new("UICorner")

                local hasDesc = cftoggle.Description ~= ""
                ToggleFrame.Name = "Toggle_" .. cftoggle.Title
                ToggleFrame.Parent = SectionList
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                ToggleFrame.Size = UDim2.new(1, 0, 0, hasDesc and 45 or 35)
                ToggleFrame.Text = ""
                
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = ToggleFrame

                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 12, 0, hasDesc and 5 or 0)
                ToggleTitle.Size = UDim2.new(1, -60, 0, hasDesc and 20 or 35)
                ToggleTitle.Font = Enum.Font.Gotham
                ToggleTitle.Text = cftoggle.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                ToggleTitle.TextSize = 13
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                if hasDesc then
                    ToggleDesc.Parent = ToggleFrame
                    ToggleDesc.BackgroundTransparency = 1
                    ToggleDesc.Position = UDim2.new(0, 12, 0, 22)
                    ToggleDesc.Size = UDim2.new(1, -60, 0, 18)
                    ToggleDesc.Font = Enum.Font.Gotham
                    ToggleDesc.Text = cftoggle.Description
                    ToggleDesc.TextColor3 = Color3.fromRGB(120, 120, 120)
                    ToggleDesc.TextSize = 11
                    ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                end

                ToggleStatus.Parent = ToggleFrame
                ToggleStatus.AnchorPoint = Vector2.new(1, 0.5)
                ToggleStatus.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                ToggleStatus.Position = UDim2.new(1, -10, 0.5, 0)
                ToggleStatus.Size = UDim2.new(0, 35, 0, 18)
                
                StatusCorner.CornerRadius = UDim.new(1, 0)
                StatusCorner.Parent = ToggleStatus

                StatusCircle.Parent = ToggleStatus
                StatusCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                StatusCircle.Position = UDim2.new(0, 2, 0.5, -7)
                StatusCircle.Size = UDim2.new(0, 14, 0, 14)
                
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = StatusCircle

                local Toggled = cftoggle.Default
                local function UpdateToggle()
                    if Toggled then
                        Library:TweenInstance(StatusCircle, 0.2, "Position", UDim2.new(1, -16, 0.5, -7))
                        Library:TweenInstance(StatusCircle, 0.2, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
                        Library:TweenInstance(ToggleStatus, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
                    else
                        Library:TweenInstance(StatusCircle, 0.2, "Position", UDim2.new(0, 2, 0.5, -7))
                        Library:TweenInstance(StatusCircle, 0.2, "BackgroundColor3", Color3.fromRGB(150, 150, 150))
                        Library:TweenInstance(ToggleStatus, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 30))
                    end
                    pcall(cftoggle.Callback, Toggled)
                end

                ToggleFrame.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                end)

                if Toggled then UpdateToggle() end
                return { Set = function(self, val) Toggled = val UpdateToggle() end }
            end

            -- [ Button Function (API: Section:AddButton(config)) ] --
            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({
                    Title = "Button",
                    Description = "",
                    Callback = function() end
                }, cfbtn or {})

                local hasDesc = cfbtn.Description ~= ""
                local Button = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnTitle = Instance.new("TextLabel")
                local BtnDesc = Instance.new("TextLabel")
                
                Button.Name = "Button_" .. cfbtn.Title
                Button.Parent = SectionList
                Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                Button.Size = UDim2.new(1, 0, 0, hasDesc and 45 or 35)
                Button.Text = ""
                
                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = Button

                BtnTitle.Parent = Button
                BtnTitle.BackgroundTransparency = 1
                BtnTitle.Position = UDim2.new(0, 0, 0, hasDesc and 5 or 0)
                BtnTitle.Size = UDim2.new(1, 0, 0, hasDesc and 20 or 35)
                BtnTitle.Font = Enum.Font.GothamBold
                BtnTitle.Text = cfbtn.Title
                BtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                BtnTitle.TextSize = 13

                if hasDesc then
                    BtnDesc.Parent = Button
                    BtnDesc.BackgroundTransparency = 1
                    BtnDesc.Position = UDim2.new(0, 0, 0, 22)
                    BtnDesc.Size = UDim2.new(1, 0, 0, 18)
                    BtnDesc.Font = Enum.Font.Gotham
                    BtnDesc.Text = cfbtn.Description
                    BtnDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
                    BtnDesc.TextSize = 11
                end

                Button.MouseButton1Click:Connect(function()
                    local oldColor = Button.BackgroundColor3
                    Library:TweenInstance(Button, 0.1, "BackgroundColor3", ConfigWindow.AccentColor)
                    task.wait(0.1)
                    Library:TweenInstance(Button, 0.1, "BackgroundColor3", oldColor)
                    pcall(cfbtn.Callback)
                end)
            end

            -- [ Slider Function (API: Section:AddSlider(config)) ] --
            function SectionFunc:AddSlider(cfslider)
                cfslider = Library:MakeConfig({
                    Title = "Slider",
                    Description = "",
                    Min = 0,
                    Max = 100,
                    Default = 50,
                    Callback = function() end
                }, cfslider or {})

                local hasDesc = cfslider.Description ~= ""
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderBtn = Instance.new("TextButton")

                SliderFrame.Name = "Slider_" .. cfslider.Title
                SliderFrame.Parent = SectionList
                SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                SliderFrame.Size = UDim2.new(1, 0, 0, hasDesc and 60 or 50)
                
                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Parent = SliderFrame

                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 12, 0, 5)
                SliderTitle.Size = UDim2.new(1, -60, 0, 20)
                SliderTitle.Font = Enum.Font.Gotham
                SliderTitle.Text = cfslider.Title
                SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -60, 0, 5)
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(cfslider.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 13
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                SliderBar.Position = UDim2.new(0, 12, 0, hasDesc and 42 or 32)
                SliderBar.Size = UDim2.new(1, -24, 0, 6)
                
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar

                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new((cfslider.Default - cfslider.Min) / (cfslider.Max - cfslider.Min), 0, 1, 0)
                
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                SliderBtn.Parent = SliderBar
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.Text = ""

                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(cfslider.Min + (cfslider.Max - cfslider.Min) * pos)
                    SliderValue.Text = tostring(val)
                    Library:TweenInstance(SliderFill, 0.1, "Size", UDim2.new(pos, 0, 1, 0))
                    pcall(cfslider.Callback, val)
                end

                local dragging = false
                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
            end

            -- [ Dropdown Function (API: Section:AddDropdown(config)) ] --
            function SectionFunc:AddDropdown(cfdrop)
                cfdrop = Library:MakeConfig({
                    Title = "Dropdown",
                    Description = "",
                    Options = {},
                    Values = {}, -- Support both 'Options' and 'Values'
                    Default = "",
                    Callback = function() end
                }, cfdrop or {})

                local options = #cfdrop.Options > 0 and cfdrop.Options or cfdrop.Values
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("TextLabel")
                local DropList = Instance.new("Frame")
                local DropListLayout = Instance.new("UIListLayout")
                local DropPadding = Instance.new("UIPadding")

                DropFrame.Name = "Dropdown_" .. cfdrop.Title
                DropFrame.Parent = SectionList
                DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                DropFrame.Size = UDim2.new(1, 0, 0, 35)
                DropFrame.ClipsDescendants = true
                
                DropCorner.CornerRadius = UDim.new(0, 8)
                DropCorner.Parent = DropFrame

                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 35)
                DropBtn.Text = ""

                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 12, 0, 0)
                DropTitle.Size = UDim2.new(1, -40, 0, 35)
                DropTitle.Font = Enum.Font.Gotham
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropTitle.TextSize = 13
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left

                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -30, 0, 0)
                DropIcon.Size = UDim2.new(0, 30, 0, 35)
                DropIcon.Font = Enum.Font.GothamBold
                DropIcon.Text = "+"
                DropIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
                DropIcon.TextSize = 18

                DropList.Name = "DropList"
                DropList.Parent = DropFrame
                DropList.BackgroundTransparency = 1
                DropList.Position = UDim2.new(0, 0, 0, 35)
                DropList.Size = UDim2.new(1, 0, 0, 0)

                DropListLayout.Parent = DropList
                DropListLayout.Padding = UDim.new(0, 5)
                DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder

                DropPadding.Parent = DropList
                DropPadding.PaddingBottom = UDim.new(0, 5)
                DropPadding.PaddingLeft = UDim.new(0, 5)
                DropPadding.PaddingRight = UDim.new(0, 5)

                local Open = false
                local function ToggleDrop()
                    Open = not Open
                    local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 40) or 35
                    Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize))
                    DropIcon.Text = Open and "-" or "+"
                end

                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList
                        OptBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        OptBtn.Size = UDim2.new(1, 0, 0, 30)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptBtn.TextSize = 12
                        OptCorner.CornerRadius = UDim.new(0, 6)
                        OptCorner.Parent = OptBtn

                        OptBtn.MouseButton1Click:Connect(function()
                            DropTitle.Text = cfdrop.Title .. " : " .. opt
                            ToggleDrop()
                            pcall(cfdrop.Callback, opt)
                        end)
                    end
                end

                AddOptions(options)

                return { 
                    Refresh = function(self, newopts)
                        for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                        AddOptions(newopts)
                        if Open then
                            task.wait()
                            Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, DropListLayout.AbsoluteContentSize.Y + 40))
                        end
                    end,
                    Set = function(self, val)
                        DropTitle.Text = cfdrop.Title .. " : " .. tostring(val)
                        pcall(cfdrop.Callback, val)
                    end
                }
            end

            -- [ TextBox Function (API: Section:AddTextbox / AddInput) ] --
            function SectionFunc:AddTextbox(cfbox)
                cfbox = Library:MakeConfig({
                    Title = "Textbox",
                    Description = "",
                    Default = "",
                    Callback = function() end
                }, cfbox or {})

                local BoxFrame = Instance.new("Frame")
                local BoxCorner = Instance.new("UICorner")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")

                BoxFrame.Name = "Textbox_" .. cfbox.Title
                BoxFrame.Parent = SectionList
                BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                BoxFrame.Size = UDim2.new(1, 0, 0, 35)
                
                BoxCorner.CornerRadius = UDim.new(0, 8)
                BoxCorner.Parent = BoxFrame

                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 12, 0, 0)
                BoxTitle.Size = UDim2.new(0, 100, 1, 0)
                BoxTitle.Font = Enum.Font.Gotham
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BoxTitle.TextSize = 13
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BoxInput.Position = UDim2.new(1, -160, 0.5, -12)
                BoxInput.Size = UDim2.new(0, 150, 0, 24)
                BoxInput.Font = Enum.Font.Gotham
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                BoxInput.TextSize = 12
                
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = BoxInput

                BoxInput.FocusLost:Connect(function(enter)
                    pcall(cfbox.Callback, BoxInput.Text)
                end)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            -- [ Label Function (API: Section:AddLabel(text)) ] --
            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = SectionList
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = val end }
            end

            -- [ Seperator Function ] --
            function SectionFunc:AddSeperator(text)
                local Sep = Instance.new("Frame")
                local SepLine = Instance.new("Frame")
                local SepText = Instance.new("TextLabel")
                
                Sep.Name = "Seperator"
                Sep.Parent = SectionList
                Sep.BackgroundTransparency = 1
                Sep.Size = UDim2.new(1, 0, 0, 20)
                
                SepLine.Parent = Sep
                SepLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                SepLine.BorderSizePixel = 0
                SepLine.Position = UDim2.new(0, 0, 0.5, 0)
                SepLine.Size = UDim2.new(1, 0, 0, 1)
                
                if text and text ~= "" then
                    SepText.Parent = Sep
                    SepText.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    SepText.Position = UDim2.new(0.5, 0, 0.5, 0)
                    SepText.AnchorPoint = Vector2.new(0.5, 0.5)
                    SepText.Size = UDim2.new(0, 80, 0, 15)
                    SepText.Font = Enum.Font.Gotham
                    SepText.Text = text
                    SepText.TextColor3 = Color3.fromRGB(100, 100, 100)
                    SepText.TextSize = 10
                end
            end

            return SectionFunc
        end

        return TabFunc
    end

    -- Toggle UI Button (Floating)
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")

    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 20, 0, 20)
    MainBtn.Size = UDim2.new(0, 50, 0, 50)
    MainBtn.Image = "rbxassetid://101817370702077"
    
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn
    
    BtnStroke.Color = Color3.fromRGB(20, 20, 20)
    BtnStroke.Thickness = 2
    BtnStroke.Parent = MainBtn

    self:MakeDraggable(MainBtn, MainBtn)

    MainBtn.MouseButton1Click:Connect(function()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
    end)

    return Tab
end

return Library
