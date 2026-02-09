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

		local Tween = game:GetService("TweenService"):Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Linear), { Position = pos })

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

function Library:MakeResizable(object, minSize)
	local ResizeBtn = Instance.new("ImageButton")
	ResizeBtn.Name = "ResizeBtn"
	ResizeBtn.Parent = object
	ResizeBtn.AnchorPoint = Vector2.new(1, 1)
	ResizeBtn.Position = UDim2.new(1, -2, 1, -2)
	ResizeBtn.Size = UDim2.new(0, 15, 0, 15)
	ResizeBtn.BackgroundTransparency = 1
	ResizeBtn.Image = "rbxassetid://10131441151"
	ResizeBtn.ImageColor3 = Color3.fromRGB(180, 180, 180)
	ResizeBtn.ZIndex = 10

	local Resizing = false
	local ResizeStart = nil
	local StartSize = nil

	ResizeBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Resizing = true
			ResizeStart = input.Position
			StartSize = object.AbsoluteSize
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = input.Position - ResizeStart
			local NewWidth = math.max(minSize.X, StartSize.X + Delta.X)
			local NewHeight = math.max(minSize.Y, StartSize.Y + Delta.Y)
			object.Size = UDim2.new(0, NewWidth, 0, NewHeight)
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
		end
	end)
end

