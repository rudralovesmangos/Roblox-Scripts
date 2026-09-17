local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local WeaponHit = ReplicatedStorage
	:WaitForChild("WeaponsSystem")
	:WaitForChild("Network")
	:WaitForChild("WeaponHit")

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTargetGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 190)
Main.Position = UDim2.new(0.5, -160, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

--// Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "All Players"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

--// Exclude label
local ExcludeLabel = Instance.new("TextLabel")
ExcludeLabel.Size = UDim2.new(1, -20, 0, 20)
ExcludeLabel.Position = UDim2.new(0, 10, 0, 43)
ExcludeLabel.BackgroundTransparency = 1
ExcludeLabel.Text = "Players to exclude:"
ExcludeLabel.TextColor3 = Color3.new(1, 1, 1)
ExcludeLabel.TextSize = 14
ExcludeLabel.Font = Enum.Font.Gotham
ExcludeLabel.TextXAlignment = Enum.TextXAlignment.Left
ExcludeLabel.Parent = Main

--// Exclude textbox
local ExcludeBox = Instance.new("TextBox")
ExcludeBox.Size = UDim2.new(1, -20, 0, 35)
ExcludeBox.Position = UDim2.new(0, 10, 0, 65)
ExcludeBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ExcludeBox.BorderSizePixel = 0
ExcludeBox.PlaceholderText = "username, username2, username3"
ExcludeBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ExcludeBox.Text = ""
ExcludeBox.TextColor3 = Color3.new(1, 1, 1)
ExcludeBox.TextSize = 14
ExcludeBox.Font = Enum.Font.Gotham
ExcludeBox.ClearTextOnFocus = false
ExcludeBox.TextXAlignment = Enum.TextXAlignment.Left
ExcludeBox.Parent = Main

local ExcludeCorner = Instance.new("UICorner")
ExcludeCorner.CornerRadius = UDim.new(0, 6)
ExcludeCorner.Parent = ExcludeBox

--// Toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 120)
ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = Main

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local Enabled = false

--// Find matching player
local function FindPlayer(Input)
	Input = Input:gsub("^%s+", ""):gsub("%s+$", "")

	if Input == "" then
		return nil
	end

	local LowerInput = string.lower(Input)

	for _, Player in ipairs(Players:GetPlayers()) do
		if string.lower(Player.Name) == LowerInput then
			return Player
		end
	end

	for _, Player in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(Player.Name), 1, #LowerInput) == LowerInput then
			return Player
		end
	end

	for _, Player in ipairs(Players:GetPlayers()) do
		if string.lower(Player.DisplayName) == LowerInput then
			return Player
		end
	end

	for _, Player in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(Player.DisplayName), 1, #LowerInput) == LowerInput then
			return Player
		end
	end

	return nil
end

--// Complete the username currently being typed
local function CompleteCurrentUsername()
	local Text = ExcludeBox.Text

	local LastComma = string.match(Text, ".*(),")

	local Prefix
	local CurrentText

	if LastComma then
		Prefix = string.sub(Text, 1, LastComma)
		CurrentText = string.sub(Text, LastComma + 1)
	else
		Prefix = ""
		CurrentText = Text
	end

	CurrentText = CurrentText:gsub("^%s+", ""):gsub("%s+$", "")

	if CurrentText == "" then
		return
	end

	local Player = FindPlayer(CurrentText)

	if Player then
		ExcludeBox.Text = Prefix .. Player.Name .. ", "

		task.defer(function()
			ExcludeBox.CursorPosition = #ExcludeBox.Text + 1
		end)
	end
end

--// Detect Enter from physical keyboard
ExcludeBox.FocusLost:Connect(function(EnterPressed)
	if EnterPressed then
		CompleteCurrentUsername()
	end
end)

--// Detect Enter/Return from the on-screen keyboard
ExcludeBox.ReturnPressedFromOnScreenKeyboard:Connect(function()
	CompleteCurrentUsername()
end)

--// Get excluded usernames
local function GetExcludedPlayers()
	local Excluded = {}

	for Username in string.gmatch(ExcludeBox.Text, "[^,]+") do
		Username = Username:gsub("^%s+", ""):gsub("%s+$", "")

		if Username ~= "" then
			Excluded[string.lower(Username)] = true
		end
	end

	return Excluded
end

--// Get currently equipped Tool
local function GetEquippedTool()
	local Character = LocalPlayer.Character

	if not Character then
		return nil
	end

	for _, Item in ipairs(Character:GetChildren()) do
		if Item:IsA("Tool") then
			return Item
		end
	end

	return nil
end

--// Fire at one player
local function FireAtPlayer(Player)
	local Character = Player.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	local TargetPart =
		Character:FindFirstChild("LeftHand")
		or Character:FindFirstChild("RightHand")
		or Character:FindFirstChild("HumanoidRootPart")

	local MyCharacter = LocalPlayer.Character

	if not MyCharacter then
		return
	end

	local Weapon = GetEquippedTool()

	if not Weapon or not Humanoid or not TargetPart then
		return
	end

	local TargetPosition = TargetPart.Position
	local OriginPosition = MyCharacter:GetPivot().Position
	local Difference = TargetPosition - OriginPosition

	local Direction

	if Difference.Magnitude > 0 then
		Direction = Difference.Unit
	else
		Direction = Vector3.new(0, 0, -1)
	end

	local args = {
		[1] = Weapon,

		[2] = {
			["p"] = TargetPosition,
			["pid"] = 1,
			["part"] = TargetPart,
			["d"] = Difference.Magnitude,
			["maxDist"] = Difference.Magnitude,
			["h"] = Humanoid,
			["m"] = TargetPart.Material,
			["sid"] = 35,
			["t"] = 0,
			["n"] = Direction
		}
	}

	WeaponHit:FireServer(unpack(args))
end

--// Fire at every player except local player and excluded players
local function FireAtAllPlayers()
	local Excluded = GetExcludedPlayers()

	for _, Player in ipairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer
			and not Excluded[string.lower(Player.Name)] then

			FireAtPlayer(Player)
		end
	end
end

--// Toggle
ToggleButton.MouseButton1Click:Connect(function()
	Enabled = not Enabled

	if Enabled then
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 130, 70)
	else
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
	end
end)

--// Heartbeat loop
RunService.Heartbeat:Connect(function()
	if Enabled then
		FireAtAllPlayers()
	end
end)

--// Dragging
local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = input.Position
		StartPosition = Main.Position
	end
end)

Title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not Dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local Delta = input.Position - DragStart

	Main.Position = UDim2.new(
		StartPosition.X.Scale,
		StartPosition.X.Offset + Delta.X,

		StartPosition.Y.Scale,
		StartPosition.Y.Offset + Delta.Y
	)
end)
