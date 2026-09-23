local args = {
    [1] = {
        [1] = "Carbonara",
        [2] = "Spicy",
        [3] = "Sardines",
        [4] = "Dumplings",
        [5] = "Chicken Tenders",
        [6] = "Spam",
        [7] = "Sausage",
        [8] = "Eggs"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceRamenOrder:FireServer(unpack(args))
