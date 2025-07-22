local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Variables
local noDamagedActive = false

-- Create GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "NoDamagedGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0.5, -90, 0.5, -30)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
button.Text = "No Damaged: OFF"
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true

-- Toggle function
local function toggleNoDamaged()
    noDamagedActive = not noDamagedActive
    if noDamagedActive then
        button.Text = "No Damaged: ON"
        button.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    else
        button.Text = "No Damaged: OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
end

button.MouseButton1Click:Connect(toggleNoDamaged)

-- Check if player has Brainrot tool
local function hasBrainrot()
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("brainrot") then
        return true
    end
    return false
end

-- Anti-damage and anti-control bypass
RunService.Heartbeat:Connect(function()
    if noDamagedActive and hasBrainrot() then
        pcall(function()
            -- Keep health max
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- Remove freezing effects if any
            if char:FindFirstChild("Frozen") then
                char.Frozen:Destroy()
            end
            
            -- Remove any grab welds by taser, medusa, or bat
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Weld") or v:IsA("Motor6D") then
                    if v.Name == "TaserGrab" or v.Name == "MedusaGrab" or v.Name == "BatGrab" then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end)
