
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("🌍 DigToChina - Serveur démarré !")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Materials = require(shared:WaitForChild("Materials"))

print("✅ Matériaux chargés :")

for materialName, materialData in pairs(Materials) do
    print(materialData.Name, materialData.Hardness)
end
