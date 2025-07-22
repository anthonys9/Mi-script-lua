local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local speedEnabled = false
local infiniteJumpEnabled = false
local roofTPEnabled = false

-- Cambia estas coordenadas a la base enemiga arriba (roof)
local roofPosition = Vector3.new(0, 50, 0) -- Ejemplo: 50 studs arriba en Y

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Spir"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local function createToggleButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 40)
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
local jumpButton = createToggleButton("Infinite Jump: OFF", UDim2.new(0, 10, 0, 60))
local roofTPButton = createToggleButton("Roof TP: OFF", UDim2.new(0, 10, 0, 110))

-- Speed toggle
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedButton.Text = "Speed: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        humanoid.WalkSpeed = 70
    else
        speedButton.Text = "Speed: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        humanoid.WalkSpeed = 16
    end
end)

-- Infinite Jump toggle
infiniteJumpEnabled = false
local canJump = true
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
    if infiniteJumpEnabled and canJump then
        if humanoid and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            canJump = false
            wait(0.2)
            canJump = true
        end
    end
end)

-- Roof TP toggle
roofTPButton.MouseButton1Click:Connect(function()
    roofTPEnabled = not roofTPEnabled
    if roofTPEnabled then
        roofTPButton.Text = "Roof TP: ON"
        roofTPButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
    else
        roofTPButton.Text = "Roof TP: OFF"
        roofTPButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Teleport suave
local function smoothTeleport(targetCFrame, duration)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    duration = duration or 0.5
    local start = hrp.CFrame
    local elapsed = 0
    while elapsed < duration do
        RunService.Heartbeat:Wait()
        elapsed = elapsed + RunService.Heartbeat:Wait()
        local alpha = elapsed / duration
        hrp.CFrame = start:Lerp(targetCFrame, alpha)
    end
    hrp.CFrame = targetCFrame
end

-- Detectar si el jugador tiene Brainrot en las manos y TP
RunService.Heartbeat:Connect(function()
    if roofTPEnabled and character then
        local hasBrainrot = false
        for _, item in pairs(character:GetChildren()) do
            if item.Name == "Brainrot" then
                hasBrainrot = true
                break
            end
        end
        if hasBrainrot then
            smoothTeleport(CFrame.new(roofPosition), 0.5)
        end
    end
end)
