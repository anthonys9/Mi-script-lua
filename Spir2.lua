-- Spir Ultimate Bypass mejorado con draggable GUI y fly sigiloso

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Variables de estado
local flying = false
local flySpeed = 70
local noclip = false
local infiniteJump = false
local airWalk = false
local brainrotHeld = false
local roofTPEnabled = false
local savedRoofPosition = nil

local character, hrp, humanoid

local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end
updateCharacter()

-- GUI draggable
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Spir"
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Parent = frame
    return btn
end

local btnFly = createButton("Fly: OFF", 10)
local btnSpeedUp = createButton("Speed +", 50)
local btnSpeedDown = createButton("Speed -", 90)
local btnNoclip = createButton("Noclip: OFF", 130)
local btnInfiniteJump = createButton("Infinite Jump: OFF", 170)
local btnAirWalk = createButton("Air Walk: OFF", 210)
local btnSavePosition = createButton("Save Roof Position", 250)
local btnRoofTP = createButton("Roof TP: OFF", 290)

btnSpeedUp.Visible = false
btnSpeedDown.Visible = false

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
local flyCF
local velocity

local function lerp(a,b,t)
    return a + (b - a) * t
end

local flyDirection = Vector3.new(0,0,0)

local function enableFly()
    flyCF = hrp.CFrame
    flying = true
end

local function disableFly()
    flying = false
end

-- Infinite jump
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
    if flying then
        disableFly()
        btnFly.Text = "Fly: OFF"
        btnSpeedUp.Visible = false
        btnSpeedDown.Visible = false
    else
        enableFly()
        btnFly.Text = "Fly: ON"
        btnSpeedUp.Visible = true
        btnSpeedDown.Visible = true
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

-- Fly movement update (lerp and smooth)
RunService.Heartbeat:Connect(function()
    updateCharacter()
    checkBrainrotHeld()

    if flying then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
            flyCF = flyCF:Lerp(hrp.CFrame + moveDir, 0.2)
            hrp.CFrame = flyCF
        end
    end

    updateAirWalk()
    roofTP()

    if noclip then setNoclip(true) end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

player.CharacterAdded:Connect(function()
    wait(1)
    updateCharacter()
    if flying then
        flyCF = hrp.CFrame
    end
    if noclip then setNoclip(true) end
end)
