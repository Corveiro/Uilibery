--[[
    NIGHTMARE HUB LIBRARY (MODIFIED VERSION - ARCADE DESIGN)
]]

local NightmareHub = {}
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIG SAVE SYSTEM ====================
local ConfigSystem = {}
ConfigSystem.ConfigFile = "NightmareGui_Config.json"

-- Default config
ConfigSystem.DefaultConfig = {}

-- Load config dari file
function ConfigSystem:Load()
    if isfile and isfile(self.ConfigFile) then
        local success, result = pcall(function()
            local fileContent = readfile(self.ConfigFile)
            local decoded = HttpService:JSONDecode(fileContent)
            return decoded
        end)
        
        if success and result then
            print("✅ Config loaded from file!")
            return result
        else
            warn("⚠️ Failed to load config, using defaults")
            return self.DefaultConfig
        end
    else
        print("📝 No config file found, creating new one...")
        return self.DefaultConfig
    end
end

-- Save config ke file
function ConfigSystem:Save(config)
    local success, error = pcall(function()
        local encoded = HttpService:JSONEncode(config)
        writefile(self.ConfigFile, encoded)
    end)
    
    if success then
        return true
    else
        warn("❌ Failed to save config:", error)
        return false
    end
end

-- Update satu setting sahaja
function ConfigSystem:UpdateSetting(config, key, value)
    config[key] = value
    self:Save(config)
end

-- ==================== NOTIFICATION SYSTEM (FROM ARCADE) ====================
local NotificationGui = nil
local DEFAULT_NOTIFICATION_SOUND_ID = 2027986581

local function createNotificationGui()
    if NotificationGui then return end
    NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "NightmareNotificationGui"
    NotificationGui.ResetOnSpawn = false
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function NightmareHub:Notify(text, soundId)
    if not NotificationGui then createNotificationGui() end
    local soundToPlay = soundId or DEFAULT_NOTIFICATION_SOUND_ID
    if soundToPlay then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundToPlay
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 0)
    notifFrame.Position = UDim2.new(0.5, 0, 0, -100)
    notifFrame.AnchorPoint = Vector2.new(0.5, 0)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = NotificationGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notifFrame
    
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(255, 50, 50)
    outline.Thickness = 1.0
    outline.Parent = notifFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    textLabel.Font = Enum.Font.Arcade
    textLabel.TextSize = 18
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = notifFrame
    
    local targetHeight = 60
    local targetYPosition = 20
    local tweenInfoIn = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local goalIn = { Size = UDim2.new(0, 300, 0, targetHeight), Position = UDim2.new(0.5, 0, 0, targetYPosition) }
    local tweenIn = TweenService:Create(notifFrame, tweenInfoIn, goalIn)
    tweenIn:Play()
    
    task.spawn(function()
        task.wait(3)
        local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local goalOut = { Size = UDim2.new(0, 300, 0, 0), Position = UDim2.new(0.5, 0, 0, -100) }
        local tweenOut = TweenService:Create(notifFrame, tweenInfoOut, goalOut)
        tweenOut:Play()
        tweenOut.Completed:Connect(function() notifFrame:Destroy() end)
    end)
end

-- ==================== UI VARIABLES ====================
local ScreenGui
local MainFrame
local ToggleButton
local ScrollFrame
local ListLayout

-- Button states
local ButtonStates = {
    joinServer = false,
    serverHop = false,
    rejoin = false
}

-- ==================== CREATE UI ====================
function NightmareHub:CreateUI()
    -- Load config
    self.Config = ConfigSystem:Load()

    -- Cleanup
    if game.CoreGui:FindFirstChild("NightmareHubUI") then
        game.CoreGui:FindFirstChild("NightmareHubUI"):Destroy()
    end
    
    -- ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NightmareHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Toggle Button
    ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(0, 20, 0.5, -30)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Image = "rbxassetid://121996261654076"
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    ToggleButton.Parent = ScreenGui
    
    -- Main Frame (Size and Design from Arcade)
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 240, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -120, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- Styling
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 50, 50)
    mainStroke.Thickness = 1 -- Thickness from Arcade
    mainStroke.Parent = MainFrame
    
    -- Title (Design from Arcade)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 45)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "NIGHTMARE HUB"
    titleLabel.TextColor3 = Color3.fromRGB(139, 0, 0)
    titleLabel.TextSize = 16 -- Size from Arcade
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.Parent = MainFrame
    
    -- ScrollingFrame (Position and Size from Arcade)
    ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -125)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = MainFrame
    
    -- UIListLayout (From Arcade)
    ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.FillDirection = Enum.FillDirection.Vertical
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.Parent = ScrollFrame
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Social Buttons (From Arcade)
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -20, 0, 2)
    divider.Position = UDim2.new(0, 10, 1, -65)
    divider.BackgroundTransparency = 1
    divider.BorderSizePixel = 0
    divider.Parent = MainFrame

    -- TikTok Button
    local tiktokButton = Instance.new("TextButton")
    tiktokButton.Size = UDim2.new(0, 100, 0, 32)
    tiktokButton.Position = UDim2.new(0, 15, 1, -55)
    tiktokButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tiktokButton.BorderSizePixel = 0
    tiktokButton.Text = "  TikTok"
    tiktokButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tiktokButton.TextSize = 13
    tiktokButton.Font = Enum.Font.Arcade
    tiktokButton.Parent = MainFrame

    local tiktokCorner = Instance.new("UICorner")
    tiktokCorner.CornerRadius = UDim.new(0, 8)
    tiktokCorner.Parent = tiktokButton

    local tiktokIcon = Instance.new("ImageLabel")
    tiktokIcon.Size = UDim2.new(0, 18, 0, 18)
    tiktokIcon.Position = UDim2.new(0, 8, 0.5, -9)
    tiktokIcon.BackgroundTransparency = 1
    tiktokIcon.Image = "rbxassetid://70531653995908"
    tiktokIcon.Parent = tiktokButton

    tiktokButton.MouseButton1Click:Connect(function()
        setclipboard("https://www.tiktok.com/@n1ghtmare.gg?_r=1&_t=ZS-92UYqNKwMLA")
        tiktokButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        task.wait(0.2)
        tiktokButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end)

    -- Discord Button
    local discordButton = Instance.new("TextButton")
    discordButton.Size = UDim2.new(0, 100, 0, 32)
    discordButton.Position = UDim2.new(0, 125, 1, -55)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.BorderSizePixel = 0
    discordButton.Text = "  Discord"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 13
    discordButton.Font = Enum.Font.Arcade
    discordButton.Parent = MainFrame

    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordButton

    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Size = UDim2.new(0, 16, 0, 16)
    discordIcon.Position = UDim2.new(0, 9, 0.5, -8)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = "rbxassetid://131585302403438"
    discordIcon.Parent = discordButton

    discordButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/V4a7BbH5")
        discordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        task.wait(0.2)
        discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)

    -- Toggle button functionality
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    createNotificationGui()
    print("✅ UI Created Successfully!")
