--[[
    Example Script using Misery UI Library
    Keeping Settings Tab functionality
]]--

-- LPH Macro Fallbacks
if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(f) return f end
    LPH_JIT_MAX = function(f) return f end
end

-- Adonis Bypass
local g = getinfo or debug.getinfo
local d = false
local h = {}
local x, y

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
    
        if typeof(a) == "function" and not x then
            x = a
            
            local o; o = hookfunction(x, function(c, f, n)
                if c ~= "_" then
                    if d then
                        warn(`Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}`)
                    end
                end
                
                return true
            end)
            table.insert(h, x)
        end
        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            local o; o = hookfunction(y, function(f)
                if d then
                    warn(`Adonis AntiCheat tried to kill (fallback): {f}`)
                end
            end)
            table.insert(h, y)
        end
    end
end

local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...
    if x and a == x then
        if d then
            warn(`zins | adonis bypassed`)
        end
        return coroutine.yield(coroutine.running())
    end
    
    return o(...)
end))

setthreadidentity(7)

local MainColor = Color3.fromRGB(100, 180, 255)
local req = (syn and syn.request or request)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ContextAction = game:GetService("ContextActionService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Variables
local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local Camera = Workspace.CurrentCamera
local angle_Y = 0
local lastFireTime = 0
local StompActive = false
local OriginalPosition = nil
local KillbotWasEnabled = false

-- World Changer Variables
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogColor = Lighting.FogColor,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
}
local AtmosphereInstance = nil
local SkyboxInstances = {}
local BlurEffect = nil
local SunRaysEffect = nil

-- Skybox Assets
local Skyboxes = {
    ["Default"] = nil,
    ["Nebula"] = {
        SkyboxBk = "rbxassetid://159454299",
        SkyboxDn = "rbxassetid://159454296",
        SkyboxFt = "rbxassetid://159454293",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxRt = "rbxassetid://159454300",
        SkyboxUp = "rbxassetid://159454288",
    },
    ["Vaporwave"] = {
        SkyboxBk = "rbxassetid://570557620",
        SkyboxDn = "rbxassetid://570557514",
        SkyboxFt = "rbxassetid://570557559",
        SkyboxLf = "rbxassetid://570557620",
        SkyboxRt = "rbxassetid://570557559",
        SkyboxUp = "rbxassetid://570557372",
    },
    ["Purple Nebula"] = {
        SkyboxBk = "rbxassetid://570557620",
        SkyboxDn = "rbxassetid://570557514",
        SkyboxFt = "rbxassetid://570557559",
        SkyboxLf = "rbxassetid://570557620",
        SkyboxRt = "rbxassetid://570557559",
        SkyboxUp = "rbxassetid://570557372",
    },
    ["Pink Daylight"] = {
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxUp = "rbxassetid://271077958",
    },
    ["Morning Glow"] = {
        SkyboxBk = "rbxassetid://1417494030",
        SkyboxDn = "rbxassetid://1417494146",
        SkyboxFt = "rbxassetid://1417494253",
        SkyboxLf = "rbxassetid://1417494402",
        SkyboxRt = "rbxassetid://1417494499",
        SkyboxUp = "rbxassetid://1417494643",
    },
    ["Setting Sun"] = {
        SkyboxBk = "rbxassetid://626460377",
        SkyboxDn = "rbxassetid://626460216",
        SkyboxFt = "rbxassetid://626460513",
        SkyboxLf = "rbxassetid://626473032",
        SkyboxRt = "rbxassetid://626458639",
        SkyboxUp = "rbxassetid://626460625",
    },
    ["Fade Blue"] = {
        SkyboxBk = "rbxassetid://153695414",
        SkyboxDn = "rbxassetid://153695352",
        SkyboxFt = "rbxassetid://153695452",
        SkyboxLf = "rbxassetid://153695320",
        SkyboxRt = "rbxassetid://153695383",
        SkyboxUp = "rbxassetid://153695471",
    },
    ["Elegant Morning"] = {
        SkyboxBk = "rbxassetid://153767241",
        SkyboxDn = "rbxassetid://153767216",
        SkyboxFt = "rbxassetid://153767266",
        SkyboxLf = "rbxassetid://153767200",
        SkyboxRt = "rbxassetid://153767231",
        SkyboxUp = "rbxassetid://153767288",
    },
    ["Neptune"] = {
        SkyboxBk = "rbxassetid://218955819",
        SkyboxDn = "rbxassetid://218953419",
        SkyboxFt = "rbxassetid://218954524",
        SkyboxLf = "rbxassetid://218958493",
        SkyboxRt = "rbxassetid://218957134",
        SkyboxUp = "rbxassetid://218950090",
    },
    ["Redshift"] = {
        SkyboxBk = "rbxassetid://401664839",
        SkyboxDn = "rbxassetid://401664862",
        SkyboxFt = "rbxassetid://401664960",
        SkyboxLf = "rbxassetid://401664881",
        SkyboxRt = "rbxassetid://401664901",
        SkyboxUp = "rbxassetid://401664936",
    },
}

-- Find all possible remote events
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = {
    ReplicatedStorage:FindFirstChild("MainEvent"),
    ReplicatedStorage:FindFirstChild("MainGameEvent"),
    ReplicatedStorage:FindFirstChild("MainRemoteEvent"),
}

-- Also check GameRemotes folder
local GameRemotes = ReplicatedStorage:FindFirstChild("GameRemotes")
if GameRemotes then
    table.insert(RemoteEvents, GameRemotes:FindFirstChild("MainEvent"))
    table.insert(RemoteEvents, GameRemotes:FindFirstChild("MainGameEvent"))
    table.insert(RemoteEvents, GameRemotes:FindFirstChild("MainRemoteEvent"))
end

-- Target Variable
local Target = nil
local Locked = false
local LastHealth = {}

-- Self-Aura System (from juju.txt)
local CurrentAura = "None"
local AuraInstances = {}
local SelfAuraEnabled = false
local SelfAuraColor = MainColor

-- Material System
local MaterialEnabled = false
local MaterialType = "ForceField"
local MaterialColor = MainColor
local OriginalMaterials = {}

-- Tool Material System
local ToolMaterialEnabled = false
local ToolMaterialType = "Neon"
local ToolMaterialColor = MainColor
local OriginalToolMaterials = {}

local particle_auras = {
    ["starlight"] = "rbxassetid://134645216613107",
    ["heavenly"] = "rbxassetid://139300897520961",
    ["ribbon"] = "rbxassetid://132069507632161",
    ["sakura"] = "rbxassetid://81755778619404",
    ["angel"] = "rbxassetid://97658130917593",
    ["wind"] = "rbxassetid://80694081850877",
    ["flow"] = "rbxassetid://119913533725648",
    ["star"] = "rbxassetid://73754563740680",
}

local function removeSelfAura()
    for _, instance in pairs(AuraInstances) do
        if instance and instance.Parent then
            instance:Destroy()
        end
    end
    AuraInstances = {}
end

local function applySelfAura(character, auraType)
    if not character or not SelfAuraEnabled then return end
    
    -- Clean up old aura
    removeSelfAura()
    
    if auraType == "None" then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Get aura asset ID
    local auraLower = string.lower(auraType)
    local assetId = particle_auras[auraLower]
    
    if not assetId then return end
    
    -- Load aura model from asset
    local success, auraModel = pcall(function()
        return game:GetObjects(assetId)[1]
    end)
    
    if success and auraModel then
        -- Parent to character
        auraModel.Parent = character
        table.insert(AuraInstances, auraModel)
        
        -- Find all attachments and parent them to HumanoidRootPart
        for _, child in pairs(auraModel:GetDescendants()) do
            if child:IsA("Attachment") then
                child.Parent = rootPart
                table.insert(AuraInstances, child)
            elseif child:IsA("ParticleEmitter") then
                -- Apply color to particles
                child.Color = ColorSequence.new(SelfAuraColor)
                table.insert(AuraInstances, child)
            elseif child:IsA("Beam") or child:IsA("Trail") then
                -- Apply color to beams/trails
                if child:IsA("Beam") then
                    child.Color = ColorSequence.new(SelfAuraColor)
                elseif child:IsA("Trail") then
                    child.Color = ColorSequence.new(SelfAuraColor)
                end
                table.insert(AuraInstances, child)
            end
        end
    end
end

local function restoreCharacterMaterial()
    local char = Client.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and OriginalMaterials[part] then
            part.Material = OriginalMaterials[part].Material
            part.Color = OriginalMaterials[part].Color
        end
    end
end

local function applyCharacterMaterial()
    local char = Client.Character
    if not char or not MaterialEnabled then return end
    
    -- Store original materials if not stored yet
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and not OriginalMaterials[part] then
            OriginalMaterials[part] = {
                Material = part.Material,
                Color = part.Color
            }
        end
    end
    
    -- Apply new material
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material[MaterialType]
            part.Color = MaterialColor
        end
    end
end

local function restoreToolMaterial()
    local char = Client.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and OriginalToolMaterials[part] then
            part.Material = OriginalToolMaterials[part].Material
            part.Color = OriginalToolMaterials[part].Color
        end
    end
end

local function applyToolMaterial()
    local char = Client.Character
    if not char or not ToolMaterialEnabled then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Store original materials if not stored yet
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and not OriginalToolMaterials[part] then
            OriginalToolMaterials[part] = {
                Material = part.Material,
                Color = part.Color
            }
        end
    end
    
    -- Apply new material
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material[ToolMaterialType]
            part.Color = ToolMaterialColor
        end
    end
end

