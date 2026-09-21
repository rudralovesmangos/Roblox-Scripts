local args = {
    [1] = "throw"
}

game:GetService("ReplicatedStorage").HugRemotes.HugRequest:FireServer(unpack(args))
