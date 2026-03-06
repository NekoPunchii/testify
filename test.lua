--[[
    Nexus UI Library v1.1 (Fixed)
    A modern, feature-rich UI library for Roblox exploits
]]

local NexusUI = {}
NexusUI.Version = "1.1.0"
NexusUI.Windows = {}
NexusUI.ConfigFolder = "NexusUI"

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--[[ UTILITY MODULE ]]--
local Utility = {}

function Utility:Tween(Object, Properties, Duration, Style, Direction)
    if not Object or not Object.Parent then return end
    Style = Style or Enum.EasingStyle.Quad
    Direction = Direction or Enum.EasingDirection.Out
    Duration = Duration or 0.3
    
    local TweenInf = TweenInfo.new(Duration, Style, Direction)
    local Tween = TweenService:Create(Object, TweenInf, Properties)
    Tween:Play()
    return Tween
end

function Utility:MakeDraggable(Frame, DragFrame)
    DragFrame = DragFrame or Frame
    local Dragging = false
    local DragInput
    local MousePos
    local FramePos
    
    DragFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
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
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - MousePos
            Frame.Position = UDim2.new(
                FramePos.X.Scale,
                FramePos.X.Offset + Delta.X,
                FramePos.Y.Scale,
                FramePos.Y.Offset + Delta.Y
            )
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

function Utility:RippleEffect(Button, Color)
    Color = Color or Color3.fromRGB(255, 255, 255)
    Button.ClipsDescendants = true
    
    Button.MouseButton1Click:Connect(function()
        local Ripple = Instance.new("Frame")
        Ripple.Name = "Ripple"
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local MouseLocation = UserInputService:GetMouseLocation()
        local RelativePosition = Vector2.new(
            MouseLocation.X - Button.AbsolutePosition.X,
            MouseLocation.Y - Button.AbsolutePosition.Y
        )
        
        Ripple.Position = UDim2.new(0, RelativePosition.X, 0, RelativePosition.Y)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.BackgroundColor3 = Color
        Ripple.BackgroundTransparency = 0.7
        Ripple.BorderSizePixel = 0
        Ripple.ZIndex = 10
        Ripple.Parent = Button
        
        Utility:CreateCorner(Ripple, 999)
        
        local MaxSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
        
        Utility:Tween(Ripple, {
            Size = UDim2.new(0, MaxSize, 0, MaxSize),
            BackgroundTransparency = 1
        }, 0.5)
        
        task.delay(0.5, function()
            if Ripple and Ripple.Parent then
                Ripple:Destroy()
            end
        end)
    end)
end

--[[ THEME SYSTEM ]]--
NexusUI.Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Tertiary = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(160, 160, 160),
        Border = Color3.fromRGB(55, 55, 60),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(235, 235, 240),
        Tertiary = Color3.fromRGB(220, 220, 225),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(20, 20, 25),
        SubText = Color3.fromRGB(100, 100, 105),
        Border = Color3.fromRGB(200, 200, 205),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26)
    },
    Aqua = {
        Background = Color3.fromRGB(15, 25, 35),
        Secondary = Color3.fromRGB(20, 35, 50),
        Tertiary = Color3.fromRGB(30, 50, 70),
        Accent = Color3.fromRGB(0, 200, 200),
        Text = Color3.fromRGB(240, 250, 255),
        SubText = Color3.fromRGB(150, 180, 200),
        Border = Color3.fromRGB(40, 70, 100),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26)
    },
    Purple = {
        Background = Color3.fromRGB(25, 20, 35),
        Secondary = Color3.fromRGB(35, 28, 50),
        Tertiary = Color3.fromRGB(50, 40, 70),
        Accent = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(245, 240, 255),
        SubText = Color3.fromRGB(180, 160, 200),
        Border = Color3.fromRGB(70, 55, 100),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26)
    }
}

NexusUI.CurrentTheme = NexusUI.Themes.Dark

--[[ NOTIFICATION SYSTEM ]]--
local NotificationSystem = {}
NotificationSystem.Container = nil
NotificationSystem.Queue = {}
NotificationSystem.Active = 0
NotificationSystem.MaxActive = 5

function NotificationSystem:Init(Parent)
    if self.Container then return end
    
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.Size = UDim2.new(0, 320, 1, 0)
    self.Container.Position = UDim2.new(1, -330, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = Parent
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = self.Container
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 20)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.Parent = self.Container
end

