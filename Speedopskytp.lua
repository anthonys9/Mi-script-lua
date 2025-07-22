local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
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

-- Save Position button
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 180, 0, 50)
saveButton.Position = UDim2.new(0, 10, 0, 10)
saveButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
saveButton.Text = "Save Position"
saveButton.TextColor3 = Color3.new(1,1,1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextScaled = true
saveButton.Parent = frame

-- Speed.OP button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 70)
speedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
speedButton.Text = "Speed.OP: OFF"
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextScaled = true
speedButton.Parent = frame

-- Noclip bypass function
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

-- Show loading screen for seconds
local function showLoading(seconds)
	loadingFrame.Visible = true
	wait(seconds)
	loadingFrame.Visible = false
end

local function teleportToPos(pos)
	if not humanoidRootPart then return end
	startNoclip()
	showLoading(1.5)
	
	local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Quad), {
		CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
	})
	tween:Play()
	tween.Completed:Wait()
	
	stopNoclip()
end

-- Save Position Button event
saveButton.MouseButton1Click:Connect(function()
	savedPosition = humanoidRootPart.Position
	saveButton.Text = "Position Saved!"
	wait(1.5)
	saveButton.Text = "Save Position"
end)

-- Speed.OP Button event toggle
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

-- Auto toggle off after teleport
RunService.Heartbeat:Connect(function()
	if speedOPEnabled and savedPosition then
		if not character or not character.Parent then
			character = player.Character or player.CharacterAdded:Wait()
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
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
