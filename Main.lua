--[[
	SenaLib v2.0.0  (visual / logica / animacoes da StarHubUI, API do SenaHub)

	Uso (igual ao SenaHub):
		local Lib = loadstring(game:HttpGet("SEU_LINK_RAW"))()
		local Win = Lib:Window({Title="Sena BETA |", Footer="Steal An Egg", Folder="SenaSAEv4", Image="logo (url ou rbxassetid)"})
		local Tab = Win:AddTab({Name="Main", Icon="home"})
		local Sec = Tab:AddSection("Auto Steal")           -- 2o parametro true = secao em largura total
		Sec:AddToggle / AddSlider / AddDropdown / AddInput / AddButton / AddParagraph / AddSubSection
		Sec:AddActionList / AddLiveChat / AddSupportCard / AddKeybind / AddColorPicker
		Win:AddForum({Name="Forum", Icon="forum", Section="Config Forum"})
		-- O painel "System & Theme" abre pelo botao no topo da janela (Window({SystemTab=false}) desliga)
		-- Tela de load "Welcome to <nome>": Window({LoadingTitle="Nome", LoadingScreen=false para desligar})
		Lib:Notify({Title="", Content="", Duration=3})
		Lib:SetTheme("StarHubGold")                         -- troca de tema ao vivo

	- .Value de cada elemento e salvo em <Folder>/SenaLib_config.json e restaurado ao recriar a UI.
	- Callbacks nao disparam na criacao, so por interacao (ou Set sem o parametro silent=true).
	- Chat ao vivo: Lib.ChatHandler = function(texto) end e Lib.LiveChat:AddMessage(user, texto).
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
local RunService = getService("RunService")
local HttpService = getService("HttpService")
local CoreGui = getService("CoreGui")
local SoundService = getService("SoundService")

local genv = (getgenv and getgenv()) or _G

if type(genv.__SenaLibInstance) == "table" and type(genv.__SenaLibInstance.DestroyGui) == "function" then
	pcall(genv.__SenaLibInstance.DestroyGui, genv.__SenaLibInstance)
end

local WHITE = Color3.fromRGB(255, 255, 255)

-- Fontes da UI (troque aqui para mudar a fonte de tudo). BuilderSans = limpa e legivel em tamanho pequeno.
local function pickFont(name, fallback)
	local ok, f = pcall(function() return Enum.Font[name] end)
	if ok and f then return f end
	return fallback
end
local F = {
	Regular = pickFont("BuilderSans", Enum.Font.Gotham),
	Medium = pickFont("BuilderSansMedium", Enum.Font.GothamMedium),
	Bold = pickFont("BuilderSansBold", Enum.Font.GothamBold),
}

local Themes = {
        NeverloseCrimson = {
            Name        = "Neverlose Crimson",
            Grad1       = Color3.fromRGB(235, 55, 75),
            Grad2       = Color3.fromRGB(255, 110, 80),
            Accent      = Color3.fromRGB(235, 55, 75),
            AccentLight = Color3.fromRGB(255, 110, 130),
            Background  = Color3.fromRGB(13, 14, 18),
            Sidebar     = Color3.fromRGB(10, 11, 14),
            Box         = Color3.fromRGB(18, 19, 25),
            SubBox      = Color3.fromRGB(24, 26, 34),
            Border      = Color3.fromRGB(36, 35, 46),
            BorderLight = Color3.fromRGB(58, 52, 68),
            TextTitle   = Color3.fromRGB(255, 255, 255),
            TextBody    = Color3.fromRGB(220, 218, 228),
            TextDim     = Color3.fromRGB(140, 136, 150),
            TextMuted   = Color3.fromRGB(90, 85, 98),
            Success     = Color3.fromRGB(34, 197, 94),
            Danger      = Color3.fromRGB(235, 55, 75)
        },
        StarHubGold = {
            Name        = "StarHub Gold",
            Grad1       = Color3.fromRGB(245, 158, 11),
            Grad2       = Color3.fromRGB(251, 191, 36),
            Accent      = Color3.fromRGB(245, 158, 11),
            AccentLight = Color3.fromRGB(251, 191, 36),
            Background  = Color3.fromRGB(14, 13, 10),
            Sidebar     = Color3.fromRGB(11, 10, 8),
            Box         = Color3.fromRGB(21, 19, 15),
            SubBox      = Color3.fromRGB(28, 25, 19),
            Border      = Color3.fromRGB(44, 39, 30),
            BorderLight = Color3.fromRGB(64, 56, 42),
            TextTitle   = Color3.fromRGB(255, 255, 255),
            TextBody    = Color3.fromRGB(230, 225, 212),
            TextDim     = Color3.fromRGB(145, 138, 125),
            TextMuted   = Color3.fromRGB(95, 88, 78),
            Success     = Color3.fromRGB(16, 185, 129),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        CyberCyan = {
            Name        = "Cyber Cyan",
            Grad1       = Color3.fromRGB(6, 182, 212),
            Grad2       = Color3.fromRGB(139, 92, 246),
            Accent      = Color3.fromRGB(6, 182, 212),
            AccentLight = Color3.fromRGB(56, 189, 248),
            Background  = Color3.fromRGB(10, 13, 18),
            Sidebar     = Color3.fromRGB(8, 10, 14),
            Box         = Color3.fromRGB(16, 21, 30),
            SubBox      = Color3.fromRGB(22, 28, 40),
            Border      = Color3.fromRGB(32, 42, 60),
            BorderLight = Color3.fromRGB(48, 68, 96),
            TextTitle   = Color3.fromRGB(250, 252, 255),
            TextBody    = Color3.fromRGB(215, 225, 238),
            TextDim     = Color3.fromRGB(130, 145, 170),
            TextMuted   = Color3.fromRGB(80, 95, 115),
            Success     = Color3.fromRGB(34, 197, 94),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        MatrixEmerald = {
            Name        = "Matrix Emerald",
            Grad1       = Color3.fromRGB(16, 185, 129),
            Grad2       = Color3.fromRGB(52, 211, 153),
            Accent      = Color3.fromRGB(16, 185, 129),
            AccentLight = Color3.fromRGB(52, 211, 153),
            Background  = Color3.fromRGB(10, 14, 12),
            Sidebar     = Color3.fromRGB(8, 11, 10),
            Box         = Color3.fromRGB(16, 22, 19),
            SubBox      = Color3.fromRGB(22, 30, 26),
            Border      = Color3.fromRGB(28, 44, 36),
            BorderLight = Color3.fromRGB(44, 68, 54),
            TextTitle   = Color3.fromRGB(245, 255, 250),
            TextBody    = Color3.fromRGB(210, 230, 220),
            TextDim     = Color3.fromRGB(120, 145, 130),
            TextMuted   = Color3.fromRGB(75, 95, 85),
            Success     = Color3.fromRGB(16, 185, 129),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        ObsidianViolet = {
            Name        = "Obsidian Violet",
            Grad1       = Color3.fromRGB(124, 58, 237),
            Grad2       = Color3.fromRGB(192, 132, 252),
            Accent      = Color3.fromRGB(124, 58, 237),
            AccentLight = Color3.fromRGB(144, 97, 249),
            Background  = Color3.fromRGB(12, 14, 19),
            Sidebar     = Color3.fromRGB(9, 10, 14),
            Box         = Color3.fromRGB(18, 20, 28),
            SubBox      = Color3.fromRGB(24, 27, 38),
            Border      = Color3.fromRGB(34, 38, 52),
            BorderLight = Color3.fromRGB(52, 60, 80),
            TextTitle   = Color3.fromRGB(255, 255, 255),
            TextBody    = Color3.fromRGB(215, 218, 230),
            TextDim     = Color3.fromRGB(125, 130, 150),
            TextMuted   = Color3.fromRGB(80, 85, 102),
            Success     = Color3.fromRGB(16, 185, 129),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        SakuraBlossom = {
            Name        = "Sakura Blossom",
            Grad1       = Color3.fromRGB(244, 63, 94),
            Grad2       = Color3.fromRGB(251, 113, 133),
            Accent      = Color3.fromRGB(244, 63, 94),
            AccentLight = Color3.fromRGB(251, 113, 133),
            Background  = Color3.fromRGB(18, 12, 16),
            Sidebar     = Color3.fromRGB(14, 9, 12),
            Box         = Color3.fromRGB(26, 18, 23),
            SubBox      = Color3.fromRGB(34, 24, 30),
            Border      = Color3.fromRGB(52, 34, 44),
            BorderLight = Color3.fromRGB(78, 48, 64),
            TextTitle   = Color3.fromRGB(255, 250, 252),
            TextBody    = Color3.fromRGB(235, 215, 225),
            TextDim     = Color3.fromRGB(155, 130, 142),
            TextMuted   = Color3.fromRGB(105, 80, 92),
            Success     = Color3.fromRGB(34, 197, 94),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        GlacierIce = {
            Name        = "Glacier Ice",
            Grad1       = Color3.fromRGB(2, 132, 199),
            Grad2       = Color3.fromRGB(56, 189, 248),
            Accent      = Color3.fromRGB(2, 132, 199),
            AccentLight = Color3.fromRGB(56, 189, 248),
            Background  = Color3.fromRGB(10, 14, 20),
            Sidebar     = Color3.fromRGB(8, 11, 16),
            Box         = Color3.fromRGB(15, 22, 32),
            SubBox      = Color3.fromRGB(20, 30, 44),
            Border      = Color3.fromRGB(30, 48, 70),
            BorderLight = Color3.fromRGB(45, 75, 110),
            TextTitle   = Color3.fromRGB(245, 252, 255),
            TextBody    = Color3.fromRGB(210, 230, 245),
            TextDim     = Color3.fromRGB(130, 150, 175),
            TextMuted   = Color3.fromRGB(80, 100, 125),
            Success     = Color3.fromRGB(34, 197, 94),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        SunsetFlame = {
            Name        = "Sunset Flame",
            Grad1       = Color3.fromRGB(234, 88, 12),
            Grad2       = Color3.fromRGB(245, 158, 11),
            Accent      = Color3.fromRGB(234, 88, 12),
            AccentLight = Color3.fromRGB(251, 146, 60),
            Background  = Color3.fromRGB(16, 12, 10),
            Sidebar     = Color3.fromRGB(13, 9, 8),
            Box         = Color3.fromRGB(24, 18, 14),
            SubBox      = Color3.fromRGB(32, 24, 18),
            Border      = Color3.fromRGB(50, 36, 26),
            BorderLight = Color3.fromRGB(75, 52, 36),
            TextTitle   = Color3.fromRGB(255, 250, 245),
            TextBody    = Color3.fromRGB(235, 220, 210),
            TextDim     = Color3.fromRGB(155, 135, 125),
            TextMuted   = Color3.fromRGB(105, 85, 75),
            Success     = Color3.fromRGB(34, 197, 94),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        ElectricLime = {
            Name        = "Electric Lime",
            Grad1       = Color3.fromRGB(132, 204, 22),
            Grad2       = Color3.fromRGB(163, 230, 53),
            Accent      = Color3.fromRGB(132, 204, 22),
            AccentLight = Color3.fromRGB(163, 230, 53),
            Background  = Color3.fromRGB(11, 14, 10),
            Sidebar     = Color3.fromRGB(9, 11, 8),
            Box         = Color3.fromRGB(17, 22, 15),
            SubBox      = Color3.fromRGB(23, 30, 20),
            Border      = Color3.fromRGB(36, 48, 30),
            BorderLight = Color3.fromRGB(54, 72, 44),
            TextTitle   = Color3.fromRGB(250, 255, 245),
            TextBody    = Color3.fromRGB(220, 235, 215),
            TextDim     = Color3.fromRGB(135, 150, 130),
            TextMuted   = Color3.fromRGB(85, 100, 80),
            Success     = Color3.fromRGB(132, 204, 22),
            Danger      = Color3.fromRGB(239, 68, 68)
        },
        MidnightStealth = {
            Name        = "Midnight Stealth",
            Grad1       = Color3.fromRGB(148, 163, 184),
            Grad2       = Color3.fromRGB(203, 213, 225),
            Accent      = Color3.fromRGB(148, 163, 184),
            AccentLight = Color3.fromRGB(226, 232, 240),
            Background  = Color3.fromRGB(11, 12, 14),
            Sidebar     = Color3.fromRGB(9, 9, 11),
            Box         = Color3.fromRGB(17, 18, 22),
            SubBox      = Color3.fromRGB(23, 24, 30),
            Border      = Color3.fromRGB(34, 36, 44),
            BorderLight = Color3.fromRGB(52, 55, 66),
            TextTitle   = Color3.fromRGB(255, 255, 255),
            TextBody    = Color3.fromRGB(220, 222, 228),
            TextDim     = Color3.fromRGB(135, 140, 150),
            TextMuted   = Color3.fromRGB(85, 90, 100),
            Success     = Color3.fromRGB(34, 197, 94),
            Danger      = Color3.fromRGB(239, 68, 68)
        }
}

local Icons = {
	Logo = "rbxassetid://10709819149", Search = "rbxassetid://10734943674", Close = "rbxassetid://10747384394",
	Minimize = "rbxassetid://10709791185", Settings = "rbxassetid://10734950309", ChevronDown = "rbxassetid://10709790948",
	Palette = "rbxassetid://10734910430", Save = "rbxassetid://10734941499", Skull = "rbxassetid://10734962068",
	Dashboard = "rbxassetid://10709752035", Combat = "rbxassetid://10709818534", Visuals = "rbxassetid://10747375132",
	Teleport = "rbxassetid://10723404337", Refresh = "rbxassetid://10734933222", Server = "rbxassetid://10734963400",
	Copy = "rbxassetid://10709812159", Sound = "rbxassetid://10709810814", SoundMute = "rbxassetid://10709810619",
	Bell = "rbxassetid://10709752996", Info = "rbxassetid://10709752996", Check = "rbxassetid://10709790644",
	Zap = "rbxassetid://10709791882",
}

-- nomes de icone usados pelo SenaHub -> icones da StarHubUI (tudo imagem, sem emoji)
local IconMap = {
	home = Icons.Dashboard, settings = Icons.Settings, swords = Icons.Combat, eye = Icons.Visuals,
	["repeat"] = Icons.Refresh, flame = Icons.Zap, bolt = Icons.Zap, server = Icons.Server, teleport = Icons.Teleport,
	palette = Icons.Palette, save = Icons.Save, skull = Icons.Skull, bell = Icons.Bell, info = Icons.Info,
	copy = Icons.Copy, sound = Icons.Sound, search = Icons.Search, logo = Icons.Logo, check = Icons.Check,
	users = Icons.Server, chat = Icons.Bell, forum = Icons.Info, donator = Icons.Logo, sparkles = Icons.Palette,
	star = Icons.Logo, shop = Icons.Dashboard, egg = Icons.Dashboard, pet = Icons.Visuals, tools = Icons.Settings,
	list = Icons.Dashboard, map = Icons.Teleport, gift = Icons.Zap, clock = Icons.Refresh, code = Icons.Settings,
	key = Icons.Settings,
}

local Library = {
	Version = "2.0.0",
	Windows = {},
	Themes = Themes,
	Icons = Icons,
	SupportLinks = { { Name = "Website", Url = "https://senahub.xyz" } },
	Settings = {
		SoundEnabled = true,
		SoundVolume = 0.55,
		WindowTransparency = 0,
		ShowFloatingToggle = true,
		ControlsPosition = "Left",
		KeybindMode = "Toggle",
		ToggleKey = "RightControl",
		CurrentTheme = "NeverloseCrimson",
		AccentStyle = "Gradient",
		WallpaperTransparency = 0.92,
		WallpaperDimming = 0.35,
		BackgroundEffect = (UIS.TouchEnabled and not UIS.KeyboardEnabled) and "Subtle Ambient Glow" or "Floating Bubbles",
		LowLag = false,
		ElementGradient = false,
		ElemGradSource = "Accent",
		ElemGradAmount = 0.35,
		ShowSplash = true,
		AutoSaveEnabled = true,
		AcrylicEnabled = false,
		BaseTheme = "NeverloseCrimson",
		BgMode = "Theme",
		BgColor1 = "#4F46E5",
		BgColor2 = "#2B277E",
		BgColor3 = "#161440",
		BgUse3 = false,
		BgAngle = 45,
		BgAnimate = false,
		GlassSidebar = true,
		PanelTransparency = 0,
	},
}
genv.__SenaLibInstance = Library
Library.Fonts = F

local Theme = Themes.NeverloseCrimson

----------------------------------------------------------------------
-- Registro de tema (troca ao vivo)
----------------------------------------------------------------------
local Reg = {
	Gradients = {}, Accents = {}, AccentLights = {}, Backgrounds = {}, Sidebars = {}, Boxes = {}, SubBoxes = {},
	Borders = {}, Texts = {}, Renderers = {}, Panels = {},
}

-- degrade opcional nos elementos (cards, caixas, botoes)
local function parseHex(h)
	if type(h) ~= "string" then return nil end
	h = h:gsub("#", "")
	if #h ~= 6 then return nil end
	local r, g, b = tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
	if not (r and g and b) then return nil end
	return Color3.fromRGB(r, g, b)
end

local function elemGradColors(base)
	local st = Library.Settings
	local c1, c2 = Theme.Grad1 or Theme.Accent, Theme.Grad2 or Theme.AccentLight
	local rot = 20
	if st.ElemGradSource == "Background" and st.BgMode == "Gradient" then
		c1 = parseHex(st.BgColor1) or c1
		c2 = parseHex(st.BgUse3 and st.BgColor3 or st.BgColor2) or c2
		rot = st.BgAngle or 45
	end
	local amt = st.ElemGradAmount or 0.35
	return base:Lerp(c1, amt), base:Lerp(c2, amt * 0.5), rot
end

local function paintBg(o, base)
	local g = o:FindFirstChild("ElemGrad")
	if g and Library.Settings.ElementGradient then
		local a, b, rot = elemGradColors(base)
		o.BackgroundColor3 = WHITE
		g.Color = ColorSequence.new(a, b)
		g.Rotation = rot
		g.Enabled = true
	else
		if g then g.Enabled = false end
		o.BackgroundColor3 = base
	end
end

local function attachElemGrad(obj, base)
	if not obj or obj:GetAttribute("NoElemGrad") or obj:FindFirstChild("ElemGrad") then return end
	if obj:IsA("TextBox") or obj:IsA("TextLabel") then return end
	if obj:IsA("TextButton") and obj.Text ~= "" then return end
	local g = Instance.new("UIGradient")
	g.Name = "ElemGrad"
	g.Enabled = false
	g.Parent = obj
	if Library.Settings.ElementGradient then paintBg(obj, base) end
end

local function repaintBoxes()
	for _, o in ipairs(Reg.Boxes) do
		if o and o.Parent then paintBg(o, Theme.Box) end
	end
	for _, o in ipairs(Reg.SubBoxes) do
		if o and o.Parent then paintBg(o, Theme.SubBox) end
	end
end

local regCount = 0
local function compactReg()
	for k, list in pairs(Reg) do
		local n = {}
		if k == "Texts" then
			for _, e in ipairs(list) do
				if e.obj and e.obj.Parent then n[#n + 1] = e end
			end
		elseif k == "Renderers" then
			for _, e in ipairs(list) do
				if not e.owner or e.owner.Parent then n[#n + 1] = e end
			end
		else
			for _, o in ipairs(list) do
				if o and o.Parent then n[#n + 1] = o end
			end
		end
		Reg[k] = n
	end
end

local function reg(cat, obj)
	local t = Reg[cat]
	if t then t[#t + 1] = obj end
	regCount = regCount + 1
	if regCount % 400 == 0 then compactReg() end
	if cat == "Panels" then
		attachElemGrad(obj, Theme.Box)
	elseif cat == "SubBoxes" then
		attachElemGrad(obj, Theme.SubBox)
	end
	return obj
end

local function regText(obj, role)
	Reg.Texts[#Reg.Texts + 1] = { obj = obj, role = role }
	obj.TextColor3 = Theme[role]
	return obj
end

local function onTheme(fn, owner)
	Reg.Renderers[#Reg.Renderers + 1] = { fn = fn, owner = owner }
end

local function resetRegistry()
	for k in pairs(Reg) do Reg[k] = {} end
end

local function ApplyGradient(obj, c1, c2, rot)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = WHITE end
	local solid = Library.Settings.AccentStyle == "Solid"
	c1 = c1 or Theme.Grad1
	c2 = solid and c1 or (c2 or Theme.Grad2)
	local grad = obj:FindFirstChildOfClass("UIGradient")
	if not grad then
		grad = Instance.new("UIGradient")
		grad.Parent = obj
		reg("Gradients", grad)
	end
	grad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
	grad.Rotation = rot or 0
	return grad
end

local function applyThemeAll()
	local solid = Library.Settings.AccentStyle == "Solid"
	local c1 = Theme.Grad1 or Theme.Accent
	local c2 = solid and c1 or (Theme.Grad2 or Theme.AccentLight)
	for _, g in ipairs(Reg.Gradients) do
		if g and g.Parent then
			if g.Name == "ChasingRingGrad" then
				g.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c1),
				})
			else
				g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
			end
			if g.Parent:IsA("TextLabel") or g.Parent:IsA("TextButton") then g.Parent.TextColor3 = WHITE end
		end
	end
	local function paint(list, col)
		for _, item in ipairs(list) do
			if item and item.Parent then
				if item:IsA("UIStroke") then
					item.Color = col
				elseif item:IsA("ImageLabel") or item:IsA("ImageButton") then
					item.ImageColor3 = col
				elseif item:IsA("TextLabel") or item:IsA("TextButton") then
					if item:FindFirstChildOfClass("UIGradient") then item.TextColor3 = WHITE else item.TextColor3 = col end
				elseif item:IsA("Frame") then
					item.BackgroundColor3 = col
				end
			end
		end
	end
	paint(Reg.Accents, Theme.Accent)
	paint(Reg.AccentLights, Theme.AccentLight)
	for _, o in ipairs(Reg.Backgrounds) do if o and o.Parent then o.BackgroundColor3 = Theme.Background end end
	for _, o in ipairs(Reg.Sidebars) do if o and o.Parent then o.BackgroundColor3 = Theme.Sidebar end end
	repaintBoxes()
	paint(Reg.Borders, Theme.Border)
	for _, e in ipairs(Reg.Texts) do
		if e.obj and e.obj.Parent then e.obj.TextColor3 = Theme[e.role] end
	end
	local alive = {}
	for _, e in ipairs(Reg.Renderers) do
		if not e.owner or e.owner.Parent then
			pcall(e.fn)
			alive[#alive + 1] = e
		end
	end
	Reg.Renderers = alive
end

----------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------
local function Tween(obj, duration, props, style, dir)
	if not obj then return end
	local tw = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function MicroBounce(obj)
	local s = obj:FindFirstChildOfClass("UIScale")
	if not s then s = Instance.new("UIScale", obj) end
	Tween(s, 0.08, { Scale = 0.94 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.delay(0.08, function()
		Tween(s, 0.2, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
end

local SoundMap = {
	Click = { id = "rbxassetid://6895079853", pitch = 1.10, vol = 0.32 },
	ToggleOn = { id = "rbxassetid://6895079853", pitch = 1.40, vol = 0.35 },
	ToggleOff = { id = "rbxassetid://6895079853", pitch = 0.88, vol = 0.28 },
	TabSwitch = { id = "rbxassetid://6895079853", pitch = 1.25, vol = 0.30 },
	Dropdown = { id = "rbxassetid://6895079853", pitch = 1.00, vol = 0.30 },
	Notify = { id = "rbxassetid://4590662766", pitch = 1.35, vol = 0.38 },
}

local function PlaySound(name)
	if not Library.Settings.SoundEnabled then return end
	local conf = SoundMap[name] or SoundMap.Click
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = conf.id
		s.Volume = conf.vol * (Library.Settings.SoundVolume or 0.55)
		s.PlaybackSpeed = conf.pitch
		s.Parent = SoundService
		s.Ended:Connect(function() s:Destroy() end)
		task.delay(1.5, function() if s and s.Parent then s:Destroy() end end)
		s:Play()
	end)
end

local function rname()
	local g = HttpService:GenerateGUID(false)
	g = g:gsub("-", "")
	return g:sub(1, 14)
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

local function corner(o, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o)
end
local function round(o) return new("UICorner", { CornerRadius = UDim.new(1, 0) }, o) end

local function stroke(o, col, th, tr)
	return new("UIStroke", {
		Color = col or Theme.Border, Thickness = th or 1, Transparency = tr or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, o)
end
local function bstroke(o, th, tr)
	local s = stroke(o, Theme.Border, th, tr)
	reg("Borders", s)
	return s
end

local function padding(o, l, r, t, b)
	return new("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0),
		PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0),
	}, o)
end

local function vlist(o, pad)
	return new("UIListLayout", { Padding = UDim.new(0, pad or 0), SortOrder = Enum.SortOrder.LayoutOrder }, o)
end

local function lbl(parent, props, role)
	local p = {
		BackgroundTransparency = 1, BorderSizePixel = 0, Font = F.Regular, TextSize = 12.5,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
		RichText = true, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0), Text = "",
	}
	if props then
		for k, v in pairs(props) do p[k] = v end
	end
	local o = new("TextLabel", p, parent)
	if not (props and props.TextColor3) then regText(o, role or "TextBody") end
	return o
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

local function fmtNum(v, decimals)
	if decimals <= 0 then return tostring(math.floor(v + 0.5)) end
	return string.format("%." .. decimals .. "f", v)
end

-- imagem custom (url/asset) sem travar a UI
local function LoadCustomImage(urlOrAsset, default)
	default = default or Icons.Logo
	if type(urlOrAsset) ~= "string" or urlOrAsset == "" then return default end
	if urlOrAsset:find("^rbxasset") then return urlOrAsset end
	if tonumber(urlOrAsset) then return "rbxassetid://" .. urlOrAsset end
	if urlOrAsset:find("roblox%.com") then
		local n = urlOrAsset:match("%d+")
		if n then return "rbxassetid://" .. n end
	end
	if urlOrAsset:find("^https?://") and writefile and isfile and getcustomasset then
		local safe = "senalib_logo_" .. tostring(math.abs(#urlOrAsset * 37 + (urlOrAsset:byte(1) or 0) * 17)) .. ".png"
		pcall(function()
			if not isfile(safe) then
				local res = game:HttpGet(urlOrAsset)
				if res and #res > 100 then writefile(safe, res) end
			end
		end)
		if isfile(safe) then
			local ok, a = pcall(getcustomasset, safe)
			if ok and a then return a end
		end
	end
	return default
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

local function cfgGet(key, opts)
	if opts and opts.NoSave then return nil end
	return Config.get(key)
end
local function cfgSet(key, opts, v)
	if opts and opts.NoSave then return end
	Config.set(key, v)
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

local function copyTheme(t)
	local c = {}
	for k, v in pairs(t) do c[k] = v end
	return c
end

local function hexToColor(h)
	if type(h) ~= "string" then return nil end
	h = h:gsub("#", "")
	if #h ~= 6 then return nil end
	local r, g, b = tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
	if not (r and g and b) then return nil end
	return Color3.fromRGB(r, g, b)
end

local function rebuildTheme()
	local s = Library.Settings
	local baseKey = (s.CurrentTheme == "Custom") and s.BaseTheme or s.CurrentTheme
	Theme = copyTheme(Themes[baseKey] or Themes.NeverloseCrimson)
	if s.CurrentTheme == "Custom" then
		local c1, c2 = hexToColor(s.CustomColor1), hexToColor(s.CustomColor2)
		if c1 and c2 then
			Theme.Accent, Theme.Grad1, Theme.Grad2, Theme.AccentLight = c1, c1, c2, c2
		end
	end
end

local function saveUiSettings(force)
	local s = Library.Settings
	if s.AutoSaveEnabled == false and not force then return end
	Config.set("__ui", {
		theme = s.CurrentTheme, baseTheme = s.BaseTheme, custom1 = s.CustomColor1, custom2 = s.CustomColor2,
		accent = s.AccentStyle, effect = s.BackgroundEffect, sound = s.SoundEnabled, volume = s.SoundVolume,
		floating = s.ShowFloatingToggle, transparency = s.WindowTransparency, controls = s.ControlsPosition,
		keymode = s.KeybindMode, key = s.ToggleKey, logo = s.CustomLogoUrl, wallpaper = s.CustomWallpaperId,
		wallT = s.WallpaperTransparency, wallD = s.WallpaperDimming, acrylic = s.AcrylicEnabled, autosave = s.AutoSaveEnabled, lowlag = s.LowLag, elemGrad = s.ElementGradient, elemSrc = s.ElemGradSource, elemAmt = s.ElemGradAmount, splash = s.ShowSplash,
		bgMode = s.BgMode, bgC1 = s.BgColor1, bgC2 = s.BgColor2, bgC3 = s.BgColor3, bgUse3 = s.BgUse3, bgAngle = s.BgAngle,
		bgAnim = s.BgAnimate, glass = s.GlassSidebar, panelT = s.PanelTransparency,
	})
end

local function loadUiSettings()
	local d = Config.get("__ui")
	if type(d) ~= "table" then return end
	local s = Library.Settings
	if type(d.baseTheme) == "string" and Themes[d.baseTheme] then s.BaseTheme = d.baseTheme end
	if d.theme == "Custom" then
		s.CurrentTheme = "Custom"
		s.CustomColor1, s.CustomColor2 = d.custom1, d.custom2
	elseif type(d.theme) == "string" and Themes[d.theme] then
		s.CurrentTheme = d.theme
		s.BaseTheme = d.theme
	end
	if d.accent == "Solid" or d.accent == "Gradient" then s.AccentStyle = d.accent end
	if type(d.effect) == "string" then s.BackgroundEffect = d.effect end
	if type(d.sound) == "boolean" then s.SoundEnabled = d.sound end
	if type(d.volume) == "number" then s.SoundVolume = math.clamp(d.volume, 0, 1) end
	if type(d.floating) == "boolean" then s.ShowFloatingToggle = d.floating end
	if type(d.transparency) == "number" then s.WindowTransparency = math.clamp(d.transparency, 0, 0.8) end
	if d.controls == "Left" or d.controls == "Right" then s.ControlsPosition = d.controls end
	if d.keymode == "Toggle" or d.keymode == "Hold" or d.keymode == "Always" then s.KeybindMode = d.keymode end
	if type(d.logo) == "string" and d.logo ~= "" then s.CustomLogoUrl = d.logo end
	if type(d.wallpaper) == "string" and d.wallpaper ~= "" then s.CustomWallpaperId = d.wallpaper end
	if type(d.wallT) == "number" then s.WallpaperTransparency = math.clamp(d.wallT, 0, 1) end
	if type(d.wallD) == "number" then s.WallpaperDimming = math.clamp(d.wallD, 0, 1) end
	if type(d.acrylic) == "boolean" then s.AcrylicEnabled = d.acrylic end
	if type(d.autosave) == "boolean" then s.AutoSaveEnabled = d.autosave end
	if type(d.lowlag) == "boolean" then s.LowLag = d.lowlag end
	if type(d.elemGrad) == "boolean" then s.ElementGradient = d.elemGrad end
	if d.elemSrc == "Accent" or d.elemSrc == "Background" then s.ElemGradSource = d.elemSrc end
	if type(d.elemAmt) == "number" then s.ElemGradAmount = math.clamp(d.elemAmt, 0, 1) end
	if type(d.splash) == "boolean" then s.ShowSplash = d.splash end
	if d.bgMode == "Theme" or d.bgMode == "Solid" or d.bgMode == "Gradient" then s.BgMode = d.bgMode end
	if hexToColor(d.bgC1) then s.BgColor1 = d.bgC1 end
	if hexToColor(d.bgC2) then s.BgColor2 = d.bgC2 end
	if hexToColor(d.bgC3) then s.BgColor3 = d.bgC3 end
	if type(d.bgUse3) == "boolean" then s.BgUse3 = d.bgUse3 end
	if type(d.bgAngle) == "number" then s.BgAngle = d.bgAngle % 360 end
	if type(d.bgAnim) == "boolean" then s.BgAnimate = d.bgAnim end
	if type(d.glass) == "boolean" then s.GlassSidebar = d.glass end
	if type(d.panelT) == "number" then s.PanelTransparency = math.clamp(d.panelT, 0, 0.6) end
	rebuildTheme()
end

local function applyCustomColors(c1, c2)
	local s = Library.Settings
	if s.CurrentTheme ~= "Custom" and Themes[s.CurrentTheme] then s.BaseTheme = s.CurrentTheme end
	s.CurrentTheme = "Custom"
	s.CustomColor1 = hex(c1)
	s.CustomColor2 = hex(c2)
	rebuildTheme()
	applyThemeAll()
	saveUiSettings()
end

----------------------------------------------------------------------
-- Notify (estilo StarHubUI: modal que desce do topo)
----------------------------------------------------------------------
local activeNotif
local notifHost

local function ensureHost()
	if notifHost and notifHost.Parent then return notifHost end
	notifHost = new("ScreenGui", {
		Name = rname(), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000,
	})
	protect(notifHost)
	notifHost.Parent = getParent()
	return notifHost
end

function Library.Notify(a, b)
	local cfg
	if type(b) == "table" then
		cfg = b
	elseif type(a) == "table" and a ~= Library then
		cfg = a
	else
		cfg = {}
	end
	local title = tostring(cfg.Title or "NOTIFICATION")
	local desc = tostring(cfg.Content or cfg.Description or "")
	local duration = tonumber(cfg.Duration) or 3.5
	local iconId = cfg.Icon or Icons.Bell
	local badgeText = tostring(cfg.Badge or "INFO")
	local badgeCol = cfg.BadgeColor or (badgeText == "COPIED" and Theme.Success or Theme.AccentLight)

	PlaySound("Notify")
	if activeNotif and activeNotif.Parent then pcall(function() activeNotif:Destroy() end) end
	activeNotif = nil

	local targetParent, protruding
	local w = Library._current
	if w and w.Main and w.Main.Parent and w.Main.Visible and not w._minimized then
		targetParent = w.Main
		protruding = true
	else
		targetParent = ensureHost()
		protruding = false
	end

	pcall(function()
		local modal = new("Frame", {
			Name = "SenaNotification", AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.new(0, 390, 0, 58),
			BackgroundColor3 = Color3.fromRGB(18, 16, 26), BackgroundTransparency = 0.05, ZIndex = 5000,
			ClipsDescendants = true,
		}, targetParent)
		corner(modal, 14)
		local mStroke = new("UIStroke", {
			Thickness = 1.4, Color = Theme.BorderLight, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, modal)
		ApplyGradient(mStroke, Theme.Grad1, Theme.Grad2, 45)

		local glow = new("Frame", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.95,
			BorderSizePixel = 0, ZIndex = 5000,
		}, modal)
		corner(glow, 14)
		reg("Accents", glow)

		local icBadge = new("Frame", {
			Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(0, 12, 0.5, -18), BackgroundColor3 = Theme.SubBox,
			BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 5001,
		}, modal)
		corner(icBadge, 10)
		stroke(icBadge, Theme.Border, 0.8, 0.5)
		local icImg = new("ImageLabel", {
			Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0.5, -10, 0.5, -10), BackgroundTransparency = 1,
			Image = tostring(iconId), ImageColor3 = Theme.AccentLight, ZIndex = 5002,
		}, icBadge)
		reg("AccentLights", icImg)

		local tL = new("TextLabel", {
			Size = UDim2.new(1, -145, 0, 16), Position = UDim2.new(0, 58, 0, 11), BackgroundTransparency = 1,
			Font = F.Bold, TextSize = 13.5, TextColor3 = Theme.TextTitle, TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd, Text = string.upper(title), ZIndex = 5001,
		}, modal)
		local sL = new("TextLabel", {
			Size = UDim2.new(1, -145, 0, 16), Position = UDim2.new(0, 58, 0, 29), BackgroundTransparency = 1,
			Font = F.Medium, TextSize = 12, TextColor3 = Theme.AccentLight, TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd, Text = desc, ZIndex = 5001,
		}, modal)
		reg("AccentLights", sL)

		local tag = new("Frame", {
			Size = UDim2.new(0, 64, 0, 22), Position = UDim2.new(1, -76, 0.5, -11), BackgroundColor3 = badgeCol,
			BackgroundTransparency = 0.82, ZIndex = 5001, BorderSizePixel = 0,
		}, modal)
		round(tag)
		stroke(tag, badgeCol, 0.8, 0.4)
		new("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = F.Bold, TextSize = 11,
			TextColor3 = badgeCol, Text = string.upper(badgeText), ZIndex = 5002,
		}, tag)

		local clickBtn = new("TextButton", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5005,
		}, modal)

		activeNotif = modal
		local startY = protruding and -75 or -60
		local targetY = protruding and -36 or 24
		modal.Position = UDim2.new(0.5, 0, 0, startY)
		Tween(modal, 0.35, { Position = UDim2.new(0.5, 0, 0, targetY) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		local dismissed = false
		local function Dismiss()
			if dismissed then return end
			dismissed = true
			pcall(function()
				local tw = Tween(modal, 0.25, { Position = UDim2.new(0.5, 0, 0, startY), BackgroundTransparency = 1 },
					Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				tw.Completed:Connect(function()
					if modal and modal.Parent then modal:Destroy() end
					if activeNotif == modal then activeNotif = nil end
				end)
			end)
			task.delay(0.3, function()
				if modal and modal.Parent then modal:Destroy() end
				if activeNotif == modal then activeNotif = nil end
			end)
		end
		clickBtn.Activated:Connect(Dismiss)
		task.delay(duration, Dismiss)
	end)
end

----------------------------------------------------------------------
-- Blocos comuns dos elementos
----------------------------------------------------------------------
local function newRow(sec, opts)
	sec._n = sec._n + 1
	local row = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = sec._n,
	}, sec._holder)
	new("UISizeConstraint", { MinSize = Vector2.new(0, 30) }, row)
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local entry = { Frame = row, SearchText = string.lower(title .. " " .. content), _content = content }
	local items = sec._win.AllSearchableItems
	items[#items + 1] = entry
	sec._weight(1)
	sec._win._lastBuild = os.clock()
	return row, entry
end

local function textBlock(parent, title, content, reserve)
	local col = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -(reserve or 0), 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	}, parent)
	vlist(col, 2)
	local t = lbl(col, { Font = F.Medium, TextSize = 14.5, Text = title, LayoutOrder = 1 }, "TextBody")
	local d = lbl(col, { Font = F.Regular, TextSize = 12.5, Text = content, LayoutOrder = 2 }, "TextDim")
	t.Visible = title ~= ""
	d.Visible = content ~= ""
	return col, t, d
end

local function attachCommon(el, row, t, d, entry, fmtTitle)
	el._row = row
	el.Alive = function() return not el._dead and row.Parent ~= nil end
	el.SetTitle = function(_, s)
		s = tostring(s == nil and "" or s)
		if t then
			local shown = fmtTitle and fmtTitle(s) or s
			if t.Text ~= shown then t.Text = shown end
			t.Visible = s ~= ""
		end
		if entry then entry.SearchText = string.lower(s .. " " .. (entry._content or "")) end
	end
	el.SetContent = function(_, s)
		s = tostring(s == nil and "" or s)
		if d then
			if d.Text ~= s then d.Text = s end
			d.Visible = s ~= ""
		end
		if entry then
			entry._content = s
			entry.SearchText = string.lower((t and t.Text or "") .. " " .. s)
		end
	end
	el.Lock = function()
		el._locked = true
		if t then t.TextTransparency = 0.5 end
		if d then d.TextTransparency = 0.5 end
	end
	el.Unlock = function()
		el._locked = false
		if t then t.TextTransparency = 0 end
		if d then d.TextTransparency = 0 end
	end
	el.SetVisible = function(_, v) row.Visible = v ~= false end
	el.Destroy = function()
		el._dead = true
		if row then row:Destroy() end
	end
	el.ResetValue = el.ResetValue or function() end
	return el
end

-- botao com texto (fill separado para o gradiente nao tingir o texto)
local function makeBtn(parent, props)
	props = props or {}
	local btn = new("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = props.Size or UDim2.new(0, 70, 0, 24),
		Position = props.Position or UDim2.new(), AnchorPoint = props.AnchorPoint or Vector2.new(), LayoutOrder = props.LayoutOrder or 0,
	}, parent)
	local fill = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = Theme.SubBox }, btn)
	corner(fill, props.Radius or 8)
	local st = stroke(fill, Theme.Border, 1, 0)
	local text = new("TextLabel", {
		Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 4, 0, 0), BackgroundTransparency = 1, Font = F.Bold,
		TextSize = props.TextSize or 12, TextColor3 = WHITE, Text = "", ZIndex = 2, TextTruncate = Enum.TextTruncate.AtEnd,
		RichText = true,
	}, btn)
	local api = { btn = btn, fill = fill, label = text, kind = nil }

	function api.setKind(kind)
		kind = kind or "accent"
		api.kind = kind
		local g = fill:FindFirstChildOfClass("UIGradient")
		if kind == "accent" then
			fill.BackgroundColor3 = WHITE
			ApplyGradient(fill, Theme.Grad1, Theme.Grad2, 45)
			st.Enabled = false
			text.TextColor3 = WHITE
		else
			if g then g:Destroy() end
			st.Enabled = true
			if kind == "green" then
				fill.BackgroundColor3 = Theme.Success
				st.Enabled = false
				text.TextColor3 = WHITE
			elseif kind == "red" then
				fill.BackgroundColor3 = Theme.Danger
				st.Enabled = false
				text.TextColor3 = WHITE
			elseif kind == "dim" then
				fill.BackgroundColor3 = Theme.Box
				st.Color = Theme.BorderLight
				text.TextColor3 = Theme.TextDim
			elseif kind == "off" then
				fill.BackgroundColor3 = Theme.SubBox
				st.Color = Theme.Border
				text.TextColor3 = Theme.TextDim
			else
				fill.BackgroundColor3 = Theme.SubBox
				st.Color = Theme.Border
				text.TextColor3 = Theme.TextTitle
			end
		end
	end
	function api.setText(s)
		s = tostring(s)
		if text.Text ~= s then text.Text = s end
	end
	api.setKind(props.Kind or "accent")
	onTheme(function() if btn.Parent then api.setKind(api.kind) end end, btn)

	btn.MouseEnter:Connect(function() Tween(fill, 0.12, { BackgroundTransparency = 0.12 }) end)
	btn.MouseLeave:Connect(function() Tween(fill, 0.12, { BackgroundTransparency = 0 }) end)
	return api
end

-- trilho arrastavel (slider e color picker)
local function makeTrack(sec, parent, props)
	props = props or {}
	local win = sec._win
	local hit = new("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = props.Size or UDim2.new(1, 0, 0, 20),
		Position = props.Position or UDim2.new(), LayoutOrder = props.LayoutOrder or 0,
	}, parent)
	local trackH = props.TrackH or 8
	local Track = new("Frame", {
		Size = UDim2.new(1, 0, 0, trackH), Position = UDim2.new(0, 0, 0.5, -trackH / 2),
		BackgroundColor3 = props.BarFrom and WHITE or Theme.SubBox, BorderSizePixel = 0,
	}, hit)
	round(Track)
	local barGrad
	if props.BarFrom then
		barGrad = new("UIGradient", { Color = ColorSequence.new(props.BarFrom, props.BarTo or props.BarFrom) }, Track)
	else
		Track:SetAttribute("NoElemGrad", true)
		reg("SubBoxes", Track)
	end
	local Fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, Track)
	round(Fill)
	ApplyGradient(Fill, Theme.Grad1, Theme.Grad2, 0)
	if props.BarFrom then Fill.Visible = false end
	local Knob = new("Frame", {
		Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, -9, 0.5, -9), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 2,
	}, Track)
	round(Knob)
	if props.BarFrom then stroke(Knob, Color3.fromRGB(20, 20, 30), 1.2, 0.2) end

	local api = { pct = 0, onChange = nil, hit = hit }
	function api.setBar(c1, c2)
		if barGrad then barGrad.Color = ColorSequence.new(c1, c2) end
	end
	function api.set(p)
		p = math.clamp(p, 0, 1)
		api.pct = p
		Fill.Size = UDim2.new(p, 0, 1, 0)
		Knob.Position = UDim2.new(p, -9, 0.5, -9)
	end

	local function fromX(x)
		local w = math.max(Track.AbsoluteSize.X, 1)
		local p = math.clamp((x - Track.AbsolutePosition.X) / w, 0, 1)
		api.set(p)
		if api.onChange then api.onChange(p, false) end
	end
	hit.InputBegan:Connect(function(i)
		if isPress(i) then
			PlaySound("Click")
			pcall(function() sec._page.ScrollingEnabled = false end)
			win._active = {
				onMove = function(inp) fromX(inp.Position.X) end,
				onEnd = function()
					pcall(function() sec._page.ScrollingEnabled = true end)
					if api.onChange then api.onChange(api.pct, true) end
				end,
			}
			fromX(i.Position.X)
		end
	end)
	return api
end

----------------------------------------------------------------------
-- Toggle
----------------------------------------------------------------------
local function addToggle(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Toggle")
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	local col, t, d = textBlock(row, title, content, 62)
	col.Position = UDim2.new(0, 0, 0, 4)

	local hit = new("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 1,
	}, row)
	local Pill = new("TextButton", {
		Size = UDim2.fromOffset(50, 28), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = Theme.SubBox, Text = "", AutoButtonColor = false, ZIndex = 2, BorderSizePixel = 0,
	}, row)
	round(Pill)
	local Knob = new("Frame", {
		Size = UDim2.fromOffset(22, 22), Position = UDim2.new(0, 3, 0.5, -11), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3,
	}, Pill)
	round(Knob)

	local el = { Type = "Toggle" }
	local saved = cfgGet(key, opts)
	if type(saved) == "boolean" then el.Value = saved else el.Value = opts.Default == true end

	local function render(anim)
		local pos
		if el.Value then
			Pill.BackgroundColor3 = WHITE
			ApplyGradient(Pill, Theme.Grad1, Theme.Grad2, 45)
			pos = UDim2.new(1, -25, 0.5, -11)
		else
			local g = Pill:FindFirstChildOfClass("UIGradient")
			if g then g:Destroy() end
			Pill.BackgroundColor3 = Theme.SubBox
			pos = UDim2.new(0, 3, 0.5, -11)
		end
		if anim then Tween(Knob, 0.2, { Position = pos }) else Knob.Position = pos end
	end
	render(false)
	onTheme(function() render(false) end, Pill)

	function el.Set(self, v, silent)
		v = (v == true)
		local changed = v ~= el.Value
		el.Value = v
		render(true)
		cfgSet(key, opts, v)
		if changed and not silent then fire(opts.Callback, v) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.ResetValue(self) el.Set(self, opts.Default == true) end
	function el.Get() return el.Value end
	el.GetValue = el.Get

	local function click()
		if el._locked then return end
		local nv = not el.Value
		PlaySound(nv and "ToggleOn" or "ToggleOff")
		MicroBounce(Pill)
		el.Set(el, nv)
	end
	Pill.Activated:Connect(click)
	hit.Activated:Connect(click)
	return attachCommon(el, row, t, d, entry)
end

----------------------------------------------------------------------
-- Slider
----------------------------------------------------------------------
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
	local suffix = opts.Suffix and (" " .. tostring(opts.Suffix)) or ""
	local function snap(v)
		v = math.clamp(v, min, max)
		v = math.floor((v - min) / inc + 0.5) * inc + min
		v = math.clamp(v, min, max)
		return tonumber(string.format("%.6f", v))
	end

	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	vlist(row, 5)

	local topRow = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1,
	}, row)
	local textCol = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -82, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	}, topRow)
	vlist(textCol, 2)
	local up = function(s) return string.upper(s) end
	local t = lbl(textCol, { Font = F.Bold, TextSize = 12.5, Text = up(title), LayoutOrder = 1 }, "TextBody")
	local d = lbl(textCol, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 2 }, "TextDim")
	t.Visible = title ~= ""
	d.Visible = content ~= ""
	local valLbl = new("TextLabel", {
		Size = UDim2.new(0, 78, 0, 18), Position = UDim2.new(1, -78, 0, 0), BackgroundTransparency = 1,
		Font = F.Bold, TextSize = 12.5, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Right,
		Text = "", RichText = false,
	}, topRow)
	ApplyGradient(valLbl, Theme.Grad1, Theme.Grad2, 0)

	local trackRow = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 2 }, row)

	local function stepBtn(text, pos)
		local b = new("TextButton", {
			Size = UDim2.fromOffset(28, 28), Position = pos, BackgroundColor3 = Theme.SubBox, Text = text, Font = F.Bold,
			TextSize = 14.5, AutoButtonColor = false, BorderSizePixel = 0, TextColor3 = Theme.TextDim,
		}, trackRow)
		round(b)
		bstroke(b, 1, 0)
		reg("SubBoxes", b)
		regText(b, "TextDim")
		return b
	end
	local btnDown = stepBtn("-", UDim2.new(0, 0, 0.5, -14))
	local bar = makeTrack(sec, trackRow, { Size = UDim2.new(1, -74, 0, 30), Position = UDim2.new(0, 37, 0, 0) })
	local btnUp = stepBtn("+", UDim2.new(1, -28, 0.5, -14))

	local el = { Type = "Slider" }
	local saved = cfgGet(key, opts)
	local startV = type(saved) == "number" and saved or tonumber(opts.Default) or min
	el.Value = snap(startV)
	local lastCommitted = el.Value

	local function show(v)
		valLbl.Text = fmtNum(v, decimals) .. suffix
		bar.set((v - min) / (max - min))
	end
	show(el.Value)

	local function commit(v, silent)
		v = snap(v)
		el.Value = v
		show(v)
		cfgSet(key, opts, v)
		if v ~= lastCommitted then
			lastCommitted = v
			if not silent then fire(opts.Callback, v) end
		end
	end

	bar.onChange = function(p, final)
		if el._locked then return end
		local v = snap(min + p * (max - min))
		valLbl.Text = fmtNum(v, decimals) .. suffix
		if not final and opts.OnDrag then fire(opts.OnDrag, v) end
		if final then commit(v, false) end
	end
	btnDown.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		commit(el.Value - inc, false)
	end)
	btnUp.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		commit(el.Value + inc, false)
	end)

	function el.Set(self, v, silent) commit(tonumber(v) or el.Value, silent) end
	el.SetValue = el.Set
	function el.LoadValue(self, v) commit(tonumber(v) or el.Value, true) end
	function el.ResetValue(self) commit(tonumber(opts.Default) or min, false) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, row, t, d, entry, up)
