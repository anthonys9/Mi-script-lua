local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedPosition = nil
local teleporting = false

-- GUI Pantalla de carga
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "SpirLoadingGui"
loadingGui.Parent = player:WaitForChild("PlayerGui")
loadingGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame", loadingGui)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
loadingFrame.Size = UDim2.new(1,0,1,0)
loadingFrame.Visible = false

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1,0,1,0)
loadingText.Text = "SPIRSKYTP"
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.Bangers
loadingText.BackgroundTransparency = 1

-- Función Noclip
local function noclipOn()
    if not player.Character then return end
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function noclipOff()
    if not player.Character then return end
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Vida infinita
local function godMode()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

-- Spoof posición (mockup para que no detecten el TP)
local function spoofPosition(pos)
    -- Esto es muy específico, depende del juego,
    -- aquí sería poner algo que "mienta" al servidor.
    -- En muchos juegos se usa mover la cámara o humanoid rootpart sin teletransportar bruscamente.
    -- Para demo, dejamos vacío o puedes agregar código específico si sabes.
end

-- Teleport suave con Tween
local function smoothTeleport(targetPos)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    teleporting = true
    loadingFrame.Visible = true
    noclipOn()
    godMode()

    local hrp = player.Character.HumanoidRootPart
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()

    tween.Completed:Wait()
    noclipOff()
    teleporting = false
    loadingFrame.Visible = false
end

-- Guardar posición base
local function savePosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = player.Character.HumanoidRootPart.Position
        print("Position saved:", savedPosition)
    else
        print("No character to save position")
    end
end

-- Reconexión automática si mueres
player.CharacterAdded:Connect(function(char)
    wait(1)
    if teleporting and savedPosition then
        smoothTeleport(savedPosition)
    end
end)

-- GUI básico para activar funciones
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpirGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -20, 0, 40)
saveBtn.Position = UDim2.new(0, 10, 0, 10)
saveBtn.Text = "Save Position"
saveBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Parent = frame

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 60)
tpBtn.Text = "SpeedGoat TP"
tpBtn.BackgroundColor3 = Color3.fromRGB(70,180,70)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Parent = frame

saveBtn.MouseButton1Click:Connect(savePosition)
tpBtn.MouseButton1Click:Connect(function()
    if savedPosition then
        smoothTeleport(savedPosition)
    else
        print("No position saved yet")
    end
end)

print("Spir TP Script loaded")
