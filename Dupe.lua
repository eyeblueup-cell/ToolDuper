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
mainFrame.Size = UDim2.new(0, 520, 0, 480)
mainFrame.Position = UDim2.new(0.5, -260, 0.4, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 10)
barCorner.Parent = titleBar

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
dragDetector.DragStart:Connect(function() end)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.ZIndex = 100
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Re-open Button
local openButton = Instance.new("TextButton")
openButton.Name = "OpenBtn"
openButton.Size = UDim2.new(0, 130, 0, 38)
openButton.Position = UDim2.new(1, -145, 1, -48)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openButton.Text = "⚙️ Open Menu"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 14
openButton.Visible = false
openButton.ZIndex = 100
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- Status Bar
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
statusText.Text = "✅ Ready"
statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
statusText.Font = Enum.Font.SourceSans
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- =============================================================================
-- 3. TAB SYSTEM
-- =============================================================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local function createTabButton(text, icon, position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.33, -2, 1, 0)
	btn.Position = UDim2.new(position, 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	btn.Text = icon .. " " .. text
	btn.TextColor3 = Color3.fromRGB(180, 180, 190)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = tabContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	return btn
end

local toolTab = createTabButton("Tools", "🔧", 0)
local playerTab = createTabButton("Player", "👤", 0.333)
local attrTab = createTabButton("Attributes", "✨", 0.666)

-- Tab Content Frames
local toolContent = Instance.new("Frame")
toolContent.Size = UDim2.new(1, -30, 1, -115)
toolContent.Position = UDim2.new(0, 15, 0, 85)
toolContent.BackgroundTransparency = 1
toolContent.Parent = mainFrame

local playerContent = Instance.new("Frame")
playerContent.Size = UDim2.new(1, -30, 1, -115)
playerContent.Position = UDim2.new(0, 15, 0, 85)
playerContent.BackgroundTransparency = 1
playerContent.Visible = false
playerContent.Parent = mainFrame

local attrContent = Instance.new("Frame")
attrContent.Size = UDim2.new(1, -30, 1, -115)
attrContent.Position = UDim2.new(0, 15, 0, 85)
attrContent.BackgroundTransparency = 1
attrContent.Visible = false
attrContent.Parent = mainFrame

-- =============================================================================
-- 4. TOOL TAB CONTENT
-- =============================================================================
local toolHeader = Instance.new("Frame")
toolHeader.Size = UDim2.new(1, 0, 0, 36)
toolHeader.Position = UDim2.new(0, 0, 0, 0)
toolHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toolHeader.BorderSizePixel = 0
toolHeader.Parent = toolContent

local toolHeaderCorner = Instance.new("UICorner")
toolHeaderCorner.CornerRadius = UDim.new(0, 6)
toolHeaderCorner.Parent = toolHeader

local toolNameLabel = Instance.new("TextLabel")
toolNameLabel.Size = UDim2.new(0.7, -10, 1, 0)
toolNameLabel.Position = UDim2.new(0, 10, 0, 0)
toolNameLabel.BackgroundTransparency = 1
toolNameLabel.Text = "🔧 No Tool Equipped"
toolNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toolNameLabel.Font = Enum.Font.GothamBold
toolNameLabel.TextSize = 14
toolNameLabel.TextXAlignment = Enum.TextXAlignment.Left
toolNameLabel.Parent = toolHeader

local toolRefreshBtn = Instance.new("TextButton")
toolRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
toolRefreshBtn.Position = UDim2.new(1, -90, 0, 4)
toolRefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
toolRefreshBtn.Text = "🔄 Refresh"
toolRefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toolRefreshBtn.Font = Enum.Font.GothamBold
toolRefreshBtn.TextSize = 12
toolRefreshBtn.Parent = toolHeader

local toolRefreshCorner = Instance.new("UICorner")
toolRefreshCorner.CornerRadius = UDim.new(0, 4)
toolRefreshCorner.Parent = toolRefreshBtn

local toolPropsScroll = Instance.new("ScrollingFrame")
toolPropsScroll.Size = UDim2.new(1, 0, 1, -46)
toolPropsScroll.Position = UDim2.new(0, 0, 0, 40)
toolPropsScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
toolPropsScroll.BorderSizePixel = 0
toolPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
toolPropsScroll.ScrollBarThickness = 6
toolPropsScroll.Parent = toolContent

local toolPropsCorner = Instance.new("UICorner")
toolPropsCorner.CornerRadius = UDim.new(0, 6)
toolPropsCorner.Parent = toolPropsScroll

local toolPropsLayout = Instance.new("UIListLayout")
toolPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
toolPropsLayout.Padding = UDim.new(0, 3)
toolPropsLayout.Parent = toolPropsScroll

local toolPropsPadding = Instance.new("UIPadding")
toolPropsPadding.PaddingLeft = UDim.new(0, 8)
toolPropsPadding.PaddingTop = UDim.new(0, 8)
toolPropsPadding.PaddingRight = UDim.new(0, 8)
toolPropsPadding.PaddingBottom = UDim.new(0, 8)
toolPropsPadding.Parent = toolPropsScroll

-- =============================================================================
-- 5. PLAYER TAB CONTENT
-- =============================================================================
local playerHeader = Instance.new("Frame")
playerHeader.Size = UDim2.new(1, 0, 0, 36)
playerHeader.Position = UDim2.new(0, 0, 0, 0)
playerHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
playerHeader.BorderSizePixel = 0
playerHeader.Parent = playerContent

local playerHeaderCorner = Instance.new("UICorner")
playerHeaderCorner.CornerRadius = UDim.new(0, 6)
playerHeaderCorner.Parent = playerHeader

local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0.7, -10, 1, 0)
playerNameLabel.Position = UDim2.new(0, 10, 0, 0)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = "👤 " .. player.Name
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextSize = 14
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.Parent = playerHeader