end

----------------------------------------------------------------------
-- Dropdown (simples / multi)
----------------------------------------------------------------------
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

	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	vlist(row, 5)
	local up = function(s) return string.upper(s) end

	local head = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1,
	}, row)
	vlist(head, 2)
	local t = lbl(head, { Font = F.Medium, TextSize = 12.5, Text = up(title), LayoutOrder = 1 }, "TextDim")
	local d = lbl(head, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 2 }, "TextMuted")
	t.Visible = title ~= ""
	d.Visible = content ~= ""

	local Box = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.SubBox, Text = "", AutoButtonColor = false, LayoutOrder = 2,
		BorderSizePixel = 0,
	}, row)
	corner(Box, 10)
	bstroke(Box, 1, 0)
	reg("SubBoxes", Box)
	local vLbl = lbl(Box, {
		Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 12, 0, 0), AutomaticSize = Enum.AutomaticSize.None,
		Font = F.Medium, TextSize = 13, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		TextYAlignment = Enum.TextYAlignment.Center, RichText = false,
	}, "TextTitle")
	local chev = new("ImageLabel", {
		Size = UDim2.fromOffset(14, 14), Position = UDim2.new(1, -24, 0.5, -7), BackgroundTransparency = 1,
		Image = Icons.ChevronDown, ImageColor3 = Theme.TextDim,
	}, Box)

	local panel = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, Visible = false, LayoutOrder = 3,
	}, row)
	local sbFrame = new("Frame", {
		Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.SubBox, BorderSizePixel = 0, Visible = false,
	}, panel)
	corner(sbFrame, 8)
	bstroke(sbFrame, 1, 0)
	reg("SubBoxes", sbFrame)
	local searchBox = new("TextBox", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), Text = "",
		PlaceholderText = "Search...", PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.TextTitle, Font = F.Regular,
		TextSize = 12.5, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
	}, sbFrame)
	local list = new("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 30),
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Border, ScrollingDirection = Enum.ScrollingDirection.Y,
	}, panel)
	new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, list)

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
		vLbl.Text = txt
		vLbl.TextColor3 = dim and Theme.TextMuted or Theme.TextTitle
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

	local saved = cfgGet(key, opts)
	if saved ~= nil and ((multi and type(saved) == "table") or (not multi and type(saved) == "string")) then
		applyValue(saved)
	else
		applyValue(opts.Default)
	end
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

	local function panelHeight()
		local searchH = (#options > 7) and 38 or 0
		sbFrame.Visible = searchH > 0
		list.Position = UDim2.new(0, 0, 0, searchH)
		local n = math.max(1, math.min(visibleCount(), maxVisible))
		local listH = n * 30 + (n - 1) * 3
		list.Size = UDim2.new(1, 0, 0, listH)
		return searchH + listH + 2
	end

	local function paintItem(b)
		local o = b:GetAttribute("opt")
		local on = (multi and isSel(o)) or (not multi and current == o)
		local lab = b:FindFirstChild("Txt")
		if lab then
			lab.TextColor3 = on and Theme.AccentLight or Theme.TextBody
			lab.Font = on and F.Bold or F.Regular
		end
		local chk = b:FindFirstChild("Chk")
		if chk then
			chk.Visible = on
			chk.ImageColor3 = Theme.AccentLight
		end
		b.BackgroundColor3 = on and Theme.SubBox or Theme.Box
	end

	local function commit(silent)
		local v = computeValue()
		el.Value = v
		refreshText()
		cfgSet(key, opts, v)
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

	local function setOpen(v)
		open = v
		PlaySound("Dropdown")
		Tween(chev, 0.22, { Rotation = v and 180 or 0 })
		if v then
			panel.Visible = true
			panel.Size = UDim2.new(1, 0, 0, 0)
			Tween(panel, 0.22, { Size = UDim2.new(1, 0, 0, panelHeight()) })
		else
			Tween(panel, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
			task.delay(0.22, function()
				if not open and panel.Parent then panel.Visible = false end
			end)
		end
	end

	local dirty = true
	local function buildItems()
		for _, b in ipairs(itemButtons) do b:Destroy() end
		itemButtons = {}
		for idx, o in ipairs(options) do
			local b = new("TextButton", {
				Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Box, Text = "", AutoButtonColor = false,
				LayoutOrder = idx, BorderSizePixel = 0,
			}, list)
			b:SetAttribute("opt", o)
			corner(b, 8)
			new("TextLabel", {
				Name = "Txt", Size = UDim2.new(1, -38, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
				Font = F.Regular, TextSize = 13.5, TextColor3 = Theme.TextBody, TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd, Text = o, RichText = false,
			}, b)
			new("ImageLabel", {
				Name = "Chk", Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
				BackgroundTransparency = 1, Image = Icons.Check, ImageColor3 = Theme.AccentLight, Visible = false,
			}, b)
			b.MouseEnter:Connect(function()
				if not isSel(o) and current ~= o then Tween(b, 0.12, { BackgroundColor3 = Theme.SubBox }) end
			end)
			b.MouseLeave:Connect(function() paintItem(b) end)
			b.Activated:Connect(function()
				if el._locked then return end
				PlaySound("Click")
				if multi then
					if isSel(o) then
						for i, s in ipairs(selected) do
							if s == o then table.remove(selected, i) break end
						end
					else
						selected[#selected + 1] = o
					end
					paintItem(b)
					commit(false)
				else
					current = o
					for _, ob in ipairs(itemButtons) do paintItem(ob) end
					commit(false)
					setOpen(false)
				end
			end)
			itemButtons[#itemButtons + 1] = b
		end
		dirty = false
	end

	local function applyFilter()
		local q = searchBox.Text:lower()
		local order = 0
		for _, b in ipairs(itemButtons) do
			local show = q == "" or b:GetAttribute("opt"):lower():find(q, 1, true) ~= nil
			b.Visible = show
			if show then
				order = order + 1
				b.LayoutOrder = order
			end
		end
	end

	local function rebuild(animate)
		if dirty then buildItems() end
		applyFilter()
		for _, b in ipairs(itemButtons) do paintItem(b) end
		if open and not animate then panel.Size = UDim2.new(1, 0, 0, panelHeight()) end
	end

	Box.Activated:Connect(function()
		if el._locked then return end
		if not open then rebuild(true) end
		setOpen(not open)
	end)
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if open then
			applyFilter()
			panel.Size = UDim2.new(1, 0, 0, panelHeight())
		end
	end)
	refreshText()
	onTheme(function()
		refreshText()
		chev.ImageColor3 = Theme.TextDim
		searchBox.PlaceholderColor3 = Theme.TextMuted
		searchBox.TextColor3 = Theme.TextTitle
		for _, b in ipairs(itemButtons) do paintItem(b) end
	end, Box)

	function el.Set(self, v, silent)
		applyValue(v)
		commit(silent)
		for _, b in ipairs(itemButtons) do paintItem(b) end
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
		dirty = true
		if open then rebuild(false) end
	end
	el.SetOptions = el.Refresh
	function el.Clear(self)
		if multi then selected = {} else current = nil end
		commit(false)
		for _, b in ipairs(itemButtons) do paintItem(b) end
	end
	return attachCommon(el, row, t, d, entry, up)
end

----------------------------------------------------------------------
-- Input
----------------------------------------------------------------------
local function addInput(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Input")
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	vlist(row, 3)
	local up = function(s) return string.upper(s) end

	local line = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), LayoutOrder = 1 }, row)
	local t = lbl(line, {
		Size = UDim2.new(0.4, -8, 1, 0), AutomaticSize = Enum.AutomaticSize.None, Font = F.Bold, TextSize = 12,
		Text = up(title), TextYAlignment = Enum.TextYAlignment.Center,
	}, "TextTitle")
	t.Visible = title ~= ""
	local hasTitle = title ~= ""
	local tb = new("TextBox", {
		Size = hasTitle and UDim2.new(0.6, 0, 0, 34) or UDim2.new(1, 0, 0, 34),
		Position = hasTitle and UDim2.new(0.4, 0, 0.5, -17) or UDim2.new(0, 0, 0.5, -17), BackgroundColor3 = Theme.SubBox, Text = "",
		PlaceholderText = tostring(opts.Placeholder or ""), PlaceholderColor3 = Theme.TextMuted, Font = F.Regular, TextSize = 12,
		TextColor3 = Theme.TextTitle, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, BorderSizePixel = 0,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, line)
	corner(tb, 8)
	local inSt = bstroke(tb, 1, 0)
	reg("SubBoxes", tb)
	padding(tb, 8, 8, 0, 0)
	local d = lbl(row, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 2 }, "TextDim")
	d.Visible = content ~= ""
	onTheme(function()
		tb.PlaceholderColor3 = Theme.TextMuted
		tb.TextColor3 = Theme.TextTitle
	end, tb)

	local el = { Type = "Input" }
	local saved = cfgGet(key, opts)
	local start = type(saved) == "string" and saved or tostring(opts.Default or "")
	tb.Text = start
	el.Value = start
	local last = start

	tb.Focused:Connect(function() Tween(inSt, 0.15, { Color = Theme.AccentLight }) end)
	tb.FocusLost:Connect(function(enter)
		Tween(inSt, 0.15, { Color = Theme.Border })
		if el._locked then tb.Text = el.Value return end
		local txt = tb.Text
		el.Value = txt
		cfgSet(key, opts, txt)
		if enter or txt ~= last then
			last = txt
			fire(opts.Callback, txt)
		end
	end)

	function el.Set(self, v, silent)
		v = tostring(v == nil and "" or v)
		tb.Text = v
		el.Value = v
		last = v
		cfgSet(key, opts, v)
		if not silent then fire(opts.Callback, v) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.ResetValue(self) el.Set(self, opts.Default or "", false) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, row, t, d, entry, up)
end

----------------------------------------------------------------------
-- Button (ActionRow da StarHubUI) e botao duplo
----------------------------------------------------------------------
local function addButton(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local el = { Type = "Button" }

	if opts.SubTitle == nil then
		local row, entry = newRow(sec, opts)
		local btn = new("TextButton", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.SubBox, Text = "",
			AutoButtonColor = false, BorderSizePixel = 0,
		}, row)
		corner(btn, 10)
		local rs = bstroke(btn, 1, 0)
		reg("SubBoxes", btn)
		padding(btn, 14, 38, 11, 11)
		vlist(btn, 2)
		local t = lbl(btn, { Font = F.Bold, TextSize = 14, Text = title, LayoutOrder = 1 }, "TextTitle")
		local d = lbl(btn, { Font = F.Regular, TextSize = 11, Text = content, LayoutOrder = 2 }, "TextDim")
		t.Visible = title ~= ""
		d.Visible = content ~= ""
		local ic = new("ImageLabel", {
			Size = UDim2.fromOffset(17, 17), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 28, 0.5, 0),
			BackgroundTransparency = 1, Image = opts.Icon or Icons.ChevronDown, ImageColor3 = Theme.AccentLight, Rotation = opts.Icon and 0 or -90,
		}, btn)
		reg("AccentLights", ic)
		btn.MouseEnter:Connect(function() Tween(rs, 0.15, { Color = Theme.BorderLight }) end)
		btn.MouseLeave:Connect(function() Tween(rs, 0.15, { Color = Theme.Border }) end)
		btn.Activated:Connect(function()
			if el._locked then return end
			PlaySound("Click")
			MicroBounce(btn)
			fire(opts.Callback)
		end)
		function el.Fire() fire(opts.Callback) end
		return attachCommon(el, row, t, d, entry)
	end

	-- botao duplo: Title / SubTitle
	local row, entry = newRow(sec, opts)
	vlist(row, 5)
	local d = lbl(row, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 1 }, "TextDim")
	d.Visible = content ~= ""
	local pair = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), LayoutOrder = 2 }, row)
	local b1 = makeBtn(pair, { Size = UDim2.new(0.5, -3, 1, 0), Position = UDim2.new(0, 0, 0, 0), Kind = "accent", Radius = 10, TextSize = 12.5 })
	local b2 = makeBtn(pair, { Size = UDim2.new(0.5, -3, 1, 0), Position = UDim2.new(0.5, 3, 0, 0), Kind = "sub", Radius = 10, TextSize = 12.5 })
	b1.setText(esc(title ~= "" and title or "Run"))
	b2.setText(esc(tostring(opts.SubTitle)))
	b1.btn.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		MicroBounce(b1.btn)
		fire(opts.Callback)
	end)
	b2.btn.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		MicroBounce(b2.btn)
		fire(opts.SubCallback)
	end)
	attachCommon(el, row, nil, d, entry)
	el.SetTitle = function(_, s) b1.setText(esc(s)) end
	el.SetSubTitle = function(_, s) b2.setText(esc(s)) end
	return el
