
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterPack = game:GetService("StarterPack")

local digEvent = ReplicatedStorage:FindFirstChild("DigBlock")

if not digEvent then
    digEvent = Instance.new("RemoteEvent")
    digEvent.Name = "DigBlock"
    digEvent.Parent = ReplicatedStorage
end

-- Création de la pelle de départ
local oldTool = StarterPack:FindFirstChild("Pelle de départ")
if oldTool then
    oldTool:Destroy()
end

local shovel = Instance.new("Tool")
shovel.Name = "Pelle de départ"
shovel.RequiresHandle = true
shovel.CanBeDropped = false
shovel:SetAttribute("DigPower", 1)

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.35, 3, 0.35)
handle.Color = Color3.fromRGB(110, 70, 35)
handle.Material = Enum.Material.Wood
handle.Parent = shovel

local blade = Instance.new("Part")
blade.Name = "Blade"
blade.Size = Vector3.new(1.3, 0.9, 0.2)
blade.Color = Color3.fromRGB(140, 140, 150)
blade.Material = Enum.Material.Metal
blade.CanCollide = false
blade.Massless = true
blade.Parent = shovel

local weld = Instance.new("WeldConstraint")
weld.Part0 = handle
weld.Part1 = blade
weld.Parent = blade

blade.CFrame = handle.CFrame * CFrame.new(0, -1.5, 0)

shovel.Parent = StarterPack

-- Système de creusage
local MAX_DISTANCE = 18
local DIG_COOLDOWN = 0.25
local lastDig = {}

digEvent.OnServerEvent:Connect(function(player, block)
    if typeof(block) ~= "Instance" then return end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then return end

    local world = workspace:FindFirstChild("DigToChinaWorld")

    if not world or not block:IsA("Part")
        or not block:IsDescendantOf(world) then
        return
    end

    if (root.Position - block.Position).Magnitude > MAX_DISTANCE then
        return
    end

    local now = os.clock()

    if lastDig[player] and now - lastDig[player] < DIG_COOLDOWN then
        return
    end

    local equippedTool = character:FindFirstChildOfClass("Tool")

    if not equippedTool then return end

    local power = equippedTool:GetAttribute("DigPower") or 1
    local hardness = block:GetAttribute("Hardness") or 1
    local health = block:GetAttribute("Health") or hardness

    lastDig[player] = now
    health -= power
    block:SetAttribute("Health", health)

    if health <= 0 then
        block:Destroy()
        print(player.Name .. " a creusé un bloc !")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    lastDig[player] = nil
end)

print("⛏️ DigToChina : pelle de départ créée !")
<
