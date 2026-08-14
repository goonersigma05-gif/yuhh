-- Winhvh Custom UI Library v2
-- Advanced UI matching the reference design with stats bar, icon sidebar, two-column layout

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Library = {}
Library.__index = Library

-- Colors matching the dark theme
local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 35),
    Tertiary = Color3.fromRGB(40, 40, 45),
    Accent = Color3.fromRGB(255, 75, 90),
    AccentHover = Color3.fromRGB(255, 95, 110),
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
    radius = radius or 8
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
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
    duration = duration or 0.15
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Winhvh"
    local windowVersion = config.Version or "v1.0"
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Stats = {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WinhvhUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    Window.ScreenGui = ScreenGui
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 900, 0, 600)
    MainContainer.Position = UDim2.new(0.5, -450, 0.5, -300)
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BorderSizePixel = 0
    MainContainer.Active = true
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui
    CreateRound(MainContainer, 12)
    
    Window.MainContainer = MainContainer
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    MainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainContainer.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Top Header with Title
    local TopHeader = Instance.new("Frame")
    TopHeader.Name = "TopHeader"
    TopHeader.Size = UDim2.new(1, 0, 0, 50)
    TopHeader.BackgroundColor3 = Colors.Secondary
    TopHeader.BorderSizePixel = 0
    TopHeader.Parent = MainContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopHeader
    
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Position = UDim2.new(0, 180, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = windowVersion
    VersionLabel.TextColor3 = Colors.TextDark
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextSize = 14
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TopHeader
    
    -- Stats Bar (PAST OWL, GREEN SCREEN, etc.)
    local StatsBar = Instance.new("Frame")
    StatsBar.Name = "StatsBar"
    StatsBar.Size = UDim2.new(0, 500, 0, 30)
    StatsBar.Position = UDim2.new(1, -520, 0, 10)
    StatsBar.BackgroundTransparency = 1
    StatsBar.Parent = TopHeader
    
    local StatsLayout = Instance.new("UIListLayout")
    StatsLayout.FillDirection = Enum.FillDirection.Horizontal
    StatsLayout.Padding = UDim.new(0, 15)
    StatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    StatsLayout.Parent = StatsBar
    
    Window.StatsBar = StatsBar
    
    -- Icon Sidebar (left side with icons)
    local IconSidebar = Instance.new("Frame")
    IconSidebar.Name = "IconSidebar"
    IconSidebar.Size = UDim2.new(0, 60, 1, -50)
    IconSidebar.Position = UDim2.new(0, 0, 0, 50)
    IconSidebar.BackgroundColor3 = Colors.IconSidebar
    IconSidebar.BorderSizePixel = 0
    IconSidebar.Parent = MainContainer
    
    Window.IconSidebar = IconSidebar
    
    local IconLayout = Instance.new("UIListLayout")
    IconLayout.Padding = UDim.new(0, 8)
    IconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    IconLayout.Parent = IconSidebar
    
    local IconPadding = Instance.new("UIPadding")
    IconPadding.PaddingTop = UDim.new(0, 15)
    IconPadding.Parent = IconSidebar
    
    -- Content Container (main area)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -60, 1, -50)
    ContentContainer.Position = UDim2.new(0, 60, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainContainer
    
    Window.ContentContainer = ContentContainer
    
    -- Add Stat function
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
        
        table.insert(Window.Stats, StatLabel)
        
        return {
            Set = function(newText)
                StatLabel.Text = newText
            end
        }
    end
    
    -- Create Tab function
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "🏠"
        
        local Tab = {}
        Tab.Name = tabName
        Tab.Sections = {}
        
        -- Tab Icon Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(0, 50, 0, 50)
        TabButton.BackgroundColor3 = Colors.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabIcon
        TabButton.TextColor3 = Colors.TextGray
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 20
        TabButton.AutoButtonColor = false
        TabButton.Parent = IconSidebar
        CreateRound(TabButton, 10)
        
        -- Tab Content (scrollable with sections)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
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
        
        Tab.TabButton = TabButton
        Tab.TabContent = TabContent
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.TabContent.Visible = false
                Tween(tab.TabButton, {BackgroundColor3 = Colors.Tertiary, TextColor3 = Colors.TextGray})
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text})
            Window.CurrentTab = Tab
        end)
        
        -- Activate first tab
        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Colors.Accent
            TabButton.TextColor3 = Colors.Text
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Create Section function (two-column layout like the image)
        function Tab:CreateSection(config)
            config = config or {}
            local sectionName = config.Name or "Section"
            local sectionIcon = config.Icon or "⚙️"
            
            local Section = {}
            Section.Name = sectionName
            Section.LeftColumn = {}
            Section.RightColumn = {}
            
            -- Section Container
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = sectionName
            SectionContainer.Size = UDim2.new(1, 0, 0, 0)
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
            SectionContainer.BackgroundColor3 = Colors.Secondary
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Parent = TabContent
            CreateRound(SectionContainer, 10)
            
            -- Section Header
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 50)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = SectionContainer
            
            local HeaderIcon = Instance.new("TextLabel")
            HeaderIcon.Size = UDim2.new(0, 40, 0, 40)
            HeaderIcon.Position = UDim2.new(0, 15, 0, 5)
            HeaderIcon.BackgroundColor3 = Colors.Tertiary
            HeaderIcon.Text = sectionIcon
            HeaderIcon.TextColor3 = Colors.Text
            HeaderIcon.Font = Enum.Font.GothamBold
            HeaderIcon.TextSize = 18
            HeaderIcon.Parent = SectionHeader
            CreateRound(HeaderIcon, 8)
            
            local HeaderTitle = Instance.new("TextLabel")
            HeaderTitle.Size = UDim2.new(1, -70, 0, 25)
            HeaderTitle.Position = UDim2.new(0, 65, 0, 5)
            HeaderTitle.BackgroundTransparency = 1
            HeaderTitle.Text = sectionName
            HeaderTitle.TextColor3 = Colors.Text
            HeaderTitle.Font = Enum.Font.GothamBold
            HeaderTitle.TextSize = 16
            HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderTitle.Parent = SectionHeader
            
            local HeaderSubtitle = Instance.new("TextLabel")
            HeaderSubtitle.Size = UDim2.new(1, -70, 0, 15)
            HeaderSubtitle.Position = UDim2.new(0, 65, 0, 28)
            HeaderSubtitle.BackgroundTransparency = 1
            HeaderSubtitle.Text = config.Subtitle or "Customize the product as you wish"
            HeaderSubtitle.TextColor3 = Colors.TextDark
            HeaderSubtitle.Font = Enum.Font.Gotham
            HeaderSubtitle.TextSize = 12
            HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
            HeaderSubtitle.Parent = SectionHeader
            
            -- Section Content with two columns
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Position = UDim2.new(0, 0, 0, 50)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionContainer
            
            -- Left Column (Main settings)
            local LeftColumn = Instance.new("Frame")
            LeftColumn.Name = "LeftColumn"
            LeftColumn.Size = UDim2.new(0.5, -10, 0, 0)
            LeftColumn.Position = UDim2.new(0, 15, 0, 0)
            LeftColumn.AutomaticSize = Enum.AutomaticSize.Y
            LeftColumn.BackgroundTransparency = 1
            LeftColumn.Parent = SectionContent
            
            local LeftLayout = Instance.new("UIListLayout")
            LeftLayout.Padding = UDim.new(0, 8)
            LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
            LeftLayout.Parent = LeftColumn
            
            -- Right Column (Tuning/Advanced settings)
            local RightColumn = Instance.new("Frame")
            RightColumn.Name = "RightColumn"
            RightColumn.Size = UDim2.new(0.5, -10, 0, 0)
            RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
            RightColumn.AutomaticSize = Enum.AutomaticSize.Y
            RightColumn.BackgroundTransparency = 1
            RightColumn.Parent = SectionContent
            
            local RightLayout = Instance.new("UIListLayout")
            RightLayout.Padding = UDim.new(0, 8)
            RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
            RightLayout.Parent = RightColumn
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingBottom = UDim.new(0, 15)
            SectionPadding.Parent = SectionContent
            
            Section.SectionContainer = SectionContainer
            Section.LeftColumn = LeftColumn
            Section.RightColumn = RightColumn
            
            table.insert(Tab.Sections, Section)
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

