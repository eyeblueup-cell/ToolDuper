local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEAN RE-INJECTION SYSTEM
local oldGui = playerGui:FindFirstChild("UnifiedModifierGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedModifierGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 99999
screenGui.Parent = playerGui

-- =============================================================================
-- 2. MAIN PANEL
-- =============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 480, 0, 420)
mainFrame.Position = UDim2.new(0.5, -240, 0.4, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 8)
barCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ Unified Modifier Suite"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Drag Detector
local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = mainFrame
dragDetector.DragStart:Connect(function() end)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 13
closeButton.ZIndex = 100
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Re-open Button
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
openButton.ZIndex = 100
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

-- =============================================================================
-- 3. TAB SYSTEM
-- =============================================================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 35)
tabContainer.Position = UDim2.new(0, 0, 0, 35)
tabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local function createTabButton(text, position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.5, -2, 1, 0)
	btn.Position = UDim2.new(position, 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = tabContainer
	return btn
end

local toolTab = createTabButton("🔧 Tools", 0)
local playerTab = createTabButton("👤 Player", 0.5)

-- Tab Content Frames
local toolContent = Instance.new("Frame")
toolContent.Size = UDim2.new(1, -24, 1, -100)
toolContent.Position = UDim2.new(0, 12, 0, 75)
toolContent.BackgroundTransparency = 1
toolContent.Parent = mainFrame

local playerContent = Instance.new("Frame")
playerContent.Size = UDim2.new(1, -24, 1, -100)
playerContent.Position = UDim2.new(0, 12, 0, 75)
playerContent.BackgroundTransparency = 1
playerContent.Visible = false
playerContent.Parent = mainFrame

-- =============================================================================
-- 4. TOOL TAB CONTENT
-- =============================================================================
-- Info Display
local toolInfo = Instance.new("TextLabel")
toolInfo.Size = UDim2.new(1, 0, 0, 30)
toolInfo.Position = UDim2.new(0, 0, 0, 0)
toolInfo.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
toolInfo.Text = "No tool equipped"
toolInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
toolInfo.Font = Enum.Font.SourceSans
toolInfo.TextSize = 13
toolInfo.Parent = toolContent

local toolInfoCorner = Instance.new("UICorner")
toolInfoCorner.CornerRadius = UDim.new(0, 4)
toolInfoCorner.Parent = toolInfo

-- Properties List
local toolPropsScroll = Instance.new("ScrollingFrame")
toolPropsScroll.Size = UDim2.new(1, 0, 1, -90)
toolPropsScroll.Position = UDim2.new(0, 0, 0, 35)
toolPropsScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
toolPropsScroll.BorderSizePixel = 0
toolPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
toolPropsScroll.ScrollBarThickness = 6
toolPropsScroll.Parent = toolContent

local toolPropsCorner = Instance.new("UICorner")
toolPropsCorner.CornerRadius = UDim.new(0, 4)
toolPropsCorner.Parent = toolPropsScroll

local toolPropsLayout = Instance.new("UIListLayout")
toolPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
toolPropsLayout.Padding = UDim.new(0, 2)
toolPropsLayout.Parent = toolPropsScroll

local toolPropsPadding = Instance.new("UIPadding")
toolPropsPadding.PaddingLeft = UDim.new(0, 5)
toolPropsPadding.PaddingTop = UDim.new(0, 5)
toolPropsPadding.PaddingRight = UDim.new(0, 5)
toolPropsPadding.Parent = toolPropsScroll

-- Tool Action Buttons
local toolActionFrame = Instance.new("Frame")
toolActionFrame.Size = UDim2.new(1, 0, 0, 45)
toolActionFrame.Position = UDim2.new(0, 0, 1, -45)
toolActionFrame.BackgroundTransparency = 1
toolActionFrame.Parent = toolContent

local doubleBtn = Instance.new("TextButton")
doubleBtn.Size = UDim2.new(0.48, 0, 1, 0)
doubleBtn.Position = UDim2.new(0, 0, 0, 0)
doubleBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
doubleBtn.Text = "Double Count"
doubleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
doubleBtn.Font = Enum.Font.SourceSansBold
doubleBtn.TextSize = 14
doubleBtn.Parent = toolActionFrame

local doubleCorner = Instance.new("UICorner")
doubleCorner.CornerRadius = UDim.new(0, 4)
doubleCorner.Parent = doubleBtn

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.48, 0, 1, 0)
scanBtn.Position = UDim2.new(0.52, 0, 0, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
scanBtn.Text = "Scan Tool"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 14
scanBtn.Parent = toolActionFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 4)
scanCorner.Parent = scanBtn