-- Settings Table
local Settings = {
    ['Ragebot'] = {
        Enabled = false,
        Keybind = nil,
        Prediction = {
            Enabled = false,
            Amount = 0.165,
        },
        TargetPart = "HumanoidRootPart",
        Smoothness = {
            Enabled = false,
            Amount = 0,
        },
        HitNotifications = false,
        FaceTarget = false,
        Spectate = false,
        AutoStomp = false,
        Manipulation = {
            Enabled = false,
            CheckFireFunction = false,
            FireRate = 0.1,
            Cooldown = 0.5,
        },
    },
    ['Killbot'] = {
        Enabled = false,
        Method = "Orbit",
        Speed = 1,
        Height = 0,
        Range = 9,
        AutoFire = false,
        Cooldown = 0.1,
        FireRate = 0.05,
        AutoEquip = {
            Enabled = false,
            Tool = "[Double-Barrel SG]",
        },
    },
    ['Visuals'] = {
        Snapline = {
            Enabled = false,
            Color = MainColor,
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Position = "Character",
            Thickness = 1.5,
        },
        HitVisualizers = {
            HitSound = false,
            SelectedSound = "Bubble",
            SoundVolume = 0.5,
            HitEffect = false,
            EffectType = "Dimensional Rift",
            EffectColor = MainColor,
            EffectLifetime = 2,
            HitMarkers = {
                Enabled = false,
                MainColor = Color3.fromRGB(255, 255, 255),
                OutlineColor = Color3.fromRGB(0, 0, 0),
                MainThickness = 3,
                OutlineThickness = 1,
            },
        },
        WorldChanger = {
            Enabled = false,
            Atmosphere = {
                Enabled = false,
                Color = Color3.fromRGB(199, 199, 199),
            },
            Fog = {
                Enabled = false,
                Color = Color3.fromRGB(192, 192, 192),
                Start = 0,
                End = 100000,
            },
            ClockTime = {
                Enabled = false,
                Time = 14,
            },
            Skybox = {
                Enabled = false,
                Selected = "Default",
            },
            Glare = 0,
            SunRays = 0,
            Blur = 0,
        },
    },
    ['Configs'] = {
        Menu = {
            Keybind = Enum.KeyCode.Insert,
        },
        Notifications = {
            Type = "Library", -- Library or Custom
            FeatureNotifications = false,
        },
    },
}

-- 3D Circle System (from juju.txt)
local circle3DState = {
    enabled = false,
    color1 = Color3.fromRGB(255, 255, 255),
    color2 = Color3.fromRGB(0, 170, 255),
    rotation = 0,
    segments = 32,
    radius = 50
}

local circle3DLines = {}

local function createCircle3D()
    -- Clean up old lines
    for _, line in pairs(circle3DLines) do
        if line then
            line:Remove()
        end
    end
    circle3DLines = {}
    
    -- Create new lines for each segment
    for i = 1, circle3DState.segments do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Transparency = 1
        line.Color = Color3.new(1, 1, 1)
        line.Visible = false
        table.insert(circle3DLines, line)
    end
end

local updateCircle3D = LPH_JIT_MAX(function(dt)
    if not circle3DState.enabled then return end
    
    -- Update rotation
    circle3DState.rotation = circle3DState.rotation + (dt * 2)
    if circle3DState.rotation > math.pi * 2 then
        circle3DState.rotation = circle3DState.rotation - (math.pi * 2)
    end
end)

local renderCircle3D = LPH_NO_VIRTUALIZE(function()
    if not circle3DState.enabled then
        for _, line in pairs(circle3DLines) do
            line.Visible = false
        end
        return
    end
    
    -- Only show circle on locked target
    if not Locked or not Target or not Target.Character then
        for _, line in pairs(circle3DLines) do
            line.Visible = false
        end
        return
    end
    
    local rootPart = Target.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        for _, line in pairs(circle3DLines) do
            line.Visible = false
        end
        return
    end
    
    -- Position circle at torso height (HumanoidRootPart position)
    local center = rootPart.Position
    local torsoHeight = center.Y -- Use HumanoidRootPart's Y position directly
    
    local worldRadius = circle3DState.radius / 10
    
    -- Draw circle segments with gap/slit - HORIZONTAL plane (Y stays at torso)
    for i = 1, circle3DState.segments do
        -- Create a gap (skip drawing segments 1-4 for a visible slit)
        if i >= 1 and i <= 4 then
            if circle3DLines[i] then
                circle3DLines[i].Visible = false
            end
        else
            local angle1 = (i / circle3DState.segments) * math.pi * 2 + circle3DState.rotation
            local angle2 = ((i + 1) / circle3DState.segments) * math.pi * 2 + circle3DState.rotation
            
            -- Calculate 3D positions at torso level
            local pos1 = Vector3.new(
                center.X + math.cos(angle1) * worldRadius,
                torsoHeight, -- Use torso Y directly
                center.Z + math.sin(angle1) * worldRadius
            )
            
            local pos2 = Vector3.new(
                center.X + math.cos(angle2) * worldRadius,
                torsoHeight, -- Use torso Y directly
                center.Z + math.sin(angle2) * worldRadius
            )
            
            -- Convert to screen space
            local screen1, onScreen1 = Camera:WorldToViewportPoint(pos1)
            local screen2, onScreen2 = Camera:WorldToViewportPoint(pos2)
            
            -- Only render if both points are visible
            if onScreen1 and onScreen2 then
                local line = circle3DLines[i]
                if line then
                    line.From = Vector2.new(screen1.X, screen1.Y)
                    line.To = Vector2.new(screen2.X, screen2.Y)
                    
                    -- Gradient color based on segment position
                    local t = i / circle3DState.segments
                    line.Color = circle3DState.color1:Lerp(circle3DState.color2, t)
                    line.Visible = true
                end
            else
                if circle3DLines[i] then
                    circle3DLines[i].Visible = false
                end
            end
        end
    end
end)


-- Load Misery UI (custom version with glow+rounded corners)
local Menu = loadstring(req({Url = "https://raw.githubusercontent.com/goonersigma05-gif/yuhh/refs/heads/main/ui.cc", Method = "Get"}).Body)()

-- Set custom accent color
Menu.Accent = Color3.fromHex("#9472FF")

-- Custom Notification System
local CustomNotifications = {}
local NotificationContainer = Instance.new("ScreenGui")
NotificationContainer.Name = "CustomNotifications"
NotificationContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationContainer.ResetOnSpawn = false
if gethui then
    NotificationContainer.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(NotificationContainer)
    NotificationContainer.Parent = game:GetService("CoreGui")
else
    NotificationContainer.Parent = game:GetService("CoreGui")
end

local function CustomNotify(message, duration)
    local duration = duration or 3
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 220, 0, 40) -- Reduced width from 300 to 220
    NotifFrame.Position = UDim2.new(0.5, -110, 1, 100) -- Adjusted center offset
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ClipsDescendants = false
    NotifFrame.Parent = NotificationContainer
    
    -- NO UICorner - sharp edges like the image
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1
    Stroke.Parent = NotifFrame
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -20, 1, -10)
    TextLabel.Position = UDim2.new(0, 10, 0, 5)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = message
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel.RichText = true
    TextLabel.Parent = NotifFrame
    
    -- Accent Line at bottom (under text) - thin 1px
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 1)
    AccentLine.Position = UDim2.new(0, 0, 1, -1)
    AccentLine.BackgroundColor3 = Menu.Accent
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = NotifFrame
    
    table.insert(CustomNotifications, NotifFrame)
    
    -- Calculate Y position based on notification count (stack upwards from bottom)
    local yOffset = -60 - ((#CustomNotifications - 1) * 50)
    
    -- Slide up from bottom
    TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -110, 1, yOffset) -- Adjusted center offset
    }):Play()
    
    -- Wait then slide out with accent line animation
    task.delay(duration, function()
        -- Animate accent line sliding left
        TweenService:Create(AccentLine, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(-1, 0, 1, -1)
        }):Play()
        
        -- Slide notification down off screen
        local slideOut = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -110, 1, 100) -- Adjusted center offset
        })
        slideOut:Play()
        slideOut.Completed:Connect(function()
            for i, notif in ipairs(CustomNotifications) do
                if notif == NotifFrame then
                    table.remove(CustomNotifications, i)
                    break
                end
            end
            NotifFrame:Destroy()
            
            -- Reposition remaining notifications
            for i, notif in ipairs(CustomNotifications) do
                local newY = -60 - ((i - 1) * 50)
                TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, -110, 1, newY) -- Adjusted center offset
                }):Play()
            end
        end)
    end)
end

-- Notification Wrapper
local function Notify(message, duration)
    if Settings.Configs.Notifications.Type == "Custom" then
        CustomNotify(message, duration)
    else
        Menu.Notify(message, duration)
    end
end

-- Snapline/Tracer Drawing
local LineOutline = Drawing.new("Line")
LineOutline.Visible = false
LineOutline.Color = Color3.fromRGB(0, 0, 0)
LineOutline.Thickness = 3
LineOutline.Transparency = 1

local Line = Drawing.new("Line")
Line.Visible = false
Line.Color = MainColor
Line.Thickness = 1.5
Line.Transparency = 1

-- Track Health Changes
local HitSounds = {
    ["Rust Headshot"] = "rbxassetid://138750331387064",
    ["Neverlose"] = "rbxassetid://110168723447153",
    ["Bubble"] = "rbxassetid://6534947588",
    ["Laser"] = "rbxassetid://7837461331",
}

