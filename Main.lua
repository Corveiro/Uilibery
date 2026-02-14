local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ Theme & Style ] --
local Theme = {
    Main = Color3.fromRGB(12, 12, 15),
    Secondary = Color3.fromRGB(18, 18, 22),
    Accent = Color3.fromRGB(255, 0, 0), -- Default Red
    Outline = Color3.fromRGB(35, 35, 40),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 165),
    FontMain = Enum.Font.GothamBold,
    FontSecondary = Enum.Font.GothamMedium
}

-- [ Utility Functions ] --
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
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

-- [ Notification System ] --
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "EliteNotify"
NotifyGui.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Parent = NotifyGui; NotifyHolder.BackgroundTransparency = 1; NotifyHolder.Position = UDim2.new(1, -310, 0, 20); NotifyHolder.Size = UDim2.new(0, 300, 1, -40)
local NotifyList = Instance.new("UIListLayout"); NotifyList.Parent = NotifyHolder; NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifyList.Padding = UDim.new(0, 10)

function Library:Notify(config)
    local title = config.Title or "SYSTEM"
    local text = config.Content or config.Text or "Notification"
    local duration = config.Duration or 5
    
    local Card = Instance.new("Frame")
    local CardCorner = Instance.new("UICorner"); CardCorner.CornerRadius = UDim.new(0, 8); CardCorner.Parent = Card
    local CardStroke = Instance.new("UIStroke"); CardStroke.Color = Theme.Accent; CardStroke.Thickness = 1.5; CardStroke.Parent = Card; CardStroke.Transparency = 1
    local T = Instance.new("TextLabel"); local M = Instance.new("TextLabel"); local Bar = Instance.new("Frame")

    Card.Parent = NotifyHolder; Card.BackgroundColor3 = Theme.Main; Card.Size = UDim2.new(1, 0, 0, 65); Card.Transparency = 1; Card.ClipsDescendants = true
    T.Parent = Card; T.BackgroundTransparency = 1; T.Position = UDim2.new(0, 12, 0, 8); T.Size = UDim2.new(1, -24, 0, 15); T.Font = Theme.FontMain; T.Text = title:upper(); T.TextColor3 = Theme.Accent; T.TextSize = 14; T.TextXAlignment = Enum.TextXAlignment.Left
    M.Parent = Card; M.BackgroundTransparency = 1; M.Position = UDim2.new(0, 12, 0, 26); M.Size = UDim2.new(1, -24, 0, 30); M.Font = Theme.FontSecondary; M.Text = text; M.TextColor3 = Theme.Text; M.TextSize = 12; M.TextXAlignment = Enum.TextXAlignment.Left; M.TextWrapped = true
    Bar.Parent = Card; Bar.BackgroundColor3 = Theme.Accent; Bar.BorderSizePixel = 0; Bar.Position = UDim2.new(0, 0, 1, -2); Bar.Size = UDim2.new(1, 0, 0, 2)

    Library:Tween(Card, 0.5, {Transparency = 0}, Enum.EasingStyle.Quint)
    Library:Tween(CardStroke, 0.5, {Transparency = 0})
    Library:Tween(Bar, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)
    task.delay(duration, function() Library:Tween(Card, 0.5, {Transparency = 1, Position = UDim2.new(1, 20, 0, 0)}, Enum.EasingStyle.Quint) task.wait(0.5) Card:Destroy() end)
end

