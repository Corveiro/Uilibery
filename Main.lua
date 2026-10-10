--[[
	SenaLib v1.0.0
	UI library para o Sena Hub (Delta / executors Luau).

	Uso (igual ao SenaHub):
		local Lib = loadstring(game:HttpGet("SEU_LINK_RAW"))()
		local Win = Lib:Window({Title="Sena BETA |", Footer="Steal An Egg", Folder="SenaSAEv4", Version=1, Color=Color3.fromRGB(232,232,238), Image="..."})
		local Tab = Win:AddTab({Name="Main", Icon="home"})
		local Sec = Tab:AddSection("Auto Steal")
		Sec:AddToggle({Title="", Content="", Default=false, Callback=function(v) end})
		Sec:AddSlider({Title="", Min=1, Max=10, Default=5, Increment=1, Callback=function(v) end})
		Sec:AddDropdown({Title="", Options={}, Multi=false, Default="", MaxVisible=5, Callback=function(v) end})
		Sec:AddInput({Title="", Placeholder="", Default="", Flag="x", Callback=function(text) end})
		Sec:AddButton({Title="", SubTitle="", Content="", Callback=function() end, SubCallback=function() end})
		Sec:AddParagraph({Title="", Content=""})
		Sec:AddSubSection("Nome")
		Sec:AddActionList({Title="", EmptyText="", VisibleRows=6, ButtonWidth=76})
		Sec:AddLiveChat({Title="", Height=300})
		Sec:AddSupportCard({})
		Sec:AddKeybind / Sec:AddColorPicker
		Win:AddForum({Name="Forum", Icon="forum", Section="Config Forum"})
		Lib:Notify({Title="", Content="", Duration=3})

	- Os valores (.Value) de cada elemento sao salvos em <Folder>/SenaLib_config.json
	  e restaurados ao recriar a UI (o SenaHub le .Value depois de montar a UI).
	- Callbacks NAO disparam na criacao, so quando o usuario interage (ou Set sem silent).
	- Chat ao vivo: defina Lib.ChatHandler = function(texto) ... end e use Lib.LiveChat:AddMessage(user, texto)
	  para ligar a um backend. Sem handler, o chat funciona local.
	- Links do card de suporte: Lib.SupportLinks = {{Name="Discord", Url="..."}}
]]

local cloneref_ = cloneref or function(x) return x end
local function getService(name)
	local ok, s = pcall(function() return cloneref_(game:GetService(name)) end)
	if ok and s then return s end
	return game:GetService(name)
end

local Players = getService("Players")
local UIS = getService("UserInputService")
local TweenService = getService("TweenService")
local HttpService = getService("HttpService")
local CoreGui = getService("CoreGui")

local genv = (getgenv and getgenv()) or _G

-- limpa instancia anterior (re-execucao)
if type(genv.__SenaLibInstance) == "table" and type(genv.__SenaLibInstance.DestroyGui) == "function" then
	pcall(genv.__SenaLibInstance.DestroyGui, genv.__SenaLibInstance)
end

local Library = {
	Version = "1.0.0",
	Windows = {},
	SupportLinks = { { Name = "Website", Url = "https://senahub.xyz" } },
}
genv.__SenaLibInstance = Library

----------------------------------------------------------------------
-- Tema
----------------------------------------------------------------------
local T = {
	bg = Color3.fromRGB(13, 13, 18),
	side = Color3.fromRGB(17, 17, 23),
	card = Color3.fromRGB(24, 24, 32),
	card2 = Color3.fromRGB(32, 32, 43),
	stroke = Color3.fromRGB(46, 46, 60),
	text = Color3.fromRGB(232, 232, 238),
	sub = Color3.fromRGB(162, 162, 174),
	accent = Color3.fromRGB(139, 124, 255),
	good = Color3.fromRGB(74, 222, 128),
	bad = Color3.fromRGB(239, 68, 68),
}

local Icons = {
	home = "🏠", flame = "🔥", users = "👥", settings = "⚙️", eye = "👁", chat = "💬",
	forum = "🗨", donator = "💎", ["repeat"] = "🔁", swords = "⚔️", sparkles = "✨",
	star = "⭐", bolt = "⚡", shop = "🛒", egg = "🥚", pet = "🐾", tools = "🛠",
	info = "ℹ️", list = "📋", map = "🗺", gift = "🎁", clock = "⏰", code = "💻", key = "🔑",
}

----------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------
local function rname()
	return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 14)
end

local function getParent()
	local ok, h = pcall(function() return gethui and gethui() end)
	if ok and h then return h end
	local ok2 = pcall(function() return CoreGui.Name end)
	if ok2 then return CoreGui end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function protect(gui)
	if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
end

local function new(class, props, parent)
	local o = Instance.new(class)
	if props then
		for k, v in pairs(props) do o[k] = v end
	end
	if parent then o.Parent = parent end
	return o
end

local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o) end
local function stroke(o, c, th, tr)
	return new("UIStroke", {
		Color = c or T.stroke, Thickness = th or 1, Transparency = tr or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, o)
end
local function padding(o, l, r, t, b)
	return new("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0),
		PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0),
	}, o)
end
local function vlist(o, pad)
	return new("UIListLayout", {
		Padding = UDim.new(0, pad or 0), SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
	}, o)
end

local function label(parent, props)
	local p = {
		BackgroundTransparency = 1, BorderSizePixel = 0, Font = Enum.Font.GothamMedium, TextSize = 13,
		TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
		RichText = true, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0), Text = "",
	}
	if props then
		for k, v in pairs(props) do p[k] = v end
	end
	return new("TextLabel", p, parent)
end

local function tw(o, props, t)
	if not o or not o.Parent then return end
	local tween = TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tween:Play()
	return tween
end

local function fire(cb, ...)
	if type(cb) ~= "function" then return end
	local args = table.pack(...)
	task.spawn(function()
		local ok, err = pcall(cb, table.unpack(args, 1, args.n))
		if not ok then warn("[SenaLib] Callback error: " .. tostring(err)) end
	end)
end

local function hex(c)
	return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function esc(s)
	s = tostring(s)
	s = s:gsub("&", "&amp;")
	s = s:gsub("<", "&lt;")
	s = s:gsub(">", "&gt;")
	return s
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function isMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

local function track(win, c)
	win._conns[#win._conns + 1] = c
	return c
end

----------------------------------------------------------------------
-- Config (persistencia)
----------------------------------------------------------------------
local Config = { data = {}, enabled = false, pending = false, path = nil }

function Config.setup(folder)
	Config.data = {}
	Config.enabled = false
	Config.path = nil
	if type(folder) ~= "string" or folder == "" then return end
	if not (writefile and readfile and isfile) then return end
	pcall(function()
		if makefolder and isfolder and not isfolder(folder) then makefolder(folder) end
	end)
	Config.path = folder .. "/SenaLib_config.json"
	Config.enabled = true
	pcall(function()
		if isfile(Config.path) then
			local d = HttpService:JSONDecode(readfile(Config.path))
			if type(d) == "table" then Config.data = d end
		end
	end)
end

function Config.get(k) return Config.data[k] end

function Config.set(k, v)
	Config.data[k] = v
	if not Config.enabled or Config.pending then return end
	Config.pending = true
	task.delay(0.6, function()
		Config.pending = false
		pcall(function() writefile(Config.path, HttpService:JSONEncode(Config.data)) end)
	end)
end

local function makeKey(sec, opts, kind)
	local win = sec._win
	local base
	if opts.Flag ~= nil then
		base = tostring(opts.Flag)
	else
		base = tostring(sec._path) .. "/" .. tostring(opts.Title or opts.Name or kind)
	end
	win._keys[base] = (win._keys[base] or 0) + 1
	if win._keys[base] > 1 then base = base .. "#" .. win._keys[base] end
	return base
end

----------------------------------------------------------------------
-- Notificacoes
----------------------------------------------------------------------
local notifGui, notifHolder

local function ensureNotif()
	if notifGui and notifGui.Parent then return end
	notifGui = new("ScreenGui", {
		Name = rname(), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true, DisplayOrder = 1000,
	})
	protect(notifGui)
	notifGui.Parent = getParent()
	notifHolder = new("Frame", {
		BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -14, 1, -14), Size = UDim2.new(0, 270, 1, -28),
	}, notifGui)
	new("UIListLayout", {
		Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
	}, notifHolder)
