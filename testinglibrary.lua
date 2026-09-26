-- ToggleLib v3.0 - Tab Sistemi, Renk Özelleştirme, Rich Text Desteği
local ToggleLib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════
-- TEMA SİSTEMİ
-- ═══════════════════════════════════════════════════════════
local DefaultTheme = {
	-- Ana renkler
	AccentColor = Color3.fromRGB(0, 180, 130),
	AccentColorHover = Color3.fromRGB(0, 200, 150),
	AccentColorDark = Color3.fromRGB(0, 140, 100),

	-- Arka plan renkleri
	Background = Color3.fromRGB(20, 20, 25),
	TopBar = Color3.fromRGB(25, 25, 30),
	ElementBackground = Color3.fromRGB(35, 35, 40),
	ElementBackgroundHover = Color3.fromRGB(42, 42, 48),
	InputBackground = Color3.fromRGB(45, 45, 50),
	InputBackgroundHover = Color3.fromRGB(52, 52, 58),

	-- Metin renkleri
	TextColor = Color3.fromRGB(255, 255, 255),
	TextColorSecondary = Color3.fromRGB(200, 200, 205),
	TextColorDim = Color3.fromRGB(150, 150, 155),
	TextColorDisabled = Color3.fromRGB(100, 100, 105),

	-- Tab renkleri
	TabBackground = Color3.fromRGB(30, 30, 35),
	TabActive = Color3.fromRGB(0, 180, 130),
	TabInactive = Color3.fromRGB(45, 45, 50),
	TabTextActive = Color3.fromRGB(255, 255, 255),
	TabTextInactive = Color3.fromRGB(150, 150, 155),

	-- Buton renkleri
	ButtonColor = Color3.fromRGB(0, 150, 110),
	ButtonColorHover = Color3.fromRGB(0, 170, 125),
	ButtonColorPress = Color3.fromRGB(0, 110, 80),

	-- Toggle renkleri
	ToggleOn = Color3.fromRGB(0, 180, 130),
	ToggleOff = Color3.fromRGB(55, 55, 60),
	ToggleCircleOn = Color3.fromRGB(255, 255, 255),
	ToggleCircleOff = Color3.fromRGB(180, 180, 180),

	-- Slider renkleri
	SliderFill = Color3.fromRGB(0, 180, 130),
	SliderBackground = Color3.fromRGB(50, 50, 55),
	SliderKnob = Color3.fromRGB(255, 255, 255),

	-- Diğer
	BorderColor = Color3.fromRGB(60, 60, 70),
	SeparatorColor = Color3.fromRGB(55, 55, 65),
	CloseButton = Color3.fromRGB(180, 40, 40),
	CloseButtonHover = Color3.fromRGB(220, 50, 50),
	ScrollBar = Color3.fromRGB(0, 180, 130),

	-- Notification renkleri
	NotifInfo = Color3.fromRGB(0, 150, 220),
	NotifSuccess = Color3.fromRGB(0, 180, 100),
	NotifWarning = Color3.fromRGB(220, 160, 0),
	NotifError = Color3.fromRGB(220, 50, 50),
	NotifBackground = Color3.fromRGB(30, 30, 35),
}

local CurrentTheme = {}
for k, v in pairs(DefaultTheme) do
	CurrentTheme[k] = v
end

-- ═══════════════════════════════════════════════════════════
-- RICH TEXT YARDIMCI FONKSİYONLARI
-- ═══════════════════════════════════════════════════════════
local TextFormat = {}

function TextFormat.Bold(text)
	return "<b>" .. text .. "</b>"
end

function TextFormat.Italic(text)
	return "<i>" .. text .. "</i>"
end

function TextFormat.BoldItalic(text)
	return "<b><i>" .. text .. "</i></b>"
end

function TextFormat.Underline(text)
	return "<u>" .. text .. "</u>"
end

function TextFormat.Strike(text)
	return "<s>" .. text .. "</s>"
end

function TextFormat.Color(text, color)
	if typeof(color) == "Color3" then
		color = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
	end
	return '<font color="' .. color .. '">' .. text .. '</font>'
end

function TextFormat.Size(text, size)
	return '<font size="' .. tostring(size) .. '">' .. text .. '</font>'
end

function TextFormat.ColorSize(text, color, size)
	return TextFormat.Color(TextFormat.Size(text, size), color)
end

ToggleLib.TextFormat = TextFormat

-- ═══════════════════════════════════════════════════════════
-- UI OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToggleLibV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

if syn then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
	ScreenGui.Parent = gethui()
else
	ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════
-- NOTIFICATION SİSTEMİ
-- ═══════════════════════════════════════════════════════════
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "Notifications"
NotificationContainer.Size = UDim2.new(0, 280, 1, 0)
NotificationContainer.Position = UDim2.new(1, -290, 0, 0)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Parent = NotificationContainer

local NotifPadding = Instance.new("UIPadding")
NotifPadding.PaddingBottom = UDim.new(0, 10)
NotifPadding.Parent = NotificationContainer

