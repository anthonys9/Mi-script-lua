local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local savedPosition = nil
local speedOPEnabled = false

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpirSkyTP_GUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

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

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 180, 0, 50)
saveButton.Position = UDim2.new(0, 10, 0, 10)
saveButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
saveButton.Text = "Save Position"
saveButton.TextColor3 = Color3.new(1,1,1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextScaled = true
saveButton.Parent = frame

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 70)
speedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
speedButton.Text = "Speed.OP: OFF"
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextScaled = true
speedButton.Parent = frame

local noclipConn

local function startNoclip()
	noclipConn = RunService.Stepped:Connect(function()
		if character and character.Parent then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end

local function stopNoclip()
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
	if character and character.Parent then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

local function makeInvulnerable(duration)
	if not humanoid then return end
	local originalHealth = humanoid.Health
	local originalMaxHealth = humanoid.MaxHealth
	
	humanoid.MaxHealth = math.huge
	humanoid.Health = math.huge
	
	delay(duration, function()
		if humanoid and humanoid.Parent then
			humanoid.MaxHealth = originalMaxHealth
			if humanoid.Health > originalMaxHealth then
				humanoid.Health = originalMaxHealth
			end
		end
	end)
end

local function showLoading(seconds)
	loadingFrame.Visible = true
	wait(seconds)
	loadingFrame.Visible = false
end

local function teleportToPos(pos)
	if not humanoidRootPart then return end
	
	startNoclip()
	makeInvulnerable(5) -- Invulnerable 5 segundos
	
	showLoading(1.5)
	
	local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(2.5, Enum.EasingStyle.Quad), {
		CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
	})
	tween:Play()
	tween.Completed:Wait()
	
	wait(0.5) -- Pequeña pausa para evitar daño caida
	
	stopNoclip()
end

saveButton.MouseButton1Click:Connect(function()
	savedPosition = humanoidRootPart.Position
	saveButton.Text = "Position Saved!"
	wait(1.5)
	saveButton.Text = "Save Position"
end)

speedButton.MouseButton1Click:Connect(function()
	speedOPEnabled = not speedOPEnabled
	if speedOPEnabled then
		speedButton.Text = "Speed.OP: ON"
		if savedPosition then
			teleportToPos(savedPosition + Vector3.new(0,50,0))
		else
			speedButton.Text = "No position saved!"
			wait(1.5)
			speedButton.Text = "Speed.OP: ON"
		end
	else
		speedButton.Text = "Speed.OP: OFF"
	end
end)

RunService.Heartbeat:Connect(function()
	if speedOPEnabled and savedPosition then
		if not character or not character.Parent then
			character = player.Character or player.CharacterAdded:Wait()
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
			humanoid = character:WaitForChild("Humanoid")
		end
		
		local hasBrainrot = false
		for _, tool in pairs(character:GetChildren()) do
			if tool:IsA("Tool") and tool.Name:lower():find("brainrot") then
				hasBrainrot = true
				break
			end
		end
		
		if not hasBrainrot then
			speedOPEnabled = false
			speedButton.Text = "Speed.OP: OFF"
		end
	end
end)