-- [ Main Window ] --
function Library:NewWindow(ConfigWindow)
    ConfigWindow = ConfigWindow or {}
    local TitleText = ConfigWindow.Title or "ELITE HUB"
    local DescText = ConfigWindow.Description or "Premium Edition"
    local WinAccent = ConfigWindow.AccentColor or Theme.Accent

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "EliteMain"
    MainGui.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
    MainGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 10); MainCorner.Parent = Main
    local MainStroke = Instance.new("UIStroke"); MainStroke.Color = WinAccent; MainStroke.Thickness = 2; MainStroke.Parent = Main; MainStroke.Transparency = 0.4
    
    Main.Name = "Main"; Main.Parent = MainGui; Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Theme.Main; Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.Size = UDim2.new(0, 520, 0, 360); Main.ClipsDescendants = true

    -- [ LUXURY EFFECT: Animated Background ]
    local BgGradient = Instance.new("UIGradient")
    BgGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10))})
    BgGradient.Rotation = 45; BgGradient.Parent = Main
    task.spawn(function() while Main do for i = 0, 360, 1 do if not Main then break end BgGradient.Rotation = i task.wait(0.05) end end end)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"; TopBar.Parent = Main; TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25); TopBar.Size = UDim2.new(1, 0, 0, 50)
    
    local WinTitle = Instance.new("TextLabel")
    WinTitle.Parent = TopBar; WinTitle.BackgroundTransparency = 1; WinTitle.Position = UDim2.new(0, 15, 0, 10); WinTitle.Size = UDim2.new(0.7, 0, 0, 20); WinTitle.Font = Theme.FontMain; WinTitle.Text = TitleText:upper(); WinTitle.TextColor3 = Theme.Text; WinTitle.TextSize = 18; WinTitle.TextXAlignment = Enum.TextXAlignment.Left

    local WinDesc = Instance.new("TextLabel")
    WinDesc.Parent = TopBar; WinDesc.BackgroundTransparency = 1; WinDesc.Position = UDim2.new(0, 15, 0, 28); WinDesc.Size = UDim2.new(0.7, 0, 0, 12); WinDesc.Font = Theme.FontSecondary; WinDesc.Text = DescText; WinDesc.TextColor3 = WinAccent; WinDesc.TextSize = 11; WinDesc.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar; CloseBtn.BackgroundTransparency = 1; CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.Size = UDim2.new(0, 40, 1, 0); CloseBtn.Font = Theme.FontMain; CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.TextSize = 18
    CloseBtn.MouseButton1Click:Connect(function() Library:Tween(Main, 0.4, {Size = UDim2.new(0,0,0,0), Transparency = 1}, Enum.EasingStyle.Quint) task.wait(0.4) MainGui:Destroy() end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"; Sidebar.Parent = Main; Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Sidebar.Position = UDim2.new(0, 0, 0, 50); Sidebar.Size = UDim2.new(0, 140, 1, -50)

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Parent = Sidebar; TabHolder.BackgroundTransparency = 1; TabHolder.Size = UDim2.new(1, 0, 1, 0); TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0); TabHolder.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout"); TabList.Parent = TabHolder; TabList.Padding = UDim.new(0, 6)
    local TabPad = Instance.new("UIPadding"); TabPad.Parent = TabHolder; TabPad.PaddingTop = UDim.new(0, 12); TabPad.PaddingLeft = UDim.new(0, 10); TabPad.PaddingRight = UDim.new(0, 10)

    local Content = Instance.new("Frame")
    Content.Name = "Content"; Content.Parent = Main; Content.BackgroundTransparency = 1; Content.Position = UDim2.new(0, 140, 0, 50); Content.Size = UDim2.new(1, -140, 1, -50)
    local PageLayout = Instance.new("UIPageLayout"); PageLayout.Parent = Content; PageLayout.SortOrder = Enum.SortOrder.LayoutOrder; PageLayout.EasingStyle = Enum.EasingStyle.Quint; PageLayout.TweenTime = 0.5

    Library:MakeDraggable(TopBar, Main)

    local TabCount = 0
    local FirstTab = true
    local TabMethods = {}

    function TabMethods:T(t, icon)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner"); TabBtnCorner.CornerRadius = UDim.new(0, 8); TabBtnCorner.Parent = TabBtn
        local TabBtnLabel = Instance.new("TextLabel")
        local ActiveIndicator = Instance.new("Frame")

        TabBtn.Parent = TabHolder; TabBtn.BackgroundColor3 = WinAccent; TabBtn.BackgroundTransparency = 1; TabBtn.Size = UDim2.new(1, 0, 0, 36); TabBtn.Text = ""; TabBtn.LayoutOrder = TabCount
        TabBtnLabel.Parent = TabBtn; TabBtnLabel.BackgroundTransparency = 1; TabBtnLabel.Size = UDim2.new(1, 0, 1, 0); TabBtnLabel.Font = Theme.FontSecondary; TabBtnLabel.Text = t; TabBtnLabel.TextColor3 = Theme.TextDark; TabBtnLabel.TextSize = 13
        ActiveIndicator.Parent = TabBtn; ActiveIndicator.BackgroundColor3 = WinAccent; ActiveIndicator.BorderSizePixel = 0; ActiveIndicator.Position = UDim2.new(0, -10, 0.5, -10); ActiveIndicator.Size = UDim2.new(0, 3, 0, 20); ActiveIndicator.Transparency = 1
        local AiCorner = Instance.new("UICorner"); AiCorner.CornerRadius = UDim.new(1,0); AiCorner.Parent = ActiveIndicator

        local Page = Instance.new("ScrollingFrame")
        Page.Name = t .. "_Page"; Page.Parent = Content; Page.BackgroundTransparency = 1; Page.Size = UDim2.new(1, 0, 1, 0); Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = WinAccent; Page.LayoutOrder = TabCount
        local PageList = Instance.new("UIListLayout"); PageList.Parent = Page; PageList.Padding = UDim.new(0, 10)
        local PagePad = Instance.new("UIPadding"); PagePad.Parent = Page; PagePad.PaddingTop = UDim.new(0, 15); PagePad.PaddingLeft = UDim.new(0, 15); PagePad.PaddingRight = UDim.new(0, 15); PagePad.PaddingBottom = UDim.new(0, 15)

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20) end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then Library:Tween(v, 0.3, {BackgroundTransparency = 1}); Library:Tween(v.TextLabel, 0.3, {TextColor3 = Theme.TextDark}); Library:Tween(v.Frame, 0.3, {Transparency = 1, Position = UDim2.new(0, -10, 0.5, -10)}) end end
            Library:Tween(TabBtn, 0.3, {BackgroundTransparency = 0.9}); Library:Tween(TabBtnLabel, 0.3, {TextColor3 = Theme.Text}); Library:Tween(ActiveIndicator, 0.3, {Transparency = 0, Position = UDim2.new(0, -2, 0.5, -10)})
            PageLayout:JumpToIndex(TabBtn.LayoutOrder)
        end)

        if FirstTab then FirstTab = false; TabBtn.BackgroundTransparency = 0.9; TabBtnLabel.TextColor3 = Theme.Text; ActiveIndicator.Transparency = 0; ActiveIndicator.Position = UDim2.new(0, -2, 0.5, -10) end

        TabCount = TabCount + 1
        local SectionMethods = {}

        function SectionMethods:AddSection(stitle)
            local SecFrame = Instance.new("Frame")
            local SecTitle = Instance.new("TextLabel")
            local SecContainer = Instance.new("Frame")
            local SecLayout = Instance.new("UIListLayout")

            SecFrame.Parent = Page; SecFrame.BackgroundTransparency = 1; SecFrame.Size = UDim2.new(1, 0, 0, 30); SecFrame.AutomaticSize = Enum.AutomaticSize.Y
            SecTitle.Parent = SecFrame; SecTitle.BackgroundTransparency = 1; SecTitle.Size = UDim2.new(1, 0, 0, 25); SecTitle.Font = Theme.FontMain; SecTitle.Text = stitle:upper(); SecTitle.TextColor3 = WinAccent; SecTitle.TextSize = 13; SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            SecContainer.Parent = SecFrame; SecContainer.BackgroundTransparency = 1; SecContainer.Position = UDim2.new(0, 0, 0, 28); SecContainer.Size = UDim2.new(1, 0, 0, 0); SecContainer.AutomaticSize = Enum.AutomaticSize.Y
            SecLayout.Parent = SecContainer; SecLayout.Padding = UDim.new(0, 8)

            local ElementMethods = {}

            function ElementMethods:AddButton(config)
                config = config or {}
                local Btn = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(0, 8); BtnCorner.Parent = Btn
                local BtnStroke = Instance.new("UIStroke"); BtnStroke.Color = Theme.Outline; BtnStroke.Parent = Btn; BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                local BtnLabel = Instance.new("TextLabel")

                Btn.Parent = SecContainer; Btn.BackgroundColor3 = Theme.Secondary; Btn.Size = UDim2.new(1, 0, 0, 38); Btn.Text = ""; Btn.AutoButtonColor = false
                BtnLabel.Parent = Btn; BtnLabel.BackgroundTransparency = 1; BtnLabel.Size = UDim2.new(1, 0, 1, 0); BtnLabel.Font = Theme.FontSecondary; BtnLabel.Text = config.Title or "Button"; BtnLabel.TextColor3 = Theme.Text; BtnLabel.TextSize = 13

                Btn.MouseEnter:Connect(function() Library:Tween(BtnStroke, 0.3, {Color = WinAccent}) Library:Tween(Btn, 0.3, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}) end)
                Btn.MouseLeave:Connect(function() Library:Tween(BtnStroke, 0.3, {Color = Theme.Outline}) Library:Tween(Btn, 0.3, {BackgroundColor3 = Theme.Secondary}) end)
                Btn.MouseButton1Click:Connect(function() Library:Tween(Btn, 0.1, {Size = UDim2.new(0.98, 0, 0, 36)}, Enum.EasingStyle.Quad) task.wait(0.1) Library:Tween(Btn, 0.1, {Size = UDim2.new(1, 0, 0, 38)}, Enum.EasingStyle.Quad) pcall(config.Callback) end)
                return {Set = function(self, t) BtnLabel.Text = t end}
            end

            function ElementMethods:AddToggle(config)
                config = config or {}
                local Toggled = config.Default or false
                local Tog = Instance.new("TextButton")
                local TogLabel = Instance.new("TextLabel")
                local Switch = Instance.new("Frame")
                local Dot = Instance.new("Frame")

                Tog.Parent = SecContainer; Tog.BackgroundColor3 = Theme.Secondary; Tog.Size = UDim2.new(1, 0, 0, 38); Tog.Text = ""
                local tCorner = Instance.new("UICorner"); tCorner.CornerRadius = UDim.new(0, 8); tCorner.Parent = Tog
                local tStroke = Instance.new("UIStroke"); tStroke.Color = Theme.Outline; tStroke.Parent = Tog
                TogLabel.Parent = Tog; TogLabel.BackgroundTransparency = 1; TogLabel.Position = UDim2.new(0, 15, 0, 0); TogLabel.Size = UDim2.new(1, -70, 1, 0); TogLabel.Font = Theme.FontSecondary; TogLabel.Text = config.Title or "Toggle"; TogLabel.TextColor3 = Theme.Text; TogLabel.TextSize = 13; TogLabel.TextXAlignment = Enum.TextXAlignment.Left
                Switch.Parent = Tog; Switch.AnchorPoint = Vector2.new(0, 0.5); Switch.BackgroundColor3 = Toggled and WinAccent or Color3.fromRGB(40, 40, 45); Switch.Position = UDim2.new(1, -50, 0.5, 0); Switch.Size = UDim2.new(0, 36, 0, 20)
                local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(1, 0); sCorner.Parent = Switch
                Dot.Parent = Switch; Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Dot.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); Dot.Size = UDim2.new(0, 16, 0, 16)
                local dCorner = Instance.new("UICorner"); dCorner.CornerRadius = UDim.new(1, 0); dCorner.Parent = Dot

                local function Update() Library:Tween(Switch, 0.3, {BackgroundColor3 = Toggled and WinAccent or Color3.fromRGB(40, 40, 45)}); Library:Tween(Dot, 0.3, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}); pcall(config.Callback, Toggled) end
                Tog.MouseButton1Click:Connect(function() Toggled = not Toggled Update() end)
                return {Set = function(self, v) Toggled = v Update() end}
            end

            function ElementMethods:AddSlider(config)
                config = config or {}
                local Min, Max, Def = config.Min or 0, config.Max or 100, config.Default or 50
                local Slid = Instance.new("Frame")
                local SlidLabel = Instance.new("TextLabel"); local ValLabel = Instance.new("TextLabel")
                local Bar = Instance.new("Frame"); local Fill = Instance.new("Frame"); local Trigger = Instance.new("TextButton")

                Slid.Parent = SecContainer; Slid.BackgroundColor3 = Theme.Secondary; Slid.Size = UDim2.new(1, 0, 0, 50)
                local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(0, 8); sCorner.Parent = Slid
                local sStroke = Instance.new("UIStroke"); sStroke.Color = Theme.Outline; sStroke.Parent = Slid
                SlidLabel.Parent = Slid; SlidLabel.BackgroundTransparency = 1; SlidLabel.Position = UDim2.new(0, 15, 0, 8); SlidLabel.Size = UDim2.new(0.5, 0, 0, 15); SlidLabel.Font = Theme.FontSecondary; SlidLabel.Text = config.Title or "Slider"; SlidLabel.TextColor3 = Theme.Text; SlidLabel.TextSize = 13; SlidLabel.TextXAlignment = Enum.TextXAlignment.Left
                ValLabel.Parent = Slid; ValLabel.BackgroundTransparency = 1; ValLabel.Position = UDim2.new(0.5, 0, 0, 8); ValLabel.Size = UDim2.new(0.5, -15, 0, 15); ValLabel.Font = Theme.FontSecondary; ValLabel.Text = tostring(Def); ValLabel.TextColor3 = WinAccent; ValLabel.TextSize = 13; ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                Bar.Parent = Slid; Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Bar.Position = UDim2.new(0, 15, 0, 32); Bar.Size = UDim2.new(1, -30, 0, 6)
                local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(1, 0); bCorner.Parent = Bar
                Fill.Parent = Bar; Fill.BackgroundColor3 = WinAccent; Fill.Size = UDim2.new((Def - Min) / (Max - Min), 0, 1, 0)
                local fCorner = Instance.new("UICorner"); fCorner.CornerRadius = UDim.new(1, 0); fCorner.Parent = Fill
                Trigger.Parent = Bar; Trigger.BackgroundTransparency = 1; Trigger.Size = UDim2.new(1, 0, 1, 0); Trigger.Text = ""

                local function Move() local perc = math.clamp((Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); local val = math.floor(Min + (Max - Min) * perc); ValLabel.Text = val; Fill.Size = UDim2.new(perc, 0, 1, 0); pcall(config.Callback, val) end
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
                local List = Instance.new("Frame"); local ListLayout = Instance.new("UIListLayout")

                Drop.Parent = SecContainer; Drop.BackgroundColor3 = Theme.Secondary; Drop.Size = UDim2.new(1, 0, 0, 38); Drop.ClipsDescendants = true
                local dCorner = Instance.new("UICorner"); dCorner.CornerRadius = UDim.new(0, 8); dCorner.Parent = Drop
                local dStroke = Instance.new("UIStroke"); dStroke.Color = Theme.Outline; dStroke.Parent = Drop
                DropBtn.Parent = Drop; DropBtn.BackgroundTransparency = 1; DropBtn.Size = UDim2.new(1, 0, 0, 38); DropBtn.Text = ""
                DropLabel.Parent = Drop; DropLabel.BackgroundTransparency = 1; DropLabel.Position = UDim2.new(0, 15, 0, 0); DropLabel.Size = UDim2.new(1, -15, 0, 38); DropLabel.Font = Theme.FontSecondary; DropLabel.Text = (config.Title or "Dropdown") .. ": " .. tostring(config.Default or ""); DropLabel.TextColor3 = Theme.Text; DropLabel.TextSize = 13; DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                List.Parent = Drop; List.BackgroundTransparency = 1; List.Position = UDim2.new(0, 0, 0, 38); List.Size = UDim2.new(1, 0, 0, 0); ListLayout.Parent = List; ListLayout.Padding = UDim.new(0, 5)
                local lPad = Instance.new("UIPadding"); lPad.Parent = List; lPad.PaddingLeft = UDim.new(0, 10); lPad.PaddingRight = UDim.new(0, 10); lPad.PaddingBottom = UDim.new(0, 10)

                local Open = false
                local function Toggle() Open = not Open; Library:Tween(Drop, 0.4, {Size = UDim2.new(1, 0, 0, Open and (ListLayout.AbsoluteContentSize.Y + 45) or 38)}, Enum.EasingStyle.Quint) end
                DropBtn.MouseButton1Click:Connect(Toggle)

                local function AddOpts(opts)
                    for _, o in pairs(opts) do
                        local Opt = Instance.new("TextButton")
                        Opt.Parent = List; Opt.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Opt.Size = UDim2.new(1, 0, 0, 32); Opt.Font = Theme.FontSecondary; Opt.Text = o; Opt.TextColor3 = Theme.TextDark; Opt.TextSize = 12
                        local oCorner = Instance.new("UICorner"); oCorner.CornerRadius = UDim.new(0, 6); oCorner.Parent = Opt
                        Opt.MouseButton1Click:Connect(function() DropLabel.Text = (config.Title or "Dropdown") .. ": " .. o Toggle() pcall(config.Callback, o) end)
                    end
                end
                AddOpts(options)
                return {Refresh = function(self, n) for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end AddOpts(n) end}
            end

            function ElementMethods:AddTextbox(config)
                config = config or {}
                local Box = Instance.new("Frame")
                local BoxLabel = Instance.new("TextLabel"); local Input = Instance.new("TextBox")

                Box.Parent = SecContainer; Box.BackgroundColor3 = Theme.Secondary; Box.Size = UDim2.new(1, 0, 0, 38)
                local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 8); bCorner.Parent = Box
                local bStroke = Instance.new("UIStroke"); bStroke.Color = Theme.Outline; bStroke.Parent = Box
                BoxLabel.Parent = Box; BoxLabel.BackgroundTransparency = 1; BoxLabel.Position = UDim2.new(0, 15, 0, 0); BoxLabel.Size = UDim2.new(0, 100, 1, 0); BoxLabel.Font = Theme.FontSecondary; BoxLabel.Text = config.Title or "Textbox"; BoxLabel.TextColor3 = Theme.Text; BoxLabel.TextSize = 13; BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                Input.Parent = Box; Input.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Input.Position = UDim2.new(1, -145, 0.5, -13); Input.Size = UDim2.new(0, 130, 0, 26); Input.Font = Theme.FontSecondary; Input.Text = config.Default or ""; Input.TextColor3 = WinAccent; Input.TextSize = 12
                local iCorner = Instance.new("UICorner"); iCorner.CornerRadius = UDim.new(0, 6); iCorner.Parent = Input
                local iStroke = Instance.new("UIStroke"); iStroke.Color = Theme.Outline; iStroke.Parent = Input
                Input.FocusLost:Connect(function() pcall(config.Callback, Input.Text) end)
            end
            ElementMethods.AddInput = ElementMethods.AddTextbox

            function ElementMethods:AddLabel(text)
                local Lab = Instance.new("TextLabel")
                Lab.Parent = SecContainer; Lab.BackgroundTransparency = 1; Lab.Size = UDim2.new(1, 0, 0, 20)
                Lab.Font = Theme.FontSecondary; Lab.Text = text; Lab.TextColor3 = Theme.TextDark; Lab.TextSize = 12; Lab.TextXAlignment = Enum.TextXAlignment.Left
                return {Set = function(self, v) Lab.Text = v end}
            end

            function ElementMethods:AddParagraph(config)
                config = config or {}
                local Para = Instance.new("Frame")
                local ParaTitle = Instance.new("TextLabel"); local ParaText = Instance.new("TextLabel")

                Para.Parent = SecContainer; Para.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Para.Size = UDim2.new(1, 0, 0, 40)
                local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 8); pCorner.Parent = Para
                local pStroke = Instance.new("UIStroke"); pStroke.Color = Theme.Outline; pStroke.Parent = Para
                ParaTitle.Parent = Para; ParaTitle.BackgroundTransparency = 1; ParaTitle.Position = UDim2.new(0, 15, 0, 8); ParaTitle.Size = UDim2.new(1, -30, 0, 15); ParaTitle.Font = Theme.FontMain; ParaTitle.Text = (config.Title or "Info"):upper(); ParaTitle.TextColor3 = WinAccent; ParaTitle.TextSize = 12; ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParaText.Parent = Para; ParaText.BackgroundTransparency = 1; ParaText.Position = UDim2.new(0, 15, 0, 25); ParaText.Size = UDim2.new(1, -30, 0, 15); ParaText.Font = Theme.FontSecondary; ParaText.Text = config.Content or config.Desc or ""; ParaText.TextColor3 = Theme.TextDark; ParaText.TextSize = 11; ParaText.TextXAlignment = Enum.TextXAlignment.Left; ParaText.TextWrapped = true
                local function Update() Para.Size = UDim2.new(1, 0, 0, ParaText.TextBounds.Y + 35); ParaText.Size = UDim2.new(1, -30, 0, ParaText.TextBounds.Y) end
                ParaText:GetPropertyChangedSignal("Text"):Connect(Update); Update()
                return {Set = function(self, v) ParaText.Text = v end}
            end

            function ElementMethods:AddSeperator(text)
                local Sep = Instance.new("Frame")
                local Lab = Instance.new("TextLabel")
                local L = Instance.new("Frame"); local R = Instance.new("Frame")

                Sep.Parent = SecContainer; Sep.BackgroundTransparency = 1; Sep.Size = UDim2.new(1, 0, 0, 30)
                Lab.Parent = Sep; Lab.AnchorPoint = Vector2.new(0.5, 0.5); Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0.5, 0, 0.5, 0); Lab.AutomaticSize = Enum.AutomaticSize.X; Lab.Font = Theme.FontMain; Lab.Text = text:upper(); Lab.TextColor3 = Color3.fromRGB(60, 60, 65); Lab.TextSize = 11
                L.Parent = Sep; L.BackgroundColor3 = Color3.fromRGB(40, 40, 45); L.BorderSizePixel = 0; L.Position = UDim2.new(0, 5, 0.5, 0); L.Size = UDim2.new(0.5, -60, 0, 1)
                R.Parent = Sep; R.BackgroundColor3 = Color3.fromRGB(40, 40, 45); R.BorderSizePixel = 0; R.Position = UDim2.new(1, -5, 0.5, 0); R.AnchorPoint = Vector2.new(1, 0); R.Size = UDim2.new(0.5, -60, 0, 1)
            end

            function ElementMethods:AddDiscord(title, invite)
                local Card = Instance.new("Frame")
                local Lab = Instance.new("TextLabel"); local Join = Instance.new("TextButton")
                Card.Parent = SecContainer; Card.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Card.Size = UDim2.new(1, 0, 0, 60)
                local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(0, 10); cCorner.Parent = Card
                local cStroke = Instance.new("UIStroke"); cStroke.Color = Color3.fromRGB(88, 101, 242); cStroke.Parent = Card
                Lab.Parent = Card; Lab.BackgroundTransparency = 1; Lab.Position = UDim2.new(0, 15, 0, 0); Lab.Size = UDim2.new(1, -130, 1, 0); Lab.Font = Theme.FontMain; Lab.Text = (title or "DISCORD SERVER"):upper(); Lab.TextColor3 = Theme.Text; Lab.TextSize = 13; Lab.TextXAlignment = Enum.TextXAlignment.Left
                Join.Parent = Card; Join.BackgroundColor3 = Color3.fromRGB(88, 101, 242); Join.Position = UDim2.new(1, -100, 0.5, -15); Join.Size = UDim2.new(0, 85, 0, 30); Join.Font = Theme.FontMain; Join.Text = "JOIN"; Join.TextColor3 = Theme.Text; Join.TextSize = 13
                local jCorner = Instance.new("UICorner"); jCorner.CornerRadius = UDim.new(0, 6); jCorner.Parent = Join
                Join.MouseButton1Click:Connect(function() if setclipboard then setclipboard("https://discord.gg/" .. invite) end Join.Text = "COPIED!" task.wait(2) Join.Text = "JOIN" end)
            end

            return ElementMethods
        end
        return SectionMethods
    end

    local ToggleBtn = Instance.new("ScreenGui")
    local MainBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "EliteToggle"; ToggleBtn.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
    MainBtn.Parent = ToggleBtn; MainBtn.BackgroundColor3 = WinAccent; MainBtn.Position = UDim2.new(0, 25, 0, 25); MainBtn.Size = UDim2.new(0, 50, 0, 50); MainBtn.Image = "rbxassetid://101817370702077"
    local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(1, 0); bCorner.Parent = MainBtn
    Library:MakeDraggable(MainBtn, MainBtn)
    MainBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    Library:Notify({Title = "ELITE LOADED", Content = "Welcome to the premium experience.", Duration = 4})

    return TabMethods
end

return Library
