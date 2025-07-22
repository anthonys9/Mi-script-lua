-- Anthony is the best 💪
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "EgorRunGui"

-- Texto emergente al cargar
local followText = Instance.new("TextLabel", ScreenGui)
followText.Size = UDim2.new(0.5, 0, 0.1, 0)
followText.Position = UDim2.new(0.25, 0, 0.4, 0)
followText.Text = "Follow me on TikTok speedgod.ios"
followText.TextColor3 = Color3.new(1, 1, 1)
followText.BackgroundTransparency = 1
followText.TextScaled = true
followText.Font = Enum.Font.FredokaOne

-- Desaparece el mensaje después de 4 segundos
task.delay(4, function()
	followText:Destroy()
end)

-- Botón de encendido/apagado
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Run: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold

-- Animación de correr
local runAnim = Instance.new("Animation")
runAnim.AnimationId = "rbxassetid://913376220" -- animación estilo Egor
local runTrack = humanoid:LoadAnimation(runAnim)

-- Lógica del movimiento falso
local running = false
local rs = game:GetService("RunService")
local con

ToggleButton.MouseButton1Click:Connect(function()
	running = not running
	ToggleButton.Text = "Run: " .. (running and "ON" or "OFF")
	if running then
		runTrack:Play()
		con = rs.RenderStepped:Connect(function()
			rootPart.Velocity = Vector3.new(0, rootPart.Velocity.Y, 0)
		end)
	else
		runTrack:Stop()
		if con then con:Disconnect() end
	end
end)

-- Mensaje en el chat
game.StarterGui:SetCore("ChatMakeSystemMessage", {
	Text = "Anthony is the best 🤖🔥",
	Color = Color3.fromRGB(0, 255, 127),
	Font = Enum.Font.SourceSansBold,
	TextSize = 24
})
