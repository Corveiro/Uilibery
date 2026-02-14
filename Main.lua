
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

-- [ Global State for Intelligent Monitor ] --
local CurrentTabName = ""
local ActiveTogglesByTab = {} -- { [TabName] = { [ToggleTitle] = state } }

-- [ Active Functions Monitor ] --
local ActiveFunctionsGui = Instance.new("ScreenGui")
ActiveFunctionsGui.Name = "ArcadeActiveMonitor"
ActiveFunctionsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ActiveFunctionsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ActiveHolder = Instance.new("Frame")
ActiveHolder.Name = "ActiveHolder"
ActiveHolder.Parent = ActiveFunctionsGui
ActiveHolder.BackgroundTransparency = 1
ActiveHolder.Position = UDim2.new(0, 15, 0.4, 0)
ActiveHolder.Size = UDim2.new(0, 250, 0.5, 0)

local ActiveList = Instance.new("UIListLayout")
ActiveList.Parent = ActiveHolder
ActiveList.Padding = UDim.new(0, 6)
ActiveList.SortOrder = Enum.SortOrder.LayoutOrder

function Library:UpdateActiveMonitor()
    for _, v in pairs(ActiveHolder:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    
    local currentTabToggles = ActiveTogglesByTab[CurrentTabName]
    if not currentTabToggles then return end
    
    for title, state in pairs(currentTabToggles) do
        if state then
            local StatusFrame = Instance.new("Frame")
            local StatusLabel = Instance.new("TextLabel")
            local StatusOn = Instance.new("TextLabel")
            local StatusCorner = Instance.new("UICorner")
            local StatusStroke = Instance.new("UIStroke")
            
            StatusFrame.Name = title
            StatusFrame.Parent = ActiveHolder
            StatusFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
            StatusFrame.BackgroundTransparency = 0.4
            StatusFrame.Size = UDim2.new(0, 0, 0, 24)
            StatusFrame.AutomaticSize = Enum.AutomaticSize.X
            
            StatusCorner.CornerRadius = UDim.new(0, 2)
            StatusCorner.Parent = StatusFrame
            
            StatusStroke.Color = Color3.fromRGB(0, 255, 150)
            StatusStroke.Thickness = 1
            StatusStroke.Transparency = 0.6
            StatusStroke.Parent = StatusFrame
            
            StatusLabel.Parent = StatusFrame
            StatusLabel.BackgroundTransparency = 1
            StatusLabel.Position = UDim2.new(0, 10, 0, 0)
            StatusLabel.Size = UDim2.new(0, 0, 1, 0)
            StatusLabel.AutomaticSize = Enum.AutomaticSize.X
            StatusLabel.Font = Enum.Font.Code
            StatusLabel.Text = title:upper()
            StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            StatusLabel.TextSize = 11
            
            StatusOn.Parent = StatusFrame
            StatusOn.BackgroundTransparency = 1
            StatusOn.Position = UDim2.new(0, 5, 0, 0) -- Extra space between title and ON
            StatusOn.Size = UDim2.new(0, 0, 1, 0)
            StatusOn.AutomaticSize = Enum.AutomaticSize.X
            StatusOn.Font = Enum.Font.Arcade
            StatusOn.Text = " ON"
            StatusOn.TextColor3 = Color3.fromRGB(0, 255, 150)
            StatusOn.TextSize = 11
            
            -- UIListLayout will handle positioning, we just need a small horizontal layout inside the frame
            local InternalLayout = Instance.new("UIListLayout")
            InternalLayout.Parent = StatusFrame
            InternalLayout.FillDirection = Enum.FillDirection.Horizontal
            InternalLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            InternalLayout.Padding = UDim.new(0, 10) -- Space between Title and ON
            
            StatusLabel.Parent = StatusFrame
            StatusOn.Parent = StatusFrame
            
            local InternalPadding = Instance.new("UIPadding")
            InternalPadding.Parent = StatusFrame
            InternalPadding.PaddingLeft = UDim.new(0, 10)
            InternalPadding.PaddingRight = UDim.new(0, 10)
            
            -- Simple animation for appearing
            StatusFrame.GroupTransparency = 1
            game:GetService("TweenService"):Create(StatusFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.4}):Play()
        end
    end
end

-- [ Notification System - Arcade Theme ] --
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "ArcadeNotifications"
NotificationGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Parent = NotificationGui
NotifHolder.BackgroundTransparency = 1
NotifHolder.Position = UDim2.new(1, -320, 0, 30)
NotifHolder.Size = UDim2.new(0, 300, 1, -60)

local NotifList = Instance.new("UIListLayout")
NotifList.Parent = NotifHolder
NotifList.Padding = UDim.new(0, 12)
NotifList.VerticalAlignment = Enum.VerticalAlignment.Top
NotifList.SortOrder = Enum.SortOrder.LayoutOrder

