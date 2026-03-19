-- ToggleLib v2.0 - Geliştirilmiş
local ToggleLib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- UI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToggleLibV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Executor desteği
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
NotificationContainer.Size = UDim2.new(0, 260, 1, 0)
NotificationContainer.Position = UDim2.new(1, -270, 0, 0)
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
        info = Color3.fromRGB(0, 150, 220),
        success = Color3.fromRGB(0, 180, 100),
        warning = Color3.fromRGB(220, 160, 0),
        error = Color3.fromRGB(220, 50, 50)
    }

    local icons = {
        info = "ℹ️",
        success = "✅",
        warning = "⚠️",
        error = "❌"
    }

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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
    NTitle.Text = (icons[notifType] or "ℹ️") .. " " .. title
    NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NTitle.TextSize = 14
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.TextTransparency = 1
    NTitle.Parent = NotifFrame

    local NMessage = Instance.new("TextLabel")
    NMessage.Size = UDim2.new(1, -25, 0, 25)
    NMessage.Position = UDim2.new(0, 16, 0, 27)
    NMessage.BackgroundTransparency = 1
    NMessage.Text = message
    NMessage.TextColor3 = Color3.fromRGB(170, 170, 175)
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

    -- Progress bar animasyonu
    task.delay(0.4, function()
        TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    end)

    -- Çıkış animasyonu
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
-- ANA FRAME
-- ═══════════════════════════════════════════════════════════

-- Dropdown overlay (en üstte, tüm dropdownlar burada açılır)
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 40)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Sürükleme sistemi (Draggable yerine manual)
local dragging = false
local dragInput, dragStart, startPos

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

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
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -36, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
end)
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 300, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.35)
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.Position = UDim2.new(1, -66, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
end)
MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
end)

-- ═══════════════════════════════════════════════════════════
-- SCROLLABLE CONTAINER (Ana içerik alanı scroll destekli)
-- ═══════════════════════════════════════════════════════════
local MAX_VISIBLE_HEIGHT = 400

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Size = UDim2.new(1, -16, 0, 0)
ScrollContainer.Position = UDim2.new(0, 8, 0, 45)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 130)
ScrollContainer.ScrollBarImageTransparency = 0.3
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.None
ScrollContainer.ClipsDescendants = true
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollContainer

local ContainerPadding = Instance.new("UIPadding")
ContainerPadding.PaddingRight = UDim.new(0, 4)
ContainerPadding.Parent = ScrollContainer

-- Değişkenler
local elements = {}
local isMinimized = false
local originalHeight = 40

-- Frame boyutunu güncelle
local function UpdateSize()
    if isMinimized then return end

    local totalHeight = 0
    for _, data in ipairs(elements) do
        totalHeight = totalHeight + data.height + 6 -- padding dahil
    end
    if #elements > 0 then
        totalHeight = totalHeight - 6 -- son elemandan sonra padding yok
    end

    local visibleHeight = math.min(totalHeight, MAX_VISIBLE_HEIGHT)
    local newFrameHeight = 55 + visibleHeight

    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

    TweenService:Create(ScrollContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = UDim2.new(1, -16, 0, visibleHeight)
    }):Play()

    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = UDim2.new(0, 300, 0, newFrameHeight)
    }):Play()

    originalHeight = newFrameHeight
end

-- Minimize fonksiyonu
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, 40)}):Play()
        TweenService:Create(ScrollContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -16, 0, 0)}):Play()
        MinimizeButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, originalHeight)}):Play()
        -- visibleHeight hesapla
        local totalHeight = 0
        for _, data in ipairs(elements) do
            totalHeight = totalHeight + data.height + 6
        end
        if #elements > 0 then totalHeight = totalHeight - 6 end
        local visibleHeight = math.min(totalHeight, MAX_VISIBLE_HEIGHT)
        TweenService:Create(ScrollContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -16, 0, visibleHeight)}):Play()
        MinimizeButton.Text = "−"
    end
end)

