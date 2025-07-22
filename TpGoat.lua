local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Variables
local savedPosition = nil
local noclipEnabled = false
local isTeleporting = false

-- Crear pantalla de carga
local function showLoadingScreen(text)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BackgroundTransparency = 0.7
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 100)
    label.Position = UDim2.new(0, 0, 0.5, -50)
    label.BackgroundTransparency = 1
    label.Text = text or "Loading..."
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    return screenGui
end

-- Quitar pantalla de carga
local function hideLoadingScreen(screenGui)
    if screenGui then
        screenGui:Destroy()
    end
end

-- Noclip toggle
local function setNoclip(state)
    noclipEnabled = state
end

-- Mantener noclip activo
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- God mode temporal
local function setGodMode(state)
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if state then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- Spoof posición (mock)
local spoofing = false
local function spoofPosition(duration)
    spoofing = true
    -- Aquí puedes poner spoof de red o lo que sea que el juego soporte.
    -- Por ahora, solo es un mock para que no te detecten moviéndote.
    wait(duration or 2)
    spoofing = false
end

-- Teleport suave con Tween
local function teleportTo(position)
    if isTeleporting then return end
    isTeleporting = true

    local loadingGui = showLoadingScreen("Anthony el GOAT")

    setNoclip(true)
    setGodMode(true)
    spoofPosition(3)

    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(position + Vector3.new(0,5,0))})
    tween:Play()
    tween.Completed:Wait()

    setNoclip(false)
    setGodMode(false)
    hideLoadingScreen(loadingGui)

    isTeleporting = false
end

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGoatGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 160, 0, 40)
saveBtn.Position = UDim2.new(0, 10, 0, 10)
saveBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
saveBtn.Text = "Save Position"
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextScaled = true
saveBtn.Parent = frame

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0, 160, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 60)
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 179, 113)
tpBtn.Text = "SpeedGoat TP"
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextScaled = true
tpBtn.Parent = frame

saveBtn.MouseButton1Click:Connect(function()
    savedPosition = hrp.Position
    saveBtn.Text = "Position Saved!"
    wait(2)
    saveBtn.Text = "Save Position"
end)

tpBtn.MouseButton1Click:Connect(function()
    if savedPosition then
        teleportTo(savedPosition)
    else
        tpBtn.Text = "No Position Saved!"
        wait(2)
        tpBtn.Text = "SpeedGoat TP"
    end
end)