-- Element Functions (AddToggle, AddSlider, etc.) - Add to Section
function AddToggle(parent, config)
    config = config or {}
    local toggleName = config.Name or "Toggle"
    local toggleDefault = config.Default or false
    local toggleCallback = config.Callback or function() end
    local column = config.Column or "Left" -- Left or Right column
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = toggleName
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = targetColumn
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = toggleName
    ToggleLabel.TextColor3 = Colors.Text
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    -- Modern toggle switch
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    ToggleButton.BackgroundColor3 = toggleDefault and Colors.Toggle or Colors.ToggleOff
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleFrame
    CreateRound(ToggleButton, 10)
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = toggleDefault and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    CreateRound(ToggleCircle, 8)
    
    local toggled = toggleDefault
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        Tween(ToggleButton, {BackgroundColor3 = toggled and Colors.Toggle or Colors.ToggleOff})
        Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
        
        pcall(toggleCallback, toggled)
    end)
    
    return {
        Set = function(value)
            toggled = value
            ToggleButton.BackgroundColor3 = toggled and Colors.Toggle or Colors.ToggleOff
            ToggleCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        end
    }
end

-- Add more element functions here (AddSlider, AddDropdown, AddColorpicker, etc.)
-- Following the same pattern

return Library


-- Add Slider (like FOV slider in image)
function AddSlider(parent, config)
    config = config or {}
    local sliderName = config.Name or "Slider"
    local sliderMin = config.Min or 0
    local sliderMax = config.Max or 100
    local sliderDefault = config.Default or 50
    local sliderCallback = config.Callback or function() end
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = sliderName
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = targetColumn
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -60, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = sliderName
    SliderLabel.TextColor3 = Colors.Text
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -50, 0, 0)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(sliderDefault)
    SliderValue.TextColor3 = Colors.Accent
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextSize = 14
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 4)
    SliderBar.Position = UDim2.new(0, 0, 1, -15)
    SliderBar.BackgroundColor3 = Colors.ToggleOff
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    CreateRound(SliderBar, 2)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
    SliderFill.BackgroundColor3 = Colors.Slider
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    CreateRound(SliderFill, 2)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 10)
    SliderButton.Position = UDim2.new(0, 0, 0, -5)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderButton.MouseMoved:Connect(function(x)
        if dragging then
            local percentage = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(sliderMin + (sliderMax - sliderMin) * percentage)
            
            SliderValue.Text = tostring(value)
            Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.05)
            
            pcall(sliderCallback, value)
        end
    end)
    
    return {
        Set = function(value)
            value = math.clamp(value, sliderMin, sliderMax)
            local percentage = (value - sliderMin) / (sliderMax - sliderMin)
            SliderValue.Text = tostring(value)
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        end
    }
