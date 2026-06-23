local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
	ColorTheme = "Dark", -- "Dark", "Light", "Blue", "Green", "Purple"
	Position = {X = 0.5, Y = 0.4},
	Size = {Width = 560, Height = 520},
	Draggable = true,
	ShowStatusBar = true,
	ShowTabs = true,
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

-- UI Settings Button
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
	
	local tween = TweenService:Create(statusDot, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		BackgroundColor3 = isError and Themes[UISettings.ColorTheme].Danger or Themes[UISettings.ColorTheme].Success
	})
	tween:Play()
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
	btn.Size = UDim2.new(0.333, -2, 1, -4)
	btn.Position = UDim2.new(position, 0, 0, 2)
	btn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
	btn.Text = icon .. " " .. text
	btn.TextColor3 = Themes[UISettings.ColorTheme].TextDim
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = tabContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	btn.MouseEnter:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(50, 50, 60) then
			btn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
		end
	end)
	btn.MouseLeave:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(50, 50, 60) then
			btn.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundHover
		end
	end)
	
	return btn
end

local toolTab = createTabButton("Tools", "🔧", 0)
local playerTab = createTabButton("Player", "👤", 0.333)
local attrTab = createTabButton("Attributes", "✨", 0.666)

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
-- 10. UI COMPONENT BUILDERS
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
local function createInputPrompt(title, currentValue, callback)
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.6
	overlay.ZIndex = 1000
	overlay.Parent = screenGui
	
	overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			overlay:Destroy()
		end
	end)
	
	local prompt = Instance.new("Frame")
	prompt.Size = UDim2.new(0, 400, 0, 140)
	prompt.Position = UDim2.new(0.5, -200, 0.5, -70)
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
	
	local inputBox = Instance.new("TextBox")
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
	
	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 6)
	inputCorner.Parent = inputBox
	
	local confirmBtn = Instance.new("TextButton")
	confirmBtn.Size = UDim2.new(0, 100, 0, 32)
	confirmBtn.Position = UDim2.new(1, -110, 1, -38)
	confirmBtn.BackgroundColor3 = Themes[UISettings.ColorTheme].SuccessDark
	confirmBtn.Text = "Confirm"
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
	nameLabel.Size = UDim2.new(0.32, 0, 1, 0)
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
	typeLabel.Position = UDim2.new(0.32, 5, 0, 0)
	typeLabel.BackgroundTransparency = 1
	typeLabel.Text = "[" .. string.sub(typeof(value), 1, 4) .. "]"
	typeLabel.TextColor3 = Themes[UISettings.ColorTheme].TextDim
	typeLabel.Font = Enum.Font.SourceSans
	typeLabel.TextSize = 9
	typeLabel.TextXAlignment = Enum.TextXAlignment.Left
	typeLabel.Parent = container
	
	local valueBtn = Instance.new("TextButton")
	valueBtn.Size = UDim2.new(0.68, -70, 1, -4)
	valueBtn.Position = UDim2.new(0.32, 60, 0, 2)
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
-- 11. UI SETTINGS PANEL
-- =============================================================================
local settingsPanel = nil
local settingsOpen = false

