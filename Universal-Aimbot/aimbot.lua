-- Rudra's Aimbot (Scriptable + 3-State Mode + Collapsible Dropdown + Looptp + Search + ESP + Wall Nudge + Noclip + Exact Walkspeed + InfJump)
-- Walkspeed textbox = EXACT AssemblyLinearVelocity. Instant start/stop on input.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== CONFIG ==========
local FOV_RADIUS = 150
local AIMBOT_ENABLED = false
local FOV_ENABLED = true
local LOOPTP_ENABLED = false
local ESP_ENABLED = false
local NOCLIP_ENABLED = false
local WALKSPEED_ENABLED = false
local INFJUMP_ENABLED = false
local LOOPTP_DISTANCE = 5
local LOOPTP_WALL_CHECK_DIST = 3
local LOOPTP_NUDGE_DIST = 1.5
local TARGET_PART = "Head"
local LOCK_MODE = "Middle"
local SELECTED_PLAYER = nil
local DROPDOWN_OPEN = false
local SEARCH_TEXT = ""
local ORIGINAL_CAMERA_TYPE = Camera.CameraType

-- Walkspeed / Jump (EXACT values, no multiplier)
local WALKSPEED_VALUE = 32   -- exact AssemblyLinearVelocity magnitude
local JUMP_FORCE = 75

-- ESP tuning
local ESP_MAX_TEXT_SIZE = 22
local ESP_MIN_TEXT_SIZE = 10
local ESP_SCALE_REF = 60
local ESP_SCALE_FACTOR = 1.4

-- ========== FOV CIRCLE ==========
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Radius = FOV_RADIUS
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = FOV_ENABLED
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- ========== RAINBOW ==========
local function getRainbowColor()
    local t = tick()
    local r = math.sin(t * 0.8) * 127 + 128
    local g = math.sin(t * 0.8 + 2) * 127 + 128
    local b = math.sin(t * 0.8 + 4) * 127 + 128
    return Color3.fromRGB(r, g, b)
end

-- ========== CORE GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RudraAimbot"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 400)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(80, 80, 80)
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Rudra's Aimbot"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Row 1: FOV + AIM
local fovBtn = Instance.new("TextButton")
fovBtn.Size = UDim2.new(0.45, 0, 0, 26)
fovBtn.Position = UDim2.new(0.03, 0, 0.10, 0)
fovBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovBtn.Text = "FOV: ON"
fovBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
fovBtn.Font = Enum.Font.Gotham
fovBtn.TextSize = 11
fovBtn.Parent = mainFrame
Instance.new("UICorner", fovBtn).CornerRadius = UDim.new(0, 5)

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(0.45, 0, 0, 26)
aimBtn.Position = UDim2.new(0.52, 0, 0.10, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimBtn.Text = "AIM: OFF"
aimBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
aimBtn.Font = Enum.Font.Gotham
aimBtn.TextSize = 11
aimBtn.Parent = mainFrame
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0, 5)

-- Row 2: Looptp + Mode
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.45, 0, 0, 26)
tpBtn.Position = UDim2.new(0.03, 0, 0.19, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tpBtn.Text = "Looptp: OFF"
tpBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
tpBtn.Font = Enum.Font.Gotham
tpBtn.TextSize = 11
tpBtn.Parent = mainFrame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.45, 0, 0, 26)
modeBtn.Position = UDim2.new(0.52, 0, 0.19, 0)
modeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
modeBtn.Text = "Mode: Middle"
modeBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 11
modeBtn.Parent = mainFrame
Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 5)

local arrowBtn = Instance.new("TextButton")
arrowBtn.Size = UDim2.new(0.10, 0, 0, 26)
arrowBtn.Position = UDim2.new(0.87, 0, 0.19, 0)
arrowBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
arrowBtn.Text = "▼"
arrowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
arrowBtn.Font = Enum.Font.Gotham
arrowBtn.TextSize = 11
arrowBtn.Visible = false
arrowBtn.Parent = mainFrame
Instance.new("UICorner", arrowBtn).CornerRadius = UDim.new(0, 5)

-- Row 3: ESP + Noclip
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.45, 0, 0, 26)
espBtn.Position = UDim2.new(0.03, 0, 0.28, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espBtn.Text = "ESP: OFF"
espBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
espBtn.Font = Enum.Font.Gotham
espBtn.TextSize = 11
espBtn.Parent = mainFrame
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 5)

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.45, 0, 0, 26)
noclipBtn.Position = UDim2.new(0.52, 0, 0.28, 0)
noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 11
noclipBtn.Parent = mainFrame
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 5)

