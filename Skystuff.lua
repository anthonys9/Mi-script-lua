local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Variables
local savedPos = nil
local noclip = false
local godActive = false

-- GUI setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpirSkyTP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

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
tpBtn.Text = "speedgoat"
tpBtn.TextScaled = true
tpBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)

-- Loading screen function
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

-- God mode (no morir)
local function enableGod()
	if godActive then return end
	godActive = true
	humanoid.Health = humanoid.MaxHealth
	humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if godActive then
			humanoid.Health = humanoid.MaxHealth
		end
	end)
end

local function disableGod()
	godActive = false
end

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
	if noclip then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- Guardar posición
saveBtn.MouseButton1Click:Connect(function()
	savedPos = hrp.Position + Vector3.new(0, 100, 0)
	print("[SpirSkyTP] Position saved at:", savedPos)
end)

-- Teletransporte
tpBtn.MouseButton1Click:Connect(function()
	if savedPos then
		showLoading()
		noclip = true
		enableGod()
		hrp.CFrame = CFrame.new(savedPos)
	end
end)

-- Detectar Brainrot en mano y teletransportar automáticamente
game:GetService("RunService").Heartbeat:Connect(function()
	pcall(function()
		local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
		if tool and tool.Name:lower():find("brainrot") and savedPos then
			showLoading()
			noclip = true
			enableGod()
			hrp.CFrame = CFrame.new(savedPos)
		end
		
		-- Desactivar god mode si estás en el suelo (approx check)
		local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
		local hit, _ = workspace:FindPartOnRay(ray, char)
		if hit then
			disableGod()
			noclip = false
		end
	end)
end)
