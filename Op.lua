-- sperHub minimal by speedgoat | Key system + AntiKick + Aimbot + spirOp TP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Key = "godblessyall"
local HasKey = false

local UI = Instance.new("ScreenGui")
UI.Name = "sperHubUI"
UI.ResetOnSpawn = false
UI.Parent = game.CoreGui

-- Anti Kick / Anti Ban (Basic)
local mt = getrawmetatable(game)
local old
old = hookmetamethod(mt, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "Destroy" then
        return wait(9e9)
    end
    return old(self, ...)
end))

-- Helper functions
local function CreateTextLabel(parent, text, size, pos, color)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = size
    lbl.Position = pos
    lbl.TextColor3 = color or Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.Parent = parent
    return lbl
end

local function CreateButton(parent, text, size, pos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.AutoButtonColor = true
    btn.Parent = parent
    return btn
end

local function CreateToggle(parent, text, pos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = pos
    frame.BackgroundColor3 = Color3.fromRGB(25,25,75)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Text = "Off"
    toggle.Size = UDim2.new(0.25, -5, 0.9, 0)
    toggle.Position = UDim2.new(0.75, 0, 0.05, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextScaled = true
    toggle.Parent = frame

    return toggle
end

-- Key GUI
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 350, 0, 150)
keyFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,50)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = UI

local keyLabel = CreateTextLabel(keyFrame, "Enter Key to Access sperHub", UDim2.new(1,0,0.4,0), UDim2.new(0,0,0,0), Color3.fromRGB(0, 255, 255))

local keyBox = Instance.new("TextBox")
keyBox.PlaceholderText = "Type your key here..."
keyBox.Size = UDim2.new(0.8, 0, 0.3, 0)
keyBox.Position = UDim2.new(0.1, 0, 0.45, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,60)
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.GothamBold
keyBox.TextScaled = true
keyBox.Parent = keyFrame

local keyButton = CreateButton(keyFrame, "Submit", UDim2.new(0.6, 0, 0.3, 0), UDim2.new(0.2, 0, 0.75, 0))

local function RemoveKeyGui()
    keyFrame:Destroy()
end

local loadingScreen = Instance.new("Frame")
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingScreen.Visible = false
loadingScreen.Parent = UI

local loadingText = Instance.new("TextLabel")
loadingText.Text = "Made by speedgoat"
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 50
loadingText.TextColor3 = Color3.fromRGB(0, 255, 255)
loadingText.Size = UDim2.new(1, 0, 0.2, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.BackgroundTransparency = 1
loadingText.Parent = loadingScreen

-- Variables for toggles
local aimbotEnabled = false
local spirOpEnabled = false
local isTeleporting = false

-- Main GUI
function MainGui()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = UI
    mainFrame.Active = true
    mainFrame.Draggable = true

    local title = CreateTextLabel(mainFrame, "sperHub", UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 10), Color3.fromRGB(0, 255, 255))
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true

    local aimbotToggle = CreateToggle(mainFrame, "Aimbot (Taser/Laser)", UDim2.new(0, 10, 0, 70))
    aimbotToggle.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            aimbotToggle.Text = "On"
            aimbotToggle.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            aimbotToggle.Text = "Off"
            aimbotToggle.BackgroundColor3 = Color3.fromRGB(150,0,0)
        end
    end)

    local spirOpToggle = CreateToggle(mainFrame, "spirOp TP (Salto + TP)", UDim2.new(0, 10, 0, 120))
    spirOpToggle.MouseButton1Click:Connect(function()
        spirOpEnabled = not spirOpEnabled
        if spirOpEnabled then
            spirOpToggle.Text = "On"
            spirOpToggle.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            spirOpToggle.Text = "Off"
            spirOpToggle.BackgroundColor3 = Color3.fromRGB(150,0,0)
        end
    end)

    -- spirOp Logic
    UserInputService.JumpRequest:Connect(function()
        if spirOpEnabled and not isTeleporting and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            isTeleporting = true
            loadingScreen.Visible = true
            loadingText.Text = "Wait..."

            local hrp = LocalPlayer.Character.HumanoidRootPart
            local basePos = hrp.Position
            local targetHeight = basePos.Y + 30 -- subir 30 studs (simular viaje)
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear)
            local tweenUp = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(basePos.X, targetHeight, basePos.Z)})
            tweenUp:Play()
            tweenUp.Completed:Wait()

            wait(1) -- Simulación de viaje

            local targetCFrame = CFrame.new(basePos.X, targetHeight + 10, basePos.Z) -- Queda a 10 studs sobre el techo
            hrp.CFrame = targetCFrame

            loadingText.Text = "Done!"
            wait(1)
            loadingScreen.Visible = false
            isTeleporting = false
        end
    end)

    -- Aquí podrías agregar la lógica del aimbot, pero la dejo en blanco para que la completes
end

keyButton.MouseButton1Click:Connect(function()
    if keyBox.Text == Key then
        HasKey = true
        RemoveKeyGui()
        wait(0.2)
        MainGui()
    else
        keyBox.Text = ""
        keyBox.PlaceholderText = "Incorrect key! Try again."
    end
end)
