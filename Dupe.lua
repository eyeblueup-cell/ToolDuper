local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Clear old UI
local oldGui = playerGui:FindFirstChild("UnifiedModifierGui")
if oldGui then oldGui:Destroy() end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedModifierGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

print("✅ ScreenGui created")

-- =============================================================================
-- MAIN FRAME
-- =============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 500)
mainFrame.Position = UDim2.new(0.5, -300, 0.4, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

print("✅ Main frame created")

-- =============================================================================
-- TITLE BAR
-- =============================================================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ Advanced Modifier Suite"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Drag Detector
local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Re-open Button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 130, 0, 38)
openButton.Position = UDim2.new(1, -145, 1, -48)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openButton.Text = "⚙️ Open Menu"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 14
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

print("✅ Title bar created")

-- =============================================================================
-- STATUS BAR
-- =============================================================================
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 28)
statusBar.Position = UDim2.new(0, 0, 1, -28)
statusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusBar

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 10, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ Ready - Click any value to edit"
statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
statusText.Font = Enum.Font.SourceSans
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

local function setStatus(text)
	statusText.Text = text
end

print("✅ Status bar created")

-- =============================================================================
-- TABS
-- =============================================================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {}
local tabNames = {"Tools", "Player", "Attributes", "Scripts", "Settings"}
local tabIcons = {"🔧", "👤", "✨", "📜", "⚙"}
local tabFrames = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.2, -2, 1, -4)
	btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 2)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	btn.Text = tabIcons[i] .. " " .. name
	btn.TextColor3 = Color3.fromRGB(180, 180, 190)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.BorderSizePixel = 0
	btn.Parent = tabContainer
	btn.Name = name .. "Tab"
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	tabs[name] = btn
	
	-- Content frame for this tab
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -20, 1, -115)
	content.Position = UDim2.new(0, 10, 0, 85)
	content.BackgroundTransparency = 1
	content.Visible = (i == 1)
	content.Parent = mainFrame
	content.Name = name .. "Content"
	
	tabFrames[name] = content
end

print("✅ Tabs created")

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================
local function createLabel(parent, text, color, size)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, size or 24)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(220, 220, 220)
	label.Font = Enum.Font.Code
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = parent
	return label
end

local function createSectionHeader(parent, text, color)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 28)
	header.BackgroundTransparency = 1
	header.Text = text
	header.TextColor3 = color or Color3.fromRGB(100, 200, 255)
	header.Font = Enum.Font.GothamBold
	header.TextSize = 13
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = parent
	return header
end

local function clearScroll(frame)
	for _, child in ipairs(frame:GetChildren()) do
		if child:IsA("TextLabel") or child:IsA("Frame") then
			child:Destroy()
		end
	end
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function updateScrollCanvas(frame, layout)
	frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end

