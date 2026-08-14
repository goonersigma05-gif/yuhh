-- Winhvh Custom UI Library v2
-- Modern UI matching reference images

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

-- Professional Color Scheme (matching images)
local Colors = {
    Background = Color3.fromRGB(18, 18, 22),
    Secondary = Color3.fromRGB(24, 24, 28),
    Tertiary = Color3.fromRGB(32, 32, 38),
    Accent = Color3.fromRGB(138, 43, 226), -- Purple accent
    AccentHover = Color3.fromRGB(158, 63, 246),
    AccentDark = Color3.fromRGB(118, 33, 206),
    Text = Color3.fromRGB(245, 245, 250),
    TextGray = Color3.fromRGB(165, 165, 180),
    TextDark = Color3.fromRGB(110, 110, 125),
    Border = Color3.fromRGB(45, 45, 55),
    Toggle = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(55, 55, 65),
    Slider = Color3.fromRGB(138, 43, 226),
    IconSidebar = Color3.fromRGB(21, 21, 25),
    StatsBar = Color3.fromRGB(21, 21, 25),
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
    
    -- Main Container (professional styling)
    local MainContainer = Instance.new("Frame")
    MainContainer.Size = UDim2.new(0, 920, 0, 620)
    MainContainer.Position = UDim2.new(0.5, -460, 0.5, -310)
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui
    CreateRound(MainContainer, 14)
    
    -- Drop shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = 0
    Shadow.Parent = MainContainer
    
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
    
    -- Top Stats Bar (like in image: PAST OWL, GREEN SCREEN, etc.)
    local TopHeader = Instance.new("Frame")
    TopHeader.Size = UDim2.new(1, 0, 0, 45)
    TopHeader.BackgroundColor3 = Colors.StatsBar
    TopHeader.BorderSizePixel = 0
    TopHeader.Parent = MainContainer
    
    -- Title on left
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 75, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "Winhvh"
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopHeader
    
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Position = UDim2.new(0, 225, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = config.Version or "v1.0"
    VersionLabel.TextColor3 = Colors.TextDark
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextSize = 13
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TopHeader
    
    -- Stats Bar Container (right side)
    local StatsBar = Instance.new("Frame")
    StatsBar.Size = UDim2.new(0, 550, 1, 0)
    StatsBar.Position = UDim2.new(1, -570, 0, 0)
    StatsBar.BackgroundTransparency = 1
    StatsBar.Parent = TopHeader
    
    local StatsLayout = Instance.new("UIListLayout")
    StatsLayout.FillDirection = Enum.FillDirection.Horizontal
    StatsLayout.Padding = UDim.new(0, 20)
    StatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    StatsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StatsLayout.Parent = StatsBar
    
    -- Icon Sidebar (left navigation like in image)
    local IconSidebar = Instance.new("Frame")
    IconSidebar.Size = UDim2.new(0, 65, 1, -45)
    IconSidebar.Position = UDim2.new(0, 0, 0, 45)
    IconSidebar.BackgroundColor3 = Colors.IconSidebar
    IconSidebar.BorderSizePixel = 0
    IconSidebar.Parent = MainContainer
    
    -- Separator line
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Colors.Border
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = IconSidebar
    
    local IconLayout = Instance.new("UIListLayout")
    IconLayout.Padding = UDim.new(0, 10)
    IconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    IconLayout.Parent = IconSidebar
    
    local IconPadding = Instance.new("UIPadding")
    IconPadding.PaddingTop = UDim.new(0, 18)
    IconPadding.Parent = IconSidebar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -65, 1, -45)
    ContentContainer.Position = UDim2.new(0, 65, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainContainer
    
    -- AddStat Function (for stats bar items)
    function Window:AddStat(text)
        local StatLabel = Instance.new("TextLabel")
        StatLabel.Size = UDim2.new(0, 0, 0, 25)
        StatLabel.AutomaticSize = Enum.AutomaticSize.X
        StatLabel.BackgroundTransparency = 1
        StatLabel.Text = text
        StatLabel.TextColor3 = Colors.TextGray
        StatLabel.Font = Enum.Font.GothamMedium
        StatLabel.TextSize = 12
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
        
        -- Tab Icon Button (modern style like image)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 52, 0, 52)
        TabButton.BackgroundColor3 = Colors.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Text = config.Icon or "🏠"
        TabButton.TextColor3 = Colors.TextGray
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 22
        TabButton.AutoButtonColor = false
        TabButton.Parent = IconSidebar
        CreateRound(TabButton, 12)
        
        -- Subtle border
        CreateStroke(TabButton, Colors.Border, 1)
        
        -- Tab Content (scrolling frame)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -25, 1, -25)
        TabContent.Position = UDim2.new(0, 15, 0, 15)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 5
        TabContent.ScrollBarImageColor3 = Colors.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 18)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContent
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 25)
        end)
        
        -- Tab Switching Logic (smooth animations)
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Colors.Tertiary, TextColor3 = Colors.TextGray}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text}, 0.2)
        end)
        
        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if TabContent.Visible then return end
            Tween(TabButton, {BackgroundColor3 = Colors.Secondary}, 0.15)
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible then return end
            Tween(TabButton, {BackgroundColor3 = Colors.Tertiary}, 0.15)
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
            
            -- Section Container (modern card style)
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
            SectionContainer.BackgroundColor3 = Colors.Secondary
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Parent = TabContent
            CreateRound(SectionContainer, 12)
            CreateStroke(SectionContainer, Colors.Border, 1)
            
            -- Section Header (professional style matching image)
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 55)
            Header.BackgroundTransparency = 1
            Header.Parent = SectionContainer
            
            -- Icon Badge (like in image)
            local HeaderIcon = Instance.new("TextLabel")
            HeaderIcon.Size = UDim2.new(0, 42, 0, 42)
            HeaderIcon.Position = UDim2.new(0, 18, 0, 7)
            HeaderIcon.BackgroundColor3 = Colors.Tertiary
            HeaderIcon.Text = config.Icon or "⚙️"
            HeaderIcon.TextColor3 = Colors.Accent
            HeaderIcon.Font = Enum.Font.GothamBold
            HeaderIcon.TextSize = 20
            HeaderIcon.Parent = Header
            CreateRound(HeaderIcon, 10)
            CreateStroke(HeaderIcon, Colors.Border, 1)
            
            -- Title and Subtitle
            local HeaderTitle = Instance.new("TextLabel")
            HeaderTitle.Size = UDim2.new(1, -75, 0, 22)
            HeaderTitle.Position = UDim2.new(0, 70, 0, 8)
            HeaderTitle.BackgroundTransparency = 1
            HeaderTitle.Text = config.Name or "Section"
            HeaderTitle.TextColor3 = Colors.Text
            HeaderTitle.Font = Enum.Font.GothamBold
            HeaderTitle.TextSize = 15
            HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderTitle.Parent = Header
            
            local HeaderSubtitle = Instance.new("TextLabel")
            HeaderSubtitle.Size = UDim2.new(1, -75, 0, 16)
            HeaderSubtitle.Position = UDim2.new(0, 70, 0, 32)
            HeaderSubtitle.BackgroundTransparency = 1
            HeaderSubtitle.Text = config.Subtitle or "Customize the product as you wish"
            HeaderSubtitle.TextColor3 = Colors.TextDark
            HeaderSubtitle.Font = Enum.Font.Gotham
            HeaderSubtitle.TextSize = 11
            HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderSubtitle.Parent = Header
            
            -- Separator line below header
            local HeaderLine = Instance.new("Frame")
            HeaderLine.Size = UDim2.new(1, -30, 0, 1)
            HeaderLine.Position = UDim2.new(0, 15, 1, -1)
            HeaderLine.BackgroundColor3 = Colors.Border
            HeaderLine.BorderSizePixel = 0
            HeaderLine.Parent = Header
            
            -- Two Column Content Layout
            local Content = Instance.new("Frame")
            Content.Size = UDim2.new(1, 0, 0, 0)
            Content.Position = UDim2.new(0, 0, 0, 55)
            Content.AutomaticSize = Enum.AutomaticSize.Y
            Content.BackgroundTransparency = 1
            Content.Parent = SectionContainer
            
            -- Left Column (main settings)
            local LeftColumn = Instance.new("Frame")
            LeftColumn.Size = UDim2.new(0.5, -20, 0, 0)
            LeftColumn.Position = UDim2.new(0, 18, 0, 0)
            LeftColumn.AutomaticSize = Enum.AutomaticSize.Y
            LeftColumn.BackgroundTransparency = 1
            LeftColumn.Parent = Content
            
            local LeftLayout = Instance.new("UIListLayout")
            LeftLayout.Padding = UDim.new(0, 10)
            LeftLayout.Parent = LeftColumn
            
            -- Right Column (tuning settings)
            local RightColumn = Instance.new("Frame")
            RightColumn.Size = UDim2.new(0.5, -20, 0, 0)
            RightColumn.Position = UDim2.new(0.5, 8, 0, 0)
            RightColumn.AutomaticSize = Enum.AutomaticSize.Y
            RightColumn.BackgroundTransparency = 1
            RightColumn.Parent = Content
            
            local RightLayout = Instance.new("UIListLayout")
            RightLayout.Padding = UDim.new(0, 10)
            RightLayout.Parent = RightColumn
            
            local Padding = Instance.new("UIPadding")
            Padding.PaddingBottom = UDim.new(0, 18)
            Padding.Parent = Content
            
            Section.LeftColumn = LeftColumn
            Section.RightColumn = RightColumn
            
            -- ADD ELEMENTS TO SECTION
            function Section:AddToggle(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -55, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Toggle"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 44, 0, 22)
                Button.Position = UDim2.new(1, -44, 0.5, -11)
                Button.BackgroundColor3 = (cfg.Default and Colors.Toggle) or Colors.ToggleOff
                Button.BorderSizePixel = 0
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.Parent = Frame
                CreateRound(Button, 11)
                
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 18, 0, 18)
                Circle.Position = (cfg.Default and UDim2.new(1, -20, 0.5, -9)) or UDim2.new(0, 2, 0.5, -9)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BorderSizePixel = 0
                Circle.Parent = Button
                CreateRound(Circle, 9)
                
                local toggled = cfg.Default or false
                
                Button.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Tween(Button, {BackgroundColor3 = toggled and Colors.Toggle or Colors.ToggleOff}, 0.2)
                    Tween(Circle, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.2)
                    if cfg.Callback then cfg.Callback(toggled) end
                end)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = toggled and Colors.AccentHover or Colors.Tertiary}, 0.15)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = toggled and Colors.Toggle or Colors.ToggleOff}, 0.15)
                end)
                
                return {Set = function(v) toggled = v end}
            end
            
            function Section:AddSlider(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                local min, max, def = cfg.Min or 0, cfg.Max or 100, cfg.Default or 50
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 55)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -65, 0, 22)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Slider"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Value = Instance.new("TextLabel")
                Value.Size = UDim2.new(0, 55, 0, 22)
                Value.Position = UDim2.new(1, -55, 0, 0)
                Value.BackgroundTransparency = 1
                Value.Text = tostring(def)
                Value.TextColor3 = Colors.Accent
                Value.Font = Enum.Font.GothamBold
                Value.TextSize = 13
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.Parent = Frame
                
                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(1, 0, 0, 5)
                Bar.Position = UDim2.new(0, 0, 1, -18)
                Bar.BackgroundColor3 = Colors.ToggleOff
                Bar.BorderSizePixel = 0
                Bar.Parent = Frame
                CreateRound(Bar, 3)
                
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Colors.Slider
                Fill.BorderSizePixel = 0
                Fill.Parent = Bar
                CreateRound(Fill, 3)
                
                local Handle = Instance.new("Frame")
                Handle.Size = UDim2.new(0, 14, 0, 14)
                Handle.Position = UDim2.new((def - min) / (max - min), -7, 0.5, -7)
                Handle.BackgroundColor3 = Colors.Text
                Handle.BorderSizePixel = 0
                Handle.ZIndex = 2
                Handle.Parent = Bar
                CreateRound(Handle, 7)
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 1, 14)
                Button.Position = UDim2.new(0, 0, 0, -7)
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
                        Tween(Handle, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.05)
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
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.38, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Dropdown"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.58, 0, 0, 32)
                Button.Position = UDim2.new(0.42, 0, 0.5, -16)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.BorderSizePixel = 0
                Button.Text = "  " .. (cfg.Default or opts[1])
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamMedium
                Button.TextSize = 12
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.AutoButtonColor = false
                Button.Parent = Frame
                CreateRound(Button, 8)
                CreateStroke(Button, Colors.Border, 1)
                
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
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Color"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Display = Instance.new("TextButton")
                Display.Size = UDim2.new(0, 40, 0, 24)
                Display.Position = UDim2.new(1, -40, 0.5, -12)
                Display.BackgroundColor3 = cfg.Default or Colors.Accent
                Display.BorderSizePixel = 0
                Display.Text = ""
                Display.AutoButtonColor = false
                Display.Parent = Frame
                CreateRound(Display, 8)
                CreateStroke(Display, Colors.Border, 1)
                
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
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -52, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Keybind"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 45, 0, 28)
                Button.Position = UDim2.new(1, -45, 0.5, -14)
                Button.BackgroundColor3 = Colors.Tertiary
                Button.BorderSizePixel = 0
                Button.Text = (cfg.Default and cfg.Default.Name) or "E"
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamBold
                Button.TextSize = 11
                Button.AutoButtonColor = false
                Button.Parent = Frame
                CreateRound(Button, 8)
                CreateStroke(Button, Colors.Border, 1)
                
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
                Button.Size = UDim2.new(1, 0, 0, 42)
                Button.BackgroundColor3 = Colors.Accent
                Button.BorderSizePixel = 0
                Button.Text = cfg.Name or "Button"
                Button.TextColor3 = Colors.Text
                Button.Font = Enum.Font.GothamBold
                Button.TextSize = 13
                Button.AutoButtonColor = false
                Button.Parent = col
                CreateRound(Button, 10)
                
                -- Subtle glow effect
                local Glow = Instance.new("ImageLabel")
                Glow.Size = UDim2.new(1, 20, 1, 20)
                Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
                Glow.AnchorPoint = Vector2.new(0.5, 0.5)
                Glow.BackgroundTransparency = 1
                Glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
                Glow.ImageColor3 = Colors.Accent
                Glow.ImageTransparency = 1
                Glow.ZIndex = 0
                Glow.Parent = Button
                
                Button.MouseEnter:Connect(function() 
                    Tween(Button, {BackgroundColor3 = Colors.AccentHover}, 0.2)
                    Tween(Glow, {ImageTransparency = 0.7}, 0.2)
                end)
                Button.MouseLeave:Connect(function() 
                    Tween(Button, {BackgroundColor3 = Colors.Accent}, 0.2)
                    Tween(Glow, {ImageTransparency = 1}, 0.2)
                end)
                Button.MouseButton1Click:Connect(function()
                    Tween(Button, {BackgroundColor3 = Colors.AccentDark}, 0.08).Completed:Connect(function()
                        Tween(Button, {BackgroundColor3 = Colors.Accent}, 0.15)
                    end)
                    if cfg.Callback then cfg.Callback() end
                end)
            end
            
            function Section:AddTextbox(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.38, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Name or "Textbox"
                Label.TextColor3 = Colors.Text
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.58, 0, 0, 32)
                Box.Position = UDim2.new(0.42, 0, 0.5, -16)
                Box.BackgroundColor3 = Colors.Tertiary
                Box.BorderSizePixel = 0
                Box.Text = ""
                Box.PlaceholderText = cfg.Placeholder or "Enter text..."
                Box.TextColor3 = Colors.Text
                Box.PlaceholderColor3 = Colors.TextDark
                Box.Font = Enum.Font.GothamMedium
                Box.TextSize = 12
                Box.TextXAlignment = Enum.TextXAlignment.Left
                Box.ClearTextOnFocus = false
                Box.Parent = Frame
                CreateRound(Box, 8)
                CreateStroke(Box, Colors.Border, 1)
                
                local Pad = Instance.new("UIPadding")
                Pad.PaddingLeft = UDim.new(0, 10)
                Pad.PaddingRight = UDim.new(0, 10)
                Pad.Parent = Box
                
                Box.Focused:Connect(function()
                    Tween(Box, {BackgroundColor3 = Colors.Secondary}, 0.2)
                end)
                
                Box.FocusLost:Connect(function(enter)
                    Tween(Box, {BackgroundColor3 = Colors.Tertiary}, 0.2)
                    if enter and cfg.Callback then cfg.Callback(Box.Text) end
                end)
                
                return {Set = function(t) Box.Text = t end}
            end
            
            function Section:AddLabel(cfg)
                cfg = cfg or {}
                local col = (cfg.Column == "Right") and RightColumn or LeftColumn
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = col
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = cfg.Text or "Label"
                Label.TextColor3 = Colors.TextGray
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
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
