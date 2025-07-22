-- Anthony’s Egor SpeedGod Visual Script 💨

-- Pantalla con texto
local screenMsg = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local text = Instance.new("TextLabel", screenMsg)
text.Size = UDim2.new(1,0,0.1,0)
text.Position = UDim2.new(0,0,0.4,0)
text.BackgroundTransparency = 1
text.Text = "Follow me on TikTok speedgod.ios"
text.TextColor3 = Color3.fromRGB(255, 255, 0)
text.TextScaled = true
text.Font = Enum.Font.FredokaOne
wait(4)
screenMsg:Destroy()

-- Botón UI
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.5, -60, 0.8, 0)
button.Text = "SpeedGod: OFF"
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(0, 255, 0)
button.BorderSizePixel = 2
button.Active = true
button.Draggable = true

-- Animación visual ultra rápida
local running = false
local animationId = "rbxassetid://616163682" -- Egor animation (puede cambiarse si deseas una aún más rápida)
local anim = Instance.new("Animation")
anim.AnimationId = animationId
local track = nil

button.MouseButton1Click:Connect(function()
	running = not running
	if running then
		button.Text = "SpeedGod: ON"
		local human = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if human then
			track = human:LoadAnimation(anim)
			track:Play()
			track:AdjustSpeed(5) -- más rápido visualmente
			game.StarterGui:SetCore("ChatMakeSystemMessage", {
				Text = "Anthony is the best 🤖🔥";
				Color = Color3.fromRGB(255, 0, 0);
			})
		end
	else
		button.Text = "SpeedGod: OFF"
		if track then
			track:Stop()
		end
	end
end)
