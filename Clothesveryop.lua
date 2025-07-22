-- GUI para copiar ropa de otro jugador - versión mejorada
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ClothesGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.5, -125, 0.4, -60)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local Icon = Instance.new("TextLabel", Frame)
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(0, 5, 0, 5)
Icon.Text = "👕"
Icon.BackgroundTransparency = 1
Icon.TextScaled = true
Icon.TextColor3 = Color3.fromRGB(255, 255, 255)

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(0, 200, 0, 30)
TextBox.Position = UDim2.new(0, 5, 0, 50)
TextBox.PlaceholderText = "Enter player name..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0, 100, 0, 30)
Button.Position = UDim2.new(0, 75, 0, 85)
Button.Text = "Copiar Ropa"
Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Button.TextColor3 = Color3.new(1,1,1)

-- Función para copiar ropa
Button.MouseButton1Click:Connect(function()
	local targetName = TextBox.Text
	local target = Players:FindFirstChild(targetName)
	if target and target:FindFirstChild("Character") then
		local char = target.Character
		for _, obj in ipairs(char:GetChildren()) do
			if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
				obj:Clone().Parent = LocalPlayer.Character
			end
		end
	end
end)
