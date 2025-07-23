-- sperHub made by speedgoat 🐐🇻🇪
-- Key: godblessyall

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Anti-Kick/Anti-Ban básico
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local __namecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(self) == "Kick" or method == "Kick" then
            return
        end
        return __namecall(self, ...)
    end)
end)

-- Pantalla de carga con rayos
local screengui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screengui)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0.2, 0)
label.Position = UDim2.new(0, 0, 0.4, 0)
label.Text = "🔵 sperHub - Cargando..."
label.TextColor3 = Color3.fromRGB(0, 170, 255)
label.TextScaled = true
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBlack

-- Rayos decorativos
for i = 1, 20 do
    local bolt = Instance.new("Frame", frame)
    bolt.Size = UDim2.new(0, math.random(2,4), 0, math.random(40, 150))
    bolt.Position = UDim2.new(math.random(), 0, math.random(), 0)
    bolt.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    bolt.BackgroundTransparency = 0.2
    bolt.Rotation = math.random(-45, 45)
    game:GetService("Debris"):AddItem(bolt, 2)
end

wait(2)

label.Text = "🛡️ Introduce la key para acceder"
wait(1)

-- Sistema de Key
local key = "godblessyall"

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.4, 0, 0.08, 0)
input.Position = UDim2.new(0.3, 0, 0.55, 0)
input.PlaceholderText = "Enter Key"
input.TextScaled = true
input.Text = ""
input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.Font = Enum.Font.GothamSemibold

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.2, 0, 0.08, 0)
button.Position = UDim2.new(0.4, 0, 0.65, 0)
button.Text = "Unlock"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold

button.MouseButton1Click:Connect(function()
    if input.Text == key then
        label.Text = "🔓 Key Correcta, cargando sperHub..."
        input.Visible = false
        button.Visible = false
        wait(2)
        screengui:Destroy()

        -- ▼▼▼ AQUÍ VAN TODAS LAS FUNCIONES DEL HUB ▼▼▼
        -- Usa ModuleScripts o agrégalas aquí directo, por ejemplo:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/speedgoatscript/sperHub/main/sperHub_Main.lua"))()

        -- ▲▲▲ FIN ▼▼▼
    else
        label.Text = "❌ Key Incorrecta"
    end
end)
