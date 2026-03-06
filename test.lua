local NexusUI = {}
NexusUI.Windows = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local Utility = {}

function Utility:Tween(Object, Properties, Duration)
    if not Object or not Object.Parent then return end
    local TweenInf = TweenInfo.new(Duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(Object, TweenInf, Properties)
    Tween:Play()
    return Tween
end

function Utility:MakeDraggable(Frame, DragFrame)
    DragFrame = DragFrame or Frame
    local Dragging = false
    local DragInput = nil
    local MousePos = nil
    local FramePos = nil
    
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
            Frame.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
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
    }
}

NexusUI.CurrentTheme = NexusUI.Themes.Dark

local Notifications = {}
Notifications.Container = nil
Notifications.Active = 0

function Notifications:Init(Parent)
    if self.Container then return end
    self.Container = Instance.new("Frame")
    self.Container.Name = "Notifications"
    self.Container.Size = UDim2.new(0, 300, 1, 0)
    self.Container.Position = UDim2.new(1, -310, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = Parent
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = self.Container
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 20)
    Padding.Parent = self.Container
end

function Notifications:Send(Config)
    if not self.Container then return end
    
    local Theme = NexusUI.CurrentTheme
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 60)
    Notif.BackgroundColor3 = Theme.Secondary
    Notif.BackgroundTransparency = 1
    Notif.Parent = self.Container
    
    Utility:CreateCorner(Notif, 6)
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title or "Notice"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 1
    Title.Parent = Notif
    
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -20, 0, 25)
    Desc.Position = UDim2.new(0, 10, 0, 28)
    Desc.BackgroundTransparency = 1
    Desc.Text = Config.Description or ""
    Desc.TextColor3 = Theme.SubText
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextWrapped = true
    Desc.TextTransparency = 1
    Desc.Parent = Notif
    
    Utility:Tween(Notif, {BackgroundTransparency = 0}, 0.3)
    Utility:Tween(Title, {TextTransparency = 0}, 0.3)
    Utility:Tween(Desc, {TextTransparency = 0}, 0.3)
    
    task.delay(Config.Duration or 4, function()
        Utility:Tween(Notif, {BackgroundTransparency = 1}, 0.3)
        Utility:Tween(Title, {TextTransparency = 1}, 0.3)
        Utility:Tween(Desc, {TextTransparency = 1}, 0.3)
        task.wait(0.3)
        if Notif and Notif.Parent then
            Notif:Destroy()
        end
    end)
end