local playerRefreshBtn = Instance.new("TextButton")
playerRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
playerRefreshBtn.Position = UDim2.new(1, -90, 0, 4)
playerRefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
playerRefreshBtn.Text = "🔄 Refresh"
playerRefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerRefreshBtn.Font = Enum.Font.GothamBold
playerRefreshBtn.TextSize = 12
playerRefreshBtn.Parent = playerHeader

local playerRefreshCorner = Instance.new("UICorner")
playerRefreshCorner.CornerRadius = UDim.new(0, 4)
playerRefreshCorner.Parent = playerRefreshBtn

local playerPropsScroll = Instance.new("ScrollingFrame")
playerPropsScroll.Size = UDim2.new(1, 0, 1, -46)
playerPropsScroll.Position = UDim2.new(0, 0, 0, 40)
playerPropsScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
playerPropsScroll.BorderSizePixel = 0
playerPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerPropsScroll.ScrollBarThickness = 6
playerPropsScroll.Parent = playerContent

local playerPropsCorner = Instance.new("UICorner")
playerPropsCorner.CornerRadius = UDim.new(0, 6)
playerPropsCorner.Parent = playerPropsScroll

local playerPropsLayout = Instance.new("UIListLayout")
playerPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerPropsLayout.Padding = UDim.new(0, 3)
playerPropsLayout.Parent = playerPropsScroll

local playerPropsPadding = Instance.new("UIPadding")
playerPropsPadding.PaddingLeft = UDim.new(0, 8)
playerPropsPadding.PaddingTop = UDim.new(0, 8)
playerPropsPadding.PaddingRight = UDim.new(0, 8)
playerPropsPadding.PaddingBottom = UDim.new(0, 8)
playerPropsPadding.Parent = playerPropsScroll

