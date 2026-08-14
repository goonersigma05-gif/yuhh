-- Winhvh Custom UI Library
-- Modern dark theme UI with tabs, toggles, sliders, dropdowns

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

-- Colors
local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(28, 28, 35),
    Accent = Color3.fromRGB(255, 70, 85),
    Text = Color3.fromRGB(245, 245, 245),
    TextDark = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(40, 40, 50),
    Toggle = Color3.fromRGB(255, 70, 85),
    Slider = Color3.fromRGB(255, 70, 85),
}

-- Utility functions
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

-- Main Window
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Winhvh"
    local windowSubtitle = config.Subtitle or "Custom UI"
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WinhvhUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
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
    
    -- Top bar stats
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, -20, 0, 40)
    TopBar.Position = UDim2.new(0, 10, 0, 10)
    TopBar.BackgroundColor3 = Colors.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainContainer
    CreateRound(TopBar, 8)
    
    -- Stats display
    local stats = {"PAST OWL", "GREEN SCREEN", "835FPS", "119PING", "4:20PM"}
    for i, stat in ipairs(stats) do
        local StatLabel = Instance.new("TextLabel")
        StatLabel.Size = UDim2.new(0, 100, 1, 0)
        StatLabel.Position = UDim2.new(0, (i-1) * 110 + 20, 0, 0)
        StatLabel.BackgroundTransparency = 1
        StatLabel.Text = stat
        StatLabel.TextColor3 = Colors.Text
        StatLabel.Font = Enum.Font.GothamMedium
        StatLabel.TextSize = 12
        StatLabel.Parent = TopBar
    end
    
    -- Sidebar (tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 70, 1, -70)
    Sidebar.Position = UDim2.new(0, 10, 0, 60)
    Sidebar.BackgroundColor3 = Colors.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainContainer
    CreateRound(Sidebar, 8)
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 8)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarList.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.Parent = Sidebar
    
    -- Content area
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -100, 1, -70)
    ContentContainer.Position = UDim2.new(0, 90, 0, 60)
    ContentContainer.BackgroundColor3 = Colors.Secondary
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainContainer
    CreateRound(ContentContainer, 8)
    
    -- Tab storage
    local Tabs = {}
    local CurrentTab = nil
    
    local Window = {}
    
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "rbxassetid://7733964640"
        
        -- Tab button in sidebar
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(0, 50, 0, 50)
        TabButton.BackgroundColor3 = Colors.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar
        CreateRound(TabButton, 8)
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = Colors.TextDark
        TabIcon.Parent = TabButton
        
        -- Tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -30, 1, -30)
        TabContent.Position = UDim2.new(0, 15, 0, 15)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Colors.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabList = Instance.new("UIListLayout")
        TabList.Padding = UDim.new(0, 10)
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Parent = TabContent
        
        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                Tween(tab.Icon, {ImageColor3 = Colors.TextDark})
                tab.Button.BackgroundColor3 = Colors.Background
            end
            
            TabContent.Visible = true
            Tween(TabIcon, {ImageColor3 = Colors.Accent})
            TabButton.BackgroundColor3 = Colors.Border
            CurrentTab = TabContent
        end)
        
        -- Store tab
        Tabs[tabName] = {
            Button = TabButton,
            Icon = TabIcon,
            Content = TabContent
        }
        
        -- Activate first tab
        if not CurrentTab then
            TabButton.BackgroundColor3 = Colors.Border
            TabIcon.ImageColor3 = Colors.Accent
            TabContent.Visible = true
            CurrentTab = TabContent
        end
        
        local Tab = {}
        
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.Size = UDim2.new(1, 0, 0, 40)
            Section.BackgroundTransparency = 1
            Section.Parent = TabContent
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, 0, 1, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Colors.Text
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.Parent = Section
            
            return Section
        end
        
        function Tab:AddToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local toggleDefault = config.Default or false
            local toggleCallback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleName
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Colors.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            CreateRound(ToggleFrame, 8)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = toggleDefault and Colors.Toggle or Colors.Border
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
                
                Tween(ToggleButton, {BackgroundColor3 = toggled and Colors.Toggle or Colors.Border})
                Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                
                pcall(toggleCallback, toggled)
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    ToggleButton.BackgroundColor3 = toggled and Colors.Toggle or Colors.Border
                    ToggleCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                end
            }
        end
        
        function Tab:AddSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local sliderMin = config.Min or 0
            local sliderMax = config.Max or 100
            local sliderDefault = config.Default or 50
            local sliderCallback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = sliderName
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Colors.Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            CreateRound(SliderFrame, 8)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -100, 0, 20)
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderName
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Position = UDim2.new(1, -75, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(sliderDefault)
            SliderValue.TextColor3 = Colors.Accent
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 4)
            SliderBar.Position = UDim2.new(0, 15, 1, -15)
            SliderBar.BackgroundColor3 = Colors.Border
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
        
        function Tab:AddDropdown(config)
            config = config or {}
            local dropdownName = config.Name or "Dropdown"
            local dropdownOptions = config.Options or {"Option 1", "Option 2"}
            local dropdownDefault = config.Default or dropdownOptions[1]
            local dropdownCallback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = dropdownName
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Colors.Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            CreateRound(DropdownFrame, 8)
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0, 200, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownName
            DropdownLabel.TextColor3 = Colors.Text
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 150, 0, 28)
            DropdownButton.Position = UDim2.new(1, -165, 0.5, -14)
            DropdownButton.BackgroundColor3 = Colors.Border
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = dropdownDefault
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 12
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
            DropdownList.Size = UDim2.new(0, 150, 0, 0)
            DropdownList.Position = UDim2.new(1, -165, 1, 5)
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
            DropdownListPadding.PaddingTop = UDim.new(0, 4)
            DropdownListPadding.PaddingBottom = UDim.new(0, 4)
            DropdownListPadding.Parent = DropdownList
            
            for _, option in ipairs(dropdownOptions) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 28)
                OptionButton.BackgroundColor3 = Colors.Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Colors.Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 12
                OptionButton.AutoButtonColor = false
                OptionButton.ZIndex = 11
                OptionButton.Parent = DropdownList
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Colors.Background})
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Colors.Secondary})
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    DropdownList.Visible = false
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    pcall(dropdownCallback, option)
                end)
            end
            
            DropdownList.Size = UDim2.new(0, 150, 0, DropdownListLayout.AbsoluteContentSize.Y + 8)
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
                Tween(DropdownIcon, {Rotation = DropdownList.Visible and 180 or 0}, 0.2)
            end)
            
            return {
                Set = function(value)
                    DropdownButton.Text = value
                end
            }
        end
        
        function Tab:AddButton(config)
            config = config or {}
            local buttonName = config.Name or "Button"
            local buttonCallback = config.Callback or function() end
            
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
            ButtonFrame.Parent = TabContent
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
        
        function Tab:AddTextbox(config)
            config = config or {}
            local textboxName = config.Name or "Textbox"
            local textboxPlaceholder = config.Placeholder or "Enter text..."
            local textboxCallback = config.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = textboxName
            TextboxFrame.Size = UDim2.new(1, 0, 0, 40)
            TextboxFrame.BackgroundColor3 = Colors.Background
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            CreateRound(TextboxFrame, 8)
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(0, 200, 1, 0)
            TextboxLabel.Position = UDim2.new(0, 15, 0, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxName
            TextboxLabel.TextColor3 = Colors.Text
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(0, 200, 0, 28)
            Textbox.Position = UDim2.new(1, -215, 0.5, -14)
            Textbox.BackgroundColor3 = Colors.Border
            Textbox.BorderSizePixel = 0
            Textbox.Text = ""
            Textbox.PlaceholderText = textboxPlaceholder
            Textbox.TextColor3 = Colors.Text
            Textbox.PlaceholderColor3 = Colors.TextDark
            Textbox.Font = Enum.Font.Gotham
            Textbox.TextSize = 12
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
        
        return Tab
    end
    
    return Window
end

return Library
