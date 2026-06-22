-- Car Flip Game GUI
-- Place in StarterPlayer > StarterCharacterScripts or StarterPlayer > StarterPlayerScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")

-- Wait for remote events
local BuyCarEvent = gameEvents:WaitForChild("BuyCar")
local SellCarEvent = gameEvents:WaitForChild("SellCar")
local RepairCarEvent = gameEvents:WaitForChild("RepairCar")
local GetPlayerDataEvent = gameEvents:WaitForChild("GetPlayerData")
local GetNPCsEvent = gameEvents:WaitForChild("GetNPCs")
local SellToNPCEvent = gameEvents:WaitForChild("SellToNPC")

local playerData = nil
local selectedCarIndex = 1

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarFlipGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 300, 0, 50)
titleLabel.Position = UDim2.new(0.5, -150, 0, 10)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
titleLabel.TextSize = 32
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Car Flip Game"
titleLabel.Parent = screenGui

-- Money Display
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0, 300, 0, 30)
moneyLabel.Position = UDim2.new(0.5, -150, 0, 70)
moneyLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
moneyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
moneyLabel.TextSize = 18
moneyLabel.Font = Enum.Font.Gotham
moneyLabel.Text = "Money: $0"
moneyLabel.Parent = screenGui

-- Reputation Display
local repLabel = Instance.new("TextLabel")
repLabel.Name = "RepLabel"
repLabel.Size = UDim2.new(0, 300, 0, 30)
repLabel.Position = UDim2.new(0.5, -150, 0, 105)
repLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
repLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
repLabel.TextSize = 18
repLabel.Font = Enum.Font.Gotham
repLabel.Text = "Reputation: 0"
repLabel.Parent = screenGui

-- Inventory Label
local invLabel = Instance.new("TextLabel")
invLabel.Name = "InvLabel"
invLabel.Size = UDim2.new(0, 400, 0, 30)
invLabel.Position = UDim2.new(0, 10, 0, 150)
invLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
invLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
invLabel.TextSize = 16
invLabel.Font = Enum.Font.GothamBold
invLabel.Text = "Your Cars (Click to select)"
invLabel.Parent = screenGui

-- Inventory List Frame
local invFrame = Instance.new("Frame")
invFrame.Name = "InventoryFrame"
invFrame.Size = UDim2.new(0, 400, 0, 200)
invFrame.Position = UDim2.new(0, 10, 0, 185)
invFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
invFrame.BorderSizePixel = 0
invFrame.Parent = screenGui

local invList = Instance.new("UIListLayout")
invList.Parent = invFrame
invList.Padding = UDim.new(0, 5)

-- Car Details Label
local detailsLabel = Instance.new("TextLabel")
detailsLabel.Name = "DetailsLabel"
detailsLabel.Size = UDim2.new(0, 400, 0, 150)
detailsLabel.Position = UDim2.new(0, 10, 0, 395)
detailsLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
detailsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
detailsLabel.TextSize = 12
detailsLabel.Font = Enum.Font.Gotham
detailsLabel.TextWrapped = true
detailsLabel.TextXAlignment = Enum.TextXAlignment.Left
detailsLabel.Text = "Select a car to see details"
detailsLabel.Parent = screenGui

-- Buttons Frame
local btnFrame = Instance.new("Frame")
btnFrame.Name = "ButtonsFrame"
btnFrame.Size = UDim2.new(0, 400, 0, 300)
btnFrame.Position = UDim2.new(0, 10, 0, 555)
btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btnFrame.BorderSizePixel = 0
btnFrame.Parent = screenGui

local btnList = Instance.new("UIListLayout")
btnList.Parent = btnFrame
btnList.Padding = UDim.new(0, 10)

-- Button template
local function createButton(name, text, position)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 190, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.Parent = btnFrame
	return btn
end

-- Create buttons
local buyBtn = createButton("BuyBtn", "Buy Car", UDim2.new(0, 0, 0, 0))
local sellBtn = createButton("SellBtn", "Sell Car", UDim2.new(0, 0, 0, 0))
local repairBtn = createButton("RepairBtn", "Repair Selected", UDim2.new(0, 0, 0, 0))
local refreshBtn = createButton("RefreshBtn", "Refresh Data", UDim2.new(0, 0, 0, 0))

-- Update player display
local function updatePlayerDisplay()
	GetPlayerDataEvent:FireServer()
end

-- Refresh event
GetPlayerDataEvent.OnClientEvent:Connect(function(data)
	playerData = data
	moneyLabel.Text = "Money: $" .. data.Money
	repLabel.Text = "Reputation: " .. math.floor(data.Reputation)
	
	-- Clear inventory list
	for _, child in pairs(invFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	-- Add cars to inventory
	for i, car in ipairs(data.Inventory) do
		local carBtn = Instance.new("TextButton")
		carBtn.Size = UDim2.new(0, -10, 0, 35)
		carBtn.BackgroundColor3 = (i == selectedCarIndex) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
		carBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		carBtn.TextSize = 12
		carBtn.Font = Enum.Font.Gotham
		carBtn.Text = car.Class .. " - Cond: " .. math.floor((car.Engine + car.Transmission + car.Suspension + car.Body + car.Paint) / 5) .. "%"
		carBtn.Parent = invFrame
		
		carBtn.MouseButton1Click:Connect(function()
			selectedCarIndex = i
			updatePlayerDisplay()
			displayCarDetails(i)
		end)
	end
end)

-- Display car details
function displayCarDetails(index)
	if not playerData or not playerData.Inventory[index] then
		detailsLabel.Text = "No car selected"
		return
	end
	
	local car = playerData.Inventory[index]
	local condition = math.floor((car.Engine + car.Transmission + car.Suspension + car.Body + car.Paint) / 5)
	
	detailsLabel.Text = string.format(
		"Class: %s\nCondition: %d%%\nEngine: %d | Transmission: %d\nSuspension: %d | Body: %d | Paint: %d\nPurchase Price: $%d",
		car.Class, condition, car.Engine, car.Transmission, car.Suspension, car.Body, car.Paint, car.PurchasePrice
	)
end

-- Button handlers
buyBtn.MouseButton1Click:Connect(function()
	local carClass = "Economy" -- Default, can be customized
	BuyCarEvent:FireServer(carClass)
	wait(0.5)
	updatePlayerDisplay()
end)

sellBtn.MouseButton1Click:Connect(function()
	if selectedCarIndex and playerData and playerData.Inventory[selectedCarIndex] then
		SellCarEvent:FireServer(selectedCarIndex)
		wait(0.5)
		updatePlayerDisplay()
	end
end)

repairBtn.MouseButton1Click:Connect(function()
	if selectedCarIndex and playerData and playerData.Inventory[selectedCarIndex] then
		-- Repair Engine as example
		RepairCarEvent:FireServer(selectedCarIndex, "Engine", 20)
		wait(0.5)
		updatePlayerDisplay()
	end
end)

refreshBtn.MouseButton1Click:Connect(function()
	updatePlayerDisplay()
end)

-- Listen for event responses
BuyCarEvent.OnClientEvent:Connect(function(success, message)
	print("Buy result: " .. message)
	updatePlayerDisplay()
end)

SellCarEvent.OnClientEvent:Connect(function(success, message)
	print("Sell result: " .. message)
	updatePlayerDisplay()
end)

RepairCarEvent.OnClientEvent:Connect(function(success, message)
	print("Repair result: " .. message)
	updatePlayerDisplay()
end)

-- Initial update
updatePlayerDisplay()

-- Auto-update every 5 seconds
spawn(function()
	while true do
		wait(5)
		updatePlayerDisplay()
	end
end)