-- Row 4: Speed toggle + exact value textbox
local wsBtn = Instance.new("TextButton")
wsBtn.Size = UDim2.new(0.45, 0, 0, 26)
wsBtn.Position = UDim2.new(0.03, 0, 0.37, 0)
wsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wsBtn.Text = "Speed: OFF"
wsBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
wsBtn.Font = Enum.Font.Gotham
wsBtn.TextSize = 11
wsBtn.Parent = mainFrame
Instance.new("UICorner", wsBtn).CornerRadius = UDim.new(0, 5)

local wsInput = Instance.new("TextBox")
wsInput.Size = UDim2.new(0.45, 0, 0, 26)
wsInput.Position = UDim2.new(0.52, 0, 0.37, 0)
wsInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
wsInput.Text = tostring(WALKSPEED_VALUE)
wsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
wsInput.Font = Enum.Font.Gotham
wsInput.TextSize = 11
wsInput.Parent = mainFrame
Instance.new("UICorner", wsInput).CornerRadius = UDim.new(0, 5)

-- Row 5: Inf Jump toggle + textbox
local ijBtn = Instance.new("TextButton")
ijBtn.Size = UDim2.new(0.45, 0, 0, 26)
ijBtn.Position = UDim2.new(0.03, 0, 0.46, 0)
ijBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ijBtn.Text = "InfJump: OFF"
ijBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ijBtn.Font = Enum.Font.Gotham
ijBtn.TextSize = 11
ijBtn.Parent = mainFrame
Instance.new("UICorner", ijBtn).CornerRadius = UDim.new(0, 5)

local ijInput = Instance.new("TextBox")
ijInput.Size = UDim2.new(0.45, 0, 0, 26)
ijInput.Position = UDim2.new(0.52, 0, 0.46, 0)
ijInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ijInput.Text = tostring(JUMP_FORCE)
ijInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ijInput.Font = Enum.Font.Gotham
ijInput.TextSize = 11
ijInput.Parent = mainFrame
Instance.new("UICorner", ijInput).CornerRadius = UDim.new(0, 5)

-- Dropdown (search + list)
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.94, 0, 0, 82)
dropdownFrame.Position = UDim2.new(0.03, 0, 0.56, 0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.Parent = mainFrame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 4)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -8, 0, 20)
searchBox.Position = UDim2.new(0, 4, 0, 4)
searchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
searchBox.Text = ""
searchBox.PlaceholderText = "Search username..."
searchBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 11
searchBox.ClearTextOnFocus = false
searchBox.Parent = dropdownFrame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(1, -8, 1, -30)
dropdownList.Position = UDim2.new(0, 4, 0, 28)
dropdownList.BackgroundTransparency = 1
dropdownList.BorderSizePixel = 0
dropdownList.ScrollBarThickness = 4
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.Parent = dropdownFrame

local ddLayout = Instance.new("UIListLayout")
ddLayout.Padding = UDim.new(0, 2)
ddLayout.Parent = dropdownList

