-- Rico TP Script for Steal a Brainrot with draggable GUI button (English)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local brainrot = workspace:WaitForChild("Brainrot") -- Adjust if needed
local centerPosition = Vector3.new(0, 10, 0) -- Change coords if you want another center

local ricoTPEnabled = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RicoTP_GUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 50)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true -- Enables dragging with mouse or finger

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
button.Text = "Rico TP: OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.Parent = frame

-- Teleport function
local function teleportToCenter()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(centerPosition)
    end
end

-- Toggle button on click
button.MouseButton1Click:Connect(function()
    ricoTPEnabled = not ricoTPEnabled
    if ricoTPEnabled then
        button.Text = "Rico TP: ON"
        button.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    else
        button.Text = "Rico TP: OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

-- Loop to detect brainrot and teleport if enabled
while true do
    wait(0.5)
    if ricoTPEnabled and (brainrot.Parent == player.Character or brainrot:FindFirstAncestor(player.Name)) then
        teleportToCenter()
    end
end