-- =============================================================================
-- 6. ATTRIBUTES TAB CONTENT
-- =============================================================================
local attrHeader = Instance.new("Frame")
attrHeader.Size = UDim2.new(1, 0, 0, 36)
attrHeader.Position = UDim2.new(0, 0, 0, 0)
attrHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
attrHeader.BorderSizePixel = 0
attrHeader.Parent = attrContent

local attrHeaderCorner = Instance.new("UICorner")
attrHeaderCorner.CornerRadius = UDim.new(0, 6)
attrHeaderCorner.Parent = attrHeader

local attrTitle = Instance.new("TextLabel")
attrTitle.Size = UDim2.new(0.4, -10, 1, 0)
attrTitle.Position = UDim2.new(0, 10, 0, 0)
attrTitle.BackgroundTransparency = 1
attrTitle.Text = "✨ All Attributes"
attrTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
attrTitle.Font = Enum.Font.GothamBold
attrTitle.TextSize = 14
attrTitle.TextXAlignment = Enum.TextXAlignment.Left
attrTitle.Parent = attrHeader

-- Target Dropdown
local attrTargetBtn = Instance.new("TextButton")
attrTargetBtn.Size = UDim2.new(0, 100, 1, -8)
attrTargetBtn.Position = UDim2.new(1, -280, 0, 4)
attrTargetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
attrTargetBtn.Text = "📍 Player"
attrTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
attrTargetBtn.Font = Enum.Font.GothamBold
attrTargetBtn.TextSize = 11
attrTargetBtn.Parent = attrHeader

local attrTargetCorner = Instance.new("UICorner")
attrTargetCorner.CornerRadius = UDim.new(0, 4)
attrTargetCorner.Parent = attrTargetBtn

local attrAddBtn = Instance.new("TextButton")
attrAddBtn.Size = UDim2.new(0, 80, 1, -8)
attrAddBtn.Position = UDim2.new(1, -180, 0, 4)
attrAddBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
attrAddBtn.Text = "➕ Add"
attrAddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
attrAddBtn.Font = Enum.Font.GothamBold
attrAddBtn.TextSize = 12
attrAddBtn.Parent = attrHeader

local attrAddCorner = Instance.new("UICorner")
attrAddCorner.CornerRadius = UDim.new(0, 4)
attrAddCorner.Parent = attrAddBtn

local attrRefreshBtn = Instance.new("TextButton")
attrRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
attrRefreshBtn.Position = UDim2.new(1, -90, 0, 4)
attrRefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
attrRefreshBtn.Text = "🔄 Refresh"
attrRefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
attrRefreshBtn.Font = Enum.Font.GothamBold
attrRefreshBtn.TextSize = 12
attrRefreshBtn.Parent = attrHeader

local attrRefreshCorner = Instance.new("UICorner")
attrRefreshCorner.CornerRadius = UDim.new(0, 4)
attrRefreshCorner.Parent = attrRefreshBtn

local attrPropsScroll = Instance.new("ScrollingFrame")
attrPropsScroll.Size = UDim2.new(1, 0, 1, -46)
attrPropsScroll.Position = UDim2.new(0, 0, 0, 40)
attrPropsScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
attrPropsScroll.BorderSizePixel = 0
attrPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
attrPropsScroll.ScrollBarThickness = 6
attrPropsScroll.Parent = attrContent

local attrPropsCorner = Instance.new("UICorner")
attrPropsCorner.CornerRadius = UDim.new(0, 6)
attrPropsCorner.Parent = attrPropsScroll

local attrPropsLayout = Instance.new("UIListLayout")
attrPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
attrPropsLayout.Padding = UDim.new(0, 3)
attrPropsLayout.Parent = attrPropsScroll

local attrPropsPadding = Instance.new("UIPadding")
attrPropsPadding.PaddingLeft = UDim.new(0, 8)
attrPropsPadding.PaddingTop = UDim.new(0, 8)
attrPropsPadding.PaddingRight = UDim.new(0, 8)
attrPropsPadding.PaddingBottom = UDim.new(0, 8)
attrPropsPadding.Parent = attrPropsScroll

