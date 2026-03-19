-- Library
local ToggleLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NekoPunchii/testify/refs/heads/main/newlib.lua"))()

-- Pickaxe listesini al
local rodsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Rods")
local pickaxeList = {}

for _, pickaxe in pairs(rodsFolder:GetChildren()) do
    if pickaxe:IsA("Model") or pickaxe:IsA("Tool") or pickaxe:IsA("BasePart") then
        table.insert(pickaxeList, pickaxe.Name)
    end
end

-- Alfabetik sırala
table.sort(pickaxeList, function(a, b)
    return a:lower() < b:lower()
end)

-- Seçili pickaxe
local selectedPickaxe = pickaxeList[1] or "Iron Pickaxe"

-- Pickaxe Dropdown
ToggleLib:CreateDropdown("Select Pickaxe", pickaxeList, function(Option)
    selectedPickaxe = Option
end)

-- 1. Toggle (Auto Mine)
ToggleLib:CreateToggle("Auto Mine", function(Value)
    getgenv().AutoMine = Value

    if Value then
        task.spawn(function()

            local mineRemote = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes")
                :WaitForChild("MineRequest")

            local cubesFolder = workspace:WaitForChild("Cubes")
            local player = game.Players.LocalPlayer

            while getgenv().AutoMine do
                pcall(function()

                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart

                        -- Tüm cube'ları mesafeye göre sırala
                        local cubesWithDistance = {}

                        for _, cube in pairs(cubesFolder:GetChildren()) do
                            if cube:IsA("BasePart") or cube:IsA("Model") then
                                local position = nil

                                if cube:IsA("BasePart") then
                                    position = cube.Position
                                elseif cube:IsA("Model") and cube.PrimaryPart then
                                    position = cube.PrimaryPart.Position
                                elseif cube:IsA("Model") then
                                    local part = cube:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        position = part.Position
                                    end
                                end

                                if position then
                                    local distance = (hrp.Position - position).Magnitude
                                    table.insert(cubesWithDistance, {cube = cube, distance = distance})
                                end
                            end
                        end

                        -- Mesafeye göre sırala
                        table.sort(cubesWithDistance, function(a, b)
                            return a.distance < b.distance
                        end)

                        -- En yakın 10 cube için firelay
                        for i = 1, math.min(10, #cubesWithDistance) do
                            mineRemote:FireServer(cubesWithDistance[i].cube, selectedPickaxe)
                        end
                    end

                end)

                task.wait(0)
            end

        end)
    end
end)
