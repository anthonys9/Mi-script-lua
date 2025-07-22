-- Copiar Avatar Script con ícono de ropa 👕 by coolkiddIa 😎
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CopyAvatarGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, 0, 1, 0)
copyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.Font = Enum.Font.GothamBold
copyButton.TextScaled = true
copyButton.Text = "👕 Copy Avatar"
copyButton.Parent = frame

-- Función
copyButton.MouseButton1Click:Connect(function()
    local targetName = "NOMBRE_DEL_JUGADOR" -- ← cambia esto
    local target = Players:FindFirstChild(targetName)

    if not target then
        warn("❌ Jugador no encontrado.")
        return
    end

    local humanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("❌ No se pudo encontrar el Humanoid del objetivo.")
        return
    end

    local desc = humanoid:GetAppliedDescription()
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
    print("✅ Avatar copiado exitosamente de: " .. targetName)
end)