-- =============================================================================
-- 7. UI COMPONENT CREATORS
-- =============================================================================
local function createLabel(parent, text, color, size)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, size or 24)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(220, 220, 220)
	label.Font = Enum.Font.Code
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = parent
	return label
end

-- Custom input prompt using a TextBox instead of GuiService
local function createInputPrompt(title, currentValue, callback)
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.ZIndex = 1000
	overlay.Parent = screenGui
	
	local prompt = Instance.new("Frame")
	prompt.Size = UDim2.new(0, 350, 0, 120)
	prompt.Position = UDim2.new(0.5, -175, 0.5, -60)
	prompt.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	prompt.BorderSizePixel = 0
	prompt.ZIndex = 1001
	prompt.Parent = overlay
	
	local promptCorner = Instance.new("UICorner")
	promptCorner.CornerRadius = UDim.new(0, 8)
	promptCorner.Parent = prompt
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 0, 30)
	titleLabel.Position = UDim2.new(0, 10, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = prompt
	
	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(1, -20, 0, 30)
	inputBox.Position = UDim2.new(0, 10, 0, 40)
	inputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	inputBox.Text = currentValue or ""
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.Font = Enum.Font.Code
	inputBox.TextSize = 14
	inputBox.ClearTextOnFocus = false
	inputBox.ZIndex = 1002
	inputBox.Parent = prompt
	
	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 4)
	inputCorner.Parent = inputBox
	
	local confirmBtn = Instance.new("TextButton")
	confirmBtn.Size = UDim2.new(0, 100, 0, 30)
	confirmBtn.Position = UDim2.new(1, -110, 1, -35)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
	confirmBtn.Text = "Confirm"
	confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.TextSize = 14
	confirmBtn.ZIndex = 1002
	confirmBtn.Parent = prompt
	
	local confirmCorner = Instance.new("UICorner")
	confirmCorner.CornerRadius = UDim.new(0, 4)
	confirmCorner.Parent = confirmBtn
	
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(0, 80, 0, 30)
	cancelBtn.Position = UDim2.new(1, -200, 1, -35)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
	cancelBtn.Text = "Cancel"
	cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.TextSize = 14
	cancelBtn.ZIndex = 1002
	cancelBtn.Parent = prompt
	
	local cancelCorner = Instance.new("UICorner")
	cancelCorner.CornerRadius = UDim.new(0, 4)
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
	
	inputBox:CaptureFocus()
end

