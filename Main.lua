local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Protect GUI Function
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

-- Main Window Creation
function Library:CreateWindow()
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CokkaHubUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        ProtectGui(ScreenGui)
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = CoreGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 10)
    TopBarCorner.Parent = TopBar
    
    -- Fix for corner overlap
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Cokka Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -50)
    TabContainer.Position = UDim2.new(0, 5, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingRight = UDim.new(0, 5)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -155, 1, -50)
    ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Window Object
    local WindowObject = {}
    WindowObject.Tabs = {}
    
    -- Tab Function
    function WindowObject:Tab(name)
        local TabObject = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.Gotham
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content (ScrollingFrame)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 5)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingBottom = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        -- Tab Click
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(WindowObject.Tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                tab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 80, 150)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
        end)
        
        TabObject.Button = TabButton
        TabObject.Content = TabContent
        
        table.insert(WindowObject.Tabs, TabObject)
        
        -- Auto select first tab
        if #WindowObject.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 80, 150)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
        end
        
        -- ═════════════════════════════════════════════════
        --                 ELEMENT FUNCTIONS
        -- ═════════════════════════════════════════════════
        
        -- Label
        function TabObject:Label(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, 0, 0, 28)
            LabelFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = LabelFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 240)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame
            
            local LabelObject = {}
            function LabelObject:Set(newText)
                Label.Text = tostring(newText)
            end
            
            return LabelObject
        end
        
        -- Label1 (alias for Label)
        function TabObject:Label1(text)
            return TabObject:Label(text)
        end
        
        -- Button
        function TabObject:Button(text, callback)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
            ButtonFrame.Text = text
            ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonFrame.TextSize = 14
            ButtonFrame.Font = Enum.Font.GothamBold
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end
        
        -- Toggle
        function TabObject:Toggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextWrapped = true
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(80, 80, 80)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(80, 80, 80)
                ToggleCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                
                pcall(callback, toggled)
            end)
        end
        
        -- Slider
        function TabObject:Slider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -60, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 45, 0, 20)
            SliderValue.Position = UDim2.new(1, -50, 0, 5)
            SliderValue.BackgroundColor3 = Color3.fromRGB(40, 80, 150)
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 12
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.BorderSizePixel = 0
            SliderValue.Parent = SliderFrame
            
            local ValueCorner = Instance.new("UICorner")
            ValueCorner.CornerRadius = UDim.new(0, 4)
            ValueCorner.Parent = SliderValue
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local dragging = false
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * sizeX)
                
                SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                SliderValue.Text = tostring(value)
                pcall(callback, value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
        end
        
        -- Dropdown
        function TabObject:Dropdown(text, options, default, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -40, 0, 35)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = text .. ": " .. (default or "")
            DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 35)
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            Arrow.TextSize = 10
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Parent = DropdownFrame
            
            local OptionsList = Instance.new("Frame")
            OptionsList.Size = UDim2.new(1, 0, 0, 0)
            OptionsList.Position = UDim2.new(0, 0, 0, 35)
            OptionsList.BackgroundTransparency = 1
            OptionsList.Parent = DropdownFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Parent = OptionsList
            
            local isOpen = false
            local currentValue = default
            
            local DropdownObject = {}
            
            function DropdownObject:Add(option)
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, -10, 0, 28)
                OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 220)
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = OptionsList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    DropdownLabel.Text = text .. ": " .. option
                    isOpen = false
                    
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                    Arrow.Rotation = 0
                    
                    pcall(callback, option)
                end)
            end
            
            function DropdownObject:Set(option)
                if option and option ~= "" then
                    currentValue = option
                    DropdownLabel.Text = text .. ": " .. option
                else
                    DropdownLabel.Text = text
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                local optionCount = #OptionsList:GetChildren() - 1
                local targetSize = isOpen and UDim2.new(1, 0, 0, 35 + (optionCount * 30)) or UDim2.new(1, 0, 0, 35)
                
                DropdownFrame.Size = targetSize
                Arrow.Rotation = isOpen and 180 or 0
            end)
            
            for _, option in ipairs(options) do
                DropdownObject:Add(option)
            end
            
            return DropdownObject
        end
        
        -- Textbox
        function TabObject:Textbox(text, clearOnFocus, callback)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -15, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
            TextboxLabel.TextSize = 13
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -20, 0, 30)
            Textbox.Position = UDim2.new(0, 10, 0, 25)
            Textbox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            Textbox.Text = ""
            Textbox.PlaceholderText = "Enter text..."
            Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Textbox.TextSize = 12
            Textbox.Font = Enum.Font.Gotham
            Textbox.BorderSizePixel = 0
            Textbox.ClearTextOnFocus = clearOnFocus
            Textbox.Parent = TextboxFrame
            
            local TextboxCorner2 = Instance.new("UICorner")
            TextboxCorner2.CornerRadius = UDim.new(0, 4)
            TextboxCorner2.Parent = Textbox
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    pcall(callback, Textbox.Text)
                end
            end)
        end
        
        -- Line
        function TabObject:Line()
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, 0, 0, 2)
            Line.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            Line.BorderSizePixel = 0
            Line.Parent = TabContent
        end
        
        return TabObject
    end
    
    return WindowObject
end

return Library