end

local notifOrder = 0

function Library.Notify(a, b)
	local o
	if type(b) == "table" then
		o = b
	elseif type(a) == "table" and a ~= Library then
		o = a
	else
		o = {}
	end
	ensureNotif()

	local kids = notifHolder:GetChildren()
	local count = 0
	for _, k in ipairs(kids) do
		if k:IsA("Frame") then count = count + 1 end
	end
	if count >= 6 then
		for _, k in ipairs(kids) do
			if k:IsA("Frame") then k:Destroy() break end
		end
	end

	notifOrder = notifOrder + 1
	local dur = tonumber(o.Duration) or 3
	local toast = new("Frame", {
		BackgroundColor3 = T.card, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = notifOrder, BackgroundTransparency = 1,
	}, notifHolder)
	corner(toast, 10)
	local st = stroke(toast, T.accent, 1, 1)
	padding(toast, 14, 12, 10, 10)
	vlist(toast, 4)
	local tl = label(toast, {
		Text = tostring(o.Title or "Sena"), Font = Enum.Font.GothamBold, TextSize = 13, RichText = false,
		LayoutOrder = 1, TextTransparency = 1,
	})
	local cl = label(toast, {
		Text = tostring(o.Content or ""), TextSize = 12, TextColor3 = T.sub, RichText = false,
		LayoutOrder = 2, TextTransparency = 1,
	})
	cl.Visible = cl.Text ~= ""
	local barBg = new("Frame", {
		BackgroundColor3 = T.card2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 3), LayoutOrder = 3,
		BackgroundTransparency = 1,
	}, toast)
	corner(barBg, 2)
	local bar = new("Frame", {
		BackgroundColor3 = T.accent, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
	}, barBg)
	corner(bar, 2)

	tw(toast, { BackgroundTransparency = 0 }, 0.2)
	tw(st, { Transparency = 0.5 }, 0.2)
	tw(tl, { TextTransparency = 0 }, 0.2)
	tw(cl, { TextTransparency = 0 }, 0.2)
	tw(barBg, { BackgroundTransparency = 0 }, 0.2)
	tw(bar, { BackgroundTransparency = 0 }, 0.2)
	local bt = TweenService:Create(bar, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })
	bt:Play()

	task.delay(dur, function()
		if not toast.Parent then return end
		tw(toast, { BackgroundTransparency = 1 }, 0.25)
		tw(st, { Transparency = 1 }, 0.25)
		tw(tl, { TextTransparency = 1 }, 0.25)
		tw(cl, { TextTransparency = 1 }, 0.25)
		tw(barBg, { BackgroundTransparency = 1 }, 0.25)
		tw(bar, { BackgroundTransparency = 1 }, 0.25)
		task.wait(0.3)
		if toast.Parent then toast:Destroy() end
	end)
end

----------------------------------------------------------------------
-- Card base
----------------------------------------------------------------------
local function baseCard(sec, opts, clickable, rightW, rightH)
	opts = opts or {}
	local card
	if clickable then
		card = new("TextButton", { Text = "", AutoButtonColor = false })
	else
		card = new("Frame")
	end
	card.Name = "Card"
	card.BackgroundColor3 = T.card
	card.BorderSizePixel = 0
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.Size = UDim2.new(1, 0, 0, 0)
	sec._n = sec._n + 1
	card.LayoutOrder = sec._n
	card.Parent = sec._holder
	corner(card, 8)
	stroke(card, T.stroke, 1, 0.35)
	padding(card, 12, 12, 10, 10)
	vlist(card, 8)

	local head = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1,
	}, card)
	new("UISizeConstraint", { MinSize = Vector2.new(0, 22) }, head)

	local reserve = (rightW and rightW > 0) and (rightW + 10) or 0
	local textHolder = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -reserve, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	}, head)
	vlist(textHolder, 2)
	local title = label(textHolder, {
		Text = tostring(opts.Title or opts.Name or ""), Font = Enum.Font.GothamBold, TextSize = 14, LayoutOrder = 1,
	})
	local content = label(textHolder, {
		Text = tostring(opts.Content or opts.Description or ""), TextSize = 12, TextColor3 = T.sub, LayoutOrder = 2,
	})
	title.Visible = title.Text ~= ""
	content.Visible = content.Text ~= ""

	local right
	if reserve > 0 then
		right = new("Frame", {
			BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(rightW, rightH or 22),
		}, head)
	end

	local ui = { card = card, head = head, title = title, content = content, right = right }

	local body
	function ui.getBody()
		if not body then
			body = new("Frame", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2,
			}, card)
			vlist(body, 6)
		end
		return body
	end

	if clickable then
		card.MouseEnter:Connect(function() tw(card, { BackgroundColor3 = T.card2 }, 0.12) end)
		card.MouseLeave:Connect(function() tw(card, { BackgroundColor3 = T.card }, 0.12) end)
	end
	return ui
end

local function attachCommon(el, ui)
	el._ui = ui
	el.Alive = function() return not el._dead and ui.card.Parent ~= nil end
	el.SetTitle = function(_, t)
		t = tostring(t or "")
		if ui.title.Text ~= t then ui.title.Text = t end
		ui.title.Visible = t ~= ""
	end
	el.SetContent = function(_, t)
		t = tostring(t or "")
		if ui.content.Text ~= t then ui.content.Text = t end
		ui.content.Visible = t ~= ""
	end
	el.Lock = function()
		el._locked = true
		ui.title.TextTransparency = 0.5
		ui.content.TextTransparency = 0.5
	end
	el.Unlock = function()
		el._locked = false
		ui.title.TextTransparency = 0
		ui.content.TextTransparency = 0
	end
	el.SetVisible = function(_, v) ui.card.Visible = v ~= false end
	el.Destroy = function()
		el._dead = true
		if ui.card then ui.card:Destroy() end
	end
	el.ResetValue = el.ResetValue or function() end
	return el
end

----------------------------------------------------------------------
-- Barra arrastavel (slider / color picker)
----------------------------------------------------------------------
local function dragBar(sec, parent, color)
	local win = sec._win
	local hit = new("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22),
	}, parent)
	local bar = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 6),
		BackgroundColor3 = T.card2, BorderSizePixel = 0,
	}, hit)
	corner(bar, 3)
	local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = color or T.accent, BorderSizePixel = 0 }, bar)
	corner(fill, 3)
	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2,
	}, bar)
	corner(knob, 7)

	local api = { pct = 0, onChange = nil, hit = hit, fill = fill }
	function api.set(p)
		p = math.clamp(p, 0, 1)
		api.pct = p
		fill.Size = UDim2.new(p, 0, 1, 0)
		knob.Position = UDim2.new(p, 0, 0.5, 0)
	end

	local dragging = false
	local function fromX(x)
		local w = math.max(bar.AbsoluteSize.X, 1)
		local p = math.clamp((x - bar.AbsolutePosition.X) / w, 0, 1)
		api.set(p)
		if api.onChange then api.onChange(p, false) end
	end

	hit.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			pcall(function() sec._page.ScrollingEnabled = false end)
			fromX(i.Position.X)
		end
	end)
	track(win, UIS.InputChanged:Connect(function(i)
		if dragging and isMove(i) then fromX(i.Position.X) end
	end))
	track(win, UIS.InputEnded:Connect(function(i)
		if dragging and isPress(i) then
			dragging = false
			pcall(function() sec._page.ScrollingEnabled = true end)
			if api.onChange then api.onChange(api.pct, true) end
		end
	end))
	return api