-- =============================================================================
-- 5. PLAYER TAB CONTENT
-- =============================================================================
-- Player Info
local playerInfo = Instance.new("TextLabel")
playerInfo.Size = UDim2.new(1, 0, 0, 30)
playerInfo.Position = UDim2.new(0, 0, 0, 0)
playerInfo.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
playerInfo.Text = "Player: " .. player.Name
playerInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
playerInfo.Font = Enum.Font.SourceSans
playerInfo.TextSize = 13
playerInfo.Parent = playerContent

local playerInfoCorner = Instance.new("UICorner")
playerInfoCorner.CornerRadius = UDim.new(0, 4)
playerInfoCorner.Parent = playerInfo

-- Player Properties
local playerPropsScroll = Instance.new("ScrollingFrame")
playerPropsScroll.Size = UDim2.new(1, 0, 1, -90)
playerPropsScroll.Position = UDim2.new(0, 0, 0, 35)
playerPropsScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
playerPropsScroll.BorderSizePixel = 0
playerPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerPropsScroll.ScrollBarThickness = 6
playerPropsScroll.Parent = playerContent

local playerPropsCorner = Instance.new("UICorner")
playerPropsCorner.CornerRadius = UDim.new(0, 4)
playerPropsCorner.Parent = playerPropsScroll

local playerPropsLayout = Instance.new("UIListLayout")
playerPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerPropsLayout.Padding = UDim.new(0, 2)
playerPropsLayout.Parent = playerPropsScroll

local playerPropsPadding = Instance.new("UIPadding")
playerPropsPadding.PaddingLeft = UDim.new(0, 5)
playerPropsPadding.PaddingTop = UDim.new(0, 5)
playerPropsPadding.PaddingRight = UDim.new(0, 5)
playerPropsPadding.Parent = playerPropsScroll

-- Player Action Buttons
local playerActionFrame = Instance.new("Frame")
playerActionFrame.Size = UDim2.new(1, 0, 0, 45)
playerActionFrame.Position = UDim2.new(0, 0, 1, -45)
playerActionFrame.BackgroundTransparency = 1
playerActionFrame.Parent = playerContent

local scanPlayerBtn = Instance.new("TextButton")
scanPlayerBtn.Size = UDim2.new(0.48, 0, 1, 0)
scanPlayerBtn.Position = UDim2.new(0, 0, 0, 0)
scanPlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
scanPlayerBtn.Text = "Scan Player"
scanPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanPlayerBtn.Font = Enum.Font.SourceSansBold
scanPlayerBtn.TextSize = 14
scanPlayerBtn.Parent = playerActionFrame

local scanPlayerCorner = Instance.new("UICorner")
scanPlayerCorner.CornerRadius = UDim.new(0, 4)
scanPlayerCorner.Parent = scanPlayerBtn

local editPlayerBtn = Instance.new("TextButton")
editPlayerBtn.Size = UDim2.new(0.48, 0, 1, 0)
editPlayerBtn.Position = UDim2.new(0.52, 0, 0, 0)
editPlayerBtn.BackgroundColor3 = Color3.fromRGB(180, 130, 40)
editPlayerBtn.Text = "Edit Attributes"
editPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
editPlayerBtn.Font = Enum.Font.SourceSansBold
editPlayerBtn.TextSize = 14
editPlayerBtn.Parent = playerActionFrame

local editPlayerCorner = Instance.new("UICorner")
editPlayerCorner.CornerRadius = UDim.new(0, 4)
editPlayerCorner.Parent = editPlayerBtn

