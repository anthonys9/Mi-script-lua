local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local brainrotToolName = "Brainrot"
local savedPosition = nil
local teleportCooldown = false

-- GUI SETUP
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SpirRoofTP"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

-- Save Position Button
local saveButton = Instance.new("TextButton", frame)
saveButton.Size = UDim2.new(1, 0, 0.33, 0)
saveButton.Position = UDim2.new(0, 0, 0, 0)
saveButton.Text = "Save Position"
saveButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextScaled = true

-- Teleport Button
local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(1, 0, 0.33, 0)
tpButton.Position = UDim2.new(0, 0, 0.33, 0)
tpButton.Text = "Roof TP Now"
tpButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextScaled = true

-- Status Label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0.34, 0)
statusLabel.Position = UDim2.new(0, 0, 0.66, 0)
statusLabel.Text = "Position: Not Set"
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextScaled = true

-- Loading Screen
local playerGui = player:WaitForChild("PlayerGui")

local loadingScreen = Instance.new("Frame")
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.new(0, 0, 0)
loadingScreen.BackgroundTransparency = 0.5
loadingScreen.ZIndex = 1000
loadingScreen.Parent = playerGui
loadingScreen.Visible = false

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, 0, 1, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextScaled = true
loadingLabel.Text = "Teleporting..."
loadingLabel.Parent = loadingScreen

-- Save Position Button Function
saveButton.MouseButton1Click:Connect(function()
	if character and character:FindFirstChild("HumanoidRootPart") then
		local pos = character.HumanoidRootPart.Position
		savedPosition = Vector3.new(pos.X, pos.Y + 50, pos.Z) -- Roof height offset
		statusLabel.Text = "Position: Saved"
	end
end)

local function doTeleport()
	if teleportCooldown or not savedPosition then return end
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local handTool = character:FindFirstChildOfClass("Tool")
	if handTool and handTool.Name == brainrotToolName then
		teleportCooldown = true
		loadingScreen.Visible = true

		character.HumanoidRootPart.CFrame = CFrame.new(savedPosition + Vector3.new(0, 10, 0))

		task.wait(2)

		loadingScreen.Visible = false
		teleportCooldown = false
	else
		statusLabel.Text = "Hold Brainrot to TP!"
	end
end

-- Teleport Button Function
tpButton.MouseButton1Click:Connect(doTeleport)

-- Auto TP if holding Brainrot
RunService.Heartbeat:Connect(function()
	if teleportCooldown or not savedPosition then return end

	local handTool = character:FindFirstChildOfClass("Tool")
	if handTool and handTool.Name == brainrotToolName then
		doTeleport()
	end
end)