function Library:Notify(ConfigNotif)
    ConfigNotif = self:MakeConfig({
        Title = "SYSTEM ALERT",
        Content = "Operation successful.",
        Duration = 5,
        Color = Color3.fromRGB(0, 255, 255)
    }, ConfigNotif or {})

    local NotifFrame = Instance.new("Frame")
    local NotifStroke = Instance.new("UIStroke")
    local NotifTitle = Instance.new("TextLabel")
    local NotifContent = Instance.new("TextLabel")
    local NotifBar = Instance.new("Frame")
    local NotifPattern = Instance.new("Frame") -- Scanline effect

    NotifFrame.Name = "Notification"
    NotifFrame.Parent = NotifHolder
    NotifFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
    NotifFrame.Size = UDim2.new(1, 0, 0, 70)
    NotifFrame.Position = UDim2.new(1.5, 0, 0, 0)
    NotifFrame.BorderSizePixel = 0

    NotifPattern.Name = "Pattern"
    NotifPattern.Parent = NotifFrame
    NotifPattern.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotifPattern.BackgroundTransparency = 0.95
    NotifPattern.Size = UDim2.new(1, 0, 1, 0)
    NotifPattern.ZIndex = 2
    
    local PatternLayout = Instance.new("UIGridLayout")
    PatternLayout.Parent = NotifPattern
    PatternLayout.CellPadding = UDim2.new(0, 0, 0, 2)
    PatternLayout.CellSize = UDim2.new(1, 0, 0, 1)
    for i=1, 20 do Instance.new("Frame", NotifPattern).BorderSizePixel = 0 end

    NotifStroke.Color = ConfigNotif.Color
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame

    NotifTitle.Parent = NotifFrame
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 12, 0, 10)
    NotifTitle.Size = UDim2.new(1, -24, 0, 18)
    NotifTitle.Font = Enum.Font.Arcade
    NotifTitle.Text = "[ " .. ConfigNotif.Title:upper() .. " ]"
    NotifTitle.TextColor3 = ConfigNotif.Color
    NotifTitle.TextSize = 13
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.ZIndex = 3

    NotifContent.Parent = NotifFrame
    NotifContent.BackgroundTransparency = 1
    NotifContent.Position = UDim2.new(0, 12, 0, 32)
    NotifContent.Size = UDim2.new(1, -24, 0, 30)
    NotifContent.Font = Enum.Font.Code
    NotifContent.Text = "> " .. ConfigNotif.Content
    NotifContent.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifContent.TextSize = 11
    NotifContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifContent.TextWrapped = true
    NotifContent.ZIndex = 3

    NotifBar.Parent = NotifFrame
    NotifBar.BackgroundColor3 = ConfigNotif.Color
    NotifBar.BorderSizePixel = 0
    NotifBar.Position = UDim2.new(0, 0, 1, -4)
    NotifBar.Size = UDim2.new(1, 0, 0, 4)
    NotifBar.ZIndex = 4

    game:GetService("TweenService"):Create(NotifFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    game:GetService("TweenService"):Create(NotifBar, TweenInfo.new(ConfigNotif.Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 4)}):Play()

    task.delay(ConfigNotif.Duration, function()
        game:GetService("TweenService"):Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, 0)}):Play()
        task.wait(0.5)
        NotifFrame:Destroy()
    end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    local ConfigWindow = self:MakeConfig({
        Title = "ARCADE MASTER PRO V2",
        Description = "Intelligent Monitoring",
        AccentColor = Color3.fromRGB(0, 255, 255)
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

    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 0
    BlurEffect.Parent = game:GetService("Lighting")

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
    DropdownPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    DropdownPanel.Position = UDim2.new(1, 0, 0, 0)
    DropdownPanel.Size = UDim2.new(0.65, 0, 1, 0)
    DropdownPanel.ZIndex = 51

    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = ConfigWindow.AccentColor
    PanelStroke.Thickness = 2
    PanelStroke.Parent = DropdownPanel

    local PanelTop = Instance.new("Frame")
    PanelTop.Name = "PanelTop"
    PanelTop.Parent = DropdownPanel
    PanelTop.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    PanelTop.Size = UDim2.new(1, 0, 0, 45)
    PanelTop.ZIndex = 52

    local BackBtn = Instance.new("TextButton")
    BackBtn.Name = "BackBtn"
    BackBtn.Parent = PanelTop
    BackBtn.BackgroundTransparency = 1
    BackBtn.Position = UDim2.new(0, 10, 0, 7)
    BackBtn.Size = UDim2.new(0, 30, 0, 30)
    BackBtn.Font = Enum.Font.Arcade
    BackBtn.Text = "<"
    BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackBtn.TextSize = 20
    BackBtn.ZIndex = 53

    local PanelTitle = Instance.new("TextLabel")
    PanelTitle.Name = "PanelTitle"
    PanelTitle.Parent = PanelTop
    PanelTitle.BackgroundTransparency = 1
    PanelTitle.Position = UDim2.new(0, 50, 0, 0)
    PanelTitle.Size = UDim2.new(1, -60, 1, 0)
    PanelTitle.Font = Enum.Font.Arcade
    PanelTitle.Text = "SELECT OPTION"
    PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PanelTitle.TextSize = 15
    PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
    PanelTitle.ZIndex = 53

    local PanelScroll = Instance.new("ScrollingFrame")
    PanelScroll.Name = "PanelScroll"
    PanelScroll.Parent = DropdownPanel
    PanelScroll.BackgroundTransparency = 1
    PanelScroll.Position = UDim2.new(0, 10, 0, 55)
    PanelScroll.Size = UDim2.new(1, -20, 1, -65)
    PanelScroll.ScrollBarThickness = 3
    PanelScroll.ScrollBarImageColor3 = ConfigWindow.AccentColor
    PanelScroll.ZIndex = 52

    local PanelList = Instance.new("UIListLayout")
    PanelList.Parent = PanelScroll
    PanelList.Padding = UDim.new(0, 8)
    PanelList.SortOrder = Enum.SortOrder.LayoutOrder

    Library:UpdateScrolling(PanelScroll, PanelList)

    TeddyUI_Premium.Name = "ArcadeUI_MasterProV2"
    TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = TeddyUI_Premium
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size = UDim2.new(0, 460, 0, 340)

    Main.Name = "Main"
    Main.Parent = DropShadowHolder
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ClipsDescendants = true
    Main.Visible = false

    UICorner.CornerRadius = UDim.new(0, 2)
    UICorner.Parent = Main

    UIStroke.Color = ConfigWindow.AccentColor
    UIStroke.Thickness = 2
    UIStroke.Parent = Main

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
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
    NameHub.Size = UDim2.new(0, 250, 0, 18)
    NameHub.Font = Enum.Font.Arcade
    NameHub.Text = ConfigWindow.Title:upper()
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 17
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Name = "Desc"
    Desc.Parent = Top
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 50, 0, 26)
    Desc.Size = UDim2.new(0, 250, 0, 12)
    Desc.Font = Enum.Font.Code
    Desc.Text = ConfigWindow.Description
    Desc.TextColor3 = ConfigWindow.AccentColor
    Desc.TextSize = 11
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    RightButtons.Name = "RightButtons"
    RightButtons.Parent = Top
    RightButtons.BackgroundTransparency = 1
    RightButtons.Position = UDim2.new(1, -75, 0, 0)
    RightButtons.Size = UDim2.new(0, 70, 1, 0)

    UIListLayout_Buttons.Parent = RightButtons
    UIListLayout_Buttons.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_Buttons.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_Buttons.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Buttons.Padding = UDim.new(0, 8)

    Close.Name = "Close"
    Close.Parent = RightButtons
    Close.BackgroundTransparency = 1
    Close.Size = UDim2.new(0, 24, 0, 24)
    Close.Font = Enum.Font.Arcade
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.TextSize = 16

    Minize.Name = "Minize"
    Minize.Parent = RightButtons
    Minize.BackgroundTransparency = 1
    Minize.Size = UDim2.new(0, 24, 0, 24)
    Minize.Font = Enum.Font.Arcade
    Minize.Text = "_"
    Minize.TextColor3 = Color3.fromRGB(180, 180, 180)
    Minize.TextSize = 16

    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    TabHolder.Position = UDim2.new(0, 0, 0, 45)
    TabHolder.Size = UDim2.new(1, 0, 0, 35)
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.ScrollingDirection = Enum.ScrollingDirection.X

    TabListLayout.Parent = TabHolder
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 10)

    TabPadding.Parent = TabHolder
    TabPadding.PaddingLeft = UDim.new(0, 15)
    TabPadding.PaddingRight = UDim.new(0, 15)

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 30, 0, 0)
    end)

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 80)
    ContentFrame.Size = UDim2.new(1, 0, 1, -80)
    ContentFrame.ClipsDescendants = true

    PageList.Name = "PageList"
    PageList.Parent = ContentFrame
    PageLayout.Parent = PageList
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.TweenTime = 0.5

    self:MakeDraggable(Top, DropShadowHolder)

    Close.MouseButton1Click:Connect(function() 
        game:GetService("TweenService"):Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.5)
        BlurEffect:Destroy()
        ActiveFunctionsGui:Destroy()
        TeddyUI_Premium:Destroy() 
    end)

    -- [ Dynamic ON/OFF Toggle Button - Refined ] --
    local ControlBtnGui = Instance.new("ScreenGui")
    ControlBtnGui.Name = "ArcadeControl"
    ControlBtnGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local MainBtn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    local BtnStatus = Instance.new("TextLabel")
    local BtnLabel = Instance.new("TextLabel")
    
    MainBtn.Name = "MainBtn"
    MainBtn.Parent = ControlBtnGui
    MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainBtn.Position = UDim2.new(0, 30, 0, 30)
    MainBtn.Size = UDim2.new(0, 110, 0, 38)
    MainBtn.Text = ""
    
    BtnCorner.CornerRadius = UDim.new(0, 2)
    BtnCorner.Parent = MainBtn
    
    BtnStroke.Color = ConfigWindow.AccentColor
    BtnStroke.Thickness = 2
    BtnStroke.Parent = MainBtn
    
    BtnLabel.Parent = MainBtn
    BtnLabel.BackgroundTransparency = 1
    BtnLabel.Position = UDim2.new(0, 10, 0, 0)
    BtnLabel.Size = UDim2.new(0, 60, 1, 0)
    BtnLabel.Font = Enum.Font.Arcade
    BtnLabel.Text = "ARCADE"
    BtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnLabel.TextSize = 13
    BtnLabel.TextXAlignment = Enum.TextXAlignment.Left

    BtnStatus.Parent = MainBtn
    BtnStatus.BackgroundTransparency = 1
    BtnStatus.Position = UDim2.new(0, 75, 0, 0) -- Increased space between Arcade and Status
    BtnStatus.Size = UDim2.new(0, 30, 1, 0)
    BtnStatus.Font = Enum.Font.Arcade
    BtnStatus.Text = "OFF"
    BtnStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    BtnStatus.TextSize = 12
    BtnStatus.TextXAlignment = Enum.TextXAlignment.Left
    
    self:MakeDraggable(MainBtn, MainBtn)

    local function ToggleUI()
        TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
        if TeddyUI_Premium.Enabled then
            BtnStatus.Text = "ON"
            BtnStatus.TextColor3 = Color3.fromRGB(0, 255, 150)
            Library:TweenInstance(MainBtn, 0.3, "BackgroundColor3", Color3.fromRGB(25, 25, 40))
        else
            BtnStatus.Text = "OFF"
            BtnStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
            Library:TweenInstance(MainBtn, 0.3, "BackgroundColor3", Color3.fromRGB(15, 15, 25))
        end
    end

    MainBtn.MouseButton1Click:Connect(ToggleUI)
    Minize.MouseButton1Click:Connect(ToggleUI)

    -- [ Intro Animation ] --
    local IntroFrame = Instance.new("Frame")
    local IntroStroke = Instance.new("UIStroke")
    local IntroText = Instance.new("TextLabel")
    local LoadingBarBG = Instance.new("Frame")
    local LoadingBarFill = Instance.new("Frame")
    local BootText = Instance.new("TextLabel")

    IntroFrame.Name = "IntroFrame"
    IntroFrame.Parent = DropShadowHolder
    IntroFrame.BackgroundColor3 = Color3.fromRGB(2, 2, 8)
    IntroFrame.Size = UDim2.new(0, 320, 0, 200)
    IntroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroFrame.ClipsDescendants = true
    
    IntroStroke.Color = ConfigWindow.AccentColor
    IntroStroke.Thickness = 2
    IntroStroke.Parent = IntroFrame
    
    IntroText.Parent = IntroFrame
    IntroText.BackgroundTransparency = 1
    IntroText.Size = UDim2.new(1, 0, 0, 60)
    IntroText.Position = UDim2.new(0, 0, 0.15, 0)
    IntroText.Font = Enum.Font.Arcade
    IntroText.Text = "BOOTING SYSTEM..."
    IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroText.TextSize = 20
    
    LoadingBarBG.Parent = IntroFrame
    LoadingBarBG.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    LoadingBarBG.Position = UDim2.new(0.1, 0, 0.6, 0)
    LoadingBarBG.Size = UDim2.new(0.8, 0, 0, 12)
    LoadingBarBG.BorderSizePixel = 0
    
    LoadingBarFill.Parent = LoadingBarBG
    LoadingBarFill.BackgroundColor3 = ConfigWindow.AccentColor
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingBarFill.BorderSizePixel = 0
    
    BootText.Parent = IntroFrame
    BootText.BackgroundTransparency = 1
    BootText.Position = UDim2.new(0.1, 0, 0.75, 0)
    BootText.Size = UDim2.new(0.8, 0, 0, 20)
    BootText.Font = Enum.Font.Code
    BootText.Text = "MASTER_PRO_V2: INITIALIZED"
    BootText.TextColor3 = ConfigWindow.AccentColor
    BootText.TextSize = 11
    BootText.TextXAlignment = Enum.TextXAlignment.Left

    local function PlayMasterIntro()
        local TS = game:GetService("TweenService")
        IntroFrame.Size = UDim2.new(0, 0, 0, 2)
        TS:Create(IntroFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 320, 0, 2)}):Play()
        task.wait(0.4)
        TS:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 320, 0, 200)}):Play()
        task.wait(0.6)
        
        local stages = {
            {text = "SYNCING INTELLIGENT MONITOR...", progress = 0.4},
            {text = "LOADING ARCADE ASSETS...", progress = 0.8},
            {text = "SYSTEM READY!", progress = 1.0}
        }
        
        for _, stage in ipairs(stages) do
            BootText.Text = "> " .. stage.text
            TS:Create(LoadingBarFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Size = UDim2.new(stage.progress, 0, 1, 0)}):Play()
            task.wait(0.6)
        end
        
        task.wait(0.3)
        IntroText.Text = "ACCESS GRANTED"
        IntroText.TextColor3 = Color3.fromRGB(0, 255, 150)
        IntroStroke.Color = Color3.fromRGB(0, 255, 150)
        task.wait(0.8)
        
        TS:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.5)
        IntroFrame:Destroy()
        
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        TS:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        
        BtnStatus.Text = "ON"
        BtnStatus.TextColor3 = Color3.fromRGB(0, 255, 150)
        
        Library:Notify({
            Title = "MASTER PRO V2",
            Content = "Intelligent Tab Monitor Active.",
            Color = Color3.fromRGB(0, 255, 150)
        })
    end

    task.spawn(PlayMasterIntro)

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
        TabListLayout_Page.Padding = UDim.new(0, 8)
        TabListLayout_Page.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabPadding_Page.Parent = TabPage
        TabPadding_Page.PaddingLeft = UDim.new(0, 12)
        TabPadding_Page.PaddingRight = UDim.new(0, 12)
        TabPadding_Page.PaddingTop = UDim.new(0, 12)
        TabPadding_Page.PaddingBottom = UDim.new(0, 12)

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
        TabBtnTitle.TextColor3 = Color3.fromRGB(120, 120, 140)
        TabBtnTitle.TextSize = 13
        
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabBtn
        TabIndicator.BackgroundColor3 = ConfigWindow.AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 1, -3)
        TabIndicator.Size = UDim2.new(1, 0, 0, 3)
        TabIndicator.Transparency = 1

        local function UpdateTabBtnSize()
            local textWidth = game:GetService("TextService"):GetTextSize(TabBtnTitle.Text, TabBtnTitle.TextSize, TabBtnTitle.Font, Vector2.new(1000, 1000)).X
            TabBtn.Size = UDim2.new(0, textWidth + 24, 1, 0)
        end
        UpdateTabBtnSize()

        local function SelectTab()
            CurrentTabName = t
            if not ActiveTogglesByTab[CurrentTabName] then
                ActiveTogglesByTab[CurrentTabName] = {}
            end
            
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    game:GetService("TweenService"):Create(v.TextLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(120, 120, 140)}):Play()
                    game:GetService("TweenService"):Create(v.Indicator, TweenInfo.new(0.3), {Transparency = 1}):Play()
                end
            end
            game:GetService("TweenService"):Create(TabBtnTitle, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            game:GetService("TweenService"):Create(TabIndicator, TweenInfo.new(0.3), {Transparency = 0}):Play()
            PageLayout:JumpTo(TabPage)
            
            -- Intelligent Monitor Update on Tab Change
            Library:UpdateActiveMonitor()
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        if FirstTab then
            FirstTab = false
            SelectTab()
        end

        TabCount = TabCount + 1

        local TabFunc = {}
        function TabFunc:AddSection(t_section)
            local SectionFrame = Instance.new("Frame")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContainer = Instance.new("Frame")
            local SectionLayout = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")

            SectionFrame.Name = t_section .. "_Section"
            SectionFrame.Parent = TabPage
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, 0, 0, 22)
            SectionTitle.Font = Enum.Font.Arcade
            SectionTitle.Text = t_section:upper()
            SectionTitle.TextColor3 = ConfigWindow.AccentColor
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionContainer.Name = "Container"
            SectionContainer.Parent = SectionFrame
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 0, 0, 25)
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y

            SectionLayout.Parent = SectionContainer
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            SectionPadding.Parent = SectionContainer
            SectionPadding.PaddingLeft = UDim.new(0, 8)

            local SectionFunc = {}
            local CurrentGroup = SectionContainer

            function SectionFunc:AddButton(cfbut)
                cfbut = Library:MakeConfig({ Title = "Button", Callback = function() end }, cfbut or {})
                local ButtonFrame = Instance.new("Frame")
                local ButtonBtn = Instance.new("TextButton")
                local ButtonStroke = Instance.new("UIStroke")

                ButtonFrame.Parent = CurrentGroup
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                ButtonFrame.Size = UDim2.new(1, 0, 0, 34)
                ButtonFrame.BorderSizePixel = 0
                
                ButtonBtn.Parent = ButtonFrame
                ButtonBtn.BackgroundTransparency = 1
                ButtonBtn.Size = UDim2.new(1, 0, 1, 0)
                ButtonBtn.Font = Enum.Font.Code
                ButtonBtn.Text = cfbut.Title
                ButtonBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                ButtonBtn.TextSize = 12
                
                ButtonStroke.Color = Color3.fromRGB(45, 45, 65)
                ButtonStroke.Thickness = 1
                ButtonStroke.Parent = ButtonFrame

                ButtonBtn.MouseEnter:Connect(function() 
                    Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 50), Enum.EasingStyle.Sine)
                    Library:TweenInstance(ButtonStroke, 0.2, "Color", ConfigWindow.AccentColor, Enum.EasingStyle.Sine)
                end)
                ButtonBtn.MouseLeave:Connect(function() 
                    Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(20, 20, 35), Enum.EasingStyle.Sine)
                    Library:TweenInstance(ButtonStroke, 0.2, "Color", Color3.fromRGB(45, 45, 65), Enum.EasingStyle.Sine)
                end)
                ButtonBtn.MouseButton1Click:Connect(function() pcall(cfbut.Callback) end)
            end

            function SectionFunc:AddToggle(cftog)
                cftog = Library:MakeConfig({ Title = "Toggle", Default = false, Callback = function() end }, cftog or {})
                local ToggleFrame = Instance.new("Frame")
                local ToggleBtn = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleBox = Instance.new("Frame")
                local BoxCheck = Instance.new("Frame")
                local BoxStroke = Instance.new("UIStroke")

                ToggleFrame.Parent = CurrentGroup
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
                ToggleFrame.BorderSizePixel = 0
                
                ToggleBtn.Parent = ToggleFrame
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
                ToggleBtn.Text = ""
                
                ToggleTitle.Parent = ToggleFrame
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 12, 0, 0)
                ToggleTitle.Size = UDim2.new(1, -60, 1, 0)
                ToggleTitle.Font = Enum.Font.Code
                ToggleTitle.Text = cftog.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                ToggleTitle.TextSize = 12
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                ToggleBox.Parent = ToggleFrame
                ToggleBox.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
                ToggleBox.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleBox.Size = UDim2.new(0, 32, 0, 20)
                ToggleBox.BorderSizePixel = 0
                
                BoxStroke.Color = Color3.fromRGB(50, 50, 70)
                BoxStroke.Thickness = 1
                BoxStroke.Parent = ToggleBox
                
                BoxCheck.Parent = ToggleBox
                BoxCheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                BoxCheck.Position = UDim2.new(0, 3, 0.5, -7)
                BoxCheck.Size = UDim2.new(0, 14, 0, 14)
                BoxCheck.BorderSizePixel = 0

                local Toggled = cftog.Default
                local function Update()
                    local targetPos = Toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    local targetColor = Toggled and ConfigWindow.AccentColor or Color3.fromRGB(255, 255, 255)
                    Library:TweenInstance(BoxCheck, 0.3, "Position", targetPos, Enum.EasingStyle.Back)
                    Library:TweenInstance(BoxCheck, 0.3, "BackgroundColor3", targetColor, Enum.EasingStyle.Sine)
                    Library:TweenInstance(BoxStroke, 0.3, "Color", Toggled and ConfigWindow.AccentColor or Color3.fromRGB(50, 50, 70))
                    
                    -- Intelligent Monitor Update (Tab Specific)
                    if not ActiveTogglesByTab[t] then ActiveTogglesByTab[t] = {} end
                    ActiveTogglesByTab[t][cftog.Title] = Toggled
                    
                    if CurrentTabName == t then
                        Library:UpdateActiveMonitor()
                    end
                    
                    pcall(cftog.Callback, Toggled)
                end

                ToggleBtn.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                Update()
                return { Set = function(self, val) Toggled = val Update() end }
            end

            function SectionFunc:AddSlider(cfslid)
                cfslid = Library:MakeConfig({ Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end }, cfslid or {})
                local SliderFrame = Instance.new("Frame")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local SliderFill = Instance.new("Frame")
                local SliderBtn = Instance.new("TextButton")
                local SliderStroke = Instance.new("UIStroke")

                SliderFrame.Parent = CurrentGroup
                SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                SliderFrame.Size = UDim2.new(1, 0, 0, 48)
                SliderFrame.BorderSizePixel = 0
                
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 12, 0, 6)
                SliderTitle.Size = UDim2.new(1, -24, 0, 16)
                SliderTitle.Font = Enum.Font.Code
                SliderTitle.Text = cfslid.Title
                SliderTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderTitle.TextSize = 12
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0, 12, 0, 6)
                SliderValue.Size = UDim2.new(1, -24, 0, 16)
                SliderValue.Font = Enum.Font.Code
                SliderValue.Text = tostring(cfslid.Default)
                SliderValue.TextColor3 = ConfigWindow.AccentColor
                SliderValue.TextSize = 12
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
                SliderBar.Position = UDim2.new(0, 12, 0, 28)
                SliderBar.Size = UDim2.new(1, -24, 0, 10)
                SliderBar.BorderSizePixel = 0
                
                SliderStroke.Color = Color3.fromRGB(50, 50, 70)
                SliderStroke.Thickness = 1
                SliderStroke.Parent = SliderBar
                
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = ConfigWindow.AccentColor
                SliderFill.Size = UDim2.new((cfslid.Default - cfslid.Min) / (cfslid.Max - cfslid.Min), 0, 1, 0)
                SliderFill.BorderSizePixel = 0
                
                SliderBtn.Parent = SliderBar
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.Text = ""

                local Dragging = false
                local function Update()
                    local pos = math.clamp((game:GetService("UserInputService"):GetMouseLocation().X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(cfslid.Min + (cfslid.Max - cfslid.Min) * pos)
                    SliderValue.Text = tostring(val)
                    game:GetService("TweenService"):Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
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
                local DropBtn = Instance.new("TextButton")
                local DropTitle = Instance.new("TextLabel")
                local DropIcon = Instance.new("TextLabel")
                local DropStroke = Instance.new("UIStroke")

                DropFrame.Parent = CurrentGroup
                DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                DropFrame.Size = UDim2.new(1, 0, 0, 34)
                DropFrame.BorderSizePixel = 0
                
                DropBtn.Parent = DropFrame
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 1, 0)
                DropBtn.Text = ""
                
                DropTitle.Parent = DropFrame
                DropTitle.BackgroundTransparency = 1
                DropTitle.Position = UDim2.new(0, 12, 0, 0)
                DropTitle.Size = UDim2.new(1, -45, 1, 0)
                DropTitle.Font = Enum.Font.Code
                DropTitle.Text = cfdrop.Title .. " : " .. (type(cfdrop.Default) == "table" and table.concat(cfdrop.Default, ", ") or tostring(cfdrop.Default))
                DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropTitle.TextSize = 12
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                DropIcon.Parent = DropFrame
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.new(1, -35, 0, 0)
                DropIcon.Size = UDim2.new(0, 30, 1, 0)
                DropIcon.Font = Enum.Font.Arcade
                DropIcon.Text = ">"
                DropIcon.TextColor3 = ConfigWindow.AccentColor
                DropIcon.TextSize = 14

                DropStroke.Color = Color3.fromRGB(45, 45, 65)
                DropStroke.Thickness = 1
                DropStroke.Parent = DropFrame

                local function CloseWazureDropdown()
                    Library:TweenInstance(DropdownPanel, 0.5, "Position", UDim2.new(1, 0, 0, 0), Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                    Library:TweenInstance(DropdownOverlay, 0.4, "BackgroundTransparency", 1, Enum.EasingStyle.Sine)
                    game:GetService("TweenService"):Create(BlurEffect, TweenInfo.new(0.4), {Size = 0}):Play()
                    task.wait(0.5)
                    DropdownOverlay.Visible = false
                end

                local function OpenWazureDropdown()
                    for _, v in pairs(PanelScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    PanelTitle.Text = cfdrop.Title:upper()
                    DropdownOverlay.Visible = true
                    Library:TweenInstance(DropdownOverlay, 0.4, "BackgroundTransparency", 0.65, Enum.EasingStyle.Sine)
                    Library:TweenInstance(DropdownPanel, 0.6, "Position", UDim2.new(0.35, 0, 0, 0), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    game:GetService("TweenService"):Create(BlurEffect, TweenInfo.new(0.6), {Size = 20}):Play()

                    for _, opt in pairs(options) do
                        local OptBtn = Instance.new("TextButton")
                        local OptStroke = Instance.new("UIStroke")
                        OptBtn.Parent = PanelScroll
                        OptBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                        OptBtn.Size = UDim2.new(1, 0, 0, 38)
                        OptBtn.Font = Enum.Font.Code
                        OptBtn.Text = opt
                        OptBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                        OptBtn.TextSize = 13
                        OptBtn.ZIndex = 53
                        OptBtn.BorderSizePixel = 0
                        
                        OptStroke.Color = Color3.fromRGB(40, 40, 60)
                        OptStroke.Thickness = 1
                        OptStroke.Parent = OptBtn
                        
                        OptBtn.MouseEnter:Connect(function() Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 45), Enum.EasingStyle.Sine) end)
                        OptBtn.MouseLeave:Connect(function() Library:TweenInstance(OptBtn, 0.2, "BackgroundColor3", Color3.fromRGB(20, 20, 30), Enum.EasingStyle.Sine) end)
                        
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
                cfbox = Library:MakeConfig({ Title = "Textbox", Default = "", Callback = function() end }, cfbox or {})
                local BoxFrame = Instance.new("Frame")
                local BoxTitle = Instance.new("TextLabel")
                local BoxInput = Instance.new("TextBox")
                local BoxStroke = Instance.new("UIStroke")
                local InputStroke = Instance.new("UIStroke")

                BoxFrame.Parent = CurrentGroup
                BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
                BoxFrame.Size = UDim2.new(1, 0, 0, 34)
                BoxFrame.BorderSizePixel = 0
                
                BoxTitle.Parent = BoxFrame
                BoxTitle.BackgroundTransparency = 1
                BoxTitle.Position = UDim2.new(0, 12, 0, 0)
                BoxTitle.Size = UDim2.new(0, 120, 1, 0)
                BoxTitle.Font = Enum.Font.Code
                BoxTitle.Text = cfbox.Title
                BoxTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                BoxTitle.TextSize = 12
                BoxTitle.TextXAlignment = Enum.TextXAlignment.Left

                BoxInput.Parent = BoxFrame
                BoxInput.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
                BoxInput.Position = UDim2.new(1, -140, 0.5, -11)
                BoxInput.Size = UDim2.new(0, 130, 0, 22)
                BoxInput.Font = Enum.Font.Code
                BoxInput.Text = cfbox.Default
                BoxInput.TextColor3 = ConfigWindow.AccentColor
                BoxInput.TextSize = 12
                BoxInput.BorderSizePixel = 0
                
                InputStroke.Color = Color3.fromRGB(60, 60, 80)
                InputStroke.Thickness = 1
                InputStroke.Parent = BoxInput

                BoxStroke.Color = Color3.fromRGB(45, 45, 65)
                BoxStroke.Thickness = 1
                BoxStroke.Parent = BoxFrame

                BoxInput.FocusLost:Connect(function() pcall(cfbox.Callback, BoxInput.Text) end)
                pcall(cfbox.Callback, cfbox.Default)
            end
            SectionFunc.AddInput = SectionFunc.AddTextbox

            function SectionFunc:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Parent = CurrentGroup
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 22)
                Label.Font = Enum.Font.Code
                Label.Text = ">> " .. text
                Label.TextColor3 = Color3.fromRGB(160, 160, 180)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                return { Set = function(self, val) Label.Text = ">> " .. val end }
            end

            function SectionFunc:AddParagraph(cfpara)
                cfpara = Library:MakeConfig({ Title = "Paragraph", Content = "", Desc = "" }, cfpara or {})
                local contentText = (cfpara.Content ~= "" and cfpara.Content) or cfpara.Desc
                local ParaFrame = Instance.new("Frame")
                local ParaTitle = Instance.new("TextLabel")
                local ParaContent = Instance.new("TextLabel")
                local ParaStroke = Instance.new("UIStroke")
                
                ParaFrame.Parent = CurrentGroup
                ParaFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
                ParaFrame.Size = UDim2.new(1, 0, 0, 50)
                ParaFrame.BorderSizePixel = 0
                
                ParaStroke.Color = Color3.fromRGB(40, 40, 60)
                ParaStroke.Thickness = 1
                ParaStroke.Parent = ParaFrame
                
                ParaTitle.Parent = ParaFrame
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 12, 0, 8)
                ParaTitle.Size = UDim2.new(1, -24, 0, 16)
                ParaTitle.Font = Enum.Font.Arcade
                ParaTitle.Text = "[ " .. cfpara.Title:upper() .. " ]"
                ParaTitle.TextColor3 = ConfigWindow.AccentColor
                ParaTitle.TextSize = 12
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left

                ParaContent.Parent = ParaFrame
                ParaContent.BackgroundTransparency = 1
                ParaContent.Position = UDim2.new(0, 12, 0, 26)
                ParaContent.Size = UDim2.new(1, -24, 0, 18)
                ParaContent.Font = Enum.Font.Code
                ParaContent.Text = contentText
                ParaContent.TextColor3 = Color3.fromRGB(200, 200, 220)
                ParaContent.TextSize = 11
                ParaContent.TextXAlignment = Enum.TextXAlignment.Left
                ParaContent.TextWrapped = true
                
                local function UpdateSize() 
                    local textHeight = ParaContent.TextBounds.Y 
                    ParaFrame.Size = UDim2.new(1, 0, 0, textHeight + 35) 
                    ParaContent.Size = UDim2.new(1, -24, 0, textHeight) 
                end
                ParaContent:GetPropertyChangedSignal("Text"):Connect(UpdateSize)
                UpdateSize()
                return { SetTitle = function(self, val) ParaTitle.Text = "[ " .. val:upper() .. " ]" end, SetDesc = function(self, val) ParaContent.Text = val end, Set = function(self, val) ParaContent.Text = val end }
            end

            function SectionFunc:AddDiscord(DiscordTitle, InviteCode)
                local DiscordCard = Instance.new("Frame")
                local Icon = Instance.new("ImageLabel")
                local Title = Instance.new("TextLabel")
                local SubTitle = Instance.new("TextLabel")
                local JoinBtn = Instance.new("TextButton")
                local CardStroke = Instance.new("UIStroke")
                
                DiscordCard.Parent = CurrentGroup
                DiscordCard.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
                DiscordCard.Size = UDim2.new(1, 0, 0, 65)
                DiscordCard.BorderSizePixel = 0
                
                CardStroke.Color = Color3.fromRGB(50, 50, 80)
                CardStroke.Thickness = 1
                CardStroke.Parent = DiscordCard
                
                Icon.Parent = DiscordCard
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(0, 12, 0, 12)
                Icon.Size = UDim2.new(0, 40, 0, 40)
                Icon.Image = "rbxassetid://11419713314"
                
                Title.Parent = DiscordCard
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 65, 0, 18)
                Title.Size = UDim2.new(1, -150, 0, 16)
                Title.Font = Enum.Font.Arcade
                Title.Text = (DiscordTitle or "DISCORD SERVER"):upper()
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                SubTitle.Parent = DiscordCard
                SubTitle.BackgroundTransparency = 1
                SubTitle.Position = UDim2.new(0, 65, 0, 36)
                SubTitle.Size = UDim2.new(1, -150, 0, 14)
                SubTitle.Font = Enum.Font.Code
                SubTitle.Text = "Join our community"
                SubTitle.TextColor3 = Color3.fromRGB(160, 160, 180)
                SubTitle.TextSize = 11
                SubTitle.TextXAlignment = Enum.TextXAlignment.Left

                JoinBtn.Parent = DiscordCard
                JoinBtn.BackgroundColor3 = ConfigWindow.AccentColor
                JoinBtn.Position = UDim2.new(1, -85, 0, 17)
                JoinBtn.Size = UDim2.new(0, 70, 0, 32)
                JoinBtn.Font = Enum.Font.Arcade
                JoinBtn.Text = "JOIN"
                JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinBtn.TextSize = 13
                JoinBtn.BorderSizePixel = 0
                
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
                SeperatorFrame.Size = UDim2.new(1, 0, 0, 24)

                SeperatorLabel.Parent = SeperatorFrame
                SeperatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                SeperatorLabel.BackgroundTransparency = 1
                SeperatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                SeperatorLabel.Size = UDim2.new(0, 0, 1, 0)
                SeperatorLabel.AutomaticSize = Enum.AutomaticSize.X
                SeperatorLabel.Font = Enum.Font.Code
                SeperatorLabel.Text = ":: " .. text:upper() .. " ::"
                SeperatorLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
                SeperatorLabel.TextSize = 11

                LineLeft.Parent = SeperatorFrame
                LineLeft.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                LineLeft.BorderSizePixel = 0
                LineLeft.Position = UDim2.new(0, 0, 0.5, 0)
                LineLeft.Size = UDim2.new(0.5, -70, 0, 1)

                LineRight.Parent = SeperatorFrame
                LineRight.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                LineRight.BorderSizePixel = 0
                LineRight.Position = UDim2.new(1, 0, 0.5, 0)
                LineRight.AnchorPoint = Vector2.new(1, 0)
                LineRight.Size = UDim2.new(0.5, -70, 0, 1)
            end

            return SectionFunc
        end

        return TabFunc
    end

    return Tab
end

return Library