function NexusUI:CreateWindow(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Nexus UI"
    Config.Theme = Config.Theme or "Dark"
    Config.ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    
    if NexusUI.Themes[Config.Theme] then
        NexusUI.CurrentTheme = NexusUI.Themes[Config.Theme]
    end
    
    local Theme = NexusUI.CurrentTheme
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    Notifications:Init(ScreenGui)
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Parent = ScreenGui
    
    Utility:CreateCorner(MainFrame, 10)
    Utility:AddStroke(MainFrame, Theme.Border, 1)
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar
    
    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 10)
    TopFix.Position = UDim2.new(0, 0, 1, -10)
    TopFix.BackgroundColor3 = Theme.Secondary
    TopFix.BorderSizePixel = 0
    TopFix.Parent = TopBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -90, 1, 0)
    TitleText.Position = UDim2.new(0, 12, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Config.Name
    TitleText.TextColor3 = Theme.Text
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 15
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TopBar
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Theme.Error
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TopBar
    
    Utility:CreateCorner(CloseBtn, 6)
    
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.BackgroundColor3 = Theme.Tertiary
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.Text
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = TopBar
    
    Utility:CreateCorner(MinBtn, 6)
    
    Utility:MakeDraggable(MainFrame, TopBar)
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(0, 140, 1, -50)
    TabList.Position = UDim2.new(0, 5, 0, 45)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = MainFrame
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabList
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Size = UDim2.new(1, -155, 1, -50)
    ContentArea.Position = UDim2.new(0, 150, 0, 45)
    ContentArea.BackgroundColor3 = Theme.Secondary
    ContentArea.Parent = MainFrame
    
    Utility:CreateCorner(ContentArea, 8)
    
    local Window = {}
    Window.Gui = ScreenGui
    Window.Main = MainFrame
    Window.TabList = TabList
    Window.Content = ContentArea
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    Window.Visible = true
    
    CloseBtn.MouseButton1Click:Connect(function()
        Window.Visible = false
        MainFrame.Visible = false
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.2)
    end)
    
    MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Utility:Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 40)}, 0.3)
            MinBtn.Text = "+"
        else
            Utility:Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.3)
            MinBtn.Text = "-"
        end
    end)
    
    MinBtn.MouseEnter:Connect(function()
        Utility:Tween(MinBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    
    MinBtn.MouseLeave:Connect(function()
        Utility:Tween(MinBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed and Input.KeyCode == Config.ToggleKey then
            Window.Visible = not Window.Visible
            MainFrame.Visible = Window.Visible
        end
    end)
    
    function Window:Notify(Data)
        Notifications:Send(Data)
    end
    
    function Window:CreateTab(TabData)
        TabData = TabData or {}
        TabData.Name = TabData.Name or "Tab"
        
        local Tab = {}
        Tab.Name = TabData.Name
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = TabData.Name
        TabBtn.Size = UDim2.new(1, -6, 0, 32)
        TabBtn.BackgroundColor3 = Theme.Tertiary
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = TabData.Name
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabList
        
        Utility:CreateCorner(TabBtn, 6)
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = TabData.Name
        TabPage.Size = UDim2.new(1, -12, 1, -12)
        TabPage.Position = UDim2.new(0, 6, 0, 6)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = false
        TabPage.Parent = ContentArea
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.Parent = TabPage
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 5)
        end)
        
        Tab.Button = TabBtn
        Tab.Page = TabPage
        
        local function SelectTab()
            for _, T in pairs(Window.Tabs) do
                T.Page.Visible = false
                Utility:Tween(T.Button, {BackgroundTransparency = 1}, 0.2)
                T.Button.TextColor3 = Theme.SubText
            end
            TabPage.Visible = true
            Utility:Tween(TabBtn, {BackgroundTransparency = 0}, 0.2)
            TabBtn.TextColor3 = Theme.Text
            Window.ActiveTab = Tab
        end
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        
        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Utility:Tween(TabBtn, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Utility:Tween(TabBtn, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        function Tab:CreateSection(Name)
            local Sec = Instance.new("Frame")
            Sec.Size = UDim2.new(1, 0, 0, 28)
            Sec.BackgroundTransparency = 1
            Sec.Parent = TabPage
            
            local SecText = Instance.new("TextLabel")
            SecText.Size = UDim2.new(1, 0, 0, 20)
            SecText.Position = UDim2.new(0, 0, 0, 4)
            SecText.BackgroundTransparency = 1
            SecText.Text = Name or "Section"
            SecText.TextColor3 = Theme.Text
            SecText.Font = Enum.Font.GothamBold
            SecText.TextSize = 13
            SecText.TextXAlignment = Enum.TextXAlignment.Left
            SecText.Parent = Sec
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.BackgroundColor3 = Theme.Border
            Line.BorderSizePixel = 0
            Line.Parent = Sec
            
            return Sec
        end
        
        function Tab:CreateButton(Data)
            Data = Data or {}
            Data.Name = Data.Name or "Button"
            Data.Callback = Data.Callback or function() end
            
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 32)
            Btn.BackgroundColor3 = Theme.Tertiary
            Btn.Text = Data.Name
            Btn.TextColor3 = Theme.Text
            Btn.Font = Enum.Font.GothamSemibold
            Btn.TextSize = 13
            Btn.AutoButtonColor = false
            Btn.Parent = TabPage
            
            Utility:CreateCorner(Btn, 6)
            
            Btn.MouseButton1Click:Connect(function()
                pcall(Data.Callback)
            end)
            
            Btn.MouseEnter:Connect(function()
                Utility:Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            Btn.MouseLeave:Connect(function()
                Utility:Tween(Btn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end)
            
            return Btn
        end
        
        function Tab:CreateToggle(Data)
            Data = Data or {}
            Data.Name = Data.Name or "Toggle"
            Data.CurrentValue = Data.CurrentValue or false
            Data.Callback = Data.Callback or function() end
            
            local Toggled = Data.CurrentValue
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 32)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            Utility:CreateCorner(Frame, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleBtn.BackgroundColor3 = Toggled and Theme.Accent or Theme.Border
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.Parent = Frame
            
            Utility:CreateCorner(ToggleBtn, 10)
            
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = ToggleBtn
            
            Utility:CreateCorner(Circle, 8)
            
            local function Update(Value)
                Toggled = Value
                Utility:Tween(ToggleBtn, {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}, 0.2)
                Utility:Tween(Circle, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                pcall(Data.Callback, Toggled)
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Update(not Toggled)
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetValue(V) Update(V) end
            function Obj:GetValue() return Toggled end
            return Obj
        end
        
        function Tab:CreateSlider(Data)
            Data = Data or {}
            Data.Name = Data.Name or "Slider"
            Data.Min = Data.Min or 0
            Data.Max = Data.Max or 100
            Data.Default = Data.Default or 50
            Data.Callback = Data.Callback or function() end
            
            local Value = Data.Default
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 45)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            Utility:CreateCorner(Frame, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 0, 18)
            Label.Position = UDim2.new(0, 10, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 40, 0, 18)
            ValLabel.Position = UDim2.new(1, -45, 0, 4)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(Value)
            ValLabel.TextColor3 = Theme.Accent
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 12
            ValLabel.Parent = Frame
            
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 5)
            Track.Position = UDim2.new(0, 10, 0, 30)
            Track.BackgroundColor3 = Theme.Secondary
            Track.Parent = Frame
            
            Utility:CreateCorner(Track, 2)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Data.Min) / (Data.Max - Data.Min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Parent = Track
            
            Utility:CreateCorner(Fill, 2)
            
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Size = UDim2.new(1, 0, 1, 8)
            SliderBtn.Position = UDim2.new(0, 0, 0, -4)
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Text = ""
            SliderBtn.Parent = Track
            
            local Dragging = false
            
            local function UpdateSlider(X)
                local Percent = math.clamp((X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Value = math.floor(Data.Min + (Data.Max - Data.Min) * Percent)
                ValLabel.Text = tostring(Value)
                Utility:Tween(Fill, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.1)
                pcall(Data.Callback, Value)
            end
            
            SliderBtn.MouseButton1Down:Connect(function()
                Dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(Input.Position.X)
                end
            end)
            
            SliderBtn.MouseButton1Click:Connect(function()
                UpdateSlider(UserInputService:GetMouseLocation().X)
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetValue(V)
                Value = math.clamp(V, Data.Min, Data.Max)
                ValLabel.Text = tostring(Value)
                Fill.Size = UDim2.new((Value - Data.Min) / (Data.Max - Data.Min), 0, 1, 0)
                pcall(Data.Callback, Value)
            end
            function Obj:GetValue() return Value end
            return Obj
        end
        
        function Tab:CreateDropdown(Data)
            Data = Data or {}
            Data.Name = Data.Name or "Dropdown"
            Data.Options = Data.Options or {}
            Data.Default = Data.Default or Data.Options[1] or ""
            Data.Callback = Data.Callback or function() end
            
            local Selected = Data.Default
            local Open = false
            local Buttons = {}
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 32)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.ClipsDescendants = true
            Frame.Parent = TabPage
            
            Utility:CreateCorner(Frame, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -30, 0, 32)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 32)
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "v"
            Arrow.TextColor3 = Theme.SubText
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 12
            Arrow.Parent = Frame
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Size = UDim2.new(1, -10, 0, 0)
            OptionsFrame.Position = UDim2.new(0, 5, 0, 36)
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.Parent = Frame
            
            local OptLayout = Instance.new("UIListLayout")
            OptLayout.Padding = UDim.new(0, 2)
            OptLayout.Parent = OptionsFrame
            
            local MainBtn = Instance.new("TextButton")
            MainBtn.Size = UDim2.new(1, 0, 0, 32)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = ""
            MainBtn.Parent = Frame
            
            local function MakeOption(Opt)
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 26)
                OptBtn.BackgroundColor3 = Opt == Selected and Theme.Accent or Theme.Secondary
                OptBtn.Text = Opt
                OptBtn.TextColor3 = Theme.Text
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.AutoButtonColor = false
                OptBtn.Parent = OptionsFrame
                
                Utility:CreateCorner(OptBtn, 4)
                Buttons[Opt] = OptBtn
                
                OptBtn.MouseButton1Click:Connect(function()
                    Selected = Opt
                    for O, B in pairs(Buttons) do
                        Utility:Tween(B, {BackgroundColor3 = O == Selected and Theme.Accent or Theme.Secondary}, 0.2)
                    end
                    Open = false
                    Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.3)
                    Arrow.Text = "v"
                    pcall(Data.Callback, Selected)
                end)
                
                OptBtn.MouseEnter:Connect(function()
                    if Opt ~= Selected then
                        Utility:Tween(OptBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
                    end
                end)
                
                OptBtn.MouseLeave:Connect(function()
                    if Opt ~= Selected then
                        Utility:Tween(OptBtn, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    end
                end)
            end
            
            for _, Opt in ipairs(Data.Options) do
                MakeOption(Opt)
            end
            
            MainBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local Height = Open and (36 + #Data.Options * 28) or 32
                Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, Height)}, 0.3)
                Arrow.Text = Open and "^" or "v"
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetValue(V)
                Selected = V
                for O, B in pairs(Buttons) do
                    B.BackgroundColor3 = O == Selected and Theme.Accent or Theme.Secondary
                end
                pcall(Data.Callback, Selected)
            end
            function Obj:GetValue() return Selected end
            function Obj:Refresh(NewOpts)
                for _, B in pairs(Buttons) do B:Destroy() end
                Buttons = {}
                Data.Options = NewOpts
                for _, Opt in ipairs(NewOpts) do MakeOption(Opt) end
                if Open then
                    Frame.Size = UDim2.new(1, 0, 0, 36 + #NewOpts * 28)
                end
            end
            return Obj
        end
        
        function Tab:CreateTextbox(Data)
            Data = Data or {}
            Data.Name = Data.Name or "Textbox"
            Data.Placeholder = Data.Placeholder or "Type here..."
            Data.Callback = Data.Callback or function() end
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 58)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            Utility:CreateCorner(Frame, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(1, -20, 0, 26)
            Box.Position = UDim2.new(0, 10, 0, 26)
            Box.BackgroundColor3 = Theme.Secondary
            Box.Text = ""
            Box.PlaceholderText = Data.Placeholder
            Box.TextColor3 = Theme.Text
            Box.PlaceholderColor3 = Theme.SubText
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 12
            Box.ClearTextOnFocus = false
            Box.Parent = Frame
            
            Utility:CreateCorner(Box, 4)
            
            Box.Focused:Connect(function()
                Utility:Tween(Box, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            Box.FocusLost:Connect(function(Enter)
                Utility:Tween(Box, {BackgroundColor3 = Theme.Secondary}, 0.2)
                if Enter then
                    pcall(Data.Callback, Box.Text)
                end
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetValue(V) Box.Text = V end
            function Obj:GetValue() return Box.Text end
            return Obj
        end
        
        function Tab:CreateKeybind(Data)
            Data = Data or {}
            Data.Name = Data.Name or "Keybind"
            Data.Default = Data.Default or "None"
            Data.Callback = Data.Callback or function() end
            
            local Key = Data.Default
            local Listening = false
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 32)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            Utility:CreateCorner(Frame, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -90, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Size = UDim2.new(0, 70, 0, 22)
            KeyBtn.Position = UDim2.new(1, -80, 0.5, -11)
            KeyBtn.BackgroundColor3 = Theme.Secondary
            KeyBtn.Text = Key
            KeyBtn.TextColor3 = Theme.Text
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 11
            KeyBtn.AutoButtonColor = false
            KeyBtn.Parent = Frame
            
            Utility:CreateCorner(KeyBtn, 4)
            
            KeyBtn.MouseButton1Click:Connect(function()
                Listening = true
                KeyBtn.Text = "..."
                Utility:Tween(KeyBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(Input, Processed)
                if Listening then
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = Input.KeyCode.Name
                        KeyBtn.Text = Key
                        Listening = false
                        Utility:Tween(KeyBtn, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    end
                elseif not Processed and Input.KeyCode and Input.KeyCode.Name == Key then
                    pcall(Data.Callback, true)
                end
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetKey(K) Key = K KeyBtn.Text = K end
            function Obj:GetKey() return Key end
            return Obj
        end
        
        function Tab:CreateLabel(Text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 22)
            Label.BackgroundTransparency = 1
            Label.Text = Text or "Label"
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabPage
            
            local Obj = {}
            Obj.Label = Label
            function Obj:SetText(T) Label.Text = T end
            return Obj
        end
        
        function Tab:CreateParagraph(Title, Content)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 60)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            Utility:CreateCorner(Frame, 6)
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -20, 0, 20)
            TitleLabel.Position = UDim2.new(0, 10, 0, 4)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text = Title or "Title"
            TitleLabel.TextColor3 = Theme.Text
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = Frame
            
            local ContentLabel = Instance.new("TextLabel")
            ContentLabel.Size = UDim2.new(1, -20, 0, 32)
            ContentLabel.Position = UDim2.new(0, 10, 0, 24)
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.Text = Content or "Content"
            ContentLabel.TextColor3 = Theme.SubText
            ContentLabel.Font = Enum.Font.Gotham
            ContentLabel.TextSize = 12
            ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            ContentLabel.TextWrapped = true
            ContentLabel.Parent = Frame
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetTitle(T) TitleLabel.Text = T end
            function Obj:SetContent(C) ContentLabel.Text = C end
            return Obj
        end
        
        return Tab
    end
    
    table.insert(NexusUI.Windows, Window)
    return Window
end

return NexusUI
