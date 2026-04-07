--[[
    Aurora UI Library
    Version: 1.0.0
    Author: Your Name
    
    Kullanım:
    local Library = loadstring(game:HttpGet("RAW_GITHUB_LINK"))()
    local Window = Library:CreateWindow("Hub Name")
    local Tab = Window:CreateTab("Tab Name", "rbxassetid://ICON_ID")
    Tab:CreateButton("Button", function() print("Clicked!") end)
]]

local AuroraLibrary = {}
AuroraLibrary.__index = AuroraLibrary

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Settings
local Settings = {
    MainColor = Color3.fromRGB(25, 25, 35),
    SecondaryColor = Color3.fromRGB(30, 30, 45),
    AccentColor = Color3.fromRGB(138, 43, 226), -- Purple
    TextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(175, 175, 175),
    EnableColor = Color3.fromRGB(0, 255, 128),
    DisableColor = Color3.fromRGB(255, 75, 75),
    Font = Enum.Font.GothamBold,
    TweenSpeed = 0.2
}

-- Utility Functions
local function CreateTween(instance, properties, duration)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or Settings.TweenSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    return tween
end

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function AddCorner(instance, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = instance
    })
end

local function AddStroke(instance, color, thickness)
    return CreateInstance("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 80),
        Thickness = thickness or 1,
        Parent = instance
    })
end

local function AddPadding(instance, padding)
    return CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = instance
    })
end

-- Ripple Effect
local function CreateRipple(button)
    button.ClipsDescendants = true
    
    button.MouseButton1Click:Connect(function()
        local mouse = Players.LocalPlayer:GetMouse()
        local ripple = CreateInstance("Frame", {
            Name = "Ripple",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, mouse.X - button.AbsolutePosition.X, 0, mouse.Y - button.AbsolutePosition.Y),
            Size = UDim2.new(0, 0, 0, 0),
            Parent = button
        })
        AddCorner(ripple, 999)
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        local tween = CreateTween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
        tween:Play()
        tween.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Main Library Function
