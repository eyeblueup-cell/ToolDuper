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
-- 2. MAIN PANEL - SIMPLIFIED TO ENSURE IT WORKS
-- =============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 600, 0, 500)
mainFrame.Position = UDim2.new(0.5, -300, 0.4, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- =============================================================================
-- 3. TITLE BAR
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
dragDetector.DragStart:Connect(function() end)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.ZIndex = 100
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
openButton.ZIndex = 100
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- =============================================================================
-- 4. STATUS BAR
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

-- =============================================================================
-- 5. TAB SYSTEM
-- =============================================================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local function createTabButton(text, icon, position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.2, -2, 1, -4)
	btn.Position = UDim2.new(position, 0, 0, 2)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	btn.Text = icon .. " " .. text
	btn.TextColor3 = Color3.fromRGB(180, 180, 190)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.BorderSizePixel = 0
	btn.Parent = tabContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	return btn
end

local toolTab = createTabButton("Tools", "🔧", 0)
local playerTab = createTabButton("Player", "👤", 0.2)
local attrTab = createTabButton("Attributes", "✨", 0.4)
local scriptsTab = createTabButton("Scripts", "📜", 0.6)
local settingsTab = createTabButton("Settings", "⚙", 0.8)

-- Tab Content Frames
local toolContent = Instance.new("Frame")
toolContent.Size = UDim2.new(1, -20, 1, -115)
toolContent.Position = UDim2.new(0, 10, 0, 85)
toolContent.BackgroundTransparency = 1
toolContent.Parent = mainFrame

local playerContent = Instance.new("Frame")
playerContent.Size = UDim2.new(1, -20, 1, -115)
playerContent.Position = UDim2.new(0, 10, 0, 85)
playerContent.BackgroundTransparency = 1
playerContent.Visible = false
playerContent.Parent = mainFrame

local attrContent = Instance.new("Frame")
attrContent.Size = UDim2.new(1, -20, 1, -115)
attrContent.Position = UDim2.new(0, 10, 0, 85)
attrContent.BackgroundTransparency = 1
attrContent.Visible = false
attrContent.Parent = mainFrame

local scriptsContent = Instance.new("Frame")
scriptsContent.Size = UDim2.new(1, -20, 1, -115)
scriptsContent.Position = UDim2.new(0, 10, 0, 85)
scriptsContent.BackgroundTransparency = 1
scriptsContent.Visible = false
scriptsContent.Parent = mainFrame

local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1, -20, 1, -115)
settingsContent.Position = UDim2.new(0, 10, 0, 85)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = mainFrame

-- =============================================================================
-- 6. TOOL TAB CONTENT
-- =============================================================================
local toolHeader = Instance.new("Frame")
toolHeader.Size = UDim2.new(1, 0, 0, 36)
toolHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toolHeader.BorderSizePixel = 0
toolHeader.Parent = toolContent

local toolHeaderCorner = Instance.new("UICorner")
toolHeaderCorner.CornerRadius = UDim.new(0, 6)
toolHeaderCorner.Parent = toolHeader

local toolNameLabel = Instance.new("TextLabel")
toolNameLabel.Size = UDim2.new(0.5, -10, 1, 0)
toolNameLabel.Position = UDim2.new(0, 12, 0, 0)
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
toolRefreshBtn.TextSize = 11
toolRefreshBtn.Parent = toolHeader

local toolRefreshCorner = Instance.new("UICorner")
toolRefreshCorner.CornerRadius = UDim.new(0, 4)
toolRefreshCorner.Parent = toolRefreshBtn

local toolDoubleBtn = Instance.new("TextButton")
toolDoubleBtn.Size = UDim2.new(0, 90, 1, -8)
toolDoubleBtn.Position = UDim2.new(1, -190, 0, 4)
toolDoubleBtn.BackgroundColor3 = Color3.fromRGB(35, 165, 90)
toolDoubleBtn.Text = "✖️2 Count"
toolDoubleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toolDoubleBtn.Font = Enum.Font.GothamBold
toolDoubleBtn.TextSize = 11
toolDoubleBtn.Parent = toolHeader

local doubleCorner = Instance.new("UICorner")
doubleCorner.CornerRadius = UDim.new(0, 4)
doubleCorner.Parent = toolDoubleBtn

