--[[
    Nexus UI Library
    A modern, feature-rich UI library for Roblox exploits
    
    Created for script developers
    Compatible with all major exploits
]]

local NexusUI = {
    Version = "1.0.0",
    Windows = {},
    Notifications = {},
    Themes = {},
    ConfigFolder = "NexusUI"
}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Utility Functions
local Utility = {}

function Utility:Tween(Object, Properties, Duration, Style, Direction)
    Style = Style or Enum.EasingStyle.Quad
    Direction = Direction or Enum.EasingDirection.Out
    
    local TweenInfo = TweenInfo.new(Duration or 0.3, Style, Direction)
    local Tween = TweenService:Create(Object, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

function Utility:MakeDraggable(Frame, DragFrame)
    DragFrame = DragFrame or Frame
    local Dragging, DragInput, MousePos, FramePos
    
    DragFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = Frame.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    DragFrame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - MousePos
            Utility:Tween(Frame, {
                Position = UDim2.new(
                    FramePos.X.Scale,
                    FramePos.X.Offset + Delta.X,
                    FramePos.Y.Scale,
                    FramePos.Y.Offset + Delta.Y
                )
            }, 0.1)
        end
    end)
end

function Utility:MakeResizable(Frame, MinSize)
    MinSize = MinSize or Vector2.new(400, 300)
    
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Size = UDim2.new(0, 20, 0, 20)
    ResizeButton.Position = UDim2.new(1, -20, 1, -20)
    ResizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ResizeButton.BorderSizePixel = 0
    ResizeButton.Text = "⋰"
    ResizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    ResizeButton.Font = Enum.Font.GothamBold
    ResizeButton.TextSize = 14
    ResizeButton.Parent = Frame
    
    local Resizing = false
    local InitialSize, InitialMouse
    
    ResizeButton.MouseButton1Down:Connect(function()
        Resizing = true
        InitialSize = Frame.Size
        InitialMouse = Vector2.new(Mouse.X, Mouse.Y)
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if Resizing then
            local Delta = Vector2.new(Mouse.X, Mouse.Y) - InitialMouse
            local NewSize = Vector2.new(
                math.max(InitialSize.X.Offset + Delta.X, MinSize.X),
                math.max(InitialSize.Y.Offset + Delta.Y, MinSize.Y)
            )
            Frame.Size = UDim2.new(0, NewSize.X, 0, NewSize.Y)
        end
    end)
end

function Utility:CreateCorner(Parent, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius or 8)
    Corner.Parent = Parent
    return Corner
end

function Utility:AddStroke(Parent, Color, Thickness)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color or Color3.fromRGB(60, 60, 60)
    Stroke.Thickness = Thickness or 1
    Stroke.Parent = Parent
    return Stroke
end

function Utility:RippleEffect(Button)
    Button.ClipsDescendants = true
    
    Button.MouseButton1Click:Connect(function()
        local Ripple = Instance.new("Frame")
        Ripple.Name = "Ripple"
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Ripple.Position = UDim2.new(0, Mouse.X - Button.AbsolutePosition.X, 0, Mouse.Y - Button.AbsolutePosition.Y)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 0.5
        Ripple.BorderSizePixel = 0
        Ripple.Parent = Button
        
        Utility:CreateCorner(Ripple, 999)
        
        local MaxSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
        
        Utility:Tween(Ripple, {
            Size = UDim2.new(0, MaxSize, 0, MaxSize),
            BackgroundTransparency = 1
        }, 0.5)
        
        task.delay(0.5, function()
            Ripple:Destroy()
        end)
    end)
end

-- Theme System
NexusUI.Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Tertiary = Color3.fromRGB(40, 40, 45),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 65),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(235, 235, 240),
        Tertiary = Color3.fromRGB(225, 225, 230),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(20, 20, 25),
        SubText = Color3.fromRGB(100, 100, 105),
        Border = Color3.fromRGB(200, 200, 205),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 23, 42),
        Secondary = Color3.fromRGB(30, 41, 59),
        Tertiary = Color3.fromRGB(51, 65, 85),
        Accent = Color3.fromRGB(14, 165, 233),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(71, 85, 105),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(251, 146, 60)
    }
}

NexusUI.CurrentTheme = NexusUI.Themes.Dark

-- Configuration System
local ConfigSystem = {}

function ConfigSystem:GetConfigPath(Name)
    return NexusUI.ConfigFolder .. "/" .. Name .. ".json"
end

function ConfigSystem:Save(Name, Data)
    if not isfolder(NexusUI.ConfigFolder) then
        makefolder(NexusUI.ConfigFolder)
    end
    
    local Success, Result = pcall(function()
        local Encoded = game:GetService("HttpService"):JSONEncode(Data)
        writefile(self:GetConfigPath(Name), Encoded)
    end)
    
    return Success
end

function ConfigSystem:Load(Name)
    local Path = self:GetConfigPath(Name)
    
    if not isfile(Path) then
        return nil
    end
    
    local Success, Result = pcall(function()
        local Content = readfile(Path)
        return game:GetService("HttpService"):JSONDecode(Content)
    end)
    
    return Success and Result or nil
end

function ConfigSystem:Delete(Name)
    local Path = self:GetConfigPath(Name)
    if isfile(Path) then
        delfile(Path)
        return true
    end
    return false
end

function ConfigSystem:List()
    if not isfolder(NexusUI.ConfigFolder) then
        return {}
    end
    
    local Configs = {}
    local Files = listfiles(NexusUI.ConfigFolder)
    
    for _, File in ipairs(Files) do
        local Name = File:match("([^/]+)%.json$")
        if Name then
            table.insert(Configs, Name)
        end
    end
    
    return Configs
end

-- Notification System
local NotificationSystem = {}
NotificationSystem.Queue = {}
NotificationSystem.ActiveNotifications = 0
NotificationSystem.MaxNotifications = 5

