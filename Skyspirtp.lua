local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local skyPosition = Vector3.new(0, 5000, 0) -- Punto alto para SkyTP
local teleported = false

-- Crear pantalla de carga
local loadingScreen = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
loadingScreen.Name = "SpirSkyTP_Loading"

local loadingLabel = Instance.new("TextLabel", loadingScreen)
loadingLabel.Size = UDim2.new(1, 0, 1, 0)
loadingLabel.BackgroundColor3 = Color3.new(0, 0, 0)
loadingLabel.BorderSizePixel = 0
loadingLabel.Text = "SpirSkyTP"
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextScaled = true
loadingLabel.Visible = false

-- Función para mostrar y ocultar pantalla de carga
local function showLoading()
	loadingLabel.Visible = true
	wait(1.5)
	loadingLabel.Visible = false
end

-- Bypass para que no te mate cuando sales de la base
local function safeTeleport(pos)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local noclipConn
	noclipConn = RunService.Stepped:Connect(function()
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)

	showLoading()

	root.CFrame = CFrame.new(pos)

	wait(2)
	if noclipConn then noclipConn:Disconnect() end
end

-- Detector de Brainrot
RunService.Heartbeat:Connect(function()
	if teleported then return end

	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character
	if not character then return end

	for _, item in pairs(character:GetChildren()) do
		if item:IsA("Tool") and item.Name:lower():find("brainrot") then
			teleported = true
			safeTeleport(skyPosition)
		end
	end
end)
