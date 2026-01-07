--[[
    NIGHTMARE HUB LIBRARY (FINAL DEBUG VERSION + CONFIG SYSTEM)
    REMODELED UI DESIGN v2 — compact + animations + visual polish
    - Interface menor
    - Animações de abrir/fechar (TweenService)
    - Hover nas abas e micro-feedback nos botões
    - Fade/slide-in ao trocar de tab
    Mantive toda a lógica, nomes e funções de criação (não quebrei nada).
]]

local NightmareHub = {}
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIG SAVE SYSTEM ====================
local ConfigSystem = {}
ConfigSystem.ConfigFile = "NightmareGui_Config.json"

-- Default config (kosong, kerana config akan dibuat secara dinamik)
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
        -- print("💾 Config saved!") -- Uncomment untuk debug
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
    -- print("🔄 Updated setting:", key, "=", value) -- Uncomment untuk debug
end

-- ==================== UI VARIABLES ====================
local ScreenGui
local MainFrame
local ToggleButton
local TabButtons = {}
local ScrollFrame
local TabContent = {}
local CurrentTab = "Main"

-- Button states
local ButtonStates = {
    joinServer = false,
    serverHop = false,
    rejoin = false
}

-- Animation presets
local tweenInfoFast = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoMed  = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoSlow = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Helper to tween Color3 (TweenService needs a goal table)
local function TweenProperty(instance, props, info)
    info = info or tweenInfoMed
    local suc, tween = pcall(function()
        return TweenService:Create(instance, info, props)
    end)
    if suc and tween then
        tween:Play()
        return tween
    end
    return nil
end

