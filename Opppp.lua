-- InsanidiTP Module (spoof + noclip + tp)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local spoofing = false
local noclipActive = false
local spoofPosition = nil

local function noclipOn()
    noclipActive = true
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function noclipOff()
    noclipActive = false
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Spoof position metatable hack
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if spoofing and method == "FireServer" then
        -- Check for events that send position updates here and spoof them
        -- This depends on the specific game implementation, you must customize
        -- Example placeholder:
        -- if self.Name == "SomeRemoteEvent" and args[1] == "UpdatePosition" then
        --     args[2] = spoofPosition
        --     return oldNamecall(self, unpack(args))
        -- end
    end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, key)
    if spoofing and (key == "CFrame" or key == "Position") and self == character.HumanoidRootPart then
        return spoofPosition or oldIndex(self, key)
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)

local function spoofPositionStart(pos)
    spoofPosition = pos
    spoofing = true
end

local function spoofPositionStop()
    spoofing = false
    spoofPosition = nil
end

local function teleportTo(position)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    spoofPositionStart(character.HumanoidRootPart.CFrame)

    noclipOn()

    -- Tween smooth teleport to avoid anti-cheat
    local TweenService = game:GetService("TweenService")
    local hrp = character.HumanoidRootPart

    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = position})
    tween:Play()
    tween.Completed:Wait()

    noclipOff()
    spoofPositionStop()
end

-- Loading screen
local function showLoadingScreen(text)
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui", playerGui)
    screenGui.Name = "SpoofLoadingGui"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BackgroundTransparency = 0.5

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.BackgroundTransparency = 1

    return screenGui
end

-- Expose functions
return {
    TeleportTo = teleportTo,
    ShowLoadingScreen = showLoadingScreen,
    NoclipOn = noclipOn,
    NoclipOff = noclipOff,
}