-- Create Hit Effect VFX
local CreateHitEffect = LPH_NO_VIRTUALIZE(function(part)
    if not part or not Settings.Visuals.HitVisualizers.HitEffect then return end
    
    local effectColor = Settings.Visuals.HitVisualizers.EffectColor
    local effectType = Settings.Visuals.HitVisualizers.EffectType
    local lifetime = Settings.Visuals.HitVisualizers.EffectLifetime
    
    -- Blood Splatter Effect
    if effectType == "Blood Splatter" then
        local attachment = Instance.new("Attachment")
        attachment.Parent = part
        
        -- Blood droplets
        local blood = Instance.new("ParticleEmitter")
        blood.Color = ColorSequence.new(effectColor)
        blood.Size = NumberSequence.new(0.8, 0.3)
        blood.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        blood.Lifetime = NumberRange.new(1, 2)
        blood.Speed = NumberRange.new(15, 35)
        blood.SpreadAngle = Vector2.new(45, 45)
        blood.Texture = "rbxasset://textures/particles/smoke_main.dds"
        blood.Acceleration = Vector3.new(0, -20, 0)
        blood.Drag = 2
        blood.Parent = attachment
        blood:Emit(50)
        
        -- Blood mist
        local mist = Instance.new("ParticleEmitter")
        mist.Color = ColorSequence.new(effectColor)
        mist.Size = NumberSequence.new(2, 4)
        mist.Transparency = NumberSequence.new(0.3, 1)
        mist.Lifetime = NumberRange.new(0.5, 1)
        mist.Speed = NumberRange.new(5, 15)
        mist.SpreadAngle = Vector2.new(180, 180)
        mist.Texture = "rbxasset://textures/particles/smoke_main.dds"
        mist.LightEmission = 0.2
        mist.Parent = attachment
        mist:Emit(30)
        
        -- Splatter marks
        for i = 1, 8 do
            task.spawn(function()
                local splat = Instance.new("Part")
                splat.Anchored = true
                splat.CanCollide = false
                splat.Size = Vector3.new(0.1, 0.1, math.random(1, 3))
                splat.Color = effectColor
                splat.Material = Enum.Material.Neon
                splat.Transparency = 0.3
                local angle = math.rad(i * 45)
                splat.CFrame = part.CFrame * CFrame.new(math.cos(angle) * 2, math.sin(angle) * 2, 0)
                splat.Parent = workspace
                
                for j = 1, 20 do
                    splat.Transparency = 0.3 + (j / 20) * 0.7
                    task.wait(0.05)
                end
                splat:Destroy()
            end)
        end
        
        task.delay(lifetime, function() attachment:Destroy() end)
    end
    
    -- Freeze Impact Effect
    if effectType == "Freeze Impact" then
        local attachment = Instance.new("Attachment")
        attachment.Parent = part
        
        -- Ice explosion burst
        local iceBurst = Instance.new("ParticleEmitter")
        iceBurst.Color = ColorSequence.new(effectColor)
        iceBurst.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(0.5, 2),
            NumberSequenceKeypoint.new(1, 0)
        })
        iceBurst.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
        iceBurst.Lifetime = NumberRange.new(1, 1.5)
        iceBurst.Speed = NumberRange.new(20, 35)
        iceBurst.SpreadAngle = Vector2.new(180, 180)
        iceBurst.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        iceBurst.LightEmission = 1
        iceBurst.Rotation = NumberRange.new(0, 360)
        iceBurst.RotSpeed = NumberRange.new(-200, 200)
        iceBurst.Drag = 5
        iceBurst.Parent = attachment
        iceBurst:Emit(80)
        
        -- Frost shockwave
        local frostWave = Instance.new("ParticleEmitter")
        frostWave.Color = ColorSequence.new(effectColor)
        frostWave.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(0.3, 4),
            NumberSequenceKeypoint.new(1, 6)
        })
        frostWave.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.5, 0.6),
            NumberSequenceKeypoint.new(1, 1)
        })
        frostWave.Lifetime = NumberRange.new(0.8, 1.2)
        frostWave.Speed = NumberRange.new(40, 60)
        frostWave.SpreadAngle = Vector2.new(180, 10)
        frostWave.Texture = "rbxasset://textures/particles/smoke_main.dds"
        frostWave.LightEmission = 0.7
        frostWave.Acceleration = Vector3.new(0, -5, 0)
        frostWave.Parent = attachment
        frostWave:Emit(50)
        
        -- Freezing mist
        local mist = Instance.new("ParticleEmitter")
        mist.Color = ColorSequence.new(effectColor)
        mist.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 5)
        })
        mist.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        mist.Lifetime = NumberRange.new(1.5, 2.5)
        mist.Speed = NumberRange.new(3, 8)
        mist.SpreadAngle = Vector2.new(180, 180)
        mist.Texture = "rbxasset://textures/particles/smoke_main.dds"
        mist.LightEmission = 0.5
        mist.Rotation = NumberRange.new(0, 360)
        mist.RotSpeed = NumberRange.new(-50, 50)
        mist.Parent = attachment
        mist:Emit(40)
        
        -- Ice crystals forming
        local crystals = Instance.new("ParticleEmitter")
        crystals.Color = ColorSequence.new(effectColor)
        crystals.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1, 0)
        })
        crystals.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        crystals.Lifetime = NumberRange.new(1, 2)
        crystals.Speed = NumberRange.new(10, 25)
        crystals.SpreadAngle = Vector2.new(180, 180)
        crystals.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        crystals.LightEmission = 1
        crystals.Rotation = NumberRange.new(0, 360)
        crystals.RotSpeed = NumberRange.new(-300, 300)
        crystals.Acceleration = Vector3.new(0, -15, 0)
        crystals.Parent = attachment
        crystals:Emit(60)
        
        -- Frozen aura rings
        for i = 1, 3 do
            task.delay(i * 0.06, function()
                local ringAttach = Instance.new("Attachment")
                ringAttach.Parent = part
                
                local ring = Instance.new("ParticleEmitter")
                ring.Color = ColorSequence.new(effectColor)
                ring.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.3),
                    NumberSequenceKeypoint.new(1, 0.1)
                })
                ring.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.2),
                    NumberSequenceKeypoint.new(1, 1)
                })
                ring.Lifetime = NumberRange.new(0.5, 0.8)
                ring.Speed = NumberRange.new(25, 40)
                ring.SpreadAngle = Vector2.new(180, 5)
                ring.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                ring.LightEmission = 1
                ring.Parent = ringAttach
                ring:Emit(30)
                
                task.delay(1, function()
                    ringAttach:Destroy()
                end)
            end)
        end
        
        task.delay(lifetime, function() attachment:Destroy() end)
    end
    
    -- Soul Extract Effect
    if effectType == "Soul Extract" then
        local attachment = Instance.new("Attachment")
        attachment.Parent = part
        
        -- Ghost/soul rising
        local soul = Instance.new("Part")
        soul.Anchored = true
        soul.CanCollide = false
        soul.Shape = Enum.PartType.Ball
        soul.Size = Vector3.new(2, 3, 1)
        soul.Color = effectColor
        soul.Material = Enum.Material.Neon
        soul.Transparency = 0.5
        soul.CFrame = part.CFrame
        soul.Parent = workspace
        
        task.spawn(function()
            for i = 1, 40 do
                soul.CFrame = soul.CFrame * CFrame.new(0, 0.2, 0)
                soul.Transparency = 0.5 + (i / 40) * 0.5
                soul.Size = soul.Size * 0.98
                task.wait(0.03)
            end
            soul:Destroy()
        end)
        
        -- Spiral particles
        local spiral = Instance.new("ParticleEmitter")
        spiral.Color = ColorSequence.new(effectColor)
        spiral.Size = NumberSequence.new(0.5, 0)
        spiral.Transparency = NumberSequence.new(0, 1)
        spiral.Lifetime = NumberRange.new(1.5, 2)
        spiral.Speed = NumberRange.new(5, 10)
        spiral.SpreadAngle = Vector2.new(30, 30)
        spiral.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        spiral.LightEmission = 1
        spiral.Acceleration = Vector3.new(0, 10, 0)
        spiral.Parent = attachment
        spiral:Emit(80)
        
        task.delay(2.5, function() attachment:Destroy() end)
    end
    
    -- Matrix Glitch Effect
    if effectType == "Matrix Glitch" then
        local attachment = Instance.new("Attachment")
        attachment.Parent = part
        
        -- Glitch cubes
        for i = 1, 15 do
            task.spawn(function()
                local cube = Instance.new("Part")
                cube.Anchored = true
                cube.CanCollide = false
                cube.Size = Vector3.new(math.random(5, 15) / 10, math.random(5, 15) / 10, math.random(5, 15) / 10)
                cube.Color = effectColor
                cube.Material = Enum.Material.Neon
                cube.Transparency = 0.2
                cube.CFrame = part.CFrame * CFrame.new(math.random(-3, 3), math.random(-3, 3), math.random(-3, 3))
                cube.Parent = workspace
                
                for j = 1, 20 do
                    cube.CFrame = cube.CFrame * CFrame.Angles(math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)), math.rad(math.random(-20, 20)))
                    cube.Transparency = 0.2 + (j / 20) * 0.8
                    task.wait(0.03)
                end
                cube:Destroy()
            end)
        end
        
        -- Digital rain
        local rain = Instance.new("ParticleEmitter")
        rain.Color = ColorSequence.new(effectColor)
        rain.Size = NumberSequence.new(0.3, 0.1)
        rain.Transparency = NumberSequence.new(0, 1)
        rain.Lifetime = NumberRange.new(0.8, 1.5)
        rain.Speed = NumberRange.new(20, 40)
        rain.SpreadAngle = Vector2.new(10, 10)
        rain.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        rain.LightEmission = 1
        rain.Acceleration = Vector3.new(0, -30, 0)
        rain.Parent = attachment
        rain:Emit(100)
        
        task.delay(2, function() attachment:Destroy() end)
    end
    
    -- Dimensional Rift Effect
    if effectType == "Dimensional Rift" then
        local attachment = Instance.new("Attachment")
        attachment.Parent = part
        
        -- Portal sphere
        local portal = Instance.new("Part")
        portal.Anchored = true
        portal.CanCollide = false
        portal.Shape = Enum.PartType.Ball
        portal.Size = Vector3.new(0.5, 0.5, 0.5)
        portal.Color = effectColor
        portal.Material = Enum.Material.Neon
        portal.CFrame = part.CFrame
        portal.Parent = workspace
        
        task.spawn(function()
            for i = 1, 30 do
                if portal then
                    portal.Size = portal.Size + Vector3.new(0.7, 0.7, 0.7)
                    portal.Transparency = i / 30
                    portal.CFrame = portal.CFrame * CFrame.Angles(math.rad(5), math.rad(5), 0)
                end
                task.wait(0.02)
            end
            if portal then portal:Destroy() end
        end)
        
        -- Rotating rings
        for i = 1, 4 do
            task.spawn(function()
                local ring = Instance.new("Part")
                ring.Anchored = true
                ring.CanCollide = false
                ring.Shape = Enum.PartType.Cylinder
                ring.Size = Vector3.new(0.3, 4, 4)
                ring.Color = effectColor
                ring.Material = Enum.Material.Neon
                ring.CFrame = part.CFrame * CFrame.Angles(math.rad(i * 45), 0, math.rad(90))
                ring.Parent = workspace
                
                for j = 1, 40 do
                    if ring then
                        ring.Size = ring.Size + Vector3.new(0, 0.8, 0.8)
                        ring.Transparency = j / 40
                        ring.CFrame = ring.CFrame * CFrame.Angles(0, 0, math.rad(10))
                    end
                    task.wait(0.015)
                end
                if ring then ring:Destroy() end
            end)
        end
        
        -- Void particles
        local void = Instance.new("ParticleEmitter")
        void.Color = ColorSequence.new(effectColor)
        void.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 7),
            NumberSequenceKeypoint.new(0.5, 3),
            NumberSequenceKeypoint.new(1, 0)
        })
        void.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
        void.Lifetime = NumberRange.new(0.8, 1.5)
        void.Rate = 300
        void.Speed = NumberRange.new(20, 45)
        void.SpreadAngle = Vector2.new(180, 180)
        void.Texture = "rbxasset://textures/particles/smoke_main.dds"
        void.LightEmission = 0.9
        void.LightInfluence = 0.1
        void.Rotation = NumberRange.new(0, 360)
        void.RotSpeed = NumberRange.new(-100, 100)
        void.Parent = attachment
        void:Emit(100)
        
        -- Spiraling beams
        local char = Client.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for i = 1, 6 do
                task.spawn(function()
                    local attach1 = Instance.new("Attachment")
                    attach1.Parent = char.HumanoidRootPart
                    
                    local attach2 = Instance.new("Attachment")
                    attach2.Parent = part
                    attach2.Position = Vector3.new(math.cos(i) * 3, math.sin(i) * 3, 0)
                    
                    local beam = Instance.new("Beam")
                    beam.Color = ColorSequence.new(effectColor)
                    beam.Width0 = 1
                    beam.Width1 = 1
                    beam.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.2),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                    beam.FaceCamera = true
                    beam.LightEmission = 1
                    beam.LightInfluence = 0
                    beam.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                    beam.Attachment0 = attach1
                    beam.Attachment1 = attach2
                    beam.Parent = char.HumanoidRootPart
                    
                    task.delay(0.6, function()
                        if beam then beam:Destroy() end
                        if attach1 then attach1:Destroy() end
                        if attach2 then attach2:Destroy() end
                    end)
                end)
            end
        end
        
        task.delay(2.5, function()
            if attachment then attachment:Destroy() end
        end)
    end
