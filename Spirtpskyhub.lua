local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleported = false
local skyHeight = 5000 -- altura para teletransportarte al cielo

-- Crear pantalla de carga completa
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "SpirSkyTP_Loading"
loadingGui.Parent = player:WaitForChild("PlayerGui")

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1,0,1,0)
loadingFrame.BackgroundColor3 = Color3.new(0,0,0)
loadingFrame.Parent = loadingGui
loadingFrame.Visible = false

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1,0,1,0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextScaled = true
loadingText.Text = "SpirSkyTP"
loadingText.Parent = loadingFrame

-- Función para mostrar pantalla de carga por X segundos
local function showLoading(seconds)
	loadingFrame.Visible = true
	wait(seconds)
	loadingFrame.Visible = false
end

-- Bypass noclip mientras teletransportas para evitar detección
local function startNoclip()
	local conn
	conn = RunService.Stepped:Connect(function()
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
	return conn
end

local function stopNoclip(conn)
	if conn then conn:Disconnect() end
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
end

-- Teletransporta al cielo y luego cae suavemente a la base
local function teleportToSkyAndBase()
	if teleported then return end
	teleported = true

	local noclipConn = startNoclip()

	showLoading(1.5)

	-- Teleportar al cielo
	local skyPos = humanoidRootPart.Position + Vector3.new(0, skyHeight, 0)
	humanoidRootPart.CFrame = CFrame.new(skyPos)

	wait(0.5)

	-- Caída suave a la base (cambia coords base aquí)
	local basePos = Vector3.new(-150, 10, -70)

	local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Quad), {
		CFrame = CFrame.new(basePos + Vector3.new(0, 10, 0))
	})
	tween:Play()
	tween.Completed:Wait()

	wait(0.3)
	humanoidRootPart.CFrame = CFrame.new(basePos)

	stopNoclip(noclipConn)
end

-- Detecta el Brainrot en mano y activa teletransporte
RunService.Heartbeat:Connect(function()
	if teleported then return end
	if not character or not character.Parent then
		character = player.Character or player.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	end

	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:lower():find("brainrot") then
			teleportToSkyAndBase()
			break
		end
	end
end)