local toolPropsScroll = Instance.new("ScrollingFrame")
toolPropsScroll.Size = UDim2.new(1, 0, 1, -44)
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
-- 7. PLAYER TAB CONTENT
-- =============================================================================
local playerHeader = Instance.new("Frame")
playerHeader.Size = UDim2.new(1, 0, 0, 36)
playerHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
playerHeader.BorderSizePixel = 0
playerHeader.Parent = playerContent

local playerHeaderCorner = Instance.new("UICorner")
playerHeaderCorner.CornerRadius = UDim.new(0, 6)
playerHeaderCorner.Parent = playerHeader

local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0.6, -10, 1, 0)
playerNameLabel.Position = UDim2.new(0, 12, 0, 0)
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
playerRefreshBtn.TextSize = 11
playerRefreshBtn.Parent = playerHeader

local playerRefreshCorner = Instance.new("UICorner")
playerRefreshCorner.CornerRadius = UDim.new(0, 4)
playerRefreshCorner.Parent = playerRefreshBtn

local playerPropsScroll = Instance.new("ScrollingFrame")
playerPropsScroll.Size = UDim2.new(1, 0, 1, -44)
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
-- 8. ATTRIBUTES TAB CONTENT
-- =============================================================================
local attrHeader = Instance.new("Frame")
attrHeader.Size = UDim2.new(1, 0, 0, 36)
attrHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
attrHeader.BorderSizePixel = 0
attrHeader.Parent = attrContent

local attrHeaderCorner = Instance.new("UICorner")
attrHeaderCorner.CornerRadius = UDim.new(0, 6)
attrHeaderCorner.Parent = attrHeader

local attrTitle = Instance.new("TextLabel")
attrTitle.Size = UDim2.new(0.35, -10, 1, 0)
attrTitle.Position = UDim2.new(0, 12, 0, 0)
attrTitle.BackgroundTransparency = 1
attrTitle.Text = "✨ All Attributes"
attrTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
attrTitle.Font = Enum.Font.GothamBold
attrTitle.TextSize = 14
attrTitle.TextXAlignment = Enum.TextXAlignment.Left
attrTitle.Parent = attrHeader

local attrTargetBtn = Instance.new("TextButton")
attrTargetBtn.Size = UDim2.new(0, 100, 1, -8)
attrTargetBtn.Position = UDim2.new(1, -290, 0, 4)
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
attrAddBtn.Size = UDim2.new(0, 85, 1, -8)
attrAddBtn.Position = UDim2.new(1, -196, 0, 4)
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
attrRefreshBtn.Position = UDim2.new(1, -96, 0, 4)
attrRefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
attrRefreshBtn.Text = "🔄 Refresh"
attrRefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
attrRefreshBtn.Font = Enum.Font.GothamBold
attrRefreshBtn.TextSize = 11
attrRefreshBtn.Parent = attrHeader

local attrRefreshCorner = Instance.new("UICorner")
attrRefreshCorner.CornerRadius = UDim.new(0, 4)
attrRefreshCorner.Parent = attrRefreshBtn

local attrPropsScroll = Instance.new("ScrollingFrame")
attrPropsScroll.Size = UDim2.new(1, 0, 1, -44)
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
-- 9. SCRIPTS TAB CONTENT
-- =============================================================================
local scriptsHeader = Instance.new("Frame")
scriptsHeader.Size = UDim2.new(1, 0, 0, 36)
scriptsHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scriptsHeader.BorderSizePixel = 0
scriptsHeader.Parent = scriptsContent

local scriptsHeaderCorner = Instance.new("UICorner")
scriptsHeaderCorner.CornerRadius = UDim.new(0, 6)
scriptsHeaderCorner.Parent = scriptsHeader

local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Size = UDim2.new(0.5, -10, 1, 0)
scriptsTitle.Position = UDim2.new(0, 12, 0, 0)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = "📜 Script Editor"
scriptsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptsTitle.Font = Enum.Font.GothamBold
scriptsTitle.TextSize = 14
scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
scriptsTitle.Parent = scriptsHeader

local scriptsRefreshBtn = Instance.new("TextButton")
scriptsRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
scriptsRefreshBtn.Position = UDim2.new(1, -90, 0, 4)
scriptsRefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
scriptsRefreshBtn.Text = "🔄 Refresh"
scriptsRefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptsRefreshBtn.Font = Enum.Font.GothamBold
scriptsRefreshBtn.TextSize = 11
scriptsRefreshBtn.Parent = scriptsHeader

local scriptsRefreshCorner = Instance.new("UICorner")
scriptsRefreshCorner.CornerRadius = UDim.new(0, 4)
scriptsRefreshCorner.Parent = scriptsRefreshBtn