local function createSettingsPanel()
	if settingsPanel then
		settingsPanel:Destroy()
		settingsPanel = nil
		settingsOpen = false
		return
	end
	
	settingsPanel = Instance.new("Frame")
	settingsPanel.Size = UDim2.new(0, 300, 0, 350)
	settingsPanel.Position = UDim2.new(0.5, -150, 0.5, -175)
	settingsPanel.BackgroundColor3 = Themes[UISettings.ColorTheme].Background
	settingsPanel.BorderSizePixel = 0
	settingsPanel.ZIndex = 500
	settingsPanel.Parent = screenGui
	
	local settingsCorner = Instance.new("UICorner")
	settingsCorner.CornerRadius = UDim.new(0, 12)
	settingsCorner.Parent = settingsPanel
	
	local settingsTitle = Instance.new("TextLabel")
	settingsTitle.Size = UDim2.new(1, 0, 0, 40)
	settingsTitle.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
	settingsTitle.Text = "⚙ UI Settings"
	settingsTitle.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	settingsTitle.Font = Enum.Font.GothamBold
	settingsTitle.TextSize = 16
	settingsTitle.Parent = settingsPanel
	
	local settingsCorner2 = Instance.new("UICorner")
	settingsCorner2.CornerRadius = UDim.new(0, 12)
	settingsCorner2.Parent = settingsTitle
	
	local settingsClose = Instance.new("TextButton")
	settingsClose.Size = UDim2.new(0, 28, 0, 28)
	settingsClose.Position = UDim2.new(1, -36, 0, 6)
	settingsClose.BackgroundColor3 = Themes[UISettings.ColorTheme].DangerDark
	settingsClose.Text = "✕"
	settingsClose.TextColor3 = Themes[UISettings.ColorTheme].TextBright
	settingsClose.Font = Enum.Font.GothamBold
	settingsClose.TextSize = 14
	settingsClose.ZIndex = 501
	settingsClose.Parent = settingsPanel
	
	local settingsCloseCorner = Instance.new("UICorner")
	settingsCloseCorner.CornerRadius = UDim.new(0, 6)
	settingsCloseCorner.Parent = settingsClose
	
	local settingsScroll = Instance.new("ScrollingFrame")
	settingsScroll.Size = UDim2.new(1, -20, 1, -60)
	settingsScroll.Position = UDim2.new(0, 10, 0, 50)
	settingsScroll.BackgroundTransparency = 1
	settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
	settingsScroll.ScrollBarThickness = 4
	settingsScroll.Parent = settingsPanel
	
	local settingsLayout = Instance.new("UIListLayout")
	settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	settingsLayout.Padding = UDim.new(0, 8)
	settingsLayout.Parent = settingsScroll
	
	-- Theme selector
	local themeLabel = Instance.new("TextLabel")
	themeLabel.Size = UDim2.new(1, 0, 0, 24)
	themeLabel.BackgroundTransparency = 1
	themeLabel.Text = "Theme:"
	themeLabel.TextColor3 = Themes[UISettings.ColorTheme].Text
	themeLabel.Font = Enum.Font.GothamBold
	themeLabel.TextSize = 13
	themeLabel.TextXAlignment = Enum.TextXAlignment.Left
	themeLabel.Parent = settingsScroll
	
	local themeContainer = Instance.new("Frame")
	themeContainer.Size = UDim2.new(1, 0, 0, 30)
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
			settingsPanel:Destroy()
			settingsPanel = nil
			settingsOpen = false
			createSettingsPanel()
		end)
	end
	
	-- Scale slider
	local scaleLabel = Instance.new("TextLabel")
	scaleLabel.Size = UDim2.new(1, 0, 0, 24)
	scaleLabel.BackgroundTransparency = 1
	scaleLabel.Text = "Scale: " .. string.format("%.1f", UISettings.Scale)
	scaleLabel.TextColor3 = Themes[UISettings.ColorTheme].Text
	scaleLabel.Font = Enum.Font.GothamBold
	scaleLabel.TextSize = 13
	scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
	scaleLabel.Parent = settingsScroll
	
	local scaleSlider = Instance.new("Frame")
	scaleSlider.Size = UDim2.new(1, 0, 0, 20)
	scaleSlider.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
	scaleSlider.Parent = settingsScroll
	
	local scaleCorner = Instance.new("UICorner")
	scaleCorner.CornerRadius = UDim.new(0, 4)
	scaleCorner.Parent = scaleSlider
	
	local scaleFill = Instance.new("Frame")
	scaleFill.Size = UDim2.new(UISettings.Scale, 0, 1, 0)
	scaleFill.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
	scaleFill.BorderSizePixel = 0
	scaleFill.Parent = scaleSlider
	
	local scaleCorner2 = Instance.new("UICorner")
	scaleCorner2.CornerRadius = UDim.new(0, 4)
	scaleCorner2.Parent = scaleFill
	
	-- Opacity slider
	local opacityLabel = Instance.new("TextLabel")
	opacityLabel.Size = UDim2.new(1, 0, 0, 24)
	opacityLabel.BackgroundTransparency = 1
	opacityLabel.Text = "Opacity: " .. string.format("%.0f", UISettings.Opacity * 100) .. "%"
	opacityLabel.TextColor3 = Themes[UISettings.ColorTheme].Text
	opacityLabel.Font = Enum.Font.GothamBold
	opacityLabel.TextSize = 13
	opacityLabel.TextXAlignment = Enum.TextXAlignment.Left
	opacityLabel.Parent = settingsScroll
	
	local opacitySlider = Instance.new("Frame")
	opacitySlider.Size = UDim2.new(1, 0, 0, 20)
	opacitySlider.BackgroundColor3 = Themes[UISettings.ColorTheme].BackgroundAlt
	opacitySlider.Parent = settingsScroll
	
	local opacityCorner = Instance.new("UICorner")
	opacityCorner.CornerRadius = UDim.new(0, 4)
	opacityCorner.Parent = opacitySlider
	
	local opacityFill = Instance.new("Frame")
	opacityFill.Size = UDim2.new(UISettings.Opacity, 0, 1, 0)
	opacityFill.BackgroundColor3 = Themes[UISettings.ColorTheme].Primary
	opacityFill.BorderSizePixel = 0
	opacityFill.Parent = opacitySlider
	
	local opacityCorner2 = Instance.new("UICorner")
	opacityCorner2.CornerRadius = UDim.new(0, 4)
	opacityCorner2.Parent = opacityFill
	
	-- Toggle buttons
	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Size = UDim2.new(1, 0, 0, 24)
	toggleLabel.BackgroundTransparency = 1
	toggleLabel.Text = "UI Elements:"
	toggleLabel.TextColor3 = Themes[UISettings.ColorTheme].Text
	toggleLabel.Font = Enum.Font.GothamBold
	toggleLabel.TextSize = 13
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleLabel.Parent = settingsScroll
	
	local toggleContainer = Instance.new("Frame")
	toggleContainer.Size = UDim2.new(1, 0, 0, 30)
	toggleContainer.BackgroundTransparency = 1
	toggleContainer.Parent = settingsScroll
	
	local toggles = {
		{name = "Status Bar", key = "ShowStatusBar"},
		{name = "Tabs", key = "ShowTabs"},
	}
	
	for i, toggle in ipairs(toggles) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.48, 0, 1, -4)
		btn.Position = UDim2.new(i == 1 and 0 or 0.52, 0, 0, 2)
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
			settingsPanel:Destroy()
			settingsPanel = nil
			settingsOpen = false
			createSettingsPanel()
		end)
	end
	
	settingsClose.MouseButton1Click:Connect(function()
		settingsPanel:Destroy()
		settingsPanel = nil
		settingsOpen = false
	end)
	
	settingsOpen = true