end

----------------------------------------------------------------------
-- Elementos
----------------------------------------------------------------------
local function addToggle(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Toggle")
	local ui = baseCard(sec, opts, true, 44, 22)
	local track_ = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = T.card2, BorderSizePixel = 0 }, ui.right)
	corner(track_, 11)
	local tstroke = stroke(track_, T.stroke, 1, 0.2)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 3, 0.5, -8),
		BackgroundColor3 = T.sub, BorderSizePixel = 0,
	}, track_)
	corner(knob, 8)

	local el = { Type = "Toggle" }
	local saved = Config.get(key)
	if type(saved) == "boolean" then el.Value = saved else el.Value = opts.Default == true end

	local function render(anim)
		local on = el.Value
		local props1 = { BackgroundColor3 = on and T.accent or T.card2 }
		local props2 = {
			Position = on and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
			BackgroundColor3 = on and Color3.new(1, 1, 1) or T.sub,
		}
		if anim then
			tw(track_, props1, 0.15)
			tw(knob, props2, 0.15)
		else
			track_.BackgroundColor3 = props1.BackgroundColor3
			knob.Position = props2.Position
			knob.BackgroundColor3 = props2.BackgroundColor3
		end
		tstroke.Transparency = on and 1 or 0.2
	end
	render(false)

	function el.Set(self, v, silent)
		v = (v == true)
		local changed = v ~= el.Value
		el.Value = v
		render(true)
		Config.set(key, v)
		if changed and not silent then fire(opts.Callback, v) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.ResetValue(self) el.Set(self, opts.Default == true) end
	function el.Get() return el.Value end
	el.GetValue = el.Get

	ui.card.Activated:Connect(function()
		if el._locked then return end
		el.Set(el, not el.Value)
	end)
	return attachCommon(el, ui)
end

local function addSlider(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Slider")
	local min = tonumber(opts.Min) or 0
	local max = tonumber(opts.Max) or 100
	if max <= min then max = min + 1 end
	local inc = tonumber(opts.Increment) or 1
	if inc <= 0 then inc = 1 end
	local decimals = 0
	do
		local s = string.format("%.6f", inc):gsub("0+$", "")
		local frac = s:match("%.(%d*)$")
		decimals = frac and #frac or 0
	end
	local function snap(v)
		v = math.clamp(v, min, max)
		v = math.floor((v - min) / inc + 0.5) * inc + min
		v = math.clamp(v, min, max)
		return tonumber(string.format("%.6f", v))
	end
	local function fmt(v)
		if decimals <= 0 then return tostring(math.floor(v + 0.5)) end
		return string.format("%." .. decimals .. "f", v)
	end

	local ui = baseCard(sec, opts, false, 60, 20)
	local valLabel = label(ui.right, {
		AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Center, Font = Enum.Font.GothamBold, TextColor3 = T.accent, TextWrapped = false,
	})
	local body = ui.getBody()
	local bar = dragBar(sec, body, T.accent)

	local el = { Type = "Slider" }
	local saved = Config.get(key)
	local startV = type(saved) == "number" and saved or tonumber(opts.Default) or min
	el.Value = snap(startV)
	local lastCommitted = el.Value

	local function show(v)
		valLabel.Text = fmt(v)
		bar.set((v - min) / (max - min))
	end
	show(el.Value)

	local function commit(v, silent)
		v = snap(v)
		el.Value = v
		show(v)
		Config.set(key, v)
		if v ~= lastCommitted then
			lastCommitted = v
			if not silent then fire(opts.Callback, v) end
		end
	end

	bar.onChange = function(p, final)
		if el._locked then return end
		local v = snap(min + p * (max - min))
		valLabel.Text = fmt(v)
		if final then commit(v, false) end
	end

	function el.Set(self, v, silent) commit(tonumber(v) or el.Value, silent) end
	el.SetValue = el.Set
	function el.LoadValue(self, v) commit(tonumber(v) or el.Value, true) end
	function el.ResetValue(self) commit(tonumber(opts.Default) or min, false) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, ui)
end

