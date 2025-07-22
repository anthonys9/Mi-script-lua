-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnthonyDancesGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Botón principal
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 150, 0, 40)
mainButton.Position = UDim2.new(0, 20, 0, 150)
mainButton.Text = "AnthonyDance’s 💃"
mainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.Parent = ScreenGui

-- Marco con scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 180, 0, 300)
scrollFrame.Position = UDim2.new(0, 20, 0, 200)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.ScrollBarThickness = 8
scrollFrame.Visible = false
scrollFrame.Parent = ScreenGui

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

-- Tabla de animaciones
local animations = {
    "507771019", "507776043", "507777268", "507777451",
    "507777623", "507777914", "941877560", "148840371",
    "484140803", "3360689775", "591577074", "1845743406"
}

local playingAnim = nil
local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

-- Crear botones por animación
for i, animId in ipairs(animations) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "Animación " .. i
    btn.Parent = scrollFrame

    btn.MouseButton1Click:Connect(function()
        if playingAnim then playingAnim:Stop() end
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. animId
        playingAnim = humanoid:LoadAnimation(anim)
        playingAnim:Play()
    end)
end

-- Botón para detener animación
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -10, 0, 30)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "❌ Parar animación"
stopBtn.Parent = scrollFrame
stopBtn.MouseButton1Click:Connect(function()
    if playingAnim then playingAnim:Stop() end
end)

-- Mostrar/ocultar menú
mainButton.MouseButton1Click:Connect(function()
    scrollFrame.Visible = not scrollFrame.Visible
end)
