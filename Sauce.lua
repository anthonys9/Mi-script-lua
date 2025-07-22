loadstring([[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local noclipEnabled = false

-- GUI setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "NoclipGUI"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.75, 0, 0.85, 0)
btn.Text = "Noclip: OFF"
btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextScaled = true
btn.Font = Enum.Font.SourceSansBold
btn.ZIndex = 10
btn.Parent = gui

-- Toggle function
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        btn.Text = "Noclip: ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        btn.Text = "Noclip: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end

btn.MouseButton1Click:Connect(toggleNoclip)

-- Drag system
local dragging, dragInput, dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

btn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Noclip logic
RunService.Stepped:Connect(function()
    if noclipEnabled then
        character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
]])()