local function addDropdown(sec, opts)
	opts = opts or {}
	local multi = opts.Multi == true
	local maxVisible = math.max(1, tonumber(opts.MaxVisible) or 5)
	local key = makeKey(sec, opts, "Dropdown")

	local options = {}
	local function setList(list)
		options = {}
		if type(list) == "table" then
			for _, v in ipairs(list) do options[#options + 1] = tostring(v) end
		end
	end
	setList(opts.Options)

	local ui = baseCard(sec, opts, false, 0)
	local body = ui.getBody()
	local header = new("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundColor3 = T.card2, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 1,
	}, body)
	corner(header, 6)
	stroke(header, T.stroke, 1, 0.4)
	local valueLabel = label(header, {
		AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(1, -34, 1, 0), Position = UDim2.new(0, 10, 0, 0),
		TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local arrow = label(header, {
		AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.fromOffset(24, 32), AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -4, 0, 0), Text = "▾", TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = T.sub, TextSize = 14,
	})

	local panel = new("Frame", {
		BackgroundColor3 = T.card2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Visible = false,
		LayoutOrder = 2, ClipsDescendants = true,
	}, body)
	corner(panel, 6)
	stroke(panel, T.stroke, 1, 0.4)

	local searchH = 0
	local sbFrame = new("Frame", {
		BackgroundColor3 = T.card, BorderSizePixel = 0, Position = UDim2.new(0, 4, 0, 4), Size = UDim2.new(1, -8, 0, 24),
		Visible = false,
	}, panel)
	corner(sbFrame, 5)
	local searchBox = new("TextBox", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 8, 0, 0),
		Text = "", PlaceholderText = "Search...", PlaceholderColor3 = T.sub, TextColor3 = T.text,
		Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	}, sbFrame)

	local list = new("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 4),
		Size = UDim2.new(1, 0, 1, -8), CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, panel)
	padding(list, 4, 4, 0, 0)
	vlist(list, 2)

	-- selecao
	local selected = {}
	local current
	local el = { Type = "Dropdown" }

	local function isSel(o)
		for _, s in ipairs(selected) do
			if s == o then return true end
		end
		return false
	end

	local function computeValue()
		if multi then
			local out = {}
			for _, s in ipairs(selected) do out[#out + 1] = s end
			return out
		end
		return current
	end

	local function refreshText()
		local txt, dim
		if multi then
			local n = #selected
			if n == 0 then
				txt, dim = "None", true
			elseif n <= 2 then
				txt = table.concat(selected, ", ")
			else
				txt = selected[1] .. ", " .. selected[2] .. " +" .. (n - 2)
			end
		else
			txt = current or "Select..."
			dim = current == nil
		end
		valueLabel.Text = esc(txt)
		valueLabel.TextColor3 = dim and T.sub or T.text
	end

	local function normalize(v)
		if multi then
			local out = {}
			if type(v) == "table" then
				for _, x in ipairs(v) do out[#out + 1] = tostring(x) end
			elseif v ~= nil and v ~= "" then
				out[1] = tostring(v)
			end
			return out
		end
		if type(v) == "table" then v = v[1] end
		if v == nil then return nil end
		return tostring(v)
	end

	local function applyValue(v)
		if multi then selected = normalize(v) else current = normalize(v) end
	end

	-- inicial: salvo > default
	local saved = Config.get(key)
	if saved ~= nil and ((multi and type(saved) == "table") or (not multi and type(saved) == "string")) then
		applyValue(saved)
	else
		applyValue(opts.Default)
	end
	if not multi and current == nil and opts.Default == nil then current = nil end
	el.Value = computeValue()

	local open = false
	local itemButtons = {}

	local function visibleCount()
		local q = searchBox.Text:lower()
		local n = 0
		for _, o in ipairs(options) do
			if q == "" or o:lower():find(q, 1, true) then n = n + 1 end
		end
		return n
	end

	local function resizePanel()
		searchH = (#options > 7) and 30 or 0
		sbFrame.Visible = searchH > 0
		list.Position = UDim2.new(0, 0, 0, searchH + 4)
		list.Size = UDim2.new(1, 0, 1, -(searchH + 8))
		local n = math.max(1, math.min(visibleCount(), maxVisible))
		panel.Size = UDim2.new(1, 0, 0, searchH + 8 + n * 28 + (n - 1) * 2)
	end

	local function paintItem(b, o)
		local on = multi and isSel(o) or (not multi and current == o)
		b.TextColor3 = on and T.accent or T.text
		b.BackgroundTransparency = on and 0.85 or 1
		local chk = b:FindFirstChild("Chk")
		if chk then chk.Visible = on end
	end

	local function commit(silent)
		local v = computeValue()
		el.Value = v
		refreshText()
		Config.set(key, v)
		if not silent then
			if multi then
				local copy = {}
				for _, x in ipairs(v) do copy[#copy + 1] = x end
				fire(opts.Callback, copy)
			else
				fire(opts.Callback, v)
			end
		end
	end

	local function rebuild()
		for _, b in ipairs(itemButtons) do b:Destroy() end
		itemButtons = {}
		local q = searchBox.Text:lower()
		local order = 0
		for _, o in ipairs(options) do
			if q == "" or o:lower():find(q, 1, true) then
				order = order + 1
				local b = new("TextButton", {
					Text = esc(o), RichText = true, AutoButtonColor = false, BackgroundColor3 = T.accent, BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 28), LayoutOrder = order, Font = Enum.Font.GothamMedium, TextSize = 12,
					TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
				}, list)
				b:SetAttribute("opt", o)
				padding(b, 8, 24, 0, 0)
				corner(b, 5)
				new("TextLabel", {
					Name = "Chk", BackgroundTransparency = 1, Text = "✓", TextColor3 = T.accent, Font = Enum.Font.GothamBold,
					TextSize = 13, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 20, 0.5, 0),
					Size = UDim2.fromOffset(16, 16), Visible = false,
				}, b)
				paintItem(b, o)
				b.Activated:Connect(function()
					if el._locked then return end
					if multi then
						if isSel(o) then
							for i, s in ipairs(selected) do
								if s == o then table.remove(selected, i) break end
							end
						else
							selected[#selected + 1] = o
						end
						paintItem(b, o)
						commit(false)
					else
						current = o
						for _, ob in ipairs(itemButtons) do paintItem(ob, ob:GetAttribute("opt")) end
						commit(false)
						open = false
						panel.Visible = false
						arrow.Text = "▾"
					end
				end)
				itemButtons[#itemButtons + 1] = b
			end
		end
		resizePanel()
	end

	local function setOpen(v)
		open = v
		panel.Visible = v
		arrow.Text = v and "▴" or "▾"
		if v then rebuild() end
	end

	header.Activated:Connect(function()
		if el._locked then return end
		setOpen(not open)
	end)
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if open then rebuild() end
	end)

	refreshText()

	function el.Set(self, v, silent)
		applyValue(v)
		commit(silent)
		if open then rebuild() end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.ResetValue(self) el.Set(self, opts.Default, false) end
	function el.Get() return el.Value end
	el.GetValue = el.Get

	function el.Refresh(self, newList, newSelection)
		setList(newList)
		if newSelection ~= nil then
			applyValue(newSelection)
		elseif #options > 0 then
			if multi then
				local keep = {}
				for _, s in ipairs(selected) do
					for _, o in ipairs(options) do
						if o == s then keep[#keep + 1] = s break end
					end
				end
				selected = keep
			elseif current ~= nil then
				local found = false
				for _, o in ipairs(options) do
					if o == current then found = true break end
				end
				if not found then current = nil end
			end
		end
		commit(true)
		if open then rebuild() end
	end
	el.SetOptions = el.Refresh
	function el.Clear(self)
		if multi then selected = {} else current = nil end
		commit(false)
		if open then rebuild() end
	end
	return attachCommon(el, ui)
end

local function addInput(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Input")
	local ui = baseCard(sec, opts, false, 0)
	local body = ui.getBody()
	local box = new("Frame", { BackgroundColor3 = T.card2, Size = UDim2.new(1, 0, 0, 32), BorderSizePixel = 0 }, body)
	corner(box, 6)
	local bs = stroke(box, T.stroke, 1, 0.4)
	local tb = new("TextBox", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
		Text = "", PlaceholderText = tostring(opts.Placeholder or ""), PlaceholderColor3 = T.sub, TextColor3 = T.text,
		Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false, TextTruncate = Enum.TextTruncate.AtEnd,
	}, box)

	local el = { Type = "Input" }
	local saved = Config.get(key)
	local start = type(saved) == "string" and saved or tostring(opts.Default or "")
	tb.Text = start
	el.Value = start
	local last = start

	tb.Focused:Connect(function() tw(bs, { Color = T.accent, Transparency = 0 }, 0.12) end)
	tb.FocusLost:Connect(function(enter)
		tw(bs, { Color = T.stroke, Transparency = 0.4 }, 0.12)
		if el._locked then tb.Text = el.Value return end
		local t = tb.Text
		el.Value = t
		Config.set(key, t)
		if enter or t ~= last then
			last = t
			fire(opts.Callback, t)
		end
	end)

	function el.Set(self, v, silent)
		v = tostring(v == nil and "" or v)
		tb.Text = v
		el.Value = v
		last = v
		Config.set(key, v)
		if not silent then fire(opts.Callback, v) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.ResetValue(self) el.Set(self, opts.Default or "", false) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, ui)
end

local function addButton(sec, opts)
	opts = opts or {}
	local dual = opts.SubTitle ~= nil
	local el = { Type = "Button" }

	if not dual then
		local ui = baseCard(sec, opts, true, 18, 18)
		label(ui.right, {
			AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(1, 0, 1, 0), Text = "›", TextSize = 22,
			TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = T.accent,
			Font = Enum.Font.GothamBold,
		})
		ui.card.Activated:Connect(function()
			if el._locked then return end
			tw(ui.card, { BackgroundColor3 = T.accent }, 0.08)
			task.delay(0.12, function() tw(ui.card, { BackgroundColor3 = T.card }, 0.2) end)
			fire(opts.Callback)
		end)
		function el.Fire() fire(opts.Callback) end
		return attachCommon(el, ui)
	end

	local ui = baseCard(sec, { Content = opts.Content }, false, 0)
	local body = ui.getBody()
	local row = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 1 }, body)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
	}, row)
	local function mk(text, primary, cb, order)
		local b = new("TextButton", {
			Text = esc(text), RichText = true, AutoButtonColor = false, Size = UDim2.new(0.5, -4, 1, 0), LayoutOrder = order,
			BackgroundColor3 = primary and T.accent or T.card2, TextColor3 = primary and Color3.new(1, 1, 1) or T.text,
			Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
		}, row)
		corner(b, 6)
		b.Activated:Connect(function()
			if el._locked then return end
			fire(cb)
		end)
		return b
	end
	local b1 = mk(tostring(opts.Title or "Run"), true, opts.Callback, 1)
	local b2 = mk(tostring(opts.SubTitle), false, opts.SubCallback, 2)
	el.SetTitle = function(_, t) b1.Text = esc(t) end
	el.SetSubTitle = function(_, t) b2.Text = esc(t) end
	attachCommon(el, ui)
	el.SetTitle = function(_, t) b1.Text = esc(t) end
	return el
end

