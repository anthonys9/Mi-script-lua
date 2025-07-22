-- Ultimate NoDamaged Protection Script for Steal a Brainrot
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local brainrotName = "Brainrot" -- Name of the item to detect

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "UltimateNoDamagedGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 160, 0, 50)
Frame.Position = UDim2.new(0.5, -80, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Icon = Instance.new("ImageLabel", Frame)
Icon.Size = UDim2.new(0, 30, 0, 30)
Icon.Position = UDim2.new(0, 10, 0.5, -15)
Icon.BackgroundTransparency = 1
Icon.Image = "http://www.roblox.com/asset/?id=6031094678" -- Lightning icon

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -50, 1, 0)
Button.Position = UDim2.new(0, 45, 0, 0)
Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Text = "No Damaged: OFF"

local enabled = false
local noclipEnabled = false
local bodyParts = {}

-- Function to get current character & humanoid (handles respawn)
local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
end

updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

-- Function to check if player holds brainrot
local function isHoldingBrainrot()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name == brainrotName then
        return true
    end
    return false
end

-- Noclip function
local function setNoclip(state)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
    noclipEnabled = state
end

-- Make player semi-transparent (intangible visual)
local function setTransparency(state)
    local transparencyValue = state and 0.5 or 0
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = transparencyValue
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = transparencyValue
        end
    end
end

-- Keep health maxed and reset debuffs constantly
local function protectHumanoid()
    if not humanoid or humanoid.Health <= 0 then return end
    humanoid.MaxHealth = math.huge
    humanoid.Health = humanoid.MaxHealth
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50

    -- Disconnect old connections if any
    if protectHumanoid.connection then protectHumanoid.connection:Disconnect() end
    if protectHumanoid.platformStandConnection then protectHumanoid.platformStandConnection:Disconnect() end

    protectHumanoid.connection = RunService.Heartbeat:Connect(function()
        if not enabled then return end

        -- Regenerate health
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end

        -- Remove PlatformStand (taser)
        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
        end

        -- Reset WalkSpeed and JumpPower to avoid freeze
        if humanoid.WalkSpeed <= 0 then
            humanoid.WalkSpeed = 16
        end
        if humanoid.JumpPower <= 0 then
            humanoid.JumpPower = 50
        end
    end)
end

-- Intangible state (noclip + transparency)
local function enableProtection()
    setNoclip(true)
    setTransparency(true)
    protectHumanoid()
end

local function disableProtection()
    setNoclip(false)
    setTransparency(false)
    if protectHumanoid.connection then protectHumanoid.connection:Disconnect() end
    if protectHumanoid.platformStandConnection then protectHumanoid.platformStandConnection:Disconnect() end
    -- Reset humanoid defaults
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

-- Main toggle button logic
Button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        Button.Text = "No Damaged: ON"
        Button.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        if isHoldingBrainrot() then
            enableProtection()
        end
    else
        Button.Text = "No Damaged: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        disableProtection()
    end
end)

-- Auto toggle protection when brainrot is picked up or dropped
RunService.Heartbeat:Connect(function()
    if enabled then
        if isHoldingBrainrot() then
            enableProtection()
        else
            disableProtection()
        end
    end
end)
