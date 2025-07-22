-- // Run-In-Place Script with intro screen 😈

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local runAnimationId = "rbxassetid://616163682" -- default run animation
local animation = Instance.new("Animation")
animation.AnimationId = runAnimationId
local track = hum:LoadAnimation(animation)

-- Create ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "RunInPlaceGui"

-- Pantalla de carga
local intro = Instance.new("TextLabel", gui)
intro.Size = UDim2.new(1, 0, 1, 0)
intro.BackgroundColor3 = Color3.new(0, 0, 0)
intro.TextColor3 = Color3.new(1, 1, 1)
intro.TextScaled = true
intro.Text = "Anthony is the best 💯"
intro.Font = Enum.Font.GothamBlack
intro.ZIndex = 10

-- Desaparece después de 3 segundos
task.delay(3, function()
	intro:Destroy()
end)

-- Botón
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.1, 0)
button.Text = "Run In Place: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.BorderSizePixel = 0
button.Active = true
button.Draggable = true

local running = false

button.MouseButton1Click:Connect(function()
    running = not running
    if running then
        track:Play()
        hum.WalkSpeed = 0 -- freeze
        button.Text = "Run In Place: ON"
    else
        track:Stop()
        hum.WalkSpeed = 16 -- normal
        button.Text = "Run In Place: OFF"
    end
end)
