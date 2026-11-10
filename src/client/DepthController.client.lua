
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DepthUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(190, 65)
panel.Position = UDim2.new(0, 15, 0, 85)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
panel.BackgroundTransparency = 0.15
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, -10)
label.Position = UDim2.fromOffset(5, 5)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Text = "🌍 Profondeur : 0 bloc"
label.Parent = panel

local SURFACE_HEIGHT = 3
local BLOCK_SIZE = 6

RunService.RenderStepped:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if root then
        local depth = math.max(
            0,
            math.floor((SURFACE_HEIGHT - root.Position.Y) / BLOCK_SIZE)
        )

        label.Text = "🌍 Profondeur : " .. depth .. " blocs"
    end
end)

print("📏 Compteur de profondeur activé !")
