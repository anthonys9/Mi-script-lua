-- sperHub by speedgoat | Key system + AntiKick + AntiBan + Full UI + Features

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Key = "godblessyall"
local HasKey = false

-- Create UI parent
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

-- Helper Functions
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

-- Loading Screen
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

-- Variables para toggles y funcionalidades
local espEnabled = false
local speedEnabled = false
local infiniteJumpEnabled = false
local spirOpEnabled = false
local brainrotESP = false
local baseTimersESP = false

local brainrotLabels = {}
local baseTimerLabels = {}

-- Función para mostrar pantalla de carga con texto dinámico
local function ShowLoading(text)
    loadingText.Text = text
    loadingScreen.Visible = true
end

local function HideLoading()
    loadingScreen.Visible = false
end

-- Funciones para Aura ESP
local function EnableAuraESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if not hrp:FindFirstChild("Aura") then
                local aura = Instance.new("SelectionBox")
                aura.Name = "Aura"
                aura.Adornee = hrp
                aura.Color3 = Color3.fromRGB(0, 170, 255)
                aura.LineThickness = 0.07
                aura.Parent = hrp
            end
        end
    end
end

local function DisableAuraESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local aura = hrp:FindFirstChild("Aura")
            if aura then aura:Destroy() end
        end
    end
end

-- Brainrot ESP
local function UpdateBrainrotESP()
    for _, br in pairs(workspace:GetChildren()) do
        if br.Name:lower():find("brainrot") and br:IsA("BasePart") then
            if not brainrotLabels[br] then
                local bill = Instance.new("BillboardGui")
                bill.Adornee = br
                bill.Size = UDim2.new(0, 100, 0, 30)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.AlwaysOnTop = true
                bill.Parent = br

                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(1, 1, 0)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBold
                label.TextScaled = true
                label.Text = br.Name
                label.Parent = bill

                brainrotLabels[br] = bill
            end
        end
    end
end

local function ClearBrainrotESP()
    for br, bill in pairs(brainrotLabels) do
        if bill and bill.Parent then
            bill:Destroy()
        end
        brainrotLabels[br] = nil
    end
end

-- Base Timers ESP (Ejemplo simple, debes ajustar la lógica según el juego)
local function CreateBaseTimersESP()
    -- Limpia primero
    for _, label in pairs(baseTimerLabels) do
        if label and label.Parent then
            label:Destroy()
        end
    end
    baseTimerLabels = {}

    -- Aquí deberías conseguir las bases y su tiempo
    local bases = workspace:FindFirstChild("Bases")
    if bases then
        for _, base in pairs(bases:GetChildren()) do
            local label = Instance.new("BillboardGui")
            label.Adornee = base
            label.Size = UDim2.new(0, 100, 0, 30)
            label.StudsOffset = Vector3.new(0, 5, 0)
            label.AlwaysOnTop = true
            label.Parent = base

            local txtLabel = Instance.new("TextLabel")
            txtLabel.BackgroundTransparency = 1
            txtLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            txtLabel.Font = Enum.Font.GothamBold
            txtLabel.TextScaled = true
            txtLabel.Text = "Tiempo: 0s"
            txtLabel.Parent = label

            baseTimerLabels[base] = txtLabel
        end
    end
end

local function RemoveBaseTimersESP()
    for _, label in pairs(baseTimerLabels) do
        if label and label.Parent then
            label.Parent:Destroy()
        end
    end
    baseTimerLabels = {}
end

-- Actualizar base timers (solo ejemplo, ajustar con lógica real)
RunService.Heartbeat:Connect(function()
    if baseTimersESP then
        for base, label in pairs(baseTimerLabels) do
            if base and base.Parent and label then
                -- Aquí pones la lógica para actualizar el tiempo real que falta
                label.Text = "Tiempo: " .. math.random(1,60) .. "s"
            end
        end
    end
end)

-- Función para teletransporte "spirOp" simulado
local function spirOpTeleport()
    if not spirOpEnabled or not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    ShowLoading("Wait...")

    -- Simular viaje con tween para que no sea instantáneo
    local basePos = Vector3.new(0, 200, 0) -- Ajusta la posición del techo según tu base
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(basePos + Vector3.new(0,1,0))})
    tween:Play()
    tween.Completed:Wait()

    HideLoading()