-- =============================================================================
-- INPUT PROMPT
-- =============================================================================
local function createInputPrompt(title, currentValue, callback, multiLine)
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.ZIndex = 1000
	overlay.Parent = screenGui
	
	local promptHeight = multiLine and 300 or 140
	local prompt = Instance.new("Frame")
	prompt.Size = UDim2.new(0, 500, 0, promptHeight)
	prompt.Position = UDim2.new(0.5, -250, 0.5, -promptHeight/2)
	prompt.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	prompt.BorderSizePixel = 0
	prompt.ZIndex = 1001
	prompt.Parent = overlay
	
	local promptCorner = Instance.new("UICorner")
	promptCorner.CornerRadius = UDim.new(0, 10)
	promptCorner.Parent = prompt
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -24, 0, 32)
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = prompt
	
	local inputBox
	if multiLine then
		inputBox = Instance.new("TextBox")
		inputBox.Size = UDim2.new(1, -24, 0, 190)
		inputBox.Position = UDim2.new(0, 12, 0, 46)
		inputBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
		inputBox.Text = currentValue or ""
		inputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
		inputBox.Font = Enum.Font.Code
		inputBox.TextSize = 13
		inputBox.ClearTextOnFocus = false
		inputBox.MultiLine = true
		inputBox.TextWrapped = true
		inputBox.ZIndex = 1002
		inputBox.Parent = prompt
	else
		inputBox = Instance.new("TextBox")
		inputBox.Size = UDim2.new(1, -24, 0, 34)
		inputBox.Position = UDim2.new(0, 12, 0, 46)
		inputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		inputBox.Text = currentValue or ""
		inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		inputBox.Font = Enum.Font.Code
		inputBox.TextSize = 14
		inputBox.ClearTextOnFocus = false
		inputBox.ZIndex = 1002
		inputBox.Parent = prompt
	end
	
	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 6)
	inputCorner.Parent = inputBox
	
	local confirmBtn = Instance.new("TextButton")
	confirmBtn.Size = UDim2.new(0, 100, 0, 32)
	confirmBtn.Position = UDim2.new(1, -110, 1, -38)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
	confirmBtn.Text = "Save"
	confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.TextSize = 14
	confirmBtn.ZIndex = 1002
	confirmBtn.Parent = prompt
	
	local confirmCorner = Instance.new("UICorner")
	confirmCorner.CornerRadius = UDim.new(0, 6)
	confirmCorner.Parent = confirmBtn
	
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(0, 80, 0, 32)
	cancelBtn.Position = UDim2.new(1, -200, 1, -38)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	cancelBtn.Text = "Cancel"
	cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.TextSize = 14
	cancelBtn.ZIndex = 1002
	cancelBtn.Parent = prompt
	
	local cancelCorner = Instance.new("UICorner")
	cancelCorner.CornerRadius = UDim.new(0, 6)
	cancelCorner.Parent = cancelBtn
	
	local function closePrompt(value)
		overlay:Destroy()
		if value ~= nil then
			callback(value)
		end
	end
	
	confirmBtn.MouseButton1Click:Connect(function()
		closePrompt(inputBox.Text)
	end)
	
	cancelBtn.MouseButton1Click:Connect(function()
		closePrompt(nil)
	end)
	
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			closePrompt(inputBox.Text)
		end
	end)
	
	task.wait(0.1)
	inputBox:CaptureFocus()
end

