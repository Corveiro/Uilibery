local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ Global Settings ] --
local AccentColor = Color3.fromRGB(255, 0, 0)
local SecondaryColor = Color3.fromRGB(15, 15, 25)
local BackgroundColor = Color3.fromRGB(10, 10, 15)

-- [ Utility Functions ] --
function Library:Tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

-- Efeito de Ciclo Cromático (RGB Suave) para Elementos de Elite
function Library:ApplyChromaticEffect(obj, prop)
    task.spawn(function()
        while obj and obj.Parent do
            for i = 0, 1, 0.005 do
                if not obj or not obj.Parent then break end
                obj[prop] = Color3.fromHSV(i, 0.8, 1)
                task.wait(0.05)
            end
        end
    end)
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

-- [ Notification System ] --
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "ArcadeNotify"
NotifyGui.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Parent = NotifyGui
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Position = UDim2.new(1, -310, 0, 20)
NotifyHolder.Size = UDim2.new(0, 300, 1, -40)
local NotifyList = Instance.new("UIListLayout")
NotifyList.Parent = NotifyHolder
NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyList.Padding = UDim.new(0, 8)

function Library:Notify(config)
    local title = config.Title or "SYSTEM"
    local text = config.Content or config.Text or "Notification"
    local duration = config.Duration or 5
    
    local Card = Instance.new("Frame")
    local CardCorner = Instance.new("UICorner")
    local CardStroke = Instance.new("UIStroke")
    local T = Instance.new("TextLabel")
    local M = Instance.new("TextLabel")
    local Bar = Instance.new("Frame")

    Card.Parent = NotifyHolder
    Card.BackgroundColor3 = BackgroundColor
    Card.Size = UDim2.new(1, 0, 0, 60)
    Card.ClipsDescendants = true
    Card.Transparency = 1
    
    CardCorner.CornerRadius = UDim.new(0, 4)
    CardCorner.Parent = Card
    
    CardStroke.Color = AccentColor
    CardStroke.Thickness = 1.5
    CardStroke.Parent = Card
    CardStroke.Transparency = 1

    T.Parent = Card
    T.BackgroundTransparency = 1
    T.Position = UDim2.new(0, 10, 0, 8)
    T.Size = UDim2.new(1, -20, 0, 15)
    T.Font = Enum.Font.Arcade
    T.Text = title:upper()
    T.TextColor3 = AccentColor
    T.TextSize = 14
    T.TextXAlignment = Enum.TextXAlignment.Left

    M.Parent = Card
    M.BackgroundTransparency = 1
    M.Position = UDim2.new(0, 10, 0, 25)
    M.Size = UDim2.new(1, -20, 0, 30)
    M.Font = Enum.Font.Code
    M.Text = text
    M.TextColor3 = Color3.fromRGB(200, 200, 200)
    M.TextSize = 12
    M.TextXAlignment = Enum.TextXAlignment.Left
    M.TextWrapped = true

    Bar.Parent = Card
    Bar.BackgroundColor3 = AccentColor
    Bar.BorderSizePixel = 0
    Bar.Position = UDim2.new(0, 0, 1, -2)
    Bar.Size = UDim2.new(1, 0, 0, 2)

    Library:Tween(Card, 0.4, {Transparency = 0}, Enum.EasingStyle.Back)
    Library:Tween(CardStroke, 0.4, {Transparency = 0})
    Library:Tween(Bar, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Library:Tween(Card, 0.4, {Transparency = 1}, Enum.EasingStyle.Back)
        Library:Tween(CardStroke, 0.4, {Transparency = 1})
        task.wait(0.4)
        Card:Destroy()
    end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    ConfigWindow = ConfigWindow or {}
    local TitleText = ConfigWindow.Title or "ARCADE HUB"
    local DescText = ConfigWindow.Description or "Impeccable Edition"
    local WinAccent = ConfigWindow.AccentColor or AccentColor

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "ArcadeMain"
    MainGui.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
    MainGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local Scanlines = Instance.new("ImageLabel")
    
    Main.Name = "Main"
    Main.Parent = MainGui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 340)
    Main.ClipsDescendants = true
    
    -- [ CINEMATIC: Opening Animation ]
    task.spawn(function()
        Library:Tween(Main, 0.6, {Size = UDim2.new(0, 480, 0, 340)}, Enum.EasingStyle.Back)
        task.wait(0.6)
        Library:Notify({Title = "BOOT SEQUENCE", Content = "Arcade Systems Initialized...", Duration = 3})
    end)

    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main

    MainStroke.Color = WinAccent
    MainStroke.Thickness = 2
    MainStroke.Parent = Main
    
    -- [ CINEMATIC: RGB Chroma & Pulse Effect ]
    task.spawn(function()
        local hue = 0
        while Main do
            hue = hue + 0.005
            if hue > 1 then hue = 0 end
            local chromaColor = Color3.fromHSV(hue, 0.8, 1)
            
            -- Sincroniza a cor de destaque com o ciclo cromático para um efeito "VIVO"
            MainStroke.Color = chromaColor
            MainStroke.Transparency = 0.3 + (math.sin(tick() * 2) * 0.2)
            task.wait(0.05)
        end
    end)

    Scanlines.Name = "Scanlines"
    Scanlines.Parent = Main
    Scanlines.BackgroundTransparency = 1
    Scanlines.Size = UDim2.new(1, 0, 1, 0)
    Scanlines.Image = "rbxassetid://6071575215"
    Scanlines.ImageTransparency = 0.9
    Scanlines.ScaleType = Enum.ScaleType.Tile
    Scanlines.TileSize = UDim2.new(0, 128, 0, 128)
    Scanlines.ZIndex = 10

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local WinTitle = Instance.new("TextLabel")
    WinTitle.Parent = TopBar
    WinTitle.BackgroundTransparency = 1
    WinTitle.Position = UDim2.new(0, 12, 0, 0)
    WinTitle.Size = UDim2.new(0.7, 0, 1, 0)
    WinTitle.Font = Enum.Font.Arcade
    WinTitle.Text = TitleText:upper()
    WinTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WinTitle.TextSize = 18
    WinTitle.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.Size = UDim2.new(0, 35, 1, 0)
    CloseBtn.Font = Enum.Font.Arcade
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.TextSize = 16
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 130, 1, -40)

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Parent = Sidebar
    TabHolder.BackgroundTransparency = 1
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabHolder
    TabList.Padding = UDim.new(0, 5)
    local TabPad = Instance.new("UIPadding")
    TabPad.Parent = TabHolder
    TabPad.PaddingTop = UDim.new(0, 10)
    TabPad.PaddingLeft = UDim.new(0, 8)
    TabPad.PaddingRight = UDim.new(0, 8)

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 130, 0, 40)
    Content.Size = UDim2.new(1, -130, 1, -40)
    local PageLayout = Instance.new("UIPageLayout")
    PageLayout.Parent = Content
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingStyle = Enum.EasingStyle.Quart
    PageLayout.TweenTime = 0.4

    Library:MakeDraggable(TopBar, Main)

    local TabCount = 0
    local FirstTab = true

    local TabMethods = {}

    function TabMethods:T(t, icon)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local TabBtnLabel = Instance.new("TextLabel")
        local ActiveIndicator = Instance.new("Frame")

        TabBtn.Parent = TabHolder
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.Text = ""
        TabBtn.LayoutOrder = TabCount

        TabBtnCorner.CornerRadius = UDim.new(0, 4)
        TabBtnCorner.Parent = TabBtn

        TabBtnLabel.Parent = TabBtn
        TabBtnLabel.BackgroundTransparency = 1
        TabBtnLabel.Size = UDim2.new(1, 0, 1, 0)
        TabBtnLabel.Font = Enum.Font.Code
        TabBtnLabel.Text = t:upper()
        TabBtnLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtnLabel.TextSize = 11

        ActiveIndicator.Parent = TabBtn
        ActiveIndicator.BackgroundColor3 = WinAccent
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.Position = UDim2.new(0, 0, 0.2, 0)
        ActiveIndicator.Size = UDim2.new(0, 2, 0.6, 0)
        ActiveIndicator.Transparency = 1

        local Page = Instance.new("ScrollingFrame")
        Page.Name = t .. "_Page"
        Page.Parent = Content
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = WinAccent
        Page.LayoutOrder = TabCount
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 8)
        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingTop = UDim.new(0, 12)
        PagePad.PaddingLeft = UDim.new(0, 12)
        PagePad.PaddingRight = UDim.new(0, 12)
        PagePad.PaddingBottom = UDim.new(0, 12)

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    Library:Tween(v, 0.2, {BackgroundTransparency = 1})
                    Library:Tween(v.TextLabel, 0.2, {TextColor3 = Color3.fromRGB(150, 150, 150)})
                    Library:Tween(v.Frame, 0.2, {Transparency = 1})
                end
            end
            Library:Tween(TabBtn, 0.2, {BackgroundTransparency = 0})
            Library:Tween(TabBtnLabel, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            Library:Tween(ActiveIndicator, 0.2, {Transparency = 0})
            PageLayout:JumpToIndex(TabBtn.LayoutOrder)
        end)

        if FirstTab then
            FirstTab = false
            TabBtn.BackgroundTransparency = 0
            TabBtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActiveIndicator.Transparency = 0
        end

        TabCount = TabCount + 1
        local SectionMethods = {}

        function SectionMethods:AddSection(stitle)
            local SecFrame = Instance.new("Frame")
            local SecTitle = Instance.new("TextLabel")
            local SecContainer = Instance.new("Frame")
            local SecLayout = Instance.new("UIListLayout")

            SecFrame.Parent = Page
            SecFrame.BackgroundTransparency = 1
            SecFrame.Size = UDim2.new(1, 0, 0, 25)
            SecFrame.AutomaticSize = Enum.AutomaticSize.Y

            SecTitle.Parent = SecFrame
            SecTitle.BackgroundTransparency = 1
            SecTitle.Size = UDim2.new(1, 0, 0, 20)
            SecTitle.Font = Enum.Font.Arcade
            SecTitle.Text = ">> " .. stitle:upper()
            SecTitle.TextColor3 = WinAccent
            SecTitle.TextSize = 12
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left

            SecContainer.Parent = SecFrame
            SecContainer.BackgroundTransparency = 1
            SecContainer.Position = UDim2.new(0, 0, 0, 22)
            SecContainer.Size = UDim2.new(1, 0, 0, 0)
            SecContainer.AutomaticSize = Enum.AutomaticSize.Y
            SecLayout.Parent = SecContainer
            SecLayout.Padding = UDim.new(0, 6)

            local ElementMethods = {}

            function ElementMethods:AddButton(config)
                config = config or {}
                local Btn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnStroke = Instance.new("UIStroke")
                local BtnLabel = Instance.new("TextLabel")

                Btn.Parent = SecContainer
                Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Btn.Size = UDim2.new(1, 0, 0, 32)
                Btn.Text = ""
                Btn.AutoButtonColor = false

                BtnCorner.CornerRadius = UDim.new(0, 4)
                BtnCorner.Parent = Btn
                BtnStroke.Color = Color3.fromRGB(45, 45, 55)
                BtnStroke.Parent = Btn

                BtnLabel.Parent = Btn
                BtnLabel.BackgroundTransparency = 1
                BtnLabel.Size = UDim2.new(1, 0, 1, 0)
                BtnLabel.Font = Enum.Font.Code
                BtnLabel.Text = config.Title or "Button"
                BtnLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                BtnLabel.TextSize = 12

                Btn.MouseEnter:Connect(function() 
                    Library:Tween(Btn, 0.2, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)})
                    Library:Tween(BtnStroke, 0.2, {Color = WinAccent, Thickness = 1.5}) 
                end)
                Btn.MouseLeave:Connect(function() 
                    Library:Tween(Btn, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)})
                    Library:Tween(BtnStroke, 0.2, {Color = Color3.fromRGB(45, 45, 55), Thickness = 1}) 
                end)
                Btn.MouseButton1Click:Connect(function()
                    local circle = Instance.new("Frame")
                    circle.Parent = Btn
                    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    circle.BackgroundTransparency = 0.8
                    circle.Position = UDim2.new(0, Mouse.X - Btn.AbsolutePosition.X, 0, Mouse.Y - Btn.AbsolutePosition.Y)
                    circle.Size = UDim2.new(0, 0, 0, 0)
                    local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(1, 0); cCorner.Parent = circle
                    Library:Tween(circle, 0.5, {Size = UDim2.new(0, 200, 0, 200), BackgroundTransparency = 1})
                    task.delay(0.5, function() circle:Destroy() end)
                    pcall(config.Callback)
                end)
                return {Set = function(self, t) BtnLabel.Text = t end}
            end

            function ElementMethods:AddToggle(config)
                config = config or {}
                local Toggled = config.Default or false
                local Tog = Instance.new("TextButton")
                local TogLabel = Instance.new("TextLabel")
                local Switch = Instance.new("Frame")
                local Dot = Instance.new("Frame")

                Tog.Parent = SecContainer
                Tog.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Tog.Size = UDim2.new(1, 0, 0, 32)
                Tog.Text = ""
                local tCorner = Instance.new("UICorner"); tCorner.CornerRadius = UDim.new(0, 4); tCorner.Parent = Tog

                TogLabel.Parent = Tog
                TogLabel.BackgroundTransparency = 1
                TogLabel.Position = UDim2.new(0, 12, 0, 0)
                TogLabel.Size = UDim2.new(1, -60, 1, 0)
                TogLabel.Font = Enum.Font.Code
                TogLabel.Text = config.Title or "Toggle"
                TogLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                TogLabel.TextSize = 12
                TogLabel.TextXAlignment = Enum.TextXAlignment.Left

                Switch.Parent = Tog
                Switch.AnchorPoint = Vector2.new(0, 0.5)
                Switch.BackgroundColor3 = Toggled and WinAccent or Color3.fromRGB(45, 45, 55)
                Switch.Position = UDim2.new(1, -40, 0.5, 0)
                Switch.Size = UDim2.new(0, 30, 0, 16)
                local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(1, 0); sCorner.Parent = Switch

                Dot.Parent = Switch
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dot.Position = Toggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                Dot.Size = UDim2.new(0, 12, 0, 12)
                local dCorner = Instance.new("UICorner"); dCorner.CornerRadius = UDim.new(1, 0); dCorner.Parent = Dot

                local function Update()
                    Library:Tween(Switch, 0.2, {BackgroundColor3 = Toggled and WinAccent or Color3.fromRGB(45, 45, 55)})
                    Library:Tween(Dot, 0.2, {Position = Toggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
                    pcall(config.Callback, Toggled)
                end
                Tog.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                return {Set = function(self, v) Toggled = v Update() end}
            end

            function ElementMethods:AddSlider(config)
                config = config or {}
                local Min, Max, Def = config.Min or 0, config.Max or 100, config.Default or 50
                local Slid = Instance.new("Frame")
                local SlidLabel = Instance.new("TextLabel")
                local ValLabel = Instance.new("TextLabel")
                local Bar = Instance.new("Frame")
                local Fill = Instance.new("Frame")
                local Trigger = Instance.new("TextButton")

                Slid.Parent = SecContainer
                Slid.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Slid.Size = UDim2.new(1, 0, 0, 45)
                local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(0, 4); sCorner.Parent = Slid

                SlidLabel.Parent = Slid
                SlidLabel.BackgroundTransparency = 1
                SlidLabel.Position = UDim2.new(0, 12, 0, 6)
                SlidLabel.Size = UDim2.new(0.5, 0, 0, 15)
                SlidLabel.Font = Enum.Font.Code
                SlidLabel.Text = config.Title or "Slider"
                SlidLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                SlidLabel.TextSize = 12
                SlidLabel.TextXAlignment = Enum.TextXAlignment.Left

                ValLabel.Parent = Slid
                ValLabel.BackgroundTransparency = 1
                ValLabel.Position = UDim2.new(0.5, 0, 0, 6)
                ValLabel.Size = UDim2.new(0.5, -12, 0, 15)
                ValLabel.Font = Enum.Font.Code
                ValLabel.Text = tostring(Def)
                ValLabel.TextColor3 = WinAccent
                ValLabel.TextSize = 12
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                Bar.Parent = Slid
                Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                Bar.Position = UDim2.new(0, 12, 0, 28)
                Bar.Size = UDim2.new(1, -24, 0, 6)
                local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(1, 0); bCorner.Parent = Bar

                Fill.Parent = Bar
                Fill.BackgroundColor3 = WinAccent
                Fill.Size = UDim2.new((Def - Min) / (Max - Min), 0, 1, 0)
                local fCorner = Instance.new("UICorner"); fCorner.CornerRadius = UDim.new(1, 0); fCorner.Parent = Fill

                Trigger.Parent = Bar
                Trigger.BackgroundTransparency = 1
                Trigger.Size = UDim2.new(1, 0, 1, 0)
                Trigger.Text = ""

                local function Move()
                    local perc = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(Min + (Max - Min) * perc)
                    ValLabel.Text = val
                    Fill.Size = UDim2.new(perc, 0, 1, 0)
                    pcall(config.Callback, val)
                end
                local Dragging = false
                Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true Move() end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                UserInputService.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Move() end end)
                return {Set = function(self, v) ValLabel.Text = v Fill.Size = UDim2.new((v - Min) / (Max - Min), 0, 1, 0) pcall(config.Callback, v) end}
            end

            function ElementMethods:AddDropdown(config)
                config = config or {}
                local options = config.Options or config.Values or {}
                local Drop = Instance.new("Frame")
                local DropBtn = Instance.new("TextButton")
                local DropLabel = Instance.new("TextLabel")
                local List = Instance.new("Frame")
                local ListLayout = Instance.new("UIListLayout")

                Drop.Parent = SecContainer
                Drop.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Drop.Size = UDim2.new(1, 0, 0, 32)
                Drop.ClipsDescendants = true
                local dCorner = Instance.new("UICorner"); dCorner.CornerRadius = UDim.new(0, 4); dCorner.Parent = Drop

                DropBtn.Parent = Drop
                DropBtn.BackgroundTransparency = 1
                DropBtn.Size = UDim2.new(1, 0, 0, 32)
                DropBtn.Text = ""

                DropLabel.Parent = Drop
                DropLabel.BackgroundTransparency = 1
                DropLabel.Position = UDim2.new(0, 12, 0, 0)
                DropLabel.Size = UDim2.new(1, -12, 0, 32)
                DropLabel.Font = Enum.Font.Code
                DropLabel.Text = (config.Title or "Dropdown") .. ": " .. tostring(config.Default or "")
                DropLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                DropLabel.TextSize = 12
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left

                List.Parent = Drop
                List.BackgroundTransparency = 1
                List.Position = UDim2.new(0, 0, 0, 32)
                List.Size = UDim2.new(1, 0, 0, 0)
                ListLayout.Parent = List
                ListLayout.Padding = UDim.new(0, 4)

                local Open = false
                local function Toggle()
                    Open = not Open
                    Library:Tween(Drop, 0.3, {Size = UDim2.new(1, 0, 0, Open and (ListLayout.AbsoluteContentSize.Y + 38) or 32)})
                end
                DropBtn.MouseButton1Click:Connect(Toggle)

                local function AddOpts(opts)
                    for _, o in pairs(opts) do
                        local Opt = Instance.new("TextButton")
                        Opt.Parent = List
                        Opt.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                        Opt.Size = UDim2.new(1, 0, 0, 28)
                        Opt.Font = Enum.Font.Code
                        Opt.Text = o
                        Opt.TextColor3 = Color3.fromRGB(180, 180, 180)
                        Opt.TextSize = 11
                        local oCorner = Instance.new("UICorner"); oCorner.CornerRadius = UDim.new(0, 3); oCorner.Parent = Opt
                        Opt.MouseButton1Click:Connect(function()
                            DropLabel.Text = (config.Title or "Dropdown") .. ": " .. o
                            Toggle()
                            pcall(config.Callback, o)
                        end)
                    end
                end
                AddOpts(options)
                return {Refresh = function(self, n) for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOpts(n) end}
            end

            function ElementMethods:AddTextbox(config)
                config = config or {}
                local Box = Instance.new("Frame")
                local BoxLabel = Instance.new("TextLabel")
                local Input = Instance.new("TextBox")

                Box.Parent = SecContainer
                Box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                Box.Size = UDim2.new(1, 0, 0, 32)
                local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 4); bCorner.Parent = Box

                BoxLabel.Parent = Box
                BoxLabel.BackgroundTransparency = 1
                BoxLabel.Position = UDim2.new(0, 12, 0, 0)
                BoxLabel.Size = UDim2.new(0, 100, 1, 0)
                BoxLabel.Font = Enum.Font.Code
                BoxLabel.Text = config.Title or "Textbox"
                BoxLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                BoxLabel.TextSize = 12
                BoxLabel.TextXAlignment = Enum.TextXAlignment.Left

                Input.Parent = Box
                Input.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                Input.Position = UDim2.new(1, -130, 0.5, -11)
                Input.Size = UDim2.new(0, 120, 0, 22)
                Input.Font = Enum.Font.Code
                Input.Text = config.Default or ""
                Input.TextColor3 = WinAccent
                Input.TextSize = 11
                local iCorner = Instance.new("UICorner"); iCorner.CornerRadius = UDim.new(0, 3); iCorner.Parent = Input
                Input.FocusLost:Connect(function() pcall(config.Callback, Input.Text) end)
            end
            ElementMethods.AddInput = ElementMethods.AddTextbox

            function ElementMethods:AddLabel(text)
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

            function ElementMethods:AddParagraph(config)
                config = config or {}
                local Para = Instance.new("Frame")
                local ParaTitle = Instance.new("TextLabel")
                local ParaText = Instance.new("TextLabel")

                Para.Parent = SecContainer
                Para.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                Para.Size = UDim2.new(1, 0, 0, 40)
                local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 4); pCorner.Parent = Para

                ParaTitle.Parent = Para
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Position = UDim2.new(0, 12, 0, 6)
                ParaTitle.Size = UDim2.new(1, -24, 0, 15)
                ParaTitle.Font = Enum.Font.Arcade
                ParaTitle.Text = (config.Title or "Info"):upper()
                ParaTitle.TextColor3 = WinAccent
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

            function ElementMethods:AddSeperator(text)
                local Sep = Instance.new("Frame")
                local Lab = Instance.new("TextLabel")
                Sep.Parent = SecContainer
                Sep.BackgroundTransparency = 1
                Sep.Size = UDim2.new(1, 0, 0, 20)
                Lab.Parent = Sep
                Lab.Size = UDim2.new(1, 0, 1, 0)
                Lab.BackgroundTransparency = 1
                Lab.Font = Enum.Font.Code
                Lab.Text = "--- " .. text:upper() .. " ---"
                Lab.TextColor3 = Color3.fromRGB(80, 80, 100)
                Lab.TextSize = 10
            end

            function ElementMethods:AddDiscord(title, invite)
                local Card = Instance.new("Frame")
                local Lab = Instance.new("TextLabel")
                local Join = Instance.new("TextButton")
                Card.Parent = SecContainer
                Card.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                Card.Size = UDim2.new(1, 0, 0, 50)
                local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(0, 4); cCorner.Parent = Card
                Lab.Parent = Card
                Lab.BackgroundTransparency = 1
                Lab.Position = UDim2.new(0, 12, 0, 0)
                Lab.Size = UDim2.new(1, -120, 1, 0)
                Lab.Font = Enum.Font.Arcade
                Lab.Text = (title or "DISCORD"):upper()
                Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
                Lab.TextSize = 12
                Lab.TextXAlignment = Enum.TextXAlignment.Left
                Join.Parent = Card
                Join.BackgroundColor3 = WinAccent
                Join.Position = UDim2.new(1, -65, 0.5, -12)
                Join.Size = UDim2.new(0, 55, 0, 24)
                Join.Font = Enum.Font.Arcade
                Join.Text = "JOIN"
                Join.TextColor3 = Color3.fromRGB(255, 255, 255)
                Join.TextSize = 11
                local jCorner = Instance.new("UICorner"); jCorner.CornerRadius = UDim.new(0, 3); jCorner.Parent = Join
                Join.MouseButton1Click:Connect(function()
                    if setclipboard then setclipboard("https://discord.gg/" .. invite) end
                    Join.Text = "COPIED"
                    task.wait(2)
                    Join.Text = "JOIN"
                end)
            end

            return ElementMethods
        end

        return SectionMethods
    end

    -- Toggle Button
    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "ArcadeToggle"
    ToggleBtn.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
    MainBtn.Parent = ToggleBtn
    MainBtn.BackgroundColor3 = WinAccent
    MainBtn.Position = UDim2.new(0, 20, 0, 20)
    MainBtn.Size = UDim2.new(0, 45, 0, 45)
    MainBtn.Image = "rbxassetid://101817370702077"
    local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(1, 0); bCorner.Parent = MainBtn
    Library:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    Library:Notify({Title = "SYSTEM LOADED", Content = "Arcade Impeccable Edition ready.", Duration = 4})

    return TabMethods
end

return Library
