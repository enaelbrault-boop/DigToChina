
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local digEvent = Instance.new("RemoteEvent")
digEvent.Name = "DigBlock"
digEvent.Parent = ReplicatedStorage

local MAX_DISTANCE = 18
local DIG_COOLDOWN = 0.25
local lastDig = {}

digEvent.OnServerEvent:Connect(function(player, block)
    if typeof(block) ~= "Instance" then
        return
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local world = workspace:FindFirstChild("DigToChinaWorld")

    if not world or not block:IsA("Part") or not block:IsDescendantOf(world) then
        return
    end

    if (root.Position - block.Position).Magnitude > MAX_DISTANCE then
        return
    end

    local now = os.clock()

    if lastDig[player] and now - lastDig[player] < DIG_COOLDOWN then
        return
    end

    lastDig[player] = now

    local hardness = block:GetAttribute("Hardness") or 1
    local health = block:GetAttribute("Health") or hardness

    health -= 1
    block:SetAttribute("Health", health)

    if health <= 0 then
        block:Destroy()
        print(player.Name .. " a creusé un bloc !")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    lastDig[player] = nil
end)

print("⛏️ Système de creusage activé !")