local function addParagraph(sec, opts)
	opts = opts or {}
	local ui = baseCard(sec, opts, false, 0)
	local el = { Type = "Paragraph" }
	return attachCommon(el, ui)
end

local function addSubSection(sec, name)
	local ui = {}
	local wrap = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	}, sec._holder)
	sec._n = sec._n + 1
	wrap.LayoutOrder = sec._n
	padding(wrap, 2, 0, 4, 0)
	vlist(wrap, 3)
	local lbl = label(wrap, {
		Text = tostring(type(name) == "table" and (name.Title or name.Name) or name or ""), Font = Enum.Font.GothamBold,
		TextSize = 11, TextColor3 = T.accent, LayoutOrder = 1,
	})
	local line = new("Frame", { BackgroundColor3 = T.stroke, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2 }, wrap)
	ui.card = wrap
	local el = { Type = "SubSection" }
	el.Alive = function() return not el._dead and wrap.Parent ~= nil end
	el.SetTitle = function(_, t) lbl.Text = tostring(t) end
	el.SetVisible = function(_, v) wrap.Visible = v ~= false end
	el.Destroy = function() el._dead = true wrap:Destroy() end
	return el
end

local function addKeybind(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Keybind")
	local win = sec._win
	local ui = baseCard(sec, opts, false, 92, 26)
	local btn = new("TextButton", {
		Text = "None", AutoButtonColor = false, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = T.card2,
		Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = T.text, BorderSizePixel = 0,
	}, ui.right)
	corner(btn, 6)
	stroke(btn, T.stroke, 1, 0.4)

	local el = { Type = "Keybind" }
	local saved = Config.get(key)
	local d = opts.Default
	if typeof(d) == "EnumItem" then d = d.Name end
	local name = type(saved) == "string" and saved or (type(d) == "string" and d or "None")
	local listening = false
	el.Value = name
	btn.Text = name

	local function setKey(n, silent)
		el.Value = n
		btn.Text = n
		Config.set(key, n)
		if not silent then fire(opts.ChangedCallback, n) end
	end

	btn.Activated:Connect(function()
		if el._locked then return end
		listening = true
		btn.Text = "..."
		btn.TextColor3 = T.accent
	end)
	track(win, UIS.InputBegan:Connect(function(i, gp)
		if listening then
			if i.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				btn.TextColor3 = T.text
				if i.KeyCode == Enum.KeyCode.Escape then
					btn.Text = el.Value
				elseif i.KeyCode == Enum.KeyCode.Backspace then
					setKey("None")
				else
					setKey(i.KeyCode.Name)
				end
			end
			return
		end
		if gp or el.Value == "None" then return end
		if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode.Name == el.Value then
			fire(opts.Callback, i.KeyCode)
		end
	end))

	function el.Set(self, v, silent)
		if typeof(v) == "EnumItem" then v = v.Name end
		setKey(tostring(v or "None"), silent)
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, ui)
end

local function addColorPicker(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "ColorPicker")
	local ui = baseCard(sec, opts, false, 38, 22)
	local swatch = new("TextButton", {
		Text = "", AutoButtonColor = false, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
	}, ui.right)
	corner(swatch, 6)
	stroke(swatch, T.stroke, 1, 0.2)

	local el = { Type = "ColorPicker" }
	local start = typeof(opts.Default) == "Color3" and opts.Default or Color3.fromRGB(139, 124, 255)
	local saved = Config.get(key)
	if type(saved) == "table" and tonumber(saved[1]) then
		start = Color3.fromRGB(saved[1], saved[2], saved[3])
	end
	local h, s, v = Color3.toHSV(start)
	el.Value = start
	swatch.BackgroundColor3 = start

	local body = ui.getBody()
	local panel = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false,
	}, body)
	vlist(panel, 2)
	local function setColor(final)
		local c = Color3.fromHSV(h, s, v)
		el.Value = c
		swatch.BackgroundColor3 = c
		if final then
			Config.set(key, { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) })
			fire(opts.Callback, c)
		end
	end
	local bh = dragBar(sec, panel, Color3.fromRGB(255, 120, 120))
	local bs = dragBar(sec, panel, Color3.fromRGB(200, 200, 220))
	local bv = dragBar(sec, panel, Color3.fromRGB(160, 160, 170))
	bh.set(h) bs.set(s) bv.set(v)
	bh.onChange = function(p, f) h = p setColor(f) end
	bs.onChange = function(p, f) s = p setColor(f) end
	bv.onChange = function(p, f) v = p setColor(f) end
	swatch.Activated:Connect(function()
		if el._locked then return end
		panel.Visible = not panel.Visible
	end)

	function el.Set(self, c, silent)
		if typeof(c) ~= "Color3" then return end
		h, s, v = Color3.toHSV(c)
		bh.set(h) bs.set(s) bv.set(v)
		el.Value = c
		swatch.BackgroundColor3 = c
		Config.set(key, { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) })
		if not silent then fire(opts.Callback, c) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, c) el.Set(self, c, true) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, ui)
end

----------------------------------------------------------------------
-- ActionList
----------------------------------------------------------------------
local function btnColors(c)
	c = tostring(c or "accent"):lower()
	if c == "green" then return Color3.fromRGB(34, 160, 90), Color3.new(1, 1, 1) end
	if c == "red" then return Color3.fromRGB(200, 56, 56), Color3.new(1, 1, 1) end
	if c == "dim" then return Color3.fromRGB(52, 52, 66), T.sub end
	return T.accent, Color3.new(1, 1, 1)
end

