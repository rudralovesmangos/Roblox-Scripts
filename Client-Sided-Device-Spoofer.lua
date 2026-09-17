--// Client-Side Device Selector
--// Place this LocalScript inside:
--// StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Prevent duplicates if the script somehow runs again
local oldGui = playerGui:FindFirstChild("DeviceSelector")
if oldGui then
	oldGui:Destroy()
end

--==================================================
-- SETTINGS
--==================================================

local selectedDevice = "Mobile"

--==================================================
-- GUI
--==================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeviceSelector"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 250, 0, 280)
main.Position = UDim2.new(0.5, -125, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Cover the bottom corners of the title bar
local titleCover = Instance.new("Frame")
titleCover.Size = UDim2.new(1, 0, 0, 10)
titleCover.Position = UDim2.new(0, 0, 1, -10)
titleCover.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleCover.BorderSizePixel = 0
titleCover.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Device Selector"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Current device label
local currentLabel = Instance.new("TextLabel")
currentLabel.Size = UDim2.new(1, -20, 0, 35)
currentLabel.Position = UDim2.new(0, 10, 0, 55)
currentLabel.BackgroundTransparency = 1
currentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentLabel.TextSize = 15
currentLabel.Font = Enum.Font.Gotham
currentLabel.Parent = main

-- Buttons container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 0, 175)
container.Position = UDim2.new(0, 10, 0, 95)
container.BackgroundTransparency = 1
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

--==================================================
-- DEVICE BUTTONS
--==================================================

local devices = {
	{
		Name = "Mobile",
		Icon = "📱"
	},
	{
		Name = "PC",
		Icon = "🖥️"
	},
	{
		Name = "Console",
		Icon = "🎮"
	},
	{
		Name = "VR",
		Icon = "🥽"
	}
}

local buttons = {}

local function updateButtons()
	currentLabel.Text = "Selected device: " .. selectedDevice

	for deviceName, button in pairs(buttons) do
		if deviceName == selectedDevice then
			button.BackgroundColor3 = Color3.fromRGB(55, 120, 210)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			button.TextColor3 = Color3.fromRGB(210, 210, 210)
		end
	end
end

for index, device in ipairs(devices) do
	local button = Instance.new("TextButton")

	button.Name = device.Name
	button.Size = UDim2.new(1, 0, 0, 38)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.BorderSizePixel = 0
	button.Text = device.Icon .. "  " .. device.Name
	button.TextColor3 = Color3.fromRGB(210, 210, 210)
	button.TextSize = 15
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = false
	button.LayoutOrder = index
	button.Parent = container

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 7)
	buttonCorner.Parent = button

	button.MouseButton1Click:Connect(function()
		selectedDevice = device.Name

		-- This is CLIENT-SIDE ONLY.
		-- It does not tell the Roblox server that your device changed.
		updateButtons()

		print("Client device selected:", selectedDevice)
	end)

	buttons[device.Name] = button
end

updateButtons()

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- EXAMPLE:
-- Access the selected device from elsewhere
--==================================================

_G.SelectedDevice = function()
	return selectedDevice
end