end

----------------------------------------------------------------------
-- Paragraph / SubSection
----------------------------------------------------------------------
local function addParagraph(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	local card = new("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.SubBox, BorderSizePixel = 0,
	}, row)
	corner(card, 10)
	bstroke(card, 1, 0)
	reg("SubBoxes", card)
	padding(card, 14, 14, 11, 11)
	vlist(card, 3)
	local t = lbl(card, { Font = F.Bold, TextSize = 13, Text = title, LayoutOrder = 1 }, "TextTitle")
	local d = lbl(card, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 2 }, "TextDim")
	t.Visible = title ~= ""
	d.Visible = content ~= ""
	local el = { Type = "Paragraph" }
	return attachCommon(el, row, t, d, entry)
end

local function addSubSection(sec, name)
	local text = tostring(type(name) == "table" and (name.Title or name.Name) or name or "")
	sec._n = sec._n + 1
	local wrap = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = sec._n,
	}, sec._holder)
	local h = new("TextLabel", {
		Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Font = F.Bold,
		TextSize = 11.5, TextXAlignment = Enum.TextXAlignment.Left, Text = string.upper(text), AutomaticSize = Enum.AutomaticSize.X,
		TextColor3 = Theme.TextDim,
	}, wrap)
	regText(h, "TextDim")
	local line = new("Frame", {
		Size = UDim2.new(1, -92, 0, 1), Position = UDim2.new(0, 88, 0.5, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0,
	}, wrap)
	local g = new("UIGradient", {
		Color = ColorSequence.new(Theme.Border),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) }),
	}, line)
	onTheme(function() g.Color = ColorSequence.new(Theme.Border) end, line)
	local function relayout()
		local w = h.AbsoluteSize.X
		line.Position = UDim2.new(0, w + 8, 0.5, 0)
		line.Size = UDim2.new(1, -(w + 8), 0, 1)
	end
	h:GetPropertyChangedSignal("AbsoluteSize"):Connect(relayout)
	local el = { Type = "SubSection" }
	el.Alive = function() return not el._dead and wrap.Parent ~= nil end
	el.SetTitle = function(_, s) h.Text = string.upper(tostring(s)) end
	el.SetVisible = function(_, v) wrap.Visible = v ~= false end
	el.Destroy = function() el._dead = true wrap:Destroy() end
	return el
end

----------------------------------------------------------------------
-- Keybind / ColorPicker
----------------------------------------------------------------------
local function addKeybind(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "Keybind")
	local win = sec._win
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	local col, t, d = textBlock(row, title, content, 106)
	col.Position = UDim2.new(0, 0, 0, 2)
	local bind = makeBtn(row, {
		Size = UDim2.fromOffset(92, 32), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Kind = "sub", Radius = 8,
	})

	local el = { Type = "Keybind" }
	local saved = cfgGet(key, opts)
	local dflt = opts.Default
	if typeof(dflt) == "EnumItem" then dflt = dflt.Name end
	local name = type(saved) == "string" and saved or (type(dflt) == "string" and dflt or "None")
	local listening = false
	el.Value = name
	bind.setText(name)

	local function setKey(n, silent)
		el.Value = n
		bind.setText(n)
		cfgSet(key, opts, n)
		if not silent then fire(opts.ChangedCallback, n) end
	end
	bind.btn.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		listening = true
		bind.setText("...")
	end)
	track(win, UIS.InputBegan:Connect(function(i, gp)
		if listening then
			if i.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				if i.KeyCode == Enum.KeyCode.Escape then
					bind.setText(el.Value)
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
	return attachCommon(el, row, t, d, entry)
end

local function addColorPicker(sec, opts)
	opts = opts or {}
	local key = makeKey(sec, opts, "ColorPicker")
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	vlist(row, 5)
	local top = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1,
	}, row)
	local col, t, d = textBlock(top, title, content, 62)
	local swatch = new("TextButton", {
		Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(50, 28), AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0,
	}, top)
	corner(swatch, 8)
	bstroke(swatch, 1, 0)

	local el = { Type = "ColorPicker" }
	local start = typeof(opts.Default) == "Color3" and opts.Default or Theme.Accent
	local saved = cfgGet(key, opts)
	if type(saved) == "table" and tonumber(saved[1]) then
		start = Color3.fromRGB(saved[1], saved[2], saved[3])
	end
	local h, s, v = Color3.toHSV(start)
	el.Value = start
	swatch.BackgroundColor3 = start

	local panel = new("Frame", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, LayoutOrder = 2,
	}, row)
	vlist(panel, 2)
	local function rgbTable(c)
		return { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) }
	end
	local function setColor(final)
		local c = Color3.fromHSV(h, s, v)
		el.Value = c
		swatch.BackgroundColor3 = c
		if final then
			cfgSet(key, opts, rgbTable(c))
			fire(opts.Callback, c)
		end
	end
	local bh = makeTrack(sec, panel, { LayoutOrder = 1 })
	local bs = makeTrack(sec, panel, { LayoutOrder = 2 })
	local bv = makeTrack(sec, panel, { LayoutOrder = 3 })
	bh.set(h) bs.set(s) bv.set(v)
	bh.onChange = function(p, f) h = p setColor(f) end
	bs.onChange = function(p, f) s = p setColor(f) end
	bv.onChange = function(p, f) v = p setColor(f) end
	swatch.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		panel.Visible = not panel.Visible
	end)

	function el.Set(self, c, silent)
		if typeof(c) ~= "Color3" then return end
		h, s, v = Color3.toHSV(c)
		bh.set(h) bs.set(s) bv.set(v)
		el.Value = c
		swatch.BackgroundColor3 = c
		cfgSet(key, opts, rgbTable(c))
		if not silent then fire(opts.Callback, c) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, c) el.Set(self, c, true) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, row, t, d, entry)
end

