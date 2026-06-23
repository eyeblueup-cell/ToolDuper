local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
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
-- 2. UI CUSTOMIZATION SETTINGS
-- =============================================================================
local UISettings = {
	Scale = 1.0,
	Opacity = 1.0,
	ColorTheme = "Dark",
	Position = {X = 0.5, Y = 0.4},
	Size = {Width = 600, Height = 560},
	Draggable = true,
	ShowStatusBar = true,
	ShowTabs = true,
	ShowTitleBar = true,
	FontSize = 12,
}

local Themes = {
	Dark = {
		Background = Color3.fromRGB(18, 18, 23),
		BackgroundAlt = Color3.fromRGB(14, 14, 18),
		BackgroundHover = Color3.fromRGB(28, 28, 36),
		Primary = Color3.fromRGB(70, 130, 255),
		PrimaryDark = Color3.fromRGB(50, 100, 200),
		Success = Color3.fromRGB(50, 220, 130),
		SuccessDark = Color3.fromRGB(35, 165, 90),
		Danger = Color3.fromRGB(255, 70, 70),
		DangerDark = Color3.fromRGB(200, 50, 50),
		Warning = Color3.fromRGB(255, 200, 50),
		Text = Color3.fromRGB(240, 240, 245),
		TextDim = Color3.fromRGB(160, 160, 170),
		TextBright = Color3.fromRGB(255, 255, 255),
		Border = Color3.fromRGB(40, 40, 50),
		CodeBg = Color3.fromRGB(10, 10, 15),
	},
	Light = {
		Background = Color3.fromRGB(240, 240, 245),
		BackgroundAlt = Color3.fromRGB(230, 230, 235),
		BackgroundHover = Color3.fromRGB(220, 220, 225),
		Primary = Color3.fromRGB(70, 130, 255),
		PrimaryDark = Color3.fromRGB(50, 100, 200),
		Success = Color3.fromRGB(50, 220, 130),
		SuccessDark = Color3.fromRGB(35, 165, 90),
		Danger = Color3.fromRGB(255, 70, 70),
		DangerDark = Color3.fromRGB(200, 50, 50),
		Warning = Color3.fromRGB(255, 200, 50),
		Text = Color3.fromRGB(30, 30, 35),
		TextDim = Color3.fromRGB(80, 80, 90),
		TextBright = Color3.fromRGB(0, 0, 0),
		Border = Color3.fromRGB(180, 180, 190),
		CodeBg = Color3.fromRGB(230, 230, 235),
	},
	Blue = {
		Background = Color3.fromRGB(10, 15, 30),
		BackgroundAlt = Color3.fromRGB(8, 12, 25),
		BackgroundHover = Color3.fromRGB(20, 30, 50),
		Primary = Color3.fromRGB(100, 180, 255),
		PrimaryDark = Color3.fromRGB(70, 130, 220),
		Success = Color3.fromRGB(50, 220, 130),
		SuccessDark = Color3.fromRGB(35, 165, 90),
		Danger = Color3.fromRGB(255, 70, 70),
		DangerDark = Color3.fromRGB(200, 50, 50),
		Warning = Color3.fromRGB(255, 200, 50),
		Text = Color3.fromRGB(220, 230, 255),
		TextDim = Color3.fromRGB(140, 160, 200),
		TextBright = Color3.fromRGB(255, 255, 255),
		Border = Color3.fromRGB(40, 60, 100),
		CodeBg = Color3.fromRGB(6, 10, 20),
	},
	Green = {
		Background = Color3.fromRGB(8, 25, 12),
		BackgroundAlt = Color3.fromRGB(6, 20, 10),
		BackgroundHover = Color3.fromRGB(20, 40, 25),
		Primary = Color3.fromRGB(100, 255, 150),
		PrimaryDark = Color3.fromRGB(70, 200, 110),
		Success = Color3.fromRGB(50, 220, 130),
		SuccessDark = Color3.fromRGB(35, 165, 90),
		Danger = Color3.fromRGB(255, 70, 70),
		DangerDark = Color3.fromRGB(200, 50, 50),
		Warning = Color3.fromRGB(255, 200, 50),
		Text = Color3.fromRGB(200, 255, 210),
		TextDim = Color3.fromRGB(130, 200, 150),
		TextBright = Color3.fromRGB(255, 255, 255),
		Border = Color3.fromRGB(40, 80, 50),
		CodeBg = Color3.fromRGB(4, 15, 6),
	},
	Purple = {
		Background = Color3.fromRGB(20, 10, 30),
		BackgroundAlt = Color3.fromRGB(16, 8, 25),
		BackgroundHover = Color3.fromRGB(35, 20, 50),
		Primary = Color3.fromRGB(200, 130, 255),
		PrimaryDark = Color3.fromRGB(160, 100, 220),
		Success = Color3.fromRGB(50, 220, 130),
		SuccessDark = Color3.fromRGB(35, 165, 90),
		Danger = Color3.fromRGB(255, 70, 70),
		DangerDark = Color3.fromRGB(200, 50, 50),
		Warning = Color3.fromRGB(255, 200, 50),
		Text = Color3.fromRGB(240, 220, 255),
		TextDim = Color3.fromRGB(180, 150, 210),
		TextBright = Color3.fromRGB(255, 255, 255),
		Border = Color3.fromRGB(60, 40, 80),
		CodeBg = Color3.fromRGB(12, 6, 18),
	},
}

-- =============================================================================
-- 3. MAIN PANEL
-- =============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, UISettings.Size.Width, 0, UISettings.Size.Height)
mainFrame.Position = UDim2.new(UISettings.Position.X, -UISettings.Size.Width/2, UISettings.Position.Y, -UISettings.Size.Height/2)
mainFrame.BackgroundColor3 = Themes[UISettings.ColorTheme].Background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- =============================================================================
-- 4. TITLE BAR
-- =============================================================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Drag Detector
local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = mainFrame
dragDetector.DragStart:Connect(function() end)

-- Title Icon
local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 30, 1, 0)
titleIcon.Position = UDim2.new(0, 12, 0, 0)
titleIcon.BackgroundTransparency = 1
titleIcon.Text = "⚡"
titleIcon.TextColor3 = Themes[UISettings.ColorTheme].Primary
titleIcon.Font = Enum.Font.GothamBold
titleIcon.TextSize = 20
titleIcon.TextXAlignment = Enum.TextXAlignment.Center
titleIcon.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -200, 1, 0)
titleText.Position = UDim2.new(0, 50, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Advanced Modifier Suite"
titleText.TextColor3 = Themes[UISettings.ColorTheme].TextBright
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Settings Button
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 28, 0, 28)
settingsBtn.Position = UDim2.new(1, -110, 0, 8)
settingsBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = Themes[UISettings.ColorTheme].Text
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 16
settingsBtn.ZIndex = 100
settingsBtn.Parent = mainFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -72, 0, 8)
minimizeBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Themes[UISettings.ColorTheme].Text
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 100
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 8)
closeButton.BackgroundColor3 = Themes[UISettings.ColorTheme].DangerDark
closeButton.Text = "✕"
closeButton.TextColor3 = Themes[UISettings.ColorTheme].TextBright
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.ZIndex = 100
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Re-open Button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.Position = UDim2.new(1, -155, 1, -50)
openButton.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
openButton.Text = "⚙️ Open Menu"
openButton.TextColor3 = Themes[UISettings.ColorTheme].TextBright
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 14
openButton.Visible = false
openButton.ZIndex = 100
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