-- FOV Size
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.4, 0, 0, 20)
fovLabel.Position = UDim2.new(0.03, 0, 0.90, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Size:"
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 10
fovLabel.Parent = mainFrame

local fovInput = Instance.new("TextBox")
fovInput.Size = UDim2.new(0.4, 0, 0, 22)
fovInput.Position = UDim2.new(0.45, 0, 0.90, 0)
fovInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
fovInput.Text = tostring(FOV_RADIUS)
fovInput.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInput.Font = Enum.Font.Gotham
fovInput.TextSize = 11
fovInput.Parent = mainFrame
Instance.new("UICorner", fovInput).CornerRadius = UDim.new(0, 4)

-- ========== ESP SYSTEM ==========
local espEntries = {}

local function createESPForPlayer(player)
    if player == LocalPlayer or espEntries[player] then return end
    local hl = Instance.new("Highlight")
    hl.Name = "RudraESP_" .. player.Name
    hl.Adornee = player.Character
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.FillTransparency = 0.55
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = screenGui

    local nameDraw = Drawing.new("Text")
    nameDraw.Size = 14
    nameDraw.Center = true
    nameDraw.Outline = true
    nameDraw.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameDraw.Color = Color3.fromRGB(255, 255, 255)
    nameDraw.Visible = false

    local distDraw = Drawing.new("Text")
    distDraw.Size = 12
    distDraw.Center = true
    distDraw.Outline = true
    distDraw.OutlineColor = Color3.fromRGB(0, 0, 0)
    distDraw.Color = Color3.fromRGB(0, 255, 255)
    distDraw.Visible = false

    espEntries[player] = { highlight = hl, nameDraw = nameDraw, distDraw = distDraw }
end

local function destroyESPForPlayer(player)
    local entry = espEntries[player]
    if not entry then return end
    if entry.highlight then entry.highlight:Destroy() end
    if entry.nameDraw then entry.nameDraw:Remove() end
    if entry.distDraw then entry.distDraw:Remove() end
    espEntries[player] = nil
end

local function refreshESPTargets()
    if not ESP_ENABLED then
        for p, _ in pairs(espEntries) do destroyESPForPlayer(p) end
        return
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local allowed = true
            if LOCK_MODE == "Username" and SELECTED_PLAYER then
                allowed = (player == SELECTED_PLAYER)
            end
            if allowed then createESPForPlayer(player) else destroyESPForPlayer(player) end
        end
    end
    for p, _ in pairs(espEntries) do
        if not p.Parent then destroyESPForPlayer(p) end
    end
end

-- ========== DROPDOWN ==========
local function refreshDropdown()
    for _, child in pairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end
    local query = string.lower(SEARCH_TEXT)
    local hasAnyone = false
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if query == "" or string.find(string.lower(player.Name), query, 1, true) then
                hasAnyone = true
                local entry = Instance.new("TextButton")
                entry.Size = UDim2.new(1, -4, 0, 20)
                entry.BackgroundColor3 = (SELECTED_PLAYER == player) and Color3.fromRGB(0, 120, 80) or Color3.fromRGB(45, 45, 45)
                entry.Text = player.Name
                entry.TextColor3 = Color3.fromRGB(255, 255, 255)
                entry.Font = Enum.Font.Gotham
                entry.TextSize = 11
                entry.Parent = dropdownList
                entry.MouseButton1Click:Connect(function()
                    SELECTED_PLAYER = player
                    refreshDropdown()
                    refreshESPTargets()
                end)
            end
        end
    end
    if not hasAnyone then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -4, 0, 20)
        empty.BackgroundTransparency = 1
        empty.Text = query == "" and "(no players)" or "(no match)"
        empty.TextColor3 = Color3.fromRGB(150, 150, 150)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 11
        empty.Parent = dropdownList
    end
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, ddLayout.AbsoluteContentSize.Y)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    SEARCH_TEXT = searchBox.Text
    refreshDropdown()
end)

Players.PlayerAdded:Connect(function()
    if LOCK_MODE == "Username" and DROPDOWN_OPEN then refreshDropdown() end
    if ESP_ENABLED then refreshESPTargets() end
end)
Players.PlayerRemoving:Connect(function(p)
    if SELECTED_PLAYER == p then SELECTED_PLAYER = nil end
    destroyESPForPlayer(p)
    if LOCK_MODE == "Username" and DROPDOWN_OPEN then refreshDropdown() end
end)

-- ========== TOGGLES ==========
fovBtn.MouseButton1Click:Connect(function()
    FOV_ENABLED = not FOV_ENABLED
    fovBtn.Text = FOV_ENABLED and "FOV: ON" or "FOV: OFF"
    fovBtn.TextColor3 = FOV_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    fovCircle.Visible = FOV_ENABLED
end)

aimBtn.MouseButton1Click:Connect(function()
    AIMBOT_ENABLED = not AIMBOT_ENABLED
    aimBtn.Text = AIMBOT_ENABLED and "AIM: ON" or "AIM: OFF"
    aimBtn.TextColor3 = AIMBOT_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if AIMBOT_ENABLED then Camera.CameraType = Enum.CameraType.Scriptable
    else Camera.CameraType = ORIGINAL_CAMERA_TYPE end
end)

tpBtn.MouseButton1Click:Connect(function()
    LOOPTP_ENABLED = not LOOPTP_ENABLED
    tpBtn.Text = LOOPTP_ENABLED and "Looptp: ON" or "Looptp: OFF"
    tpBtn.TextColor3 = LOOPTP_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

espBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espBtn.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
    espBtn.TextColor3 = ESP_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    refreshESPTargets()
end)

