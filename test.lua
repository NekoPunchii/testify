local NexusUI = {}
NexusUI.Windows = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local function Tween(Object, Properties, Duration)
    if not Object or not Object.Parent then return end
    local Info = TweenInfo.new(Duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local T = TweenService:Create(Object, Info, Properties)
    T:Play()
    return T
end

local function MakeDraggable(Frame, Handle)
    Handle = Handle or Frame
    local Dragging = false
    local StartPos = nil
    local StartMouse = nil
    
    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            StartPos = Frame.Position
            StartMouse = Input.Position
        end
    end)
    
    Handle.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - StartMouse
            Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end

local function CreateCorner(Parent, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius or 8)
    C.Parent = Parent
    return C
end

local function CreateStroke(Parent, Color, Size)
    local S = Instance.new("UIStroke")
    S.Color = Color or Color3.fromRGB(60, 60, 60)
    S.Thickness = Size or 1
    S.Parent = Parent
    return S
end

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 35),
    Tertiary = Color3.fromRGB(45, 45, 50),
    Accent = Color3.fromRGB(255, 120, 180),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(55, 55, 60),
    Success = Color3.fromRGB(67, 181, 129),
    Error = Color3.fromRGB(240, 71, 71)
}

function NexusUI:CreateWindow(Config)
    Config = Config or {}
    Config.Name = Config.Name or "Nexus UI"
    Config.ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    
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
    
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifications"
    NotifHolder.Size = UDim2.new(0, 280, 1, 0)
    NotifHolder.Position = UDim2.new(1, -290, 0, 0)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui
    
    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 8)
    NotifLayout.Parent = NotifHolder
    
    local NotifPad = Instance.new("UIPadding")
    NotifPad.PaddingBottom = UDim.new(0, 15)
    NotifPad.Parent = NotifHolder
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 520, 0, 380)
    Main.Position = UDim2.new(0.5, -260, 0.5, -190)
    Main.BackgroundColor3 = Theme.Background
    Main.Parent = ScreenGui
    
    CreateCorner(Main, 10)
    CreateStroke(Main, Theme.Border)
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.Parent = Main
    
    CreateCorner(TopBar, 10)
    
    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 12)
    TopFix.Position = UDim2.new(0, 0, 1, -12)
    TopFix.BackgroundColor3 = Theme.Secondary
    TopFix.BorderSizePixel = 0
    TopFix.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -85, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -33, 0, 5)
    CloseBtn.BackgroundColor3 = Theme.Error
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TopBar
    
    CreateCorner(CloseBtn, 6)
    
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Position = UDim2.new(1, -65, 0, 5)
    MinBtn.BackgroundColor3 = Theme.Tertiary
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.Text
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = TopBar
    
    CreateCorner(MinBtn, 6)
    
    MakeDraggable(Main, TopBar)
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(0, 130, 1, -48)
    TabList.Position = UDim2.new(0, 5, 0, 43)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = Main
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabList
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)
    
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -145, 1, -48)
    Content.Position = UDim2.new(0, 140, 0, 43)
    Content.BackgroundColor3 = Theme.Secondary
    Content.Parent = Main
    
    CreateCorner(Content, 8)
    
    local Window = {}
    Window.Gui = ScreenGui
    Window.Main = Main
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    Window.IsVisible = true
    
    CloseBtn.MouseButton1Click:Connect(function()
        Window.IsVisible = false
        Main.Visible = false
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}, 0.15)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.15)
    end)
    
    MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(Main, {Size = UDim2.new(0, 520, 0, 38)}, 0.25)
            MinBtn.Text = "+"
        else
            Tween(Main, {Size = UDim2.new(0, 520, 0, 380)}, 0.25)
            MinBtn.Text = "-"
        end
    end)
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
    end)
    
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
    end)
    
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.KeyCode == Config.ToggleKey then
            Window.IsVisible = not Window.IsVisible
            Main.Visible = Window.IsVisible
        end
    end)
    
    function Window:Notify(Data)
        Data = Data or {}
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(1, 0, 0, 55)
        Notif.BackgroundColor3 = Theme.Secondary
        Notif.BackgroundTransparency = 1
        Notif.Parent = NotifHolder
        
        CreateCorner(Notif, 6)
        
        local NTitle = Instance.new("TextLabel")
        NTitle.Size = UDim2.new(1, -15, 0, 18)
        NTitle.Position = UDim2.new(0, 8, 0, 6)
        NTitle.BackgroundTransparency = 1
        NTitle.Text = Data.Title or "Notice"
        NTitle.TextColor3 = Theme.Text
        NTitle.Font = Enum.Font.GothamBold
        NTitle.TextSize = 13
        NTitle.TextXAlignment = Enum.TextXAlignment.Left
        NTitle.TextTransparency = 1
        NTitle.Parent = Notif
        
        local NDesc = Instance.new("TextLabel")
        NDesc.Size = UDim2.new(1, -15, 0, 22)
        NDesc.Position = UDim2.new(0, 8, 0, 26)
        NDesc.BackgroundTransparency = 1
        NDesc.Text = Data.Description or ""
        NDesc.TextColor3 = Theme.SubText
        NDesc.Font = Enum.Font.Gotham
        NDesc.TextSize = 11
        NDesc.TextXAlignment = Enum.TextXAlignment.Left
        NDesc.TextWrapped = true
        NDesc.TextTransparency = 1
        NDesc.Parent = Notif
        
        Tween(Notif, {BackgroundTransparency = 0}, 0.25)
        Tween(NTitle, {TextTransparency = 0}, 0.25)
        Tween(NDesc, {TextTransparency = 0}, 0.25)
        
        task.delay(Data.Duration or 3, function()
            Tween(Notif, {BackgroundTransparency = 1}, 0.25)
            Tween(NTitle, {TextTransparency = 1}, 0.25)
            Tween(NDesc, {TextTransparency = 1}, 0.25)
            task.wait(0.3)
            if Notif.Parent then
                Notif:Destroy()
            end
        end)
    end
    
    function Window:CreateTab(Data)
        Data = Data or {}
        Data.Name = Data.Name or "Tab"
        
        local Tab = {}
        Tab.Name = Data.Name
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -4, 0, 30)
        TabBtn.BackgroundColor3 = Theme.Tertiary
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = Data.Name
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabList
        
        CreateCorner(TabBtn, 5)
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, -10, 1, -10)
        TabPage.Position = UDim2.new(0, 5, 0, 5)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = false
        TabPage.Parent = Content
        
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
                Tween(T.Button, {BackgroundTransparency = 1}, 0.15)
                T.Button.TextColor3 = Theme.SubText
            end
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0}, 0.15)
            TabBtn.TextColor3 = Theme.Text
            Window.ActiveTab = Tab
        end
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        
        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabBtn, {BackgroundTransparency = 0.6}, 0.15)
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        function Tab:CreateSection(Name)
            local Sec = Instance.new("Frame")
            Sec.Size = UDim2.new(1, 0, 0, 25)
            Sec.BackgroundTransparency = 1
            Sec.Parent = TabPage
            
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 18)
            SecLabel.Position = UDim2.new(0, 0, 0, 3)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = Name or "Section"
            SecLabel.TextColor3 = Theme.Text
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 12
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = Sec
            
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
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Theme.Tertiary
            Btn.Text = Data.Name or "Button"
            Btn.TextColor3 = Theme.Text
            Btn.Font = Enum.Font.GothamSemibold
            Btn.TextSize = 12
            Btn.AutoButtonColor = false
            Btn.Parent = TabPage
            
            CreateCorner(Btn, 5)
            
            Btn.MouseButton1Click:Connect(function()
                if Data.Callback then
                    pcall(Data.Callback)
                end
            end)
            
            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.15)
            end)
            
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
            end)
            
            return Btn
        end
        
        function Tab:CreateToggle(Data)
            Data = Data or {}
            local Enabled = Data.CurrentValue or false
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 30)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            CreateCorner(Frame, 5)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name or "Toggle"
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 38, 0, 18)
            ToggleBtn.Position = UDim2.new(1, -45, 0.5, -9)
            ToggleBtn.BackgroundColor3 = Enabled and Theme.Accent or Theme.Border
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.Parent = Frame
            
            CreateCorner(ToggleBtn, 9)
            
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = ToggleBtn
            
            CreateCorner(Circle, 7)
            
            local function Update(Val)
                Enabled = Val
                Tween(ToggleBtn, {BackgroundColor3 = Enabled and Theme.Accent or Theme.Border}, 0.15)
                Tween(Circle, {Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.15)
                if Data.Callback then
                    pcall(Data.Callback, Enabled)
                end
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Update(not Enabled)
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetValue(V)
                Update(V)
            end
            function Obj:GetValue()
                return Enabled
            end
            return Obj
        end
        
        function Tab:CreateSlider(Data)
            Data = Data or {}
            local Min = Data.Min or 0
            local Max = Data.Max or 100
            local Val = Data.Default or Min
            
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 42)
            Frame.BackgroundColor3 = Theme.Tertiary
            Frame.Parent = TabPage
            
            CreateCorner(Frame, 5)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -45, 0, 16)
            Label.Position = UDim2.new(0, 10, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = Data.Name or "Slider"
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 35, 0, 16)
            ValLabel.Position = UDim2.new(1, -40, 0, 4)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(Val)
            ValLabel.TextColor3 = Theme.Accent
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 11
            ValLabel.Parent = Frame
            
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 5)
            Track.Position = UDim2.new(0, 10, 0, 28)
            Track.BackgroundColor3 = Theme.Secondary
            Track.Parent = Frame
            
            CreateCorner(Track, 2)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Val - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Parent = Track
            
            CreateCorner(Fill, 2)
            
            local SliderArea = Instance.new("TextButton")
            SliderArea.Size = UDim2.new(1, 0, 1, 10)
            SliderArea.Position = UDim2.new(0, 0, 0, -5)
            SliderArea.BackgroundTransparency = 1
            SliderArea.Text = ""
            SliderArea.Parent = Track
            
            local Dragging = false
            
            local function SetValue(X)
                local Pct = math.clamp((X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Val = math.floor(Min + (Max - Min) * Pct)
                ValLabel.Text = tostring(Val)
                Tween(Fill, {Size = UDim2.new(Pct, 0, 1, 0)}, 0.08)
                if Data.Callback then
                    pcall(Data.Callback, Val)
                end
            end
            
            SliderArea.MouseButton1Down:Connect(function()
                Dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    SetValue(Input.Position.X)
                end
            end)
            
            SliderArea.MouseButton1Click:Connect(function()
                SetValue(UserInputService:GetMouseLocation().X)
            end)
            
            local Obj = {}
            Obj.Frame = Frame
            function Obj:SetValue(V)
                Val = math.clamp(V, Min, Max)
                ValLabel.Text = tostring(Val)
                Fill.Size = UDim2.new((Val - Min) / (Max - Min), 0, 1, 0)
                if Data.Callback then
                    pcall(Data.Callback, Val)
                end
            end
            function Obj:GetValue()
                return Val
            end
            return Obj
        end
        
        function Tab:CreateLabel(Text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 20)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Text or "Label"
            Lbl.TextColor3 = Theme.Text
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = TabPage
            
            local Obj = {}
            Obj.Label = Lbl
            function Obj:SetText(T)
                Lbl.Text = T
            end
            return Obj
        end
        
        return Tab
    end
    
    table.insert(NexusUI.Windows, Window)
    return Window
end

return NexusUI