local scriptsScroll = Instance.new("ScrollingFrame")
scriptsScroll.Size = UDim2.new(1, 0, 1, -44)
scriptsScroll.Position = UDim2.new(0, 0, 0, 40)
scriptsScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
scriptsScroll.BorderSizePixel = 0
scriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsScroll.ScrollBarThickness = 6
scriptsScroll.Parent = scriptsContent

local scriptsCorner = Instance.new("UICorner")
scriptsCorner.CornerRadius = UDim.new(0, 6)
scriptsCorner.Parent = scriptsScroll

local scriptsLayout = Instance.new("UIListLayout")
scriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
scriptsLayout.Padding = UDim.new(0, 3)
scriptsLayout.Parent = scriptsScroll

local scriptsPadding = Instance.new("UIPadding")
scriptsPadding.PaddingLeft = UDim.new(0, 8)
scriptsPadding.PaddingTop = UDim.new(0, 8)
scriptsPadding.PaddingRight = UDim.new(0, 8)
scriptsPadding.PaddingBottom = UDim.new(0, 8)
scriptsPadding.Parent = scriptsScroll

-- =============================================================================
-- 10. SETTINGS TAB CONTENT
-- =============================================================================
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
settingsScroll.BorderSizePixel = 0
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.ScrollBarThickness = 6
settingsScroll.Parent = settingsContent

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsScroll

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 8)
settingsLayout.Parent = settingsScroll

local settingsPadding = Instance.new("UIPadding")
settingsPadding.PaddingLeft = UDim.new(0, 12)
settingsPadding.PaddingTop = UDim.new(0, 12)
settingsPadding.PaddingRight = UDim.new(0, 12)
settingsPadding.PaddingBottom = UDim.new(0, 12)
settingsPadding.Parent = settingsScroll

-- =============================================================================
-- 11. HELPER FUNCTIONS
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

-- Custom Input Prompt
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