function AuroraLibrary:CreateWindow(title, config)
    config = config or {}
    local windowConfig = {
        Title = title or "Aurora Hub",
        Subtitle = config.Subtitle or "v1.0.0",
        Size = config.Size or UDim2.new(0, 550, 0, 380),
        KeyBind = config.KeyBind or Enum.KeyCode.RightControl
    }
    
    -- Destroy existing GUI
    if CoreGui:FindFirstChild("AuroraUI") then
        CoreGui:FindFirstChild("AuroraUI"):Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "AuroraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Settings.MainColor,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = windowConfig.Size,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 10)
    AddStroke(MainFrame, Settings.AccentColor, 2)
    
    -- Shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 35, 1, 35),
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = MainFrame
    })
    
    -- Top Bar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Settings.SecondaryColor,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = MainFrame
    })
    AddCorner(TopBar, 10)
    
    local TopBarFix = CreateInstance("Frame", {
        Name = "Fix",
        BackgroundColor3 = Settings.SecondaryColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        Parent = TopBar
    })
    
    -- Title
    local TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Settings.Font,
        Text = windowConfig.Title,
        TextColor3 = Settings.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Subtitle
    local SubtitleLabel = CreateInstance("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15 + TitleLabel.TextBounds.X + 8, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = windowConfig.Subtitle,
        TextColor3 = Settings.SecondaryTextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 75, 75),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Settings.Font,
        Text = "",
        Parent = TopBar
    })
    AddCorner(CloseButton, 999)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 200, 75),
        Position = UDim2.new(1, -45, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Settings.Font,
        Text = "",
        Parent = TopBar
    })
    AddCorner(MinimizeButton, 999)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, windowConfig.Size.X.Offset, 0, 45)}):Play()
        else
            CreateTween(MainFrame, {Size = windowConfig.Size}):Play()
        end
    end)
    
    -- Tab Container (Left Side)
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Settings.SecondaryColor,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 140, 1, -45),
        Parent = MainFrame
    })
    
    local TabContainerCorner = CreateInstance("Frame", {
        BackgroundColor3 = Settings.SecondaryColor,
        Position = UDim2.new(1, -10, 0, 0),
        Size = UDim2.new(0, 10, 1, 0),
        BorderSizePixel = 0,
        Parent = TabContainer
    })
    
    local BottomLeftCorner = CreateInstance("Frame", {
        Name = "BottomLeftCorner",
        BackgroundColor3 = Settings.MainColor,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(0, 10, 0, 10),
        BorderSizePixel = 0,
        Parent = TabContainer
    })
    
    local BottomLeftCornerRound = CreateInstance("Frame", {
        BackgroundColor3 = Settings.SecondaryColor,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = BottomLeftCorner
    })
    AddCorner(BottomLeftCornerRound, 10)
    
    local TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 10),
        Size = UDim2.new(1, -10, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Settings.AccentColor,
        Parent = TabContainer
    })
    
    local TabListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabList
    })
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Container (Right Side)
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 145, 0, 50),
        Size = UDim2.new(1, -150, 1, -55),
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Dragging System
    local dragging = false
    local dragInput, mousePos, framePos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            
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
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Keybind to toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == windowConfig.KeyBind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Window Object
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    function Window:CreateTab(name, icon)
        local tabData = {}
        
        -- Tab Button
        local TabButton = CreateInstance("TextButton", {
            Name = name,
            BackgroundColor3 = Settings.MainColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.Gotham,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        AddCorner(TabButton, 6)
        
        local TabIcon = CreateInstance("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = icon or "rbxassetid://3926305904",
            ImageColor3 = Settings.SecondaryTextColor,
            Parent = TabButton
        })
        
        local TabLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Settings.SecondaryTextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        -- Tab Content
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = name .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Settings.AccentColor,
            Visible = false,
            Parent = ContentContainer
        })
        
        local ContentLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })
        
        AddPadding(TabContent, 5)
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        local function SelectTab()
            -- Deselect all
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundTransparency = 1
                tab.Icon.ImageColor3 = Settings.SecondaryTextColor
                tab.Label.TextColor3 = Settings.SecondaryTextColor
                tab.Content.Visible = false
            end
            
            -- Select this tab
            CreateTween(TabButton, {BackgroundTransparency = 0}):Play()
            CreateTween(TabIcon, {ImageColor3 = Settings.AccentColor}):Play()
            CreateTween(TabLabel, {TextColor3 = Settings.TextColor}):Play()
            TabContent.Visible = true
            Window.ActiveTab = tabData
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tabData then
                CreateTween(TabButton, {BackgroundTransparency = 0.5}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tabData then
                CreateTween(TabButton, {BackgroundTransparency = 1}):Play()
            end
        end)
        
        tabData.Button = TabButton
        tabData.Icon = TabIcon
        tabData.Label = TabLabel
        tabData.Content = TabContent
        
        table.insert(Window.Tabs, tabData)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        -- Tab Element Functions
        local Tab = {}
        
        -- Section
        function Tab:CreateSection(name)
            local Section = CreateInstance("Frame", {
                Name = name .. "Section",
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = TabContent
            })
            AddCorner(Section, 6)
            
            local SectionLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Settings.Font,
                Text = name,
                TextColor3 = Settings.AccentColor,
                TextSize = 14,
                Parent = Section
            })
            
            return Section
        end
        
        -- Button
        function Tab:CreateButton(name, callback)
            callback = callback or function() end
            
            local Button = CreateInstance("TextButton", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = "",
                AutoButtonColor = false,
                Parent = TabContent
            })
            AddCorner(Button, 6)
            AddStroke(Button)
            CreateRipple(Button)
            
            local ButtonLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            local ButtonIcon = CreateInstance("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
                Image = "rbxassetid://3926307971",
                ImageRectOffset = Vector2.new(764, 244),
                ImageRectSize = Vector2.new(36, 36),
                ImageColor3 = Settings.SecondaryTextColor,
                Parent = Button
            })
            
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            Button.MouseEnter:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Settings.SecondaryColor}):Play()
            end)
            
            return Button
        end
        
        -- Toggle
        function Tab:CreateToggle(name, default, callback)
            callback = callback or function() end
            local toggled = default or false
            
            local Toggle = CreateInstance("TextButton", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = "",
                AutoButtonColor = false,
                Parent = TabContent
            })
            AddCorner(Toggle, 6)
            AddStroke(Toggle)
            
            local ToggleLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            local ToggleIndicator = CreateInstance("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = toggled and Settings.EnableColor or Settings.DisableColor,
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 44, 0, 22),
                Parent = Toggle
            })
            AddCorner(ToggleIndicator, 11)
            
            local ToggleCircle = CreateInstance("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Settings.TextColor,
                Position = toggled and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                Parent = ToggleIndicator
            })
            AddCorner(ToggleCircle, 999)
            
            local function UpdateToggle()
                if toggled then
                    CreateTween(ToggleIndicator, {BackgroundColor3 = Settings.EnableColor}):Play()
                    CreateTween(ToggleCircle, {Position = UDim2.new(1, -19, 0.5, 0)}):Play()
                else
                    CreateTween(ToggleIndicator, {BackgroundColor3 = Settings.DisableColor}):Play()
                    CreateTween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
                end
            end
            
            Toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
                callback(toggled)
            end)
            
            Toggle.MouseEnter:Connect(function()
                CreateTween(Toggle, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
            end)
            
            Toggle.MouseLeave:Connect(function()
                CreateTween(Toggle, {BackgroundColor3 = Settings.SecondaryColor}):Play()
            end)
            
            local ToggleObj = {}
            function ToggleObj:Set(value)
                toggled = value
                UpdateToggle()
                callback(toggled)
            end
            function ToggleObj:Get()
                return toggled
            end
            
            return ToggleObj
        end
        
        -- Slider
        function Tab:CreateSlider(name, min, max, default, callback)
            callback = callback or function() end
            min = min or 0
            max = max or 100
            default = default or min
            
            local Slider = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 55),
                Parent = TabContent
            })
            AddCorner(Slider, 6)
            AddStroke(Slider)
            
            local SliderLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            local SliderValue = CreateInstance("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -12, 0, 0),
                Size = UDim2.new(0.3, 0, 0, 30),
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = Settings.AccentColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Slider
            })
            
            local SliderBar = CreateInstance("Frame", {
                BackgroundColor3 = Settings.MainColor,
                Position = UDim2.new(0, 12, 0, 35),
                Size = UDim2.new(1, -24, 0, 10),
                Parent = Slider
            })
            AddCorner(SliderBar, 5)
            
            local SliderFill = CreateInstance("Frame", {
                BackgroundColor3 = Settings.AccentColor,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                Parent = SliderBar
            })
            AddCorner(SliderFill, 5)
            
            local SliderCircle = CreateInstance("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Settings.TextColor,
                Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                ZIndex = 2,
                Parent = SliderBar
            })
            AddCorner(SliderCircle, 999)
            
            local dragging = false
            
            local function UpdateSlider(input)
                local pos = UDim2.new(
                    math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1),
                    0, 0.5, 0
                )
                SliderCircle.Position = pos
                SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
                
                local value = math.floor(min + ((max - min) * pos.X.Scale))
                SliderValue.Text = tostring(value)
                callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            local SliderObj = {}
            function SliderObj:Set(value)
                value = math.clamp(value, min, max)
                local pos = (value - min) / (max - min)
                SliderCircle.Position = UDim2.new(pos, 0, 0.5, 0)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderValue.Text = tostring(value)
                callback(value)
            end
            
            return SliderObj
        end
        
        -- Dropdown
        function Tab:CreateDropdown(name, options, default, callback)
            callback = callback or function() end
            options = options or {}
            default = default or options[1] or "Select..."
            
            local opened = false
            
            local Dropdown = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = TabContent
            })
            AddCorner(Dropdown, 6)
            AddStroke(Dropdown)
            
            local DropdownButton = CreateInstance("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = "",
                Parent = Dropdown
            })
            
            local DropdownLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Dropdown
            })
            
            local DropdownSelected = CreateInstance("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -35, 0, 0),
                Size = UDim2.new(0.4, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = default,
                TextColor3 = Settings.AccentColor,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Dropdown
            })
            
            local DropdownArrow = CreateInstance("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -12, 0, 19),
                Size = UDim2.new(0, 16, 0, 16),
                Image = "rbxassetid://3926307971",
                ImageRectOffset = Vector2.new(564, 284),
                ImageRectSize = Vector2.new(36, 36),
                ImageColor3 = Settings.SecondaryTextColor,
                Parent = Dropdown
            })
            
            local DropdownContent = CreateInstance("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 43),
                Size = UDim2.new(1, -10, 0, #options * 30),
                Parent = Dropdown
            })
            
            local DropdownLayout = CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 3),
                Parent = DropdownContent
            })
            
            local function CreateOption(optionName)
                local Option = CreateInstance("TextButton", {
                    BackgroundColor3 = Settings.MainColor,
                    Size = UDim2.new(1, 0, 0, 28),
                    Font = Enum.Font.Gotham,
                    Text = optionName,
                    TextColor3 = Settings.TextColor,
                    TextSize = 13,
                    AutoButtonColor = false,
                    Parent = DropdownContent
                })
                AddCorner(Option, 4)
                
                Option.MouseButton1Click:Connect(function()
                    DropdownSelected.Text = optionName
                    opened = false
                    CreateTween(Dropdown, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    CreateTween(DropdownArrow, {Rotation = 0}):Play()
                    callback(optionName)
                end)
                
                Option.MouseEnter:Connect(function()
                    CreateTween(Option, {BackgroundColor3 = Settings.AccentColor}):Play()
                end)
                
                Option.MouseLeave:Connect(function()
                    CreateTween(Option, {BackgroundColor3 = Settings.MainColor}):Play()
                end)
            end
            
            for _, option in ipairs(options) do
                CreateOption(option)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    CreateTween(Dropdown, {Size = UDim2.new(1, 0, 0, 48 + #options * 31)}):Play()
                    CreateTween(DropdownArrow, {Rotation = 180}):Play()
                else
                    CreateTween(Dropdown, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    CreateTween(DropdownArrow, {Rotation = 0}):Play()
                end
            end)
            
            local DropdownObj = {}
            function DropdownObj:Set(value)
                DropdownSelected.Text = value
                callback(value)
            end
            function DropdownObj:Refresh(newOptions)
                for _, child in ipairs(DropdownContent:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                for _, option in ipairs(newOptions) do
                    CreateOption(option)
                end
                DropdownContent.Size = UDim2.new(1, -10, 0, #newOptions * 30)
            end
            
            return DropdownObj
        end
        
        -- TextBox (Input)
        function Tab:CreateInput(name, placeholder, callback)
            callback = callback or function() end
            
            local Input = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = TabContent
            })
            AddCorner(Input, 6)
            AddStroke(Input)
            
            local InputLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Input
            })
            
            local InputBox = CreateInstance("TextBox", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Settings.MainColor,
                Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.new(0.5, -5, 0, 26),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder or "Enter...",
                PlaceholderColor3 = Settings.SecondaryTextColor,
                Text = "",
                TextColor3 = Settings.TextColor,
                TextSize = 13,
                ClearTextOnFocus = false,
                Parent = Input
            })
            AddCorner(InputBox, 4)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(InputBox.Text)
                end
            end)
            
            local InputObj = {}
            function InputObj:Set(value)
                InputBox.Text = value
            end
            function InputObj:Get()
                return InputBox.Text
            end
            
            return InputObj
        end
        
        -- Keybind
        function Tab:CreateKeybind(name, default, callback)
            callback = callback or function() end
            local keybind = default or Enum.KeyCode.E
            local listening = false
            
            local Keybind = CreateInstance("TextButton", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = "",
                AutoButtonColor = false,
                Parent = TabContent
            })
            AddCorner(Keybind, 6)
            AddStroke(Keybind)
            
            local KeybindLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Keybind
            })
            
            local KeybindValue = CreateInstance("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Settings.MainColor,
                Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.new(0, 60, 0, 26),
                Font = Enum.Font.GothamBold,
                Text = keybind.Name,
                TextColor3 = Settings.AccentColor,
                TextSize = 12,
                Parent = Keybind
            })
            AddCorner(KeybindValue, 4)
            
            Keybind.MouseButton1Click:Connect(function()
                listening = true
                KeybindValue.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    keybind = input.KeyCode
                    KeybindValue.Text = keybind.Name
                    listening = false
                elseif not processed and input.KeyCode == keybind then
                    callback(keybind)
                end
            end)
            
            local KeybindObj = {}
            function KeybindObj:Set(key)
                keybind = key
                KeybindValue.Text = key.Name
            end
            function KeybindObj:Get()
                return keybind
            end
            
            return KeybindObj
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local Label = CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundColor3 = Settings.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Settings.TextColor,
                TextSize = 13,
                Parent = TabContent
            })
            AddCorner(Label, 6)
            
            local LabelObj = {}
            function LabelObj:Set(newText)
                Label.Text = newText
            end
            
            return LabelObj
        end
        
        -- Paragraph
        function Tab:CreateParagraph(title, content)
            local Paragraph = CreateInstance("Frame", {
                Name = "Paragraph",
                BackgroundColor3 = Settings.SecondaryColor,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 0, 0),
                Parent = TabContent
            })
            AddCorner(Paragraph, 6)
            AddStroke(Paragraph)
            
            local ParagraphLayout = CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 5),
                Parent = Paragraph
            })
            AddPadding(Paragraph, 10)
            
            local ParagraphTitle = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Settings.Font,
                Text = title,
                TextColor3 = Settings.AccentColor,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Paragraph
            })
            
            local ParagraphContent = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 0, 0),
                Font = Enum.Font.Gotham,
                Text = content,
                TextColor3 = Settings.SecondaryTextColor,
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Parent = Paragraph
            })
            
            local ParagraphObj = {}
            function ParagraphObj:Set(newTitle, newContent)
                ParagraphTitle.Text = newTitle
                ParagraphContent.Text = newContent
            end
            
            return ParagraphObj
        end
        
        -- Color Picker
        function Tab:CreateColorPicker(name, default, callback)
            callback = callback or function() end
            local selectedColor = default or Color3.fromRGB(255, 255, 255)
            local opened = false
            
            local ColorPicker = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = Settings.SecondaryColor,
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = TabContent
            })
            AddCorner(ColorPicker, 6)
            AddStroke(ColorPicker)
            
            local ColorPickerButton = CreateInstance("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                Parent = ColorPicker
            })
            
            local ColorLabel = CreateInstance("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.6, 0, 0, 38),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Settings.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorPicker
            })
            
            local ColorPreview = CreateInstance("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = selectedColor,
                Position = UDim2.new(1, -12, 0, 19),
                Size = UDim2.new(0, 50, 0, 22),
                Parent = ColorPicker
            })
            AddCorner(ColorPreview, 4)
            AddStroke(ColorPreview, Color3.fromRGB(60, 60, 80), 2)
            
            -- Color Picker Content
            local PickerContent = CreateInstance("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 45),
                Size = UDim2.new(1, -20, 0, 120),
                Parent = ColorPicker
            })
            
            local ColorCanvas = CreateInstance("ImageLabel", {
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Size = UDim2.new(1, -35, 0, 100),
                Image = "rbxassetid://4155801252",
                Parent = PickerContent
            })
            AddCorner(ColorCanvas, 4)
            
            local ColorCanvasSelector = CreateInstance("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 14, 0, 14),
                Parent = ColorCanvas
            })
            AddCorner(ColorCanvasSelector, 999)
            AddStroke(ColorCanvasSelector, Color3.fromRGB(0, 0, 0), 2)
            
            local HueSlider = CreateInstance("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 25, 0, 100),
                Image = "rbxassetid://3641079629",
                Parent = PickerContent
            })
            AddCorner(HueSlider, 4)
            
            local HueSelector = CreateInstance("Frame", {
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(1, 4, 0, 5),
                Parent = HueSlider
            })
            AddCorner(HueSelector, 2)
            AddStroke(HueSelector, Color3.fromRGB(0, 0, 0), 1)
            
            local hue, sat, val = 0, 1, 1
            
            local function UpdateColor()
                selectedColor = Color3.fromHSV(hue, sat, val)
                ColorCanvas.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                ColorPreview.BackgroundColor3 = selectedColor
                callback(selectedColor)
            end
            
            -- Canvas dragging
            local canvasDragging = false
            ColorCanvas.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    canvasDragging = true
                end
            end)
            ColorCanvas.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    canvasDragging = false
                end
            end)
            
            -- Hue dragging
            local hueDragging = false
            HueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                end
            end)
            HueSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if canvasDragging then
                        local pos = Vector2.new(
                            math.clamp((input.Position.X - ColorCanvas.AbsolutePosition.X) / ColorCanvas.AbsoluteSize.X, 0, 1),
                            math.clamp((input.Position.Y - ColorCanvas.AbsolutePosition.Y) / ColorCanvas.AbsoluteSize.Y, 0, 1)
                        )
                        sat = pos.X
                        val = 1 - pos.Y
                        ColorCanvasSelector.Position = UDim2.new(pos.X, 0, pos.Y, 0)
                        UpdateColor()
                    elseif hueDragging then
                        local pos = math.clamp((input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                        hue = pos
                        HueSelector.Position = UDim2.new(0.5, 0, pos, 0)
                        UpdateColor()
                    end
                end
            end)
            
            ColorPickerButton.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    CreateTween(ColorPicker, {Size = UDim2.new(1, 0, 0, 175)}):Play()
                else
                    CreateTween(ColorPicker, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                end
            end)
            
            local ColorPickerObj = {}
            function ColorPickerObj:Set(color)
                selectedColor = color
                hue, sat, val = color:ToHSV()
                ColorCanvas.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                ColorPreview.BackgroundColor3 = color
                ColorCanvasSelector.Position = UDim2.new(sat, 0, 1 - val, 0)
                HueSelector.Position = UDim2.new(0.5, 0, hue, 0)
                callback(color)
            end
            function ColorPickerObj:Get()
                return selectedColor
            end
            
            return ColorPickerObj
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or ""
        local duration = config.Duration or 5
        local type_ = config.Type or "Info" -- Info, Success, Warning, Error
        
        local typeColors = {
            Info = Settings.AccentColor,
            Success = Color3.fromRGB(0, 255, 128),
            Warning = Color3.fromRGB(255, 200, 75),
            Error = Color3.fromRGB(255, 75, 75)
        }
        
        local NotificationHolder = ScreenGui:FindFirstChild("NotificationHolder")
        if not NotificationHolder then
            NotificationHolder = CreateInstance("Frame", {
                Name = "NotificationHolder",
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, -20),
                Size = UDim2.new(0, 300, 1, -40),
                Parent = ScreenGui
            })
            
            CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = NotificationHolder
            })
        end
        
        local Notification = CreateInstance("Frame", {
            BackgroundColor3 = Settings.MainColor,
            Size = UDim2.new(0, 0, 0, 70),
            ClipsDescendants = true,
            Parent = NotificationHolder
        })
        AddCorner(Notification, 8)
        AddStroke(Notification, typeColors[type_], 2)
        
        local NotificationAccent = CreateInstance("Frame", {
            BackgroundColor3 = typeColors[type_],
            Size = UDim2.new(0, 4, 1, 0),
            Parent = Notification
        })
        
        local NotificationTitle = CreateInstance("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 8),
            Size = UDim2.new(1, -20, 0, 22),
            Font = Settings.Font,
            Text = title,
            TextColor3 = Settings.TextColor,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notification
        })
        
        local NotificationContent = CreateInstance("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 32),
            Size = UDim2.new(1, -20, 0, 30),
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = Settings.SecondaryTextColor,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = Notification
        })
        
        -- Animate in
        CreateTween(Notification, {Size = UDim2.new(0, 280, 0, 70)}):Play()
        
        -- Auto close
        task.delay(duration, function()
            local closeTween = CreateTween(Notification, {Size = UDim2.new(0, 0, 0, 70)}, 0.3)
            closeTween:Play()
            closeTween.Completed:Connect(function()
                Notification:Destroy()
            end)
        end)
    end
    
    return Window
end

-- Theme System
function AuroraLibrary:SetTheme(theme)
    if theme.MainColor then Settings.MainColor = theme.MainColor end
    if theme.SecondaryColor then Settings.SecondaryColor = theme.SecondaryColor end
    if theme.AccentColor then Settings.AccentColor = theme.AccentColor end
    if theme.TextColor then Settings.TextColor = theme.TextColor end
end

-- Return Library
return AuroraLibrary
