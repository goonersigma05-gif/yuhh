-- Winhvh Custom UI Library
-- Modern UI with all features: toggles, sliders, dropdowns, color pickers, keybinds, sub-tabs

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}
Library.__index = Library

-- Modern Colors
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 30),
    Tertiary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(255, 70, 85),
    Text = Color3.fromRGB(245, 245, 245),
    TextDark = Color3.fromRGB(150, 150, 160),
    Border = Color3.fromRGB(45, 45, 55),
    Toggle = Color3.fromRGB(255, 70, 85),
    Slider = Color3.fromRGB(255, 70, 85),
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
    duration = duration or 0.2
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Winhvh"
    local windowSubtitle = config.Subtitle or "Custom UI"
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
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
    MainContainer.Size = UDim2.new(0, 850, 0, 550)
    MainContainer.Position = UDim2.new(0.5, -425, 0.5, -275)
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BorderSizePixel = 0
    MainContainer.Active = true
    MainContainer.Parent = ScreenGui
    CreateRound(MainContainer, 12)
    CreateStroke(MainContainer, Colors.Border, 1)
    
    Window.MainContainer = MainContainer
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 0
    Shadow.Parent = MainContainer
    
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
    
    MainContainer.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Top bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, -20, 0, 50)
    TopBar.Position = UDim2.new(0, 10, 0, 10)
    TopBar.BackgroundColor3 = Colors.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainContainer
    CreateRound(TopBar, 10)
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 15)
    SubtitleLabel.Position = UDim2.new(0, 220, 0.5, -7)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = windowSubtitle
    SubtitleLabel.TextColor3 = Colors.TextDark
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TopBar
    
    -- Sidebar for tabs
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, -80)
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.BackgroundColor3 = Colors.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainContainer
    CreateRound(Sidebar, 10)
    
    Window.Sidebar = Sidebar
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -210, 1, -80)
    ContentContainer.Position = UDim2.new(0, 200, 0, 70)
    ContentContainer.BackgroundColor3 = Colors.Secondary
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainContainer
    CreateRound(ContentContainer, 10)
    
    Window.ContentContainer = ContentContainer
    
    -- Create Tab function
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "rbxassetid://7733964640"
        
        local Tab = {}
        Tab.Name = tabName
        Tab.SubTabs = {}
        Tab.CurrentSubTab = nil
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.BackgroundColor3 = Colors.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar
        CreateRound(TabButton, 8)
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 15, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = Colors.TextDark
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -50, 1, 0)
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Colors.TextDark
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content with Sub-Tabs
        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        -- Sub-Tab Bar
        local SubTabBar = Instance.new("Frame")
        SubTabBar.Name = "SubTabBar"
        SubTabBar.Size = UDim2.new(1, -20, 0, 40)
        SubTabBar.Position = UDim2.new(0, 10, 0, 10)
        SubTabBar.BackgroundTransparency = 1
        SubTabBar.Parent = TabContent
        
        local SubTabList = Instance.new("UIListLayout")
        SubTabList.FillDirection = Enum.FillDirection.Horizontal
        SubTabList.Padding = UDim.new(0, 8)
        SubTabList.Parent = SubTabBar
        
        -- Sub-Tab Content Container
        local SubTabContainer = Instance.new("Frame")
        SubTabContainer.Name = "SubTabContainer"
        SubTabContainer.Size = UDim2.new(1, -20, 1, -60)
        SubTabContainer.Position = UDim2.new(0, 10, 0, 55)
        SubTabContainer.BackgroundTransparency = 1
        SubTabContainer.Parent = TabContent
        
        Tab.TabButton = TabButton
        Tab.TabContent = TabContent
        Tab.SubTabBar = SubTabBar
        Tab.SubTabContainer = SubTabContainer
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.TabContent.Visible = false
                Tween(tab.TabButton, {BackgroundColor3 = Colors.Tertiary})
                for _, element in ipairs(tab.TabButton:GetChildren()) do
                    if element:IsA("ImageLabel") then
                        Tween(element, {ImageColor3 = Colors.TextDark})
                    elseif element:IsA("TextLabel") then
                        Tween(element, {TextColor3 = Colors.TextDark})
                    end
                end
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Colors.Accent})
            Tween(TabIcon, {ImageColor3 = Colors.Text})
            Tween(TabLabel, {TextColor3 = Colors.Text})
            Window.CurrentTab = Tab
        end)
        
        -- Activate first tab
        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Colors.Accent
            TabIcon.ImageColor3 = Colors.Text
            TabLabel.TextColor3 = Colors.Text
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Create SubTab function
        function Tab:CreateSubTab(subTabName)
            subTabName = subTabName or "SubTab"
            
            local SubTab = {}
            SubTab.Name = subTabName
            SubTab.Elements = {}
            
            -- SubTab Button
            local SubTabButton = Instance.new("TextButton")
            SubTabButton.Name = subTabName
            SubTabButton.Size = UDim2.new(0, 120, 1, 0)
            SubTabButton.BackgroundColor3 = Colors.Tertiary
            SubTabButton.BorderSizePixel = 0
            SubTabButton.Text = subTabName
            SubTabButton.TextColor3 = Colors.TextDark
            SubTabButton.Font = Enum.Font.GothamMedium
            SubTabButton.TextSize = 13
            SubTabButton.AutoButtonColor = false
            SubTabButton.Parent = SubTabBar
            CreateRound(SubTabButton, 6)
            
            -- SubTab Content (scrollable)
            local SubTabContent = Instance.new("ScrollingFrame")
            SubTabContent.Name = subTabName .. "Content"
            SubTabContent.Size = UDim2.new(1, 0, 1, 0)
            SubTabContent.BackgroundTransparency = 1
            SubTabContent.BorderSizePixel = 0
            SubTabContent.ScrollBarThickness = 4
            SubTabContent.ScrollBarImageColor3 = Colors.Accent
            SubTabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            SubTabContent.Visible = false
            SubTabContent.Parent = SubTabContainer
            
            local SubTabLayout = Instance.new("UIListLayout")
            SubTabLayout.Padding = UDim.new(0, 10)
            SubTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SubTabLayout.Parent = SubTabContent
            
            SubTabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SubTabContent.CanvasSize = UDim2.new(0, 0, 0, SubTabLayout.AbsoluteContentSize.Y + 10)
            end)
            
            SubTab.SubTabButton = SubTabButton
            SubTab.SubTabContent = SubTabContent
            
            -- SubTab switching
            SubTabButton.MouseButton1Click:Connect(function()
                for _, subTab in pairs(Tab.SubTabs) do
                    subTab.SubTabContent.Visible = false
                    Tween(subTab.SubTabButton, {BackgroundColor3 = Colors.Tertiary, TextColor3 = Colors.TextDark})
                end
                
                SubTabContent.Visible = true
                Tween(SubTabButton, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text})
                Tab.CurrentSubTab = SubTab
            end)
            
            -- Activate first subtab
            if #Tab.SubTabs == 0 then
                SubTabButton.BackgroundColor3 = Colors.Accent
                SubTabButton.TextColor3 = Colors.Text
                SubTabContent.Visible = true
                Tab.CurrentSubTab = SubTab
            end
            
            table.insert(Tab.SubTabs, SubTab)
            
            -- Add Toggle
            function SubTab:AddToggle(config)
                config = config or {}
                local toggleName = config.Name or "Toggle"
                local toggleDefault = config.Default or false
                local toggleCallback = config.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = toggleName
                ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
                ToggleFrame.BackgroundColor3 = Colors.Tertiary
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = SubTabContent
                CreateRound(ToggleFrame, 8)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Colors.Text
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 45, 0, 22)
                ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
                ToggleButton.BackgroundColor3 = toggleDefault and Colors.Toggle or Colors.Border
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false
                ToggleButton.Parent = ToggleFrame
                CreateRound(ToggleButton, 11)
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
                ToggleCircle.Position = toggleDefault and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleButton
                CreateRound(ToggleCircle, 9)
                
                local toggled = toggleDefault
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    Tween(ToggleButton, {BackgroundColor3 = toggled and Colors.Toggle or Colors.Border})
                    Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
                    
                    pcall(toggleCallback, toggled)
                end)
                
                return {
                    Set = function(value)
                        toggled = value
                        ToggleButton.BackgroundColor3 = toggled and Colors.Toggle or Colors.Border
                        ToggleCircle.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                    end
                }
            end
            
            -- Add Slider
            function SubTab:AddSlider(config)
                config = config or {}
                local sliderName = config.Name or "Slider"
                local sliderMin = config.Min or 0
                local sliderMax = config.Max or 100
                local sliderDefault = config.Default or 50
                local sliderCallback = config.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = sliderName
                SliderFrame.Size = UDim2.new(1, 0, 0, 60)
                SliderFrame.BackgroundColor3 = Colors.Tertiary
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = SubTabContent
                CreateRound(SliderFrame, 8)
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -100, 0, 25)
                SliderLabel.Position = UDim2.new(0, 15, 0, 8)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Colors.Text
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 70, 0, 25)
                SliderValue.Position = UDim2.new(1, -85, 0, 8)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(sliderDefault)
                SliderValue.TextColor3 = Colors.Accent
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -30, 0, 6)
                SliderBar.Position = UDim2.new(0, 15, 1, -20)
                SliderBar.BackgroundColor3 = Colors.Border
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                CreateRound(SliderBar, 3)
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
                SliderFill.BackgroundColor3 = Colors.Slider
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                CreateRound(SliderFill, 3)
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
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
                        Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                        
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
            
            -- Add Dropdown
            function SubTab:AddDropdown(config)
                config = config or {}
                local dropdownName = config.Name or "Dropdown"
                local dropdownOptions = config.Options or {"Option 1", "Option 2"}
                local dropdownDefault = config.Default or dropdownOptions[1]
                local dropdownCallback = config.Callback or function() end
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = dropdownName
                DropdownFrame.Size = UDim2.new(1, 0, 0, 45)
                DropdownFrame.BackgroundColor3 = Colors.Tertiary
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Parent = SubTabContent
                CreateRound(DropdownFrame, 8)
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(0, 250, 1, 0)
                DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = dropdownName
                DropdownLabel.TextColor3 = Colors.Text
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(0, 180, 0, 30)
                DropdownButton.Position = UDim2.new(1, -190, 0.5, -15)
                DropdownButton.BackgroundColor3 = Colors.Border
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
                DropdownIcon.Size = UDim2.new(0, 25, 1, 0)
                DropdownIcon.Position = UDim2.new(1, -25, 0, 0)
                DropdownIcon.BackgroundTransparency = 1
                DropdownIcon.Text = "▼"
                DropdownIcon.TextColor3 = Colors.TextDark
                DropdownIcon.Font = Enum.Font.GothamBold
                DropdownIcon.TextSize = 11
                DropdownIcon.Parent = DropdownButton
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Size = UDim2.new(0, 180, 0, 0)
                DropdownList.Position = UDim2.new(1, -190, 1, 5)
                DropdownList.BackgroundColor3 = Colors.Secondary
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
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.BackgroundColor3 = Colors.Secondary
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
                        Tween(OptionButton, {BackgroundColor3 = Colors.Tertiary})
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Colors.Secondary})
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = "  " .. option
                        DropdownList.Visible = false
                        Tween(DropdownIcon, {Rotation = 0}, 0.2)
                        pcall(dropdownCallback, option)
                    end)
                end
                
                DropdownList.Size = UDim2.new(0, 180, 0, DropdownListLayout.AbsoluteContentSize.Y + 10)
                
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
            
            -- Add Button
            function SubTab:AddButton(config)
                config = config or {}
                local buttonName = config.Name or "Button"
                local buttonCallback = config.Callback or function() end
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Name = buttonName
                ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
                ButtonFrame.BackgroundColor3 = Colors.Accent
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Text = buttonName
                ButtonFrame.TextColor3 = Colors.Text
                ButtonFrame.Font = Enum.Font.GothamBold
                ButtonFrame.TextSize = 14
                ButtonFrame.AutoButtonColor = false
                ButtonFrame.Parent = SubTabContent
                CreateRound(ButtonFrame, 8)
                
                ButtonFrame.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(255, 90, 105)})
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Colors.Accent})
                end)
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(200, 50, 65)}, 0.1).Completed:Connect(function()
                        Tween(ButtonFrame, {BackgroundColor3 = Colors.Accent}, 0.1)
                    end)
                    pcall(buttonCallback)
                end)
            end
            
            -- Add Textbox
            function SubTab:AddTextbox(config)
                config = config or {}
                local textboxName = config.Name or "Textbox"
                local textboxPlaceholder = config.Placeholder or "Enter text..."
                local textboxCallback = config.Callback or function() end
                
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Name = textboxName
                TextboxFrame.Size = UDim2.new(1, 0, 0, 45)
                TextboxFrame.BackgroundColor3 = Colors.Tertiary
                TextboxFrame.BorderSizePixel = 0
                TextboxFrame.Parent = SubTabContent
                CreateRound(TextboxFrame, 8)
                
                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Size = UDim2.new(0, 250, 1, 0)
                TextboxLabel.Position = UDim2.new(0, 15, 0, 0)
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Text = textboxName
                TextboxLabel.TextColor3 = Colors.Text
                TextboxLabel.Font = Enum.Font.Gotham
                TextboxLabel.TextSize = 14
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Parent = TextboxFrame
                
                local Textbox = Instance.new("TextBox")
                Textbox.Size = UDim2.new(0, 220, 0, 30)
                Textbox.Position = UDim2.new(1, -230, 0.5, -15)
                Textbox.BackgroundColor3 = Colors.Border
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
                TextboxPadding.PaddingLeft = UDim.new(0, 10)
                TextboxPadding.PaddingRight = UDim.new(0, 10)
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
            
            -- Add Colorpicker
            function SubTab:AddColorpicker(config)
                config = config or {}
                local colorpickerName = config.Name or "Colorpicker"
                local colorpickerDefault = config.Default or Color3.fromRGB(255, 0, 0)
                local colorpickerCallback = config.Callback or function() end
                
                local ColorpickerFrame = Instance.new("Frame")
                ColorpickerFrame.Name = colorpickerName
                ColorpickerFrame.Size = UDim2.new(1, 0, 0, 45)
                ColorpickerFrame.BackgroundColor3 = Colors.Tertiary
                ColorpickerFrame.BorderSizePixel = 0
                ColorpickerFrame.Parent = SubTabContent
                CreateRound(ColorpickerFrame, 8)
                
                local ColorpickerLabel = Instance.new("TextLabel")
                ColorpickerLabel.Size = UDim2.new(1, -70, 1, 0)
                ColorpickerLabel.Position = UDim2.new(0, 15, 0, 0)
                ColorpickerLabel.BackgroundTransparency = 1
                ColorpickerLabel.Text = colorpickerName
                ColorpickerLabel.TextColor3 = Colors.Text
                ColorpickerLabel.Font = Enum.Font.Gotham
                ColorpickerLabel.TextSize = 14
                ColorpickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorpickerLabel.Parent = ColorpickerFrame
                
                local ColorDisplay = Instance.new("TextButton")
                ColorDisplay.Size = UDim2.new(0, 40, 0, 25)
                ColorDisplay.Position = UDim2.new(1, -50, 0.5, -12.5)
                ColorDisplay.BackgroundColor3 = colorpickerDefault
                ColorDisplay.BorderSizePixel = 0
                ColorDisplay.Text = ""
                ColorDisplay.AutoButtonColor = false
                ColorDisplay.Parent = ColorpickerFrame
                CreateRound(ColorDisplay, 6)
                CreateStroke(ColorDisplay, Colors.Border, 2)
                
                -- Color picker window
                local ColorWindow = Instance.new("Frame")
                ColorWindow.Size = UDim2.new(0, 220, 0, 180)
                ColorWindow.Position = UDim2.new(1, -230, 1, 5)
                ColorWindow.BackgroundColor3 = Colors.Secondary
                ColorWindow.BorderSizePixel = 0
                ColorWindow.Visible = false
                ColorWindow.ZIndex = 15
                ColorWindow.Parent = ColorpickerFrame
                CreateRound(ColorWindow, 8)
                CreateStroke(ColorWindow, Colors.Border, 1)
                
                local hue, sat, val = colorpickerDefault:ToHSV()
                local currentColor = colorpickerDefault
                
                -- Saturation/Value picker
                local SVPicker = Instance.new("TextButton")
                SVPicker.Size = UDim2.new(1, -50, 1, -50)
                SVPicker.Position = UDim2.new(0, 10, 0, 10)
                SVPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                SVPicker.BorderSizePixel = 0
                SVPicker.Text = ""
                SVPicker.AutoButtonColor = false
                SVPicker.ZIndex = 16
                SVPicker.Parent = ColorWindow
                CreateRound(SVPicker, 6)
                
                local SVOverlay1 = Instance.new("ImageLabel")
                SVOverlay1.Size = UDim2.new(1, 0, 1, 0)
                SVOverlay1.BackgroundTransparency = 1
                SVOverlay1.Image = "rbxassetid://4155801252"
                SVOverlay1.ZIndex = 17
                SVOverlay1.Parent = SVPicker
                CreateRound(SVOverlay1, 6)
                
                local SVOverlay2 = Instance.new("ImageLabel")
                SVOverlay2.Size = UDim2.new(1, 0, 1, 0)
                SVOverlay2.BackgroundTransparency = 1
                SVOverlay2.Image = "rbxassetid://4155801252"
                SVOverlay2.Rotation = 90
                SVOverlay2.ZIndex = 17
                SVOverlay2.Parent = SVPicker
                CreateRound(SVOverlay2, 6)
                
                -- Hue slider
                local HueSlider = Instance.new("TextButton")
                HueSlider.Size = UDim2.new(0, 20, 1, -50)
                HueSlider.Position = UDim2.new(1, -28, 0, 10)
                HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueSlider.BorderSizePixel = 0
                HueSlider.Text = ""
                HueSlider.AutoButtonColor = false
                HueSlider.ZIndex = 16
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
                RGBDisplay.TextSize = 12
                RGBDisplay.ZIndex = 16
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
            
            -- Add Keybind
            function SubTab:AddKeybind(config)
                config = config or {}
                local keybindName = config.Name or "Keybind"
                local keybindDefault = config.Default or Enum.KeyCode.F
                local keybindCallback = config.Callback or function() end
                
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Name = keybindName
                KeybindFrame.Size = UDim2.new(1, 0, 0, 45)
                KeybindFrame.BackgroundColor3 = Colors.Tertiary
                KeybindFrame.BorderSizePixel = 0
                KeybindFrame.Parent = SubTabContent
                CreateRound(KeybindFrame, 8)
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Size = UDim2.new(1, -120, 1, 0)
                KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Text = keybindName
                KeybindLabel.TextColor3 = Colors.Text
                KeybindLabel.Font = Enum.Font.Gotham
                KeybindLabel.TextSize = 14
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = KeybindFrame
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Size = UDim2.new(0, 90, 0, 30)
                KeybindButton.Position = UDim2.new(1, -100, 0.5, -15)
                KeybindButton.BackgroundColor3 = Colors.Border
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Text = keybindDefault.Name
                KeybindButton.TextColor3 = Colors.Text
                KeybindButton.Font = Enum.Font.GothamBold
                KeybindButton.TextSize = 13
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
            
            -- Add Label
            function SubTab:AddLabel(text)
                text = text or "Label"
                
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Size = UDim2.new(1, 0, 0, 35)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Parent = SubTabContent
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -30, 1, 0)
                Label.Position = UDim2.new(0, 15, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
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
            
            return SubTab
        end
        
        return Tab
    end
    
    return Window
end

return Library
