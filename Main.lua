--[[
    ARCADE UI LIBRARY (REFORMED & PROTECTED)
    Foco: Funcionalidade e Anti-Detecção
]]

local ArcadeUILib = {}
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==================== ANTI-DETECTION UTILS ====================
local function RandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local res = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        res = res .. string.sub(chars, rand, rand)
    end
    return res
end

-- Proteção de Metatabela para esconder a UI
local function ProtectInstance(instance)
    pcall(function()
        local mt = getrawmetatable(game)
        local setro = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)
        if setro then setro(mt, false) end
        local old_index = mt.__index
        
        mt.__index = newcclosure(function(t, k)
            if not checkcaller() and (t == game:GetService("CoreGui") or t == game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")) then
                if k == instance.Name then
                    return nil
                end
            end
            return old_index(t, k)
        end)
        if setro then setro(mt, true) end
    end)
end

-- ==================== CONFIG SAVE SYSTEM ====================
local ConfigSystem = {}
ConfigSystem.ConfigFile = "ArcadeUI_Config.json"
ConfigSystem.DefaultConfig = {}

function ConfigSystem:Load()
    if isfile and isfile(self.ConfigFile) then
        local success, result = pcall(function()
            local fileContent = readfile(self.ConfigFile)
            return HttpService:JSONDecode(fileContent)
        end)
        if success and result then return result end
    end
    return self.DefaultConfig
end

function ConfigSystem:Save(config)
    pcall(function()
        writefile(self.ConfigFile, HttpService:JSONEncode(config))
    end)
end

function ConfigSystem:UpdateSetting(config, key, value)
    config[key] = value
    self:Save(config)
end

-- ==================== NOTIFICATION SYSTEM ====================
local NotificationGui = nil
local DEFAULT_NOTIFICATION_SOUND_ID = 2027986581

local function createNotificationGui()
    if NotificationGui then return end
    
    NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = RandomString(math.random(15, 20))
    NotificationGui.ResetOnSpawn = false
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Proteção de CoreGui
    pcall(function()
        if gethui then
            NotificationGui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(NotificationGui)
            NotificationGui.Parent = game:GetService("CoreGui")
        else
            NotificationGui.Parent = game:GetService("CoreGui")
            ProtectInstance(NotificationGui)
        end
    end)
end

-- ==================== UI VARIABLES ====================
local ScreenGui
local MainFrame
local ToggleButton
local ScrollFrame
local ListLayout

-- ==================== DRAGGABLE SYSTEM (FIXED) ====================
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==================== CREATE UI ====================
function ArcadeUILib:CreateUI()
    self.Config = ConfigSystem:Load()

    -- Cleanup old UI
    pcall(function()
        local old = game:GetService("CoreGui"):FindFirstChild("ArcadeUI") or (gethui and gethui():FindFirstChild("ArcadeUI"))
        if old then old:Destroy() end
    end)

    -- ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = RandomString(math.random(15, 20))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Proteção de CoreGui
    pcall(function()
        if gethui then
            ScreenGui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = game:GetService("CoreGui")
        else
            ScreenGui.Parent = game:GetService("CoreGui")
            ProtectInstance(ScreenGui)
        end
    end)

    -- Toggle Button
    ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = RandomString(8)
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(0, 20, 0.5, -30)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Image = "rbxassetid://121996261654076"
    ToggleButton.Parent = ScreenGui
    MakeDraggable(ToggleButton, ToggleButton)

    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = RandomString(10)
    MainFrame.Size = UDim2.new(0, 240, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -120, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    MakeDraggable(MainFrame, MainFrame)

    -- Styling
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = MainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 50, 50)
    mainStroke.Thickness = 1
    mainStroke.Parent = MainFrame

    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 45)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ttk : @N1ghtmare.gg"
    titleLabel.TextColor3 = Color3.fromRGB(139, 0, 0)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.Parent = MainFrame

    -- ScrollingFrame
    ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -125)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = MainFrame

    -- UIListLayout
    ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.Parent = ScrollFrame

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Social Buttons (TikTok & Discord)
    local function createSocialButton(text, pos, color, iconId, link)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 0, 32)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = "  " .. text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.Arcade
        btn.Parent = MainFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 18, 0, 18)
        icon.Position = UDim2.new(0, 8, 0.5, -9)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://" .. iconId
        icon.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(link) end
            btn.BackgroundTransparency = 0.5
            task.wait(0.2)
            btn.BackgroundTransparency = 0
        end)
    end

    createSocialButton("TikTok", UDim2.new(0, 15, 1, -55), Color3.fromRGB(0, 0, 0), "70531653995908", "https://www.tiktok.com/@n1ghtmare.gg?_r=1&_t=ZS-92UYqNKwMLA")
    createSocialButton("Discord", UDim2.new(0, 125, 1, -55), Color3.fromRGB(88, 101, 242), "131585302403438", "https://discord.gg/V4a7BbH5")

    -- Toggle button functionality
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    createNotificationGui()
end

-- Função de Notificação Original
function ArcadeUILib:Notify(text, soundId)
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
    textLabel.Parent = notifFrame
    
    local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(0.5, 0, 0, 20)
    })
    tweenIn:Play()
    
    task.spawn(function()
        task.wait(3)
        local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(0.5, 0, 0, -100)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function() notifFrame:Destroy() end)
    end)
end

-- Função de Toggle Original
function ArcadeUILib:AddToggleRow(text1, callback1, text2, callback2)
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, 0, 0, 35)
    rowFrame.BackgroundTransparency = 1
    rowFrame.Parent = ScrollFrame

    local function createSingleToggle(text, callback, position)
        local configKey = "Arcade_" .. text
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 100, 0, 32)
        toggle.Position = position
        toggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        toggle.BorderSizePixel = 0
        toggle.Text = text
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 13
        toggle.Font = Enum.Font.Arcade
        toggle.Parent = rowFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggle

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 50, 50)
        stroke.Thickness = 1
        stroke.Parent = toggle

        local isToggled = self.Config[configKey] or false
        if isToggled then toggle.BackgroundColor3 = Color3.fromRGB(200, 30, 30) end
        if callback then callback(isToggled) end

        toggle.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            toggle.BackgroundColor3 = isToggled and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(80, 0, 0)
            ConfigSystem:UpdateSetting(self.Config, configKey, isToggled)
            if callback then callback(isToggled) end
        end)
    end

    createSingleToggle(text1, callback1, UDim2.new(0, 5, 0, 0))
    if text2 and callback2 then
        createSingleToggle(text2, callback2, UDim2.new(0, 115, 0, 0))
    end
end

return ArcadeUILib

