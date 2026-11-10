
local Workspace = game:GetService("Workspace")

local BLOCK_SIZE = 6
local MAP_SIZE = 11


local Materials = {
    {Name = "Sable", Depth = 2, Hardness = 1, Color = Color3.fromRGB(194, 178, 128)},
    {Name = "Terre", Depth = 4, Hardness = 3, Color = Color3.fromRGB(101, 67, 33)},
    {Name = "Pierre", Depth = 4, Hardness = 8, Color = Color3.fromRGB(100, 100, 100)},
    {Name = "Pierre dure", Depth = 3, Hardness = 15, Color = Color3.fromRGB(60, 60, 60)},
    {Name = "Pierre du noyau", Depth = 3, Hardness = 30, Color = Color3.fromRGB(80, 30, 20)}
}

local oldWorld = Workspace:FindFirstChild("DigToChinaWorld")
if oldWorld then
    oldWorld:Destroy()
end

local world = Instance.new("Folder")
world.Name = "DigToChinaWorld"
world.Parent = Workspace

local currentDepth = 0

for _, material in ipairs(Materials) do
    for layer = 1, material.Depth do
        currentDepth += 1

        for x = 1, MAP_SIZE do
            for z = 1, MAP_SIZE do
                local block = Instance.new("Part")
                block.Name = material.Name
                block.Size = Vector3.new(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
                block.Position = Vector3.new(
                    (x - (MAP_SIZE + 1) / 2) * BLOCK_SIZE,
                    -((currentDepth - 1) * BLOCK_SIZE),
                    (z - (MAP_SIZE + 1) / 2) * BLOCK_SIZE
                )
                block.Anchored = true
                block.Material = Enum.Material.SmoothPlastic
                block.Color = material.Color
                block.TopSurface = Enum.SurfaceType.Smooth
                block.BottomSurface = Enum.SurfaceType.Smooth
                block:SetAttribute("MaterialName", material.Name)
                block:SetAttribute("Hardness", material.Hardness)
                
-- Apparition aléatoire des minerais
if material.Name == "Pierre" or material.Name == "Pierre dure" then
    local roll = math.random(1, 1000)

    local oreName = nil
    local oreColor = nil
    local oreHardness = nil

    if roll <= 40 then
        oreName = "Charbon"
        oreColor = Color3.fromRGB(35, 35, 35)
        oreHardness = 3
    elseif roll <= 65 then
        oreName = "Fer"
        oreColor = Color3.fromRGB(190, 130, 100)
        oreHardness = 5
    elseif roll <= 75 then
        oreName = "Or"
        oreColor = Color3.fromRGB(255, 200, 20)
        oreHardness = 8
    elseif roll <= 78 then
        oreName = "Diamant"
        oreColor = Color3.fromRGB(40, 230, 255)
        oreHardness = 12
    end

    if oreName then
        block.Name = oreName
        block.Color = oreColor
        block:SetAttribute("MaterialName", oreName)
        block:SetAttribute("Hardness", oreHardness)
    end
end

                block.Parent = world
            end
        end
    end
end

local spawn = Instance.new("SpawnLocation")
spawn.Name = "PlayerSpawn"
spawn.Size = Vector3.new(6, 1, 6)
spawn.Position = Vector3.new(0, 4, 0)
spawn.Anchored = true
spawn.Neutral = true
spawn.Parent = world

print("🌍 DigToChina : monde généré !")
print("⛏️ Nombre de couches :", currentDepth)