function NotificationSystem:Create(Config)
    Config = Config or {}
    Config.Title = Config.Title or "Notification"
    Config.Description = Config.Description or ""
    Config.Type = Config.Type or "Info"
    Config.Duration = Config.Duration or 3
    
    -- Queue if too many notifications
    if self.ActiveNotifications >= self.MaxNotifications then
        table.insert(self.Queue, Config)
        return
    end
    
    self.ActiveNotifications = self.ActiveNotifications + 1
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "NexusNotification"
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        NotificationGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(NotificationGui)
        NotificationGui.Parent = CoreGui
    else
        NotificationGui.Parent = CoreGui
    end
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(0, 300, 0, 80)
    Notification.Position = UDim2.new(1, -320, 1, 100)
    Notification.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
    Notification.BorderSizePixel = 0
    Notification.Parent = NotificationGui
    
    Utility:CreateCorner(Notification, 8)
    Utility:AddStroke(Notification, NexusUI.CurrentTheme.Border, 1)
    
    -- Type indicator
    local TypeColors = {
        Success = NexusUI.CurrentTheme.Success,
        Error = NexusUI.CurrentTheme.Error,
        Warning = NexusUI.CurrentTheme.Warning,
        Info = NexusUI.CurrentTheme.Accent
    }
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 4, 1, 0)
    Indicator.BackgroundColor3 = TypeColors[Config.Type] or NexusUI.CurrentTheme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Notification
    
    Utility:CreateCorner(Indicator, 8)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 0, 25)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title
    Title.TextColor3 = NexusUI.CurrentTheme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notification
    
    -- Description
    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(1, -50, 0, 35)
    Description.Position = UDim2.new(0, 15, 0, 35)
    Description.BackgroundTransparency = 1
    Description.Text = Config.Description
    Description.TextColor3 = NexusUI.CurrentTheme.SubText
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.TextWrapped = true
    Description.Parent = Notification
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = NexusUI.CurrentTheme.SubText
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.Parent = Notification
    
    -- Animations
    local TargetPosition = UDim2.new(1, -320, 1, -100 - (self.ActiveNotifications - 1) * 90)
    
    Utility:Tween(Notification, {Position = TargetPosition}, 0.5, Enum.EasingStyle.Back)
    
    -- Close function
    local function Close()
        Utility:Tween(Notification, {
            Position = UDim2.new(1, -320, 1, 100)
        }, 0.3)
        
        task.wait(0.3)
        NotificationGui:Destroy()
        self.ActiveNotifications = self.ActiveNotifications - 1
        
        -- Process queue
        if #self.Queue > 0 then
            local NextNotification = table.remove(self.Queue, 1)
            self:Create(NextNotification)
        end
    end
    
    CloseButton.MouseButton1Click:Connect(Close)
    
    -- Auto close
    task.delay(Config.Duration, Close)
    
    return Notification
end

-- Window Class
local Window = {}
Window.__index = Window

