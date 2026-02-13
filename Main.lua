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

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 520, 0, 360)

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
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main

    UIStroke.Color = Color3.fromRGB(35, 35, 35)
    UIStroke.Thickness = 1.2
    UIStroke.Parent = Main

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Top.Size = UDim2.new(1, 0, 0, 45)

    LogoHub.Name = "LogoHub"
    LogoHub.Parent = Top
    LogoHub.BackgroundTransparency = 1
    LogoHub.Position = UDim2.new(0, 12, 0, 7)
    LogoHub.Size = UDim2.new(0, 30, 0, 30)
    LogoHub.Image = "rbxassetid://123256573634"

    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 50, 0, 8)
    NameHub.Size = UDim2.new(0, 200, 0, 18)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = ConfigWindow.Title
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 15
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 50, 0, 24)
    Desc.Size = UDim2.new(0, 200, 0, 12)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = Color3.fromRGB(130, 130, 130)
    Desc.TextSize = 11
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -140, 0, 0)
    RightButtons.Size = UDim2.new(0, 130, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 8)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Font = Enum.Font.GothamBold
    Close.Text = "✕"
    Close.TextColor3 = Color3.fromRGB(200, 200, 200)
    Close.TextSize = 14

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 25, 0, 25)
    Minize.Font = Enum.Font.GothamBold
    Minize.Text = "—"
    Minize.TextColor3 = Color3.fromRGB(200, 200, 200)
    Minize.TextSize = 14

    BackBtn.Name = "BackBtn"
    BackBtn.Parent = RightButtons
    BackBtn.BackgroundTransparency = 1
    BackBtn.Size = UDim2.new(0, 55, 0, 25)
    BackBtn.Font = Enum.Font.GothamBold
    BackBtn.Text = "← Back"
    BackBtn.TextColor3 = ConfigWindow.AccentColor
    BackBtn.TextSize = 11
    BackBtn.Visible = false

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 45)
    ContentFrame.Size = UDim2.new(1, 0, 1, -45)
    ContentFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame
    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quad
    PageLayout.TweenTime = 0.3

    HomeTab.Name = "Home"
    HomeTab.Parent = PageList
    HomeTab.BackgroundTransparency = 1
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.ScrollBarThickness = 0
    HomeTab.LayoutOrder = 0

    HomeGridLayout.Parent = HomeTab
    HomeGridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
    HomeGridLayout.CellSize = UDim2.new(0, 115, 0, 115)
    HomeGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    HomePadding.Parent = HomeTab
    HomePadding.PaddingLeft = UDim.new(0, 15)
    HomePadding.PaddingTop = UDim.new(0, 15)

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

        local Card = Instance.new("TextButton")
        local CardCorner = Instance.new("UICorner")
        local CardStroke = Instance.new("UIStroke")
        local CardIcon = Instance.new("ImageLabel")
        local CardTitle = Instance.new("TextLabel")

        Card.Name = t .. "_Card"
        Card.Parent = HomeTab
        Card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Card.Text = ""
        Card.LayoutOrder = TabCount
        
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card
        
        CardStroke.Color = Color3.fromRGB(40, 40, 40)
        CardStroke.Thickness = 1
        CardStroke.Parent = Card

        CardIcon.Parent = Card
        CardIcon.AnchorPoint = Vector2.new(0.5, 0)
        CardIcon.BackgroundTransparency = 1
        CardIcon.Position = UDim2.new(0.5, 0, 0, 20)
        CardIcon.Size = UDim2.new(0, 40, 0, 40)
        CardIcon.Image = (iconid and iconid ~= "") and iconid or "rbxassetid://123256573634"
        CardIcon.ImageColor3 = ConfigWindow.AccentColor

        CardTitle.Parent = Card
        CardTitle.BackgroundTransparency = 1
        CardTitle.Position = UDim2.new(0, 0, 0, 70)
        CardTitle.Size = UDim2.new(1, 0, 0, 25)
        CardTitle.Font = Enum.Font.GothamBold
        CardTitle.Text = t
        CardTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        CardTitle.TextSize = 12

        Card.MouseEnter:Connect(function()
            Library:TweenInstance(Card, 0.2, "BackgroundColor3", Color3.fromRGB(25, 25, 25))
            Library:TweenInstance(CardStroke, 0.2, "Color", ConfigWindow.AccentColor)
        end)
        Card.MouseLeave:Connect(function()
            Library:TweenInstance(Card, 0.2, "BackgroundColor3", Color3.fromRGB(20, 20, 20))
            Library:TweenInstance(CardStroke, 0.2, "Color", Color3.fromRGB(40, 40, 40))
        end)

        Card.MouseButton1Click:Connect(function()
            PageLayout:JumpToIndex(TabPage.LayoutOrder)
            BackBtn.Visible = true
        end)

        TabCount = TabCount + 1
        local TabFunc = {}

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
            SectionCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            SectionCard.Size = UDim2.new(1, 0, 0, 40)
            
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionCard
            
            SectionStroke.Color = Color3.fromRGB(30, 30, 30)
            SectionStroke.Parent = SectionCard

            SectionTitle.Parent = SectionCard
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 12, 0, 0)
            SectionTitle.Size = UDim2.new(1, -12, 0, 30)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = RealNameSection:upper()
            SectionTitle.TextColor3 = ConfigWindow.AccentColor
            SectionTitle.TextSize = 11
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionList.Name = "SectionList"
            SectionList.Parent = SectionCard
            SectionList.BackgroundTransparency = 1
            SectionList.Position = UDim2.new(0, 0, 0, 30)
            SectionList.Size = UDim2.new(1, 0, 0, 0)

            SectionListLayout.Parent = SectionList
            SectionListLayout.Padding = UDim.new(0, 6)
            SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionList
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)

            SectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionCard.Size = UDim2.new(1, 0, 0, SectionListLayout.AbsoluteContentSize.Y + 40)
            end)

            local SectionFunc = {}
            local CurrentGroup = SectionList 

            function SectionFunc:AddSeperator(text)
                local SepFrame = Instance.new("Frame")
                local SepBtn = Instance.new("TextButton")
                local SepCorner = Instance.new("UICorner")
                local SepStroke = Instance.new("UIStroke")
                local SepText = Instance.new("TextLabel")
                local SepIcon = Instance.new("ImageLabel")
                local GroupFrame = Instance.new("Frame")
                local GroupLayout = Instance.new("UIListLayout")
                
                SepFrame.Name = "SeperatorGroup"
                SepFrame.Parent = SectionList
                SepFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                SepFrame.Size = UDim2.new(1, 0, 0, 32)
                
                SepCorner.CornerRadius = UDim.new(0, 6)
                SepCorner.Parent = SepFrame
                SepStroke.Color = Color3.fromRGB(40, 40, 40); SepStroke.Parent = SepFrame
                
                SepBtn.Parent = SepFrame; SepBtn.BackgroundTransparency = 1; SepBtn.Size = UDim2.new(1, 0, 1, 0); SepBtn.Text = ""
                SepText.Parent = SepFrame; SepText.BackgroundTransparency = 1; SepText.Position = UDim2.new(0, 10, 0, 0); SepText.Size = UDim2.new(1, -40, 1, 0); SepText.Font = Enum.Font.GothamBold; SepText.Text = text or "Group"; SepText.TextColor3 = Color3.fromRGB(200, 200, 200); SepText.TextSize = 11; SepText.TextXAlignment = Enum.TextXAlignment.Left
                
                SepIcon.Parent = SepFrame; SepIcon.AnchorPoint = Vector2.new(1, 0.5); SepIcon.BackgroundTransparency = 1; SepIcon.Position = UDim2.new(1, -10, 0.5, 0); SepIcon.Size = UDim2.new(0, 12, 0, 12); SepIcon.Image = "rbxassetid://10131441151"; SepIcon.ImageColor3 = ConfigWindow.AccentColor

                GroupFrame.Name = "Group_" .. (text or "Unnamed")
                GroupFrame.Parent = SectionList
                GroupFrame.BackgroundTransparency = 1
                GroupFrame.Size = UDim2.new(1, 0, 0, 0)
                GroupFrame.ClipsDescendants = true
                GroupFrame.Visible = false

                GroupLayout.Parent = GroupFrame; GroupLayout.Padding = UDim.new(0, 6); GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local isOpen = false
                local function ToggleGroup()
                    isOpen = not isOpen
                    GroupFrame.Visible = isOpen
                    Library:TweenInstance(SepIcon, 0.2, "Rotation", isOpen and 90 or 0)
                    if not isOpen then GroupFrame.Size = UDim2.new(1, 0, 0, 0) else GroupFrame.Size = UDim2.new(1, 0, 0, GroupLayout.AbsoluteContentSize.Y) end
                end
                SepBtn.MouseButton1Click:Connect(ToggleGroup)
                GroupLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if isOpen then GroupFrame.Size = UDim2.new(1, 0, 0, GroupLayout.AbsoluteContentSize.Y) end end)
                CurrentGroup = GroupFrame 
            end

            function SectionFunc:AddToggle(cftoggle)
                cftoggle = Library:MakeConfig({ Title = "Toggle", Description = "", Default = false, Callback = function() end }, cftoggle or {})
                local ToggleFrame = Instance.new("TextButton")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleDesc = Instance.new("TextLabel")
                local ToggleStatus = Instance.new("Frame")
                local StatusCorner = Instance.new("UICorner")
                local StatusCircle = Instance.new("Frame")
                local CircleCorner = Instance.new("UICorner")

                local hasDesc = cftoggle.Description and cftoggle.Description ~= ""
                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                ToggleFrame.Size = UDim2.new(1, 0, 0, hasDesc and 50 or 40)
                ToggleFrame.Text = ""
                ToggleCorner.CornerRadius = UDim.new(0, 6); ToggleCorner.Parent = ToggleFrame
                ToggleTitle.Parent = ToggleFrame; ToggleTitle.BackgroundTransparency = 1; ToggleTitle.Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0); ToggleTitle.Size = UDim2.new(1, -60, 0, hasDesc and 20 or 40); ToggleTitle.Font = Enum.Font.Gotham; ToggleTitle.Text = cftoggle.Title; ToggleTitle.TextColor3 = Color3.fromRGB(230, 230, 230); ToggleTitle.TextSize = 13; ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                if hasDesc then ToggleDesc.Parent = ToggleFrame; ToggleDesc.BackgroundTransparency = 1; ToggleDesc.Position = UDim2.new(0, 12, 0, 26); ToggleDesc.Size = UDim2.new(1, -60, 0, 18); ToggleDesc.Font = Enum.Font.Gotham; ToggleDesc.Text = cftoggle.Description; ToggleDesc.TextColor3 = Color3.fromRGB(120, 120, 120); ToggleDesc.TextSize = 11; ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left end
                ToggleStatus.Parent = ToggleFrame; ToggleStatus.AnchorPoint = Vector2.new(1, 0.5); ToggleStatus.BackgroundColor3 = Color3.fromRGB(35, 35, 35); ToggleStatus.Position = UDim2.new(1, -10, 0.5, 0); ToggleStatus.Size = UDim2.new(0, 32, 0, 16); StatusCorner.CornerRadius = UDim.new(1, 0); StatusCorner.Parent = ToggleStatus
                StatusCircle.Parent = ToggleStatus; StatusCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150); StatusCircle.Position = UDim2.new(0, 2, 0.5, -6); StatusCircle.Size = UDim2.new(0, 12, 0, 12); CircleCorner.CornerRadius = UDim.new(1, 0); CircleCorner.Parent = StatusCircle

                local Toggled = cftoggle.Default
                local function UpdateToggle(noCallback)
                    if Toggled then
                        Library:TweenInstance(StatusCircle, 0.2, "Position", UDim2.new(1, -14, 0.5, -6))
                        Library:TweenInstance(StatusCircle, 0.2, "BackgroundColor3", Color3.fromRGB(255, 255, 255))
                        Library:TweenInstance(ToggleStatus, 0.2, "BackgroundColor3", ConfigWindow.AccentColor)
                    else
                        Library:TweenInstance(StatusCircle, 0.2, "Position", UDim2.new(0, 2, 0.5, -6))
                        Library:TweenInstance(StatusCircle, 0.2, "BackgroundColor3", Color3.fromRGB(150, 150, 150))
                        Library:TweenInstance(ToggleStatus, 0.2, "BackgroundColor3", Color3.fromRGB(35, 35, 35))
                    end
                    if not noCallback then pcall(cftoggle.Callback, Toggled) end
                end
                ToggleFrame.MouseButton1Click:Connect(function() Toggled = not Toggled UpdateToggle() end)
                UpdateToggle(false) 
                return { Set = function(self, val) Toggled = val UpdateToggle() end }
            end

            function SectionFunc:AddButton(cfbtn)
                cfbtn = Library:MakeConfig({ Title = "Button", Description = "", Callback = function() end }, cfbtn or {})
                local hasDesc = cfbtn.Description and cfbtn.Description ~= ""
                local Button = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnTitle = Instance.new("TextLabel")
                local BtnDesc = Instance.new("TextLabel")
                Button.Parent = CurrentGroup; Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28); Button.Size = UDim2.new(1, 0, 0, hasDesc and 50 or 40); Button.Text = ""; BtnCorner.CornerRadius = UDim.new(0, 6); BtnCorner.Parent = Button
                BtnTitle.Parent = Button; BtnTitle.BackgroundTransparency = 1; BtnTitle.Position = UDim2.new(0, 0, 0, hasDesc and 6 or 0); BtnTitle.Size = UDim2.new(1, 0, 0, hasDesc and 20 or 40); BtnTitle.Font = Enum.Font.GothamBold; BtnTitle.Text = cfbtn.Title; BtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255); BtnTitle.TextSize = 13
                if hasDesc then BtnDesc.Parent = Button; BtnDesc.BackgroundTransparency = 1; BtnDesc.Position = UDim2.new(0, 0, 0, 26); BtnDesc.Size = UDim2.new(1, 0, 0, 18); BtnDesc.Font = Enum.Font.Gotham; BtnDesc.Text = cfbtn.Description; BtnDesc.TextColor3 = Color3.fromRGB(180, 180, 180); BtnDesc.TextSize = 11 end
                Button.MouseButton1Click:Connect(function()
                    local oldColor = Button.BackgroundColor3
                    Library:TweenInstance(Button, 0.1, "BackgroundColor3", ConfigWindow.AccentColor)
                    task.wait(0.1)
                    Library:TweenInstance(Button, 0.1, "BackgroundColor3", oldColor)
                    pcall(cfbtn.Callback)
                end)
            end

            function SectionFunc:AddSlider(cfslider)
                cfslider = Library:MakeConfig({ Title = "Slider", Description = "", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslider or {})
                local hasDesc = cfslider.Description and cfslider.Description ~= ""
                local SliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderBtn = Instance.new("TextButton")
                SliderFrame.Parent = CurrentGroup; SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); SliderFrame.Size = UDim2.new(1, 0, 0, hasDesc and 65 or 55); SliderCorner.CornerRadius = UDim.new(0, 6); SliderCorner.Parent = SliderFrame
                SliderTitle.Parent = SliderFrame; SliderTitle.BackgroundTransparency = 1; SliderTitle.Position = UDim2.new(0, 12, 0, 8); SliderTitle.Size = UDim2.new(1, -60, 0, 20); SliderTitle.Font = Enum.Font.Gotham; SliderTitle.Text = cfslider.Title; SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230); SliderTitle.TextSize = 13; SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderValue.Parent = SliderFrame; SliderValue.BackgroundTransparency = 1; SliderValue.Position = UDim2.new(1, -60, 0, 8); SliderValue.Size = UDim2.new(0, 50, 0, 20); SliderValue.Font = Enum.Font.GothamBold; SliderValue.Text = tostring(cfslider.Default); SliderValue.TextColor3 = ConfigWindow.AccentColor; SliderValue.TextSize = 13; SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderBar.Parent = SliderFrame; SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SliderBar.Position = UDim2.new(0, 12, 0, hasDesc and 48 or 38); SliderBar.Size = UDim2.new(1, -24, 0, 6); BarCorner.CornerRadius = UDim.new(1, 0); BarCorner.Parent = SliderBar
                SliderFill.Parent = SliderBar; SliderFill.BackgroundColor3 = ConfigWindow.AccentColor; SliderFill.Size = UDim2.new((cfslider.Default - cfslider.Min) / (cfslider.Max - cfslider.Min), 0, 1, 0); FillCorner.CornerRadius = UDim.new(1, 0); FillCorner.Parent = SliderFill
                SliderBtn.Parent = SliderBar; SliderBtn.BackgroundTransparency = 1; SliderBtn.Size = UDim2.new(1, 0, 1, 0); SliderBtn.Text = ""
                local function UpdateSlider(input, noCallback)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(cfslider.Min + (cfslider.Max - cfslider.Min) * pos)
                    SliderValue.Text = tostring(val)
                    Library:TweenInstance(SliderFill, 0.1, "Size", UDim2.new(pos, 0, 1, 0))
                    if not noCallback then pcall(cfslider.Callback, val) end
                end
                local dragging = false
                SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true UpdateSlider(input) end end)
                game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end end)
                game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
                pcall(cfslider.Callback, cfslider.Default)
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

                DropFrame.Parent = CurrentGroup; DropFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); DropFrame.Size = UDim2.new(1, 0, 0, 40); DropFrame.ClipsDescendants = true; DropCorner.CornerRadius = UDim.new(0, 6); DropCorner.Parent = DropFrame
                DropBtn.Parent = DropFrame; DropBtn.BackgroundTransparency = 1; DropBtn.Size = UDim2.new(1, 0, 0, 40); DropBtn.Text = ""
                DropTitle.Parent = DropFrame; DropTitle.BackgroundTransparency = 1; DropTitle.Position = UDim2.new(0, 12, 0, 0); DropTitle.Size = UDim2.new(1, -40, 0, 40); DropTitle.Font = Enum.Font.Gotham; DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default)); DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230); DropTitle.TextSize = 13; DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropIcon.Parent = DropFrame; DropIcon.BackgroundTransparency = 1; DropIcon.Position = UDim2.new(1, -30, 0, 0); DropIcon.Size = UDim2.new(0, 30, 0, 40); DropIcon.Font = Enum.Font.GothamBold; DropIcon.Text = "+"; DropIcon.TextColor3 = Color3.fromRGB(200, 200, 200); DropIcon.TextSize = 16
                DropList.Parent = DropFrame; DropList.BackgroundTransparency = 1; DropList.Position = UDim2.new(0, 0, 0, 40); DropList.Size = UDim2.new(1, 0, 0, 0); DropListLayout.Parent = DropList; DropListLayout.Padding = UDim.new(0, 5); DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder; DropPadding.Parent = DropList; DropPadding.PaddingBottom = UDim.new(0, 5); DropPadding.PaddingLeft = UDim.new(0, 5); DropPadding.PaddingRight = UDim.new(0, 5)

                local Open = false
                local function ToggleDrop() Open = not Open local targetSize = Open and (DropListLayout.AbsoluteContentSize.Y + 45) or 40 Library:TweenInstance(DropFrame, 0.3, "Size", UDim2.new(1, 0, 0, targetSize)) DropIcon.Text = Open and "−" or "+" end
                DropBtn.MouseButton1Click:Connect(ToggleDrop)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        OptBtn.Parent = DropList; OptBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32); OptBtn.Size = UDim2.new(1, 0, 0, 32); OptBtn.Font = Enum.Font.Gotham; OptBtn.Text = opt; OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200); OptBtn.TextSize = 12; OptCorner.CornerRadius = UDim.new(0, 4); OptCorner.Parent = OptBtn
                        OptBtn.MouseButton1Click:Connect(function() DropTitle.Text = cfdrop.Title .. " : " .. opt ToggleDrop() pcall(cfdrop.Callback, opt) end)
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
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                BoxFrame.Parent = CurrentGroup; BoxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); BoxFrame.Size = UDim2.new(1, 0, 0, 40); BoxCorner.CornerRadius = UDim.new(0, 6); BoxCorner.Parent = BoxFrame
                BoxTitle.Parent = BoxFrame; BoxTitle.BackgroundTransparency = 1; BoxTitle.Position = UDim2.new(0, 12, 0, 0); BoxTitle.Size = UDim2.new(0, 100, 1, 0); BoxTitle.Font = Enum.Font.Gotham; BoxTitle.Text = cfbox.Title; BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230); BoxTitle.TextSize = 13; BoxTitle.TextXAlignment = Enum.TextXAlignment.Left
                BoxInput.Parent = BoxFrame; BoxInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BoxInput.Position = UDim2.new(1, -160, 0.5, -13); BoxInput.Size = UDim2.new(0, 150, 0, 26); BoxInput.Font = Enum.Font.Gotham; BoxInput.Text = cfbox.Default; BoxInput.TextColor3 = Color3.fromRGB(255, 255, 255); BoxInput.TextSize = 12; InputCorner.CornerRadius = UDim.new(0, 4); InputCorner.Parent = BoxInput
                BoxInput.FocusLost:Connect(function() pcall(cfbox.Callback, BoxInput.Text) end)
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 25); Label.Font = Enum.Font.Gotham; Label.Text = text; Label.TextColor3 = Color3.fromRGB(160, 160, 160); Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                local ParaFrame = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")
                ParaFrame.Parent = CurrentGroup; ParaFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22); ParaFrame.Size = UDim2.new(1, 0, 0, 50); ParaCorner.CornerRadius = UDim.new(0, 6); ParaCorner.Parent = ParaFrame
                ParaTitle.Parent = ParaFrame; ParaTitle.BackgroundTransparency = 1; ParaTitle.Position = UDim2.new(0, 10, 0, 8); ParaTitle.Size = UDim2.new(1, -20, 0, 15); ParaTitle.Font = Enum.Font.GothamBold; ParaTitle.Text = cfpara.Title; ParaTitle.TextColor3 = Color3.fromRGB(255, 255, 255); ParaTitle.TextSize = 13; ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.Parent = ParaFrame; ParaContent.BackgroundTransparency = 1; ParaContent.Position = UDim2.new(0, 10, 0, 26); ParaContent.Size = UDim2.new(1, -20, 0, 18); ParaContent.Font = Enum.Font.Gotham; ParaContent.Text = contentText; ParaContent.TextColor3 = Color3.fromRGB(140, 140, 140); ParaContent.TextSize = 11; ParaContent.TextXAlignment = Enum.TextXAlignment.Left; ParaContent.TextWrapped = true
                local function UpdateSize() local textHeight = ParaContent.TextBounds.Y ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 35) ParaContent.Size = UDim2.new(1, -20, 0, textHeight) end
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
                DiscordCard.Parent = CurrentGroup; DiscordCard.BackgroundColor3 = Color3.fromRGB(22, 22, 22); DiscordCard.Size = UDim2.new(1, 0, 0, 70); UICorner.CornerRadius = UDim.new(0, 8); UICorner.Parent = DiscordCard
                Icon.Parent = DiscordCard; Icon.BackgroundTransparency = 1; Icon.Position = UDim2.new(0, 12, 0, 12); Icon.Size = UDim2.new(0, 45, 0, 45); Icon.Image = "rbxassetid://123256573634"
                Title.Parent = DiscordCard; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 65, 0, 18); Title.Size = UDim2.new(1, -140, 0, 20); Title.Font = Enum.Font.GothamBold; Title.Text = DiscordTitle or "Discord Server"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left
                SubTitle.Parent = DiscordCard; SubTitle.BackgroundTransparency = 1; SubTitle.Position = UDim2.new(0, 65, 0, 36); SubTitle.Size = UDim2.new(1, -140, 0, 20); SubTitle.Font = Enum.Font.Gotham; SubTitle.Text = "Click to join our community"; SubTitle.TextColor3 = Color3.fromRGB(160, 160, 160); SubTitle.TextSize = 11; SubTitle.TextXAlignment = Enum.TextXAlignment.Left
                JoinBtn.Parent = DiscordCard; JoinBtn.BackgroundColor3 = ConfigWindow.AccentColor; JoinBtn.Position = UDim2.new(1, -80, 0, 20); JoinBtn.Size = UDim2.new(0, 65, 0, 30); JoinBtn.Font = Enum.Font.GothamBold; JoinBtn.Text = "Join"; JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); JoinBtn.TextSize = 13; BtnCorner.CornerRadius = UDim.new(0, 6); BtnCorner.Parent = JoinBtn
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
    MainBtn.Parent = ToggleBtn; MainBtn.BackgroundColor3 = ConfigWindow.AccentColor; MainBtn.Position = UDim2.new(0, 20, 0, 20); MainBtn.Size = UDim2.new(0, 45, 0, 45); MainBtn.Image = "rbxassetid://101817370702077"
    BtnCorner.CornerRadius = UDim.new(1, 0); BtnCorner.Parent = MainBtn
    BtnStroke.Color = Color3.fromRGB(20, 20, 20); BtnStroke.Thickness = 2; BtnStroke.Parent = MainBtn
    self:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)

    return Tab
end

return Library
