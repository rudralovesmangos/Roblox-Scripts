local args = {
    [1] = {
        [1] = "Cheese",
        [2] = "Spicy",
        [3] = "Mayo",
        [4] = "Sweet n Sour",
        [5] = "Ranch",
        [6] = "Birria",
        [7] = "Onion Powder",
        [8] = "Honey Garlic"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceSauceOrder:FireServer(unpack(args))