-- =============================================================================
-- BUILD TOOL TAB
-- =============================================================================
local function buildToolTab()
	local content = tabFrames["Tools"]
	
	-- Clear content
	for _, child in ipairs(content:GetChildren()) do
		child:Destroy()
	end
	
	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	header.BorderSizePixel = 0
	header.Parent = content
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 6)
	headerCorner.Parent = header
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "🔧 No Tool Equipped"
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = header
	
	local refreshBtn = Instance.new("TextButton")
	refreshBtn.Size = UDim2.new(0, 80, 1, -8)
	refreshBtn.Position = UDim2.new(1, -90, 0, 4)
	refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	refreshBtn.Text = "🔄 Refresh"
	refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.TextSize = 11
	refreshBtn.Parent = header
	
	local refreshCorner = Instance.new("UICorner")
	refreshCorner.CornerRadius = UDim.new(0, 4)
	refreshCorner.Parent = refreshBtn
	
	local doubleBtn = Instance.new("TextButton")
	doubleBtn.Size = UDim2.new(0, 90, 1, -8)
	doubleBtn.Position = UDim2.new(1, -190, 0, 4)
	doubleBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
	doubleBtn.Text = "✖️2 Count"
	doubleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	doubleBtn.Font = Enum.Font.GothamBold
	doubleBtn.TextSize = 11
	doubleBtn.Parent = header
	
	local doubleCorner = Instance.new("UICorner")
	doubleCorner.CornerRadius = UDim.new(0, 4)
	doubleCorner.Parent = doubleBtn
	
	-- Scroll frame
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, -44)
	scroll.Position = UDim2.new(0, 0, 0, 40)
	scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	scroll.BorderSizePixel = 0
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 6
	scroll.Parent = content
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 6)
	scrollCorner.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 3)
	layout.Parent = scroll
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = scroll
	
	-- Scan function
	local function scanTool()
		clearScroll(scroll)
		
		local character = player.Character
		if not character then
			createLabel(scroll, "❌ Character not found!", Color3.fromRGB(255, 100, 100), 24)
			nameLabel.Text = "🔧 No Character"
			updateScrollCanvas(scroll, layout)
			setStatus("❌ Character not found!")
			return
		end
		
		local tool = character:FindFirstChildOfClass("Tool")
		if not tool then
			createLabel(scroll, "❌ No tool equipped!", Color3.fromRGB(255, 100, 100), 24)
			nameLabel.Text = "🔧 No Tool Equipped"
			updateScrollCanvas(scroll, layout)
			setStatus("❌ No tool equipped!")
			return
		end
		
		nameLabel.Text = "🔧 " .. tool.Name
		setStatus("✅ Scanned tool: " .. tool.Name)
		
		createSectionHeader(scroll, "📦 Basic Properties", Color3.fromRGB(100, 200, 255))
		
		local basicProps = {"Name", "ClassName", "ToolTip", "Enabled", "CanBeDropped", "RequiresHandle", "TextureId"}
		for _, prop in ipairs(basicProps) do
			local success, val = pcall(function() return tool[prop] end)
			if success and val ~= nil then
				local display = tostring(val)
				if #display > 50 then display = string.sub(display, 1, 50) .. "..." end
				createLabel(scroll, "  " .. prop .. ": " .. display, Color3.fromRGB(220, 220, 220), 22)
			end
		end
		
		local attributes = tool:GetAttributes()
		if next(attributes) ~= nil then
			createSectionHeader(scroll, "✨ Tool Attributes", Color3.fromRGB(100, 255, 150))
			for name, value in pairs(attributes) do
				createLabel(scroll, "  " .. name .. " = " .. tostring(value), Color3.fromRGB(200, 255, 200), 22)
			end
		else
			createLabel(scroll, "  (No custom attributes)", Color3.fromRGB(150, 150, 150), 22)
		end
		
		updateScrollCanvas(scroll, layout)
	end
	
	refreshBtn.MouseButton1Click:Connect(scanTool)
	
	doubleBtn.MouseButton1Click:Connect(function()
		local character = player.Character
		if not character then
			setStatus("❌ Character not found!")
			return
		end
		local tool = character:FindFirstChildOfClass("Tool")
		if not tool then
			setStatus("❌ No tool equipped!")
			return
		end
		
		local count = tool:GetAttribute("Count")
		if count == nil then
			tool:SetAttribute("Count", 1)
			setStatus("✨ Created 'Count' attribute = 1")
		elseif type(count) == "number" then
			local doubled = count * 2
			tool:SetAttribute("Count", doubled)
			setStatus("✖️2 Count: " .. count .. " → " .. doubled)
		else
			setStatus("⚠️ 'Count' is not a number!")
		end
		scanTool()
	end)
	
	scanTool()
end

