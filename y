-- Winhvh Custom UI Library v2
-- Complete rewrite with proper structure

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

-- Colors
local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 35),
    Tertiary = Color3.fromRGB(40, 40, 45),
    Accent = Color3.fromRGB(255, 75, 90),
    AccentHover = Color3.fromRGB(255, 95, 110),
    AccentDark = Color3.fromRGB(200, 60, 75),
    Text = Color3.fromRGB(240, 240, 245),
    TextGray = Color3.fromRGB(160, 160, 170),
    TextDark = Color3.fromRGB(100, 100, 110),
    Border = Color3.fromRGB(50, 50, 60),
    Toggle = Color3.fromRGB(255, 75, 90),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    Slider = Color3.fromRGB(255, 75, 90),
    IconSidebar = Color3.fromRGB(25, 25, 30),
}

-- Utility Functions
local function CreateRound(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Main CreateWindow Function
function Library:CreateWindow(config)
    config = config or {}
    
    local Window = {}
    Window.Tabs = {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WinhvhUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Size = UDim2.new(0, 900, 0, 600)
    MainContainer.Position = UDim2.new(0.5, -450, 0.5, -300)
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui
    CreateRound(MainContainer, 12)
    
    Window.MainContainer = MainContainer
    
    -- Draggable
    local dragging, dragStart, startPos
    MainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainContainer.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Top Header
    local TopHeader = Instance.new("Frame")
    TopHeader.Size = UDim2.new(1, 0, 0, 50)
    TopHeader.BackgroundColor3 = Colors.Secondary
    TopHeader.BorderSizePixel = 0
    TopHeader.Parent = MainContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "Winhvh"
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopHeader
    
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Position = UDim2.new(0, 180, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = config.Version or "v1.0"
    VersionLabel.TextColor3 = Colors.TextDark
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextSize = 14
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TopHeader
    
    -- Stats Bar
    local StatsBar = Instance.new("Frame")
    StatsBar.Size = UDim2.new(0, 500, 0, 30)
    StatsBar.Position = UDim2.new(1, -520, 0, 10)
    StatsBar.BackgroundTransparency = 1
    StatsBar.Parent = TopHeader
    
    local StatsLayout = Instance.new("UIListLayout")
    StatsLayout.FillDirection = Enum.FillDirection.Horizontal
    StatsLayout.Padding = UDim.new(0, 15)
    StatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    StatsLayout.Parent = StatsBar
    
    -- Icon Sidebar
    local IconSidebar = Instance.new("Frame")
    IconSidebar.Size = UDim2.new(0, 60, 1, -50)
    IconSidebar.Position = UDim2.new(0, 0, 0, 50)
    IconSidebar.BackgroundColor3 = Colors.IconSidebar
    IconSidebar.BorderSizePixel = 0
    IconSidebar.Parent = MainContainer
    
    local IconLayout = Instance.new("UIListLayout")
    IconLayout.Padding = UDim.new(0, 8)
    IconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    IconLayout.Parent = IconSidebar
    
    local IconPadding = Instance.new("UIPadding")
    IconPadding.PaddingTop = UDim.new(0, 15)
    IconPadding.Parent = IconSidebar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -60, 1, -50)
    ContentContainer.Position = UDim2.new(0, 60, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainContainer
    
    -- AddStat Function
    function Window:AddStat(text)
        local StatLabel = Instance.new("TextLabel")
        StatLabel.Size = UDim2.new(0, 0, 1, 0)
        StatLabel.AutomaticSize = Enum.AutomaticSize.X
        StatLabel.BackgroundTransparency = 1
        StatLabel.Text = text
        StatLabel.TextColor3 = Colors.Text
        StatLabel.Font = Enum.Font.GothamMedium
        StatLabel.TextSize = 13
        StatLabel.Parent = StatsBar
        
        return {
            Set = function(newText)
                StatLabel.Text = newText
            end
        }
    end
    
    -- CreateTab Function
    function Window:CreateTab(config)
        config = config or {}
        local Tab = {}
        Tab.Sections = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 50, 0, 50)
        TabButton.BackgroundColor3 = Colors.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Text = config.Icon or "🏠"
        TabButton.TextColor3 = Colors.TextGray
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 20
        TabButton.AutoButtonColor = false
        TabButton.Parent = IconSidebar
        CreateRound(TabButton, 10)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Colors.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 15)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContent
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Switching
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Colors.Tertiary, TextColor3 = Colors.TextGray})
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text})
        end)
        
        -- First tab active
        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Colors.Accent
            TabButton.TextColor3 = Colors.Text
            TabContent.Visible = true
        end
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        -- CreateSection Function
        function Tab:CreateSection(config)
            config = config or {}
            local Section = {}
            
            -- Section Container
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
            SectionContainer.BackgroundColor3 = Colors.Secondary
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Parent = TabContent
            CreateRound(SectionContainer, 10)
            
            -- Header
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 50)
            Header.BackgroundTransparency = 1
            Header.Parent = SectionContainer
            
            local HeaderIcon = Instance.new("TextLabel")
            HeaderIcon.Size = UDim2.new(0, 40, 0, 40)
            HeaderIcon.Position = UDim2.new(0, 15, 0, 5)
            HeaderIcon.BackgroundColor3 = Colors.Tertiary
            HeaderIcon.Text = config.Icon or "⚙️"
            HeaderIcon.TextColor3 = Colors.Text
            HeaderIcon.Font = Enum.Font.GothamBold
            HeaderIcon.TextSize = 18
            HeaderIcon.Parent = Header
            CreateRound(HeaderIcon, 8)
            
            local HeaderTitle = Instance.new("TextLabel")
            HeaderTitle.Size = UDim2.new(1, -70, 0, 25)
            HeaderTitle.Position = UDim2.new(0, 65, 0, 5)
            HeaderTitle.BackgroundTransparency = 1
            HeaderTitle.Text = config.Name or "Section"
            HeaderTitle.TextColor3 = Colors.Text
            HeaderTitle.Font = Enum.Font.GothamBold
            HeaderTitle.TextSize = 16
            HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderTitle.Parent = Header
            
            local HeaderSubtitle = Instance.new("TextLabel")
            HeaderSubtitle.Size = UDim2.new(1, -70, 0, 15)
            HeaderSubtitle.Position = UDim2.new(0, 65, 0, 28)
            HeaderSubtitle.BackgroundTransparency = 1
            HeaderSubtitle.Text = config.Subtitle or "Customize the product as you wish"
            HeaderSubtitle.TextColor3 = Colors.TextDark
            HeaderSubtitle.Font = Enum.Font.Gotham
            HeaderSubtitle.TextSize = 12
            HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderSubtitle.Parent = Header
            
            -- Content (two columns)
            local Content = Instance.new("Frame")
            Content.Size = UDim2.new(1, 0, 0, 0)
            Content.Position = UDim2.new(0, 0, 0, 50)
            Content.AutomaticSize = Enum.AutomaticSize.Y
            Content.BackgroundTransparency = 1
            Content.Parent = SectionContainer
            
            -- Left Column
            local LeftColumn = Instance.new("Frame")
            LeftColumn.Size = UDim2.new(0.5, -10, 0, 0)
            LeftColumn.Position = UDim2.new(0, 15, 0, 0)
            LeftColumn.AutomaticSize = Enum.AutomaticSize.Y
            LeftColumn.BackgroundTransparency = 1
            LeftColumn.Parent = Content
            
            local LeftLayout = Instance.new("UIListLayout")
            LeftLayout.Padding = UDim.new(0, 8)
            LeftLayout.Parent = LeftColumn
            
            -- Right Column
            local RightColumn = Instance.new("Frame")
            RightColumn.Size = UDim2.new(0.5, -10, 0, 0)
            RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
            RightColumn.AutomaticSize = Enum.AutomaticSize.Y
            RightColumn.BackgroundTransparency = 1
            RightColumn.Parent = Content
            
            local RightLayout = Instance.new("UIListLayout")
            RightLayout.Padding = UDim.new(0, 8)
            RightLayout.Parent = RightColumn
            
            local Padding = Instance.new("UIPadding")
            Padding.PaddingBottom = UDim.new(0, 15)
            Padding.Parent = Content
            
            Section.LeftColumn = LeftColumn
            Section.RightColumn = RightColumn
            
            -- ADD ELEMENTS TO SECTION
            function Section:AddToggle(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 35)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Toggle"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 40, 0, 20)
                Button.Position = UDim2.new(1, -40, 0.5, -10)
                Button.BackgroundColor3 = (cfg.Default and Colors.Toggle) or Colors.ToggleOff
                Button.BorderSizePixel = 0
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.Parent = Frame
                CreateRound(Button, 10)
                
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Position = (cfg.Default and UDim2.new(1, -18, 0.5, -8)) or UDim2.new(0, 2, 0.5, -8)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BorderSizePixel = 0
                Circle.Parent = Button
                CreateRound(Circle, 8)
                
                local toggled = cfg.Default or false
                
                Button.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Tween(Button, {BackgroundColor3 = toggled and Colors.Toggle or Colors.ToggleOff})
                    Tween(Circle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                    if cfg.Callback then cfg.Callback(toggled) end
                end)
                
                return {Set = function(v) toggled = v end}
            end
            
            function Section:AddSlider(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                local min, max, def = cfg.Min or 0, cfg.Max or 100, cfg.Default or 50
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 50)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Slider"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 50, 0, 20)
                Value.Position = UDim2.new(1, -50, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = tostring(def)
                Value.TextColor3 = Colors.Accent
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 14
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.Parent = Frame
                
                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(1, 0, 0, 4)
                Bar.Position = UDim2.new(0, 0, 1, -15)
                Bar.BackgroundColor3 = Colors.ToggleOff
                Bar.BorderSizePixel = 0
                Bar.Parent = Frame
                CreateRound(Bar, 2)
                
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Colors.Slider
                Fill.BorderSizePixel = 0
                Fill.Parent = Bar
                CreateRound(Fill, 2)
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 1, 10)
                Button.Position = UDim2.new(0, 0, 0, -5)
                Button.BackgroundTransparency = 1
                Button.Text = ""
                Button.Parent = Bar
                
                local dragging = false
                Button.MouseButton1Down:Connect(function() dragging = true end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                
                Button.MouseMoved:Connect(function(x)
                    if dragging then
                        local pct = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + (max - min) * pct)
                        Value.Text = tostring(val)
                        Tween(Fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                        if cfg.Callback then cfg.Callback(val) end
                    end
                end)
                
                return {Set = function(v) Value.Text = tostring(v) end}
            end
            
            function Section:AddDropdown(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                local opts = cfg.Options or {"Option 1"}
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 35)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Dropdown"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.55, 0, 0, 28)
                Button.Position = UDim2.new(0.45, 0, 0.5, -14)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.BorderSizePixel = 0
                Button.Text = "  " .. (cfg.Default or opts[1])
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 13
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.AutoButtonColor = false
                Button.Parent = Frame
                CreateRound(Button, 6)
                
                local Icon = Instance.new("TextLabel")
                Icon.Size = UDim2.new(0, 20, 1, 0)
                Icon.Position = UDim2.new(1, -20, 0, 0)
                Icon.BackgroundTransparency = 1
                Icon.Text = "▼"
                Icon.TextColor3 = Colors.TextDark
                Icon.Font = Enum.Font.GothamBold
                Icon.TextSize = 10
                Icon.Parent = Button
                
                local List = Instance.new("Frame")
                List.Size = UDim2.new(0.55, 0, 0, 0)
                List.Position = UDim2.new(0.45, 0, 1, 5)
                List.BackgroundColor3 = Colors.Tertiary
                List.BorderSizePixel = 0
                List.Visible = false
                List.ZIndex = 10
                List.Parent = Frame
                CreateRound(List, 6)
                
                local Layout = Instance.new("UIListLayout")
                Layout.Padding = UDim.new(0, 2)
                Layout.Parent = List
                
                local Pad = Instance.new("UIPadding")
                Pad.PaddingTop = UDim.new(0, 5)
                Pad.PaddingBottom = UDim.new(0, 5)
                Pad.Parent = List
                
                for _, opt in ipairs(opts) do
                    local Opt = Instance.new("TextButton")
                    Opt.Size = UDim2.new(1, 0, 0, 28)
                    Opt.BackgroundColor3 = Colors.Tertiary
                    Opt.BorderSizePixel = 0
                    Opt.Text = "  " .. opt
                    Opt.TextColor3 = Colors.Text
                    Opt.Font = Enum.Font.Gotham
                    Opt.TextSize = 13
                    Opt.TextXAlignment = Enum.TextXAlignment.Left
                    Opt.AutoButtonColor = false
                    Opt.ZIndex = 11
                    Opt.Parent = List
                    
                    Opt.MouseEnter:Connect(function() Tween(Opt, {BackgroundColor3 = Colors.Secondary}) end)
                    Opt.MouseLeave:Connect(function() Tween(Opt, {BackgroundColor3 = Colors.Tertiary}) end)
                    Opt.MouseButton1Click:Connect(function()
                        Button.Text = "  " .. opt
                        List.Visible = false
                        Tween(Icon, {Rotation = 0}, 0.2)
                        if cfg.Callback then cfg.Callback(opt) end
                    end)
                end
                
                List.Size = UDim2.new(0.55, 0, 0, Layout.AbsoluteContentSize.Y + 10)
                
                Button.MouseButton1Click:Connect(function()
                    List.Visible = not List.Visible
                    Tween(Icon, {Rotation = List.Visible and 180 or 0}, 0.2)
                end)
                
                return {Set = function(v) Button.Text = "  " .. v end}
            end
            
            function Section:AddColorpicker(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 35)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -45, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Color"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Display = Instance.new("TextButton")
                Display.Size = UDim2.new(0, 35, 0, 20)
                Display.Position = UDim2.new(1, -35, 0.5, -10)
                Display.BackgroundColor3 = cfg.Default or Color3.fromRGB(255, 0, 0)
                Display.BorderSizePixel = 0
                Display.Text = ""
                Display.AutoButtonColor = false
                Display.Parent = Frame
                CreateRound(Display, 6)
                
                -- Simple color picker - just click to cycle colors for now
                local colors = {
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(255, 0, 255),
                    Color3.fromRGB(0, 255, 255),
                }
                local idx = 1
                
                Display.MouseButton1Click:Connect(function()
                    idx = (idx % #colors) + 1
                    Display.BackgroundColor3 = colors[idx]
                    if cfg.Callback then cfg.Callback(colors[idx]) end
                end)
                
                return {Set = function(c) Display.BackgroundColor3 = c end}
            end
            
            function Section:AddKeybind(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 35)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -45, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Keybind"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 35, 0, 25)
                Button.Position = UDim2.new(1, -35, 0.5, -12.5)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.BorderSizePixel = 0
                Button.Text = (cfg.Default and cfg.Default.Name) or "E"
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamBold
                Button.TextSize = 12
                Button.AutoButtonColor = false
                Button.Parent = Frame
                CreateRound(Button, 6)
                
                local key = cfg.Default or Enum.KeyCode.E
                local binding = false
                
                Button.MouseButton1Click:Connect(function()
                    if not binding then
                        binding = true
                        Button.Text = "..."
                        local con
                        con = UserInputService.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.Keyboard then
                                key = i.KeyCode
                                Button.Text = key.Name
                                binding = false
                                con:Disconnect()
                            end
                        end)
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(i)
                    if i.KeyCode == key and not binding then
                        if cfg.Callback then cfg.Callback() end
                    end
                end)
                
                return {Set = function(k) key = k Button.Text = k.Name end}
            end
            
            function Section:AddButton(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.BackgroundColor3 = Colors.Accent
                Button.BorderSizePixel = 0
                Button.Text = cfg.Name or "Button"
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamBold
                Button.TextSize = 14
                Button.AutoButtonColor = false
                Button.Parent = col
                CreateRound(Button, 8)
                
                Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = Colors.AccentHover}) end)
                Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = Colors.Accent}) end)
                Button.MouseButton1Click:Connect(function()
                    Tween(Button, {BackgroundColor3 = Colors.AccentDark}, 0.1).Completed:Connect(function()
                        Tween(Button, {BackgroundColor3 = Colors.Accent}, 0.1)
                    end)
                    if cfg.Callback then cfg.Callback() end
                end)
            end
            
            function Section:AddTextbox(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 35)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Textbox"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.55, 0, 0, 28)
                Box.Position = UDim2.new(0.45, 0, 0.5, -14)
                Box.BackgroundColor3 = Colors.Tertiary
                Box.BorderSizePixel = 0
                Box.Text = ""
                Box.PlaceholderText = cfg.Placeholder or "Enter text..."
                Box.TextColor3 = Colors.Text
                Box.PlaceholderColor3 = Colors.TextDark
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 13
                Box.ClearTextOnFocus = false
                Box.Parent = Frame
                CreateRound(Box, 6)
                
                local Pad = Instance.new("UIPadding")
                Pad.PaddingLeft = UDim.new(0, 8)
                Pad.PaddingRight = UDim.new(0, 8)
                Pad.Parent = Box
                
                Box.FocusLost:Connect(function(enter)
                    if enter and cfg.Callback then cfg.Callback(Box.Text) end
                end)
                
                return {Set = function(t) Box.Text = t end}
            end
            
            function Section:AddLabel(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 30)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Text or "Label"
                Label.TextColor3 = Colors.TextDark
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = Frame
                
                return {Set = function(t) Label.Text = t end}
            end
            
            function Section:AddRangeSlider(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                local def = cfg.Default or {20, 80}
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 50)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -80, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Range"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 70, 0, 20)
                Value.Position = UDim2.new(1, -70, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = def[1] .. " - " .. def[2]
                Value.TextColor3 = Colors.Text
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 13
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.Parent = Frame
                
                return {Set = function(min, max) Value.Text = min .. " - " .. max end}
            end
            
            function Section:AddPercentage(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                local def = cfg.Default or {60, 95}
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 35)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -80, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Percentage"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 70, 1, 0)
                Value.Position = UDim2.new(1, -70, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = def[1] .. "% - " .. def[2] .. "%"
                Value.TextColor3 = Colors.Text
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 13
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.Parent = Frame
                
                return {Set = function(min, max) Value.Text = min .. "% - " .. max .. "%" end}
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Library
