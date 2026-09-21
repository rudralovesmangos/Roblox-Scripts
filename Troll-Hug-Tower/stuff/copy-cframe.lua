local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local chter = lplr.Character or CharacterAdded:Wait("Character")
local humanoid = chter.Humanoid
local hrp = chter.HumanoidRootPart

setclipboard(tostring(hrp.CFrame))
print(tostring(hrp.CFrame))
