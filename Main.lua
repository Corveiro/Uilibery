local Library = {}

-- [ Services ] --
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [ Utility Functions ] --
function Library:Tween(Instance, Time, Properties, Style)
    local Tween = TweenService:Create(Instance, TweenInfo.new(Time, Style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), Properties)
    Tween:Play()
    return Tween
end

function Library:MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
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
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

-- [ Main Window ] --
function Library:NewWindow(Config)
    Config = Config or {}
    local Title = Config.Title or "SYNTRAX"
    local Description = Config.Description or "PREMIUM EDITION"
    local AccentColor = Config.AccentColor or Color3.fromRGB(255, 0, 0)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Syntrax_Elite"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local MainShadow = Instance.new("ImageLabel")
    
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Position = UDim2.new(0.5, -250, 0.5, -180)
    Main.Size = UDim2.new(0, 500, 0, 360)
    Main.ClipsDescendants = true
    
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main
    
    MainStroke.Color = Color3.fromRGB(30, 30, 30)
    MainStroke.Thickness = 1.2
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = Main

    MainShadow.Name = "Shadow"
    MainShadow.Parent = Main
    MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainShadow.BackgroundTransparency = 1
    MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainShadow.Size = UDim2.new(1, 40, 1, 40)
    MainShadow.Image = "rbxassetid://6014265364"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.5
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    MainShadow.ZIndex = 0

    -- [ Topbar ] --
    local Topbar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local DescLabel = Instance.new("TextLabel")
    local CloseBtn = Instance.new("TextButton")
    
    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Size = UDim2.new(0, 200, 0, 18)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title:upper()
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    DescLabel.Name = "Desc"
    DescLabel.Parent = Topbar
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 15, 0, 24)
    DescLabel.Size = UDim2.new(0, 200, 0, 12)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = Description
    DescLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    DescLabel.TextSize = 10
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left

    CloseBtn.Name = "Close"
    CloseBtn.Parent = Topbar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.TextSize = 14
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    Library:MakeDraggable(Topbar, Main)

    -- [ Tab System ] --
    local TabHolder = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    TabHolder.Position = UDim2.new(0, 0, 0, 45)
    TabHolder.Size = UDim2.new(1, 0, 0, 35)
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.ScrollingDirection = Enum.ScrollingDirection.X
    
    TabList.Parent = TabHolder
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 15)
    
    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 15)

    local Content = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, 80)
    Content.Size = UDim2.new(1, 0, 1, -80)
    
    PageLayout.Parent = Content
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.TweenTime = 0.4

    local Tabs = {}
    local TabCount = 0

    function Tabs:T(t, icon)
        local TabBtn = Instance.new("TextButton")
        local TabIndicator = Instance.new("Frame")
        local TabLabel = Instance.new("TextLabel")
        
        TabBtn.Name = t .. "_Tab"
        TabBtn.Parent = TabHolder
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.Text = ""
        TabBtn.LayoutOrder = TabCount
        
        TabLabel.Parent = TabBtn
        TabLabel.BackgroundTransparency = 1
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.Text = t
        TabLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        TabLabel.TextSize = 12
        
        TabLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            TabBtn.Size = UDim2.new(0, TabLabel.TextBounds.X + 10, 1, 0)
            TabHolder.CanvasSize = UDim2.new(0, TabList.AbsoluteContentSize.X + 30, 0, 0)
        end)

        TabIndicator.Parent = TabBtn
        TabIndicator.AnchorPoint = Vector2.new(0.5, 1)
        TabIndicator.BackgroundColor3 = AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0.5, 0, 1, 0)
        TabIndicator.Size = UDim2.new(0, 0, 0, 2)

        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")
        
        Page.Name = t .. "_Page"
        Page.Parent = Content
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = AccentColor
        Page.LayoutOrder = TabCount
        
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        
        PagePadding.Parent = Page
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end)

        local function Select()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:Tween(v.TextLabel, 0.3, {TextColor3 = Color3.fromRGB(120, 120, 120)})
                    Library:Tween(v.Frame, 0.3, {Size = UDim2.new(0, 0, 0, 2)})
                end
            end
            Library:Tween(TabLabel, 0.3, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            Library:Tween(TabIndicator, 0.3, {Size = UDim2.new(1, 0, 0, 2)})
            PageLayout:JumpToIndex(Page.LayoutOrder)
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if TabCount == 0 then task.spawn(Select) end
        
        TabCount = TabCount + 1
        local Sections = {}

        function Sections:AddSection(name)
            local SectionFrame = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContainer = Instance.new("Frame")
            local SectionList = Instance.new("UIListLayout")
            
            SectionFrame.Name = name .. "_Section"
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            SectionFrame.Size = UDim2.new(1, 0, 0, 35)
            SectionFrame.ClipsDescendants = true
            
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            SectionStroke.Color = Color3.fromRGB(25, 25, 25)
            SectionStroke.Parent = SectionFrame
            
            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 12, 0, 0)
            SectionTitle.Size = UDim2.new(1, -12, 0, 35)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = name:upper()
            SectionTitle.TextColor3 = AccentColor
            SectionTitle.TextSize = 11
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionContainer.Name = "Container"
            SectionContainer.Parent = SectionFrame
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 10, 0, 35)
            SectionContainer.Size = UDim2.new(1, -20, 0, 0)
            
            SectionList.Parent = SectionContainer
            SectionList.Padding = UDim.new(0, 6)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContainer.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 10)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 45)
            end)

            local Elements = {}
            local CurrentParent = SectionContainer

            function Elements:AddSeperator(text)
                local SepFrame = Instance.new("Frame")
                local SepBtn = Instance.new("TextButton")
                local SepTitle = Instance.new("TextLabel")
                local SepIcon = Instance.new("ImageLabel")
                local Group = Instance.new("Frame")
                local GroupList = Instance.new("UIListLayout")
                
                SepFrame.Name = "Group_" .. text
                SepFrame.Parent = SectionContainer
                SepFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                SepFrame.Size = UDim2.new(1, 0, 0, 32)
                
                local SepCorner = Instance.new("UICorner")
                SepCorner.CornerRadius = UDim.new(0, 6); SepCorner.Parent = SepFrame
                
                SepBtn.Parent = SepFrame; SepBtn.BackgroundTransparency = 1; SepBtn.Size = UDim2.new(1, 0, 1, 0); SepBtn.Text = ""
                SepTitle.Parent = SepFrame; SepTitle.BackgroundTransparency = 1; SepTitle.Position = UDim2.new(0, 10, 0, 0); SepTitle.Size = UDim2.new(1, -40, 1, 0); SepTitle.Font = Enum.Font.GothamBold; SepTitle.Text = text; SepTitle.TextColor3 = Color3.fromRGB(200, 200, 200); SepTitle.TextSize = 11; SepTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                SepIcon.Parent = SepFrame; SepIcon.AnchorPoint = Vector2.new(1, 0.5); SepIcon.BackgroundTransparency = 1; SepIcon.Position = UDim2.new(1, -10, 0.5, 0); SepIcon.Size = UDim2.new(0, 14, 0, 14); SepIcon.Image = "rbxassetid://10131441151"; SepIcon.ImageColor3 = AccentColor

                Group.Name = "GroupContent"
                Group.Parent = SectionContainer
                Group.BackgroundTransparency = 1
                Group.Size = UDim2.new(1, 0, 0, 0)
                Group.ClipsDescendants = true
                Group.Visible = false
                
                GroupList.Parent = Group; GroupList.Padding = UDim.new(0, 6); GroupList.SortOrder = Enum.SortOrder.LayoutOrder
                
                local Open = false
                SepBtn.MouseButton1Click:Connect(function()
                    Open = not Open
                    Group.Visible = Open
                    Library:Tween(SepIcon, 0.3, {Rotation = Open and 90 or 0})
                    if Open then
                        Group.Size = UDim2.new(1, 0, 0, GroupList.AbsoluteContentSize.Y)
                    else
                        Group.Size = UDim2.new(1, 0, 0, 0)
                    end
                end)
                
                GroupList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if Open then Group.Size = UDim2.new(1, 0, 0, GroupList.AbsoluteContentSize.Y) end
                end)
                
                CurrentParent = Group
            end

            function Elements:AddToggle(cfg)
                cfg = cfg or {}
                local Toggled = cfg.Default or false
                local Toggle = Instance.new("TextButton")
                local Title = Instance.new("TextLabel")
                local Desc = Instance.new("TextLabel")
                local Switch = Instance.new("Frame")
                local Knob = Instance.new("Frame")
                
                local hasDesc = cfg.Description and cfg.Description ~= ""
                Toggle.Parent = CurrentParent
                Toggle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                Toggle.Size = UDim2.new(1, 0, 0, hasDesc and 48 or 40)
                Toggle.Text = ""
                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)
                
                Title.Parent = Toggle; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0); Title.Size = UDim2.new(1, -60, 0, hasDesc and 20 or 40); Title.Font = Enum.Font.Gotham; Title.Text = cfg.Title or "Toggle"; Title.TextColor3 = Color3.fromRGB(230, 230, 230); Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
                if hasDesc then Desc.Parent = Toggle; Desc.BackgroundTransparency = 1; Desc.Position = UDim2.new(0, 12, 0, 26); Desc.Size = UDim2.new(1, -60, 0, 16); Desc.Font = Enum.Font.Gotham; Desc.Text = cfg.Description; Desc.TextColor3 = Color3.fromRGB(100, 100, 100); Desc.TextSize = 11; Desc.TextXAlignment = Enum.TextXAlignment.Left end
                
                Switch.Parent = Toggle; Switch.AnchorPoint = Vector2.new(1, 0.5); Switch.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Switch.Position = UDim2.new(1, -12, 0.5, 0); Switch.Size = UDim2.new(0, 34, 0, 18); Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
                Knob.Parent = Switch; Knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150); Knob.Position = UDim2.new(0, 2, 0.5, -7); Knob.Size = UDim2.new(0, 14, 0, 14); Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

                local function Update(noCallback)
                    Library:Tween(Switch, 0.3, {BackgroundColor3 = Toggled and AccentColor or Color3.fromRGB(30, 30, 30)})
                    Library:Tween(Knob, 0.3, {Position = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)})
                    if not noCallback then pcall(cfg.Callback, Toggled) end
                end
                
                Toggle.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                Update(false)
                return { Set = function(self, val) Toggled = val Update() end }
            end

            function Elements:AddButton(cfg)
                cfg = cfg or {}
                local Button = Instance.new("TextButton")
                local Title = Instance.new("TextLabel")
                local hasDesc = cfg.Description and cfg.Description ~= ""
                
                Button.Parent = CurrentParent; Button.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Button.Size = UDim2.new(1, 0, 0, hasDesc and 48 or 40); Button.Text = ""; Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
                Title.Parent = Button; Title.BackgroundTransparency = 1; Title.Size = UDim2.new(1, 0, 1, 0); Title.Font = Enum.Font.GothamBold; Title.Text = cfg.Title or "Button"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 13
                
                Button.MouseEnter:Connect(function() Library:Tween(Button, 0.2, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}) end)
                Button.MouseLeave:Connect(function() Library:Tween(Button, 0.2, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}) end)
                Button.MouseButton1Click:Connect(function()
                    Library:Tween(Title, 0.1, {TextSize = 11})
                    task.wait(0.1)
                    Library:Tween(Title, 0.1, {TextSize = 13})
                    pcall(cfg.Callback)
                end)
            end

            function Elements:AddSlider(cfg)
                cfg = cfg or {}
                local Min, Max, Default = cfg.Min or 0, cfg.Max or 100, cfg.Default or 50
                local Slider = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Value = Instance.new("TextLabel")
                local Bar = Instance.new("Frame")
                local Fill = Instance.new("Frame")
                local Trigger = Instance.new("TextButton")
                
                Slider.Parent = CurrentParent; Slider.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Slider.Size = UDim2.new(1, 0, 0, 50); Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 6)
                Title.Parent = Slider; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 12, 0, 8); Title.Size = UDim2.new(1, -60, 0, 15); Title.Font = Enum.Font.Gotham; Title.Text = cfg.Title or "Slider"; Title.TextColor3 = Color3.fromRGB(200, 200, 200); Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
                Value.Parent = Slider; Value.BackgroundTransparency = 1; Value.Position = UDim2.new(1, -60, 0, 8); Value.Size = UDim2.new(0, 50, 0, 15); Value.Font = Enum.Font.GothamBold; Value.Text = tostring(Default); Value.TextColor3 = AccentColor; Value.TextSize = 12; Value.TextXAlignment = Enum.TextXAlignment.Right
                
                Bar.Parent = Slider; Bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Bar.Position = UDim2.new(0, 12, 0, 32); Bar.Size = UDim2.new(1, -24, 0, 4); Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
                Fill.Parent = Bar; Fill.BackgroundColor3 = AccentColor; Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0); Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
                Trigger.Parent = Bar; Trigger.BackgroundTransparency = 1; Trigger.Size = UDim2.new(1, 0, 1, 0); Trigger.Text = ""

                local function Update(input, noCallback)
                    local Pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local Val = math.floor(Min + (Max - Min) * Pos)
                    Value.Text = tostring(Val)
                    Library:Tween(Fill, 0.1, {Size = UDim2.new(Pos, 0, 1, 0)})
                    if not noCallback then pcall(cfg.Callback, Val) end
                end
                
                local Dragging = false
                Trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true Update(input) end end)
                UserInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                pcall(cfg.Callback, Default)
            end

            function Elements:AddDropdown(cfg)
                cfg = cfg or {}
                local Options = cfg.Options or cfg.Values or {}
                local Dropdown = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Icon = Instance.new("ImageLabel")
                local Trigger = Instance.new("TextButton")
                local List = Instance.new("Frame")
                local ListLayout = Instance.new("UIListLayout")
                
                Dropdown.Parent = CurrentParent; Dropdown.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Dropdown.Size = UDim2.new(1, 0, 0, 40); Dropdown.ClipsDescendants = true; Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
                Title.Parent = Dropdown; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 12, 0, 0); Title.Size = UDim2.new(1, -40, 0, 40); Title.Font = Enum.Font.Gotham; Title.Text = (cfg.Title or "Dropdown") .. " : " .. tostring(cfg.Default or "None"); Title.TextColor3 = Color3.fromRGB(230, 230, 230); Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
                Icon.Parent = Dropdown; Icon.AnchorPoint = Vector2.new(1, 0.5); Icon.BackgroundTransparency = 1; Icon.Position = UDim2.new(1, -12, 0, 20); Icon.Size = UDim2.new(0, 14, 0, 14); Icon.Image = "rbxassetid://10131441151"; Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
                Trigger.Parent = Dropdown; Trigger.BackgroundTransparency = 1; Trigger.Size = UDim2.new(1, 0, 0, 40); Trigger.Text = ""
                
                List.Parent = Dropdown; List.BackgroundTransparency = 1; List.Position = UDim2.new(0, 5, 0, 40); List.Size = UDim2.new(1, -10, 0, 0)
                ListLayout.Parent = List; ListLayout.Padding = UDim.new(0, 4); ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local Open = false
                local function Toggle()
                    Open = not Open
                    Library:Tween(Dropdown, 0.3, {Size = UDim2.new(1, 0, 0, Open and (ListLayout.AbsoluteContentSize.Y + 50) or 40)})
                    Library:Tween(Icon, 0.3, {Rotation = Open and 180 or 0})
                end
                Trigger.MouseButton1Click:Connect(Toggle)

                local function AddOptions(opts)
                    for _, opt in pairs(opts) do
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Parent = List; OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); OptBtn.Size = UDim2.new(1, 0, 0, 30); OptBtn.Font = Enum.Font.Gotham; OptBtn.Text = opt; OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180); OptBtn.TextSize = 12; Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
                        OptBtn.MouseButton1Click:Connect(function()
                            Title.Text = (cfg.Title or "Dropdown") .. " : " .. opt
                            Toggle()
                            pcall(cfg.Callback, opt)
                        end)
                    end
                end
                AddOptions(Options)
                if cfg.Default and cfg.Default ~= "" then pcall(cfg.Callback, cfg.Default) end
                return { Refresh = function(self, new) for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOptions(new) end }
            end

            function Elements:AddTextbox(cfg)
                cfg = cfg or {}
                local Box = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Input = Instance.new("TextBox")
                
                Box.Parent = CurrentParent; Box.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Box.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
                Title.Parent = Box; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 12, 0, 0); Title.Size = UDim2.new(0, 100, 1, 0); Title.Font = Enum.Font.Gotham; Title.Text = cfg.Title or "Input"; Title.TextColor3 = Color3.fromRGB(230, 230, 230); Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
                Input.Parent = Box; Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Input.Position = UDim2.new(1, -160, 0.5, -13); Input.Size = UDim2.new(0, 150, 0, 26); Input.Font = Enum.Font.Gotham; Input.Text = cfg.Default or ""; Input.TextColor3 = Color3.fromRGB(255, 255, 255); Input.TextSize = 12; Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
                Input.FocusLost:Connect(function() pcall(cfg.Callback, Input.Text) end)
                pcall(cfg.Callback, cfg.Default or "")
            end
            Elements.AddInput = Elements.AddTextbox

            function Elements:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentParent; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 25); Label.Font = Enum.Font.Gotham; Label.Text = text; Label.TextColor3 = Color3.fromRGB(150, 150, 150); Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = val end }
            end

            function Elements:AddParagraph(cfg)
                cfg = cfg or {}
                local Para = Instance.new("Frame")
                local Title = Instance.new("TextLabel")
                local Content = Instance.new("TextLabel")
                
                Para.Parent = CurrentParent; Para.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Para.Size = UDim2.new(1, 0, 0, 50); Instance.new("UICorner", Para).CornerRadius = UDim.new(0, 6)
                Title.Parent = Para; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 12, 0, 8); Title.Size = UDim2.new(1, -24, 0, 15); Title.Font = Enum.Font.GothamBold; Title.Text = cfg.Title or "Info"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
                Content.Parent = Para; Content.BackgroundTransparency = 1; Content.Position = UDim2.new(0, 12, 0, 26); Content.Size = UDim2.new(1, -24, 0, 18); Content.Font = Enum.Font.Gotham; Content.Text = cfg.Content or cfg.Desc or ""; Content.TextColor3 = Color3.fromRGB(140, 140, 140); Content.TextSize = 11; Content.TextXAlignment = Enum.TextXAlignment.Left; Content.TextWrapped = true
                
                local function Update() local h = Content.TextBounds.Y Para.Size = UDim2.new(1, 0, 0, h + 35) Content.Size = UDim2.new(1, -24, 0, h) end
                Content:GetPropertyChangedSignal("Text"):Connect(Update); Update()
                return { Set = function(self, val) Content.Text = val end }
            end

            function Elements:AddDiscord(title, invite)
                local Card = Instance.new("Frame")
                local Icon = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local Join = Instance.new("TextButton")
                
                Card.Parent = CurrentParent; Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Card.Size = UDim2.new(1, 0, 0, 60); Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
                Icon.Parent = Card; Icon.BackgroundTransparency = 1; Icon.Position = UDim2.new(0, 10, 0, 10); Icon.Size = UDim2.new(0, 40, 0, 40); Icon.Image = "rbxassetid://123256573634"
                Title.Parent = Card; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 60, 0, 0); Title.Size = UDim2.new(1, -140, 1, 0); Title.Font = Enum.Font.GothamBold; Title.Text = title or "Discord"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left
                Join.Parent = Card; Join.AnchorPoint = Vector2.new(1, 0.5); Join.BackgroundColor3 = AccentColor; Join.Position = UDim2.new(1, -10, 0.5, 0); Join.Size = UDim2.new(0, 70, 0, 30); Join.Font = Enum.Font.GothamBold; Join.Text = "JOIN"; Join.TextColor3 = Color3.fromRGB(255, 255, 255); Join.TextSize = 12; Instance.new("UICorner", Join).CornerRadius = UDim.new(0, 6)
                
                Join.MouseButton1Click:Connect(function() if setclipboard then setclipboard("https://discord.gg/" .. invite) end Join.Text = "COPIED!" task.wait(2) Join.Text = "JOIN" end)
            end

            return Elements
        end
        return Sections
    end

    -- [ Toggle UI Button ] --
    local ToggleGui = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    ToggleGui.Name = "Syntrax_Toggle"; ToggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    MainBtn.Parent = ToggleGui; MainBtn.BackgroundColor3 = AccentColor; MainBtn.Position = UDim2.new(0, 20, 0, 20); MainBtn.Size = UDim2.new(0, 45, 0, 45); MainBtn.Image = "rbxassetid://101817370702077"
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
    Library:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    return Tabs
end

return Library