end)

-- Create Hit Marker (Damage Number)
local function CreateHitMarker(targetPart, damage)
    if not Settings.Visuals.HitVisualizers.HitMarkers.Enabled then return end
    if not targetPart then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "HitMarker"
    billboardGui.Adornee = targetPart
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(math.random(-2, 2), math.random(2, 4), math.random(-1, 1))
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = targetPart
    
    -- Outline text
    local outlineLabel = Instance.new("TextLabel")
    outlineLabel.Size = UDim2.new(1, 0, 1, 0)
    outlineLabel.BackgroundTransparency = 1
    outlineLabel.Text = "-" .. tostring(damage)
    outlineLabel.Font = Enum.Font.FredokaOne -- Cartoon font
    outlineLabel.TextSize = 32
    outlineLabel.TextColor3 = Settings.Visuals.HitVisualizers.HitMarkers.OutlineColor
    outlineLabel.TextStrokeTransparency = 0
    outlineLabel.TextStrokeColor3 = Settings.Visuals.HitVisualizers.HitMarkers.OutlineColor
    outlineLabel.TextTransparency = 0
    outlineLabel.ZIndex = 1
    outlineLabel.Parent = billboardGui
    
    -- Main text
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, 0, 1, 0)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "-" .. tostring(damage)
    mainLabel.Font = Enum.Font.FredokaOne -- Cartoon font
    mainLabel.TextSize = 32
    mainLabel.TextColor3 = Settings.Visuals.HitVisualizers.HitMarkers.MainColor
    mainLabel.TextStrokeTransparency = 1 - (Settings.Visuals.HitVisualizers.HitMarkers.OutlineThickness / 10)
    mainLabel.TextStrokeColor3 = Settings.Visuals.HitVisualizers.HitMarkers.OutlineColor
    mainLabel.TextTransparency = 0
    mainLabel.ZIndex = 2
    mainLabel.Parent = billboardGui
    
    -- Pop-up animation
    local startSize = 28
    local endSize = 32
    local duration = 1.5
    
    task.spawn(function()
        -- Scale up animation
        for i = 0, 1, 0.1 do
            local size = startSize + (endSize - startSize) * i
            outlineLabel.TextSize = size
            mainLabel.TextSize = size
            task.wait(0.03)
        end
        
        -- Float up and fade
        local startTime = tick()
        while tick() - startTime < duration do
            local alpha = (tick() - startTime) / duration
            billboardGui.StudsOffset = billboardGui.StudsOffset + Vector3.new(0, 0.02, 0)
            outlineLabel.TextTransparency = alpha
            mainLabel.TextTransparency = alpha
            task.wait()
        end
        
        billboardGui:Destroy()
    end)
end

local TrackHealth = LPH_NO_VIRTUALIZE(function()
    if not Locked or not Target or not Target.Character then return end
    
    local humanoid = Target.Character:FindFirstChild("Humanoid")
    if humanoid then
        if not LastHealth[Target.UserId] then
            LastHealth[Target.UserId] = humanoid.Health
            return
        end
        
        local currentHealth = humanoid.Health
        local previousHealth = LastHealth[Target.UserId]
        
        if currentHealth < previousHealth then
            local damage = math.floor(previousHealth - currentHealth)
            if damage > 0 then
                local part = Settings.Ragebot.TargetPart
                local targetPart = Target.Character:FindFirstChild(part)
                
                -- Show hit notification if enabled
                if Settings.Ragebot.HitNotifications then
                    Notify('winhvh  >  <font color="#' .. tostring(MainColor:ToHex()) .. '">Inflicted</font> ' .. Target.Name .. ' for <font color="#' .. tostring(MainColor:ToHex()) .. '">' .. tostring(damage) .. '</font> damage in the <font color="#' .. tostring(MainColor:ToHex()) .. '">' .. part .. '</font>', 2)
                end
                
                -- Create hit marker with damage number
                if targetPart then
                    CreateHitMarker(targetPart, damage)
                end
                
                -- Play hit sound (independent of notifications)
                if Settings.Visuals.HitVisualizers.HitSound then
                    local soundId = HitSounds[Settings.Visuals.HitVisualizers.SelectedSound]
                    if soundId then
                        local sound = Instance.new("Sound")
                        sound.SoundId = soundId
                        sound.Volume = Settings.Visuals.HitVisualizers.SoundVolume
                        sound.Parent = SoundService
                        sound:Play()
                        
                        sound.Ended:Connect(function()
                            sound:Destroy()
                        end)
                    end
                end
                
                -- Create hit effect (independent of notifications)
                if targetPart then
                    CreateHitEffect(targetPart)
                end
            end
        end
        
        LastHealth[Target.UserId] = currentHealth
    end
end)

-- Get Closest Player to Mouse
local GetClosestPlayer = LPH_NO_VIRTUALIZE(function()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Client and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < ShortestDistance then
                    ShortestDistance = distance
                    ClosestPlayer = player
                end
            end
        end
    end
    
    return ClosestPlayer
end)

-- Get Closest Part (for aimlock)
local GetClosestPart = LPH_NO_VIRTUALIZE(function()
    if not Locked or not Target or not Target.Character then
        return nil
    end
    
    local part = Target.Character:FindFirstChild(Settings.Ragebot.TargetPart)
    if part then
        return part
    end
    return nil
end)

-- Hook Mouse for Aimlock
local oldIndex
oldIndex = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(newcclosure(function(self, key)
    if self == Mouse and (key == "Target" or key == "Hit") and Locked then
        local closest = GetClosestPart()
        if closest then
            if key == "Target" then
                return closest
            elseif key == "Hit" then
                local prediction = Settings.Ragebot.Prediction.Enabled and Settings.Ragebot.Prediction.Amount or 0
                local targetPos = CFrame.new(closest.Position + (closest.Velocity * prediction))
                
                -- Apply smoothness if enabled
                if Settings.Ragebot.Smoothness.Enabled and Settings.Ragebot.Smoothness.Amount > 0 then
                    local currentCF = Camera.CFrame
                    local targetCF = CFrame.new(currentCF.Position, targetPos.Position)
                    local smoothedCF = currentCF:Lerp(targetCF, 1 / Settings.Ragebot.Smoothness.Amount)
                    return CFrame.new(smoothedCF.Position, targetPos.Position)
                end
                
                return targetPos
            end
        end
    end
    return oldIndex(self, key)
end)))

-- Menu Setup
Menu.Accent = MainColor
Menu.Keybinds = Menu.Keybinds() do
    Menu.Keybinds.Add('Ragebot', Locked and 'On' or 'Off')
end
Menu.Indicators = Menu.Indicators() do
    Menu.Indicators.Add('Target Name', 'Text', 'None')
    Menu.Indicators.Add('Target Health', 'Bar', 100, 0, 100)
    Menu.Indicators.Add('Target Tool', 'Text', 'None')
end
Menu.Watermark()
Menu.Watermark:Update('winhvh')

-- Functions
local function MenuToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Menu:SetVisible(not Menu.IsVisible)
    end
end

-- Animated window title
local titleText = ""
local fullTitle = "winhvh"
local titleIndex = 0

task.spawn(function()
    task.wait(0.5)
    while titleIndex < #fullTitle do
        titleIndex = titleIndex + 1
        titleText = string.sub(fullTitle, 1, titleIndex)
        Menu:SetTitle(titleText)
        task.wait(0.1)
    end
    -- Keep cycling the full title
    while true do
        task.wait(2)
        for i = #fullTitle, 1, -1 do
            Menu:SetTitle(string.sub(fullTitle, 1, i))
            task.wait(0.05)
        end
        task.wait(0.3)
        for i = 1, #fullTitle do
            Menu:SetTitle(string.sub(fullTitle, 1, i))
            task.wait(0.1)
        end
    end
end)