end

-- Add Range Slider (like "8 - 24" in Tuning section)
function AddRangeSlider(parent, config)
    config = config or {}
    local sliderName = config.Name or "Range"
    local sliderMin = config.Min or 0
    local sliderMax = config.Max or 100
    local sliderDefault = config.Default or {20, 80}
    local sliderCallback = config.Callback or function() end
    local column = config.Column or "Right"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = sliderName
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = targetColumn
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -80, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = sliderName
    SliderLabel.TextColor3 = Colors.Text
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 70, 0, 20)
    SliderValue.Position = UDim2.new(1, -70, 0, 0)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = sliderDefault[1] .. " - " .. sliderDefault[2]
    SliderValue.TextColor3 = Colors.Text
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextSize = 13
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    return {
        Set = function(min, max)
            SliderValue.Text = min .. " - " .. max
        end
    }
end

-- Add Dropdown (like Hit Part dropdown)
function AddDropdown(parent, config)
    config = config or {}
    local dropdownName = config.Name or "Dropdown"
    local dropdownOptions = config.Options or {"Option 1", "Option 2"}
    local dropdownDefault = config.Default or dropdownOptions[1]
    local dropdownCallback = config.Callback or function() end
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = dropdownName
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = targetColumn
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = dropdownName
    DropdownLabel.TextColor3 = Colors.Text
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0.55, 0, 0, 28)
    DropdownButton.Position = UDim2.new(0.45, 0, 0.5, -14)
    DropdownButton.BackgroundColor3 = Colors.Tertiary
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = "  " .. dropdownDefault
    DropdownButton.TextColor3 = Colors.Text
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextSize = 13
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.AutoButtonColor = false
    DropdownButton.Parent = DropdownFrame
    CreateRound(DropdownButton, 6)
    
    local DropdownIcon = Instance.new("TextLabel")
    DropdownIcon.Size = UDim2.new(0, 20, 1, 0)
    DropdownIcon.Position = UDim2.new(1, -20, 0, 0)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Text = "▼"
    DropdownIcon.TextColor3 = Colors.TextDark
    DropdownIcon.Font = Enum.Font.GothamBold
    DropdownIcon.TextSize = 10
    DropdownIcon.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(0.55, 0, 0, 0)
    DropdownList.Position = UDim2.new(0.45, 0, 1, 5)
    DropdownList.BackgroundColor3 = Colors.Tertiary
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 10
    DropdownList.Parent = DropdownFrame
    CreateRound(DropdownList, 6)
    CreateStroke(DropdownList, Colors.Border, 1)
    
    local DropdownListLayout = Instance.new("UIListLayout")
    DropdownListLayout.Padding = UDim.new(0, 2)
    DropdownListLayout.Parent = DropdownList
    
    local DropdownListPadding = Instance.new("UIPadding")
    DropdownListPadding.PaddingTop = UDim.new(0, 5)
    DropdownListPadding.PaddingBottom = UDim.new(0, 5)
    DropdownListPadding.Parent = DropdownList
    
    for _, option in ipairs(dropdownOptions) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.BackgroundColor3 = Colors.Tertiary
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = "  " .. option
        OptionButton.TextColor3 = Colors.Text
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextSize = 13
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 11
        OptionButton.Parent = DropdownList
        
        OptionButton.MouseEnter:Connect(function()
            Tween(OptionButton, {BackgroundColor3 = Colors.Secondary})
        end)
        
        OptionButton.MouseLeave:Connect(function()
            Tween(OptionButton, {BackgroundColor3 = Colors.Tertiary})
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = "  " .. option
            DropdownList.Visible = false
            Tween(DropdownIcon, {Rotation = 0}, 0.2)
            pcall(dropdownCallback, option)
        end)
    end
    
    DropdownList.Size = UDim2.new(0.55, 0, 0, DropdownListLayout.AbsoluteContentSize.Y + 10)
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
        Tween(DropdownIcon, {Rotation = DropdownList.Visible and 180 or 0}, 0.2)
    end)
    
    return {
        Set = function(value)
            DropdownButton.Text = "  " .. value
        end
    }
