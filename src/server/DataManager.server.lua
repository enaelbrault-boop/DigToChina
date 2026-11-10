
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local coinStore = DataStoreService:GetDataStore("DigToChina_Coins_V1")

local function savePlayer(player)
    local stats = player:FindFirstChild("leaderstats")
    local coins = stats and stats:FindFirstChild("Pièces")

    if not coins then return end

    local success, err = pcall(function()
        coinStore:SetAsync("Player_" .. player.UserId, coins.Value)
    end)

    if success then
        print("💾 Pièces sauvegardées pour " .. player.Name)
    else
        warn("Erreur de sauvegarde :", err)
    end
end

Players.PlayerAdded:Connect(function(player)
    local stats = player:WaitForChild("leaderstats")
    local coins = stats:WaitForChild("Pièces")

    local success, data = pcall(function()
        return coinStore:GetAsync("Player_" .. player.UserId)
    end)

    if success and typeof(data) == "number" then
        coins.Value = data
    elseif not success then
        warn("Impossible de charger les pièces de " .. player.Name)
    end
end)

Players.PlayerRemoving:Connect(savePlayer)

-- Sauvegarde automatique toutes les 60 secondes
task.spawn(function()
    while true do
        task.wait(60)

        for _, player in ipairs(Players:GetPlayers()) do
            savePlayer(player)
        end
    end
end)

game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        savePlayer(player)
    end
end)

print("💾 Sauvegarde DigToChina activée !")
