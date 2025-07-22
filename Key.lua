local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to create key input GUI
local function requestKey()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeyGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.Active = true
    frame.Draggable = true

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0, 280, 0, 50)
    textbox.Position = UDim2.new(0, 10, 0, 30)
    textbox.PlaceholderText = "Enter Key"
    textbox.ClearTextOnFocus = false
    textbox.Text = ""
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 24
    textbox.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 90)
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    button.Text = "Submit"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 24
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = frame

    local key = "key"

    local function destroyGui()
        screenGui:Destroy()
    end

    local function onSubmit()
        if textbox.Text == key then
            destroyGui()
            startSpeedGui()
        else
            textbox.Text = ""
            textbox.PlaceholderText = "Wrong key, try again"
        end
    end

    button.MouseButton1Click:Connect(onSubmit)
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            onSubmit()
        end
    end)
end

-- Function to create speed GUI
function startSpeedGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpeedGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 120, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.Active = true
    frame.Draggable = true

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    button.Text = "Speed: OFF"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Parent = frame

    local speedEnabled = false
    local humanoid = nil

    local function updateSpeed()
        if humanoid then
            humanoid.WalkSpeed = speedEnabled and 70 or 16
        end
    end

    -- Wait for character and humanoid
    local function setup()
        local character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        updateSpeed()
    end

    player.CharacterAdded:Connect(function()
        setup()
    end)

    setup()

    button.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            button.Text = "Speed: ON"
            button.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        else
            button.Text = "Speed: OFF"
            button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        end
        updateSpeed()
    end)
end

-- Start by requesting key
requestKey()