-- =============================================================================
-- 6. UTILITY FUNCTIONS
-- =============================================================================
local function clearScroll(frame)
	for _, child in ipairs(frame:GetChildren()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			child:Destroy()
		end
	end
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function addPropertyLine(parent, name, value, editable)
	local line = Instance.new("TextLabel")
	line.Size = UDim2.new(1, 0, 0, 22)
	line.BackgroundTransparency = 1
	line.Text = string.format("%s: %s", name, tostring(value))
	line.TextColor3 = Color3.fromRGB(220, 220, 220)
	line.Font = Enum.Font.Code
	line.TextSize = 12
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.TextWrapped = true
	line.Parent = parent
	return line
end

local function addClickableProperty(parent, name, currentValue, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 30)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name .. ":"
	label.TextColor3 = Color3.fromRGB(180, 180, 255)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	local valueBtn = Instance.new("TextButton")
	valueBtn.Size = UDim2.new(0.6, -10, 1, -4)
	valueBtn.Position = UDim2.new(0.4, 5, 0, 2)
	valueBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	valueBtn.Text = tostring(currentValue)
	valueBtn.TextColor3 = Color3.fromRGB(255, 255, 200)
	valueBtn.Font = Enum.Font.Code
	valueBtn.TextSize = 12
	valueBtn.TextXAlignment = Enum.TextXAlignment.Left
	valueBtn.Parent = container
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 3)
	btnCorner.Parent = valueBtn
	
	valueBtn.MouseButton1Click:Connect(function()
		local success, newValue = pcall(callback)
		if success and newValue ~= nil then
			valueBtn.Text = tostring(newValue)
		end
	end)
	
	return container
end

local function scanPlayer()
	clearScroll(playerPropsScroll)
	
	local character = player.Character
	if not character then
		addPropertyLine(playerPropsScroll, "⚠️ Error", "Character not found!", false)
		return
	end
	
	-- Player core properties
	addPropertyLine(playerPropsScroll, "Player Name", player.Name, false)
	addPropertyLine(playerPropsScroll, "User ID", player.UserId, false)
	addPropertyLine(playerPropsScroll, "Display Name", player.DisplayName, false)
	
	-- Character properties
	addPropertyLine(playerPropsScroll, "Character", character.Name, false)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		addPropertyLine(playerPropsScroll, "Health", math.floor(humanoid.Health), false)
		addPropertyLine(playerPropsScroll, "Max Health", math.floor(humanoid.MaxHealth), false)
		addPropertyLine(playerPropsScroll, "Walk Speed", humanoid.WalkSpeed, false)
		addPropertyLine(playerPropsScroll, "Jump Power", humanoid.JumpPower, false)
	end
	
	-- Player Attributes
	local attributes = player:GetAttributes()
	if next(attributes) ~= nil then
		addPropertyLine(playerPropsScroll, "--- Player Attributes ---", "", false)
		for name, value in pairs(attributes) do
			addClickableProperty(playerPropsScroll, name, value, function()
				local newVal = tonumber(value) or value
				if type(newVal) == "number" then
					newVal = newVal * 2
				elseif type(newVal) == "string" then
					newVal = newVal .. "_modified"
				end
				player:SetAttribute(name, newVal)
				return newVal
			end)
		end
	end
	
	-- Character Attributes
	local charAttributes = character:GetAttributes()
	if next(charAttributes) ~= nil then
		addPropertyLine(playerPropsScroll, "--- Character Attributes ---", "", false)
		for name, value in pairs(charAttributes) do
			addClickableProperty(playerPropsScroll, name, value, function()
				local newVal = tonumber(value) or value
				if type(newVal) == "number" then
					newVal = newVal * 2
				elseif type(newVal) == "string" then
					newVal = newVal .. "_modified"
				end
				character:SetAttribute(name, newVal)
				return newVal
			end)
		end
	end
	
	playerPropsScroll.CanvasSize = UDim2.new(0, 0, 0, playerPropsLayout.AbsoluteContentSize.Y + 10)
end