-- Keybind ile toggle
local toggleKey = Enum.KeyCode.RightControl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, 40)}):Play()
            TweenService:Create(ScrollContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -16, 0, 0)}):Play()
            MinimizeButton.Text = "+"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, originalHeight)}):Play()
            local totalHeight = 0
            for _, data in ipairs(elements) do
                totalHeight = totalHeight + data.height + 6
            end
            if #elements > 0 then totalHeight = totalHeight - 6 end
            local visibleHeight = math.min(totalHeight, MAX_VISIBLE_HEIGHT)
            TweenService:Create(ScrollContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -16, 0, visibleHeight)}):Play()
            MinimizeButton.Text = "−"
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- TOGGLE OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateToggle(name, callback)
    local ELEMENT_HEIGHT = 34

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollContainer

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 44, 0, 22)
    ToggleButton.Position = UDim2.new(1, -52, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton

    local Circle = Instance.new("Frame")
    Circle.Name = "Circle"
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 2, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleButton

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local Clickable = Instance.new("TextButton")
    Clickable.Size = UDim2.new(1, 0, 1, 0)
    Clickable.BackgroundTransparency = 1
    Clickable.Text = ""
    Clickable.Parent = ToggleFrame

    local toggled = false

    local function setVisual(state)
        local circlePos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local bgColor = state and Color3.fromRGB(0, 180, 130) or Color3.fromRGB(55, 55, 60)
        local circleColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        local textColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220)

        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(ToggleLabel, TweenInfo.new(0.2), {TextColor3 = textColor}):Play()
    end

    Clickable.MouseButton1Click:Connect(function()
        toggled = not toggled
        setVisual(toggled)
        callback(toggled)
    end)

    -- Hover efekti
    Clickable.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 46)}):Play()
    end)
    Clickable.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
    end)

    table.insert(elements, {frame = ToggleFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        SetValue = function(value)
            toggled = value
            setVisual(toggled)
            callback(toggled)
        end,
        GetValue = function()
            return toggled
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == ToggleFrame then
                    table.remove(elements, i)
                    break
                end
            end
            ToggleFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- BUTTON OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateButton(name, callback)
    local ELEMENT_HEIGHT = 34

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name
    ButtonFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ScrollContainer

    local BFCorner = Instance.new("UICorner")
    BFCorner.CornerRadius = UDim.new(0, 8)
    BFCorner.Parent = ButtonFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -16, 1, -8)
    Button.Position = UDim2.new(0, 8, 0, 4)
    Button.BackgroundColor3 = Color3.fromRGB(0, 150, 110)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = ButtonFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 110, 80)}):Play()
        task.wait(0.08)
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 150, 110)}):Play()
        callback()
    end)

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 170, 125)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 150, 110)}):Play()
    end)

    table.insert(elements, {frame = ButtonFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        SetText = function(text)
            Button.Text = text
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == ButtonFrame then
                    table.remove(elements, i)
                    break
                end
            end
            ButtonFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- TEXTBOX OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateTextBox(name, placeholder, callback)
    local ELEMENT_HEIGHT = 34

    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = name
    TextBoxFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Parent = ScrollContainer

    local TBFCorner = Instance.new("UICorner")
    TBFCorner.CornerRadius = UDim.new(0, 8)
    TBFCorner.Parent = TextBoxFrame

    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Size = UDim2.new(0.4, -10, 1, 0)
    TextBoxLabel.Position = UDim2.new(0, 12, 0, 0)
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Text = name
    TextBoxLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TextBoxLabel.TextSize = 14
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextBoxLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TextBoxLabel.Parent = TextBoxFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.55, -10, 0, 24)
    TextBox.Position = UDim2.new(0.45, 0, 0.5, -12)
    TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    TextBox.BorderSizePixel = 0
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder or "Enter text..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 13
    TextBox.Font = Enum.Font.Gotham
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = TextBoxFrame

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 6)
    TBCorner.Parent = TextBox

    local TBStroke = Instance.new("UIStroke")
    TBStroke.Color = Color3.fromRGB(60, 60, 70)
    TBStroke.Thickness = 1
    TBStroke.Parent = TextBox

    TextBox.Focused:Connect(function()
        TweenService:Create(TBStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 180, 130)}):Play()
    end)

    TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(TBStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 70)}):Play()
        if enterPressed then
            callback(TextBox.Text)
        end
    end)

    table.insert(elements, {frame = TextBoxFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        GetText = function()
            return TextBox.Text
        end,
        SetText = function(text)
            TextBox.Text = text
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == TextBoxFrame then
                    table.remove(elements, i)
                    break
                end
            end
            TextBoxFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- DROPDOWN OLUŞTURMA (OVERLAY SİSTEMİ İLE)
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateDropdown(name, options, callback)
    local ELEMENT_HEIGHT = 34

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = ScrollContainer

    local DFCorner = Instance.new("UICorner")
    DFCorner.CornerRadius = UDim.new(0, 8)
    DFCorner.Parent = DropdownFrame

    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.4, -10, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = name
    DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownLabel.Parent = DropdownFrame

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0.55, -10, 0, 24)
    DropdownButton.Position = UDim2.new(0.45, 0, 0.5, -12)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = "Select..."
    DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropdownButton.TextSize = 13
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Parent = DropdownFrame

    local DBCorner = Instance.new("UICorner")
    DBCorner.CornerRadius = UDim.new(0, 6)
    DBCorner.Parent = DropdownButton

    local DBStroke = Instance.new("UIStroke")
    DBStroke.Color = Color3.fromRGB(60, 60, 70)
    DBStroke.Thickness = 1
    DBStroke.Parent = DropdownButton

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -22, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.TextSize = 10
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = DropdownButton

    -- Overlay üzerinde açılan dropdown listesi
    local maxVisibleOptions = 6
    local optionHeight = 30
    local containerHeight = math.min(#options, maxVisibleOptions) * optionHeight

    local OptionsScroll = Instance.new("ScrollingFrame")
    OptionsScroll.Size = UDim2.new(0, 150, 0, containerHeight)
    OptionsScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    OptionsScroll.BorderSizePixel = 0
    OptionsScroll.Visible = false
    OptionsScroll.ZIndex = 110
    OptionsScroll.ScrollBarThickness = 3
    OptionsScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 130)
    OptionsScroll.ScrollBarImageTransparency = 0.2
    OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #options * optionHeight)
    OptionsScroll.Parent = DropdownOverlay

    local OSCorner = Instance.new("UICorner")
    OSCorner.CornerRadius = UDim.new(0, 6)
    OSCorner.Parent = OptionsScroll

    local OSStroke = Instance.new("UIStroke")
    OSStroke.Color = Color3.fromRGB(0, 180, 130)
    OSStroke.Thickness = 1
    OSStroke.Parent = OptionsScroll

    local OSShadow = Instance.new("ImageLabel")
    OSShadow.Name = "Shadow"
    OSShadow.Size = UDim2.new(1, 12, 1, 12)
    OSShadow.Position = UDim2.new(0, -6, 0, -6)
    OSShadow.BackgroundTransparency = 1
    OSShadow.Image = "rbxassetid://5554236805"
    OSShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    OSShadow.ImageTransparency = 0.6
    OSShadow.ScaleType = Enum.ScaleType.Slice
    OSShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    OSShadow.ZIndex = 109
    OSShadow.Parent = OptionsScroll

    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Parent = OptionsScroll

    local isOpen = false
    local selectedOption = nil

    local function closeDropdown()
        isOpen = false
        OptionsScroll.Visible = false
        DropdownOverlay.Visible = false
        Arrow.Text = "▼"
        TweenService:Create(DBStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(60, 60, 70)}):Play()
    end

    local function populateOptions(opts)
        for _, child in ipairs(OptionsScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local totalH = #opts * optionHeight
        OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, totalH)
        local newContainerH = math.min(#opts, maxVisibleOptions) * optionHeight
        OptionsScroll.Size = UDim2.new(0, 150, 0, newContainerH)

        for _, option in ipairs(opts) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, optionHeight)
            OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = "  " .. option
            OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptionButton.TextSize = 13
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextXAlignment = Enum.TextXAlignment.Left
            OptionButton.ZIndex = 111
            OptionButton.Parent = OptionsScroll

            if option == selectedOption then
                OptionButton.BackgroundColor3 = Color3.fromRGB(0, 140, 100)
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            OptionButton.MouseEnter:Connect(function()
                if option ~= selectedOption then
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 56)}):Play()
                end
            end)

            OptionButton.MouseLeave:Connect(function()
                if option ~= selectedOption then
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                else
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 140, 100)}):Play()
                end
            end)

            OptionButton.MouseButton1Click:Connect(function()
                selectedOption = option
                DropdownButton.Text = option
                closeDropdown()
                callback(option)
            end)
        end
    end

    populateOptions(options)

    DropdownButton.MouseButton1Click:Connect(function()
        if isOpen then
            closeDropdown()
            return
        end

        -- Diğer açık dropdown varsa kapat
        if activeDropdownClose then
            activeDropdownClose()
        end

        isOpen = true
        DropdownOverlay.Visible = true
        Arrow.Text = "▲"
        TweenService:Create(DBStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 180, 130)}):Play()

        -- Dropdown butonunun ekran pozisyonunu bul
        local absPos = DropdownButton.AbsolutePosition
        local absSize = DropdownButton.AbsoluteSize
        OptionsScroll.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
        OptionsScroll.Size = UDim2.new(0, absSize.X, 0, math.min(#options, maxVisibleOptions) * optionHeight)
        OptionsScroll.Visible = true

        populateOptions(options)

        activeDropdownClose = closeDropdown
    end)

    -- Hover efekti
    DropdownButton.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 56)}):Play()
        end
    end)
    DropdownButton.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
        end
    end)

    table.insert(elements, {frame = DropdownFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        GetSelected = function()
            return selectedOption
        end,
        SetSelected = function(option)
            if table.find(options, option) then
                selectedOption = option
                DropdownButton.Text = option
                callback(option)
            end
        end,
        UpdateOptions = function(newOptions)
            options = newOptions
            populateOptions(options)
            if selectedOption and not table.find(options, selectedOption) then
                selectedOption = nil
                DropdownButton.Text = "Select..."
            end
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == DropdownFrame then
                    table.remove(elements, i)
                    break
                end
            end
            DropdownFrame:Destroy()
            OptionsScroll:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- SLIDER OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateSlider(name, min, max, default, callback)
    local ELEMENT_HEIGHT = 50
    min = min or 0
    max = max or 100
    default = default or min

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollContainer

    local SFCorner = Instance.new("UICorner")
    SFCorner.CornerRadius = UDim.new(0, 8)
    SFCorner.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.65, -10, 0, 22)
    SliderLabel.Position = UDim2.new(0, 12, 0, 4)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
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
    ValueLabel.TextColor3 = Color3.fromRGB(0, 200, 150)
    ValueLabel.TextSize = 14
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, -24, 0, 6)
    SliderBG.Position = UDim2.new(0, 12, 0, 34)
    SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame

    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 14, 0, 14)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.BorderSizePixel = 0
    SliderKnob.ZIndex = 2
    SliderKnob.Parent = SliderBG

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SliderKnob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(0, 180, 130)
    KnobStroke.Thickness = 2
    KnobStroke.Parent = SliderKnob

    local currentValue = default
    local sliding = false

    local SliderClickArea = Instance.new("TextButton")
    SliderClickArea.Size = UDim2.new(1, 0, 0, 20)
    SliderClickArea.Position = UDim2.new(0, 0, 0, 27)
    SliderClickArea.BackgroundTransparency = 1
    SliderClickArea.Text = ""
    SliderClickArea.Parent = SliderFrame

    local function updateSlider(input)
        local sliderAbsPos = SliderBG.AbsolutePosition
        local sliderAbsSize = SliderBG.AbsoluteSize

        local relativeX = math.clamp((input.Position.X - sliderAbsPos.X) / sliderAbsSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * relativeX)

        local fillSize = (currentValue - min) / (max - min)
        TweenService:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(fillSize, 0, 1, 0)}):Play()
        TweenService:Create(SliderKnob, TweenInfo.new(0.05), {Position = UDim2.new(fillSize, -7, 0.5, -7)}):Play()
        ValueLabel.Text = tostring(currentValue)
        callback(currentValue)
    end

    SliderClickArea.InputBegan:Connect(function(input)
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
    UpdateSize()

    return {
        SetValue = function(value)
            currentValue = math.clamp(math.floor(value), min, max)
            local fillSize = (currentValue - min) / (max - min)
            SliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
            SliderKnob.Position = UDim2.new(fillSize, -7, 0.5, -7)
            ValueLabel.Text = tostring(currentValue)
            callback(currentValue)
        end,
        GetValue = function()
            return currentValue
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == SliderFrame then
                    table.remove(elements, i)
                    break
                end
            end
            SliderFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- KEYBIND OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateKeybind(name, defaultKey, callback)
    local ELEMENT_HEIGHT = 34
    defaultKey = defaultKey or Enum.KeyCode.Unknown

    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = name
    KeybindFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    KeybindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    KeybindFrame.BorderSizePixel = 0
    KeybindFrame.Parent = ScrollContainer

    local KFCorner = Instance.new("UICorner")
    KFCorner.CornerRadius = UDim.new(0, 8)
    KFCorner.Parent = KeybindFrame

    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
    KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = name
    KeybindLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    KeybindLabel.TextSize = 14
    KeybindLabel.Font = Enum.Font.Gotham
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.TextTruncate = Enum.TextTruncate.AtEnd
    KeybindLabel.Parent = KeybindFrame

    local KeyButton = Instance.new("TextButton")
    KeyButton.Size = UDim2.new(0, 60, 0, 24)
    KeyButton.Position = UDim2.new(1, -68, 0.5, -12)
    KeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    KeyButton.BorderSizePixel = 0
    KeyButton.Text = defaultKey == Enum.KeyCode.Unknown and "None" or defaultKey.Name
    KeyButton.TextColor3 = Color3.fromRGB(0, 200, 150)
    KeyButton.TextSize = 12
    KeyButton.Font = Enum.Font.GothamBold
    KeyButton.Parent = KeybindFrame

    local KBCorner = Instance.new("UICorner")
    KBCorner.CornerRadius = UDim.new(0, 6)
    KBCorner.Parent = KeyButton

    local KBStroke = Instance.new("UIStroke")
    KBStroke.Color = Color3.fromRGB(60, 60, 70)
    KBStroke.Thickness = 1
    KBStroke.Parent = KeyButton

    local currentKey = defaultKey
    local listening = false

    KeyButton.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        KeyButton.Text = "..."
        TweenService:Create(KBStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 180, 130)}):Play()
        TweenService:Create(KeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not listening then
            -- Keybind tetikleme
            if input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown and not gameProcessed then
                callback(currentKey)
            end
            return
        end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                currentKey = Enum.KeyCode.Unknown
                KeyButton.Text = "None"
            else
                currentKey = input.KeyCode
                KeyButton.Text = input.KeyCode.Name
            end
            listening = false
            TweenService:Create(KBStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(KeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
        end
    end)

    table.insert(elements, {frame = KeybindFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        GetKey = function()
            return currentKey
        end,
        SetKey = function(key)
            currentKey = key
            KeyButton.Text = key == Enum.KeyCode.Unknown and "None" or key.Name
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == KeybindFrame then
                    table.remove(elements, i)
                    break
                end
            end
            KeybindFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- COLOR PICKER OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateColorPicker(name, defaultColor, callback)
    local ELEMENT_HEIGHT = 34
    defaultColor = defaultColor or Color3.fromRGB(255, 0, 0)

    local CPFrame = Instance.new("Frame")
    CPFrame.Name = name
    CPFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    CPFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    CPFrame.BorderSizePixel = 0
    CPFrame.ClipsDescendants = true
    CPFrame.Parent = ScrollContainer

    local CPCorner = Instance.new("UICorner")
    CPCorner.CornerRadius = UDim.new(0, 8)
    CPCorner.Parent = CPFrame

    local CPLabel = Instance.new("TextLabel")
    CPLabel.Size = UDim2.new(1, -50, 0, ELEMENT_HEIGHT)
    CPLabel.Position = UDim2.new(0, 12, 0, 0)
    CPLabel.BackgroundTransparency = 1
    CPLabel.Text = name
    CPLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    CPLabel.TextSize = 14
    CPLabel.Font = Enum.Font.Gotham
    CPLabel.TextXAlignment = Enum.TextXAlignment.Left
    CPLabel.TextTruncate = Enum.TextTruncate.AtEnd
    CPLabel.Parent = CPFrame

    local ColorPreview = Instance.new("TextButton")
    ColorPreview.Size = UDim2.new(0, 30, 0, 22)
    ColorPreview.Position = UDim2.new(1, -40, 0, 6)
    ColorPreview.BackgroundColor3 = defaultColor
    ColorPreview.BorderSizePixel = 0
    ColorPreview.Text = ""
    ColorPreview.Parent = CPFrame

    local CPrCorner = Instance.new("UICorner")
    CPrCorner.CornerRadius = UDim.new(0, 6)
    CPrCorner.Parent = ColorPreview

    local CPrStroke = Instance.new("UIStroke")
    CPrStroke.Color = Color3.fromRGB(80, 80, 90)
    CPrStroke.Thickness = 1
    CPrStroke.Parent = ColorPreview

    -- Expanded color picker area
    local PickerArea = Instance.new("Frame")
    PickerArea.Size = UDim2.new(1, -20, 0, 110)
    PickerArea.Position = UDim2.new(0, 10, 0, 40)
    PickerArea.BackgroundTransparency = 1
    PickerArea.Visible = false
    PickerArea.Parent = CPFrame

    local currentColor = defaultColor
    local currentHue, currentSat, currentVal = Color3.toHSV(defaultColor)
    local expanded = false

    -- Hue slider
    local HueBar = Instance.new("Frame")
    HueBar.Size = UDim2.new(1, 0, 0, 16)
    HueBar.Position = UDim2.new(0, 0, 0, 0)
    HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueBar.BorderSizePixel = 0
    HueBar.Parent = PickerArea

    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(0, 4)
    HueCorner.Parent = HueBar

    local HueGradient = Instance.new("UIGradient")
    HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
    })
    HueGradient.Parent = HueBar

    local HuePointer = Instance.new("Frame")
    HuePointer.Size = UDim2.new(0, 4, 1, 4)
    HuePointer.Position = UDim2.new(currentHue, -2, 0, -2)
    HuePointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HuePointer.BorderSizePixel = 0
    HuePointer.ZIndex = 3
    HuePointer.Parent = HueBar

    local HPCorner = Instance.new("UICorner")
    HPCorner.CornerRadius = UDim.new(0, 2)
    HPCorner.Parent = HuePointer

    local HPStroke = Instance.new("UIStroke")
    HPStroke.Color = Color3.fromRGB(0, 0, 0)
    HPStroke.Thickness = 1
    HPStroke.Parent = HuePointer

    -- Saturation/Value pad
    local SVPad = Instance.new("Frame")
    SVPad.Size = UDim2.new(1, 0, 0, 70)
    SVPad.Position = UDim2.new(0, 0, 0, 22)
    SVPad.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
    SVPad.BorderSizePixel = 0
    SVPad.Parent = PickerArea

    local SVCorner = Instance.new("UICorner")
    SVCorner.CornerRadius = UDim.new(0, 6)
    SVCorner.Parent = SVPad

    -- Beyaz gradient (soldan sağa saturation)
    local WhiteGrad = Instance.new("UIGradient")
    WhiteGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    WhiteGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    WhiteGrad.Parent = SVPad

    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.Parent = SVPad

    local DOCorner = Instance.new("UICorner")
    DOCorner.CornerRadius = UDim.new(0, 6)
    DOCorner.Parent = DarkOverlay

    local DarkGrad = Instance.new("UIGradient")
    DarkGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
    DarkGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    DarkGrad.Rotation = 90
    DarkGrad.Parent = DarkOverlay

    local SVPointer = Instance.new("Frame")
    SVPointer.Size = UDim2.new(0, 10, 0, 10)
    SVPointer.Position = UDim2.new(currentSat, -5, 1 - currentVal, -5)
    SVPointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SVPointer.BorderSizePixel = 0
    SVPointer.ZIndex = 3
    SVPointer.Parent = SVPad

    local SVPCorner = Instance.new("UICorner")
    SVPCorner.CornerRadius = UDim.new(1, 0)
    SVPCorner.Parent = SVPointer

    local SVPStroke = Instance.new("UIStroke")
    SVPStroke.Color = Color3.fromRGB(0, 0, 0)
    SVPStroke.Thickness = 1.5
    SVPStroke.Parent = SVPointer

    -- Hex label
    local HexLabel = Instance.new("TextLabel")
    HexLabel.Size = UDim2.new(1, 0, 0, 16)
    HexLabel.Position = UDim2.new(0, 0, 0, 94)
    HexLabel.BackgroundTransparency = 1
    HexLabel.Text = string.format("#%02X%02X%02X", math.floor(defaultColor.R * 255), math.floor(defaultColor.G * 255), math.floor(defaultColor.B * 255))
    HexLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
    HexLabel.TextSize = 11
    HexLabel.Font = Enum.Font.GothamBold
    HexLabel.TextXAlignment = Enum.TextXAlignment.Center
    HexLabel.Parent = PickerArea

    local function updateColor()
        currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
        ColorPreview.BackgroundColor3 = currentColor
        SVPad.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
        SVPointer.Position = UDim2.new(currentSat, -5, 1 - currentVal, -5)
        HuePointer.Position = UDim2.new(currentHue, -2, 0, -2)
        HexLabel.Text = string.format("#%02X%02X%02X", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
        callback(currentColor)
    end

    -- Hue dragging
    local hueInput = Instance.new("TextButton")
    hueInput.Size = UDim2.new(1, 0, 1, 0)
    hueInput.BackgroundTransparency = 1
    hueInput.Text = ""
    hueInput.ZIndex = 4
    hueInput.Parent = HueBar

    local draggingHue = false

    hueInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
            currentHue = relX
            updateColor()
        end
    end)

    -- SV dragging
    local svInput = Instance.new("TextButton")
    svInput.Size = UDim2.new(1, 0, 1, 0)
    svInput.BackgroundTransparency = 1
    svInput.Text = ""
    svInput.ZIndex = 4
    svInput.Parent = DarkOverlay

    local draggingSV = false

    svInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
            local relX = math.clamp((input.Position.X - SVPad.AbsolutePosition.X) / SVPad.AbsoluteSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - SVPad.AbsolutePosition.Y) / SVPad.AbsoluteSize.Y, 0, 1)
            currentSat = relX
            currentVal = 1 - relY
            updateColor()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingHue then
                local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                currentHue = relX
                updateColor()
            end
            if draggingSV then
                local relX = math.clamp((input.Position.X - SVPad.AbsolutePosition.X) / SVPad.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - SVPad.AbsolutePosition.Y) / SVPad.AbsoluteSize.Y, 0, 1)
                currentSat = relX
                currentVal = 1 - relY
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

    -- Expand/collapse
    local elementData = {frame = CPFrame, height = ELEMENT_HEIGHT}

    ColorPreview.MouseButton1Click:Connect(function()
        expanded = not expanded

        if expanded then
            elementData.height = ELEMENT_HEIGHT + 120
            CPFrame.ClipsDescendants = false
            PickerArea.Visible = true
            TweenService:Create(CPFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT + 120)}):Play()
            TweenService:Create(CPrStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 180, 130)}):Play()
        else
            elementData.height = ELEMENT_HEIGHT
            TweenService:Create(CPFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)}):Play()
            TweenService:Create(CPrStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(80, 80, 90)}):Play()
            task.delay(0.25, function()
                if not expanded then
                    PickerArea.Visible = false
                    CPFrame.ClipsDescendants = true
                end
            end)
        end

        UpdateSize()
    end)

    table.insert(elements, elementData)
    UpdateSize()

    return {
        GetColor = function()
            return currentColor
        end,
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
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- LABEL OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateLabel(text)
    local ELEMENT_HEIGHT = 30

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "Label"
    LabelFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    LabelFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    LabelFrame.BorderSizePixel = 0
    LabelFrame.Parent = ScrollContainer

    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 8)
    LabelCorner.Parent = LabelFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(160, 160, 165)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = LabelFrame

    table.insert(elements, {frame = LabelFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        SetText = function(newText)
            Label.Text = newText
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == LabelFrame then
                    table.remove(elements, i)
                    break
                end
            end
            LabelFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- SEPARATOR OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateSeparator()
    local ELEMENT_HEIGHT = 8

    local SeparatorFrame = Instance.new("Frame")
    SeparatorFrame.Name = "Separator"
    SeparatorFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    SeparatorFrame.BackgroundTransparency = 1
    SeparatorFrame.Parent = ScrollContainer

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -20, 0, 1)
    Line.Position = UDim2.new(0, 10, 0.5, 0)
    Line.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    Line.BorderSizePixel = 0
    Line.Parent = SeparatorFrame

    table.insert(elements, {frame = SeparatorFrame, height = ELEMENT_HEIGHT})
    UpdateSize()
end

-- ═══════════════════════════════════════════════════════════
-- PROGRESS BAR OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateProgressBar(name, maxValue)
    local ELEMENT_HEIGHT = 40
    maxValue = maxValue or 100

    local PBFrame = Instance.new("Frame")
    PBFrame.Name = name
    PBFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    PBFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    PBFrame.BorderSizePixel = 0
    PBFrame.Parent = ScrollContainer

    local PBFCorner = Instance.new("UICorner")
    PBFCorner.CornerRadius = UDim.new(0, 8)
    PBFCorner.Parent = PBFrame

    local PBLabel = Instance.new("TextLabel")
    PBLabel.Size = UDim2.new(0.65, 0, 0, 18)
    PBLabel.Position = UDim2.new(0, 12, 0, 3)
    PBLabel.BackgroundTransparency = 1
    PBLabel.Text = name
    PBLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    PBLabel.TextSize = 13
    PBLabel.Font = Enum.Font.Gotham
    PBLabel.TextXAlignment = Enum.TextXAlignment.Left
    PBLabel.Parent = PBFrame

    local PBPercent = Instance.new("TextLabel")
    PBPercent.Size = UDim2.new(0.35, -12, 0, 18)
    PBPercent.Position = UDim2.new(0.65, 0, 0, 3)
    PBPercent.BackgroundTransparency = 1
    PBPercent.Text = "0%"
    PBPercent.TextColor3 = Color3.fromRGB(0, 200, 150)
    PBPercent.TextSize = 13
    PBPercent.Font = Enum.Font.GothamBold
    PBPercent.TextXAlignment = Enum.TextXAlignment.Right
    PBPercent.Parent = PBFrame

    local BarBG = Instance.new("Frame")
    BarBG.Size = UDim2.new(1, -24, 0, 8)
    BarBG.Position = UDim2.new(0, 12, 0, 26)
    BarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    BarBG.BorderSizePixel = 0
    BarBG.Parent = PBFrame

    local BarBGCorner = Instance.new("UICorner")
    BarBGCorner.CornerRadius = UDim.new(1, 0)
    BarBGCorner.Parent = BarBG

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBG

    local BarFillCorner = Instance.new("UICorner")
    BarFillCorner.CornerRadius = UDim.new(1, 0)
    BarFillCorner.Parent = BarFill

    local BarGradient = Instance.new("UIGradient")
    BarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 160))
    })
    BarGradient.Parent = BarFill

    table.insert(elements, {frame = PBFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        SetValue = function(value)
            value = math.clamp(value, 0, maxValue)
            local percent = value / maxValue
            TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
            PBPercent.Text = math.floor(percent * 100) .. "%"
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == PBFrame then
                    table.remove(elements, i)
                    break
                end
            end
            PBFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- MULTI-TOGGLE (Checkbox Group) OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateMultiToggle(name, options, callback)
    local OPTION_HEIGHT = 26
    local ELEMENT_HEIGHT = 28 + (#options * (OPTION_HEIGHT + 4))

    local MTFrame = Instance.new("Frame")
    MTFrame.Name = name
    MTFrame.Size = UDim2.new(1, 0, 0, ELEMENT_HEIGHT)
    MTFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MTFrame.BorderSizePixel = 0
    MTFrame.Parent = ScrollContainer

    local MTCorner = Instance.new("UICorner")
    MTCorner.CornerRadius = UDim.new(0, 8)
    MTCorner.Parent = MTFrame

    local MTLabel = Instance.new("TextLabel")
    MTLabel.Size = UDim2.new(1, -20, 0, 24)
    MTLabel.Position = UDim2.new(0, 12, 0, 2)
    MTLabel.BackgroundTransparency = 1
    MTLabel.Text = name
    MTLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    MTLabel.TextSize = 14
    MTLabel.Font = Enum.Font.GothamSemibold
    MTLabel.TextXAlignment = Enum.TextXAlignment.Left
    MTLabel.Parent = MTFrame

    local selectedOptions = {}

    for i, option in ipairs(options) do
        local yPos = 26 + ((i - 1) * (OPTION_HEIGHT + 4))

        local OptionFrame = Instance.new("Frame")
        OptionFrame.Size = UDim2.new(1, -20, 0, OPTION_HEIGHT)
        OptionFrame.Position = UDim2.new(0, 10, 0, yPos)
        OptionFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
        OptionFrame.BorderSizePixel = 0
        OptionFrame.Parent = MTFrame

        local OFCorner = Instance.new("UICorner")
        OFCorner.CornerRadius = UDim.new(0, 5)
        OFCorner.Parent = OptionFrame

        local Checkbox = Instance.new("Frame")
        Checkbox.Size = UDim2.new(0, 16, 0, 16)
        Checkbox.Position = UDim2.new(0, 6, 0.5, -8)
        Checkbox.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        Checkbox.BorderSizePixel = 0
        Checkbox.Parent = OptionFrame

        local CBCorner = Instance.new("UICorner")
        CBCorner.CornerRadius = UDim.new(0, 4)
        CBCorner.Parent = Checkbox

        local Checkmark = Instance.new("TextLabel")
        Checkmark.Size = UDim2.new(1, 0, 1, 0)
        Checkmark.BackgroundTransparency = 1
        Checkmark.Text = ""
        Checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
        Checkmark.TextSize = 12
        Checkmark.Font = Enum.Font.GothamBold
        Checkmark.Parent = Checkbox

        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -30, 1, 0)
        OptionLabel.Position = UDim2.new(0, 28, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = Color3.fromRGB(190, 190, 195)
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.Parent = OptionFrame

        local OptionClick = Instance.new("TextButton")
        OptionClick.Size = UDim2.new(1, 0, 1, 0)
        OptionClick.BackgroundTransparency = 1
        OptionClick.Text = ""
        OptionClick.Parent = OptionFrame

        local checked = false

        OptionClick.MouseButton1Click:Connect(function()
            checked = not checked

            if checked then
                table.insert(selectedOptions, option)
                TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 180, 130)}):Play()
                Checkmark.Text = "✓"
                TweenService:Create(OptionLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                for j, v in ipairs(selectedOptions) do
                    if v == option then
                        table.remove(selectedOptions, j)
                        break
                    end
                end
                TweenService:Create(Checkbox, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
                Checkmark.Text = ""
                TweenService:Create(OptionLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(190, 190, 195)}):Play()
            end

            callback(selectedOptions)
        end)

        OptionClick.MouseEnter:Connect(function()
            TweenService:Create(OptionFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(48, 48, 54)}):Play()
        end)
        OptionClick.MouseLeave:Connect(function()
            TweenService:Create(OptionFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(42, 42, 48)}):Play()
        end)
    end

    table.insert(elements, {frame = MTFrame, height = ELEMENT_HEIGHT})
    UpdateSize()

    return {
        GetSelected = function()
            return selectedOptions
        end,
        Destroy = function()
            for i, v in ipairs(elements) do
                if v.frame == MTFrame then
                    table.remove(elements, i)
                    break
                end
            end
            MTFrame:Destroy()
            UpdateSize()
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- SET TITLE
-- ═══════════════════════════════════════════════════════════
function ToggleLib:SetTitle(newTitle)
    Title.Text = newTitle
end

-- ═══════════════════════════════════════════════════════════
-- DESTROY
-- ═══════════════════════════════════════════════════════════
function ToggleLib:Destroy()
    ScreenGui:Destroy()
end

return ToggleLib
