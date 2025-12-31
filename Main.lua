
--[[
    !! NÃO MODIFICAR ESTE ARQUIVO !!
    Código protegido contra detecção.
]]

local _G = _G
local _1 = game
local _2 = _1:GetService
local _3 = "Players"
local _4 = _2(_1, _3)
local _5 = _4.LocalPlayer
local _6 = "HttpService"
local _7 = _2(_1, _6)
local _8 = "TweenService"
local _9 = _2(_1, _8)
local _10 = "SoundService"
local _11 = _2(_1, _10)
local _12 = "CoreGui"
local _13 = _2(_1, _12)

local _14 = {}
local _15 = {}
_15._ = "ArcadeUI_Config.json"

_15.__ = {}

function _15:_()
    if isfile and isfile(self._) then
        local _a, _b = pcall(function()
            local _c = readfile(self._)
            local _d = _7:JSONDecode(_c)
            return _d
        end)
        if _a and _b then
            return _b
        else
            return self.__
        end
    else
        return self.__
    end
end

function _15:__(_e)
    local _f, _g = pcall(function()
        local _h = _7:JSONEncode(_e)
        writefile(self._, _h)
    end)
    return _f
end

function _15:___(_e, _i, _j)
    _e[_i] = _j
    self:__(_e)
end

local _16 = nil
local _17 = 2027986581

local function _18()
    if _16 then return end
    _16 = Instance.new("ScreenGui")
    _16.Name = "ArcadeNotificationGui"
    _16.ResetOnSpawn = false
    _16.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _16.Parent = _5:WaitForChild("PlayerGui")
end

local _19, _20, _21, _22, _23

function _14:_24()
    self._25 = _15:_()

    if _13:FindFirstChild("ArcadeUI") then
        _13:FindFirstChild("ArcadeUI"):Destroy()
    end

    task.wait(math.random(1, 3) / 10)

    _19 = Instance.new("ScreenGui")
    _19.Name = "ArcadeUI"
    _19.ResetOnSpawn = false
    _19.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _19.Parent = _13

    task.wait(0.05)

    _21 = Instance.new("ImageButton")
    _21.Size = UDim2.new(0, 60, 0, 60)
    _21.Position = UDim2.new(0, 20, 0.5, -30)
    _21.BackgroundTransparency = 1
    _21.Image = "rbxassetid://121996261654076"
    _21.Active = true
    _21.Draggable = true
    _21.Parent = _19

    task.wait(0.05)

    _20 = Instance.new("Frame")
    _20.Size = UDim2.new(0, 240, 0, 380)
    _20.Position = UDim2.new(0.5, -120, 0.5, -190)
    _20.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    _20.BackgroundTransparency = 0.1
    _20.BorderSizePixel = 0
    _20.Active = true
    _20.Draggable = true
    _20.Visible = false
    _20.Parent = _19

    local _26 = Instance.new("UICorner")
    _26.CornerRadius = UDim.new(0, 15)
    _26.Parent = _20

    local _27 = Instance.new("UIStroke")
    _27.Color = Color3.fromRGB(255, 50, 50)
    _27.Thickness = 1
    _27.Parent = _20

    local _28 = Instance.new("TextLabel")
    _28.Size = UDim2.new(1, 0, 0, 45)
    _28.Position = UDim2.new(0, 0, 0, 5)
    _28.BackgroundTransparency = 1
    _28.Text = "ttk : @N1ghtmare.gg"
    _28.TextColor3 = Color3.fromRGB(139, 0, 0)
    _28.TextSize = 16
    _28.Font = Enum.Font.Arcade
    _28.Parent = _20

    task.wait(0.05)

    _22 = Instance.new("ScrollingFrame")
    _22.Size = UDim2.new(1, -20, 1, -125)
    _22.Position = UDim2.new(0, 10, 0, 55)
    _22.BackgroundTransparency = 1
    _22.BorderSizePixel = 0
    _22.ScrollBarThickness = 4
    _22.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    _22.CanvasSize = UDim2.new(0, 0, 0, 0)
    _22.Parent = _20

    _23 = Instance.new("UIListLayout")
    _23.SortOrder = Enum.SortOrder.LayoutOrder
    _23.Padding = UDim.new(0, 10)
    _23.FillDirection = Enum.FillDirection.Vertical
    _23.HorizontalAlignment = Enum.HorizontalAlignment.Center
    _23.Parent = _22

    _23:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        _22.CanvasSize = UDim2.new(0, 0, 0, _23.AbsoluteContentSize.Y + 10)
    end)

    local _29 = Instance.new("Frame")
    _29.Size = UDim2.new(1, -20, 0, 2)
    _29.Position = UDim2.new(0, 10, 1, -65)
    _29.BackgroundTransparency = 1
    _29.BorderSizePixel = 0
    _29.Parent = _20

    local _30 = Instance.new("TextButton")
    _30.Size = UDim2.new(0, 100, 0, 32)
    _30.Position = UDim2.new(0, 15, 1, -55)
    _30.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _30.BorderSizePixel = 0
    _30.Text = "  TikTok"
    _30.TextColor3 = Color3.fromRGB(255, 255, 255)
    _30.TextSize = 13
    _30.Font = Enum.Font.Arcade
    _30.Parent = _20

    local _31 = Instance.new("UICorner")
    _31.CornerRadius = UDim.new(0, 8)
    _31.Parent = _30

    local _32 = Instance.new("ImageLabel")
    _32.Size = UDim2.new(0, 18, 0, 18)
    _32.Position = UDim2.new(0, 8, 0.5, -9)
    _32.BackgroundTransparency = 1
    _32.Image = "rbxassetid://70531653995908"
    _32.Parent = _30

    _30.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://www.tiktok.com/@n1ghtmare.gg?_r=1&_t=ZS-92UYqNKwMLA")
        end
        _30.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        task.wait(0.2)
        _30.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end)

    local _33 = Instance.new("TextButton")
    _33.Size = UDim2.new(0, 100, 0, 32)
    _33.Position = UDim2.new(0, 125, 1, -55)
    _33.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    _33.BorderSizePixel = 0
    _33.Text = "  Discord"
    _33.TextColor3 = Color3.fromRGB(255, 255, 255)
    _33.TextSize = 13
    _33.Font = Enum.Font.Arcade
    _33.Parent = _20

    local _34 = Instance.new("UICorner")
    _34.CornerRadius = UDim.new(0, 8)
    _34.Parent = _33

    local _35 = Instance.new("ImageLabel")
    _35.Size = UDim2.new(0, 16, 0, 16)
    _35.Position = UDim2.new(0, 9, 0.5, -8)
    _35.BackgroundTransparency = 1
    _35.Image = "rbxassetid://131585302403438"
    _35.Parent = _33

    _33.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/V4a7BbH5")
        end
        _33.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        task.wait(0.2)
        _33.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)

    _21.MouseButton1Click:Connect(function()
        _20.Visible = not _20.Visible
    end)

    _18()
