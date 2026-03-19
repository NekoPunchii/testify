-- Library
local ToggleLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NekoPunchii/testify/refs/heads/main/newlib.lua"))()

ToggleLib:SetTitle("🎮 Auto Mine Script")

ToggleLib:CreateLabel("═══ Auto Mine ═══")

-- 1. Toggle (Auto Mine)
ToggleLib:CreateToggle("Auto Mine", function(Value)
    getgenv().AutoMine = Value

    if Value then
        ToggleLib:Notify("Auto Mine", "Auto Mine açıldı!", 2, "success")
        
        task.spawn(function()

            local mineRemote = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes")
                :WaitForChild("MineRequest")

            local cubesFolder = workspace:WaitForChild("Cubes")
            local player = game.Players.LocalPlayer

            while getgenv().AutoMine do
                pcall(function()

                    -- Equipped tool'u bul
                    local character = workspace:FindFirstChild("Elijah_Ultra2004")
                    local equippedTool = nil

                    if character then
                        for _, child in pairs(character:GetChildren()) do
                            if child:IsA("Tool") then
                                equippedTool = child.Name
                                break
                            end
                        end
                    end

                    if equippedTool and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
                            mineRemote:FireServer(cubesWithDistance[i].cube, equippedTool)
                        end
                    end

                end)

                task.wait(0)
            end

        end)
    else
        ToggleLib:Notify("Auto Mine", "Auto Mine kapatıldı!", 2, "warning")
    end
end)
