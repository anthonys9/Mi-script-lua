local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local InsanidiTP = {}
InsanidiTP.savedPosition = nil
InsanidiTP.isTeleporting = false

-- Noclip function
local function setNoclip(state)
	for _, part in pairs(Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.CanCollide = not state
		end
	end
end

-- God mode (infinite health)
local function setGodMode(state)
	local humanoid = Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.MaxHealth = math.huge
		if state then
			humanoid.Health = humanoid.MaxHealth
		end
	end
end

-- Loading screen
local function showLoadingScreen()
	local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
	screenGui.Name = "InsanidiLoadingScreen"

	local frame = Instance.new("Frame", screenGui)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 0.6

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Text = "Anthony the Goat"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.Arcade
	label.BackgroundTransparency = 1

	return screenGui
end

-- Teleport function
function InsanidiTP:teleport()
	if not self.savedPosition or self.isTeleporting then return end
	self.isTeleporting = true

	local loadingScreen = showLoadingScreen()
	setNoclip(true)
	setGodMode(true)

	-- Teleport to sky above position
	local skyPosition = self.savedPosition + Vector3.new(0, 50, 0)
	HumanoidRootPart.CFrame = CFrame.new(skyPosition)

	-- Float down slowly
	local bodyPos = Instance.new("BodyPosition", HumanoidRootPart)
	bodyPos.MaxForce = Vector3.new(0, math.huge, 0)
	bodyPos.P = 1000
	bodyPos.Position = skyPosition

	local descendSpeed = 0.5
	local targetY = self.savedPosition.Y + 5

	while HumanoidRootPart.Position.Y > targetY do
		bodyPos.Position = bodyPos.Position - Vector3.new(0, descendSpeed, 0)
		RunService.Heartbeat:Wait()
	end

	bodyPos:Destroy()
	setNoclip(false)
	setGodMode(false)

	if loadingScreen then loadingScreen:Destroy() end
	self.isTeleporting = false
end

-- Save position function
function InsanidiTP:savePosition()
	if Character and HumanoidRootPart then
		self.savedPosition = HumanoidRootPart.Position
		print("Position saved:", self.savedPosition)
	end
end

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "InsanidiTPGui"

local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0, 10, 0, 10)
MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainButton.Text = ""
MainButton.AutoButtonColor = false
MainButton.Active = true
MainButton.Draggable = true
MainButton.ZIndex = 10

-- Add goat icon (unicode emoji 🐐) and explosion icon (💥) using TextLabel layered on button
local IconLabel = Instance.new("TextLabel", MainButton)
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.BackgroundTransparency = 1
IconLabel.Text = "🐐💥"
IconLabel.TextScaled = true
IconLabel.Font = Enum.Font.Arcade
IconLabel.TextColor3 = Color3.new(1, 1, 1)

-- Frame for options (hidden by default)
local OptionsFrame = Instance.new("Frame", ScreenGui)
OptionsFrame.Size = UDim2.new(0, 160, 0, 100)
OptionsFrame.Position = UDim2.new(0, 10, 0, 80)
OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OptionsFrame.Visible = false
OptionsFrame.Active = true
OptionsFrame.Draggable = true

local SaveBtn = Instance.new("TextButton", OptionsFrame)
SaveBtn.Size = UDim2.new(1, -10, 0, 40)
SaveBtn.Position = UDim2.new(0, 5, 0, 10)
SaveBtn.Text = "Save Position"
SaveBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
SaveBtn.TextColor3 = Color3.new(1, 1, 1)
SaveBtn.Font = Enum.Font.SourceSansBold
SaveBtn.TextScaled = true

local TpBtn = Instance.new("TextButton", OptionsFrame)
TpBtn.Size = UDim2.new(1, -10, 0, 40)
TpBtn.Position = UDim2.new(0, 5, 0, 55)
TpBtn.Text = "Insanidi TP"
TpBtn.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
TpBtn.TextColor3 = Color3.new(1, 1, 1)
TpBtn.Font = Enum.Font.SourceSansBold
TpBtn.TextScaled = true

-- Toggle options visibility
MainButton.MouseButton1Click:Connect(function()
	OptionsFrame.Visible = not OptionsFrame.Visible
end)

SaveBtn.MouseButton1Click:Connect(function()
	InsanidiTP:savePosition()
end)

TpBtn.MouseButton1Click:Connect(function()
	InsanidiTP:teleport()
end)