local function createEditableValue(parent, name, value, onEdit, showDelete)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 32)
	container.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 4)
	containerCorner.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.35, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 12
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = container
	
	local typeLabel = Instance.new("TextLabel")
	typeLabel.Size = UDim2.new(0, 45, 1, 0)
	typeLabel.Position = UDim2.new(0.35, 5, 0, 0)
	typeLabel.BackgroundTransparency = 1
	typeLabel.Text = "[" .. typeof(value) .. "]"
	typeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	typeLabel.Font = Enum.Font.SourceSans
	typeLabel.TextSize = 10
	typeLabel.TextXAlignment = Enum.TextXAlignment.Left
	typeLabel.Parent = container
	
	local valueBtn = Instance.new("TextButton")
	valueBtn.Size = UDim2.new(0.65, -60, 1, -4)
	valueBtn.Position = UDim2.new(0.35, 55, 0, 2)
	valueBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	valueBtn.Text = tostring(value)
	valueBtn.TextColor3 = Color3.fromRGB(255, 255, 200)
	valueBtn.Font = Enum.Font.Code
	valueBtn.TextSize = 12
	valueBtn.TextXAlignment = Enum.TextXAlignment.Left
	valueBtn.Parent = container
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 3)
	btnCorner.Parent = valueBtn
	
	local editIcon = Instance.new("TextButton")
	editIcon.Size = UDim2.new(0, 24, 1, -4)
	editIcon.Position = UDim2.new(1, -28, 0, 2)
	editIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	editIcon.Text = "✎"
	editIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
	editIcon.Font = Enum.Font.GothamBold
	editIcon.TextSize = 14
	editIcon.Parent = container
	
	local editCorner = Instance.new("UICorner")
	editCorner.CornerRadius = UDim.new(0, 3)
	editCorner.Parent = editIcon
	
	local deleteIcon = Instance.new("TextButton")
	deleteIcon.Size = UDim2.new(0, 20, 1, -4)
	deleteIcon.Position = UDim2.new(1, -52, 0, 2)
	deleteIcon.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
	deleteIcon.Text = "✕"
	deleteIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
	deleteIcon.Font = Enum.Font.GothamBold
	deleteIcon.TextSize = 12
	deleteIcon.Parent = container
	
	local deleteCorner = Instance.new("UICorner")
	deleteCorner.CornerRadius = UDim.new(0, 3)
	deleteCorner.Parent = deleteIcon
	
	if not showDelete then
		deleteIcon.Visible = false
	end
	
	local function updateValue(newVal)
		valueBtn.Text = tostring(newVal)
		typeLabel.Text = "[" .. typeof(newVal) .. "]"
		if onEdit then onEdit(newVal) end
		
		valueBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
		task.wait(0.15)
		valueBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	end
	
	local function promptEdit()
		local currentVal = valueBtn.Text
		createInputPrompt("Edit '" .. name .. "'", currentVal, function(input)
			if input and input ~= "" then
				local num = tonumber(input)
				if num ~= nil then
					updateValue(num)
				elseif input == "true" or input == "false" then
					updateValue(input == "true")
				else
					updateValue(input)
				end
			end
		end)
	end
	
	valueBtn.MouseButton1Click:Connect(promptEdit)
	editIcon.MouseButton1Click:Connect(promptEdit)
	
	return container, valueBtn, deleteIcon
end

local function createSectionHeader(parent, text, color)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 24)
	header.BackgroundTransparency = 1
	header.Text = text
	header.TextColor3 = color or Color3.fromRGB(200, 200, 255)
	header.Font = Enum.Font.GothamBold
	header.TextSize = 13
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = parent
	return header
end

-- =============================================================================
-- 8. CLEAR AND SCAN FUNCTIONS
-- =============================================================================
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