----------------------------------------------------------------------
-- ActionList (linhas com botao, reaproveitadas por id)
----------------------------------------------------------------------
local function addActionList(sec, opts)
	opts = opts or {}
	local rowH = 56
	local visibleRows = math.max(1, tonumber(opts.VisibleRows) or 5)
	local btnW = tonumber(opts.ButtonWidth) or 72
	local title = tostring(opts.Title or "")
	local content = tostring(opts.Content or "")
	local row, entry = newRow(sec, { Title = title, Content = content })
	vlist(row, 6)
	local t = lbl(row, { Font = F.Bold, TextSize = 12.5, Text = string.upper(title), LayoutOrder = 1 }, "TextBody")
	local d = lbl(row, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 2 }, "TextDim")
	t.Visible = title ~= ""
	d.Visible = content ~= ""

	local listFrame = new("ScrollingFrame", {
		BackgroundColor3 = Theme.Box, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 40), CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Border,
		ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = 3,
	}, row)
	corner(listFrame, 10)
	bstroke(listFrame, 1, 0)
	reg("Boxes", listFrame)
	padding(listFrame, 6, 6, 6, 6)
	vlist(listFrame, 4)
	local emptyLabel = lbl(listFrame, {
		Text = tostring(opts.EmptyText or "Nothing here."), TextSize = 12.5, AutomaticSize = Enum.AutomaticSize.None,
		Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
		LayoutOrder = -1,
	}, "TextMuted")

	local records = {}
	local el = { Type = "ActionList" }

	local function buildRow(id)
		local rec = { id = id }
		local f = new("Frame", { BackgroundColor3 = Theme.SubBox, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, rowH) }, listFrame)
		corner(f, 10)
		bstroke(f, 1, 0)
		reg("SubBoxes", f)
		rec.frame = f
		local function cell(x, y, w, h, font, size, role)
			return lbl(f, {
				AutomaticSize = Enum.AutomaticSize.None, Size = w, Position = UDim2.new(x[1], x[2], 0, y), Font = font, TextSize = size,
				TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
			}, role)
		end
		rec.name = cell({ 0, 12 }, 9, UDim2.new(0.38, -10, 0, 18), 18, F.Bold, 10.5, "TextTitle")
		rec.sub = cell({ 0, 12 }, 32, UDim2.new(0.38, -10, 0, 16), 16, F.Regular, 9, "TextDim")
		rec.status = cell({ 0.4, 0 }, 9, UDim2.new(0.6, -14, 0, 18), 18, F.Medium, 10, "TextBody")
		rec.statusSub = cell({ 0.4, 0 }, 32, UDim2.new(0.6, -14, 0, 16), 16, F.Regular, 8.5, "TextDim")
		rec.btn = makeBtn(f, {
			Size = UDim2.fromOffset(btnW, 32), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Kind = "accent",
		})
		rec.btn.btn.Visible = false
		local function setter(text, color)
			if not rec.btn.btn.Parent then return end
			rec.btn.setText(esc(tostring(text)))
			rec.btn.setKind(tostring(color or "accent"):lower())
			if rec.row and tostring(text) == tostring(rec.row.button) then
				rec.override = nil
			else
				rec.override = os.clock() + 2.5
			end
		end
		rec.btn.btn.Activated:Connect(function()
			local r = rec.row
			if r and type(r.onClick) == "function" then
				PlaySound("Click")
				fire(r.onClick, r, setter)
			end
		end)
		return rec
	end

	local function setText(l, txt)
		txt = tostring(txt == nil and "" or txt)
		if l.Text ~= txt then l.Text = txt end
	end

	local function applyRow(rec, r)
		setText(rec.name, esc(r.name or ""))
		setText(rec.sub, r.sub or "")
		setText(rec.status, r.status or "")
		setText(rec.statusSub, r.statusSub or "")
		local hasBtn = type(r.button) == "string" and r.button ~= ""
		rec.btn.btn.Visible = hasBtn
		local w = hasBtn and (btnW + 18) or 10
		rec.status.Size = UDim2.new(0.6, -w, 0, 18)
		rec.statusSub.Size = UDim2.new(0.6, -w, 0, 16)
		if hasBtn and not (rec.override and os.clock() < rec.override) then
			rec.override = nil
			local kind = tostring(r.buttonColor or "accent"):lower()
			if rec.btn.kind ~= kind then rec.btn.setKind(kind) end
			rec.btn.setText(esc(r.button))
		end
	end

	function el.Update(self, rows)
		if el._dead then return end
		rows = type(rows) == "table" and rows or {}
		local seen = {}
		for i, r in ipairs(rows) do
			local id = tostring(r.id or i)
			seen[id] = true
			local rec = records[id]
			if not rec then
				rec = buildRow(id)
				records[id] = rec
			end
			rec.row = r
			rec.frame.LayoutOrder = i
			applyRow(rec, r)
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
	return attachCommon(el, row, t, d, entry)
end

----------------------------------------------------------------------
-- LiveChat
----------------------------------------------------------------------
local function addLiveChat(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or "Live Chat")
	local content = tostring(opts.Content or "")
	local row, entry = newRow(sec, { Title = title, Content = content })
	vlist(row, 6)
	local t = lbl(row, { Font = F.Bold, TextSize = 12.5, Text = string.upper(title), LayoutOrder = 1 }, "TextBody")
	local d = lbl(row, { Font = F.Regular, TextSize = 11.5, Text = content, LayoutOrder = 2 }, "TextDim")
	d.Visible = content ~= ""

	local msgs = new("ScrollingFrame", {
		BackgroundColor3 = Theme.Box, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, tonumber(opts.Height) or 260),
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Border, ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = 3,
	}, row)
	corner(msgs, 10)
	bstroke(msgs, 1, 0)
	reg("Boxes", msgs)
	padding(msgs, 8, 8, 8, 8)
	vlist(msgs, 4)

	local inputRow = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 4 }, row)
	local box = new("TextBox", {
		Size = UDim2.new(1, -74, 1, 0), BackgroundColor3 = Theme.SubBox, Text = "", PlaceholderText = "Type a message...",
		PlaceholderColor3 = Theme.TextMuted, Font = F.Regular, TextSize = 12, TextColor3 = Theme.TextTitle,
		TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, BorderSizePixel = 0,
	}, inputRow)
	corner(box, 8)
	local bs = bstroke(box, 1, 0)
	reg("SubBoxes", box)
	padding(box, 8, 8, 0, 0)
	local send = makeBtn(inputRow, {
		Size = UDim2.new(0, 66, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Kind = "accent", Radius = 8,
	})
	send.setText("Send")

	local el = { Type = "LiveChat" }
	local count = 0
	local localName = Players.LocalPlayer and (Players.LocalPlayer.DisplayName or Players.LocalPlayer.Name) or "You"

	function el.AddMessage(self, user, text, color)
		count = count + 1
		local c = typeof(color) == "Color3" and color or Theme.AccentLight
		local l = lbl(msgs, {
			Text = string.format('<font color="%s"><b>%s</b></font>  %s', hex(c), esc(user or "?"), esc(text or "")),
			TextSize = 12, LayoutOrder = count,
		}, "TextBody")
		if count > 120 then
			for _, k in ipairs(msgs:GetChildren()) do
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
		PlaySound("Click")
		local handler = opts.Callback or Library.ChatHandler
		if type(handler) == "function" then
			fire(handler, text)
		else
			el.AddMessage(el, localName, text, Theme.AccentLight)
		end
	end
	send.btn.Activated:Connect(doSend)
	box.Focused:Connect(function() Tween(bs, 0.15, { Color = Theme.AccentLight }) end)
	box.FocusLost:Connect(function(enter)
		Tween(bs, 0.15, { Color = Theme.Border })
		if enter then doSend() end
	end)
	onTheme(function()
		box.PlaceholderColor3 = Theme.TextMuted
		box.TextColor3 = Theme.TextTitle
	end, box)

	Library.LiveChat = el
	return attachCommon(el, row, t, d, entry)
end

----------------------------------------------------------------------
-- SupportCard
----------------------------------------------------------------------
local function addSupportCard(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or "Support Sena")
	local content = tostring(opts.Content or "Thanks for using Sena! Your support keeps the hub updated and bug free.")
	local row, entry = newRow(sec, { Title = title, Content = content })
	local card = new("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.SubBox, BorderSizePixel = 0,
	}, row)
	corner(card, 12)
	local cs = new("UIStroke", { Thickness = 1.4, Color = Theme.BorderLight, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, card)
	ApplyGradient(cs, Theme.Grad1, Theme.Grad2, 45)
	reg("SubBoxes", card)
	padding(card, 12, 12, 10, 12)
	vlist(card, 6)
	local t = lbl(card, { Font = F.Bold, TextSize = 13.5, Text = string.upper(title), LayoutOrder = 1 }, "TextTitle")
	local d = lbl(card, { Font = F.Regular, TextSize = 12, Text = content, LayoutOrder = 2 }, "TextDim")
	local links = opts.Links or Library.SupportLinks or {}
	for i, ln in ipairs(links) do
		local b = makeBtn(card, { Size = UDim2.new(1, 0, 0, 40), Kind = "accent", Radius = 10, LayoutOrder = 2 + i, TextSize = 13.5 })
		b.setText(esc("Copy " .. tostring(ln.Name or ln.Title or "Link")))
		b.btn.Activated:Connect(function()
			PlaySound("Click")
			MicroBounce(b.btn)
			local url = tostring(ln.Url or ln.Link or "")
			local ok = false
			if setclipboard then ok = pcall(setclipboard, url) end
			Library.Notify(Library, {
				Title = tostring(ln.Name or "Link"), Content = ok and url or "Clipboard unavailable", Icon = Icons.Copy,
				Badge = ok and "COPIED" or "INFO", Duration = 3,
			})
		end)
	end
	local el = { Type = "SupportCard" }
	return attachCommon(el, row, t, d, entry)
end

----------------------------------------------------------------------
-- Secoes (GroupBox da StarHubUI)
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Extras da aba System & Theme (iguais aos da StarHubUI)
----------------------------------------------------------------------
local Palettes = {
	{ Name = "Crimson", Col1 = Color3.fromRGB(235, 55, 75), Col2 = Color3.fromRGB(255, 110, 80) },
	{ Name = "Gold", Col1 = Color3.fromRGB(245, 158, 11), Col2 = Color3.fromRGB(251, 191, 36) },
	{ Name = "Cyan", Col1 = Color3.fromRGB(6, 182, 212), Col2 = Color3.fromRGB(139, 92, 246) },
	{ Name = "Emerald", Col1 = Color3.fromRGB(16, 185, 129), Col2 = Color3.fromRGB(52, 211, 153) },
	{ Name = "Violet", Col1 = Color3.fromRGB(124, 58, 237), Col2 = Color3.fromRGB(192, 132, 252) },
	{ Name = "Sakura", Col1 = Color3.fromRGB(244, 63, 94), Col2 = Color3.fromRGB(251, 113, 133) },
	{ Name = "Glacier", Col1 = Color3.fromRGB(2, 132, 199), Col2 = Color3.fromRGB(56, 189, 248) },
	{ Name = "Sunset", Col1 = Color3.fromRGB(234, 88, 12), Col2 = Color3.fromRGB(245, 158, 11) },
	{ Name = "Lime", Col1 = Color3.fromRGB(132, 204, 22), Col2 = Color3.fromRGB(163, 230, 53) },
	{ Name = "Stealth", Col1 = Color3.fromRGB(148, 163, 184), Col2 = Color3.fromRGB(203, 213, 225) },
}

local function addModeSelector(sec, opts)
	opts = opts or {}
	local modes = opts.Options or opts.Modes or {}
	local key = makeKey(sec, opts, "ModeSelector")
	local title = tostring(opts.Title or opts.Name or "")
	local row, entry = newRow(sec, opts)
	vlist(row, 4)
	local t = lbl(row, { Font = F.Bold, TextSize = 12, Text = string.upper(title), LayoutOrder = 1 }, "TextDim")
	t.Visible = title ~= ""
	local btnRow = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 2 }, row)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
	}, btnRow)
	local el = { Type = "ModeSelector" }
	local saved = cfgGet(key, opts)
	local active = (type(saved) == "string" and saved) or opts.Default or modes[1]
	el.Value = active
	local btns = {}
	local function refresh()
		for name, b in pairs(btns) do b.setKind(name == active and "accent" or "off") end
	end
	local n = math.max(#modes, 1)
	for i, m in ipairs(modes) do
		local b = makeBtn(btnRow, {
			Size = UDim2.new(1 / n, -((n - 1) * 6) / n, 1, 0), Kind = "off", Radius = 19, TextSize = 13.5, LayoutOrder = i,
		})
		b.setText(esc(m))
		btns[m] = b
		b.btn.Activated:Connect(function()
			if el._locked then return end
			PlaySound("Click")
			active = m
			el.Value = m
			refresh()
			cfgSet(key, opts, m)
			fire(opts.Callback, m)
		end)
	end
	refresh()
	function el.Set(self, v, silent)
		v = tostring(v)
		if not btns[v] then return end
		active = v
		el.Value = v
		refresh()
		cfgSet(key, opts, v)
		if not silent then fire(opts.Callback, v) end
	end
	el.SetValue = el.Set
	function el.LoadValue(self, v) el.Set(self, v, true) end
	function el.Get() return el.Value end
	el.GetValue = el.Get
	return attachCommon(el, row, t, nil, entry, string.upper)
end

local function addColorPalette(sec, opts)
	opts = opts or {}
	local row, entry = newRow(sec, { Title = "Quick accent palettes" })
	vlist(row, 4)
	lbl(row, { Font = F.Bold, TextSize = 12, Text = "QUICK ACCENT PALETTES (ONE-TAP)", LayoutOrder = 1 }, "TextMuted")
	local grid = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 76), LayoutOrder = 2 }, row)
	new("UIGridLayout", {
		CellSize = UDim2.new(0.2, -6, 0, 32), CellPadding = UDim2.new(0, 6, 0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
	}, grid)
	for i, pal in ipairs(Palettes) do
		local b = new("TextButton", {
			BackgroundColor3 = pal.Col1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i,
		}, grid)
		corner(b, 8)
		local st = stroke(b, WHITE, 1.2, 0.5)
		b.MouseEnter:Connect(function()
			Tween(st, 0.15, { Transparency = 0, Thickness = 1.8 })
			MicroBounce(b)
		end)
		b.MouseLeave:Connect(function() Tween(st, 0.15, { Transparency = 0.5, Thickness = 1.2 }) end)
		b.Activated:Connect(function()
			PlaySound("Click")
			MicroBounce(b)
			applyCustomColors(pal.Col1, pal.Col2)
			fire(opts.Callback, pal.Col1, pal.Col2, pal.Name)
			Library.Notify(Library, { Title = "ACCENT CHANGED", Content = "Live palette switched to: " .. pal.Name })
		end)
	end
	local el = { Type = "ColorPalette" }
	return attachCommon(el, row, nil, nil, entry)
end

local function addColorPickerRow(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or opts.Name or "")
	local row, entry = newRow(sec, opts)
	local line = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44) }, row)
	local t = lbl(line, {
		Size = UDim2.new(0.5, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.None, Font = F.Bold, TextSize = 12, Text = string.upper(title),
		TextYAlignment = Enum.TextYAlignment.Center,
	}, "TextTitle")
	local color = typeof(opts.Default) == "Color3" and opts.Default or Theme.Accent
	local swatch = new("Frame", {
		Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -112, 0.5, -9), BackgroundColor3 = color, BorderSizePixel = 0,
	}, line)
	round(swatch)
	stroke(swatch, WHITE, 1, 0.4)
	local hexLbl = new("TextLabel", {
		Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -86, 0, 0), BackgroundTransparency = 1, Font = F.Bold, TextSize = 12.5,
		TextXAlignment = Enum.TextXAlignment.Left, Text = hex(color), TextColor3 = Theme.AccentLight, RichText = false,
	}, line)
	reg("AccentLights", hexLbl)
	local palIcon = new("ImageLabel", {
		Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -16, 0.5, -8), BackgroundTransparency = 1, Image = Icons.Palette,
		ImageColor3 = Theme.TextDim,
	}, line)
	onTheme(function() palIcon.ImageColor3 = Theme.TextDim end, palIcon)
	local hit = new("TextButton", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
	}, line)

	local el = { Type = "ColorPickerRow", Value = color }
	function el.Set(self, c, silent)
		if typeof(c) ~= "Color3" then return end
		el.Value = c
		swatch.BackgroundColor3 = c
		hexLbl.Text = hex(c)
		if not silent then fire(opts.Callback, c, hex(c)) end
	end
	el.SetValue = el.Set
	function el.Get() return el.Value end
	el.GetValue = el.Get
	hit.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		sec._win:OpenColorPicker(el.Value, function(newCol, newHex)
			el.Value = newCol
			swatch.BackgroundColor3 = newCol
			hexLbl.Text = newHex
			fire(opts.Callback, newCol, newHex)
		end, title)
	end)
	return attachCommon(el, row, t, nil, entry, string.upper)
end

local function addDangerButton(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or opts.Name or "")
	local content = tostring(opts.Content or opts.Description or "")
	local row, entry = newRow(sec, opts)
	local btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Danger, Text = "",
		AutoButtonColor = false, BorderSizePixel = 0,
	}, row)
	corner(btn, 10)
	padding(btn, 38, 14, 11, 11)
	vlist(btn, 2)
	new("ImageLabel", {
		Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -22, 0.5, 0),
		BackgroundTransparency = 1, Image = opts.Icon or Icons.Skull, ImageColor3 = WHITE,
	}, btn)
	local t = lbl(btn, { Font = F.Bold, TextSize = 12.5, Text = title, LayoutOrder = 1, TextColor3 = WHITE })
	local d = lbl(btn, {
		Font = F.Regular, TextSize = 11, Text = content, LayoutOrder = 2, TextColor3 = Color3.fromRGB(255, 220, 220),
	})
	t.Visible = title ~= ""
	d.Visible = content ~= ""
	onTheme(function() btn.BackgroundColor3 = Theme.Danger end, btn)
	local el = { Type = "DangerButton" }
	btn.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		MicroBounce(btn)
		fire(opts.Callback)
	end)
	return attachCommon(el, row, t, d, entry)
end

local function addColorSliders(sec, opts)
	opts = opts or {}
	local title = tostring(opts.Title or opts.Name or "")
	local row, entry = newRow(sec, opts)
	vlist(row, 4)
	local head = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 1 }, row)
	local t = lbl(head, {
		Size = UDim2.new(1, -120, 1, 0), AutomaticSize = Enum.AutomaticSize.None, Font = F.Bold, TextSize = 12, Text = string.upper(title),
		TextYAlignment = Enum.TextYAlignment.Center,
	}, "TextTitle")
	local color = typeof(opts.Default) == "Color3" and opts.Default or Theme.Accent
	local swatch = new("TextButton", {
		Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -112, 0.5, -11), BackgroundColor3 = color, Text = "",
		AutoButtonColor = false, BorderSizePixel = 0,
	}, head)
	round(swatch)
	stroke(swatch, WHITE, 1, 0.4)
	local hexLbl = new("TextLabel", {
		Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -84, 0, 0), BackgroundTransparency = 1, Font = F.Bold, TextSize = 12.5,
		TextXAlignment = Enum.TextXAlignment.Left, Text = hex(color), TextColor3 = Theme.AccentLight, RichText = false,
	}, head)
	reg("AccentLights", hexLbl)
	local palIcon = new("ImageLabel", {
		Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -16, 0.5, -8), BackgroundTransparency = 1, Image = Icons.Palette,
		ImageColor3 = Theme.TextDim,
	}, head)
	onTheme(function() palIcon.ImageColor3 = Theme.TextDim end, palIcon)

	local ch = { math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5) }
	local names = { "R", "G", "B" }
	local tracks, vals = {}, {}
	local el = { Type = "ColorSliders", Value = color }
	local function currentColor() return Color3.fromRGB(ch[1], ch[2], ch[3]) end
	local function refresh()
		local c = currentColor()
		el.Value = c
		swatch.BackgroundColor3 = c
		hexLbl.Text = hex(c)
		tracks[1].setBar(Color3.fromRGB(0, ch[2], ch[3]), Color3.fromRGB(255, ch[2], ch[3]))
		tracks[2].setBar(Color3.fromRGB(ch[1], 0, ch[3]), Color3.fromRGB(ch[1], 255, ch[3]))
		tracks[3].setBar(Color3.fromRGB(ch[1], ch[2], 0), Color3.fromRGB(ch[1], ch[2], 255))
		for i = 1, 3 do
			tracks[i].set(ch[i] / 255)
			vals[i].Text = tostring(ch[i])
		end
	end
	for i = 1, 3 do
		local line = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 1 + i }, row)
		lbl(line, {
			Size = UDim2.new(0, 16, 1, 0), AutomaticSize = Enum.AutomaticSize.None, Font = F.Bold, TextSize = 12, Text = names[i],
			TextYAlignment = Enum.TextYAlignment.Center,
		}, "TextDim")
		tracks[i] = makeTrack(sec, line, {
			Size = UDim2.new(1, -78, 0, 30), Position = UDim2.new(0, 24, 0, 0), BarFrom = Color3.new(0, 0, 0), BarTo = Color3.new(1, 1, 1),
			TrackH = 12,
		})
		vals[i] = lbl(line, {
			Size = UDim2.new(0, 46, 1, 0), Position = UDim2.new(1, -46, 0, 0), AutomaticSize = Enum.AutomaticSize.None, Font = F.Bold,
			TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = false,
		}, "TextBody")
		tracks[i].onChange = function(p, final)
			if el._locked then return end
			ch[i] = math.floor(p * 255 + 0.5)
			refresh()
			local c = currentColor()
			fire(opts.Live, c)
			if final then fire(opts.Callback, c, hex(c)) end
		end
	end
	refresh()

	function el.Set(self, c, silent)
		if typeof(c) ~= "Color3" then return end
		ch = { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) }
		refresh()
		if not silent then fire(opts.Callback, c, hex(c)) end
	end
	el.SetValue = el.Set
	function el.Get() return el.Value end
	el.GetValue = el.Get
	swatch.Activated:Connect(function()
		if el._locked then return end
		PlaySound("Click")
		sec._win:OpenColorPicker(currentColor(), function(newCol, newHex)
			ch = { math.floor(newCol.R * 255 + 0.5), math.floor(newCol.G * 255 + 0.5), math.floor(newCol.B * 255 + 0.5) }
			refresh()
			fire(opts.Live, newCol)
			fire(opts.Callback, newCol, newHex)
		end, title)
	end)
	return attachCommon(el, row, t, nil, entry, string.upper)
end

local ADDERS = {
	AddToggle = addToggle, AddSlider = addSlider, AddDropdown = addDropdown, AddInput = addInput,
	AddButton = addButton, AddParagraph = addParagraph, AddSubSection = addSubSection, AddKeybind = addKeybind,
	AddColorPicker = addColorPicker, AddActionList = addActionList, AddLiveChat = addLiveChat,
	AddSupportCard = addSupportCard, AddModeSelector = addModeSelector, AddColorPalette = addColorPalette,
	AddColorPickerRow = addColorPickerRow, AddActionRow = addButton, AddDangerButton = addDangerButton,
	AddColorSliders = addColorSliders,
}

