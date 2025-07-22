-- NoDamaged Ultimate Protection Script with movable button and lightning icon
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NoDamagedUltimateGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 140, 0, 50)
Frame.Position = UDim2.new(0.5, -70, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

local Icon = Instance.new("ImageLabel", Frame)
Icon.Size = UDim2.new(0, 28, 0, 28)
Icon.Position = UDim2.new(0, 6, 0.5, -14)
Icon.BackgroundTransparency = 1
Icon.Image = "http://www.roblox.com/asset/?id=6031094678" -- Lightning icon

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -40, 1, 0)
Button.Position = UDim2.new(0, 38, 0, 0)
Button.Text = "No Damaged"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 15
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Button.AutoButtonColor = false

local enabled = false
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local function makeIntangible()
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Transparency = 0.5
		elseif part:IsA("Decal") or part:IsA("Texture") then
			part.Transparency = 0.5
		end
	end
end

local function makeTangible()
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
			part.Transparency = 0
		elseif part:IsA("Decal") or part:IsA("Texture") then
			part.Transparency = 0
		end
	end
end

local function protectHumanoid()
	if not Humanoid or Humanoid.Health <= 0 then return end
	
	Humanoid.MaxHealth = math.huge
	Humanoid.Health = Humanoid.MaxHealth
	
	Humanoid.StateChanged:Connect(function(_, newState)
		if enabled then
			if newState == Enum.HumanoidStateType.FallingDown or
				newState == Enum.HumanoidStateType.Ragdoll or
				newState == Enum.HumanoidStateType.PlatformStanding or
				newState == Enum.HumanoidStateType.Dead then
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
		end
	end)
end

local function antiTaser()
	RunService.Heartbeat:Connect(function()
		if enabled and Humanoid.PlatformStand == true then
			Humanoid.PlatformStand = false
		end
	end)
end

local function antiFreeze()
	RunService.Heartbeat:Connect(function()
		if enabled then
			if Humanoid.WalkSpeed == 0 then Humanoid.WalkSpeed = 16 end
			if Humanoid.JumpPower == 0 then Humanoid.JumpPower = 50 end
		end
	end)
end

local function noDamagedLoop()
	spawn(function()
		while enabled do
			task.wait(0.2)
			Character = Player.Character or Player.CharacterAdded:Wait()
			Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
				Humanoid.Health = Humanoid.MaxHealth
			end
			makeIntangible()
		end
		makeTangible()
	end)
end

Button.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		Button.Text = "Protected ⚡"
		Button.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
		protectHumanoid()
		noDamagedLoop()
		antiTaser()
		antiFreeze()
	else
		Button.Text = "No Damaged"
		Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		makeTangible()
	end
end)
