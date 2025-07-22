--// Spir GUI Fly + Noclip + Air Walk + Auto Respawn //--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI creation
local function createGUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "SpirGUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 150, 0, 200)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Active = true
    frame.Draggable = true

    local function createButton(name, text, posY)
        local btn = Instance.new("TextButton", frame)
        btn.Name = name
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.SourceSansBold
        btn.Text = text
        return btn
    end

    local flyBtn = createButton("FlyButton", "Fly: OFF", 0)
    local speedUpBtn = createButton("SpeedUp", "Speed +", 35)
    local speedDownBtn = createButton("SpeedDown", "Speed -", 70)
    local noclipBtn = createButton("NoclipButton", "Noclip: OFF", 110)

    speedUpBtn.Visible = false
    speedDownBtn.Visible = false

    return gui, flyBtn, speedUpBtn, speedDownBtn, noclipBtn
end

-- Main logic
local flying = false
local speed = 50
local noclip = false
local airWalk = true
local velocity = Vector3.zero
local floatPart

local function onCharacterLoad()
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if not player.PlayerGui:FindFirstChild("SpirGUI") then
        gui, flyBtn, speedUpBtn, speedDownBtn, noclipBtn = createGUI()
    end
end

local function startFlying()
    flying = true
    floatPart = Instance.new("BodyVelocity")
    floatPart.MaxForce = Vector3.new(1,1,1) * math.huge
    floatPart.Velocity = Vector3.new()
    floatPart.Parent = humanoidRootPart
end

local function stopFlying()
    flying = false
    if floatPart then
        floatPart:Destroy()
        floatPart = nil
    end
end

-- Input detection
local inputDirection = {
    forward = false,
    back = false,
    left = false,
    right = false,
    up = false,
    down = false
}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local code = input.KeyCode
    if code == Enum.KeyCode.W then inputDirection.forward = true end
    if code == Enum.KeyCode.S then inputDirection.back = true end
    if code == Enum.KeyCode.A then inputDirection.left = true end
    if code == Enum.KeyCode.D then inputDirection.right = true end
    if code == Enum.KeyCode.Space then inputDirection.up = true end
    if code == Enum.KeyCode.LeftControl then inputDirection.down = true end
end)

UserInputService.InputEnded:Connect(function(input)
    local code = input.KeyCode
    if code == Enum.KeyCode.W then inputDirection.forward = false end
    if code == Enum.KeyCode.S then inputDirection.back = false end
    if code == Enum.KeyCode.A then inputDirection.left = false end
    if code == Enum.KeyCode.D then inputDirection.right = false end
    if code == Enum.KeyCode.Space then inputDirection.up = false end
    if code == Enum.KeyCode.LeftControl then inputDirection.down = false end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if noclip and character then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Air Walk + Fly
RunService.Heartbeat:Connect(function()
    if not humanoidRootPart or not character then return end

    -- Air Walk
    if airWalk then
        local rayOrigin = humanoidRootPart.Position
        local rayDirection = Vector3.new(0, -5, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

        local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if not result then
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end

    -- Fly movement
    if flying and floatPart then
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero

        if inputDirection.forward then moveVec += cam.CFrame.LookVector end
        if inputDirection.back then moveVec -= cam.CFrame.LookVector end
        if inputDirection.left then moveVec -= cam.CFrame.RightVector end
        if inputDirection.right then moveVec += cam.CFrame.RightVector end
        if inputDirection.up then moveVec += cam.CFrame.UpVector end
        if inputDirection.down then moveVec -= cam.CFrame.UpVector end

        floatPart.Velocity = moveVec.Unit * speed
    end
end)

-- GUI Logic
local gui, flyBtn, speedUpBtn, speedDownBtn, noclipBtn = createGUI()

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "Fly: ON"
        speedUpBtn.Visible = true
        speedDownBtn.Visible = true
        startFlying()
    else
        flyBtn.Text = "Fly: OFF"
        speedUpBtn.Visible = false
        speedDownBtn.Visible = false
        stopFlying()
    end
end)

speedUpBtn.MouseButton1Click:Connect(function()
    speed = speed + 10
end)

speedDownBtn.MouseButton1Click:Connect(function()
    speed = math.max(10, speed - 10)
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- Respawn handler
player.CharacterAdded:Connect(onCharacterLoad)
