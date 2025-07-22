--[[
    Script: insanidiTPv2 by CoolkiddIa & Anthony 🐐
    Loading screen "Anthony the GOAT", safe TP with spoof, noclip, and floating menu button.
]]

-- Loading screen
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.ZIndex = 999

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1, 0, 1, 0)
Label.Text = "Anthony the GOAT"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamBlack
Label.TextScaled = true
Label.BackgroundTransparency = 1

wait(2.5)
Frame:Destroy()

-- Main GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local mainBtn = Instance.new("ImageButton", gui)
mainBtn.Size = UDim2.new(0, 70, 0, 70)
mainBtn.Position = UDim2.new(0, 20, 0.3, 0)
mainBtn.BackgroundTransparency = 1
mainBtn.Image = "rbxassetid://16581741144" -- Goat + explosion icon

-- Dropdown menu
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Visible = false
frame.Active = true
frame.Draggable = true

mainBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Save Position button
local saveBtn = Instance.new("TextButton", frame)
saveBtn.Size = UDim2.new(1, -10, 0, 50)
saveBtn.Position = UDim2.new(0, 5, 0, 10)
saveBtn.Text = "Save Position"
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.TextScaled = true

-- Teleport button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -10, 0, 50)
tpBtn.Position = UDim2.new(0, 5, 0, 65)
tpBtn.Text = "speedgoat"
tpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.SourceSansBold
tpBtn.TextScaled = true

-- Position logic
local savedPosition = nil

saveBtn.MouseButton1Click:Connect(function()
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		savedPosition = char.HumanoidRootPart.Position
		print("Position saved:", savedPosition)
	end
end)

-- Safe teleport with spoof and noclip
tpBtn.MouseButton1Click:Connect(function()
	if not savedPosition then return end

	local player = game.Players.LocalPlayer
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")

	-- Spoof to a far away location before teleporting
	local spoofPart = Instance.new("Part", workspace)
	spoofPart.Anchored = true
	spoofPart.Transparency = 1
	spoofPart.CanCollide = false
	spoofPart.Position = Vector3.new(99999, 99999, 99999)
	hrp.CFrame = spoofPart.CFrame
	wait(0.15)

	-- Noclip temporarily
	local function noclip()
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end

	noclip()

	-- Smooth TP using Tween
	local TweenService = game:GetService("TweenService")
	local goal = {}
	goal.CFrame = CFrame.new(savedPosition + Vector3.new(0, 5, 0))
	local tween = TweenService:Create(hrp, TweenInfo.new(0.75, Enum.EasingStyle.Linear), goal)
	tween:Play()

	tween.Completed:Wait()
end)