function Library:NewWindow(ConfigWindow)
	local ConfigWindow = self:MakeConfig({
		Title = "HOHO HUB V4",
		Description = "UI Library",
	}, ConfigWindow or {})

	local TeddyUI_Premium = Instance.new("ScreenGui")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	local Main = Instance.new("ImageLabel")
	local UICorner = Instance.new("UICorner")
	local UIStrokeMain = Instance.new("UIStroke")
	
	local Top = Instance.new("Frame")
	local TopTabs = Instance.new("Frame")
	local TopTabsList = Instance.new("UIListLayout")
	local Underline = Instance.new("Frame")
	
	local DropdownZone = Instance.new("Frame")

	TeddyUI_Premium.Name = "HohoHubV4_UI"
	TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = TeddyUI_Premium
	DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadowHolder.BackgroundTransparency = 1.000
	DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadowHolder.Size = UDim2.new(0, 500, 0, 350)
	DropShadowHolder.ZIndex = 0

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(255, 255, 0)
	DropShadow.ImageTransparency = 0.7
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	Main.Name = "Main"
	Main.Parent = DropShadowHolder
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(1, 0, 1, 0)
	Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Main.ClipsDescendants = true
	Main.Image = ""

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Main

	UIStrokeMain.Parent = Main
	UIStrokeMain.Color = Color3.fromRGB(255, 255, 0)
	UIStrokeMain.Thickness = 1.5
	UIStrokeMain.Transparency = 0.2

	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 40)

	TopTabs.Name = "TopTabs"
	TopTabs.Parent = Top
	TopTabs.BackgroundTransparency = 1
	TopTabs.Size = UDim2.new(1, 0, 1, 0)

	TopTabsList.Parent = TopTabs
	TopTabsList.FillDirection = Enum.FillDirection.Horizontal
	TopTabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TopTabsList.SortOrder = Enum.SortOrder.LayoutOrder
	TopTabsList.Padding = UDim.new(0, 20)

	Underline.Name = "Underline"
	Underline.Parent = Top
	Underline.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
	Underline.BorderSizePixel = 0
	Underline.Position = UDim2.new(0, 0, 1, -2)
	Underline.Size = UDim2.new(0, 0, 0, 2)
	Underline.ZIndex = 5

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = Main
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0, 0, 0, 40)
	ContentContainer.Size = UDim2.new(1, 0, 1, -40)

	local PagesView = Instance.new("ScrollingFrame")
	PagesView.Name = "PagesView"
	PagesView.Parent = ContentContainer
	PagesView.BackgroundTransparency = 1
	PagesView.Size = UDim2.new(1, 0, 1, 0)
	PagesView.CanvasSize = UDim2.new(0, 0, 0, 0)
	PagesView.ScrollBarThickness = 2
	PagesView.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0)
	PagesView.Visible = false

	local PagesGrid = Instance.new("UIGridLayout")
	PagesGrid.Parent = PagesView
	PagesGrid.CellPadding = UDim2.new(0, 15, 0, 15)
	PagesGrid.CellSize = UDim2.new(0, 220, 0, 100)
	PagesGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	PagesGrid.SortOrder = Enum.SortOrder.LayoutOrder

	local PagesPadding = Instance.new("UIPadding")
	PagesPadding.Parent = PagesView
	PagesPadding.PaddingTop = UDim.new(0, 15)
	PagesPadding.PaddingBottom = UDim.new(0, 15)

	local SubPageContainer = Instance.new("Frame")
	SubPageContainer.Name = "SubPageContainer"
	SubPageContainer.Parent = ContentContainer
	SubPageContainer.BackgroundTransparency = 1
	SubPageContainer.Size = UDim2.new(1, 0, 1, 0)
	SubPageContainer.Visible = false

	local SubPageTop = Instance.new("Frame")
	SubPageTop.Name = "SubPageTop"
	SubPageTop.Parent = SubPageContainer
	SubPageTop.BackgroundTransparency = 1
	SubPageTop.Size = UDim2.new(1, 0, 0, 40)

	local BackBtn = Instance.new("ImageButton")
	BackBtn.Name = "BackBtn"
	BackBtn.Parent = SubPageTop
	BackBtn.BackgroundTransparency = 1
	BackBtn.Position = UDim2.new(0, 10, 0.5, -12)
	BackBtn.Size = UDim2.new(0, 24, 0, 24)
	BackBtn.Image = "rbxassetid://6031094678"
	BackBtn.ImageColor3 = Color3.fromRGB(255, 255, 0)

	local SubPageTitle = Instance.new("TextLabel")
	SubPageTitle.Parent = SubPageTop
	SubPageTitle.BackgroundTransparency = 1
	SubPageTitle.Position = UDim2.new(0, 45, 0, 0)
	SubPageTitle.Size = UDim2.new(0, 150, 1, 0)
	SubPageTitle.Font = Enum.Font.GothamBold
	SubPageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubPageTitle.TextSize = 14
	SubPageTitle.TextXAlignment = Enum.TextXAlignment.Left

	local SearchFrame = Instance.new("Frame")
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = SubPageTop
	SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	SearchFrame.Position = UDim2.new(1, -160, 0.5, -12)
	SearchFrame.Size = UDim2.new(0, 150, 0, 24)
	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 6)
	SearchCorner.Parent = SearchFrame
	local SearchStroke = Instance.new("UIStroke")
	SearchStroke.Color = Color3.fromRGB(255, 255, 0)
	SearchStroke.Thickness = 1
	SearchStroke.Transparency = 0.5
	SearchStroke.Parent = SearchFrame

	local SearchBox = Instance.new("TextBox")
	SearchBox.Parent = SearchFrame
	SearchBox.BackgroundTransparency = 1
	SearchBox.Position = UDim2.new(0, 5, 0, 0)
	SearchBox.Size = UDim2.new(1, -10, 1, 0)
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.PlaceholderText = "Search..."
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.TextSize = 12
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	local SubPageContent = Instance.new("Frame")
	SubPageContent.Name = "SubPageContent"
	SubPageContent.Parent = SubPageContainer
	SubPageContent.BackgroundTransparency = 1
	SubPageContent.Position = UDim2.new(0, 0, 0, 40)
	SubPageContent.Size = UDim2.new(1, 0, 1, -40)

	local HomeView = Instance.new("ScrollingFrame")
	HomeView.Name = "HomeView"
	HomeView.Parent = ContentContainer
	HomeView.BackgroundTransparency = 1
	HomeView.Size = UDim2.new(1, 0, 1, 0)
	HomeView.ScrollBarThickness = 2
	HomeView.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0)
	HomeView.Visible = true
	local HomeList = Instance.new("UIListLayout")
	HomeList.Parent = HomeView
	HomeList.Padding = UDim.new(0, 10)
	HomeList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	local HomePadding = Instance.new("UIPadding")
	HomePadding.Parent = HomeView
	HomePadding.PaddingTop = UDim.new(0, 10)

	local CreditsView = Instance.new("ScrollingFrame")
	CreditsView.Name = "CreditsView"
	CreditsView.Parent = ContentContainer
	CreditsView.BackgroundTransparency = 1
	CreditsView.Size = UDim2.new(1, 0, 1, 0)
	CreditsView.ScrollBarThickness = 2
	CreditsView.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0)
	CreditsView.Visible = false
	local CreditsList = Instance.new("UIListLayout")
	CreditsList.Parent = CreditsView
	CreditsList.Padding = UDim.new(0, 10)
	CreditsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	local CreditsPadding = Instance.new("UIPadding")
	CreditsPadding.Parent = CreditsView
	CreditsPadding.PaddingTop = UDim.new(0, 10)

	DropdownZone.Name = "DropdownZone"
	DropdownZone.Parent = Main
	DropdownZone.BackgroundTransparency = 0.5
	DropdownZone.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	DropdownZone.Size = UDim2.new(1, 0, 1, 0)
	DropdownZone.Visible = false
	DropdownZone.ZIndex = 100

	self:MakeDraggable(Top, DropShadowHolder)
	self:MakeResizable(DropShadowHolder, Vector2.new(400, 300))

	local CurrentTab = "Home"
	local function SwitchMainTab(name, btn)
		CurrentTab = name
		HomeView.Visible = (name == "Home")
		PagesView.Visible = (name == "Pages")
		CreditsView.Visible = (name == "Credits")
		SubPageContainer.Visible = false
		
		Library:TweenInstance(Underline, 0.2, "Position", UDim2.new(0, btn.AbsolutePosition.X - TopTabs.AbsolutePosition.X, 1, -2))
		Library:TweenInstance(Underline, 0.2, "Size", UDim2.new(0, btn.AbsoluteSize.X, 0, 2))
	end

	local function CreateMainTabBtn(name)
		local Btn = Instance.new("TextButton")
		Btn.Name = name .. "Btn"
		Btn.Parent = TopTabs
		Btn.BackgroundTransparency = 1
		Btn.Size = UDim2.new(0, 80, 1, 0)
		Btn.Font = Enum.Font.GothamBold
		Btn.Text = name
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		Btn.TextSize = 14
		
		Btn.MouseButton1Click:Connect(function()
			SwitchMainTab(name, Btn)
		end)
		return Btn
	end

	local HomeBtn = CreateMainTabBtn("Home")
	local PagesBtn = CreateMainTabBtn("Pages")
	local CreditsBtn = CreateMainTabBtn("Credits")

	task.spawn(function()
		task.wait(0.1)
		SwitchMainTab("Home", HomeBtn)
	end)

	BackBtn.MouseButton1Click:Connect(function()
		SubPageContainer.Visible = false
		PagesView.Visible = true
	end)

	local Tab = {}
	local AllTabs = {}

	function Tab:T(t, iconid)
		local Card = Instance.new("Frame")
		local CardCorner = Instance.new("UICorner")
		local CardStroke = Instance.new("UIStroke")
		local CardBtn = Instance.new("TextButton")
		local CardIcon = Instance.new("ImageLabel")
		local CardTitle = Instance.new("TextLabel")

		Card.Name = t .. "Card"
		Card.Parent = PagesView
		Card.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		CardCorner.CornerRadius = UDim.new(0, 10)
		CardCorner.Parent = Card
		CardStroke.Color = Color3.fromRGB(255, 255, 0)
		CardStroke.Thickness = 1
		CardStroke.Transparency = 0.6
		CardStroke.Parent = Card

		CardBtn.Parent = Card
		CardBtn.BackgroundTransparency = 1
		CardBtn.Size = UDim2.new(1, 0, 1, 0)
		CardBtn.Text = ""

		CardIcon.Parent = Card
		CardIcon.AnchorPoint = Vector2.new(0.5, 0)
		CardIcon.Position = UDim2.new(0.5, 0, 0, 15)
		CardIcon.Size = UDim2.new(0, 40, 0, 40)
		CardIcon.BackgroundTransparency = 1
		CardIcon.Image = iconid or "rbxassetid://6023426915"
		CardIcon.ImageColor3 = Color3.fromRGB(255, 255, 0)

		CardTitle.Parent = Card
		CardTitle.AnchorPoint = Vector2.new(0.5, 1)
		CardTitle.Position = UDim2.new(0.5, 0, 1, -10)
		CardTitle.Size = UDim2.new(1, -10, 0, 20)
		CardTitle.BackgroundTransparency = 1
		CardTitle.Font = Enum.Font.GothamBold
		CardTitle.Text = t
		CardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		CardTitle.TextSize = 14

		local Layout = Instance.new("ScrollingFrame")
		Layout.Name = t .. "Layout"
		Layout.Parent = SubPageContent
		Layout.BackgroundTransparency = 1
		Layout.Size = UDim2.new(1, 0, 1, 0)
		Layout.CanvasSize = UDim2.new(0, 0, 0, 0)
		Layout.ScrollBarThickness = 2
		Layout.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 0)
		Layout.Visible = false

		local LayoutList = Instance.new("UIListLayout")
		LayoutList.Parent = Layout
		LayoutList.Padding = UDim.new(0, 10)
		LayoutList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		local LayoutPadding = Instance.new("UIPadding")
		LayoutPadding.Parent = Layout
		LayoutPadding.PaddingTop = UDim.new(0, 10)

		Library:UpdateScrolling(Layout, LayoutList)

		CardBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(SubPageContent:GetChildren()) do
				if v:IsA("ScrollingFrame") then v.Visible = false end
			end
			Layout.Visible = true
			SubPageTitle.Text = t
			PagesView.Visible = false
			SubPageContainer.Visible = true
		end)

		SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local text = SearchBox.Text:lower()
			for _, item in pairs(Layout:GetChildren()) do
				if item:IsA("Frame") and item:FindFirstChild("NameSection") then
					local sectionVisible = false
					for _, element in pairs(item.SectionList:GetChildren()) do
						if element:IsA("Frame") and element:FindFirstChild("Title") then
							if element.Title.Text:lower():find(text) then
								element.Visible = true
								sectionVisible = true
							else
								element.Visible = false
							end
						end
					end
					item.Visible = sectionVisible
				end
			end
		end)

		local TabFunc = {}
		function TabFunc:AddSection(RealNameSection)
			local Section = Instance.new("Frame")
			local SectionCorner = Instance.new("UICorner")
			local NameSection = Instance.new("Frame")
			local Title = Instance.new("TextLabel")
			local SectionList = Instance.new("Frame")
			local SectionListLayout = Instance.new("UIListLayout")
			local SectionPadding = Instance.new("UIPadding")

			Section.Name = "Section"
			Section.Parent = Layout
			Section.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			Section.Size = UDim2.new(0.95, 0, 0, 40)
			SectionCorner.CornerRadius = UDim.new(0, 8)
			SectionCorner.Parent = Section

			NameSection.Name = "NameSection"
			NameSection.Parent = Section
			NameSection.BackgroundTransparency = 1
			NameSection.Size = UDim2.new(1, 0, 0, 30)

			Title.Name = "Title"
			Title.Parent = NameSection
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 10, 0, 0)
			Title.Size = UDim2.new(1, -10, 1, 0)
			Title.Font = Enum.Font.GothamBold
			Title.Text = RealNameSection
			Title.TextColor3 = Color3.fromRGB(255, 255, 0)
			Title.TextSize = 14
			Title.TextXAlignment = Enum.TextXAlignment.Left

			SectionList.Name = "SectionList"
			SectionList.Parent = Section
			SectionList.BackgroundTransparency = 1
			SectionList.Position = UDim2.new(0, 0, 0, 30)
			SectionList.Size = UDim2.new(1, 0, 1, -30)

			SectionListLayout.Parent = SectionList
			SectionListLayout.Padding = UDim.new(0, 5)
			SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			SectionPadding.Parent = SectionList
			SectionPadding.PaddingLeft = UDim.new(0, 5)
			SectionPadding.PaddingRight = UDim.new(0, 5)
			SectionPadding.PaddingBottom = UDim.new(0, 5)

			SectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(0.95, 0, 0, SectionListLayout.AbsoluteContentSize.Y + 35)
			end)

			local SectionFunc = {}

			function SectionFunc:AddToggle(cftoggle)
				cftoggle = Library:MakeConfig({Title = "Toggle", Default = false, Callback = function() end}, cftoggle or {})
				local Toggle = Instance.new("Frame")
				local ToggleCorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local ToggleCheck = Instance.new("Frame")
				local CheckCorner = Instance.new("UICorner")
				local CheckStroke = Instance.new("UIStroke")
				local Click = Instance.new("TextButton")

				Toggle.Name = "Toggle"
				Toggle.Parent = SectionList
				Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				Toggle.Size = UDim2.new(1, 0, 0, 35)
				ToggleCorner.CornerRadius = UDim.new(0, 6)
				ToggleCorner.Parent = Toggle

				Title.Name = "Title"
				Title.Parent = Toggle
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 0)
				Title.Size = UDim2.new(1, -40, 1, 0)
				Title.Font = Enum.Font.Gotham
				Title.Text = cftoggle.Title
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left

				ToggleCheck.Name = "ToggleCheck"
				ToggleCheck.Parent = Toggle
				ToggleCheck.AnchorPoint = Vector2.new(1, 0.5)
				ToggleCheck.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
				ToggleCheck.Position = UDim2.new(1, -10, 0.5, 0)
				ToggleCheck.Size = UDim2.new(0, 18, 0, 18)
				CheckCorner.CornerRadius = UDim.new(0, 4)
				CheckCorner.Parent = ToggleCheck
				CheckStroke.Color = Color3.fromRGB(255, 255, 0)
				CheckStroke.Thickness = 1.5
				CheckStroke.Parent = ToggleCheck

				Click.Parent = Toggle
				Click.BackgroundTransparency = 1
				Click.Size = UDim2.new(1, 0, 1, 0)
				Click.Text = ""

				local ToggleFunc = {Value = cftoggle.Default}
				function ToggleFunc:Set(val)
					ToggleFunc.Value = val
					Library:TweenInstance(ToggleCheck, 0.2, "BackgroundColor3", val and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(10, 10, 10))
					cftoggle.Callback(val)
				end
				Click.MouseButton1Click:Connect(function() ToggleFunc:Set(not ToggleFunc.Value) end)
				ToggleFunc:Set(ToggleFunc.Value)
				return ToggleFunc
			end

			function SectionFunc:AddButton(cfbutton)
				cfbutton = Library:MakeConfig({Title = "Button", Callback = function() end}, cfbutton or {})
				local Button = Instance.new("Frame")
				local ButtonCorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Click = Instance.new("TextButton")

				Button.Name = "Button"
				Button.Parent = SectionList
				Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				Button.Size = UDim2.new(1, 0, 0, 35)
				ButtonCorner.CornerRadius = UDim.new(0, 6)
				ButtonCorner.Parent = Button

				Title.Name = "Title"
				Title.Parent = Button
				Title.BackgroundTransparency = 1
				Title.Size = UDim2.new(1, 0, 1, 0)
				Title.Font = Enum.Font.GothamBold
				Title.Text = cfbutton.Title
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 13

				Click.Parent = Button
				Click.BackgroundTransparency = 1
				Click.Size = UDim2.new(1, 0, 1, 0)
				Click.Text = ""
				Click.MouseButton1Click:Connect(cfbutton.Callback)
				
				Library:MouseEvent(Button, function()
					Library:TweenInstance(Button, 0.2, "BackgroundColor3", Color3.fromRGB(30, 30, 30))
				end, function()
					Library:TweenInstance(Button, 0.2, "BackgroundColor3", Color3.fromRGB(20, 20, 20))
				end)
				return {}
			end

			function SectionFunc:AddSlider(cfslider)
				cfslider = Library:MakeConfig({Title = "Slider", Min = 0, Max = 100, Default = 50, Callback = function() end}, cfslider or {})
				local Slider = Instance.new("Frame")
				local SliderCorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local ValueLabel = Instance.new("TextLabel")
				local SliderBar = Instance.new("Frame")
				local BarCorner = Instance.new("UICorner")
				local Fill = Instance.new("Frame")
				local FillCorner = Instance.new("UICorner")
				local Click = Instance.new("TextButton")

				Slider.Name = "Slider"
				Slider.Parent = SectionList
				Slider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				Slider.Size = UDim2.new(1, 0, 0, 45)
				SliderCorner.CornerRadius = UDim.new(0, 6)
				SliderCorner.Parent = Slider

				Title.Parent = Slider
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 5)
				Title.Size = UDim2.new(1, -60, 0, 20)
				Title.Font = Enum.Font.Gotham
				Title.Text = cfslider.Title
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 12
				Title.TextXAlignment = Enum.TextXAlignment.Left

				ValueLabel.Parent = Slider
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Position = UDim2.new(1, -50, 0, 5)
				ValueLabel.Size = UDim2.new(0, 40, 0, 20)
				ValueLabel.Font = Enum.Font.GothamBold
				ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
				ValueLabel.TextSize = 12
				ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

				SliderBar.Parent = Slider
				SliderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
				SliderBar.Position = UDim2.new(0, 10, 0, 30)
				SliderBar.Size = UDim2.new(1, -20, 0, 6)
				BarCorner.Parent = SliderBar

				Fill.Parent = SliderBar
				Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
				Fill.Size = UDim2.new(0, 0, 1, 0)
				FillCorner.Parent = Fill

				Click.Parent = SliderBar
				Click.BackgroundTransparency = 1
				Click.Size = UDim2.new(1, 0, 1, 0)
				Click.Text = ""

				local SliderFunc = {Value = cfslider.Default}
				local function Update(input)
					local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					local val = math.floor(cfslider.Min + (cfslider.Max - cfslider.Min) * pos)
					SliderFunc.Value = val
					ValueLabel.Text = tostring(val)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					cfslider.Callback(val)
				end

				local dragging = false
				Click.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(input) end
				end)
				game:GetService("UserInputService").InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
				end)
				game:GetService("UserInputService").InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)

				function SliderFunc:Set(val)
					val = math.clamp(val, cfslider.Min, cfslider.Max)
					SliderFunc.Value = val
					ValueLabel.Text = tostring(val)
					local pos = (val - cfslider.Min) / (cfslider.Max - cfslider.Min)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					cfslider.Callback(val)
				end
				SliderFunc:Set(cfslider.Default)
				return SliderFunc
			end

			function SectionFunc:AddDropdown(cfdropdown)
				cfdropdown = Library:MakeConfig({Title = "Dropdown", Options = {}, Default = "", Callback = function() end}, cfdropdown or {})
				local Dropdown = Instance.new("Frame")
				local DropCorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local SelectedLabel = Instance.new("TextLabel")
				local Click = Instance.new("TextButton")

				Dropdown.Name = "Dropdown"
				Dropdown.Parent = SectionList
				Dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				Dropdown.Size = UDim2.new(1, 0, 0, 35)
				DropCorner.CornerRadius = UDim.new(0, 6)
				DropCorner.Parent = Dropdown

				Title.Parent = Dropdown
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 0)
				Title.Size = UDim2.new(0.5, -10, 1, 0)
				Title.Font = Enum.Font.Gotham
				Title.Text = cfdropdown.Title
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left

				SelectedLabel.Parent = Dropdown
				SelectedLabel.BackgroundTransparency = 1
				SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
				SelectedLabel.Size = UDim2.new(0.5, -10, 1, 0)
				SelectedLabel.Font = Enum.Font.GothamBold
				SelectedLabel.Text = cfdropdown.Default or "Select..."
				SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
				SelectedLabel.TextSize = 12
				SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right

				Click.Parent = Dropdown
				Click.BackgroundTransparency = 1
				Click.Size = UDim2.new(1, 0, 1, 0)
				Click.Text = ""

				local DropFunc = {Value = cfdropdown.Default, Options = cfdropdown.Options}
				Click.MouseButton1Click:Connect(function()
					DropdownZone.Visible = true
					local ListFrame = Instance.new("Frame", DropdownZone)
					ListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
					ListFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
					ListFrame.Size = UDim2.new(0, 200, 0, 200)
					Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 10)
					Instance.new("UIStroke", ListFrame).Color = Color3.fromRGB(255, 255, 0)
					
					local Scroll = Instance.new("ScrollingFrame", ListFrame)
					Scroll.BackgroundTransparency = 1
					Scroll.Size = UDim2.new(1, 0, 1, 0)
					Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
					local List = Instance.new("UIListLayout", Scroll)
					List.Padding = UDim.new(0, 5)
					
					local function CreateOption(opt)
						local OptBtn = Instance.new("TextButton", Scroll)
						OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
						OptBtn.Size = UDim2.new(1, -10, 0, 30)
						OptBtn.Font = Enum.Font.Gotham
						OptBtn.Text = opt
						OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
						OptBtn.TextSize = 12
						Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
						OptBtn.MouseButton1Click:Connect(function()
							DropFunc.Value = opt
							SelectedLabel.Text = opt
							cfdropdown.Callback(opt)
							DropdownZone.Visible = false
							ListFrame:Destroy()
						end)
					end

					for _, opt in pairs(DropFunc.Options) do CreateOption(opt) end
					Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
					
					DropdownZone.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownZone.Visible then
							DropdownZone.Visible = false
							ListFrame:Destroy()
						end
					end)
				end)

				function DropFunc:Refresh(newList)
					DropFunc.Options = newList
				end
				function DropFunc:Set(val)
					DropFunc.Value = val
					SelectedLabel.Text = val
					cfdropdown.Callback(val)
				end
				return DropFunc
			end

			function SectionFunc:AddParagraph(cfpara)
				cfpara = Library:MakeConfig({Title = "Paragraph", Content = ""}, cfpara or {})
				local Para = Instance.new("Frame")
				local ParaCorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Content = Instance.new("TextLabel")

				Para.Name = "Paragraph"
				Para.Parent = SectionList
				Para.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				Para.Size = UDim2.new(1, 0, 0, 50)
				ParaCorner.CornerRadius = UDim.new(0, 6)
				ParaCorner.Parent = Para

				Title.Parent = Para
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 5)
				Title.Size = UDim2.new(1, -20, 0, 20)
				Title.Font = Enum.Font.GothamBold
				Title.Text = cfpara.Title
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left

				Content.Parent = Para
				Content.BackgroundTransparency = 1
				Content.Position = UDim2.new(0, 10, 0, 25)
				Content.Size = UDim2.new(1, -20, 0, 20)
				Content.Font = Enum.Font.Gotham
				Content.Text = cfpara.Content
				Content.TextColor3 = Color3.fromRGB(180, 180, 180)
				Content.TextSize = 12
				Content.TextXAlignment = Enum.TextXAlignment.Left
				Content.TextWrapped = true

				local ParaFunc = {}
				function ParaFunc:SetTitle(t) Title.Text = t end
				function ParaFunc:SetDesc(d) Content.Text = d end
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
				DiscordCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				DiscordCard.Size = UDim2.new(1, 0, 0, 65)
				UICorner.CornerRadius = UDim.new(0, 10)
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
				Title.Text = DiscordTitle or "Discord Server"
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left

				SubTitle.Parent = DiscordCard
				SubTitle.BackgroundTransparency = 1
				SubTitle.Position = UDim2.new(0, 65, 0, 32)
				SubTitle.Size = UDim2.new(1, -140, 0, 20)
				SubTitle.Font = Enum.Font.Gotham
				SubTitle.Text = "Clique para entrar no servidor"
				SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
				SubTitle.TextSize = 11
				SubTitle.TextXAlignment = Enum.TextXAlignment.Left

				JoinBtn.Name = "JoinBtn"
				JoinBtn.Parent = DiscordCard
				JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
				JoinBtn.Position = UDim2.new(1, -75, 0, 17)
				JoinBtn.Size = UDim2.new(0, 65, 0, 30)
				JoinBtn.Font = Enum.Font.GothamBold
				JoinBtn.Text = "Join"
				JoinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
				JoinBtn.TextSize = 13
				BtnCorner.CornerRadius = UDim.new(0, 10)
				BtnCorner.Parent = JoinBtn

				JoinBtn.MouseButton1Click:Connect(function()
					if setclipboard then setclipboard("https://discord.gg/" .. InviteCode) end
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
					JoinBtn.Text = "Copiado!"
					task.wait(2)
					JoinBtn.Text = "Join"
				end)
			end

			return SectionFunc
		end
		return TabFunc
	end

	local ToggleBtn = Instance.new("ImageButton", TeddyUI_Premium)
	ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
	ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	ToggleBtn.Image = "rbxassetid://101817370702077"
	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
	local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
	ToggleStroke.Color = Color3.fromRGB(255, 255, 0)
	ToggleStroke.Thickness = 2
	ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible DropShadow.Visible = Main.Visible end)

	return Tab