-- =============================================================================
-- 5. STATUS BAR
-- =============================================================================
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 1, -30)
statusBar.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 12)
statusCorner.Parent = statusBar

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 12, 0.5, -4)
statusDot.BackgroundColor3 = Themes[UISettings.ColorTheme].Success
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBar

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -30, 1, 0)
statusText.Position = UDim2.new(0, 28, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ Ready"
statusText.TextColor3 = Themes[UISettings.ColorTheme].Text
statusText.Font = Enum.Font.SourceSans
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

local function setStatus(text, color, isError)
	statusText.Text = text
	statusText.TextColor3 = color or Themes[UISettings.ColorTheme].Text
	statusDot.BackgroundColor3 = isError and Themes[UISettings.ColorTheme].Danger or Themes[UISettings.ColorTheme].Success
end

-- =============================================================================
-- 6. TAB SYSTEM
-- =============================================================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 44)
tabContainer.Position = UDim2.new(0, 0, 0, 45)
tabContainer.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local function createTabButton(text, icon, position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.2, -2, 1, -4)
	btn.Position = UDim2.new(position, 0, 0, 2)
	btn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
	btn.Text = icon .. " " .. text
	btn.TextColor3 = Themes[UISettings.ColorTheme].TextDim
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
toolContent.Size = UDim2.new(1, -20, 1, -125)
toolContent.Position = UDim2.new(0, 10, 0, 95)
toolContent.BackgroundTransparency = 1
toolContent.Parent = mainFrame

local playerContent = Instance.new("Frame")
playerContent.Size = UDim2.new(1, -20, 1, -125)
playerContent.Position = UDim2.new(0, 10, 0, 95)
playerContent.BackgroundTransparency = 1
playerContent.Visible = false
playerContent.Parent = mainFrame

local attrContent = Instance.new("Frame")
attrContent.Size = UDim2.new(1, -20, 1, -125)
attrContent.Position = UDim2.new(0, 10, 0, 95)
attrContent.BackgroundTransparency = 1
attrContent.Visible = false
attrContent.Parent = mainFrame

local scriptsContent = Instance.new("Frame")
scriptsContent.Size = UDim2.new(1, -20, 1, -125)
scriptsContent.Position = UDim2.new(0, 10, 0, 95)
scriptsContent.BackgroundTransparency = 1
scriptsContent.Visible = false
scriptsContent.Parent = mainFrame

local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1, -20, 1, -125)
settingsContent.Position = UDim2.new(0, 10, 0, 95)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = mainFrame

-- =============================================================================
-- 7. TOOL TAB CONTENT
-- =============================================================================
local toolHeader = Instance.new("Frame")
toolHeader.Size = UDim2.new(1, 0, 0, 40)
toolHeader.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
toolHeader.BorderSizePixel = 0
toolHeader.Parent = toolContent

local toolHeaderCorner = Instance.new("UICorner")
toolHeaderCorner.CornerRadius = UDim.new(0, 8)
toolHeaderCorner.Parent = toolHeader

local toolNameLabel = Instance.new("TextLabel")
toolNameLabel.Size = UDim2.new(0.5, -10, 1, 0)
toolNameLabel.Position = UDim2.new(0, 12, 0, 0)
toolNameLabel.BackgroundTransparency = 1
toolNameLabel.Text = "🔧 No Tool Equipped"
toolNameLabel.TextColor3 = Themes[UISettings.ColorTheme].TextBright
toolNameLabel.Font = Enum.Font.GothamBold
toolNameLabel.TextSize = 14
toolNameLabel.TextXAlignment = Enum.TextXAlignment.Left
toolNameLabel.Parent = toolHeader

local toolDoubleBtn = Instance.new("TextButton")
toolDoubleBtn.Size = UDim2.new(0, 90, 1, -8)
toolDoubleBtn.Position = UDim2.new(1, -190, 0, 4)
toolDoubleBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].SuccessDark
toolDoubleBtn.Text = "✖️2 Count"
toolDoubleBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
toolDoubleBtn.Font = Enum.Font.GothamBold
toolDoubleBtn.TextSize = 11
toolDoubleBtn.Parent = toolHeader

local doubleCorner = Instance.new("UICorner")
doubleCorner.CornerRadius = UDim.new(0, 4)
doubleCorner.Parent = toolDoubleBtn

local toolRefreshBtn = Instance.new("TextButton")
toolRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
toolRefreshBtn.Position = UDim2.new(1, -96, 0, 4)
toolRefreshBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
toolRefreshBtn.Text = "🔄 Refresh"
toolRefreshBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
toolRefreshBtn.Font = Enum.Font.GothamBold
toolRefreshBtn.TextSize = 11
toolRefreshBtn.Parent = toolHeader

local toolRefreshCorner = Instance.new("UICorner")
toolRefreshCorner.CornerRadius = UDim.new(0, 4)
toolRefreshCorner.Parent = toolRefreshBtn

local toolPropsScroll = Instance.new("ScrollingFrame")
toolPropsScroll.Size = UDim2.new(1, 0, 1, -48)
toolPropsScroll.Position = UDim2.new(0, 0, 0, 44)
toolPropsScroll.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
toolPropsScroll.BorderSizePixel = 0
toolPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
toolPropsScroll.ScrollBarThickness = 6
toolPropsScroll.Parent = toolContent

local toolPropsCorner = Instance.new("UICorner")
toolPropsCorner.CornerRadius = UDim.new(0, 8)
toolPropsCorner.Parent = toolPropsScroll

local toolPropsLayout = Instance.new("UIListLayout")
toolPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
toolPropsLayout.Padding = UDim.new(0, 4)
toolPropsLayout.Parent = toolPropsScroll

local toolPropsPadding = Instance.new("UIPadding")
toolPropsPadding.PaddingLeft = UDim.new(0, 10)
toolPropsPadding.PaddingTop = UDim.new(0, 10)
toolPropsPadding.PaddingRight = UDim.new(0, 10)
toolPropsPadding.PaddingBottom = UDim.new(0, 10)
toolPropsPadding.Parent = toolPropsScroll