-- Editable Value Component
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
	nameLabel.Size = UDim2.new(0.3, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 12
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = container
	
	local typeLabel = Instance.new("TextLabel")
	typeLabel.Size = UDim2.new(0, 50, 1, 0)
	typeLabel.Position = UDim2.new(0.3, 5, 0, 0)
	typeLabel.BackgroundTransparency = 1
	typeLabel.Text = "[" .. string.sub(typeof(value), 1, 4) .. "]"
	typeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	typeLabel.Font = Enum.Font.SourceSans
	typeLabel.TextSize = 9
	typeLabel.TextXAlignment = Enum.TextXAlignment.Left
	typeLabel.Parent = container
	
	local valueBtn = Instance.new("TextButton")
	valueBtn.Size = UDim2.new(0.7, -70, 1, -4)
	valueBtn.Position = UDim2.new(0.3, 60, 0, 2)
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
	editIcon.Size = UDim2.new(0, 26, 1, -4)
	editIcon.Position = UDim2.new(1, -30, 0, 2)
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
	deleteIcon.Position = UDim2.new(1, -54, 0, 2)
	deleteIcon.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
	deleteIcon.Text = "✕"
	deleteIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
	deleteIcon.Font = Enum.Font.GothamBold
	deleteIcon.TextSize = 11
	deleteIcon.Parent = container
	
	local deleteCorner = Instance.new("UICorner")
	deleteCorner.CornerRadius = UDim.new(0, 3)
	deleteCorner.Parent = deleteIcon
	
	if not showDelete then
		deleteIcon.Visible = false
	end
	
	local function updateValue(newVal)
		valueBtn.Text = tostring(newVal)
		typeLabel.Text = "[" .. string.sub(typeof(newVal), 1, 4) .. "]"
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

-- =============================================================================
-- 12. CLEAR AND UPDATE FUNCTIONS
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

-- =============================================================================
-- 13. SCAN FUNCTIONS
-- =============================================================================
local function scanTool()
	clearScroll(toolPropsScroll)
	
	local character = player.Character
	if not character then
		createLabel(toolPropsScroll, "❌ Character not found!", Color3.fromRGB(255, 100, 100), 24)
		toolNameLabel.Text = "🔧 No Character"
		updateScrollCanvas(toolPropsScroll, toolPropsLayout)
		setStatus("❌ Character not found!")
		return
	end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		createLabel(toolPropsScroll, "❌ No tool equipped!", Color3.fromRGB(255, 100, 100), 24)
		toolNameLabel.Text = "🔧 No Tool Equipped"
		updateScrollCanvas(toolPropsScroll, toolPropsLayout)
		setStatus("❌ No tool equipped!")
		return
	end
	
	toolNameLabel.Text = "🔧 " .. tool.Name
	setStatus("✅ Scanned tool: " .. tool.Name)
	
	createSectionHeader(toolPropsScroll, "📦 Basic Properties", Color3.fromRGB(100, 200, 255))
	
	local basicProps = {"Name", "ClassName", "ToolTip", "Enabled", "CanBeDropped", "RequiresHandle", "TextureId"}
	for _, prop in ipairs(basicProps) do
		local success, val = pcall(function() return tool[prop] end)
		if success and val ~= nil then
			local display = tostring(val)
			if #display > 50 then display = string.sub(display, 1, 50) .. "..."
			end
			createLabel(toolPropsScroll, "  " .. prop .. ": " .. display, Color3.fromRGB(220, 220, 220), 22)
		end
	end
	
	local attributes = tool:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(toolPropsScroll, "✨ Tool Attributes", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(toolPropsScroll, name, value, function(newVal)
				tool:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal))
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				tool:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(toolPropsScroll, toolPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name)
			end)
		end
	else
		createLabel(toolPropsScroll, "  (No custom attributes)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	local children = tool:GetChildren()
	if #children > 0 then
		createSectionHeader(toolPropsScroll, "📂 Child Objects", Color3.fromRGB(255, 200, 100))
		for _, child in ipairs(children) do
			local icon = "📁"
			if child:IsA("Script") or child:IsA("LocalScript") then icon = "📜" end
			if child:IsA("Part") or child:IsA("MeshPart") then icon = "🧩" end
			if child:IsA("Animation") then icon = "🎬" end
			createLabel(toolPropsScroll, "  " .. icon .. " " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(200, 200, 200), 22)
		end
	end
	
	updateScrollCanvas(toolPropsScroll, toolPropsLayout)
end

local function scanPlayer()
	clearScroll(playerPropsScroll)
	
	local character = player.Character
	if not character then
		createLabel(playerPropsScroll, "❌ Character not found!", Color3.fromRGB(255, 100, 100), 24)
		updateScrollCanvas(playerPropsScroll, playerPropsLayout)
		setStatus("❌ Character not found!")
		return
	end
	
	playerNameLabel.Text = "👤 " .. player.Name
	setStatus("✅ Scanned player: " .. player.Name)
	
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
			createLabel(playerPropsScroll, "  • " .. obj.Name, Color3.fromRGB(220, 220, 220), 22)
		end
	end
	if not hasTools then
		createLabel(playerPropsScroll, "  (No tools equipped)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	local attributes = player:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(playerPropsScroll, "✨ Player Attributes", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(playerPropsScroll, name, value, function(newVal)
				player:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal))
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				player:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(playerPropsScroll, playerPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name)
			end)
		end
	end
	
	local charAttributes = character:GetAttributes()
	if next(charAttributes) ~= nil then
		createSectionHeader(playerPropsScroll, "✨ Character Attributes", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(charAttributes) do
			local container, _, deleteBtn = createEditableValue(playerPropsScroll, name, value, function(newVal)
				character:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal))
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				character:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(playerPropsScroll, playerPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name)
			end)
		end
	end
	
	updateScrollCanvas(playerPropsScroll, playerPropsLayout)
end

