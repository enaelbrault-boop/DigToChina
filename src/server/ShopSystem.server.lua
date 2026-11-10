
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local buyEvent = Instance.new("RemoteFunction")
buyEvent.Name = "BuyShovel"
buyEvent.Parent = ReplicatedStorage

local shovels = {
    ["Pelle en fer"] = {
        Price = 50,
        Power = 3,
        Color = Color3.fromRGB(150, 150, 160)
    },

    ["Pelle en or"] = {
        Price = 250,
        Power = 8,
        Color = Color3.fromRGB(255, 190, 30)
    },

    ["Pelle diamant"] = {
        Price = 1000,
        Power = 20,
        Color = Color3.fromRGB(50, 220, 255)
    }
}

local function createShovel(name, data)
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    tool:SetAttribute("DigPower", data.Power)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.35, 3, 0.35)
    handle.Color = Color3.fromRGB(110, 70, 35)
    handle.Material = Enum.Material.Wood
    handle.Parent = tool

    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(1.3, 0.9, 0.2)
    blade.Color = data.Color
    blade.Material = Enum.Material.Metal
    blade.CanCollide = false
    blade.Massless = true
    blade.Parent = tool

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = blade
    weld.Parent = blade

    blade.CFrame = handle.CFrame * CFrame.new(0, -1.5, 0)

    return tool
end

buyEvent.OnServerInvoke = function(player, shovelName)
    local data = shovels[shovelName]
    if not data then
        return false, "Pelle inconnue"
    end

    local stats = player:FindFirstChild("leaderstats")
    local coins = stats and stats:FindFirstChild("Pièces")

    if not coins then
        return false, "Argent introuvable"
    end

    if coins.Value < data.Price then
        return false, "Pas assez de pièces !"
    end

    local starterGear = player:FindFirstChild("StarterGear")
    local backpack = player:FindFirstChild("Backpack")

    if not starterGear or not backpack then
        return false, "Réessaie dans un instant"
    end

    if starterGear:FindFirstChild(shovelName) then
        return false, "Tu possèdes déjà cette pelle"
    end

    coins.Value -= data.Price

    local tool = createShovel(shovelName, data)
    tool:Clone().Parent = starterGear
    tool.Parent = backpack

    return true, "Bravo ! Tu as acheté " .. shovelName
end

print("🏪 Boutique DigToChina activée !")
