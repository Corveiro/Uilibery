local Library = {}

function Library:TweenInstance(Instance, Time, OldValue, NewValue)

	local rz_Tween = game:GetService("TweenService"):Create(Instance, TweenInfo.new(Time, Enum.EasingStyle.Quad), { [OldValue] = NewValue })	rz_Tween:Play()	return rz_Tween

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

	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Main.ClipsDescendants = true

	Main.Image = ""

	Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

	Main.BackgroundTransparency = 0

	UICorner.Parent = Main
	UICorner.CornerRadius = UDim.new(0, 6)

	Top.Name = "Top"

	Top.Parent = Main

	Top.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	Top.BackgroundTransparency = 0

	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Top.BorderSizePixel = 0

	Top.Size = UDim2.new(1, 0, 0, 50)

	Line.Name = "Line"

	Line.Parent = Top

	Line.BackgroundColor3 = Color3.fromRGB(255, 180, 0)

	Line.BackgroundTransparency = 0.3

	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Line.BorderSizePixel = 0

	Line.Position = UDim2.new(0, 0, 1, -1)

	Line.Size = UDim2.new(1, 0, 0, 1)

	Left.Name = "Left"

	Left.Parent = Top

	NameHub.Name = "NameHub"

	NameHub.Parent = Left

	NameHub.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	NameHub.BackgroundTransparency = 1.000

	NameHub.BorderColor3 = Color3.fromRGB(0, 0, 0)

	NameHub.BorderSizePixel = 0

	NameHub.Position = UDim2.new(0, 60, 0, 10)

	NameHub.Size = UDim2.new(0, 470, 0, 20)

	NameHub.Font = Enum.Font.GothamBold

	NameHub.Text = ConfigWindow.Title

	NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)

	NameHub.TextSize = 14.000

	NameHub.TextXAlignment = Enum.TextXAlignment.Left

	LogoHub.Name = "LogoHub"

	LogoHub.Parent = Left

	LogoHub.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	LogoHub.BackgroundTransparency = 1.000

	LogoHub.BorderColor3 = Color3.fromRGB(0, 0, 0)

	LogoHub.BorderSizePixel = 0

	LogoHub.Position = UDim2.new(0, 10, 0, 5)

	LogoHub.Size = UDim2.new(0, 40, 0, 35)

	LogoHub.Image = "rbxassetid://123256573634"

	Desc.Name = "Desc"

	Desc.Parent = Left

	Desc.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	Desc.BackgroundTransparency = 1.000

	Desc.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Desc.BorderSizePixel = 0

	Desc.Position = UDim2.new(0, 60, 0, 27)

	Desc.Size = UDim2.new(0, 470, 1, -30)

	Desc.Font = Enum.Font.GothamBold

	Desc.Text = ConfigWindow.Description

	Desc.TextColor3 = Color3.fromRGB(150, 150, 150)

	Desc.TextSize = 12.000

	Desc.TextXAlignment = Enum.TextXAlignment.Left

	Desc.TextYAlignment = Enum.TextYAlignment.Top

	Right.Name = "Right"

	Right.Parent = Top

	Frame.Parent = Right

	Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	Frame.BackgroundTransparency = 1.000

	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Frame.BorderSizePixel = 0

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

	Minize.Active = false

	Minize.AnchorPoint = Vector2.new(0, 0.5)

	Minize.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	Minize.BackgroundTransparency = 1.000

	Minize.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Minize.BorderSizePixel = 0

	Minize.Selectable = false

	Minize.Size = UDim2.new(0, 30, 0, 30)

	Minize.Text = ""

	Icon.Name = "Icon"

	Icon.Parent = Minize

	Icon.AnchorPoint = Vector2.new(0.5, 0.5)

	Icon.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	Icon.BackgroundTransparency = 1.000

	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Icon.BorderSizePixel = 0

	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)

	Icon.Size = UDim2.new(0, 20, 0, 20)

	Icon.Image = "rbxassetid://136452605242985"

	Icon.ImageRectOffset = Vector2.new(288, 672)

	Icon.ImageRectSize = Vector2.new(96, 96)

	Large.Name = "Large"

	Large.Parent = Frame

	Large.Active = false

	Large.AnchorPoint = Vector2.new(0, 0.5)

	Large.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	Large.BackgroundTransparency = 1.000

	Large.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Large.BorderSizePixel = 0

	Large.Selectable = false

	Large.Size = UDim2.new(0, 30, 0, 30)

	Large.Text = ""

	Icon_2.Name = "Icon"

	Icon_2.Parent = Large

	Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)

	Icon_2.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	Icon_2.BackgroundTransparency = 1.000

	Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Icon_2.BorderSizePixel = 0

	Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)

	Icon_2.Size = UDim2.new(0, 20, 0, 20)

	Icon_2.Image = "rbxassetid://136452605242985"

	Icon_2.ImageRectOffset = Vector2.new(384, 672)

	Icon_2.ImageRectSize = Vector2.new(96, 96)

	Close.Name = "Close"

	Close.Parent = Frame

	Close.Active = false

	Close.AnchorPoint = Vector2.new(0, 0.5)

	Close.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	Close.BackgroundTransparency = 1.000

	Close.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Close.BorderSizePixel = 0

	Close.Selectable = false

	Close.Size = UDim2.new(0, 30, 0, 30)

	Close.Text = ""

	Close.MouseButton1Down:Connect(function()

		DropdownZone.Visible = true

		local tat_ = Instance.new("Frame", DropdownZone);

		tat_["BorderSizePixel"] = 0;

		tat_["BackgroundColor3"] = Color3.fromRGB(15, 15, 15);

		tat_["AnchorPoint"] = Vector2.new(0.5, 0.5);

		tat_["Size"] = UDim2.new(0, 400, 0, 150);

		tat_["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		tat_["BorderColor3"] = Color3.fromRGB(180, 180, 180);

		tat_["Name"] = [[Tat]];

		local suacc = Instance.new("UIStroke", tat_);

		suacc["Transparency"] = 0.5;

		suacc["Color"] = Color3.fromRGB(255, 180, 0);

		local suacc = Instance.new("UICorner", tat_);

		suacc["CornerRadius"] = UDim.new(0, 6);

		local suacc2 = Instance.new("TextLabel", tat_);

		suacc2["BorderSizePixel"] = 0;

		suacc2["TextSize"] = 20;

		suacc2["BackgroundColor3"] = Color3.fromRGB(30, 30, 30);

		suacc2["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);

		suacc2["TextColor3"] = Color3.fromRGB(255, 255, 255);

		suacc2["BackgroundTransparency"] = 1;

		suacc2["Size"] = UDim2.new(0, 400, 0, 50);

		suacc2["BorderColor3"] = Color3.fromRGB(0, 0, 0);

		suacc2["Text"] = [[Are you sure]];

		local btnyes = Instance.new("TextButton", tat_);

		btnyes["BorderSizePixel"] = 0;

		btnyes["TextSize"] = 25;

		btnyes["TextColor3"] = Color3.fromRGB(255, 255, 255);

		btnyes["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);

		btnyes["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);

		btnyes["AnchorPoint"] = Vector2.new(0, 1);

		btnyes["Size"] = UDim2.new(0, 150, 0, 50);

		btnyes["BorderColor3"] = Color3.fromRGB(0, 0, 0);

		btnyes["Text"] = [[Yes]];

		btnyes["Position"] = UDim2.new(0, 40, 1, -40);

		btnyes.MouseButton1Down:Connect(function()

			TeddyUI_Premium:Destroy()

		end)

		local thuaaa_corner = Instance.new("UICorner", btnyes);
		thuaaa_corner.CornerRadius = UDim.new(0, 4)

		local thuaaa = Instance.new("UIStroke", btnyes);

		thuaaa["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

		thuaaa["Color"] = Color3.fromRGB(255, 180, 0);

		local btnno = Instance.new("TextButton", tat_);

		btnno["BorderSizePixel"] = 0;

		btnno["TextSize"] = 25;

		btnno["TextColor3"] = Color3.fromRGB(255, 255, 255);

		btnno["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);

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

		local thuaa_corner = Instance.new("UICorner", btnno);
		thuaa_corner.CornerRadius = UDim.new(0, 4)

		local thuaa = Instance.new("UIStroke", btnno);

		thuaa["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

		thuaa["Color"] = Color3.fromRGB(40, 40, 40);

	end)

	Icon_3.Name = "Icon"

	Icon_3.Parent = Close

	Icon_3.AnchorPoint = Vector2.new(0.5, 0.5)

	Icon_3.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	Icon_3.BackgroundTransparency = 1.000

	Icon_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Icon_3.BorderSizePixel = 0

	Icon_3.Position = UDim2.new(0.5, 0, 0.5, 0)

	Icon_3.Size = UDim2.new(0, 20, 0, 20)

	Icon_3.Image = "rbxassetid://105957381820378"

	Icon_3.ImageRectOffset = Vector2.new(480, 0)

	Icon_3.ImageRectSize = Vector2.new(96, 96)

	UIStroke.Color = Color3.fromRGB(255, 180, 0)

	UIStroke.Transparency = 0.5

	UIStroke.Parent = Main

	TabFrame.Name = "TabFrame"

	TabFrame.Parent = Main

	TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	TabFrame.BackgroundTransparency = 0

	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	TabFrame.BorderSizePixel = 0

	TabFrame.Position = UDim2.new(0, 0, 0, 50)

	TabFrame.Size = UDim2.new(0, 144, 1, -50)

	Line_2.Name = "Line"

	Line_2.Parent = TabFrame

	Line_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

	Line_2.BackgroundTransparency = 0

	Line_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Line_2.BorderSizePixel = 0

	Line_2.Position = UDim2.new(1, -1, 0, 0)

	Line_2.Size = UDim2.new(0, 1, 1, 0)

	SearchFrame.Name = "SearchFrame"

	SearchFrame.Parent = TabFrame

	SearchFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

	SearchFrame.BackgroundTransparency = 0

	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	SearchFrame.BorderSizePixel = 0

	SearchFrame.Position = UDim2.new(0, 7, 0, 10)

	SearchFrame.Size = UDim2.new(1, -14, 0, 30)

	UICorner_2.CornerRadius = UDim.new(0, 4)

	UICorner_2.Parent = SearchFrame

	IconSearch.Name = "IconSearch"

	IconSearch.Parent = SearchFrame

	IconSearch.AnchorPoint = Vector2.new(0, 0.5)

	IconSearch.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	IconSearch.BackgroundTransparency = 1.000

	IconSearch.BorderColor3 = Color3.fromRGB(0, 0, 0)

	IconSearch.BorderSizePixel = 0

	IconSearch.Position = UDim2.new(0, 5, 0.5, 0)

	IconSearch.Size = UDim2.new(0, 18, 0, 18)

	IconSearch.Image = "rbxassetid://136452605242985"

	IconSearch.ImageColor3 = Color3.fromRGB(150, 150, 150)

	IconSearch.ImageRectOffset = Vector2.new(96, 96)

	IconSearch.ImageRectSize = Vector2.new(96, 96)

	SearchBox.Name = "SearchBox"

	SearchBox.Parent = SearchFrame

	SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	SearchBox.BackgroundTransparency = 1.000

	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)

	SearchBox.BorderSizePixel = 0

	SearchBox.Position = UDim2.new(0, 25, 0, 0)

	SearchBox.Size = UDim2.new(1, -25, 1, 0)

	SearchBox.Font = Enum.Font.GothamBold

	SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)

	SearchBox.PlaceholderText = "Search..."

	SearchBox.Text = ""

	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)

	SearchBox.TextSize = 13.000

	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	ScrollingTab.Name = "ScrollingTab"

	ScrollingTab.Parent = TabFrame

	ScrollingTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	ScrollingTab.BackgroundTransparency = 1.000

	ScrollingTab.BorderColor3 = Color3.fromRGB(0, 0, 0)

	ScrollingTab.BorderSizePixel = 0

	ScrollingTab.Position = UDim2.new(0, 0, 0, 50)

	ScrollingTab.Selectable = false

	ScrollingTab.Size = UDim2.new(1, 0, 1, -50)

	ScrollingTab.ScrollBarThickness = 0

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

	LayoutFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	LayoutFrame.BackgroundTransparency = 1.000

	LayoutFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	LayoutFrame.BorderSizePixel = 0

	LayoutFrame.Position = UDim2.new(0, 144, 0, 50)

	LayoutFrame.Size = UDim2.new(1, -144, 1, -50)

	LayoutFrame.ClipsDescendants = true

	RealLayout.Name = "RealLayout"

	RealLayout.Parent = LayoutFrame

	RealLayout.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	RealLayout.BackgroundTransparency = 1.000

	RealLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)

	RealLayout.BorderSizePixel = 0

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

	LayoutName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	LayoutName.BackgroundTransparency = 1.000

	LayoutName.BorderColor3 = Color3.fromRGB(0, 0, 0)

	LayoutName.BorderSizePixel = 0

	LayoutName.Size = UDim2.new(1, 0, 0, 40)

	TextLabel.Parent = LayoutName

	TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

	TextLabel.BackgroundTransparency = 1.000

	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)

	TextLabel.BorderSizePixel = 0

	TextLabel.Position = UDim2.new(0, 15, 0, 0)

	TextLabel.Size = UDim2.new(1, -15, 1, 0)

	TextLabel.Font = Enum.Font.GothamBold

	TextLabel.Text = "Home"

	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

	TextLabel.TextSize = 14.000

	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	DropdownZone.Name = "DropdownZone"

	DropdownZone.Parent = TeddyUI_Premium

	DropdownZone.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

	DropdownZone.BackgroundTransparency = 0.500

	DropdownZone.BorderColor3 = Color3.fromRGB(0, 0, 0)

	DropdownZone.BorderSizePixel = 0

	DropdownZone.Size = UDim2.new(1, 0, 1, 0)

	DropdownZone.Visible = false

	self:MakeDraggable(Top, DropShadowHolder)

	local AllLayouts = 0

	function WindowFunc:NewTab(t, iconid)

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

		TabDisable.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

		TabDisable.BackgroundTransparency = 1.000

		TabDisable.BorderColor3 = Color3.fromRGB(0, 0, 0)

		TabDisable.BorderSizePixel = 0

		TabDisable.Size = UDim2.new(1, 0, 0, 25)

		Choose_2.Name = "Choose"

		Choose_2.Parent = TabDisable

		Choose_2.BackgroundColor3 = Color3.fromRGB(255, 180, 0)

		Choose_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Choose_2.BorderSizePixel = 0

		Choose_2.Position = UDim2.new(0, -7, 0, 5)

		Choose_2.Size = UDim2.new(0, 3, 0, 15)

		Choose_2.Visible = false

		UICorner_4.CornerRadius = UDim.new(1, 0)

		UICorner_4.Parent = Choose_2

		TabIcon.Name = "TabIcon"

		TabIcon.Parent = TabDisable

		TabIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

		TabIcon.BackgroundTransparency = 1.000

		TabIcon.Position = UDim2.new(0, 12, 0.5, 0)

		TabIcon.AnchorPoint = Vector2.new(0, 0.5)

		TabIcon.Size = UDim2.new(0, 14, 0, 14) 

		TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

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

		NameTab_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

		NameTab_2.BackgroundTransparency = 1.000

		NameTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		NameTab_2.BorderSizePixel = 0

		NameTab_2.Position = UDim2.new(0, NamePosX, 0, 0)

		NameTab_2.Size = UDim2.new(1, -NamePosX, 1, 0)

		NameTab_2.Font = Enum.Font.GothamBold

		NameTab_2.Text = t

		NameTab_2.TextColor3 = Color3.fromRGB(255, 255, 255)

		NameTab_2.TextSize = 12.000

		NameTab_2.TextTransparency = 0.300

		NameTab_2.TextXAlignment = Enum.TextXAlignment.Left

		Click_Tab_2.Name = "Click_Tab"

		Click_Tab_2.Parent = TabDisable

		Click_Tab_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

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

		Layout.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

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

		UIPadding_3.PaddingRight = UDim.new(0, 7)

		UIListLayout_3.Parent = Layout

		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

		UIListLayout_3.Padding = UDim.new(0, 10)

		if AllLayouts == 0 then

			NameTab_2.TextTransparency = 0

			Choose_2.Visible = true

			if TabIcon.Visible then

				TabIcon.ImageTransparency = 0

			end

		end

		Click_Tab_2.MouseButton1Down:Connect(function()

			for _, v in next, ScrollingTab:GetChildren() do

				if v:IsA("Frame") and v.Name == "TabDisable" then

					Library:TweenInstance(v.NameTab, 0.3, "TextTransparency", 0.3)

					v.Choose.Visible = false

					if v.TabIcon.Visible then

						Library:TweenInstance(v.TabIcon, 0.3, "ImageTransparency", 0.3)

					end

				end

			end

			Library:TweenInstance(NameTab_2, 0.3, "TextTransparency", 0)

			Choose_2.Visible = true

			if TabIcon.Visible then

				Library:TweenInstance(TabIcon, 0.3, "ImageTransparency", 0)

			end

			UIPageLayout:JumpToIndex(Layout.LayoutOrder)

			TextLabel.Text = t

		end)

		AllLayouts = AllLayouts + 1

		local TabFunc = {}

		function TabFunc:AddSection(RealNameSection)

			local Section = Instance.new("Frame")

			local UICorner_5 = Instance.new("UICorner")

			local UIStroke_2 = Instance.new("UIStroke")

			local NameSection = Instance.new("Frame")

			local Title = Instance.new("TextLabel")

			local Line_3 = Instance.new("Frame")

			local UIGradient = Instance.new("UIGradient")

			local SectionList = Instance.new("Frame")

			local UIPadding_4 = Instance.new("UIPadding")

			local UIListLayout_4 = Instance.new("UIListLayout")

			Section.Name = "Section"

			Section.Parent = Layout

			Section.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

			Section.BackgroundTransparency = 0

			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)

			Section.BorderSizePixel = 0

			Section.Position = UDim2.new(1.36775815, 0, 0.545454562, 0)

			Section.Size = UDim2.new(1, 0, 0, 55)

			UICorner_5.CornerRadius = UDim.new(0, 6)

			UICorner_5.Parent = Section

			UIStroke_2.Color = Color3.fromRGB(40, 40, 40)

			UIStroke_2.Thickness = 1

			UIStroke_2.Transparency = 0

			UIStroke_2.Parent = Section

			NameSection.Name = "NameSection"

			NameSection.Parent = Section

			NameSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

			NameSection.BackgroundTransparency = 1.000

			NameSection.BorderColor3 = Color3.fromRGB(0, 0, 0)

			NameSection.BorderSizePixel = 0

			NameSection.Size = UDim2.new(1, 0, 0, 30)

			Title.Name = "Title"

			Title.Parent = NameSection

			Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

			Title.BackgroundTransparency = 1.000

			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)

			Title.BorderSizePixel = 0

			Title.Size = UDim2.new(1, 0, 1, 0)

			Title.Font = Enum.Font.GothamBold

			Title.Text = RealNameSection

			Title.TextColor3 = Color3.fromRGB(255, 255, 255)

			Title.TextSize = 14.000

			Line_3.Name = "Line"

			Line_3.Parent = NameSection

			Line_3.BackgroundColor3 = Color3.fromRGB(255, 180, 0)

			Line_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

			Line_3.BorderSizePixel = 0

			Line_3.Position = UDim2.new(0, 0, 1, -1)

			Line_3.Size = UDim2.new(1, 0, 0, 1)

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}

			UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}

			UIGradient.Parent = Line_3

			SectionList.Name = "SectionList"

			SectionList.Parent = Section

			SectionList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

			SectionList.BackgroundTransparency = 1.000

			SectionList.BorderColor3 = Color3.fromRGB(0, 0, 0)

			SectionList.BorderSizePixel = 0

			SectionList.Position = UDim2.new(0, 0, 0, 30)

			SectionList.Size = UDim2.new(1, 0, 0, 25)

			UIPadding_4.Parent = SectionList

			UIPadding_4.PaddingBottom = UDim.new(0, 5)

			UIPadding_4.PaddingLeft = UDim.new(0, 5)

			UIPadding_4.PaddingRight = UDim.new(0, 5)

			UIPadding_4.PaddingTop = UDim.new(0, 5)

			UIListLayout_4.Parent = SectionList

			UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

			UIListLayout_4.Padding = UDim.new(0, 5)

			UIListLayout_4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

				Section.Size = UDim2.new(1, 0, 0, UIListLayout_4.AbsoluteContentSize.Y + 40)

			end)

			local SectionFunc = {}

			function SectionFunc:AddToggle(cftoggle)

				local cftoggle = Library:MakeConfig({

					Title = "Toggle < Missing Title >",

					Description = "",

					Default = false,

					Callback = function()

					end

				}, cftoggle or {})

				local Toggle = Instance.new("Frame")

				local UICorner_6 = Instance.new("UICorner")

				local Title_2 = Instance.new("TextLabel")

				local ToggleCheck = Instance.new("Frame")

				local UICorner_7 = Instance.new("UICorner")

				local Check = Instance.new("Frame")

				local UICorner_8 = Instance.new("UICorner")

				local Toggle_Click = Instance.new("TextButton")

				local Content = Instance.new("TextLabel")

				Toggle.Name = "Toggle"

				Toggle.Parent = SectionList

				Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Toggle.BackgroundTransparency = 0

				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Toggle.BorderSizePixel = 0

				Toggle.Size = UDim2.new(1, 0, 0, 35)

				UICorner_6.CornerRadius = UDim.new(0, 4)

				UICorner_6.Parent = Toggle

				Title_2.Name = "Title"

				Title_2.Parent = Toggle

				Title_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_2.BackgroundTransparency = 1.000

				Title_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_2.BorderSizePixel = 0

				Title_2.Position = UDim2.new(0, 10, 0, 0)

				Title_2.Size = UDim2.new(1, -60, 1, 0)

				Title_2.Font = Enum.Font.GothamBold

				Title_2.Text = cftoggle.Title

				Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_2.TextSize = 13.000

				Title_2.TextXAlignment = Enum.TextXAlignment.Left

				ToggleCheck.Name = "ToggleCheck"

				ToggleCheck.Parent = Toggle

				ToggleCheck.AnchorPoint = Vector2.new(0, 0.5)

				ToggleCheck.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				ToggleCheck.BorderColor3 = Color3.fromRGB(0, 0, 0)

				ToggleCheck.BorderSizePixel = 0

				ToggleCheck.Position = UDim2.new(1, -30, 0.5, 0)

				ToggleCheck.Size = UDim2.new(0, 20, 0, 20)

				UICorner_7.CornerRadius = UDim.new(0, 4)

				UICorner_7.Parent = ToggleCheck

				local CheckStroke = Instance.new("UIStroke", ToggleCheck)
				CheckStroke.Color = Color3.fromRGB(40, 40, 40)
				CheckStroke.Thickness = 1

				Check.Name = "Check"

				Check.Parent = ToggleCheck

				Check.AnchorPoint = Vector2.new(0.5, 0.5)

				Check.BackgroundColor3 = Color3.fromRGB(255, 180, 0)

				Check.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Check.BorderSizePixel = 0

				Check.Position = UDim2.new(0.5, 0, 0.5, 0)

				Check.Size = UDim2.new(0, 0, 0, 0)

				UICorner_8.CornerRadius = UDim.new(0, 2)

				UICorner_8.Parent = Check

				Toggle_Click.Name = "Toggle_Click"

				Toggle_Click.Parent = Toggle

				Toggle_Click.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Toggle_Click.BackgroundTransparency = 1.000

				Toggle_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Toggle_Click.BorderSizePixel = 0

				Toggle_Click.Size = UDim2.new(1, 0, 1, 0)

				Toggle_Click.Font = Enum.Font.SourceSans

				Toggle_Click.Text = ""

				Toggle_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

				Toggle_Click.TextSize = 14.000

				Content.Name = "Content"

				Content.Parent = Toggle

				Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Content.BackgroundTransparency = 1.000

				Content.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Content.BorderSizePixel = 0

				Content.Position = UDim2.new(0, 10, 0, 22)

				Content.Size = UDim2.new(1, -60, 1, 0)

				Content.Font = Enum.Font.GothamBold

				Content.Text = cftoggle.Description

				Content.TextColor3 = Color3.fromRGB(150, 150, 150)

				Content.TextSize = 12.000

				Content.TextXAlignment = Enum.TextXAlignment.Left

				Content.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content, Title_2, Toggle)

				local ToggleFunc = { Value = cftoggle.Default }

				function ToggleFunc:Set(Boolean)

					if Boolean then

						Library:TweenInstance(Check, 0.2, "Size", UDim2.new(0, 12, 0, 12))
						Library:TweenInstance(CheckStroke, 0.2, "Color", Color3.fromRGB(255, 180, 0))

					else

						Library:TweenInstance(Check, 0.2, "Size", UDim2.new(0, 0, 0, 0))
						Library:TweenInstance(CheckStroke, 0.2, "Color", Color3.fromRGB(40, 40, 40))

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

					Callback = function()

					end

				}, cfbutton or {})

				local Button = Instance.new("Frame")

				local UICorner_9 = Instance.new("UICorner")

				local Title_3 = Instance.new("TextLabel")

				local Button_Click = Instance.new("TextButton")

				local Content_2 = Instance.new("TextLabel")

				local ImageLabel = Instance.new("ImageLabel")

				Button.Name = "Button"

				Button.Parent = SectionList

				Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Button.BackgroundTransparency = 0

				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Button.BorderSizePixel = 0

				Button.Size = UDim2.new(1, 0, 0, 35)

				UICorner_9.CornerRadius = UDim.new(0, 4)

				UICorner_9.Parent = Button

				Title_3.Name = "Title"

				Title_3.Parent = Button

				Title_3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_3.BackgroundTransparency = 1.000

				Title_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_3.BorderSizePixel = 0

				Title_3.Position = UDim2.new(0, 10, 0, 0)

				Title_3.Size = UDim2.new(1, -60, 1, 0)

				Title_3.Font = Enum.Font.GothamBold

				Title_3.Text = cfbutton.Title

				Title_3.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_3.TextSize = 13.000

				Title_3.TextXAlignment = Enum.TextXAlignment.Left

				Button_Click.Name = "Button_Click"

				Button_Click.Parent = Button

				Button_Click.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Button_Click.BackgroundTransparency = 1.000

				Button_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Button_Click.BorderSizePixel = 0

				Button_Click.Size = UDim2.new(1, 0, 1, 0)

				Button_Click.Font = Enum.Font.SourceSans

				Button_Click.Text = ""

				Button_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

				Button_Click.TextSize = 14.000

				Content_2.Name = "Content"

				Content_2.Parent = Button

				Content_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Content_2.BackgroundTransparency = 1.000

				Content_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Content_2.BorderSizePixel = 0

				Content_2.Position = UDim2.new(0, 10, 0, 22)

				Content_2.Size = UDim2.new(1, -60, 1, 0)

				Content_2.Font = Enum.Font.GothamBold

				Content_2.Text = cfbutton.Description

				Content_2.TextColor3 = Color3.fromRGB(150, 150, 150)

				Content_2.TextSize = 12.000

				Content_2.TextXAlignment = Enum.TextXAlignment.Left

				Content_2.TextYAlignment = Enum.TextYAlignment.Top

				ImageLabel.Parent = Button

				ImageLabel.AnchorPoint = Vector2.new(0, 0.5)

				ImageLabel.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

				ImageLabel.BackgroundTransparency = 1.000

				ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)

				ImageLabel.BorderSizePixel = 0

				ImageLabel.Position = UDim2.new(1, -35, 0.5, 0)

				ImageLabel.Size = UDim2.new(0, 24, 0, 24)

				ImageLabel.Image = "rbxassetid://85905776508942"

				Library:UpdateContent(Content_2, Title_3, Button)

				Button_Click.Activated:Connect(function()

					Button.BackgroundTransparency = 0.5

					cfbutton.Callback()

					Library:TweenInstance(Button, 0.2, "BackgroundTransparency", 0)

				end)

			end

			function SectionFunc:AddDropdown(cfdropdown)

				local cfdropdown = Library:MakeConfig({

					Title = "Dropdown",

					Description = "",

					Values = {},

					Default = {}, 

					Multi = false, 

					Callback = function()

					end

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

				local UIStroke_3 = Instance.new("UIStroke")

				local UICorner_24 = Instance.new("UICorner")

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

				Dropdown.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Dropdown.BackgroundTransparency = 0

				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Dropdown.BorderSizePixel = 0

				Dropdown.Size = UDim2.new(1, 0, 0, 35)

				UICorner_19.CornerRadius = UDim.new(0, 4)

				UICorner_19.Parent = Dropdown

				Title_8.Name = "Title"

				Title_8.Parent = Dropdown

				Title_8.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_8.BackgroundTransparency = 1.000

				Title_8.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_8.BorderSizePixel = 0

				Title_8.Position = UDim2.new(0, 10, 0, 0)

				Title_8.Size = UDim2.new(1, -60, 1, 0)

				Title_8.Font = Enum.Font.GothamBold

				Title_8.Text = cfdropdown.Title

				Title_8.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_8.TextSize = 13.000

				Title_8.TextXAlignment = Enum.TextXAlignment.Left

				Content_6.Name = "Content"

				Content_6.Parent = Dropdown

				Content_6.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Content_6.BackgroundTransparency = 1.000

				Content_6.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Content_6.BorderSizePixel = 0

				Content_6.Position = UDim2.new(0, 10, 0, 22)

				Content_6.Size = UDim2.new(1, -60, 1, 0)

				Content_6.Font = Enum.Font.GothamBold

				Content_6.Text = cfdropdown.Description

				Content_6.TextColor3 = Color3.fromRGB(150, 150, 150)

				Content_6.TextSize = 12.000

				Content_6.TextXAlignment = Enum.TextXAlignment.Left

				Content_6.TextYAlignment = Enum.TextYAlignment.Top

				Selects.Name = "Selects"

				Selects.Parent = Dropdown

				Selects.AnchorPoint = Vector2.new(0, 0.5)

				Selects.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				Selects.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Selects.BorderSizePixel = 0

				Selects.Position = UDim2.new(1, -110, 0.5, 0)

				Selects.Size = UDim2.new(0, 100, 0, 22)

				UICorner_20.CornerRadius = UDim.new(0, 4)

				UICorner_20.Parent = Selects

				SelectText.Name = "SelectText"

				SelectText.Parent = Selects

				SelectText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				SelectText.BackgroundTransparency = 1.000

				SelectText.BorderColor3 = Color3.fromRGB(0, 0, 0)

				SelectText.BorderSizePixel = 0

				SelectText.Position = UDim2.new(0, 5, 0, 0)

				SelectText.Size = UDim2.new(1, -25, 1, 0)

				SelectText.Font = Enum.Font.GothamBold

				SelectText.Text = "Select"

				SelectText.TextColor3 = Color3.fromRGB(255, 180, 0)

				SelectText.TextSize = 12.000

				SelectText.TextXAlignment = Enum.TextXAlignment.Left

				UITextSizeConstraint.Parent = SelectText

				UITextSizeConstraint.MaxTextSize = 12

				Drop_Click.Name = "Drop_Click"

				Drop_Click.Parent = Selects

				Drop_Click.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Drop_Click.BackgroundTransparency = 1.000

				Drop_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Drop_Click.BorderSizePixel = 0

				Drop_Click.Size = UDim2.new(1, 0, 1, 0)

				Drop_Click.Font = Enum.Font.SourceSans

				Drop_Click.Text = ""

				Drop_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

				Drop_Click.TextSize = 14.000

				ImageLabel_2.Parent = Selects

				ImageLabel_2.AnchorPoint = Vector2.new(0, 0.5)

				ImageLabel_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				ImageLabel_2.BackgroundTransparency = 1.000

				ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

				ImageLabel_2.BorderSizePixel = 0

				ImageLabel_2.Position = UDim2.new(1, -20, 0.5, 0)

				ImageLabel_2.Size = UDim2.new(0, 15, 0, 15)

				ImageLabel_2.Image = "rbxassetid://80845745785361"
				ImageLabel_2.ImageColor3 = Color3.fromRGB(150, 150, 150)

				Library:UpdateContent(Content_6, Title_8, Dropdown)

				DropdownList.Name = "DropdownList"

				DropdownList.Parent = DropdownZone

				DropdownList.AnchorPoint = Vector2.new(0.5, 0.5)

				DropdownList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)

				DropdownList.BorderSizePixel = 0

				DropdownList.Position = UDim2.new(0.5, 0, 0.5, 0)

				DropdownList.Size = UDim2.new(0, 400, 0, 250)

				DropdownList.Visible = false

				UIStroke_3.Color = Color3.fromRGB(255, 180, 0)

				UIStroke_3.Transparency = 0.5

				UIStroke_3.Parent = DropdownList

				UICorner_24.CornerRadius = UDim.new(0, 6)

				UICorner_24.Parent = DropdownList

				Topbar.Name = "Topbar"

				Topbar.Parent = DropdownList

				Topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

				Topbar.BackgroundTransparency = 0

				Topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Topbar.BorderSizePixel = 0

				Topbar.Size = UDim2.new(1, 0, 0, 50)

				Title_10.Name = "Title"

				Title_10.Parent = Topbar

				Title_10.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_10.BackgroundTransparency = 1.000

				Title_10.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_10.BorderSizePixel = 0

				Title_10.Position = UDim2.new(0, 15, 0, 0)

				Title_10.Size = UDim2.new(1, -115, 1, 0)

				Title_10.Font = Enum.Font.GothamBold

				Title_10.Text = cfdropdown.Title

				Title_10.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_10.TextSize = 16.000

				Title_10.TextXAlignment = Enum.TextXAlignment.Left

				SearchFrame_2.Name = "SearchFrame"

				SearchFrame_2.Parent = Topbar

				SearchFrame_2.AnchorPoint = Vector2.new(0, 0.5)

				SearchFrame_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				SearchFrame_2.BackgroundTransparency = 0

				SearchFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

				SearchFrame_2.BorderSizePixel = 0

				SearchFrame_2.Position = UDim2.new(1, -155, 0.5, 0)

				SearchFrame_2.Size = UDim2.new(0, 110, 0, 30)

				UICorner_25.CornerRadius = UDim.new(0, 4)

				UICorner_25.Parent = SearchFrame_2

				UIStroke_4.Color = Color3.fromRGB(40, 40, 40)

				UIStroke_4.Thickness = 1

				UIStroke_4.Parent = SearchFrame_2

				IconSearch_2.Name = "IconSearch"

				IconSearch_2.Parent = SearchFrame_2

				IconSearch_2.AnchorPoint = Vector2.new(0, 0.5)

				IconSearch_2.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

				IconSearch_2.BackgroundTransparency = 1.000

				IconSearch_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

				IconSearch_2.BorderSizePixel = 0

				IconSearch_2.Position = UDim2.new(0, 5, 0.5, 0)

				IconSearch_2.Size = UDim2.new(0, 16, 0, 16)

				IconSearch_2.Image = "rbxassetid://136452605242985"

				IconSearch_2.ImageColor3 = Color3.fromRGB(150, 150, 150)

				IconSearch_2.ImageRectOffset = Vector2.new(96, 96)

				IconSearch_2.ImageRectSize = Vector2.new(96, 96)

				TextBox.Parent = SearchFrame_2

				TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				TextBox.BackgroundTransparency = 1.000

				TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)

				TextBox.BorderSizePixel = 0

				TextBox.Position = UDim2.new(0, 25, 0, 0)

				TextBox.Size = UDim2.new(1, -25, 1, 0)

				TextBox.Font = Enum.Font.GothamBold

				TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)

				TextBox.PlaceholderText = "Search..."

				TextBox.Text = ""

				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

				TextBox.TextSize = 12.000

				TextBox.TextXAlignment = Enum.TextXAlignment.Left

				Click_Dropdown.Name = "Click_Dropdown"

				Click_Dropdown.Parent = Topbar

				Click_Dropdown.AnchorPoint = Vector2.new(0, 0.5)

				Click_Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Click_Dropdown.BackgroundTransparency = 1.000

				Click_Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Click_Dropdown.BorderSizePixel = 0

				Click_Dropdown.Position = UDim2.new(1, -35, 0.5, 0)

				Click_Dropdown.Size = UDim2.new(0, 25, 0, 25)

				Click_Dropdown.Font = Enum.Font.SourceSans

				Click_Dropdown.Text = ""

				Click_Dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)

				Click_Dropdown.TextSize = 14.000

				Icon_4.Name = "Icon"

				Icon_4.Parent = Click_Dropdown

				Icon_4.AnchorPoint = Vector2.new(0.5, 0.5)

				Icon_4.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

				Icon_4.BackgroundTransparency = 1.000

				Icon_4.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Icon_4.BorderSizePixel = 0

				Icon_4.Position = UDim2.new(0.5, 0, 0.5, 0)

				Icon_4.Size = UDim2.new(0, 20, 0, 20)

				Icon_4.Image = "rbxassetid://105957381820378"

				Icon_4.ImageRectOffset = Vector2.new(480, 0)

				Icon_4.ImageRectSize = Vector2.new(96, 96)

				Real_List.Name = "Real_List"

				Real_List.Parent = DropdownList

				Real_List.Active = true

				Real_List.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Real_List.BackgroundTransparency = 1.000

				Real_List.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Real_List.BorderSizePixel = 0

				Real_List.Position = UDim2.new(0, 0, 0, 50)

				Real_List.Size = UDim2.new(1, 0, 1, -50)

				Real_List.ScrollBarThickness = 2
				Real_List.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)

				UICorner_26.CornerRadius = UDim.new(0, 4)

				UICorner_26.Parent = Real_List

				UIListLayout_5.Parent = Real_List

				UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

				UIListLayout_5.Padding = UDim.new(0, 5)

				UIPadding_5.Parent = Real_List

				UIPadding_5.PaddingBottom = UDim.new(0, 10)

				UIPadding_5.PaddingLeft = UDim.new(0, 10)

				UIPadding_5.PaddingRight = UDim.new(0, 10)

				UIPadding_5.PaddingTop = UDim.new(0, 10)

				UIListLayout_5:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

					Real_List.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_5.AbsoluteContentSize.Y + 20)

				end)

				local DropdownFunc = { Value = cfdropdown.Default, Options = cfdropdown.Values }

				local function Refresh()

					for _, v in next, Real_List:GetChildren() do

						if v:IsA("Frame") and v.Name == "Option" then

							v:Destroy()

						end

					end

					for _, v in next, DropdownFunc.Options do

						local Option = Instance.new("Frame")

						local UICorner_27 = Instance.new("UICorner")

						local Option_Click = Instance.new("TextButton")

						local NameOption = Instance.new("TextLabel")

						local Option_Check = Instance.new("Frame")

						local UICorner_28 = Instance.new("UICorner")

						Option.Name = "Option"

						Option.Parent = Real_List

						Option.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

						Option.BackgroundTransparency = 0

						Option.BorderColor3 = Color3.fromRGB(0, 0, 0)

						Option.BorderSizePixel = 0

						Option.Size = UDim2.new(1, 0, 0, 30)

						UICorner_27.CornerRadius = UDim.new(0, 4)

						UICorner_27.Parent = Option

						Option_Click.Name = "Option_Click"

						Option_Click.Parent = Option

						Option_Click.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

						Option_Click.BackgroundTransparency = 1.000

						Option_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

						Option_Click.BorderSizePixel = 0

						Option_Click.Size = UDim2.new(1, 0, 1, 0)

						Option_Click.Font = Enum.Font.SourceSans

						Option_Click.Text = ""

						Option_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

						Option_Click.TextSize = 14.000

						NameOption.Name = "NameOption"

						NameOption.Parent = Option

						NameOption.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

						NameOption.BackgroundTransparency = 1.000

						NameOption.BorderColor3 = Color3.fromRGB(0, 0, 0)

						NameOption.BorderSizePixel = 0

						NameOption.Position = UDim2.new(0, 10, 0, 0)

						NameOption.Size = UDim2.new(1, -40, 1, 0)

						NameOption.Font = Enum.Font.GothamBold

						NameOption.Text = v

						NameOption.TextColor3 = Color3.fromRGB(255, 255, 255)

						NameOption.TextSize = 12.000

						NameOption.TextXAlignment = Enum.TextXAlignment.Left

						Option_Check.Name = "Option_Check"

						Option_Check.Parent = Option

						Option_Check.AnchorPoint = Vector2.new(0, 0.5)

						Option_Check.BackgroundColor3 = Color3.fromRGB(255, 180, 0)

						Option_Check.BorderColor3 = Color3.fromRGB(0, 0, 0)

						Option_Check.BorderSizePixel = 0

						Option_Check.Position = UDim2.new(1, -25, 0.5, 0)

						Option_Check.Size = UDim2.new(0, 15, 0, 15)

						Option_Check.Visible = false

						UICorner_28.CornerRadius = UDim.new(1, 0)

						UICorner_28.Parent = Option_Check

						if cfdropdown.Multi then

							if table.find(DropdownFunc.Value, v) then

								Option_Check.Visible = true

								NameOption.TextColor3 = Color3.fromRGB(255, 180, 0)

							end

						else

							if DropdownFunc.Value == v then

								Option_Check.Visible = true

								NameOption.TextColor3 = Color3.fromRGB(255, 180, 0)

							end

						end

						Option_Click.MouseButton1Down:Connect(function()

							if cfdropdown.Multi then

								if table.find(DropdownFunc.Value, v) then

									table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, v))

									Option_Check.Visible = false

									NameOption.TextColor3 = Color3.fromRGB(255, 255, 255)

								else

									table.insert(DropdownFunc.Value, v)

									Option_Check.Visible = true

									NameOption.TextColor3 = Color3.fromRGB(255, 180, 0)

								end

								local MultiText = ""

								for i, val in next, DropdownFunc.Value do

									MultiText = MultiText .. (i == 1 and "" or ", ") .. val

								end

								SelectText.Text = MultiText == "" and "Select" or MultiText

								cfdropdown.Callback(DropdownFunc.Value)

							else

								DropdownFunc.Value = v

								for _, opt in next, Real_List:GetChildren() do

									if opt:IsA("Frame") and opt.Name == "Option" then

										opt.Option_Check.Visible = false

										opt.NameOption.TextColor3 = Color3.fromRGB(255, 255, 255)

									end

								end

								Option_Check.Visible = true

								NameOption.TextColor3 = Color3.fromRGB(255, 180, 0)

								SelectText.Text = v

								cfdropdown.Callback(v)

								DropdownZone.Visible = false

								DropdownList.Visible = false

							end

						end)

					end

				end

				TextBox:GetPropertyChangedSignal("Text"):Connect(function()

					local InputText = TextBox.Text:lower()

					for _, v in next, Real_List:GetChildren() do

						if v:IsA("Frame") and v.Name == "Option" then

							if v.NameOption.Text:lower():find(InputText) then

								v.Visible = true

							else

								v.Visible = false

							end

						end

					end

				end)

				Drop_Click.MouseButton1Down:Connect(function()

					DropdownZone.Visible = true

					DropdownList.Visible = true

					Refresh()

				end)

				Click_Dropdown.MouseButton1Down:Connect(function()

					DropdownZone.Visible = false

					DropdownList.Visible = false

				end)

				function DropdownFunc:Set(Value)

					DropdownFunc.Value = Value

					if cfdropdown.Multi then

						local MultiText = ""

						for i, val in next, Value do

							MultiText = MultiText .. (i == 1 and "" or ", ") .. val

						end

						SelectText.Text = MultiText == "" and "Select" or MultiText

					else

						SelectText.Text = Value

					end

					cfdropdown.Callback(Value)

				end

				function DropdownFunc:Refresh(Values)

					DropdownFunc.Options = Values

					Refresh()

				end

				if cfdropdown.Default then

					DropdownFunc:Set(cfdropdown.Default)

				end

				return DropdownFunc

			end

			function SectionFunc:AddSlider(cfslider)

				local cfslider = Library:MakeConfig({

					Title = "Slider < Missing Title >",

					Description = "",

					Max = 100,

					Min = 1,

					Increment = 1,

					Default = 1,

					Callback = function()

					end

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

				Slider.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Slider.BackgroundTransparency = 0

				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Slider.BorderSizePixel = 0

				Slider.Size = UDim2.new(1, 0, 0, 35)

				UICorner_10.CornerRadius = UDim.new(0, 4)

				UICorner_10.Parent = Slider

				Title_4.Name = "Title"

				Title_4.Parent = Slider

				Title_4.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_4.BackgroundTransparency = 1.000

				Title_4.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_4.BorderSizePixel = 0

				Title_4.Position = UDim2.new(0, 10, 0, 0)

				Title_4.Size = UDim2.new(1, -60, 1, 0)

				Title_4.Font = Enum.Font.GothamBold

				Title_4.Text = cfslider.Title

				Title_4.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_4.TextSize = 13.000

				Title_4.TextXAlignment = Enum.TextXAlignment.Left

				Content_3.Name = "Content"

				Content_3.Parent = Slider

				Content_3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Content_3.BackgroundTransparency = 1.000

				Content_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Content_3.BorderSizePixel = 0

				Content_3.Position = UDim2.new(0, 10, 0, 22)

				Content_3.Size = UDim2.new(1, -160, 1, 0)

				Content_3.Font = Enum.Font.GothamBold

				Content_3.Text = cfslider.Description

				Content_3.TextColor3 = Color3.fromRGB(150, 150, 150)

				Content_3.TextSize = 12.000

				Content_3.TextXAlignment = Enum.TextXAlignment.Left

				Content_3.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content_3, Title_4, Slider)

				SliderFrame.Name = "SliderFrame"

				SliderFrame.Parent = Slider

				SliderFrame.AnchorPoint = Vector2.new(0, 0.5)

				SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

				SliderFrame.BorderSizePixel = 0

				SliderFrame.Position = UDim2.new(1, -140, 0.5, 0)

				SliderFrame.Size = UDim2.new(0, 130, 0, 8)

				UICorner_11.CornerRadius = UDim.new(1, 0)

				UICorner_11.Parent = SliderFrame

				SliderDraggable.Name = "SliderDraggable"

				SliderDraggable.Parent = SliderFrame

				SliderDraggable.BackgroundColor3 = Color3.fromRGB(255, 180, 0)

				SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)

				SliderDraggable.BorderSizePixel = 0

				SliderDraggable.Size = UDim2.new(0, 20, 1, 0)

				UICorner_12.CornerRadius = UDim.new(1, 0)

				UICorner_12.Parent = SliderDraggable

				Circle.Name = "Circle"

				Circle.Parent = SliderDraggable

				Circle.AnchorPoint = Vector2.new(0.5, 0.5)

				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

				Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Circle.BorderSizePixel = 0

				Circle.Position = UDim2.new(1, 0, 0.5, 0)

				Circle.Size = UDim2.new(0, 12, 0, 12)

				UICorner_13.CornerRadius = UDim.new(1, 0)

				UICorner_13.Parent = Circle

				SliderValue.Name = "SliderValue"

				SliderValue.Parent = Slider

				SliderValue.AnchorPoint = Vector2.new(0, 0.5)

				SliderValue.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)

				SliderValue.BorderSizePixel = 0

				SliderValue.Position = UDim2.new(1, -185, 0.5, 0)

				SliderValue.Size = UDim2.new(0, 35, 0, 20)

				SliderValue.Font = Enum.Font.GothamBold

				SliderValue.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)

				SliderValue.PlaceholderText = "..."

				SliderValue.Text = ""

				SliderValue.TextColor3 = Color3.fromRGB(255, 180, 0)

				SliderValue.TextSize = 11.000

				UICorner_14.CornerRadius = UDim.new(0, 4)

				UICorner_14.Parent = SliderValue

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

						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

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

					if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then

						local Position = math.clamp((Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)

						SliderFunc:Set(((cfslider.Max - cfslider.Min) * Position) + cfslider.Min)

					end

				end)

				SliderValue.FocusLost:Connect(function()

					if SliderValue.Text == "" then

						SliderValue.Text = cfslider.Default

					end

					SliderFunc:Set(tonumber(SliderValue.Text))

					cfslider.Callback(SliderFunc.Value)

				end)

				SliderFunc:Set(cfslider.Default)

				return SliderFunc

			end

			function SectionFunc:AddTextbox(cftextbox)

				local cftextbox = Library:MakeConfig({

					Title = "Textbox < Missing Title >",

					Description = "",

					Default = "",

					Placeholder = "Input here...",

					Callback = function()

					end

				}, cftextbox or {})

				local Textbox = Instance.new("Frame")

				local UICorner_15 = Instance.new("UICorner")

				local Title_5 = Instance.new("TextLabel")

				local Content_4 = Instance.new("TextLabel")

				local TextboxFrame = Instance.new("Frame")

				local UICorner_16 = Instance.new("UICorner")

				local TextboxValue = Instance.new("TextBox")

				Textbox.Name = "Textbox"

				Textbox.Parent = SectionList

				Textbox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Textbox.BackgroundTransparency = 0

				Textbox.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Textbox.BorderSizePixel = 0

				Textbox.Size = UDim2.new(1, 0, 0, 35)

				UICorner_15.CornerRadius = UDim.new(0, 4)

				UICorner_15.Parent = Textbox

				Title_5.Name = "Title"

				Title_5.Parent = Textbox

				Title_5.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_5.BackgroundTransparency = 1.000

				Title_5.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_5.BorderSizePixel = 0

				Title_5.Position = UDim2.new(0, 10, 0, 0)

				Title_5.Size = UDim2.new(1, -60, 1, 0)

				Title_5.Font = Enum.Font.GothamBold

				Title_5.Text = cftextbox.Title

				Title_5.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_5.TextSize = 13.000

				Title_5.TextXAlignment = Enum.TextXAlignment.Left

				Content_4.Name = "Content"

				Content_4.Parent = Textbox

				Content_4.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Content_4.BackgroundTransparency = 1.000

				Content_4.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Content_4.BorderSizePixel = 0

				Content_4.Position = UDim2.new(0, 10, 0, 22)

				Content_4.Size = UDim2.new(1, -160, 1, 0)

				Content_4.Font = Enum.Font.GothamBold

				Content_4.Text = cftextbox.Description

				Content_4.TextColor3 = Color3.fromRGB(150, 150, 150)

				Content_4.TextSize = 12.000

				Content_4.TextXAlignment = Enum.TextXAlignment.Left

				Content_4.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content_4, Title_5, Textbox)

				TextboxFrame.Name = "TextboxFrame"

				TextboxFrame.Parent = Textbox

				TextboxFrame.AnchorPoint = Vector2.new(0, 0.5)

				TextboxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				TextboxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

				TextboxFrame.BorderSizePixel = 0

				TextboxFrame.Position = UDim2.new(1, -110, 0.5, 0)

				TextboxFrame.Size = UDim2.new(0, 100, 0, 22)

				UICorner_16.CornerRadius = UDim.new(0, 4)

				UICorner_16.Parent = TextboxFrame

				TextboxValue.Name = "TextboxValue"

				TextboxValue.Parent = TextboxFrame

				TextboxValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				TextboxValue.BackgroundTransparency = 1.000

				TextboxValue.BorderColor3 = Color3.fromRGB(0, 0, 0)

				TextboxValue.BorderSizePixel = 0

				TextboxValue.Position = UDim2.new(0, 5, 0, 0)

				TextboxValue.Size = UDim2.new(1, -10, 1, 0)

				TextboxValue.Font = Enum.Font.GothamBold

				TextboxValue.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)

				TextboxValue.PlaceholderText = cftextbox.Placeholder

				TextboxValue.Text = cftextbox.Default

				TextboxValue.TextColor3 = Color3.fromRGB(255, 180, 0)

				TextboxValue.TextSize = 12.000

				TextboxValue.TextXAlignment = Enum.TextXAlignment.Left

				TextboxValue.FocusLost:Connect(function()

					cftextbox.Callback(TextboxValue.Text)

				end)

				return {

					Set = function(Value)

						TextboxValue.Text = Value

						cftextbox.Callback(Value)

					end

				}

			end

			function SectionFunc:AddKeybind(cfkeybind)

				local cfkeybind = Library:MakeConfig({

					Title = "Keybind < Missing Title >",

					Description = "",

					Default = Enum.KeyCode.E,

					Callback = function()

					end

				}, cfkeybind or {})

				local Keybind = Instance.new("Frame")

				local UICorner_17 = Instance.new("UICorner")

				local Title_6 = Instance.new("TextLabel")

				local Content_5 = Instance.new("TextLabel")

				local KeybindFrame = Instance.new("Frame")

				local UICorner_18 = Instance.new("UICorner")

				local KeybindValue = Instance.new("TextLabel")

				local Keybind_Click = Instance.new("TextButton")

				Keybind.Name = "Keybind"

				Keybind.Parent = SectionList

				Keybind.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Keybind.BackgroundTransparency = 0

				Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Keybind.BorderSizePixel = 0

				Keybind.Size = UDim2.new(1, 0, 0, 35)

				UICorner_17.CornerRadius = UDim.new(0, 4)

				UICorner_17.Parent = Keybind

				Title_6.Name = "Title"

				Title_6.Parent = Keybind

				Title_6.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_6.BackgroundTransparency = 1.000

				Title_6.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_6.BorderSizePixel = 0

				Title_6.Position = UDim2.new(0, 10, 0, 0)

				Title_6.Size = UDim2.new(1, -60, 1, 0)

				Title_6.Font = Enum.Font.GothamBold

				Title_6.Text = cfkeybind.Title

				Title_6.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_6.TextSize = 13.000

				Title_6.TextXAlignment = Enum.TextXAlignment.Left

				Content_5.Name = "Content"

				Content_5.Parent = Keybind

				Content_5.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Content_5.BackgroundTransparency = 1.000

				Content_5.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Content_5.BorderSizePixel = 0

				Content_5.Position = UDim2.new(0, 10, 0, 22)

				Content_5.Size = UDim2.new(1, -160, 1, 0)

				Content_5.Font = Enum.Font.GothamBold

				Content_5.Text = cfkeybind.Description

				Content_5.TextColor3 = Color3.fromRGB(150, 150, 150)

				Content_5.TextSize = 12.000

				Content_5.TextXAlignment = Enum.TextXAlignment.Left

				Content_5.TextYAlignment = Enum.TextYAlignment.Top

				Library:UpdateContent(Content_5, Title_6, Keybind)

				KeybindFrame.Name = "KeybindFrame"

				KeybindFrame.Parent = Keybind

				KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)

				KeybindFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

				KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

				KeybindFrame.BorderSizePixel = 0

				KeybindFrame.Position = UDim2.new(1, -110, 0.5, 0)

				KeybindFrame.Size = UDim2.new(0, 100, 0, 22)

				UICorner_18.CornerRadius = UDim.new(0, 4)

				UICorner_18.Parent = KeybindFrame

				KeybindValue.Name = "KeybindValue"

				KeybindValue.Parent = KeybindFrame

				KeybindValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				KeybindValue.BackgroundTransparency = 1.000

				KeybindValue.BorderColor3 = Color3.fromRGB(0, 0, 0)

				KeybindValue.BorderSizePixel = 0

				KeybindValue.Size = UDim2.new(1, 0, 1, 0)

				KeybindValue.Font = Enum.Font.GothamBold

				KeybindValue.Text = cfkeybind.Default.Name

				KeybindValue.TextColor3 = Color3.fromRGB(255, 180, 0)

				KeybindValue.TextSize = 12.000

				Keybind_Click.Name = "Keybind_Click"

				Keybind_Click.Parent = KeybindFrame

				Keybind_Click.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Keybind_Click.BackgroundTransparency = 1.000

				Keybind_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Keybind_Click.BorderSizePixel = 0

				Keybind_Click.Size = UDim2.new(1, 0, 1, 0)

				Keybind_Click.Font = Enum.Font.SourceSans

				Keybind_Click.Text = ""

				Keybind_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

				Keybind_Click.TextSize = 14.000

				local KeybindFunc = { Value = cfkeybind.Default }

				Keybind_Click.MouseButton1Down:Connect(function()

					KeybindValue.Text = "..."

					local Connection

					Connection = game:GetService("UserInputService").InputBegan:Connect(function(Input)

						if Input.UserInputType == Enum.UserInputType.Keyboard then

							KeybindValue.Text = Input.KeyCode.Name

							KeybindFunc.Value = Input.KeyCode

							Connection:Disconnect()

						end

					end)

				end)

				game:GetService("UserInputService").InputBegan:Connect(function(Input, Process)

					if not Process and Input.KeyCode == KeybindFunc.Value then

						cfkeybind.Callback()

					end

				end)

				return {

					Set = function(Value)

						KeybindValue.Text = Value.Name

						KeybindFunc.Value = Value

					end

				}

			end

			function SectionFunc:AddLabel(cflabel)

				local cflabel = Library:MakeConfig({

					Title = "Label < Missing Title >",

				}, cflabel or {})

				local Label = Instance.new("Frame")

				local UICorner_29 = Instance.new("UICorner")

				local Title_11 = Instance.new("TextLabel")

				Label.Name = "Label"

				Label.Parent = SectionList

				Label.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

				Label.BackgroundTransparency = 0

				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Label.BorderSizePixel = 0

				Label.Size = UDim2.new(1, 0, 0, 30)

				UICorner_29.CornerRadius = UDim.new(0, 4)

				UICorner_29.Parent = Label

				Title_11.Name = "Title"

				Title_11.Parent = Label

				Title_11.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

				Title_11.BackgroundTransparency = 1.000

				Title_11.BorderColor3 = Color3.fromRGB(0, 0, 0)

				Title_11.BorderSizePixel = 0

				Title_11.Position = UDim2.new(0, 10, 0, 0)

				Title_11.Size = UDim2.new(1, -20, 1, 0)

				Title_11.Font = Enum.Font.GothamBold

				Title_11.Text = cflabel.Title

				Title_11.TextColor3 = Color3.fromRGB(255, 255, 255)

				Title_11.TextSize = 13.000

				Title_11.TextXAlignment = Enum.TextXAlignment.Left

				return {

					Set = function(Value)

						Title_11.Text = Value

					end

				}

			end

			return SectionFunc

		end

		return TabFunc

	end

	return WindowFunc

end

return Library