local Window = Menu:SetTitle('winhvh') do

    -- Ragebot Tab
    local RagebotTab = Menu.Tab("Ragebot") do
        
        local RagebotSection = Menu.Container("Ragebot", "Ragebot", "Left") do
            Menu.CheckBox("Ragebot", "Ragebot", "Enabled", false, function(a)
                Settings.Ragebot.Enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Ragebot ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            Menu.Hotkey("Ragebot", "Ragebot", "Keybind", nil, function(a)
                Settings.Ragebot.Keybind = a
            end)
            Menu.ComboBox("Ragebot", "Ragebot", "Target Part", "HumanoidRootPart", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, function(a)
                Settings.Ragebot.TargetPart = a
            end)
            
            -- Prediction
            Menu.CheckBox("Ragebot", "Ragebot", "Prediction", false, function(a)
                Settings.Ragebot.Prediction.Enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Prediction ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            Menu.Slider("Ragebot", "Ragebot", "Prediction Amount", 0, 0.5, 0.165, '', 0.001, function(a)
                Settings.Ragebot.Prediction.Amount = a
            end)
            
            -- Smoothness
            Menu.CheckBox("Ragebot", "Ragebot", "Smoothness", false, function(a)
                Settings.Ragebot.Smoothness.Enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Smoothness ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            Menu.Slider("Ragebot", "Ragebot", "Smoothness Amount", 0, 20, 0, '', 0.1, function(a)
                Settings.Ragebot.Smoothness.Amount = a
            end)
            
            -- Hit Notifications
            Menu.CheckBox("Ragebot", "Ragebot", "Hit Notifications", false, function(a)
                Settings.Ragebot.HitNotifications = a
            end)
            
            -- Auto Stomp
            Menu.CheckBox("Ragebot", "Ragebot", "Auto Stomp", false, function(a)
                Settings.Ragebot.AutoStomp = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Auto Stomp ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            
            -- Manipulation
            Menu.CheckBox("Ragebot", "Ragebot", "Manipulation", false, function(a)
                Settings.Ragebot.Manipulation.Enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Manipulation ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            Menu.CheckBox("Ragebot", "Ragebot", "Check for Fire Function", false, function(a)
                Settings.Ragebot.Manipulation.CheckFireFunction = a
            end)
            Menu.Slider("Ragebot", "Ragebot", "Fire Rate", 0, 1, 0.1, 's', 0.01, function(a)
                Settings.Ragebot.Manipulation.FireRate = a
            end)
            Menu.Slider("Ragebot", "Ragebot", "Cooldown", 0, 2, 0.5, 's', 0.01, function(a)
                Settings.Ragebot.Manipulation.Cooldown = a
            end)
        end

        local VisualsSection = Menu.Container("Ragebot", "Visualization", "Right") do
            -- 3D Circle Controls
            Menu.CheckBox("Ragebot", "Visualization", "3D Circle", false, function(a)
                circle3DState.enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  3D Circle ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            
            local whiteColor = Color3.fromRGB(255, 255, 255)
            local blueColor = Color3.fromRGB(0, 170, 255)
            
            Menu.ColorPicker("Ragebot", "Visualization", "Circle Color 1", whiteColor, 0, function(a)
                if a then
                    circle3DState.color1 = a
                end
            end)
            Menu.ColorPicker("Ragebot", "Visualization", "Circle Color 2", blueColor, 0, function(a)
                if a then
                    circle3DState.color2 = a
                end
            end)
            
            Menu.CheckBox("Ragebot", "Visualization", "Snapline", false, function(a)
                Settings.Visuals.Snapline.Enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Snapline ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            Menu.ColorPicker("Ragebot", "Visualization", "Line Color", MainColor, 0, function(a)
                if a then
                    Settings.Visuals.Snapline.Color = a
                    if Line then
                        Line.Color = a
                    end
                end
            end)
            Menu.ColorPicker("Ragebot", "Visualization", "Outline Color", Color3.fromRGB(0, 0, 0), 0, function(a)
                if a then
                    Settings.Visuals.Snapline.OutlineColor = a
                    if LineOutline then
                        LineOutline.Color = a
                    end
                end
            end)
            Menu.ComboBox("Ragebot", "Visualization", "Position", "Character", {"Cursor", "Character", "Tool"}, function(a)
                Settings.Visuals.Snapline.Position = a
            end)
            Menu.Slider("Ragebot", "Visualization", "Thickness", 0.5, 5, 1.5, '', 0.1, function(a)
                Settings.Visuals.Snapline.Thickness = a
                if Line then
                    Line.Thickness = a
                end
                if LineOutline then
                    LineOutline.Thickness = a + 1.5
                end
            end)
            
            -- Face Target
            Menu.CheckBox("Ragebot", "Visualization", "Face Target", false, function(a)
                Settings.Ragebot.FaceTarget = a
            end)
            
            -- Spectate Target
            Menu.CheckBox("Ragebot", "Visualization", "Spectate Target", false, function(a)
                Settings.Ragebot.Spectate = a
            end)
        end

        local KillbotSection = Menu.Container("Ragebot", "Killbot", "Right") do
            Menu.CheckBox("Ragebot", "Killbot", "Enabled", false, function(a)
                Settings.Killbot.Enabled = a
                if Settings.Configs.Notifications.FeatureNotifications then
                    Notify('winhvh  >  Killbot ' .. (a and 'Enabled' or 'Disabled'), 1.5)
                end
            end)
            Menu.ComboBox("Ragebot", "Killbot", "Method", "Orbit", {"Orbit", "Strafe", "Connection"}, function(a)
                Settings.Killbot.Method = a
            end)
            Menu.Slider("Ragebot", "Killbot", "Speed", 0, 15, 1, '', 0.1, function(a)
                Settings.Killbot.Speed = a
            end)
            Menu.Slider("Ragebot", "Killbot", "Height", 0, 15, 0, '', 0.1, function(a)
                Settings.Killbot.Height = a
            end)
            Menu.Slider("Ragebot", "Killbot", "Range", 1, 50, 9, '', 1, function(a)
                Settings.Killbot.Range = a
            end)
            Menu.CheckBox("Ragebot", "Killbot", "Auto Fire", false, function(a)
                Settings.Killbot.AutoFire = a
            end)
            Menu.Slider("Ragebot", "Killbot", "Cooldown", 0, 1, 0.1, 's', 0.01, function(a)
                Settings.Killbot.Cooldown = a
            end)
            Menu.Slider("Ragebot", "Killbot", "Fire Rate", 0.01, 0.5, 0.05, 's', 0.01, function(a)
                Settings.Killbot.FireRate = a
            end)
            Menu.CheckBox("Ragebot", "Killbot", "Auto Equip Tool", false, function(a)
                Settings.Killbot.AutoEquip.Enabled = a
            end)
            Menu.ComboBox("Ragebot", "Killbot", "Tool", "[Double-Barrel SG]", {"[Double-Barrel SG]", "[DoubleBarrel]", "[Revolver]", "[TacticalShotgun]", "[Knife]"}, function(a)
                Settings.Killbot.AutoEquip.Tool = a
            end)
        end

    end

    -- Visuals Tab
    local VisualsTab = Menu.Tab("Visuals") do
        
        local HitVisualizersSection = Menu.Container("Visuals", "Hit Visualizers", "Left") do
            Menu.CheckBox("Visuals", "Hit Visualizers", "Hit Sound", false, function(a)
                Settings.Visuals.HitVisualizers.HitSound = a
            end)
            Menu.ComboBox("Visuals", "Hit Visualizers", "Sound", "Bubble", {"Rust Headshot", "Neverlose", "Bubble", "Laser"}, function(a)
                Settings.Visuals.HitVisualizers.SelectedSound = a
            end)
            Menu.Slider("Visuals", "Hit Visualizers", "Sound Volume", 0, 1, 0.5, '', 0.1, function(a)
                Settings.Visuals.HitVisualizers.SoundVolume = a
            end)
            Menu.CheckBox("Visuals", "Hit Visualizers", "Hit Effect", false, function(a)
                Settings.Visuals.HitVisualizers.HitEffect = a
            end)
            Menu.ComboBox("Visuals", "Hit Visualizers", "Effect Type", "Dimensional Rift", {"Dimensional Rift", "Blood Splatter", "Freeze Impact", "Soul Extract", "Matrix Glitch"}, function(a)
                Settings.Visuals.HitVisualizers.EffectType = a
            end)
            Menu.Slider("Visuals", "Hit Visualizers", "Effect Lifetime", 1, 5, 2, 's', 0.5, function(a)
                Settings.Visuals.HitVisualizers.EffectLifetime = a
            end)
            Menu.ColorPicker("Visuals", "Hit Visualizers", "Effect Color", MainColor, 0, function(a)
                if a then
                    Settings.Visuals.HitVisualizers.EffectColor = a
                end
            end)
            
            -- Hit Markers
            Menu.CheckBox("Visuals", "Hit Visualizers", "Hit Markers", false, function(a)
                Settings.Visuals.HitVisualizers.HitMarkers.Enabled = a
            end)
            Menu.ColorPicker("Visuals", "Hit Visualizers", "Marker Color", Color3.fromRGB(255, 255, 255), 0, function(a)
                if a then
                    Settings.Visuals.HitVisualizers.HitMarkers.MainColor = a
                end
            end)
            Menu.ColorPicker("Visuals", "Hit Visualizers", "Marker Outline", Color3.fromRGB(0, 0, 0), 0, function(a)
                if a then
                    Settings.Visuals.HitVisualizers.HitMarkers.OutlineColor = a
                end
            end)
            Menu.Slider("Visuals", "Hit Visualizers", "Marker Thickness", 1, 10, 3, '', 1, function(a)
                Settings.Visuals.HitVisualizers.HitMarkers.MainThickness = a
            end)
            Menu.Slider("Visuals", "Hit Visualizers", "Outline Thickness", 0, 5, 1, '', 1, function(a)
                Settings.Visuals.HitVisualizers.HitMarkers.OutlineThickness = a
            end)
        end

        local SelfAuraSection = Menu.Container("Visuals", "Self Aura", "Left") do
            Menu.CheckBox("Visuals", "Self Aura", "Enabled", false, function(a)
                SelfAuraEnabled = a
                if a then
                    local char = Client.Character
                    if char and CurrentAura and CurrentAura ~= "None" then
                        applySelfAura(char, CurrentAura)
                    end
                else
                    removeSelfAura()
                end
            end)
            Menu.ComboBox("Visuals", "Self Aura", "Aura Type", "None", {"None", "Angel", "Starlight", "Heavenly", "Ribbon", "Sakura", "Wind", "Flow", "Star"}, function(a)
                CurrentAura = a or "None"
                if a == "None" then
                    removeSelfAura()
                else
                    local char = Client.Character
                    if char and SelfAuraEnabled then
                        applySelfAura(char, a)
                    end
                end
            end)
            Menu.ColorPicker("Visuals", "Self Aura", "Aura Color", MainColor, 0, function(a)
                if a then
                    SelfAuraColor = a
                    -- Reapply aura with new color
                    local char = Client.Character
                    if char and SelfAuraEnabled and CurrentAura and CurrentAura ~= "None" then
                        applySelfAura(char, CurrentAura)
                    end
                end
            end)
            
            -- Material Section
            Menu.CheckBox("Visuals", "Self Aura", "Material", false, function(a)
                MaterialEnabled = a
                if a then
                    applyCharacterMaterial()
                else
                    restoreCharacterMaterial()
                end
            end)
            Menu.ComboBox("Visuals", "Self Aura", "Material Type", "ForceField", {"ForceField", "Neon", "Glass", "Plastic", "Metal", "Granite", "Ice", "Marble"}, function(a)
                MaterialType = a
                if MaterialEnabled then
                    applyCharacterMaterial()
                end
            end)
            Menu.ColorPicker("Visuals", "Self Aura", "Material Color", MainColor, 0, function(a)
                if a then
                    MaterialColor = a
                    if MaterialEnabled then
                        applyCharacterMaterial()
                    end
                end
            end)
            
            -- Tool Material Section
            Menu.CheckBox("Visuals", "Self Aura", "Tool Material", false, function(a)
                ToolMaterialEnabled = a
                if a then
                    applyToolMaterial()
                else
                    restoreToolMaterial()
                end
            end)
            Menu.ComboBox("Visuals", "Self Aura", "Tool Material Type", "Neon", {"Neon", "ForceField", "Glass", "Plastic", "Metal", "Granite", "Ice", "Marble"}, function(a)
                ToolMaterialType = a
                if ToolMaterialEnabled then
                    applyToolMaterial()
                end
            end)
            Menu.ColorPicker("Visuals", "Self Aura", "Tool Material Color", MainColor, 0, function(a)
                if a then
                    ToolMaterialColor = a
                    if ToolMaterialEnabled then
                        applyToolMaterial()
                    end
                end
            end)
        end

        local WorldChangerSection = Menu.Container("Visuals", "World Changer", "Right") do
            Menu.CheckBox("Visuals", "World Changer", "Enabled", false, function(a)
                Settings.Visuals.WorldChanger.Enabled = a
                if not a then
                    -- Restore original lighting
                    for prop, value in pairs(OriginalLighting) do
                        Lighting[prop] = value
                    end
                    if AtmosphereInstance then
                        AtmosphereInstance:Destroy()
                        AtmosphereInstance = nil
                    end
                    for _, sky in pairs(SkyboxInstances) do
                        if sky then sky:Destroy() end
                    end
                    SkyboxInstances = {}
                    if BlurEffect then
                        BlurEffect:Destroy()
                        BlurEffect = nil
                    end
                    if SunRaysEffect then
                        SunRaysEffect:Destroy()
                        SunRaysEffect = nil
                    end
                end
            end)
            
            -- Atmosphere
            Menu.CheckBox("Visuals", "World Changer", "Atmosphere", false, function(a)
                Settings.Visuals.WorldChanger.Atmosphere.Enabled = a
                if a then
                    if not AtmosphereInstance then
                        AtmosphereInstance = Instance.new("Atmosphere")
                        AtmosphereInstance.Parent = Lighting
                    end
                    AtmosphereInstance.Color = Settings.Visuals.WorldChanger.Atmosphere.Color
                    AtmosphereInstance.Decay = Color3.fromRGB(106, 112, 125)
                    AtmosphereInstance.Glare = Settings.Visuals.WorldChanger.Glare
                    AtmosphereInstance.Haze = 0
                    AtmosphereInstance.Density = 0.3
                    AtmosphereInstance.Offset = 0.25
                else
                    if AtmosphereInstance then
                        AtmosphereInstance:Destroy()
                        AtmosphereInstance = nil
                    end
                end
            end)
            
            -- Fog
            Menu.CheckBox("Visuals", "World Changer", "Fog", false, function(a)
                Settings.Visuals.WorldChanger.Fog.Enabled = a
                if a and Settings.Visuals.WorldChanger.Enabled then
                    Lighting.FogColor = Settings.Visuals.WorldChanger.Fog.Color
                    Lighting.FogStart = Settings.Visuals.WorldChanger.Fog.Start
                    Lighting.FogEnd = Settings.Visuals.WorldChanger.Fog.End
                else
                    Lighting.FogColor = OriginalLighting.FogColor
                    Lighting.FogStart = OriginalLighting.FogStart
                    Lighting.FogEnd = OriginalLighting.FogEnd
                end
            end)
            Menu.Slider("Visuals", "World Changer", "Fog Start", 0, 5000, 0, '', 50, function(a)
                Settings.Visuals.WorldChanger.Fog.Start = a
                if Settings.Visuals.WorldChanger.Fog.Enabled and Settings.Visuals.WorldChanger.Enabled then
                    Lighting.FogStart = a
                end
            end)
            Menu.Slider("Visuals", "World Changer", "Fog End", 100, 500, 500, '', 10, function(a)
                Settings.Visuals.WorldChanger.Fog.End = a
                if Settings.Visuals.WorldChanger.Fog.Enabled and Settings.Visuals.WorldChanger.Enabled then
                    Lighting.FogEnd = a
                end
            end)
            
            -- Clock Time
            Menu.CheckBox("Visuals", "World Changer", "Clock Time", false, function(a)
                Settings.Visuals.WorldChanger.ClockTime.Enabled = a
                if a and Settings.Visuals.WorldChanger.Enabled then
                    Lighting.ClockTime = Settings.Visuals.WorldChanger.ClockTime.Time
                else
                    Lighting.ClockTime = OriginalLighting.ClockTime
                end
            end)
            Menu.Slider("Visuals", "World Changer", "Time", 0, 24, 14, '', 0.1, function(a)
                Settings.Visuals.WorldChanger.ClockTime.Time = a
                if Settings.Visuals.WorldChanger.ClockTime.Enabled and Settings.Visuals.WorldChanger.Enabled then
                    Lighting.ClockTime = a
                end
            end)
            
            -- Skybox
            Menu.CheckBox("Visuals", "World Changer", "Skybox", false, function(a)
                Settings.Visuals.WorldChanger.Skybox.Enabled = a
                if a and Settings.Visuals.WorldChanger.Enabled then
                    local skyboxData = Skyboxes[Settings.Visuals.WorldChanger.Skybox.Selected]
                    if skyboxData then
                        local sky = Instance.new("Sky")
                        sky.SkyboxBk = skyboxData.SkyboxBk
                        sky.SkyboxDn = skyboxData.SkyboxDn
                        sky.SkyboxFt = skyboxData.SkyboxFt
                        sky.SkyboxLf = skyboxData.SkyboxLf
                        sky.SkyboxRt = skyboxData.SkyboxRt
                        sky.SkyboxUp = skyboxData.SkyboxUp
                        sky.Parent = Lighting
                        table.insert(SkyboxInstances, sky)
                    end
                else
                    for _, sky in pairs(SkyboxInstances) do
                        if sky then sky:Destroy() end
                    end
                    SkyboxInstances = {}
                end
            end)
            Menu.ComboBox("Visuals", "World Changer", "Skybox Style", "Default", {"Default", "Nebula", "Vaporwave", "Purple Nebula", "Pink Daylight", "Morning Glow", "Setting Sun", "Fade Blue", "Elegant Morning", "Neptune", "Redshift"}, function(a)
                Settings.Visuals.WorldChanger.Skybox.Selected = a
                if Settings.Visuals.WorldChanger.Skybox.Enabled and Settings.Visuals.WorldChanger.Enabled then
                    for _, sky in pairs(SkyboxInstances) do
                        if sky then sky:Destroy() end
                    end
                    SkyboxInstances = {}
                    
                    if a ~= "Default" then
                        local skyboxData = Skyboxes[a]
                        if skyboxData then
                            local sky = Instance.new("Sky")
                            sky.SkyboxBk = skyboxData.SkyboxBk
                            sky.SkyboxDn = skyboxData.SkyboxDn
                            sky.SkyboxFt = skyboxData.SkyboxFt
                            sky.SkyboxLf = skyboxData.SkyboxLf
                            sky.SkyboxRt = skyboxData.SkyboxRt
                            sky.SkyboxUp = skyboxData.SkyboxUp
                            sky.Parent = Lighting
                            table.insert(SkyboxInstances, sky)
                        end
                    end
                end
            end)
            
            -- Post Processing Effects
            Menu.Slider("Visuals", "World Changer", "Glare", 0, 10, 0, '', 0.1, function(a)
                Settings.Visuals.WorldChanger.Glare = a
                if AtmosphereInstance and Settings.Visuals.WorldChanger.Enabled then
                    AtmosphereInstance.Glare = a
                end
            end)
            
            Menu.Slider("Visuals", "World Changer", "Sun Rays Intensity", 0, 1, 0, '', 0.05, function(a)
                Settings.Visuals.WorldChanger.SunRays = a
                if Settings.Visuals.WorldChanger.Enabled then
                    if a > 0 then
                        if not SunRaysEffect then
                            SunRaysEffect = Instance.new("SunRaysEffect")
                            SunRaysEffect.Parent = Lighting
                        end
                        SunRaysEffect.Intensity = a
                    else
                        if SunRaysEffect then
                            SunRaysEffect:Destroy()
                            SunRaysEffect = nil
                        end
                    end
                end
            end)
            
            Menu.Slider("Visuals", "World Changer", "Blur", 0, 50, 0, '', 1, function(a)
                Settings.Visuals.WorldChanger.Blur = a
                if Settings.Visuals.WorldChanger.Enabled then
                    if a > 0 then
                        if not BlurEffect then
                            BlurEffect = Instance.new("BlurEffect")
                            BlurEffect.Parent = Lighting
                        end
                        BlurEffect.Size = a
                    else
                        if BlurEffect then
                            BlurEffect:Destroy()
                            BlurEffect = nil
                        end
                    end
                end
            end)
        end

    end

    -- Configuration Tab
    local ConfigsTab = Menu.Tab("Configuration") do

        local MenuSection = Menu.Container("Configuration", "Menu", "Left") do
            Menu.Hotkey('Configuration', 'Menu', 'Menu Key', Settings.Configs.Menu.Keybind, function(a)
                Settings.Configs.Menu.Keybind = a
                ContextAction:BindAction('menuToggle', MenuToggle, true, a)
            end)
            Menu.ColorPicker("Configuration", "Menu", "Accent Color", MainColor, 0, function(self)
                if self then
                    MainColor = self
                    Menu.Accent = self
                end
            end)
    
            Menu.CheckBox('Configuration', 'Menu', 'Indicators', false, function(Boolean)
                Menu.Indicators:SetVisible(Boolean)
            end)
    
            Menu.CheckBox('Configuration', 'Menu', 'Keybinds', false, function(Boolean)
                Menu.Keybinds:SetVisible(Boolean)
            end)
            
            Menu.ComboBox('Configuration', 'Menu', 'Notification Type', 'Library', {'Library', 'Custom'}, function(selected)
                Settings.Configs.Notifications.Type = selected
            end)
            
            Menu.CheckBox('Configuration', 'Menu', 'Feature Notifications', false, function(Boolean)
                Settings.Configs.Notifications.FeatureNotifications = Boolean
            end)
        end

        local ConfigSection = Menu.Container('Configuration', 'Configs', 'Right') do
            Menu.TextBox('Configuration', 'Configs', 'Config Name', '', function(text)
                print("Config Name:", text)
            end)
            Menu.Button('Configuration', 'Configs', 'Save Config', function()
                print("Config Saved")
            end)
            Menu.Button('Configuration', 'Configs', 'Load Config', function()
                print("Config Loaded")
            end)
        end
        
    end
end

-- Initialize
Menu.Watermark:SetVisible(true)
Menu:SetTab("Ragebot")
Menu:SetVisible(true)
Menu:Init()

-- Initialize circle3D
createCircle3D()

-- Ragebot Keybind Handler
UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input, isTyping)
    if isTyping then return end
    
    if Settings.Ragebot.Keybind and input.KeyCode == Settings.Ragebot.Keybind and Settings.Ragebot.Enabled then
        if Locked then
            -- Unlock
            Locked = false
            Target = nil
            Menu.Keybinds.List['Ragebot']:Update('Off')
            Menu.Indicators.List['Target Name']:Update('None')
            Notify('winhvh  >  Unlocked', 1.5)
            
            -- Unspectate
            if Settings.Ragebot.Spectate then
                Camera.CameraSubject = Client.Character and Client.Character:FindFirstChild("Humanoid")
            end
        else
            -- Lock to closest player
            Target = GetClosestPlayer()
            if Target then
                Locked = true
                Menu.Keybinds.List['Ragebot']:Update('On')
                Menu.Indicators.List['Target Name']:Update(Target.Name)
                Notify('winhvh  >  Locked on to ' .. Target.Name, 1.5)
                
                -- Spectate
                if Settings.Ragebot.Spectate and Target.Character then
                    Camera.CameraSubject = Target.Character:FindFirstChild("Humanoid")
                end
            else
                Notify('winhvh  >  No target found', 1.5)
            end
        end
    end
end))

-- Bullet Manipulation System (GunHandler hook method)
local LastManipulation = 0

-- Try to find and hook GunHandler
local GunHandler = nil
task.spawn(function()
    for attempt = 1, 10 do
        -- Check ReplicatedStorage for GunHandler
        local module = ReplicatedStorage:FindFirstChild("GunHandler")
        if module then
            GunHandler = require(module)
            break
        end
        
        -- Check Modules folder
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        if modules then
            module = modules:FindFirstChild("GunHandler")
            if module then
                GunHandler = require(module)
                break
            end
        end
        
        task.wait(0.5)
    end
    
    -- Hook GunHandler.Shoot if found
    if GunHandler and GunHandler.Shoot then
        local originalShoot = GunHandler.Shoot
        
        GunHandler.Shoot = function(params)
            if Settings.Ragebot.Manipulation.Enabled and Locked and Target and Target.Character then
                if tick() - LastManipulation < Settings.Ragebot.Manipulation.Cooldown then
                    return originalShoot(params)
                end
                
                local targetPart = Target.Character:FindFirstChild(Settings.Ragebot.TargetPart)
                if targetPart then
                    local targetPos = targetPart.Position
                    
                    -- Apply prediction
                    if Settings.Ragebot.Prediction.Enabled then
                        local velocity = targetPart.AssemblyLinearVelocity
                        targetPos = targetPos + (velocity * Settings.Ragebot.Prediction.Amount)
                    end
                    
                    -- Modify shoot parameters
                    local newParams = params and table.clone(params) or {}
                    newParams.AimPosition = targetPos
                    newParams.Hit = targetPart
                    newParams.Normal = Vector3.new(0, 1, 0)
                    
                    if newParams.BeamTarget then
                        newParams.BeamTarget = targetPart
                    end
                    
                    LastManipulation = tick()
                    return originalShoot(newParams)
                end
            end
            
            return originalShoot(params)
        end
    end
end)

-- Fallback: Metatable hook for Mouse.Hit (for games without GunHandler)
local Mouse = Client:GetMouse()
local Mt = getrawmetatable(game)
setreadonly(Mt, false)
local OldIndex = Mt.__index

Mt.__index = function(Self, Index)
    if not checkcaller() and Self == Mouse then
        if (Index == "Hit" or Index == "Target") and Settings.Ragebot.Manipulation.Enabled then
            if Locked and Target and Target.Character then
                local targetPart = Target.Character:FindFirstChild(Settings.Ragebot.TargetPart)
                if targetPart then
                    local targetPos = targetPart.Position
                    
                    -- Apply prediction
                    if Settings.Ragebot.Prediction.Enabled then
                        local velocity = targetPart.AssemblyLinearVelocity
                        targetPos = targetPos + (velocity * Settings.Ragebot.Prediction.Amount)
                    end
                    
                    return CFrame.new(targetPos)
                end
            end
        end
    end
    return OldIndex(Self, Index)
end

setreadonly(Mt, true)

-- Tool grip manipulation (additional method)
local function CFrameToOffset(Origin, Target)
    local ActualOrigin = Origin * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
    return ActualOrigin:ToObjectSpace(Target):inverse()
end

local function TeleportBullet(Tool)
    if not (Locked and Target and Target.Character) then return end
    if tick() - LastManipulation < Settings.Ragebot.Manipulation.Cooldown then return end
    
    local targetPart = Target.Character:FindFirstChild(Settings.Ragebot.TargetPart)
    local originPart = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
    local rightHand = Client.Character and Client.Character:FindFirstChild("RightHand")
    
    if targetPart and originPart and rightHand then
        local targetPos = targetPart.Position
        
        -- Apply prediction
        if Settings.Ragebot.Prediction.Enabled then
            local velocity = targetPart.AssemblyLinearVelocity
            targetPos = targetPos + (velocity * Settings.Ragebot.Prediction.Amount)
        end
        
        local OriginalGrip = Tool.Grip
        Tool.Parent = Client.Backpack
        Tool.Grip = CFrameToOffset(rightHand.CFrame, CFrame.new(targetPos))
        Tool.Parent = Client.Character
        
        RunService.RenderStepped:Wait()
        
        Tool.Parent = Client.Backpack
        Tool.Grip = OriginalGrip
        Tool.Parent = Client.Character
        
        LastManipulation = tick()
    end
end

-- Tool hook system
local ToolConnections = {}

local function HandleTool(Tool)
    if not Tool:IsA("Tool") then return end
    
    -- Check for fire function if enabled
    if Settings.Ragebot.Manipulation.CheckFireFunction then
        local hasFire = Tool:FindFirstChild("Fire") or 
                       Tool:FindFirstChild("Shoot") or 
                       Tool:FindFirstChild("fire") or 
                       Tool:FindFirstChild("shoot")
        if not hasFire then return end
    end
    
    -- Disable grip change connections
    pcall(function()
        for _, Conn in ipairs(getconnections(Tool:GetPropertyChangedSignal("Grip"))) do
            Conn:Disable()
        end
    end)
    
    -- Hook tool activation
    if ToolConnections.Activated then
        ToolConnections.Activated:Disconnect()
    end
    
    ToolConnections.Activated = Tool.Activated:Connect(function()
        if Settings.Ragebot.Manipulation.Enabled then
            task.wait(Settings.Ragebot.Manipulation.FireRate)
            TeleportBullet(Tool)
        end
    end)
end

local function HandleCharacter(Character)
    if ToolConnections.ChildAdded then
        ToolConnections.ChildAdded:Disconnect()
    end
    
    ToolConnections.ChildAdded = Character.ChildAdded:Connect(function(Child)
        if Child:IsA("Tool") then
            HandleTool(Child)
        end
    end)
    
    if ToolConnections.ChildRemoved then
        ToolConnections.ChildRemoved:Disconnect()
    end
    
    ToolConnections.ChildRemoved = Character.ChildRemoved:Connect(function(Child)
        if Child:IsA("Tool") and ToolConnections.Activated then
            ToolConnections.Activated:Disconnect()
        end
    end)
    
    -- Hook existing tool
    local existingTool = Character:FindFirstChildOfClass("Tool")
    if existingTool then
        HandleTool(existingTool)
    end
end

-- Setup character
if Client.Character then
    HandleCharacter(Client.Character)
end

Client.CharacterAdded:Connect(HandleCharacter)

-- Main Loop
RunService.Heartbeat:Connect(LPH_JIT_MAX(function(dt)
    -- Update 3D Circle rotation
    updateCircle3D(dt)
    
    -- Track health changes for hit notifications
    TrackHealth()
    
    -- Update Indicators
    if Target and Target.Character then
        local targetHumanoid = Target.Character:FindFirstChild("Humanoid")
        local targetTool = Target.Character:FindFirstChildOfClass("Tool")
        
        -- Update Name
        Menu.Indicators.List['Target Name']:Update(Target.Name)
        
        -- Update Health Bar
        if targetHumanoid then
            local health = math.floor(targetHumanoid.Health)
            local maxHealth = math.floor(targetHumanoid.MaxHealth)
            Menu.Indicators.List['Target Health']:Update(health, 0, maxHealth)
        else
            Menu.Indicators.List['Target Health']:Update(0, 0, 100)
        end
        
        -- Update Tool
        if targetTool then
            Menu.Indicators.List['Target Tool']:Update(targetTool.Name)
        else
            Menu.Indicators.List['Target Tool']:Update('None')
        end
    else
        -- No target
        Menu.Indicators.List['Target Name']:Update('None')
        Menu.Indicators.List['Target Health']:Update(0, 0, 100)
        Menu.Indicators.List['Target Tool']:Update('None')
    end
    
    -- Face Target
    if Locked and Target and Target.Character and Settings.Ragebot.FaceTarget then
        local targetRoot = Target.Character:FindFirstChild("HumanoidRootPart")
        local char = Client.Character
        local charRoot = char and char:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and charRoot then
            charRoot.CFrame = CFrame.new(charRoot.Position, Vector3.new(targetRoot.Position.X, charRoot.Position.Y, targetRoot.Position.Z))
        end
    end
    
    -- Auto Stomp (Tracks Head part like Da Hood)
    if Locked and Target and Target.Character and Settings.Ragebot.AutoStomp and not StompActive then
        local targetChar = Target.Character
        local targetHumanoid = targetChar:FindFirstChild("Humanoid")
        local targetHead = targetChar:FindFirstChild("Head")
        local bodyEffects = targetChar:FindFirstChild("BodyEffects")
        
        -- Check if knocked (HP <= 14 or Dead)
        local knocked = (targetHumanoid and targetHumanoid.Health <= 14) or (bodyEffects and bodyEffects:FindFirstChild("Dead") and bodyEffects.Dead.Value)
        
        if knocked and targetHead then
            local char = Client.Character
            local charRoot = char and char:FindFirstChild("HumanoidRootPart")
            
            -- Only stomp if within 15 studs (close range)
            if charRoot and (targetHead.Position - charRoot.Position).Magnitude <= 15 then
                StompActive = true
                
                -- Disable killbot if it was on
                if Settings.Killbot.Enabled then
                    KillbotWasEnabled = true
                    Settings.Killbot.Enabled = false
                end
                
                task.spawn(function()
                    -- Save original position
                    OriginalPosition = charRoot.CFrame
                    
                    local stompStartTime = tick()
                    local maxStompTime = 5 -- 5 seconds max
                    
                    -- CONTINUOUS tracking connection that FOLLOWS the Head
                    local trackConnection = RunService.RenderStepped:Connect(function()
                        -- Stop if time limit reached
                        if tick() - stompStartTime > maxStompTime then
                            StompActive = false
                            return
                        end
                        
                        -- Get fresh target reference
                        local currentTarget = Target and Target.Character
                        if not currentTarget then
                            StompActive = false
                            return
                        end
                        
                        local currentTargetHead = currentTarget:FindFirstChild("Head")
                        local currentTargetHum = currentTarget:FindFirstChild("Humanoid")
                        
                        if not currentTargetHead or not currentTargetHum or not charRoot then
                            StompActive = false
                            return
                        end
                        
                        -- Check if dead or got up
                        local be = currentTarget:FindFirstChild("BodyEffects")
                        local dead = be and be:FindFirstChild("Dead")
                        if (dead and dead.Value == true) or currentTargetHum.Health > 14 then
                            StompActive = false
                            return
                        end
                        
                        -- TRACK HEAD POSITION CONTINUOUSLY - stay on top of Head
                        local targetPos = currentTargetHead.Position
                        charRoot.CFrame = CFrame.new(targetPos + Vector3.new(0, 1.5, 0))
                    end)
                    
                    -- Separate loop for firing stomp
                    task.spawn(function()
                        while StompActive do
                            -- Fire stomp remote
                            for _, remote in ipairs(RemoteEvents) do
                                if remote and remote:IsA("RemoteEvent") then
                                    pcall(function()
                                        remote:FireServer("Stomp")
                                    end)
                                end
                            end
                            task.wait(0.15)
                        end
                    end)
                    
                    -- Wait for stomp to finish
                    while StompActive do
                        task.wait(0.1)
                    end
                    
                    -- Disconnect tracking
                    if trackConnection then
                        trackConnection:Disconnect()
                    end
                    
                    -- Wait 3 seconds before TPing back
                    task.wait(3)
                    
                    -- TP back to original position INSTANTLY
                    if charRoot and OriginalPosition then
                        charRoot.CFrame = OriginalPosition
                    end
                    
                    -- Re-enable killbot
                    if KillbotWasEnabled then
                        Settings.Killbot.Enabled = true
                        KillbotWasEnabled = false
                    end
                    
                    StompActive = false
                    OriginalPosition = nil
                end)
            end
        end
    end
    
    -- Killbot
    if Locked and Target and Target.Character and Settings.Killbot.Enabled and Settings.Ragebot.Enabled then
        local targetRoot = Target.Character:FindFirstChild("HumanoidRootPart")
        local char = Client.Character
        local charRoot = char and char:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and charRoot then
            if Settings.Killbot.Method == "Orbit" then
                angle_Y = angle_Y + (RunService.Heartbeat:Wait() / Settings.Killbot.Speed) % 1
                charRoot.CFrame = CFrame.new(targetRoot.Position) * CFrame.Angles(0, 2 * math.pi * angle_Y, 0) * CFrame.new(0, Settings.Killbot.Height, Settings.Killbot.Range)
            elseif Settings.Killbot.Method == "Strafe" then
                local randomX = math.random(-Settings.Killbot.Range, Settings.Killbot.Range)
                local randomZ = math.random(-Settings.Killbot.Range, Settings.Killbot.Range)
                charRoot.CFrame = targetRoot.CFrame * CFrame.new(randomX, Settings.Killbot.Height, randomZ)
            elseif Settings.Killbot.Method == "Connection" then
                charRoot.CFrame = targetRoot.CFrame * CFrame.new(0, Settings.Killbot.Height, Settings.Killbot.Range)
            end
        end
        
        -- Auto Equip Tool
        if Settings.Killbot.AutoEquip.Enabled and char then
            local equippedTool = char:FindFirstChildOfClass("Tool")
            local targetToolName = Settings.Killbot.AutoEquip.Tool
            
            -- If no tool equipped or wrong tool equipped
            if not equippedTool or equippedTool.Name ~= targetToolName then
                -- Find tool in backpack
                local backpack = Client:FindFirstChild("Backpack")
                if backpack then
                    local tool = backpack:FindFirstChild(targetToolName)
                    if tool then
                        -- Equip the tool
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid:EquipTool(tool)
                        end
                    end
                end
            end
        end
        
        -- Auto Fire
        if Settings.Killbot.AutoFire then
            local currentTime = tick()
            if currentTime - lastFireTime >= Settings.Killbot.Cooldown then
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then
                    task.spawn(function()
                        tool:Activate()
                        task.wait(Settings.Killbot.FireRate)
                        tool:Deactivate()
                    end)
                    lastFireTime = currentTime
                end
            end
        end
    end
    
    -- Check if target still exists
    if Locked and Target then
        if not Target.Parent or not Target.Character or not Target.Character:FindFirstChild("HumanoidRootPart") then
            Locked = false
            Target = nil
            Menu.Keybinds.List['Ragebot']:Update('Off')
            Menu.Indicators.List['Target Name']:Update('None')
            Notify('winhvh  >  Target lost', 1.5)
            LastHealth = {}
            
            -- Unspectate
            if Settings.Ragebot.Spectate then
                Camera.CameraSubject = Client.Character and Client.Character:FindFirstChild("Humanoid")
            end
        end
    end
end))

-- Snapline Render Loop
RunService.RenderStepped:Connect(LPH_JIT_MAX(function()
    -- Render 3D Circle
    renderCircle3D()
    
    if not Settings.Visuals.Snapline.Enabled or not Locked or not Target or not Target.Character then
        Line.Visible = false
        LineOutline.Visible = false
        return
    end
    
    local targetChar = Target.Character
    local targetPart = targetChar:FindFirstChild(Settings.Ragebot.TargetPart)
    
    if not targetPart then
        Line.Visible = false
        LineOutline.Visible = false
        return
    end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    
    if not onScreen then
        Line.Visible = false
        LineOutline.Visible = false
        return
    end
    
    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
    local fromPos
    
    -- Determine start position based on setting
    if Settings.Visuals.Snapline.Position == "Cursor" then
        fromPos = UserInputService:GetMouseLocation()
    elseif Settings.Visuals.Snapline.Position == "Character" then
        local char = Client.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local charScreen, charOnScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
            if charOnScreen then
                fromPos = Vector2.new(charScreen.X, charScreen.Y)
            else
                Line.Visible = false
                LineOutline.Visible = false
                return
            end
        else
            Line.Visible = false
            LineOutline.Visible = false
            return
        end
    elseif Settings.Visuals.Snapline.Position == "Tool" then
        local char = Client.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            local toolScreen, toolOnScreen = Camera:WorldToViewportPoint(tool.Handle.Position)
            if toolOnScreen then
                fromPos = Vector2.new(toolScreen.X, toolScreen.Y)
            else
                Line.Visible = false
                LineOutline.Visible = false
                return
            end
        else
            -- Fallback to cursor if no tool
            fromPos = UserInputService:GetMouseLocation()
        end
    end
    
    -- Update outline
    LineOutline.From = fromPos
    LineOutline.To = targetPos
    LineOutline.Visible = true
    
    -- Update main line
    Line.From = fromPos
    Line.To = targetPos
    Line.Visible = true
end))

-- Bind menu toggle
ContextAction:BindAction('menuToggle', MenuToggle, false, Settings.Configs.Menu.Keybind)

-- Self-Aura System (from juju.txt)
local CurrentAura = "None"
local AuraInstances = {}
local SelfAuraEnabled = false
local SelfAuraColor = MainColor

local particle_auras = {
    ["starlight"] = "rbxassetid://134645216613107",
    ["heavenly"] = "rbxassetid://139300897520961",
    ["ribbon"] = "rbxassetid://132069507632161",
    ["sakura"] = "rbxassetid://81755778619404",
    ["angel"] = "rbxassetid://97658130917593",
    ["wind"] = "rbxassetid://80694081850877",
    ["flow"] = "rbxassetid://119913533725648",
    ["star"] = "rbxassetid://73754563740680",
}

local function removeSelfAura()
    for _, instance in pairs(AuraInstances) do
        if instance and instance.Parent then
            instance:Destroy()
        end
    end
    AuraInstances = {}
end

local function applySelfAura(character, auraType)
    if not character or not SelfAuraEnabled then return end
    
    -- Clean up old aura
    removeSelfAura()
    
    if auraType == "None" then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Get aura asset ID
    local auraLower = string.lower(auraType)
    local assetId = particle_auras[auraLower]
    
    if not assetId then return end
    
    -- Load aura model from asset
    local success, auraModel = pcall(function()
        return game:GetObjects(assetId)[1]
    end)
    
    if success and auraModel then
        -- Parent to character
        auraModel.Parent = character
        table.insert(AuraInstances, auraModel)
        
        -- Find all attachments and parent them to HumanoidRootPart
        for _, child in pairs(auraModel:GetDescendants()) do
            if child:IsA("Attachment") then
                child.Parent = rootPart
                table.insert(AuraInstances, child)
            elseif child:IsA("ParticleEmitter") then
                -- Apply color to particles
                child.Color = ColorSequence.new(SelfAuraColor)
                table.insert(AuraInstances, child)
            elseif child:IsA("Beam") or child:IsA("Trail") then
                -- Apply color to beams/trails
                if child:IsA("Beam") then
                    child.Color = ColorSequence.new(SelfAuraColor)
                elseif child:IsA("Trail") then
                    child.Color = ColorSequence.new(SelfAuraColor)
                end
                table.insert(AuraInstances, child)
            end
        end
    end
end

-- Monitor character respawns
Client.CharacterAdded:Connect(function(character)
    -- Reapply aura
    if CurrentAura and CurrentAura ~= "None" and SelfAuraEnabled then
        character:WaitForChild("HumanoidRootPart")
        task.wait(0.5)
        applySelfAura(character, CurrentAura)
    end
    
    -- Clear material storage for new character
    OriginalMaterials = {}
    
    -- Reapply character material
    if MaterialEnabled then
        character:WaitForChild("HumanoidRootPart")
        task.wait(0.5)
        applyCharacterMaterial()
    end
    
    -- Monitor tool equips for tool material
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and ToolMaterialEnabled then
            task.wait(0.1)
            applyToolMaterial()
        end
    end)
end)

-- Monitor current character's tool equips
if Client.Character then
    Client.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and ToolMaterialEnabled then
            task.wait(0.1)
            applyToolMaterial()
        end
    end)
end

-- Welcome notification
task.wait(0.5)
Menu.Notify('winhvh  >  Loaded, welcome <font color="#' .. tostring(MainColor:ToHex()) .. '">' .. Client.Name .. '</font>', 3)
