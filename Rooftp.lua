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
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 10, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local saveButton = Instance.new("TextButton", frame)
saveButton.Size = UDim2.new(1, 0, 0.5, 0)
saveButton.Position = UDim2.new(0, 0, 0, 0)
saveButton.Text = "Save Position"
saveButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextScaled = true

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0.5, 0)
statusLabel.Position = UDim2.new(0, 0, 0.5, 0)
statusLabel.Text = "Position: Not Set"
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextScaled = true

-- Save Position Button
saveButton.MouseButton1Click:Connect(function()
	if character and character:FindFirstChild("HumanoidRootPart") then
		local pos = character.HumanoidRootPart.Position
		savedPosition = Vector3.new(pos.X, pos.Y + 50, pos.Z) -- Roof height
		statusLabel.Text = "Position: Saved"
	end
end)

-- Detect Brainrot and TP
RunService.Heartbeat:Connect(function()
	if teleportCooldown or not savedPosition then return end

	local backpack = player:FindFirstChild("Backpack")
	local handTool = character:FindFirstChildOfClass("Tool")

	if (handTool and handTool.Name == brainrotToolName) or
	   (backpack and backpack:FindFirstChild(brainrotToolName)) then
		teleportCooldown = true
		character:MoveTo(savedPosition)
		task.wait(2)
		teleportCooldown = false
	end
end)
