local args = {
    [1] = {
        [1] = "Choco Buttons Cereal",
        [2] = "Chocoballs Cereal",
        [3] = "Cookies n Cream Cereal",
        [4] = "Strawberry Cookie Cereal",
        [5] = "Matcha Cookie Cereal",
        [6] = "Macaron Cereal",
        [7] = "Matcha Chewy Cookie",
        [8] = "Dubai Chewy Cookie"
    }
}

game:GetService("ReplicatedStorage").PlaceFoodOrderRemotes.PlaceDessertOrder:FireServer(unpack(args))