-- =============================================================================
-- 8. PLAYER TAB CONTENT
-- =============================================================================
local playerHeader = Instance.new("Frame")
playerHeader.Size = UDim2.new(1, 0, 0, 40)
playerHeader.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
playerHeader.BorderSizePixel = 0
playerHeader.Parent = playerContent

local playerHeaderCorner = Instance.new("UICorner")
playerHeaderCorner.CornerRadius = UDim.new(0, 8)
playerHeaderCorner.Parent = playerHeader

local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0.6, -10, 1, 0)
playerNameLabel.Position = UDim2.new(0, 12, 0, 0)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = "👤 " .. player.Name
playerNameLabel.TextColor3 = Themes[UISettings.ColorTheme].TextBright
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextSize = 14
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.Parent = playerHeader

local playerRefreshBtn = Instance.new("TextButton")
playerRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
playerRefreshBtn.Position = UDim2.new(1, -96, 0, 4)
playerRefreshBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
playerRefreshBtn.Text = "🔄 Refresh"
playerRefreshBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
playerRefreshBtn.Font = Enum.Font.GothamBold
playerRefreshBtn.TextSize = 11
playerRefreshBtn.Parent = playerHeader

local playerRefreshCorner = Instance.new("UICorner")
playerRefreshCorner.CornerRadius = UDim.new(0, 4)
playerRefreshCorner.Parent = playerRefreshBtn

local playerPropsScroll = Instance.new("ScrollingFrame")
playerPropsScroll.Size = UDim2.new(1, 0, 1, -48)
playerPropsScroll.Position = UDim2.new(0, 0, 0, 44)
playerPropsScroll.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
playerPropsScroll.BorderSizePixel = 0
playerPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerPropsScroll.ScrollBarThickness = 6
playerPropsScroll.Parent = playerContent

local playerPropsCorner = Instance.new("UICorner")
playerPropsCorner.CornerRadius = UDim.new(0, 8)
playerPropsCorner.Parent = playerPropsScroll

local playerPropsLayout = Instance.new("UIListLayout")
playerPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerPropsLayout.Padding = UDim.new(0, 4)
playerPropsLayout.Parent = playerPropsScroll

local playerPropsPadding = Instance.new("UIPadding")
playerPropsPadding.PaddingLeft = UDim.new(0, 10)
playerPropsPadding.PaddingTop = UDim.new(0, 10)
playerPropsPadding.PaddingRight = UDim.new(0, 10)
playerPropsPadding.PaddingBottom = UDim.new(0, 10)
playerPropsPadding.Parent = playerPropsScroll

-- =============================================================================
-- 9. ATTRIBUTES TAB CONTENT
-- =============================================================================
local attrHeader = Instance.new("Frame")
attrHeader.Size = UDim2.new(1, 0, 0, 40)
attrHeader.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
attrHeader.BorderSizePixel = 0
attrHeader.Parent = attrContent

local attrHeaderCorner = Instance.new("UICorner")
attrHeaderCorner.CornerRadius = UDim.new(0, 8)
attrHeaderCorner.Parent = attrHeader

local attrTitle = Instance.new("TextLabel")
attrTitle.Size = UDim2.new(0.35, -10, 1, 0)
attrTitle.Position = UDim2.new(0, 12, 0, 0)
attrTitle.BackgroundTransparency = 1
attrTitle.Text = "✨ All Attributes"
attrTitle.TextColor3 = Themes[UISettings.ColorTheme].TextBright
attrTitle.Font = Enum.Font.GothamBold
attrTitle.TextSize = 14
attrTitle.TextXAlignment = Enum.TextXAlignment.Left
attrTitle.Parent = attrHeader

local attrTargetBtn = Instance.new("TextButton")
attrTargetBtn.Size = UDim2.new(0, 100, 1, -8)
attrTargetBtn.Position = UDim2.new(1, -290, 0, 4)
attrTargetBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
attrTargetBtn.Text = "📍 Player"
attrTargetBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
attrTargetBtn.Font = Enum.Font.GothamBold
attrTargetBtn.TextSize = 11
attrTargetBtn.Parent = attrHeader

local attrTargetCorner = Instance.new("UICorner")
attrTargetCorner.CornerRadius = UDim.new(0, 4)
attrTargetCorner.Parent = attrTargetBtn

local attrAddBtn = Instance.new("TextButton")
attrAddBtn.Size = UDim2.new(0, 85, 1, -8)
attrAddBtn.Position = UDim2.new(1, -196, 0, 4)
attrAddBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].SuccessDark
attrAddBtn.Text = "➕ Add"
attrAddBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
attrAddBtn.Font = Enum.Font.GothamBold
attrAddBtn.TextSize = 12
attrAddBtn.Parent = attrHeader

local attrAddCorner = Instance.new("UICorner")
attrAddCorner.CornerRadius = UDim.new(0, 4)
attrAddCorner.Parent = attrAddBtn

local attrRefreshBtn = Instance.new("TextButton")
attrRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
attrRefreshBtn.Position = UDim2.new(1, -96, 0, 4)
attrRefreshBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
attrRefreshBtn.Text = "🔄 Refresh"
attrRefreshBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
attrRefreshBtn.Font = Enum.Font.GothamBold
attrRefreshBtn.TextSize = 11
attrRefreshBtn.Parent = attrHeader

local attrRefreshCorner = Instance.new("UICorner")
attrRefreshCorner.CornerRadius = UDim.new(0, 4)
attrRefreshCorner.Parent = attrRefreshBtn

local attrPropsScroll = Instance.new("ScrollingFrame")
attrPropsScroll.Size = UDim2.new(1, 0, 1, -48)
attrPropsScroll.Position = UDim2.new(0, 0, 0, 44)
attrPropsScroll.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
attrPropsScroll.BorderSizePixel = 0
attrPropsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
attrPropsScroll.ScrollBarThickness = 6
attrPropsScroll.Parent = attrContent

local attrPropsCorner = Instance.new("UICorner")
attrPropsCorner.CornerRadius = UDim.new(0, 8)
attrPropsCorner.Parent = attrPropsScroll

local attrPropsLayout = Instance.new("UIListLayout")
attrPropsLayout.SortOrder = Enum.SortOrder.LayoutOrder
attrPropsLayout.Padding = UDim.new(0, 4)
attrPropsLayout.Parent = attrPropsScroll

local attrPropsPadding = Instance.new("UIPadding")
attrPropsPadding.PaddingLeft = UDim.new(0, 10)
attrPropsPadding.PaddingTop = UDim.new(0, 10)
attrPropsPadding.PaddingRight = UDim.new(0, 10)
attrPropsPadding.PaddingBottom = UDim.new(0, 10)
attrPropsPadding.Parent = attrPropsScroll

