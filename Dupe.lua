local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEAR PREVIOUS UI ENTIRELY TO PREVENT LAYERING OVERLAPS
local oldGui = playerGui:FindFirstChild("FailSafeModifierGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FailSafeModifierGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 99999 -- FORCES THIS UI ABOVE ABSOLUTELY EVERYTHING ELSE
screenGui.Parent = playerGui

-- =============================================================================
-- 2. CREATE PANEL (SIMPLIFIED STRUCTURE)
-- =============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.Position = UDim2.new(0.5, -160, 0.4, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Prevents clicks from going through the frame into the map
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Top Drag Handle Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 8)
barCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Tool Custom Modifier"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- =============================================================================
-- 3. NATIVE DRAGGING (USES ROBLOX ENGINE INSTEAD OF BUGGY SCRIPTS)
-- =============================================================================
local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = mainFrame

-- =============================================================================
-- 4. BUTTONS & STYLING
-- =============================================================================
-- Bright Red Close Button (Completely outside the Titlebar to prevent drag blocking)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"
closeButton.Size = UDim2.new(0, 26, 0, 26)
closeButton.Position = UDim2.new(1, -32, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.ZIndex = 100 -- Enforces click priority
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Instructions
local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(1, -24, 0, 80)
instructions.Position = UDim2.new(0, 12, 0, 50)
instructions.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
instructions.Text = "📝 HOW TO USE:\n1. Hold a tool in your hand.\n2. Click the green button below.\n3. The tool's 'Count' attribute will double.\n4. Press [Right Shift] or [M] to hide/show."
instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
instructions.Font = Enum.Font.SourceSans
instructions.TextSize = 14
instructions.TextXAlignment = Enum.TextXAlignment.Left
instructions.TextYAlignment = Enum.TextYAlignment.Top
instructions.TextWrapped = true
instructions.Parent = mainFrame

local instPadding = Instance.new("UIPadding")
instPadding.PaddingLeft = UDim.new(0, 8)
instPadding.PaddingTop = UDim.new(0, 8)
instPadding.Parent = instructions

-- Real-time Status Display
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 25)
statusLabel.Position = UDim2.new(0, 12, 0, 145)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle (Ready)"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 14
statusLabel.Parent = mainFrame

-- Huge Green Action Button
local actionButton = Instance.new("TextButton")
actionButton.Name = "ActionBtn"
actionButton.Size = UDim2.new(1, -24, 0, 45)
actionButton.Position = UDim2.new(0, 12, 1, -55)
actionButton.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
actionButton.Text = "DOUBLE 'COUNT' ATTRIBUTE"
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Font = Enum.Font.SourceSansBold
actionButton.TextSize = 16
actionButton.Parent = mainFrame

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionButton

-- Re-open Button (Hidden by default, spawns in bottom right corner if panel closes)
local openButton = Instance.new("TextButton")
openButton.Name = "OpenBtn"
openButton.Size = UDim2.new(0, 120, 0, 35)
openButton.Position = UDim2.new(1, -135, 1, -45)
openButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
openButton.Text = "Open Menu ⚙️"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 14
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

-- =============================================================================
-- 5. FUNCTIONAL HOOKS
-- =============================================================================
local function toggleUI()
	mainFrame.Visible = not mainFrame.Visible
	openButton.Visible = not mainFrame.Visible
end

closeButton.MouseButton1Click:Connect(toggleUI)
openButton.MouseButton1Click:Connect(toggleUI)

-- Dual-Key Toggle Engine (Works via M or RightShift keycaps)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.RightShift then
		toggleUI()
	end
end)

-- The Attribute Processing Loop
actionButton.MouseButton1Click:Connect(function()
	local character = player.Character
	if not character then
		statusLabel.Text = "❌ Error: Character missing!"
		return
	end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		statusLabel.Text = "❌ Error: No tool equipped in your hand!"
		return
	end
	
	local currentCount = tool:GetAttribute("Count")
	
	if type(currentCount) == "number" then
		local doubled = currentCount * 2
		tool:SetAttribute("Count", doubled)
		statusLabel.Text = "✅ Doubled count to: " .. tostring(doubled)
	else
		tool:SetAttribute("Count", 1)
		statusLabel.Text = "✨ Created missing attribute 'Count' at 1!"
	end
end)

print("⚡ Core fail-safe UI running.")