function NotificationSystem:Notify(Config)
    Config = Config or {}
    Config.Title = Config.Title or "Notification"
    Config.Description = Config.Description or ""
    Config.Type = Config.Type or "Info"
    Config.Duration = Config.Duration or 4
    
    if not self.Container then return end
    
    if self.Active >= self.MaxActive then
        table.insert(self.Queue, Config)
        return
    end
    
    self.Active = self.Active + 1
    
    local Theme = NexusUI.CurrentTheme
    local TypeColors = {
        Success = Theme.Success,
        Error = Theme.Error,
        Warning = Theme.Warning,
        Info = Theme.Accent
    }
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(1, 0, 0, 70)
    Notification.BackgroundColor3 = Theme.Secondary
    Notification.BorderSizePixel = 0
    Notification.BackgroundTransparency = 1
    Notification.Parent = self.Container
    
    Utility:CreateCorner(Notification, 8)
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 4, 1, -10)
    Indicator.Position = UDim2.new(0, 5, 0, 5)
    Indicator.BackgroundColor3 = TypeColors[Config.Type] or Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Notification
    
    Utility:CreateCorner(Indicator, 2)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -60, 0, 22)
    Title.Position = UDim2.new(0, 18, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 1
    Title.Parent = Notification
    
    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(1, -60, 0, 30)
    Description.Position = UDim2.new(0, 18, 0, 32)
    Description.BackgroundTransparency = 1
    Description.Text = Config.Description
    Description.TextColor3 = Theme.SubText
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.TextWrapped = true
    Description.TextTransparency = 1
    Description.Parent = Notification
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme.SubText
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.TextTransparency = 1
    CloseBtn.Parent = Notification
    
    Utility:Tween(Notification, {BackgroundTransparency = 0}, 0.3)
    Utility:Tween(Title, {TextTransparency = 0}, 0.3)
    Utility:Tween(Description, {TextTransparency = 0}, 0.3)
    Utility:Tween(CloseBtn, {TextTransparency = 0}, 0.3)
    
    local Closed = false
    local function Close()
        if Closed then return end
        Closed = true
        
        Utility:Tween(Notification, {BackgroundTransparency = 1}, 0.3)
        Utility:Tween(Title, {TextTransparency = 1}, 0.3)
        Utility:Tween(Description, {TextTransparency = 1}, 0.3)
        Utility:Tween(CloseBtn, {TextTransparency = 1}, 0.3)
        
        task.wait(0.3)
        if Notification and Notification.Parent then
            Notification:Destroy()
        end
        self.Active = self.Active - 1
        
        if #self.Queue > 0 then
            local Next = table.remove(self.Queue, 1)
            self:Notify(Next)
        end
    end
    
    CloseBtn.MouseButton1Click:Connect(Close)
    task.delay(Config.Duration, Close)
end

--[[ CREATE WINDOW ]]--
function NexusUI:CreateWindow(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Nexus UI"
    Config.LoadingTitle = Config.LoadingTitle or "Nexus UI"
    Config.LoadingSubtitle = Config.LoadingSubtitle or "Loading..."
    Config.Theme = Config.Theme or "Dark"
    Config.ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    Config.Size = Config.Size or {550, 400}
    
    if NexusUI.Themes[Config.Theme] then
        NexusUI.CurrentTheme = NexusUI.Themes[Config.Theme]
    end
    
    local Theme = NexusUI.CurrentTheme
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    NotificationSystem:Init(ScreenGui)
    
    -- Loading Screen
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "Loading"
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = Theme.Background
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.ZIndex = 100
    LoadingFrame.Parent = ScreenGui
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
    LoadingTitle.Position = UDim2.new(0, 0, 0.5, -30)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Text = Config.LoadingTitle
    LoadingTitle.TextColor3 = Theme.Text
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.TextSize = 28
    LoadingTitle.ZIndex = 101
    LoadingTitle.Parent = LoadingFrame
    
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Size = UDim2.new(1, 0, 0, 25)
    LoadingSubtitle.Position = UDim2.new(0, 0, 0.5, 15)
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Text = Config.LoadingSubtitle
    LoadingSubtitle.TextColor3 = Theme.SubText
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.TextSize = 16
    LoadingSubtitle.ZIndex = 101
    LoadingSubtitle.Parent = LoadingFrame
    
    task.spawn(function()
        local Dots = {".", "..", "..."}
        for i = 1, 9 do
            if not LoadingSubtitle or not LoadingSubtitle.Parent then break end
            LoadingSubtitle.Text = Config.LoadingSubtitle .. Dots[(i % 3) + 1]
            task.wait(0.25)
        end
        
        if LoadingFrame and LoadingFrame.Parent then
            Utility:Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
            Utility:Tween(LoadingTitle, {TextTransparency = 1}, 0.5)
            Utility:Tween(LoadingSubtitle, {TextTransparency = 1}, 0.5)
            
            task.wait(0.5)
            if LoadingFrame and LoadingFrame.Parent then
                LoadingFrame:Destroy()
            end
        end
    end)
    
    -- Main Window
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, Config.Size[1], 0, Config.Size[2])
    MainWindow.Position = UDim2.new(0.5, -Config.Size[1]/2, 0.5, -Config.Size[2]/2)
    MainWindow.BackgroundColor3 = Theme.Background
    MainWindow.BorderSizePixel = 0
    MainWindow.Parent = ScreenGui
    
    Utility:CreateCorner(MainWindow, 10)
    Utility:AddStroke(MainWindow, Theme.Border, 1)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainWindow
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar
    
    local TopCover = Instance.new("Frame")
    TopCover.Size = UDim2.new(1, 0, 0, 10)
    TopCover.Position = UDim2.new(0, 0, 1, -10)
    TopCover.BackgroundColor3 = Theme.Secondary
    TopCover.BorderSizePixel = 0
    TopCover.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Name
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 22
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = TopBar
    
    Utility:CreateCorner(CloseButton, 8)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(1, -80, 0, 5)
    MinimizeButton.BackgroundColor3 = Theme.Tertiary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 22
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = TopBar
    
    Utility:CreateCorner(MinimizeButton, 8)
    
    Utility:MakeDraggable(MainWindow, TopBar)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -55)
    Sidebar.Position = UDim2.new(0, 5, 0, 50)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainWindow
    
    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Name = "TabHolder"
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.BackgroundTransparency = 1
    TabHolder.BorderSizePixel = 0
    TabHolder.ScrollBarThickness = 2
    TabHolder.ScrollBarImageColor3 = Theme.Accent
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabHolder
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    -- Content Container
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -165, 1, -55)
    ContentHolder.Position = UDim2.new(0, 160, 0, 50)
    ContentHolder.BackgroundColor3 = Theme.Secondary
    ContentHolder.BorderSizePixel = 0
    ContentHolder.Parent = MainWindow
    
    Utility:CreateCorner(ContentHolder, 8)
    
    -- Window Object
    local Window = {}
    Window.ScreenGui = ScreenGui
    Window.MainWindow = MainWindow
    Window.TabHolder = TabHolder
    Window.ContentHolder = ContentHolder
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    Window.OriginalSize = UDim2.new(0, Config.Size[1], 0, Config.Size[2])
    Window.Visible = true
    
    -- Close (Hide) functionality
    CloseButton.MouseButton1Click:Connect(function()
        Window.Visible = false
        MainWindow.Visible = false
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Utility:Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Utility:Tween(CloseButton, {BackgroundColor3 = Theme.Error}, 0.2)
    end)
    
    -- Minimize functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        
        if Window.Minimized then
            Utility:Tween(MainWindow, {Size = UDim2.new(0, MainWindow.Size.X.Offset, 0, 45)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Utility:Tween(MainWindow, {Size = Window.OriginalSize}, 0.3)
            MinimizeButton.Text = "-"
        end
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Utility:Tween(MinimizeButton, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Utility:Tween(MinimizeButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed and Input.KeyCode == Config.ToggleKey then
            Window.Visible = not Window.Visible
            MainWindow.Visible = Window.Visible
        end
    end)
    
    -- Notification method
    function Window:Notify(NotifyConfig)
        NotificationSystem:Notify(NotifyConfig)
    end
    
    -- Destroy method
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    -- Toggle method
    function Window:Toggle(State)
        if State ~= nil then
            Window.Visible = State
        else
            Window.Visible = not Window.Visible
        end
        MainWindow.Visible = Window.Visible
    end
    
    -- Create Tab Method
    function Window:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or "●"
        
        local Tab = {}
        Tab.Name = TabConfig.Name
        Tab.Elements = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabConfig.Name
        TabButton.Size = UDim2.new(1, -8, 0, 35)
        TabButton.BackgroundColor3 = Theme.Tertiary
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabHolder
        
        Utility:CreateCorner(TabButton, 6)
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 25, 1, 0)
        TabIcon.Position = UDim2.new(0, 8, 0, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = TabConfig.Icon
        TabIcon.TextColor3 = Theme.SubText
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.TextSize = 14
        TabIcon.Parent = TabButton
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Position = UDim2.new(0, 35, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = TabConfig.Name
        TabText.TextColor3 = Theme.SubText
        TabText.Font = Enum.Font.GothamSemibold
        TabText.TextSize = 13
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabConfig.Name .. "_Content"
        TabContent.Size = UDim2.new(1, -15, 1, -15)
        TabContent.Position = UDim2.new(0, 8, 0, 8)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentHolder
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.Parent = TabContent
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Store references
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.IconLabel = TabIcon
        Tab.TextLabel = TabText
        
        -- Tab selection function
        local function SelectTab()
            -- Deselect all tabs
            for _, OtherTab in pairs(Window.Tabs) do
                if OtherTab.Content then
                    OtherTab.Content.Visible = false
                end
                if OtherTab.Button then
                    Utility:Tween(OtherTab.Button, {BackgroundTransparency = 1}, 0.2)
                end
                if OtherTab.IconLabel then
                    OtherTab.IconLabel.TextColor3 = Theme.SubText
                end
                if OtherTab.TextLabel then
                    OtherTab.TextLabel.TextColor3 = Theme.SubText
                end
            end
            
            -- Select this tab
            TabContent.Visible = true
            Utility:Tween(TabButton, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Tertiary}, 0.2)
            TabIcon.TextColor3 = Theme.Accent
            TabText.TextColor3 = Theme.Text
            Window.ActiveTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Utility:Tween(TabButton, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.Tertiary}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Utility:Tween(TabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab automatically
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        --[[ TAB ELEMENT METHODS ]]--
        
        function Tab:CreateSection(SectionName)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundTransparency = 1
            Section.Parent = TabContent
            
            local SectionText = Instance.new("TextLabel")
            SectionText.Size = UDim2.new(1, 0, 0, 20)
            SectionText.Position = UDim2.new(0, 0, 0, 5)
            SectionText.BackgroundTransparency = 1
            SectionText.Text = SectionName or "Section"
            SectionText.TextColor3 = Theme.Text
            SectionText.Font = Enum.Font.GothamBold
            SectionText.TextSize = 14
            SectionText.TextXAlignment = Enum.TextXAlignment.Left
            SectionText.Parent = Section
            
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.Position = UDim2.new(0, 0, 1, -2)
            Divider.BackgroundColor3 = Theme.Border
            Divider.BorderSizePixel = 0
            Divider.Parent = Section
            
            return Section
        end
        
        function Tab:CreateButton(ButtonConfig)
            ButtonConfig = ButtonConfig or {}
            ButtonConfig.Name = ButtonConfig.Name or "Button"
            ButtonConfig.Description = ButtonConfig.Description or nil
            ButtonConfig.Callback = ButtonConfig.Callback or function() end
            
            local HasDesc = ButtonConfig.Description ~= nil
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, HasDesc and 50 or 35)
            ButtonFrame.BackgroundColor3 = Theme.Tertiary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            Utility:CreateCorner(ButtonFrame, 6)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Clickable"
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            Button.Parent = ButtonFrame
            
            local ButtonText = Instance.new("TextLabel")
            ButtonText.Size = UDim2.new(1, -20, 0, 20)
            ButtonText.Position = UDim2.new(0, 10, 0, HasDesc and 6 or 8)
            ButtonText.BackgroundTransparency = 1
            ButtonText.Text = ButtonConfig.Name
            ButtonText.TextColor3 = Theme.Text
            ButtonText.Font = Enum.Font.GothamSemibold
            ButtonText.TextSize = 13
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left
            ButtonText.Parent = ButtonFrame
            
            if HasDesc then
                local DescText = Instance.new("TextLabel")
                DescText.Size = UDim2.new(1, -20, 0, 18)
                DescText.Position = UDim2.new(0, 10, 0, 26)
                DescText.BackgroundTransparency = 1
                DescText.Text = ButtonConfig.Description
                DescText.TextColor3 = Theme.SubText
                DescText.Font = Enum.Font.Gotham
                DescText.TextSize = 11
                DescText.TextXAlignment = Enum.TextXAlignment.Left
                DescText.Parent = ButtonFrame
            end
            
            Utility:RippleEffect(Button)
            
            Button.MouseButton1Click:Connect(function()
                pcall(ButtonConfig.Callback)
            end)
            
            Button.MouseEnter:Connect(function()
                Utility:Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Utility:Tween(ButtonFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end)
            
            local ButtonObj = {}
            ButtonObj.Frame = ButtonFrame
            
            function ButtonObj:SetText(NewText)
                ButtonText.Text = NewText
            end
            
            return ButtonObj
        end
        
        function Tab:CreateToggle(ToggleConfig)
            ToggleConfig = ToggleConfig or {}
            ToggleConfig.Name = ToggleConfig.Name or "Toggle"
            ToggleConfig.CurrentValue = ToggleConfig.CurrentValue or false
            ToggleConfig.Callback = ToggleConfig.Callback or function() end
            
            local Toggled = ToggleConfig.CurrentValue
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Theme.Tertiary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            Utility:CreateCorner(ToggleFrame, 6)
            
            local ToggleText = Instance.new("TextLabel")
            ToggleText.Size = UDim2.new(1, -70, 1, 0)
            ToggleText.Position = UDim2.new(0, 10, 0, 0)
            ToggleText.BackgroundTransparency = 1
            ToggleText.Text = ToggleConfig.Name
            ToggleText.TextColor3 = Theme.Text
            ToggleText.Font = Enum.Font.GothamSemibold
            ToggleText.TextSize = 13
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 44, 0, 22)
            ToggleButton.Position = UDim2.new(1, -54, 0.5, -11)
            ToggleButton.BackgroundColor3 = Toggled and Theme.Accent or Theme.Border
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            Utility:CreateCorner(ToggleButton, 11)
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            Utility:CreateCorner(ToggleCircle, 9)
            
            local function UpdateToggle(Value)
                Toggled = Value
                
                Utility:Tween(ToggleButton, {
                    BackgroundColor3 = Toggled and Theme.Accent or Theme.Border
                }, 0.2)
                
                Utility:Tween(ToggleCircle, {
                    Position = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                }, 0.2)
                
                pcall(ToggleConfig.Callback, Toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                UpdateToggle(not Toggled)
            end)
            
            local ToggleObj = {}
            ToggleObj.Frame = ToggleFrame
            
            function ToggleObj:SetValue(Value)
                UpdateToggle(Value)
            end
            
            function ToggleObj:GetValue()
                return Toggled
            end
            
            return ToggleObj
        end
        
        function Tab:CreateSlider(SliderConfig)
            SliderConfig = SliderConfig or {}
            SliderConfig.Name = SliderConfig.Name or "Slider"
            SliderConfig.Min = SliderConfig.Min or 0
            SliderConfig.Max = SliderConfig.Max or 100
            SliderConfig.Default = SliderConfig.Default or 50
            SliderConfig.Increment = SliderConfig.Increment or 1
            SliderConfig.Callback = SliderConfig.Callback or function() end
            
            local CurrentValue = SliderConfig.Default
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.Tertiary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            Utility:CreateCorner(SliderFrame, 6)
            
            local SliderText = Instance.new("TextLabel")
            SliderText.Size = UDim2.new(1, -60, 0, 20)
            SliderText.Position = UDim2.new(0, 10, 0, 5)
            SliderText.BackgroundTransparency = 1
            SliderText.Text = SliderConfig.Name
            SliderText.TextColor3 = Theme.Text
            SliderText.Font = Enum.Font.GothamSemibold
            SliderText.TextSize = 13
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -55, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(CurrentValue)
            SliderValue.TextColor3 = Theme.Accent
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 13
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -20, 0, 6)
            SliderTrack.Position = UDim2.new(0, 10, 0, 33)
            SliderTrack.BackgroundColor3 = Theme.Secondary
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderFrame
            
            Utility:CreateCorner(SliderTrack, 3)
            
            local FillPercent = (CurrentValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(FillPercent, 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            Utility:CreateCorner(SliderFill, 3)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 10)
            SliderButton.Position = UDim2.new(0, 0, 0, -5)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderTrack
            
            local Dragging = false
            
            local function UpdateSlider(InputX)
                local TrackPos = SliderTrack.AbsolutePosition.X
                local TrackSize = SliderTrack.AbsoluteSize.X
                
                local Position = math.clamp((InputX - TrackPos) / TrackSize, 0, 1)
                local RawValue = SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * Position
                local Value = math.floor(RawValue / SliderConfig.Increment + 0.5) * SliderConfig.Increment
                Value = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
                
                CurrentValue = Value
                SliderValue.Text = tostring(Value)
                
                local FillSize = (Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                Utility:Tween(SliderFill, {Size = UDim2.new(FillSize, 0, 1, 0)}, 0.1)
                
                pcall(SliderConfig.Callback, Value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                Dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(Input.Position.X)
                end
            end)
            
            SliderButton.MouseButton1Click:Connect(function()
                local MouseLoc = UserInputService:GetMouseLocation()
                UpdateSlider(MouseLoc.X)
            end)
            
            local SliderObj = {}
            SliderObj.Frame = SliderFrame
            
            function SliderObj:SetValue(Value)
                CurrentValue = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
                SliderValue.Text = tostring(CurrentValue)
                local FillSize = (CurrentValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                SliderFill.Size = UDim2.new(FillSize, 0, 1, 0)
                pcall(SliderConfig.Callback, CurrentValue)
            end
            
            function SliderObj:GetValue()
                return CurrentValue
            end
            
            return SliderObj
        end
        
        function Tab:CreateDropdown(DropdownConfig)
            DropdownConfig = DropdownConfig or {}
            DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
            DropdownConfig.Options = DropdownConfig.Options or {}
            DropdownConfig.CurrentOption = DropdownConfig.CurrentOption or (DropdownConfig.Options[1] or "")
            DropdownConfig.MultiSelect = DropdownConfig.MultiSelect or false
            DropdownConfig.Callback = DropdownConfig.Callback or function() end
            
            local Selected = DropdownConfig.MultiSelect and {} or DropdownConfig.CurrentOption
            local IsOpen = false
            local OptionButtons = {}
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            DropdownFrame.BackgroundColor3 = Theme.Tertiary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            Utility:CreateCorner(DropdownFrame, 6)
            
            local DropdownText = Instance.new("TextLabel")
            DropdownText.Size = UDim2.new(1, -40, 0, 35)
            DropdownText.Position = UDim2.new(0, 10, 0, 0)
            DropdownText.BackgroundTransparency = 1
            DropdownText.Text = DropdownConfig.Name
            DropdownText.TextColor3 = Theme.Text
            DropdownText.Font = Enum.Font.GothamSemibold
            DropdownText.TextSize = 13
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left
            DropdownText.Parent = DropdownFrame
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, 35)
            DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Theme.SubText
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.TextSize = 10
            DropdownArrow.Parent = DropdownFrame
            
            local OptionsHolder = Instance.new("Frame")
            OptionsHolder.Name = "Options"
            OptionsHolder.Size = UDim2.new(1, -10, 0, 0)
            OptionsHolder.Position = UDim2.new(0, 5, 0, 40)
            OptionsHolder.BackgroundTransparency = 1
            OptionsHolder.Parent = DropdownFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 3)
            OptionsLayout.Parent = OptionsHolder
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local function CreateOption(OptionName)
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = OptionName
                OptionButton.Size = UDim2.new(1, 0, 0, 28)
                OptionButton.BackgroundColor3 = Theme.Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = OptionName
                OptionButton.TextColor3 = Theme.Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 12
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = OptionsHolder
                
                Utility:CreateCorner(OptionButton, 4)
                
                OptionButtons[OptionName] = OptionButton
                
                if DropdownConfig.MultiSelect then
                    if table.find(Selected, OptionName) then
                        OptionButton.BackgroundColor3 = Theme.Accent
                    end
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        local Index = table.find(Selected, OptionName)
                        if Index then
                            table.remove(Selected, Index)
                            Utility:Tween(OptionButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
                        else
                            table.insert(Selected, OptionName)
                            Utility:Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                        end
                        pcall(DropdownConfig.Callback, Selected)
                    end)
                else
                    if OptionName == Selected then
                        OptionButton.BackgroundColor3 = Theme.Accent
                    end
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Selected = OptionName
                        pcall(DropdownConfig.Callback, Selected)
                        
                        for _, Btn in pairs(OptionButtons) do
                            if Btn and Btn.Parent then
                                Utility:Tween(Btn, {BackgroundColor3 = Theme.Secondary}, 0.2)
                            end
                        end
                        Utility:Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                        
                        IsOpen = false
                        Utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                        Utility:Tween(DropdownArrow, {Rotation = 0}, 0.3)
                    end)
                end
                
                OptionButton.MouseEnter:Connect(function()
                    local IsSelected = DropdownConfig.MultiSelect and table.find(Selected, OptionName) or OptionName == Selected
                    if not IsSelected then
                        Utility:Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    local IsSelected = DropdownConfig.MultiSelect and table.find(Selected, OptionName) or OptionName == Selected
                    if not IsSelected then
                        Utility:Tween(OptionButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    end
                end)
            end
            
            for _, Option in ipairs(DropdownConfig.Options) do
                CreateOption(Option)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                local OptionCount = #DropdownConfig.Options
                local TargetHeight = IsOpen and (40 + (OptionCount * 31)) or 35
                Utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, TargetHeight)}, 0.3)
                Utility:Tween(DropdownArrow, {Rotation = IsOpen and 180 or 0}, 0.3)
            end)
            
            local DropdownObj = {}
            DropdownObj.Frame = DropdownFrame
            
            function DropdownObj:Refresh(NewOptions)
                for _, Child in pairs(OptionsHolder:GetChildren()) do
                    if Child:IsA("TextButton") then
                        Child:Destroy()
                    end
                end
                OptionButtons = {}
                
                DropdownConfig.Options = NewOptions
                for _, Option in ipairs(NewOptions) do
                    CreateOption(Option)
                end
                
                if IsOpen then
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 40 + (#NewOptions * 31))
                end
            end
            
            function DropdownObj:SetValue(Value)
                Selected = Value
                for Name, Btn in pairs(OptionButtons) do
                    if Btn and Btn.Parent then
                        local IsSelected = DropdownConfig.MultiSelect and table.find(Selected, Name) or Name == Selected
                        Btn.BackgroundColor3 = IsSelected and Theme.Accent or Theme.Secondary
                    end
                end
                pcall(DropdownConfig.Callback, Selected)
            end
            
            function DropdownObj:GetValue()
                return Selected
            end
            
            return DropdownObj
        end
        
        function Tab:CreateTextbox(TextboxConfig)
            TextboxConfig = TextboxConfig or {}
            TextboxConfig.Name = TextboxConfig.Name or "Textbox"
            TextboxConfig.PlaceholderText = TextboxConfig.PlaceholderText or "Enter text..."
            TextboxConfig.Default = TextboxConfig.Default or ""
            TextboxConfig.Callback = TextboxConfig.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "Textbox"
            TextboxFrame.Size = UDim2.new(1, 0, 0, 65)
            TextboxFrame.BackgroundColor3 = Theme.Tertiary
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            Utility:CreateCorner(TextboxFrame, 6)
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 22)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = TextboxConfig.Name
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.Font = Enum.Font.GothamSemibold
            TextboxLabel.TextSize = 13
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -20, 0, 28)
            Textbox.Position = UDim2.new(0, 10, 0, 30)
            Textbox.BackgroundColor3 = Theme.Secondary
            Textbox.BorderSizePixel = 0
            Textbox.Text = TextboxConfig.Default
            Textbox.PlaceholderText = TextboxConfig.PlaceholderText
            Textbox.TextColor3 = Theme.Text
            Textbox.PlaceholderColor3 = Theme.SubText
            Textbox.Font = Enum.Font.Gotham
            Textbox.TextSize = 12
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            Utility:CreateCorner(Textbox, 4)
            
            Textbox.Focused:Connect(function()
                Utility:Tween(Textbox, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            Textbox.FocusLost:Connect(function(EnterPressed)
                Utility:Tween(Textbox, {BackgroundColor3 = Theme.Secondary}, 0.2)
                if EnterPressed then
                    pcall(TextboxConfig.Callback, Textbox.Text)
                end
            end)
            
            local TextboxObj = {}
            TextboxObj.Frame = TextboxFrame
            
            function TextboxObj:SetValue(Value)
                Textbox.Text = Value
            end
            
            function TextboxObj:GetValue()
                return Textbox.Text
            end
            
            return TextboxObj
        end
        
        function Tab:CreateKeybind(KeybindConfig)
            KeybindConfig = KeybindConfig or {}
            KeybindConfig.Name = KeybindConfig.Name or "Keybind"
            KeybindConfig.CurrentKeybind = KeybindConfig.CurrentKeybind or "None"
            KeybindConfig.Mode = KeybindConfig.Mode or "Toggle"
            KeybindConfig.Callback = KeybindConfig.Callback or function() end
            
            local CurrentKey = KeybindConfig.CurrentKeybind
            local Listening = false
            local IsActive = false
            local Connection
            local Connection2
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "Keybind"
            KeybindFrame.Size = UDim2.new(1, 0, 0, 35)
            KeybindFrame.BackgroundColor3 = Theme.Tertiary
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            
            Utility:CreateCorner(KeybindFrame, 6)
            
            local KeybindText = Instance.new("TextLabel")
            KeybindText.Size = UDim2.new(1, -100, 1, 0)
            KeybindText.Position = UDim2.new(0, 10, 0, 0)
            KeybindText.BackgroundTransparency = 1
            KeybindText.Text = KeybindConfig.Name
            KeybindText.TextColor3 = Theme.Text
            KeybindText.Font = Enum.Font.GothamSemibold
            KeybindText.TextSize = 13
            KeybindText.TextXAlignment = Enum.TextXAlignment.Left
            KeybindText.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 80, 0, 25)
            KeybindButton.Position = UDim2.new(1, -90, 0.5, -12.5)
            KeybindButton.BackgroundColor3 = Theme.Secondary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = CurrentKey
            KeybindButton.TextColor3 = Theme.Text
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.TextSize = 11
            KeybindButton.AutoButtonColor = false
            KeybindButton.Parent = KeybindFrame
            
            Utility:CreateCorner(KeybindButton, 4)
            
            KeybindButton.MouseButton1Click:Connect(function()
                Listening = true
                KeybindButton.Text = "..."
                Utility:Tween(KeybindButton, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            Connection = UserInputService.InputBegan:Connect(function(Input, Processed)
                if Listening then
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = Input.KeyCode.Name
                        KeybindButton.Text = CurrentKey
                        Listening = false
                        Utility:Tween(KeybindButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    end
                elseif not Processed and Input.KeyCode and Input.KeyCode.Name == CurrentKey then
                    if KeybindConfig.Mode == "Toggle" then
                        IsActive = not IsActive
                        pcall(KeybindConfig.Callback, IsActive)
                    else
                        pcall(KeybindConfig.Callback, true)
                    end
                end
            end)
            
            if KeybindConfig.Mode == "Hold" then
                Connection2 = UserInputService.InputEnded:Connect(function(Input)
                    if Input.KeyCode and Input.KeyCode.Name == CurrentKey then
                        pcall(KeybindConfig.Callback, false)
                    end
                end)
            end
            
            local KeybindObj = {}
            KeybindObj.Frame = KeybindFrame
            
            function KeybindObj:SetKeybind(Key)
                CurrentKey = Key
                KeybindButton.Text = Key
            end
            
            function KeybindObj:GetKeybind()
                return CurrentKey
            end
            
            return KeybindObj
        end
        
        function Tab:CreateLabel(LabelText)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.Size = UDim2.new(1, 0, 0, 25)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = LabelText or "Label"
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelFrame
            
            local LabelObj = {}
            LabelObj.Frame = LabelFrame
            
            function LabelObj:SetText(NewText)
                Label.Text = NewText
            end
            
            return LabelObj
        end
        
        function Tab:CreateParagraph(Title, Content)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = "Paragraph"
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 70)
            ParagraphFrame.BackgroundColor3 = Theme.Tertiary
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContent
            
            Utility:CreateCorner(ParagraphFrame, 6)
            
            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -20, 0, 22)
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = Title or "Title"
            ParagraphTitle.TextColor3 = Theme.Text
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextSize = 14
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame
            
            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -20, 0, 40)
            ParagraphContent.Position = UDim2.new(0, 10, 0, 28)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = Content or "Content"
            ParagraphContent.TextColor3 = Theme.SubText
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextSize = 12
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame
            
            local ParagraphObj = {}
            ParagraphObj.Frame = ParagraphFrame
            
            function ParagraphObj:SetTitle(NewTitle)
                ParagraphTitle.Text = NewTitle
            end
            
            function ParagraphObj:SetContent(NewContent)
                ParagraphContent.Text = NewContent
            end
            
            return ParagraphObj
        end
        
        function Tab:CreateColorPicker(ColorConfig)
            ColorConfig = ColorConfig or {}
            ColorConfig.Name = ColorConfig.Name or "Color Picker"
            ColorConfig.Default = ColorConfig.Default or Color3.fromRGB(255, 255, 255)
            ColorConfig.Callback = ColorConfig.Callback or function() end
            
            local CurrentColor = ColorConfig.Default
            local PickerOpen = false
            local R, G, B = math.floor(CurrentColor.R * 255), math.floor(CurrentColor.G * 255), math.floor(CurrentColor.B * 255)
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = "ColorPicker"
            ColorFrame.Size = UDim2.new(1, 0, 0, 35)
            ColorFrame.BackgroundColor3 = Theme.Tertiary
            ColorFrame.BorderSizePixel = 0
            ColorFrame.ClipsDescendants = true
            ColorFrame.Parent = TabContent
            
            Utility:CreateCorner(ColorFrame, 6)
            
            local ColorText = Instance.new("TextLabel")
            ColorText.Size = UDim2.new(1, -60, 0, 35)
            ColorText.Position = UDim2.new(0, 10, 0, 0)
            ColorText.BackgroundTransparency = 1
            ColorText.Text = ColorConfig.Name
            ColorText.TextColor3 = Theme.Text
            ColorText.Font = Enum.Font.GothamSemibold
            ColorText.TextSize = 13
            ColorText.TextXAlignment = Enum.TextXAlignment.Left
            ColorText.Parent = ColorFrame
            
            local ColorDisplay = Instance.new("TextButton")
            ColorDisplay.Size = UDim2.new(0, 40, 0, 25)
            ColorDisplay.Position = UDim2.new(1, -50, 0, 5)
            ColorDisplay.BackgroundColor3 = CurrentColor
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Text = ""
            ColorDisplay.AutoButtonColor = false
            ColorDisplay.Parent = ColorFrame
            
            Utility:CreateCorner(ColorDisplay, 4)
            Utility:AddStroke(ColorDisplay, Theme.Border, 2)
            
            local SlidersHolder = Instance.new("Frame")
            SlidersHolder.Size = UDim2.new(1, -20, 0, 100)
            SlidersHolder.Position = UDim2.new(0, 10, 0, 40)
            SlidersHolder.BackgroundTransparency = 1
            SlidersHolder.Parent = ColorFrame
            
            local SliderRefs = {}
            
            local function CreateColorSlider(Name, DefaultValue, YPos, SliderColor)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 28)
                SliderFrame.Position = UDim2.new(0, 0, 0, YPos)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = SlidersHolder
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(0, 20, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = Name
                SliderLabel.TextColor3 = SliderColor
                SliderLabel.Font = Enum.Font.GothamBold
                SliderLabel.TextSize = 12
                SliderLabel.Parent = SliderFrame
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Size = UDim2.new(1, -70, 0, 6)
                SliderTrack.Position = UDim2.new(0, 25, 0.5, -3)
                SliderTrack.BackgroundColor3 = Theme.Secondary
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Parent = SliderFrame
                
                Utility:CreateCorner(SliderTrack, 3)
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(DefaultValue / 255, 0, 1, 0)
                SliderFill.BackgroundColor3 = SliderColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderTrack
                
                Utility:CreateCorner(SliderFill, 3)
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 35, 0, 20)
                SliderValue.Position = UDim2.new(1, -35, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(DefaultValue)
                SliderValue.TextColor3 = Theme.Text
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.TextSize = 11
                SliderValue.Parent = SliderFrame
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Size = UDim2.new(1, 0, 1, 10)
                SliderButton.Position = UDim2.new(0, 0, 0, -5)
                SliderButton.BackgroundTransparency = 1
                SliderButton.Text = ""
                SliderButton.Parent = SliderTrack
                
                SliderRefs[Name] = {Fill = SliderFill, Value = SliderValue}
                
                local Dragging = false
                
                local function UpdateColor(InputX)
                    local Position = math.clamp((InputX - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local Value = math.floor(Position * 255)
                    
                    SliderValue.Text = tostring(Value)
                    SliderFill.Size = UDim2.new(Position, 0, 1, 0)
                    
                    if Name == "R" then R = Value
                    elseif Name == "G" then G = Value
                    else B = Value end
                    
                    CurrentColor = Color3.fromRGB(R, G, B)
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    pcall(ColorConfig.Callback, CurrentColor)
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
                        UpdateColor(Input.Position.X)
                    end
                end)
                
                SliderButton.MouseButton1Click:Connect(function()
                    local MouseLoc = UserInputService:GetMouseLocation()
                    UpdateColor(MouseLoc.X)
                end)
            end
            
            CreateColorSlider("R", R, 0, Color3.fromRGB(255, 100, 100))
            CreateColorSlider("G", G, 32, Color3.fromRGB(100, 255, 100))
            CreateColorSlider("B", B, 64, Color3.fromRGB(100, 100, 255))
            
            ColorDisplay.MouseButton1Click:Connect(function()
                PickerOpen = not PickerOpen
                local TargetHeight = PickerOpen and 145 or 35
                Utility:Tween(ColorFrame, {Size = UDim2.new(1, 0, 0, TargetHeight)}, 0.3)
            end)
            
            local ColorObj = {}
            ColorObj.Frame = ColorFrame
            
            function ColorObj:SetColor(NewColor)
                CurrentColor = NewColor
                ColorDisplay.BackgroundColor3 = NewColor
                R = math.floor(NewColor.R * 255)
                G = math.floor(NewColor.G * 255)
                B = math.floor(NewColor.B * 255)
                
                if SliderRefs["R"] then
                    SliderRefs["R"].Fill.Size = UDim2.new(R / 255, 0, 1, 0)
                    SliderRefs["R"].Value.Text = tostring(R)
                end
                if SliderRefs["G"] then
                    SliderRefs["G"].Fill.Size = UDim2.new(G / 255, 0, 1, 0)
                    SliderRefs["G"].Value.Text = tostring(G)
                end
                if SliderRefs["B"] then
                    SliderRefs["B"].Fill.Size = UDim2.new(B / 255, 0, 1, 0)
                    SliderRefs["B"].Value.Text = tostring(B)
                end
                
                pcall(ColorConfig.Callback, NewColor)
            end
            
            function ColorObj:GetColor()
                return CurrentColor
            end
            
            return ColorObj
        end
        
        return Tab
    end
    
    table.insert(NexusUI.Windows, Window)
    
    return Window
end

return NexusUI
