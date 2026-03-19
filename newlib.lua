-- ToggleLib Oluşturma
local ToggleLib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- UI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToggleLib"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Executor desteği
if syn then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 40)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -40, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Toggle Container
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "ToggleContainer"
ToggleContainer.Size = UDim2.new(1, -20, 0, 0)
ToggleContainer.Position = UDim2.new(0, 10, 0, 45)
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.ClipsDescendants = true
ToggleContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ToggleContainer

-- Değişkenler
local elementCount = 0
local isMinimized = false
local originalSize = nil

-- Frame boyutunu güncelle
local function UpdateSize()
    if not isMinimized then
        local newHeight = 55 + (elementCount * 42)
        MainFrame.Size = UDim2.new(0, 280, 0, newHeight)
        ToggleContainer.Size = UDim2.new(1, -20, 0, elementCount * 42)
        originalSize = MainFrame.Size
    end
end

-- Minimize fonksiyonu
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 280, 0, 40)}):Play()
        TweenService:Create(ToggleContainer, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 0)}):Play()
        MinimizeButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
        TweenService:Create(ToggleContainer, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, elementCount * 42)}):Play()
        MinimizeButton.Text = "−"
    end
end)

-- ═══════════════════════════════════════════════════════════
-- TOGGLE OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateToggle(name, callback)
    elementCount = elementCount + 1

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ToggleContainer

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

    Clickable.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local circlePos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local bgColor = toggled and Color3.fromRGB(0, 180, 130) or Color3.fromRGB(55, 55, 60)
        local circleColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        
        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = bgColor}):Play()
        
        callback(toggled)
    end)

    UpdateSize()
    
    return {
        SetValue = function(value)
            toggled = value
            local circlePos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local bgColor = toggled and Color3.fromRGB(0, 180, 130) or Color3.fromRGB(55, 55, 60)
            local circleColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            Circle.Position = circlePos
            Circle.BackgroundColor3 = circleColor
            ToggleButton.BackgroundColor3 = bgColor
            callback(toggled)
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- BUTTON OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateButton(name, callback)
    elementCount = elementCount + 1

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name
    ButtonFrame.Size = UDim2.new(1, 0, 0, 34)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ToggleContainer

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame

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
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 120, 90)}):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 150, 110)}):Play()
        callback()
    end)

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 125)}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 110)}):Play()
    end)

    UpdateSize()
end

-- ═══════════════════════════════════════════════════════════
-- TEXTBOX OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateTextBox(name, placeholder, callback)
    elementCount = elementCount + 1

    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = name
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 34)
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Parent = ToggleContainer

    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 8)
    TextBoxCorner.Parent = TextBoxFrame

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

    UpdateSize()
    
    return {
        GetText = function()
            return TextBox.Text
        end,
        SetText = function(text)
            TextBox.Text = text
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- DROPDOWN OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateDropdown(name, options, callback)
    elementCount = elementCount + 1

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = ToggleContainer

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame

    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.4, -10, 0, 34)
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
    DropdownButton.Position = UDim2.new(0.45, 0, 0, 5)
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

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -22, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.TextSize = 10
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = DropdownButton

    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Size = UDim2.new(0.55, -10, 0, #options * 28)
    OptionsContainer.Position = UDim2.new(0.45, 0, 0, 32)
    OptionsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.Visible = false
    OptionsContainer.ZIndex = 10
    OptionsContainer.Parent = DropdownFrame

    local OCCorner = Instance.new("UICorner")
    OCCorner.CornerRadius = UDim.new(0, 6)
    OCCorner.Parent = OptionsContainer

    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Parent = OptionsContainer

    local isOpen = false
    local selectedOption = nil

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        OptionButton.BackgroundTransparency = 0
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionButton.TextSize = 13
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.ZIndex = 11
        OptionButton.Parent = OptionsContainer

        if i == 1 then
            local OBCornerTop = Instance.new("UICorner")
            OBCornerTop.CornerRadius = UDim.new(0, 6)
            OBCornerTop.Parent = OptionButton
        elseif i == #options then
            local OBCornerBottom = Instance.new("UICorner")
            OBCornerBottom.CornerRadius = UDim.new(0, 6)
            OBCornerBottom.Parent = OptionButton
        end

        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 150, 110)}):Play()
        end)

        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        end)

        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownButton.Text = option
            isOpen = false
            OptionsContainer.Visible = false
            Arrow.Text = "▼"
            TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 34)}):Play()
            callback(option)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        OptionsContainer.Visible = isOpen
        
        if isOpen then
            Arrow.Text = "▲"
            TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 38 + (#options * 28))}):Play()
        else
            Arrow.Text = "▼"
            TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 34)}):Play()
        end
    end)

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
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- LABEL OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateLabel(text)
    elementCount = elementCount + 1

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "Label"
    LabelFrame.Size = UDim2.new(1, 0, 0, 34)
    LabelFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    LabelFrame.BorderSizePixel = 0
    LabelFrame.Parent = ToggleContainer

    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 8)
    LabelCorner.Parent = LabelFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.Parent = LabelFrame

    UpdateSize()
    
    return {
        SetText = function(newText)
            Label.Text = newText
        end
    }
end

-- ═══════════════════════════════════════════════════════════
-- SEPARATOR OLUŞTURMA
-- ═══════════════════════════════════════════════════════════
function ToggleLib:CreateSeparator()
    elementCount = elementCount + 1

    local SeparatorFrame = Instance.new("Frame")
    SeparatorFrame.Name = "Separator"
    SeparatorFrame.Size = UDim2.new(1, 0, 0, 10)
    SeparatorFrame.BackgroundTransparency = 1
    SeparatorFrame.Parent = ToggleContainer

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -20, 0, 1)
    Line.Position = UDim2.new(0, 10, 0.5, 0)
    Line.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Line.BorderSizePixel = 0
    Line.Parent = SeparatorFrame

    UpdateSize()
end

return ToggleLib