-- ==================== CREATE UI ====================
function NightmareHub:CreateUI()
    -- Load config awal-awal
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
    
    -- Toggle Button (pequeno botão flutuante)
    ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 48, 0, 48)
    ToggleButton.Position = UDim2.new(0, 18, 0.5, -24)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Image = "rbxassetid://121996261654076"
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    ToggleButton.Parent = ScreenGui

    -- Subtle hover feedback for toggle
    ToggleButton.MouseEnter:Connect(function()
        TweenProperty(ToggleButton, {Size = UDim2.new(0, 52, 0, 52)}, tweenInfoFast)
    end)
    ToggleButton.MouseLeave:Connect(function()
        TweenProperty(ToggleButton, {Size = UDim2.new(0, 48, 0, 48)}, tweenInfoFast)
    end)
    
    -- Main Frame (COMPACT)
    local targetSize = UDim2.new(0, 420, 0, 340) -- menor
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 20, 0, 20) -- start tiny for animation
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- Shadow / drop behind main
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.Position = UDim2.new(0, -6, 0, -6)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = MainFrame.ZIndex - 1
    shadow.BorderSizePixel = 0
    shadow.Parent = MainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 20)
    shadowCorner.Parent = shadow
    
    -- Styling
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 50, 50)
    mainStroke.Thickness = 1.6
    mainStroke.Parent = MainFrame
    
    -- Accent strip (thin)
    local accentStrip = Instance.new("Frame")
    accentStrip.Size = UDim2.new(0, 6, 1, 0)
    accentStrip.Position = UDim2.new(0, 0, 0, 0)
    accentStrip.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    accentStrip.BorderSizePixel = 0
    accentStrip.Parent = MainFrame
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 16)
    accentCorner.Parent = accentStrip
    
    -- Title area (top compact)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, -12, 0, 40)
    titleBar.Position = UDim2.new(0, 12, 0, 8)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = MainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "NIGHTMARE HUB"
    titleLabel.TextColor3 = Color3.fromRGB(139, 0, 0)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 100, 1, 0)
    subtitle.Position = UDim2.new(1, -100, 0, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "COMPACT"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Right
    subtitle.Parent = titleBar
    
    -- Close Button (compact)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.Arcade
    closeBtn.Parent = MainFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    local closeBtnStroke = Instance.new("UIStroke")
    closeBtnStroke.Color = Color3.fromRGB(255, 50, 50)
    closeBtnStroke.Thickness = 1
    closeBtnStroke.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        -- animated close
        if MainFrame:GetAttribute("Busy") then return end
        MainFrame:SetAttribute("Busy", true)
        local shrink = TweenProperty(MainFrame, {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 0.6}, tweenInfoSlow)
        if shrink then shrink.Completed:Wait() end
        MainFrame.Visible = false
        MainFrame:SetAttribute("Busy", false)
    end)
    
    -- Sidebar (vertical tabs compact)
    local sideBar = Instance.new("Frame")
    sideBar.Size = UDim2.new(0, 100, 1, -78)
    sideBar.Position = UDim2.new(0, 12, 0, 56)
    sideBar.BackgroundTransparency = 1
    sideBar.Parent = MainFrame
    
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 12)
    sideCorner.Parent = sideBar
    
    local sideStroke = Instance.new("UIStroke")
    sideStroke.Color = Color3.fromRGB(50, 0, 0)
    sideStroke.Thickness = 1
    sideStroke.Parent = sideBar
    
    -- Vertical layout for sidebar tabs
    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 8)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sideBar
    
    -- Content Frame (to the right of the sidebar)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -140, 1, -78)
    contentFrame.Position = UDim2.new(0, 132, 0, 56)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = MainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 12)
    contentCorner.Parent = contentFrame
    
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(60, 0, 0)
    contentStroke.Thickness = 1
    contentStroke.Parent = contentFrame
    
    -- ScrollingFrame (conteúdo)
    ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -20)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 10)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = contentFrame
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = ScrollFrame
    
    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 18)
    end)
    
    -- Initialize tab content
    local tabs = {"Main", "Visual", "Misc", "Discord"}
    for _, tabName in ipairs(tabs) do
        TabContent[tabName] = {}
    end
    
    -- Create sidebar tab buttons (vertical style) BUT keep TabButtons structure
    for i, tabName in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabName
        tabBtn.Size = UDim2.new(1, -12, 0, 40)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.TextSize = 13
        tabBtn.Font = Enum.Font.Arcade
        tabBtn.Parent = sideBar
        
        local iconPadding = Instance.new("UIPadding")
        iconPadding.PaddingLeft = UDim.new(0, 8)
        iconPadding.Parent = tabBtn
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabBtn
        
        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = Color3.fromRGB(100, 0, 0)
        tabStroke.Thickness = 1
        tabStroke.Parent = tabBtn
        
        TabButtons[tabName] = {button = tabBtn, stroke = tabStroke}
        
        -- Hover animations for tab buttons
        tabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= tabName then
                TweenProperty(tabBtn, {BackgroundColor3 = Color3.fromRGB(120, 15, 15)}, tweenInfoFast)
                TweenProperty(tabStroke, {Color = Color3.fromRGB(180, 40, 40)}, tweenInfoFast)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= tabName then
                TweenProperty(tabBtn, {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}, tweenInfoFast)
                TweenProperty(tabStroke, {Color = Color3.fromRGB(100, 0, 0)}, tweenInfoFast)
            end
        end)
        
        tabBtn.MouseButton1Click:Connect(function()
            self:SwitchTab(tabName)
        end)
    end
    
    -- Initialize tab content for Discord & others (same as before)
    self:SetupDiscordTab()
    
    -- Toggle button functionality (animated open/close)
    ToggleButton.MouseButton1Click:Connect(function()
        if MainFrame:GetAttribute("Busy") then return end
        MainFrame:SetAttribute("Busy", true)
        if not MainFrame.Visible then
            MainFrame.Visible = true
            -- expand with tween and subtle bounce
            TweenProperty(MainFrame, {Size = targetSize, BackgroundTransparency = 0.05}, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
            -- fade in children quickly
            task.delay(0.18, function()
                for _, items in pairs(TabContent) do
                    for _, item in ipairs(items) do
                        pcall(function()
                            if item:IsA("GuiObject") then
                                item.BackgroundTransparency = item.BackgroundTransparency or 1
                                item.TextTransparency = item.TextTransparency or 0
                                TweenProperty(item, {BackgroundTransparency = 0}, tweenInfoFast)
                            end
                        end)
                    end
                end
            end)
            task.delay(0.42, function() MainFrame:SetAttribute("Busy", false) end)
        else
            -- shrink and hide after animation
            TweenProperty(MainFrame, {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 0.6}, tweenInfoSlow)
            task.delay(0.36, function()
                MainFrame.Visible = false
                MainFrame:SetAttribute("Busy", false)
            end)
        end
    end)
    
    -- Set default tab
    self:SwitchTab("Main")
    
    print("✅ UI Created Successfully! (Compact + animations)")
end

-- ==================== HELPER FUNCTIONS ====================
function NightmareHub:CreateToggleButton(text, configKey, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -10, 0, 34)
    -- Fundo padrão: cinza
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = text
    -- Texto padrão: branco
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.Arcade
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    local btnStroke = Instance.new("UIStroke")
    -- Borda padrão: branca e fina
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 0.8
    btnStroke.Parent = toggleBtn

    -- Muat status awal dari config
    local isToggled = self.Config[configKey] or false
    if isToggled then
        -- Quando ativado: texto e borda ficam vermelhas
        toggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        btnStroke.Color = Color3.fromRGB(255, 50, 50)
    end

    -- Panggil callback sekali pada permulaan untuk memuat fungsi
    if callback then callback(isToggled) end
    
    toggleBtn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        -- Mantemos o fundo cinza; apenas alteramos texto e borda conforme pedido
        if isToggled then
            TweenProperty(toggleBtn, {TextColor3 = Color3.fromRGB(255, 50, 50)}, tweenInfoFast)
            TweenProperty(btnStroke, {Color = Color3.fromRGB(255, 50, 50)}, tweenInfoFast)
        else
            TweenProperty(toggleBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, tweenInfoFast)
            TweenProperty(btnStroke, {Color = Color3.fromRGB(255, 255, 255)}, tweenInfoFast)
        end
        
        -- Simpan status baru ke config
        ConfigSystem:UpdateSetting(self.Config, configKey, isToggled)
        
        if callback then callback(isToggled) end
    end)
    
    -- hover micro feedback: escurecer/levar a tona levemente o fundo, manter borda conforme estado
    toggleBtn.MouseEnter:Connect(function()
        TweenProperty(toggleBtn, {BackgroundColor3 = Color3.fromRGB(75, 75, 75)}, tweenInfoFast)
    end)
    toggleBtn.MouseLeave:Connect(function()
        local bg = Color3.fromRGB(60, 60, 60)
        TweenProperty(toggleBtn, {BackgroundColor3 = bg}, tweenInfoFast)
        -- garantir que a cor da borda reflete o estado atual
        local strokeColor = (self.Config[configKey] and Color3.fromRGB(255,50,50)) or Color3.fromRGB(255,255,255)
        TweenProperty(btnStroke, {Color = strokeColor}, tweenInfoFast)
        local textColor = (self.Config[configKey] and Color3.fromRGB(255,50,50)) or Color3.fromRGB(255,255,255)
        TweenProperty(toggleBtn, {TextColor3 = textColor}, tweenInfoFast)
    end)
    
    return toggleBtn
