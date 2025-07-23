local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Crear pantalla de key
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KeyUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "Enter Key"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0.3, 0)
box.Position = UDim2.new(0.1, 0, 0.3, 0)
box.PlaceholderText = "Key here..."
box.Text = ""

local button = Instance.new("TextButton", frame)
button.Text = "Submit"
button.Size = UDim2.new(0.5, 0, 0.3, 0)
button.Position = UDim2.new(0.25, 0, 0.65, 0)

local function loadMainMenu()
	gui:Destroy()

	local menu = Instance.new("ScreenGui", game.CoreGui)
	menu.Name = "SperHub"

	local frame = Instance.new("Frame", menu)
	frame.Size = UDim2.new(0, 250, 0, 200)
	frame.Position = UDim2.new(0.5, -125, 0.5, -100)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

	local aimbotBtn = Instance.new("TextButton", frame)
	aimbotBtn.Text = "Aimbot: Off"
	aimbotBtn.Size = UDim2.new(1, 0, 0.3, 0)
	aimbotBtn.Position = UDim2.new(0, 0, 0, 0)

	local spirOpBtn = Instance.new("TextButton", frame)
	spirOpBtn.Text = "SpirOp TP"
	spirOpBtn.Size = UDim2.new(1, 0, 0.3, 0)
	spirOpBtn.Position = UDim2.new(0, 0, 0.35, 0)

	local function activateTP()
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			local tp = Instance.new("Part", workspace)
			tp.Anchored = true
			tp.Transparency = 1
			tp.Size = Vector3.new(1,1,1)
			tp.Position = root.Position + Vector3.new(0, 50, 0)
			wait(0.1)
			root.CFrame = CFrame.new(tp.Position)
			tp:Destroy()
		end
	end

	local aimbotOn = false
	aimbotBtn.MouseButton1Click:Connect(function()
		aimbotOn = not aimbotOn
		aimbotBtn.Text = "Aimbot: " .. (aimbotOn and "On" or "Off")
	end)

	spirOpBtn.MouseButton1Click:Connect(function()
		activateTP()
	end)
end

button.MouseButton1Click:Connect(function()
	if box.Text == "godblessyall" then
		loadMainMenu()
	else
		box.Text = "❌ Incorrect key"
	end
end)
