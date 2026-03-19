-- Library
local ToggleLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NekoPunchii/testify/refs/heads/main/newlib.lua"))()

-- 1. Toggle (Auto Eat)
ToggleLib:CreateToggle("Auto Eat", function(Value)
    getgenv().AutoEat = Value

    if Value then
        task.spawn(function()

            local eatRemote = game:GetService("ReplicatedStorage")
                :WaitForChild("E&F")
                :WaitForChild("Food")
                :WaitForChild("EatOnceRE")

            while getgenv().AutoEat do
                pcall(function()

                    eatRemote:FireServer()

                end)

                task.wait(0)
            end

        end)
    end
end)

-- 2. Toggle (Auto Get Coins)
ToggleLib:CreateToggle("Auto Get Coins", function(Value)
    getgenv().AutoGetCoins = Value

    if Value then
        task.spawn(function()

            local getCoinsRemote = game:GetService("ReplicatedStorage")
                :WaitForChild("E&F")
                :WaitForChild("Race")
                :WaitForChild("GetCoinsRE")

            while getgenv().AutoGetCoins do
                pcall(function()

                    getCoinsRemote:FireServer(1e20)

                end)

                task.wait(0)
            end

        end)
    end
end)

-- Separator
ToggleLib:CreateSeparator()

-- Label
ToggleLib:CreateLabel("Auto Luck Settings")

-- Egg Dropdown
local eggs = {}
for i = 1, 20 do
    table.insert(eggs, "Egg" .. i)
end

local selectedEgg = "Egg1"
ToggleLib:CreateDropdown("Select Egg", eggs, function(Option)
    selectedEgg = Option
end)

-- Amount TextBox
local luckAmount = 1
ToggleLib:CreateTextBox("Amount", "Enter amount...", function(Text)
    local num = tonumber(Text)
    if num then
        luckAmount = num
    end
end)

-- 3. Toggle (Auto Luck)
ToggleLib:CreateToggle("Auto Luck", function(Value)
    getgenv().AutoLuck = Value

    if Value then
        task.spawn(function()

            local luckRemote = game:GetService("ReplicatedStorage")
                :WaitForChild("E&F")
                :WaitForChild("Luck")
                :WaitForChild("DoLuckRE")

            while getgenv().AutoLuck do
                pcall(function()

                    luckRemote:FireServer(selectedEgg, luckAmount)

                end)

                task.wait(0)
            end

        end)
    end
end)
