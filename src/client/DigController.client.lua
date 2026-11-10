
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local digEvent = ReplicatedStorage:WaitForChild("DigBlock")

local function digAtPosition(position)
    local ray = camera:ViewportPointToRay(position.X, position.Y)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    if player.Character then
        params.FilterDescendantsInstances = {player.Character}
    end

    local result = workspace:Raycast(
        ray.Origin,
        ray.Direction * 100,
        params
    )

    if result then
        local block = result.Instance
        local world = workspace:FindFirstChild("DigToChinaWorld")

        if world and block:IsDescendantOf(world)
            and block.Name ~= "PlayerSpawn" then
            digEvent:FireServer(block)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        digAtPosition(Vector2.new(
            input.Position.X,
            input.Position.Y
        ))
    end
end)

print("⛏️ Commandes de creusage activées !")