-- =============================================================================
-- 10. SCRIPTS TAB CONTENT
-- =============================================================================
local scriptsHeader = Instance.new("Frame")
scriptsHeader.Size = UDim2.new(1, 0, 0, 40)
scriptsHeader.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
scriptsHeader.BorderSizePixel = 0
scriptsHeader.Parent = scriptsContent

local scriptsHeaderCorner = Instance.new("UICorner")
scriptsHeaderCorner.CornerRadius = UDim.new(0, 8)
scriptsHeaderCorner.Parent = scriptsHeader

local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Size = UDim2.new(0.5, -10, 1, 0)
scriptsTitle.Position = UDim2.new(0, 12, 0, 0)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = "📜 Script Editor"
scriptsTitle.TextColor3 = Themes[UISettings.ColorTheme].TextBright
scriptsTitle.Font = Enum.Font.GothamBold
scriptsTitle.TextSize = 14
scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
scriptsTitle.Parent = scriptsHeader

local scriptsRefreshBtn = Instance.new("TextButton")
scriptsRefreshBtn.Size = UDim2.new(0, 80, 1, -8)
scriptsRefreshBtn.Position = UDim2.new(1, -96, 0, 4)
scriptsRefreshBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
scriptsRefreshBtn.Text = "🔄 Refresh"
scriptsRefreshBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
scriptsRefreshBtn.Font = Enum.Font.GothamBold
scriptsRefreshBtn.TextSize = 11
scriptsRefreshBtn.Parent = scriptsHeader

local scriptsRefreshCorner = Instance.new("UICorner")
scriptsRefreshCorner.CornerRadius = UDim.new(0, 4)
scriptsRefreshCorner.Parent = scriptsRefreshBtn

local scriptsScroll = Instance.new("ScrollingFrame")
scriptsScroll.Size = UDim2.new(1, 0, 1, -48)
scriptsScroll.Position = UDim2.new(0, 0, 0, 44)
scriptsScroll.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
scriptsScroll.BorderSizePixel = 0
scriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsScroll.ScrollBarThickness = 6
scriptsScroll.Parent = scriptsContent

local scriptsCorner = Instance.new("UICorner")
scriptsCorner.CornerRadius = UDim.new(0, 8)
scriptsCorner.Parent = scriptsScroll

local scriptsLayout = Instance.new("UIListLayout")
scriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
scriptsLayout.Padding = UDim.new(0, 4)
scriptsLayout.Parent = scriptsScroll

local scriptsPadding = Instance.new("UIPadding")
scriptsPadding.PaddingLeft = UDim.new(0, 10)
scriptsPadding.PaddingTop = UDim.new(0, 10)
scriptsPadding.PaddingRight = UDim.new(0, 10)
scriptsPadding.PaddingBottom = UDim.new(0, 10)
scriptsPadding.Parent = scriptsScroll

-- =============================================================================
-- 11. SETTINGS TAB CONTENT
-- =============================================================================
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
settingsScroll.BorderSizePixel = 0
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.ScrollBarThickness = 6
settingsScroll.Parent = settingsContent

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
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
-- 12. UI COMPONENT BUILDERS
-- =============================================================================
local function createLabel(parent, text, color, size)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, size or 24)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Themes[UISettings.ColorTheme].Text
	label.Font = Enum.Font.Code
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = parent
	return label
end

