local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpirSkyTP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SpirSkyTP"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Size = UDim2.new(1, -20, 0, 40)
saveBtn.Position = UDim2.new(0, 10, 0, 50)
saveBtn.Text = "Save Position"
saveBtn.TextScaled = true
saveBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 100)
tpBtn.Text = "Speed.op"
tpBtn.TextScaled = true
tpBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)

local savedPos = nil

saveBtn.MouseButton1Click:Connect(function()
	savedPos = hrp.Position + Vector3.new(0, 100, 0)
end)

-- Pantalla de carga
local function showLoading()
	local loading = Instance.new("ScreenGui", game.CoreGui)
	loading.Name = "SpirSkyTP_Loading"
	local text = Instance.new("TextLabel", loading)
	text.Size = UDim2.new(1,0,1,0)
	text.Text = "SpirSkyTP"
	text.TextColor3 = Color3.new(1,1,1)
	text.BackgroundColor3 = Color3.new(0,0,0)
	text.TextScaled = true
	wait(1.5)
	loading:Destroy()
end

-- God mode
local function godMode()
	humanoid.Health = humanoid.MaxHealth
	humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		humanoid.Health = humanoid.MaxHealth
	end)
end

-- Bypass y noclip
local noclip = false
game:GetService("RunService").Stepped:Connect(function()
	if noclip then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- Teleport
tpBtn.MouseButton1Click:Connect(function()
	if savedPos then
		showLoading()
		noclip = true
		godMode()
		hrp.CFrame = CFrame.new(savedPos)
	end
end)

-- Auto-TP cuando agarras el brainrot
game:GetService("RunService").Heartbeat:Connect(function()
	pcall(function()
		local tool = player.Character:FindFirstChildOfClass("Tool")
		if tool and tool.Name:lower():find("brainrot") then
			if savedPos then
				showLoading()
				noclip = true
				godMode()
				hrp.CFrame = CFrame.new(savedPos)
			end
		end
	end)
end)
