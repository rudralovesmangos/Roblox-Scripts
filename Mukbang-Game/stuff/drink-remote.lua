local args = {
    [1] = {
        [1] = "Water",
        [2] = "Apple Juice",
        [3] = "Cola",
        [4] = "Orange Soda",
        [5] = "Lime Soda",
        [6] = "Lemon Soda",
        [7] = "Grapefruit Soda",
        [8] = "Milk"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceDrinksOrder:FireServer(unpack(args))