local function createSectionHeader(parent, text, color)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 28)
	header.BackgroundTransparency = 1
	header.Text = text
	header.TextColor3 = color or Themes[UISettings.ColorTheme].Primary
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
	overlay.BackgroundTransparency = 0.6
	overlay.ZIndex = 1000
	overlay.Parent = screenGui
	
	local promptHeight = multiLine and 250 or 140
	local prompt = Instance.new("Frame")
	prompt.Size = UDim2.new(0, 500, 0, promptHeight)
	prompt.Position = UDim2.new(0.5, -250, 0.5, -promptHeight/2)
	prompt.BackgroundColor3 = Themes[UISettings.ColorTheme].Background
	prompt.BorderSizePixel = 0
	prompt.ZIndex = 1001
	prompt.Parent = overlay
	
	local promptCorner = Instance.new("UICorner")
	promptCorner.CornerRadius = UDim.new(0, 12)
	promptCorner.Parent = prompt
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -24, 0, 32)
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = prompt
	
	local inputBox
	if multiLine then
		inputBox = Instance.new("TextBox")
		inputBox.Size = UDim2.new(1, -24, 0, 140)
		inputBox.Position = UDim2.new(0, 12, 0, 46)
		inputBox.BackgroundColor3 = Themes[UISettings.ColorTheme].CodeBg
		inputBox.Text = currentValue or ""
		inputBox.TextColor3 = Themes[UISettings.ColorTheme].TextBright
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
		inputBox.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
		inputBox.Text = currentValue or ""
		inputBox.TextColor3 = Themes[UISettings.ColorTheme].TextBright
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
	confirmBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].SuccessDark
	confirmBtn.Text = "Save"
	confirmBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
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
	cancelBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].DangerDark
	cancelBtn.Text = "Cancel"
	cancelBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
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
	container.Size = UDim2.new(1, 0, 0, 34)
	container.BackgroundColor3 = Themes[UISettings.ColorTheme].Background
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = container
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.3, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Themes[UISettings.ColorTheme].TextBright
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
	typeLabel.TextColor3 = Themes[UISettings.ColorTheme].TextDim
	typeLabel.Font = Enum.Font.SourceSans
	typeLabel.TextSize = 9
	typeLabel.TextXAlignment = Enum.TextXAlignment.Left
	typeLabel.Parent = container
	
	local valueBtn = Instance.new("TextButton")
	valueBtn.Size = UDim2.new(0.7, -70, 1, -4)
	valueBtn.Position = UDim2.new(0.3, 60, 0, 2)
	valueBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
	valueBtn.Text = tostring(value)
	valueBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	valueBtn.Font = Enum.Font.Code
	valueBtn.TextSize = 12
	valueBtn.TextXAlignment = Enum.TextXAlignment.Left
	valueBtn.Parent = container
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = valueBtn
	
	local editIcon = Instance.new("TextButton")
	editIcon.Size = UDim2.new(0, 28, 1, -4)
	editIcon.Position = UDim2.new(1, -32, 0, 2)
	editIcon.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
	editIcon.Text = "✎"
	editIcon.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	editIcon.Font = Enum.Font.GothamBold
	editIcon.TextSize = 14
	editIcon.Parent = container
	
	local editCorner = Instance.new("UICorner")
	editCorner.CornerRadius = UDim.new(0, 4)
	editCorner.Parent = editIcon
	
	local deleteIcon = Instance.new("TextButton")
	deleteIcon.Size = UDim2.new(0, 22, 1, -4)
	deleteIcon.Position = UDim2.new(1, -58, 0, 2)
	deleteIcon.BackgroundColor3 = Themes[UISettings.ColorTheme].DangerDark
	deleteIcon.Text = "✕"
	deleteIcon.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	deleteIcon.Font = Enum.Font.GothamBold
	deleteIcon.TextSize = 11
	deleteIcon.Parent = container
	
	local deleteCorner = Instance.new("UICorner")
	deleteCorner.CornerRadius = UDim.new(0, 4)
	deleteCorner.Parent = deleteIcon
	
	if not showDelete then
		deleteIcon.Visible = false
	end
	
	local function updateValue(newVal)
		valueBtn.Text = tostring(newVal)
		typeLabel.Text = "[" .. string.sub(typeof(newVal), 1, 4) .. "]"
		if onEdit then onEdit(newVal) end
		
		valueBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Success
		task.wait(0.15)
		valueBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
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
-- 13. SCRIPT EDITOR FUNCTIONS
-- =============================================================================
local function scanScripts()
	clearScroll(scriptsScroll)
	
	local character = player.Character
	if not character then
		createLabel(scriptsScroll, "❌ Character not found!", Themes[UISettings.ColorTheme].Danger, 24)
		updateScrollCanvas(scriptsScroll, scriptsLayout)
		return
	end
	
	createSectionHeader(scriptsScroll, "📜 Scripts in Character", Themes[UISettings.ColorTheme].Primary)
	
	local function findScripts(obj, depth)
		if depth > 3 then return end -- Limit depth
		
		for _, child in ipairs(obj:GetChildren()) do
			if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
				local scriptType = child:IsA("LocalScript") and "LocalScript" or 
								  child:IsA("ModuleScript") and "ModuleScript" or "Script"
				
				local container = Instance.new("Frame")
				container.Size = UDim2.new(1, 0, 0, 50)
				container.BackgroundColor3 = Themes[UISettings.ColorTheme].Background
				container.BorderSizePixel = 0
				container.Parent = scriptsScroll
				
				local containerCorner = Instance.new("UICorner")
				containerCorner.CornerRadius = UDim.new(0, 6)
				containerCorner.Parent = container
				
				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
				nameLabel.Position = UDim2.new(0, 10, 0, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = "📄 " .. child.Name
				nameLabel.TextColor3 = Themes[UISettings.ColorTheme].TextBright
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
				typeLabel.TextColor3 = Themes[UISettings.ColorTheme].TextDim
				typeLabel.Font = Enum.Font.SourceSans
				typeLabel.TextSize = 11
				typeLabel.TextXAlignment = Enum.TextXAlignment.Left
				typeLabel.Parent = container
				
				local editBtn = Instance.new("TextButton")
				editBtn.Size = UDim2.new(0, 60, 1, -6)
				editBtn.Position = UDim2.new(1, -130, 0, 3)
				editBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
				editBtn.Text = "✎ Edit"
				editBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
				editBtn.Font = Enum.Font.GothamBold
				editBtn.TextSize = 11
				editBtn.Parent = container
				
				local editCorner = Instance.new("UICorner")
				editCorner.CornerRadius = UDim.new(0, 4)
				editCorner.Parent = editBtn
				
				local viewBtn = Instance.new("TextButton")
				viewBtn.Size = UDim2.new(0, 60, 1, -6)
				viewBtn.Position = UDim2.new(1, -66, 0, 3)
				viewBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
				viewBtn.Text = "👁 View"
				viewBtn.TextColor3 = Themes[UISettings.ColorTheme].Text
				viewBtn.Font = Enum.Font.GothamBold
				viewBtn.TextSize = 11
				viewBtn.Parent = container
				
				local viewCorner = Instance.new("UICorner")
				viewCorner.CornerRadius = UDim.new(0, 4)
				viewCorner.Parent = viewBtn
				
				editBtn.MouseButton1Click:Connect(function()
					local source = child.Source or ""
					createInputPrompt("Editing: " .. child.Name, source, function(newSource)
						if newSource then
							child.Source = newSource
							setStatus("✅ Updated script: " .. child.Name, Themes[UISettings.ColorTheme].Success)
							scanScripts()
						end
					end, true)
				end)
				
				viewBtn.MouseButton1Click:Connect(function()
					local source = child.Source or ""
					createInputPrompt("Viewing: " .. child.Name, source, function()
						-- Read-only, just close
					end, true)
				end)
			end
			
			-- Recurse into children
			findScripts(child, depth + 1)
		end
	end
	
	findScripts(character, 0)
	
	-- Also check player scripts
	createSectionHeader(scriptsScroll, "📜 Scripts in Player", Themes[UISettings.ColorTheme].Warning)
	
	local playerScripts = player:GetChildren()
	local hasPlayerScripts = false
	for _, child in ipairs(playerScripts) do
		if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
			hasPlayerScripts = true
			local scriptType = child:IsA("LocalScript") and "LocalScript" or 
							  child:IsA("ModuleScript") and "ModuleScript" or "Script"
			
			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, 0, 0, 40)
			container.BackgroundColor3 = Themes[UISettings.ColorTheme].Background
			container.BorderSizePixel = 0
			container.Parent = scriptsScroll
			
			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 6)
			containerCorner.Parent = container
			
			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
			nameLabel.Position = UDim2.new(0, 10, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = "📄 " .. child.Name
			nameLabel.TextColor3 = Themes[UISettings.ColorTheme].TextBright
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.TextSize = 12
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.Parent = container
			
			local typeLabel = Instance.new("TextLabel")
			typeLabel.Size = UDim2.new(0.3, 0, 1, 0)
			typeLabel.Position = UDim2.new(0.5, 10, 0, 0)
			typeLabel.BackgroundTransparency = 1
			typeLabel.Text = "[" .. scriptType .. "]"
			typeLabel.TextColor3 = Themes[UISettings.ColorTheme].TextDim
			typeLabel.Font = Enum.Font.SourceSans
			typeLabel.TextSize = 11
			typeLabel.TextXAlignment = Enum.TextXAlignment.Left
			typeLabel.Parent = container
			
			local editBtn = Instance.new("TextButton")
			editBtn.Size = UDim2.new(0, 60, 1, -6)
			editBtn.Position = UDim2.new(1, -66, 0, 3)
			editBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
			editBtn.Text = "✎ Edit"
			editBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
			editBtn.Font = Enum.Font.GothamBold
			editBtn.TextSize = 11
			editBtn.Parent = container
			
			local editCorner = Instance.new("UICorner")
			editCorner.CornerRadius = UDim.new(0, 4)
			editCorner.Parent = editBtn
			
			editBtn.MouseButton1Click:Connect(function()
				local source = child.Source or ""
				createInputPrompt("Editing: " .. child.Name, source, function(newSource)
					if newSource then
						child.Source = newSource
						setStatus("✅ Updated script: " .. child.Name, Themes[UISettings.ColorTheme].Success)
						scanScripts()
					end
				end, true)
			end)
		end
	end
	
	if not hasPlayerScripts then
		createLabel(scriptsScroll, "  (No scripts in player)", Themes[UISettings.ColorTheme].TextDim, 22)
	end
	
	updateScrollCanvas(scriptsScroll, scriptsLayout)
end

-- =============================================================================
-- 14. BUILD SETTINGS TAB
-- =============================================================================
local function buildSettingsTab()
	clearScroll(settingsScroll)
	
	-- Theme selector
	createSectionHeader(settingsScroll, "🎨 Theme", Themes[UISettings.ColorTheme].Primary)
	
	local themeContainer = Instance.new("Frame")
	themeContainer.Size = UDim2.new(1, 0, 0, 34)
	themeContainer.BackgroundTransparency = 1
	themeContainer.Parent = settingsScroll
	
	local themes = {"Dark", "Light", "Blue", "Green", "Purple"}
	for i, themeName in ipairs(themes) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.18, 2, 1, -4)
		btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 2)
		btn.BackgroundColor3 = Themes[themeName].Primary
		btn.Text = themeName
		btn.TextColor3 = Themes[themeName].TextBright
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 10
		btn.Parent = themeContainer
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			UISettings.ColorTheme = themeName
			applyTheme()
			buildSettingsTab()
			setStatus("🎨 Theme changed to: " .. themeName, Themes[UISettings.ColorTheme].Success)
		end)
	end
	
	-- Scale
	createSectionHeader(settingsScroll, "📏 Scale: " .. string.format("%.1f", UISettings.Scale), Themes[UISettings.ColorTheme].Warning)
	
	local scaleContainer = Instance.new("Frame")
	scaleContainer.Size = UDim2.new(1, 0, 0, 24)
	scaleContainer.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
	scaleContainer.Parent = settingsScroll
	
	local scaleCorner = Instance.new("UICorner")
	scaleCorner.CornerRadius = UDim.new(0, 4)
	scaleCorner.Parent = scaleContainer
	
	local scaleFill = Instance.new("Frame")
	scaleFill.Size = UDim2.new((UISettings.Scale - 0.5) / 1.5, 0, 1, 0)
	scaleFill.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
	scaleFill.BorderSizePixel = 0
	scaleFill.Parent = scaleContainer
	
	local scaleCorner2 = Instance.new("UICorner")
	scaleCorner2.CornerRadius = UDim.new(0, 4)
	scaleCorner2.Parent = scaleFill
	
	local scaleButtons = Instance.new("Frame")
	scaleButtons.Size = UDim2.new(1, 0, 0, 24)
	scaleButtons.Position = UDim2.new(0, 0, 0, 28)
	scaleButtons.BackgroundTransparency = 1
	scaleButtons.Parent = settingsScroll
	
	local scales = {"0.5", "0.75", "1.0", "1.25", "1.5", "2.0"}
	for i, s in ipairs(scales) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.15, 0, 1, 0)
		btn.Position = UDim2.new((i-1) * 0.166, 0, 0, 0)
		btn.BackgroundColor3 = UISettings.Scale == tonumber(s) and Themes[UISettings.ColorTheme].Primary or Themes[UISettings.ColorTheme].BackgroundHover
		btn.Text = s
		btn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.Parent = scaleButtons
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			UISettings.Scale = tonumber(s)
			applyTheme()
			buildSettingsTab()
			setStatus("📏 Scale set to: " .. s, Themes[UISettings.ColorTheme].Success)
		end)
	end
	
	-- Opacity
	createSectionHeader(settingsScroll, "👻 Opacity: " .. string.format("%.0f", UISettings.Opacity * 100) .. "%", Themes[UISettings.ColorTheme].Warning)
	
	local opacityContainer = Instance.new("Frame")
	opacityContainer.Size = UDim2.new(1, 0, 0, 24)
	opacityContainer.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
	opacityContainer.Parent = settingsScroll
	
	local opacityCorner = Instance.new("UICorner")
	opacityCorner.CornerRadius = UDim.new(0, 4)
	opacityCorner.Parent = opacityContainer
	
	local opacityFill = Instance.new("Frame")
	opacityFill.Size = UDim2.new(UISettings.Opacity, 0, 1, 0)
	opacityFill.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
	opacityFill.BorderSizePixel = 0
	opacityFill.Parent = opacityContainer
	
	local opacityCorner2 = Instance.new("UICorner")
	opacityCorner2.CornerRadius = UDim.new(0, 4)
	opacityCorner2.Parent = opacityFill
	
	local opacityButtons = Instance.new("Frame")
	opacityButtons.Size = UDim2.new(1, 0, 0, 24)
	opacityButtons.Position = UDim2.new(0, 0, 0, 28)
	opacityButtons.BackgroundTransparency = 1
	opacityButtons.Parent = settingsScroll
	
	local opacities = {"0.25", "0.5", "0.75", "1.0"}
	for i, o in ipairs(opacities) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.23, 0, 1, 0)
		btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
		btn.BackgroundColor3 = UISettings.Opacity == tonumber(o) and Themes[UISettings.ColorTheme].Primary or Themes[UISettings.ColorTheme].BackgroundHover
		btn.Text = string.format("%.0f", tonumber(o) * 100) .. "%"
		btn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.Parent = opacityButtons
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			UISettings.Opacity = tonumber(o)
			applyTheme()
			buildSettingsTab()
			setStatus("👻 Opacity set to: " .. string.format("%.0f", tonumber(o) * 100) .. "%", Themes[UISettings.ColorTheme].Success)
		end)
	end
	
	-- UI Toggles
	createSectionHeader(settingsScroll, "🔘 UI Elements", Themes[UISettings.ColorTheme].Success)
	
	local toggleContainer = Instance.new("Frame")
	toggleContainer.Size = UDim2.new(1, 0, 0, 60)
	toggleContainer.BackgroundTransparency = 1
	toggleContainer.Parent = settingsScroll
	
	local toggles = {
		{name = "Status Bar", key = "ShowStatusBar"},
		{name = "Tabs", key = "ShowTabs"},
		{name = "Title Bar", key = "ShowTitleBar"},
	}
	
	for i, toggle in ipairs(toggles) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.32, 0, 0.45, 0)
		btn.Position = UDim2.new((i-1) * 0.34, 0, 0, 0)
		btn.BackgroundColor3 = UISettings[toggle.key] and Themes[UISettings.ColorTheme].SuccessDark or Themes[UISettings.ColorTheme].DangerDark
		btn.Text = (UISettings[toggle.key] and "✅ " or "❌ ") .. toggle.name
		btn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 11
		btn.Parent = toggleContainer
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			UISettings[toggle.key] = not UISettings[toggle.key]
			applyTheme()
			buildSettingsTab()
			setStatus("🔘 Toggled: " .. toggle.name, Themes[UISettings.ColorTheme].Success)
		end)
	end
	
	-- Reset button
	local resetBtn = Instance.new("TextButton")
	resetBtn.Size = UDim2.new(1, 0, 0, 40)
	resetBtn.Position = UDim2.new(0, 0, 1, -50)
	resetBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].Warning
	resetBtn.Text = "🔄 Reset All Settings"
	resetBtn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.TextSize = 14
	resetBtn.Parent = settingsScroll
	
	local resetCorner = Instance.new("UICorner")
	resetCorner.CornerRadius = UDim.new(0, 6)
	resetCorner.Parent = resetBtn
	
	resetBtn.MouseButton1Click:Connect(function()
		UISettings.Scale = 1.0
		UISettings.Opacity = 1.0
		UISettings.ColorTheme = "Dark"
		UISettings.ShowStatusBar = true
		UISettings.ShowTabs = true
		UISettings.ShowTitleBar = true
		applyTheme()
		buildSettingsTab()
		setStatus("🔄 Settings reset to default!", Themes[UISettings.ColorTheme].Success)
	end)
	
	updateScrollCanvas(settingsScroll, settingsLayout)