end

function NightmareHub:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 34)
    button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Arcade
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Parent = button
    
    button.MouseButton1Click:Connect(function()
        print("🔘 BUTTON CLICKED:", text)
        -- click feedback
        TweenProperty(button, {BackgroundColor3 = Color3.fromRGB(0,100,200)}, tweenInfoFast)
        task.delay(0.12, function()
            TweenProperty(button, {BackgroundColor3 = Color3.fromRGB(80,0,0)}, tweenInfoFast)
        end)
        if callback then 
            callback(button) 
        end
    end)
    
    -- hover micro feedback
    button.MouseEnter:Connect(function()
        TweenProperty(button, {BackgroundColor3 = Color3.fromRGB(120, 10, 10)}, tweenInfoFast)
    end)
    button.MouseLeave:Connect(function()
        TweenProperty(button, {BackgroundColor3 = Color3.fromRGB(80, 0, 0)}, tweenInfoFast)
    end)
    
    return button
end

function NightmareHub:CreateSection(text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 22)
    section.BackgroundTransparency = 1
    section.Text = "━━ " .. text .. " ━━"
    section.TextColor3 = Color3.fromRGB(255, 50, 50)
    section.TextSize = 12
    section.Font = Enum.Font.Arcade
    
    return section
end

function NightmareHub:CreateTextBox(placeholderText)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 0, 34)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = placeholderText or ""
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Arcade
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextTruncate = Enum.TextTruncate.AtEnd
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 10)
    inputPadding.PaddingRight = UDim.new(0, 10)
    inputPadding.Parent = textBox
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 8)
    textBoxCorner.Parent = textBox
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Color3.fromRGB(0, 0, 0)
    textBoxStroke.Thickness = 0.5
    textBoxStroke.Parent = textBox
    
    -- focus highlight
    textBox.Focused:Connect(function()
        TweenProperty(textBox, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, tweenInfoFast)
    end)
    textBox.FocusLost:Connect(function()
        TweenProperty(textBox, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, tweenInfoFast)
    end)
    
    return textBox
end

-- ==================== DYNAMIC TAB FUNCTIONS ====================
function NightmareHub:AddMainToggle(text, callback)
    local configKey = "Main_" .. text
    local toggle = self:CreateToggleButton(text, configKey, callback)
    table.insert(TabContent["Main"], toggle)
    toggle.Parent = ScrollFrame
    toggle.Visible = (CurrentTab == "Main")
    return toggle