local function scanTool()
	clearScroll(toolPropsScroll)
	
	local character = player.Character
	if not character then
		addPropertyLine(toolPropsScroll, "⚠️ Error", "Character not loaded!", false)
		toolInfo.Text = "❌ Character not found"
		return
	end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		addPropertyLine(toolPropsScroll, "⚠️ Error", "No tool equipped!", false)
		toolInfo.Text = "❌ No tool equipped"
		return
	end
	
	toolInfo.Text = "🔧 " .. tool.Name .. " (" .. tool.ClassName .. ")"
	
	-- Standard properties
	local props = {"Name", "ClassName", "ToolTip", "Enabled", "CanBeDropped", "RequiresHandle", "TextureId"}
	for _, prop in ipairs(props) do
		local success, val = pcall(function() return tool[prop] end)
		if success then
			addPropertyLine(toolPropsScroll, prop, tostring(val), false)
		end
	end
	
	-- Tool Attributes (clickable for editing)
	local attributes = tool:GetAttributes()
	if next(attributes) ~= nil then
		addPropertyLine(toolPropsScroll, "--- Attributes ---", "", false)
		for name, value in pairs(attributes) do
			addClickableProperty(toolPropsScroll, name, value, function()
				local newVal
				if type(value) == "number" then
					newVal = value * 2
				elseif type(value) == "string" then
					newVal = value .. "_modified"
				elseif type(value) == "boolean" then
					newVal = not value
				else
					newVal = value
				end
				tool:SetAttribute(name, newVal)
				return newVal
			end)
		end
	end
	
	-- Children objects
	local children = tool:GetChildren()
	if #children > 0 then
		addPropertyLine(toolPropsScroll, "--- Children ---", "", false)
		for _, child in ipairs(children) do
			addPropertyLine(toolPropsScroll, "📁 " .. child.Name, child.ClassName, false)
		end
	end
	
	toolPropsScroll.CanvasSize = UDim2.new(0, 0, 0, toolPropsLayout.AbsoluteContentSize.Y + 10)
end

-- =============================================================================
-- 7. TAB SWITCHING
-- =============================================================================
local function switchTab(tab)
	toolContent.Visible = (tab == "tool")
	playerContent.Visible = (tab == "player")
	
	toolTab.BackgroundColor3 = (tab == "tool") and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 35)
	toolTab.TextColor3 = (tab == "tool") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
	playerTab.BackgroundColor3 = (tab == "player") and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 35)
	playerTab.TextColor3 = (tab == "player") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
	
	if tab == "tool" then scanTool() end
	if tab == "player" then scanPlayer() end
end

toolTab.MouseButton1Click:Connect(function() switchTab("tool") end)
playerTab.MouseButton1Click:Connect(function() switchTab("player") end)

-- =============================================================================
-- 8. BUTTON ACTIONS
-- =============================================================================
scanBtn.MouseButton1Click:Connect(scanTool)

doubleBtn.MouseButton1Click:Connect(function()
	local character = player.Character
	if not character then return end
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return end
	
	local count = tool:GetAttribute("Count")
	if count == nil then
		tool:SetAttribute("Count", 1)
	elseif type(count) == "number" then
		tool:SetAttribute("Count", count * 2)
	end
	scanTool()
end)

scanPlayerBtn.MouseButton1Click:Connect(scanPlayer)

editPlayerBtn.MouseButton1Click:Connect(function()
	-- Opens a simple prompt to add/change player attributes
	local success, input = pcall(function()
		return game:GetService("GuiService"):PromptInput("Enter attribute name", "")
	end)
	
	if success and input and input ~= "" then
		local success2, value = pcall(function()
			return game:GetService("GuiService"):PromptInput("Enter value for " .. input, "string")
		end)
		if success2 and value then
			-- Try to detect type
			local numVal = tonumber(value)
			if numVal then
				player:SetAttribute(input, numVal)
			elseif value == "true" or value == "false" then
				player:SetAttribute(input, value == "true")
			else
				player:SetAttribute(input, value)
			end
			scanPlayer()
		end
	end
end)

-- =============================================================================
-- 9. TOGGLE SYSTEM
-- =============================================================================
local function toggleUI()
	mainFrame.Visible = not mainFrame.Visible
	openButton.Visible = not mainFrame.Visible
end

closeButton.MouseButton1Click:Connect(toggleUI)
openButton.MouseButton1Click:Connect(toggleUI)

local lastToggle = 0
UserInputService.InputBegan:Connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.RightShift then
		local now = tick()
		if now - lastToggle > 0.3 then
			lastToggle = now
			toggleUI()
		end
	end
end)

-- =============================================================================
-- 10. INITIALIZATION
-- =============================================================================
switchTab("tool")
print("⚡ Unified Modifier Suite loaded successfully!") 
print("📌 Press [M] or [Right Shift] to toggle UI")
