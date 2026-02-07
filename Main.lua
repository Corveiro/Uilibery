local Library = {}

local T1UIColor = {
	["Border Color"] = Color3.fromRGB(212, 161, 255),
	["Click Effect Color"] = Color3.fromRGB(230, 230, 230),
	["Setting Icon Color"] = Color3.fromRGB(230, 230, 230),
	["Logo Image"] = "rbxassetid://135300070242371",
	["Search Icon Color"] = Color3.fromRGB(255, 255, 255),
	["Search Icon Highlight Color"] = Color3.fromRGB(212, 161, 255),
	["GUI Text Color"] = Color3.fromRGB(230, 230, 230),
	["Text Color"] = Color3.fromRGB(230, 230, 230),
	["Placeholder Text Color"] = Color3.fromRGB(178, 178, 178),
	["Title Text Color"] = Color3.fromRGB(212, 161, 255),
	["Background Main Color"] = Color3.fromRGB(43, 43, 43),
	["Background 1 Color"] = Color3.fromRGB(30,30,30),
	["Background 1 Transparency"] = 0.5,
	["Background 2 Color"] = Color3.fromRGB(90, 90, 90),
	["Background 3 Color"] = Color3.fromRGB(53, 53, 53),
	["Background Image"] = "",
	["Page Selected Color"] = Color3.fromRGB(212, 161, 255),
	["Section Text Color"] = Color3.fromRGB(212, 161, 255),
	["Section Underline Color"] = Color3.fromRGB(212, 161, 255),
	["Toggle Border Color"] = Color3.fromRGB(212, 161, 255),
	["Toggle Checked Color"] = Color3.fromRGB(230, 230, 230),
	["Toggle Desc Color"] = Color3.fromRGB(185, 185, 185),
	["Button Color"] = Color3.fromRGB(212, 161, 255),
	["Label Color"] = Color3.fromRGB(255, 46, 46),
	["Dropdown Icon Color"] = Color3.fromRGB(230, 230, 230),
	["Dropdown Selected Color"] = Color3.fromRGB(212, 161, 255),
	["Dropdown Selected Check Color"] = Color3.fromRGB(219, 64, 64),
	["Textbox Highlight Color"] = Color3.fromRGB(212, 161, 255),
	["Box Highlight Color"] = Color3.fromRGB(212, 161, 255),
	["Slider Line Color"] = Color3.fromRGB(75, 75, 75),
	["Slider Highlight Color"] = Color3.fromRGB(194, 25, 25),
	["Tween Animation 1 Speed"] = 0.25,
	["Tween Animation 2 Speed"] = 0.5,
	["Tween Animation 3 Speed"] = 0.1,
	["Text Stroke Transparency"] = .5
}

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
		local Tween = game:GetService("TweenService"):Create(object, TweenInfo.new(0.2), { Position = pos })
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
	local UIStroke = Instance.new("UIStroke")
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

	TeddyUI_Premium.Name = "TeddyUI_Premium"
	TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = TeddyUI_Premium
	DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadowHolder.BackgroundTransparency = 1.000
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadowHolder.Size = UDim2.new(0, 555, 0, 350)
	DropShadowHolder.ZIndex = 0

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.500
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	Main.Name = "Main"
	Main.Parent = DropShadowHolder
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 555, 0, 350)
	Main.BorderSizePixel = 0
	Main.BorderColor3 = T1UIColor["Border Color"]
	Main.ClipsDescendants = true
	Main.BackgroundColor3 = T1UIColor["Background Main Color"]
	Main.BackgroundTransparency = 0
	Main.Image = T1UIColor["Background Image"]
	Main.ScaleType = Enum.ScaleType.Crop

	UICorner.Parent = Main

	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = T1UIColor["Background 1 Color"]
	Top.BackgroundTransparency = T1UIColor["Background 1 Transparency"]
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 50)

	Line.Name = "Line"
	Line.Parent = Top
	Line.BackgroundColor3 = T1UIColor["Border Color"]
	Line.BackgroundTransparency = 0
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 0, 1, -1)
	Line.Size = UDim2.new(1, 0, 0, 1)
	Line.Visible = true

	Left.Name = "Left"
	Left.Parent = Top

	NameHub.Name = "NameHub"
	NameHub.Parent = Left
	NameHub.BackgroundTransparency = 1.000
	NameHub.Position = UDim2.new(0, 60, 0, 10)
	NameHub.Size = UDim2.new(0, 470, 0, 20)
	NameHub.Font = Enum.Font.GothamBold
	NameHub.Text = ConfigWindow.Title
	NameHub.TextColor3 = T1UIColor["Title Text Color"]
	NameHub.TextSize = 14.000
	NameHub.TextXAlignment = Enum.TextXAlignment.Left

	LogoHub.Name = "LogoHub"
	LogoHub.Parent = Left
	LogoHub.BackgroundTransparency = 1.000
	LogoHub.Position = UDim2.new(0, 10, 0, 5)
	LogoHub.Size = UDim2.new(0, 40, 0, 35)
	LogoHub.Image = T1UIColor["Logo Image"]

	Desc.Name = "Desc"
	Desc.Parent = Left
	Desc.BackgroundTransparency = 1.000
	Desc.Position = UDim2.new(0, 60, 0, 27)
	Desc.Size = UDim2.new(0, 470, 1, -30)
	Desc.Font = Enum.Font.GothamBold
	Desc.Text = ConfigWindow.Description
	Desc.TextColor3 = T1UIColor["GUI Text Color"]
	Desc.TextSize = 12.000
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextYAlignment = Enum.TextYAlignment.Top

	Right.Name = "Right"
	Right.Parent = Top

	Frame.Parent = Right
	Frame.BackgroundTransparency = 1.000
	Frame.Position = UDim2.new(1, -110, 0, 0)
	Frame.Size = UDim2.new(0, 110, 1, 0)

	UIListLayout.Parent = Frame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 6)

	UIPadding.Parent = Frame
	UIPadding.PaddingTop = UDim.new(0, 10)

	Minize.Name = "Minize"
	Minize.Parent = Frame
	Minize.BackgroundTransparency = 1.000
	Minize.Size = UDim2.new(0, 30, 0, 30)
	Minize.Text = ""

	Icon.Name = "Icon"
	Icon.Parent = Minize
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1.000
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.Image = "rbxassetid://136452605242985"
	Icon.ImageColor3 = T1UIColor["Setting Icon Color"]
	Icon.ImageRectOffset = Vector2.new(288, 672)
	Icon.ImageRectSize = Vector2.new(96, 96)

	Large.Name = "Large"
	Large.Parent = Frame
	Large.BackgroundTransparency = 1.000
	Large.Size = UDim2.new(0, 30, 0, 30)
	Large.Text = ""

	Icon_2.Name = "Icon"
	Icon_2.Parent = Large
	Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon_2.BackgroundTransparency = 1.000
	Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon_2.Size = UDim2.new(0, 18, 0, 18)
	Icon_2.Image = "rbxassetid://136452605242985"
	Icon_2.ImageColor3 = T1UIColor["Setting Icon Color"]
	Icon_2.ImageRectOffset = Vector2.new(580, 194)
	Icon_2.ImageRectSize = Vector2.new(96, 96)

	Close.Name = "Close"
	Close.Parent = Frame
	Close.BackgroundTransparency = 1.000
	Close.Size = UDim2.new(0, 30, 0, 30)
	Close.Text = ""
	Close.MouseButton1Down:Connect(function()
		DropdownZone.Visible = true
		local tat_ = Instance.new("Frame", DropdownZone);
		tat_["BorderSizePixel"] = 0;
		tat_["BackgroundColor3"] = T1UIColor["Background 1 Color"];
		tat_["BackgroundTransparency"] = T1UIColor["Background 1 Transparency"];
		tat_["AnchorPoint"] = Vector2.new(0.5, 0.5);
		tat_["Size"] = UDim2.new(0, 400, 0, 150);
		tat_["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		tat_["BorderColor3"] = T1UIColor["Border Color"];
		tat_["Name"] = [[Tat]];
		local suacc = Instance.new("UIStroke", tat_);
		suacc["Transparency"] = 0;
		suacc["Color"] = T1UIColor["Border Color"];
		local suacc = Instance.new("UICorner", tat_);
		suacc["CornerRadius"] = UDim.new(0, 5);
		local suacc2 = Instance.new("TextLabel", tat_);
		suacc2["BorderSizePixel"] = 0;
		suacc2["TextSize"] = 20;
		suacc2["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);
		suacc2["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		suacc2["TextColor3"] = T1UIColor["Text Color"];
		suacc2["BackgroundTransparency"] = 1;
		suacc2["Size"] = UDim2.new(0, 400, 0, 50);
		suacc2["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		suacc2["Text"] = [[Are you sure]];
		local btnyes = Instance.new("TextButton", tat_);
		btnyes["BorderSizePixel"] = 0;
		btnyes["TextSize"] = 25;
		btnyes["TextColor3"] = T1UIColor["Text Color"];
		btnyes["BackgroundColor3"] = T1UIColor["Background Main Color"];
		btnyes["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		btnyes["AnchorPoint"] = Vector2.new(0, 1);
		btnyes["Size"] = UDim2.new(0, 150, 0, 50);
		btnyes["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		btnyes["Text"] = [[Yes]];
		btnyes["Position"] = UDim2.new(0, 40, 1, -40);
		btnyes.MouseButton1Down:Connect(function()
			TeddyUI_Premium:Destroy()
		end)
		local thuaaa = Instance.new("UICorner", btnyes);
		local thuaaa = Instance.new("UIStroke", btnyes);
		thuaaa["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
		thuaaa["Color"] = T1UIColor["Border Color"];
		local btnno = Instance.new("TextButton", tat_);
		btnno["BorderSizePixel"] = 0;
		btnno["TextSize"] = 25;
		btnno["TextColor3"] = T1UIColor["Text Color"];
		btnno["BackgroundColor3"] = T1UIColor["Background Main Color"];
		btnno["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		btnno["AnchorPoint"] = Vector2.new(1, 1);
		btnno["Size"] = UDim2.new(0, 150, 0, 50);
		btnno["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		btnno["Text"] = [[No]];
		btnno["Position"] = UDim2.new(1, -40, 1, -40);
		btnno.MouseButton1Down:Connect(function()
			tat_:Destroy()
			DropdownZone.Visible = false
		end)
		local thuaa = Instance.new("UICorner", btnno);
		local thuaa = Instance.new("UIStroke", btnno);
		thuaa["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
		thuaa["Color"] = T1UIColor["Border Color"];
	end)

	Icon_3.Name = "Icon"
	Icon_3.Parent = Close
	Icon_3.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon_3.BackgroundTransparency = 1.000
	Icon_3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon_3.Size = UDim2.new(0, 20, 0, 20)
	Icon_3.Image = "rbxassetid://105957381820378"
	Icon_3.ImageColor3 = T1UIColor["Setting Icon Color"]
	Icon_3.ImageRectOffset = Vector2.new(480, 0)
	Icon_3.ImageRectSize = Vector2.new(96, 96)

	UIStroke.Parent = Main
	UIStroke.Color = T1UIColor["Border Color"]
	UIStroke.Transparency = 0
	UIStroke.Thickness = 1.2

	TabFrame.Name = "TabFrame"
	TabFrame.Parent = Main
	TabFrame.BackgroundColor3 = T1UIColor["Background 1 Color"]
	TabFrame.BackgroundTransparency = T1UIColor["Background 1 Transparency"]
	TabFrame.Position = UDim2.new(0, 0, 0, 50)
	TabFrame.Size = UDim2.new(0, 144, 1, -50)

	Line_2.Name = "Line"
	Line_2.Parent = TabFrame
	Line_2.BackgroundColor3 = T1UIColor["Border Color"]
	Line_2.Position = UDim2.new(1, -1, 0, 0)
	Line_2.Size = UDim2.new(0, 1, 1, 0)
	Line_2.Visible = true

	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = TabFrame
	SearchFrame.BackgroundColor3 = T1UIColor["Background 2 Color"]
	SearchFrame.Position = UDim2.new(0, 7, 0, 10)
	SearchFrame.Size = UDim2.new(1, -14, 0, 30)

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = SearchFrame

	IconSearch.Name = "IconSearch"
	IconSearch.Parent = SearchFrame
	IconSearch.AnchorPoint = Vector2.new(0, 0.5)
	IconSearch.BackgroundTransparency = 1.000
	IconSearch.Position = UDim2.new(0, 10, 0.5, 0)
	IconSearch.Size = UDim2.new(0, 15, 0, 15)
	IconSearch.Image = "rbxassetid://71309835376233"
	IconSearch.ImageColor3 = T1UIColor["Search Icon Color"]

	SearchBox.Name = "SearchBox"
	SearchBox.Parent = SearchFrame
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.Position = UDim2.new(0, 35, 0, 0)
	SearchBox.Size = UDim2.new(1, -35, 1, 0)
	SearchBox.Font = Enum.Font.GothamBold
	SearchBox.PlaceholderText = "Search"
	SearchBox.PlaceholderColor3 = T1UIColor["Placeholder Text Color"]
	SearchBox.Text = ""
	SearchBox.TextColor3 = T1UIColor["Text Color"]
	SearchBox.TextSize = 13.000
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	ScrollingTab.Name = "ScrollingTab"
	ScrollingTab.Parent = TabFrame
	ScrollingTab.BackgroundTransparency = 1.000
	ScrollingTab.Position = UDim2.new(0, 0, 0, 50)
	ScrollingTab.Size = UDim2.new(1, 0, 1, -50)
	ScrollingTab.ScrollBarThickness = 2
	ScrollingTab.ScrollBarImageColor3 = T1UIColor["Border Color"]

	self:UpdateScrolling(ScrollingTab, UIListLayout_2)
	UIPadding_2.Parent = ScrollingTab
	UIPadding_2.PaddingBottom = UDim.new(0, 3)
	UIPadding_2.PaddingLeft = UDim.new(0, 7)
	UIPadding_2.PaddingRight = UDim.new(0, 7)
	UIPadding_2.PaddingTop = UDim.new(0, 3)
	UIListLayout_2.Parent = ScrollingTab
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.Padding = UDim.new(0, 10)

	LayoutFrame.Name = "LayoutFrame"
	LayoutFrame.Parent = Main
	LayoutFrame.BackgroundTransparency = 1.000
	LayoutFrame.Position = UDim2.new(0, 144, 0, 50)
	LayoutFrame.Size = UDim2.new(1, -144, 1, -50)
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
	UIPageLayout.TweenTime = T1UIColor["Tween Animation 1 Speed"]

	LayoutName.Name = "LayoutName"
	LayoutName.Parent = LayoutFrame
	LayoutName.BackgroundTransparency = 1.000
	LayoutName.Size = UDim2.new(1, 0, 0, 40)

	TextLabel.Parent = LayoutName
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Size = UDim2.new(1, -10, 1, 0)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = ""
	TextLabel.TextColor3 = T1UIColor["Title Text Color"]
	TextLabel.TextSize = 13.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	DropdownZone.Name = "DropdownZone"
	DropdownZone.Parent = Main
	DropdownZone.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	DropdownZone.BackgroundTransparency = 1
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
		local UIListLayout_3 = Instance.new("UIListLayout")
		local TabIcon = Instance.new("ImageLabel")
		local IconRound = Instance.new("UICorner")
		local UIPadding_3 = Instance.new("UIPadding")

		TabDisable.Name = "TabDisable"
		TabDisable.Parent = ScrollingTab
		TabDisable.BackgroundTransparency = 1.000
		TabDisable.Size = UDim2.new(1, 0, 0, 25)

		Choose_2.Name = "Choose"
		Choose_2.Parent = TabDisable
		Choose_2.BackgroundColor3 = T1UIColor["Page Selected Color"]
		Choose_2.Position = UDim2.new(0, 0, 0, 5)
		Choose_2.Size = UDim2.new(0, 4, 0, 15)
		Choose_2.Visible = false
		UICorner_4.CornerRadius = UDim.new(1, 0)
		UICorner_4.Parent = Choose_2

		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabDisable
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.Position = UDim2.new(0, 12, 0.5, 0)
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.Size = UDim2.new(0, 14, 0, 14) 
		TabIcon.ImageColor3 = T1UIColor["Text Color"]
		IconRound.Parent = TabIcon
		IconRound.CornerRadius = UDim.new(0, 4)

		local NamePosX = 15
		if iconid and tostring(iconid) ~= "" then
			TabIcon.Image = iconid
			TabIcon.Visible = true
			NamePosX = 35
		else
			TabIcon.Image = ""
			TabIcon.Visible = false
			NamePosX = 15
		end

		NameTab_2.Name = "NameTab"
		NameTab_2.Parent = TabDisable
		NameTab_2.BackgroundTransparency = 1.000
		NameTab_2.Position = UDim2.new(0, NamePosX, 0, 0)
		NameTab_2.Size = UDim2.new(1, -NamePosX, 1, 0)
		NameTab_2.Font = Enum.Font.GothamBold
		NameTab_2.Text = t
		NameTab_2.TextColor3 = T1UIColor["Text Color"]
		NameTab_2.TextSize = 12.000
		NameTab_2.TextTransparency = 0.300
		NameTab_2.TextXAlignment = Enum.TextXAlignment.Left

		Click_Tab_2.Name = "Click_Tab"
		Click_Tab_2.Parent = TabDisable
		Click_Tab_2.BackgroundTransparency = 1.000
		Click_Tab_2.Size = UDim2.new(1, 0, 1, 0)
		Click_Tab_2.Text = ""

		Layout.Name = "Layout"
		Layout.Parent = LayoutList
		Layout.BackgroundTransparency = 1.000
		Layout.Size = UDim2.new(1, 0, 1, 0)
		Layout.CanvasSize = UDim2.new(0, 0, 1, 0)
		Layout.ScrollBarThickness = 2
		Layout.ScrollBarImageColor3 = T1UIColor["Border Color"]
		Layout.LayoutOrder = AllLayouts

		Library:UpdateScrolling(Layout, UIListLayout_3)
		UIPadding_3.Parent = Layout
		UIPadding_3.PaddingBottom = UDim.new(0, 7)
		UIPadding_3.PaddingLeft = UDim.new(0, 10)
		UIPadding_3.PaddingRight = UDim.new(0, 7)
		UIListLayout_3.Parent = Layout
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 10)

		if AllLayouts == 0 then
			NameTab_2.TextTransparency = 0
			Choose_2.Visible = true
			if TabIcon.Visible then TabIcon.ImageTransparency = 0 end
			UIPageLayout:JumpToIndex(0)
			TextLabel.Text = t
		else
			if TabIcon.Visible then TabIcon.ImageTransparency = 0.5 end
		end

		Click_Tab_2.Activated:Connect(function()
			TextLabel.Text = t
			for i, v in next, ScrollingTab:GetChildren() do
				if v:IsA("Frame") then
					Library:TweenInstance(v.NameTab, 0.3, "TextTransparency", 0.3)
					if v:FindFirstChild("TabIcon") then
						Library:TweenInstance(v.TabIcon, 0.3, "ImageTransparency", 0.5)
					end
					v.Choose.Visible = false
				end
			end
			Library:TweenInstance(NameTab_2, 0.2, "TextTransparency", 0)
			if TabIcon.Visible then Library:TweenInstance(TabIcon, 0.2, "ImageTransparency", 0) end
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
			local SectionList = Instance.new("Frame")
			local UIListLayout_4 = Instance.new("UIListLayout")
			local UIPadding_4 = Instance.new("UIPadding")

			Section.Name = "Section"
			Section.Parent = Layout
			Section.BackgroundColor3 = T1UIColor["Background 3 Color"]
			Section.Size = UDim2.new(1, 0, 0, 55)
			UICorner_5.CornerRadius = UDim.new(0, 6)
			UICorner_5.Parent = Section

			NameSection.Name = "NameSection"
			NameSection.Parent = Section
			NameSection.BackgroundTransparency = 1.000
			NameSection.Size = UDim2.new(1, 0, 0, 35)

			Title.Name = "Title"
			Title.Parent = NameSection
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 0, 0, 5)
			Title.Size = UDim2.new(1, 0, 1, -5)
			Title.Font = Enum.Font.GothamBold
			Title.Text = RealNameSection
			Title.TextColor3 = T1UIColor["Section Text Color"]
			Title.TextSize = 15.000

			Line_3.Name = "Line"
			Line_3.Parent = NameSection
			Line_3.BackgroundColor3 = T1UIColor["Section Underline Color"]
			Line_3.BorderSizePixel = 0
			Line_3.Position = UDim2.new(0.5, -25, 1, -2)
			Line_3.Size = UDim2.new(0, 50, 0, 2)

			SectionList.Name = "SectionList"
			SectionList.Parent = Section
			SectionList.BackgroundTransparency = 1.000
			SectionList.Position = UDim2.new(0, 0, 0, 35)
			SectionList.Size = UDim2.new(1, 0, 1, -35)
			UIListLayout_4.Parent = SectionList
			UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_4.Padding = UDim.new(0, 5)
			UIPadding_4.Parent = SectionList
			UIPadding_4.PaddingBottom = UDim.new(0, 5)
			UIPadding_4.PaddingLeft = UDim.new(0, 5)
			UIPadding_4.PaddingRight = UDim.new(0, 5)
			UIPadding_4.PaddingTop = UDim.new(0, 5)

			UIListLayout_4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, 0, 0, UIListLayout_4.AbsoluteContentSize.Y + 45)
			end)

			local SectionFunc = {}

			function SectionFunc:AddToggle(cftoggle)
				local cftoggle = Library:MakeConfig({
					Title = "Toggle < Missing Title >",
					Default = false,
					Callback = function() end
				}, cftoggle or {})
				local Toggle = Instance.new("Frame")
				local UICorner_6 = Instance.new("UICorner")
				local Title_2 = Instance.new("TextLabel")
				local ToggleCheck = Instance.new("Frame")
				local UICorner_7 = Instance.new("UICorner")
				local UIStroke_2 = Instance.new("UIStroke")
				local Toggle_Click = Instance.new("TextButton")

				Toggle.Name = "Toggle"
				Toggle.Parent = SectionList
				Toggle.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Toggle.Size = UDim2.new(1, 0, 0, 35)
				UICorner_6.CornerRadius = UDim.new(0, 6)
				UICorner_6.Parent = Toggle

				Title_2.Name = "Title"
				Title_2.Parent = Toggle
				Title_2.BackgroundTransparency = 1.000
				Title_2.Position = UDim2.new(0, 10, 0, 0)
				Title_2.Size = UDim2.new(1, -10, 1, 0)
				Title_2.Font = Enum.Font.GothamBold
				Title_2.Text = cftoggle.Title
				Title_2.TextColor3 = T1UIColor["Text Color"]
				Title_2.TextSize = 13.000
				Title_2.TextXAlignment = Enum.TextXAlignment.Left

				ToggleCheck.Name = "ToggleCheck"
				ToggleCheck.Parent = Toggle
				ToggleCheck.BackgroundColor3 = T1UIColor["Background Main Color"]
				ToggleCheck.Position = UDim2.new(1, -30, 0.5, -8)
				ToggleCheck.Size = UDim2.new(0, 16, 0, 16)
				UICorner_7.CornerRadius = UDim.new(0, 4)
				UICorner_7.Parent = ToggleCheck
				UIStroke_2.Parent = ToggleCheck
				UIStroke_2.Color = T1UIColor["Toggle Border Color"]
				UIStroke_2.Thickness = 1.2

				Toggle_Click.Name = "Toggle_Click"
				Toggle_Click.Parent = Toggle
				Toggle_Click.BackgroundTransparency = 1.000
				Toggle_Click.Size = UDim2.new(1, 0, 1, 0)
				Toggle_Click.Text = ""

				local Toggled = cftoggle.Default
				local function UpdateToggle()
					if Toggled then
						Library:TweenInstance(ToggleCheck, 0.2, "BackgroundColor3", T1UIColor["Toggle Checked Color"])
						Library:TweenInstance(UIStroke_2, 0.2, "Color", T1UIColor["Toggle Checked Color"])
					else
						Library:TweenInstance(ToggleCheck, 0.2, "BackgroundColor3", T1UIColor["Background Main Color"])
						Library:TweenInstance(UIStroke_2, 0.2, "Color", T1UIColor["Toggle Border Color"])
					end
					cftoggle.Callback(Toggled)
				end
				Toggle_Click.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					UpdateToggle()
				end)
				UpdateToggle()
				local ToggleFunc = {}
				function ToggleFunc:Set(v) Toggled = v UpdateToggle() end
				return ToggleFunc
			end

			function SectionFunc:AddButton(cfbutton)
				local cfbutton = Library:MakeConfig({
					Title = "Button < Missing Title >",
					Callback = function() end
				}, cfbutton or {})
				local Button = Instance.new("Frame")
				local UICorner_8 = Instance.new("UICorner")
				local Title_3 = Instance.new("TextLabel")
				local Button_Click = Instance.new("TextButton")

				Button.Name = "Button"
				Button.Parent = SectionList
				Button.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Button.Size = UDim2.new(1, 0, 0, 35)
				UICorner_8.CornerRadius = UDim.new(0, 6)
				UICorner_8.Parent = Button

				Title_3.Name = "Title"
				Title_3.Parent = Button
				Title_3.BackgroundTransparency = 1.000
				Title_3.Position = UDim2.new(0, 10, 0, 0)
				Title_3.Size = UDim2.new(1, -10, 1, 0)
				Title_3.Font = Enum.Font.GothamBold
				Title_3.Text = cfbutton.Title
				Title_3.TextColor3 = T1UIColor["Text Color"]
				Title_3.TextSize = 13.000
				Title_3.TextXAlignment = Enum.TextXAlignment.Left

				Button_Click.Name = "Button_Click"
				Button_Click.Parent = Button
				Button_Click.BackgroundTransparency = 1.000
				Button_Click.Size = UDim2.new(1, 0, 1, 0)
				Button_Click.Text = ""
				Button_Click.MouseButton1Click:Connect(function()
					Library:TweenInstance(Button, 0.1, "BackgroundColor3", T1UIColor["Click Effect Color"])
					wait(0.1)
					Library:TweenInstance(Button, 0.2, "BackgroundColor3", T1UIColor["Background 1 Color"])
					cfbutton.Callback()
				end)
			end

			function SectionFunc:AddSlider(cfslider)
				local cfslider = Library:MakeConfig({
					Title = "Slider < Missing Title >",
					Min = 0,
					Max = 100,
					Default = 50,
					Callback = function() end
				}, cfslider or {})
				local Slider = Instance.new("Frame")
				local UICorner_9 = Instance.new("UICorner")
				local Title_4 = Instance.new("TextLabel")
				local SliderFrame = Instance.new("Frame")
				local UICorner_10 = Instance.new("UICorner")
				local SliderDraggable = Instance.new("Frame")
				local UICorner_11 = Instance.new("UICorner")
				local SliderValue = Instance.new("TextBox")

				Slider.Name = "Slider"
				Slider.Parent = SectionList
				Slider.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Slider.Size = UDim2.new(1, 0, 0, 45)
				UICorner_9.CornerRadius = UDim.new(0, 6)
				UICorner_9.Parent = Slider

				Title_4.Name = "Title"
				Title_4.Parent = Slider
				Title_4.BackgroundTransparency = 1.000
				Title_4.Position = UDim2.new(0, 10, 0, 5)
				Title_4.Size = UDim2.new(1, -60, 0, 16)
				Title_4.Font = Enum.Font.GothamBold
				Title_4.Text = cfslider.Title
				Title_4.TextColor3 = T1UIColor["Text Color"]
				Title_4.TextSize = 13.000
				Title_4.TextXAlignment = Enum.TextXAlignment.Left

				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider
				SliderFrame.BackgroundColor3 = T1UIColor["Slider Line Color"]
				SliderFrame.Position = UDim2.new(0, 10, 1, -12)
				SliderFrame.Size = UDim2.new(1, -60, 0, 4)
				UICorner_10.CornerRadius = UDim.new(0, 2)
				UICorner_10.Parent = SliderFrame

				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderFrame
				SliderDraggable.BackgroundColor3 = T1UIColor["Slider Highlight Color"]
				SliderDraggable.Size = UDim2.new(0, 0, 1, 0)
				UICorner_11.CornerRadius = UDim.new(0, 2)
				UICorner_11.Parent = SliderDraggable

				SliderValue.Name = "SliderValue"
				SliderValue.Parent = Slider
				SliderValue.BackgroundTransparency = 1.000
				SliderValue.Position = UDim2.new(1, -45, 0, 10)
				SliderValue.Size = UDim2.new(0, 35, 0, 25)
				SliderValue.Font = Enum.Font.GothamBold
				SliderValue.Text = tostring(cfslider.Default)
				SliderValue.TextColor3 = T1UIColor["Text Color"]
				SliderValue.TextSize = 12.000

				local Mouse = game.Players.LocalPlayer:GetMouse()
				local UserInputService = game:GetService("UserInputService")
				local Dragging = false
				local function UpdateSlider()
					local Percentage = math.clamp((Mouse.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
					local Value = math.floor(((cfslider.Max - cfslider.Min) * Percentage) + cfslider.Min)
					SliderValue.Text = tostring(Value)
					SliderDraggable.Size = UDim2.new(Percentage, 0, 1, 0)
					cfslider.Callback(Value)
				end
				SliderFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true UpdateSlider() end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider() end
				end)
				local DefaultPercentage = (cfslider.Default - cfslider.Min) / (cfslider.Max - cfslider.Min)
				SliderDraggable.Size = UDim2.new(DefaultPercentage, 0, 1, 0)
				local SliderFunc = {}
				function SliderFunc:Set(v)
					local Percentage = (v - cfslider.Min) / (cfslider.Max - cfslider.Min)
					SliderValue.Text = tostring(v)
					SliderDraggable.Size = UDim2.new(Percentage, 0, 1, 0)
					cfslider.Callback(v)
				end
				return SliderFunc
			end

			function SectionFunc:AddTextbox(cfbox)
				local cfbox = Library:MakeConfig({
					Title = "Textbox < Missing Title >",
					Default = "",
					Placeholder = "Input Here...",
					Callback = function() end
				}, cfbox or {})
				local Textbox = Instance.new("Frame")
				local UICorner_12 = Instance.new("UICorner")
				local Title_5 = Instance.new("TextLabel")
				local TextboxFrame = Instance.new("Frame")
				local UICorner_13 = Instance.new("UICorner")
				local RealTextBox = Instance.new("TextBox")

				Textbox.Name = "Textbox"
				Textbox.Parent = SectionList
				Textbox.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Textbox.Size = UDim2.new(1, 0, 0, 35)
				UICorner_12.CornerRadius = UDim.new(0, 6)
				UICorner_12.Parent = Textbox

				Title_5.Name = "Title"
				Title_5.Parent = Textbox
				Title_5.BackgroundTransparency = 1.000
				Title_5.Position = UDim2.new(0, 10, 0, 0)
				Title_5.Size = UDim2.new(1, -10, 1, 0)
				Title_5.Font = Enum.Font.GothamBold
				Title_5.Text = cfbox.Title
				Title_5.TextColor3 = T1UIColor["Text Color"]
				Title_5.TextSize = 13.000
				Title_5.TextXAlignment = Enum.TextXAlignment.Left

				TextboxFrame.Name = "TextboxFrame"
				TextboxFrame.Parent = Textbox
				TextboxFrame.BackgroundColor3 = T1UIColor["Background Main Color"]
				TextboxFrame.Position = UDim2.new(1, -110, 0.5, -10)
				TextboxFrame.Size = UDim2.new(0, 100, 0, 20)
				UICorner_13.CornerRadius = UDim.new(0, 4)
				UICorner_13.Parent = TextboxFrame

				RealTextBox.Parent = TextboxFrame
				RealTextBox.BackgroundTransparency = 1.000
				RealTextBox.Size = UDim2.new(1, 0, 1, 0)
				RealTextBox.Font = Enum.Font.GothamBold
				RealTextBox.PlaceholderText = cfbox.Placeholder
				RealTextBox.PlaceholderColor3 = T1UIColor["Placeholder Text Color"]
				RealTextBox.Text = cfbox.Default
				RealTextBox.TextColor3 = T1UIColor["Text Color"]
				RealTextBox.TextSize = 11.000
				RealTextBox.FocusLost:Connect(function() cfbox.Callback(RealTextBox.Text) end)
			end

			function SectionFunc:AddDropdown(cfdropdown)
				local cfdropdown = Library:MakeConfig({
					Title = "Dropdown < Missing Title >",
					Options = {},
					Default = "",
					Multi = false,
					Callback = function() end
				}, cfdropdown or {})
				local Dropdown = Instance.new("Frame")
				local UICorner_14 = Instance.new("UICorner")
				local Title_8 = Instance.new("TextLabel")
				local Selects = Instance.new("Frame")
				local UICorner_15 = Instance.new("UICorner")
				local SelectText = Instance.new("TextLabel")
				local Drop_Click = Instance.new("TextButton")
				local DropdownList = Instance.new("Frame")
				local Topbar = Instance.new("Frame")
				local Title_10 = Instance.new("TextLabel")
				local SearchFrame_2 = Instance.new("Frame")
				local UICorner_25 = Instance.new("UICorner")
				local UIStroke_4 = Instance.new("UIStroke")
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
				Dropdown.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Dropdown.Size = UDim2.new(1, 0, 0, 35)
				UICorner_14.CornerRadius = UDim.new(0, 6)
				UICorner_14.Parent = Dropdown

				Title_8.Name = "Title"
				Title_8.Parent = Dropdown
				Title_8.BackgroundTransparency = 1.000
				Title_8.Position = UDim2.new(0, 10, 0, 0)
				Title_8.Size = UDim2.new(1, -10, 1, 0)
				Title_8.Font = Enum.Font.GothamBold
				Title_8.Text = cfdropdown.Title
				Title_8.TextColor3 = T1UIColor["Text Color"]
				Title_8.TextSize = 13.000
				Title_8.TextXAlignment = Enum.TextXAlignment.Left

				Selects.Name = "Selects"
				Selects.Parent = Dropdown
				Selects.BackgroundColor3 = T1UIColor["Background Main Color"]
				Selects.Position = UDim2.new(1, -110, 0.5, -10)
				Selects.Size = UDim2.new(0, 100, 0, 20)
				UICorner_15.CornerRadius = UDim.new(0, 4)
				UICorner_15.Parent = Selects

				SelectText.Name = "SelectText"
				SelectText.Parent = Selects
				SelectText.BackgroundTransparency = 1.000
				SelectText.Size = UDim2.new(1, -20, 1, 0)
				SelectText.Position = UDim2.new(0, 5, 0, 0)
				SelectText.Font = Enum.Font.GothamBold
				SelectText.Text = tostring(cfdropdown.Default) == "" and "None" or tostring(cfdropdown.Default)
				SelectText.TextColor3 = T1UIColor["Text Color"]
				SelectText.TextSize = 10.000
				SelectText.TextXAlignment = Enum.TextXAlignment.Left

				Drop_Click.Name = "Drop_Click"
				Drop_Click.Parent = Dropdown
				Drop_Click.BackgroundTransparency = 1.000
				Drop_Click.Size = UDim2.new(1, 0, 1, 0)
				Drop_Click.Text = ""

				DropdownList.Name = "DropdownList"
				DropdownList.Parent = DropdownZone
				DropdownList.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownList.BackgroundColor3 = T1UIColor["Background Main Color"]
				DropdownList.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownList.Size = UDim2.new(0, 350, 0, 250)
				DropdownList.Visible = false
				local UICorner_27 = Instance.new("UICorner")
				UICorner_27.Parent = DropdownList
				local UIStroke_3 = Instance.new("UIStroke")
				UIStroke_3.Parent = DropdownList
				UIStroke_3.Color = T1UIColor["Border Color"]

				Topbar.Name = "Topbar"
				Topbar.Parent = DropdownList
				Topbar.BackgroundTransparency = 1.000
				Topbar.Size = UDim2.new(1, 0, 0, 50)

				Title_10.Name = "Title"
				Title_10.Parent = Topbar
				Title_10.BackgroundTransparency = 1.000
				Title_10.Position = UDim2.new(0, 15, 0, 0)
				Title_10.Size = UDim2.new(1, -200, 1, -5)
				Title_10.Font = Enum.Font.GothamBold
				Title_10.Text = cfdropdown.Title
				Title_10.TextColor3 = T1UIColor["Title Text Color"]
				Title_10.TextSize = 14.000
				Title_10.TextXAlignment = Enum.TextXAlignment.Left

				SearchFrame_2.Name = "SearchFrame"
				SearchFrame_2.Parent = Topbar
				SearchFrame_2.BackgroundColor3 = T1UIColor["Background 2 Color"]
				SearchFrame_2.Position = UDim2.new(1, -150, 0, 8)
				SearchFrame_2.Size = UDim2.new(0, 100, 0, 30)
				UICorner_25.CornerRadius = UDim.new(0, 5)
				UICorner_25.Parent = SearchFrame_2
				UIStroke_4.Color = T1UIColor["Border Color"]
				UIStroke_4.Parent = SearchFrame_2

				IconSearch_2.Name = "IconSearch"
				IconSearch_2.Parent = SearchFrame_2
				IconSearch_2.BackgroundTransparency = 1.000
				IconSearch_2.Position = UDim2.new(0, 10, 0.5, -7)
				IconSearch_2.Size = UDim2.new(0, 15, 0, 15)
				IconSearch_2.Image = "rbxassetid://71309835376233"
				IconSearch_2.ImageColor3 = T1UIColor["Search Icon Color"]

				TextBox.Parent = SearchFrame_2
				TextBox.BackgroundTransparency = 1.000
				TextBox.Position = UDim2.new(0, 35, 0, 0)
				TextBox.Size = UDim2.new(1, -35, 1, 0)
				TextBox.Font = Enum.Font.GothamBold
				TextBox.PlaceholderText = "Search..."
				TextBox.Text = ""
				TextBox.TextColor3 = T1UIColor["Text Color"]
				TextBox.TextSize = 12.000

				Click_Dropdown.Name = "Click_Dropdown"
				Click_Dropdown.Parent = Topbar
				Click_Dropdown.BackgroundTransparency = 1.000
				Click_Dropdown.Position = UDim2.new(1, -40, 0, 8)
				Click_Dropdown.Size = UDim2.new(0, 30, 0, 30)
				Click_Dropdown.Text = ""
				Icon_4.Name = "Icon"
				Icon_4.Parent = Click_Dropdown
				Icon_4.BackgroundTransparency = 1.000
				Icon_4.Size = UDim2.new(0, 20, 0, 20)
				Icon_4.Position = UDim2.new(0.5, -10, 0.5, -10)
				Icon_4.Image = "rbxassetid://105957381820378"
				Icon_4.ImageColor3 = T1UIColor["Setting Icon Color"]

				Real_List.Name = "Real_List"
				Real_List.Parent = DropdownList
				Real_List.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Real_List.Position = UDim2.new(0, 10, 0, 50)
				Real_List.Size = UDim2.new(1, -20, 1, -60)
				Library:UpdateScrolling(Real_List, UIListLayout_5)
				UICorner_26.CornerRadius = UDim.new(0, 5)
				UICorner_26.Parent = Real_List
				UIListLayout_5.Parent = Real_List
				UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_5.Padding = UDim.new(0, 5)
				UIPadding_5.Parent = Real_List
				UIPadding_5.PaddingLeft = UDim.new(0, 7)
				UIPadding_5.PaddingRight = UDim.new(0, 7)
				UIPadding_5.PaddingTop = UDim.new(0, 7)

				Drop_Click.Activated:Connect(function() DropdownZone.Visible = true DropdownList.Visible = true Library:TweenInstance(DropdownZone, 0.3, "BackgroundTransparency", 0.3) end)
				Click_Dropdown.Activated:Connect(function() DropdownList.Visible = false Library:TweenInstance(DropdownZone, 0.3, "BackgroundTransparency", 1) wait(0.3) DropdownZone.Visible = false end)
				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					local InputText = TextBox.Text:lower()
					for _, item in next, Real_List:GetChildren() do
						if item:IsA("Frame") and item:FindFirstChild("Title") then item.Visible = item.Title.Text:lower():find(InputText) and true or false end
					end
				end)

				local DropFunc = { Value = {} }
				if type(cfdropdown.Default) == "string" and cfdropdown.Default ~= "" then DropFunc.Value = {cfdropdown.Default} elseif type(cfdropdown.Default) == "table" then DropFunc.Value = cfdropdown.Default end

				function DropFunc:Set(ignored)
					for i, v in next, Real_List:GetChildren() do
						if v:IsA("Frame") then
							if table.find(DropFunc.Value, v.Title.Text) then
								Library:TweenInstance(v, 0.3, "BackgroundTransparency", 0)
								Library:TweenInstance(v.Title, 0.3, "TextTransparency", 0)
							else
								Library:TweenInstance(v, 0.3, "BackgroundTransparency", 0.98)
								Library:TweenInstance(v.Title, 0.3, "TextTransparency", 0.5)
							end
						end
					end
					local DropValueStr = table.concat(DropFunc.Value, ", ")
					SelectText.Text = DropValueStr == "" and "None" or DropValueStr
				end

				function DropFunc:Add(v)
					local Option2 = Instance.new("Frame")
					local UICorner_28 = Instance.new("UICorner")
					local Option2_Click = Instance.new("TextButton")
					local Title_12 = Instance.new("TextLabel")

					Option2.Name = "Option 2"
					Option2.Parent = Real_List
					Option2.BackgroundColor3 = T1UIColor["Dropdown Selected Color"]
					Option2.BackgroundTransparency = 0.980
					Option2.Size = UDim2.new(1, 0, 0, 30)
					UICorner_28.CornerRadius = UDim.new(0, 4)
					UICorner_28.Parent = Option2

					Title_12.Name = "Title"
					Title_12.Parent = Option2
					Title_12.BackgroundTransparency = 1.000
					Title_12.Size = UDim2.new(1, 0, 1, 0)
					Title_12.Font = Enum.Font.GothamBold
					Title_12.Text = v
					Title_12.TextColor3 = T1UIColor["Text Color"]
					Title_12.TextSize = 12.000
					Title_12.TextTransparency = 0.500

					Option2_Click.Name = "Option2_Click"
					Option2_Click.Parent = Option2
					Option2_Click.BackgroundTransparency = 1.000
					Option2_Click.Size = UDim2.new(1, 0, 1, 0)
					Option2_Click.Text = ""
					Option2_Click.Activated:Connect(function()
						if cfdropdown.Multi then
							if table.find(DropFunc.Value, v) then table.remove(DropFunc.Value, table.find(DropFunc.Value, v)) else table.insert(DropFunc.Value, v) end
						else
							DropFunc.Value = {v}
						end
						DropFunc:Set()
						cfdropdown.Callback(cfdropdown.Multi and DropFunc.Value or v)
					end)
				end
				for i, v in next, cfdropdown.Options do DropFunc:Add(v) end
				DropFunc:Set()
				return DropFunc
			end

			function SectionFunc:AddLabel(args)
				local Label = Instance.new("Frame")
				local Title_5 = Instance.new("TextLabel")
				Label.Name = "Label"
				Label.Parent = SectionList
				Label.BackgroundTransparency = 1.000
				Label.Size = UDim2.new(1, 0, 0, 20)
				Title_5.Name = "Title"
				Title_5.Parent = Label
				Title_5.BackgroundTransparency = 1.000
				Title_5.Position = UDim2.new(0, 10, 0, 0)
				Title_5.Size = UDim2.new(1, -10, 1, 0)
				Title_5.Font = Enum.Font.GothamBold
				Title_5.Text = args
				Title_5.TextColor3 = T1UIColor["Label Color"]
				Title_5.TextSize = 13.000
				Title_5.TextXAlignment = Enum.TextXAlignment.Left
			end

			function SectionFunc:AddParagraph(cfpara)
				local cfpara = Library:MakeConfig({ Title = "Paragraph < Missing Title >", Content = "" }, cfpara or {})
				local Paragraph = Instance.new("Frame")
				local UICorner_16 = Instance.new("UICorner")
				local Title_6 = Instance.new("TextLabel")
				local Content_4 = Instance.new("TextLabel")

				Paragraph.Name = "Paragraph"
				Paragraph.Parent = SectionList
				Paragraph.BackgroundColor3 = T1UIColor["Background 1 Color"]
				Paragraph.Size = UDim2.new(1, 0, 0, 45)
				UICorner_16.CornerRadius = UDim.new(0, 3)
				UICorner_16.Parent = Paragraph

				Title_6.Name = "Title"
				Title_6.Parent = Paragraph
				Title_6.BackgroundTransparency = 1.000
				Title_6.Position = UDim2.new(0, 10, 0, 7)
				Title_6.Size = UDim2.new(1, -60, 0, 16)
				Title_6.Font = Enum.Font.GothamBold
				Title_6.Text = cfpara.Title
				Title_6.TextColor3 = T1UIColor["Text Color"]
				Title_6.TextSize = 13.000
				Title_6.TextXAlignment = Enum.TextXAlignment.Left

				Content_4.Name = "Content"
				Content_4.Parent = Paragraph
				Content_4.BackgroundTransparency = 1.000
				Content_4.Position = UDim2.new(0, 10, 0, 22)
				Content_4.Size = UDim2.new(1, -10, 1, 0)
				Content_4.Font = Enum.Font.GothamBold
				Content_4.Text = cfpara.Content
				Content_4.TextColor3 = T1UIColor["Toggle Desc Color"]
				Content_4.TextSize = 12.000
				Content_4.TextXAlignment = Enum.TextXAlignment.Left
				Content_4.TextYAlignment = Enum.TextYAlignment.Top
				Library:UpdateContent(Content_4, Title_6, Paragraph)
				local ParaFunc = {}
				function ParaFunc:SetTitle(args) Title_6.Text = args end
				function ParaFunc:SetDesc(args) Content_4.Text = args end
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
				DiscordCard.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				DiscordCard.BackgroundTransparency = 0.4
				DiscordCard.Size = UDim2.new(1, 0, 0, 65)
				UICorner.CornerRadius = UDim.new(0, 9)
				UICorner.Parent = DiscordCard

				Icon.Parent = DiscordCard
				Icon.BackgroundTransparency = 1
				Icon.Position = UDim2.new(0, 10, 0, 10)
				Icon.Size = UDim2.new(0, 45, 0, 45)
				Icon.Image = "rbxassetid://123256573634"

				Title.Parent = DiscordCard
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 65, 0, 15)
				Title.Size = UDim2.new(1, -140, 0, 20)
				Title.Font = Enum.Font.GothamBold
				Title.Text = DiscordTitle or "Night Mystic"
				Title.TextColor3 = T1UIColor["Text Color"]
				Title.TextSize = 14

				SubTitle.Parent = DiscordCard
				SubTitle.BackgroundTransparency = 1
				SubTitle.Position = UDim2.new(0, 65, 0, 32)
				SubTitle.Size = UDim2.new(1, -140, 0, 20)
				SubTitle.Font = Enum.Font.Gotham
				SubTitle.Text = "Clique para entrar no servidor"
				SubTitle.TextColor3 = T1UIColor["Toggle Desc Color"]
				SubTitle.TextSize = 11

				JoinBtn.Name = "JoinBtn"
				JoinBtn.Parent = DiscordCard
				JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
				JoinBtn.Position = UDim2.new(1, -75, 0, 17)
				JoinBtn.Size = UDim2.new(0, 65, 0, 30)
				JoinBtn.Font = Enum.Font.GothamBold
				JoinBtn.Text = "Join"
				JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				JoinBtn.TextSize = 13
				BtnCorner.CornerRadius = UDim.new(0, 4)
				BtnCorner.Parent = JoinBtn

				JoinBtn.MouseButton1Click:Connect(function()
					if setclipboard then setclipboard("https://discord.gg/" .. InviteCode) end
					local req = (syn and syn.request) or (http and http.request) or http_request or request
					if req then pcall(function() req({ Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST", Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" }, Body = game:GetService("HttpService"):JSONEncode({ cmd = "INVITE_BROWSER", nonce = game:GetService("HttpService"):GenerateGUID(false), args = { code = InviteCode } }) }) end) end
					JoinBtn.Text = "Copiado!"
					task.wait(2)
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
	G2L["2"]["BackgroundColor3"] = T1UIColor["Background 1 Color"];
	G2L["2"]["Image"] = [[rbxassetid://101817370702077]];
	G2L["2"]["Size"] = UDim2.new(0, 50, 0, 50);
	G2L["2"]["BorderColor3"] = T1UIColor["Border Color"];
	G2L["2"]["AnchorPoint"] = Vector2.new(0, 0)
	G2L["2"]["Position"] = UDim2.new(0, 30, 0, 30)
	G2L["3"] = Instance.new("UICorner", G2L["2"]);
	G2L["3"]["CornerRadius"] = UDim.new(1, 0);
	G2L["4"] = Instance.new("UIStroke", G2L["2"]);
	G2L["4"]["Thickness"] = 2;
	G2L["4"]["Color"] = T1UIColor["Border Color"];

	G2L["2"].MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled end)
	Minize.MouseButton1Click:Connect(function() TeddyUI_Premium.Enabled = false end)
	return Tab
end
return Library