local function addActionList(sec, opts)
	opts = opts or {}
	local rowH = 48
	local visibleRows = math.max(1, tonumber(opts.VisibleRows) or 5)
	local btnW = tonumber(opts.ButtonWidth) or 72
	local ui = baseCard(sec, { Title = opts.Title, Content = opts.Content }, false, 0)
	local body = ui.getBody()
	local listFrame = new("ScrollingFrame", {
		BackgroundColor3 = T.card2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 40), CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent,
		ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = 1,
	}, body)
	corner(listFrame, 8)
	padding(listFrame, 6, 6, 6, 6)
	vlist(listFrame, 4)
	local emptyLabel = label(listFrame, {
		Text = tostring(opts.EmptyText or "Nothing here."), TextColor3 = T.sub, TextSize = 12, AutomaticSize = Enum.AutomaticSize.None,
		Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
		LayoutOrder = -1,
	})

	local records = {}
	local el = { Type = "ActionList" }

	local function buildRow(id)
		local rec = { id = id }
		local f = new("Frame", { BackgroundColor3 = T.card, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, rowH) }, listFrame)
		corner(f, 6)
		rec.frame = f
		rec.name = label(f, {
			AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(0.38, -10, 0, 18), Position = UDim2.new(0, 10, 0, 7),
			Font = Enum.Font.GothamBold, TextSize = 13, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		rec.sub = label(f, {
			AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(0.38, -10, 0, 16), Position = UDim2.new(0, 10, 0, 26),
			TextSize = 11, TextColor3 = T.sub, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		rec.status = label(f, {
			AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(0.62, -14, 0, 18), Position = UDim2.new(0.4, 0, 0, 7),
			TextSize = 12, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		rec.statusSub = label(f, {
			AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(0.62, -14, 0, 16), Position = UDim2.new(0.4, 0, 0, 26),
			TextSize = 11, TextColor3 = T.sub, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		rec.btn = new("TextButton", {
			AutoButtonColor = false, Size = UDim2.fromOffset(btnW, 28), AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0), Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
			Text = "", Visible = false,
		}, f)
		corner(rec.btn, 6)
		local function setter(text, color)
			if not rec.btn.Parent then return end
			rec.btn.Text = esc(tostring(text))
			local bg, fg = btnColors(color)
			rec.btn.BackgroundColor3 = bg
			rec.btn.TextColor3 = fg
			if rec.row and tostring(text) == tostring(rec.row.button) then
				rec.override = nil
			else
				rec.override = os.clock() + 2.5
			end
		end
		rec.btn.Activated:Connect(function()
			local row = rec.row
			if row and type(row.onClick) == "function" then fire(row.onClick, row, setter) end
		end)
		return rec
	end

	local function setText(lbl, txt)
		txt = tostring(txt == nil and "" or txt)
		if lbl.Text ~= txt then lbl.Text = txt end
	end

	local function applyRow(rec, row)
		setText(rec.name, esc(row.name or ""))
		setText(rec.sub, row.sub or "")
		setText(rec.status, row.status or "")
		setText(rec.statusSub, row.statusSub or "")
		local hasBtn = type(row.button) == "string" and row.button ~= ""
		rec.btn.Visible = hasBtn
		local w = hasBtn and (btnW + 14) or 10
		rec.status.Size = UDim2.new(0.62, -w, 0, 18)
		rec.statusSub.Size = UDim2.new(0.62, -w, 0, 16)
		if hasBtn and not (rec.override and os.clock() < rec.override) then
			rec.override = nil
			local bg, fg = btnColors(row.buttonColor)
			local txt = esc(row.button)
			if rec.btn.Text ~= txt then rec.btn.Text = txt end
			rec.btn.BackgroundColor3 = bg
			rec.btn.TextColor3 = fg
		end
	end

	function el.Update(self, rows)
		if el._dead then return end
		rows = type(rows) == "table" and rows or {}
		local seen = {}
		for i, row in ipairs(rows) do
			local id = tostring(row.id or i)
			seen[id] = true
			local rec = records[id]
			if not rec then
				rec = buildRow(id)
				records[id] = rec
			end
			rec.row = row
			rec.frame.LayoutOrder = i
			applyRow(rec, row)
		end
		for id, rec in pairs(records) do
			if not seen[id] then
				rec.frame:Destroy()
				records[id] = nil
			end
		end
		emptyLabel.Visible = #rows == 0
		local n = math.min(#rows, visibleRows)
		local h = (#rows == 0) and 40 or (n * rowH + (n - 1) * 4 + 12)
		listFrame.Size = UDim2.new(1, 0, 0, h)
	end
	el.Set = el.Update
	el.SetValue = el.Update
	function el.Clear(self) el.Update(el, {}) end
	return attachCommon(el, ui)
end

----------------------------------------------------------------------
-- LiveChat
----------------------------------------------------------------------
local function addLiveChat(sec, opts)
	opts = opts or {}
	local ui = baseCard(sec, { Title = opts.Title or "Live Chat", Content = opts.Content }, false, 0)
	local body = ui.getBody()
	local msgs = new("ScrollingFrame", {
		BackgroundColor3 = T.card2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, tonumber(opts.Height) or 260),
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
		ScrollBarImageColor3 = T.accent, ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = 1,
	}, body)
	corner(msgs, 8)
	padding(msgs, 8, 8, 8, 8)
	vlist(msgs, 4)

	local row = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 2 }, body)
	local boxFrame = new("Frame", { BackgroundColor3 = T.card2, BorderSizePixel = 0, Size = UDim2.new(1, -74, 1, 0) }, row)
	corner(boxFrame, 6)
	local bs = stroke(boxFrame, T.stroke, 1, 0.4)
	local box = new("TextBox", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), Text = "",
		PlaceholderText = "Type a message...", PlaceholderColor3 = T.sub, TextColor3 = T.text, Font = Enum.Font.GothamMedium,
		TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
	}, boxFrame)
	local send = new("TextButton", {
		Text = "Send", AutoButtonColor = false, BackgroundColor3 = T.accent, TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(0, 66, 1, 0), AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0,
	}, row)
	corner(send, 6)

	local el = { Type = "LiveChat" }
	local count = 0
	local localName = Players.LocalPlayer and (Players.LocalPlayer.DisplayName or Players.LocalPlayer.Name) or "You"

	function el.AddMessage(self, user, text, color)
		count = count + 1
		local c = typeof(color) == "Color3" and color or T.accent
		local l = label(msgs, {
			Text = string.format('<font color="%s"><b>%s</b></font>  %s', hex(c), esc(user or "?"), esc(text or "")),
			TextSize = 12, LayoutOrder = count,
		})
		if count > 120 then
			local kids = msgs:GetChildren()
			for _, k in ipairs(kids) do
				if k:IsA("TextLabel") then k:Destroy() break end
			end
		end
		task.defer(function()
			if msgs.Parent then msgs.CanvasPosition = Vector2.new(0, 1e6) end
		end)
		return l
	end
	function el.Clear(self)
		for _, k in ipairs(msgs:GetChildren()) do
			if k:IsA("TextLabel") then k:Destroy() end
		end
		count = 0
	end

	local function doSend()
		local text = box.Text
		text = text:gsub("^%s+", "")
		text = text:gsub("%s+$", "")
		if text == "" then return end
		box.Text = ""
		local handler = opts.Callback or Library.ChatHandler
		if type(handler) == "function" then
			fire(handler, text)
		else
			el.AddMessage(el, localName, text, T.accent)
		end
	end
	send.Activated:Connect(doSend)
	box.FocusLost:Connect(function(enter)
		tw(bs, { Color = T.stroke, Transparency = 0.4 }, 0.12)
		if enter then doSend() end
	end)
	box.Focused:Connect(function() tw(bs, { Color = T.accent, Transparency = 0 }, 0.12) end)

	Library.LiveChat = el
	return attachCommon(el, ui)
end

----------------------------------------------------------------------
-- SupportCard
----------------------------------------------------------------------
local function addSupportCard(sec, opts)
	opts = opts or {}
	local ui = baseCard(sec, {
		Title = opts.Title or "Support Sena",
		Content = opts.Content or "Thanks for using Sena! Your support keeps the hub updated and free of bugs.",
	}, false, 0)
	new("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(34, 28, 66), T.card), Rotation = 20,
	}, ui.card)
	local links = opts.Links or Library.SupportLinks or {}
	if #links > 0 then
		local body = ui.getBody()
		for i, ln in ipairs(links) do
			local b = new("TextButton", {
				Text = esc("Copy " .. tostring(ln.Name or ln.Title or "Link")), RichText = true, AutoButtonColor = false,
				BackgroundColor3 = T.accent, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 12,
				Size = UDim2.new(1, 0, 0, 32), LayoutOrder = i, BorderSizePixel = 0,
			}, body)
			corner(b, 6)
			b.Activated:Connect(function()
				local url = tostring(ln.Url or ln.Link or "")
				local ok = false
				if setclipboard then ok = pcall(setclipboard, url) end
				Library.Notify(Library, {
					Title = tostring(ln.Name or "Link"), Content = ok and "Link copied to clipboard" or url, Duration = 3,
				})
			end)
		end
	end
	local el = { Type = "SupportCard" }
	return attachCommon(el, ui)
end

----------------------------------------------------------------------
-- Section
----------------------------------------------------------------------
local ADDERS = {
	AddToggle = addToggle, AddSlider = addSlider, AddDropdown = addDropdown, AddInput = addInput,
	AddButton = addButton, AddParagraph = addParagraph, AddSubSection = addSubSection, AddKeybind = addKeybind,
	AddColorPicker = addColorPicker, AddActionList = addActionList, AddLiveChat = addLiveChat,
	AddSupportCard = addSupportCard,
}

local function buildSection(win, tab, name)
	tab._n = tab._n + 1
	local page = tab._page
	local wrap = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = tab._n,
	}, page)
	vlist(wrap, 8)

	local sec = {
		Name = name, _win = win, _tab = tab, _page = page, _n = 0,
		_path = tostring(tab.Name) .. "/" .. tostring(name or "General"),
	}
	local header
	if name and tostring(name) ~= "" then
		header = new("TextButton", {
			Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), LayoutOrder = 1,
		}, wrap)
		local bar = new("Frame", {
			BackgroundColor3 = T.accent, BorderSizePixel = 0, Size = UDim2.fromOffset(3, 14), Position = UDim2.new(0, 0, 0.5, -7),
		}, header)
		corner(bar, 2)
		local nl = label(header, {
			Text = tostring(name), Font = Enum.Font.GothamBold, TextSize = 13, AutomaticSize = Enum.AutomaticSize.None,
			Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 11, 0, 0), TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = false,
		})
		local arrow = label(header, {
			Text = "▾", AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.fromOffset(24, 22), AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0), TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = T.sub, TextSize = 14,
		})
		sec._header = header
		sec._nameLabel = nl
		sec._arrow = arrow
	end

	local holder = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2,
	}, wrap)
	vlist(holder, 6)
	sec._holder = holder
	sec._wrap = wrap

	if header then
		header.Activated:Connect(function()
			holder.Visible = not holder.Visible
			sec._arrow.Text = holder.Visible and "▾" or "▸"
		end)
	end

	for nm, fn in pairs(ADDERS) do
		sec[nm] = function(_, o) return fn(sec, o) end
	end
	sec.AddSection = function(_, n, f) return tab:AddSection(n, f) end
	sec.SetTitle = function(_, t)
		if sec._nameLabel then sec._nameLabel.Text = tostring(t) end
	end
	sec.SetVisible = function(_, v) wrap.Visible = v ~= false end
	sec.Destroy = function() wrap:Destroy() end
	sec.Alive = function() return wrap.Parent ~= nil end
	return sec