end

-- =============================================================================
-- 15. SCAN FUNCTIONS
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
		createLabel(toolPropsScroll, "❌ Character not found!", Themes[UISettings.ColorTheme].Danger, 24)
		toolNameLabel.Text = "🔧 No Character"
		updateScrollCanvas(toolPropsScroll, toolPropsLayout)
		setStatus("❌ Character not found!", Themes[UISettings.ColorTheme].Danger, true)
		return
	end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		createLabel(toolPropsScroll, "❌ No tool equipped!", Themes[UISettings.ColorTheme].Danger, 24)
		toolNameLabel.Text = "🔧 No Tool Equipped"
		updateScrollCanvas(toolPropsScroll, toolPropsLayout)
		setStatus("❌ No tool equipped!", Themes[UISettings.ColorTheme].Danger, true)
		return
	end
	
	toolNameLabel.Text = "🔧 " .. tool.Name
	setStatus("✅ Scanned tool: " .. tool.Name, Themes[UISettings.ColorTheme].Success)
	
	createSectionHeader(toolPropsScroll, "📦 Basic Properties", Themes[UISettings.ColorTheme].Primary)
	
	local basicProps = {"Name", "ClassName", "ToolTip", "Enabled", "CanBeDropped", "RequiresHandle", "TextureId"}
	for _, prop in ipairs(basicProps) do
		local success, val = pcall(function() return tool[prop] end)
		if success and val ~= nil then
			local display = tostring(val)
			if #display > 50 then display = string.sub(display, 1, 50) .. "..." end
			createLabel(toolPropsScroll, "  " .. prop .. ": " .. display, Themes[UISettings.ColorTheme].Text, 22)
		end
	end
	
	local attributes = tool:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(toolPropsScroll, "✨ Tool Attributes", Themes[UISettings.ColorTheme].Success)
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(toolPropsScroll, name, value, function(newVal)
				tool:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal), Themes[UISettings.ColorTheme].Success)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				tool:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(toolPropsScroll, toolPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name, Themes[UISettings.ColorTheme].Warning)
			end)
		end
	else
		createLabel(toolPropsScroll, "  (No custom attributes)", Themes[UISettings.ColorTheme].TextDim, 22)
	end
	
	local children = tool:GetChildren()
	if #children > 0 then
		createSectionHeader(toolPropsScroll, "📂 Child Objects", Themes[UISettings.ColorTheme].Warning)
		for _, child in ipairs(children) do
			local icon = "📁"
			if child:IsA("Script") or child:IsA("LocalScript") then icon = "📜" end
			if child:IsA("Part") or child:IsA("MeshPart") then icon = "🧩" end
			if child:IsA("Animation") then icon = "🎬" end
			createLabel(toolPropsScroll, "  " .. icon .. " " .. child.Name .. " (" .. child.ClassName .. ")", Themes[UISettings.ColorTheme].Text, 22)
		end
	end
	
	updateScrollCanvas(toolPropsScroll, toolPropsLayout)