end

function _14:_36(_37, _38)
    if not _16 then
        _18()
    end

    local _39 = _38 or _17

    if _39 then
        local _40 = Instance.new("Sound")
        _40.SoundId = "rbxassetid://" .. _39
        _40.Volume = 0.5
        _40.Parent = _11
        _40:Play()
        _40.Ended:Connect(function()
            _40:Destroy()
        end)
    end

    local _41 = Instance.new("Frame")
    _41.Size = UDim2.new(0, 300, 0, 0)
    _41.Position = UDim2.new(0.5, 0, 0, -100)
    _41.AnchorPoint = Vector2.new(0.5, 0)
    _41.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    _41.BackgroundTransparency = 0.1
    _41.BorderSizePixel = 0
    _41.Parent = _16

    local _42 = Instance.new("UICorner")
    _42.CornerRadius = UDim.new(0, 12)
    _42.Parent = _41

    local _43 = Instance.new("UIStroke")
    _43.Color = Color3.fromRGB(255, 50, 50)
    _43.Thickness = 1.0
    _43.Parent = _41

    local _44 = Instance.new("TextLabel")
    _44.Size = UDim2.new(1, -20, 1, 0)
    _44.Position = UDim2.new(0, 10, 0, 0)
    _44.BackgroundTransparency = 1
    _44.Text = _37
    _44.TextColor3 = Color3.fromRGB(255, 50, 50)
    _44.Font = Enum.Font.Arcade
    _44.TextSize = 18
    _44.TextWrapped = true
    _44.TextXAlignment = Enum.TextXAlignment.Center
    _44.TextYAlignment = Enum.TextYAlignment.Center
    _44.Parent = _41

    local _45 = 60
    local _46 = 20

    local _47 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local _48 = { Size = UDim2.new(0, 300, 0, _45), Position = UDim2.new(0.5, 0, 0, _46) }
    local _49 = _9:Create(_41, _47, _48)
    _49:Play()

    task.spawn(function()
        task.wait(3)
        local _50 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local _51 = { Size = UDim2.new(0, 300, 0, 0), Position = UDim2.new(0.5, 0, 0, -100) }
        local _52 = _9:Create(_41, _50, _51)
        _52:Play()
        _52.Completed:Connect(function()
            _41:Destroy()
        end)
    end)
end

function _14:_53(_54, _55, _56, _57)
    local _58 = Instance.new("Frame")
    _58.Size = UDim2.new(1, 0, 0, 35)
    _58.BackgroundTransparency = 1
    _58.Parent = _22

    local function _59(_5a, _5b, _5c)
        local _5d = "Arcade_" .. _5a
        local _5e = Instance.new("TextButton")
        _5e.Size = UDim2.new(0, 100, 0, 32)
        _5e.Position = _5c
        _5e.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        _5e.BorderSizePixel = 0
        _5e.Text = _5a
        _5e.TextColor3 = Color3.fromRGB(255, 255, 255)
        _5e.TextSize = 13
        _5e.Font = Enum.Font.Arcade
        _5e.Parent = _58

        local _5f = Instance.new("UICorner")
        _5f.CornerRadius = UDim.new(0, 8)
        _5f.Parent = _5e

        local _60 = Instance.new("UIStroke")
        _60.Color = Color3.fromRGB(255, 50, 50)
        _60.Thickness = 1
        _60.Parent = _5e

        local _61 = self._25[_5d] or false
        if _61 then
            _5e.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        end

        if _5b then _5b(_61) end

        _5e.MouseButton1Click:Connect(function()
            _61 = not _61
            if _61 then
                _5e.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            else
                _5e.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            end
            _15:___(self._25, _5d, _61)
            if _5b then _5b(_61) end
        end)
    end

    _59(_54, _55, UDim2.new(0, 5, 0, 0))
    if _56 and _57 then
        _59(_56, _57, UDim2.new(0, 115, 0, 0))
    end
end

return _14