function Window:CreateTab(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Tab"
    Config.Icon = Config.Icon or "rbxassetid://0"
    
    local Tab = {
        Name = Config.Name,
        Icon = Config.Icon,
        Elements = {},
        Sections = {},
        Window = self
    }
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = Config.Name
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
    TabButton.BackgroundTransparency = 1
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabContainer
    
    Utility:CreateCorner(TabButton, 6)
    
    -- Tab Icon (if using default icons, we'll use text)
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Name = "Icon"
    TabIcon.Size = UDim2.new(0, 30, 0, 30)
    TabIcon.Position = UDim2.new(0, 10, 0.5, -15)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = "•"
    TabIcon.TextColor3 = NexusUI.CurrentTheme.SubText
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.TextSize = 24
    TabIcon.Parent = TabButton
    
    -- Tab Name
    local TabName = Instance.new("TextLabel")
    TabName.Name = "TabName"
    TabName.Size = UDim2.new(1, -50, 1, 0)
    TabName.Position = UDim2.new(0, 45, 0, 0)
    TabName.BackgroundTransparency = 1
    TabName.Text = Config.Name
    TabName.TextColor3 = NexusUI.CurrentTheme.SubText
    TabName.Font = Enum.Font.GothamSemibold
    TabName.TextSize = 14
    TabName.TextXAlignment = Enum.TextXAlignment.Left
    TabName.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = Config.Name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = NexusUI.CurrentTheme.Accent
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = self.ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Tab button click
    TabButton.MouseButton1Click:Connect(function()
        for _, TabData in pairs(self.Tabs) do
            TabData.Button.BackgroundTransparency = 1
            TabData.Content.Visible = false
            TabData.Button:FindFirstChild("TabName").TextColor3 = NexusUI.CurrentTheme.SubText
            TabData.Button:FindFirstChild("Icon").TextColor3 = NexusUI.CurrentTheme.SubText
        end
        
        TabButton.BackgroundTransparency = 0
        TabContent.Visible = true
        TabName.TextColor3 = NexusUI.CurrentTheme.Text
        TabIcon.TextColor3 = NexusUI.CurrentTheme.Accent
        
        Utility:Tween(TabButton, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
    end)
    
    -- Hover effects
    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundTransparency == 1 then
            Utility:Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundTransparency ~= 0 then
            Utility:Tween(TabButton, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    Tab.Button = TabButton
    Tab.Content = TabContent
    
    table.insert(self.Tabs, Tab)
    
    -- Select first tab
    if #self.Tabs == 1 then
        TabButton.BackgroundTransparency = 0
        TabButton.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
        TabContent.Visible = true
        TabName.TextColor3 = NexusUI.CurrentTheme.Text
        TabIcon.TextColor3 = NexusUI.CurrentTheme.Accent
    end
    
    -- Tab Methods
    function Tab:CreateSection(Name)
        local Section = Instance.new("Frame")
        Section.Name = Name
        Section.Size = UDim2.new(1, 0, 0, 35)
        Section.BackgroundTransparency = 1
        Section.Parent = TabContent
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Size = UDim2.new(1, 0, 1, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = Name
        SectionTitle.TextColor3 = NexusUI.CurrentTheme.Text
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 16
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = Section
        
        local Divider = Instance.new("Frame")
        Divider.Name = "Divider"
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.Position = UDim2.new(0, 0, 1, -1)
        Divider.BackgroundColor3 = NexusUI.CurrentTheme.Border
        Divider.BorderSizePixel = 0
        Divider.Parent = Section
        
        table.insert(self.Sections, Section)
        return Section
    end
    
    function Tab:CreateButton(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Button"
        Config.Description = Config.Description or ""
        Config.Callback = Config.Callback or function() end
        
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Name = "ButtonFrame"
        ButtonFrame.Size = UDim2.new(1, 0, 0, Config.Description ~= "" and 60 or 40)
        ButtonFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Parent = TabContent
        
        Utility:CreateCorner(ButtonFrame, 6)
        
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""
        Button.Parent = ButtonFrame
        
        local ButtonText = Instance.new("TextLabel")
        ButtonText.Name = "ButtonText"
        ButtonText.Size = UDim2.new(1, -20, 0, 20)
        ButtonText.Position = UDim2.new(0, 10, 0, Config.Description ~= "" and 8 or 10)
        ButtonText.BackgroundTransparency = 1
        ButtonText.Text = Config.Name
        ButtonText.TextColor3 = NexusUI.CurrentTheme.Text
        ButtonText.Font = Enum.Font.GothamSemibold
        ButtonText.TextSize = 14
        ButtonText.TextXAlignment = Enum.TextXAlignment.Left
        ButtonText.Parent = ButtonFrame
        
        if Config.Description ~= "" then
            local Description = Instance.new("TextLabel")
            Description.Name = "Description"
            Description.Size = UDim2.new(1, -20, 0, 20)
            Description.Position = UDim2.new(0, 10, 0, 30)
            Description.BackgroundTransparency = 1
            Description.Text = Config.Description
            Description.TextColor3 = NexusUI.CurrentTheme.SubText
            Description.Font = Enum.Font.Gotham
            Description.TextSize = 12
            Description.TextXAlignment = Enum.TextXAlignment.Left
            Description.Parent = ButtonFrame
        end
        
        Utility:RippleEffect(Button)
        
        Button.MouseButton1Click:Connect(function()
            Config.Callback()
        end)
        
        Button.MouseEnter:Connect(function()
            Utility:Tween(ButtonFrame, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
        end)
        
        Button.MouseLeave:Connect(function()
            Utility:Tween(ButtonFrame, {BackgroundColor3 = NexusUI.CurrentTheme.Secondary}, 0.2)
        end)
        
        return ButtonFrame
    end
    
    function Tab:CreateToggle(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Toggle"
        Config.CurrentValue = Config.CurrentValue or false
        Config.Callback = Config.Callback or function() end
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = TabContent
        
        Utility:CreateCorner(ToggleFrame, 6)
        
        local ToggleText = Instance.new("TextLabel")
        ToggleText.Name = "ToggleText"
        ToggleText.Size = UDim2.new(1, -70, 1, 0)
        ToggleText.Position = UDim2.new(0, 10, 0, 0)
        ToggleText.BackgroundTransparency = 1
        ToggleText.Text = Config.Name
        ToggleText.TextColor3 = NexusUI.CurrentTheme.Text
        ToggleText.Font = Enum.Font.GothamSemibold
        ToggleText.TextSize = 14
        ToggleText.TextXAlignment = Enum.TextXAlignment.Left
        ToggleText.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 45, 0, 22)
        ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
        ToggleButton.BackgroundColor3 = Config.CurrentValue and NexusUI.CurrentTheme.Accent or NexusUI.CurrentTheme.Tertiary
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = ""
        ToggleButton.AutoButtonColor = false
        ToggleButton.Parent = ToggleFrame
        
        Utility:CreateCorner(ToggleButton, 11)
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
        ToggleIndicator.Position = Config.CurrentValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Parent = ToggleButton
        
        Utility:CreateCorner(ToggleIndicator, 9)
        
        local function Toggle(Value)
            Config.CurrentValue = Value
            
            Utility:Tween(ToggleButton, {
                BackgroundColor3 = Value and NexusUI.CurrentTheme.Accent or NexusUI.CurrentTheme.Tertiary
            }, 0.2)
            
            Utility:Tween(ToggleIndicator, {
                Position = Value and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }, 0.2)
            
            Config.Callback(Value)
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            Toggle(not Config.CurrentValue)
        end)
        
        ToggleFrame.MouseEnter:Connect(function()
            Utility:Tween(ToggleFrame, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
        end)
        
        ToggleFrame.MouseLeave:Connect(function()
            Utility:Tween(ToggleFrame, {BackgroundColor3 = NexusUI.CurrentTheme.Secondary}, 0.2)
        end)
        
        return {
            Frame = ToggleFrame,
            SetValue = Toggle
        }
    end
    
    function Tab:CreateSlider(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Slider"
        Config.Min = Config.Min or 0
        Config.Max = Config.Max or 100
        Config.Default = Config.Default or 50
        Config.Increment = Config.Increment or 1
        Config.Callback = Config.Callback or function() end
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = "SliderFrame"
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = TabContent
        
        Utility:CreateCorner(SliderFrame, 6)
        
        local SliderText = Instance.new("TextLabel")
        SliderText.Name = "SliderText"
        SliderText.Size = UDim2.new(1, -70, 0, 20)
        SliderText.Position = UDim2.new(0, 10, 0, 5)
        SliderText.BackgroundTransparency = 1
        SliderText.Text = Config.Name
        SliderText.TextColor3 = NexusUI.CurrentTheme.Text
        SliderText.Font = Enum.Font.GothamSemibold
        SliderText.TextSize = 14
        SliderText.TextXAlignment = Enum.TextXAlignment.Left
        SliderText.Parent = SliderFrame
        
        local SliderValue = Instance.new("TextLabel")
        SliderValue.Name = "SliderValue"
        SliderValue.Size = UDim2.new(0, 50, 0, 20)
        SliderValue.Position = UDim2.new(1, -60, 0, 5)
        SliderValue.BackgroundTransparency = 1
        SliderValue.Text = tostring(Config.Default)
        SliderValue.TextColor3 = NexusUI.CurrentTheme.Accent
        SliderValue.Font = Enum.Font.GothamBold
        SliderValue.TextSize = 14
        SliderValue.TextXAlignment = Enum.TextXAlignment.Right
        SliderValue.Parent = SliderFrame
        
        local SliderTrack = Instance.new("Frame")
        SliderTrack.Name = "Track"
        SliderTrack.Size = UDim2.new(1, -20, 0, 4)
        SliderTrack.Position = UDim2.new(0, 10, 1, -15)
        SliderTrack.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
        SliderTrack.BorderSizePixel = 0
        SliderTrack.Parent = SliderFrame
        
        Utility:CreateCorner(SliderTrack, 2)
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
        SliderFill.BackgroundColor3 = NexusUI.CurrentTheme.Accent
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderTrack
        
        Utility:CreateCorner(SliderFill, 2)
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Name = "SliderButton"
        SliderButton.Size = UDim2.new(1, 0, 1, 0)
        SliderButton.BackgroundTransparency = 1
        SliderButton.Text = ""
        SliderButton.Parent = SliderTrack
        
        local Dragging = false
        
        local function UpdateSlider(Input)
            local Position = math.clamp((Input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
            local Value = math.floor(((Config.Max - Config.Min) * Position + Config.Min) / Config.Increment + 0.5) * Config.Increment
            Value = math.clamp(Value, Config.Min, Config.Max)
            
            SliderValue.Text = tostring(Value)
            Utility:Tween(SliderFill, {Size = UDim2.new(Position, 0, 1, 0)}, 0.1)
            
            Config.Callback(Value)
        end
        
        SliderButton.MouseButton1Down:Connect(function()
            Dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider(Input)
            end
        end)
        
        SliderButton.MouseButton1Click:Connect(function()
            UpdateSlider(UserInputService:GetMouseLocation())
        end)
        
        return SliderFrame
    end
    
    function Tab:CreateDropdown(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Dropdown"
        Config.Options = Config.Options or {}
        Config.CurrentOption = Config.CurrentOption or Config.Options[1] or "None"
        Config.MultiSelect = Config.MultiSelect or false
        Config.Callback = Config.Callback or function() end
        
        local Selected = Config.MultiSelect and {} or Config.CurrentOption
        
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
        DropdownFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = TabContent
        
        Utility:CreateCorner(DropdownFrame, 6)
        
        local DropdownText = Instance.new("TextLabel")
        DropdownText.Name = "DropdownText"
        DropdownText.Size = UDim2.new(1, -40, 0, 40)
        DropdownText.Position = UDim2.new(0, 10, 0, 0)
        DropdownText.BackgroundTransparency = 1
        DropdownText.Text = Config.Name
        DropdownText.TextColor3 = NexusUI.CurrentTheme.Text
        DropdownText.Font = Enum.Font.GothamSemibold
        DropdownText.TextSize = 14
        DropdownText.TextXAlignment = Enum.TextXAlignment.Left
        DropdownText.Parent = DropdownFrame
        
        local DropdownIcon = Instance.new("TextLabel")
        DropdownIcon.Name = "Icon"
        DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
        DropdownIcon.Position = UDim2.new(1, -30, 0, 10)
        DropdownIcon.BackgroundTransparency = 1
        DropdownIcon.Text = "▼"
        DropdownIcon.TextColor3 = NexusUI.CurrentTheme.SubText
        DropdownIcon.Font = Enum.Font.GothamBold
        DropdownIcon.TextSize = 10
        DropdownIcon.Parent = DropdownFrame
        
        local OptionsContainer = Instance.new("Frame")
        OptionsContainer.Name = "Options"
        OptionsContainer.Size = UDim2.new(1, -10, 0, 0)
        OptionsContainer.Position = UDim2.new(0, 5, 0, 45)
        OptionsContainer.BackgroundTransparency = 1
        OptionsContainer.Parent = DropdownFrame
        
        local OptionsLayout = Instance.new("UIListLayout")
        OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsLayout.Padding = UDim.new(0, 2)
        OptionsLayout.Parent = OptionsContainer
        
        local IsOpen = false
        
        local function CreateOption(OptionName)
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = OptionName
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = OptionName
            OptionButton.TextColor3 = NexusUI.CurrentTheme.Text
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextSize = 12
            OptionButton.AutoButtonColor = false
            OptionButton.Parent = OptionsContainer
            
            Utility:CreateCorner(OptionButton, 4)
            
            if Config.MultiSelect then
                local IsSelected = table.find(Selected, OptionName) ~= nil
                OptionButton.BackgroundColor3 = IsSelected and NexusUI.CurrentTheme.Accent or NexusUI.CurrentTheme.Tertiary
                
                OptionButton.MouseButton1Click:Connect(function()
                    local Index = table.find(Selected, OptionName)
                    if Index then
                        table.remove(Selected, Index)
                        OptionButton.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
                    else
                        table.insert(Selected, OptionName)
                        OptionButton.BackgroundColor3 = NexusUI.CurrentTheme.Accent
                    end
                    Config.Callback(Selected)
                end)
            else
                if OptionName == Selected then
                    OptionButton.BackgroundColor3 = NexusUI.CurrentTheme.Accent
                end
                
                OptionButton.MouseButton1Click:Connect(function()
                    Selected = OptionName
                    Config.Callback(OptionName)
                    
                    for _, Option in pairs(OptionsContainer:GetChildren()) do
                        if Option:IsA("TextButton") then
                            Utility:Tween(Option, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
                        end
                    end
                    
                    Utility:Tween(OptionButton, {BackgroundColor3 = NexusUI.CurrentTheme.Accent}, 0.2)
                    
                    -- Close dropdown
                    IsOpen = false
                    Utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    Utility:Tween(DropdownIcon, {Rotation = 0}, 0.3)
                end)
            end
            
            OptionButton.MouseEnter:Connect(function()
                if not Config.MultiSelect or not table.find(Selected, OptionName) then
                    Utility:Tween(OptionButton, {BackgroundColor3 = NexusUI.CurrentTheme.Accent}, 0.2)
                end
            end)
            
            OptionButton.MouseLeave:Connect(function()
                if not Config.MultiSelect and OptionName ~= Selected then
                    Utility:Tween(OptionButton, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
                elseif Config.MultiSelect and not table.find(Selected, OptionName) then
                    Utility:Tween(OptionButton, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
                end
            end)
        end
        
        for _, Option in ipairs(Config.Options) do
            CreateOption(Option)
        end
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Size = UDim2.new(1, 0, 0, 40)
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Text = ""
        DropdownButton.Parent = DropdownFrame
        
        DropdownButton.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            
            local TargetSize = IsOpen and UDim2.new(1, 0, 0, 45 + (#Config.Options * 32)) or UDim2.new(1, 0, 0, 40)
            Utility:Tween(DropdownFrame, {Size = TargetSize}, 0.3)
            Utility:Tween(DropdownIcon, {Rotation = IsOpen and 180 or 0}, 0.3)
        end)
        
        return {
            Frame = DropdownFrame,
            Refresh = function(NewOptions)
                for _, Child in pairs(OptionsContainer:GetChildren()) do
                    if Child:IsA("TextButton") then
                        Child:Destroy()
                    end
                end
                
                Config.Options = NewOptions
                for _, Option in ipairs(NewOptions) do
                    CreateOption(Option)
                end
                
                if IsOpen then
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 45 + (#NewOptions * 32))
                end
            end
        }
    end
    
    function Tab:CreateKeybind(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Keybind"
        Config.CurrentKeybind = Config.CurrentKeybind or "NONE"
        Config.Mode = Config.Mode or "Toggle" -- Toggle or Hold
        Config.Callback = Config.Callback or function() end
        
        local KeybindFrame = Instance.new("Frame")
        KeybindFrame.Name = "KeybindFrame"
        KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
        KeybindFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        KeybindFrame.BorderSizePixel = 0
        KeybindFrame.Parent = TabContent
        
        Utility:CreateCorner(KeybindFrame, 6)
        
        local KeybindText = Instance.new("TextLabel")
        KeybindText.Name = "KeybindText"
        KeybindText.Size = UDim2.new(1, -100, 1, 0)
        KeybindText.Position = UDim2.new(0, 10, 0, 0)
        KeybindText.BackgroundTransparency = 1
        KeybindText.Text = Config.Name
        KeybindText.TextColor3 = NexusUI.CurrentTheme.Text
        KeybindText.Font = Enum.Font.GothamSemibold
        KeybindText.TextSize = 14
        KeybindText.TextXAlignment = Enum.TextXAlignment.Left
        KeybindText.Parent = KeybindFrame
        
        local KeybindButton = Instance.new("TextButton")
        KeybindButton.Name = "KeybindButton"
        KeybindButton.Size = UDim2.new(0, 80, 0, 28)
        KeybindButton.Position = UDim2.new(1, -90, 0.5, -14)
        KeybindButton.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
        KeybindButton.BorderSizePixel = 0
        KeybindButton.Text = Config.CurrentKeybind
        KeybindButton.TextColor3 = NexusUI.CurrentTheme.Text
        KeybindButton.Font = Enum.Font.GothamBold
        KeybindButton.TextSize = 12
        KeybindButton.AutoButtonColor = false
        KeybindButton.Parent = KeybindFrame
        
        Utility:CreateCorner(KeybindButton, 6)
        
        local Listening = false
        local CurrentKeybind = Config.CurrentKeybind
        local IsActive = false
        
        KeybindButton.MouseButton1Click:Connect(function()
            Listening = true
            KeybindButton.Text = "..."
            Utility:Tween(KeybindButton, {BackgroundColor3 = NexusUI.CurrentTheme.Accent}, 0.2)
        end)
        
        UserInputService.InputBegan:Connect(function(Input, Processed)
            if Listening then
                if Input.KeyCode ~= Enum.KeyCode.Unknown then
                    CurrentKeybind = Input.KeyCode.Name
                    KeybindButton.Text = CurrentKeybind
                    Config.CurrentKeybind = CurrentKeybind
                    Listening = false
                    Utility:Tween(KeybindButton, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
                end
            elseif not Processed and Input.KeyCode.Name == CurrentKeybind then
                if Config.Mode == "Toggle" then
                    IsActive = not IsActive
                    Config.Callback(IsActive)
                else
                    Config.Callback(true)
                end
            end
        end)
        
        if Config.Mode == "Hold" then
            UserInputService.InputEnded:Connect(function(Input)
                if Input.KeyCode.Name == CurrentKeybind then
                    Config.Callback(false)
                end
            end)
        end
        
        return KeybindFrame
    end
    
    function Tab:CreateTextbox(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Textbox"
        Config.PlaceholderText = Config.PlaceholderText or "Enter text..."
        Config.Default = Config.Default or ""
        Config.Callback = Config.Callback or function() end
        
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Name = "TextboxFrame"
        TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
        TextboxFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        TextboxFrame.BorderSizePixel = 0
        TextboxFrame.Parent = TabContent
        
        Utility:CreateCorner(TextboxFrame, 6)
        
        local TextboxLabel = Instance.new("TextLabel")
        TextboxLabel.Name = "Label"
        TextboxLabel.Size = UDim2.new(1, -20, 0, 25)
        TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
        TextboxLabel.BackgroundTransparency = 1
        TextboxLabel.Text = Config.Name
        TextboxLabel.TextColor3 = NexusUI.CurrentTheme.Text
        TextboxLabel.Font = Enum.Font.GothamSemibold
        TextboxLabel.TextSize = 14
        TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextboxLabel.Parent = TextboxFrame
        
        local Textbox = Instance.new("TextBox")
        Textbox.Name = "Textbox"
        Textbox.Size = UDim2.new(1, -20, 0, 30)
        Textbox.Position = UDim2.new(0, 10, 0, 35)
        Textbox.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
        Textbox.BorderSizePixel = 0
        Textbox.Text = Config.Default
        Textbox.PlaceholderText = Config.PlaceholderText
        Textbox.TextColor3 = NexusUI.CurrentTheme.Text
        Textbox.PlaceholderColor3 = NexusUI.CurrentTheme.SubText
        Textbox.Font = Enum.Font.Gotham
        Textbox.TextSize = 13
        Textbox.ClearTextOnFocus = false
        Textbox.Parent = TextboxFrame
        
        Utility:CreateCorner(Textbox, 6)
        
        Textbox.FocusLost:Connect(function(EnterPressed)
            if EnterPressed then
                Config.Callback(Textbox.Text)
            end
        end)
        
        Textbox.Focused:Connect(function()
            Utility:Tween(Textbox, {BackgroundColor3 = NexusUI.CurrentTheme.Accent}, 0.2)
        end)
        
        Textbox.FocusLost:Connect(function()
            Utility:Tween(Textbox, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
        end)
        
        return TextboxFrame
    end
    
    function Tab:CreateLabel(Text)
        local LabelFrame = Instance.new("Frame")
        LabelFrame.Name = "LabelFrame"
        LabelFrame.Size = UDim2.new(1, 0, 0, 30)
        LabelFrame.BackgroundTransparency = 1
        LabelFrame.Parent = TabContent
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -10, 1, 0)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Text or "Label"
        Label.TextColor3 = NexusUI.CurrentTheme.Text
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = LabelFrame
        
        return {
            Frame = LabelFrame,
            SetText = function(NewText)
                Label.Text = NewText
            end
        }
    end
    
    function Tab:CreateParagraph(Title, Content)
        local ParagraphFrame = Instance.new("Frame")
        ParagraphFrame.Name = "ParagraphFrame"
        ParagraphFrame.Size = UDim2.new(1, 0, 0, 80)
        ParagraphFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        ParagraphFrame.BorderSizePixel = 0
        ParagraphFrame.Parent = TabContent
        
        Utility:CreateCorner(ParagraphFrame, 6)
        
        local ParagraphTitle = Instance.new("TextLabel")
        ParagraphTitle.Name = "Title"
        ParagraphTitle.Size = UDim2.new(1, -20, 0, 25)
        ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
        ParagraphTitle.BackgroundTransparency = 1
        ParagraphTitle.Text = Title or "Paragraph"
        ParagraphTitle.TextColor3 = NexusUI.CurrentTheme.Text
        ParagraphTitle.Font = Enum.Font.GothamBold
        ParagraphTitle.TextSize = 14
        ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphTitle.Parent = ParagraphFrame
        
        local ParagraphContent = Instance.new("TextLabel")
        ParagraphContent.Name = "Content"
        ParagraphContent.Size = UDim2.new(1, -20, 1, -35)
        ParagraphContent.Position = UDim2.new(0, 10, 0, 30)
        ParagraphContent.BackgroundTransparency = 1
        ParagraphContent.Text = Content or "Content"
        ParagraphContent.TextColor3 = NexusUI.CurrentTheme.SubText
        ParagraphContent.Font = Enum.Font.Gotham
        ParagraphContent.TextSize = 12
        ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
        ParagraphContent.TextWrapped = true
        ParagraphContent.Parent = ParagraphFrame
        
        -- Auto resize based on content
        local TextSize = game:GetService("TextService"):GetTextSize(
            Content,
            ParagraphContent.TextSize,
            ParagraphContent.Font,
            Vector2.new(ParagraphContent.AbsoluteSize.X, math.huge)
        )
        ParagraphFrame.Size = UDim2.new(1, 0, 0, TextSize.Y + 45)
        
        return ParagraphFrame
    end
    
    function Tab:CreateColorPicker(Config)
        Config = Config or {}
        Config.Name = Config.Name or "Color Picker"
        Config.Default = Config.Default or Color3.fromRGB(255, 255, 255)
        Config.Callback = Config.Callback or function() end
        
        local ColorPickerFrame = Instance.new("Frame")
        ColorPickerFrame.Name = "ColorPickerFrame"
        ColorPickerFrame.Size = UDim2.new(1, 0, 0, 40)
        ColorPickerFrame.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
        ColorPickerFrame.BorderSizePixel = 0
        ColorPickerFrame.Parent = TabContent
        
        Utility:CreateCorner(ColorPickerFrame, 6)
        
        local ColorPickerText = Instance.new("TextLabel")
        ColorPickerText.Name = "Text"
        ColorPickerText.Size = UDim2.new(1, -60, 1, 0)
        ColorPickerText.Position = UDim2.new(0, 10, 0, 0)
        ColorPickerText.BackgroundTransparency = 1
        ColorPickerText.Text = Config.Name
        ColorPickerText.TextColor3 = NexusUI.CurrentTheme.Text
        ColorPickerText.Font = Enum.Font.GothamSemibold
        ColorPickerText.TextSize = 14
        ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
        ColorPickerText.Parent = ColorPickerFrame
        
        local ColorDisplay = Instance.new("Frame")
        ColorDisplay.Name = "ColorDisplay"
        ColorDisplay.Size = UDim2.new(0, 40, 0, 28)
        ColorDisplay.Position = UDim2.new(1, -50, 0.5, -14)
        ColorDisplay.BackgroundColor3 = Config.Default
        ColorDisplay.BorderSizePixel = 0
        ColorDisplay.Parent = ColorPickerFrame
        
        Utility:CreateCorner(ColorDisplay, 6)
        Utility:AddStroke(ColorDisplay, NexusUI.CurrentTheme.Border, 2)
        
        local ColorButton = Instance.new("TextButton")
        ColorButton.Name = "ColorButton"
        ColorButton.Size = UDim2.new(1, 0, 1, 0)
        ColorButton.BackgroundTransparency = 1
        ColorButton.Text = ""
        ColorButton.Parent = ColorDisplay
        
        local PickerOpen = false
        local PickerWindow
        
        ColorButton.MouseButton1Click:Connect(function()
            if PickerOpen then
                PickerWindow:Destroy()
                PickerOpen = false
                return
            end
            
            PickerOpen = true
            
            -- Create color picker window
            PickerWindow = Instance.new("Frame")
            PickerWindow.Name = "PickerWindow"
            PickerWindow.Size = UDim2.new(0, 250, 0, 280)
            PickerWindow.Position = UDim2.new(0.5, -125, 0.5, -140)
            PickerWindow.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
            PickerWindow.BorderSizePixel = 0
            PickerWindow.Parent = self.Window.ScreenGui
            
            Utility:CreateCorner(PickerWindow, 8)
            Utility:AddStroke(PickerWindow, NexusUI.CurrentTheme.Border, 2)
            
            -- Title
            local PickerTitle = Instance.new("TextLabel")
            PickerTitle.Name = "Title"
            PickerTitle.Size = UDim2.new(1, -40, 0, 40)
            PickerTitle.Position = UDim2.new(0, 10, 0, 0)
            PickerTitle.BackgroundTransparency = 1
            PickerTitle.Text = "Pick a Color"
            PickerTitle.TextColor3 = NexusUI.CurrentTheme.Text
            PickerTitle.Font = Enum.Font.GothamBold
            PickerTitle.TextSize = 16
            PickerTitle.TextXAlignment = Enum.TextXAlignment.Left
            PickerTitle.Parent = PickerWindow
            
            -- Close button
            local CloseButton = Instance.new("TextButton")
            CloseButton.Name = "Close"
            CloseButton.Size = UDim2.new(0, 30, 0, 30)
            CloseButton.Position = UDim2.new(1, -35, 0, 5)
            CloseButton.BackgroundTransparency = 1
            CloseButton.Text = "✕"
            CloseButton.TextColor3 = NexusUI.CurrentTheme.SubText
            CloseButton.Font = Enum.Font.GothamBold
            CloseButton.TextSize = 18
            CloseButton.Parent = PickerWindow
            
            CloseButton.MouseButton1Click:Connect(function()
                PickerWindow:Destroy()
                PickerOpen = false
            end)
            
            -- Color canvas (simplified RGB sliders)
            local CurrentColor = Config.Default
            local R, G, B = math.floor(CurrentColor.R * 255), math.floor(CurrentColor.G * 255), math.floor(CurrentColor.B * 255)
            
            local function CreateSlider(Name, Color, DefaultValue, YPos)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = Name .. "Slider"
                SliderFrame.Size = UDim2.new(1, -20, 0, 50)
                SliderFrame.Position = UDim2.new(0, 10, 0, YPos)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = PickerWindow
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(0, 30, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = Name
                SliderLabel.TextColor3 = Color
                SliderLabel.Font = Enum.Font.GothamBold
                SliderLabel.TextSize = 14
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 40, 0, 20)
                SliderValue.Position = UDim2.new(1, -40, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(DefaultValue)
                SliderValue.TextColor3 = NexusUI.CurrentTheme.Text
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.TextSize = 12
                SliderValue.Parent = SliderFrame
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Size = UDim2.new(1, 0, 0, 4)
                SliderTrack.Position = UDim2.new(0, 0, 1, -10)
                SliderTrack.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Parent = SliderFrame
                
                Utility:CreateCorner(SliderTrack, 2)
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(DefaultValue / 255, 0, 1, 0)
                SliderFill.BackgroundColor3 = Color
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderTrack
                
                Utility:CreateCorner(SliderFill, 2)
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.BackgroundTransparency = 1
                SliderButton.Text = ""
                SliderButton.Parent = SliderTrack
                
                local Dragging = false
                
                local function UpdateSlider(Input)
                    local Position = math.clamp((Input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local Value = math.floor(Position * 255)
                    
                    SliderValue.Text = tostring(Value)
                    SliderFill.Size = UDim2.new(Position, 0, 1, 0)
                    
                    if Name == "R" then R = Value
                    elseif Name == "G" then G = Value
                    else B = Value end
                    
                    CurrentColor = Color3.fromRGB(R, G, B)
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    Config.Callback(CurrentColor)
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    Dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(Input)
                    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(Input)
                    end
                end)
            end
            
            CreateSlider("R", Color3.fromRGB(255, 100, 100), R, 50)
            CreateSlider("G", Color3.fromRGB(100, 255, 100), G, 110)
            CreateSlider("B", Color3.fromRGB(100, 100, 255), B, 170)
            
            -- Preview
            local Preview = Instance.new("Frame")
            Preview.Name = "Preview"
            Preview.Size = UDim2.new(1, -20, 0, 40)
            Preview.Position = UDim2.new(0, 10, 1, -50)
            Preview.BackgroundColor3 = CurrentColor
            Preview.BorderSizePixel = 0
            Preview.Parent = PickerWindow
            
            Utility:CreateCorner(Preview, 6)
        end)
        
        return ColorPickerFrame
    end
    
    return Tab
end

-- Create Window
function NexusUI:CreateWindow(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Nexus UI"
    Config.LoadingTitle = Config.LoadingTitle or "Loading"
    Config.LoadingSubtitle = Config.LoadingSubtitle or "Please wait..."
    Config.Size = Config.Size or UDim2.new(0, 550, 0, 600)
    Config.Theme = Config.Theme or "Dark"
    Config.ToggleKeybind = Config.ToggleKeybind or Enum.KeyCode.RightControl
    Config.SaveConfig = Config.SaveConfig or false
    
    -- Set theme
    NexusUI.CurrentTheme = NexusUI.Themes[Config.Theme] or NexusUI.Themes.Dark
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI_" .. Config.Name
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Protection
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Loading Screen
    local LoadingScreen = Instance.new("Frame")
    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
    LoadingScreen.BackgroundColor3 = NexusUI.CurrentTheme.Background
    LoadingScreen.BorderSizePixel = 0
    LoadingScreen.Parent = ScreenGui
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Name = "Title"
    LoadingTitle.Size = UDim2.new(0, 400, 0, 50)
    LoadingTitle.Position = UDim2.new(0.5, -200, 0.5, -50)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Text = Config.LoadingTitle
    LoadingTitle.TextColor3 = NexusUI.CurrentTheme.Text
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.TextSize = 32
    LoadingTitle.Parent = LoadingScreen
    
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Name = "Subtitle"
    LoadingSubtitle.Size = UDim2.new(0, 400, 0, 30)
    LoadingSubtitle.Position = UDim2.new(0.5, -200, 0.5, 10)
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Text = Config.LoadingSubtitle
    LoadingSubtitle.TextColor3 = NexusUI.CurrentTheme.SubText
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.TextSize = 16
    LoadingSubtitle.Parent = LoadingScreen
    
    -- Loading animation
    task.spawn(function()
        for i = 1, 3 do
            LoadingSubtitle.Text = Config.LoadingSubtitle .. "."
            task.wait(0.3)
            LoadingSubtitle.Text = Config.LoadingSubtitle .. ".."
            task.wait(0.3)
            LoadingSubtitle.Text = Config.LoadingSubtitle .. "..."
            task.wait(0.3)
        end
        
        Utility:Tween(LoadingScreen, {BackgroundTransparency = 1}, 0.5)
        for _, Child in pairs(LoadingScreen:GetChildren()) do
            if Child:IsA("TextLabel") then
                Utility:Tween(Child, {TextTransparency = 1}, 0.5)
            end
        end
        
        task.wait(0.5)
        LoadingScreen:Destroy()
    end)
    
    -- Main Window
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = Config.Size
    MainWindow.Position = UDim2.new(0.5, -Config.Size.X.Offset/2, 0.5, -Config.Size.Y.Offset/2)
    MainWindow.BackgroundColor3 = NexusUI.CurrentTheme.Background
    MainWindow.BorderSizePixel = 0
    MainWindow.Visible = false
    MainWindow.Parent = ScreenGui
    
    Utility:CreateCorner(MainWindow, 12)
    Utility:AddStroke(MainWindow, NexusUI.CurrentTheme.Border, 2)
    
    -- Show after loading
    task.delay(1, function()
        MainWindow.Visible = true
    end)
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainWindow
    
    Utility:CreateCorner(Topbar, 12)
    
    local TopbarCover = Instance.new("Frame")
    TopbarCover.Size = UDim2.new(1, 0, 0, 12)
    TopbarCover.Position = UDim2.new(0, 0, 1, -12)
    TopbarCover.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
    TopbarCover.BorderSizePixel = 0
    TopbarCover.Parent = Topbar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name
    Title.TextColor3 = NexusUI.CurrentTheme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
    MinimizeButton.BackgroundColor3 = NexusUI.CurrentTheme.Tertiary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = NexusUI.CurrentTheme.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 20
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Topbar
    
    Utility:CreateCorner(MinimizeButton, 8)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = NexusUI.CurrentTheme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Topbar
    
    Utility:CreateCorner(CloseButton, 8)
    
    -- Sidebar (Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, -60)
    Sidebar.Position = UDim2.new(0, 10, 0, 55)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainWindow
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = NexusUI.CurrentTheme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -210, 1, -60)
    ContentArea.Position = UDim2.new(0, 200, 0, 55)
    ContentArea.BackgroundColor3 = NexusUI.CurrentTheme.Secondary
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainWindow
    
    Utility:CreateCorner(ContentArea, 8)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, 0)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = ContentArea
    
    -- Make draggable
    Utility:MakeDraggable(MainWindow, Topbar)
    
    -- Make resizable
    Utility:MakeResizable(MainWindow, Vector2.new(400, 300))
    
    -- Toggle keybind
    local IsVisible = true
    UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed and Input.KeyCode == Config.ToggleKeybind then
            IsVisible = not IsVisible
            MainWindow.Visible = IsVisible
        end
    end)
    
    -- Minimize
    local IsMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            Utility:Tween(MainWindow, {Size = UDim2.new(0, MainWindow.Size.X.Offset, 0, 50)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Utility:Tween(MainWindow, {Size = Config.Size}, 0.3)
            MinimizeButton.Text = "−"
        end
    end)
    
    -- Close
    CloseButton.MouseButton1Click:Connect(function()
        Utility:Tween(MainWindow, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Hover effects
    MinimizeButton.MouseEnter:Connect(function()
        Utility:Tween(MinimizeButton, {BackgroundColor3 = NexusUI.CurrentTheme.Accent}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Utility:Tween(MinimizeButton, {BackgroundColor3 = NexusUI.CurrentTheme.Tertiary}, 0.2)
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Utility:Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Utility:Tween(CloseButton, {BackgroundColor3 = NexusUI.CurrentTheme.Error}, 0.2)
    end)
    
    -- Window object
    local WindowObject = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        Tabs = {},
        Config = Config
    }
    
    setmetatable(WindowObject, Window)
    
    -- Notification method
    function WindowObject:Notify(Config)
        return NotificationSystem:Create(Config)
    end
    
    -- Theme change method
    function WindowObject:SetTheme(ThemeName)
        local Theme = NexusUI.Themes[ThemeName]
        if not Theme then return end
        
        NexusUI.CurrentTheme = Theme
        
        -- Update all colors (simplified)
        MainWindow.BackgroundColor3 = Theme.Background
        Topbar.BackgroundColor3 = Theme.Secondary
        TopbarCover.BackgroundColor3 = Theme.Secondary
        Title.TextColor3 = Theme.Text
        ContentArea.BackgroundColor3 = Theme.Secondary
        
        for _, Tab in pairs(self.Tabs) do
            -- Update tab colors
        end
    end
    
    -- Save/Load configuration
    function WindowObject:SaveConfig(Name)
        local ConfigData = {}
        -- Implement config saving logic
        return ConfigSystem:Save(Name, ConfigData)
    end
    
    function WindowObject:LoadConfig(Name)
        local ConfigData = ConfigSystem:Load(Name)
        if ConfigData then
            -- Implement config loading logic
        end
        return ConfigData ~= nil
    end
    
    table.insert(NexusUI.Windows, WindowObject)
    
    return WindowObject
end

return NexusUI
