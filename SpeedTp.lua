-- GUI Anti-TP Script SpeedgoatTPv2 🐐
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variables
local savedPosition = nil
local teleporting = false

-- Pantalla de carga
local loadingScreen = Instance.new("ScreenGui", game.CoreGui)
loadingScreen.IgnoreGuiInset = true
loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
local blackBg = Instance.new("Frame", loadingScreen)
blackBg.BackgroundColor3 = Color3.new(0, 0, 0)
blackBg.Size = UDim2.new(1, 0, 1, 0)
local label = Instance.new("TextLabel", blackBg)
label.Text = "Anthony el GOAT"
label.Size = UDim2.new(1, 0, 1, 0)
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBlack
label.TextScaled = true

-- Cerrar pantalla de carga luego de 2 segundos
task.delay(2, function()
    loadingScreen:Destroy()
end)

-- Crear GUI flotante
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.6, 0)
frame.Active = true
frame.Draggable = true

-- Íconos decorativos
local icon = Instance.new("ImageLabel", frame)
icon.Image = "rbxassetid://12397023436" -- Cabra
icon.Size = UDim2.new(0, 40, 0, 40)
icon.Position = UDim2.new(0, 5, 0, 5)
icon.BackgroundTransparency = 1

local icon2 = Instance.new("ImageLabel", frame)
icon2.Image = "rbxassetid://14662599444" -- Explosión
icon2.Size = UDim2.new(0, 40, 0, 40)
icon2.Position = UDim2.new(0, 50, 0, 5)
icon2.BackgroundTransparency = 1

-- Save Position Button
local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Save Position"
saveBtn.Size = UDim2.new(0, 180, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 50)
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextScaled = true

-- TP Button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "speedgoat"
tpBtn.Size = UDim2.new(0, 180, 0, 30)
tpBtn.Position = UDim2.new(0, 10, 0, 85)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextScaled = true

-- Función de Save Position
saveBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
    end
end)

-- Función de Teletransporte con Tween y spoof temporal
tpBtn.MouseButton1Click:Connect(function()
    if not savedPosition or teleporting then return end
    teleporting = true
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Noclip temporal
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Tween TP
    local root = char.HumanoidRootPart
    local goal = {}
    goal.CFrame = CFrame.new(savedPosition)
    TweenService:Create(root, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()

    wait(0.7)
    teleporting = false
end)