-- =============================================================================
-- BUILD PLAYER TAB
-- =============================================================================
local function buildPlayerTab()
	local content = tabFrames["Player"]
	
	for _, child in ipairs(content:GetChildren()) do
		child:Destroy()
	end
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	header.BorderSizePixel = 0
	header.Parent = content
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 6)
	headerCorner.Parent = header
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.6, -10, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "👤 " .. player.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = header
	
	local refreshBtn = Instance.new("TextButton")
	refreshBtn.Size = UDim2.new(0, 80, 1, -8)
	refreshBtn.Position = UDim2.new(1, -90, 0, 4)
	refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	refreshBtn.Text = "🔄 Refresh"
	refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.TextSize = 11
	refreshBtn.Parent = header
	
	local refreshCorner = Instance.new("UICorner")
	refreshCorner.CornerRadius = UDim.new(0, 4)
	refreshCorner.Parent = refreshBtn
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, -44)
	scroll.Position = UDim2.new(0, 0, 0, 40)
	scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	scroll.BorderSizePixel = 0
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 6
	scroll.Parent = content
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 6)
	scrollCorner.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 3)
	layout.Parent = scroll
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = scroll
	
	local function scanPlayer()
		clearScroll(scroll)
		
		local character = player.Character
		if not character then
			createLabel(scroll, "❌ Character not found!", Color3.fromRGB(255, 100, 100), 24)
			updateScrollCanvas(scroll, layout)
			setStatus("❌ Character not found!")
			return
		end
		
		setStatus("✅ Scanned player: " .. player.Name)
		
		createSectionHeader(scroll, "👤 Player Info", Color3.fromRGB(100, 200, 255))
		createLabel(scroll, "  Name: " .. player.Name, Color3.fromRGB(220, 220, 220), 22)
		createLabel(scroll, "  Display Name: " .. player.DisplayName, Color3.fromRGB(220, 220, 220), 22)
		createLabel(scroll, "  User ID: " .. player.UserId, Color3.fromRGB(220, 220, 220), 22)
		
		createSectionHeader(scroll, "🧍 Character Info", Color3.fromRGB(255, 200, 100))
		
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			createLabel(scroll, "  Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), Color3.fromRGB(220, 220, 220), 22)
			createLabel(scroll, "  Walk Speed: " .. humanoid.WalkSpeed, Color3.fromRGB(220, 220, 220), 22)
			createLabel(scroll, "  Jump Power: " .. humanoid.JumpPower, Color3.fromRGB(220, 220, 220), 22)
		end
		
		createSectionHeader(scroll, "🔧 Equipped Tools", Color3.fromRGB(100, 255, 200))
		local tools = character:GetChildren()
		local hasTools = false
		for _, obj in ipairs(tools) do
			if obj:IsA("Tool") then
				hasTools = true
				createLabel(scroll, "  • " .. obj.Name, Color3.fromRGB(220, 220, 220), 22)
			end
		end
		if not hasTools then
			createLabel(scroll, "  (No tools equipped)", Color3.fromRGB(150, 150, 150), 22)
		end
		
		local attributes = player:GetAttributes()
		if next(attributes) ~= nil then
			createSectionHeader(scroll, "✨ Player Attributes", Color3.fromRGB(100, 255, 150))
			for name, value in pairs(attributes) do
				createLabel(scroll, "  " .. name .. " = " .. tostring(value), Color3.fromRGB(200, 255, 200), 22)
			end
		end
		
		local charAttributes = character:GetAttributes()
		if next(charAttributes) ~= nil then
			createSectionHeader(scroll, "✨ Character Attributes", Color3.fromRGB(100, 255, 150))
			for name, value in pairs(charAttributes) do
				createLabel(scroll, "  " .. name .. " = " .. tostring(value), Color3.fromRGB(200, 255, 200), 22)
			end
		end
		
		updateScrollCanvas(scroll, layout)
	end
	
	refreshBtn.MouseButton1Click:Connect(scanPlayer)
	scanPlayer()
end

-- =============================================================================
-- BUILD ATTRIBUTES TAB
-- =============================================================================
local function buildAttributesTab()
	local content = tabFrames["Attributes"]
	
	for _, child in ipairs(content:GetChildren()) do
		child:Destroy()
	end
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	header.BorderSizePixel = 0
	header.Parent = content
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 6)
	headerCorner.Parent = header
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.35, -10, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "✨ All Attributes"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header
	
	local targetBtn = Instance.new("TextButton")
	targetBtn.Size = UDim2.new(0, 100, 1, -8)
	targetBtn.Position = UDim2.new(1, -290, 0, 4)
	targetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	targetBtn.Text = "📍 Player"
	targetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	targetBtn.Font = Enum.Font.GothamBold
	targetBtn.TextSize = 11
	targetBtn.Parent = header
	
	local targetCorner = Instance.new("UICorner")
	targetCorner.CornerRadius = UDim.new(0, 4)
	targetCorner.Parent = targetBtn
	
	local addBtn = Instance.new("TextButton")
	addBtn.Size = UDim2.new(0, 85, 1, -8)
	addBtn.Position = UDim2.new(1, -196, 0, 4)
	addBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
	addBtn.Text = "➕ Add"
	addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	addBtn.Font = Enum.Font.GothamBold
	addBtn.TextSize = 12
	addBtn.Parent = header
	
	local addCorner = Instance.new("UICorner")
	addCorner.CornerRadius = UDim.new(0, 4)
	addCorner.Parent = addBtn
	
	local refreshBtn = Instance.new("TextButton")
	refreshBtn.Size = UDim2.new(0, 80, 1, -8)
	refreshBtn.Position = UDim2.new(1, -96, 0, 4)
	refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	refreshBtn.Text = "🔄 Refresh"
	refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.TextSize = 11
	refreshBtn.Parent = header
	
	local refreshCorner = Instance.new("UICorner")
	refreshCorner.CornerRadius = UDim.new(0, 4)
	refreshCorner.Parent = refreshBtn
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, -44)
	scroll.Position = UDim2.new(0, 0, 0, 40)
	scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	scroll.BorderSizePixel = 0
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 6
	scroll.Parent = content
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 6)
	scrollCorner.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 3)
	layout.Parent = scroll
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = scroll
	
	local attrTarget = "player"
	local targetOptions = {"Player", "Character", "Tool"}
	
	local function scanAllAttributes()
		clearScroll(scroll)
		
		local targetObj = nil
		local targetName = ""
		
		if attrTarget == "player" then
			targetObj = player
			targetName = "Player"
		elseif attrTarget == "character" then
			targetObj = player.Character
			targetName = "Character"
		elseif attrTarget == "tool" then
			local char = player.Character
			if char then
				targetObj = char:FindFirstChildOfClass("Tool")
				targetName = "Tool"
			end
		end
		
		if not targetObj then
			createLabel(scroll, "❌ Target not found!", Color3.fromRGB(255, 100, 100), 24)
			updateScrollCanvas(scroll, layout)
			setStatus("❌ Target not found!")
			return
		end
		
		createSectionHeader(scroll, "📍 Target: " .. targetName, Color3.fromRGB(100, 200, 255))
		createLabel(scroll, "  Name: " .. targetObj.Name, Color3.fromRGB(220, 220, 220), 22)
		createLabel(scroll, "  Class: " .. targetObj.ClassName, Color3.fromRGB(220, 220, 220), 22)
		
		local attributes = targetObj:GetAttributes()
		if next(attributes) ~= nil then
			createSectionHeader(scroll, "✨ Attributes", Color3.fromRGB(100, 255, 150))
			for name, value in pairs(attributes) do
				createLabel(scroll, "  " .. name .. " = " .. tostring(value), Color3.fromRGB(200, 255, 200), 22)
			end
		else
			createLabel(scroll, "  (No attributes found)", Color3.fromRGB(150, 150, 150), 22)
		end
		
		updateScrollCanvas(scroll, layout)
	end
	
	refreshBtn.MouseButton1Click:Connect(scanAllAttributes)
	
	local targetIndex = 1
	targetBtn.MouseButton1Click:Connect(function()
		targetIndex = targetIndex % #targetOptions + 1
		attrTarget = string.lower(targetOptions[targetIndex])
		targetBtn.Text = "📍 " .. targetOptions[targetIndex]
		scanAllAttributes()
	end)
	
	addBtn.MouseButton1Click:Connect(function()
		local targetObj = nil
		if attrTarget == "player" then
			targetObj = player
		elseif attrTarget == "character" then
			targetObj = player.Character
		elseif attrTarget == "tool" then
			local char = player.Character
			if char then
				targetObj = char:FindFirstChildOfClass("Tool")
			end
		end
		
		if not targetObj then
			setStatus("❌ Target not found!")
			return
		end
		
		createInputPrompt("Enter attribute name", "", function(name)
			if name and name ~= "" then
				createInputPrompt("Enter value for '" .. name .. "'", "1", function(value)
					if value and value ~= "" then
						local num = tonumber(value)
						if num ~= nil then
							targetObj:SetAttribute(name, num)
						elseif value == "true" or value == "false" then
							targetObj:SetAttribute(name, value == "true")
						else
							targetObj:SetAttribute(name, value)
						end
						setStatus("✅ Added attribute: " .. name .. " = " .. value)
						scanAllAttributes()
					end
				end)
			end
		end)
	end)
	
	scanAllAttributes()