end

-- Add Colorpicker (like FOV color in image)
function AddColorpicker(parent, config)
    config = config or {}
    local colorpickerName = config.Name or "Color"
    local colorpickerDefault = config.Default or Color3.fromRGB(255, 0, 0)
    local colorpickerCallback = config.Callback or function() end
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = colorpickerName
    ColorFrame.Size = UDim2.new(1, 0, 0, 35)
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.Parent = targetColumn
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Size = UDim2.new(1, -45, 1, 0)
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Text = colorpickerName
    ColorLabel.TextColor3 = Colors.Text
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.TextSize = 14
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorLabel.Parent = ColorFrame
    
    local ColorDisplay = Instance.new("TextButton")
    ColorDisplay.Size = UDim2.new(0, 35, 0, 20)
    ColorDisplay.Position = UDim2.new(1, -35, 0.5, -10)
    ColorDisplay.BackgroundColor3 = colorpickerDefault
    ColorDisplay.BorderSizePixel = 0
    ColorDisplay.Text = ""
    ColorDisplay.AutoButtonColor = false
    ColorDisplay.Parent = ColorFrame
    CreateRound(ColorDisplay, 6)
    
    -- Color picker window
    local ColorWindow = Instance.new("Frame")
    ColorWindow.Size = UDim2.new(0, 200, 0, 200)
    ColorWindow.Position = UDim2.new(1, 5, 0, 0)
    ColorWindow.BackgroundColor3 = Colors.Secondary
    ColorWindow.BorderSizePixel = 0
    ColorWindow.Visible = false
    ColorWindow.ZIndex = 20
    ColorWindow.Parent = ColorFrame
    CreateRound(ColorWindow, 8)
    CreateStroke(ColorWindow, Colors.Border, 1)
    
    local hue, sat, val = colorpickerDefault:ToHSV()
    local currentColor = colorpickerDefault
    
    -- Saturation/Value picker
    local SVPicker = Instance.new("TextButton")
    SVPicker.Size = UDim2.new(1, -45, 1, -50)
    SVPicker.Position = UDim2.new(0, 10, 0, 10)
    SVPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    SVPicker.BorderSizePixel = 0
    SVPicker.Text = ""
    SVPicker.AutoButtonColor = false
    SVPicker.ZIndex = 21
    SVPicker.Parent = ColorWindow
    CreateRound(SVPicker, 6)
    
    local SVOverlay1 = Instance.new("ImageLabel")
    SVOverlay1.Size = UDim2.new(1, 0, 1, 0)
    SVOverlay1.BackgroundTransparency = 1
    SVOverlay1.Image = "rbxassetid://4155801252"
    SVOverlay1.ZIndex = 22
    SVOverlay1.Parent = SVPicker
    
    local SVOverlay2 = Instance.new("ImageLabel")
    SVOverlay2.Size = UDim2.new(1, 0, 1, 0)
    SVOverlay2.BackgroundTransparency = 1
    SVOverlay2.Image = "rbxassetid://4155801252"
    SVOverlay2.Rotation = 90
    SVOverlay2.ZIndex = 22
    SVOverlay2.Parent = SVPicker
    
    -- Hue slider
    local HueSlider = Instance.new("TextButton")
    HueSlider.Size = UDim2.new(0, 20, 1, -50)
    HueSlider.Position = UDim2.new(1, -28, 0, 10)
    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.BorderSizePixel = 0
    HueSlider.Text = ""
    HueSlider.AutoButtonColor = false
    HueSlider.ZIndex = 21
    HueSlider.Parent = ColorWindow
    CreateRound(HueSlider, 6)
    
    local HueGradient = Instance.new("UIGradient")
    HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    })
    HueGradient.Rotation = 90
    HueGradient.Parent = HueSlider
    
    -- RGB display
    local RGBDisplay = Instance.new("TextLabel")
    RGBDisplay.Size = UDim2.new(1, -20, 0, 25)
    RGBDisplay.Position = UDim2.new(0, 10, 1, -35)
    RGBDisplay.BackgroundColor3 = Colors.Tertiary
    RGBDisplay.BorderSizePixel = 0
    RGBDisplay.Text = string.format("RGB: %d, %d, %d", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
    RGBDisplay.TextColor3 = Colors.Text
    RGBDisplay.Font = Enum.Font.Gotham
    RGBDisplay.TextSize = 11
    RGBDisplay.ZIndex = 21
    RGBDisplay.Parent = ColorWindow
    CreateRound(RGBDisplay, 6)
    
    local function updateColor()
        currentColor = Color3.fromHSV(hue, sat, val)
        ColorDisplay.BackgroundColor3 = currentColor
        SVPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        RGBDisplay.Text = string.format("RGB: %d, %d, %d", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
        pcall(colorpickerCallback, currentColor)
    end
    
    local svDragging = false
    local hueDragging = false
    
    SVPicker.MouseButton1Down:Connect(function()
        svDragging = true
    end)
    
    HueSlider.MouseButton1Down:Connect(function()
        hueDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
            hueDragging = false
        end
    end)
    
    SVPicker.MouseMoved:Connect(function(x, y)
        if svDragging then
            local relX = math.clamp((x - SVPicker.AbsolutePosition.X) / SVPicker.AbsoluteSize.X, 0, 1)
            local relY = math.clamp((y - SVPicker.AbsolutePosition.Y) / SVPicker.AbsoluteSize.Y, 0, 1)
            sat = relX
            val = 1 - relY
            updateColor()
        end
    end)
    
    HueSlider.MouseMoved:Connect(function(x, y)
        if hueDragging then
            local relY = math.clamp((y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
            hue = relY
            updateColor()
        end
    end)
    
    ColorDisplay.MouseButton1Click:Connect(function()
        ColorWindow.Visible = not ColorWindow.Visible
    end)
    
    return {
        Set = function(color)
            hue, sat, val = color:ToHSV()
            updateColor()
        end
    }
end

-- Add Keybind (like Toggle Aim keybind)
function AddKeybind(parent, config)
    config = config or {}
    local keybindName = config.Name or "Keybind"
    local keybindDefault = config.Default or Enum.KeyCode.E
    local keybindCallback = config.Callback or function() end
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = keybindName
    KeybindFrame.Size = UDim2.new(1, 0, 0, 35)
    KeybindFrame.BackgroundTransparency = 1
    KeybindFrame.Parent = targetColumn
    
    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Size = UDim2.new(1, -45, 1, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = keybindName
    KeybindLabel.TextColor3 = Colors.Text
    KeybindLabel.Font = Enum.Font.Gotham
    KeybindLabel.TextSize = 14
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.Parent = KeybindFrame
    
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(0, 35, 0, 25)
    KeybindButton.Position = UDim2.new(1, -35, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Colors.Tertiary
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = keybindDefault.Name
    KeybindButton.TextColor3 = Colors.Text
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.TextSize = 12
    KeybindButton.AutoButtonColor = false
    KeybindButton.Parent = KeybindFrame
    CreateRound(KeybindButton, 6)
    
    local currentKey = keybindDefault
    local binding = false
    
    KeybindButton.MouseButton1Click:Connect(function()
        if not binding then
            binding = true
            KeybindButton.Text = "..."
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeybindButton.Text = currentKey.Name
                    binding = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == currentKey and not binding then
            pcall(keybindCallback)
        end
    end)
    
    return {
        Set = function(key)
            currentKey = key
            KeybindButton.Text = key.Name
        end
    }
end

-- Add Button (like Test Button)
function AddButton(parent, config)
    config = config or {}
    local buttonName = config.Name or "Button"
    local buttonCallback = config.Callback or function() end
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = buttonName
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.BackgroundColor3 = Colors.Accent
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = buttonName
    ButtonFrame.TextColor3 = Colors.Text
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.TextSize = 14
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = targetColumn
    CreateRound(ButtonFrame, 8)
    
    ButtonFrame.MouseEnter:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Colors.AccentHover})
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Colors.Accent})
    end)
    
    ButtonFrame.MouseButton1Click:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Colors.AccentDark}, 0.1).Completed:Connect(function()
            Tween(ButtonFrame, {BackgroundColor3 = Colors.Accent}, 0.1)
        end)
        pcall(buttonCallback)
    end)
