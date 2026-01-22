-- Minimalist iOS-like redesign of the original UI library
-- Notes:
-- - API and element-adding functions (Tab, SectionFunc:AddToggle/AddButton/etc.) kept intact.
-- - Design updated: soft rounded corners, light translucent panels, subtle shadows, iOS blue accent.
-- - Toggle keeps ON/OFF system, but visual styling improved and made more minimal.
-- - Kept original logic/flow; only visual properties and a few small layout improvements changed.

local Library = {}

-- Global theme for the iOS-like redesign
local Theme = {
    Background        = Color3.fromRGB(245, 246, 250), -- very light background
    Panel             = Color3.fromRGB(255, 255, 255), -- panels
    Accent            = Color3.fromRGB(10, 132, 255),  -- iOS blue
    TextPrimary       = Color3.fromRGB(28, 28, 30),    -- primary text (dark)
    TextSecondary     = Color3.fromRGB(99, 99, 102),   -- secondary text (muted)
    Muted             = Color3.fromRGB(229, 229, 234), -- subtle elements / off toggles
    ShadowColor       = Color3.fromRGB(0, 0, 0),
    Transparent       = 1,
}

-- small helper to create consistent UICorner radii
local function setCorner(uicorner, radius)
    if uicorner then
        uicorner.CornerRadius = UDim.new(0, radius)
    end
end

function Library:TweenInstance(Instance, Time, OldValue, NewValue)
	local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Enum.EasingStyle.Quad), { [OldValue] = NewValue })
	rz_Tween:Play()
	return rz_Tween
end

function Library:UpdateContent(Content, Title, Object)
	if Content.Text ~= "" then
		Title.Position = UDim2.new(0, 10, 0, 7)
		Title.Size = UDim2.new(1, -60, 0, 16)
		local MaxY = math.max(Content.TextBounds.Y + 15, 45)
		Object.Size = UDim2.new(1, 0, 0, MaxY)
	end
end

function Library:UpdateScrolling(Scroll, List)
	List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 15)
	end)
end

function Library:MouseEvent(Skibidi, ...)
	local Args = { ... }
	Skibidi.MouseEnter:Connect(Args[1])
	Skibidi.MouseLeave:Connect(Args[2])
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
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	local function UpdatePos(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = game:GetService("TweenService"):Create(object, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = pos })
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			UpdatePos(input)
		end
	end)
end

