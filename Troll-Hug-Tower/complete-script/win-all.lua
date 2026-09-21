-- variables
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local chter = lplr.Character or lplr.CharacterAdded:Wait()
local human = chter:FindFirstChild("Humanoid")
local hrp = chter:FindFirstChild("HumanoidRootPart")

-- functions

function teleport()
hrp:PivotTo(CFrame.new(-1.0330528, 403.153015, -105.868423, 0.999312282, -0.00748586934, 0.0363163985, 5.71972636e-10, 0.979409277, 0.201884806, -0.0370799005, -0.201745972, 0.978735745))
print("Teleported!")

end

function hug(username)

local args = {
    [1] = "tryGrab",
    [2] = username
}

game:GetService("ReplicatedStorage").HugRemotes.HugRequest:FireServer(unpack(args))

end

function drop()
local args = {
    [1] = "throw"
}

game:GetService("ReplicatedStorage").HugRemotes.HugRequest:FireServer(unpack(args))
end

-- hug and teleport

teleport()

for _, player in pairs(plrs:GetPlayers()) do
local user = player
local userchter = user.Character
local user_name = user.Name
if userchter == nil then

continue

end
hug(userchter)
print("Hugged: " .. user_name)

task.wait(0.5)

drop()
print("Dropped: " .. user_name)

task.wait(0.5)


end
