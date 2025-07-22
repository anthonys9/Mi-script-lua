local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local isTall = false
local scaleFactor = 3 -- cuánto quieres aumentar (3x más alto)

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalHeightChanger"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 170, 0, 50)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.Text = "Become Giant: OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.Parent = frame

local originalSizes = {}

local function scaleCharacter(character, scale)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            if not originalSizes[part] then
                originalSizes[part] = part.Size
            end
            part.Size = originalSizes[part] * scale
        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
            local handle = part.Handle
            if not originalSizes[handle] then
                originalSizes[handle] = handle.Size
            end
            handle.Size = originalSizes[handle] * scale
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local bodyHeightScale = humanoid:FindFirstChild("BodyHeightScale")
        local bodyDepthScale = humanoid:FindFirstChild("BodyDepthScale")
        local bodyWidthScale = humanoid:FindFirstChild("BodyWidthScale")

        if not bodyHeightScale then
            bodyHeightScale = Instance.new("NumberValue")
            bodyHeightScale.Name = "BodyHeightScale"
            bodyHeightScale.Parent = humanoid
        end
        if not bodyDepthScale then
            bodyDepthScale = Instance.new("NumberValue")
            bodyDepthScale.Name = "BodyDepthScale"
            bodyDepthScale.Parent = humanoid
        end
        if not bodyWidthScale then
            bodyWidthScale = Instance.new("NumberValue")
            bodyWidthScale.Name = "BodyWidthScale"
            bodyWidthScale.Parent = humanoid
        end

        bodyHeightScale.Value = scale
        bodyDepthScale.Value = scale
        bodyWidthScale.Value = scale
    end
end

local function resetCharacter(character)
    for part, size in pairs(originalSizes) do
        if part and part.Parent then
            part.Size = size
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local bodyHeightScale = humanoid:FindFirstChild("BodyHeightScale")
        local bodyDepthScale = humanoid:FindFirstChild("BodyDepthScale")
        local bodyWidthScale = humanoid:FindFirstChild("BodyWidthScale")

        if bodyHeightScale then bodyHeightScale.Value = 1 end
        if bodyDepthScale then bodyDepthScale.Value = 1 end
        if bodyWidthScale then bodyWidthScale.Value = 1 end
    end
end

button.MouseButton1Click:Connect(function()
    isTall = not isTall
    if isTall then
        button.Text = "Become Giant: ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        scaleCharacter(character, scaleFactor)
    else
        button.Text = "Become Giant: OFF"
        button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        resetCharacter(character)
    end
end)
