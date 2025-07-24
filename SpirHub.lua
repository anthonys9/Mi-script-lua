-- Aimbot con team check para SpirHub
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

local AimbotEnabled = false
local AimPartName = "Head" -- Parte a apuntar, puede ser "Head" o "HumanoidRootPart"
local AimFOV = 70 -- grados para rango de apuntado
local AimSmoothness = 0.25 -- entre 0 (instantáneo) y 1 (muy lento)

-- Función para chequear si un jugador es enemigo (team check)
local function IsEnemy(player)
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return false
    end
    if player.Team and LocalPlayer.Team then
        return player.Team ~= LocalPlayer.Team
    end
    return true -- si no hay equipo, considera enemigo
end

-- Función para obtener la distancia angular en pantalla (para FOV)
local function GetScreenDistance(point)
    local viewportPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(point)
    if not onScreen then return math.huge end
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    return (Vector2.new(viewportPoint.X, viewportPoint.Y) - mousePos).Magnitude
end

-- Función para encontrar el mejor objetivo en rango y línea de visión
local function GetClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = AimFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and player.Character then
            local char = player.Character
            local aimPart = char:FindFirstChild(AimPartName) or char:FindFirstChild("HumanoidRootPart")
            if aimPart then
                local screenDist = GetScreenDistance(aimPart.Position)
                if screenDist < shortestDistance then
                    closestPlayer = player
                    shortestDistance = screenDist
                end
            end
        end
    end
    return closestPlayer
end

-- Loop de aimbot
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestEnemy()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(AimPartName) or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local cam = workspace.CurrentCamera
                local camCFrame = cam.CFrame
                local direction = (targetPart.Position - camCFrame.Position).Unit
                local newCFrame = CFrame.new(camCFrame.Position, camCFrame.Position + direction)
                cam.CFrame = camCFrame:Lerp(newCFrame, AimSmoothness)
            end
        end
    end
end)

-- Integración con SpirHub UI: botón toggle y texto
local function CreateAimbotButton(guiParent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 20)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = "Aimbot: OFF"
    btn.Parent = guiParent
    btn.Active = true
    btn.Draggable = true

    btn.MouseButton1Click:Connect(function()
        AimbotEnabled = not AimbotEnabled
        btn.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    end)
end

-- Ejemplo de uso en tu gui principal (suponiendo que tengas un Frame llamado 'MainFrame'):
-- CreateAimbotButton(MainFrame)

return {
    CreateAimbotButton = CreateAimbotButton,
    Toggle = function(state) AimbotEnabled = state end
}
