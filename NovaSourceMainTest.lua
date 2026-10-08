--[[\
	NovaUI - Modern UI Library
	Inspired by Rayfield & Fluent
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

	-- Sistema de Keys
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

	-- Pantalla de Carga (2.5 segundos)
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

	TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	task.wait(2.5)
	LoadGui:Destroy()

	-- Interfaz Principal
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NovaUI"
	ScreenGui.Parent = ParentGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Botón flotante "UI"
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

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 500, 0, 330)
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -165)
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

	local TabList = Instance.new("ScrollingFrame")
	TabList.Size = UDim2.new(0, 130, 1, -45)
	TabList.Position = UDim2.new(0, 10, 0, 40)
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
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	TopBar.InputChanged:Connect(function(input)
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

	local Window = {}
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
					TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
				end
			end
			TabPage.Visible = true
			TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)

		firstTab = false

		local TabObj = {}

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
				TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
				task.wait(0.1)
				TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
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
				TweenService:Create(Checkbox, TweenInfo.new(0.2), {
					BackgroundColor3 = Toggled and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(32, 32, 42)
				}):Play()
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
			-- Implementación básica de Dropdown
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

			local opened = false
			local optIndex = 1
			DropdownBtn.MouseButton1Click:Connect(function()
				opened = not opened
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
				-- Ciclo simple de prueba de colores para el picker
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