end

function NightmareHub:AddVisualToggle(text, callback)
    local configKey = "Visual_" .. text
    local toggle = self:CreateToggleButton(text, configKey, callback)
    table.insert(TabContent["Visual"], toggle)
    toggle.Parent = ScrollFrame
    toggle.Visible = (CurrentTab == "Visual")
    return toggle
end

function NightmareHub:AddMiscToggle(text, callback)
    local configKey = "Misc_" .. text
    local toggle = self:CreateToggleButton(text, configKey, callback)
    table.insert(TabContent["Misc"], toggle)
    toggle.Parent = ScrollFrame
    toggle.Visible = (CurrentTab == "Misc")
    return toggle
end

-- ==================== DISCORD TAB (FINAL DEBUG VERSION + CONFIG) ====================
function NightmareHub:SetupDiscordTab()
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChild("Terrain")
    print("🔧 DEBUG: Starting SetupDiscordTab...")

    -- Social Section
    local socialSection = self:CreateSection("SOCIAL")
    table.insert(TabContent["Discord"], socialSection)
    socialSection.Parent = ScrollFrame
    socialSection.Visible = false
    
    -- TIKTOK BUTTON (Button Biasa, tidak di-save)
    local tiktokBtn = self:CreateButton("Tiktok", function(button)
        print("🔥 Tiktok clicked")
        setclipboard("https://www.tiktok.com/@n1ghtmare.gg?_r=1&_t=ZS-91TYDcuhlRQ")
        button.Text = "COPIED!"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(2)
        button.Text = "Tiktok"
        button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)
    table.insert(TabContent["Discord"], tiktokBtn)
    tiktokBtn.Parent = ScrollFrame
    tiktokBtn.Visible = false
    
    -- DISCORD BUTTON (Button Biasa, tidak di-save)
    local discordBtn = self:CreateButton("Discord", function(button)
        print("🔥 Discord clicked")
        setclipboard("https://discord.gg/Bcdt9nXV")
        button.Text = "COPIED!"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(2)
        button.Text = "Discord"
        button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)
    table.insert(TabContent["Discord"], discordBtn)
    discordBtn.Parent = ScrollFrame
    discordBtn.Visible = false
    
    -- Server Section
    local serverSection = self:CreateSection("SERVER")
    table.insert(TabContent["Discord"], serverSection)
    serverSection.Parent = ScrollFrame
    serverSection.Visible = false
    
    -- Job ID Input
    local jobIdInput = self:CreateTextBox("Input Job Id")
    table.insert(TabContent["Discord"], jobIdInput)
    jobIdInput.Parent = ScrollFrame
    jobIdInput.Visible = false
    
    -- JOIN SERVER BUTTON (Button Biasa, tidak di-save)
    local joinServerBtn = self:CreateButton("Join Server", function(button)
        if ButtonStates.joinServer then return end
        
        local jobId = jobIdInput.Text:gsub("%s+", "")
        
        if jobId == "" then
            button.Text = "ENTER JOB ID!"
            button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(1.5)
            button.Text = "Join Server"
            button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            return
        end
        
        ButtonStates.joinServer = true
        button.Text = "JOINING..."
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        local success, errorMsg = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        end)
        
        if not success then
            warn("Join Server failed: " .. tostring(errorMsg))
            button.Text = "FAILED!"
            button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(2)
            button.Text = "Join Server"
            button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
        
        ButtonStates.joinServer = false
    end)
    table.insert(TabContent["Discord"], joinServerBtn)
    joinServerBtn.Parent = ScrollFrame
    joinServerBtn.Visible = false
    
    -- COPY JOB ID BUTTON (Button Biasa, tidak di-save)
    local copyJobIdBtn = self:CreateButton("Copy Current Job ID", function(button)
        print("🔥 Copy Job ID clicked")
        local currentJobId = game.JobId
        if currentJobId and currentJobId ~= "" then
            setclipboard(currentJobId)
            button.Text = "COPIED: " .. currentJobId:sub(1, 8) .. "..."
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.wait(2)
            button.Text = "Copy Current Job ID"
            button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        else
            button.Text = "NO JOB ID!"
            button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(1)
            button.Text = "Copy Current Job ID"
            button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
    end)
    table.insert(TabContent["Discord"], copyJobIdBtn)
    copyJobIdBtn.Parent = ScrollFrame
    copyJobIdBtn.Visible = false
    
    -- SERVER HOP BUTTON (Button Biasa, tidak di-save)
    local serverHopBtn = self:CreateButton("Server Hop", function(button)
        if ButtonStates.serverHop then return end
        
        ButtonStates.serverHop = true
        button.Text = "SEARCHING..."
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        task.spawn(function(btnRef)
            local servers = {}
            local cursor = ""
            
            repeat
                local url = string.format(
                    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
                    game.PlaceId,
                    cursor
                )
                
                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)
                
                if success and result and result.data then
                    for _, server in ipairs(result.data) do
                        if server.id ~= game.JobId and server.playing < server.maxPlayers and server.maxPlayers > 0 then
                            table.insert(servers, server.id)
                        end
                    end
                    cursor = result.nextPageCursor or ""
                else
                    break
                end
            until cursor == "" or #servers > 20
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                local tpSuccess = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
                end)
                
                if not tpSuccess then
                    btnRef.Text = "FAILED!"
                    btnRef.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    task.wait(2)
                end
            else
                btnRef.Text = "NO SERVERS!"
                btnRef.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                task.wait(2)
            end
            
            btnRef.Text = "Server Hop"
            btnRef.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            ButtonStates.serverHop = false
        end, button)
    end)
    table.insert(TabContent["Discord"], serverHopBtn)
    serverHopBtn.Parent = ScrollFrame
    serverHopBtn.Visible = false
    
    -- REJOIN BUTTON (Button Biasa, tidak di-save)
    local rejoinBtn = self:CreateButton("Rejoin Server", function(button)
        if ButtonStates.rejoin then return end
        
        ButtonStates.rejoin = true
        button.Text = "REJOINING..."
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        local success, errorMsg = pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
        
        if not success then
            warn("Rejoin failed: " .. tostring(errorMsg))
            button.Text = "FAILED!"
            button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(2)
            button.Text = "Rejoin Server"
            button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
        
        ButtonStates.rejoin = false
    end)
    table.insert(TabContent["Discord"], rejoinBtn)
    rejoinBtn.Parent = ScrollFrame
    rejoinBtn.Visible = false
    
    -- Utility Section
    local utilitySection = self:CreateSection("UTILITY")
    table.insert(TabContent["Discord"], utilitySection)
    utilitySection.Parent = ScrollFrame
    utilitySection.Visible = false
    
    -- DYNAMIC ISLAND TOGGLE (Toggle dengan Config)
    print("🔧 DEBUG: Creating Dynamic Island...")
    local dynamicIslandGui = nil
    
    local function createDynamicIsland()
        if game.CoreGui:FindFirstChild("DynamicIslandGUI") then
            game.CoreGui:FindFirstChild("DynamicIslandGUI"):Destroy()
        end
        
        local diScreenGui = Instance.new("ScreenGui")
        diScreenGui.Name = "DynamicIslandGUI"
        diScreenGui.Parent = game.CoreGui
        diScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        diScreenGui.ResetOnSpawn = false
        
        local dynamicIsland = Instance.new("Frame")
        dynamicIsland.Name = "DynamicIsland"
        dynamicIsland.Size = UDim2.new(0, 400, 0, 70)
        dynamicIsland.Position = UDim2.new(0.5, -200, 0, 10)
        dynamicIsland.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        dynamicIsland.BorderSizePixel = 0
        dynamicIsland.Parent = diScreenGui
        dynamicIsland.Active = true
        
        local islandCorner = Instance.new("UICorner")
        islandCorner.CornerRadius = UDim.new(0, 35)
        islandCorner.Parent = dynamicIsland
        
        local islandStroke = Instance.new("UIStroke")
        islandStroke.Color = Color3.fromRGB(40, 40, 40)
        islandStroke.Thickness = 1
        islandStroke.Transparency = 0.5
        islandStroke.Parent = dynamicIsland
        
        -- Avatar Container
        local avatarContainer = Instance.new("Frame")
        avatarContainer.Name = "AvatarContainer"
        avatarContainer.Size = UDim2.new(0, 55, 0, 55)
        avatarContainer.Position = UDim2.new(0, 8, 0.5, -27.5)
        avatarContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        avatarContainer.BorderSizePixel = 0
        avatarContainer.Parent = dynamicIsland
        
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatarContainer
        
        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Name = "Avatar"
        avatarImage.Size = UDim2.new(1, -4, 1, -4)
        avatarImage.Position = UDim2.new(0, 2, 0, 2)
        avatarImage.BackgroundTransparency = 1
        avatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatarImage.Parent = avatarContainer
        
        local avatarImgCorner = Instance.new("UICorner")
        avatarImgCorner.CornerRadius = UDim.new(1, 0)
        avatarImgCorner.Parent = avatarImage
        
        -- Info Container
        local infoContainer = Instance.new("Frame")
        infoContainer.Name = "InfoContainer"
        infoContainer.Size = UDim2.new(1, -260, 1, 0)
        infoContainer.Position = UDim2.new(0, 70, 0, 0)
        infoContainer.BackgroundTransparency = 1
        infoContainer.Parent = dynamicIsland
        
        local usernameLabel = Instance.new("TextLabel")
        usernameLabel.Name = "Username"
        usernameLabel.Size = UDim2.new(1, 0, 0, 18)
        usernameLabel.Position = UDim2.new(0, 0, 0, 8)
        usernameLabel.BackgroundTransparency = 1
        usernameLabel.Text = "@" .. LocalPlayer.Name
        usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        usernameLabel.Font = Enum.Font.GothamBold
        usernameLabel.TextSize = 15
        usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
        usernameLabel.Parent = infoContainer
        
        -- Stats Container
        local statsContainer = Instance.new("Frame")
        statsContainer.Name = "StatsContainer"
        statsContainer.Size = UDim2.new(1, 0, 0, 22)
        statsContainer.Position = UDim2.new(0, 0, 1, -27)
        statsContainer.BackgroundTransparency = 1
        statsContainer.Parent = infoContainer
        
        -- FPS Container
        local fpsContainer = Instance.new("Frame")
        fpsContainer.Name = "FPS"
        fpsContainer.Size = UDim2.new(0.33, -2, 1, 0)
        fpsContainer.Position = UDim2.new(0, 0, 0, 0)
        fpsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        fpsContainer.BorderSizePixel = 0
        fpsContainer.Parent = statsContainer
        
        local fpsCorner = Instance.new("UICorner")
        fpsCorner.CornerRadius = UDim.new(0, 8)
        fpsCorner.Parent = fpsContainer
        
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSValue"
        fpsLabel.Size = UDim2.new(1, 0, 1, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.Text = "60"
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        fpsLabel.Font = Enum.Font.GothamBold
        fpsLabel.TextSize = 11
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
        fpsLabel.Parent = fpsContainer
        
        -- Ping Container
        local pingContainer = Instance.new("Frame")
        pingContainer.Name = "Ping"
        pingContainer.Size = UDim2.new(0.33, 1, 1, 0)
        pingContainer.Position = UDim2.new(0.33, 1, 0, 0)
        pingContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        pingContainer.BorderSizePixel = 0
        pingContainer.Parent = statsContainer
        
        local pingCorner = Instance.new("UICorner")
        pingCorner.CornerRadius = UDim.new(0, 8)
        pingCorner.Parent = pingContainer
        
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingValue"
        pingLabel.Size = UDim2.new(1, 0, 1, 0)
        pingLabel.BackgroundTransparency = 1
        pingLabel.Text = "0ms"
        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        pingLabel.Font = Enum.Font.GothamBold
        pingLabel.TextSize = 11
        pingLabel.TextXAlignment = Enum.TextXAlignment.Center
        pingLabel.Parent = pingContainer
        
        -- Time Container
        local timeContainer = Instance.new("Frame")
        timeContainer.Name = "Time"
        timeContainer.Size = UDim2.new(0.33, 2, 1, 0)
        timeContainer.Position = UDim2.new(0.66, 5, 0, 0)
        timeContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        timeContainer.BorderSizePixel = 0
        timeContainer.Parent = statsContainer
        
        local timeCorner = Instance.new("UICorner")
        timeCorner.CornerRadius = UDim.new(0, 8)
        timeCorner.Parent = timeContainer
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Name = "TimeValue"
        timeLabel.Size = UDim2.new(1, 0, 1, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = "00:00"
        timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.TextSize = 11
        timeLabel.TextXAlignment = Enum.TextXAlignment.Center
        timeLabel.Parent = timeContainer
        
        -- Draggable functionality
        local dragging = false
        local dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            dynamicIsland.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        dynamicIsland.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = dynamicIsland.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        dynamicIsland.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
        
        -- FPS Counter
        local lastTime = tick()
        local frameCount = 0
        local fps = 60
        
        game:GetService("RunService").RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local currentTime = tick()
            
            if currentTime - lastTime >= 1 then
                fps = frameCount
                frameCount = 0
                lastTime = currentTime
                
                fpsLabel.Text = tostring(fps)
                
                if fps >= 55 then
                    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif fps >= 30 then
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
        
        -- Ping Counter
        spawn(function()
            while wait(2) do
                local success, ping = pcall(function()
                    return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                
                if success then
                    local pingValue = math.floor(ping)
                    pingLabel.Text = pingValue .. "ms"
                    
                    if pingValue <= 100 then
                        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif pingValue <= 200 then
                        pingLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        pingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end)
        
        -- Time Update
        spawn(function()
            while wait(1) do
                local time = os.date("*t")
                timeLabel.Text = string.format("%02d:%02d", time.hour, time.min)
            end
        end)
        
        return diScreenGui
    end
    
    local dynamicIslandBtn = self:CreateToggleButton("Dynamic Island", "Discord_Dynamic Island", function(state)
        if state then
            print("✅ Dynamic Island ON")
            dynamicIslandGui = createDynamicIsland()
        else
            print("❌ Dynamic Island OFF")
            if dynamicIslandGui then
                dynamicIslandGui:Destroy()
                dynamicIslandGui = nil
            end
            if game.CoreGui:FindFirstChild("DynamicIslandGUI") then
                game.CoreGui:FindFirstChild("DynamicIslandGUI"):Destroy()
            end
        end
    end)
    table.insert(TabContent["Discord"], dynamicIslandBtn)
    dynamicIslandBtn.Parent = ScrollFrame
    dynamicIslandBtn.Visible = false
    print("🔧 DEBUG: Dynamic Island button created and added.")
    
    -- FPS BOOSTER TOGGLE (Toggle dengan Config)
    print("🔧 DEBUG: Creating FPS Booster...")
    local function removeTextures()
        print("🔧 Removing textures...")
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then
                obj.Transparency = 1
            elseif obj:IsA("MeshPart") then
                obj.TextureID = ""
            end
        end
    end

    local function removeParticles()
        print("🔧 Removing particles...")
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
        end
    end

    local function applyLowGraphics()
        print("🔧 Applying low graphics settings...")
        
        if Lighting then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 0
            
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or 
                   effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") then
                    effect.Enabled = false
                end
            end
        end
        
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
        end
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
    
    local fpsBoosterBtn = self:CreateToggleButton("FPS Booster", "Discord_FPS Booster", function(state)
        if state then
            print("✅ FPS Booster ON")
            removeTextures()
            removeParticles()
            applyLowGraphics()
        else
            print("❌ FPS Booster OFF")
        end
    end)
    table.insert(TabContent["Discord"], fpsBoosterBtn)
    fpsBoosterBtn.Parent = ScrollFrame
    fpsBoosterBtn.Visible = false
    print("🔧 DEBUG: FPS Booster button created and added.")

    -- AURORA VISUAL TOGGLE (Toggle dengan Config)
    print("🔧 DEBUG: Creating Aurora Visual...")
    _G.AuroraAnimation = { Active = false, Effects = {} }

    local function removeAuroraEffects()
        _G.AuroraAnimation.Active = false
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj.Name == "AuroraEffect" then
                obj:Destroy()
            end
        end
    end

    local function addAurora()
        removeAuroraEffects()
        
        local sky = Instance.new("Sky")
        sky.Name = "AuroraEffect"
        sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
        sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
        sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
        sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
        sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
        sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
        sky.StarCount = 8000
        sky.CelestialBodiesShown = true
        sky.Parent = Lighting
        
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "AuroraEffect"
        colorCorrection.TintColor = Color3.fromRGB(100, 255, 200)
        colorCorrection.Brightness = 0.05
        colorCorrection.Contrast = 0.1
        colorCorrection.Saturation = 0.2
        colorCorrection.Parent = Lighting
        
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Name = "AuroraEffect"
        atmosphere.Color = Color3.fromRGB(100, 200, 255)
        atmosphere.Glare = 0.5
        atmosphere.Haze = 1.5
        atmosphere.Density = 0.3
        atmosphere.Parent = Lighting
        
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "AuroraEffect"
        bloom.Intensity = 0.5
        bloom.Size = 24
        bloom.Threshold = 0.8
        bloom.Parent = Lighting
        
        _G.AuroraAnimation.Effects = { ColorCorrection = colorCorrection, Atmosphere = atmosphere, Bloom = bloom }
        _G.AuroraAnimation.Active = true
        
        task.spawn(function()
            local time = 0
            while _G.AuroraAnimation.Active do
                time = time + 0.01
                local r = 80 + math.sin(time * 0.5) * 40
                local g = 180 + math.sin(time * 0.3) * 75
                local b = 200 + math.sin(time * 0.4) * 55
                
                if colorCorrection and colorCorrection.Parent then
                    colorCorrection.TintColor = Color3.fromRGB(r, g, b)
                    colorCorrection.Brightness = 0.05 + math.sin(time * 0.2) * 0.03
                    colorCorrection.Saturation = 0.2 + math.sin(time * 0.25) * 0.1
                end
                
                if atmosphere and atmosphere.Parent then
                    local ar = 80 + math.sin(time * 0.4 + 1) * 50
                    local ag = 150 + math.sin(time * 0.35 + 2) * 70
                    local ab = 220 + math.sin(time * 0.3 + 3) * 35
                    atmosphere.Color = Color3.fromRGB(ar, ag, ab)
                    atmosphere.Haze = 1.3 + math.sin(time * 0.15) * 0.4
                    atmosphere.Density = 0.25 + math.sin(time * 0.18) * 0.15
                end
                
                if bloom and bloom.Parent then
                    bloom.Intensity = 0.4 + math.sin(time * 0.3) * 0.2
                    bloom.Size = 20 + math.sin(time * 0.25) * 8
                end
                
                task.wait(0.03)
            end
        end)
    end

    local auroraVisualBtn = self:CreateToggleButton("Aurora Visual", "Discord_Aurora Visual", function(state)
        if state then
            print("✅ Aurora Visual ON")
            addAurora()
        else
            print("❌ Aurora Visual OFF")
            removeAuroraEffects()
        end
    end)
    table.insert(TabContent["Discord"], auroraVisualBtn)
    auroraVisualBtn.Parent = ScrollFrame
    auroraVisualBtn.Visible = false
    print("🔧 DEBUG: Aurora Visual button created and added.")
    
    -- 🔥 CRITICAL: Force update the CanvasSize
    task.wait(0.1)
    local layout = ScrollFrame:FindFirstChildOfClass("UIListLayout")
    if layout then
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        print("🔧 DEBUG: CanvasSize manually updated to:", layout.AbsoluteContentSize.Y + 10)
    end

    print("🔧 DEBUG: SetupDiscordTab finished. Total items:", #TabContent["Discord"])
end

-- ==================== TAB SWITCHING ====================
function NightmareHub:SwitchTab(tabName)
    if MainFrame and MainFrame:GetAttribute("Busy") then return end
    CurrentTab = tabName
    
    -- Update tab button colors & stroke with tween
    for name, data in pairs(TabButtons) do
        if name == tabName then
            TweenProperty(data.button, {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}, tweenInfoFast)
            TweenProperty(data.button, {TextColor3 = Color3.fromRGB(255,255,255)}, tweenInfoFast)
            TweenProperty(data.stroke, {Color = Color3.fromRGB(255, 50, 50)}, tweenInfoFast)
        else
            TweenProperty(data.button, {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}, tweenInfoFast)
            TweenProperty(data.button, {TextColor3 = Color3.fromRGB(150,150,150)}, tweenInfoFast)
            TweenProperty(data.stroke, {Color = Color3.fromRGB(100, 0, 0)}, tweenInfoFast)
        end
    end
    
    -- Hide previous content with fade out
    for _, items in pairs(TabContent) do
        for _, item in ipairs(items) do
            if item and item:IsA("GuiObject") then
                pcall(function()
                    TweenProperty(item, {BackgroundTransparency = 1}, tweenInfoFast)
                    if item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") then
                        TweenProperty(item, {TextTransparency = 1}, tweenInfoFast)
                    end
                end)
                item.Visible = false
            end
        end
    end
    
    -- Show new tab items with fade in + slight stagger
    if TabContent[tabName] then
        for i, item in ipairs(TabContent[tabName]) do
            item.Visible = true
            -- Set initial transparencies to create fade-in
            pcall(function()
                if item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") then
                    item.TextTransparency = 1
                end
                item.BackgroundTransparency = 1
            end)
            -- staggered fade-in
            task.delay(0.06 * (i-1), function()
                pcall(function()
                    TweenProperty(item, {BackgroundTransparency = 0}, tweenInfoMed)
                    if item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") then
                        TweenProperty(item, {TextTransparency = 0}, tweenInfoMed)
                    end
                end)
            end)
        end
        -- reset scroll top smoothly
        pcall(function()
            TweenProperty(ScrollFrame, {CanvasPosition = Vector2.new(0,0)}, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
        end)
    end
end

return NightmareHub
