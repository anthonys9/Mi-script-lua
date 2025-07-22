-- Opppp.lua by coolkiddIa & Anthon
-- 🔥 Ultimate TP con spoof, noclip, y pantalla de carga 🔥

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SpirSkyTPGui"
local main = Instance.new("Frame", ScreenGui)
main.Size = UDim2.new(0, 200, 0, 100)
main.Position = UDim2.new(0.5, -100, 0.4, -50)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

local speedGoatBtn = Instance.new("TextButton", main)
speedGoatBtn.Size = UDim2.new(0, 180, 0, 40)
speedGoatBtn.Position = UDim2.new(0, 10, 0, 10)
speedGoatBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedGoatBtn.Text = "🐐 speedgoat"
speedGoatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedGoatBtn.TextScaled = true

local savePosBtn = Instance.new("TextButton", main)
savePosBtn.Size = UDim2.new(0, 180, 0, 40)
savePosBtn.Position = UDim2.new(0, 10, 0, 55)
savePosBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
savePosBtn.Text = "📍 Save Position"
savePosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
savePosBtn.TextScaled = true

-- Loading screen
local loading = Instance.new("ScreenGui", game.CoreGui)
loading.Name = "SpirLoading"
local bg = Instance.new("Frame", loading)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local label = Instance.new("TextLabel", bg)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "Anthony el GOAT"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.Arcade
loading.Enabled = false

-- Vars
local savedPos = nil
local spoofing = false

-- Funciones
local function spoofPosition(enable)
    if not Character or not HumanoidRootPart then return end
    spoofing = enable
    if enable then
        -- Camuflaje
        local clone = HumanoidRootPart:Clone()
        clone.Name = "SpoofedHRP"
        clone.Anchored = true
        clone.CFrame = HumanoidRootPart.CFrame
        clone.Parent = Character
        HumanoidRootPart.Transparency = 1
    else
        local spoofed = Character:FindFirstChild("SpoofedHRP")
        if spoofed then spoofed:Destroy() end
        HumanoidRootPart.Transparency = 0
    end
end

local function activateNoclip(state)
    if not Character then return end
    for _, v in pairs(Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

-- TP Función
local function teleportTo(pos)
    loading.Enabled = true
    spoofPosition(true)
    activateNoclip(true)

    -- Tween suave
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()

    task.wait(1)
    spoofPosition(false)
    activateNoclip(false)
    loading.Enabled = false
end

-- Botones
savePosBtn.MouseButton1Click:Connect(function()
    if HumanoidRootPart then
        savedPos = HumanoidRootPart.Position
    end
end)

speedGoatBtn.MouseButton1Click:Connect(function()
    if savedPos then
        teleportTo(savedPos + Vector3.new(0, 5, 0))
    end
end)
