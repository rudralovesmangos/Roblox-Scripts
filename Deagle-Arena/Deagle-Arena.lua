local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lplr = Players.LocalPlayer
local NetworkRemote = ReplicatedStorage.Modules.Packages.Network.NetworkRemote
local NetworkRemoteFunction = ReplicatedStorage.Modules.Packages.Network.NetworkRemoteFunction

while true do
    local cam = workspace.CurrentCamera

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lplr then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root then
                local startTime = os.clock()

                while os.clock() - startTime < 0.1 do
                    -- Refresh the player's character/root
                    character = player.Character
                    root = character and character:FindFirstChild("HumanoidRootPart")

                    local myCharacter = lplr.Character

                    if root and myCharacter then
                        myCharacter:PivotTo(root.CFrame)

                        cam.CFrame = CFrame.lookAt(
                            cam.CFrame.Position,
                            root.Position
                        )

                        NetworkRemote:FireServer(
                            "PingReply",
                            tostring(root.CFrame)
                        )
                    end

                    task.wait()
                end

                print("Finished:", player.Name)
            end
        end
    end

    -- Check whether we died
    local character = lplr.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if humanoid and root and humanoid.Health <= 0 then
        local lplrc = root.CFrame

        NetworkRemoteFunction:InvokeServer(
            "Deploy",
            "Spawn@" .. tostring(lplrc)
        )

        local newCharacter = lplr.Character

        if not newCharacter or newCharacter == character then
            newCharacter = lplr.CharacterAdded:Wait()
        end

        newCharacter:WaitForChild("HumanoidRootPart")

        print("Respawned, continuing...")
    end

    task.wait()
end