end

-- =============================================================================
-- 12. THEME APPLICATION
-- =============================================================================
local function applyTheme()
	local theme = Themes[UISettings.ColorTheme]
	
	-- Apply theme to main frame
	mainFrame.BackgroundColor3 = theme.Background
	mainFrame.Size = UDim2.new(0, UISettings.Size.Width * UISettings.Scale, 0, UISettings.Size.Height * UISettings.Scale)
	mainFrame.Position = UDim2.new(UISettings.Position.X, -UISettings.Size.Width * UISettings.Scale / 2, UISettings.Position.Y, -UISettings.Size.Height * UISettings.Scale / 2)
	mainFrame.BackgroundTransparency = 1 - UISettings.Opacity
	
	-- Title bar
	titleBar.BackgroundColor3 = theme.BackgroundAlt
	titleIcon.TextColor3 = theme.Primary
	titleText.TextColor3 = theme.TextBright
	
	-- Status bar
	statusBar.BackgroundColor3 = theme.BackgroundAlt
	statusBar.Visible = UISettings.ShowStatusBar
	statusText.TextColor3 = theme.Text
	
	-- Tab container
	tabContainer.Visible = UISettings.ShowTabs
	tabContainer.BackgroundColor3 = theme.BackgroundAlt
	
	-- Update all child elements recursively
	local function updateChildren(parent)
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("TextLabel") then
				-- Keep special colors
			elseif child:IsA("TextButton") then
				if child ~= closeButton and child ~= minimizeBtn and child ~= settingsBtn then
					-- Keep button colors as they are set individually
				end
			elseif child:IsA("Frame") then
				if child ~= mainFrame and child ~= titleBar and child ~= statusBar and child ~= tabContainer then
					if child.BackgroundColor3 ~= Color3.fromRGB(0, 0, 0) and child.BackgroundTransparency < 0.5 then
						child.BackgroundColor3 = theme.BackgroundAlt
					end
				end
				updateChildren(child)
			end
		end
	end
	
	updateChildren(mainFrame)
	
	-- Update open button
	openButton.BackgroundColor3 = theme.BackgroundAlt
	openButton.TextColor3 = theme.TextBright