function ToggleLib:Notify(title, message, duration, notifType)
	duration = duration or 3
	notifType = notifType or "info"

	local colors = {
		info = CurrentTheme.NotifInfo,
		success = CurrentTheme.NotifSuccess,
		warning = CurrentTheme.NotifWarning,
		error = CurrentTheme.NotifError
	}

	local icons = {
		info = "ℹ️",
		success = "✅",
		warning = "⚠️",
		error = "❌"
	}

	local NotifFrame = Instance.new("Frame")
	NotifFrame.Size = UDim2.new(1, 0, 0, 65)
	NotifFrame.BackgroundColor3 = CurrentTheme.NotifBackground
	NotifFrame.BorderSizePixel = 0
	NotifFrame.BackgroundTransparency = 1
	NotifFrame.Parent = NotificationContainer

	local NCorner = Instance.new("UICorner")
	NCorner.CornerRadius = UDim.new(0, 8)
	NCorner.Parent = NotifFrame

	local NStroke = Instance.new("UIStroke")
	NStroke.Color = colors[notifType] or colors.info
	NStroke.Thickness = 1.5
	NStroke.Transparency = 1
	NStroke.Parent = NotifFrame

	local AccentBar = Instance.new("Frame")
	AccentBar.Size = UDim2.new(0, 3, 1, -10)
	AccentBar.Position = UDim2.new(0, 5, 0, 5)
	AccentBar.BackgroundColor3 = colors[notifType] or colors.info
	AccentBar.BorderSizePixel = 0
	AccentBar.BackgroundTransparency = 1
	AccentBar.Parent = NotifFrame

	local ABCorner = Instance.new("UICorner")
	ABCorner.CornerRadius = UDim.new(0, 2)
	ABCorner.Parent = AccentBar

	local NTitle = Instance.new("TextLabel")
	NTitle.Size = UDim2.new(1, -25, 0, 22)
	NTitle.Position = UDim2.new(0, 16, 0, 5)
	NTitle.BackgroundTransparency = 1
	NTitle.RichText = true
	NTitle.Text = (icons[notifType] or "ℹ️") .. " <b>" .. title .. "</b>"
	NTitle.TextColor3 = CurrentTheme.TextColor
	NTitle.TextSize = 14
	NTitle.Font = Enum.Font.Gotham
	NTitle.TextXAlignment = Enum.TextXAlignment.Left
	NTitle.TextTransparency = 1
	NTitle.Parent = NotifFrame

	local NMessage = Instance.new("TextLabel")
	NMessage.Size = UDim2.new(1, -25, 0, 28)
	NMessage.Position = UDim2.new(0, 16, 0, 27)
	NMessage.BackgroundTransparency = 1
	NMessage.RichText = true
	NMessage.Text = message
	NMessage.TextColor3 = CurrentTheme.TextColorDim
	NMessage.TextSize = 12
	NMessage.Font = Enum.Font.Gotham
	NMessage.TextXAlignment = Enum.TextXAlignment.Left
	NMessage.TextWrapped = true
	NMessage.TextTransparency = 1
	NMessage.Parent = NotifFrame

	local ProgressBar = Instance.new("Frame")
	ProgressBar.Size = UDim2.new(1, -16, 0, 2)
	ProgressBar.Position = UDim2.new(0, 8, 1, -5)
	ProgressBar.BackgroundColor3 = colors[notifType] or colors.info
	ProgressBar.BorderSizePixel = 0
	ProgressBar.BackgroundTransparency = 1
	ProgressBar.Parent = NotifFrame

	local PBCorner = Instance.new("UICorner")
	PBCorner.CornerRadius = UDim.new(0, 1)
	PBCorner.Parent = ProgressBar

	-- Giriş animasyonu
	TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
	TweenService:Create(NStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
	TweenService:Create(AccentBar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
	TweenService:Create(NTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	TweenService:Create(NMessage, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	TweenService:Create(ProgressBar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

	task.delay(0.4, function()
		TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
	end)

	task.delay(duration + 0.4, function()
		TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
		TweenService:Create(NStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(AccentBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(NTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(NMessage, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(ProgressBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		task.wait(0.35)
		TweenService:Create(NotifFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
		task.wait(0.25)
		NotifFrame:Destroy()
	end)
end

-- ═══════════════════════════════════════════════════════════
-- DROPDOWN OVERLAY (Global)
-- ═══════════════════════════════════════════════════════════
local DropdownOverlay = Instance.new("Frame")
DropdownOverlay.Name = "DropdownOverlay"
DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
DropdownOverlay.BackgroundTransparency = 1
DropdownOverlay.ZIndex = 100
DropdownOverlay.Visible = false
DropdownOverlay.Parent = ScreenGui

local OverlayClick = Instance.new("TextButton")
OverlayClick.Size = UDim2.new(1, 0, 1, 0)
OverlayClick.BackgroundTransparency = 1
OverlayClick.Text = ""
OverlayClick.ZIndex = 100
OverlayClick.Parent = DropdownOverlay

local activeDropdownClose = nil
OverlayClick.MouseButton1Click:Connect(function()
	if activeDropdownClose then
		activeDropdownClose()
		activeDropdownClose = nil
	end
end)

-- ═══════════════════════════════════════════════════════════
-- WINDOW OLUŞTURMA (Ana fonksiyon)
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateWindow(config)
	config = config or {}
	local windowTitle = config.Title or "🎮 Script Hub"
	local windowSize = config.Size or UDim2.new(0, 420, 0, 500)
	local windowTheme = config.Theme or {}

	-- Tema uygula
	for k, v in pairs(windowTheme) do
		if CurrentTheme[k] ~= nil then
			CurrentTheme[k] = v
		end
	end

	local Window = {}
	local tabs = {}
	local activeTab = nil
	local isMinimized = false

	-- Ana Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 40) -- Başlangıçta sadece title bar
	MainFrame.Position = config.Position or UDim2.new(0.5, -(windowSize.X.Offset / 2), 0.5, -(windowSize.Y.Offset / 2))
	MainFrame.BackgroundColor3 = CurrentTheme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = CurrentTheme.BorderColor
	MainStroke.Thickness = 1
	MainStroke.Parent = MainFrame

	-- Shadow
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Size = UDim2.new(1, 20, 1, 20)
	Shadow.Position = UDim2.new(0, -10, 0, -10)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.5
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
	Shadow.ZIndex = -1
	Shadow.Parent = MainFrame

	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 40)
	TitleBar.BackgroundColor3 = CurrentTheme.TopBar
	TitleBar.BorderSizePixel = 0
	TitleBar.ZIndex = 5
	TitleBar.Parent = MainFrame

	local TBCornerFix = Instance.new("UICorner")
	TBCornerFix.CornerRadius = UDim.new(0, 10)
	TBCornerFix.Parent = TitleBar

	-- Title bar alt kısmı düzeltmek için
	local TBBottomFix = Instance.new("Frame")
	TBBottomFix.Size = UDim2.new(1, 0, 0, 12)
	TBBottomFix.Position = UDim2.new(0, 0, 1, -12)
	TBBottomFix.BackgroundColor3 = CurrentTheme.TopBar
	TBBottomFix.BorderSizePixel = 0
	TBBottomFix.ZIndex = 5
	TBBottomFix.Parent = TitleBar

	-- Sürükleme
	local dragging = false
	local dragInput, dragStart, startPos

	TitleBar.InputBegan:Connect(function(input)
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

	TitleBar.InputChanged:Connect(function(input)
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

	-- Başlık
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -90, 0, 40)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.RichText = true
	Title.Text = windowTitle
	Title.TextColor3 = CurrentTheme.TextColor
	Title.TextSize = 16
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 6
	Title.Parent = TitleBar

	-- Close Button
	local CloseButton = Instance.new("TextButton")
	CloseButton.Size = UDim2.new(0, 28, 0, 28)
	CloseButton.Position = UDim2.new(1, -38, 0, 6)
	CloseButton.BackgroundColor3 = CurrentTheme.CloseButton
	CloseButton.BorderSizePixel = 0
	CloseButton.Text = "✕"
	CloseButton.TextColor3 = CurrentTheme.TextColor
	CloseButton.TextSize = 13
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.ZIndex = 6
	CloseButton.Parent = TitleBar

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseButton

	CloseButton.MouseEnter:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.CloseButtonHover}):Play()
	end)
	CloseButton.MouseLeave:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.CloseButton}):Play()
	end)
	CloseButton.MouseButton1Click:Connect(function()
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.new(0, windowSize.X.Offset, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.35)
		ScreenGui:Destroy()
	end)

	-- Minimize Button
	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
	MinimizeButton.Position = UDim2.new(1, -70, 0, 6)
	MinimizeButton.BackgroundColor3 = CurrentTheme.TabInactive
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Text = "−"
	MinimizeButton.TextColor3 = CurrentTheme.TextColor
	MinimizeButton.TextSize = 18
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.ZIndex = 6
	MinimizeButton.Parent = TitleBar

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 6)
	MinCorner.Parent = MinimizeButton

	MinimizeButton.MouseEnter:Connect(function()
		TweenService:Create(MinimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ElementBackgroundHover}):Play()
	end)
	MinimizeButton.MouseLeave:Connect(function()
		TweenService:Create(MinimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.TabInactive}):Play()
	end)

	-- ═══════════════════════════════════════════════════════
	-- TAB BAR
	-- ═══════════════════════════════════════════════════════
	local TabBarContainer = Instance.new("Frame")
	TabBarContainer.Name = "TabBarContainer"
	TabBarContainer.Size = UDim2.new(1, 0, 0, 36)
	TabBarContainer.Position = UDim2.new(0, 0, 0, 40)
	TabBarContainer.BackgroundColor3 = CurrentTheme.TabBackground
	TabBarContainer.BorderSizePixel = 0
	TabBarContainer.ZIndex = 4
	TabBarContainer.Parent = MainFrame

	local TabBarScroll = Instance.new("ScrollingFrame")
	TabBarScroll.Size = UDim2.new(1, -10, 1, -4)
	TabBarScroll.Position = UDim2.new(0, 5, 0, 2)
	TabBarScroll.BackgroundTransparency = 1
	TabBarScroll.BorderSizePixel = 0
	TabBarScroll.ScrollBarThickness = 0
	TabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
	TabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
	TabBarScroll.ZIndex = 4
	TabBarScroll.Parent = TabBarContainer

	local TabBarLayout = Instance.new("UIListLayout")
	TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
	TabBarLayout.Padding = UDim.new(0, 4)
	TabBarLayout.Parent = TabBarScroll

	-- Accent line altında tab bar
	local TabAccentLine = Instance.new("Frame")
	TabAccentLine.Size = UDim2.new(1, 0, 0, 2)
	TabAccentLine.Position = UDim2.new(0, 0, 1, -2)
	TabAccentLine.BackgroundColor3 = CurrentTheme.AccentColor
	TabAccentLine.BorderSizePixel = 0
	TabAccentLine.ZIndex = 5
	TabAccentLine.Parent = TabBarContainer

	-- Content Area
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, 0, 1, -78)
	ContentArea.Position = UDim2.new(0, 0, 0, 78)
	ContentArea.BackgroundTransparency = 1
	ContentArea.BorderSizePixel = 0
	ContentArea.ClipsDescendants = true
	ContentArea.Parent = MainFrame

	-- Minimize
	local targetHeight = windowSize.Y.Offset

	MinimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
				Size = UDim2.new(0, windowSize.X.Offset, 0, 40)
			}):Play()
			MinimizeButton.Text = "+"
		else
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
				Size = UDim2.new(0, windowSize.X.Offset, 0, targetHeight)
			}):Play()
			MinimizeButton.Text = "−"
		end
	end)

	-- Keybind toggle
	local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == toggleKey then
			isMinimized = not isMinimized
			if isMinimized then
				TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, windowSize.X.Offset, 0, 40)
				}):Play()
				MinimizeButton.Text = "+"
			else
				TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, windowSize.X.Offset, 0, targetHeight)
				}):Play()
				MinimizeButton.Text = "−"
			end
		end
	end)

	-- Açılış animasyonu
	task.spawn(function()
		task.wait(0.05)
		TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, windowSize.X.Offset, 0, targetHeight)
		}):Play()
	end)

	-- ═══════════════════════════════════════════════════════
	-- TAB OLUŞTURMA
	-- ═══════════════════════════════════════════════════════
	function Window:CreateTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabName = tabConfig.Name or "Tab"
		local tabIcon = tabConfig.Icon or ""

		local Tab = {}
		local elements = {}

		-- Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabName
		TabButton.Size = UDim2.new(0, 0, 0, 28)
		TabButton.AutomaticSize = Enum.AutomaticSize.X
		TabButton.BackgroundColor3 = CurrentTheme.TabInactive
		TabButton.BorderSizePixel = 0
		TabButton.Text = ""
		TabButton.ZIndex = 5
		TabButton.Parent = TabBarScroll

		local TBtnCorner = Instance.new("UICorner")
		TBtnCorner.CornerRadius = UDim.new(0, 6)
		TBtnCorner.Parent = TabButton

		local TBtnPadding = Instance.new("UIPadding")
		TBtnPadding.PaddingLeft = UDim.new(0, 12)
		TBtnPadding.PaddingRight = UDim.new(0, 12)
		TBtnPadding.Parent = TabButton

		local TBtnLabel = Instance.new("TextLabel")
		TBtnLabel.Size = UDim2.new(0, 0, 1, 0)
		TBtnLabel.AutomaticSize = Enum.AutomaticSize.X
		TBtnLabel.BackgroundTransparency = 1
		TBtnLabel.RichText = true
		TBtnLabel.Text = (tabIcon ~= "" and (tabIcon .. " ") or "") .. tabName
		TBtnLabel.TextColor3 = CurrentTheme.TabTextInactive
		TBtnLabel.TextSize = 13
		TBtnLabel.Font = Enum.Font.GothamSemibold
		TBtnLabel.ZIndex = 5
		TBtnLabel.Parent = TabButton

		-- Tab Content (ScrollingFrame)
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = tabName .. "_Content"
		TabContent.Size = UDim2.new(1, -16, 1, -8)
		TabContent.Position = UDim2.new(0, 8, 0, 4)
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.ScrollBarThickness = 3
		TabContent.ScrollBarImageColor3 = CurrentTheme.ScrollBar
		TabContent.ScrollBarImageTransparency = 0.3
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.Visible = false
		TabContent.ClipsDescendants = true
		TabContent.Parent = ContentArea

		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 6)
		ContentLayout.Parent = TabContent

		local ContentPad = Instance.new("UIPadding")
		ContentPad.PaddingRight = UDim.new(0, 4)
		ContentPad.Parent = TabContent

		-- Canvas boyutunu güncelle
		local function UpdateCanvas()
			local totalHeight = 0
			for _, data in ipairs(elements) do
				totalHeight = totalHeight + data.height + 6
			end
			if #elements > 0 then
				totalHeight = totalHeight - 6
			end
			TabContent.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 8)
		end

		-- Tab aktif yapma
		local function ActivateTab()
			-- Tüm tab'ları deaktif et
			for _, t in ipairs(tabs) do
				t.content.Visible = false
				TweenService:Create(t.button, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.TabInactive}):Play()
				TweenService:Create(t.label, TweenInfo.new(0.2), {TextColor3 = CurrentTheme.TabTextInactive}):Play()
			end

			-- Bu tab'ı aktif et
			TabContent.Visible = true
			TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.TabActive}):Play()
			TweenService:Create(TBtnLabel, TweenInfo.new(0.2), {TextColor3 = CurrentTheme.TabTextActive}):Play()
			activeTab = Tab
		end

		TabButton.MouseButton1Click:Connect(ActivateTab)

		TabButton.MouseEnter:Connect(function()
			if activeTab ~= Tab then
				TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ElementBackgroundHover}):Play()
			end
		end)
		TabButton.MouseLeave:Connect(function()
			if activeTab ~= Tab then
				TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.TabInactive}):Play()
			end
		end)

		table.insert(tabs, {
			tab = Tab,
			button = TabButton,
			label = TBtnLabel,
			content = TabContent
		})

		-- İlk tab'ı otomatik aktif yap
		if #tabs == 1 then
			ActivateTab()
		end

		-- ═══════════════════════════════════════════════════
		-- TOGGLE
		-- ═══════════════════════════════════════════════════
		function Tab:CreateToggle(toggleConfig)
			toggleConfig = toggleConfig or {}
			local name = toggleConfig.Name or "Toggle"
			local default = toggleConfig.Default or false
			local callback = toggleConfig.Callback or function() end
			local colors = toggleConfig.Colors or {}

			local onColor = colors.On or CurrentTheme.ToggleOn
			local offColor = colors.Off or CurrentTheme.ToggleOff
			local circleOnColor = colors.CircleOn or CurrentTheme.ToggleCircleOn
			local circleOffColor = colors.CircleOff or CurrentTheme.ToggleCircleOff

			local ELEMENT_HEIGHT = 36

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = name
			ToggleFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			ToggleFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = TabContent

			local TFCorner = Instance.new("UICorner")
			TFCorner.CornerRadius = UDim.new(0, 8)
			TFCorner.Parent = ToggleFrame

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.RichText = true
			ToggleLabel.Text = name
			ToggleLabel.TextColor3 = CurrentTheme.TextColorSecondary
			ToggleLabel.TextSize = 14
			ToggleLabel.Font = Enum.Font.Gotham
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.TextTruncate = Enum.TextTruncate.AtEnd
			ToggleLabel.Parent = ToggleFrame

			local ToggleBG = Instance.new("Frame")
			ToggleBG.Size = UDim2.new(0, 44, 0, 22)
			ToggleBG.Position = UDim2.new(1, -54, 0.5, -11)
			ToggleBG.BackgroundColor3 = offColor
			ToggleBG.BorderSizePixel = 0
			ToggleBG.Parent = ToggleFrame

			local TBGCorner = Instance.new("UICorner")
			TBGCorner.CornerRadius = UDim.new(1, 0)
			TBGCorner.Parent = ToggleBG

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0, 18, 0, 18)
			Circle.Position = UDim2.new(0, 2, 0.5, -9)
			Circle.BackgroundColor3 = circleOffColor
			Circle.BorderSizePixel = 0
			Circle.Parent = ToggleBG

			local CCorner = Instance.new("UICorner")
			CCorner.CornerRadius = UDim.new(1, 0)
			CCorner.Parent = Circle

			local Clickable = Instance.new("TextButton")
			Clickable.Size = UDim2.new(1, 0, 1, 0)
			Clickable.BackgroundTransparency = 1
			Clickable.Text = ""
			Clickable.Parent = ToggleFrame

			local toggled = default

			local function setVisual(state, skipCallback)
				local circlePos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
				local bgCol = state and onColor or offColor
				local cCol = state and circleOnColor or circleOffColor
				local tCol = state and CurrentTheme.TextColor or CurrentTheme.TextColorSecondary

				TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = circlePos, BackgroundColor3 = cCol}):Play()
				TweenService:Create(ToggleBG, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = bgCol}):Play()
				TweenService:Create(ToggleLabel, TweenInfo.new(0.2), {TextColor3 = tCol}):Play()
			end

			if default then
				setVisual(true, true)
				task.spawn(function() callback(true) end)
			end

			Clickable.MouseButton1Click:Connect(function()
				toggled = not toggled
				setVisual(toggled)
				callback(toggled)
			end)

			Clickable.MouseEnter:Connect(function()
				TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ElementBackgroundHover}):Play()
			end)
			Clickable.MouseLeave:Connect(function()
				TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ElementBackground}):Play()
			end)

			table.insert(elements, {frame = ToggleFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				SetValue = function(value)
					toggled = value
					setVisual(toggled)
					callback(toggled)
				end,
				GetValue = function()
					return toggled
				end,
				SetText = function(text)
					ToggleLabel.Text = text
				end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == ToggleFrame then
							table.remove(elements, i)
							break
						end
					end
					ToggleFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- BUTTON
		-- ═══════════════════════════════════════════════════
		function Tab:CreateButton(btnConfig)
			btnConfig = btnConfig or {}
			local name = btnConfig.Name or "Button"
			local callback = btnConfig.Callback or function() end
			local colors = btnConfig.Colors or {}

			local btnColor = colors.Color or CurrentTheme.ButtonColor
			local btnHover = colors.Hover or CurrentTheme.ButtonColorHover
			local btnPress = colors.Press or CurrentTheme.ButtonColorPress
			local btnTextColor = colors.TextColor or CurrentTheme.TextColor

			local ELEMENT_HEIGHT = 36

			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Name = name
			ButtonFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			ButtonFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.Parent = TabContent

			local BFCorner = Instance.new("UICorner")
			BFCorner.CornerRadius = UDim.new(0, 8)
			BFCorner.Parent = ButtonFrame

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1, -16, 1, -8)
			Button.Position = UDim2.new(0, 8, 0, 4)
			Button.BackgroundColor3 = btnColor
			Button.BorderSizePixel = 0
			Button.RichText = true
			Button.Text = name
			Button.TextColor3 = btnTextColor
			Button.TextSize = 14
			Button.Font = Enum.Font.GothamSemibold
			Button.Parent = ButtonFrame

			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 6)
			BtnCorner.Parent = Button

			Button.MouseButton1Click:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.08), {BackgroundColor3 = btnPress}):Play()
				task.wait(0.08)
				TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = btnColor}):Play()
				callback()
			end)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = btnHover}):Play()
			end)
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = btnColor}):Play()
			end)

			table.insert(elements, {frame = ButtonFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				SetText = function(text)
					Button.Text = text
				end,
				SetColor = function(color)
					btnColor = color
					Button.BackgroundColor3 = color
				end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == ButtonFrame then
							table.remove(elements, i)
							break
						end
					end
					ButtonFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- TEXTBOX
		-- ═══════════════════════════════════════════════════
		function Tab:CreateTextBox(tbConfig)
			tbConfig = tbConfig or {}
			local name = tbConfig.Name or "TextBox"
			local placeholder = tbConfig.Placeholder or "Enter text..."
			local callback = tbConfig.Callback or function() end
			local colors = tbConfig.Colors or {}

			local ELEMENT_HEIGHT = 36

			local TextBoxFrame = Instance.new("Frame")
			TextBoxFrame.Name = name
			TextBoxFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			TextBoxFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			TextBoxFrame.BorderSizePixel = 0
			TextBoxFrame.Parent = TabContent

			local TBFCorner = Instance.new("UICorner")
			TBFCorner.CornerRadius = UDim.new(0, 8)
			TBFCorner.Parent = TextBoxFrame

			local TBLabel = Instance.new("TextLabel")
			TBLabel.Size = UDim2.new(0.4, -10, 1, 0)
			TBLabel.Position = UDim2.new(0, 12, 0, 0)
			TBLabel.BackgroundTransparency = 1
			TBLabel.RichText = true
			TBLabel.Text = name
			TBLabel.TextColor3 = CurrentTheme.TextColorSecondary
			TBLabel.TextSize = 14
			TBLabel.Font = Enum.Font.Gotham
			TBLabel.TextXAlignment = Enum.TextXAlignment.Left
			TBLabel.TextTruncate = Enum.TextTruncate.AtEnd
			TBLabel.Parent = TextBoxFrame

			local TextBox = Instance.new("TextBox")
			TextBox.Size = UDim2.new(0.55, -10, 0, 26)
			TextBox.Position = UDim2.new(0.45, 0, 0.5, -13)
			TextBox.BackgroundColor3 = colors.Background or CurrentTheme.InputBackground
			TextBox.BorderSizePixel = 0
			TextBox.Text = ""
			TextBox.PlaceholderText = placeholder
			TextBox.PlaceholderColor3 = CurrentTheme.TextColorDisabled
			TextBox.TextColor3 = CurrentTheme.TextColor
			TextBox.TextSize = 13
			TextBox.Font = Enum.Font.Gotham
			TextBox.ClearTextOnFocus = false
			TextBox.Parent = TextBoxFrame

			local TBCorner = Instance.new("UICorner")
			TBCorner.CornerRadius = UDim.new(0, 6)
			TBCorner.Parent = TextBox

			local TBStroke = Instance.new("UIStroke")
			TBStroke.Color = CurrentTheme.BorderColor
			TBStroke.Thickness = 1
			TBStroke.Parent = TextBox

			TextBox.Focused:Connect(function()
				TweenService:Create(TBStroke, TweenInfo.new(0.2), {Color = colors.FocusBorder or CurrentTheme.AccentColor}):Play()
			end)

			TextBox.FocusLost:Connect(function(enterPressed)
				TweenService:Create(TBStroke, TweenInfo.new(0.2), {Color = CurrentTheme.BorderColor}):Play()
				if enterPressed then
					callback(TextBox.Text)
				end
			end)

			table.insert(elements, {frame = TextBoxFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				GetText = function() return TextBox.Text end,
				SetText = function(text) TextBox.Text = text end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == TextBoxFrame then
							table.remove(elements, i)
							break
						end
					end
					TextBoxFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- DROPDOWN
		-- ═══════════════════════════════════════════════════
		function Tab:CreateDropdown(ddConfig)
			ddConfig = ddConfig or {}
			local name = ddConfig.Name or "Dropdown"
			local options = ddConfig.Options or {}
			local default = ddConfig.Default or nil
			local callback = ddConfig.Callback or function() end
			local colors = ddConfig.Colors or {}

			local ELEMENT_HEIGHT = 36

			local DDFrame = Instance.new("Frame")
			DDFrame.Name = name
			DDFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			DDFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			DDFrame.BorderSizePixel = 0
			DDFrame.Parent = TabContent

			local DFCorner = Instance.new("UICorner")
			DFCorner.CornerRadius = UDim.new(0, 8)
			DFCorner.Parent = DDFrame

			local DDLabel = Instance.new("TextLabel")
			DDLabel.Size = UDim2.new(0.4, -10, 1, 0)
			DDLabel.Position = UDim2.new(0, 12, 0, 0)
			DDLabel.BackgroundTransparency = 1
			DDLabel.RichText = true
			DDLabel.Text = name
			DDLabel.TextColor3 = CurrentTheme.TextColorSecondary
			DDLabel.TextSize = 14
			DDLabel.Font = Enum.Font.Gotham
			DDLabel.TextXAlignment = Enum.TextXAlignment.Left
			DDLabel.TextTruncate = Enum.TextTruncate.AtEnd
			DDLabel.Parent = DDFrame

			local DDButton = Instance.new("TextButton")
			DDButton.Size = UDim2.new(0.55, -10, 0, 26)
			DDButton.Position = UDim2.new(0.45, 0, 0.5, -13)
			DDButton.BackgroundColor3 = colors.Background or CurrentTheme.InputBackground
			DDButton.BorderSizePixel = 0
			DDButton.Text = default or "Select..."
			DDButton.TextColor3 = CurrentTheme.TextColorSecondary
			DDButton.TextSize = 13
			DDButton.Font = Enum.Font.Gotham
			DDButton.TextTruncate = Enum.TextTruncate.AtEnd
			DDButton.Parent = DDFrame

			local DBCorner = Instance.new("UICorner")
			DBCorner.CornerRadius = UDim.new(0, 6)
			DBCorner.Parent = DDButton

			local DBStroke = Instance.new("UIStroke")
			DBStroke.Color = CurrentTheme.BorderColor
			DBStroke.Thickness = 1
			DBStroke.Parent = DDButton

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 1, 0)
			Arrow.Position = UDim2.new(1, -22, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "▼"
			Arrow.TextColor3 = CurrentTheme.TextColorDim
			Arrow.TextSize = 10
			Arrow.Font = Enum.Font.GothamBold
			Arrow.Parent = DDButton

			-- Overlay Options
			local maxVisible = 6
			local optHeight = 30
			local containerH = math.min(#options, maxVisible) * optHeight

			local OptionsScroll = Instance.new("ScrollingFrame")
			OptionsScroll.Size = UDim2.new(0, 160, 0, containerH)
			OptionsScroll.BackgroundColor3 = colors.DropdownBackground or CurrentTheme.ElementBackground
			OptionsScroll.BorderSizePixel = 0
			OptionsScroll.Visible = false
			OptionsScroll.ZIndex = 110
			OptionsScroll.ScrollBarThickness = 3
			OptionsScroll.ScrollBarImageColor3 = CurrentTheme.ScrollBar
			OptionsScroll.ScrollBarImageTransparency = 0.2
			OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #options * optHeight)
			OptionsScroll.Parent = DropdownOverlay

			local OSCorner = Instance.new("UICorner")
			OSCorner.CornerRadius = UDim.new(0, 6)
			OSCorner.Parent = OptionsScroll

			local OSStroke = Instance.new("UIStroke")
			OSStroke.Color = colors.DropdownBorder or CurrentTheme.AccentColor
			OSStroke.Thickness = 1
			OSStroke.Parent = OptionsScroll

			local OptionsLayout = Instance.new("UIListLayout")
			OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
			OptionsLayout.Parent = OptionsScroll

			local isOpen = false
			local selectedOption = default

			local function closeDD()
				isOpen = false
				OptionsScroll.Visible = false
				DropdownOverlay.Visible = false
				Arrow.Text = "▼"
				TweenService:Create(DBStroke, TweenInfo.new(0.15), {Color = CurrentTheme.BorderColor}):Play()
			end

			local function populateOpts(opts)
				for _, child in ipairs(OptionsScroll:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end

				local totalH = #opts * optHeight
				OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, totalH)
				OptionsScroll.Size = UDim2.new(0, 160, 0, math.min(#opts, maxVisible) * optHeight)

				for _, option in ipairs(opts) do
					local OptBtn = Instance.new("TextButton")
					OptBtn.Size = UDim2.new(1, 0, 0, optHeight)
					OptBtn.BackgroundColor3 = colors.DropdownBackground or CurrentTheme.ElementBackground
					OptBtn.BorderSizePixel = 0
					OptBtn.RichText = true
					OptBtn.Text = "  " .. option
					OptBtn.TextColor3 = CurrentTheme.TextColorSecondary
					OptBtn.TextSize = 13
					OptBtn.Font = Enum.Font.Gotham
					OptBtn.TextXAlignment = Enum.TextXAlignment.Left
					OptBtn.ZIndex = 111
					OptBtn.Parent = OptionsScroll

					if option == selectedOption then
						OptBtn.BackgroundColor3 = colors.SelectedColor or CurrentTheme.AccentColorDark
						OptBtn.TextColor3 = CurrentTheme.TextColor
					end

					OptBtn.MouseEnter:Connect(function()
						if option ~= selectedOption then
							TweenService:Create(OptBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.InputBackgroundHover}):Play()
						end
					end)
					OptBtn.MouseLeave:Connect(function()
						if option ~= selectedOption then
							TweenService:Create(OptBtn, TweenInfo.new(0.1), {BackgroundColor3 = colors.DropdownBackground or CurrentTheme.ElementBackground}):Play()
						end
					end)

					OptBtn.MouseButton1Click:Connect(function()
						selectedOption = option
						DDButton.Text = option
						closeDD()
						callback(option)
					end)
				end
			end

			populateOpts(options)

			if default and table.find(options, default) then
				callback(default)
			end

			DDButton.MouseButton1Click:Connect(function()
				if isOpen then
					closeDD()
					return
				end

				if activeDropdownClose then
					activeDropdownClose()
				end

				isOpen = true
				DropdownOverlay.Visible = true
				Arrow.Text = "▲"
				TweenService:Create(DBStroke, TweenInfo.new(0.15), {Color = colors.DropdownBorder or CurrentTheme.AccentColor}):Play()

				local absPos = DDButton.AbsolutePosition
				local absSize = DDButton.AbsoluteSize
				OptionsScroll.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
				OptionsScroll.Size = UDim2.new(0, absSize.X, 0, math.min(#options, maxVisible) * optHeight)
				OptionsScroll.Visible = true

				populateOpts(options)
				activeDropdownClose = closeDD
			end)

			DDButton.MouseEnter:Connect(function()
				if not isOpen then
					TweenService:Create(DDButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.InputBackgroundHover}):Play()
				end
			end)
			DDButton.MouseLeave:Connect(function()
				if not isOpen then
					TweenService:Create(DDButton, TweenInfo.new(0.15), {BackgroundColor3 = colors.Background or CurrentTheme.InputBackground}):Play()
				end
			end)

			table.insert(elements, {frame = DDFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				GetSelected = function() return selectedOption end,
				SetSelected = function(option)
					if table.find(options, option) then
						selectedOption = option
						DDButton.Text = option
						callback(option)
					end
				end,
				UpdateOptions = function(newOptions)
					options = newOptions
					populateOpts(options)
					if selectedOption and not table.find(options, selectedOption) then
						selectedOption = nil
						DDButton.Text = "Select..."
					end
				end,
				Refresh = function()
					populateOpts(options)
				end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == DDFrame then
							table.remove(elements, i)
							break
						end
					end
					DDFrame:Destroy()
					OptionsScroll:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- SLIDER
		-- ═══════════════════════════════════════════════════
		function Tab:CreateSlider(sliderConfig)
			sliderConfig = sliderConfig or {}
			local name = sliderConfig.Name or "Slider"
			local min = sliderConfig.Min or 0
			local max = sliderConfig.Max or 100
			local default = sliderConfig.Default or min
			local increment = sliderConfig.Increment or 1
			local callback = sliderConfig.Callback or function() end
			local colors = sliderConfig.Colors or {}

			local fillColor = colors.Fill or CurrentTheme.SliderFill
			local bgColor = colors.Background or CurrentTheme.SliderBackground
			local knobColor = colors.Knob or CurrentTheme.SliderKnob

			local ELEMENT_HEIGHT = 52

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = name
			SliderFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			SliderFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = TabContent

			local SFCorner = Instance.new("UICorner")
			SFCorner.CornerRadius = UDim.new(0, 8)
			SFCorner.Parent = SliderFrame

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(0.65, -10, 0, 22)
			SliderLabel.Position = UDim2.new(0, 12, 0, 4)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.RichText = true
			SliderLabel.Text = name
			SliderLabel.TextColor3 = CurrentTheme.TextColorSecondary
			SliderLabel.TextSize = 14
			SliderLabel.Font = Enum.Font.Gotham
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.TextTruncate = Enum.TextTruncate.AtEnd
			SliderLabel.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0.35, -12, 0, 22)
			ValueLabel.Position = UDim2.new(0.65, 0, 0, 4)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(default)
			ValueLabel.TextColor3 = colors.ValueText or CurrentTheme.AccentColor
			ValueLabel.TextSize = 14
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local SliderBG = Instance.new("Frame")
			SliderBG.Size = UDim2.new(1, -24, 0, 6)
			SliderBG.Position = UDim2.new(0, 12, 0, 36)
			SliderBG.BackgroundColor3 = bgColor
			SliderBG.BorderSizePixel = 0
			SliderBG.Parent = SliderFrame

			local SBGCorner = Instance.new("UICorner")
			SBGCorner.CornerRadius = UDim.new(1, 0)
			SBGCorner.Parent = SliderBG

			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			SliderFill.BackgroundColor3 = fillColor
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBG

			local SFillCorner = Instance.new("UICorner")
			SFillCorner.CornerRadius = UDim.new(1, 0)
			SFillCorner.Parent = SliderFill

			local SliderKnob = Instance.new("Frame")
			SliderKnob.Size = UDim2.new(0, 14, 0, 14)
			SliderKnob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
			SliderKnob.BackgroundColor3 = knobColor
			SliderKnob.BorderSizePixel = 0
			SliderKnob.ZIndex = 2
			SliderKnob.Parent = SliderBG

			local KCorner = Instance.new("UICorner")
			KCorner.CornerRadius = UDim.new(1, 0)
			KCorner.Parent = SliderKnob

			local KStroke = Instance.new("UIStroke")
			KStroke.Color = fillColor
			KStroke.Thickness = 2
			KStroke.Parent = SliderKnob

			local currentValue = default
			local sliding = false

			local SliderClick = Instance.new("TextButton")
			SliderClick.Size = UDim2.new(1, 0, 0, 22)
			SliderClick.Position = UDim2.new(0, 0, 0, 28)
			SliderClick.BackgroundTransparency = 1
			SliderClick.Text = ""
			SliderClick.Parent = SliderFrame

			local function snapValue(val)
				if increment < 1 then
					return math.floor(val / increment + 0.5) * increment
				else
					return math.floor(val / increment + 0.5) * increment
				end
			end

			local function updateSlider(input)
				local absPos = SliderBG.AbsolutePosition
				local absSize = SliderBG.AbsoluteSize
				local relX = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
				currentValue = snapValue(min + (max - min) * relX)
				currentValue = math.clamp(currentValue, min, max)

				local fillSize = (currentValue - min) / (max - min)
				TweenService:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(fillSize, 0, 1, 0)}):Play()
				TweenService:Create(SliderKnob, TweenInfo.new(0.05), {Position = UDim2.new(fillSize, -7, 0.5, -7)}):Play()

				if increment < 1 then
					local decimals = #tostring(increment):match("%.(%d+)") or 0
					ValueLabel.Text = string.format("%." .. decimals .. "f", currentValue)
				else
					ValueLabel.Text = tostring(currentValue)
				end
				callback(currentValue)
			end

			SliderClick.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
				end
			end)

			table.insert(elements, {frame = SliderFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				SetValue = function(value)
					currentValue = math.clamp(snapValue(value), min, max)
					local fillSize = (currentValue - min) / (max - min)
					SliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
					SliderKnob.Position = UDim2.new(fillSize, -7, 0.5, -7)
					if increment < 1 then
						local decimals = #tostring(increment):match("%.(%d+)") or 0
						ValueLabel.Text = string.format("%." .. decimals .. "f", currentValue)
					else
						ValueLabel.Text = tostring(currentValue)
					end
					callback(currentValue)
				end,
				GetValue = function() return currentValue end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == SliderFrame then
							table.remove(elements, i)
							break
						end
					end
					SliderFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- KEYBIND
		-- ═══════════════════════════════════════════════════
		function Tab:CreateKeybind(kbConfig)
			kbConfig = kbConfig or {}
			local name = kbConfig.Name or "Keybind"
			local defaultKey = kbConfig.Default or Enum.KeyCode.Unknown
			local callback = kbConfig.Callback or function() end
			local colors = kbConfig.Colors or {}

			local ELEMENT_HEIGHT = 36

			local KBFrame = Instance.new("Frame")
			KBFrame.Name = name
			KBFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			KBFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			KBFrame.BorderSizePixel = 0
			KBFrame.Parent = TabContent

			local KFCorner = Instance.new("UICorner")
			KFCorner.CornerRadius = UDim.new(0, 8)
			KFCorner.Parent = KBFrame

			local KBLabel = Instance.new("TextLabel")
			KBLabel.Size = UDim2.new(1, -80, 1, 0)
			KBLabel.Position = UDim2.new(0, 12, 0, 0)
			KBLabel.BackgroundTransparency = 1
			KBLabel.RichText = true
			KBLabel.Text = name
			KBLabel.TextColor3 = CurrentTheme.TextColorSecondary
			KBLabel.TextSize = 14
			KBLabel.Font = Enum.Font.Gotham
			KBLabel.TextXAlignment = Enum.TextXAlignment.Left
			KBLabel.TextTruncate = Enum.TextTruncate.AtEnd
			KBLabel.Parent = KBFrame

			local KeyBtn = Instance.new("TextButton")
			KeyBtn.Size = UDim2.new(0, 60, 0, 24)
			KeyBtn.Position = UDim2.new(1, -68, 0.5, -12)
			KeyBtn.BackgroundColor3 = colors.Background or CurrentTheme.InputBackground
			KeyBtn.BorderSizePixel = 0
			KeyBtn.Text = defaultKey == Enum.KeyCode.Unknown and "None" or defaultKey.Name
			KeyBtn.TextColor3 = colors.TextColor or CurrentTheme.AccentColor
			KeyBtn.TextSize = 12
			KeyBtn.Font = Enum.Font.GothamBold
			KeyBtn.Parent = KBFrame

			local KBtnCorner = Instance.new("UICorner")
			KBtnCorner.CornerRadius = UDim.new(0, 6)
			KBtnCorner.Parent = KeyBtn

			local KBStroke = Instance.new("UIStroke")
			KBStroke.Color = CurrentTheme.BorderColor
			KBStroke.Thickness = 1
			KBStroke.Parent = KeyBtn

			local currentKey = defaultKey
			local listening = false

			KeyBtn.MouseButton1Click:Connect(function()
				if listening then return end
				listening = true
				KeyBtn.Text = "..."
				TweenService:Create(KBStroke, TweenInfo.new(0.2), {Color = CurrentTheme.AccentColor}):Play()
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if not listening then
					if input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown and not gameProcessed then
						callback(currentKey)
					end
					return
				end

				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == Enum.KeyCode.Escape then
						currentKey = Enum.KeyCode.Unknown
						KeyBtn.Text = "None"
					else
						currentKey = input.KeyCode
						KeyBtn.Text = input.KeyCode.Name
					end
					listening = false
					TweenService:Create(KBStroke, TweenInfo.new(0.2), {Color = CurrentTheme.BorderColor}):Play()
				end
			end)

			table.insert(elements, {frame = KBFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				GetKey = function() return currentKey end,
				SetKey = function(key)
					currentKey = key
					KeyBtn.Text = key == Enum.KeyCode.Unknown and "None" or key.Name
				end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == KBFrame then
							table.remove(elements, i)
							break
						end
					end
					KBFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- COLOR PICKER
		-- ═══════════════════════════════════════════════════
		function Tab:CreateColorPicker(cpConfig)
			cpConfig = cpConfig or {}
			local name = cpConfig.Name or "Color"
			local defaultColor = cpConfig.Default or Color3.fromRGB(255, 0, 0)
			local callback = cpConfig.Callback or function() end

			local ELEMENT_HEIGHT = 36

			local CPFrame = Instance.new("Frame")
			CPFrame.Name = name
			CPFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			CPFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			CPFrame.BorderSizePixel = 0
			CPFrame.ClipsDescendants = true
			CPFrame.Parent = TabContent

			local CPCorner = Instance.new("UICorner")
			CPCorner.CornerRadius = UDim.new(0, 8)
			CPCorner.Parent = CPFrame

			local CPLabel = Instance.new("TextLabel")
			CPLabel.Size = UDim2.new(1, -50, 0, ELEMENT_HEIGHT)
			CPLabel.Position = UDim2.new(0, 12, 0, 0)
			CPLabel.BackgroundTransparency = 1
			CPLabel.RichText = true
			CPLabel.Text = name
			CPLabel.TextColor3 = CurrentTheme.TextColorSecondary
			CPLabel.TextSize = 14
			CPLabel.Font = Enum.Font.Gotham
			CPLabel.TextXAlignment = Enum.TextXAlignment.Left
			CPLabel.TextTruncate = Enum.TextTruncate.AtEnd
			CPLabel.Parent = CPFrame

			local ColorPreview = Instance.new("TextButton")
			ColorPreview.Size = UDim2.new(0, 30, 0, 22)
			ColorPreview.Position = UDim2.new(1, -40, 0, 7)
			ColorPreview.BackgroundColor3 = defaultColor
			ColorPreview.BorderSizePixel = 0
			ColorPreview.Text = ""
			ColorPreview.Parent = CPFrame

			local CPrCorner = Instance.new("UICorner")
			CPrCorner.CornerRadius = UDim.new(0, 6)
			CPrCorner.Parent = ColorPreview

			local CPrStroke = Instance.new("UIStroke")
			CPrStroke.Color = CurrentTheme.BorderColor
			CPrStroke.Thickness = 1
			CPrStroke.Parent = ColorPreview

			-- Expanded picker
			local PickerArea = Instance.new("Frame")
			PickerArea.Size = UDim2.new(1, -20, 0, 110)
			PickerArea.Position = UDim2.new(0, 10, 0, 42)
			PickerArea.BackgroundTransparency = 1
			PickerArea.Visible = false
			PickerArea.Parent = CPFrame

			local currentColor = defaultColor
			local currentHue, currentSat, currentVal = Color3.toHSV(defaultColor)
			local expanded = false

			-- Hue bar
			local HueBar = Instance.new("Frame")
			HueBar.Size = UDim2.new(1, 0, 0, 16)
			HueBar.Position = UDim2.new(0, 0, 0, 0)
			HueBar.BackgroundColor3 = Color3.new(1,1,1)
			HueBar.BorderSizePixel = 0
			HueBar.Parent = PickerArea

			Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)

			local HueGrad = Instance.new("UIGradient")
			HueGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
				ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
				ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
				ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
				ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
				ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1)),
			})
			HueGrad.Parent = HueBar

			local HuePointer = Instance.new("Frame")
			HuePointer.Size = UDim2.new(0, 4, 1, 4)
			HuePointer.Position = UDim2.new(currentHue, -2, 0, -2)
			HuePointer.BackgroundColor3 = Color3.new(1,1,1)
			HuePointer.BorderSizePixel = 0
			HuePointer.ZIndex = 3
			HuePointer.Parent = HueBar
			Instance.new("UICorner", HuePointer).CornerRadius = UDim.new(0, 2)
			local hpStroke = Instance.new("UIStroke", HuePointer)
			hpStroke.Color = Color3.new(0,0,0)
			hpStroke.Thickness = 1

			-- SV Pad
			local SVPad = Instance.new("Frame")
			SVPad.Size = UDim2.new(1, 0, 0, 70)
			SVPad.Position = UDim2.new(0, 0, 0, 22)
			SVPad.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
			SVPad.BorderSizePixel = 0
			SVPad.Parent = PickerArea
			Instance.new("UICorner", SVPad).CornerRadius = UDim.new(0, 6)

			local WhiteGrad = Instance.new("UIGradient")
			WhiteGrad.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
			WhiteGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
			WhiteGrad.Parent = SVPad

			local DarkOL = Instance.new("Frame")
			DarkOL.Size = UDim2.new(1, 0, 1, 0)
			DarkOL.BackgroundColor3 = Color3.new(0,0,0)
			DarkOL.BorderSizePixel = 0
			DarkOL.Parent = SVPad
			Instance.new("UICorner", DarkOL).CornerRadius = UDim.new(0, 6)

			local DarkGrad = Instance.new("UIGradient")
			DarkGrad.Color = ColorSequence.new(Color3.new(0,0,0))
			DarkGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
			DarkGrad.Rotation = 90
			DarkGrad.Parent = DarkOL

			local SVPointer = Instance.new("Frame")
			SVPointer.Size = UDim2.new(0, 10, 0, 10)
			SVPointer.Position = UDim2.new(currentSat, -5, 1-currentVal, -5)
			SVPointer.BackgroundColor3 = Color3.new(1,1,1)
			SVPointer.BorderSizePixel = 0
			SVPointer.ZIndex = 3
			SVPointer.Parent = SVPad
			Instance.new("UICorner", SVPointer).CornerRadius = UDim.new(1, 0)
			local svpStroke = Instance.new("UIStroke", SVPointer)
			svpStroke.Color = Color3.new(0,0,0)
			svpStroke.Thickness = 1.5

			local HexLabel = Instance.new("TextLabel")
			HexLabel.Size = UDim2.new(1, 0, 0, 16)
			HexLabel.Position = UDim2.new(0, 0, 0, 94)
			HexLabel.BackgroundTransparency = 1
			HexLabel.Text = string.format("#%02X%02X%02X", defaultColor.R*255, defaultColor.G*255, defaultColor.B*255)
			HexLabel.TextColor3 = CurrentTheme.TextColorDim
			HexLabel.TextSize = 11
			HexLabel.Font = Enum.Font.GothamBold
			HexLabel.TextXAlignment = Enum.TextXAlignment.Center
			HexLabel.Parent = PickerArea

			local function updateColor()
				currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
				ColorPreview.BackgroundColor3 = currentColor
				SVPad.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
				SVPointer.Position = UDim2.new(currentSat, -5, 1-currentVal, -5)
				HuePointer.Position = UDim2.new(currentHue, -2, 0, -2)
				HexLabel.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255)
				callback(currentColor)
			end

			-- Hue input
			local hueInputBtn = Instance.new("TextButton")
			hueInputBtn.Size = UDim2.new(1,0,1,0)
			hueInputBtn.BackgroundTransparency = 1
			hueInputBtn.Text = ""
			hueInputBtn.ZIndex = 4
			hueInputBtn.Parent = HueBar

			local draggingHue = false

			hueInputBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingHue = true
					currentHue = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
					updateColor()
				end
			end)

			-- SV input
			local svInputBtn = Instance.new("TextButton")
			svInputBtn.Size = UDim2.new(1,0,1,0)
			svInputBtn.BackgroundTransparency = 1
			svInputBtn.Text = ""
			svInputBtn.ZIndex = 4
			svInputBtn.Parent = DarkOL

			local draggingSV = false

			svInputBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSV = true
					currentSat = math.clamp((input.Position.X - SVPad.AbsolutePosition.X) / SVPad.AbsoluteSize.X, 0, 1)
					currentVal = 1 - math.clamp((input.Position.Y - SVPad.AbsolutePosition.Y) / SVPad.AbsoluteSize.Y, 0, 1)
					updateColor()
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if draggingHue then
						currentHue = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
						updateColor()
					end
					if draggingSV then
						currentSat = math.clamp((input.Position.X - SVPad.AbsolutePosition.X) / SVPad.AbsoluteSize.X, 0, 1)
						currentVal = 1 - math.clamp((input.Position.Y - SVPad.AbsolutePosition.Y) / SVPad.AbsoluteSize.Y, 0, 1)
						updateColor()
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingHue = false
					draggingSV = false
				end
			end)

			local elementData = {frame = CPFrame, height = ELEMENT_HEIGHT}

			ColorPreview.MouseButton1Click:Connect(function()
				expanded = not expanded
				if expanded then
					elementData.height = ELEMENT_HEIGHT + 125
					CPFrame.ClipsDescendants = false
					PickerArea.Visible = true
					TweenService:Create(CPFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT + 125)}):Play()
					TweenService:Create(CPrStroke, TweenInfo.new(0.15), {Color = CurrentTheme.AccentColor}):Play()
				else
					elementData.height = ELEMENT_HEIGHT
					TweenService:Create(CPFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)}):Play()
					TweenService:Create(CPrStroke, TweenInfo.new(0.15), {Color = CurrentTheme.BorderColor}):Play()
					task.delay(0.25, function()
						if not expanded then
							PickerArea.Visible = false
							CPFrame.ClipsDescendants = true
						end
					end)
				end
				UpdateCanvas()
			end)

			table.insert(elements, elementData)
			UpdateCanvas()

			return {
				GetColor = function() return currentColor end,
				SetColor = function(color)
					currentHue, currentSat, currentVal = Color3.toHSV(color)
					updateColor()
				end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == CPFrame then
							table.remove(elements, i)
							break
						end
					end
					CPFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- LABEL
		-- ═══════════════════════════════════════════════════
		function Tab:CreateLabel(text, labelConfig)
			labelConfig = labelConfig or {}
			local ELEMENT_HEIGHT = labelConfig.Height or 30

			local LabelFrame = Instance.new("Frame")
			LabelFrame.Name = "Label"
			LabelFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			LabelFrame.BackgroundColor3 = labelConfig.Background or Color3.fromRGB(30, 30, 35)
			LabelFrame.BorderSizePixel = 0
			LabelFrame.Parent = TabContent

			Instance.new("UICorner", LabelFrame).CornerRadius = UDim.new(0, 8)

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -20, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.RichText = true
			Label.Text = text
			Label.TextColor3 = labelConfig.TextColor or CurrentTheme.TextColorDim
			Label.TextSize = labelConfig.TextSize or 13
			Label.Font = labelConfig.Font or Enum.Font.GothamSemibold
			Label.TextXAlignment = labelConfig.Alignment or Enum.TextXAlignment.Center
			Label.TextTruncate = Enum.TextTruncate.AtEnd
			Label.Parent = LabelFrame

			table.insert(elements, {frame = LabelFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				SetText = function(newText) Label.Text = newText end,
				SetColor = function(color) Label.TextColor3 = color end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == LabelFrame then
							table.remove(elements, i)
							break
						end
					end
					LabelFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- SEPARATOR
		-- ═══════════════════════════════════════════════════
		function Tab:CreateSeparator(sepConfig)
			sepConfig = sepConfig or {}
			local ELEMENT_HEIGHT = 10

			local SepFrame = Instance.new("Frame")
			SepFrame.Name = "Separator"
			SepFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			SepFrame.BackgroundTransparency = 1
			SepFrame.Parent = TabContent

			local Line = Instance.new("Frame")
			Line.Size = UDim2.new(1, -20, 0, 1)
			Line.Position = UDim2.new(0, 10, 0.5, 0)
			Line.BackgroundColor3 = sepConfig.Color or CurrentTheme.SeparatorColor
			Line.BorderSizePixel = 0
			Line.Parent = SepFrame

			table.insert(elements, {frame = SepFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()
		end

		-- ═══════════════════════════════════════════════════
		-- PROGRESS BAR
		-- ═══════════════════════════════════════════════════
		function Tab:CreateProgressBar(pbConfig)
			pbConfig = pbConfig or {}
			local name = pbConfig.Name or "Progress"
			local maxValue = pbConfig.Max or 100
			local colors = pbConfig.Colors or {}

			local ELEMENT_HEIGHT = 42

			local PBFrame = Instance.new("Frame")
			PBFrame.Name = name
			PBFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			PBFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			PBFrame.BorderSizePixel = 0
			PBFrame.Parent = TabContent

			Instance.new("UICorner", PBFrame).CornerRadius = UDim.new(0, 8)

			local PBLabel = Instance.new("TextLabel")
			PBLabel.Size = UDim2.new(0.65, 0, 0, 18)
			PBLabel.Position = UDim2.new(0, 12, 0, 4)
			PBLabel.BackgroundTransparency = 1
			PBLabel.RichText = true
			PBLabel.Text = name
			PBLabel.TextColor3 = CurrentTheme.TextColorSecondary
			PBLabel.TextSize = 13
			PBLabel.Font = Enum.Font.Gotham
			PBLabel.TextXAlignment = Enum.TextXAlignment.Left
			PBLabel.Parent = PBFrame

			local PBPercent = Instance.new("TextLabel")
			PBPercent.Size = UDim2.new(0.35, -12, 0, 18)
			PBPercent.Position = UDim2.new(0.65, 0, 0, 4)
			PBPercent.BackgroundTransparency = 1
			PBPercent.Text = "0%"
			PBPercent.TextColor3 = colors.Text or CurrentTheme.AccentColor
			PBPercent.TextSize = 13
			PBPercent.Font = Enum.Font.GothamBold
			PBPercent.TextXAlignment = Enum.TextXAlignment.Right
			PBPercent.Parent = PBFrame

			local BarBG = Instance.new("Frame")
			BarBG.Size = UDim2.new(1, -24, 0, 8)
			BarBG.Position = UDim2.new(0, 12, 0, 28)
			BarBG.BackgroundColor3 = colors.Background or CurrentTheme.SliderBackground
			BarBG.BorderSizePixel = 0
			BarBG.Parent = PBFrame
			Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

			local BarFill = Instance.new("Frame")
			BarFill.Size = UDim2.new(0, 0, 1, 0)
			BarFill.BackgroundColor3 = colors.Fill or CurrentTheme.AccentColor
			BarFill.BorderSizePixel = 0
			BarFill.Parent = BarBG
			Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

			table.insert(elements, {frame = PBFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				SetValue = function(value)
					value = math.clamp(value, 0, maxValue)
					local pct = value / maxValue
					TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
					PBPercent.Text = math.floor(pct * 100) .. "%"
				end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == PBFrame then
							table.remove(elements, i)
							break
						end
					end
					PBFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- MULTI-TOGGLE
		-- ═══════════════════════════════════════════════════
		function Tab:CreateMultiToggle(mtConfig)
			mtConfig = mtConfig or {}
			local name = mtConfig.Name or "Multi Toggle"
			local options = mtConfig.Options or {}
			local defaults = mtConfig.Defaults or {}
			local callback = mtConfig.Callback or function() end
			local colors = mtConfig.Colors or {}

			local OPTION_HEIGHT = 28
			local ELEMENT_HEIGHT = 30 + (#options * (OPTION_HEIGHT + 4))

			local MTFrame = Instance.new("Frame")
			MTFrame.Name = name
			MTFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			MTFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			MTFrame.BorderSizePixel = 0
			MTFrame.Parent = TabContent

			Instance.new("UICorner", MTFrame).CornerRadius = UDim.new(0, 8)

			local MTLabel = Instance.new("TextLabel")
			MTLabel.Size = UDim2.new(1, -20, 0, 26)
			MTLabel.Position = UDim2.new(0, 12, 0, 2)
			MTLabel.BackgroundTransparency = 1
			MTLabel.RichText = true
			MTLabel.Text = name
			MTLabel.TextColor3 = CurrentTheme.TextColorSecondary
			MTLabel.TextSize = 14
			MTLabel.Font = Enum.Font.GothamSemibold
			MTLabel.TextXAlignment = Enum.TextXAlignment.Left
			MTLabel.Parent = MTFrame

			local selectedOptions = {}
			for _, d in ipairs(defaults) do
				if table.find(options, d) then
					table.insert(selectedOptions, d)
				end
			end

			for i, option in ipairs(options) do
				local yPos = 28 + ((i-1) * (OPTION_HEIGHT + 4))
				local isDefault = table.find(defaults, option) ~= nil

				local OptFrame = Instance.new("Frame")
				OptFrame.Size = UDim2.new(1, -20, 0, OPTION_HEIGHT)
				OptFrame.Position = UDim2.new(0, 10, 0, yPos)
				OptFrame.BackgroundColor3 = CurrentTheme.InputBackground
				OptFrame.BorderSizePixel = 0
				OptFrame.Parent = MTFrame
				Instance.new("UICorner", OptFrame).CornerRadius = UDim.new(0, 5)

				local Checkbox = Instance.new("Frame")
				Checkbox.Size = UDim2.new(0, 16, 0, 16)
				Checkbox.Position = UDim2.new(0, 6, 0.5, -8)
				Checkbox.BackgroundColor3 = isDefault and (colors.CheckedColor or CurrentTheme.AccentColor) or CurrentTheme.ToggleOff
				Checkbox.BorderSizePixel = 0
				Checkbox.Parent = OptFrame
				Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(0, 4)

				local Checkmark = Instance.new("TextLabel")
				Checkmark.Size = UDim2.new(1, 0, 1, 0)
				Checkmark.BackgroundTransparency = 1
				Checkmark.Text = isDefault and "✓" or ""
				Checkmark.TextColor3 = CurrentTheme.TextColor
				Checkmark.TextSize = 12
				Checkmark.Font = Enum.Font.GothamBold
				Checkmark.Parent = Checkbox

				local OptLabel = Instance.new("TextLabel")
				OptLabel.Size = UDim2.new(1, -30, 1, 0)
				OptLabel.Position = UDim2.new(0, 28, 0, 0)
				OptLabel.BackgroundTransparency = 1
				OptLabel.RichText = true
				OptLabel.Text = option
				OptLabel.TextColor3 = isDefault and CurrentTheme.TextColor or CurrentTheme.TextColorDim
				OptLabel.TextSize = 13
				OptLabel.Font = Enum.Font.Gotham
				OptLabel.TextXAlignment = Enum.TextXAlignment.Left
				OptLabel.Parent = OptFrame

				local OptClick = Instance.new("TextButton")
				OptClick.Size = UDim2.new(1,0,1,0)
				OptClick.BackgroundTransparency = 1
				OptClick.Text = ""
				OptClick.Parent = OptFrame

				local checked = isDefault

				OptClick.MouseButton1Click:Connect(function()
					checked = not checked
					if checked then
						table.insert(selectedOptions, option)
						TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = colors.CheckedColor or CurrentTheme.AccentColor}):Play()
						Checkmark.Text = "✓"
						TweenService:Create(OptLabel, TweenInfo.new(0.15), {TextColor3 = CurrentTheme.TextColor}):Play()
					else
						for j, v in ipairs(selectedOptions) do
							if v == option then table.remove(selectedOptions, j) break end
						end
						TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ToggleOff}):Play()
						Checkmark.Text = ""
						TweenService:Create(OptLabel, TweenInfo.new(0.15), {TextColor3 = CurrentTheme.TextColorDim}):Play()
					end
					callback(selectedOptions)
				end)

				OptClick.MouseEnter:Connect(function()
					TweenService:Create(OptFrame, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.InputBackgroundHover}):Play()
				end)
				OptClick.MouseLeave:Connect(function()
					TweenService:Create(OptFrame, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.InputBackground}):Play()
				end)
			end

			if #defaults > 0 then
				task.spawn(function() callback(selectedOptions) end)
			end

			table.insert(elements, {frame = MTFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				GetSelected = function() return selectedOptions end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == MTFrame then
							table.remove(elements, i)
							break
						end
					end
					MTFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		-- ═══════════════════════════════════════════════════
		-- PARAGRAPH (Çok satırlı metin kutusu)
		-- ═══════════════════════════════════════════════════
		function Tab:CreateParagraph(pConfig)
			pConfig = pConfig or {}
			local title = pConfig.Title or "Info"
			local content = pConfig.Content or ""

			local ELEMENT_HEIGHT = pConfig.Height or 70

			local PFrame = Instance.new("Frame")
			PFrame.Name = title
			PFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
			PFrame.BackgroundColor3 = CurrentTheme.ElementBackground
			PFrame.BorderSizePixel = 0
			PFrame.Parent = TabContent

			Instance.new("UICorner", PFrame).CornerRadius = UDim.new(0, 8)

			local PTitle = Instance.new("TextLabel")
			PTitle.Size = UDim2.new(1, -20, 0, 22)
			PTitle.Position = UDim2.new(0, 12, 0, 4)
			PTitle.BackgroundTransparency = 1
			PTitle.RichText = true
			PTitle.Text = "<b>" .. title .. "</b>"
			PTitle.TextColor3 = CurrentTheme.TextColor
			PTitle.TextSize = 14
			PTitle.Font = Enum.Font.Gotham
			PTitle.TextXAlignment = Enum.TextXAlignment.Left
			PTitle.Parent = PFrame

			local PContent = Instance.new("TextLabel")
			PContent.Size = UDim2.new(1, -20, 1, -28)
			PContent.Position = UDim2.new(0, 12, 0, 26)
			PContent.BackgroundTransparency = 1
			PContent.RichText = true
			PContent.Text = content
			PContent.TextColor3 = CurrentTheme.TextColorDim
			PContent.TextSize = 12
			PContent.Font = Enum.Font.Gotham
			PContent.TextXAlignment = Enum.TextXAlignment.Left
			PContent.TextYAlignment = Enum.TextYAlignment.Top
			PContent.TextWrapped = true
			PContent.Parent = PFrame

			table.insert(elements, {frame = PFrame, height = ELEMENT_HEIGHT})
			UpdateCanvas()

			return {
				SetTitle = function(t) PTitle.Text = "<b>" .. t .. "</b>" end,
				SetContent = function(c) PContent.Text = c end,
				Destroy = function()
					for i, v in ipairs(elements) do
						if v.frame == PFrame then
							table.remove(elements, i)
							break
						end
					end
					PFrame:Destroy()
					UpdateCanvas()
				end
			}
		end

		return Tab
	end

	-- ═══════════════════════════════════════════════════
	-- WINDOW METODLARı
	-- ═══════════════════════════════════════════════════
	function Window:SetTitle(newTitle)
		Title.Text = newTitle
	end

	function Window:Destroy()
		ScreenGui:Destroy()
	end

	function Window:SetTheme(themeTable)
		for k, v in pairs(themeTable) do
			if CurrentTheme[k] ~= nil then
				CurrentTheme[k] = v
			end
		end
	end

	function Window:Notify(title, message, duration, notifType)
		ToggleLib:Notify(title, message, duration, notifType)
	end

	return Window
end

-- Theme getter
function ToggleLib:GetTheme()
	return CurrentTheme
end

function ToggleLib:SetTheme(themeTable)
	for k, v in pairs(themeTable) do
		if CurrentTheme[k] ~= nil then
			CurrentTheme[k] = v
		end
	end
end

function ToggleLib:Destroy()
	ScreenGui:Destroy()
end

return ToggleLib
