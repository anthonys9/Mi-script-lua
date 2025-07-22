local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local floating = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 50)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- steel blue
button.Text = "Float: OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.Parent = frame

-- Floating function
local floatForce

local function enableFloat()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    floatForce = Instance.new("BodyPosition")
    floatForce.Position = character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    floatForce.MaxForce = Vector3.new(0, math.huge, 0)
    floatForce.P = 1000
    floatForce.Parent = character.HumanoidRootPart
end

local function disableFloat()
    if floatForce then
        floatForce:Destroy()
        floatForce = nil
    end
end

-- Button toggle
button.MouseButton1Click:Connect(function()
    floating = not floating
    if floating then
        button.Text = "Float: ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 205, 50) -- lime green
        enableFloat()
    else
        button.Text = "Float: OFF"
        button.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- steel blue
        disableFloat()
    end
end)

-- Keep floating position updated
game:GetService("RunService").Heartbeat:Connect(function()
    if floating and floatForce and character and character:FindFirstChild("HumanoidRootPart") then
        floatForce.Position = character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    end
end)