end

-- Add Textbox (like Custom Value textbox)
function AddTextbox(parent, config)
    config = config or {}
    local textboxName = config.Name or "Textbox"
    local textboxPlaceholder = config.Placeholder or "Enter text..."
    local textboxCallback = config.Callback or function() end
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = textboxName
    TextboxFrame.Size = UDim2.new(1, 0, 0, 35)
    TextboxFrame.BackgroundTransparency = 1
    TextboxFrame.Parent = targetColumn
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = textboxName
    TextboxLabel.TextColor3 = Colors.Text
    TextboxLabel.Font = Enum.Font.Gotham
    TextboxLabel.TextSize = 14
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.Parent = TextboxFrame
    
    local Textbox = Instance.new("TextBox")
    Textbox.Size = UDim2.new(0.55, 0, 0, 28)
    Textbox.Position = UDim2.new(0.45, 0, 0.5, -14)
    Textbox.BackgroundColor3 = Colors.Tertiary
    Textbox.BorderSizePixel = 0
    Textbox.Text = ""
    Textbox.PlaceholderText = textboxPlaceholder
    Textbox.TextColor3 = Colors.Text
    Textbox.PlaceholderColor3 = Colors.TextDark
    Textbox.Font = Enum.Font.Gotham
    Textbox.TextSize = 13
    Textbox.ClearTextOnFocus = false
    Textbox.Parent = TextboxFrame
    CreateRound(Textbox, 6)
    
    local TextboxPadding = Instance.new("UIPadding")
    TextboxPadding.PaddingLeft = UDim.new(0, 8)
    TextboxPadding.PaddingRight = UDim.new(0, 8)
    TextboxPadding.Parent = Textbox
    
    Textbox.FocusLost:Connect(function(enter)
        if enter then
            pcall(textboxCallback, Textbox.Text)
        end
    end)
    
    return {
        Set = function(text)
            Textbox.Text = text
        end
    }