end

----------------------------------------------------------------------
-- Window
----------------------------------------------------------------------
local BASE_W, BASE_H = 600, 380

local function makeDrag(win, handle, target, onTap)
	local dragging, startPos, startIn, moved = false, nil, nil, false
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			moved = false
			startIn = i.Position
			startPos = target.Position
			local c
			c = i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
					if c then c:Disconnect() end
					if not moved and onTap then onTap() end
				end
			end)
		end
	end)
	track(win, UIS.InputChanged:Connect(function(i)
		if dragging and isMove(i) then
			local d = i.Position - startIn
			if d.Magnitude > 6 then moved = true end
			if moved then
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end))
end

local function resolveImage(url)
	if type(url) ~= "string" or url == "" then return nil end
	if url:find("^rbxasset") then return url end
	if not (url:find("^https?://") and writefile and getcustomasset and game.HttpGet) then return nil end
	local ok, res = pcall(function()
		local data = game:HttpGet(url)
		local ext = url:match("%.(%a%a%a%a?)$") or "png"
		local fname = "SenaLib_bg." .. ext
		writefile(fname, data)
		return getcustomasset(fname)
	end)
	if ok then return res end
	return nil
end

function Library.Window(self, opts)
	if self ~= Library and opts == nil then opts = self end
	opts = type(opts) == "table" and opts or {}

	for _, w in ipairs(Library.Windows) do pcall(w.Destroy, w) end
	Library.Windows = {}

	Config.setup(opts.Folder)
	local textColor = typeof(opts.Color) == "Color3" and opts.Color or T.text
	if typeof(opts.Accent) == "Color3" then T.accent = opts.Accent end

	local win = { Tabs = {}, Options = opts, _keys = {}, _conns = {}, _tabsList = {}, _dead = false }

	local gui = new("ScreenGui", {
		Name = rname(), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 999,
	})
	protect(gui)
	gui.Parent = getParent()
	win.Gui = gui

	local root = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5),
	}, gui)
	local main = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0, 0), Size = UDim2.fromOffset(BASE_W, BASE_H),
		BackgroundColor3 = T.bg, BorderSizePixel = 0, ClipsDescendants = true,
	}, root)
	corner(main, 12)
	stroke(main, T.stroke, 1, 0)
	local scale = new("UIScale", { Scale = 1 }, main)
	local function calcScale()
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
		scale.Scale = math.clamp(math.min((vp.X - 24) / BASE_W, (vp.Y - 24) / BASE_H, 1.15), 0.4, 1.15)
	end
	calcScale()
	if workspace.CurrentCamera then
		track(win, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(calcScale))
	end

	-- imagem de fundo (opcional)
	local bg = new("ImageLabel", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ImageTransparency = 0.9, ScaleType = Enum.ScaleType.Crop,
		Image = "", ZIndex = 0,
	}, main)
	corner(bg, 12)
	if opts.Image then
		task.spawn(function()
			local a = resolveImage(opts.Image)
			if a and bg.Parent then bg.Image = a end
		end)
	end

	-- topbar
	local topbar = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44) }, main)
	new("Frame", {
		BackgroundColor3 = T.stroke, BackgroundTransparency = 0.3, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
	}, topbar)
	local logo = new("TextLabel", {
		BackgroundColor3 = T.accent, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(0, 12, 0.5, -13),
		Text = tostring(opts.Title or "S"):sub(1, 1):upper(), Font = Enum.Font.GothamBold, TextSize = 14,
		TextColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
	}, topbar)
	corner(logo, 8)
	new("UIGradient", { Color = ColorSequence.new(T.accent, Color3.fromRGB(96, 165, 250)), Rotation = 45 }, logo)
	local titleWrap = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 46, 0, 0),
	}, topbar)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
	}, titleWrap)
	label(titleWrap, {
		Text = tostring(opts.Title or "Sena"), Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = textColor,
		AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 20), TextWrapped = false, LayoutOrder = 1,
		TextYAlignment = Enum.TextYAlignment.Center, RichText = false,
	})
	if opts.Footer then
		label(titleWrap, {
			Text = tostring(opts.Footer), TextSize = 12, TextColor3 = T.sub, AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, 20), TextWrapped = false, LayoutOrder = 2, TextYAlignment = Enum.TextYAlignment.Center,
			RichText = false,
		})
	end

	local function topButton(text, xOff)
		local b = new("TextButton", {
			Text = text, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = T.sub, BackgroundColor3 = T.card,
			AutoButtonColor = false, Size = UDim2.fromOffset(28, 28), AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, xOff, 0.5, 0), BorderSizePixel = 0,
		}, topbar)
		corner(b, 7)
		b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = T.card2 }, 0.1) end)
		b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = T.card }, 0.1) end)
		return b
	end
	local closeBtn = topButton("✕", -10)
	local minBtn = topButton("—", -44)

	makeDrag(win, topbar, root)

	-- corpo
	local bodyF = new("Frame", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 44), Size = UDim2.new(1, 0, 1, -44),
	}, main)
	local side = new("Frame", { BackgroundColor3 = T.side, BackgroundTransparency = 0.35, BorderSizePixel = 0, Size = UDim2.new(0, 150, 1, 0) }, bodyF)
	new("Frame", {
		BackgroundColor3 = T.stroke, BackgroundTransparency = 0.3, BorderSizePixel = 0, Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
	}, side)
	local tabList = new("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y,
	}, side)
	padding(tabList, 8, 8, 8, 8)
	vlist(tabList, 4)
	local pages = new("Frame", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 150, 0, 0), Size = UDim2.new(1, -150, 1, 0), ClipsDescendants = true,
	}, bodyF)

	-- botao flutuante
	local fab = new("TextButton", {
		Text = tostring(opts.Title or "S"):sub(1, 1):upper(), Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.new(1, 1, 1),
		BackgroundColor3 = T.accent, AutoButtonColor = false, Size = UDim2.fromOffset(42, 42), Position = UDim2.new(0, 14, 0, 74),
		BorderSizePixel = 0, ZIndex = 5,
	}, gui)
	corner(fab, 21)
	stroke(fab, Color3.new(1, 1, 1), 1, 0.7)
	local function setVisible(v)
		main.Visible = v and true or false
	end
	makeDrag(win, fab, fab, function() setVisible(not main.Visible) end)
	minBtn.Activated:Connect(function() setVisible(false) end)

	local confirmUntil = 0
	closeBtn.Activated:Connect(function()
		if os.clock() < confirmUntil then
			win.Destroy(win)
		else
			confirmUntil = os.clock() + 2
			closeBtn.Text = "?"
			closeBtn.TextColor3 = T.bad
			Library.Notify(Library, { Title = "Close UI", Content = "Press again to close the UI.", Duration = 2 })
			task.delay(2, function()
				if closeBtn.Parent then
					closeBtn.Text = "✕"
					closeBtn.TextColor3 = T.sub
				end
			end)
		end
	end)

	local toggleKey = opts.ToggleKey
	if typeof(toggleKey) ~= "EnumItem" then toggleKey = Enum.KeyCode.RightShift end
	track(win, UIS.InputBegan:Connect(function(i, gp)
		if not gp and i.KeyCode == toggleKey then setVisible(not main.Visible) end
	end))

	----------------------------------------------------------------
	-- Tabs
	----------------------------------------------------------------
	local function selectTab(t)
		for _, x in ipairs(win._tabsList) do x._setActive(x == t) end
		win.ActiveTab = t
	end

	function win.AddTab(_, o)
		o = o or {}
		local name = tostring(o.Name or o.Title or "Tab")
		local btn = new("TextButton", {
			Text = "", AutoButtonColor = false, BackgroundColor3 = T.card, BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 36), LayoutOrder = #win._tabsList + 1, BorderSizePixel = 0,
		}, tabList)
		corner(btn, 8)
		local bar = new("Frame", {
			BackgroundColor3 = T.accent, BorderSizePixel = 0, Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 0, 0.5, -8),
			Visible = false,
		}, btn)
		corner(bar, 2)

		local iconName = tostring(o.Icon or "")
		if iconName:find("^rbxassetid") then
			new("ImageLabel", {
				BackgroundTransparency = 1, Image = iconName, Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 14, 0.5, -9),
				ImageColor3 = T.sub,
			}, btn)
		else
			new("TextLabel", {
				BackgroundTransparency = 1, Text = Icons[iconName:lower()] or "•", TextSize = 15, Font = Enum.Font.GothamMedium,
				TextColor3 = T.text, Size = UDim2.fromOffset(22, 36), Position = UDim2.new(0, 12, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
			}, btn)
		end
		local nameL = label(btn, {
			Text = name, TextSize = 13, TextColor3 = T.sub, AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.new(1, -44, 1, 0),
			Position = UDim2.new(0, 40, 0, 0), TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd, RichText = false,
		})

		local page = new("ScrollingFrame", {
			BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent,
			ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false,
		}, pages)
		padding(page, 12, 12, 12, 12)
		vlist(page, 12)

		local tab = { Name = name, _win = win, _page = page, _n = 0 }
		tab._setActive = function(on)
			page.Visible = on
			bar.Visible = on
			btn.BackgroundTransparency = on and 0.1 or 1
			nameL.TextColor3 = on and textColor or T.sub
			nameL.Font = on and Enum.Font.GothamBold or Enum.Font.GothamMedium
		end
		btn.Activated:Connect(function() selectTab(tab) end)
		btn.MouseEnter:Connect(function()
			if win.ActiveTab ~= tab then tw(btn, { BackgroundTransparency = 0.6 }, 0.1) end
		end)
		btn.MouseLeave:Connect(function()
			if win.ActiveTab ~= tab then tw(btn, { BackgroundTransparency = 1 }, 0.1) end
		end)

		tab.AddSection = function(_, sname, _flag)
			return buildSection(win, tab, sname)
		end
		local defaultSec
		for nm in pairs(ADDERS) do
			tab[nm] = function(_, a)
				if not defaultSec then defaultSec = buildSection(win, tab, nil) end
				return defaultSec[nm](defaultSec, a)
			end
		end
		tab.Select = function() selectTab(tab) end
		tab.SetVisible = function(_, v) btn.Visible = v ~= false end

		win._tabsList[#win._tabsList + 1] = tab
		win.Tabs[#win.Tabs + 1] = tab
		tab._setActive(false)
		if #win._tabsList == 1 then selectTab(tab) end
		return tab
	end

	function win.AddForum(_, o)
		o = o or {}
		local tab = win.AddTab(win, { Name = o.Name or "Forum", Icon = o.Icon or "forum" })
		local sec = tab:AddSection(o.Section or "Forum")
		local posts = {}
		local saved = Config.get("__forum")
		if type(saved) == "table" then posts = saved end

		local list
		local function rows()
			local out = {}
			for i = #posts, 1, -1 do
				local p = posts[i]
				out[#out + 1] = {
					id = tostring(i), name = tostring(p.title or ""),
					sub = string.format('<font color="#A2A2AE">%s · %s</font>', esc(p.author or "?"), os.date("%d/%m %H:%M", p.at or 0)),
					status = esc(string.sub(tostring(p.body or ""), 1, 60)), statusSub = "", button = "Copy", buttonColor = "accent",
					onClick = function(_, setBtn)
						local ok = false
						if setclipboard then ok = pcall(setclipboard, tostring(p.body or "")) end
						setBtn(ok and "Copied" or "No clip", ok and "green" or "red")
						task.delay(1.4, function() pcall(setBtn, "Copy", "accent") end)
					end,
				}
			end
			return out
		end

		local titleIn = sec:AddInput({ Title = "Title", Placeholder = "Post title", Default = "", Flag = "__forum_title" })
		local bodyIn = sec:AddInput({ Title = "Content", Placeholder = "Config / note to share", Default = "", Flag = "__forum_body" })
		sec:AddButton({
			Title = "Publish", Content = "Saves the post locally in this forum.",
			Callback = function()
				local t, b = tostring(titleIn.Value or ""), tostring(bodyIn.Value or "")
				if t == "" or b == "" then
					Library.Notify(Library, { Title = "Forum", Content = "Fill the title and the content first.", Duration = 3 })
					return
				end
				posts[#posts + 1] = {
					title = t, body = b, at = os.time(),
					author = Players.LocalPlayer and Players.LocalPlayer.Name or "?",
				}
				Config.set("__forum", posts)
				titleIn:Set("", true)
				bodyIn:Set("", true)
				if list then list:Update(rows()) end
			end,
		})
		list = sec:AddActionList({ Title = "Posts", EmptyText = "No posts yet.", VisibleRows = 5, ButtonWidth = 72 })
		list:Update(rows())
		return tab
	end

	function win.Toggle(_, v)
		if v == nil then v = not main.Visible end
		setVisible(v)
	end
	win.SetVisible = win.Toggle
	function win.SelectTab(_, t)
		if type(t) == "table" and t._setActive then selectTab(t) end
	end
	function win.Notify(_, o) Library.Notify(Library, o) end
	function win.Alive() return not win._dead and gui.Parent ~= nil end
	function win.Destroy(self)
		if win._dead then return end
		win._dead = true
		for _, c in ipairs(win._conns) do pcall(function() c:Disconnect() end) end
		win._conns = {}
		pcall(function() gui:Destroy() end)
		for i, w in ipairs(Library.Windows) do
			if w == win then table.remove(Library.Windows, i) break end
		end
		if type(Library.OnDestroy) == "function" then fire(Library.OnDestroy) end
	end
	win.DestroyGui = win.Destroy
	win.Close = win.Destroy

	Library.Windows[#Library.Windows + 1] = win
	return win
end

function Library.DestroyGui(self)
	for _, w in ipairs(Library.Windows) do pcall(w.Destroy, w) end
	Library.Windows = {}
	if notifGui then pcall(function() notifGui:Destroy() end) end
	notifGui, notifHolder = nil, nil
end

return Library