local function buildSection(win, tab, name, wide, badge, icon)
	local forceSide
	if wide == "Left" or wide == "Right" then
		forceSide = wide
		wide = false
	end
	wide = true -- layout em coluna unica: toda secao ocupa a largura toda
	tab._order = tab._order + 1
	local parentFrame
	local side
	if wide == true then
		parentFrame = new("Frame", {
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = tab._order,
		}, tab._page)
		tab._cols = nil
	else
		if not tab._cols then
			local cols = new("Frame", {
				Name = "Columns", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = tab._order,
			}, tab._page)
			local left = new("Frame", {
				Name = "LeftColumn", BackgroundTransparency = 1, Size = UDim2.new(0.488, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
			}, cols)
			vlist(left, 10)
			local right = new("Frame", {
				Name = "RightColumn", BackgroundTransparency = 1, Size = UDim2.new(0.488, 0, 0, 0), Position = UDim2.new(0.512, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
			}, cols)
			vlist(right, 10)
			tab._cols = { left = left, right = right, wl = 0, wr = 0 }
		end
		local c = tab._cols
		local useLeft = c.wl <= c.wr
		if forceSide == "Left" then useLeft = true elseif forceSide == "Right" then useLeft = false end
		if useLeft then
			parentFrame = c.left
			side = "l"
			c.wl = c.wl + 2
		else
			parentFrame = c.right
			side = "r"
			c.wr = c.wr + 2
		end
	end

	local hasHeader = name ~= nil and tostring(name) ~= ""
	local Card = new("Frame", {
		Name = "GroupBox_" .. tostring(name or "General"), Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Box,
		BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
	}, parentFrame)
	corner(Card, 12)
	local cs = bstroke(Card, 1, 0)
	reg("Boxes", Card)
	reg("Panels", Card)
	Card.BackgroundTransparency = Library.Settings.PanelTransparency or 0

	if hasHeader then
		local header = new("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1 }, Card)
		local bIcon = new("ImageLabel", {
			Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 12, 0.5, -7), BackgroundTransparency = 1,
			Image = icon or Icons.Logo, ImageColor3 = Theme.AccentLight,
		}, header)
		reg("AccentLights", bIcon)
		local bTitle = new("TextLabel", {
			Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 32, 0, 0), BackgroundTransparency = 1, Font = F.Bold,
			TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Text = string.upper(tostring(name)), TextTruncate = Enum.TextTruncate.AtEnd,
			TextColor3 = Theme.TextTitle, RichText = false,
		}, header)
		regText(bTitle, "TextTitle")
		if badge then
			local bb = new("TextLabel", {
				Size = UDim2.new(0, 75, 0, 18), Position = UDim2.new(1, -85, 0.5, -9), BackgroundColor3 = Theme.SubBox,
				Font = F.Bold, TextSize = 11, TextColor3 = Theme.Success, Text = string.upper(tostring(badge)), BorderSizePixel = 0,
			}, header)
			round(bb)
			reg("SubBoxes", bb)
		end
		local line = new("Frame", {
			Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0,
		}, header)
		reg("Borders", line)
		bTitle.Name = "BoxTitle"
	end

	local Container = new("Frame", {
		Name = "Container", Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, hasHeader and 42 or 0), BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, Card)
	vlist(Container, 10)
	padding(Container, 14, 14, 12, 16)

	local sec = {
		Name = name, _win = win, _tab = tab, _page = tab._page, _n = 0, _holder = Container, _card = Card,
		_path = tostring(tab.Name) .. "/" .. tostring(name or "General"),
	}
	sec._weight = function(n)
		local c = tab._cols
		if side and c and tab._cols then
			if side == "l" then c.wl = c.wl + n else c.wr = c.wr + n end
		end
	end
	for nm, fn in pairs(ADDERS) do
		sec[nm] = function(_, o) return fn(sec, o) end
	end
	sec.AddSection = function(_, n, w) return tab:AddSection(n, w) end
	sec.SetTitle = function(_, s)
		local l = Card:FindFirstChild("BoxTitle", true)
		if l then l.Text = string.upper(tostring(s)) end
	end
	sec.SetVisible = function(_, v) Card.Visible = v ~= false end
	sec.Destroy = function() Card:Destroy() end
	sec.Alive = function() return Card.Parent ~= nil end
	return sec
end

----------------------------------------------------------------------
-- Efeitos de fundo (iguais aos da StarHubUI)
----------------------------------------------------------------------
local EffectNames = {
	"Floating Bubbles", "Subtle Ambient Glow", "Matrix Cyber Rain", "Starlight Fireflies", "Fire Embers",
	"Snowfall Drift", "Off (Clean Minimal)",
}

local function buildEffects(Fx)
	local E = {}
	local rnd = math.random
	local function canvas(name)
		return new("Frame", { Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0, Visible = false }, Fx)
	end

	do -- Nebula
		local c = canvas("NebulaCanvas")
		local g1 = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.72, 0, 0.35, 0), Size = UDim2.new(0.65, 0, 0.65, 0),
			BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.96, BorderSizePixel = 0, ZIndex = 0,
		}, c)
		round(g1)
		reg("Accents", g1)
		local g2 = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.28, 0, 0.70, 0), Size = UDim2.new(0.55, 0, 0.55, 0),
			BackgroundColor3 = Theme.AccentLight, BackgroundTransparency = 0.97, BorderSizePixel = 0, ZIndex = 0,
		}, c)
		round(g2)
		reg("AccentLights", g2)
		E["Subtle Ambient Glow"] = {
			canvas = c,
			step = function(t)
				g1.BackgroundTransparency = 0.96 + math.sin(t * 1.2) * 0.015
				g2.BackgroundTransparency = 0.97 + math.cos(t * 0.9) * 0.015
			end,
		}
	end

	do -- Bubbles
		local c = canvas("BubbleCanvas")
		local items = {}
		for i = 1, 10 do
			local sz = rnd(14, 38)
			local b = new("Frame", {
				Size = UDim2.new(0, sz, 0, sz), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.AccentLight,
				BackgroundTransparency = rnd(88, 94) / 100, BorderSizePixel = 0, ZIndex = 0,
			}, c)
			local sx = rnd(4, 96) / 100
			b.Position = UDim2.new(sx, 0, rnd(5, 105) / 100, 0)
			round(b)
			local bs = new("UIStroke", {
				Color = Theme.AccentLight, Thickness = 1, Transparency = 0.82, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}, b)
			local gloss = new("Frame", {
				Size = UDim2.new(0.35, 0, 0.35, 0), Position = UDim2.new(0.2, 0, 0.15, 0), BackgroundColor3 = WHITE,
				BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = 0,
			}, b)
			round(gloss)
			reg("AccentLights", b)
			reg("AccentLights", bs)
			items[#items + 1] = {
				o = b, speed = rnd(18, 36) / 100, bx = sx, ph = math.random() * math.pi * 2, fq = rnd(12, 25) / 10, amp = rnd(8, 20) / 1000,
			}
		end
		E["Floating Bubbles"] = {
			canvas = c,
			step = function(t, dt, h)
				for _, it in ipairs(items) do
					local cur = it.o.Position
					local ny = cur.Y.Scale - (it.speed * dt / h)
					local nx = it.bx + math.sin(t * it.fq + it.ph) * it.amp
					if ny < -0.08 then
						ny = 1.05
						it.bx = rnd(4, 96) / 100
						it.o.BackgroundTransparency = rnd(88, 94) / 100
					end
					it.o.Position = UDim2.new(nx, 0, ny, 0)
				end
			end,
		}
	end

	do -- Matrix
		local c = canvas("MatrixCanvas")
		local chars = { "0", "1", "X", "Z", "7", "4", "A", "F", "9", "3", "#", "*", "+", "%", "0", "1" }
		local items = {}
		for i = 1, 12 do
			local l = new("TextLabel", {
				Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((i - 0.5) / 12, 0, rnd(0, 100) / 100, 0),
				BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 11.5, TextColor3 = Theme.AccentLight,
				TextTransparency = rnd(25, 75) / 100, Text = chars[rnd(1, #chars)], ZIndex = 0,
			}, c)
			reg("AccentLights", l)
			items[#items + 1] = { o = l, speed = rnd(14, 38) / 100, nxt = tick() + rnd(10, 40) / 100 }
		end
		E["Matrix Cyber Rain"] = {
			canvas = c,
			step = function(t, dt, h)
				for _, it in ipairs(items) do
					local cur = it.o.Position
					local ny = cur.Y.Scale + (it.speed * dt / h)
					if ny > 1.06 then
						ny = -0.06
						it.o.Text = chars[rnd(1, #chars)]
						it.o.TextTransparency = rnd(25, 75) / 100
					end
					if t >= it.nxt then
						it.o.Text = chars[rnd(1, #chars)]
						it.nxt = t + rnd(15, 50) / 100
					end
					it.o.Position = UDim2.new(cur.X.Scale, 0, ny, 0)
				end
			end,
		}
	end

	do -- Fireflies
		local c = canvas("FireflyCanvas")
		local items = {}
		for i = 1, 12 do
			local sz = rnd(5, 10)
			local bx, by = rnd(5, 95) / 100, rnd(8, 92) / 100
			local f = new("Frame", {
				Size = UDim2.new(0, sz, 0, sz), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(bx, 0, by, 0),
				BackgroundColor3 = Theme.AccentLight, BackgroundTransparency = rnd(30, 70) / 100, BorderSizePixel = 0, ZIndex = 0,
			}, c)
			round(f)
			new("UIStroke", { Color = WHITE, Thickness = 0.8, Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, f)
			reg("AccentLights", f)
			items[#items + 1] = {
				o = f, bx = bx, by = by, fx = rnd(4, 12) / 10, fy = rnd(5, 14) / 10, ax = rnd(25, 65) / 1000, ay = rnd(25, 65) / 1000,
				ph = math.random() * math.pi * 2, ps = rnd(15, 30) / 10, bt = rnd(30, 60) / 100,
			}
		end
		E["Starlight Fireflies"] = {
			canvas = c,
			step = function(t)
				for _, it in ipairs(items) do
					it.o.Position = UDim2.new(it.bx + math.sin(t * it.fx + it.ph) * it.ax, 0, it.by + math.cos(t * it.fy + it.ph) * it.ay, 0)
					it.o.BackgroundTransparency = it.bt + math.sin(t * it.ps + it.ph) * 0.22
				end
			end,
		}
	end

	do -- Embers
		local c = canvas("EmberCanvas")
		local items = {}
		for i = 1, 12 do
			local sz = rnd(4, 8)
			local sx = rnd(4, 96) / 100
			local e = new("Frame", {
				Size = UDim2.new(0, sz, 0, sz), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(sx, 0, rnd(10, 105) / 100, 0),
				BackgroundColor3 = Color3.fromRGB(255, rnd(120, 200), 50), BackgroundTransparency = rnd(30, 65) / 100, BorderSizePixel = 0, ZIndex = 0,
			}, c)
			round(e)
			items[#items + 1] = { o = e, speed = rnd(25, 55) / 100, bx = sx, fq = rnd(18, 36) / 10, amp = rnd(6, 16) / 1000, ph = math.random() * math.pi * 2 }
		end
		E["Fire Embers"] = {
			canvas = c,
			step = function(t, dt, h)
				for _, it in ipairs(items) do
					local cur = it.o.Position
					local ny = cur.Y.Scale - (it.speed * dt / h)
					local nx = it.bx + math.sin(t * it.fq + it.ph) * it.amp
					if ny < -0.06 then
						ny = 1.05
						it.bx = rnd(4, 96) / 100
						it.o.BackgroundTransparency = rnd(30, 65) / 100
					end
					it.o.Position = UDim2.new(nx, 0, ny, 0)
				end
			end,
		}
	end

	do -- Snow
		local c = canvas("SnowCanvas")
		local items = {}
		for i = 1, 14 do
			local sz = rnd(3, 7)
			local sx = rnd(2, 98) / 100
			local s = new("Frame", {
				Size = UDim2.new(0, sz, 0, sz), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(sx, 0, rnd(-5, 95) / 100, 0),
				BackgroundColor3 = Color3.fromRGB(240, 245, 255), BackgroundTransparency = rnd(35, 75) / 100, BorderSizePixel = 0, ZIndex = 0,
			}, c)
			round(s)
			items[#items + 1] = { o = s, speed = rnd(12, 28) / 100, bx = sx, fq = rnd(8, 18) / 10, amp = rnd(10, 25) / 1000, ph = math.random() * math.pi * 2 }
		end
		E["Snowfall Drift"] = {
			canvas = c,
			step = function(t, dt, h)
				for _, it in ipairs(items) do
					local cur = it.o.Position
					local ny = cur.Y.Scale + (it.speed * dt / h)
					local nx = it.bx + math.sin(t * it.fq + it.ph) * it.amp
					if ny > 1.06 then
						ny = -0.06
						it.bx = rnd(2, 98) / 100
					end
					it.o.Position = UDim2.new(nx, 0, ny, 0)
				end
			end,
		}
	end
	return E
end

----------------------------------------------------------------------
-- Drag
----------------------------------------------------------------------
local function attachDrag(win, handle, target, onTap)
	local dragging, dragStart, startPos, moved = false, nil, nil, false
	handle.InputBegan:Connect(function(inp)
		if isPress(inp) then
			dragging = true
			moved = false
			dragStart = inp.Position
			startPos = target.Position
			local c
			c = inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then
					dragging = false
					if c then c:Disconnect() end
					if not moved and onTap then onTap() end
				end
			end)
		end
	end)
	track(win, UIS.InputChanged:Connect(function(inp)
		if dragging and isMove(inp) then
			local delta = inp.Position - dragStart
			if delta.Magnitude > 6 then moved = true end
			if moved then
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end))
end

----------------------------------------------------------------------
-- Window
----------------------------------------------------------------------
function Library.Window(self, opts)
	if self ~= Library and opts == nil then opts = self end
	opts = type(opts) == "table" and opts or {}

	for _, w in ipairs(Library.Windows) do pcall(w.Destroy, w) end
	Library.Windows = {}
	resetRegistry()

	Config.setup(opts.Folder)
	Library.Settings.CurrentTheme = "NeverloseCrimson"
	Library.Settings.BaseTheme = "NeverloseCrimson"
	rebuildTheme()
	loadUiSettings()
	local S = Library.Settings

	local WinTitle = tostring(opts.Title or "Sena")
	local WinSub = tostring(opts.SubTitle or opts.Footer or "")
	local WinSize = opts.Size or UDim2.new(0, 720, 0, 485)
	local WH = WinSize.Y.Offset
	local ToggleKey = Enum.KeyCode.RightControl
	pcall(function()
		local saved = Config.get("__ui")
		local nm = (type(saved) == "table" and saved.key)
			or (typeof(opts.ToggleKey) == "EnumItem" and opts.ToggleKey.Name)
			or (opts.ToggleKey and tostring(opts.ToggleKey)) or S.ToggleKey
		local k = Enum.KeyCode[nm]
		if k then ToggleKey = k end
	end)
	S.ToggleKey = ToggleKey.Name

	local win = {
		Tabs = {}, Options = opts, _keys = {}, _conns = {}, _tabsList = {}, AllSearchableItems = {}, _dead = false,
		_minimized = false, Keybind = ToggleKey,
	}

	local gui = new("ScreenGui", {
		Name = rname(), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
	})
	protect(gui)
	gui.Parent = getParent()
	win.Gui = gui
	-- despachante unico de arraste (sliders / seletores): 2 conexoes em vez de uma por elemento
	track(win, UIS.InputChanged:Connect(function(inp)
		local a = win._active
		if a and isMove(inp) then a.onMove(inp) end
	end))
	track(win, UIS.InputEnded:Connect(function(inp)
		local a = win._active
		if a and isPress(inp) then
			win._active = nil
			a.onEnd(inp)
		end
	end))

	local root = new("Frame", {
		Name = "SenaRoot", BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5),
	}, gui)
	local Main = new("Frame", {
		Name = "MainWindow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0, 0), Size = WinSize,
		BackgroundColor3 = Theme.Background, BackgroundTransparency = S.WindowTransparency, BorderSizePixel = 0,
		ClipsDescendants = false,
	}, root)
	corner(Main, 16)
	local mainStroke = stroke(Main, Theme.Border, 1.2, 0.2)
	reg("Backgrounds", Main)
	reg("Borders", mainStroke)
	win.Main = Main
	Library._current = win
	local BgGrad = new("UIGradient", { Enabled = false }, Main)

	local winScale = new("UIScale", {}, Main)
	local function updateScale()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local vp = cam.ViewportSize
		local isTouch = UIS.TouchEnabled and not (UIS.KeyboardEnabled and UIS.MouseEnabled)
		if isTouch or vp.X < 920 or vp.Y < 560 then
			local sx = (vp.X * 0.92) / WinSize.X.Offset
			local sy = (vp.Y * 0.90) / WinSize.Y.Offset
			winScale.Scale = math.clamp(math.min(sx, sy), 0.55, 0.92)
		else
			winScale.Scale = 1
		end
	end
	updateScale()
	pcall(function()
		if workspace.CurrentCamera then
			track(win, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
		end
	end)

	-- fundo
	local Wallpaper = new("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 0,
		ImageTransparency = S.WallpaperTransparency, Image = "", Visible = false,
		ImageColor3 = Color3.fromRGB(
			math.floor(255 * (1 - S.WallpaperDimming)), math.floor(255 * (1 - S.WallpaperDimming)), math.floor(255 * (1 - S.WallpaperDimming))
		),
	}, Main)
	corner(Wallpaper, 16)
	win.Wallpaper = Wallpaper
	local Acrylic = new("Frame", {
		Name = "Acrylic", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 0,
		Visible = S.AcrylicEnabled ~= false,
	}, Main)
	corner(Acrylic, 16)
	new("UIGradient", {
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.94), NumberSequenceKeypoint.new(1, 1) }), Rotation = 45,
	}, Acrylic)
	win.Acrylic = Acrylic
	if S.CustomWallpaperId and S.CustomWallpaperId ~= "" then
		task.spawn(function()
			local res = LoadCustomImage(S.CustomWallpaperId, "")
			if res and res ~= "" and Wallpaper.Parent then
				Wallpaper.Image = res
				Wallpaper.Visible = true
			end
		end)
	end
	local Fx = new("Frame", {
		Name = "FxCanvas", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 0,
	}, Main)
	corner(Fx, 16)
	local Effects = buildEffects(Fx)
	local function setEffect(mode)
		S.BackgroundEffect = mode
		Fx.Visible = Effects[mode] ~= nil
		for name, e in pairs(Effects) do e.canvas.Visible = (name == mode) end
	end
	setEffect(S.BackgroundEffect)

	-- header
	local Header = new("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1 }, Main)
	attachDrag(win, Header, root)
	local HeaderLine = new("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0,
	}, Header)
	reg("Borders", HeaderLine)

	local Traffic = new("Frame", {
		Name = "TrafficContainer", Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1,
	}, Header)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 7),
	}, Traffic)

	local function trafficDot(col, hov, fn)
		local dot = new("TextButton", {
			Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = col, Text = "", AutoButtonColor = false, BorderSizePixel = 0,
		}, Traffic)
		round(dot)
		stroke(dot, hov, 0.5, 0.4)
		dot.MouseEnter:Connect(function() Tween(dot, 0.15, { BackgroundColor3 = hov }) end)
		dot.MouseLeave:Connect(function() Tween(dot, 0.15, { BackgroundColor3 = col }) end)
		dot.Activated:Connect(function()
			PlaySound("Click")
			MicroBounce(dot)
			fn()
		end)
		return dot
	end

	local Body -- definido abaixo
	local updateFloating
	local function minimizedOffset()
		return -((WH - 44) * winScale.Scale) / 2
	end

	local function toggleMain(show)
		if show == nil then show = not Main.Visible end
		if show then
			Main.Visible = true
			winScale.Scale = 0.8
			Main.Size = win._minimized and UDim2.new(0, WinSize.X.Offset, 0, 44) or WinSize
			Main.Position = UDim2.new(0, 0, 0, win._minimized and minimizedOffset() or 0)
			if win._minimized then
				HeaderLine.Visible = false
				Main.ClipsDescendants = true
			else
				HeaderLine.Visible = true
				Main.ClipsDescendants = false
				if Body then Body.Visible = true end
			end
			PlaySound("ToggleOn")
			Tween(winScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			task.delay(0.4, updateScale)
		else
			PlaySound("ToggleOff")
			local tw = Tween(winScale, 0.22, { Scale = 0.8 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			tw.Completed:Connect(function()
				if winScale.Scale <= 0.85 then
					Main.Visible = false
					updateScale()
				end
			end)
			task.delay(0.26, function()
				if winScale.Scale <= 0.85 and Main.Parent then
					Main.Visible = false
					updateScale()
				end
			end)
		end
		if updateFloating then pcall(updateFloating) end
	end

	trafficDot(Color3.fromRGB(255, 95, 87), Color3.fromRGB(255, 130, 120), function() toggleMain(false) end)
	trafficDot(Color3.fromRGB(254, 188, 46), Color3.fromRGB(255, 215, 80), function()
		win._minimized = not win._minimized
		PlaySound(win._minimized and "ToggleOff" or "ToggleOn")
		if win._minimized then
			if Body then Body.Visible = false end
			HeaderLine.Visible = false
			Main.ClipsDescendants = true
			Tween(Main, 0.25, {
				Size = UDim2.new(0, WinSize.X.Offset, 0, 44), Position = UDim2.new(0, 0, 0, minimizedOffset()),
			})
		else
			Main.ClipsDescendants = false
			HeaderLine.Visible = true
			Tween(Main, 0.3, { Size = WinSize, Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			task.delay(0.05, function()
				if not win._minimized and Body then Body.Visible = true end
			end)
		end
	end)
	trafficDot(Color3.fromRGB(39, 201, 63), Color3.fromRGB(75, 235, 100), function()
		Tween(root, 0.32, { Position = UDim2.fromScale(0.5, 0.5) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)

	local TitleLabel = new("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 18), BackgroundTransparency = 1, Font = F.Bold,
		TextSize = 15.5, Text = WinTitle, TextColor3 = Theme.TextTitle, RichText = false,
	}, Header)
	regText(TitleLabel, "TextTitle")
	local SubLabel = new("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 14), BackgroundTransparency = 1, Font = F.Regular,
		TextSize = 12, Text = WinSub, TextColor3 = Theme.TextDim, RichText = false,
	}, Header)
	regText(SubLabel, "TextDim")
	-- botao System & Theme no topo da janela
	local sysBtn = makeBtn(Header, {
		Size = UDim2.fromOffset(154, 30), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 82, 0.5, 0), Kind = "off",
		Radius = 15, TextSize = 13.5,
	})
	sysBtn.label.Position = UDim2.new(0, 28, 0, 0)
	sysBtn.label.Size = UDim2.new(1, -34, 1, 0)
	sysBtn.setText(esc("System & Theme"))
	local sysIcon = new("ImageLabel", {
		Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 10, 0.5, -7), BackgroundTransparency = 1, Image = Icons.Settings,
		ImageColor3 = Theme.TextDim, ZIndex = 3,
	}, sysBtn.btn)
	local function updateSysBtn()
		local on = win.ActiveTab ~= nil and win.ActiveTab._system == true
		sysBtn.setKind(on and "accent" or "off")
		sysIcon.ImageColor3 = on and WHITE or Theme.TextDim
	end
	win._updateSysBtn = updateSysBtn
	onTheme(updateSysBtn, sysBtn.btn)
	sysBtn.btn.Activated:Connect(function()
		PlaySound("TabSwitch")
		MicroBounce(sysBtn.btn)
		local sys = win._sysTab
		if not sys then return end
		if win.ActiveTab == sys then
			local back = win._prevTab
			if not back or back == sys then
				for _, tb in ipairs(win._tabsList) do
					if not tb._system then back = tb break end
				end
			end
			if back and back ~= sys then back.Select() end
		else
			sys.Select()
		end
	end)

	local function setControlsPosition(pos)
		S.ControlsPosition = pos
		if pos == "Right" then
			Traffic.Position = UDim2.new(1, -78, 0, 0)
			sysBtn.btn.AnchorPoint = Vector2.new(1, 0.5)
			sysBtn.btn.Position = UDim2.new(1, -92, 0.5, 0)
			TitleLabel.AnchorPoint = Vector2.new(0, 0)
			TitleLabel.Position = UDim2.new(0, 18, 0, 8)
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			SubLabel.AnchorPoint = Vector2.new(0, 0)
			SubLabel.Position = UDim2.new(0, 18, 0, 24)
			SubLabel.TextXAlignment = Enum.TextXAlignment.Left
		else
			Traffic.Position = UDim2.new(0, 14, 0, 0)
			sysBtn.btn.AnchorPoint = Vector2.new(0, 0.5)
			sysBtn.btn.Position = UDim2.new(0, 82, 0.5, 0)
			TitleLabel.AnchorPoint = Vector2.new(1, 0)
			TitleLabel.Position = UDim2.new(1, -18, 0, 8)
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Right
			SubLabel.AnchorPoint = Vector2.new(1, 0)
			SubLabel.Position = UDim2.new(1, -18, 0, 24)
			SubLabel.TextXAlignment = Enum.TextXAlignment.Right
		end
	end
	setControlsPosition(S.ControlsPosition)

	-- corpo
	Body = new("Frame", {
		Name = "BodyContainer", Size = UDim2.new(1, 0, 1, -44), Position = UDim2.new(0, 0, 0, 44), BackgroundTransparency = 1,
	}, Main)
	local Sidebar = new("Frame", {
		Name = "Sidebar", Size = UDim2.new(0, 175, 1, 0), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0,
	}, Body)
	corner(Sidebar, 16)
	reg("Sidebars", Sidebar)

	-- fundo da janela: cor do tema, cor solida ou degrade de ate 3 cores
	local bgListeners = {}
	win._bgListeners = bgListeners
	local function applyWindowBg()
		local mode = S.BgMode
		local c1 = hexToColor(S.BgColor1) or Color3.fromRGB(26, 16, 51)
		local c2 = hexToColor(S.BgColor2) or Color3.fromRGB(11, 27, 58)
		local c3 = hexToColor(S.BgColor3) or c2
		if mode == "Gradient" then
			Main.BackgroundColor3 = WHITE
			BgGrad.Enabled = true
			if S.BgUse3 then
				BgGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c3),
				})
			else
				BgGrad.Color = ColorSequence.new(c1, c2)
			end
			BgGrad.Rotation = S.BgAngle or 45
		elseif mode == "Solid" then
			BgGrad.Enabled = false
			Main.BackgroundColor3 = c1
		else
			BgGrad.Enabled = false
			Main.BackgroundColor3 = Theme.Background
		end
		if mode ~= "Theme" and S.GlassSidebar ~= false then
			Sidebar.BackgroundColor3 = Color3.new(0, 0, 0)
			Sidebar.BackgroundTransparency = 0.55
		else
			Sidebar.BackgroundColor3 = Theme.Sidebar
			Sidebar.BackgroundTransparency = 0
		end
		for _, f in ipairs(bgListeners) do pcall(f) end
	end
	win.ApplyWindowBg = applyWindowBg
	applyWindowBg()
	onTheme(applyWindowBg, Main)
	local SideLine = new("Frame", {
		Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Theme.Border, BorderSizePixel = 0,
	}, Sidebar)
	reg("Borders", SideLine)

	local LogoHolder = new("Frame", {
		Size = UDim2.new(1, 0, 0, 94), Position = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1,
	}, Sidebar)
	local Brand = new("TextButton", {
		Size = UDim2.new(0, 74, 0, 74), Position = UDim2.new(0.5, -37, 0.5, -37), BackgroundColor3 = Theme.Box, Text = "",
		AutoButtonColor = false, BorderSizePixel = 0,
	}, LogoHolder)
	corner(Brand, 20)
	local bsStroke = stroke(Brand, Theme.Border, 1.6, 0)
	ApplyGradient(bsStroke, Theme.Grad1, Theme.Grad2, 45)
	reg("Boxes", Brand)
	local BrandIcon = new("ImageLabel", {
		Size = UDim2.new(0, 62, 0, 62), Position = UDim2.new(0.5, -31, 0.5, -31), BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit, Image = Icons.Logo, ImageColor3 = WHITE,
	}, Brand)
	Brand.MouseEnter:Connect(function()
		Tween(Brand, 0.15, { Size = UDim2.new(0, 80, 0, 80), Position = UDim2.new(0.5, -40, 0.5, -40) })
	end)
	Brand.MouseLeave:Connect(function()
		Tween(Brand, 0.15, { Size = UDim2.new(0, 74, 0, 74), Position = UDim2.new(0.5, -37, 0.5, -37) })
	end)
	Brand.Activated:Connect(function()
		MicroBounce(Brand)
		PlaySound("Click")
	end)

	-- busca
	local SearchBox = new("Frame", {
		Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, 104), BackgroundColor3 = Theme.Box, BorderSizePixel = 0,
	}, Sidebar)
	corner(SearchBox, 9)
	bstroke(SearchBox, 1, 0)
	reg("Boxes", SearchBox)
	local sIcon = new("ImageLabel", {
		Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 8, 0.5, -6.5), BackgroundTransparency = 1, Image = Icons.Search,
		ImageColor3 = Theme.TextMuted,
	}, SearchBox)
	local SearchInput = new("TextBox", {
		Size = UDim2.new(1, -44, 1, 0), Position = UDim2.new(0, 26, 0, 0), BackgroundTransparency = 1, Font = F.Regular,
		TextSize = 13, TextColor3 = Theme.TextTitle, PlaceholderColor3 = Theme.TextMuted, PlaceholderText = "Search...",
		ClearTextOnFocus = false, Text = "", TextXAlignment = Enum.TextXAlignment.Left,
	}, SearchBox)
	local sClear = new("TextButton", {
		Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -20, 0.5, -8), BackgroundTransparency = 1, Text = "X",
		Font = F.Bold, TextSize = 11.5, TextColor3 = Theme.TextMuted, Visible = false,
	}, SearchBox)
	sClear.Activated:Connect(function()
		SearchInput.Text = ""
		sClear.Visible = false
	end)
	onTheme(function()
		sIcon.ImageColor3 = Theme.TextMuted
		SearchInput.TextColor3 = Theme.TextTitle
		SearchInput.PlaceholderColor3 = Theme.TextMuted
		sClear.TextColor3 = Theme.TextMuted
	end, SearchBox)
	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(SearchInput.Text)
		sClear.Visible = q ~= ""
		for _, item in ipairs(win.AllSearchableItems) do
			if item.Frame and item.Frame.Parent and item.SearchText then
				item.Frame.Visible = (q == "" or string.find(item.SearchText, q, 1, true) ~= nil)
			end
		end
	end)

	local NavScroll = new("ScrollingFrame", {
		Name = "NavScroll", Size = UDim2.new(1, -8, 1, -146), Position = UDim2.new(0, 4, 0, 140), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Border, AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
	}, Sidebar)
	vlist(NavScroll, 4)
	padding(NavScroll, 4, 4, 4, 12)

	local ContentArea = new("Frame", {
		Name = "ContentArea", Size = UDim2.new(1, -175, 1, 0), Position = UDim2.new(0, 175, 0, 0), BackgroundTransparency = 1,
	}, Body)

	-- botao flutuante (squircle)
	local Floating = new("Frame", {
		Name = "SenaFloating", Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 20, 0.45, 0),
		BackgroundColor3 = Color3.fromRGB(12, 13, 17), BackgroundTransparency = 0.05, BorderSizePixel = 0,
		Visible = S.ShowFloatingToggle,
	}, gui)
	round(Floating)
	local flScale = new("UIScale", { Scale = 1 }, Floating)
	local flStroke = stroke(Floating, WHITE, 3.6, 0)
	local flGrad = new("UIGradient", { Name = "ChasingRingGrad" }, flStroke)
	flGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.Grad1), ColorSequenceKeypoint.new(0.5, Theme.Grad2), ColorSequenceKeypoint.new(1, Theme.Grad1),
	})
	reg("Gradients", flGrad)
	reg("Boxes", Floating)
	local flAura = new("Frame", {
		Name = "AuraGlow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 10, 1, 10),
		BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 0,
	}, Floating)
	round(flAura)
	reg("Accents", flAura)
	task.spawn(function()
		while Floating and Floating.Parent do
			if S.LowLag then
				task.wait(1)
			else
				Tween(flAura, 1.4, { Size = UDim2.new(1, 16, 1, 16), BackgroundTransparency = 0.82 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.4)
				if not Floating or not Floating.Parent then break end
				Tween(flAura, 1.4, { Size = UDim2.new(1, 8, 1, 8), BackgroundTransparency = 0.94 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.4)
			end
		end
	end)
	local flGlow = new("Frame", {
		Name = "LogoUnderglow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 30, 0, 30),
		BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 3,
	}, Floating)
	round(flGlow)
	reg("Accents", flGlow)
	local flShadow = new("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0.5, 1, 0.5, 2), BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Fit, Image = Icons.Logo, ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 0.6, ZIndex = 5,
	}, Floating)
	local flIcon = new("ImageLabel", {
		Name = "MainLogo", AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, Image = Icons.Logo, ImageColor3 = WHITE, ZIndex = 10,
	}, Floating)
	local flIconScale = new("UIScale", {}, flIcon)
	local flBtn = new("TextButton", {
		Name = "HitboxButton", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 25,
	}, Floating)

	updateFloating = function()
		if not Floating or not Floating.Parent then return end
		if Main.Visible then
			Tween(flStroke, 0.25, { Thickness = 3.6, Transparency = 0 })
			Tween(flAura, 0.25, { BackgroundTransparency = 0.80 })
			Tween(flGlow, 0.25, { BackgroundTransparency = 0.65 })
		else
			Tween(flStroke, 0.25, { Thickness = 3.2, Transparency = 0.25 })
			Tween(flAura, 0.25, { BackgroundTransparency = 0.90 })
			Tween(flGlow, 0.25, { BackgroundTransparency = 0.85 })
		end
	end
	flBtn.MouseEnter:Connect(function()
		Tween(flScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		Tween(flStroke, 0.2, { Thickness = 4.2, Transparency = 0 })
		Tween(flAura, 0.2, { BackgroundTransparency = 0.70, Size = UDim2.new(1, 18, 1, 18) })
		Tween(flGlow, 0.2, { BackgroundTransparency = 0.55 })
	end)
	flBtn.MouseLeave:Connect(function()
		Tween(flScale, 0.2, { Scale = 1.0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		updateFloating()
	end)
	attachDrag(win, flBtn, Floating, function()
		Tween(flScale, 0.06, { Scale = 0.88 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.06, function()
			Tween(flScale, 0.22, { Scale = 1.0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		end)
		flIconScale.Scale = 0.84
		Tween(flIconScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local ripple = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 10, 0, 10),
			BackgroundColor3 = Theme.AccentLight, BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 1,
		}, Floating)
		round(ripple)
		local rt = Tween(ripple, 0.45, { Size = UDim2.new(2.4, 0, 2.4, 0), BackgroundTransparency = 1 })
		rt.Completed:Connect(function() ripple:Destroy() end)
		task.delay(0.5, function() if ripple and ripple.Parent then ripple:Destroy() end end)
		toggleMain()
	end)

	-- logo customizada (url/asset) sem travar a UI
	task.spawn(function()
		local src = S.CustomLogoUrl or opts.Logo or opts.Image
		if not src then return end
		local img = LoadCustomImage(src, Icons.Logo)
		if img and BrandIcon.Parent then
			BrandIcon.Image = img
			flIcon.Image = img
			flShadow.Image = img
		end
	end)

	-- loop de animacao (efeitos + anel girando), limitado a ~25 fps
	local acc, ringAcc = 0, 0
	track(win, RunService.RenderStepped:Connect(function(dt)
		if S.LowLag then return end
		ringAcc = ringAcc + dt
		if ringAcc >= 0.04 then
			ringAcc = 0
			if Floating.Visible and flGrad and flGrad.Parent then flGrad.Rotation = (os.clock() * 120) % 360 end
		end
		if not Main.Visible or win._minimized then return end
		acc = acc + dt
		if acc < 0.04 then return end
		local k = acc * 60
		acc = 0
		if S.BgMode == "Gradient" and S.BgAnimate then BgGrad.Rotation = ((S.BgAngle or 45) + os.clock() * 15) % 360 end
		local e = Effects[S.BackgroundEffect]
		if not e then return end
		local h = Main.AbsoluteSize.Y
		if h <= 0 then h = WH end
		e.step(os.clock(), k, h)
	end))

	-- tecla de atalho
	track(win, UIS.InputBegan:Connect(function(inp, gpe)
		if not gpe and not win._listeningKey and not win._splashActive and inp.KeyCode == win.Keybind then
			if S.KeybindMode == "Hold" then
				toggleMain(true)
			elseif S.KeybindMode ~= "Always" then
				toggleMain()
			end
		end
	end))
	track(win, UIS.InputEnded:Connect(function(inp, gpe)
		if not gpe and inp.KeyCode == win.Keybind and S.KeybindMode == "Hold" then toggleMain(false) end
	end))

	----------------------------------------------------------------
	-- Abas
	----------------------------------------------------------------
	function win.AddTab(_, o)
		o = o or {}
		local TabTitle = tostring(o.Name or o.Title or "Tab")
		win._lastBuild = os.clock()
		local BadgeText = o.Badge or o.BadgeText
		local order = o._order or (#win._tabsList + 5)

		local Page = new("ScrollingFrame", {
			Name = "Page_" .. TabTitle, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
			ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Border, AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false,
		}, ContentArea)
		padding(Page, 10, 10, 10, 20)
		vlist(Page, 10)

		local TabBtn = new("TextButton", {
			Name = "Nav_" .. TabTitle, Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Theme.SubBox, BackgroundTransparency = 0.85,
			Text = "", AutoButtonColor = false, LayoutOrder = order, BorderSizePixel = 0,
		}, NavScroll)
		corner(TabBtn, 10)
		if o._hidden then TabBtn.Visible = false end
		local tabStroke = stroke(TabBtn, Theme.Border, 1, 0.75)
		local activeGlow = new("Frame", {
			Name = "ActiveGlow", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.8,
			BorderSizePixel = 0, Visible = false,
		}, TabBtn)
		corner(activeGlow, 10)
		new("UIGradient", {
			Color = ColorSequence.new(Theme.Accent),
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.65), NumberSequenceKeypoint.new(1, 1) }),
		}, activeGlow)
		reg("Accents", activeGlow)

		local iconBadge = new("Frame", {
			Name = "IconBadge", Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 8, 0.5, -13), BackgroundColor3 = Theme.SubBox,
			BackgroundTransparency = 0.45, BorderSizePixel = 0,
		}, TabBtn)
		corner(iconBadge, 8)
		local ibStroke = stroke(iconBadge, Theme.Border, 1, 0.6)

		local iconName = tostring(o.Icon or "")
		local low = iconName:lower()
		local img = iconName:find("^rbxassetid") and iconName or (IconMap[low] or Icons.Dashboard)
		local tIcon = new("ImageLabel", {
			Name = "TabIcon", Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0.5, -7.5, 0.5, -7.5), BackgroundTransparency = 1,
			Image = img, ImageColor3 = Theme.TextDim,
		}, iconBadge)
		local function setIconColor(col, anim)
			if tIcon:IsA("ImageLabel") then
				if anim then Tween(tIcon, 0.18, { ImageColor3 = col }) else tIcon.ImageColor3 = col end
			end
		end

		local tName = new("TextLabel", {
			Name = "TabName", Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 40, 0, 0), BackgroundTransparency = 1,
			Font = F.Medium, TextSize = 14, TextColor3 = Theme.TextDim, TextXAlignment = Enum.TextXAlignment.Left,
			Text = TabTitle, TextTruncate = Enum.TextTruncate.AtEnd, RichText = false,
		}, TabBtn)
		local rightIndicator = new("ImageLabel", {
			Name = "RightIndicator", Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -16, 0.5, -6), BackgroundTransparency = 1,
			Image = Icons.ChevronDown, Rotation = -90, ImageColor3 = Theme.AccentLight, ImageTransparency = 1, Visible = false,
		}, TabBtn)
		reg("AccentLights", rightIndicator)

		if BadgeText then
			local bTag = new("Frame", {
				Name = "BadgeTag", Size = UDim2.new(0, 46, 0, 18), Position = UDim2.new(1, -52, 0.5, -9),
				BackgroundColor3 = Color3.fromRGB(15, 26, 20), BackgroundTransparency = 0.25, BorderSizePixel = 0,
			}, TabBtn)
			round(bTag)
			stroke(bTag, Theme.Success, 1, 0.5)
			local bText = new("TextLabel", {
				BackgroundTransparency = 1, Font = F.Bold, TextSize = 11, TextColor3 = Theme.Success,
				Text = tostring(BadgeText), Size = UDim2.new(1, 0, 1, 0),
			}, bTag)
			if tostring(BadgeText) == "LIVE" then
				bText.Size = UDim2.new(1, -17, 1, 0)
				bText.Position = UDim2.new(0, 16, 0, 0)
				bText.TextXAlignment = Enum.TextXAlignment.Left
				local dot = new("Frame", {
					Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 6, 0.5, -3), BackgroundColor3 = Theme.Success, BorderSizePixel = 0,
				}, bTag)
				round(dot)
				task.spawn(function()
					while bTag and bTag.Parent do
						Tween(dot, 0.5, { BackgroundTransparency = 0.85 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
						task.wait(0.5)
						if not bTag or not bTag.Parent then break end
						Tween(dot, 0.5, { BackgroundTransparency = 0 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
						task.wait(0.5)
					end
				end)
			end
		end

		local tab = { Name = TabTitle, Title = TabTitle, Page = Page, Button = TabBtn, _win = win, _page = Page, _order = 0, _cols = nil, _system = o._system }

		local function applyState(active)
			if active then
				activeGlow.Visible = true
				TabBtn.BackgroundColor3 = Theme.SubBox
				TabBtn.BackgroundTransparency = 0.15
				tabStroke.Color = Theme.Accent
				tabStroke.Transparency = 0.2
				tabStroke.Thickness = 1.2
				iconBadge.BackgroundColor3 = Theme.Accent
				iconBadge.BackgroundTransparency = 0.12
				ibStroke.Color = Theme.AccentLight
				ibStroke.Transparency = 0
				ibStroke.Thickness = 1.2
				tName.TextColor3 = Theme.TextTitle
				tName.Font = F.Bold
				setIconColor(WHITE)
				if not BadgeText then
					rightIndicator.Visible = true
					rightIndicator.ImageColor3 = Theme.AccentLight
					rightIndicator.ImageTransparency = 0.35
				end
			else
				activeGlow.Visible = false
				TabBtn.BackgroundColor3 = Theme.SubBox
				TabBtn.BackgroundTransparency = 0.85
				tabStroke.Color = Theme.Border
				tabStroke.Transparency = 0.75
				tabStroke.Thickness = 1
				iconBadge.BackgroundColor3 = Theme.SubBox
				iconBadge.BackgroundTransparency = 0.45
				ibStroke.Color = Theme.Border
				ibStroke.Transparency = 0.6
				ibStroke.Thickness = 1
				tName.TextColor3 = Theme.TextDim
				tName.Font = F.Medium
				setIconColor(Theme.TextDim)
				rightIndicator.Visible = false
				rightIndicator.ImageTransparency = 1
			end
			iconBadge.Position = UDim2.new(0, 8, 0.5, -13)
			tName.Position = UDim2.new(0, 40, 0, 0)
		end
		tab._applyState = applyState
		onTheme(function() applyState(win.ActiveTab == tab) end, TabBtn)

		TabBtn.MouseEnter:Connect(function()
			if win.ActiveTab ~= tab then
				Tween(tabStroke, 0.18, { Color = Theme.BorderLight, Transparency = 0.2, Thickness = 1.2 })
				Tween(TabBtn, 0.18, { BackgroundColor3 = Theme.SubBox, BackgroundTransparency = 0.35 })
				Tween(iconBadge, 0.18, { Position = UDim2.new(0, 11, 0.5, -13), BackgroundTransparency = 0.25 })
				Tween(ibStroke, 0.18, { Color = Theme.BorderLight, Transparency = 0.25 })
				Tween(tName, 0.18, { Position = UDim2.new(0, 44, 0, 0), TextColor3 = Theme.TextTitle })
				setIconColor(WHITE, true)
			else
				Tween(tabStroke, 0.18, { Color = Theme.AccentLight, Transparency = 0.1, Thickness = 1.4 })
				Tween(tName, 0.18, { Position = UDim2.new(0, 43, 0, 0) })
				Tween(iconBadge, 0.18, { Position = UDim2.new(0, 10, 0.5, -13) })
				if not BadgeText then
					Tween(rightIndicator, 0.18, { Position = UDim2.new(1, -14, 0.5, -6), ImageTransparency = 0.1 })
				end
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if win.ActiveTab ~= tab then
				Tween(tabStroke, 0.18, { Color = Theme.Border, Transparency = 0.75, Thickness = 1 })
				Tween(TabBtn, 0.18, { BackgroundColor3 = Theme.SubBox, BackgroundTransparency = 0.85 })
				Tween(iconBadge, 0.18, { Position = UDim2.new(0, 8, 0.5, -13), BackgroundTransparency = 0.45 })
				Tween(ibStroke, 0.18, { Color = Theme.Border, Transparency = 0.6 })
				Tween(tName, 0.18, { Position = UDim2.new(0, 40, 0, 0), TextColor3 = Theme.TextDim })
				setIconColor(Theme.TextDim, true)
			else
				Tween(tabStroke, 0.18, { Color = Theme.Accent, Transparency = 0.2, Thickness = 1.2 })
				Tween(tName, 0.18, { Position = UDim2.new(0, 40, 0, 0) })
				Tween(iconBadge, 0.18, { Position = UDim2.new(0, 8, 0.5, -13) })
				if not BadgeText then
					Tween(rightIndicator, 0.18, { Position = UDim2.new(1, -16, 0.5, -6), ImageTransparency = 0.35 })
				end
			end
		end)

		local function activate()
			if win.ActiveTab == tab then return end
			if win.ActiveTab and not win.ActiveTab._system then win._prevTab = win.ActiveTab end
			PlaySound("TabSwitch")
			MicroBounce(TabBtn)
			for _, t in ipairs(win._tabsList) do
				t.Page.Visible = false
				t._applyState(false)
			end
			win.ActiveTab = tab
			Page.Position = UDim2.new(0, 0, 0, 6)
			Page.Visible = true
			Tween(Page, 0.22, { Position = UDim2.new(0, 0, 0, 0) })
			applyState(true)
			rightIndicator.ImageTransparency = 1
			if not BadgeText then Tween(rightIndicator, 0.2, { ImageTransparency = 0.35 }) end
			if win._updateSysBtn then win._updateSysBtn() end
		end
		TabBtn.Activated:Connect(activate)
		tab.Select = activate
		tab.Activate = activate

		tab.AddSection = function(_, sname, wide, badge, icon)
			return buildSection(win, tab, sname, wide, badge, icon)
		end
		local defaultSec
		for nm in pairs(ADDERS) do
			tab[nm] = function(_, a)
				if not defaultSec then defaultSec = buildSection(win, tab, nil, false, nil, nil) end
				return defaultSec[nm](defaultSec, a)
			end
		end
		tab.SetVisible = function(_, v) TabBtn.Visible = v ~= false end

		applyState(false)
		win._tabsList[#win._tabsList + 1] = tab
		win.Tabs[#win.Tabs + 1] = tab
		if not o._system and not win._activated then
			win._activated = true
			activate()
		end
		return tab
	end

	function win.AddNavHeader(_, text, order)
		local f = new("Frame", {
			Name = "NavHeader_" .. tostring(text), Size = UDim2.new(1, -4, 0, 24), BackgroundTransparency = 1, LayoutOrder = order or 1,
		}, NavScroll)
		local h = new("TextLabel", {
			Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(0, 6, 0, 0), BackgroundTransparency = 1, Font = F.Bold,
			TextSize = 11.5, TextXAlignment = Enum.TextXAlignment.Left, Text = string.upper(tostring(text)), TextColor3 = Theme.TextDim,
		}, f)
		regText(h, "TextDim")
		local line = new("Frame", {
			Size = UDim2.new(1, -92, 0, 1), Position = UDim2.new(0, 88, 0.5, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0,
		}, f)
		local g = new("UIGradient", {
			Color = ColorSequence.new(Theme.Border),
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) }),
		}, line)
		onTheme(function() g.Color = ColorSequence.new(Theme.Border) end, line)
		return f
	end

	function win.AddForum(_, o)
		o = o or {}
		local tab = win.AddTab(win, { Name = o.Name or "Forum", Icon = o.Icon or "forum" })
		local sec = tab:AddSection(o.Section or "Forum", true)
		local posts = {}
		local savedPosts = Config.get("__forum")
		if type(savedPosts) == "table" then posts = savedPosts end

		local list
		local function rows()
			local out = {}
			for i = #posts, 1, -1 do
				local p = posts[i]
				out[#out + 1] = {
					id = tostring(i), name = tostring(p.title or ""),
					sub = string.format('%s · %s', esc(p.author or "?"), os.date("%d/%m %H:%M", p.at or 0)),
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
				local ttl, bdy = tostring(titleIn.Value or ""), tostring(bodyIn.Value or "")
				if ttl == "" or bdy == "" then
					Library.Notify(Library, { Title = "Forum", Content = "Fill the title and the content first.", Duration = 3 })
					return
				end
				posts[#posts + 1] = {
					title = ttl, body = bdy, at = os.time(), author = Players.LocalPlayer and Players.LocalPlayer.Name or "?",
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

	-- seletor de cor (modal da StarHubUI)
	local picker
	local function buildPicker()
		local m = new("Frame", {
			Name = "ColorPickerModal", Size = UDim2.new(0, 350, 0, 265), Position = UDim2.new(0.5, -175, 0.5, -132),
			BackgroundColor3 = Color3.fromRGB(24, 21, 33), BorderSizePixel = 0, Visible = false, ZIndex = 100,
			ClipsDescendants = true, Active = true,
		}, Main)
		corner(m, 14)
		stroke(m, Color3.fromRGB(62, 54, 82), 1.2, 0)
		local header = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, ZIndex = 101 }, m)
		attachDrag(win, header, m)
		local cpTitle = new("TextLabel", {
			Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Font = F.Bold,
			TextSize = 15.5, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left, Text = "Colorpicker", ZIndex = 101,
			RichText = false,
		}, header)
		local cpClose = new("TextButton", {
			Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -30, 0.5, -11), BackgroundColor3 = Color3.fromRGB(36, 32, 48),
			Text = "X", Font = F.Bold, TextSize = 12.5, TextColor3 = Color3.fromRGB(180, 175, 195), ZIndex = 102,
			AutoButtonColor = false, BorderSizePixel = 0,
		}, header)
		round(cpClose)

		local currH, currS, currV = 0, 1, 1
		local oldColor, activeColor, activeCb = WHITE, WHITE, nil
		local updating = false

		local SVBox = new("Frame", {
			Name = "SVBox", Size = UDim2.new(0, 155, 0, 125), Position = UDim2.new(0, 14, 0, 42),
			BackgroundColor3 = Color3.fromHSV(0, 1, 1), BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 101,
		}, m)
		corner(SVBox, 6)
		local whiteOv = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 102 }, SVBox)
		new("UIGradient", {
			Color = ColorSequence.new(WHITE),
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }), Rotation = 0,
		}, whiteOv)
		local blackOv = new("Frame", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 103,
		}, SVBox)
		new("UIGradient", {
			Color = ColorSequence.new(Color3.new(0, 0, 0)),
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }), Rotation = 90,
		}, blackOv)
		local SVCursor = new("Frame", {
			Size = UDim2.new(0, 11, 0, 11), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 104,
		}, SVBox)
		round(SVCursor)
		stroke(SVCursor, WHITE, 1.6, 0)

		local HueBar = new("Frame", {
			Name = "HueBar", Size = UDim2.new(0, 11, 0, 125), Position = UDim2.new(0, 178, 0, 42), BackgroundColor3 = WHITE,
			BorderSizePixel = 0, ZIndex = 101,
		}, m)
		round(HueBar)
		new("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
			}),
		}, HueBar)
		local HueKnob = new("Frame", {
			Size = UDim2.new(1, 6, 0, 6), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = WHITE, ZIndex = 104,
			BorderSizePixel = 0,
		}, HueBar)
		round(HueKnob)
		stroke(HueKnob, Color3.fromRGB(40, 36, 52), 1.2, 0)

		local inputs = new("Frame", {
			Size = UDim2.new(1, -204, 0, 125), Position = UDim2.new(0, 198, 0, 42), BackgroundTransparency = 1, ZIndex = 101,
		}, m)
		vlist(inputs, 6)
		local function makeField(labelName, order)
			local r = new("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = order, ZIndex = 101 }, inputs)
			local box = new("TextBox", {
				Size = UDim2.new(1, -44, 1, 0), BackgroundColor3 = Color3.fromRGB(36, 31, 50), TextColor3 = WHITE, Font = F.Bold,
				TextSize = 13, ClearTextOnFocus = false, ZIndex = 102, BorderSizePixel = 0, Text = "",
			}, r)
			corner(box, 6)
			stroke(box, Color3.fromRGB(56, 48, 76), 1, 0)
			new("TextLabel", {
				Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, Font = F.Medium,
				TextSize = 12, TextColor3 = Color3.fromRGB(180, 175, 195), TextXAlignment = Enum.TextXAlignment.Center,
				Text = labelName, ZIndex = 102,
			}, r)
			return box
		end
		local hexInput = makeField("Hex", 1)
		local redInput = makeField("Red", 2)
		local greenInput = makeField("Green", 3)
		local blueInput = makeField("Blue", 4)

		local swatchRow = new("Frame", {
			Size = UDim2.new(0, 175, 0, 24), Position = UDim2.new(0, 14, 0, 176), BackgroundTransparency = 1, ZIndex = 101,
		}, m)
		local oldSwatch = new("TextButton", {
			Size = UDim2.new(0.5, -4, 1, 0), BackgroundColor3 = oldColor, Text = "", AutoButtonColor = false, ZIndex = 102,
			BorderSizePixel = 0,
		}, swatchRow)
		corner(oldSwatch, 6)
		stroke(oldSwatch, Color3.fromRGB(62, 54, 82), 1, 0)
		local newSwatch = new("Frame", {
			Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0.5, 4, 0, 0), BackgroundColor3 = activeColor, ZIndex = 102,
			BorderSizePixel = 0,
		}, swatchRow)
		corner(newSwatch, 6)
		stroke(newSwatch, WHITE, 1, 0.5)

		local btnRow = new("Frame", {
			Size = UDim2.new(1, -28, 0, 32), Position = UDim2.new(0, 14, 1, -44), BackgroundTransparency = 1, ZIndex = 101,
		}, m)
		local function modalBtn(text, x, textCol)
			local b = new("TextButton", {
				Size = UDim2.new(0.5, -5, 1, 0), Position = x, BackgroundColor3 = Color3.fromRGB(38, 33, 52), Text = text,
				Font = F.Bold, TextSize = 13.5, TextColor3 = textCol, AutoButtonColor = false, ZIndex = 102, BorderSizePixel = 0,
			}, btnRow)
			corner(b, 8)
			stroke(b, Color3.fromRGB(62, 54, 82), 1, 0)
			b.MouseEnter:Connect(function() Tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(48, 42, 68) }) end)
			b.MouseLeave:Connect(function() Tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(38, 33, 52) }) end)
			return b
		end
		local doneBtn = modalBtn("Done", UDim2.new(0, 0, 0, 0), WHITE)
		local cancelBtn = modalBtn("Cancel", UDim2.new(0.5, 5, 0, 0), Color3.fromRGB(180, 175, 195))

		local function refresh(fromInputs)
			activeColor = Color3.fromHSV(currH, currS, currV)
			SVBox.BackgroundColor3 = Color3.fromHSV(currH, 1, 1)
			SVCursor.Position = UDim2.new(currS, 0, 1 - currV, 0)
			HueKnob.Position = UDim2.new(0.5, 0, currH, 0)
			newSwatch.BackgroundColor3 = activeColor
			if not fromInputs then
				updating = true
				hexInput.Text = hex(activeColor)
				redInput.Text = tostring(math.floor(activeColor.R * 255 + 0.5))
				greenInput.Text = tostring(math.floor(activeColor.G * 255 + 0.5))
				blueInput.Text = tostring(math.floor(activeColor.B * 255 + 0.5))
				updating = false
			end
		end

		local svDrag, hueDrag = false, false
		local function updateSV(x, y)
			local w, h = math.max(SVBox.AbsoluteSize.X, 1), math.max(SVBox.AbsoluteSize.Y, 1)
			currS = math.clamp((x - SVBox.AbsolutePosition.X) / w, 0, 1)
			currV = 1 - math.clamp((y - SVBox.AbsolutePosition.Y) / h, 0, 1)
			refresh(false)
		end
		local function updateHue(y)
			currH = math.clamp((y - HueBar.AbsolutePosition.Y) / math.max(HueBar.AbsoluteSize.Y, 1), 0, 1)
			refresh(false)
		end
		SVBox.InputBegan:Connect(function(i)
			if isPress(i) then
				svDrag = true
				updateSV(i.Position.X, i.Position.Y)
			end
		end)
		HueBar.InputBegan:Connect(function(i)
			if isPress(i) then
				hueDrag = true
				updateHue(i.Position.Y)
			end
		end)
		track(win, UIS.InputChanged:Connect(function(i)
			if not isMove(i) then return end
			if svDrag then updateSV(i.Position.X, i.Position.Y) elseif hueDrag then updateHue(i.Position.Y) end
		end))
		track(win, UIS.InputEnded:Connect(function(i)
			if isPress(i) then
				svDrag = false
				hueDrag = false
			end
		end))

		local function fromRgbBoxes()
			if updating then return end
			local r = math.clamp(tonumber(redInput.Text) or 0, 0, 255)
			local g = math.clamp(tonumber(greenInput.Text) or 0, 0, 255)
			local b = math.clamp(tonumber(blueInput.Text) or 0, 0, 255)
			currH, currS, currV = Color3.toHSV(Color3.fromRGB(r, g, b))
			refresh(false)
		end
		redInput.FocusLost:Connect(fromRgbBoxes)
		greenInput.FocusLost:Connect(fromRgbBoxes)
		blueInput.FocusLost:Connect(fromRgbBoxes)
		hexInput.FocusLost:Connect(function()
			if updating then return end
			local c = hexToColor(hexInput.Text)
			if c then
				currH, currS, currV = Color3.toHSV(c)
			end
			refresh(false)
		end)

		local function close() m.Visible = false end
		cpClose.Activated:Connect(function() PlaySound("Click") close() end)
		cancelBtn.Activated:Connect(function() PlaySound("Click") close() end)
		oldSwatch.Activated:Connect(function()
			currH, currS, currV = Color3.toHSV(oldColor)
			refresh(false)
		end)
		doneBtn.Activated:Connect(function()
			PlaySound("Click")
			local cb, c = activeCb, activeColor
			close()
			if cb then fire(cb, c, hex(c)) end
		end)

		return {
			open = function(color, callback, ttl)
				oldColor = typeof(color) == "Color3" and color or WHITE
				activeCb = callback
				currH, currS, currV = Color3.toHSV(oldColor)
				cpTitle.Text = ttl and tostring(ttl) or "Colorpicker"
				oldSwatch.BackgroundColor3 = oldColor
				refresh(false)
				m.Position = UDim2.new(0.5, -175, 0.5, -132)
				m.Visible = true
			end,
		}
	end
	function win.OpenColorPicker(_, color, cb, ttl)
		if not picker then picker = buildPicker() end
		picker.open(color, cb, ttl)
	end

	-- painel System & Theme (abre pelo botao no topo da janela)
	function win.AddSystemTab(_)
		local tab = win.AddTab(win, { Name = "System & Theme", Icon = "settings", _system = true, _hidden = true, _order = 9000 })
		win._sysTab = tab
		local names, keyByName = {}, {}
		for k, th in pairs(Themes) do
			names[#names + 1] = th.Name
			keyByName[th.Name] = k
		end
		table.sort(names)
		local function note(title, content, badge)
			Library.Notify(Library, { Title = title, Content = content, Badge = badge })
		end
		local p1Row, p2Row
		local function syncRows()
			if p1Row then p1Row:Set(Theme.Grad1 or Theme.Accent, true) end
			if p2Row then p2Row:Set(Theme.Grad2 or Theme.AccentLight, true) end
		end
		local modeSel, cs1, cs2, cs3, use3Tog, angleSld
		local function bgChanged()
			win.ApplyWindowBg()
			if S.ElementGradient and S.ElemGradSource == "Background" then repaintBoxes() end
			saveUiSettings()
		end
		local function forceGradientMode()
			if S.BgMode == "Theme" then
				S.BgMode = "Gradient"
				if modeSel then modeSel:Set("Gradient", true) end
			end
		end

		----------------------------------------------------------------
		-- 1) THEME & ACCENT  (tema, paletas, cores, degrade dos elementos)
		----------------------------------------------------------------
		local ThemeBox = tab:AddSection("THEME & ACCENT", nil, "PALETTE", Icons.Palette)
		ThemeBox:AddSubSection("PRESET")
		ThemeBox:AddModeSelector({
			Title = "ACCENT COLOR STYLE", Options = { "Gradient Mode", "Solid Mode" },
			Default = (S.AccentStyle == "Solid") and "Solid Mode" or "Gradient Mode", NoSave = true,
			Callback = function(choice)
				S.AccentStyle = choice:find("Solid") and "Solid" or "Gradient"
				applyThemeAll()
				note("ACCENT STYLE CHANGED", "Rendering in " .. S.AccentStyle .. " accent mode")
				saveUiSettings()
			end,
		})
		ThemeBox:AddDropdown({
			Title = "READY-MADE THEME PRESET", Options = names, MaxVisible = 6, NoSave = true,
			Default = (S.CurrentTheme == "Custom") and "Custom" or (Themes[S.CurrentTheme] or Themes.NeverloseCrimson).Name,
			Callback = function(sel)
				local k = keyByName[sel]
				if k then
					Library.SetTheme(Library, k)
					syncRows()
					note("THEME CHANGED", "Applied preset: " .. sel)
				end
			end,
		})
		ThemeBox:AddSubSection("ONE-TAP PALETTES")
		ThemeBox:AddColorPalette({ Callback = function() syncRows() end })
		ThemeBox:AddSubSection("CUSTOM ACCENT")
		p1Row = ThemeBox:AddColorPickerRow({
			Title = "PRIMARY ACCENT (COLOR 1)", Default = Theme.Grad1 or Theme.Accent,
			Callback = function(newCol, hx)
				local c2 = (S.AccentStyle == "Solid") and newCol or (Theme.Grad2 or Theme.AccentLight)
				applyCustomColors(newCol, c2)
				syncRows()
				note("PRIMARY COLOR 1 SET", "Color 1 updated to: " .. hx)
			end,
		})
		p2Row = ThemeBox:AddColorPickerRow({
			Title = "SECONDARY ACCENT (COLOR 2)", Default = Theme.Grad2 or Theme.AccentLight,
			Callback = function(newCol, hx)
				applyCustomColors(Theme.Grad1 or Theme.Accent, newCol)
				syncRows()
				note("SECONDARY COLOR 2 SET", "Color 2 updated to: " .. hx)
			end,
		})
		ThemeBox:AddSubSection("ELEMENT GRADIENT")
		ThemeBox:AddToggle({
			Title = "GRADIENT ON ELEMENTS", Content = "Tints cards, buttons and boxes with a soft gradient (optional)", NoSave = true,
			Default = S.ElementGradient == true,
			Callback = function(v)
				S.ElementGradient = v
				repaintBoxes()
				saveUiSettings()
				note("ELEMENT GRADIENT", v and "Gradient enabled on elements" or "Gradient disabled on elements", "STYLE")
			end,
		})
		ThemeBox:AddModeSelector({
			Title = "GRADIENT SOURCE", Options = { "Accent", "Background" }, Default = S.ElemGradSource or "Accent", NoSave = true,
			Callback = function(m)
				S.ElemGradSource = m
				repaintBoxes()
				saveUiSettings()
			end,
		})
		ThemeBox:AddSlider({
			Title = "GRADIENT INTENSITY", Min = 0, Max = 100, Default = math.floor((S.ElemGradAmount or 0.35) * 100 + 0.5), Suffix = "%",
			NoSave = true,
			OnDrag = function(v)
				S.ElemGradAmount = v / 100
				if S.ElementGradient then repaintBoxes() end
			end,
			Callback = function(v)
				S.ElemGradAmount = v / 100
				repaintBoxes()
				saveUiSettings()
			end,
		})

		----------------------------------------------------------------
		-- 2) WINDOW BACKGROUND  (modo, presets, cores, imagem, efeitos, transparencia)
		----------------------------------------------------------------
		local BgBox = tab:AddSection("WINDOW BACKGROUND", nil, "GRADIENT", Icons.Visuals)
		BgBox:AddSubSection("MODE & PREVIEW")
		modeSel = BgBox:AddModeSelector({
			Title = "BACKGROUND MODE", Options = { "Theme", "Solid", "Gradient" }, Default = S.BgMode or "Theme", NoSave = true,
			Callback = function(m)
				S.BgMode = m
				bgChanged()
			end,
		})
		do
			local row = newRow(BgBox, { Title = "live preview" })
			vlist(row, 4)
			lbl(row, { Font = F.Bold, TextSize = 12, Text = "LIVE PREVIEW", LayoutOrder = 1 }, "TextDim")
			local pv = new("Frame", { Size = UDim2.new(1, 0, 0, 62), BackgroundColor3 = WHITE, BorderSizePixel = 0, LayoutOrder = 2 }, row)
			corner(pv, 10)
			bstroke(pv, 1, 0)
			local pg = new("UIGradient", { Enabled = false }, pv)
			new("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = F.Bold, TextSize = 15, Text = WinTitle,
				TextColor3 = WHITE, TextStrokeTransparency = 0.7, RichText = false,
			}, pv)
			local function update()
				local mode = S.BgMode
				local c1 = hexToColor(S.BgColor1) or Color3.fromRGB(26, 16, 51)
				local c2 = hexToColor(S.BgColor2) or Color3.fromRGB(11, 27, 58)
				local c3 = hexToColor(S.BgColor3) or c2
				if mode == "Gradient" then
					pv.BackgroundColor3 = WHITE
					pg.Enabled = true
					if S.BgUse3 then
						pg.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c3),
						})
					else
						pg.Color = ColorSequence.new(c1, c2)
					end
					pg.Rotation = S.BgAngle or 45
				elseif mode == "Solid" then
					pg.Enabled = false
					pv.BackgroundColor3 = c1
				else
					pg.Enabled = false
					pv.BackgroundColor3 = Theme.Background
				end
			end
			bgListeners[#bgListeners + 1] = update
			update()
		end

		BgBox:AddSubSection("GRADIENT PRESETS")
		local function ramp(base)
			local h, sat, v = Color3.toHSV(base)
			return base, Color3.fromHSV(h, sat, v * 0.55), Color3.fromHSV(h, sat, v * 0.28)
		end
		local BgPresets = {
			{ "Midnight", Color3.fromRGB(79, 70, 229), 45 }, { "Aurora", Color3.fromRGB(45, 212, 191), 60 },
			{ "Sunset", Color3.fromRGB(249, 115, 22), 35 }, { "Ocean", Color3.fromRGB(14, 165, 233), 55 },
			{ "Emerald", Color3.fromRGB(16, 185, 129), 50 }, { "Rose", Color3.fromRGB(244, 63, 94), 40 },
			{ "Graphite", Color3.fromRGB(156, 163, 175), 90 }, { "Snow", Color3.fromRGB(232, 236, 245), 45 },
			{ "Neon", Color3.fromRGB(168, 85, 247), 45 }, { "Arctic", Color3.fromRGB(125, 211, 252), 65 },
		}
		do
			local row = newRow(BgBox, { Title = "gradient presets" })
			local grid = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 100) }, row)
			new("UIGridLayout", {
				CellSize = UDim2.new(0.2, -6, 0, 44), CellPadding = UDim2.new(0, 6, 0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder,
			}, grid)
			for i, pr in ipairs(BgPresets) do
				local c1, c2, c3 = ramp(pr[2])
				local b = new("TextButton", {
					Text = "", AutoButtonColor = false, BackgroundColor3 = WHITE, BorderSizePixel = 0, LayoutOrder = i,
				}, grid)
				corner(b, 10)
				new("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c3),
					}),
					Rotation = pr[3],
				}, b)
				local st = stroke(b, WHITE, 1.2, 0.6)
				new("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = F.Bold, TextSize = 13, Text = pr[1],
					TextColor3 = WHITE, TextStrokeTransparency = 0.5, ZIndex = 2, RichText = false,
				}, b)
				b.MouseEnter:Connect(function()
					Tween(st, 0.15, { Transparency = 0, Thickness = 1.8 })
					MicroBounce(b)
				end)
				b.MouseLeave:Connect(function() Tween(st, 0.15, { Transparency = 0.6, Thickness = 1.2 }) end)
				b.Activated:Connect(function()
					PlaySound("Click")
					S.BgMode = "Gradient"
					S.BgColor1, S.BgColor2, S.BgColor3 = hex(c1), hex(c2), hex(c3)
					S.BgUse3 = true
					S.BgAngle = pr[3]
					if cs1 then cs1:Set(c1, true) end
					if cs2 then cs2:Set(c2, true) end
					if cs3 then cs3:Set(c3, true) end
					if use3Tog then use3Tog:Set(true, true) end
					if angleSld then angleSld:Set(pr[3], true) end
					if modeSel then modeSel:Set("Gradient", true) end
					bgChanged()
					note("BACKGROUND", "Gradient preset: " .. pr[1], "BG")
				end)
			end
		end

		BgBox:AddSubSection("COLORS")
		cs1 = BgBox:AddColorSliders({
			Title = "BACKGROUND COLOR 1", Default = hexToColor(S.BgColor1) or Color3.fromRGB(26, 16, 51),
			Live = function(c)
				S.BgColor1 = hex(c)
				forceGradientMode()
				win.ApplyWindowBg()
			end,
			Callback = function(c)
				S.BgColor1 = hex(c)
				forceGradientMode()
				bgChanged()
			end,
		})
		cs2 = BgBox:AddColorSliders({
			Title = "BACKGROUND COLOR 2", Default = hexToColor(S.BgColor2) or Color3.fromRGB(11, 27, 58),
			Live = function(c)
				S.BgColor2 = hex(c)
				forceGradientMode()
				win.ApplyWindowBg()
			end,
			Callback = function(c)
				S.BgColor2 = hex(c)
				forceGradientMode()
				bgChanged()
			end,
		})
		use3Tog = BgBox:AddToggle({
			Title = "USE THIRD COLOR", Content = "Blend a third color into the end of the gradient", NoSave = true, Default = S.BgUse3 == true,
			Callback = function(v)
				S.BgUse3 = v
				forceGradientMode()
				bgChanged()
			end,
		})
		cs3 = BgBox:AddColorSliders({
			Title = "BACKGROUND COLOR 3 (OPTIONAL)", Default = hexToColor(S.BgColor3) or Color3.fromRGB(42, 15, 46),
			Live = function(c)
				S.BgColor3 = hex(c)
				forceGradientMode()
				win.ApplyWindowBg()
			end,
			Callback = function(c)
				S.BgColor3 = hex(c)
				forceGradientMode()
				bgChanged()
			end,
		})

		BgBox:AddSubSection("GRADIENT OPTIONS")
		angleSld = BgBox:AddSlider({
			Title = "GRADIENT ANGLE", Min = 0, Max = 360, Increment = 5, Default = math.floor((S.BgAngle or 45) + 0.5), Suffix = "deg",
			NoSave = true,
			OnDrag = function(v)
				S.BgAngle = v
				win.ApplyWindowBg()
			end,
			Callback = function(v)
				S.BgAngle = v
				bgChanged()
			end,
		})
		BgBox:AddToggle({
			Title = "ANIMATE GRADIENT", Content = "Slowly rotates the gradient (Gradient mode)", NoSave = true, Default = S.BgAnimate == true,
			Callback = function(v)
				S.BgAnimate = v
				if not v then win.ApplyWindowBg() end
				saveUiSettings()
			end,
		})

		BgBox:AddSubSection("IMAGE & EFFECTS")
		BgBox:AddDropdown({
			Title = "BACKGROUND EFFECT", Options = EffectNames, Default = S.BackgroundEffect or "Floating Bubbles", NoSave = true,
			MaxVisible = 7,
			Callback = function(sel)
				setEffect(sel)
				note("BACKGROUND EFFECT", "Active mode: " .. sel, "EFFECT")
				saveUiSettings()
			end,
		})
		BgBox:AddInput({
			Title = "WALLPAPER IMAGE...", Placeholder = "https://... or Decal ID", Default = S.CustomWallpaperId or "", NoSave = true,
			Callback = function(txt)
				if txt and txt ~= "" then
					task.spawn(function()
						local res = LoadCustomImage(txt, "")
						Wallpaper.Image = res
						Wallpaper.Visible = res ~= ""
					end)
					S.CustomWallpaperId = txt
					saveUiSettings()
				end
			end,
		})
		BgBox:AddSlider({
			Title = "WALLPAPER TRANSPARENCY", Min = 0, Max = 100, Default = math.floor((S.WallpaperTransparency or 0.92) * 100 + 0.5),
			Suffix = "%", NoSave = true,
			OnDrag = function(v) Wallpaper.ImageTransparency = v / 100 end,
			Callback = function(v)
				S.WallpaperTransparency = v / 100
				Wallpaper.ImageTransparency = v / 100
				saveUiSettings()
			end,
		})
		BgBox:AddSlider({
			Title = "WALLPAPER DIMMING", Min = 0, Max = 100, Default = math.floor((S.WallpaperDimming or 0.35) * 100 + 0.5),
			Suffix = "%", NoSave = true,
			Callback = function(v)
				S.WallpaperDimming = v / 100
				local f = math.floor(255 * (1 - v / 100))
				Wallpaper.ImageColor3 = Color3.fromRGB(f, f, f)
				saveUiSettings()
			end,
		})

		BgBox:AddSubSection("TRANSPARENCY & GLASS")
		BgBox:AddSlider({
			Title = "WINDOW TRANSPARENCY", Min = 0, Max = 80, Default = math.floor((S.WindowTransparency or 0) * 100 + 0.5),
			Suffix = "%", NoSave = true,
			OnDrag = function(v) Main.BackgroundTransparency = v / 100 end,
			Callback = function(v)
				S.WindowTransparency = v / 100
				Main.BackgroundTransparency = v / 100
				saveUiSettings()
			end,
		})
		local function applyPanelT(v)
			S.PanelTransparency = v / 100
			for _, f in ipairs(Reg.Panels) do
				if f and f.Parent then f.BackgroundTransparency = v / 100 end
			end
		end
		BgBox:AddSlider({
			Title = "PANEL TRANSPARENCY", Content = "Lets the background show through the cards", Min = 0, Max = 60,
			Default = math.floor((S.PanelTransparency or 0) * 100 + 0.5), Suffix = "%", NoSave = true,
			OnDrag = applyPanelT,
			Callback = function(v)
				applyPanelT(v)
				saveUiSettings()
			end,
		})
		BgBox:AddToggle({
			Title = "GLASS SIDEBAR", Content = "Translucent sidebar over a custom background", NoSave = true, Default = S.GlassSidebar ~= false,
			Callback = function(v)
				S.GlassSidebar = v
				bgChanged()
			end,
		})
		BgBox:AddToggle({
			Title = "ACRYLIC GLASS EFFECT", Content = "Enables a translucent glossy backdrop", NoSave = true, Default = S.AcrylicEnabled ~= false,
			Callback = function(v)
				S.AcrylicEnabled = v
				Acrylic.Visible = v
				saveUiSettings()
			end,
		})

		----------------------------------------------------------------
		-- 3) INTERFACE & PERFORMANCE
		----------------------------------------------------------------
		local UiBox = tab:AddSection("INTERFACE & PERFORMANCE", nil, nil, Icons.Settings)
		UiBox:AddSubSection("WINDOW")
		UiBox:AddModeSelector({
			Title = "CONTROLS ALIGNMENT", Options = { "Left (macOS)", "Right (Windows)" }, NoSave = true,
			Default = S.ControlsPosition == "Left" and "Left (macOS)" or "Right (Windows)",
			Callback = function(pos)
				local pp = pos:find("Left") and "Left" or "Right"
				setControlsPosition(pp)
				note("LAYOUT CHANGED", "Controls moved to: " .. pos)
				saveUiSettings()
			end,
		})
		UiBox:AddToggle({
			Title = "SHOW FLOATING TOGGLE BUTTON", Content = "Draggable logo button to open/close the window", NoSave = true,
			Default = S.ShowFloatingToggle,
			Callback = function(v)
				S.ShowFloatingToggle = v
				Floating.Visible = v
				saveUiSettings()
			end,
		})
		UiBox:AddToggle({
			Title = "WELCOME SCREEN", Content = "Shows the loading / Welcome screen when the script starts", NoSave = true,
			Default = S.ShowSplash ~= false,
			Callback = function(v)
				S.ShowSplash = v
				saveUiSettings()
			end,
		})
		UiBox:AddSubSection("PERFORMANCE")
		UiBox:AddToggle({
			Title = "LOW-LAG MODE", Content = "Pauses background effects and ring animation for maximum FPS", NoSave = true,
			Default = S.LowLag == true,
			Callback = function(v)
				S.LowLag = v
				saveUiSettings()
				note("LOW-LAG MODE", v and "Animations paused for max performance" or "Animations enabled", "PERF")
			end,
		})
		UiBox:AddActionRow({
			Title = "RESPONSIVE AUTO-SCALE", Content = "Locked for PC (100%) & Auto-Fit for Mobile", Icon = Icons.Zap,
			Callback = function()
				updateScale()
				note("RESPONSIVE SCALE", "Display scale re-synchronized!", "SYSTEM")
			end,
		})
		UiBox:AddSubSection("BRANDING")
		UiBox:AddInput({
			Title = "CUSTOM LOGO...", Placeholder = "https://... or Decal ID", Default = S.CustomLogoUrl or "", NoSave = true,
			Callback = function(txt)
				if txt and txt ~= "" then
					task.spawn(function()
						local res = LoadCustomImage(txt, Icons.Logo)
						BrandIcon.Image = res
						flIcon.Image = res
						flShadow.Image = res
					end)
					S.CustomLogoUrl = txt
					saveUiSettings()
				end
			end,
		})
		UiBox:AddSubSection("TOOLS")
		UiBox:AddActionRow({
			Title = "TEST NOTIFICATION", Content = "Send sample breakout notification", Icon = Icons.Bell,
			Callback = function()
				Library.Notify(Library, {
					Title = "NOTIFICATION TEST", Content = "Breakout notification modal verified & active!", Duration = 3.5,
					Badge = "VERIFIED", BadgeColor = Color3.fromRGB(34, 197, 94), Icon = Icons.Bell,
				})
			end,
		})

		----------------------------------------------------------------
		-- 4) SOUND & SYSTEM
		----------------------------------------------------------------
		local SysBox = tab:AddSection("SOUND & SYSTEM", nil, nil, Icons.Zap)
		SysBox:AddSubSection("AUDIO")
		SysBox:AddToggle({
			Title = "UI SOUND EFFECTS", Content = "Interactive bubble audio on clicks and switches", NoSave = true, Default = S.SoundEnabled,
			Callback = function(v)
				S.SoundEnabled = v
				if v then PlaySound("ToggleOn") end
				saveUiSettings()
			end,
		})
		SysBox:AddSlider({
			Title = "SOUND VOLUME", Min = 0, Max = 100, Default = math.floor((S.SoundVolume or 0.55) * 100 + 0.5), Suffix = "%",
			NoSave = true,
			Callback = function(v)
				S.SoundVolume = v / 100
				saveUiSettings()
			end,
		})
		SysBox:AddActionRow({
			Title = "TEST BUBBLE SOUND", Content = "Play the bubble audio sequence", Icon = Icons.Bell,
			Callback = function()
				PlaySound("ToggleOn")
				task.delay(0.16, function() PlaySound("Click") end)
				task.delay(0.32, function() PlaySound("Notify") end)
			end,
		})
		SysBox:AddSubSection("CONFIG")
		SysBox:AddToggle({
			Title = "REAL-TIME AUTO SAVE", Content = "Automatically saves the UI preferences to disk", NoSave = true,
			Default = S.AutoSaveEnabled ~= false,
			Callback = function(v)
				S.AutoSaveEnabled = v
				if v then
					saveUiSettings(true)
					note("AUTO SAVE ENABLED", "Real-time configuration auto-saving active!", "CONFIG")
				else
					note("AUTO SAVE PAUSED", "Auto-save disabled. Use the manual save button.", "CONFIG")
				end
			end,
		})
		SysBox:AddModeSelector({
			Title = "KEYBIND MODE", Options = { "Toggle", "Hold", "Always" }, Default = S.KeybindMode or "Toggle", NoSave = true,
			Callback = function(mode)
				S.KeybindMode = mode
				note("KEYBIND MODE", "Mode active: " .. mode)
				saveUiSettings()
			end,
		})
		local kRow = newRow(SysBox, { Title = "toggle key" })
		local kBtn = new("TextButton", {
			Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.SubBox, Text = "TOGGLE KEY: " .. win.Keybind.Name, Font = F.Bold,
			TextSize = 13, TextColor3 = Theme.AccentLight, AutoButtonColor = false, BorderSizePixel = 0,
		}, kRow)
		corner(kBtn, 10)
		bstroke(kBtn, 1, 0)
		reg("SubBoxes", kBtn)
		reg("AccentLights", kBtn)
		kBtn.Activated:Connect(function()
			if win._listeningKey then return end
			win._listeningKey = true
			PlaySound("Click")
			kBtn.Text = "PRESS ANY KEY..."
			kBtn.TextColor3 = Theme.TextTitle
			local conn
			conn = UIS.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.Keyboard then
					conn:Disconnect()
					win._listeningKey = false
					if inp.KeyCode ~= Enum.KeyCode.Escape then
						win.Keybind = inp.KeyCode
						S.ToggleKey = inp.KeyCode.Name
						note("KEYBIND UPDATED", "Hub bind set to: " .. inp.KeyCode.Name)
						saveUiSettings()
					end
					kBtn.Text = "TOGGLE KEY: " .. win.Keybind.Name
					kBtn.TextColor3 = Theme.AccentLight
				end
			end)
		end)
		SysBox:AddActionRow({
			Title = "Save UI Settings", Content = "Manually writes the UI configuration to disk", Icon = Icons.Save,
			Callback = function()
				saveUiSettings(true)
				Library.Notify(Library, { Title = "CONFIG SAVED", Content = "Preferences saved!", Badge = "SAVED", Icon = Icons.Save })
			end,
		})
		SysBox:AddActionRow({
			Title = "Reset All Settings", Content = "Deletes the saved UI settings and restores defaults", Icon = Icons.Refresh,
			Callback = function()
				Config.set("__ui", nil)
				note("RESET DEFAULTS", "Saved UI settings deleted! Reopen the UI to apply defaults.", "RESET")
			end,
		})
		SysBox:AddSubSection("DANGER ZONE")
		SysBox:AddDangerButton({
			Title = "Unload Script Hub", Content = "Completely unloads the hub and its UI", Icon = Icons.Skull,
			Callback = function()
				if type(Library.OnUnload) == "function" then fire(Library.OnUnload) end
				pcall(function()
					if type(genv.__SenaV4HubShutdown) == "function" then genv.__SenaV4HubShutdown() end
				end)
				Tween(Main, 0.22, { Size = UDim2.new(0, 0, 0, 0) })
				task.delay(0.25, function() win.Destroy(win) end)
			end,
		})
		return tab
	end
	win.AddSettingsTab = win.AddSystemTab

	-- tela de load: animacao + "Welcome to <nome>" + botao Continue
	local function buildSplash()
		local sg = new("ScreenGui", {
			Name = rname(), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1002,
			IgnoreGuiInset = true,
		})
		protect(sg)
		sg.Parent = getParent()
		win._splashGui = sg
		win._splashActive = true
		Main.Visible = false
		Floating.Visible = false

		local scriptName = tostring(opts.LoadingTitle or opts.ScriptName or WinTitle)
		scriptName = scriptName:gsub("%s*[|%-:]+%s*$", "")
		if scriptName == "" then scriptName = WinTitle end

		local dim = new("Frame", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
			Active = true,
		}, sg)
		Tween(dim, 0.4, { BackgroundTransparency = 0.3 }, Enum.EasingStyle.Quad)
		local root = new("Frame", {
			BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5),
		}, sg)
		local card = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(440, 310), BackgroundColor3 = Theme.Box, BorderSizePixel = 0,
		}, root)
		corner(card, 22)
		local cardStroke = stroke(card, WHITE, 2, 0)
		ApplyGradient(cardStroke, Theme.Grad1, Theme.Grad2, 45)
		local top = new("Frame", {
			Size = UDim2.new(1, 0, 0, 140), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
		}, card)
		corner(top, 22)
		new("UIGradient", {
			Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.82), NumberSequenceKeypoint.new(1, 1) }),
		}, top)
		local cScale = new("UIScale", { Scale = 0.8 }, card)
		local function fitScale()
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
			return math.clamp(math.min((vp.X * 0.92) / 440, (vp.Y * 0.88) / 310, 1.15), 0.5, 1.15)
		end
		local base = fitScale()
		Tween(cScale, 0.5, { Scale = base }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		-- logo com anel girando e brilho pulsante
		local ringHolder = new("Frame", {
			Size = UDim2.fromOffset(92, 92), Position = UDim2.new(0.5, -46, 0, 22), BackgroundTransparency = 1,
		}, card)
		local glow = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.fromOffset(104, 104),
			BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.88, BorderSizePixel = 0,
		}, ringHolder)
		round(glow)
		local disc = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Theme.SubBox, BorderSizePixel = 0 }, ringHolder)
		round(disc)
		local ring = stroke(disc, WHITE, 3.5, 0)
		local ringGrad = new("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Theme.Grad1), ColorSequenceKeypoint.new(0.5, Theme.Grad2), ColorSequenceKeypoint.new(1, Theme.Grad1),
			}),
		}, ring)
		local logoImg = new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.fromOffset(54, 54),
			BackgroundTransparency = 1, Image = Icons.Logo, ImageColor3 = WHITE, ScaleType = Enum.ScaleType.Fit,
		}, disc)
		task.spawn(function()
			local src = S.CustomLogoUrl or opts.Logo or opts.Image
			if src then
				local img = LoadCustomImage(src, Icons.Logo)
				if logoImg.Parent then logoImg.Image = img end
			end
		end)
		task.spawn(function()
			while sg.Parent do
				Tween(glow, 1.2, { Size = UDim2.fromOffset(118, 118), BackgroundTransparency = 0.8 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.2)
				if not sg.Parent then break end
				Tween(glow, 1.2, { Size = UDim2.fromOffset(104, 104), BackgroundTransparency = 0.9 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.2)
			end
		end)
		local spin
		spin = RunService.RenderStepped:Connect(function()
			if sg.Parent then
				ringGrad.Rotation = (os.clock() * 200) % 360
			elseif spin then
				spin:Disconnect()
			end
		end)
		track(win, spin)

		-- textos
		local title = new("TextLabel", {
			Size = UDim2.new(1, -40, 0, 38), Position = UDim2.new(0, 20, 0, 124), BackgroundTransparency = 1, Font = F.Bold, TextSize = 26,
			TextColor3 = Theme.TextTitle, RichText = true, TextScaled = true,
			Text = 'Welcome to <font color="' .. hex(Theme.AccentLight) .. '">' .. esc(scriptName) .. '</font>',
		}, card)
		new("UITextSizeConstraint", { MaxTextSize = 26, MinTextSize = 14 }, title)
		local sub = new("TextLabel", {
			Size = UDim2.new(1, -40, 0, 22), Position = UDim2.new(0, 20, 0, 164), BackgroundTransparency = 1, Font = F.Medium, TextSize = 15,
			TextColor3 = Theme.TextDim, RichText = false, Text = tostring(opts.Footer or opts.SubTitle or ""),
		}, card)

		-- barra de progresso
		local track_ = new("Frame", {
			Size = UDim2.new(1, -80, 0, 8), Position = UDim2.new(0, 40, 0, 204), BackgroundColor3 = Theme.SubBox, BorderSizePixel = 0,
			ClipsDescendants = true,
		}, card)
		round(track_)
		local fill = new("Frame", {
			Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.new(-0.35, 0, 0, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0,
		}, track_)
		round(fill)
		ApplyGradient(fill, Theme.Grad1, Theme.Grad2, 0)
		local status = new("TextLabel", {
			Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 20, 0, 216), BackgroundTransparency = 1, Font = F.Medium, TextSize = 14,
			TextColor3 = Theme.TextDim, RichText = false, Text = "Loading interface",
		}, card)

		-- botao Continue
		local btn = makeBtn(card, {
			Size = UDim2.fromOffset(240, 46), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -22), Kind = "dim",
			Radius = 14, TextSize = 17,
		})
		btn.setText("Loading...")

		local ready = false
		task.spawn(function()
			local dots = 0
			while sg.Parent and not ready do
				dots = (dots % 3) + 1
				status.Text = "Loading interface" .. string.rep(".", dots)
				task.wait(0.4)
			end
		end)
		task.spawn(function()
			while sg.Parent and not ready do
				fill.Position = UDim2.new(-0.35, 0, 0, 0)
				Tween(fill, 0.9, { Position = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(0.95)
			end
		end)
		local startT = os.clock()
		task.spawn(function()
			while sg.Parent do
				local el = os.clock() - startT
				if (el >= 1.8 and os.clock() - (win._lastBuild or 0) >= 0.7) or el >= 15 then break end
				task.wait(0.15)
			end
			if not sg.Parent then return end
			ready = true
			fill.Position = UDim2.new(0, 0, 0, 0)
			Tween(fill, 0.4, { Size = UDim2.new(1, 0, 1, 0) })
			status.Text = "Ready to launch"
			status.TextColor3 = Theme.Success
			btn.setKind("accent")
			btn.setText("Continue")
			MicroBounce(btn.btn)
			PlaySound("Notify")
		end)

		local closing = false
		btn.btn.Activated:Connect(function()
			if not ready or closing then return end
			closing = true
			PlaySound("Click")
			MicroBounce(btn.btn)
			Tween(cScale, 0.3, { Scale = base * 0.9 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			Tween(dim, 0.3, { BackgroundTransparency = 1 })
			win._splashActive = false
			Floating.Visible = S.ShowFloatingToggle
			toggleMain(true)
			task.delay(0.35, function()
				if sg.Parent then sg:Destroy() end
				win._splashGui = nil
			end)
		end)
	end

	function win.SetEffect(_, mode)
		if Effects[mode] or mode == "Off (Clean Minimal)" then
			setEffect(mode)
			saveUiSettings()
		end
	end
	function win.Toggle(_, v) toggleMain(v) end
	win.SetVisible = win.Toggle
	function win.SelectTab(_, t)
		if type(t) == "table" and t.Select then t.Select() end
	end
	function win.Notify(_, o) Library.Notify(Library, o) end
	function win.Alive() return not win._dead and gui.Parent ~= nil end
	function win.Destroy(self)
		if win._dead then return end
		win._dead = true
		for _, c in ipairs(win._conns) do pcall(function() c:Disconnect() end) end
		win._conns = {}
		pcall(function() gui:Destroy() end)
		if win._splashGui then pcall(function() win._splashGui:Destroy() end) end
		for i, w in ipairs(Library.Windows) do
			if w == win then table.remove(Library.Windows, i) break end
		end
		if Library._current == win then Library._current = nil end
		if type(Library.OnDestroy) == "function" then fire(Library.OnDestroy) end
	end
	win.DestroyGui = win.Destroy
	win.Close = win.Destroy

	Library.Windows[#Library.Windows + 1] = win
	if opts.LoadingScreen ~= false and S.ShowSplash ~= false then
		local okS, errS = pcall(buildSplash)
		if not okS then
			warn("[SenaLib] Welcome screen error: " .. tostring(errS))
			win._splashActive = false
			Main.Visible = true
			Floating.Visible = S.ShowFloatingToggle
		end
	end
	if opts.SystemTab ~= false then
		local ok, err = pcall(win.AddSystemTab, win)
		if not ok then warn("[SenaLib] System & Theme tab error: " .. tostring(err)) end
	end
	task.delay(2, function()
		if not win._dead and not win.ActiveTab and win._tabsList[1] then win._tabsList[1].Select() end
	end)
	return win
end

----------------------------------------------------------------------
-- API global
----------------------------------------------------------------------
function Library.SetTheme(a, b)
	local name = (a == Library) and b or a
	if type(name) ~= "string" or not Themes[name] then return end
	Library.Settings.CurrentTheme = name
	Library.Settings.BaseTheme = name
	rebuildTheme()
	applyThemeAll()
	saveUiSettings()
end

function Library.SetCustomColors(a, b, c)
	local c1, c2 = b, c
	if a ~= Library then c1, c2 = a, b end
	if typeof(c1) == "Color3" and typeof(c2) == "Color3" then applyCustomColors(c1, c2) end
end

function Library.SetAccentStyle(a, b)
	local v = (a == Library) and b or a
	if v ~= "Gradient" and v ~= "Solid" then return end
	Library.Settings.AccentStyle = v
	applyThemeAll()
	saveUiSettings()
end

function Library.DestroyGui(self)
	for _, w in ipairs(Library.Windows) do pcall(w.Destroy, w) end
	Library.Windows = {}
	if activeNotif then pcall(function() activeNotif:Destroy() end) end
	activeNotif = nil
	if notifHost then pcall(function() notifHost:Destroy() end) end
	notifHost = nil
	Library._current = nil
end

return Library