end

-- Add Label
function AddLabel(parent, config)
    config = config or {}
    local labelText = config.Text or "Label"
    local column = config.Column or "Left"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(1, 0, 0, 30)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Parent = targetColumn
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Colors.TextDark
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = LabelFrame
    
    return {
        Set = function(newText)
            Label.Text = newText
        end
    }
end

-- Add Percentage Display (like "60% - 95%" in image)
function AddPercentage(parent, config)
    config = config or {}
    local percentageName = config.Name or "Percentage"
    local percentageDefault = config.Default or {60, 95}
    local column = config.Column or "Right"
    
    local targetColumn = column == "Right" and parent.RightColumn or parent.LeftColumn
    
    local PercentageFrame = Instance.new("Frame")
    PercentageFrame.Name = percentageName
    PercentageFrame.Size = UDim2.new(1, 0, 0, 35)
    PercentageFrame.BackgroundTransparency = 1
    PercentageFrame.Parent = targetColumn
    
    local PercentageLabel = Instance.new("TextLabel")
    PercentageLabel.Size = UDim2.new(1, -80, 1, 0)
    PercentageLabel.BackgroundTransparency = 1
    PercentageLabel.Text = percentageName
    PercentageLabel.TextColor3 = Colors.Text
    PercentageLabel.Font = Enum.Font.Gotham
    PercentageLabel.TextSize = 14
    PercentageLabel.TextXAlignment = Enum.TextXAlignment.Left
    PercentageLabel.Parent = PercentageFrame
    
    local PercentageValue = Instance.new("TextLabel")
    PercentageValue.Size = UDim2.new(0, 70, 1, 0)
    PercentageValue.Position = UDim2.new(1, -70, 0, 0)
    PercentageValue.BackgroundTransparency = 1
    PercentageValue.Text = percentageDefault[1] .. "% - " .. percentageDefault[2] .. "%"
    PercentageValue.TextColor3 = Colors.Text
    PercentageValue.Font = Enum.Font.GothamBold
    PercentageValue.TextSize = 13
    PercentageValue.TextXAlignment = Enum.TextXAlignment.Right
    PercentageValue.Parent = PercentageFrame
    
    return {
        Set = function(min, max)
            PercentageValue.Text = min .. "% - " .. max .. "%"
        end
    }
end

-- Attach element functions to Section
local SectionMeta = {}
SectionMeta.__index = SectionMeta

function SectionMeta:AddToggle(config)
    return AddToggle(self, config)
end

function SectionMeta:AddSlider(config)
    return AddSlider(self, config)
end

function SectionMeta:AddRangeSlider(config)
    return AddRangeSlider(self, config)
end

function SectionMeta:AddDropdown(config)
    return AddDropdown(self, config)
end

function SectionMeta:AddColorpicker(config)
    return AddColorpicker(self, config)
end

function SectionMeta:AddKeybind(config)
    return AddKeybind(self, config)
end

function SectionMeta:AddButton(config)
    return AddButton(self, config)
end

function SectionMeta:AddTextbox(config)
    return AddTextbox(self, config)
end

function SectionMeta:AddLabel(config)
    return AddLabel(self, config)
end

function SectionMeta:AddPercentage(config)
    return AddPercentage(self, config)
end

-- Apply metatable to sections
local OriginalCreateSection = Library.CreateSection
if OriginalCreateSection then
    function Library.CreateSection(tab, config)
        local section = OriginalCreateSection(tab, config)
        return setmetatable(section, SectionMeta)
    end
end