end

-- =============================================================================
-- 13. SCAN FUNCTIONS
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
	
	local basicProps = {"Name", "ClassName", "ToolTip", "Enabled", "CanBeDropped", "RequiresHandle"}
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
-- 14. TAB SWITCHING
-- =============================================================================
local function switchTab(tab)
	toolContent.Visible = (tab == "tool")
	playerContent.Visible = (tab == "player")
	attrContent.Visible = (tab == "attributes")
	
	local tabs = {toolTab, playerTab, attrTab}
	local activeTab = {tool = 1, player = 2, attributes = 3}
	
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
end

toolTab.MouseButton1Click:Connect(function() switchTab("tool") end)
playerTab.MouseButton1Click:Connect(function() switchTab("player") end)
attrTab.MouseButton1Click:Connect(function() switchTab("attributes") end)

-- =============================================================================
-- 15. BUTTON ACTIONS
-- =============================================================================
toolRefreshBtn.MouseButton1Click:Connect(scanTool)
playerRefreshBtn.MouseButton1Click:Connect(scanPlayer)
attrRefreshBtn.MouseButton1Click:Connect(scanAllAttributes)

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
-- 16. SETTINGS BUTTON
-- =============================================================================
settingsBtn.MouseButton1Click:Connect(function()
	if settingsOpen then
		if settingsPanel then
			settingsPanel:Destroy()
			settingsPanel = nil
		end
		settingsOpen = false
	else
		createSettingsPanel()
	end
end)

-- =============================================================================
-- 17. TOGGLE SYSTEM
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
-- 18. AUTO-REFRESH
-- =============================================================================
local function onCharacterAdded()
	task.wait(1)
	if toolContent.Visible then scanTool() end
	if playerContent.Visible then scanPlayer() end
	if attrContent.Visible then scanAllAttributes() end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- =============================================================================
-- 19. INITIALIZATION
-- =============================================================================
applyTheme()
switchTab("tool")
setStatus("🚀 Loaded! Click ⚙ to customize UI", Themes[UISettings.ColorTheme].Success)

print("⚡ Advanced Modifier Suite v3.0 loaded!")
print("📌 Features:")
print("  • Click any value to edit")
print("  • Press [M] or [Right Shift] to toggle")
print("  • Click ⚙ to customize UI (theme, scale, opacity)")
print("  • Add/delete attributes on the fly")
