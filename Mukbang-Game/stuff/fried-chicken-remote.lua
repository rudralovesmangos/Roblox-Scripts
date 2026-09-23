local args = {
    [1] = {
        [1] = "Fried Chicken",
        [2] = "Flamin' Hot Chicken",
        [3] = "Candied Chicken",
        [4] = "Shallot Chicken",
        [5] = "Snowy Chicken",
        [6] = "Cheesy Snow Chicken",
        [7] = "Spicy Honey Chicken",
        [8] = "Honey Soy Chicken"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceMainOrder:FireServer(unpack(args))
