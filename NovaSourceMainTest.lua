--[[\
	NovaUI - Modern & Advanced UI Library
	Inspired by Rayfield & Fluent
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local ProtectGui = protectgui or (syn and syn.protect_gui)
local ParentGui = CoreGui
pcall(function()
	if ProtectGui then
		local screen = Instance.new("ScreenGui")
		ProtectGui(screen)
		ParentGui = screen.Parent
		screen:Destroy()
	end
end)

local NovaUI = {}

function NovaUI:CreateWindow(Settings)
	Settings = Settings or {}
	local WindowName = Settings.Name or "NovaUI Hub"
	local LoadingTitle = Settings.LoadingTitle or "NovaUI"
	local LoadingSubtitle = Settings.LoadingSubtitle or "Cargando interfaz..."
	local KeySystem = Settings.KeySystem or false
	local KeySettings = Settings.KeySettings or {}
	local RGBBorders = Settings.RGBBorders or false
	local UseAnimations = Settings.Animations ~= false -- Por defecto true
	local UserProfileSettings = Settings.UserProfile or { Enabled = false }
	local WatermarkSettings = Settings.Watermark or { Enabled = false }

	-- 1. Sistema de Keys
	local KeyPassed = false
	if KeySystem then
		local KeyGui = Instance.new("ScreenGui")
		KeyGui.Name = "NovaKeySystem"
		KeyGui.Parent = ParentGui
		KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local KeyMain = Instance.new("Frame")
		KeyMain.Size = UDim2.new(0, 380, 0, 220)
		KeyMain.Position = UDim2.new(0.5, -190, 0.5, -110)
		KeyMain.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		KeyMain.BorderSizePixel = 0
		KeyMain.Parent = KeyGui

		local KeyCorner = Instance.new("UICorner")
		KeyCorner.CornerRadius = UDim.new(0, 8)
		KeyCorner.Parent = KeyMain

		local KeyStroke = Instance.new("UIStroke")
		KeyStroke.Color = Color3.fromRGB(45, 45, 55)
		KeyStroke.Thickness = 1
		KeyStroke.Parent = KeyMain

		local Title = Instance.new("TextLabel")
		Title.Size = UDim2.new(1, 0, 0, 40)
		Title.Position = UDim2.new(0, 0, 0, 10)
		Title.BackgroundTransparency = 1
		Title.Font = Enum.Font.GothamBold
		Title.Text = KeySettings.Title or "Sistema de Keys"
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 18
		Title.Parent = KeyMain

		local Subtitle = Instance.new("TextLabel")
		Subtitle.Size = UDim2.new(1, -20, 0, 30)
		Subtitle.Position = UDim2.new(0, 10, 0, 45)
		Subtitle.BackgroundTransparency = 1
		Subtitle.Font = Enum.Font.Gotham
		Subtitle.Text = KeySettings.Subtitle or "Introduce tu key para continuar."
		Subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
		Subtitle.TextSize = 13
		Subtitle.TextWrapped = true
		Subtitle.Parent = KeyMain

		local TextBox = Instance.new("TextBox")
		TextBox.Size = UDim2.new(1, -40, 0, 40)
		TextBox.Position = UDim2.new(0, 20, 0, 90)
		TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
		TextBox.BorderSizePixel = 0
		TextBox.Font = Enum.Font.Gotham
		TextBox.PlaceholderText = "Escribe tu key aquí..."
		TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 14
		TextBox.Parent = KeyMain

		local BoxCorner = Instance.new("UICorner")
		BoxCorner.CornerRadius = UDim.new(0, 6)
		BoxCorner.Parent = TextBox

		local SubmitBtn = Instance.new("TextButton")
		SubmitBtn.Size = UDim2.new(1, -40, 0, 38)
		SubmitBtn.Position = UDim2.new(0, 20, 0, 145)
		SubmitBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		SubmitBtn.BorderSizePixel = 0
		SubmitBtn.Font = Enum.Font.GothamBold
		SubmitBtn.Text = "Verificar Key"
		SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		SubmitBtn.TextSize = 14
		SubmitBtn.Parent = KeyMain

		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = SubmitBtn

		SubmitBtn.MouseButton1Click:Connect(function()
			local keyInput = TextBox.Text
			local valid = false
			if type(KeySettings.Key) == "table" then
				for _, k in pairs(KeySettings.Key) do
					if k == keyInput then valid = true break end
				end
			else
				if KeySettings.Key == keyInput then valid = true end
			end

			if valid then
				KeyPassed = true
				KeyGui:Destroy()
			else
				SubmitBtn.Text = "Key Incorrecta!"
				task.wait(1.5)
				SubmitBtn.Text = "Verificar Key"
			end
		end)

		repeat task.wait() until KeyPassed
	end

	-- 2. Pantalla de Carga (2.5 segundos)
	local LoadGui = Instance.new("ScreenGui")
	LoadGui.Name = "NovaLoading"
	LoadGui.Parent = ParentGui
	LoadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local LoadMain = Instance.new("Frame")
	LoadMain.Size = UDim2.new(0, 320, 0, 130)
	LoadMain.Position = UDim2.new(0.5, -160, 0.5, -65)
	LoadMain.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	LoadMain.BorderSizePixel = 0
	LoadMain.Parent = LoadGui

	local LoadCorner = Instance.new("UICorner")
	LoadCorner.CornerRadius = UDim.new(0, 8)
	LoadCorner.Parent = LoadMain

	local LoadTitle = Instance.new("TextLabel")
	LoadTitle.Size = UDim2.new(1, 0, 0, 30)
	LoadTitle.Position = UDim2.new(0, 0, 0, 15)
	LoadTitle.BackgroundTransparency = 1
	LoadTitle.Font = Enum.Font.GothamBold
	LoadTitle.Text = LoadingTitle
	LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	LoadTitle.TextSize = 18
	LoadTitle.Parent = LoadMain

	local LoadSub = Instance.new("TextLabel")
	LoadSub.Size = UDim2.new(1, 0, 0, 20)
	LoadSub.Position = UDim2.new(0, 0, 0, 45)
	LoadSub.BackgroundTransparency = 1
	LoadSub.Font = Enum.Font.Gotham
	LoadSub.Text = LoadingSubtitle
	LoadSub.TextColor3 = Color3.fromRGB(150, 150, 160)
	LoadSub.TextSize = 12
	LoadSub.Parent = LoadMain

	local BarBackground = Instance.new("Frame")
	BarBackground.Size = UDim2.new(1, -40, 0, 6)
	BarBackground.Position = UDim2.new(0, 20, 0, 85)
	BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	BarBackground.BorderSizePixel = 0
	BarBackground.Parent = LoadMain

	local BarBackCorner = Instance.new("UICorner")
	BarBackCorner.CornerRadius = UDim.new(1, 0)
	BarBackCorner.Parent = BarBackground

	local BarFill = Instance.new("Frame")
	BarFill.Size = UDim2.new(0, 0, 1, 0)
	BarFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	BarFill.BorderSizePixel = 0
	BarFill.Parent = BarBackground

	local BarFillCorner = Instance.new("UICorner")
	BarFillCorner.CornerRadius = UDim.new(1, 0)
	BarFillCorner.Parent = BarFill

	if UseAnimations then
		TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	else
		BarFill.Size = UDim2.new(1, 0, 1, 0)
	end
	task.wait(2.5)
	LoadGui:Destroy()

	-- 3. Interfaz Principal
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NovaUI"
	ScreenGui.Parent = ParentGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Notificaciones Container
	local NotifContainer = Instance.new("Frame")
	NotifContainer.Name = "Notifications"
	NotifContainer.Size = UDim2.new(0, 250, 1, 0)
	NotifContainer.Position = UDim2.new(1, -260, 0, 0)
	NotifContainer.BackgroundTransparency = 1
	NotifContainer.Parent = ScreenGui

	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifLayout.Padding = UDim.new(0, 10)
	NotifLayout.Parent = NotifContainer

	-- Botón Flotante "UI"
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "ToggleUI"
	ToggleButton.Size = UDim2.new(0, 45, 0, 45)
	ToggleButton.Position = UDim2.new(0, 20, 0.5, -22)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Font = Enum.Font.GothamBold
	ToggleButton.Text = "UI"
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButton.TextSize = 14
	ToggleButton.Parent = ScreenGui

	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(0, 8)
	ToggleCorner.Parent = ToggleButton

	local ToggleStroke = Instance.new("UIStroke")
	ToggleStroke.Color = Color3.fromRGB(45, 45, 55)
	ToggleStroke.Thickness = 1
	ToggleStroke.Parent = ToggleButton

	-- Watermark Opcional
	if WatermarkSettings.Enabled then
		local Watermark = Instance.new("Frame")
		Watermark.Size = UDim2.new(0, 200, 0, 30)
		Watermark.Position = UDim2.new(1, -220, 0, 20)
		Watermark.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
		Watermark.BorderSizePixel = 0
		Watermark.Parent = ScreenGui

		local WCorner = Instance.new("UICorner")
		WCorner.CornerRadius = UDim.new(0, 6)
		WCorner.Parent = Watermark

		local WStroke = Instance.new("UIStroke")
		WStroke.Color = Color3.fromRGB(40, 40, 50)
		WStroke.Thickness = 1
		WStroke.Parent = Watermark

		local WText = Instance.new("TextLabel")
		WText.Size = UDim2.new(1, 0, 1, 0)
		WText.BackgroundTransparency = 1
		WText.Font = Enum.Font.GothamMedium
		WText.TextColor3 = Color3.fromRGB(200, 200, 210)
		WText.TextSize = 11
		WText.Parent = Watermark

		RunService.RenderStepped:Connect(function()
			local fps = math.floor(1 / RunService.RenderStepped:Wait())
			local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
			WText.Text = (WatermarkSettings.Text or "NovaUI") .. " | FPS: " .. fps .. " | Ping: " .. ping .. "ms"
		end)
	end

	-- Ventana Principal
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 520, 0, 350)
	MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
	MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Color3.fromRGB(40, 40, 50)
	MainStroke.Thickness = 1
	MainStroke.Parent = MainFrame

	-- Bucle RGB para bordes si está activado
	if RGBBorders then
		RunService.RenderStepped:Connect(function()
			local hue = tick() % 5 / 5
			MainStroke.Color = Color3.fromHSV(hue, 1, 1)
			ToggleStroke.Color = Color3.fromHSV(hue, 1, 1)
		end)
	end

	-- Barra Superior
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = MainFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -20, 1, 0)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = WindowName
	TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar

	-- Perfil de Usuario Opcional (Izquierda superior)
	local tabListOffset = 40
	if UserProfileSettings.Enabled then
		tabListOffset = 100
		local ProfileFrame = Instance.new("Frame")
		ProfileFrame.Size = UDim2.new(0, 130, 0, 50)
		ProfileFrame.Position = UDim2.new(0, 10, 0, 40)
		ProfileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
		ProfileFrame.BorderSizePixel = 0
		ProfileFrame.Parent = MainFrame

		local PCorn = Instance.new("UICorner")
		PCorn.CornerRadius = UDim.new(0, 6)
		PCorn.Parent = ProfileFrame

		local AvatarImg = Instance.new("ImageLabel")
		AvatarImg.Size = UDim2.new(0, 36, 0, 36)
		AvatarImg.Position = UDim2.new(0, 7, 0.5, -18)
		AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		AvatarImg.Image = UserProfileSettings.Image or Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
		AvatarImg.Parent = ProfileFrame

		local ACorn = Instance.new("UICorner")
		ACorn.CornerRadius = UDim.new(1, 0)
		ACorn.Parent = AvatarImg

		local NameLabel = Instance.new("TextLabel")
		NameLabel.Size = UDim2.new(1, -48, 1, 0)
		NameLabel.Position = UDim2.new(0, 46, 0, 0)
		NameLabel.BackgroundTransparency = 1
		NameLabel.Font = Enum.Font.GothamBold
		NameLabel.Text = UserProfileSettings.Name or LocalPlayer.Name
		NameLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
		NameLabel.TextSize = 11
		NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left
		NameLabel.Parent = ProfileFrame
	end

	-- Contenedor de Pestañas Izquierdas
	local TabList = Instance.new("ScrollingFrame")
	TabList.Size = UDim2.new(0, 130, 1, -(tabListOffset + 10))
	TabList.Position = UDim2.new(0, 10, 0, tabListOffset)
	TabList.BackgroundTransparency = 1
	TabList.BorderSizePixel = 0
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabList.ScrollBarThickness = 2
	TabList.Parent = MainFrame

	local UIListLayoutTabs = Instance.new("UIListLayout")
	UIListLayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayoutTabs.Padding = UDim.new(0, 5)
	UIListLayoutTabs.Parent = TabList

	local PagesContainer = Instance.new("Folder")
	PagesContainer.Name = "PagesContainer"
	PagesContainer.Parent = MainFrame

	-- Toggle UI Visibilidad
	local UIv = true
	ToggleButton.MouseButton1Click:Connect(function()
		UIv = not UIv
		MainFrame.Visible = UIv
	end)

	-- Arrastrar ventana
	local dragging, dragInput, dragStart, startPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	local Window = {}

	function Window:Notify(NotifSettings)
		local Title = NotifSettings.Title or "Notificación"
		local Content = NotifSettings.Content or "Mensaje"
		local Duration = NotifSettings.Duration or 3

		local Notif = Instance.new("Frame")
		Notif.Size = UDim2.new(1, 0, 0, 65)
		Notif.Position = UDim2.new(1, 300, 0, 0)
		Notif.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
		Notif.BorderSizePixel = 0
		Notif.Parent = NotifContainer

		local NCorn = Instance.new("UICorner")
		NCorn.CornerRadius = UDim.new(0, 8)
		NCorn.Parent = Notif

		local NStroke = Instance.new("UIStroke")
		NStroke.Color = Color3.fromRGB(45, 45, 55)
		NStroke.Thickness = 1
		NStroke.Parent = Notif

		local NTitle = Instance.new("TextLabel")
		NTitle.Size = UDim2.new(1, -20, 0, 25)
		NTitle.Position = UDim2.new(0, 10, 0, 5)
		NTitle.BackgroundTransparency = 1
		NTitle.Font = Enum.Font.GothamBold
		NTitle.Text = Title
		NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		NTitle.TextSize = 13
		NTitle.TextXAlignment = Enum.TextXAlignment.Left
		NTitle.Parent = Notif

		local NDesc = Instance.new("TextLabel")
		NDesc.Size = UDim2.new(1, -20, 0, 30)
		NDesc.Position = UDim2.new(0, 10, 0, 25)
		NDesc.BackgroundTransparency = 1
		NDesc.Font = Enum.Font.Gotham
		NDesc.Text = Content
		NDesc.TextColor3 = Color3.fromRGB(160, 160, 170)
		NDesc.TextSize = 11
		NDesc.TextWrapped = true
		NDesc.TextXAlignment = Enum.TextXAlignment.Left
		NDesc.Parent = Notif

		if UseAnimations then
			TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
			task.wait(Duration)
			TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)}):Play()
			task.wait(0.3)
		else
			Notif.Position = UDim2.new(0, 0, 0, 0)
			task.wait(Duration)
		end
		Notif:Destroy()
	end

	local firstTab = true

	function Window:CreateTab(TabName)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
		TabButton.BackgroundTransparency = firstTab and 0 or 1
		TabButton.BorderSizePixel = 0
		TabButton.Font = Enum.Font.GothamMedium
		TabButton.Text = TabName
		TabButton.TextColor3 = firstTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 160)
		TabButton.TextSize = 12
		TabButton.Parent = TabList

		local TabBtnCorner = Instance.new("UICorner")
		TabBtnCorner.CornerRadius = UDim.new(0, 6)
		TabBtnCorner.Parent = TabButton

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = TabName.."Page"
		TabPage.Size = UDim2.new(1, -150, 1, -45)
		TabPage.Position = UDim2.new(0, 145, 0, 40)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.ScrollBarThickness = 3
		TabPage.Visible = firstTab
		TabPage.Parent = PagesContainer

		local UIListLayoutPage = Instance.new("UIListLayout")
		UIListLayoutPage.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayoutPage.Padding = UDim.new(0, 6)
		UIListLayoutPage.Parent = TabPage

		local UIPaddingPage = Instance.new("UIPadding")
		UIPaddingPage.PaddingRight = UDim.new(0, 8)
		UIPaddingPage.Parent = TabPage

		UIListLayoutPage:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutPage.AbsoluteContentSize.Y + 10)
		end)

		UIListLayoutTabs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabList.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutTabs.AbsoluteContentSize.Y + 10)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _, page in pairs(PagesContainer:GetChildren()) do
				if page:IsA("ScrollingFrame") then page.Visible = false end
			end
			for _, btn in pairs(TabList:GetChildren()) do
				if btn:IsA("TextButton") then
					if UseAnimations then
						TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
					else
						btn.BackgroundTransparency = 1
						btn.TextColor3 = Color3.fromRGB(150, 150, 160)
					end
				end
			end
			TabPage.Visible = true
			if UseAnimations then
				TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			else
				TabButton.BackgroundTransparency = 0
				TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end)

		firstTab = false
		local TabObj = {}

		function TabObj:CreateSection(SectionName)
			local SecLabel = Instance.new("TextLabel")
			SecLabel.Size = UDim2.new(1, 0, 0, 22)
			SecLabel.BackgroundTransparency = 1
			SecLabel.Font = Enum.Font.GothamBold
			SecLabel.Text = "  " .. string.upper(SectionName)
			SecLabel.TextColor3 = Color3.fromRGB(110, 110, 125)
			SecLabel.TextSize = 10
			SecLabel.TextXAlignment = Enum.TextXAlignment.Left
			SecLabel.Parent = TabPage
		end

		function TabObj:CreateLabel(Text)
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, 0, 0, 28)
			Label.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			Label.BorderSizePixel = 0
			Label.Font = Enum.Font.GothamMedium
			Label.Text = "  " .. Text
			Label.TextColor3 = Color3.fromRGB(200, 200, 210)
			Label.TextSize = 12
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = TabPage

			local LCorner = Instance.new("UICorner")
			LCorner.CornerRadius = UDim.new(0, 6)
			LCorner.Parent = Label

			local LObj = {}
			function LObj:Set(NewText)
				Label.Text = "  " .. NewText
			end
			return LObj
		end

		function TabObj:CreateParagraph(ParaSettings)
			local Title = ParaSettings.Title or "Título"
			local Content = ParaSettings.Content or "Contenido"

			local Para = Instance.new("Frame")
			Para.Size = UDim2.new(1, 0, 0, 55)
			Para.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			Para.BorderSizePixel = 0
			Para.Parent = TabPage

			local PCorn = Instance.new("UICorner")
			PCorn.CornerRadius = UDim.new(0, 6)
			PCorn.Parent = Para

			local PTitle = Instance.new("TextLabel")
			PTitle.Size = UDim2.new(1, -20, 0, 20)
			PTitle.Position = UDim2.new(0, 10, 0, 5)
			PTitle.BackgroundTransparency = 1
			PTitle.Font = Enum.Font.GothamBold
			PTitle.Text = Title
			PTitle.TextColor3 = Color3.fromRGB(230, 230, 240)
			PTitle.TextSize = 12
			PTitle.TextXAlignment = Enum.TextXAlignment.Left
			PTitle.Parent = Para

			local PContent = Instance.new("TextLabel")
			PContent.Size = UDim2.new(1, -20, 0, 25)
			PContent.Position = UDim2.new(0, 10, 0, 25)
			PContent.BackgroundTransparency = 1
			PContent.Font = Enum.Font.Gotham
			PContent.Text = Content
			PContent.TextColor3 = Color3.fromRGB(150, 150, 160)
			PContent.TextSize = 11
			PContent.TextWrapped = true
			PContent.TextXAlignment = Enum.TextXAlignment.Left
			PContent.Parent = Para
		end

		function TabObj:CreateButton(ButtonSettings)
			local ButtonName = ButtonSettings.Name or "Botón"
			local Callback = ButtonSettings.Callback or function() end

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1, 0, 0, 32)
			Button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			Button.BorderSizePixel = 0
			Button.Font = Enum.Font.GothamMedium
			Button.Text = "  "..ButtonName
			Button.TextColor3 = Color3.fromRGB(220, 220, 230)
			Button.TextSize = 12
			Button.TextXAlignment = Enum.TextXAlignment.Left
			Button.Parent = TabPage

			local BCorn = Instance.new("UICorner")
			BCorn.CornerRadius = UDim.new(0, 6)
			BCorn.Parent = Button

			Button.MouseButton1Click:Connect(function()
				pcall(Callback)
				if UseAnimations then
					TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
					task.wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
				end
			end)
		end

		function TabObj:CreateToggle(ToggleSettings)
			local ToggleName = ToggleSettings.Name or "Toggle"
			local Default = ToggleSettings.CurrentValue or false
			local Callback = ToggleSettings.Callback or function() end
			local Toggled = Default

			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.new(1, 0, 0, 32)
			Toggle.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			Toggle.BorderSizePixel = 0
			Toggle.Font = Enum.Font.GothamMedium
			Toggle.Text = "  "..ToggleName
			Toggle.TextColor3 = Color3.fromRGB(220, 220, 230)
			Toggle.TextSize = 12
			Toggle.TextXAlignment = Enum.TextXAlignment.Left
			Toggle.Parent = TabPage

			local TCorn = Instance.new("UICorner")
			TCorn.CornerRadius = UDim.new(0, 6)
			TCorn.Parent = Toggle

			local Checkbox = Instance.new("Frame")
			Checkbox.Size = UDim2.new(0, 18, 0, 18)
			Checkbox.Position = UDim2.new(1, -26, 0.5, -9)
			Checkbox.BackgroundColor3 = Toggled and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(32, 32, 42)
			Checkbox.BorderSizePixel = 0
			Checkbox.Parent = Toggle

			local CBCorn = Instance.new("UICorner")
			CBCorn.CornerRadius = UDim.new(0, 4)
			CBCorn.Parent = Checkbox

			Toggle.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				pcall(Callback, Toggled)
				local targetColor = Toggled and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(32, 32, 42)
				if UseAnimations then
					TweenService:Create(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
				else
					Checkbox.BackgroundColor3 = targetColor
				end
			end)
		end

		function TabObj:CreateSlider(SliderSettings)
			local SliderName = SliderSettings.Name or "Slider"
			local Range = SliderSettings.Range or {0, 100}
			local CurrentValue = SliderSettings.CurrentValue or Range[1]
			local Callback = SliderSettings.Callback or function() end

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 50)
			SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = TabPage

			local SCorn = Instance.new("UICorner")
			SCorn.CornerRadius = UDim.new(0, 6)
			SCorn.Parent = SliderFrame

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Size = UDim2.new(1, -20, 0, 25)
			TitleLabel.Position = UDim2.new(0, 10, 0, 2)
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Font = Enum.Font.GothamMedium
			TitleLabel.Text = SliderName
			TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
			TitleLabel.TextSize = 12
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(1, -20, 0, 25)
			ValueLabel.Position = UDim2.new(0, -10, 0, 2)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Font = Enum.Font.GothamMedium
			ValueLabel.Text = tostring(CurrentValue)
			ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
			ValueLabel.TextSize = 12
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local SliderBar = Instance.new("Frame")
			SliderBar.Size = UDim2.new(1, -20, 0, 6)
			SliderBar.Position = UDim2.new(0, 10, 0, 32)
			SliderBar.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
			SliderBar.BorderSizePixel = 0
			SliderBar.Parent = SliderFrame

			local SBCorn = Instance.new("UICorner")
			SBCorn.CornerRadius = UDim.new(1, 0)
			SBCorn.Parent = SliderBar

			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((CurrentValue - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)
			SliderFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBar

			local SFCorn = Instance.new("UICorner")
			SFCorn.CornerRadius = UDim.new(1, 0)
			SFCorn.Parent = SliderFill

			local draggingSlider = false
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					local val = math.floor(Range[1] + ((Range[2] - Range[1]) * pos))
					SliderFill.Size = UDim2.new(pos, 0, 1, 0)
					ValueLabel.Text = tostring(val)
					pcall(Callback, val)
				end
			end)
		end

		function TabObj:CreateDropdown(DropdownSettings)
			local DropdownName = DropdownSettings.Name or "Dropdown"
			local Options = DropdownSettings.Options or {}
			local Callback = DropdownSettings.Callback or function() end

			local DropdownBtn = Instance.new("TextButton")
			DropdownBtn.Size = UDim2.new(1, 0, 0, 32)
			DropdownBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			DropdownBtn.BorderSizePixel = 0
			DropdownBtn.Font = Enum.Font.GothamMedium
			DropdownBtn.Text = "  "..DropdownName.." : "..tostring(DropdownSettings.CurrentOption or Options[1])
			DropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
			DropdownBtn.TextSize = 12
			DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
			DropdownBtn.Parent = TabPage

			local DCorn = Instance.new("UICorner")
			DCorn.CornerRadius = UDim.new(0, 6)
			DCorn.Parent = DropdownBtn

			local optIndex = 1
			DropdownBtn.MouseButton1Click:Connect(function()
				optIndex = optIndex % #Options + 1
				local chosen = Options[optIndex]
				DropdownBtn.Text = "  "..DropdownName.." : "..tostring(chosen)
				pcall(Callback, chosen)
			end)
		end

		function TabObj:CreateColorPicker(ColorPickerSettings)
			local CPName = ColorPickerSettings.Name or "Color Picker"
			local DefaultColor = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			local Callback = ColorPickerSettings.Callback or function() end

			local CPBtn = Instance.new("TextButton")
			CPBtn.Size = UDim2.new(1, 0, 0, 32)
			CPBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			CPBtn.BorderSizePixel = 0
			CPBtn.Font = Enum.Font.GothamMedium
			CPBtn.Text = "  "..CPName
			CPBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
			CPBtn.TextSize = 12
			CPBtn.TextXAlignment = Enum.TextXAlignment.Left
			CPBtn.Parent = TabPage

			local CPCorn = Instance.new("UICorner")
			CPCorn.CornerRadius = UDim.new(0, 6)
			CPCorn.Parent = CPBtn

			local ColorDisplay = Instance.new("Frame")
			ColorDisplay.Size = UDim2.new(0, 24, 0, 16)
			ColorDisplay.Position = UDim2.new(1, -32, 0.5, -8)
			ColorDisplay.BackgroundColor3 = DefaultColor
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Parent = CPBtn

			local CDCorn = Instance.new("UICorner")
			CDCorn.CornerRadius = UDim.new(0, 4)
			CDCorn.Parent = ColorDisplay

			CPBtn.MouseButton1Click:Connect(function()
				local newColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
				ColorDisplay.BackgroundColor3 = newColor
				pcall(Callback, newColor)
			end)
		end

		return TabObj
	end

	return Window
end

return NovaUI