end

local function scanPlayer()
	clearScroll(playerPropsScroll)
	
	local character = player.Character
	if not character then
		createLabel(playerPropsScroll, "❌ Character not found!", Themes[UISettings.ColorTheme].Danger, 24)
		updateScrollCanvas(playerPropsScroll, playerPropsLayout)
		setStatus("❌ Character not found!", Themes[UISettings.ColorTheme].Danger, true)
		return
	end
	
	playerNameLabel.Text = "👤 " .. player.Name
	setStatus("✅ Scanned player: " .. player.Name, Themes[UISettings.ColorTheme].Success)
	
	createSectionHeader(playerPropsScroll, "👤 Player Info", Themes[UISettings.ColorTheme].Primary)
	createLabel(playerPropsScroll, "  Name: " .. player.Name, Themes[UISettings.ColorTheme].Text, 22)
	createLabel(playerPropsScroll, "  Display Name: " .. player.DisplayName, Themes[UISettings.ColorTheme].Text, 22)
	createLabel(playerPropsScroll, "  User ID: " .. player.UserId, Themes[UISettings.ColorTheme].Text, 22)
	
	createSectionHeader(playerPropsScroll, "🧍 Character Info", Themes[UISettings.ColorTheme].Warning)
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		createLabel(playerPropsScroll, "  Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), Themes[UISettings.ColorTheme].Text, 22)
		createLabel(playerPropsScroll, "  Walk Speed: " .. humanoid.WalkSpeed, Themes[UISettings.ColorTheme].Text, 22)
		createLabel(playerPropsScroll, "  Jump Power: " .. humanoid.JumpPower, Themes[UISettings.ColorTheme].Text, 22)
		createLabel(playerPropsScroll, "  Max Health: " .. humanoid.MaxHealth, Themes[UISettings.ColorTheme].Text, 22)
	end
	
	createSectionHeader(playerPropsScroll, "🔧 Equipped Tools", Themes[UISettings.ColorTheme].Success)
	local tools = character:GetChildren()
	local hasTools = false
	for _, obj in ipairs(tools) do
		if obj:IsA("Tool") then
			hasTools = true
			createLabel(playerPropsScroll, "  • " .. obj.Name, Themes[UISettings.ColorTheme].Text, 22)
		end
	end
	if not hasTools then
		createLabel(playerPropsScroll, "  (No tools equipped)", Themes[UISettings.ColorTheme].TextDim, 22)
	end
	
	local attributes = player:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(playerPropsScroll, "✨ Player Attributes", Themes[UISettings.ColorTheme].Success)
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(playerPropsScroll, name, value, function(newVal)
				player:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal), Themes[UISettings.ColorTheme].Success)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				player:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(playerPropsScroll, playerPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name, Themes[UISettings.ColorTheme].Warning)
			end)
		end
	end
	
	local charAttributes = character:GetAttributes()
	if next(charAttributes) ~= nil then
		createSectionHeader(playerPropsScroll, "✨ Character Attributes", Themes[UISettings.ColorTheme].Success)
		for name, value in pairs(charAttributes) do
			local container, _, deleteBtn = createEditableValue(playerPropsScroll, name, value, function(newVal)
				character:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal), Themes[UISettings.ColorTheme].Success)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				character:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(playerPropsScroll, playerPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name, Themes[UISettings.ColorTheme].Warning)
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
		createLabel(attrPropsScroll, "❌ Target not found!", Themes[UISettings.ColorTheme].Danger, 24)
		updateScrollCanvas(attrPropsScroll, attrPropsLayout)
		setStatus("❌ Target not found!", Themes[UISettings.ColorTheme].Danger, true)
		return
	end
	
	createSectionHeader(attrPropsScroll, "📍 Target: " .. targetName, Themes[UISettings.ColorTheme].Primary)
	createLabel(attrPropsScroll, "  Name: " .. targetObj.Name, Themes[UISettings.ColorTheme].Text, 22)
	createLabel(attrPropsScroll, "  Class: " .. targetObj.ClassName, Themes[UISettings.ColorTheme].Text, 22)
	
	local attributes = targetObj:GetAttributes()
	if next(attributes) ~= nil then
		createSectionHeader(attrPropsScroll, "✨ Attributes", Themes[UISettings.ColorTheme].Success)
		for name, value in pairs(attributes) do
			local container, _, deleteBtn = createEditableValue(attrPropsScroll, name, value, function(newVal)
				targetObj:SetAttribute(name, newVal)
				setStatus("✅ Updated '" .. name .. "' to: " .. tostring(newVal), Themes[UISettings.ColorTheme].Success)
			end, true)
			deleteBtn.MouseButton1Click:Connect(function()
				targetObj:SetAttribute(name, nil)
				container:Destroy()
				updateScrollCanvas(attrPropsScroll, attrPropsLayout)
				setStatus("🗑️ Deleted attribute: " .. name, Themes[UISettings.ColorTheme].Warning)
			end)
		end
	else
		createLabel(attrPropsScroll, "  (No attributes found)", Themes[UISettings.ColorTheme].TextDim, 22)
	end
	
	updateScrollCanvas(attrPropsScroll, attrPropsLayout)
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
			btn.TextColor3 = Themes[UISettings.ColorTheme].TextBright
		else
			btn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
			btn.TextColor3 = Themes[UISettings.ColorTheme].TextDim
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
		setStatus("❌ Character not found!", Themes[UISettings.ColorTheme].Danger, true)
		return
	end
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		setStatus("❌ No tool equipped!", Themes[UISettings.ColorTheme].Danger, true)
		return
	end
	
	local count = tool:GetAttribute("Count")
	if count == nil then
		tool:SetAttribute("Count", 1)
		setStatus("✨ Created 'Count' attribute = 1", Themes[UISettings.ColorTheme].Warning)
	elseif type(count) == "number" then
		local doubled = count * 2
		tool:SetAttribute("Count", doubled)
		setStatus("✖️2 Count: " .. count .. " → " .. doubled, Themes[UISettings.ColorTheme].Success)
	else
		setStatus("⚠️ 'Count' is not a number!", Themes[UISettings.ColorTheme].Warning, true)
	end
	scanTool()