local attrTarget = "player"
local targetOptions = {"Player", "Character", "Tool"}

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
		createLabel(attrPropsScroll, "❌ Target not found!", Color3.fromRGB(255, 100, 100), 24)
		updateScrollCanvas(attrPropsScroll, attrPropsLayout)
		setStatus("❌ Target not found!")
		return
	end
	
	createSectionHeader(attrPropsScroll, "📍 Target: " .. targetName, Color3.fromRGB(100, 200, 255))
	createLabel(attrPropsScroll, "  Name: " .. targetObj.Name, Color3.fromRGB(220, 220, 220), 22)
	createLabel(attrPropsScroll, "  Class: " .. targetObj.ClassName, Color3.fromRGB(220, 220, 220), 22)
	
	local attributes = targetObj:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(attrPropsScroll, "✨ Attributes", Color3.fromRGB(100, 255, 150))
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(attrPropsScroll, name, value, function(newVal)
				targetObj:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal))
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				targetObj:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(attrPropsScroll, attrPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name)
			end)
		end
	else
		createLabel(attrPropsScroll, "  (No attributes found)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	updateScrollCanvas(attrPropsScroll, attrPropsLayout)
end

-- =============================================================================
-- 14. SCRIPT SCAN FUNCTION
-- =============================================================================
local function scanScripts()
	clearScroll(scriptsScroll)
	
	local character = player.Character
	if not character then
		createLabel(scriptsScroll, "❌ Character not found!", Color3.fromRGB(255, 100, 100), 24)
		updateScrollCanvas(scriptsScroll, scriptsLayout)
		return
	end
	
	local function findScriptsInObject(obj, depth)
		if depth > 2 then return end
		
		for _, child in ipairs(obj:GetChildren()) do
			if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
				local scriptType = child:IsA("LocalScript") and "LocalScript" or 
								  child:IsA("ModuleScript") and "ModuleScript" or "Script"
				
				local container = Instance.new("Frame")
				container.Size = UDim2.new(1, 0, 0, 44)
				container.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
				container.BorderSizePixel = 0
				container.Parent = scriptsScroll
				
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
				nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
				nameLabel.Parent = container
				
				local typeLabel = Instance.new("TextLabel")
				typeLabel.Size = UDim2.new(0.3, 0, 1, 0)
				typeLabel.Position = UDim2.new(0.4, 10, 0, 0)
				typeLabel.BackgroundTransparency = 1
				typeLabel.Text = "[" .. scriptType .. "]"
				typeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				typeLabel.Font = Enum.Font.SourceSans
				typeLabel.TextSize = 11
				typeLabel.TextXAlignment = Enum.TextXAlignment.Left
				typeLabel.Parent = container
				
				local editBtn = Instance.new("TextButton")
				editBtn.Size = UDim2.new(0, 55, 1, -6)
				editBtn.Position = UDim2.new(1, -120, 0, 3)
				editBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
				editBtn.Text = "✎ Edit"
				editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				editBtn.Font = Enum.Font.GothamBold
				editBtn.TextSize = 11
				editBtn.Parent = container
				
				local editCorner = Instance.new("UICorner")
				editCorner.CornerRadius = UDim.new(0, 3)
				editCorner.Parent = editBtn
				
				local viewBtn = Instance.new("TextButton")
				viewBtn.Size = UDim2.new(0, 55, 1, -6)
				viewBtn.Position = UDim2.new(1, -60, 0, 3)
				viewBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
				viewBtn.Text = "👁 View"
				viewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				viewBtn.Font = Enum.Font.GothamBold
				viewBtn.TextSize = 11
				viewBtn.Parent = container
				
				local viewCorner = Instance.new("UICorner")
				viewCorner.CornerRadius = UDim.new(0, 3)
				viewCorner.Parent = viewBtn
				
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
				
				viewBtn.MouseButton1Click:Connect(function()
					local source = child.Source or ""
					createInputPrompt("Viewing: " .. child.Name, source, function() end, true)
				end)
			end
			
			findScriptsInObject(child, depth + 1)
		end
	end
	
	createSectionHeader(scriptsScroll, "📜 Scripts in Character", Color3.fromRGB(100, 200, 255))
	findScriptsInObject(character, 0)
	
	createSectionHeader(scriptsScroll, "📜 Scripts in Player", Color3.fromRGB(255, 200, 100))
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
			container.Parent = scriptsScroll
			
			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 4)
			containerCorner.Parent = container
			
			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
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
			typeLabel.Position = UDim2.new(0.5, 10, 0, 0)
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
		createLabel(scriptsScroll, "  (No scripts in player)", Color3.fromRGB(150, 150, 150), 22)
	end
	
	updateScrollCanvas(scriptsScroll, scriptsLayout)
end

