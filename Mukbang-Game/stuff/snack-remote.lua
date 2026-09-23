local args = {
    [1] = {
        [1] = "Corn Dog",
        [2] = "Crumble Dog",
        [3] = "Panko Dog",
        [4] = "Apple Cubu Dog",
        [5] = "Flamin' Hot Dog",
        [6] = "Takees Dog",
        [7] = "Blue Taki Dog",
        [8] = "Mozzarella Sticks"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceSnacksOrder:FireServer(unpack(args))