end

-- [ORIGINAL CODE PRESERVED BELOW]
local OriginalCodeStart = [[
]]

	TeddyUI_Premium.Name = "TeddyUI_Premium"

	TeddyUI_Premium.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	TeddyUI_Premium.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	DropShadowHolder.Name = "DropShadowHolder"

	DropShadowHolder.Parent = TeddyUI_Premium

	DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)

	DropShadowHolder.BackgroundTransparency = 1.000

	DropShadowHolder.BorderSizePixel = 0

	DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)

	DropShadowHolder.Size = UDim2.new(0, 400, 0, 380)

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

	Main.Size = UDim2.new(1, 0, 1, 0)

	Main.BorderSizePixel = 0

	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Main.ClipsDescendants = true

	Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Main.BackgroundTransparency = 0
	Main.Image = ""

	UICorner.Parent = Main

	Top.Name = "Top"

	Top.Parent = Main

	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

	Top.BackgroundTransparency = 1.000

	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Top.BorderSizePixel = 0

	Top.Size = UDim2.new(1, 0, 0, 50)

	Line.Name = "Line"
	Line.Parent = Top
	Line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	Line.BackgroundTransparency = 0.8
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 0, 1, -1)
	Line.Size = UDim2.new(1, 0, 0, 1)
	Line.Visible = true

	Left.Name = "Left"

	Left.Parent = Top

	NameHub.Name = "NameHub"

	NameHub.Parent = Left

	NameHub.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	NameHub.BackgroundTransparency = 1.000

	NameHub.BorderColor3 = Color3.fromRGB(0, 0, 0)

	NameHub.BorderSizePixel = 0

	NameHub.Position = UDim2.new(0, 60, 0, 10)

	NameHub.Size = UDim2.new(1, -180, 0, 20)

	NameHub.Font = Enum.Font.GothamBold

	NameHub.Text = ConfigWindow.Title

	NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)

	NameHub.TextSize = 16.000

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

	Desc.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	Desc.BackgroundTransparency = 1.000

	Desc.BorderColor3 = Color3.fromRGB(0, 0, 0)

	Desc.BorderSizePixel = 0

	Desc.Position = UDim2.new(0, 60, 0, 27)

	Desc.Size = UDim2.new(1, -180, 0, 15)

	Desc.Font = Enum.Font.GothamBold

	Desc.Text = ConfigWindow.Description

	Desc.TextColor3 = Color3.fromRGB(150, 150, 150)

	Desc.TextSize = 12.000

	Desc.TextXAlignment = Enum.TextXAlignment.Left

	Desc.TextYAlignment = Enum.TextYAlignment.Top

	Right.Name = "Right"

	Right.Parent = Top

	Frame.Parent = Right

	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

	Minize.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

	Large.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

	Icon_2.Size = UDim2.new(0, 18, 0, 18)

	Icon_2.Image = "rbxassetid://136452605242985"

	Icon_2.ImageRectOffset = Vector2.new(580, 194)

	Icon_2.ImageRectSize = Vector2.new(96, 96)

	Close.Name = "Close"

	Close.Parent = Frame

	Close.Active = false

	Close.AnchorPoint = Vector2.new(0, 0.5)

	Close.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

		tat_["BackgroundColor3"] = Color3.fromRGB(19, 19, 19);

		tat_["AnchorPoint"] = Vector2.new(0.5, 0.5);

		tat_["Size"] = UDim2.new(0, 300, 0, 150);

		tat_["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		tat_["BorderColor3"] = Color3.fromRGB(180, 180, 180);

		tat_["Name"] = [[Tat]];

		local suacc = Instance.new("UIStroke", tat_);

		suacc["Transparency"] = 0.5;

		suacc["Color"] = Color3.fromRGB(101, 101, 101);

		local suacc = Instance.new("UICorner", tat_);

		suacc["CornerRadius"] = UDim.new(0, 5);

		local suacc2 = Instance.new("TextLabel", tat_);

		suacc2["BorderSizePixel"] = 0;

		suacc2["TextSize"] = 20;

		suacc2["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);

		suacc2["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);

		suacc2["TextColor3"] = Color3.fromRGB(255, 255, 255);

		suacc2["BackgroundTransparency"] = 1;

		suacc2["Size"] = UDim2.new(0, 300, 0, 50);

		suacc2["BorderColor3"] = Color3.fromRGB(0, 0, 0);

		suacc2["Text"] = [[Are you sure]];

		local btnyes = Instance.new("TextButton", tat_);

		btnyes["BorderSizePixel"] = 0;

		btnyes["TextSize"] = 25;

		btnyes["TextColor3"] = Color3.fromRGB(255, 255, 255);

		btnyes["BackgroundColor3"] = Color3.fromRGB(5, 5, 5);

		btnyes["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);

		btnyes["AnchorPoint"] = Vector2.new(0, 1);

		btnyes["Size"] = UDim2.new(0, 100, 0, 50);

		btnyes["BorderColor3"] = Color3.fromRGB(0, 0, 0);

		btnyes["Text"] = [[Yes]];

		btnyes["Position"] = UDim2.new(0, 40, 1, -40);

		btnyes.MouseButton1Down:Connect(function()

			TeddyUI_Premium:Destroy()

		end)

		local thuaaa = Instance.new("UICorner", btnyes);

		local thuaaa = Instance.new("UIStroke", btnyes);

		thuaaa["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

		thuaaa["Color"] = Color3.fromRGB(39, 39, 39);

		local btnno = Instance.new("TextButton", tat_);

		btnno["BorderSizePixel"] = 0;

		btnno["TextSize"] = 25;

		btnno["TextColor3"] = Color3.fromRGB(255, 255, 255);

		btnno["BackgroundColor3"] = Color3.fromRGB(5, 5, 5);

		btnno["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);

		btnno["AnchorPoint"] = Vector2.new(1, 1);

		btnno["Size"] = UDim2.new(0, 100, 0, 50);

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

		thuaa["Color"] = Color3.fromRGB(39, 39, 39);

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

	UIStroke.Color = Color3.fromRGB(180, 180, 180)

	UIStroke.Transparency = 1.0

	UIStroke.Parent = Main

	TabFrame.Name = "TabFrame"

	TabFrame.Parent = Main

	TabFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

	TabFrame.BackgroundTransparency = 0.3

	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	TabFrame.BorderSizePixel = 0

	TabFrame.Position = UDim2.new(0, 10, 0, 60)

	TabFrame.Size = UDim2.new(0, 130, 1, -70)

	Line_2.Name = "Line"
	Line_2.Parent = TabFrame
	Line_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	Line_2.BackgroundTransparency = 0.9
	Line_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line_2.BorderSizePixel = 0
	Line_2.Position = UDim2.new(1, -1, 0, 0)
	Line_2.Size = UDim2.new(0, 1, 1, 0)
	Line_2.Visible = true

	SearchFrame.Name = "SearchFrame"

	SearchFrame.Parent = TabFrame

	SearchFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

	SearchFrame.BackgroundTransparency = 0.2

	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	SearchFrame.BorderSizePixel = 0

	SearchFrame.Position = UDim2.new(0, 7, 0, 10)

	SearchFrame.Size = UDim2.new(1, -14, 0, 30)

	UICorner_2.CornerRadius = UDim.new(0, 8)

	UICorner_2.Parent = SearchFrame

	IconSearch.Name = "IconSearch"

	IconSearch.Parent = SearchFrame

	IconSearch.AnchorPoint = Vector2.new(0, 0.5)

	IconSearch.BackgroundColor3 = Color3.fromRGB(180, 180, 180)

	IconSearch.BackgroundTransparency = 1.000

	IconSearch.BorderColor3 = Color3.fromRGB(0, 0, 0)

	IconSearch.BorderSizePixel = 0

	IconSearch.Position = UDim2.new(0, 10, 0.5, 0)

	IconSearch.Size = UDim2.new(0, 15, 0, 15)

	IconSearch.Image = "rbxassetid://71309835376233"

	SearchBox.Name = "SearchBox"

	SearchBox.Parent = SearchFrame

	SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	SearchBox.BackgroundTransparency = 1.000

	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)

	SearchBox.BorderSizePixel = 0

	SearchBox.ClipsDescendants = true

	SearchBox.Position = UDim2.new(0, 35, 0, 0)

	SearchBox.Size = UDim2.new(1, -35, 1, 0)

	SearchBox.Font = Enum.Font.GothamBold

	SearchBox.Text = ""

	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)

	SearchBox.TextSize = 14.000

	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	ScrollingTab.Name = "ScrollingTab"

	ScrollingTab.Parent = TabFrame

	ScrollingTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	ScrollingTab.BackgroundTransparency = 1.000

	ScrollingTab.BorderColor3 = Color3.fromRGB(0, 0, 0)

	ScrollingTab.BorderSizePixel = 0

	ScrollingTab.Position = UDim2.new(0, 0, 0, 50)

	ScrollingTab.Selectable = false

	ScrollingTab.Size = UDim2.new(1, 0, 1, -50)

	ScrollingTab.ScrollBarThickness = 0

	UIPadding_2.Parent = ScrollingTab

	UIPadding_2.PaddingBottom = UDim.new(0, 3)

	UIPadding_2.PaddingLeft = UDim.new(0, 7)

	UIPadding_2.PaddingRight = UDim.new(0, 7)

	UIPadding_2.PaddingTop = UDim.new(0, 3)

	UIListLayout_2.Parent = ScrollingTab

	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

	UIListLayout_2.Padding = UDim.new(0, 10)

	self:UpdateScrolling(ScrollingTab, UIListLayout_2)

	LayoutFrame.Name = "LayoutFrame"

	LayoutFrame.Parent = Main

	LayoutFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	LayoutFrame.BackgroundTransparency = 1.000

	LayoutFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

	LayoutFrame.BorderSizePixel = 0

	LayoutFrame.Position = UDim2.new(0, 150, 0, 60)

	LayoutFrame.Size = UDim2.new(1, -160, 1, -70)

	LayoutFrame.ClipsDescendants = true

	RealLayout.Name = "RealLayout"

	RealLayout.Parent = LayoutFrame

	RealLayout.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

	LayoutName.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	LayoutName.BackgroundTransparency = 1.000

	LayoutName.BorderColor3 = Color3.fromRGB(0, 0, 0)

	LayoutName.BorderSizePixel = 0

	LayoutName.Size = UDim2.new(1, 0, 0, 40)

	TextLabel.Parent = LayoutName

	TextLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	TextLabel.BackgroundTransparency = 1.000

	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)

	TextLabel.BorderSizePixel = 0

	TextLabel.Position = UDim2.new(0, 10, 0, 0)

	TextLabel.Size = UDim2.new(1, -10, 1, 0)

	TextLabel.Font = Enum.Font.GothamBold

	TextLabel.Text = ""

	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

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
	self:MakeResizable(DropShadowHolder, Vector2.new(350, 300))

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

		local UIPadding_3 = Instance.new("UIPadding")

		local TabIcon = Instance.new("ImageLabel")

		local IconRound = Instance.new("UICorner")

		TabDisable.Name = "TabDisable"

		TabDisable.Parent = ScrollingTab

		TabDisable.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		TabDisable.BackgroundTransparency = 1.000

		TabDisable.BorderColor3 = Color3.fromRGB(0, 0, 0)

		TabDisable.BorderSizePixel = 0

		TabDisable.Size = UDim2.new(1, 0, 0, 25)

		Choose_2.Name = "Choose"

		Choose_2.Parent = TabDisable

			Choose_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

		Choose_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Choose_2.BorderSizePixel = 0

		Choose_2.Position = UDim2.new(0, 0, 0, 5)

		Choose_2.Size = UDim2.new(0, 4, 0, 15)

		Choose_2.Visible = false

		UICorner_4.CornerRadius = UDim.new(0, 8)

		UICorner_4.Parent = Choose_2

		TabIcon.Name = "TabIcon"

		TabIcon.Parent = TabDisable

		TabIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		TabIcon.BackgroundTransparency = 1.000

		TabIcon.Position = UDim2.new(0, 12, 0.5, 0)

		TabIcon.AnchorPoint = Vector2.new(0, 0.5)

		TabIcon.Size = UDim2.new(0, 14, 0, 14) 

			TabIcon.ImageColor3 = Color3.fromRGB(255, 0, 0)

		IconRound.Parent = TabIcon

		IconRound.CornerRadius = UDim.new(0, 8)

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

		NameTab_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		NameTab_2.BackgroundTransparency = 1.000

		NameTab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		NameTab_2.BorderSizePixel = 0

		NameTab_2.Position = UDim2.new(0, NamePosX, 0, 0)

		NameTab_2.Size = UDim2.new(1, -NamePosX, 1, 0)

		NameTab_2.Font = Enum.Font.GothamBold

		NameTab_2.Text = t

		NameTab_2.TextColor3 = Color3.fromRGB(255, 255, 255)

		NameTab_2.TextSize = 13.000

		NameTab_2.TextTransparency = 0.300

		NameTab_2.TextXAlignment = Enum.TextXAlignment.Left

		Click_Tab_2.Name = "Click_Tab"

		Click_Tab_2.Parent = TabDisable

		Click_Tab_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Click_Tab_2.BackgroundTransparency = 1.000

		Click_Tab_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Click_Tab_2.BorderSizePixel = 0

		Click_Tab_2.Size = UDim2.new(1, 0, 1, 0)

		Click_Tab_2.Font = Enum.Font.SourceSans

		Click_Tab_2.Text = ""

		Click_Tab_2.TextColor3 = Color3.fromRGB(0, 0, 0)

		Click_Tab_2.TextSize = 16.000

		Layout.Name = "Layout"

		Layout.Parent = LayoutList

		Layout.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

			UIPageLayout:JumpToIndex(0)

			TextLabel.Text = t

		else

			if TabIcon.Visible then

				TabIcon.ImageTransparency = 0.5

			end

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

		local SectionList = Instance.new("Frame")

		local UIPadding_4 = Instance.new("UIPadding")

		local UIListLayout_4 = Instance.new("UIListLayout")

		Section.Name = "Section"

		Section.Parent = Layout

			Section.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

			Section.BackgroundTransparency = 0.3

		Section.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Section.BorderSizePixel = 0

		Section.Position = UDim2.new(1.36775815, 0, 0.545454562, 0)

		Section.Size = UDim2.new(1, 0, 0, 55)

			UICorner_5.CornerRadius = UDim.new(0, 10)

		UICorner_5.Parent = Section

		NameSection.Name = "NameSection"

		NameSection.Parent = Section

		NameSection.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		NameSection.BackgroundTransparency = 1.000

		NameSection.BorderColor3 = Color3.fromRGB(0, 0, 0)

		NameSection.BorderSizePixel = 0

		NameSection.Size = UDim2.new(1, 0, 0, 35)

		Title.Name = "Title"

		Title.Parent = NameSection

		Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Title.BackgroundTransparency = 1.000

		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Title.BorderSizePixel = 0

		Title.Position = UDim2.new(0, 0, 0, 5)

		Title.Size = UDim2.new(1, 0, 1, -5)

		Title.Font = Enum.Font.GothamBold

		Title.Text = RealNameSection

			Title.TextColor3 = Color3.fromRGB(255, 0, 0)

			Title.TextSize = 16.000

		Line_3.Name = "Line"

		Line_3.Parent = NameSection

			Line_3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

		Line_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Line_3.BorderSizePixel = 0

		Line_3.Position = UDim2.new(0, 0, 1, -1)

		Line_3.Size = UDim2.new(1, 0, 0, 1)

		SectionList.Name = "SectionList"

		SectionList.Parent = Section

		SectionList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		SectionList.BackgroundTransparency = 1.000

		SectionList.BorderColor3 = Color3.fromRGB(0, 0, 0)

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

		UIListLayout_4.Padding = UDim.new(0, 5)

		UIListLayout_4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

			Section.Size = UDim2.new(1, 0, 0, UIListLayout_4.AbsoluteContentSize.Y + 55)

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

		local UIStroke = Instance.new("UIStroke")

		local Toggle_Click = Instance.new("TextButton")

		local Content = Instance.new("TextLabel")

		Toggle.Name = "Toggle"

		Toggle.Parent = SectionList

			Toggle.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

			Toggle.BackgroundTransparency = 0.3

		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Toggle.BorderSizePixel = 0

		Toggle.Size = UDim2.new(1, 0, 0, 35)

			UICorner_6.CornerRadius = UDim.new(0, 10)

		UICorner_6.Parent = Toggle

		Title_2.Name = "Title"

		Title_2.Parent = Toggle

		Title_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Title_2.BackgroundTransparency = 1.000

		Title_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Title_2.BorderSizePixel = 0

		Title_2.Position = UDim2.new(0, 10, 0, 0)

		Title_2.Size = UDim2.new(1, -40, 1, 0)

		Title_2.Font = Enum.Font.Gotham

		Title_2.Text = cftoggle.Title

		Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)

		Title_2.TextSize = 14.000

		Title_2.TextXAlignment = Enum.TextXAlignment.Left

		ToggleCheck.Name = "ToggleCheck"

		ToggleCheck.Parent = Toggle

		ToggleCheck.AnchorPoint = Vector2.new(1, 0.5)

		ToggleCheck.BackgroundColor3 = Color3.fromRGB(12, 12, 12)

		ToggleCheck.BorderColor3 = Color3.fromRGB(0, 0, 0)

		ToggleCheck.BorderSizePixel = 0

		ToggleCheck.Position = UDim2.new(1, -10, 0.5, 0)

		ToggleCheck.Size = UDim2.new(0, 20, 0, 20)

		UICorner_7.CornerRadius = UDim.new(0, 8)

		UICorner_7.Parent = ToggleCheck

		UIStroke.Name = "UIStroke"

		UIStroke.Parent = ToggleCheck

		UIStroke.Color = Color3.fromRGB(60, 60, 60)

		UIStroke.Thickness = 2

		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		Toggle_Click.Name = "Toggle_Click"

		Toggle_Click.Parent = Toggle

		Toggle_Click.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Toggle_Click.BackgroundTransparency = 1.000

		Toggle_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Toggle_Click.BorderSizePixel = 0

		Toggle_Click.Size = UDim2.new(1, 0, 1, 0)

		Toggle_Click.Font = Enum.Font.SourceSans

		Toggle_Click.Text = ""

		Toggle_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

		Content.Name = "Content"

		Content.Parent = Toggle

		Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Content.BackgroundTransparency = 1.000

		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Content.BorderSizePixel = 0

		Content.Position = UDim2.new(0, 10, 0, 22)

		Content.Size = UDim2.new(1, -40, 1, 0)

		Content.Font = Enum.Font.Gotham

		Content.Text = cftoggle.Description

		Content.TextColor3 = Color3.fromRGB(120, 120, 120)

		Content.TextSize = 13.000

		Content.TextXAlignment = Enum.TextXAlignment.Left

		Content.TextYAlignment = Enum.TextYAlignment.Top

		Library:UpdateContent(Content, Title_2, Toggle)

		local ToggleFunc = { Value = cftoggle.Default }

		function ToggleFunc:Set(Boolean)

			if Boolean then

				Library:TweenInstance(ToggleCheck, 0.2, "BackgroundColor3", Color3.fromRGB(255, 0, 0))

				Library:TweenInstance(UIStroke, 0.2, "Color", Color3.fromRGB(255, 0, 0))

			else

				Library:TweenInstance(ToggleCheck, 0.2, "BackgroundColor3", Color3.fromRGB(15, 15, 15))

				Library:TweenInstance(UIStroke, 0.2, "Color", Color3.fromRGB(60, 60, 60))

			end

			self.Value = Boolean

			cftoggle.Callback(Boolean)

		end

		ToggleFunc:Set(ToggleFunc.Value)

		Toggle_Click.Activated:Connect(function()

			ToggleFunc:Set(not ToggleFunc.Value)

		end)

		return ToggleFunc

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

		local ButtonFrame = Instance.new("Frame")

		local UICorner_Button = Instance.new("UICorner")

		local Button_Click = Instance.new("TextButton")

		local Content_2 = Instance.new("TextLabel")

		Button.Name = "Button"

		Button.Parent = SectionList

			Button.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

			Button.BackgroundTransparency = 0.3

		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Button.BorderSizePixel = 0

		Button.Size = UDim2.new(1, 0, 0, 35)

			UICorner_9.CornerRadius = UDim.new(0, 10)

		UICorner_9.Parent = Button

		Title_3.Name = "Title"

		Title_3.Parent = Button

		Title_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Title_3.BackgroundTransparency = 1.000

		Title_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Title_3.BorderSizePixel = 0

		Title_3.Position = UDim2.new(0, 10, 0, 0)

		Title_3.Size = UDim2.new(1, -100, 1, 0)

		Title_3.Font = Enum.Font.GothamBold

		Title_3.Text = cfbutton.Title

		Title_3.TextColor3 = Color3.fromRGB(255, 255, 255)

		Title_3.TextSize = 14.000

		Title_3.TextXAlignment = Enum.TextXAlignment.Left

		ButtonFrame.Name = "ButtonFrame"

		ButtonFrame.Parent = Button

		ButtonFrame.AnchorPoint = Vector2.new(1, 0.5)

			ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

		ButtonFrame.BorderSizePixel = 0

		ButtonFrame.Position = UDim2.new(1, -10, 0.5, 0)

		ButtonFrame.Size = UDim2.new(0, 70, 0, 22)

		UICorner_Button.CornerRadius = UDim.new(0, 8)

		UICorner_Button.Parent = ButtonFrame

		Button_Click.Name = "Button_Click"

		Button_Click.Parent = ButtonFrame

		Button_Click.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Button_Click.BackgroundTransparency = 1.000

		Button_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Button_Click.BorderSizePixel = 0

		Button_Click.Size = UDim2.new(1, 0, 1, 0)

		Button_Click.Font = Enum.Font.GothamBold

		Button_Click.Text = "Click"

			Button_Click.TextColor3 = Color3.fromRGB(255, 255, 255)

		Button_Click.TextSize = 13.000

		Content_2.Name = "Content"

		Content_2.Parent = Button

		Content_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Content_2.BackgroundTransparency = 1.000

		Content_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Content_2.BorderSizePixel = 0

		Content_2.Position = UDim2.new(0, 10, 0, 22)

		Content_2.Size = UDim2.new(1, -100, 1, 0)

		Content_2.Font = Enum.Font.Gotham

		Content_2.Text = cfbutton.Description

		Content_2.TextColor3 = Color3.fromRGB(255, 255, 255)

		Content_2.TextSize = 13.000

		Content_2.TextXAlignment = Enum.TextXAlignment.Left

		Content_2.TextYAlignment = Enum.TextYAlignment.Top

		Library:UpdateContent(Content_2, Title_3, Button)

		Button_Click.Activated:Connect(function()

				Library:TweenInstance(ButtonFrame, 0.1, "BackgroundColor3", Color3.fromRGB(200, 0, 0))

				cfbutton.Callback()

				wait(0.1)

				Library:TweenInstance(ButtonFrame, 0.2, "BackgroundColor3", Color3.fromRGB(255, 0, 0))

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

			Dropdown.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

			Dropdown.BackgroundTransparency = 0.3

		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Dropdown.BorderSizePixel = 0

		Dropdown.Size = UDim2.new(1, 0, 0, 60)

			UICorner_19.CornerRadius = UDim.new(0, 10)

		UICorner_19.Parent = Dropdown

		Title_8.Name = "Title"

		Title_8.Parent = Dropdown

		Title_8.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Title_8.BackgroundTransparency = 1.000

		Title_8.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Title_8.BorderSizePixel = 0

		Title_8.Position = UDim2.new(0, 10, 0, 8)

		Title_8.Size = UDim2.new(1, -20, 0, 16)

		Title_8.Font = Enum.Font.GothamBold

		Title_8.Text = cfdropdown.Title

		Title_8.TextColor3 = Color3.fromRGB(180, 180, 180)

		Title_8.TextSize = 14.000

		Title_8.TextXAlignment = Enum.TextXAlignment.Left

		Content_6.Name = "Content"

		Content_6.Parent = Dropdown

		Content_6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Content_6.BackgroundTransparency = 1.000

		Content_6.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Content_6.BorderSizePixel = 0

		Content_6.Position = UDim2.new(0, 10, 0, 22)

		Content_6.Size = UDim2.new(1, -60, 1, 0)

		Content_6.Font = Enum.Font.Gotham

		Content_6.Text = cfdropdown.Description

		Content_6.TextColor3 = Color3.fromRGB(100, 100, 100)

		Content_6.TextSize = 13.000

		Content_6.TextXAlignment = Enum.TextXAlignment.Left

		Content_6.TextYAlignment = Enum.TextYAlignment.Top

		Selects.Name = "Selects"

		Selects.Parent = Dropdown

			Selects.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Selects.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Selects.BorderSizePixel = 0

		Selects.Position = UDim2.new(0, 10, 0, 28)

		Selects.Size = UDim2.new(1, -20, 0, 25)

			UICorner_20.CornerRadius = UDim.new(0, 10)

		UICorner_20.Parent = Selects

		SelectText.Name = "SelectText"

		SelectText.Parent = Selects

		SelectText.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		SelectText.BackgroundTransparency = 1.000

		SelectText.BorderColor3 = Color3.fromRGB(0, 0, 0)

		SelectText.BorderSizePixel = 0

		SelectText.Position = UDim2.new(0, 10, 0, 0)

		SelectText.Size = UDim2.new(1, -35, 1, 0)

		SelectText.Font = Enum.Font.GothamBold

		SelectText.Text = ""

		SelectText.TextColor3 = Color3.fromRGB(255, 255, 255)

		SelectText.TextSize = 14.000

		SelectText.TextXAlignment = Enum.TextXAlignment.Left

		UITextSizeConstraint.Parent = SelectText

		UITextSizeConstraint.MaxTextSize = 13

		ImageLabel_2.Parent = Selects

		ImageLabel_2.AnchorPoint = Vector2.new(1, 0.5)

		ImageLabel_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		ImageLabel_2.BackgroundTransparency = 1.000

		ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		ImageLabel_2.BorderSizePixel = 0

		ImageLabel_2.Position = UDim2.new(1, -8, 0.5, 0)

		ImageLabel_2.Size = UDim2.new(0, 16, 0, 16)

		ImageLabel_2.Image = "rbxassetid://80845745785361"

		ImageLabel_2.ImageColor3 = Color3.fromRGB(255, 255, 255)

		Drop_Click.Name = "Drop_Click"

		Drop_Click.Parent = Selects

		Drop_Click.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Drop_Click.BackgroundTransparency = 1.000

		Drop_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Drop_Click.BorderSizePixel = 0

		Drop_Click.Size = UDim2.new(1, 0, 1, 0)

		Drop_Click.Font = Enum.Font.SourceSans

		Drop_Click.Text = ""

		Drop_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

		Drop_Click.TextSize = 16.000

		Library:UpdateContent(Content_6, Title_8, Dropdown)

		DropdownList.Name = "DropdownList"

		DropdownList.Parent = DropdownZone

		DropdownList.AnchorPoint = Vector2.new(0.5, 0.5)

		DropdownList.BackgroundColor3 = Color3.fromRGB(18, 18, 18)

		DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)

		DropdownList.BorderSizePixel = 0

		DropdownList.Position = UDim2.new(0.5, 0, 0.5, 0)

		DropdownList.Size = UDim2.new(0, 300, 0, 250)

		DropdownList.Visible = false

		UIStroke_3.Color = Color3.fromRGB(100, 100, 100)

		UIStroke_3.Transparency = 0.5

		UIStroke_3.Parent = DropdownList

		UICorner_24.CornerRadius = UDim.new(0, 8)

		UICorner_24.Parent = DropdownList

		Topbar.Name = "Topbar"

		Topbar.Parent = DropdownList

		Topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Topbar.BackgroundTransparency = 1.000

		Topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Topbar.Size = UDim2.new(1, 0, 0, 50)

		Title_10.Name = "Title"

		Title_10.Parent = Topbar

		Title_10.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Title_10.BackgroundTransparency = 1.000

		Title_10.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Title_10.BorderSizePixel = 0

		Title_10.Position = UDim2.new(0, 15, 0, 0)

		Title_10.Size = UDim2.new(1, -150, 1, -5)

		Title_10.Font = Enum.Font.GothamBold

		Title_10.Text = cfdropdown.Title

		Title_10.TextColor3 = Color3.fromRGB(255, 255, 255)

		Title_10.TextSize = 16.000

		Title_10.TextWrapped = true

		Title_10.TextXAlignment = Enum.TextXAlignment.Left

		SearchFrame_2.Name = "SearchFrame"

		SearchFrame_2.Parent = Topbar

		SearchFrame_2.BackgroundColor3 = Color3.fromRGB(12, 12, 12)

		SearchFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		SearchFrame_2.BorderSizePixel = 0

		SearchFrame_2.Position = UDim2.new(1, -130, 0, 8)

		SearchFrame_2.Size = UDim2.new(0, 80, 0, 30)

		UICorner_25.CornerRadius = UDim.new(0, 8)

		UICorner_25.Parent = SearchFrame_2

		UIStroke_4.Color = Color3.fromRGB(100, 100, 100)

		UIStroke_4.Transparency = 0.7400000095367432

		UIStroke_4.Parent = SearchFrame_2

		IconSearch_2.Name = "IconSearch"

		IconSearch_2.Parent = SearchFrame_2

		IconSearch_2.AnchorPoint = Vector2.new(0, 0.5)

		IconSearch_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		IconSearch_2.BackgroundTransparency = 1.000

		IconSearch_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

		IconSearch_2.BorderSizePixel = 0

		IconSearch_2.Position = UDim2.new(0, 10, 0.5, 0)

		IconSearch_2.Size = UDim2.new(0, 15, 0, 15)

		IconSearch_2.Image = "rbxassetid://71309835376233"

		TextBox.Parent = SearchFrame_2

		TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		TextBox.BackgroundTransparency = 1.000

		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)

		TextBox.BorderSizePixel = 0

		TextBox.Position = UDim2.new(0, 35, 0, 0)

		TextBox.Size = UDim2.new(1, -35, 1, 0)

		TextBox.Font = Enum.Font.GothamBold

		TextBox.PlaceholderText = "Search..."

		TextBox.Text = ""

		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

		TextBox.TextSize = 13.000

		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		Click_Dropdown.Name = "Click_Dropdown"

		Click_Dropdown.Parent = Topbar

		Click_Dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		Click_Dropdown.BackgroundTransparency = 1.000

		Click_Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Click_Dropdown.BorderSizePixel = 0

		Click_Dropdown.Position = UDim2.new(1, -40, 0, 8)

		Click_Dropdown.Size = UDim2.new(0, 30, 0, 30)

		Click_Dropdown.Text = ""

		Icon_4.Name = "Icon"

		Icon_4.Parent = Click_Dropdown

		Icon_4.AnchorPoint = Vector2.new(0.5, 0.5)

		Icon_4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

		Real_List.BackgroundColor3 = Color3.fromRGB(12, 12, 12)

		Real_List.BorderColor3 = Color3.fromRGB(0, 0, 0)

		Real_List.BorderSizePixel = 0

		Real_List.Position = UDim2.new(0, 10, 0, 50)

		Real_List.Selectable = false

		Real_List.ScrollBarThickness = 0

		Real_List.Size = UDim2.new(1, -20, 1, -60)

		Library:UpdateScrolling(Real_List, UIListLayout_5)

		UICorner_26.CornerRadius = UDim.new(0, 8)

		UICorner_26.Parent = Real_List

		UIListLayout_5.Parent = Real_List

		UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

		UIListLayout_5.Padding = UDim.new(0, 5)

		UIPadding_5.Parent = Real_List

		UIPadding_5.PaddingBottom = UDim.new(0, 7)

		UIPadding_5.PaddingLeft = UDim.new(0, 7)

		UIPadding_5.PaddingRight = UDim.new(0, 7)

		UIPadding_5.PaddingTop = UDim.new(0, 7)

		local UICorner_29 = Instance.new("UICorner")

		UICorner_29.Parent = DropdownZone

		Drop_Click.Activated:Connect(function()

			DropdownZone.Visible = true

			DropdownList.Visible = true

			Library:TweenInstance(DropdownZone, 0.3, "BackgroundTransparency", 0.3)

		end)

		Click_Dropdown.Activated:Connect(function()

			DropdownList.Visible = false

			Library:TweenInstance(DropdownZone, 0.3, "BackgroundTransparency", 1)

			wait(0.3)

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

						Library:TweenInstance(v, 0.3, "BackgroundTransparency", 0)

						Library:TweenInstance(v.Title, 0.3, "TextTransparency", 0)

					else

						Library:TweenInstance(v, 0.3, "BackgroundTransparency", 0.98)

						Library:TweenInstance(v.Title, 0.3, "TextTransparency", 0.5)

					end

				end

			end

			local DropValueStr = table.concat(DropFunc.Value, ", ")

			if DropValueStr == "" then

				SelectText.Text = "None"

			else

				SelectText.Text = DropValueStr

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

				Option2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

			Option2.BackgroundTransparency = 0.980

			Option2.BorderColor3 = Color3.fromRGB(0, 0, 0)

			Option2.BorderSizePixel = 0

			Option2.Size = UDim2.new(1, 0, 0, 35)

				UICorner_28.CornerRadius = UDim.new(0, 10)

			UICorner_28.Parent = Option2

			Option2_Click.Name = "Option2_Click"

			Option2_Click.Parent = Option2

			Option2_Click.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

			Option2_Click.BackgroundTransparency = 1.000

			Option2_Click.BorderColor3 = Color3.fromRGB(0, 0, 0)

			Option2_Click.BorderSizePixel = 0

			Option2_Click.Size = UDim2.new(1, 0, 1, 0)

			Option2_Click.Font = Enum.Font.SourceSans

			Option2_Click.Text = ""

			Option2_Click.TextColor3 = Color3.fromRGB(0, 0, 0)

			Option2_Click.TextSize = 16.000

			Title_12.Name = "Title"

			Title_12.Parent = Option2

			Title_12.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

			Title_12.BackgroundTransparency = 1.000

			Title_12.BorderColor3 = Color3.fromRGB(0, 0, 0)

			Title_12.BorderSizePixel = 0

			Title_12.Size = UDim2.new(1, 0, 1, 0)

			Title_12.Font = Enum.Font.GothamBold

			Title_12.Text = v

			Title_12.TextColor3 = Color3.fromRGB(255, 255, 255)

			Title_12.TextSize = 14.000

			Title_12.TextTransparency = 0.500

				UIGradient_3.Color = ColorSequence.new { ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)) }

			UIGradient_3.Rotation = 0.9900000095367432

			UIGradient_3.Transparency = NumberSequence.new { NumberSequenceKeypoint.new(0.00, 0.50), NumberSequenceKeypoint.new(0.50, 0.49), NumberSequenceKeypoint.new(1.00, 0.44) }

			UIGradient_3.Parent = Option2

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

				Input.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

				Input.BackgroundTransparency = 0.3

					Input.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Input.BorderSizePixel = 0

					Input.Size = UDim2.new(1, 0, 0, 35)

					UICorner_17.CornerRadius = UDim.new(0, 10)

					UICorner_17.Parent = Input

					Title_7.Name = "Title"

					Title_7.Parent = Input

					Title_7.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Title_7.BackgroundTransparency = 0.5

					Title_7.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Title_7.BorderSizePixel = 0

					Title_7.Position = UDim2.new(0, 10, 0, 0)

					Title_7.Size = UDim2.new(1, -60, 1, 0)

					Title_7.Font = Enum.Font.GothamBold

					Title_7.Text = cftextbox.Title

					Title_7.TextColor3 = Color3.fromRGB(255, 255, 255)

					Title_7.TextSize = 14.000

					Title_7.TextXAlignment = Enum.TextXAlignment.Left

					Content_5.Name = "Content"

					Content_5.Parent = Input

					Content_5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Content_5.BackgroundTransparency = 1.000

					Content_5.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Content_5.BorderSizePixel = 0

					Content_5.Position = UDim2.new(0, 10, 0, 22)

					Content_5.Size = UDim2.new(1, -160, 1, 0)

					Content_5.Font = Enum.Font.GothamBold

					Content_5.Text = cftextbox.Description

					Content_5.TextColor3 = Color3.fromRGB(100, 100, 100)

					Content_5.TextSize = 13.000

					Content_5.TextXAlignment = Enum.TextXAlignment.Left

					Content_5.TextYAlignment = Enum.TextYAlignment.Top

					Library:UpdateContent(Content_5, Title_7, Input)

					TextboxFrame.Name = "TextboxFrame"

					TextboxFrame.Parent = Input

					TextboxFrame.AnchorPoint = Vector2.new(0, 0.5)

					TextboxFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

					TextboxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

					TextboxFrame.BorderSizePixel = 0

					TextboxFrame.Position = UDim2.new(1, -110, 0.5, 0)

					TextboxFrame.Size = UDim2.new(0, 100, 0, 28)

					UICorner_18.CornerRadius = UDim.new(0, 10)

					UICorner_18.Parent = TextboxFrame

					RealTextBox.Name = "RealTextBox"

					RealTextBox.Parent = TextboxFrame

					RealTextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					RealTextBox.BackgroundTransparency = 1.000

					RealTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)

					RealTextBox.BorderSizePixel = 0

					RealTextBox.Position = UDim2.new(0, 35, 0, 0)

					RealTextBox.Size = UDim2.new(1, -35, 1, 0)

					RealTextBox.Font = Enum.Font.GothamBold

					RealTextBox.PlaceholderText = cftextbox.PlaceHolder

					RealTextBox.Text = cftextbox.Default

					RealTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

					RealTextBox.TextSize = 13.000

					RealTextBox.TextXAlignment = Enum.TextXAlignment.Left

					WritingIcon.Name = "WritingIcon"

					WritingIcon.Parent = TextboxFrame

					WritingIcon.AnchorPoint = Vector2.new(0, 0.5)

					WritingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					WritingIcon.BackgroundTransparency = 1.000

					WritingIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)

					WritingIcon.BorderSizePixel = 0

					WritingIcon.Position = UDim2.new(0, 10, 0.5, 0)

					WritingIcon.Size = UDim2.new(0, 15, 0, 15)

					WritingIcon.Image = "rbxassetid://126409600467363"

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

				Slider.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

				Slider.BackgroundTransparency = 0.3

					Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Slider.BorderSizePixel = 0

					Slider.Size = UDim2.new(1, 0, 0, 35)

					UICorner_10.CornerRadius = UDim.new(0, 10)

					UICorner_10.Parent = Slider

					Title_4.Name = "Title"

					Title_4.Parent = Slider

					Title_4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Title_4.BackgroundTransparency = 1.000

					Title_4.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Title_4.BorderSizePixel = 0

					Title_4.Position = UDim2.new(0, 10, 0, 0)

					Title_4.Size = UDim2.new(1, -60, 1, 0)

					Title_4.Font = Enum.Font.GothamBold

					Title_4.Text = cfslider.Title

					Title_4.TextColor3 = Color3.fromRGB(255, 255, 255)

					Title_4.TextSize = 14.000

					Title_4.TextXAlignment = Enum.TextXAlignment.Left

					Content_3.Name = "Content"

					Content_3.Parent = Slider

					Content_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Content_3.BackgroundTransparency = 1.000

					Content_3.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Content_3.BorderSizePixel = 0

					Content_3.Position = UDim2.new(0, 10, 0, 22)

					Content_3.Size = UDim2.new(1, -160, 1, 0)

					Content_3.Font = Enum.Font.GothamBold

					Content_3.Text = cfslider.Description

					Content_3.TextColor3 = Color3.fromRGB(100, 100, 100)

					Content_3.TextSize = 13.000

					Content_3.TextXAlignment = Enum.TextXAlignment.Left

					Content_3.TextYAlignment = Enum.TextYAlignment.Top

					Library:UpdateContent(Content_3, Title_4, Slider)

					SliderFrame.Name = "SliderFrame"

					SliderFrame.Parent = Slider

					SliderFrame.AnchorPoint = Vector2.new(0, 0.5)

					SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)

					SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

					SliderFrame.BorderSizePixel = 0

					SliderFrame.Position = UDim2.new(1, -110, 0.5, 0)

					SliderFrame.Size = UDim2.new(0, 100, 0, 8)

					UICorner_11.CornerRadius = UDim.new(0, 8)

					UICorner_11.Parent = SliderFrame

					SliderDraggable.Name = "SliderDraggable"

					SliderDraggable.Parent = SliderFrame

					SliderDraggable.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

					SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)

					SliderDraggable.BorderSizePixel = 0

					SliderDraggable.Size = UDim2.new(0, 20, 1, 0)

					UICorner_12.CornerRadius = UDim.new(0, 8)

					UICorner_12.Parent = SliderDraggable

					Circle.Name = "Circle"

					Circle.Parent = SliderDraggable

					Circle.AnchorPoint = Vector2.new(0, 0.100000001)

					Circle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Circle.BorderSizePixel = 0

					Circle.Position = UDim2.new(1, -6, 0, 0)

					Circle.Size = UDim2.new(0, 12, 0, 12)

					UICorner_13.CornerRadius = UDim.new(0, 8)

					UICorner_13.Parent = Circle

					SliderValue.Name = "SliderValue"

					SliderValue.Parent = Slider

					SliderValue.AnchorPoint = Vector2.new(0, 0.5)

					SliderValue.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)

					SliderValue.BorderSizePixel = 0

					SliderValue.Position = UDim2.new(1, -150, 0.5, 0)

					SliderValue.Size = UDim2.new(0, 35, 0, 20)

					SliderValue.Font = Enum.Font.GothamBold

					SliderValue.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)

					SliderValue.PlaceholderText = "..."

					SliderValue.Text = ""

					SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)

					SliderValue.TextSize = 13.000

					UICorner_14.CornerRadius = UDim.new(0, 10)

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

					Seperator.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Seperator.BackgroundTransparency = 1.000

					Seperator.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Seperator.BorderSizePixel = 0

					Seperator.Size = UDim2.new(1, 0, 0, 20)

					Title_5.Name = "Title"

					Title_5.Parent = Seperator

					Title_5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Title_5.BackgroundTransparency = 1.000

					Title_5.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Title_5.BorderSizePixel = 0

					Title_5.Position = UDim2.new(0, 10, 0, 0)

					Title_5.Size = UDim2.new(1, -10, 1, 0)

					Title_5.Font = Enum.Font.GothamBold

					Title_5.Text = args

					Title_5.TextColor3 = Color3.fromRGB(255, 255, 255)

					Title_5.TextSize = 14.000

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

				Paragraph.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

				Paragraph.BackgroundTransparency = 0.3

					Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Paragraph.BorderSizePixel = 0

					Paragraph.Size = UDim2.new(1, 0, 0, 45)

					UICorner_16.CornerRadius = UDim.new(0, 10)

					UICorner_16.Parent = Paragraph

					Title_6.Name = "Title"

					Title_6.Parent = Paragraph

					Title_6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Title_6.BackgroundTransparency = 1.000

					Title_6.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Title_6.BorderSizePixel = 0

					Title_6.Position = UDim2.new(0, 10, 0, 7)

					Title_6.Size = UDim2.new(1, -60, 0, 16)

					Title_6.Font = Enum.Font.GothamBold

					Title_6.Text = cfpara.Title

					Title_6.TextColor3 = Color3.fromRGB(255, 255, 255)

					Title_6.TextSize = 14.000

					Title_6.TextXAlignment = Enum.TextXAlignment.Left

					Content_4.Name = "Content"

					Content_4.Parent = Paragraph

					Content_4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

					Content_4.BackgroundTransparency = 1.000

					Content_4.BorderColor3 = Color3.fromRGB(0, 0, 0)

					Content_4.BorderSizePixel = 0

					Content_4.Position = UDim2.new(0, 10, 0, 22)

					Content_4.Size = UDim2.new(1, -10, 1, 0)

					Content_4.Font = Enum.Font.GothamBold

					Content_4.Text = cfpara.Content

					Content_4.TextColor3 = Color3.fromRGB(100, 100, 100)

					Content_4.TextSize = 13.000

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
					DiscordCard.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
					DiscordCard.BackgroundTransparency = 0.3
					DiscordCard.BorderSizePixel = 0
					DiscordCard.Size = UDim2.new(1, 0, 0, 65)

					UICorner.CornerRadius = UDim.new(0, 10)
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
					Title.TextColor3 = Color3.fromRGB(255, 255, 255)
					Title.TextSize = 14
					Title.TextXAlignment = Enum.TextXAlignment.Left

					SubTitle.Parent = DiscordCard
					SubTitle.BackgroundTransparency = 1
					SubTitle.Position = UDim2.new(0, 65, 0, 32)
					SubTitle.Size = UDim2.new(1, -140, 0, 20)
					SubTitle.Font = Enum.Font.Gotham
					SubTitle.Text = "Clique para entrar no servidor"
					SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
					SubTitle.TextSize = 11
					SubTitle.TextXAlignment = Enum.TextXAlignment.Left

					JoinBtn.Name = "JoinBtn"
					JoinBtn.Parent = DiscordCard
					JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
					JoinBtn.Position = UDim2.new(1, -75, 0, 17)
					JoinBtn.Size = UDim2.new(0, 65, 0, 30)
					JoinBtn.Font = Enum.Font.GothamBold
					JoinBtn.Text = "Join"
					JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
					JoinBtn.TextSize = 13

					BtnCorner.CornerRadius = UDim.new(0, 10)
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

			G2L["2"]["BackgroundColor3"] = Color3.fromRGB(255, 0, 0);

		G2L["2"]["Image"] = [[rbxassetid://101817370702077]];

		G2L["2"]["Size"] = UDim2.new(0, 50, 0, 50);

		G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

		G2L["2"]["AnchorPoint"] = Vector2.new(0, 0)

	    G2L["2"]["Position"] = UDim2.new(0, 30, 0, 30)

		G2L["3"] = Instance.new("UICorner", G2L["2"]);

		G2L["3"]["CornerRadius"] = UDim.new(1, 0);

		G2L["4"] = Instance.new("UIStroke", G2L["2"]);

		G2L["4"]["Thickness"] = 2;

		G2L["4"]["Color"] = Color3.fromRGB(20, 20, 20);

		G2L["2"].MouseButton1Click:Connect(function()

			TeddyUI_Premium.Enabled = not TeddyUI_Premium.Enabled

		end)

		Minize.MouseButton1Click:Connect(function()

			TeddyUI_Premium.Enabled = false

		end)

		return Tab

	end

	return Library
