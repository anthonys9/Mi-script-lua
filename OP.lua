local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local function createGui()
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "SpirUniversal"

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 170)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = gui
	frame.Active = true
	frame.Draggable = true

	local function createButton(name, yOffset, callback)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 180, 0, 30)
		button.Position = UDim2.new(0, 10, 0, yOffset)
		button.Text = name
		button.TextColor3 = Color3.new(1, 1, 1)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.Parent = frame
		button.MouseButton1Click:Connect(callback)
		return button
	end

	return frame, createButton
end

local function initScript()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local walkOnAirEnabled = false
	local noclipEnabled = false
	local flyingEnabled = false
	local flySpeed = 5
	local airParts = {}

	local frame, createButton = createGui()

	-- WALK ON AIR
	createButton("Walk on Air: OFF", 10, function(btn)
		walkOnAirEnabled = not walkOnAirEnabled
		btn.Text = "Walk on Air: " .. (walkOnAirEnabled and "ON" or "OFF")
	end)

	-- NOCLIP
	createButton("Noclip: OFF", 45, function(btn)
		noclipEnabled = not noclipEnabled
		btn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
	end)

	-- FLY TOGGLE
	local flyBtn = createButton("Fly: OFF", 80, function(btn)
		flyingEnabled = not flyingEnabled
		btn.Text = "Fly: " .. (flyingEnabled and "ON" or "OFF")
		speedUpBtn.Visible = flyingEnabled
		speedDownBtn.Visible = flyingEnabled
	end)

	-- SPEED UP / DOWN
	local speedUpBtn = createButton("Speed +", 115, function()
		flySpeed = flySpeed + 1
	end)
	local speedDownBtn = createButton("Speed -", 150, function()
		flySpeed = math.max(1, flySpeed - 1)
	end)
	speedUpBtn.Visible = false
	speedDownBtn.Visible = false

	-- NOCLIP HANDLER
	RunService.Stepped:Connect(function()
		if noclipEnabled then
			for _, part in pairs((player.Character or {}).GetDescendants and player.Character:GetDescendants() or {}) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end
	end)

	-- FLY HANDLER
	local flyDir = Vector3.zero
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.W then flyDir = Vector3.new(0, 0, -1) end
		if input.KeyCode == Enum.KeyCode.S then flyDir = Vector3.new(0, 0, 1) end
		if input.KeyCode == Enum.KeyCode.A then flyDir = Vector3.new(-1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.D then flyDir = Vector3.new(1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.Space then flyDir = Vector3.new(0, 1, 0) end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Space then
			flyDir = Vector3.zero
		end
	end)

	RunService.Heartbeat:Connect(function()
		character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return end
		hrp = character.HumanoidRootPart

		-- Fly
		if flyingEnabled and flyDir.Magnitude > 0 then
			local camCF = workspace.CurrentCamera.CFrame
			local moveVec = camCF:VectorToWorldSpace(flyDir).Unit * flySpeed
			hrp.Velocity = moveVec
		end

		-- Walk on air
		if walkOnAirEnabled then
			local ray = Ray.new(hrp.Position, Vector3.new(0, -6, 0))
			local _, hit = workspace:FindPartOnRay(ray, character)
			if not hit then
				local air = Instance.new("Part")
				air.Size = Vector3.new(6, 1, 6)
				air.Position = hrp.Position - Vector3.new(0, 3, 0)
				air.Anchored = true
				air.Transparency = 1
				air.CanCollide = true
				air.Parent = workspace
				table.insert(airParts, air)
				game.Debris:AddItem(air, 0.5)
			end
		end
	end)
end

-- Auto re-run on respawn
player.CharacterAdded:Connect(function()
	wait(1)
	pcall(initScript)
end)

-- Initial run
pcall(initScript)
