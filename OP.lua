-- Speedgoat TP Script for Steal a Brainrot
-- Features:
-- Noclip during TP
-- Godmode (infinite health + regen)
-- Tween smooth teleport
-- Movable GUI button "speedgoat"
-- Loading screen during TP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local brainrotName = "Brainrot" -- name of the item to detect

-- Variables
local noclipEnabled = false
local godmodeEnabled = false
local speedgoatEnabled = false

-- Base position saved by user
local savedPosition = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SpeedgoatGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local buttonSpeedgoat = Instance.new("TextButton")
buttonSpeedgoat.Size = UDim2.new(1, 0, 1, 0)
buttonSpeedgoat.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
buttonSpeedgoat.Text = "speedgoat: OFF"
buttonSpeedgoat.TextColor3 = Color3.new(1,1,1)
buttonSpeedgoat.Font = Enum.Font.SourceSansBold
buttonSpeedgoat.TextScaled = true
buttonSpeedgoat.Parent = frame

local buttonSavePos = Instance.new("TextButton")
buttonSavePos.Size = UDim2.new(0, 150, 0, 50)
buttonSavePos.Position = UDim2.new(0, 20, 0, 80)
buttonSavePos.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
buttonSavePos.Text = "Save Position"
buttonSavePos.TextColor3 = Color3.new(1,1,1)
buttonSavePos.Font = Enum.Font.SourceSansBold
buttonSavePos.TextScaled = true
buttonSavePos.Parent = screenGui

-- Loading screen
local loadingScreen = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
loadingScreen.Name = "SpeedgoatLoading"
loadingScreen.Enabled = false

local loadingFrame = Instance.new("Frame", loadingScreen)
loadingFrame.Size = UDim2.new(1,0,1,0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local loadingLabel = Instance.new("TextLabel", loadingFrame)
loadingLabel.Size = UDim2.new(1,0,1,0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.fromRGB(255,255,255)
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextScaled = true
loadingLabel.Text = "SPIR SPEEDGOAT"
loadingLabel.TextStrokeColor3 = Color3.new(0,0,0)
loadingLabel.TextStrokeTransparency = 0
loadingLabel.TextWrapped = true

-- Functions

-- Enable noclip
local function noclipOn()
    noclipEnabled = true
end

-- Disable noclip
local function noclipOff()
    noclipEnabled = false
end

-- Noclip connection
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Enable godmode
local function enableGodmode()
    godmodeEnabled = true
    spawn(function()
        while godmodeEnabled do
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            wait(0.1)
        end
    end)
end

-- Disable godmode
local function disableGodmode()
    godmodeEnabled = false
end

-- Check if player has Brainrot in hands
local function hasBrainrot()
    if character and character:FindFirstChild("RightHand") then
        local rightHand = character.RightHand
        for _, child in pairs(rightHand:GetChildren()) do
            if child.Name == brainrotName then
                return true
            end
        end
    end
    return false
end

-- Tween teleport function
local function tweenTeleport(targetPos)
    if not character or not hrp then return end

    noclipOn()
    enableGodmode()
    loadingScreen.Enabled = true

    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))})

    tween:Play()
    tween.Completed:Wait()

    loadingScreen.Enabled = false
    noclipOff()
    disableGodmode()
end

-- Button save position click
buttonSavePos.MouseButton1Click:Connect(function()
    if hrp then
        savedPosition = hrp.Position
        buttonSavePos.Text = "Position Saved!"
        wait(2)
        buttonSavePos.Text = "Save Position"
    end
end)

-- Button speedgoat click
buttonSpeedgoat.MouseButton1Click:Connect(function()
    speedgoatEnabled = not speedgoatEnabled
    if speedgoatEnabled then
        buttonSpeedgoat.Text = "speedgoat: ON"
        if savedPosition then
            if hasBrainrot() then
                tweenTeleport(savedPosition)
            else
                warn("You need to hold the Brainrot to teleport!")
            end
        else
            warn("Save your base position first!")
        end
    else
        buttonSpeedgoat.Text = "speedgoat: OFF"
    end
end)

-- Allow dragging GUI with finger / mouse
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
