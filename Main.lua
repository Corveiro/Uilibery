local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ Utility & Effects ] --
function Library:Tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
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
            Library:Tween(object, 0.1, {Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)}, Enum.EasingStyle.Linear)
        end
    end)
end

-- [ Notification System ] --
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "ArcadeNotifications"
NotifyGui.Parent = (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Name = "Holder"
NotifyHolder.Parent = NotifyGui
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Position = UDim2.new(1, -310, 0, 20)
NotifyHolder.Size = UDim2.new(0, 300, 1, -40)

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Parent = NotifyHolder
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 10)

function Library:Notify(config)
    config = config or {}
    local title = config.Title or "NOTIFICATION"
    local content = config.Content or config.Text or "Message goes here..."
    local duration = config.Duration or 5
    local color = config.Color or Color3.fromRGB(255, 0, 0)

    local Card = Instance.new("Frame")
    local CardStroke = Instance.new("UIStroke")
    local CardCorner = Instance.new("UICorner")
    local TitleLabel = Instance.new("TextLabel")
    local ContentLabel = Instance.new("TextLabel")
    local TimerBar = Instance.new("Frame")
    local Glow = Instance.new("ImageLabel")

    Card.Name = "Notification"
    Card.Parent = NotifyHolder
    Card.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Card.Size = UDim2.new(0, 0, 0, 65)
    Card.ClipsDescendants = true
    Card.Transparency = 1

    CardCorner.CornerRadius = UDim.new(0, 4)
    CardCorner.Parent = Card

    CardStroke.Color = color
    CardStroke.Thickness = 1.5
    CardStroke.Parent = Card
    CardStroke.Transparency = 1

    TitleLabel.Parent = Card
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 12, 0, 8)
    TitleLabel.Size = UDim2.new(1, -24, 0, 15)
    TitleLabel.Font = Enum.Font.Arcade
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = color
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    ContentLabel.Parent = Card
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Position = UDim2.new(0, 12, 0, 26)
    ContentLabel.Size = UDim2.new(1, -24, 0, 30)
    ContentLabel.Font = Enum.Font.Code
    ContentLabel.Text = content
    ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ContentLabel.TextSize = 12
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true

    TimerBar.Parent = Card
    TimerBar.BackgroundColor3 = color
    TimerBar.BorderSizePixel = 0
    TimerBar.Position = UDim2.new(0, 0, 1, -2)
    TimerBar.Size = UDim2.new(1, 0, 0, 2)

    Library:Tween(Card, 0.5, {Size = UDim2.new(1, 0, 0, 65), Transparency = 0}, Enum.EasingStyle.Back)
    Library:Tween(CardStroke, 0.5, {Transparency = 0})
    
    Library:Tween(TimerBar, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Library:Tween(Card, 0.5, {Size = UDim2.new(0, 0, 0, 65), Transparency = 1}, Enum.EasingStyle.Back)
        Library:Tween(CardStroke, 0.5, {Transparency = 1})
        task.wait(0.5)
        Card:Destroy()
    end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "ARCADE HUB",
        Description = "Magnificent Edition",
        AccentColor = Color3.fromRGB(255, 0, 0)
    }, ConfigWindow or {})

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "Arcade_Magnificent"
    MainGui.Parent = (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Container = Instance.new("Frame")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local Scanlines = Instance.new("ImageLabel")
    
    -- Structure
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local Logo = Instance.new("ImageLabel")
    local ControlButtons = Instance.new("Frame")
    local CloseBtn = Instance.new("TextButton")
    local MinBtn = Instance.new("TextButton")
    
    local Sidebar = Instance.new("Frame")
    local InfoBar = Instance.new("Frame")
    local FPSLabel = Instance.new("TextLabel")
    local PingLabel = Instance.new("TextLabel")
    local TabScroll = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    
    local ContentArea = Instance.new("Frame")
    local PageLayout = Instance.new("UIPageLayout")
    local PagesFolder = Instance.new("Folder")

    -- Window Styling
    Container.Name = "Container"
    Container.Parent = MainGui
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 480, 0, 340)
    Container.BackgroundTransparency = 1

    Main.Name = "Main"
    Main.Parent = Container
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true

    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = Main

    MainStroke.Color = ConfigWindow.AccentColor
    MainStroke.Thickness = 2
    MainStroke.Parent = Main
    
    -- [ IMPROVEMENT: Pulsing Glow ]
    task.spawn(function()
        while task.wait() do
            for i = 0, 1, 0.01 do
                MainStroke.Transparency = 0.2 + (math.sin(tick() * 2) * 0.2)
                task.wait(0.05)
            end
        end
    end)

    -- [ IMPROVEMENT: Scanline Effect ]
    Scanlines.Name = "Scanlines"
    Scanlines.Parent = Main
    Scanlines.BackgroundTransparency = 1
    Scanlines.Size = UDim2.new(1, 0, 1, 0)
    Scanlines.Image = "rbxassetid://6071575215" -- Scanline pattern
    Scanlines.ImageTransparency = 0.9
    Scanlines.ScaleType = Enum.ScaleType.Tile
    Scanlines.TileSize = UDim2.new(0, 128, 0, 128)
    Scanlines.ZIndex = 10

    -- TopBar
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    TopBar.Size = UDim2.new(1, 0, 0, 45)

    Logo.Name = "Logo"
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 12, 0, 7)
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Image = "rbxassetid://101817370702077"

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 50, 0, 8)
    Title.Size = UDim2.new(0, 200, 0, 18)
    Title.Font = Enum.Font.Arcade
    Title.Text = ConfigWindow.Title:upper()
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    SubTitle.Name = "SubTitle"
    SubTitle.Parent = TopBar
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 50, 0, 25)
    SubTitle.Size = UDim2.new(0, 200, 0, 12)
    SubTitle.Font = Enum.Font.Code
    SubTitle.Text = ConfigWindow.Description
    SubTitle.TextColor3 = ConfigWindow.AccentColor
    SubTitle.TextSize = 10
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    ControlButtons.Name = "Controls"
    ControlButtons.Parent = TopBar
    ControlButtons.BackgroundTransparency = 1
    ControlButtons.Position = UDim2.new(1, -70, 0, 0)
    ControlButtons.Size = UDim2.new(0, 60, 1, 0)

    local ControlLayout = Instance.new("UIListLayout")
    ControlLayout.Parent = ControlButtons
    ControlLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlLayout.Padding = UDim.new(0, 8)

    CloseBtn.Name = "Close"
    CloseBtn.Parent = ControlButtons
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Font = Enum.Font.Arcade
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.TextSize = 16

    MinBtn.Name = "Min"
    MinBtn.Parent = ControlButtons
    MinBtn.BackgroundTransparency = 1
    MinBtn.Size = UDim2.new(0, 20, 0, 20)
    MinBtn.Font = Enum.Font.Arcade
    MinBtn.Text = "_"
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.TextSize = 16

    -- Sidebar (Vertical Tabs for better organization)
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.Size = UDim2.new(0, 130, 1, -45)

    InfoBar.Name = "InfoBar"
    InfoBar.Parent = Sidebar
    InfoBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    InfoBar.Position = UDim2.new(0, 0, 1, -30)
    InfoBar.Size = UDim2.new(1, 0, 0, 30)

    FPSLabel.Parent = InfoBar
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Position = UDim2.new(0, 8, 0, 0)
    FPSLabel.Size = UDim2.new(0.5, -8, 1, 0)
    FPSLabel.Font = Enum.Font.Code
    FPSLabel.Text = "FPS: 60"
    FPSLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    FPSLabel.TextSize = 10
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

    PingLabel.Parent = InfoBar
    PingLabel.BackgroundTransparency = 1
    PingLabel.Position = UDim2.new(0.5, 0, 0, 0)
    PingLabel.Size = UDim2.new(0.5, -8, 1, 0)
    PingLabel.Font = Enum.Font.Code
    PingLabel.Text = "MS: 0"
    PingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    PingLabel.TextSize = 10
    PingLabel.TextXAlignment = Enum.TextXAlignment.Right

    task.spawn(function()
        while task.wait(1) do
            FPSLabel.Text = "FPS: " .. math.floor(1/RunService.RenderStepped:Wait())
            local ping = tonumber(string.format("%.0f", game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()))
            PingLabel.Text = "MS: " .. ping
        end
    end)

    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, 0, 1, -30)
    TabScroll.Parent = Sidebar
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0

    TabList.Parent = TabScroll
    TabList.Padding = UDim.new(0, 4)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    TabPadding.Parent = TabScroll
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)

    -- Content
    ContentArea.Name = "Content"
    ContentArea.Parent = Main
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 130, 0, 45)
    ContentArea.Size = UDim2.new(1, -130, 1, -45)

    PagesFolder.Name = "Pages"
    PagesFolder.Parent = ContentArea
    PageLayout.Parent = PagesFolder
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.TweenTime = 0.4

    -- Functions
    Library:MakeDraggable(TopBar, Container)
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)
    MinBtn.MouseButton1Click:Connect(function() MainGui.Enabled = not MainGui.Enabled end)

    local TabCount = 0
    local Tabs = {}
    local FirstTab = true

    function Tabs:T(t, icon)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local TabBtnLabel = Instance.new("TextLabel")
        local TabIcon = Instance.new("ImageLabel")
        local ActiveLine = Instance.new("Frame")

        local Page = Instance.new("ScrollingFrame")
        local PageList = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        -- Tab Button Styling
        TabBtn.Name = t .. "_Tab"
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.Text = ""
        TabBtn.LayoutOrder = TabCount

        TabBtnCorner.CornerRadius = UDim.new(0, 4)
        TabBtnCorner.Parent = TabBtn

        TabBtnLabel.Parent = TabBtn
        TabBtnLabel.BackgroundTransparency = 1
        TabBtnLabel.Position = UDim2.new(0, 32, 0, 0)
        TabBtnLabel.Size = UDim2.new(1, -32, 1, 0)
        TabBtnLabel.Font = Enum.Font.Code
        TabBtnLabel.Text = t:upper()
        TabBtnLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtnLabel.TextSize = 11
        TabBtnLabel.TextXAlignment = Enum.TextXAlignment.Left

        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Image = icon or "rbxassetid://6031763447"
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        ActiveLine.Name = "Active"
        ActiveLine.Parent = TabBtn
        ActiveLine.BackgroundColor3 = ConfigWindow.AccentColor
        ActiveLine.BorderSizePixel = 0
        ActiveLine.Position = UDim2.new(0, 0, 0.2, 0)
        ActiveLine.Size = UDim2.new(0, 2, 0.6, 0)
        ActiveLine.Transparency = 1

        -- Page Styling
        Page.Name = t .. "_Page"
        Page.Parent = PagesFolder
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = ConfigWindow.AccentColor
        Page.LayoutOrder = TabCount

        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 12)
        PagePadding.PaddingLeft = UDim.new(0, 12)
        PagePadding.PaddingRight = UDim.new(0, 12)
        PagePadding.PaddingBottom = UDim.new(0, 12)

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 24)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabScroll:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:Tween(v, 0.2, {BackgroundTransparency = 1})
                    Library:Tween(v.TextLabel, 0.2, {TextColor3 = Color3.fromRGB(150, 150, 150)})
                    Library:Tween(v.ImageLabel, 0.2, {ImageColor3 = Color3.fromRGB(150, 150, 150)})
                    Library:Tween(v.Active, 0.2, {Transparency = 1})
                end
            end
            Library:Tween(TabBtn, 0.2, {BackgroundTransparency = 0})
            Library:Tween(TabBtnLabel, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            Library:Tween(TabIcon, 0.2, {ImageColor3 = ConfigWindow.AccentColor})
            Library:Tween(ActiveLine, 0.2, {Transparency = 0})
            PageLayout:JumpToIndex(TabBtn.LayoutOrder)
        end)

        if FirstTab then
            FirstTab = false
            TabBtn.BackgroundTransparency = 0
            TabBtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = ConfigWindow.AccentColor
            ActiveLine.Transparency = 0
        end

        TabCount = TabCount + 1
        local TabFunc = {}

        function TabFunc:AddSection(title)
            local SecFrame = Instance.new("Frame")
            local SecTitle = Instance.new("TextLabel")
            local SecContainer = Instance.new("Frame")
            local SecLayout = Instance.new("UIListLayout")

            SecFrame.Name = title .. "_Section"
            SecFrame.Parent = Page
            SecFrame.BackgroundTransparency = 1
            SecFrame.Size = UDim2.new(1, 0, 0, 25)
            SecFrame.AutomaticSize = Enum.AutomaticSize.Y

            SecTitle.Parent = SecFrame
            SecTitle.BackgroundTransparency = 1
            SecTitle.Size = UDim2.new(1, 0, 0, 20)
            SecTitle.Font = Enum.Font.Arcade
            SecTitle.Text = ":: " .. title:upper()
            SecTitle.TextColor3 = ConfigWindow.AccentColor
            SecTitle.TextSize = 12
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left

            SecContainer.Parent = SecFrame
            SecContainer.BackgroundTransparency = 1
            SecContainer.Position = UDim2.new(0, 0, 0, 22)
            SecContainer.Size = UDim2.new(1, 0, 0, 0)
            SecContainer.AutomaticSize = Enum.AutomaticSize.Y

            SecLayout.Parent = SecContainer
            SecLayout.Padding = UDim.new(0, 6)
            SecLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local Elements = {}

            function Elements:AddButton(config)
                config = Library:MakeConfig({Title = "Button", Callback = function() end}, config or {})
                local Btn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnLabel = Instance.new("TextLabel")

                Btn.Parent = SecContainer
                Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Btn.Size = UDim2.new(1, 0, 0, 34)
                Btn.Text = ""
                Btn.AutoButtonColor = false

                BtnCorner.CornerRadius = UDim.new(0, 4)
                BtnCorner.Parent = Btn

                BtnStroke.Color = Color3.fromRGB(45, 45, 55)
                BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                BtnStroke.Parent = Btn

                BtnLabel.Parent = Btn
                BtnLabel.BackgroundTransparency = 1
                BtnLabel.Size = UDim2.new(1, 0, 1, 0)
                BtnLabel.Font = Enum.Font.Code
                BtnLabel.Text = config.Title
                BtnLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                BtnLabel.TextSize = 13

                Btn.MouseEnter:Connect(function() Library:Tween(BtnStroke, 0.2, {Color = ConfigWindow.AccentColor}) end)
                Btn.MouseLeave:Connect(function() Library:Tween(BtnStroke, 0.2, {Color = Color3.fromRGB(45, 45, 55)}) end)
                Btn.MouseButton1Down:Connect(function() Library:Tween(Btn, 0.1, {Size = UDim2.new(0.98, 0, 0, 32)}, Enum.EasingStyle.Quad) end)
                Btn.MouseButton1Up:Connect(function() 
                    Library:Tween(Btn, 0.1, {Size = UDim2.new(1, 0, 0, 34)}, Enum.EasingStyle.Quad)
                    pcall(config.Callback)
                end)

                -- Tooltip Improvement
                if config.Description or config.Tooltip then
                    local Tooltip = Instance.new("TextLabel")
                    Tooltip.Parent = MainGui
                    Tooltip.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                    Tooltip.Size = UDim2.new(0, 0, 0, 20)
                    Tooltip.Visible = false
                    Tooltip.ZIndex = 100
                    Tooltip.Font = Enum.Font.Code
                    Tooltip.Text = config.Description or config.Tooltip
                    Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Tooltip.TextSize = 11
                    local TooltipCorner = Instance.new("UICorner"); TooltipCorner.CornerRadius = UDim.new(0, 4); TooltipCorner.Parent = Tooltip
                    local TooltipStroke = Instance.new("UIStroke"); TooltipStroke.Color = ConfigWindow.AccentColor; TooltipStroke.Parent = Tooltip

                    Btn.MouseEnter:Connect(function()
                        Tooltip.Visible = true
                        local textWidth = game:GetService("TextService"):GetTextSize(Tooltip.Text, Tooltip.TextSize, Tooltip.Font, Vector2.new(1000, 1000)).X
                        Tooltip.Size = UDim2.new(0, textWidth + 10, 0, 20)
                    end)
                    Btn.MouseMoved:Connect(function()
                        Tooltip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
                    end)
                    Btn.MouseLeave:Connect(function() Tooltip.Visible = false end)
                end

                return {Set = function(self, t) BtnLabel.Text = t end}
            end

            function Elements:AddToggle(config)
                config = Library:MakeConfig({Title = "Toggle", Default = false, Callback = function() end}, config or {})
                local Toggled = config.Default
                local Tog = Instance.new("TextButton")
                local TogCorner = Instance.new("UICorner")
                local TogLabel = Instance.new("TextLabel")
                local Switch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local Dot = Instance.new("Frame")
                local DotCorner = Instance.new("UICorner")

                Tog.Parent = SecContainer
                Tog.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Tog.Size = UDim2.new(1, 0, 0, 34)
                Tog.Text = ""

                TogCorner.CornerRadius = UDim.new(0, 4)
                TogCorner.Parent = Tog

                TogLabel.Parent = Tog
                TogLabel.BackgroundTransparency = 1
                TogLabel.Position = UDim2.new(0, 12, 0, 0)
                TogLabel.Size = UDim2.new(1, -60, 1, 0)
                TogLabel.Font = Enum.Font.Code
                TogLabel.Text = config.Title
                TogLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                TogLabel.TextSize = 13
                TogLabel.TextXAlignment = Enum.TextXAlignment.Left

                Switch.Parent = Tog
                Switch.AnchorPoint = Vector2.new(0, 0.5)
                Switch.BackgroundColor3 = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(45, 45, 55)
                Switch.Position = UDim2.new(1, -45, 0.5, 0)
                Switch.Size = UDim2.new(0, 34, 0, 18)

                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = Switch

                Dot.Parent = Switch
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dot.Position = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Dot.Size = UDim2.new(0, 14, 0, 14)
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = Dot

                local function Update()
                    Library:Tween(Switch, 0.2, {BackgroundColor3 = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(45, 45, 55)})
                    Library:Tween(Dot, 0.2, {Position = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                    pcall(config.Callback, Toggled)
                end

                Tog.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                pcall(config.Callback, Toggled)
                return {Set = function(self, v) Toggled = v Update() end}
            end

            function Elements:AddSlider(config)
                config = Library:MakeConfig({Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end}, config or {})
                local Slid = Instance.new("Frame")
                local SlidCorner = Instance.new("UICorner")
                local SlidLabel = Instance.new("TextLabel")
                local ValLabel = Instance.new("TextLabel")
                local Bar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local Fill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local Trigger = Instance.new("TextButton")

                Slid.Parent = SecContainer
                Slid.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Slid.Size = UDim2.new(1, 0, 0, 48)

                SlidCorner.CornerRadius = UDim.new(0, 4)
                SlidCorner.Parent = Slid

                SlidLabel.Parent = Slid
                SlidLabel.BackgroundTransparency = 1
                SlidLabel.Position = UDim2.new(0, 12, 0, 8)
                SlidLabel.Size = UDim2.new(0.5, 0, 0, 15)
                SlidLabel.Font = Enum.Font.Code
                SlidLabel.Text = config.Title
                SlidLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                SlidLabel.TextSize = 12
                SlidLabel.TextXAlignment = Enum.TextXAlignment.Left

                ValLabel.Parent = Slid
                ValLabel.BackgroundTransparency = 1
                ValLabel.Position = UDim2.new(0.5, 0, 0, 8)
                ValLabel.Size = UDim2.new(0.5, -12, 0, 15)
                ValLabel.Font = Enum.Font.Code
                ValLabel.Text = tostring(config.Default)
                ValLabel.TextColor3 = ConfigWindow.AccentColor
                ValLabel.TextSize = 12
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                Bar.Parent = Slid
                Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                Bar.Position = UDim2.new(0, 12, 0, 30)
                Bar.Size = UDim2.new(1, -24, 0, 6)
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = Bar

                Fill.Parent = Bar
                Fill.BackgroundColor3 = ConfigWindow.AccentColor
                Fill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                Trigger.Parent = Bar
                Trigger.BackgroundTransparency = 1
                Trigger.Size = UDim2.new(1, 0, 1, 0)
                Trigger.Text = ""

                local function Move()
                    local perc = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(config.Min + (config.Max - config.Min) * perc)
                    ValLabel.Text = tostring(val)
                    Library:Tween(Fill, 0.1, {Size = UDim2.new(perc, 0, 1, 0)})
                    pcall(config.Callback, val)
                end

                local Dragging = false
                Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true Move() end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                UserInputService.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Move() end end)
                
                pcall(config.Callback, config.Default)
                return {Set = function(self, v) ValLabel.Text = tostring(v) Fill.Size = UDim2.new((v - config.Min) / (config.Max - config.Min), 0, 1, 0) pcall(config.Callback, v) end}
            end

            function Elements:AddDropdown(config)
                config = Library:MakeConfig({Title = "Dropdown", Options = {}, Default = "", Callback = function() end}, config or {})
                local options = config.Options or config.Values or {}
                local Drop = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropBtn = Instance.new("TextButton")
                local DropLabel = Instance.new("TextLabel")
                local Icon = Instance.new("TextLabel")
                local List = Instance.new("Frame")
                local ListLayout = Instance.new("UIListLayout")
                local ListPadding = Instance.new("UIPadding")

                Drop.Parent = SecContainer
                Drop.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Drop.Size = UDim2.new(1, 0, 0, 34)
                Drop.ClipsDescendants = true
                DropCorner.CornerRadius = UDim.new(0, 4)
                DropCorner.Parent = Drop

                DropBtn.Parent = Drop
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 34)
                DropBtn.Text = ""

                DropLabel.Parent = Drop
                DropLabel.BackgroundTransparency = 1
                DropLabel.Position = UDim2.new(0, 12, 0, 0)
                DropLabel.Size = UDim2.new(1, -40, 0, 34)
                DropLabel.Font = Enum.Font.Code
                DropLabel.Text = config.Title .. ": " .. tostring(config.Default)
                DropLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                DropLabel.TextSize = 12
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left

                Icon.Parent = Drop
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(1, -30, 0, 0)
                Icon.Size = UDim2.new(0, 30, 0, 34)
                Icon.Font = Enum.Font.Arcade
                Icon.Text = "+"
                Icon.TextColor3 = ConfigWindow.AccentColor
                Icon.TextSize = 14

                List.Parent = Drop
                List.BackgroundTransparency = 1
                List.Position = UDim2.new(0, 0, 0, 34)
                List.Size = UDim2.new(1, 0, 0, 0)
                ListLayout.Parent = List
                ListLayout.Padding = UDim.new(0, 4)
                ListPadding.Parent = List
                ListPadding.PaddingLeft = UDim.new(0, 6)
                ListPadding.PaddingRight = UDim.new(0, 6)
                ListPadding.PaddingBottom = UDim.new(0, 6)

                local Open = false
                local function Toggle()
                    Open = not Open
                    local target = Open and (ListLayout.AbsoluteContentSize.Y + 40) or 34
                    Library:Tween(Drop, 0.3, {Size = UDim2.new(1, 0, 0, target)})
                    Icon.Text = Open and "-" or "+"
                end
                DropBtn.MouseButton1Click:Connect(Toggle)

                local function AddOpts(opts)
                    for _, o in pairs(opts) do
                        local Opt = Instance.new("TextButton")
                        local OptCorner = Instance.new("UICorner")
                        Opt.Parent = List
                        Opt.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                        Opt.Size = UDim2.new(1, 0, 0, 28)
                        Opt.Font = Enum.Font.Code
                        Opt.Text = o
                        Opt.TextColor3 = Color3.fromRGB(180, 180, 180)
                        Opt.TextSize = 11
                        OptCorner.CornerRadius = UDim.new(0, 3)
                        OptCorner.Parent = Opt
                        Opt.MouseButton1Click:Connect(function()
                            DropLabel.Text = config.Title .. ": " .. o
                            Toggle()
                            pcall(config.Callback, o)
                        end)
                    end
                end
                AddOpts(options)
                return {Refresh = function(self, new) for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOpts(new) end}
            end

            function Elements:AddTextbox(config)
                config = Library:MakeConfig({Title = "Textbox", Default = "", Callback = function() end}, config or {})
                local Box = Instance.new("Frame")
                local BoxCorner = Instance.new("UICorner")
                local BoxLabel = Instance.new("TextLabel")
                local Input = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")

                Box.Parent = SecContainer
                Box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Box.Size = UDim2.new(1, 0, 0, 34)
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = Box

                BoxLabel.Parent = Box
                BoxLabel.BackgroundTransparency = 1
                BoxLabel.Position = UDim2.new(0, 12, 0, 0)
                BoxLabel.Size = UDim2.new(0, 100, 1, 0)
                BoxLabel.Font = Enum.Font.Code
                BoxLabel.Text = config.Title
                BoxLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                BoxLabel.TextSize = 12
                BoxLabel.TextXAlignment = Enum.TextXAlignment.Left

                Input.Parent = Box
                Input.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                Input.Position = UDim2.new(1, -130, 0.5, -11)
                Input.Size = UDim2.new(0, 120, 0, 22)
                Input.Font = Enum.Font.Code
                Input.Text = config.Default
                Input.TextColor3 = ConfigWindow.AccentColor
                Input.TextSize = 11
                InputCorner.CornerRadius = UDim.new(0, 3)
                InputCorner.Parent = Input

                Input.FocusLost:Connect(function() pcall(config.Callback, Input.Text) end)
            end
            Elements.AddInput = Elements.AddTextbox

            function Elements:AddLabel(text)
                local Lab = Instance.new("TextLabel")
                Lab.Parent = SecContainer
                Lab.BackgroundTransparency = 1
                Lab.Size = UDim2.new(1, 0, 0, 20)
                Lab.Font = Enum.Font.Code
                Lab.Text = "> " .. text
                Lab.TextColor3 = Color3.fromRGB(160, 160, 180)
                Lab.TextSize = 12
                Lab.TextXAlignment = Enum.TextXAlignment.Left
                return {Set = function(self, v) Lab.Text = "> " .. v end}
            end

            function Elements:AddParagraph(config)
                config = Library:MakeConfig({Title = "Info", Content = ""}, config or {})
                local Para = Instance.new("Frame")
                local ParaCorner = Instance.new("UICorner")
                local ParaTitle = Instance.new("TextLabel")
                local ParaText = Instance.new("TextLabel")

                Para.Parent = SecContainer
                Para.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                Para.Size = UDim2.new(1, 0, 0, 40)
                ParaCorner.CornerRadius = UDim.new(0, 4)
                ParaCorner.Parent = Para

                ParaTitle.Parent = Para
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 12, 0, 6)
                ParaTitle.Size = UDim2.new(1, -24, 0, 15)
                ParaTitle.Font = Enum.Font.Arcade
                ParaTitle.Text = config.Title:upper()
                ParaTitle.TextColor3 = ConfigWindow.AccentColor
                ParaTitle.TextSize = 12
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaText.Parent = Para
                ParaText.BackgroundTransparency = 1
                ParaText.Position = UDim2.new(0, 12, 0, 22)
                ParaText.Size = UDim2.new(1, -24, 0, 15)
                ParaText.Font = Enum.Font.Code
                ParaText.Text = config.Content or config.Desc or ""
                ParaText.TextColor3 = Color3.fromRGB(180, 180, 200)
                ParaText.TextSize = 11
                ParaText.TextXAlignment = Enum.TextXAlignment.Left
                ParaText.TextWrapped = true

                local function Update()
                    Para.Size = UDim2.new(1, 0, 0, ParaText.TextBounds.Y + 32)
                    ParaText.Size = UDim2.new(1, -24, 0, ParaText.TextBounds.Y)
                end
                ParaText:GetPropertyChangedSignal("Text"):Connect(Update)
                Update()
                return {Set = function(self, v) ParaText.Text = v end}
            end

            function Elements:AddSeperator(text)
                local Sep = Instance.new("Frame")
                local Lab = Instance.new("TextLabel")
                local L = Instance.new("Frame")
                local R = Instance.new("Frame")

                Sep.Parent = SecContainer
                Sep.BackgroundTransparency = 1
                Sep.Size = UDim2.new(1, 0, 0, 20)

                Lab.Parent = Sep
                Lab.AnchorPoint = Vector2.new(0.5, 0.5)
                Lab.BackgroundTransparency = 1
                Lab.Position = UDim2.new(0.5, 0, 0.5, 0)
                Lab.AutomaticSize = Enum.AutomaticSize.X
                Lab.Font = Enum.Font.Code
                Lab.Text = text:upper()
                Lab.TextColor3 = Color3.fromRGB(80, 80, 100)
                Lab.TextSize = 10

                L.Parent = Sep
                L.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                L.BorderSizePixel = 0
                L.Position = UDim2.new(0, 0, 0.5, 0)
                L.Size = UDim2.new(0.5, -60, 0, 1)

                R.Parent = Sep
                R.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                R.BorderSizePixel = 0
                R.Position = UDim2.new(1, 0, 0.5, 0)
                R.AnchorPoint = Vector2.new(1, 0)
                R.Size = UDim2.new(0.5, -60, 0, 1)
            end

            function Elements:AddDiscord(title, invite)
                local Card = Instance.new("Frame")
                local CardCorner = Instance.new("UICorner")
                local Icon = Instance.new("ImageLabel")
                local Lab = Instance.new("TextLabel")
                local Join = Instance.new("TextButton")
                local JoinCorner = Instance.new("UICorner")

                Card.Parent = SecContainer
                Card.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                Card.Size = UDim2.new(1, 0, 0, 50)
                CardCorner.CornerRadius = UDim.new(0, 4)
                CardCorner.Parent = Card

                Icon.Parent = Card
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 10, 0.5, -15)
                Icon.Size = UDim2.new(0, 30, 0, 30)
                Icon.Image = "rbxassetid://101817370702077"

                Lab.Parent = Card
                Lab.BackgroundTransparency = 1
                Lab.Position = UDim2.new(0, 50, 0, 0)
                Lab.Size = UDim2.new(1, -120, 1, 0)
                Lab.Font = Enum.Font.Arcade
                Lab.Text = (title or "DISCORD"):upper()
                Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
                Lab.TextSize = 12
                Lab.TextXAlignment = Enum.TextXAlignment.Left

                Join.Parent = Card
                Join.BackgroundColor3 = ConfigWindow.AccentColor
                Join.Position = UDim2.new(1, -65, 0.5, -12)
                Join.Size = UDim2.new(0, 55, 0, 24)
                Join.Font = Enum.Font.Arcade
                Join.Text = "JOIN"
                Join.TextColor3 = Color3.fromRGB(255, 255, 255)
                Join.TextSize = 11
                JoinCorner.CornerRadius = UDim.new(0, 3)
                JoinCorner.Parent = Join

                Join.MouseButton1Click:Connect(function()
                    if setclipboard then setclipboard("https://discord.gg/" .. invite) end
                    Join.Text = "COPIED"
                    task.wait(2)
                    Join.Text = "JOIN"
                end)
            end

            return Elements
        end

        return TabFunc
    end

    -- Toggle UI Button
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    ToggleBtn.Name = "ArcadeToggle"
    ToggleBtn.Parent = (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
    
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = ConfigWindow.AccentColor
    MainBtn.Position = UDim2.new(0, 20, 0, 20)
    MainBtn.Size = UDim2.new(0, 45, 0, 45)
    MainBtn.Image = "rbxassetid://101817370702077"
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = MainBtn
    BtnStroke.Color = Color3.fromRGB(20, 20, 30)
    BtnStroke.Thickness = 2
    BtnStroke.Parent = MainBtn
    Library:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() Container.Visible = not Container.Visible end)

    -- Initial Notification
    Library:Notify({
        Title = "SYSTEM LOADED",
        Content = "Welcome to " .. ConfigWindow.Title .. ". All systems online.",
        Duration = 5
    })

    return Tabs
end

return Library