local function scanTool()
	clearScroll(toolPropsScroll)
	
	local character = player.Character
	if not character then
		createLabel(toolPropsScroll, "❌ Error: Character not found!", Color3.fromRGB(255, 100, 100))
		toolNameLabel.Text = "🔧 No Character"
		updateScrollCanvas(toolPropsScroll, toolPropsLayout)
		return
	end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		createLabel(toolPropsScroll, "❌ No tool equipped in hand!", Color3.fromRGB(255, 100, 100))
		toolNameLabel.Text = "🔧 No Tool Equipped"
		updateScrollCanvas(toolPropsScroll, toolPropsLayout)
		return
	end
	
	toolNameLabel.Text = "🔧 " .. tool.Name
	
	createSectionHeader(toolPropsScroll, "📦 Basic Properties", Color3.fromRGB(100, 200, 255))
	
	local basicProps = {"Name", "ClassName", "ToolTip", "Enabled", "CanBeDropped", "RequiresHandle"}
	for _, prop in ipairs(basicProps) do
		local success, val = pcall(function() return tool[prop] end)
		if success and val ~= nil then
			createLabel(toolPropsScroll, "  " .. prop .. ": " .. tostring(val), Color3.fromRGB(220, 220, 220), 22)
		end
	end
	
	local attributes = tool:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(toolPropsScroll, "✨ Tool Attributes (Click to Edit)", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(toolPropsScroll, name, value, function(newVal)
				tool:SetAttribute(name, newVal)
				statusText.Text = "✅ Updated '" .. name .. "' to: " .. tostring(newVal)
				statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				tool:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(toolPropsScroll, toolPropsLayout)
				statusText.Text = "🗑️ Deleted attribute: " .. name
				statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
			end)
		end
	else
		createLabel(toolPropsScroll, "  (No custom attributes)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	local children = tool:GetChildren()
	if #children > 0 then
		createSectionHeader(toolPropsScroll, "📂 Child Objects", Color3.fromRGB(255, 200, 100))
		for _, child in ipairs(children) do
			local childText = "  📁 " .. child.Name
			if child:IsA("Script") or child:IsA("LocalScript") then
				childText = childText .. " [Script]"
			elseif child:IsA("Part") or child:IsA("MeshPart") then
				childText = childText .. " [Part]"
			end
			createLabel(toolPropsScroll, childText, Color3.fromRGB(200, 200, 200), 22)
		end
	end
	
	updateScrollCanvas(toolPropsScroll, toolPropsLayout)
end

local function scanPlayer()
	clearScroll(playerPropsScroll)
	
	local character = player.Character
	if not character then
		createLabel(playerPropsScroll, "❌ Error: Character not found!", Color3.fromRGB(255, 100, 100))
		updateScrollCanvas(playerPropsScroll, playerPropsLayout)
		return
	end
	
	playerNameLabel.Text = "👤 " .. player.Name
	
	createSectionHeader(playerPropsScroll, "👤 Player Info", Color3.fromRGB(100, 200, 255))
	createLabel(playerPropsScroll, "  Name: " .. player.Name, Color3.fromRGB(220, 220, 220), 22)
	createLabel(playerPropsScroll, "  Display Name: " .. player.DisplayName, Color3.fromRGB(220, 220, 220), 22)
	createLabel(playerPropsScroll, "  User ID: " .. player.UserId, Color3.fromRGB(220, 220, 220), 22)
	
	createSectionHeader(playerPropsScroll, "🧍 Character Info", Color3.fromRGB(255, 200, 100))
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		createLabel(playerPropsScroll, "  Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), Color3.fromRGB(220, 220, 220), 22)
		createLabel(playerPropsScroll, "  Walk Speed: " .. humanoid.WalkSpeed, Color3.fromRGB(220, 220, 220), 22)
		createLabel(playerPropsScroll, "  Jump Power: " .. humanoid.JumpPower, Color3.fromRGB(220, 220, 220), 22)
	end
	
	createSectionHeader(playerPropsScroll, "🔧 Equipped Tools", Color3.fromRGB(100, 255, 200))
	local tools = character:GetChildren()
	local hasTools = false
	for _, obj in ipairs(tools) do
		if obj:IsA("Tool") then
			hasTools = true
			createLabel(playerPropsScroll, "  " .. obj.Name, Color3.fromRGB(220, 220, 220), 22)
		end
	end
	if not hasTools then
		createLabel(playerPropsScroll, "  (No tools equipped)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	local attributes = player:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(playerPropsScroll, "✨ Player Attributes (Click to Edit)", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(playerPropsScroll, name, value, function(newVal)
				player:SetAttribute(name, newVal)
				statusText.Text = "✅ Updated '" .. name .. "' to: " .. tostring(newVal)
				statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				player:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(playerPropsScroll, playerPropsLayout)
				statusText.Text = "🗑️ Deleted attribute: " .. name
				statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
			end)
		end
	end
	
	local charAttributes = character:GetAttributes()
	if next(charAttributes) ~= nil then
		createSectionHeader(playerPropsScroll, "✨ Character Attributes (Click to Edit)", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(charAttributes) do
			local container, _, deleteBtn = createEditableValue(playerPropsScroll, name, value, function(newVal)
				character:SetAttribute(name, newVal)
				statusText.Text = "✅ Updated '" .. name .. "' to: " .. tostring(newVal)
				statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				character:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(playerPropsScroll, playerPropsLayout)
				statusText.Text = "🗑️ Deleted attribute: " .. name
				statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
			end)
		end
	end
	
	updateScrollCanvas(playerPropsScroll, playerPropsLayout)
end

local attrTarget = "player" -- "player", "character", or "tool"

local function scanAllAttributes()
	clearScroll(attrPropsScroll)
	
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
		createLabel(attrPropsScroll, "❌ Target not found!", Color3.fromRGB(255, 100, 100))
		updateScrollCanvas(attrPropsScroll, attrPropsLayout)
		return
	end
	
	createSectionHeader(attrPropsScroll, "📍 Target: " .. targetName, Color3.fromRGB(100, 200, 255))
	createLabel(attrPropsScroll, "  Name: " .. targetObj.Name, Color3.fromRGB(220, 220, 220), 22)
	
	local attributes = targetObj:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(attrPropsScroll, "✨ Attributes (Click to Edit)", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(attrPropsScroll, name, value, function(newVal)
				targetObj:SetAttribute(name, newVal)
				statusText.Text = "✅ Updated '" .. name .. "' to: " .. tostring(newVal)
				statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				targetObj:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(attrPropsScroll, attrPropsLayout)
				statusText.Text = "🗑️ Deleted attribute: " .. name
				statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
			end)
		end
	else
		createLabel(attrPropsScroll, "  (No attributes found)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	updateScrollCanvas(attrPropsScroll, attrPropsLayout)
end

-- =============================================================================
-- 9. TAB SWITCHING & BUTTON ACTIONS
-- =============================================================================
local function switchTab(tab)
	toolContent.Visible = (tab == "tool")
	playerContent.Visible = (tab == "player")
	attrContent.Visible = (tab == "attributes")
	
	toolTab.BackgroundColor3 = (tab == "tool") and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 38)
	toolTab.TextColor3 = (tab == "tool") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
	playerTab.BackgroundColor3 = (tab == "player") and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 38)
	playerTab.TextColor3 = (tab == "player") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
	attrTab.BackgroundColor3 = (tab == "attributes") and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(30, 30, 38)
	attrTab.TextColor3 = (tab == "attributes") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
	
	if tab == "tool" then scanTool() end
	if tab == "player" then scanPlayer() end
	if tab == "attributes" then scanAllAttributes() end
end

toolTab.MouseButton1Click:Connect(function() switchTab("tool") end)
playerTab.MouseButton1Click:Connect(function() switchTab("player") end)
attrTab.MouseButton1Click:Connect(function() switchTab("attributes") end)

toolRefreshBtn.MouseButton1Click:Connect(scanTool)
playerRefreshBtn.MouseButton1Click:Connect(scanPlayer)
attrRefreshBtn.MouseButton1Click:Connect(scanAllAttributes)

-- Target dropdown
local targetOptions = {"Player", "Character", "Tool"}
local targetIndex = 1

attrTargetBtn.MouseButton1Click:Connect(function()
	targetIndex = targetIndex % #targetOptions + 1
	attrTarget = string.lower(targetOptions[targetIndex])
	attrTargetBtn.Text = "📍 " .. targetOptions[targetIndex]
	scanAllAttributes()
end)

-- Add Attribute
attrAddBtn.MouseButton1Click:Connect(function()
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
		statusText.Text = "❌ Target not found!"
		statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
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
					statusText.Text = "✅ Added attribute: " .. name .. " = " .. value
					statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
					scanAllAttributes()
				end
			end)
		end
	end)
end)

-- =============================================================================
-- 10. TOGGLE SYSTEM
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
-- 11. INITIALIZATION
-- =============================================================================
switchTab("tool")
print("⚡ Advanced Modifier Suite loaded successfully!")
print("📌 Press [M] or [Right Shift] to toggle UI")
print("📌 Click any value to edit it directly")
