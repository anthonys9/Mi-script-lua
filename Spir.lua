-- Spir Ultimate Bypass for Steal a Brainrot
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer

-- Variables
local flying = false
local flySpeed = 70
local noclip = false
local infiniteJump = false
local airWalk = false
local brainrotHeld = false
local roofTPEnabled = false
local savedRoofPosition = nil

-- Create GUI in CoreGui for bypass
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Spir"
screenGui.Parent = CoreGui

local function createButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Parent = screenGui
    return btn
end

local btnFly = createButton("Fly: OFF", 10)
local btnSpeedUp = createButton("Speed +", 45)
local btnSpeedDown = createButton("Speed -", 80)
local btnNoclip = createButton("Noclip: OFF", 115)
local btnInfiniteJump = createButton("Infinite Jump: OFF", 150)
local btnAirWalk = createButton("Air Walk: OFF", 185)
local btnSavePosition = createButton("Save Roof Position", 220)
local btnRoofTP = createButton("Roof TP: OFF", 255)

btnSpeedUp.Visible = false
btnSpeedDown.Visible = false

-- Player character references
local character
local hrp
local humanoid

local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end
updateCharacter()

-- Noclip function
local function setNoclip(state)
    noclip = state
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = not noclip
        end
    end
end

-- Fly variables
local velocity
local bodyGyro

-- Enable fly
local function enableFly()
    if not hrp then return end
    velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    velocity.Velocity = Vector3.new(0,0,0)
    velocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
end

-- Disable fly
local function disableFly()
    if velocity then
        velocity:Destroy()
        velocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
end

-- Infinite jump variables
local function onJumpRequest()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Air Walk platform
local airPlatform = nil
local function updateAirWalk()
    if airWalk and hrp then
        local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
        local part, pos = workspace:FindPartOnRayWithIgnoreList(ray, {character})
        if not part then
            if not airPlatform then
                airPlatform = Instance.new("Part")
                airPlatform.Size = Vector3.new(6,1,6)
                airPlatform.Transparency = 1
                airPlatform.Anchored = true
                airPlatform.CanCollide = true
                airPlatform.Name = "AirWalkPlatform"
                airPlatform.Parent = workspace
            end
            airPlatform.CFrame = CFrame.new(hrp.Position - Vector3.new(0,3,0))
        else
            if airPlatform then
                airPlatform:Destroy()
                airPlatform = nil
            end
        end
    else
        if airPlatform then
            airPlatform:Destroy()
            airPlatform = nil
        end
    end
end

-- Brainrot detection
local function checkBrainrotHeld()
    brainrotHeld = false
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name == "Brainrot" then
        brainrotHeld = true
    end
end

-- Roof TP
local function roofTP()
    if savedRoofPosition and brainrotHeld and roofTPEnabled then
        hrp.CFrame = CFrame.new(savedRoofPosition)
    end
end

-- Button events
btnFly.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        btnFly.Text = "Fly: ON"
        btnSpeedUp.Visible = true
        btnSpeedDown.Visible = true
        enableFly()
    else
        btnFly.Text = "Fly: OFF"
        btnSpeedUp.Visible = false
        btnSpeedDown.Visible = false
        disableFly()
    end
end)

btnSpeedUp.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 10
end)

btnSpeedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
end)

btnNoclip.MouseButton1Click:Connect(function()
    noclip = not noclip
    setNoclip(noclip)
    btnNoclip.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

btnInfiniteJump.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    btnInfiniteJump.Text = infiniteJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
end)

btnAirWalk.MouseButton1Click:Connect(function()
    airWalk = not airWalk
    btnAirWalk.Text = airWalk and "Air Walk: ON" or "Air Walk: OFF"
end)

btnSavePosition.MouseButton1Click:Connect(function()
    if hrp then
        savedRoofPosition = hrp.Position + Vector3.new(0, 50, 0)
        btnSavePosition.Text = "Position Saved!"
        wait(2)
        btnSavePosition.Text = "Save Roof Position"
    end
end)

btnRoofTP.MouseButton1Click:Connect(function()
    roofTPEnabled = not roofTPEnabled
    btnRoofTP.Text = roofTPEnabled and "Roof TP: ON" or "Roof TP: OFF"
end)

-- Update fly movement
local inputVector = Vector3.new()
local function updateFlyMovement()
    local cam = workspace.CurrentCamera
    local direction = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0,1,0) end
    return direction.Unit
end

RunService.Heartbeat:Connect(function()
    updateCharacter()
    checkBrainrotHeld()

    if flying and velocity and bodyGyro then
        local dir = updateFlyMovement()
        if dir.Magnitude > 0 then
            velocity.Velocity = dir * flySpeed
            bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + dir)
        else
            velocity.Velocity = Vector3.new(0,0,0)
        end
    end

    updateAirWalk()
    roofTP()
    if noclip then setNoclip(true) end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Auto run after death
player.CharacterAdded:Connect(function()
    wait(1)
    updateCharacter()
    if flying then enableFly() end
    if noclip then setNoclip(true) end
end)
