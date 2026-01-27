local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility Functions
local function MakeDraggable(frame, dragFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame = dragFrame or frame
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(80, 80, 100)
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(20, 20, 30))
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

local function ProtectGui(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        gui.Parent = CoreGui
    end
end

local function RippleEffect(button)
    local ripple = Instance.new("ImageLabel")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundTransparency = 1
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ripple.ImageTransparency = 0.5
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y)
    TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, size * 2, 0, size * 2),
        ImageTransparency = 1
    }):Play()
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Main Library
function Library:CreateWindow()
    local WindowManager = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false
    }
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CokkaHubUI_" .. HttpService:GenerateGUID(false)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ProtectGui(ScreenGui)
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 700, 0, 500)
    MainContainer.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainContainer
    
    CreateStroke(MainContainer, Color3.fromRGB(60, 60, 80), 2)
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = 0
    Shadow.Parent = MainContainer
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainContainer
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    CreateGradient(TopBar, Color3.fromRGB(30, 30, 45), Color3.fromRGB(20, 20, 30), 0)
    
    -- Fixing corner overlap
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 12)
    TopBarFix.Position = UDim2.new(0, 0, 1, -12)
    TopBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar
    
    CreateGradient(TopBarFix, Color3.fromRGB(30, 30, 45), Color3.fromRGB(20, 20, 30), 0)
    
    -- Logo/Icon
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 35, 0, 35)
    Logo.Position = UDim2.new(0, 10, 0.5, -17.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://6031075938" -- Placeholder icon
    Logo.ImageColor3 = Color3.fromRGB(100, 150, 255)
    Logo.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 55, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Cokka Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(0, 200, 0, 15)
    Subtitle.Position = UDim2.new(0, 55, 0, 28)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Premium Edition"
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
    Subtitle.TextSize = 11
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = TopBar
    
    -- Control Buttons Container
    local ControlButtons = Instance.new("Frame")
    ControlButtons.Name = "ControlButtons"
    ControlButtons.Size = UDim2.new(0, 80, 0, 30)
    ControlButtons.Position = UDim2.new(1, -90, 0.5, -15)
    ControlButtons.BackgroundTransparency = 1
    ControlButtons.Parent = TopBar
    
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Padding = UDim.new(0, 5)
    ButtonLayout.Parent = ControlButtons
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.LayoutOrder = 1
    MinimizeButton.Parent = ControlButtons
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.LayoutOrder = 2
    CloseButton.Parent = ControlButtons
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Button Hover Effects
    for _, button in pairs({MinimizeButton, CloseButton}) do
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = button == CloseButton and Color3.fromRGB(220, 70, 70) or Color3.fromRGB(70, 70, 90)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = button == CloseButton and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 50, 70)
            }):Play()
        end)
        
        button.MouseButton1Click:Connect(function()
            RippleEffect(button)
        end)
    end
    
    -- Close Button Function
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Function
    MinimizeButton.MouseButton1Click:Connect(function()
        WindowManager.Minimized = not WindowManager.Minimized
        
        local targetSize = WindowManager.Minimized and UDim2.new(0, 700, 0, 50) or UDim2.new(0, 700, 0, 500)
        
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = targetSize
        }):Play()
        
        MinimizeButton.Text = WindowManager.Minimized and "+" or "─"
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 180, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainContainer
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 8)
    TabContainerCorner.Parent = TabContainer
    
    CreateStroke(TabContainer, Color3.fromRGB(40, 40, 50), 1)
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, -10, 1, -10)
    TabScroll.Position = UDim2.new(0, 5, 0, 5)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 4
    TabScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabScroll
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingRight = UDim.new(0, 5)
    TabPadding.Parent = TabScroll
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -210, 1, -60)
    ContentContainer.Position = UDim2.new(0, 200, 0, 55)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainContainer
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentContainer
    
    CreateStroke(ContentContainer, Color3.fromRGB(40, 40, 50), 1)
    
    -- Make Window Draggable
    MakeDraggable(MainContainer, TopBar)
    
    -- Tab Creation Function
    function WindowManager:Tab(name)
        local TabManager = {
            Name = name,
            Active = false
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. name
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabScroll
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Icon (optional)
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxassetid://6031097225" -- Placeholder
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 180)
        TabIcon.Parent = TabButton
        
        -- Tab Name
        local TabName = Instance.new("TextLabel")
        TabName.Name = "TabName"
        TabName.Size = UDim2.new(1, -50, 1, 0)
        TabName.Position = UDim2.new(0, 40, 0, 0)
        TabName.BackgroundTransparency = 1
        TabName.Text = name
        TabName.TextColor3 = Color3.fromRGB(180, 180, 200)
        TabName.TextSize = 14
        TabName.Font = Enum.Font.GothamSemibold
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. name
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 15)
        end)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 8)
        ContentPadding.PaddingBottom = UDim.new(0, 8)
        ContentPadding.PaddingLeft = UDim.new(0, 8)
        ContentPadding.PaddingRight = UDim.new(0, 8)
        ContentPadding.Parent = TabContent
        
        -- Tab Button Click
        TabButton.MouseButton1Click:Connect(function()
            RippleEffect(TabButton)
            
            for _, tab in pairs(WindowManager.Tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                tab.Name_Label.TextColor3 = Color3.fromRGB(180, 180, 200)
                tab.Icon.ImageColor3 = Color3.fromRGB(150, 150, 180)
                tab.Content.Visible = false
                tab.Active = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 80, 150)
            TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            TabManager.Active = true
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if not TabManager.Active then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabManager.Active then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                }):Play()
            end
        end)
        
        TabManager.Button = TabButton
        TabManager.Content = TabContent
        TabManager.Name_Label = TabName
        TabManager.Icon = TabIcon
        
        table.insert(WindowManager.Tabs, TabManager)
        
        -- Auto-select first tab
        if #WindowManager.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 80, 150)
            TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            TabManager.Active = true
        end
        
        -- ═══════════════════════════════════════════════════════
        --                    ELEMENT FUNCTIONS
        -- ═══════════════════════════════════════════════════════
        
        function TabManager:Label(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.Size = UDim2.new(1, 0, 0, 35)
            LabelFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = LabelFrame
            
            CreateStroke(LabelFrame, Color3.fromRGB(45, 45, 60), 1)
            
            local Label = Instance.new("TextLabel")
            Label.Name = "LabelText"
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 240)
            Label.TextSize = 14
            Label.Font = Enum.Font.GothamSemibold
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame
            
            local LabelObject = {}
            
            function LabelObject:Set(newText)
                Label.Text = newText
                
                -- Auto-resize based on text
                local textSize = game:GetService("TextService"):GetTextSize(
                    newText,
                    14,
                    Enum.Font.GothamSemibold,
                    Vector2.new(Label.AbsoluteSize.X, math.huge)
                )
                
                LabelFrame.Size = UDim2.new(1, 0, 0, math.max(35, textSize.Y + 10))
            end
            
            return LabelObject
        end
        
        function TabManager:Label1(text)
            return TabManager:Label(text)
        end
        
        function TabManager:Button(text, callback)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
            ButtonFrame.Text = ""
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.ClipsDescendants = true
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            CreateGradient(ButtonFrame, Color3.fromRGB(60, 110, 210), Color3.fromRGB(40, 90, 180), 45)
            CreateStroke(ButtonFrame, Color3.fromRGB(70, 120, 220), 1)
            
            local ButtonText = Instance.new("TextLabel")
            ButtonText.Name = "ButtonText"
            ButtonText.Size = UDim2.new(1, 0, 1, 0)
            ButtonText.BackgroundTransparency = 1
            ButtonText.Text = text
            ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonText.TextSize = 15
            ButtonText.Font = Enum.Font.GothamBold
            ButtonText.Parent = ButtonFrame
            
            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(60, 110, 210)
                }):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(50, 100, 200)
                }):Play()
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                RippleEffect(ButtonFrame)
                
                -- Scale animation
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -4, 0, 38)
                }):Play()
                
                task.wait(0.1)
                
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 40)
                }):Play()
                
                task.spawn(function()
                    pcall(callback)
                end)
            end)
        end
        
        function TabManager:Toggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            CreateStroke(ToggleFrame, Color3.fromRGB(45, 45, 60), 1)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextWrapped = true
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 50, 0, 24)
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(60, 60, 75)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            CreateStroke(ToggleButton, default and Color3.fromRGB(70, 220, 120) or Color3.fromRGB(80, 80, 95), 1)
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local CircleShadow = Instance.new("UIStroke")
            CircleShadow.Color = Color3.fromRGB(0, 0, 0)
            CircleShadow.Thickness = 0
            CircleShadow.Transparency = 0.5
            CircleShadow.Parent = ToggleCircle
            
            local toggled = default or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(60, 60, 75)
                }):Play()
                
                TweenService:Create(ToggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                }):Play()
                
                -- Update stroke color
                local stroke = ToggleButton:FindFirstChildOfClass("UIStroke")
                if stroke then
                    TweenService:Create(stroke, TweenInfo.new(0.25), {
                        Color = toggled and Color3.fromRGB(70, 220, 120) or Color3.fromRGB(80, 80, 95)
                    }):Play()
                end
                
                task.spawn(function()
                    pcall(callback, toggled)
                end)
            end)
            
            -- Hover effect
            ToggleButton.MouseEnter:Connect(function()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }):Play()
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                }):Play()
            end)
        end
        
        function TabManager:Slider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            CreateStroke(SliderFrame, Color3.fromRGB(45, 45, 60), 1)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Size = UDim2.new(1, -80, 0, 25)
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Size = UDim2.new(0, 60, 0, 25)
            SliderValue.Position = UDim2.new(1, -70, 0, 5)
            SliderValue.BackgroundColor3 = Color3.fromRGB(40, 80, 150)
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 13
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.BorderSizePixel = 0
            SliderValue.Parent = SliderFrame
            
            local ValueCorner = Instance.new("UICorner")
            ValueCorner.CornerRadius = UDim.new(0, 6)
            ValueCorner.Parent = SliderValue
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.Size = UDim2.new(1, -30, 0, 6)
            SliderBar.Position = UDim2.new(0, 15, 1, -20)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            CreateStroke(SliderBar, Color3.fromRGB(60, 60, 70), 1)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            CreateGradient(SliderFill, Color3.fromRGB(70, 130, 230), Color3.fromRGB(50, 110, 200), 0)
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.Size = UDim2.new(0, 16, 0, 16)
            SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Parent = SliderBar
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = SliderKnob
            
            CreateStroke(SliderKnob, Color3.fromRGB(60, 120, 220), 2)
            
            local dragging = false
            local currentValue = default
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * sizeX)
                
                currentValue = value
                
                TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(sizeX, 0, 1, 0)
                }):Play()
                
                TweenService:Create(SliderKnob, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(sizeX, -8, 0.5, -8)
                }):Play()
                
                SliderValue.Text = tostring(value)
                
                task.spawn(function()
                    pcall(callback, value)
                end)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                    
                    TweenService:Create(SliderKnob, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new((currentValue - min) / (max - min), -10, 0.5, -10)
                    }):Play()
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    
                    TweenService:Create(SliderKnob, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
                    }):Play()
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            SliderKnob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    
                    TweenService:Create(SliderKnob, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new((currentValue - min) / (max - min), -10, 0.5, -10)
                    }):Play()
                end
            end)
        end
        
        function TabManager:Dropdown(text, options, default, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            CreateStroke(DropdownFrame, Color3.fromRGB(45, 45, 60), 1)
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 45)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "DropdownLabel"
            DropdownLabel.Size = UDim2.new(1, -50, 0, 45)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = text .. ": " .. (default or "Select...")
            DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -35, 0, 12.5)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://6031094678"
            Arrow.ImageColor3 = Color3.fromRGB(150, 150, 180)
            Arrow.Rotation = 0
            Arrow.Parent = DropdownFrame
            
            local OptionsList = Instance.new("Frame")
            OptionsList.Name = "OptionsList"
            OptionsList.Size = UDim2.new(1, 0, 0, 0)
            OptionsList.Position = UDim2.new(0, 0, 0, 45)
            OptionsList.BackgroundTransparency = 1
            OptionsList.Parent = DropdownFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.Padding = UDim.new(0, 4)
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Parent = OptionsList
            
            local OptionsPadding = Instance.new("UIPadding")
            OptionsPadding.PaddingTop = UDim.new(0, 5)
            OptionsPadding.PaddingBottom = UDim.new(0, 5)
            OptionsPadding.PaddingLeft = UDim.new(0, 10)
            OptionsPadding.PaddingRight = UDim.new(0, 10)
            OptionsPadding.Parent = OptionsList
            
            local isOpen = false
            local currentValue = default
            
            local DropdownObject = {}
            
            function DropdownObject:Add(option)
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. option
                OptionButton.Size = UDim2.new(1, 0, 0, 32)
                OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 220)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = OptionsList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                CreateStroke(OptionButton, Color3.fromRGB(50, 50, 65), 1)
                
                OptionButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    DropdownLabel.Text = text .. ": " .. option
                    
                    isOpen = false
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 45)
                    }):Play()
                    
                    TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Rotation = 0
                    }):Play()
                    
                    task.spawn(function()
                        pcall(callback, option)
                    end)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 80, 150)
                    }):Play()
                    
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                    }):Play()
                    
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        TextColor3 = Color3.fromRGB(200, 200, 220)
                    }):Play()
                end)
            end
            
            function DropdownObject:Set(option)
                if option and option ~= "" then
                    currentValue = option
                    DropdownLabel.Text = text .. ": " .. option
                else
                    DropdownLabel.Text = text .. ": Select..."
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                local optionCount = #OptionsList:GetChildren() - 1 -- Exclude padding
                local targetHeight = isOpen and (45 + (optionCount * 36) + 10) or 45
                
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, targetHeight)
                }):Play()
                
                TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = isOpen and 180 or 0
                }):Play()
            end)
            
            -- Add all options
            for _, option in ipairs(options or {}) do
                DropdownObject:Add(option)
            end
            
            return DropdownObject
        end
        
        function TabManager:Textbox(text, clearOnFocus, callback)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "Textbox"
            TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame
            
            CreateStroke(TextboxFrame, Color3.fromRGB(45, 45, 60), 1)
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "TextboxLabel"
            TextboxLabel.Size = UDim2.new(1, -20, 0, 25)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.GothamSemibold
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local TextboxInput = Instance.new("TextBox")
            TextboxInput.Name = "TextboxInput"
            TextboxInput.Size = UDim2.new(1, -20, 0, 35)
            TextboxInput.Position = UDim2.new(0, 10, 0, 30)
            TextboxInput.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            TextboxInput.Text = ""
            TextboxInput.PlaceholderText = "Enter text..."
            TextboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
            TextboxInput.TextSize = 13
            TextboxInput.Font = Enum.Font.Gotham
            TextboxInput.BorderSizePixel = 0
            TextboxInput.ClearTextOnFocus = clearOnFocus or false
            TextboxInput.TextXAlignment = Enum.TextXAlignment.Left
            TextboxInput.Parent = TextboxFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 6)
            InputCorner.Parent = TextboxInput
            
            local InputPadding = Instance.new("UIPadding")
            InputPadding.PaddingLeft = UDim.new(0, 10)
            InputPadding.PaddingRight = UDim.new(0, 10)
            InputPadding.Parent = TextboxInput
            
            CreateStroke(TextboxInput, Color3.fromRGB(50, 50, 65), 1)
            
            TextboxInput.Focused:Connect(function()
                local stroke = TextboxInput:FindFirstChildOfClass("UIStroke")
                if stroke then
                    TweenService:Create(stroke, TweenInfo.new(0.2), {
                        Color = Color3.fromRGB(60, 120, 220),
                        Thickness = 2
                    }):Play()
                end
                
                TweenService:Create(TextboxInput, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                }):Play()
            end)
            
            TextboxInput.FocusLost:Connect(function(enterPressed)
                local stroke = TextboxInput:FindFirstChildOfClass("UIStroke")
                if stroke then
                    TweenService:Create(stroke, TweenInfo.new(0.2), {
                        Color = Color3.fromRGB(50, 50, 65),
                        Thickness = 1
                    }):Play()
                end
                
                TweenService:Create(TextboxInput, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                }):Play()
                
                if enterPressed then
                    task.spawn(function()
                        pcall(callback, TextboxInput.Text)
                    end)
                end
            end)
        end
        
        function TabManager:Line()
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Size = UDim2.new(1, 0, 0, 2)
            Line.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            Line.BorderSizePixel = 0
            Line.Parent = TabContent
            
            CreateGradient(Line, Color3.fromRGB(40, 40, 55), Color3.fromRGB(60, 60, 75), 0)
        end
        
        return TabManager
    end
    
    -- Entrance Animation
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 500),
        Position = UDim2.new(0.5, -350, 0.5, -250)
    }):Play()
    
    return WindowManager
end

return Library
