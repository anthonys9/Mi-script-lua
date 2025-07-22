local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleported = false
local savedPosition = nil
local skyHeight = 5000 -- altura para teletransportar

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpirSkyTP_GUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- Loading screen
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1,0,1,0)
loadingFrame.BackgroundColor3 = Color3.new(0,0,0)
loadingFrame.Visible = false
loadingFrame.Parent = screenGui

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1,0,1,0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.new(1,1,1)
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextScaled = true
loadingLabel.Text = "SpirSkyTP"
loadingLabel.Parent = loadingFrame

-- Buttons
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 160, 0, 40)
saveButton.Position = UDim2.new(0, 10, 0, 10)
saveButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- steel blue
saveButton.Text = "Save Position"
saveButton.TextColor3 = Color3.new(1,1,1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextScaled = true
saveButton.Parent = frame

local skyTPButton = Instance.new("TextButton")
skyTPButton.Size = UDim2.new(0, 160, 0, 40)
skyTPButton.Position = UDim2.new(0, 10, 0, 55)
skyTPButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70) -- green
skyTPButton.Text = "SkySpirTP: OFF"
skyTPButton.TextColor3 = Color3.new(1,1,1)
skyTPButton.Font = Enum.Font.SourceSansBold
skyTPButton.TextScaled = true
skyTPButton.Parent = frame

local skyTPEnabled = false

-- Show loading screen function
local function showLoading(seconds)
	loadingFrame.Visible = true
	wait(seconds)
	loadingFrame.Visible = false
end

-- Noclip bypass while teleporting
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

-- Teleport function with tween and bypass
local function teleportToPosition(pos)
	if not humanoidRootPart then return end

	local noclipConn = startNoclip()

	showLoading(1.5)

	-- Tween caer suave
	local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Quad), {
		CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
	})
	tween:Play()
	tween.Completed:Wait()

	wait(0.3)

	stopNoclip(noclipConn)
end

-- Save position button event
saveButton.MouseButton1Click:Connect(function()
	savedPosition = humanoidRootPart.Position
	saveButton.Text = "Position Saved!"
	wait(1.5)
	saveButton.Text = "Save Position"
end)

-- SkyTP button toggle
skyTPButton.MouseButton1Click:Connect(function()
	skyTPEnabled = not skyTPEnabled
	if skyTPEnabled then
		skyTPButton.Text = "SkySpirTP: ON"
	else
		skyTPButton.Text = "SkySpirTP: OFF"
	end
end)

-- Detect if player has Brainrot and teleport if enabled
RunService.Heartbeat:Connect(function()
	if not skyTPEnabled or not savedPosition then return end

	if not character or not character.Parent then
		character = player.Character or player.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	end

	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:lower():find("brainrot") then
			teleportToPosition(savedPosition + Vector3.new(0, 50, 0)) -- Teleport 50 studs above saved position
			skyTPEnabled = false
			skyTPButton.Text = "SkySpirTP: OFF"
			break
		end
	end
end)