end

-- Main GUI
function MainGui()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = UI
    mainFrame.Active = true
    mainFrame.Draggable = true

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 80, 0, 80)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031079414"
    icon.Parent = mainFrame
    icon.ClipsDescendants = true
    icon.Name = "Icon"

    local title = CreateTextLabel(mainFrame, "sperHub", UDim2.new(0.7, 0, 0, 80), UDim2.new(0, 100, 0, 10), Color3.fromRGB(0, 255, 255))
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
    scrollFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    scrollFrame.ScrollBarThickness = 7
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Parent = mainFrame

    local options = {}

    options.Aimbot = CreateToggle(scrollFrame, "Aimbot (Taser/Laser)", UDim2.new(0, 10, 0, 10))
    options.Aimbot.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            options.Aimbot.Text = "On"
            options.Aimbot.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            options.Aimbot.Text = "Off"
            options.Aimbot.BackgroundColor3 = Color3.fromRGB(150,0,0)
        end
    end)

    options.Speed = CreateToggle(scrollFrame, "Speed 55 no bugs", UDim2.new(0, 10, 0, 60))
    options.Speed.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            options.Speed.Text = "On"
            options.Speed.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            options.Speed.Text = "Off"
            options.Speed.BackgroundColor3 = Color3.fromRGB(150,0,0)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)

    options.InfiniteJump = CreateToggle(scrollFrame, "Infinite Jump", UDim2.new(0, 10, 0, 110))
    options.InfiniteJump.MouseButton1Click:Connect(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            options.InfiniteJump.Text = "On"
            options.InfiniteJump.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            options.InfiniteJump.Text = "Off"
            options.InfiniteJump.BackgroundColor3 = Color3.fromRGB(150,0,0)
        end
    end)

    options.ESP = CreateToggle(scrollFrame, "ESP Names + Aura Azul", UDim2.new(0, 10, 0, 160))
    options.ESP.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            options.ESP.Text = "On"
            options.ESP.BackgroundColor3 = Color3.fromRGB(0,150,0)
            EnableAuraESP()
        else
            options.ESP.Text = "Off"
            options.ESP.BackgroundColor3 = Color3.fromRGB(150,0,0)
            DisableAuraESP()
        end
    end)

    options.spirOp = CreateToggle(scrollFrame, "spirOp TP (Salto + TP)", UDim2.new(0, 10, 0, 210))
    options.spirOp.MouseButton1Click:Connect(function()
        spirOpEnabled = not spirOpEnabled
        if spirOpEnabled then
            options.spirOp.Text = "On"
            options.spirOp.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            options.spirOp.Text = "Off"
            options.spirOp.BackgroundColor3 = Color3.fromRGB(150,0,0)
        end
    end)

    options.BrainrotESP = CreateToggle(scrollFrame, "Brainrot Names ESP", UDim2.new(0, 10, 0, 260))
    options.BrainrotESP.MouseButton1Click:Connect(function()
        brainrotESP = not brainrotESP
        if brainrotESP then
            options.BrainrotESP.Text = "On"
            options.BrainrotESP.BackgroundColor3 = Color3.fromRGB(0,150,0)
        else
            options.BrainrotESP.Text = "Off"
            options.BrainrotESP.BackgroundColor3 = Color3.fromRGB(150,0,0)
            ClearBrainrotESP()
        end
    end)

    options.BaseTimersESP = CreateToggle(scrollFrame, "Base Timers ESP", UDim2.new(0, 10, 0, 310))
    options.BaseTimersESP.MouseButton1Click:Connect(function()
        baseTimersESP = not baseTimersESP
        if baseTimersESP then
            options.BaseTimersESP.Text = "On"
            options.BaseTimersESP.BackgroundColor3 = Color3.fromRGB(0,150,0)
            CreateBaseTimersESP()
        else
            options.BaseTimersESP.Text = "Off"
            options.BaseTimersESP.BackgroundColor3 = Color3.fromRGB(150,0,0)
            RemoveBaseTimersESP()
        end
    end)

    local rejoinBtn = CreateButton(mainFrame, "Rejoin Server", UDim2.new(0.9, 0, 0.07, 0), UDim2.new(0
