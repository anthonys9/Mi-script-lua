local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()

local speedEnabled = false
local infiniteJumpEnabled = false
local brainrotTPEnabled = false

local basePosition = Vector3.new(0, 10, 0) -- Cambia esto a las coordenadas de tu base

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Spir"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local function createToggleButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Text = text
    button.Parent = frame
    return button
end

local speedButton = createToggleButton("Speed: OFF", UDim2.new(0, 10, 0, 10))
local jumpButton = createToggleButton("Infinite Jump: OFF", UDim2.new(0, 10, 0, 50))
local brainrotButton = createToggleButton("Brainrot TP: OFF", UDim2.new(0, 10, 0, 90))

-- Speed toggle
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedButton.Text = "Speed: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50) -- lime green
        humanoid.WalkSpeed = 32 -- Velocidad rápida, default es 16
    else
        speedButton.Text = "Speed: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        humanoid.WalkSpeed = 16 -- Default
    end
end)

-- Infinite Jump toggle
infiniteJumpEnabled = false
jumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        jumpButton.Text = "Infinite Jump: ON"
        jumpButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
    else
        jumpButton.Text = "Infinite Jump: OFF"
        jumpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        if humanoid and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Brainrot teleport toggle
brainrotButton.MouseButton1Click:Connect(function()
    brainrotTPEnabled = not brainrotTPEnabled
    if brainrotTPEnabled then
        brainrotButton.Text = "Brainrot TP: ON"
        brainrotButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
    else
        brainrotButton.Text = "Brainrot TP: OFF"
        brainrotButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Función para teletransportar a base
local function teleportToBase()
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
    end
end

-- Detectar si el jugador tiene Brainrot en las manos
RunService.Heartbeat:Connect(function()
    if brainrotTPEnabled and character then
        local hasBrainrot = false
        for _, item in pairs(character:GetChildren()) do
            if item.Name == "Brainrot" then
                hasBrainrot = true
                break
            end
        end
        if hasBrainrot then
            teleportToBase()
        end
    end
end)
