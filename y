-- Modern Gaming UI Library
-- Based on professional cheat UI design

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

-- Professional Color Scheme
local Colors = {
    Background = Color3.fromRGB(18, 18, 22),
    Secondary = Color3.fromRGB(28, 28, 32),
    Tertiary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(255, 65, 85),
    AccentHover = Color3.fromRGB(255, 85, 105),
    Text = Color3.fromRGB(240, 240, 245),
    TextDark = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(45, 45, 50),
    ToggleOn = Color3.fromRGB(255, 65, 85),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    Sidebar = Color3.fromRGB(22, 22, 26),
    StatsBar = Color3.fromRGB(22, 22, 26),
}

-- Utility Functions
local function CreateRound(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
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

-- Main Window Creation
function Library:CreateWindow(config)
    config = config or {}
    
    local Window = {}
    Window.Tabs = {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Size = UDim2.new(0, 850, 0, 550)
    MainContainer.Position = UDim2.new(0.5, -425, 0.5, -275)
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui
    CreateRound(MainContainer, 8)
    
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
    
    -- Top Stats Bar
    local StatsBar = Instance.new("Frame")
    StatsBar.Size = UDim2.new(1, 0, 0, 40)
    StatsBar.BackgroundColor3 = Colors.StatsBar
    StatsBar.BorderSizePixel = 0
    StatsBar.Parent = MainContainer
    
    local StatsLayout = Instance.new("UIListLayout")
    StatsLayout.FillDirection = Enum.FillDirection.Horizontal
    StatsLayout.Padding = UDim.new(0, 25)
    StatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    StatsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StatsLayout.Parent = StatsBar
    
    local StatsPadding = Instance.new("UIPadding")
    StatsPadding.PaddingRight = UDim.new(0, 20)
    StatsPadding.Parent = StatsBar
    
    -- Icon Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 60, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainContainer
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 8)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.Parent = Sidebar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -60, 1, -40)
    ContentContainer.Position = UDim2.new(0, 60, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainContainer
    
    -- AddStat Function
    function Window:AddStat(text)
        local StatLabel = Instance.new("TextLabel")
        StatLabel.Size = UDim2.new(0, 0, 0, 20)
        StatLabel.AutomaticSize = Enum.AutomaticSize.X
        StatLabel.BackgroundTransparency = 1
        StatLabel.Text = text
        StatLabel.TextColor3 = Colors.TextDark
        StatLabel.Font = Enum.Font.GothamMedium
        StatLabel.TextSize = 11
        StatLabel.Parent = StatsBar
        
        return {
            Set = function(self, newText)
                StatLabel.Text = newText
            end
        }
    end
    
    -- CreateTab Function
    function Window:CreateTab(config)
        config = config or {}
        local Tab = {}
        Tab.Sections = {}
        
        -- Tab Button (Icon Button)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 50, 0, 50)
        TabButton.BackgroundColor3 = Colors.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Text = config.Icon or "🎯"
        TabButton.TextColor3 = Colors.TextDark
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 20
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar
        CreateRound(TabButton, 8)
        
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
                Tween(tab.Button, {BackgroundColor3 = Colors.Tertiary, TextColor3 = Colors.TextDark}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text}, 0.2)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if not TabContent.Visible then
                Tween(TabButton, {BackgroundColor3 = Colors.Secondary}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabContent.Visible then
                Tween(TabButton, {BackgroundColor3 = Colors.Tertiary}, 0.15)
            end
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
            CreateRound(SectionContainer, 8)
            
            -- Header
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 50)
            Header.BackgroundTransparency = 1
            Header.Parent = SectionContainer
            
            -- Header Icon
            local HeaderIcon = Instance.new("TextLabel")
            HeaderIcon.Size = UDim2.new(0, 35, 0, 35)
            HeaderIcon.Position = UDim2.new(0, 12, 0, 8)
            HeaderIcon.BackgroundColor3 = Colors.Tertiary
            HeaderIcon.Text = config.Icon or "⚙"
            HeaderIcon.TextColor3 = Colors.Text
            HeaderIcon.Font = Enum.Font.GothamBold
            HeaderIcon.TextSize = 16
            HeaderIcon.Parent = Header
            CreateRound(HeaderIcon, 6)
            
            -- Header Title
            local HeaderTitle = Instance.new("TextLabel")
            HeaderTitle.Size = UDim2.new(1, -60, 0, 20)
            HeaderTitle.Position = UDim2.new(0, 55, 0, 8)
            HeaderTitle.BackgroundTransparency = 1
            HeaderTitle.Text = config.Name or "Section"
            HeaderTitle.TextColor3 = Colors.Text
            HeaderTitle.Font = Enum.Font.GothamBold
            HeaderTitle.TextSize = 14
            HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderTitle.Parent = Header
            
            -- Header Subtitle
            local HeaderSubtitle = Instance.new("TextLabel")
            HeaderSubtitle.Size = UDim2.new(1, -60, 0, 14)
            HeaderSubtitle.Position = UDim2.new(0, 55, 0, 28)
            HeaderSubtitle.BackgroundTransparency = 1
            HeaderSubtitle.Text = config.Subtitle or "Customize the product as you wish"
            HeaderSubtitle.TextColor3 = Colors.TextDark
            HeaderSubtitle.Font = Enum.Font.Gotham
            HeaderSubtitle.TextSize = 10
            HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderSubtitle.Parent = Header
            
            -- Tab Selector (if provided)
            local TabSelector
            if config.Tabs then
                TabSelector = Instance.new("Frame")
                TabSelector.Size = UDim2.new(1, -20, 0, 30)
                TabSelector.Position = UDim2.new(0, 10, 0, 50)
                TabSelector.BackgroundTransparency = 1
                TabSelector.Parent = SectionContainer
                
                local TabLayout = Instance.new("UIListLayout")
                TabLayout.FillDirection = Enum.FillDirection.Horizontal
                TabLayout.Padding = UDim.new(0, 8)
                TabLayout.Parent = TabSelector
                
                Section.ActiveTab = config.Tabs[1] or "Main"
                
                for _, tabName in ipairs(config.Tabs) do
                    local TabBtn = Instance.new("TextButton")
                    TabBtn.Size = UDim2.new(0, 80, 0, 28)
                    TabBtn.BackgroundColor3 = (tabName == Section.ActiveTab) and Colors.Tertiary or Colors.Background
                    TabBtn.Text = tabName
                    TabBtn.TextColor3 = Colors.Text
                    TabBtn.Font = Enum.Font.GothamMedium
                    TabBtn.TextSize = 12
                    TabBtn.AutoButtonColor = false
                    TabBtn.Parent = TabSelector
                    CreateRound(TabBtn, 6)
                    
                    TabBtn.MouseButton1Click:Connect(function()
                        Section.ActiveTab = tabName
                        for _, btn in ipairs(TabSelector:GetChildren()) do
                            if btn:IsA("TextButton") then
                                Tween(btn, {BackgroundColor3 = Colors.Background}, 0.2)
                            end
                        end
                        Tween(TabBtn, {BackgroundColor3 = Colors.Tertiary}, 0.2)
                        
                        -- Show/hide columns based on tab
                        if Section.LeftColumn then
                            Section.LeftColumn.Visible = (tabName == "Main" or tabName == config.Tabs[1])
                        end
                        if Section.RightColumn then
                            Section.RightColumn.Visible = (tabName == "Tuning" or tabName == config.Tabs[2])
                        end
                    end)
                end
            end
            
            -- Content Area
            local ContentStart = config.Tabs and 85 or 55
            local Content = Instance.new("Frame")
            Content.Size = UDim2.new(1, 0, 0, 0)
            Content.Position = UDim2.new(0, 0, 0, ContentStart)
            Content.AutomaticSize = Enum.AutomaticSize.Y
            Content.BackgroundTransparency = 1
            Content.Parent = SectionContainer
            
            -- Two Column Layout
            local LeftColumn = Instance.new("Frame")
            LeftColumn.Size = UDim2.new(0.5, -15, 0, 0)
            LeftColumn.Position = UDim2.new(0, 12, 0, 0)
            LeftColumn.AutomaticSize = Enum.AutomaticSize.Y
            LeftColumn.BackgroundTransparency = 1
            LeftColumn.Parent = Content
            
            local LeftLayout = Instance.new("UIListLayout")
            LeftLayout.Padding = UDim.new(0, 8)
            LeftLayout.Parent = LeftColumn
            
            local RightColumn = Instance.new("Frame")
            RightColumn.Size = UDim2.new(0.5, -15, 0, 0)
            RightColumn.Position = UDim2.new(0.5, 8, 0, 0)
            RightColumn.AutomaticSize = Enum.AutomaticSize.Y
            RightColumn.BackgroundTransparency = 1
            RightColumn.Parent = Content
            
            local RightLayout = Instance.new("UIListLayout")
            RightLayout.Padding = UDim.new(0, 8)
            RightLayout.Parent = RightColumn
            
            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.PaddingBottom = UDim.new(0, 15)
            ContentPadding.Parent = Content
            
            Section.LeftColumn = LeftColumn
            Section.RightColumn = RightColumn
            
            -- ADD ELEMENTS
            function Section:AddToggle(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Toggle"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Toggle = Instance.new("TextButton")
                Toggle.Size = UDim2.new(0, 38, 0, 20)
                Toggle.Position = UDim2.new(1, -38, 0.5, -10)
                Toggle.BackgroundColor3 = cfg.Default and Colors.ToggleOn or Colors.ToggleOff
                Toggle.Text = ""
                Toggle.AutoButtonColor = false
                Toggle.Parent = Frame
                CreateRound(Toggle, 10)
                
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Position = cfg.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BorderSizePixel = 0
                Circle.Parent = Toggle
                CreateRound(Circle, 8)
                
                local toggled = cfg.Default or false
                
                Toggle.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Tween(Toggle, {BackgroundColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff}, 0.2)
                    Tween(Circle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    if cfg.Callback then cfg.Callback(toggled) end
                end)
                
                return {Set = function(v) toggled = v end}
            end
            
            function Section:AddSlider(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                local min, max, def = cfg.Min or 0, cfg.Max or 100, cfg.Default or 50
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 48)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Slider"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 50, 0, 20)
                Value.Position = UDim2.new(1, -50, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = tostring(def)
                Value.TextColor3 = Colors.Accent
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 12
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
                Fill.BackgroundColor3 = Colors.Accent
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
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                local opts = cfg.Options or {"Option 1"}
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.35, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Dropdown"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.6, 0, 0, 26)
                Button.Position = UDim2.new(0.4, 0, 0.5, -13)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.Text = "  " .. (cfg.Default or opts[1])
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 11
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
                Icon.TextSize = 8
                Icon.Parent = Button
                
                local List = Instance.new("Frame")
                List.Size = UDim2.new(0.6, 0, 0, 0)
                List.Position = UDim2.new(0.4, 0, 1, 5)
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
                    Opt.Size = UDim2.new(1, 0, 0, 26)
                    Opt.BackgroundColor3 = Colors.Tertiary
                    Opt.Text = "  " .. opt
                    Opt.TextColor3 = Colors.Text
                    Opt.Font = Enum.Font.Gotham
                    Opt.TextSize = 11
                    Opt.TextXAlignment = Enum.TextXAlignment.Left
                    Opt.AutoButtonColor = false
                    Opt.ZIndex = 11
                    Opt.Parent = List
                    
                    Opt.MouseEnter:Connect(function() Tween(Opt, {BackgroundColor3 = Colors.Secondary}, 0.15) end)
                    Opt.MouseLeave:Connect(function() Tween(Opt, {BackgroundColor3 = Colors.Tertiary}, 0.15) end)
                    Opt.MouseButton1Click:Connect(function()
                        Button.Text = "  " .. opt
                        List.Visible = false
                        Tween(Icon, {Rotation = 0}, 0.2)
                        if cfg.Callback then cfg.Callback(opt) end
                    end)
                end
                
                List.Size = UDim2.new(0.6, 0, 0, Layout.AbsoluteContentSize.Y + 10)
                
                Button.MouseButton1Click:Connect(function()
                    List.Visible = not List.Visible
                    Tween(Icon, {Rotation = List.Visible and 180 or 0}, 0.2)
                end)
                
                return {Set = function(v) Button.Text = "  " .. v end}
            end
            
            function Section:AddColorpicker(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -35, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Color"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Display = Instance.new("TextButton")
                Display.Size = UDim2.new(0, 26, 0, 26)
                Display.Position = UDim2.new(1, -26, 0.5, -13)
                Display.BackgroundColor3 = cfg.Default or Colors.Accent
                Display.Text = ""
                Display.AutoButtonColor = false
                Display.Parent = Frame
                CreateRound(Display, 13)
                
                -- Simple color cycle for demo
                local colors = {
                    Color3.fromRGB(255, 65, 85),
                    Color3.fromRGB(65, 255, 85),
                    Color3.fromRGB(65, 85, 255),
                    Color3.fromRGB(255, 255, 65),
                }
                local idx = 1
                
                Display.MouseButton1Click:Connect(function()
                    idx = (idx % #colors) + 1
                    Display.BackgroundColor3 = colors[idx]
                    if cfg.Callback then cfg.Callback(colors[idx]) end
                end)
                
                return {Set = function(c) Display.BackgroundColor3 = c end}
            end
            
            function Section:AddTextbox(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.35, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Textbox"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.6, 0, 0, 26)
                Box.Position = UDim2.new(0.4, 0, 0.5, -13)
                Box.BackgroundColor3 = Colors.Tertiary
                Box.Text = ""
                Box.PlaceholderText = cfg.Placeholder or "username"
                Box.TextColor3 = Colors.Text
                Box.PlaceholderColor3 = Colors.TextDark
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 11
                Box.TextXAlignment = Enum.TextXAlignment.Left
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
            
            function Section:AddButton(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 36)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.Text = cfg.Name or "Button"
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamMedium
                Button.TextSize = 12
                Button.AutoButtonColor = false
                Button.Parent = col
                CreateRound(Button, 6)
                
                Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = Colors.Secondary}, 0.2) end)
                Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = Colors.Tertiary}, 0.2) end)
                Button.MouseButton1Click:Connect(function()
                    if cfg.Callback then cfg.Callback() end
                end)
            end
            
            function Section:AddLabel(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 28)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Text or "Label"
                Label.TextColor3 = Colors.TextDark
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = Frame
                
                return {Set = function(t) Label.Text = t end}
            end
            
            function Section:AddRangeSlider(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                local def = cfg.Default or {20, 80}
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 48)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -70, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Range"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 60, 0, 20)
                Value.Position = UDim2.new(1, -60, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = def[1] .. " - " .. def[2]
                Value.TextColor3 = Colors.Text
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 11
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.Parent = Frame
                
                return {Set = function(min, max) Value.Text = min .. " - " .. max end}
            end
            
            function Section:AddPercentage(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                local def = cfg.Default or {60, 95}
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -70, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Percentage"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 60, 1, 0)
                Value.Position = UDim2.new(1, -60, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = def[1] .. "% - " .. def[2] .. "%"
                Value.TextColor3 = Colors.Text
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 11
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.Parent = Frame
                
                return {Set = function(min, max) Value.Text = min .. "% - " .. max .. "%" end}
            end
            
            function Section:AddKeybind(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right" or cfg.Column == "Tuning") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -45, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Keybind"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 40, 0, 26)
                Button.Position = UDim2.new(1, -40, 0.5, -13)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.Text = (cfg.Default and cfg.Default.Name) or "E"
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamBold
                Button.TextSize = 11
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
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Library
