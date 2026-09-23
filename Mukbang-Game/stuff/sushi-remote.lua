local args = {
    [1] = {
        [1] = "Salmon Maki",
        [2] = "Salmon Roe Maki",
        [3] = "2x Salmon Maki",
        [4] = "Tuna Maki",
        [5] = "Tuna Roe Maki",
        [6] = "2x Tuna Maki",
        [7] = "Trout Maki",
        [8] = "Trout Roe Maki"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceSushiOrder:FireServer(unpack(args))
