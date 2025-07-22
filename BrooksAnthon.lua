-- AnthonBrooks GUI for Brookhaven FE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnthonBrooksGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 50)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Text = "AnthonBrooks"
toggleButton.Parent = mainFrame

-- Frame to hold options, initially hidden
local optionsFrame = Instance.new("Frame")
optionsFrame.Size = UDim2.new(0, 180, 0, 300)
optionsFrame.Position = UDim2.new(0, 0, 0, 50)
optionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
optionsFrame.BorderSizePixel = 0
optionsFrame.Visible = false
optionsFrame.Parent = mainFrame

-- Scrolling frame for vertical scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- enough space for options
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = optionsFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = scrollFrame

-- Helper function to create buttons
local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = scrollFrame
    return btn
end

-- Variables for features
local speedBoost = false
local speedValue = 16
local dancePlaying = nil
local noclipOn = false

-- Speed boost button
local speedBtn = createButton("Speed Boost: OFF")

-- Infinite jump button
local infiniteJumpBtn = createButton("Infinite Jump: OFF")

-- Noclip button
local noclipBtn = createButton("Noclip: OFF")

-- Dance menu button (toggle)
local danceMenuBtn = createButton("Show Dances")

-- Frame for dances, hidden by default
local danceFrame = Instance.new("Frame")
danceFrame.Size = UDim2.new(1, -12, 0, 300)
danceFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
danceFrame.Visible = false
danceFrame.Parent = scrollFrame

local danceScroll = Instance.new("ScrollingFrame")
danceScroll.Size = UDim2.new(1, 0, 1, 0)
danceScroll.CanvasSize = UDim2.new(0, 0, 3, 0)
danceScroll.ScrollBarThickness = 6
danceScroll.BackgroundTransparency = 1
danceScroll.Parent = danceFrame

local danceLayout = Instance.new("UIListLayout")
danceLayout.SortOrder = Enum.SortOrder.LayoutOrder
danceLayout.Padding = UDim.new(0, 4)
danceLayout.Parent = danceScroll

-- Dance animations (FE, public IDs)
local dances = {
    {"Wave", "180436334"},
    {"Dance1", "2411470185"},
    {"Dance2", "507771019"},
    {"Dance3", "125750702"},
    {"Dance4", "415257506"},
    {"Dance5", "527116533"},
    {"Dance6", "13342652579"},
    {"Dance7", "494482813"},
    {"Dance8", "2850918148"},
    {"Dance9", "493244567"},
    {"Dance10", "452840116"},
    {"Dance11", "663458875"},
    {"Dance12", "657756107"},
}

local animator
local currentAnimTrack

local function stopCurrentAnim()
    if currentAnimTrack then
        currentAnimTrack:Stop()
        currentAnimTrack = nil
    end
end

local function playAnim(animId)
    stopCurrentAnim()
    if not animator then
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        end
    end
    if animator then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://"..animId
        currentAnimTrack = animator:LoadAnimation(anim)
        currentAnimTrack:Play()
    end
end

-- Create dance buttons
for i, dance in ipairs(dances) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = dance[1]
    btn.Parent = danceScroll
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(function()
        playAnim(dance[2])
    end)
end

-- Button handlers
toggleButton.MouseButton1Click:Connect(function()
    optionsFrame.Visible = not optionsFrame.Visible
end)

speedBtn.MouseButton1Click:Connect(function()
    speedBoost = not speedBoost
    if speedBoost then
        speedValue = 50
        speedBtn.Text = "Speed Boost: ON"
    else
        speedValue = 16
        speedBtn.Text = "Speed Boost: OFF"
    end
end)

infiniteJumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpBtn.Text = (infiniteJumpBtn.Text == "Infinite Jump: OFF") and "Infinite Jump: ON" or "Infinite Jump: OFF"
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    noclipBtn.Text = noclipOn and "Noclip: ON" or "Noclip: OFF"
end)

danceMenuBtn.MouseButton1Click:Connect(function()
    danceFrame.Visible = not danceFrame.Visible
    danceMenuBtn.Text = danceFrame.Visible and "Hide Dances" or "Show Dances"
end)

-- Infinite jump implementation
local infiniteJumpEnabled = false
infiniteJumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Speed boost update
RunService.Heartbeat:Connect(function()
    if character and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.WalkSpeed = speedValue
    end
    -- Noclip toggle
    if noclipOn then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)
