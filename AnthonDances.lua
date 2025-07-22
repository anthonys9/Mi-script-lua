local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Animations IDs oficiales Roblox FE (puedes cambiar o agregar)
local dances = {
    {Name = "Dance 1", AnimationId = "rbxassetid://2416663241"},
    {Name = "Dance 2", AnimationId = "rbxassetid://2416662645"},
    {Name = "Dance 3", AnimationId = "rbxassetid://2416662733"},
    {Name = "Dance 4", AnimationId = "rbxassetid://2416663474"},
    {Name = "Dance 5", AnimationId = "rbxassetid://2416663036"},
    {Name = "Dance 6", AnimationId = "rbxassetid://2416663372"},
    {Name = "Dance 7", AnimationId = "rbxassetid://2416663556"},
    {Name = "Dance 8", AnimationId = "rbxassetid://2416663584"},
    {Name = "Dance 9", AnimationId = "rbxassetid://2416663611"},
    {Name = "Dance 10", AnimationId = "rbxassetid://2416663660"},
    {Name = "Dance 11", AnimationId = "rbxassetid://2416663694"},
    {Name = "Dance 12", AnimationId = "rbxassetid://2416663726"},
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnthonyDanceGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 50)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "AnthonyDance's"
toggleButton.Parent = mainFrame

local danceFrame = Instance.new("Frame")
danceFrame.Size = UDim2.new(0, 150, 0, 0) -- starts hidden (height 0)
danceFrame.Position = UDim2.new(0, 0, 1, 0)
danceFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
danceFrame.BorderSizePixel = 0
danceFrame.ClipsDescendants = true
danceFrame.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = danceFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local animationTrack = nil

-- Function to play animation
local function playAnimation(animId)
    if animationTrack then
        animationTrack:Stop()
        animationTrack:Destroy()
        animationTrack = nil
    end
    local animator = humanoid:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", humanoid)
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    animationTrack = animator:LoadAnimation(anim)
    animationTrack:Play()
end

-- Function to stop animation
local function stopAnimation()
    if animationTrack then
        animationTrack:Stop()
        animationTrack:Destroy()
        animationTrack = nil
    end
end

-- Toggle danceFrame visibility
local expanded = false
toggleButton.MouseButton1Click:Connect(function()
    expanded = not expanded
    if expanded then
        danceFrame:TweenSize(UDim2.new(0, 150, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    else
        danceFrame:TweenSize(UDim2.new(0, 150, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        stopAnimation()
    end
end)

-- Create buttons for dances + stop button
for i, dance in ipairs(dances) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = dance.Name
    btn.Parent = danceFrame
    btn.LayoutOrder = i

    btn.MouseButton1Click:Connect(function()
        playAnimation(dance.AnimationId)
    end)
end

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -10, 0, 30)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextScaled = true
stopBtn.Text = "Stop Animation"
stopBtn.Parent = danceFrame
stopBtn.LayoutOrder = #dances + 1
stopBtn.MouseButton1Click:Connect(stopAnimation)