noclipBtn.MouseButton1Click:Connect(function()
    NOCLIP_ENABLED = not NOCLIP_ENABLED
    noclipBtn.Text = NOCLIP_ENABLED and "Noclip: ON" or "Noclip: OFF"
    noclipBtn.TextColor3 = NOCLIP_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if not NOCLIP_ENABLED then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

wsBtn.MouseButton1Click:Connect(function()
    WALKSPEED_ENABLED = not WALKSPEED_ENABLED
    wsBtn.Text = WALKSPEED_ENABLED and "Speed: ON" or "Speed: OFF"
    wsBtn.TextColor3 = WALKSPEED_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

ijBtn.MouseButton1Click:Connect(function()
    INFJUMP_ENABLED = not INFJUMP_ENABLED
    ijBtn.Text = INFJUMP_ENABLED and "InfJump: ON" or "InfJump: OFF"
    ijBtn.TextColor3 = INFJUMP_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- ========== MODE ==========
local function applyModeUI()
    if LOCK_MODE == "Middle" then
        modeBtn.Text = "Mode: Middle"
        modeBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
        arrowBtn.Visible = false
        dropdownFrame.Visible = false
        DROPDOWN_OPEN = false
        SELECTED_PLAYER = nil
    elseif LOCK_MODE == "Closest" then
        modeBtn.Text = "Mode: Closest"
        modeBtn.TextColor3 = Color3.fromRGB(255, 165, 0)
        arrowBtn.Visible = false
        dropdownFrame.Visible = false
        DROPDOWN_OPEN = false
        SELECTED_PLAYER = nil
    else
        modeBtn.Text = "Mode: Username"
        modeBtn.TextColor3 = Color3.fromRGB(255, 0, 255)
        arrowBtn.Visible = true
        dropdownFrame.Visible = DROPDOWN_OPEN
    end
    if ESP_ENABLED then refreshESPTargets() end
end

modeBtn.MouseButton1Click:Connect(function()
    if LOCK_MODE == "Middle" then LOCK_MODE = "Closest"
    elseif LOCK_MODE == "Closest" then
        LOCK_MODE = "Username"
        DROPDOWN_OPEN = false
        refreshDropdown()
    else LOCK_MODE = "Middle" end
    applyModeUI()
end)

arrowBtn.MouseButton1Click:Connect(function()
    DROPDOWN_OPEN = not DROPDOWN_OPEN
    dropdownFrame.Visible = DROPDOWN_OPEN
    arrowBtn.Text = DROPDOWN_OPEN and "▲" or "▼"
    if DROPDOWN_OPEN then refreshDropdown() end
end)

-- ========== INPUT VALIDATION ==========
fovInput.FocusLost:Connect(function()
    local num = tonumber(fovInput.Text)
    if num and num > 10 and num < 1000 then
        FOV_RADIUS = num; fovCircle.Radius = num
    else fovInput.Text = tostring(FOV_RADIUS) end
end)

wsInput.FocusLost:Connect(function()
    local num = tonumber(wsInput.Text)
    -- Exact value, any positive number
    if num and num > 0 then
        WALKSPEED_VALUE = num
    else
        wsInput.Text = tostring(WALKSPEED_VALUE)
    end
end)

ijInput.FocusLost:Connect(function()
    local num = tonumber(ijInput.Text)
    if num and num > 0 then
        JUMP_FORCE = num
    else
        ijInput.Text = tostring(JUMP_FORCE)
    end
end)

-- ========== TARGET SELECTION ==========
local function isValidTarget(player)
    if player == LocalPlayer or not player.Character then return false end
    local part = player.Character:FindFirstChild(TARGET_PART)
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    return part ~= nil and hum ~= nil and hum.Health > 0
end

local function getClosestToCenter()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest, closestDist = nil, FOV_RADIUS
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local part = player.Character:FindFirstChild(TARGET_PART)
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < closestDist then closestDist = dist; closest = part end
            end
        end
    end
    return closest
end

local function getClosestInWorkspace()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, closestDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local part = player.Character:FindFirstChild(TARGET_PART)
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if screenDist <= FOV_RADIUS then
                    local worldDist = (part.Position - myRoot.Position).Magnitude
                    if worldDist < closestDist then closestDist = worldDist; closest = part end
                end
            end
        end
    end
    return closest
end

local function getSelectedPlayerPart()
    if not SELECTED_PLAYER or not isValidTarget(SELECTED_PLAYER) then return nil end
    return SELECTED_PLAYER.Character:FindFirstChild(TARGET_PART)
end

-- ========== RENDER LOOP ==========
RunService:BindToRenderStep("RudraAimbot", Enum.RenderPriority.Camera.Value + 1, function()
    if FOV_ENABLED then
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Color = getRainbowColor()
    end

    if AIMBOT_ENABLED then
        if Camera.CameraType ~= Enum.CameraType.Scriptable then Camera.CameraType = Enum.CameraType.Scriptable end
        local target
        if LOCK_MODE == "Username" then target = getSelectedPlayerPart()
        elseif LOCK_MODE == "Closest" then target = getClosestInWorkspace()
        else target = getClosestToCenter() end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end

    if ESP_ENABLED then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        for player, entry in pairs(espEntries) do
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 and myRoot then
                local worldPos = head.Position + Vector3.new(0, 1.5, 0)
                local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
                local studs = (head.Position - myRoot.Position).Magnitude
                if onScreen then
                    local scale = ESP_SCALE_REF / math.max(studs, 5)
                    local textSize = math.clamp(ESP_MIN_TEXT_SIZE + scale * ESP_SCALE_FACTOR * 4, ESP_MIN_TEXT_SIZE, ESP_MAX_TEXT_SIZE)
                    local distSize = math.clamp(textSize - 3, ESP_MIN_TEXT_SIZE - 2, ESP_MAX_TEXT_SIZE - 3)
                    entry.nameDraw.Text = player.Name
                    entry.nameDraw.Position = Vector2.new(screenPos.X, screenPos.Y - textSize - 2)
                    entry.nameDraw.Size = textSize
                    entry.nameDraw.Visible = true
                    entry.distDraw.Text = string.format("[%d studs]", math.floor(studs))
                    entry.distDraw.Position = Vector2.new(screenPos.X, screenPos.Y)
                    entry.distDraw.Size = distSize
                    entry.distDraw.Visible = true
                    entry.highlight.Adornee = char
                    entry.highlight.Enabled = true
                else
                    entry.nameDraw.Visible = false
                    entry.distDraw.Visible = false
                    entry.highlight.Enabled = false
                end
            else
                entry.nameDraw.Visible = false
                entry.distDraw.Visible = false
                entry.highlight.Enabled = false
            end
        end
    end
end)

-- ========== NOCLIP LOOP ==========
RunService.Stepped:Connect(function()
    if not NOCLIP_ENABLED then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
    end
end)

-- ========== WALKSPEED (Exact velocity, instant start/stop) ==========
RunService.Heartbeat:Connect(function()
    if not WALKSPEED_ENABLED then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local moveDir = hum.MoveDirection
    local currentVel = root.AssemblyLinearVelocity

    if moveDir.Magnitude > 0.1 then
        -- Moving: set exact horizontal velocity from the textbox value
        root.AssemblyLinearVelocity = Vector3.new(
            moveDir.X * WALKSPEED_VALUE,
            currentVel.Y,
            moveDir.Z * WALKSPEED_VALUE
        )
    else
        -- Not moving: INSTANT STOP (horizontal only, keep gravity)
        if math.abs(currentVel.X) > 0.01 or math.abs(currentVel.Z) > 0.01 then
            root.AssemblyLinearVelocity = Vector3.new(0, currentVel.Y, 0)
        end
    end
end)

-- ========== INFINITE JUMP (AssemblyLinearVelocity) ==========
UserInputService.JumpRequest:Connect(function()
    if not INFJUMP_ENABLED then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local vel = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(vel.X, JUMP_FORCE, vel.Z)
    end
end)

-- ========== LOOPTP (Heartbeat) ==========
RunService.Heartbeat:Connect(function()
    if not LOOPTP_ENABLED then return end
    if LOCK_MODE ~= "Username" or not SELECTED_PLAYER then return end
    if not isValidTarget(SELECTED_PLAYER) then return end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local theirRoot = SELECTED_PLAYER.Character:FindFirstChild("HumanoidRootPart")
    if myRoot and theirRoot then
        local behindPos = theirRoot.Position - (theirRoot.CFrame.LookVector * LOOPTP_DISTANCE)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { myChar, SELECTED_PLAYER.Character }
        params.IgnoreWater = true
        local moveDir = (behindPos - myRoot.Position)
        if moveDir.Magnitude > 0.1 then
            moveDir = moveDir.Unit
            local wallHit = workspace:Raycast(myRoot.Position, moveDir * LOOPTP_WALL_CHECK_DIST, params)
            if wallHit then behindPos = behindPos + (moveDir * LOOPTP_NUDGE_DIST) end
        end
        myRoot.CFrame = CFrame.new(behindPos, theirRoot.Position)
    end
end)

print("[Rudra] Aimbot loaded. Speed = exact velocity. Instant start/stop.")