end)

local targetIndex = 1
attrTargetBtn.MouseButton1Click:Connect(function()
	targetIndex = targetIndex % #targetOptions + 1
	attrTarget = string.lower(targetOptions[targetIndex])
	attrTargetBtn.Text = "📍 " .. targetOptions[targetIndex]
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
		setStatus("❌ Target not found!", Themes[UISettings.ColorTheme].Danger, true)
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
					setStatus("✅ Added attribute: " .. name .. " = " .. value, Themes[UISettings.ColorTheme].Success)
					scanAllAttributes()
				end
			end)
		end
	end)
end)

-- =============================================================================
-- 18. APPLY THEME
-- =============================================================================
function applyTheme()
	local theme = Themes[UISettings.ColorTheme]
	
	mainFrame.BackgroundColor3 = theme.Background
	mainFrame.Size = UDim2.new(0, UISettings.Size.Width * UISettings.Scale, 0, UISettings.Size.Height * UISettings.Scale)
	mainFrame.Position = UDim2.new(UISettings.Position.X, -UISettings.Size.Width * UISettings.Scale / 2, UISettings.Position.Y, -UISettings.Size.Height * UISettings.Scale / 2)
	mainFrame.BackgroundTransparency = 1 - UISettings.Opacity
	
	titleBar.BackgroundColor3 = theme.BackgroundAlt
	titleBar.Visible = UISettings.ShowTitleBar
	titleIcon.TextColor3 = theme.Primary
	titleText.TextColor3 = theme.TextBright
	
	statusBar.BackgroundColor3 = theme.BackgroundAlt
	statusBar.Visible = UISettings.ShowStatusBar
	statusText.TextColor3 = theme.Text
	
	tabContainer.Visible = UISettings.ShowTabs
	tabContainer.BackgroundColor3 = theme.BackgroundAlt
	
	openButton.BackgroundColor3 = theme.BackgroundAlt
	openButton.TextColor3 = theme.TextBright
end

-- =============================================================================
-- 19. TOGGLE SYSTEM
-- =============================================================================
local function toggleUI()
	mainFrame.Visible = not mainFrame.Visible
	openButton.Visible = not mainFrame.Visible
end

closeButton.MouseButton1Click:Connect(toggleUI)
openButton.MouseButton1Click:Connect(toggleUI)
minimizeBtn.MouseButton1Click:Connect(toggleUI)

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
-- 20. AUTO-REFRESH
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
-- 21. INITIALIZATION
-- =============================================================================
applyTheme()
switchTab("tool")
setStatus("🚀 Loaded! 5 tabs with full editing capabilities", Themes[UISettings.ColorTheme].Success)

print("⚡ Advanced Modifier Suite v4.0 loaded!")
print("📌 Features:")
print("  • 5 Tabs: Tools, Player, Attributes, Scripts, Settings")
print("  • Click any value to edit")
print("  • Edit LocalScripts, Scripts, and ModuleScripts")
print("  • Full UI customization (theme, scale, opacity)")
print("  • Add/delete attributes on the fly")
print("  • Press [M] or [Right Shift] to toggle")
