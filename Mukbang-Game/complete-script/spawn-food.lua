-- functions

function friedChicken()
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
end

function desert()
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
end

function sushi()
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
end

function noodle()
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
end

function snack()
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
end

function drink()
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
end

function sauce()
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
end

task.spawn(friedChicken)
task.spawn(desert)
task.spawn(drink)
task.spawn(noodle)
task.spawn(snack)
task.spawn(sushi)
task.spawn(sauce)

print("Done! Spawned All Food!")
