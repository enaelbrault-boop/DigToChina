
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local buyEvent = ReplicatedStorage:WaitForChild("BuyShovel")

local gui = Instance.new("ScreenGui")
gui.Name = "DigToChinaShop"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local open = Instance.new("TextButton")
open.Size = UDim2.fromOffset(130, 48)
open.Position = UDim2.new(1, -145, 0, 20)
open.Text = "🏪 BOUTIQUE"
open.TextScaled = true
open.Parent = gui

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(280, 260)
panel.Position = UDim2.new(0.5, -140, 0.5, -130)
panel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
panel.Visible = false
panel.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "⛏️ BOUTIQUE DES PELLES"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = panel

local items = {
    {"Pelle en fer", 50, 3},
    {"Pelle en or", 250, 8},
    {"Pelle diamant", 1000, 20}
}

for i, item in ipairs(items) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 48)
    button.Position = UDim2.new(0.05, 0, 0, 50 + (i - 1) * 55)
    button.Text = item[1] .. " - " .. item[2] .. " pièces (x" .. item[3] .. ")"
    button.TextScaled = true
    button.Parent = panel

    button.Activated:Connect(function()
        local success, message = buyEvent:InvokeServer(item[1])
        button.Text = message

        task.wait(2)
        button.Text = item[1] .. " - " .. item[2] .. " pièces (x" .. item[3] .. ")"
    end)
end

local close = Instance.new("TextButton")
close.Size = UDim2.new(0.9, 0, 0, 35)
close.Position = UDim2.new(0.05, 0, 1, -40)
close.Text = "FERMER"
close.Parent = panel

open.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

close.Activated:Connect(function()
    panel.Visible = false
end)
