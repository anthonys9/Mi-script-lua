-- NoDamaged GUI with Icon and Full Protection
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NoDamagedGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 130, 0, 50)
Frame.Position = UDim2.new(0.5, -65, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local Icon = Instance.new("ImageLabel", Frame)
Icon.Size = UDim2.new(0, 24, 0, 24)
Icon.Position = UDim2.new(0, 6, 0.5, -12)
Icon.BackgroundTransparency = 1
Icon.Image = "http://www.roblox.com/asset/?id=6031094678" -- ⚡ Rayo ícono

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -35, 1, 0)
Button.Position = UDim2.new(0, 30, 0, 0)
Button.Text = "No Damaged"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14

local enabled = false

-- Protección mágica anti daño
local function protect()
	if not Character or not Character:FindFirstChild("Humanoid") then return end
	local humanoid = Character:FindFirstChild("Humanoid")

	-- Vida infinita y regeneración
	humanoid.MaxHealth = math.huge
	humanoid.Health = humanoid.MaxHealth

	-- Protección de estado
	humanoid.StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)

	-- Hacer intangible (como noclip) si te pegan
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

Button.MouseButton1Click:Connect(function()
	enabled = not enabled
	Button.Text = enabled and "Protected ⚡" or "No Damaged"
	if enabled then
		protect()
		while enabled do
			task.wait(0.25)
			Character = Player.Character or Player.CharacterAdded:Wait()
			if Character:FindFirstChild("Humanoid") then
				Character.Humanoid.Health = Character.Humanoid.MaxHealth
				for _, part in pairs(Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end
	end
end)
