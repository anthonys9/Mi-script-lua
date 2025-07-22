-- AnthonyDance’s V2 by coolkiddia 🕺🔥
-- Funciona FE si el juego permite Humanoid:LoadAnimation()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Crear ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AnthonyDancesGUI"

-- Botón principal
local mainButton = Instance.new("TextButton", gui)
mainButton.Size = UDim2.new(0, 160, 0, 50)
mainButton.Position = UDim2.new(0, 20, 0, 200)
mainButton.Text = "AnthonyDance’s 💃"
mainButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.Font = Enum.Font.GothamBold
mainButton.TextSize = 16
mainButton.Draggable = true
mainButton.Active = true

-- Marco para los bailes
local danceFrame = Instance.new("Frame", gui)
danceFrame.Size = UDim2.new(0, 180, 0, 360)
danceFrame.Position = UDim2.new(0, 20, 0, 260)
danceFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
danceFrame.Visible = false

-- Lista de AnimationIds (FE-validos)
local animationIds = {
    "507771019", -- Dance 1
    "507776043", -- Dance 2
    "507777268", -- Dance 3
    "507777826", -- Dance 4
    "507778104", -- Dance 5
    "507778210", -- Dance 6
    "507777623", -- Dance 7
    "507776720", -- Dance 8
    "507775227", -- Dance 9
    "507770677", -- Dance 10
    "507771955", -- Dance 11
    "507779075", -- Dance 12
}

local anims = {}
local currentTrack = nil

-- Crear botones para cada animación
for i, animId in ipairs(animationIds) do
	local btn = Instance.new("TextButton", danceFrame)
	btn.Size = UDim2.new(1, -10, 0, 25)
	btn.Position = UDim2.new(0, 5, 0, (i - 1) * 28 + 5)
	btn.Text = "Baile " .. i
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. animId
	anims[i] = anim

	btn.MouseButton1Click:Connect(function()
		if currentTrack then
			currentTrack:Stop()
		end
		local track = hum:LoadAnimation(anim)
		track:Play()
		currentTrack = track
	end)
end

-- Botón para detener
local stopButton = Instance.new("TextButton", danceFrame)
stopButton.Size = UDim2.new(1, -10, 0, 25)
stopButton.Position = UDim2.new(0, 5, 0, #animationIds * 28 + 10)
stopButton.Text = "Parar Baile ❌"
stopButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 14
stopButton.MouseButton1Click:Connect(function()
	if currentTrack then
		currentTrack:Stop()
		currentTrack = nil
	end
end)

-- Toggle mostrar/ocultar
mainButton.MouseButton1Click:Connect(function()
	danceFrame.Visible = not danceFrame.Visible
end)
