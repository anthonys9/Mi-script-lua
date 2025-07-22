local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local savedPosition = nil

-- Crear GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SkyTPGui"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 120)
main.Position = UDim2.new(0, 10, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

local saveButton = Instance.new("TextButton", main)
saveButton.Size = UDim2.new(1, 0, 0.3, 0)
saveButton.Position = UDim2.new(0, 0, 0, 0)
saveButton.Text = "Save Position"
saveButton.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
saveButton.TextColor3 = Color3.new(1,1,1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextScaled = true

local tpButton = Instance.new("TextButton", main)
tpButton.Size = UDim2.new(1, 0, 0.3, 0)
tpButton.Position = UDim2.new(0, 0, 0.35, 0)
tpButton.Text = "Sky TP"
tpButton.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
tpButton.TextColor3 = Color3.new(1,1,1)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextScaled = true

local loadingFrame = Instance.new("Frame", gui)
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.Visible = false
loadingFrame.ZIndex = 10

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(0.3, 0, 0.1, 0)
loadingText.Position = UDim2.new(0.35, 0, 0.45, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Teleporting..."
loadingText.TextScaled = true
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.SourceSansBold

-- Guardar posición
saveButton.MouseButton1Click:Connect(function()
	savedPosition = humanoidRootPart.Position
	saveButton.Text = "Position Saved!"
	wait(1)
	saveButton.Text = "Save Position"
end)

-- Teleport al cielo y caída a posición
tpButton.MouseButton1Click:Connect(function()
	if not savedPosition then return end

	loadingFrame.Visible = true

	wait(0.5)

	-- Teleportar al cielo
	local skyPos = savedPosition + Vector3.new(0, 300, 0)
	character:PivotTo(CFrame.new(skyPos))

	wait(1)

	-- Detectar cuando esté justo arriba
	local goal = savedPosition + Vector3.new(0, 10, 0)
	local fallTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
		Position = goal
	})
	fallTween:Play()

	wait(2)
	loadingFrame.Visible = false
end)