end

-- ==================== HELPER FUNCTIONS ====================
function NightmareHub:CreateToggleButton(text, configKey, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 210, 0, 32) -- Size from Arcade
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = text
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 13 -- Size from Arcade
    toggleBtn.Font = Enum.Font.Arcade
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Parent = toggleBtn

    -- Load initial state
    local isToggled = self.Config[configKey] or false
    if isToggled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    end

    if callback then callback(isToggled) end
    
    toggleBtn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
        ConfigSystem:UpdateSetting(self.Config, configKey, isToggled)
        if callback then callback(isToggled) end
    end)
    
    return toggleBtn
end

function NightmareHub:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 210, 0, 32) -- Size from Arcade
    button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13 -- Size from Arcade
    button.Font = Enum.Font.Arcade
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if callback then callback(button) end
    end)
    
    return button
end

function NightmareHub:CreateSection(text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundTransparency = 1
    section.Text = "━━ " .. text .. " ━━"
    section.TextColor3 = Color3.fromRGB(255, 50, 50)
    section.TextSize = 12
    section.Font = Enum.Font.Arcade
    
    return section
end

function NightmareHub:CreateTextBox(placeholderText)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 210, 0, 32) -- Size from Arcade
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = placeholderText or ""
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 13 -- Size from Arcade
    textBox.Font = Enum.Font.Arcade
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Center
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 8)
    textBoxCorner.Parent = textBox
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Color3.fromRGB(255, 50, 50)
    textBoxStroke.Thickness = 1
    textBoxStroke.Parent = textBox
    
    return textBox
end

-- ==================== ELEMENT ADDING FUNCTIONS (NO TABS) ====================
function NightmareHub:AddToggle(text, callback)
    local configKey = "Nightmare_" .. text
    local toggle = self:CreateToggleButton(text, configKey, callback)
    toggle.Parent = ScrollFrame
    return toggle
end

function NightmareHub:AddButton(text, callback)
    local button = self:CreateButton(text, callback)
    button.Parent = ScrollFrame
    return button
end

function NightmareHub:AddTextBox(placeholder, callback)
    local textBox = self:CreateTextBox(placeholder)
    textBox.Parent = ScrollFrame
    textBox.FocusLost:Connect(function(enterPressed)
        if callback then callback(textBox.Text, enterPressed) end
    end)
    return textBox
end

function NightmareHub:AddSection(text)
    local section = self:CreateSection(text)
    section.Parent = ScrollFrame
    return section
end

-- ==================== DISCORD & SERVER UTILITIES ====================
function NightmareHub:AddServerUtilities()
    self:AddSection("SERVER")
    
    local jobIdInput = self:CreateTextBox("Input Job Id")
    jobIdInput.Parent = ScrollFrame
    
    self:AddButton("Join Server", function(button)
        if ButtonStates.joinServer then return end
        local jobId = jobIdInput.Text:gsub("%s+", "")
        if jobId == "" then
            button.Text = "ENTER JOB ID!"
            task.wait(1.5)
            button.Text = "Join Server"
            return
        end
        ButtonStates.joinServer = true
        button.Text = "JOINING..."
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer) end)
        ButtonStates.joinServer = false
    end)
    
    self:AddButton("Copy Current Job ID", function(button)
        local currentJobId = game.JobId
        if currentJobId and currentJobId ~= "" then
            setclipboard(currentJobId)
            button.Text = "COPIED!"
            task.wait(2)
            button.Text = "Copy Current Job ID"
        end
    end)
    
    self:AddButton("Server Hop", function(button)
        if ButtonStates.serverHop then return end
        ButtonStates.serverHop = true
        button.Text = "SEARCHING..."
        task.spawn(function()
            local servers = {}
            local cursor = ""
            repeat
                local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s", game.PlaceId, cursor)
                local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
                if success and result and result.data then
                    for _, server in ipairs(result.data) do
                        if server.id ~= game.JobId and server.playing < server.maxPlayers then table.insert(servers, server.id) end
                    end
                    cursor = result.nextPageCursor or ""
                else break end
            until cursor == "" or #servers > 20
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            end
            button.Text = "Server Hop"
            ButtonStates.serverHop = false
        end)
    end)
    
    self:AddButton("Rejoin Server", function(button)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

return NightmareHub