-- =============================================================================
-- 15. BUILD SETTINGS TAB
-- =============================================================================
local function buildSettingsTab()
	clearScroll(settingsScroll)
	
	createSectionHeader(settingsScroll, "⚙ UI Settings", Color3.fromRGB(100, 200, 255))
	createLabel(settingsScroll, "  Press [M] or [Right Shift] to toggle UI", Color3.fromRGB(200, 200, 200), 24)
	createLabel(settingsScroll, "  Click any value to edit it", Color3.fromRGB(200, 200, 200), 24)
	createLabel(settingsScroll, "  Edit scripts in the Scripts tab", Color3.fromRGB(200, 200, 200), 24)
	
	createSectionHeader(settingsScroll, "📊 Info", Color3.fromRGB(255, 200, 100))
	createLabel(settingsScroll, "  Player: " .. player.Name, Color3.fromRGB(220, 220, 220), 22)
	createLabel(settingsScroll, "  User ID: " .. player.UserId, Color3.fromRGB(220, 220, 220), 22)
	
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			createLabel(settingsScroll, "  Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), Color3.fromRGB(220, 220, 220), 22)
		end
	end
	
	createSectionHeader(settingsScroll, "🎨 Features", Color3.fromRGB(100, 255, 150))
	createLabel(settingsScroll, "  ✅ Edit any attribute by clicking it", Color3.fromRGB(200, 255, 200), 22)
	createLabel(settingsScroll, "  ✅ Edit LocalScripts and Scripts", Color3.fromRGB(200, 255, 200), 22)
	createLabel(settingsScroll, "  ✅ View all scripts in character/player", Color3.fromRGB(200, 255, 200), 22)
	createLabel(settingsScroll, "  ✅ Add/delete attributes on the fly", Color3.fromRGB(200, 255, 200), 22)
	createLabel(settingsScroll, "  ✅ Double Count quick action", Color3.fromRGB(200, 255, 200), 22)
	
	updateScrollCanvas(settingsScroll, settingsLayout)
end

-- =============================================================================
-- 16. TAB SWITCHING
-- =============================================================================
local function switchTab(tab)
	toolContent.Visible = (tab == "tool")
	playerContent.Visible = (tab == "player")
	attrContent.Visible = (tab == "attributes")
	scriptsContent.Visible = (tab == "scripts")
	settingsContent.Visible = (tab == "settings")
	
	local tabs = {toolTab, playerTab, attrTab, scriptsTab, settingsTab}
	local activeTab = {tool = 1, player = 2, attributes = 3, scripts = 4, settings = 5}
	
	for i, btn in ipairs(tabs) do
		if i == activeTab[tab] then
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			btn.TextColor3 = Color3.fromRGB(180, 180, 190)
		end
	end
	
	if tab == "tool" then scanTool() end
	if tab == "player" then scanPlayer() end
	if tab == "attributes" then scanAllAttributes() end
	if tab == "scripts" then scanScripts() end
	if tab == "settings" then buildSettingsTab() end
end

toolTab.MouseButton1Click:Connect(function() switchTab("tool") end)
playerTab.MouseButton1Click:Connect(function() switchTab("player") end)
attrTab.MouseButton1Click:Connect(function() switchTab("attributes") end)
scriptsTab.MouseButton1Click:Connect(function() switchTab("scripts") end)
settingsTab.MouseButton1Click:Connect(function() switchTab("settings") end)

-- =============================================================================
-- 17. BUTTON ACTIONS
-- =============================================================================
toolRefreshBtn.MouseButton1Click:Connect(scanTool)
playerRefreshBtn.MouseButton1Click:Connect(scanPlayer)
attrRefreshBtn.MouseButton1Click:Connect(scanAllAttributes)
scriptsRefreshBtn.MouseButton1Click:Connect(scanScripts)

toolDoubleBtn.MouseButton1Click:Connect(function()
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

attrTargetBtn.MouseButton1Click:Connect(function()
	local currentIdx = 1
	for i, name in ipairs(targetOptions) do
		if string.lower(name) == attrTarget then
			currentIdx = i
			break
		end
	end
	currentIdx = currentIdx % #targetOptions + 1
	attrTarget = string.lower(targetOptions[currentIdx])
	attrTargetBtn.Text = "📍 " .. targetOptions[currentIdx]
	scanAllAttributes()
end)

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

-- =============================================================================
-- 18. TOGGLE SYSTEM
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
-- 19. AUTO-REFRESH
-- =============================================================================
local function onCharacterAdded()
	task.wait(1)
	if toolContent.Visible then scanTool() end
	if playerContent.Visible then scanPlayer() end
	if attrContent.Visible then scanAllAttributes() end
	if scriptsContent.Visible then scanScripts() end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- =============================================================================
-- 20. INITIALIZATION
-- =============================================================================
switchTab("tool")
setStatus("🚀 Loaded! 5 tabs with full editing capabilities")

print("⚡ Advanced Modifier Suite loaded successfully!")
print("📌 Press [M] or [Right Shift] to toggle UI")
print("📌 Click any value to edit it")
print("📌 Edit scripts in the Scripts tab")
