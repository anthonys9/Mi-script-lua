local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local screenGui
local frame
local button

local floating = false
local floatForce

local function createGUI(character)
    if screenGui then
        screenGui:Destroy()
        screenGui = nil
    end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 120, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.Active = true
    frame.Draggable = true

    button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    button.Text = "Float: OFF"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        floating = not floating
        if floating then
            button.Text = "Float: ON"
            button.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        else
            button.Text = "Float: OFF"
            button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            if floatForce then
                floatForce:Destroy()
                floatForce = nil
            end
        end
    end)
end

local function enableFloat(character)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not floatForce then
        floatForce = Instance.new("BodyPosition")
        floatForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        floatForce.P = 1000
        floatForce.D = 100
        floatForce.Parent = hrp
    end
end

local function disableFloat()
    if floatForce then
        floatForce:Destroy()
        floatForce = nil
    end
end

local function checkGround(character)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -5, 0) -- raycast 5 studs hacia abajo

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return result ~= nil
end

local function onHeartbeat(character)
    if floating and character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and floatForce then
            if not checkGround(character) then
                -- Mantener al jugador en el aire a 5 studs sobre su posición actual
                floatForce.Position = hrp.Position + Vector3.new(0, 5, 0)
            else
                -- Hay suelo, desactivar fuerza para que caiga normal
                disableFloat()
            end
        end
    end
end

local function setup(character)
    createGUI(character)
    floating = false
    disableFloat()

    RunService.Heartbeat:Connect(function()
        if floating then
            enableFloat(character)
            onHeartbeat(character)
        else
            disableFloat()
        end
    end)
end

local player = game:GetService("Players").LocalPlayer

if player.Character then
    setup(player.Character)
end

player.CharacterAdded:Connect(function(char)
    setup(char)
end)