end

-- =============================================================================
-- BUILD SCRIPTS TAB
-- =============================================================================
local function buildScriptsTab()
	local content = tabFrames["Scripts"]
	
	for _, child in ipairs(content:GetChildren()) do
		child:Destroy()
	end
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	header.BorderSizePixel = 0
	header.Parent = content
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 6)
	headerCorner.Parent = header
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.5, -10, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "📜 Script Editor"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header
	
	local refreshBtn = Instance.new("TextButton")
	refreshBtn.Size = UDim2.new(0, 80, 1, -8)
	refreshBtn.Position = UDim2.new(1, -90, 0, 4)
	refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	refreshBtn.Text = "🔄 Refresh"
	refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.TextSize = 11
	refreshBtn.Parent = header
	
	local refreshCorner = Instance.new("UICorner")
	refreshCorner.CornerRadius = UDim.new(0, 4)
	refreshCorner.Parent = refreshBtn
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, -44)
	scroll.Position = UDim2.new(0, 0, 0, 40)
	scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	scroll.BorderSizePixel = 0
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 6
	scroll.Parent = content
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 6)
	scrollCorner.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 3)
	layout.Parent = scroll
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = scroll
	
	local function scanScripts()
		clearScroll(scroll)
		
		local character = player.Character
		if not character then
			createLabel(scroll, "❌ Character not found!", Color3.fromRGB(255, 100, 100), 24)
			updateScrollCanvas(scroll, layout)
			return
		end
		
		local function findScripts(obj, depth)
			if depth > 2 then return end
			
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
					local scriptType = child:IsA("LocalScript") and "LocalScript" or 
									  child:IsA("ModuleScript") and "ModuleScript" or "Script"
					
					local container = Instance.new("Frame")
					container.Size = UDim2.new(1, 0, 0, 36)
					container.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
					container.BorderSizePixel = 0
					container.Parent = scroll
					
					local containerCorner = Instance.new("UICorner")
					containerCorner.CornerRadius = UDim.new(0, 4)
					containerCorner.Parent = container
					
					local nameLabel = Instance.new("TextLabel")
					nameLabel.Size = UDim2.new(0.35, 0, 1, 0)
					nameLabel.Position = UDim2.new(0, 10, 0, 0)
					nameLabel.BackgroundTransparency = 1
					nameLabel.Text = "📄 " .. child.Name
					nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					nameLabel.Font = Enum.Font.GothamBold
					nameLabel.TextSize = 12
					nameLabel.TextXAlignment = Enum.TextXAlignment.Left
					nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
					nameLabel.Parent = container
					
					local typeLabel = Instance.new("TextLabel")
					typeLabel.Size = UDim2.new(0.25, 0, 1, 0)
					typeLabel.Position = UDim2.new(0.35, 10, 0, 0)
					typeLabel.BackgroundTransparency = 1
					typeLabel.Text = "[" .. scriptType .. "]"
					typeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
					typeLabel.Font = Enum.Font.SourceSans
					typeLabel.TextSize = 11
					typeLabel.TextXAlignment = Enum.TextXAlignment.Left
					typeLabel.Parent = container
					
					local editBtn = Instance.new("TextButton")
					editBtn.Size = UDim2.new(0, 55, 1, -6)
					editBtn.Position = UDim2.new(1, -60, 0, 3)
					editBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
					editBtn.Text = "✎ Edit"
					editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
					editBtn.Font = Enum.Font.GothamBold
					editBtn.TextSize = 11
					editBtn.Parent = container
					
					local editCorner = Instance.new("UICorner")
					editCorner.CornerRadius = UDim.new(0, 3)
					editCorner.Parent = editBtn
					
					editBtn.MouseButton1Click:Connect(function()
						local source = child.Source or ""
						createInputPrompt("Editing: " .. child.Name, source, function(newSource)
							if newSource then
								child.Source = newSource
								setStatus("✅ Updated script: " .. child.Name)
								scanScripts()
							end
						end, true)
					end)
				end
				
				findScripts(child, depth + 1)
			end
		end
		
		createSectionHeader(scroll, "📜 Scripts in Character", Color3.fromRGB(100, 200, 255))
		findScripts(character, 0)
		
		createSectionHeader(scroll, "📜 Scripts in Player", Color3.fromRGB(255, 200, 100))
		local hasPlayerScripts = false
		for _, child in ipairs(player:GetChildren()) do
			if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
				hasPlayerScripts = true
				local scriptType = child:IsA("LocalScript") and "LocalScript" or 
								  child:IsA("ModuleScript") and "ModuleScript" or "Script"
				
				local container = Instance.new("Frame")
				container.Size = UDim2.new(1, 0, 0, 36)
				container.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
				container.BorderSizePixel = 0
				container.Parent = scroll
				
				local containerCorner = Instance.new("UICorner")
				containerCorner.CornerRadius = UDim.new(0, 4)
				containerCorner.Parent = container
				
				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
				nameLabel.Position = UDim2.new(0, 10, 0, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = "📄 " .. child.Name
				nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				nameLabel.Font = Enum.Font.GothamBold
				nameLabel.TextSize = 12
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.Parent = container
				
				local typeLabel = Instance.new("TextLabel")
				typeLabel.Size = UDim2.new(0.3, 0, 1, 0)
				typeLabel.Position = UDim2.new(0.4, 10, 0, 0)
				typeLabel.BackgroundTransparency = 1
				typeLabel.Text = "[" .. scriptType .. "]"
				typeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				typeLabel.Font = Enum.Font.SourceSans
				typeLabel.TextSize = 11
				typeLabel.Parent = container
				
				local editBtn = Instance.new("TextButton")
				editBtn.Size = UDim2.new(0, 55, 1, -6)
				editBtn.Position = UDim2.new(1, -60, 0, 3)
				editBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
				editBtn.Text = "✎ Edit"
				editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				editBtn.Font = Enum.Font.GothamBold
				editBtn.TextSize = 11
				editBtn.Parent = container
				
				local editCorner = Instance.new("UICorner")
				editCorner.CornerRadius = UDim.new(0, 3)
				editCorner.Parent = editBtn
				
				editBtn.MouseButton1Click:Connect(function()
					local source = child.Source or ""
					createInputPrompt("Editing: " .. child.Name, source, function(newSource)
						if newSource then
							child.Source = newSource
							setStatus("✅ Updated script: " .. child.Name)
							scanScripts()
						end
					end, true)
				end)
			end
		end
		
		if not hasPlayerScripts then
			createLabel(scroll, "  (No scripts in player)", Color3.fromRGB(150, 150, 150), 22)
		end
		
		updateScrollCanvas(scroll, layout)
	end
	
	refreshBtn.MouseButton1Click:Connect(scanScripts)
	scanScripts()
end

-- =============================================================================
-- BUILD SETTINGS TAB
-- =============================================================================
local function buildSettingsTab()
	local content = tabFrames["Settings"]
	
	for _, child in ipairs(content:GetChildren()) do
		child:Destroy()
	end
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	scroll.BorderSizePixel = 0
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 6
	scroll.Parent = content
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 6)
	scrollCorner.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.Parent = scroll
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.Parent = scroll
	
	createSectionHeader(scroll, "⚙ UI Settings", Color3.fromRGB(100, 200, 255))
	createLabel(scroll, "  Press [M] or [Right Shift] to toggle UI", Color3.fromRGB(200, 200, 200), 24)
	createLabel(scroll, "  Click any value to edit it", Color3.fromRGB(200, 200, 200), 24)
	createLabel(scroll, "  Edit scripts in the Scripts tab", Color3.fromRGB(200, 200, 200), 24)
	
	createSectionHeader(scroll, "📊 Info", Color3.fromRGB(255, 200, 100))
	createLabel(scroll, "  Player: " .. player.Name, Color3.fromRGB(220, 220, 220), 22)
	createLabel(scroll, "  User ID: " .. player.UserId, Color3.fromRGB(220, 220, 220), 22)
	
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			createLabel(scroll, "  Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), Color3.fromRGB(220, 220, 220), 22)
		end
	end
	
	createSectionHeader(scroll, "🎨 Features", Color3.fromRGB(100, 255, 150))
	createLabel(scroll, "  ✅ Edit any attribute by clicking it", Color3.fromRGB(200, 255, 200), 22)
	createLabel(scroll, "  ✅ Edit LocalScripts and Scripts", Color3.fromRGB(200, 255, 200), 22)
	createLabel(scroll, "  ✅ View all scripts in character/player", Color3.fromRGB(200, 255, 200), 22)
	createLabel(scroll, "  ✅ Add/delete attributes on the fly", Color3.fromRGB(200, 255, 200), 22)
	createLabel(scroll, "  ✅ Double Count quick action", Color3.fromRGB(200, 255, 200), 22)
	
	updateScrollCanvas(scroll, layout)
end

-- =============================================================================
-- TAB SWITCHING
-- =============================================================================
local function switchTab(tabName)
	local contentMap = {
		Tools = tabFrames["Tools"],
		Player = tabFrames["Player"],
		Attributes = tabFrames["Attributes"],
		Scripts = tabFrames["Scripts"],
		Settings = tabFrames["Settings"]
	}
	
	for name, content in pairs(contentMap) do
		content.Visible = (name == tabName)
	end
	
	for name, btn in pairs(tabs) do
		if name == tabName then
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			btn.TextColor3 = Color3.fromRGB(180, 180, 190)
		end
	end
	
	-- Build the tab content
	if tabName == "Tools" then buildToolTab() end
	if tabName == "Player" then buildPlayerTab() end
	if tabName == "Attributes" then buildAttributesTab() end
	if tabName == "Scripts" then buildScriptsTab() end
	if tabName == "Settings" then buildSettingsTab() end
end

-- Connect tab buttons
for name, btn in pairs(tabs) do
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
end

-- =============================================================================
-- TOGGLE SYSTEM
-- =============================================================================
local function toggleUI()
	mainFrame.Visible = not mainFrame.Visible
	openButton.Visible = not mainFrame.Visible
	print("Toggled UI - Visible:", mainFrame.Visible)
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
-- INITIALIZATION
-- =============================================================================
switchTab("Tools")
setStatus("🚀 Loaded! Press M or Right Shift to toggle")

print("⚡ Advanced Modifier Suite loaded successfully!")
print("📌 Press [M] or [Right Shift] to toggle UI")
print("📌 Click any value to edit it")
print("📌 Edit scripts in the Scripts tab")