function Library:NewWindow(ConfigWindow)
	local ConfigWindow = self:MakeConfig({
		Title = "SYNTRAX Hub",
		Description = "By Thais",
	}, ConfigWindow or {})

	-- Root objects
	local TeddyUI_Premium = Instance.new("ScreenGui")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	local Main = Instance.new("ImageLabel")
	local UICorner = Instance.new("UICorner")
	local Top = Instance.new("Frame")
	local Line = Instance.new("Frame")
	local Left = Instance.new("Folder")
	local NameHub = Instance.new("TextLabel")
	local LogoHub = Instance.new("ImageLabel")
	local Desc = Instance.new("TextLabel")
	local Right = Instance.new("Folder")
	local Frame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local Minize = Instance.new("TextButton")
	local Icon = Instance.new("ImageLabel")
	local Large = Instance.new("TextButton")
	local Icon_2 = Instance.new("ImageLabel")
	local Close = Instance.new("TextButton")
	local Icon_3 = Instance.new("ImageLabel")

	local TabFrame = Instance.new("Frame")
	local Line_2 = Instance.new("Frame")
	local SearchFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local IconSearch = Instance.new("ImageLabel")
	local SearchBox = Instance.new("TextBox")
	local ScrollingTab = Instance.new("ScrollingFrame")
	local UIPadding_2 = Instance.new("UIPadding")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local LayoutFrame = Instance.new("Frame")
	local RealLayout = Instance.new("Frame")
	local LayoutList = Instance.new("Folder")
	local UIPageLayout = Instance.new("UIPageLayout")
	local LayoutName = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local DropdownZone = Instance.new("Frame")

	-- root setup
	TeddyUI_Premium.Name = "TeddyUI_Premium"
	TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = TeddyUI_Premium
	DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadowHolder.BackgroundTransparency = 1.000
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadowHolder.Size = UDim2.new(0, 560, 0, 360)
	DropShadowHolder.ZIndex = 0

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 50, 1, 50)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6015897843" -- subtle shadow asset
	DropShadow.ImageColor3 = Theme.ShadowColor
	DropShadow.ImageTransparency = 0.7
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	Main.Name = "Main"
	Main.Parent = DropShadowHolder
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 560, 0, 360)
	Main.BorderSizePixel = 0
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.ClipsDescendants = true

	-- iOS-like frosted panel: subtle white with slight transparency
	Main.Image = ""
	Main.BackgroundColor3 = Theme.Panel
	Main.BackgroundTransparency = 0.02

	UICorner.Parent = Main
	setCorner(UICorner, 14)

	-- Top bar (title area)
	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = Theme.Panel
	Top.BackgroundTransparency = 1.000
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 56)

	Line.Name = "Line"
	Line.Parent = Top
	Line.BackgroundColor3 = Theme.Muted
	Line.BackgroundTransparency = 0.85
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 0, 1, -1)
	Line.Size = UDim2.new(1, 0, 0, 1)

	Left.Name = "Left"
	Left.Parent = Top

	NameHub.Name = "NameHub"
	NameHub.Parent = Left
	NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameHub.BackgroundTransparency = 1.000
	NameHub.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameHub.BorderSizePixel = 0
	NameHub.Position = UDim2.new(0, 64, 0, 16)
	NameHub.Size = UDim2.new(0, 420, 0, 24)
	NameHub.Font = Enum.Font.GothamBold
	NameHub.Text = ConfigWindow.Title
	NameHub.TextColor3 = Theme.TextPrimary
	NameHub.TextSize = 15.000
	NameHub.TextXAlignment = Enum.TextXAlignment.Left

	LogoHub.Name = "LogoHub"
	LogoHub.Parent = Left
	LogoHub.BackgroundTransparency = 1.000
	LogoHub.BorderSizePixel = 0
	LogoHub.Position = UDim2.new(0, 18, 0, 13)
	LogoHub.Size = UDim2.new(0, 34, 0, 34)
	LogoHub.Image = "rbxassetid://123256573634"
	LogoHub.ImageColor3 = Theme.Accent

	Desc.Name = "Desc"
	Desc.Parent = Left
	Desc.BackgroundTransparency = 1.000
	Desc.BorderSizePixel = 0
	Desc.Position = UDim2.new(0, 64, 0, 36)
	Desc.Size = UDim2.new(0, 420, 0, 14)
	Desc.Font = Enum.Font.Gotham
	Desc.Text = ConfigWindow.Description
	Desc.TextColor3 = Theme.TextSecondary
	Desc.TextSize = 12.000
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextYAlignment = Enum.TextYAlignment.Top

	Right.Name = "Right"
	Right.Parent = Top

	Frame.Parent = Right
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1.000
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(1, -132, 0, 0)
	Frame.Size = UDim2.new(0, 132, 1, 0)

	UIListLayout.Parent = Frame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 8)

	UIPadding.Parent = Frame
	UIPadding.PaddingTop = UDim.new(0, 8)

	-- minimize / maximize / close buttons: iOS minimal circular style
	Minize.Name = "Minize"
	Minize.Parent = Frame
	Minize.Active = false
	Minize.AnchorPoint = Vector2.new(0, 0.5)
	Minize.BackgroundColor3 = Theme.Panel
	Minize.BackgroundTransparency = 0.02
	Minize.BorderSizePixel = 0
	Minize.Selectable = false
	Minize.Size = UDim2.new(0, 32, 0, 32)
	Minize.Text = ""
	local minCorner = Instance.new("UICorner", Minize); minCorner.CornerRadius = UDim.new(1, 0)
	local minStroke = Instance.new("UIStroke", Minize); minStroke.Color = Color3.new(1,1,1); minStroke.Transparency = 0.9; minStroke.Thickness = 0.5

	Icon.Name = "Icon"
	Icon.Parent = Minize
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1.000
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Size = UDim2.new(0, 16, 0, 16)
	Icon.Image = "rbxassetid://136452605242985"
	Icon.ImageColor3 = Theme.TextSecondary

	Large.Name = "Large"
	Large.Parent = Frame
	Large.Active = false
	Large.AnchorPoint = Vector2.new(0, 0.5)
	Large.BackgroundColor3 = Theme.Panel
	Large.BackgroundTransparency = 0.02
	Large.BorderSizePixel = 0
	Large.Selectable = false
	Large.Size = UDim2.new(0, 32, 0, 32)
	Large.Text = ""
	local largeCorner = Instance.new("UICorner", Large); largeCorner.CornerRadius = UDim.new(1, 0)
	local largeStroke = Instance.new("UIStroke", Large); largeStroke.Color = Color3.new(1,1,1); largeStroke.Transparency = 0.9; largeStroke.Thickness = 0.5

	Icon_2.Name = "Icon"
	Icon_2.Parent = Large
	Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon_2.BackgroundTransparency = 1.000
	Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon_2.Size = UDim2.new(0, 14, 0, 14)
	Icon_2.Image = "rbxassetid://136452605242985"
	Icon_2.ImageColor3 = Theme.TextSecondary

	Close.Name = "Close"
	Close.Parent = Frame
	Close.Active = false
	Close.AnchorPoint = Vector2.new(0, 0.5)
	Close.BackgroundColor3 = Theme.Panel
	Close.BackgroundTransparency = 0.02
	Close.BorderSizePixel = 0
	Close.Selectable = false
	Close.Size = UDim2.new(0, 32, 0, 32)
	Close.Text = ""
	local closeCorner = Instance.new("UICorner", Close); closeCorner.CornerRadius = UDim.new(1, 0)
	local closeStroke = Instance.new("UIStroke", Close); closeStroke.Color = Color3.new(1,1,1); closeStroke.Transparency = 0.9; closeStroke.Thickness = 0.5

	-- Close confirmation (kept functionally same, with cleaner visuals)
	Close.MouseButton1Down:Connect(function()
		DropdownZone.Visible = true
		local tat_ = Instance.new("Frame", DropdownZone);
		tat_["BorderSizePixel"] = 0;
		tat_["BackgroundColor3"] = Theme.Panel;
		tat_["AnchorPoint"] = Vector2.new(0.5, 0.5);
		tat_["Size"] = UDim2.new(0, 380, 0, 140);
		tat_["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		tat_["BorderColor3"] = Color3.fromRGB(200, 200, 200);
		tat_["Name"] = [[ConfirmExit]];
		local suacc = Instance.new("UIStroke", tat_);
		suacc["Transparency"] = 0.9;
		suacc["Color"] = Color3.fromRGB(220,220,220);
		local suaccC = Instance.new("UICorner", tat_);
		suaccC["CornerRadius"] = UDim.new(0, 10);
		local suacc2 = Instance.new("TextLabel", tat_);
		suacc2["BorderSizePixel"] = 0;
		suacc2["TextSize"] = 18;
		suacc2["BackgroundColor3"] = Theme.Panel;
		suacc2["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		suacc2["TextColor3"] = Theme.TextPrimary;
		suacc2["BackgroundTransparency"] = 1;
		suacc2["Size"] = UDim2.new(0, 380, 0, 50);
		suacc2["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		suacc2["Text"] = [[Are you sure]];
		suacc2.Position = UDim2.new(0, 0, 0, 10);

		local btnyes = Instance.new("TextButton", tat_);
		btnyes["BorderSizePixel"] = 0;
		btnyes["TextSize"] = 15;
		btnyes["TextColor3"] = Color3.fromRGB(255, 255, 255);
		btnyes["BackgroundColor3"] = Theme.Accent;
		btnyes["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		btnyes["AnchorPoint"] = Vector2.new(0, 1);
		btnyes["Size"] = UDim2.new(0, 140, 0, 40);
		btnyes["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		btnyes["Text"] = [[Yes]];
		btnyes["Position"] = UDim2.new(0, 40, 1, -20);
		local thuaaa = Instance.new("UICorner", btnyes);
		local thuaaa2 = Instance.new("UIStroke", btnyes);
		thuaaa2["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
		thuaaa2["Color"] = Color3.fromRGB(39, 39, 39);

		btnyes.MouseButton1Down:Connect(function()
			TeddyUI_Premium:Destroy()
		end)

		local btnno = Instance.new("TextButton", tat_);
		btnno["BorderSizePixel"] = 0;
		btnno["TextSize"] = 15;
		btnno["TextColor3"] = Theme.TextPrimary;
		btnno["BackgroundColor3"] = Theme.Muted;
		btnno["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		btnno["AnchorPoint"] = Vector2.new(1, 1);
		btnno["Size"] = UDim2.new(0, 140, 0, 40);
		btnno["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		btnno["Text"] = [[No]];
		btnno["Position"] = UDim2.new(1, -40, 1, -20);
		local thuaa = Instance.new("UICorner", btnno);
		local thuaa2 = Instance.new("UIStroke", btnno);
		thuaa2["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
		thuaa2["Color"] = Color3.fromRGB(39, 39, 39);

		btnno.MouseButton1Down:Connect(function()
			tat_:Destroy()
			DropdownZone.Visible = false
		end)
	end)

	Icon_3.Name = "Icon"
	Icon_3.Parent = Close
	Icon_3.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon_3.BackgroundColor3 = Theme.Panel
	Icon_3.BackgroundTransparency = 1.000
	Icon_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon_3.BorderSizePixel = 0
	Icon_3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon_3.Size = UDim2.new(0, 16, 0, 16)
	Icon_3.Image = "rbxassetid://105957381820378"
	Icon_3.ImageRectOffset = Vector2.new(480, 0)
	Icon_3.ImageRectSize = Vector2.new(96, 96)
	Icon_3.ImageColor3 = Theme.TextSecondary

	-- Tab column
	TabFrame.Name = "TabFrame"
	TabFrame.Parent = Main
	TabFrame.BackgroundColor3 = Theme.Panel
	TabFrame.BackgroundTransparency = 1.000
	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabFrame.BorderSizePixel = 0
	TabFrame.Position = UDim2.new(0, 0, 0, 56)
	TabFrame.Size = UDim2.new(0, 150, 1, -56)

	Line_2.Name = "Line"
	Line_2.Parent = TabFrame
	Line_2.BackgroundColor3 = Theme.Muted
	Line_2.BackgroundTransparency = 0.85
	Line_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line_2.BorderSizePixel = 0
	Line_2.Position = UDim2.new(1, -1, 0, 0)
	Line_2.Size = UDim2.new(0, 1, 1, 0)

	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = TabFrame
	SearchFrame.BackgroundColor3 = Theme.Panel
	SearchFrame.BackgroundTransparency = 0.02
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.Position = UDim2.new(0, 12, 0, 12)
	SearchFrame.Size = UDim2.new(1, -24, 0, 36)
	UICorner_2.CornerRadius = UDim.new(0, 10)
	UICorner_2.Parent = SearchFrame

	IconSearch.Name = "IconSearch"
	IconSearch.Parent = SearchFrame
	IconSearch.AnchorPoint = Vector2.new(0, 0.5)
	IconSearch.BackgroundTransparency = 1.000
	IconSearch.Position = UDim2.new(0, 14, 0.5, 0)
	IconSearch.Size = UDim2.new(0, 16, 0, 16)
	IconSearch.Image = "rbxassetid://71309835376233"
	IconSearch.ImageColor3 = Theme.TextSecondary

	SearchBox.Name = "SearchBox"
	SearchBox.Parent = SearchFrame
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.BorderSizePixel = 0
	SearchBox.Position = UDim2.new(0, 36, 0, 0)
	SearchBox.Size = UDim2.new(1, -40, 1, 0)
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.PlaceholderText = "Search"
	SearchBox.Text = ""
	SearchBox.TextColor3 = Theme.TextPrimary
	SearchBox.TextSize = 13.000
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	ScrollingTab.Name = "ScrollingTab"
	ScrollingTab.Parent = TabFrame
	ScrollingTab.BackgroundTransparency = 1.000
	ScrollingTab.BorderSizePixel = 0
	ScrollingTab.Position = UDim2.new(0, 0, 0, 60)
	ScrollingTab.Selectable = false
	ScrollingTab.Size = UDim2.new(1, 0, 1, -60)
	ScrollingTab.ScrollBarThickness = 0

	self:UpdateScrolling(ScrollingTab, UIListLayout_2)

	UIPadding_2.Parent = ScrollingTab
	UIPadding_2.PaddingBottom = UDim.new(0, 8)
	UIPadding_2.PaddingLeft = UDim.new(0, 10)
	UIPadding_2.PaddingRight = UDim.new(0, 10)
	UIPadding_2.PaddingTop = UDim.new(0, 4)

	UIListLayout_2.Parent = ScrollingTab
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.Padding = UDim.new(0, 10)

	-- Layout area
	LayoutFrame.Name = "LayoutFrame"
	LayoutFrame.Parent = Main
	LayoutFrame.BackgroundTransparency = 1.000
	LayoutFrame.Position = UDim2.new(0, 150, 0, 56)
	LayoutFrame.Size = UDim2.new(1, -150, 1, -56)
	LayoutFrame.ClipsDescendants = true

	RealLayout.Name = "RealLayout"
	RealLayout.Parent = LayoutFrame
	RealLayout.BackgroundTransparency = 1.000
	RealLayout.Position = UDim2.new(0, 0, 0, 40)
	RealLayout.Size = UDim2.new(1, 0, 1, -40)

	LayoutList.Name = "Layout List"
	LayoutList.Parent = RealLayout

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local InputText = SearchBox.Text:lower()
		for _, Layout in next, LayoutList:GetChildren() do
			if Layout:IsA("ScrollingFrame") then
				for _, Section in next, Layout:GetChildren() do
					if Section.Name == "Section" then
						local SectionList = Section:FindFirstChild("SectionList")
						if SectionList then
							for _, Element in next, SectionList:GetChildren() do
								if Element:IsA("Frame") and Element:FindFirstChild("Title") then
									if Element.Title.Text:lower():find(InputText) then
										Element.Visible = true
									else
										Element.Visible = false
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	UIPageLayout.Parent = LayoutList
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
	UIPageLayout.TweenTime = 0.300

	LayoutName.Name = "LayoutName"
	LayoutName.Parent = LayoutFrame
	LayoutName.BackgroundTransparency = 1.000
	LayoutName.Size = UDim2.new(1, 0, 0, 40)

	TextLabel.Parent = LayoutName
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0, 14, 0, 0)
	TextLabel.Size = UDim2.new(1, -20, 1, 0)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = ""
	TextLabel.TextColor3 = Theme.TextPrimary
	TextLabel.TextSize = 14.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	DropdownZone.Name = "DropdownZone"
	DropdownZone.Parent = Main
	DropdownZone.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	DropdownZone.BackgroundTransparency = 1
	DropdownZone.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownZone.BorderSizePixel = 0
	DropdownZone.Size = UDim2.new(1, 0, 1, 0)
	DropdownZone.Visible = false

	self:MakeDraggable(Top, DropShadowHolder)

	local AllLayouts = 0
	local Tab = {}

	function Tab:T(t, iconid)
		local TabDisable = Instance.new("Frame")
		local Choose_2 = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local NameTab_2 = Instance.new("TextLabel")
		local Click_Tab_2 = Instance.new("TextButton")
		local Layout = Instance.new("ScrollingFrame")
		local UIPadding_3 = Instance.new("UIPadding")
		local UIListLayout_3 = Instance.new("UIListLayout")
		local TabIcon = Instance.new("ImageLabel")
		local IconRound = Instance.new("UICorner")

		TabDisable.Name = "TabDisable"
		TabDisable.Parent = ScrollingTab
		TabDisable.BackgroundTransparency = 1.000
		TabDisable.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabDisable.BorderSizePixel = 0
		TabDisable.Size = UDim2.new(1, 0, 0, 36)

		Choose_2.Name = "Choose"
		Choose_2.Parent = TabDisable
		Choose_2.BackgroundColor3 = Theme.Accent
		Choose_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Choose_2.BorderSizePixel = 0
		Choose_2.Position = UDim2.new(0, 10, 0, 8)
		Choose_2.Size = UDim2.new(0, 4, 0, 20)
		Choose_2.Visible = false
		setCorner(UICorner_4, 3)
		UICorner_4.Parent = Choose_2

		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabDisable
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.Position = UDim2.new(0, 14, 0.5, 0)
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.Size = UDim2.new(0, 16, 0, 16)
		TabIcon.ImageColor3 = Theme.TextPrimary
		IconRound.Parent = TabIcon
		setCorner(IconRound, 4)

		local NamePosX = 20
		if iconid and tostring(iconid) ~= "" then
			TabIcon.Image = iconid
			TabIcon.Visible = true
			NamePosX = 40
		else
			TabIcon.Image = ""
			TabIcon.Visible = false
			NamePosX = 20
		end

		NameTab_2.Name = "NameTab"
		NameTab_2.Parent = TabDisable
		NameTab_2.BackgroundTransparency = 1.000
		NameTab_2.Position = UDim2.new(0, NamePosX, 0, 6)
		NameTab_2.Size = UDim2.new(1, -NamePosX, 1, 0)
		NameTab_2.Font = Enum.Font.Gotham
		NameTab_2.Text = t
		NameTab_2.TextColor3 = Theme.TextPrimary
		NameTab_2.TextSize = 13.000
		NameTab_2.TextTransparency = 0.4
		NameTab_2.TextXAlignment = Enum.TextXAlignment.Left

		Click_Tab_2.Name = "Click_Tab"
		Click_Tab_2.Parent = TabDisable
		Click_Tab_2.BackgroundTransparency = 1.000
		Click_Tab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Click_Tab_2.BorderSizePixel = 0
		Click_Tab_2.Size = UDim2.new(1, 0, 1, 0)
		Click_Tab_2.Font = Enum.Font.SourceSans
		Click_Tab_2.Text = ""
		Click_Tab_2.TextColor3 = Color3.fromRGB(0, 0, 0)
		Click_Tab_2.TextSize = 14.000

		Layout.Name = "Layout"
		Layout.Parent = LayoutList
		Layout.BackgroundTransparency = 1.000
		Layout.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Layout.BorderSizePixel = 0
		Layout.Selectable = false
		Layout.Size = UDim2.new(1, 0, 1, 0)
		Layout.CanvasSize = UDim2.new(0, 0, 1, 0)
		Layout.ScrollBarThickness = 0
		Layout.LayoutOrder = AllLayouts

		Library:UpdateScrolling(Layout, UIListLayout_3)

		UIPadding_3.Parent = Layout
		UIPadding_3.PaddingBottom = UDim.new(0, 7)
		UIPadding_3.PaddingLeft = UDim.new(0, 10)
		UIPadding_3.PaddingRight = UDim.new(0, 10)

		UIListLayout_3.Parent = Layout
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 8)

		if AllLayouts == 0 then
			NameTab_2.TextTransparency = 0
			Choose_2.Visible = true
			if TabIcon.Visible then
				TabIcon.ImageTransparency = 0
			end
			UIPageLayout:JumpToIndex(0)
			TextLabel.Text = t
		else
			if TabIcon.Visible then
				TabIcon.ImageTransparency = 0.6
			end
		end

		Click_Tab_2.Activated:Connect(function()
			TextLabel.Text = t
			for i, v in next, ScrollingTab:GetChildren() do
				if v:IsA("Frame") then
					Library:TweenInstance(v.NameTab, 0.25, "TextTransparency", 0.4)
					if v:FindFirstChild("TabIcon") then
						Library:TweenInstance(v.TabIcon, 0.25, "ImageTransparency", 0.6)
					end
					v.Choose.Visible = false
				end
			end
			Library:TweenInstance(NameTab_2, 0.2, "TextTransparency", 0)
			if TabIcon.Visible then
				Library:TweenInstance(TabIcon, 0.2, "ImageTransparency", 0)
			end
			UIPageLayout:JumpToIndex(Layout.LayoutOrder)
			Choose_2.Visible = true
		end)

		AllLayouts = AllLayouts + 1

		local TabFunc = {}

		function TabFunc:AddSection(RealNameSection)
			local Section = Instance.new("Frame")
			local UICorner_5 = Instance.new("UICorner")
			local NameSection = Instance.new("Frame")
			local Title = Instance.new("TextLabel")
			local Line_3 = Instance.new("Frame")
			local UIGradient = Instance.new("UIGradient")
			local SectionList = Instance.new("Frame")
			local UIPadding_4 = Instance.new("UIPadding")
			local UIListLayout_4 = Instance.new("UIListLayout")

			Section.Name = "Section"
			Section.Parent = Layout
			Section.BackgroundTransparency = 0.95
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.Position = UDim2.new(1.36775815, 0, 0.545454562, 0)
			Section.Size = UDim2.new(1, 0, 0, 55)
			UICorner_5.Parent = Section
			setCorner(UICorner_5, 8)

			NameSection.Name = "NameSection"
			NameSection.Parent = Section
			NameSection.BackgroundTransparency = 1.000
			NameSection.BorderSizePixel = 0
			NameSection.Size = UDim2.new(1, 0, 0, 30)

			Title.Name = "Title"
			Title.Parent = NameSection
			Title.BackgroundTransparency = 1.000
			Title.Size = UDim2.new(1, 0, 1, 0)
			Title.Font = Enum.Font.GothamBold
			Title.Text = RealNameSection
			Title.TextColor3 = Theme.TextPrimary
			Title.TextSize = 14.000

			Line_3.Name = "Line"
			Line_3.Parent = NameSection
			Line_3.BackgroundColor3 = Theme.Muted
			Line_3.BorderSizePixel = 0
			Line_3.Position = UDim2.new(0, 0, 1, -2)
			Line_3.Size = UDim2.new(1, 0, 0, 2)
			UIGradient.Color = ColorSequence.new { ColorSequenceKeypoint.new(0.00, Theme.Muted), ColorSequenceKeypoint.new(1.00, Theme.Accent) }
			UIGradient.Transparency = NumberSequence.new { NumberSequenceKeypoint.new(0.00, 0.6), NumberSequenceKeypoint.new(1.00, 0.6) }
			UIGradient.Parent = Line_3

			SectionList.Name = "SectionList"
			SectionList.Parent = Section
			SectionList.BackgroundTransparency = 1.000
			SectionList.BorderSizePixel = 0
			SectionList.Position = UDim2.new(0, 0, 0, 35)
			SectionList.Size = UDim2.new(1, 0, 1, -35)
			UIPadding_4.Parent = SectionList
			UIPadding_4.PaddingBottom = UDim.new(0, 8)
			UIPadding_4.PaddingLeft = UDim.new(0, 8)
			UIPadding_4.PaddingRight = UDim.new(0, 8)
			UIPadding_4.PaddingTop = UDim.new(0, 8)

			UIListLayout_4.Parent = SectionList
			UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_4.Padding = UDim.new(0, 6)
			UIListLayout_4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, 0, 0, UIListLayout_4.AbsoluteContentSize.Y + 55)
			end)

			local SectionFunc = {}

			function SectionFunc:AddToggle(cftoggle)
				local cftoggle = Library:MakeConfig({
					Title = "Toggle < Missing Title >",
					Description = "",
					Default = false,
					Callback = function() end
				}, cftoggle or {})

				local Toggle = Instance.new("Frame")
				local UICorner_6 = Instance.new("UICorner")
				local Title_2 = Instance.new("TextLabel")
				local ToggleCheck = Instance.new("Frame")
				local UICorner_7 = Instance.new("UICorner")
				local Check = Instance.new("TextLabel")
				local UICorner_8 = Instance.new("UICorner")
				local Toggle_Click = Instance.new("TextButton")
				local Content = Instance.new("TextLabel")

				Toggle.Name = "Toggle"
				Toggle.Parent = SectionList
				Toggle.BackgroundTransparency = 0.95
				Toggle.BorderSizePixel = 0
				Toggle.Size = UDim2.new(1, 0, 0, 34)

				UICorner_6.Parent = Toggle
				setCorner(UICorner_6, 8)

				Title_2.Name = "Title"
				Title_2.Parent = Toggle
				Title_2.BackgroundTransparency = 1.000
				Title_2.Position = UDim2.new(0, 10, 0, 6)
				Title_2.Size = UDim2.new(1, -80, 0, 18)
				Title_2.Font = Enum.Font.GothamBold
				Title_2.Text = cftoggle.Title
				Title_2.TextColor3 = Theme.TextPrimary
				Title_2.TextSize = 13.000
				Title_2.TextXAlignment = Enum.TextXAlignment.Left

				ToggleCheck.Name = "ToggleCheck"
				ToggleCheck.Parent = Toggle
				ToggleCheck.AnchorPoint = Vector2.new(0, 0.5)
				ToggleCheck.BackgroundColor3 = Theme.Muted
				ToggleCheck.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleCheck.BorderSizePixel = 0
				ToggleCheck.Position = UDim2.new(1, -58, 0.5, 0)
				ToggleCheck.Size = UDim2.new(0, 46, 0, 26)
				UICorner_7.CornerRadius = UDim.new(1, 0)
				UICorner_7.Parent = ToggleCheck

				Check.Name = "Check"
				Check.Parent = ToggleCheck
				Check.AnchorPoint = Vector2.new(0.5, 0.5)
				Check.BackgroundTransparency = 1
				Check.Font = Enum.Font.GothamBold
				Check.TextSize = 12
				Check.TextColor3 = Theme.Panel
				Check.Text = "OFF"
				Check.Position = UDim2.new(0.5, 0, 0.5, 0)
				Check.Size = UDim2.new(1, -6, 1, 0)
				Check.TextXAlignment = Enum.TextXAlignment.Center
				Check.TextYAlignment = Enum.TextYAlignment.Center
				UICorner_8.Parent = Check
				setCorner(UICorner_8, 6)

				Toggle_Click.Name = "Toggle_Click"
				Toggle_Click.Parent = Toggle
				Toggle_Click.BackgroundTransparency = 1.000
				Toggle_Click.BorderSizePixel = 0
				Toggle_Click.Size = UDim2.new(1, 0, 1, 0)
				Toggle_Click.Font = Enum.Font.SourceSans
				Toggle_Click.Text = ""
				Toggle_Click.TextColor3 = Color3.fromRGB(0, 0, 0)
				Toggle_Click.TextSize = 14.000

				Content.Name = "Content"
				Content.Parent = Toggle
				Content.BackgroundTransparency = 1.000
				Content.Position = UDim2.new(0, 10, 0, 28)
				Content.Size = UDim2.new(1, -60, 1, 0)
				Content.Font = Enum.Font.Gotham
				Content.Text = cftoggle.Description
				Content.TextColor3 = Theme.TextSecondary
				Content.TextSize = 12.000
				Content.TextXAlignment = Enum.TextXAlignment.Left
				Content.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content, Title_2, Toggle)

				local ToggleFunc = { Value = cftoggle.Default }

				function ToggleFunc:Set(Boolean)
					if Boolean then
						-- ON: accent rounded pill
						ToggleCheck.BackgroundColor3 = Theme.Accent
						Check.Text = "ON"
						Library:TweenInstance(Check, 0.18, "TextTransparency", 0)
					else
						-- OFF: muted pill
						ToggleCheck.BackgroundColor3 = Theme.Muted
						Library:TweenInstance(Check, 0.18, "TextTransparency", 0.6)
						Check.Text = "OFF"
					end

					self.Value = Boolean
					cftoggle.Callback(Boolean)
				end

				ToggleFunc:Set(ToggleFunc.Value)

				Toggle_Click.Activated:Connect(function()
					ToggleFunc:Set(not ToggleFunc.Value)
				end)
			end

			function SectionFunc:AddButton(cfbutton)
				local cfbutton = Library:MakeConfig({
					Title = "Button < Missing Title >",
					Description = "",
					Callback = function() end
				}, cfbutton or {})

				local Button = Instance.new("Frame")
				local UICorner_9 = Instance.new("UICorner")
				local Title_3 = Instance.new("TextLabel")
				local Button_Click = Instance.new("TextButton")
				local Content_2 = Instance.new("TextLabel")
				local ImageLabel = Instance.new("ImageLabel")

				Button.Name = "Button"
				Button.Parent = SectionList
				Button.BackgroundTransparency = 0.95
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, 0, 0, 34)
				UICorner_9.Parent = Button
				setCorner(UICorner_9, 8)

				Title_3.Name = "Title"
				Title_3.Parent = Button
				Title_3.BackgroundTransparency = 1.000
				Title_3.Position = UDim2.new(0, 10, 0, 6)
				Title_3.Size = UDim2.new(1, -80, 0, 18)
				Title_3.Font = Enum.Font.GothamBold
				Title_3.Text = cfbutton.Title
				Title_3.TextColor3 = Theme.TextPrimary
				Title_3.TextSize = 13.000
				Title_3.TextXAlignment = Enum.TextXAlignment.Left

				Button_Click.Name = "Button_Click"
				Button_Click.Parent = Button
				Button_Click.BackgroundTransparency = 1.000
				Button_Click.BorderSizePixel = 0
				Button_Click.Size = UDim2.new(1, 0, 1, 0)
				Button_Click.Text = ""
				Button_Click.TextSize = 14.000

				Content_2.Name = "Content"
				Content_2.Parent = Button
				Content_2.BackgroundTransparency = 1.000
				Content_2.Position = UDim2.new(0, 10, 0, 28)
				Content_2.Size = UDim2.new(1, -60, 1, 0)
				Content_2.Font = Enum.Font.Gotham
				Content_2.Text = cfbutton.Description
				Content_2.TextColor3 = Theme.TextSecondary
				Content_2.TextSize = 12.000
				Content_2.TextXAlignment = Enum.TextXAlignment.Left
				Content_2.TextYAlignment = Enum.TextYAlignment.Top

				ImageLabel.Parent = Button
				ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
				ImageLabel.BackgroundTransparency = 1.000
				ImageLabel.Position = UDim2.new(1, -36, 0.5, 0)
				ImageLabel.Size = UDim2.new(0, 20, 0, 20)
				ImageLabel.Image = "rbxassetid://85905776508942"
				ImageLabel.ImageColor3 = Theme.TextSecondary

				Library:UpdateContent(Content_2, Title_3, Button)

				Button_Click.Activated:Connect(function()
					Button.BackgroundTransparency = 0.98
					cfbutton.Callback()
					Library:TweenInstance(Button, 0.18, "BackgroundTransparency", 0.95)
				end)
			end

			function SectionFunc:AddDropdown(cfdropdown)
				local cfdropdown = Library:MakeConfig({
					Title = "Dropdown",
					Description = "",
					Values = {},
					Default = {},
					Multi = false,
					Callback = function() end
				}, cfdropdown or {})

				local Dropdown = Instance.new("Frame")
				local UICorner_19 = Instance.new("UICorner")
				local Title_8 = Instance.new("TextLabel")
				local Content_6 = Instance.new("TextLabel")
				local Selects = Instance.new("Frame")
				local UICorner_20 = Instance.new("UICorner")
				local SelectText = Instance.new("TextLabel")
				local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
				local Drop_Click = Instance.new("TextButton")
				local ImageLabel_2 = Instance.new("ImageLabel")
				local DropdownList = Instance.new("Frame")

				local UICorner_24 = Instance.new("UICorner")
				local Topbar = Instance.new("Frame")
				local Title_10 = Instance.new("TextLabel")
				local SearchFrame_2 = Instance.new("Frame")
				local UICorner_25 = Instance.new("UICorner")
				local IconSearch_2 = Instance.new("ImageLabel")
				local TextBox = Instance.new("TextBox")
				local Click_Dropdown = Instance.new("TextButton")
				local Icon_4 = Instance.new("ImageLabel")
				local Real_List = Instance.new("ScrollingFrame")
				local UICorner_26 = Instance.new("UICorner")
				local UIListLayout_5 = Instance.new("UIListLayout")
				local UIPadding_5 = Instance.new("UIPadding")

				Dropdown.Name = "Dropdown"
				Dropdown.Parent = SectionList
				Dropdown.BackgroundTransparency = 0.95
				Dropdown.BorderSizePixel = 0
				Dropdown.Size = UDim2.new(1, 0, 0, 34)
				UICorner_19.Parent = Dropdown
				setCorner(UICorner_19, 8)

				Title_8.Name = "Title"
				Title_8.Parent = Dropdown
				Title_8.BackgroundTransparency = 1.000
				Title_8.Position = UDim2.new(0, 10, 0, 6)
				Title_8.Size = UDim2.new(1, -90, 0, 18)
				Title_8.Font = Enum.Font.GothamBold
				Title_8.Text = cfdropdown.Title
				Title_8.TextColor3 = Theme.TextPrimary
				Title_8.TextSize = 13.000
				Title_8.TextXAlignment = Enum.TextXAlignment.Left

				Content_6.Name = "Content"
				Content_6.Parent = Dropdown
				Content_6.BackgroundTransparency = 1.000
				Content_6.Position = UDim2.new(0, 10, 0, 28)
				Content_6.Size = UDim2.new(1, -90, 1, 0)
				Content_6.Font = Enum.Font.Gotham
				Content_6.Text = cfdropdown.Description
				Content_6.TextColor3 = Theme.TextSecondary
				Content_6.TextSize = 12.000
				Content_6.TextXAlignment = Enum.TextXAlignment.Left
				Content_6.TextYAlignment = Enum.TextYAlignment.Top

				Selects.Name = "Selects"
				Selects.Parent = Dropdown
				Selects.AnchorPoint = Vector2.new(0, 0.5)
				Selects.BackgroundColor3 = Theme.Panel
				Selects.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Selects.BorderSizePixel = 0
				Selects.Position = UDim2.new(1, -98, 0.5, 0)
				Selects.Size = UDim2.new(0, 82, 0, 28)
				UICorner_20.CornerRadius = UDim.new(0, 8)
				UICorner_20.Parent = Selects

				SelectText.Name = "SelectText"
				SelectText.Parent = Selects
				SelectText.BackgroundTransparency = 1.000
				SelectText.Position = UDim2.new(0, 10, 0, 0)
				SelectText.Size = UDim2.new(1, -26, 1, 0)
				SelectText.Font = Enum.Font.Gotham
				SelectText.Text = ""
				SelectText.TextColor3 = Theme.TextPrimary
				SelectText.TextScaled = true
				SelectText.TextSize = 12.000
				SelectText.TextWrapped = true
				UITextSizeConstraint.Parent = SelectText
				UITextSizeConstraint.MaxTextSize = 12

				Drop_Click.Name = "Drop_Click"
				Drop_Click.Parent = Selects
				Drop_Click.BackgroundTransparency = 1.000
				Drop_Click.Size = UDim2.new(1, 0, 1, 0)
				Drop_Click.Font = Enum.Font.SourceSans
				Drop_Click.Text = ""
				Drop_Click.TextSize = 14.000

				ImageLabel_2.Parent = Selects
				ImageLabel_2.AnchorPoint = Vector2.new(0, 0.5)
				ImageLabel_2.BackgroundTransparency = 1.000
				ImageLabel_2.Position = UDim2.new(1, -22, 0.5, 0)
				ImageLabel_2.Size = UDim2.new(0, 14, 0, 14)
				ImageLabel_2.Image = "rbxassetid://80845745785361"
				ImageLabel_2.ImageColor3 = Theme.TextSecondary

				Library:UpdateContent(Content_6, Title_8, Dropdown)

				-- dropdown popup (keeps behavior but cleaned visuals)
				DropdownList.Name = "DropdownList"
				DropdownList.Parent = DropdownZone
				DropdownList.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownList.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
				DropdownList.BorderSizePixel = 0
				DropdownList.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownList.Size = UDim2.new(0, 380, 0, 260)
				DropdownList.Visible = false
				UICorner_24.Parent = DropdownList
				setCorner(UICorner_24, 10)

				Topbar.Name = "Topbar"
				Topbar.Parent = DropdownList
				Topbar.BackgroundTransparency = 1.000
				Topbar.BorderSizePixel = 0
				Topbar.Size = UDim2.new(1, 0, 0, 48)

				Title_10.Name = "Title"
				Title_10.Parent = Topbar
				Title_10.BackgroundTransparency = 1.000
				Title_10.Position = UDim2.new(0, 16, 0, 8)
				Title_10.Size = UDim2.new(1, -200, 1, -5)
				Title_10.Font = Enum.Font.GothamBold
				Title_10.Text = cfdropdown.Title
				Title_10.TextColor3 = Theme.TextPrimary
				Title_10.TextSize = 14.000
				Title_10.TextXAlignment = Enum.TextXAlignment.Left

				SearchFrame_2.Name = "SearchFrame"
				SearchFrame_2.Parent = Topbar
				SearchFrame_2.BackgroundColor3 = Theme.Panel
				SearchFrame_2.BorderSizePixel = 0
				SearchFrame_2.Position = UDim2.new(1, -160, 0, 8)
				SearchFrame_2.Size = UDim2.new(0, 140, 0, 32)
				UICorner_25.CornerRadius = UDim.new(0, 8)
				UICorner_25.Parent = SearchFrame_2

				IconSearch_2.Name = "IconSearch"
				IconSearch_2.Parent = SearchFrame_2
				IconSearch_2.AnchorPoint = Vector2.new(0, 0.5)
				IconSearch_2.BackgroundTransparency = 1.000
				IconSearch_2.Position = UDim2.new(0, 10, 0.5, 0)
				IconSearch_2.Size = UDim2.new(0, 14, 0, 14)
				IconSearch_2.Image = "rbxassetid://71309835376233"
				IconSearch_2.ImageColor3 = Theme.TextSecondary

				TextBox.Parent = SearchFrame_2
				TextBox.BackgroundTransparency = 1.000
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0, 34, 0, 0)
				TextBox.Size = UDim2.new(1, -40, 1, 0)
				TextBox.Font = Enum.Font.Gotham
				TextBox.PlaceholderText = "Search..."
				TextBox.Text = ""
				TextBox.TextColor3 = Theme.TextPrimary
				TextBox.TextSize = 12.000
				TextBox.TextXAlignment = Enum.TextXAlignment.Left

				Click_Dropdown.Name = "Click_Dropdown"
				Click_Dropdown.Parent = Topbar
				Click_Dropdown.BackgroundTransparency = 1.000
				Click_Dropdown.Position = UDim2.new(1, -42, 0, 8)
				Click_Dropdown.Size = UDim2.new(0, 32, 0, 32)
				Click_Dropdown.Text = ""

				Icon_4.Name = "Icon"
				Icon_4.Parent = Click_Dropdown
				Icon_4.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_4.BackgroundTransparency = 1.000
				Icon_4.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon_4.Size = UDim2.new(0, 14, 0, 14)
				Icon_4.Image = "rbxassetid://105957381820378"
				Icon_4.ImageColor3 = Theme.TextSecondary

				Real_List.Name = "Real_List"
				Real_List.Parent = DropdownList
				Real_List.BackgroundColor3 = Color3.fromRGB(245, 245, 247)
				Real_List.BorderSizePixel = 0
				Real_List.Position = UDim2.new(0, 12, 0, 54)
				Real_List.Selectable = false
				Real_List.ScrollBarThickness = 0
				Real_List.Size = UDim2.new(1, -24, 1, -66)
				Library:UpdateScrolling(Real_List, UIListLayout_5)
				UICorner_26.Parent = Real_List
				setCorner(UICorner_26, 8)

				UIListLayout_5.Parent = Real_List
				UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_5.Padding = UDim.new(0, 6)

				UIPadding_5.Parent = Real_List
				UIPadding_5.PaddingBottom = UDim.new(0, 8)
				UIPadding_5.PaddingLeft = UDim.new(0, 8)
				UIPadding_5.PaddingRight = UDim.new(0, 8)
				UIPadding_5.PaddingTop = UDim.new(0, 8)

				local UICorner_29 = Instance.new("UICorner")
				UICorner_29.Parent = DropdownZone

				Drop_Click.Activated:Connect(function()
					DropdownZone.Visible = true
					DropdownList.Visible = true
					Library:TweenInstance(DropdownZone, 0.28, "BackgroundTransparency", 0.5)
				end)

				Click_Dropdown.Activated:Connect(function()
					DropdownList.Visible = false
					Library:TweenInstance(DropdownZone, 0.28, "BackgroundTransparency", 1)
					wait(0.28)
					DropdownZone.Visible = false
				end)

				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					local InputText = TextBox.Text:lower()
					for _, item in next, Real_List:GetChildren() do
						if item:IsA("Frame") and item:FindFirstChild("Title") then
							if item.Title.Text:lower():find(InputText) then
								item.Visible = true
							else
								item.Visible = false
							end
						end
					end
				end)

				local DropFunc = { Value = {} }
				if type(cfdropdown.Default) == "string" then
					if cfdropdown.Default ~= "" then
						DropFunc.Value = {cfdropdown.Default}
					end
				elseif type(cfdropdown.Default) == "table" then
					DropFunc.Value = cfdropdown.Default
				end

				function DropFunc:Set(ignored)
					for i, v in next, Real_List:GetChildren() do
						if v:IsA("Frame") then
							if table.find(DropFunc.Value, v.Title.Text) then
								Library:TweenInstance(v, 0.22, "BackgroundTransparency", 0)
								Library:TweenInstance(v.Title, 0.22, "TextTransparency", 0)
								if v:FindFirstChild("Indicator") then v.Indicator.Visible = true end
							else
								v.BackgroundColor3 = Color3.fromRGB(245, 245, 247)
								if v:FindFirstChild("Indicator") then v.Indicator.Visible = false end
								Library:TweenInstance(v.Title, 0.22, "TextTransparency", 0.6)
							end
						end
					end

					local DropValueStr = table.concat(DropFunc.Value, ", ")
					if DropValueStr == "" then
						SelectText.Text = "None"
						SelectText.TextColor3 = Theme.TextSecondary
					else
						SelectText.Text = DropValueStr
						SelectText.TextColor3 = Theme.TextPrimary
					end
				end

				function DropFunc:Add(v)
					local Option2 = Instance.new("Frame")
					local UICorner_28 = Instance.new("UICorner")
					local Option2_Click = Instance.new("TextButton")
					local Title_12 = Instance.new("TextLabel")
					local UIGradient_3 = Instance.new("UIGradient")

					Option2.Name = "Option 2"
					Option2.Parent = Real_List
					Option2.BackgroundColor3 = Color3.fromRGB(245, 245, 247)
					Option2.BorderSizePixel = 0
					Option2.Size = UDim2.new(1, 0, 0, 36)
					UICorner_28.Parent = Option2
					setCorner(UICorner_28, 8)

					Option2_Click.Name = "Option2_Click"
					Option2_Click.Parent = Option2
					Option2_Click.BackgroundTransparency = 1.000
					Option2_Click.Size = UDim2.new(1, 0, 1, 0)
					Option2_Click.Text = ""

					Title_12.Name = "Title"
					Title_12.Parent = Option2
					Title_12.BackgroundTransparency = 1.000
					Title_12.Size = UDim2.new(1, 0, 1, 0)
					Title_12.Font = Enum.Font.Gotham
					Title_12.Text = v
					Title_12.TextColor3 = Theme.TextPrimary
					Title_12.TextSize = 13.000
					Title_12.TextTransparency = 0.6

					UIGradient_3.Color = ColorSequence.new { ColorSequenceKeypoint.new(0.00, Color3.fromRGB(250,250,250)), ColorSequenceKeypoint.new(1.00, Theme.Accent) }
					UIGradient_3.Rotation = 0.99
					UIGradient_3.Transparency = NumberSequence.new { NumberSequenceKeypoint.new(0.00, 0.7), NumberSequenceKeypoint.new(1.00, 0.7) }
					UIGradient_3.Parent = Option2

					local Indicator = Instance.new("Frame", Option2)
					Indicator.Name = "Indicator"
					Indicator.BackgroundColor3 = Theme.Accent
					Indicator.BorderSizePixel = 0
					Indicator.Position = UDim2.new(0, 0, 0, 0)
					Indicator.Size = UDim2.new(0, 4, 1, 0)
					Indicator.Visible = false
					local indCorner = Instance.new("UICorner", Indicator); indCorner.CornerRadius = UDim.new(0, 2)

					Option2_Click.Activated:Connect(function()
						local currentVal = Title_12.Text
						if cfdropdown.Multi then
							if table.find(DropFunc.Value, currentVal) then
								for i, val in pairs(DropFunc.Value) do
									if val == currentVal then
										table.remove(DropFunc.Value, i)
										break
									end
								end
							else
								table.insert(DropFunc.Value, currentVal)
							end
						else
							DropFunc.Value = {currentVal}
						end

						DropFunc:Set()
						if cfdropdown.Multi then
							cfdropdown.Callback(DropFunc.Value)
						else
							cfdropdown.Callback(DropFunc.Value[1])
						end
					end)
				end

				function DropFunc:Clear()
					for i, v in next, Real_List:GetChildren() do
						if v:IsA("Frame") then
							v:Destroy()
						end
					end
				end

				function DropFunc:Refresh(NewList)
					self:Clear()
					for i, v in next, NewList do
						self:Add(v)
					end
				end

				DropFunc:Refresh(cfdropdown.Values)
				DropFunc:Set()
				if #DropFunc.Value > 0 then
					if cfdropdown.Multi then
						cfdropdown.Callback(DropFunc.Value)
					else
						cfdropdown.Callback(DropFunc.Value[1])
					end
				end

				return DropFunc
			end

			function SectionFunc:AddInput(cftextbox)
				local cftextbox = Library:MakeConfig({
					Title = "Textbox",
					Description = "",
					PlaceHolder = "",
					Default = "",
					Callback = function() end
				}, cftextbox or {})

				local Input = Instance.new("Frame")
				local UICorner_17 = Instance.new("UICorner")
				local Title_7 = Instance.new("TextLabel")
				local Content_5 = Instance.new("TextLabel")
				local TextboxFrame = Instance.new("Frame")
				local UICorner_18 = Instance.new("UICorner")
				local RealTextBox = Instance.new("TextBox")
				local WritingIcon = Instance.new("ImageLabel")

				Input.Name = "Input"
				Input.Parent = SectionList
				Input.BackgroundTransparency = 0.95
				Input.BorderSizePixel = 0
				Input.Size = UDim2.new(1, 0, 0, 34)
				UICorner_17.Parent = Input
				setCorner(UICorner_17, 8)

				Title_7.Name = "Title"
				Title_7.Parent = Input
				Title_7.BackgroundTransparency = 1.000
				Title_7.Position = UDim2.new(0, 10, 0, 6)
				Title_7.Size = UDim2.new(1, -80, 0, 18)
				Title_7.Font = Enum.Font.GothamBold
				Title_7.Text = cftextbox.Title
				Title_7.TextColor3 = Theme.TextPrimary
				Title_7.TextSize = 13.000
				Title_7.TextXAlignment = Enum.TextXAlignment.Left

				Content_5.Name = "Content"
				Content_5.Parent = Input
				Content_5.BackgroundTransparency = 1.000
				Content_5.Position = UDim2.new(0, 10, 0, 28)
				Content_5.Size = UDim2.new(1, -160, 1, 0)
				Content_5.Font = Enum.Font.Gotham
				Content_5.Text = cftextbox.Description
				Content_5.TextColor3 = Theme.TextSecondary
				Content_5.TextSize = 12.000
				Content_5.TextXAlignment = Enum.TextXAlignment.Left
				Content_5.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content_5, Title_7, Input)

				TextboxFrame.Name = "TextboxFrame"
				TextboxFrame.Parent = Input
				TextboxFrame.AnchorPoint = Vector2.new(0, 0.5)
				TextboxFrame.BackgroundColor3 = Theme.Panel
				TextboxFrame.BorderColor3 = Color3.fromRGB(230, 230, 230)
				TextboxFrame.BorderSizePixel = 0
				TextboxFrame.Position = UDim2.new(1, -180, 0.5, 0)
				TextboxFrame.Size = UDim2.new(0, 160, 0, 30)
				UICorner_18.Parent = TextboxFrame
				setCorner(UICorner_18, 8)

				RealTextBox.Name = "RealTextBox"
				RealTextBox.Parent = TextboxFrame
				RealTextBox.BackgroundTransparency = 1.000
				RealTextBox.BorderSizePixel = 0
				RealTextBox.Position = UDim2.new(0, 38, 0, 0)
				RealTextBox.Size = UDim2.new(1, -40, 1, 0)
				RealTextBox.Font = Enum.Font.Gotham
				RealTextBox.PlaceholderText = cftextbox.PlaceHolder
				RealTextBox.Text = cftextbox.Default
				RealTextBox.TextColor3 = Theme.TextPrimary
				RealTextBox.TextSize = 13.000
				RealTextBox.TextXAlignment = Enum.TextXAlignment.Left

				WritingIcon.Name = "WritingIcon"
				WritingIcon.Parent = TextboxFrame
				WritingIcon.AnchorPoint = Vector2.new(0, 0.5)
				WritingIcon.BackgroundTransparency = 1.000
				WritingIcon.Position = UDim2.new(0, 12, 0.5, 0)
				WritingIcon.Size = UDim2.new(0, 16, 0, 16)
				WritingIcon.Image = "rbxassetid://126409600467363"
				WritingIcon.ImageColor3 = Theme.TextSecondary

				RealTextBox.FocusLost:Connect(function()
					cftextbox.Callback(RealTextBox.Text)
				end)

				cftextbox.Callback(RealTextBox.Text)
			end

			function SectionFunc:AddSlider(cfslider)
				local cfslider = Library:MakeConfig({
					Title = "Slider < Missing Title >",
					Description = "",
					Max = 100,
					Min = 1,
					Increment = 1,
					Default = 1,
					Callback = function() end
				}, cfslider or {})

				local Slider = Instance.new("Frame")
				local UICorner_10 = Instance.new("UICorner")
				local Title_4 = Instance.new("TextLabel")
				local Content_3 = Instance.new("TextLabel")
				local SliderFrame = Instance.new("Frame")
				local UICorner_11 = Instance.new("UICorner")
				local SliderDraggable = Instance.new("Frame")
				local UICorner_12 = Instance.new("UICorner")
				local Circle = Instance.new("Frame")
				local UICorner_13 = Instance.new("UICorner")
				local SliderValue = Instance.new("TextBox")
				local UICorner_14 = Instance.new("UICorner")

				Slider.Name = "Slider"
				Slider.Parent = SectionList
				Slider.BackgroundTransparency = 0.95
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(1, 0, 0, 34)

				UICorner_10.Parent = Slider
				setCorner(UICorner_10, 8)

				Title_4.Name = "Title"
				Title_4.Parent = Slider
				Title_4.BackgroundTransparency = 1.000
				Title_4.Position = UDim2.new(0, 10, 0, 6)
				Title_4.Size = UDim2.new(1, -200, 0, 18)
				Title_4.Font = Enum.Font.GothamBold
				Title_4.Text = cfslider.Title
				Title_4.TextColor3 = Theme.TextPrimary
				Title_4.TextSize = 13.000
				Title_4.TextXAlignment = Enum.TextXAlignment.Left

				Content_3.Name = "Content"
				Content_3.Parent = Slider
				Content_3.BackgroundTransparency = 1.000
				Content_3.Position = UDim2.new(0, 10, 0, 28)
				Content_3.Size = UDim2.new(1, -160, 1, 0)
				Content_3.Font = Enum.Font.Gotham
				Content_3.Text = cfslider.Description
				Content_3.TextColor3 = Theme.TextSecondary
				Content_3.TextSize = 12.000
				Content_3.TextXAlignment = Enum.TextXAlignment.Left
				Content_3.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content_3, Title_4, Slider)

				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider
				SliderFrame.AnchorPoint = Vector2.new(0, 0.5)
				SliderFrame.BackgroundColor3 = Theme.Muted
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(1, -180, 0.5, 0)
				SliderFrame.Size = UDim2.new(0, 160, 0, 8)
				UICorner_11.Parent = SliderFrame
				UICorner_11.CornerRadius = UDim.new(1, 0)

				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderFrame
				SliderDraggable.BackgroundColor3 = Theme.Accent
				SliderDraggable.BorderSizePixel = 0
				SliderDraggable.Size = UDim2.new(0, 20, 1, 0)
				UICorner_12.Parent = SliderDraggable
				UICorner_12.CornerRadius = UDim.new(1, 0)

				Circle.Name = "Circle"
				Circle.Parent = SliderDraggable
				Circle.AnchorPoint = Vector2.new(0, 0.5)
				Circle.BackgroundColor3 = Theme.Panel
				Circle.BorderSizePixel = 0
				Circle.Position = UDim2.new(1, -8, 0.5, 0)
				Circle.Size = UDim2.new(0, 14, 0, 14)
				UICorner_13.Parent = Circle
				setCorner(UICorner_13, 14)

				SliderValue.Name = "SliderValue"
				SliderValue.Parent = Slider
				SliderValue.AnchorPoint = Vector2.new(0, 0.5)
				SliderValue.BackgroundColor3 = Theme.Panel
				SliderValue.BorderSizePixel = 0
				SliderValue.Position = UDim2.new(1, -220, 0.5, 0)
				SliderValue.Size = UDim2.new(0, 44, 0, 22)
				SliderValue.Font = Enum.Font.Gotham
				SliderValue.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
				SliderValue.PlaceholderText = "..."
				SliderValue.Text = ""
				SliderValue.TextColor3 = Theme.TextPrimary
				SliderValue.TextSize = 12.000
				UICorner_14.Parent = SliderValue
				setCorner(UICorner_14, 6)

				local SliderFunc = {Value = cfslider.Default}
				local Dragging = false

				local function Round(Number, Factor)
					local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
					if Result < 0 then
						Result = Result + Factor
					end
					return Result
				end

				function SliderFunc:Set(Value)
					Value = math.clamp(Round(Value, cfslider.Increment), cfslider.Min, cfslider.Max)
					SliderFunc.Value = Value
					SliderValue.Text = tostring(Value)
					game:GetService("TweenService"):Create(
						SliderDraggable,
						TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Size = UDim2.fromScale((Value - cfslider.Min) / (cfslider.Max - cfslider.Min), 1) }
					):Play()
				end

				SliderFrame.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
					end
				end)

				SliderFrame.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
						cfslider.Callback(SliderFunc.Value)
					end
				end)

				game:GetService("UserInputService").InputChanged:Connect(function(Input)
					if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						local SizeScale = math.clamp((Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
						SliderFunc:Set(cfslider.Min + ((cfslider.Max - cfslider.Min) * SizeScale))
					end
				end)

				SliderValue:GetPropertyChangedSignal("Text"):Connect(function()
					local Valid = SliderValue.Text:gsub("[^%d]", "")
					if Valid ~= "" then
						local ValidNumber = math.min(tonumber(Valid), cfslider.Max)
						SliderValue.Text = tostring(ValidNumber)
					else
						SliderValue.Text = tostring(Valid)
					end
				end)

				SliderValue.FocusLost:Connect(function()
					if SliderValue.Text ~= "" then
						SliderFunc:Set(tonumber(SliderValue.Text))
					else
						SliderFunc:Set(0)
					end
				end)

				SliderFunc:Set(tonumber(cfslider.Default))

				return SliderFunc
			end

			function SectionFunc:AddSeperator(args)
				local Seperator = Instance.new("Frame")
				local Title_5 = Instance.new("TextLabel")

				Seperator.Name = "Seperator"
				Seperator.Parent = SectionList
				Seperator.BackgroundTransparency = 1.000
				Seperator.BorderSizePixel = 0
				Seperator.Size = UDim2.new(1, 0, 0, 28)

				Title_5.Name = "Title"
				Title_5.Parent = Seperator
				Title_5.BackgroundTransparency = 1.000
				Title_5.Position = UDim2.new(0, 10, 0, 0)
				Title_5.Size = UDim2.new(1, -10, 1, 0)
				Title_5.Font = Enum.Font.Gotham
				Title_5.Text = args
				Title_5.TextColor3 = Theme.TextSecondary
				Title_5.TextSize = 13.000
				Title_5.TextXAlignment = Enum.TextXAlignment.Left
			end

			function SectionFunc:AddParagraph(cfpara)
				local cfpara = Library:MakeConfig({
					Title = "Paragraph < Missing Title >",
					Content = ""
				}, cfpara or {})

				local Paragraph = Instance.new("Frame")
				local UICorner_16 = Instance.new("UICorner")
				local Title_6 = Instance.new("TextLabel")
				local Content_4 = Instance.new("TextLabel")
				local ParaFunc = {}

				Paragraph.Name = "Paragraph"
				Paragraph.Parent = SectionList
				Paragraph.BackgroundTransparency = 0.95
				Paragraph.BorderSizePixel = 0
				Paragraph.Size = UDim2.new(1, 0, 0, 56)
				UICorner_16.Parent = Paragraph
				setCorner(UICorner_16, 8)

				Title_6.Name = "Title"
				Title_6.Parent = Paragraph
				Title_6.BackgroundTransparency = 1.000
				Title_6.Position = UDim2.new(0, 10, 0, 8)
				Title_6.Size = UDim2.new(1, -60, 0, 18)
				Title_6.Font = Enum.Font.GothamBold
				Title_6.Text = cfpara.Title
				Title_6.TextColor3 = Theme.TextPrimary
				Title_6.TextSize = 13.000
				Title_6.TextXAlignment = Enum.TextXAlignment.Left

				Content_4.Name = "Content"
				Content_4.Parent = Paragraph
				Content_4.BackgroundTransparency = 1.000
				Content_4.Position = UDim2.new(0, 10, 0, 28)
				Content_4.Size = UDim2.new(1, -10, 1, 0)
				Content_4.Font = Enum.Font.Gotham
				Content_4.Text = cfpara.Content
				Content_4.TextColor3 = Theme.TextSecondary
				Content_4.TextSize = 12.000
				Content_4.TextXAlignment = Enum.TextXAlignment.Left
				Content_4.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content_4, Title_6, Paragraph)

				function ParaFunc:SetTitle(args)
					Title_6.Text = args
				end

				function ParaFunc:SetDesc(args)
					Content_4.Text = args
				end

				return ParaFunc
			end

			function SectionFunc:AddDiscord(DiscordTitle, InviteCode)
				local DiscordCard = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local Icon = Instance.new("ImageLabel")
				local Title = Instance.new("TextLabel")
				local SubTitle = Instance.new("TextLabel")
				local JoinBtn = Instance.new("TextButton")
				local BtnCorner = Instance.new("UICorner")

				DiscordCard.Name = "DiscordCard"
				DiscordCard.Parent = SectionList 
				DiscordCard.BackgroundColor3 = Theme.Panel
				DiscordCard.BackgroundTransparency = 0.02
				DiscordCard.BorderSizePixel = 0
				DiscordCard.Size = UDim2.new(1, 0, 0, 70)

				UICorner.CornerRadius = UDim.new(0, 10)
				UICorner.Parent = DiscordCard

				Icon.Parent = DiscordCard
				Icon.BackgroundTransparency = 1
				Icon.Position = UDim2.new(0, 12, 0, 12)
				Icon.Size = UDim2.new(0, 46, 0, 46)
				Icon.Image = "rbxassetid://123256573634"
				Icon.ImageColor3 = Theme.Accent

				Title.Parent = DiscordCard
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 72, 0, 18)
				Title.Size = UDim2.new(1, -170, 0, 20)
				Title.Font = Enum.Font.GothamBold
				Title.Text = DiscordTitle or "Community"
				Title.TextColor3 = Theme.TextPrimary
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left

				SubTitle.Parent = DiscordCard
				SubTitle.BackgroundTransparency = 1
				SubTitle.Position = UDim2.new(0, 72, 0, 38)
				SubTitle.Size = UDim2.new(1, -170, 0, 16)
				SubTitle.Font = Enum.Font.Gotham
				SubTitle.Text = "Click to join the server"
				SubTitle.TextColor3 = Theme.TextSecondary
				SubTitle.TextSize = 12
				SubTitle.TextXAlignment = Enum.TextXAlignment.Left

				JoinBtn.Name = "JoinBtn"
				JoinBtn.Parent = DiscordCard
				JoinBtn.BackgroundColor3 = Theme.Accent
				JoinBtn.Position = UDim2.new(1, -92, 0, 20)
				JoinBtn.Size = UDim2.new(0, 72, 0, 30)
				JoinBtn.Font = Enum.Font.GothamBold
				JoinBtn.Text = "Join"
				JoinBtn.TextColor3 = Color3.fromRGB(255,255,255)
				JoinBtn.TextSize = 13

				BtnCorner.CornerRadius = UDim.new(0, 8)
				BtnCorner.Parent = JoinBtn

				JoinBtn.MouseButton1Click:Connect(function()
					if setclipboard then 
                        setclipboard("https://discord.gg/" .. InviteCode) 
                    end
					local req = (syn and syn.request) or (http and http.request) or http_request or request
					if req then
						pcall(function()
							req({
								Url = "http://127.0.0.1:6463/rpc?v=1",
								Method = "POST",
								Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
								Body = game:GetService("HttpService"):JSONEncode({
									cmd = "INVITE_BROWSER",
									nonce = game:GetService("HttpService"):GenerateGUID(false),
									args = { code = InviteCode }
								})
							})
						end)
					end
					JoinBtn.Text = "Copied!"
					task.wait(1.6)
					JoinBtn.Text = "Join"
				end)
			end

			return SectionFunc
		end

		return TabFunc
	end

	local G2L = {};
	G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
	G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

	G2L["2"] = Instance.new("ImageButton", G2L["1"]);
	G2L["2"]["BorderSizePixel"] = 0;
	G2L["2"].Visible = true
	self:MakeDraggable(G2L["2"],G2L["2"])
	G2L["2"]["BackgroundColor3"] = Theme.Panel;
	G2L["2"]["Image"] = [[rbxassetid://101817370702077]];
	G2L["2"]["Size"] = UDim2.new(0, 52, 0, 52);
	G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	G2L["2"]["AnchorPoint"] = Vector2.new(0, 0)
	G2L["2"]["Position"] = UDim2.new(0, 30, 0, 30)
	G2L["3"] = Instance.new("UICorner", G2L["2"]);
	G2L["3"]["CornerRadius"] = UDim.new(1, 0);
	G2L["4"] = Instance.new("UIStroke", G2L["2"]);
	G2L["4"]["Thickness"] = 1.5;
	G2L["4"]["Color"] = Color3.fromRGB(235, 235, 235);

	G2L["2"].MouseButton1Click:Connect(function()
		TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled
	end)

	Minize.MouseButton1Click:Connect(function()
		TeddyUI_Premium.Enabled = false
	end)

	return Tab
end

return Library
